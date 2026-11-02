Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DC45760A383C
	for <linux-mm@archiver.kernel.org>; Mon,  2 Nov 2026 10:19:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=gpdNj83U
Received: by kanga.kvack.org (Postfix)
	id DAD0B6B05BD; Mon,  2 Nov 2026 05:18:56 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D5E5F6B05BE; Mon,  2 Nov 2026 05:18:56 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C4CD26B05BF; Mon,  2 Nov 2026 05:18:56 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A14C26B05BD
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 05:18:56 -0500 (EST)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id A24341C4187
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 10:18:55 +0000 (UTC)
X-FDA: 85389780630.29.5D0C465
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf26.hostedemail.com (Postfix) with ESMTP id F1435140007
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 10:18:53 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=gpdNj83U;
	spf=pass (imf26.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793614734;
	b=Kx8v1PHu7AlJr5G0ep7sOvgVSHVqKuGLCUXjFwMkphK8f3UMXCCtOl8hQjrUiV+z+vFkhD
	sKPhsPzLDYRbRmgVohPoGX6oqGSgf9mZybtG7wyd/n909amTf4Q/owoYMQySRiLwO7HBOb
	A5221gL2D36+KExwxohVenxz3zk0Nwc=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=gpdNj83U;
	spf=pass (imf26.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793614734;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cslvm6SXg+YQnopv/KqOEZKzVolYz1TO5/sQmHGDWzQ=;
	b=xmSzjmEN9nojBWRgoKxKz5RRROQUc3IaNAdQ4iyiho1qEbN9idfNZ2aGjGCimVPQfEHe+c
	wuMEeHi5/Rprv7ezbxd9pYWTzQa//qjvpRWat373rrtr+unn0JVM+C0O5U7Z0ZZNQCTx7h
	xUS37tqsN25HaJBhCvxQF++4oFw6cgM=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 41E6F43F52;
	Mon,  2 Nov 2026 10:18:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A20E51F00A18;
	Mon,  2 Nov 2026 10:18:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793614733;
	bh=cslvm6SXg+YQnopv/KqOEZKzVolYz1TO5/sQmHGDWzQ=;
	h=Subject:From:To:Cc:In-Reply-To:References:Date;
	b=gpdNj83UGE1Ukt50sUEwNY/N9tpD+iMDA2q0OJQtfZkapjZwoj+TwwGtKX5P0wzUv
	 0NkAbkmlZNeBgJqm30+NjkgU6y7WtrfJnUQ6NZ5r5sFneXOc/rBMU+syLr35LG/FSf
	 Ean0dHuO41RzzBRhfJwhD4eAiVnpBVDId72mecCUlE8FXGdIj0ywXErcOJbbRedmxj
	 GR4OPqfcxlyrWe6ZFBs7h33ec/ZLih7zwFWXRzC/6jtkwWYqAFXwgX7hDhqjxVIAOi
	 QBzcz3W3FAWeFsQYZFBfUDVjQv9LWZmYd2j0wT8RuxJuX29xwL/tQM+XU1vS4qFrge
	 zSpq0N8G2ULkg==
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v2 06/12] mm: hugetlb_vmemmap: rename
 vmemmap_remap_pte() to vmemmap_optimize_pte()
From: Mike Rapoport <rppt@kernel.org>
To: Muchun Song <songmuchun@bytedance.com>
Cc: Oscar Salvador <osalvador@suse.de>, 
 Andrew Morton <akpm@linux-foundation.org>, Mike Rapoport <rppt@kernel.org>, 
 Qi Zheng <qi.zheng@linux.dev>, Lance Yang <lance.yang@linux.dev>, 
 James Houghton <jthoughton@google.com>, 
 David Hildenbrand <david@kernel.org>, Muchun Song <muchun.song@linux.dev>, 
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
In-Reply-To: <20261102032525.3597743-7-songmuchun@bytedance.com>
References: <20261102032525.3597743-1-songmuchun@bytedance.com>
 <20261102032525.3597743-7-songmuchun@bytedance.com>
Date: Mon, 02 Nov 2026 12:18:31 +0200
Message-Id: <179361471104.1337633.1040318147717529848.b4-review@b4>
X-Mailer: b4 0.16.1-dev
X-Rspam-User: 
X-Rspamd-Queue-Id: F1435140007
X-Stat-Signature: iugmydu9wors8ch3p59hccy4x4gk4teb
X-Rspamd-Server: rspam01
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793614733-965977
X-HE-Meta: U2FsdGVkX19zSHLXXHxC0ukhffh2u+8Att/0rewFOdIIYahEQfy/8UEm9S3sR+GtoZFL2JoLG7ALYyaFvkjFzQ/uL25g8ukHK/WuZ7nQp1B7CDrmcXEeCXRSZJcz484wdRHgmvu3B+5dLLFVizJa0VUcunlLTUDuR+D1cCzwRTOSX3NOPzSFMA7hAr2jbJDboe0nGiEyiNNycsfAvzIEX9AEmwzuRgmg3sxeo92f6VkYWGLbZNTC53D1nP+y+AY4Yd8SxoEMdcdYCJ0BxFjXhAcdwF+PUcoEO0ASqs1+eEsmYu5i5OPZVJSoLg32e/9Vajmd9Vy6bBCpRlW+EryivQoLxHGPTKxXT3osoFTL7TextuH3m6GXdbaXl0adjsS/xhSRV2h/Tryw2z1Mpd2q9/pxoqC7Y6W5DiKcBqnzEhUjSBSn9+HVd4SMMi+rn0bzBuXkkI21thyzjpcxEN0+yxeaKLsW5xCArwmnMYti2lmpYeLsPKbbSOKeLvlL0ZhJKD/J1eRXXZX9nWFPi2HVzKSLcxMNyyy7Stb2Qn9JoNiETScAF1H75atRvjM4UxYhd/WC5tiA17cCPXqYAPvHo+4BQrJ9V0YxX0emYTR0JRxtEn9Qs/uHyJjZqfSetwjb1zNjaO4rVjWJgdh1MbPGYVMKSMwpMQrkUhzdAwwlc3ReN46Z9ujYrEV46IYeQ9AK6Gsfpmy3sRoyuGiidOLrijm3Fx0GMdZgnW/gI7309Xh37MWoCgw4QxymoykAQRlbG6SCVJwgVRb6/LaObtU7nq4Ig6xZf2QxZk+Nr26yOf/eQT8R5gRJKUnz4vGE/iFVBlXBDflKanyuBZHXQtASkZzGIoau7GXSWGCTZeRqWveCg6HCiOkGHRtXnKLOEr2EYNndSwuv9NMFOTu58655OL/557J/9lf5o2aMGaRx47hIj9ZyHxdcqjQqdQlOZgm+Ch7pX8c8d5VScpwyiR6
 otBxmxKX
 DUG1JdBB5OQraNEuvKSFf+5lWfHqFUCcvkkHI0Qa1TayO/oRQlzv71yQ0/+FTfZiyg5HNe2OzJ34wLEFIZZ73Y5wx1cuOrMfPIF60Yi//oaDegMiPyqx+O90tkAprPOqSwsq2N+prGUU8UzCtBqr8i1aA4LLXGjtKScE+wZN7cVR+r11BTI8XMRyOHtLI5UXGtAXKh/k5m2Ama8HxMjt3HFqxlijJEv2YQ8tQiN+fxtf1e4PBiKd6EPonuAYwfLAARYygwlca+9eEoQ/BivdKqPHAwqHC4AsXyTTFlZU7Dgpx+lqvytky6HBTpg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, 02 Nov 2026 11:25:19 +0800, Muchun Song <songmuchun@bytedance.com> wrote:
> Both optimization and restoration update vmemmap PTEs by remapping them,
> so "remap" does not identify the callback's role.  Use "optimize" for the
> optimization callback to match "restore" and make the two directions
> explicit and consistent.
> 
> No functional change intended.
> 
> [...]

Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

-- 
Sincerely yours,
Mike.



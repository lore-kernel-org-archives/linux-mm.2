Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B3874606A320
	for <linux-mm@archiver.kernel.org>; Thu, 19 Nov 2026 07:06:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=OAjUxK8X
Received: by kanga.kvack.org (Postfix)
	id B82386B05B1; Thu, 19 Nov 2026 02:06:40 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B334C6B05B2; Thu, 19 Nov 2026 02:06:40 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A4A156B05B3; Thu, 19 Nov 2026 02:06:40 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 79C476B05B1
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 02:06:40 -0500 (EST)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 0095040951
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 07:06:39 +0000 (UTC)
X-FDA: 85450985760.11.E0CF099
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf23.hostedemail.com (Postfix) with ESMTP id 2EC0E14000E
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 07:06:38 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=OAjUxK8X;
	spf=pass (imf23.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795071998;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=roEfV9nY1STcRzCu+/cxIrjvr9SwHPE6ZUbDalowc6w=;
	b=7SoT6G8wk9fREOFjECkKxqRkce5YEjsbljWV7g38y6jofNn+8j+yBM3NL+6XBQgK6+7Ylx
	SM5JvBfMwh+stKQ5cRzxYyX0S0f9oENELTcVw+Jd265oHdnsfkezhz70Ry1tAdEgsXd2Hr
	GSapiJlsRkpsw513HtHce8Q4GU1nEes=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795071998;
	b=enkx98T9Pmfnd5yNGu7yV7q14HWQUjYrQ7tHPBEv+0aMuGN1F/Murt414Eq9ZfXobGovhr
	Y0BpdR7Rj9V8X86sPO+NZpTxg0ozn6YVWRTiqXkqpguuh/6SnCpn9BaS8b/NnNgNMoD0uh
	tNTTs5jBjgJgMGNK8WcmNRcKqA6To14=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=OAjUxK8X;
	spf=pass (imf23.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 8D20D61FB0;
	Thu, 19 Nov 2026 07:06:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BEDBE1F000C4;
	Thu, 19 Nov 2026 07:06:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1795071997;
	bh=roEfV9nY1STcRzCu+/cxIrjvr9SwHPE6ZUbDalowc6w=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=OAjUxK8X+5SbFM85ImCRyQabs+kyB4NucK13vPznRyvkhsQEJ0+Ll4GgCm+vVJ/Sz
	 kllNKyZVh6573ApXTytCRJRAlFzfWBvb0iELX0gwmeIZVhxEkztv9BLsqji6dfeca3
	 195WOF7oM0Tmi+zYi9lOloiQvTuLb/jqRoagQEwc=
Date: Wed, 18 Nov 2026 23:06:36 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Mani Tofigh <mt4022@columbia.edu>
Cc: Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>,
 David Hildenbrand <david@kernel.org>, Miaohe Lin <linmiaohe@huawei.com>,
 Naoya Horiguchi <nao.horiguchi@gmail.com>, Matthew Wilcox
 <willy@infradead.org>, Jane Chu <jane.chu@oracle.com>, Zi Yan
 <ziy@nvidia.com>, Kaitao Cheng <kaitao.cheng@linux.dev>, Mike Rapoport
 <rppt@kernel.org>, Mike Kravetz <mike.kravetz@oracle.com>, Yu Zhao
 <yuzhao@google.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 tz2294@columbia.edu, stable@vger.kernel.org
Subject: Re: [PATCH v2 0/2] mm/hugetlb: clear the hugetlb flag before
 leaking a hwpoisoned folio
Message-Id: <20261118230636.493784ad9653075ab69f2252@linux-foundation.org>
In-Reply-To: <20261103-hugetlb-hwpoison-leak-v2-0-98085750c145@columbia.edu>
References: <20261103-hugetlb-hwpoison-leak-v2-0-98085750c145@columbia.edu>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: ayf5y7qomicpjinxq4iw73napxc1593f
X-Rspam-User: 
X-Rspamd-Queue-Id: 2EC0E14000E
X-Spam-Status: No, score=-7.5 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam03
X-HE-Tag: 1795071998-297370
X-HE-Meta: U2FsdGVkX1+i12N3+j1M2ZIhWcXPx8FysMB5iFeNN650c7PVKPgcogXnD7fF28zLnbB/ecs3A+vaS2OOGiwMJwJ+M7YqSDjK7AIKiBP7umfB2glBljyhXvhMovVUJvdfY/iomuDFYfHougx0dbjY772CI7jEsdUJjVRBWDxGir0HeVtYRRx5aM2sih7TfOW6Ybx4bvYCusfPuQxDR9X33rrcXyU2l386wbckdOHMpWzboG9y+x2zkeWj36fa4o9Gr59kiJYQg29wnT/Mb0vcNFGGnAr4FzmOKYiSCoUIAdIiGjTh365LOM/10CcJWXPtGk8OD49lxMtKJzMyYuiL1wPxhXGPfxBmYkvBIK5WiO9p5F/SSYD2h/nLZhsm+B2yiextCWNL/3TdzCEVILhd9JjrA8is4z3692Bp3vpHm22KLynvdFHD0tSlgWtj7LfuZ5b8BqwtYpwp76h3sxFC6XcF0juWl2l015BX5TKGQ62167gZt8wQz9u8If5zioh2sYOQJGhCfkkhFMYwXTACw2XN/jWA12tsF9MEbi+Y2yfPOUydAxh/tDIzgXlPwdAcSOIiBcWrQjXQ3noVl0wRsgDPRIT3cScAM4cRUFaPMyR6Wkv7QS5itKh66xMsywnsuAbw/Glj8Mn92bNd12q0A+OY8CoRalaHWKjQ8rk48AlD8K1HmDPQ7WSmEJY7hpfOvSqGYyaOqMMgIoKboQSS9eRUc1Wr3qno4Ju+xcyT0IRYj6sr5VeIRbSAd7OydAPAqJCX+hMtTNi0UgMzVtNL0AyVZmbEVT4+hV4SxS6/Fa3JBWAG7baoeI1t40QNSw7HSotOLq6EPfFXT29TTFvObDQ/R5ben8f4lYfChnybSc5sMjHoSDHBNyQdZozjnWEUN2rLLely+9aFznm1uDwlPANySAfubPfhN2S2ENvV1OjlNddAE/zU8e4ap7f5j7SGOGyaqxl1FAw0GNy6Uht
 W1tgX6CP
 yjSNEVlOHOh64DyQxnDjK5h+MY3z5EMhFDwINafVZ6JfrSsmnHeOxg3IedZs3ggxI1EmEC/pDZP8hckX4p3k4xBoRwlExYJ5mv17DeTU3cLZoUuJBWxW7hmNlTm/sOkOM01jbL8TBNxXvZtZqMY3V4bz13H8ulAbbOuVvOST3lQ0WnIdde3UOEDzvwLXhDw0iz2j0+xqmYQxiX9/z3M9rowtaWXqrmZgeCxzNEJ3iT6ojoWUbEJs08xVYIdqDmyPa/CaHXafqBJ453oDwHl0uCq/l0ZIPaRWA30J119bpZzqUxyLpahNy/kNI0T58uWCuK4F6+uNhc33nfOE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, 03 Nov 2026 16:00:48 -0500 Mani Tofigh <mt4022@columbia.edu> wrote:

> If memory_failure() can't save the raw error page of a hugetlb folio,
> the folio is marked raw_hwp_unreliable and leaked once it's freed.  With
> hugetlb_free_vmemmap=on it's leaked while it's still a hugetlb folio,
> and dissolving it then loops forever, e.g., when offlining its memory
> block.  Patch 2 leaks it only after the hugetlb flag is cleared, as
> without vmemmap optimization.
> 
> Miaohe pointed out that unpoison_memory() then doesn't see a hugetlb
> folio anymore and unpoisons it.  That already happens without vmemmap
> optimization, so patch 1 fixes it on its own and goes first.
> 
> Patch 2 lets a raw_hwp_unreliable folio reach the add_hugetlb_folio()
> rollback when restoring its vmemmap fails, as
> dissolve_free_hugetlb_folio() already does.  It relies on Kaitao's
> "mm/hugetlb: preserve persistent flags when returning folios to the
> pool" [1] (in mm-new) to keep the flag there.

Problem.  [1] doesn't have cc:stable whereas your patches do.  So we're
sending -stable people something which won't work.

I don't know if there's a way of expressing such a dependency for the
-stable machinery but fortunately [1] is still in development mode (ie,
in mm-unstable), so I can add a cc:stable to that along with an
explanatory note.

And I agree that these two patches are -stable material, especially
[2/2].  Having an offlining attempt lock up until reboot is not our
preferred user experience ;)



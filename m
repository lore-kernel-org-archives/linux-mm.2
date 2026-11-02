Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7AABF60A5BDA
	for <linux-mm@archiver.kernel.org>; Mon,  2 Nov 2026 10:19:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=OMbzK99u
Received: by kanga.kvack.org (Postfix)
	id 19ED36B05BE; Mon,  2 Nov 2026 05:18:59 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 102006B05BF; Mon,  2 Nov 2026 05:18:59 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F0B886B05C0; Mon,  2 Nov 2026 05:18:58 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id CE6976B05BE
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 05:18:58 -0500 (EST)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 6DCEE1A0C69
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 10:18:58 +0000 (UTC)
X-FDA: 85389780756.08.9FAD32B
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf01.hostedemail.com (Postfix) with ESMTP id C727340008
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 10:18:56 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=OMbzK99u;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793614736;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7NDwhp7QJiOHTlc8/aRvhSK4SA3VmvKNMth+l08RDl0=;
	b=1XDlxU+To8bdipvsK458RZ+6S6qzHErIxQi1tuFgBgG6K2GjfOMNfzCDHM/Jjv+b+rzxdL
	wU84lEeVWzMyChHqr0yCztfw8ou/svhd4qH9SJsgaj0KkvYq/Dx/QUtedRHRYej+YQYGed
	t5vRk6kHtKDLqcV1kYTA55eBUn9i/54=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=OMbzK99u;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793614736;
	b=PX/B2D1q5dzKOiNCsyLuKyyQpFRZMSyC5Ojb5xqWjcAmQOvcVHqHoVWEKB4Js0Uj5dPnkt
	xIqzdhMAAN6SctBQI61Oo5Pj1OK7luwgDAQXf+C2rbLtdc1knLRHFhBgLv5j2WbV27oJlz
	/MqbX4yvWuDenMEdAngoKi3teiNfg0w=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 6FB2C60F40;
	Mon,  2 Nov 2026 10:18:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A36091F00A02;
	Mon,  2 Nov 2026 10:18:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793614736;
	bh=7NDwhp7QJiOHTlc8/aRvhSK4SA3VmvKNMth+l08RDl0=;
	h=Subject:From:To:Cc:In-Reply-To:References:Date;
	b=OMbzK99u+uG/LJfEEGDqe+8KJ6mR6VDDU7f89GuKcmdSVZ6WVd+fj3Y4ho+NjlP4e
	 ZxPo1++VhQrM3ej1YhX7ZWc1rrtU54MHZVQs+X6O4MbF9hSrQeTha2Fk7Ua1iqZEsn
	 eqv//R2HW7rB9RGTxRnLCZi9ZKw1ZWxAhHkQhCpVgE8VlywTEP5acPGZLDexdgnmyg
	 uSBGSBnBxzUBM28UJu2oeT2Lu7i5rKOZRAKREOuzrEDXPNMumrEQUgZslNGLDr1ChC
	 aBDAGM2NHD2Ix0wUpthu+3WpX+oZM7Fig/e/XXzcJ9jLui7JOwRvlv16FF6X5lGq1q
	 /DmgEcWkCrrTQ==
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v2 07/12] mm: hugetlb_vmemmap: simplify shared tail
 page handling
From: Mike Rapoport <rppt@kernel.org>
To: Muchun Song <songmuchun@bytedance.com>
Cc: Oscar Salvador <osalvador@suse.de>, 
 Andrew Morton <akpm@linux-foundation.org>, Mike Rapoport <rppt@kernel.org>, 
 Qi Zheng <qi.zheng@linux.dev>, Lance Yang <lance.yang@linux.dev>, 
 James Houghton <jthoughton@google.com>, 
 David Hildenbrand <david@kernel.org>, Muchun Song <muchun.song@linux.dev>, 
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
In-Reply-To: <20261102032525.3597743-8-songmuchun@bytedance.com>
References: <20261102032525.3597743-1-songmuchun@bytedance.com>
 <20261102032525.3597743-8-songmuchun@bytedance.com>
Date: Mon, 02 Nov 2026 12:18:31 +0200
Message-Id: <179361471104.1337633.2887300135309297128.b4-review@b4>
X-Mailer: b4 0.16.1-dev
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: C727340008
X-Stat-Signature: gxrgpnkbzy5p75f5p7xgrmb7dmnaqybq
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793614736-152014
X-HE-Meta: U2FsdGVkX18xxq0Eq1UVCk6Kcup4fOR1spKUByWXqdBsSI2DTbNJMsZJ9ShBhYdRR/bHS7qMlk9dZHkxx27dqQEec6B+IMLYb+XV7fA6DY2WFds44t3iAAH7nevqL8wqe+8cemjdNbO/Uprm17dXfWhHIPMpqw7i+xCJlnZ9Pm13HUU59WY1HdPKTDRhMPAu8PBEx9hgLdQSPFa3YwI1iwOB5uDyXDSCuh2vPTZmHYTcT9+fUTcmtQFrsNatySOHiofg83LsU4x1No0s62PuCYrqK6gjnsPDBuNILQyAv1mIX1IhilZdFdueNZdQmNHQ6ORce+d3ajKqb00DfcsbGxG2Vrr6NNqiMU4wg1DxOEh+kpY4z7g7vw6h04N1KQ33WJCB3jPJV3omVj5JleCHgOEpSvowpLapyNcF1buzpna23/XImfjlf0KHYOevbWgcW0Dfz+IFX07O1I655tEDWkZCEHsJHhcA2JL8GTw3WwwJQ2xRaZ3/96tCNfRYZb9dDHp9AG4P5nBsjnNcWauA7Ydycf5+iApteqivjr+WvsQcHn+vP7YVMiFsX/K69Tw5012jxuxATPE9XPJP2ZcQBuiGRxJXL0ax/fSk89y1KRF+00YyzfS6bbemddPnJl5pt+wrCv+QE8hmlgnVSPqif0/j70YcIG9Mwoxmj9AtaPmhJYZW+QlHtefMb7ty2TFvxxlY4o5mH+jm9num3kvMbDQIS8i4Z9dTtywyx33uyw8UlpVQy1HyQJXaKq/5lO1wRoZD3LFSsyWMqYb58MsPmZlxt2Twoq554VIcwZ5yJBp4n0OaNHMIV1wFmuOO+Y11DKnLYM9Iqwp2ubmbVsu4s8SQdgdI3+M+b1vJDgdFIp0eG6eVOI/9OuCTWMroT9CewOx9FpiZ/fsr7v59IXMkA/MyfscijjYWS2FJd/URMOyBYogaOrHHSWjquNlhZRXMGHYKbGQSUkyx0hDxf4d
 D+2lDfbm
 teFrJG4le0E+gluAwOkQzHnlU69y1QuC2d4RQ02ivP2mczyCMKy30WsICuGB3M3K9/fwXvy9LuQz3CjMmsICjEIaWAUteMJTx3GGy5eyNyumwZvNg6Q6fjUdM3xg1CBC/N8P/p+r55oDC9DMwxmCei9QlIoqcXNyAv9x3FvYHW4nETziDdSa1l874Pccka7Nwvkbq3wG33w8J+njycHLIzTo2SrTrL0wHZMl55nEn7JsGFl6eu/2quASjXmPYXNbTvC+RvuzdqV9Vhau/qo9jDJm0I5E2F4qzd1eo+4KOS0FyvYO6is0ZtuHuXQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

> The remap walker currently carries a shared tail page selected by its
> caller, even though the optimize and restore callbacks can derive the
> same information from the folio being processed.  This adds redundant
> state to the walker and couples its interface to caller-side preparation.
> 
> Derive the shared mapping state in the callbacks instead, keeping the
> mapping policy with the PTE being processed and simplifying the remap
> interface.
> 
> No functional change intended.
> 
> Signed-off-by: Muchun Song <songmuchun@bytedance.com>
> Reviewed-by: Lance Yang <lance.yang@linux.dev>
> Reviewed-by: Qi Zheng <qi.zheng@linux.dev>

Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

-- 
Sincerely yours,
Mike.



Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E173BF5544A
	for <linux-mm@archiver.kernel.org>; Wed, 25 Feb 2026 02:54:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4D5756B0005; Tue, 24 Feb 2026 21:54:47 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 483686B0088; Tue, 24 Feb 2026 21:54:47 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 33ABB6B008A; Tue, 24 Feb 2026 21:54:47 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 20BAE6B0005
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 21:54:47 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 43410C1CA6
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 02:54:46 +0000 (UTC)
X-FDA: 84481461372.24.6FF0838
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf24.hostedemail.com (Postfix) with ESMTP id 83EEE180002
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 02:54:44 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=dVnbsjQH;
	spf=pass (imf24.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771988084;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wfg2uCz2SJHFjhKIQdLenL/QZAPuj/hAiKw300EGI1k=;
	b=Sy3TNGSFXMy5kKYAPosAlvgNQsZ3hmvJNesW5Sr+M5vMR3GymRMRBVGAUBPRf0jTHApPk7
	A3Lqb3OCY6mJB+hJMmCYbjnwZKxyTSclpBjtpdHKAG6pbzYqMZM1DEK42/SrS2P0q7mc6N
	+KWjwh3+y7trMw8h26uKOMQDxydQenI=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=dVnbsjQH;
	spf=pass (imf24.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771988084; a=rsa-sha256;
	cv=none;
	b=QozTc8bfxHXJdkc6eIbYL5/BeGF4n72XOxDAOTm0nnd9rv5wwr5Yihnd01ExM3/2mtn+85
	aJRYJu898uMl9bZAKzw/Q4w89R3WLhLqMecdyvgzmmY2lXPPLq4FGAcsaLNu75ehdzCmCT
	E1c6voM162b2XWiJbB3tPOwu9JZsI+0=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 42B9F4442A;
	Wed, 25 Feb 2026 02:54:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6E1AC116D0;
	Wed, 25 Feb 2026 02:54:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771988083;
	bh=sv0BlK/PbJISeFWRNtuvB50+SpWmS9eaRA5oaLiZUfc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dVnbsjQHy6FVcw4vQWo0DIfbZItECN3MHkQSIx6PKyGIuREBKGeAG24vZXXFE+Tzm
	 vS7MULKaeu2m3PB2WKqeHPeJ4qtgG6fBbvMQkH2qVJm4yqyx3aEbk80si3oTB0OEZT
	 +NFEq7/yAhuCVLfZW25e02xHd1yDcJwqU9a57k5dgug6N9ZnEGkKCoEY4OZK0rYfHF
	 1ywjE9nroeVLAPRNWHFd+aN7Qb1fhH9car1NpKJyb6HYDtAZol04esfFTiUD3/u3Dt
	 7N16SWqLMkcvf2038aR6t1bYoRJQTq/IQ31guy7C8HgdMZG1YelCtg6cODMYKeMlEt
	 bH4cclVgLGB+g==
From: SeongJae Park <sj@kernel.org>
To: Zi Yan <ziy@nvidia.com>
Cc: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Kefeng Wang <wangkefeng.wang@huawei.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Ron Economos <re@w6rz.net>
Subject: Re: [PATCH v2] mm/cma: move put_page_testzero() out of VM_WARN_ON in cma_release()
Date: Tue, 24 Feb 2026 18:54:40 -0800
Message-ID: <20260225025440.63897-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260225022853.2347732-1-ziy@nvidia.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: a8hfn67znd6yptrurpoh6f66q1wxnuzq
X-Rspam-User: 
X-Rspamd-Queue-Id: 83EEE180002
X-Rspamd-Server: rspam01
X-HE-Tag: 1771988084-945003
X-HE-Meta: U2FsdGVkX1/+x0jT2FuoihPhl1gcvOb6icmwF8NYKEJJ7r9cdbKkvqHinj0DhqDFkzwYYxMoZhwo4+7mcgiVd1nadsTus5Ylkwks/oL8w8ZWxF599+WMYjYqj32RFg03Cu7Y0e5CQL55OF9yuP28MfhNVDFphy1KNse/Hr3L45SOABjEtzT+VWpYEYHTn7P5/jLbgUAvSIdqSpECB3c46zYnHjrPWz7xHd/u9T1SMrFmME4Rna49h7fgoei6gJNVrxcukcoHwm4RK+KSCBsmE8ldiFiFR4bhS9NJFtNjtR09MhXnhE3PN1aWhPH86Ia4SGmQ0QZc/wFh0gYjIqb/fRCQSHFQ1Pu19BhsIsf69wgVaVOMMuoAkWcceZQ+kgfz5xKzkDUdp491rAEXFZDIpPgu8jDPppag/WnoWE5tR1q2BrP8nPfySjeyr4CgOZlAjqGnuuM+bOgTMvOqj11uFp1fBTxGImLvNzoJGzzQxChST+EPDjzy/2F/HUx0MAqLy1PQvfM8eJrqecjYwsUa5a7mHnYrI3Am0bs7HINkvnPzEurh6cYWhSOkogYq1uJ4mTSAPKJndF6HsvsAvpU8e0rgQatw7rs7m4BUfe+0b9+kugOtpNz0hHI6gjNyZYppxrjynOLULRoMUOv5w/Kd3E1tDjBCs0mAK3ovVtfJ17CSBvna19cI71QD2q/XiVHgO/x2q7ZQ8aDl+O9Qfjn0YNvK08Wtmq7omZYfEZvWIyhbPlH33mZSb9iXuqd1Gd31M3S0w7/7REFsPGsJmVWD/S8zXKlKsqWKM8TPGNyONly6Y5swEXCQYwGh6QlbS7AZ65A19m9eB5XyreHRQA2zqOM36W1jvLgveCZ/m5glEzQSZeTnDYyWRrp3e/loq9DcQ6huTMwNz83nLaiIgu4dc/Mf1aPlhAIsCw5ocTipZY3wZz9oXGUymn55Y6+t95V0dPB8myjesVXQcS6XPq1
 eJowNXYQ
 +VoPuEGtoP9EnBS3aWvbVLgCoIdY/kqWznVgKPyiL2PDR9Hm5rAAPMJAICihZUz9wk3I+LZ2ZzMg2uF1mrlTQlxp4gTS+bYBNC0kA+RhUen4LmzWFe6c4oUs74Qt5tOsp5snMorHVf0z4LPBskImn7pOkFwycvn9xkupLju1Cx0riArRkuS7D4uHKuEImOOXZnwBhPe2bHKpcJLoCnLV6hw0EQzMaGCT043NhYeBTlxhXDzN56xTt88z3R0cKYiT2N09zIZdLzqgschDym2A9aNLDJIpqqYXdt7PiourzWGJAJ+OuBKYjbMHNBxh0PDH5em1QZcheRgX+jlMDGyKFOYbIy1bPkvCs1rU5ct31cslnk4VCBOCEpbdwfSsEjPsqEKYl
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 24 Feb 2026 21:28:52 -0500 Zi Yan <ziy@nvidia.com> wrote:

> When CONFIG_DEBUG_VM is not set, VM_WARN_ON is a NOP. Putting any statement
> with side effect inside it is incorrect. Collect all put_page_testzero()
> results and check the sum using WARN instead after the loop.
> 
> Fixes: 9bda131c6093 ("mm: cma: add cma_alloc_frozen{_compound}()")
> Reported-by: Ron Economos <re@w6rz.net>
> Closes: https://lore.kernel.org/all/1b17c38f-30d3-4bb4-a7e1-e74b19ada885@w6rz.net/
> Suggested-by: Kefeng Wang <wangkefeng.wang@huawei.com>
> Signed-off-by: Zi Yan <ziy@nvidia.com>
> ---
> >From V1:
> - Collect all put_page_testzero() results and do a single WARN after the
>   loop.
> 
>  mm/cma.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/mm/cma.c b/mm/cma.c
> index 94b5da468a7d..ea540d3f473c 100644
> --- a/mm/cma.c
> +++ b/mm/cma.c
> @@ -1013,6 +1013,7 @@ bool cma_release(struct cma *cma, const struct page *pages,
>  		 unsigned long count)
>  {
>  	struct cma_memrange *cmr;
> +	unsigned long ret = 0;
>  	unsigned long i, pfn;
>  
>  	cmr = find_cma_memrange(cma, pages, count);
> @@ -1021,7 +1022,9 @@ bool cma_release(struct cma *cma, const struct page *pages,
>  
>  	pfn = page_to_pfn(pages);
>  	for (i = 0; i < count; i++, pfn++)
> -		VM_WARN_ON(!put_page_testzero(pfn_to_page(pfn)));
> +		ret += put_page_testzero(pfn_to_page(pfn));

So, 'ret' will be incremented when put_page_testzero() returns 'true', right?
Shouldn't 'ret' be inceremented only when put_page_testzero() returns 'false'?

> +
> +	WARN(ret, "%lu pages are still in use!\n", ret);

This will trigger the warning even if CONFIG_DEBUG_VM is unset.  I'm fine with
the changed behavior, but I'm curious if that is the real intention of this
revision.


Thanks,
SJ

[...]


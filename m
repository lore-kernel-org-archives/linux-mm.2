Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5ACF6CA0EE8
	for <linux-mm@archiver.kernel.org>; Wed, 17 Sep 2025 12:27:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B29668E0014; Wed, 17 Sep 2025 08:27:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AD9EF8E0001; Wed, 17 Sep 2025 08:27:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A16CC8E0014; Wed, 17 Sep 2025 08:27:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 8F7128E0001
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 08:27:37 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 0D1AA86D3D
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 12:27:37 +0000 (UTC)
X-FDA: 83898668154.08.A1380FB
Received: from out-182.mta1.migadu.com (out-182.mta1.migadu.com [95.215.58.182])
	by imf11.hostedemail.com (Postfix) with ESMTP id 2AA9A40017
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 12:27:34 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Wgryn0H3;
	spf=pass (imf11.hostedemail.com: domain of chengming.zhou@linux.dev designates 95.215.58.182 as permitted sender) smtp.mailfrom=chengming.zhou@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758112055;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9qjlcBWvXVjLJDUhAtJSvzuP30qgjG2/ZCnjDSBqbMg=;
	b=mg3GnjvN930TgbsEp6uAyvOmLYCth+Z8BV00DGXG831s+USqeYxwvUwZ+SfGbcYhEG6Pzx
	9c7Ny5eWNycH7wo6QOqjveJ7DxKQPPEgMh6GvtdSPBw7M9LxwjobRjhvMdf6QDMLA/Z6v7
	yqDL5d1B5kZV7LG4xeMMF22b7kendQY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758112055; a=rsa-sha256;
	cv=none;
	b=AcVcDOk2E0pVYfytcUHgx0Qez8QGlLxPT5n5K90mAQzdiG2JAABXKVTyqPNtYvxk8/1wsJ
	YXKl4Bm4AiZ7axHS3SyrxEwgdkPTjefpww0/ok7U4M49nDlqoq0Ot978UyAaEAm6+HXz00
	o7gr0cjItA478qvFpBDIIb2RZgMwwAk=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Wgryn0H3;
	spf=pass (imf11.hostedemail.com: domain of chengming.zhou@linux.dev designates 95.215.58.182 as permitted sender) smtp.mailfrom=chengming.zhou@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Message-ID: <bc91d995-b964-4eb7-8b4d-c11c9f00eaef@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1758112052;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=9qjlcBWvXVjLJDUhAtJSvzuP30qgjG2/ZCnjDSBqbMg=;
	b=Wgryn0H33P8UysTg54ZpjWuLjfWsAt4PmDSksu+LiEiB2saOKADDVoBwCCc+kNyuc/nEt8
	LsB1ToI91cgwN6UQmtQq/H4IxUN2RZUHfshkkq/Q7Hyr/jVnFlQNGxd3T72V153HtuaDUB
	brbJyccBio7DwPP7qAJb51BOasuNk/o=
Date: Wed, 17 Sep 2025 20:27:15 +0800
MIME-Version: 1.0
Subject: Re: [PATCH v2 1/3] mm/ksm: Fix incorrect KSM counter handling in
 mm_struct during fork
To: Donet Tom <donettom@linux.ibm.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@redhat.com>
Cc: Ritesh Harjani <ritesh.list@gmail.com>, Xu Xin <xu.xin16@zte.com.cn>,
 Wei Yang <richard.weiyang@gmail.com>,
 Aboorva Devarajan <aboorvad@linux.ibm.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org,
 Giorgi Tchankvetadze <giorgitchankvetadze1997@gmail.com>,
 stable@vger.kernel.org
References: <cover.1757946863.git.donettom@linux.ibm.com>
 <4044e7623953d9f4c240d0308cf0b2fe769ee553.1757946863.git.donettom@linux.ibm.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Chengming Zhou <chengming.zhou@linux.dev>
In-Reply-To: <4044e7623953d9f4c240d0308cf0b2fe769ee553.1757946863.git.donettom@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: 2AA9A40017
X-Stat-Signature: 8wo3d9e871ojcnmfsmfensj43n83gmck
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1758112054-618131
X-HE-Meta: U2FsdGVkX1+einRScJCbsZy3STdLXf4K/wbMV3HvNAPj9DapEHDWe+q9AV1nBVHe2jDi6ZQ5RVFxEpTM6oU+/dR9wOEOSdFqexYYQgLxXo0xueB2BsO1CzF8BrVi1nc98hvtndvDi7y7wYyMBsvAtXXeTJD7Rgvrp0Sb0pSEudJVOyv4Xed0PQZ2j/uGvMx+Vk0gEZn8g4rZljnMDRZkYG4e15f6wI8VPJv/dtiNK7M5Psjc8JNu7evM5QhBCZiqkpOnW2QxYZuA985xQGyPAPGRcKjijmVNh1icLm+nYPsBTKct045oAIGcEujrE0aSenqJEPOJ5071jtk/Fwhp0rRL+i2iuRtCYykxbmhiAwfd65YIkG+tXL1HA4z7WXbGv3vD3Qka+u9RgWJ5lxNAY8QWx1s8OPT5wCS6r/blDmMniRyjIXdffmfCfTNfqgPJQv9LQRiXKbiXB0orlZpVhHQvumQdwDT22j9ms3dvkFtSEhHZG1U0zmuZWtTXW6OdwOj0TE6RPzmDRNoSw3A4UsUIIdw3KNiIqvk0+iOwoedXtDrm0NKtuRc929YVjTdQjquQgJZpcfPcIlrgF2g2wtEeVndAb9J2y3QdfRYcjZQFXfAvwvC9AyQdHX1V4xQ5lb2c4J+LZH+cuiLbKXcVHGt9gRLxxp/hnonNjJK91qW/0tzVxLjd3AKgapjFwYhV58joSLGAzt+62ylwXvOMcj7MkPs0GkOjn1H1wSlRD5w+CX0hc58rRGWu73EO/uma2i9OmzWA+vVPgykHMwwJWKy7cykM6IXcKZqoseGOmcaWYIpdQ1XVtI3QzmsGI7M9I7POaKTSGe9IWvDo2CP/bW5YSAi0RR5O4HxXZgYMZw7+djzUJleDH5Pp3Axy/qF+Yry3+7GgDl03jehGtLaik+hVhLLFAKnI2u1ZQMzAHHEKaMeU9HhHjWDA+dPbp+gtn+9EvC17WHtsqHRaWDm
 ZhyU5o5F
 jp4MvKdyNrcqEGS1SfP//gWixxewXqFSpVzDnb94cjLt++KV2gmC+3R6zhVT+E5bOU+6ILh83KfPbxQEPnPBiN8dG5PL1Y/ZCtwRn7DFLl8pp6bybJIEektsMx3uxzoQ2akR0L0Ys9ea5WNtU2P8anR/bQHwF+Uws3ahBAC+7OtdDCfvwZkgf8z9JeGOz2SOBYbW1egJ9Sz6tHi2rzFLMfuTiNYNGKdNu0eno39ttVqpPbTsKP1BTeKe9vJk1g1J6agbmachPLNyjRjcoO9jpHsbcXP/jBrae8ir7mM7BejS6KpSek78ayZ1x+2J8KzPSH5XO2xSb6dCw42vCFC1nFid5AzlLQk7+/i//aV6Vp0+S85JA/cWhJbqr6FpGSIygVFGQkjR0tqFfrrPAPV65aDsSXQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2025/9/15 23:03, Donet Tom wrote:
> Currently, the KSM-related counters in `mm_struct`, such as
> `ksm_merging_pages`, `ksm_rmap_items`, and `ksm_zero_pages`, are
> inherited by the child process during fork. This results in inconsistent
> accounting.
> 
> When a process uses KSM, identical pages are merged and an rmap item is
> created for each merged page. The `ksm_merging_pages` and
> `ksm_rmap_items` counters are updated accordingly. However, after a
> fork, these counters are copied to the child while the corresponding
> rmap items are not. As a result, when the child later triggers an
> unmerge, there are no rmap items present in the child, so the counters
> remain stale, leading to incorrect accounting.
> 
> A similar issue exists with `ksm_zero_pages`, which maintains both a
> global counter and a per-process counter. During fork, the per-process
> counter is inherited by the child, but the global counter is not
> incremented. Since the child also references zero pages, the global
> counter should be updated as well. Otherwise, during zero-page unmerge,
> both the global and per-process counters are decremented, causing the
> global counter to become inconsistent.
> 
> To fix this, ksm_merging_pages and ksm_rmap_items are reset to 0
> during fork, and the global ksm_zero_pages counter is updated with the
> per-process ksm_zero_pages value inherited by the child. This ensures
> that KSM statistics remain accurate and reflect the activity of each
> process correctly.
> 
> Fixes: 7609385337a4 ("ksm: count ksm merging pages for each process")
> Fixes: cb4df4cae4f2 ("ksm: count allocated ksm rmap_items for each process")
> Fixes: e2942062e01d ("ksm: count all zero pages placed by KSM")
> cc: stable@vger.kernel.org # v6.6
> Signed-off-by: Donet Tom <donettom@linux.ibm.com>

Reviewed-by: Chengming Zhou <chengming.zhou@linux.dev>

Thanks.

> ---
>   include/linux/ksm.h | 8 +++++++-
>   1 file changed, 7 insertions(+), 1 deletion(-)
> 
> diff --git a/include/linux/ksm.h b/include/linux/ksm.h
> index 22e67ca7cba3..067538fc4d58 100644
> --- a/include/linux/ksm.h
> +++ b/include/linux/ksm.h
> @@ -56,8 +56,14 @@ static inline long mm_ksm_zero_pages(struct mm_struct *mm)
>   static inline void ksm_fork(struct mm_struct *mm, struct mm_struct *oldmm)
>   {
>   	/* Adding mm to ksm is best effort on fork. */
> -	if (mm_flags_test(MMF_VM_MERGEABLE, oldmm))
> +	if (mm_flags_test(MMF_VM_MERGEABLE, oldmm)) {
> +		long nr_ksm_zero_pages = atomic_long_read(&mm->ksm_zero_pages);
> +
> +		mm->ksm_merging_pages = 0;
> +		mm->ksm_rmap_items = 0;
> +		atomic_long_add(nr_ksm_zero_pages, &ksm_zero_pages);
>   		__ksm_enter(mm);
> +	}
>   }
>   
>   static inline int ksm_execve(struct mm_struct *mm)


Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C05CEC5DF74
	for <linux-mm@archiver.kernel.org>; Tue, 18 Aug 2026 14:23:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D17236B03B9; Tue, 18 Aug 2026 10:23:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CEEAB6B0452; Tue, 18 Aug 2026 10:23:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C032A6B07B4; Tue, 18 Aug 2026 10:23:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 98AA96B03B9
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 10:23:36 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 40C2A1A02CE
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 14:23:36 +0000 (UTC)
X-FDA: 85114608432.09.FF38DA7
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf01.hostedemail.com (Postfix) with ESMTP id 64AEF40009
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 14:23:34 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=j1b6Dg3a;
	spf=pass (imf01.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787063014;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=h880+CPRpSv4AV1jDBV+Jr+Z/juMTH5NojBRxANXwVA=;
	b=Xd+85mLJAkmEWaV7opXh8ILQK0OZMmpckRK0RwJ0HMNTr3VAiP16fzyuQfR4KjvCY0U2Vl
	dOT5sUY0TkXdQWE4JS13nHJkXAJ3sdntrdpHBiQ6UYrvy8lePWLXfU+YL77fPnMlyedbeY
	VZxJeJ6eEM6K4RRjsusz0tBDtRt7Yu4=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=j1b6Dg3a;
	spf=pass (imf01.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787063014;
	b=yVGzrbSkf17Hw6mGWtM1fyI/M4Sgi4K4DxUIYtm/GqSQJLOD2TGRGDH3tyt9XJVlLkZnK1
	gx+k5hqENzDw9pgmFJ+r4xcGL+zOdvnHo5eufEF3TAI2ONtBTODR6Xg6HhpomOnci/8jsE
	1vqWB1HKCOPc26A7lQ5PKvdZEZ46cIw=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 3F1AF43A00;
	Tue, 18 Aug 2026 14:23:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6DE1D1F000E9;
	Tue, 18 Aug 2026 14:23:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787063013;
	bh=h880+CPRpSv4AV1jDBV+Jr+Z/juMTH5NojBRxANXwVA=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=j1b6Dg3aZ/8bvBGwgc+wHk+4pe/7FqbVkNBUpIkinH92Sq48jGFvgW0PvZY2EKP4F
	 VPi2slutiS03hYcTkO4b7VMDL9Cy4029nQqHht5bAltYO35DZbpHQhxaYDfkdGXmyU
	 d7mp2SrQrrIBQ9zjdrlp858WDIS2AB2TdP8OLDLDYPgpkN060waU+EelgU14pAz94+
	 EEgTaG60FPSDCzubaikqveSexJSCIBQ/7a6cH1W0+TV/nKQCEokV6McdnNHbo1rqTm
	 PT2T3D2Py9wQFVCHs4iwPVWc/41mgPfCbIOTSZ38TD/AhtiAHiPRevutGTGeN3HawO
	 1vGbxP7bvcjXg==
Message-ID: <3dadebb3-7e2a-459c-a5e8-b375faf89938@kernel.org>
Date: Tue, 18 Aug 2026 16:23:29 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] hugetlb: add cond_resched() to __unmap_hugepage_range()
To: Leon Hwang <leon.hwang@linux.dev>, linux-mm@kvack.org
Cc: Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>,
 Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
 Lance Yang <lance.yang@linux.dev>
References: <20260818135029.93288-1-leon.hwang@linux.dev>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260818135029.93288-1-leon.hwang@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: fgq5hy7odcuezffwrby6cczywh31p6cf
X-Rspamd-Queue-Id: 64AEF40009
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1787063014-248006
X-HE-Meta: U2FsdGVkX19Bs/UpLH+CQh8qQiihiAK2RcEt2qW79n4Z+syIbiZU7fTdSfF+AW5KY5yT6K6f1i1a7iqr8VFggTlaEqp6iSx7Ud5ueYHSGMGvSof7f0jPyjJK21Sfpe8KGtVvMxUEB2Dt3rJJjaiFi4a4FfkbHI2TidAsDBqXWicfEQjELR+aLXAoNPHtpfkxB9uadJQI+EKDeaKDr5af1Jew/b0OLT8UJMTMhz+W8XfBPvrv34roWSQmzJM5zezTcjrxiV7HgXpumhzlVOTyNyp4UJzrogB7CucPS47GwJky4jW08o25lpOjX4/KkTjQLhBH7cETMS6NpS8Phn6LupVkBZC8Kt3EwMcFnW4EZBbD/hI+nnDYT6huRuuP3kgD2/OMsBqac8kuF2t5CNtJJu5abY94q2XXfb6ekzzHbYoEvNk6HREr7rgtk16CGJn7zqLw+1U9Aig1Zkl0HFuBKSS97oKbfhRB40Z3hElZtEPi5bFH4LW075H15Dyl6UcyNR3fyTcjJxW7Aub+uxkxwFUBhRC/16CsClMFTQeq269m6umWgEBEXrAySptWtSZbQM/haLarfqnDf9DxcDOOlcWZFYWDMwvc9Ngwa2locMX6snfnKhlHxET2Fr42lkTn4xpzMnjjF4+oHlKpQYS5WO5q5rA21xpDt+BAbrkBcHsQEJ1IoHsLCSTk65fvXfJCm6YDgxb3JUhDR7drgjApukMAm1WKUUQnroxVZhAE+IPoDrB0H0a7x9g9eKf5ANwObceDfuy12q7f1V5TQUza6Fd87AhA0WiXat6P1y3j0DKsClfGXYnYo7NqPlwxFLCVgR7Tz6/TgD+xSzBIMhyzd2vWZgKyp3bwTSyc17+SZKNmNAeMDrACMyE0Aig+LawqUGUKOfXeP04p8xOvUuEYxzKa5OdlhfXtletf1VioKKzx+5n3JzR65ooJelsCtDc6c7k7W5IXf+1RUb/cI1z
 DYohMPZU
 kWEB1n7SeJoRXgOhaA+dCfloi/yldAk+4W8jlDTMQ8QyMzPlf9fyNPbmYs2s96K/Y362Z9S9xgzw+N7IVsRooqFm5h81TsvZntPB/cA4BAVJ8MfHj7LL2wDCAdSp1hqU4iC8tENeQqStNz+ACq/8jgew6yjpr32bZoqDsINjt4ImzPiORjB83W6Q1QNqgqPLz7jdyUxzp9p3bLVLjcIVvaQ6WNUKvh7q5IM0UcENKWjoavKFV+XvkQkWa2jNwlQoTZMlNHCKXs5mqVOQFY029NXfFYcMzpuAzp2ZkYHbV7pwCfNovfdBwe9SeqLV6Kh/grqr91zre7uYIIgEug5sJF/Cbfm6DCK18mJbCFZXoiRq0iUY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/18/26 15:50, Leon Hwang wrote:
> Packet receive timeouts were traced to sparse HugeTLB unmapping in
> production. A task unmapping a sparse 2.5 TiB HugeTLB mapping could
> remain in kernel context for over 40 ms without reaching a scheduling
> point while walking empty huge PTEs. Although hard IRQs could still be
> handled, the per-CPU ksoftirqd thread and other runnable tasks could not
> run during that interval, delaying NET_RX softirq work queued to
> ksoftirqd.
> 
> Add cond_resched() at the beginning of the hugepage loop so ksoftirqd
> and other runnable tasks can run between iterations. Testing with
> PREEMPT_NONE showed that the maximum interval between scheduling points
> fell from over 40 ms to below 2.5 ms. Total time spent in
> __unmap_hugepage_range() remained about 36 ms.
> 
> Reported-by: Lance Yang <lance.yang@linux.dev>
> Tested-by: Lance Yang <lance.yang@linux.dev>
> Signed-off-by: Leon Hwang <leon.hwang@linux.dev>
> ---
>  mm/hugetlb.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/mm/hugetlb.c b/mm/hugetlb.c
> index dded1768193a..0a91aac2369f 100644
> --- a/mm/hugetlb.c
> +++ b/mm/hugetlb.c
> @@ -5233,6 +5233,8 @@ void __unmap_hugepage_range(struct mmu_gather *tlb, struct vm_area_struct *vma,
>  	last_addr_mask = hugetlb_mask_last_page(h);
>  	address = start;
>  	for (; address < end; address += sz) {
> +		cond_resched();
> +
>  		ptep = hugetlb_walk(vma, address, sz);
>  		if (!ptep) {
>  			address |= last_addr_mask;

As Michal just put it:

"PREEMPT_NONE is effectivelly dead and most cond_resched will/should be
removed. Is there any reason why you are not using full preemption when
requiring low latencies?"

https://lore.kernel.org/r/aoRnUxUlgf_kRlm8@tiehlicka

-- 
Cheers,

David


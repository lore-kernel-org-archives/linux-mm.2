Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DB8FAC53219
	for <linux-mm@archiver.kernel.org>; Tue, 28 Jul 2026 15:08:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C6C1F6B008C; Tue, 28 Jul 2026 11:08:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C43146B0098; Tue, 28 Jul 2026 11:08:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B59A26B0099; Tue, 28 Jul 2026 11:08:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 925B26B008C
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 11:08:54 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 1CB1D403BB
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 15:08:54 +0000 (UTC)
X-FDA: 85038517788.17.AAFE09B
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf09.hostedemail.com (Postfix) with ESMTP id 67E4F140011
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 15:08:52 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="DN+/cy/j";
	spf=pass (imf09.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785251332;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bbpXCpMeqFXxWGITOUTukELoIUWtZsgWtlrXo7aWqs0=;
	b=HgDGXqnMMEqOpdUZi4peb0C2llSu83r6xOvd4LIn5dl4TpKOgNSwswzLog62H3Gb+BIWxU
	9pPtGrXWKmYT7CdEw0RvPVOSlcXKzg6Ynd3GftGQ3L49VW9s8QHvGBDoZ0u+RFGrHNHTdU
	8xfPg7FuJRXbvOXaCEoLKXO0z3YLI3g=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="DN+/cy/j";
	spf=pass (imf09.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785251332;
	b=VVW+6IoBdNNkcvQWkCO/MmH76/Q8LNlNU6HE57qKHq8cZyIVs6Ws+u7XpAieOsEbdjPntX
	orq8Qfv6//QkohPyjM1LXPrdtQvM8CEDiNcheDxbQw0YwcZUVQ2JZowDzL2jK0NUk7JhZ5
	wDe7iwOE9Pf/HmNvCMt/Y4JCam3IPME=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id EDA6460A8C;
	Tue, 28 Jul 2026 15:08:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0EB871F000E9;
	Tue, 28 Jul 2026 15:08:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785251331;
	bh=bbpXCpMeqFXxWGITOUTukELoIUWtZsgWtlrXo7aWqs0=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=DN+/cy/j+nZRUxsRp+l5QlOr58qx5PORg5WApKQUfoYWiHLMKVqTmLwWWFwN3p/yX
	 IAYTySDUL9AKg0zu2y0KQTuA0LcnA0RkBu/2BVs4HxN6in+lvgNoHaeByxWA9WURPw
	 g7Kz73aVqV7rmmWODJGzc39Ym0hr4Q3awvQjaX5xAP9ACNTuyq1wLAvOyLyuRNCN3T
	 +r4FZJ1/RlpnEYo3Q131qLo4Let3HN7lphpBg3ip2aSeVqr9IZvwY2n1Uu3DF4oE0K
	 tnCFLWx92cWwsin474c95jh++5NOb+3jIYmAT7H/XEC9U5TgCLry9TPEHK9oFl7kMu
	 KDq1dcC5CqK8A==
Message-ID: <17658f3e-dca8-4e8a-b57a-328a46306890@kernel.org>
Date: Tue, 28 Jul 2026 17:08:46 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] hugetlb: only adjust reservation during unmapping if
 mapcount is 0
To: Guillaume Morin <guillaume@morinfr.org>, linux-mm@kvack.org
Cc: muchun.song@linux.dev, leitao@debian.org, Rik van Riel <riel@surriel.com>
References: <aleRuVBaWu6eTCJb@bender.morinfr.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <aleRuVBaWu6eTCJb@bender.morinfr.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 67E4F140011
X-Rspamd-Server: rspam01
X-Stat-Signature: hnrtryf9nn847ced6yd5j6ebxdir4joq
X-HE-Tag: 1785251332-147539
X-HE-Meta: U2FsdGVkX182lM63wkNgLMB7HRmpcmu8ZJx1BeFkMrjnq4RKnyxBwdCgECyia3uhAB7BDC/lv3t4YCVa+2qbsllxA22V1XEbUH7t/lk+DvacuC8eMUVgqmtWqI6G1ruBhwye5Q2gzaTwKy1Kq4Mybam5Cr8eMeTBCemKV1E7O8IVdY8hExs/xMiYVKHVG0oKgb4vLBEg/R2+WUsd015UDtDhUTOvOolRcEedfrccIx1KbfBGM3NcPqrOxSob7/cJ0qtzeQAtr0ajNhU5BcbbvGCwt6w/Vl5zr78KZ2jwGQ8f4Ua1L6PBMY1zBo5v0tmxu7zrjEXvxfmbNkESh1idFbzxZh4gEWyRqoDC8IvvSGEfyqVoHRCqKRMmJpT0I0xHeaBsY7RD8D47sYXpqhAF4HQhjd9uSV1zcq/c8VTLDTkFY/ODr+8jgxWYLGs8eUDpdAxRfcsj6O/nZKJcdUFKRx8roSgoyrZO7NTxrZsY6c2xEqr4Tf1FFqWsMF5Du4fEfYhf3k2JMuBk/PUCPwP+zFKYqFEdDRaUf9xNb1FejThYDAynLBf6ip5KzWHZQ97zbIEkLZqje2usmfUyVkXPZwS0VGFFXhqnXZJryxO5rI8inSERUuCJSB+YBwThyA9/oc44rGUDXzn7hXg0vapAezu5xZQvwf4yJdI4feKEqOueNisGz8z466xYRfsb7tR2vKgpwn0PhtBMuKsCgaX8CmAKYPF/0ZJHkTM0WwWfWWgUaXNMr2t1i8iuRrYRnyZgvA7SK/S6yPdW0CLqQoolAuZv5KFT35ZcIYeQavXsSF2+VUxIXPiqns4Y9s+PuIOs71rCyPJyx+wPRqRHRblMRXfF9bdy4WOVANljKq8ja1XXJ/EAfNm27qrX7+2g0sAnFwqwrIYEmY3i3LR9UUf3LvpGbW2Mf8E96+jvQSLr/YODc1VGu9MjniZQ9CcBxVD7dQ8OYC5Tb2FiobIgByP
 QfKnoeCB
 dHs9a3nxxV6Qer9MF7ReOh22qVCxUI+sbMGXU4KYkVGlciZP3rAyFb9y5/S1XL5XiggmB0g54ZAY/S3lV4cXzyaXLgeh5QdEMz4iAq9t1dEww3BK+ARelIQ8jvwHM1vYFEsmCa4Sn9tVNTqUhX5uXDPeX23s9tvchipw3eGRCy/ri9GDSpT1XqfDrRp/JD1J0pXlJ6DiAZ2tmzoP+xxEJ9CivwZGDP342jFj6/RJcnt4CSGK/9+nhS8uek7Om5pTEMULqPdqIR7auO6w57C/NtIepS3hkHuuG1BgWLDfhl0yUqTVCB59qYA9l5k0TQMrQPC+1D3cWMy4AmWvrHqsRbPDFEXFFubNmjYGTRKx3JKQ39aL+glbONaL5Q+dGzdmWC+KiuGpKSQkBRcxO4zPisxpSUHvJQSu0HlV8
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/15/26 15:57, Guillaume Morin wrote:
> Since df7a6d1f6405, __unmap_hugepage_range can adjust reservations. In
> the case of folio mapped in both a parent and a child, if the parent
> unmaps the range first, the reservation adjustment will result in
> an underflow of the reserved count. Once the child unmaps the range, the
> count is restored.
> This patch changes __unmap_hugepage_range() so it now checks the
> mapcount before adjusting the reservation.
> 
> Link: https://lore.kernel.org/all/alEJkwn5VlTTH_ZX@bender.morinfr.org/
> Fixes: df7a6d1f6405 ("mm/hugetlb: restore the reservation if needed")
> Signed-off-by: Guillaume Morin <guillaume@morinfr.org>
> Cc: Muchun Song <muchun.song@linux.dev>
> Cc: Breno Leitao <leitao@debian.org>
> Cc: Rik van Riel <riel@surriel.com>
> Cc: <stable@vger.kernel.org>
> ---
>  mm/hugetlb.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/mm/hugetlb.c b/mm/hugetlb.c
> index 571212b80835..c0167a09a0c4 100644
> --- a/mm/hugetlb.c
> +++ b/mm/hugetlb.c
> @@ -5252,7 +5252,7 @@ void __unmap_hugepage_range(struct mmu_gather *tlb, struct vm_area_struct *vma,
>  
>  		spin_lock_irq(&hugetlb_lock);
>  		if (!h->surplus_huge_pages && __vma_private_lock(vma) &&
> -		    folio_test_anon(folio)) {
> +		    folio_mapcount(folio) == 0 && folio_test_anon(folio)) {

There is folio_mapped(), can that be used instead?

-- 
Cheers,

David


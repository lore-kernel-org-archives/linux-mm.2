Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 26A91C624A4
	for <linux-mm@archiver.kernel.org>; Mon, 31 Aug 2026 15:59:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 222426B0088; Mon, 31 Aug 2026 11:59:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1F97A6B008A; Mon, 31 Aug 2026 11:59:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0E88B6B008C; Mon, 31 Aug 2026 11:59:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D30F16B0088
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 11:59:32 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 541D3401B3
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 15:59:32 +0000 (UTC)
X-FDA: 85162024584.28.BF2EA3A
Received: from mail-pg1-f178.google.com (mail-pg1-f178.google.com [209.85.215.178])
	by imf08.hostedemail.com (Postfix) with ESMTP id 7DF2E16000E
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 15:59:30 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=GOgYT4j4;
	spf=pass (imf08.hostedemail.com: domain of kunwu.chan@gmail.com designates 209.85.215.178 as permitted sender) smtp.mailfrom=kunwu.chan@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788191970;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=S55ppFl9FgwQ4vQKooEY5Qf66QJ+aBK7c5+37bZh5e0=;
	b=HZBFEEvJ4ypNxyCCyarb4oIzYo3I5vK+HQ9qNErCFcAaG1FLeChsKaSez8DO1f78yT/ZH+
	8vmuwsB0n+cel01pN/+P1ec1FH4kzgY4SfUQ8LF8n/VAOUaevov6+j702Ciskb1aFsLFvH
	PPv5qq+hbqVHfO45R8w7vypof6W537U=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=GOgYT4j4;
	spf=pass (imf08.hostedemail.com: domain of kunwu.chan@gmail.com designates 209.85.215.178 as permitted sender) smtp.mailfrom=kunwu.chan@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788191970;
	b=duY+0eKfzqebjuTc2Ag5uhXyrc83uSlhJqMtzcLpCMun8YtCJ7clRLR2SgRUYQNk18envd
	3+1MFzd4WEyzp9vG+zohk+hjMM9xzA6FKrIpJxNa7kJX8AbLLqPjkCI9MFO3UqVpnjgtm6
	jyAzv4MvbeFqCrFStDHBSWp4J1+SlPA=
Received: by mail-pg1-f178.google.com with SMTP id 41be03b00d2f7-c9e607d81fcso2384206a12.2
        for <linux-mm@kvack.org>; Mon, 31 Aug 2026 08:59:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788191969; x=1788796769; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=S55ppFl9FgwQ4vQKooEY5Qf66QJ+aBK7c5+37bZh5e0=;
        b=GOgYT4j48Vf96id6/bd9tc0sTSReJ9H1koB19nDPUXetfh9Cu9pHyPuc/jJibVDZYt
         I5s+ZkljUb/Aj4lF8+9TCsWaYohPW/NQpduKC8j1STUjJouImvCBPjDCJaJBhSUJloO+
         zXJRQx+mTbT6Locgk7x8T4A6ACmRC/+epc8HFHuBlUhVg2K6vMeBthenJhN0djypm1cc
         GndXM6qN3q0e62rWdC8xUgKnTELRa4xs0UY2eB7nBwfJX8imyW/3ELufkX7PZWMRldeC
         gSpEx+jfy3eoRFfb6uCNW6gW/njJvhaufb6wexxKSXDCSaBKHi1U0M+mD5CCQX1cYiSp
         Ffgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788191969; x=1788796769;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=S55ppFl9FgwQ4vQKooEY5Qf66QJ+aBK7c5+37bZh5e0=;
        b=gZ62+edOBX3njaGHnaQ4YlWhv80xEI/2Tbhi8QYYCiBhRs3F/h0fRaHw6Xt96sQ7Bs
         HVSgTXpxryPSmGVhQVLI1hhZ8k9jv59+tD3Qt6MkYjR+JdkTpwzLt0skuLSI7tm0Lke0
         iF9AdT/LL1MbJp0sKZa0/ZFo706OazqvN3ozp79nLsjEWLimEj+OMix9jCh0gzYJfNOs
         4RGhvLgk/ndOuHIihpdy8+8ndVIKQh7HqUMEcK8xn62SR4HzaffFB8IkRXqj2Z+PuK+g
         SBFq7ku8fYrHFKcb3T2Ys5xjgyXKwpbxVMnf/2j64xIHp4sucVLJ4KMI9r5GxfN3zypz
         16og==
X-Forwarded-Encrypted: i=1; AKwUvBydx+V6sMVurMntKpghj10qW6tVL0JdZM7YRepUXJeoX3DCTiFppdhxAMhrKxLLAsTBw7/7wpXJeg==@kvack.org
X-Gm-Message-State: AFuF++nsITg86EOTIAnhycz8KLLoNcKkaNY1c2iP9GxsDiSDxPVUI1AN
	UNfdTV/MtGN6dY9aU0YMSWjtHDhjtmei4hUvDAeN87B28/xkeg0zvOwI
X-Gm-Gg: AYBFou0eWw0Y4K+21Vhv178NBAOozLDqvTiVn+v7nirGZZPg0rAAcVufAKQOYQY4Al6
	X1Sb+Rd887sU0c2i+9gn9PpuZuaP/N129iR8NOdXAKU6AS/2pN3c90eyVQVYQi1QL5n9wRg/uYP
	u3bZ7fHx/0QD1+5Pgh/pKETNtbBTqe2OAuctN8X4JQ9NnetrcfKWUDD6/Z4AVgDDPMDZ5nS4cBC
	hi+xLizpIPZhmSXFyles0EcbUMBJmvx0Prljdo8R4ridEPV4738HzvWCD7J9HsHLbmQ8kEO8Wml
	88lY4mNxiyAr3STGIJaPHfCa4BUb/aZQS7yugEukO0n9lbZN+ROYFTURmTl6T1AAvjg9EYTVcD5
	c2OemAwj2dkqYsPIinBlpGxxmq0jsONy4Uzntxlj2jxO0qL8Mf69kpB+EDkjBdgdPI5Qx07PHTu
	ZYlZv5pUntELiZIHrKv+e0twVbFBm6EsddUdk1jLUubXvcUtO4NSkOV9ee/G4=
X-Received: by 2002:a17:90b:3c45:b0:398:c292:ac80 with SMTP id 98e67ed59e1d1-398c292b6b2mr20410535a91.10.1788191968691;
        Mon, 31 Aug 2026 08:59:28 -0700 (PDT)
Received: from gmail.com ([185.220.238.38])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3990d630371sm115535a91.17.2026.08.31.08.59.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 31 Aug 2026 08:59:28 -0700 (PDT)
From: Kunwu Chan <kunwu.chan@gmail.com>
X-Google-Original-From: Kunwu Chan <kunwu.chan@linux.dev>
To: Dev Jain <dev.jain@arm.com>
Cc: Kunwu Chan <kunwu.chan@linux.dev>,
	akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org,
	riel@surriel.com,
	liam@infradead.org,
	vbabka@kernel.org,
	harry@kernel.org,
	jannh@google.com,
	lance.yang@linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Kunwu Chan <kunwu.chan@gmail.com>
Subject: Re: [PATCH] mm/rmap: remove stale hugetlb check in try_to_unmap_one
Date: Mon, 31 Aug 2026 23:59:12 +0800
Message-ID: <20260831155913.2497152-1-kunwu.chan@linux.dev>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260831082849.3573957-1-dev.jain@arm.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: dsumub4rj3pycpxqcnsce7uxun7ketdy
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 7DF2E16000E
X-Rspam-User: 
X-HE-Tag: 1788191970-557104
X-HE-Meta: U2FsdGVkX19S0cPma51uuIJbP5Fwc2wC2oxS1GFqiEHHPgCv7i+5XHzfdkEpWwFN7aXB9oqX/qF38Njd/yY4VQvpc3CSBmKvOlVVvMpdmOrrEbP7ZaD+6ktNItwt57aukdQw8+mPNk7zLMdmhd9/FYAwuGxojttRf8TRLGMPtA8HzG+UA5rXzD9Xts1G3Zx7UpdoS9cptE7Xd3QlDFvROeZuR6nkxouX/uCL0EunfXHZJyOZn7ZdD0BOSRfkli06z4MgdEOPaVHix6adGwx/LQMHeTcnuKkl7xZl3Lx/C8qq7SwCk5PhZCKbQFI6yA/C7+1JmHVh+xdGY8aPgTjAGz7qNOAZQHpF1sWqxN03iNw9VYiG+EsVL8YW8L9F+W4uokUBUc8ljqrd53Z7FI+29BMhmLvuUpNfVqQpPuM4IwYm7zeVwJ4UA+mD6xlBdWICQX8KzF8gJfhaPpJgiNk4bcHRg3rt8pguG51dGgoTMF95y5ZvKwcQ60a0tEbl337pQNiDz/GcYgEFMRiYZPYzr+e0YxrSWntkEbj4l79AVx0SOMPhmYpP+pL3ugKhC3GEE+uKUJDedNysjA8MDJY2vu1CfvUGUfM7Zv6ECNFBDtXQbTsLmeJXXca2NXc3c3jwhNDf+IyCukCUpbNxzoQS7t/RlW/smXx6xDg2prhxVUIqzA2DOHKiG7/87SD6hEBBQkjM6mBdeQ0uP0PNr4rs01lewqo+/GEZJ1HI5mPa7q3TDtK5Biwtl0TCCf1kisAuZItY3UBVEjWLqcA9M7B+s/Gf1fVPZfCdWPidxuy2dhtH1T7ie0YJX9eWXxRiPzEMfcQ61YyzKcawNHThx7Od/7/usg6sK4Lz3k2nJnbphfwF3cZj/0Vc5CvlQQ+BHbgpwUHTPy+aGpLmUGc5+jnUT7jMyz89hF8cfWhEn1F4Hv6WphZfWAyQDPNgsCjOr1UKgHRalqd7TnTEeCM4Khi
 LaxaMosk
 JrJhyCHjZuPvwQTEI6+s3Z5Jv0SkGSFvcKlsJIu6/dRNgW7sMtsd/LIKLsVu6HKNR2piIRz2TdT9uOH4W5eM8yneFjCExKU1alW7r5gvomxI912pzrR+wYymJ6mtmskNfLiniJpjQl4izL1LfRYvtTExQhLbb0W1Pnp3IUohd8mAEw5lV0m+U9NBfyIPtIvhCYdA9ElsfLjp+kLCNJHZs5d1X5jkZXQTBprXnBc4a62Mmnq4C2dZC/8Gv0S9dkP83wFzc8u526TTeBrfO9E1hS9Ve4uo04SbhWQJ425QKu/aeL/xpw1567StQJZtyO5LzqUHyNOdzM/t0tGvQscqZd156RCEetsXLzOqkvT7xhlDzFht8Q8DpJNi99tBt5uBEu0uzIkqsoirGGRluqkVirIAg7Tq4lTNS8yhrzA7CPBf3BiupaHFlOQ/u3l4LjfLbURMgVCqySo4EypoKvkzf4IGozH0fKiDVyot+MuCRxTMLLmwbp8fcyayRB8IGRzI9l50dVCh1/OQAeKT3NbePbXf5MfnAHhTIM3Gc+Cy5OenBe1XZIuQ3lzL9Aw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 31 Aug 2026 08:28:47 +0000 Dev Jain <dev.jain@arm.com> wrote:

> Post commit d4ec5572825a ("mm/rmap: add try_to_unmap_poisoned_hugetlb_one")
> try_to_unmap_one() cannot be called with a hugetlb folio. Therefore remove
> the folio_test_hugetlb() check.

Yes, the d4ec5572825 change shows that try_to_unmap() dispatches 
hugetlb folios to try_to_unmap_poisoned_hugetlb_one(), 
so try_to_unmap_one() cannot be called with a hugetlb folio.


It would be better to add:
Fixes: d4ec5572825 ("mm/rmap: add try_to_unmap_poisoned_hugetlb_one")

Reviewed-by: Kunwu Chan <kunwu.chan@gmail.com>

Thanks,
KunWu

> 
> Signed-off-by: Dev Jain <dev.jain@arm.com>
> ---
> Rebase soup - my huge_ptep_get() fixes landed after the refactoring.
> 
> This patch applies on Linux 7.3-rc1.
> 
>  mm/rmap.c | 7 ++-----
>  1 file changed, 2 insertions(+), 5 deletions(-)
> 
> diff --git a/mm/rmap.c b/mm/rmap.c
> index d1819fd699380..606c8ecf31302 100644
> --- a/mm/rmap.c
> +++ b/mm/rmap.c
> @@ -2299,11 +2299,8 @@ static bool try_to_unmap_one(struct folio *folio, struct vm_area_struct *vma,
>  		VM_BUG_ON_FOLIO(!pvmw.pte, folio);
>  
>  		address = pvmw.address;
> -		if (folio_test_hugetlb(folio)) {
> -			pteval = huge_ptep_get(mm, address, pvmw.pte);
> -		} else {
> -			pteval = ptep_get(pvmw.pte);
> -		}
> +		pteval = ptep_get(pvmw.pte);
> +
>  		if (likely(pte_present(pteval))) {
>  			pfn = pte_pfn(pteval);
>  		} else {
> -- 
> 2.43.0
> 
> 



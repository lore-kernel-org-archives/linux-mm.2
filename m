Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A8269E6749B
	for <linux-mm@archiver.kernel.org>; Mon, 22 Dec 2025 08:23:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 975BD6B0088; Mon, 22 Dec 2025 03:23:38 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 923766B0089; Mon, 22 Dec 2025 03:23:38 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 82F676B008A; Mon, 22 Dec 2025 03:23:38 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 709696B0088
	for <linux-mm@kvack.org>; Mon, 22 Dec 2025 03:23:38 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 1548C8B974
	for <linux-mm@kvack.org>; Mon, 22 Dec 2025 08:23:38 +0000 (UTC)
X-FDA: 84246418116.12.F840AEE
Received: from out-171.mta0.migadu.com (out-171.mta0.migadu.com [91.218.175.171])
	by imf25.hostedemail.com (Postfix) with ESMTP id 35FE3A000B
	for <linux-mm@kvack.org>; Mon, 22 Dec 2025 08:23:35 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=faTvPAjT;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf25.hostedemail.com: domain of chengming.zhou@linux.dev designates 91.218.175.171 as permitted sender) smtp.mailfrom=chengming.zhou@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766391816; a=rsa-sha256;
	cv=none;
	b=njdclm3PBgx9xyXB6W8wpZ+IA8Ins0gZmKQ1N35yq5+LpexRJXZf5Ig/mKvSs9cd9dI+NW
	DlKoHCAgMNspefMIiJJRRyYicH95rvO/Pb/ygcj/qGDHHd/swTFVozkT8toYhLT6kqMzYd
	eaRxJ75ctcnviwB226QO3mp/ZSQjszY=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=faTvPAjT;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf25.hostedemail.com: domain of chengming.zhou@linux.dev designates 91.218.175.171 as permitted sender) smtp.mailfrom=chengming.zhou@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766391816;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/c4zkGZ1j4uSjI4uDlaD2/g71zW9hroM6yOlK7PiRhQ=;
	b=zWKqQuEDOk0im1yy2UdFyU7ylyrtrwuoooSqR6eXLB+DtvHSeqyopRhwghWtkgDRMyXCCG
	XEWB+GZYZTFOwpK2lo3g0XpPcBxMjvgq8nck+YclcBwuenoB5Vc9/dtHvfPZTRKIfTcwTt
	2vWqv1FuVQWVMI+0myE2Rf4eZ9lwzw0=
Message-ID: <30e2087c-3bca-479c-9974-0681f0187cc2@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1766391809;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=/c4zkGZ1j4uSjI4uDlaD2/g71zW9hroM6yOlK7PiRhQ=;
	b=faTvPAjTgnwnLkY+Lt1BQpsfXjUFyjt3PN87D3Dpx8fZWg7SfU/LFXh137t49CPRsKUJ2P
	lwBfiGbdDdj7FYmepEitJrEzp/DHGaOEIXSNb2yVDwRB8GUdXJ6c9swqV6GW5Rx0uQkyE6
	yD4YJPRBuk0lEDeY0oBtLAZvArYtmRU=
Date: Mon, 22 Dec 2025 16:23:13 +0800
MIME-Version: 1.0
Subject: Re: [PATCH] mm/ksm: fix pte_unmap_unlock of wrong address in
 break_ksm_pmd_entry
To: Sasha Levin <sashal@kernel.org>, akpm@linux-foundation.org,
 david@kernel.org
Cc: xu.xin16@zte.com.cn, pedrodemargomes@gmail.com, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
References: <20251220202926.318366-1-sashal@kernel.org>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Chengming Zhou <chengming.zhou@linux.dev>
In-Reply-To: <20251220202926.318366-1-sashal@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 35FE3A000B
X-Stat-Signature: m5bc79uwiauj68aydbyf1tmeosr567pa
X-HE-Tag: 1766391815-33328
X-HE-Meta: U2FsdGVkX18yVQ27PgCVu0y+5hn52IipegQ7crqWafrPHzDI0QMiVKzaNEXVC/SpDwUSBMEN6j9R3UQS/tPQBOve4Q+S9JR3P2PXn7Rb7PTzk3x9SisvR9jAgXPQWiPxcYDrvqDwX8EIOzWnDcmlV2DCPYmkWqI+sacEmds8UP4WUkAEtH1BD/ZQl+Y3TtAMpTRkEfYsQqEMj1aevyF56UF4fHIYbC3GSqHQqtxOuYKC4xtH3vxZVKkJgHF3D0oTPfhO83Y/mlGD6AFrJPzDKp4xeJ5e14jlFS7jh8wZtVlGdUfFm+2qIF/F8f+0mSGnun0zkbiMSqEJPq5dlXrrhaQ18oeNDkkuxd4kURmMzZbKyCLDocyAj4Pov8EbeKLvk7Td2wJwivvKq76wep+Qaw0BnIDyAGp1WYzOEQvz+PfRWBuqr7zynJDJGJNNrQBAdMJZ7+1R3y16FiYcq3SAZvbnORioi6f8mVc3HRCZ5FAH7GbIHJ1/ztjJY27Y+0WiaNZx0utVb/g5RUeFbduBTF3SuJy75ezRy8Q3vKaXgnlR4AGmIIhWTCiB3bSfY8nTcyfk31mODNf/6umYN7MfGAVCed5Vd7ssg84X5G1sKYx2i/byT0B0d1Y9J43yZvC6n4gkNYsOqpc6uDTbcEWDxEG8yjB1rPh/86Qr+QlVjvavh7uaVxzzCF4I894D9DL7bO6OgNDvwob4qjWIApf8hgbSlC5n0UwFpRwaDrzDH2UBqfmC9JwAozvFBoWDVhQm3UihcYjLlCDz/VrOLSmMpO2vo9V6x/uMttfxlhjboUFh+8Ww8Q/CcG1Pepcq97BvQI0Blbs017vLykfdMBK28WCgMJQHYCAIXyenlqdHwMGNJNb8a0v0kxzgwooj5tXbYPupkGDMpRmkj7IPGZw1l/aLS/qVUNAJwzePpmfsTFFDn5/SlZZE9wyiq14N0X6kCDxSEVW9ATJptv0NF72
 H6bE0l9p
 mtLz57OU/Dmsi/TjV5hl3LwmEk4ym4j9jvMjL4YE8FeLb0uwliy5Fzd36QiUgpELDkDSu5kXR7ajjk6aHYyCDIPxsdgelVm7JCCg4H0WgvJevg+c6PlyjbKBFBvWohyr08jYrSKiXQE+C/4R3Kk6TgVo2vO0kGZdsiXbU7CeHKfU+m1bIAtI/s41e0WKi2I6luod1UUe/3o2D++PKnyvyTWaz+0YiTcVktY27H3gXAE4yq1eUdM3/ViTsalGLYbaz4JLCzimwU5nwxBFuR31R0JQQRQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2025/12/21 04:29, Sasha Levin wrote:
> On ARM32 with HIGHMEM/HIGHPTE, break_ksm_pmd_entry() triggers a BUG
> during KSM unmerging because pte_unmap_unlock() is passed a pointer
> that may be beyond the mapped PTE page.
> 
> The issue occurs when the PTE iteration loop completes without finding
> a KSM page. After the loop, 'ptep' has been incremented past the last
> PTE entry. On ARM32 LPAE with 512 PTEs per page (512 * 8 = 4096 bytes),
> this means ptep points to the next page, outside the kmap'd region.
> 
> When pte_unmap_unlock(ptep, ptl) calls kunmap_local(ptep), it unmaps
> the wrong page address, leaving the original kmap slot still mapped.
> The next kmap_local then finds this slot unexpectedly occupied:
> 
>    WARNING: mm/highmem.c:622 kunmap_local_indexed  (address mismatch)
>    kernel BUG at mm/highmem.c:564  __kmap_local_pfn_prot  (slot not empty)
> 
> Fix this by passing start_ptep to pte_unmap_unlock(), which always
> points within the originally mapped PTE page.
> 
> Reproducer: Run LTP ksm03 test on ARM32 with HIGHMEM enabled. The test
> triggers KSM merging followed by unmerging (writing 0 then 2 to
> /sys/kernel/mm/ksm/run), which exercises break_ksm_pmd_entry().
> 
> Fixes: 5d4939fc2258 ("ksm: perform a range-walk in break_ksm")
> Assisted-by: claude-opus-4-5-20251101
> Signed-off-by: Sasha Levin <sashal@kernel.org>

Reviewed-by: Chengming Zhou <chengming.zhou@linux.dev>

Thanks.

> ---
>   mm/ksm.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/mm/ksm.c b/mm/ksm.c
> index cfc182255c7b..2d89a7c8b4eb 100644
> --- a/mm/ksm.c
> +++ b/mm/ksm.c
> @@ -650,7 +650,7 @@ static int break_ksm_pmd_entry(pmd_t *pmdp, unsigned long addr, unsigned long en
>   		}
>   	}
>   out_unlock:
> -	pte_unmap_unlock(ptep, ptl);
> +	pte_unmap_unlock(start_ptep, ptl);
>   	return found;
>   }
>   


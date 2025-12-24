Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 11466E74916
	for <linux-mm@archiver.kernel.org>; Wed, 24 Dec 2025 11:35:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 20A836B0005; Wed, 24 Dec 2025 06:35:14 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1B81F6B0088; Wed, 24 Dec 2025 06:35:14 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0C3F56B008A; Wed, 24 Dec 2025 06:35:14 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id EC2976B0005
	for <linux-mm@kvack.org>; Wed, 24 Dec 2025 06:35:13 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id A52BA1A0128
	for <linux-mm@kvack.org>; Wed, 24 Dec 2025 11:35:13 +0000 (UTC)
X-FDA: 84254158506.02.D8E92E4
Received: from out-179.mta1.migadu.com (out-179.mta1.migadu.com [95.215.58.179])
	by imf10.hostedemail.com (Postfix) with ESMTP id D06CBC0007
	for <linux-mm@kvack.org>; Wed, 24 Dec 2025 11:35:11 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=f+ipvznN;
	spf=pass (imf10.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.179 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766576112;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=y4r+rkBsBIRRgeO/AD5wwWFdV4DArdg4UZWAqYivFNs=;
	b=GD7SgvugCplqVezWqeColce6D8EH9OMuX5dEmvso7iIe72t5of3VPmyFE1BqWKhj8nL/M0
	+7vTBFKoP8YWYce2NqkkQF3aoR2o7+lDlSvv11+U5X4BiGW30A6B2nYcFu5g+zqZhXOwlx
	ncbNLaXBKiZYcQgqemckZDXGha+f2os=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=f+ipvznN;
	spf=pass (imf10.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.179 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766576112; a=rsa-sha256;
	cv=none;
	b=zoHEbDUtLS+xEsOiCK4Hj4EBfwlhWHsKXvj8WAt0WItm8X6luqvNpGrfaSG2GVmgIFVsNX
	9j3xxNgxEYUyizi5d5AAPcS+jKubQdMv4cSN0/CNI0yyqW2frxED18cP41/3epKUiq/3pY
	BDPOl9NXq90pudaFvYEe0bu0xi0BNew=
Message-ID: <533d2818-b7ed-4bdf-a69b-5ca2678ef193@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1766576109;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=y4r+rkBsBIRRgeO/AD5wwWFdV4DArdg4UZWAqYivFNs=;
	b=f+ipvznNzx2BGJa7BQHWc6B7JD9Qq54vNmjmGvPaEXx/ICCLDP4vErBdNrqGf7ARGH3RE7
	szdz60O6/eYKyLCGaHaslJgLXXnOtUHDaXcDX/W2Dh4DP9Te/QAXc056UXzTC3n9DjcfTy
	s42844qNlAcL6DQ2EzUKH4C9nvA0Ur8=
Date: Wed, 24 Dec 2025 19:34:47 +0800
MIME-Version: 1.0
Subject: Re: [PATCH V2 1/5] mm/khugepaged: remove unnecessary goto 'skip'
 label
To: Shivank Garg <shivankg@amd.com>
Cc: Zi Yan <ziy@nvidia.com>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 "Liam R . Howlett" <Liam.Howlett@oracle.com>, Nico Pache
 <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
 David Hildenbrand <david@kernel.org>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
References: <20251224111351.41042-4-shivankg@amd.com>
 <20251224111351.41042-6-shivankg@amd.com>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Lance Yang <lance.yang@linux.dev>
In-Reply-To: <20251224111351.41042-6-shivankg@amd.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: D06CBC0007
X-Stat-Signature: hje1auwtf88ewffutehek3j15p7r6fjn
X-Rspam-User: 
X-HE-Tag: 1766576111-496273
X-HE-Meta: U2FsdGVkX1/mEDABsM5gucvo/u4oK99HymKC6Hp754Slx8Yfeq8jOwS1zIlAhXmslbmnTbOEIsqQP8V19U/u08j4G4ezTkD1JnSlfAJzXvdapRyLYlwEtcaWMjtbUD/NPy+gAGKFOUnpG/D7Ete86boD0pM0TBSiilPUT72QeM61BhUfmfpL97rVbEUfrLBmm+QrNKfRICZ37yqUfiytll5Q/7tpeGze3bPPy3CIsJxd2OHQRCCFkZ6BBYxBvh7tAWYRk4vR8akwNCOHo3bFr6HLDLRc7vinVJME92Vcpjy3rV3Yye2c5BC2h7PVBvdvpAJyaulNlOu7XrPMsMuZ/K1oVdhdsgjNaPWW1lg0fBLtftLHt6Y2zefe3tBBfX8jG3IQ97AGPJR3O3fpQeZ/WUG7aSslljxjljZgYkqCHtDEVcF4dm/vQujv6FnWsX/PbdJPh2FXjNb9KIwxEFJZCccqr1Nt9Gsa9o/iLDsnmHM5qNpXl3yD/dRwm0YhWR9q3SHqID+ORj2R649vbPwvPSQY5llhPtZrds21YSBO2G+CDaEUhYdUsbg0QujW+DxNFPOWz9RA035jUMD9oKHCroYTnGi4uE+WDSY87VIKm31ujiSCZrCKw+vOKme2dcg3GAyhqYubI9SC4VTz89AZ9Yi3s8yNawPztWP1VMndw7K0/ytxWsgDqtf17DBAdzrEjrCcR733zqMBJybqSBjVC3yRHa0QlhG5IYZcACcVP/FM2bek2ZQgTEnxCRW92ehj0tJpu/04yGdD2RcyVwZXsOyqXe9ZAdCqnkWC8bsJCUZYlK3sixGDHKw++PigA+jS2D1OEOZd+u6O+Zfi3KUI5YuMD0nve1y5joK4jEN2C+Gmg7mpAeqIVA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2025/12/24 19:13, Shivank Garg wrote:
> Replace goto skip with actual logic for better code readability.
> 
> No functional change.
> 
> Reviewed-by: Liam R. Howlett <Liam.Howlett@oracle.com>
> Reviewed-by: Zi Yan <ziy@nvidia.com>
> Acked-by: David Hildenbrand (Red Hat) <david@kernel.org>
> Signed-off-by: Shivank Garg <shivankg@amd.com>
> ---

LGTM.

Reviewed-by: Lance Yang <lance.yang@linux.dev>

>   mm/khugepaged.c | 7 ++++---
>   1 file changed, 4 insertions(+), 3 deletions(-)
> 
> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> index 6c8c35d3e0c9..107146f012b1 100644
> --- a/mm/khugepaged.c
> +++ b/mm/khugepaged.c
> @@ -2442,14 +2442,15 @@ static unsigned int khugepaged_scan_mm_slot(unsigned int pages, int *result,
>   			break;
>   		}
>   		if (!thp_vma_allowable_order(vma, vma->vm_flags, TVA_KHUGEPAGED, PMD_ORDER)) {
> -skip:
>   			progress++;
>   			continue;
>   		}
>   		hstart = round_up(vma->vm_start, HPAGE_PMD_SIZE);
>   		hend = round_down(vma->vm_end, HPAGE_PMD_SIZE);
> -		if (khugepaged_scan.address > hend)
> -			goto skip;
> +		if (khugepaged_scan.address > hend) {
> +			progress++;
> +			continue;
> +		}
>   		if (khugepaged_scan.address < hstart)
>   			khugepaged_scan.address = hstart;
>   		VM_BUG_ON(khugepaged_scan.address & ~HPAGE_PMD_MASK);



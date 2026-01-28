Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D0033D25B54
	for <linux-mm@archiver.kernel.org>; Wed, 28 Jan 2026 13:04:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 412866B0089; Wed, 28 Jan 2026 08:04:12 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3C04F6B008A; Wed, 28 Jan 2026 08:04:12 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2A1D86B008C; Wed, 28 Jan 2026 08:04:12 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 18F016B0089
	for <linux-mm@kvack.org>; Wed, 28 Jan 2026 08:04:12 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id A4D20D3BD7
	for <linux-mm@kvack.org>; Wed, 28 Jan 2026 13:04:11 +0000 (UTC)
X-FDA: 84381390702.21.D581E1A
Received: from mx0a-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
	by imf26.hostedemail.com (Postfix) with ESMTP id 8ED92140010
	for <linux-mm@kvack.org>; Wed, 28 Jan 2026 13:04:09 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=meta.com header.s=s2048-2025-q2 header.b=iDXq3tL0;
	spf=pass (imf26.hostedemail.com: domain of "prvs=048834cd31=clm@meta.com" designates 67.231.153.30 as permitted sender) smtp.mailfrom="prvs=048834cd31=clm@meta.com";
	dmarc=pass (policy=reject) header.from=meta.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769605449;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=k/pGhjjYmAKBWBEtTdB176K0sd0KMfPht8r5ew4KCnM=;
	b=LwhZMScHjnoj61B8jtT7xaTm/v4N/s3cmqQU/IZGQON+r5PYYC1P3bZqDbAmBW7WsFFASI
	jIgE4XF27psUiyDun68LUFZLXJwMWJlC/G8FbqzDrprVzt8cDVxm6MhcGqL2Geq7i57JUb
	j2/QEILlj94JNgWhj3DzaY3vZ1FO6po=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=meta.com header.s=s2048-2025-q2 header.b=iDXq3tL0;
	spf=pass (imf26.hostedemail.com: domain of "prvs=048834cd31=clm@meta.com" designates 67.231.153.30 as permitted sender) smtp.mailfrom="prvs=048834cd31=clm@meta.com";
	dmarc=pass (policy=reject) header.from=meta.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769605449; a=rsa-sha256;
	cv=none;
	b=L1lNt4JLVto/VkxwOkgCUwTviVbjoRzp+5p9FAH4XgG0+rIFA1TGdfv1D/IbAbYGuuHxTI
	7h9/ecTP0w1R5eDxg4LFJcjIjBheVnNFHQnOfx5cg5cAt+da4SOdjgEMtQAOtbLtU7B436
	2fhhcTMy7rukoT2tEMau8vpPem9QQQE=
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
	by m0089730.ppops.net (8.18.1.11/8.18.1.11) with ESMTP id 60SB0vN6978688;
	Wed, 28 Jan 2026 05:03:52 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=s2048-2025-q2;
	 bh=k/pGhjjYmAKBWBEtTdB176K0sd0KMfPht8r5ew4KCnM=; b=iDXq3tL0fkx6
	iUG695ttVIZmvas0BlfoDpOw7EQzAWF4VRuFWm4hE7AiJFoFMhhDaISMWtPLZZio
	5c0kkajV6J7aDDsMttgdZD6gPhxmen+27SXuUcH+VzRTNX9RAR2Wj2gqd3OLA3GS
	WNUnFoUShTW6CsYXGm1lk+zyswz8/Afi1t4IfF8budHOCncTqcjaefXOI7bj76zk
	FuhkNRhio5NN6PnTcsPH7dB7s3ceL9LJ0hNtmrnmMB8ko3x214UtnC/3EIGshKCN
	uDW1zZ4s48jdjArdbNK/PG0ukz1vW2bLzhMZ52TUzk3IbMUfOYQODMrrXJPgRoDH
	M5jPaXLmcQ==
Received: from maileast.thefacebook.com ([163.114.135.16])
	by m0089730.ppops.net (PPS) with ESMTPS id 4by7wtmax1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
	Wed, 28 Jan 2026 05:03:51 -0800 (PST)
Received: from devbig003.atn7.facebook.com (2620:10d:c0a8:1b::8e35) by
 mail.thefacebook.com (2620:10d:c0a9:6f::237c) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.2.2562.35; Wed, 28 Jan 2026 13:03:50 +0000
From: Chris Mason <clm@meta.com>
To: Kairui Song <ryncsn@gmail.com>
CC: <linux-mm@kvack.org>, Hugh Dickins <hughd@google.com>,
        Baolin Wang
	<baolin.wang@linux.alibaba.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>,
        Chris
 Li <chrisl@kernel.org>, Baoquan He <bhe@redhat.com>,
        Barry Song
	<baohua@kernel.org>, <linux-kernel@vger.kernel.org>,
        Kairui Song
	<kasong@tencent.com>, <stable@vger.kernel.org>
Subject: Re: [PATCH v3] mm/shmem, swap: fix race of truncate and swap entry split
Date: Wed, 28 Jan 2026 05:02:34 -0800
Message-ID: <20260128130336.727049-1-clm@meta.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260120-shmem-swap-fix-v3-1-3d33ebfbc057@tencent.com>
References: <20260120-shmem-swap-fix-v3-1-3d33ebfbc057@tencent.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [2620:10d:c0a8:1b::8e35]
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTI4MDEwNyBTYWx0ZWRfXwoGNjke19CC7
 n/dt4+Be8CsTyZDuUmOA7wTaR9aLdsB08tTPkDkImpfkNHgDzd1eUj3tz+KxT3y53NaF1CZKirN
 NxqQOfCjWhXudfFYwFmdZ3m1wc5rG8VDyXU06zD/zvha6MsmtLaZBDyoiXjfd4Lf3Sr/JWGxVsT
 PePTbUI+eultJJURd6e0ge+VEJlyMMkJCvkmRmepppT+GQAMRToqz5x8yVCjmg57hTS/UEEO2tv
 2ArCVl1WZq3sHMaf7tJr8mFXRHqjUenaprF21E2LL9PbGS0sg9LkZChFT3vyTBaM9lMs+ENXYOH
 muk6GmxXx5N2/3HVz7tIoCJfpuP4lzB+10mUrqxwwDjRUC7WVDzXmmHJjD56nTo6hfM7IeY+Pkg
 97RzKhL7q4tdk86qo8UEVZqMiX+bfTdCicn/c7018ahehw/k7I0hHhPGnAu/675YY/KerPvc09X
 2SemmyQjd4xHwVR/vQg==
X-Proofpoint-ORIG-GUID: uHLxgoPUD54u1_PxNjda0pDEUYOYnRxj
X-Authority-Analysis: v=2.4 cv=Jsr8bc4C c=1 sm=1 tr=0 ts=697a0937 cx=c_pps
 a=MfjaFnPeirRr97d5FC5oHw==:117 a=MfjaFnPeirRr97d5FC5oHw==:17
 a=vUbySO9Y5rIA:10 a=VkNPw1HP01LnGYTKEx00:22 a=pGLkceISAAAA:8 a=GvQkQWPkAAAA:8
 a=h77ORrGvqfQH1F6JnNAA:9
X-Proofpoint-GUID: uHLxgoPUD54u1_PxNjda0pDEUYOYnRxj
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-01-28_02,2026-01-28_01,2025-10-01_01
X-Stat-Signature: c1i5t8n4wdjxauw8gc3axo6mpqswcph4
X-Rspamd-Queue-Id: 8ED92140010
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1769605449-337696
X-HE-Meta: U2FsdGVkX1+9E0SDZwD/TV44JTHDsNFfMtfai+QZ99ZnYkFmEMvXc54kgEjejv8JAKkVVCjgP6vEEfmqVTXfJOr9xnYOGp+d1ApYou50RD66vzGoJLKwtEkLuY6Eoj/L9sgzPSSnmq+iAt/dc91wslrSSBR/frQ8vwHcUBcv5bOOpa8W50XqfMByHMMXP589/6dFxas7UPeOVKfwixON6ttt2i7gt0f5iIA0BRQ/RzxfSsRCYDdJt0QUfg5Kd+oU+LHiX/vrl5vi1YX6YEjTLpZl9Ke/g2bMqc8WWFMM/yCFdJsVgeopanMhC/l8v2chDNxWQCBL4i8++FBzz5B130GZg3jHk8AGssP1P9c0RSY/1YIoIkayY5IDfxzUR68ievv6xFYB+8yT40BWJmjVCmcjhcKjGgqqoZcMiyF4oqV9E43+OvCH+CMfvPDi7cyH9lnazqSZJogz8mIN5549YvueQwI4fRttcJBQ4v+1uwsIYNYo6qamewL5VlgTMLgASof4iZ/+x1kVczxcNWM06d7ZWxnrDU+0L8bCkPEca/LdWFMWD/U2Hcpe1pa/LFfJyT4Uapw30J39oMcuyf3b/F5XaGLL2nf3AcLL1sC/sm/quVKfLb5fTTfKsmQDaRu9UqkqVVPFJVPFxxkTw9gMpuvVP0vcxSaMzJBDIWyWuTE4zd8yiiHc3sZQUds8qdYhPG6KNIZsU3GMmtpZZjS0H8DjoV74EP2KSDIoSWGNMeQiBY4ddh6eBhFK5vUifGTrSTcIX+CZCp+gj8Ut472rxVToba7WGVK5MQhQHiP24XRRlIJqUW1cAGnljAG01IWuWKp62OF3TkhNSxwroMSo+vFx7zI1UedZq14bKJ8OrYQ/jh1WdkxstBfaxV89MPtDk10WFsoSCCpJY55Ru94Yg26NWfmUYyxhYnIms9IrvIVTnWAgQL3T6YiMq+AYuutsb3YMJq+BNzKcj/H27aY
 wZ2GjjDy
 3qpZFmo1KDzkJDHI+B85S+/8OlDRs2MYZLeoKFykfYfyXJ6xrNylTsOazP58L0ihRDYi0Eq/4sGsH8BK6vQlZOGfH1iHtBqBQ/r9asuEmpmizxTp3B6qTEIbp0+WzGqUA+nTpvjJfl+5nObcp3v0LGQZ5+/C2fmvr92dABM4T5nA8OMOdg/grgVLX2VExcMjRduCdnsYuQwOXBUZ4WyxI2hJY7iUlJzX15sMMDBID6ACMYfb42diw/UUIC+jvqrGDGg9F/781TZrC4DuYv4sLdKiCIj+csvHunqUVPHmibyo84x4xbx/bTvsh0mgr28aOOuLzbh7VWNNF7Ajy5PrnWa2KPgcem99p1Gma2QFfDOaZCYBEb0/1i+ID2l1YPyL+uRVx
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Kairui Song <ryncsn@gmail.com> wrote:
> From: Kairui Song <kasong@tencent.com>
> 
> The helper for shmem swap freeing is not handling the order of swap
> entries correctly. It uses xa_cmpxchg_irq to erase the swap entry, but
> it gets the entry order before that using xa_get_order without lock
> protection, and it may get an outdated order value if the entry is split
> or changed in other ways after the xa_get_order and before the
> xa_cmpxchg_irq.
> 
> And besides, the order could grow and be larger than expected, and cause
> truncation to erase data beyond the end border. For example, if the
> target entry and following entries are swapped in or freed, then a large
> folio was added in place and swapped out, using the same entry, the
> xa_cmpxchg_irq will still succeed, it's very unlikely to happen though.
> 
> To fix that, open code the Xarray cmpxchg and put the order retrieval
> and value checking in the same critical section. Also, ensure the order
> won't exceed the end border, skip it if the entry goes across the
> border.
> 
> Skipping large swap entries crosses the end border is safe here.
> Shmem truncate iterates the range twice, in the first iteration,
> find_lock_entries already filtered such entries, and shmem will
> swapin the entries that cross the end border and partially truncate the
> folio (split the folio or at least zero part of it). So in the second
> loop here, if we see a swap entry that crosses the end order, it must
> at least have its content erased already.
> 
> I observed random swapoff hangs and kernel panics when stress testing
> ZSWAP with shmem. After applying this patch, all problems are gone.
> 

Hi everyone, another flag from running mm-next through AI review.  I'm
low confidence on this one:

> diff --git a/mm/shmem.c b/mm/shmem.c
> --- a/mm/shmem.c
> +++ b/mm/shmem.c

[ ... ]

> @@ -1191,12 +1203,23 @@
>  		folio = fbatch.folios[i];
>
>  		if (xa_is_value(folio)) {
> +			int order;
>  			long swaps_freed;
>
>  			if (unfalloc)
>  				continue;
> -			swaps_freed = shmem_free_swap(mapping, indices[i], folio);
> +			swaps_freed = shmem_free_swap(mapping, indices[i],
> +						      end - 1, folio);
>  			if (!swaps_freed) {
> +				/*
> +				 * If found a large swap entry cross the end border,
> +				 * skip it as the truncate_inode_partial_folio above
> +				 * should have at least zerod its content once.
> +				 */
> +				order = shmem_confirm_swap(mapping, indices[i],
> +							   radix_to_swp_entry(folio));
> +				if (order > 0 && indices[i] + (1 << order) > end)
> +					continue;
>  				/* Swap was replaced by page: retry */
>  				index = indices[i];
>  				break;

Could this code infinite loop if a large swap entry crosses the START
boundary instead of the END boundary?

When shmem_free_swap() returns 0, it could be either because:
(a) The entry was replaced by a page, or
(b) The entry failed the boundary check (base < index ||
    base + nr_pages - 1 > end)

The boundary check here only handles case (b) for entries crossing the
END boundary:

    if (order > 0 && indices[i] + (1 << order) > end)
        continue;

But what happens if the entry crosses the START boundary? If
find_get_entries() returns a large swap entry at indices[i] where
the entry's base (calculated as indices[i] & ~((1 << order) - 1)) is
less than the truncation start point, then shmem_free_swap() will
return 0 due to the "base < index" check. The code will then call
shmem_confirm_swap(), get the order, check if it crosses the END
boundary (which it doesn't), and retry with the same index:

    index = indices[i];
    break;

The next iteration will find the same entry again at the same index,
leading to an infinite loop. For example:

- Truncating range [18, 30]
- Large swap entry at [16, 23] (order 3, 8 pages)
- indices[i] = 18
- shmem_free_swap() sees base=16 < index=18, returns 0
- Check: 18 + 8 > 30 is false (26 <= 30)
- Retries with index=18
- Loop repeats indefinitely

Should the boundary check also handle the START case, perhaps:

    if (order > 0) {
        pgoff_t base = indices[i] & ~((1UL << order) - 1);
        if (base + (1 << order) - 1 > end || base < start)
            continue;
    }

where 'start' is preserved from before the loop?



Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B7F1DD30CDB
	for <linux-mm@archiver.kernel.org>; Tue, 13 Jan 2026 22:09:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 280566B0088; Tue, 13 Jan 2026 17:09:19 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 230286B0089; Tue, 13 Jan 2026 17:09:19 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 13C4B6B008A; Tue, 13 Jan 2026 17:09:19 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id F3D636B0088
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 17:09:18 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 76E551A02C2
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 22:09:18 +0000 (UTC)
X-FDA: 84328332396.11.EBBDEFB
Received: from mx0a-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
	by imf21.hostedemail.com (Postfix) with ESMTP id 70F1B1C000E
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 22:09:16 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=meta.com header.s=s2048-2025-q2 header.b="UeFR/cmf";
	spf=pass (imf21.hostedemail.com: domain of "prvs=9473463a0e=clm@meta.com" designates 67.231.153.30 as permitted sender) smtp.mailfrom="prvs=9473463a0e=clm@meta.com";
	dmarc=pass (policy=reject) header.from=meta.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768342156;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HbKNjJaO1cGUCeRepTM0eTzzK48zgICKB6rrGrUwt9E=;
	b=H9Yk9a3tciLC+iR7ZJjLkNYLV5T4SiGzOK5cpa0G3tM3NgGKWO+WRsweTy7TbifYYZcjEg
	BBmRT8SpyxQ21YrKmdL5T1Ra6KUmTmjN99b+MCa3HMtJzZVjZGHxVgfuMDxo6gNKWtn7w6
	qo6lOAfUkmrqcYSfB3Z6UQtjGW2GoCI=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=meta.com header.s=s2048-2025-q2 header.b="UeFR/cmf";
	spf=pass (imf21.hostedemail.com: domain of "prvs=9473463a0e=clm@meta.com" designates 67.231.153.30 as permitted sender) smtp.mailfrom="prvs=9473463a0e=clm@meta.com";
	dmarc=pass (policy=reject) header.from=meta.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768342156; a=rsa-sha256;
	cv=none;
	b=fc6F3XgmVV58zHr3rn87MM/WcY5v0+yUYx/9KrCRIOPJdZxEq6gf7KxUHl+SrwxsuWKOIY
	XWXWBqvxG3S4cosQ3SX8JQZRyNzZsJEuQOL2k7bjmcm9pA+eNV80Shv91CST2YPRVmjfty
	P5VLN8ili9Ys3WTb9mqLHXz5UjBVKgU=
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
	by m0001303.ppops.net (8.18.1.11/8.18.1.11) with ESMTP id 60DLXVAV2738866;
	Tue, 13 Jan 2026 14:09:11 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=s2048-2025-q2;
	 bh=HbKNjJaO1cGUCeRepTM0eTzzK48zgICKB6rrGrUwt9E=; b=UeFR/cmf9T+o
	iP5iXBbEUMomk1D46SRSu7KKO9LC87SrzkqbuZIkwKIzguargCRgVRUPvPAh6pkU
	K1ACfW+dxGNDwzuRLkSxl6oUU2oTuz3oNIntCKjHSmPW5bwCb98OKuCx9GKOuWSr
	EyhDOZNfFQ/OHijEC89oMzyk8ufoS+hcNnbX7Fnc86JYENYjZvzVrn4glAdF0D+8
	68S7aeklgstqNi/2UCLcUnTlBqtPdjklIxXlsH+wnoatZayHxTlUm9o71DrFDCY9
	5WQJzVQWg9nrv7Rghke84sULb+/ZvQ0OexZHb6RLmfjfJXXsTru2ztTg7BNfO25E
	2rok1Huk6g==
Received: from maileast.thefacebook.com ([163.114.135.16])
	by m0001303.ppops.net (PPS) with ESMTPS id 4bnx2qg8sn-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
	Tue, 13 Jan 2026 14:09:11 -0800 (PST)
Received: from devbig003.atn7.facebook.com (2620:10d:c0a8:1b::30) by
 mail.thefacebook.com (2620:10d:c0a9:6f::8fd4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.2.2562.29; Tue, 13 Jan 2026 22:09:09 +0000
From: Chris Mason <clm@meta.com>
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
CC: Chris Mason <clm@meta.com>, Andrew Morton <akpm@linux-foundation.org>,
        David Hildenbrand <david@kernel.org>,
        "Liam R . Howlett"
	<Liam.Howlett@oracle.com>,
        Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport
	<rppt@kernel.org>,
        Suren Baghdasaryan <surenb@google.com>,
        Michal Hocko
	<mhocko@suse.com>, Jann Horn <jannh@google.com>,
        <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 2/2] mm/madvise: allow guard page install/remove under VMA lock
Date: Tue, 13 Jan 2026 14:08:51 -0800
Message-ID: <20260113220856.2358195-1-clm@meta.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <cca1edbd99cd1386ad20556d08ebdb356c45ef91.1762795245.git.lorenzo.stoakes@oracle.com>
References:
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [2620:10d:c0a8:1b::30]
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTEzMDE4MCBTYWx0ZWRfX3HTgfC1bFz+W
 XaSrb78bYD/J2y9w9eM2ZWlDZDSXVnTIHExA+8M3dTx72waMbnQ/h53G4vj90rJwJzP3Z1SV/HF
 qlj4/m3I/yXD4IBQCg5D1O8Eq+762RNmXKpec6Qdjb1jLA+EdBNaaVMMKSBLsrgexKi9bgs7CzY
 VBFIAjR7se87rYe3hYy/yVjklNPdzgCIWO0Rue3ZiB+fCuM6M8UinwKRxhJirQM9via+JxYHXdX
 BNGFuOj3X3jTECniKAgVlJfRng3fQprsMYKQUiEHbk6Qy6sLF6dr7NSVU8kRNLGRLUo5dg/rHuw
 suTcDcwsNr6VE+9HbHeFPfrYwq+VuhQ0+xqU35nxbyFVS/LbXzAhVUK9SYhlzrmi3O3B3uGKtm3
 DnVGzWOn3ui3Ig0cgM71qBUxnDrhYoP9gu1aiudlXDh6qxwEYqkq7CztS/x6PLkKe2RIdAPYPfx
 0dl1Q2xCMuK+GSPPEuw==
X-Authority-Analysis: v=2.4 cv=S+bUAYsP c=1 sm=1 tr=0 ts=6966c287 cx=c_pps
 a=MfjaFnPeirRr97d5FC5oHw==:117 a=MfjaFnPeirRr97d5FC5oHw==:17
 a=vUbySO9Y5rIA:10 a=VkNPw1HP01LnGYTKEx00:22 a=yPCof4ZbAAAA:8
 a=eayTNkxmwnh0hqTbl_MA:9
X-Proofpoint-ORIG-GUID: 9wuHkkCUaWIdRwetfIQUywQLUMkXutII
X-Proofpoint-GUID: 9wuHkkCUaWIdRwetfIQUywQLUMkXutII
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2026-01-13_04,2026-01-09_02,2025-10-01_01
X-Rspam-User: 
X-Stat-Signature: s9us4jkzqfphomtkizupwg5qum8q9y7r
X-Rspamd-Queue-Id: 70F1B1C000E
X-Rspamd-Server: rspam04
X-HE-Tag: 1768342156-123672
X-HE-Meta: U2FsdGVkX18RKgias82y4O2cwGxc4hKWzoscD+i9RSRuHI0n0AZt5Ss9pt3kanAO15dSYQ48G8p1RY566h3GyuqBzej5/k0Hz98pw9FOSyEXX9wwLEpEyEUm3QPq4Cbpt1CMTWzYzaMXxkS5E1MOtCCF+D0/MMVHBNUVmakOrbQTwe7CaDd/QJKxmhqI6+ONZltYRmss1bzaiIeht0Sm8KQyniSssmwFTmmbo36ItRgMo0XB6ZuCVoRlnhzVFJH6g6uh8zLw9gwX6A2kk7RG3Xb0UQv6++WdoAdskLu5wCJonXwi5uz76cEQ70t7xMRRr9PG6qc7E52MUVG/iQONUsAqIOrQLiSH+ACImTiDr/Tpd+AjRVbo8W0jAuJb4/HjxLlSMXFnWA9dh/9GwkuNlxynD2wTQlx9LCKFeEn5OXL7KpiFQ9WBf6/h4RR7531pqlwjzkoH0cNjbm7YD6ocLgB9PHRcY2EyRnvPjWyUMsFBT2Ha0cUd+ABVekAsKGLbj7yuvEWbG2fVDOI9Zd1654tOS3TStYzY+AYF2cGaYy6lMqTt2GdprQMjOQjy2ztBa0jBKLFW2s4U/HKa2xYS+4MA26B9LiHVejr/ANIg7sSZDqHr7E6alwSdcoTP+YJ+RRjbl4fTsi4CaZyPfw1Xbkh7c0MSjX0sq4BFGW0ZFubmkZoE5HHMVSe+4t9lz/JV9PB7KxjeZ2nrNJqHm19eGEWEsppjXZgNtcKB8Nq+haW9uV6z2fGAmaly1Bc8ws7Qd4nC08nTz3GOgvOWqLOWSQ4BFwiYE8tL8e1rGeKTLHgN7TMNqckDIX8gxFL4c4X5MQLirXws0UCoQgCF+bcp4idKCER/m0brjEEp4razAJx+uMEqPylKjYkHrsNEJlvdQv5cwSr6MugH+AbgrM/wMu5jiMYQWXpubnuwDVYptWA6v165GbKwdVxqnPUlVZ7tQnCPfvt7Oth/W/wqC2j
 OyIljeEa
 oZ0OOH35t8uApO1p/MTJ1doPdJqDsxVYanC8jEkBWn7KACQA9mRnX4yLW0lnGDx8SD17iDuSFXte+pZp8NNbboGJ2qjY2/d8W1MQHr8kWZ1fenKgROvkdyIFfDnYgr36Q16YHjZhVoRxmThFKb9cTWaAHz/+JHyrKQwShc3f/I1g9HV2qZSnoaiFU2IPtUUJC2iwsgI7QbVqRMYpaTvzjx3M4p43AL/IpN7vOuHSuufcJt2UMj1+eoJIW69O5adO2qAmy1Zv12FNByd9Q+dSrOSkX/e5rTz9y1uXC9ArDzgi/dleflEVKxbf3h0pqv710LjX1JLgSnZqTl4TT+GLjxEiz4wZegwpsqAN2S0J3ENu3hbc=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 10 Nov 2025 17:22:58 +0000 Lorenzo Stoakes <lorenzo.stoakes@oracle.com> wrote:

> We only need to keep the page table stable so we can perform this operation
> under the VMA lock. PTE installation is stabilised via the PTE lock.
> 
> One caveat is that, if we prepare vma->anon_vma we must hold the mmap read
> lock. We can account for this by adapting the VMA locking logic to
> explicitly check for this case and prevent a VMA lock from being acquired
> should it be the case.
> 
> This check is safe, as while we might be raced on anon_vma installation,
> this would simply make the check conservative, there's no way for us to see
> an anon_vma and then for it to be cleared, as doing so requires the
> mmap/VMA write lock.
> 
> We abstract the VMA lock validity logic to is_vma_lock_sufficient() for
> this purpose, and add prepares_anon_vma() to abstract the anon_vma logic.
> 
> In order to do this we need to have a way of installing page tables
> explicitly for an identified VMA, so we export walk_page_range_vma() in an
> unsafe variant - walk_page_range_vma_unsafe() and use this should the VMA
> read lock be taken.
> 
> We additionally update the comments in madvise_guard_install() to more
> accurately reflect the cases in which the logic may be reattempted,
> specifically THP huge pages being present.
> 

Hi Lorenzo, one more flagged by AI:

> diff --git a/mm/madvise.c b/mm/madvise.c
> index 7ed5bedb8f8ef..2a165e9beb5bb 100644

[ ... ]

> @@ -1173,8 +1180,13 @@ static long madvise_guard_install(struct madvise_behavior *madv_behavior)
>  		unsigned long nr_pages = 0;
>
>  		/* Returns < 0 on error, == 0 if success, > 0 if zap needed. */
> -		err = walk_page_range_mm_unsafe(vma->vm_mm, range->start,
> -				range->end, &guard_install_walk_ops, &nr_pages);
> +		if (madv_behavior->lock_mode == MADVISE_VMA_READ_LOCK)
> +			err = walk_page_range_vma_unsafe(madv_behavior->vma,
> +					range->start, range->end, &walk_ops,
> +					&nr_pages);
> +		else
> +			err = walk_page_range_mm_unsafe(vma->vm_mm, range->start,
> +					range->end, &walk_ops, &nr_pages);
>  		if (err < 0)
>  			return err;
>
> @@ -1195,8 +1207,7 @@ static long madvise_guard_install(struct madvise_behavior *madv_behavior)
>  	}

When err > 0 (zap needed), zap_page_range_single() is called below
regardless of lock_mode.  If lock_mode == MADVISE_VMA_READ_LOCK (only VMA
lock is held), and the zap range contains a THP PUD mapping that requires
splitting, the call chain:

  madvise_guard_install()
    -> zap_page_range_single()
      -> zap_page_range_single_batched()
        -> unmap_single_vma()
          -> unmap_page_range()
            -> zap_p4d_range()
              -> zap_pud_range()

will hit mmap_assert_locked() in zap_pud_range() (mm/memory.c) when
pud_trans_huge() is true and partial PUD splitting is required.

The assertion will trigger a WARN_ON because only the VMA lock is held,
not the mmap lock.

Is there an additional check needed before calling zap_page_range_single()
when in VMA lock mode, or should this path fall back to mmap lock when THP
is possible?

> @@ -1715,9 +1763,9 @@ static enum madvise_lock_mode get_lock_mode(struct madvise_behavior *madv_behavi
>  	case MADV_POPULATE_READ:
>  	case MADV_POPULATE_WRITE:
>  	case MADV_COLLAPSE:
> +		return MADVISE_MMAP_READ_LOCK;
>  	case MADV_GUARD_INSTALL:
>  	case MADV_GUARD_REMOVE:
> -		return MADVISE_MMAP_READ_LOCK;
>  	case MADV_DONTNEED:
>  	case MADV_DONTNEED_LOCKED:
>  	case MADV_FREE:

This change moves MADV_GUARD_INSTALL to use MADVISE_VMA_READ_LOCK, but
zap_page_range_single() called later in madvise_guard_install() may
require the mmap lock for THP PUD splitting as noted above.




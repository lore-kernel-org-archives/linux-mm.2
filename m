Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4C20BD25B44
	for <linux-mm@archiver.kernel.org>; Wed, 28 Jan 2026 11:50:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B463E6B0088; Wed, 28 Jan 2026 06:50:14 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ADC796B0089; Wed, 28 Jan 2026 06:50:14 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9D55B6B008A; Wed, 28 Jan 2026 06:50:14 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 8E2D36B0088
	for <linux-mm@kvack.org>; Wed, 28 Jan 2026 06:50:14 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 4552FC224D
	for <linux-mm@kvack.org>; Wed, 28 Jan 2026 11:50:14 +0000 (UTC)
X-FDA: 84381204348.18.1C2067A
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
	by imf19.hostedemail.com (Postfix) with ESMTP id 2C00D1A0003
	for <linux-mm@kvack.org>; Wed, 28 Jan 2026 11:50:11 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=meta.com header.s=s2048-2025-q2 header.b="Dlw/8eqd";
	spf=pass (imf19.hostedemail.com: domain of "prvs=048834cd31=clm@meta.com" designates 67.231.145.42 as permitted sender) smtp.mailfrom="prvs=048834cd31=clm@meta.com";
	dmarc=pass (policy=reject) header.from=meta.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769601012;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3sR3yOvEanCCv4kAGiE4ro9nNhwneHcuB6+V0EWWMj8=;
	b=ZGPFgNFpFExL3/PIN1AiNCTjTq4aYr09iPAPDeYHzp+C35YZG5i5zF3eZr+NKSmeBE5+4C
	FuJ4/NZ7KFqMd8Lr49TAKKMj07Mek83TaH1wic1VlCJNRg2YY1eqLSr4PpMRXXOPawYDQC
	3Bw/MwMKapyshvoaTy1PXNpJuCMz8X0=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=meta.com header.s=s2048-2025-q2 header.b="Dlw/8eqd";
	spf=pass (imf19.hostedemail.com: domain of "prvs=048834cd31=clm@meta.com" designates 67.231.145.42 as permitted sender) smtp.mailfrom="prvs=048834cd31=clm@meta.com";
	dmarc=pass (policy=reject) header.from=meta.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769601012; a=rsa-sha256;
	cv=none;
	b=R5RIcLvDttzBs5vC1zDLEbFs0mVqy3tM3nMSMD95H/M8FS+tNYrYGkX17tBzBvpgIgC2L8
	eTLqr71TcVeUrUA2VNW3TAMPvomz7gDZ9nq/nOHg6uNfBP34YzDkl9Hhu877lNVm5VQwTk
	/go6rwmW6LrAD2NH7+XoFT2eSvDxS9A=
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 60SB1KUd3541108;
	Wed, 28 Jan 2026 03:49:55 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=s2048-2025-q2;
	 bh=3sR3yOvEanCCv4kAGiE4ro9nNhwneHcuB6+V0EWWMj8=; b=Dlw/8eqdQHt5
	7lZZcxaOCvV89JZWGSEnAzDPiOB4lcLaRFhrCP2j42KEuACZC5V03WbpWGTCCxSW
	IBh6pQOzWn3+elIlQSRE0tNJxq+iGZ0Cc4UpGDNMvdOazF5FgkQJa8YUyyXzQOnp
	X2BYEbYuFjaMzsjxnnz5IOSV+W6TIlUP8WCg9h7et4D3gnVmvDN+oupW8eqf+mzs
	/SSAYF2Wz6rMk7/vHEasSxQPx1MFbyr6QHTKojVgznPGJ17A+hFJFOzwbd9bAnev
	zsaRgAn+UR9RZpRu5XvVeMtJmp8kTK4sdYiiHvM4hjZpc6GeoYmmeFnJjUlreFK/
	x3fosorduw==
Received: from mail.thefacebook.com ([163.114.134.16])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 4byfjegygc-3
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
	Wed, 28 Jan 2026 03:49:55 -0800 (PST)
Received: from devbig003.atn7.facebook.com (2620:10d:c085:208::7cb7) by
 mail.thefacebook.com (2620:10d:c08b:78::c78f) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.2.2562.35; Wed, 28 Jan 2026 11:49:53 +0000
From: Chris Mason <clm@meta.com>
To: Baolin Wang <baolin.wang@linux.alibaba.com>
CC: <akpm@linux-foundation.org>, <david@kernel.org>, <catalin.marinas@arm.com>,
        <will@kernel.org>, <lorenzo.stoakes@oracle.com>,
        <ryan.roberts@arm.com>, <Liam.Howlett@oracle.com>, <vbabka@suse.cz>,
        <rppt@kernel.org>, <surenb@google.com>, <mhocko@suse.com>,
        <riel@surriel.com>, <harry.yoo@oracle.com>, <jannh@google.com>,
        <willy@infradead.org>, <baohua@kernel.org>, <dev.jain@arm.com>,
        <linux-mm@kvack.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v5 4/5] arm64: mm: implement the architecture-specific clear_flush_young_ptes()
Date: Wed, 28 Jan 2026 03:47:43 -0800
Message-ID: <20260128114936.72280-1-clm@meta.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <9d866a2644051e13a41ef4d6ca3909c6e1f9e229.1766631066.git.baolin.wang@linux.alibaba.com>
References: <cover.1766631066.git.baolin.wang@linux.alibaba.com> <9d866a2644051e13a41ef4d6ca3909c6e1f9e229.1766631066.git.baolin.wang@linux.alibaba.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [2620:10d:c085:208::7cb7]
X-Proofpoint-ORIG-GUID: b-m_VTtyJFGqx8Wk26KZECPrbXwG6GcU
X-Authority-Analysis: v=2.4 cv=dIerWeZb c=1 sm=1 tr=0 ts=6979f7e3 cx=c_pps
 a=CB4LiSf2rd0gKozIdrpkBw==:117 a=CB4LiSf2rd0gKozIdrpkBw==:17
 a=vUbySO9Y5rIA:10 a=VkNPw1HP01LnGYTKEx00:22 a=SRrdq9N9AAAA:8
 a=MGNFab1UUB5QvBCUKlEA:9
X-Proofpoint-GUID: b-m_VTtyJFGqx8Wk26KZECPrbXwG6GcU
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTI4MDA5NyBTYWx0ZWRfX7lAz2qDJSew2
 nPUAe+g6Z2mDxCV6iqhRxBR+FrVuJKpCVLSJrX9QYEqZoWuEAKmCiT8NGqqPNAEDXiG0l6dwcGH
 tYA2FsxvjOp76ILWLbMqFAsSfrlKo62kNrI7hDZmMY8i3Rk+hv3I8g5N/SUcVTuRJE1uQoACz2R
 9cBFQCbPzRdTZHxICyfkrlICfIKcgDO5Sl/f0gFTBjKHb+awUq/ePePMsk0T5YARDS10ZsPUFnU
 rt91CLPk5cPNWdg4ZSaeEJrvsxHzrQ5u+s3ICRYPCeyc2XQgbBfOYTB725Fpwj+TUc2S++Kot1e
 Ne+dehN/vT655V4UV0WHTYW8dLCaUlgYoR99LqCTo/v3PuGCbZ+RlGldZsVdgwXLsVWXqRStvSK
 LB541OK5uB5KTJPKW4GLU9HOVLePhWX7lFet7JQNWgBJ/KkMtSnRmevznFz1JsFn20Ar6PKaRKn
 2grUTFFJPf9Uv+i980A==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-01-28_02,2026-01-27_03,2025-10-01_01
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 2C00D1A0003
X-Stat-Signature: h8hs4ruk63c6ohyz4ejzianp86f7ah9f
X-Rspam-User: 
X-HE-Tag: 1769601011-995080
X-HE-Meta: U2FsdGVkX1+sW/nFFyQuaxbMU19hDKoc+fv0wBR24sAT5/ambi3lwnWePhgHLhRHaDJ9cZ7ztwNww9NZ5OJJLdyq3dspe6QBetwQQTofZkSvvUMqxoUWWqdvbmtsxaRYVs/zPvJZpyqwLQnzPRhBYIBiWYCg5zI3cd2zxSQFU/qyK9GHBqKMmf7GTzJ1lPPo0whE2j4rqlLw0rFkSNhQbL63Ia11y4T4tlV/55sbLKv7Yu7v9palVb+XvXQwqgMRbqzaNA6IXNg6F6Gqr9XY13FaxIpyOU0AvkrLfi10PG7fti1S5xOo7NUQ50+RkRg4dtCg6griZL+QvS/Z4W28Z5oyZjFhTLrfsx2nznit2EKU1Vz8Kb8bqfnQcKzycB4ZoflOjPYUQ+6PvIyPuxzRX/oZFahD5wjmWyWdbVWFlW/UBtc/l6Rlzalte6RWLCiRBmhp4a4Qf0F2uS2X28NE/WWI2JW21d17rObvEGTLo39L1IRW9KwqPoG/c7KgBYwn4thXfU47ViUc+LVx74AfB6aiKG15/6G9WhQDiXsO4JROfPMi0UZgGrSyTRXse60Gg8WtGHJHhkJtZ8XvjiG8px9T9BkqwIZ+sLGXn2WXyFJPNq1l8oBievZkY2WknwKvWPI7cRjQqLt/7cIl/Fx0kgzB4TB7Ar/7/gwuU8ZzJjKTjxb8S/aCNDy/FvSLnDvJZMNpaVyEae7R2+7E82IfZu/PbAcpU2UEcN6DHFZYczGIsUxf13+MfK4pbtapguHOaBmJR+1x4LDpSSSOjNJn1PyD+geiVhQPb417JnXsQJBmNCyspDFBhLJvLFaQagekNHXomtEOPdn4n87msZTj3aZxbuEFPmzTfKEmIkUsfXFy51kF3voN+sIi9VdrGysCwTNZ4J3QqwUyq7umDxWSY+woaD1pKO/bgkvWSUjWPVq+NnLEikjkq73mjAYDPdcMBOxwv3ObJShOlpLNVl4
 Nk/6hhjJ
 0pIP1S7l+UWVgrVx5ir6vwNCUdDU/WGZnGXqlbIWr08BJn84v+7Ym1jUlo1JJUIxU9lHW7zuA3Ai2JE8TGOtUPguIuRDNBUpfb4QmRdxm39u6dsTYRCqs9VL/XnpRd8uf+JWjC366npetfnWP5LD8Xo5ie91LeBiCwjpO20oCySaXJqbSqRjBy78Zfnk6yu4aFp88tj3HCgjy9BcvG0MNH2iFSGNuckIalySys7470Qpfq7xe6Ibzcr3v/PCfsT4KYBBxlwvhAqtBXmYcsWcCoekJHEmpj9nblJgQKMqCKim7X0L+/Nyf5gY0rOiZWRUSJzBiCefj9Uty+PF1Tj6RLNqUVL2ZB6jmiVBDEPmbwJZEUDiougQmKp3kp+sNwi7zrGuP2Oz1MDmQwdKVtqdQjnk89oxH3iPGqsCThczpz/6bCNXz9F1m5S+fZeIR1Sw9XZ3z
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Baolin Wang <baolin.wang@linux.alibaba.com> wrote:
> Implement the Arm64 architecture-specific clear_flush_young_ptes() to enable
> batched checking of young flags and TLB flushing, improving performance during
> large folio reclamation.
> 
> Performance testing:
> Allocate 10G clean file-backed folios by mmap() in a memory cgroup, and try to
> reclaim 8G file-backed folios via the memory.reclaim interface. I can observe
> 33% performance improvement on my Arm64 32-core server (and 10%+ improvement
> on my X86 machine). Meanwhile, the hotspot folio_check_references() dropped
> from approximately 35% to around 5%.

Hi everyone, I ran mm-new through my AI review prompts and this one was
flagged.  AI review below:

> diff --git a/arch/arm64/include/asm/pgtable.h b/arch/arm64/include/asm/pgtable.h
> --- a/arch/arm64/include/asm/pgtable.h
> +++ b/arch/arm64/include/asm/pgtable.h
> @@ -1838,6 +1838,17 @@ static inline int ptep_clear_flush_young(struct vm_area_struct *vma,
>  	return contpte_clear_flush_young_ptes(vma, addr, ptep, 1);
>  }
>
> +#define clear_flush_young_ptes clear_flush_young_ptes
> +static inline int clear_flush_young_ptes(struct vm_area_struct *vma,
> +					 unsigned long addr, pte_t *ptep,
> +					 unsigned int nr)
> +{
> +	if (likely(nr == 1 && !pte_cont(__ptep_get(ptep))))
> +		return __ptep_clear_flush_young(vma, addr, ptep);

Should this be checking !pte_valid_cont() instead of !pte_cont()?

The existing ptep_clear_flush_young() above uses !pte_valid_cont() to
determine when to take the fast path. The new function only checks
!pte_cont(), which differs when handling non-present PTEs.

Non-present PTEs (device-private, device-exclusive) can reach
clear_flush_young_ptes() through folio_referenced_one()->
clear_flush_young_ptes_notify(). These entries may have bit 52 set as
part of their encoding, but they aren't valid contiguous mappings.

With the current check, wouldn't such entries incorrectly trigger the
contpte path and potentially cause contpte_clear_flush_young_ptes() to
process additional unrelated PTEs beyond the intended single entry?

> +
> +	return contpte_clear_flush_young_ptes(vma, addr, ptep, nr);
> +}
> +
>  #define wrprotect_ptes wrprotect_ptes
>  static __always_inline void wrprotect_ptes(struct mm_struct *mm,
>  				unsigned long addr, pte_t *ptep, unsigned int nr)



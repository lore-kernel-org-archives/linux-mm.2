Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CB5D4C88E5C
	for <linux-mm@archiver.kernel.org>; Wed, 16 Sep 2026 13:39:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E739C6B0092; Wed, 16 Sep 2026 09:39:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E4BA86B0093; Wed, 16 Sep 2026 09:39:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D62F26B00A1; Wed, 16 Sep 2026 09:39:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B56476B0092
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 09:39:13 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id D47561C28CB
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 13:39:12 +0000 (UTC)
X-FDA: 85219731744.29.5279CE1
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf15.hostedemail.com (Postfix) with ESMTP id 10709A0005
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 13:39:10 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=JSfXnglF;
	spf=pass (imf15.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789565951;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uB6n1K3LCaEVCrqPWgjTTDdDBNC3FP5MLx4HfaiqvKA=;
	b=zf9by2SaHPuUB2iV2j2WrmV6cAw4rx6ZXmoppWL6KkYc5QYvvn0gx48itI40bKT3a6NaPK
	0N4cDFanFREcLk6ABZsh8KmSC19wMRnE28+fJwP/844Soutf/Lid0kKjKnxKNiMALd6/IS
	s2/yRbxGbvj/jha+nDqQx1oqhR1vKkc=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=JSfXnglF;
	spf=pass (imf15.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789565951;
	b=d0ylhfwmSpiV6NBuca/ursHLB2UOQzWD5hMKBaTN+KQ5/iybcu9oBuwW28q8lc5kyLL4Ur
	CJPhfcJl1RoLpqnTY7dh8RhvJgwi0/3MQdKiGuk2x1wQ51aNd9U+gFEzdZf2DSgEjjRe69
	CeD1AbBA7MDGjFG2H1fau1WSpijY+nw=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 3453B4145E;
	Wed, 16 Sep 2026 13:39:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5EC81F000FF;
	Wed, 16 Sep 2026 13:39:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789565950;
	bh=uB6n1K3LCaEVCrqPWgjTTDdDBNC3FP5MLx4HfaiqvKA=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=JSfXnglF0N3PtBmzFz52fRvW/pwX6FqS6EyRHa2wwVpaoCOJBaGFPgMuWG+ODgm57
	 uzUdyTc9y4b7iiFWbatxIpIKXgXXfxwYzyQf62fwn3dreu18PdoYBOJSapkhTnjMx5
	 kYYH3g0YTT1WsS1k5JiV0UL8DU8Ekyk3frjNZsRlkvymK+oJQR6gA7VLvdusvGKExm
	 gGfbrjjQ0+6m1CVxfALv14O9PRixN0G9mH9svEYusD7Xf13kvHRIzI5kMdKdjusYlg
	 JpqDCF6yF5H2tRUsQEnvE2Qy9MofukMIlRcMhuOGPkWPxNdv6jpUs3JEUqS3QBoJTc
	 lLdZgRRvkC2dw==
Message-ID: <ef85271a-a1a3-4b9b-8c99-c1f871a13c6b@kernel.org>
Date: Wed, 16 Sep 2026 15:39:05 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V2 04/14] arm64/mm: Route all pgtable atomics to central
 helpers
To: Anshuman Khandual <anshuman.khandual@arm.com>,
 linux-arm-kernel@lists.infradead.org
Cc: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Ryan Roberts <ryan.roberts@arm.com>, Mark Rutland <mark.rutland@arm.com>,
 Lorenzo Stoakes <ljs@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
 Mike Rapoport <rppt@kernel.org>, Linu Cherian <linu.cherian@arm.com>,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org
References: <20260907035030.2839978-1-anshuman.khandual@arm.com>
 <20260907035030.2839978-5-anshuman.khandual@arm.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260907035030.2839978-5-anshuman.khandual@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 10709A0005
X-Stat-Signature: ia394547yb571q7gto88a33rzxyefcbx
X-Rspam-User: 
X-HE-Tag: 1789565950-317847
X-HE-Meta: U2FsdGVkX187LVD0itQ6dd1FDhdKeJreJZux0jKtSjMcfZDSoBluW7ZmZ/KxfjxWm9lShg88VQ9I6+bePKKYX91EE3crGTYkUSdtDlLO01Khz37Yx2CUZe6dJzXcuQhD8bDIZ01WLKk8xHpCZ+99L0BZ+2x1L2rnbJZn2i31QCiyj+4vIR081hiz6RwLrUkWIeyp8AOUzMrbV3pl3QTgvDebo9Aq2DuqnwBzqPqttzJaQKxbE6OSFXRJk3S1M6NY0OBK/4Pr55VoRw1UgW/93yheM4y67g1ESWcN2DTuNICElr1zVPVC4YxWKoZH0ZopUgC8h6E6QKiCFVYZnMZOvrXIquX0Wd5HgqElBU6tEj5CijzDpDpxdtq7w9ANO7VVP6sgmLrkzqa23RkOChuohgp+fPXydkoKdyCVe0m6ER2pItkr5r8pj5rlZXgWYLD0i0AX+esLuCg/s+YO7OfhwcndFmxRH/HH4suK29zb4rqfDyg10f8eCDC1D/fmVRv2fkRK9ZyFA+kct645h91bV26Xt//YYN8sTSfBmXUOQ3FbxXdtEnahVaHZ0mdtOxm6TfTvrPbDWQ7vzs3tuaYwsiDUZezcVmoyqehy9fxTPdjoNFJk6msxzOfw21GeQ2dMP+UIDyOiTWmwqTdG7D+MMNsMdzROOJ316+7aHAj+Tn+9VglSLgr3P/5FMt+nlyTOzaHKW2io3neKqTPAYh/QuH4jyqnUneIDkH5w9vtxitk7bUiw9VIn03hgc4iqN7EMI3Tqo+5ZM6Ff8jutiqGZRgTNXFBGwr54nLrSYZKm1nLc27gOhXx1q/+c8KGs4zrgUmu8tB33VFQZ4xZ+ko2lTOWte7DW1hjyPegQHFYh0fbBlEoUPfmE+1ygBSXhNXOVj1sDSbnIK4g6ppo2tWhEebW1fBvbWNjqM2mf2z74Bh9GaJ9y2f3+JNMrYT8HpFnnsqDbjybXNmESI5B5yX+
 kKXUavaw
 aiFZ/cdaoIPMYFlzxHtTnKYYdskWYQUCzL/qH8sPJ87Sibp4ETV4J9+3jX8ATRh6RtV9ez1OjDv4Xrv+74W9lw/zk5SMsss5ZBXBHmeZeoWsNZLRPqonsqvHmArXcAKtUqBciK8EKjyEI/M6UjO7JlVxI8koqjXDHcJhmD376x3UPoDonenAMggOL2FlpvB9NEphixo/SqtHoaALG7Q2gwc8M38yutUN5wMsJhDxtUKrqDeawTSh5UeTISwGoALnDDK05/EyFfLPbIvvn5RJp/6q+spEbO8mbXzqi1aK9i3Np7hB2VnRuGPDrqLToQ2Orhx0iGjE/CGZFYFuK7+BJV28dCefScxl3gYmVEat4o4xhJJPjEV0F+4m5zfOcHtrOvORMcs4st56/lJGJd5XjrW5+wg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/7/26 05:50, Anshuman Khandual wrote:
> Route all cmpxchg() operations performed on various page table entries to a
> new ptval_cmpxchg_relaxed() helper. Similarly route all xchg() operations
> performed on page table entries to a new ptval_xchg_relaxed() helper.
> 
> Currently these helpers just forward to the same APIs that were previously
> called direct, but in future we will change the routing for D128 which is
> too long to use the standard APIs.
> 
> Cc: Catalin Marinas <catalin.marinas@arm.com>
> Cc: Will Deacon <will@kernel.org>
> Cc: Ryan Roberts <ryan.roberts@arm.com>
> Cc: Mark Rutland <mark.rutland@arm.com>
> Cc: linux-arm-kernel@lists.infradead.org
> Cc: linux-kernel@vger.kernel.org
> Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
> ---

[...]

>  	case PAGE_SIZE:
> @@ -1400,7 +1411,7 @@ static inline void ___ptep_set_wrprotect(struct mm_struct *mm,
>  	do {
>  		old_pte = pte;
>  		pte = pte_wrprotect(pte);
> -		pte_val(pte) = cmpxchg_relaxed(&pte_val(*ptep),
> +		pte_val(pte) = ptval_cmpxchg_relaxed(&pte_val(*ptep),
>  					       pte_val(old_pte), pte_val(pte));

Indentation goes out of sync here.

>  	} while (pte_val(pte) != pte_val(old_pte));
>  }
> @@ -1438,7 +1449,7 @@ static inline void __clear_young_dirty_pte(struct vm_area_struct *vma,
>  		if (flags & CYDP_CLEAR_DIRTY)
>  			pte = pte_mkclean(pte);
>  
> -		pte_val(pte) = cmpxchg_relaxed(&pte_val(*ptep),
> +		pte_val(pte) = ptval_cmpxchg_relaxed(&pte_val(*ptep),
>  					       pte_val(old_pte), pte_val(pte));

Same here

Reviewed-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David


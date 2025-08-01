Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A09FAC87FCB
	for <linux-mm@archiver.kernel.org>; Fri,  1 Aug 2025 07:21:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 20C336B0099; Fri,  1 Aug 2025 03:21:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1E34A6B009A; Fri,  1 Aug 2025 03:21:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0F9956B009B; Fri,  1 Aug 2025 03:21:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 020F96B0099
	for <linux-mm@kvack.org>; Fri,  1 Aug 2025 03:21:40 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 806EF1A0FFE
	for <linux-mm@kvack.org>; Fri,  1 Aug 2025 07:21:39 +0000 (UTC)
X-FDA: 83727343518.12.2CA50CE
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf03.hostedemail.com (Postfix) with ESMTP id 11DEC20004
	for <linux-mm@kvack.org>; Fri,  1 Aug 2025 07:21:36 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=ElAxXGFE;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf03.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754032897; a=rsa-sha256;
	cv=none;
	b=Bfkpnbim355KoWSR5gk4g1jKMTnoGcg++vBNMVUIxH3iQdPhBRb/Ow44U7ZlAeZYe595wE
	JFSmW0bTz5FVPoN6zS+sEM0NUTo4ig+48fhhcp8OO6D5WX0eBujVQomqZ4m6MeAAYQ8YHz
	uNHJqOgR1RWTj6JJQqYUnR9ED5HHtAU=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=ElAxXGFE;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf03.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754032897;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=k8xuj1kmMyeJuw59snTbgeRO/erNCN9chpx+Tbf452o=;
	b=f7oguKSIuWrY9tGllpelMRCGEUbD8WwilJovrTbgjocnDH0Ka4G7Xx4K/96oxF3j6asU8w
	rck1DGV93M/eHar8SK2IPsaZ5kItluf8yv57FOhr3vRFnAaXRpFfFvpGnZe8H1R1Jx3gzF
	SslknHPBceJtJv3IlBwzTy7XTy4a3r0=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1754032896;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=k8xuj1kmMyeJuw59snTbgeRO/erNCN9chpx+Tbf452o=;
	b=ElAxXGFEO4dILXuE7l+bruLQ3ng4p66DEJhY/p2/Kx2eRc6Pb+spwVyMm6BSt2sHMlMO0M
	NJ2dTo8VLmelJb5lgmvaHbucwvUw3xGQGwSbwbRQlodtp0jyc0xp+8MM0ny6OoYyhegX6I
	roefq/usztZ+TeXAqgmpAj6ewWUGwno=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-575-erSEZW6pPVyzf4DfvV06nw-1; Fri, 01 Aug 2025 03:21:34 -0400
X-MC-Unique: erSEZW6pPVyzf4DfvV06nw-1
X-Mimecast-MFC-AGG-ID: erSEZW6pPVyzf4DfvV06nw_1754032893
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-45867ac308dso2853955e9.2
        for <linux-mm@kvack.org>; Fri, 01 Aug 2025 00:21:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754032893; x=1754637693;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=k8xuj1kmMyeJuw59snTbgeRO/erNCN9chpx+Tbf452o=;
        b=amo3CVoXZFOwjFlwS9YLzX6BdDbaBNvJt65Ua7tJxdX6D8L3NC2Xh9Dd/C3C5LJMg1
         4gXwXkujukCFW66rEyWutgzaJlEA0Zke+6Jp21tJ5DIpARrQ61UUwxdaXrNL2cCIMamI
         92xv+VzEe3LUYkYJ5cTAto2N/P8NUkmhTi8OrHlxuICMV0D3wXT3auS95Ie9M0lGxPHv
         2bSadrWi9Q7fyRXqPO9IIUb4MbxCubo58812jTiNhXwFlptLATwdmbb7hKVdfGMiN21n
         TaMaKyiFb/fEIrO9pSOfGTnLUdiT5fpD1pmDj+EPhcs/FIY8nGl4y+qEqArFbWu+r9K+
         3RgQ==
X-Forwarded-Encrypted: i=1; AJvYcCULdBmSaglU+k1zs+ONPB8CV50MLYqYFuAJXG3XGCxasWkrYJPeKc8HdDdg5DoJ+rjTtXiPo8tmgA==@kvack.org
X-Gm-Message-State: AOJu0YzB0anOMod1m6FFCppqCi1JsrXbydApNIIesYbjM4X6vAcIM/C7
	ILw13JM+0NJmuOw9mYyG98+af7M+Ai+CtitBOMsQVN1LHuXg4uWiQUVXrJpCNwugtbkKtrn9M8B
	uo4Tsnegjr0ekeWdYs/JwVqWKW5fSneUgbVqoPH2i1BwV/cpCzpMp
X-Gm-Gg: ASbGncv97+GL4B/IOmH8xZRTpXGZ4dotRWVBM5qJ4fqe887zAMGtGRX0ztMoBpX1ylE
	4RrhyInGeItn5myzanzt1dTxNsZHs9KvQn+GdCh8UjwHpE5qxFWEKZj90twy+cu2wkSbkzExBVc
	X47J0h5WeRZusXc/3NO14lkSIzxMmhZA8KWUwdVWJbDEjXSgYCLFxi92XPtL/VVvH8lM5Po0Eo0
	TtgvswQVdupvsZWikohDrvUmeF7w9vW0Cr+Su0SUlIcm5iDdNfMBiToPWMZa++lMRDPEirgPcbl
	dVUXYY/OKrxoUq9h4lIavRV5CmCYbH0+MLt72WNI6DYPyjOdS+qzvKr0/X/E1MsUbkYUjBkMqzV
	gOY1ZISr5VT0l9p5fG3vU9iyjZybh0o+Jj/QNnTDes4ladsoph+h12g6ynt3k0bAv
X-Received: by 2002:a05:600c:c166:b0:43d:abd:ad1c with SMTP id 5b1f17b1804b1-45892b95290mr88213705e9.6.1754032893000;
        Fri, 01 Aug 2025 00:21:33 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGGnbWL+2Z46Bx7ewYm1BnyM3pVCWPyXd8fhCoLsU/ONtKYTdZJvEp9DlxsOJ15wsyICfx0Kw==
X-Received: by 2002:a05:600c:c166:b0:43d:abd:ad1c with SMTP id 5b1f17b1804b1-45892b95290mr88213445e9.6.1754032892516;
        Fri, 01 Aug 2025 00:21:32 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f20:7500:5f99:9633:990e:138? (p200300d82f2075005f999633990e0138.dip0.t-ipconnect.de. [2003:d8:2f20:7500:5f99:9633:990e:138])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3b79c4696c8sm4788092f8f.55.2025.08.01.00.21.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 01 Aug 2025 00:21:31 -0700 (PDT)
Message-ID: <d2b6be85-44d5-4a87-bfe5-4a9e80f95bb8@redhat.com>
Date: Fri, 1 Aug 2025 09:21:30 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/1] userfaultfd: fix a crash when UFFDIO_MOVE handles
 a THP hole
To: Suren Baghdasaryan <surenb@google.com>, akpm@linux-foundation.org
Cc: peterx@redhat.com, aarcange@redhat.com, lokeshgidra@google.com,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 syzbot+b446dbe27035ef6bd6c2@syzkaller.appspotmail.com, stable@vger.kernel.org
References: <20250731154442.319568-1-surenb@google.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 g3eXuA==
Organization: Red Hat
In-Reply-To: <20250731154442.319568-1-surenb@google.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: MzewNU7FeU7eLKs1jJtPvvrF6fpl-CaTwsHZq27_F7k_1754032893
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: hziabfcsfiokcu9cjoodsmywz4xysz3p
X-Rspam-User: 
X-Rspamd-Queue-Id: 11DEC20004
X-Rspamd-Server: rspam02
X-HE-Tag: 1754032896-414423
X-HE-Meta: U2FsdGVkX1/80/go4+nO37WQbo2XA9j3NSXHA/YVBdHKPK6O4H/qqhPsUnoTgBsaekRYjQ/KhF4TIzxGlZxHQ3DL9EhHJwtAsF0c3ULBu4dgmKIeQeEaLcfZhstg/eZYoky7iYGrL3NDq7ehbmWhomdHiQemCzSHUavXQ4MCOWrwpZ4rcelctM7k2icEUCDnsP1AcffHoJ/qLnGTH3VBpz40mbOyIU77HJ0MHFQFRdCP9on6UBBlrClz+9+ix8EGUjXVWhyOZLCmjfHRWiAGGaxFHh/LSkWXEDQAWaYbAwwIOmIICBD0Lv7Pbo/LzTBQivrYKiq61d28noPXdtQkY8QU5zSteK0Fna3rrfJH4BNJnQV36amBTU+OCUfLoAK4+6DMjaqHE16N9zZNFEG4u0tpPOc5Jz17Fob0hMZ0zsYMewP8juuu183OK0Bj3r/tMi4M1vCdbOgO7VYjfGf5+sHVzE+/6zQ4SGPsg+G+OYbYGgO6JIQxM/p5J7EvtuKQn5V2o2r2Bz/DskdO7kKL0mt1NQaIR0clQ2ryaLYv7kpJkqT69bAooF0xFvVtgT8U23VnoGfTAusMAyR1jNCA4uDzkfmoPSh24U9Sbz/hIxHWy3UOjsNLlQ7J5MiGU+aC3Is4+AWtT74V91ZqESzdZIhcpFM6h2YlhSTNfLxU+xaxmdFcfMb35Eaz75ILQvF3KRs+zAHxrzE+Am06PfVlca1WhcfMV6BycEfggoj2GXAkc8RvgUHaBfZA057t5aXPSk/3B25lzYYVOzKcyAiuU+QV3EQ4nmFZyMUANOTg2Ny1r2/oRUdvR+10Pjx/MGjRcLA/KtR0UpDncQvho5srGSjHRzi9JClwVI29cx9awtlVau9XhxA4iJSqnuTPSB8IjvTmOwPA70SQf11Xg16SsPNm6xuY8Rdl9g4nEO6J46/Sm3JKqVj3sQK8QYIzTkI7Yis7CHiZLlfLHxQG6IP
 3RV0XKPP
 VmHvKLrdrEqFQ8yh46OGbWiKJaA9vaUdZaHUVOcCQHvU9+aFaU4+xGyCeMmH1Rg3y6lSaVyixBU1Z3TD3lZx8jneWfXjHItW8XY5XDqK9p8NkE64Sl4DAkx3zspmGoMPKfgzUtfO37sTMdr737sp4BNvG4QhomrG8EvdliEZdr+gNm3nXHcT0ETfMF9Er2oemjE5Nuer/oNuX7DCKZmvh35OI5tWNRgU15AOiLn1mnNwOGyzQvX1ad+ftpzk+0vLMoUUq1KIibCJIwUxpQC4YwDxJS8W3zjPT2Ndin8oLsEIkhWabrEiNlPmA2ddMMN6b10kdzTpSK4vd1X/NthFKPCvm8IvjCE6YfwwMRYvco+1U4mNKiHTMmBLL+X3Y0zSjC45E0jfdXNoVqSxocc8J8v+7dQGG2CfR29ih+xMzyE98hakv2Al1DOPowF3i64rlqumJIY1P4wKr5AwACtRNfR3cCWEHoJJNO/TNv0lHpEbaqlUy4QdhbqWw2p9ZNnyJ2fSfPptxQZaEaYb5XG2X2+cig0SxuB/hHMU1rcj2QOUxDRlD7wu9qYZBH9HEm+XGuecjg7oQIe3wf6UEv5Mc0BktlxyYqsalC++KfysKUPmrn59/S/SjKXg7e2MMYAhBVDL85GOvGAud1TCP5+KiO9pdGdwmEPnM48+ybZJ2g676zJchEd9/Qaf+4KDce6oNLatw8IYSeHOLp5s=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 31.07.25 17:44, Suren Baghdasaryan wrote:

Hi!

Did you mean in you patch description:

"userfaultfd: fix a crash in UFFDIO_MOVE with some non-present PMDs"

Talking about THP holes is very very confusing.

> When UFFDIO_MOVE is used with UFFDIO_MOVE_MODE_ALLOW_SRC_HOLES and it
> encounters a non-present THP, it fails to properly recognize an unmapped

You mean a "non-present PMD that is not a migration entry".

> hole and tries to access a non-existent folio, resulting in
> a crash. Add a check to skip non-present THPs.

That makes sense. The code we have after this patch is rather 
complicated and hard to read.

> 
> Fixes: adef440691ba ("userfaultfd: UFFDIO_MOVE uABI")
> Reported-by: syzbot+b446dbe27035ef6bd6c2@syzkaller.appspotmail.com
> Closes: https://lore.kernel.org/all/68794b5c.a70a0220.693ce.0050.GAE@google.com/
> Signed-off-by: Suren Baghdasaryan <surenb@google.com>
> Cc: stable@vger.kernel.org
> ---
> Changes since v1 [1]
> - Fixed step size calculation, per Lokesh Gidra
> - Added missing check for UFFDIO_MOVE_MODE_ALLOW_SRC_HOLES, per Lokesh Gidra
> 
> [1] https://lore.kernel.org/all/20250730170733.3829267-1-surenb@google.com/
> 
>   mm/userfaultfd.c | 45 +++++++++++++++++++++++++++++----------------
>   1 file changed, 29 insertions(+), 16 deletions(-)
> 
> diff --git a/mm/userfaultfd.c b/mm/userfaultfd.c
> index cbed91b09640..b5af31c22731 100644
> --- a/mm/userfaultfd.c
> +++ b/mm/userfaultfd.c
> @@ -1818,28 +1818,41 @@ ssize_t move_pages(struct userfaultfd_ctx *ctx, unsigned long dst_start,
>   
>   		ptl = pmd_trans_huge_lock(src_pmd, src_vma);
>   		if (ptl) {
> -			/* Check if we can move the pmd without splitting it. */
> -			if (move_splits_huge_pmd(dst_addr, src_addr, src_start + len) ||
> -			    !pmd_none(dst_pmdval)) {
> -				struct folio *folio = pmd_folio(*src_pmd);
> +			if (pmd_present(*src_pmd) || is_pmd_migration_entry(*src_pmd)) {
> +				/* Check if we can move the pmd without splitting it. */
> +				if (move_splits_huge_pmd(dst_addr, src_addr, src_start + len) ||
> +				    !pmd_none(dst_pmdval)) {
> +					if (pmd_present(*src_pmd)) {
> +						struct folio *folio = pmd_folio(*src_pmd);
> +
> +						if (!folio || (!is_huge_zero_folio(folio) &&
> +							       !PageAnonExclusive(&folio->page))) {
> +							spin_unlock(ptl);
> +							err = -EBUSY;
> +							break;
> +						}
> +					}

... in particular that. Is there some way to make this code simpler / 
easier to read? Like moving that whole last folio-check thingy into a 
helper?


-- 
Cheers,

David / dhildenb



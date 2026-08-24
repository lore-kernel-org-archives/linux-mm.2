Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AD75CC5DF81
	for <linux-mm@archiver.kernel.org>; Mon, 24 Aug 2026 15:45:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6EBE76B0095; Mon, 24 Aug 2026 11:45:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6C3DB6B0096; Mon, 24 Aug 2026 11:45:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5D96B6B0099; Mon, 24 Aug 2026 11:45:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 357D96B0095
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 11:45:16 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id B9B7C1201A8
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 15:45:15 +0000 (UTC)
X-FDA: 85136586990.07.1DCCC7F
Received: from mail-pj1-f48.google.com (mail-pj1-f48.google.com [209.85.216.48])
	by imf10.hostedemail.com (Postfix) with ESMTP id AF1DDC000A
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 15:45:13 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=sifive.com header.s=google header.b=AGuxWBg4;
	spf=pass (imf10.hostedemail.com: domain of samuel.holland@sifive.com designates 209.85.216.48 as permitted sender) smtp.mailfrom=samuel.holland@sifive.com;
	dmarc=pass (policy=reject) header.from=sifive.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787586313;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QEtJVtkW7q375yAi3A0GskrIJ2s9H0yJ3yupt0Y509Y=;
	b=rsTYwKC+sCNkVYEbP2rxkqD9X+zvBHk7inQWSqy0d7BhWqliaZ/CWWiiZOFgqWO25GN3FP
	8JvQFbhcTtzcVDFqKT5qMRXiGogd91Yka4rgHCuiLeOD/Ql84MKQ3QfW650WTtDES4+fGK
	JEMoogXjThNf6p9esyIiVYDSGoQkknA=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787586313;
	b=irHgFXVC6uhUXuGB7bG4euAQ/HnjEXTXLLzmH58oXVC2RBs4V+WV9yDDAWVDqh0m9Qg17/
	9vQ9cd0lco311okRlDTjFMx6TzNoZEVyQts53HAbY9PZTFbNJSr8LLY5zaKB7OIMtFpaxG
	Bh67dSkE8lPnSF+5zlnIn3H2BZdSR0o=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=sifive.com header.s=google header.b=AGuxWBg4;
	spf=pass (imf10.hostedemail.com: domain of samuel.holland@sifive.com designates 209.85.216.48 as permitted sender) smtp.mailfrom=samuel.holland@sifive.com;
	dmarc=pass (policy=reject) header.from=sifive.com
Received: by mail-pj1-f48.google.com with SMTP id 98e67ed59e1d1-38deea72eebso4186463a91.1
        for <linux-mm@kvack.org>; Mon, 24 Aug 2026 08:45:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sifive.com; s=google; t=1787586312; x=1788191112; darn=kvack.org;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=QEtJVtkW7q375yAi3A0GskrIJ2s9H0yJ3yupt0Y509Y=;
        b=AGuxWBg4FtpOfBgiaK+dL1aDjRm/E6TS9QBRaBarnD5LvVXN1JtVAgUwCSn8f2sT+L
         u3dhwRqrV2L5BZm4IF2fy5bhaexBNajk4k1/pT4OEVvrmhkSApd0eS6jc+YYpxosJCjT
         WunY4lVlwQQYfLcaMlUfuwYkELAOG3BGOY5sg3l3pyPcm4PFB77TMPzuzTkCBHbFim0F
         RJtrCoA1PBwnm90sqp8+Lhuwb+tUu0NeNVTJupg2SrY5KD3zlx1AnAmv2f+Bx8xKLFH2
         QO8wk//gMsa7X6HG2sUFHBOg1BfLdrpRDqnCkP8JmctT9ZP0UcuGRmry0Q4umU2P94jV
         ZL2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787586312; x=1788191112;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=QEtJVtkW7q375yAi3A0GskrIJ2s9H0yJ3yupt0Y509Y=;
        b=OjxfJfJ8NW7TmuOIocP/iRvS033lJw7HeWs2Xl/v//B1C2CEBhjXbvPFe7y5lTVTM3
         7+fb4zSoO2denOwlFyRwLH4RnkJODxMlaMXfc925spOvkTrwZKAs8SZ7/ioIv0dAKHj8
         ua+A/2/BIbBPMim+zeIoNIJF8TOetCMZE+BMnTvjgZQm8SbH59NMKXXLyFcKo+ct4eZf
         vYavCWIaPEwBm/1xZTZ847OgkK6v97kkzdSCwsr9a5PecOxqswmFDQHa9YLEMa+0YYN/
         Ld2d8YpwBZUa+Akcm5OWGE/UdcCbb2MOJBdUSyraiB7iXvcplScCxfqEplkI+O1ox5GM
         5PMA==
X-Forwarded-Encrypted: i=1; AHgh+RoT/IdURT76/QaW0FsgqVRji2XxlCGzh0uCqlyX8pp/zer8URNcrZ4EDT+LHwSWkMO/5GzUKs5pZw==@kvack.org
X-Gm-Message-State: AFuF++m0CxOELAo3Z/7kuTwWFOptFWluJkz16Zk/1BJNV9fR7y9FpADl
	rlr/kLiLQ9nIPM6h8wDLaVgz9d7ZPNUEVq+a3QRwJezD4+SRcwxKNN/GO4HxQQVoSNM=
X-Gm-Gg: AR+sD13n/150/LHt0jS5OaBOZP3JaeGl7SHQCPsN40w0a4F0diApTk4S5GWM6nPw1GD
	abIvUHzS6qSM4yNOHsMLBpHt2uIQCkPo8DJOO0AzaHCrLZyQ7KPhKSs8pEBrsDPBMwrw5FRMran
	1wTOMqqp3qNb+JydPepCvcsUsQdAn6TrxOefnnmwvvUynbTU51dnXEe1oNhVfH/ihRNBuE0uVDA
	2iv0ExV5xWT92XPiyyjcrszVnF0E40AUkWBJkk2/QOkE6+S2RPvSZ/pTIiUQRt8DbzwO6ZBpX0M
	rf6zPZJgnCuN9RucNbsd8RB3r6E9qtYPwPj2yuPDjHIz1vT2epP38+OwZEzohpe20qsACoV8SFp
	4YzTefaByL/Eq/0zQBONb/5+NjZtUI7p/taHmvTUC2LiiApK/XYDPDF3ft1zK9NrURRSAyzYr1d
	BTj/naLiywDx6AnKGdNOBrFXz/f0+nK7/0dMuEsRIgTGk/QmSB9GT4bK25yEg8pDOGfqvC3MQpe
	Q8bliL3ZvJScPE=
X-Received: by 2002:a17:90b:5867:b0:395:4de4:92c8 with SMTP id 98e67ed59e1d1-395df4dcdbcmr39252435a91.15.1787586312489;
        Mon, 24 Aug 2026 08:45:12 -0700 (PDT)
Received: from [100.64.0.1] ([165.225.242.163])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-39645b7ff6dsm23611a91.10.2026.08.24.08.45.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 24 Aug 2026 08:45:11 -0700 (PDT)
Message-ID: <029cfde8-74fc-4437-bc18-b1b53d44cab2@sifive.com>
Date: Mon, 24 Aug 2026 10:45:09 -0500
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC V3 1/8] mm: Make ptrval_to_str() generally available
To: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Yoshinori Sato <ysato@users.sourceforge.jp>, Rich Felker
 <dalias@libc.org>, John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
 Helge Deller <deller@gmx.de>, Huacai Chen <chenhuacai@kernel.org>,
 WANG Xuerui <kernel@xen0n.name>, linux-alpha@vger.kernel.org,
 linux-snps-arc@lists.infradead.org, linux-arm-kernel@lists.infradead.org,
 linux-csky@vger.kernel.org, linux-hexagon@vger.kernel.org,
 loongarch@lists.linux.dev, linux-m68k@lists.linux-m68k.org,
 linux-mips@vger.kernel.org, linux-openrisc@vger.kernel.org,
 linux-parisc@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
 linux-riscv@lists.infradead.org, linux-s390@vger.kernel.org,
 linux-sh@vger.kernel.org, sparclinux@vger.kernel.org,
 linux-um@lists.infradead.org, linux-arch@vger.kernel.org,
 linux-kernel@vger.kernel.org, Lorenzo Stoakes <ljs@kernel.org>,
 linux-mm@kvack.org, akpm@linux-foundation.org, david@kernel.org
References: <20260818040041.1891769-1-anshuman.khandual@arm.com>
 <20260818040041.1891769-2-anshuman.khandual@arm.com>
From: Samuel Holland <samuel.holland@sifive.com>
Content-Language: en-US
In-Reply-To: <20260818040041.1891769-2-anshuman.khandual@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Stat-Signature: nxxtd3s51bcq8gpwg4z3psueb4qpo4km
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: AF1DDC000A
X-HE-Tag: 1787586313-571008
X-HE-Meta: U2FsdGVkX1/2o/W9HEXax1TIo/EQsl4MlM61A+Q6KF1pC6FVlD6u2KzkgYO4ngthGKDvGQ0L4F53S5oN67cNcDm0taJPv+p98BMdrEEwEyQwgAl07uJau0vKLHtqeGrRbbio51GvIusnxOGkp14Y+qMIikmV0rzDvbvKglX03LdYy9t98oTvgY4HoZWL7WTsuaEwdp1Rn2tR01VzyfvW+0r8l4yFV3w5vXlsviz573Fb+wIJSvfP6m7eF4hdqBvdDVjlSduCQDpWNQgyLe8JJR9n14I8Jw0cwAvWwRr3ojbLdJCeg94vxDu/uxUIZy3iXeNrnznwEGLRk312BjMSv1hzeu2a05oqg8q/cyOp9QeLFAjIC+3GCltY+QCoLl/KP/o3TmdEGEJVuWYKjmDU7XxY8DBsvEsQOSNtyW1zNf/ERvSgXansTsi6iZ/cCa/SjHvyV8HRteBL31Y55RC0LeWRoYa1r8KZRtPTDthzcTBtz8tyq+ShKctmSzthuZ59HVL5j6TFL9MyFb4zfu9CpFCZCFptbKKQqhDGvV/OTucaGGmD+Y2MMFy74oE6TQXQYSn+a2280fnZCFY2lCHLxZWqtaFtqaNwBxkPFEmVjQRCT/uE4mH0WznhZMZr2zNazyHzbShfurTKYRQRm3r5PUeP+nXb8ngPrmTDrqxgqOjLM07V/HqaNs7cOroQpyIXtaZDf2S7qCsaKTi1bdXy84ZZLnQkrWDtwYmgOpL7Fc/XkuYlF4Sp3C+yA8HNcMnLBhDZRLGrCwtWZ3JRoLS0W35O1RcWpVktc+68z+J/drbcjNd0SFaAvxivPRwbZKtm/+qPdWyTvPI0QFZYKXvrXtIQymGar1f6/P1sVaAdSblnkdnEpygqmWiGqwisv+w0q3RhumDJs4eudj+zLfhljoAZ2tNAKs28epMulC9dIvUGYgASf0xKc1KBh2/W7gR6NcaLvUkH1+LfqsrSzUt
 xST3pE6u
 cvQMB6bGJc4KeaLhheq9IT3yRsNQxch9eqOR6EIFA7AVMRow0B7q6uYQrP0t6fkY+bdRUOfii8clqChRCcNqKVxA1KhXFIjsxZ+1owpYrDz4YtbDdR1L6dmtCv+dJ3h8mRWnqnylLG7VfP/ptA6Fvxfrr98owtsVi41yvaeQEqf6R2Uf4ot/9zzRqICx72entdJWMM0401AMI2JYLi2LBY2SSpMYdEplaE2NsFdrSlUe/Asoqrax4vZHyHtN6olvih4Y5ckXwEqAC9j/7hp2chRlcuy5ceXg0Ind74rj/vsfY7sSxkwej23bLXwlKa55dsM+onuixwCnG9po35SK9g4s4M5ViSmZbG1t3ncH92vOgMyahTNS4Af4CL1U8H4QNTa/olfkObN8/cks2L4v+zr67NY2UdmuBobd2BTjiJ78bYOLr4fok3r//WUMKMpPziBLviwIQuYn4grFtt4NxWKuZSyPNwP2i8iHeviqeWa/uWPdpv3JU5z3+dxqXOvidAUpGnJ3GjLEXziBk++TYyMMmbp+HcizkpY34rEmsenu3LRF70/BdaFWHw0ADJFUwxRzif7pKO0xc7IUWafHmuaQfvFSZDCQ+x+zNfs7yAnjUNktpr0BT9dDjHc26p+IqLNwwjNZpZOwlkkE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2026-08-17 11:00 PM, Anshuman Khandual wrote:
> Move ptrval_to_str() inside a header thus making the helper more generally

Typo here and in subject: ptrval -> ptval

> available for new users which are being added later. While here, also move
> another related string size macro PTVAL_STR_MAX inside the header as well.
> 
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: David Hildenbrand <david@kernel.org>
> Cc: Lorenzo Stoakes <ljs@kernel.org>
> Cc: linux-mm@kvack.org
> Cc: linux-kernel@vger.kernel.org
> Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
> ---
>  include/linux/mm_types.h | 15 +++++++++++++++
>  mm/memory.c              | 16 ++--------------
>  2 files changed, 17 insertions(+), 14 deletions(-)
> 
> diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
> index b18c2b2e7d2c..a5b514e55dd7 100644
> --- a/include/linux/mm_types.h
> +++ b/include/linux/mm_types.h
> @@ -2001,4 +2001,19 @@ static inline unsigned long mmf_init_legacy_flags(unsigned long flags)
>  	return flags & MMF_INIT_LEGACY_MASK;
>  }
>  
> +void ptval_bytes_to_hex_str(char *buf, size_t buf_size, const void *entry, size_t entry_size);
> +
> +#define ptval_to_str(buf, val)								\
>...


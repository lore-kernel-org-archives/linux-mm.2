Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 16A23D374B9
	for <linux-mm@archiver.kernel.org>; Fri,  5 Dec 2025 23:29:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5D5B46B00B6; Fri,  5 Dec 2025 18:29:20 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5AD856B00B7; Fri,  5 Dec 2025 18:29:20 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4C31F6B00B8; Fri,  5 Dec 2025 18:29:20 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3CCC46B00B6
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 18:29:20 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id E5D96B8768
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 23:29:19 +0000 (UTC)
X-FDA: 84187010838.04.7ADF1EE
Received: from mail-pf1-f178.google.com (mail-pf1-f178.google.com [209.85.210.178])
	by imf02.hostedemail.com (Postfix) with ESMTP id F02FC80006
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 23:29:17 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=rivosinc.com header.s=google header.b=BxNwwFWn;
	spf=pass (imf02.hostedemail.com: domain of debug@rivosinc.com designates 209.85.210.178 as permitted sender) smtp.mailfrom=debug@rivosinc.com;
	dmarc=pass (policy=none) header.from=rivosinc.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764977358;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=m859Pz85Fe3NafYsTdo+q5V0iu/zXgcB/nZgW0VxOeI=;
	b=SzWQINbFtp9UqUR6un4Q7y0JbQA/EI2+Nj/aC3GbRM8qINFqvWwqSdKBb3TYIvaZ+yt7AF
	wuROFjLCtndm3OGhJwpiwcKI31h49OhXdYqpi+83As17sygcpEl3lkiIlEOh1wg/n2R0Lc
	zaRbbD+AtZLyxI86zNODYWy+Apz+pvA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764977358; a=rsa-sha256;
	cv=none;
	b=gNAcoNanyyzyblxYF6X3RVNRtVw3p5tBLOBM1hT7qutFqfRTSTSiDfpUmhtOmC3UGfmz/O
	FPdYe6MTgGct2JpCmDTZPDOgZ4mmnU1RpQfabFCjSGdzGG5xbiYTpalnHQwwflkj9DZTcS
	bk3eoxn9gJoiYE9w//GsZQMPpKO39Lg=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=rivosinc.com header.s=google header.b=BxNwwFWn;
	spf=pass (imf02.hostedemail.com: domain of debug@rivosinc.com designates 209.85.210.178 as permitted sender) smtp.mailfrom=debug@rivosinc.com;
	dmarc=pass (policy=none) header.from=rivosinc.com
Received: by mail-pf1-f178.google.com with SMTP id d2e1a72fcca58-7b8bbf16b71so2984825b3a.2
        for <linux-mm@kvack.org>; Fri, 05 Dec 2025 15:29:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc.com; s=google; t=1764977357; x=1765582157; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=m859Pz85Fe3NafYsTdo+q5V0iu/zXgcB/nZgW0VxOeI=;
        b=BxNwwFWn2aJklJ/NZXosnkPWm0yickLAiC1H5shZWje7iLVjJpoi1mFtsqSzdtiqPP
         fMjMeWXbZGmNbVTkDkpGM/TTkOqpnSw5ZtzqMq7AiEObAgdfe5o4VWxOS7+K4odIpJHd
         6oySX5Wa/v7GwZrczTRG0YWcpusVZMZ0VYj2hpRgCk4hjUpOCxWWEBI0Pk+OuxZud9Yo
         gmDZON1Hb5RZ7HnIx6bS8u/3+LOjIDC+fHLMQefpJ9df416VPmM8isFX1QAxF+iu5lVU
         pk6C/SONM31B906xZTldKIFuQptoUAIi/wZoN2qVzFgC04S/Og0zGd29XmlOW41swJkG
         RwLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764977357; x=1765582157;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=m859Pz85Fe3NafYsTdo+q5V0iu/zXgcB/nZgW0VxOeI=;
        b=ZLAGCgcPu1tJpzSjWiyoyNfK/HEq6g9hS8YnM+GjtlQ/u0WGfq+efDKrug8V8Y4Iil
         93Guo2J3dZ08i297ZpOyQ35sThYh9/Q2vstDSsFSZSySdVU4F7/2NAF7of2OSA6Kmwmb
         hCWyeVHnxZl0wI6HOVLJ2kbJYV2CTF2EdXmceBzspU3yVZizcYlQgQ4EgAt8JqKnnoHc
         ga7+GymUJE1+GB0AD3MOJrdzdaxvLB3+6los0VRBdj1i/eCV7fS7PZkpBpiZNpUCeivo
         tV5LUd0aLykayQwhZWxF8UlkEFz/ndGKXWFBJyMTAMm0+Y76e9OLXLsf0+gVmWSanyZB
         4H2g==
X-Forwarded-Encrypted: i=1; AJvYcCX09Br5XWBX0F1tYeIuGK4TfeEsovvmfg8y2Ls0NvA4AbT5GZ3V6PDnK1rLFGaGFsoBZ4pV0kaayA==@kvack.org
X-Gm-Message-State: AOJu0Yy1MbiYoJXE8QhgfeCk3R9SDMcRcFo9h+aZoQCLdsjL7wuzuaJB
	ZOPC6WseVyxAzom62H+Z5ulh+9CiS0zp7hPgdCHFiP43dUHd37qyZSsMcEliCGfZkc8=
X-Gm-Gg: ASbGncsQYXVV8ItpghZiTMUkH+pEuT9h7TNKjQ3N2Q4viJThATRx/1eB1cK56ljlgO7
	b1kT0NQbcafKHGdtaBeWqcJS9Uria+cmK2zovB/p6DYS5NEFLudy/18B+w/wA/QUBFkOyi0qifh
	04ZiXpNly2M/y5648Lpk7bZb9qcSx4BLM+qG5t8EUa/nsScvrIAwLEsYPU6+89lasj6u7uu5VIG
	Sv4GQfPSBtKM9zYGYcbMNhwg2mt75VJYrxHw4oAMoiGBG6WoBcfS6nM1x0shcC2wR8jSJY9uDYW
	vn8fs07XT2goO4vWZ0NYXk7LSUd08zu6/pkQgiLDXyKq3coL5MU4rcDq+NdG4q+rEFpdwYkNmrf
	woEPPdE7mHWj1e5RMu/dwr+MqDJi9uzPLaLArGndvpOPhTuDEst++ICb/xydEWBYmWHrW+LKIaT
	LsrK+3+I/RPlzwU/CtlbVUx3M2MEDi2es=
X-Google-Smtp-Source: AGHT+IG0PS99KFFmyGmoZ4EZkx7PjzgoWxSynADwEB0PMGoZ1tOJUc0gMelNMUgjpR2OcW1nhmhbdw==
X-Received: by 2002:a05:7022:24a4:b0:119:e569:fb9b with SMTP id a92af1059eb24-11e031662c8mr594295c88.10.1764977356505;
        Fri, 05 Dec 2025 15:29:16 -0800 (PST)
Received: from debug.ba.rivosinc.com ([64.71.180.162])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-11df76ff44asm23779652c88.9.2025.12.05.15.29.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Dec 2025 15:29:15 -0800 (PST)
Date: Fri, 5 Dec 2025 15:29:13 -0800
From: Deepak Gupta <debug@rivosinc.com>
To: Krzysztof Kozlowski <krzk@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
	"H. Peter Anvin" <hpa@zytor.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Paul Walmsley <paul.walmsley@sifive.com>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Albert Ou <aou@eecs.berkeley.edu>, Conor Dooley <conor@kernel.org>,
	Rob Herring <robh@kernel.org>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>,
	Arnd Bergmann <arnd@arndb.de>,
	Christian Brauner <brauner@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Oleg Nesterov <oleg@redhat.com>,
	Eric Biederman <ebiederm@xmission.com>, Kees Cook <kees@kernel.org>,
	Jonathan Corbet <corbet@lwn.net>, Shuah Khan <shuah@kernel.org>,
	Jann Horn <jannh@google.com>, Conor Dooley <conor+dt@kernel.org>,
	Miguel Ojeda <ojeda@kernel.org>,
	Alex Gaynor <alex.gaynor@gmail.com>,
	Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>,
	=?iso-8859-1?Q?Bj=F6rn?= Roy Baron <bjorn3_gh@protonmail.com>,
	Andreas Hindborg <a.hindborg@kernel.org>,
	Alice Ryhl <aliceryhl@google.com>, Trevor Gross <tmgross@umich.edu>,
	Benno Lossin <lossin@kernel.org>, linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
	linux-riscv@lists.infradead.org, devicetree@vger.kernel.org,
	linux-arch@vger.kernel.org, linux-doc@vger.kernel.org,
	linux-kselftest@vger.kernel.org, alistair.francis@wdc.com,
	richard.henderson@linaro.org, jim.shu@sifive.com,
	andybnac@gmail.com, kito.cheng@sifive.com, charlie@rivosinc.com,
	atishp@rivosinc.com, evan@rivosinc.com, cleger@rivosinc.com,
	alexghiti@rivosinc.com, samitolvanen@google.com, broonie@kernel.org,
	rick.p.edgecombe@intel.com, rust-for-linux@vger.kernel.org,
	Zong Li <zong.li@sifive.com>, David Hildenbrand <david@redhat.com>,
	Andreas Korb <andreas.korb@aisec.fraunhofer.de>,
	Valentin Haudiquet <valentin.haudiquet@canonical.com>,
	Paul Walmsley <pjw@kernel.org>,
	Charles Mirabile <cmirabil@redhat.com>
Subject: Re: [PATCH v25 00/28] riscv control-flow integrity for usermode
Message-ID: <aTNqyVVGy9_XjFGt@debug.ba.rivosinc.com>
References: <20251205-v5_user_cfi_series-v25-0-1a07c0127361@rivosinc.com>
 <d45808b5-44c3-42c6-a54c-3a13606ee39d@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <d45808b5-44c3-42c6-a54c-3a13606ee39d@kernel.org>
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: F02FC80006
X-Stat-Signature: 8p4huywj3si8dg5o3jss1hm74paj4oe1
X-Rspam-User: 
X-HE-Tag: 1764977357-711248
X-HE-Meta: U2FsdGVkX1+6wpnrk0Ml/ckNim7snvrZkDZa9v7FCF+WkjZUw+8yd1z/uM2Jyzodun30Z9lHlQa33IZoSER7GVqLviEPfBLzjxHJXxucgxM3j9dt4FQAuLSTZ4CRRj/ossIDlXu91nukn4niM3zh3w30kgrsilINAvbN51Oh9oAHXeOdhX+P2d/SruadaTnGGFFoGEHVJ4Ysc2f2bade9cfdPolX9tEAVmZdqo+qX06veS/kNDgH1JpIj/G8eMBC4LRLBWvvn7fUXr8MSqG7dl1aG7F02jBs0DM9INeETTU4mwHTRS8/6IXRZzUHYJzOKB0DhHcqFYKyhjP134fYLqrL7IVvNKtaM+gt6om03KYIuXzvuXozXm+FheMTNkfNtJocPF+AHTfSP8H/LS2qsVPDVBq4hK5dedo60EZpyI5EB9lJIsPK/nTEEJH7X/Ekvbh6bbjvNndHPxpph/96rnYDCYRT3z4PY1rwo6httfhbMwtbnkaiaJgrt6ydQSQVQlccSjU/HNgVOPomM7puhkO1jj9OmnS7i/vu/rZsy+LQ+LoiqH/saO9HcvzXFgIKDp0YZjOdiVZquDnv92L/5aXYXLqkGYw0DRSlfvhszkE7WdYVRhvr2Ck/PTrcqD7de13YYdnrPF7PjZ4IEEjMOOXeoykMW6KMFw8SEyNd+Mxv19DNOz5gpAF2pZXKvRqs97giGR3uluOYVqPz4H5LlZaPnJXL1SQYFPIYrMrj5PxPab44fs6KoRBwA3fw7Bi9ZUgoeogpWA09ZbzVLIe++HkO+5+SGYSjajBZW89pqkjFjh1dzHXLN1x9RzpsQdZCfpckzL06I66k1gNVZrhffC5DGvJhJ7YDw/vkH6PuF9RfI90HXObRLHxELYMXNyK7BsjR2QUaoJL5/ugunjhVDJQaAyXiAwo/TnZlEP3LMOCsYpcX/GMaipy/wX0Dy6KqPoDiA6o41oX3iWY1Jx3
 oFxhkjIt
 4Pibu6c8ErGvw74T10dopPlJWDY9rqv/kCUrEDaRoh6mAUIHXouU16E6ZTzzLH95EdCdDVIXtBPhElsSYG+EtfyhYHnCAjnB/pqoDkMmehs+zhKf4ARfQrTocVQVrciXXoILk4MbZhWishqlcLpV3DPEKxIHNrTPEPqPgUNY4Yrek2QcJdZbXXbZiJM1MI4y9UfvIk3uCAMd2knvAt0vo55oycwqStSe/aSJd8VaWUPOHHRyMwXg8SlEVVY2T7eKxURKv8MAfn9x/EWF+FybUINV3+Jb+s4D8SC8zMcHWToU/y0i5O6lDWHxae3sI1pYPEbiWSBDLDovdU7CTnZG8IgUfTCVEcrRIF6rqYhgq2I+bEJUPMXQ9+tygsgmTsVvpsXzkKC9haLAl91JEtJAWk1ZdiTMq/30b6C+PecrzCrlvcoClXrivL5auOtpPcte9xm3lTtHOXLORedqV2Q7ml0hP59xnzp1dbl1qb1tjkofHpDI=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Dec 05, 2025 at 08:32:32PM +0100, Krzysztof Kozlowski wrote:
>On 05/12/2025 19:41, Deepak Gupta via B4 Relay wrote:
>> v25: Removal of `riscv_nousercfi` from `cpufeature.c` and instead placing
>> it as extern in `usercfi.h` was leading to build error whene cfi config
>> is not selected. Placed `riscv_nousercfi` outside cfi config ifdef block
>> in `usercfi.h`
>
>
>Please stop. You sent this 28-patch-bomb TWICE to 50 or 60 addresses.
>It's actually merge window so it should wait in the first place, but for
>sure sending it multiple times does not help. Please observe the Linux
>development process.

Sorry about that. I'll be careful next time.

>
>Best regards,
>Krzysztof


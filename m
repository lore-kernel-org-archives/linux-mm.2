Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2D3A0606A31C
	for <linux-mm@archiver.kernel.org>; Sun,  8 Nov 2026 15:56:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=soleen.com header.i=@soleen.com header.a=rsa-sha256 header.s=google header.b=ONVAS6EP
Received: by kanga.kvack.org (Postfix)
	id EA6346B05B0; Sun,  8 Nov 2026 10:56:35 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E56706B05B1; Sun,  8 Nov 2026 10:56:35 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D45A16B05B2; Sun,  8 Nov 2026 10:56:35 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A04796B05B0
	for <linux-mm@kvack.org>; Sun,  8 Nov 2026 10:56:35 -0500 (EST)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 13E5216049B
	for <linux-mm@kvack.org>; Sun,  8 Nov 2026 15:56:35 +0000 (UTC)
X-FDA: 85412404350.04.8179372
Received: from mail-vk1-f173.google.com (mail-vk1-f173.google.com [209.85.221.173])
	by imf22.hostedemail.com (Postfix) with ESMTP id 0A47EC0004
	for <linux-mm@kvack.org>; Sun,  8 Nov 2026 15:56:32 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=ONVAS6EP;
	spf=pass (imf22.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.221.173 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794153393;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JK29MDVmuTI3bC659OetYO7/ux09RXcoPKlf4Kypjy4=;
	b=aVrk0reT8+sBj0eE1hwT3fFO9wPwoF6LoWzT0hgxoujivi/Sdc0qFlm4Y3O/dS+8jhTUMX
	wM9TH24gi7EBwC+EK2CSPHm+qd/xVbboWaJ22ce0MFjjn34XheW5970lDje5PjgsKSihfa
	Lx/e47QbEUVHneU5yD6XM0ck1MzArYY=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794153393;
	b=4XXA9AEBRHu3TliYOSxcs5/XFkey2ba5fg9eYu/kNcMtrmrdGHV/MlF6mB/+miSaWrrY2j
	NdLyV9C0sjaHEB+HFgy4Q9pUOpdD11jFkxMmuhhxyReEgHP/iNaJIhNJa+xM5w76TU6PBQ
	HNABpT9qoii97/NQaABb0q6kLbO5I4k=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=ONVAS6EP;
	spf=pass (imf22.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.221.173 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
Received: by mail-vk1-f173.google.com with SMTP id 71dfb90a1353d-5eab93a9862so21414e0c.0
        for <linux-mm@kvack.org>; Sun, 08 Nov 2026 07:56:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1794153392; x=1794758192; darn=kvack.org;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:content-type:mime-version:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=JK29MDVmuTI3bC659OetYO7/ux09RXcoPKlf4Kypjy4=;
        b=ONVAS6EPzR7mfxj5lpRw41VDWOTeaxVmBLXWclcBilNcSmC7f2ORZyWIJJRlQUX2WF
         KLtANFT6+A339BfuJ9ME+4pIVivnJRkgynqso/xjuMKKAs1Y0LIDGrgqgDjiy3qPRi5r
         UNdIaA0YEWGaVnfPQsEsyBqRa6+P5iVejXGjR/+0AViTYIYCfR0AQqePgjhW10ONnZkO
         DRY9iKZyTIzAd5IVHi5md5dZNJttmFFaRAxgOZijPnuYg6diExzu7kV/D0xcaGUAvuyD
         Ry/UC6YKSChYKtJ49wJjtqkj5NyiiYzbuz6xsimwjb9rN7ZLKcUA/isZWN6nfEutCTJA
         kmcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794153392; x=1794758192;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:content-type:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=JK29MDVmuTI3bC659OetYO7/ux09RXcoPKlf4Kypjy4=;
        b=Zsd0xSnNWOD838YYnAV2W63vhujwmCgQPuvZvf6S/p0HxLjwXViLBLOMh8BzMV42yC
         0sobqGux4eYQ0iZjNp1MPe3yzsdtj0zE7G33q1mdQk80OV9RXfFtQGTWUYv/Q/UHEKeg
         apVwRVQ77Uh9A1C9Z/Qv5IFe65z/MNlGhPUMYq9W5LV4AFM+d5dPtHZzggtkZ4I8tn64
         FbQt9urFVvZmZxH/kGvcJYCjT6d3KdfUdF/hKeODTFwGSA2fMo4UYAe3MKAnu5VNyraZ
         fNRl0WVWkSUj2TbuQ6iPOhjHeErfIOPHL6qyzzkVfEYPXfOaBbNUpXwKBn9Ll8Corvnx
         7x6w==
X-Forwarded-Encrypted: i=1; AL+hErGnlIU+8vDGcOuBjht85mAojl2BnLtIGnCSTUduGIpGIRhPyKUbRfxfgQLbyXr6vlTymslcTlDe9Q==@kvack.org
X-Gm-Message-State: APuU4Z/CRZJfmjIJol+CLz7reFlop70rYNOMUOi2q2uNN+9rnPpOwn5L
	h3c+/IfxFjIWAF9SwmEx0zghpG6GsCvN7yy0/LYrYX2wKDnqwC71Z4CDlYFRcQnX5dI=
X-Gm-Gg: AYBFou30ueCkFJXpsbsMTzDTsZSgyNpYAigw6zDnP/9sDXaU9h9H1mU9X8HC3P8c2cm
	KFIpqGaA7HuC19fZmp28nfOcNKZggY6+lwJ2FrBN135XNltSuDkGG6uEl1ck9NQtVfTrqxiW59V
	z2SI3Jdqveu06RJiD/37grquFWeYcjsnQPnx3wD+Yf3NkIpOmc+JM23dYjYT0JzZPLRp1XiJlr5
	I+3FN0OdJKKuoBNkMZFCsCoXFk8ZVlO08z3rr2Xe06c6BCnHo6zGc1qYK9Oy5UXKBpD3WyeaZEk
	aNvsVI+du+zB0ZfoaK0OMQWdNvsqidznfYxlDpvDJnfgvulx7ljclTuKtA29cE62L6ULatAeD6u
	MjCyoIL/xLUaBvLP4s/6VgdOiYCPdv+1hcuDAa5fBJJPjkgspFJLxlpud2nf/UBo/na3+K8dvKA
	uBvF7lfgl5v4rIWNc46zPOSKs5z6KtdYsMwFMFou/CiayJI5BGNwNpcWuOnuVjUvj1Tp/wEDnsS
	w3ZsCKrg6Oy4WN0X+d9iBI7rvX8eY2UG37FMVg5Q20OfbVK4CNBYP5+VPfKwkI87m2mOe4TimgH
	js3FpuyUeiQx8zfTd71YoXC8Dz5S10lT+Izj6SxDRVb4rYowoR2rKd/Id8mkJf5p6q1V90QUY1+
	7MF5FXxmkuNK0Xshb5Baheb0+u2NQB8km0omH/rn7PFZSBtXFZdZqmbJ2TRNoyDb+yMeb
X-Received: by 2002:a05:6123:64:b0:5c9:a60b:e5c0 with SMTP id 71dfb90a1353d-5ece724fbd5mr492168e0c.16.1794153391927;
        Sun, 08 Nov 2026 07:56:31 -0800 (PST)
Received: from soleen.c.googlers.com (64.167.245.35.bc.googleusercontent.com. [35.245.167.64])
        by smtp.gmail.com with ESMTPSA id 71dfb90a1353d-5ece6069662sm2078039e0c.5.2026.11.08.07.56.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 08 Nov 2026 07:56:31 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] kho: check fdt_phys in is_kho_boot()
From: Pasha Tatashin <pasha.tatashin@soleen.com>
To: Greg Thelen <gthelen@google.com>
Cc: Mike Rapoport <rppt@kernel.org>, 
 Pasha Tatashin <pasha.tatashin@soleen.com>, 
 Pratyush Yadav <pratyush@kernel.org>, Alexander Graf <graf@amazon.com>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 Evangelos Petrongonas <epetron@amazon.de>, kexec@lists.infradead.org, 
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
In-Reply-To: <20261023054518.3258350-1-gthelen@google.com>
References: <20261023054518.3258350-1-gthelen@google.com>
Date: Sun, 08 Nov 2026 10:56:28 -0500
Message-Id: <179415338854.358073.9410769433043113739.b4-review@b4>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1569;
 i=pasha.tatashin@soleen.com; h=from:subject:message-id;
 bh=mM2B1WNxYEzouTeXd1iMrrTZ9Kih7nqHtFvmUB5THMA=;
 b=owEBbQKS/ZANAwAKAbt3KEzbc3reAcsmYgBq8JuuMqQ0q2iiQjSKjFS6r+naeIRZABjkt1NEg
 9AFf7Sq2OOJAjMEAAEKAB0WIQRBMaqT7LRvGvB/NmK7dyhM23N63gUCavCbrgAKCRC7dyhM23N6
 3kMmD/9uCE4nQFVuk15wOnI9NIxeSab1p5bGiQyaOO1FPMifDpfLJgy4YhFU1/HPX9XWn5ekYEg
 p0qr/AVUD+JXW/MxeCXhsPafSlziDGPcHhcZrrgdOG6ro39EIj6WrS77ta3QhQWcqh6+vGvEem2
 yGrcqfR5If1LYD/jiNemKuLGvElD+xnG1Q+GVn9PLm0szTidchmpiESGFf82iOd8R+pmIgr1Cw0
 FBebpRNz3Ju2Kvk66F1ekS01vnGyX+Eo4QhuHPcPP+wrjZTgLR7x24wV5T80aQGDHamLZQqMtal
 TqzeATUi4YvNQMsavBwZ6Y13Majg8MnDaFWK5ClMDThk+WtmaTQ1GgN09AsoQHp9kEcfWVEBRGU
 9yCNx1+3Oxl6gg1I5qbGxYIMW1JF4sKPEISWrRN3hkK9wlK0zuPF4AljgRiHDjvimUfWmM+iduS
 1hk3ldlqQKmkQXwG8qVbAPHxzJzHISCjJo5UyiEOu74OZXxD2pUaUVJzsLtNis+5Js/ndbko80p
 3w6ENK7E800cYwSL8v374m4vHg+Vzr0/iLwf+9sCPUtMhfYJLugrMkxYb6sSsqSsLEtEcuztmEJ
 3kajzAcRiLi+lQn2EIvjWexnxSCodVLr3gsDdJJ/QkYjGsyb98dgsTCp/1xi78lGcH38cAR+aYw
 CRs86UV2DQ0ZQxg==
X-Developer-Key: i=pasha.tatashin@soleen.com; a=openpgp;
 fpr=CAAAB722DD22A081F0D49F35633A6A993D43B569
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam09
X-Stat-Signature: sm3zcc4ugbuaxyc5ush1gnsp6yod595i
X-Rspamd-Queue-Id: 0A47EC0004
X-Rspam-User: 
X-HE-Tag: 1794153392-999938
X-HE-Meta: U2FsdGVkX1+BY3taOrVfiWzNGE0gbmXMEQl8u1Cqb1ny7sCjFoNR6Oli4jFAzbScJjdOQqkJ6XMpUcMSOY4wM+iIhzduhPaKmQ8JbHUp/ZOiujFkr39k6Ea806nDoo1Ax7w0F/ayDvxIkTDiodrf5eqt16lpztJyfZTnUIsF9ZVTlddCjCnJwzGiOiqN2qAJ+/5kSnvppyC5r3JZIY95Xx6qxu34l8c3DhVn0sNTu7tVI5ncsrVuDm8pK4ECXorsG+elyoi6GqNOPh5buRmaFAHpOd7bL+rycNzmccJzIDo1+DMt/gCuppWjxwAySF6EWL6gpyBzD6PN7u6Cv4DthbAYgp8wP0dmGAejLPSSYhbgbYVbvhSwp5wUrHYUhryxv5TTbtTp2AT170m6HFNLxTo2cMzd9CFWVz02tAwhLWcmf+jL7uQHbMnQwdOvpCZGDl+pgb+7dmFLH4Ygn6YQUdMmvbfepMFw+6ubJP2Ii1b+bXMCAxIAsMoDkSk2lawAnyK7gKUionI4+zkObWtFYvaf+7EbbTW6wQwcz5F/ZSRTUFb7ZG+C+Qfn/AjLlL7C1RTgin0314osb04/FuLXMMGJeh5lOu+xTyBFpCiLGW6jcO1crvRi9SLZxwmATz3zjWWJrWOO5BFJ0Qym/NJomOZMgCzeCVTCknZpsQtm/fxn/WhKir2li/kfjWxYrJHeL90qHmHUFbhGnzox2sEcMIQCt1XphWFpkfNsSJgEKV5fbZAeICblzaCOP0NZ3rIDirA3gJg7cdcV6R1ZDTdLCH3RQZri5l7Ao1Syl37MceKRlbOt1sbls35RbVukJ6Mg0b+5iwTSFsqPd7LdMkFEKlRdhsOND5oLb57pcLfFMEeAht1strb6h0PaKkybcHu1G1JQX1V5W0e4bP4ZHaB4ge+x8LryYpiJhcjYjtCZTyLlW8pXsQzRgZy/VameMoiEeWOxA/l7jPxun9lCT77
 mO49HHvK
 G5aIHVb9DG6SX4x2y8vRw5hHbbZp6UTfQWAZ7BLYFn2r4JvpIypv9MAXbwyLvj1HIDrnOWAW1V7LEchJJHXkRRx+Eswm1539cq+SHQ2NvzbIe0KTv15h+RNacf6JJ4oY/ifZazqePZJx27GWcv2/RP3VCdBEWzUzSrjVNjDFs0T9WVvB1rjCTZLX//anFaSVu6GQoawxWtlJoMKVaxdSklJlwgz53tY4TAM7FfeNQCJfduQM5EXYiogoTVjYEzOlC4m5FjymVUjYYxNvFlI0Od+q6WBH4YOsQlME7drQjTexgHUGOe5ksjAVUzqRFSaAEBbfQLrB9s2/nk5E=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

I am planning to take this patch, and change the commit message as 
follows to address Mike's concern:

> During arm64 setup_arch(), efi_init() -> reserve_regions() calls
> is_kho_boot() before arm64_memblock_init() initializes memstart_addr.
> At this point memstart_addr still holds its initial sentinel value (-1).
> 
> When booting via kexec with KHO enabled, kho_populate() sets
> kho_in.fdt_phys from the /chosen FDT node. Calling is_kho_boot() ->
> kho_get_fdt() invokes phys_to_virt(kho_in.fdt_phys), which evaluates
> PHYS_OFFSET and triggers VM_BUG_ON(memstart_addr & 1) on arm64 kernels
> built with CONFIG_DEBUG_VM=y:

Repalce the above two parapgraphs with:

is_kho_boot() is called early in boot before the linear memory map is 
initialized, so calling phys_to_virt() via kho_get_fdt() there is 
invalid.

On arm64 (and similarly in upcoming riscv64 support), this triggers 
BUG_ONs in debug builds, such as:

> 
>   kernel BUG at ./arch/arm64/include/asm/memory.h:377!
>   Internal error: Oops - BUG: 00000000f2000800 [#1] SMP
>   Call trace:
>    is_kho_boot+0x2c/0x38 (P)
>    efi_init+0x94/0xf8
>    setup_arch+0xf0/0x240
>    start_kernel+0x84/0x490
>    __primary_switched+0x88/0x98
> 
> Check kho_in.fdt_phys directly in is_kho_boot() instead of calling
> kho_get_fdt() so that early boot callers do not invoke phys_to_virt()
> before the linear map offset is initialized.

Replace the above with:

Use kho_in.fdt_phys in is_kho_boot() directly instead of translating it 
to a virtual address.

-- 
Pasha



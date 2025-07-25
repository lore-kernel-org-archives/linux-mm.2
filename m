Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F37B4C87FCE
	for <linux-mm@archiver.kernel.org>; Fri, 25 Jul 2025 15:34:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 923336B0088; Fri, 25 Jul 2025 11:34:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8FAFC6B0089; Fri, 25 Jul 2025 11:34:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 810E86B008A; Fri, 25 Jul 2025 11:34:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 6F6906B0088
	for <linux-mm@kvack.org>; Fri, 25 Jul 2025 11:34:00 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 3BA63C07BE
	for <linux-mm@kvack.org>; Fri, 25 Jul 2025 15:34:00 +0000 (UTC)
X-FDA: 83703182640.26.EF1531D
Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	by imf20.hostedemail.com (Postfix) with ESMTP id 5A1BE1C0013
	for <linux-mm@kvack.org>; Fri, 25 Jul 2025 15:33:58 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=evFyKddM;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf20.hostedemail.com: domain of samitolvanen@google.com designates 209.85.214.174 as permitted sender) smtp.mailfrom=samitolvanen@google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753457638;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IMrTLQB9tEMEJbnJ/xHH9mm9yGwT1IOyIE5qrsMa5ek=;
	b=6HWeQ+dlLuT4VJddu6gRRrz9mi9yxy1Mj2FgzvPSUDk0jUsLO+N2KlVCdAeALnhOJku+qW
	FJ8mlA62jVWYsSPUotlOl40gBKjgSd7lDN1TP1TR/kNyqyTdTc1QnU9PFRB5lFCdZ4jyDk
	CKCBhezMH0eC5sOL8gmzORtYxWbZn2M=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753457638; a=rsa-sha256;
	cv=none;
	b=pc8G8A+iazv0AzMDMFj8WRFLHlImozHEZFdwEZ6ZuVjPmN1ZLolIUn0u41o5O8AA6qRWyv
	62VoorqrC+/kuoGVknqX3AUPIxuNQItrlHQEzx3Fn26qaKVLJ8FATV3xn9WFqI5sW2uj5v
	9i/4tDP30ebphzJGxfQMH7PveaDGyds=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=evFyKddM;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf20.hostedemail.com: domain of samitolvanen@google.com designates 209.85.214.174 as permitted sender) smtp.mailfrom=samitolvanen@google.com
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-23dd9ae5aacso157665ad.1
        for <linux-mm@kvack.org>; Fri, 25 Jul 2025 08:33:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1753457637; x=1754062437; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=IMrTLQB9tEMEJbnJ/xHH9mm9yGwT1IOyIE5qrsMa5ek=;
        b=evFyKddM4zexoutRbI0F2BYQtT2T1ubfNcQSanIZb/VjUCH/GLxLLR0kkRDYj+VRvO
         lWvd5n4bsOvg/6r6TvwKGMDnkArHPSwU9sv2qeRbedSarfXcHrwkwlSOoxBtMidO3Bwv
         /l2g2wH7HNc8ALE2Pa5kgh1AHNKQE4RmXh81E0Hsm+MqXLAPGPw99cDxX/uF1gRNC6SB
         Yem1esVDPihM1HAGJjV69+5jTY4W/BBKpi9by1wbasP+C+nV9jgQltRBHyDnNGu2xnWC
         AIeNFwbDr519TVeoUkqMKIl1/QVVWjO7jlxIlG5IOsnUDAoLvUi43G199gzwYZWINRr9
         u4YQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753457637; x=1754062437;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=IMrTLQB9tEMEJbnJ/xHH9mm9yGwT1IOyIE5qrsMa5ek=;
        b=E2ufsqLd1Yd+VzxtaTMelFe+nT+XajNfWQeL6K9oYzraJOfhXvqb1xtDiQKdV55gmQ
         z2U0RW5myIies6OhdjKe8oLy7MW+pmECJDAzJp5P+anq+grlZbAcXOeMT7KPIYLeiFCf
         Sz49hLz1GdaGmhYztgnqbmOwt5ZSGDzMk0n6+SlX++JrtbsdSxvftJBmp4AfDaZeNLXH
         v74z6qZE9frr9UbXwyJ0Vaw3uKNwt44hGJuu2oDwIUM9E02h6K/jt374dS7w4aQ5iKTM
         W2q5KJgXYCugYkgZOxrnk/wI6U7sV6WVsHiS6nvfX+3FD2ulBrTLBHR3jhOPkQNMZltV
         Ikew==
X-Forwarded-Encrypted: i=1; AJvYcCXYM0qdOB7ZPMy51i6qlKAkCvhA/izGbtKwF2QNgpn7qFTa/xv7mXvobDXo2r1xLQDbZd3IZv4/Kw==@kvack.org
X-Gm-Message-State: AOJu0Yz0RhMSpa+emEK23LZR3ervDcbtAxc6KqBbPLCvIGDPf4L1nsCr
	ZYmh1bsWYWiUNpZaPTvxRXc8vck0RrM7Tr4iQvMe2gp1a3WgKdi2pwBF21a9uQYAHg==
X-Gm-Gg: ASbGncvzGlGD+5kqdb4E7fO22wO1h/FIPyKexCKdpXVrM9FgskdW72ait7smULdC7y7
	QAxFgo5zTTuHD+xe1SzAcKvV3yugw3SJ/QSYtEkdFbebf1eTUvqd6/pQ3n99zm3vbHBUExxzLmj
	1ObcugOSv2uSCzUKF1F/ShPKFGCk7E3iEB1moyhQhvmvpV9JxH6Q5o9wR4CsQCOKXCGOECKZoVp
	wlXZDd0bVaMP6Gs1fIkk8wCpUPXIKlY9Ck6GArVHg8yQyuOdKPDWaoG6LBwNA02+8a9yWsyj8Ly
	98A2mc+vySPM287Qn448jUDryKCS5Cm4sXV4B2yQfR95Np5phe4vRqdAmjckqHaWMmKdwkIH2G1
	OMhMUgG+zd5Q/ArkrV/0eYfSJQpM9ucjgaXbp42ToCncDIQER5klgI4cPPfN8QSA5NA==
X-Google-Smtp-Source: AGHT+IGqwy+SyKapfsDhV0SCrakv4CqrxfO6vBXV3nKCxXlckVrSgte7qwyPNubIbBY6dQEWJppRvg==
X-Received: by 2002:a17:903:2d1:b0:223:fd7e:84ab with SMTP id d9443c01a7336-23fadb22253mr3447835ad.24.1753457636899;
        Fri, 25 Jul 2025 08:33:56 -0700 (PDT)
Received: from google.com (106.81.125.34.bc.googleusercontent.com. [34.125.81.106])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-23fbe4fd692sm86545ad.91.2025.07.25.08.33.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Jul 2025 08:33:56 -0700 (PDT)
Date: Fri, 25 Jul 2025 15:33:51 +0000
From: Sami Tolvanen <samitolvanen@google.com>
To: Deepak Gupta <debug@rivosinc.com>
Cc: Paul Walmsley <paul.walmsley@sifive.com>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Albert Ou <aou@eecs.berkeley.edu>, Alexandre Ghiti <alex@ghiti.fr>,
	Masahiro Yamada <masahiroy@kernel.org>,
	Nathan Chancellor <nathan@kernel.org>,
	Nicolas Schier <nicolas.schier@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@redhat.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Nick Desaulniers <nick.desaulniers+lkml@gmail.com>,
	Bill Wendling <morbo@google.com>,
	Monk Chiang <monk.chiang@sifive.com>,
	Kito Cheng <kito.cheng@sifive.com>,
	Justin Stitt <justinstitt@google.com>,
	linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org,
	linux-kbuild@vger.kernel.org, linux-mm@kvack.org,
	llvm@lists.linux.dev, rick.p.edgecombe@intel.com,
	broonie@kernel.org, cleger@rivosinc.com, apatel@ventanamicro.com,
	ajones@ventanamicro.com, conor.dooley@microchip.com,
	charlie@rivosinc.com, samuel.holland@sifive.com, bjorn@rivosinc.com,
	fweimer@redhat.com, jeffreyalaw@gmail.com,
	heinrich.schuchardt@canonical.com, andrew@sifive.com,
	ved@rivosinc.com
Subject: Re: [PATCH 02/11] riscv: update asm call site in `call_on_irq_stack`
 to setup correct label
Message-ID: <20250725153351.GB1724026@google.com>
References: <20250724-riscv_kcfi-v1-0-04b8fa44c98c@rivosinc.com>
 <20250724-riscv_kcfi-v1-2-04b8fa44c98c@rivosinc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250724-riscv_kcfi-v1-2-04b8fa44c98c@rivosinc.com>
X-Rspamd-Queue-Id: 5A1BE1C0013
X-Stat-Signature: apj9okna438n8mmi17ajcejkwr5nap3e
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-HE-Tag: 1753457638-563097
X-HE-Meta: U2FsdGVkX1/7f/HE3hxutMwbTBnz/GMxv0jnuFriieKSWDJcpPgRTdxkeFqfr4IdrBBjPVorlhiZ48z7BZXV8urbdLD0N9xSQAejFHKy7AcbiWPjFHjrb6eGoYsfwh0rFG+/Msn9Nw8rGOvtTTbKFOsweWE2r3PjPfYKhbExujvacIudoDeYH6jCOQGy1QKtfJDJYire2hay3TZ07a/BBHEa7fwyIr6LbSkLDtDcyrHJ5t/X5uR45fTnGwX2zTv/GO36xIXm8a0Gxo+ExXFE0mSofoXUQQRooPCECjqQxdf2EbFb1o2mbzN3ByKivCXw/Ey+c1LQ+QW5XJRkPGPCru129HeGP5TwoNfowvTqXLTvW3QvVBJziaZGTAJjbpoF7CHz8TPr/5JQp8hg+OEFHLx+j8L9UYsASyeJAm86Ca90TmudnhkJkmgnrvMDktZSsPEL7NObM+0AW7WMB9r3nCLrptjkj18OvTj37+5YBhn804jJ3fDy8qKSAb3urTFMv9Iu1DM6DyY8j07Q5tbghFBP15vhZVX1l7cpN3H+jzxU9gAgk3BkbeDOolzuGRGHGl2mpU8hGTAp+YrpuPI6z6OX3c818iuOd5/1qrzaWrN1G6ATPxYI0xbPqMm3HpPCGDaOZInOb5xkVwKqu9XndUbtl24/JrydRbjStSDIDGBGk6FeDkU0E/5Zg8H7R6wCztb59XkHyK/6GyLbrs/awb73yQISfvxi9r11SE+6aPcGz1WSD2zW49zzd1s5t00ty6JEsn3Oq07h4OdmrPMRG3h/vX6DG+cP8nM36JR99MI0co9QlNBX2IlSd0ZbJXU15G70UjO7QvZB8Trbmi+j4oud3Ioib9UjO+z5aA4wktydLakuSxEQveztNlHcP+3Nry+GvDPSKK4XRojwTdoCN8cz1R+djQyPUdlFsI+ZVHA40sEb6JcWnHeN9szgu8Zawj3fFqZYXyAC8Gpp9Ra
 N0A4PJGF
 pxjebzB6p7mmNPN2gK2cBSM7M5TSHOeV/CZOmNhJHWGDcYQ0SxMSlsoF+D9yTPAR07p4ofyhEXRh8pykPmvRqlT8ltTk53dwUFD9Lt796A59h8zN+tqdrjWmc/apU9sS6ZLYy88kYilVKQUdWrqWc0SO24H4LO19x3x0bP8tzxpN9Q5JErCjOy/k1f/Y3RNvd5oeVt4Q/t6KJqQKWKi2NvPAplAs1d/NqMmc89rPx7O+68unRZORku7jzzX7BrdUTdQjwbq4OA4jSLftyCCIIs1szAbp4TI8R/PwAa7L7up9ydloBM7ZVeghqj9+dEYeY9HZAi5QPrKnZquZ6/MQS6/zMAUWBZ4eKXqmaOynlb8Ob0Td4hRT+y3O/mN4JzdEz9E+d/oFAmHPgcFUj4e+aNb1UBtGPAOFtO2Ydw5swETdLpI+/THsQQwx8C67ihVwLmY2nF97mpL+GnSKFmTglOoeao9AltudwwtFTBr2XHen1QkfobFQ/ttUq9sBZ9MaYy8eyJDkW3XM5fNsw4lhKSFoo4PpHeqgUDV63108/Y4KAOuA=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jul 24, 2025 at 04:36:55PM -0700, Deepak Gupta wrote:
> Call sites written in asm performing indirect call, they need to setup
> label register (t2/x7) with correct label.
> 
> Currently first kernel was compiled with `-save-temps` option and
> normalized function signature string is captured and then placed at the
> asm callsite.
> 
> TODO: to write a macro wrapper with toolchain support.
> 
> Signed-off-by: Deepak Gupta <debug@rivosinc.com>
> ---
>  arch/riscv/kernel/entry.S | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/arch/riscv/kernel/entry.S b/arch/riscv/kernel/entry.S
> index 2660faf52232..598e17e800ae 100644
> --- a/arch/riscv/kernel/entry.S
> +++ b/arch/riscv/kernel/entry.S
> @@ -389,6 +389,7 @@ SYM_FUNC_START(call_on_irq_stack)
>  	load_per_cpu t0, irq_stack_ptr, t1
>  	li	t1, IRQ_STACK_SIZE
>  	add	sp, t0, t1
> +	lui t2, %lpad_hash("FvP7pt_regsE")

Ah, I see. The plan is to hardcode the signatures in assembly code and
keep them manually in sync with C code. When we implemented KCFI, we
thought this would become extremely tedious to maintain after a while.
Do you have any plans to add KCFI-style __kcfi_typeid_<function> symbols
that would allow labels to be determined from C type signatures instead?

Sami


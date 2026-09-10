Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7C92EC88E41
	for <linux-mm@archiver.kernel.org>; Thu, 10 Sep 2026 06:31:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 85CCC6B0095; Thu, 10 Sep 2026 02:31:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 80E406B0096; Thu, 10 Sep 2026 02:31:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 723AD6B0098; Thu, 10 Sep 2026 02:31:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 4AEBF6B0095
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 02:31:53 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id CD5F740430
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 06:31:52 +0000 (UTC)
X-FDA: 85196882064.03.03FACE6
Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	by imf24.hostedemail.com (Postfix) with ESMTP id 06A63180005
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 06:31:50 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=PmLLcdn5;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf24.hostedemail.com: domain of mkchauras@gmail.com designates 209.85.214.175 as permitted sender) smtp.mailfrom=mkchauras@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789021911;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1toCXFJJyIGT7Bi3z+gvDkztm6+uDMf7He5yX/dqQdk=;
	b=IvIxXv0YjUu/cV4EE6TLJQfIwL1HleFejL8LU9tQkhQcmTK1zak7+E8oyKySx8t/1wWAyg
	Uol4A75eYe6GDBin8Hj9+xNCLkmthnODwfult8tKFmrMJ+c7w990dcM/4ezWMOm1dV8PzN
	JNTX7j/9WBezL9BUT75pYhHLkHYWD9A=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789021911;
	b=MATCjFxUrtVALoMMDVhSaP1BuSU44tKsP1RRVCauem1RgkdNd2j01kc/1VScqGDlnzD+4T
	3lZ0IZwPjgSiBLL0BfadOy5bmx2pThl9GartooFraPiQB0yYCOtRhLMRh6o4b7Nf98VXPv
	5ZnQ7EUmUIATyM8COl5Lzdqg1SNKee4=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=PmLLcdn5;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf24.hostedemail.com: domain of mkchauras@gmail.com designates 209.85.214.175 as permitted sender) smtp.mailfrom=mkchauras@gmail.com
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-2cc891373e0so70404055ad.2
        for <linux-mm@kvack.org>; Wed, 09 Sep 2026 23:31:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789021910; x=1789626710; darn=kvack.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=1toCXFJJyIGT7Bi3z+gvDkztm6+uDMf7He5yX/dqQdk=;
        b=PmLLcdn5om39t1NSBA4F2P8dwRgZxp08MLxbIXXs8WBjmztiIL/+8xP+975rT/U9GI
         O1UJazkh1BjsU+GK+Y4lfqAn3PoWNn31Jh/bFLSLp8ps2VEoZ/qDWADcjCasszlEhuRr
         GobLswORDdFJ7hxAmDZ00DkR98LAyZ0b0D/XGVcMQHJuu+hS/SuXCy+lnDK1Tv90gB5s
         IceuI8WK6R+Cnf5YsB/abKsBnrzQGjMyQRp9hcHIw9jqXH5UOX3LdnjsnMFX1iclDWWk
         0NfFeYz8iP+EOxseLks3NfSjrxNLCD2gbBvkNXN0RywFj6PaVc+ekZTXc0ykY9scDk3g
         v8Qg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789021910; x=1789626710;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=1toCXFJJyIGT7Bi3z+gvDkztm6+uDMf7He5yX/dqQdk=;
        b=P8NlbzzjbPlt3ydQhWLgVA3IJ+SoV8qgzItxfqa/fgNnYDh/dYcpEpuobSN8R99D0j
         H4it2DgCCmXHJrMJqRHBMn+bDYMRf7OPOykI1yjDmXGk00YFubDMX7/7F8bafEPHFJMK
         EcHOexE2dnco1BzJaBJbKNMvKGQMemq4QrwhRhR0OEVKD0BE+8xCrFKI/YHQP0KPAY3N
         +5tt9BFzi6BFwBmFj/6n+bXxggxgzH9Be5pwjAUM6fU1wZkMmYg8qp3EDb5nMcklRWNK
         AuKODyvwCztiko6Nfufwz5mkN2Yg75g5HVy/D3CNzJup/4L4lSoQUP4E4LNC2IVwUyeB
         9vzw==
X-Forwarded-Encrypted: i=1; AKwUvBw7B2t1gskm/F8KGF1GYcx6QiQp+/LTJRRURWvZ+MsxtTBwtVBGJBGQ/Mpm5+39+RwW60HhLhOkWw==@kvack.org
X-Gm-Message-State: AFuF++lprKzkp5l/6XzjgAvcPnio/la9YgGGqi9yAveQ+3IuHzmL1Qjv
	dwJGTVrH1bXuumDQDd/KVNIHuqJQVq6hvevu7h7V0n1jmZwQ9OR9VzA0
X-Gm-Gg: AYBFou3MOuMpPdcucDbwYcm66d5aw8m+dHYCgtqUu193Q1O0JGGkfCqVv6/SZXhYUkq
	ZphfGv3ItCtyXiG/rUSwYZb4JJ8sVa2i2xV1lAkCFOSgdVmVsseFrPcljXydkAzh5/35aIPR940
	NocdkDrYkcmOqhoETC45jpQqa2/asre5s+nrImkvPN8Bb1vYgcTGpk1EEVsZxI1ielNd2Cntim3
	wJ0IWylGyGSWp4UVWr3TwwzOA+a7iIz77boUFVaWbqPp9FnBrAORTABKiaN2Ao4ny3AhCDjBdOY
	Ibcf3Hs0TxJvYDlngmSRcEwcHJVonaag10pwwlb4ANOElXSb3F+mAu43ji1PexyTR4T/qMmrb6+
	6MygQnOh9Q1WLhzfDAxrg7SghaylhZu/geZ+1qrNnBJkm2UxX408+/fpBoHeFwp4jaw0V2tvxvF
	TT33Bw5UKtvWgO3P9NxzxdIsjYmjrz2QwKenf38SM+LfTN740dIlLqzu8L0KKq8klQkc+HYHtt8
	uTA+yX+Vk/sFVdlE4HWDUe/YcKaZFL0dtwADRODaaY=
X-Received: by 2002:a17:90b:258d:b0:396:4c63:7193 with SMTP id 98e67ed59e1d1-39b261323e0mr64061526a91.11.1789021909725;
        Wed, 09 Sep 2026 23:31:49 -0700 (PDT)
Received: from li-1a3e774c-28e4-11b2-a85c-acc9f2883e29.ibm.com ([129.41.58.4])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-39d7e834319sm2507639a91.10.2026.09.09.23.31.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Sep 2026 23:31:49 -0700 (PDT)
Date: Thu, 10 Sep 2026 12:01:26 +0530
From: Mukesh Kumar Chaurasiya <mkchauras@gmail.com>
To: Thomas =?utf-8?Q?Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>
Cc: Paul Walmsley <paul.walmsley@sifive.com>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
	Alexandre Ghiti <alex@ghiti.fr>, Nathan Chancellor <nathan@kernel.org>, 
	Nick Desaulniers <nick.desaulniers+lkml@gmail.com>, Bill Wendling <morbo@google.com>, 
	Justin Stitt <justinstitt@google.com>, Andy Lutomirski <luto@kernel.org>, 
	Vincenzo Frascino <vincenzo.frascino@arm.com>, Kees Cook <kees@kernel.org>, Ingo Molnar <mingo@redhat.com>, 
	Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, Richard Weinberger <richard@nod.at>, 
	Anton Ivanov <anton.ivanov@cambridgegreys.com>, Johannes Berg <johannes@sipsolutions.net>, 
	Russell King <linux@armlinux.org.uk>, Catalin Marinas <catalin.marinas@arm.com>, 
	Will Deacon <will@kernel.org>, Madhavan Srinivasan <maddy@linux.ibm.com>, 
	Michael Ellerman <mpe@ellerman.id.au>, Nicholas Piggin <npiggin@gmail.com>, 
	Huacai Chen <chenhuacai@kernel.org>, WANG Xuerui <kernel@xen0n.name>, 
	Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>, 
	Alexander Gordeev <agordeev@linux.ibm.com>, Christian Borntraeger <borntraeger@linux.ibm.com>, 
	Sven Schnelle <svens@linux.ibm.com>, Thomas Bogendoerfer <tsbogend@alpha.franken.de>, 
	Miguel Ojeda <ojeda@kernel.org>, Alex Gaynor <alex.gaynor@gmail.com>, Gary Guo <gary@garyguo.net>, 
	=?utf-8?B?QmrDtnJu?= Roy Baron <bjorn3_gh@protonmail.com>, Benno Lossin <lossin@kernel.org>, 
	Andreas Hindborg <a.hindborg@kernel.org>, Alice Ryhl <aliceryhl@google.com>, 
	Trevor Gross <tmgross@umich.edu>, Danilo Krummrich <dakr@kernel.org>, 
	Thomas Gleixner <tglx@kernel.org>, Christophe Leroy <chleroy@kernel.org>, 
	Boqun Feng <boqun@kernel.org>, Nicolas Schier <nsc@kernel.org>, linux-riscv@lists.infradead.org, 
	linux-kernel@vger.kernel.org, llvm@lists.linux.dev, linux-mm@kvack.org, 
	linux-um@lists.infradead.org, linux-arm-kernel@lists.infradead.org, 
	linuxppc-dev@lists.ozlabs.org, loongarch@lists.linux.dev, linux-s390@vger.kernel.org, 
	linux-mips@vger.kernel.org, rust-for-linux@vger.kernel.org, linux-kbuild@vger.kernel.org, 
	Jan Stancek <jstancek@redhat.com>, Arnaldo Carvalho de Melo <acme@redhat.com>, 
	Alexandre Ghiti <alexghiti@rivosinc.com>
Subject: Re: [PATCH v5 01/24] elf, uapi: Add a header for relocation constants
Message-ID: <aqJOscgnnevybiKO@li-1a3e774c-28e4-11b2-a85c-acc9f2883e29.ibm.com>
References: <20260908-vdso-absolute-reloc-v5-0-3a93791af1cf@linutronix.de>
 <20260908-vdso-absolute-reloc-v5-1-3a93791af1cf@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260908-vdso-absolute-reloc-v5-1-3a93791af1cf@linutronix.de>
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 06A63180005
X-Stat-Signature: urox57czf1975obe416pwy4f9gh3ktz5
X-HE-Tag: 1789021910-151537
X-HE-Meta: U2FsdGVkX18ydfiyhboFnkKonXE1mHFQoJ45SWA45yQFMR5no3NYNjRHRz1RVSmJSMSAnCFpGEh0JbPzh7C+6nqXj6GXAaNdR/g7+caW3/Xc4SF6iXaxTycNk2BZ0sZxMIkdo+mHHs3708jNSx/YE2O/6WJcXEftsKZfZ4gBNhm/JC7pQM36vrvQHXhJuqo/AzQFtUOVJ31mExnbDRDL8xL0/jfJjGteNeYDZpUHz1knjMX0BMmP58umAXr8lzI/cjFnS+aCyq4WJQx6CVNAnxwRvJcqw4K1lW4agc6D/xi+ko1CFQmbMRP1UKYQH9Z7BQKA6AWueLeHR9ijOv9gtIpDF55P4BgkBQD6JdBf6s03BU+BhoS3jSeiOUqX6xkMC5hMFWqrRW1Aciw78GEHk9Mw/phKxqzh4ZLl0jZZJ3RBhWMKgdX6SjAUmeAAUNfc0S1V9BtxtzEYrQUvdRQQxbLFjxYyOC/opVse3bvJGhVA6ag2JVdT189mVbmHUfznlJDO2USLh7qv7ml5R5FDYkYF9teg+UdVwUiigDy1XRSforsswLL5YXnQOf0WT2PPSIVX2fCJdJjkjEtxX/0hZf79PFwCbxBPYJqyukzSUeHsgMMQmlWxRi6dTSLv/c5g/czuLMeX0XTM+WtHc3h33FZPJwWoJ+QYn0NDZ7DxFvzrkW39uaEO2jatU9IEz8kGNd1ShIhumAh1iPfS2CNcEc23tLqHGNWuAKpfoKUmJpPB5rmnO+BO+q1u8MLhSqzFJeQXiR30g4a9wMCRbtdD4n0BfM7Yw06gSC4tb37HXFOpRiiEMHMkPLldGop6Hg+XmsOjbWaSvYpJrVsBIWUxmBz9BhGJePbYsDW537fSYnCHZS4c7lsXpEddmGSyyva6jLGesRmo3iZRUeYxympvMqfOx3pl5qFrC1WgCevDLYdmSqtklQmrtwG4wjkWLH+FKasa0qZlNrjayf8a94d
 bFPVRdcR
 MHV6Zb2tfMDDU+snXyy1OfhO0mTasenloMYy/+3RTd+N16S+hpBB0TYR1ZOi7YBxa2Errdt9ZtdMK0ZZB8nrVJ/M+9VG0Bi/KhNyYg2YlWaenmA/wdBzyEsOBMzmU95hfW5O8qVpwoFBY31AjnD40p1E8l+EN0XptBE3UBwkdv45FwqJEudX+yYuc4YxIM8rOoSuMHG8wHtMB7zry2fi0cxvJ14xN8MslkSG2tY3JwMUZ76D+PXXYC6QUfaHzQYFalUEsadCVhS0+hGwxp6H9fLBEGEglG4tDmfTxPINYnW3tH41vW6kcZEDjQDyrb/gg6ki6GVhCJ+NFGXn04C4qy4WESomNVOb7SpnWSOx50E4Zfy8T5Ly7NdkFNw1io+9RvcQ6q1aRXqHKsVZu0v/h7klxROEOFh8QuVvnNIyx4E66Bvkdpowgm1oGfeJcikyVh97iwkBtqDAS7vqQs1cbtkzMXnPCOVmq8NnlXjxk3e6rdc8cAnqRgG4aBrOv6nBF8X5aH4xW8g1zNZ5wPIDncgddgUyX8jilmXetKOxtUB8N7A2rn7WyHZp4UHkPFECiG5sMbPoZq6lHqTmQpv9mUjlgmA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 08, 2026 at 08:33:35AM +0200, Thomas Weiﬂschuh wrote:
> While the numeric constants for relocations are architecture specific,
> it is still useful to get access to them from other architectures.
> Also the definitions are useful for userspace in general.
> For example tools processing elf files during a kernel cross-compilation
> can make use of them.
> 
> Introduce a dedicated header for them, similar to the elf-em.h header.
> For now the header is empty but it will be filled step by step in
> upcomming commits.
> 
> Signed-off-by: Thomas Weiﬂschuh <thomas.weissschuh@linutronix.de>
> ---
>  include/uapi/linux/elf-r.h | 5 +++++
>  include/uapi/linux/elf.h   | 1 +
>  2 files changed, 6 insertions(+)
> 
> diff --git a/include/uapi/linux/elf-r.h b/include/uapi/linux/elf-r.h
> new file mode 100644
> index 000000000000..2c382c8a4807
> --- /dev/null
> +++ b/include/uapi/linux/elf-r.h
> @@ -0,0 +1,5 @@
> +/* SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note */
> +#ifndef _UAPI_LINUX_ELF_R_H
> +#define _UAPI_LINUX_ELF_R_H
> +
> +#endif /* _UAPI_LINUX_ELF_R_H */
> diff --git a/include/uapi/linux/elf.h b/include/uapi/linux/elf.h
> index ee30dcd80901..b3e312255552 100644
> --- a/include/uapi/linux/elf.h
> +++ b/include/uapi/linux/elf.h
> @@ -4,6 +4,7 @@
>  
>  #include <linux/types.h>
>  #include <linux/elf-em.h>
> +#include <linux/elf-r.h>
>  
>  /* 32-bit ELF base types. */
>  typedef __u32	Elf32_Addr;
> 
> -- 
> 2.55.0
> 
Reviewed-by: Mukesh Kumar Chaurasiya (IBM) <mkchauras@gmail.com>


Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3977ACD13DA
	for <linux-mm@archiver.kernel.org>; Tue,  5 May 2026 07:20:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A163C6B0095; Tue,  5 May 2026 03:20:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 99FDD6B0096; Tue,  5 May 2026 03:20:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 88F276B0098; Tue,  5 May 2026 03:20:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 76B5D6B0095
	for <linux-mm@kvack.org>; Tue,  5 May 2026 03:20:14 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 370618C5B6
	for <linux-mm@kvack.org>; Tue,  5 May 2026 07:20:14 +0000 (UTC)
X-FDA: 84732517548.13.37727AE
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf07.hostedemail.com (Postfix) with ESMTP id B508E4000D
	for <linux-mm@kvack.org>; Tue,  5 May 2026 07:20:12 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=fail ("headers rsa verify failed") header.d=kernel.org header.s=k20201202 header.b=AZxWbBvY;
	spf=pass (imf07.hostedemail.com: domain of bot+bpf-ci@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=bot+bpf-ci@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777965612;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uKEcwDRmE/Dw3PjePODviG+2OyaPs0Fr4s87SnOlBNg=;
	b=WOgQ2ZT0VPZEA8Y2eXBvi5B/LiQO08v76vLTHqbGJ4JL/bZTwi5rSmj51WvwCBoc1xHqGO
	P63jaPcHiEJqm7TJ1eQx0FdjUTlTpYNlOxwDBs1Q1G33yQQ+gv1oaxDynFFwP4C4qwlkRM
	QWB2geu4mMbRbYZZxIdOw8qMauXavtM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777965612; a=rsa-sha256;
	cv=none;
	b=r2Th8RXpPkYPm8Gnu0GVBgnc19Lk1Q3/93oNRx3gWiUKuRRxL4ZIxgCSTXtFh9eQmG8UiC
	8Q2xTWrZICJT9s5KmygMU9CdQFm3oLe6CGjm0JTjMmeBh8fGZurCSLflEzYZHqWuvWs7nH
	h+YE9xh6FJDUYV9xc3J/2advBNB8mnE=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=fail ("headers rsa verify failed") header.d=kernel.org header.s=k20201202 header.b=AZxWbBvY;
	spf=pass (imf07.hostedemail.com: domain of bot+bpf-ci@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=bot+bpf-ci@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 49DA96014B;
	Tue,  5 May 2026 07:20:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E591EC2BCF6;
	Tue,  5 May 2026 07:20:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777965612;
	bh=Z0FXQFs0XgCitklm42p+eFCRXoSwhNl8YaZgF5P9pKc=;
	h=In-Reply-To:References:Subject:From:To:Cc:Date:From;
	b=AZxWbBvYjHzMwBGYAn0U/L+Y4nNRwAOnQ7QKBncZ5DofsMttNhg1rsqFqCAox2z4/
	 VLC8c51H6eGo4up2Oc9WzaBpVdjqlowLNCCdtrbnljiGBQOVebgMS8cmbhe4lEoUOR
	 YOUd4azIaiomeZtl+96K3UoRYPsTZCtUEYVtgzTDr47ziJI9XzLSYAno5EeSCiFszF
	 I0bFBlGGW91/979neAvZamO6efbThBqQq+v1advRIdvH24/vBNcixvmB4Ru5RePWTW
	 fTQkhHnQa+GFAtYyExdmfSAVa6wcAcfYaOQxhKk7LvgTC5vEJdzwI0EBfhAIJcGSDy
	 iIAYNNRsm+sqA==
Content-Type: multipart/mixed; boundary="===============8001377551619871004=="
MIME-Version: 1.0
Message-Id: <2b13d3da553b3d2b09d94c046e80281f972d997b3e9037a0b215d6663135711a@mail.kernel.org>
In-Reply-To: <20260505062026.91724-2-cuiyunhui@bytedance.com>
References: <20260505062026.91724-2-cuiyunhui@bytedance.com>
Subject: Re: [PATCH v4 1/3] riscv: io: avoid null-pointer arithmetic in PIO helpers
From: bot+bpf-ci@kernel.org
To: cuiyunhui@bytedance.com, pjw@kernel.org, palmer@dabbelt.com,
	aou@eecs.berkeley.edu, alex@ghiti.fr, dennis@kernel.org,
	tj@kernel.org, cl@gentwo.org, ast@kernel.org, daniel@iogearbox.net,
	andrii@kernel.org, martin.lau@linux.dev, eddyz87@gmail.com,
	memxor@gmail.com, song@kernel.org, yonghong.song@linux.dev,
	jolsa@kernel.org, bjorn@kernel.org, pulehui@huawei.com,
	puranjay@kernel.org, thuth@redhat.com, ajones@ventanamicro.com,
	ben.dooks@codethink.co.uk, rkrcmar@ventanamicro.com,
	cuiyunhui@bytedance.com, samuel.holland@sifive.com,
	zong.li@sifive.com, conor.dooley@microchip.com, tglx@kernel.org,
	debug@rivosinc.com, seanwascoding@gmail.com, andybnac@gmail.com,
	menglong8.dong@gmail.com, cyrilbur@tenstorrent.com,
	wangruikang@iscas.ac.cn, atishp@rivosinc.com,
	apatel@ventanamicro.com, linux-riscv@lists.infradead.org,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	bpf@vger.kernel.org, arnd@arndb.de, nathan@kernel.org,
	nick.desaulniers+lkml@gmail.com, morbo@google.com,
	justinstitt@google.com, qingfang.deng@siflower.com.cn,
	linux-arch@vg.kvack.org, er.kernel.org@kvack.org,
	llvm@lists.linux.dev
Cc: ast@kernel.org,andrii@kernel.org,daniel@iogearbox.net,martin.lau@kernel.org,eddyz87@gmail.com,yonghong.song@linux.dev,clm@meta.com,ihor.solodrai@linux.dev
Date: Tue,  5 May 2026 07:20:07 +0000 (UTC)
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: B508E4000D
X-Rspam-User: 
X-Stat-Signature: iqz64m877agwx4xkw3s8nr9fsbwyed6b
X-HE-Tag: 1777965612-230650
X-HE-Meta: U2FsdGVkX1/ntpUrkM4rhgnWD35EsXM7KhUMtg3db9MlGRwO6ID1HXFJMobgcXM7oiA7tpNUqu2eNjYwESxuuOI5m50lLCNZ2VBxVjcUz6yPN+KoNgV6bC2uHcin3xRoeuIdTaXO+4yhP1F5HV7O8J5DGMvFB5TKWPwsMlFng1ROaeLdIP7oM9yNl3TqNRlg4sDeZ1heW+ehjczWLIqs34z6mXe3ROBkpTvU4LJC7my88/GBwDbYUbfP9/4kvG1g94lzlNITAMZ0Wn95MOdehKc5gzDYBvYtXyfb4I7CiW0qyfAdmwyXxwsss9OASXzyXei1RfksvxnPlmCCkhY0nm68HnoEXK6DqlEII2CWYSOpnkdfC8IOpaZs8y7QTKKjK3YT2kT9raTZJrf4zn4VXDXsMjyZjwuMxTHoDGyl09Tid2QqLMsJwJkTBUkfO6rS9ElFgBBS3BuQTL+Ojk/WtSAFvHm+Xv+fgkoV1HOt6GLWZbY7D+oSZnHRy16JEVEiK7VRRhy9kBmKlBOi8k7f80bIakm94DdiVownvj1F6Q4HENNFdswEC3+klxrqckww57HdxBsVE8MCNmqTtJnCaklW23zICdahw06femYV2ni0hfgH+NhM6L3+oDwcZdVHvo4jmB8LO+duB9IdQEava3PSF8AcquWEhuxOBYQVCvRpXov0XlschFBEOduQu8zFmCLliozv+ZLooJ6ZUOuSnt2sBBIdHmuSTbFB++Sr51ZJYq5pWneuuOOXA7VFS+skisYXvZRR9Ga40EJFAuCPi2hmPfZczTbgGWOltvltF+mmtx2nvWCW8KXRR1ePiSiw6931ixnA9JCNtYE+ilfoxQNWqEzKNAvEL9u5MKIw4a3gK5uoGpPsrlkSYiuqq9rViCn1bfKdQZBUA/qI+5HVohgRnqVPuQWbq68pgJVIqVA8ZIwkscWFG85MQeMKgXq17+SNYds1+0MLDHJPl3b
 pLj1okBi
 SnrjMGBesEODVIL2W8rxkbTCcb1fJUDaEj1eJ8hpnLTYT3TlDAMeyNIbkC4I33J5dQkwECiKhnfRDnLCcSA4PrgU7537f52VOcSkIwrQeK+U0JRRRRhH8MWzYTO9AbvCdKYv8WiLQZJCys1stKYNJ2FyFuow+e9l1uCTuDm9/h/MTQdkYsR2kkugKp1mMJlhjhXg+c5veIVT/ERJ+u3yg7d+pIMSiBRK6dQox47QtHpPr4SgcNz38+S4X+Sn8Ifzkva/pESwDpv6eQNSfOhjur79Bvl8noTTVvMHtiYxu5xN5u9hzN3QAl3DkcwsCJnORIn3GLmorR0zRIebokEe9w5rs3IC5xZafZ/bNECL7UVjuJtQTgrY8Hd00Rp1H+RAWooGPeDx5UK+6kqCZZGOUVBNivdQxVL2FVXERebdCMe1XTv1OnAJygpnmb7UF0qt7qq8BYkM3zql//Ec0e+4eLH0i7EC+0UDhRDJsucETXuLY1ZenrhDWjF2u75M/ZbfJkqwgu12u22IuI1aljtz4gwqTr03IusfLokg73eS4eVYOu6v+G6GF5Wen7kA2rfsviMuHdMI1PTLALGIlBM8YHl4HG0gcgEY25WUPzLltKNutZAyUDyGrFduJNnWkPxtfGkfo
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

--===============8001377551619871004==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

> diff --git a/arch/riscv/include/asm/io.h b/arch/riscv/include/asm/io.h
> index 09bb5f57a9d3..6f5d70313c83 100644
> --- a/arch/riscv/include/asm/io.h
> +++ b/arch/riscv/include/asm/io.h
> @@ -56,6 +56,8 @@
>  #define __io_pbw()	RISCV_FENCE(iow, o)
>  #define __io_paw()	RISCV_FENCE(o, io)
>
> +#define PCI_IO_ADDR(addr)	((void __iomem *)((unsigned long)PCI_IOBASE + (addr)))
> +
>  /*
>   * Accesses from a single hart to a single I/O address must be ordered.  This
>   * allows us to use the raw read macros, but we still need to fence before and

Arnd Bergmann raised concerns about this approach in his review of v4
(https://lore.kernel.org/all/3720c3a4-cc0d-4ba8-97ae-35def0189e2e@app.fastmail.com/).

He points out that the NULL pointer arithmetic warnings are actually
useful because they indicate real bugs - NULL pointer dereferences that
will crash the kernel if the driver is ever loaded. The proper fix is to
ensure drivers have 'depends on HAS_IOPORT' in their Kconfig entries.

He suggests removing the custom RISC-V PIO accessors (ins*/outs*)
entirely and using the asm-generic versions instead, which already have
the correct #ifdef checks. This would be a cleaner approach than adding
guards to suppress warnings.

[ ... ]

> diff --git a/include/asm-generic/io.h b/include/asm-generic/io.h
> index ca5a1ce6f0f8..d799e5ccc943 100644
> --- a/include/asm-generic/io.h
> +++ b/include/asm-generic/io.h
> @@ -1205,8 +1205,12 @@ static inline void __iomem *ioremap_np(phys_addr_t offset, size_t size)
>  #define ioport_map ioport_map
>  static inline void __iomem *ioport_map(unsigned long port, unsigned int nr)
>  {
> +#ifdef CONFIG_HAS_IOPORT
>  	port &= IO_SPACE_LIMIT;
>  	return (port > MMIO_UPPER_LIMIT) ? NULL : PCI_IOBASE + port;
> +#else
> +	return NULL;
> +#endif
>  }
>  #define ARCH_HAS_GENERIC_IOPORT_MAP
>  #endif

Is this change necessary? The function definition here is already
guarded by the #ifdef CONFIG_HAS_IOPORT_MAP check, which should prevent
it from being visible when CONFIG_HAS_IOPORT is disabled.


---
AI reviewed your patch. Please fix the bug or email reply why it's not a bug.
See: https://github.com/kernel-patches/vmtest/blob/master/ci/claude/README.md

CI run summary: https://github.com/kernel-patches/bpf/actions/runs/25361792504
--===============8001377551619871004==--


Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AD2A8C5DF87
	for <linux-mm@archiver.kernel.org>; Fri, 21 Aug 2026 11:46:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B66536B009B; Fri, 21 Aug 2026 07:46:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B3DF16B009D; Fri, 21 Aug 2026 07:46:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A543F6B009F; Fri, 21 Aug 2026 07:46:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 7D71C6B009B
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 07:46:05 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 032771C17E2
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 11:46:04 +0000 (UTC)
X-FDA: 85125097890.20.EEC204E
Received: from ewsoutbound.kpnmail.nl (ewsoutbound.kpnmail.nl [195.121.94.168])
	by imf10.hostedemail.com (Postfix) with ESMTP id DDF61C000A
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 11:46:02 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=xs4all.nl header.s=xs4all01 header.b=FT6wv1JU;
	spf=pass (imf10.hostedemail.com: domain of jkoolstra@xs4all.nl designates 195.121.94.168 as permitted sender) smtp.mailfrom=jkoolstra@xs4all.nl;
	dmarc=pass (policy=reject) header.from=xs4all.nl
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787312763;
	b=jiHEfPDEvTU2kNPYC0SE88PWIRxDsMOlmJvh3sfzEn3oShycu02s7xe//foTcas9LZM9Sf
	Y4gf33zeyaljBWN562slXVaQfphkMuD6cVu3/WoN/v2TLruZ7x4DvGfoP6d2e7oC3N0Fy8
	dz7JKfAzv+JpNZwPoJYsOyRfOxE0FJU=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=xs4all.nl header.s=xs4all01 header.b=FT6wv1JU;
	spf=pass (imf10.hostedemail.com: domain of jkoolstra@xs4all.nl designates 195.121.94.168 as permitted sender) smtp.mailfrom=jkoolstra@xs4all.nl;
	dmarc=pass (policy=reject) header.from=xs4all.nl
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787312763;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yFPmgGHt8SfwvN/uEXqWH/wUz0hJJxpKPqJOuk3pBBM=;
	b=dMmIVnOPSANYFQwMp7fe2ZY1CA1nF8jxvDGZ4KT3ga4tTO8SoW1V5KhLQDy3SO32FHsQM6
	x62izKQJ4Mm3Ni5oBb0xddsCLG1EvrfRX9v08iz+PcOL1/JyHlYPstAoxMAu7ybzI5Ig9f
	adjR/VmcXEMAAEbEjW3Lz9gsAY8Ul4Y=
X-KPN-MessageId: e0887a5e-9d55-11f1-861c-005056aba152
Received: from smtp.kpnmail.nl (unknown [10.31.155.38])
	by ewsoutbound.so.kpn.org (Halon) with ESMTPS
	id e0887a5e-9d55-11f1-861c-005056aba152;
	Fri, 21 Aug 2026 13:45:59 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=xs4all.nl; s=xs4all01;
	h=content-type:mime-version:message-id:subject:to:from:date;
	bh=yFPmgGHt8SfwvN/uEXqWH/wUz0hJJxpKPqJOuk3pBBM=;
	b=FT6wv1JU6jQOf5bV++m8gzkkrFKXwb19IJ2LLFJJBSkHg6fo6QZPr/atwQOA2U3Gc/JRbyEPgBFmx
	 v+3vDDX3os3EBiCVrm5SvSDk6GHqU3UP2n+l0PnF/fPzssVg+pJ4b2UmAawi5AIgKAJl6bbsTrRyw8
	 Q9Vz8iPOzJBx8or66RWB/inyQtAzthl2KS85B740TQ3QOlB1AmjKWuMSJ5pra1vhuskR3uYLaja+0Y
	 kkEQzwTToLiECc4CC0Ut35dRnZgnp1of+SowzEf+Eum6ToNdkDYGA5fv6Fig+k6A2WdvHoWS0i8A4w
	 flrh9eH4qCCvVallyLooNYQEQsrzE5Q==
X-KPN-MID: 33|ilEge/h7m+/Q9upzrozFqztLXqy78Hd2ih5BIJCdjBaiAYzReanRBYnKVtch47B
 ejkS4yT9QE1WkDtKF6cBKjcv46OaiHcYjCL2addabmSU=
X-KPN-VerifiedSender: Yes
X-CMASSUN: 33|Q0wP+J6rG6V1Xcmg6XTyqcjJZlrLvJ4+shaI9oPmFiccw69ASds7LUtEE1TGXUm
 yAxT+hnTa5XNQO/cyMcmLHA==
X-Originating-IP: 85.144.169.142
Received: from localhost (142-169-144-85.ftth.glasoperator.nl [85.144.169.142])
	by smtp.xs4all.nl (Halon) with ESMTPSA
	id e061f711-9d55-11f1-bd1e-005056abf0db;
	Fri, 21 Aug 2026 13:45:58 +0200 (CEST)
Date: Fri, 21 Aug 2026 13:45:59 +0200
From: Jori Koolstra <jkoolstra@xs4all.nl>
To: =?utf-8?B?SsOpcsOpbXk=?= Jean <Jeremy.Jean@oss.cyber.gouv.fr>
Cc: kees@kernel.org, viro@zeniv.linux.org.uk, brauner@kernel.org, 
	jack@suse.cz, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] binfmt_elf_fdpic: reject PT_LOAD with filesz larger than
 memsz
Message-ID: <aog5Kx6HB3jxb8cJ@lt-jori.localdomain>
References: <20260820222824.3165092-3-Jeremy.Jean@oss.cyber.gouv.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260820222824.3165092-3-Jeremy.Jean@oss.cyber.gouv.fr>
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: DDF61C000A
X-Stat-Signature: ui4u4mudmfogkn9m1neccdcm8npmjuud
X-HE-Tag: 1787312762-86382
X-HE-Meta: U2FsdGVkX19ST0tm6zL4+Ej4GQ2aOhBxH4YVu3tuajVPb6cg2TbZ91LGOUMlDv/SUGI7PBdwwzbctQgcYVdxmC42QlkJj5060OSXcZES7RdJJUCwao9YQ95j9wVBKqNSFWQ1oFI46UJlDJjcy54q20W2XdptDRJogQMTu0RtToGCTHYISVOv7Qwr9WQI843zE/E/gBHVlaiPgPVf0bt1bx2PoNraHydtBsKV5JUjsDpBH1I1UJKAkYS+26VZduk42O/c2cQEJokXumojLaVLM0CGOgn7796ulpr/eNnDc76s1T8F+UC+No0zhuDS8KoiFlKT7f9WRSQwT3tFpmd1k6IEEG6PRw3LXS9/sGu0r5W8S8ZYZ0VIp7ADXgpS54JfgpYp5nMV7Ik6NXo7y4EwKtYxSZqg44p/gEniToub6HQwqQIJigYyLxEzjh2R7RWZcK1zYdWZ+VOdWKxSbTCPx20ESmwC6zVaCgSiQc9f5i0T7C8UgkQMFgYVCZz9oEjumSUjWcRuwN+/t73L2n12bTBeDSQYjHKAOKJ4uTwOOHMxoMYvEFMHWnhXMxp9tKlw8mcynG2CddAjKZS4QmVIHL8v316m4AdfCzRrdvWh2aIAIsD3Z3P2M3JQ+rqxUOz5mKMcQngDZAZ5XI5pQl+KQJB4vdt/ie0JBhDa4aM4DCsZ8RWUCpkYWP/2s0JNdQfPV2GNh09dQ0ATn65umP9PIVuHwPNPec5OO9iShxk71inxu7l0EeIYoT6Pxf17uThL2OopHBjn4XSyPJBiL3187RhKlYVBFT0Br/LhNyAoBeDHtB50gGW4QGUOe47SpGLedAMCPvsWRxFFGLmXBmUcX3lp2uNwzB42BcP9INkBN5OUuogqrFLSEPnK44JL59mjE3ZwIHUW3QiycLJzbuR72FGLozSxKciO/WI7N92wKOKZqpgAivPDzHcIxFvvUfUgLCPIN3OA0v2cx8gYW7d
 2HbJ8bRp
 h3KK2sQncxsI1NLVvZ+GSG9auexFY4IS9wCAPASM+bMBoBoKnkOWSx3xr167/e5uTBhtaPa72lf8/9HQkTph+7pih9yaacI0/kIKOttq+RUjM3a6dcuabfyQBLFuz29TsXJ6m3Xio7S8PJVCHnKC2KBrfHlyItOE5YGC9wS9ebQIn+NBsN7zysEwZKttIaAOlUdefVw/YT59xVAfjcrxEgFN5g9h7HSmy02tBC4e/bbIEY5sK5obVt5BZVwqpHsSKLWmC1bFHBGOXrGwqWQckLI++A/3cLRDXqxtZr7AWz3U9BHX1IF+qoYVTGhKxIheVK48vzotxIqeUKFXyrjcQGQbF6mZTkUYyQVjSc04zje04yXbTfH+/A1jpSPDKeMEIz7/QmtIRNXpcEgH1T4UMgD8aCmvxbOYJzxKyVnENkM7WrY5EA4Dx4jpPeQ8zZ8UBZtscvYPLCATjaPOzSK0h/zhtRiOb/nAYw79y9ROUa6D1p5gKOSuO1/mc7a1u67fIFtGpJ2e9XJOo0JJSmlTrh7R7TELBL48jGe4za9zpLT1M//LgvKi7uhTuHw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 20, 2026 at 10:28:26PM +0000, Jérémy Jean wrote:
> The ELF specification requires p_filesz to be no larger than p_memsz for
> PT_LOAD segments.
> 
> elf_fdpic_map_file_constdisp_on_uclinux() sizes its contiguous allocation
> from p_memsz, then read_code() copies p_filesz bytes into it. A malformed
> segment can therefore copy file contents past the allocation on NOMMU
> systems. The direct-mmap path also subtracts p_filesz from p_memsz without
> first validating the relationship.
> 
> Validate every PT_LOAD immediately after fetching the program headers.
> This covers both executable and interpreter headers before
> begin_new_exec() makes execution irreversible.
> 
> On RV32 NOMMU, an ET_DYN with an 8192-byte p_filesz and 4096-byte p_memsz
> copied a marker from the second file page past its one-page mapping.
> After this change execve() rejects it with -EINVAL, while an 8192/8192
> control still executes.
> 
> The flaw dates back to the driver's introduction in the pre-git history
> tree introduced in v2.6.11 by 91808d6ebe39 ("[PATCH] FRV: Add FDPIC ELF
> binary format driver").

I came across this about a month ago. But I wonder if this is even worth
fixing. You are on a non-MMU system, so running a malicious ELF kinda
means gameover anyhow, doesn't it?

> 
> Assisted-by: Codex:gpt-5

You are allowed to use LLM assistance, but the commit message also reads
like AI, so I am a bit worried whether you actually understand the
change you are proposing. Afaik, this is still required.

> Signed-off-by: Jérémy Jean <Jeremy.Jean@oss.cyber.gouv.fr>
> ---
>  fs/binfmt_elf_fdpic.c | 6 ++++++
>  1 file changed, 6 insertions(+)
> 
> diff --git a/fs/binfmt_elf_fdpic.c b/fs/binfmt_elf_fdpic.c
> index 068c46875c74..e8a6e89b76a0 100644
> --- a/fs/binfmt_elf_fdpic.c
> +++ b/fs/binfmt_elf_fdpic.c
> @@ -157,6 +157,12 @@ static int elf_fdpic_fetch_phdrs(struct elf_fdpic_params *params,
>  	if (unlikely(retval != size))
>  		return retval < 0 ? retval : -ENOEXEC;
>  
> +	phdr = params->phdrs;
> +	for (loop = 0; loop < params->hdr.e_phnum; loop++, phdr++) {
> +		if (phdr->p_type == PT_LOAD && phdr->p_filesz > phdr->p_memsz)
> +			return -EINVAL;
> +	}
> +
>  	/* determine stack size for this binary */
>  	phdr = params->phdrs;
>  	for (loop = 0; loop < params->hdr.e_phnum; loop++, phdr++) {
> -- 
> 2.47.3
> 


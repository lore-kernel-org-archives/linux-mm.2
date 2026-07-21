Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B3B28C44536
	for <linux-mm@archiver.kernel.org>; Tue, 21 Jul 2026 20:36:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 069F86B008A; Tue, 21 Jul 2026 16:36:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F0D356B008C; Tue, 21 Jul 2026 16:36:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DD5E06B0092; Tue, 21 Jul 2026 16:36:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id AC0E46B008A
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 16:36:41 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 1D555140295
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 20:36:41 +0000 (UTC)
X-FDA: 85013942202.12.39B923A
Received: from ewsoutbound.kpnmail.nl (ewsoutbound.kpnmail.nl [195.121.94.184])
	by imf11.hostedemail.com (Postfix) with ESMTP id B032E40006
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 20:36:38 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=xs4all.nl header.s=xs4all01 header.b="fw4JTd/q";
	spf=pass (imf11.hostedemail.com: domain of jkoolstra@xs4all.nl designates 195.121.94.184 as permitted sender) smtp.mailfrom=jkoolstra@xs4all.nl;
	dmarc=pass (policy=reject) header.from=xs4all.nl
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784666199;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=X6JbNQIATPP5lzRYGP9EC0Lk7v2gUEGWN6HyA1XyIBs=;
	b=e5Un8hko0HlfcQnjmEX5Jka4GpM4lpKFTTeBwa1v2RRr8MuYkBLWGBI9v0tCAjKaMj2qwa
	2/+Y3cnY2fEmXzQmQ2wH7XdSPMUwH6OnH5KVmNVsXDWRs9uhGnTPOEoNcw7LmvdVn021i7
	jsOI9m8teV7fvn704kPFw8w2OdScRZ0=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784666199;
	b=3GDSb1wvj7y43SE6lJjhLhpl9MgyG3ZPplVD6vQUMDGWEcBs6DHQ4VrlXRCHGrVdlikgzx
	ty9XN1Bir7RMzmHon2t52h/cHP4kiPCuc5XXKBZYsAVPvGPc4NCEoyZGije3MTMSoMEhQP
	35vix5Crq0DmZDpTnJL+2bWWKANZVvs=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=xs4all.nl header.s=xs4all01 header.b="fw4JTd/q";
	spf=pass (imf11.hostedemail.com: domain of jkoolstra@xs4all.nl designates 195.121.94.184 as permitted sender) smtp.mailfrom=jkoolstra@xs4all.nl;
	dmarc=pass (policy=reject) header.from=xs4all.nl
X-KPN-MessageId: de161530-8543-11f1-a5a0-005056994fde
Received: from smtp.kpnmail.nl (unknown [10.31.155.8])
	by ewsoutbound.so.kpn.org (Halon) with ESMTPS
	id de161530-8543-11f1-a5a0-005056994fde;
	Tue, 21 Jul 2026 22:36:36 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=xs4all.nl; s=xs4all01;
	h=content-type:mime-version:message-id:subject:to:from:date;
	bh=X6JbNQIATPP5lzRYGP9EC0Lk7v2gUEGWN6HyA1XyIBs=;
	b=fw4JTd/qR7ifxH2fj/4bRz3KVC/QD9f8iYNWW5Q3w8YjOYoFoFe4ZdcHOC3XahpY8VjOIfWJHHbix
	 XD5XiYFNABemP+gEJ5gDD10p2GlkGKoFArYnrqnkeFamt6ikv+qf0UJrjZ1x6jlR1RP3irnfPrbkNU
	 7VCacAMAstMXBntGGZaXwYEw20UpvXGZNHFjmZ3snx8i3ixbr6UttKvLC5uFZBXMxEJZQNJX9fiRSD
	 ZI2phKRqAvsixtMKeqePNMSe4LhwKK026NBQ1fJPx4lkArGyL7VKuVz2LzW8VewpT04zM4x/csvEkZ
	 lPkkZKC/9qy4Wn3Bffmic4C4SEkfVSQ==
X-KPN-MID: 33|/FRaVBBNTpX7oZEbL/WUJwV+obe8QveTmU6qomkjd7Zwy0bDuddoRQ6LhmU9/QC
 +7Nh0UkLCbRlhhU1hxRxRyHX5B0cO19/6jnvbrmmuR1g=
X-KPN-VerifiedSender: Yes
X-CMASSUN: 33|Bt02zkTEX4BovQyofVTpaC6SvmEMyLJr1cMXxpOT5X5aV92dxLfZk6RhnWA+hTi
 9O7uuVJiPiXaYg6l10QxO/g==
X-Originating-IP: 178.231.6.225
Received: from localhost (unknown [178.231.6.225])
	by smtp.xs4all.nl (Halon) with ESMTPSA
	id dde1a5a1-8543-11f1-8dd0-00505699d6e5;
	Tue, 21 Jul 2026 22:36:35 +0200 (CEST)
Date: Tue, 21 Jul 2026 22:37:58 +0200
From: Jori Koolstra <jkoolstra@xs4all.nl>
To: Christian Brauner <brauner@kernel.org>
Cc: linux-fsdevel@vger.kernel.org, 
	Farid Zakaria <farid.m.zakaria@gmail.com>, Daniel Borkmann <daniel@iogearbox.net>, 
	Alexei Starovoitov <ast@kernel.org>, Kees Cook <kees@kernel.org>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>, Jonathan Corbet <corbet@lwn.net>, 
	linux-mm@kvack.org, bpf@vger.kernel.org, jannh@google.com, mail@johnericson.me, 
	stable@vger.kernel.org
Subject: Re: [PATCH] binfmt_elf_fdpic: only honour the first PT_INTERP
Message-ID: <al_MqBrjDW1QjRau@daedalus>
References: <20260721-gezittert-medium-kreide-b41fc1f0277e@brauner>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260721-gezittert-medium-kreide-b41fc1f0277e@brauner>
X-Rspamd-Queue-Id: B032E40006
X-Stat-Signature: yhqak5uirf7nga8dnoe4thu1uj7tzcsz
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1784666198-904485
X-HE-Meta: U2FsdGVkX1/GWT/zRMO//B0VzcDzbkJWPG3WR6Xc0hbVAQwQU1/qkLTJm5q7ARYT6gzOmf//UvoThGqAO2IEWefOXDQRcCLo2oH9XK9qoyHPeg2G1YXR0fdWcyIYVvrrKUjpgCMInxIwsBtzbRydv26zKmC9XM5KLl33gUvyk6s6Mva6FKLkb+tCYp28094r3VLl7FupiUV/C2kXvKzOhGzn/hiwiHr00Zmhig+dUsrTKfcz79VrXAQcYsEvlp6bnj6/Ojz9A2WQ7QW4u5Qwi02UHZ4qf5Gf0CLzbYsg0LaZc19BZbONsho9oWAHjdvvgIwmpgRMwrboh177y90PZOgQvDT9MGzubEGKimiO6fa/CCcZ3AnVvjVtQW6gSUBcKMseskSGaO005/gdPt9iqEt8Sr3Yto1MqjFQo4PiO+NyvLCBAKNkd4t3NOqWCZC/L6WMJCzHpTku1rI5CVvE/L1lQqoIjPe9RErkV0i5/+txWKlk28GRgtWOTZ+CPXbink6vZnxaMdIYlQZ8TlWNRuIuyz8r3QvA95ammE7+TzcEip+ETvjNoY9iaAN63rC4+2qqvufcevw11wI3Ngqb+nBehYFEOkuETndAnxQuWG3+flFaQ9evCEl0GaJbL1GtpHLy/wKabQCPcj42XFXy5RMn71JCquFGn7vxzPivAR1WcOz4ppdrtN2PwsCYJKVpaMYJwpspGhqgQYHOuQ3uQYIkL93xV5Nvf1gpKMVSrz2ZKbnC6sRpRXOd6NMtJMhEd+HoHd5b2ZPF7nsXs9e55uWhgWfNDB2lsa4JZ7mNL0jD0gThfUz7HTCA1JevOF+0SatBa+ZQGZlYOtR6q/GnwzDvgLBkzfo4hmabTTGuHoxKmlTWIPH7/eHHRo1g3UeHJLwZWS3HlqXtGX9YuG0YqxnlZDn6E1chycuFkerS6Ppbdkyc56/vAu1eVNVG+QL35a+8FlVm/oO5/E35/Rb
 F1RjvOw2
 8ma+uGywG+B4ZqytCsTk2Ybzjgad3IWGZ3Iprf8pC9SNKj9JrLUV29wvaOv+19St/o/4KatF79jfSNwufUftc5cc2PqLIkiu96IwfU7p10H+mtgbJraPdYP0EKE7iDI9jKEQfY/vjM3ivS86D1P8OD020K71FwVUycifr2qdE82DggpF36X0E7oByYaocMg/LpHArBLouXyEfT3c44x2Jxb3LTRC+mlVP+1BEeYo2nr0FD5ylwuBLUga8TkjRoSt0DJGkmXmaTuMZwk9F5sYQqeUM5ADggIZvJopD6s7ahrIkSTQwqzSsZkFi/xBdqgqJ8zrLyhfKCC5CjyWNgXPKZ2dZ9LFwPfTLYtcICCZ0zYEERYgbs9ZKN9M+9872bVFmAXhszW84ey0XYaS4kJoMeUO8LETER30iGexrcrJanR88HcMGBGfIWDNxTVbUjVdO+u4qPw+JecjfSSyHGJGVuMzLaVSEshGoPEVJVj3zwCsTOhtomFlAO/nID/znhQJ6Bev3PINhtrJGZDkQiC0RwVynlspklMY3yNPlc4Lr6Tl26Gqr61A5/NNQ/XOBHuJhbV+KFV04QGVkSVb4e42S87N/QUHtynnBPzLA1RYjxHA8v3C+sDPTF/2z1g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jul 21, 2026 at 01:20:45PM +0200, Christian Brauner wrote:
> The program header scan handles PT_INTERP from a switch nested in the
> scan loop, so its break leaves the switch and not the loop. A binary
> carrying more than one PT_INTERP runs the case again and overwrites both
> interpreter_name and interpreter. The previous name allocation leaks and
> so does the previous interpreter reference, along with the write denial
> open_exec() took on it. The denial is never released, so the file stays
> unwritable for as long as the system runs.
> 
> An unprivileged caller reaches this with a crafted binary and repeats it
> at will. binfmt_elf stops at the first PT_INTERP. Do the same here.
> 
> The flaw dates back to the driver's introduction in the pre-git history
> tree introduced in v2.6.11 by 91808d6ebe39 ("[PATCH] FRV: Add FDPIC ELF
> binary format driver").
> 
> Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
> Cc: stable@vger.kernel.org
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
> ---
>  fs/binfmt_elf_fdpic.c | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/fs/binfmt_elf_fdpic.c b/fs/binfmt_elf_fdpic.c
> index 7e3108489c83..fe0b5c5ed2bc 100644
> --- a/fs/binfmt_elf_fdpic.c
> +++ b/fs/binfmt_elf_fdpic.c
> @@ -231,6 +231,10 @@ static int load_elf_fdpic_binary(struct linux_binprm *bprm)
>  	for (i = 0; i < exec_params.hdr.e_phnum; i++, phdr++) {
>  		switch (phdr->p_type) {
>  		case PT_INTERP:
> +			/* elf ABI allows only one interpreter */
> +			if (interpreter_name)
> +				continue;
> +
>  			retval = -ENOMEM;
>  			if (phdr->p_filesz > PATH_MAX)
>  				goto error;
> -- 
> 2.53.0
> 

Good catch.

Reviewed-by: Jori Koolstra <jkoolstra@xs4all.nl>

Btw, it seems that elf_fdpic_map_file_constdisp_on_uclinux() has no
check to verify that phdr->p_memsz >= phdr->p_filesz, despite elf(5)
saying that

	The file size may not be larger than the memory size.

Afaict, currently read_code() may blow past what vm_mmap() allocated
there, which may result in memory corruption for a non MMU system. This
is an LLM assisted find, and it may be that I missed something when
verifying. If you agree this is wrong, I'll fix it.

Thanks,
Jori.


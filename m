Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9F7C1606A8BF
	for <linux-mm@archiver.kernel.org>; Thu, 12 Nov 2026 11:30:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=dHY9/lJM
Received: by kanga.kvack.org (Postfix)
	id C24176B05B8; Thu, 12 Nov 2026 06:30:45 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BD4AF6B05BA; Thu, 12 Nov 2026 06:30:45 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AC41C6B05BE; Thu, 12 Nov 2026 06:30:45 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 8826E6B05B8
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 06:30:45 -0500 (EST)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 1D16DC053B
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 11:30:45 +0000 (UTC)
X-FDA: 85426249650.08.DC6050A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf10.hostedemail.com (Postfix) with ESMTP id 77CD7C0003
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 11:30:43 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=fail ("headers rsa verify failed") header.d=kernel.org header.s=k20260515 header.b="dHY9/lJM";
	spf=pass (imf10.hostedemail.com: domain of bot+bpf-ci@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=bot+bpf-ci@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794483043;
	b=TuV6AEIWjFESZ0GZXVj6cp8L9nOA+3t1lkHx01JZu5WH+vrJo8quL3aM4G1Vb1frFcp3kn
	QOP8VrxyzhvyIDC9CJwiCgvVoFRKDVQ8tn2ynffqSm0c4et/9N2jBEriUzCEpUV05/zln7
	3smop9jPOTwjfO3bnEmSm1e5frDorMg=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=fail ("headers rsa verify failed") header.d=kernel.org header.s=k20260515 header.b="dHY9/lJM";
	spf=pass (imf10.hostedemail.com: domain of bot+bpf-ci@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=bot+bpf-ci@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794483043;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TH0+wCv5ifM8REH9nQg/3agFqlZ5DUFIscm/3LxWRo0=;
	b=D6HTKCvJAfpaagckMTfa3Yg1l6ZDPWBGpIen8+nVDm2zl95BE1tVlGKH60O+RFip5qOWkx
	KfTBcuUJkugr+E7oJWNTppXM9u+xTlr3BuORNBnhoZTAX8h2Rk9t7EWn1YbMGvvLEvLc1l
	ZMF2x9H19RrbBziLX2jgTddcjTAOroU=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id B582E4180A;
	Thu, 12 Nov 2026 11:30:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 797931F00A0B;
	Thu, 12 Nov 2026 11:30:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794483042;
	bh=TH0+wCv5ifM8REH9nQg/3agFqlZ5DUFIscm/3LxWRo0=;
	h=In-Reply-To:References:Subject:From:To:Cc:Date;
	b=dHY9/lJMFRTkdoK0UtBygoZvi0viJvrQDXFX2s5FvKi786pb0Fxhon1g90q0LAJNn
	 PENqDFIZIbjRAr6env65rzcSprlxQbjXkDe0p4+7/+w1cPdM9UvcoaclCxkmEnvx/L
	 oE9DKvkZ2ClL78AeiJ7MU1YcU2e6+Dliu2fKS7trzQcaY8LOeI391uTkm+viM/MxVy
	 WDMDLV/0R+iz9jXmxmDqgcXL1XCSVSjY8aMO+Og+0+8IwKBzCv70WgbblclOZGVhak
	 6d/l5yZ3gEYyAKuzNgCi7t9AcEuUPoxh/sg66l5EHUZ40X4td6nIxtPKl+gGBVsMFH
	 3yeE/40xoNEGw==
Content-Type: multipart/mixed; boundary="===============1184916852212940912=="
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Message-Id: <a0cf14f466cffe1ae1e1138e7ea4466152c96c1b89ba8268a5923a0d13534f28@mail.kernel.org>
In-Reply-To: <20261112104149.38589-6-cuiyunhui@bytedance.com>
References: <20261112104149.38589-6-cuiyunhui@bytedance.com>
Subject: Re: [PATCH v10 5/9] riscv: implement preemptible this_cpu add_return operations
From: bot+bpf-ci@kernel.org
To: cuiyunhui@bytedance.com, pjw@kernel.org, palmer@dabbelt.com,
	aou@eecs.berkeley.edu, alex@ghiti.fr, dennis@kernel.org,
	tj@kernel.org, cl@gentwo.org, oleg@redhat.com, ast@kernel.org,
	daniel@iogearbox.net, andrii@kernel.org, eddyz87@gmail.com,
	memxor@gmail.com, martin.lau@linux.dev, song@kernel.org,
	yonghong.song@linux.dev, jolsa@kernel.org, emil@etsalapatis.com,
	ihor.solodrai@linux.dev, bjorn@kernel.org, pulehui@huawei.com,
	puranjay@kernel.org, broonie@kernel.org, cuiyunhui@bytedance.com,
	dave@stgolabs.net, david.laight.linux@gmail.com, jszhang@kernel.org,
	tglx@kernel.org, conor.dooley@microchip.com, thuth@redhat.com,
	ajones@ventanamicro.com, ben.dooks@codethink.co.uk,
	rkrcmar@ventanamicro.com, samuel.holland@sifive.com,
	zong.li@sifive.com, debug@rivosinc.com, seanwascoding@gmail.com,
	andybnac@gmail.com, menglong8.dong@gmail.com,
	cyrilbur@tenstorrent.com, wangruikang@iscas.ac.cn,
	atishp@rivosinc.com, apatel@ventanamicro.com, arnd@arndb.de,
	nathan@kernel.org, nick.desaulniers+lkml@gmail.com, morbo@google.com,
	justinstitt@google.c, om@kvack.org, qingfang.deng@siflower.com.cn,
	linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, bpf@vger.kernel.org, linux-arch@vger.kernel.org,
	llvm@lists.linux.dev
Cc: ast@kernel.org,andrii@kernel.org,daniel@iogearbox.net,martin.lau@kernel.org,eddyz87@gmail.com,yonghong.song@linux.dev,mason@kernel.org,ihor.solodrai@linux.dev
Date: Thu, 12 Nov 2026 11:30:37 +0000 (UTC)
X-Stat-Signature: 3s8kmdysqene3ws6ob3f9guhqrxnhdji
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 77CD7C0003
X-Spam-Status: No, score=-13.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794483043-972254
X-HE-Meta: U2FsdGVkX1/rJAkPaQvuf3lEXKjgxcqRoY1o4vhQ/Iph1kwfZ6jdG0KdEyFKbJ1QXhrVw386YaHv2qjzkbR4Yt3SoNtV4WlFo9QxjWlk6Qkf/yxxTkvgCqlMPUi3XJVky4hm0swRikJqkMwgR9t6dHtvY2rymswuaVsAJLX5Psnk3Lpvxdu52lGHV9rHdwvvQPdSd/y57eOZ/lUQc397wT8S2V+Em1l9xrXMgW38hs280wBoMhVDLls/9b3D1i8QZMRmoYVVVj63x2dFL124OXXZvee9nR7NY4V+a5kYtgKd5jC/QYIf/Z5M+QXaCCbf7muoGHQ1zOrhN2NC+SptkxwF5YtZT3fa/yPKl5zYCLxernHvdt/Zd2HsuzhGfTAKX1FimzEi7bcB/2TlVlMi6Q07cocXwqL8VzsorXRhRXrZ57RxKQLyyJf2lggOC2Pxp+0YoD+8hbK+5c62FNUVyKCPOqYxa/+3OcSnQbyQ6uOujTi2+gAEca8ag3NdrqKa7IdkXIUixbakwIP5yMQXsGLUCnn5wBIJ4htmFdmSYZ56r4Yn0H8x10pyX8ch0NxRBTiT5oo2y3dGUN8bDChiDNJ/cEjyoyISFFdN0SYsJjA47a5CulS+sFHnnQlFZsLjpfNBm/B2Uabc+lZtk3QIVeb91n9qon17m1VK2B22pRO9dchl3Qo+DD/qRMUu/9r6QaSvPqdv9nzNgsd4yeXPM5Ct/5IUisXNqNTVj8/WOTxt3mibZhjKurs8Ff/1x1RQkbjrpd+2dVFxvYWTiAgIfL9Gu0/5tYAO1ScypcXWQ9WEHlHNZYvyX4hFAfZ/P+ThSYPtwF8V4keZUWXEWI//WmniszHP0UDQspYhUsbik5+ndgI9omxqDLnJZ2HsFLb3q7VZrEuLI9SNXFjHIEaqTsQv/twkjoYXrEEFvH0fmpPk/nwdJDcdNbrkQsRuxPYK6AmJqI0tTq2lY/Y0848
 rakBwxZU
 ByyR2Ua8OMNUDeRbBNBF8hdmhVMWM73OIDI7ywd6ksw2vPJFCHoHSqojRyClJiQmfPchHwBlyYYgwL00hgXecl+/0MO991o/NjB+Vd2WAYKEB2/YLohXlGwRc7kjF6ZO+KDb+uvov/bH0i0fP9u8xrg69OgXBwDR2/5HXpI00djaSY6LUYwUbwbiUdfCHQA0QV6sb9PtJeIP35dfsuLbxXldzeQhKQqOtYg6GtP3v3CZ1Rn8Km1FjUICkrkmgno0rQHPYVpsr0rpvQLTIoG+6w91NtfvveCJsc1aVLAMlQOu5KKwjlg1Ck9gb7JCu8cksgsP+78tPLTiNa63qKFTn7lwm1/t+4ibzdCHoeZRfvtYUCk5AyelhPlnlSAcAXCKh9K/4YHc4Fpkyizn3yY4KNqf/Kdi4xDCdgBIfkq92+yxESFgnrHYQc4ZZY9RaIHUS4GuMrNgAVWZmxAiSa0gSreDWHEMFEBCytTP6hzD7lvAOZ9rHNJqOq4lcvFe89duvvBGSS0emsjbDMaGRgcyl8xUGT8/cI2RxV+L+pzH8QalI8xXcodcDH7LwlJbNky+bab5a0UPvuper4DQap9GzcMPc8BCawJltTVtyA5KG1P+QvrZzUEQiYNBmwe9hYDUzmpEp
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

--===============1184916852212940912==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

> riscv: implement preemptible this_cpu add_return operations

TL;DR: Nit only: the riscv this_cpu add_return helpers duplicate the 32/64 and
8/16 code and the field mask; could they use the existing macro-generated
pattern like neighbouring ops? Not a bug.

> diff --git a/arch/riscv/include/asm/percpu.h b/arch/riscv/include/asm/percpu.h
> --- a/arch/riscv/include/asm/percpu.h
> +++ b/arch/riscv/include/asm/percpu.h

[ ... ]

> +static __always_inline u32
> +__percpu_add_return_amo_case_32(void __percpu *pcp, unsigned long val)
> +{
[ ... ]
> +	return ret + (u32)val;
> +}
> +
> +#ifdef CONFIG_64BIT
> +static __always_inline u64
> +__percpu_add_return_amo_case_64(void __percpu *pcp, unsigned long val)
> +{
[ ... ]
> +static __always_inline unsigned long
> +__percpu_add_return_8_16(void __percpu *pcp, unsigned long val,
> +			 unsigned int bits)
> +{
> +	__PCPU_OP_CONTEXT();
> +	const u32 field_mask = GENMASK(bits - 1, 0);

This isn't a bug, but the add_return helpers repeat code that the rest of
this header generates with macros.

__percpu_add_return_amo_case_32() and __percpu_add_return_amo_case_64() are
identical apart from the width and the .w/.d suffix.  Inside
__percpu_add_return_8_16(), the amoadd.b and amoadd.h asm blocks are
identical apart from the suffix and the (u8)/(u16) casts.  The field mask is
rebuilt with GENMASK(bits - 1, 0) even though PERCPU_8_16_GET_MASK(sz)
already exists.

The neighbouring __PERCPU_AMO_OP_CASE and __PERCPU_8_16_OP_CASE helpers take
the width and suffix as macro parameters.

Could the add_return variants be generated the same way (taking sz/sfx, and
using PERCPU_8_16_GET_MASK), so the 32/64 and 8/16 copies don't need to be
kept in sync by hand?


---
AI reviewed your patch. Please fix the bug or email reply why it's not a bug.
See: https://github.com/kernel-patches/vmtest/blob/master/ci/claude/README.md

CI run summary: https://github.com/kernel-patches/bpf/actions/runs/43205409812
--===============1184916852212940912==--


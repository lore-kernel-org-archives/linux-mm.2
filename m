Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AF63C606A333
	for <linux-mm@archiver.kernel.org>; Sun, 22 Nov 2026 00:10:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=hmQ6M1rL
Received: by kanga.kvack.org (Postfix)
	id 9548E6B05B4; Sat, 21 Nov 2026 19:10:58 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 905966B05B5; Sat, 21 Nov 2026 19:10:58 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 81B886B05B6; Sat, 21 Nov 2026 19:10:58 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 3B3316B05B4
	for <linux-mm@kvack.org>; Sat, 21 Nov 2026 19:10:58 -0500 (EST)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 9EF3B1C3F2B
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 00:10:57 +0000 (UTC)
X-FDA: 85460824554.27.2D825FB
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf19.hostedemail.com (Postfix) with ESMTP id 075B01A0004
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 00:10:55 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=hmQ6M1rL;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795306256;
	b=vPKErNIkYFM96BNrq/UQST1bdfJd6IXIQn3W6Q3hT68OLegJDuP9TOPofmfFj1cCXJOlS4
	wtwpKatPHTabNJ9O7oVRbRfcd0qGpfhMyo4yp3CfEW/XN0ULt5XNrsMYB8s3He3WdvsVhr
	DIX6BYH86tqca6PU9SF2jYF01mc62Qg=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795306256;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YDEZd+115v43bK/wr1bFRFbeszstBTRa8ACq9ULnBOQ=;
	b=Y7iKMBAtuSkrdPUbyhyNkF0JLkLY8JcqA/HJ3RERxkQYIR4D82kSS4hrezcRh3KURhL1Ex
	CxVx9kCm1c+/7M5zvtwGqCo4H2zzTN609O2B8cgTME8XRNzMV2BJ02XvIBsBnHq9Z94G6i
	pMXYRwfevNZhpb3z18maveSYzoECbuQ=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=hmQ6M1rL;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 9629861CE8;
	Sun, 22 Nov 2026 00:10:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92C891F000CF;
	Sun, 22 Nov 2026 00:10:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795306255;
	bh=YDEZd+115v43bK/wr1bFRFbeszstBTRa8ACq9ULnBOQ=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=hmQ6M1rLHKpTRjaiNNMLGrsaKJqArrTdAIZHfM02sku8F0ZjI8WUlH/htwPRyVHiV
	 6J2gJCV9NGDIDz+MXqdWZn54l5m/XHgxjR6Hh3d288WFHZE7NKyJZp5KdJh37gR2Pq
	 hk+jpRhaxE38e8Frx0gR/HV0Ll3J+YIHWMTbq/GWWZHjhg2X0Sa2I40Gdmu8y7KeN1
	 MhiNS1BmCv9gTa1a4SMZjQr0UfK0jE0aTGYSZk3gFxoXlYFlPyVfdN/Fr8vpSH06hh
	 zYCLrix19edCmqV8fuNQymk1dJv325KAGzKikRAR93Z3aOTflr3rwIgOmOuhTQVL7i
	 cWQBIgLoFBc1g==
Message-ID: <sashiko-outbox-227538@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [RFC PATCH v5 03/25] arch: Wire up userns_set_idmap() system
 call
Reply-To: sashiko-reviews@lists.linux.dev
To: "Jarkko Sakkinen" <jarkko@kernel.org>
Cc: linux-mm@kvack.org, linux-security-module@vger.kernel.org, "Alexander
 Mikhalitsyn" <alex@amutable.com>, "Alexander Viro" <viro@zeniv.linux.org.uk>, "Andy
 Lutomirski" <luto@amacapital.net>, "Christian Brauner" <brauner@kernel.org>, "David
 Howells" <dhowells@redhat.com>, "Jan Kara" <jack@suse.cz>, "Jonathan Corbet" <corbet@lwn.net>, "Josef
 Bacik" <josef@toxicpanda.com>, "Kees Cook" <kees@kernel.org>, "Neal Gompa" <neal@gompa.dev>, "Paul
 Moore" <paul@paul-moore.com>, "Serge Hallyn" <sergeh@kernel.org>, "Zygmunt
 Krynicki" <zygmunt.krynicki@canonical.com>
In-Reply-To: <20261121000844.1863324-4-jarkko@kernel.org>
References: <20261121000844.1863324-1-jarkko@kernel.org>
 <20261121000844.1863324-4-jarkko@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sun, 22 Nov 2026 00:10:54 +0000
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 075B01A0004
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Stat-Signature: 5kqs5a9jcaymb64ihbw4h9rtccdkjaz7
X-Rspam-User:
X-HE-Tag: 1795306255-637385
X-HE-Meta: U2FsdGVkX19zpbceiIjKd8iLBmsbFFlTvqBlAfW74ijKXGikpaf5QMqh3Zoct3sMiF2x0aqRBdUcszP/oosgkPk1NcYbRAlM/rE+LeVpzcrCsY8MdFfvCibtwsiRPkpZlUhcjlk2f7q84zhhUhm3v3OUpzHo6xvEa/8mUsHtre2tAJFwAffPVxs3eqjLBqiCeXx3bkHKRSsGAnBdq9G4yo0ILIkz3dKuRhRNx9TOmGbAy3CRBVUh5c63/5TVAS+HDNEa07Iroqq74Ar9+pcGFgy1RN6dHafDUopzhharTHJB6TW2MDlTRT8h5WwcgVdth/7wnvF4+G8SF6oV9ufZaaOQYJtadnBh0tFWP2s+VP8A1P+JSwBtGzARJipu2pqFRdiQClSCREoGA3D2I4D92e0ql1heZpZ31p/F3mL9SrNpikKWqNOEUh5lfkcxRUzCGBe5EAa3ZWQXINsk+Aes6QCMeSBzLpwOjHB4TZqSHrFlP/OnFu5ZKn347AsOtu7xJUMqlDEXUq99U/4CndeATdL4Jwu+n8wCTlBZltBbJLbRPyhVYv5zd51HdyTPraUyFAVv+pTxsug/aOWkZq526MpIXF6bK0piQ7vwD78fcOOflwbESX6mYOtEkedJbTsvBq+ssDT0QoljyFOBfWAzslMHkPj0ll/UwypP+glhGntJBxFNg+yfINymIvtAfonAzr6yTv1O0aTKycTTLYK6pM9KPeMM8PeuRMWBZItRKzD0NWhq7qrhlgG6yRTRhi8j5khiUfTbqY99/sQ0esfMo+k7Mus87acLtLCwIL/wtmEmgtl6Q/Z5rshICSoOZLN+c8dcZjXbUyFiw83DvoinH/WjeeUf3Ihxp6ssriQUFNMlWLymrW+TZ4C5mFRDAuI2yLT1SxCvk+x6k4S3OAtRVT+spBeOA8BCLHBk4auvOWv9VcMg+URCpMOOnJNuQoNOyRRyRQdmtxlAKhJDcDU
 qMk+MWUL
 T8lzQ7tJb5zCCaQZOR4nqWoUPUpGizFl4uhOlPPUX7f2DOm9HN+vDGNetAZs64JfStVMpl3tFCEPyUBjasE2QapyQI8uZKFlVhAicc9vpe0fFMxxioDZGK4/TIUEL4GuSXLw9yTcMFnSa1qyvof9KvPCgcG+1qkJdSgn6vF84YyGop5NN+WYHfJ70xCsf3H6zwI1t6a3toTUrXMXD0c38gGJ+4PGQhNkfBeOcfNmoBB/JDTvmHazp399Jcd9QYjBzdHmKKabrbbUwViKDwIue5JWN5CgCD1ZmZl1FMmoys9vN08YGmbQCqqiDafv3aHIoWmeq0d/dJek9TPz1cGmoM0Ev/wO5hKBp6mdJUrERI+dGlMQzEl+G0dniDCskdQbzsEqHkY6pG/RcFQZa4W4qyiyUtgGD/PBad8C4AaaypSi8H/2uR97X+qRId0m7TVrByC4uR/zJTKFhPswMOPncWMAnd2U8/KngDOqBFWFX/VrHxrb8mERQuMhRfZ1MPLVtBN32RqKKOeXT/WCunTeMSle2HlylKK0DVofP0YwhviIDNHqd9DsABOsnyPguAs7MuSuqNQll71e83xOwIaOSSvjvYZjJ9rFutRx5DVvLxae6jj5zeN7F13rV2cG9e4nw0Bt9DiS71mEgBZNQyrhWejPyfYcAkrkE3AqgZFs+XjtnMnP87s218x+xUXI5Gk+oppxJoM09VEST7jm3uEHy2zVDwEKmxKzz4PJz7eTYmHI+We6Cu+4SIWeDGuC3tyW+3DdoScmVBaHgWPLCy68CFKoN/zNX0doGtvt977yebIAcsWuM4XNZym6l3JfgcF1PT1iNclLWVsIPLEOUnKcyluKgGmh82kIiTh1Rco8gAtXwYR8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential
issue to consider:
- [High] arch: duplicate sys_ prefix in syscall.tbl for
  userns_set_idmap()
--

commit 830eeaaedd55436f6eba477c154843b0a257eb5d
Author: Jarkko Sakkinen <jarkko@kernel.org>

arch: Wire up userns_set_idmap() system call

This commit wires up the userns_set_idmap() system call across the
architecture syscall tables and include/uapi/asm-generic/unistd.h.

> diff --git a/arch/alpha/kernel/syscalls/syscall.tbl b/arch/alpha/kernel/s=
yscalls/syscall.tbl
> index 52e3538cc7df4..9384d59a44dcd 100644
> --- a/arch/alpha/kernel/syscalls/syscall.tbl
> +++ b/arch/alpha/kernel/syscalls/syscall.tbl
> @@ -512,3 +512,4 @@
>  580	common	listns				sys_listns
>  581	common	rseq_slice_yield		sys_rseq_slice_yield
>  582	common	fchroot				sys_fchroot
> +583	common	userns_set_idmap		sys_sys_userns_set_idmap
> diff --git a/arch/arm/tools/syscall.tbl b/arch/arm/tools/syscall.tbl
> index 55717ed32c27e..6130366b76812 100644
> --- a/arch/arm/tools/syscall.tbl
> +++ b/arch/arm/tools/syscall.tbl
> @@ -487,3 +487,4 @@
>  470	common	listns				sys_listns
>  471	common	rseq_slice_yield		sys_rseq_slice_yield
>  472	common	fchroot				sys_fchroot
> +473	common	userns_set_idmap		sys_sys_userns_set_idmap
> diff --git a/arch/arm64/tools/syscall_32.tbl b/arch/arm64/tools/syscall_3=
2.tbl
> index df2d1d82fb3cc..3fcc7899fd087 100644
> --- a/arch/arm64/tools/syscall_32.tbl
> +++ b/arch/arm64/tools/syscall_32.tbl
> @@ -484,3 +484,4 @@
>  470	common	listns				sys_listns
>  471	common	rseq_slice_yield		sys_rseq_slice_yield
>  472	common	fchroot				sys_fchroot
> +473	common	userns_set_idmap		sys_sys_userns_set_idmap
> diff --git a/arch/m68k/kernel/syscalls/syscall.tbl b/arch/m68k/kernel/sys=
calls/syscall.tbl
> index ba7a4d8903d04..5607635bd4bd7 100644
> --- a/arch/m68k/kernel/syscalls/syscall.tbl
> +++ b/arch/m68k/kernel/syscalls/syscall.tbl
> @@ -472,3 +472,4 @@
>  470	common	listns				sys_listns
>  471	common	rseq_slice_yield		sys_rseq_slice_yield
>  472	common	fchroot				sys_fchroot
> +473	common	userns_set_idmap		sys_sys_userns_set_idmap
> diff --git a/arch/microblaze/kernel/syscalls/syscall.tbl b/arch/microblaz=
e/kernel/syscalls/syscall.tbl
> index 76d7cbe2a133c..97ee93f42fac2 100644
> --- a/arch/microblaze/kernel/syscalls/syscall.tbl
> +++ b/arch/microblaze/kernel/syscalls/syscall.tbl
> @@ -478,3 +478,4 @@
>  470	common	listns				sys_listns
>  471	common	rseq_slice_yield		sys_rseq_slice_yield
>  472	common	fchroot				sys_fchroot
> +473	common	userns_set_idmap		sys_sys_userns_set_idmap
> diff --git a/arch/mips/kernel/syscalls/syscall_n32.tbl b/arch/mips/kernel=
/syscalls/syscall_n32.tbl
> index 9ae88e4eac61e..da4ed57a91d3b 100644
> --- a/arch/mips/kernel/syscalls/syscall_n32.tbl
> +++ b/arch/mips/kernel/syscalls/syscall_n32.tbl
> @@ -411,3 +411,4 @@
>  470	n32	listns				sys_listns
>  471	n32	rseq_slice_yield		sys_rseq_slice_yield
>  472	n32	fchroot				sys_fchroot
> +473	n32	userns_set_idmap		sys_sys_userns_set_idmap
> diff --git a/arch/mips/kernel/syscalls/syscall_n64.tbl b/arch/mips/kernel=
/syscalls/syscall_n64.tbl
> index 83dc93a0712f1..5e9839b6b3891 100644
> --- a/arch/mips/kernel/syscalls/syscall_n64.tbl
> +++ b/arch/mips/kernel/syscalls/syscall_n64.tbl
> @@ -387,3 +387,4 @@
>  470	n64	listns				sys_listns
>  471	n64	rseq_slice_yield		sys_rseq_slice_yield
>  472	n64	fchroot				sys_fchroot
> +473	n64	userns_set_idmap		sys_sys_userns_set_idmap
> diff --git a/arch/mips/kernel/syscalls/syscall_o32.tbl b/arch/mips/kernel=
/syscalls/syscall_o32.tbl
> index 9c62429c9b7b4..290c1b61be47d 100644
> --- a/arch/mips/kernel/syscalls/syscall_o32.tbl
> +++ b/arch/mips/kernel/syscalls/syscall_o32.tbl
> @@ -460,3 +460,4 @@
>  470	o32	listns				sys_listns
>  471	o32	rseq_slice_yield		sys_rseq_slice_yield
>  472	o32	fchroot				sys_fchroot
> +473	o32	userns_set_idmap		sys_sys_userns_set_idmap
> diff --git a/arch/parisc/kernel/syscalls/syscall.tbl b/arch/parisc/kernel=
/syscalls/syscall.tbl
> index 88adc4016cce0..fc0fa917eb92a 100644
> --- a/arch/parisc/kernel/syscalls/syscall.tbl
> +++ b/arch/parisc/kernel/syscalls/syscall.tbl
> @@ -471,3 +471,4 @@
>  470	common	listns				sys_listns
>  471	common	rseq_slice_yield		sys_rseq_slice_yield
>  472	common	fchroot				sys_fchroot
> +473	common	userns_set_idmap		sys_sys_userns_set_idmap
> diff --git a/arch/powerpc/kernel/syscalls/syscall.tbl b/arch/powerpc/kern=
el/syscalls/syscall.tbl
> index cfbb70039ff00..d12e49022b235 100644
> --- a/arch/powerpc/kernel/syscalls/syscall.tbl
> +++ b/arch/powerpc/kernel/syscalls/syscall.tbl
> @@ -563,3 +563,4 @@
>  470	common	listns				sys_listns
>  471	nospu	rseq_slice_yield		sys_rseq_slice_yield
>  472	common	fchroot				sys_fchroot
> +473	common	userns_set_idmap		sys_sys_userns_set_idmap
> diff --git a/arch/s390/kernel/syscalls/syscall.tbl b/arch/s390/kernel/sys=
calls/syscall.tbl
> index 1b45e68a217bb..dc427811d30d7 100644
> --- a/arch/s390/kernel/syscalls/syscall.tbl
> +++ b/arch/s390/kernel/syscalls/syscall.tbl
> @@ -399,3 +399,4 @@
>  470	common	listns				sys_listns
>  471	common	rseq_slice_yield		sys_rseq_slice_yield
>  472	common	fchroot				sys_fchroot
> +473	common	userns_set_idmap		sys_sys_userns_set_idmap
> diff --git a/arch/sh/kernel/syscalls/syscall.tbl b/arch/sh/kernel/syscall=
s/syscall.tbl
> index ace068dff0de0..e62ac9acc7ada 100644
> --- a/arch/sh/kernel/syscalls/syscall.tbl
> +++ b/arch/sh/kernel/syscalls/syscall.tbl
> @@ -476,3 +476,4 @@
>  470	common	listns				sys_listns
>  471	common	rseq_slice_yield		sys_rseq_slice_yield
>  472	common	fchroot				sys_fchroot
> +473	common	userns_set_idmap		sys_sys_userns_set_idmap
> diff --git a/arch/sparc/kernel/syscalls/syscall.tbl b/arch/sparc/kernel/s=
yscalls/syscall.tbl
> index 5b9fe0e8140f2..df074bf322c41 100644
> --- a/arch/sparc/kernel/syscalls/syscall.tbl
> +++ b/arch/sparc/kernel/syscalls/syscall.tbl
> @@ -518,3 +518,4 @@
>  470	common	listns				sys_listns
>  471	common	rseq_slice_yield		sys_rseq_slice_yield
>  472	common	fchroot				sys_fchroot
> +473	common	userns_set_idmap		sys_sys_userns_set_idmap
> diff --git a/arch/x86/entry/syscalls/syscall_32.tbl b/arch/x86/entry/sysc=
alls/syscall_32.tbl
> index 2c172ef48dfd3..243a3f55834dd 100644
> --- a/arch/x86/entry/syscalls/syscall_32.tbl
> +++ b/arch/x86/entry/syscalls/syscall_32.tbl
> @@ -478,3 +478,4 @@
>  470	i386	listns			sys_listns
>  471	i386	rseq_slice_yield	sys_rseq_slice_yield
>  472	i386	fchroot			sys_fchroot
> +473	i386	userns_set_idmap	sys_sys_userns_set_idmap
> diff --git a/arch/x86/entry/syscalls/syscall_64.tbl b/arch/x86/entry/sysc=
alls/syscall_64.tbl
> index d5b6045b0090c..f11700e3af657 100644
> --- a/arch/x86/entry/syscalls/syscall_64.tbl
> +++ b/arch/x86/entry/syscalls/syscall_64.tbl
> @@ -397,6 +397,7 @@
>  470	common	listns			sys_listns
>  471	common	rseq_slice_yield	sys_rseq_slice_yield
>  472	common	fchroot			sys_fchroot
> +473	common	userns_set_idmap	sys_sys_userns_set_idmap
> =20
>  #
>  # Due to a historical design error, certain syscalls are numbered differ=
ently
> diff --git a/arch/xtensa/kernel/syscalls/syscall.tbl b/arch/xtensa/kernel=
/syscalls/syscall.tbl
> index d354bb231796c..1d28de95915f5 100644
> --- a/arch/xtensa/kernel/syscalls/syscall.tbl
> +++ b/arch/xtensa/kernel/syscalls/syscall.tbl
> @@ -443,3 +443,4 @@
>  470	common	listns				sys_listns
>  471	common	rseq_slice_yield		sys_rseq_slice_yield
>  472	common	fchroot				sys_fchroot
> +473	common	userns_set_idmap		sys_sys_userns_set_idmap
> diff --git a/include/uapi/asm-generic/unistd.h b/include/uapi/asm-generic=
/unistd.h
> index 5b7e77a7c736e..695eac2d356bc 100644
> --- a/include/uapi/asm-generic/unistd.h
> +++ b/include/uapi/asm-generic/unistd.h
> @@ -867,8 +867,12 @@ __SYSCALL(__NR_rseq_slice_yield, sys_rseq_slice_yiel=
d)
>  #define __NR_fchroot 472
>  __SYSCALL(__NR_fchroot, sys_fchroot)
> =20
> +/* kernel/user_namespace.c */
> +#define __NR_userns_set_idmap 473
> +__SYSCALL(__NR_userns_set_idmap, sys_userns_set_idmap)
> +
>  #undef __NR_syscalls
> -#define __NR_syscalls 473
> +#define __NR_syscalls 474
> =20
>  /*
>   * 32 bit systems traditionally used different
> diff --git a/scripts/syscall.tbl b/scripts/syscall.tbl
> index 0ab5316051202..0dddd465d1c5a 100644
> --- a/scripts/syscall.tbl
> +++ b/scripts/syscall.tbl
> @@ -413,3 +413,4 @@
>  470	common	listns				sys_listns
>  471	common	rseq_slice_yield		sys_rseq_slice_yield
>  472	common	fchroot				sys_fchroot
> +473	common	userns_set_idmap		sys_sys_userns_set_idmap

[Severity: High]
Should the entry point in scripts/syscall.tbl and the architecture
syscall*.tbl files be sys_userns_set_idmap rather than
sys_sys_userns_set_idmap?  Because the syscall is defined with
SYSCALL_DEFINE4(userns_set_idmap, ...), the duplicated sys_ prefix causes
the generated syscall tables to reference undefined symbols such as
sys_sys_userns_set_idmap and __x64_sys_sys_userns_set_idmap, breaking the
build across all architectures.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261121000844.1863=
324-1-jarkko@kernel.org?part=3D3


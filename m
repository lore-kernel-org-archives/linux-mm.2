Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A4511606A320
	for <linux-mm@archiver.kernel.org>; Sun,  8 Nov 2026 07:44:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=okxR5XsR
Received: by kanga.kvack.org (Postfix)
	id C0C936B05B1; Sun,  8 Nov 2026 02:44:01 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B9C6E6B05B2; Sun,  8 Nov 2026 02:44:01 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AB4096B05B4; Sun,  8 Nov 2026 02:44:01 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 8B6A06B05B2
	for <linux-mm@kvack.org>; Sun,  8 Nov 2026 02:44:01 -0500 (EST)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 9D18D1A028D
	for <linux-mm@kvack.org>; Sun,  8 Nov 2026 07:44:00 +0000 (UTC)
X-FDA: 85411163040.07.B78BBD0
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf12.hostedemail.com (Postfix) with ESMTP id 0906140002
	for <linux-mm@kvack.org>; Sun,  8 Nov 2026 07:43:58 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=okxR5XsR;
	spf=pass (imf12.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794123839;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=I8CSjpyW0jwA7Z9/vMpZjBHVFz3fYhrc+SH2KIWX5F0=;
	b=3eRzrEbQxFF+6f6Ex4tGUJaEnVAS2bwsKovQLqpMit3zXyLbqC/SM6Lt4jW2RciXd9VqIP
	NIBtSpnxDiFXUn/4nTiSyjJd/eJoAbvrpffg7h0pWTCHdxdMzs7FG2zdKlUJDpe5TSHek4
	roD+7KiCECUDNVX6gFwQ5skOjAwX/Vo=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794123839;
	b=Hqf1g19ecOzuLQxy/NtPYHR02htniBQPvByE/DbIWV7JSg0IiXTG7mWJT25byu18xQCiXW
	3fRqtLTSjTZsg1hMU+wbZaoq7vihmKVtCsEKs/ElE80Bw+Dg+wpdOHaNq6XI0QpbOX/aHC
	hvA6IY56OcVpc66QkzhzI0iHS8ARLaQ=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=okxR5XsR;
	spf=pass (imf12.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id C0E7661193;
	Sun,  8 Nov 2026 07:43:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2F1E1F0089F;
	Sun,  8 Nov 2026 07:43:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794123837;
	bh=I8CSjpyW0jwA7Z9/vMpZjBHVFz3fYhrc+SH2KIWX5F0=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=okxR5XsR9XMpt4NCXl1QntWzJTw20k6ekUKbGT3NbCs4yuVfx0mldVJo1Qp7nSRye
	 vseK+pwdQZ70eXazM3QfvBdtaO9Hk4ixRKZlUrG40CVMsmZRPhm7NMe3BjzOY5WHDk
	 WN9uryA41w/aQ9ZS4BwhGytqXgkt/+UfUnJg+EmqXfareSU8f+YAi5fs8RQNaacJS1
	 pSB6F1wge3mUMLl+pYsuDtUfCKuFIj3JhjiX6PCbo8ilty5uX+LFSUxrgMoePa8tx1
	 lQt5qGAwbtYpzlssi8673QxPKUN8pyzQMSizsLaA0HHxV83n1Dr2014uQxDaSZHq/B
	 rpvY6OQZzIHuA==
Message-ID: <sashiko-outbox-203633@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 1/4] arm64: percpu: Always inline helpers used by
 noinstr code
Reply-To: sashiko-reviews@lists.linux.dev
To: "Jisheng Zhang" <jszhang@kernel.org>, "Catalin Marinas" <catalin.marinas@arm.com>, "Will
 Deacon" <will@kernel.org>, "Mark Rutland" <mark.rutland@arm.com>, "Andrey
 Ryabinin" <ryabinin.a.a@gmail.com>, "Alexander Potapenko" <glider@google.com>, "Andrey
 Konovalov" <andreyknvl@gmail.com>, "Dmitry Vyukov" <dvyukov@google.com>, "Vincenzo
 Frascino" <vincenzo.frascino@arm.com>, "Tejun Heo" <tj@kernel.org>, "Dennis
 Zhou" <dennis@kernel.org>, "Christoph Lameter" <cl@gentwo.org>
Cc: kasan-dev@googlegroups.com, linux-mm@kvack.org
In-Reply-To: <20261107071339.17467-2-jszhang@kernel.org>
References: <20261107071339.17467-1-jszhang@kernel.org>
 <20261107071339.17467-2-jszhang@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sun, 08 Nov 2026 07:43:56 +0000
X-Rspamd-Server: rspam06
X-Stat-Signature: px8t7f699cmerqs5x7mgujyjdmtubsji
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 0906140002
X-Rspam-User: 
X-HE-Tag: 1794123838-93261
X-HE-Meta: U2FsdGVkX19A9O0P6uoEURloKJCD5dLPKtEq5eQlExk5FIGKsaTf4L/fx2tkFdFnD4dRFg4suWim30MkGub14+XJuHBQ1n/ME1wUhz78YK0ttH9QA+bvMoB0gwjqbC6FDjrpK+N2D8ptINERQv71qjn2WBjQg4giAJd74KAoUZIBPb5fpw+aONPHwioIha80CaRDx+QdPKO76lq15jVWUPeFPJhunHGC7FQDmjzaJz5mE0GsPlGDwKH0mDEtVHHH7YtMWCeO+K2SFkzZR8xvHS3OjoQR9c61sUMl8SGJxAY4GbN1Zb6I51G115t8WPGE0n+z495avpwbMDdumGUsLwGyW84hrShSu0HHJFirjWKcEZF4SELyeiRzOn7PLWzARxC18rf8UUNPmiF2Dl6CjvfbmUrqUvMwYwmHfDvaqZ12Otvz1aWES/IgmIF4Vle8SWYyBeNKwJ32uMe0i2xYzkABAwZSM7G3EpRw9L5cKH2nYmQZKlW0QmTzOvMgKXrUripB3Is1ax1VxecWDOcSlxu4f4N1zfHc+KW1YKAbnIb1Bfacree/xJoKVhbBPXSigH8p1SzsdYKghWu3kA2Qwc6IfWldPqIAj5PSex/yV5LJuzXmjnsuni/Jb7QGMBLSPM5E9BFQZBFh7NXI+KZRyiPuLLhIo09qIdhobX1+qgGaNPwREYjGl+Yxby7NBSF++6wNhy2ix1KI6q+59BXjGq6ZW4dHtcXikTAgWDUu/ORn41ByBRP01e6ERZuK2IavFJOIWbIz78oAyM6M6EP2L5jPTHeMi08NvHXEhtMEUDgojWRWgYf/ECvZtaYXmyqF272MF6ThX8aK1G0vI6/8LoVUvkDeF+3tGdw1fNuACiyU8RrseQYIlg75/NgNn1Z9bHklDwbEMyBnPV/CRZYQMXLhepadkefEgjF7GKJwnv/mxalcnPyrnP+fg82YSUnL3u8+1O3vJnzFQIAPZNN
 tor3CYs3
 iRkmHEaTdZ/gT9FRvUz0uL/9yUPkXsTZKQXaFp5RX6p+S73AAxH4dGDhZK0AybAJcTqeSk7dOP0n8imY2qBZPIZGifyfW22w3Sc/fJUVPv6IoLx6pOowrcsinyhTQ+TfX7zj0CSJRg3BpITyceQvx6YbuVQAGcluiurpSTtMQ7aWULoNLr+oT2topYORzzo5y0WqR8X8B/Vx9PUbtSq+XDDj6aKcEY563aO/peywi69uf7cjYEOS6CmudvY6J2uzBsAliarVr5LFX08kfZL3coA1ImIZe0VZ48fZ+GFslsVg/q8qI11lDt0QPD+3Z0qtCpFWrIcN1SIiIAMhzJYh33plfPl4gcwPAWYPiU5QOrt+GnogEYfXyJyc/lUg4jtyqACfm0SBQSFyVJT/9xXEoSGMKEXDntDJEnmabBYdFfH5kTW4/iM/+CsnBk3/z+GmYILkz7N6sAh4BSTovS9H7rLWvHaFvxfWpsKMW4IlktDNUQxKmAQ3T3DQtnXp05wXmGbCt89eWOixf1x8O4dyDMEySKtHj4f0j/bOiFkrlFGYDhXXooKYQlvWZBD2RBitkCGqoH6Qs2ByifWX1Cm2aFWuNeX3Pg8mHdGz8onPJyaKf2uVlOpLOkhyaboIkrbn9pMRDCRvLAmAwRqd1W8npsCF2ThwW1m4KcY/o
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
- [Low] arm64: percpu: __PERCPU_OP_CASE() and sibling helpers not marked
  __always_inline
--

commit 3a2df0916b5200b227df21487897e171275b29f4
Author: Jisheng Zhang <jszhang@kernel.org>

arm64: percpu: Always inline helpers used by noinstr code

This commit marks __hyp_my_cpu_offset(), __kern_my_cpu_offset(), and
__percpu_read_##sz() as __always_inline so they are not emitted out of line
when called from non-instrumentable code.

> diff --git a/arch/arm64/include/asm/percpu.h b/arch/arm64/include/asm/per=
cpu.h
> index 3cc316091d665..7c344de5052d5 100644
> --- a/arch/arm64/include/asm/percpu.h
> +++ b/arch/arm64/include/asm/percpu.h

[ ... ]

> @@ -129,7 +129,7 @@ static inline unsigned long __kern_my_cpu_offset(void)
>  #endif
> =20
>  #define PERCPU_RW_OPS(w, sfx, sz)						\
> -static inline unsigned long __percpu_read_##sz(void __percpu *pcp)		\
> +static __always_inline unsigned long __percpu_read_##sz(void __percpu *p=
cp)		\
>  {										\
>  	u16 *gprs =3D &current_thread_info()->pcpu_gprs;				\
>  	unsigned long off;							\

[Severity: Low]
Should __PERCPU_OP_CASE() and the remaining __percpu_* helpers in this head=
er
(__percpu_write_##sz(), __PERCPU_RET_OP_CASE(), PERCPU_XCHG_OP(),
PERCPU_CMPXCHG_OP(), and __percpu_cmpxchg_128()) also be marked
__always_inline?

The noinstr function lockdep_hardirqs_on() calls
__debug_atomic_inc(redundant_hardirqs_on), which under CONFIG_DEBUG_LOCKDEP=
=3Dy
expands to this_cpu_inc(lockdep_stats.redundant_hardirqs_on) ->
__percpu_add_case_64().  Because __PERCPU_OP_CASE() still uses plain static
inline and is also called from instrumentable lockdep functions, builds with
CONFIG_CC_OPTIMIZE_FOR_SIZE=3Dy can emit __percpu_add_case_64() out of line=
 in
.text and call it from .noinstr.text before RCU and lockdep state are ready
for instrumentation.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261107071339.1746=
7-1-jszhang@kernel.org?part=3D1


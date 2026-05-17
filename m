Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 88292CD4F3D
	for <linux-mm@archiver.kernel.org>; Sun, 17 May 2026 21:34:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C71D36B0093; Sun, 17 May 2026 17:34:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C22A96B0095; Sun, 17 May 2026 17:34:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B116E6B0099; Sun, 17 May 2026 17:34:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 9F3C56B0093
	for <linux-mm@kvack.org>; Sun, 17 May 2026 17:34:26 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 4AC651A0660
	for <linux-mm@kvack.org>; Sun, 17 May 2026 21:34:26 +0000 (UTC)
X-FDA: 84778215732.13.217C1FB
Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	by imf25.hostedemail.com (Postfix) with ESMTP id 4E943A0002
	for <linux-mm@kvack.org>; Sun, 17 May 2026 21:34:24 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=XkA+SwU1;
	spf=pass (imf25.hostedemail.com: domain of david.laight.linux@gmail.com designates 209.85.128.44 as permitted sender) smtp.mailfrom=david.laight.linux@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779053664;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2jowbETNoUhlLBVOkFK2p96CeL17LN1x91A+MDtDQyE=;
	b=zGu2kj7sOob6RzLTHFIxDBK1TZHek0U8vpW83LqWtcZe5/giacBGCOYQZUqj3TXPM9F5lC
	9tXpf/Qq0N2kIXoNf16NOR5nrx8UqEfjCYJv+dPNjjj7by5P1hlm0Ef1fLmxCG/haMs5Ge
	DQDwLGHv7WHGLc+O3uM/+Gtw8fKKzx0=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=XkA+SwU1;
	spf=pass (imf25.hostedemail.com: domain of david.laight.linux@gmail.com designates 209.85.128.44 as permitted sender) smtp.mailfrom=david.laight.linux@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779053664; a=rsa-sha256;
	cv=none;
	b=NWnuNsP9C71TUumvxLFjvv1UoqtjyPmuN26yA3DB9IFBc4Hs+IOx7edxwGTV26xcx3S2iV
	6aUnGS7WTCtxkjQfERQxjGjXv0HTjG/wcuy0M01wHSTxyrbGBoM89muzbvg0x6z9AoufDd
	Y27pv2tPGzyQOJkCSOrYj0yph8Top4M=
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-48a7fe4f40bso19746785e9.0
        for <linux-mm@kvack.org>; Sun, 17 May 2026 14:34:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779053662; x=1779658462; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2jowbETNoUhlLBVOkFK2p96CeL17LN1x91A+MDtDQyE=;
        b=XkA+SwU1q2KpPo/Kl2d4S+ShXyXFed/oAfMJBdFQyIvFIc01qysrUishgUjREp70h9
         BeaBU1aturmaqV7TK7MJaZx4VeTPuwV3t+6XVAA7SVXGtF/UPgQNddzPia8kh2wbYK8R
         JPE0muFgDtRUUrvmF/U47OfHFTxPFS7TSTLZaZiHGW0DAd0oMYK8eM3jxWnJp+6ZSBLY
         eLVJtIT8PAb7Vkj+nFIY8NYAe2eQP98ziSEJ5erdSdJdR1q2jwfqQWM8Nw3w+HXgRQuI
         ZNSrU1W5FwxX7BpR0JtuvqbFaI3wBAz+RG4Ba4B4Hf1nWO2wBNEP3BPf+RNKxY8gsGl2
         BI/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779053662; x=1779658462;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=2jowbETNoUhlLBVOkFK2p96CeL17LN1x91A+MDtDQyE=;
        b=rz9ZO0m3tyWaxA5gJl3EMwOTlPPVNHB4PuorFSKJ+Q/D4J7xbaKCwtezwoRWMe6iTw
         VQY/wneiyyL9F1Xq2RJtznnBMYb+4KB11gK/IeR4OA9T02A2bRZu7Qg39t4iHDPm+wKG
         mgfw3Jh4F0ntA1lHsCVgBRx5trc8lnhPVTbimHARBJm+FOGm0h5UT/ZphcaTbiNU4s65
         FIwWGU73SjkDGiZ/SnE7X4+4von7dkdqLTbS+ZWh0Gq1BW31BONZU3aY6mCLTAyKOYzz
         nNTvg63zGygUnBGL1sdXRqN79itzVXAJauqqMUfJUwCaMkc7W2Tq/MKdqcfTt5h7v5bk
         vR8Q==
X-Forwarded-Encrypted: i=1; AFNElJ+cqNzeF3N9Y6/RgWJItxAeQAk2ajGmmeJAdd8JrXo2PSPDICVNqKNQb0Qd1rYQIoceoEBxsA1Upw==@kvack.org
X-Gm-Message-State: AOJu0YzgOKHkmXNBfB1ivCArFYNWhPdiFen8Mb53hEGB74ykIAv7QbG4
	y9NA8b54LPyJ85m6zuC6aaHUiszXmMtxriAzoqtx3LDOW5zzw9LVehVS
X-Gm-Gg: Acq92OHVaRvWS5QZO2kNmqHDUXgbIsuh7pWmouLYksKuF37jlmgU4yJUQwDu2n3ezXJ
	uUCaCDpuLbdCtb/HmEvEc4QIIX+QW60tomfjk28fMMeY94ercJh0j6/ZK1RN5ZYZ8KC2vhGIqeA
	4ASzcCucVXxoRIBQIHhg498MDTIyCZjxxCJa2FSET8YeoKTipMVjy0V0e4sfz63Y1oCzRtlvQh8
	g5ZcWbyMgsZ2/TMlvgVKMXFRlsqiG0QjAxwHLuF4EEtNTAVM7O7UHq6E60VYS2Ee3g5SpcVFIN/
	t1bcJlJ999887DsXLhGHQFIBYIIyRbwfSwlIPg7tKz+MB2qCmRXH+XKbGvHet40RL5BNrcmsOUm
	cdOTTaSLbh1NOcff714qkZavMU4asWHYjLYRUhM2DaFONWI4p9W4y3ZXaH8h/j5OAhxv4czuASo
	CLoX46gUgGrEkyxUDOQisZxeReNF5LlTmiCxpUcuKvnmSH0dkyOjgSpTAVzJ/SEcjG
X-Received: by 2002:a05:600c:885:b0:489:c57:7836 with SMTP id 5b1f17b1804b1-48fe6517fdfmr116464375e9.27.1779053662255;
        Sun, 17 May 2026 14:34:22 -0700 (PDT)
Received: from pumpkin (82-69-66-36.dsl.in-addr.zen.co.uk. [82.69.66.36])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-45da0fe0f72sm34621522f8f.25.2026.05.17.14.34.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 17 May 2026 14:34:21 -0700 (PDT)
Date: Sun, 17 May 2026 22:34:19 +0100
From: David Laight <david.laight.linux@gmail.com>
To: =?UTF-8?B?QW5kcsOp?= Almeida <andrealmeid@igalia.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Juri Lelli
 <juri.lelli@redhat.com>, Vincent Guittot <vincent.guittot@linaro.org>,
 Steven Rostedt <rostedt@goodmis.org>, Christian Brauner
 <brauner@kernel.org>, Kees Cook <kees@kernel.org>, Shuah Khan
 <shuah@kernel.org>, willy@infradead.org, mathieu.desnoyers@efficios.com,
 Linus Torvalds <torvalds@linux-foundation.org>, akpm@linux-foundation.org,
 Yafang Shao <laoar.shao@gmail.com>, andrii.nakryiko@gmail.com,
 arnaldo.melo@gmail.com, Petr Mladek <pmladek@suse.com>,
 linux-kernel@vger.kernel.org, kernel-dev@igalia.com, linux-mm@kvack.org,
 linux-api@vger.kernel.org
Subject: Re: [PATCH 3/6] string: Introduce strtostr() for safe and
 performance string copies
Message-ID: <20260517223419.3262de7c@pumpkin>
In-Reply-To: <20260517-tonyk-long_name-v1-3-3c282eaa91e2@igalia.com>
References: <20260517-tonyk-long_name-v1-0-3c282eaa91e2@igalia.com>
	<20260517-tonyk-long_name-v1-3-3c282eaa91e2@igalia.com>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.38; arm-unknown-linux-gnueabihf)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: 4tzhi5ni48dn1s7b87tjumeh8iqbycnx
X-Rspamd-Queue-Id: 4E943A0002
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1779053664-186128
X-HE-Meta: U2FsdGVkX1+TkSfv+iM3Fa5P3f4GZXN9QFi4LPKKQ1Mn7+PLMoz1vY+NTG/27ZTzBMgDMqMbXnVsM1/s6jz6A13yETW7KYnlFqKBrH9nfj3HdZsSL4+UhkiQtP163tDynfampS/HCAvTLuioQ+0Cohfxd7xRHcoAE7F460v1o56D+F8zsxcNF+iiqWUHfI8G2KAZGBJVL9kOXWcjTlUQr3Cd0LbdzSjFPzxmvQaqqBZzX5JDDbBEYUR2QsGoUQgjr6I+IjCeUrDTwG1Q7javiJyW15ISBYy7R/FwseTDjgnbpoR/5g9/i/K6Up8MY9TOnn1Or0T7/rXccknBsRsxhZGa3ASPM82m0Wzwo4D/Hrta4ab8ryVADXOQ5laNXwEuO+h4t92Ugh0ucIuTuYBfCbkZUoCQvwVAvbpUQkRyx9ZHCi5ZI2zNoy1BMMOwOh3ZQKO/QuIOsQN5bFVh6kahq1lvxLHyKg8g+6japgSSdbYkspAvBy0QDfGv/SomN5usMvhvkQ7T9JmIvNYZslWPz0KMdzNFI38QCH9olN1fbRd56ivSEBYM45emLsCKHRghOoHFZ6+BWoD17vWODojNfOdt4wC79PyCF2jOOkjYBDhEfSrQscaRJgy8/Ttq2pKIH+HoeFe9CdMBDKSpG4VJfghqCUBTNIKjFh06hSs6nvufHlzG8pLGnIFCV6QIAfPvseUE5a1PCnGBtXOQHajBuFW4AvzCo9bdYGZe3kEq/tW0U/KPOZvHJGZ+dO8O+FFyClC0uukhA2T3GYxOYHoqdEA0SFbikU7ib3p3lMaxSMSoLkmQjzkB1XsSw9mPWU9YrI7G5LkVyfwKHDRcKWmUkYuzsPaMeM9RGbyQxasRtSU3e7rSQLsxobwADztaRYm0e/p/f86XazEBcsioDJpnoKfnTmwuXy6ZlH++nZWYK4XfRmglAP8M2S5o8hSR5355b0qrUlNhCQxcjpdVZkx
 STW6C0Qq
 c08/8ub2rz3HQYGHIpNjMibjn6JjK3X2KuwX81oEyNC2N/0BJkI0fZri1YXz3OpN7MdXK/TZv7rDZu72z4p9+m44Ab/DTzE0xuKn2amrn6hpZgWqJzon7uwLyQY1pOqTYLNtzfxsGefhFKiID58SomgntBDjKSiDpT4NMEDHo/KNgK6yS2FlyeZJk3eqh1ewieX+31gbjA9ZZYSvp3bIBFBDZvsGbt6MIvovy16IIvA1gULT/I+Ef029oXwV8LFd93Nta1TvnwIbGPa/Mo1HsGvV8dmZPsSjH6PJN1SJPxTRthtWP47BJHLmgSxdY9zIbzp2sKAEducpE89jnTWGvpqVIIf/Quc7IqJ0JvWuPjzwh3NI+V+p5wkD4vZweNYBriKiXGIhi7YficTvOSW9su6xHAkO5PXAP8mYrd2oTzQ5heJGm2tohJazV+A6bDqTgBnONOxmrro8PG/RgljsglymCY3uFAW16AuoXdxFd1FTN3c9YBS5KVzZIewJdFpzK7okOQbuhaIHzbjcOk56jHiW9zI3baLqVfI8yQ2nzQ0aItxQnY5yUY8AdssvdYiCbeaAP+uT4pYHCFW10YdBdoqUiorXCwQ2Ez+veUhfdJOzMDX1tDK8oJjqN4A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, 17 May 2026 15:36:13 -0300
Andr=C3=A9 Almeida <andrealmeid@igalia.com> wrote:

> Some parts of the kernel uses memcpy() instead of strscpy() because they
> are performance sensitive and doesn't care about the return value of
> strscpy(). One such common case is to copy current->comm to a different
> buffer.
>=20
> As the command name is guaranteed to be NUL-terminated in the range of
> TASK_COMM_LEN, this is safe enough and doesn't create unterminated
> strings. However, in order to expand the size of current->comm, this
> expectation will be broken and those memcpy() could create such strings
> without trailing NUL byte.
>=20
> In order to support a fast and safe string copy, create strtostr(), to co=
py
> a NUL-terminated string to a new string buffer. If the destination buffer
> is bigger than the source, no pad is applied, but the string is
> NUL-terminated. If the destination buffer is smaller, the string is
> truncated. The last byte of the destination is always set to NUL for safe=
ty.
>=20
> Signed-off-by: Andr=C3=A9 Almeida <andrealmeid@igalia.com>
> ---
>  include/linux/coredump.h                           |  2 +-
>  include/linux/string.h                             | 28 ++++++++++++++++=
++++++
>  include/linux/tracepoint.h                         |  4 ++--
>  include/trace/events/block.h                       | 10 ++++----
>  include/trace/events/coredump.h                    |  2 +-
>  include/trace/events/f2fs.h                        |  4 ++--
>  include/trace/events/oom.h                         |  2 +-
>  include/trace/events/osnoise.h                     |  2 +-
>  include/trace/events/sched.h                       | 10 ++++----
>  include/trace/events/signal.h                      |  2 +-
>  include/trace/events/task.h                        |  4 ++--
>  kernel/printk/nbcon.c                              |  2 +-
>  kernel/printk/printk.c                             |  2 +-
>  tools/bpf/bpftool/pids.c                           |  4 ++--
>  .../selftests/bpf/test_kmods/bpf_testmod-events.h  |  2 +-
>  15 files changed, 54 insertions(+), 26 deletions(-)
>=20
> diff --git a/include/linux/coredump.h b/include/linux/coredump.h
> index 68861da4cf7c..b370ef69f673 100644
> --- a/include/linux/coredump.h
> +++ b/include/linux/coredump.h
> @@ -54,7 +54,7 @@ extern void vfs_coredump(const kernel_siginfo_t *siginf=
o);
>  	do {	\
>  		char comm[TASK_COMM_LEN];	\
>  		/* This will always be NUL terminated. */ \
> -		memcpy(comm, current->comm, sizeof(comm)); \
> +		strtostr(comm, current->comm); \
>  		printk_ratelimited(Level "coredump: %d(%*pE): " Format "\n",	\
>  			task_tgid_vnr(current), (int)strlen(comm), comm, ##__VA_ARGS__);	\
>  	} while (0)	\
> diff --git a/include/linux/string.h b/include/linux/string.h
> index b850bd91b3d8..ff1f59f4139c 100644
> --- a/include/linux/string.h
> +++ b/include/linux/string.h
> @@ -445,6 +445,34 @@ void memcpy_and_pad(void *dest, size_t dest_len, con=
st void *src, size_t count,
>  	memcpy(dest, src, strnlen(src, min(_src_len, _dest_len)));	\
>  } while (0)
> =20
> +/**
> + * strtostr - Copy NUL-terminanted string to NUL-terminate string
> + *
> + * @dest: Pointer of destination string
> + * @src: Pointer to NUL-terminates string
> + *
> + * This is a replacement for strcpy() where the caller doesn't care abou=
t the
> + * return value and if the string is going to be truncated, albeit it ne=
eds
> + * to mark sure that it will be NUL-terminated. Intended for performance
> + * sensitive cases, such as tracing.

If you care about performance, and the destination isn't smaller (especially
if the sizes are the same) then just use memcpy().
=20
> + *
> + * If the destination is bigger than the source, no padding happens. It =
it's
> + * smaller the strings gets truncated.
> + *
> + * Both arguments needs to be arrays with lengths discoverable by the co=
mpiler.
> + */
> +#define strtostr(dest, src)	do {					\
> +	const size_t _dest_len =3D __must_be_cstr(dest) +			\
> +				 ARRAY_SIZE(dest);			\
> +	const size_t _src_len =3D __must_be_cstr(src) +			\
> +				__builtin_object_size(src, 1);		\
> +									\
> +	BUILD_BUG_ON(!__builtin_constant_p(_dest_len) ||		\
> +		     _dest_len =3D=3D (size_t)-1);				\
> +	memcpy(dest, src, strnlen(src, min(_src_len, _dest_len)));	\
> +	dest[_dest_len - 1] =3D '\0';						\
> +} while (0)

That doesn't work (for all sorts of reasons).
_dest_len can be the size of a pointer - no array check.
You need to use __is_array() and sizeof () for both dest and src.
You might have meant to check that _src_len is constant, not _dest_len.
You must not leave the destination unterminated.

__builtin_object_size(x->y,1) is also entirely useless!
If you have a pointer to a structure that ends in an array then the
object size of that array is SIZE_MAX (as if the array continues past
the end of the structure).
See https://godbolt.org/z/csenjfvxe (which I happened to prepare earlier to=
day).

__builtin_object_size(x->y,0) also seems to always return SIZE_MAX.
You do get a sane answer for (x->y,3) on recent clang - but nowhere else.

-- David




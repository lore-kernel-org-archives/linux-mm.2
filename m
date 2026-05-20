Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 51BF7CD4F54
	for <linux-mm@archiver.kernel.org>; Wed, 20 May 2026 09:53:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 93E8D6B0005; Wed, 20 May 2026 05:53:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8A18D6B0088; Wed, 20 May 2026 05:53:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 769316B008A; Wed, 20 May 2026 05:53:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 63C7B6B0005
	for <linux-mm@kvack.org>; Wed, 20 May 2026 05:53:41 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 06973C11AC
	for <linux-mm@kvack.org>; Wed, 20 May 2026 09:53:41 +0000 (UTC)
X-FDA: 84787336242.11.8555E0D
Received: from mail-wr1-f53.google.com (mail-wr1-f53.google.com [209.85.221.53])
	by imf25.hostedemail.com (Postfix) with ESMTP id 187C4A000C
	for <linux-mm@kvack.org>; Wed, 20 May 2026 09:53:38 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=fXa5ILqA;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf25.hostedemail.com: domain of david.laight.linux@gmail.com designates 209.85.221.53 as permitted sender) smtp.mailfrom=david.laight.linux@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779270819;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3ebYrN+Cy1jpS7On8dq1CN3DpE7snkr/MnVsVyf9e2g=;
	b=ZPqryYamBl1sJ23gUvMi70VHPF8oH93gsito1eg2Jigs8k1z+yw7n/ylMTbILmBtIdxiK2
	vwRT1RcB6vRPmFVQM5DGhWOCgjZQqsPWpfFI5NHKkRg70VyTwxKAUrpbHYevGfERMmoDA5
	x13sngMvqhJIzNMng8s5J2VNcpESKKU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779270819; a=rsa-sha256;
	cv=none;
	b=mPH8RGW3WmjSigYTh9EeX08LrXrE7ujdlwTdTmDUFSlfiiNER4ouiJtF+GTLIIP8rDrBT/
	kNDyrCzzWQRv2SKdPt+ah0XQZeH3fMCFg67L8b+VL3IuGdXO6yLEqxe1qDZlrNkkF2a/Vg
	IF92Hqju4sykpitgRNWGPqrSakq01bc=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=fXa5ILqA;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf25.hostedemail.com: domain of david.laight.linux@gmail.com designates 209.85.221.53 as permitted sender) smtp.mailfrom=david.laight.linux@gmail.com
Received: by mail-wr1-f53.google.com with SMTP id ffacd0b85a97d-43fe62837baso2625495f8f.3
        for <linux-mm@kvack.org>; Wed, 20 May 2026 02:53:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779270817; x=1779875617; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3ebYrN+Cy1jpS7On8dq1CN3DpE7snkr/MnVsVyf9e2g=;
        b=fXa5ILqAcRCB5ZUk54+MMX5xN4yW0MO2YGMGZV9yYPtuf8isNMIycvJtb7T/qKjm0v
         ufMmVI15mIW+yVaX7WRHBCsAKiQz0iLrMmBpcEQ+4NuYh1FNCBnEf6Moffo6Gc5AM762
         W/40YeNUdJ5Gd3YN7X8615K+LVdP5I1fbrsgVhdRoNHFW6SrFjsRf13slAw/aR7LH+yN
         LOdhe7S3seCSComiCfbOBEdP2MqLOaE0Z8Lx0WUaEmZgGHSBw+Krpsez5H7rYjrp87Xx
         BCxUnIc4MTwJ1e32qaYyntNVzfiC6qBph8QiHQ6gLHToRs++wf1UZxUbobi8OAS1Qe3O
         rsTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779270817; x=1779875617;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=3ebYrN+Cy1jpS7On8dq1CN3DpE7snkr/MnVsVyf9e2g=;
        b=gr9Z/NLngC4/hbh80aR0jkk5VPdXuBDbAtuoxhMzyPJIwT0SBwRijKb9pBXG5tvH6L
         uxaQqoF6rgnfLaC5MZ66Uss0Oyb67nYo/6JI+L7lPWyl3E+8fZEJoWN39+bg9uS490Zc
         7i35T34gVUkkwjswRmuWQaZ17jUIONhEPBjzcj/yVctPYmzGN3SuKK16FCtegC+mXNrf
         rjIUo3ouwB90WEYRvNAgDM+7meiR0+QeoTPYDOsfkMIBXbrACalfBRTsWSMFs91xhnel
         xPhcjCPjdcPyRpkXN8yKre4YrxEEAxMV2PF/wX/zW2E66QlkCSig84aUNhdOYTU76Iju
         +nEw==
X-Forwarded-Encrypted: i=1; AFNElJ9sn6RlvS9oAgefbiIRXc80eHU760yHWMaQm4c21rpIhHFTM5V3EhwO2cIMKIrVuA6igRR7L1gbUw==@kvack.org
X-Gm-Message-State: AOJu0YyvXIp7dt/Y3f3DU9Enmm3Jp//eXJhJhINOcI2dPuwcHgye+iBL
	qXfDUFturTuuvrPWoETHb+pj9WQMXepKMnVBcqzqCaD9lXYAh4GPnqtL
X-Gm-Gg: Acq92OHcKvD59AnydftUVWE0iVW8zbgWqfvHLZVfNo9Qb2kk64TTAVmaAb74+1Ih/vq
	g1Sm0V5WNntJ9a/1Ht/IjZDf2gUVItFiDJ9Ir9F4SGpAtBNam/DeCwVcUhg5E49DsiWKT/BS1e9
	IPMenitIucYcOyJaPOJJR5jliZRLNcc7H3lU1bQlDkuqRzLT3VH0zTQR+Sv8EQwEi/eNBRXuBx9
	D+taoxnesEEU/c8JTIM6HXhkme7FwM6OdXSQgVajzNwlVO9QAAyxTvr9dp2bqrW2O9cFNZ2v5T1
	yZOn3obESNelDyOLpbWa9WWbB9X42g495sIukS+XRzvWnzms71rphyE3vb3FfYBDjcyM6KmEApy
	5058F3nthNa76r4wvSv459RJp77LnT2Uq1gYZtMXflu60xI13rQg4t5/9E+DcF1WQlOnm1ln5LB
	A1uq+y7vPeIrFsth5ihcQClKXhPM/Z5rxoXCVIP/ZiV9yv3NaySUSaCx3tCuT1sGMAA4vslWDK3
	ek=
X-Received: by 2002:a05:6000:186c:b0:44a:aa3c:5927 with SMTP id ffacd0b85a97d-45e5c5957b9mr38170692f8f.29.1779270817325;
        Wed, 20 May 2026 02:53:37 -0700 (PDT)
Received: from pumpkin (82-69-66-36.dsl.in-addr.zen.co.uk. [82.69.66.36])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-45da0fe0fecsm48645755f8f.26.2026.05.20.02.53.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 May 2026 02:53:36 -0700 (PDT)
Date: Wed, 20 May 2026 10:53:35 +0100
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
Message-ID: <20260520105335.1970fc23@pumpkin>
In-Reply-To: <471b5b42-974c-441a-9afb-13e1baba5c44@igalia.com>
References: <20260517-tonyk-long_name-v1-0-3c282eaa91e2@igalia.com>
	<20260517-tonyk-long_name-v1-3-3c282eaa91e2@igalia.com>
	<20260517223419.3262de7c@pumpkin>
	<d4d6cf61-568e-478e-88d6-01b769d7eded@igalia.com>
	<20260518193843.7bde8d53@pumpkin>
	<471b5b42-974c-441a-9afb-13e1baba5c44@igalia.com>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.38; arm-unknown-linux-gnueabihf)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Queue-Id: 187C4A000C
X-Rspamd-Server: rspam04
X-Stat-Signature: 7n1g9jknyxzxpnppxmtbsfzq4zja8nty
X-HE-Tag: 1779270818-200899
X-HE-Meta: U2FsdGVkX18qEfNtaRmt8e3EwzJr2yXGg33U5PJ7+X2MFxJ0bU+mmuIETzPlB2FMo9CIGRTpUx94zVyMxNprTNiCGYk114biWo+/dlt4Yd5a98Fqg8RoKUaFMkfYgXoPzDZeuzmukPt5Ba3dWVLt1d4ZuNMBaye6A2W/3I/xemh4DtYLpjqgF8CZXlk1WK/o5vmNK+7VQH33M5rGSSlEL2lPHw0yoeYq3LoBcK58skvxp1x+4neWPGD92hcgWB/oN6z6NoU/4iHBUKRhAGbCwmRPp8Ahra4uxXJhtuf/xqZVyptLTbgwPxAptNndffi/qkYzlmjo5FXT6V5oWruk+dHffIwRR4KFkiimZsOUGWaJ7N1lFLS+rq9oB6EbuMs3uVDA//bhBnDEMvjnD2QswyJoTh/8+RbqcaTtP2caA6dzJdxtvYCU3t8Mr844f+HWWDP9WBGaxe9mw8Ujs3By5Q3gY/IVICoWFuyQT0oN69RfPsYMccODQ51Z30qYap4CEBtxGFmYmpxe5YSlworXJ/4dJrpUUtZkd0jLE1TOCtc1i5EmKOkA7lgUfjgJGEC5qgxhQkEPXJJjyoSlhVpOC2rzH+s8B00FPWxzsODyAVBrS4/bQQNSBJzU9VUUeT5AvAIqIPow9pHaqq8acAPP2wmk4gnp4Ym7vw74qGSJ/kV4jRKQMPr7s0rM222ZezaSjTsAKVPnFzPIq2fPm5rzGeyLqsxZzAxCaSLFZpSg22Tzc3LkTGgpw0lsauPN6Qy82FHAR9zouUw0SumH+kB6Nq0S2QZSECANcFkzoRc+NsOcLMPhI3jVRhMb02IPC1R60QSloXcg5JEy5+Pm73yjLA2QavuBFGcs6hicEDlJ6y1zPjV7YXCAA3VLajR+45k2CpKGTkk4kOCkMzRgK9Rk5MGYFisLUvWt/GT8QRV/bwgk9i4XuwIjPli+tkZ3oQW9q0CIF346WD7aLOfDHS+
 xkMuO8X7
 5egzeXbixWk7wAL3vxnY3qEzQX4BQaRSAvm8wa8C1OvP7okFH+jQ0p5GUvPTF1mwok04a2dfMQDtYyNSxUjhja0auZqgcAt+e8iLVZXpiWu0ZmlyeCYc4edI6n+D6P4Iyfe7IUrwgfqkoUZF6p3Qwg+p2AUDk3HKEGw0pKo5wdj3VIk2fRAI5u0p2uB7wigFW+5kKIkhDD9wRz0tuBNGdHQV3XgcrvTGTtYZgh+tlgKBL7Uijor0NPUH76EmWzAPunztYqSt68hXhNiVBhEu2uyh+lBXiKvJScxFytG78CVSwSs9B854pRjKOyo9oaPIWRJ+TRKhKDGmmCkHdFuAtd6Y7r1mqZEOgtvNuSMrGeS93HmwuTMSgewhTnCvU7G+ZFN34cax8Ddqn129NoxMaaE/UnQjVBpQIHAx708aH7MlMNp6UAKhc/6ls+8GM8cl034H0xIt0QAIgtfXNMyqJteLiaReGtQjE8nNv1hw1za+U2krdD2jvT2JdbxdKW9Ibrk5lC12WFls55uAXjoSWtOwsEjxnCrPR2brIu7Z7fczCzEa5yZW3GgRLCy9JJmDKx4qU2F5KW09O04H9zNCH8E4tdKa/Md50ujJ2+XORfdtTVJQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 19 May 2026 16:47:05 -0300
Andr=C3=A9 Almeida <andrealmeid@igalia.com> wrote:

> Em 18/05/2026 15:38, David Laight escreveu:
> > On Mon, 18 May 2026 11:36:49 -0300
> > Andr=C3=A9 Almeida <andrealmeid@igalia.com> wrote:
> >  =20
> >> Hi David, thanks for the feedback!
> >>
> >> Em 17/05/2026 18:34, David Laight escreveu: =20
> >>> On Sun, 17 May 2026 15:36:13 -0300
> >>> Andr=C3=A9 Almeida <andrealmeid@igalia.com> wrote:
> >>>     =20
> >>>> Some parts of the kernel uses memcpy() instead of strscpy() because =
they
> >>>> are performance sensitive and doesn't care about the return value of
> >>>> strscpy(). One such common case is to copy current->comm to a differ=
ent
> >>>> buffer.
> >>>>
> >>>> As the command name is guaranteed to be NUL-terminated in the range =
of
> >>>> TASK_COMM_LEN, this is safe enough and doesn't create unterminated
> >>>> strings. However, in order to expand the size of current->comm, this
> >>>> expectation will be broken and those memcpy() could create such stri=
ngs
> >>>> without trailing NUL byte.
> >>>>
> >>>> In order to support a fast and safe string copy, create strtostr(), =
to copy
> >>>> a NUL-terminated string to a new string buffer. If the destination b=
uffer
> >>>> is bigger than the source, no pad is applied, but the string is
> >>>> NUL-terminated. If the destination buffer is smaller, the string is
> >>>> truncated. The last byte of the destination is always set to NUL for=
 safety.
> >>>>
> >>>> Signed-off-by: Andr=C3=A9 Almeida <andrealmeid@igalia.com>
> >>>> ---
> >> [...]>> +/**
> >>>> + * strtostr - Copy NUL-terminanted string to NUL-terminate string
> >>>> + *
> >>>> + * @dest: Pointer of destination string
> >>>> + * @src: Pointer to NUL-terminates string
> >>>> + *
> >>>> + * This is a replacement for strcpy() where the caller doesn't care=
 about the
> >>>> + * return value and if the string is going to be truncated, albeit =
it needs
> >>>> + * to mark sure that it will be NUL-terminated. Intended for perfor=
mance
> >>>> + * sensitive cases, such as tracing. =20
> >>>
> >>> If you care about performance, and the destination isn't smaller (esp=
ecially
> >>> if the sizes are the same) then just use memcpy().
> >>>       =20
> >>
> >> The problem is that as I'm expanding current->comm, the source buffer
> >> might be bigger than destination, and when we truncate the string, it
> >> won't have the termination NUL byte. So we need an extra dest[len-1] =
=3D
> >> \0 after the memcpy. =20
> >=20
> > It depends on other access to the destination.
> > If it might be being concurrently read it is vital that it is always
> > terminated.
> > So you can't even temporarily have a non-zero byte at the end.
> >  =20
>=20
> I don't think this is the case here, as far as I can tell all the=20
> callers of strtostr will wait the end of the copy before using it.

It's not the callers, it is other threads.
The comm[] string in the process structure can be read write it is being
updated.
It doesn't matter if the reader gets a mix of the old and new strings,
but it must see the terminating '\0'.

...
> > I'd also create function that is explicitly for copying process names.
> > (Or replace the one that is already there - saves a lot of churn.)
> > then you know (and can check) the sizes are the expected ones.
> >  =20
>=20
> I don't have strong feeling about get_task_comm(), but Linus said that=20
> "I'd rather aim to get rid of get_task_comm() entirely"[1] so for me=20
> it's fine to get a new function for that.
>=20
> [1]=20
> https://lore.kernel.org/all/CAHk-=3Dwi5c=3D_-FBGo_88CowJd_F-Gi6Ud9d=3DTAL=
m65ReN7YjrMw@mail.gmail.com/
>=20

You could probably justify a rewritten get_task_comm() without all the bagg=
age.

It might end up being a wrapper for strscpy_pad() or some other (to be writ=
ten
function).
Maybe the body gets get extracted out later for other uses...

The advantage of a wrapper is that you can change the implementation
without having to change all the call sites.

Another (untested) wrapper:
#define copy_task_com(dst, src) do { \
	size_t _dst_len =3D sizeof(dst) + __must_be_array(dst); \
	size_t _src_len =3D sizeof(src); \
	const char *src =3D _src; \
	char *_dst =3D dst; \
\
	if (__is_array(src) && _src_len <=3D _dst_len) { \
		memcpy(_dst, _src, _src_len) \
	}else if (_Alignof(dst) < _Alignof(u64) || _Alignof(src) < _Alignof(u64) |=
| \
			!__is_array(src) || _dst_len !=3D 16 || _src_len < 16) { \
		strscpy_pad(_dst, _src, _dst_len); \
	} else { \
		((u64 *)_dst)[0] =3D ((u64 *)src)[0]; \
		((u64 *)_dst)[1] =3D ((u64 *)src)[1] & ~le64toh(0xff); \
	} \
} while (0);

Although (annoyingly) neither _Alignof() nor alignof() gives the value you =
want.
I don't think you can fix the alignment of a structure member.

-- David


> > It might even be worth making the #define (needed to get the array size=
s)
> > call out to different functions for the different cases.
> >=20
> > Thinks more...
> > On 64bit the 16 byte copy can be 'load; store; load; mask; store' provi=
ded
> > the buffer is aligned (copying u64 on 32bit will work the same).
> > But that requires that all the buffers be aligned.
> > So you'd need to check _Alignof(dest) >=3D _Alignof(u64) as well.
> > (Probably with a fallback to get things to compile.)
> >=20
> > Whether that is best for the longer 64 byte copy is anybodies guess.
> >=20
> > I also suspect it would be best to zero fill when copying a 16 byte
> > name into a 64 byte buffer.
> > (If you zero fill first then you can just copy 16 bytes over.)
> >=20
> > -- David
> >  =20
> >> } while (0)
> >>
> >> =20
> >>> -- David
> >>>
> >>>     =20
> >> =20
> >  =20
>=20
>=20



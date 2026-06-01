Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0651CCD6E55
	for <linux-mm@archiver.kernel.org>; Mon,  1 Jun 2026 16:22:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 673D76B045D; Mon,  1 Jun 2026 12:22:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6241D6B045F; Mon,  1 Jun 2026 12:22:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4C5536B0460; Mon,  1 Jun 2026 12:22:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 357366B045D
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 12:22:33 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id ED4711C0D3B
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 16:22:32 +0000 (UTC)
X-FDA: 84831861744.28.F2A13D3
Received: from mail-yx1-f43.google.com (mail-yx1-f43.google.com [74.125.224.43])
	by imf23.hostedemail.com (Postfix) with ESMTP id E2FDB14000D
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 16:22:30 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=rivosinc.com header.s=google header.b=B4Xjg647;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf23.hostedemail.com: domain of debug@rivosinc.com designates 74.125.224.43 as permitted sender) smtp.mailfrom=debug@rivosinc.com;
	dmarc=pass (policy=none) header.from=rivosinc.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780330951;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=A1Wsv67Vk9GRUFlRdxu2VA3iBYDzYBLeu5jipj2Jvzw=;
	b=ShgL/Tqg7q5YuJM8Ti2RcLPyWOANJuoKi4AfQ9bh1qn6RIFQ3YQgL41t087fbxUtKttBE9
	Do06TEVzaIIlzAUWhr9UEe82K2zE1CRQ3ZUBeLv2f1oKFgpRwUcb0llSuauMTZAiQreiEM
	wTBQFKLv6dC6q3QGSASVcq4CaFfx4pI=
ARC-Authentication-Results: i=2;
	imf23.hostedemail.com;
	dkim=pass header.d=rivosinc.com header.s=google header.b=B4Xjg647;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf23.hostedemail.com: domain of debug@rivosinc.com designates 74.125.224.43 as permitted sender) smtp.mailfrom=debug@rivosinc.com;
	dmarc=pass (policy=none) header.from=rivosinc.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1780330951;
	b=o96mHOfKwBByj2ABvaS9ixh32ecVcEkotHqBvdWydYVkJlPfjc2PU7+O7vkibjwy2ZFbXq
	NMp+0ZG+26OiM0AQQdEf9dfBzQ9NX4/qJhGJrXTGa0nPv9YAYBEBk/ASHnEmwOKiNNQdrO
	iTAE79OpAUgLUQu136AIvooLoSLHuXA=
Received: by mail-yx1-f43.google.com with SMTP id 956f58d0204a3-66050c021f0so3056781d50.1
        for <linux-mm@kvack.org>; Mon, 01 Jun 2026 09:22:30 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1780330950; cv=none;
        d=google.com; s=arc-20240605;
        b=OUkyRzZWuLUjKI1sAZwunAmrdAITfdB0vE3vaaD+4mD+MaFIAneBmhmnhzFGSJyaWm
         dq0agHO8I9t63ZGQEZjlQo+AL2WUNxkTDrCW4PVc44fgB40qw9j4jGcW8LdfUJyVAmok
         LzF7pqGXXisNjOXPPuMx9TDhGOvAZHPXLiCMe+bfqZR+cRdqNb2FJuoFumyqVqQqzhNm
         3tDViea6xwjUkH95cxgYXRVSkLGn84jyWh7wl8gXI6J8Mm9je1NPqlE6rrgsqoHfES3f
         IJpbA2OPD8VlPuFcS3wPRATSsAUS0bce1AWgd36skPIRqneXYbPJoS4TmnwXOYfDCgjY
         c4tg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=A1Wsv67Vk9GRUFlRdxu2VA3iBYDzYBLeu5jipj2Jvzw=;
        fh=fNhIi7km2jdm/pOVbdRvdqBSd0G2PQp1lcN9d+7HNOQ=;
        b=cqutOP84gZXu4yi5p1mODmZhUP8Nm5ihHsKVaBCZ6fW/7/J6d6pvZHJMkvnvb0A6vQ
         4zGHApVVbo/WhcAYiWmprs7x1AkALmlCSL70PcqUPrbOgu5jm2l1uV0LQEYTZbFVI5a8
         WKGtxPUleEztCKVHDjmA0ywPWoq928YUNkGxHcmDxVlomqnr9I5081sLCZ0d+ZlLGq/x
         Fo559cQlF71QAzt1nmCcH4yiqUo//mbYf4mI+LO1ZyKaFXsAlr7maruNUeR+1dSuKvUo
         qTejsx0/QFm/nr07GG3UDPhJJTEYlin4dmbbujDjPsh0ZB4tYt6seKsyYxjNBsFMyIa3
         i2cg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc.com; s=google; t=1780330950; x=1780935750; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=A1Wsv67Vk9GRUFlRdxu2VA3iBYDzYBLeu5jipj2Jvzw=;
        b=B4Xjg647pa+qNawGC6p8ExckkOYGh5x2CNpXymHhe+zw2bEMMLbcOYKYHKDRxIsfqX
         JrycgoqNW4Pd84Ai9VnMpcli9+v+GDRg05GIj1B0a+7M7/Y3kDVxkC2aXzEe8idvNm/a
         lM5Km0X0ijqysb/PYVL0brWJxbL2tnQS7BuKBO573Pauj4REuoSHJMYhM6yVEXhsPdu+
         4I3j7u7ps/X+mfs/1CtnDdYYjVkW07l+rvB7ThZqY4pnIAqeVCjRFkFWCgcWxhFHZqdq
         UjbNE+QM4kH03RzFNfIq1UiD7zU4mjTz9BAJsSbqvizQ/5Q66H9wunLcOQLJT6xjRjgk
         O6fw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780330950; x=1780935750;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=A1Wsv67Vk9GRUFlRdxu2VA3iBYDzYBLeu5jipj2Jvzw=;
        b=ACdW9c2cmyMdYfFLw8gEx7kP29nx5Ewx0xXuQz5J8qNuWocXyKGlVq7P4515cTgYt8
         MOXeEorB9snWN3cW3S/Ujg0yjDs9Q1ZM0ihHxwyRx3RvInqpGskPiyLuVM0JGYY/q6AL
         +oLcCH+oCnKPHc/+W9W1tvviG/Cz0xe4TSYuU9jqK+c4sqtv/zTVG9MIof4+7ZMbAbhZ
         1XGrP40P0wpkNb0kGz8zu5LmT1tAz62G4BqTIOZHEFeGeLn3Q+eQNuI51LLvpdcrWgOa
         KxTpireeUwS7s7uWds9qHOMGvX+DOJA7/ss3w4D581qbUYU/9t9X9tk+93ryaId2qqCA
         aLfA==
X-Forwarded-Encrypted: i=1; AFNElJ/mrbcN//c0XMHedLDmlbpA3279iXGCGuviQ5TXM7zbtN5GmDroNamdXAKzgVZbQAsJrXl9iomBGg==@kvack.org
X-Gm-Message-State: AOJu0Yy0rMtBTd/d1tIw+6pXmlPHiPsfUYtR1M86xZiDROuWbpoB/RZ5
	Z222V33gva8NsWDjMg3l0a/5PUo+6/4bxmN4CXxdDR8uNg1CvM3t8TU4MNFtpzl2+aV8shd1fqC
	eBpl1f5MF+EScHHnV6fxw0zaRVz/lKowlhYPAALk0cw==
X-Gm-Gg: Acq92OGoWAPY45QOnMMzzPZUeVdj87vNuFUGz6lNC/RlnWk6pf7qEeC73mm5rbzmzFS
	8EYwBGgj2RCG6aKtONJZK/RB6+p/Nrb8w2yHjx9Wnvltd91hH0yfjZSGhWmxgM8xivvlinWakkF
	d10IJ8uQNfm6ubZXoZZ+UBenfn6U0rO15yqijq9PtcJYfS6WWU4o0Xwi5H7h1EyNp0VD08TeyJl
	j+F+O82nkCP6YZe7u3c9ctKe+oPR4UhRLRJnKNkSQHWC8lvdVyk+BoXf8pTwYJFMPVKjISrvRIk
	mL6wbuzS9Y+xlLcjV0lWFHCg1emWZT652r0CyWGMipZaLzlxRo8=
X-Received: by 2002:a05:690e:138b:b0:660:7b47:24cc with SMTP id
 956f58d0204a3-6607b474ddamr5466859d50.1.1780330949770; Mon, 01 Jun 2026
 09:22:29 -0700 (PDT)
MIME-Version: 1.0
References: <20251112-v5_user_cfi_series-v23-0-b55691eacf4f@rivosinc.com>
 <20251112-v5_user_cfi_series-v23-6-b55691eacf4f@rivosinc.com>
 <87jyslndo4.fsf@igel.home> <CAKC1njS=AHu6uHrH4ae8VxcdEbhgiPXYCAoN3F_mnppBd3SwOA@mail.gmail.com>
 <875x44o9hj.fsf@igel.home>
In-Reply-To: <875x44o9hj.fsf@igel.home>
From: Deepak Gupta <debug@rivosinc.com>
Date: Mon, 1 Jun 2026 09:22:17 -0700
X-Gm-Features: AVHnY4J6Ejb9kcuTR-Xh2mJuobUXOxxIDSAgxNY81YZ-jI0UDO1cEHEz8fOc8KU
Message-ID: <CAKC1njSn_rtCj8ii876PNQTk0nsCTfWsb4DzdymufHVthh1Rkg@mail.gmail.com>
Subject: Re: [PATCH v23 06/28] riscv/mm : ensure PROT_WRITE leads to VM_READ | VM_WRITE
To: Andreas Schwab <schwab@linux-m68k.org>
Cc: Deepak Gupta via B4 Relay <devnull+debug.rivosinc.com@kernel.org>, 
	Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, Andrew Morton <akpm@linux-foundation.org>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@suse.cz>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Paul Walmsley <paul.walmsley@sifive.com>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
	Conor Dooley <conor@kernel.org>, Rob Herring <robh@kernel.org>, 
	Krzysztof Kozlowski <krzk+dt@kernel.org>, Arnd Bergmann <arnd@arndb.de>, 
	Christian Brauner <brauner@kernel.org>, Peter Zijlstra <peterz@infradead.org>, 
	Oleg Nesterov <oleg@redhat.com>, Eric Biederman <ebiederm@xmission.com>, Kees Cook <kees@kernel.org>, 
	Jonathan Corbet <corbet@lwn.net>, Shuah Khan <shuah@kernel.org>, Jann Horn <jannh@google.com>, 
	Conor Dooley <conor+dt@kernel.org>, Miguel Ojeda <ojeda@kernel.org>, 
	Alex Gaynor <alex.gaynor@gmail.com>, Boqun Feng <boqun.feng@gmail.com>, 
	Gary Guo <gary@garyguo.net>, =?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Andreas Hindborg <a.hindborg@kernel.org>, Alice Ryhl <aliceryhl@google.com>, 
	Trevor Gross <tmgross@umich.edu>, Benno Lossin <lossin@kernel.org>, linux-kernel@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, 
	linux-riscv@lists.infradead.org, devicetree@vger.kernel.org, 
	linux-arch@vger.kernel.org, linux-doc@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, alistair.francis@wdc.com, 
	richard.henderson@linaro.org, jim.shu@sifive.com, andybnac@gmail.com, 
	kito.cheng@sifive.com, charlie@rivosinc.com, atishp@rivosinc.com, 
	evan@rivosinc.com, cleger@rivosinc.com, alexghiti@rivosinc.com, 
	samitolvanen@google.com, broonie@kernel.org, rick.p.edgecombe@intel.com, 
	rust-for-linux@vger.kernel.org, Zong Li <zong.li@sifive.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: E2FDB14000D
X-Stat-Signature: xp58nmnoicogs4i7tewt516qnohm1yfz
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1780330950-676026
X-HE-Meta: U2FsdGVkX1/5RYepkyqNyPiOoEYRp1sOyDhakY1VohmNPrnAHpoAcsGgWsiDMcdWubsgwXwKLBF9qdjZORhUKYCfcUWZ51u/udTRrw1RcXOrLJtkLHKWneegAUeyzslwiG8a2+H61GQeEtEFpYPjwFC3now8/8HzwU9iqLC3zA7Y5l2zIvhRoXK13nXUrEBX5kYJTIkv6pzxSVztSmmZmORDqsyiub2qWr6Ej9JDlOPVdZVU7AjkGSFpbWReMU9Mf6RbkJi2aTAEc4eoIK+NOUgj3+nCyrCrkDyhTfk3oyq1sI6ZeiVxQnuyoQ/C96lBKM0p4SY2Q0t6zTCVkBVg+19zU9m2c5eYGQQlN74epeeEdDLdbO/LwNZQ+cpBpbwpOBY1tiYdgRKsQfox+xYUbSaKYT0ZLgZNxDTWVDypA4JenzytEbHedUX+OPNhZ/83Psucd7DX72pDUoJUEQ56FIYOC9jBKdKiQ0RtVa0Iytxn6nfR1qrY8e62hNqC+wZv3f2IoHDcDwIsJ3iWXkPwzuZsDgauGzF+LCrFld7kAuBiHCts4vPlugu3dBi0y1Z37NIjQXGyk48F61mtCVC4myPlUQ8RSCrwxSgJ+03grFHWptXfsPqyLJvhfyLh+tPFIAWR6VgnWp24jUpbe83xOLieLYMSKSIFtCUK6iRv3E0kSETbjIHj67kxi1XyqnTfZiUzwGjB4b+xSN6YBrBvKgspUaRcw5iWQwrpCo6g9qmcZQGRQN5AT4aZHp4VGhUDNr2b8rJ9EWsaxK15iGDDKFA1mgvtPdDbX3VWt/uPo/M9aRm2ClkjFNPVkNgz8hLGe0QUlaKdeh41pZRMDDp513+/9Ouns1m+z/n8XiWkZrMv9n3dOmnY0BQ+jyX7unbK0Y2JiZH/Edyv69wuqPCyKynFYqdFFComHtc7EsNstfB6VE479B6nwOPIioWlAk/AatECdA0xMys6XTofl9w
 yL2cHKnJ
 Ih+rKbyFrYYJfttHSJwpjwIlFR6W/Ros3GQDGTeVTYt5g4dpvVEMGsjVuBGIyklnPJaSTYGPa7kUNIARkvSTOl+BaaPu6JZfQq69eeGcxensqmocJk64oprch5fXVu4RK0Eu2kY2qcwmmMidi6BU3/DUMTcAWgRWk96cenyWqiU4357rY/AezwqDeppJu0gRGbxlltHzzfGEnBQxQPie5m762qTFOmfRknukQhR0H5h5BRfF7lFizT38li87OZzZD7RSXDRG/cuxMdohUfhqRuRlDHdNT1BDKqmeR/+kn0XLonJUdRWvPKJLxNjG0rXct/QV6e7wxgjANs5d8XKBEH6lv7Se+a6Ksm91HYTo62ZXpez8sfoj9aFjoo3FQI5mWgQ2xijZujLy9DcJ9TEjKYd9ZUlaldM+AIs/NdWn6BTbI7x6eiXgeZEyDoLjLuz2Ad4mrhjglvlWHLUbiaWrp0TLSxHavi/2CPUt2
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, May 30, 2026 at 2:47=E2=80=AFPM Andreas Schwab <schwab@linux-m68k.o=
rg> wrote:
>
> On Mai 30 2026, Deepak Gupta wrote:
>
> > I see two ways forward:
> >
> > - It can be done in generic way where incoming PROT_WRITE means
> >   PROT_READ | PROT_WRITE irrespective of RISC-V. Although others
> >   (x86, arm, etc) would have to weigh in.
> >
> > OR
> >
> > - mmap04 LTP test can be updated to expect either of "rw-p" or "-w-p"
> >   whenever only PROT_WRITE was specified.
>
> OR
>
> - Add a new PROT_ flag.

This was settled when x86 introduced shadow stack. Instead of having
new `PROT_`, it was agreed to create a new syscall for mapping shadow
stack memory (syscall: `map_shadow_stack`). Scenarios like `clone3` or
co-routines required manufacturing a shadow stack, thus necessitating a
new mechanism to create shadow stack style memory in demand. Instead
of having a new PROT_ flag,  a new syscall was created.

>
> --
> Andreas Schwab, schwab@linux-m68k.org
> GPG Key fingerprint =3D 7578 EB47 D4E5 4D69 2510  2552 DF73 E780 A9DA AEC=
1
> "And now for something completely different."


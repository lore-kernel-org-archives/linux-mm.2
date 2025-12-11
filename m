Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AE3F3D41D64
	for <linux-mm@archiver.kernel.org>; Thu, 11 Dec 2025 17:13:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 09DC16B0006; Thu, 11 Dec 2025 12:13:24 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 04EFF6B0007; Thu, 11 Dec 2025 12:13:23 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E7F2A6B0008; Thu, 11 Dec 2025 12:13:23 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id C8B3A6B0006
	for <linux-mm@kvack.org>; Thu, 11 Dec 2025 12:13:23 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 5E9DE12DF6
	for <linux-mm@kvack.org>; Thu, 11 Dec 2025 17:13:23 +0000 (UTC)
X-FDA: 84207836286.30.7E07F1F
Received: from mail-yx1-f42.google.com (mail-yx1-f42.google.com [74.125.224.42])
	by imf07.hostedemail.com (Postfix) with ESMTP id 63B2940013
	for <linux-mm@kvack.org>; Thu, 11 Dec 2025 17:13:21 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=rivosinc.com header.s=google header.b=Q9wHsYC5;
	spf=pass (imf07.hostedemail.com: domain of debug@rivosinc.com designates 74.125.224.42 as permitted sender) smtp.mailfrom=debug@rivosinc.com;
	dmarc=pass (policy=none) header.from=rivosinc.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765473201;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XgsqjP5OdKf2pfViq8wHSszLchDHEA8k2q0YnXN+A5g=;
	b=yg2XnpHRZKCDul5V6pldZmREwv2ifzbyt7BEoFP2uDfBc8GxVrXZPLGD2NJY2OF7sGwQ5a
	/NXMyqGU/aUp41Kg0GufPeHYeqNI0ba0Unow2ZUnDS8+HTVT8n7gR3swZSOWKtM1iC661Q
	/3jV5Ha8sINeZqznUu7ir0+oGbMyfqY=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=rivosinc.com header.s=google header.b=Q9wHsYC5;
	spf=pass (imf07.hostedemail.com: domain of debug@rivosinc.com designates 74.125.224.42 as permitted sender) smtp.mailfrom=debug@rivosinc.com;
	dmarc=pass (policy=none) header.from=rivosinc.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765473201; a=rsa-sha256;
	cv=none;
	b=xMUU9/vWgpR2KuqWxfeqxnZ2C97NDO3X0MxvdR0rugm2bqiX+P30WfqjbRMEYnfuBRsIR/
	7VS/GwZEMpuzoP+DPiE9glLE0lx+4afpjscysaQx7e6j46qx6nEC/9jvA/sWLbq3oKnjU5
	Fs+3qm/fw7Ocxek2bPKsabPedXKNINs=
Received: by mail-yx1-f42.google.com with SMTP id 956f58d0204a3-640f88b8613so283148d50.2
        for <linux-mm@kvack.org>; Thu, 11 Dec 2025 09:13:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc.com; s=google; t=1765473200; x=1766078000; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XgsqjP5OdKf2pfViq8wHSszLchDHEA8k2q0YnXN+A5g=;
        b=Q9wHsYC5npk022JQ/uwzCU1RYAdHy04ywgyeXA5MqlmYf+lNaWIk++NjHWCjgSbH/p
         HVORGgufJ+89ApDfk/rr7W7vnbnfv1s77HY8owGcEE99HiO2/nhR6fXwCn0MDajDzU0Q
         VhSIwsg0JK3bp/5JrDgUfXFaT8NG9iyEgwQvdWF2Ny1EoZ4U/qGSY9/AlKD1zcdZ+qvq
         2pe+3BP7Pegt1pq4l2Ebbk3+DKrOPjmEY3qPqP2Di1arCQKJULt2bPwvMeWx/9NVl98w
         vbDIvX4PYQ4JD8Yup4CKSs9TChz8X7RMEv1VJWbM7lcJf64jfgW4LvTTXWHcCdUWmb8x
         C7Cg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765473200; x=1766078000;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=XgsqjP5OdKf2pfViq8wHSszLchDHEA8k2q0YnXN+A5g=;
        b=M1pPIMxgIuS+P7QHU7LxBnq3uGtl6ezeEkXrbR94m9mBMfqzkgvzc/lC8Flr+VFBwH
         Z7Q9ZpxyCq8565SPBwv4dmMrQyOjB2mhvVWsc494AzMoBb/f6TLF5UhHnHq512PV/iAu
         rCmAyZGEcOulX1uRVoL8rW+sZTxoCEpVkU/ydbGqNfs5mKh3E9+s5w72O8k0uI5wbOWO
         BU8c6oh+CkYC31x882T2HaDWyYDLdppmLRfrFbEfYds2I2xhUHe/2+0Fo/9+xTMzDdG7
         NCpj2jnj6KfpCTKSkwhE0SyLuk9OqMoouTk8TzxGlmhfpDRqXCcq9xg3WwSChMEL4Aim
         KVcA==
X-Forwarded-Encrypted: i=1; AJvYcCWjiP4eMc1nTltA5fjKyKYJEuk+8ee9v8tXLSgVR4Ou3jkYi/hdz5K/jLM5VRj8H9VoVTJretDkdQ==@kvack.org
X-Gm-Message-State: AOJu0YypfRnKmVTQk1hDF78bRKrKDeCyI2ytPl/mfL7yS/hLr3HDZVRZ
	FybjF9cIxXa5mWIgvXY4r6tVyohQLzjh8znlO9Dloyuz20Kr8ddUxFikdNJxkOLj7CiJGeALrEh
	lT9c/pRbpis+EY5fBXFddpXCjewhyfw/CxNvspu0XXw==
X-Gm-Gg: AY/fxX6xHlk4rXWbp5P34r3XkekuMCQDxwhbXo1NwnDQcdbnPPtFUD0XJ6mne/rMk/K
	0AvMow1kGvwfTPF4yD2+/ewMY68LQpduE2xfJfwt2RT3CtbLQjJqG09iFOoj9FCQFGQ4sH4hjpo
	5Aps2fhY0OCZnM4w5ybizSzcmdVrb9S8sAGLg+1pgXJg9/4aKFPceHHpto749Ft1NLRdfm7rSeC
	GFCDq87mH2Iks1ja7QkonpBI069GDeVu4/IfN0mRNF+lUk/jCQQXUmjozwH1ppsg/LFT493
X-Google-Smtp-Source: AGHT+IEDvxO44/POz7bnaB+zrKXCNOOS/WPSTW3GIVXm1upC0YATz2kq4R7kn6XsCe0YNeacKDOWMUqKTxb574ExUiM=
X-Received: by 2002:a05:690e:2514:20b0:63b:8e09:7a47 with SMTP id
 956f58d0204a3-6446e97b295mr4684556d50.19.1765473200251; Thu, 11 Dec 2025
 09:13:20 -0800 (PST)
MIME-Version: 1.0
References: <20251205-v5_user_cfi_series-v25-0-1a07c0127361@rivosinc.com>
 <20251205-v5_user_cfi_series-v25-6-1a07c0127361@rivosinc.com> <b2acb9ca-1320-ab42-3937-2ea17153fac2@kernel.org>
In-Reply-To: <b2acb9ca-1320-ab42-3937-2ea17153fac2@kernel.org>
From: Deepak Gupta <debug@rivosinc.com>
Date: Thu, 11 Dec 2025 09:13:01 -0800
X-Gm-Features: AQt7F2rXBhYBRubaxsEthZTktAJEjMnbT8BXdFrJ84aaWwsz26es8ubAplXa-kc
Message-ID: <CAKC1njTfn-5ZeAV7x5819kXUqitVgO0HkKQi1S6UvZyiuroxvg@mail.gmail.com>
Subject: Re: [PATCH v25 06/28] riscv/mm : ensure PROT_WRITE leads to VM_READ | VM_WRITE
To: Paul Walmsley <pjw@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
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
	rust-for-linux@vger.kernel.org, Zong Li <zong.li@sifive.com>, 
	Andreas Korb <andreas.korb@aisec.fraunhofer.de>, 
	Valentin Haudiquet <valentin.haudiquet@canonical.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 63B2940013
X-Rspam-User: 
X-Stat-Signature: 71ztomwqe3t17gsqtdbra4oxn46xa7f8
X-HE-Tag: 1765473201-934618
X-HE-Meta: U2FsdGVkX19yi3NuQpIIGPPKftyTjAQe4ejtdAbIGrdHK7BlXaiFmmwV464+ZdtBesuVnU0M6uR1btd5QffReJjy5gs+1bA4dmcuh7lhti0WZppT7Ql70c6Qe1T+o5Ve4I3V2pBFm7v0GeX/Cos1RL6q6DsbN20RNN/Zf3AwaeMgRqPyhSAr4ZoQVBshkiWgzCNDGGQs4RtcRNmXe/naI+Xw8vpE+1HzEzjswtMni9evjyYHeGR7QOYE1XpDK6svKKl022o1BKu/K7yMi/jOacZclykIyclTRf8+p5kEgynxzVeEgtzUD3xJZatNwuNUaDAw1OB/TERLoc4NApChsoLEUDZ6jg9XOasuRPE+Dx35j6wGpFr4ne/D5zNTAGkrJDqD0jz4VF8xmCCGl0696G0K/P7TmIQzcCP5yqxG6GZMxxX9Dzb2iH/p9cfPMocW3iMqvc5ljnc+xtqaEQwa8I44DW5RCRe/7bfaCqtWeXohhLrw7srCq4N/iAfREn2r6AkPsXW4ezeSIHYBTLHEEAh6qe1ieOT1qccZDn4P5jXy0O1/q2QVoSwCutlYQF+gQDpY9CroZTb390EyFTrZJ5JVzgJjH1Z5marKRLF4eqygJ3X4HYkmrZZrMSAatrECVPcUJpBYRXhPzyUPy7KicEKOVzl9Yh9AEopjZE5lnIxU2NPO7oCzdFHPpssNQrrIJIfxLtTSiG4/gpcz7X4KdyKWjAv+HzHCbBR4yW3fW1HC5GAhAHvjFOxlQl0u7TDfvHyyO4PjleYVbbbiy2PffU62UDQ4FheuaB/+lPYyWM580veBebL7YNdq+ebPF1mMvlYYVjST8Li1A9JmCrGoIdE0NREWZjLPxcSWE+lbfxuSZu6MTvh3VO1tx+sr/t0yAEDwM/W7+nj7gHPeq26so2HK1deOT8aBFnPJVHvEMQikQvhRJINeCc2Xm3f12lPnoF0Gb81oeKfQHaVVQTW
 LcZBDmqB
 dSn3uoqnzb+g2gbJ93G2duEvn1kI3Am39wRbeujQjQFIsSM6QAPoKEt5z2rq7AhkL3tNqP4Z20vfM+JjulN5zIObnIAG0rSzbnbJDbAcvaeuMxsU1OiZoAbDglXjebu7mJHbn9jjyY4/cdF8G90BNcFvB5dH10S8cKj/8eRux5C+InzcMFDlEe+4fiNGXVrPKxryI7HroSbqpwe/K29ySNGtfmARNHXVtdnP7Zhp0H0ONEgRnPBb5qiZb6jUC2f+H52NM8OhpAuj5TPzjPT1Wln/I9etwAiYCPsXfvaGC3qhu9OB89ySl2mSreBnImLauZunOYE/DLrutxxxAzcPb+p6asrkWI64KXMRNpFJRz0QSxUq4Sc++ftIFTmqdZXxYlLmBxnVGU3G3tvv/y4GQ4fkq0b2Ws2qzauglnAAss2u03qr9q/5jGudwGgH6Z7fmn7OS6OG0ApfEtVg=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Dec 11, 2025 at 12:47=E2=80=AFAM Paul Walmsley <pjw@kernel.org> wro=
te:
>
> On Fri, 5 Dec 2025, Deepak Gupta via B4 Relay wrote:
>
> > From: Deepak Gupta <debug@rivosinc.com>
> >
> > `arch_calc_vm_prot_bits` is implemented on risc-v to return VM_READ |
> > VM_WRITE if PROT_WRITE is specified. Similarly `riscv_sys_mmap` is
> > updated to convert all incoming PROT_WRITE to (PROT_WRITE | PROT_READ).
> > This is to make sure that any existing apps using PROT_WRITE still work=
.
> >
> > Earlier `protection_map[VM_WRITE]` used to pick read-write PTE encoding=
s.
> > Now `protection_map[VM_WRITE]` will always pick PAGE_SHADOWSTACK PTE
> > encodings for shadow stack. Above changes ensure that existing apps
> > continue to work because underneath kernel will be picking
> > `protection_map[VM_WRITE|VM_READ]` PTE encodings.
> >
> > Reviewed-by: Zong Li <zong.li@sifive.com>
> > Reviewed-by: Alexandre Ghiti <alexghiti@rivosinc.com>
> > Signed-off-by: Arnd Bergmann <arnd@arndb.de>
>
> This Signed-off-by: doesn't look right.  It doesn't look like Arnd
> developed this patch, and it doesn't appear that he replied with a
> Signed-off-by: to the list regarding a patch that you wrote.  Did I miss
> it?  Did you mean Co-developed-by: or some other tag?
>

Seems like b4 messed it up. I'll fix it up.


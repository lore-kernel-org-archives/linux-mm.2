Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DBDD8CD4F2C
	for <linux-mm@archiver.kernel.org>; Fri, 12 Jun 2026 07:31:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 136986B0005; Fri, 12 Jun 2026 03:31:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0E7456B0088; Fri, 12 Jun 2026 03:31:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F179B6B0093; Fri, 12 Jun 2026 03:31:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id E127E6B0005
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 03:31:05 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 79981120580
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 07:31:05 +0000 (UTC)
X-FDA: 84870439290.24.CAB59ED
Received: from mail-ed1-f43.google.com (mail-ed1-f43.google.com [209.85.208.43])
	by imf26.hostedemail.com (Postfix) with ESMTP id 6A5D1140003
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 07:31:03 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=MJ78ll1k;
	spf=pass (imf26.hostedemail.com: domain of glider@google.com designates 209.85.208.43 as permitted sender) smtp.mailfrom=glider@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1781249463;
	b=0Wu87H99M2x6O2ude8QJyv1gud3pCYNLL85qhW5ahGj0Sp3KhQ6a4+XtmfO5zee0IU+v4i
	xhxYwPoXHVYlTjqU8Poqt0bVEIefnCG2t81lHYf1eZEsh7GLCgIpCxBHmixDPFqpUGiY5e
	Pj22gDItbsbINVJ6dg6UPz63CymugH8=
ARC-Authentication-Results: i=2;
	imf26.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=MJ78ll1k;
	spf=pass (imf26.hostedemail.com: domain of glider@google.com designates 209.85.208.43 as permitted sender) smtp.mailfrom=glider@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781249463;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SbYOYDefhLvBGJQzilDjssSWO2zIKceTdBiGnToKxU0=;
	b=pBLvwj3VKhKvowJp/RXTOHvbuBfooIZO8Z3R/nuDBjwKhKMDMbv4nS1PqjG3BtrcBEIfnq
	WTVDk2cNQVk/V7ZpnLgpxBE9HuH8YlvCOl7tho0kzSX3f//xSEymb4b3VrMV6GSVkXWbfJ
	rMNeqYdXBA5b2vQKCBClfjumsJP1sUw=
Received: by mail-ed1-f43.google.com with SMTP id 4fb4d7f45d1cf-68bfcf11050so1199549a12.0
        for <linux-mm@kvack.org>; Fri, 12 Jun 2026 00:31:03 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1781249462; cv=none;
        d=google.com; s=arc-20240605;
        b=See8hSm8OGZK9rKkwCDOUXQ4/38rpNFjqcwqNVDqQNfZBFLxRw7Tve6Q1hxC72rlKb
         WVs+cpB3413oN5hvF+LwEQwt3nq18IuTvLo23q8RbKQz54BXdo9xDPZWVV3MWIiQU7zS
         6IKw282QCCCiV/RpZXYmSuSGssFQXud8tCcNwvfSo1X5zchOm/f/6/9tYCu1Y0U7GX86
         X7Iw1XzIJVwj33VFxzfcrlBPXzSyUeBUIA7J9SdDWKrF6sVEupwdig5wJU8V2OKkRJ4v
         yHgp85dV7OamqcHWKCx4A4bRCgi0JG03ZElWq9RliAFJIda8/nAm5qRlqx2kzMe7P6SE
         5zPA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=SbYOYDefhLvBGJQzilDjssSWO2zIKceTdBiGnToKxU0=;
        fh=tvrnCnRyhVXqoxr0ta4Iiaxp9mDKCsVHlwr2Ae6CslA=;
        b=IGUbHG9308fkm2rrcUdI7kxus0K5bgOox317gVPzIQxav0Wzd7OzjCHSvqG7KM0g3F
         9wEx9Ww+gxYCLIY49YUSpZ6p8/jPvoyBRYJtg6Ic6lNhq55Ro2jGb/m2t+LCqOIUizUx
         8pwjHDer6fzfpT08QbyGXCXkNWZV5FDkT0Ex+/2jwT5FUyxUUfJ2mISl/oae3AneP7wT
         xpEy9zWBWFfNyOp+rQjNNJ6D1QGDWJlbaWRP8vZoJujX4TzzyrjSlcEK7l12g7M5aVDF
         rPKURGxi33Ouu7rzBysQSyQH25ZRWAV5CfGi3xPE03DIhIrAC6RsFXCJ7WDAVudJDCG8
         CVgA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1781249462; x=1781854262; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=SbYOYDefhLvBGJQzilDjssSWO2zIKceTdBiGnToKxU0=;
        b=MJ78ll1kpGJ/xHsyBx3RJJL1gX8CNlafsPjVWz7TKNq+7NzTmrBZnaX1FGU4ar37Sx
         A0ddtFBmT16Gimmtt4bs0mPCX5KW/aNDkHa8QTQRn7jK0mRWXNNfFuo4ZeiCt8UK0eVy
         Gl00t69qJK4cLwkHWPS/6d9JtNgsxbNHMu5GZrXrU6Fj2Qnf/nEZasKEjVNxN7lOQp3F
         86BBdGceY1g22qb+ey+yL4k2u8sl3Num6zi+htYPSe8YQHrtG1v4KNNoBb1/sT56D8+W
         7Z4PbgeDrItSSWwpn0B9cKyfhEZAZ72cCqysCXJxzgui82vUusEcpuUlF0D9xuucr3zk
         4ECw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781249462; x=1781854262;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=SbYOYDefhLvBGJQzilDjssSWO2zIKceTdBiGnToKxU0=;
        b=VD9MyrDFfhbZCQJPNq1ccG2EPWMi0zaIuEBoTayMYHEJR+JRGDlEhwPLYcMccP94tC
         oE8tXmhqjSRrm43dTy/BqESi6q6qLVfwBmS8R32UwFOj6vrJU7iqMrQ3Tx3JfbobhB5K
         1NCepaOPnh/A9N5Tc7N9mTCY8bMVNFd874Zfj0qDS4w5tmXpbv43qoRk4vHiFoZau9zI
         86+pX28BIV2kCNW2ZzPICWqevbBFHSWUd7SZVBnHRvP7C45lZvA5CB1aXz4uGTeKYrBF
         MJCpLBaZUF5cmMXOrbI267HhnedVviB0K7s/SRuUlfnHofwnDOV6omBFlX7OAnY6pkTo
         p1GQ==
X-Forwarded-Encrypted: i=1; AFNElJ8Jpl6fY8mOY+iDDQaABOH10tvVI2BSUtz8GSItaQPR8QXnD4734L4e/gtfl95cfREXhwEzgZpfqg==@kvack.org
X-Gm-Message-State: AOJu0Yy8ODokfPYEH3173AQ/WRuGNflQAo+iSod79haXDiNcKmiTs+Kw
	e/6fc4Yp77OJ8zk/8eRLbr3MiaG7V7HMyC5rDk2YqG6H385wQDB842dExVpSN0bE8woBD0WaXYB
	BcY2dibReDDRSRibnwvXgtQAVrBGc4gGLDscF4Xfh
X-Gm-Gg: Acq92OEAzvF9J79jseXNL458I46QircDE/8r77DUs4dYssplwLzelboXi3HXqeDgim4
	yWEg/S2zL7Sr2+3Ahf37PeW4uPU2x2I9WCIF4tUCG/IhHsC3BERvBMpOsd8IysgUYapolo+oHIB
	x3ksAwsC7mB9R2cjRwA4Miwhm/3X2nIO/qxefQZwbm2OIFMKJ62xoX8NS8VTb5VtC3oh8XuDZKK
	WqvqXgMs3LsKqGZYGp1LiA5M/8Qe89rGRA09cUt6ruUgF2RUUpSMTAW167cw5hYxSevt907NmeR
	eR3HQeesg0UqJU9oPjOzic/+QIIbAsVjBlneSQ==
X-Received: by 2002:a05:6402:360e:b0:691:ad29:ea33 with SMTP id
 4fb4d7f45d1cf-693779d1edfmr692502a12.12.1781249461160; Fri, 12 Jun 2026
 00:31:01 -0700 (PDT)
MIME-Version: 1.0
References: <20260611-b4-kcov-dataflow-v2-v2-0-0a261da3987c@est.tech> <20260611-b4-kcov-dataflow-v2-v2-3-0a261da3987c@est.tech>
In-Reply-To: <20260611-b4-kcov-dataflow-v2-v2-3-0a261da3987c@est.tech>
From: Alexander Potapenko <glider@google.com>
Date: Fri, 12 Jun 2026 09:30:22 +0200
X-Gm-Features: AVVi8CevQ1ha7IS1m5wrojNeqF7AokFDz6V9vLKSYwmszS5cFjeqHBoSGHAAq9c
Message-ID: <CAG_fn=XRzSuFrxtFbz2t9jjY8HPUUhhnU3iWJiSV-X4+hg66cw@mail.gmail.com>
Subject: Re: [RFC PATCH v2 03/14] kcov: add barriers to recursion guard in kcov_df_write
To: Yunseong Kim <yunseong.kim@est.tech>
Cc: Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>, 
	Juri Lelli <juri.lelli@redhat.com>, Vincent Guittot <vincent.guittot@linaro.org>, 
	Dietmar Eggemann <dietmar.eggemann@arm.com>, Steven Rostedt <rostedt@goodmis.org>, 
	Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>, 
	Valentin Schneider <vschneid@redhat.com>, K Prateek Nayak <kprateek.nayak@amd.com>, 
	Andrey Konovalov <andreyknvl@gmail.com>, Dmitry Vyukov <dvyukov@google.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Miguel Ojeda <ojeda@kernel.org>, 
	Boqun Feng <boqun@kernel.org>, Gary Guo <gary@garyguo.net>, 
	=?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Benno Lossin <lossin@kernel.org>, Andreas Hindborg <a.hindborg@kernel.org>, 
	Alice Ryhl <aliceryhl@google.com>, Trevor Gross <tmgross@umich.edu>, 
	Danilo Krummrich <dakr@kernel.org>, Nathan Chancellor <nathan@kernel.org>, Nicolas Schier <nsc@kernel.org>, 
	Nick Desaulniers <nick.desaulniers+lkml@gmail.com>, Bill Wendling <morbo@google.com>, 
	Justin Stitt <justinstitt@google.com>, Kees Cook <kees@kernel.org>, 
	David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Shuah Khan <shuah@kernel.org>, 
	Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, linux-kernel@vger.kernel.org, 
	kasan-dev@googlegroups.com, rust-for-linux@vger.kernel.org, 
	linux-kbuild@vger.kernel.org, llvm@lists.linux.dev, linux-mm@kvack.org, 
	linux-kselftest@vger.kernel.org, workflows@vger.kernel.org, 
	linux-doc@vger.kernel.org, Yeoreum Yun <yeoreum.yun@arm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 6A5D1140003
X-Rspam-User: 
X-Stat-Signature: sirorzfti695d747fx69te4r69714duy
X-HE-Tag: 1781249463-827220
X-HE-Meta: U2FsdGVkX18YEYXeFSoh6j/gW0szD3sAxBnvuqIRYGWMBPmenOVPTymiFSyXoDCGQSIp2mRov9dUjiraQPFe3k8VkphqJmZMjsaNroBfS8w2L+mHXzt73C1m9DQZsTTk3iHTHN1yMv9g7nd9D+5P9Vlz/HvuTnimS1Y/ZD5+7jh4VoZKdRawBDVTEdrpQYknnP2dBh3ucIVp377a0TIlg1eFq2wgaxyq3ie6tfThNyfMaH6nVQfayxbsL7c99sNC0PLrHWFU6pJMTCUv8736rN8H1BxBu7dmW6FaEYFkhMOz6wfxQMGYIlZLJzhoK3f9aCBO7QM8i5LHwK2qLeRfh9n4ydEEA2LKd0Uhz3t6MFTVqztQxA0tk+0lR4Ui561bei4b1ft6ZLNbW166Q6rz8N4zdUQkRUZM6QBKHXe9EZSVHXmKKThceKu+I5c6Qd3hGMgNp7uEk2xlHdY6BidxpmLLG2iEFlOQJqllr0A9rtQz9SImESc1+tcoxzftYXVGLnzNMJqd1ak59bBBULLVjQQkAUoSsmukihwMGQF9BbpR9eep8zLwGhEvmyARCedo9S9QUj4vhL+S1/BZhjtHWhSUS9WIn4k8bEJNXZEwkqZ5sYSgbu1mMTwgdKJKf9oDq6vonAtwCpE+2Zic+M2tQoWVJ5emMQ3xm7VAOsfDb2FJ5z7srGvXsmj39BrrmE8RKTta4BNsFn6pIDilz5ROsoQ9K55P1dMIpazdr1pJJqXpOJch7KOE4BqjzvgVO4aqA5QiqQboMED/HRZ+MmIXuNgvikBq/o6KBcVeE47lF2fLEkktYKCSN2tc3NLxfMe9haXlBQMOHlnT+D0gT5gCs/klf4OD8Z2aLDtUJ0WKTv7EilaKvvooUbVE07X0w1WOosre3mEgGUJGIg4QFGi8EhjwFxuwUnIHGpDa1x6kkkSIml61eYC13ysUrxOpj81st5umRKHHvXx7nuCi4Ra
 ewRDFh2d
 sWQLot8RetMROAGxfXOpM9B4PW3ars1NQH9zoeZlzcDwM6JleZRAUmxqNjy7v3VzfFyGCaOWQOScR+EYNzJB1mRMEOxBVmtnKmhRI3Y20gzP+G5W2VNzMofJEeKLOAmQhCSmn9TrvnriKHvW+NkDgAQYWaZ6lwENOEQX0YMl28vJDbz5GpzxrEVoqGddA90v/1OmwA6Iwi7qSqPlDcJD+WqhqzAqg6msqo5Rs65lLQg4yZGV0hKcAtiGPm4a9xGDvyFL7lQj08OBLBEGA3sRIlI1L9qrSdMJp6dXN9dsNY0zT6DgnV6vRRe9U3ICFQ2H5j+86fxDVdHLKyaDZQnRcJyK5o+OkWRdUPrNH6+vaGdhtXILLIecCiD7jz0d5ZxVJtC5QHaBUQePmf5jvZ8M2DprkXcjTjFG/Mpub/C6Ap+IyDOG8/0lyitdXbBSwVZgXOdAzS6fosr1bGDDEMgYY/g6g8EXek+Q3DflDmbVhyasN9oZKVc4f1KpFY+7fXzi7Yg+tHyFmtHVRMKwc16vbygnr5NW3HdAPnZAF
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jun 11, 2026 at 6:21=E2=80=AFPM Yunseong Kim <yunseong.kim@est.tech=
> wrote:
>
> The recursion guard (bit-31 of kcov_df_seq) prevents reentry when
> copy_from_kernel_nofault() or other called functions are instrumented
> with INSTRUMENT_ALL. Without compiler barriers, the guard set/clear
> can be reordered relative to the function body, making the protection
> ineffective under optimization.
>
> Add barrier() after setting the guard and before clearing it, ensuring
> the compiler does not move instrumented operations outside the guarded
> region.
>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Signed-off-by: Yunseong Kim <yunseong.kim@est.tech>
> ---
>  kernel/kcov_dataflow.c | 2 ++

Please merge this patch into the one introducing kcov_dataflow.c


>  1 file changed, 2 insertions(+)
>
> diff --git a/kernel/kcov_dataflow.c b/kernel/kcov_dataflow.c
> index df7e8bf70bfa..5248293280d5 100644
> --- a/kernel/kcov_dataflow.c
> +++ b/kernel/kcov_dataflow.c
> @@ -86,6 +86,7 @@ kcov_df_write(u64 type_marker, u64 pc, u64 meta, void *=
ptr,
>         if (t->kcov_df_seq & (1U << 31))
>                 return;
>         t->kcov_df_seq |=3D (1U << 31);
> +       barrier();

Please make sure barriers have comments explaining which barriers they
pair with (see kernel/kcov.c)


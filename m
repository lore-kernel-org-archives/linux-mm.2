Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6CA80CA0ED1
	for <linux-mm@archiver.kernel.org>; Mon, 18 Aug 2025 18:47:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0C54C8E002A; Mon, 18 Aug 2025 14:47:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 09CC88E000A; Mon, 18 Aug 2025 14:47:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EF5CC8E002A; Mon, 18 Aug 2025 14:47:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id DD7AC8E000A
	for <linux-mm@kvack.org>; Mon, 18 Aug 2025 14:47:03 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 85C92160734
	for <linux-mm@kvack.org>; Mon, 18 Aug 2025 18:47:03 +0000 (UTC)
X-FDA: 83790760326.18.2A8DB21
Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	by imf19.hostedemail.com (Postfix) with ESMTP id 90ABB1A0002
	for <linux-mm@kvack.org>; Mon, 18 Aug 2025 18:47:01 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=qsIkFwsk;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf19.hostedemail.com: domain of aliceryhl@google.com designates 209.85.128.43 as permitted sender) smtp.mailfrom=aliceryhl@google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755542821; a=rsa-sha256;
	cv=none;
	b=t+bfZQlixFM/vI1Co6JeRwGxPsCOzWpijjVxcb2gerHlWZL5p8VzMT0VhDf4j9BFPAdhtA
	W4wD7GDEZF8lX5kvgZKzStYSusuEsHLYosuVqxJ+h3BMdgawCURAuRxY8oBUjoV8WyOlC9
	hoJAAD5iChm/eA8uD65VjwM++UW2LtU=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=qsIkFwsk;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf19.hostedemail.com: domain of aliceryhl@google.com designates 209.85.128.43 as permitted sender) smtp.mailfrom=aliceryhl@google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755542821;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Me1o71bySPNE6ozhOT6isRZtcdCRFNLWJRygKFvabT4=;
	b=TRBXsmPZTSbtNbuXSgizoc8Uzi0etHSZea36zYWp2SXa3pwmaqMmkk/oE9+z03eqjV9dOJ
	2Us2stDpOBx3lB+urEftlZP2UfxGJzynZx5ffC4N5ggS5+4MWlzVND6uiY3icEQ1dguLnk
	meKT0O6FF2aZD2eAZkPHaKvAH8fcDoo=
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-45a1b0becf5so23905975e9.2
        for <linux-mm@kvack.org>; Mon, 18 Aug 2025 11:47:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1755542820; x=1756147620; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Me1o71bySPNE6ozhOT6isRZtcdCRFNLWJRygKFvabT4=;
        b=qsIkFwskL0aJskLzpHI2RbW2OGHyvvOZWW8N3vtdA/6DueKpNb+4hOZT43qlD2Axde
         9uHYHw+TAGVUSAD+A1WOyEb1v0Dlf9R5+HCUmrK8/JtdRwUIcY9baPGElaKJ+PXPPxAi
         Y6Ghqx0qsUAnoloRWwvY21ClTle9Z4xBvK6f/zBYwBwjf6da6ZMJngWzuqBqklAnZ5SC
         hfXFyRN75yNBsRV9HH4IHUdpW9nDUV+Ke5jgUWJBTdfOfbjc8foyQOsCMSVaaiXrAeaE
         BwJkTGfgxW8adoYA8+NqjSG0lhEVdMZ+4IAmua2b+PY8zq2KVenETkElZHVti3KsoN1A
         bu6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755542820; x=1756147620;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Me1o71bySPNE6ozhOT6isRZtcdCRFNLWJRygKFvabT4=;
        b=v4P47w08uxo9M87CrJ4F31O2y2ijVGuXvZk/n0hnla2Mg1GIH3gMvoLjprxerO8u78
         5/Y6UHoH1CSLRQDvJiXk4+9WV3VfBiFv4vJFg97WsRUMqVW6RfQ5pMHV70LJw9BKIgcW
         GJDlnBj+Y95wj0pAVop5U8JHQZ9BlFTQYkn0K9ra733BsFv1dEJGvwh+jYPJa8vFl1Gy
         Mr9k/ShzPAPtk0GPDtul13D3W/9e48NrzwOKiCX6reNYah9yOEEib+/T2oCRfrPxPiOn
         grFpyWj3Wb4bQTr0PB2My0gDj5ILsoxdllNf1/yls9Vx3z1d5GHWTtPNlv0cuPjYJYpB
         8BOA==
X-Forwarded-Encrypted: i=1; AJvYcCXzabW0OpCSn7f3ZAZCDtJIMRarget9AuDfaLegRJbq304+Lt3pkqzJ7ZeBVfr4rHqZVi6fxThLQg==@kvack.org
X-Gm-Message-State: AOJu0YzPHuYxFQDcT8YWLMXWydKR7uImaFCDrR9T4mMo9TOwbXOLuHAq
	YQvADK39wAJhXPszSfCQHMMrAZtZLxN1ut35HTTtrhOLHyCnpL8/sc5DPetETtul0ycE6u0/ZbW
	xAr67LYRhGzqkOc+onby5NUvgSZRpkbuvkZpuLebq
X-Gm-Gg: ASbGncuOk442/ldJM/pBb7WqpVJ9onLJGNmPMUqPwFK5IVhRKKkUWCuZRbnpLXavQa7
	LkfJbsweamBoHe1Xkgi6lOLCjnjZ60WKj5wHHvH97OKC4TlPMuXVt1DyKNt6hVc0jP1SXKLrfM5
	JrA9lCQtp6yOeJh08TyydN+6cy/+A4lNuAne+fZwQvMNi9n2NlDQnJzGASIaprzkGcjtD+DUr8u
	Igk0+JPqvJTYOTSuFA=
X-Google-Smtp-Source: AGHT+IFLXetOVp8U2f0VHdoGA8Qd25eyC4/86+oKYuuZu1tnTogajoOeu9n4fKnmqFulipmTJwqdd/mlNYD6PV1NV2E=
X-Received: by 2002:a5d:5d07:0:b0:3b7:9c28:f846 with SMTP id
 ffacd0b85a97d-3bb68fdd74dmr10640572f8f.44.1755542819634; Mon, 18 Aug 2025
 11:46:59 -0700 (PDT)
MIME-Version: 1.0
References: <20250818180923.192042-1-dakr@kernel.org>
In-Reply-To: <20250818180923.192042-1-dakr@kernel.org>
From: Alice Ryhl <aliceryhl@google.com>
Date: Mon, 18 Aug 2025 20:46:47 +0200
X-Gm-Features: Ac12FXz6gbvv-OYarFDJOsB6rcv3wq6rTkOI9n_bRh-TEbKfUIQz8PkeqvTnRj4
Message-ID: <CAH5fLghXq++6MArtGjHjjP0=s4m9Faue9kokyN7sR4vuHGtrWQ@mail.gmail.com>
Subject: Re: [PATCH] rust: alloc: add ARCH_KMALLOC_MINALIGN to bindgen blocklist
To: Danilo Krummrich <dakr@kernel.org>
Cc: lorenzo.stoakes@oracle.com, vbabka@suse.cz, Liam.Howlett@oracle.com, 
	urezki@gmail.com, ojeda@kernel.org, alex.gaynor@gmail.com, 
	boqun.feng@gmail.com, gary@garyguo.net, bjorn3_gh@protonmail.com, 
	lossin@kernel.org, a.hindborg@kernel.org, tmgross@umich.edu, 
	rust-for-linux@vger.kernel.org, linux-mm@kvack.org, 
	Thorsten Leemhuis <linux@leemhuis.info>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 90ABB1A0002
X-Stat-Signature: mzrehd8egst1npo1c99i49pzspdhd6e6
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1755542821-989746
X-HE-Meta: U2FsdGVkX1/0bdVWv+vBndCItb1mAiaOXylqTuc1DPiEWPSmdc3Y8YMGqK6nld7sLySfDXeOZfbhuVJCjW7reL0Qm/rDlOzR0KQA+M/qBGZS1+I1O01ukPNPsIVaF5D8AwWN1yj9vUKDPNx6KZczwolM93tFfePW0Ju6iuC90QNohCUbHixGvu59lh7gcxfoQt3foxWUTpLCfRZSAa8g4TlFptlVgc8TnFE9WtCnUcpvOwZa7ABoDaTyvGlRxOBuzUCADSTAkVqLcXLBNXPIPZmPdaRBZS8pz84SXPRe8ZyNs5eR7E1YrJE14frcdrG0zaYH85nxH4aB4IhPjD/Q+mebcWRDQl+Xq536SgoXJ+RMxsUNJ3FA2DPvfdRudzwViasRGoT7naA71KT0vrXM8yUp9x7NChw4DKbvsEiijgUHptH467POH/3RHfvtAL7/KubPfvTxMsK6/LctppGxXSl3SPK6WmepOrpQQb339T3CY+qa6j9PwAOI8i2ycVWZZX477nTO6SkiwYzJVJem9rFRFEZyhisZw10HJx31xxCs1VvgpIs3AEHhAgVUIjit24ZodBEaB6IVmK4dT2vtDM8NZ5HedkVo1iVhn0U64hQUzLmLqbzvsbHD5bUoUCrdYqFxPqDrophYbd2bbm9Mil4loWxRSqZ+EbNq96eFZGZ2CvRh2t91qyhTE4rFLYR/gG+emAuvWZrDK7MWcIATp64duaCQqZgALZ8mH9KuXOzuG9axuRD0fQOHs5TLicp6T9sskjnm2E09eAPpr/ERMDxJepgOJYB87pe+/NHoPbESu+cUWN06V4cMRo3dbaXRrfMYn3U6ufE1Hx7YL4nvIePD8FTJPBy4AZJdUw2AIEX6G9jXCCDfjzIo/lxBXXofWFcmhZe8v7oWoeBIckA3T3o4PYAGmNo9dJW2Y7C7HUBBtvp7NmuZFliAEoh+DuXN4WjAR7qjNRhMbiHnzdT
 0VE0utKq
 jVdwSafXf3ObSAe608/HUOWLHSut/uregLwrc0IaBXow6NDiCMTA6elRNJLH+G6QPfIxZ24OowuIJx6/s8U8vxzQB4FgWLOkto/66J6x+NfiXAOIOc9O9qHqsU1O5MAsoNVc5KxJsUTORYu6lTO1BU6zvn/9g9bZfiTLb9mswfK/dal8Fo5uNq3nBupM1r2su95CCV+nsJ6t8rXkaloZTcpO8qI3sXp5OFzyTNz1cjJbDZfnSFnRPb21y28boKavlFXbSlYaFxLd5jItcgWr2amHCgIwbeBszA2/6n5xW4xhmcS/y4XjVbdzv3TM7fPKzXN6rKsKqKKcWS2HkQt1etkbEuLLfc0xNi6YmfQmB43YtwTJh7LMvHRIRZevB9LAJQz9hUK81y0XGhyZvcpqquxt9hpxob8fzQ4Q3
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Aug 18, 2025 at 8:09=E2=80=AFPM Danilo Krummrich <dakr@kernel.org> =
wrote:
>
> For some architectures, such as X86_64, ARCH_KMALLOC_MINALIGN is not
> resolvable for bindgen. E.g. due to being defined as
> __alignof__(unsigned long long).
>
> Hence, we have to create a rust helper, i.e. let the C compiler evaluate
> the expression and store it in a const.
>
> However, if for other architectures, such as arm64,
> ARCH_KMALLOC_MINALIGN does evaluate to something that can be directly
> processed by bindgen, we end up with multiple definitions of
> ARCH_KMALLOC_MINALIGN in the generated bindings.
>
>         error[E0428]: the name `ARCH_KMALLOC_MINALIGN` is defined multipl=
e times
>               --> /builddir/build/BUILD/kernel-6.17.0-build/kernel-next-2=
0250818/linux-6.17.0-0.0.next.20250818.423.vanilla.fc44.aarch64/rust/bindin=
gs/bindings_generated.rs:134545:1
>                |
>         9622   | pub const ARCH_KMALLOC_MINALIGN: u32 =3D 8;
>                | ----------------------------------------- previous defin=
ition of the value `ARCH_KMALLOC_MINALIGN` here
>         ...
>         134545 | pub const ARCH_KMALLOC_MINALIGN: usize =3D 8;
>                | ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ `ARCH_KMALLO=
C_MINALIGN` redefined here
>                |
>                =3D note: `ARCH_KMALLOC_MINALIGN` must be defined only onc=
e in the value namespace of this module
>
> To fix this up, add ARCH_KMALLOC_MINALIGN to the blocklist of bindgen,
> such that we always only generate the symbol from the rust helper.
>
> Reported-by: Thorsten Leemhuis <linux@leemhuis.info>
> Closes: https://lore.kernel.org/all/8aa05f08-ef6e-4dfe-9453-beaab7b3cb98@=
leemhuis.info/
> Fixes: 1b1a946dc2b5 ("rust: alloc: specify the minimum alignment of each =
allocator")
> Signed-off-by: Danilo Krummrich <dakr@kernel.org>

Reviewed-by: Alice Ryhl <aliceryhl@google.com>


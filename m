Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 34F7DD24449
	for <linux-mm@archiver.kernel.org>; Thu,  4 Dec 2025 17:19:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8F55B6B0088; Thu,  4 Dec 2025 12:19:20 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8CC6E6B00A5; Thu,  4 Dec 2025 12:19:20 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7BB2F6B00C1; Thu,  4 Dec 2025 12:19:20 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 67C8F6B0088
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 12:19:20 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 1196C8924D
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 17:19:20 +0000 (UTC)
X-FDA: 84182449680.28.1FBBBC5
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf02.hostedemail.com (Postfix) with ESMTP id 8DF738000C
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 17:19:17 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=E5QxuICe;
	spf=pass (imf02.hostedemail.com: domain of cmirabil@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=cmirabil@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764868757;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tbhl1hB6Go7cKeEzi9fq0ksxVXWeewQm1ULfbDi4zC4=;
	b=8cXjAWr+EdShLssQX10Au450Z5LtxWAqnQQxUBB4l5m0ictm34/kbZDGMVU9x+kjJCiXYJ
	GgYqmEERBGXd5535kj0qCtxua6sULGC6QuzY0FgC4r/I81W5p1Zy6LN3eYqfgWgaOITJbp
	21rewfJjQMtb9qeO2YNNh9pZ9kSjKbY=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=E5QxuICe;
	spf=pass (imf02.hostedemail.com: domain of cmirabil@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=cmirabil@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764868757; a=rsa-sha256;
	cv=none;
	b=TvPqUat2SBWcQEcTcMpyjGFewZRStrFQfrO2I4zSmwJ6/l7XF7ewyMSQ+JrS6inz5+AhwU
	zkcOga8Hg35wTqulVEgX16CeMssTfqywn1U2Wfld0nNOd00SvVtHU0iQ7sGE1S+yS74DjH
	ywirVD4GNPYPtEhjrfgI1O1376mtUik=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1764868756;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=tbhl1hB6Go7cKeEzi9fq0ksxVXWeewQm1ULfbDi4zC4=;
	b=E5QxuICeo9FKTeP3+4l3ttmQGIuqqbORbSEWoQ+H/F1HoF9aJOdw6NSi7d3JPkHwWTJdqc
	oIaIRJPdwOEnMH4fA3U5Xmd6snI7QMYUic/Rq8EilapvUDrttsLc02j7XRz9HnGCgOAGmR
	NXjgbNjw/JalK27Mv91uLhNMl7d45wg=
Received: from mail-ua1-f72.google.com (mail-ua1-f72.google.com
 [209.85.222.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-639-gC22A7RkNzqfWRUPTP34GQ-1; Thu, 04 Dec 2025 12:19:10 -0500
X-MC-Unique: gC22A7RkNzqfWRUPTP34GQ-1
X-Mimecast-MFC-AGG-ID: gC22A7RkNzqfWRUPTP34GQ_1764868750
Received: by mail-ua1-f72.google.com with SMTP id a1e0cc1a2514c-9371e5b4a4fso1623921241.3
        for <linux-mm@kvack.org>; Thu, 04 Dec 2025 09:19:10 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764868750; x=1765473550;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=tbhl1hB6Go7cKeEzi9fq0ksxVXWeewQm1ULfbDi4zC4=;
        b=M0TEA7ymofZTzCtECtYgAAySxmkyt3J9LVSN11GSh054ul8XCWe0Jbx7/4ge5gDDUx
         wwszmTi2eA+ayD0eADkmdI6mm8oloTYEgayphuJLjzEqMm/35T15L9xxf0FjaZBadL0M
         QLTzagrm6qVv4dw5CbnqehKVtX5h9RThIJsCb1kX6cu/GTKgya3rWEQBBtQnWx8Ec60C
         QLUIC7kLRTXvEZA8r+JWgjyUaNWO5aZzgdfyLIc9bkHjBEHWB/7KBshEEluSlko0A35i
         +h+eoCI1yLjpZOqHyrcMwqkCGAQX2/P6XKBpQCMZmdIYECa4ktklwQUNIItJtM+Pr4rX
         nerA==
X-Forwarded-Encrypted: i=1; AJvYcCVgDNN0/6nl74r4a1opqVyot0eiViTZkiy8CuZ+P7yeMzU+xmdLpp0uyFX6xIbt3batt1Zc6VIujw==@kvack.org
X-Gm-Message-State: AOJu0YyogfCsE0+GCOo2Y/gKEWAKyQ0QMFQ1VkACnH4fxQ2UOL9OfxFx
	TORvVsn/KqdHVYjfNYl/5ewunOcEUmfWQFb2mS1Xc6fxUHaGiiSaZXWTPA+ORN/J+OzFQMWg9E9
	3sBJ0a7Lpcqppzv9jy9Nk20thT7cpnmBM4ZJYfe/qIGGaNJ8eXZ62z8wrg2d/bMFP7zUe1dt9gF
	MD5N+f6XjTakMLkhftu8EUOJF0NsQ=
X-Gm-Gg: ASbGncsbR8OFvYnIuwoQGzFI2NCZsKYWgHgxV2ruQttDDL1Ih8vKi9fdo1T+rdv8yAq
	MBTB8mlWBc8L9F3WvXYcHqpZiR/0ckhLzvfjd502ujq/wEY/2ZsmYX8Y0cNdSfDxihE65d8QCzd
	7wM1CMu2m+Hy4tR1F15kLCP2HDwbUi/LSyq0hThKXlER9JpMdPDtkajlqv8f6V1XxtED10koW/N
	Fo=
X-Received: by 2002:a05:6122:219e:b0:55b:d85:5073 with SMTP id 71dfb90a1353d-55e69d33928mr1380193e0c.4.1764868750235;
        Thu, 04 Dec 2025 09:19:10 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEeIB0YNcpJAiGx/GNuObvXw/sfsBoL+Pu7iwpKlscfZjHDAR4upRzogd+N3zgiWodvzIxUpcfLPOjZg7ZeO+k=
X-Received: by 2002:a05:6122:219e:b0:55b:d85:5073 with SMTP id
 71dfb90a1353d-55e69d33928mr1380133e0c.4.1764868749828; Thu, 04 Dec 2025
 09:19:09 -0800 (PST)
MIME-Version: 1.0
References: <20251112-v5_user_cfi_series-v23-0-b55691eacf4f@rivosinc.com>
 <20251112-v5_user_cfi_series-v23-24-b55691eacf4f@rivosinc.com> <20251204175055-fefb76ff-2ff2-48b8-b92c-3d3ce33ec9f5@linutronix.de>
In-Reply-To: <20251204175055-fefb76ff-2ff2-48b8-b92c-3d3ce33ec9f5@linutronix.de>
From: Charles Mirabile <cmirabil@redhat.com>
Date: Thu, 4 Dec 2025 12:18:57 -0500
X-Gm-Features: AWmQ_bn9PjdtETVMsD9KORY8lffIPeFGUkSijG0lA3xh-eP2WvDjQUg18Xtxf3s
Message-ID: <CABe3_aH6wRzKt+f8RyG+0mN0Kyu2eASRn4URxgU4R-zEmdwBgA@mail.gmail.com>
Subject: Re: [PATCH v23 24/28] arch/riscv: dual vdso creation logic and select
 vdso based on hw
To: =?UTF-8?Q?Thomas_Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>
Cc: Deepak Gupta <debug@rivosinc.com>, Thomas Gleixner <tglx@linutronix.de>, 
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
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
	rust-for-linux@vger.kernel.org
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: pGX2QksgOPYbv9q_hwgnGggjW5XmNwaXP3ZWarfjl_U_1764868750
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 8DF738000C
X-Stat-Signature: xrba18wsmzz7x1eqw59sbg5stzztt8mr
X-Rspam-User: 
X-HE-Tag: 1764868757-672927
X-HE-Meta: U2FsdGVkX1+LuQCjtwJWjVLlM9/Tjr1GR0tcNV5Ov4wv7b0PiOeAqDpvKiCrNhcDy6D1tWo/izskmbrJ9i7SZQy/Zv427iVOAziAV9RrXcGqyotglQVc/71jFfBQsdyKF0njKk9iQ4zGAXncNpIgQ4nx1xUYjywFcKjePjEtxUt9m9a+pxz5+YuaZ9ylqu2xxE4OTF6JADBGlQr3vgCzt+I1N56HmvIir6fVUgNkdjuKZuJ4TBw7KGGoQ92eHaXQwq/7XY2Gg8mdgLSWs0GB+gbyV0n1nYWL9iS+4xv3pJ3dOGKBZTUDY9EcKrvu5K0Y8O+DlEpZ9k0lpmD7EjGMSQbgrKkKVTaIH6QMSWVJTSnABSi+gcmg+CqK6bEIZ9q+d2Zsq+aYRunWUk0mots3AICh2tXGNeGjyhzshOyvN1e27D0HevQ5GGyl6G1r5Ei4zmtLUCtBNjLoGpEh1P5kTyq8nEgl7pykw3Foun9p6oJtPv2lRKtdpo6fjrh8MNKgcVxKGHS+cUZZhDCQc093JHfdtiXZgx3DmU5xv8N+cOTHIelq0Mt+NZo30ol3Fs5PokEtUOUygeCAl0VzUzmIWxHu9+XFXAs4TaO6biUoyL4JTfAF0xFtcQDUAyUhLe/GM1uwzwXe6HKN5O3WivnkQRYIyYl2KSjwBhd46/c1d+8dR3wlnZRpj5f66d/M4A//Ah6jaAEdDei8j4rtaX5JRTZE15e/lNYGUZNQ2N/8mP+SiyUYABM1QmAdLqqPrZw8HuZP9aK2qPIfUzYMQqjkthKW2x9lz76TjNwjJBzoG6j/NY57REYltPVg5e/upauIhwE3O0mirdNaK9vn7/PofwwjHP3HKSTF4XQn2y+QpOw5SYOJNJaPOV/4y20WFbTRHP6TQTOHJsY3cr46d2aSkFTZXJ2zLrcTRTNnh6NNk8pl787PXAFkPrntkh8fr3athXo9AUN/Igi/02Mhmk1
 4/JmPZoC
 qMnngBexEHYuW9tSsWBP5BBLnjdSO/D1irUwyqgR2mqhWM3DSgYb3iCmU/ZzBVFn0DQh5TObsAfq7Kn9fplXq8xDNza16qNpfkMzu/JrHIdKlLyenTyqdNYe4EUToexZTVuLOvKNyd1zh4RfgYX98BVFBH5MlNKNgc3OXyHTIz8huZdORuqAN1A6jzsgDlIN0zcsmTjl9tXCjtT6ktwFlvwxCBduIU2JwEq0MYk56SzvazsYTvlPkKfKRSz6HpvnR+zWy+M0ef31lyGV3i7tjfAV3VHLmhX5lin2oJk8kaEUVscQH6rMbhoewxnh0hIi/9WPYcYeVIKHE/pT7yOVN+ckcct+PUFwZPfV5zc63C4eqCp9RgF6hp1AkCqNRiO6KXpyqmZbvm0/yCllGDHgsofx/XIQliLCq0EfKsqduwC8ss2a6H5PHhv9+YJVU5ookbjbgbfxUg3SjBtIEr3HONhzwGOtRQ30NKBmtsK/radrBXO09192u4m2z5nKoBL1FIsJl
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Dec 4, 2025 at 12:04=E2=80=AFPM Thomas Wei=C3=9Fschuh
<thomas.weissschuh@linutronix.de> wrote:
>
> On Wed, Nov 12, 2025 at 04:43:22PM -0800, Deepak Gupta via B4 Relay wrote=
:
> > From: Deepak Gupta <debug@rivosinc.com>
> >
> > Shadow stack instructions are taken from zimop (mandated on RVA23).
> > Any hardware prior to RVA23 profile will fault on shadow stack instruct=
ion.
> > Any userspace with shadow stack instruction in it will fault on such
> > hardware. Thus such userspace can't be brought onto such a hardware.
> >
> > It's not known how userspace will respond to such binary fragmentation.
> > However in order to keep kernel portable across such different hardware=
,
> > `arch/riscv/kernel/vdso_cfi` is created which has logic (Makefile) to
> > compile `arch/riscv/kernel/vdso` sources with cfi flags and then change=
s
> > in `arch/riscv/kernel/vdso.c` for selecting appropriate vdso depending
> > on whether underlying hardware(cpu) implements zimop extension. Offset
> > of vdso symbols will change due to having two different vdso binaries,
> > there is added logic to include new generated vdso offset header and
> > dynamically select offset (like for rt_sigreturn).
>
> If the used vDSO variant only depends on the hardware and nothing else,
> why not use alternative patching and avoid the complexity?
> I see that RISCV_ALTERNATIVE depends on !XIP_KERNEL but the vDSO code is
> moved to dynamically allocated memory in any case, so it is patchable.

These instructions are emitted by the toolchain in the C code, so a
traditional approach with alternatives is not exactly feasible. Maybe
you could do it by scan the binary for them, but that sounds dubious.

>
> > Signed-off-by: Deepak Gupta <debug@rivosinc.com>
> > Acked-by: Charles Mirabile <cmirabil@redhat.com>
>
> (...)
>



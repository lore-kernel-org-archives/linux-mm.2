Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 13E27CCF9E3
	for <linux-mm@archiver.kernel.org>; Tue, 11 Nov 2025 09:03:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 56B388E0017; Tue, 11 Nov 2025 04:03:17 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5431D8E0002; Tue, 11 Nov 2025 04:03:17 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 458E88E0017; Tue, 11 Nov 2025 04:03:17 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 2F86B8E0002
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 04:03:17 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id E81B288E22
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 09:03:16 +0000 (UTC)
X-FDA: 84097737192.18.D7100CE
Received: from mail-qv1-f48.google.com (mail-qv1-f48.google.com [209.85.219.48])
	by imf08.hostedemail.com (Postfix) with ESMTP id F083B16000C
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 09:03:14 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b="aTlg/SRd";
	spf=pass (imf08.hostedemail.com: domain of glider@google.com designates 209.85.219.48 as permitted sender) smtp.mailfrom=glider@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762851795;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pvNoy8QjEGF5vDREzb9JJ0U69eI//OHw5iW0XV0TScg=;
	b=fDsF2bHI/923OO10lZjRVRgUNn/kzZJUSlT++QjyWC0o5EjscwfhrWzmrzzPKYuh+M9FdT
	66w58lRITxlVOe5WpEY9EXvtd2xQjT0qJlCQ+VOw1dydmowLPNOEYCm8jSMfe81vaWS3vv
	yHUPqJrpyXX4JZsLXVSpjP1x2mmZ3KI=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b="aTlg/SRd";
	spf=pass (imf08.hostedemail.com: domain of glider@google.com designates 209.85.219.48 as permitted sender) smtp.mailfrom=glider@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762851795; a=rsa-sha256;
	cv=none;
	b=dOmaW0fwYWLpZ6l264fwBWgh5GvK2C7Ntpq5j29KDxDgJ02uc/4DEpckY0YyMmL8K6rODF
	0IxNoDYEXwdHvF0Qsg6LrQ1QTccwuv7I16fzz9LknHjM/NxfXGBxr6CKlzUF16Bfv0ec+6
	21rlj40Uec4WCkWwnhtL3DjR1ybggcU=
Received: by mail-qv1-f48.google.com with SMTP id 6a1803df08f44-8824ce98111so25193236d6.0
        for <linux-mm@kvack.org>; Tue, 11 Nov 2025 01:03:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1762851794; x=1763456594; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pvNoy8QjEGF5vDREzb9JJ0U69eI//OHw5iW0XV0TScg=;
        b=aTlg/SRd0XZL2WWfrdZ0B7WHVyNk3sHkr76CXSDyP7DIhPObP4R21bEc+9RkqxYDul
         6lkrLvEFxaDKhhxOHLXI9xt8gWCYzRKVXRvljIXT5dNcn6lxcdmbOwnLXFOKCxfIHvcM
         SCdQkWZOiCxcl20tWapdRZ3hPwOZQkbi7bp4AD8A9BN/J5WabTlrdYu9hHefYJzZ62uN
         HYUaph+CV/tJHfBSUu7rpSAyjjGsmpxFGqRX09Etm816vqRT2Qm49cgc3IW0H1QhJiT/
         GqVkFpNdSlvzcFGJBOzhoEhnj5PD+K00J+pjRRx5FUNlJ9JireD3LY2XrvU1SpNSp/Hm
         gyWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762851794; x=1763456594;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=pvNoy8QjEGF5vDREzb9JJ0U69eI//OHw5iW0XV0TScg=;
        b=c5TlxCs4bXqsrwCW81A9cWn+xfa2+y+y8hzF0avnir3827Q2K9WghRz4VVbTMwoFoC
         z9ROdFQP2LMRBgMOpbVbfcum5XZkLZmFeqHv1RRHUEjj9XQPIbuurfAftXfi5ZwEG7Sm
         3Ut5xxrONpIRnmW2XbuMxoG3BeSPIj29S4A25DErn6TCoHcuFzgkzmxRsIQy0c6qw69M
         K80P6AWEGJR0zA6lhy4FF/OJcE1yzF0ATyQGYTOrNqJlUF4109r8SS6tc41qT7j+m8qS
         WHuqoFI6ILk381ffDf4P/omqmNm8O9qZpFDQcJeutQbVyDFzZti+E13SNfxq9Y2cDkJ2
         YhDA==
X-Forwarded-Encrypted: i=1; AJvYcCUIsMiC0muJT+faH8RXfIvhcy5nyAlVVIfU92iV022tsP7oCiLIkIAzQOJa2ns48SbEUsDHc97FGg==@kvack.org
X-Gm-Message-State: AOJu0YyXnSajW5vaxo0L8yTqvzKW85OsBzpD9mK4UBveSPNUs3ZXz4YC
	Zjxda/imFwI9S5zPUP4UK4Z1tDG9I5Z7sLoyQ/lDIxajtUqv2ftCqwu8I81oT1UphsC9rmwHl4c
	oscegFMyAkmo2hyA3Gia+Up10yxk2pMWxkbpqf8Zk
X-Gm-Gg: ASbGncvIqv2fJ6BU77xtTKXVG/c12a/gk7aFALn+n/+AahildfONb3vhq/ktOH9heM7
	DTQlebueD2HitozRfu7pL7l71CGPI2xoEzgBRngVi5TrwywaKYlfU3RR5GA70Fna7yAqKhrOERZ
	DZtb1fWBRcpYaT3FkaGs1382cySmXeDgLhO/6Qe/8PqbPhazZg4uK0Ubikd7geY2jy8bZEyQeeD
	4BJdyHgBpVkIYOIzcbRkYgqldrlGx6FROqmA7NU2AVZT0g3sKULMsONIZuFgAQYOpjrsZKubuTF
	hZuREnzU9NHXj05FYnUwrWkxKA==
X-Google-Smtp-Source: AGHT+IH4F7Ckq32jrbiUxtB1JJ5uFrJqHGgUMRdrFl5ONAv3USRRzhM1TtECqM3yfM33Ue560sqRvq2+UhD4VMC4pSM=
X-Received: by 2002:a05:6214:e42:b0:880:51ab:a3e3 with SMTP id
 6a1803df08f44-882387621d9mr168741746d6.67.1762851793588; Tue, 11 Nov 2025
 01:03:13 -0800 (PST)
MIME-Version: 1.0
References: <cover.1761763681.git.m.wieczorretman@pm.me> <0a21096d806eafa679798b9844ec33bf8a5499a4.1761763681.git.m.wieczorretman@pm.me>
In-Reply-To: <0a21096d806eafa679798b9844ec33bf8a5499a4.1761763681.git.m.wieczorretman@pm.me>
From: Alexander Potapenko <glider@google.com>
Date: Tue, 11 Nov 2025 10:02:36 +0100
X-Gm-Features: AWmQ_bncs5LVtJN1ReProGRqJJIZk54xNH4kh3rOCX8uWFHvQkLT6YYoepdGREs
Message-ID: <CAG_fn=XQPbZb4MTBUgkJ17gfQL5K1QMahaJ39Mw7Hv4zm1crXw@mail.gmail.com>
Subject: Re: [PATCH v6 16/18] arm64: Unify software tag-based KASAN inline
 recovery path
To: Maciej Wieczor-Retman <m.wieczorretman@pm.me>
Cc: xin@zytor.com, peterz@infradead.org, kaleshsingh@google.com, 
	kbingham@kernel.org, akpm@linux-foundation.org, nathan@kernel.org, 
	ryabinin.a.a@gmail.com, dave.hansen@linux.intel.com, bp@alien8.de, 
	morbo@google.com, jeremy.linton@arm.com, smostafa@google.com, kees@kernel.org, 
	baohua@kernel.org, vbabka@suse.cz, justinstitt@google.com, 
	wangkefeng.wang@huawei.com, leitao@debian.org, jan.kiszka@siemens.com, 
	fujita.tomonori@gmail.com, hpa@zytor.com, urezki@gmail.com, ubizjak@gmail.com, 
	ada.coupriediaz@arm.com, nick.desaulniers+lkml@gmail.com, ojeda@kernel.org, 
	brgerst@gmail.com, elver@google.com, pankaj.gupta@amd.com, 
	mark.rutland@arm.com, trintaeoitogc@gmail.com, jpoimboe@kernel.org, 
	thuth@redhat.com, pasha.tatashin@soleen.com, dvyukov@google.com, 
	jhubbard@nvidia.com, catalin.marinas@arm.com, yeoreum.yun@arm.com, 
	mhocko@suse.com, lorenzo.stoakes@oracle.com, samuel.holland@sifive.com, 
	vincenzo.frascino@arm.com, bigeasy@linutronix.de, surenb@google.com, 
	ardb@kernel.org, Liam.Howlett@oracle.com, nicolas.schier@linux.dev, 
	ziy@nvidia.com, kas@kernel.org, tglx@linutronix.de, mingo@redhat.com, 
	broonie@kernel.org, corbet@lwn.net, andreyknvl@gmail.com, 
	maciej.wieczor-retman@intel.com, david@redhat.com, maz@kernel.org, 
	rppt@kernel.org, will@kernel.org, luto@kernel.org, kasan-dev@googlegroups.com, 
	linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	x86@kernel.org, linux-kbuild@vger.kernel.org, linux-mm@kvack.org, 
	llvm@lists.linux.dev, linux-doc@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: F083B16000C
X-Stat-Signature: horua9317ykektqaayn9ynx75cty9tfg
X-Rspam-User: 
X-HE-Tag: 1762851794-318210
X-HE-Meta: U2FsdGVkX1+i0x0l3KR7m3S1AdFujTrvGXSCqMqaAf1t8iXI7AvToLfzCvtx7Jjfo49Mz8X8/Fm+OhKEYRn5t/dndukAa0v9rtoIVKLXV91Dd5jWmHMnEMlGWiOnWfi86aoi8Tt1qPk/MTVirDcUC8RPKt3ckPEuPvMsYCsDZpsBN7OiD4R7fMkLsRkOiZbtXR4Ku/ut3rewYQlufDaQUoWg2sby7yCqpoRF+wSgsTb9ED0TLE0Miyke+Uy9miBUhd6p3KOfUEv0yvfLQjJw8NbYHkTCGdW7Obccm9MDSKrcMFzsGurekQ8CwAGY6hCKZFrzuHJFmnCGQViUKdoL6PltOk2YA0mx6e7OdSi1QpXjT57FaRV/eZsvRWzudTgnwt6QhIGBlwPxRAhU+twgyfHKRLHnhiwyjjMrI5pQt+VH5wArndFzXDxvGJ6GLS62uKFQ2iryzzBHfRYujUKFI1NaXuf/vs1JEGXxHa0Bx2iNEcNkPBfBJHghZLHSdxuH5yCL4kCH6LvWDW9zjRLcNqCO5EqMf0kfi7xnoNVrw8A8yLYR+xxRFTX1ydv4eRb7e1vwuRLdYsqJ4jhST5yvaCRYHcOWQQUmnu8892miAlcKsTrqFzeEasFy26UiKTHKDtGWmxvIStvI/z6Wl07z6+JbfEXPP3cfkp7mf0xrisuRlo5ITJp9Mj0ash+gDL4ZX15X7zJMlgyZ8Bqcz2/UIvUB8Oq3LoykfCPnyavMJmugw6zB7e/shdZHaCiU5WmZ4ui05Xi3gg4r9t1xUPGi6K/30WjB/9hVASqe3YyKIzkWYQxVI34Y6CGjTB76GcXUd7lnHQXfcI6DQWREkoU1opXtQdrbdn1xgXgF5ONi9pLlDgXF5T4eoWzexaaLlasAUFuQm05xjM8hdqVf1uJ7hQzV6n0nWcQVPB7bVCDloQdNZuLqh1sV4lCUWeC2vgGdS94KXhllomsB4JAS7XH
 LtItLEQL
 nXzP3Mk+FRnkog/jwDHnxN6P0o3m5D1+FdHWZXK9ccMtm0fzuezYcayQQByr4FFm4laC5udR0nAFrwTnxV7DpO3/iQmL84KWQdDwmst1DLEf6bwcuS/UPhKHgTA5QhicQO5e26NpXG1ED2FnbFJqYscM/xY7FIpla3pasD5a8yiOHG9yrjLs/yCOLuNGuomnpd0B/8iyddfFuQMCL3VGxlAIFX/1i9SeT5LVyDkHSrJMkttygLabbgYdyFuyBsXuEP64+5PkOui4A1YFZf6FG3qvrLnLbsCHF5K21Eg0wFjbxY2eHEVob0tWJ39NU7UomUC7x62cd5/m6tTsxrDMUFFuVA9OQIlEu06aYOWDvCTGwzzGNfPw4254wvvUak4/OTxmKW9aVN9NNSwNSNeNexmLORQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Oct 29, 2025 at 9:10=E2=80=AFPM Maciej Wieczor-Retman
<m.wieczorretman@pm.me> wrote:
>
> From: Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>
>
> To avoid having a copy of a long comment explaining the intricacies of
> the inline KASAN recovery system and issues for every architecture that
> uses the software tag-based mode, a unified kasan_die_unless_recover()
> function was added.
>
> Use kasan_die_unless_recover() in the kasan brk handler to cleanup the
> long comment, that's kept in the non-arch KASAN code.
>
> Signed-off-by: Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>
> Acked-by: Catalin Marinas <catalin.marinas@arm.com>
Acked-by: Alexander Potapenko <glider@google.com>


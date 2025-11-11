Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 92C5FCCF9E3
	for <linux-mm@archiver.kernel.org>; Tue, 11 Nov 2025 10:14:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D31FF8E000C; Tue, 11 Nov 2025 05:14:53 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CE2A18E0002; Tue, 11 Nov 2025 05:14:53 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BD1438E000C; Tue, 11 Nov 2025 05:14:53 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A70C38E0002
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 05:14:53 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 545DF4C0DB
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 10:14:53 +0000 (UTC)
X-FDA: 84097917666.03.6995084
Received: from mail-pj1-f48.google.com (mail-pj1-f48.google.com [209.85.216.48])
	by imf30.hostedemail.com (Postfix) with ESMTP id 5AF9880009
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 10:14:51 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=mXbTY5TG;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf30.hostedemail.com: domain of glider@google.com designates 209.85.216.48 as permitted sender) smtp.mailfrom=glider@google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762856091; a=rsa-sha256;
	cv=none;
	b=AnA20EhzoaR3boEuOnTXQOTHYJzBeLUv7fSOCppDyFETqz4vM7nx1PmDnEzjMcAwYyyKIZ
	Ehrzd3mbDIoRDJ6dPNSn8DJrI0OGzy/9grn02vtwIsT2gjw3t1zB40TgHaPp70XXr6TZ3p
	t9fvw12Vfs98Ok/YeN7Go9pqyp/yKxM=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=mXbTY5TG;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf30.hostedemail.com: domain of glider@google.com designates 209.85.216.48 as permitted sender) smtp.mailfrom=glider@google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762856091;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QCoNa0bAFU4qkhO5GhIkfapiatY4Py/cCoDedmB34wk=;
	b=EV349+784KjVaPdUBm8FXc532yxGhSLVPRL2nlH+5uoz96bS0YapC2nOfnKXDBQHod2D9N
	WUyfwUsCwIaKBXHbXbuabuK8eGBig5rNXlBeb6zWev+ltkcQIOSGYvtwJBmZlqTJ0Eudf7
	1OueQuz20kE2DOr/CgtOb4GcNzGpnkc=
Received: by mail-pj1-f48.google.com with SMTP id 98e67ed59e1d1-340a5c58bf1so2832845a91.2
        for <linux-mm@kvack.org>; Tue, 11 Nov 2025 02:14:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1762856090; x=1763460890; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=QCoNa0bAFU4qkhO5GhIkfapiatY4Py/cCoDedmB34wk=;
        b=mXbTY5TGU9giHjUfv9NGNYOIQRDuHkwMUov++RkFAtYxRLjFGr7wx8vtvAlxcTobsX
         tGuRcVkfjBSbiLfcpF3YZjdG3Db/6lRpm2cc0vzZ/6aR8pxOgtH5ykI/jKkJ1a8BY6ZL
         5p8q57BI+/xjhxcEVqZIht2fVTdc7vIP8XwJ5L5WdtgqlL/ShC71fH1bnSUNw5zBto2w
         v4Fh1tC2NfHDdQovs2qmYx4MKHwJDWS0TzM5kHcvSHc7hQn2yyajbEiZmnez6o/TzRAw
         HqxIYS285+zqChbKo8P4gNbg6rMQI1OuuHZa+O1RRx/UF3fYtFHPHabqzt17AbDU8WhI
         krdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762856090; x=1763460890;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QCoNa0bAFU4qkhO5GhIkfapiatY4Py/cCoDedmB34wk=;
        b=CPhV3Uv1jS8YUM+IEs/nwgoqeoAMKzL5PpR4VQiVIXse/rzSbigF9aYKOcNDUE29Tt
         k45aEeSfSmN6CJXNspaTZh2uGGHS2nTvuOrsXVNW4ent78v7PxNbEpmYc9kLGyP7lPEL
         i7YnnDxXqzhCoPvuXmRHAnHsuWwybKYy5vH1mox+JgW4GXJCLOn6HifJxsjKqIkn62Dz
         wZOfQplSaTmUTXGyplL0p5MQhg0SPPSwDia8Ur75dgkDW4P2gfQ6bGVXCl+cnGUzM4Ii
         d9x0FsyfNvITLRn1OuVlKt13xyRArxT9ms6LCv5X2MH8GHy4dABiYwNqST93SmR1iqKr
         FJ6Q==
X-Forwarded-Encrypted: i=1; AJvYcCU4IXtTtCKN7y8Nx6FOBHq5bpirF6uNK0d8AG0ygPqtgDH94QfUXXYB2drfsHqBCZkQgnxKbnymZQ==@kvack.org
X-Gm-Message-State: AOJu0YztdWu12lL7oJ70K75GSCWWntqEBnqUwhJ6kRVZZd3+V8o75Asu
	nYfV+vaCTcX+uzBf8rpCFL/ylqU9OZZRLZPen5uADmmWkWK7C4sRKdwfePQ68P4imToPMfbFsl7
	BdU7mVU7NeUVSRzIOBMWl3KLcgUk1vvu3SBdltomT
X-Gm-Gg: ASbGnctpTRQbA3JlUpaG4hitKK/kizG89kvgbRbszn36O5EqvhncJ/rlxz3/XMfwmTA
	3t5ejtp1FM0AOpyTDWF8InyyFg+VCtLD6cUQJcepX1U5XjFhx2H1OdE3kyUFWoYTr3w2WOikir1
	IcfgbsYAIDtN8Pnqtxr3zQ6iM7kenkxXXNn4WLIV0JVyofJnlIIgmOKrybdRwQMmHOJinmZX9Rs
	bFCq8MaFNUF6xySxOzSj/6qWIK/de7yDVCwEbL/6EzvITNfoanp68NxwbgRKnDNrQBAQNIG1f0w
	AqIsZyf/3jyoMkw3tnzeEbUZn/6zkHwmkjaW
X-Google-Smtp-Source: AGHT+IFQSxMJjSbUGKNKNlHPOvAOCrOFIwylDJVM9WLCE9houa0HQsWEPCsgreAvWbtMbfV9H0B8kgzaUxxNh9fow8M=
X-Received: by 2002:a17:90b:1f87:b0:340:bb64:c5e with SMTP id
 98e67ed59e1d1-3436cb89ac3mr14436274a91.14.1762856089911; Tue, 11 Nov 2025
 02:14:49 -0800 (PST)
MIME-Version: 1.0
References: <cover.1761763681.git.m.wieczorretman@pm.me> <8b0daaf83752528418bf2dd8d08906c37fa31f69.1761763681.git.m.wieczorretman@pm.me>
In-Reply-To: <8b0daaf83752528418bf2dd8d08906c37fa31f69.1761763681.git.m.wieczorretman@pm.me>
From: Alexander Potapenko <glider@google.com>
Date: Tue, 11 Nov 2025 11:14:12 +0100
X-Gm-Features: AWmQ_bk1ReQnmXZU019ENpKczYWPK1RduG0S2XHhWai-9JyZu-To_X33SgyNVa8
Message-ID: <CAG_fn=UzrdF4v_0iK5b+DHDhFG5pD-W4cac62YYK5x2hgPx9yA@mail.gmail.com>
Subject: Re: [PATCH v6 15/18] x86/kasan: Handle UD1 for inline KASAN reports
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
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 5AF9880009
X-Stat-Signature: n489fpf6grsf3aa1wd4t7tmd47adyqkx
X-HE-Tag: 1762856091-881648
X-HE-Meta: U2FsdGVkX1+fcjQKrP8bU/pQohnn+ahzpl4wbSDFjXZ1qXCyJWiwEpk2Fc30B99VRDW/u7GTDMC/nIEO6DBIF+/R9VvLw3gyCSP9j+frnHHh2F8k0sJtcCF7vL2zHVyrqW4ndKK9lcYahOsIRndH8vguy2V+O6+dGlqfHAaMZDC7r9UwF7tzPI31E3MqHjmdxQz2fChOLjcidErcQ0tsCDFI6hqD9t1SpOrBISPs0kzuyZcOI0Gqc3c7bTYgqBQ2J0JfRp7jl5IujOxURwteIv+hIToyo1K9LOY64YMO5jiCXI9Hh4aDoDUSE1pjWhqDuGR/bksEwDrgl4xLeT71NnWn4XJCu7rVIGyJ0BEjEJXQhlmjfwE8mwOCeU768yVX3BjsnHPg8UmsU3R41Qre2YA9fIt9nuf776tshRyi1Dv75RbbkHJgOX4SblL74YbqUEk/egJ10EGpiURXWP8ROEV2o62KjBBGBGOkL46H9r+oREm+RRBD9qTRdeC6pZ627/bm8UumArP7JNUBKY2dVWMim1m1/XrX3TkXx9z2hnmdXpbBd2prmz7XzauvuqtqlSQma/hB6lfl/y+MtjYDz1GhzIArliH/418/Bo/1v1lSvH0tkQ2GYFsj1hvhb8rfjFIZSoGTrI9ZUNHjGkwMuGI7qdS8WSOH65OT2yygFTAJKm454/hhu6UcxGoF4YBtTcP4eX7p+ED/Jpf52OSzn4ceujA6bKD7QRHIN0+mkZHDjm3pggNtIeOFMVCGnQsmIu/JAvhts+NAGZY9HK2obMUSBZq7yJEXGRiLVyPaq1TPquE3egJ/9OksV1uHO0+UpTjkZTACQCfkDaqFI0ZQfuRJjhGaS4QQ6XXhickoGrNVDTYt49b4xNT+oo3KbGEaEl57LfxrKqElBZXIsVxuigcU3lNb8cmjXADmWTVXxb2fEDfGJN5LV6csSns2OPqcIkp74bd0yEaGisz+jkS
 GHcnD1k3
 a/OzW9FXPL7eYu9tBCAUBg8TR1r7CZTfBVPjrvViZM+BURALT5SY9r5cYCSYg0XKy3Gu1WyadM8fDBv0cwPXTOTuRLzIJ4uC2oRoLscFduv6jaznt2Q8uZV2iZ1EUGPY5WKfQbrIQSROChcaPqiAKMwkWfRj+9rKbx7oRc0D9da+JkqQkbUha2zo/IphoP5iA8r9cg+GIOdKJtVl+KpIK9B++7bow2fq4IOnXFxLzFO8h+DEF9jNH0Usbe7ENoUe/D2yvyibwm5Z27Hw=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> +++ b/arch/x86/mm/kasan_inline.c

The name kasan_inline.c is confusing: a reader may imply that this
file is used for CONFIG_KASAN_INLINE, or that it contains inline
functions, while neither is true.
I suggest renaming it into something like kasan_sw_tags.c


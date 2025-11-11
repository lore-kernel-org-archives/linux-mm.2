Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6ED62CCF9E3
	for <linux-mm@archiver.kernel.org>; Tue, 11 Nov 2025 09:43:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A11AD8E0012; Tue, 11 Nov 2025 04:43:41 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9C2B98E0002; Tue, 11 Nov 2025 04:43:41 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 88A9A8E0012; Tue, 11 Nov 2025 04:43:41 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 72C3F8E0002
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 04:43:41 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 4096E12D2B0
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 09:43:41 +0000 (UTC)
X-FDA: 84097839042.05.5F047E8
Received: from mail-pj1-f54.google.com (mail-pj1-f54.google.com [209.85.216.54])
	by imf02.hostedemail.com (Postfix) with ESMTP id 8E04680008
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 09:43:39 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=yQEPs81r;
	spf=pass (imf02.hostedemail.com: domain of glider@google.com designates 209.85.216.54 as permitted sender) smtp.mailfrom=glider@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762854219;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pIXt5RY2avngREVQV/WVzy+4eYrZh/+QLtTn4Iny2dI=;
	b=nky0gX90718eIsBzn34sAjHsgLtii5XxRDBY/Pj7e27nteIYXbvpSYrSn+x/T5LHagV+yR
	oVpsKdfNoTPt27tMPezrQFHxElZhDo+SkJ2BZQEKMAyuIC1XWlOnT993svqTkR9Z3etzVu
	s9CLmnhg3g2H4nXSJkggLpGpSAI1VBo=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762854219; a=rsa-sha256;
	cv=none;
	b=iuUj7qFUckOj27w2c6qJIzRHRYqpW7Vwe0M8+7qSC41BjKkMLIJTDT+DmpcKOcGOaFEDZh
	Bb1Tjx+9l+Qdv4wS0oMs/M3EmjAAK5IGxBl0wOjKY/QD/J+sALPb0XETv7697668gEd7DE
	SCJWGPfR9RWHY4o1R7BWGM55RTzAMMY=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=yQEPs81r;
	spf=pass (imf02.hostedemail.com: domain of glider@google.com designates 209.85.216.54 as permitted sender) smtp.mailfrom=glider@google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-pj1-f54.google.com with SMTP id 98e67ed59e1d1-343806688c5so2317712a91.0
        for <linux-mm@kvack.org>; Tue, 11 Nov 2025 01:43:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1762854218; x=1763459018; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pIXt5RY2avngREVQV/WVzy+4eYrZh/+QLtTn4Iny2dI=;
        b=yQEPs81rv52k0mo0zh3rEYfUiWjXEeHaH4a+rHB5tNcC2lmIg4VUFVxZvVL/GvOagJ
         pOaBx8slsMbZRWK+v28KOV/shykZxOGwKChOKNOfpgaann9hLBo5GFvU98VwlaPZqejx
         BIs44V1qXVlwAZ8aYsRpY+8YwFxNbHA+/j5zStlMBKzFzJfZpxyDGl+aIVJYBmlNbyt6
         0nlsTiKmG8IDbBwJ+4G42EOSFjBta22Hgcdbz5XxdnC/O7EyDWgcWgih1E2I+rdPqEqS
         OOgJ7PLsxLaBjvtYv29q8Egrw/ypxdC3I+QvYyDmYWiOLSoG6mrAAeroCVlmpVXJbE0u
         UQRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762854218; x=1763459018;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=pIXt5RY2avngREVQV/WVzy+4eYrZh/+QLtTn4Iny2dI=;
        b=d5RF+WiOlffUCniSNEIruAiBaNUkTwaH0EC+Bl31QnmEZROd3gEmrdnTzYi6grQBDg
         /tfaWQKtAHdPVD3zw3YkUbY5EVQu7AG1VRqCb5c+oBUkzCYpYxiS9yaHkmbUWAtwBpma
         jh2UATFGabXnnB0G+IK/xV3AJtkWyGZafhEAWfwVgZr8y8cmW5JbDw/0gBtK1fjav/Yy
         lcrZSyRENJjJmgGmgoeSe1mYnpTarS87lkiHDDMwYKmW2bZIUSJim4SMhhtFIXyxQTxG
         mwTOq+m0fc92QrVPVpHgHHyM/1XxKvk3qyTOyBsIegG36hPSHDjW2frAAtu0kOKOPRjB
         AsDQ==
X-Forwarded-Encrypted: i=1; AJvYcCWgXu0QGha36xZcjMLusgWi3UC1zmrvnioAQ3mk8VoD2YmxTpAZBO9j44GrUw7zX635OnjOT2pZkQ==@kvack.org
X-Gm-Message-State: AOJu0YwBWKryItMW41U+bSFnvFYDaVBgmdbZaBIM5Uwi9/ZjkPnM6XwT
	VQ9KGjIBXLbMUW+hRsv+FBFo4iIKmffq0L7MZmYG48DTFSjNg9XVGv13/HimBtCwsrqIZK6Q38j
	434R3fS7xlO+poxi8YStloTUXAsllqVGhUIkYXYgk
X-Gm-Gg: ASbGncuquNTTnEQ8bB2xizhHS9cPfqaFrN7rTjt16ubMlsVPug+Ua3yAeHTgU0ILdmb
	sCqB052hAWwQR8i2hBg0pAZbiY5bJlr51+BksQAJ8WusSj3ARq2Q0KIsSUu4Veo3+tovLbBFYcE
	/kZDQFrYhaMpuX/w3ZnXaW62nUBX4mdnnjC4bS0r7s1AVWmiriYnAI7RkoQHkWuuH4Zvr7ooj0w
	mzUwtwKUxW2Vee8eqeTYt8xlZYy2Ou+a8Bqt9Dkr0kfT1JREyPCiCMO9/H8AWMbJuddEiY83qdP
	DYtZ+zhKqu/XTvWHIxVq6xY3me6eOAC64sgH
X-Google-Smtp-Source: AGHT+IEXo9sAHez4NR7EbhnospiZemL/LvJQCJ/Qa++0OXR1ORpXnOCB1WU1DKZb7CVWmG9+mXoqaQaxouu4ZLKngmU=
X-Received: by 2002:a17:90b:6c3:b0:340:5b6a:5bb0 with SMTP id
 98e67ed59e1d1-3436ccfd8dfmr13988152a91.26.1762854218118; Tue, 11 Nov 2025
 01:43:38 -0800 (PST)
MIME-Version: 1.0
References: <cover.1761763681.git.m.wieczorretman@pm.me> <d030a07c956c1e7cbf8cd44d6b42120baaa41723.1761763681.git.m.wieczorretman@pm.me>
In-Reply-To: <d030a07c956c1e7cbf8cd44d6b42120baaa41723.1761763681.git.m.wieczorretman@pm.me>
From: Alexander Potapenko <glider@google.com>
Date: Tue, 11 Nov 2025 10:42:59 +0100
X-Gm-Features: AWmQ_bkUJ_QlWZiGCG2FxZvthHc4c4y_090hZyMeaaw5jt0Qf6xk9VB1Qerb_Pc
Message-ID: <CAG_fn=VUzLi1C9jss1eHV=pPh4QFmWk-fQUbhNwrGNSUk-yKaw@mail.gmail.com>
Subject: Re: [PATCH v6 08/18] x86/mm: Reset tag for virtual to physical
 address conversions
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
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 8E04680008
X-Stat-Signature: jpmprdx3ktpnwdy3gt3x3z1bf1tq1wof
X-Rspam-User: 
X-HE-Tag: 1762854219-314506
X-HE-Meta: U2FsdGVkX1/A5XMpeWXYkdhOM01FBs2AknXdHjqBM3huLc0EhUiOtBicyG8Q1BGFx8MruYd+ymh8162X5VdNPHP81pu26cY9k2kBmRQhXfnoNebopOSW94Q2HdBcpHbAcj1qReB65kWWvHyEvKfLBdYSKqlJAEIf5XHtLM9shknTDdDscu7CVwB4pITDxWmIXLYxDtYiGWYKbVWd7QPR3LPTiG5xI4Fd2rmdLbOqilfVYDuYpy6AlwFbrpilpcLkS5nekikqkAIH6tlySH42aL+Y4FzDAj+I2slmUltyXaNrlggjgKoEbgddbmJ2etRgx7BvzCrUf+DeGhJO87R0spViyd5GXWAT76K4cI3+zw1HfmRLNS9zCwqXKG00IE46OKc2+9IW0f11VizE5D/Agy/D0Azi3m07Uqgl5B4oBeXmFk/A9b5hq3yFJBteLoyIT9c4w1zH6JFG3TOknNMZ4UdmKMZEQ4hOQl7sdUj7d05HEs6ZzZUKmNT7htSPyBrFvhq0vOQG4t1BCvJ3prMKLE5v/pMsa62CaPAgufyy8N8oIUJNwC1fXCtIKJnCzi54cvlF9323vTH/JX4P84oQIjBy/6OQF0silI6qw+d0/9f8ngUH9q6ab9taJNy6fjHKPI7ZbTq0JmBsd110ygoW4HfkxOvD0u97sDkwVGyRmbAuqVNuelz27JTUauFVprukL037/qNm6SLLwVc1Io4iBA4tF3ylrkA9V7at1NcwTljOJueayPjrpEUb//LIKCgKBrzqt1lE3ED33iadexyuzwvoB+2zNMq8f27lPBRZGrsCgkkeFBiBKaV2eYKB4qvWZI3vW9B/D+kc0/KZ87y4yVl/o3uzq/+jDsU3OKFy+STs16Z0W5STvT7f47Gvhd4ZLF4fFbEmIkxWqekP+roHSFcCGwmyQCTtibbbuXqx+UPTq7xl71bKinU+mBc9w0Ll19QiKAFgkNzMSUAntgm
 XSGWEYiv
 TrWxqxYqhtgsHtuk=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Oct 29, 2025 at 8:07=E2=80=AFPM Maciej Wieczor-Retman
<m.wieczorretman@pm.me> wrote:
>
> From: Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>
>
> Any place where pointer arithmetic is used to convert a virtual address
> into a physical one can raise errors if the virtual address is tagged.
>
> Reset the pointer's tag by sign extending the tag bits in macros that do
> pointer arithmetic in address conversions. There will be no change in
> compiled code with KASAN disabled since the compiler will optimize the
> __tag_reset() out.
>
> Signed-off-by: Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>
Acked-by: Alexander Potapenko <glider@google.com>


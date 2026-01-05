Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C84C1C79FA3
	for <linux-mm@archiver.kernel.org>; Mon,  5 Jan 2026 16:06:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 05D2D6B0173; Mon,  5 Jan 2026 11:06:10 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 006D26B017C; Mon,  5 Jan 2026 11:06:09 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E4C326B017E; Mon,  5 Jan 2026 11:06:09 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id D23876B0173
	for <linux-mm@kvack.org>; Mon,  5 Jan 2026 11:06:09 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 924C91399CC
	for <linux-mm@kvack.org>; Mon,  5 Jan 2026 16:06:09 +0000 (UTC)
X-FDA: 84298386858.28.D211E46
Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	by imf29.hostedemail.com (Postfix) with ESMTP id 9731312000E
	for <linux-mm@kvack.org>; Mon,  5 Jan 2026 16:06:07 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=ThekdUGV;
	spf=pass (imf29.hostedemail.com: domain of alexei.starovoitov@gmail.com designates 209.85.128.47 as permitted sender) smtp.mailfrom=alexei.starovoitov@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767629167;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Z+gjLDipIMUL9dempdjXyuPmU/vwivKlOWRjXPdfJGo=;
	b=iPxwZhcPsL/PYG6bvPQk7FeqZ+WfmbY/M9Q8jZcD/ptVd1Gh3nYhTKeyPPa2SVO/N9OIRq
	dJpEzb5H3ynISmHDh/D2ltMs+t9lCgSzQsxfovduKClKggVzDo4ywOkyk6q2FSzmN90g4b
	Ucsn0qZhSEChGcnhvAcUae44pAt2IXg=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=ThekdUGV;
	spf=pass (imf29.hostedemail.com: domain of alexei.starovoitov@gmail.com designates 209.85.128.47 as permitted sender) smtp.mailfrom=alexei.starovoitov@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767629167; a=rsa-sha256;
	cv=none;
	b=YkGFJGfojNnAfEa5TUs0QeXZwmD9Rl8rFhC55oSqQoBU6qDVYF+HceIHTxCPmcShZR5IWn
	cwTe/wZ2xQFWrDuABGlgZAcnttkKINcOwnmdJsIVBd0aK1Tt1i4b1aadHY3lSwoYfJnPvo
	7dihzamLo3n4iF0l86po5PJA1j4bCpA=
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-4779adb38d3so558005e9.2
        for <linux-mm@kvack.org>; Mon, 05 Jan 2026 08:06:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1767629166; x=1768233966; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Z+gjLDipIMUL9dempdjXyuPmU/vwivKlOWRjXPdfJGo=;
        b=ThekdUGVzksvuOkIKV0bepBvfKsqBFV+s//DyD4A1SAiNEiJBqm2fGi9KwDegq9AO3
         mPi7vBvQtflTaKSnhCYW0SFEMJE1qs3hTp6KYa+ugqxJa9NAr5EiFCLpc/Zje+jxjZEC
         urORtyiTbaW8ywx1ZH+tYgihwC/X9Yage5h74Dn9YGbM7RFwhC3zoOjRZLSK4FnIQ8Lq
         nC5ijARUY1Lpp2GItgVt6mN1C8ArZ0OdMeUkFKXVparaMUyR5ao0skoXB3WCHKbmbHXz
         lUDkpkYy59a7RClbpgRD5GYQ1WCIGRPgfp0KA4ALvFg3a7SVHFGMog0eB29nzvNXtp3J
         ByGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767629166; x=1768233966;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Z+gjLDipIMUL9dempdjXyuPmU/vwivKlOWRjXPdfJGo=;
        b=O4aeO3qBZcgG81giKVQPD9A9b5xtokflKfdqJy3IR6k7+YPu46DyAZ+yGAod0ey/7x
         21Xxg+3/GwnBLdvU4alO/yPkfaHhhXh7DcJUvWwt0RHIqL+BbLG7mo2/pItwvXKS4bui
         DtWH13MrGja/r68e/im83hxXs1tL3IoRTrsVoW+FuQX6xeBkIeuumC7xQTrKbX8bFUkm
         7SAg0XInJbh6YCYTFyF6RolNtO4Jzd2WuCrSbVzE6yAdfLbOC95OzWfPBMLWV4jcV0/4
         Q0DDQAYtJMTBBl3KmXTYerAE913QhjgiNad3vdelnmQex0dP2xgYwCSxBUZpLZ6OGXve
         mhtg==
X-Forwarded-Encrypted: i=1; AJvYcCWzptDiQrcd4R/o/inisaHFEMKr4O55AuQ6Go7y5EQn4ss+cumzrzVhl3RfXaEWZfvjB53EglKWaQ==@kvack.org
X-Gm-Message-State: AOJu0YyS4oo+OjNfKcmYlnIPUfuRb0FnXY0KObhSBYPNDSmRii87G9Uj
	OjWQN+I8XH0xJfR8+TIqWFVFhsyaTh9ckhSi72fMHi/9a79kEr8wjoklB6XEQHBYPt9u/t2WA2l
	9IEEJrAo53tNBCuOXo7y62rpJgOBno5Ruy+qG
X-Gm-Gg: AY/fxX4eUtKzDfPC2C7+N7SI5e6iQfGK1fb059Qf12/0MQg68kqvNrAusZlHVet3gpB
	PLXLzFgXhblTr52MhM5lrbZrCIZZd34yKGODe29zqt9Gw1u/hE6Ydj1/QF/h/2UYPYzKfkwqsdG
	5NLrr73jfFs6ddmdX0o+/NemoZyhMGq2MEDalWQhNt2sG9qOC+WgjPj6Hr/xvhmq7FQeIC9ZrZU
	4KEfdPni3N5faZ6nFVFsCzdOM7XXY7Imp9koWglcoDu6oNn0krQfcGXJ1NDidMrHnlNmxL3+gQs
	2GKEejLb4u9EE7FYEV+s2sBoU+CP
X-Google-Smtp-Source: AGHT+IH91ju9x26fwpmxKHCdxAk8uiY92yKq0jBd/lsXT5SeT8QJFOnafkbENxS6BD2bJ2pFHihHX423TaK749jOh98=
X-Received: by 2002:a5d:5888:0:b0:42b:2ac7:7942 with SMTP id
 ffacd0b85a97d-432bca168c4mr376036f8f.5.1767629165881; Mon, 05 Jan 2026
 08:06:05 -0800 (PST)
MIME-Version: 1.0
References: <20251223044156.208250-1-roman.gushchin@linux.dev>
 <20251223044156.208250-4-roman.gushchin@linux.dev> <aVQ1zvBE9csQYffT@google.com>
 <7ia4ms2zwuqb.fsf@castle.c.googlers.com> <aVTTxjwgNgWMF-9Q@google.com>
 <CAADnVQLNiMTG5=BCMHQZcPC-+=owFvRW+DDNdSKFdF8RPHGrqQ@mail.gmail.com> <aVts9hQyy-yAjlIK@google.com>
In-Reply-To: <aVts9hQyy-yAjlIK@google.com>
From: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date: Mon, 5 Jan 2026 08:05:54 -0800
X-Gm-Features: AQt7F2pFjbuNmXIapoQzPTyKKnnTbgegxc-4fgtPxfMOBgrMLb4YI8ApwcxajHA
Message-ID: <CAADnVQJr0WqmqA2fQeC0=Jn5F-ujWmUkL-GfT6Jbv8jiQwCAMw@mail.gmail.com>
Subject: Re: [PATCH bpf-next v4 3/6] mm: introduce bpf_get_root_mem_cgroup()
 BPF kfunc
To: Matt Bobrowski <mattbobrowski@google.com>, Kumar Kartikeya Dwivedi <memxor@gmail.com>, 
	Tejun Heo <tj@kernel.org>
Cc: Roman Gushchin <roman.gushchin@linux.dev>, bpf <bpf@vger.kernel.org>, 
	linux-mm <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>, 
	JP Kobryn <inwardvessel@gmail.com>, Alexei Starovoitov <ast@kernel.org>, 
	Daniel Borkmann <daniel@iogearbox.net>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Michal Hocko <mhocko@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 9731312000E
X-Stat-Signature: mjxf8emc1ppp1q5zbcok1apmmk4swgx7
X-HE-Tag: 1767629167-846849
X-HE-Meta: U2FsdGVkX1/nhQRoXReDLWRkH2kvURhn9vym56+JKPwylCuguirz2ibw4gsxxp7DU4tX8ENIVYw2D/55hkJuGXS660d7qZVRKwH09pzrNZgJ8yq0S7Wf3Y8t6mOAVFHAiCZThZ+blGM4/9KTjiXx+Bx7MNeY62/Cb2YadRzQlem5OtRlbGuRSfBVWQCtKrfzWeJrl79mUgN/0AdaKtG0rJ+RNb5ZOFoLU936FODpWUWa9f/U7w1hlpTfQ3HmKIA0GWM2gi5qnve3rSHl4d3xKjJgNt0Hnb+cMz3ZTn/L+hi6ZnVvoDvY/YvMHxCA471+rgouDauWHYYIf1njxJ/uzmzv0XHdA3O3b+T38q97wpF5B4zEpzkaNJutxHgcV50gzJGQP6v/IT7OIfIQo+75HjlqVT+1p+Hup31Askq4TGcf2v4F3+lLKqn9xQpkivtj8Izi1uSxO7c2vU+79H/9MKW/iDEJaC0Ow9Gadqu/CHgGBH5BfNgxOoukmac5OiwRGRj5zQH36Y6EZT22voD+kkjI12zw6/upqUMoCpsy56Ah50TGP1MMyf0fZclzglLqwNsf6z1XWuhxhlGSCJG46cp9HXhVWa3kAKPo3I2VQRGfBOYeBx2v0n8ho0EQh4lVKnHufnsqiqnm8MONaQcfR2FEULSYhVG+K5J0pC8HHo6FzNemz9EMvjIKD6jVwo0xr428KlPP1sANkRjhto0yqaGNvW/C31i8xOK1DpuoElAzyLh4WmY847Hp/j33W2yEag2/p9nMSbOjvs1aZwkYTLw3CL/kE6LLG69EQSI56JsIseqkH0FzWZqOdTf4x/8NZ9EAI7Y+ElQFMjee4WgQf5UkSTrW4QwyXvwuBeoCPnTBo3NGVpRAaqfOLT4e+/Kpz/CvCt6AtvbNlH4CPnw+RTJbNz19VNsaJAX5JR3JFIWqqDoLjf6U8mb8ytrYyz9WcPyBHySCoq1ac90n1JN
 YycRaaxl
 RvFQ6HlXKe2OqHQ7t0i4lVgmmmiL9QG5+e9p6IoWzxR57qtCohnvfQ3ReseW6Lqohv2jo7ZIt0y7xLwJmzWbrXZ4z1leOGpQjn6AdyjX68GurnjIKEBHLhiTQyPhc/OXSOC/1Eb+YyJhsKgO7MzjfDvjJHx1nJB+k+2Onpzm+j3lCIRZqBtMIQOhXxWjfwYWLIaW3gkaGWEj0lefRlgSNuQ552ORL2KXNRbl4MyO/3fNEy/fM+7eK4cFqcOWPwOYlVrMfn+/rHhZc3kE7i7b9Fbxd1qO67kWvkk1+Za5D2owvOoqR0ywdTteoWg0ovh8XX+tNtuqgFY4DLLp8h/nntztue6H6Acg/UB35WV8815Z9Ma3I+wEOr+pEQiaZr92bXzwc4e1d6yF6BvgBgE64eh0xOKwNajWRkMTHhNFNRmLb64Y2eTA6OUj7iI24PJaHLihK0GSrykrxxQg=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Jan 4, 2026 at 11:49=E2=80=AFPM Matt Bobrowski <mattbobrowski@googl=
e.com> wrote:
>
> >
> > No need for a new KF flag. Any struct returned by kfunc should be
> > trusted or trusted_or_null if KF_RET_NULL was specified.
> > I don't remember off the top of my head, but this behavior
> > is already implemented or we discussed making it this way.
>
> Hm, I do not see any evidence of this kind of semantic currently
> implemented, so perhaps it was only discussed at some point. Would you
> like me to put forward a patch that introduces this kind of implicit
> trust semantic for BPF kfuncs returning pointer to struct types?

Hmm. What about these:
BTF_ID_FLAGS(func, scx_bpf_cpu_rq)
BTF_ID_FLAGS(func, scx_bpf_locked_rq, KF_RET_NULL)
BTF_ID_FLAGS(func, scx_bpf_cpu_curr, KF_RET_NULL | KF_RCU_PROTECTED)

I thought they're returning a trusted pointer without acquiring it.
iirc the last one returns trusted in RCU CS,
but the first two return just a legacy ptr_to_btf_id ?
This is something to fix asap then.


Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1E793CCF9EA
	for <linux-mm@archiver.kernel.org>; Wed, 29 Oct 2025 01:33:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4A7418E0022; Tue, 28 Oct 2025 21:33:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 457A18E0015; Tue, 28 Oct 2025 21:33:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 31FE78E0022; Tue, 28 Oct 2025 21:33:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 1BE3B8E0015
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 21:33:07 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id DAA86140655
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 01:33:06 +0000 (UTC)
X-FDA: 84049428372.10.761B74E
Received: from mail-wr1-f41.google.com (mail-wr1-f41.google.com [209.85.221.41])
	by imf20.hostedemail.com (Postfix) with ESMTP id F0D091C0002
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 01:33:04 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Oi8G2uti;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf20.hostedemail.com: domain of alexei.starovoitov@gmail.com designates 209.85.221.41 as permitted sender) smtp.mailfrom=alexei.starovoitov@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761701585; a=rsa-sha256;
	cv=none;
	b=4H2+xNVe9ZvdXKnpJnzOFwvW4yIwxvWxXUXqg3SziRu3UCWiAT6QFxSUgNr17PTxigg4oy
	9pK7FxcoPi/eB9JaV6EWzJ0z7t53clMgUHe8Vc4CxcI9jeKuxAxe/RLaJkxV5UVngAYLpO
	ai+7ahKaffRWbjroNiTjODcQvMY9zVw=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Oi8G2uti;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf20.hostedemail.com: domain of alexei.starovoitov@gmail.com designates 209.85.221.41 as permitted sender) smtp.mailfrom=alexei.starovoitov@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761701585;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NZgb8HNWg7Vp1KBGuTQoK7+25dHkAhI3MFTK1ft779c=;
	b=WU/DwYvjOERLueCaJizLIg+5VxHbhUqbSQCmTqaI8p/X01m3jbPV7SRdgWWKyRZDPt/Sd9
	JY9RIBDd42OlVaKmTi5OYX3TPOenFyMFhO2h9qOTLsino8LfLjtxN6QAALNftWN+Xdjffx
	sJ48m8z5yBvDV1uwJBLhuRFcOdcayKQ=
Received: by mail-wr1-f41.google.com with SMTP id ffacd0b85a97d-3ece1102998so4766780f8f.2
        for <linux-mm@kvack.org>; Tue, 28 Oct 2025 18:33:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1761701583; x=1762306383; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=NZgb8HNWg7Vp1KBGuTQoK7+25dHkAhI3MFTK1ft779c=;
        b=Oi8G2utiVt5uIoqR2/3LBRP78bYtpBHEYauN11t7iM1VRfRlaRSGcxB/yZUTrIacaf
         og2WaDVMzjPqcqurYFQj1J3GEMshKb6d7iv6SmKfL1Ml0WNyZu2GrK1LFh4qYhi96jSV
         iwSZRflcQiPj/jX+6Un7nAWlXyV6T6ls2gG93yCw4bVYobXtM4QuOKvBaVoLUwzx48Ah
         OJXd0cnO14C7ocriJxb8KUmQmY8PLFUB7Os0GR0cpzEx45wXq362JvBJPrAD+FGVrkQ8
         jfYPp0sdHCo/o98Jpok3NsfU61YFDQzM2uOO2s6eAHDxGln1G4gK8BlIy/WM8wLVb/NC
         Ef1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761701583; x=1762306383;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=NZgb8HNWg7Vp1KBGuTQoK7+25dHkAhI3MFTK1ft779c=;
        b=dGs63fAtrhhhE4nyj6J8IQwf09HbGKo9I2wXqBD4fbMfgEjDLgRp9VJbOJ791rmDAX
         3fUPXD6VMIb3z/JJmzZRSbgIBhnwcahSPkt9GIhGC/eAz9mRr1OCN4AffpEWu1SVGPCp
         SmlEywnxsLWaekY+/MljiSZBoBa8c2aIrTc1q3CvPP1as6ATQC1TqRxPq3KPFOqno2gY
         QVNGmKrQ0i1V5Zj2jp26XevfDti15XpCf35R4uSXo00m139i5s6jooTs8ascE0MocDBF
         MOoleV7rUx4UabmavInrqfO0TV+yAFNmILQQLDfsgrAP3DgpH26rZc9GBaePFhE1UBCI
         ZgvQ==
X-Forwarded-Encrypted: i=1; AJvYcCW0gPgaNYQGSv8eF76IaPTJmbQhE9QNuVAH/DRYyu8vCJ3kCtEuRM58TC0dZEuutKJnkAArQ+sVtA==@kvack.org
X-Gm-Message-State: AOJu0Yy2NGg64XLgFOdl3HM75jSl4UhZw59gIJIUSDme4DKSJjaH1S5n
	IJIFcOPAEWf/l6s8D2eVbWP9vYmA+2PpU4PLqfKLLFrfBt7lFU4fpyyXoBjm4TPYTpXtnj3mXPQ
	3gTHPOX25r4stQ5OlZ4ZC/wFk3rWGbOY=
X-Gm-Gg: ASbGncuNj9Ixyt3Jr0QQWlBsTta+X0CGHxEISxrsWJAEZkIFcjBpdRPg389Zamw6+NI
	31jzqLP9ki9NUV5LKHOn1ODDxztIy0MMZtLObOmYOknIYf+IpuPKNgNP3Iq+vUf7hVCmx48xQ9x
	gPDaIbWQfK+DYXZOP3vUc8RDALGyBr3y1E9sZ2Zz32GZjl8R1j0yg/PINw4hrKW2lM3Z8jsxtT+
	s9Y0vw6DKH7x/m9I4vOMiMXv3CJg5a69/mYhBIWAuyzxI8Ihj8BcvrbbxACceR60x7jZVuld+DL
	4UCxo7LH5r+H847BVw==
X-Google-Smtp-Source: AGHT+IGTMzuv/ArJ+OYA4q54z3AmWM67z6gdganGyzk1cdUdXR07L641GaC7I+IwWt6JzcrPAq7tGRPMfDWEY1QXS5M=
X-Received: by 2002:a05:6000:26c2:b0:427:880:9538 with SMTP id
 ffacd0b85a97d-429aefbde03mr708524f8f.45.1761701583059; Tue, 28 Oct 2025
 18:33:03 -0700 (PDT)
MIME-Version: 1.0
References: <20251026100159.6103-1-laoar.shao@gmail.com> <20251026100159.6103-7-laoar.shao@gmail.com>
In-Reply-To: <20251026100159.6103-7-laoar.shao@gmail.com>
From: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date: Tue, 28 Oct 2025 18:32:51 -0700
X-Gm-Features: AWmQ_bntzSgbNvji5U8WdqIphFhfm5XUNy_QTFtw53IwUs3LIlTTv2I1GT8Ge5E
Message-ID: <CAADnVQKziFmRiVjDpjtYcmxU74VjPg4Pqn2Ax=O2SsfjLLy5Zw@mail.gmail.com>
Subject: Re: [PATCH v12 mm-new 06/10] mm: bpf-thp: add support for global mode
To: Yafang Shao <laoar.shao@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Alexei Starovoitov <ast@kernel.org>, 
	Daniel Borkmann <daniel@iogearbox.net>, Andrii Nakryiko <andrii@kernel.org>, 
	David Hildenbrand <david@redhat.com>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	Martin KaFai Lau <martin.lau@linux.dev>, Eduard <eddyz87@gmail.com>, Song Liu <song@kernel.org>, 
	Yonghong Song <yonghong.song@linux.dev>, John Fastabend <john.fastabend@gmail.com>, 
	KP Singh <kpsingh@kernel.org>, Stanislav Fomichev <sdf@fomichev.me>, Hao Luo <haoluo@google.com>, 
	Jiri Olsa <jolsa@kernel.org>, Zi Yan <ziy@nvidia.com>, 
	Liam Howlett <Liam.Howlett@oracle.com>, npache@redhat.com, ryan.roberts@arm.com, 
	dev.jain@arm.com, Johannes Weiner <hannes@cmpxchg.org>, usamaarif642@gmail.com, 
	gutierrez.asier@huawei-partners.com, Matthew Wilcox <willy@infradead.org>, 
	Amery Hung <ameryhung@gmail.com>, David Rientjes <rientjes@google.com>, 
	Jonathan Corbet <corbet@lwn.net>, Barry Song <21cnbao@gmail.com>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Tejun Heo <tj@kernel.org>, lance.yang@linux.dev, 
	Randy Dunlap <rdunlap@infradead.org>, Chris Mason <clm@meta.com>, bpf <bpf@vger.kernel.org>, 
	linux-mm <linux-mm@kvack.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: F0D091C0002
X-Stat-Signature: r9pfrcap7egr3wrz54csd8d7pb1wah66
X-HE-Tag: 1761701584-97669
X-HE-Meta: U2FsdGVkX1/Xv7evVGeSxIaTDT0f1b/f0W2F9KTYpS0+acoRsfrniDbmkdYkU4DfrWJZSYJb+WXVHbK0OK91CnVcUfltk4vfCw4MFKR0R7UtsbvU6c2caBmIvyglW3Ojm54gr0LbnOLRi+hExIud6A5AIB/jxVHSnC0HT40wppi2mPIPn/GraSs8TMKvUVb7TPfxk46IpC/Fak3g+eD7JkZpg+DrdYbXtMv2X4CCi10xwMk6OKhdpp9+wp8n2jQ8OCuf/om7Gxt8DB+F6Ifwu2A24J4hn62ogynjgPiXdDIu5u9kP9S1/VXbwU4WdehFIapX2/PTbq8BX4xSlZo+LjgvJ/e9QVZU6AaKZVj9HQkRiYnS5NPXXx55pJSbJbFK9I3ffZURXTKv8kpFQ75lrqQQM4scTDmYdrjKP3kJkzl7UJPAfzUSS80gzON90y3OxlcDUXtraM+Wf6gG0Lqui9BSsSKjSE12NDrIv0zbrwUT4Jt+Ew/gIAx46e7D3zSMs8t0tBOg4f+2ZxAgETXYeZz/q7hKy9/cVw4TUpOe96qJGrZ49ooVTcgeZlXkGMlhWH2CWyYMC8VRp1jVSciXSJ7xPHcLXGnwFScgmQMZq5apFr6Hz0K7E2w7Jkpe5oVjSAjVVIjjHs7sCAQXq7By79rXsdpMqYPoeEKgUWRWoDp+v8+gAZXLx0balLEkp58WDlt/wqvLRQ/QK/ptxNQrkoXVcDPRwPsa/8Mbrqftk/PjNKn9jQrCfgRLZDClTpgpMeY5ZMEalmsF2OgODp6uUBQRYcliPrApHvDU7MzIGTAgOiu3fDFfKGkWmcVC9qfGWP71c5kCLax+bRzY0mRvKCEQ4ukAWfi5uXlzz0OIonDv4jxqU2gG8x/q5XnSvdLgsxhxK7F9vgPm8rf9cponZkywky0FnosrKlsv+k9MGNPx+mGUdlepCdYul+OkueE9TOLVP9WhmJ2A1eOoTip
 8uTuWzTa
 iuHEbtU9McNMXe1Ffd4npjyBldsIY4czYptCWIL3dn5ELrSS1nf8td7QfH6oO/Z3QNoAWJiJwWtwjjj+Dm9UKZs65fzFui5IS0+xqEDxiUg7yeEOw/aRHwlqWba+2+iIi/viq3DD9yGzEYdMlPd4U5jkfqK1cWvYD5hsEbO/jkne02K8iHAHMpICO9ZTIUq09Ij8+3y7WrDDAHjclkzvoQB4mOGjfxyDYsfnP+PGcpFkx5jRDbHMHc/LPem6u9UjEQ/3oBkRI4t5dWN781nDOSdjgTWmnkKdw3wtL+J8QE1SlXNFS5E66KFnnKonLBe961YboXcm9iYZcWbwDIgnjoGsamDIJkBjHrMT8tMBR/tx38groQPazKgbMhycipmyAT7wicIEVdPll2MCE/+KPBAs7HvsR5XUOq/QD4eHxYcoP6EdM8KKqihlKS7qxnanWNJ3qXOt4/KwpQ9rPYoP6Y1zegw07ZfUB6bCbdmF7T8pmasK1ok9X9yfRoHYuhMBxJDsP
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Oct 26, 2025 at 3:03=E2=80=AFAM Yafang Shao <laoar.shao@gmail.com> =
wrote:
>
> The per-process BPF-THP mode is unsuitable for managing shared resources
> such as shmem THP and file-backed THP. This aligns with known cgroup
> limitations for similar scenarios [0].
>
> Introduce a global BPF-THP mode to address this gap. When registered:
> - All existing per-process instances are disabled
> - New per-process registrations are blocked
> - Existing per-process instances remain registered (no forced unregistrat=
ion)
>
> The global mode takes precedence over per-process instances. Updates are
> type-isolated: global instances can only be updated by new global
> instances, and per-process instances by new per-process instances.

...

>         spin_lock(&thp_ops_lock);
> -       /* Each process is exclusively managed by a single BPF-THP. */
> -       if (rcu_access_pointer(mm->bpf_mm.bpf_thp)) {
> +       /* Each process is exclusively managed by a single BPF-THP.
> +        * Global mode disables per-process instances.
> +        */
> +       if (rcu_access_pointer(mm->bpf_mm.bpf_thp) || rcu_access_pointer(=
bpf_thp_global)) {
>                 err =3D -EBUSY;
>                 goto out;
>         }

You didn't address the issue and instead doubled down
on this broken global approach.

This bait-and-switch patchset is frankly disingenuous.
'lets code up some per-mm hack, since people will hate it anyway,
and I'm not going to use it either, and add this global mode
as a fake "fallback"...'

The way the previous thread evolved and this followup hack
I don't see a genuine desire to find a solution.
Just relentless push for global mode.

Nacked-by: Alexei Starovoitov <ast@kernel.org>

Please carry it in all future patches.


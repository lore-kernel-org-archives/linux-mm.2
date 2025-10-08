Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8B373CCA470
	for <linux-mm@archiver.kernel.org>; Wed,  8 Oct 2025 03:25:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D1EB58E0013; Tue,  7 Oct 2025 23:25:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CCF8E8E0002; Tue,  7 Oct 2025 23:25:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BBE128E0013; Tue,  7 Oct 2025 23:25:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id AB2448E0002
	for <linux-mm@kvack.org>; Tue,  7 Oct 2025 23:25:43 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 59D1E859D2
	for <linux-mm@kvack.org>; Wed,  8 Oct 2025 03:25:43 +0000 (UTC)
X-FDA: 83973507366.17.AC2E572
Received: from mail-wr1-f54.google.com (mail-wr1-f54.google.com [209.85.221.54])
	by imf08.hostedemail.com (Postfix) with ESMTP id 6C3B116000C
	for <linux-mm@kvack.org>; Wed,  8 Oct 2025 03:25:41 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=kRQ3241y;
	spf=pass (imf08.hostedemail.com: domain of alexei.starovoitov@gmail.com designates 209.85.221.54 as permitted sender) smtp.mailfrom=alexei.starovoitov@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759893941;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Aq7/8dQHrmRmSKQ6xABjHJxjL0wL6AjJEcMgMgkiMrU=;
	b=8DCYTdAfASS9LSQbR+BA8HM90FpvcjFDM0P/7pyomx16aZVHjUxV7yfaOQJMeuBRJCeVwB
	Db3ypoLbahKSzoZAtC31//ba09jjC6hLvNMAK69a87el6cATnIYw8htJuEFx4qQMh/xjDu
	oGULmRA57zpORpZ4vugth54MkOj9lfw=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=kRQ3241y;
	spf=pass (imf08.hostedemail.com: domain of alexei.starovoitov@gmail.com designates 209.85.221.54 as permitted sender) smtp.mailfrom=alexei.starovoitov@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759893941; a=rsa-sha256;
	cv=none;
	b=m+NgJVWJug6WArTu1ag58BIw75bVZtP43qqeBu3HDnZjurloKSEr72b9249+h2DjAAS2UT
	xSucNyOqFs7pwuavSEKPV3HnY0uadHYuuRusXYwPTCQVmhc2bNJeC5WioiI38RkSLpzIGP
	fsygdbOwWKe4cm0yDXwIJf7tNe8LnA8=
Received: by mail-wr1-f54.google.com with SMTP id ffacd0b85a97d-3ee130237a8so4958683f8f.0
        for <linux-mm@kvack.org>; Tue, 07 Oct 2025 20:25:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1759893940; x=1760498740; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Aq7/8dQHrmRmSKQ6xABjHJxjL0wL6AjJEcMgMgkiMrU=;
        b=kRQ3241yrq8kY9dZL8PTCHI2TtIUmNwEvJdUZk0XADvc5IhLlO/OIHfCG/xIfuY2CX
         zIEQ2cQVXeMQbGUyOw6hf/JbMpEyTqYZdJjAjLy8FRGGKtJOf5ZzLQZ4q7KqcSS4ddTi
         8CS50kIzlj2NKZj/tIjrcLtBbgr4TNstYiJxUdmxcx9z9ynJk/ZyfTynbBhbFuDH00Qp
         YMVJ3ycjfC+RpvPbld84+UshF2fPPSD0+h6PuqvzYTGI38h6cg7IJcQFRxop+9tRqX4T
         y4+3xR/KHS5J8G4cTFCShezQ3UfiCC3WwH2AB9kkBFLuxwLc51FC06YnnOl6d+NgfUYF
         wRbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759893940; x=1760498740;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Aq7/8dQHrmRmSKQ6xABjHJxjL0wL6AjJEcMgMgkiMrU=;
        b=v25N1F5SknNKqidGtJWDgD8ilYya5a27Et/Je7oIBIDe52BSnpJaXsIyO9XD3CZ+T4
         RVtZM1bzK9IzR4fa8GEIjUKw4Ppb+8cv7rvga8nzIqLdpAtJIu+QbAOe7bFHs+cTcP+o
         37Pb0/wQI5yx44G19EXLEsX0OBlXF+CIYya9qYq31Y87motg+5J7AB6MMb7a/IVLeHQ1
         hppVdzSKou+u5T98u/1wpiKCPFHmPTMFOGe0BjWEvZCrIoQRURsZvFqqXwH6wwQ9xNX5
         ENgwumXD7xni0gg1BwzfZhiqQ6bCT9RK8C6GkQ4DC3c9ZwLSCTnMAI2XWDc4AqIQVr7x
         fuIQ==
X-Forwarded-Encrypted: i=1; AJvYcCXDpahdKLLqRAIWdd0a2H/yYc8MHhNrv9ydeyve1PabkDB+qpwB5fcNMCAcGpIj6XvucaP3YjAMMA==@kvack.org
X-Gm-Message-State: AOJu0Yw2tZIAStZKDXgR7m20rRCwMoEJWWbKwE55QqTGp/QxvDW5Txya
	h0Fottu3NX5RhsnCTljD7gWcZwMNHVsww2rWg+aj6orVUzsj+9nU9uBCyFSD/bX9Ppqkj0lqZwD
	9NnNKA8umV/+MQynE2btM1eBT1N7yyxY=
X-Gm-Gg: ASbGncuTQiyTBZvA4zRJVT2J7hdBesYLamb/WlE7rNqi9rok1m/upWmmS7Sqr/L513L
	cHWXnmiA682tgPomxqHQ9TY2kDt0FgCMZSDdJOcLK2FgKqQu4I3EmCmh7Oybi7mxfxuHhmxhzYL
	16iZhJP7sZnYi0GK0JHicukhl3dqqH5tDOs6RY8I9yJaCyKyAGh6hO/YomOthIvKMceaZ3HcQTr
	AKF0Ga6ud+0TwOae5yLaP2WdGwjxqkq8ZYCq2vgWVN3Hda7XTYlFvLVzosJVbaW
X-Google-Smtp-Source: AGHT+IHeswXWseQTzOZVDgPDpClSJjRdYqa3Gk+TNJHyXQ0PCdIukEVOo3TQExJxoJHeGY0CBioSlo3kBJaFQswByNk=
X-Received: by 2002:a5d:5d02:0:b0:425:7c1b:9344 with SMTP id
 ffacd0b85a97d-42666ab87c3mr807115f8f.15.1759893939583; Tue, 07 Oct 2025
 20:25:39 -0700 (PDT)
MIME-Version: 1.0
References: <20250930055826.9810-1-laoar.shao@gmail.com> <20250930055826.9810-4-laoar.shao@gmail.com>
 <CAADnVQJtrJZOCWZKH498GBA8M0mYVztApk54mOEejs8Wr3nSiw@mail.gmail.com> <CALOAHbATDURsi265PGQ7022vC9QsKUxxyiDUL9wLKGgVpaxJUw@mail.gmail.com>
In-Reply-To: <CALOAHbATDURsi265PGQ7022vC9QsKUxxyiDUL9wLKGgVpaxJUw@mail.gmail.com>
From: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date: Tue, 7 Oct 2025 20:25:28 -0700
X-Gm-Features: AS18NWATPwVk-W8hdC0xrQiJYrJaEbx7Di3QWbBv11leFl2ACmYaQhhy44lYgpI
Message-ID: <CAADnVQ+S590wKn0rdaDAHk=txQenXn6KyfhSZ3ks6vJA3nKrNg@mail.gmail.com>
Subject: Re: [PATCH v9 mm-new 03/11] mm: thp: add support for BPF based THP
 order selection
To: Yafang Shao <laoar.shao@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@redhat.com>, ziy@nvidia.com, 
	baolin.wang@linux.alibaba.com, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	Liam Howlett <Liam.Howlett@oracle.com>, npache@redhat.com, ryan.roberts@arm.com, 
	dev.jain@arm.com, Johannes Weiner <hannes@cmpxchg.org>, usamaarif642@gmail.com, 
	gutierrez.asier@huawei-partners.com, Matthew Wilcox <willy@infradead.org>, 
	Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, 
	Andrii Nakryiko <andrii@kernel.org>, Amery Hung <ameryhung@gmail.com>, 
	David Rientjes <rientjes@google.com>, Jonathan Corbet <corbet@lwn.net>, 21cnbao@gmail.com, 
	Shakeel Butt <shakeel.butt@linux.dev>, Tejun Heo <tj@kernel.org>, lance.yang@linux.dev, 
	Randy Dunlap <rdunlap@infradead.org>, bpf <bpf@vger.kernel.org>, 
	linux-mm <linux-mm@kvack.org>, "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>, 
	LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 6C3B116000C
X-Stat-Signature: zxwnjfiwryetom67h4hkb56tj76byk6a
X-Rspam-User: 
X-HE-Tag: 1759893941-657703
X-HE-Meta: U2FsdGVkX1/wOVl6VW3VNtK70QQkkEgAC2wCKt7v1z6HJEjiqNIMlVFTFwNE4tQ8r1yycK1NdW2ywwTNYwDoFz9XBIsnb87TpvDm3xeHncrlH1ZqWxWHImBrCV6N/7DhcTBb+iveiCW837kzNxz1FGDOzc9D2rj/Ht3BNhu1snPdBLKnaWzJY2RKc4AaVpeYQ7aEi+dBnyJW2zwDAX5h2xcwP9Ysa7VUNUTQeBGVCoKnp79/peoqkLC3nSyjYfEqw4AwVDiVj6oxcPbvCqKA8T1qNUXFwi+uFnKwh+kN8cCnc8rOA0Cm5/MujUCi0U/HaAFMOsbt+HnZNbViYHlmPTZYRjOQgSO5Z851U8Jgra+wsP/3fAiHo/Om4BAFqXyE63mVM60Z9jD35zQySl4k1QO47eZjMwGJvvf6DMKMuhEz31wbQOmB9RV2IZ2fOiLa9+u0HLDGd9WluYD4GCzrPvxgNSD3i/x8b/ikuoE/MmB04lW2kfHjv8/Nt6/Citj2hzX+9fRn+tTRT3xzB1bNUjntDNy7RGl4Lw9UwuSKVfq3TpidmOQKs6s78KI35H2XovxV0t8Nt6YbOtoNxwtrVU7bVF6wXAOaWE6kacSdPyk9n2vheDQ5R0TwIFG5Gibp80drrQ0N0y2uas8Nk3usT6T6GN+IcnRkAFjiSjifyzEfNBPjhiNxYAsveI5K3oCjTnOyH5kB2IDYZKLiQZX2U2qe6jzlR8WEZEHtZB1pRhvg9Fe59TZp6CeEaybT4cNUNjaliiuvPMmt0QRhgTkMrIvD8tizXEF4hcQmzLO6udKBzjZAelfA7cHScNe4Wo+h5jIBjYx4sAL39/pEDRG9YjKZ2+sJ4KdJjAiOBPE3mPD7uFbs+BabuyNFI7S45OMa2+FrcNXZTBlE7/JYTVgt24slIE7TL8lCEql8imdUj9UYt3fDPkDHNUDmBK++Q/JCXGbj5ogTxHiw7UvzuBl
 2pu3GG7s
 R8ta0LjegQf0SQGcUKQKTtRWClP9suqUUrJ6+uVstQIzeEBXeQ2aW8AgzYSveb10Qs2Ob6FNEfOvkAOJOYUfVJT/tdA6Kn5DHCvPpBJn8gZgyEOPE9jyiO6mmjJ9hJFZamBr4d6/G95hYi085gryOipW8ggk+tuoo3rHlPYUHMGXSkj2UpyUOeNk3cyOMiYRZZPXZAXBWhDkLPbj1k73gLSZsJSVvrh1yHPaVlte+L3IjiRwqvDc6rhILGJdPCZLrGPDpqSNRTdzEtT1v3T7I9zajK6otdEUYtT60iDbsrSTPHS436G74yfLeYVeVbCc3rPlsFqZVtTpkYmOinRs/N6wl7dLRY6VGwBmnvpJIKKDrrtmnmIS7CMcacbff1WGh6GXMD5RrA5oup7Bh/Oh+JqReN3FZmCONGGu1fo47T2JDt7mRH789jTdhGZJtGBMkId/Oc4/jcKbTEgC8qQNWtTs7ORGLMyaDGpB7
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Oct 7, 2025 at 1:47=E2=80=AFAM Yafang Shao <laoar.shao@gmail.com> w=
rote:
> has shown that multiple attachments often introduce conflicts. This is
> precisely why system administrators prefer to manage BPF programs with
> a single manager=E2=80=94to avoid undefined behaviors from competing prog=
rams.

I don't believe this a single bit. bpf-thp didn't have any
production exposure. Everything that you said above is wishful thinking.
In actual production every programmable component needs to be
scoped in some way. One can argue that scheduling is a global
property too, yet sched-ext only works on a specific scheduling class.
All bpf program types are scoped except tracing, since kprobe/fentry
are global by definition, and even than multiple tracing programs
can be attached to the same kprobe.

> execution. In other words, it is functionally a variant of fmod_ret.

hid-bpf initially went with fmod_ret approach, deleted the whole thing
and redesigned it with _scoped_ struct-ops.

> If we allow multiple attachments and they return different values, how
> do we resolve the conflict?
>
> If one program returns order-9 and another returns order-1, which
> value should be chosen? Neither 1, 9, nor a combination (1 & 9) is
> appropriate.

No. If you cannot figure out how to stack multiple programs
it means that the api you picked is broken.

> A single global program is a natural and logical extension of the
> existing global /sys/kernel/mm/transparent_hugepage/ interface. It is
> a good fit for BPF-THP and avoids unnecessary complexity.

The Nack to single global prog is not negotiable.


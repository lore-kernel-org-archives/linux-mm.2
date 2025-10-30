Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EEAD5CCF9F5
	for <linux-mm@archiver.kernel.org>; Thu, 30 Oct 2025 09:20:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 110288E0139; Thu, 30 Oct 2025 05:20:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 09A758E0112; Thu, 30 Oct 2025 05:20:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EA3588E0139; Thu, 30 Oct 2025 05:20:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D26CC8E0112
	for <linux-mm@kvack.org>; Thu, 30 Oct 2025 05:20:54 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 8E2BE1A0A78
	for <linux-mm@kvack.org>; Thu, 30 Oct 2025 09:20:54 +0000 (UTC)
X-FDA: 84054236028.19.9141211
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf10.hostedemail.com (Postfix) with ESMTP id 2402BC0010
	for <linux-mm@kvack.org>; Thu, 30 Oct 2025 09:20:51 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=NEjdbsL5;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf10.hostedemail.com: domain of npache@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=npache@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761816052;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WrnKVX90qOg0KXOFerofsL+qXt9ZrtN/DGELABhsPnQ=;
	b=nc05xKE89d2HBG7XocZSgqTL0YlFm2TQIGj9AOiw7I1xUgN6L7vgiUlDnXdFKPJtfJEUrk
	8IF2/EhSrWJM/MVbvJvHfc46eQ/OJCWQVXyUqqW6+yoJaRNP/v2JbVwxaczHa3HHfCx4LM
	TgYViXvbePvOKQ3erIpl+dzN5gMRzpE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761816052; a=rsa-sha256;
	cv=none;
	b=eERyuToI/ZhlUCxNZtdB/fiwUvQgOpszYVpepadzvVodKMot9hhLdI17EL/cGCMwssLXZo
	RpdzbbvGr7IITfUPqtX+QvTMoaoTrRQ6ae0f5rF+eY//+3Vlle2R2Ll7D/HEm68ljD4aIl
	vW/CnV40hQ0u4NP/96x24KIdmxMtAzY=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=NEjdbsL5;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf10.hostedemail.com: domain of npache@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=npache@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1761816051;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=WrnKVX90qOg0KXOFerofsL+qXt9ZrtN/DGELABhsPnQ=;
	b=NEjdbsL5GGgAFZwlV3u4hrGS7/nXxg9KNkK2roT6+ToplfuCfmpT1EJdafhnzCdjpMQLWO
	8WnDoKGrd4QxIXSxcDLc2OMTh7zYCU0P9KVCKnC4LveXtoODShrB5fDPOxOb1/NuEQcXuL
	YmuZxZ+cdMBRMDWi2PGffV3M24onfD4=
Received: from mail-yw1-f198.google.com (mail-yw1-f198.google.com
 [209.85.128.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-100-D-aNdP1iOASDmBMsCN5Tzw-1; Thu, 30 Oct 2025 05:20:48 -0400
X-MC-Unique: D-aNdP1iOASDmBMsCN5Tzw-1
X-Mimecast-MFC-AGG-ID: D-aNdP1iOASDmBMsCN5Tzw_1761816048
Received: by mail-yw1-f198.google.com with SMTP id 00721157ae682-738a7fc9901so12914037b3.0
        for <linux-mm@kvack.org>; Thu, 30 Oct 2025 02:20:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761816048; x=1762420848;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=WrnKVX90qOg0KXOFerofsL+qXt9ZrtN/DGELABhsPnQ=;
        b=Nvw0d/NkCwcFs7M8tS8O72XMokqvRMhQvOjVJZCfDH9I+xy6MtkPWjqSUHIkJZKKGA
         zm37XAgk0Vj+UDfG9ThQVGpkUJqekMQodPJ06sJ83kxtHcOFcyLHdb99J5YdgdkIMira
         kKCHGvuJAkJhpZsmA8IealOba8MowcMsvSzQY2ZcsxMT3ypM0zy22VvUIiTaBWFWgCpb
         DkDRsmhVAFF8WU6nc8DBM4Kx1WuIQujwOinG0ip8ZgZbhzj9jguz9NtmJpOzYW8+Cij/
         3yv0SLyX2QJtpCLDLVEqIFK3EYdgVW+jwTepO+0xR0/eZ/9jZOulKYwI1aIbYlvvm6e1
         kukQ==
X-Forwarded-Encrypted: i=1; AJvYcCWTpPB9xAv050fhmDSNYvR/Sh9knaZcSpqNmJJKb3zUDF+lHnGZA380loZfHVKlobaUxZ1UMDoiCg==@kvack.org
X-Gm-Message-State: AOJu0YzEekxMfiMUgFexu/Xrmj+nIqYds0TCt83W8SJODmeM8G3HzUz8
	ItcQkgc9Ki/DqJQNz0DhvWUMlQ+NLI/NJpwyycFY/TLxYTuOxPutEGTfLhjvBJTd9xEBU/nsu4h
	8Xym4y5/yzKJ0Q0+YOXqfZF1vBGxTX6n5aZckiTsfVZdRjkOZHfRjY+idgG3MOMWAwy3FSz77oK
	HQwXJftQ0bvA1SaWdjo5AkhTBOd/s=
X-Gm-Gg: ASbGnctC1MmtuGfaSQOZJpEP2fhNeJybtb45/dDIcfOdAMcrhQ/GW6FlzJOfQfCxaxn
	aBFXt1UY3BIPmUMj3GqP5+u3Qo26sddQ+Dawh6nrFAbj3a+CUecF5CMft64wEkSN93741i0DKU+
	bqTfmVf1e8Kw2/YYJKZz3tDc4DzILB698riSGJZmo6E8ncrKA4YeFzY+GNIF5xDGN/BnYeVg==
X-Received: by 2002:a05:690c:4c11:b0:784:8239:95bb with SMTP id 00721157ae682-78628fb8a75mr58291427b3.51.1761816048370;
        Thu, 30 Oct 2025 02:20:48 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFI5kI0F21WL+QZ1OA4Dk5ECCGXkdTRNA09ZYjLWlY5M89loSfEtpTmKAv4OFS+49Y22AUCQe8xd4jVF4QnaWI=
X-Received: by 2002:a05:690c:4c11:b0:784:8239:95bb with SMTP id
 00721157ae682-78628fb8a75mr58291307b3.51.1761816047984; Thu, 30 Oct 2025
 02:20:47 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1761757731.git.lorenzo.stoakes@oracle.com>
 <CAA1CXcCiS37Kw78pam3=htBX5FvtbFOWvYNA0nPWLyE93HPtwA@mail.gmail.com> <4e6d3f7b-551f-4cbf-8c00-2b9bb1f54d68@lucifer.local>
In-Reply-To: <4e6d3f7b-551f-4cbf-8c00-2b9bb1f54d68@lucifer.local>
From: Nico Pache <npache@redhat.com>
Date: Thu, 30 Oct 2025 03:20:21 -0600
X-Gm-Features: AWmQ_blJjXz4EnpEZUUXNRpsB4nZ3dPXcyhHU9r2Z2YEnS4O1uwurODA2NiBlJ8
Message-ID: <CAA1CXcBP1MYdBi55kdF83B5OD6uMoFmyKP95mWJx7gkwZDQxKg@mail.gmail.com>
Subject: Re: [PATCH 0/4] initial work on making VMA flags a bitmap
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Muchun Song <muchun.song@linux.dev>, 
	Oscar Salvador <osalvador@suse.de>, David Hildenbrand <david@redhat.com>, 
	"Liam R . Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@suse.cz>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
	Wei Xu <weixugc@google.com>, Peter Xu <peterx@redhat.com>, Ingo Molnar <mingo@redhat.com>, 
	Peter Zijlstra <peterz@infradead.org>, Juri Lelli <juri.lelli@redhat.com>, 
	Vincent Guittot <vincent.guittot@linaro.org>, Dietmar Eggemann <dietmar.eggemann@arm.com>, 
	Steven Rostedt <rostedt@goodmis.org>, Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>, 
	Valentin Schneider <vschneid@redhat.com>, Kees Cook <kees@kernel.org>, 
	Matthew Wilcox <willy@infradead.org>, Jason Gunthorpe <jgg@ziepe.ca>, John Hubbard <jhubbard@nvidia.com>, 
	Leon Romanovsky <leon@kernel.org>, Zi Yan <ziy@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Ryan Roberts <ryan.roberts@arm.com>, 
	Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, 
	Xu Xin <xu.xin16@zte.com.cn>, Chengming Zhou <chengming.zhou@linux.dev>, 
	Jann Horn <jannh@google.com>, Matthew Brost <matthew.brost@intel.com>, 
	Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>, 
	Byungchul Park <byungchul@sk.com>, Gregory Price <gourry@gourry.net>, 
	Ying Huang <ying.huang@linux.alibaba.com>, Alistair Popple <apopple@nvidia.com>, 
	Pedro Falcato <pfalcato@suse.de>, Shakeel Butt <shakeel.butt@linux.dev>, 
	David Rientjes <rientjes@google.com>, Rik van Riel <riel@surriel.com>, Harry Yoo <harry.yoo@oracle.com>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Kairui Song <kasong@tencent.com>, 
	Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>, Chris Li <chrisl@kernel.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, Qi Zheng <zhengqi.arch@bytedance.com>, 
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-mm@kvack.org, Alice Ryhl <aliceryhl@google.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: Rzy1GXjc33IlHhlnSvQxpTlc7Nnc2AzqvZ0piKmbXjw_1761816048
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam01
X-Stat-Signature: scx1e8bu3f7ynaxmerwr4iw9zh19ninw
X-Rspam-User: 
X-Rspamd-Queue-Id: 2402BC0010
X-HE-Tag: 1761816051-410014
X-HE-Meta: U2FsdGVkX1/Djuu5cvqpRhsh84mTE6eNOlNPy6HxuuDFUV5EulAiSuJIUGsXQPa/P2F8f7HuMLxopuLmBx6tY0umAXVLLkpVQ4VvwyLZXkzQKal0HMywCFb6zepWjElX86lM9nSr+CIwii4CcodDwnGT27d4kxXy9bQiYG6Q89GpW2f0XEUtc6z5+gDxWF/AnieiaQgN4cGYMyjv0oSD9ar23TV40auCopsMCEx/Kwg3qZTIZ/vLK0fCJ66f+9D7GYSpq52CXI8P5UDHf9RHf0yQukSdDmGkgfoVB6lFLf8A9q2bDnXJ1GzQTr+pV8F7TZuj4TrwCDL2Vf0CMr7PuvReIwlXyb+XykIsp9lIAC9y9vmrziy8czzevBQMriMKvXFC7jUAbJuaFfjmtOS8XubeqKxqC61aGaEXpux0/A54XBm6GXykf5v67hTIVEKzxOXNjO6roQIVWI19ZRr7gHY+IM0WTFWQLoK0T4AXO6EfCYu2qiWBPLzQFa8Xuqzq6W2qGCV2pAmiZW1j5cPrhGUJUAjA0t3LZE5EcQBPwQv2xxElAWfNfIYxTvoFR3KT8zVLD/yzHZXF56HsQZAgcZ7NSUMk0f8RW+e7aRQshrpO47fm8SLSQbYoCIJGcaHuBnTwtXfKYjbTpe/m1s64mTNrgfuv3jzpysk+s58yHKt4vR0i3HpsP6ChhKgbyeVogIyP74KVXdBWIiL7JQnltEc0W4C6cFPhu2tpPpvMVJaQ6inpIIGfuBYdoJE0EXpNcdt6J5ul9e0ZgBxESifbzyAMT9ynZq7woGUUHZTG70iDTx6wtFyOjnA9KGloKRMusuTTahfopXmGs2KpnlKSsZoG0yNxIchDv+8ht1qPt1Ej7bvg+f4yiJciP+sLnbpyIVSnB/3jzyBja5PA/EIkQF9z9AVk3txh4ZUopPDOodfd/18JL8pojnT/wTlasvXbINf7u1eaoghMA9/BJd1
 D65sy6No
 0RkDPT2fwRrXNAv3N/bn+4SGsrCrvRsvyKHEZ7t8EyATTR56i6D5Z8cOQdjWWjat7pGy+oxJRTyaIzpiLYGilg59roe2BRi2ja3yq53Tot3H6OCEW9p9h4Vdfeb7Wl6UpDE7ngqkwnXhglmF7n3hL0OnA/DacMxCFItWst3NHir9YdNaFa84iFprNbWrmbaOXwZ719kZQ71pkjdocoPtBO5blNVcShZuR8RrJCinRbhgUqfVwUvY9W3cRlG6W8GeAtgCgFPpqkD4oIdRYf3BW3z70c/MM2iOJZ30GvaBbjbajZNHPK6dpZnMG6UzwRuGVyXf4s6XwD2FxjSwl7kEjfHegFnZTAMBYUEozVL2olFrxh4lc/F+RcpWnPVXcl/U9SlaoK2EURAbtnSz4bKENurQBUQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Oct 30, 2025 at 2:34=E2=80=AFAM Lorenzo Stoakes
<lorenzo.stoakes@oracle.com> wrote:
>
> +cc Alice - could you help look at this? It seems I have broken the rust
> bindings here :)

From a first glance it looks trivial to fix, there are a bunch of
bindings of the VM_* flags.

for example

kernel/mm/virt.rs:    pub const MIXEDMAP: vm_flags_t =3D
bindings::VM_MIXEDMAP as vm_flags_t;

I believe this just needs to be converted to
'bindings::VM_MIXEDMAP_BIT' if I understand your series correctly
(havent fully looked at the details).

>
> Thanks!
>
> On Wed, Oct 29, 2025 at 09:07:07PM -0600, Nico Pache wrote:
> > Hey Lorenzo,
> >
> > I put your patchset into the Fedora Koji system to run some CI on it fo=
r you.
> >
> > It failed to build due to what looks like some Rust bindings.
> >
> > Heres the build: https://koji.fedoraproject.org/koji/taskinfo?taskID=3D=
138547842
> >
> > And x86 build logs:
> > https://kojipkgs.fedoraproject.org//work/tasks/7966/138547966/build.log
> >
> > The error is pretty large but here's a snippet if you want an idea
> >
> > error[E0425]: cannot find value `VM_READ` in crate `bindings`
> >    --> rust/kernel/mm/virt.rs:399:44
> >     |
> > 399 |     pub const READ: vm_flags_t =3D bindings::VM_READ as vm_flags_=
t;
> >     |                                            ^^^^^^^ not found in `=
bindings`
> > error[E0425]: cannot find value `VM_WRITE` in crate `bindings`
> >    --> rust/kernel/mm/virt.rs:402:45
> >     |
> > 402 |     pub const WRITE: vm_flags_t =3D bindings::VM_WRITE as vm_flag=
s_t;
> >     |                                             ^^^^^^^^ not found
> > in `bindings`
> > error[E0425]: cannot find value `VM_EXEC` in crate `bindings`
> >      --> rust/kernel/mm/virt.rs:405:44
> >       |
> >   405 |     pub const EXEC: vm_flags_t =3D bindings::VM_EXEC as vm_flag=
s_t;
> >       |                                            ^^^^^^^ help: a
> > constant with a similar name exists: `ET_EXEC`
> >       |
> >      ::: /builddir/build/BUILD/kernel-6.18.0-build/kernel-6.18-rc3-16-g=
e53642b87a4f/linux-6.18.0-0.rc3.e53642b87a4f.31.bitvma.fc44.x86_64/rust/bin=
dings/bindings_generated.rs:13881:1
> >       |
> > 13881 | pub const ET_EXEC: u32 =3D 2;
> >       | ---------------------- similarly named constant `ET_EXEC` defin=
ed here
> > error[E0425]: cannot find value `VM_SHARED` in crate `bindings`
> >    --> rust/kernel/mm/virt.rs:408:46
> >     |
> > 408 |     pub const SHARED: vm_flags_t =3D bindings::VM_SHARED as vm_fl=
ags_t;
> >     |                                              ^^^^^^^^^ not found
> > in `bindings`
> >
> > In the next version Ill do the same and continue with the CI testing fo=
r you!
>
> Thanks much appreciated :)
>
> It seems I broke the rust bindings (clearly), have pinged Alice to have a
> look!
>
> May try and repro my side to see if there's something trivial that I coul=
d
> take a look at.
>
> I ran this through mm self tests, allmodconfig + a bunch of other checks
> but ofc enabling rust was not one, I should probably update my scripts [0=
]
> to do that too :)

Ah cool, thanks for sharing your scripts, Ill take a look into those!

Cheers,
-- Nico
>
> Cheers, Lorenzo
>
> [0]:https://github.com/lorenzo-stoakes/review-scripts
>



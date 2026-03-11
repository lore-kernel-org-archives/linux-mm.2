Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4D09D1125850
	for <linux-mm@archiver.kernel.org>; Wed, 11 Mar 2026 16:01:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 42AA16B0005; Wed, 11 Mar 2026 12:01:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3F9036B0089; Wed, 11 Mar 2026 12:01:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 305366B008A; Wed, 11 Mar 2026 12:01:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 0B6DF6B0005
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 12:01:43 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 7BD32B76BE
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 16:01:42 +0000 (UTC)
X-FDA: 84534247644.02.3BE221B
Received: from mail-ej1-f73.google.com (mail-ej1-f73.google.com [209.85.218.73])
	by imf30.hostedemail.com (Postfix) with ESMTP id 83FC080018
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 16:01:40 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=SCaX1Vt1;
	spf=pass (imf30.hostedemail.com: domain of 34pGxaQkKCCE7IF9BOVEIDLLDIB.9LJIFKRU-JJHS79H.LOD@flex--aliceryhl.bounces.google.com designates 209.85.218.73 as permitted sender) smtp.mailfrom=34pGxaQkKCCE7IF9BOVEIDLLDIB.9LJIFKRU-JJHS79H.LOD@flex--aliceryhl.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773244900;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FZ9wJHN98p2eqW+aluFwwdS4VIjV0bOaQ4w+79zBhNs=;
	b=4Hxf3n3ckHVt0Y/065LYRUjoKkI6GpgYMfCfe3Oaz2IA+CXCnmBkX6yIYysUwDrFd31DkU
	Hb5zloUKjVNPyahbdjpOrBUCG6GCTaMwNnKk6wJDpxUcEzZmEbFyeD/h7XRuJCo9q1UF9f
	dfLOl0lL6go38ib0wNl3gvWpFbeF82M=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773244900; a=rsa-sha256;
	cv=none;
	b=GYJxA0dF+gCRYfdV0VoDTCivGUUYe10CgV9sxnxjk+fkZNq+HnZdjUjSIhUaWEa5ceZbLH
	VN7jrr9KMdfG4trGM1lAU46BkItebgq9vhpcMjMBO2Gn3TMx/x3ikGQRxAxJxcnOY1CcyS
	gnpchUVXF+QUpJpaA56097DjHYTI8Jo=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=SCaX1Vt1;
	spf=pass (imf30.hostedemail.com: domain of 34pGxaQkKCCE7IF9BOVEIDLLDIB.9LJIFKRU-JJHS79H.LOD@flex--aliceryhl.bounces.google.com designates 209.85.218.73 as permitted sender) smtp.mailfrom=34pGxaQkKCCE7IF9BOVEIDLLDIB.9LJIFKRU-JJHS79H.LOD@flex--aliceryhl.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-ej1-f73.google.com with SMTP id a640c23a62f3a-b844098869cso1293344466b.2
        for <linux-mm@kvack.org>; Wed, 11 Mar 2026 09:01:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1773244899; x=1773849699; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=FZ9wJHN98p2eqW+aluFwwdS4VIjV0bOaQ4w+79zBhNs=;
        b=SCaX1Vt18pId1s92jHln6B+zvKehf2OS7QTki00+ZE5W27jpHbko5vT8sh0r07iU1G
         RRam1QIo+C1rfU8lHW44t7BiGgTbOu2y3LWscTngoMyV5CR+aKQDbTycRjZLKnBJejNX
         ZB1g+lKdeaNTyMsQQ51qCJwTL2CfJTn2X2uYgZblLx4cQgRQTaePQzKf7YbODm+2Ge87
         WArTDEiJxYZH1sUS73mKvhOJn0UhDf6BfJPlsFKlDez1LRmszh0jwIWrye8NGvpQsTw4
         4lFzCi6m8A+cP3fNpH74VJQgLdgjqz39YQ0mvRsknvIrtvxNM5cpyxkpji9XG4oReHLQ
         8Fiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773244899; x=1773849699;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=FZ9wJHN98p2eqW+aluFwwdS4VIjV0bOaQ4w+79zBhNs=;
        b=eEvHtt5+6VF/sYKJjTGplF6sKxjiBspEmOBrQS7l6A6o1rmIri0fzh7WtjIuAKClFh
         /OYj0/nI9DbOlPCpryYyQ1iq0YVZ1EiFwhoTyxoG74TriB4hi3qjpQ2t4QEVQ52Ebxji
         bHhZkBCAVr8CuAFPAiqorqrR0VJl9mVy4LQv+2JsMXK6o5cdEPtcLtdYCb2SNcA617Ik
         6fXy+ZjQ30nIiAXvpt625Ia1jFfRUsPR3Eko5j4u9xDWeBw2PW5yi1r/uwxhPYiFDbZJ
         c7WMgvZ8i3+eoM0Y7ATyWgM4FFKxt5xJtFxePNlKeiH/Nc7aiqAOHrLOQTffb5BSSxot
         SOaQ==
X-Forwarded-Encrypted: i=1; AJvYcCXDMP/KCsADkleyJ4gmeDtGu+Tc3Ixmq/YAXHvGyl2LlO/83/iAb2caXYbX8FISxk2akfNk0xFTFA==@kvack.org
X-Gm-Message-State: AOJu0Yw7qe3fWMsfeOK45f5Zh5d2B21Q5MWDvVerCkDtRwxEvASKrlB1
	9XKeAbzjk99PCoX+UKM4A2gHjI6fVr0OnMkQ5hm+PouvvuLE/RiqpgLm1eus+YDS3isBTlVL9Jg
	rSazpa22DkSozMRmiMw==
X-Received: from wrbgw30.prod.google.com ([2002:a05:6000:40de:b0:439:ac29:98cb])
 (user=aliceryhl job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:907:6d22:b0:b93:3792:4b03 with SMTP id a640c23a62f3a-b972e4f775amr187595066b.32.1773244898034;
 Wed, 11 Mar 2026 09:01:38 -0700 (PDT)
Date: Wed, 11 Mar 2026 16:01:36 +0000
In-Reply-To: <20260311120418.GU1687929@ziepe.ca>
Mime-Version: 1.0
References: <20260227200848.114019-1-david@kernel.org> <20260227200848.114019-17-david@kernel.org>
 <20260309142954.GM1687929@ziepe.ca> <61df6369-333c-430a-bd18-c5b1acae68ea@kernel.org>
 <abE4JYo223OxWCBQ@google.com> <20260311120418.GU1687929@ziepe.ca>
Message-ID: <abGR4GWMXC2tJyr8@google.com>
Subject: Re: [PATCH v1 16/16] mm/memory: support VM_MIXEDMAP in zap_special_vma_range()
From: Alice Ryhl <aliceryhl@google.com>
To: Jason Gunthorpe <jgg@ziepe.ca>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>, linux-kernel@vger.kernel.org, 
	"linux-mm @ kvack . org" <linux-mm@kvack.org>, Andrew Morton <akpm@linux-foundation.org>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Jann Horn <jannh@google.com>, 
	Pedro Falcato <pfalcato@suse.de>, David Rientjes <rientjes@google.com>, 
	Shakeel Butt <shakeel.butt@linux.dev>, "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
	Madhavan Srinivasan <maddy@linux.ibm.com>, Michael Ellerman <mpe@ellerman.id.au>, 
	Christian Borntraeger <borntraeger@linux.ibm.com>, Janosch Frank <frankja@linux.ibm.com>, 
	Claudio Imbrenda <imbrenda@linux.ibm.com>, Alexander Gordeev <agordeev@linux.ibm.com>, 
	Gerald Schaefer <gerald.schaefer@linux.ibm.com>, Heiko Carstens <hca@linux.ibm.com>, 
	Vasily Gorbik <gor@linux.ibm.com>, Jarkko Sakkinen <jarkko@kernel.org>, Thomas Gleixner <tglx@kernel.org>, 
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
	"Arve =?utf-8?B?SGrDuG5uZXbDpWc=?=" <arve@android.com>, Todd Kjos <tkjos@android.com>, 
	Christian Brauner <brauner@kernel.org>, Carlos Llamas <cmllamas@google.com>, Ian Abbott <abbotti@mev.co.uk>, 
	H Hartley Sweeten <hsweeten@visionengravers.com>, Jani Nikula <jani.nikula@linux.intel.com>, 
	Joonas Lahtinen <joonas.lahtinen@linux.intel.com>, Rodrigo Vivi <rodrigo.vivi@intel.com>, 
	Tvrtko Ursulin <tursulin@ursulin.net>, David Airlie <airlied@gmail.com>, 
	Simona Vetter <simona@ffwll.ch>, Leon Romanovsky <leon@kernel.org>, 
	Dimitri Sivanich <dimitri.sivanich@hpe.com>, Arnd Bergmann <arnd@arndb.de>, 
	Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, 
	Andrii Nakryiko <andrii@kernel.org>, Peter Zijlstra <peterz@infradead.org>, 
	Arnaldo Carvalho de Melo <acme@kernel.org>, Namhyung Kim <namhyung@kernel.org>, Andy Lutomirski <luto@kernel.org>, 
	Vincenzo Frascino <vincenzo.frascino@arm.com>, Eric Dumazet <edumazet@google.com>, 
	Neal Cardwell <ncardwell@google.com>, "David S. Miller" <davem@davemloft.net>, 
	David Ahern <dsahern@kernel.org>, Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, 
	Miguel Ojeda <ojeda@kernel.org>, linuxppc-dev@lists.ozlabs.org, kvm@vger.kernel.org, 
	linux-s390@vger.kernel.org, linux-sgx@vger.kernel.org, 
	intel-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org, 
	linux-rdma@vger.kernel.org, bpf@vger.kernel.org, 
	linux-perf-users@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	netdev@vger.kernel.org, rust-for-linux@vger.kernel.org, x86@kernel.org
Content-Type: text/plain; charset="utf-8"
X-Rspam-User: 
X-Stat-Signature: rwsf8a5hm8bb7keex3r46jzcpr9um687
X-Rspamd-Queue-Id: 83FC080018
X-Rspamd-Server: rspam03
X-HE-Tag: 1773244900-5359
X-HE-Meta: U2FsdGVkX181AmlfYoWWEfsuCkiyBCIsBu75jqWXxhk08SolpGzLnZDfo4v3kJf/K9pQzPQOP604osAQrQgKBM/t50y9drBwhDGwhXLjD6IlnVvvraQviP8D35HKY8qUGWiEhkSi59b9ccw0uOs7hnJib2zqDYqLW+7v84Kf2UJZT44TPWzMdKvsvBjT9csjP1QjV3lVmq354WeVQAnYjd0ab5+MVelh34dqtacoAORp4z3rO9ltArZjf5qk4A4h0b9OaMKQ8oONdeFgRkYJihNG64MkCkDCiK9JeFdVXVAxK59V2dnZ9Pt0Hv9RSlXVcUoFBIIkO2eJ6xStyazcgcMbijZIjRAFAPj56Uumsj70ActOD+Pv18xCsfCfBgZWB7g5F/gpyvNfJ/IsceZgFx4fvEe4oNQxNWIduwbyUXJzDVOmsmuDrBkF7KVpPptj6J59sss59nC6rDhEINo3cN9tC+pJ2I+pvrDdh1Y25+G8NrRzhGnL6PtPFqH2gpuzEbb9hSE0v7YArilEZW7voi1M3zfHNhIPOnRDnjtfN1M1hN2+YP3T3TGtA1npIM2ML27vWqEC7DCrfV0igNHI/6YDqCSBMGaTJ+eg7J2l6QDCU70oO17SFRP5+QgtOaOILdYpDQ1hnRCgUkuVRipdxiOgPYpxN5d8OF4B6MD1vVTCJd7qjkXHmtKh03FrMklBH62gWscNog7PJe5ck4BN6JYETj8DDX/BY6dJVRiRF+3nHPqAr5Mn3SjtPJxNu4DHNYPmg/LwRwetG/IcDEbXrRzpSum3vEA2aLdwnAzynQDTU2DdxW7pfbUPTImlsMkbQn/lqTJOmTKQ2+dbJzRbvRM8xSwzO0bC7tXSGwVOOh+PQtWO5/MyA68j3ITPRytrs9jsFOsCaJnrHWk6wq8c9i9cUliOsQbllCMFjwu1I4zWXCdzc5ZD6E24dWsSnRw+qTkInYHtdLWoJZEECXU
 2DTzEH1a
 MT/lxNGtgOeItkSJ2CIeq7if02VCgGW78QH8GZVCttQeIRnOVCu8jZGs49UXl9nFRKp/nTSjVbs6VtvD2ymxw4HWceRxwDWINAgHpRpE2t1R/EZUPMEzMTS7A5t+IpXA/iKmG44dMAWTPZPUEOPoHYHHG9rHh++G7PbPhhHFBzflPllBJ0D2eQ7tiIc5fbhKc4WvCc8AUl6V/B7P1JKWcKZ5xGa6R9EdSHBcy4tsiyAzVrxKKY8lAyVhccLgyU1j4+QEkik6hZm0lz4J9mS75YHq9De44a3syBBc3B7JWRPN9NWos9kb3Z08z/X46FnPj99HhpY8GYvMGN83kE/8VJg1apHW698G/u818ewKVTcHVStcdt8NXq4N9QDV/P3dkBJa64ZKDoh5yu+CdUROAt0liy9dybzyeczwVXTWiO7Ad0w62T8FDCu+PXaq5Qh4P/Ew25GTAgsFC981/zfdcgihrGHDYyIBKXzNUh8MR2jo7biLY75WzwtVaTt/t2/kp0ZS3mdzLrg/fkCwwGz3at8hel06KrZEXmqVzsVcr69UmSPmR2TJvN0N7iZMDSQo9ru3xBRiqnU6TmU9YH1qaKi0V6M1WhXOMSazp10qk9uLtc+q70Z1XZxjKG8atyD4nAhVeaZpZVChL+ocV7szvYH5Ya2V20AlrlJJy
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Mar 11, 2026 at 09:04:18AM -0300, Jason Gunthorpe wrote:
> On Wed, Mar 11, 2026 at 09:38:45AM +0000, Alice Ryhl wrote:
> > It doesn't really make sense to have multiple binder VMAs. What happens
> > with Rust Binder is that process A is receiving transactions and has the
> > VMA mapped once.
> 
> IIRC the problem is the kernel doesn't guarentee singleton VMAs,
> userspace can always clone them with fork or something. Did binder
> solve this somehow?

The Binder VMA is DONTCOPY, so it will not be present after fork.

> Since you can't assume there is only one VMA the locking becomes a
> mess to cover all the cases where userspace can trigger a VMA clone.
> 
> address space deals with this internally.
> 
> Thus, zap_special_vma_range() is extremely hard to use.

I mean, the hard part about the locking is keeping them in sync. Binder
just doesn't do that. Only the original VMA gets pages inserted or
zapped. If you create a second VMA, you just get a useless read-only VMA
that you can't do anything with.

Alice


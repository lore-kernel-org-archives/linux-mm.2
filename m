Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 71B88D46627
	for <linux-mm@archiver.kernel.org>; Thu, 15 Jan 2026 21:42:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D16646B00CF; Thu, 15 Jan 2026 16:42:53 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C9A766B00D0; Thu, 15 Jan 2026 16:42:53 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B47D56B00D1; Thu, 15 Jan 2026 16:42:53 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 9FA466B00CF
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 16:42:53 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 7049858F94
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 21:42:53 +0000 (UTC)
X-FDA: 84335523426.24.E9CEE9B
Received: from mail-vs1-f41.google.com (mail-vs1-f41.google.com [209.85.217.41])
	by imf25.hostedemail.com (Postfix) with ESMTP id 8FBCEA0012
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 21:42:51 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=zljJL9Hk;
	spf=pass (imf25.hostedemail.com: domain of ackerleytng@google.com designates 209.85.217.41 as permitted sender) smtp.mailfrom=ackerleytng@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768513371;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CRW9L/9HA/1Bpy1MjTpDe5h57ZTPcwDUOwqt2sU0Wb8=;
	b=ZLf2Zqbv6TXcibhKBZMtamTqfkKJ8bFFRvZujoxu1oe4JGYhXvQLrS/K+zAYLDibrj1LUn
	piDujCMHxAT7UhclOdYaMDhneL6/a6ChWUBgf0jGzKi4VhjAlXHhjhgHUyIC6UAqgfRQZi
	dRibvv3oBed4lcwJU44tL5l4lYQ1wKg=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=zljJL9Hk;
	spf=pass (imf25.hostedemail.com: domain of ackerleytng@google.com designates 209.85.217.41 as permitted sender) smtp.mailfrom=ackerleytng@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768513371; a=rsa-sha256;
	cv=none;
	b=kYndSZg6Zru6BnieiznvbTx/fxL2jjpENDOdm5r7riOindk9onwdteRaOiP7Irr54Reh8g
	kv5qSoqaOzc6NNTOWDUT3MFFe5mGDbJoBTLtL7E5sNGGC3ute9U4Zp+11AyLyRBdhulHD5
	ZOguGv9HgVMhMYy7xxNs/lZPcj+0Xbs=
Received: by mail-vs1-f41.google.com with SMTP id ada2fe7eead31-5eea2b345fbso497667137.2
        for <linux-mm@kvack.org>; Thu, 15 Jan 2026 13:42:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1768513370; x=1769118170; darn=kvack.org;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=CRW9L/9HA/1Bpy1MjTpDe5h57ZTPcwDUOwqt2sU0Wb8=;
        b=zljJL9Hkl3/EHrHjoSA4SFpVoW6OWE+Xi/zFXY9zvqDv1++CYdmJVVXh2aRRWMDV+G
         Rq+OmApkeD5ZYt+BsmDUCNA4ly9O4WX1d493BsAZlW55Kk7jQ4GDklBwjMQHNJtQCYNQ
         rf094W1KlW0Hh3t+/uX7F1+vKWXOKRXCEY1TtOYL0A7kWOyUMRzNn5Jjzf9RV2yAhaqU
         5ufS8J0WRAkE9pa92hwyOYkooRiyk4ShCvsgzfk+OQSYEu5ECZcbjFO3kSKvAfCAnvo+
         C4ZAJHzTMRsTZDSuW+JZrsxXtBFAbMi4bKZ/kJv3VBcIPIkyaEMLm4/LXr1PLXzcN6OR
         7N2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768513370; x=1769118170;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=CRW9L/9HA/1Bpy1MjTpDe5h57ZTPcwDUOwqt2sU0Wb8=;
        b=teNBKCAlx/oyZ9rg0esLXWKVX8DZRUR4Wtq82wE/snEU+66uuIzFG7CFSw/vAv0Ht3
         6OJN+N6A/CqClbAJk+jKiaTivXZhBrGUWmGftO5gxeMYRQ1baDHxnfMWcd0LDp070UjJ
         BMWhuEG+EY5JaoFXvG7F+IaxK9qTQi2xllEM9VOp7pHK1USNhXtbLTopXjw1qXWGFpF/
         FKQ1rS/rHBmtFcWtHUfZe2mGcp+VCCT6RyropdBz5vi0WqLqipqT8Q4A2uTCzij3XOWf
         HOpixtoqXN1Wye9MTsE13z7c004HlMr49US4CCoXO2UDZZv9PFfM7Fvi083a1jfWYG8Z
         BYJQ==
X-Forwarded-Encrypted: i=1; AJvYcCXU0YNZ1ccRc6uMURPDToFrMB/SIS218V/cz/U7bE48SoObDZ3T5xJEchPMsfybk6P+8xdJBS6Jug==@kvack.org
X-Gm-Message-State: AOJu0Yy0Y+TdIjx0qzZbPnrdvCU6iXYEevx4k0c9Y+aphDDZxII8AteK
	/ZqhYWnVgpnnedixgZqR5L5amvV+nLuIdrWWLhfZGFy2FnfvG7rZgeROG7ccbDYU8pjQmxSVUcg
	7ozWFihZRoaPK3qulsiU0yjpGzwBC9qWgWIpkBzg+
X-Gm-Gg: AY/fxX6+PgWBeEbpGFq9kYYla/xqYp2xxswIDZSNvDbLfJdVJUONe553iRR3+SGnhZM
	OnZN2tY8H8BENKg/b9UYLpg2bquhZscII2U3zDyvVksisQD7/W2VSa0PBsfFxGiHll+wa7hTrco
	Q08/uKzzEgYX21zS1jwI/Je5lNaQ8o7oTksti6bZYMFKGFEs0CBpOP8tZSZbMUPEQdX4POWwA9L
	e1VWCRBO4aUYxQVN3TNYMV2W1A8zLmzjp6vPjHYQcc6MF8kb6aAr1cdYTcyDJMcCom6UHnKqEBp
	8Ar9hwR0MwkDcG0vV+Cc1LsMqGXci6i5F9V1
X-Received: by 2002:a05:6102:cc6:b0:5db:20ea:2329 with SMTP id
 ada2fe7eead31-5f1a55a32demr371875137.35.1768513369890; Thu, 15 Jan 2026
 13:42:49 -0800 (PST)
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Thu, 15 Jan 2026 13:42:48 -0800
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Thu, 15 Jan 2026 13:42:48 -0800
From: Ackerley Tng <ackerleytng@google.com>
In-Reply-To: <20260114134510.1835-4-kalyazin@amazon.com>
References: <20260114134510.1835-1-kalyazin@amazon.com> <20260114134510.1835-4-kalyazin@amazon.com>
MIME-Version: 1.0
Date: Thu, 15 Jan 2026 13:42:48 -0800
X-Gm-Features: AZwV_Qjy0HC7gblz7T2Mj2ciHvpfRgcw_pe8yM4xzbPDNZpWuI6Qc22FzNRUu1Q
Message-ID: <CAEvNRgF-61VROyB0zG4Gyky_+Pks0wJBX0Uv_ysLGZCw3H8LNQ@mail.gmail.com>
Subject: Re: [PATCH v9 03/13] mm: introduce AS_NO_DIRECT_MAP
To: "Kalyazin, Nikita" <kalyazin@amazon.co.uk>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, 
	"linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, 
	"linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, 
	"kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>, 
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>, 
	"bpf@vger.kernel.org" <bpf@vger.kernel.org>, 
	"linux-kselftest@vger.kernel.org" <linux-kselftest@vger.kernel.org>, "kernel@xen0n.name" <kernel@xen0n.name>, 
	"linux-riscv@lists.infradead.org" <linux-riscv@lists.infradead.org>, 
	"linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>, 
	"loongarch@lists.linux.dev" <loongarch@lists.linux.dev>
Cc: "pbonzini@redhat.com" <pbonzini@redhat.com>, "corbet@lwn.net" <corbet@lwn.net>, 
	"maz@kernel.org" <maz@kernel.org>, "oupton@kernel.org" <oupton@kernel.org>, 
	"joey.gouly@arm.com" <joey.gouly@arm.com>, "suzuki.poulose@arm.com" <suzuki.poulose@arm.com>, 
	"yuzenghui@huawei.com" <yuzenghui@huawei.com>, "catalin.marinas@arm.com" <catalin.marinas@arm.com>, 
	"will@kernel.org" <will@kernel.org>, "seanjc@google.com" <seanjc@google.com>, 
	"tglx@linutronix.de" <tglx@linutronix.de>, "mingo@redhat.com" <mingo@redhat.com>, "bp@alien8.de" <bp@alien8.de>, 
	"dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>, "x86@kernel.org" <x86@kernel.org>, 
	"hpa@zytor.com" <hpa@zytor.com>, "luto@kernel.org" <luto@kernel.org>, 
	"peterz@infradead.org" <peterz@infradead.org>, "willy@infradead.org" <willy@infradead.org>, 
	"akpm@linux-foundation.org" <akpm@linux-foundation.org>, "david@kernel.org" <david@kernel.org>, 
	"lorenzo.stoakes@oracle.com" <lorenzo.stoakes@oracle.com>, 
	"Liam.Howlett@oracle.com" <Liam.Howlett@oracle.com>, "vbabka@suse.cz" <vbabka@suse.cz>, 
	"rppt@kernel.org" <rppt@kernel.org>, "surenb@google.com" <surenb@google.com>, "mhocko@suse.com" <mhocko@suse.com>, 
	"ast@kernel.org" <ast@kernel.org>, "daniel@iogearbox.net" <daniel@iogearbox.net>, 
	"andrii@kernel.org" <andrii@kernel.org>, "martin.lau@linux.dev" <martin.lau@linux.dev>, 
	"eddyz87@gmail.com" <eddyz87@gmail.com>, "song@kernel.org" <song@kernel.org>, 
	"yonghong.song@linux.dev" <yonghong.song@linux.dev>, 
	"john.fastabend@gmail.com" <john.fastabend@gmail.com>, "kpsingh@kernel.org" <kpsingh@kernel.org>, 
	"sdf@fomichev.me" <sdf@fomichev.me>, "haoluo@google.com" <haoluo@google.com>, 
	"jolsa@kernel.org" <jolsa@kernel.org>, "jgg@ziepe.ca" <jgg@ziepe.ca>, 
	"jhubbard@nvidia.com" <jhubbard@nvidia.com>, "peterx@redhat.com" <peterx@redhat.com>, 
	"jannh@google.com" <jannh@google.com>, "pfalcato@suse.de" <pfalcato@suse.de>, 
	"shuah@kernel.org" <shuah@kernel.org>, "riel@surriel.com" <riel@surriel.com>, 
	"ryan.roberts@arm.com" <ryan.roberts@arm.com>, "jgross@suse.com" <jgross@suse.com>, 
	"yu-cheng.yu@intel.com" <yu-cheng.yu@intel.com>, "kas@kernel.org" <kas@kernel.org>, 
	"coxu@redhat.com" <coxu@redhat.com>, "kevin.brodsky@arm.com" <kevin.brodsky@arm.com>, 
	"maobibo@loongson.cn" <maobibo@loongson.cn>, "prsampat@amd.com" <prsampat@amd.com>, 
	"mlevitsk@redhat.com" <mlevitsk@redhat.com>, "jmattson@google.com" <jmattson@google.com>, 
	"jthoughton@google.com" <jthoughton@google.com>, "agordeev@linux.ibm.com" <agordeev@linux.ibm.com>, 
	"alex@ghiti.fr" <alex@ghiti.fr>, "aou@eecs.berkeley.edu" <aou@eecs.berkeley.edu>, 
	"borntraeger@linux.ibm.com" <borntraeger@linux.ibm.com>, "chenhuacai@kernel.org" <chenhuacai@kernel.org>, 
	"dev.jain@arm.com" <dev.jain@arm.com>, "gor@linux.ibm.com" <gor@linux.ibm.com>, 
	"hca@linux.ibm.com" <hca@linux.ibm.com>, 
	"Jonathan.Cameron@huawei.com" <Jonathan.Cameron@huawei.com>, "palmer@dabbelt.com" <palmer@dabbelt.com>, 
	"pjw@kernel.org" <pjw@kernel.org>, 
	"shijie@os.amperecomputing.com" <shijie@os.amperecomputing.com>, "svens@linux.ibm.com" <svens@linux.ibm.com>, 
	"thuth@redhat.com" <thuth@redhat.com>, "wyihan@google.com" <wyihan@google.com>, 
	"yang@os.amperecomputing.com" <yang@os.amperecomputing.com>, 
	"vannapurve@google.com" <vannapurve@google.com>, "jackmanb@google.com" <jackmanb@google.com>, 
	"aneesh.kumar@kernel.org" <aneesh.kumar@kernel.org>, "patrick.roy@linux.dev" <patrick.roy@linux.dev>, 
	"Thomson, Jack" <jackabt@amazon.co.uk>, "Itazuri, Takahiro" <itazur@amazon.co.uk>, 
	"Manwaring, Derek" <derekmn@amazon.com>, "Cali, Marco" <xmarcalx@amazon.co.uk>
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 8FBCEA0012
X-Stat-Signature: q79gfdps1b7h6o65mgp8d3f4u7drhkrq
X-HE-Tag: 1768513371-577290
X-HE-Meta: U2FsdGVkX1/JGUKh1xquUL5qErBDsKwrP9M9nvW6mFHFKj3FokSKmS4pecvXb0Z45a/Vjwd2triJLp8l8xea3a7kFbLf78+MNy2bVLCBClyjHlwiiT6HfiAX/obpZw7Drt0ecQ+ddnOjhvCGNxbP0Djr0COiRvdaTg+CbIFKmrHJOJIdh3r8dhK/dxqiV0/2KgWDkj9BIvzS7zgewrgKPQQpwPaNDIJcwCnid+p7+se7ixgq9v1GKFnHpOpXkDhnkXn+v9YBWBoKjDTcVs0lolQ3AmM7ZmKXis2ueirxflDrwRIMZ++GEW0+JEk9tG5YuWGjHSC2bgb23Yg0Tsrol8inKVi/u8Y2nEhGBaEgVHhCKIJ+o9d+t0RX4fEeLm0tB80KazEo7R3nKp+euvS6K7VHXvrJyVlPk5i0xyOwkfZM5FA7CaL4tw3+/JaaQE3M3nOMV4gtbITzbUF5gQpdqT0TOOyE45j/TPmmxg/7giI3q7I/9peo1gtGwRW0Yc/kSgqkBL4zXR46IwI/kwFVpio5Z5A1HE29uS59yqAhHxJJYhilpthqUHzdOWvmAGGg9d/rzYqoj6LKpU6Q9nzePU9nM2JaxX5PBX57HcEQxJ2JyN/uG6W+wX0kdopR0bWG9IFtKnt+HEh3tCMi26FEFvY/VRHgkQxO7BnUQFARHvQB6GWmMdQcKDZHXUYAMPhteZTUSk5t6QKeiWe/zrpdtUpXIGFmIpZLEABG4G9MEFg0r+1uSbWlWI2D+gdmgYjRF5hBsrA4MB2PdLkaCPAnJDUOtJdkk7PhHCOlyai7QlUZHOfJr1/plXfvqNTZCsuPtD06gVGuqZlqxJuz1amb0Mly/2re+vmfKPhx2rwxgJd7hZD3JKMed1W6nZl5NYH6XEj5cNLMep7vfd8uIwiWuHOLkNPfMolKgKmD4JmExdxIlIz4dpB5YJiT5vPPeDDks6LynEa9HFV7/pIjvZh
 6l2ClRjt
 xO1KLEXiBdsfPcWQeq3m5V42UC4DQFT3AxRB7ZEaioG2IklYCqgnEIoNYPU5l70M/IJz1hgK3zyYQB9xaSPcdtfkiJjNt2OjbVi4+zOquFn+pgWW4OCk7QROpNJrgFq3VAKfrfndUE1B/eGOv9azHigc1f9VHZHH0vuNNEHehmnbqYFM5UmvclHRgMWjYzJl9HrBJv9pflXWcNOjHBI34fu0sjFij9qraajbqg2S6n3S41qq2jbjwpcCa+8RXIsW6+9RkyS2COffUf3BKcuF7f+zoXibUhufpjKn2rGCipM+qM6lbcaLTuoFTPMBeSGrHOMzFtcLNuXswpbzvSbXatyIly0p2j75V8YcqTJEWGGDgVQKLHSNP4EkbZoqTRO0Pe0IZ0mTWqTTyGoZTfqjIlZ9efd+J9UEqFNf6dzVJkSEvxFY9kLaWJFcbpM2R7iz4QvXhXjdJLsQnGB7LCy+bukXP9mbi3BsvfxWy9u24ewjo4guzfdi3l5SDeHkycj8miG06QoxLT5DAfjd6dglk7zvwdD3ZEQOqo+cM
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

"Kalyazin, Nikita" <kalyazin@amazon.co.uk> writes:

> From: Patrick Roy <patrick.roy@linux.dev>
>
> Add AS_NO_DIRECT_MAP for mappings where direct map entries of folios are
> set to not present. Currently, mappings that match this description are
> secretmem mappings (memfd_secret()). Later, some guest_memfd
> configurations will also fall into this category.
>
> Reject this new type of mappings in all locations that currently reject
> secretmem mappings, on the assumption that if secretmem mappings are
> rejected somewhere, it is precisely because of an inability to deal with
> folios without direct map entries, and then make memfd_secret() use
> AS_NO_DIRECT_MAP on its address_space to drop its special
> vma_is_secretmem()/secretmem_mapping() checks.
>
> Use a new flag instead of overloading AS_INACCESSIBLE (which is already
> set by guest_memfd) because not all guest_memfd mappings will end up
> being direct map removed (e.g. in pKVM setups, parts of guest_memfd that
> can be mapped to userspace should also be GUP-able, and generally not
> have restrictions on who can access it).
>
> Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> Acked-by: David Hildenbrand (Red Hat) <david@kernel.org>
> Signed-off-by: Patrick Roy <patrick.roy@linux.dev>
> Acked-by: Vlastimil Babka <vbabka@suse.cz>
> Signed-off-by: Nikita Kalyazin <kalyazin@amazon.com>
> ---
>  include/linux/pagemap.h   | 16 ++++++++++++++++
>  include/linux/secretmem.h | 18 ------------------
>  lib/buildid.c             |  4 ++--
>  mm/gup.c                  | 10 +++++-----
>  mm/mlock.c                |  2 +-
>  mm/secretmem.c            |  8 ++------
>  6 files changed, 26 insertions(+), 32 deletions(-)
>
> diff --git a/include/linux/pagemap.h b/include/linux/pagemap.h
> index 31a848485ad9..6ce7301d474a 100644
> --- a/include/linux/pagemap.h
> +++ b/include/linux/pagemap.h
> @@ -210,6 +210,7 @@ enum mapping_flags {
>  	AS_WRITEBACK_MAY_DEADLOCK_ON_RECLAIM = 9,
>  	AS_KERNEL_FILE = 10,	/* mapping for a fake kernel file that shouldn't
>  				   account usage to user cgroups */
> +	AS_NO_DIRECT_MAP = 11,	/* Folios in the mapping are not in the direct map */
>  	/* Bits 16-25 are used for FOLIO_ORDER */
>  	AS_FOLIO_ORDER_BITS = 5,
>  	AS_FOLIO_ORDER_MIN = 16,
> @@ -345,6 +346,21 @@ static inline bool mapping_writeback_may_deadlock_on_reclaim(const struct addres
>  	return test_bit(AS_WRITEBACK_MAY_DEADLOCK_ON_RECLAIM, &mapping->flags);
>  }
>
> +static inline void mapping_set_no_direct_map(struct address_space *mapping)
> +{
> +	set_bit(AS_NO_DIRECT_MAP, &mapping->flags);
> +}
> +
> +static inline bool mapping_no_direct_map(const struct address_space *mapping)
> +{
> +	return test_bit(AS_NO_DIRECT_MAP, &mapping->flags);
> +}
> +
> +static inline bool vma_has_no_direct_map(const struct vm_area_struct *vma)
> +{
> +	return vma->vm_file && mapping_no_direct_map(vma->vm_file->f_mapping);
> +}
> +
>  static inline gfp_t mapping_gfp_mask(const struct address_space *mapping)
>  {
>  	return mapping->gfp_mask;
> diff --git a/include/linux/secretmem.h b/include/linux/secretmem.h
> index e918f96881f5..0ae1fb057b3d 100644
> --- a/include/linux/secretmem.h
> +++ b/include/linux/secretmem.h
> @@ -4,28 +4,10 @@
>
>  #ifdef CONFIG_SECRETMEM
>
> -extern const struct address_space_operations secretmem_aops;
> -
> -static inline bool secretmem_mapping(struct address_space *mapping)
> -{
> -	return mapping->a_ops == &secretmem_aops;
> -}
> -
> -bool vma_is_secretmem(struct vm_area_struct *vma);
>  bool secretmem_active(void);
>
>  #else
>
> -static inline bool vma_is_secretmem(struct vm_area_struct *vma)
> -{
> -	return false;
> -}
> -
> -static inline bool secretmem_mapping(struct address_space *mapping)
> -{
> -	return false;
> -}
> -
>  static inline bool secretmem_active(void)
>  {
>  	return false;
> diff --git a/lib/buildid.c b/lib/buildid.c
> index aaf61dfc0919..b78fe5797e9c 100644
> --- a/lib/buildid.c
> +++ b/lib/buildid.c
> @@ -46,8 +46,8 @@ static int freader_get_folio(struct freader *r, loff_t file_off)
>
>  	freader_put_folio(r);
>
> -	/* reject secretmem folios created with memfd_secret() */
> -	if (secretmem_mapping(r->file->f_mapping))
> +	/* reject folios without direct map entries (e.g. from memfd_secret() or guest_memfd()) */
> +	if (mapping_no_direct_map(r->file->f_mapping))
>  		return -EFAULT;
>
>  	r->folio = filemap_get_folio(r->file->f_mapping, file_off >> PAGE_SHIFT);
> diff --git a/mm/gup.c b/mm/gup.c
> index 9cad53acbc99..11461a54b3ae 100644
> --- a/mm/gup.c
> +++ b/mm/gup.c
> @@ -11,7 +11,6 @@
>  #include <linux/rmap.h>
>  #include <linux/swap.h>
>  #include <linux/swapops.h>
> -#include <linux/secretmem.h>
>
>  #include <linux/sched/signal.h>
>  #include <linux/rwsem.h>
> @@ -1216,7 +1215,7 @@ static int check_vma_flags(struct vm_area_struct *vma, unsigned long gup_flags)
>  	if ((gup_flags & FOLL_SPLIT_PMD) && is_vm_hugetlb_page(vma))
>  		return -EOPNOTSUPP;
>
> -	if (vma_is_secretmem(vma))
> +	if (vma_has_no_direct_map(vma))
>  		return -EFAULT;
>
>  	if (write) {
> @@ -2724,7 +2723,7 @@ EXPORT_SYMBOL(get_user_pages_unlocked);
>   * This call assumes the caller has pinned the folio, that the lowest page table
>   * level still points to this folio, and that interrupts have been disabled.
>   *
> - * GUP-fast must reject all secretmem folios.
> + * GUP-fast must reject all folios without direct map entries (such as secretmem).
>   *
>   * Writing to pinned file-backed dirty tracked folios is inherently problematic
>   * (see comment describing the writable_file_mapping_allowed() function). We
> @@ -2753,7 +2752,7 @@ static bool gup_fast_folio_allowed(struct folio *folio, unsigned int flags)
>  	if (WARN_ON_ONCE(folio_test_slab(folio)))
>  		return false;
>
> -	/* hugetlb neither requires dirty-tracking nor can be secretmem. */
> +	/* hugetlb neither requires dirty-tracking nor can be without direct map. */
>  	if (folio_test_hugetlb(folio))
>  		return true;
>
> @@ -2791,8 +2790,9 @@ static bool gup_fast_folio_allowed(struct folio *folio, unsigned int flags)
>  	 * At this point, we know the mapping is non-null and points to an
>  	 * address_space object.
>  	 */
> -	if (secretmem_mapping(mapping))
> +	if (mapping_no_direct_map(mapping))
>  		return false;
> +
>  	/* The only remaining allowed file system is shmem. */
>  	return !reject_file_backed || shmem_mapping(mapping);
>  }
> diff --git a/mm/mlock.c b/mm/mlock.c
> index 2f699c3497a5..a6f4b3df4f3f 100644
> --- a/mm/mlock.c
> +++ b/mm/mlock.c
> @@ -474,7 +474,7 @@ static int mlock_fixup(struct vma_iterator *vmi, struct vm_area_struct *vma,
>
>  	if (newflags == oldflags || (oldflags & VM_SPECIAL) ||
>  	    is_vm_hugetlb_page(vma) || vma == get_gate_vma(current->mm) ||
> -	    vma_is_dax(vma) || vma_is_secretmem(vma) || (oldflags & VM_DROPPABLE))
> +	    vma_is_dax(vma) || vma_has_no_direct_map(vma) || (oldflags & VM_DROPPABLE))
>  		/* don't set VM_LOCKED or VM_LOCKONFAULT and don't count */
>  		goto out;
>
> diff --git a/mm/secretmem.c b/mm/secretmem.c
> index edf111e0a1bb..560cdbe1fe5d 100644
> --- a/mm/secretmem.c
> +++ b/mm/secretmem.c
> @@ -134,11 +134,6 @@ static int secretmem_mmap_prepare(struct vm_area_desc *desc)
>  	return 0;
>  }
>
> -bool vma_is_secretmem(struct vm_area_struct *vma)
> -{
> -	return vma->vm_ops == &secretmem_vm_ops;
> -}
> -
>  static const struct file_operations secretmem_fops = {
>  	.release	= secretmem_release,
>  	.mmap_prepare	= secretmem_mmap_prepare,
> @@ -156,7 +151,7 @@ static void secretmem_free_folio(struct folio *folio)
>  	folio_zero_segment(folio, 0, folio_size(folio));
>  }
>
> -const struct address_space_operations secretmem_aops = {
> +static const struct address_space_operations secretmem_aops = {
>  	.dirty_folio	= noop_dirty_folio,
>  	.free_folio	= secretmem_free_folio,
>  	.migrate_folio	= secretmem_migrate_folio,
> @@ -205,6 +200,7 @@ static struct file *secretmem_file_create(unsigned long flags)
>
>  	mapping_set_gfp_mask(inode->i_mapping, GFP_HIGHUSER);
>  	mapping_set_unevictable(inode->i_mapping);
> +	mapping_set_no_direct_map(inode->i_mapping);
>
>  	inode->i_op = &secretmem_iops;
>  	inode->i_mapping->a_ops = &secretmem_aops;
> --
> 2.50.1

Thanks also for the cleanups!

Reviewed-by: Ackerley Tng <ackerleytng@google.com>


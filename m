Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8075ACD98D2
	for <linux-mm@archiver.kernel.org>; Tue, 16 Jun 2026 22:19:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 569156B00D6; Tue, 16 Jun 2026 18:19:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5412D6B00D7; Tue, 16 Jun 2026 18:19:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 42F226B00D9; Tue, 16 Jun 2026 18:19:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 18E5D6B00D6
	for <linux-mm@kvack.org>; Tue, 16 Jun 2026 18:19:19 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 87A33140288
	for <linux-mm@kvack.org>; Tue, 16 Jun 2026 22:19:18 +0000 (UTC)
X-FDA: 84887192796.25.35A92B5
Received: from mail-ed1-f74.google.com (mail-ed1-f74.google.com [209.85.208.74])
	by imf01.hostedemail.com (Postfix) with ESMTP id AA43140002
	for <linux-mm@kvack.org>; Tue, 16 Jun 2026 22:19:16 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=szJ1nf0O;
	spf=pass (imf01.hostedemail.com: domain of 3hTgxagkKCBQu52wyBI1508805y.w86527EH-664Fuw4.8B0@flex--aliceryhl.bounces.google.com designates 209.85.208.74 as permitted sender) smtp.mailfrom=3hTgxagkKCBQu52wyBI1508805y.w86527EH-664Fuw4.8B0@flex--aliceryhl.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781648356;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hcH8wbzZOm8yn4lLoAkAwb8V6hZltU+bJ+2UV9XpA9s=;
	b=AscRmMbsdoEmRPWIi9ic3LLNKoBD46AiORkV8IlAtSNtyNdXBGnTC1UhQUx9wDhrcufV6D
	gi3W1Qhnsw6d0cM+7K8JBPaPGslJBR5sxc4pldjgFpfpg9rVuZTMWYYJxkLjMDPPazXeKT
	G9Seu2oFEHIejIByQZ9l7BHwYF0a39o=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=szJ1nf0O;
	spf=pass (imf01.hostedemail.com: domain of 3hTgxagkKCBQu52wyBI1508805y.w86527EH-664Fuw4.8B0@flex--aliceryhl.bounces.google.com designates 209.85.208.74 as permitted sender) smtp.mailfrom=3hTgxagkKCBQu52wyBI1508805y.w86527EH-664Fuw4.8B0@flex--aliceryhl.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781648356;
	b=hHamQjZHpAJNeIErFg7fCj6+gNuJeeGyXVj1wLwosrZsNOoEPDnWplhzej5B5AgkYJyKNR
	hlh0j+iHhLtK75wT6YFwwlDmOv4LWI8guOg+byncy++/APeesnVJxqAp1Jgu47KtgZDYUE
	m5KtuOnVBWRj+JKNSKQXasCcKWvsmAc=
Received: by mail-ed1-f74.google.com with SMTP id 4fb4d7f45d1cf-691a67a7b58so3945833a12.1
        for <linux-mm@kvack.org>; Tue, 16 Jun 2026 15:19:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1781648355; x=1782253155; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=hcH8wbzZOm8yn4lLoAkAwb8V6hZltU+bJ+2UV9XpA9s=;
        b=szJ1nf0OcpJdlYLbU5rzXP4XpYvHO3JAVFbP/0ahiQlwtiV7ufpYb+uyP/wnLwhuUr
         G/6LdqV8uvzWteXyZHIt8Q2jrfLlcdxTxn2VR1bhLshH7Icya0WuNv61+exYzxACau/c
         8OoIyhCdnmd1fLgwMgq3sfIOwl4hO0awPPHrEv8IqX3JpmAdKqrb6kjPxuv2kZ7Dwexk
         /ErF0XBEE7qTnPCvnltVDmF93Eo2v6P6ry55MEgpzmyc4g6zcSf52U5NY+cyUxXDroFe
         eQC4HlCnnKQ4PFQ+dA/eSrqAjMLhGSBMU4FJt8WG1Bl4NJegiYwmx1L2a05LoCdEjOaW
         HReA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781648355; x=1782253155;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=hcH8wbzZOm8yn4lLoAkAwb8V6hZltU+bJ+2UV9XpA9s=;
        b=DACRP5mgRZzSfJdgg423JhcTWeFOJU1PUg4THgB4YnE/gjFeSNK+IqKoTQ+lBc9vxG
         3jn/QiHpcs+Ie0+qhpcpfrPhc84+xf2ulf6hSbZFqnN1xXIhXjRJ8ieVclipGpp0TWOQ
         L+7cbasg5WVKvRKLM5Ug1blcuhr7ezhEYMDYZxo9NNwBVYoJIJRYYZ6JWzRlBGy1quyK
         b0yWAUEhDdl6pDR0VjO0jDkrnxrWgK+zKEEG6PXYGAjKXVIowpqva2lBWPPXVE2bnii5
         qFa7iycETS0MB5qK8MvbmzalznnZNN2/IpcBxjjhdBxAmZoMxdt82NCT2FhKZ32T6dVZ
         Tvcw==
X-Forwarded-Encrypted: i=1; AFNElJ8u6V9Ud6t85HfnCdhlsYgpjnwSJebwUD7SOhN7DVZ7jFSkK/EoVWY7qKTvg3WOQHF56HHlpzkFZA==@kvack.org
X-Gm-Message-State: AOJu0YwwWOsS/TXFlcblatKnhvHSPPzIXdHQo0A5w8BD8i3cUWlb1VA9
	QWVX9COqOpoRM7ZTH2uq0H6VHwmWj/6cMtHHZZI9hRLSrpUZbUgMkXa0Cy//VvorIJULM3Wk8bz
	YTYdrntE5pdNwYAjS4g==
X-Received: from ejfp18.prod.google.com ([2002:a17:906:e92:b0:beb:c99:aa2])
 (user=aliceryhl job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:907:1dd6:b0:bed:9a7:5ed1 with SMTP id a640c23a62f3a-c043a477df5mr130254166b.5.1781610629337;
 Tue, 16 Jun 2026 04:50:29 -0700 (PDT)
Date: Tue, 16 Jun 2026 11:50:27 +0000
In-Reply-To: <20260604-unique-ref-v17-1-7b4c3d2930b9@kernel.org>
Mime-Version: 1.0
References: <20260604-unique-ref-v17-0-7b4c3d2930b9@kernel.org> <20260604-unique-ref-v17-1-7b4c3d2930b9@kernel.org>
Message-ID: <ajE4g7JsM6bnpEOu@google.com>
Subject: Re: [PATCH v17 01/10] rust: alloc: add `KBox::into_non_null`
From: Alice Ryhl <aliceryhl@google.com>
To: Andreas Hindborg <a.hindborg@kernel.org>
Cc: Miguel Ojeda <ojeda@kernel.org>, Gary Guo <gary@garyguo.net>, 
	"=?utf-8?B?QmrDtnJu?= Roy Baron" <bjorn3_gh@protonmail.com>, Benno Lossin <lossin@kernel.org>, 
	Trevor Gross <tmgross@umich.edu>, Danilo Krummrich <dakr@kernel.org>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Dave Ertman <david.m.ertman@intel.com>, 
	Ira Weiny <ira.weiny@intel.com>, Leon Romanovsky <leon@kernel.org>, Paul Moore <paul@paul-moore.com>, 
	Serge Hallyn <sergeh@kernel.org>, "Rafael J. Wysocki" <rafael@kernel.org>, David Airlie <airlied@gmail.com>, 
	Simona Vetter <simona@ffwll.ch>, Alexander Viro <viro@zeniv.linux.org.uk>, 
	Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
	Daniel Almeida <daniel.almeida@collabora.com>, Viresh Kumar <vireshk@kernel.org>, 
	Nishanth Menon <nm@ti.com>, Stephen Boyd <sboyd@kernel.org>, Bjorn Helgaas <bhelgaas@google.com>, 
	"Krzysztof =?utf-8?Q?Wilczy=C5=84ski?=" <kwilczynski@kernel.org>, Boqun Feng <boqun@kernel.org>, 
	Uladzislau Rezki <urezki@gmail.com>, Lorenzo Stoakes <ljs@kernel.org>, Vlastimil Babka <vbabka@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Igor Korotin <igor.korotin@linux.dev>, 
	Pavel Tikhomirov <ptikhomirov@virtuozzo.com>, linux-kernel@vger.kernel.org, 
	rust-for-linux@vger.kernel.org, linux-block@vger.kernel.org, 
	linux-security-module@vger.kernel.org, dri-devel@lists.freedesktop.org, 
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, linux-pm@vger.kernel.org, 
	linux-pci@vger.kernel.org, driver-core@lists.linux.dev
Content-Type: text/plain; charset="utf-8"
X-Rspamd-Queue-Id: AA43140002
X-Stat-Signature: amcen4k8aw6fdirr67sowqycaso77hk5
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1781648356-496897
X-HE-Meta: U2FsdGVkX18stcMvDjBfrUaD6/IyoCI1mmyd0ZIKFE6QqOU4Ubx9V30WqhzsTFoSMZmtwFi8MKX9B05ytRU3GHY3FkqZHwLr67EdjwJZiM5rW2qWEWckkL3UkyIAgEPo42Nvi6Bc5Lf1EyTX+82FyYvfbOvwEMhp2k9EBVfSAj1HPnv1GJUxRb1WqSoh0xYYLdmi6u8ptP+OHT3fWNoOgd1DTFLLzrySI2vQxF+qEkwIp/R09ciHOgHjwb6VSLVBcd0zenK1xuMOZF8LbLEFBeIDZDo1Mzp9ZF3sCQoG86M09Pq/qcYdN6otI6vzAqHokSDE0C8UR6N1xQghSK+9M96pGChjVnXwmndAu+UjVk2kj7BgTMFCPYr0HdR3FqIYt0xkobEXSc9lUTxdfzYIzqiOv7kH8qjp/0FE+n/wWjjgVWDQYInytSlpjnOjRsbkhJeYq1ak92TLE72wX+QFMUP7ufBPXz8KbVeulA5F7OZNaC7T5BzYHJPCT6R4OKIPjC0695Kz4aDG3j8K6nhDchT24ruQCRpl8f0mMrWIru4ioin/X7gekAOn99Fcyw9dBBy6GwrbQNZhIYTIJwBnBzMKgan2LXFFbanXWGAOsWiBSDOdF4XFMAQnFSb1ie6Xg7CrQq5cYrsCgsPwVG2rdM/jfegHi1DI9vhlK67AU2HlGfJ/nKRsNtR24dM+bAN67MgaG/1XrPjcEo2L72YQwRmU9gfWkZ9VOsi56fiLS2uwwnOWm+oMWNL7mvUSD2oTSLTWAkvQ1HQkQB+6QvHEumE9WrPhUKtFIy28X95sYAVIxla1ITLTy10wYXAzEsD43FzrzyJ4XDc9VZ7s++a5FkdKt3ES37gvu5+vqmtPJzNL5t3zjIIj7YpNd5m9FWAMl4miHXbaLgnS0OXALhYD8DXT5JvKpgGffZ1SZfUnge5kCS9kZ/29SG+MUQOazwiLjz9ELvg3GDLoEQN70ob
 ZYib9mS/
 duAkMUZqzrhyJ5nZkFUU4BX+IEr+J47v57od2j5/ZdntcVgaxzuKZ4B5/OuYB36eVZAhcbSQxJVFh4bgQEB4u5gmlX4T4sTdUbKmRlpvzWcK4X95UeZfNDnyYWX+xbD7Tlrns6FuEUuRzSdButQqUppfUOYAiWqJ2YEWLVGnkt2tsZfxTmP+/88u14HFYsfIjLCQBLRs5oteftMe1ifojhEVtCkBLMTceqcj4roTPnzReOg4P7ItlB5Fn4BCT31a7LFtBqDcfcfQIcIbkdVUfOp8fIgBgq/kiNUPuCdvFmMi94c9eSxaoCcTq9SfVKdrYzOrZ/kdWMC3ETpPzVxJvxoSZACmq+H63F2m53Q9PeMvS0DeQeJ5yn80NaIcFttFRUoj+xNCcZ05bt+KrqfinA9yywEAz4JRYF+KkggBO519Eue2HEcFSLxxOTruPHOQKMVPvEmFPDgn26X1CRgaZcZsPe6UL7b9UCCnvXwBrquLXYnhEBy5jcTjUNVju6n7UPAxRnv5Qyt2bheiIYODwAOEIgOLrcH8bCki9BcbhE+UZNJa3iz0+TdIWjoIbRiKfwLSPxO8rBganXeUGS111qGUGZSkx+9u4btIXEa03BgwrkGd+g+OyNfvELtRMKWnyGcGrq3a27VAV6U3MhAb+t5R/gHRXdntwDrSfMa4dvWj0o9qRa+SWZw+POO2qDYEhb8tj6LzZu7CEB8lUY6SKfY0yTXbZnpqjr1NHx9arFrNY8mitmOanAEsq61I9fw+2wvk2ClKXKn741srtab0sDhEtDt8aG4tW7qGyzvi7EMUThHNLjfgglI+uwR3M/YM49PNdNWwgTe3nlKqYMJ7vpOwVex6FpaI6EMYnJxW1GVnEpZ8Q4ymkuopYNhsF7mnIa5ur
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jun 04, 2026 at 10:11:13PM +0200, Andreas Hindborg wrote:
> Add a method to consume a `Box<T, A>` and return a `NonNull<T>`. This
> is a convenience wrapper around `Self::into_raw` for callers that need
> a `NonNull` pointer rather than a raw pointer.
> 
> Signed-off-by: Andreas Hindborg <a.hindborg@kernel.org>

Reviewed-by: Alice Ryhl <aliceryhl@google.com>


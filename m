Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5386AC5DF94
	for <linux-mm@archiver.kernel.org>; Tue, 25 Aug 2026 07:32:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0C1996B008C; Tue, 25 Aug 2026 03:32:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 099126B0092; Tue, 25 Aug 2026 03:32:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ECA226B0095; Tue, 25 Aug 2026 03:32:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B3B316B008C
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 03:32:22 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 0EFFF8034D
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 07:32:22 +0000 (UTC)
X-FDA: 85138973724.04.DE5BFA7
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com [209.85.218.70])
	by imf12.hostedemail.com (Postfix) with ESMTP id 5C36240004
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 07:32:20 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=DmcND4jV;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf12.hostedemail.com: domain of 3AUWNagkKCBw2DA46JQ9D8GG8D6.4GEDAFMP-EECN24C.GJ8@flex--aliceryhl.bounces.google.com designates 209.85.218.70 as permitted sender) smtp.mailfrom=3AUWNagkKCBw2DA46JQ9D8GG8D6.4GEDAFMP-EECN24C.GJ8@flex--aliceryhl.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787643140;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Gc0l75ZBOgJa/54BUKdQtQYXjBIwPQDc3JRV2G9xqCo=;
	b=x+BbHOlCs8+n2yCTqoeJizQU2dd8J8akV317UqH5hH3lb6qLHopKO1bQ0+HN0QmEV9XECS
	dLz1pv8QOKYt47KBAPz2y6/BwfZxK6dXcqNRht+kw7iw2DdRVOetYV8LTcQJJan0/U20sz
	u7QlmEVBou+x96NM8dlTpgUM61ObbsU=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=DmcND4jV;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf12.hostedemail.com: domain of 3AUWNagkKCBw2DA46JQ9D8GG8D6.4GEDAFMP-EECN24C.GJ8@flex--aliceryhl.bounces.google.com designates 209.85.218.70 as permitted sender) smtp.mailfrom=3AUWNagkKCBw2DA46JQ9D8GG8D6.4GEDAFMP-EECN24C.GJ8@flex--aliceryhl.bounces.google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787643140;
	b=hbF2C9QgThug52oqcy49fXlMEA6ZTAyvxpVuwtz19b9Vc5D/EdaHM+tvrqGlbiaiOC4jxH
	IMb/VQF8emkOOir7FfVIARbsOBP7im/6qAY9H3OBC6aKimAsEoa1Yv8U0+EioDaIgJRQVF
	0+c8YbY1mYZ/3e+oS+uBoQL1BrKfZ9o=
Received: by mail-ej1-f70.google.com with SMTP id a640c23a62f3a-c15cec1ccb6so370691266b.1
        for <linux-mm@kvack.org>; Tue, 25 Aug 2026 00:32:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1787643139; x=1788247939; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Gc0l75ZBOgJa/54BUKdQtQYXjBIwPQDc3JRV2G9xqCo=;
        b=DmcND4jV9N0kx4m6aac5Y8LgKA/DxVaoSZSsb65u64zz6+qR51NlkByJQjwgXgQA+X
         OHCcQ5FOz5EdgRPtbS+zCzzIREXO0M1DQlMIni6ayXqLQWqZOvbAE/wJcX4UOKDic/HQ
         cR/z/Lbus2ZcfO1qfCzVPpQq8Kkt/idZM0a/Sbaodye+gKsPMFsh3m/YjYgIq2KGsLaN
         +jB6rS4fJfiY0uOABWB1MoVb3Sml/asLZaNHi8RfPKzT1bT70dGe372HyxsAhK74i+aS
         FxFKQV+B3DlZFcVKRhtraMaIwhRXWQBzAqOvsjnphOfNpGFGhyK5VpG155Zm3sxqfCPY
         WFKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787643139; x=1788247939;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Gc0l75ZBOgJa/54BUKdQtQYXjBIwPQDc3JRV2G9xqCo=;
        b=q9OzgFNaaPJwj5sHy09Yrh8/bbeK4UtZSh7wCZJkkXFcckooGiDEXGOecQUxJi1pM1
         889cFnFe0ERFa4s+ggz/6AWPh6RSvVyW9OUowSa2LerZKiwvBQSHnfnZRM/7rkmpn8VR
         XYHlXWTpl3WnChY68qyTX8/tDbt10iz1YJlaBg50F+rtM/IL84lsLQxijyFZd+DH0/c2
         x9J/YpWovnyDZakHfwoO0iWKmW5D7DE/gP4q/S/5sBc+VcyYusImJl368iurxW5ld/bX
         SpsfUlUOtWXP8xaVeLl24y0rUSpQP1oqF1u1JMHmHY7iK4jRgNwwOy3ZEWs7egWc1bgl
         VAig==
X-Forwarded-Encrypted: i=1; AHgh+RqIddhrSnKm0b55k9nQpR8aKcXcwW+IH5xQDNXB+4HL6x/63RvPKM5J0nmu4kGEIv64hVxymaaw7A==@kvack.org
X-Gm-Message-State: AFuF++kgplstn6m2ey6liZGR9kkAmfziEY4KOjDn/AZjZmcywsET5/Pj
	5zjQ4ZfkozoV2gKZjhK6zNYSOoLYMggMUcNY7DNt9+4b/VL8Nonyjnp/QtpmIAKgk5EtI3qV+mH
	bg7nthwTQ4X4X7RCvPQ==
X-Received: from edwy24.prod.google.com ([2002:a05:6402:1358:b0:6a0:3497:f2f6])
 (user=aliceryhl job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6402:52ca:b0:6a1:4fc7:94b3 with SMTP id 4fb4d7f45d1cf-6a5c40cdb68mr5068957a12.1.1787643137356;
 Tue, 25 Aug 2026 00:32:17 -0700 (PDT)
Date: Tue, 25 Aug 2026 07:32:15 +0000
In-Reply-To: <20260824194808.216021-1-iprintercanon@gmail.com>
Mime-Version: 1.0
References: <20260218-binder-vma-check-v2-1-60f9d695a990@google.com> <20260824194808.216021-1-iprintercanon@gmail.com>
Message-ID: <ao1E_6yo9hE17e2E@google.com>
Subject: Re: [PATCH v2 1/2] rust_binder: check ownership before using vma
From: Alice Ryhl <aliceryhl@google.com>
To: Artem Lytkin <iprintercanon@gmail.com>
Cc: Lorenzo Stoakes <ljs@kernel.org>, "Liam R . Howlett" <liam@infradead.org>, 
	Danilo Krummrich <dakr@kernel.org>, Jann Horn <jannh@google.com>, Carlos Llamas <cmllamas@google.com>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Daniel Almeida <daniel.almeida@collabora.com>, 
	Deborah Brouwer <deborah.brouwer@collabora.com>, linux-mm@kvack.org, 
	rust-for-linux@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="utf-8"
X-Rspamd-Queue-Id: 5C36240004
X-Stat-Signature: f5opa4x9mzmsngp745ddjkfy6jf7iat4
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-HE-Tag: 1787643140-25457
X-HE-Meta: U2FsdGVkX19C0OqmpPjQ7329NPOsneh/HrUmYEapDnNABism/YV1ja3uyFZFfqhPnWSKWhn5dlFcADqbGFpJMM5v1gW00/rlmLQKTCSEXImmLnsZSco7G2Zqoemo8mxtA7ZTWuTrSy/QlThQC46IHLf/8piGSWTzX90ByL96AVVX+0g8gi+yinL+DVI49rFOGZty8UJj7RDtyeOThmo0KRLaLOtqgl5gUOpRmFVeyvf/WNSzhNcJ5SGRr+5xcJVZUYGM/0wDnNr9AevmYVidmIgialjjlI8rhgEU/isKyNrqlaP8jFLpyo1tzsCZCmLai8PIUZDmgzVXQurPVrf+ki1UTcDlEQdGKM4a/SPSucptn5RaI2Qd6wcZ5xFpMmtr+WnZXK1CHFIrYl6BBrxdbtuMLSeKxGog6nS2GMbb5cZ825M7Hi6ukcIOnFVBeWPyncxv1vOovYXf7KESMctyJGthdqlISudosqM1bTDaVmi4tNIoJ0DtGeOsALrzwjb7Ro0EW5pk4wZm1QT1cP8pr/RQl8kEHcfPQ1jgmUCwQy7ZiLkvRs1sH8bwtAQJOsHp7vZGO1FEm7HfibMXj5vOqsV3nKUK0a3gg29LHy5s2nlV0Z6shKw8xAQ42rq9b7RFWuoN22bo9Re3+plAHo2syAl/8umiJYgY3h2KBzneh9Nmt8iNgmpzgJsLuVNNJPtKHHbKYnreRRJRtdnjN2HmExyG2ksvjzIMo1FIssOxHvMq+WAeKzTvLj0vBNMnS4OieddkjqMIwg/CpjKJiBMtdHuwJrGReZdZ5xqe8BJoppYsGlgNc33CywEooK2V2zGClrAmChvkYyAlRSgKrifzrPOlSztqsgzVzfVrrsq6ZpFWtiPRroQEj1+hzT+5Ed7jzftb4xukb7oSnLt4+l/e9CqRX/TzRO5qBWHxFE5fVloOCMxxib5/4E9PAl03zKyv0PypJIf/ZKWyCCfPwoo
 hylv9jOd
 L4a8VTPETeWbz1YWS7ucFOlCfUZo/NQtC4ucrKUZXLasq+8CxlG5Jj1Ad/Q8Msd+Lwr7T2FV9rZ2dZ0K1bMaoOqQUCVNSluPyBte1zqdm7OjVpF5P4TPyF8MucZKmzW6fF9tv9uReCKEacilmqBsJdjtI2xxz6SQYZOrsCjVaeeKH0C0Bo91DjFMaBkJDBSyCLO+RQHP5v4LLkYXXEpWdrMX6SniTFtija+UbVsiYVKd47i1AD/V7Pf4BHAUt5Evly1NkO9Yr8lwHEsXrNqXq/BrpKutrcS8uwnH3tRQ7R50e8n5GDbCsC4uAeRqFjxRaasRQEC/6OuU96OOVxiXvwbdAFVqoxxVCOyZ8P/FyipOiOdAHT1DnJ9leFbzJ/kF/FhVWoeEfNlSu6uR2hYu12XY6gAWxix4gby2KBiwMlHECq+yQQURAOaHJZlRUFOCW3UxdwFJM9hqwv/O3cbcHDS8GFofSVQiCh8jPj3iGcnudu8l/rNGEKAloFO5wB1PrE4FMXRIg9frFT0obuy/VV/6A0bBUT0GXRxkmV6YiavofUkNEk8u3+s8PjYqazEnjTYz3rQt1VdV5O+MLfauzW1HhuAPeNBSn22sql1JG/aHzcEzCq5AdddisqHtRlYfnNq7DQqw7cVppkbGh6WrjG3/ed/osJKSYQTApaMB6GgKmUBi79lYcS+S254QEJ6J1T8zzJEaNtszaGWiVo40P4MIVImPtKNJaCpJRNs34olhcxUC4xGamicUvivPi5dOPW9CyAWZu3JT/uyUIRBB3mn0vTw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Aug 24, 2026 at 10:48:08PM +0300, Artem Lytkin wrote:
> On Wed, Feb 18, 2026, Alice Ryhl wrote:
> > The plan is to introduce more vma
> > abstractions to avoid this unsafe access to vm_ops and vm_private_data,
> > but for now let's start with the simplest possible fix.
> [...]
> > (We probably still want to do both, but
> > the vm_ops->close callback will be added later as part of the follow-up
> > vma API changes.)
> 
> Alice, is that follow-up still on your list, or would you rather someone
> else took it?
> 
> I'd like to add the missing pieces to kernel::mm::virt: a VmOperations
> trait with open, close and fault, a typed way to install it together
> with the private data on a VmaNew, a VmFault wrapper, and a PFN-map
> typestate next to VmaMixedMap with vmf_insert_pfn_prot() on it. Binder
> would then drop BINDER_VM_OPS and the raw vm_ops pointer compare and get
> a close callback like the C driver has. Tyr needs the fault and PFN-map
> half of that for its user MMIO mmap. The first two patches of
> Collabora's Tyr series are the pgprot_noncached and pgoff helpers; they
> have had no replies since 7 May, so I'd build on those rather than
> duplicate them:
> 
>   https://lore.kernel.org/all/20260507-tyr-mmap-v1-0-eec048a23c25@collabora.com/

I have a draft for the vm_open callback somewhere and it's still on my
todo-list, but I'm not actively working on it right now. I'd be happy to
let someone else work on it, but it's somewhat nontrivial, so perhaps we
should have a call to discuss the design to work out the details?

> One design question first, for you and Lorenzo. f_op->mmap is
> deprecated in favour of mmap_prepare, where a driver sets desc->vm_ops
> instead of touching the vma, and the Rust side only has the old mmap
> path today. Should the vm_ops abstraction be built around mmap_prepare
> from the start, with a Rust mmap_prepare hook for miscdevice next to
> it, or is landing it on the existing VmaNew an acceptable first step?

Lorenzo, where can I learn more about this new mmap_prepare API? What
are the main differences?

Alice


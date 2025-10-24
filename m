Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6EDE1CCF9E0
	for <linux-mm@archiver.kernel.org>; Fri, 24 Oct 2025 15:52:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B77C08E00C5; Fri, 24 Oct 2025 11:52:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B4F848E0042; Fri, 24 Oct 2025 11:52:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A8D9B8E00C5; Fri, 24 Oct 2025 11:52:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 984668E0042
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 11:52:32 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 3C55889460
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 15:52:32 +0000 (UTC)
X-FDA: 84033450144.05.87B251F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf01.hostedemail.com (Postfix) with ESMTP id A42854000E
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 15:52:30 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="hmS/OtrF";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761321150;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VTiLyCUWXiRFzBsFXUw4i8LajKRgD3EvwGN8FJe5470=;
	b=CWSyvSlNsXQXpE9Ux99Sy2Qd0lbQus75jXxXAczw5qVwWhmTUgmK+jfNuCxF/4SmLMTpdr
	NnQG7N3mUcRA91d1Uk2sgH9aj7Jr8Nm0wKYoeXT1SG0X7F37DntpzzbSegO4Iev21t3uKO
	789vFagqJSXcMzwnylbwT5C8xF0+t0E=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="hmS/OtrF";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761321150; a=rsa-sha256;
	cv=none;
	b=WNcYuS7hb8/I7pdAKESjwvKQMMTtEdWHr3xU6KmoZspGVFI+u359i7mA1gYftTwDjfdnZF
	4DNIuZca+ERVrvI762DsgiKFc6e8JcFrQhRR0e6DF0hsRvqIz9mIpLKScDaTuQU3KPqU5d
	xU4psP2lPf3Xo07OKLE3yhtB/kZ8SbA=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 81703438E6;
	Fri, 24 Oct 2025 15:52:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34EF6C4CEF1;
	Fri, 24 Oct 2025 15:52:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761321149;
	bh=hN57D+m8bfZOyaql25Ql2BNoX4IBCg8l7ydroV/tKz0=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=hmS/OtrFuMY/e8rrKApoVlK6kToisDX80rTEqsylwmg+YmFSMbqGuRSosQ2ziAcBi
	 jbPOVLF8KOBXTJXRxl1OSHbIQo2H29kyfcKZkMUKBpJrIwaH5wpIe4N/H+9zRlasMH
	 kYcaEH/CycQEoRHV6B5Lrel8kpBTARMqYaaf5OT0PrvTJtOh+0usoO1I7FFlgwdk+7
	 wu34rIi0QCLtGoEHvw//qh8xp7MjinNmo7GtZmfTxGX5Ppo3ULQ6lzQuSkPw13/BMx
	 dY8wu/l8fW+yG9wQ9I+frPOeQJmEwLhCw0JkqWqgkZ7EshbZFuuPGRTCV/DqK1E4BG
	 EMwY35Ot7E8wA==
From: Pratyush Yadav <pratyush@kernel.org>
To: Pratyush Yadav <pratyush@kernel.org>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>,  akpm@linux-foundation.org,
  brauner@kernel.org,  corbet@lwn.net,  graf@amazon.com,  jgg@ziepe.ca,
  linux-kernel@vger.kernel.org,  linux-kselftest@vger.kernel.org,
  linux-mm@kvack.org,  masahiroy@kernel.org,  ojeda@kernel.org,
  rdunlap@infradead.org,  rppt@kernel.org,  tj@kernel.org
Subject: Re: [PATCHv7 3/7] kho: drop notifiers
In-Reply-To: <mafs0o6pwe1sy.fsf@kernel.org> (Pratyush Yadav's message of "Fri,
	24 Oct 2025 17:50:53 +0200")
References: <20251022005719.3670224-1-pasha.tatashin@soleen.com>
	<20251022005719.3670224-4-pasha.tatashin@soleen.com>
	<mafs0ikg7fbez.fsf@kernel.org>
	<CA+CK2bDrrg0UoJXpeN+Au2-sreYrZ+DHVcEUidzPw2Qk60orgg@mail.gmail.com>
	<mafs0o6pwe1sy.fsf@kernel.org>
Date: Fri, 24 Oct 2025 17:52:26 +0200
Message-ID: <mafs0jz0ke1qd.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain
X-Rspam-User: 
X-Rspamd-Queue-Id: A42854000E
X-Rspamd-Server: rspam03
X-Stat-Signature: rozmsnjr6x7h84hhgeac8rdwyogzay37
X-HE-Tag: 1761321150-161577
X-HE-Meta: U2FsdGVkX18e7YpC7fW2wYfdaM3Btw8tq+LxECoPzjaBCJkZ3xKwZfXdGrlP5PwDbcNSUp6L6uRHbv8wo5RA/c2JlZWRA/v7FkWmLCu3szvm+TPANkMcnJRUprk07fM/VevaBI4B2u8YtDJEhrUugbI+3YyV05aKbV9bch9FJFPm5TIQoFJupT9CSzqBQ14PSrCmwDoSnGpOrUrwiStBohZ9Yli/jlp6RSCnY/bwrx+DO4DWlv8xLXtA/MimMblU7Bni0Swbhg6nwOjF7/sUHngY9Q/X0ZeAr6R/drkloxJ9t0iLjv6LIDLZ4kuHgzYnO7rMzH67UUhAiOEN1X+hM7N46bRLC1Mag6gpM7ziRo0MhFY9lfJeJv9xj4Jo8BpWvYZ5YS0lDKZ6koRfdDfA6/SueXDKjzYM8WionVum/zaaizfzcLYui8pewSd9hAuaP8PT8zhVMJByRDWZGKXGzy8SS2VFkHgmkg2fl5cP3nLOeovDlJMMwn6OzOScD4nJxpXtO84xH2Tj7wCQQpfcNKcKWIFdKXC5m7suaW6nq4Yo6x98c/K0AqBAMgemmoZE3P1PuatfIdeusSMjUL6SlP7g9dzYGrVnOG6m68ZXaVypl1B56tS1YIBVOP3SUz9uu2vkysOP8sqW9V1wbkNv0E8OwdoPGH2yavO3n/40EJnt+RrIdOqt0Y0cTWr1lBNAhim9dXa3CJFljn6/0OYt/X62W6ptqJq1JzVH+2+2Ovgu4zpxw5xF7UhWdljN3JQS1+ftTu4fZCUXfhawCztvyTWYMTpJZF+AF4MSGk2COtQp+ydwp8HEjPrc+WQ1RnA6XoVZ3lRCF/tpj5+qVH0Q1PmqnhEk/c7bx3VnINOFSK74e9y/N9TCLpW8YiQs/lDJtwXq8e9d3nT38sUdR1vhYA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Oct 24 2025, Pratyush Yadav wrote:

> On Fri, Oct 24 2025, Pasha Tatashin wrote:
>
>>> > -int kho_add_subtree(struct kho_serialization *ser, const char *name, void *fdt)
>>> > +int kho_add_subtree(const char *name, void *fdt)
>>> >  {
>>> > -     int err = 0;
>>> > -     u64 phys = (u64)virt_to_phys(fdt);
>>> > -     void *root = page_to_virt(ser->fdt);
>>> > +     struct kho_sub_fdt *sub_fdt;
>>> > +     int err;
>>> >
>>> > -     err |= fdt_begin_node(root, name);
>>> > -     err |= fdt_property(root, PROP_SUB_FDT, &phys, sizeof(phys));
>>> > -     err |= fdt_end_node(root);
>>> > +     sub_fdt = kmalloc(sizeof(*sub_fdt), GFP_KERNEL);
>>> > +     if (!sub_fdt)
>>> > +             return -ENOMEM;
>>> >
>>> > -     if (err)
>>> > -             return err;
>>> > +     INIT_LIST_HEAD(&sub_fdt->l);
>>> > +     sub_fdt->name = name;
>>> > +     sub_fdt->fdt = fdt;
>>> >
>>> > -     return kho_debugfs_fdt_add(&kho_out.dbg, name, fdt, false);
>>> > +     mutex_lock(&kho_out.fdts_lock);
>>> > +     list_add_tail(&sub_fdt->l, &kho_out.sub_fdts);
>>> > +     err = kho_debugfs_fdt_add(&kho_out.dbg, name, fdt, false);
>>>
>>> I think you should remove sub_fdt from the list and kfree() it on error
>>> here. Otherwise we signal an error to the caller and they might free
>>> sub_fdt->fdt, which will later result in a use-after-free at
>>> __kho_finalize().
>>
>> I think, it is better to simply do:
>> WARN_ON_ONCE(kho_debugfs_fdt_add(...));
>> Now debugfs is optional, and there is no reason to return an error to
>> a caller if kho_debugfs_fdt_add() fails
>
> Yeah, that works too.

On a second thought, maybe pr_warn() instead of WARN_ON()? This isn't an
assertion since the debugfs creation can fail for many reasons. It isn't
expected to always succeed. So a full WARN_ON() splat seems overkill.

[...]

-- 
Regards,
Pratyush Yadav


Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E64FDC55822
	for <linux-mm@archiver.kernel.org>; Wed,  5 Aug 2026 09:26:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E54D16B00A3; Wed,  5 Aug 2026 05:26:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E2C226B00A4; Wed,  5 Aug 2026 05:26:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D42AB6B00A7; Wed,  5 Aug 2026 05:26:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id AC9836B00A3
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 05:26:53 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 1C7F040412
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 09:26:53 +0000 (UTC)
X-FDA: 85066686306.02.3A6D339
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf27.hostedemail.com (Postfix) with ESMTP id 9887940005
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 09:26:51 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=JQyTH42u;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of a.hindborg@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785922011;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ubge1xIhaMVtNlK1W4+X5SNrqz3ntDqZDTmYPkn/nf0=;
	b=4Gstspj7+8EuqdLBMCC8StY6NTukV66zWJzSVPge6q2/mlwvWgZFG0tUpaAWSaOGCflOw7
	4GNpXJ4ZtIIEsoRpiHWsrioNZ+ChUn7ZWZshMCWATZ2RvaHHAkNB+fpxrto21ezb1E5Jbg
	1dMfXmGYBH6otLqU752hR6NWbApl9zA=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=JQyTH42u;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of a.hindborg@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785922011;
	b=rzFX49jo8VTQ7mAkWIj5+WBXsDNRo7BfTAcGpKbSMncM9FJiYJegi6/TCAbufGRuR8BDMO
	TK1wK9ITRe2C35uWu5KTNLtPtxTLkSWFBKdwwS4RuByH7NC7hxO7/Qxi1vaG7svN/XoETu
	Jw4p3eWtfdqS1dVPNTZknprDmLHn/MY=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 1A7F3600B1;
	Wed,  5 Aug 2026 09:26:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 187241F00A3A;
	Wed,  5 Aug 2026 09:26:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785922010;
	bh=Ubge1xIhaMVtNlK1W4+X5SNrqz3ntDqZDTmYPkn/nf0=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date;
	b=JQyTH42uXQexz55JjOim55HIDMLIO8rx5JZA6mc0pfSqhqVsFV4t0AR1xby9i8PcZ
	 u4bljuEIXHSw4A97VrATcDzUwdrzZR6zOZYHkvM3wFgCJMC5CwS6f02Phd0buLNvqA
	 +D9nqehMXxxoccLfCQ05Fro9k0IWl4RwjxNy+cSHoS56plJjC5F/DUVgUyHZVbFMFc
	 zrekZqd2pIIvBUCihrZJ6gr9fdxZVrhVK8oZNlI2t7oIXvMKeLw8FHsCz3OV9vBsjk
	 tEeBiJq9cDNJdc3hlz+2xUCzIIAaw9Tm0baqz3Jl4gW23olatVRjxDwhgoUVEfFOzq
	 pLYXqXeWlPKcQ==
From: Andreas Hindborg <a.hindborg@kernel.org>
To: Trevor Chan <trev@trevrosa.dev>, gregkh@linuxfoundation.org,
 rafael@kernel.org, dakr@kernel.org, ojeda@kernel.org, paul@paul-moore.com,
 aliceryhl@google.com, airlied@gmail.com, simona@ffwll.ch,
 viro@zeniv.linux.org.uk, brauner@kernel.org, igor.korotin@linux.dev,
 vireshk@kernel.org, nm@ti.com, sboyd@kernel.org, m.wilczynski@samsung.com,
 boqun@kernel.org, gary@garyguo.net, axboe@kernel.dk,
 daniel.almeida@collabora.com, shankari.ak0208@gmail.com, lyude@redhat.com,
 j@jananu.net, lossin@kernel.org, acourbot@nvidia.com,
 markus.probst@posteo.de, driver-core@lists.linux.dev,
 rust-for-linux@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-block@vger.kernel.org, linux-security-module@vger.kernel.org,
 dri-devel@lists.freedesktop.org, linux-fsdevel@vger.kernel.org,
 linux-mm@kvack.org, linux-pm@vger.kernel.org, linux-pci@vger.kernel.org,
 linux-pwm@vger.kernel.org
Cc: david.m.ertman@intel.com, iweiny@kernel.org, leon@kernel.org,
 bjorn3_gh@protonmail.com, tmgross@umich.edu, tamird@kernel.org,
 work@onurozkan.dev, sergeh@kernel.org, matthew.brost@intel.com,
 thomas.hellstrom@linux.intel.com, jack@suse.cz, ljs@kernel.org,
 liam@infradead.org, bhelgaas@google.com, kwilczynski@kernel.org,
 ptikhomirov@virtuozzo.com
Subject: Re: [PATCH v6] rust: aref: make `AlwaysRefCounted::inc_ref` an
 associated function
In-Reply-To: <20260628095132.47753-1-trev@trevrosa.dev>
References: <0CoR7Z5B4-PH8GYYbWlZysVJpMnNLTFzTO0tBlOpJQNFiQ2CPrhdjyD4-4jQs4n0J_1QqovCd_EaYpclyigEKw==@protonmail.internalid>
 <20260628095132.47753-1-trev@trevrosa.dev>
Date: Wed, 05 Aug 2026 11:26:34 +0200
Message-ID: <87pkzw9aut.fsf@t14s.mail-host-address-is-not-set>
MIME-Version: 1.0
Content-Type: text/plain
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 9887940005
X-Stat-Signature: kj6fxeuwfxax3zshr48hugzjihu9effy
X-Rspam-User: 
X-HE-Tag: 1785922011-298951
X-HE-Meta: U2FsdGVkX1/OzBNFvIwn8L7lJKpOdqrOZQuTdEW5APdheNpMhaGVXBxbLZNTiHqs9L12VDmllffwOtuWgqJkNNbmRcyb3X/OTzQz9TJjOiT7N7Y4nsd95oVMD4a62hZRO88Q/vXoyXpXQZQegnjE1ulwKiyswKti1I1axDvXnKm6v9lC1HtffRsvXK1xggoDBVZqN7YQG2KdUizShqVgljs0W5E26I92SNYYdVli8fD9BYPIA4zWyfOeZx+IY3swPiHkR1qeIr1oZRJE6FnWmBbC4DXoihdfaWhmXqixg+B89US1EDfdj/qzdSPFoSNjuso/F9zbqWlhegr2itfosk0fjhc17t/K4kjIEbAwq6NGYdY0xHRjLu31U0qEJv1bGIu4LKcg8fY0B/W3UquK8MmxvD4X15JsWn6e2aVA+m5+9AjXUDDC/OYYHiWYBCeN7Omr5TjM+5N1KI/F+J5lepPlnaiC2AYThs24I92K4h+krdibYS4SkLNhrzw5IOdHc33qFRvk/RF/B+bW7PKviQkUQFfJmedSc43cgecbd7oSnCrWFoSUsyFS3Kw58ptxWfUNhGwxJGXF/L7js+uAZiqWYjdvE1BdFZldOLrasPW4Nys6++7kkGrkzPooFDT9+apyomlTx92/mNTPL1xK63+hexv58CQuijQX0tBh8CrrhSI8Xjh6p+7XLbS1CUqVjHOt+pjOy/nCjRxY6H8dNhJbnXDFUY2aTz9JdEcygR1nxFQPDIdil7CjUvY2BSnoP2YQvofwARfW8JWhx07ctEz5bD9XQvAENFW9s5nSsMaLnPPMUK9R+OiteQ3IA2bRUj5IND20yNVL9UIL21E4DIMG4aB2xp8Cu5IAkibexCKrMiITETgz/9KTBLuUDA8H1qm6RD+cWPYtYvbC+Utp0E4QGoT4vZJ7a1Rg+gdEFS9z5O/JyanfNTgWf60oXi83uNFJTdJpedn8P2he25d
 zekiZEK9
 jbLuGo9HwQQLC6FDIn6koZSdDGlrsnbhwWLaCm/k/scRzN+vccMypP+jRjWjLyo/bLhCyil9ZHFCgzekEv1ZsnN01dxN67ytTv4MI3bAJ4jAgN4K9FKftcfdZqPyfxEQ+MG+VLlwURhQr3BLvpvfZ7KxJpQBY3MnZCTYGJiZnM1Ru8R8OZQ8XaG1DrMRGZHXk2AHIuRCWZ0mjWx3wA9D8IL46CeSkIIDrFGQltJygl55FQRK6hqE4UPVLcxkj+YEUrcPxAxQTOqxvBo7QriNLk6H8JRcYQPZCUL1YR8zZ/h/0sXE/wQwoeFo+Qwc2QhArbBuNsBWBhaitKyxkRIvt/WaoDkG19TnXzCl8IHwQ29I7xIxm970uXhydsrRzaITPwKsHKJ50AjYA+0zt9mcqN4OVWfFrciO7VRFThV6TI1S/uDw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

"Trevor Chan" <trev@trevrosa.dev> writes:

> `AlwaysRefCounted::inc_ref` is a function that shouldn't be called lightly.
>
> To prevent accidentally calling it, change `inc_ref` to be an associated function.
>
> Modify all `AlwaysRefCounted` implementors to work with this change.
>
> Suggested-by: Benno Lossin <lossin@kernel.org>
> Link: https://github.com/Rust-for-Linux/linux/issues/1177
> Reviewed-by: Alice Ryhl <aliceryhl@google.com>
> Signed-off-by: Trevor Chan <trev@trevrosa.dev>

Reviewed-by: Andreas Hindborg <a.hindborg@kernel.org>

Best regards,
Andreas Hindborg




Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0C10DCDB47F
	for <linux-mm@archiver.kernel.org>; Wed, 24 Jun 2026 19:17:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E7B926B0088; Wed, 24 Jun 2026 15:17:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E535E6B008A; Wed, 24 Jun 2026 15:17:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D8FCB6B008C; Wed, 24 Jun 2026 15:17:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id BC5F66B0088
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 15:17:26 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 48FBB140210
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 19:17:26 +0000 (UTC)
X-FDA: 84915764892.09.850D182
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf24.hostedemail.com (Postfix) with ESMTP id 99B5C180010
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 19:17:24 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jipwVXQt;
	spf=pass (imf24.hostedemail.com: domain of a.hindborg@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782328644;
	b=FYYhbMkZ41qZDbR4drXRpH5y/930+OCdFPQiRPcVBeTHIUwj33ycADMTn1PP0uwIDKlzd8
	u4W+DY6+fWQsevx9fvqmuFbaHMMQvlqgZlPpNR9BX1ii3DLbC8w4ti9ozv379Rd2XleQ5f
	3GytflckCGNsIdQyk1nFHDL7QrFCNt8=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782328644;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BXTL1/pEN/FTyKPKMA8BVIZWBMRtKuw+rExm3vmkKx4=;
	b=iSWW/sBQcyDXp4KrmjxMBSqM4nLCW3r+5RoC3cgCjo/5wDw4f8jeFwI0lJds17hmtswbqv
	v7K50G31WyOUgt5t7SVowk1JQoaN2Z4A0XKeWNcXXkK6eVQPg4JW4RTpOWdbcP/T9AIfKi
	I01VS9+yTzjCPW5NJ8GOZaSl/BouO+k=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jipwVXQt;
	spf=pass (imf24.hostedemail.com: domain of a.hindborg@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 060D360018;
	Wed, 24 Jun 2026 19:17:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4DA3A1F000E9;
	Wed, 24 Jun 2026 19:17:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782328643;
	bh=BXTL1/pEN/FTyKPKMA8BVIZWBMRtKuw+rExm3vmkKx4=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date;
	b=jipwVXQtIhW9z8lFxljLcuY7oEB/LokW5tJFCYei9aG4AJZaD4IX+IkiuSVyW+9gX
	 XkAsEiaMRxjWXGmEuXVkVh28pqAoVc/aDo37K2YiiFJUxAjm2ddCHFTl9+aM661GW3
	 PE+Qcm1rb4neo7M1iuFsvHQGR9Z8jyp3VjjmJiFWU3LtteGM0CUG1TvIJmIFo9kAFC
	 4R6ORXsd+HioryjRDjvG1YfuF4t1dKBfkbIc9bDf7FTKereQM/74Au9PjcixYNzNzD
	 QYNlB8bH7PIOPQgoUBOOyXhslgfwjWS1ahCofuush0ejyBFSORKT3noH+//Lvsum9v
	 qnflbrsxJvUcA==
From: Andreas Hindborg <a.hindborg@kernel.org>
To: Onur =?utf-8?Q?=C3=96zkan?= <work@onurozkan.dev>
Cc: Miguel Ojeda <ojeda@kernel.org>, Gary Guo <gary@garyguo.net>,
 =?utf-8?Q?Bj=C3=B6rn?= Roy
 Baron <bjorn3_gh@protonmail.com>, Benno Lossin <lossin@kernel.org>, Alice
 Ryhl <aliceryhl@google.com>, Trevor Gross <tmgross@umich.edu>, Danilo
 Krummrich <dakr@kernel.org>, Greg Kroah-Hartman
 <gregkh@linuxfoundation.org>, Dave Ertman <david.m.ertman@intel.com>, Ira
 Weiny <ira.weiny@intel.com>, Leon Romanovsky <leon@kernel.org>, Paul Moore
 <paul@paul-moore.com>, Serge Hallyn <sergeh@kernel.org>, "Rafael J.
 Wysocki" <rafael@kernel.org>, David Airlie <airlied@gmail.com>, Simona
 Vetter <simona@ffwll.ch>, Alexander Viro <viro@zeniv.linux.org.uk>,
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, Daniel
 Almeida <daniel.almeida@collabora.com>, Viresh Kumar <vireshk@kernel.org>,
 Nishanth Menon <nm@ti.com>, Stephen Boyd <sboyd@kernel.org>, Bjorn Helgaas
 <bhelgaas@google.com>, Krzysztof =?utf-8?Q?Wilczy=C5=84ski?=
 <kwilczynski@kernel.org>,
 Boqun Feng <boqun@kernel.org>, Uladzislau Rezki <urezki@gmail.com>,
 Lorenzo Stoakes <ljs@kernel.org>, Vlastimil Babka <vbabka@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>, Igor Korotin
 <igor.korotin@linux.dev>, Pavel Tikhomirov <ptikhomirov@virtuozzo.com>,
 linux-kernel@vger.kernel.org, rust-for-linux@vger.kernel.org,
 linux-block@vger.kernel.org, linux-security-module@vger.kernel.org,
 dri-devel@lists.freedesktop.org, linux-fsdevel@vger.kernel.org,
 linux-mm@kvack.org, linux-pm@vger.kernel.org, linux-pci@vger.kernel.org,
 driver-core@lists.linux.dev, Oliver Mangold <oliver.mangold@pm.me>, Viresh
 Kumar <viresh.kumar@linaro.org>
Subject: Re: [PATCH v17 06/10] rust: rename `AlwaysRefCounted` to `RefCounted`.
In-Reply-To: <20260623175814.87191-1-work@onurozkan.dev>
References: <20260604-unique-ref-v17-0-7b4c3d2930b9@kernel.org>
 <20260604-unique-ref-v17-6-7b4c3d2930b9@kernel.org>
 <20260623175814.87191-1-work@onurozkan.dev>
Date: Wed, 24 Jun 2026 21:17:08 +0200
Message-ID: <87cxxfiw97.fsf@t14s.mail-host-address-is-not-set>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 99B5C180010
X-Stat-Signature: auij8q6gunsq4nxcsxowqs6md57rjp3x
X-HE-Tag: 1782328644-621559
X-HE-Meta: U2FsdGVkX18MgVk7WRghXLSMNGOfQsBF27oBfuSWzh8FsJy716NbESAh+vU/ZPsZsvPv+n1riQF2RRGcIxAUsYQro8KUl7Bae2lAByagVDoBnAHhND2HC5cimUwsBDXy17xFimefDWASDho8BfpBcvVlDxGHxdNooaXCSGo6bQGmFunewIm59Q7bBT0+nqjBBsgjY9IKWZZEtXkOXCgPiqZSxjQUOKmJje0tLxIi8bgRKgO4luSfT676PwZMhrINN3iUOQDwHTBmEg1Z0WKjYf7qv/6PCZeqly7HbD2HPgMBrhw/16Bnr2K/KAFGTJjBz2b1AB33sdxrfupKKOtTRqbGvgfo8YksW2KOEliTLIi4jL7qiYPURco8Kc98t4mIf3D29bdXu89bfFgyb4ckDKj8ed7H1xSq0FjwUPgQ1sMntc4W6dDS865m5qqeSKtXE00l+cxuOJJS9Rz92TWMsyXkay8WYk1Kq3FGZRXUY5oNQ7GNp/bm5HxcD4ACmEkbMn1BQ3vhr/e9wS/EjkKqqyI2o1x5GZQt763yJNXtx5CvDbjoxBR/yBNHOJjnxIKH62fglDPvEK1o9rpiNMuvnlH4NipBHhFgxVxccfuPKNiUICDIBY5ZwI/vjzoUWvkmVMxZNvcpiFog6J7lpoS2RpZn8lpLFStOd1uQafwZnIHBObXmZZv0NW2Zpipb0CHGLwJTuHWzOPCH9QHSkCx8iN4v0MTQYRjT3Uuz346Y1+EHXh2LOj0fkdTA6qNRV58SMHVwGA4evYqEkSA/D2Ypm8ok0O9QWeV8I/T8k2/EOuUQ+VwS7jOzHtIA3bEkwZmEk7LoUDFu1/qMXXVKGQy5dppTS3fUFYUY+u6hLhHpLfpdxPDoR/YNQXRo938kcE8cvSiReAKSqWJJzm7dTdjbsQPUdGZwd10X6XQ74bPxsGn9z7NDqUKiRMhqrGEcTA6dG1Ud+FH/78YbmlmTRRg
 jg5f10+j
 zhWbhp7sqDNSMZxfiUH8N/S+CA6Uhrry9+OU+UyaqIxB7ZoJIU++v3l5d9MkYd04lxDboFRe47mUOkU+7ht4VbgvqGIymngjx/G69rGbBwjw/ipQNB4kmu0SV1VCgY6S+2Zz+hd+1gNi9hfXA7YsHJom2UhX0Jn2EamI+KX3n3oumSH85PhC6aMuMyLVKIG15oWM4LzaJH1Fd0Y+X5Va/08za7hGvLK750/KpOGyUwOrYdiMU7eXAPCivKC2f8bHcS1CAqyHXabLUC6ZxIeH5FYMEgu7XW3/RZObuCRCr1LT0Zt7j/7sdhfCq5bIvawVVuFdCym0xNRVxFP9lJkahiOkB3FozwM1AlXeJ2GChnWtwjGWa940y2ZdY0+T+DdEI2uHT9x0v6SWoPdKZWvkaXxFr4GqmUMGtivSM4jQ3MudQAGb2tq+d2Y+xZMuiYc8cWarXpGNz5LVsWZaUW8exWq7l1w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Onur =C3=96zkan <work@onurozkan.dev> writes:

> On Thu, 04 Jun 2026 22:11:18 +0200
> Andreas Hindborg <a.hindborg@kernel.org> wrote:
>
>> From: Oliver Mangold <oliver.mangold@pm.me>
>>=20
>> There are types where it may both be reference counted in some cases and
>> owned in others. In such cases, obtaining `ARef<T>` from `&T` would be
>> unsound as it allows creation of `ARef<T>` copy from `&Owned<T>`.
>>=20
>> Therefore, we split `AlwaysRefCounted` into `RefCounted` (which `ARef<T>`
>> would require) and a marker trait to indicate that the type is always
>> reference counted (and not `Ownable`) so the `&T` -> `ARef<T>` conversion
>> is possible.
>>=20
>> - Rename `AlwaysRefCounted` to `RefCounted`.
>> - Add a new unsafe trait `AlwaysRefCounted`.
>> - Implement the new trait `AlwaysRefCounted` for the newly renamed
>>   `RefCounted` implementations. This leaves functionality of existing
>>   implementers of `AlwaysRefCounted` intact.
>>=20
>> Suggested-by: Alice Ryhl <aliceryhl@google.com>
>> Reviewed-by: Daniel Almeida <daniel.almeida@collabora.com>
>> Signed-off-by: Oliver Mangold <oliver.mangold@pm.me>
>> [ Andreas: Updated commit message and rebase on rust-6.20-7.0 ]
>> Acked-by: Igor Korotin <igor.korotin.linux@gmail.com>
>> Acked-by: Danilo Krummrich <dakr@kernel.org>
>> Acked-by: Viresh Kumar <viresh.kumar@linaro.org>
>> Reviewed-by: Gary Guo <gary@garyguo.net>
>> Co-developed-by: Andreas Hindborg <a.hindborg@kernel.org>
>> Signed-off-by: Andreas Hindborg <a.hindborg@kernel.org>
>> ---
>>  rust/kernel/auxiliary.rs        |  7 +++++-
>>  rust/kernel/block/mq/request.rs | 15 ++++++++-----
>>  rust/kernel/cred.rs             | 13 +++++++++--
>>  rust/kernel/device.rs           | 12 ++++++++--
>>  rust/kernel/device/property.rs  | 11 +++++++--
>>  rust/kernel/drm/device.rs       |  9 ++++++--
>>  rust/kernel/drm/gem/mod.rs      | 16 ++++++++++----
>>  rust/kernel/fs/file.rs          | 16 ++++++++++----
>>  rust/kernel/i2c.rs              | 13 ++++++++---
>>  rust/kernel/mm.rs               | 15 +++++++++----
>>  rust/kernel/mm/mmput_async.rs   |  9 ++++++--
>>  rust/kernel/opp.rs              | 10 ++++++---
>>  rust/kernel/owned.rs            |  2 +-
>>  rust/kernel/pci.rs              | 10 ++++++++-
>>  rust/kernel/pid_namespace.rs    | 12 ++++++++--
>>  rust/kernel/platform.rs         |  7 +++++-
>>  rust/kernel/sync/aref.rs        | 49 ++++++++++++++++++++++++++--------=
-------
>>  rust/kernel/task.rs             | 13 +++++++++--
>>  rust/kernel/types.rs            |  3 ++-
>>  rust/kernel/usb.rs              | 17 +++++++++++---
>>  20 files changed, 195 insertions(+), 64 deletions(-)
>>=20
>> diff --git a/rust/kernel/auxiliary.rs b/rust/kernel/auxiliary.rs
>> index 93c0db1f6655..49f07740f657 100644
>> --- a/rust/kernel/auxiliary.rs
>> +++ b/rust/kernel/auxiliary.rs
>> @@ -19,6 +19,7 @@
>>          to_result, //
>>      },
>>      prelude::*,
>> +    sync::aref::{AlwaysRefCounted, RefCounted},
>
> This patch has multiple horizontal use statements around.

Thanks, I'll take another pass to fix that.


Best regards,
Andreas Hindborg





Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EB57FC88E53
	for <linux-mm@archiver.kernel.org>; Tue, 15 Sep 2026 11:55:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0C4FA6B00BA; Tue, 15 Sep 2026 07:55:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 09D386B00BB; Tue, 15 Sep 2026 07:55:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EF6F36B00BC; Tue, 15 Sep 2026 07:55:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id C38BB6B00BA
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 07:55:08 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 5371AC03B4
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 11:55:08 +0000 (UTC)
X-FDA: 85215840696.26.47CD183
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf23.hostedemail.com (Postfix) with ESMTP id A888314000A
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 11:55:06 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ZuWOcXAx;
	spf=pass (imf23.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789473306;
	b=h45A45SJqla1Jqfz+PM/U+DI3AlEHdV+/65jE137SXI0qA357DY4To1NB3E4FoJg0Ljxci
	nm7qG7zz6ai762Ktd4aF/OPNBHIGcDCJG2qIEc12QJPIYggZvAUvOX31phb91fQ7P1jeHh
	cb/mU0ewbXSWm8Zk+GZjZM6kz3n9rEI=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ZuWOcXAx;
	spf=pass (imf23.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789473306;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=z5q8YTazTS0g58MAO23KPqH00t77+r0Qm1szy+uSGx8=;
	b=q+8w1h5Zww6NR1leeiQXab691P3BjV0Pucs3uAU/Vjxk/mv3Hwqmj8zRdwQNF3ldb7e8Am
	EenbhLYP6YaWwZ11hVw4Esoi7cto0AF1MUKaVGiChe3/3n+3JaJPcECGMU30iunKD+6lxd
	JWFbKDIb8kNkVCVXMupsrz1eXAcrJCs=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 05F6A44503;
	Tue, 15 Sep 2026 11:55:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 148F91F00893;
	Tue, 15 Sep 2026 11:55:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789473305;
	bh=z5q8YTazTS0g58MAO23KPqH00t77+r0Qm1szy+uSGx8=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=ZuWOcXAxSUf8U369yMDLM5CrTH3NJo6vFF48Zf7qsB7e9dLLAU7rmbvFKGtSwEN54
	 mrXyu8/sUo7qSyMhvbEGo+56h3zo92SZrUdXQDVHKmZsSL1yip9FieQwDFx3xFr6W4
	 tBOqKBhe78D3RbDLNy/MZGAQn79PhMCfv5ZbZLoxyQiJCVFGpeYe2T3W8SPiGli1OE
	 NJ9s1R/i1hoZ9yPqcd3D1GgTWMiPLPMS4hdNI6X7OCZH/p2PAhMdHWisK0u0w1/QXC
	 YOxwO8oP0q6Czx2WnOyHnYHMCetkSnm/+kFJHxdJpz1jYA9qFglwCwZ6hc4JzfujT3
	 h2LUQd6qFe6SA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH RFC POC 01/50] file: install files on syscall exit
Reply-To: sashiko-reviews@lists.linux.dev
To: "Linus Torvalds" <torvalds@linux-foundation.org>, "Christian Brauner" <brauner@kernel.org>
Cc: linux-fsdevel@vger.kernel.org, linux-m68k@lists.linux-m68k.org, linux-kernel@vger.kernel.org, linux-snps-arc@lists.infradead.org, kvm@vger.kernel.org, bpf@vger.kernel.org, io-uring@vger.kernel.org, linux-alpha@vger.kernel.org, kexec@lists.infradead.org, "Jens
 Axboe" <axboe@kernel.dk>, "Michael S. Tsirkin" <mst@redhat.com>, dri-devel@lists.freedesktop.org, sparclinux@vger.kernel.org, linux-parisc@vger.kernel.org, linux-mm@kvack.org, linux-openrisc@vger.kernel.org, linux-gpio@vger.kernel.org, linux-arm-msm@vger.kernel.org, linux-hexagon@vger.kernel.org, "Jann
 Horn" <jannh@google.com>, "Ingo Molnar" <mingo@redhat.com>, "Oleg Nesterov" <oleg@redhat.com>, "David
 Airlie" <airlied@redhat.com>, "Eugenio Perez" <eperezma@redhat.com>, linux-csky@vger.kernel.org, "Alexander
 Viro" <viro@zeniv.linux.org.uk>, linux-mips@vger.kernel.org, linux-um@lists.infradead.org, linuxppc-dev@lists.ozlabs.org, "Peter
 Zijlstra" <peterz@infradead.org>, virtualization@lists.linux.dev, "Jan Kara" <jack@suse.cz>, linux-hyperv@vger.kernel.org, linux-sh@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 =?utf-8?b?Q2hyaXN0aWFuIEJyYXVuZXIgKEFtdXRhYmxlKQ==?= <brauner@kernel.org>
In-Reply-To: <20260915-work-fd-reserve-unify-folded-v1-1-4d5217d6b246@kernel.org>
References: <20260915-work-fd-reserve-unify-folded-v1-0-4d5217d6b246@kernel.org>
 <20260915-work-fd-reserve-unify-folded-v1-1-4d5217d6b246@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 15 Sep 2026 11:55:03 +0000
Message-Id: <20260915115504.148F91F00893@smtp.kernel.org>
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: A888314000A
X-Rspam-User: 
X-Stat-Signature: 5gz1kqnxybuamyxk44u6un14pdkt39ga
X-HE-Tag: 1789473306-649456
X-HE-Meta: U2FsdGVkX1/HlEtmiEcu2Miu1TR5sh9N45knMuJnVQdMLd3rN4ETJ1wQdYzpmcZvdv8E1Oo7b6Sc7UzzP79tM0FNXj7nYMxaeYG/FwEfr9YSN7XABpBDhn+1ohHoY/NaS0dzAda6PtezoHBOmmHhagQAANGFZ0NY017/MsDWbHBU7bRbCTz4f5Yk0RQOqPgwDNI5Gsld9NcisG2UDZ+pJiMSc3nhpF7YzK2VOaEbXvtbBGWAtGqIJWFOtWjEuk2nspUH2XMuCMJA5qkEJzQgRwNongyjbes+Drz90D/VzRhW07GswmT0pPFX2OCCjHMzXkNMzBIWNPfzRJLmi6CQ+UdxMDoJXeC3s1n0wXUPP4UQTLrNhime7FKHVngxC2NAw1OjH659oLYqo3OyQLz0xpCWwHWzM0wsyE+nTBp4Ugswz8dcOnYfNr7Vn6N60qtq/KyW5jCgrt+sFFb7JKAW4mAIx9Z3MHoxajMGofjaaihqWuU5re2+4B9/Hxo1HJf3foTWY7FUMUHfXg2BXO5SUHnxO5T34Zav1h44nJ+14XhV36Viqab/sMJNGQdR4UGMtK37lliqI6b1KkaBTLgdTOkL1JFTKJRpzcyQ5RAYKuzug7hjBLbRzK1W36jx2n6e2aVipHwFZRUHsT/AW8m2YCwy9s6rj59/2SA8VeV0rlQkzKAzj6SjnnhPlMAlCcHl25I/JSqiVwupYV6s5Dh3xBfEJ+I9VJE7ANFiye/C3IRUD/OpohjVLEF8uxEk8lY3CEyJ9ye3I1OI1ewcaqwdJtGhRWBOu2v/0Upk2yzhRivap1eERey666bALqOrwYpv+o6OtLJrwbu8jj+WydE5Ew2LH4tnmY4EzHg0iPYFKOtiBNv870+80EBDwvOMGnCswRD71EHEKMeMfeW7RJzkSqCdsPbxItQlQGcKxUooQHf00ZZRb8xqafo4+2p9Z1JDc+mJeY8zIeBphxlRfpf
 xw25Byr1
 PXaWJAensT+aHY/4KRjTbMvjc5PGk5tC3M+XrREl0II+FPrqI2B/Pi9F6ytmTbB9iAqthDyRUImlwwh7imy5Los7r/hdafP6UZ8uAvVctKiBGJf7BeuS3RZ/1ZseutY2YHWPcuoSjqP4lRrHgvNwnp1DdSG/v5D10STFliXOnz3VBTNkOYcZ7hgQ4B4F3ad4GywwQmBh6AjkS9QxcDi/ARj6v3r83smys5GdIjeh+8//gfdN1JUdabCaism3k+9Grdo1oczc/J/h5mGHsktP5ILD+VX0bojXteuap0QvFtoY1+X22zMHz7S6It4U9TjWo2arYIc5KfytxdV3t8ezNOqov+G4rgGFp27AenMtNThCfUoh9AIPUIjsmI1JVfQnZbh9oaPXC8WpmI5B8CSbUsr4RkSepqLzrfxmXeB1PwFjCESwJU+hCf841zMFibaSvjERxgiQDqHgRRi4QPcg8xvosZb9MDa/MH/0y1bWWczxFo7VY+Lh6T4qU0LzdeQpx3t72O0nN4dF/j6u09vyRyYcnT1tstYUNaMbCAcP+5eRIdW3yWM8QHNKaYvhV49Jv8/2ands4Sd1Kwr+YVPiN0x1OOhtE+CnE+/7KPgVyMhF0wHp92/SNpHXJTu04Kt3eeD3DyGnbahsU0ukEvTQchpYH0idzdOxG3uVGLgokwCtW22U=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> So we've spoken about this idea quite a few times over the years that
> we could reserve fds and files on a task and then install or a clean
> them up on syscall success or error and get rid of most of the
> complicated cleanup dance that we have.
>=20
> My original approach to this had been to implement FD_PREPARE() based on
> cleanup guards and use scopes to make this happen. The other idea was
> what I'm illustrating here. It is overall equally robust and makes the
> install fd and file pattern work even if it there's a ton of cleanup or
> setup work happening in the middle. This is particular evident in the
> conversions of various dma/drm code later in the series.
>=20
> So this lets the syscall path do the install. fd_prepare() allocates a
> descriptor like get_unused_fd_flags() does and records it in a slot on
> the task. fd_stage() attaches the file to that slot and returns the
> [ ... ]
> fdtagble with outstanding reservations. Kernel threads never return to
> userspace so nothing would commit. Anything left at exit is a bug and
> gets warned about and dropped.
>=20
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260915-work-fd-re=
serve-unify-folded-v1-0-4d5217d6b246@kernel.org?part=3D1



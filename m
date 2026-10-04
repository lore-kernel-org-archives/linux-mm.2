Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BC55DCA5FE6
	for <linux-mm@archiver.kernel.org>; Sun,  4 Oct 2026 17:21:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A38D36B008A; Sun,  4 Oct 2026 13:21:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9E9256B008C; Sun,  4 Oct 2026 13:21:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 926336B0092; Sun,  4 Oct 2026 13:21:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 6DDBC6B008A
	for <linux-mm@kvack.org>; Sun,  4 Oct 2026 13:21:16 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id D67391A0B94
	for <linux-mm@kvack.org>; Sun,  4 Oct 2026 17:21:15 +0000 (UTC)
X-FDA: 85285609710.24.256EE76
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf01.hostedemail.com (Postfix) with ESMTP id 4F67E40005
	for <linux-mm@kvack.org>; Sun,  4 Oct 2026 17:21:14 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=dRc8M5K5;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791134474;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5DHJ05YuSaH+xr8cKdC4cMoW1ZLSjTRGXK11CvcxzcE=;
	b=EGrlBPOZhlN1BUK2d5lIDdqg+tnboStvF/K3pveRwoQur5PVT1NnsU/l/fK4kD+DfQTNRS
	CVXJj54AFD3CtkS8RtrSSU1qUkXumSG57J1opoF47/jq610YtXv7DaypoEi2+1Cr3rpIOb
	MCubNny1Plcs8jSDl10xOaMeDP+jDrE=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=dRc8M5K5;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791134474;
	b=CFS+s8xWy57a3rSlaB8n14j48oYvJP8DutNKppdw+kH4tOdV3t6UoOZYqS0WsNLPhkSVbC
	iVWaCnvDA3sZSaOrttEmrAUQiAmQm8RpzdyLS7q2CpLb4VCZHoG6/aWmk1aBkTH5Uipat/
	/tKQeU8DczIU9YwxfodsYBVuK+hMrjA=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id DA47A60120;
	Sun,  4 Oct 2026 17:21:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D536B1F000FF;
	Sun,  4 Oct 2026 17:21:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791134473;
	bh=5DHJ05YuSaH+xr8cKdC4cMoW1ZLSjTRGXK11CvcxzcE=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date;
	b=dRc8M5K5uZMZIVGAAwj7Y7uhyYSUbAcWbnq+NtuV/keIDnxjDLhJJIcmxQIkLoCzR
	 33+SxYgjWcYH8y9a1+FKiwzTMFn5drCn7RebxPcOa+PMlUQkU4D7xznSJc25AQfrWJ
	 I0I5UYHGbP/vnztJHoPEcqicUXsjX2zH8/9PJTh6ZS7/oO/40JhyTmNxxgwQ/6PKVA
	 tIF9Nu0lWRhVXfnXJUCP49MXSlKlYbsmKS6w9TY6oKunJkslNtsNgrLS1bBdnP7QVD
	 1SE6+4jXIwIl5NSkUaDznyxrjDrCo33BvokSYO2oeVm86q/I6+pirNn5xN3BNE6URC
	 2mW0Jacr6qckA==
From: Pratyush Yadav <pratyush@kernel.org>
To: Samiullah Khawaja <skhawaja@google.com>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>,  Mike Rapoport
 <rppt@kernel.org>,  Pratyush Yadav <pratyush@kernel.org>,  Alexander Graf
 <graf@amazon.com>,  David Matlack <dmatlack@google.com>,
  tarunsahu@google.com,  open list <linux-kernel@vger.kernel.org>,  "open
 list:KEXEC HANDOVER (KHO)" <kexec@lists.infradead.org>,  "open list:KEXEC
 HANDOVER (KHO)" <linux-mm@kvack.org>
Subject: Re: [RFC PATCH 0/6] Introduce file handler dependency level
In-Reply-To: <20261001005734.1033516-1-skhawaja@google.com> (Samiullah
	Khawaja's message of "Thu, 1 Oct 2026 00:57:28 +0000")
References: <20261001005734.1033516-1-skhawaja@google.com>
Date: Sun, 04 Oct 2026 19:21:10 +0200
Message-ID: <2vxz4if1l6ux.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain
X-Stat-Signature: jy6hq9e17za4wkh6b9hx667iwm66gfue
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 4F67E40005
X-HE-Tag: 1791134474-224515
X-HE-Meta: U2FsdGVkX1+FLKbnezqOCfA82tbuFcOrDAuuHMED8BJX4L5zbZmfzEo+h0tj0OS0BXL/zHVHd/urPTUL53akTf/Okww4IiGfTpWi1+62KATY35ZLLIlpq6lAfnI6U0LHp+B4aaQsy7m2I0bOEi58ey6DPpfU4zlcXy6SozQK4qwTlF/AUhtQnSX6Y1sKTh7G4NS9hRfZNXWWbRlunvvPrClI37SeE6gJZwUXOi9Lmxp6jLXoJW+tT2mHNduqnRpgQlq28eXjJ3BtYzFRVpf0PUxXcrzqG11xRRgvpC3hhEWf4TNEypZasNbxDsAtTJmhcNuV09xl9lgpgZQh1t/sINq7Gb9q/H8GlwWKyfbmpZeqlUUPydKIZrfUfNqiUVedi/kDCz8wuZ4+8bXxY1N7v53prfKfCFxpRK8heRA5VMjt1jlSDnRIE9WZu6mNOzH2Ua6pYkTEGJBXjlHsUJfit/mFXLn4/lE4E7smsHxstrIZoyi5E9vOcVmxrqpTZUxeySrp6+PywPXmn+U72/HYD1iyf15vesc7z9xdEdu2VAL5OENmm7BahK/WcLE2xxFAhcCTh4zg1m8WgCpaL6j8m8hfiLIVYhBU7o72cScK6Zm5fF+xHhUvuthOYUJ3s9EueIqbne3Q78jAqTDLYP3USVPg/p1aHAEpW3l6FX/oWtXPC/W4w5D8dSgLcDNDSzqg9YoPQt+hAOhZEKoPg0D4Uusx8LoU1B4PkfQ+7CFCBbbgWtuw4ievWcfou25x3k+CBqcZjvB3mgLsS9Vg8wHH+mTxDQ6162C+hcseQJ8IC4MK0/OpG5RogQyUKgwREO6JAuKgUvpFDBQ7isvqS93ZplYQxto1ZlcGocOnXlfZH9+DKfXcgEBSGlDy2/c118bVOlce7MppWAIopeJl66XGJFfCaXC50FmJhTcLm9QG5nVW7XGtod/HUaKei6JTtPm/z6UZjcipgA+23pSE3wr
 alGzQqw3
 cwONb+C7/EkK3ApQemhSkhNk7y8BxxWKx1otZcin2+hiCZyOu73FNKKT3+JcNmT+o4bCy7jyJ6ArnjWt7CLlrzs99yMFfHddfjRo8vTjoDUZhi/4oHjbAGuvxwF2++qlJz3YP5WRMOFQbd8SLAYt+YOQsYBRasxA7cQdzuZewLzJRzHy8nq9sDu4nMjH29MahqzNL6Qol5bUQs6D84p93ChAA8goZCc6sTNBIKL+tyJNXnzba4k6EGV16gA3wKF1a1zZJy/s4eaO/M0xx/kK7WOpBnA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Sami,

I've skimmed the patches. I didn't dive too deep into the code, but here
is at least my first reaction.

On Thu, Oct 01 2026, Samiullah Khawaja wrote:

> LUO allows preservation of FDs into sessions. An FD can depend on other
> FDs, and for some FDs this can mean the dependency must be preserved
> before it due to various reasons including immutability and performance.
> See discussion on FD dependency patch series [1] and documentation [2]
> for details. Also see the Liveupdate IOMMU [3] and guest_memfd
> preservation [4] patch series for examples. These dependencies are
> enforced by the file handlers, and userspace is responsible for
> preserving the FDs in the correct order.
>
> This RFC proposes a mechanism that allows userspace to preserve the FDs
> as a batch, and the kernel preserves them in the required order. This
> allows the VMM to preserve a bag of FDs without worrying about the
> order. A new ioctl is added that allows userspace to provide an array of
> FDs and tokens for preservation. This gives the kernel the token and the
> intent to preserve every FD in the batch up front.
>
> This RFC introduces the concept of file handler levels. Each file
> handler offers a certain type of resource or functionality that relates
> to other file handlers. These can be represented by levels. This RFC
> adds the following levels and more can be added later:
>
>  - Default (no level set)
>  - Memory Providers
>  - Memory Mappers (or users)
>  - Devices
>
> The levels are optional static configurations of how the file handlers
> relate to each other. Each level represents a class of file handler,
> which fixes the order of preservation between them.
>
> The levels are spaced out to allow addition of new levels. LUO can use
> these levels to deduce the order of preservation of a batch of FDs.

I think you need to explain what problem you actually solve here.

This seems like a lot of complexity to essentially turn file handler
dependencies into heuristics. Because you basically assign a "priority
number" to each file type. But dependencies can really be complicated
and I think modelling them as absolute integers is going to paint us in
a corner real quick.

And I don't get what this buys us. Why not take the much much simpler
path where a file handler just rejects a file if its dependency isn't
there? This would force userspace to preserve files in the right order.

And userspace doesn't necessarily have to to anything complicated
either. It just needs to write the code in a way that a memfd is
preserved before its iommufd. So we leave it up to userspace to figure
out the order, and in the kernel we only _enforce_ it.

This also lets us express the real dependencies and we don't have to do
the dance of giving each file type a number and trying to make sure the
number sits in the right place on the list for all use cases.

Or, if you _don't_ want to burden userspace with this work, why not take
the files in any order and do the final check at freeze()?

>
> The batch is atomic: either all FDs are preserved or none are, and on
> failure the index of the failing FD is returned to userspace. The
> existing LIVEUPDATE_SESSION_PRESERVE_FD ioctl is unchanged and behaves
> as a batch of one. Note that this does not break compatibility and
> userspace can still attempt to preserve FDs individually using the
> existing preservation ioctl.
>
> The patch series builds on top of the Liveupdate IOMMU series [3] to
> demonstrate the FD dependency. The full tree, including the
> dependencies, is available at:
> https://github.com/samikhawaja/linux/tree/luo/fd-dependency-rfc
>
> I will present this at the Live Update MC at LPC 2026. I will also talk
> about alternative solutions I considered.
>
> Future work:
>
>  - Allow file handlers to be preserved at multiple levels to allow
>    resolving circular dependencies.
>
> Looking forward to your feedback on this.
>
> [1] https://lore.kernel.org/all/alrDpAMknlYN9jL9@google.com/#t
> [2] https://lore.kernel.org/all/20260910173659.1945246-2-skhawaja@google.com/
> [3] https://lore.kernel.org/all/20260921004834.2601285-1-skhawaja@google.com/
> [4] https://lore.kernel.org/all/20260728121138.1103610-9-tarunsahu@google.com/
>
> Samiullah Khawaja (6):
>   liveupdate: Introduce file handler dependency level
>   mm/memfd_luo: Set Liveupdate level of a memfd file handler
>   iommufd: Set liveupdate file handler level
>   vfio/pci: Set live update file handler level
>   selftests/liveupdate: Add API to preserve a batch of FDs
>   iommufd/selftests: Preserve all the FDs in a batch
>
>  drivers/iommu/iommufd/liveupdate.c            |   1 +
>  drivers/vfio/pci/vfio_pci_liveupdate.c        |   1 +
>  include/linux/liveupdate.h                    |  24 ++
>  include/uapi/linux/liveupdate.h               |  39 +++
>  kernel/liveupdate/luo_file.c                  | 316 ++++++++++++------
>  kernel/liveupdate/luo_internal.h              |   2 +
>  kernel/liveupdate/luo_session.c               |  45 +++
>  mm/memfd_luo.c                                |   1 +
>  .../iommu/iommufd_liveupdate_kexec_test.c     |  27 +-
>  .../liveupdate/lib/include/libliveupdate.h    |   2 +
>  .../selftests/liveupdate/lib/lu_utils.c       |  20 ++
>  11 files changed, 379 insertions(+), 99 deletions(-)
>
>
> base-commit: 945d61765894dda2f0344de50cb1ade2e51b66fd

-- 
Regards,
Pratyush Yadav


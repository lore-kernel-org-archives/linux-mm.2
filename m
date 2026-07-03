Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 813BBC43602
	for <linux-mm@archiver.kernel.org>; Fri,  3 Jul 2026 16:28:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 108406B00B5; Fri,  3 Jul 2026 12:28:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 092336B00B6; Fri,  3 Jul 2026 12:28:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EC3FC6B00B7; Fri,  3 Jul 2026 12:28:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id BE9176B00B5
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 12:28:33 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 38D23C1143
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 16:28:33 +0000 (UTC)
X-FDA: 84947998506.13.F484BD2
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf12.hostedemail.com (Postfix) with ESMTP id 3C3FD40006
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 16:28:31 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b="gF2WbR/W";
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf12.hostedemail.com: domain of catalin.marinas@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=catalin.marinas@arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783096111;
	b=QC6zZDSGw6loj3neLulpLf1BggTgWeXnJyR+PfWBW7TKYP013Tzy148bqc/jiuqdX+Giij
	hADiCWwGmPT1cHSxUwdCf2tDW/Ux4BXTaKoSU2uZejPCQbrRTEPhuvZUZgveDWQOxRsIvn
	Z2zghrun4l4quop5vS4SfkYb5377bbo=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783096111;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hE1esvXYdfizQGHxS8HoUjMArMC+DaamFQ0LitcTbU4=;
	b=A6nZcNmCl4ljAe28bDRkQzl96mFjp+X04LZHH1sTTcZgSYGY4xA28o9CdVW2kfRVRlTD0d
	G9UnC5SwLUAfick+9gIh+fvOoly8/JzYbUVryhxaPSewWTyIIcw+wF8jHxF8du4mNI96GA
	o/LuaTNJpqMseCc06Tn4DJCVOyiwliQ=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b="gF2WbR/W";
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf12.hostedemail.com: domain of catalin.marinas@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=catalin.marinas@arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id E5DA71E7D;
	Fri,  3 Jul 2026 09:28:25 -0700 (PDT)
Received: from arm.com (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 24F493F905;
	Fri,  3 Jul 2026 09:28:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1783096110; bh=hcr/VLRoB6bOL7od2RJpsiqly4sCMoyU4iz0d/lMjTE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=gF2WbR/Wf9hS09+xZK6JhcHHu6PbPN2K9KD3T4cUGcy8JE3xadOOPtFQtuNps/yF9
	 aCFHuItvlieixXf9raOV51gLR8iJtvOC9FPqO8FM2wzEi9bUbGiItUJzFGPJxQqU9m
	 L9sWLC1odQPoLYqPu8x0KiZEzsCEQiJf6+gfRvyw=
Date: Fri, 3 Jul 2026 17:28:26 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Breno Leitao <leitao@debian.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Pavel Tikhomirov <ptikhomirov@virtuozzo.com>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, kernel-team@meta.com,
	stable@vger.kernel.org
Subject: Re: [PATCH] mm/kmemleak: fix checksum computation for per-cpu objects
Message-ID: <akfjKpv838nqsl78@arm.com>
References: <20260703-kmemleak_checksum-v1-1-5e0ab7d6966f@debian.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260703-kmemleak_checksum-v1-1-5e0ab7d6966f@debian.org>
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: tju6rn7h61rcxia6oszwjdot1onz134n
X-Rspamd-Queue-Id: 3C3FD40006
X-HE-Tag: 1783096111-21639
X-HE-Meta: U2FsdGVkX19f2BP3cvBUfZ03VUqP536ERsCvzMmUVWiUKDVV3pXPzzjU5fulIj84rIdNutFsG8bQ5vJ6gcW/s+fHU6FHbj0jhVgmr1bGsQOCx+gLQ1HDf5ejD2nPSXDC8Aee+x70NtYgZaZrnPA7bIg3eLBqdLMTJNIbvQyttNX0aJG5lmZCDlmhTC2fpqfDsWKfVXtfQRLKLPpzZRzGR4y1SDNILu+diDxtwx6KNkbbdqAz1iOFbuDbDF4m04Lc7MScwYJtHQKYsqSx89l8Z1HbqzqRVBgc7wxPaHSuahb3CfGpzd3Eop3xqIf5zZSzlcfBoUHLZxxjlEjZzSiyJ45hYYHZ/Vtvrt8ho7A+ZjONbVysPbVkfT986HqonpIozFQXi8Uej0qH8kQoab3kpZmu00us0ic7UDkD0fPiF7kLlO4W9iOwFQHqlRYnkEDq0kmngFkg+rIrFOmd4SULmZTc92tR2MbLoln6hvr6WUmdmYiuvSGss4JFKIVBNo+rEucPj0YcuCmj5VV8YlS7PwCVzGYMAR95Owx5/hg/5X2bxrUqks8ivcoMqhKP0rV6tTHrRxVNamdM7IivyWMte9YP6lHQXuErDKQWpRY4qrmQ1T39JQVfEzcq58WA/Zh6L9tZzGzCEueTyROVBGX0EeosRecx+JklzTbVLNXmklUUWROwPCqalrplGpJFFv9sAZpDZxQtPy5GO9R5JWy044xU+rW+hSVRq9VlC8EZyqfq+RsAilMnmhsvyPQok/hVFqdoxlC/9cedTkFKd3TD0yNj/rUfzTWtYFQysOlNBBb6Id5jUVqrFMQqlYbqC515GXS0QQj/79I50EiWLDoh+eip9uNwjvcdQuVIStioMZcdHlhR6rf9+DwWtzK7y5hKa+5UGr/NGxmTzsNgJDMnDvcEuU9Y44v9kiQPakhEjpP8fmVhCMJhuAAMPnf5GfdCtr9+4YQ9xymCD5GBQFt
 gRCbpB3f
 gDoULK26VhlRnNpbdx3bW76Q8Dk0lowWkYs2GtPb5v4CSKYL9UnJMsW/U3K/iA13rdvY9gbc60CLW/qteT2A+WmBz8YD00PJWd2YJo/G7e3lq6Ry8grv5r808cuNsmWLC7GVyCc6qMke7yQYi30OyD77E7QOso1WaFLuk2PTpTDkKkUNs60tmVJ6kpzE2FTuo6J2YeqHgUk51RJeKlC1MNo+DxeYT6o/V25wxWhSigX+d/JrC7bk+8SkDtk9Z5oIi6sIkUJGdr8STCm0k00auiE/g6SKRMKH6ySDwT5icV96svZ1epN0Q4wcdFH7led675nfO5oIU34BU8Z2clbVJV+be8A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jul 03, 2026 at 09:17:24AM -0700, Breno Leitao wrote:
> The per-cpu object checksum folds each CPU's CRC together with XOR and
> seeds every CRC with 0. Both choices make update_checksum() miss content
> changes:
> 
>   - XOR is self-cancelling, so equal contents on two CPUs cancel out and
>     simultaneous identical changes leave the checksum unchanged.
>   - crc32(0, ...) over all-zero content is 0, so a freshly allocated,
>     zeroed per-cpu area checksums to 0, matching the initial value, and
>     the object is never seen to change.
> 
> See discussions at [0].
> 
> When update_checksum() wrongly reports an actively modified object as
> unchanged, kmemleak stops greying it for an extra scan and can report a
> live per-cpu object as a leak.
> 
> Fold the per-cpu CRC as a single rolling checksum across all CPUs and
> initialise the object checksum to ~0 so the first computed value always
> registers as a change, even for content that hashes to 0.
> reset_checksum() is seeded the same way.
> 
> Link: https://lore.kernel.org/all/akfYImSNDh3OjIfR@gmail.com [0]
> Co-developed-by: Catalin Marinas <catalin.marinas@arm.com>

Since you added co-developed-by, I think it needs this as well:

Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>

(otherwise I'm fine with suggested-by)

Thanks for the investigation and posting this.

-- 
Catalin


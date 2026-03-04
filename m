Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 25855EF8FE7
	for <linux-mm@archiver.kernel.org>; Wed,  4 Mar 2026 14:00:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 687BC6B0088; Wed,  4 Mar 2026 09:00:55 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 60BB16B0093; Wed,  4 Mar 2026 09:00:55 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4ECDD6B0099; Wed,  4 Mar 2026 09:00:55 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3DEA16B0088
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 09:00:55 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 09F5B13B4A4
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 14:00:55 +0000 (UTC)
X-FDA: 84508541670.02.FFC43BA
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf18.hostedemail.com (Postfix) with ESMTP id 88BEB1C0014
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 14:00:52 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=bUwqURsS;
	spf=pass (imf18.hostedemail.com: domain of kas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772632852;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NL58OaTqkzJ7X4/qWDOWloI7PZvXcTeyvlQSsYy3lrI=;
	b=yNKV9ZX4V4BuItO+yHBT0uGZ/U7xNhTkRxw/2lMRLyzFR4oNQx7nHXpM8IK+Un1SVy4F6q
	7veqXvrnZ4/pvDJ3czgNYCxtMAS3S7PB5QjLeUdoJiuYztLLdNkc9+znYenvVfk6eimqN4
	BFxioDO5VTbdLdL+RI27VTvaPJNCcdc=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=bUwqURsS;
	spf=pass (imf18.hostedemail.com: domain of kas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772632852; a=rsa-sha256;
	cv=none;
	b=wXLrYwBr5l+9e7ZIp7L1LK5LKLBXTQ7q/yP4fftBsfaJbqB3+1y0CFeidzg31W0lW2L42n
	PvBjMK+XcwsxZPJEkujWKCUyJEul5lGOGg1HPpZ2C0k+IAii1TlVav2bS908seFreF97RH
	IhZCqMmykTRH9pnpqTK7wzfEVufPmEY=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id F06846132B;
	Wed,  4 Mar 2026 14:00:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E13FEC4CEF7;
	Wed,  4 Mar 2026 14:00:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772632851;
	bh=iKD3YwaDmZBvntoN1UL5rht9ScDTUuy5/Ay84GFJXFk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=bUwqURsShNUVzKeSU1D2X4VOfivUa3RtxubxcSSDYG+bdbbYJWE+Y4K7zaVj1Kcxi
	 +fdOzBawT8AhsO4jJxT2buJ7iLkCUKiAzn/5ig7UwTvIunjupj85JMzs9iHZ6cKsRf
	 h2jIQuBvoWltC74YmGMNdw5rJWksge7WQSBWFeO253Gz7cG8MAKc37mytzGa4IksUK
	 413oqzQoKpfJLRuEe0srdr5ssmZDtSg8dcVEN7/FKBcEBXewHpX0F1IoTvU7GQicqk
	 VCDV76f0v5MZYJGC4YkLzkve7kF7AK+7nmevVYgthBr50syQzdVtC4PZE3PhAVnk8y
	 YQKcGWzRlc6dw==
Received: from phl-compute-06.internal (phl-compute-06.internal [10.202.2.46])
	by mailfauth.phl.internal (Postfix) with ESMTP id DAE53F4006A;
	Wed,  4 Mar 2026 09:00:49 -0500 (EST)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-06.internal (MEProxy); Wed, 04 Mar 2026 09:00:49 -0500
X-ME-Sender: <xms:ETuoaWvwUrlVZkit4uoOmdHqE67oUFV2LRLqV369TeGzwgkGBEjTNQ>
    <xme:ETuoaW2eM_fl-pJvDF5U7exUlJ0PXiiBD8oZHXiSHFqzryPW0PcHB_dAoJ85GaYtZ
    7GFHeHAE49giYlupzq58gW0z14iJipM-3S_EbjDTBH_FWLHp_4RCiM>
X-ME-Received: <xmr:ETuoabJofWDhTcPdZ8g6CdSK6uFuiC2rdBIR0u1CeawbQ9kNYo-Fyebr5Ai52w>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgddvieefieeiucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhepfffhvfevuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepmfhirhihlhcu
    ufhhuhhtshgvmhgruhcuoehkrghssehkvghrnhgvlhdrohhrgheqnecuggftrfgrthhtvg
    hrnhepueeijeeiffekheeffffftdekleefleehhfefhfduheejhedvffeluedvudefgfek
    necuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepkhhirh
    hilhhlodhmvghsmhhtphgruhhthhhpvghrshhonhgrlhhithihqdduieduudeivdeiheeh
    qddvkeeggeegjedvkedqkhgrsheppehkvghrnhgvlhdrohhrghesshhhuhhtvghmohhvrd
    hnrghmvgdpnhgspghrtghpthhtohepfeekpdhmohguvgepshhmthhpohhuthdprhgtphht
    thhopehushgrmhgrrghrihhfieegvdesghhmrghilhdrtghomhdprhgtphhtthhopegrkh
    hpmheslhhinhhugidqfhhouhhnuggrthhiohhnrdhorhhgpdhrtghpthhtohepnhhprggt
    hhgvsehrvgguhhgrthdrtghomhdprhgtphhtthhopegurghvihgusehkvghrnhgvlhdroh
    hrghdprhgtphhtthhopeiiihihsehnvhhiughirgdrtghomhdprhgtphhtthhopehlihhn
    uhigqdhmmheskhhvrggtkhdrohhrghdprhgtphhtthhopehmrghtthhhvgifrdgsrhhosh
    htsehinhhtvghlrdgtohhmpdhrtghpthhtohepjhhoshhhuhgrrdhhrghhnhhjhiesghhm
    rghilhdrtghomhdprhgtphhtthhopehhrghnnhgvshestghmphigtghhghdrohhrgh
X-ME-Proxy: <xmx:ETuoaY_H-BSZw25VHhEBB45Az1HuICdPIVZimFqpwyiJiKM59ChvcA>
    <xmx:ETuoaShdtHCyJeZAEi4m0MSjPfa4uK2-IGnuo_5c3otQ2ISoMKHBCg>
    <xmx:ETuoafzDwjcm5qfpcyiFl1Hx2by73GXaYq3QvRughfcI0krBUxvH0A>
    <xmx:ETuoaZqkc7apPTcFBEg96I3B63hOVeKSWUjNncb62jgae16j1NUT7g>
    <xmx:ETuoaT7Me7I2pfd3pDojTSQG5b3wP1gLwlrr1s4H_K61a_klSE5hUQOc>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 4 Mar 2026 09:00:47 -0500 (EST)
Date: Wed, 4 Mar 2026 14:00:42 +0000
From: Kiryl Shutsemau <kas@kernel.org>
To: Usama Arif <usamaarif642@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, npache@redhat.com, 
	david@kernel.org, ziy@nvidia.com, linux-mm@kvack.org, matthew.brost@intel.com, 
	joshua.hahnjy@gmail.com, hannes@cmpxchg.org, rakie.kim@sk.com, byungchul@sk.com, 
	gourry@gourry.net, ying.huang@linux.alibaba.com, apopple@nvidia.com, 
	riel@surriel.com, shakeel.butt@linux.dev, linux-kernel@vger.kernel.org, 
	kernel-team@meta.com, Usama Arif <usama.arif@linux.dev>
Subject: Re: [PATCH] mm/migrate_device: fix folio refcount leak on
 folio_split_unmapped failure
Message-ID: <aag4xM8wCAqTmco0@thinkstation>
References: <20260304120132.3973445-1-usamaarif642@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260304120132.3973445-1-usamaarif642@gmail.com>
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 88BEB1C0014
X-Stat-Signature: eco5ae5zwrkjowe8aowrxkufrhb3ucfz
X-Rspam-User: 
X-HE-Tag: 1772632852-790295
X-HE-Meta: U2FsdGVkX1/+xNJHBZO3PDtcijaRqPCRJYaoFiPto7GBiEjnzZyV5lnSxDjViA8pHqjNMAeEy0TPILXPJyKCoY7Qs/7LUmS7zEOifwyd7hD/8kJWq/+w4/tW3w6kR5p4OX4kPZZ+2k8CXiTLRRM/bCrF5BiocnK7fyAdUVOJwgK83/oEsA9vDk2e50AmT+Pyhhchspm3BTsyylTqT2mF4CfADKWR838HzRQWxi/IX8y68j8oFZP0DoqYcFO490l3MqpFkp5Lkue8hsmuURvoOgnd10enmgwS9kYSKtUKyHC52pg7NJLDF3uh+EUareOrQfYeoZ19mt8wYuY99qffYBVbtbpidugSHZBK3bxMncSXHASPTcloyGweW9NfGUtt2weFyWVPeiY5cY4V43bALKbI6oR9yN19Xm2a1xAzjDHPoYh8+BNdyd9BQwLdeASP9BUWqjeO5KWGfLJeprB7+I0CZ5AG9tABYNCmz2a9j7YQkaeLpE/WrtBM2xCqG7lbQM5XYOgLBHsoFeMtyIsGy8n6qQ7UlzA63lioxCIper2dwKydaDgJTfHJo8vDqJRMiKAhnNli6x2/O7tDoSV8XA+Ptq85keGiB6bLzI537H2xFFbrBTPdumNm/LxE1tZ7FOR9OjzStvRuQwTqLOnJsj3ntKzQcIwIs8b+dIhuHoZOpD7BkQ/6YofDi9ekvpQFFVQhC7a1Wo07lEK6TbjUI7OmWDsT6l7weAQUkHb8xAFiRl56JGXSf1GGIzr2CjemNZGV9E0htJtdCszK7oMB8AhrOYsP2ANEUzCcRooENIPMFoD304D4nad99BSN7qA2aHDypyHC311rAbpI9BSthUywE+dvC3RW5SZJv/CjUBVBO1ttJ1Hk/a+a7HLDS1r1LS6WtfFlA4gC49Arj8ItwIcAC6+/Q06FMk6gvg7mLatt1AcXvLKVj16iomiVHFADCj27PdUilzZUvvN3yCS
 H7VgCHhY
 k9HgXa9FpdRWJPfYWU+CsnzYaQc3CO8W0dJcXDUC6GLe0gH/B/O/nRZgoXbeVeXMNpAA76w90Z8CxM+IMiLVD5sEQ4fmblkMyQMB0cgC/bfgxvGG/3CoTmqfnALZpTldpZpB7RVb+m0c65LFjil5L49PSPIohLlMCnN8djnOPus8Z8CQltLO0OG0ukrGxUXJcJ2ZOSfBn7TqVHJdu7YhY2T03f8KAPaeKorUI7OkTzGitGkzaXfjKYi/UeugUxgHRfRSnPRB3hwvW0nwLSGi9DWfPWeFVoBfQBWfr/O0D28vz8HvmjAJ1k/Si8UrFaxBqAYQy1Y8gU95QBAxFBK9N2zMVVUitNjaBYez1x/glxW8yZW5PtLplG0SCZ/o86+Yh+YwgPoYOiAW+E2b9tXIQYHhOHcZEXAK/dUvM9W9Z1La5JMk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Mar 04, 2026 at 04:01:32AM -0800, Usama Arif wrote:
> From: Usama Arif <usama.arif@linux.dev>
> 
> migrate_vma_split_unmapped_folio() takes an extra reference via
> folio_get() before calling folio_split_unmapped().  On success, the
> split consumes this reference: __folio_freeze_and_split_unmapped()
> expects the +1 in its folio_ref_freeze() check, and distributes it
> across the resulting sub-folios via folio_ref_unfreeze(...+1), which
> are later balanced by folio_put() calls in __migrate_device_finalize().

Without this explanation folio_get() looks very random. And I still
can't say I understand reference management for the folios here.

Who takes reference for the folio if it !THP that gets return in the
_finalize()?

Can we get reference for THP and !THP at the same spot?

I think we should avoid spacial-casing THP where possible.

-- 
  Kiryl Shutsemau / Kirill A. Shutemov


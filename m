Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 71D76C982DB
	for <linux-mm@archiver.kernel.org>; Fri, 16 Jan 2026 17:14:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4B20D6B0005; Fri, 16 Jan 2026 12:14:43 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 45A0E6B0088; Fri, 16 Jan 2026 12:14:43 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3B2B86B0089; Fri, 16 Jan 2026 12:14:43 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 286466B0005
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 12:14:43 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id D76F351D82
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 17:14:42 +0000 (UTC)
X-FDA: 84338476404.17.60EC536
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf12.hostedemail.com (Postfix) with ESMTP id 766EA40015
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 17:14:41 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=rZkslwi1;
	spf=pass (imf12.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768583681; a=rsa-sha256;
	cv=none;
	b=AbhmxW64OXjKwaQayUx04GLlZ/BZllOXJiny1r+28ZrOCkHK5SIiO7XNeJM1i3XMChRaz0
	4F3kMpnn9Lw8AsjnQl6qRKx1+ac+hHOT3i7b0pvW8UVgnS20G1RAqctR942ceqrMxX2Ekb
	e6/YG00RHSZRVCcUhFjMpv+UAWMcZD8=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=rZkslwi1;
	spf=pass (imf12.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768583681;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=arJvcCvN4ztGJLd7hUCd1IXFDv2P3lxC+j2W3w2tICE=;
	b=a7KGvmOUdQ2cIG9NNYHyZMIlc0rHTu4RJ7N3KVkiEMh9bkQL7bva7wqaGX7gqa0WuKykYh
	qfjWH0FzVPH5stU7lgbK+/9aXdfHY1MyZSAW1VrSF9bYzFsf21GI9zBjzariGm7Z2hfkts
	CHs4Xtw/XKW+KDTL/DMci8t1QqJyjOM=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id EF2AD60150;
	Fri, 16 Jan 2026 17:14:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25132C116C6;
	Fri, 16 Jan 2026 17:14:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768583680;
	bh=d4CxCBV64cuXzGjuk2uWj4LPcoHD1d0/Q4IvI0bWIQ0=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=rZkslwi1YB3MS82MWfrwr91m8ny+VcHQ9zx1fV+m11nPiXOIlxOrDB/3qRKxF+3Ya
	 lJ6NR5Lo7R/QYTpVw5hVM5WxiUe5ytTY42GKkTOGzeriYbHLL/1l3ZKIMgpop0l97d
	 K/vWGnYE4k5FWbLO5qdZ/QlzcDTFhV7O75SxKkUMDG8XpAHNiLCOGUAgJGQQlKd/1A
	 aSrhQRWgaThcB5aA7mc86eaSvrqtNi+tIqCMWxJIZhLO/7CaaL8lhNiZ/TiTFW9R5f
	 +g1uB6VjXsuotecCbO8L5DN4UvuvaHcc0YfFdx6Q+aSjK2BY8Vv3PYle+XeSRaQM4j
	 q0X13GuhF/OjQ==
From: Pratyush Yadav <pratyush@kernel.org>
To: l00580197 <longwei27@huawei.com>
Cc: Alexander Graf <graf@amazon.com>,  Mike Rapoport <rppt@kernel.org>,
  Pasha Tatashin <pasha.tatashin@soleen.com>,  Pratyush Yadav
 <pratyush@kernel.org>,  <kexec@lists.infradead.org>,
  <linux-mm@kvack.org>,  <linux-kernel@vger.kernel.org>,
  <hewenliang4@huawei.com>
Subject: Re: [PATCH] kho: test: clean up residual memory upon test_kho
 module unload
In-Reply-To: <20260107022427.4114424-1-longwei27@huawei.com>
	(longwei27@huawei.com's message of "Wed, 7 Jan 2026 10:24:27 +0800")
References: <20260107022427.4114424-1-longwei27@huawei.com>
Date: Fri, 16 Jan 2026 17:14:37 +0000
Message-ID: <2vxzjyxh7a4i.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain
X-Stat-Signature: ofnntjbark6g719xcima6x5nhyd9pq3q
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 766EA40015
X-Rspam-User: 
X-HE-Tag: 1768583681-787192
X-HE-Meta: U2FsdGVkX19oiZM2Ik08b6tIHPopzy0zFrSMCh/IkatqrtCU6zx+p0kle1BPynkRrz8MnciR+Mj1FOfRbsNQVhn1dxcBpNZN9FOlqJXv3decum5YlA7Ea9+OGpulCM7HhaD64QlFPROSxa7qu/Lqx/PIH7tXOt1/mhc7rjLXlK5EauKYrzLeGbg20VORtL3fh+7BQIgw8NJhCSXpMZ7su/KxCN2Nrj4y1rEeUFdBdwUVFpV0114AtKt3G4G5rGDR959hqbc7SaO468iGn+KwwTPqFlfzr7frxX2XtYj6U8CpIGTizYQsDXz5VPfCVpx1voe/r7xs/tS0D5cWvZmr9HHOJHaGRJg3bwpRvLlDYPoZHkrKzB6JZtq3vpPPuqYbnWDg2rKsijZLJjbNboE0nIygg682BfjD3ex4zaWJn9WcG0/2CGb9Y/cSggNv5P07rPvF9e9zHxC+CdVjJIqxtgExNf4wpywbklgJ7XTxpwJXAhkeqHeOq32mqvdCeclq0dbbGARbmn9X+vsgWyA0mG258qGnXGldgTapQHWsM3SPWEBqwN1bltrwMlD3dCXjd2Sz4mfuePU1ZfdO2s6Us2IUo+rwCJo+NZzJ+K8kYA7b0+mH34oBG0it1mEsBazcQrg7VuA9VpwyqTbCbdXKH4OAer0HNB/z1s+OPcmsxZqAXb52vxErL3K5MWw5UR7k9aRdGWqDNi9zACqFIkTWjiAmAJpJVrSOgpymf9fPTL339f+lL62FzkgW0xGq3A4rGObh+YvcfPEoTHkSliWaoqQCHFyLPSh3rs+HssCYN1Uz9U3TrBe41WisRY5x0VAf34mHNCW3/Fw+wh91lomVbMOyvfw3aJB8i/HfOSyW/JbJrXH/7GkPmMHnT90jFN2JePVX3TgLzNCz66GdVj6GpdDehOlArwMYCv84xKjPcuxLOJv9/9PdrbvFK1QPz7aq
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jan 07 2026, l00580197 wrote:

> From: Long Wei <longwei27@huawei.com>
>
> During the initialization phase, the test_kho module invokes the
> kho_preserve_folio function, which internally configures bitmaps
> within kho_mem_track and establishes chunk linked lists in KHO.
> Upon unloading the test_kho module, it is necessary to clean up
> these states.
>
> Signed-off-by: Long Wei <longwei27@huawei.com>

Reviewed-by: Pratyush Yadav <pratyush@kernel.org>

[...]

-- 
Regards,
Pratyush Yadav


Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 649DCCFD2F6
	for <linux-mm@archiver.kernel.org>; Thu, 27 Nov 2025 22:03:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9DC026B0031; Thu, 27 Nov 2025 17:03:44 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 965606B0062; Thu, 27 Nov 2025 17:03:44 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 853EF6B008A; Thu, 27 Nov 2025 17:03:44 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 6E48D6B0031
	for <linux-mm@kvack.org>; Thu, 27 Nov 2025 17:03:44 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 293EC1402B9
	for <linux-mm@kvack.org>; Thu, 27 Nov 2025 22:03:44 +0000 (UTC)
X-FDA: 84157764768.18.F4A145C
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf03.hostedemail.com (Postfix) with ESMTP id 93D1220014
	for <linux-mm@kvack.org>; Thu, 27 Nov 2025 22:03:42 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=UUHxuxKr;
	spf=pass (imf03.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764281022;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jCbdeANbiExZLlbNwVWtk60PePbhkxhvg8Gvmxz81a8=;
	b=mUcVAKbrnLa2qzBjgu4T0pOqxdDGepFDB6ON1Ww6dMP5N4culqBySPnOKAEYmEJMklnBp8
	QfmIf3JYDkFyMA9DROs+Xe+i/DxEkEYdeLAbZwuBA9E9EdZT1DoPYJGNprXIFLK8f/wuxS
	jrstj+a7cvK6WeXsA1OWw/23oN1hfMQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764281022; a=rsa-sha256;
	cv=none;
	b=13jdTl/IoXFWL2wuVp1X+c+EAI/QW3G32FHZ8AXnmSiMkdu7vQhr0McmAixwLsQkDkeZtE
	bgQjXf36+6LcggqWs2QoWO1b/e7MW0ypZ6lRM9sVsNUKZc0p/AnTf5iyNSuJz+j6vX0KSk
	cdRvvLsOsX2/jWjcl6e7ZK/+GKAQakk=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=UUHxuxKr;
	spf=pass (imf03.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id ACA9060242;
	Thu, 27 Nov 2025 22:03:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6DC32C4CEF8;
	Thu, 27 Nov 2025 22:03:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764281021;
	bh=zmGqLytRZby4owN8iTnbIG9QtDWsxgRKExAp/iyG32A=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=UUHxuxKrkEpUJcSgNslQrLDR6ouE+5g3AYpeOjauhuzHbPXfRD4nRkGiIrNYYIcm+
	 gjq1rwyKpiliq0wO99yQCJKNgnl79jClro6F+Szv+GvbjtSVOGb+TQjJmr3xRTSWcn
	 SzOj0eWJ38znFR/eGhYe1WiIZPQA3OYy3pj/7LfzOeQjOtXzOA2l2FkXoetSiCCgkn
	 2jMU/vG84afuXoGnKlVxl/Hr8MfVfDJuXoahD9XYxGDmWOBDmky25fXZZRupMzAE1l
	 miTGpXSG1S5my9wTYcLTQub/6kJrwZ7Ox+gJz2F4L+ccLeSvZ4hRF7r0hdHwzG8rmQ
	 /M/0eOlT7UckQ==
From: Pratyush Yadav <pratyush@kernel.org>
To: Pratyush Yadav <pratyush@kernel.org>
Cc: Miquel Raynal <miquel.raynal@bootlin.com>,
  linux-mtd@lists.infradead.org,  linux-mm@kvack.org,
  linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mailmap: update Pratyush Yadav's email address
In-Reply-To: <20251125173151.29430-1-pratyush@kernel.org> (Pratyush Yadav's
	message of "Tue, 25 Nov 2025 18:31:49 +0100")
References: <20251125173151.29430-1-pratyush@kernel.org>
Date: Thu, 27 Nov 2025 23:03:39 +0100
Message-ID: <mafs0345zw2tg.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 93D1220014
X-Stat-Signature: ub8bq4yguoqbgcdzhopybico3bqh59oi
X-HE-Tag: 1764281022-531361
X-HE-Meta: U2FsdGVkX19P6ePI70RR9ePArZnkbDErkdq4azHPq6Jg5gGj7rJH7hOt//p0SgsLywXRvCFVJTlJHhGNk4P7LgH1RzTUI1RJurmvx/e6uLSPyngfUNtreqO6VxXjsy6yx1dh7GKLTzaIPjFRIzlSA5m6P3cJJ1jOs+f5F713H6ZLn7CB2WC/ezwVQ0/lZPeogV0vG1Xfv/iOUQX+xYd4UtDjOVkJsEuuT0SKVYYPNkqWf00n5BT324YgUqrphrYRLtJvghxXFGJccimyP8wOWIzX/1HVhD6+aoTtuNSQCdrcvPn0QqHdtjEigbQc0/7YjmeSmK5J1yZSRa2Cy1hLhX/u0FJnLtLjG2lHnW4zFT5eiDTawdMm5NAoK/KRMTNpz+GdmHs3Ia9PsVXtmGeI3MyKjfin/Di2HO8ZqMo/XQDZUWwAs4HdSfu1IjT+CWzX7FIUOnihbyrS4Y3lzTFxtHv6MyaWm0hgZRf5e6ZrOPk68NVYMEMEJwy3WWPRR1FSniezCHjojdZL0ibFrna/Dy4N/VtMc4JBYd6bF7/9PhPBByCNh0+Lx4cg8wjCp9IkY1bYDQ+Bt5XU1RmdnUC6QDgT/XaaoHMXPAodMPs59g9AnJmKgeTBw5Ns6LxspNHQD9VFuc+RphL2S1j90vMeu8sOm91lJGERC0m6LosdXHFeT5xS+FtYyHlIRLChN79FubsJ00UL2mIb8poiqCSLies0bbnqBSDq5ibDCLgDut6tAFp0GSSjJAf2SwKPswo9SZXqEy+IdaQfINbp1fbuVHYJngwavt1Ljv37YD/R2D8YZyZJGCt8bwjmA1DKvPpuMc/6xDFC57bzWXoelzVEyiVbzpvqBTyYlDV/jLewbLKkWi5WS93pd0nB9U/MWVu9jrxgWM7PHIEfvGY7/IEapB/37opY9Z/3Px+CLnkIXqbTV4Dj6hpLSgaiMMQvVJZmVawWk3hCZ7naRGQAUvh
 EpYIZ7JJ
 B0Ca4CTPid/ZliKDDMaays6Fd07XcBhUlfIJSogY1uCZFhWJiyfoa3J/7QTyaE1dlduncDJUj/MO4BbaHU0d9i8cMdAHleKm9TwGySI20lpGwq7HsZurbqPrLkIfTUFYAIGlUA2CcfHXR2BkzVq7sGewo+5OsXmJN4MGtGfRcEwJxoUW58YTpchF6N5x8xLP37fqQqrxH+k449wLDp5G3rIc4VtNC52P0PDhX+eUgL+r2S30=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000005, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Nov 25 2025, Pratyush Yadav wrote:

> I will stop having access to my Amazon email soon. Map it to my kernel
> email.
>
> Signed-off-by: Pratyush Yadav <pratyush@kernel.org>

Applied to spi-nor/next.

[...]

-- 
Regards,
Pratyush Yadav


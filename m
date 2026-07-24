Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9D0AEC531C9
	for <linux-mm@archiver.kernel.org>; Fri, 24 Jul 2026 23:35:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 410E16B007B; Fri, 24 Jul 2026 19:35:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3C1C26B0088; Fri, 24 Jul 2026 19:35:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2B2E26B008A; Fri, 24 Jul 2026 19:35:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 058D16B007B
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 19:35:13 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 75060A0C42
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 23:35:13 +0000 (UTC)
X-FDA: 85025278506.17.7AB057D
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf28.hostedemail.com (Postfix) with ESMTP id D5C1FC0009
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 23:35:11 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=none;
	spf=pass (imf28.hostedemail.com: domain of sre@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sre@kernel.org;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=collabora.com (policy=none)
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784936111;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=4ZsZf8mlcRgO4a30pXSf1rO5CYE8B1uYHjFerDlxN7c=;
	b=sOsrBOnLsq2jCF6ZZEJuUFRsK+ZAg3UKbKlUgAM+kP8inIgLZVWkMddY0DWwSeiGOTEaqY
	WmyhmQlAaWhcfcj/RoybAE0XW0KZXjGZ8vFBsEuY0jL87/9uvwy8qx96M5GohkkmxmIzRJ
	AAw0hYE83xTp2pNpKZY0+gJqY5wNZoc=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784936111;
	b=YJqAxpPUzAzn1HDyEepqGUBmant0SM6jH7N8KV5UFyNno/McYn1B3LSolr+nd36MS2hAGM
	e4HiYXUVHlBumHRKpRbQPpZDivBwLZobOm6wztTPwtXHsFIzn17VFGWUCKmSnoGWEYWdG/
	aQ8LMdRZ3H08HmG3p92zZMzYw4Ygir8=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=none;
	spf=pass (imf28.hostedemail.com: domain of sre@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sre@kernel.org;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=collabora.com (policy=none)
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 9C2FC60A8E;
	Fri, 24 Jul 2026 23:35:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2BFD41F00ACA;
	Fri, 24 Jul 2026 23:35:10 +0000 (UTC)
Received: by venus (Postfix, from userid 1000)
	id 93CE9181F1C; Sat, 25 Jul 2026 01:35:08 +0200 (CEST)
From: Sebastian Reichel <sebastian.reichel@collabora.com>
To: Julia.Lawall@inria.fr, Alex Deucher <alexander.deucher@amd.com>, 
 Alexander Shishkin <alexander.shishkin@linux.intel.com>, 
 Alexandre Belloni <alexandre.belloni@bootlin.com>, 
 Andrew Lunn <andrew@lunn.ch>, Andrew Morton <akpm@linux-foundation.org>, 
 Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>, 
 Borislav Petkov <bp@alien8.de>, 
 =?utf-8?q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>, 
 Daniel Lezcano <daniel.lezcano@kernel.org>, 
 David Airlie <airlied@gmail.com>, "David S. Miller" <davem@davemloft.net>, 
 Dmitry Torokhov <dmitry.torokhov@gmail.com>, 
 Eric Dumazet <edumazet@google.com>, Florian Westphal <fw@strlen.de>, 
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
 Hans de Goede <hansg@kernel.org>, Hans Verkuil <hverkuil@kernel.org>, 
 Heikki Krogerus <heikki.krogerus@linux.intel.com>, 
 Herbert Xu <herbert@gondor.apana.org.au>, 
 =?utf-8?q?Ilpo_J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>, 
 Jakub Kicinski <kuba@kernel.org>, 
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>, 
 Jani Nikula <jani.nikula@linux.intel.com>, Jaroslav Kysela <perex@perex.cz>, 
 Jason Gunthorpe <jgg@ziepe.ca>, Jiri Pirko <jiri@resnulli.us>, 
 "Joerg Roedel (AMD)" <joro@8bytes.org>, Johan Hovold <johan@kernel.org>, 
 Jonathan Cameron <jic23@kernel.org>, 
 Joonas Lahtinen <joonas.lahtinen@linux.intel.com>, 
 Julian Anastasov <ja@ssi.bg>, Leon Romanovsky <leon@kernel.org>, 
 Liam Girdwood <lgirdwood@gmail.com>, Linus Walleij <linusw@kernel.org>, 
 Maarten Lankhorst <maarten.lankhorst@linux.intel.com>, 
 Mark Brown <broonie@kernel.org>, 
 "Martin K. Petersen" <martin.petersen@oracle.com>, 
 Matthew Sakai <msakai@redhat.com>, 
 Mauro Carvalho Chehab <mchehab@kernel.org>, 
 Maxime Ripard <mripard@kernel.org>, 
 Michael Turquette <mturquette@baylibre.com>, 
 Mike Rapoport <rppt@kernel.org>, 
 Miri Korenblit <miriam.rachel.korenblit@intel.com>, 
 Nicolas Palix <nicolas.palix@imag.fr>, 
 Pablo Neira Ayuso <pablo@netfilter.org>, Paolo Abeni <pabeni@redhat.com>, 
 Ping-Ke Shih <pkshih@realtek.com>, "Rafael J. Wysocki" <rafael@kernel.org>, 
 Rodrigo Vivi <rodrigo.vivi@intel.com>, Sebastian Reichel <sre@kernel.org>, 
 Shuah Khan <shuah@kernel.org>, Simona Vetter <simona@ffwll.ch>, 
 Simon Horman <horms@verge.net.au>, Stephen Boyd <sboyd@kernel.org>, 
 Steve French <sfrench@samba.org>, Takashi Iwai <tiwai@suse.com>, 
 Thomas Renninger <trenn@suse.com>, Thomas Zimmermann <tzimmermann@suse.de>, 
 Tony Luck <tony.luck@intel.com>, Tvrtko Ursulin <tursulin@ursulin.net>, 
 Vadim Fedorenko <vadim.fedorenko@linux.dev>, Vinod Koul <vkoul@kernel.org>, 
 Will Deacon <will@kernel.org>, Yazen Ghannam <Yazen.Ghannam@amd.com>, 
 Sang-Heon Jeon <ekffu200098@gmail.com>
Cc: cocci@inria.fr, amd-gfx@lists.freedesktop.org, 
 dmaengine@vger.kernel.org, dm-devel@lists.linux.dev, 
 dri-devel@lists.freedesktop.org, intel-gfx@lists.freedesktop.org, 
 intel-wired-lan@lists.osuosl.org, iommu@lists.linux.dev, 
 linux-cifs@vger.kernel.org, linux-clk@vger.kernel.org, 
 linux-crypto@vger.kernel.org, linux-edac@vger.kernel.org, 
 linux-gpio@vger.kernel.org, linux-iio@vger.kernel.org, 
 linux-input@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-media@vger.kernel.org, linux-mm@kvack.org, linux-pm@vger.kernel.org, 
 linux-rdma@vger.kernel.org, linux-rtc@vger.kernel.org, 
 linux-s390@vger.kernel.org, linux-scsi@vger.kernel.org, 
 linux-sound@vger.kernel.org, linux-usb@vger.kernel.org, 
 linux-wireless@vger.kernel.org, lvs-devel@vger.kernel.org, 
 netdev@vger.kernel.org, netfilter-devel@vger.kernel.org, 
 nouveau@lists.freedesktop.org, platform-driver-x86@vger.kernel.org
In-Reply-To: <20260723184538.3888637-1-ekffu200098@gmail.com>
References: <20260723184538.3888637-1-ekffu200098@gmail.com>
Subject: Re: (subset) [PATCH 00/36] treewide: remove conditional returns
 with no effect
Message-Id: <178493610858.699463.6794401814873674138.b4-ty@collabora.com>
Date: Sat, 25 Jul 2026 01:35:08 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.3
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: D5C1FC0009
X-Stat-Signature: f6of4x5d7uijmotzgnfi3inek8br55ik
X-Rspam-User: 
X-HE-Tag: 1784936111-603043
X-HE-Meta: U2FsdGVkX195oTnqC8eZNga7/wSzlcqm8Y8jiRqc1hCJaubzeDMkf8NZpQU42NS3zxjFqYZ9ZVx2Fa4bG6rUNotkjnNhulPF2bxJmfO6gspecB15iczoWwwQXJIG5yvrew79RAdtr9sSOFarSeSZB9fhWkUlvcOSSq3/xig0jf79UMp5E+0FMtXx8bfZ5/FkJ+YZJeLe6/dJJ0yzeYCSvyX5nQp275prr8iuiRgRwEIelFQE1nQCgfZkaPys3oBo9gkjQum/vRT/i3E3WmxZbSTzVni2Qf8Qv7fVDEkBj4R8iruY1hjQ7bMKuQN2hLhyvS4GNKcuiUTBGU5Hvber5H3pqZP5A3SjI8rMIP8YTpDliPaM+YzJxoakPGh5hT/MvjGzKmHXS13ogzbO4T9u/4tbWTFwKhWO+dTnhi26Viinb5LdcRo0GoDFMtdwxK4QmZv7CFIw0n/OY2bvgh1k3CvQYenGR2s3XF+iSG41h7aN9n/D11dbaGViFySNjypdZQvzxtksB9wHqIaHCDk1q97plQ5qrT2SNX8em5f8kDq5v2AezUcikgpQ4JN2U0bKTz4AYglxHL2FP5vIz7AQAmNnDP1UterzG/HDWHeD/AvV7zRbp0X+Ryv08wnx68FmjViYe3YB8Gp4JTpb/AFQb/2zgghmwOq8toFmtD4jkbqHzqWLqXAtwkRs0M5NhJ/TQAcDBFC2s0IfLe/6e1PmfLUWHHUd/6SE0CE7M2VZ9h6SK/alPsxRwrUMFpJdYc6FitDTC4ctcJFD2+AE6Ip+zHaqqYpCKhj6BP3mjL8enKrzvk6rDSMUkvQjuFKWLjBqsXFixRDhqy596n5djvU1NtTy4yhpzQD7vzHV7Fqeawq/2bSmky/SWHBq8J688XH4LgYhMu0B8MY1JHs1Uxdge8jYodFxx4gpd4uoP8vtLzoGmApTk+34sJb2zndo5Uts7l01Rr9bT0ss51j34k6
 SZtl6j0w
 cE8t/EtMRoPA2b84eKhWBBNsqxTfIfKjrr2ja53Mx44Ezky2QAzzrTfmqFaC+IClFCUsqeorD8w9e65oww2o1yx8RbBke5cyl2rC21oY/rLB/aRzgEnkGbDIJQE8mgg+BYwQJokZswWXM+RwfL78ZimDNfAccgX6HG6hsHzjt80npRNECF145hCHSfkQ17YSOgmaNhefdmluFCObBR9L7DhjmupJqMBS30qhc02ijdMryvDSMaN69D2CN8hsiZawjIfuSNIYN08yH4XMb07H/aVE3ocDmdxHrDCa/6uOA+UpvyTQB+P9bcwbWiCvscEJH0YJvYBWgRDIwtvrfJ7AAvDUIcr160ijmLsIi/jZ6tObg8NTyNg0OqyP2TgepBtWm+GN8xuKa1flB5e6jmcVuWNfmsTAdX8VV4P0NsUJnwAhWpj5129ATa8sYm9eVp0UeNCwxqz8IfXqAQ/I=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On Fri, 24 Jul 2026 03:45:02 +0900, Sang-Heon Jeon wrote:
> While reading mm/memblock, I found a conditional return where both
> branches return the same value:
> 
> 	err = do_something();
> 	if (err)
> 		return err;
> 	return err;
> 
> [...]

Applied, thanks!

[26/36] power: supply: pm8916_lbc: remove conditional return with no effect
        commit: b7c8d46411317f135e7791c0eddc56691de63f07

Best regards,
-- 
Sebastian Reichel <sebastian.reichel@collabora.com>



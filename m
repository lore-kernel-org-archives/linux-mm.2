Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1AAEDC53219
	for <linux-mm@archiver.kernel.org>; Mon, 27 Jul 2026 22:56:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F0C346B0093; Mon, 27 Jul 2026 18:56:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EBDA26B0095; Mon, 27 Jul 2026 18:56:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DAE696B0096; Mon, 27 Jul 2026 18:56:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 737886B0093
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 18:56:07 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 0E0121A022B
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 22:56:07 +0000 (UTC)
X-FDA: 85036066374.04.43E1699
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf16.hostedemail.com (Postfix) with ESMTP id 25DCB180008
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 22:56:04 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=iwaG5uRX;
	spf=pass (imf16.hostedemail.com: domain of broonie@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=broonie@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785192965;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QggSvxtNQ67iS+XUwqrDlrH2xraHrxGb+vgcG7y0WsY=;
	b=P0v2n4r5m/R5Knfmp7iDwX+tYMtop9PuIdUPVkOd8E99NJiCBOs0D+KWYsS0ghGHF7KiIH
	7hjIlIQWpiKtvQxIjPyDqFyHPrakaDCSowk3EJ8aGcRvstJxlabojEdi7CeKOCiOvzqBd2
	hkvzdSXOgY52cfnSwwqTa1L0PE/DbtM=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=iwaG5uRX;
	spf=pass (imf16.hostedemail.com: domain of broonie@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=broonie@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785192965;
	b=8PCBSsGsA292M0sUEB+OSop6HWewZdZ72alAzUabxCam+izj6iiB9/zJeOCjVqugx780Q0
	zFr7FDh5Ct0s7jNDGzj3V5X+dBktjmumf1gtXaM7DGKyA9uWtrd/Bc459J8gEywpLyEVTL
	OVkjnY2UNTyq7WEeVkH8PzX1ahkUNyI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 3854F40426;
	Mon, 27 Jul 2026 22:56:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04CDB1F000E9;
	Mon, 27 Jul 2026 22:55:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785192964;
	bh=QggSvxtNQ67iS+XUwqrDlrH2xraHrxGb+vgcG7y0WsY=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=iwaG5uRX32rTgcSQn1oI8cDhvVdBgF7xNVMcmwA5nB2roQEpjWkBM9/elDUKMWR+e
	 A0p9zb+3tSs36tELwjTyibEs5znVgnOoeBgaUwvlk+h9jnbCN1e+v9elShDExZRawl
	 S9FIBGMRZSowIq2RtsqIUQJ/GKy2epEJEkS13zWkXc/uH+dFvxm4jWJtqykilYp8FZ
	 n/dZuVVGnI4Oh8Jv/TOV8zbNHWDjAXhVQbUPhHErbAZOrGNAAwjAULYVaj3h2kBbW9
	 ED2feS2pNPbAGb5xCgo1ctL4J3aD2Ir+AJmF+Wa3lGIyvJ/mNC9waIoSbc3rE33Rm4
	 vgzkKLQuteGUQ==
From: Mark Brown <broonie@kernel.org>
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
Message-Id: <178515520105.50339.6347304746485042237.b4-ty@b4>
Date: Mon, 27 Jul 2026 13:26:41 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.16-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=1395; i=broonie@kernel.org;
 h=from:subject:message-id; bh=oEgoEtojyQ9PC8g7uhG7viM9B7fGAJubrsCe9lk5/YY=;
 b=owEBbQGS/pANAwAKASTWi3JdVIfQAcsmYgBqZ+HxlIWhtS7M/+/D/kSsIotZNE7ycdvTNKMa6
 lyMcsUy1YGJATMEAAEKAB0WIQSt5miqZ1cYtZ/in+ok1otyXVSH0AUCamfh8QAKCRAk1otyXVSH
 0NGoB/9aZSWKSSxB+DoiO9o+r0R7LvQ0b9P0b+u/ow+7Ti4Va043c7UzGI2RzCGdUpf18XgLn6f
 SgEv95GzlB+upqVsxmPG9VHhXWw4Ho9J4p/hSGXTDgAS8ErF8GjIkiAzWtWwlF1NwqBzKdr1HBU
 4bzLooMHmkm+sRhw0K+K8vYxKzoIVIF4rw3OtvuVpbcnMjoni4zgFcLTc5cd+g7gZ+ms/PpNPge
 1bCGwvXOdpSE1Sx0RqUVVFnzDZUByQ/Qgq4t95aAwkznICTyGzRGtCagn7hNdby/Adb/VqLQiGG
 EXfGwi5kgCay4GMGfP+CcNTcNXARRSisUOfJQUCdGh8to0xz
X-Developer-Key: i=broonie@kernel.org; a=openpgp;
 fpr=3F2568AAC26998F9E813A1C5C3F436CA30F5D8EB
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 25DCB180008
X-Stat-Signature: dfzkepa8io9qfhunu7x1u673ra8k6xjw
X-HE-Tag: 1785192964-338615
X-HE-Meta: U2FsdGVkX1/ju9YgQC09yOU+jZq/3Hc0UQJpeQWNPs/0KXqnhdO9jRTW/z0wHZRNpV7FXw1PZQ8GmZ3mekmaxktrl7jYoziW8y2e+N6zVgNU6eAZmeogIvLJFRtAaY58bXMqWmYuRFyxeL3ylfVNFDlofN+Ff/++D8rJYNy/8Fq44fo9JVb1rj+McL8RQ5Cbmj59uXQiwbq0alWxFjfx8gh9ZiE1yiARpVjd+eWT8LLPLVOKyVw7aHtrK37hArZDcBVc7/zwpVM0ZCh0akBKZPHQWWcWPf2qppkogyQsU37TIh19uMKwd7sGfG7aE8OSgzCqZpx7G9erZs4pRIuGmyRpWZU26eAQu6EKzO9lTRLt6LGoZemz/sBOKLiySxpplhnB1JY4aDfVYUzWEva0MYDpbZienHaN7/ZCqj4anApYg78xMTEKXApnRBvRV3fsBTJqRvsyniIbsIPE2PfJgdjk53xqNNZKJqH7Cq7zb8WYVKCUQuVF/q+PL31V7oKbv4waIq+zgMD2WCjIFgqaHIyItweqR6kHRpZE5IV30KR5SiRQcRm1qLZGvZOHl5i8Iki+saGayn1bNtB2gvw6c4O10bh0/bGkSVJWMG1+DUy5QMc8cw7942hGk4RrNjGerU5t5eRehgKerMxsyrhyD+4C3wi/jO4TPIENcR4uWmZ8VKAguBFVP0seEDG97tGDbds0IBLJLeL1cEJv2f9c77IDIZDgWN6WpEZ9iNtUxumnDSEbOGID+6StyA//HgPjSelvHN2YIKS/pnT4w/M6wxpTycLG4r+xX9Ni9+W04oVMtFZrpSOB/wRbDqhRzrSaUKDT8UW5wn/3LaJ9qeXfU7fbhQhuaTb1xIrjyCX87+nE9Z7p+CTrDLTXNtRDv5LXXA6Cc8j9Pvy1/OgA6TSLJg3cbNR0dBanshOu82xXjopWhfGcboaEtof4n2dpxrYoXLRfBs9WT/xP2+5ovNT
 o3FCtN5E
 n3a/cvKI5sczNo/FbxRrBoIEpO8+/XYcHTlUwnq9IWAzdTPMWAjl/OZ1Mmx8dM8wSPvQQP1FsnXg2Dxcwn5uLHWzlbAr6EYixAxkXliP6iGu6Axii8w0YJOXgNAqm6xAio+esK/XD5KM3vggiOFCuG25verLq1U9ia2FjdwCY7/e5gbKFeXQfaPE3e+UVf/QgpdaVWhKhflcb2/boE1sZGjtA+s++OXM5D75Jew1w35/NCfr+jgA3Cn/o6m9EfqZva0tOHXKTIUxCyWfIqiqNnnlZv4uxBINWHf7wkvsXWnAwXQJu6B2I3sXIAs2pl4QaKfAo
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 24 Jul 2026 03:45:02 +0900, Sang-Heon Jeon wrote:
> treewide: remove conditional returns with no effect
> 
> Hello,
> 
> While reading mm/memblock, I found a conditional return where both
> branches return the same value:
> 
> [...]

Applied to

   https://git.kernel.org/pub/scm/linux/kernel/git/broonie/regulator.git for-7.3

Thanks!

[14/36] ASoC: remove conditional return with no effect
        https://git.kernel.org/broonie/misc/c/ca9b51f41c9d
[28/36] regulator: wm831x-isink: remove conditional return with no effect
        https://git.kernel.org/broonie/misc/c/9396a1d9e142

All being well this means that it will be integrated into the linux-next
tree (usually sometime in the next 24 hours) and sent to Linus during
the next merge window (or sooner if it is a bug fix), however if
problems are discovered then the patch may be dropped or reverted.

You may get further e-mails resulting from automated or manual testing
and review of the tree, please engage with people reporting problems and
send followup patches addressing any issues that are reported if needed.

If any updates are required or you are submitting further changes they
should be sent as incremental updates against current git, existing
patches will not be replaced.

Please add any relevant lists and maintainers to the CCs when replying
to this mail.

Thanks,
Mark



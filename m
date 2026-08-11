Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5D85EC5CFDB
	for <linux-mm@archiver.kernel.org>; Tue, 11 Aug 2026 18:52:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 12EC26B007B; Tue, 11 Aug 2026 14:52:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0DF646B0088; Tue, 11 Aug 2026 14:52:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F12716B008A; Tue, 11 Aug 2026 14:52:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C80386B007B
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 14:52:12 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 6B278140186
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 18:52:12 +0000 (UTC)
X-FDA: 85089883704.02.72A51C2
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf09.hostedemail.com (Postfix) with ESMTP id BBD45140007
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 18:52:10 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=f9fcK+NV;
	spf=pass (imf09.hostedemail.com: domain of vkoul@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vkoul@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786474330;
	b=NLFSZSiBz3zre7cGh0xV7odlvW4XfNPX7mD3gTcn5k+Az+j7AywbQf8W1oUf9cB1UdZGvI
	UesfWShXE1udivb0wJL2zxWbuYILJloENMGpCeCwxK2GryGZLNLLOiMnJv/LWuVSBN7y3C
	eOWthtw9ZesdXgD1IDkJJZCOPj8BxY4=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=f9fcK+NV;
	spf=pass (imf09.hostedemail.com: domain of vkoul@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vkoul@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786474330;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=L0HTQS1LYVWSdc3RimfvMueRkxBKnov+tJfBP1Nzenc=;
	b=3K2BS5zVpWTjxwp6DGR5V0e6aPobTOmS6Q4XO+pvJquwSIo1w/R0oEhRt/zaqrdtCnLyio
	ZVBR67OiD20sNaCmKW/0hRMP5+Z8bB2/MI3GCfsv7xSygC4BFmB+YDvyLUaIb5WFYwcGLt
	zwY5I6cMzYvHZuUrATQxjyxOHsHnBJE=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id B1915600AE;
	Tue, 11 Aug 2026 18:52:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64C9D1F00A3A;
	Tue, 11 Aug 2026 18:51:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786474329;
	bh=L0HTQS1LYVWSdc3RimfvMueRkxBKnov+tJfBP1Nzenc=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=f9fcK+NVNWrvcSOcKHy6zfAbJxAzV4H4fy8MVkzolSHyhTXevNA14uYiezSHzn6pQ
	 ycpaMxR2NK5BhnYOlevG/IFGX9tQA5Zq59bExZRq8ebTHdeuBPIJKdmorpcmlYiJYN
	 enPNXmLxCznd3cawK4k1uWZ7ls5UQ+kBsVAJbZyI9ASkk1wotZU4MuXOcOSURRiwqg
	 sT65TPpe9rPAxYbWb9c4r08z7q71qyz1ECpgE74A6BnSnCI7mMzF6uQjafv+S2Jyy3
	 tECe4u8tzT2Nvo9T8WlyH+ZxIb0wNqskL4SGoz+McXb9NEhgBdQAaCdq0Vli+in/qH
	 jqXBcNxLA7xiA==
From: Vinod Koul <vkoul@kernel.org>
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
 Vadim Fedorenko <vadim.fedorenko@linux.dev>, Will Deacon <will@kernel.org>, 
 Yazen Ghannam <Yazen.Ghannam@amd.com>, 
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
Message-Id: <178647430099.1113716.2263974283705757692.b4-ty@kernel.org>
Date: Wed, 12 Aug 2026 00:21:40 +0530
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.13.0
X-Rspamd-Queue-Id: BBD45140007
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: k98zo7ym1dtjnha7u83t77fmhodf7ssi
X-HE-Tag: 1786474330-663259
X-HE-Meta: U2FsdGVkX1/ycGqmTDiKcElBXHFQkn37RquyEuHXxHLMgelQWS1/5r/ALwJhdW8x6glGgBKI1bd5CzCzAVcyKFgbK4BCS3fmDQqNCYD/JOqo0uJd0yGf1oeBPeXBwpihydQsIE/ejpnyw2VaxDFSBA6Un55rLgBMEvGzZpIhJej8JWtNexVn9i+yTWUirazlYMUvDJgZBWYwcEyK2SQ6XYNcE9Zr4kOKpE6E4KtiP1gh+bG/fQPxDsvdImsGRs1YZKUBDCuR/GcfWLQkohm1Qqe1vd1Fi5lvItohPeHNK8W2yg6lNw51jx0ADj9xVKrt/BNRK/7J0y/kcflAivNxW62B/Glxgtd4hraMNxkConoBBwAnO2T8cQubBBM9kAfnmFdcCLWm+hWVEhtWuMVXB/wTzZAqVnQZCufgnRy8CQmgCEkETIy7AURO7EcB5JXomZ4TLzyD1xwSdy+j2UJuHSophF2mcGq7g2fe2GN+CyMqg1+8cw8Tvnihqdj6ou4/eFQVCUrNRhjbAs+nc5POPOzXeupzzK01rI/XAV+1DRSXYXZH1XXK5h+yBdfE7dCGQC+FiHISDTdTgPm6QKPXUgtGOGTg2NTu0E8RMhLiIzdlZ7t3lMH8B5pPHtLJPnID5QdduThpz1wNx0E4bEa/2Gi7UsS0xcUwA3Ahf3JvJZ2eDgZ/fin9Z2OpXHw5PzbrsslT9FvkGxrmp7xe4dtHmrc6gmYcBhrAOu9eUF2F2hi4xWdD+qM3NWiXis6+/VACOT1U7MnIfOjdj5fqV5XNfO5xAu3S7kMcMi3XGO02xUuWuD+Z6o1fx2QEyf+VrgLhk9U2oARwys3xIbM61IF9ba4US2ypWaCigMT9ajAsCze1bTQjgvs6eAVNAfIMtMNrjus2n3In1djKP+VEUPpqFDoXbXPdRdjYAGlSBWv+HR4Y+N6owQjYicR1Q4bOKe+I5pHjjkyLDx6e/Kbu1Op
 60ameFfA
 PEyyFJdl7QuR8a4gAV4jv3+mXabwIHC8XVqE9w+3+DylKPiS0MCnsqEcFiXqANwT32P1N6ND6r15wdzPB3rl9ODTYGAvhKlUyySTZRRLc8WLXAbkRPpcHH/j+omTfHLnnqWrTow4bFROtdyC07EDvz+uvzteKw5aM7Tpq0RqnFQ8uY5Wee+/uu1T0P44BZlMgzhKBr0j5/ZqS40w9n87+vHmw3/kuXtRLbMlc7ewQ8sblo91NaPDlxV51FBNetv3exh0WjoDciymD0xvAGWem3conhmJcgoC/GnOLAhDaW7rqdpo=
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

[19/36] dmaengine: qcom_hidma: remove conditional return with no effect
        commit: 04b8c3de13871653a8ecbd9f1adfea4d0694ecfe

Best regards,
-- 
~Vinod




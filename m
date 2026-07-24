Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5B835C531C9
	for <linux-mm@archiver.kernel.org>; Fri, 24 Jul 2026 21:48:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BA8EF6B007B; Fri, 24 Jul 2026 17:48:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B59456B0088; Fri, 24 Jul 2026 17:48:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A48846B008A; Fri, 24 Jul 2026 17:48:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 6CCA76B007B
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 17:48:29 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id CFB8A1601A6
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 21:48:28 +0000 (UTC)
X-FDA: 85025009496.18.E294AAA
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf03.hostedemail.com (Postfix) with ESMTP id 4C7122000B
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 21:48:27 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=bhpTuvSZ;
	spf=pass (imf03.hostedemail.com: domain of kuba@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kuba@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784929707;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GTdZSgSwBlfAlIxva5M6ZU/kD9VYoe26BBxVBJ5WdPE=;
	b=rdzcU0+E/M7ipttCVLsbke0kyyvg8k5KglIO5+vkZqko1dsw6mPC2y0pP8TpuIMaIBqYCe
	yIYDaLLVAnHaC5siVRR+XvU/pAL1Hf/Ak+0mjPTOJs+BT05HBK6ZQHYaSQlEGY5zx6A/W9
	NMKbqCS8U5lxVtcmMeJKtD+w4sSLsFU=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=bhpTuvSZ;
	spf=pass (imf03.hostedemail.com: domain of kuba@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kuba@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784929707;
	b=eMT8RIk886+R4JPobUni7evvy+Vr4psAMmvdCsJMlYSl33oKUoqJZVq3ba1c0VJHLlMWo3
	1EvLNW4obkl2enmfWiBEoFE7sam3XAzqQTUXRRAjQoE9u2Vo0V3avFlc/on1/PF6zLvUBw
	LmhwHzD+zwOu1WkFUbdKEbsI8U5Jeic=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 1DC3C60A60;
	Fri, 24 Jul 2026 21:48:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A6FC1F000E9;
	Fri, 24 Jul 2026 21:48:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784929705;
	bh=GTdZSgSwBlfAlIxva5M6ZU/kD9VYoe26BBxVBJ5WdPE=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=bhpTuvSZWBV7iq9keKc8+pixk18qLEuyMz3ZTlqKcB81KF/CnyeLGI6JSyvHGt9tA
	 E+SxQVBXcXsXsZgtn3HAr+6nPULrU5HRAYu13tTfnL5ffRJr3w0sXxS3y6FSy3SRlS
	 Qe3XQkADPgbjY9nioQHCBPR4pvKP4dL5d3HxM/ORX/63JYStNE+wqJy61XHcdbEpWF
	 xaZAuoqTpynwYjXBJP4BY73AhLP471MMWjcWFGi91teQEabAfmboMZJJ2AI9mVl919
	 5Vj52Ap+SYxCLa6sCvz56w/tCisRBng0kD6I+yiTKpyHAoJV1VexiywmsHK9mBuUsB
	 8QLvkwcrgPftA==
Date: Fri, 24 Jul 2026 14:48:22 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Sang-Heon Jeon <ekffu200098@gmail.com>
Cc: Julia.Lawall@inria.fr, Alex Deucher <alexander.deucher@amd.com>,
 Alexander Shishkin <alexander.shishkin@linux.intel.com>, Alexandre Belloni
 <alexandre.belloni@bootlin.com>, Andrew Lunn <andrew@lunn.ch>, Andrew
 Morton <akpm@linux-foundation.org>, Arkadiusz Kubalewski
 <arkadiusz.kubalewski@intel.com>, Borislav Petkov <bp@alien8.de>, Christian
 =?UTF-8?B?S8O2bmln?= <christian.koenig@amd.com>, Daniel Lezcano
 <daniel.lezcano@kernel.org>, David Airlie <airlied@gmail.com>, "David S.
 Miller" <davem@davemloft.net>, Dmitry Torokhov <dmitry.torokhov@gmail.com>,
 Eric Dumazet <edumazet@google.com>, Florian Westphal <fw@strlen.de>, Greg
 Kroah-Hartman <gregkh@linuxfoundation.org>, Hans de Goede
 <hansg@kernel.org>, Hans Verkuil <hverkuil@kernel.org>, Heikki Krogerus
 <heikki.krogerus@linux.intel.com>, Herbert Xu
 <herbert@gondor.apana.org.au>, Ilpo =?UTF-8?B?SsOkcnZpbmVu?=
 <ilpo.jarvinen@linux.intel.com>, "James E.J. Bottomley"
 <James.Bottomley@HansenPartnership.com>, Jani Nikula
 <jani.nikula@linux.intel.com>, Jaroslav Kysela <perex@perex.cz>, Jason
 Gunthorpe <jgg@ziepe.ca>, Jiri Pirko <jiri@resnulli.us>, "Joerg Roedel
 (AMD)" <joro@8bytes.org>, Johan Hovold <johan@kernel.org>, Jonathan Cameron
 <jic23@kernel.org>, Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
 Julian Anastasov <ja@ssi.bg>, Leon Romanovsky <leon@kernel.org>, Liam
 Girdwood <lgirdwood@gmail.com>, Linus Walleij <linusw@kernel.org>, Maarten
 Lankhorst <maarten.lankhorst@linux.intel.com>, Mark Brown
 <broonie@kernel.org>, "Martin K. Petersen" <martin.petersen@oracle.com>,
 Matthew Sakai <msakai@redhat.com>, Mauro Carvalho Chehab
 <mchehab@kernel.org>, Maxime Ripard <mripard@kernel.org>, Michael Turquette
 <mturquette@baylibre.com>, Mike Rapoport <rppt@kernel.org>, Miri Korenblit
 <miriam.rachel.korenblit@intel.com>, Nicolas Palix <nicolas.palix@imag.fr>,
 Pablo Neira Ayuso <pablo@netfilter.org>, Paolo Abeni <pabeni@redhat.com>,
 Ping-Ke Shih <pkshih@realtek.com>, "Rafael J. Wysocki" <rafael@kernel.org>,
 Rodrigo Vivi <rodrigo.vivi@intel.com>, Sebastian Reichel <sre@kernel.org>,
 Shuah Khan <shuah@kernel.org>, Simona Vetter <simona@ffwll.ch>, Simon
 Horman <horms@verge.net.au>, Stephen Boyd <sboyd@kernel.org>, Steve French
 <sfrench@samba.org>, Takashi Iwai <tiwai@suse.com>, Thomas Renninger
 <trenn@suse.com>, Thomas Zimmermann <tzimmermann@suse.de>, Tony Luck
 <tony.luck@intel.com>, Tvrtko Ursulin <tursulin@ursulin.net>, Vadim
 Fedorenko <vadim.fedorenko@linux.dev>, Vinod Koul <vkoul@kernel.org>, Will
 Deacon <will@kernel.org>, Yazen Ghannam <Yazen.Ghannam@amd.com>,
 cocci@inria.fr, amd-gfx@lists.freedesktop.org, dmaengine@vger.kernel.org,
 dm-devel@lists.linux.dev, dri-devel@lists.freedesktop.org,
 intel-gfx@lists.freedesktop.org, intel-wired-lan@lists.osuosl.org,
 iommu@lists.linux.dev, linux-cifs@vger.kernel.org,
 linux-clk@vger.kernel.org, linux-crypto@vger.kernel.org,
 linux-edac@vger.kernel.org, linux-gpio@vger.kernel.org,
 linux-iio@vger.kernel.org, linux-input@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
 linux-mm@kvack.org, linux-pm@vger.kernel.org, linux-rdma@vger.kernel.org,
 linux-rtc@vger.kernel.org, linux-s390@vger.kernel.org,
 linux-scsi@vger.kernel.org, linux-sound@vger.kernel.org,
 linux-usb@vger.kernel.org, linux-wireless@vger.kernel.org,
 lvs-devel@vger.kernel.org, netdev@vger.kernel.org,
 netfilter-devel@vger.kernel.org, nouveau@lists.freedesktop.org,
 platform-driver-x86@vger.kernel.org
Subject: Re: [PATCH 00/36] treewide: remove conditional returns with no
 effect
Message-ID: <20260724144822.6af8213f@kernel.org>
In-Reply-To: <20260723184538.3888637-1-ekffu200098@gmail.com>
References: <20260723184538.3888637-1-ekffu200098@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 4C7122000B
X-Stat-Signature: zzr587sdq4ijiuokdpoj5beddx639epj
X-HE-Tag: 1784929707-369758
X-HE-Meta: U2FsdGVkX1+eUrBjktoLZ0n1QgGmFMKhE/ez88RMSXK9UYFoM5g75y2t8m9hi8TCd7Pr9LAV7aP8FIylxoVWgxy6oOmnFrsjAGpFjpbqV3f/Cnz1CJP1FaaLJOZBfCQk0vqEzXsMsf4J+NPr6rU5JZH+b2F+UHmnhtW7CVil8u1L+k49XaI28QSC3X+qAcF7QI7RqhALYBvv2G2tV381SUr3q1TCnbbJMq80ob6vDZFerBq0hQIS+Rc0HdE2oDXpXGmZR3hHdtHll+/UnRawb911wjsNZYmNaLP/Y9/Q1nQDTsXKrp19KkvoTg0Du4c+6gDb1HXQyyVQl6F7grWw5H3qqfO8J6L5A7NrQYm6XD1G2/0FJi6HCz+wh2r5UwwgGpnP4J7UKs2rSLAXRz/qY6dyI2j5I7OshqIy6ydE4YYldnu+KkHvvdf8iWTFX4UCAXKLnuZbbIGRdksLMHErcg1ix1YqazNHSj9FDDCtOu8g9NIWVgKIc9wHUr4nQoIPqohWkCDILU5k/lrOxBCxsgpcuvUC7BXVF4/rzMvDcvrvWuSL2QAvP4bBB5fKYLYECLS4PYaOuX8z04PLudS406c/v+RczTW2FaXcu6wnKMEDZNoiLNpfhHcgvrVD/vQSsjeQpC+BW2c5yJHf2zkjZNrZumWeV/FCdcpkSnMj/VE3VqbWW6AsSclo4KMEjGClQpbpOapN+dNXlU9NlQiL8qHbRqMRZzeLdPXaXpB8MFz5lsOQCUrvQiIJcVYfA4+CSFj0Q558OwaxU9JhqkY5Mpoh4A9GQtOBXO2KO1oXd4JzjMLR5gvO0IRWTaxNp8lM0Onr/CB20fzRfhbl8v61EQ4f53571MdOGWq+Xc7zN6BgTejzET/JsOfPFKuf8AnaKZJp/TmklHWc2YCQ3715JLBLDxKohDiToeStYvOso6OlC9A7oMfS1eX+ztl4Jd9GzfJB+lE7m6SKYZWJCH4
 mzCBrWfX
 SwiaLetCZrqcVZr+jug896qMGsR+AnFgz5vE94ojdZtNxmhUjcX/QfR6tclaNrHShIbftV2rjCoaiy0z2yMPR/DZLnh2LNj6RIoVNtYbI0jdcte+ZbchHJBIbvei3DWJD/KuB6IpPf58njKLu59ZWmmCCIvMmYjSY5kOl4DndDbJUolBOPEai6p9ELWrGEnDgNzJJnU1PMYzoXwBk5pGsLD1f/Sj0B5VQijYxpk1dB4GVSeIzBDOHqkVJdzemtJW/NFd4SeNY58AskKMcjFSBSpU3Wv6TLSaf66LWOBsDDSokW7cx0TEJl8+dv1bG0/OV4irIgfIMrLYmzp4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 24 Jul 2026 03:45:02 +0900 Sang-Heon Jeon wrote:
> Patch 1 adds a Coccinelle script that matches the pattern, including
> negation and constant-comparison variants. Where a local variable is
> assigned right before the check, the assignment and the two returns
> turn into a single return of the assigned expression.

Huh, I thought we already had such script. Various script children have
been sending such "cleanups" in the past.

> Patches 2-36 are generated by the script, with hand fixes to restore
> unexpectedly removed comments and to fix the formatting checkpatch.pl
> complained about.

Please post patches 4,7,8,9 as a separate series. Since you only CCed
netdev on subset of the series patchwork thinks there are patches
missing and doesn't kick off any CI.


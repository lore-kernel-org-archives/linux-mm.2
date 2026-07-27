Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 97FF8C53219
	for <linux-mm@archiver.kernel.org>; Mon, 27 Jul 2026 08:30:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 317B26B007B; Mon, 27 Jul 2026 04:30:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2C8BC6B0088; Mon, 27 Jul 2026 04:30:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1BD8F6B008A; Mon, 27 Jul 2026 04:30:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id DADF26B007B
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 04:30:42 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 71043A06C2
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 08:30:42 +0000 (UTC)
X-FDA: 85033885524.10.AEBDD43
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	by imf27.hostedemail.com (Postfix) with ESMTP id 6146140003
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 08:30:38 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=JJvitefY;
	spf=pass (imf27.hostedemail.com: domain of jani.nikula@intel.com designates 192.198.163.17 as permitted sender) smtp.mailfrom=jani.nikula@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785141040;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Wun0I1dkmxfa8qNfn0OQhv2DA5hF2iEgMMGgkdL9fIM=;
	b=nruNjJAS428QUPgXrB+gWXKGaaDwKzm28zcYOeF7jcJtuZrl8OCRaTcS0jGMogSzBzRtFh
	4MBbWPy2tpXxKnShYEDKXrxBlMJwDvDSUeUddY79OZ661YQj7EMN7LjH1GMesyiYzHmL2A
	6bf6w1tJRJCfearzhjLURPYPzA9cFEw=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785141040;
	b=F05gCaq8SRhD9UWv75N7RNsY2wq68ZIdc4hlt8CVhKV8blOOUrN6x5mVGPhPOy43cD/3at
	DsmrCgmb2aq07uuBg0FNZYZVRcy87cZjdYCMyoYTptUJAzNYLsHrQDc3reX+ROG8NOqAvP
	T071tY1OcStH5Di9gHCO8RpnD7SPZZo=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=JJvitefY;
	spf=pass (imf27.hostedemail.com: domain of jani.nikula@intel.com designates 192.198.163.17 as permitted sender) smtp.mailfrom=jani.nikula@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1785141038; x=1816677038;
  h=from:to:cc:subject:in-reply-to:references:date:
   message-id:mime-version;
  bh=qWnqu6VCUiwZWG189ixa/W9uGeC6PMG4tY9t7kvdnXI=;
  b=JJvitefYLe07AMSyEpc7DGn/YG7kFCXhaQfVbbJwfTOYn6h27UZtCetQ
   2V4D8O/xI8P5Bf14SztgwaxdyU96ZuwNhG+epzZ6fjagj8hSR30fmfFUs
   xgnob9d5ZicLJa0BxT9MHmd3yl5YVfD7tw0X4nCY9U3xGV+9vqjt2ulOv
   DfdWmhKKbIetZJHGX6RJQaEMg08h7iZtBp07fzN7KE9jaBq2+XebY1ClZ
   brzHV5pVqGjHzXhGJY0j4TIiN6/PJ+3bW/7Fz0gL/ynYa8cL7sAK2GBcw
   hwPAJpvdutYUTe2SSMATAnwMjQt+OPo7F4kjL2TSqhVuGHpS8eHsdFUQ4
   Q==;
X-CSE-ConnectionGUID: Qnntyq90RaGvDXSVpCscVw==
X-CSE-MsgGUID: drhVodM6QMGoy8YMZftonQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11857"; a="85573899"
X-IronPort-AV: E=Sophos;i="6.25,188,1779174000"; 
   d="scan'208";a="85573899"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Jul 2026 01:30:34 -0700
X-CSE-ConnectionGUID: zuBRshsISau4U4oJl9pq1g==
X-CSE-MsgGUID: S6JnVra9Qs26laDkF7yO1A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,188,1779174000"; 
   d="scan'208";a="259417611"
Received: from rvuia-mobl.ger.corp.intel.com (HELO localhost) ([10.245.245.197])
  by orviesa007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Jul 2026 01:30:04 -0700
From: Jani Nikula <jani.nikula@linux.intel.com>
To: Jakub Kicinski <kuba@kernel.org>, Sang-Heon Jeon <ekffu200098@gmail.com>
Cc: Julia.Lawall@inria.fr, Alex Deucher <alexander.deucher@amd.com>,
 Alexander Shishkin <alexander.shishkin@linux.intel.com>, Alexandre Belloni
 <alexandre.belloni@bootlin.com>, Andrew Lunn <andrew@lunn.ch>, Andrew
 Morton <akpm@linux-foundation.org>, Arkadiusz Kubalewski
 <arkadiusz.kubalewski@intel.com>, Borislav Petkov <bp@alien8.de>,
 Christian =?utf-8?Q?K=C3=B6nig?= <christian.koenig@amd.com>, Daniel Lezcano
 <daniel.lezcano@kernel.org>, David Airlie <airlied@gmail.com>, "David S.
 Miller" <davem@davemloft.net>, Dmitry Torokhov
 <dmitry.torokhov@gmail.com>, Eric Dumazet <edumazet@google.com>, Florian
 Westphal <fw@strlen.de>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 Hans de Goede <hansg@kernel.org>, Hans Verkuil <hverkuil@kernel.org>,
 Heikki Krogerus <heikki.krogerus@linux.intel.com>, Herbert Xu
 <herbert@gondor.apana.org.au>, Ilpo =?utf-8?Q?J=C3=A4rvinen?=
 <ilpo.jarvinen@linux.intel.com>, "James E.J. Bottomley"
 <James.Bottomley@HansenPartnership.com>, Jaroslav Kysela <perex@perex.cz>,
 Jason Gunthorpe <jgg@ziepe.ca>, Jiri Pirko <jiri@resnulli.us>, "Joerg
 Roedel
 (AMD)" <joro@8bytes.org>, Johan Hovold <johan@kernel.org>, Jonathan Cameron
 <jic23@kernel.org>, Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
 Julian Anastasov <ja@ssi.bg>, Leon Romanovsky <leon@kernel.org>, Liam
 Girdwood <lgirdwood@gmail.com>, Linus Walleij <linusw@kernel.org>, Maarten
 Lankhorst <maarten.lankhorst@linux.intel.com>, Mark Brown
 <broonie@kernel.org>, "Martin K. Petersen" <martin.petersen@oracle.com>,
 Matthew Sakai <msakai@redhat.com>, Mauro Carvalho Chehab
 <mchehab@kernel.org>, Maxime Ripard <mripard@kernel.org>, Michael
 Turquette <mturquette@baylibre.com>, Mike Rapoport <rppt@kernel.org>, Miri
 Korenblit <miriam.rachel.korenblit@intel.com>, Nicolas Palix
 <nicolas.palix@imag.fr>, Pablo Neira Ayuso <pablo@netfilter.org>, Paolo
 Abeni <pabeni@redhat.com>, Ping-Ke Shih <pkshih@realtek.com>, "Rafael J.
 Wysocki" <rafael@kernel.org>, Rodrigo Vivi <rodrigo.vivi@intel.com>,
 Sebastian Reichel <sre@kernel.org>, Shuah Khan <shuah@kernel.org>, Simona
 Vetter <simona@ffwll.ch>, Simon Horman <horms@verge.net.au>, Stephen Boyd
 <sboyd@kernel.org>, Steve French <sfrench@samba.org>, Takashi Iwai
 <tiwai@suse.com>, Thomas Renninger <trenn@suse.com>, Thomas Zimmermann
 <tzimmermann@suse.de>, Tony Luck <tony.luck@intel.com>, Tvrtko Ursulin
 <tursulin@ursulin.net>, Vadim Fedorenko <vadim.fedorenko@linux.dev>, Vinod
 Koul <vkoul@kernel.org>, Will
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
Subject: Re: [PATCH 00/36] treewide: remove conditional returns with no effect
In-Reply-To: <20260724144822.6af8213f@kernel.org>
Organization: Intel Finland Oy - BIC 0357606-4 - c/o Alberga Business Park,
 6 krs Bertel Jungin Aukio 5, 02600 Espoo, Finland
References: <20260723184538.3888637-1-ekffu200098@gmail.com>
 <20260724144822.6af8213f@kernel.org>
Date: Mon, 27 Jul 2026 11:30:01 +0300
Message-ID: <0ee1ef4aa7daa908bf28397ccc639c89b6aabd9c@intel.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 6146140003
X-Stat-Signature: rxct66m4r96wqgqfrgxexu5rrist8j3x
X-Rspam-User: 
X-HE-Tag: 1785141038-485080
X-HE-Meta: U2FsdGVkX18vPB2x7PCkZeNcpK7q0lSunxuu1XPLITHFPYSo073U2V3hbNMwy8Zc5UlVLZAm4VomfxIz9tpNJ/eyq1N5fK3xm+jPXvKXVboRfN+adj9mDUA5U58iXGYIGg3G6CQKQObjJVBc/RCjszBNPoDLbA5w03qTqnx41jXTtSMwH8RctKeB92MB0yudC3V5Xhf6iRifykO4yJ+H0ukpxzttAhknqDUw4VBhzzNFiZ+HJ5MOzeWUoUreMvbfdughCfucKR23q5Frcrc4Lz5WK+s31IY3TuBkFB4Hqmmi8uvigz5torEVHR+7DJmLaR/daLUw2nfSnConxvLCeI4d2l//H73khBT9iEGbt7GuCAyDE47Zs7WXIlwmmJ+WrN+O064GAOvy/vt86kN7G5IBANVsq7DPXXZWL7FWOey0716BLLk4KnmzsBIB5pxmPGSYHisZvDYOW+1b1wVo6iKFujUwm1pNPue++g2nVUnK0vQe5wH7zb+WHf0EZsTJWvJGfoAeXPhHjTwJoA/TIv43Lj2ZC7QJApV8HdoMJcwHv+6jcGZFYwao3CeMsS/jAAaZ2LvK42FMEQ6FVyLLnPz2Yd/IxgfbMhrsD3ExAjid+Z7SPyv3K1XV/J/RKZjmuQenG4HtEGp4BNiOCNyeP6zC6Ohv3YSlKmvKJrvSFTrUIMxnUQj4cmGbKUooYOMmuFtRYjm9WjQTzPc1SSTRHrc/C6VaDVu5Dst8hMmSeWYgFq9DbBtLBBi02iIeydt5pCZgrRGpE4VJOIVT0HJj2kSgP0R/7e/m9T2EwTgEuqxp3siG3lFrp/kiX+h3DslkfK1NQHRythJZ2LcOddNEXX4tFjGRdjCkT1HeiDuVgdWt3T2bixxgZ69wgZ/5yzL+RJtEgE8ES2yZYSFkuifZqBKZ2Sct/J15o/0F1o3WaZ6i2e5RDrY6PJrjcujPiSYZoxWvSxEA9dfhDrSsqHa
 B2M8EdTt
 04IG7i412zJM8j6dQI4Ze0t9dtFTj1+Df0IoNzevt7HY/iY4yNkvRtVQiTsNLwXDSPlVNYO3dRawUa9MoQTD7sdQrysm906tTJKJe64jZQpc/OuTCVLH5N23t4YbGIOYiwqThEDAzPAMoqLtZib5rjMvFvcXO5mnyip6LvfszQ05KwZVxYW12rlv/mxumYg9Z6BYwqKiC0IfxX1wvj3/A0OD0e5RUMiX8b24fUjpCkLBxUmfEyLVDL5NGQCniVYRZ+81LyecVArMIyHV2ycSwLj3GvHZ7GSdYxEbLMO7mVAKdaoesKpnJJ4nSiWDDiGgAqJVPvsPPt6Ct6A8oMl21Ueoki/FvCCDyBejePNbKgEX7Y9TvwlVDHkGQFKXm8N7uddy3JZs92E7zV00Un8jxzPVSwpfGO1w2T/4eglyGy4+2o31MEGSFGjkazadtxzRQntQ8X7HdMQ5ZzQWq3Y1muOedHUrgzqNYKJyWQbmsewhEdsdVvdoCciePGA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 24 Jul 2026, Jakub Kicinski <kuba@kernel.org> wrote:
> On Fri, 24 Jul 2026 03:45:02 +0900 Sang-Heon Jeon wrote:
>> Patch 1 adds a Coccinelle script that matches the pattern, including
>> negation and constant-comparison variants. Where a local variable is
>> assigned right before the check, the assignment and the two returns
>> turn into a single return of the assigned expression.
>
> Huh, I thought we already had such script. Various script children have
> been sending such "cleanups" in the past.

We did, and it was removed, I believe in 1a617a8475e8 ("coccinelle:
misc: remove "complex return code" warnings"), because people just don't
want this constant churn.

It's perfectly fine to have the error case and happy day scenario
separated.


BR,
Jani.


-- 
Jani Nikula, Intel


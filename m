Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 11E42C53219
	for <linux-mm@archiver.kernel.org>; Mon, 27 Jul 2026 11:37:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E8B8C6B00C0; Mon, 27 Jul 2026 07:37:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E3BC76B00C1; Mon, 27 Jul 2026 07:37:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D2AF06B00C2; Mon, 27 Jul 2026 07:37:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 95B986B00C0
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 07:37:32 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id F10E9A10B8
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 11:37:31 +0000 (UTC)
X-FDA: 85034356302.21.613A331
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	by imf02.hostedemail.com (Postfix) with ESMTP id D122C8000C
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 11:37:28 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=G8mXo8Vi;
	spf=pass (imf02.hostedemail.com: domain of jani.nikula@intel.com designates 198.175.65.10 as permitted sender) smtp.mailfrom=jani.nikula@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785152250;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/6ix+2ekyEjmxtNQWG+EytAOJTxYlBnpiXnHByYObJw=;
	b=GnbLy/pohiRIXKpu66sK+aZYvWPSsJieGAXykKqyxvyPKeJzFmzSCYUNcau93Lk0xOB6xM
	TLphIR44NLVxHYadpWNu0S2mHIiAAUsN6xUCo2PX9Sfyf8Gtur3Grzzp9MalhvBG8ccWnC
	Rl44FsF2pyvVgmt9SW4/pX/EQ+x7kV4=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=G8mXo8Vi;
	spf=pass (imf02.hostedemail.com: domain of jani.nikula@intel.com designates 198.175.65.10 as permitted sender) smtp.mailfrom=jani.nikula@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785152250;
	b=TwxFruWdTGk6NC17hCk5b+Iu5FneiYqODLjRCAdDq7fS0fPb8kymZxBNsSKibIWBvVkOmC
	efrrfjoAhm8R0JAavZM4BbWVz66o16d9t78zZZYyRvvjJPc0VNeVGnr05T7alG2ynQJodD
	ZRyLV3ci3MWvOxnlq1j/IdgYMrEevK8=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1785152249; x=1816688249;
  h=from:to:cc:subject:in-reply-to:references:date:
   message-id:mime-version:content-transfer-encoding;
  bh=/6ix+2ekyEjmxtNQWG+EytAOJTxYlBnpiXnHByYObJw=;
  b=G8mXo8Viqf78xazk9zqbaR8AWKxx3t4VL7oDFw8rAxZ9fV31PanygXol
   GYyxOcnS5F2KOuKBNxorVeH2MINx+MYePQnoH9fxc9PiSWr8QSuLttjKr
   kLW/v8fOVnB4+baLVXDnzBLLGhoO8FMdTKv+rSQtEK8qXX4b5+P2pn29+
   S3bjjeywJrbVeKzapB0yAndUCmJWqOannRsMDFgBgD8QOQAyXHny7F/GV
   +QrqO7gjFmlTJbFT/0mLoOZmxeV/KSvGIl4QJLLKSnr4cC6O0AoXqfTSv
   gWy8eEN7OdOn0swD6VSJjgjsaTmugDFCUwuPsuX4IXK4Jz6UoJQ1cCPB/
   Q==;
X-CSE-ConnectionGUID: rVuBMxM0Teuv4jSFggaTug==
X-CSE-MsgGUID: qR2uCmc3S2+VY6ETJxIklA==
X-IronPort-AV: E=McAfee;i="6800,10657,11857"; a="103128687"
X-IronPort-AV: E=Sophos;i="6.25,188,1779174000"; 
   d="scan'208";a="103128687"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Jul 2026 04:37:27 -0700
X-CSE-ConnectionGUID: jc740gvBSCmfJ/AOeJRN5Q==
X-CSE-MsgGUID: 4x0a30kMTGOmwHJgJde0/Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,188,1779174000"; 
   d="scan'208";a="297617694"
Received: from rvuia-mobl.ger.corp.intel.com (HELO localhost) ([10.245.245.197])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Jul 2026 04:37:02 -0700
From: Jani Nikula <jani.nikula@linux.intel.com>
To: Sang-Heon Jeon <ekffu200098@gmail.com>
Cc: Jakub Kicinski <kuba@kernel.org>, Julia.Lawall@inria.fr, Alex Deucher
 <alexander.deucher@amd.com>, Alexander Shishkin
 <alexander.shishkin@linux.intel.com>, Alexandre Belloni
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
 <James.Bottomley@hansenpartnership.com>, Jaroslav Kysela <perex@perex.cz>,
 Jason Gunthorpe <jgg@ziepe.ca>, Jiri Pirko <jiri@resnulli.us>, "Joerg
 Roedel (AMD)" <joro@8bytes.org>, Johan Hovold <johan@kernel.org>, Jonathan
 Cameron <jic23@kernel.org>, Joonas Lahtinen
 <joonas.lahtinen@linux.intel.com>, Julian Anastasov <ja@ssi.bg>, Leon
 Romanovsky <leon@kernel.org>, Liam Girdwood <lgirdwood@gmail.com>, Linus
 Walleij <linusw@kernel.org>, Maarten Lankhorst
 <maarten.lankhorst@linux.intel.com>, Mark Brown <broonie@kernel.org>,
 "Martin K. Petersen" <martin.petersen@oracle.com>, Matthew Sakai
 <msakai@redhat.com>, Mauro Carvalho Chehab <mchehab@kernel.org>, Maxime
 Ripard <mripard@kernel.org>, Michael Turquette <mturquette@baylibre.com>,
 Mike Rapoport <rppt@kernel.org>, Miri Korenblit
 <miriam.rachel.korenblit@intel.com>, Nicolas Palix
 <nicolas.palix@imag.fr>, Pablo Neira Ayuso <pablo@netfilter.org>, Paolo
 Abeni <pabeni@redhat.com>, Ping-Ke Shih <pkshih@realtek.com>, "Rafael J.
 Wysocki" <rafael@kernel.org>, Rodrigo Vivi <rodrigo.vivi@intel.com>,
 Sebastian Reichel <sre@kernel.org>, Shuah Khan <shuah@kernel.org>, Simona
 Vetter <simona@ffwll.ch>, Simon Horman <horms@verge.net.au>, Stephen Boyd
 <sboyd@kernel.org>, Steve French <sfrench@samba.org>, Takashi Iwai
 <tiwai@suse.com>, Thomas Renninger <trenn@suse.com>, Thomas Zimmermann
 <tzimmermann@suse.de>, Tony Luck <tony.luck@intel.com>, Tvrtko Ursulin
 <tursulin@ursulin.net>, Vadim Fedorenko <vadim.fedorenko@linux.dev>, Vinod
 Koul <vkoul@kernel.org>, Will Deacon <will@kernel.org>, Yazen Ghannam
 <Yazen.Ghannam@amd.com>, cocci@inria.fr, amd-gfx@lists.freedesktop.org,
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
Subject: Re: [PATCH 00/36] treewide: remove conditional returns with no effect
In-Reply-To: <CABFDxMFMOAZ_3kYxEGCutnGt1OSSmgvmwx-=M1RxGc3VGKORYQ@mail.gmail.com>
Organization: Intel Finland Oy - BIC 0357606-4 - c/o Alberga Business Park,
 6 krs Bertel Jungin Aukio 5, 02600 Espoo, Finland
References: <20260723184538.3888637-1-ekffu200098@gmail.com>
 <20260724144822.6af8213f@kernel.org>
 <0ee1ef4aa7daa908bf28397ccc639c89b6aabd9c@intel.com>
 <CABFDxMFMOAZ_3kYxEGCutnGt1OSSmgvmwx-=M1RxGc3VGKORYQ@mail.gmail.com>
Date: Mon, 27 Jul 2026 14:36:57 +0300
Message-ID: <a4703624643e1d2fd1a9dedc1d36ce5d34d3133f@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Queue-Id: D122C8000C
X-Rspamd-Server: rspam01
X-Stat-Signature: aqsmzcpd8ewiybeuz9ug3eg83gotg1pw
X-HE-Tag: 1785152248-906074
X-HE-Meta: U2FsdGVkX1/4ACl4DdtbtJRktf1JCaS7m/YtAIg/zwJFVJVBRDLopEp4HGGigMktprPa75+6vYBYAGFmaogr0vEhEX6kfCqAR9vbLEbiaoRZYTQwGnZO1UYJFltY14amI/V8O/yBtJvqldvR0QhZzXatDL3/yPPjZb/TndvkWBE5V7Q47JFB46wAHydAv8mfca5qXXNBVCJ8B5QV7Fs0AP+64n3DmEUHQJmoLY9NAQFPwoeGyq6dsPjZ/1jsglTvY4wydsJ0hC7hLwM0hNnZBOFOewPN4kvbHWJU99I0ETCXIQi6gGasicw+DW0UgCbrI//pHgfSdGg2zETG9thXoywzydXlooeE9uwVQ8rO3ZlpNRoI8StguR4VeHJuhUtOrEospXyU8x6FC1xQbvY+BMUdCV3oKO9qg01aAS2ni9Fcoez3sAjn02JEHnSkrRbfJ35qceg5dp0peZm6BCHELfDi7dFR7aYxvmruu6nod0CewCHrg6+UVKphI/x1NsT+B6mZEkD+69typnvZYEG+HYN226bDLGqxC+AZ0gJDaMpBZaKbfDU+tHBHb4UZ4NroeR8nqIhiH7ccFVrI1ceXVdDmcGCq7k+hetwE8Svg112ymC+CtgbzLmSd0unFjXYTczUMPuwg2St4muvPo3kupweycMWs/y/bkZwju19ag0k2fKFZhLBMjNa1qZ5Lacpso/hobaBOXe+uIsFvkRFt7b/gqi6TY7jM0b/xyQA9gbltp/70ExtIsZXwU4FNATYzxtsbuPyfKcwZsm9SynQDM3GBhQX3b/nI0BXXN/FRC2jSnq6lo1svHu7D29DJr7mg6/JVvGAmk228pCzCuool2kcrMUd9YB4vyv8BXJl2ikqdYnL2MkfoGS7cLB1X5t+N6o0Hf/LFu5/XBHvz8ysih0pKDUIcjfXYHqP2lyQGy/VTRFgdHelP/+6wloFjUZd9oZC/0oslIrcxdIfSQaN
 4DYWmwLp
 R8MQmkFsUR+wMiuLYcvjKCVgJEGQgj9tAcURxef5jMBWXRRps2CfDsmOQm5EKtJfMGcM5XhsNNGoS9c2RpHUS14Uz1Bx/AxLqBn0qchKUmNYbiz6k9mj2OGUHDbmmRb5el0+rLLXr6MFtzDyEA1oRyZCQeqyxbnQMGgYLfx0JIJ/a0ffTuCsLAKtHV7eo6J6V9Ywyo1m10R45AUB678Mjo1H1EIOFQT0607mxl2ZOWGfn+ZNWK3c7aEHFJDlj9kDBQx2WmqcM0I2PMvC3JZm1PSZb9K51u/SbM/NjrCB85fAmQwZ3J5rvzjf6qcWUeoon5I1qRLgEDYnNdIExcPV0dLV+o0N84TUEkEDhusRnN8d4pFXb/KmiTj5M4XOHnn87wX1iim6sNt/QXNJqEm0Th1zn5ULBQec/y6t8jLgzuijHlvKT2KDIkRh+9d0Mt7YTvmXDj6xDbyb4uQlC1WxbeEvgf3Z8ZGU8aQOCQG0EcCiAWOdYwzXK3cdaoWZCaiJ+G3ZZcA7KVCWMCZ5dLom3KsGG/tyBZpp1fBfbaJrx1DNzQDQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 27 Jul 2026, Sang-Heon Jeon <ekffu200098@gmail.com> wrote:
> Hello,
>
> On Mon, Jul 27, 2026 at 5:30=E2=80=AFPM Jani Nikula <jani.nikula@linux.in=
tel.com> wrote:
>>
>> On Fri, 24 Jul 2026, Jakub Kicinski <kuba@kernel.org> wrote:
>> > On Fri, 24 Jul 2026 03:45:02 +0900 Sang-Heon Jeon wrote:
>> >> Patch 1 adds a Coccinelle script that matches the pattern, including
>> >> negation and constant-comparison variants. Where a local variable is
>> >> assigned right before the check, the assignment and the two returns
>> >> turn into a single return of the assigned expression.
>> >
>> > Huh, I thought we already had such script. Various script children have
>> > been sending such "cleanups" in the past.
>>
>> We did, and it was removed, I believe in 1a617a8475e8 ("coccinelle:
>> misc: remove "complex return code" warnings"), because people just don't
>> want this constant churn.
>>
>> It's perfectly fine to have the error case and happy day scenario
>> separated.
>
> Thanks for sharing the history.
>
> I checked the mailing list. The removed script looks similar to the
> new one, but it is different. The removed script reported a
> conditional return followed by an explicit return 0, where the error
> case and happy day scenario are separated as you mentioned, and Johan
> also complained about this 10 years ago.
>
> But the new script only reports when both branches return the same
> variable, not the explicit 0. So, I think the new script is close to
> the restricted version that Julia mentioned 10 years ago, and it
> should be acceptable.

ret =3D=3D=3D 0 after an if (ret) return.

BR,
Jani.


>
>>
>> BR,
>> Jani.
>>
>>
>> --
>> Jani Nikula, Intel
>
> Best Regards,
> Sang-Heon Jeon

--=20
Jani Nikula, Intel


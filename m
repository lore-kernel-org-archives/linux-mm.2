Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 36DB2C53219
	for <linux-mm@archiver.kernel.org>; Mon, 27 Jul 2026 11:08:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1D2CD6B00BC; Mon, 27 Jul 2026 07:08:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 15D916B00BD; Mon, 27 Jul 2026 07:08:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F421C6B00BE; Mon, 27 Jul 2026 07:08:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id BACDC6B00BC
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 07:08:48 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 39C58160666
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 11:08:48 +0000 (UTC)
X-FDA: 85034283936.06.A8683FC
Received: from mail-yw1-f171.google.com (mail-yw1-f171.google.com [209.85.128.171])
	by imf25.hostedemail.com (Postfix) with ESMTP id 4DEB5A0014
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 11:08:46 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=UpTxQJte;
	spf=pass (imf25.hostedemail.com: domain of ekffu200098@gmail.com designates 209.85.128.171 as permitted sender) smtp.mailfrom=ekffu200098@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785150526;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pV1TDUaa2YAV2kxJY3x35Y0FQXGiZRc6WWYevwzWDGg=;
	b=FyCS789wDYZYRzCqNRTIkOhqruemDcDvQpuI5BD3Dg1OxswX5dpCdJgBYh6zVQmgzh2H+g
	K2D+MhFMfas9/MgFnbws+qf5yUSKbdKFa9o61FaI/uEWJaP7w0xeEnJxc05XHnbH0kJJkC
	mLHe93L2BBt2j9K5665WxqsKKomVUqQ=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1785150526;
	b=a2C3NxHTPN5iee40aKHSimfqWkNhFwXGPRBwUYL1yX/w2/d8sGo10C3pTm6a0D6Fgp64q0
	2Y4TC3/joBxEI9bYZ+FH9LuqdzYwMVuk9Aq07N8I8agzu1GeSeXLsFYBunlHYhGg9R0HaN
	2nk4Zrf7AnLCIQ5td7H0RC0wFsdjn/0=
ARC-Authentication-Results: i=2;
	imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=UpTxQJte;
	spf=pass (imf25.hostedemail.com: domain of ekffu200098@gmail.com designates 209.85.128.171 as permitted sender) smtp.mailfrom=ekffu200098@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-yw1-f171.google.com with SMTP id 00721157ae682-81e86df8987so29996997b3.3
        for <linux-mm@kvack.org>; Mon, 27 Jul 2026 04:08:46 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1785150525; cv=none;
        d=google.com; s=arc-20260327;
        b=lTLA2jRESp8mJjvG+hSaNpH4wjjMK7MTaTTWnnr4vclGn98XvmX+xhnQLXTwUkurrA
         7nkFwn1U8/tqXE21rW7XmZDfVQpNXeKNdruwRY9IJTdWVQfxulAWKifp5v2yTQFeU8VS
         z15WRF05/S6VodYMcHbgzg1SMRZQNMQyTqQaYeVMnZqTsoDEoPM0bUQYg3nIWRjV816N
         Nqg3I0NJ8QXE6m2GPUiv7tdvb917sLZE2fMe/xbw4fzJ/IO6Sy4xT8+o15eKYdg5qLVy
         OZBh36PlqN5z/3eXp2u4qq7W9Nda/g3V2IX6bWH3x0+IAqVIMyB9oag/KTpwEZ6ojJJJ
         EBVg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=pV1TDUaa2YAV2kxJY3x35Y0FQXGiZRc6WWYevwzWDGg=;
        fh=TjI4sBQJVQrg/6XM82gqZ/ePq6TB9TRNU8EhZ1mACI0=;
        b=lmFpzPeZN5RSlH4S9WA3D/rAL5K+ZgGL0MZuT4tsAWvOMoR/HfsZKNRY7/cQrlvCwe
         j4ucf/h5D4WtBI5w/HJV3mWcs5ciaCd53SMkwpnVNmUp3dguFJJc1wSCB/4ur1svfjJN
         8rQMcDfdAmpcAOCEYDQtcX1T+eambtgEh65725pOlzTv/bzYfNvTZYpDtHedwVsWoECy
         Bjl7Rub9AtsEq9SBBKgF9PIqgru2Y8+do9Fu2F4SO+4rZEarfqTKlutq3s4qVhyTRsP7
         y95GB10aiVzDpCWS01OcVuWBWbQ2IatUqFQPXmCbJ3hdKEi3Ubd/l1NQpZjAF8awivIS
         N+gQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785150525; x=1785755325; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=pV1TDUaa2YAV2kxJY3x35Y0FQXGiZRc6WWYevwzWDGg=;
        b=UpTxQJteZttS9Z5fURipmnfyt029xQTeVda5kpZDAJ0drqwHwjBTWDiJVPOyVSqg+m
         VbTthgZIF8WKiZBVzrmgnaMr/7jL22nkFvToqdFbhi31FRS6MNK0aBuIda4N2UTSmvNM
         q7rFpOaySZ1pKvjIE0eOe39a9sZLfah14SDJvlYAnMlqOmFIXjhTtauaZrxdAc9COKjX
         vVLKLiJIS3qICgXCpZbL4B5X3eWL5Qmjh+qtUQXUy3cQmkuy8yJtLJFwcajvs3dDtKdm
         P4mzZmGbwiOccdmtHnO9YhUwGZQCdoFa2N+mtmQ8LNJNd31gNKLWoFovT5iOPZ3ap/IN
         kBQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785150525; x=1785755325;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=pV1TDUaa2YAV2kxJY3x35Y0FQXGiZRc6WWYevwzWDGg=;
        b=eq86SkpNgLKjimHp5sMGKHmwAsOKBkWf8Zk/zzM8awctu7yzElPLfUOiD36Gju5TXp
         Y25vUUqFD6OM6RCTCdEFnT6iQ3dfbaxe+yVO21ry13p6ikoa0MIIbpeIX8ZVIhPH/a69
         BEsyEv+GCnBWq3a8JTBnQU3nbP1/hmZrbf73Vez6MSC+Ot/HwiyH6I3oW2KCsLy0SZp3
         l5Suhvh3hzWv6WcNzrDk9Obbwz9UuG+u/uM1pC25CtSnvssfUBqNLw0ZTJf1zNHp/Rfu
         k2SGYluQ0EwptFDJ3+owFfxPEoVZgyt3Mz3CgO1RVbXkGNPScIjJm1iPJJ/PYOfY+Q1N
         ygzA==
X-Forwarded-Encrypted: i=1; AHgh+RowBRHWf5XG5fe3Pf14/kn7hYAhznGqp2wCAYOLvsQSf7PYL6fa/PZmo/S2NjQTn3j/HGgTiERhjQ==@kvack.org
X-Gm-Message-State: AOJu0YxmBGlTRqwXQCXsLGcngvtzYVbVV9hNO/AhdsKQ0cnoloBlDi/3
	Ic9bCk/dzmULrU7gOUJmJHPXjaT4kLiS27XTmbiFeDwRnXfVySJU58d7wEpe6ti057WLCKpHtYy
	ynEMORgJf5MxrpJFwLEsJDcUT6+QmoK4=
X-Gm-Gg: AR+sD13+xeuC61e+KhNIfg2282l4UBu+M8tBRTPJ8ZfU3mUpsc3XD/0T5shUH1J8Ko+
	NGDVVF7I5QWo//LfVCLi7tbqdzAMg+oWFh/hozcNtHYk/X7M+RMkfgX7ytwht8t8s9HNJDJ66qj
	1u/2kyZyjikCdPpcvre4fUK8WQwpyTDtM5RkYS5HIw2lj81voRNmJeOLFhOkY/Z6NntE18/XJaU
	P/oXXkku1xJ6EYGfSfbkGqNjRXQChqDLxaJypLc2fQcKeXVk6RaXSVd66U=
X-Received: by 2002:a05:690c:3747:b0:809:86c6:ee18 with SMTP id
 00721157ae682-81f69e3978bmr27868337b3.37.1785150525277; Mon, 27 Jul 2026
 04:08:45 -0700 (PDT)
MIME-Version: 1.0
References: <20260723184538.3888637-1-ekffu200098@gmail.com>
 <20260724144822.6af8213f@kernel.org> <0ee1ef4aa7daa908bf28397ccc639c89b6aabd9c@intel.com>
In-Reply-To: <0ee1ef4aa7daa908bf28397ccc639c89b6aabd9c@intel.com>
From: Sang-Heon Jeon <ekffu200098@gmail.com>
Date: Mon, 27 Jul 2026 20:08:33 +0900
X-Gm-Features: AUfX_mzhfgKW48GB4CRuyNKliFu1x1EH8aDGDqYePXeE0rGOBX3Wid5IOU1hKpc
Message-ID: <CABFDxMFMOAZ_3kYxEGCutnGt1OSSmgvmwx-=M1RxGc3VGKORYQ@mail.gmail.com>
Subject: Re: [PATCH 00/36] treewide: remove conditional returns with no effect
To: Jani Nikula <jani.nikula@linux.intel.com>
Cc: Jakub Kicinski <kuba@kernel.org>, Julia.Lawall@inria.fr, 
	Alex Deucher <alexander.deucher@amd.com>, 
	Alexander Shishkin <alexander.shishkin@linux.intel.com>, 
	Alexandre Belloni <alexandre.belloni@bootlin.com>, Andrew Lunn <andrew@lunn.ch>, 
	Andrew Morton <akpm@linux-foundation.org>, 
	Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>, Borislav Petkov <bp@alien8.de>, 
	=?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>, 
	Daniel Lezcano <daniel.lezcano@kernel.org>, David Airlie <airlied@gmail.com>, 
	"David S. Miller" <davem@davemloft.net>, Dmitry Torokhov <dmitry.torokhov@gmail.com>, 
	Eric Dumazet <edumazet@google.com>, Florian Westphal <fw@strlen.de>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Hans de Goede <hansg@kernel.org>, 
	Hans Verkuil <hverkuil@kernel.org>, Heikki Krogerus <heikki.krogerus@linux.intel.com>, 
	Herbert Xu <herbert@gondor.apana.org.au>, 
	=?UTF-8?Q?Ilpo_J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>, 
	"James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>, Jaroslav Kysela <perex@perex.cz>, 
	Jason Gunthorpe <jgg@ziepe.ca>, Jiri Pirko <jiri@resnulli.us>, "Joerg Roedel (AMD)" <joro@8bytes.org>, 
	Johan Hovold <johan@kernel.org>, Jonathan Cameron <jic23@kernel.org>, 
	Joonas Lahtinen <joonas.lahtinen@linux.intel.com>, Julian Anastasov <ja@ssi.bg>, 
	Leon Romanovsky <leon@kernel.org>, Liam Girdwood <lgirdwood@gmail.com>, Linus Walleij <linusw@kernel.org>, 
	Maarten Lankhorst <maarten.lankhorst@linux.intel.com>, Mark Brown <broonie@kernel.org>, 
	"Martin K. Petersen" <martin.petersen@oracle.com>, Matthew Sakai <msakai@redhat.com>, 
	Mauro Carvalho Chehab <mchehab@kernel.org>, Maxime Ripard <mripard@kernel.org>, 
	Michael Turquette <mturquette@baylibre.com>, Mike Rapoport <rppt@kernel.org>, 
	Miri Korenblit <miriam.rachel.korenblit@intel.com>, Nicolas Palix <nicolas.palix@imag.fr>, 
	Pablo Neira Ayuso <pablo@netfilter.org>, Paolo Abeni <pabeni@redhat.com>, 
	Ping-Ke Shih <pkshih@realtek.com>, "Rafael J. Wysocki" <rafael@kernel.org>, 
	Rodrigo Vivi <rodrigo.vivi@intel.com>, Sebastian Reichel <sre@kernel.org>, Shuah Khan <shuah@kernel.org>, 
	Simona Vetter <simona@ffwll.ch>, Simon Horman <horms@verge.net.au>, Stephen Boyd <sboyd@kernel.org>, 
	Steve French <sfrench@samba.org>, Takashi Iwai <tiwai@suse.com>, Thomas Renninger <trenn@suse.com>, 
	Thomas Zimmermann <tzimmermann@suse.de>, Tony Luck <tony.luck@intel.com>, 
	Tvrtko Ursulin <tursulin@ursulin.net>, Vadim Fedorenko <vadim.fedorenko@linux.dev>, 
	Vinod Koul <vkoul@kernel.org>, Will Deacon <will@kernel.org>, 
	Yazen Ghannam <Yazen.Ghannam@amd.com>, cocci@inria.fr, amd-gfx@lists.freedesktop.org, 
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
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 4DEB5A0014
X-Stat-Signature: g99se1995rtyctruhbjc6eizpp73bdqg
X-Rspam-User: 
X-HE-Tag: 1785150526-473364
X-HE-Meta: U2FsdGVkX18TpICSgUMiHxmt3cfYqyn6sS6a2lJLblJQGsJoFQQT2q7iY0rzE6Qp/Q/N3OZos8mVDpsCgeK3hwB3rMGC90XIymDXfspfkr8CQrh/Fghi4zOvwWyw5ciQ0xaPV7QUl62OHylcreazLoMweaEMchgy3zvDXUw7f8bqubWx3unJIvOqWKs9peTymcbggXxI69YIyrVc3aXGYzbNB/pQIXpMuf4H+UcLj79OC66O6rw7zJg9uVeyEDM+QagR2jYEw3fdvd2IbYfD09Y41DCen/HTnalx8Ysde4PH612z7RNF5+kWVOID71gpqvb5lQFZiXdxcs1u8E1jI60nKJ88Glxo7Q7jdKkTTvhJ7indiKv3lSxWvZa4phGfQN0L5kS6MPk8pbVmyYs1Tvh4AQqaP8KpqEUChn/4Bz1nU6cMd3XOFegHl4VYUnEQvws+PcbbPU4xHMW/ECbv9F7dX/QQquc+aKRZ8kYQqYpOwtq+uW7T+QFYGeXCQIiIBVTk7GdW8z2RmATOyGAtziMS0DYLVGCIU2g1x81duojHkgek4px2DU5hNRCs3ZHdXqCeWHWDW/0TswOKaakAt7NjdqiXbc5bb7ZwN4Ur2EtKu90dVM+cR2pFMzPoeP2KslBjYhF9qeTNyEufqSsc1XmaFqeTM2MYbWr8K+sZJSszsSrJ7brHvJHakS+VhPQiYOcSeK3hCzXy0/YbHqRkqmx5eiSKpleuPtDfNRBg5iXqdR3aLcn4AzeomL2m7lsuQ8bYUShsPn0AuuDsDqsGdm+qdjmdj5XewTxXVZMfG1N8adqUubGpib9cKBXe5Gz0rs/e72MQuYe68gIpYceqpT72CNKW7rPtQMTGnjcGv+bLSVyxwrer5B9q36WJyIHs2m2UMNoxKQxQe38kqhOyG+74hWe7jxbW/31wXirKg16+C8DzUSaPlXbSYEuB3nvgpFWs+devN9RcDo/ffsC
 1qFGOOru
 4Tk70RNVkNVE5xSl8UfNnI8AVHjQlu0AWbQfOHA2DA84HPoUNVCLTHkzalzfAB3yn0ky4kd1SIoVEei/e3/eno6EfV7JCidu+1CSNdkkBzZg6fg1u/vCTLI4SN3GzPS7V0iqcZ5CJxD++3ekqfAMUeSorbLXdcKifTdL4Y2dUEqFwIRyHMJ1A9rU7pXibO+93g8W/mjiZ7v4JXETEZOXjVId3ycowlD9KCBMHDk3iTL6M7EeFJ4na+0KCNIgRUO11Q+lgvdpFkc9gIHW5d2gZC2O872bgJLN8nlWB4tFYtJXqUx2B217m5Joba+fv/J71L815NbX3XmyfiwH3aGoL8NSGCbRF/LO6gKqXxGI0OQIpvuXDP1Z15tGPCPPVoJjwV1QknBVoReVuJ3vBa6Ewd/Tx4obkxmJxkr+yRJmchnFJA27T43YPnFVL0w4KfYAceXTb8QFtMe/MtxpYBHv0XugTSw0+Uy4OO6Kgjb3iBzWEAHvUGKZ7BpHAf34nSip89SMBjETygJLXSiQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello,

On Mon, Jul 27, 2026 at 5:30=E2=80=AFPM Jani Nikula <jani.nikula@linux.inte=
l.com> wrote:
>
> On Fri, 24 Jul 2026, Jakub Kicinski <kuba@kernel.org> wrote:
> > On Fri, 24 Jul 2026 03:45:02 +0900 Sang-Heon Jeon wrote:
> >> Patch 1 adds a Coccinelle script that matches the pattern, including
> >> negation and constant-comparison variants. Where a local variable is
> >> assigned right before the check, the assignment and the two returns
> >> turn into a single return of the assigned expression.
> >
> > Huh, I thought we already had such script. Various script children have
> > been sending such "cleanups" in the past.
>
> We did, and it was removed, I believe in 1a617a8475e8 ("coccinelle:
> misc: remove "complex return code" warnings"), because people just don't
> want this constant churn.
>
> It's perfectly fine to have the error case and happy day scenario
> separated.

Thanks for sharing the history.

I checked the mailing list. The removed script looks similar to the
new one, but it is different. The removed script reported a
conditional return followed by an explicit return 0, where the error
case and happy day scenario are separated as you mentioned, and Johan
also complained about this 10 years ago.

But the new script only reports when both branches return the same
variable, not the explicit 0. So, I think the new script is close to
the restricted version that Julia mentioned 10 years ago, and it
should be acceptable.

>
> BR,
> Jani.
>
>
> --
> Jani Nikula, Intel

Best Regards,
Sang-Heon Jeon


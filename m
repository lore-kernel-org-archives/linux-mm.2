Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4FDE6C5321C
	for <linux-mm@archiver.kernel.org>; Mon, 27 Jul 2026 12:59:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 143626B00F0; Mon, 27 Jul 2026 08:59:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 11C6E6B00F6; Mon, 27 Jul 2026 08:59:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E628D6B00F8; Mon, 27 Jul 2026 08:59:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A06076B00F0
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 08:59:45 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 040C31C0ECC
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 12:59:44 +0000 (UTC)
X-FDA: 85034563530.12.0E13238
Received: from mail-yw1-f171.google.com (mail-yw1-f171.google.com [209.85.128.171])
	by imf13.hostedemail.com (Postfix) with ESMTP id 215D520004
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 12:59:42 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="aK2rK/lt";
	spf=pass (imf13.hostedemail.com: domain of ekffu200098@gmail.com designates 209.85.128.171 as permitted sender) smtp.mailfrom=ekffu200098@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785157183;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ix29oOBbLOf7nlyiJN1FbRfyq7KaaHwmDtcPHELsDuI=;
	b=lREuHQR5HfLi45jFHIXVpa5LNkk7e6jTkqD7UOZwr/9Iagfne7lgFewSc+Lq4phtTqfLHS
	Fb/ds+UqR6dz8p7Or+Zn9OXwFaRpfB8537oEV0aQehk7sFfI0PKxL41lzE7pFlQwYZ1PcG
	58zCtGAwjiPuurPod9KCtVnlB+6KHY8=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1785157183;
	b=KxFKhzsKFy/h3X84UoAxWFQgJ6Vrc8g69DwNt2A6dbv+Y971NBrFAPg3P2NqVVYEgvQsV4
	+XWezHNen4KL6TPgFkGlEV6BC85joQUn7QvNCXlJCuC+qEsdIuBpJifsbr5TyAdp9x5DlZ
	v5VvFLV8l2arZcyzGxeqSPDRkbzQjwU=
ARC-Authentication-Results: i=2;
	imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="aK2rK/lt";
	spf=pass (imf13.hostedemail.com: domain of ekffu200098@gmail.com designates 209.85.128.171 as permitted sender) smtp.mailfrom=ekffu200098@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-yw1-f171.google.com with SMTP id 00721157ae682-81f36179d72so31143897b3.2
        for <linux-mm@kvack.org>; Mon, 27 Jul 2026 05:59:42 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1785157182; cv=none;
        d=google.com; s=arc-20260327;
        b=gF/pdIGfKCYLa37c65fJBR3D3PtS37G+x4zQ4hqu2afudyvTCyDeNDsrlhDmtGJdg5
         4WJzeWJUvELKlUyw6Ar6nCgwb+9OGWnFi37ZmVKJ8cM9JfD/TshSPjuWlcu+HwsqVIP8
         7Dki3YkAywI/L48vWJ7aoZGoKFR2z36cQyejchdA2olPksKHObsWOcVnk5Kb8TJO2X97
         tUTCoThP9ZZaZbkJcpD4DCLhmetvOkmexy9S63EakfQwww65NdCY1yuWUsGGTw7zXmat
         Gx/3bjaeraT+mbDBySrPMmUjlJ8m0eU4+ihX18SEVMOfQ61LKi2q0Maya5gsR4NkHpKB
         Nxfw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=ix29oOBbLOf7nlyiJN1FbRfyq7KaaHwmDtcPHELsDuI=;
        fh=5c50XVpHZXWHsrqPQDLtUFaNbln2Gy7XfmcvsKrbicY=;
        b=H/N1d1bRyNP91izJDZUIOmTzCn4/6RRR1SPzSAJ7PiSJ2NaouSbm+Wc2F3ii504hRh
         3Bdh+NeDEI1En5FnMMqiedssqG+7Wj8U9+HzXbaDQo+6ROfZcXBc2nvHKZ7Zq0TYCI5y
         AnvPWIpCbo9ygFAs+3ie/Blig8bl2xNFZc0d8N63yko1HG6EpfONM3B+co/sYY04GM13
         ERsmOI3gJ/Wltrr43qJgeyWQTzf9N/qcsV4d9rmSgsxrd2hu3i/rTqbJRDWWmUiT7sTo
         7DW2IamXJbLoD2QpzlOf8oAS+VEfDeEwdhjAl+KiIjqYrYYracHqyc+DSSV7P6tz+f1l
         fPFw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785157182; x=1785761982; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=ix29oOBbLOf7nlyiJN1FbRfyq7KaaHwmDtcPHELsDuI=;
        b=aK2rK/ltIGHSGnjUlrpFjg0pMJqgrINSavI2g1nb7YS0pLr1yBGcaqoqEKzBNsN+uh
         IaBF/VjSXGnUn4c5R4yit8lvNM6dSdgWdBRQktuPdc8VnNqODNNr2g75flT7w6T2iYmv
         UKlWkDnXZCvtrgqWRqxO2XywXf/L4CYJ/eYuJ089qA7/mK+faHjObB+9OcSSKuQ41X3e
         2eGh5t+H/v4QsVkRwtygSJ8HCfyWPp4SP4uYBKc6nyzxHfYf+xRHlXl3JZ3v3TuIRi7S
         OYGm5sOXOuPgS1iWMPyVKPVZKr9ewWBnlTux3KD5T2ojLzTLUNOYDSRftf/eBLbN4YyO
         qOJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785157182; x=1785761982;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ix29oOBbLOf7nlyiJN1FbRfyq7KaaHwmDtcPHELsDuI=;
        b=GFMcUYLF6v4p6j0qLQOpKPU+JFvPbXnm+jqnidQEeAUd4YgK620V08MDwv7pZIJH+A
         AA0Swok+RdfCBt0NHhy2eDnc1EDjDDY1Nn0mX3WV5lk4Fr4VMnL8tKpHKNiCWCvluGv2
         dQJtEF5PJMtsxnnoPQSbHOdSwchzB48foWNzGMbQ7fc1I2XwuIjhZNVxh+Njb4Gq1Iok
         0qfLnTEeERZDn941PwZvMV+517dvibZMseg0T5MVHhSx3BrWYgwwdKj8ZWAUXluOKGPb
         DIcUtBJPmEXhF+aiVUbIlpk35UiIV/iujFkAjSeJRUdrl6Z2oVYab2Qu0m2b+qAjUhIN
         hEGA==
X-Forwarded-Encrypted: i=1; AHgh+RrwH/yWRrQp4fSa9Cph196/KrDOxqlxrkPM74lnUKRtbRp3lQA7fSBAxziXz6MofekIGapTCc5B4Q==@kvack.org
X-Gm-Message-State: AOJu0YzDNTjsdsTrkkm2eOtg+UZhUEL7ciKoUrHACVc3AB+8ThkVwkuu
	hM7WVki8X2jpJrgF6sVRzJcxobvklMtzHqIP9HBZjnOWe4PnUKc/dFUy5qSqHZQbC0VdkwIuoCD
	KsdiiBUuUbKQemSo8+YETP/zRKeZJAuI=
X-Gm-Gg: AR+sD130S5IhJd+tVQXmvkooiq9Ky3Gs9sq5RqB+G7uxTw2Lsk5xXncxEd6HozG4e9E
	jgxlwXpL8vCO28BPizWfXbTIW26DObDbNExZ6iGVrgyVuj9mIkxrXIotuWi+UULa6dSMpR3eHUm
	AkWAsoVrevE8YFq/0b6kzL2kp9aI7wfO6KB3Y4oazmkWM9RTK4GwjriPwzL77XQOBgfitez6KVH
	eUPMtGWJMtn4UgcO2BzFLUBZ8J3pmhwMXIU/AlF+AJi1dRqgYaE4uES7l4unsV+jjeSWQ==
X-Received: by 2002:a05:690c:6f02:b0:81e:97e2:2210 with SMTP id
 00721157ae682-81f69ebac17mr31274727b3.69.1785157182142; Mon, 27 Jul 2026
 05:59:42 -0700 (PDT)
MIME-Version: 1.0
References: <20260723184538.3888637-1-ekffu200098@gmail.com> <adcfc6f2-3309-4496-8331-1ae31e85d363@sirena.org.uk>
In-Reply-To: <adcfc6f2-3309-4496-8331-1ae31e85d363@sirena.org.uk>
From: Sang-Heon Jeon <ekffu200098@gmail.com>
Date: Mon, 27 Jul 2026 21:59:30 +0900
X-Gm-Features: AUfX_mxOitBR08KsPWHGWKTOhvBmlqBsOevQYdsbBN1kI3uyZROYcZJFQfRk1pk
Message-ID: <CABFDxMEmB=5UZx6RZgFNZyB5sg-+e2hgx_T1QjV0JzqP+auTFQ@mail.gmail.com>
Subject: Re: [PATCH 00/36] treewide: remove conditional returns with no effect
To: Mark Brown <broonie@kernel.org>
Cc: Julia.Lawall@inria.fr, Alex Deucher <alexander.deucher@amd.com>, 
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
	Jakub Kicinski <kuba@kernel.org>, 
	"James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>, 
	Jani Nikula <jani.nikula@linux.intel.com>, Jaroslav Kysela <perex@perex.cz>, 
	Jason Gunthorpe <jgg@ziepe.ca>, Jiri Pirko <jiri@resnulli.us>, "Joerg Roedel (AMD)" <joro@8bytes.org>, 
	Johan Hovold <johan@kernel.org>, Jonathan Cameron <jic23@kernel.org>, 
	Joonas Lahtinen <joonas.lahtinen@linux.intel.com>, Julian Anastasov <ja@ssi.bg>, 
	Leon Romanovsky <leon@kernel.org>, Liam Girdwood <lgirdwood@gmail.com>, Linus Walleij <linusw@kernel.org>, 
	Maarten Lankhorst <maarten.lankhorst@linux.intel.com>, 
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
X-Rspamd-Queue-Id: 215D520004
X-Stat-Signature: 81geskhmno4q4e3rkdeq71awwnq9f5qy
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1785157182-113264
X-HE-Meta: U2FsdGVkX18dvmoVWhvKaqk5ux1/2EiRibA/hGuAQmMkraDXQYpAgHSbM9H1/cHp14rzKBO+f+m7IZCxAvVo9n59cbU0Wr8lGZrLY8c0pemL0z3D09q41BFLPbxVhRi9q4kXQxZ0BBBKkhgonRHCAy117SIHgNG6GHDKmV7v/+8ujjculI3Lm3Sa1aCIzBIyI6o4+E/8k0L5t/H0sLcJbxNyI+Gl3x33DYhVnaUg7SpPDANM5cd4H0Uid0VuFnkY2hH+BdggESndhARRVj4qHTTSRWNTZTqteMAfJbb+LafKbJ6QoO0/c+ErcdLCPE6SpyTxIsbbz6vzmtBWCjd0nIwih6CQ2hVV68bxnApViXF1y4WYH+p4NvWvMy/uKMwzQFEn5TqOg95dwxfYdp/dbGlAA0ohEONBVulvPITc6rfcNrbZ0mN078FbO1qsnpf1X6OPlOlljwkelN07VMYOlbQAmLgN6CH0n3piERzwCuSCWHpF3GFG/QzSyAp4uFSDpU38djuX4SzyuzLWQxB+C468rPRa8paTkcgPFpE0elUcUpGBSCfjN1Qr5B72WdoY7Tx2bkMqAhZEm3l8f/FY10TUvzrT4pEDv2CT2Xjpp/N9BJ6wb0HZIem/93NeylopWKVTl/HmF0MC89GSheEvjK5Xy8w2HNow1YbOoij9xBIAlUKLuUB28MwLkyAbFTraP4rTQf3acJgwYuWKaODu7AQS/aQfDKVK4z7VQlbGRpKXvIHHC2X5JexPHrzdOrJF/YVM+bu1QTmFGgBQSBDsQfZFyIFMCLXMStLvHaGt7vKwBLuk+1KczBYjBJAo4HB6K2aYTVddGGQr4DXF+Sdkc71BfChLiuxMBPj1Nly+w7YsNf4C64CHOx7MLruJaK1HMteeocs2AZYS7rS/+Zg3dpGA2H16KkjTcgUq0f27Fs1OIgWlPiWgJTowv24KGSgVkVKllEDns9r1tD3hFS3
 do5Uf0/a
 O1YIL7GyBYWPrIpapkSYDQ/qcLgV4YEV++CjwHi6iMvAVT/gyEpxr4leusQR4Q3GoRAIQNYnN0DZ7XT1+Hd9kITPswt2Kywkxhxk8AnIntgXsXuNTvgkx8yK7z4dJADhlhCqGbTfUxUEsqAdvFVTDsmtobw+Cioq4uQYN+pJtb7EgJmxzUD/5Q6wtAR3UK/8XKQHOw2BUPb1+wRFFt0of/wYtLtkJH9DfW3mkdUr6Dl/0R49voFa0jq9ySLN3KxW3MH4CfYhr8uSqwmz+2RgYeeybn+bB382J3CTB42YPgD38Vgq4S7si6VZvvN6KBdjCzlBlqLvCKSXfDKr1JwqapuLYKKwTOszzINahtOJgdttGo1FZ8+wbTGgjiXq8ju1hHOPOOtZV0q4wwh7M1aFvGWIEhQpXATefJWc4WOjKT4DmSdbjtAV21m7Bx+U5zqg6TMh49FtjeO3l11p7CNdaAdymj+VUBhDEzgGzp+uPKm7dfDKlxGAG+rbWgA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jul 27, 2026 at 9:12=E2=80=AFPM Mark Brown <broonie@kernel.org> wro=
te:
>
> On Fri, Jul 24, 2026 at 03:45:02AM +0900, Sang-Heon Jeon wrote:
>
> > All patches are independent and can be applied separately, but for
> > everyone's convenience, it would be nice if they were merged through
> > a single tree.
>
> Please don't do this, it does not make anything more convenient - it
> results in huge CC lists and makes it more difficult to work out who
> will actually apply things.  If there's no dependencies just send to
> each subsystem independently.

Thanks for letting me know. I'll keep that in mind. In v2, I will send
the cleanup patches to each subsystem independently.

Best Regards,
Sang-Heon Jeon


Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B5457CAC5B8
	for <linux-mm@archiver.kernel.org>; Mon,  6 Oct 2025 20:35:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 16DAA8E0017; Mon,  6 Oct 2025 16:35:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 11EA48E0002; Mon,  6 Oct 2025 16:35:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F015D8E0017; Mon,  6 Oct 2025 16:35:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id D78508E0002
	for <linux-mm@kvack.org>; Mon,  6 Oct 2025 16:35:10 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id A18E614073D
	for <linux-mm@kvack.org>; Mon,  6 Oct 2025 20:35:10 +0000 (UTC)
X-FDA: 83968843980.26.84F6381
Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	by imf05.hostedemail.com (Postfix) with ESMTP id A16E310000D
	for <linux-mm@kvack.org>; Mon,  6 Oct 2025 20:35:08 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="j/mLNtf0";
	spf=pass (imf05.hostedemail.com: domain of david.laight.linux@gmail.com designates 209.85.128.43 as permitted sender) smtp.mailfrom=david.laight.linux@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759782908;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=w8A8mrbjHOp4I+EQv9aLZuINyxZFXeZgTqLUL4/gbts=;
	b=dBVS0665pOrg28I3p+xqGl4gLwm3Lyo/i+UmB6+yhDlz516+MQr2GBNb5DhmkEZUu9B9Ma
	keOEAILV0ANOodHUzJcSuEbP6UhA2RKqggckNqNt6eKzgJ7X2HUgJEyzP9f/Jl/fmKDJYB
	FmWAdDTGhZHBST5JvJFNoG5zO2idezQ=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="j/mLNtf0";
	spf=pass (imf05.hostedemail.com: domain of david.laight.linux@gmail.com designates 209.85.128.43 as permitted sender) smtp.mailfrom=david.laight.linux@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759782908; a=rsa-sha256;
	cv=none;
	b=SQqG+duEt7DfQ5w5+2wq2XALynFpQvHWW6ec6onpdZs8+JUVabGGumh6aIgklLP7zlqukM
	jyksFhhaTtpqdql9xTQ/YOLSzD/ZdGs0ZeR25MbkyWGNtm25BDwKx9bmZEBswlURUulLu+
	Ve5IbIpOK0ExoeaOWIuVnuiIxH7RDT4=
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-46e542196c7so36021185e9.0
        for <linux-mm@kvack.org>; Mon, 06 Oct 2025 13:35:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1759782907; x=1760387707; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=w8A8mrbjHOp4I+EQv9aLZuINyxZFXeZgTqLUL4/gbts=;
        b=j/mLNtf0oGh6hT30hgdF/YfHzoFK7i2h1G140udnHQMELnmdEP8c81QoubLxPMduPz
         GP7Y6fVGx8YQuTqQXFG9Vm5CxUhlxrndOuKmfy7lx1BUq0Z2fyvFo0QRZW8i2xS5855+
         N4u+hH2NWy0n3v6MXoh7g4RpCphV3H6qi60a8n9m89QEVKyE17kTGQMfw2NoNGZ2Hp/T
         jnwV/NJ3X13Q2gV1RArjlAVprE7r/0zYUz7e2h4zBJHod/wRs9t1O4g9AwUQmPSQ4bWn
         iqMo8g1TeqLHCSjg8QlrEORCJkdJUgI3RaZHRwcLUyJcPlG0Q1jatvi0WwPraSlk8cap
         dgVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759782907; x=1760387707;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=w8A8mrbjHOp4I+EQv9aLZuINyxZFXeZgTqLUL4/gbts=;
        b=BNYBF6wl0RrS8HpkPId9xJXPISGpeqJ+jO6fMS9Ly7vVIY7b0fXmMyzGGlKTNQ7v9j
         wCvKdUPbwc5Vz84mrdQE3cyppHd7BFdS3Gxn9ssDh62zlgFCOiZXReoKdxu2JTmjjfjq
         6zgUdzSmaeP69DXD8AHZFyJgrpsEN1uKtcj0pZcWTJ2Pey4XGRUsz84fNLJ04HH9fWbk
         Pb19Iwiz7qXYwo0I7NyDILHGGOpX0XK86FDI9zKsL6xGcmQkNO/htu/HHAXnfmIhqJ8p
         0PjUGvV6uAUsOLY5dsJ7zKN25Ucnkvov0hllCSndapmYJIbwWIMAzcOE/FnPO14KZwNv
         pJow==
X-Forwarded-Encrypted: i=1; AJvYcCWz/Bth3NVpj3KDsLsaSA29P1RlvmlH8Qru4rN08Zft4luyxOHteWIVLJBCD9zTmrlghFL8oMK4/w==@kvack.org
X-Gm-Message-State: AOJu0Yx+d2JvT15uG/6+7szv5YcoACoOEnSnu+Ra9WP10eCqylbb/Ii4
	VeXd0jDekpAPoS69lxJXk4bxthlhznoGuTIBxEL5AzV1w+Py36XBo4vS
X-Gm-Gg: ASbGncvpE4u2FQmUAYS+YUZrF0nIOIsDNoixhAp0GQBTu8lV9Y6wdIFWZjn6+Jrw5+r
	p2jlNZFQ+N0Hdv1+wOxOREPd0+YDBHBmgIe3rjL8f2gm3kdAmiHKjt1OCyeNH/ek1E0hIG1hoFa
	0bm+LOsQN3slY+vZ4Wb8ZWQNCTmXKNNNr5lVN9uKGWzz8NzZB564SJ29f3ApUaNyIAvSS+66hvM
	1gmdljhaYb0B9PkRNm8/Z7sx04qL2VE89uE+UXcunaPSan27SwgA1QuvBBbtfSSgg+Iz3P1wcqQ
	0o36jNaUJ6qu3eURqeNM7KkvtHYX+x5h7EUaM0cZy5ek469HkSQ+5kunTGa0FAumadmU7YSI1CM
	LS68tQEi7IRpiJTh9VqF87Uz/imdb14tHi+Kabi00Drwv0dKrt7r0cHOBm/78xQo7Xvz95gVl33
	3Hlj7IkW1SA43w
X-Google-Smtp-Source: AGHT+IEnzSpQE+ROtayFnE2b4dPjTQF2CaZO9TdUfVNFcX6ejR4aNYCswD7XdVH/ajIMwYylIXY+YQ==
X-Received: by 2002:a05:600c:2287:b0:45d:d86b:b386 with SMTP id 5b1f17b1804b1-46fa29f13dfmr4596085e9.14.1759782906754;
        Mon, 06 Oct 2025 13:35:06 -0700 (PDT)
Received: from pumpkin (82-69-66-36.dsl.in-addr.zen.co.uk. [82.69.66.36])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-46e723591fcsm172334545e9.10.2025.10.06.13.35.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Oct 2025 13:35:06 -0700 (PDT)
Date: Mon, 6 Oct 2025 21:35:03 +0100
From: David Laight <david.laight.linux@gmail.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Eliav Farber <farbere@amazon.com>, dave.hansen@linux.intel.com,
 peterz@infradead.org, tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
 x86@kernel.org, hpa@zytor.com, james.morse@arm.com, rric@kernel.org,
 daniel@ffwll.ch, maarten.lankhorst@linux.intel.com, mripard@kernel.org,
 tzimmermann@suse.de, sean@poorly.run, jdelvare@suse.com,
 linux@roeck-us.net, linus.walleij@linaro.org, dmitry.torokhov@gmail.com,
 maz@kernel.org, wens@csie.org, jernej.skrabec@gmail.com, agk@redhat.com,
 snitzer@redhat.com, dm-devel@redhat.com, davem@davemloft.net,
 kuba@kernel.org, mcoquelin.stm32@gmail.com,
 krzysztof.kozlowski@canonical.com, malattia@linux.it, hdegoede@redhat.com,
 mgross@linux.intel.com, jejb@linux.ibm.com, martin.petersen@oracle.com,
 sakari.ailus@linux.intel.com, clm@fb.com, josef@toxicpanda.com,
 dsterba@suse.com, jack@suse.com, tytso@mit.edu, adilger.kernel@dilger.ca,
 dushistov@mail.ru, luc.vanoostenryck@gmail.com, rostedt@goodmis.org,
 pmladek@suse.com, senozhatsky@chromium.org,
 andriy.shevchenko@linux.intel.com, linux@rasmusvillemoes.dk,
 minchan@kernel.org, ngupta@vflare.org, akpm@linux-foundation.org,
 yoshfuji@linux-ipv6.org, dsahern@kernel.org, pablo@netfilter.org,
 kadlec@netfilter.org, fw@strlen.de, jmaloy@redhat.com,
 ying.xue@windriver.com, shuah@kernel.org, willy@infradead.org,
 sashal@kernel.org, quic_akhilpo@quicinc.com, ruanjinjie@huawei.com,
 David.Laight@aculab.com, herve.codina@bootlin.com,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 linux-um@lists.infradead.org, linux-edac@vger.kernel.org,
 amd-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
 linux-arm-msm@vger.kernel.org, freedreno@lists.freedesktop.org,
 linux-hwmon@vger.kernel.org, linux-input@vger.kernel.org,
 linux-sunxi@lists.linux.dev, linux-media@vger.kernel.org,
 netdev@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com,
 platform-driver-x86@vger.kernel.org, linux-scsi@vger.kernel.org,
 linux-staging@lists.linux.dev, linux-btrfs@vger.kernel.org,
 linux-ext4@vger.kernel.org, linux-sparse@vger.kernel.org,
 linux-mm@kvack.org, netfilter-devel@vger.kernel.org,
 coreteam@netfilter.org, tipc-discussion@lists.sourceforge.net,
 linux-kselftest@vger.kernel.org, stable@vger.kernel.org, Linus Torvalds
 <torvalds@linux-foundation.org>, Lorenzo Stoakes
 <lorenzo.stoakes@oracle.com>
Subject: Re: [PATCH v2 07/19 5.15.y] minmax: simplify and clarify
 min_t()/max_t() implementation
Message-ID: <20251006213242.3462e746@pumpkin>
In-Reply-To: <2025100648-capable-register-101b@gregkh>
References: <20251003130006.41681-1-farbere@amazon.com>
	<20251003130006.41681-8-farbere@amazon.com>
	<2025100648-capable-register-101b@gregkh>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.38; arm-unknown-linux-gnueabihf)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: fyi6jxemfznaukh7cnojtu3wp5f8o8hc
X-Rspamd-Queue-Id: A16E310000D
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1759782908-950144
X-HE-Meta: U2FsdGVkX1+E0kgUPyWK2dBKkdmmnpSz/TF5gXdF8x7ji1mkvPfuDz5oq+/ZM4DozHnia0Ke/twsxux2Jp06Oc7r64elzzYjp6mv9NwTSGtuqVISx2ydnEHceDmfutLUx3ocgyfrbjMS3k4Ut2EyvWpda8vKhBw+EyL88jBTpQzb6/1v4KBbiuRiEcrMhdesB/F2Rse8Lfny8GfCicqXzzo8tPlwAKd/CzDzxkh9Sil8Cvuzhz+kKlyvmuXSZ5F8MmR5x4JblHirDDDm50CsIUQhJuzx/Q75ZBE+36RFcEGbvVLbsUCoOVp+W69VyEhLZ4EP9YRNcVfaqWNGBp3qDRAI9xSxD8FhjkYKqBdzXXEQXySu7lbl5tygfXgsEMxAj9TMgtJv+0RDKcLTMmJMG6DBQIYRvCcURT4o+o1tS6QiHk45To1H+Daz2Os64s4pCMVW7UBQpHUa7E7yZ7ecBkILd8D9W9dtVOO1BsP/YwlOoZbuvKzrSq8618pJb8WsEo9LcWoggPFXxQrnc/z257fl8szkaSRVz0KcMOUT49Z2xxv3IKrTCB9Bdf/zarv68ApTCW6LxSYr+dqWslJGSVLM4g9EGvB8FSxIWXxm7sianE/Btn/6DkdPvbUk4fauFnqeZvo8ReM/+x0E8F/lUzeYuFF74nzdi+uQVNOh5UGr9xUq6SrrAKtQfUcih6JHTF8xoikVPoTZtwe/M7FW3H1VgeJ2ANhtOeQjfqxvW4IejwW+BfBw/VBOCqM9COYVMKlderR85q/y5z8DbK7PezQffyR2cu6XIkRskAuira+1uxAkky0D5SybxXko0e0FKXP96Wa84CmLgiCbZkbQApAbjcRVhulFZoutocTgonorgoiSo3dQRxX4fF4D3RULSVeLswoO5k4E/JiPpwbw1DLAQo1tXtg8sJDgB1Dlwq05tggfXb7J3lYtNkKG2w+qaQCREdEpR14pozhjMDg
 8WCTf9l9
 Uy1Qqyyxhdvo1DWZDLUSszX8cOPekYZ3kQ0R9DH3pjgOvp5tcFjkAskIq454hR2O46d+lbcwgdpYYb9WKE03yDdsbZVSuhdRm5zkGNvcl/Xed2liLwvTwQRpBzoIN7xuR+mJmmlhmOJvJN38xDlVgoB40bRW3sRRO77LVMHLRCTSCd8/2mdbajyyN7tlQm5M9Rj7ZsptjV2kz61hQHeaYLG0k3TavomV3ZWe1aPOLQWpIM6lkh+ArCk7WXw+dh59dgfOt4AJsFWJBY7EsJ26AUh1UcWyIKG3ERhVfEv6/fcx2HjaUhr9baNbfpB/wkEGXc7rf4ZnuQsWPLzK9TCgwIxiEngyEpF+QiT8T4dO80yqtwYPsfQxRyaBTQI/vYwJnBre6VjAqhzgZVGYBKMwx/cDvSQ9pCBkzmPkY4i6V5mC3Am9KrSncDsdCSMCAweOm/8+OE6/1enP1P9jp1jJffZaeE0C78L5qEAGHeyFYbNwTJKuJHRXhQmHipgEVWKb3a67yNKnW4xO5h+MItKR/VPKL0mNMqQU273vYrwtaUpqVRybpuypbmn6mjHiamOZBYhqdeiCOEGtQw22Y630xMms7ZFI+B15hXIVcaPP69b+hzwhUNTCfaTJMCjNhFZrfdE14t2Mx7dBBE29SZnvQD93tSGOBqnZ0t6s4MUmL9aWaaMUe+PphVoJsuP4OvbSVdtYOq3BsEhNpkEHMAe41CLCjLTdeHsaBavrw
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 6 Oct 2025 12:47:45 +0200
Greg KH <gregkh@linuxfoundation.org> wrote:

(I've had to trim the 'To' list to send this...)

> On Fri, Oct 03, 2025 at 12:59:54PM +0000, Eliav Farber wrote:
> > From: Linus Torvalds <torvalds@linux-foundation.org>
> >=20
> > [ Upstream commit 017fa3e89187848fd056af757769c9e66ac3e93d ]
> >=20
> > This simplifies the min_t() and max_t() macros by no longer making them
> > work in the context of a C constant expression.
> >=20
> > That means that you can no longer use them for static initializers or
> > for array sizes in type definitions, but there were only a couple of
> > such uses, and all of them were converted (famous last words) to use
> > MIN_T/MAX_T instead.
> >=20
> > Cc: David Laight <David.Laight@aculab.com>
> > Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> > Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
> > Signed-off-by: Eliav Farber <farbere@amazon.com> =20
>=20
> Eliav, your testing infrastructure needs some work, this patch breaks
> the build on this kernel tree:
>=20
> In file included from ./include/linux/kernel.h:16,
>                  from ./include/linux/list.h:9,
>                  from ./include/linux/wait.h:7,
>                  from ./include/linux/wait_bit.h:8,
>                  from ./include/linux/fs.h:6,
>                  from fs/erofs/internal.h:10,
>                  from fs/erofs/zdata.h:9,
>                  from fs/erofs/zdata.c:6:
> fs/erofs/zdata.c: In function =E2=80=98z_erofs_decompress_pcluster=E2=80=
=99:
> fs/erofs/zdata.h:185:61: error: ISO C90 forbids variable length array =E2=
=80=98pages_onstack=E2=80=99 [-Werror=3Dvla]
>   185 |         min_t(unsigned int, THREAD_SIZE / 8 / sizeof(struct page =
*), 96U)
>       |                                                             ^~~~

That constant seems to get (renamed and) changed to 32 in a later patch.
I'm not sure of the rational for the min() at all.
I think THREAD_SIZE is the size of the kernel stack? Or at least related to=
 it.
The default seems to be 8k on x86-64 and 4k or 8k on i386.
So it is pretty much always going to be 96.

Linus added MIN() that can be used for array sizes.
But I'd guess this could just be changed to 32 - need to ask the erofs guys.

	David


> ./include/linux/minmax.h:49:23: note: in definition of macro =E2=80=98__c=
mp_once_unique=E2=80=99
>    49 |         ({ type ux =3D (x); type uy =3D (y); __cmp(op, ux, uy); })
>       |                       ^
> ./include/linux/minmax.h:164:27: note: in expansion of macro =E2=80=98__c=
mp_once=E2=80=99
>   164 | #define min_t(type, x, y) __cmp_once(min, type, x, y)
>       |                           ^~~~~~~~~~
> fs/erofs/zdata.h:185:9: note: in expansion of macro =E2=80=98min_t=E2=80=
=99
>   185 |         min_t(unsigned int, THREAD_SIZE / 8 / sizeof(struct page =
*), 96U)
>       |         ^~~~~
> fs/erofs/zdata.c:847:36: note: in expansion of macro =E2=80=98Z_EROFS_VMA=
P_ONSTACK_PAGES=E2=80=99
>   847 |         struct page *pages_onstack[Z_EROFS_VMAP_ONSTACK_PAGES];
>       |                                    ^~~~~~~~~~~~~~~~~~~~~~~~~~
> cc1: all warnings being treated as errors
>=20
>=20
> I'll drop this whole series, please do a bit more testing before sending
> out a new version.
>=20
> thanks,
>=20
> greg k-h
>=20



Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CE011CA0FED
	for <linux-mm@archiver.kernel.org>; Wed, 10 Sep 2025 09:50:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EE2988E0007; Wed, 10 Sep 2025 05:50:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EBA7F8E0003; Wed, 10 Sep 2025 05:50:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DF7168E0007; Wed, 10 Sep 2025 05:50:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id CB88F8E0003
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 05:50:11 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 69A4186F72
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 09:50:11 +0000 (UTC)
X-FDA: 83872869822.01.14BC92E
Received: from mail-lf1-f50.google.com (mail-lf1-f50.google.com [209.85.167.50])
	by imf18.hostedemail.com (Postfix) with ESMTP id 6980B1C0006
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 09:50:09 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=linaro.org header.s=google header.b=K5r2sSqh;
	spf=pass (imf18.hostedemail.com: domain of linus.walleij@linaro.org designates 209.85.167.50 as permitted sender) smtp.mailfrom=linus.walleij@linaro.org;
	dmarc=pass (policy=none) header.from=linaro.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757497809;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8Y7rG79FKOI2JeBB22WORiCW6ZRk/F6yyki8GX6i0OY=;
	b=sD4/l4NUMmuS6BiXh3LxmiUT7jcAEpdO3HH2sCqpOm7aVqlvfp2uMQ6ltO9jUtaQvgKK48
	PesHjkrb0RuB8cx9Zd+Vo0M61OpYYlchkL4TkGDrR1lzWurK7gpTDRJXA3+vjTKCgbD2QS
	adskkS+lOZhcR0TtKvFE9GUF20Dgzxw=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=linaro.org header.s=google header.b=K5r2sSqh;
	spf=pass (imf18.hostedemail.com: domain of linus.walleij@linaro.org designates 209.85.167.50 as permitted sender) smtp.mailfrom=linus.walleij@linaro.org;
	dmarc=pass (policy=none) header.from=linaro.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757497809; a=rsa-sha256;
	cv=none;
	b=JDi0yXgdNux0lQwN3NQTM0OogTQL14xa9G6iLu9pc2JjKVT7Bt+Ifb05g2bRYAdnDGUhRU
	VyrbParLVKC/GfOtkGolYY68UqVGhd12dxQYfehvKD9hI8w5FNyufTwUObAz1abvpBUZYS
	BaG38XJ9JafhXq0YrpCveb53stgMBYY=
Received: by mail-lf1-f50.google.com with SMTP id 2adb3069b0e04-5608bfae95eso7521517e87.1
        for <linux-mm@kvack.org>; Wed, 10 Sep 2025 02:50:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1757497807; x=1758102607; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8Y7rG79FKOI2JeBB22WORiCW6ZRk/F6yyki8GX6i0OY=;
        b=K5r2sSqhHjmV5KFlzmAUHADvGEEJWK0NwjI7KGm6cDx+K3djC/AwMpDoCJLJXrFeuW
         yg95vTkdFy6OhKL6njeXmfgfmL+ouOEJ/VAuLeSBPXz0+OT/UbobG6YJgDAfTlgd6Cxe
         gOQTn52mZXONnW40VWJyrW23qNIR1tJjs08WO0xoy4bbc/f9M9MViQoGzkGPQaUYcto8
         Gj/vDdRyB6W9ky8vhuqvjdb+VbR5389wGgy7ZpWWifeFzTneHyKFrSXL0O4bSvep9STr
         bOh4S+W9WykuoTq26tBWFYWRKGfPUrQWJZPzjOtRjTRQ0r5fjU5RvbWBsKXc7Ze8mPl2
         CmTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757497807; x=1758102607;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=8Y7rG79FKOI2JeBB22WORiCW6ZRk/F6yyki8GX6i0OY=;
        b=lKRqT5afP7pwKy/FqEvDu5HD7120q4TE6MasI6H/CGf/uuJJh3BSmIw/OvEVASAUwE
         pvYhnbYEp3lnhCExPg5DkzO4p1NY0bhtwJqwk544oFMdwll3ZixA5fY6kpdJ5XVx7ZxN
         aePPfBIbqRfmuhAkH3R+89S8zkiUSFXv1/XgWT2A3EYSorjdDI2NhSmORcnLnkkMFn52
         poZU0bwZKx3OQCu8nr2oR1MFX4SI91nG9RwMw3MUK/BrDgU9nXpwQZhH2ChfJ4jESnmV
         sACwzD3disSujYq3pIik4dXxdzCt/2wch+YgoHHVznzd/ifu2nFkf5SWSpuBb2LLyBZi
         O0bw==
X-Forwarded-Encrypted: i=1; AJvYcCVPP61InCBXCKEpxl6jORZ0zCzkJZxVgEY0s9A4iiCLjNfXrxEz/nqbx036FsvFp/xGp0VCPHD/UQ==@kvack.org
X-Gm-Message-State: AOJu0Yy7X7KEUU39SqpK3Tv/ff4X00DnVyiD+YyQYa0LdBCUiZJyIjny
	QeoNOV6OmYPhP2yLpxiaXK6itR8LPlTk2BLdqOJpsABnm+SKoDnVbDsClH0ZTN791MQLjh019i2
	KjhPYpcN4fCJalboTNP5pxu7GwQukZ8IWMkqg1frqtQ==
X-Gm-Gg: ASbGncsxTxYyggDIHEWWbmqDKuiLrWK2vScBB0RBPysKcFKBmmP9uF/MPJ1UXe5vVl7
	KC+kySDmBWMhKOt/yTyNq6/LJuLHYSHZPok5+FEu75hCAPr+uwhfEVOOY/R3ga7bU3jEn98kvEQ
	LidoTr3uueH8sqomW1vu9o5JiDAc7N44jwbxWd0zAOE4FX2bMUHWB5DAsDeD3LPnid2NtJsTi8c
	mNdci4=
X-Google-Smtp-Source: AGHT+IGq2x91wz7j8DANH/yJwpeO4d/hIy0ABq1WES66C1SeY2aK74/VWAJ5lsiz89NvTXBUTDFt595MC0reZwFBRxA=
X-Received: by 2002:a2e:a009:0:20b0:336:5e1f:b1ec with SMTP id
 38308e7fff4ca-33b536f14b1mr41029971fa.31.1757497807337; Wed, 10 Sep 2025
 02:50:07 -0700 (PDT)
MIME-Version: 1.0
References: <4ff89b72-03ff-4447-9d21-dd6a5fe1550f@app.fastmail.com> <aMDYdp3H-yOHU1Pm@casper.infradead.org>
In-Reply-To: <aMDYdp3H-yOHU1Pm@casper.infradead.org>
From: Linus Walleij <linus.walleij@linaro.org>
Date: Wed, 10 Sep 2025 11:49:55 +0200
X-Gm-Features: Ac12FXxu2Penmvb-ANhZIzZlxEacPcTMGZ42OzvKFfqr5PHU2ajbCjOLxBc-XSU
Message-ID: <CACRpkdZZZNV5BdNhyXEK__=EJLjDtAEsc2Kv4Tv53+=Mv-8R=w@mail.gmail.com>
Subject: Re: [TECH TOPIC] Reaching consensus on CONFIG_HIGHMEM phaseout
To: Matthew Wilcox <willy@infradead.org>, Russell King <rmk+kernel@armlinux.org.uk>
Cc: Arnd Bergmann <arnd@arndb.de>, ksummit@lists.linux.dev, linux-kernel@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, linuxppc-dev@lists.ozlabs.org, 
	linux-mips@vger.kernel.org, linux-mm@kvack.org, imx@lists.linux.dev, 
	Christophe Leroy <christophe.leroy@csgroup.eu>, Richard Weinberger <richard@nod.at>, 
	Lucas Stach <l.stach@pengutronix.de>, Geert Uytterhoeven <geert+renesas@glider.be>, 
	Ankur Arora <ankur.a.arora@oracle.com>, David Hildenbrand <david@redhat.com>, 
	Mike Rapoport <rppt@kernel.org>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	Andrew Morton <akpm@linux-foundation.org>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Vlastimil Babka <vbabka@suse.cz>, Suren Baghdasaryan <surenb@google.com>, Ira Weiny <ira.weiny@intel.com>, 
	Nishanth Menon <nm@ti.com>, =?UTF-8?Q?Heiko_St=C3=BCbner?= <heiko@sntech.de>, 
	Alexander Sverdlin <alexander.sverdlin@gmail.com>, 
	"Chester A. Unal" <chester.a.unal@arinc9.com>, 
	Sergio Paracuellos <sergio.paracuellos@gmail.com>, Andreas Larsson <andreas@gaisler.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 6980B1C0006
X-Rspamd-Server: rspam05
X-Stat-Signature: nmyzfdx6qipwmh7xobbiw7k5x718wnm6
X-Rspam-User: 
X-HE-Tag: 1757497809-893758
X-HE-Meta: U2FsdGVkX1+F9T3yqtLyxr9juqR7GJHR5j2LzxQ2cBIit9f9vPmLtB13+5frLzbKFbstUhWIufq/UeSdmZbRHKyvar9b4ZsB5CiQ7lAEUtTkF7rPDBJ0vqOuEf/ikEo8YuZm2iPjGURDmnVgKwtcsjJAzxg46CfOAl/5IuQk7eZEFebHmTPBXwFxGltcZpTLZOBqo7ZXQDJpO01rO/mch52z+Mzftm9dnuYtb9WZufE4KmI8j48OF+VQA1pAWsibMGOOhLjM2K7UzT9UJCDnlG1B7oOBLvzhoJlbvDqJ6f97jtnbsR5ZF17I6pAflnKMz5sPgJld9dP3a5UJGHkPxJhTEDRJNT9pgfh6OGUOkJwFsCfz+jOtsQp6AEu4E9ZwzW/JeNoumjyRraiqSrtcJGdWdtqpuLARGRveevMT7Und/5BNVH/T6BxSmwbvm0o1PVmydeDuvkk1AyfYrcWOA/qzOTRKGh0mMh+qJ6ydqUr2KCknWbbSX1UxEBCKeBCPTXDeP0C+WtQiGZp+epdnxL0DTucI5RfL0kIx3RmNmPMuNomBor0UvTZESz+Dglsf9rEcqCGozNuXfHgBrC7KUgX6TGnGbJ3HP4V3nzix+aYrX4na+6ApaxBy+GWBIOWcTRS2lr/AbzMH5eEJ6bRZlOVSX6HXhnSsE7xxIWm0i52idZUU/MWajmkILoAMUa7xHY5uqpUwHCppVgwRDMI+VKaKRUad70NwAKi8/3DDJ8OfnZyKKOoY2Rat59LbHLs2igNuCu1w58HxI7AOYsRjCz1CtzZ5oYkzublBLNnCgA/pMA9E68yR9+Zg2wKogKJAE9bmoGB9SninHXgi5eSZoir2n1TDPN4BMACEGpgkZuEQNiV8tH9E26gWfvvXAgj86BLWKTM/2/ebTfSTocOYgE+S9tpOp/K3dvvRJ2OU1mp+3B34R3e0Irsi7XnaonT88OgHmSBFaX0Lz9vrv32
 amD6tZA/
 eJM89Ve6g0pRVwb2LKGNw0a0Cpl2ZCBLvgFaZp7eLDwULmglbNecq8dPq2YW5B9oERAQP8kllsCInYwY19Kpd6BOKr4yDMvZNjhI+wFEIHhD0vsQ9ili6o2IqFrdf1CT+lmyZ2vEjDtwoFeB34NZqgAtcKEs8sqN+/FUBEbFnXMKWdYc9nkrgUop7QHc5ItWj3n1NKRz0p2RlKP+uw93ZaG76fA26g06a3Mqws23Kt11u5uQ2VwRwLkIuh2pJOoz3dX4RfmABau1bJ6gDUt5VYBJPHBs8R267fOm2fXrlVyGDKTwAfs5Xu/yY0860OXkIgJKFK5GrvhJRqY3sT6IZ85CLr92RLeF3pyqcmM6h/j7SM4IUL1mwrA5YTwuVYPmsSV0Q
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 10, 2025 at 3:46=E2=80=AFAM Matthew Wilcox <willy@infradead.org=
> wrote:

> I don't mind that the feature remains ... unless it causes us trouble.
> Which it currently does.  Perhaps we could start by removing HIGHPTE?
> There was a certain amount of complexity introduced into the page fault
> path when support for that was introduced.  x86 removed support for it,
> so it's just ARM left before we can remove the complexity again.

I sent an RFC patch so we can see what Russell has to say about this,
it is currently only enabled by default on the VT8500 machine.

Yours,
Linus Walleij


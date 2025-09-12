Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 72509CAC582
	for <linux-mm@archiver.kernel.org>; Fri, 12 Sep 2025 12:46:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C21848E001E; Fri, 12 Sep 2025 08:46:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BF9948E0003; Fri, 12 Sep 2025 08:46:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B0F758E001E; Fri, 12 Sep 2025 08:46:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 9FE788E0003
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 08:46:49 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 550A011ABED
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 12:46:49 +0000 (UTC)
X-FDA: 83880572538.26.A9D7A22
Received: from mail-lj1-f177.google.com (mail-lj1-f177.google.com [209.85.208.177])
	by imf30.hostedemail.com (Postfix) with ESMTP id 4EFCC80003
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 12:46:47 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=linaro.org header.s=google header.b=HTvt2Vay;
	spf=pass (imf30.hostedemail.com: domain of linus.walleij@linaro.org designates 209.85.208.177 as permitted sender) smtp.mailfrom=linus.walleij@linaro.org;
	dmarc=pass (policy=none) header.from=linaro.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757681207;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4J5UZwv7Uo2rH+o6sSlfGyt4PnQotdtpRnvjkNoAGSQ=;
	b=ac9qJwrZiPEVMwvMVCmt2WgqpNE/QehmRRIGbNuOyDmJR9TjjEg0oHqC/1qgXQ4R8p2tJj
	PQyyTOD+WaDR6OQBHfG0xxpe9Rv1qOCBywwVvfBsbQjD9fqZl0S3RoLfGEoe7rqpyzLpQf
	98GDEwkmYREWFoGGAyK8Uhtz9EeLapk=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=linaro.org header.s=google header.b=HTvt2Vay;
	spf=pass (imf30.hostedemail.com: domain of linus.walleij@linaro.org designates 209.85.208.177 as permitted sender) smtp.mailfrom=linus.walleij@linaro.org;
	dmarc=pass (policy=none) header.from=linaro.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757681207; a=rsa-sha256;
	cv=none;
	b=YA/xugxZN3TPBnVWOd6hm2fyy7xJFsSdUpczBcjXYfvZYwo0BAMa4O6KhK5q4L46rk0gbc
	FDczVJZZd9ly3BtUDtta8BwYf6MJiIREp03BeXVRfpFkGm0XsH7Q4tgh6GJwtLPxMuphm4
	fX7VsKL7FHUqX4+xblBO1soS95WcKfY=
Received: by mail-lj1-f177.google.com with SMTP id 38308e7fff4ca-336b88c5362so18046581fa.0
        for <linux-mm@kvack.org>; Fri, 12 Sep 2025 05:46:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1757681205; x=1758286005; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4J5UZwv7Uo2rH+o6sSlfGyt4PnQotdtpRnvjkNoAGSQ=;
        b=HTvt2Vayex8oLcFZ1Q08KUnvM3supO2zD8XhVhelHGGazANFYSPYKAHnI4EgiUWNL+
         Oa/95ZBuHKdpdWMUDfuiX9IFrAM4EdZ7APhvxgD20hYI+VGAY413D3bMw4sLki+gZuCv
         0NbiVr7RhOsf4mNIssLMn1mfGFhKrVycCzfl0lFe6ajiuDCW0DXlZ9MXJwCw0GNCh2Ut
         NnjLrHMjRgmsA7Lrno5tzWW/OadAbTNr4aO/pFpebrWYN9hsnJnq/yonJav1wIAzNzps
         tXKIECidXnGGxMqUKFmmEarFGtcTqoJGl2w+zyhyHzF4rNvX6RyV7R2uV5tlDueaWP7P
         3Dhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757681205; x=1758286005;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=4J5UZwv7Uo2rH+o6sSlfGyt4PnQotdtpRnvjkNoAGSQ=;
        b=tN33EJKdu7CGKNOvNgIR7ihMpGvXjiBN+4MimEO/axkmCnAFC/y03KKNsSDtZ9tsCX
         hOnLFAERurpcLw0rOg0pEH7gatzkGigGBgUtlKeL5DOzMeGPCaJiFDQFbNrRZWiytolw
         +wm/Ejaycd+Gbwl65wqpfrGrgurrsbpeHFKkjVZIjHW9+kVSYg9wdRm2ugxFe6YFuf9+
         spanfqvbNtZpZkQHOVTxZv+h0JiRkMrlJhUavu2wXpt1VP+ffFW2ZCiTJcI7/k5OVFaV
         UU+p+AvUDN5gcRUJM7Ad0YYoR6DzOeJ90GryfJcR6B/SSmNErLwsYNwu9DlYAiNcpIyW
         mDWA==
X-Forwarded-Encrypted: i=1; AJvYcCVsOr5CeGI3zFANSPqIMNN5VfOLihK7S8K9NOClfYJABhugqA9EAOQvJjLFybI7pBlWO92Zk32GNQ==@kvack.org
X-Gm-Message-State: AOJu0YyGUAjplzdEqpfSxuTR93Kr31kydmkyGCVBBXGMCiRuMRCyyVpc
	rELw4vfdUtYNeWn/kZtw6WVGmOcadvyCEs2qAmhC6NWTkEePvVL38cLd5Do/JGWbJcyVzweC8YL
	0xBo8Ejlmdf+lax8Iglo6e36zC0d1el5qqm2JGxsAEg==
X-Gm-Gg: ASbGncv/+GNirIIEH0WVviD3NAA9aDjEInOJh96PW8seZ5vJ2D0b0EF5nejqietHRnw
	0qoxWViZ5TWdDKf6CjjtxYPp6NFqinLAR7JjA1NMiOQV3Np1bWZY85poQPEGa55BwhEZesJI+PI
	eGGgzXJYFc0X7V9mUDmf43GoQAaME0fSNernVhXlt+C+EBJFWtEo2F/PbicScCCtQMWusxsa/xv
	bH5Izc=
X-Google-Smtp-Source: AGHT+IFceSrS+iukkr/XkXsYJuXAC3/mzUt2kTyPUu5TFhzIuaRO7o+4f66lybawSyOyyY1O0N/R5wKHhfBQZAMqWCU=
X-Received: by 2002:a05:651c:23c5:20b0:339:1b54:b367 with SMTP id
 38308e7fff4ca-3513b296a39mr5927901fa.18.1757681205355; Fri, 12 Sep 2025
 05:46:45 -0700 (PDT)
MIME-Version: 1.0
References: <4ff89b72-03ff-4447-9d21-dd6a5fe1550f@app.fastmail.com>
 <497308537.21756.1757513073548.JavaMail.zimbra@nod.at> <dec53524-97ee-4e56-8795-c7549c295fac@sr71.net>
 <640041197.22387.1757536385810.JavaMail.zimbra@nod.at> <4fcd272f-81e3-4729-922b-588ad144e39b@app.fastmail.com>
In-Reply-To: <4fcd272f-81e3-4729-922b-588ad144e39b@app.fastmail.com>
From: Linus Walleij <linus.walleij@linaro.org>
Date: Fri, 12 Sep 2025 14:46:31 +0200
X-Gm-Features: Ac12FXysdXrp8ARxlqs--JPKzGSESzQlXQvRlkFB3ZYER3az5tDF4P1ySurKojc
Message-ID: <CACRpkdY9VS1H642wSUsLvwi91YOwXGkiePdq+JktDSeiWTon8w@mail.gmail.com>
Subject: Re: [TECH TOPIC] Reaching consensus on CONFIG_HIGHMEM phaseout
To: Arnd Bergmann <arnd@arndb.de>
Cc: Richard Weinberger <richard@nod.at>, Dave Hansen <dave@sr71.net>, ksummit <ksummit@lists.linux.dev>, 
	linux-kernel <linux-kernel@vger.kernel.org>, 
	linux-arm-kernel <linux-arm-kernel@lists.infradead.org>, 
	linuxppc-dev <linuxppc-dev@lists.ozlabs.org>, linux-mips <linux-mips@vger.kernel.org>, 
	linux-mm <linux-mm@kvack.org>, imx <imx@lists.linux.dev>, 
	Christophe Leroy <christophe.leroy@csgroup.eu>, Lucas Stach <l.stach@pengutronix.de>, 
	Geert Uytterhoeven <geert+renesas@glider.be>, Ankur Arora <ankur.a.arora@oracle.com>, 
	David Hildenbrand <david@redhat.com>, Mike Rapoport <rppt@kernel.org>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Matthew Wilcox <willy@infradead.org>, 
	Andrew Morton <akpm@linux-foundation.org>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Vlastimil Babka <vbabka@suse.cz>, Suren Baghdasaryan <surenb@google.com>, Ira Weiny <ira.weiny@intel.com>, 
	Nishanth Menon <nm@ti.com>, =?UTF-8?Q?Heiko_St=C3=BCbner?= <heiko@sntech.de>, 
	Alexander Sverdlin <alexander.sverdlin@gmail.com>, 
	"Chester A. Unal" <chester.a.unal@arinc9.com>, 
	Sergio Paracuellos <sergio.paracuellos@gmail.com>, Andreas Larsson <andreas@gaisler.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 4EFCC80003
X-Stat-Signature: 61hmy1fnrds7hedqqtisw5r688ezjac8
X-HE-Tag: 1757681207-614452
X-HE-Meta: U2FsdGVkX182La4CLL5D6T0joKPr2y5DeQzkP8dmmC0AjSuFUyjy+0ImfqBRKlS7vaB35l2l55x/R+pai1zWR/Dc7PCS0zhNqFnMCmFpxQuA8fGJk0B/OvE7hihBBLQdAoI7jZQOzf/GoOeeCmvf/gn2d4EFVWzI93vzwQXOvw/gaSVfx1THH30izCoFDFR+1qHU8MtVJAtZeN9cRaqI6ZoctqMB8VnZV9VIuP244pVbPUFJUs68rk2dF2NBcyLCe9xAg1fCC9NFDrLUr1pdIk5eCtH757Caw2ydXiXhIE1wRBcvj332LNKdFRtt1Be1j84C0B85RYMvKhuuzZwGY1AWZdJIWuz0aJhSGahRHAM7HiHAprr4iUFS7r+V6idnglUpDpMXdbkhf89oe8n5i0khytnYXSfgCX+0ifRVHjcKiAvel0QLJat6L4LUTuv2pWukXWCc8RIv2PghWUVPEJxUGawiq3fwVx8IdjIgHqdm6TK1lDQRzh6vwA2EAVb+/2XrzkGeXPU4LLsZ7byUAvpy4vAY1VOmyz8PeebxuRetvtuy3duTyBr9twEKPS8JvimDtOQAvwmS0ziOneYw1vSGE4bPd5SAnXwfbsShkTAiEI//L1i2GcmLQJEZzTADXaEh0OiyIWyqu5mbfyKzlhVA/KJLh98v0wiNmiHnIPsuRfzOyDaJgV0V9qytE5y4eyekyjQ35zd3gr3ZRfC3b15WK39HrFBV7aKwGECAnn3VP3xKcIyrlyMD66U0orz/bF8xHpPRlHQtSwU8h+mNOfWz+5RROqKQuqK3f8cTVvrLdG72pqMcHXvAu9JsToGjM9x6XX/xE2DokTpDQFv48Tx6Id5QBT5v/XczqWNVAt6SbO5xojFdG2fbiBMWnc63Nw0HXIpYrldTF0eu2rwDjs/RwP0hnqgb8QKdOiatMbe7EGlV3OSvMuAawUqv+npFsecJ4QOXJfrUGP2QTUR
 Mtv5/Aws
 qZM1QhqarxiJRom8KUZtAq8m2ktZR8yGgNyJ7JXHJSrMmfdVegBnwHZ41p4iIjNirgPAa8fGNVV/JOQAe1AfJNNXaoDbJ4QH7UeBv+uHwjKqNb9A2TMX689uYT9uszXjw3c4Vm6aX9ICzw9BiICjyvowjd02GZ6X/n2c9bYoFYG13mtz+GaUoX0Jgxfn26WD76M+TyRYvmMmbFI5wuK7zJPQhS19qPcrKoIBbQADi96XEFVEpi/p1oZm2TUgWjyt939jGY5rCKgcqMKaNECyneuXX/axf3zsbgZ7bJAQeyHUMS0TLC2EkGSTOEGq7KYlGPcebMT/Li4s8LknzGh6u2pA7KViwcGjdNxya7GTHdd2iuAnvzbALLXeO5Q==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Sep 12, 2025 at 12:31=E2=80=AFPM Arnd Bergmann <arnd@arndb.de> wrot=
e:
> On Wed, Sep 10, 2025, at 22:33, Richard Weinberger wrote:
> > ----- Urspr=C3=BCngliche Mail -----
> >> Von: "Dave Hansen" <dave@sr71.net>
> >>> Even with a new memory split, which could utilize most of the
> >>> available memory, I expect there to be issues with various
> >>> applications and FPGA device drivers.
>
> I also remember driver problems on older Marvell NAS systems, which
> we never fully figured out, my best guess in retrospect is that these
> had devices with DMA address restrictions, and if lowmem is small
> enough it would always work, but any lowmem allocation above the
> hardware DMA address limit would cause data corruption.

This kind of mess is often also driver problems, in the Kirkwood MMC
driver there is some dated code traversing sglists iteratively
instead of using sg_miter() on !DMA which I think is not entirely
safe either.

I wanted to fix that driver but the hardware is in my NAS and
all the time someone is watching a movie from it :D

Yours,
Linus Walleij


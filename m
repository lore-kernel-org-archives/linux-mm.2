Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D5E0CCAC592
	for <linux-mm@archiver.kernel.org>; Fri, 19 Sep 2025 07:25:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3ECAB28000F; Fri, 19 Sep 2025 03:25:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 376878E0022; Fri, 19 Sep 2025 03:25:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2658328000F; Fri, 19 Sep 2025 03:25:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 11DC28E0022
	for <linux-mm@kvack.org>; Fri, 19 Sep 2025 03:25:04 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id BF3D613B362
	for <linux-mm@kvack.org>; Fri, 19 Sep 2025 07:25:03 +0000 (UTC)
X-FDA: 83905163286.07.7E1C555
Received: from mail-qk1-f169.google.com (mail-qk1-f169.google.com [209.85.222.169])
	by imf23.hostedemail.com (Postfix) with ESMTP id C09E8140008
	for <linux-mm@kvack.org>; Fri, 19 Sep 2025 07:25:01 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	spf=pass (imf23.hostedemail.com: domain of geert.uytterhoeven@gmail.com designates 209.85.222.169 as permitted sender) smtp.mailfrom=geert.uytterhoeven@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758266701;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=jN8ls4Umh9EIXSEQoAkCyXxQ8L8mjN2Gdzzs4J/riyA=;
	b=I9S+c6CxGIh39C/CJAG1v/kDKndc8HMivBNMqhp631C+59oJJdVgSDprz9PKCJp2GRslG0
	nZqO938z+TAvT2cuUvZv6semQFpyLQ7DNn4K4KGR/xUN8b6OPcs+CCcFAMhkbv8oWblW3y
	Br0zwikelazl3WTaEFkDbAPShVAWXxk=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=none;
	spf=pass (imf23.hostedemail.com: domain of geert.uytterhoeven@gmail.com designates 209.85.222.169 as permitted sender) smtp.mailfrom=geert.uytterhoeven@gmail.com;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758266701; a=rsa-sha256;
	cv=none;
	b=crESFAOzG6YyJBHat+1GMMC5RjXJ05oG2M7fEVWiTksMcPcHHVjImre5T0jcCKeOzQrcuv
	krAkTFRTbC8j6Bpt3c8y4KZ8jh88Zkfznr8HqExcszFET3dEiiYKczsfxI7wpQXZISwV7+
	di8YO0WHZUJG5Pj2iKPpJpg9cfZ6PhY=
Received: by mail-qk1-f169.google.com with SMTP id af79cd13be357-81076e81a23so254444085a.3
        for <linux-mm@kvack.org>; Fri, 19 Sep 2025 00:25:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758266701; x=1758871501;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=jN8ls4Umh9EIXSEQoAkCyXxQ8L8mjN2Gdzzs4J/riyA=;
        b=gTQ1ocwB5m8W65Itwp5tIcolx/1UgE/cIpr9AxvLvC70Mm/erd1otKsQ0MgxM6BAlL
         ldn8LmDMCq4rXvTeCx4/8SGIOukfSNh1YEFhaCXAmflclba6P77mciYOvWIDyoq1Su4L
         42o9INnhBIKzQuEm+tXHWXPzCZ/ewRBBcDYAC/iQxAqInR+/MAiBgz0X1IrOXbQMTOg8
         bdut7+d9Eeao4X/h/Rjyc6RAj5LBXV47Hc6MEm6J2EwiE6pmvfsSLB6kH7TVB3kAGMiB
         fBpGzOLsHN65ez3vexp0FVB27dtvl5asydtdJ1Pr6aFznKC9G9mOCYm3YsenRkST49cg
         Q9kw==
X-Forwarded-Encrypted: i=1; AJvYcCXswSiIhTb6/rUSA8iStnm9u9Lq5g0Ro10dm4KZHLj6IjTTBNgIcmWDeAV7V6BSWRFQQudQFPYVMw==@kvack.org
X-Gm-Message-State: AOJu0Yyz4dOo6naJ/ntnZrdQdxmy6J9Un1Ox+/vpoKVR/qDnRBQjXfyX
	v2YCeXKqo8LT8Ik3O3XnNCDunG1d85l0t5xw5uil6yINGyBHAlLZDalumj7iLDcn
X-Gm-Gg: ASbGnctQvn7wbZr+GYk2wuR7i6WYEvIuk0tWcLIl8d7j+5m+EYA4XaDGORaykDbRe04
	+IP+bxFu10fC4vsMN3YPZqPLFXd6FQiYJAkcXKEVB2SNbJZRTl8/vvjkOlWPsaAIFtG2DivwHVb
	Vx1GcjGFeTZ4OL7gS/IBtNWxsEsHrrLwhlNpjdzQD9+I+y16387QP7ovg20A654a60VFBEQSb48
	TBDIpTK/X3FaO7boglCkM0+1B3t/ljvc4uZhWwyF6gTvoC1dqKB89qndHoySKO52jAM/+DKNr2Q
	xD7Hpp0CvBLMgEB4rnnhIA/FHi6op3FRA3hnat1oVENIK4cKHXimn9Si9slxy6l6edcBeSpVQA5
	xH9k0+eYIdKXeemHsFp2MvQi6gVOHVhuM1KM97hwA4PGiJcp+YhfCLOVV9Niuooiz
X-Google-Smtp-Source: AGHT+IEWHmWAOqJVPj0hptPA31SfgI+BId0+WCRWWpPWcMf6NudoBWMCfcgSrvhp+PYGvL4kJuEB2g==
X-Received: by 2002:a05:620a:84b:b0:813:64ce:dd1a with SMTP id af79cd13be357-83baa7ff693mr230424285a.47.1758266700562;
        Fri, 19 Sep 2025 00:25:00 -0700 (PDT)
Received: from mail-qk1-f177.google.com (mail-qk1-f177.google.com. [209.85.222.177])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-836262b5592sm303603185a.2.2025.09.19.00.25.00
        for <linux-mm@kvack.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 19 Sep 2025 00:25:00 -0700 (PDT)
Received: by mail-qk1-f177.google.com with SMTP id af79cd13be357-80e3612e1a7so279937785a.0
        for <linux-mm@kvack.org>; Fri, 19 Sep 2025 00:25:00 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCUe0j1Y1QXFqzXi6DGQIpZiT9jpiFjBHdM2mLm3hs2mx7hZKTXvZKxvo0DS7mf1w9pzaZOlMvsMGw==@kvack.org
X-Received: by 2002:a05:6102:534c:b0:55d:b35e:7a58 with SMTP id
 ada2fe7eead31-588f3357b74mr639278137.23.1758266271934; Fri, 19 Sep 2025
 00:17:51 -0700 (PDT)
MIME-Version: 1.0
References: <4ff89b72-03ff-4447-9d21-dd6a5fe1550f@app.fastmail.com>
 <20250917125951.GA1390993@nvidia.com> <02b0f383-1c43-4eeb-a76f-830c2970b833@app.fastmail.com>
In-Reply-To: <02b0f383-1c43-4eeb-a76f-830c2970b833@app.fastmail.com>
From: Geert Uytterhoeven <geert@linux-m68k.org>
Date: Fri, 19 Sep 2025 09:17:40 +0200
X-Gmail-Original-Message-ID: <CAMuHMdVecUeLZ2LPpa457C0a=uduvDhQ4KZJx-++dEFJraRi3w@mail.gmail.com>
X-Gm-Features: AS18NWAI1tRNfDFQjIFUy24j2rmv5VjIZdZQpBy05JHeqlSMB-7iVf4odZQDlmM
Message-ID: <CAMuHMdVecUeLZ2LPpa457C0a=uduvDhQ4KZJx-++dEFJraRi3w@mail.gmail.com>
Subject: Re: [TECH TOPIC] Reaching consensus on CONFIG_HIGHMEM phaseout
To: Arnd Bergmann <arnd@arndb.de>
Cc: Jason Gunthorpe <jgg@nvidia.com>, ksummit@lists.linux.dev, linux-kernel@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, linuxppc-dev@lists.ozlabs.org, 
	linux-mips@vger.kernel.org, linux-mm@kvack.org, imx@lists.linux.dev, 
	Christophe Leroy <christophe.leroy@csgroup.eu>, Richard Weinberger <richard@nod.at>, 
	Lucas Stach <l.stach@pengutronix.de>, Linus Walleij <linus.walleij@linaro.org>, 
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
X-Rspamd-Queue-Id: C09E8140008
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Stat-Signature: rhhewuprmx59ym6gqth8ygthjkmkfttg
X-HE-Tag: 1758266701-141328
X-HE-Meta: U2FsdGVkX19d5h026s3k0J8xLz97HG41wPh1LDlA0PZ3mypHue/oEBVtijGcnfaNoLWQ4Q4nSeRrAkclJaWi/QZmLF7JOAhD7St3e90ImcpdqgXyB3wGPHk/UcRrN12J7q9GaR3WlBAfdNDOMI/4MAMzVxYCNiUoq13S31D/SK0+oVave/Y8NtRmDGrh/Gwz3sciX7O6ehFFBK/h9kog9T3XqKkvCUq2uzpTHzsl8ELND+oY0Gag0EhmwTgYHfCgbAGUx+cR2LPZ5iUx3tA8g3BISuin1bPK792xg6yxhdXxMFZTVX3pEU3hSCydcOKDZtHRL7HQP/1Dx07O+WDCYKCJNOrNHcR5F1z+w9BbvFCRaFlZjTgxYDo7KRwla0wPOv6dj2rfE2p3LM6BOHpgQ3B0OG9wjN2xZGERoyJd9l74XX6me/Zk0p9ExZ+VmjC0cLMtsP1+un95ONHF/QgtGC2RIPyKXrvfy47yjvxE6xAksmu3375MTQcaSgiQQHG/lbS5PBX6oW90qs7hUHiJStUW8ymMPU2ShrWvjn8STcG/j9zWuh1MMublrcsJ52qh4bcdgapi0pSgWaE6+YRnC07Uvlc8ZD/yDvs0s+pT9hpZA2cCMqXo+lGqp65KC6mMTHfYlRwp3ZO/MaSbZ49xbhccJwTwr5BAc55BDoBr+ugqtt8AjJQGWnIbQK2sGLPxxKj3SwdzVkRp+U92/i1I7dWS8zRbuT2IAAvrhfJ5x6qFKn93GL4gt27DVLAJL+/l4kQKG8dq45/42/N5pij4Nd+80B7gmClX/sDwnQPEII+oNCV8/IdZVaBE74CDXSFuSi3IA5G48yCZw6EOLc8un5egzVaX1LV7jUuv9r1eo6m0Kyj6yowzrRi/ZbrGDGkhrVUrn0df76hAK3Ci6zRVZMcYvv9hsHTGwyrxUrQsKQQn4Ay5ea9gklnJv8HdwRPfz7nACTZIgTjSbl0N8kv
 TIc3CubT
 3ZxZGq4/5I6NEqhk8e7WSKD0rh6sFV87a2gQVjBnp+eBFcloRZiBt+8N8CpEx0c4pMBUIYxY11WIuY1k2hfmH3Xui5w94/R/+nyukpMMz+1vs1ph/Ttd3ALVlG2OaUHmw2C+eod91AuDTOXpPt69gv45enTHnu/Y1h13QZbXeD51aFpE02Jjvjvv9WyHPPvkNP6IwbcFROVEiFdvnq2P2koRm7f9ch5M92MiD56S4PQjECGTJj9E8enA5dHKgaq6E1YMWA2vPFmvDM/YEJsYuC0nFkP5Dbm6dhTS8XrSN6GInnWV/2eVwGdEVGdbjCODV8/++Szd8I3hZfJ6bGMFafRmgEQIZm0SPG3TC2eZBloBP6LKIY6Mg+KRX7E5TQnhte2DR5bpF5jA6AhflQCIb3YYAL23jhL9QdUjbKBzTnUYLRYqpSK7XedDZO8R96xatdfPIEvbGxgKO1oW+KAmSptvv/MCR8HAadM6ZGfVxZA+DUUwDmRW5WjEAvIJVDzIqWEqmWA+MJVkB9TP6bWAfyXHn7Q==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Arnd,

On Thu, 18 Sept 2025 at 15:13, Arnd Bergmann <arnd@arndb.de> wrote:
> On Wed, Sep 17, 2025, at 14:59, Jason Gunthorpe wrote:
> > On Tue, Sep 09, 2025 at 11:23:37PM +0200, Arnd Bergmann wrote:
> >
> >> I'm still collecting information about which of the remaining highmem
> >> users plan to keep updating their kernels and for what reason.
> >
> > On this topic of removing some parts of highmem, can we say goodbye to
> > kmap_high_get()? Only ARM uses it and only for
> > !cache_is_vipt_nonaliasing() systems.
>
> Good idea. I think we are almost there, just need to verify that
> there is actually no impact for existing users. I already knew
> that there is very little highmem usage on ARMv6 and earlier, but
> I tried to recheck all platforms that might be affected:

> * Microchip SAM9x7 is the newest ARMv5 chip, clearly does
>   get kernel updates, and the only one I can think of with
>   DDR3 support, but seems to be limited to 256MB total memory.

Are they limited to DDR3?

IIRC, someone (you? ;-) told me at ELCE that Microchip keeps on spinning
new variants of old SoCs, to accommodate the changing DDR landscape
and market.  So perhaps they also accept larger RAM sizes?

Gr{oetje,eeting}s,

                        Geert

-- 
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds


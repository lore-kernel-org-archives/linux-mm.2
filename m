Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6D19CCDB471
	for <linux-mm@archiver.kernel.org>; Tue, 23 Jun 2026 20:03:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 483176B0088; Tue, 23 Jun 2026 16:03:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 433E96B008A; Tue, 23 Jun 2026 16:03:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 324396B008C; Tue, 23 Jun 2026 16:03:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 07A546B0088
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 16:03:52 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 703541C3C6E
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 20:03:52 +0000 (UTC)
X-FDA: 84912253104.21.AD6ABE7
Received: from bali.collaboradmins.com (bali.collaboradmins.com [148.251.105.195])
	by imf04.hostedemail.com (Postfix) with ESMTP id 96F2640011
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 20:03:50 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=mail header.b=qrn7Niwy;
	spf=pass (imf04.hostedemail.com: domain of boris.brezillon@collabora.com designates 148.251.105.195 as permitted sender) smtp.mailfrom=boris.brezillon@collabora.com;
	dmarc=pass (policy=none) header.from=collabora.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782245030;
	b=4UJ7qts1k9yzN/kjlDC7D8JIP4XIEknW3irDoHLrOwWdobTCNGHUa/QShh2WcaPQ4CbL8m
	wsk+DO86i9KdfwXse+MDPsQb4O50ANPuIfyUOBDdmWRzMSxq4YBKsx6XSbA4iDyZHC4WxJ
	5S7fO1eG8l1T+0WDBbOMLCt2fClYEfc=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782245030;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DXELDEspCfpyJMg4+vOKDxU3lUu/ClJJRZ+C4E6jvrM=;
	b=UkdOh7tXsg8qlb2H1E/vnhq+J2q2SM/BrGjdOArVnZZYWKVIDnbW2Nz9zChz4ZweT8PBwJ
	o4JqzgieBRt4VJniAcQu57iDJ8Aj6az0Nn5fc4YB0MrJnPCE+6paRrgP+uilj2bcNL1qgy
	9cZd/XYNFPwDxFfteTamYr5aOt3u4So=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=mail header.b=qrn7Niwy;
	spf=pass (imf04.hostedemail.com: domain of boris.brezillon@collabora.com designates 148.251.105.195 as permitted sender) smtp.mailfrom=boris.brezillon@collabora.com;
	dmarc=pass (policy=none) header.from=collabora.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=collabora.com;
	s=mail; t=1782245027;
	bh=LEMNvch+xEu+3Is5PhYgSbaYPcKf+aaNjlvCqRGadLk=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=qrn7Niwyx9X5/cf6oD0iBsejz56tkf6uuuHGLwSsSOTkXQmRdFr7zA6fWbdRHQxWV
	 5DgR1oseO7vzVTMkOtPX7QHDNTgesmBT1Mnufn8y6f1pe2ONFut1J1s/dAl05ln7Hd
	 YWd7Z+NkFvbfsU3AuzmL8raJau21+w9Lcu1n4iP4m1ZOF94rZ63HVqqbCQIXwNkWxV
	 aqkWJl4FkiZflSqm7yL/YsKw4rLfINNulCO5afB1iUiSvPsf4b3sIwnKh5OMWbOujd
	 EJ7zdicpVdczoxpYIaL7C54lqEMauhzon34+7VgjNazjlu5cU7C3jbR+QA9e/jMpHn
	 EFWt+vmwaZ+DQ==
Received: from fedora-2.home (unknown [100.64.0.11])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bbrezillon)
	by bali.collaboradmins.com (Postfix) with ESMTPSA id 0F28A17E02B5;
	Tue, 23 Jun 2026 22:03:47 +0200 (CEST)
Date: Tue, 23 Jun 2026 22:03:41 +0200
From: Boris Brezillon <boris.brezillon@collabora.com>
To: Matthew Wilcox <willy@infradead.org>
Cc: "Christian A. Ehrhardt" <lk@c--e.de>, dri-devel@lists.freedesktop.org,
 Steven Price <steven.price@arm.com>, Liviu Dudau <liviu.dudau@arm.com>,
 Andrew Morton <akpm@linux-foundation.org>, Maarten Lankhorst
 <maarten.lankhorst@linux.intel.com>, Maxime Ripard <mripard@kernel.org>,
 Thomas Zimmermann <tzimmermann@suse.de>, David Airlie <airlied@gmail.com>,
 Simona Vetter <simona@ffwll.ch>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drm/panthor: Check VMA boundaries for PMD mappings
Message-ID: <20260623220341.7ad4a0e2@fedora-2.home>
In-Reply-To: <ajrRhpVH6uhOABnV@casper.infradead.org>
References: <20260623181942.1536598-1-lk@c--e.de>
	<ajrRhpVH6uhOABnV@casper.infradead.org>
Organization: Collabora
X-Mailer: Claws Mail 4.4.0 (GTK 3.24.52; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 96F2640011
X-Stat-Signature: wtgscko1jjbszifz3pmo3tfmbtc1coa4
X-HE-Tag: 1782245030-244377
X-HE-Meta: U2FsdGVkX1+fqPplaNRCsO/z3+MtHRm/iPR/QTSrMOEnn4qySw8Umf+gfoQtzme8TKZH4fQIcrxX4djnRXeEtDs9e7oM0/fG4FD/MlLZVGcM04jM+T3beSM4ezx6SjxClGXj2BwrWmtOTwZ7nL8Xcwq3qv4UyddnxHTeY/7/wM1lmsOEB2AedAQBP2L3kflgzTrXAjeVjNmKeRp/uGbNApuELCl2AXv6M4KL3H4KXNRJ8kaQNB9jdqEL2zTnxW7pFFTWRuFavqaelfL5dmQvFJTCDoDmsnN7IDXoh2H1yoRN6L0MP03Gpu/U9jKxsENv9TqtYJVs8JQcQnMTpb/t9+0B+SFv3Q/pPS3KHXwmtCtVeaGHQmm/Yk2tpBTBGSxAFYVkCn7zdo9fswo/O+h664oDoMWqJAafCuyFO8MLZXL+hewnGaOkPcRJoPIbpVcuB4Q9LWxJ0OJQRF4qnFI790z4x4xg2kZG3sG5RBuXwSAIcxjUGXsbjx/Mplc8Dyhom3jYAeJc8R7GI2xwTnPXodRNfuP6LwhMXmuXnihoFLXIGcCde2mblUC31xPf83aOlkjGwyQjDX/W0U/Awrp24eKAz1ElJS6F1QwTZWIWOJJb/nP+6OwFvH50K4npoWGJP385MiNfo7Uj09+OxovuL1iG8ZL7EMCmI/GPcjW0jptvmEcfqLu5hhu6HMxe0eq8BM94JPzk2Xea8zKUL8CGzTRagOJzk4+6b86HlsCqvmueKJIvAHV66MQoCMg8J+yXGUUMWpPcQaojHwkOHTX6/he9lzrsHTEsLk3oM7DNrEAOzNMbNG5K6zEYdzZhOXMSck6tuwx+I4xyCqXhfFvRMyAgs4VRyZc9nFN8D89meBuSWzZO1LhK3s7ZpJJRfaE80zpEmdOGtpsfBYIxE5LPbdkGEoauoQuBkDn0BY2pPKkY2ulyCN3kGQf92vY95gPO86yJe5qlV5P02sQrkmJ
 TGPyGPMA
 BE8EFTggwc5IILEFiRmlnOIGZLrbFJUfOPAPO3nwTHJE+D9f2mG68YrWM8v3Ig9msyTuNEpjkfvo8m0y/8fYmDUHPn8KqHdQ8w4CEoAIri+COxEzdmJEki5qeLAQVZSFVaF85KIB8jsmLthG8M3uT8ffq797ZmjBgUpNWsQygBjgSV496EZBMDFb/k0FkAkcMfkvbj4FWsyxBxipJNvV79fk16nqS55GOCYPJLPmj5IbPQtxp67pQZV48P2Ls25GArXbUYH/qx4raEoyrQt1lcJCHPZd6kLV4Zyqg477QcSv9Oi2xw0MW2DySmpzsimvbIc9ISLx+WFXFt4aUCkMHcVECLdHpxc2zhLTsKUy8EJxRo7CbgfcjNff3bRm+ZfxIRHHux8ZTGWvJygeroQAfxKGZeeSAcPEeQAtEzaa3h9FmK3wJ0p/+NaO46/k0N6x3HJZA9IVpDKHDW+sdA+V26r6AAMAe51lf5ZZZ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Matthew,

On Tue, 23 Jun 2026 19:33:42 +0100
Matthew Wilcox <willy@infradead.org> wrote:

> On Tue, Jun 23, 2026 at 08:19:42PM +0200, Christian A. Ehrhardt wrote:
> > The panthor version is only compile tested because I don't
> > have the hardware. However, the code is identical to that
> > fixed in [1] and I have a reproducer for that.
> > 
> > No need for for stable backports. The code is new in 7.1.  
> 
> What documentation did you need to see to persuade you to use
> map_pages instead of writing a huge_fault handler?
> 
> (yes, you're all Doing It Wrong, please stop, but help us help you)

We tried [1], but couldn't figure out how to make it work with the
current locking in the gem_shmem logic, so we decided to postpone the
map_page() addition. We plan to get back to it and implement map_page(),
but my understanding is that we still need the fault()+huge_fault() as a
fallback for when we can't acquire the locks we need to service the
fault. Oh, and BTW, we had just the fault() implementation in the
version that was merged, no huge_fault(), but this fault()
implementation was mapping PMDs which led to another issue [2] that
forced us to add this huge_fault() implem.

I'm all for improving that, but if I'm completely honest, there are
times where our MM-related questions are left unanswered ([3] is one
example), and it gets hard to figure out how to do things properly
without proper guidance from the MM experts. I thought [2] was one of
these, but apparently the MM list/maintainers were not Cc-ed on that
one, oops.

Just to be clear, I'm not blaming anyone here (I know how busy subsystem
maintainers are in general), I'm just trying to explain how we ended up
with these new huge_fault() implementations (one being a fork of the
original implementation) that you were not expecting, but also wanted to
point out that we've been pretty transparent about where we were heading
during the submission process, and we didn't get a clear "no, stop
there!" back then.

Anyway, I'll try to get back to this map_pages() implementation, and
see how we can handle the fallback when locks can't be acquired in that
path (I assume this would mean no PMD mapping in the fallback path if
we get rid of huge_fault()).

Regards,

Boris

[1]https://patchew.org/linux/20251015153018.43735-1-loic.molinari@collabora.com/20251015153018.43735-4-loic.molinari@collabora.com/
[2]https://lore.kernel.org/all/20260319015224.46896-1-pedrodemargomes@gmail.com/
[3]https://lore.kernel.org/all/20260319155028.291f3157@fedora/


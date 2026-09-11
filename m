Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 68A60C88E53
	for <linux-mm@archiver.kernel.org>; Fri, 11 Sep 2026 18:32:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1C2166B0099; Fri, 11 Sep 2026 14:32:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 199A46B009B; Fri, 11 Sep 2026 14:32:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0AFEC6B009D; Fri, 11 Sep 2026 14:32:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D70236B0099
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 14:32:06 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 5CE5A8032D
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 18:32:06 +0000 (UTC)
X-FDA: 85202325852.04.5C86893
Received: from mail-pg1-f179.google.com (mail-pg1-f179.google.com [209.85.215.179])
	by imf27.hostedemail.com (Postfix) with ESMTP id 8C2FB40008
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 18:32:04 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=WtiwWeYD;
	spf=pass (imf27.hostedemail.com: domain of dmatlack@google.com designates 209.85.215.179 as permitted sender) smtp.mailfrom=dmatlack@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789151524;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=647PeDACYFGwHy56KY6C8DNyZ6c/Uo5FYVw3HHMYVSA=;
	b=f0cslwL5QGA9aWRuvi2h70CP39fYYB7Yc6KoFw1FBRY1P+NpPdrVr/x6u0vAen0BoANujM
	wn5ClVqOfEbamB9AoLX979WLcY91hFfD/InN9DB6giQyfUt9YhXbxHzlSMNS7koIOhxH3l
	27UjAqdLkZ7MzaU1EYgWDN8v+OX2EgM=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789151524;
	b=AhcGS/V81kZV64la6W7zulgvp4J+2pnhxpNN+Px4SZG2g2bkJvp2nrROTDecMDoscDLLRZ
	IS1gnlYpNSoKk3K+BbiKAQc27+pBxbZFm8+1uEVI8LzIktA0PC/C4n5Y7L8YM8vtCeb2Fc
	+NGijQjCI32RssB77SuHvKntO58tJGA=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=WtiwWeYD;
	spf=pass (imf27.hostedemail.com: domain of dmatlack@google.com designates 209.85.215.179 as permitted sender) smtp.mailfrom=dmatlack@google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-pg1-f179.google.com with SMTP id 41be03b00d2f7-cc4d64bcea5so362514a12.1
        for <linux-mm@kvack.org>; Fri, 11 Sep 2026 11:32:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1789151523; x=1789756323; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=647PeDACYFGwHy56KY6C8DNyZ6c/Uo5FYVw3HHMYVSA=;
        b=WtiwWeYDElL3ffkmyORV/D4t3inyT+t2HadNtIivz5YyAh5fBn2aPDlDO4VSOm/eqG
         qAJlJS8SuLdWrbyqA7PH/qAgdZQuePoSOaKJwjm7Wqs5QXnuFVKlC3SryaIgnDx/1h/l
         hdGrQNQeXXdvm3h4Eyq4BY4s08k8QDtbPHotJuqiymH76x04gdXfuAOUx7VwV/7ooSek
         xRFvE6F+kvVlIx45vCpPYTEDPnnawQHmiBIgf5G6JXAKpjCR1vQpPARm91tzkBPRx6Hw
         clrQyUiz/chjAEdKMhrCSSb0uv87mwGsmoPJhiU3Fcu77ag7HWyZiU80kjorZTC9Qp/P
         SFaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789151523; x=1789756323;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=647PeDACYFGwHy56KY6C8DNyZ6c/Uo5FYVw3HHMYVSA=;
        b=XXllVbOn+INV6TTCRbLgnBsdq2TomEOFXwQneYJf5JJEs5Qrwu402b/Nb+08NXaLfd
         YHalXyyP0L0tdy20D2+nW348ADcGePSt7DsIwoGIMhRw9HSpEge/E2ebiuAYn9La8RT8
         Dkm6TWf6zX/wr739YeIwtIOKtQv8SB8AHYi7rRQgX8wBU1MiG2vg04A6LR9+rv+z2OlN
         nbRUz1FuFwPC9LkIqC1ydA+gIjJjxUq2/0N4oSu2elDk337WmuAwcPimiNDJq1EG2qhp
         Q681q3+uSDs2aFrUfRj0Xpu/+CfbACT5JTBetqXdC+roK5wqkYv5g/RHNgH2VuNmpfqY
         btWw==
X-Forwarded-Encrypted: i=1; AKwUvBwiIH1aksFqKn4BgRS+HgCdD/FrdcLwppua1HvVE/bRt5QuR1tUjZOl1lGc4dVBTSn06jAz69zOLg==@kvack.org
X-Gm-Message-State: AFuF++nxmTQFsUsS9Y70PLyuHtSN/UoIp5Gs3SrXYvWU0Jnwg+47sV8a
	SM3bgUe/dvdzHi/zo/LEBbnX7S9Qr/k2tqLsup6NAq3/3D6ewfX6Fvlb0aHxHxwTyg==
X-Gm-Gg: AYBFou2Qm291GM7HNZ1ezIxWVQejbPo8Fjr0/7wVhqWtecHhK+qxENwfgfnAnQSUWTT
	uPeXaOIMvVz+bhCDjlmVQZkStwB2tBlncFh+vYwe5A1S5BK6rEL8yiciIx21ZMjEehgFTwr7qiG
	YWm6CkkBztKNsqpFf6J/52eUdIx4H8jpPRJmcMCCxBUUhtU++IQSU7Y3IRnjsCm8k60hNZVEEFc
	J3XtsHZQ0jPAohhWAW9NUrAhkNpojltVaPE4KO3XOYeI7vpFU7YAP1+c5j0ii6dDkR5dg35Uzcc
	xdO2ggS5f3lmRwdec9Evz7FsxnW0xkwlqaNv8noh/IUFP8P68POdXfXZuQmHrbUlew4Z37l6kOJ
	/axXEKT+1ZZ17ZB1a/5JGn2FV/Rt36nrn1wanNq2upLpnmAb86GegZ665ZiNFVmRv6dIGDYcGUW
	8huL3cZZwq0Bpda/66/P/dL1W+y3LcHChaPhkWLp8Y33FbEWwRMUnQ2oxrYax5y5eeKIpG22P/P
	mxgHBN6T6kpGjDllNZhHzd6cYn9f/ag5f7Lir5XXzfX/ie7uvc=
X-Received: by 2002:a05:6a20:4308:b0:3c4:3767:adb2 with SMTP id adf61e73a8af0-3daed46ab05mr10698355637.1.1789151522711;
        Fri, 11 Sep 2026 11:32:02 -0700 (PDT)
Received: from google.com (192.150.203.35.bc.googleusercontent.com. [35.203.150.192])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-cc4c657156bsm1621771a12.21.2026.09.11.11.32.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Sep 2026 11:32:01 -0700 (PDT)
Date: Fri, 11 Sep 2026 18:31:51 +0000
From: David Matlack <dmatlack@google.com>
To: Bjorn Helgaas <helgaas@kernel.org>
Cc: kexec@lists.infradead.org, linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	linux-pci@vger.kernel.org,
	Adithya Jayachandran <ajayachandra@nvidia.com>,
	Alexander Graf <graf@amazon.com>,
	Alex Williamson <alex@shazbot.org>,
	Bjorn Helgaas <bhelgaas@google.com>, Chris Li <chrisl@kernel.org>,
	David Rientjes <rientjes@google.com>,
	Jacob Pan <jacob.pan@linux.microsoft.com>,
	Jason Gunthorpe <jgg@nvidia.com>, Jonathan Corbet <corbet@lwn.net>,
	Josh Hilke <jrhilke@google.com>,
	Leon Romanovsky <leonro@nvidia.com>, Lukas Wunner <lukas@wunner.de>,
	Mike Rapoport <rppt@kernel.org>, Parav Pandit <parav@nvidia.com>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Pranjal Shrivastava <praan@google.com>,
	Pratyush Yadav <pratyush@kernel.org>,
	Saeed Mahameed <saeedm@nvidia.com>,
	Samiullah Khawaja <skhawaja@google.com>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Vipin Sharma <vipinsh@google.com>, William Tu <witu@nvidia.com>,
	Yi Liu <yi.l.liu@intel.com>
Subject: Re: [PATCH v8 08/12] PCI: liveupdate: Adopt ACS controls in incoming
 preserved devices
Message-ID: <aqRJF8OME7hn7CJr@google.com>
References: <20260728221007.2098560-9-dmatlack@google.com>
 <20260910235149.GA364189@bhelgaas>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260910235149.GA364189@bhelgaas>
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 8C2FB40008
X-Stat-Signature: i9hdpx3je5dhjgh3ju5s4sb3timeaoof
X-Rspam-User: 
X-HE-Tag: 1789151524-558089
X-HE-Meta: U2FsdGVkX1/xTai3hUYhTwTH6z2fsm6ishZ2AKTgayzmHKIBmOHfhD2tCgCBEMWNyyIAIsVNj9I94a9kop4uAKposMVxIJa1vJlCjfpryCTCpCbEMSGOly7UfvRC1HIP9WgM7y2svwkFIgwSY/SqmRjf4jtwGbLEwHZ+rvMILj7UG/S3WzsFXZsFjJqpWeLqQkdBZcoLsnehVGPbZSO21te1bvK36c8P0PTErl8vaxenhXI8JnGaojdJWRk9zoxW2S0p1GZLSrlrqRrPsSJ7tOmpiKKtxl/HCWYFEdhzjz70uagOOhOJ+3pLQu6WURL4N7p+yUiCwXl7X2H7OkWrzIzfqAQ5hqIe5q3tM0Op2YmA1IxUYN6oUxr2yqX8m4HN3f7NkUdpqBmTxF7xQkDSpIr08WqZTxb5+k2BPjN9HltdDa4LUmI6fGeIwujfPTCKOOMdjk5lxQpQlR/YDVxuk3Ew1tJsMpZMK4bqqSQEHIW1WWxpa6Up/48aISeUeiel2S3yBbAnsQQZM/znxcRKcGki8CAg0cKzuarA5BH7ijnu5O+9TveJ5Y/MOOveQYlqEDpZOqF6hykgFqSbWYJu1VOq1BD+ggdpEetBQm+Csbf80UEsmLlWtQix6JYoUe2ycOWO8yjO0P8PB0/cBImMS/NJdhRFTnOmQpRK40v36y6kg4YVfn9FSjxJG1WKXq6ps6h+ha+zUYDQ4cIo+H38qxgbJJyfbFaJqOi5Pz543me39bWVHuNKNkoNyrMD14MLDOqz9gZYhSmxYeiSbVMUx4vffp8mB4gn7/2Ik0LXuIWisofg/OP0BqT8Ru2Kq8LQFEZzqakYESdQy0KJVgBI9ooK1Pa32Xaq76R1YkVDK0aZ/FQT6wqoKBiyv6YJuh+Zx7VUdBKH5V6ERCjrFYESycZIoqbLsd0unlIG5+ykujrWIY+A5wW1HvscihF3xpDJiyczE+9Dv+VatTK50Nw
 DVValjKa
 cuWtZ6Qa86Jps9VAi6Nx1Com5nOjSF74sTmilsgO+9H6utDjCZXbV9HdC5JnfDYT9sq/GwsY1+4XWQ138bGjE1oEidbXshjbPAr3Am4Npru+F8N4NN9L9BDgj8WCmT3CMvOst7BPfumwgdgeq1C6XutMgBig4lQhPu9QvMgDIskHbqWhb1+T0T7unJa2D3d3lH0zLulBEMoH2GmoePrCIz6AhtDIizTl1ZGXeXJWC9W3kNK9kx46ULp4TszQfYKLt1w2r6aSDxwrlbKFvFY+pMhq06fHwgN2aKAp9eE1RFfseI03cDp2DRS+HcTOob2pclMuxtATj5uVt1JrElfw5zNPa0R9GaywQlp83S9JUcR00dhU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2026-09-10 06:51 PM, Bjorn Helgaas wrote:

> > diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
> > index 77b17b13ee61..22001bdf4c97 100644
> > --- a/drivers/pci/pci.c
> > +++ b/drivers/pci/pci.c
> > @@ -34,6 +34,8 @@
> >  #include <linux/aer.h>
> >  #include <linux/bitfield.h>
> >  #include <linux/suspend.h>
> > +
> > +#include "liveupdate.h"
> >  #include "pci.h"
> >  
> >  DEFINE_MUTEX(pci_slot_mutex);
> > @@ -1008,6 +1010,9 @@ void pci_enable_acs(struct pci_dev *dev)
> >  	bool enable_acs = false;
> >  	int pos;
> >  
> > +	if (!pci_liveupdate_enable_adopted_acs_controls(dev))
> > +		return;
> 
> Ugh.  The asymmetry between pci_save_state(), which does nothing
> ACS-related, and pci_restore_state(), which enables it, is sort of
> sketchy to begin with.
> 
> The command-line parsing in this path feels like kind of a wart (not
> that you're touching it).
> 
> It just seems like this path is already hard to analyze, and
> liveupdate is making it harder.
> 
> If we could save/restore the ACS state around the reset, wouldn't that
> solve this without any liveupdate specials here?

Yeah that would simplify the liveupdate support greatly. Let me work on
that for v9.


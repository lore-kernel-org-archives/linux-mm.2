Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 266B4CC6B03
	for <linux-mm@archiver.kernel.org>; Thu,  2 Apr 2026 05:52:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4EB026B0088; Thu,  2 Apr 2026 01:52:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 49BE26B0089; Thu,  2 Apr 2026 01:52:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3B2CF6B008A; Thu,  2 Apr 2026 01:52:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 29F066B0088
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 01:52:13 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id BAF9258E73
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 05:52:12 +0000 (UTC)
X-FDA: 84612545304.01.85BA587
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf17.hostedemail.com (Postfix) with ESMTP id CA44F40009
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 05:52:10 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=PPxOzgQx;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775109130; a=rsa-sha256;
	cv=none;
	b=BNiR1U6/gx4LeafSENDXlkz9u7EAN+sirRrunqVJ/W//Ws3aTA2J0EiWX5xyLqo28FzY7w
	u62tnUsDH15C2v224MxL7I6gIdMAjk5PupFTFY5KEBT1frEdMlSjCXhmiEuhmtqvYG/JdJ
	AO//HvSWTwO10CPDQQC+6iEILI8uvcI=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=PPxOzgQx;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775109130;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nssnQak+6swktPuhkbd/kvAIgTaeKRiMkpqP+p2SjUE=;
	b=i/8CqG9bN8u0k4Fz4RNHIwhDuF1WTJwSrogvdu8NEhAveUfyhjLULYNLkt7GzfYDjWQ+aq
	6KvGh/pCtOY3I+I7i5H6WonNi7+Ln10bb65y/XhV2xp5W43B6A5QzUmTR1HyooCMU2Kw0B
	ThSTnbUuOjL/0JSlSWSXU/3PWakrX68=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id A0A934448F
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 05:52:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80785C2BCAF
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 05:52:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775109129;
	bh=nssnQak+6swktPuhkbd/kvAIgTaeKRiMkpqP+p2SjUE=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=PPxOzgQxzk7W5Vo/klTC43Wcu2S7zUu+/bBSFAgPQh/fEZSdpk8w2GSUO7wbaL/Gu
	 Mp4aJSc6R9KKatkw+PphFmtdACSQ0wohQ2kldW0QJnP5QKgSvUgQz9crzjUgjfeusH
	 OKl5+mFZga3eIIsx+9FWRGWPRzzC3Nkl3I9Wjs7bWdHkVxVnKLwnviSCD7k653vf5E
	 FgMe5I32hTUA2XHvsiZL1ePhwO1bz86mHi2TxF5voI3Yo+Dakr8tvP6Lk8FXurzoW6
	 /HXuEMCy4fYv/NqG1Y6tVJ1PeA9Jf47F/Aos+d+E94m740RUg9p1SsgZfv1gwLAANt
	 TljxQL/Qio6GA==
Received: by mail-qv1-f46.google.com with SMTP id 6a1803df08f44-8a56ca653ceso5400396d6.2
        for <linux-mm@kvack.org>; Wed, 01 Apr 2026 22:52:09 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCWlRbVBuDs0FDx2YdwT5w94981B/PrknX5S7X74nkQaEWTDkR4UlFkO3nZ7lllWgulaiszfYb07zw==@kvack.org
X-Gm-Message-State: AOJu0YzUI2C1sGKZZurcIihtcy5n/KddilxsPrCP/6EOYx7phPSge6TI
	K59kM5R/uadpDG0HcAzLcNTn2kzYinCtm2lG1FNGVg6WsJSdtMHNHkkiBdQhg70GKoqW8dzCzBO
	8drtwC3S21HK0CIZl80Hw12GuEG2ifvU=
X-Received: by 2002:a05:6214:1bc7:b0:899:f1bc:c6ab with SMTP id
 6a1803df08f44-8a43a36d0f8mr96439976d6.42.1775109128756; Wed, 01 Apr 2026
 22:52:08 -0700 (PDT)
MIME-Version: 1.0
References: <20260330071229.14614-1-devnexen@gmail.com> <20260401074753.238053-1-devnexen@gmail.com>
 <ac3sa2GB79LGADpY@casper.infradead.org>
In-Reply-To: <ac3sa2GB79LGADpY@casper.infradead.org>
From: Barry Song <baohua@kernel.org>
Date: Thu, 2 Apr 2026 13:51:57 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4zhTwrHZogHK3LLCw=UWwBu2cJeZze5SmOtkXw0vu8Bag@mail.gmail.com>
X-Gm-Features: AQROBzAx5-Q9HVOL64RCE3HiUeRJwuFRF-Fo-axDIx8i53tCpmju9lCwo6ELZx8
Message-ID: <CAGsJ_4zhTwrHZogHK3LLCw=UWwBu2cJeZze5SmOtkXw0vu8Bag@mail.gmail.com>
Subject: Re: [PATCH v3] mm/page_io: use sio->len for PSWPIN accounting in sio_read_complete()
To: Matthew Wilcox <willy@infradead.org>
Cc: David Carlier <devnexen@gmail.com>, Kairui Song <kasong@tencent.com>, 
	David Hildenbrand <david@kernel.org>, Chris Li <chrisl@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Kemeng Shi <shikemeng@huaweicloud.com>, 
	Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>, 
	Youngjun Park <youngjun.park@lge.com>, NeilBrown <neil@brown.name>, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: CA44F40009
X-Stat-Signature: taoudftnj9aw9xb6c87xk7mugd53dxnk
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1775109130-632178
X-HE-Meta: U2FsdGVkX19aPim9SpaG8MCswjurkxvB3Rc20gP+vskwUUu2MNNS/K2BjbrQ/btkCckTxTU74IcwKiEijEa0PIF5D8PABqGlB292gDawFwBkvViaXJUIxqC77ggpgMZna91fE9TNFoHCkBuBi+bejczmreJOTLpLc9nYItXLbJ16ReDQQN3etC3Kiht6UMPoUIwP9BaETOQx+wbIgAUxKauSZFDcLGvO9Sl9LneITAdbuY7wWK1SkqDe+9PpyYET4mR/EdAxGASAw9wutdhd53Ae2zxsiZy5BFtnWfQ2oTQe6Q2VODvNVrRiUHr/euH0uD+wJvjEMlX1AheLwhKrHmgDJYQ3bZNQW9zwGm4Y5la1DCpIwXmxLFvU1QKrRXBvCXfQS8YUpTJCPGNAmqRKf5pLxpj0tDN2yMSkgCK18dMyl7HXSl+B+qOyRUYjL98X0QzIhYHU1szUttvucsUQMe0oeNhl515vMpVs27N2JwZ2rOynMYoQ3dVvyZzK8oHJrfvEHYFnTUOjeHechinVKlIAij2DC/HxB2cQ4xTrzoE+/aEijBz/lfIpnS86PqIA3NnRMbUmSEshcgWyyyp9aUnbLD3VoSvwztezUt9Mj++Aymf+D9f/w+DLWfMcu0f8tbhzXemoPaV32dO9HciOctWU5O6khByH9Cfxbzqv2p6JKg2YNW3BRTiuVkVqFwQAA3V5S4RtKrGfsvcPIWn1+JgVBfWqeFjWkpiWY4x2WmoXYm5V6TLJj+Em85QhfSQnr2l/wYausr2XywPrz/29xiYib9uMuVIYlwSp2mmlzY51vFiuhnEfUHBj8LrUvkDkJve4b1fR6D0ri9DxkmGj1NpzqnMDMn+O0Fh6/aDa/GcbJaqvArzDYsVish6pTxRIyRqdpvcNEYu+hkNRtLNJIycpfXFtLovCeITvXwJsKkMp8q+Xiv5NX3DguOS14pxdeATOwZkL1viJKZo20DU
 x9k2GwIN
 ID8DsfM0B7AlxUeI5475TSeMIYutP6QvNXDHId33m0VhVPmvhaEt3SxnT04LRoJh7Sw3iz/yQJzudgRcwmEWDEfa+BQXVc/24ra4+o85fikJOf88LAhdHT74XwJu8ZPLLoCNbLZUwyIhzeq3O+fL3SVLch6UNhh+QJpX3YsFyvchM+AuVi9+1LA00OoTAQo6AUWoN5r1Ux/iMZS5cQH+LOpYipdtpi86jbnA4jjq6AcyVYWOw4oacgFCsZLfklh+5qsR6zgZbLbd8SzmF9vywBRsKAVJNzBxvjCITZW/W40Wfq1xg31XQ6p8u/FI56BPeGOCsjJX77YbfN5PD+IARZexsxxZ1Tz41UMXq6K1c5xbaEucWP8MDxlJOiGPmYZGyXnzzF3VlJ6L2RlkYJRNzGtQu0bPa9tbVtJGY
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Apr 2, 2026 at 12:11=E2=80=AFPM Matthew Wilcox <willy@infradead.org=
> wrote:
>
> On Wed, Apr 01, 2026 at 08:47:53AM +0100, David Carlier wrote:
> > sio_read_complete() uses sio->pages to account global PSWPIN vm events,
> > but sio->pages tracks the number of bvec entries (folios), not base
> > pages.
>
> Since you're messing with this file anyway, do you want to submit a
> third patch to rename swap_iocb->pages to ->bvecs?

+1, that would be great.


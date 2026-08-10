Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EF046C5AD55
	for <linux-mm@archiver.kernel.org>; Mon, 10 Aug 2026 12:59:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 11AE56B007B; Mon, 10 Aug 2026 08:59:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0A51A6B008A; Mon, 10 Aug 2026 08:59:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ED6C26B009B; Mon, 10 Aug 2026 08:59:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id CB4766B007B
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 08:59:40 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 6770580157
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 12:59:40 +0000 (UTC)
X-FDA: 85085366520.29.A372C9A
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf30.hostedemail.com (Postfix) with ESMTP id D9A348000C
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 12:59:38 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="T8N/ScqI";
	spf=pass (imf30.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786366778;
	b=3mAODuwc1ccfShvragmNOTdNwRUmbujrIi7TprKh9pexQ9XuDUlB0Rp/6Y+ipIO4+16Yo0
	EnxTcS0b39eH73q7LoQlGXlGF9b9rHJhL123jhmvBkz23kVoCUQh562n97KeswCcOXFte2
	ay/NIw5AkQ1vSLItza2czodV3qBUz88=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="T8N/ScqI";
	spf=pass (imf30.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786366778;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MYlcj+u2W+VYiTXVxXMnRS7W+yO0vIm6ouPOUsdwmkc=;
	b=OtPh/vig3n6tGNhCV6/bb24ttsxV4HyKHRZEz0/YVsqXAk4HbUnMNa6hpGzVMuzxGeNHDx
	diGyH+W/dwB153+uFQyKEr1ZwWeCaBp58VkCBzl7nTrMbVJps9W8qDLHE6HXW79RSxrQQ0
	OooN2iWkv7J04UD+Kj48nblljHQGHyA=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 5AFB3601E0;
	Mon, 10 Aug 2026 12:59:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B4AC1F000E9;
	Mon, 10 Aug 2026 12:59:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786366778;
	bh=MYlcj+u2W+VYiTXVxXMnRS7W+yO0vIm6ouPOUsdwmkc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=T8N/ScqIRjJAOgYs3+PaMhjfCYen/schAQ8rtWFcVjOk3u8u4UptVgFR6RGq3Dx5M
	 VGxojNJ5+REH0WMRaMaJtyik/MA18pnCOt1Sw/rDp8h6KvlISnfEQ2soFKvT6QiQOb
	 wb69fjmO/6z5KEtcNhwbYf5jr915axnLMLnECgKo4TGU/0p4sSL6to/iTe58v/lKET
	 SS7A5yrPnG5XG/SjiWg10X9WT69T2A7Skc/4xpnG0Y2pQH4Bld+fcLnkoGJeA6MpMa
	 B8NXAo/NJsKxM2bDsv8dcSZIAA/I59WOXNFIqvfMJevz9SsRxfieYAoWSE0YG7Ujgh
	 5cqh1ljwPA//A==
Date: Mon, 10 Aug 2026 13:59:18 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Tal Zussman <tz2294@columbia.edu>
Cc: Johannes Weiner <hannes@cmpxchg.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, Baoquan He <baoquan.he@linux.dev>, 
	Barry Song <baohua@kernel.org>, Youngjun Park <youngjun.park@lge.com>, 
	David Hildenbrand <david@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Matthew Wilcox <willy@infradead.org>, Christoph Hellwig <hch@lst.de>, Yosry Ahmed <yosry@kernel.org>, 
	Chengming Zhou <chengming.zhou@linux.dev>, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 6/6] mm/swap: rename __swap_writepage() to
 __swap_writeout()
Message-ID: <annK9htFubx6tNOF@lucifer>
References: <20260806-b4-page_io-folios-v1-0-0899bac3b826@columbia.edu>
 <20260806-b4-page_io-folios-v1-6-0899bac3b826@columbia.edu>
 <anYPVB3dwJCVoXVv@cmpxchg.org>
 <0208741b-ba5d-4044-9991-575d162f7513@columbia.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0208741b-ba5d-4044-9991-575d162f7513@columbia.edu>
X-Rspamd-Queue-Id: D9A348000C
X-Stat-Signature: inuc38braeomwq8x96cq6u3dj43gxf3i
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1786366778-649947
X-HE-Meta: U2FsdGVkX1/OvgJu9dGILgpaVZyIP9g3d2rcrLOU0RFqec46KeRTozqD+ObjBgvokoOZoTb9ujvlSselSfFqSl29fSfvHyFk43Z7foeM7d+DySmbmfvp4bDP2sxppLmE0mCFsHjM5ZxC4w6JUB3H0M2PzOKOysNztmvI55VH5YFPIVzVAzDloOqC5Udf9dBOaX20DAPfGdQPcL2FBchm6k+P2IJUgCQNj0Z++Rq7uJrs3iImbOdlj45s25O2WTNDNiCr0O8UVsuan0gJpXXkDaIQUgRoGKl1YsCxJIXNRwo0yZ8nrF23GQVnrsR30xfFQO2pVBF2YuM4BkBCKnjkt02Xc/KAMLh7W/GGCJGYZGvUQ9BNyIwSA3EiB+NEWNRHHvd3T+PqgSAWL9lvc4oNXVOWGNU3l2E6aSX6w2sqtr/USy6emekzdiVgaHCJ92q+Uo3f3Kakk/T+2Pefzh/eyxGvIKPEz78CdzKAN9cios0YoevuLg4OZgZdxKD6ELwLTcP38zh2drj7QJR5iUe749CHcyJ6nOZcCwdED07WD5B1G5TRErwaD4iB14lVtehQIGn3OSIQ6BgyLGzO3/7Q6K0PV879Fvj8ZPOWCrP32bXDT+RvGk2e+oGzpR+I9i3kWwEGRcbTyLr/wuq46fEHn44jfPaCPJttLm5XhYqSvsQSAYUAsVuhu2x82kyKikbuY0t8kBSCZoTPS+mo1e5Lf20Y5oRz3UvxvkiXzNp6iZa4q3oZV8MuMXP5ZILaUoeOFbZazCi+cgN/2d1v0HWglO1jTZC13PcMhLy2YbSA5G/TYVSanQOWs8be01cmFh26VCCrbaZXNBUxi0bE0KfXoaAA2m7Z5YLgIzDznFtcprmKoEREmPtkbhJOZ9FfSEPaylE54ZcfPsm7wzinwc2AvF4kB604myvtIPVCePtCPnEGL3Un69vwkzOtLDbjxNKsCBihzQxM4PcgzNtaixc
 6vdswmcl
 qrrIhq3wcYapYy9sonuDSrYQ6+zncqY4g/MydtS459amVdh1siZ+NwDfyEw0pMPXd+dL+2GCyMnJuW+FXWeZtkTukhZAMeorL4jxunI0Htn7gr8GFz+WJvdE4R3oT3qAcfCpWkNdKx6/gN6TsP3C3ss0/9wLEUeEawTysawWSfvwj5wy2LGwCECLNqduhtGWB2t13E7mBSTDob3vkUrgoEXL9qyKeSe2OXX5gnRKo2JGErdh479Df+KPUbj7kA+zBO/BcXkVHDi0f6ALn4hrlisn5Mj8n/rWAU2xeiUTb74PFK7g=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Aug 07, 2026 at 10:44:31PM +0300, Tal Zussman wrote:
> On 8/7/26 1:01 PM, Johannes Weiner wrote:
> > On Thu, Aug 06, 2026 at 06:55:38PM -0400, Tal Zussman wrote:
> >> Commit 84798514db50 ("mm: Remove swap_writepage() and
> >> shmem_writepage()") renamed swap_writepage() to swap_writeout().  Rename
> >> __swap_writepage(), which operates on a folio, to match its caller.
> >> Update a stale reference to swap_writepage() in swapfile.c as well.
> >>
> >> Signed-off-by: Tal Zussman <tz2294@columbia.edu>
> >
>
> Thanks for the reviews!
>
> > Looking at that commit, I can only guess that pageout() had an
> > influence on the swap_writeout() name.
> >
> > However, on the read side of the page_io.c API, we're following
> > swap_read_folio* consistently.
> >
> > [__]swap_write_folio* would seem more symmetrical?
> >
>
> That sounds reasonable, will change it.
>
> > [ At the risk of starting something, should the file itself be
> >    renamed? swap_rw.c or swap_io.c or something. ]
> >
>
> You said it, not me... :)
> I like swap_io.c - happy to stick a patch at the beginning renaming it
> if there are no objections.

folio_io.c! ;) Kidding, swap_io.c seems reasonable, feel free to rename it.

You should also update the entry in MAINTAINERS too.

--
Cheers, Lorenzo


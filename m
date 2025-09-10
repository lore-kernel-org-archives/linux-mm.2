Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B44F9CAC582
	for <linux-mm@archiver.kernel.org>; Wed, 10 Sep 2025 03:14:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1F8378E0019; Tue,  9 Sep 2025 23:14:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1D00C8E000F; Tue,  9 Sep 2025 23:14:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 10D2C8E0019; Tue,  9 Sep 2025 23:14:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id F37AB8E000F
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 23:14:26 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 97FA113B4EB
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 03:14:26 +0000 (UTC)
X-FDA: 83871872532.18.81890EE
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf05.hostedemail.com (Postfix) with ESMTP id E9C37100003
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 03:14:24 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=KABHcOun;
	spf=pass (imf05.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757474065;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZjxJqZKeziiercXpy4QeHK+X23hEf9eGdcDqTA22TcI=;
	b=DBRee4mVL4I1SGyMoeKA0GeXT8POvy7P3muiUGFX3J17M0DVdTP3WU4Jv38xiP4gXod0H9
	vHfu3zEXdXuLA722rokj0NSR5FxmMaj2yt+923SNKdxAzt2bwIkGzFv4TE9cQCuM2EbHqk
	YbWd5o9Q0btXDLltMpsmijzbj8DTD1o=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757474065; a=rsa-sha256;
	cv=none;
	b=EZOtSmfv4T3/qgtkLtygN6DwP9tMoTjkma6Mgfd0tGX3uj9oXbBLWID7iPRCCDzoY2I633
	5bkjM09Ss2X+ovCDDggJExd/2Iow2zeAJ1HTQXbV3Oc6OfenqkTvtj7B6A71ys5dGdfRw9
	Q9N4ljZeHKT9dt6uuoZXx2cbVpY2Bcg=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=KABHcOun;
	spf=pass (imf05.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 8966943C25;
	Wed, 10 Sep 2025 03:14:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4421BC4CEF0;
	Wed, 10 Sep 2025 03:14:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1757474063;
	bh=TcwTT74aQaPaV63W1C7OeqMDunCWPhOwjwEsGuRKoKA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KABHcOun1fxqcw3tG8NUUO83OuhFEK5DBYCADvm5MMT6Cru3LTtfsldFv3IADKp/D
	 IGCWOTNHR1i5NviYpacgIfrN+sMIi5omdZKeabU26YVruspNDCjr79DWCt+kGgpN19
	 0ePH7yrG4+HRhdaGTNFLd8ZB26zTx2WGJ6WJ44x7JvesO1TodiZQUzW7+Zu2KXHOEN
	 j7a7jz+9d/4NqJFPC0gSbE8PbtTq8FTbL8s+1ui6RPl5psyfOD3QpUiUbi6MNf7tG3
	 XlrrJfeFu/0wEE+wbX4tlEsvIcSf8298CD388zkXg72fu1IpUEtYl453JyBPJYyQdF
	 BY1fOqk3RTtFQ==
From: SeongJae Park <sj@kernel.org>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Yosry Ahmed <yosryahmed@google.com>,
	Nhat Pham <nphamcs@gmail.com>,
	Chengming Zhou <zhouchengming@bytedance.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] mm: remove unused zpool layer
Date: Tue,  9 Sep 2025 20:14:21 -0700
Message-Id: <20250910031421.166611-1-sj@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250909151345.GE1474@cmpxchg.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: E9C37100003
X-Stat-Signature: bns8bxgqywsh3b51sg1qt6g9zrtiz3so
X-Rspam-User: 
X-HE-Tag: 1757474064-513938
X-HE-Meta: U2FsdGVkX1/2UFf59g+AjSJbC5izEvwhWXjA2WW4vf4HWxQoUSugr5craLGvz0MU1bysPlAedbeyg8TXifuA7OlBqgUlq+gEt2iqE8JwGTyhfxyBfhRQIgxB89ItWLsxXOZnWMwdn2P9WzZb1p/mwB0DeYY6tWs8G8UnmvEaw0SKYhl6hBsSinggkpU1x9LSehq6eYwEaxOQgfPFMYMT5a91BvHQc5qa2xnW1va4nSDIe06ngKvtHIcAIYTY0Ce2gGsYG4CyBQNKrTtM4wqLjPNnnbpgpDcxU/7IgBKHtBnn3MpAwDfC8QHWWqyQEbT7mYl5rSqS6117Z1ExjRLVwkVPPyZXWhZ7w7qJ9LqON5DErDQCHczZFIMpVCoWSVzJH/eVBxhlDvu+Wx1BwNeUcaG0CK78rFihxLttGIW7rSPaORPxNQVGuI9vazagTeoPWrPfGErLJnz6MjLvAyxc2tlCUjmrGduXXDyxhDvTah6vEOuj0y4ZUHWibCJO3CNd0P8eTuezCznWZi2S6EXHVGVAKrnZ2ZaRPDmOP85vZD1ag9LgTXJLe7KQYmAxZDoid3HFeuwQRtFkpPXD4tGMJCoHJAKTrGI2E1dAEZONIEVYaAhYW2PgTvht1fkvmSacUMd9kmTrHoMDBWhmD4hppb71j77VETtt1a8q7w7waiYAfCPtxTK4UzOi+RF6aAbD2qcgtyPgNz4S2niMUkyIn/YrIcp0GqvyIxt9D8IyTb+LlrB/8BsDPzWnzC1tOxs53QKAp76MeyhwmCt9gUm4huf/1qtzcxgNJ9sXWlcXvqd3pZ0Kr0EuNQDhyTpp5daj6EhJh/7ZlL3/jxgT/FAC8h2jIFYZih6WgKjp7PPJLXWOegA4h8vxWRz8QhUY8qSRRhFh8n6gc5ngCtJaeK4456oB0o+vxGsZ5FPWcA67q4vms+LkqwZtLgu20idflarREf0EZMKrh/QpPkVxfEQ
 H12oiCq8
 H/nJU7uAPrS76n9mkBjyElHtS9e5o7MaGVwuwVa/s6d6xLJXbBL8+V1n7NPu6iiZVvgsw63Ue1MNlbPMgB3Uc1M59ttPy6ePuHFRN8aMkYoJtofllEYERzACO5BnyIp11J9gmh6T7TAlnVREOjQX9Ebgce6XogoqfYKDoGitJP/m7x3PdvAG/RRLdI9dGe2L2lv4m36bCKG1AeHqkfUXjayHp3I5yuCvS372ciUzfTcILBiHBQBDvRXLdAf0pxy/buWn5YxJS1BZXRSMm1e00M8jgZychICCkQTSI
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 9 Sep 2025 16:13:45 +0100 Johannes Weiner <hannes@cmpxchg.org> wrote:

> On Fri, Aug 29, 2025 at 12:07:28PM -0700, SeongJae Park wrote:
> > On Fri, 29 Aug 2025 17:15:27 +0100 Johannes Weiner <hannes@cmpxchg.org> wrote:
> > 
> > > With zswap using zsmalloc directly, there are no more in-tree users of
> > > this code. Remove it.
> > > 
> > > Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
> > [...]
> > > --- a/Documentation/admin-guide/mm/zswap.rst
> > > +++ b/Documentation/admin-guide/mm/zswap.rst
> > [...]
> > >  When a swap page is passed from swapout to zswap, zswap maintains a mapping
> > > -of the swap entry, a combination of the swap type and swap offset, to the zpool
> > > -handle that references that compressed swap page.  This mapping is achieved
> > > -with a red-black tree per swap type.  The swap offset is the search key for the
> > > -tree nodes.
> > 
> > Nit.  s/red-black tree/xarray/ ?
> 
> Yeah, I just kept the changes scoped to the removal of zpool.

Makes sense to me :)

> 
> But this file indeed needs a general update beyond the changes in this
> series. I'll send a separate patch to clean this up.

Looking forward to!

> 
> > Acked-by: SeongJae Park <sj@kernel.org>
> 
> Thanks SJ

:)


Thanks,
SJ


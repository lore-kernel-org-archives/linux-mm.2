Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 363F8D0EE0F
	for <linux-mm@archiver.kernel.org>; Tue, 25 Nov 2025 18:50:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7D5866B00AC; Tue, 25 Nov 2025 13:50:19 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7AD4F6B00AE; Tue, 25 Nov 2025 13:50:19 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6E9F46B00B0; Tue, 25 Nov 2025 13:50:19 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 5DD4D6B00AC
	for <linux-mm@kvack.org>; Tue, 25 Nov 2025 13:50:19 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 0F430C03A8
	for <linux-mm@kvack.org>; Tue, 25 Nov 2025 18:50:19 +0000 (UTC)
X-FDA: 84150019758.16.B03E841
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf18.hostedemail.com (Postfix) with ESMTP id E44931C0004
	for <linux-mm@kvack.org>; Tue, 25 Nov 2025 18:50:16 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=iuUVPQSl;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of chrisl@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chrisl@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764096617;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ukWrwSjZlLYKUcD6IWWFHdiqUV37XSS8qX/fgD+pQ7g=;
	b=yS2NKF2FczUlHaTsfD+x5lWAsnkLxTllN2rEGCSnoJ9/uGp4lhKP1EU9YYy3ylYsStuhsF
	LAIsMTAqkUEPyfY2PC37GmTECTeYCz6tRGc6aXFNKR1GiauK+nU87jgCtiIddB6k7qbIhW
	OnVsV/eAsbx5kk0HvOBgKfIhm2SmQRs=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=iuUVPQSl;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of chrisl@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chrisl@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764096617; a=rsa-sha256;
	cv=none;
	b=coieWR6XZ7/ZiY/o92DS76G5fUfD5vCB+R1/SK3XfVxxHATaza08fyJZ+e3wuevu0fkoXM
	ZXM2qqqDyjZti3Zi4dSR3LTvLG1fijsyQ4SDM5lLUKmOG/9oRG9v5I4sDnPAIS+LY+M4/Y
	E8jzNxeE0jifWeY7PgOdHBOMEeU8D0g=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id D79DD440FD
	for <linux-mm@kvack.org>; Tue, 25 Nov 2025 18:50:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3BF4C2BCB2
	for <linux-mm@kvack.org>; Tue, 25 Nov 2025 18:50:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764096615;
	bh=1Zi9MirAGKy/v0udiFU8DlL4UOivyp7lI6WloM6i6Fk=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=iuUVPQSleuIi/pE4DBFG+Wb86dYtkoYxb9jCy86S0RLEi9QJglfWQ/xDnJaiA8oWu
	 2AS7hATkaFSRO3VmXcnI1inMMrqc3KitSzD93EGRxTpz4x6k53rLbVG6/fBBuzmmqo
	 crDaOTqk1pqb5vQW7Kkrp4KUmXQeM0nBY1hYcI3REYsBTmYgibviRh3EQbYyfTQOeG
	 FWqdIA1xvP5r54PEEJwTBp1d3sqHcAbHz0h/AvIuY3W4Qyb22cnc4NWoHQ0QFFIbqJ
	 Vn1qvpXJKRhdRcOrwTbHSdbbvCDGRuKj5RsgkA1YC8SSBdQ1C4er1ejx9l4LsFkxZV
	 o/iGW+88ayTbw==
Received: by mail-yx1-f51.google.com with SMTP id 956f58d0204a3-63fc8c337f2so5666500d50.0
        for <linux-mm@kvack.org>; Tue, 25 Nov 2025 10:50:15 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCUOGilsS1vLyL/6fcS5H02JKyi1oFh2gB9cXhwB6zQA9SnJChxd6zpNfKTNdjPlhVYOEbbaNN2cag==@kvack.org
X-Gm-Message-State: AOJu0YwujLtFqhqhCCYLcjJ6m0F99FId46IXirAK2a97RYCh3dQxBpTq
	tgwRPfBa5n0jS0pk0IZZyAd57hTD940zBAfN5arcU954En9G2oVah6/7PZFDHw0qzXNO70cjJdA
	YRFxOjp9IjulaBtaA5LLuAHCcaxT3vP2LTkJFKHZDeQ==
X-Google-Smtp-Source: AGHT+IGIC0i/LXrXNUNTGS3yjIrrUWS/5FWIVCYENL3WO7849119knRaExmgxG5rQ0VG+NAV74Zx3wYL17RXeEg5yCo=
X-Received: by 2002:a05:690c:4d48:b0:788:e1b:5ee6 with SMTP id
 00721157ae682-78ab6fce818mr62995737b3.70.1764096614792; Tue, 25 Nov 2025
 10:50:14 -0800 (PST)
MIME-Version: 1.0
References: <20251121-ghost-v1-1-cfc0efcf3855@kernel.org> <20251121114011.GA71307@cmpxchg.org>
 <CACePvbXXDaOY-E-nZ3n44w0StBc=n59+v5V-X2fw-V+roH=Qyw@mail.gmail.com>
 <20251124172717.GA476776@cmpxchg.org> <2a8fd7bd35939b9aa4a7267c93e1fda995137966@linux.dev>
In-Reply-To: <2a8fd7bd35939b9aa4a7267c93e1fda995137966@linux.dev>
From: Chris Li <chrisl@kernel.org>
Date: Tue, 25 Nov 2025 22:50:02 +0400
X-Gmail-Original-Message-ID: <CACePvbUB8wjEH1rsaRs+LwX4RKGrjLFSGzjhgrdS3e7Lcz6BeQ@mail.gmail.com>
X-Gm-Features: AWmQ_bkzEnvQwZ9Zziwl4NIWRSv3az9wdvgJhSsJnMOdTc5O190_Ak5qh8ecVaQ
Message-ID: <CACePvbUB8wjEH1rsaRs+LwX4RKGrjLFSGzjhgrdS3e7Lcz6BeQ@mail.gmail.com>
Subject: Re: [PATCH RFC] mm: ghost swapfile support for zswap
To: Yosry Ahmed <yosry.ahmed@linux.dev>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Andrew Morton <akpm@linux-foundation.org>, 
	Kairui Song <kasong@tencent.com>, Kemeng Shi <shikemeng@huaweicloud.com>, 
	Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>, Barry Song <baohua@kernel.org>, 
	Chengming Zhou <chengming.zhou@linux.dev>, linux-mm@kvack.org, 
	Rik van Riel <riel@surriel.com>, linux-kernel@vger.kernel.org, pratmal@google.com, 
	sweettea@google.com, gthelen@google.com, weixugc@google.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Queue-Id: E44931C0004
X-Rspamd-Server: rspam11
X-Stat-Signature: ydxr4iwzf31fnjizmegxw7qfaznbu4n1
X-HE-Tag: 1764096616-505861
X-HE-Meta: U2FsdGVkX18xlS0Xq8nCfJaugTt5rctmfgE8WuRGExDz7k92lxiDvi5AeTUk7Gwj3rCw52vK7Yt53gplqsaRpjCm99XuuhGKv8lyJxaoDpwsdASG4m8QLupebjvIsdj1v889sKBAgDc7Sql4r1BdRHWKTWx0hHjBZyWdH1zkwz/YWWDRA5WJgkoXMcgSvB4Xk/5XRiGsmeD7p3ls88Ru/j6gXROeZZlgpG95iRTwkUE4ORgwrbTMUr3ZmKb47RT9bcT++Or72ESew6SfF6oB2xpgZICmmcLws4j8J6RKwVZ0DOSTs3ZNOvSPdXaqWW+T29QepQcqV65p1aAWl3IVD0Wc4jqTLc2KMarVD0p6TIBp29fDuMUc779F5ph+v4qiV8J/7Z+g0m3lW+gQv4XdwVkB9DyjT3ENfe3YwnaGv15amh/7d05gNFXGHPaIjAGzrQxVSeHfvOXR8Yg3RYmzctFspBVx4oY8VZ6EP24uQTm5OXPvGUhr99kQkmHdmHof14MQm7hYY7fdj0AwVQEd0WaNcrDUsgxp8V+Yv5jiapEqrP2ehF7VF3uEDvOz6zm30HbNE2jyjgRIzBdguPCN6uP2WnUNLtf6jzh3asuLFbDIlTROfMlghnp29ADVCIybfqFAPaDm+5nFxYc6fM5cgQgGbNH75BnIi1S6+ZoETGpDzVljJIqMlMP3wfEyOhhNdg4IJEv/Zd2/QDmFcQLfavWAEhMj8g7suOxdh23kRvCxriA7lqkw41yWMBwpMx1nyODcZ/bdbwHjofFxDPVRYcotO0dGhIO4IaRdaJz+XXQ3iHzSdquV9x9UmHesm4bHLPqfaZW0n0hWibiMYEefoPj4Xnn74coCFEn/dpyfDdaw8hnNdGFnRZ5ZEieX1AJnSKPzFruwfdj4tHbhEk05DAsNJqi5GC2+EeC3FaBgQOH8MpzjvhT7MfO8kkYpIj+YEVuEOM2hCKzS0M/tt43
 5pMcfo4x
 aUeegPV1MIYbXjqyorBuQGZEoBzzYb58Y9gr4GvA12FXdmZZ9NQPRPsyqH4WmzQeWUUEIwvDjE+gar0rZ4T2eYwzx6rnApW16ABcFQOGSFyEssJEy6swp11mxBY1r66WTA6/8j86fCQ3a0ku32bgXx3dBQFWYol3SgmbaGCVeWNhz8yLhqtrqnMXOl5PgH+YcENdJ/2a3MZ1K5lng+1Po6xR+v1xMwFRJaIguG7Sfu8p593Agyjp4TPQfxdvSdbySiTyzCCjcP8TEyCTu03zyqZr3oBK02HssxFla
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Nov 24, 2025 at 11:32=E2=80=AFPM Yosry Ahmed <yosry.ahmed@linux.dev=
> wrote:
>
> I think what Chris's idea is (and Chris correct me if I am wrong), is
> that we use ghost swapfiles (that are not backed by disk space) for
> zswap. So zswap has its own swapfiles, separate from disk swapfiles.

Ack.

> memory.tiers establishes the ordering between swapfiles, so you put
> "ghost" -> "real" to get today's zswap writeback behavior. When you
> writeback, you keep page tables pointing at the swap entry in the ghost
> swapfile. What you do is:
> - Allocate a new swap entry in the "real" swapfile.
> - Update the swap table of the "ghost" swapfile to point at the swap
>   entry in the "real" swapfile, reusing the pointer used for the
>   swapcache.

Ack, with minor adjustment in mapping the swap entry to the physical
location. The swap entry has swap cache, the physical location does
not.

> Then, on swapin, you read the swap table of the "ghost" swapfile, find
> the redirection, and read to the swap table of the "real" swapfile, then
> read the page from disk into the swap cache. The redirection in the
> "ghost" swapfile will keep existing, wasting that slot, until all
> references to it are dropped.

Ack. That is assuming we don't have a rmap a like for the swap entry.

> I think this might work for this specific use case, with less overhead
> than the xarray. BUT there are a few scenarios that are not covered
> AFAICT:
>
> - You still need to statically size the ghost swapfiles and their
>   overheads.

No true, both ghost swapfile and physical swapfile can expand
additional clusters beyond the original physical size, for allocating
the continued high order entry or redirection. For a ghost swapfile,
there is no physical layer, only the front end. So the size can grow
dynamically. Just allocate more clusters. The current swapfile header
file size is just an initial size. My current patch does not implement
that. It will need some later swap table phase to make it happen. But
that is not an architecture limit, it has been considered as part of
normal business.

> - Wasting a slot in the ghost swapfile for the redirection. This
>   complicates static provisioning a bit, because you have to account for
>   entries that will be in zswap as well as writtenback. Furthermore,
>   IIUC swap.tiers is intended to be generic and cover other use cases
>   beyond zswap like SSD -> HDD. For that, I think wasting a slot in the
>   SSD when we writeback to the HDD is a much bigger problem.

Yes and No. Yes it only wastes a front end swap entry (with swap
cache). The physical location is  a seperate layer. No, the physical
SSD space is not wasted because you can allocate additional front end
swap entry by growing the swap entry front end. Then have the
additional front end swap entry point to the physical location you
just directed away from. There is a lot more consideration of the
front end vs the physical layer. The physical layer does not care
about location order size 2^N alignment. The physical layer cares a
bit about continuity and  the number of IOV that it needs to issue.
The swap entry front end and the physical layer have slightly
different constraints.

> - We still cannot do swapoff efficiently as we need to walk the page
>   tables (and some swap tables) to find and swapin all entries in a
>   swapfile. Not as important as other things, but worth mentioning.

That need rmap for swap entries. It It is an independent issue.

Chris


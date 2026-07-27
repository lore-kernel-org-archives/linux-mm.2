Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 516E1C531D0
	for <linux-mm@archiver.kernel.org>; Mon, 27 Jul 2026 10:08:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E093D6B00A6; Mon, 27 Jul 2026 06:08:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DB8DA6B00A9; Mon, 27 Jul 2026 06:08:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CF9F86B00AA; Mon, 27 Jul 2026 06:08:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id AB50B6B00A6
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 06:08:29 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 44914406B5
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 10:08:29 +0000 (UTC)
X-FDA: 85034131938.17.816F223
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf27.hostedemail.com (Postfix) with ESMTP id 7813640006
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 10:08:27 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Cn4G1dYW;
	spf=pass (imf27.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785146907;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=I03Tf7oe1oyPKkCeh2/uxA3siPkO86atNMUY0KznFQI=;
	b=dzy+GfcA03A9QfZmDyAIRiQ6vjprlY3slZdlSJ56JRj5XwKD0PnDrAm6qUyJ4oPboDLXtv
	1Ix9Hhh6wFEIsDd3E19EImkvF8iscBh4jryruig8pT0A/wMr+pwftukqzJ361ggAGqR34W
	ZoOhWpOIkylHb3FvTzM/nUKhe8rHdps=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785146907;
	b=EETKa3PeLjuF/lGMhTLqKdTlOIn/Y3Drs772XPsemwR+JX20APQQwwvO9HEGa4YX7mpga4
	5JLNcDr6vlMGNALMx4P2GfljD5PdaHC+C45XpwFkdOz5En7sCvjNg0tLU6KbRVYBCNv4yh
	9tNm3Gqq65/+lLpbD7prCYUl3zZ4GSw=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Cn4G1dYW;
	spf=pass (imf27.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 59AA642DD9;
	Mon, 27 Jul 2026 10:08:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA7771F000E9;
	Mon, 27 Jul 2026 10:08:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785146906;
	bh=I03Tf7oe1oyPKkCeh2/uxA3siPkO86atNMUY0KznFQI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Cn4G1dYW14+InpRXOVRcBBEQ07NLqLs6jK/EZ35lNz8Esh0P26puvKGNauqqfEeh7
	 9osfo7sqwksjbyu4yX1mwS/iEbCZkW61Yfj+un3HoLHZemTan+2w77PFgAbeebUiiy
	 I5BYfz3xEnC9ZSbjnpdMAN4ogt1BFORpYP8aJvfMSz/J5AHvUjYG/pZ/KLNsoFbx7y
	 kq8ZUrlqSbfPCC5/NBrXNv0uBsFaTLR0D6yw/5i58V91kGNLmboB1/Aj8eJ085Ax8L
	 jsU/MRpgj8oTWBsEvYTUfIynnzcYvidOgP83QTQpp1mwbsALCPZWrGozEblgb/obUH
	 VCelFTLPuBqRA==
Date: Mon, 27 Jul 2026 13:08:18 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Muchun Song <muchun.song@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Pratyush Yadav <pratyush@kernel.org>,
	David Hildenbrand <david@kernel.org>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Alexander Graf <graf@amazon.com>,
	Oscar Salvador <osalvador@suse.de>, Jason Miu <jasonmiu@google.com>,
	Jork Loeser <jloeser@linux.microsoft.com>,
	kexec@lists.infradead.org, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Muchun Song <songmuchun@bytedance.com>
Subject: Re: [PATCH v4 16/21] mm/mm_init: simplify deferred_free_pages()
 migratetype init
Message-ID: <amcuEiLzIunJwZVx@kernel.org>
References: <20260725172133.4018491-1-pratyush@kernel.org>
 <20260725172133.4018491-17-pratyush@kernel.org>
 <amXelr2DcRRyZDY4@kernel.org>
 <20260726202522.e55861cc87fc3e0c6d030e1f@linux-foundation.org>
 <92E24479-07A8-4998-9607-87420A8BE04E@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <92E24479-07A8-4998-9607-87420A8BE04E@linux.dev>
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 7813640006
X-Stat-Signature: 9ajo78d7odqqc1opyrkjyqwzj9dh6qz5
X-Rspam-User: 
X-HE-Tag: 1785146907-242148
X-HE-Meta: U2FsdGVkX19h599M2lmzT7GMbG7ZnEC+bwj/5kWU6QuH+jxAKq+56ZC16qbAY9SzsIxZuMaYZcti/l24/kkY0wWGeeQaXeQnamGeTi3ILWSPE1Mkw8fmCItCRJKAyA1F7I97nTaTpEdNoguL0KXmXV1dbPwj2CEpIb2CgApoB2jZge5GccbIk71Mpzalx9FQ9sfh0K2rCAZZO9m+UQ3iRKJBUjsrkhEmm0hwFtFtrxIFrls6jhI0RLf8Ya3Ao3mDoX3kAnnkq6ZzMi9oQAVigE7VpUUDN7uRpYR7BtSR5XYVs9vFDVpgD4rsqejAUIfqyioFfkap/aIfcAtEAlREw+5ztxgCgkOKuX73dwfeK2ZhIvj7CsxxCjhPjxPuvAbi9XhIBNbrVI2sJK4jE6/JrByUYiISV3iVnqxPXNjGDpAWKvKs29ctbSp7slzu9QI5YjnnBIrPI3hWxneHq2+kmh1BPEJTfjmh0YDeQv9aMSaiYzMc1nvx3TSHbhca/S27OCTK65Oiekq36KnPqKJgEsLJ3g/rPXS2/Go4VHQpzh0191PGYglClpfXadA1Ca1kQCwERCXgcBgPEbVI01sjW2sBv5fbYFBoM9+2DQepo3dbUsO8IVfHbMEAKApROQkVDGHY8/y7Z8DOz9LzvI0jHwzTd+QjEwptXmqT2ASc2SHdyVNtJFBhuQ1ccZq5odk4HSAeFAxfsAnjC7xNvgdK7aoHBN4h1Mg+a0aIe2ZahoOlubb+/Cjx76EwHoJhRSMJje0yZF7BAqO2LoNvzlQoZaQd6iuSRroD/3SZ2FQ5WUS3EXArAJ36qYtc2uX+/nixKpd5pp/4q+0U4LxM53iWIqMj7XwbZDkr3hiZHYL9AKeOjCT4Qew2JkKAff82I9M6DK+C60SEfz54dFPvdfyYt3/r74bVuAXOuUGIZj4BfKdyR172W0Vpnolyz3Vbs0cUmylDfWv0P/lGYDuaVJ3
 /n1CYspX
 RVL+DWARxDK3RlM6moCVpksl19/z/d9m3Sckh87qgrTcGeN5ExJl2GDuolFEaatUsFPDN9yUjdMCfv8igjHJ2tQZLqSBzcVtw+iixhNxG3KQZM28L7et7VWCYi+s23vyUzG3uiaedJXuHH65YElXoUaJ3y1lc2YC+tDhxW95U5AQyEEiB1+KVSKuhmQR370k/7A6LPvfowHv/avO2vkyWZkGdQKT9PBpzmuHyXP94fAipROOKxcUSfpOitga3LVekROi4CVpNVGHWJ2xSUlSERIdPwj95RN3FuSP4BegL+hir6yF6A6cnqdlxicmFcxUH3Ia26aeQV50zGevH3YgJFFc2En4uOdvyfOZkYJRq+JMiGVuyuuRLRX6pBMVQe/GHoAIk8QVw24MuO21jXj9L6qt/qkOWznk7WLKs
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jul 27, 2026 at 11:43:31AM +0800, Muchun Song wrote:
> 
> 
> > On Jul 27, 2026, at 11:25, Andrew Morton <akpm@linux-foundation.org> wrote:
> > 
> > On Sun, 26 Jul 2026 13:16:54 +0300 Mike Rapoport <rppt@kernel.org> wrote:
> > 
> >> On Sat, Jul 25, 2026 at 07:21:16PM +0200, Pratyush Yadav wrote:
> >>> From: Muchun Song <songmuchun@bytedance.com>
> >>> 
> >>> deferred_free_pages() open-codes two loops to initialize the pageblock
> >>> migratetype for a range of pages.
> >>> 
> >>> Replace them with pageblock_migratetype_init_range() to remove the
> >>> duplication and make the code clearer (Note that deferred_free_pages() may
> >>> be called from atomic context).
> >>> 
> >>> Link: https://lore.kernel.org/20260612035903.2468601-6-songmuchun@bytedance.com
> >>> Signed-off-by: Muchun Song <songmuchun@bytedance.com>
> >>> Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> >>> Acked-by: Oscar Salvador <osalvador@suse.de>
> >>> Signed-off-by: Pratyush Yadav (Google) <pratyush@kernel.org>
> >>> ---
> >>> 
> >>> Notes:
> >>>    This patch is taken from Muchun's series [0]. The patch as of today is
> >>>    in mm-unstable.
> >> 
> >> @Andrew,
> >> 
> >> It looks like it'll take some time for this patch to get into mm-stable so
> >> we can't base this work on a branch in the mm tree :(
> > 
> > I didn't know anyone was using mm-stable :(

Maybe nobody uses it because it's not really stable? ;-)
 
> > Series is adequately reviewed and is near head-of-queue so I can move
> > it into mm-stable a few days hence if that helps?
> > 
> >> I'd like to expose the KHO scratch extension to linux-next ASAP so I'm
> >> inclined to take this patch as a part of this series and live for a while
> >> with a duplicated commit in linux-next. Once this patch would be in
> >> mm-stable we can rebase kho-scratch work on top of mm-stable and hopefully
> >> there will be enough time for it to live in linux-next so that Linus won't
> >> get angry at us :) 
> >> 
> >> How does that sound to you?
> > 
> > That's fine - let me know what you choose to do and I'll adapt to it.
> > 
> > An unknown (to me) is whether Muchun's series "mm: Refactor bootmem
> > gigantic hugepage allocation, v4" still works with this patch removed.  Everything
> > applies OK for what that's worth.
> 
> Hi Andrew,
> 
> I'd like to confirm that this is a completely independent cleanup patch,
> so it can be merged on its own.

That's great, thanks for confirming!

Then I think the easiest would be to take "mm/mm_init: simplify
deferred_free_pages() migratetype init" via liveupdate tree.
 
-- 
Sincerely yours,
Mike.


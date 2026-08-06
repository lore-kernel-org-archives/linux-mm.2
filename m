Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6B0E0C5AC7A
	for <linux-mm@archiver.kernel.org>; Thu,  6 Aug 2026 23:36:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E060C6B007B; Thu,  6 Aug 2026 19:36:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DB5FF6B0088; Thu,  6 Aug 2026 19:36:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CA5596B0095; Thu,  6 Aug 2026 19:36:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 92F986B007B
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 19:36:48 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id E6C3FC069E
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 23:36:47 +0000 (UTC)
X-FDA: 85072456854.09.C319DDE
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf21.hostedemail.com (Postfix) with ESMTP id 32F9F1C0002
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 23:36:46 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=mVvpszWi;
	spf=pass (imf21.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786059406;
	b=Iro2s80ygsY3n5SJpd7OL82Jl8WT9wBCRvpTCoKBRD4EtC1RSY1wv7eWNUO5v4NaKlWcb/
	1+n4zBAJkDS+PrhJZslan+at/xhebRblsaOtOIY5XC08b21niDpkzvvYmy3d6CuO6znjhZ
	fn3OForl/Dm0eDjZFS8aCSRQBIHFyZY=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=mVvpszWi;
	spf=pass (imf21.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786059406;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Xlao5rltnHCuX1s/4rsdC//1xkwI2J9Cedg4lygq0PU=;
	b=OFMFqkBS/CtI2ma6Mp1tDRRcvUexFrx24mqftosiabJWQ64ekBrp6b8xLXkuZJUxV9Jyog
	3JXUyzNlRS3RoatFFfmBiG6fv9EvxOMBvqpeP+K3j2mzpC++FbJzrXv80A54s03GGH1tAJ
	zPQA5ebVZkiSJPZdhlrnr9fZ8VrkWiI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id D7C1743FFE;
	Thu,  6 Aug 2026 23:36:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9BA8B1F01804;
	Thu,  6 Aug 2026 23:36:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1786059404;
	bh=Xlao5rltnHCuX1s/4rsdC//1xkwI2J9Cedg4lygq0PU=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=mVvpszWigeAi3bm0gcCUV4dYWqqNbFHd8AH0g2PLIc72WYfOgfRWHftKmLt3TCETl
	 0KP7OuKSyk6vjAkI5SkaCSRJzlNPgkrOM0/ERoDMazZhsgcSV98zsEcKo23+1YxA0m
	 HGm+mOT/kO/wBFjzT4yrEbOSaNRgZgtjbKeKwCn8=
Date: Thu, 6 Aug 2026 16:36:44 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: kernel test robot <lkp@intel.com>
Cc: Muchun Song <songmuchun@bytedance.com>, oe-kbuild-all@lists.linux.dev,
 Linux Memory Management List <linux-mm@kvack.org>
Subject: Re: [linux-next:master 8777/13479] mm/hugetlb.c:3095:39: warning:
 array subscript 4294967295 is above array bounds of 'struct list_head[1]'
Message-Id: <20260806163644.20229f5ab7cbf176edbf2613@linux-foundation.org>
In-Reply-To: <202608070433.x3vNSfjt-lkp@intel.com>
References: <202608070433.x3vNSfjt-lkp@intel.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 32F9F1C0002
X-Stat-Signature: qk1wyiz3iybynes4gscquy1qw89dk6tk
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1786059406-937314
X-HE-Meta: U2FsdGVkX1/3RLVyRTst8xn6SbZueEBdkbYyYz/B4neN5jsL+7lM+kXdxBogfOx5dFhvOgTG4lSH6CXXctR4gcaz/wW+tR2etAOJrX96VKaLuJbL/jPWpNmU6odcoBRKnnoNHg3UwBM4NsAoXGW87gGIul3yoYh6jTN2GGh2UUPIjdDDGlSE0Tl1DGr7HsGHoEnHBBEOpIjoDVmhHlE6XkVL9ItoEUvDDnBu5Vxko8wsN98TAyUSEFY6v/SDLP1clDfHNK1skAOvKAJtrrkgyCdWKyIK8XRBTra2KDz1zOTk1QaCcRisku/NKPkhsAAX5+EpefZyxlACq7MyVvwobFhsQnCFL+2oA1U02nUZTddwQxkakC25YbBxBWiJFpD/p23nS3vV0/NQFKxlvkLaipP9kRudsGGCtBt+fuify5MNJubmTlcqmat9ANRVAOBmdU8iLsgHA1/NeB+xqy4siNajoKw4yujN6cBeHJFHVPN4jgo+4M5eofidUmx9+678WDHe31q2kX6ZewFirbi+dTFW9q/7vsviRt+MznxlIgP+z6UqAZltts3LAv5rG0XCPOwmyXjuiiCy3RGSP/ZiLNEIQB9tvlkI7RmU4iD4hPJEF7r4ywQanX2eJEvY33AGD+TCWUdIL4CDLTApJ0mPt/gouth/Amf4FAlW2Ff57fCF9/PPodaQlBGQjgqN9BdtKu2fY+LqgAszwsAmEQ4My2t3hbepjo31mDD4YEWMG2ytYg0jZogmiUXyZLZIHFnd7p5P9G+8sGl+dlVaq69QC9whRjHAuljqr6J994t4n6NC0PmEEL/uZhgS5YYiCHo/vDrhHCr+VxhKLKGdHUnR/8Mq4nZWO3BbrEoP6QRzMQc7Q4dpfVCa+W5IpzMObxEOU3IT7v9Y4srkomOCx9fmI70fv4VyfSMXX7st/s84iv5LXoEnIbuTSowgsO/x2rgio3eMUiZIYoentbis6P2
 CRB5lJAb
 qaZ96+Bjw0GZUFrp3ey421wUgbm5KdXkZoYbz5NrXW7Qmx3QkteY44xMk/O4vBkTRSlGdZKwc5O55BLyXGxaXrS2GnUDunb3LdFikFkowyYVloXtDubWaq6M94ftU5ngcTZQM1O2/ElM+57Lm/GS3uJ0ACAXGeQLa01OGB54dETcyazx6UMgQCO+oV0M+/OI0zPQk3EUkubXhsMFtc3e9XdkbvQXUx1NvEBsMCYwXMrubPIFh/NL4TNjEs/kSjiXRthYkEDmoPVpHq82FK/KF56KOlgpX6nSoI1PoqtnXgwtSjvOLa7Moqb58SQlPQjv0a77HrVNYCisW6AQIDGWTQGRE7a0g5TGozM5GDOOIRqxXj4g8TX9k7PHSZiqUaOcHr0PUGnpQb+APybtDez8FfMRU5A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 07 Aug 2026 05:01:04 +0800 kernel test robot <lkp@intel.com> wrote:

> tree:   https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git master
> head:   ea2bff00da89d7767d677bb68470130ba96f4928
> commit: 20549ccf4da49ff6dcb35ffc741f92aa92e07aeb [8777/13479] mm/hugetlb: free cross-zone bootmem gigantic pages after allocation
> config: parisc-randconfig-002-20260807 (https://download.01.org/0day-ci/archive/20260807/202608070433.x3vNSfjt-lkp@intel.com/config)
> compiler: hppa-linux-gcc (GCC) 8.5.0

Such an old compiler.

> reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260807/202608070433.x3vNSfjt-lkp@intel.com/reproduce)
> 
> If you fix the issue in a separate patch/commit (i.e. not just a new version of
> the same patch/commit), kindly add following tags
> | Reported-by: kernel test robot <lkp@intel.com>
> | Closes: https://lore.kernel.org/oe-kbuild-all/202608070433.x3vNSfjt-lkp@intel.com/
> 
> All warnings (new ones prefixed by >>):
> 
>    mm/hugetlb.c: In function 'alloc_bootmem_huge_page':
> >> mm/hugetlb.c:3095:39: warning: array subscript 4294967295 is above array bounds of 'struct list_head[1]' [-Warray-bounds]
>        list_add(&m->list, &huge_boot_pages[nid_request]);
>                            ~~~~~~~~~~~~~~~^~~~~~~~~~~~~
>    In file included from mm/hugetlb.c:6:
> >> include/linux/list.h:163:12: warning: array subscript -1 is below array bounds of 'struct list_head[1]' [-Warray-bounds]
>      new->prev = prev;
>      ~~~~~~~~~~^~~~~~

Well crap, that patch has been in there since June 12.

I can't reproduce it with the provided config and hppa-linux gcc-16.1.0.

Muchun, I'd be inclined to pretend we never saw this.  But if you want
to address it, please do a patch against mm-stable with

Fixes: 20549ccf4da4 ("mm/hugetlb: free cross-zone bootmem gigantic pages after allocation")



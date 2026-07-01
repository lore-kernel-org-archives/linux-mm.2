Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 37CEFC43458
	for <linux-mm@archiver.kernel.org>; Wed,  1 Jul 2026 18:13:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1627A6B00A8; Wed,  1 Jul 2026 14:13:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1395F6B00A9; Wed,  1 Jul 2026 14:13:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 052946B00AB; Wed,  1 Jul 2026 14:13:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D40176B00A8
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 14:13:37 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 655FA168359
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 18:13:37 +0000 (UTC)
X-FDA: 84941005674.08.BE2F2B5
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf05.hostedemail.com (Postfix) with ESMTP id 9F63A10000B
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 18:13:35 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=zLLKqDIY;
	spf=pass (imf05.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782929615;
	b=OgKZamOI2LKib3KBpdj7MCIqDN3ls4Qj7+xY/3SIaxPRi2Y12oAJAafiC4BPgZT+jM08cX
	m1xlhylb5UHHsMQZWIk5lgTO+QPbpVNYjrRf5Yu2s4jvl6idVyzQIvafZeNDpxcyRUKV/T
	yUCOVofyUbjD5uyj/mIDyfb/clVha9g=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782929615;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6dBPtCiZj++yQEUojIUaLLBbVlYTIXmcVSA7FgHeDUU=;
	b=khTwnRfM16QeIAk4di/b4SA1bYbn9E25MILCGqVLkXD1dpVd+A8/dXeHpVR8ZnO4lu3Fnk
	sM8ZPub9rN8vPWeLz5znOVOhWJkJlqxhiyeCg9cWhw/wMFjzEs9fA6UXh6SkS4bWPMMlhg
	kR0OdBXyQ+YpPv+PNp8E/yESGPHN+Jk=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=zLLKqDIY;
	spf=pass (imf05.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 2DA9860122;
	Wed,  1 Jul 2026 18:13:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BDE741F000E9;
	Wed,  1 Jul 2026 18:13:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1782929614;
	bh=6dBPtCiZj++yQEUojIUaLLBbVlYTIXmcVSA7FgHeDUU=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=zLLKqDIYXDyxhXphbCPWUqPhrV5BydL5HTFgSOGyh7g8SLlRFYJL5mf+3yTtyfhPG
	 DyGWkLQZs23gukUMBv3spfBiis3KFHMGySk/dpcPL666nCVS/fTWRKoMKvDJS93Fn3
	 9WMsiWgVI1qJfpP4YaJIVR+PKnzrvIF2qtryPaSs=
Date: Wed, 1 Jul 2026 11:13:34 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Muchun Song <songmuchun@bytedance.com>
Cc: kernel test robot <lkp@intel.com>, oe-kbuild-all@lists.linux.dev, Linux
 Memory Management List <linux-mm@kvack.org>
Subject: Re: [linux-next:master 1977/2307] mm/hugetlb.c:3095:4: warning:
 array subscript -1 is below array bounds of 'struct list_head[1]'
Message-Id: <20260701111334.ea3759a839d3ada05e042b19@linux-foundation.org>
In-Reply-To: <CAMZfGtUtS_dqh4wNX9sAM01VaqCUMRDTxg+NgWYsRwrjp=CBWw@mail.gmail.com>
References: <202607010945.6lDjBFTU-lkp@intel.com>
	<CAMZfGtUtS_dqh4wNX9sAM01VaqCUMRDTxg+NgWYsRwrjp=CBWw@mail.gmail.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 9F63A10000B
X-Stat-Signature: 1iff75e4ac3zzg19q8uoksb1kq6dowpu
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1782929615-104978
X-HE-Meta: U2FsdGVkX1+lUETOigPVahnWogj/leCZ9OGHzEZ1VZBahz0saP3s+v+NlADrjXFVoVKw2wblV/c5mWjPq2MDbKUIsQ4nm6su2oBZLXExveZEi+OjhzMpBsLeylRPTJVQ6JWUKtkgB0M8mYYvvnQP3uNa0uvg2WoPyksd+vBbuE/iQl8KqNov/xhnlyCWuKzsBJ8ahykdG3cUcdoGgUMNcmrGcQZdSTxTHzYnPJNhR+vcg/Gs5WlDGgKDUurUPhmZgxrQskL7FumbyE88sCXHS6UD0lFVkNubIMpV2dYdIBF4SW+qroozfUo4DDA+oqedMXCIlLd7zoE01z5pr5edmPdyr0QDAkaPnPJGM9ykkWGJKuLqiEXnflk7ZsgfZDCdIFGmCZHz3+YLsZHZudTlloiDQDqTo/zZbtdwcHHEcg6OCV/yKzVPVyuVaO+TU04awn9jwjvnmsKzsFot2XBCnN6IDf/Yh63Dxzvs91afvD5rD2+hkYi7Ixa5ED0jNjeZFGO8/6cRkY8fkJTZ/AobPBvpnYgAZPv1EW7G7cuRJIzQFSjtA4tAqvDXoaToLLxGKaqDiZXNkVvxiP/zwYdLxSejoEd+2LWSWYKg3coqbnAIBRBTwNc1vIxyaRHdgexqhd+yjB9BhmThSUcb1i0MNzJozdjC8U5Mv4IiEuvh4CTU2TET2yd+S0mX27a9XO05NnknNEnk9Jkt0j0BxkOTVBxWDv2IwAXfLnUjfIIlJ7DZFrQyZczG+27HlboxcChe0EZFkQn23r8x8ofqH46yveJT23cEHrPKJw1/aoBlEtaD7fCdj/f75+vJp/5IWEAmxqHvkRRW9bVQnABhL3xb8eonc8UCETWU1B76F0AgRlw75j0xRR+HPQbJqdvurkFQCFVjOc7wPs/edzX0ygytPWnRBrxWBkJSuhQAq+3q8zE9wkuWNgCWxKCsToSyPga/6WuzQs1pUFuNkcc+hkr
 mftECJ2y
 NVbjEejH0+4iAU3ukqzxpf0pFGfsbJD1UItwEfwAUi6UXXEMGIgGf8iC/f/PPtLbmnxYWV3AAsEzQv0jjVe2iK2Nde0TwsRX58XRhMbtuwVnuFo0yD+hglLjwb/thOMxEc4EGz65nk1H6mBT2Q7NnGRjP/b40VuVRBRS0eG7EURjzSS6qPH72FWBt0h0l00joVkyMFnlWG8G2Kp9HZioH/7vKIpUkbFaV1PMgqfiBo5/fJVPLgDr6u6AgKdo+/kZVcMVHvjdwOpzUHsia3+DhaMSrqKgyESGQ/VBISCEQ81hvmt55XEz/NOulYGnZcYHBCJEHyNsYnKyr+S20ZMSYWjDOEEvlJLNgDLw3SEwFvjkPjP0vG9EB1+kFI6lwaqAfypozN1Zg7nMIGpBEQHHF8gWk0XFlpbgPJ1EtNcL64XDAhTtg0nylN9JyJqlYEQoS90ua
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 1 Jul 2026 22:53:28 +0800 Muchun Song <songmuchun@bytedance.com> wrote:

> On Wed, Jul 1, 2026 at 9:37 AM kernel test robot <lkp@intel.com> wrote:
> >
> > tree:   https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git master
> > head:   be5c93fa674f0fc3c8f359c2143abce6bbb422e6
> > commit: f48ee682d55e3602fcc194cb93b8398f2546e53f [1977/2307] mm/hugetlb: free cross-zone bootmem gigantic pages after allocation
> > config: sparc-randconfig-r131-20260701 (https://download.01.org/0day-ci/archive/20260701/202607010945.6lDjBFTU-lkp@intel.com/config)
> > compiler: sparc64-linux-gcc (GCC) 8.5.0

Old compiler.

> > sparse: v0.6.5-rc1
> > reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260701/202607010945.6lDjBFTU-lkp@intel.com/reproduce)
> >
> > If you fix the issue in a separate patch/commit (i.e. not just a new version of
> > the same patch/commit), kindly add following tags
> > | Reported-by: kernel test robot <lkp@intel.com>
> > | Closes: https://lore.kernel.org/oe-kbuild-all/202607010945.6lDjBFTU-lkp@intel.com/
> >
> > All warnings (new ones prefixed by >>):
> >
> >    mm/hugetlb.c: In function 'alloc_bootmem_huge_page':
> > >> mm/hugetlb.c:3095:4: warning: array subscript -1 is below array bounds of 'struct list_head[1]' [-Warray-bounds]
> >        list_add(&m->list, &huge_boot_pages[nid_request]);
> >        ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> >
> 
> It seems like a false positive?

I can't reproduce this with sparc gcc-15.2.0




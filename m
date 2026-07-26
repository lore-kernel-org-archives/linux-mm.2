Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1D8B1C531D0
	for <linux-mm@archiver.kernel.org>; Sun, 26 Jul 2026 02:51:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 94FEC6B007B; Sat, 25 Jul 2026 22:51:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8FFF56B0088; Sat, 25 Jul 2026 22:51:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7C8BF6B008A; Sat, 25 Jul 2026 22:51:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 4FA956B007B
	for <linux-mm@kvack.org>; Sat, 25 Jul 2026 22:51:13 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id C88DB120435
	for <linux-mm@kvack.org>; Sun, 26 Jul 2026 02:51:12 +0000 (UTC)
X-FDA: 85029401184.03.48831F8
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf06.hostedemail.com (Postfix) with ESMTP id 7F248180002
	for <linux-mm@kvack.org>; Sun, 26 Jul 2026 02:51:10 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b="vs/G0SX2";
	spf=pass (imf06.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785034271;
	b=Mf5rrlbkyy30dL7kLcxMh79qoOkPj1txE0oKOffKvl6brB3Nyy+hJn7+HG5dnarbMtP5ZL
	nj9TI26HRQB4YucgBGK2kWhQByNlN7d7c3drrLF9YCIHZjtlRdv0ZA+NAlRg6GA5BY/0wi
	skZhnqr3fQiYCJkuke26fRlPPFQUPTE=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b="vs/G0SX2";
	spf=pass (imf06.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785034271;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uJqo0KAzdrTFteiLyXiwHItJklOekXH2ZJCIKZBTq1w=;
	b=QebATD3znLihsa4NgOAhdvCPNWsvSVodMEd5NrYp+oG22aXLoMzNWPT8uNxXiPlMz67DTm
	21ApdGuUe1XVn1AXkLoBbMvHsp0Xj1VaWSzLoXHrP8xmwOEizN2T6rZ/m7B5/zxEoFrMpW
	gQim5urkv4Epo+zPHW6ANtvVyrvxGvI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 7600460008;
	Sun, 26 Jul 2026 02:51:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E03D11F000E9;
	Sun, 26 Jul 2026 02:51:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785034269;
	bh=uJqo0KAzdrTFteiLyXiwHItJklOekXH2ZJCIKZBTq1w=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=vs/G0SX2LvUBaB5f47wVVZ4IU34Pbvqdf2ByrOMvD2TbNVqAs45qqix+KYHqZGLW+
	 LElKKXECKoOKC20W7/PLESsPwuTNRdowUZjjpWacQZMbh8I3GpvI4bVkXiUN3VIW8A
	 4DxKo27pmPJR/9Xed4JBG3G5TBPVxXME0+tOoRDc=
Date: Sat, 25 Jul 2026 19:51:08 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: kernel test robot <lkp@intel.com>
Cc: "Kiryl Shutsemau (Meta)" <kas@kernel.org>,
 oe-kbuild-all@lists.linux.dev, David Hildenbrand <david@kernel.org>, Linux
 Memory Management List <linux-mm@kvack.org>, mm-commits@vger.kernel.org
Subject: Re: [akpm-mm:mm-unstable 340/601]
 include/linux/compiler_types.h:702:38: error: call to
 '__compiletime_assert_501' declared with attribute error: BUILD_BUG failed
Message-Id: <20260725195108.3f31c2641b0689d344e55400@linux-foundation.org>
In-Reply-To: <202607250853.VaJWGLeA-lkp@intel.com>
References: <202607250853.VaJWGLeA-lkp@intel.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: ig3iq7c71iaxbk6nyoh7wy18xhbd5gdk
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 7F248180002
X-Rspam-User: 
X-HE-Tag: 1785034270-764702
X-HE-Meta: U2FsdGVkX1+faQ+o+YKto6LuPb5BlmTpoJTrXo0AwVSl+M2d6KG831jNTcRHg3bIOFKLvI44ptVXGMWiAhG/JZ6lDFSYyJF8se+sokaQizubI1k3EUqKE0Ht7krjjEFUm9sfwt9eaID1pDly1xo7t7G1YlfupfvR/gNeSocWQpsYZ5vF6Nu3tMHhUmtCWEgDPeEfDI95MANRPyJGXZrMVkTB3HoDTzBrpFRxtETqrRzFgq5llmV980vf1BLLjHvtqwTGEaQ5lhOJu1XvisYQ34g+kU///h/lMmLqmfq6xWNuiUnyTreanV10SK/hNiZ27w1oEDbfjijqPSve9mjTvWyzqhLiR83Jnfjku2kqvEaUCWMvNj9dFAron1VSm45iLJWuCDYmuSXo7VB1gKGF8+f3NvtBiAhh1neHpkwcqSqxvFXNz8WSVpDi2AejPPgi9U2jhWIvURQnGuyqyhRT5pAvpvl7c5SQ5va8lQ4ytg8K6EbTG/M/YdGZQCl8N600NADQDi8ojCr/ymmdBd6BGzxs40mS4orycPAT7+yDkcZk9kkp2B4VxKjaSrf103ZinvjHNBLBl2/Hky47f3ZOG4FK5M97Q1sMLzUV8Lrxbg8Mk7v6S1nziBrsAbnbY+r4TWViTGsSorpoGCHD7EfV5S1o9SMJ/V1YaVUtc3IC014/M0PlReF6/1lKjh9rV4eV2YxZSdblD4olkyMWuz9ZFoRfr6yfGCZJb0UCDbH6vLg47ah5Z16D2mDVGlk30B0QsVBwW2svt/D5jxahtalebwDKlNgRZsfUWVztpx/ejKf/r2ohzGZoMJvmW3FpiR3h/Odf/AK3eBiVzoCUaZjPefzPLVD2LIV6xzytdzJ8wkpCIrbqwXtGlyNy/xMVYbiuWS93XzkwWIEcMnakHD1bIh17dCdSW8aeeWfw1lSFRI9xXz/3ZZT5vFgVbKC+jbKRuhnwma9A2F31/Y+xUFD
 kQUUuOt5
 vyvSJCNCW2eeuWPqurtw+nIujZwdZdmU/sVRP+Ll6RfpxbuYM9w+mTwl2lpQgfeNV9Gd65mcvzRwiMy9khHBzT+JMZBvBiJ6eKOjKvMhtYxAJLE9OtLjv9f0MJNaIEn1cpmDO9+EjLnq30CVbVgAZJUhffcRbDQBqxIbzqwNfnbe8wgKuhrfHOiZrxSFpbZB7BaTNZz2lq33KPVR4OKhqPVdvnbovJiAmPmViSCmJ+DQuUVawTV2cMgPw5hSGVFzWouMUMzWcJqkeK+Th/gwLWQRKBPt61ZS9x9idaomSB3nFpAbgOwgCB7zUzTI7P9NigyPBvD6JGuIQ4sTtkhA02HqF1Bx8szaj++DN1O6TuJ6n26SAIgB2RH6pSHv5eC9c/sa4AunZoZlDRxmNO46IHg63jQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, 25 Jul 2026 08:56:41 +0800 kernel test robot <lkp@intel.com> wrote:

> tree:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-unstable
> head:   c04df384b55dd9dcf72c36b661becb5aaba371a9
> commit: d2aed7c02fafacb9d055a2f683ac12e977ef16e0 [340/601] mm: preserve RWP marker across PTE rewrites
> config: sparc64-randconfig-r134-20260725 (https://download.01.org/0day-ci/archive/20260725/202607250853.VaJWGLeA-lkp@intel.com/config)
> compiler: sparc64-linux-gcc (GCC) 8.5.0
> sparse: v0.6.5-rc1
> reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260725/202607250853.VaJWGLeA-lkp@intel.com/reproduce)
> 
> If you fix the issue in a separate patch/commit (i.e. not just a new version of
> the same patch/commit), kindly add following tags
> | Reported-by: kernel test robot <lkp@intel.com>
> | Closes: https://lore.kernel.org/oe-kbuild-all/202607250853.VaJWGLeA-lkp@intel.com/
> 
> All errors (new ones prefixed by >>):
> 
>    In file included from <command-line>:
>    mm/huge_memory.c: In function 'move_pages_huge_pmd':
> >> include/linux/compiler_types.h:702:38: error: call to '__compiletime_assert_501' declared with attribute error: BUILD_BUG failed
>      _compiletime_assert(condition, msg, __compiletime_assert_, __COUNTER__)
>                                          ^
>    include/linux/compiler_types.h:683:4: note: in definition of macro '__compiletime_assert'
>        prefix ## suffix();    \

Well dang.

I can't reproduce with sparc64 gcc-15.2.0. 
Documentation/process/changes.rst says we support 8,1, released in
2018.  Your 8.5 was released in 2021 so perhaps three other people are
still using it :(

https://www.kernel.org/pub/tools/crosstool/ doesn't appear to have
sparc64 gcc-8.5 so I gave up.

So I dunno.  I'm inclined to ignore and assume that if someone else hits
this one day, they'll either fix it or provide us with enough details
to figure it out.



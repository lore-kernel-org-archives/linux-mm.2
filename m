Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 124D6CA5FC5
	for <linux-mm@archiver.kernel.org>; Wed, 30 Sep 2026 19:02:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0719A6B0092; Wed, 30 Sep 2026 15:02:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 021C86B0093; Wed, 30 Sep 2026 15:02:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EA1796B0095; Wed, 30 Sep 2026 15:02:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id BECD36B0092
	for <linux-mm@kvack.org>; Wed, 30 Sep 2026 15:02:03 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 426F51201ED
	for <linux-mm@kvack.org>; Wed, 30 Sep 2026 19:02:03 +0000 (UTC)
X-FDA: 85271348526.09.DF4D270
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf23.hostedemail.com (Postfix) with ESMTP id 74F7514000F
	for <linux-mm@kvack.org>; Wed, 30 Sep 2026 19:02:01 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=fFiKF37h;
	spf=pass (imf23.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790794921;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iAsReCTytLlPmWcEOHSoj1dgR274NQzuT79OvkmOz4o=;
	b=KeQwrQRXzgOicsurs9n8UtrhzL7S9qX9G35OQkTsuafeHANKfxlyaKzE36MFamn8N/b96q
	aWDgd699Kk9lMF/vZHUEpxQOUKoUVBfJoLO/pHmWQOaAzzy2mS9mfpAiwgXd3l7s/uzic/
	60ixOcj/MFxOesYn2X5ojt0CI0usTz0=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=fFiKF37h;
	spf=pass (imf23.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790794921;
	b=lh/mczEc11HYb/cePUon8JY6Uj11K4h1hO1WgA9aWFjm+xEqRir58NPVvxviCi+fOvJywP
	mcUkczIZdnYIcuzzxBfmQQK8hO5YsXCTmfbUkyRb7GyZu5M69V2mNWUbjzLbUMSknl2pD3
	RbwLv4v5OXntadIerjtJNUqiC0bzzTg=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id BADB041B4B;
	Wed, 30 Sep 2026 19:02:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 634411F000FF;
	Wed, 30 Sep 2026 19:02:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1790794920;
	bh=iAsReCTytLlPmWcEOHSoj1dgR274NQzuT79OvkmOz4o=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=fFiKF37hUkAaT3syIQ0DpdkG1CSyfgYKzcoxFjEp35VVkyQroO8/A1Oocn2EKN9vZ
	 JVVIoIiXnsZ0uINyVGVWT4KR0usM73P2RfcLFsaUwsLSmmx3g69d9hPm+sXi24Z+DE
	 NHsagci6EXTheHl7sWTUmsa2UYuIvv6NZVSAV4aA=
Date: Wed, 30 Sep 2026 12:01:59 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: kernel test robot <lkp@intel.com>
Cc: Josh Law <objecting@objecting.org>, oe-kbuild-all@lists.linux.dev,
 linux-kernel@vger.kernel.org, Linux Memory Management List
 <linux-mm@kvack.org>, linux-mips@vger.kernel.org, Bradley Morgan
 <brads@mainlining.org>
Subject: Re: arch/mips/boot/compressed/decompress.c:undefined reference to
 `__ashldi3'
Message-Id: <20260930120159.7e4f29a82d461bd8b040454e@linux-foundation.org>
In-Reply-To: <202609301826.MFaFMsmd-lkp@intel.com>
References: <202609301826.MFaFMsmd-lkp@intel.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 74F7514000F
X-Rspam-User: 
X-Stat-Signature: m7eb9a5aasugn3nde5mhezg8u9b6rsu3
X-HE-Tag: 1790794921-762566
X-HE-Meta: U2FsdGVkX1/gjuFfrXi9oEzJ+xrBPzPeMonWxrVkkCsqgbOZo6Ylm/doz4DTHGwaE5QHIjLnhUY1W76ZmsuU1XQDlLm7a9Gh7ygkQFr51Xd3/AAe/RN073X6gb/LBk37Fdys/8tiIT6bScVFwHYxc7p1J1zlnpjoQN/58qLAf2WEyrcWYTODZF1LpvFlxmsFTkM/MA9gYwXul49aftA7e3GnWGov8kzTdz0U9pB4BaExyhxDeek+JzFkls5Cnzr8mNUlgbVrqp25aNcZrhaXHB++an8BQBof8EklO4nJu34JDfCR9phm7TeBMAuoVWGN3vUjfsQr+CXvXseRnztlvcBqsr+1UMmh7hNIs8Sd2qSU6Cm5RB00Pp/XKmWHWV8PR7GFDOTR9p1ZwrexsXDY6a4aYeBrz+pggxjByprzVuq8RD8Gmc/TaSLG8R9wcheIP4mmtpSRhzGX4GHBMeiWi+6Dz1WeCQRnBk3YV3iv7uSs8NvcsHZUcf1418ms4MXCT81UyXnDqQWKnBocf7Hut+urUEteLx8r9rVAgSfASBXJs6zRr2YWMkXbI5L7Co/hOKe88MKyOjjIfmsdfYFbM4QklQrtKegGPImH0fiSisHHMd9X9WEp8crXrjv09agOyOiAZqC1ob8pos3rWHtiM0IsYwGXdrxNlTc/xZXHbx8kmQx7y2187Dp40TT2/mFb9awsZk61HlD4HGvV+eaTbqhM8tCZVveinVI4IKkrp66V/6K+37rVYpIQA8svOdERp8U6C5xJ+0jbd7aFsOZP97llh97N+ChHtNApxT5F5/l3yit4jYpFpjqcHl0nvckPx1eZG7xIsHwNRKePLq6EUD/eUhP2IY3gQ1K7FWld9iYOBOhRxq6zJUQnEeRkorSa9krI933PgdYHw3yxjtp0qZ9jVrsCbkAR9IosbOhXUsxUV28M0SuCmknTYA7XtgXkn9I1V15LssvYkizZ57W
 qyOMNjY3
 F+GRPNRI8ouV8IvHya+Fi7sBYxnwSO3J1s/gtQBNqHylgaAU9vaL4ziwOBtxtNkxNecOCbvtXCtSm5ZVmFCBQRqsVqXpDLgZV3bqZo1rTuUD/6cIULvurC21qNJr0LUuRNDiaWFIlHn5ASJQK8hw8ZEAc1ALS4XE8HBRn7pXIEadofBkRbmUDnF/mztN83QAQUb8VpT31dKydPkx3zxZp606VC66stvY2fjLxioOXy1XX5ad0Rubg2pmGtafCRRhDOrtrP2HCbXtIenE7a2bOx3L/ZWHUc5fB1FGifbLJDjQsMsHOZYrhs9uPmtT7chm8qsfGQND0ZApkHO9WA0qcSLumcbJljrbyIL/13+LNXlg0UGaobrOi2NbxHjAPIX6Uos/KphV01DFO+xChmrkjGle+BQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 30 Sep 2026 18:36:50 +0200 kernel test robot <lkp@intel.com> wrote:

> tree:   https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git master
> head:   551c722f40809618230001baccf219193e22fc5a
> commit: d4dba3b9c03a326cfa73833d6b166aeb442f82b5 lib: decompress_bunzip2: fix 32-bit shift undefined behavior
> date:   6 months ago
> config: mips-randconfig-r2300-20260930 (https://download.01.org/0day-ci/archive/20260930/202609301826.MFaFMsmd-lkp@intel.com/config)
> compiler: mips-linux-gcc (GCC) 15.2.0
> sparse: v0.6.5-rc1
> reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260930/202609301826.MFaFMsmd-lkp@intel.com/reproduce)
> 
> If you fix the issue in a separate patch/commit (i.e. not just a new version of
> the same patch/commit), kindly add following tags
> | Fixes: d4dba3b9c03a ("lib: decompress_bunzip2: fix 32-bit shift undefined behavior")
> | Reported-by: kernel test robot <lkp@intel.com>
> | Closes: https://lore.kernel.org/oe-kbuild-all/202609301826.MFaFMsmd-lkp@intel.com/
> 
> All errors (new ones prefixed by >>):
> 
>    mips-linux-ld: arch/mips/boot/compressed/decompress.o: in function `get_bits':
> >> arch/mips/boot/compressed/decompress.c:(.text+0xf4): undefined reference to `__ashldi3'
> >> mips-linux-ld: arch/mips/boot/compressed/decompress.c:(.text+0x168): undefined reference to `__ashldi3'

I dunno, I'd be suspecting a toolchain issue here?

--- a/lib/decompress_bunzip2.c
+++ b/lib/decompress_bunzip2.c
@@ -135,7 +135,7 @@ static unsigned int INIT get_bits(struct bunzip_data *bd, char bits_wanted)
 		}
 		/* Avoid 32-bit overflow (dump bit buffer to top of output) */
 		if (bd->inbufBitCount >= 24) {
-			bits = bd->inbufBits&((1 << bd->inbufBitCount)-1);
+			bits = bd->inbufBits & ((1ULL << bd->inbufBitCount) - 1);
 			bits_wanted -= bd->inbufBitCount;
 			bits <<= bits_wanted;
 			bd->inbufBitCount = 0;
@@ -146,7 +146,7 @@ static unsigned int INIT get_bits(struct bunzip_data *bd, char bits_wanted)
 	}
 	/* Calculate result */
 	bd->inbufBitCount -= bits_wanted;
-	bits |= (bd->inbufBits >> bd->inbufBitCount)&((1 << bits_wanted)-1);
+	bits |= (bd->inbufBits >> bd->inbufBitCount) & ((1ULL << bits_wanted) - 1);
 
 	return bits;
 }

32-bit MIPS should be able to do this?


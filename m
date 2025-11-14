Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CA797CE8D76
	for <linux-mm@archiver.kernel.org>; Fri, 14 Nov 2025 18:54:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 03AFA8E000C; Fri, 14 Nov 2025 13:54:57 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 012C38E0006; Fri, 14 Nov 2025 13:54:56 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E91BD8E000C; Fri, 14 Nov 2025 13:54:56 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D71318E0006
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 13:54:56 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 881B81A04AE
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 18:54:56 +0000 (UTC)
X-FDA: 84110114592.02.05FF333
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf01.hostedemail.com (Postfix) with ESMTP id 0D67A40017
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 18:54:53 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b="EXyj+jX/";
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=none (imf01.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763146494; a=rsa-sha256;
	cv=none;
	b=rb3nWRHQXaFK5FJ//bRaIjmvqN1ExOXkq4/JB3atLa8P6HcOhgy7EFScIeSnyAA5qrtiJ2
	y75AdtKFaTJw0kgBVUqsgcM4/zHwLJDO3fFKaryLdnQiyopq9Kd6skxM0EYlCGJlZ5Jbb5
	oAG//qeP7ND1kGZDnHQdpLO7RgBTai4=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b="EXyj+jX/";
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=none (imf01.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763146494;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BSZ7Nwx1AvWu7mAZVmuradqomXtKIHLL0ikfemFoO2w=;
	b=E6C5y9ST7nPcinddLB8/+iLUZG3YSOk/lBrF+3RlnxsO8hadG/nxkJ2MkLjHQDsyT+5d7v
	4d2v8yUczyAf+j8av70sswQHf/ptxM+WNpWUOiRBDC6DpAwNAYEtMSMpEmOhz5F/2LRks4
	9QOfV9a3kn1728kVqC/3v6J4Gfr9j5g=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=BSZ7Nwx1AvWu7mAZVmuradqomXtKIHLL0ikfemFoO2w=; b=EXyj+jX/BCty3AsVD6q8QioIyM
	2Tu4hXDLT6tK2iLl7v3D8NpDemFXta54A9KS5c/9JTbl/kaYZYgeBcKsuY3S69miBq2y4AXmAv2bL
	YQD4NgIM7YIim3b0UHSaUhNRz/WimQx7WxGquDaJwIo7MVXyCTLDLjft8/UOa06x5up7w8+pMGpSw
	y68/Lux4D98y4TT/21m/3RbtLpiIPdbbkbKvR1UMPg15Onw3LD/mL7F2ndcPS9PxptjRtDtDfcio6
	/OGLs9hEtShvsTvCwTvfTocOLOwo5T+6WGd0vxdCn+uu4DRkTSGzyn6Pz7xZpcmyTbVwWnoXBj/An
	lkpE5YmQ==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vJywa-00000009mlh-00u6;
	Fri, 14 Nov 2025 18:54:48 +0000
Date: Fri, 14 Nov 2025 18:54:47 +0000
From: Matthew Wilcox <willy@infradead.org>
To: Nathan Chancellor <nathan@kernel.org>
Cc: kernel test robot <lkp@intel.com>,
	"David Hildenbrand (Red Hat)" <david@kernel.org>,
	llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
	Andrew Morton <akpm@linux-foundation.org>,
	Linux Memory Management List <linux-mm@kvack.org>,
	linuxppc-dev@lists.ozlabs.org,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Nicholas Piggin <npiggin@gmail.com>,
	Christophe Leroy <christophe.leroy@csgroup.eu>
Subject: Re: [akpm-mm:mm-unstable 36/283] mm/hugetlb.c:4753:18: warning:
 implicit conversion from 'unsigned long long' to 'unsigned long' changes
 value from 17179869184 to 0
Message-ID: <aRd69_c1pULRoKOU@casper.infradead.org>
References: <202511141140.LrrRrtIv-lkp@intel.com>
 <20251114182956.GD2566209@ax162>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251114182956.GD2566209@ax162>
X-Rspamd-Queue-Id: 0D67A40017
X-Rspamd-Server: rspam07
X-Stat-Signature: y5mxb4qqahfsjmioaek31dupiabpou8q
X-Rspam-User: 
X-HE-Tag: 1763146493-331413
X-HE-Meta: U2FsdGVkX18X1mLjVCv5zMtU6d740mdn4Xlw+iTCfDScGMXc4NhIIcAm4oO3u5+1GT4b0w2fQ7BoOMlM+IyO86T3RKQ7dgOJUrKZ6iyVp7/VGqg/XwnPpDkF8Do2CUfDYVt8qI7loHmzpNO5HFs6PDsalG9uc8LsFUu1ITYoHmqOOUBR8CFaV0hAjtH3GAfOhyQUh5DghRRhhcpvaa4K2M/cPRIm0gcKgcVgo1PiHv3I2FagrTQwJoPKMQ2zkiWVHNMmKddk0wo7i00ntK36AN87WoqNKX3eb742QH6R4xnOYdOcSuOFaE0ItpZfPxi2bIjRSF4mtrzzsSm71BIpsIXliKGCrwsoTcJZGuD2tE0H2kwH6TVupwk5qAiGdoRuvhSVmt1DTdulWg+ShvVEtN7duUWbx4WWa9oXsByXJ9i7765+66Ufu5DvstX7+xR3P/tKOEYvYzlMtcxqTHSPH3IlqlASlC27fUvTpldLuhiVTQ1Y7oYbD08qeR3cAD8FbIwv+6Trkp9y8intGV0lQVjUgBs3vkO2udPdmpIWPJsBVUPQt7GnUGtU+ttcETp0u1KEzes53GzJRLonlTwBrSFS06CkrlFYzK7B54PPuAhb0CIencGlGN68ciDw9YrNOz16sIKwx9Xa4q5w7mA7dfJ3IggqCppwbq9eFUk2rk/N8mXbParEtps8oTXab7gHpolrWdiQvECI9i+hE9f5nlpFi6pIhSscxt+Ef4/cJf3lDZuuDFhBZtwFvV9CO/Zp1+UtBdIN75uZYILQG5FarMB1wO6e7JDiPudPkNA2hvC5yTtXDHuqlq4ZBr3P8lRCRz2ojTYgEU0ffSrJcp1AHNdwdvKMAAB3Jy2rSie2imSpfb0MtnG5VlxJFhbpvGtPLfU8cz/A2UEw7BprzVJg0H65U6a125wULa9SC7TWkK1NgtRevNzDY+eDhn1fD1vPjp0gVGyVXjRYENt7PPQ
 P0apBphO
 2R5bN2oysggN6Z4XlaRgY52DoR06+50tHTdB/5TlACrdtM9DOAhyRYjRHdWCHw14Us+mC07ZG5Sr4WLyhn1w5lSTDt7rvF4WkOTesHr8+svn4JKdKCyEXOUMRu7XzVci2Kc+XUi/nNLunsB0dajkaijmzRruRZk/LoE4rPsrCBkYYd0xLJP92MqN2HbkLvr7ukMGcyHhQKTsqAY4thDHc+hdpsBdkvdILOsIM4sjbmUlserhh04T+DuW4kbnUvLey/HiM
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Nov 14, 2025 at 11:29:56AM -0700, Nathan Chancellor wrote:
> > >> mm/util.c:1263:16: warning: implicit conversion from 'unsigned long long' to 'unsigned long' changes value from 17179869184 to 0 [-Wconstant-conversion]
> >     1263 |         if (ps->idx < MAX_FOLIO_NR_PAGES) {
> >          |                       ^~~~~~~~~~~~~~~~~~
> >    include/linux/mm.h:2104:36: note: expanded from macro 'MAX_FOLIO_NR_PAGES'
> >     2104 | #define MAX_FOLIO_NR_PAGES      (1UL << MAX_FOLIO_ORDER)
> >          |                                         ^~~~~~~~~~~~~~~
> >    include/linux/mm.h:2095:36: note: expanded from macro 'MAX_FOLIO_ORDER'
> >     2095 | #define MAX_FOLIO_ORDER         get_order(SZ_16G)
> >          |                                 ~~~~~~~~~ ^~~~~~
> >    include/linux/sizes.h:56:19: note: expanded from macro 'SZ_16G'
> >       56 | #define SZ_16G                          _AC(0x400000000, ULL)
> >          |                                         ^~~~~~~~~~~~~~~~~~~~~

Clearly this is a 32-bit build, since otherwise a conversion from
"unsigned long long" to "unsigned long" is a NOP.  But 32-bit cannot
support 16GB folios!

I say this is a bug in powerpc32's config.

#if !defined(CONFIG_ARCH_HAS_GIGANTIC_PAGE)
#define MAX_FOLIO_ORDER         MAX_PAGE_ORDER
...
#else
#define MAX_FOLIO_ORDER         PUD_ORDER

(PUD_ORDER is 16GB, so I think this will be what's being picked up)

but the only place the mentions ARCH_HAS_GIGANTIC_PAGE is pretty
clearly dependent on 64bit ...

config PPC_RADIX_MMU
        bool "Radix MMU Support"
        depends on PPC_BOOK3S_64
        select ARCH_HAS_GIGANTIC_PAGE

so I'm a bit stuck about how this comes to be.  Adding the PPC people
for thoughts.



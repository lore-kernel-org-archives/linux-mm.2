Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B7A5DEF8FEA
	for <linux-mm@archiver.kernel.org>; Wed,  4 Mar 2026 14:24:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1E92D6B00C5; Wed,  4 Mar 2026 09:24:10 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1C1436B00C7; Wed,  4 Mar 2026 09:24:10 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0F70E6B00C8; Wed,  4 Mar 2026 09:24:10 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id F12896B00C5
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 09:24:09 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 8ED0D8BF93
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 14:24:09 +0000 (UTC)
X-FDA: 84508600218.06.AF6FB7D
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	by imf28.hostedemail.com (Postfix) with ESMTP id 50728C0005
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 14:24:07 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=CLqTDTZq;
	spf=pass (imf28.hostedemail.com: domain of andriy.shevchenko@intel.com designates 198.175.65.17 as permitted sender) smtp.mailfrom=andriy.shevchenko@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772634247;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bufIZ0KxszJQ3L9rJ1V727Ee8v2Au2l4SBRQrB6L5Jw=;
	b=XlV4OXQwyz4DNpnskuxyLPC0AOTmvV4AVzKAWA2eM7hSvd+rE1KdFMMmtdb0YaFzIG6KuG
	3l4U62aOY4TLPOAubkZSfy8bMbgva/8wt/xEb2GrPOHr1FhWolfJ0XyFTuaclfOoTtizVm
	I1jvQc8EBoZzfTErzj1b8C1zUDJkcDM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772634247; a=rsa-sha256;
	cv=none;
	b=KWz8b2m7wQ42ryA2iAKpWI4qo00gWznSRPieLizaEBqEfgCTRgM+ZoK90eh9JuJzcYN5hw
	6+5ccskLJ/AKrkpMqH71BgFte3aQDX2ze4anTa3T+4/3VBNy1+lbPU0oFDO1WNhr1HJTx8
	++TklDejwGcrNGmIzmMqjBPjXxcgDK0=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=CLqTDTZq;
	spf=pass (imf28.hostedemail.com: domain of andriy.shevchenko@intel.com designates 198.175.65.17 as permitted sender) smtp.mailfrom=andriy.shevchenko@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1772634248; x=1804170248;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=tu9M8dAwlOQjnoY40nXiz6IClVdkQ07FefvPXNdEylE=;
  b=CLqTDTZqvFzQMfbrZ+Rx38cbtDoDgj8A3kpwFIYak8t/FrisbwJMopC8
   O6e05VsUuInTNL1vZt5KzqxSvYW346ANWF/ALupW0mJ2OhQfsvdAAvR/6
   xOOFpmSEUeCGMii35wLDf+XTmj7ckJAQZUVM2geY60LZiklme6THPVYyI
   k0Co3Jlbw3WiwLp8lFzGdaEtlYucDj+v2epIM3jtTmwK+CSvkBxr74J8a
   BVfSjuhpEVnlsIrJ4w6YWpXbOSru6PtUcv/J3zN0sQ8STemtmifrTixoH
   lJuTs3AEKt699OFpIlV2VZKVtuGmH6wgKr9bM+O+WkkFlU1bVDn/Wy71e
   w==;
X-CSE-ConnectionGUID: J6mkiiiFSiC2EmZZfcJobA==
X-CSE-MsgGUID: huCB/X0eRPS1rhJOvgaiaA==
X-IronPort-AV: E=McAfee;i="6800,10657,11719"; a="73660052"
X-IronPort-AV: E=Sophos;i="6.21,324,1763452800"; 
   d="scan'208";a="73660052"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Mar 2026 06:24:07 -0800
X-CSE-ConnectionGUID: uzbeTbSRRRakzTp6nigDog==
X-CSE-MsgGUID: 15Rp0FUNTGS/1QZm+UiaJg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,324,1763452800"; 
   d="scan'208";a="223020477"
Received: from abityuts-desk.ger.corp.intel.com (HELO localhost) ([10.245.245.127])
  by fmviesa005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Mar 2026 06:24:03 -0800
Date: Wed, 4 Mar 2026 16:24:00 +0200
From: Andy Shevchenko <andriy.shevchenko@intel.com>
To: kernel test robot <lkp@intel.com>, Kees Cook <kees@kernel.org>,
	Ard Biesheuvel <ardb@kernel.org>, Paul Walmsley <pjw@kernel.org>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Albert Ou <aou@eecs.berkeley.edu>,
	Geert Uytterhoeven <geert+renesas@glider.be>
Cc: Dmitry Antipov <dmantipov@yandex.ru>, oe-kbuild-all@lists.linux.dev,
	David Hildenbrand <david@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Linux Memory Management List <linux-mm@kvack.org>
Subject: Re: [akpm-mm:mm-nonmm-unstable 49/110] __efistub_cmdline.c:undefined
 reference to `__efistub___lshrdi3'
Message-ID: <aahAgJ0G1uYSCFnF@ashevche-desk.local>
References: <202603041925.KLKqpK6N-lkp@intel.com>
 <aag95SSwClx4IzJU@ashevche-desk.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aag95SSwClx4IzJU@ashevche-desk.local>
Organization: Intel Finland Oy - BIC 0357606-4 - c/o Alberga Business Park, 6
 krs, Bertel Jungin Aukio 5, 02600 Espoo
X-Rspam-User: 
X-Stat-Signature: fyuqgknjmoqpnsq4fhzchntqyg3qfx3g
X-Rspamd-Queue-Id: 50728C0005
X-Rspamd-Server: rspam03
X-HE-Tag: 1772634247-406674
X-HE-Meta: U2FsdGVkX1/wirGxZQwaaFzQ19WVZ5bA/0lDvr+NVukGbTNlycrvy3U8E7wlRaV7RfsWp/Vg8jyJmCGXNrqqZMbBtBexAUA8L/hv3YKAfQSXeBHDYDZeWbeSkvcfgJtyn6o1fsiElMP0zpZ9ePy+v5CJmvnt+AzIrnF7WPg+AYXSjlowkjLcIm/IirSAi0ilmTe4OJ1+gwZAF+UTjmiTA3PTMyZwkKFV+WXrk7g+Vb0NR0CHly+jbvLcFLEPVLQOggxBZTT/us8gERtb8SpQ3EztU1VZnXIo/3aOF2kVHy+VemX/L5ltOuP5xgLiG7xWBevl1APQe71OoYVd2goPtA4BbSrHXMuO1HxP2X8AfocjYxRIb7yw+bFyf+nsRh5MQ0d2R91brnbQh8IF4R1o2MqOA/F4Ivj8Ozhv/G0fy3CHKs/kProzzEtQ6CpREmvR9FR964vrS4RZprEEBUFOXEf0BL22Ldkyz6pPlvpj0Y9lp5CkXl8P4TPXQ2oKVHHL+X+X0uXVljpLJUKAF8TeJMtYlhl24mKNjBa7SoiyzoqwrHKSDa6Z69OmjCFs0nDF/pLQVwTkX63rs50AIYrUrLNbgD1xhoJdawRyiIxu4j8rQX2BYWB0th0NKhF4CuxxkV7ig9NGosRB+lClOTbxluYOPTo07oH83aMkqkRJjWnkRuW5cYuKlNEza/1pJFDoHu/MfhlGIidFWKX7lc/0v6DNwxVeCXoZ++WafCjRciEQDO9q4mHT9hMdgyCD+lAgTDOzKEwpO0tDe/xfWv05foR8kn0U5fw8a1jNSwHhyGt4Y+1afO7Z0I68l/wxj/F8E9MxMnfWUfX0x1wYqq30C96lHWhzfsrfrBr18yOMHzdDv7DNmmR3dvAaa1vlXjixb3tp4OxQTGCqMUqaAELAq8UI76Sxoq+TZzNXDc7Z34rJqOju4Ok7SOKxcYEl8YPvLgVVg7rX7hWGvCxWsKA
 sWweFlKI
 TbuZNnyJf+1B1LY0NtvdRayhDqS9AzgD/4D5l2ZWWbDzjz3AX7BGZmrAu/aPXTYaLPezxc/2faelZRgOypasiaFLfA0uZ0A255VB3G0sZiN0ZGUzlP2H9ueq2Q9HWQkXZGM8FBFQNupEyKF6I8Ti3mtciQlCn2Q1Oq3PQUC7kWzLuy6rmox9qO0KStjavNnlF0SbsmTxY9HsilTfp/4Jg7ZAD7objrWZRoXnieVNQGTFPqjTEkfFfLCf3okOpn35HhPSlqEvdWXuRiAfoNEdllaD/UGj9znAdmHlxtfJJHL3STKPTDZjesA8U6Ihth8j8B14Lb9u5r4u3/GTlEEDry09/tYIBxYyYgKxu6gseOQAGdMOvO4zoGRRnymVYIuYw3bU0hX7ZpD90NrrWe5pKNmGWN2BvdjsPbV6/yqzxzXb/A30=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

And since it's riscv, adding people from there.

It might be that they simply need to include the corresponding library to their
architecture builds (we have lib/lshrdi3.c)

On Wed, Mar 04, 2026 at 04:12:57PM +0200, Andy Shevchenko wrote:
> On Wed, Mar 04, 2026 at 07:29:09PM +0800, kernel test robot wrote:
> > tree:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-nonmm-unstable
> > head:   09c4ad73ba08ac959a6afb5e019826743837e0aa
> > commit: 7c5bff091374a7980431237af80e6da21dce74fe [49/110] lib: fix memparse() to handle overflow
> > config: riscv-randconfig-001-20260304 (https://download.01.org/0day-ci/archive/20260304/202603041925.KLKqpK6N-lkp@intel.com/config)
> > compiler: riscv32-linux-gcc (GCC) 8.5.0
> > reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260304/202603041925.KLKqpK6N-lkp@intel.com/reproduce)
> > 
> > If you fix the issue in a separate patch/commit (i.e. not just a new version of
> > the same patch/commit), kindly add following tags
> > | Reported-by: kernel test robot <lkp@intel.com>
> > | Closes: https://lore.kernel.org/oe-kbuild-all/202603041925.KLKqpK6N-lkp@intel.com/
> > 
> > All errors (new ones prefixed by >>):
> > 
> >    riscv32-linux-ld: drivers/firmware/efi/libstub/lib-cmdline.stub.o: in function `__efistub_.L38':
> > >> __efistub_cmdline.c:(.init.text+0x1d4): undefined reference to `__efistub___lshrdi3'
> 
> Wow! It seems compiler tries to use some intrinsics here?
> Cc'ed to more people who may be stakeholders of the efistub and overflow.

-- 
With Best Regards,
Andy Shevchenko




Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5215EEFCBD4
	for <linux-mm@archiver.kernel.org>; Mon, 16 Mar 2026 07:12:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A8D976B0150; Mon, 16 Mar 2026 03:12:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A3B226B0151; Mon, 16 Mar 2026 03:12:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 947B66B0152; Mon, 16 Mar 2026 03:12:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 7F3886B0150
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 03:12:57 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 31CA01B9476
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 07:12:57 +0000 (UTC)
X-FDA: 84551059194.13.A0EAB52
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf24.hostedemail.com (Postfix) with ESMTP id B38ED180003
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 07:12:55 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=SMDd1Sl2;
	spf=pass (imf24.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773645175;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=H36Rh4jAsS0QoXhWjGsqigNoERHzKKkiQ3eU2//MTDI=;
	b=texYs3AxBDkr8tcRD/uDt9GmRBcc43qA1Up8jryS117+QqRjlELrtnRxRi8PqQC+VPY5Pu
	V6LZwqOgqlcbKj32SsbML7X+f34jiBz7OI0nFjPkqPcZ7yOj5eA3oVT629cMjGaYtDSR73
	hk55m6EYS1cA/D2h00CgE3c8bNpJNZA=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=SMDd1Sl2;
	spf=pass (imf24.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773645175; a=rsa-sha256;
	cv=none;
	b=qoVQsGZwgNtEDFdUTzZUMwAvyX9MFfGvygWdbmuw9d+fTVGxtBVQ3bHqext6wl3basNv6I
	tyQCxFIVJnKaYWLrrIhmQ4vdIRuQhC5CD+cm89pjd3b11Mjp/z/59nRRsoLdNwgfXMAmX1
	1mwPKR2QK49Tx6eMfE1yAxwTrDvEOzk=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 29A57600AC;
	Mon, 16 Mar 2026 07:12:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3ECF8C2BC9E;
	Mon, 16 Mar 2026 07:12:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773645174;
	bh=csmW8+0vk8ePHltXghMcxvD+0rWN3gKYZg5DsV2YUHE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=SMDd1Sl2gDiqkcGkpasG9q5rUYW/ZH+KeDmVfiWwasTyYVe1CHG0UHj95ptABoGzC
	 NZkfRwI/MddUlG9iq4aNqWixkshRqz6nupTt86/2KmkyH0kSIMEAcsM0mJv99fwg4Q
	 kn3pEY4O+MigkoHHqItE+T3mvNLqBvh2Jx6xBocRgbmUu6L2ISMaiO2yjmqxACsWs1
	 aNKzaw/bFnP1Jy+OOwRWa03bLiaj0sz5gIF3m8M1DXhP6NBlQISitsMlAWhcFAAK1T
	 ZB+gH+xw6j8qxiykH4n2i13rosSAlhW7nsjm7xAb1B3FcunnQkjxaNkVyQajjZgimT
	 WRJPhNNad6RTg==
Date: Mon, 16 Mar 2026 07:12:51 +0000
From: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
To: kernel test robot <lkp@intel.com>
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev, 
	David Hildenbrand <david@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
	Linux Memory Management List <linux-mm@kvack.org>
Subject: Re: [akpm-mm:mm-new 378/389] drivers/mtd/mtdchar.c:1384:9: error:
 call to undeclared function 'vma_desc_test_flags'; ISO C99 and later do not
 support implicit function declarations
Message-ID: <57eb2d3a-b9e5-49fd-ac71-4d48e444b7b5@lucifer.local>
References: <202603161221.qNrB6fVE-lkp@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <202603161221.qNrB6fVE-lkp@intel.com>
X-Rspamd-Queue-Id: B38ED180003
X-Stat-Signature: jjzeerr7nm8gw15kqwkqzt8f8w1hjwed
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1773645175-548939
X-HE-Meta: U2FsdGVkX19jev+jCDvnHIKHUlF/EpltYEjOlgff/m6i6ZI8KekayqeN/d9Rq4RepA81wRDSSZUU7clFAe+f7YZUIY319vt8aXM93XqRzKgPBOx6+6eDQTda1FJ6/siIZ+vfLY5WxShB8UPab9omIUozugw171VEQ/mzeh1QWStPMPZd+Hjg/BKyql8kTzv7jku/xbgmKsHq+dhj6siCNFQW8JZZu7Q1B9cgdnkss1NxDex4ISYMsjVMMAmH2nM6lueYZTMbQlgSa7GeCdIsxWGAYRkqFGR2ySxqUnNxNYJCi+Uqzl77Juy/XIGhQQzcmG1bIoYjTNaMtsdXMfojvVAvsOUn1m1LAyaerXrwUzd5van/pchFFsukX9w1j4qIj6IPhVnxqYeS5CiyVExT16BoIc4lRkyIxwvatgsqtTPfuD8x7wf4g+oXu4lF4QUnchPxEPd1CLOdz3GtkuGLf6VMfRXiWz0zqsQSg8KZQqMIgrMOop48Ga75De6xTvZbbHUIa2jWi6XLV9x+EbO7F812srT52Ou9mPd7UCn2Q+solSxzUownhUt4wdbQvcaEogmuc4VkelVNYmawXRE+4xZjxI+vmIjrnbnH8Kv52RLDSFkPRcRp3F6798s66YbIx9pOmjzj5G8b//U42X5G1RZwUAGVp6MMQAuBMeRBS1KaAtqYGiT6sKbCz+NNSrIp3px/wMkkjkm4vCKLTJtkUWaqEJAC9C+s9O8clajtANaLN6jVkmz15XtpAdSwgWkye8lU5U1iE6Z/azaC3YTKmvy4B+qbgwY8X57TWMNNdbeHwhF7gacfryTzviOH17ZaK2AMC0CRTzbfnIOQenqLgTI7lV4KbXWkg9+VCc2w0ZHKWV0237I//iPE6pUFMkXwqwT/v98+7GtpALi54UVzsEXs1VZfPlOdNNu4fPllNVT5a9vzKoDUVg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Mar 16, 2026 at 12:20:38PM +0800, kernel test robot wrote:
> tree:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-new
> head:   c5a81ff6071bcf42531426e6336b5cc424df6e3d
> commit: cf0dfae0323aa8b75cee0b94d5c7553b511d7bc3 [378/389] mtdchar: replace deprecated mmap hook with mmap_prepare, clean up
> config: arm-randconfig-002-20260316 (https://download.01.org/0day-ci/archive/20260316/202603161221.qNrB6fVE-lkp@intel.com/config)
> compiler: clang version 23.0.0git (https://github.com/llvm/llvm-project 36041192cf6c9042615c8d2364cacc698ef89865)
> reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260316/202603161221.qNrB6fVE-lkp@intel.com/reproduce)
>
> If you fix the issue in a separate patch/commit (i.e. not just a new version of
> the same patch/commit), kindly add following tags
> | Reported-by: kernel test robot <lkp@intel.com>
> | Closes: https://lore.kernel.org/oe-kbuild-all/202603161221.qNrB6fVE-lkp@intel.com/
>
> All errors (new ones prefixed by >>):
>
> >> drivers/mtd/mtdchar.c:1384:9: error: call to undeclared function 'vma_desc_test_flags'; ISO C99 and later do not support implicit function declarations [-Wimplicit-function-declaration]
>     1384 |         return vma_desc_test_flags(desc, VMA_SHARED_BIT) ? 0 : -EACCES;
>          |                ^

Ack, this should be vma_desc_test_any(). Will fix!

>    1 error generated.
>
>
> vim +/vma_desc_test_flags +1384 drivers/mtd/mtdchar.c
>
>   1375
>   1376	/*
>   1377	 * set up a mapping for shared memory segments
>   1378	 */
>   1379	static int mtdchar_mmap_prepare(struct vm_area_desc *desc)
>   1380	{
>   1381	#ifdef CONFIG_MMU
>   1382		return -ENODEV;
>   1383	#else
> > 1384		return vma_desc_test_flags(desc, VMA_SHARED_BIT) ? 0 : -EACCES;
>   1385	#endif
>   1386	}
>   1387
>
> --
> 0-DAY CI Kernel Test Service
> https://github.com/intel/lkp-tests/wiki

Cheers, Lorenzo


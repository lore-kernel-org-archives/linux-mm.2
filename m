Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8C37B606A31C
	for <linux-mm@archiver.kernel.org>; Sat, 28 Nov 2026 05:49:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=JktTvMfS
Received: by kanga.kvack.org (Postfix)
	id CF9B06B05B0; Sat, 28 Nov 2026 00:49:03 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CAA7F6B05B1; Sat, 28 Nov 2026 00:49:03 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BC1476B05B2; Sat, 28 Nov 2026 00:49:03 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A0E986B05B0
	for <linux-mm@kvack.org>; Sat, 28 Nov 2026 00:49:03 -0500 (EST)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 1FC901405A0
	for <linux-mm@kvack.org>; Sat, 28 Nov 2026 05:49:03 +0000 (UTC)
X-FDA: 85483449366.24.1F4EB60
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf06.hostedemail.com (Postfix) with ESMTP id 4384B180005
	for <linux-mm@kvack.org>; Sat, 28 Nov 2026 05:49:01 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=JktTvMfS;
	dmarc=none;
	spf=pass (imf06.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795844941;
	b=o6SLjUN6Geu1sySPkNHQz4udHFqcCsaDzJUGgnIvcqbIsZELtSMuhPdHad+Blo8egQXX6H
	E9yxBXeT4qM7Aii5lVWYps6qV3A0EZnzA6/u2LGGq0lt9u9WWGaHSafmVL2TccyUgh1rF4
	IFNMNUJBscEL8emRgkyfZ+ljI+OIxoY=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795844941;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gYeJofYi9liYn6S4qO14pY4ChJw65r1Z1mgpE4pXETY=;
	b=2uktsCzpxzNZZarUQuetzWZJFXHa71pctY2iMxYoglmOrzQbwkPWVnr4aGygS89SHNGUV3
	3m4DdxRDts811yrkEQhH3f/ikLylQdaXEeBtuvCDJE0WBpIOzvN4z64YjQok+R7ViaAJN5
	lip3D6sknkb4V1fT6v5M5XRWuYZsIf4=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=JktTvMfS;
	dmarc=none;
	spf=pass (imf06.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id A2B7E6062C;
	Sat, 28 Nov 2026 05:49:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 038A71F00893;
	Sat, 28 Nov 2026 05:48:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1795844940;
	bh=gYeJofYi9liYn6S4qO14pY4ChJw65r1Z1mgpE4pXETY=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=JktTvMfS19fCnaznrdzb45dOpH8joUVYkIfnfNGRYCdYxm0Bxwyb85eLPLLYeZmk+
	 zyKu1DHM1vTN7kgGZOdUOgUfSXxoOnvt9OrJtwrm2QZ2GCRaSGn5mHngdMHk7RzXwZ
	 sIhENi3nRl9jpBRbRql3a1BC6vMAqLskpNA4teUU=
Date: Fri, 27 Nov 2026 21:48:59 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: kernel test robot <lkp@intel.com>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>, llvm@lists.linux.dev,
 oe-kbuild-all@lists.linux.dev, Linux Memory Management List
 <linux-mm@kvack.org>, mm-commits@vger.kernel.org
Subject: Re: [akpm-mm:mm-unstable 303/428] mm/huge_memory.c:2546:67: error:
 too few arguments to function call, expected 4, have 3
Message-Id: <20261127214859.8f11ddcd5575f062253cd681@linux-foundation.org>
In-Reply-To: <20261128060622.OMTGOfau-lkp@intel.com>
References: <20261128060622.OMTGOfau-lkp@intel.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 4384B180005
X-Stat-Signature: w4nc7p1ozjjotc6xetqnach1a9zh6fhe
X-Spam-Status: No, score=-12.5 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,NICE_REPLY_A,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User:
X-HE-Tag: 1795844941-898937
X-HE-Meta: U2FsdGVkX1+PIs1ShSBwHhIwsC9xwdR+f/h7g8gNR3EERnLjJ7erl63Sl8bpOpDSc5GrawBHWL+cE2F+pAChmn/ZynkNtg9Ge5nCj8ZkHEicC1bd6BOfDeOG28a5rBWhTO11s5yto/fBAGvtUdEi/407m0sZSpwr/Y+7WePpYGbhl5S84NEYVqVoVqN+6sKGmpEgO/mKcvn5DZL3br0qH0hqvGdc1ujFUTttcWYB7pIMK56ptuNI1XY1lWWz4iJeWwYz+uvruwiyM2KTznGT3MMREfWhtpR0MVdhxL8x4yWR1RiwE9qm6sZQs5U0bdeuVzANbIEhuzN8Fiz0gj4gr5qtPOY4Yb0xbBAVdwFcmhVx8GJJRBr21Tv1/SBSU8YVWvy0pwNaMrWrDCiMn4c2t8z9zuOPYlKkROUyoGqSVqK4L++xhukpiGP7HWjYFa0gbcvWmthm3J8o7JiPuxyjKDmY37bDv7d8T2OucoKobUM1Mg0u5rl3NFC5IUL2DCuSDWAfkv0ThUpcRdLrCy9cdbsjZvkveNzskRq4FKegEYMWLGAdRZabbyAP3L1VTIHq1yWv0Nw09KuvN//5xalO+L/SiOMCvYLlo9XIGS0+hFRK/6UPaFZg5Gj9Z4A8fMOsIt+N2esNcHl4x0q/6QISVMomAAz+EGL2XDHc5O+m7SfGp2tpP9VvreUh+JVMqnlIhXoq6+jEVannr7vzcgbNQgl1BdfSGXAWkGSmxfDF20Y8ZN8u+6/+DGe/ZwwE3ErwI2rGwRaytEVRTkcYbNZfhQ4XccD9a0S6Q/vqGqbRUzyWoQEWywpRSs8jC5VP5z8Umll0laqsHAkERihwkp8Pg6hGNh4gXwSSGHw7RIMIxWQJiNWTKfSDDM0PSE8z/idPUfcHVgRiI5L0R7EXUQE2Uifg+DI7kaX3w0LZWDUIFK3PSI+wd3UV5NqGkPRvFJ2uqTsJS2Ez3Ib8VTgiWBl
 vlLsoaQ8
 tBDu6TWuQgVQ5L5NiTqc+5XR1ZWfRAcz2l6lZHQ7HfdEdO/23LSYOki6XshQOlI9oeo9Rcq7rfb0s8fduh5ppK5K+nSAGHwucO2dAVh8bDKjZjQfeQLL6Q+gFxjhn5KUAoQVIbmtyowY6SS7DECg3UCG23Jm+81byc53VoFcfh1vTuvqG6lYvLv64nEs4+Tt8KEL3yvWO6LBxi/YRffiIsasojTaadVenyA6/YKsP793rx2nicHnJ93c2Cf0GS3YvD3Ti86XoplUzxtYhPFBIhXiJg2YUB4zlwClGdupTHcfcTx+SkP1JnosP9ILJzezbzYh89wrR9bBkKMYPZzPeZw3kQb22zq2qEmSwngrld8I40lQR9StlfXmyXaYM723o4iwGx47O+LxAX2WE0QGb0zX7FO5VtUD3d4ffGAzY3C4G34dOG0gwr1CmXuQ5D192/3q57a7ZwYeRbOhCoW0WbCH6AC/urvfYpUkBBcBlaRAuA3VgMPUvBWRrAV0kkV6A4zW+3PnFTllRov1QvxHdiMiyWNIL2tZ/qmAZraMqTZEOvCtA8BXCXD5UG/tv/q2YY7jkU39jGI0tuBC5rlY/Cif9ebY94R0uMzK0y87zqBfjlHUV1ojC153mLA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Sat, 28 Nov 2026 06:11:18 +0100 kernel test robot <lkp@intel.com> wrote:

> tree:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-unstable
> head:   ac6a52aad42728ef45e6972c403072fba5c524f4
> commit: 5a7c0c5e349b6b13c1689fedd1a82073b4679418 [303/428] mm/hugetlb: delay anon folio rmap removal until after the TLB flush
> config: x86_64-kexec (https://download.01.org/0day-ci/archive/20261128/20261128060622.OMTGOfau-lkp@intel.com/config)
> compiler: clang version 22.1.8 (https://github.com/llvm/llvm-project ca7933e47d3a3451d81e72ac174dcb5aa28b59d1)
> reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20261128/20261128060622.OMTGOfau-lkp@intel.com/reproduce)
> 
> If you fix the issue in a separate patch/commit (i.e. not just a new version of
> the same patch/commit), kindly add following tags
> | Reported-by: kernel test robot <lkp@intel.com>
> | Closes: https://lore.kernel.org/oe-kbuild-all/20261128060622.OMTGOfau-lkp@intel.com/
> 
> All errors (new ones prefixed by >>):
> 
> >> mm/huge_memory.c:2546:67: error: too few arguments to function call, expected 4, have 3
>     2546 |         else if (__tlb_remove_page_size(tlb, &folio->page, HPAGE_PMD_SIZE))
>          |                  ~~~~~~~~~~~~~~~~~~~~~~                                  ^
>    include/asm-generic/tlb.h:248:6: note: '__tlb_remove_page_size' declared here
>      248 | bool __tlb_remove_page_size(struct mmu_gather *tlb, struct page *page,
>          |      ^                      ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>      249 |                 int page_size, bool delay_rmap);
>          |                 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Thanks.  I've fixed all that up so perhaps there's some timing skew
happening here.



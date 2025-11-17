Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5759ECEACEF
	for <linux-mm@archiver.kernel.org>; Mon, 17 Nov 2025 15:45:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B55A48E001A; Mon, 17 Nov 2025 10:45:47 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B2D4C8E0002; Mon, 17 Nov 2025 10:45:47 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A6A3E8E001A; Mon, 17 Nov 2025 10:45:47 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 95BD48E0002
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 10:45:47 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 732B712D5BD
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 15:45:47 +0000 (UTC)
X-FDA: 84120524334.28.60F0763
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf26.hostedemail.com (Postfix) with ESMTP id C40EC140018
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 15:45:45 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=aLnlna23;
	spf=pass (imf26.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763394345;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OOASFy8VudqRVqHCveoUNB8IGvERyojY4oDE5V5cHlc=;
	b=KYL7XMVz6yp2zBZZhEqEauPn9s7/R1Ag6csEDssLPTOoUIsyvTzQaMsftBfRtEmZICeZ3M
	xqH3Nz03tMng4Un1AzhylFZVi3vbpW6Zc0MinioUMHZ2UOK5ysoN98U6bDG7CtE9N/ztgC
	+OWQKyeHs9glXZO4P78vuzv6Jd6V2Qw=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=aLnlna23;
	spf=pass (imf26.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763394345; a=rsa-sha256;
	cv=none;
	b=yxxrNNsLHU4mAfrT1xr+rdK4SzKPHxUZhwoDfeAY7LOFwqbu87LqBWpL3EVdelHQkpEIRZ
	0xU2qx+nOpNIsTbVbftFosC45SLK/giOuEzDCii07f9ntqO/9dJ4iAiRfJIsbfVPRfGtGi
	BChhrUm2cXfSGjpxFwJRQAJoRvBlIMA=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 492A86023D;
	Mon, 17 Nov 2025 15:45:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8E4EC19423;
	Mon, 17 Nov 2025 15:45:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763394345;
	bh=tj/kdr8wlxOfWSKm75R1BNNXJbnbmo771IOdR00jaco=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aLnlna23QmguzEOWiKyg2KqCqmDk+FtWeTCjEBhwlAkH3Yc57igyJLWRG8xWPb45z
	 eOyyfDa6qENLdeCm1yl4vzvFN3/cdATdy5dHYOovQrW0L2NJIdjqVthayQJSQzJeJq
	 b41Ca1Ua+IPapZBX4+v2nhAeBiXnt50QBvs66gYFswEzI4e2jXubzR7OUurh7Fi3Df
	 +FuL7KEgh2j9lUl39isgKIM3Bnb0jRRaL987kSydNoRHRC5/MMlFGAILA8n+TN0e6h
	 N1rhIjIsATNbSkjUsphnZd/x8kSEVUBK7aEoewAssjF6X9FSLi4jj7AXcB57C7oDhM
	 OwQ2lySAGspVg==
From: SeongJae Park <sj@kernel.org>
To: kernel test robot <lkp@intel.com>
Cc: SeongJae Park <sj@kernel.org>,
	oe-kbuild-all@lists.linux.dev,
	Andrew Morton <akpm@linux-foundation.org>,
	Linux Memory Management List <linux-mm@kvack.org>
Subject: Re: [linux-next:master 8868/9360] arch/m68k/include/asm/page.h:20:27: error: lvalue required as unary '&' operand
Date: Mon, 17 Nov 2025 07:45:35 -0800
Message-ID: <20251117154536.11143-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <202511172257.CjElDcRX-lkp@intel.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: C40EC140018
X-Stat-Signature: ogdp4d6g3ss6jogdzwcoc43mb9fh7jrz
X-Rspam-User: 
X-HE-Tag: 1763394345-880148
X-HE-Meta: U2FsdGVkX19WUy3DQfbi2B3FF0uEmXxm9qgT/JxGBHLPx9J+aFBAEv1jFI0kY2KKv7MVdnGcPyR3jLlrtmhy+tpErWvPZI02YWahKpFcziX2nUSragFsPjNkYQIcz8ujtJGP1S7kDT2gPx1KmeSU3FwcgywhIXSg1KwOzoJa7uUrv2KESuQI95grO4XzmHjvg+PhCviN3qVBTonbA82gnY2WggL22/YSOQP/R7mMBXMVOatQnCyupaPSGc6BkVRlu0g6t4AXuR7+2BTq30lk08+I5b3/quuvGgf1qlQ8+PDnEilprqt7TesNag50TKtbkODeBESk/l/l1Oq6SuNq3r6lBzJbb5fnbGaKic3anAsvJGLZqo1HdFn1n/y34udKbNHUk3UIU3dZtC6G4zJ+zmYwy/BH/gqcR2FH7+p6tmcdlFm7Y+mHn4hy60y7lc3u2KcQ2oIjlhp2ImNvdWzIFFUXW74ZtbAbQiROiycNV9LRA/6AM/GNyVV1RHZQB8S84NEF+6Rz9MKLBuKWUWWUEOOTn5InNXjUG1En+mKBDT/cEgVnVBrqz4gNslZCNXggWVb9obdLDZrcyv6aaeU16nfvH3D0dfXghAZSRRwO/dyMswQxvPJm16/bWA398bDAPvtUn+tcYFTJUELp3WdQJENZD5/7/KkPB8e92PIDzaZ1WU1iNJWjlq2BtdaFeldS7XvLUmeYFl30Ph7tNN93zg7fqzgUSnGn8tda6Do6Upws50CBQKGvDnwthMk2jkvFgQSubbiaLpcnIt8fsPvEHtPieiPoBOqP27nfdloADPE7hEnDj5jklAQlhOmwPoPw2rCvqlwkpZQjYe5v7FoIRlXpJN5hudhGpud6Lt0q7pd+dXe0FQVNyHLO6gUfF5RCBWRy0TbOvTpMzdpSHLvRRvHSmsjl1n1Y73fItsDRx9cW+Jh3om7QPDO1S4bA17oKOzOZ+JPLw7l15MdibXP
 3dRWAM7C
 FfUN80R9c8/UY3PTgwQdk7oSzZkvVL78SasYdlBYEgObqKzPBfAXXhrKdO8nWU5vZdmxMkEqAx4ZAm+qwikDniQgBRHfuTwC4C4vd4CxYHlR05QyQumsEadt9GMbNXXvKCMV/VQigoScUkrEI9XFVAqItQsHomTlEERhmV6SIwu6an7maxpvqkQcfGV4f989S8IE4WQ+b1DFX/Bex3nbVxKo2gB4rZuK9/UMam+auntTPUO8v5tMQCuLV25XKKMhcLJITnA+6j19f4xU=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 17 Nov 2025 22:29:37 +0800 kernel test robot <lkp@intel.com> wrote:

> tree:   https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git master
> head:   0c1c7a6a83feaf2cf182c52983ffe330ffb50280
> commit: f54f0efb9d91fa2eee95a7eb29d0051f2176df47 [8868/9360] mm/damon/vaddr: cleanup using pmd_trans_huge_lock()
> config: m68k-allmodconfig (https://download.01.org/0day-ci/archive/20251117/202511172257.CjElDcRX-lkp@intel.com/config)
> compiler: m68k-linux-gcc (GCC) 15.1.0
> reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20251117/202511172257.CjElDcRX-lkp@intel.com/reproduce)
> 
> If you fix the issue in a separate patch/commit (i.e. not just a new version of
> the same patch/commit), kindly add following tags
> | Reported-by: kernel test robot <lkp@intel.com>
> | Closes: https://lore.kernel.org/oe-kbuild-all/202511172257.CjElDcRX-lkp@intel.com/
> 
> All errors (new ones prefixed by >>):
> 
>    In file included from arch/m68k/include/asm/thread_info.h:6,
>                     from include/linux/thread_info.h:60,
>                     from include/asm-generic/preempt.h:5,
>                     from ./arch/m68k/include/generated/asm/preempt.h:1,
>                     from include/linux/preempt.h:79,
>                     from include/linux/spinlock.h:56,
>                     from include/linux/wait.h:9,
>                     from include/linux/wait_bit.h:8,
>                     from include/linux/fs.h:7,
>                     from include/linux/highmem.h:5,
>                     from mm/damon/vaddr.c:10:
>    mm/damon/vaddr.c: In function 'damon_mkold_pmd_entry':
> >> arch/m68k/include/asm/page.h:20:27: error: lvalue required as unary '&' operand
>       20 | #define pmd_val(x)      ((&x)->pmd)
>          |                           ^
>    arch/m68k/include/asm/motorola_pgtable.h:116:34: note: in expansion of macro 'pmd_val'
>      116 | #define pmd_present(pmd)        (pmd_val(pmd) & _PAGE_TABLE)
>          |                                  ^~~~~~~
>    mm/damon/vaddr.c:314:21: note: in expansion of macro 'pmd_present'
>      314 |                 if (pmd_present(pmdp_get(pmd)))
>          |                     ^~~~~~~~~~~

Thank you for the report!  I just sent a fix:
https://lore.kernel.org/20251117154415.11041-1-sj@kernel.org


Thanks,
SJ

[...]


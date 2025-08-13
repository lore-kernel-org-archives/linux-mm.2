Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 21234C87FCF
	for <linux-mm@archiver.kernel.org>; Wed, 13 Aug 2025 13:46:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B230290007B; Wed, 13 Aug 2025 09:46:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AFAE4900044; Wed, 13 Aug 2025 09:46:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A37C690007B; Wed, 13 Aug 2025 09:46:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 93ADD900044
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 09:46:02 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 3E1781A0275
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 13:46:02 +0000 (UTC)
X-FDA: 83771857764.23.399B9CE
Received: from submarine.notk.org (submarine.notk.org [62.210.214.84])
	by imf04.hostedemail.com (Postfix) with ESMTP id ADF3D40004
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 13:45:57 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=codewreck.org header.s=2 header.b=iVDqdWfO;
	dmarc=pass (policy=none) header.from=codewreck.org;
	spf=pass (imf04.hostedemail.com: domain of asmadeus@codewreck.org designates 62.210.214.84 as permitted sender) smtp.mailfrom=asmadeus@codewreck.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755092760; a=rsa-sha256;
	cv=none;
	b=BuB9QiGRcLytqv8Z7RSChAsWSTc1N/inhlf4vU0+wXoShEhmTR7M4H8p+9IZBd3CSYrLxf
	aIe72WIb8IkoW4BiU4GwNnzrQyxyJVbR9sal/v8on2/wCzNXqMx9PiRCn7U/mQmGUjQPD1
	KomCYmDihDTVOesf8lM6mrUHX4BNjnQ=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=codewreck.org header.s=2 header.b=iVDqdWfO;
	dmarc=pass (policy=none) header.from=codewreck.org;
	spf=pass (imf04.hostedemail.com: domain of asmadeus@codewreck.org designates 62.210.214.84 as permitted sender) smtp.mailfrom=asmadeus@codewreck.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755092760;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=O7DIiSFTU0d+SOR8smmh+GVaLhshEu060AgzuYvrVMU=;
	b=fs2slxG5/PZ7eNP8Dh9EMr72exYLpWRaPOPtX4vdCNvVhwamsXGkL6YOzMcs4dLibpCN8c
	9HKhD/2AjO6k6JG3wYW3iBvlTdWyrdzNF6IDxncReNf3SeY+6QzyGIE9DIHiO4rki36UjY
	+/wOo8iUFdwzFKcaJ3kpdJNqOaw/7+Q=
Received: from gaia.codewreck.org (localhost [127.0.0.1])
	by submarine.notk.org (Postfix) with ESMTPS id 67C9814C2D3;
	Wed, 13 Aug 2025 15:45:50 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=codewreck.org;
	s=2; t=1755092755;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=O7DIiSFTU0d+SOR8smmh+GVaLhshEu060AgzuYvrVMU=;
	b=iVDqdWfOqfC7zGw5pMTbF0uOkQf840TCcqccC6MfX+jhl/kiESHTstDOEoMxRS/nUQ9Ds6
	MEBHYWhy9RuQ9+cBA7nglc0sbtNAHjYVZFMvMLj68pFX5tUfEPka2mGiIJnWGOiM4o41Ev
	RXYM4F8f9Vf8HclTLyjFnK9m7Xpd5+U3HFc6PF7bxgoB9V92C8LJVZzsDiEyLF6qf91di+
	jAMaVx8cMTp864nf7WcPFtLDEap6afRs5PkVVA+IFVsk+0LOIdoAJW+vqTSf9bez9wh6Sq
	RbmWS4DMcXMNdHulvj+iLRTjLlw3/C0a/tirBD8qwJsBJfG6dkgbK2ZK54YhbA==
Received: from localhost (gaia.codewreck.org [local])
	by gaia.codewreck.org (OpenSMTPD) with ESMTPA id 8a7ce430;
	Wed, 13 Aug 2025 13:45:48 +0000 (UTC)
Date: Wed, 13 Aug 2025 22:45:33 +0900
From: Dominique Martinet <asmadeus@codewreck.org>
To: Andy Shevchenko <andriy.shevchenko@intel.com>
Cc: Nathan Chancellor <nathan@kernel.org>,
	kernel test robot <lkp@intel.com>,
	Dominique Martinet via B4 Relay <devnull+asmadeus.codewreck.org@kernel.org>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Christian Brauner <brauner@kernel.org>,
	David Howells <dhowells@redhat.com>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Andrew Morton <akpm@linux-foundation.org>, llvm@lists.linux.dev,
	oe-kbuild-all@lists.linux.dev,
	Linux Memory Management List <linux-mm@kvack.org>,
	Maximilian Bosch <maximilian@mbosch.me>,
	Ryan Lahfa <ryan@lahfa.xyz>, Christian Theune <ct@flyingcircus.io>,
	Arnout Engelen <arnout@bzzt.net>, linux-kernel@vger.kernel.org,
	linux-block@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	stable@vger.kernel.org
Subject: Re: [PATCH 1/2] iov_iter: iterate_folioq: fix handling of offset >=
 folio size
Message-ID: <aJyW_QNI8vIdr03O@codewreck.org>
References: <20250811-iot_iter_folio-v1-1-d9c223adf93c@codewreck.org>
 <202508120250.Eooq2ydr-lkp@intel.com>
 <20250813051633.GA3895812@ax162>
 <aJwj4dQ3b599qKHn@codewreck.org>
 <aJyVfWKX2eSMsfrb@black.igk.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <aJyVfWKX2eSMsfrb@black.igk.intel.com>
X-Stat-Signature: cgp8mmk3rqckq1zkz7o71wkgpu4otyat
X-Rspam-User: 
X-Rspamd-Queue-Id: ADF3D40004
X-Rspamd-Server: rspam02
X-HE-Tag: 1755092757-148754
X-HE-Meta: U2FsdGVkX1/N7sVfjDOSu4bRgojwgE5hniz0M9dkh0D5q3wxh+hbEtnvQ90z4eGmZtFtkAWOAJWxZsrqTeecCyEeV2cI6+HgHYGCaqgFIv4ED6Bf9dQhbH8WAsuY107SGBSDh1bSOX6fkC2hCWfzoM2mQJwL8xILzzhALd/IWZog7bEUpNSWO/lpU+ikarXXA+0Y4ypWezAGlcWfoNHEqcjO4z3eRVEttXMSS3xg8UAcYc1RAi/CcSwHuyyh5MfYIub+mThVzyslBJr0UUyXhPRSc8yFhSLMf9EklYOWj4cWGu4NK2Hk/kDStcrZjrYc2JNHRD3evjn/eZ3IoDVvSzjB3ONn3pvgbs2iQn6rUoIrxF+u41wdGCcgyH9bK5r6IAPP2MS8IQs+F/wGXxhW9uxZftBwDe58wothXf5JbqCXwLvEdAjh72ZzENxelCxlHcGsVtB/LgjpwCzihhERjt/T5qsPxytghENFbjsLa+t3BTOZVL1EMg86N9bG9Go7oyse95EAELgZursmvZgR/hTutjIDr1eiHJD8fQP4w/utmoWXU+H5DAyMA1sscvdQkMF9ypZTZpygexmld9xsb8onv3BXJROVMUB+5vdCEFv/Y8CyOSFABnKdpb2jA5o2uuq4IS9wYKrtrIb/luZGWOF8WA5w6z4mPp/AFAJYdVF/XIrQ9w8s2iRpyTuILYbAKhcA3lIFWvo538IaRlSFLPaD11iXLfm+ZFR2Sm4KedgVDecb5vf+rwVsWJMAlFW1vWLoDbeTGa5sIS87mR9boAKas5ite4InZWXcYkOkcdHwhQTAxpHQjtBLl8RiLQ2mvzeTDRvVChMUoeknsl3OP7BChcz6E8IffrcD/zn8xgc0bZWccSOz/oDwlWDGMhEEbQJJxzc83/7qXt83P3kIBVjvhrEW2cW7t4xD1KhOh8a4+evPQJ/jExtSP4yAfLssVOuEuaM7KRk7w7xjkj2
 RyjbB7Vo
 p0jRTP+YKaLorAQiQPTUwpU1QAK0VSAMMVYKMoDqzfOj/9J8tGdEFqFvAiPr64Fm1dd5ED5FTJnhzIEypXKVIO9mOh4C89db3JerJpW7rUMfbknrAwmGMLCGJHxOHJzCE5aGSdQuNMg4A68tthQ36TH67NswmQVAAA4beSxkZCEc4Lc7v6jYfH0OLHHziGt0u6f4g1vFW/hlW1hPYfhfyeWhk4W5gr33h2SIyXt9Bh7Ufz13HFESARXFy4HHTVhFSaT8NL2igrmfxnZxr6IlIV1/Sn7dlgTR9qavpRBbUIsOvLHV7bH6js+0LAA1m+NNN0wY3CsXaxTGYR9DngMD6ppYI40W+HDaDw7EvhuDdpzlaaCAaq0EbFCV0/yHCilwYTN+AG0h3NCWejO1Ay6NYcJp2kesFWVFrGdUVH1tWISQTvyc=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Andy Shevchenko wrote on Wed, Aug 13, 2025 at 03:39:09PM +0200:
> > I assume Andrew will pick it up eventually?
> 
> I hope this to happen sooner as it broke my builds too (I always do now `make W=1`
> and suggest all developers should follow).

I actually test with W=1 too, but somehow this warning doesn't show up
in my build, I'm not quite sure why :/
(even if I try clang like the test robot... But there's plenty of
other warnings all around everywhere else, so I agree this is all way
too manual)

Anyway, sorry about it...
-- 
Dominique


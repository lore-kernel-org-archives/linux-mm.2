Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 32F66606A31B
	for <linux-mm@archiver.kernel.org>; Thu,  5 Nov 2026 11:50:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=hOhJJ17f
Received: by kanga.kvack.org (Postfix)
	id 56EA36B05B0; Thu,  5 Nov 2026 06:50:00 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 50A296B05B2; Thu,  5 Nov 2026 06:50:00 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 40E786B05B4; Thu,  5 Nov 2026 06:50:00 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 185B56B05B0
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 06:50:00 -0500 (EST)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id A28C8160723
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 11:49:59 +0000 (UTC)
X-FDA: 85400896518.06.E6230D2
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf29.hostedemail.com (Postfix) with ESMTP id 9B3B112000C
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 11:49:57 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=hOhJJ17f;
	spf=pass (imf29.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793879397;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VImrv8FOkQBPZjLUsdaZmiq4Cy9sbelPnrfcMNk1WI0=;
	b=Qg5XmFJPhHlkxvq2nf0Z+OrhHTMNlykh+gxVLDPsLjWMI+CJX0H0ajxPlNdfAaGFtWTo5/
	+7dL2Qrk0Lt9g6i5aFapBvz4Ofz6ANxmfD8TwEveSZa9U46PBSRaOiqcbcyvt+t+4L6j/s
	vVsX7608v/TP7tlNXkkvTQ+b5FEA2SY=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=hOhJJ17f;
	spf=pass (imf29.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793879397;
	b=jVZwKHFzPw5LKi0Mt/9Lg2lyzZxHpXvicezj9q8049xxxRzRqkFkcxtg03/0Qtk8EOu6o/
	ZTPWVyzU2wfXcOdayZoiSObuDmXg/GLItgTbVTP96k1hdPN1kF5vgarxHAZN7zn5OzYeP2
	Wt03klPYBDGjhcv5PupLkjWcqQT3NHA=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id CA22443702;
	Thu,  5 Nov 2026 11:49:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA9E71F00919;
	Thu,  5 Nov 2026 11:49:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793879396;
	bh=VImrv8FOkQBPZjLUsdaZmiq4Cy9sbelPnrfcMNk1WI0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=hOhJJ17fnaoVYndtIuekxR8R6KO9FBbg6IMn7mFLdmS1AHggfitt7+Nvrcw1ZoLS4
	 Q65DYL5m5guEYklW1MnM8sShCjbOu/AVXCRkeAq0oWJzYgdSjMYQSoPJ96z4njASSx
	 g0B6PgBhVRGiD/wpmrvUwA1kR0egiK6rTVJvWHCbIph7lJVlgjaYza1OLGN6+QLjV7
	 eB+WAtu5GOmRtEtNDB3x5vun45DMPw9GgdaKtuLzUTNEVCYpObK5jCJwkxgaleD938
	 anISYi/vi9jKckwLJA6u6BOWD2I3Hy1tpQyEN3C1GYWIOm7+okR8USjxmUUyIzI++d
	 OX/zTf+vcj9eQ==
Received: from phl-compute-12.internal (phl-compute-12.internal [10.202.2.52])
	by mailfauth.ams.internal (Postfix) with ESMTP id 8419B198003A;
	Thu,  5 Nov 2026 06:49:51 -0500 (EST)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-12.internal (MEProxy); Thu, 05 Nov 2026 06:49:54 -0500
X-ME-Sender: <xms:Xm3saiAdn_cZh3JtSZrh99WhVttXV31FNCr4PBP-ecHfjESLFAyeLw>
    <xme:Xm3saopxSAetXRYpzwVNDP-QRy3P_jPcWB7JsYsS16lNph1qMbflVqH7SrgNofevG
    o9yA6mIHliJgXjQtkKKvElnY8KcnuLkCCcGHC9u_cgftVDxmYe4qQw>
X-ME-Received: <xmr:Xm3sau1vZ0S9_M5aNLCqdNT5Lq-NPQ05c7vA75rSiwVOkLoUv75Ra_nvijk>
X-ME-Proxy-Cause: dmFkZTFaQBfUFVPMP8xrPqBpPtUnYXtbN3LRpp/oxJl/b1RmZnSSZHsU20CPxF1I64DXUJ
    SNLa91ZNNqfrtHA9eDebWdeJ3pYuxgu/qVSEnCct1TlKIRlJn3GcjTHnnT+sn/oHMnbGM1
    92CZwyL88cWl12ru+oFk3aGPCVOPyvG/BBaSa3nzQ0qnYXC+EDwfMTbKFpKaz7lB8mwBSr
    tjdeBaZoIb3fDCkky6tsMipkpHqSdW7Zzs1aYBXDycZrYrz694hViPMgw3pBshbYyrko2L
    Ohq3WEDa90dSPdCt1Zj6L7kr+Qhl/jG4fQDMc8x/v4q4YqTy9IFSVobK5sWmdPu2MF5qpt
    EjNpg3PBFTo3XO9RRKHjGaWEQXb5hxpkiWD5hurwcftjcBKJ3dF7hkJYtdSdF1MXJTQGtI
    U1DxCDZulyaz+XBHLq20bFdQhQbcfFjWNS+nuDxFo8TUM/HN7akP5A3EdHg18A8AJQwdQv
    PWAvcY13nCclZdQ9XC+ee25WbgDrMiKU8N3e64SqzkgOYAmYJbKJAAlcOZK0GXdOgKQBNC
    ul1laNs1D8hTZTkx8NJuJzTLRCqehRluIahZmS7tTps7YtiVuhHvREip5GILZ3mwcCpJtr
    UaCfBsMS72oJMuFm65lhi0wXsXbtCojAj7PUM7Q/sN338f1Y+5/vcc2kDuzQ
X-ME-Proxy: <xmx:X23sav36-BZf_GdwZf1t908PDlsbnfG7hQS6Im0OKWe1m08mb8IFBA>
    <xmx:X23sarciPpe7lJ_W_T8XXfpsZ5Dz4Nickzk89PD9OSK30i_0X_RguQ>
    <xmx:X23sar4mO8DRWKgjo6flEr1hmYHrDo14rxHdRIiC1TMqq78q9bRNlA>
    <xmx:X23saoi18BpZHjKIwprPReemBZ9lHVBBrXRlSF6c1dUmGIYVXOylvQ>
    <xmx:X23satrGkUFjjpRHQtDWiikpbfIcGWhCKBGjUS-v73FO4Hw4LlhPATus>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 5 Nov 2026 06:49:50 -0500 (EST)
Date: Thu, 5 Nov 2026 11:49:49 +0000
From: Kiryl Shutsemau <kas@kernel.org>
To: Sasha Levin <sashal@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Zi Yan <ziy@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Lorenzo Stoakes <ljs@kernel.org>, 
	"Liam R . Howlett" <liam@infradead.org>, Nico Pache <nico.pache@linux.dev>, 
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>, 
	Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>, Shuah Khan <shuah@kernel.org>, 
	linux-mm@kvack.org, linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] selftests/mm: skip split_huge_page_test without the
 split_huge_pages file
Message-ID: <auxtQQ7KsQJK0wkH@thinkstation>
References: <20261105030242.1241448-1-sashal@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261105030242.1241448-1-sashal@kernel.org>
X-Stat-Signature: swke7fhjau5mhywp3z4ai1jpf1k4o6yo
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 9B3B112000C
X-HE-Tag: 1793879397-187403
X-HE-Meta: U2FsdGVkX18KLzkYoyzGHIpSq6ah7PoueQ74lIviQJiqqR/kl/qWELVZpQRfixxaKN9phrr+gCj+Y7AGeuAxRKMeSZ6aB9+KTiWWWsmADCVutKjCi/pKUPHirD2XmjarjQxipYmfL0jy/yj6oCnlLZtIuJW9Fz99iJY3Fnb/XncKvmI4RaquEBSdjTaVapGYXZ47yyp4I6LsR1/hTREGCYamlKvL22eEE0avIPoMUPnLcV+GiMeqQZMAfXJbPI8qLyvB3XZwolSEjSI95EiwJtAJcaIL4RB3uCKgIiwniVf+KLOa53/d4t5GzY1viGHh50mt2wPU4jVATvWQeAPUS6bt80s6WVR4ihVYYuzyaCo8LkH9I0qSgsGQsaw2KEAg86bGF8qXIrOL86cz8ipwx+xGhPHJDZ32ZaFPw3zr3EO54LAXNIzV7pvTolccSljvjVd5pZq8xUUq/Vo4c2+uvPNUCQS4gM2UQgO+FtmjZ1t7N66X0NkZhJ0W5V5X0HaZywi6xoJYhUKES2JU/sFxn1X1gQ/uDbDZL/KjgGVB/yf9Jl93lHZSVci2DpCulGOWXqhRM4trwQWfdudZHxwlBJSvIKWGSxZ1OsDeNHQbC7gXMG18DwGOn6G4LR3AG8ftff4s5h2c/qsBOuMTwfs/VBIXEdQi+VfR+vibWmErlQNrdNdCTEkkY3oamZ51M4LCpP4UfVGM2Y5gxV0syybcoiTa5jj7waEAkCk0TiOQ9V7n4RVBX9TekTnAe26cUmHj9ONDOOJFQ/Zysdl0CrPRw5aZmVY7iHI0X5FRyGFL16hy/mVrmLG8bfAAmWquQDgCZEIzef8m8PYzpYpphne4Y+6n8ScTo/Gv2ZAZRquFPm6Myxz1AlAky+ErxFcqkfMo9/eH91YWOiz5MpVd18bk8PAWDLXPdL7ysz5gTMLDwm+aEDTeDVGASEtqED0TLMYXg90mRhcPZIQ0LC4T3sa
 KLIkBtFy
 nLIaaPNXog95Of7qJKxXO6JC790Q27Ogc4UIgz5c6VG4cL9zQk0LxZH65tOZ3wTtTpq5eon0vBCG6vKvcWjVmj0cs7R9N7/QsIcYMPkUbP2D0T1UIVP4IK49Xx32iT9LgZynyMj/lgMYqmJkj1zffJHs27cxcG9RsVEfNGfwak8Tl+rSpXPzffPjcVNmRNtx/YvpcsBZxAIXccH61PZLHCynM4rguhGxGMEi0p5jwDDv4ZDvPA39RCRD9VQlhxLHVzp7s6R38ibCTyb1597Ef/GH+AHsMGE009aZsSwQE+LmOZLFcdlOCXzDJNqTpJl4bFuQPhKzGgltLJlK0sdKobzpBFOnOlKY2j98H
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, Nov 04, 2026 at 10:02:42PM -0500, Sasha Levin wrote:
> Every case in split_huge_page_test goes through
> /sys/kernel/debug/split_huge_pages. When that file does not exist,
> because debugfs is not mounted or the kernel has no CONFIG_DEBUG_FS, the
> first write bails out of the whole test and it is reported as a failure:
> 
>   Bail out! write_file(/sys/kernel/debug/split_huge_pages): No such file or directory
> 
> Skip the test in that case.
> 
> Fixes: fa6c02315f74 ("mm: huge_memory: a new debugfs interface for splitting THP tests")
> Signed-off-by: Sasha Levin <sashal@kernel.org>

Acked-by: Kiryl Shutsemau (Meta) <kas@kernel.org>

-- 
  Kiryl Shutsemau / Kirill A. Shutemov


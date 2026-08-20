Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 79EDDC5DF87
	for <linux-mm@archiver.kernel.org>; Thu, 20 Aug 2026 13:27:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 674A66B0095; Thu, 20 Aug 2026 09:27:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 64CE46B00A3; Thu, 20 Aug 2026 09:27:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5624E6B00A9; Thu, 20 Aug 2026 09:27:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 329DC6B0095
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 09:27:33 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id C34751C025A
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 13:27:32 +0000 (UTC)
X-FDA: 85121724744.16.7538EB0
Received: from fhigh-a8-smtp.messagingengine.com (fhigh-a8-smtp.messagingengine.com [103.168.172.159])
	by imf20.hostedemail.com (Postfix) with ESMTP id D291F1C000C
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 13:27:30 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm1 header.b="E ODRIw3";
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b=d4z0BTyc;
	spf=pass (imf20.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.159 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787232450;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4Ozy3CczgOizZ3ooFCppKIjSA7fkYEtdaAuwRLg7kbU=;
	b=7jDBus6Z3SfEojehpBtsqySSf2nkD0AD+AS1OGL05nOil0CdSvqt/fxb3mjuCdGPoCwK/8
	BFvLXZbF2LTnCs4c/H4ouWaHKCa5P53d86IkHrFKCtJdDK3LOFX0mTdp/wrT0Igb3Bt4tT
	qsSv9GiRuWMS1KpVTd0q1FEAhwaK1/E=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm1 header.b="E ODRIw3";
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b=d4z0BTyc;
	spf=pass (imf20.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.159 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787232450;
	b=b+Xj3xHMxNuUIgp4ScktF7LlMkzdYcUJo/os+BEEp5ydkWhmt9AaCQl2QYPGfAMu5BsPW2
	vJeUEX/Ko3sfXDC0ny22vWQUlfZQuZb+qK0eKDQYU5hWn90MoUcRoFgXpAuWRPCnkxAwlI
	joyMFej6W2zc3LTfi8OyftjsGJs3w4U=
Received: from phl-compute-10.internal (phl-compute-10.internal [10.202.2.50])
	by mailfhigh.phl.internal (Postfix) with ESMTP id 5DB0914000F9;
	Thu, 20 Aug 2026 09:27:30 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-10.internal (MEProxy); Thu, 20 Aug 2026 09:27:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-type:content-type:date:date:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm1; t=1787232450; x=
	1787318850; bh=4Ozy3CczgOizZ3ooFCppKIjSA7fkYEtdaAuwRLg7kbU=; b=E
	ODRIw3P2o1acvpUAqB72OM7hK828HA4AEGL7JzwwmMOfO/ncvj6zaV25GHFUOXAd
	4alwM0WIJtrx/07sWpU0q9o0MlmoS516ZXhz5w0/TVVZV+h4s0z76t+RNZvQiA0a
	Ybqu/tJyb9RbnTHVhInmsdmjhPp1t5S3m7SFdi6LwCNGHyJO+wlfgflYvI1skpEG
	MwYd1YTdsRKAPowaxhTozYRGj1xkWy2ot/9mbsW9zfyfpT7evJQNWY8Kc36dzrG4
	X8rx28meskatUlgr9Dqrr/mOk3o0msUdGjuwIIqlzQhbQjGmnY+uw0H4U4Pxv8uy
	D2crUL7NA7JlIknhkw+Iw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=
	1787232450; x=1787318850; bh=4Ozy3CczgOizZ3ooFCppKIjSA7fkYEtdaAu
	wRLg7kbU=; b=d4z0BTycjChykZU1niYaj7gAn+TEb7PaorwazbN5uNjSN1Gklyz
	0bGJt0Kf6GrgD4StCK1QcI5v2cElqeLub/EdavWJJ+D0hTgfvOrCy67Z1G2+j31z
	d1euHASEcrF51Rlg8JkVcns9yvV5j6cwXH9nxjGlV6JUrzr5JN1R+De+iRqLRabn
	+2Qgt1/U3zwpAkFM9Fbut0v14Dkx/vKwxWrus7omgNVhSgp25LF8M9wMZyXG4Qz4
	bIVNSpCu87Z1RwXte9hLE611iQMYocKWW6CF/1JkQ1cXI5QDxQ6vBimhzAJlLuT7
	y1b7IfVWnzAgx1+Wy6oA4Sp+wwp3PXCbDCw==
X-ME-Sender: <xms:wQCHasFuB8LJ9TeH7QvEB3gn-XxmvGbmB7FDrkBxE5DvIeHl3ER_zw>
    <xme:wQCHaop8KbndauSCo9fxeOQHmHkV4fqeVRHg_B7zGMUmxX9DTsptntwkiAQkIMjpJ
    IAxCZY7vexw6rutRJQYXyGTsjWd_uTOOyP3VzLJkHyiL_r_d7co_sGW>
X-ME-Received: <xmr:wQCHaqOs_aXMJZKFYhML8XvvB3xnXVf-qSaaJVuCzk4umQEgTkIJ9ksI_r4>
X-ME-Proxy-Cause: dmFkZTEoKWm6bbmmfKi8x+K64Bxlg2CB2ySvnBwPrS1jXCXrk+eT4gF4UsCKBI5mmn6nm6
    60dm5WiLU3C4ooe5Pk2R042r9JhGRWPI4U8qW/2GOICA1YTtX5yENYuOuFlIecdJVuWR/w
    5JGXSbmyBZhjSNoTK2zFoJKBzMljg4Jc9hIgPbXyLQw7jrbietBBxSHh1AiAfo1n1bvrLW
    qn8jrbWy3WhtmSFEgBwZdQxOxJOXdzvw78mkoULr1Y6Q5l0wDkEO1Kdj+eWSSV6ljPRsZA
    CL5JMXuJcVo7h0NaIjspEMlNGtoTil/pue8HDKYy5THLX0778c/3xdRsjTjEuyjpul/QLt
    aF4PiCfx1WRJe4eFQAex2bzNi43lzQxmOeRwqDlQnAMimRgm0BpmnF4jgtVcZL+4xxeyYh
    tXBXiCYKLmv5WaqY5rlD2ICC3W6go5soIqOIegCyG6+m62SVB2j3G4tTKLEdrEX+MynZiF
    6/cAoU3xCRTJipaFsMy+2toLPoljjNDoqIpl+j3ouLTC5UgptPnjYOunOKRRno9OLqCyHk
    x2WY6lMCRD+gt8AIe28D55YhWoGNr2WLc7Ybsq8nQjIJQvL7M2ckIEU2Du+HOBNFtBj2yf
    WWAbNidtxuzP/HJSAAX+Bz8r/0LtsO7Jn68I2EmckseVmg6Ki4jxx5c3AJGg
X-ME-Proxy: <xmx:wQCHakc9MEuLFfvEzNeb5Pr9JuA039uguEI6PYwYrwEAEPMNl2TqFA>
    <xmx:wQCHaoQk4LldvSf0eRdTXHa74QTPOGcpuby8QszIaaprPncX9NpdDA>
    <xmx:wQCHajoqwx894LBwB-ltGDxUGmE992BMq71Jlys4T8xbbx4MtpZpow>
    <xmx:wQCHau6KVsNnv_pNePY2FqvioCzKQBg-lFQW5Wnhb6PWBbgI_n-cKQ>
    <xmx:wgCHamfXySBPmm6VzFXjELx3tJldPDBMdhRwZ9pl45wgFfqiBQ1nlqHs>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 20 Aug 2026 09:27:29 -0400 (EDT)
Date: Thu, 20 Aug 2026 14:27:27 +0100
From: Kiryl Shutsemau <kirill@shutemov.name>
To: Qi Xi <xiqi2@huawei.com>
Cc: akpm@linux-foundation.org, vbabka@kernel.org, longli@microsoft.com, 
	kotaranov@microsoft.com, jan.kiszka@siemens.com, kbingham@kernel.org, surenb@google.com, 
	mhocko@suse.com, brendan.jackman@linux.dev, hannes@cmpxchg.org, ziy@nvidia.com, 
	linux-hyperv@vger.kernel.org, linux-rdma@vger.kernel.org, netdev@vger.kernel.org, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, sunnanyong@huawei.com, 
	wangkefeng.wang@huawei.com
Subject: Re: [PATCH] mm: drop stale MAX_ORDER references
Message-ID: <aocAePwuxr4te2jG@thinkstation>
References: <20260818122408.4182417-1-xiqi2@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260818122408.4182417-1-xiqi2@huawei.com>
X-Stat-Signature: s5dpfrqz559ynektug1y6888ft6ezb99
X-Rspamd-Queue-Id: D291F1C000C
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1787232450-190090
X-HE-Meta: U2FsdGVkX192mEB/4BGpuWWjKZYuRW4NePJgLVxhOcX1CcjsFDrWgnxxZp+t0qIgN1kKB61CAS+VrisdOKsrPjnGAvujLQ4+fdurq4vJnLDFikXY3zfr50DN0mogjB/ED9RyHg9M5c6y+B45kvD0tV1sygaPuPWaRI620zNdUsXxdRKgZwZGFHKlOJ191JkUMUlvs5JWNgTI9QykoyUurte/rUTeX/2Sbn2ttIONagJggG9mpb4R3RTwVSFwyZQ7pAJMJHXpxUH/8i4fO7r2H1/YLwxg/MTDkhs3ip1SsGyR9W2Q4AOsXcC7WkM8UVeG9TU15cGFx6u3rtcgjpOcV8nS30No4yt+KAHACdGamzhYdZOOlzRZ7PTwNjsU+mdYn1xGJcLF3Io7/azk/0VNYvh5hbcGx4qlx0+z9OMFnrnNeh/S/j+2Se3iIjt54+79KtPkusNxOTsLeBh5urPUyIE6ocKpAyiQ0IU5V8fjUkiMbYvrYxMtADSuFN9AKL6ZPTFK/dba0zlg5LDSj1t3tWHjA2zyDiKwo//SkoJccAEfVf5z4lFFL971ftHiI1pMoqDjNsV8mQCvauxmve3gnBJyXWx0o/zD3bGpy2dtkoxV4bP2XXuhltIoNa7XWPhPgUrNy17MwhPQGrSg/1cCBFTK8B5J1+yBoTYbCwPY6RVx24M83/exLVPhAqU2LWMA1L5EGt+8AfQL1bBtcyOdwLxbjzjTTMRjkH17DZgNMSENC16tLLztNg/0H5JDvWs/pyxfLmJ/VG8xy/S77NZyOYQMD2kxlBiE48jzvHvJ9jO/LyaqmI6Sl6THxOXz2A2UE2iG27/J2CPhdUT7H/WQd0HBd+u6bdzhgZeOVac9msvwk+hVlnTM5RCS+sUSBMWVZKg9Uvysp1G87gJ71wj0WbUohFjQC62QU34cPpPmZhZNTP+vubQddTqwnzMiieBUppZxfVnWLYKiTA8vEMn
 thM7NTD8
 p6of5NWRi55W4BuEy9FeciTAUy5WUGF8yfgdQT74mHLonScL1hB9qHbow0+zpfqRN3Uvyue3r1yAVZ+Yp7ABNqhKZBRN/cAOdehV3UPr2gdrU54nlJy7DFAhuV8GAEHqEgZKkgU0yXrGnRdsUag0lghpgX2s3eqHOsRQP1HIF1N5ptnZGdI5K6gMlovjsbhbhenhhFE+BDSTaLKBJI3LnIKEZX9BiIgVo+lgZWGSdzAzytihosNQVbu2B9kTOdsxzSgNJFl6/wJH1DdkEtdIxfkamryJbcpEREZa7AfiaKqA8INXhC0spf6Juual/OzRxxAjDmFZ3qkN2CqjTRLISS65J5p0+CkXqb075DCxTYXs4k8nQ8isgQ5vNgaCV/vQClZwgeDeRzXUKaVO3XFIQo/scMKFSrJy7Ye36yVgcNU9EuysQqXPES6cj8hPL7ISZyXawloNGc/DqTHMH9o6j0SbC8C+0k6jXGoMbzAcn5oMe/rYW+ZRaIMwfpjdX61z9502++QLAe9VFLfc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Aug 18, 2026 at 08:24:08PM +0800, Qi Xi wrote:
> The treewide rename in commit 5e0a760b4441 ("mm, treewide: rename
> MAX_ORDER to MAX_PAGE_ORDER") left a few spots still using the old
> name:
> 
>   - two comments in include/net/mana/mana.h and mm/page_alloc.c;
>   - the gdb helper scripts/gdb/linux/mm.py, where self.MAX_ORDER is
>     a local mirror of the kernel's MAX_ORDER define.
> 
> Rename the leftover instances to MAX_PAGE_ORDER so the tree is
> consistent.
> 
> No functional changes.
> 
> Signed-off-by: Qi Xi <xiqi2@huawei.com>
> ---
>  include/net/mana/mana.h | 4 ++--
>  mm/page_alloc.c         | 2 +-
>  scripts/gdb/linux/mm.py | 8 ++++----
>  3 files changed, 7 insertions(+), 7 deletions(-)
> 
> diff --git a/include/net/mana/mana.h b/include/net/mana/mana.h
> index 04acb6791dbd..1d5bed71d6a7 100644
> --- a/include/net/mana/mana.h
> +++ b/include/net/mana/mana.h
> @@ -40,8 +40,8 @@ enum TRI_STATE {
>  #define COMP_ENTRY_SIZE 64
>  
>  /* This Max value for RX buffers is derived from __alloc_page()'s max page
> - * allocation calculation. It allows maximum 2^(MAX_ORDER -1) pages. RX buffer
> - * size beyond this value gets rejected by __alloc_page() call.
> + * allocation calculation. It allows maximum 2^(MAX_PAGE_ORDER -1) pages. RX

Should it reference MAX_ORDER_NR_PAGES instead?

> + * buffer size beyond this value gets rejected by __alloc_page() call.
>   */
>  #define MAX_RX_BUFFERS_PER_QUEUE 8192
>  #define DEF_RX_BUFFERS_PER_QUEUE 1024

-- 
  Kiryl Shutsemau / Kirill A. Shutemov


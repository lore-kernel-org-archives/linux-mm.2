Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E5774F41986
	for <linux-mm@archiver.kernel.org>; Wed, 15 Apr 2026 10:05:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 59C716B0099; Wed, 15 Apr 2026 06:05:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 574C26B009D; Wed, 15 Apr 2026 06:05:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4C9026B009E; Wed, 15 Apr 2026 06:05:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 3D2C76B0099
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 06:05:34 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id B67611B81CC
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 10:05:33 +0000 (UTC)
X-FDA: 84660358146.15.AE22959
Received: from fout-a5-smtp.messagingengine.com (fout-a5-smtp.messagingengine.com [103.168.172.148])
	by imf10.hostedemail.com (Postfix) with ESMTP id ADDD2C000B
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 10:05:31 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm3 header.b="r MihxMb";
	dkim=pass header.d=messagingengine.com header.s=fm2 header.b=aeRHL9NH;
	spf=pass (imf10.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.148 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776247531; a=rsa-sha256;
	cv=none;
	b=pNQ31Jha8WEnpbXdKrmzTxRe0DJtr377Qddc0Hco/E4STk+d1JFpEOHyjz1VRMGtTpeMY3
	Y58P2Ep3itrU48lMjVTn/Zr6b5GHnsikuGzfASHLEgr65MNFsYw4FhTu6A6oCfxqnvzCAk
	ziXWnU+FhHoWDw84Mx7eK/he6ZysNDk=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776247531;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Gz/2LXU1K8BhzecoWedpHAL3WhAhwdUS9rpTtpz7gUQ=;
	b=rHtUVO+69tz8rKMIB2Dovpwz08Pvj/PvogyG+jV4T4ClSh8yQ8CHltYqI4o74K1qscUnZn
	QnLM+TwRJqF+HbKx5lja9uFwR4bXvtwt7jUbwNjFJvlcKLWLC9NIMtyC1iG8hbwGPyB2Vw
	RhHdlxFmsaMuuzUsvbDIwhzMvkY1QI4=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm3 header.b="r MihxMb";
	dkim=pass header.d=messagingengine.com header.s=fm2 header.b=aeRHL9NH;
	spf=pass (imf10.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.148 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
Received: from phl-compute-05.internal (phl-compute-05.internal [10.202.2.45])
	by mailfout.phl.internal (Postfix) with ESMTP id 183E1EC0468;
	Wed, 15 Apr 2026 06:05:31 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-05.internal (MEProxy); Wed, 15 Apr 2026 06:05:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-type:content-type:date:date:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm3; t=1776247531; x=
	1776333931; bh=Gz/2LXU1K8BhzecoWedpHAL3WhAhwdUS9rpTtpz7gUQ=; b=r
	MihxMbpACz6IajCeWCwHlLQsnD7jNefsYQHWduxFgSQDsSIfL8MCWCvlBEmxZ3wS
	HUUpR1Zqx1z4re8ZqJhd1FLLZ3DQQwVH+7QOiD6uZ/ZIewctG7MY6TMdK2zEf2xu
	k8Lul/1m9Af8k12ooQ/mztCl4elVDlB6XkJtOop/DgK4Eq1llUFBv2xqA62beA3Q
	pEW8TPpR3U8ApJV8aaYmSGMPnujQnRfMO6vOc90fX6RjJBYCXRp8pudgm5kcIoA+
	8EtTtCvzPR+FBcvr/4ERTp4UH40dt8C3sEN+lvFBJanoErAjseHA2S3ZIUi3AlXs
	nS7VUl/CVgiAEdNrVxp9g==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; t=
	1776247531; x=1776333931; bh=Gz/2LXU1K8BhzecoWedpHAL3WhAhwdUS9rp
	Ttpz7gUQ=; b=aeRHL9NHunEMk9W4/cvLQ3p8XcOinFi9Y8oS8+mRouE7JdXm9Vs
	gxFu1jrXco5aWTms3E9BNfcRqpnSJX39se6DYbNZpIJolcx5Gp/Srgot/sQ2xx/t
	Q5aAMlkkOPG1nyDhhWw3HBRbatZ9sU7P3AZZboUg56WuqilFG/NIDmkn+BBxzj8U
	3IKgAi/hps0/iPop0QKkV6ZGva1175TWtfKCj48p/8R7Y4D+OCSUoDtACKUJPARf
	Jfy7wZQYvAfXpMFurUUrvYPLGx2XA9QH3ZvfRbOPopHIYD0wXDxlcnF2FJG2z2S9
	ya02tB7ObCRK40l6LnQTeBxLM9FpqRYTNGQ==
X-ME-Sender: <xms:6mLfaWAc9YdFjHQAGO7gHUs-GlzlHoZP1eNW87__MmlIBF57csJr0Q>
    <xme:6mLfacajXl-iRko3WiIu998OxraCfgWSXdShsu1fPnkaXkiyK6kR2WDv2KXZbo3bD
    NWc9ai9nXevYUYK6FTM14mLF-FvGxmtp35nxygMhVvZE3IcenFRHNC0>
X-ME-Received: <xmr:6mLfaVGGC1r3F-vWXyk1a1er9lfAlmkejm1In5Q0uQmRF7wylZNW_r19GAClLA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefhedrtddtgdegfeejlecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpuffrtefokffrpgfnqfghnecuuegr
    ihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenucfjug
    hrpeffhffvvefukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefmihhrhihlucfu
    hhhuthhsvghmrghuuceokhhirhhilhhlsehshhhuthgvmhhovhdrnhgrmhgvqeenucggtf
    frrghtthgvrhhnpeefteehjeduueejieekteduledvveekfedutdekvddthedtteeiueei
    teejueegtdenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhroh
    hmpehkihhrihhllhesshhhuhhtvghmohhvrdhnrghmvgdpnhgspghrtghpthhtohepvddt
    pdhmohguvgepshhmthhpohhuthdprhgtphhtthhopehmihhnghihuhdrhhgvsehshhhoph
    gvvgdrtghomhdprhgtphhtthhopehlihhnuhigqdhmmheskhhvrggtkhdrohhrghdprhgt
    phhtthhopehlihhnuhigqdhfshguvghvvghlsehvghgvrhdrkhgvrhhnvghlrdhorhhgpd
    hrtghpthhtohephhgrnhhnvghssegtmhhpgigthhhgrdhorhhgpdhrtghpthhtoheptghl
    mhesmhgvthgrrdgtohhmpdhrtghpthhtoheplhhinhhugidqkhgvrhhnvghlsehvghgvrh
    drkhgvrhhnvghlrdhorhhgpdhrtghpthhtohepfihilhhlhiesihhnfhhrrgguvggrugdr
    ohhrghdprhgtphhtthhopegsfhhoshhtvghrsehrvgguhhgrthdrtghomhdprhgtphhtth
    hopegrgigsohgvsehkvghrnhgvlhdrughk
X-ME-Proxy: <xmx:6mLfaYvgsxWcMmu7Mk83CMbexwvnD9rgjgGJN10jNwvGk326lNc6Xg>
    <xmx:6mLfaTI2496G5wsWC-omTnhciKbmRbfnmfmIULHnBX8fiQRcwZu8vQ>
    <xmx:6mLfaeOV4hu3ZyUXPuXlBRoBn3UpLMBOIKZPg-NA6Acp1UgBuCI1Xg>
    <xmx:6mLfaTblMYOaDLEYzjXfg5ndAvYoMJpmU-EApVLpflOtDUquS76rGg>
    <xmx:62LfaYTz-M4YyhDbs3i_K9rNoL1qKzMPN7tEiNE8zwD7h-CXmPsugzRb>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 15 Apr 2026 06:05:28 -0400 (EDT)
Date: Wed, 15 Apr 2026 11:05:21 +0100
From: Kiryl Shutsemau <kirill@shutemov.name>
To: Mingyu He <mingyu.he@shopee.com>
Cc: linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, hannes@cmpxchg.org, 
	clm@meta.com, linux-kernel@vger.kernel.org, willy@infradead.org, 
	bfoster@redhat.com, Jens Axboe <axboe@kernel.dk>, littleswimmingwhale@gmail.com
Subject: Re: [ISSUE] Read performance regression when using RWF_DONTCACHE
 form 8026e49 "mm/filemap: add read support for RWF_DONTCACHE"
Message-ID: <ad9g22IbYJatwptY@thinkstation>
References: <CAAoBcuSK38z5Nh7rGuHDFwpNvtc0W49OZKc1_d1QkCbK_nL7Ew@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAAoBcuSK38z5Nh7rGuHDFwpNvtc0W49OZKc1_d1QkCbK_nL7Ew@mail.gmail.com>
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: ADDD2C000B
X-Stat-Signature: xmc5msd3rqnm3ufzbngn6edaonyng8ak
X-HE-Tag: 1776247531-177907
X-HE-Meta: U2FsdGVkX18qsH2aGQO0BRUwNM44URrtyHB9Zi3GLcMk2IqWTmirvu6YMZfBdn24CanBinuFLbp+ATQGCdRDv7Jo96Sa5yRdgCXQjoRFYTFsrdAut3u7mzXmJ3MkD1bzQBgdmaRmb5T2TWHKAbmDewqOAQqmA+xlpDyv713E96asW5BP3hvwucBRSy/+Z+g+VGn1n1qcM7X8Pq0tbda1fdruUrzkUurvBE00CBSWwrNnGhi959kp/g23bAeNDQQnscMVHkceRi49WeE/+m6E9SjVztSz1k9S+Ak1KuOKQ7qj+yj7am9x5ct8WyKw7Rl32hMJNLHFdXo8Pl4U7lHsIzzynoFnTnIOmpN+PMhxki3Xy2DFL1OS1rEHv/Me3bPLusm3n3SG84Gd31stSXFTYZ0T3XQS6lJBnZxW7Ru9C0ermMHB+AfSTmTLnOIt7LgeVJda92EOBFjS2LcTF2P+VIj0RPAYQ8W95N9+Qfz0mU3cq/zmwGRODianmTmIvIvWl+ZsKsZb5WpXklx2dhwBQT7/gVQUCBuAXLESQOdqJTGzkjiEsI6shI85ngudMI3A2tFVCHcho0/PSZXAp7Q2Hz+P2R+sJ/J2tvUPNL5qcOP6ppvJ1M3P0YyR++uYZvluKyPFNOGem2C8CXdXbg2GvyY1eqwndL439HYjyXFQ7QZy0zyZvskibQJWxMp4U5+CnyIRr5Kd1mvuWrdko4r+q8sNvZlcAVyBkhdG0wiq5wP9d5PCRa9hA2XFAdApM2tLlGv29tt/qcoA5abL/9GX7VWo7nOAqoDFcaBOiOEZZ0OjnQ8zsUIwA5TbHhH/0+wcYSlpALwOT7bWsf6cZmp2vniRJb+bbtrh3AlmT5lcD4H2reheLl8jTBPyXRu93q9KFu9bvWelg86XBELccWRXOWrBLY/YeCfF5Lqa9+yj4BFlj7AMIdWEzzlLkT0mifAwdp7P7Ejm1zOVw38gzf6
 l3jpWl6A
 BisuikodsZTtwBAFLwR72JzSCfOg8d0xcWb0G3TgIvwIMjiTmAQrEYtLHzv4e+lMkEqpy6flUut54FgVVd+lw/ivwxcbvima3Lez6pRQxBH202gpsWkTi2NB4DxrsCzgY/kqnD6YNR/19xkMtU1mvzYvLuuTkU/kNLL6EAH4n1yBCRiq5L+Ao8hIPZDKHmoj1DLM1No7r2bi/mO7lAulHPiQAElCeul4HWJ2UoG2yiZICJ8KiDAKlORlhhIs3Ebnoac4Pr7eiF2qTtTQCRf9n1XVelS8aPrCi+5nv0n015l3+eCfqD5cGnoS2XrjJFsMVXLobM+sHI3YhpNdtFWIITudrIEYNQKtuGFvf5e7iXY3+XbKeBqysGMpGg8Tnp2bjdxyceayWqxv60m7BGWn7x4jaFdge7e6lvS6KtZwQ5ecdhE//YonWFN3+MhPLR9LHueRvdFX1X6ze88OLIo2HkLyE+I25JoV9okc6oKGi/hq2AgM6PYkhlmRDG2KhHafC4zsMiAr1HzCXKMQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Apr 15, 2026 at 03:28:27PM +0800, Mingyu He wrote:
> The smaller the buffer_size in the test program, the more the
> performance dropped. Initially, I used a 4k buffer_size, and the
> performance decreased significantly. When the buffer_size was
> increased to 128K, the read performance with RWF_DONTCACHE actually
> surpassed the non-flagged version by about 10%.

Maybe you have block size larger than 4k? Core-mm will allocate larger
folios for page cache if filesystem asks it to. And if you try to access
it with 4k buffer it gets multiple read-discard cycles for the same
block with RWF_DONTCACHE. Without RWF_DONTCACHE only the first access to
the block will lead to I/O, following accesses are served from page
cache.

-- 
  Kiryl Shutsemau / Kirill A. Shutemov


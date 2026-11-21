Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 74472606A682
	for <linux-mm@archiver.kernel.org>; Sat, 21 Nov 2026 00:48:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=gHtF+QpI
Received: by kanga.kvack.org (Postfix)
	id 8248C6B00EF; Fri, 20 Nov 2026 19:48:05 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7DDD96B05B0; Fri, 20 Nov 2026 19:48:05 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6C4A46B05B1; Fri, 20 Nov 2026 19:48:05 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 50EC36B00EF
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 19:48:05 -0500 (EST)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 6981540278
	for <linux-mm@kvack.org>; Sat, 21 Nov 2026 00:48:04 +0000 (UTC)
X-FDA: 85457289288.20.CAD6138
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf20.hostedemail.com (Postfix) with ESMTP id D263E1C0008
	for <linux-mm@kvack.org>; Sat, 21 Nov 2026 00:48:02 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=gHtF+QpI;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf20.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795222083;
	b=ZdJGjRQrP/msMil/DliP6hOeJ1+tIKiZatwHNEGkrSEg7dS+5zbI7p+P4VT/u5DNnXEP/k
	SzFLNWX9RAP+8T2kbm64W629QbHwmkV8enqxsHd2EdULRv/eXQGc3+u/NIot9M52/rbq+d
	53RIj1Z6Jvwdo40WYBXWrza1f9XI9+4=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795222082;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cBNynnd5zqGP6W8jWML05LhU3hMAEMMow9kN5eJ4T90=;
	b=BGTYWGDk38MwXz2WQ8xpQQ+Ny83zVWzD15IyvDzv1aXemAvcD5Y2/LNkXh+4OI2GAFIOsE
	+Qccq8oFb4U/fBM2f8OqdHeQZhhUfmEM6IruKmEnPWD9SUz3jWRP41No6LTFqQk16opRb2
	MgfX0fRDaN4NngCd3vrn/NuGWn5dQ3Q=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=gHtF+QpI;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf20.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 5A65A60F16;
	Sat, 21 Nov 2026 00:48:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23AE61F000C4;
	Sat, 21 Nov 2026 00:48:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795222081;
	bh=cBNynnd5zqGP6W8jWML05LhU3hMAEMMow9kN5eJ4T90=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gHtF+QpIhNIM5CUpjcr05/i4zd3ftTePLBLVeKrM675G25prhXRlw9wJv6COexrAY
	 TMHyK6h8i9NVKoQpPB12V/Hv6i9qNrJsW9DtRZybb02ZhgRCSgQa21lNDBUZHhUgMb
	 E0UXfnAaZUfClFkf7BFE/xF8p01dCVxyeB3Z2tParUW6exnM2Ym25aKjWx/sURXZDA
	 wnnK+DTK3hk8Ao1Sl5D5Q04kfmfadAXROjJTcbRrfFP8FHZFUln0JVXKnKCrLL3f1C
	 NFADM31upgsDv6ZOCQFegSrXfcFCeJi9gtWfOE8exlx3rASzOIjtkC8q0WvtmDAvfY
	 3e3o/MkzMIohA==
From: SJ Park <sj@kernel.org>
To: kaleshsingh@google.com
Cc: SJ Park <sj@kernel.org>,
	akpm@linux-foundation.org,
	kernel-team@android.com,
	android-mm@google.com,
	Kees Cook <kees@kernel.org>,
	stable@vger.kernel.org,
	Chris Li <chrisl@kernel.org>,
	Kairui Song <kasong@tencent.com>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Nhat Pham <nphamcs@gmail.com>,
	Baoquan He <baoquan.he@linux.dev>,
	Barry Song <baohua@kernel.org>,
	Youngjun Park <youngjun.park@lge.com>,
	"Gustavo A. R. Silva" <gustavoars@kernel.org>,
	linux-mm@kvack.org
Subject: Re: [PATCH] mm: swap: make swap_header badpages a flexible array
Date: Fri, 20 Nov 2026 16:47:52 -0800
Message-ID: <20261121004753.83107-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261120061750.2973004-1-kaleshsingh@google.com>
References: 
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: D263E1C0008
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: pr8jxqy1dee1tuxo9h55tskmp56oifa7
X-Rspam-User:
X-HE-Tag: 1795222082-526577
X-HE-Meta: U2FsdGVkX18XBp/Hc5SDIzl1nehCa7kcJ43QDuFMBCMtnEHrQHWih93NbL6oN3sE0/SDe4rB3j2CefV2cVmoDVx0LegrSj1sYkZ53dLbWqEfWX2Js9+H0Mb86blPHCqRIvDVwn4oJs+1BurpDbk4bE4Pf6aiOqwg5I1wE4igJijNhl8QbcDFgqHGzX9Vdvm1RZv7+q8wlMlXgoIXIgBHSCY80L3m79d9S4G9Bg6E8NwQ37cQM+1Vn/SGaIFtFaYhVhi3hE+Z+y/uCBEcobe1W80QF9X4kqOyLd950WY1ipSseubUVqsxd8yTOXrgiyLxQRXJzJRDG+Og4ZtXBiptecuoyRcafeF2fYrOo2YO2P/HRN6RREEjhfeAc8j/Gbm2/DbCmi0vNr7+KKgo8X9tMKa7cvjBN5GJfz9IydwoeiBT3zI7cTPqRC6xtJww/w5iFd26q1z8d0Ifo7Vze56nWvv3stpquYw16EgwVZpFZ6xM2zvmJ3WU7LuG3WgEiuFjWM820ITHE9pMhK1hcQA+vEZa8PEDZ4GA/hIX5VT45rPyWT1UUCMbXC4Zn74MhqaGAYogfEFHQ8A5pjAMzpBTTXWH0uqbQ6hpv981zgXY+W4goaKNb/lz0OFBOXNKfEJJw/McxEEeEFaGSK157mbzoiDw8hzDZ07CQoNw6zbNDFcYbxXRtPHeZAAkyejT4pYFyZ86VPxz4ASGe8XP9J39v8+yioSkG/cMUUZPXExU3ULggnBJWivLMMZBvoP9QBjLe0P2bbQmmLtvwBxns51bJLzkZ+pLv3v7bVjutZ5/E/6mG9vA3TBTwDvZtr+PBLsYMcncXb7Bj4u+qpcz9nOiJ27nOeyrsFkbW/JumbKdJGer3l+yd4MuUa0AjiiIeuC/5qP2Luydz7zlHK7JOhmcSfoOPeNOxh/99/1Z6rCcyA0vzwdrYPhGtCM8Oey2KBNvINZse07Bfgg3LycE1oB
 aSzP6NAy
 CsOcTKSDYZV9XESkA9VGEUsprRR3FGE4bFG0FKs0XRS5MjpUSoMm1++Jtvz3cIOP3vYoRyp216ugbogeCjbXzgMTWWOQwv0Tc9y1HcR5saBKuBZy0ArldIztaJAhAhQfwAlq1FCq3AYjnhEQpVKkC7dctoXsoHwrq0ttxuosvRa1juefK7RSjM+/mdzignp2nIoOwWhpkDu6z2rCkLer7FAUy8/U4LsxRFTOM/f4CeVOmD26jili9tImee7iFviNa/JXP6z5LVyzBpSp0NxOVYeuCBm4T2VxZXXlKgHHVGBRMF6jgFnavhrxf3b6sJWCGUzF+9ZhRxMc6HhXOgiLcKQy3PNMw9xD9wPt4u6brLpLcz65862DbeH6Amf3JAJflLYUXwx/rzIqKo2C2Pw36wkhqLNXFIwvpt3jNY4f1j8eFWPk8CpKZSVygEDW2cyDI/iMrefqekz4pb35BM6rxER+qt/tGGQTdN/fevPvkorwH55Y98MggUno12o3AVVp5abeiPbtTQA1O0bYjmRAxRDy/X3/or/fruYTryXyGaynMoThyn/F8+3IC3GaUwf1/z65t3/GWjQaVhHs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Fri, 20 Nov 2026 06:17:49 +0000 kaleshsingh@google.com wrote:

> From: Kalesh Singh <kaleshsingh@google.com>
> 
> The swap header declares its list of bad pages as a one-element array,
> even though the list can fill the rest of the header page. Since the
> kernel is built with -fstrict-flex-arrays=3, the compiler takes that
> size literally, so with UBSAN bounds checking, swapon() of a swap area
> with two or more bad pages reports an out-of-bounds access:
> 
>   UBSAN: array-index-out-of-bounds in mm/swapfile.c:3674:26
>   index 1 is out of range for type '__u32[1]' (aka 'unsigned int[1]')
> 
> Kernels that trap on UBSAN reports and panic on oops, such as Android
> GKI kernels, crash instead.
> 
> Declare the list as a flexible array. The layout of the swap header
> does not change.

Makes sense to me.

> 
> Fixes: df8fc4e934c1 ("kbuild: Enable -fstrict-flex-arrays=3")
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Kees Cook <kees@kernel.org>
> Cc: stable@vger.kernel.org # 6.6.y, 6.12.y, 6.18.y
> Signed-off-by: Kalesh Singh <kaleshsingh@google.com>

Reviewed-by: SJ Park <sj@kernel.org>


Thanks,
SJ

[...]


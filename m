Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E66B3EB48F8
	for <linux-mm@archiver.kernel.org>; Thu, 12 Feb 2026 11:28:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5DE8B6B0089; Thu, 12 Feb 2026 06:28:31 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 595206B008A; Thu, 12 Feb 2026 06:28:31 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4CB8B6B008C; Thu, 12 Feb 2026 06:28:31 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 3C4FE6B0089
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 06:28:31 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id EBCD51607E9
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 11:28:30 +0000 (UTC)
X-FDA: 84435581580.14.5BB5294
Received: from mxhk.zte.com.cn (mxhk.zte.com.cn [160.30.148.34])
	by imf22.hostedemail.com (Postfix) with ESMTP id 0962AC0005
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 11:28:26 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=zte.com.cn;
	spf=pass (imf22.hostedemail.com: domain of xu.xin16@zte.com.cn designates 160.30.148.34 as permitted sender) smtp.mailfrom=xu.xin16@zte.com.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770895708;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references; bh=8He8jOTROtAzqJ/oNeRwWbyH/rOy/ic8ciNMYGi1E7Y=;
	b=Ocz5HGf/qOuSFTX4o1dRuHlA8DWc/u3ZplxjghS1Ep0s9nwRktwSJvWbNi2Am4IGi0ehAJ
	c4milIK3fzKVi+qgROy78Orx7N8dno1HBf5zlMOPR53uxyIqtd38N/6KwumNI4xEi24YWC
	wtmomw8c8lp2NhVOrOVTGLoWplylTI0=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=zte.com.cn;
	spf=pass (imf22.hostedemail.com: domain of xu.xin16@zte.com.cn designates 160.30.148.34 as permitted sender) smtp.mailfrom=xu.xin16@zte.com.cn
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770895708; a=rsa-sha256;
	cv=none;
	b=SCM5TDZx7BqS4ofiih4wxwCHbdkHOqEbAcHw5u5gMRO0JobqwV+Yhc2VmVEGx/3CrZawxA
	XVmPhpcgz0Fu9xmz0pWamu796YgO7MDyl20128qKRtwUvh2lLEHEbe50cJG/Fj2wYYFv9r
	nkj6HvBhPYpiuKa/TFAUe4O43M24Tnw=
Received: from mse-fl2.zte.com.cn (unknown [10.5.228.133])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mxhk.zte.com.cn (FangMail) with ESMTPS id 4fBY2b2fnHz5BNRf;
	Thu, 12 Feb 2026 19:28:23 +0800 (CST)
Received: from xaxapp02.zte.com.cn ([10.88.97.241])
	by mse-fl2.zte.com.cn with SMTP id 61CBSHSc013012;
	Thu, 12 Feb 2026 19:28:17 +0800 (+08)
	(envelope-from xu.xin16@zte.com.cn)
Received: from mapi (xaxapp02[null])
	by mapi (Zmail) with MAPI id mid32;
	Thu, 12 Feb 2026 19:28:20 +0800 (CST)
X-Zmail-TransId: 2afa698db954efa-5ce08
X-Mailer: Zmail v1.0
Message-ID: <20260212192820223O_r2NQzSEPG_C56cs-z4l@zte.com.cn>
Date: Thu, 12 Feb 2026 19:28:20 +0800 (CST)
Mime-Version: 1.0
From: <xu.xin16@zte.com.cn>
To: <david@kernel.org>, <akpm@linux-foundation.org>, <xu.xin16@zte.com.cn>
Cc: <chengming.zhou@linux.dev>, <hughd@google.com>, <wang.yaxin@zte.com.cn>,
        <yang.yang29@zte.com.cn>, <linux-mm@kvack.org>,
        <linux-kernel@vger.kernel.org>
Subject: =?UTF-8?B?W1BBVENIIHYzIDAvMl0gS1NNOiBPcHRpbWl6YXRpb25zIGZvciBybWFwX3dhbGtfa3Nt?=
Content-Type: text/plain;
	charset="UTF-8"
X-MAIL:mse-fl2.zte.com.cn 61CBSHSc013012
X-TLS: YES
X-SPF-DOMAIN: zte.com.cn
X-ENVELOPE-SENDER: xu.xin16@zte.com.cn
X-SPF: None
X-SOURCE-IP: 10.5.228.133 unknown Thu, 12 Feb 2026 19:28:23 +0800
X-Fangmail-Anti-Spam-Filtered: true
X-Fangmail-MID-QID: 698DB957.000/4fBY2b2fnHz5BNRf
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 0962AC0005
X-Stat-Signature: xh8bhoqyaetc4anq1fshtysx9dcqd7tc
X-Rspam-User: 
X-HE-Tag: 1770895706-232718
X-HE-Meta: U2FsdGVkX1/EITLxhOC6gAxLdDt2bgbwD0ucFPaHxzeWknCfJNVt2oulW52TCQeFyRYTrcMzcSnba4xWCR2cSi32Vv8wmYzu0a7VNi9re5Vu4X4VUi3u/IjXp24ydwlvQH4u9GhfqVN00Rv1U5ynT37Ex7jtgvxGAh0qQ0SVRi7BBoKKTfMwwpLIemu1tYsI5gEwtaqmmpD40LOFO9VA/ikrcRlTeyrHFfeEzOonIszHwPaewRoIye9uAv5N5BFU7B7nh3XhGhug3hpxVyXt+nxmjfRt75CaVFxEk/lY5P7HVRcsaDeAigmhHwnNKFYADMeQ2V/2e3HTKH22/qwlDBjW/JW1BQPoQCqeQlsn7mbxUE4OJ6pbcKCPbTkrRyjakzxT92QiWeeu03ktJ4bLQAKbghJDnfz3ZFlIwgZJyoK6GvqkjUOAmJtYNZaog5I2+xpwXbv2YKceRplXrASska2WYva+V39x5E5xStH5UbXOfew+gf2G1mgJJs8EsBp3pnexXrCLCOSMWwuIdrLsL8inTsIE4ZfPfuNlZT+r5QG3l8s+52ZQQPvBnp8Q6lgUYjzrZA1p64BALFf8SWOTVrl/yrIIKeydoOgSFMnnohTQh4JTg4Y2i3kF9dmYH5JB/BjwaGWXwiBceuRldvlW//BdHg9lCTme4u+8/CsPAsFy812DCZkZTCzSAICfsuWoVC9rfSqLxUygyEKtkfRw6FmPen889VTUDBufbvmXf00UXlOhWGnnn2MosXNQSwrPFmSnIQ8MBuBnX09g0p6z7EcoUIzLIS4GVzIMn3IOvBeeOn8gwtFQ3pxVhBYl1Z3t6fyzpTC0dra0HPRLvFLXRDsfBUcYwAkSqH1Oz/hM6fiwtNCQ2ZK/2b2aJuMw8h9kRHorpeg0h6E+gaqm/JHcu1aZzqneixVuTZ6lUNtk+DuAzWavmRUBFjAs6nIJeq/QIEHvRTP3E8xLc27GeLy
 L00Jt3on
 Bw5n2jGB9fUWJfNOeqCkBKcPAZ0bUjUBcR5b1OBunouWXlOwnp23JSZIY8lXTSfFSLweyzQDDJGBjuRz36HCSBS7mmDjHhq6SyQf0eGd1SNPRT9T8mCw2FLkjFUYm1BFCZ04GWtIcAvGz4h6h2StzYCRjJ6zglLcfQ3QxDgNvj4eXCMrcJ+2/dN4bzERg4xoduaFBPstVLMyER60xiqMqDqBHKHfha3lzCBiUR9+ubuSxxzM6AzdyHkg5KoGyyAbgaip0
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: xu xin <xu.xin16@zte.com.cn>

There are two performance optimization patches for rmap_walk_ksm.

The patch [1/2] move the initializaion of addr from the position inside
loop to the position before the loop, since the variable will not change
in the loop.

The patch [2/2] optimize rmap_walk_ksm by passing a suitable page offset
range to the anon_vma_interval_tree_foreach loop to reduce ineffective
checks.

The metric performance and reproducer can be found at patch[2/2].

Changes in v3:
- Fix some typos in commit description
- Replace "pgoff_start" and 'pgoff_end' by 'pgoff'.

Changes in v2:
- Use const variable to initialize 'addr'  "pgoff_start" and 'pgoff_end'
- Let pgoff_end = pgoff_start, since KSM folios are always order-0 (Suggested by David)

xu xin (2):
  ksm: Initialize the addr only once in rmap_walk_ksm
  ksm: Optimize rmap_walk_ksm by passing a suitable address range

 mm/ksm.c | 14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

-- 
2.25.1


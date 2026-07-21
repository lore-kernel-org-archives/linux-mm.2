Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 86519C4451C
	for <linux-mm@archiver.kernel.org>; Tue, 21 Jul 2026 09:04:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 53DDA6B00AB; Tue, 21 Jul 2026 05:04:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 515C06B00AE; Tue, 21 Jul 2026 05:04:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3DE086B00B0; Tue, 21 Jul 2026 05:04:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 0788C6B00AB
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 05:04:53 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 53E671A042C
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 09:04:53 +0000 (UTC)
X-FDA: 85012198866.11.31BCA4B
Received: from mxhk.zte.com.cn (mxhk.zte.com.cn [160.30.148.34])
	by imf02.hostedemail.com (Postfix) with ESMTP id BAACF8000D
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 09:04:49 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=zte.com.cn;
	spf=pass (imf02.hostedemail.com: domain of hu.shengming@zte.com.cn designates 160.30.148.34 as permitted sender) smtp.mailfrom=hu.shengming@zte.com.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784624691;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=JCVdhjMUzVtp2JBwzV1kvqlYQbOirRRL02aMa6bd6UQ=;
	b=yKwyiWUWn2IXwtHUlCRpRP6nwGWMG07BRmeyzTSmQoYQ9nQ+WW19l5U92Ijx+RbPLLxHjD
	M3mtQzVbMELE9pa94MbErAqyBt8r+nKQgM/VSigliudTp1fDjKLmR/IvyzGKaGfJFG7MdD
	QLcR8XwxbrTu6/Qe1jhwfuzByE5Kd3Y=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=zte.com.cn;
	spf=pass (imf02.hostedemail.com: domain of hu.shengming@zte.com.cn designates 160.30.148.34 as permitted sender) smtp.mailfrom=hu.shengming@zte.com.cn
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784624691;
	b=vrmPZMUkw6y4SUZlAycdLHc1TIi6/xB/BeAuvCqDf3n5vX1K42LgOS0bHiUpj2oVl9DCzf
	q/vadQOu311KWlaAVC1emardk4d/vBfWhH/AkGg4Lfv2ebE5PJ5HFt5tw3/s8DBbPZmcuD
	SEX09MLauUouqHCFzPJ8R93VqgDrkF0=
Received: from mse-fl2.zte.com.cn (unknown [10.5.228.133])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mxhk.zte.com.cn (FangMail) with ESMTPS id 4h4BKV4DGFz4yjjC;
	Tue, 21 Jul 2026 17:04:46 +0800 (CST)
Received: from xaxapp02.zte.com.cn ([10.88.97.241])
	by mse-fl2.zte.com.cn with SMTP id 66L94bMC054921;
	Tue, 21 Jul 2026 17:04:37 +0800 (+08)
	(envelope-from hu.shengming@zte.com.cn)
Received: from mapi (xaxapp05[null])
	by mapi (Zmail) with MAPI id mid32;
	Tue, 21 Jul 2026 17:04:39 +0800 (CST)
X-Zmail-TransId: 2afc6a5f3627bca-f5661
X-Mailer: Zmail v1.0
Message-ID: <20260721170439864YfrJGliTZWCikCX-HcPzl@zte.com.cn>
In-Reply-To: <234c56b7-4036-4d03-8d8d-6298d16c3a77@kernel.org>
References: 20260721084522552ZPa16p1SRj3PYat3sqxuN@zte.com.cn,01ea11f8-65b4-4941-adf7-423c3f000292@kernel.org,234c56b7-4036-4d03-8d8d-6298d16c3a77@kernel.org
Date: Tue, 21 Jul 2026 17:04:39 +0800 (CST)
Mime-Version: 1.0
From: <hu.shengming@zte.com.cn>
To: <vbabka@kernel.org>
Cc: <harry@kernel.org>, <akpm@linux-foundation.org>, <hao.li@linux.dev>,
        <cl@gentwo.org>, <rientjes@google.com>, <roman.gushchin@linux.dev>,
        <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
        <zhang.run@zte.com.cn>, <cai.qu@zte.com.cn>
Subject: =?UTF-8?B?UmU6IFtQQVRDSCB2M10gbW0vc2x1YjogcHJldmVudCBwZm1lbWFsbG9jIG9iamVjdHMgZnJvbSBlbnRlcmluZyB0aGUgYmFybg==?=
Content-Type: text/plain;
	charset="UTF-8"
X-MAIL:mse-fl2.zte.com.cn 66L94bMC054921
X-TLS: YES
X-ENVELOPE-SENDER: hu.shengming@zte.com.cn
X-SOURCE-IP: 10.5.228.133 unknown Tue, 21 Jul 2026 17:04:46 +0800
X-CLEAN: YES
X-Fangmail-Anti-Spam-Filtered: true
X-Fangmail-MID-QID: 6A5F362E.001/4h4BKV4DGFz4yjjC
X-Rspamd-Queue-Id: BAACF8000D
X-Rspam-User: 
X-Stat-Signature: ko4rt6hi6y6beix4kqm6sf14z4yfntua
X-Rspamd-Server: rspam04
X-HE-Tag: 1784624689-445382
X-HE-Meta: U2FsdGVkX1/TCWlrSZQJuUPcF6+bkZWgVM7oHGfNSifeyxIas/lE46pjB5w9jMWkgf95EGqGOd6kaUiJmiuqdhGhBEcFcu8w+cVGTUp1U3DDh6ZYEI/fXY1F+mtlmAOHjUrqdRc3kCAiYOvQ5HiAsgIuGM65bNZkr4/lGonM9hL1Y9Cuc/gKixfzw/1hOaDHajjjFt6bl9Ql9tFEaib/+NJOarNNSoFBQ5YsjPp6i1U4i8RUZ5Jg9Dwm+a99CDLFp5lAF6mI1IYnW7W+qk/CjSTkTI09pCwNaDF7ZBpE9mWkSGnwxRgn9ZHT8zH+A9nqJ6+1pFpHKsD2ARMaohhEl/bi5785UjHA7oMfUswsAv6JH0fm+ew40qAkQ0M4dxY9J7uwiOlLs5y8NEXVcGL0kFgM58uR7kxxEAy6oMgUYDiH9yhlPW4cELtk8hJB4Qe6fWibcj6trTzMMBWG6Gl0CObi41R5+yWB1GEXAnz335gg9EMUQrtuaiRqmDMzYvB/Q4oyclroNUHJFlzNi+nTVZCfIb5Dq/2a+JJO7UovFCj+4LpwIDfGVRgStuVLa8XH3NJ0JolnfqvbHxzZGWukVJePwN+zmf7VXQtrBhTeDxFaGOVraw+Cy5RjQAn+UhgCS7vG7UOQRyE5fSL4+302LEM9BB9iXqSxZcvYBHMsB0yQFl94j8Ednf6CbZxxEJB5VV0vWt0AbOT0Mevlnr7CnUGxrit430MEfRgRE6DEf90SYmeQ2rpVI7/Z+je9P2uKZibRuJOfwCofiTKOHIqQHHcGEmQZaFp4OtoMPUYHkn+fy3TnVtiYgVjG/9O2jiQL3waC7weDpT53DsLAstKamjhtY/RfkxrEGzSTdKFVbqaOp+JC4amjx7ZPxblqq8B+tiH/k3LtlFllwcI7jpvcVKhBgwMIZmrCH4tG9PQQwUD2pNgBZaL9loiqig4tuHFQLCHASGn7eY4KlPPGKJV
 Y49FnMgF
 uj9TuLD8/OOdRKASYlcwcot2vmEKF/IDEWubIm7pp/ZqHsUJE18/FgViKt34zx80buW4Qs7xmng45x1NlOuzcdCvroNuJ6gB99uGenqlutmcfBr6DHj02/FYHr0RyPa3e50AF6yZgpG8zV7Xz5gS+jHAjPnabl3VnOPe/+NcAP3B+Jr7xWNcvkd4XRtbf2V5fQWWbd/Bj1NAjHOyoaRwInirOQQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Vlastimil wrote:
> On 7/21/26 09:34, Vlastimil Babka (SUSE) wrote:
> > On 7/21/26 02:45, hu.shengming@zte.com.cn wrote:
> >> From: Shengming Hu <hu.shengming@zte.com.cn>
> >> 
> >> kmem_cache_return_sheaf() may refill a partially consumed sheaf before
> >> placing it in the barn. Without an explicit restriction, this refill may
> >> draw objects from pfmemalloc slabs and consume emergency reserves.
> >> 
> >> Add __GFP_NOMEMALLOC so that returned sheaves are refilled only from
> >> non-pfmemalloc slabs. Also add __GFP_NOWARN, as suggested by Hao Li,
> >> because this refill is a best-effort attempt and failure is acceptable..
> >> If the refill fails, flush and free the sheaf instead.
> >> 
> >> Fixes: 3c1ea5c5019f ("slab: sheaf prefilling for guaranteed allocations")
> > 
> > Wonder if 1ce20c28eafd ("slab: handle pfmemalloc slabs properly with
> > sheaves") is a better match. Until that commit we just didn't care, and it
> > seems like this is a case that commit missed?

Agreed, 1ce20c28eafd is a better match. Thanks for catching this.

> Added to slab/for-next with changed Fixes: per above, but can adjust it
> further if it was wrong. Thanks!
> 

Thanks!

--
With Best Regards,
Shengming


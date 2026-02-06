Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A9E72EA795E
	for <linux-mm@archiver.kernel.org>; Fri,  6 Feb 2026 09:55:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EB7896B0089; Fri,  6 Feb 2026 04:55:24 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E650D6B0092; Fri,  6 Feb 2026 04:55:24 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D70E76B0096; Fri,  6 Feb 2026 04:55:24 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id C24436B0089
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 04:55:24 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 6B645160767
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 09:55:24 +0000 (UTC)
X-FDA: 84413574168.02.25EA7A7
Received: from mxhk.zte.com.cn (mxhk.zte.com.cn [160.30.148.35])
	by imf18.hostedemail.com (Postfix) with ESMTP id 896251C0005
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 09:55:21 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=none;
	spf=pass (imf18.hostedemail.com: domain of xu.xin16@zte.com.cn designates 160.30.148.35 as permitted sender) smtp.mailfrom=xu.xin16@zte.com.cn;
	dmarc=pass (policy=none) header.from=zte.com.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770371722;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references; bh=KWCBMD68S+zqhg98Xg5yXktwIQbyTWraR6cGf6tziBA=;
	b=g7utF25lYSs4Uflc1mbaaZFDihr2sWjTG1vByr4UrqJzZPnQQ9PAMY4jgY2cpGleyb/6Q6
	tMTL5dVR7sXngEV7+OJkdq8PKkhMFZHXkBaFWG+PyqwSFM2zstvtklCAxTlkl4fRc3iXtQ
	Z1W98TSWZc9AbjLd+pj8vhb7cHlJzSE=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=none;
	spf=pass (imf18.hostedemail.com: domain of xu.xin16@zte.com.cn designates 160.30.148.35 as permitted sender) smtp.mailfrom=xu.xin16@zte.com.cn;
	dmarc=pass (policy=none) header.from=zte.com.cn
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770371722; a=rsa-sha256;
	cv=none;
	b=E6gbuMc64zA8xeMo44aB8vXYpb7DAWtxLc5UGaRT8gG8hSS/D/Ya0EPXLWvjSU+I7KiYJ8
	Bn0llTZfX5kj4emRrQ9GvUSLsr1BI2XFRkZbPKNWRLmueJmbgp6ZJgpI7X6PyWam6qu86J
	lMvwBD3vfZwseKlf0csBFwta5fpSZVI=
Received: from mse-fl1.zte.com.cn (unknown [10.5.228.132])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mxhk.zte.com.cn (FangMail) with ESMTPS id 4f6qFx3X8Sz8Xs72;
	Fri, 06 Feb 2026 17:55:17 +0800 (CST)
Received: from xaxapp02.zte.com.cn ([10.88.97.241])
	by mse-fl1.zte.com.cn with SMTP id 6169t6bs097749;
	Fri, 6 Feb 2026 17:55:06 +0800 (+08)
	(envelope-from xu.xin16@zte.com.cn)
Received: from mapi (xaxapp02[null])
	by mapi (Zmail) with MAPI id mid32;
	Fri, 6 Feb 2026 17:55:07 +0800 (CST)
X-Zmail-TransId: 2afa6985ba7b3d7-19706
X-Mailer: Zmail v1.0
Message-ID: <20260206175507055aERH4UFC0NcZLtWAwn1hv@zte.com.cn>
Date: Fri, 6 Feb 2026 17:55:07 +0800 (CST)
Mime-Version: 1.0
From: <xu.xin16@zte.com.cn>
To: <david@kernel.org>, <akpm@linux-foundation.org>
Cc: <chengming.zhou@linux.dev>, <hughd@google.com>, <wang.yaxin@zte.com.cn>,
        <yang.yang29@zte.com.cn>, <linux-mm@kvack.org>,
        <linux-kernel@vger.kernel.org>
Subject: =?UTF-8?B?W1BBVENIIHYyIDAvMl0gS1NNOiBPcHRpbWl6YXRpb25zIGZvciBybWFwX3dhbGtfa3Nt?=
Content-Type: text/plain;
	charset="UTF-8"
X-MAIL:mse-fl1.zte.com.cn 6169t6bs097749
X-TLS: YES
X-SPF-DOMAIN: zte.com.cn
X-ENVELOPE-SENDER: xu.xin16@zte.com.cn
X-SPF: None
X-SOURCE-IP: 10.5.228.132 unknown Fri, 06 Feb 2026 17:55:17 +0800
X-Fangmail-Anti-Spam-Filtered: true
X-Fangmail-MID-QID: 6985BA85.000/4f6qFx3X8Sz8Xs72
X-Rspam-User: 
X-Rspamd-Queue-Id: 896251C0005
X-Rspamd-Server: rspam07
X-Stat-Signature: p9gtfksdk4ykxopqx6fos4ka95uz3y9i
X-HE-Tag: 1770371721-457103
X-HE-Meta: U2FsdGVkX18e+mLlc4j5KfvpdEej8dOHJhWZ49Yg3Hvwu6kXz8hsMvZn0ismfgKbEZpthxAjIJ9HlBuoXaMSeGFruh6lE9HqpvZaK+iKqeRSsv9X16C62grwuRUDYxHyL5lQfNxR2PN4fnPnINUw71+K28nM1Rblwfc7Idn2iKExT1iTuPRxS1awHvavqWRW0Dg0CMvWqJITz9VzmYoKDtGd7z2FeRlOOYyz4BEktm17QOohLx6WaSgIigwpbFtblIsC10ldWNQAuYqIWWtiXHseqNVjTBl2Kqyr3E7smWghDQgth+Dn2yveQkAaNCY1UWuTpG9Zr089DhAklBgfloSH+x+l17hNeLGvoUplXT6ySExkuMYXQpf6KThVZjW8a05rw1auKxRqhFRaK1QdZWqRqJlu0ZohwS2KcQWxwMpMHYRbekMn0jm1n2VVJiIQtbkN0T6Q6l8mQFP6NKw+8SiylnCKloSnJC44sxaJTqRdrTfP4Z5gR6BbaOyfDTkVKf0UX3/pVh8TitFezpGf1xyMm0twv1EFS/zIMfzDnPNiJQ7CTmGv5vE7U9xR/k8wqNfG8I/YoKoFav3aLCY6au+y0YXp3k3e0jn4dL6pn0Jb5GwJ8kVzIKeHt68k1rx/tile9568wC8I83HWaetjkYkQFBdZ/nGVCDwXADEzijIc0UTBh6gy8zCPrG5iSLlkwHjHX4VkWNEwmp2bj01B+oKurW2wDsFEXQ38x7gibIe2tB18w8xpp2hAXSbZ9TtOkH95IeGPuH4W991svvV6smwQIOYUrcVx35rT/1a6tyXRBl0z7I3EjslHlI1dwJyMtMab4jYm99znahLcaX4tuHpJwX7Kh3/Ncj+4vTpBbmQU0nINClLQgUkAUR7L6O6UwzZ5FZfoPIOYLlLfkHDY/gJQ9R1zNIqIe+T/+yyiQqogZ/0bYYt+54oUK6p7DYK4w/MmTriGNh3MkQBuq6v
 89e7XHdu
 n3ICsN1ioPHoGp/lNQpDp4c2L+RqdY8mEZuieyr9V4LtsYCnK1PDmlyRzWuntdtykjDidfYn9e0+t1k7zybpvBVzHAvYfLg0rr1GlkzjuXYkj8SDKqT+R4O5i9WNfGxkoaYHOaE1le4fjXI67HssMOmdJJk2R69gGJiApuoFzOlFivcHVcGqh35gpZIaHBuzp7EzWWYPp3nRISrKsmoGBQZo4PoNBaOwYuk01HYgkT84oiwVBkl29FAbjr5IlhW+Fd/kp
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: xu xin <xu.xin16@zte.com.cn>

There are two perfomance optimization patches for rmap_walk_ksm.

The patch [1/2] move the initializaion of addr from the position inside loop
to the position before the loop, since the variable will not change in the
loop.

The patch [2/2] optimize rmap_walk_ksm by passing a suitable page offset range
to the anon_vma_interval_tree_foreach loop to reduce ineffective checks.

The metric performance is seen at patch[2/2].

xu xin (2):
  ksm: Initialize the addr only once in rmap_walk_ksm
  ksm: Optimize rmap_walk_ksm by passing a suitable address range

 mm/ksm.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

-- 
2.25.1


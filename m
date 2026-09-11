Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 813EAC88E50
	for <linux-mm@archiver.kernel.org>; Fri, 11 Sep 2026 09:08:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 656626B0092; Fri, 11 Sep 2026 05:08:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 606A76B0093; Fri, 11 Sep 2026 05:08:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5249E6B0096; Fri, 11 Sep 2026 05:08:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 30C676B0092
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 05:08:15 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 422CA140169
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 09:08:14 +0000 (UTC)
X-FDA: 85200904908.22.9583550
Received: from mxhk.zte.com.cn (mxhk.zte.com.cn [160.30.148.35])
	by imf19.hostedemail.com (Postfix) with ESMTP id 6683F1A0004
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 09:08:11 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=zte.com.cn;
	spf=pass (imf19.hostedemail.com: domain of xu.xin16@zte.com.cn designates 160.30.148.35 as permitted sender) smtp.mailfrom=xu.xin16@zte.com.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789117692;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=b1w3iQ69U9QwO1mIb/4+iUTHpyJHJUTHc/hIeZfBwUM=;
	b=eoO0oIJOj/AgoAq3XZ/bq6Mm4iUUhW87xZBDE2K57rBmhDZSKRXVpIzzOmz89NB4Kk9hXf
	0/L8oGG+hI4qk3+VTm21Utxe6NcjTocLycT14YKVEiVJ5ObR49gzIcrOrkr4ui/HesCUs3
	XYy8QeCR674YrGTGNFCpUx0d16DwIF8=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789117692;
	b=f7Wk23Slat24UOESc4/KlAMQzPfQREs6ZKn0+GzMugQwUPf+XXPj5Dbo2bFurN34sb7eti
	VcNqDD+imf1r6iMmq8nkaB/hIH/bwZjpVSaYfshKgawpsP1ZMitER8ej1gFp3H/J3uzwua
	DbYeT9I3ySo4NDrIH7pDEybxppU+QSk=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=zte.com.cn;
	spf=pass (imf19.hostedemail.com: domain of xu.xin16@zte.com.cn designates 160.30.148.35 as permitted sender) smtp.mailfrom=xu.xin16@zte.com.cn
Received: from mse-fl1.zte.com.cn (unknown [10.5.228.132])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mxhk.zte.com.cn (FangMail) with ESMTPS id 4hh7xJ4S5sz8XrrM;
	Fri, 11 Sep 2026 17:08:04 +0800 (CST)
Received: from xaxapp01.zte.com.cn ([10.88.99.176])
	by mse-fl1.zte.com.cn with SMTP id 68B97rcj046889;
	Fri, 11 Sep 2026 17:07:53 +0800 (+08)
	(envelope-from xu.xin16@zte.com.cn)
Received: from mapi (xaxapp04[null])
	by mapi (Zmail) with MAPI id mid32;
	Fri, 11 Sep 2026 17:07:55 +0800 (CST)
X-Zmail-TransId: 2afb6aa3c4eb72b-0c6c5
X-Mailer: Zmail v1.0
Message-ID: <20260911170755975ug1lrs9fz0EjWzEAnsbmB@zte.com.cn>
In-Reply-To: <aqO_memM4BIbFAxf@gremlin>
References: 20260911160421076_KNXun8Mpp9Xj7fxHG0i7@zte.com.cn,20260911160725440VlRXkblhz6f7GJgQfbVv3@zte.com.cn,aqO_memM4BIbFAxf@gremlin
Date: Fri, 11 Sep 2026 17:07:55 +0800 (CST)
Mime-Version: 1.0
From: <xu.xin16@zte.com.cn>
To: <ljs@kernel.org>
Cc: <akpm@linux-foundation.org>, <david@kernel.org>, <surenb@google.com>,
        <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>
Subject: =?UTF-8?B?UmU6IFtQQVRDSCAxLzRdIG1tL3BhZ2V3YWxrOiBkZWxldGUgdGhlIHVudXNlZCBtZW1iZXI=?=
Content-Type: text/plain;
	charset="UTF-8"
X-MAIL:mse-fl1.zte.com.cn 68B97rcj046889
X-TLS: YES
X-ENVELOPE-SENDER: xu.xin16@zte.com.cn
X-SOURCE-IP: 10.5.228.132 unknown Fri, 11 Sep 2026 17:08:04 +0800
X-CLEAN: YES
X-Fangmail-Anti-Spam-Filtered: true
X-Fangmail-MID-QID: 6AA3C4F4.002/4hh7xJ4S5sz8XrrM
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 6683F1A0004
X-Stat-Signature: xe33bthh48iyjuhgtuxj3nr8c8kk8txc
X-Rspam-User: 
X-HE-Tag: 1789117691-255229
X-HE-Meta: U2FsdGVkX183HxSAgxyIlHLACRPYC6U1t3g5gRaXC6LKPGEYGbVk0wlJ+oGWJ9wXpbz+IjZFf5u442vSLkA2gDkYdCiAplEKQJLaIN7c7ORgt/u3Y8Ae4c/x4RYMF0t6SORftczPlaZia/kfBBoHeuQ2BIDdnWl5xzmCkza/3dBwiuwcEW1wWPFxmodv9bvmQDMP1dt0t290+p+DfjVbrtjJopu/Rxdy/IuMNvLjRCoBMxbkGYzUtmNxYlqAuGVjkdrjqg8lzF22R5ZzFjq+qPAtuAWSQyZA7bKwmNmGnYYcKJRnEwYuobQGQORXo70nYSxFXg1R8fzae2gxXOzKkwVuNdNVQIYaIv+anr9sTTsXG5dX2ch4T9Z4cEKlgi0goIGzdF3cYRtYspw/wmQl/XwZmEm6/q2BA9X8dhQuau81Ncj7L0Qrg8AErkF66aQAFjCUFIy4SaVN2v2m2rcmmOyZxffKwDjDNDUqqxVUHqZ/taptq7IjGKiSs+gQ1scH2xJGVUaphVh3JfSZdM528LY1XePFTIZQs/nm0xuAvt+ZxVGc5OszRg/PYkgXfidh3t7Cl4yC56c85jUENlWRO29NN7d3Vx4e3x2+OPUYC8WuOHA49AkaVsyrbRVbA7YtiOHfK8HAls1rgGg+eyjz+ag2DsBkni0aS5V9BPiuHNGensHO1dVMskADlE4ttjk9jAy5cnB/YRE0Up12mjWbr+vU8hzgngJcDbQEHWsRJOfoYHaf/MKBPVl7IzixvDeIjaZuT+OBqfSS0pEJaJl80U1HzYZbjtqY4BwrtK1FBvYbmKefQbziWKu1EGVk0PkO/wecYzD2m+7rGW1SfEYvRj3X0gbYvhEry5SeJHGxZ+VIm9eehWj7UQda1RMpojBEz1jfqQewml90sFJnGsS5aS99TgM0oOgkenL0KSagavSnnAReJCAldvZ6uaeM5wFSrb1WZZ4V6pJ6Wtem+1C
 xiZH6zIG
 7+9vI5KA2yTbT8MDtqaeoW1ke6sUn5zxxViCvdZH1wZkaSEFlasvwj99g5782yBdcPGQcwj+Ap6zyxbUo8lAfcV2dsQGX9ngiLU5qksISAd9JHjjFv6eNhQdX1bwNVW1kwsHJ4yEli2HzLY5SfhNCT/L0kCw7tKXXwIUd0vFt8OwqZqBzrrzfr+LIFJ54QsDl6gzHjBwVMHIk96dTY+18x3z2GcdC+Dfk4xX3HeNxZL3t3ADU2m4tMSUpUEJbS3rkknkV6ZH3qRyFKzKAbH9eH/ojHQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> Please fix your cc'ing.
> 
> Cc- everybody on every mail.
> 
> You cc me only on this (1/4) and 3/4 but then don't on an mm/rmap.c change in
> 2/4 when I co-maintain rmap.
> 
> And 4/4 is about use of VMA locks which I also co-maintain :)
> 
> Just cc- everybody on everything...
> 

Oh, I’m really sorry—I accidentally missed sending it to you. 

I’ll CC everyone in the follow-ups.


Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B9646C61DB9
	for <linux-mm@archiver.kernel.org>; Fri, 28 Aug 2026 13:13:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CE4D56B0088; Fri, 28 Aug 2026 09:13:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C95696B008A; Fri, 28 Aug 2026 09:13:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BA9F86B0095; Fri, 28 Aug 2026 09:13:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 9C1B16B0088
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 09:13:02 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 2C37B1202BD
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 13:13:02 +0000 (UTC)
X-FDA: 85150718604.19.B51BFE3
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	by imf29.hostedemail.com (Postfix) with ESMTP id 6014312000E
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 13:12:59 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b="X/FmnSM0";
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf29.hostedemail.com: domain of panov.nikita@huawei.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=panov.nikita@huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787922780;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YZG/JSrF/VgDZ41PuQy1wlBeOCLxrcnR7jrPKEkUbq4=;
	b=b/aHh9ORLdOfnaoLiNy4Y9bAAwQeKzoG+BooGTxvcXhWAxf2fujC648knA+VenIuvVsENK
	SPvQz9lUO7DY+1Glw2JRYrIjN39oVeegr51Bn6POa7W9o4Ou/FpAdql2WWdiVf9Tpi4Qaj
	h8bzpJGS1siSlToOzAHI5wHpCmgJFYk=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787922780;
	b=Ld9aJwovS9IfimzJNd+PaE9foTExTbm4uh+vaMHji5V+c5dbb7FYxr3V4mPnhSLfqqPL4Y
	QbwKLXcSxez5XdaYmGX9soOE43KejFxaNdlZoNCl+4nyBdX7iiYtxUG2YYdXSdDbPwQZm8
	+F995OyPFFqzDv/rsUfsPQFyacG1Wzs=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b="X/FmnSM0";
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf29.hostedemail.com: domain of panov.nikita@huawei.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=panov.nikita@huawei.com
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=YZG/JSrF/VgDZ41PuQy1wlBeOCLxrcnR7jrPKEkUbq4=;
	b=X/FmnSM0cS8HU6OnEAMI/DZZTXh74QoTo1Le4oCvCSwYeTWZAk46qtXTgna18+E49nQq/3iSf
	qheht6algnU0qoCJW6XzQRxdC+oG0Qbj8Vq0w1cfmLdGs2jC8aYEKUx+ov57SbCcT6l05sqTHc3
	9rNWE4N6n5crfeJk95LZueE=
Received: from mail.maildlp.com (unknown [172.18.224.83])
	by frasgout.his.huawei.com (SkyGuard) with ESMTPS id 4hWf1W1hsjzHnH49;
	Fri, 28 Aug 2026 21:12:15 +0800 (CST)
Received: from mscpeml500004.china.huawei.com (unknown [7.188.26.250])
	by mail.maildlp.com (Postfix) with ESMTPS id F07E740569;
	Fri, 28 Aug 2026 21:12:52 +0800 (CST)
Received: from mscphis00949.huawei.com (10.123.66.11) by
 mscpeml500004.china.huawei.com (7.188.26.250) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Fri, 28 Aug 2026 16:12:52 +0300
From: Nikita Panov <panov.nikita@huawei.com>
To: <ljs@kernel.org>
CC: <akpm@linux-foundation.org>, <artem.kuzin@huawei.com>,
	<catalin.marinas@arm.com>, <cl@gentwo.org>, <david@kernel.org>,
	<liam@infradead.org>, <linux-arm-kernel@lists.infradead.org>,
	<linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>,
	<linux@armlinux.org.uk>, <mark.rutland@arm.com>, <mhocko@suse.com>,
	<panov.nikita@huawei.com>, <rppt@kernel.org>, <surenb@google.com>,
	<vbabka@kernel.org>, <wangkefeng.wang@huawei.com>, <will@kernel.org>
Subject: Re: [RFC PATCH 02/18] arm64: align kernel text and rodata
Date: Fri, 28 Aug 2026 21:00:17 +0800
Message-ID: <20260828130017.134474-1-panov.nikita@huawei.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <apB1JCaNkGQMJQqq@gremlin>
References: <apB1JCaNkGQMJQqq@gremlin>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.123.66.11]
X-ClientProxiedBy: mscpeml100003.china.huawei.com (10.199.174.67) To
 mscpeml500004.china.huawei.com (7.188.26.250)
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 6014312000E
X-Stat-Signature: tspg4rfeztijsqxhtimdasxppmnszfq9
X-Rspam-User: 
X-HE-Tag: 1787922779-585886
X-HE-Meta: U2FsdGVkX1/2b22nrSlPFQRHpPCMOHKxCB0SVfUBoZRxRoZ54rDRVfl3sS/3lgx8V5mdoIvc6FaPehgVvCQd1cI3De7mTkv9Qw7cUlSjwk/Z5aA+ZTepC2lTdRuewDbCea90Tz0IMnNrSV7a0x0w5lGRciuRciONFHJNhOwKHT4qCSJasCKAM1mmhnce/Hv4csXLsXYTK34VdyqdKjNOdhHcIVB+dUwqHUq5pAu2p+sQ8rq4z2CoB1cjOupTqmXTlDx++yLHJcl+Cja317bfrTOtBwxEZkfG6fcJkwz0GI2bjlP3N26i7tFzBNVWerq4VKnDeXgF7aWY7xdZ+A4uK9EnrDZSb6AZOOY5AtzlQGvrCRvHZF3wwFXPXx2FRFO3AlKelS+TE/wpxJTwq+hU0hyx0ufxTL7Z1OU5si+K3PLM6A47GvpJYiWxlszig0COZgjAG+0mNlmMdleXUY8UsLkJK2rSFUJ96By+DuBBAD7Lq7ltqo6IxoWKpAMCHuhzCx7YBL9o4iZMasQaTt5RWxrAAjkS+3ib939QFtaGWA6ErzKi9WRYmKzwV7yiUA8cYR9HKZemw+/aSlVSz18Q3J9WrStkjb3bwM2zepDdyDHeIv12TdHgThnOpZAKp0WTw8/e5VcN82zVZAsQX5ntLCRrjWitP0wWuKU8lfL70cnvNWonQ3I1B+1UmOGDjHOTalpfEHZE/3xSXzNdgcjGYa+v+2kylvzNszMH/Ing7FXmM50Bf1+14VpM3rwMZu33ffwgfawRApO3crWQUkwH+joBfmDdSCn+jJFbaf/QZUqJ+VowLmqGjM79KbQPtjiIAl8vDBCwYjPRWLnIpDe1k3g79PhxpwkAHmTN4ib67pDjtmuC4pJgD1QyJFultnPPINyJx+r8at0xDV5OWnK+DLEh5whnioM5UGFmDPP7Qgv7mhQS+eDxyMRIAr35JhcfEn4rk7/p3RZH+YCIdjn
 fjvkcEkX
 gRw8Fv270KOq2H7vshoegwBXcbdOgMppkrOLtZZeCLl8gYuE5ItXEeIBVycH7fTOPanM45JafSd+liW4msMO55Eq2v7MNqpDah/C6dUTlc6hevjI4Qz55BJuTFOqtpZa47V7RfVYIrcX6/KB6iN/HpgCxnfNIq5Ikdo6iRPyK0yYzp5cspB9gpT5JsxBrqVPDEWmGNL/xqYrKwybC6WZnUun6LYefNuGU+B9PaKNoMXWU/TIZWvp4dImyf0UpOUV/dF+2zMarOiTvrW14oBJNGFGfY1h5UhjSQVWQlfuTx0cmOU1MDpnYxSYRyHHoN0Z7H9X141Uzs5x3CA6zThCkMU73wg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello,

On 8/27/2026 8:35 PM, Lorenzo Stoakes (ARM) wrote:
> On Fri, Aug 28, 2026 at 12:11:42AM +0800, Nikita Panov wrote:
>> Acked-by: Artem Kuzin <artem.kuzin@huawei.com>
>> Acked-by: Alexander Grubnikov <alexander.grubnikov@huawei.com>
>> Acked-by: Ilya Hanov <ilya.hanov@huawei-partners.com>
>> Acked-by: Denis Darvish <darvish.denis@huawei.com>
>
> One small note on procedure: it's not really the done thing to pre-Ack
> patches in series sent upstream like this :)
>
> --
> Cheers, Lorenzo

Thanks for clarification, will remove it from future submissions.

BR
Nikita Panov


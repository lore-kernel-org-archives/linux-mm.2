Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 34789C43458
	for <linux-mm@archiver.kernel.org>; Tue, 14 Jul 2026 00:30:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 022246B0088; Mon, 13 Jul 2026 20:30:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F3BF86B008A; Mon, 13 Jul 2026 20:30:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E7D126B008C; Mon, 13 Jul 2026 20:30:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id BE6B56B0088
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 20:30:50 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 3560140249
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 00:30:50 +0000 (UTC)
X-FDA: 84985501860.13.91FF319
Received: from mxct.zte.com.cn (mxct.zte.com.cn [183.62.165.209])
	by imf24.hostedemail.com (Postfix) with ESMTP id 642DD180010
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 00:30:47 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=none;
	spf=pass (imf24.hostedemail.com: domain of xu.xin16@zte.com.cn designates 183.62.165.209 as permitted sender) smtp.mailfrom=xu.xin16@zte.com.cn;
	dmarc=pass (policy=none) header.from=zte.com.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783989048;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=CxH6boBiQC3wVDpayYNL3CJ3Kr0DFxT8OSa0w/nVwB8=;
	b=oHAp89g0P8GUtcVm+P1jk6ZSy0PTh+ANxENeaufxW84Bb0qRYwDQZgYj+CzZLPEpbooSrC
	/Hu9yU5w6wmHvDyLZezDH3k7fXnmk/0/6BK30GyN6pstfQVue1HHRz1h9otW6tV+RxFicl
	9F6UVCo3gMIg6+bU7CS+jwKQXnwzua8=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=none;
	spf=pass (imf24.hostedemail.com: domain of xu.xin16@zte.com.cn designates 183.62.165.209 as permitted sender) smtp.mailfrom=xu.xin16@zte.com.cn;
	dmarc=pass (policy=none) header.from=zte.com.cn
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783989048;
	b=mJpzaLkyydznvMwQ5tcFrVolfhWtxZ5G+vH/wvOQNIBn+B817M03oJXnv+3ZE3bBZAMXua
	QZaV+CqJDsnwCtLMYtBi/xhf9rRWbOi8AriA+cVRHYlyoUr2J8EK1DZx3OHaJGUFB/8mYm
	fM3wJ89vgWYcTtOq/jgK41dAzsyk2N4=
Received: from mse-fl1.zte.com.cn (unknown [10.5.228.132])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mxct.zte.com.cn (FangMail) with ESMTPS id 4gzgFR0MLgz5B7RM;
	Tue, 14 Jul 2026 08:30:35 +0800 (CST)
Received: from xaxapp04.zte.com.cn ([10.99.98.157])
	by mse-fl1.zte.com.cn with SMTP id 66E0UUjn027130;
	Tue, 14 Jul 2026 08:30:30 +0800 (+08)
	(envelope-from xu.xin16@zte.com.cn)
Received: from mapi (xaxapp01[null])
	by mapi (Zmail) with MAPI id mid32;
	Tue, 14 Jul 2026 08:30:31 +0800 (CST)
X-Zmail-TransId: 2af96a55832746b-39f90
X-Mailer: Zmail v1.0
Message-ID: <20260714083031191-87qcnWfUzJUvfGv3UDje@zte.com.cn>
In-Reply-To: <b542ad50-097b-4440-8e7b-6a93c8a70ed1@kernel.org>
References: 20260713144153556amKkr4s-dWoQu5-ziCfZe@zte.com.cn,b542ad50-097b-4440-8e7b-6a93c8a70ed1@kernel.org
Date: Tue, 14 Jul 2026 08:30:31 +0800 (CST)
Mime-Version: 1.0
From: <xu.xin16@zte.com.cn>
To: <david@kernel.org>
Cc: <akpm@linux-foundation.org>, <ljs@kernel.org>, <ziy@nvidia.com>,
        <baolin.wang@linux.alibaba.com>, <baohua@kernel.org>,
        <lance.yang@linux.dev>, <usama.arif@linux.dev>,
        <chengming.zhou@linux.dev>, <qi.zheng@linux.dev>, <linux-mm@kvack.org>,
        <linux-kernel@vger.kernel.org>, <npache@redhat.com>,
        <ryan.roberts@arm.com>, <dev.jain@arm.com>, <wang.yaxin@zte.com.cn>
Subject: =?UTF-8?B?UmU6IFtQQVRDSCB2MiAyLzJdIG1tL21tX3Nsb3QuaDogY2xlYW4gdXAgbWFjcm8gcGFyYW1ldGVyIG5hbWVzIGluIG1tX3Nsb3RfbG9va3VwKCkgYW5kIG1tX3Nsb3RfaW5zZXJ0KCk=?=
Content-Type: text/plain;
	charset="UTF-8"
X-MAIL:mse-fl1.zte.com.cn 66E0UUjn027130
X-TLS: YES
X-ENVELOPE-SENDER: xu.xin16@zte.com.cn
X-SOURCE-IP: 10.5.228.132 unknown Tue, 14 Jul 2026 08:30:35 +0800
X-CLEAN: YES
X-Fangmail-Anti-Spam-Filtered: true
X-Fangmail-MID-QID: 6A55832B.000/4gzgFR0MLgz5B7RM
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 642DD180010
X-Stat-Signature: twtq3m59pxsadx8hpibpcr9mu87yku41
X-HE-Tag: 1783989047-94078
X-HE-Meta: U2FsdGVkX18/5GCHfj2d8woZVU1OizprWtOMbpW37yGYM2OT3iBj4GAJw1MrIICRqdOs7W2lF54gwALZGqxGXKqFwXB2qLHWQNtah0H4Zl/27CITEnumFU7Y87UPS5BZph/JnVgmeoXavR5tlP/E709zcFqNnsek6047peJT4fj3O7a7iGfkVJCldlrJX1p15HC6/ZIouGTA0BHBC9Nzih9rE6xFkGSGP9Bsp6MZCaoY/9pg2aqOsX+T3G6z0zw6J4A25nLEg+g/MbMzG4saIY1pzRHyy3AXlRj/U1MpxkMyQXd7FG0/B2us+Rv+BF24CT1GkwcHAqZGCXCKgHV2mxHmRIfTU2OnqNOkAIdbPWeYuyRMsjw+OZJrD3L6aXowF3Yv5MSLggt9DkJEbyqzODHG9KA7bKbd2RBeX4kCEqecHQPd0Teeov9pY8fsyJeTQw9ivomYncdODrOpKWS8voYK+UQZIn/3chLLlZsiCH4We47LdfUiHMnu3K4nKQ/wPSToVmu80I+uZV8R/7IhYWivdldHMoIEm8RBO2Gias4q0+tV+JyonGFnRKAjn7Px1DYARu+Yj3ZtEDkvPATR92klvbs1/xbTZC3Y/KsowEU8KoV11b/i+5vdnRfjKclAVTIEXQz8McKvtte8KFTdGTuc2eSPkE7q1p5xWLr+dxtSHUfAyYA6zPbLdxg/IxY4Jk6sCe1DTEeJUko6qm18PuTZrdhLjCrXwZKAQ7LBsg7guoO6Yt47PUJsVr8QP3+pUCTb/zzyuwHbMHhPwObAUSrOsWLIn9W+lfBO9A603Y54gsKgKvDx2ddR+MwHsQxY8zqDhl9wwGFou8ltgMTc74EDBLXzcqk1MTcbq85kqHxzGgs45haDhij6lQpYx81GNOLOE1Doc/q6NKrRH4OCuy+PyNKxhp8FEiZEdz9wT78XZev2zAC3MXAyqbbLaoqlPeRx764B3u7AYTIIGUp
 PX2+U2H5
 KbCy2MOzUq0g7gtU4xiSR1HmS6cYe9SqHUNqIc5/Z9G8QEsVG/UfILRWIdh847mgYMjo1CecGA1iu+5KLUp4DqjmjKEpjLfBRdxPdCeID1LxgM6Hy5Yj6aAhykwUlEvdasEWosUBcRDde+0qwEqU+icCNXz41B6mV7wLrburv7aop7c178jQARC7zfZcjYRZpVOmuKpQ2nS2o9s4+DlEFS+TGDR0xpa1BGZrdytuLGoHAq6ppVNRnl/UmOTxquQrxAb025MUdqsml7fY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> > From: xu xin <xu.xin16@zte.com.cn>
> > 
> 
> No patch description, but the other patch "mm/mm_slot.h: clean up macro
> parameter names in mm_slot_lookup() and mm_slot_insert()" has some.

Oh, my SMTP settings were messed up, so I had to manually paste the patch,
and it just so happened that I left out the description. I guess I should resend it.


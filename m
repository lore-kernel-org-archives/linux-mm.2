Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 22FE5E81BDE
	for <linux-mm@archiver.kernel.org>; Mon,  9 Feb 2026 16:17:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 631CF6B0088; Mon,  9 Feb 2026 11:17:53 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5DBDD6B0089; Mon,  9 Feb 2026 11:17:53 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 515A66B008A; Mon,  9 Feb 2026 11:17:53 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 41F276B0088
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 11:17:53 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id E504D89885
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 16:17:52 +0000 (UTC)
X-FDA: 84425424384.23.914DFF6
Received: from ms.lwn.net (ms.lwn.net [45.79.88.28])
	by imf11.hostedemail.com (Postfix) with ESMTP id 731CE40002
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 16:17:51 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=lwn.net header.s=20201203 header.b=Wlv+zLmI;
	spf=pass (imf11.hostedemail.com: domain of corbet@lwn.net designates 45.79.88.28 as permitted sender) smtp.mailfrom=corbet@lwn.net;
	dmarc=pass (policy=none) header.from=lwn.net
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770653871;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Pfd3fGm/vAqfsIchHA2EWNezDEXJf4wFF2gszkKumO0=;
	b=LAUiHwQ7PnV1Yxc1pMZXubBgUX0vKT8cDdPb8TszR6C/yURAQ2DVhuORt6YawHWV+TXMQ1
	28LSofix30vxPZQjQjdAQmgVSoSD4S5YmvoZEVCyW88W/7vHuHh6bhJFx709sJ14+BJZJZ
	lr9XAOLt8Hsow98EPSGgvZUjGMq2qYI=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=lwn.net header.s=20201203 header.b=Wlv+zLmI;
	spf=pass (imf11.hostedemail.com: domain of corbet@lwn.net designates 45.79.88.28 as permitted sender) smtp.mailfrom=corbet@lwn.net;
	dmarc=pass (policy=none) header.from=lwn.net
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770653871; a=rsa-sha256;
	cv=none;
	b=W+/gcym3A0sq5Vgg9BROWaG1QXv2wjEl1pesXVI1MLXkk4HdTf6pOSMGDwBb/vk86/ZwrT
	Swjy0GbjssXwsDHctfH64mmbz/JlwSYXJ94u+VkwjwLtT3CCMLYFBxFoOo/TJTynR0QbKx
	gGf6NEZOfgSyfcUdqSd2l/Wcgz8kXNI=
DKIM-Filter: OpenDKIM Filter v2.11.0 ms.lwn.net B977040B32
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=lwn.net; s=20201203;
	t=1770653869; bh=Pfd3fGm/vAqfsIchHA2EWNezDEXJf4wFF2gszkKumO0=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=Wlv+zLmIpcF6JHoPlusQsqWcKvNx6BtL3E60/N1ZtKBSx2hwQ44E7JWyCl/A6hLP3
	 2zgdaVfdTyK8TrTjG80xJbLJN+YS86wECoSke8fHGCrMMwktrGKWFr/HiqxAFobAqv
	 fYmYqiBtmO9dzLbaPy23i774XnZTJ7sHZJnjtrt1SHuQo2PdYeVAUP7VWkkwnuPn6s
	 La5AnPFEWn08S70v7myNmZvLXQwK8I1G+ML1FupYOL8Evs9YcB9sWOs/LKOSBLUkHg
	 wUGVI6YlEqzXhYAjnPagAY6aSA/Hp1VZWz8mbd6BSKaR0nTXIdy84AcIqpZQ6teeoh
	 ph1VWpy59YG3Q==
Received: from localhost (unknown [IPv6:2601:280:4600:27b::1fe])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by ms.lwn.net (Postfix) with ESMTPSA id B977040B32;
	Mon,  9 Feb 2026 16:17:49 +0000 (UTC)
From: Jonathan Corbet <corbet@lwn.net>
To: Matthew Wilcox <willy@infradead.org>, Min-Hsun Chang <chmh0624@gmail.com>
Cc: akpm@linux-foundation.org, linux-doc@vger.kernel.org,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, Linus Walleij
 <linus.walleij@linaro.org>
Subject: Re: [PATCH v2] Docs/mm: fix typos and grammar in page_tables.rst
In-Reply-To: <aYoB5JatO60ouaMD@casper.infradead.org>
References: <20260209145603.96664-1-chmh0624@gmail.com>
 <aYoB5JatO60ouaMD@casper.infradead.org>
Date: Mon, 09 Feb 2026 09:17:48 -0700
Message-ID: <875x85ao2b.fsf@trenco.lwn.net>
MIME-Version: 1.0
Content-Type: text/plain
X-Rspamd-Server: rspam12
X-Stat-Signature: ighjbqdaixcha5kzs87fnsk6gwcfrjw7
X-Rspamd-Queue-Id: 731CE40002
X-Rspam-User: 
X-HE-Tag: 1770653871-400701
X-HE-Meta: U2FsdGVkX19YgvpsjHwoujrObiFoNwbBkK42DIe+4EdfF8ogc41IQsu9UDTLZgmVVJLHp91q2PpohmTjUcQVUp0EcbXS29HBDb/U96JLA2dtAr9exDYF3AAjnXKVEVofMlx90H1Xr9B06AouaEu4OVKqurJ3FSRekKvaU+bwopO+sIZ7MwspA/TsKWRIKYWGJpS0Rar0y3p4aTu6UHZjxcKpSSCshrSjUXNIbZ6s1+D83Yj+K+OlLRMY1+KBzMkEcbJYIcRpmtr4AQuZEPd441oHgidWRyODm33s/opRtmpianowrJ3pVmCw3wO+73uiyN3fQ8FAQrSLlP00Y+IvhTKdknoxTRZ0KUgP3DjNYJIfT2O8mRnYOKZwbVVLjadrxrznvX5rEwYsR4ExByhUO4uM6qAjKJNO6zbnKx9pnJQ7F57BUBYlPVh5jg0YKA6OfrD07rzxTfmT65oMb55u8RbkacJLwyEnLiQw+S1BbOKOOhhJAtnUQoIIJfEDsuSfpc1zYICHg1VMYAbLY2zT+2FgGRaLFHi62DahIoNf/18Ez3JILXsTOyw87jWiOz26l9DGNsnVXCkIp8Vm7BiNaqDGkhLnambddo0+G59sLvm8Uu1m3BTTvSLPkr3Y8O2PnXJDIlxLxLeRbY0+HqgdpLLnSTNlxsBAXrJhBuRU2zevt83eesY2xd0bSlTpDgsc8naEZcjFmaULcto8LFRNZhQXUwL0643DCBmy4BVs4d0ZrIkzoKuHUPss3wU0akprk/XXLChKNRM2uiHOpHGVIlxZlqp6GiuIf213s56qA6BA8hi0JRULbe/Jga8Lc42W+wCKKkdNkiGYnJ94Q08O8RvYH0flPtZwTpcI13CWIda3AwPR/3AailvzqfMTqbCuk1Arp8GztNP9fFmgC+JObXpd5vMTt6oZiKBtRRtSltQI5+On5dbHP/Ak1CUReFdPjpBc+dNAA8kNm7qQsF0
 vj+Hx8Ay
 4dFJ/5E5Nr2GuKaC286MF22PTS8UsUsMs0FmFIMrdo2LUVSLaDXf9Q9df+58rj/LnwrI1
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Matthew Wilcox <willy@infradead.org> writes:

>> -the fact that Torvald's first computer had 4MB of physical memory. Entries in
>> -this single table were referred to as *PTE*:s - page table entries.
>> +the fact that Torvalds's first computer had 4MB of physical memory. Entries in
>> +this single table were referred to as *PTEs* - page table entries.
>
> I'm unsure about this change of "*PTE*:s" to "*PTEs*".  Is that special
> rst syntax to keep PTE highlighted without highlighting the 's'?

No, it was just a typo - look how the current version is rendered on
https://docs.kernel.org/mm/page_tables.html.

Thanks,

jon


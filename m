Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 399B7CA0EEB
	for <linux-mm@archiver.kernel.org>; Tue, 19 Aug 2025 12:23:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9E2456B00CC; Tue, 19 Aug 2025 08:23:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 992D86B00CD; Tue, 19 Aug 2025 08:23:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8A8BF6B00CE; Tue, 19 Aug 2025 08:23:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 73F246B00CC
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 08:23:13 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 19DB016078C
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 12:23:13 +0000 (UTC)
X-FDA: 83793421866.24.7969539
Received: from m16.mail.163.com (m16.mail.163.com [117.135.210.5])
	by imf12.hostedemail.com (Postfix) with ESMTP id 2BC5C40005
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 12:23:09 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b="G/lUupuO";
	spf=pass (imf12.hostedemail.com: domain of chizhiling@163.com designates 117.135.210.5 as permitted sender) smtp.mailfrom=chizhiling@163.com;
	dmarc=pass (policy=none) header.from=163.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755606191;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XML5m6XHKtdCDAlB9JUUL64oZubz2drUcUaH/mhajyY=;
	b=Fusyr43xDmCD4B6lj2Hez2szO8+yt4V3EUMsoTO6sidvMGGpeJ2foq4HPN2WzUwz55guC8
	uazSeecKVFxHu4p+1o1NmRBYV7OKKzOD/ZOanoIcAtIaI0hJaEw8fk4MBqvVhkuI8ZmyZJ
	a+yN3mYEf0++nTqlfjWkyA9y0I7Feyw=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b="G/lUupuO";
	spf=pass (imf12.hostedemail.com: domain of chizhiling@163.com designates 117.135.210.5 as permitted sender) smtp.mailfrom=chizhiling@163.com;
	dmarc=pass (policy=none) header.from=163.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755606191; a=rsa-sha256;
	cv=none;
	b=PNnZOAbynf5WcdbSXPTkVtNC7Qw2xoHJFeFDm5xiHXek48reQyedzQODbqWa6ezrfX11tQ
	t5i/IlPHTsNrhoL8BajUnSIDLU3QnvsWyBansQIhAexP7UkOX17C358pXBK1aa03hosO+H
	I7PZka5evJFQP9EFr+AsHz5eBgvC71Q=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=Message-ID:Date:MIME-Version:Subject:To:From:
	Content-Type; bh=XML5m6XHKtdCDAlB9JUUL64oZubz2drUcUaH/mhajyY=;
	b=G/lUupuOjYUya+gk2UT6VYOhHDLWY9lQWtoMPaL09/X+ucvel+ATwE2MzZRu94
	DiPS/eomMWeBhfB8FVkv79u0B8PNRGtZi/EGmvH6JgQ09AiKmUIj9biZpndji1Ei
	AzdCOGqWGa8NzR2jp6ztNHLm3PmuKT1K+VIYOM/hXisbs=
Received: from [10.42.20.201] (unknown [])
	by gzga-smtp-mtada-g1-3 (Coremail) with SMTP id _____wD3v_WSbKRofFI1DA--.58046S2;
	Tue, 19 Aug 2025 20:22:43 +0800 (CST)
Message-ID: <10485bcf-5ccf-4fec-b403-0d895236c131@163.com>
Date: Tue, 19 Aug 2025 20:22:42 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/3] mpage: terminate read-ahead on read error
To: Matthew Wilcox <willy@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-fsdevel@vger.kernel.org,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Alexander Viro <viro@zeniv.linux.org.uk>,
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
 Namjae Jeon <linkinjeon@kernel.org>, Sungjong Seo <sj1557.seo@samsung.com>,
 Yuezhang Mo <yuezhang.mo@sony.com>, Chi Zhiling <chizhiling@kylinos.cn>
References: <20250812072225.181798-1-chizhiling@163.com>
 <20250817194125.921dd351332677e516cc3b53@linux-foundation.org>
 <9b3116ba-0f68-44bb-9ec9-36871fe6096e@163.com>
 <aKM5sUFuOevaG4_i@casper.infradead.org>
Content-Language: en-US
From: Chi Zhiling <chizhiling@163.com>
In-Reply-To: <aKM5sUFuOevaG4_i@casper.infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-CM-TRANSID:_____wD3v_WSbKRofFI1DA--.58046S2
X-Coremail-Antispam: 1Uf129KBjvdXoWrKrykGFy3WFW8ZF45uF18Grg_yoW3ZFc_uF
	sFkanrGw17Kr4xJanxuan0grn0kw4rWry5Gr48Wrn7t345Zr98Xa1Dur9agFZ8Jw42vrZa
	kFs7WrW3G3sFgjkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUvcSsGvfC2KfnxnUUI43ZEXa7IUU4SotUUUUU==
X-Originating-IP: [116.128.244.169]
X-CM-SenderInfo: hfkl6xxlol0wi6rwjhhfrp/xtbBawSunWikZrC5bgAAsR
X-Stat-Signature: jyjtsdf8jih3pqofsspnntir5ckzpaf9
X-Rspam-User: 
X-Rspamd-Queue-Id: 2BC5C40005
X-Rspamd-Server: rspam05
X-HE-Tag: 1755606189-390467
X-HE-Meta: U2FsdGVkX18mQgJq+MaAz454WERkLTFe24Q15eZZnDZPDJNizBsElh1HawynL3cKKRijEkVkOK9W/C0fDDlZNoCGZM/lKa6RrINsQDcItBVrF1Bs8lr6d7RElny8dpuXiFdLtGI8acB3XpA0eMna2mdUjYtaxgg8fQOJYDTeM8bgkfv4koqdFHECdNY/IvwmJu2pgMEEuN21N3YkOB5EK334XYA7sOzOGwXEXNktqHr5sUfFZbUy/UPX+0wTZRnzMtRIYhtas9dgzDYV78rxCYd21wDTHt8Tf+YWFcOI2SafKTx0JDHrLuL6az/b1EuciiPAzpJk4w/JogIBbtVWGxgw0KGV9mBnZhNKbo6MwaVkS9RQkmxPqpjLjzYvQDe6+3BVWFiQSUuB2Ep7ueFSE8HjgJ3cTc1Do4C9trYtUEkcNHEGNC5tuZ5F8wFjRsnVB32GJCl6/MsduoBp82vJnxpx1sIP7UiqY98X6WmawKw1YH4ygEPCtBXdxK5lfqnsLUlp5KmoS2zvjlwYjvmk50kC8M/NQIFRspPdjAWB9bvi14ziVWVnAYqUVCSR4lGGjMLerH72xrNojyRZMbX0Wx8p2A+gvLuXN+Xae+oX9doWhq6QrgExwmWEbBMOf/CGMQ+h2YWbFaVLAbHJ2uJU/46mdKrir54rpPnXA7VA8ZIAiQmOT41qlklBaF9GT50W9au/ow9PLkuszNWEHTiqmVdkwkRfD0G1vAEYjdvQvG5qQ49jFzNvcEf+zC6wPTHSGrU6L4sDPa8IsWr4JaQIyDj29Sjzx6rYUWcbcD5mxp2/OScUDkPDT7lhBXXs2fnC4uiJSAnyrPLHiU7ocsTJaopF1dJBKzZHjv8ztEBA7fZyh52GGJ3f0cSVpMP5Ybp7XoiJ8003P/yIsyW/GmZ6cT2ZQ4okZvWNyaqJo/Z9Y3qUhs29WDauPIerFMiW/C5sWLBwLICzjA51xiKdn33
 MMmuN4dA
 E7hBLvA9uJNZcW0JtpRuRPIHe/MV0UkDctb1rQFRt14C0k64Bu157EfwBprJmesubMTlmWcIt7wESaem4YIoFxMTf3j0aELfoxlMmRHlUjzHb0Vpd23hx0sFlHCX/6cBEilWyisl2x1b2Q3t7ej/wvJUTR4X55EA+dELR2KzEwBqozCuSgMEI14gSWDZ+jZL0PLsHA025d/QFONkrBQDAjnsR50EqXzfv83ti21ILslWqEs7j9Hk/d1dR06kX4kljZh2JbrvvCjymNyqkMcBcPJ8DAzAR6oULGG5Y7EJdC9ib1lg0+5BfMh1WjJwhrDPufLDCQW5AqbEzmxniLLgsQQGEl/4FkXGpSt9qOlKAdULGmPFcXJ7G4e7z+bIaybxyIYcE5a9DL3104Qs=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2025/8/18 22:33, Matthew Wilcox wrote:
> On Mon, Aug 18, 2025 at 06:04:23PM +0800, Chi Zhiling wrote:
>>> Also, boy this is old code.  Basically akpm code from pre-git times.
>>> It was quite innovative back then, but everybody who understood it has
>>> since moved on,  got senile or probably died.  Oh well.
>>
>> Actually, I think this patch is safe, but I'm not sure if we should fix this
>> issue. After all, this code has existed for a long time, and it's quite rare
>> to unplug the device during a copy operation :)
> 
> Converting exfat to use iomap would be a valuable piece of work ...

Yes, this is indeed worthwhile, and exFAT should also be restructured to 
support extents rather than fetching entries one by one.

I estimate this would bring significant performance improvements


Thanks,
Chi Zhiling



Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5427AF506E1
	for <linux-mm@archiver.kernel.org>; Mon, 16 Mar 2026 14:57:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 98DD66B02CE; Mon, 16 Mar 2026 10:57:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 911856B02D0; Mon, 16 Mar 2026 10:57:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 81DA56B02D1; Mon, 16 Mar 2026 10:57:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 6F3B76B02CE
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 10:57:04 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 1EE7DC176F
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 14:57:04 +0000 (UTC)
X-FDA: 84552228768.07.7C957BF
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	by imf10.hostedemail.com (Postfix) with ESMTP id 12A11C000A
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 14:56:59 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=none;
	spf=pass (imf10.hostedemail.com: domain of gutierrez.asier@huawei-partners.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=gutierrez.asier@huawei-partners.com;
	dmarc=pass (policy=quarantine) header.from=huawei-partners.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773673022;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=gHU1LhORBaSIFIwYZJ4G0bVW1M8OYaYhBowsa1Kjtvg=;
	b=fMyxSJx9/ujb0WL5c5K1kXjyiD5dCm/QBpEBdDMJRwy52hq3w3e+l9R6aH0E8Xl8dpSMm9
	XHAenX2d2bzW8U3xMiCPA8ivt7EyE+9ueh5mGgpqHS3P0DG2Jikz/uDic9ywyNscs4w8ca
	da8s5DIJOMYeCOL026aIr4QuPLRv/Ps=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773673022; a=rsa-sha256;
	cv=none;
	b=miQAQUwons9kLaFsJr+kk5TIXCNkWFaQ5kZOFUSx+RxpRFi7Dib5cbEp0r/i49IEiETKsH
	gPIsqTuWRo7BfH3Z/YRwkw1oI6oy4uHsyOWSOrW1TzYDGfHS9fj5I7ks4gecdh3ScqBvKW
	8tVDaSSdhvNkwoD5OXrFw/RP3bvldck=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=none;
	spf=pass (imf10.hostedemail.com: domain of gutierrez.asier@huawei-partners.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=gutierrez.asier@huawei-partners.com;
	dmarc=pass (policy=quarantine) header.from=huawei-partners.com
Received: from mail.maildlp.com (unknown [172.18.224.83])
	by frasgout.his.huawei.com (SkyGuard) with ESMTPS id 4fZJ7P42sszJ4692;
	Mon, 16 Mar 2026 22:56:01 +0800 (CST)
Received: from mscpeml500003.china.huawei.com (unknown [7.188.49.51])
	by mail.maildlp.com (Postfix) with ESMTPS id 2643040569;
	Mon, 16 Mar 2026 22:56:56 +0800 (CST)
Received: from [10.123.123.154] (10.123.123.154) by
 mscpeml500003.china.huawei.com (7.188.49.51) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Mon, 16 Mar 2026 17:56:55 +0300
Message-ID: <224a29a1-13cb-41aa-8736-aebe1023fb7d@huawei-partners.com>
Date: Mon, 16 Mar 2026 17:56:55 +0300
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1 1/1] Docs/mm/damon: Document DAMON actions when
 TRANSPARENT_HUGEPAGE is off
To: SeongJae Park <sj@kernel.org>
CC: <artem.kuzin@huawei.com>, <stepanov.anatoly@huawei.com>,
	<wangkefeng.wang@huawei.com>, <yanquanmin1@huawei.com>, <zuoze1@huawei.com>,
	<damon@lists.linux.dev>, <akpm@linux-foundation.org>, <ljs@kernel.org>,
	<Liam.Howlett@oracle.com>, <vbabka@kernel.org>, <rppt@kernel.org>,
	<surenb@google.com>, <mhocko@suse.com>, <corbet@lwn.net>,
	<skhan@linuxfoundation.org>, <linux-doc@vger.kernel.org>,
	<linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>
References: <20260316144848.99972-1-sj@kernel.org>
Content-Language: en-US
From: Gutierrez Asier <gutierrez.asier@huawei-partners.com>
In-Reply-To: <20260316144848.99972-1-sj@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.123.123.154]
X-ClientProxiedBy: mscpeml500004.china.huawei.com (7.188.26.250) To
 mscpeml500003.china.huawei.com (7.188.49.51)
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 12A11C000A
X-Stat-Signature: z4qn4hysfbrpx5emzrxsfkrk9jrcn1z9
X-HE-Tag: 1773673019-66951
X-HE-Meta: U2FsdGVkX189M1WkpkTrhXpYl6qFCajb8mbci/VviWh2uaQ+t9cc2urJz6rgOj/p1yblR0AQpBSG+x4DVTFKmrZBL8lW5/PDTVXGwsc6hk+jhBq4mod/welsAgzgWfLG6Vtcpto9Ny7G18E0w43fLS6imKtT5Cju+UDRi9/HfjF1MV51agG2zsE1XIqtDHRolvLAI3dRTHMEtdbvwS1e6ShVVXK1vOciMUjbz5wHNFPSo2ESanP/21sldqJ26PjVqdKfo+WIvgPufhHnT1kpHMhFCPA88z//erLn3hmR1hmYLi71O4rc8BUZ6cMSaRuT7xvCMMDdDJ+4Xub5zvLGFGDsCbxSPHJInaW2LIJZMqQy62WdGCmkAJhDcWpXrWcD3H3RCnebA89ClK4IddnXCRYiDE9QVXssK0bjvYHIFXE8SATZZaWVq6v4rJPdZ/Iho5GMJ3Ms/OpUYGsR2B0Zqg5vyx9kNRXZvcs9ExAxhWR1UZBb9vP3ueN02F98GiE/gljKaVa9pbg62/S1IF4FuJwZeY0edJ2Gv+wLl1QZJoDqmbjGYoZO92PeXnbwtp6z0uQEgpbcGmnBOEsQziFnaKSSwVuTziwholMlepMFXbdisJdUhveFK2CP304Z9yBSyBNFDsY+p/FgUUMdIObJPuIRYjb8HaYELyFV0cK2UaPqENaoKJRX6zgD5J9BT/I2C2RasaQ8atHGCsCayGvnP45PydiHULfC3kQec70FcUe9tGlrlOli95nbpk8eSGjgq02qAK0d4EZAqH/ZeYs8xTiSkBq2knstNlxhsHSrHryWr7ER9JbHJgFDUn5VROo9QYicojcUtGZNMjgCruBRP0NlgQ/+ZR8rdYo68AwAT2clw6kiJQkNUssGJ4OW0x3a6u8XqGeT4S+icw05HOlvO2xddoAJ/AaehlA5JTdjqIah4xQhQ/zbGAOUr2yef7+Nn0TT6PLwQmzmhtBtVB1
 Vtw125kC
 Sa5SKfQ1gEHiEa9yvvuO30SVBDdIsiaSZ6KeqIE5k87S+2de9/IYn/L6p7uyOSZ5ESUgSy3+PGOGhS0p9P/0zQnmk5K+BI+zJhLONJ3JdG/Rd4cIFWmdixoBgnI73BY4Q5iGOaa4wyrgWUezqo1vIl+Rx0AX3bocUONFRu7Kwax7raBqjygfDIP5wzc/Qwi3rF6pivEstzBf7O9hJFBJhgKvM608N08dJ/vn//fjk8TOu8+60RAmLGBDj7rgXKAEl4J7+v8hkdH8Fvn322QB6+/o0PMFMi27+Vl0QFMB4RALocdPEYhocDL+5UQL9t0IkMnXKpwlJdK4EjkzqJmo2a/1IYh/aL7P5r4N4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi SJ,

On 3/16/2026 5:48 PM, SeongJae Park wrote:
> Hello Asier,
> 
> 
> Thank you for sending this patch. :)
> 
> On Mon, 16 Mar 2026 14:08:21 +0000 <gutierrez.asier@huawei-partners.com> wrote:
> 
>> From: Asier Gutierrez <gutierrez.asier@huawei-partners.com>
>>
>> MADV_HUGEPAGE and MADV_NOHUGEPAGE are guarded and they
>> are not available when compiling the kernel without TRANSPARENT_HUGEPAGE
>> option. The DAMON behaviour is to silently fail[1] in when DAMOS_HUGEPAGE or
> 
> checkpatch.pl shows a warning for the above line:
> 
>     WARNING: Prefer a maximum 75 chars per line (possible unwrapped commit description?)
>     #12:
>     option. The DAMON behaviour is to silently fail[1] in when DAMOS_HUGEPAGE or

Yes, this is due to the link. I tried to keep this patch compact, without a
cover letter. I will submit a new version without the link.

>> DAMOS_NOHUGEPAGE are used, but TRANSPARENT_HUGEPAGE is disabled. Update the
>> DAMON documentation to reflect this behaviour.
>>
>> [1]: https://lore.kernel.org/damon/66131775-180b-4b9f-b7ce-61a3e077b6e6@huawei-partners.com/T/#m278d3c9bbedcceaf2efa51e3dc7b40a40654e51c
>>
>> Signed-off-by: Asier Gutierrez <gutierrez.asier@huawei-partners.com>
> 
> Reviewed-by: SeongJae Park <sj@kernel.org>
> 
> Andrew might add this to mm.git while fixing the checkpatch warning on his own.
> Let's give time for Andrew today.
> 
> I also added this to damon/next tree after fixing the warning.  If Andrew
> doesn't pick this with the fix today, I will post mine as v2 of this patch
> tomorrow.  If you prefer to do the v2 posting on your own, just let me know :)
> 
> 
> Thanks,
> SJ
> 
> [...]
> 

-- 
Asier Gutierrez
Huawei



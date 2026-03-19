Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B67FD1088E64
	for <linux-mm@archiver.kernel.org>; Thu, 19 Mar 2026 02:13:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C1EB96B03AF; Wed, 18 Mar 2026 22:13:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BCFC06B03B0; Wed, 18 Mar 2026 22:13:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AE5266B03B1; Wed, 18 Mar 2026 22:13:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A04976B03AF
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 22:13:48 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 5B068160302
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 02:13:48 +0000 (UTC)
X-FDA: 84561191736.04.F356E9C
Received: from outbound.baidu.com (mx20.baidu.com [111.202.115.85])
	by imf25.hostedemail.com (Postfix) with SMTP id 23015A000B
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 02:13:42 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=baidu.com header.s=selector1 header.b=LpB03TEw;
	spf=pass (imf25.hostedemail.com: domain of "prvs=md1532F6E9FC=lirongqing@baidu.com" designates 111.202.115.85 as permitted sender) smtp.mailfrom="prvs=md1532F6E9FC=lirongqing@baidu.com";
	dmarc=pass (policy=quarantine) header.from=baidu.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773886426;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EgHH7qOY5jxBVpQbBidFr5NKADpALlAllzw4hcL8fBU=;
	b=J6QwoaU9D+xm1QZ4VWOlfXYTue5sEG+GJfCu3ZnbSq4OGz+Ueh4erB44oyeVU/xWtUacfe
	iP6F80FjShnp2vv2Mp2lq84Q+k6hfFt84AK2uqIV9vIFklLcq5fWWB8mhyxXprKuj7Cuut
	Oxvy+HdOEchi2UyCv4xlrWX7DC3Eoow=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=baidu.com header.s=selector1 header.b=LpB03TEw;
	spf=pass (imf25.hostedemail.com: domain of "prvs=md1532F6E9FC=lirongqing@baidu.com" designates 111.202.115.85 as permitted sender) smtp.mailfrom="prvs=md1532F6E9FC=lirongqing@baidu.com";
	dmarc=pass (policy=quarantine) header.from=baidu.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773886426; a=rsa-sha256;
	cv=none;
	b=Xq1624kkDq9nYjjFTLqtvN4B1pv1RdCDbzgHOtBtQKYgN3XrFuvAmr2C7UYG2Rsy2pEmcT
	kJmofoZoiJq7u23kPInR0YCVFhY1UQ3abeI/PHAm/rKMAzrryfnC8rAb8VwFRmkJNvxkmW
	MbSA9tZeoYQR+cHpUZHMlXNMxJx9mdw=
X-MD-Sfrom: lirongqing@baidu.com
X-MD-SrcIP: 172.31.50.48
From: "Li,Rongqing(ACG CCN)" <lirongqing@baidu.com>
To: Uladzislau Rezki <urezki@gmail.com>
CC: Andrew Morton <akpm@linux-foundation.org>, "linux-mm@kvack.org"
	<linux-mm@kvack.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>
Subject: =?gb2312?B?tPC4tDogWz8/Pz9dIFJlOiBbUEFUQ0hdIG1tL3ZtYWxsb2M6IHVzZSB1bmJv?=
 =?gb2312?Q?und_workqueue_for_vmap_area_draining?=
Thread-Topic: [????] Re: [PATCH] mm/vmalloc: use unbound workqueue for vmap
 area draining
Thread-Index: AQHctqn2PFcTqY3na0KXpgTZ+bdNx7W0EXKAgAENExA=
Date: Thu, 19 Mar 2026 02:13:38 +0000
Message-ID: <f490b901efc241efa4f581cda6123d39@baidu.com>
References: <20260318073630.2325-1-lirongqing@baidu.com>
 <abrqe7WDcbvzvrqt@milan>
In-Reply-To: <abrqe7WDcbvzvrqt@milan>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-originating-ip: [10.127.72.29]
Content-Type: text/plain; charset="gb2312"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=baidu.com;
	s=selector1; t=1773886420;
	bh=EgHH7qOY5jxBVpQbBidFr5NKADpALlAllzw4hcL8fBU=;
	h=From:To:CC:Subject:Date:Message-ID:Content-Type;
	b=LpB03TEwrTBrtCAUCmcBxFl/b7CBQ/gGmF0cxLEqfxDbSlcatXzDPr+/8In2uGnnf
	 C1oNXV8gkVRyWISNCeNIHwXC5yd6+uP4D43Y+LL1gVQ2//pji+tRc07Vwu15sXxCtY
	 nIdSbpbcRkjq6ahrSiRqCFTlpnB9ruS+PQgAN7nlQaWdGBzanekDZH/nwjR6BokcHw
	 n9u+RpbVg7uMuDREjDlRQI0ved6hTAjqg8o87HT+JkRnXw+g76vmbuGDNT6NxGQmFC
	 sI2lyqsHilDwwraxYziICDyxYqvAuoV7apSJYCsa2L9TqP2MEjo06O6cjgCuW1Naeb
	 Bbr+JuqqRXt6Q==
X-Stat-Signature: rhfhuqrbctt5bb46z34z8nuksfjrdepk
X-Rspamd-Server: rspam09
X-Rspam-User: 
X-Rspamd-Queue-Id: 23015A000B
X-HE-Tag: 1773886422-27139
X-HE-Meta: U2FsdGVkX19T5Fib4xjJMaWPoG65PYO/B72gpGCayaSbDjR95gUryS3QagQgMHMkXkJ0DA5djhRL3OUHwbhYrArjVb8m796rzRSlenZlUnyagE8Plj2FwFZ/mcLt9ARLwnW4SHeo9Lgp/j10NtNeVtEIKrZeEBMsekb6OW888WsG8DeJCOUxiYnCFFOgxBOqHVq0v5hx6tHg0urzeS3n0lORj+S1DWj/BVAf56cQvkwk8QjbDEtZaO32mhMWDpQVt0ghmJTCHQEIPbumiYW/UcUd9osNF+FsW3fOgpuLb1Sw+IhHFDDFSzKqQ6rH/vG3FvpOalCqezzGYTifknU0AWgFdVKqQvWUjNWqYEWrYtImhPyqHpu9BtBK3M7cmHsOw8SsD5bKZiPryriLxR8CNirdh+I95LmiEyOfvUCB7uCjkSfHb6csXX6j4BUqeEIl90NiXaM2t11OHTSx6JOJlDAuF4GzJuiHBZO8qw5kmsZSp2mEb1Ao+Cu/wdtUXmvWVUESCLStzSQfIW271BOa25yB61aG8emW8/c9mXHTHlxFiyGaRYDR2Mg4kmriuPxuoFp0bevJ9shiqN2jWZ5yRKFGv6QnSCSyfJMxD3xUwkZC40yLMOLMoJjoV8FWvyEuzSPaNtK0VGKcCZuaUWpRFfkgDVGtZeFz2T+VjuDx8kiTTtZFQpa0hNbzbaNbMcBZ6XmaVHB9/8SmjmqEOYfzq51AsaX0xEo7jjrIotkoptISXpalG0GEEiLO+6iwBS+QlnCBQFRaN5JKL/EkKY1jOMKwZ+4LdaoYd22FOIzi9P1gsguSereyzokVX1NnHWYRpeQ3gz26qu936Nyd85fYry+b+F8hf7nH0VnWAGT/ZgIbgs0+v2enV05xamu/xsv8dcRuOo9osM72ddBBw2ccm1GwiMK8+la5suIP3QVy4u2JVuIDgIpeHIbjNT7UYcU7iGcMbHq3WEdhrGU20RT
 3u2EoLBP
 oOxdMIbjxTZ0lu+/VVGl9+yRVeHyoWrKZ3Ofm5hYXXDNnDEsBRzU94s5df9hfvs8Q74adQqUY1vIegEolpvMqgxo3GN5N0jGso23gH+kt6/EIjwmmwWwDleBdZWtIy4ySeAody7ur9Qe5v/G/gjZrJZ8ZylH+FYnMTz/8HgdMjzrYFKaCnxFlCqgwpkQrJi88wBsxX7/2x/TWgsYbKYvIBTRh3WhCbDsljokQuPsG4DqBcDj+Z3zd2NVWqmsOgQ+OkgEtuuVRhzR13nq8Dbu7x1oVpf1sCj5Mv7RWMQ28HYO0i4kt7oUEJU3k0XNB9u4+DrFr6SgeE6pRTgrD/yXLp1N92P7+2SyCqk5Jxd4KlaGWBCeyicwEAM5Y8git3Knw9oCQ442KZ+PBPJxApRIIvD5RL7L7Zr/7bPYWJVI1JJkAvnOfLmEmxc6qwOEMLObQhpn7MolvQjknhaT9Pu2IU9OoSEYE3WvmmHM0AS8ceMQScsj1IQPCP0V7aJJwW3N+Imo6PIQTDp4osacZUN2L8ITOHkLueBVuVTa6jIKRNnhmxUCYyK2TOZW3wjtjirjrvnfrHmI0CDo/2ICEzp8upZni8Y/QNaoM4mXenVcuOrZcy0wL/sXfHgHVSww0m/mdtvaP
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

PiA+IC0tDQo+ID4gMi45LjQNCj4gPg0KPiBXZSBmcmVlIG1lbW9yeSBoZXJlLiBUaGVyZWZvcmUg
aXQgaXMgdGltZSB0byBzd2l0Y2ggdG8gb3VyIG93biB3b3JrcXVldWUNCj4gd2l0aCBXUV9NRU1f
UkVDTEFJTSB8IFdRX1VOQk9VTkQgZmxhZ3MuDQo+IA0KDQpPaywgSSB3aWxsIHNlbmQgdjINCg0K
VGhhbmtzDQoNCltMaSxSb25ncWluZ10gDQo=


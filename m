Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 33A74606A321
	for <linux-mm@archiver.kernel.org>; Thu, 26 Nov 2026 11:05:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 54AFA6B05B0; Thu, 26 Nov 2026 06:05:00 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 522C16B05B1; Thu, 26 Nov 2026 06:05:00 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 438356B05B2; Thu, 26 Nov 2026 06:05:00 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 249286B05B0
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 06:05:00 -0500 (EST)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id A800B1C418E
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 11:04:59 +0000 (UTC)
X-FDA: 85476987918.10.04CC44B
Received: from zg8tmtyylji0my4xnjqumte4.icoremail.net (zg8tmtyylji0my4xnjqumte4.icoremail.net [162.243.164.118])
	by imf02.hostedemail.com (Postfix) with ESMTP id A670F8000E
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 11:04:54 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=none;
	spf=pass (imf02.hostedemail.com: domain of yangyizhen3198@phytium.com.cn designates 162.243.164.118 as permitted sender) smtp.mailfrom=yangyizhen3198@phytium.com.cn;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795691097;
	b=w/xKNwdx/iB7tqB+YpL5cN9ZSuUH7KHcLxjJWPKn+lSJfqaCxxMeEg6Vdtkbv3HdLOJjnZ
	EP9bywdzxJHgE9EFAMGgDewsTZhvH8tZMvhqdl+3wwxRVi+JVAtUY6rXIo4vWzD+OORDtp
	KN+J5CZlQqAYoLNMDVcvwShw2QWeBR4=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795691097;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=7WZrC5amErdAZUKH3zA00f9ty+dy4dlRNgU1aieOoRU=;
	b=S2cjIWi1UVxncxeYo35L4N7VJq+yTL483qOYrUgeRbay7DOqv3Pwh1fHGfeMtc6p9bHZVb
	+s4Gg0b+NoDj1x90FqR5u8Mj88xdng4vdF11iUH991SGPjFZPp52ZWaj7+d+23tv5n0tJk
	Zt6XicAUX00pyNnB6dHK/mm37HHEX/4=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=none;
	spf=pass (imf02.hostedemail.com: domain of yangyizhen3198@phytium.com.cn designates 162.243.164.118 as permitted sender) smtp.mailfrom=yangyizhen3198@phytium.com.cn;
	dmarc=none
Received: from prodtpl.icoremail.net (unknown [10.12.1.20])
	by hzbj-icmmx-6 (Coremail) with UTF8SMTP id AQAAfwAHXt1TEghrtjkqAg--.9133S2;
	Thu, 26 Nov 2026 19:04:51 +0800 (CST)
Received: from yangyizhen3198$phytium.com.cn ( [218.76.62.144] ) by
 ajax-webmail-mail (Coremail) ; Thu, 26 Nov 2026 19:04:50 +0800 (GMT+08:00)
Date: Thu, 26 Nov 2026 19:04:50 +0800 (GMT+08:00)
X-CM-HeaderCharset: UTF-8
From: =?UTF-8?B?5p2o6L2255SE?= <yangyizhen3198@phytium.com.cn>
To: "Christian Brauner" <brauner@kernel.org>
Cc: "Jens Axboe" <axboe@kernel.dk>,
	"Alexander Viro" <viro@zeniv.linux.org.uk>,
	"Jan Kara" <jack@suse.cz>, linux-block@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: Re: [RFC PATCH 0/1] block: long udev open waits during cache
 teardown
X-Priority: 3
X-Mailer: Coremail Webmail Server Version 2024.3-cmXT6 build
 20250512(e7b47ee3) Copyright (c) 2002-2026 www.mailtech.cn OP_ICM_ICMVM
In-Reply-To: <20261120-hassliebe-arena-kaufvertrag-3ac58fd0483a@brauner>
References: <20261117105107.14236-1-yangyizhen3198@phytium.com.cn>
 <20261120-hassliebe-arena-kaufvertrag-3ac58fd0483a@brauner>
Content-Transfer-Encoding: base64
X-CM-CTRLDATA: Lc7SY2Zvb3Rlcl90eHQ9MTM4NzozODM=
Content-Type: text/plain; charset=UTF-8
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Message-ID: <4effe3b8.6085.1a217879319.Coremail.yangyizhen3198@phytium.com.cn>
X-Coremail-Locale: zh_CN
X-CM-TRANSID:AQAAf8Dw8nVSEghrOBUAAQ--.52298W
X-CM-SenderInfo: 51dqw5pl2kv0atrzmqxsk13x1xpou0fpof0/1tbiAQALDWsHN0wEe
	QABss
X-Coremail-Antispam: 1Uk129KBjvJXoWxZw4xXr18Zr4rAF1xtrWkWFg_yoWrXryUp3
	W8t3W8Aw1UGw17G3ySgw18ZryUC3yUGr47Ja10y3sFywnrJrnIqrnxKFW8J3WjgFyYyrWD
	tw17Z398Xr1UtrUanT9S1TB71UUUUUDqnTZGkaVYY2UrUUUUj1kv1TuYvTs0mT0YCTnIWj
	DUYxn0WfASr-VFAU7a7-sFnT9fnUUIcSsGvfJ3UbIYCTnIWIevJa73UjIFyTuYvj4RJUUU
	UUUUU
X-Rspam-User:
X-Rspamd-Queue-Id: A670F8000E
X-Stat-Signature: pskf6kfucdxzufzwhqumg9u941hwqbyr
X-Rspamd-Server: rspam12
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=no autolearn_force=no version=4.0.1
X-HE-Tag: 1795691094-173694
X-HE-Meta: U2FsdGVkX19ITHqAm/cxwXvlX0L/C3Kfm9+EkRPkjZ2tEsUsA/VwwnS92ripIg6jXLUjhwpxaelK2YzBbeB8ePf0euNna6Tru8fE0O8cvA0kcmCQE28iBjaKN+EdniDq7FzPRI82Nllms2dG9JpzkRgKfsf/7rMqXfCr+BsIYaU0DzBI7lznNEr5OfSJlvJH3n+947UH260VOkH48gERluA2kFqrSN9x/yvUDHlnBpA6c1NFg5xqCh/r8u2FoWkWkhk8QNOUyyKNVYlYxVKPzxrTFWeArDlDiJR4qKrMvBmvOM05GaxMKwfJOynpThw6cWPx6wajeAQcKGdglJ3YIAPt1jY5cAjE7S62QYA1Bk7PuoB0fsbnDdqmHE1HXR0SE+0kjnKWdM01ozpmwdwpiAQNzLTrnZ/mtasoF2XQKY0o8AVdUx7pjjMHG59SStZcVl8KGI0xomUmDiWW2AplcmwYHi1j25enp2Ws8hyfJOQzLaZ52Mh9iOECgeh6bDh9VEr5PxkIr4Tl4UdmJEMlztjcCx7zYsHdAxAfODYlfZrOt+SwcQz7sXKATanReOUWcz86LkcyVX4m31izwa4DPaPzrXGlOFPCJl3Ef3BWSdiEjhQ9AD6MpJqv4kNY5+IlNddB7Lp5yOzyJz+L4g+CvIn6jG3LA8QRe1ikw0WQT8W3jbsHzNqx2/4HXtqEW0l2XiC+jAdh47gQuURUTDHqZlaSuwX7t74CkcwJvlltO0kA2TSbSZZ0NZFO/ZQVjiH3yCdjsqGBAd6FvdR/cTrTQn9UtE8pn9pXZkj6tNX1CQNLjOiMZdHESjC5YCFGk77HibV/ZAiqZCGNCINqBqYr4CqtAP00yAevLm8eSzzEaUUzIjukcjmJn7VsUramho4hXbD11STfWeWm8DyzKMxxNGtA3GY9/1bPd8Anm8JzFdQI4FySbIJ9aprPtrSYk7deOPfS9PFsEawJxCBL15W
 aYrgTnzp
 8Hdmtn5f0wm2VXQIB8bqSHOVPJQ3ye9UzdFz47ijIqnRjFJ4YuxZCLkCVRE1ZOL4jSljKHdKzkOWnnCaXfB8Va0co58cqH+83QuvRc3f2emPIK8WBqP2XYR5YhVJ5zbK5hFq/xWdV/Rq/DD2t60uTFGOAm79MXjrety2Pg8yVjxiqukIRMHckaj4m85db6mucjsO02ratoh163cL2mT/LdkFn1ETryNWOCO6gVRcb5zG92rNomKfkmso+GLHSOiahjzQc6H/9C+yQ1dPxCwSYVQ5kd52Qc1aTbzUeIzJD+XgMecDwWNF/HqQ2VF2iuqMyoJjFKmfcjoW2OmZmspr9RFdYUEeXVxOPuAYHv26oqaRd4E0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

SGkgQ2hyaXN0aWFuLAoKPiBJZiB0aGF0IHN0aWxsIHJlcHJvZHVjZXMgb24gbWFpbmxpbmUgaXQn
cyBhIHF1ZXN0aW9uCj4gYWJvdXQgdGhlIGJkZXYgcmVsZWFzZSBsb2NraW5nLgoKSSByZXByb2R1
Y2VkIHRoZSBsb25nIHVkZXYgb3BlbiB3YWl0IG9uIHVwc3RyZWFtIExpbnV4IHY2LjYgYW5kIG9u
CkxpbnV4IHY3LjAuMTQuIE9uIGJvdGgga2VybmVscywgdWRldiBibG9ja2VkIHdoaWxlIHRyeWlu
ZyB0byBvcGVuIHRoZQpkZXZpY2UgYXMgbWtmcy5udGZzIHdhcyBjbG9zaW5nIGl0IGFmdGVyIGEg
ZnVsbCBmb3JtYXQuCgpUaGFua3MgZm9yIHBvaW50aW5nIG91dCB0aGUgaW1wYWN0IG9uIG90aGVy
IG9wZW5lcnMuIEkgYWdyZWUgdGhhdCBhCnVkZXYgcHJvYmUgY2xvc2luZyBpdHMgb3duIGZpbGUg
Y291bGQgdHJpZ2dlciB3cml0ZWJhY2sgYW5kIGV2aWN0CmNhY2hlIHRoYXQgYW5vdGhlciBvcGVu
ZXIgaXMgc3RpbGwgdXNpbmcuIEknbGwgZHJvcCB0aGUgX19mcHV0KCkKcHJvcG9zYWwuCgpJJ2Qg
bGlrZSB0byB1bmRlcnN0YW5kIHRoZSBsb2NraW5nIHJlcXVpcmVtZW50cyBpbiB0aGUgYmxvY2sg
ZGV2aWNlCmxhc3QtY2xvc2UgcGF0aC4gSW4gcGFydGljdWxhciwgd2h5IGRvZXMga2lsbF9iZGV2
KCkgbmVlZCB0byBjb21wbGV0ZQp3aGlsZSBvcGVuX211dGV4IGlzIGhlbGQ/IFdoYXQgc3RhdGUg
YW5kIG9yZGVyaW5nIHJlcXVpcmVtZW50cyBkb2VzCnRoZSBsb2NrIHByb3RlY3QgZHVyaW5nIHRo
aXMgY2xlYW51cD8KCkknbSBhc2tpbmcgYmVjYXVzZSB0aGUgZGV2aWNlIG1hcHBpbmcgY2FuIHN0
aWxsIGNvbnRhaW4gYSBsYXJnZQphbW91bnQgb2YgY2xlYW4gcGFnZSBjYWNoZSBhZnRlciB0aGUg
ZWFybHkgc3luYy4gSW4gbXkgdGVzdHMgb24gdGhlCnZlbmRvciA2LjYga2VybmVsLCBhYm91dCA4
MDUgR2lCIHJlbWFpbmVkIGF0IGZpbmFsIHRlYXJkb3duLCBhbmQKdGhlIHRydW5jYXRlIHRvb2sg
cm91Z2hseSBzZXZlbiBtaW51dGVzIHdoaWxlIHVkZXYgd2FzIHdhaXRpbmcuCkNvdWxkIHRoZSBy
ZWxlYXNlIHBhdGggYmUgY2hhbmdlZCB0byByZWR1Y2UgdGhlIHRpbWUgb3Blbl9tdXRleCBpcwpo
ZWxkIHdoaWxlIHByZXNlcnZpbmcgdGhvc2UgcmVxdWlyZW1lbnRzPwoKPiBBbmQgbWtmcyBjYW4g
anVzdCBmc3luYygpIGFuZCBQT1NJWF9GQURWX0RPTlRORUVEIHRoZSBkZXZpY2UgaXRzZWxmCj4g
YmVmb3JlIGl0IGNsb3NlcyBpdC4KCkkndmUgc3VibWl0dGVkIGEgcGF0Y2ggdG8gdGhlIG50ZnMt
M2cgcHJvamVjdCB0aGF0IGNhbGxzIGZzeW5jKCkKYW5kIHRoZW4gcG9zaXhfZmFkdmlzZSguLi4s
IFBPU0lYX0ZBRFZfRE9OVE5FRUQpIGluIHVzZXJzcGFjZQpiZWZvcmUgY2xvc2luZyB0aGUgZGV2
aWNlLgoKVGhhbmtzLApFdGhhbg0KDQrkv6Hmga/lronlhajlo7DmmI7vvJrmnKzpgq7ku7bljIXl
kKvkv6Hmga/lvZLlj5Hku7bkurrmiYDlnKjnu4Tnu4fmiYDmnIks5Y+R5Lu25Lq65omA5Zyo57uE
57uH5a+56K+l6YKu5Lu25oul5pyJ5omA5pyJ5p2D5Yip44CC6K+35o6l5pS26ICF5rOo5oSP5L+d
5a+GLOacque7j+WPkeS7tuS6uuS5pumdouiuuOWPryzkuI3lvpflkJHku7vkvZXnrKzkuInmlrnn
u4Tnu4flkozkuKrkurrpgI/pnLLmnKzpgq7ku7bmiYDlkKvkv6Hmga/jgIINCkluZm9ybWF0aW9u
IFNlY3VyaXR5IE5vdGljZTogVGhlIGluZm9ybWF0aW9uIGNvbnRhaW5lZCBpbiB0aGlzIG1haWwg
aXMgc29sZWx5IHByb3BlcnR5IG9mIHRoZSBzZW5kZXIncyBvcmdhbml6YXRpb24uVGhpcyBtYWls
IGNvbW11bmljYXRpb24gaXMgY29uZmlkZW50aWFsLlJlY2lwaWVudHMgbmFtZWQgYWJvdmUgYXJl
IG9ibGlnYXRlZCB0byBtYWludGFpbiBzZWNyZWN5IGFuZCBhcmUgbm90IHBlcm1pdHRlZCB0byBk
aXNjbG9zZSB0aGUgY29udGVudHMgb2YgdGhpcyBjb21tdW5pY2F0aW9uIHRvIG90aGVycy4=



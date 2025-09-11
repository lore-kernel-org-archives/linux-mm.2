Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 410C1CAC58E
	for <linux-mm@archiver.kernel.org>; Thu, 11 Sep 2025 15:04:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7C6678E0009; Thu, 11 Sep 2025 11:04:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7769B8E0001; Thu, 11 Sep 2025 11:04:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 665228E0009; Thu, 11 Sep 2025 11:04:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 500D88E0001
	for <linux-mm@kvack.org>; Thu, 11 Sep 2025 11:04:15 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 21F8FB9B56
	for <linux-mm@kvack.org>; Thu, 11 Sep 2025 15:04:15 +0000 (UTC)
X-FDA: 83877290070.26.B91FC77
Received: from m16.mail.163.com (m16.mail.163.com [117.135.210.5])
	by imf22.hostedemail.com (Postfix) with ESMTP id 23600C0013
	for <linux-mm@kvack.org>; Thu, 11 Sep 2025 15:04:10 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=fail ("body hash did not verify") header.d=163.com header.s=s110527 header.b="K oO2UY5";
	spf=pass (imf22.hostedemail.com: domain of 00107082@163.com designates 117.135.210.5 as permitted sender) smtp.mailfrom=00107082@163.com;
	dmarc=pass (policy=none) header.from=163.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757603053;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=R9HM9zIlGy82epQdECWeMo8XaOByczUIim9micFq2Ic=;
	b=8WNeVeQAF9+zxF2PKMOFjc13OTTJzNgyVJOuhI+LlgAE+jLSU7CyTiKNH0gKo70x4bv8SB
	rBE2vCH8fWhk0zSX8ETUYccf+tH2zBR2/jDtTERQFlN8XILf70elnkq0bU33A5/CpYLzgN
	pNpfoYSUjEMtrtLy2YzTUdHsF0YC2pA=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=fail ("body hash did not verify") header.d=163.com header.s=s110527 header.b="K oO2UY5";
	spf=pass (imf22.hostedemail.com: domain of 00107082@163.com designates 117.135.210.5 as permitted sender) smtp.mailfrom=00107082@163.com;
	dmarc=pass (policy=none) header.from=163.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757603053; a=rsa-sha256;
	cv=none;
	b=rvoHdeEbGrl2gXiUzbDsQi3Jgl+Sk77OOTeD0PT9i+y26XU7SMD0FT86bnCdClNyhuyJJs
	8aUy/tF3lLKWwwA1+gN+VNNsBWWxSIHmEaq8S+IyHOl18jxwMrObMQWZhydLxlIVHZ/gAq
	jTLO7WFk910SPITwxBhqbhFegP8h8Kk=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=Date:From:To:Subject:Content-Type:MIME-Version:
	Message-ID; bh=zT13f5E8NapKoHf1bvUnYWcJqBwdVmg+t2G4vMoo2nk=; b=K
	oO2UY5t+ZDFloK72DQPnCscC5fZRfRTy9f1PLz6QspKCK8VxHA6Qm7VWugpA1XC9
	fj2O4XtqiERgCL+97vlqAaoZWj+BUWPZuwBCDwxwfZxpjYP/XqIvdg3YRtpRQrYs
	72bh32IifnaEIF956GpPoz0x9ri6MDLf7YJjqP1qgU=
Received: from 00107082$163.com ( [111.35.190.173] ) by
 ajax-webmail-wmsvr-40-122 (Coremail) ; Thu, 11 Sep 2025 23:03:50 +0800
 (CST)
X-Originating-IP: [111.35.190.173]
Date: Thu, 11 Sep 2025 23:03:50 +0800 (CST)
From: "David Wang" <00107082@163.com>
To: "Suren Baghdasaryan" <surenb@google.com>
Cc: akpm@linux-foundation.org, kent.overstreet@linux.dev, vbabka@suse.cz,
	hannes@cmpxchg.org, usamaarif642@gmail.com, rientjes@google.com,
	roman.gushchin@linux.dev, harry.yoo@oracle.com,
	shakeel.butt@linux.dev, pasha.tatashin@soleen.com,
	souravpanda@google.com, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re:[PATCH 1/1] alloc_tag: mark inaccurate allocation counters in
 /proc/allocinfo output
X-Priority: 3
X-Mailer: Coremail Webmail Server Version 2023.4-cmXT build
 20250723(a044bf12) Copyright (c) 2002-2025 www.mailtech.cn 163com
In-Reply-To: <20250909234942.1104356-1-surenb@google.com>
References: <20250909234942.1104356-1-surenb@google.com>
X-NTES-SC: AL_Qu2eBfqbvEgo5iCQYOkZnEYQheY4XMKyuPkg1YJXOp80qSTW1A0GU1FlInXn6t6RBSGwlyeUcjhi6ehqfah2XYRFpFuYvfayCeL9QuJ6t6c1
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset=GBK
MIME-Version: 1.0
Message-ID: <20cafc1c.a658.199394de44e.Coremail.00107082@163.com>
X-Coremail-Locale: zh_CN
X-CM-TRANSID:eigvCgD3P2zX5MJoXO0uAA--.16302W
X-CM-SenderInfo: qqqrilqqysqiywtou0bp/xtbBEA7FqmjCuoTPRgAGsq
X-Coremail-Antispam: 1U5529EdanIXcx71UUUUU7vcSsGvfC2KfnxnUU==
X-Stat-Signature: pz5mapotjog457ojib469c15tkujdxug
X-Rspam-User: 
X-Rspamd-Queue-Id: 23600C0013
X-Rspamd-Server: rspam04
X-HE-Tag: 1757603050-68912
X-HE-Meta: U2FsdGVkX18ujspcQ3ce7TGTlerPfosny9nn/zxjfk7qTHv0mqhsxXrR7aHsHfK3pc3kpQK4l2Krc4TE5DbFs/DkNoMQNGprTI+oVvQH/TtOsEE2SBMiY5yh91n22xp0PJXkCBs2kQc/17CoH0XnmNtCTX4/ctSzZFcVemXTXdTqDH+doQZFRogqyteH5vKQ4LrXGZRpkqIu48jzEZL52vLHaTb2WSXoy1WIGpxsGFBdTlnPIuTZZni/YIoSISKO4Evio5rnue/+APd5Hear88TSt14wFSPkbxBwiYjv2OqwSAndik56Ocq4vfQbQbSHYZFV/ppmkEjzjhRpzQOW+PD7ovzTkZwgIFjc2St/birHmasCh04x9qHoIOPEIClzsZGdQbb7WggJ3xzFZlLVbbJ6dAWJ0E1iwCDRx4ob5mi51TwPVgCXhDEL33HFxE1eJQO9aV76d/2bWDSEvTGmS0Pd9hs2x7MWGMO9gKzVlhkY47z01LcQdCtgsG9H0khOCsI2iKXk5yeBGwWAxXzsvmIGFGL/Fwx1zshtbenb6rg6QXGSCZQ4fj20D/4Tz2euySu+292Gl1HGdr9q5Xg3WZUHMJKl/PLcl/kJztWPExVTDBXtZCmOnMAMC2rJfaQqWRpdlWFC5GjgeDTDgT21WorqM/tmzWQVC79PXyZB/VGRtQh7ATD6pJuwj+cACGp+XR/I1P8vcq276dB8QMeWQWnQXT5cbqU3EsLbeqR63h9p0wZWqIOsErKOf21l9CGYVk/qadZKN8VGd9fDSmhxAZtfVWvKEoUhnKDR/gyaZuMO7XBU8D8Xgq4/DaFNEvnyXJ/Ehd6b3Dk+Pep8SpnjNpSITOTRbkFasejG9CdiJDo2KE4pp0J5/Ee7frSQudC0rcrN8EQwMHBT8LJPbkG07/Zq+kXdx2eJOfXaHeIRTMhb6l3gWq5jMPFmSMzRQBHLxD8ymzGzIYh3r8b5dl2
 XpYD5mKU
 7xkNIwO9HbOhrwc4sUTGkpNG8k95k4rc6iO4/kzLqPhcuEbQ4z7GH9h2QjjY+uB5bSW3ZENReG6AlG4jaaSqCLil+dAIoxlRkb8oM7qv8+U9qhsUkiUNkt3nLTfG8BO3ZoCvX5ZhWxZ8GBoeXxoZ6bqKrPEQNfOWSnzyyXGjfA6gdFn0n1YBe2AEk8yHPZ8c+hIKIdjooW9l95nP5Sq9YQiwwp0mjclRwfy6YvL1csnfN+JqhoczpgVrIwueNYRDMe/4aTAXhayeQotn0eB33hq/2vXZEPpj+V8X/vTAs2y4QvgFlDmV1q50hcmuASWD4ePcDys/01vNxIjCxuMTKpBskGypfiMawi9J8vYxVgVtXqzCRX9NF/q9tITcogDjQ2fHjmZm9qFV0TUNJu5Pv//FeeoPy5HholrlrPcGGYvZgg0P07Mkn2E1tMjG3P6FTy96RXl/IZDN+FRsOaIq6+lA8WaF9eoJ9rpcOUb2kfsv0DPtBUaMaD5Rl+Zu4jXv5yNs+t0F7NACHtUBbgwaAgf9pzWfrGsTdJ8zxky96XQaXYaknnLmW/unvb48AkbicSTsq2fBVd8gXQk5xacX9UiYhBnmqm8OKbZM/63YOY/L69AlHfuNUrwPW6cgbvRAs5bJ7FL+qTmT05oagXvSeLB28tdAl007XlEvYmTzs5SQYFJk5eHyxvwDLGXVwY9p9VwAb8HERMkTa/Os=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

CkF0IDIwMjUtMDktMTAgMDc6NDk6NDIsICJTdXJlbiBCYWdoZGFzYXJ5YW4iIDxzdXJlbmJAZ29v
Z2xlLmNvbT4gd3JvdGU6Cj5XaGlsZSByYXJlLCBtZW1vcnkgYWxsb2NhdGlvbiBwcm9maWxpbmcg
Y2FuIGNvbnRhaW4gaW5hY2N1cmF0ZSBjb3VudGVycwo+aWYgc2xhYiBvYmplY3QgZXh0ZW5zaW9u
IHZlY3RvciBhbGxvY2F0aW9uIGZhaWxzLiBUaGF0IGFsbG9jYXRpb24gbWlnaHQKPnN1Y2NlZWQg
bGF0ZXIgYnV0IHByaW9yIHRvIHRoYXQsIHNsYWIgYWxsb2NhdGlvbnMgdGhhdCB3b3VsZCBoYXZl
IHVzZWQKPnRoYXQgb2JqZWN0IGV4dGVuc2lvbiB2ZWN0b3Igd2lsbCBub3QgYmUgYWNjb3VudGVk
IGZvci4gVG8gaW5kaWNhdGUKPmluY29ycmVjdCBjb3VudGVycywgbWFyayB0aGVtIHdpdGggYW4g
YXN0ZXJpc2sgaW4gdGhlIC9wcm9jL2FsbG9jaW5mbwo+b3V0cHV0Lgo+QnVtcCB1cCAvcHJvYy9h
bGxvY2luZm8gdmVyc2lvbiB0byByZWZsZWN0IGNoYW5nZSBpbiB0aGUgZmlsZSBmb3JtYXQuCj4K
PkV4YW1wbGUgb3V0cHV0IHdpdGggaW52YWxpZCBjb3VudGVyczoKPmFsbG9jaW5mbyAtIHZlcnNp
b246IDIuMAo+ICAgICAgICAgICAwICAgICAgICAwIGFyY2gveDg2L2tlcm5lbC9rZGVidWdmcy5j
OjEwNSBmdW5jOmNyZWF0ZV9zZXR1cF9kYXRhX25vZGVzCj4gICAgICAgICAgIDAgICAgICAgIDAg
YXJjaC94ODYva2VybmVsL2FsdGVybmF0aXZlLmM6MjA5MCBmdW5jOmFsdGVybmF0aXZlc19zbXBf
bW9kdWxlX2FkZAo+ICAgICAgICAgIDAqICAgICAgIDAqIGFyY2gveDg2L2tlcm5lbC9hbHRlcm5h
dGl2ZS5jOjEyNyBmdW5jOl9faXRzX2FsbG9jCj4gICAgICAgICAgIDAgICAgICAgIDAgYXJjaC94
ODYva2VybmVsL2ZwdS9yZWdzZXQuYzoxNjAgZnVuYzp4c3RhdGVyZWdzX3NldAo+ICAgICAgICAg
ICAwICAgICAgICAwIGFyY2gveDg2L2tlcm5lbC9mcHUveHN0YXRlLmM6MTU5MCBmdW5jOmZwc3Rh
dGVfcmVhbGxvYwo+ICAgICAgICAgICAwICAgICAgICAwIGFyY2gveDg2L2tlcm5lbC9jcHUvYXBl
cmZtcGVyZi5jOjM3OSBmdW5jOmFyY2hfZW5hYmxlX2h5YnJpZF9jYXBhY2l0eV9zY2FsZQo+ICAg
ICAgICAgICAwICAgICAgICAwIGFyY2gveDg2L2tlcm5lbC9jcHUvYW1kX2NhY2hlX2Rpc2FibGUu
YzoyNTggZnVuYzppbml0X2FtZF9sM19hdHRycwo+ICAgICAgNDkxNTIqICAgICAgNDgqIGFyY2gv
eDg2L2tlcm5lbC9jcHUvbWNlL2NvcmUuYzoyNzA5IGZ1bmM6bWNlX2RldmljZV9jcmVhdGUKPiAg
ICAgICAzMjc2OCAgICAgICAgMSBhcmNoL3g4Ni9rZXJuZWwvY3B1L21jZS9nZW5wb29sLmM6MTMy
IGZ1bmM6bWNlX2dlbl9wb29sX2NyZWF0ZQo+ICAgICAgICAgICAwICAgICAgICAwIGFyY2gveDg2
L2tlcm5lbC9jcHUvbWNlL2FtZC5jOjEzNDEgZnVuYzptY2VfdGhyZXNob2xkX2NyZWF0ZV9kZXZp
Y2UKPgoKSGksIApUaGUgY2hhbmdlcyBtYXkgIGJyZWFrIHNvbWUgY2xpZW50IHRvb2xzLCBtaW5l
IGluY2x1ZGVkLi4uLiAKSSBkb24ndCBtaW5kIGFkanVzdGluZyBteSB0b29scywgYnV0IHN0aWxs
CklzIGl0IGFjY2VwdGFibGUgIHRvIGNoYW5nZSAKICAgICAgNDkxNTIqICAgICAgNDgqIGFyY2gv
eDg2L2tlcm5lbC9jcHUvbWNlL2NvcmUuYzoyNzA5IGZ1bmM6bWNlX2RldmljZV9jcmVhdGUKdG8K
ICAgICAgKzQ5MTUyICAgICAgKzQ4IGFyY2gveDg2L2tlcm5lbC9jcHUvbWNlL2NvcmUuYzoyNzA5
IGZ1bmM6bWNlX2RldmljZV9jcmVhdGUqCgpUaGUgJysnIHNpZ24gbWFrZSBpdCBzdGlsbCBzdGFu
ZG91dCB3aGVuIHZpZXcgZnJvbSBhIHRlcm1pbmFsLCBhbmQgY2xpZW50IHRvb2xzLCBub3QgYWxs
IG9mIHRoZW0gdGhvdWdoLCBtaWdodCBub3QgbmVlZCBhbnkgY2hhbmdlcy4gCkFuZCB3aGVuIGNs
aWVudCB3YW50IHRvIGZpbHRlciBvdXQgaW5hY2N1cmF0ZSBkYXRhIGl0ZW1zLCBpdCBjb3VsZCBi
ZSBkb25lIGJ5IGNoZWNraW5nIHRoZSB0YWlsaW5nICcqIiBvZiBmdW5jIG5hbWUuCgooVGhlcmUg
d291bGQgYmUgc29tZSBjb3JuZXIgY2FzZXMsIGZvciBleGFtcGxlLCB0aGUgJysnIHNpZ24gbWF5
IG5vdCBuZWVkZWQgd2hlbiB0aGUgdmFsdWUgcmVhY2ggYSBuZWdhdGl2ZSB2YWx1ZSBpZiBzb21l
IHVuZGVyZmxvdyBidWcgaGFwcGVuZWQpCgoKVGhhbmtzCkRhdmlkLgoKCj5TdWdnZXN0ZWQtYnk6
IEpvaGFubmVzIFdlaW5lciA8aGFubmVzQGNtcHhjaGcub3JnPgo+U2lnbmVkLW9mZi1ieTogU3Vy
ZW4gQmFnaGRhc2FyeWFuIDxzdXJlbmJAZ29vZ2xlLmNvbT4KPi0tLQoK


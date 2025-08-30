Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 03639CA0FF0
	for <linux-mm@archiver.kernel.org>; Sat, 30 Aug 2025 02:04:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 125A18E0006; Fri, 29 Aug 2025 22:04:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0FC658E0001; Fri, 29 Aug 2025 22:04:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0389A8E0006; Fri, 29 Aug 2025 22:04:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id E74E18E0001
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 22:04:22 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id A99D5BC5F8
	for <linux-mm@kvack.org>; Sat, 30 Aug 2025 02:04:22 +0000 (UTC)
X-FDA: 83831779164.18.3C6EC26
Received: from m16.mail.163.com (m16.mail.163.com [117.135.210.3])
	by imf15.hostedemail.com (Postfix) with ESMTP id CA3E9A000D
	for <linux-mm@kvack.org>; Sat, 30 Aug 2025 02:04:19 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=fail ("body hash did not verify") header.d=163.com header.s=s110527 header.b="E LQ9q3m";
	spf=pass (imf15.hostedemail.com: domain of yangshiguang1011@163.com designates 117.135.210.3 as permitted sender) smtp.mailfrom=yangshiguang1011@163.com;
	dmarc=pass (policy=none) header.from=163.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756519460;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7Hd+IKkI7LueDUZIZaO72mgRAKubR2asw9SWh4jRMY0=;
	b=CRSCEjS7qPz1YNcCEkiPmxHD07SWmQDrOccS4k3udUY+IS2TZNe6+tJOw9wwl1HTLs3OQ3
	WFflik2Ozuq1+8Qu+3lgUkhtZGx0drpm5eTjbDreusKgJNSaaYt35IgI8r7q85522l5C09
	vn4xEa6vY+xFwttHUeixrAjWJdJ5G/4=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=fail ("body hash did not verify") header.d=163.com header.s=s110527 header.b="E LQ9q3m";
	spf=pass (imf15.hostedemail.com: domain of yangshiguang1011@163.com designates 117.135.210.3 as permitted sender) smtp.mailfrom=yangshiguang1011@163.com;
	dmarc=pass (policy=none) header.from=163.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756519460; a=rsa-sha256;
	cv=none;
	b=C8Cstpc12qzcFGhlHDYsmhlCdPUuY59n4+n/NFR5CvWaPdk0CDO2Lk+JMkSe6/Vk5a2LFg
	OMkWJoaiMd3MflCj4zlXkp/dIPPjT/HFddHQmuL0Eg5+/r1mRlxXrXb7n9+ERs+q5epcv8
	wQ00f48aUIXgrTZutGTZs/b4I1iAm+0=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=Date:From:To:Subject:Content-Type:MIME-Version:
	Message-ID; bh=yDf6R8OVR4Mv+z5f263aPwRbugqrNKlI+W4Ql3f8lGI=; b=E
	LQ9q3msednwRY90iZzFYZRu1iM0djK52o1KsWiUXD7EPDeAJ/8c94MjKcajEUiTw
	PrdsVzuFEKr/itCRlU9m4sixRMrOjIuinh0I5VaWPwcQ5vILp8iJZ1+zoMJS/wUk
	d7ANyRrX1ZOndMmcHKTi3GW24DYx2FJcxZUgJN7500=
Received: from yangshiguang1011$163.com ( [1.202.162.48] ) by
 ajax-webmail-wmsvr-40-149 (Coremail) ; Sat, 30 Aug 2025 09:48:26 +0800
 (CST)
X-Originating-IP: [1.202.162.48]
Date: Sat, 30 Aug 2025 09:48:26 +0800 (CST)
From: yangshiguang  <yangshiguang1011@163.com>
To: "Vlastimil Babka" <vbabka@suse.cz>
Cc: "Harry Yoo" <harry.yoo@oracle.com>,
	"Matthew Wilcox" <willy@infradead.org>, akpm@linux-foundation.org,
	cl@gentwo.org, rientjes@google.com, roman.gushchin@linux.dev,
	glittao@gmail.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	yangshiguang <yangshiguang@xiaomi.com>, stable@vger.kernel.org
Subject: Re:Re: [PATCH v3] mm: slub: avoid wake up kswapd in
 set_track_prepare
X-Priority: 3
X-Mailer: Coremail Webmail Server Version 2023.4-cmXT build
 20250723(a044bf12) Copyright (c) 2002-2025 www.mailtech.cn 163com
In-Reply-To: <9dbd300c-240b-477f-ba03-8a17c7c2b84b@suse.cz>
References: <20250825121737.2535732-1-yangshiguang1011@163.com>
 <aKxZp_GgYVzp8Uvt@casper.infradead.org>
 <54d9e5ac-5a51-4901-9b13-4c248aada2d7@suse.cz> <aK6U61xNpJS0qs15@hyeyoo>
 <6e1ab9d8.6595.198ea7d7a78.Coremail.yangshiguang1011@163.com>
 <fc6f7372-efb4-48e3-b217-c8bec0065b97@suse.cz>
 <4d271e7e.6bea.198f596bd15.Coremail.yangshiguang1011@163.com>
 <9dbd300c-240b-477f-ba03-8a17c7c2b84b@suse.cz>
X-NTES-SC: AL_Qu2eBPmat00r4CSYbOkfmUgRj+k6WsK3s/sn3oNfP5B+jCLr9QwKYn5CAn3N8/OKBxCuvii7ST1E+uBAfIh4eIsl8V52gcVznlkkp5TdwoVTRA==
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset=GBK
MIME-Version: 1.0
Message-ID: <15cc44af.7a6.198f8a95fb5.Coremail.yangshiguang1011@163.com>
X-Coremail-Locale: zh_CN
X-CM-TRANSID:lSgvCgDnf7xqWLJoc58kAA--.142W
X-CM-SenderInfo: 51dqw25klj3ttqjriiqr6rljoofrz/1tbiEAa45Wixi0ReDAADsM
X-Coremail-Antispam: 1U5529EdanIXcx71UUUUU7vcSsGvfC2KfnxnUU==
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: CA3E9A000D
X-Stat-Signature: x9ai97zm6zuk3p5893kpkzpkk747ziuy
X-Rspam-User: 
X-HE-Tag: 1756519459-999418
X-HE-Meta: U2FsdGVkX1/A96T5dKqr5qWWDMYjs2pDRaSNGD9P4elvMgdtsI3lrcp5uts3oc6f+D9KDH/ZOnaa1ESaGa69/KQ6zRyxDSFLMm0xaVeIpnSYv6jesTAq+pNu4kheYTKdbGZSa5axqZxLj/noeNnprOnwDBcWqIP+dV0G+oeysVjnZZDlAOeQh4WiD774t4nnhXVhYh+IG4JeUYJ+B6fFiPE1hxZmJDm+uCPwe0KwqLaEs6ZQw5o84pK8UBV570jKEBK57naENyWbdoKYTXBizILdish+zzrQ2PUcMC3llDbAG4gng/VSzo5F6KCPv75GJFnNuTeyYlpndRnmKaZdYelslfHUpffNAL3ZPAiYY7rVd81EVZDydeB7IeZxUhnMI+0eI/ZdQmkb9iOCQ+TO/1JXjZhjgQtdVxPMEXUzVvMgVToVjZ5KS8P6ToY++xgN5iSO/oraGW16YnPdKPms8FWqEbMQ7TcGuNSbXUIyV1cTb3K4N/rCu4oaf42BqnR3o9xGGfL0bk8h0aFihWP5fIVz9nWoeEH6NHu3OLQU4JQGuwxxeMf8oytkYc9ZSmn9NQe8aToFX/Rgc9U37nuBF6AitCJRuA3dTeVaYcVUIe1Pi0Y62Ixm/Wk2RHsPulQDfhd3SBNLAZGMsx2u3JVwtuscetlKwC0V/nU4jmT7Yh/l/57NxYYK7015L7TkBM+U8H+TWYlU38CnTM1LwB4ZfUs9VS/PHuesdLd8v93rUvD3sjCxFNjyhWH/MgF1wys76LTD7pRJVoVZ8R/DKQ6WZymp6zDPfFHmcR0wDG/I3SFlZhgK2xc6gB3OHSzaiXU+iTaPIgUp7Y7WzEpfDWQhVBn0jp4iyhw5DmrEUvFZxQnrknY5wgDFYjZFJhoqnZPeMjDcyelbHT6sorFoJy7uzXZmSD7HxrGtGxcmx5grsbYFY0jQYH4GgxCSlPz0I5zQSPpo43vx6hicGn1nx4Y
 n0sIYkKm
 oeLW29tQmA/jvTc5Jgyc/eqcLuDdlqM6QducDsBEmgNO1RzJBVauo084i2hUPCcYKH3lEtCYcKbZ1McwriLpnPOZSoKrwrNA0lfYhA0PHhybbi+N47yOYTmcgoA5RckcnlMUYHkpeJzs960XyRWANU9Es7uDxwl5mxWKBMY3sUplF9rt2M4TdMJu/eQrI52ZTf1PVJXIY4oIW0EBRNCr099Z9iWP4/+gLydTSXUN+O3X0pD3lfWpbNc4G4OaHxaAaNXiM/o9HgPqQOEPg3grzh9e3P2qF33o03s7iPPt+fgLQHDUdIYKI0bBQ/He/pONTPcuS5JVxv6n8aady0GA/VtbfJ1JBPJ/8SUFrkUpmSYkvAc/gr9CiUxDtTftFJcszjLfAYRQ3h8JsY9kZlHt3ZvUGsRPyhuXjpYMhIlLro+y1ei98LQpBHgCL5rUmTmL4/juvnUpSkbHShMrOyCikwBTUS6nxoD/rukp3CuTNAM/19YANjBmfAFtyKab/UvK47qngmo4+2A7iIWRSk305/M0IzRqIF0qDesKcqLZXbaAEudUJcGAO7Np6oXU8Hjn8BoYUAetmvy8Yz5NJ2ycpn2fjLiDOBcOyAhvSor8lQ0diBwPB7fNH9Axv5A==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

CgoKCkF0IDIwMjUtMDgtMjkgMjE6MDg6NTgsICJWbGFzdGltaWwgQmFia2EiIDx2YmFia2FAc3Vz
ZS5jej4gd3JvdGU6Cj5PbiA4LzI5LzI1IDEzOjI5LCB5YW5nc2hpZ3Vhbmcgd3JvdGU6Cj4+IEF0
IDIwMjUtMDgtMjcgMTY6NDA6MjEsICJWbGFzdGltaWwgQmFia2EiIDx2YmFia2FAc3VzZS5jej4g
d3JvdGU6Cj4+IAo+Pj4+IAo+Pj4+Pgo+Pj4+IAo+Pj4+IEhvdyBhYm91dCB0aGlzPyAKPj4+PiAK
Pj4+PiAgICAgICAgIC8qIFByZWVtcHRpb24gaXMgZGlzYWJsZWQgaW4gX19fc2xhYl9hbGxvYygp
ICovCj4+Pj4gLSAgICAgICBnZnBfZmxhZ3MgJj0gfihfX0dGUF9ESVJFQ1RfUkVDTEFJTSk7Cj4+
Pj4gKyAgICAgICBnZnBfZmxhZ3MgPSAoZ2ZwX2ZsYWdzICYgfihfX0dGUF9ESVJFQ1RfUkVDTEFJ
TSB8IF9fR0ZQX05PRkFJTCkpIHwKPj4+PiArICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgX19HRlBfTk9XQVJOOwo+Pj4KPj4+SSdkIHN1Z2dlc3QgdXNpbmcgZ2ZwX25lc3Rl
ZF9mbGFncygpIGFuZCAmIH4oX19HRlBfRElSRUNUX1JFQ0xBSU0pOwo+Pj4KPj4gCj4+IEhvd2V2
ZXIsIGdmcCBoYXMgYmVlbiBwcm9jZXNzZWQgYnkgZ2ZwX25lc3RlZF9tYXNrKCkgaW4KPj4gc3Rh
Y2tfZGVwb3Rfc2F2ZV9mbGFncygpLgo+Cj5BaGEsIGRpZG4ndCBub3RpY2UuIEdvb2QgdG8ga25v
dyEKPgo+PiBTdGlsbCBuZWVkIHRvIGNhbGwgaGVyZT8KPgo+Tm8gdGhlbiB3ZSBjYW4gaW5kZWVk
IGp1c3QgbWFzayBvdXQgX19HRlBfRElSRUNUX1JFQ0xBSU0uCj4KPk1heWJlIHRoZSBjb21tZW50
IGNvdWxkIHNheSBzb21ldGhpbmcgbGlrZToKCj4KCnN1cmUuIEV4cHJlc3MgY2xlYXJseS4KCgo+
LyoKPiAqIFByZWVtcHRpb24gaXMgZGlzYWJsZWQgaW4gX19fc2xhYl9hbGxvYygpIHNvIHdlIG5l
ZWQgdG8gZGlzYWxsb3cKPiAqIGJsb2NraW5nLiBUaGUgZmxhZ3MgYXJlIGZ1cnRoZXIgYWRqdXN0
ZWQgYnkgZ2ZwX25lc3RlZF9tYXNrKCkgaW4KPiAqIHN0YWNrX2RlcG90IGl0c2VsZi4KPiAqLwo+
PiBzZXRfdHJhY2tfcHJlcGFyZSgpCj4+IC0+c3RhY2tfZGVwb3Rfc2F2ZV9mbGFncygpCj4+IAo+
Pj4+ICA+LS0gCj4+Pj4+Q2hlZXJzLAo+Pj4+PkhhcnJ5IC8gSHllb25nZ29uCg==


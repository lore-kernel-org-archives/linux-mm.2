Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3D4D2F357D5
	for <linux-mm@archiver.kernel.org>; Wed, 25 Feb 2026 10:47:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7417A6B00A9; Wed, 25 Feb 2026 05:47:00 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6EB896B00AB; Wed, 25 Feb 2026 05:47:00 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5EE6D6B00AD; Wed, 25 Feb 2026 05:47:00 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 49A2C6B00A9
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 05:47:00 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id DC7EB8B6CC
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 10:46:59 +0000 (UTC)
X-FDA: 84482651358.05.C64343D
Received: from mta22.hihonor.com (mta22.honor.com [81.70.192.198])
	by imf06.hostedemail.com (Postfix) with ESMTP id A341E180004
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 10:46:57 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=honor.com header.s=dkim header.b=DVYm76W4;
	spf=pass (imf06.hostedemail.com: domain of wangzicheng@honor.com designates 81.70.192.198 as permitted sender) smtp.mailfrom=wangzicheng@honor.com;
	dmarc=pass (policy=none) header.from=honor.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772016418;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6rzVrm6XXdOFZVj5xCn0UrAgDcHRt9urTMjYtAI6Rmg=;
	b=MjryezpxzDZkvEbWdkJIzwZsIjOhEaZ7PkNMbX4VgGETWyohyS1F5I3cY13yA4rg00j/DR
	SzrMpZGMdcbd/5R7u6nG3fEpxzX6LvHh8UtT7Fe79LqPIotVwklC30C+2sYojhZ/oiZjzO
	ZQv4TKFPB94b+eh8X08bZ4KEPUag4Wg=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=honor.com header.s=dkim header.b=DVYm76W4;
	spf=pass (imf06.hostedemail.com: domain of wangzicheng@honor.com designates 81.70.192.198 as permitted sender) smtp.mailfrom=wangzicheng@honor.com;
	dmarc=pass (policy=none) header.from=honor.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772016418; a=rsa-sha256;
	cv=none;
	b=DEvM1Jum06gdRL1uaLmGJjIj0zp1aNJbNSmyGAo172nH3tHYBFPefECFLgu7c43rCoLh+S
	Wof68xuiQ0w//e7Q5iSbxXgTMSmFo8eNXQApJloHrLp/BxJ7uzROV5eixKp8Vurg8HwhdH
	z+xY9UdTZWRRDjMn5o6dXlE/jHn5tZ8=
dkim-signature: v=1; a=rsa-sha256; d=honor.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=To:From;
	bh=6rzVrm6XXdOFZVj5xCn0UrAgDcHRt9urTMjYtAI6Rmg=;
	b=DVYm76W4HL4rGoM3v67DcahMq2JfSo2Uzz16vtHX1jC/vvNoHJk3P0n4kX0MSuZA3ICkoHHEE
	vPCF1KD9dZNi8S/n2rGlXHTvVq0RXoZ/22V16hbJC9L2wloUyL8s1aa2eO/7AGGhWjv6cWTly3K
	TXlzQaHNbpm17pb5GCDrguY=
Received: from w002.hihonor.com (unknown [10.68.28.120])
	by mta22.hihonor.com (SkyGuard) with ESMTPS id 4fLWQf2Kf6zYkxWj;
	Wed, 25 Feb 2026 18:43:22 +0800 (CST)
Received: from a015.hihonor.com (10.68.27.88) by w002.hihonor.com
 (10.68.28.120) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.27; Wed, 25 Feb
 2026 18:46:47 +0800
Received: from w002.hihonor.com (10.68.28.120) by a015.hihonor.com
 (10.68.27.88) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.27; Wed, 25 Feb
 2026 18:46:47 +0800
Received: from w002.hihonor.com ([fe80::ef6f:d9c5:cf75:d4d3]) by
 w002.hihonor.com ([fe80::ef6f:d9c5:cf75:d4d3%14]) with mapi id
 15.02.2562.027; Wed, 25 Feb 2026 18:46:47 +0800
From: wangzicheng <wangzicheng@honor.com>
To: Suren Baghdasaryan <surenb@google.com>
CC: "lsf-pc@lists.linux-foundation.org" <lsf-pc@lists.linux-foundation.org>,
	"linux-mm@kvack.org" <linux-mm@kvack.org>, wangxin 00023513
	<wangxin23@honor.com>, gao xu <gaoxu2@honor.com>, wangtao
	<tao.wangtao@honor.com>, liulu 00013167 <liulu.liu@honor.com>, zhouxiaolong
	<zhouxiaolong9@honor.com>, linkunli <linkunli@honor.com>,
	"kasong@tencent.com" <kasong@tencent.com>, "21cnbao@gmail.com"
	<21cnbao@gmail.com>, "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
	"axelrasmussen@google.com" <axelrasmussen@google.com>, "yuanchu@google.com"
	<yuanchu@google.com>, "weixugc@google.com" <weixugc@google.com>, Randy Dunlap
	<rdunlap@infradead.org>, "Liam.Howlett@oracle.com" <Liam.Howlett@oracle.com>,
	"willy@infradead.org" <willy@infradead.org>, Kalesh Singh
	<kaleshsingh@google.com>, yangxuzhe 00017436 <yangxuzhe@honor.com>
Subject: RE: [LSF/MM/BPF TOPIC] MGLRU on Android: Real-World Problems and
 Challenges
Thread-Topic: [LSF/MM/BPF TOPIC] MGLRU on Android: Real-World Problems and
 Challenges
Thread-Index: AQHcpbCW9Jb7JciVVEirgKqS2Lh6gbWTO+JQ
Date: Wed, 25 Feb 2026 10:46:47 +0000
Message-ID: <e3734e2cfac3403da02213b64af8c5b4@honor.com>
References: <e5c8b5b9e7574dce8e4d4744595123e2@honor.com>
 <CAJuCfpHzTdwcGh8wXetEcAy-93-WqPmoyDnbC8UhzGttpcm_Cw@mail.gmail.com>
In-Reply-To: <CAJuCfpHzTdwcGh8wXetEcAy-93-WqPmoyDnbC8UhzGttpcm_Cw@mail.gmail.com>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-originating-ip: [10.163.18.229]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-Stat-Signature: k1d6bo9aphcysj9zusujpdqzw9hzszi3
X-Rspam-User: 
X-Rspamd-Queue-Id: A341E180004
X-Rspamd-Server: rspam01
X-HE-Tag: 1772016417-844169
X-HE-Meta: U2FsdGVkX195pBxAwQuIx9RpB4ALO+EudgDG7wi1d6LtdWrWy3ww6XojsGakdHrAaNjmrL5pAxXQbUeeoVatsW62JiTLgmaE9m3N52GQIULeH7uu7lmx6JznuvDqqaEQOvbahOZiXniPIJ/s13yPtsmCRNVnTOsvX5jnqu2YB4VuDl+1Q7NLckC/Ust0dJZdt8AQE6EjcRi6w5Th3UXyUoPe8k5D6N5PttOYDqwYOFYzOfRDDwIZkGr8ZCIohY8Wp0mJurG3QlCTgigRXC3Fl7j/Hp9aMZCi5srj0EeUzHwWW0pb5Vv4fXM5bRcqbbGBXT396Wlflu419Wt4dZGR9xDaV/zJ4idb6yRPBDylchvckTP9kUKamYYiJw8pjE5BCtSTARA0rFDSBGx4Z42kgOsNitfDwOIGVNjaMsSt5UQlP6bgBcvkKSPZvSBTv24AZN1LS9ZckH6b5YmxQimru8Rg3/jSa2d6+WkTi58d269tRrUzI4xcg0FC4NrdO4KlFGZUNTqwxiZOStF8BBcY6o1ahDInvT/da4f3T4Tu8ZFFEiUiIBTcHCF9WY2UtJ2ksWKA3+kicFgCAwlvVEvkqdcniHJgQZ0tvGDEPK3y8ZsCqZPTZaDK1NqUjnYiCp8wwpqFpdQImJijNWrI3UORYZ9dtxTwVBqg9AAqrhMfWXzH9QQyiUyBHPFOOEwvrE/kj7XLwYSDyN41C5UPxtAEwtRGotdREUWjbvZvqvXZHMLNdanKBPABF+5BPUnlccMAetR0yTOo9ZRH4CKM9ecLurvXBXUtrs03pqGROgKH8Didf5LF6YBghzdt79tgpGFy6x2PV5GBgkeidyM97dWcmsX16kmNkJtFUdrDFgYavRH6sUnX1Pjwb3NAkcR17foCZV0rCQHSo0bx40VEMSN6WyyJN4kuFMLt2aHIFld+0YqmXur3l7jSQZ/V/UqcqsG4aoZA0ccmu4q2bDtSdyS
 ZZajRDlt
 t/HRfYTDYevk4ZCgJ7LeRhR9rScGypg3g3ydAzljjNThIIzUwWbRTzRPHjw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

PiA+DQo+ID4gV2UgYXJlIGhhcHB5IHRvIHNoYXJlIG1vcmUgZGV0YWlsZWQgZGF0YSBhbmQgZXhw
ZXJpbWVudHMgYW5kIHRvIGhlbHANCj4gPiB3aXRoIFBvQ3MgYW5kIGxhcmdlLXNjYWxlIHZhbGlk
YXRpb24gaWYgdGhlcmUgaXMgaW50ZXJlc3QgaW4NCj4gPiBwdXJzdWluZyB0aGVzZSBkaXJlY3Rp
b25zLg0KPiANCj4gRm9yIG9idmlvdXMgcmVhc29ucyBJJ20gaW50ZXJlc3RlZCBpbiB0aGlzIGRp
c2N1c3Npb24uIFdlIGFsc28gbm90aWNlDQo+IHNvbWUgc2hvcnRjb21pbmdzIG9mIE1HTFJVIGFu
ZCB3b3VsZCBsaWtlIHRvIGNvbGxhYm9yYXRlIG9uIHJlc29sdmluZw0KPiB0aGVtLg0KPiBUaGFu
a3MsDQo+IFN1cmVuLg0KPiANCkhpIFN1cmVuLA0KDQp0aGFua3MsIHdl4oCZZCBiZSB2ZXJ5IGhh
cHB5IHRvIHdvcmsgdG9nZXRoZXIgb24gdGhpcy4NCg0KPiA+DQo+ID4gUmVmZXJlbmNlDQo+ID4g
WzFdIGh0dHBzOi8vbG9yZS5rZXJuZWwub3JnL2xpbnV4LW1tLzIwMjUxMTI4MDI1MzE1LjM1MjA2
ODktMS0NCj4gd2FuZ3ppY2hlbmdAaG9ub3IuY29tLw0KPiA+IFsyXSBodHRwczovL2FuZHJvaWQt
DQo+IHJldmlldy5nb29nbGVzb3VyY2UuY29tL2Mva2VybmVsL2NvbW1vbi8rLzM4NjY1NTQNCj4g
PiBbM10gaHR0cHM6Ly9hbmRyb2lkLQ0KPiByZXZpZXcuZ29vZ2xlc291cmNlLmNvbS9jL2tlcm5l
bC9jb21tb24vKy8zODcwOTIwDQo+ID4gWzRdIGh0dHBzOi8vbHduLm5ldC9BcnRpY2xlcy8xMDUx
ODgyLw0KPiA+DQo+ID4gLS0NCj4gPiBCZXN0IHJlZ2FyZHMsIGFuZCB3aXNoaW5nIHlvdSBhIHBy
b3NwZXJvdXMgWWVhciBvZiB0aGUgSG9yc2UsDQo+ID4gWmljaGVuZyBXYW5nDQo=


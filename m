Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 94B8EEFB7E5
	for <linux-mm@archiver.kernel.org>; Tue, 24 Feb 2026 03:17:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8CCF06B0088; Mon, 23 Feb 2026 22:17:17 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 87A726B0089; Mon, 23 Feb 2026 22:17:17 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 76FD96B008A; Mon, 23 Feb 2026 22:17:17 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 61ECD6B0088
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 22:17:17 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id CA4081B4BE6
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 03:17:16 +0000 (UTC)
X-FDA: 84477889272.11.8573F74
Received: from mta22.hihonor.com (mta22.honor.com [81.70.192.198])
	by imf17.hostedemail.com (Postfix) with ESMTP id 0A69C40006
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 03:17:13 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=honor.com header.s=dkim header.b=FtVctY1y;
	spf=pass (imf17.hostedemail.com: domain of wangzicheng@honor.com designates 81.70.192.198 as permitted sender) smtp.mailfrom=wangzicheng@honor.com;
	dmarc=pass (policy=none) header.from=honor.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771903034;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=z5r6VEzTDKV+tT966K7bLNjRi5fM54HF2kL4LxgaQMI=;
	b=UFde6199wp/EHu+fBbbZgc9eLqw2nK7palyBJFfEzir+DONMCbZuxY+IM8RqtJYhQkZ5r9
	HrNnqJ18vrEdW7+cDey9zCJfMlMP6ibRonN79sz5+RrfMdcnd4zP23Zi2LKZ+KYDVxGPkn
	4WMb80zaK8aQl2MXFDeHLNTwTu/hjTA=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=honor.com header.s=dkim header.b=FtVctY1y;
	spf=pass (imf17.hostedemail.com: domain of wangzicheng@honor.com designates 81.70.192.198 as permitted sender) smtp.mailfrom=wangzicheng@honor.com;
	dmarc=pass (policy=none) header.from=honor.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771903034; a=rsa-sha256;
	cv=none;
	b=v1bI13kKF2l9mMAsV41eNb2Dyt88/TvfYICp+3ceTc6Fdo2u3W4EubGZZb1F5yMZvnE9SB
	6rpZZ5VMAjIWJLMyCJx/Ix8uU8LrLxD3gbUrhDVJymc7e5hRpQoD4cLeKFhbHhSUE91gmC
	BfFXGKrVBHCqcm1taJ/8f+4VvC92GPo=
dkim-signature: v=1; a=rsa-sha256; d=honor.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=To:From;
	bh=z5r6VEzTDKV+tT966K7bLNjRi5fM54HF2kL4LxgaQMI=;
	b=FtVctY1yorP8T9vJfFBzKS2p7+Ri51uSdzxY18BOUZCgY6rNUqM7vyGQOeOVDNJr4WrgMR7Xu
	MLZk5OQDI2ioPoTioZfcaQ5Pm7kTpXXdE7ryIVHg6QCKph7SBle0n/+FqCK0omQIIuHJJ2eJSF6
	V7Q47O1CJvGEc8mqoHvRJfU=
Received: from w012.hihonor.com (unknown [10.68.27.189])
	by mta22.hihonor.com (SkyGuard) with ESMTPS id 4fKjVH4gcfzYl1Gb;
	Tue, 24 Feb 2026 11:13:43 +0800 (CST)
Received: from a007.hihonor.com (10.68.22.31) by w012.hihonor.com
 (10.68.27.189) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.27; Tue, 24 Feb
 2026 11:17:08 +0800
Received: from w002.hihonor.com (10.68.28.120) by a007.hihonor.com
 (10.68.22.31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.27; Tue, 24 Feb
 2026 11:17:08 +0800
Received: from w002.hihonor.com ([fe80::ef6f:d9c5:cf75:d4d3]) by
 w002.hihonor.com ([fe80::ef6f:d9c5:cf75:d4d3%14]) with mapi id
 15.02.2562.027; Tue, 24 Feb 2026 11:17:08 +0800
From: wangzicheng <wangzicheng@honor.com>
To: "lsf-pc@lists.linux-foundation.org" <lsf-pc@lists.linux-foundation.org>,
	"linux-mm@kvack.org" <linux-mm@kvack.org>
CC: wangxin 00023513 <wangxin23@honor.com>, gao xu <gaoxu2@honor.com>, wangtao
	<tao.wangtao@honor.com>, liulu 00013167 <liulu.liu@honor.com>, zhouxiaolong
	<zhouxiaolong9@honor.com>, linkunli <linkunli@honor.com>,
	"kasong@tencent.com" <kasong@tencent.com>, "21cnbao@gmail.com"
	<21cnbao@gmail.com>, "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
	"axelrasmussen@google.com" <axelrasmussen@google.com>, "yuanchu@google.com"
	<yuanchu@google.com>, "weixugc@google.com" <weixugc@google.com>, Randy Dunlap
	<rdunlap@infradead.org>, "Liam.Howlett@oracle.com" <Liam.Howlett@oracle.com>,
	"willy@infradead.org" <willy@infradead.org>
Subject: RE: [LSF/MM/BPF TOPIC] MGLRU on Android: Real-World Problems and
 Challenges
Thread-Topic: RE: [LSF/MM/BPF TOPIC] MGLRU on Android: Real-World Problems and
 Challenges
Thread-Index: AdylO0tsrJ+MTD6TQuqKlap5pOdBLg==
Date: Tue, 24 Feb 2026 03:17:07 +0000
Message-ID: <e5c8b5b9e7574dce8e4d4744595123e2@honor.com>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-originating-ip: [10.163.18.229]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 0A69C40006
X-Stat-Signature: f9dya4z4rds7sbbkrk7fyh8moait9im4
X-Rspam-User: 
X-HE-Tag: 1771903033-277984
X-HE-Meta: U2FsdGVkX1+M2Unnh16WvGFA5zelmoXGXeKOhw6kJcoUjdn2oKT08v+X5+vntXQ54nJzLFhwddyLaOsKocLHqN2A63vBsTyTQGEbGbQ2TSobKmaTLcZRIkNXdSv2WY+z30KiF0Y1IrhljPgXrsOngWCRcv9+dQASTRd1vnFo6sXetR8DVIMXAOXMIGDVc8EiBGtNzW95d9+7i8Ma/iu7hrfgLW/eKBa1q+FmeJyWhcYkZ7FBFhUAt8LWkH8/jwZ1N67fBLtCd5A31i+KRmZ2+j210a7mN9TyE1juUna6nzfC85/esb5gZajCoeZTu/osBPSuB8ZcTKB3ATzu4CrN2ZOma/IjqMp49/QhgFPJ9+u8PyzFX4QWuGfHIJaTMeEvliD21K4fAILCh5cbEg2ApQ9ENXPTEQxNnrWdFxsBUzcyGju0m46beoSN61Ldupt18vlcjOFzXrCvDBx8l0OcArYM75PXLtYEc3IDoeXIX8ZCD+0WHmDZJaLJj4yIMOTD55vuxN4jNjlR9S0SavkN5BrHmRyfYwWeF8cNI9xfrvTNPCdp4z0go43Zq/kGMWjSoNtkFvuka+UJcpV76WxSC6/FmCN5J3lSJHbHXNeKzax1VmQzh2TUOj3xmqaAG6f+MUo8VfAy4Tkb7LF9Ewannqoa+xZ3btgd7r/MDfUyYvXWlMLU+rcRJxj56FC9WvHvFoHuS/O0dQifh0aM0fov/vWf1KLxIoxkR80Pin3KIVPLdnQe6HJ5mi9w3c8Pgo7ULjPQQ6bCLfDTqp1HtEcKX8WLVZjy9qkgwWB2aAmKXr7Azw/f/iq4D8Fj/t7wZzehNsRyIIHQ1oFEagVJcdh3ar4LGv4zuMkQIFJoh2PFbJDq+TF1obdruZGXClPlY6KdmVayDqArSaWC+TY7QKqThLbqCT6OzWrJRcjHQMym+HGKwdEGddIsIDTOI7fdLjLxci2VeKG1B2YgmIv7LRt
 1EKKGQpJ
 rnH2cMursK9bf6wv+2Tw8/9L9MAs0g6tuecxWmp4eqsd8lNJR7xCOh3C3joTwTHtAnoVHCE/tvFwdl5JTXYBnQc7S9r4V0ywbmuzTxzzYNOnoidoSOCJi/An7HKOEZt0pAKGfXIvEqL1Y0wDc/QRFKjW9Tk9l9iXsCI3j+RSG1xYZ3u4kzrOAPTXNThUcctDSfi6+1T/H7cBnDEpbm6QOX6TZTsfxp8YVMhl3x0poseZ5WOQd84NUv9be0oQjk9nQ2/wYySTL2oxsMSVk7IW6EEmBC0hNrTR0tmXHxkc9ERxeIsHMpiBJFKFwWZhDlH0UO1H8IVy9ynqRAbmMUuI0OXeClGY0rq7+SaE08GZsZKahVGUD/6bMB/Qry6oQcEzhKCrWRpo6dbFYWuj2nW7+X6Aq0GFRDGYf00pUJsqprE28t519y7nWsrSBnyzBiuDE623QWajbcdWPPfo2kpZADmxEFsMs+VyU0SyCm0Mt0n4a3aXi3VTpRGZpUr+e+G0j7pwZlrwRHIdRsYnT5i+YgrwZd0gN9YcJGejLDfVCXd9MR0+0z+M7vHpqHqguYOEP+uWIq22AXsxddREtrxAwsVGSU1jres8T9PfWMHxToi9wEuZ+glcsemBtWl+AR38RjbtKQRRZ9nKQ4sjKY7AGSI4CEZpWnVU2GZQu9L5UKw/abCY=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.002863, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

SGksDQoNCkkgcHJldmlvdXNseSBzZW50IGEgc2ltaWxhciBlbWFpbCB3aGljaCB1bmZvcnR1bmF0
ZWx5IGhhZCBlbmNvZGluZyBpc3N1ZXMuDQpJJ20gcmVzZW5kaW5nIGEgY2xlYW5lZC11cCB2ZXJz
aW9uIGhlcmUgc28gaXQncyBlYXNpZXIgdG8gcmVhZCBhbmQgZGlzY3Vzcy4NCg0KTUdMUlUgaGFz
IGJlZW4gYXZhaWxhYmxlIG9uIEFuZHJvaWQgZm9yIGFib3V0IGZvdXIgeWVhcnMsIGJ1dCBtYW55
DQpPRU0gdmVuZG9ycyBzdGlsbCBjaG9vc2Ugbm90IHRvIGVuYWJsZSBpdCBpbiBwcm9kdWN0aW9u
Lg0KSE9OT1IgaXMgYSBtYWpvciBBbmRyb2lkIE9FTSBzaGlwcGluZyB0ZW5zIG9mIG1pbGxpb25z
IG9mIGRldmljZXMNCnBlciB5ZWFyLCBhbmQgd2UgcnVuIE1HTFJVIG9uIGFsbCBvdXIgZGV2aWNl
cyBhY3Jvc3MgbXVsdGlwbGUga2VybmVsDQp2ZXJzaW9ucyAoNS4xNX42LjEyKSBhbmQgUkFNIGNv
bmZpZ3VyYXRpb25zKDRHfjI0RyksIGJhY2tlZCBieQ0KbGFyZ2Utc2NhbGUgYmV0YSBhbmQgZmll
bGQgZGF0YS4gRnJvbSB0aGlzIGRlcGxveW1lbnQsIHdlIGhhdmUgaWRlbnRpZmllZA0KZm91ciBj
b25jcmV0ZSBpc3N1ZXMgKFExLVE0KSBhbmQgY3VycmVudCB3b3JrYXJvdW5kcywgYW5kIHdvdWxk
IGxpa2UgdG8NCndvcmsgd2l0aCB0aGUgY29tbXVuaXR5IHRvIGRlc2lnbiB1cHN0cmVhbSBzb2x1
dGlvbnMuDQpBbHNvIHdlIHdvdWxkIGxpa2UgdG8gZGlzY3VzcyBNR0xSVSdzIGZ1dHVyZSBkaXJl
Y3Rpb24gb24gQW5kcm9pZC4NCg0KQmVsb3cgaXMgYSBzaG9ydCBzdW1tYXJ5IG9mIHdoYXQgd2Ug
c2VlLg0KDQpRMTogYW5vbi9maWxlIGltYmFsYW5jZSBhbmQgZHJvcCBpbiBhdmFpbGFibGUgbWVt
b3J5DQpBbmRyb2lkIGFwcHMgd29ya2xvYWQgc2hvdyBhIHBlcnNpc3RlbnQgYW5vbi9maWxlIGdl
bmVyYXRpb25hbA0KaW1iYWxhbmNlIHVuZGVyIE1HTFJVOg0KYW5vbiBwYWdlcyB0ZW5kIHRvIHN0
YXkgaW4gdGhlIHlvdW5nZXN0IDIgZ2VuZXJhdGlvbnM7DQpmaWxlIHBhZ2VzIGFyZSBzcHJlYWQg
YWNyb3NzIG11bHRpcGxlIGdlbmVyYXRpb25zIGFuZCBvdmVyLXJlY2xhaW1lZC4NClR1bmluZyBz
d2FwcGluZXNzIHRvIDIwMCBhbmQgQU5PTl9PTkxZIGRvZXMgbm90IGZ1bGx5IGZpeCB0aGlzLg0K
T24gYSAxNkcgbWVkaWEgd29ya2xvYWQgd2Ugc2VlOg0KTUdMUlU6IE1lbUF2YWlsYWJsZSB+IDYw
NjAgTUINCmxlZ2FjeTogTWVtQXZhaWxhYmxlIH4gNjk4MiBNQiAoZGlmZmVycyBieSB+MUcpDQpU
b2RheSB3ZSBtaXRpZ2F0ZSB0aGlzIHZpYSBleHBsaWNpdCBtZW1jZyBhZ2luZyBpbiBBbmRyb2lk
DQp1c2Vyc3BhY2UgWzFdLCB3aGljaCBpcyBhIHZlbmRvci1vbmx5IHdvcmthcm91bmQuDQoNClEy
OiBIYXJkIHRvIGNvbnRyb2wgcmVjbGFpbSBhbW91bnQgYW5kIHN0b3BwaW5nIGNvbmRpdGlvbnMg
KG1lbWNnKQ0KRm9yIG1lbWNnIHJlY2xhaW0gaXQgaXMgaGFyZCB0byBzdG9wIG5lYXIgYSB0YXJn
ZXQgcmVjbGFpbSBhbW91bnQ6DQprc3dhcGQgY2FuIGNvbnRpbnVlIHJlY2xhaW1pbmcgZXZlbiBh
ZnRlciB3YXRlcm1hcmtzIGFyZSBtZXQNCihlLmcuIHRvIHNhdGlzZnkgaGlnaGVyLW9yZGVyIG9y
IG1lbWNnIGFsbG9jYXRpb25zKTsNCnJlY2xhaW0gdmlhIHRyeV90b19mcmVlX21lbV9jZ3JvdXBf
cGFnZXMoKSBsYWNrcyBjbGVhciBhYm9ydA0Kc2VtYW50aWNzIGFuZCBjYW4gb3ZlcnNob290IHRo
ZSBpbnRlbmRlZCByZWNsYWltIGFtb3VudC4NCldlIGN1cnJlbnRseSB1c2UgT0VNIGhvb2tzIFsy
XSB0byBlYXJseS1leGl0IG9yIGJ5cGFzcyByZWNsYWltIHVuZGVyDQpzb21lIGNvbmRpdGlvbnMN
Cg0KUTM6IEhpZ2ggcmVjbGFpbSBjb3N0IGFuZCBsb25nIHVuaW50ZXJydXB0aWJsZSBzbGVlcCBv
biBsb3dlci1lbmQNCmRldmljZXMNCk9uIGxvd2VyLWVuZCBkZXZpY2VzLCByZWNsYWltIGNvc3Qg
YW5kIGxhdGVuY3kgYXJlIGhhcmRlciB0byBjb250cm9sOg0KdGhyb3R0bGVfZGlyZWN0X3JlY2xh
aW0gY2FuIG1ha2UgdGFza3Mgd2FpdCBmb3Iga3N3YXBkIGluc3RlYWQgb2YNCmRvaW5nIGRpcmVj
dCByZWNsYWltOw0Kc29tZXRpbWVzIHRoZSB0YXJnZXQgZ2VuZXJhdGlvbnMgaW4gbWFueSBtZW1j
Z3MgaGF2ZSB2ZXJ5IGZldw0KcmVjbGFpbWFibGUNCnBhZ2VzLCBzbyB0aGUgQ1BVIHNwZW5kcyB0
aW1lIHNjYW5uaW5nIHdpdGggbGl0dGxlIHByb2dyZXNzLg0KV2Ugb2JzZXJ2ZSB0YXNrcyBzdGF5
aW5nIGluIHVuaW50ZXJydXB0aWJsZSBzbGVlcCBpbiB0cnlfdG9fZnJlZV9wYWdlcygpDQpXZSBo
YXZlbid0IGZpbmQgYW55IHByb3BlciB3YXlzIHRvIGZpeCBpdC4NCg0KUTQ6IExhY2sgb2YgZ2xv
YmFsIGhvdC9jb2xkICsgcHJpb3JpdHkgdmlldyB3aXRoIHBlci1hcHAgbWVtY2cNCkFuZHJvaWQg
dXNlcyBhIHBlci1hcHAgbWVtY2cgbW9kZWwgYW5kIGZvcmVncm91bmQvYmFja2dyb3VuZCBsZXZl
bHMNCmZvciByZXNvdXJjZSBjb250cm9sLiByb290IHJlY2xhaW0gbGFja3MgYSBjcm9zcy1tZW1j
ZyBob3QvY29sZCBhbmQNCnByaW9yaXR5IHZpZXc7DQpmb3JlZ3JvdW5kIGFwcCBmaWxlIHBhZ2Vz
IG1heSBiZSByZWNsYWltZWQgYW5kIHJlbG9hZGVkIGZyZXF1ZW50bHksDQpjYXVzaW5nIHZpc2li
bGUgc3RhbGxzOw0KV2UgY3VycmVudGx5IHVzZSBhIGhvb2sgWzNdIHRvIHNraXAgcmVjbGFpbSBm
b3IgZm9yZWdyb3VuZCBhcHBzLg0KDQpEaXNjdXNzaW9uDQoNCi0gVmVuZG9yLW9ubHkgd29ya2Fy
b3VuZHMgLT4gZ2VuZXJpYyBtZWNoYW5pc21zIChRMS1RNCkNCk91ciBjdXJyZW50IGZpeGVzICh1
c2Vyc3BhY2UgbWVtY2cgYWdpbmcgWzFdLCBPRU0gcmVjbGFpbSBob29rcw0KWzIsM10pIGFyZSBB
bmRyb2lkL3ZlbmRvci1vbmx54oCUd2hhdCBwYXJ0cyBzaG91bGQgYmUgdHVybmVkIGludG8NCmdl
bmVyaWMgTUdMUlUva2VybmVsIG1lY2hhbmlzbXMgdnMuIGtlcHQgYXMgQW5kcm9pZCBwb2xpY3k/
DQpXZSBuZWVkIGd1aWRhbmNlIGZyb20gY29tbXVuaXR5Lg0KDQotIEhvdyBtdWNoIGNvbnRyb2wg
c2hvdWxkIE1HTFJVIGV4cG9zZSB0byBBbmRyb2lkPyAoUTEtUTMpDQpGb3IgUTEvUTIsIEFuZHJv
aWQgaGFzIHN0cm9uZyBmZy9iZyBhbmQgcHJpb3JpdHkgc2VtYW50aWNzIHRoYXQNCnRoZSBrZXJu
ZWwgZG9lcyBub3Qgc2VlLiBTaG91bGQgTUdMUlUgcHJvdmlkZSBtb3JlIGV4cGxpY2l0IGNvbnRy
b2wNCnBvaW50cyAoZS5nLiBhbm9uLXZzLWZpbGUgLyBnZW5lcmF0aW9uIHN0ZWVyaW5nLA0KInRh
cmdldCBhbW91bnQgKyBhYm9ydCBjb25kaXRpb24iIG1lbWNnIHJlY2xhaW0pIHNvIEFuZHJvaWQg
Y2FuDQpzYWZlbHkgdHJhZGUgY29tcGxleGl0eSBhbmQgcmlzayBmb3IgYmV0dGVyIHBlcmZvcm1h
bmNlIGFuZCBib3VuZGVkDQpyZWNsYWltIGxhdGVuY3kgKFEzKT8NCg0KLSBNR0xSVSBldm9sdXRp
b24gd2l0aG91dCBtZW1jZyBMUlU6IGdsb2JhbCBob3QvY29sZCAmIHNjYW5uaW5nIChRNCkNCklm
IG1lbWNnIExSVSB3aWxsIGJlIHJlbW92ZWQgWzRdLCBob3cgc2hvdWxkIHdlIG1haW50YWluIGEg
Y3Jvc3MtbWVtY2cNCmdsb2JhbCBob3QvY29sZCB2aWV3IGFuZCBwZXItYXBwIHByaW9yaXR5IG9u
IEFuZHJvaWQ/DQpHaXZlbiB0aGF0IG11Y2ggb2YgdGhlIHBvd2VyIGJlbmVmaXQgc2VlbXMgdG8g
Y29tZSBmcm9tIHBhZ2UtdGFibGUNCnNjYW5uaW5nIHdoaWxlIGdlbmVyYXRpb25zIGFyZSBjb21w
bGV4LCBpcyBpdCByZWFzb25hYmxlIHRvIGRlY291cGxlDQpwYWdlLXNjYW5uaW5nIGZ1bmN0aW9u
YWxpdHkgZnJvbSBNR0xSVSBhbmQgbWFrZSBpdCBhIHNlcGVyYXRlIGtlcm5lbA0KY29uZmlndXJh
dGlvbi4NCg0KV2UgYXJlIGhhcHB5IHRvIHNoYXJlIG1vcmUgZGV0YWlsZWQgZGF0YSBhbmQgZXhw
ZXJpbWVudHMgYW5kIHRvIGhlbHANCndpdGggUG9DcyBhbmQgbGFyZ2Utc2NhbGUgdmFsaWRhdGlv
biBpZiB0aGVyZSBpcyBpbnRlcmVzdCBpbg0KcHVyc3VpbmcgdGhlc2UgZGlyZWN0aW9ucy4NCg0K
UmVmZXJlbmNlDQpbMV0gaHR0cHM6Ly9sb3JlLmtlcm5lbC5vcmcvbGludXgtbW0vMjAyNTExMjgw
MjUzMTUuMzUyMDY4OS0xLXdhbmd6aWNoZW5nQGhvbm9yLmNvbS8NClsyXSBodHRwczovL2FuZHJv
aWQtcmV2aWV3Lmdvb2dsZXNvdXJjZS5jb20vYy9rZXJuZWwvY29tbW9uLysvMzg2NjU1NA0KWzNd
IGh0dHBzOi8vYW5kcm9pZC1yZXZpZXcuZ29vZ2xlc291cmNlLmNvbS9jL2tlcm5lbC9jb21tb24v
Ky8zODcwOTIwDQpbNF0gaHR0cHM6Ly9sd24ubmV0L0FydGljbGVzLzEwNTE4ODIvDQoNCi0tDQpC
ZXN0IHJlZ2FyZHMsIGFuZCB3aXNoaW5nIHlvdSBhIHByb3NwZXJvdXMgWWVhciBvZiB0aGUgSG9y
c2UsDQpaaWNoZW5nIFdhbmcNCg==


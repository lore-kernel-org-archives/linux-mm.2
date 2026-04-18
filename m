Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F018BF436BC
	for <linux-mm@archiver.kernel.org>; Sat, 18 Apr 2026 07:17:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D00526B019B; Sat, 18 Apr 2026 03:17:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CB0CA6B019C; Sat, 18 Apr 2026 03:17:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B9F916B019D; Sat, 18 Apr 2026 03:17:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A87A86B019B
	for <linux-mm@kvack.org>; Sat, 18 Apr 2026 03:17:49 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id E571E13AF13
	for <linux-mm@kvack.org>; Sat, 18 Apr 2026 07:17:48 +0000 (UTC)
X-FDA: 84670821816.03.DF6BC38
Received: from mta22.hihonor.com (mta22.hihonor.com [81.70.192.198])
	by imf07.hostedemail.com (Postfix) with ESMTP id C706940002
	for <linux-mm@kvack.org>; Sat, 18 Apr 2026 07:17:45 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=honor.com header.s=dkim header.b=UYZz4mFD;
	spf=pass (imf07.hostedemail.com: domain of wangzicheng@honor.com designates 81.70.192.198 as permitted sender) smtp.mailfrom=wangzicheng@honor.com;
	dmarc=pass (policy=none) header.from=honor.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776496667;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YcnYwxdm11l2YsV38nkbZmy+ORKmwW84uUYUMtyVXY8=;
	b=MT5P1P2TJO6Ae8rvCNUWra6WVhUXsAjrRFybk4/icmjNohb4/3RmUWAwhr/j2WnANz+9aT
	MDKhQK95c32p6/yBY2pEOxU7vTkQxU0Zb06U5XQL5+uKe44v3NEK9pBrjMK4951pcnf1yC
	LkXHywg6wNRNYJSKxnfKopkwrOZBDwQ=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=honor.com header.s=dkim header.b=UYZz4mFD;
	spf=pass (imf07.hostedemail.com: domain of wangzicheng@honor.com designates 81.70.192.198 as permitted sender) smtp.mailfrom=wangzicheng@honor.com;
	dmarc=pass (policy=none) header.from=honor.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776496667; a=rsa-sha256;
	cv=none;
	b=s5W27zCLs/ucCV7xALBRbI9a4ecQXNTbY/bZaP/87du4IVbxN8wn43OKR6wvETo4W1vSwj
	0/XRDjxREcaGHiSgamCCxV2aCSFrF1PeEH9Ne5xJ5omeuiMzu6ZbbZqTAxYr3rmDY1eMtC
	ZUVXgIQMO4W7Nw0N4BcJIhk4onZxBoM=
dkim-signature: v=1; a=rsa-sha256; d=honor.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=To:From;
	bh=YcnYwxdm11l2YsV38nkbZmy+ORKmwW84uUYUMtyVXY8=;
	b=UYZz4mFDb65uYVcDZUkDVBHEOJAXqR1d3xDw1+CdSB3t4TM9uMurjBP5AgVXxZvxZeNp4B+iO
	T+uwYHaLdKuW/qhGvfzaIX6NJ8SRmZfmnPwy0XyuWQjpnvSRGt43HMzLx6s0DUzj6d9Huc0Wnj/
	vZMtyKwOYhUdYCMlZ5A70/0=
Received: from w012.hihonor.com (unknown [10.68.27.189])
	by mta22.hihonor.com (SkyGuard) with ESMTPS id 4fyNN81L81zYl9tb;
	Sat, 18 Apr 2026 15:16:40 +0800 (CST)
Received: from TA007.hihonor.com (10.77.205.64) by w012.hihonor.com
 (10.68.27.189) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.27; Sat, 18 Apr
 2026 15:17:40 +0800
Received: from TA012.hihonor.com (10.77.228.68) by TA007.hihonor.com
 (10.77.205.64) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.37; Sat, 18 Apr
 2026 15:17:40 +0800
Received: from TA012.hihonor.com ([fe80::9e31:9fdb:69fb:928c]) by
 TA012.hihonor.com ([fe80::9e31:9fdb:69fb:928c%8]) with mapi id
 15.02.2562.017; Sat, 18 Apr 2026 15:17:20 +0800
From: wangzicheng <wangzicheng@honor.com>
To: wangxinyu19 <wxy2009nrrr@163.com>, "devnull+kasong.tencent.com@kernel.org"
	<devnull+kasong.tencent.com@kernel.org>
CC: "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
	"axelrasmussen@google.com" <axelrasmussen@google.com>, "baohua@kernel.org"
	<baohua@kernel.org>, "baolin.wang@linux.alibaba.com"
	<baolin.wang@linux.alibaba.com>, "chenridong@huaweicloud.com"
	<chenridong@huaweicloud.com>, "chrisl@kernel.org" <chrisl@kernel.org>,
	"david@kernel.org" <david@kernel.org>, "hannes@cmpxchg.org"
	<hannes@cmpxchg.org>, "kaleshsingh@google.com" <kaleshsingh@google.com>,
	"kasong@tencent.com" <kasong@tencent.com>, "laoar.shao@gmail.com"
	<laoar.shao@gmail.com>, "lenohou@gmail.com" <lenohou@gmail.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-mm@kvack.org" <linux-mm@kvack.org>, "ljs@kernel.org" <ljs@kernel.org>,
	"mhocko@kernel.org" <mhocko@kernel.org>, "qi.zheng@linux.dev"
	<qi.zheng@linux.dev>, "shakeel.butt@linux.dev" <shakeel.butt@linux.dev>,
	"stevensd@google.com" <stevensd@google.com>, "surenb@google.com"
	<surenb@google.com>, "vernon2gm@gmail.com" <vernon2gm@gmail.com>,
	"weixugc@google.com" <weixugc@google.com>, "yuanchu@google.com"
	<yuanchu@google.com>, "yuzhao@google.com" <yuzhao@google.com>,
	"zhengqi.arch@bytedance.com" <zhengqi.arch@bytedance.com>, wangzhen
	<wangzhen5@honor.com>, wangtao <tao.wangtao@honor.com>
Subject: RE: [PATCH v5 00/14] mm/mglru: improve reclaim loop and dirty folio
 handling
Thread-Topic: [PATCH v5 00/14] mm/mglru: improve reclaim loop and dirty folio
 handling
Thread-Index: AQHcypwxcxsnTRgug0iAuixHwWXWW7XiDtKAgAJZVUA=
Date: Sat, 18 Apr 2026 07:17:20 +0000
Message-ID: <3a28d9d327d84ae192fb3dcb925a0674@honor.com>
References: <20260413-mglru-reclaim-v5-0-8eaeacbddc44@tencent.com>
 <20260417025123.2971253-1-wxy2009nrrr@163.com>
In-Reply-To: <20260417025123.2971253-1-wxy2009nrrr@163.com>
Accept-Language: en-US
Content-Language: zh-CN
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-originating-ip: [10.163.18.229]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-Stat-Signature: k8uw67h1airh6d7zdomuun3o8dcq43xi
X-Rspamd-Queue-Id: C706940002
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1776496665-152408
X-HE-Meta: U2FsdGVkX1+eA7/1sUKJmu5DAi4AIBz/7pFf3vzqWigTY63wwynETrl02wBFEDzKGTlqGS7fumPTEtG+p+av+stvztFwSer0Do7egfPbTnP7XjtUhPQJIaJ8KOgyEJ/F8O4AWbjzEQCcDHrFfhhLjpefB3aBSz/+ZNKzm7ZdfAlgm9fMeMVzCQwkN2+nSZchpycvd7zrnitufNi8PkY2YbU9aTlTBmZdH9EXedbOHLWrVQhLggbwvTkqQ+QswiQ1H6AfpWJBOLUOBjxRvzAyaXUvqgzGNUq9G9pzsIkUx731bjAdstFmbMU0YYlaX0eWHFDylc1kPtuEOUfSimdi5kYDMOd4L7IKURkMvhJEvIyERrHmn2B1rHw2PeZ+X1HWsdwkB9WVxUKThciE+6u1T3C+ezYWy2qmRxOQrpVdznXfa/f2rpSlXWX+ujl8lmOCvai7WXXUzQQbsZC4J3fYLvv4M58zngHNVmyz4o0H85IEakvkJ9guZxx5+f7+ByOjcHpRZIqXPUL23Beo4CFxdsEjV/oG3cYeEDTYfhUNSXByk7/jFADqGoQ/w5qtCMb8v1/3VMTQnb00DRYBIIGm+p803lLWHWaE81tMJB5lvBjaWsl6fdijUeT2jwTV4KW6PYsiEEu/py655PaGZA9fJm7C+vVRyPnFDsEqqbS+zVoHhFnCNU6R/FKMB4Tb8ysrMPTxn0LT7nMDP6S5FBAkUfHAVGtHNI/GmxZoZHL3reQ6FhiwTKDuKJ8sAeMusrHbufW0z98XIZJa/S/SvK63LAWzsfnHKsKz9kDIwYYJTWrY1IO3mOXzY46aESKFV51MkoX+k2Z0JkdRoQ3EYLNA3Qzg2JUyebssojF6nUa4BFnZ5ldOyBIOxSQs1CNhq+sJWeAo+1hQNt9X29w+13IZXkqewSnXMm1BT/viHVCXYB/yRYvyjSEtJJtEOb+h+U9NxwIowmX3bS/dRDdJxRV
 KuT4b24L
 16pLXrV3Ch/eZI0zpygJuxeS0K1WS8ktQoXgaV5183QppYcg+rALouYdrLAMQ9pqcrB5AfF0/2c11NNteoDfcuUejC1z6RRbalQWIXNaSs2nNiGxEqvpEA41ioC14SMT+Zg9woS1C6iNHgWQS7cjlevGUyCr5h/NRqTZQI7xMW9lTN1WJ9X6UsfUiK3zlDVV1Y3sf7uAbHzkYmQpEIASl61ZT4EIfPFS/R+xfXA09MK0rhI13Wa8lsh/dNPd6I+Kl3UtvHPpa2yuSxFKbiislKCgEFkEDiJ2uZkh46cqcwMo3SQHFnBfBrVW39a8B1v3t8aYrcg95M4KFNfdQD/x2u4UFTxt9g4Bqk9Q31ly5ooBSE+IVtgV4irjAABm3inztC8+EaGLzviKKfV0JDX3U5Ncn4JHnFTX9w/1GnXPmN8X/oK34rdbXnW1cvTAd7Iq8bsILou5J3KXUmVCPEtDB52An8o7JUW79LQW+OBIxJrC2TmaJQZXcDnwYduJLYwUvwwon9DApDiRIF3XsKyqjpce7j0qtZlD2GZUf
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

PiBIaSBLYWlydWksDQo+IA0KPiBXZSBoYXZlIHRlc3RlZCB0aGlzIHBhdGNoIHNlcmllcyBvbiBB
bmRyb2lkIGRldmljZSB1bmRlciBhIHR5cGljYWwgc2NlbmFyaW8uDQo+IA0KPiBUaGUgdGVzdCBj
b25zaXN0ZWQgb2YgY29sZC1zdGFydGluZyBtdWx0aXBsZSBhcHBsaWNhdGlvbnMgc2VxdWVudGlh
bGx5DQo+IHVuZGVyIG1vZGVyYXRlIHN5c3RlbSBsb2FkIChzb21lIHNlcnZpY2VzIHJ1bm5pbmcg
b24gdGhlIGJhY2tncm91bmQsDQo+IHN1Y2ggYXMgbWFwIG5hdmlnYXRpbmcsIEFJIHZvaWNlLWFz
c2lzdGFudCkuIEVhY2ggdGVzdCByb3VuZCBjb2xkLXN0YXJ0cw0KPiBhIGZpeGVkIHNldCBvZiBh
cHBzIG9uZSBieSBvbmUgYW5kIHJlY29yZHMgdGhlIGNvbGQgc3RhcnQgbGF0ZW5jeS4NCj4gQSB0
b3RhbCBvZiAxMDAgcm91bmRzIHdlcmUgY29uZHVjdGVkIHRvIGVuc3VyZSBzdGF0aXN0aWNhbCBz
aWduaWZpY2FuY2UuDQo+IA0KDQpIaSBYaW55dSBhbmQgS2FpcnVpLA0KDQpXZSBoYXZlIHRlc3Qg
dGhlIHBhdGNoIHVuZGVyIGEgKipoZWF2eSoqIGxvYWQgYmVuY2htYXJrIGZvciBjYW1lcmEuDQoN
Cj4gQmVmb3JlOg0KPiAgIC9wcm9jL3Ztc3RhdCBpbmZvOg0KPiAgICAgcGdwZ2luIDI2OSwyMjQN
Cj4gICAgIHBncGdvdXQgMjI2LDA3OA0KPiAgICAgd29ya2luZ3NldF9yZWZhdWx0X2Fub24gMjM3
DQo+ICAgICB3b3JraW5nc2V0X3JlZmF1bHRfZmlsZSAyNzY4OQ0KPiANCj4gICBMYXVuY2ggVGlt
ZSBTdW1tYXJ5IChhbGwgYXBwcywgYWxsIHJ1bnMpDQo+ICAgICBNZWFuIDg2OC4wbXMNCj4gICAg
IFA1MCA4ODguMG1zDQo+ICAgICBQOTAgMTI3NC4ybXMNCj4gICAgIFA5NSAxMzk5LjBtcw0KPiAN
Cj4gQWZ0ZXI6DQo+ICAgL3Byb2Mvdm1zdGF0IGluZm86DQo+ICAgICBwZ3BnaW4gMjIzLDgwMSAg
ICAgICAgICAgICAgICAoLTE2LjklKQ0KPiAgICAgcGdwZ291dCAzMDgsODczDQo+ICAgICB3b3Jr
aW5nc2V0X3JlZmF1bHRfYW5vbiA0OTgNCj4gICAgIHdvcmtpbmdzZXRfcmVmYXVsdF9maWxlIDE3
MDc1ICgtMzguMyUpDQo+IA0KPiAgIExhdW5jaCBUaW1lIFN1bW1hcnkgKGFsbCBhcHBzLCBhbGwg
cnVucykNCj4gICAgIE1lYW4gODUwLjVtcyAoLTIuMDclKQ0KPiAgICAgUDUwIDg2MS41bXMgICgt
My4wNCUpDQo+ICAgICBQOTAgMTE3OS4wbXMgKC04LjA1JSkNCj4gICAgIFA5NSAxMjI4LjBtcyAo
LTEyLjIlKQ0KPiANCj4gLS0NCj4gQmVzdCByZWdhcmRzLA0KPiBYaW55dQ0KPiANCg0KV2UgZXZh
bHVhdGVkIHRoZSBiYWNrcG9ydGVkIHBhdGNoZXMgb24gYW5kcm9pZDE2LTYuMTIgdXNpbmcgYSAq
KmhlYXZ5KioNCm1vYmlsZSB3b3JrbG9hZCBvbiBhIFF1YWxjb21tIDg4NTAgZGV2aWNlICgxNkdC
IFJBTSArIDE2R0IgenJhbSkuDQoodm1zY2FuIGNvZGUgaW4gdGhpcyB0cmVlIGlzIGxhcmdlbHkg
c2ltaWxhciB0byB2Ni4xOCkNCg0KVGhlIHdvcmtsb2FkIHNpbXVsYXRlcyByZWFsIHVzZXIgYmVo
YXZpb3IgYnkgc2VxdWVudGlhbGx5DQpjb2xkLXN0YXJ0aW5nIDIzIGFwcHMuIEZvciBlYWNoIGFw
cGxpY2F0aW9uIHdlIHBlcmZvcm0gdGhlIHJlbGF0ZWQNCm9wZXJhdGlvbnMgKHNob3J04oCRdmlk
ZW8gc3dpcGluZywgYmFja2dyb3VuZCBtdXNpYyBwbGF5YmFjaywgYW5kDQpuYXZpZ2F0aW9uKS4g
QWZ0ZXIgZXhpdGluZyBvbmUgYXBwbGljYXRpb24gdGhlIG5leHQgaXMgbGF1bmNoZWQNCmltbWVk
aWF0ZWx5IGluIDFzLiBBZnRlciBhbGwgYXBwcyBjb21wbGV0ZSwgdGhlIGNhbWVyYSBpcyBsYXVu
Y2hlZA0KYW5kIGEgcGhvdG8gaXMgdGFrZW4uDQoNCkJhc2VsaW5lIGFuZCBwYXRjaGVkIGtlcm5l
bHMgd2VyZSB0ZXN0ZWQgdW5kZXIgaWRlbnRpY2FsIGNvbmRpdGlvbnMuDQood2l0aCBhIGZhbiBr
ZXB0IGNvb2xpbmcgdGhlIHRlc3RiZWQpDQpGdWxsIHN5c3RlbSB0cmFjZXMgd2VyZSBjb2xsZWN0
ZWQgZm9yIHRocmVlIHJ1bnMgaW4gZWFjaA0KY29uZmlndXJhdGlvbiwgYW5kIHRlbiBhZGRpdGlv
bmFsIHRyYWNlcyB3ZXJlIHJlY29yZGVkIGZvciB0aGUgZmluYWwNCmNhbWVyYSBsYXVuY2ggc3Rh
Z2UuDQoNCk92ZXJhbGwgYXBwbGljYXRpb24ga2VlcGFsaXZlIGJlaGF2aW9yIHNob3dzIG5vIG5v
dGljZWFibGUNCmRpZmZlcmVuY2UuIEhvd2V2ZXIsIHdlIG9ic2VydmVkIHBlcmZvcm1hbmNlIGRl
dmlhdGlvbnMgaW4gc29tZQ0KbWVtb3J54oCRcHJlc3N1cmUgc2NlbmFyaW9zLg0KDQpCZWZvcmU6
DQpNZW1pbmZvICgxMDAgbXMgcGVyIHNhbXBsZSwgYXZlcmFnZSByZXN1bHQpDQpNZW1BdmFpbGFi
bGU6IDU0MjANCk1lbUZyZWU6IDE0MjENCkNhY2hlZDogMzg2Mg0KQW5vblBhZ2VzOiAzODA0DQpE
aXJ0eTogNjINCnZtc3RhdCBjb3VudGVycyAobGFzdCBzYW1wbGUpDQpwZ3BnaW46IDMsNzAxLDg2
OQ0KcGdwZ291dDogMyw1NDUsMDU4DQp3b3JraW5nc2V0X3JlZmF1bHRfYW5vbjogMzkwLDk2Nw0K
d29ya2luZ3NldF9yZWZhdWx0X2ZpbGU6IDc5LDkyNw0KVG90YWwgYXBwIGxhdW5jaCB0aW1lICgy
MyBhcHBzICsgbGF1bmNoZXIgw5cgMjMpOiA3NzAyIG1zDQpDYW1lcmEgbGF1bmNoIHRpbWU6IDY4
NCBtcw0KDQpBZnRlcjoNCk1lbWluZm8gKDEwMCBtcyBwZXIgc2FtcGxlLCBhdmVyYWdlIHJlc3Vs
dCkNCk1lbUF2YWlsYWJsZTogNTA1OCAoLTclKQ0KTWVtRnJlZTogMTM4MiAoLTMlKQ0KQ2FjaGVk
OiAzMjEzICgtMTclKQ0KQW5vblBhZ2VzOiAzNjM3ICgtNCUpDQpEaXJ0eTogMzUgKC00NCUpDQp2
bXN0YXQgY291bnRlcnMgKGxhc3Qgc2FtcGxlKQ0KcGdwZ2luOiA1LDc1Miw0MjkgKCs1NSUpDQpw
Z3Bnb3V0OiAzLDY2OCw3ODggKCszJSkNCndvcmtpbmdzZXRfcmVmYXVsdF9hbm9uOiAxLDQ5Miw5
NjQgKCsyODIlKQ0Kd29ya2luZ3NldF9yZWZhdWx0X2ZpbGU6IDU5MCw1MDUgKCs2MzklKQ0KVG90
YWwgYXBwIGxhdW5jaCB0aW1lICgyMyBhcHBzICsgbGF1bmNoZXIgw5cgMjMpOiA4ODcyIG1zICgr
MTUlKQ0KQW1vbmcgdGhlIHRlc3RlZCBhcHBzLCAxMSBpbXByb3ZlZCB3aGlsZSAxNCByZWdyZXNz
ZWQuDQpDYW1lcmEgbGF1bmNoIHRpbWU6IDk4MCBtcyAoKzQzJSksIHdoaWNoIGlzIGFsc28gdGhl
IHN0YWdlIHdpdGggdGhlDQpoaWdoZXN0IG1lbW9yeSBwcmVzc3VyZS4NCg0KRnJvbSB3aG9sZSB0
cmFjZSBhbmFseXNpcywgZGlyZWN0IHJlY2xhaW0gYXBwZWFycyB0byBydW4gc2xvd2VyLg0KQmVm
b3JlIHYucy4gYWZ0ZXINCnRvdGFsIGR1cmF0aW9uOiAxMTY1OSBtcyAvIDU3MDA2IG1zDQp0b3Rh
bCByZWNsYWltZWQ6IDM5NTMgTUIgLyA2MzQ0IE1CDQpzcGVlZDogMC4zMzkgTUIvbXMgLyAwLjEx
MSBNQi9tcw0KdGltZXM6IDE2MTE3IC8gMjc1NjINCg0KVGhlIHBlcmZvcm1hbmNlIG1pZ2h0IGJl
aGF2ZSBkaWZmZXJlbnRseSBvbiBkZXZpY2VzIHdpdGggc21hbGxlciBtZW1vcnkNCihlLmcuIDji
gJMxNkdCKSBjb21wYXJlZCB0byBzZXJ2ZXJzIHdpdGggMTAwK0dCIG1lbW9yeSwgb3IgdW5kZXIN
Cm1vZGVyYXRlIHRvIGhlYXZ5IG1lbW9yeSBwcmVzc3VyZS4NCkNvdWxkIHRoaXMgYmUgcmVsYXRl
ZCB0byBwYXRjaCAwOS8xNFsxXSB3aGljaCByZW1vdmVzIGZvbGlvX2luY19nZW4oKQ0Kd2hlbiBg
IHdyaXRlYmFjayB8fCAodHlwZSA9PSBMUlVfR0VOX0ZJTEUgJiYgZGlydHkpYD8NCg0KQW55IGNv
bW1lbnRzIG9yIHN1Z2dlc3Rpb25zIHdvdWxkIGJlIGFwcHJlY2lhdGVkLg0KDQpbMV0gaHR0cHM6
Ly9sb3JlLmtlcm5lbC5vcmcvbGludXgtbW0vMjAyNjA0MTMtbWdscnUtcmVjbGFpbS12NS0wLThl
YWVhY2JkZGM0NEB0ZW5jZW50LmNvbS9ULyNtNTY4ZWJhODRkMzVkOGQ1ZmY1MTlkM2UyOTIzN2Rl
NmQ2NGY2NzY1OQ0KDQpCZXN0LA0KWmljaGVuZw0KDQo=


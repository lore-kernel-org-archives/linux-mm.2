Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D2486EF48C5
	for <linux-mm@archiver.kernel.org>; Sat, 14 Feb 2026 10:06:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B679D6B0005; Sat, 14 Feb 2026 05:06:14 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B15986B0088; Sat, 14 Feb 2026 05:06:14 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A3F386B008A; Sat, 14 Feb 2026 05:06:14 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 93CCA6B0005
	for <linux-mm@kvack.org>; Sat, 14 Feb 2026 05:06:14 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 6D89A1C981
	for <linux-mm@kvack.org>; Sat, 14 Feb 2026 10:06:13 +0000 (UTC)
X-FDA: 84442631826.16.C639919
Received: from mta21.hihonor.com (mta21.hihonor.com [81.70.160.142])
	by imf07.hostedemail.com (Postfix) with ESMTP id B4FA84000E
	for <linux-mm@kvack.org>; Sat, 14 Feb 2026 10:06:09 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=honor.com;
	spf=pass (imf07.hostedemail.com: domain of wangzicheng@honor.com designates 81.70.160.142 as permitted sender) smtp.mailfrom=wangzicheng@honor.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771063570;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references; bh=w3oVWRqVzXAGHBE7lTcq5FW0IOdli7QPuJQYM7Iob34=;
	b=Dt7r136s8iXHsZ9I+P94yiefWtEE9AR3umu3y6cGdP/5BGCiCIprkWUwAj9K0jcqZXUH7G
	wCvv8iG/UpxAK1cQ38TsVqyUzu9tNYmxI9N13RkwpfRj273dvb3SMjutTFANOlyFtyucYK
	s4y3xhqhUksgPspzboACHOhOH1rTUAQ=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=honor.com;
	spf=pass (imf07.hostedemail.com: domain of wangzicheng@honor.com designates 81.70.160.142 as permitted sender) smtp.mailfrom=wangzicheng@honor.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771063570; a=rsa-sha256;
	cv=none;
	b=3H+vMJguixzEbi42i7jRa7Gv7SMgcR/3NbkVSc16J6h7vES6NYn6DFyQ+0c0HFZPjHVQBW
	ENDCWnz5B4O+jbfSOQmZc75rAhScZ8bQ9+i+ihhXykEaGoLWht2zpOunjm3/iB3ul5prcx
	XV6ctyPY0YnqN2GCwus0QajtqcSzCIE=
Received: from w002.hihonor.com (unknown [10.68.28.120])
	by mta21.hihonor.com (SkyGuard) with ESMTPS id 4fCl2s3MZYzYtb07;
	Sat, 14 Feb 2026 18:02:45 +0800 (CST)
Received: from a010.hihonor.com (10.68.16.52) by w002.hihonor.com
 (10.68.28.120) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.27; Sat, 14 Feb
 2026 18:06:04 +0800
Received: from w002.hihonor.com (10.68.28.120) by a010.hihonor.com
 (10.68.16.52) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.27; Sat, 14 Feb
 2026 18:06:04 +0800
Received: from w002.hihonor.com ([fe80::ef6f:d9c5:cf75:d4d3]) by
 w002.hihonor.com ([fe80::ef6f:d9c5:cf75:d4d3%14]) with mapi id
 15.02.2562.027; Sat, 14 Feb 2026 18:06:04 +0800
From: wangzicheng <wangzicheng@honor.com>
To: "lsf-pc@lists.linux-foundation.org" <lsf-pc@lists.linux-foundation.org>,
	"linux-mm@kvack.org" <linux-mm@kvack.org>
CC: wangxin 00023513 <wangxin23@honor.com>, gao xu <gaoxu2@honor.com>, wangtao
	<tao.wangtao@honor.com>, liulu 00013167 <liulu.liu@honor.com>, zhouxiaolong
	<zhouxiaolong9@honor.com>, linkunli <linkunli@honor.com>
Subject: [LSF/MM/BPF TOPIC] MGLRU on Android: Real-World Problems and
 Challenges
Thread-Topic: [LSF/MM/BPF TOPIC] MGLRU on Android: Real-World Problems and
 Challenges
Thread-Index: AdydmBxyZyfDdnnJTJ6R043ZWmrr6Q==
Date: Sat, 14 Feb 2026 10:06:04 +0000
Message-ID: <cb0c0a0bfc7247cf85858eecf0db6eca@honor.com>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-originating-ip: [10.163.18.229]
Content-Type: text/plain; charset="gb2312"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-Rspamd-Server: rspam11
X-Stat-Signature: tcuh8jt8yyrurjiecsst387f654rhcno
X-Rspam-User: 
X-Rspamd-Queue-Id: B4FA84000E
X-HE-Tag: 1771063569-757310
X-HE-Meta: U2FsdGVkX19FXyBXfZXOmUd1ADXmnN/W1hR0b/WnlWonprCHG1CkQHmVRRjRmRBTqF9Tzkv1q7FaSgJuLsOqh6+g4H+WfGKE+hIwlBmAMyDh2LN5jYCyZKeVcY9+yokIIJN3JpkML1/W+AiJPdvDjwE2dyskz5CCv97e86PbRw6rj+l+qM17KwugvYxLLiN+Ws3FrfOdOlTrDF0elXSFwai4FQzlqcuwMCsPn2aGl/BCwzK68PwaZuUp8fu/ifiTPaOQfM9u49SE8zuqhDwqgG2jrFXeYMe6pO2knaiC6mS4Liio2Ea60NGNq2UHKbxOVaYRasDubovchpR0SuxG4JOJl1x0e0gHYVj9aapJwZmLPugnKUzka8aMMall+XLK2sw+nbMQbUxQyjSL2tjlDGtDm/WUggiR2DCACzm2F1ECGWAuat8vSfauWmL3IY+X9UkX94vveA9yEmSYLRTUxgdGduHph10t62Wa3b1GDG/5GW+S1C4kz0kEGuwL1S0Zl5AXkJKl39a5TY4RVFWmdH/QmjnJiF9OVVWIYdlyCjK/Lmxh9GAGoDfzm1GiFwakPn6PVsY0flx41OBrQdFiZSFSNyu1tJ9hhd/a9gtnWPTgRMx5twn3PFIjeHlPTAE5zUVuMWpDD/Y2FytEDwKRqv2OjntWZIkpAndwcQUrrZakcpUzgZxwxb3Zfc0niUE3W9rrio78rdcOVp+dqYv2WGoAlXw7MbR1LWLkhjCz1/0zED2U32Ymv1aZQB36K581/FvYMyijlj9iFkbE97VMKIkQTWwEhX7BQ5TtrbeQpmotxc8zSc8XBVSuOu73/O1TltK23Ot68CPjgEdv7GLmMJ6TVA+6najl8GWTL+dGxs9WcYxxuRq0+5MMlAWnH30tdA7O4DCGAF346VSMvuMbaAkJ3Py7UXMEw+n2QHg0xIMMNSne89SxVqoP+4N2DBB/gcHxAZkVJZAfl1wDLfU
 yGtMfpMH
 WoxZekJ/siEc42QANVGrqlWMcrH7RFMl91ZVtatZoI9Y7NvXaONkYk5J1PYRJ98zQUwzRy+vAoGkGZihijvWRx62k2MgLxp4NF2tz9vGQUueivm4crLCMoEo+5GRLw58Ckp0Qt0qtZyW1J+yo/JZ2/ghqE2OmNh21XCSL/2gDgHFFZz9mA3wEfFQ4Ul5iWbno7eeXqT8aaQCt8quRNBSdJEEmydhgYgC+ShQ6SQGAOgOqzRwxBOOnZwfgZwc6G8B/OBccPfsuqvN77Ni5nJfxxgY600fpR1vRvRNLZCF9I/WyUBSag2dlNGOjz7kALkYZLjOkfmX20v89Rr0IcQnZdlYBQWoZ8bAb8BE6aIpqEVxrCbFEzLJq8hks46pq/40Zks1R07x1xedjzR/tY402o6e8P/gGzWaSAAVwQTE5ShSQg/EzZck41Lwymy6w4908ChD+TG45sJUlx1CDh1eNys6KbbpI1WS+5xNK+S8h/wIytqn3aV9mYn2OJQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.347526, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

SGksDQoNCk1HTFJVIGhhcyBiZWVuIGF2YWlsYWJsZSBvbiBBbmRyb2lkIGZvciBhYm91dCBmb3Vy
IHllYXJzLCBidXQgbWFueQ0KT0VNIHZlbmRvcnMgc3RpbGwgY2hvb3NlIG5vdCB0byBlbmFibGUg
aXQgaW4gcHJvZHVjdGlvbi4NCkhPTk9SIGlzIGEgbWFqb3IgQW5kcm9pZCBPRU0gc2hpcHBpbmcg
dGVucyBvZiBtaWxsaW9ucyBvZiBkZXZpY2VzDQpwZXIgeWVhciwgYW5kIHdlIHJ1biBNR0xSVSBv
biBhbGwgb3VyIGRldmljZXMgYWNyb3NzIG11bHRpcGxlIGtlcm5lbA0KdmVyc2lvbnMgKDUuMTV+
Ni4xMikgYW5kIFJBTSBjb25maWd1cmF0aW9ucyg0R34yNEcpLCBiYWNrZWQgYnkNCmxhcmdlLXNj
YWxlIGJldGEgYW5kIGZpZWxkIGRhdGEuIEZyb20gdGhpcyBkZXBsb3ltZW50LCB3ZSBoYXZlIGlk
ZW50aWZpZWQNCmZvdXIgY29uY3JldGUgaXNzdWVzIChRMahDUTQpIGFuZCBjdXJyZW50IHdvcmth
cm91bmRzLCBhbmQgd291bGQgbGlrZSB0bw0Kd29yayB3aXRoIHRoZSBjb21tdW5pdHkgdG8gZGVz
aWduIHVwc3RyZWFtIHNvbHV0aW9ucy4gDQpBbHNvIHdlIHdvdWxkIGxpa2UgdG8gZGlzY3VzcyBN
R0xSVaGvcyBmdXR1cmUgZGlyZWN0aW9uIG9uIEFuZHJvaWQuDQoNCkJlbG93IGlzIGEgc2hvcnQg
c3VtbWFyeSBvZiB3aGF0IHdlIHNlZS4NCg0KUTE6IGFub24vZmlsZSBpbWJhbGFuY2UgYW5kIGRy
b3AgaW4gYXZhaWxhYmxlIG1lbW9yeQ0KQW5kcm9pZCBhcHBzIHdvcmtsb2FkIHNob3cgYSBwZXJz
aXN0ZW50IGFub24vZmlsZSBnZW5lcmF0aW9uYWwNCmltYmFsYW5jZSB1bmRlciBNR0xSVToNCmFu
b24gcGFnZXMgdGVuZCB0byBzdGF5IGluIHRoZSB5b3VuZ2VzdCAyIGdlbmVyYXRpb25zOw0KZmls
ZSBwYWdlcyBhcmUgc3ByZWFkIGFjcm9zcyBtdWx0aXBsZSBnZW5lcmF0aW9ucyBhbmQgb3Zlci1y
ZWNsYWltZWQuDQpUdW5pbmcgc3dhcHBpbmVzcyB0byAyMDAgYW5kIEFOT05fT05MWSBkb2VzIG5v
dCBmdWxseSBmaXggdGhpcy4NCk9uIGEgMTZHIG1lZGlhIHdvcmtsb2FkIHdlIHNlZToNCk1HTFJV
OiBNZW1BdmFpbGFibGUgodYgNjA2MCBNQg0KbGVnYWN5OiBNZW1BdmFpbGFibGUgodYgNjk4MiBN
QiAoZGlmZmVycyBieSB+MUcpDQpUb2RheSB3ZSBtaXRpZ2F0ZSB0aGlzIHZpYSBleHBsaWNpdCBt
ZW1jZyBhZ2luZyBpbiBBbmRyb2lkDQp1c2Vyc3BhY2UgWzFdLCB3aGljaCBpcyBhIHZlbmRvci1v
bmx5IHdvcmthcm91bmQuDQoNClEyOiBIYXJkIHRvIGNvbnRyb2wgcmVjbGFpbSBhbW91bnQgYW5k
IHN0b3BwaW5nIGNvbmRpdGlvbnMgKG1lbWNnKQ0KRm9yIG1lbWNnIHJlY2xhaW0gaXQgaXMgaGFy
ZCB0byBzdG9wIG5lYXIgYSB0YXJnZXQgcmVjbGFpbSBhbW91bnQ6DQprc3dhcGQgY2FuIGNvbnRp
bnVlIHJlY2xhaW1pbmcgZXZlbiBhZnRlciB3YXRlcm1hcmtzIGFyZSBtZXQNCihlLmcuIHRvIHNh
dGlzZnkgaGlnaGVyLW9yZGVyIG9yIG1lbWNnIGFsbG9jYXRpb25zKTsNCnJlY2xhaW0gdmlhIHRy
eV90b19mcmVlX21lbV9jZ3JvdXBfcGFnZXMoKSBsYWNrcyBjbGVhciBhYm9ydA0Kc2VtYW50aWNz
IGFuZCBjYW4gb3ZlcnNob290IHRoZSBpbnRlbmRlZCByZWNsYWltIGFtb3VudC4NCldlIGN1cnJl
bnRseSB1c2UgT0VNIGhvb2tzIFsyXSB0byBlYXJseS1leGl0IG9yIGJ5cGFzcyByZWNsYWltIHVu
ZGVyDQpzb21lIGNvbmRpdGlvbnMNCg0KUTM6IEhpZ2ggcmVjbGFpbSBjb3N0IGFuZCBsb25nIHVu
aW50ZXJydXB0aWJsZSBzbGVlcCBvbiBsb3dlci1lbmQNCmRldmljZXMNCk9uIGxvd2VyLWVuZCBk
ZXZpY2VzLCByZWNsYWltIGNvc3QgYW5kIGxhdGVuY3kgYXJlIGhhcmRlciB0byBjb250cm9sOg0K
dGhyb3R0bGVfZGlyZWN0X3JlY2xhaW0gY2FuIG1ha2UgdGFza3Mgd2FpdCBmb3Iga3N3YXBkIGlu
c3RlYWQgb2YNCmRvaW5nIGRpcmVjdCByZWNsYWltOw0Kc29tZXRpbWVzIHRoZSB0YXJnZXQgZ2Vu
ZXJhdGlvbnMgaW4gbWFueSBtZW1jZ3MgaGF2ZSB2ZXJ5IGZldyByZWNsYWltYWJsZQ0KcGFnZXMs
IHNvIHRoZSBDUFUgc3BlbmRzIHRpbWUgc2Nhbm5pbmcgd2l0aCBsaXR0bGUgcHJvZ3Jlc3MuDQpX
ZSBvYnNlcnZlIHRhc2tzIHN0YXlpbmcgaW4gdW5pbnRlcnJ1cHRpYmxlIHNsZWVwIGluIHRyeV90
b19mcmVlX3BhZ2VzKCkNCldlIGhhdmVuJ3QgZmluZCBhbnkgcHJvcGVyIHdheXMgdG8gZml4IGl0
Lg0KDQpRNDogTGFjayBvZiBnbG9iYWwgaG90L2NvbGQgKyBwcmlvcml0eSB2aWV3IHdpdGggcGVy
LWFwcCBtZW1jZw0KQW5kcm9pZCB1c2VzIGEgcGVyLWFwcCBtZW1jZyBtb2RlbCBhbmQgZm9yZWdy
b3VuZC9iYWNrZ3JvdW5kIGxldmVscw0KZm9yIHJlc291cmNlIGNvbnRyb2wuIHJvb3QgcmVjbGFp
bSBsYWNrcyBhIGNyb3NzLW1lbWNnIGhvdC9jb2xkIGFuZA0KcHJpb3JpdHkgdmlldzsNCmZvcmVn
cm91bmQgYXBwIGZpbGUgcGFnZXMgbWF5IGJlIHJlY2xhaW1lZCBhbmQgcmVsb2FkZWQgZnJlcXVl
bnRseSwNCmNhdXNpbmcgdmlzaWJsZSBzdGFsbHM7DQpXZSBjdXJyZW50bHkgdXNlIGEgaG9vayBb
M10gdG8gc2tpcCByZWNsYWltIGZvciBmb3JlZ3JvdW5kIGFwcHMuDQoNCkRpc2N1c3Npb24NCg0K
LSBWZW5kb3Itb25seSB3b3JrYXJvdW5kcyCh+iBnZW5lcmljIG1lY2hhbmlzbXMgKFExqENRNCkN
Ck91ciBjdXJyZW50IGZpeGVzICh1c2Vyc3BhY2UgbWVtY2cgYWdpbmcgWzFdLCBPRU0gcmVjbGFp
bSBob29rcw0KWzIsM10pIGFyZSBBbmRyb2lkL3ZlbmRvci1vbmx5oap3aGF0IHBhcnRzIHNob3Vs
ZCBiZSB0dXJuZWQgaW50bw0KZ2VuZXJpYyBNR0xSVS9rZXJuZWwgbWVjaGFuaXNtcyB2cy4ga2Vw
dCBhcyBBbmRyb2lkIHBvbGljeT8NCldlIG5lZWQgZ3VpZGFuY2UgZnJvbSBjb21tdW5pdHkuDQoN
Ci0gSG93IG11Y2ggY29udHJvbCBzaG91bGQgTUdMUlUgZXhwb3NlIHRvIEFuZHJvaWQ/IChRMahD
UTMpDQpGb3IgUTEvUTIsIEFuZHJvaWQgaGFzIHN0cm9uZyBmZy9iZyBhbmQgcHJpb3JpdHkgc2Vt
YW50aWNzIHRoYXQNCnRoZSBrZXJuZWwgZG9lcyBub3Qgc2VlLiBTaG91bGQgTUdMUlUgcHJvdmlk
ZSBtb3JlIGV4cGxpY2l0IGNvbnRyb2wNCnBvaW50cyAoZS5nLiBhbm9uLXZzLWZpbGUgLyBnZW5l
cmF0aW9uIHN0ZWVyaW5nLCANCiJ0YXJnZXQgYW1vdW50ICsgYWJvcnQgY29uZGl0aW9uIiBtZW1j
ZyByZWNsYWltKSBzbyBBbmRyb2lkIGNhbg0Kc2FmZWx5IHRyYWRlIGNvbXBsZXhpdHkgYW5kIHJp
c2sgZm9yIGJldHRlciBwZXJmb3JtYW5jZSBhbmQgYm91bmRlZA0KcmVjbGFpbSBsYXRlbmN5IChR
Myk/DQoNCi0gTUdMUlUgZXZvbHV0aW9uIHdpdGhvdXQgbWVtY2cgTFJVOiBnbG9iYWwgaG90L2Nv
bGQgJiBzY2FubmluZyAoUTQpDQpJZiBtZW1jZyBMUlUgd2lsbCBiZSByZW1vdmVkIFs0XSwgaG93
IHNob3VsZCB3ZSBtYWludGFpbiBhIGNyb3NzLW1lbWNnDQpnbG9iYWwgaG90L2NvbGQgdmlldyBh
bmQgcGVyLWFwcCBwcmlvcml0eSBvbiBBbmRyb2lkPw0KR2l2ZW4gdGhhdCBtdWNoIG9mIHRoZSBw
b3dlciBiZW5lZml0IHNlZW1zIHRvIGNvbWUgZnJvbSBwYWdlLXRhYmxlDQpzY2FubmluZyB3aGls
ZSBnZW5lcmF0aW9ucyBhcmUgY29tcGxleCwgaXMgaXQgcmVhc29uYWJsZSB0byBkZWNvdXBsZQ0K
cGFnZS1zY2FubmluZyBmdW5jdGlvbmFsaXR5IGZyb20gTUdMUlUgYW5kIG1ha2UgaXQgYSBzZXBl
cmF0ZSBrZXJuZWwNCmNvbmZpZ3VyYXRpb24uDQoNCldlIGFyZSBoYXBweSB0byBzaGFyZSBtb3Jl
IGRldGFpbGVkIGRhdGEgYW5kIGV4cGVyaW1lbnRzIGFuZCB0byBoZWxwDQp3aXRoIFBvQ3MgYW5k
IGxhcmdlLXNjYWxlIHZhbGlkYXRpb24gaWYgdGhlcmUgaXMgaW50ZXJlc3QgaW4NCnB1cnN1aW5n
IHRoZXNlIGRpcmVjdGlvbnMuDQoNClJlZmVyZW5jZQ0KWzFdIGh0dHBzOi8vbG9yZS5rZXJuZWwu
b3JnL2xpbnV4LW1tLzIwMjUxMTI4MDI1MzE1LjM1MjA2ODktMS13YW5nemljaGVuZ0Bob25vci5j
b20vDQpbMl0gaHR0cHM6Ly9hbmRyb2lkLXJldmlldy5nb29nbGVzb3VyY2UuY29tL2Mva2VybmVs
L2NvbW1vbi8rLzM4NjY1NTQNClszXSBodHRwczovL2FuZHJvaWQtcmV2aWV3Lmdvb2dsZXNvdXJj
ZS5jb20vYy9rZXJuZWwvY29tbW9uLysvMzg3MDkyMA0KWzRdIGh0dHBzOi8vbHduLm5ldC9BcnRp
Y2xlcy8xMDUxODgyLw0KDQotLQ0KQmVzdCwNClppY2hlbmcgV2FuZw0K


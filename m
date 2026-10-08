Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 72212CA600A
	for <linux-mm@archiver.kernel.org>; Thu,  8 Oct 2026 07:35:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 757096B009E; Thu,  8 Oct 2026 03:35:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6BACE6B009F; Thu,  8 Oct 2026 03:35:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5818C6B00A0; Thu,  8 Oct 2026 03:35:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 13C306B009E
	for <linux-mm@kvack.org>; Thu,  8 Oct 2026 03:35:22 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 8A1E7C048C
	for <linux-mm@kvack.org>; Thu,  8 Oct 2026 07:35:21 +0000 (UTC)
X-FDA: 85298648442.22.669B863
Received: from mailgw1.hygon.cn (unknown [101.204.27.37])
	by imf15.hostedemail.com (Postfix) with ESMTP id 42462A0002
	for <linux-mm@kvack.org>; Thu,  8 Oct 2026 07:35:16 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=none;
	spf=pass (imf15.hostedemail.com: domain of wujianyong@hygon.cn designates 101.204.27.37 as permitted sender) smtp.mailfrom=wujianyong@hygon.cn;
	dmarc=pass (policy=none) header.from=hygon.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791444919;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=HZqRq/F/3jQ6IXMF7y8X96VYNXFgopBe7ubViHZyU38=;
	b=JXSz/x7hCEjHpx3YSKFhFPNPbqMziMP+gihxfxg1KCFfslIUkVTVqBhSjkQ2ZQlHC0nbfc
	BvN2Qlp75OghgNOpXNGQdxPjmROtUQ79bZGGTKV9NOi5lk9Um/cdL7D26xqw7TzkSedhor
	eVpiOKnQ/9slFAIiCm3RkpF0Pue/e2w=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791444919;
	b=F2x59q0qrnNUivGNgwX5D5pT5d2U28AoWtHiG7TO1WE1p8qWeCrNCvft1ryagXXWP6EvSs
	4CkNp87kQHDDnkXgH9/OPQkpPpu4hscaD1YZDmv3EHJ5iMZ3McW2Vhol5WPcATNBA1QSdM
	SYQ/2e1ZZxQzNaiFnRhUEl7YAMryEi0=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=none;
	spf=pass (imf15.hostedemail.com: domain of wujianyong@hygon.cn designates 101.204.27.37 as permitted sender) smtp.mailfrom=wujianyong@hygon.cn;
	dmarc=pass (policy=none) header.from=hygon.cn
Received: from maildlp1.hygon.cn (unknown [127.0.0.1])
	by mailgw1.hygon.cn (Postfix) with ESMTP id 4j0hbg28dKz12NY1;
	Thu,  8 Oct 2026 15:35:11 +0800 (CST)
Received: from maildlp1.hygon.cn (unknown [172.23.18.60])
	by mailgw1.hygon.cn (Postfix) with ESMTP id 4j0hbf5pPZz12NY1;
	Thu,  8 Oct 2026 15:35:10 +0800 (CST)
Received: from cncheex06.Hygon.cn (unknown [172.23.18.116])
	by maildlp1.hygon.cn (Postfix) with ESMTPS id AAF835948;
	Thu,  8 Oct 2026 15:35:02 +0800 (CST)
Received: from cncheex04.Hygon.cn (172.23.18.114) by cncheex06.Hygon.cn
 (172.23.18.116) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.36; Thu, 8 Oct
 2026 15:35:10 +0800
Received: from cncheex04.Hygon.cn ([fe80::1b6f:6c58:58a4:430d]) by
 cncheex04.Hygon.cn ([fe80::1b6f:6c58:58a4:430d%10]) with mapi id
 15.02.1544.036; Thu, 8 Oct 2026 15:35:10 +0800
From: Jianyong Wu <wujianyong@hygon.cn>
To: Tim Chen <tim.c.chen@linux.intel.com>, Peter Zijlstra
	<peterz@infradead.org>
CC: Ingo Molnar <mingo@redhat.com>, Juri Lelli <juri.lelli@redhat.com>,
	Vincent Guittot <vincent.guittot@linaro.org>, Chen Yu <yu.c.chen@intel.com>,
	Dietmar Eggemann <dietmar.eggemann@arm.com>, Steven Rostedt
	<rostedt@goodmis.org>, Ben Segall <bsegall@google.com>, Mel Gorman
	<mgorman@suse.de>, Valentin Schneider <vschneid@redhat.com>, K Prateek Nayak
	<kprateek.nayak@amd.com>, Shrikanth Hegde <sshegde@linux.ibm.com>, Phil Auld
	<pauld@redhat.com>, Andrew Morton <akpm@linux-foundation.org>, "David
 Hildenbrand" <david@kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>,
	"jianyong.wu@outlook.com" <jianyong.wu@outlook.com>, Yuan Zhong
	<zhongyuan@hygon.cn>, Huangsj <huangsj@hygon.cn>, Fengyu Wang
	<wangfengyu@hygon.cn>, Zhiwei Ying <yingzhiwei@hygon.cn>, "justin.he@arm.com"
	<justin.he@arm.com>
Subject: RE: [RFC PATCH v2 02/23] sched/topology: Introduce a NUMA distance
 matrix with unique distance values
Thread-Topic: [RFC PATCH v2 02/23] sched/topology: Introduce a NUMA distance
 matrix with unique distance values
Thread-Index: AQHdNiA3jheQVPdvikWpN4gB9aTKG7a3i1wAgCMFioCAAQKWYIAAjPiAgADjB/CAAIHNgIAF/bTAgAVsM4CACnnIsA==
Date: Thu, 8 Oct 2026 07:35:10 +0000
Message-ID: <4d2b5dede1f64350ac17ea9d0a5428a1@hygon.cn>
References: <20260827122816.756234-1-wujianyong@hygon.cn>
				 <20260827122816.756234-3-wujianyong@hygon.cn>
				 <20260831115004.GF776954@noisy.programming.kicks-ass.net>
			 <da32ba66d95fd88869ba052f97698b9a4d6c3dc6.camel@linux.intel.com>
			 <09261c8222994a41a04ace5f342475df@hygon.cn>
		 <ce95ec57af9dfaf4d9ed604ad7337441a543f538.camel@linux.intel.com>
		 <f6ebab3d0e44412dad17ac64a3b93339@hygon.cn>
	 <112e526b4013e23c70adf5b8883db8e75358b473.camel@linux.intel.com>
	 <8a0c239b5bdf40c99b645087dec8fd18@hygon.cn>
 <2a120db1b0c052eb88dcbc2ed1de6027a16542b4.camel@linux.intel.com>
In-Reply-To: <2a120db1b0c052eb88dcbc2ed1de6027a16542b4.camel@linux.intel.com>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-originating-ip: [172.19.20.45]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-Rspamd-Queue-Id: 42462A0002
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: a58xya5rd5xd77ofw6k5gh1yfxh8qf1x
X-HE-Tag: 1791444916-167354
X-HE-Meta: U2FsdGVkX18gz4WFNoBhN862wp0geKn/GbL0rRJH5nGkQ+ta2VEp/kTaGJ3PYopuPnzC4HdNb5Dev4wL1iYP0y2LdkoIO5kfwnfbzZPj/qk4303b5TztC6AARRKS0jtPP/oX2gEsPZuILb9CQe/6mMqkfP2tD5GVuEM4lxkIkH5COGeiOfaXAQJa4QRpLEuN8AgNc4qrEjLFX4HwZWqRLoGkgdjET1DM9ox0BKESi6DdTL+pNFOm4S85IpQpE92NdbjSESVUaOys2nwg9JeQfBFG8SFyb3FXl8X4RZzJMtN/g2//SiWzVV3eWa+Labn0T387aCg7IScM5tDA6k9qY0sqoQTXfOHrQcy9KJPFpRqexwve7qppNTuy7vrCk8NGmycbORI+Ki9aFa8UbTyZ/yhtvTxb0B6mnEBYlM0z/LL9PqQlRSy5sWBodzCOwRPSx4mQBA1azO40MUoAsTt/ml6c2RsCH5wd7D2QOMWnRvDqcCadwA0usRWJ+o0RE6C56mlPFyXT/0T9UTxuu0y9ogYQ9pG6ZXXtM5BTv7LUdWc5G3lN78oncxJkjr8tTI0JED66E2rmVhxb/BLmx/VycC3R+tUaA9Mca+ROpotpFBn9myN2yaprFS46xeCv0WfOYWACR1Jh8uq8TGY//DYSZSUCrEYicl/5ooFcVL4d9M8QXHwdDLCiU/ywjso3xyoY50oGW2IZrDkeZxZhk9eAgdY9ZDjTYFZPvJLXIvYw2OG1whbegdRDOlttaR5nrjvCquN/DbFVGtA4ODtkViypTFrmetW7RG3QuCby+E79YjgFgsWYrSdM9Tr+n6+4KhDiW+3d8OiCL/qZ5eqU1lKnKWQPhau1C8zDr9u0kfEvWBBuOqzIkj7Y+s2jFAYeClPXzCxU0+1k0tJgnQ2tlSUkNbNexrWnjoQIolnMVj66wuLC7abiKsf9nt0coJo9eeSxEX5bl+qeQK/gaTiQSV7
 xvigu3QG
 jp+751sfZfrFcIx8CD3Mn5UXHXyGEfrl5RQoc56TdKzpRDIZJWi3OoOIAWkTgUGvtpBFCBpuTThUDNfAGNNcmUG45J22gq6TXt6Ut9NBjdiwy0xdsQOicG/88eRpP+2Bner3c7yfgrgcbPH2gSLmP+nCceLTbT/fXOZVTUHNOIvXKBypiW7+hEyAjxVI0vFQ0iKN9CKHY6RC+6FDxYZGvfix0zuOC/quzKZF+pF0v808pbz4mRXAwbKve1qsLa6VMpkj+lYOQqMOiqa/NugLxPRGfVjr4ZEAy9P/if5uLvkrYbEDlAu9bE/l6j/WNMxt1s+CAsYGpDP66LkKrRdp3aU/qlvn9coBg9mzddjwNGQxEIenf9gn23YJuNE632a9NJpi91mdb1amKBCDkotT3zX+SDyESNzLzwDv0s/l0yZ4DNR8CnwA5d4/xMu4w7W2TdnyMbXXC52G7DC7BozvOCsjVSTXQTdWK8jRX1Iqaiies8ftxyXmJAbK5msVrGzY1msB9rVWG1pkug05gmwDrVpNss1wVmTDQ1W/9ST77suikrdoeZKc0LvyM7dsKu5rbIt61q7lWOZVGnbzKIa8F8LcjD5QfCD4bAFsw3VOjgZqzvD0m8bfNtBB0knAvCY8mRHQIRp7xHDPS08ry/ZEsO0csAHCZOxclwWOCWLjoygh9ofzBwWZjrnA5E6ZVtYTj97f23ILPbgGI6qaT/6sdv9+q++SBEea6aqAxKvqCb/8mPE4a89swL2vj8af6nDhuiejZzuOJMFBIYp8otSc5y1Klh0k43nbNTF8seTaOTmEbeuvi2fB9wXJpOuD8LWyjhmt8HWkD9dnKJ2vF9KL4o9EdzQzutVPEMWOVe6MxOji3dAvsllucRtv9bQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

SGkgVGltLA0KDQo+IC0tLS0tT3JpZ2luYWwgTWVzc2FnZS0tLS0tDQo+IEZyb206IFRpbSBDaGVu
IDx0aW0uYy5jaGVuQGxpbnV4LmludGVsLmNvbT4NCj4gU2VudDogRnJpZGF5LCBPY3RvYmVyIDIs
IDIwMjYgNjowNCBBTQ0KPiBUbzogSmlhbnlvbmcgV3UgPHd1amlhbnlvbmdAaHlnb24uY24+OyBQ
ZXRlciBaaWpsc3RyYQ0KPiA8cGV0ZXJ6QGluZnJhZGVhZC5vcmc+DQo+IENjOiBJbmdvIE1vbG5h
ciA8bWluZ29AcmVkaGF0LmNvbT47IEp1cmkgTGVsbGkgPGp1cmkubGVsbGlAcmVkaGF0LmNvbT47
DQo+IFZpbmNlbnQgR3VpdHRvdCA8dmluY2VudC5ndWl0dG90QGxpbmFyby5vcmc+OyBDaGVuIFl1
DQo+IDx5dS5jLmNoZW5AaW50ZWwuY29tPjsgRGlldG1hciBFZ2dlbWFubg0KPiA8ZGlldG1hci5l
Z2dlbWFubkBhcm0uY29tPjsgU3RldmVuIFJvc3RlZHQgPHJvc3RlZHRAZ29vZG1pcy5vcmc+Ow0K
PiBCZW4gU2VnYWxsIDxic2VnYWxsQGdvb2dsZS5jb20+OyBNZWwgR29ybWFuIDxtZ29ybWFuQHN1
c2UuZGU+Ow0KPiBWYWxlbnRpbiBTY2huZWlkZXIgPHZzY2huZWlkQHJlZGhhdC5jb20+OyBLIFBy
YXRlZWsgTmF5YWsNCj4gPGtwcmF0ZWVrLm5heWFrQGFtZC5jb20+OyBTaHJpa2FudGggSGVnZGUg
PHNzaGVnZGVAbGludXguaWJtLmNvbT47DQo+IFBoaWwgQXVsZCA8cGF1bGRAcmVkaGF0LmNvbT47
IEFuZHJldyBNb3J0b24NCj4gPGFrcG1AbGludXgtZm91bmRhdGlvbi5vcmc+OyBEYXZpZCBIaWxk
ZW5icmFuZCA8ZGF2aWRAa2VybmVsLm9yZz47DQo+IGxpbnV4LWtlcm5lbEB2Z2VyLmtlcm5lbC5v
cmc7IGxpbnV4LW1tQGt2YWNrLm9yZzsNCj4gamlhbnlvbmcud3VAb3V0bG9vay5jb207IFl1YW4g
WmhvbmcgPHpob25neXVhbkBoeWdvbi5jbj47IEh1YW5nc2oNCj4gPGh1YW5nc2pAaHlnb24uY24+
OyBGZW5neXUgV2FuZyA8d2FuZ2Zlbmd5dUBoeWdvbi5jbj47IFpoaXdlaSBZaW5nDQo+IDx5aW5n
emhpd2VpQGh5Z29uLmNuPjsganVzdGluLmhlQGFybS5jb20NCj4gU3ViamVjdDogUmU6IFtSRkMg
UEFUQ0ggdjIgMDIvMjNdIHNjaGVkL3RvcG9sb2d5OiBJbnRyb2R1Y2UgYSBOVU1BDQo+IGRpc3Rh
bmNlIG1hdHJpeCB3aXRoIHVuaXF1ZSBkaXN0YW5jZSB2YWx1ZXMNCj4gDQo+IE9uIE1vbiwgMjAy
Ni0wOS0yOCBhdCAwOTozOSArMDAwMCwgSmlhbnlvbmcgV3Ugd3JvdGU6DQo+ID4gSGkgVGltLA0K
PiA+DQo+ID4NCj4gPiBNYWtlcyBzZW5zZS4gU28sIHdoYXQgYWJvdXQgdGhlIGZvbGxvd2luZyBz
b2x1dGlvbj8NCj4gPiBHaXZlbiBhIG5vZGUgYWZmaW5pdHkgc2VxdWVuY2UsIGEgbW92ZSBmcm9t
IHNyYyB0byBkc3QgaW1wcm92ZXMgdGhlDQo+ID4gYWZmaW5pdHkgb2YgZXZlcnkgdGFzayB3aG9z
ZSBwcmVmZXJyZWQgbm9kZSBpIHJhbmtzIGRzdCBiZXR0ZXIgdGhhbiBzcmMuDQo+IFRoZSBzY29y
ZQ0KPiA+IGlzIHRoZW4NCj4gPg0KPiA+IERpID0gcmF3X2Rpc3Qoc3JjLCBpKSAtIHJhd19kaXN0
KGRzdCwgaSkNCj4gPiBhZmZpbml0eV9iaWFzX2kgPSBwb3NpdGlvbiBvZiBzcmMgbWludXMgcG9z
aXRpb24gb2YgZHN0IGluIG5vZGUgaSdzIGFmZmluaXR5DQo+ID4gICAgICAgICAgICAgIHNlcXVl
bmNlLCBjb3VudGVkIGFtb25nIHRoZSBub2RlcyBhdCB0aGUgc2FtZQ0KPiBkaXN0YW5jZSBmcm9t
DQo+ID4gICAgICAgICAgICAgIGkgKHplcm8gd2hlbiBEaSBpcyBub3QgemVybykNCj4gDQo+IERv
IHdlIHJlYWxseSBuZWVkIGFuIGFmZmluaXR5IGJpYXM/ICBJIHRoaW5rIHlvdXIgaW50ZW50aW9u
IGlzIHRvIHVzZSBpdCBmb3INCj4gYnJlYWtpbmcgYSB0aWUuDQo+IElmIHRoZXJlIGlzIGEgdGll
IGluIGFmZmluaXR5IHNjb3JlICh3aXRob3V0IGluamVjdGluZyBiaWFzKSwNCj4ganVzdCB1c2Ug
dGhlIHBvc2l0aW9uIGRpZmYgdG8gYnJlYWsgdGhlIHRpZS4gIEhhdmluZyBhIGJpYXMgZGlzdG9y
dHMNCj4gdGhlIGFmZmluaXR5IHNjb3JlLg0KPiANCj4NCkkgdGhpbmsgdGhlcmUgaXMgYSBtaXN1
bmRlcnN0YW5kaW5nIGFib3V0IHRoZSBwdXJwb3NlIG9mIHRoZSBiaWFzLg0KSXQgaXMgbm90IGlu
dGVuZGVkIHRvIGJyZWFrIHRpZXMgYmV0d2VlbiBhZmZpbml0eSBzY29yZXMuIEkgd2FudCB0aGUN
CnNjb3JlIGl0c2VsZiB0byByZWZsZWN0IG9wcG9ydHVuaXRpZXMgZm9yIGFnZ3JlZ2F0aW9uLCBp
bmNsdWRpbmcgbW92ZXMNCnRoYXQgbGVhdmUgdGhlIHJhdyBOVU1BIGRpc3RhbmNlIHVuY2hhbmdl
ZCBidXQgZm9sbG93IHRoZSBmaXhlZCBub2RlDQphZmZpbml0eSBvcmRlci4NCg0KVGhhdCBzYWlk
LCBJIGFncmVlIHdpdGggeW91ciBjb25jZXJuIGFib3V0IHVzaW5nIGFydGlmaWNpYWwgbm9kZQ0K
ZGlzdGFuY2VzIGluIHRoZSBzY29yZSBjYWxjdWxhdGlvbi4gVGhlIG1hZ25pdHVkZSBvZiBhbiBh
cnRpZmljaWFsDQpkaXN0YW5jZSBvciByYW5rIGRpZmZlcmVuY2Ugc2hvdWxkIG5vdCBkZXRlcm1p
bmUgdGhlIHdlaWdodCBvZiB0aG9zZQ0KYWdncmVnYXRpb24gb3Bwb3J0dW5pdGllcy4NCg0KSG93
IGFib3V0IHRoZSBmb2xsb3dpbmcgYXBwcm9hY2g/DQoNCldoZW4gdGhlIHNvdXJjZSBhbmQgZGVz
dGluYXRpb24gaGF2ZSBkaWZmZXJlbnQgcmF3IGRpc3RhbmNlcyB0byBhIHRhc2sncw0KcHJlZmVy
cmVkIG5vZGUsIHdlIHVzZSB0aGUgcmF3IGRpc3RhbmNlIGRpZmZlcmVuY2UgYXMgdGhlIHdlaWdo
dCwNCnByb3ZpZGVkIHRoZSBkZXN0aW5hdGlvbiBpcyBjbG9zZXIuDQoNCldoZW4gdGhvc2UgZGlz
dGFuY2VzIGFyZSBlcXVhbCwgd2UgdXNlIHRoZSBmaXhlZCBub2RlIGFmZmluaXR5IHNlcXVlbmNl
DQp0byBkZXRlcm1pbmUgZWxpZ2liaWxpdHkuIElmIHRoZSBkZXN0aW5hdGlvbiBjb21lcyBiZWZv
cmUgdGhlIHNvdXJjZSwNCmVhY2ggZWxpZ2libGUgdGFzayBjb250cmlidXRlcyBhIHdlaWdodCBv
ZiAxLiBPdGhlcndpc2UsIGl0IGNvbnRyaWJ1dGVzDQpub3RoaW5nLg0KDQpGb3IgZWFjaCBwcmVm
ZXJyZWQgbm9kZSwgdGhlIGNhbGN1bGF0aW9uIHdvdWxkIGxvb2sgbGlrZSB0aGlzLg0KQSBzbWFs
bGVyIHJhbmsgbWVhbnMgYW4gZWFybGllciBwb3NpdGlvbiBpbiB0aGUgYWZmaW5pdHkgc2VxdWVu
Y2UuDQoNCiAgZGVsdGEgPSBub2RlX2Rpc3RhbmNlKHNyY19ub2RlLCBwcmVmX25vZGUpIC0NCiAg
ICAgICAgICAgICAgbm9kZV9kaXN0YW5jZShkc3Rfbm9kZSwgcHJlZl9ub2RlKTsNCg0KICBpZiAo
ZGVsdGEgPiAwKSB7DQogICAgd2VpZ2h0ID0gZGVsdGE7DQogIH0gZWxzZSBpZiAoZGVsdGEgPT0g
MCAmJg0KICBhZmZpX25vZGVfcmFua19vZihwcmVmX25vZGUsIGRzdF9ub2RlKSA8DQogIGFmZmlf
bm9kZV9yYW5rX29mKHByZWZfbm9kZSwgc3JjX25vZGUpKSB7DQogICAgd2VpZ2h0ID0gMTsNCiAg
fSBlbHNlIHsNCiAgICBjb250aW51ZTsNCiAgfQ0KDQogIHNjb3JlICs9IG51bWFfY291bnRzW3By
ZWZfbm9kZV0gKiB3ZWlnaHQ7DQoNCkhlcmUsIG51bWFfY291bnRzW3ByZWZfbm9kZV0gaXMgdGhl
IG51bWJlciBvZiB0YXNrcyBvbiB0aGUgY2FuZGlkYXRlDQpzb3VyY2UgdGhhdCBwcmVmZXIgcHJl
Zl9ub2RlLg0KDQpUaGlzIHdheSwgdGhlIGZpeGVkIG9yZGVyIGRldGVybWluZXMgZWxpZ2liaWxp
dHksIGJ1dCB0aGUgcmFuayBkaWZmZXJlbmNlDQpkb2VzIG5vdCBhZmZlY3QgdGhlIHdlaWdodC4g
Rm9yIGVxdWFsLWRpc3RhbmNlIG1vdmVzLCB0aGUgY29udHJpYnV0aW9uDQpzaW1wbHkgY291bnRz
IHRoZSBlbGlnaWJsZSB0YXNrcy4gQSB6ZXJvIHdlaWdodCB3b3VsZCBsb3NlIHRoYXQNCmluZm9y
bWF0aW9uLCBldmVuIHRob3VnaCB0aGVzZSBtb3ZlcyBjYW4gaGVscCBjb25jZW50cmF0ZSB0YXNr
cyBvbiBmZXdlcg0Kbm9kZXMuDQoNClRoaXMgcmV0YWlucyBhIG1pbmltYWwgYWdncmVnYXRpb24g
cHJlZmVyZW5jZSB3aXRob3V0IHVzaW5nIGFydGlmaWNpYWwNCmRpc3RhbmNlIHZhbHVlcyBpbiB0
aGUgY2FsY3VsYXRpb24uIFdvdWxkIHRoaXMgYWRkcmVzcyB5b3VyIGNvbmNlcm4/DQoNClRoYW5r
cw0KSmlhbnlvbmcNCg==



Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D89F2CD6E4A
	for <linux-mm@archiver.kernel.org>; Thu,  4 Jun 2026 04:03:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3BE776B0092; Thu,  4 Jun 2026 00:03:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 36F206B0093; Thu,  4 Jun 2026 00:03:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 25DF36B0095; Thu,  4 Jun 2026 00:03:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 147EE6B0092
	for <linux-mm@kvack.org>; Thu,  4 Jun 2026 00:03:10 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id AD83E404E0
	for <linux-mm@kvack.org>; Thu,  4 Jun 2026 04:03:09 +0000 (UTC)
X-FDA: 84840884898.08.D7E78D4
Received: from mta20.hihonor.com (mta20.honor.com [81.70.206.69])
	by imf20.hostedemail.com (Postfix) with ESMTP id F2E5E1C000D
	for <linux-mm@kvack.org>; Thu,  4 Jun 2026 04:03:06 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=honor.com;
	spf=pass (imf20.hostedemail.com: domain of tao.wangtao@honor.com designates 81.70.206.69 as permitted sender) smtp.mailfrom=tao.wangtao@honor.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780545787;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=5F7qVXu42m4/ePzu3v9e8ju7GLQBLmOcF+tUmhqDFDo=;
	b=3U/8gq9YJ4XbkzMTuT4dDIJRqTK+gGtIGMdEFGOQdnGA0Z1RvJPZSlp09fpypsughYpjfP
	4g8eVaEj4ID46PPWlXsmLr17jZ2pyn1v/C+KLjcTicXvTsDoxDj69QzqNjV5hydTP/nzwU
	/xOYVJgKkt0dVjGhI/FTG68j+gMhWfg=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=honor.com;
	spf=pass (imf20.hostedemail.com: domain of tao.wangtao@honor.com designates 81.70.206.69 as permitted sender) smtp.mailfrom=tao.wangtao@honor.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780545787;
	b=JnTqQ4LTskfZwj527rF43eC0sFHKH5jz+Hwt5Zu/wMp1YhYvEJYxLuLcfme7+xkKEMhCL9
	o/UXeoe/5xqC9kWxRDj0Onm/MJkINr+2YLTmWEhrU3j+Dt0me3rwm4nRJ2X5GX+AafBivY
	XrRpXEq0ZlHc4qbGmVFltC7/Erb8YT8=
Received: from TW002-1.hihonor.com (unknown [10.72.0.137])
	by mta20.hihonor.com (SkyGuard) with ESMTPS id 4gW9qJ2b4SzYl2n1;
	Thu,  4 Jun 2026 12:01:32 +0800 (CST)
Received: from TA001.hihonor.com (10.77.210.32) by TW002-1.hihonor.com
 (10.72.0.137) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.37; Thu, 4 Jun
 2026 12:03:02 +0800
Received: from TA003.hihonor.com (10.72.0.43) by TA001.hihonor.com
 (10.77.210.32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.37; Thu, 4 Jun
 2026 12:03:06 +0800
Received: from TA003.hihonor.com ([fe80::998f:47ec:980d:bdf1]) by
 TA003.hihonor.com ([fe80::998f:47ec:980d:bdf1%7]) with mapi id
 15.02.2562.037; Thu, 4 Jun 2026 12:03:02 +0800
From: wangtao <tao.wangtao@honor.com>
To: Barry Song <21cnbao@gmail.com>, "David Hildenbrand (Arm)"
	<david@kernel.org>
CC: "catalin.marinas@arm.com" <catalin.marinas@arm.com>, "will@kernel.org"
	<will@kernel.org>, "tglx@kernel.org" <tglx@kernel.org>, "mingo@redhat.com"
	<mingo@redhat.com>, "bp@alien8.de" <bp@alien8.de>,
	"dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>, "x86@kernel.org"
	<x86@kernel.org>, "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
	"willy@infradead.org" <willy@infradead.org>, "sj@kernel.org" <sj@kernel.org>,
	"kees@kernel.org" <kees@kernel.org>, "luizcap@redhat.com"
	<luizcap@redhat.com>, "zhangjiao2@cmss.chinamobile.com"
	<zhangjiao2@cmss.chinamobile.com>, "kas@kernel.org" <kas@kernel.org>,
	"ljs@kernel.org" <ljs@kernel.org>, "hpa@zytor.com" <hpa@zytor.com>,
	"liam@infradead.org" <liam@infradead.org>, "vbabka@kernel.org"
	<vbabka@kernel.org>, "rppt@kernel.org" <rppt@kernel.org>, "surenb@google.com"
	<surenb@google.com>, "mhocko@suse.com" <mhocko@suse.com>, "jack@suse.cz"
	<jack@suse.cz>, "riel@surriel.com" <riel@surriel.com>, "harry@kernel.org"
	<harry@kernel.org>, "jannh@google.com" <jannh@google.com>, "jgg@ziepe.ca"
	<jgg@ziepe.ca>, "jhubbard@nvidia.com" <jhubbard@nvidia.com>,
	"peterx@redhat.com" <peterx@redhat.com>, "ziy@nvidia.com" <ziy@nvidia.com>,
	"baolin.wang@linux.alibaba.com" <baolin.wang@linux.alibaba.com>,
	"npache@redhat.com" <npache@redhat.com>, "ryan.roberts@arm.com"
	<ryan.roberts@arm.com>, "dev.jain@arm.com" <dev.jain@arm.com>,
	"lance.yang@linux.dev" <lance.yang@linux.dev>, "xu.xin16@zte.com.cn"
	<xu.xin16@zte.com.cn>, "chengming.zhou@linux.dev" <chengming.zhou@linux.dev>,
	"nao.horiguchi@gmail.com" <nao.horiguchi@gmail.com>,
	"matthew.brost@intel.com" <matthew.brost@intel.com>,
	"joshua.hahnjy@gmail.com" <joshua.hahnjy@gmail.com>, "rakie.kim@sk.com"
	<rakie.kim@sk.com>, "byungchul@sk.com" <byungchul@sk.com>,
	"gourry@gourry.net" <gourry@gourry.net>, "ying.huang@linux.alibaba.com"
	<ying.huang@linux.alibaba.com>, "apopple@nvidia.com" <apopple@nvidia.com>,
	"pfalcato@suse.de" <pfalcato@suse.de>, "linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "linux-fsdevel@vger.kernel.org"
	<linux-fsdevel@vger.kernel.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>,
	"damon@lists.linux.dev" <damon@lists.linux.dev>, "shakeel.butt@linux.dev"
	<shakeel.butt@linux.dev>, "ryncsn@gmail.com" <ryncsn@gmail.com>,
	"jparsana@google.com" <jparsana@google.com>, "dvander@google.com"
	<dvander@google.com>, zhangji <zhangji1@honor.com>, wangzicheng
	<wangzicheng@honor.com>
Subject: RE: [PATCH 0/15] mm: introduce ANON_VMA_LAZY for deferred anon_vma
 creation
Thread-Topic: [PATCH 0/15] mm: introduce ANON_VMA_LAZY for deferred anon_vma
 creation
Thread-Index: AQHc7cjw5r5ki6LAJ0S2mW/rJEfblbYszHKAgAAenICAAOQZkA==
Date: Thu, 4 Jun 2026 04:03:01 +0000
Message-ID: <273d02a1af954b8c9f4da7fb74e6b4cb@honor.com>
References: <20260527110147.17815-1-tao.wangtao@honor.com>
 <70377626-500d-46f2-a3f5-a0d2914ce365@kernel.org>
 <CAGsJ_4zg8+pVDwtsJtxxiC1ahJ9MR56Ue8VXCt_VrQgcXES2uQ@mail.gmail.com>
In-Reply-To: <CAGsJ_4zg8+pVDwtsJtxxiC1ahJ9MR56Ue8VXCt_VrQgcXES2uQ@mail.gmail.com>
Accept-Language: en-US
Content-Language: zh-CN
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-originating-ip: [10.163.18.240]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: F2E5E1C000D
X-Stat-Signature: utz1c76b57hfjyi6epq9mxmqyyxf9hby
X-Rspam-User: 
X-HE-Tag: 1780545786-555642
X-HE-Meta: U2FsdGVkX19AMovs2Vq1p+aDx3EQ2+fyBSgLd8ZlHFTaugUTdFHQ0uN5IMeH6pzadO11fC8Ta9SKe6CxCFaDxInsDNcbsZE3mTShzPF07Q/g4MRRtp8NxJcIgfhousbYn1AlbrDsIHx0FQX1vtqPlOTSpoynLcShjGGHPPGP5BpMI0wAMlm98KaZ7tRzzHxwJeNjiG/1L1W9xLlGH5RC5P7trpLbvdu28mT/8WooF5fewzzUA77rnvc+y7pOl5u3IJgcMR8B/KosuS0tKFoLU2ANgsgk+s+fA071njIMHu1ADAHYEExjQgguiyZbuQC5ZZcoBwrPmGWSaYlTdyADfjeBFP0JFprBpgq2dWLGxTh/YHHr7VCo2voDwjCbrpXJ5jqX7QkkZB9DOlYI4je7+6IYRqS95F0eMhXaNKJGZoVMGsbotMRp0GPDWCoGmUkXgfR/zgcX2Qenpeqb414rhWkWGOztf8+JrIm3e7jGVXls77IE5qyYEGZK9XtTZIOZVXmATg0p8xTCJTsI/SKeydNbkM7eHblT5SPrM4OPZDL4GyMF8FY4RbeJtqBT3PrxeVQkiKRlKUfv433ZkcKGH18FiymVBmG6yUVoeTqLSgGYgcZvXqMdlaRo8l62ALefvpMZUtTS8wcOg09b3QZH7Lnb9fZvFoCY8lorYv+dQ/DlJ2DPUd+yLdDinLKOHTWeMJKgsa5KFZuVNlp4HFKSTWhU463qTiV3GL5IM1arUwoOt8tdqNVbA6gI5rf3bJcmuPjBCub0ivjHBbOXb3/KBsbrFUUv7d/+qMn0Kj0AHKBrfHjyeMXp8PqEcWN85LNt3Vpvpx+wDzIGVlxLTqsLlxmIAy6xlA6WKciUOX7mx0SVwkL3UbCoN8SzCxmo/OHElDO52m8DzdV+xFI6epwoELxpzgxgHh1BPynDSPrc7CfGidMwvQVWTopZrO3A0kgj9tzsV/fgELEw8a7ansM
 jKfuZroc
 Oo6iqqEltAVjLWL3YXPpovkyLet5doJA5ETOsunkMIhbpcS5Fjuj46REMNrLUKRRLRCH4K2Dy346C8trToGtdRyp/BVgrbo6fVlVs+L+jBKfZ+MYcTI1qKuFi8CRUkmy+PLnBJ/+d7mn9UpSY7Ebypvw6ANiKDXpnjmuz60RzQaljdcMW4gHh9w9mF0vWvaF6j0hAwSYtdEbnb1R9QEY2PvM1Uk11psp7ZWAluQ1X4hEmuGlrsBWTEgcNeGyUBkZDl6yiRxxVTTg4IRs1QRNmeq1pgT/Wegli6IXvHc06TmXgD0wpId49bDiJ4SIXG4we93vJc/eUjzISgwSLWBnyr3uGQuj9SHAjvk03jqaiQ26IIVWDFChQ0LyWMM7LjBUoOzpkKcDPSb8MuG4k6N2qQ1LngTHRNWKDkXzEFEwuWHuxuSqwbhOPta0RgoTOpQtp7FSlvndV/aFjB+GLte1fwkUBKw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

PiA+DQo+ID4gSGkhDQo+ID4NCj4gPiBXaGVuIEkgc2F3IHRoZSBkaWZmc2F0IEkgd2FzIGNvbmNl
cm5lZC4gR29pbmcgdGhyb3VnaCB0aGUgcGF0Y2hlcyBtYWRlDQo+IG1lIC4uLg0KPiA+IG1vcmUg
Y29uY2VybmVkIDopDQo+ID4NCj4gPiBUaGlzIGlzIGEgbG90IG9mIGNvbXBsZXhpdHkuIE9uIHRv
cCBvZiBzb21ldGhpbmcgdGhhdCBpcyBhbHJlYWR5IHNvDQo+ID4gY29tcGxpY2F0ZWQgdGhhdCBJ
IGZhaWwgdG8gZ3Jhc3AgbW9zdCBkZXRhaWxzIHdpdGhvdXQgcmVndWxhcmx5IHRha2luZw0KPiA+
IGEgbG9vayBhdCB0aGUgbmljZSBmaWd1cmVzIExvcmVuem8gY3JlYXRlZCByZWNlbnRseS4NCj4g
Pg0KPiA+IEZvciBleGFtcGxlLCBJIHJlYWQgYWJvdmUgInNpbmNlIGNoaWxkIFZNQXMgZG8gbm90
IG5lZWQgdG8gYWxsb2NhdGUNCj4gYW5vbl92bWEiDQo+ID4gYW5kIHdvbmRlcmVkIGhvdyB0aGF0
IGNvdWxkIGJlIHBhcnQgb2Ygc29tZXRoaW5nIHRoYXQgaXMganVzdCBkb25lDQo+ID4gbGF6aWx5
LiBUaGVuIEkgaGFkIHRvIGxlYXJuIGluIHRoZSBwYXRjaGVzIHRoYXQgdGhlcmUgaXMgc29tZQ0K
PiA+IGFkZGl0aW9uYWwgIkNoaWxkIFZNQXMgYXJlIGNyZWF0ZWQgYXMgQU5PTl9WTUFfVFJFRV9Q
QVJFTlQgYW5kIGRvDQo+IG5vdA0KPiA+IGFsbG9jYXRlIGFub25fdm1hIiAtLSBleGN1c2UgbWUs
IHdoYXQ/IDopDQo+IA0KPiBZZXMsIHRoYXQgcGFydCBpcyBxdWl0ZSBjb21wbGljYXRlZCBoZXJl
LiBUaGVyZSBhcmUgdHdvIGNhc2VzIGhlcmU6DQo+IDEuIEEgZm9ya3MgQiwgYW5kIEIgaW5oZXJp
dHMgYSBWTUEgZnJvbSBBLiBJbiB0aGlzIGNhc2UsIEIncyBWTUEgZ2V0cw0KPiBBTk9OX1ZNQV9U
UkVFX1BBUkVOVC4NCj4gDQo+IDIuIEEgZm9ya3MgQiwgYW5kIEIgbGF0ZXIgY3JlYXRlcyBhIG5l
dyBWTUEgdmlhIG1tYXAoKS4NCj4gSWYgYSBwYWdlIGZhdWx0IG9jY3VycyBpbiB0aGlzIG5ldyBW
TUEsIGl0IGdldHMgQU5PTl9WTUFfVFJFRV9WTUEuDQo+IA0KPiBJbiBib3RoIGNhc2VzLCB3ZSBu
ZWVkIHRvIHVwZ3JhZGUgQiB0byBhIHJlZ3VsYXIgYW5vbl92bWEgd2hlbiBCIGJlY29tZXMNCj4g
YSBwYXJlbnQgYW5kIHBlcmZvcm1zIGEgZm9yaygpLg0KPiANClRoYW5rIHlvdSBmb3IgaGVscGlu
ZyBleHBsYWluLg0KDQo+IFRoaXMgbWF5IGJlIGEgYml0IG9mZi10b3BpYywgYnV0IEknbSBhbHNv
IGNvbnNpZGVyaW5nIHdoZXRoZXIgdGhlcmUgaXMgYSBjaGFuY2UNCj4gdG8gd29yayB3aXRoIFN1
cmVuIHRvIHN1cHBvcnQgY2FzZSAyIHZpYSBhIEdLSSBob29rIGluIHRoZSBBbmRyb2lkIGtlcm5l
bA0KPiBiZWZvcmUgTG9yZW56bydzIHdvcmsgaXMgcmVhZHkuDQo+IA0KPiBFdmVuIHRoZW4sIHRo
ZSBvcHRpbWl6YXRpb24gd291bGQgYXBwbHkgb25seSB0byB0aGUgY2FzZSB3aGVyZSBCIG5ldmVy
DQo+IGZvcmtzLCBhbGxvd2luZyB1cyB0byBza2lwIHRoZSBhbm9uX3ZtYSAidXBncmFkZSIgZW50
aXJlbHkuIFRoYXQgYXNzdW1wdGlvbg0KPiBob2xkcyBmb3IgbW9zdCBhcHBsaWNhdGlvbnMsIGFs
dGhvdWdoIHRoZXJlIGFyZSBhIGZldyBjYXNlcyB3aGVyZSBpdCBkb2VzIG5vdC4NCj4gDQo+IEkn
bSBhY3R1YWxseSBob3BpbmcgQW5kcm9pZCBjb3VsZCBldmVudHVhbGx5IGRpc2FibGUgZm9ya2lu
ZyBmb3IgVUkNCj4gYXBwbGljYXRpb25zIGFsdG9nZXRoZXIuIEZyb20gd2hhdCBJJ3ZlIGhlYXJk
LCBzb21lIGFwcGxpY2F0aW9ucyB1c2UgZm9yaygpDQo+IHByaW1hcmlseSB0byBldmFkZSBMTUtE
ICh0aGUgQW5kcm9pZCBsb3ctbWVtb3J5IGtpbGxlciBkYWVtb24pLiBGb3INCj4gZXhhbXBsZSwg
YSBjaGlsZCBwcm9jZXNzIG1heSBtb25pdG9yIHRoZSBtYWluIHByb2Nlc3MsIGFuZCBpZiB0aGUg
bWFpbg0KPiBwcm9jZXNzIGlzIGtpbGxlZCwgZGV0ZWN0IHRoYXQgZXZlbnQgYW5kIHJlcXVlc3Qg
YSByZWxhdW5jaC4gVGhpcyBpcyBvbmUgd2F5DQo+IHNvbWUgYXBwbGljYXRpb25zIGF0dGVtcHQg
dG8ga2VlcCB0aGVtc2VsdmVzIGFsaXZlIGluZGVmaW5pdGVseS4NCj4gDQo+IEJ1dCBldmVuIGlm
IHdlIGxpbWl0IHRoZSBvcHRpbWl6YXRpb24gdG8gdGhlIHN1YnNldCBvZiBjYXNlIDIgd2hlcmUg
QiBuZXZlcg0KPiBmb3Jrcywgd2Ugc3RpbGwgbmVlZCB0byBoYW5kbGUgbXJlbWFwKCksIFZNQSBt
ZXJnZXMsIFZNQSBzcGxpdHMsIGFuZA0KPiBzaW1pbGFyIGNhc2VzLg0KPiBUaGF0IHN0YXJ0cyB0
byBiZWNvbWUgcXVpdGUgYSBoZWFkYWNoZS4NCj4gDQo+IFNvIHBsZWFzZSBqdXN0IGlnbm9yZSBt
eSByYW1ibGluZyBpZiBpdCB0dXJucyBvdXQgdG8gYmUgbm9uc2Vuc2UgOi0pDQo+IA0KPiA+DQo+
ID4gUmVhZGluZyBhYm91dCBWTUEgcmVmY291bnRzIG1hZGUgbWUgc2hpdmVyLiBSZWFkaW5nICJI
b2xkaW5nIG9ubHkNCj4gPiBmb2xpb19sb2NrKGZvbGlvKSBjYW5ub3QgZ3VhcmFudGVlIHRoYXQg
dGhlIHNwbGl0IG9wZXJhdGlvbiBjb21wbGV0ZXMNCj4gPiBhdG9taWNhbGx5LiIgY29uZnVzZWQg
bWUuIExlYXJuaW5nIHRoYXQgd2UgaGF2ZSB0byBpbnZlbnQgaW50ZXJlc3RpbmcNCj4gPiB3YXlz
IHRvIG1ha2UgcGFnZSBtaWdyYXRpb24gbXV0dWFsbHkgZXhjbHVzaXZlIHRvIGZyZWVfcGd0YWJs
ZXMoKQ0KPiA+IGNvbmNlcm5lZCBtZS4gRmlndXJpbmcgb3V0IHRoYXQgdGhlcmUgYXJlIGFyY2gt
c3BlY2lmaWMgY29uZmlnIG9wdGlvbnMNCj4gPiBhbmQgcnVudGltZSB0b2dnbGVzIGlzIGEgY2xl
YXIgd2FybmluZyBzaWduLg0KPiA+DQo+ID4gU2VlaW5nIHRlc3RfZm9saW9fdW5tYXBwZWQoKSB3
YXMgZnVubnksIHRob3VnaCAod2h5PyEgOikpLg0KPiA+DQo+ID4gSSB0aGluayB0aGlzIHBhdGNo
IHNldCBoYXMgYSBub2JsZSBnb2FsIG9mIHJlZHVjaW5nIGFub25fdm1hIG92ZXJoZWFkDQo+ID4g
d2hlbiBhbm9uIHBhZ2VzIGFyZSBub3Qgc2hhcmVkIGR1cmluZyBmb3JrLiBIb3dldmVyLCB1c2lu
ZyBhbm9uX3ZtYQ0KPiA+IGZvciB0aGVtIGFjdHVhbGx5IG1ha2VzIHRoZSBvdmVyYWxsIGltcGxl
bWVudGF0aW9uIChlLmcuLCBybWFwIHdhbGtzLA0KPiA+IGxvY2tpbmcpIG1vcmUgY29uc2lzdGVu
dCBhbmQgc2ltcGxlci4NCj4gPg0KPiA+IEV2ZW4gaWYgd2UgY291bGQgYmUgY29udmluY2VkIHRo
YXQgbW9zdCBvZiB0aGlzIGhlcmUgaXMgY29ycmVjdCwgaG93DQo+ID4gc2hvdWxkIHdlIHJlYXNv
bmFibHkgbWFpbnRhaW4gdGhpcyBpbmNyZWFzaW5nIGxldmVsIG9mIGNvbXBsZXhpdHkgaGVyZT8N
Cj4gPg0KPiA+IEkgd29uJ3QgZWNobyB3aGF0IGhhcyBhbHJlYWR5IGJlZW4gc2FpZCBpbiB0aGlz
IHRocmVhZCAoYW5kIEkgZGlkbid0DQo+ID4gbWFuYWdlIHRvIHJlYWQgYWxsLCB1bmZvcnR1bmF0
ZWx5KSwgYnV0IGZvciBzdWNoIGJpZyBhbmQgaW52YXNpdmUgd29yaw0KPiA+IGl0J3Mgb2Z0ZW4g
YmVzdCB0byBnZXQgaW4gdG91Y2ggd2l0aCB0aGUgY29tbXVuaXR5IGVhcmxpZXIuIE90aGVyd2lz
ZSwNCj4gPiB5b3UgbWlnaHQgZW5kIHVwIHdhc3RpbmcgeW91ciB0aW1lLg0KPiA+DQo+ID4gT2ss
IGFyZ3VhYmx5LCBzb21lb25lIHdobyB3cml0ZXMgdGhhdCBjb2RlIGxlYXJucyBhIGxvdCBvbiB0
aGUgd2F5Lg0KPiA+IEFuZCBpZiB0aGlzIGNvZGUgcmVhbGx5IHdhcyB3cml0dGVuIGJ5IG9uZSBk
ZXZlbG9wZXIgb25seSwgSSB0aXAgbXkNCj4gPiBoYXQhIEknZCBiZSBjdXJpb3VzIGlmIHRoYXQg
Y29kZSBhbHJlYWR5IHJhbiBzb21ld2hlcmUgb24gc29tZSBBbmRyb2lkDQo+IGtlcm5lbCBvdXQg
dGhlcmU/DQo+IA0KPiBJIGhlYXJkIGZyb20gWmljaGVuZyB0aGF0IHRoZXkgaGF2ZSBiZWVuIHJ1
bm5pbmcgdGhpcyBmb3IgbW9udGhzIGFuZCBpdA0KPiBzZWVtcyByZWFzb25hYmx5IHN0YWJsZS4g
UGxlYXNlIGNvcnJlY3QgbWUgaWYgSSdtIHdyb25nLCBaaWNoZW5nIDotKS4gVGhpcw0KPiByZWFs
bHkgc2hvdWxkIGhhdmUgYmVlbiBkaXNjdXNzZWQgd2l0aCB0aGUgY29tbXVuaXR5IGVhcmxpZXIu
DQo+IA0KSSBpbml0aWFsbHkgZGV2ZWxvcGVkIGFuZCBkZWJ1Z2dlZCB0aGlzIGJhc2VkIG9uIHRo
ZSBBbmRyb2lkIEdLSSBicmFuY2gNCmFuZCBkaWQgc29tZSBwcmVsaW1pbmFyeSB0ZXN0aW5nIG9u
IGFuIEFuZHJvaWQgcGhvbmUuDQoNClNpbmNlIEdLSSBnZW5lcmFsbHkgb25seSBhY2NlcHRzIGZl
YXR1cmVzIG1lcmdlZCBmcm9tIHRoZSB1cHN0cmVhbQ0KY29tbXVuaXR5LCBhbmQgdGhpcyBtZW1v
cnkgc2F2aW5nIGNvdWxkIGFsc28gYmVuZWZpdCB0aGUgY29tbXVuaXR5LCBJDQpwb3J0ZWQgdGhl
IHBhdGNoIHRvIHRoZSBMaW51eCBtYXN0ZXIgYnJhbmNoLg0KDQpCZWNhdXNlIG15IEVuZ2xpc2gg
aXMgbm90IHZlcnkgZ29vZCBhbmQgSSByYXJlbHkgcGFydGljaXBhdGUgaW4gdGhlDQpjb21tdW5p
dHksIEkgYW0gbm90IGZhbWlsaWFyIHdpdGggdGhlIGNvbW11bml0eSB3b3JrZmxvdy4gSSBkaWQg
bm90IHNlbmQNCmFuIGVtYWlsIGZvciBkaXNjdXNzaW9uIGluIGFkdmFuY2Ugd2l0aCBhbiBSRkMg
dGFnLiBJIGFwb2xvZ2l6ZSBhZ2Fpbi4NCg0KPiA+DQo+ID4gQnV0IGFkZGluZyBtb3JlIGNvbXBs
ZXhpdHkgb24gdG9wIG9mIHNvbWV0aGluZyB0aGF0J3MgYWxyZWFkeQ0KPiA+IGV4dHJlbWVseSBj
b21wbGljYXRlZCB0byBzYXZlIHNvbWUgbWVtb3J5IGxvb2tzIGxpa2UgdGhlIHdyb25nDQo+IGRp
cmVjdGlvbiwgcmVhbGx5Lg0KPiA+DQo+ID4gSSB3YXMgZXhjaXRlZCB3aGVuIExvcmVuem8gc3Rh
cnRlZCB3b3JraW5nIG9uIGEgY29tcGxldGVseSBuZXcNCj4gPiBhcHByb2FjaCB0aGF0IHdvdWxk
IGZvY3VzIG9uIGltcHJvdmluZyB0aGUgY29tbW9uIGNhc2VzIHdoaWxlIHRyeWluZw0KPiA+IHRv
IHJlZHVjZSB0aGUgb3ZlcmFsbCBjb21wbGV4aXR5LiBCZWNhdXNlIEkgdGhpbmsgbW9zdCBvZiB1
cyByZWFsbHkNCj4gPiBkaXNsaWtlIGFub25fdm1hLiBJdCdzIHN0aWxsIHdvcmsgaW4gcHJvZ3Jl
c3MsIGFuZCBJIGFtIHN1cmUgdGhlcmUgYXJlIHNvbWUNCj4gcm91Z2ggZWRnZXMuDQo+ID4NCj4g
PiBCdXQgZnVuZGFtZW50YWxseSwgSSB0aGluayB3ZSB3YW50IHRvIGZpbmQgYSBuZXcgZGVzaWdu
IHRoYXQgaXMganVzdA0KPiA+IG5hdHVyYWxseSBzaW1wbGVyLg0KPiA+DQo+IA0KPiArMQ0KPiAN
Cj4gPiBMb3JlbnpvIGhhcyBiZWVuIGhhcmQgYXQgd29yayBleHBsb3JpbmcgdmFyaW91cyBkZXNp
Z24gb3B0aW9ucyAoYW5kDQo+ID4gSSdtIGFmcmFpZCBoZSBtaWdodCBiZSBvbmUgb2YgdGhlIDMg
cGVvcGxlIG9uIHRoaXMgcGxhbmV0IHRoYXQNCj4gPiB1bmRlcnN0YW5kIGFub25fdm1hIGluIGZ1
bGwgZGV0YWlsKSwgc28gSSBzdWdnZXN0IHdlIHdhaXQgZm9yIGENCj4gPiByZWRlc2lnbiBwcm9w
b3NhbCBmcm9tIGhpbSBhbmQgc2VlIGlmIHRoYXQgaXMgZG9hYmxlPw0KPiA+DQo+IA0KPiBUaGFu
a3MNCj4gQmFycnkNCg==


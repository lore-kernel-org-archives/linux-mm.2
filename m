Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B3690CD6E4A
	for <linux-mm@archiver.kernel.org>; Thu,  4 Jun 2026 07:35:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 23DAD6B0005; Thu,  4 Jun 2026 03:35:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1EE576B0088; Thu,  4 Jun 2026 03:35:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0DD276B008A; Thu,  4 Jun 2026 03:35:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id EE47E6B0005
	for <linux-mm@kvack.org>; Thu,  4 Jun 2026 03:35:27 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id B33161405E3
	for <linux-mm@kvack.org>; Thu,  4 Jun 2026 07:35:27 +0000 (UTC)
X-FDA: 84841419894.12.4BEC1EE
Received: from mta22.hihonor.com (mta22.hihonor.com [81.70.192.198])
	by imf18.hostedemail.com (Postfix) with ESMTP id B78A41C0006
	for <linux-mm@kvack.org>; Thu,  4 Jun 2026 07:35:23 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=honor.com header.s=dkim header.b=MAlF3fYm;
	spf=pass (imf18.hostedemail.com: domain of tao.wangtao@honor.com designates 81.70.192.198 as permitted sender) smtp.mailfrom=tao.wangtao@honor.com;
	dmarc=pass (policy=none) header.from=honor.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780558525;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9h5MDONrlf5udMRRWdNkQZ2RCA0Oam9E19zys+QVifc=;
	b=j1f2+Omtt0tqrV0oDZssXRUjtAOwHfCBL3PmZQdLkqtVFPIpKV656ruNLi52ZkpS8YqPKn
	f7+LywzijLpa7SSroQFLC0iNWxG6iNTGbWaJSh3VufcWj52CO9q0ZgvnEoqpYtH353A94Z
	ykSSgDjbF2E3koBcZiUtQcZOKzydGGg=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=honor.com header.s=dkim header.b=MAlF3fYm;
	spf=pass (imf18.hostedemail.com: domain of tao.wangtao@honor.com designates 81.70.192.198 as permitted sender) smtp.mailfrom=tao.wangtao@honor.com;
	dmarc=pass (policy=none) header.from=honor.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780558525;
	b=pJym7guJKhJ33StWpYQaviYRyHtg7dQQXP5GNv4tDavx42w7ze7UiyADZmkmeQi+jYRLaX
	Z0VE92Ni2Cx1JFI8518DM43gaf1IrLPsSpFSi7AQXffQZMWDklscoulBa2CKvqACI5KYUs
	c8nQVhjGKUDfkGLfbr/TW1Lp0Rg4fDE=
dkim-signature: v=1; a=rsa-sha256; d=honor.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=To:From;
	bh=9h5MDONrlf5udMRRWdNkQZ2RCA0Oam9E19zys+QVifc=;
	b=MAlF3fYmlZBznxMRnPOaTW9/Xu6Cl1PQpuaNrTdumG3c7d/S+iH/b0+6O9gJpaoev1YAXsgsO
	ot3OKjO7lBz608uUW/2Swz0jn/wrqpbjnfeKHGa/9iad50CBgTZfEI5ceXLRX/ZV6FQ0SyHf/CT
	KsZB3CVHnX0eapmbUDOFx4M=
Received: from TW006-1.hihonor.com (unknown [10.77.215.153])
	by mta22.hihonor.com (SkyGuard) with ESMTPS id 4gWGXP33Q3zYlRXB;
	Thu,  4 Jun 2026 15:33:57 +0800 (CST)
Received: from TA006-1.hihonor.com (10.77.232.151) by TW006-1.hihonor.com
 (10.77.215.153) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.37; Thu, 4 Jun
 2026 15:35:15 +0800
Received: from TA003.hihonor.com (10.72.0.43) by TA006-1.hihonor.com
 (10.77.232.151) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Thu, 4 Jun
 2026 15:34:25 +0800
Received: from TA003.hihonor.com ([fe80::998f:47ec:980d:bdf1]) by
 TA003.hihonor.com ([fe80::998f:47ec:980d:bdf1%7]) with mapi id
 15.02.2562.037; Thu, 4 Jun 2026 15:35:15 +0800
From: wangtao <tao.wangtao@honor.com>
To: Barry Song <21cnbao@gmail.com>
CC: "David Hildenbrand (Arm)" <david@kernel.org>, "catalin.marinas@arm.com"
	<catalin.marinas@arm.com>, "will@kernel.org" <will@kernel.org>,
	"tglx@kernel.org" <tglx@kernel.org>, "mingo@redhat.com" <mingo@redhat.com>,
	"bp@alien8.de" <bp@alien8.de>, "dave.hansen@linux.intel.com"
	<dave.hansen@linux.intel.com>, "x86@kernel.org" <x86@kernel.org>,
	"akpm@linux-foundation.org" <akpm@linux-foundation.org>,
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
Thread-Index: AQHc7cjw5r5ki6LAJ0S2mW/rJEfblbYszHKAgAAenICAAOQZkP//ggoAgACqSnA=
Date: Thu, 4 Jun 2026 07:35:14 +0000
Message-ID: <3031859912bb43a7ab16ec63863914ab@honor.com>
References: <20260527110147.17815-1-tao.wangtao@honor.com>
 <70377626-500d-46f2-a3f5-a0d2914ce365@kernel.org>
 <CAGsJ_4zg8+pVDwtsJtxxiC1ahJ9MR56Ue8VXCt_VrQgcXES2uQ@mail.gmail.com>
 <273d02a1af954b8c9f4da7fb74e6b4cb@honor.com>
 <CAGsJ_4xTMsV8fJVfhshDQp4=Ax2f_+b6yR873cEP11bjcEa_5Q@mail.gmail.com>
In-Reply-To: <CAGsJ_4xTMsV8fJVfhshDQp4=Ax2f_+b6yR873cEP11bjcEa_5Q@mail.gmail.com>
Accept-Language: en-US
Content-Language: zh-CN
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-originating-ip: [10.163.18.240]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: B78A41C0006
X-Stat-Signature: 7sxydmdtdtyfpy8xyxqwc6hjh8ie4ujd
X-Rspam-User: 
X-HE-Tag: 1780558523-391214
X-HE-Meta: U2FsdGVkX1+GBaqf5nay0Uny5VYes5g0Cy4RKRWFy76Jcl2bZqtxRfeAAz8ylktlk7kh273Dq1+sSLI81VB04xUy70y0qWEEqh0rfllSZ1pwIApbWj6WmV5PhNGkeCspKRohnZeehtl83fg7T/OgJ5UOqNZFWFJZlpLhJgxFbw7iU/HG9jWgmtrGWTgjiDZXE+gZEqdOo4ycO0lPqtYPZ0gfXP0G8Zvz2IvZ59hWJzm34QqUeyyovotz/7gEG/KSZwHP3BKfOtsLHMTB6ubG/aE+zZt+gjkLQL9nSO5GYLohnwQmBaew+hI0T8uzMcJstm8H3+nbFjgSCjHJs27PF3csLtgRs4DPMz6VpaPUqgJXSYBKp9pDf5DyVu1G7YB5rOD7w4VsrDT9F7pIX/lR4fBXhFanJcKIK084HaCtz/yve/mTXTC2YG2ocXCdiGaeNfzJCmPWrvGBtEB6K3DQSe8EVxWqj9ocuqdGIXp2bDkCSFDxiS1UqqN/KaYqqCKTTi0t4Np48miCcwok8Sx7q+kMDQq08OvLBlJU5M7JbebeAhrn366FOeu1V5OK1/7xYASH9gOUMJrb+RalnNu4gPy+mFp4VIk0T0Ij0FhgajBW0zyPqek2vZ7UFUug021F0DMziwmX7qgLDTNbREbhfxHRynXxhsZZx17AAjKU9cRjDggEM9g6ST3g2SlK40S6OQMPfAqFOO9AdDD80rbpOvm/hLHo3q0OqWq6l6REglke/Izx+stIAZIO0qu+RxZUNE41oXN4HTKh7/v+/uJ5HpAfieePFOeu8SXjuKc0/IFpdkpzb/AfLx3P/e3CdPUFrUsu1SWzuj9JWlt5MfMPRMX60bQuGdzhYjJQb7E/35P9Rv0maHS+wuG0zdkOs4X2zLFAjIZHwK/ATTuXF7PZRb0Yby8IvbUUEL70fZUYomV/0ZMbHC0Zomm4Yzgz7iss8P6eZ0ASFIYA8V3J3RU
 L9UuWuaF
 lGnywrsZox4fFHD25963ssNDDwCneFWY0ozqfRe7tGn6cNrlASEHEJU/eDhzzG8g7m76bRjQtgJhGN+yM0zCkcP/wP1Cmqr9KnAhhLyDO+t1zkcIoMjlD3oSsbspzlT7EU/VXZTWvWS1zZx820yGbqD3otXxLuc3vU5Jw8fhaDVvoo+PgWevgweYxidw2dNAriHBmDBf/FHCTQ8xspEzc4Nul4HzLgN7F+2+MtleGISoSl0UWQRyT+t9H6j1eAKMNGC/6+6db5QzHyZyK/9eNCLgsY30xIs+h1VNHob7z4QPSLw9Yz5UhlY1WeSodqKw5R/+m4fS8XEVrFynAB6t5jyO0DCpxxQztcup3ANZ4uLEf1TLY6+30E8DPM+pZ6qCHufM9TFIQ6pq5mbgmwvbldQur9lIa2AakHzQdeXLK8fz/1wf80i4o1iKbXWj9vuwmEvlo5nDr34BfR1hhkF6+j8YzmXlmF7n9mfWOLt4He2h8KPqcGbD8ghv12f3HjoYFEGWGuRmKAa/E/v8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

PiBbLi4uXQ0KPiA+ID4gPiBJIHdvbid0IGVjaG8gd2hhdCBoYXMgYWxyZWFkeSBiZWVuIHNhaWQg
aW4gdGhpcyB0aHJlYWQgKGFuZCBJDQo+ID4gPiA+IGRpZG4ndCBtYW5hZ2UgdG8gcmVhZCBhbGws
IHVuZm9ydHVuYXRlbHkpLCBidXQgZm9yIHN1Y2ggYmlnIGFuZA0KPiA+ID4gPiBpbnZhc2l2ZSB3
b3JrIGl0J3Mgb2Z0ZW4gYmVzdCB0byBnZXQgaW4gdG91Y2ggd2l0aCB0aGUgY29tbXVuaXR5DQo+
ID4gPiA+IGVhcmxpZXIuIE90aGVyd2lzZSwgeW91IG1pZ2h0IGVuZCB1cCB3YXN0aW5nIHlvdXIg
dGltZS4NCj4gPiA+ID4NCj4gPiA+ID4gT2ssIGFyZ3VhYmx5LCBzb21lb25lIHdobyB3cml0ZXMg
dGhhdCBjb2RlIGxlYXJucyBhIGxvdCBvbiB0aGUgd2F5Lg0KPiA+ID4gPiBBbmQgaWYgdGhpcyBj
b2RlIHJlYWxseSB3YXMgd3JpdHRlbiBieSBvbmUgZGV2ZWxvcGVyIG9ubHksIEkgdGlwDQo+ID4g
PiA+IG15IGhhdCEgSSdkIGJlIGN1cmlvdXMgaWYgdGhhdCBjb2RlIGFscmVhZHkgcmFuIHNvbWV3
aGVyZSBvbiBzb21lDQo+ID4gPiA+IEFuZHJvaWQNCj4gPiA+IGtlcm5lbCBvdXQgdGhlcmU/DQo+
ID4gPg0KPiA+ID4gSSBoZWFyZCBmcm9tIFppY2hlbmcgdGhhdCB0aGV5IGhhdmUgYmVlbiBydW5u
aW5nIHRoaXMgZm9yIG1vbnRocyBhbmQNCj4gPiA+IGl0IHNlZW1zIHJlYXNvbmFibHkgc3RhYmxl
LiBQbGVhc2UgY29ycmVjdCBtZSBpZiBJJ20gd3JvbmcsIFppY2hlbmcNCj4gPiA+IDotKS4gVGhp
cyByZWFsbHkgc2hvdWxkIGhhdmUgYmVlbiBkaXNjdXNzZWQgd2l0aCB0aGUgY29tbXVuaXR5IGVh
cmxpZXIuDQo+ID4gPg0KPiA+IEkgaW5pdGlhbGx5IGRldmVsb3BlZCBhbmQgZGVidWdnZWQgdGhp
cyBiYXNlZCBvbiB0aGUgQW5kcm9pZCBHS0kNCj4gPiBicmFuY2ggYW5kIGRpZCBzb21lIHByZWxp
bWluYXJ5IHRlc3Rpbmcgb24gYW4gQW5kcm9pZCBwaG9uZS4NCj4gPg0KPiA+IFNpbmNlIEdLSSBn
ZW5lcmFsbHkgb25seSBhY2NlcHRzIGZlYXR1cmVzIG1lcmdlZCBmcm9tIHRoZSB1cHN0cmVhbQ0K
PiA+IGNvbW11bml0eSwgYW5kIHRoaXMgbWVtb3J5IHNhdmluZyBjb3VsZCBhbHNvIGJlbmVmaXQg
dGhlIGNvbW11bml0eSwgSQ0KPiA+IHBvcnRlZCB0aGUgcGF0Y2ggdG8gdGhlIExpbnV4IG1hc3Rl
ciBicmFuY2guDQo+ID4NCj4gPiBCZWNhdXNlIG15IEVuZ2xpc2ggaXMgbm90IHZlcnkgZ29vZCBh
bmQgSSByYXJlbHkgcGFydGljaXBhdGUgaW4gdGhlDQo+ID4gY29tbXVuaXR5LCBJIGFtIG5vdCBm
YW1pbGlhciB3aXRoIHRoZSBjb21tdW5pdHkgd29ya2Zsb3cuIEkgZGlkIG5vdA0KPiA+IHNlbmQg
YW4gZW1haWwgZm9yIGRpc2N1c3Npb24gaW4gYWR2YW5jZSB3aXRoIGFuIFJGQyB0YWcuIEkgYXBv
bG9naXplIGFnYWluLg0KPiA+DQo+IA0KPiBObyB3b3JyaWVzLiBJIGtub3cgc29tZW9uZSB3aG8g
aGFzIHdvcmtlZCBvbiB0aGUgTGludXgga2VybmVsIGZvciBtYW55LA0KPiBtYW55IHllYXJzIGFu
ZCBoYXMgZXhjZWxsZW50IGtlcm5lbCBleHBlcnRpc2UsIHlldCBoYXMgbmV2ZXIgc3VibWl0dGVk
IGENCj4gcGF0Y2ggdGhyb3VnaG91dCBoaXMgY2FyZWVyIGZvciB2YXJpb3VzIHJlYXNvbnMuDQo+
IA0KPiBJIGhlYXJkIGZyb20gWmljaGVuZyB0aGF0IHlvdSBhcmUgSE9OT1IncyBrZXkgTU0gZXhw
ZXJ0IGFuZCBoYXZlIGJlZW4NCj4gZ3VpZGluZyB0aGVtIG9uIG1lbW9yeS1tYW5hZ2VtZW50IHJl
bGF0ZWQgd29yay4gVGhhdCdzIHJlYWxseSBpbXByZXNzaXZlLg0KPiBQZXJzb25hbGx5LCBJJ2Qg
bG92ZSB0byBzZWUgbW9yZSBpZGVhcyBhbmQgY29udHJpYnV0aW9ucyBmcm9tIHlvdSBpbiB0aGUg
bGludXgtDQo+IG1tIGNvbW11bml0eS4NCj4gDQo+IEJUVywgcmVnYXJkaW5nIG15IGVhcmxpZXIg
c3VnZ2VzdGlvbiBhYm91dCB1c2luZyBHS0kgaG9va3PigJRsaW1pdGluZyB0aGUNCj4gb3B0aW1p
emF0aW9uIHRvIG5ld2x5IGNyZWF0ZWQgVk1BcyBhbmQgdG8gYXBwbGljYXRpb25zIHRoYXQgbmV2
ZXIgY2FsbA0KPiBmb3JrKCnigJRkbyB5b3UgaGF2ZSBhbnkgaWRlYXMgb24gd2hhdCB0aGUgc21h
bGxlc3QgcG9zc2libGUgaG9vayBjaGFuZ2UNCj4gd291bGQgbG9vayBsaWtlPw0KRXZlbiBpZiBB
bmRyb2lkIGRvZXMgbm90IGNvbnNpZGVyIGhhbmRsaW5nIGZvciAzMi1iaXQsIEtTTSwgb3INCm1l
bW9yeS1mYWlsdXJlLCBhIGxhcmdlIG51bWJlciBvZiBob29rcyBhcmUgc3RpbGwgcmVxdWlyZWQu
DQoNCkEgZGlmZmVyZW50IGltcGxlbWVudGF0aW9uIGFwcHJvYWNoIGlzIGFsc28gbmVlZGVkLiBG
b3IgZXhhbXBsZSwgb25lDQpvciBhIHNldCBvZiBhbm9uX3ZtYV9sb2NrcyBjb3VsZCBiZSB1c2Vk
IHRvIG1hcmsgd2hldGhlciBhIFZNQSBpcw0KbGF6eSwgc28gdGhhdCB3ZSBjYW4gYXZvaWQgbW9k
aWZ5aW5nIGFsbCBwbGFjZXMgdGhhdCBkZXJlZmVyZW5jZQ0KYW5vbl92bWEuIFJlc2VydmVkIGZp
ZWxkcyBpbiB2bWEgY291bGQgYmUgdXNlZCB0byByZWNvcmQgdGhlIHJvb3Rfdm1hDQphbmQgYSBy
ZWZlcmVuY2UgY291bnQgcmVzcGVjdGl2ZWx5Lg0KDQpSb3VnaGx5LCBob29rcyB3b3VsZCBiZSBu
ZWVkZWQgaW4gdGhlIGZvbGxvd2luZyBwbGFjZXM6DQoNCjEuIF9fdm1mX2Fub25fcHJlcGFyZTog
bWFyayBsYXp5X3ZtYSBpbiB0aGUgZmF1bHQgcGF0aC4NCjIuIF9fZm9saW9fc2V0X2Fub24gYW5k
IGZvbGlvX21vdmVfYW5vbl9ybWFwOiBzZXQgbWFwcGluZyB0byBsYXp5X3ZtYS4NCjMuIHJtYXBf
d2Fsa19hbm9uOiBoYW5kbGUgcm1hcF93YWxrIGZvciBsYXp5X3ZtYS4NCjQuIGZvbGlvX2dldF9h
bm9uX3ZtYSBhbmQgcHV0X2Fub25fdm1hOiBhZGQgaG9va3MgdG8gZGlzdGluZ3Vpc2gNCiAgIGxh
enlfdm1hIGhhbmRsaW5nLg0KNS4gYW5vbl92bWFfZm9yazogZGVjaWRlIHdoZXRoZXIgdG8gdXBn
cmFkZSBwdm1hLT5hbm9uX3ZtYS4NCjYuIEFkZCBhIGhvb2sgaW4gdHJ5X2R1cF9hbm9uX3JtYXAg
dG8gdXBncmFkZSBmb2xpby0+bWFwcGluZy4NCjcuIGFub25fdm1hX2Nsb25lOiBoYW5kbGUgbGlu
a3Mgd2hlbiBzcmMgaXMgYSBsYXp5X3ZtYS4NCjguIHZtX2FyZWFfYWxsb2MgLyB2bV9hcmVhX2R1
cCAvIHZtX2FyZWFfZnJlZTogYWRkIFZNQSByZWZlcmVuY2UNCiAgIGNvdW50aW5nLg0KOS4gbXJl
bWFwOiBoYW5kbGUgdXBncmFkZXMgaW4gY29weV92bWEgYW5kIG1vdmVfcGFnZV90YWJsZXMuDQoN
CklmIHRoaXMgY2FuIGJlIHJlc3RyaWN0ZWQgdG8gYXBwcyBvbmx5IGFuZCB0aGUgYXBwIG5ldmVy
IGNhbGxzIGZvcmsoKSwNCnRoZW4gNSBhbmQgNiBjb3VsZCBhbHNvIGJlIHJlbW92ZWQuDQoNCklm
IGVhY2ggcGFnZSdzIG1hcHBpbmcgaW4gdGhlIHBhZ2UgdGFibGVzIGlzIHN5bmNocm9ub3VzbHkg
dXBkYXRlZA0Kd2hlbiB1cGdyYWRpbmcgbGF6eV92bWEsIHRoZW4gNCBhbmQgNSBjb3VsZCBiZSBt
ZXJnZWQgaW50byBvbmUuDQoNCklmIGxhenlfdm1hIGlzIHJlc3RyaWN0ZWQgdG8gYW5vbnltb3Vz
IFZNQXMgd2hlcmUNCnZtYV9tYXBwaW5nX2Jhc2Uodm1hKSA9IDAsIHRoZW4gcm9vdF92bWEgYW5k
IHRoZSBWTUEgcmVmZXJlbmNlIGNvdW50DQpjb3VsZCBhbHNvIGJlIHJlbW92ZWQuDQoNCldpdGgg
dGhpcyByZXN0cmljdGlvbiwgd2UgY291bGQgZGlyZWN0bHkgdXNlIGZvbGlvLT5tYXBwaW5nIHRv
IHJlY29yZA0KbW0sIGFuZCBsb2NhdGUgdGhlIHZtYSB1c2luZyBmb2xpby0+aW5kZXgsIHdoaWNo
IHdvdWxkIHNpbXBsaWZ5IHRoaXMNCnBhdGNoIHNlcmllcy4NCj4gDQo+IFRoYW5rcw0KPiBCYXJy
eQ0K


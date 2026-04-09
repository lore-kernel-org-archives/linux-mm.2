Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B6E22E9DE6A
	for <linux-mm@archiver.kernel.org>; Thu,  9 Apr 2026 08:37:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1A14F6B008C; Thu,  9 Apr 2026 04:37:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 151846B0092; Thu,  9 Apr 2026 04:37:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 068736B0093; Thu,  9 Apr 2026 04:37:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id E8F5A6B008C
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 04:37:34 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 8F9D11B7E99
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 08:37:34 +0000 (UTC)
X-FDA: 84638363628.11.25645FC
Received: from mta20.hihonor.com (mta20.hihonor.com [81.70.206.69])
	by imf10.hostedemail.com (Postfix) with ESMTP id CF991C000B
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 08:37:30 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=none;
	spf=pass (imf10.hostedemail.com: domain of wangzicheng@honor.com designates 81.70.206.69 as permitted sender) smtp.mailfrom=wangzicheng@honor.com;
	dmarc=pass (policy=none) header.from=honor.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775723852;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=slKIIxZHPJtfzl3BxAXEGV+ymAm1hnWUImamO1FevdE=;
	b=LJWymxJ3MRe8pm7PHqwBtfcY8fZIh5hTVnn+hhwonGPcSx83+EzBhhOwquNDzYugr+cfBO
	Us1JlBZ8M0jg041ZKjtdUZj2f3AwtQ3GrMQOWXPuoJvWihUnXjzmvF4dD9D5QddxhiU4f8
	iuPQMhE7dY2RghN56ZPlNPe5jbFzLLo=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=none;
	spf=pass (imf10.hostedemail.com: domain of wangzicheng@honor.com designates 81.70.206.69 as permitted sender) smtp.mailfrom=wangzicheng@honor.com;
	dmarc=pass (policy=none) header.from=honor.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775723852; a=rsa-sha256;
	cv=none;
	b=32djK0RHBoCJMQFo+CqEcho7PUELfZiq1w3OmxmF4tYdkejc4B1Yc6VU+zsd52V8RCVT4Z
	Ukfb972SA+SeusD4oUwoelEy49z6U1orZgzrzqXiLML/VwT3NRfAOvEg40hp+gUV+CWTXG
	E1Rh1LsOINUs/bsTqg7IND7QgDW93fE=
Received: from w001.hihonor.com (unknown [10.68.25.235])
	by mta20.hihonor.com (SkyGuard) with ESMTPS id 4frtZH5ZGkzYkxt8;
	Thu,  9 Apr 2026 16:36:23 +0800 (CST)
Received: from TA011.hihonor.com (10.77.232.85) by w001.hihonor.com
 (10.68.25.235) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.27; Thu, 9 Apr
 2026 16:37:24 +0800
Received: from TA012.hihonor.com (10.77.228.68) by TA011.hihonor.com
 (10.77.232.85) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Thu, 9 Apr
 2026 16:37:23 +0800
Received: from TA012.hihonor.com ([fe80::9e31:9fdb:69fb:928c]) by
 TA012.hihonor.com ([fe80::9e31:9fdb:69fb:928c%8]) with mapi id
 15.02.2562.017; Thu, 9 Apr 2026 16:37:08 +0800
From: wangzicheng <wangzicheng@honor.com>
To: Barry Song <baohua@kernel.org>, Kairui Song <ryncsn@gmail.com>
CC: wangzhen <wangzhen5@honor.com>, Andrew Morton <akpm@linux-foundation.org>,
	Johannes Weiner <hannes@cmpxchg.org>, David Hildenbrand <david@kernel.org>,
	Michal Hocko <mhocko@kernel.org>, Qi Zheng <zhengqi.arch@bytedance.com>,
	Shakeel Butt <shakeel.butt@linux.dev>, Lorenzo Stoakes <ljs@kernel.org>, Axel
 Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, Wei
 Xu <weixugc@google.com>, "kasong@tencent.com" <kasong@tencent.com>,
	"baolin.wang@linux.alibaba.com" <baolin.wang@linux.alibaba.com>,
	"linux-mm@kvack.org" <linux-mm@kvack.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>
Subject: RE: [PATCH RFC] mm/vmscan:Fix the hot/cold inversion when swappiness
 = 0 or 201
Thread-Topic: [PATCH RFC] mm/vmscan:Fix the hot/cold inversion when swappiness
 = 0 or 201
Thread-Index: AQHcxpp3lWbWYl52/kGrIYBkwEcKwbXTsUiAgABHaICAAZuggIAAusoA
Date: Thu, 9 Apr 2026 08:37:08 +0000
Message-ID: <6e9abeaab88f4053a34ced0b3b4be165@honor.com>
References: <7829b070df1b405dbc97dd6a028d8c8a@honor.com>
 <4451bdc432864aebb54f401eee51ea53@honor.com> <adUM54W3WYwEFj3J@KASONG-MC4>
 <CAGsJ_4yZHjSq=d1g7dJC9szwRVLuHqLpWt0Cphi7npzrQz6p3g@mail.gmail.com>
 <adW_O1-QAQadQ68-@KASONG-MC4>
 <CAGsJ_4wcQTrp-zQ=pj2v5Pa3z_SLs56p+t2OmG6myz7GJdqb2A@mail.gmail.com>
In-Reply-To: <CAGsJ_4wcQTrp-zQ=pj2v5Pa3z_SLs56p+t2OmG6myz7GJdqb2A@mail.gmail.com>
Accept-Language: en-US
Content-Language: zh-CN
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-originating-ip: [10.163.18.229]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-Rspamd-Queue-Id: CF991C000B
X-Stat-Signature: oho9tbiq9toqguaitrh7nmj8jr5ygik1
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1775723850-513334
X-HE-Meta: U2FsdGVkX1+cr1aK9LB56SUMaleaccoYuDZr6wmqk8A2pJPnbg/Y6Ejtgx60vmRLJIjc5frUfsEJ2tQtVsUphHIlcy4gKEWcwdSLLUM08uaZuQO7v5SltNhdC3f1HRtWwJbtD3HDWBWvLtgvJwUFua13nPNn/WGxTF6x+u7fP5Ir38Aib3TjKoxbuKq29NWNFV/KSkp+6FmkwKTI79KVsagLXxCC58GPyN2b1ThZFsfbop3Reakm44/1CX6riptf+xQasCG0yEFMZutfGXRP4Kei5Re3oa9dCQw2uX+7orx4VJfkuEhPhJp9xlM2XVza5lxqWwbJJGw3dHZpJcWJR5m21xuGSABM+ua42ft0ortSfmiFQxEwydqC911g6gkBDKoSPmhTjxDaLscvbCKn9XfpMpSJM+Vcu1fDswbVd4ktAhiT6k11EU/19+8yCNDT8fMhOvDj+sqyA0IxX6XbpsIoyFPdmZJem/gjgXzi9Yh2BIdODlrZqAPoLbkADAFhr8BIuUSZYLTfCZHWUkXF/KwJYfMcv3y3O8eZgbQjaLJkSzcbeDTku3nEeuYklzCZxvA05ZK5/ZAuExJJFEI/0BUntYvh+VDmkQNMCdOzsTsmIFLzgIVKoxL/ogwqq9ihyU2Mo9r1P5iQTkBJPmTP7J4BqbSPyd1Y3JgPNEeXJ0ZGsEdTCMxPUsv5wfSImPjY+V3+xZALEBjpGRbN6eD4zJP23HFtLBSYH8dQEX6ycFoZHReBKctYGH2UMLYjSSvSPl+3Iw7MrEa1tOduqrI3bxDDPN36612UarMpIoQZq5XAsBtho+XtRATwR7YRyNVN49BOJ0Xb/GH7zpi20AaqvhzZ7vy+SldnTr0Qj80UF09HiwFnSaCeJ5CB84qFJtf+hE7nBeX9PKjyWbtfTxLCHnIIJq38j6Tpwf47Bp0xYSb8oStTIY6mz9dS0fBPDJKcAGPUoPMTKhwpKOwsVyk
 47+dGyCj
 QZwPz6rpaGZZZ4QRSrRWRRa04tQUTNYyINFVrIaTwurLJAZZqufAuLEq63l3wX7/RT/Oa4oVJ8S7iLu01EyecWrLjF/B86pCqxH55Ftgwt5eXEr2CaHZ79UQWuPu9rvuU6C/q2tKviCUzPikY9vo3PdhOPkSI+UgO0rXoqmEaH4HnZLtZEsLnFDfe2F4bcJgt90Fy0xPxTEGnYwShQdcEj/VEJwiEdlbbp9mAyVxSHzgy7QNJPJCaXA6Wgln6OeCyUMxtrlGcFwBgxlA7xkBvduub57eF/kKujT9VEFpZLQEdfrIS5hhl3/PIkzBU2JCp0MMnMdK+yLOOJ5oB5Nj96Yjk4QtJHQK9GPOMt+WSlnL/YC/TBwsrTvF6IJ8OQPOjt8NL55bjPl4EmkTPSNBuDKkvw/jzLUE3BeTBkMjUM4cKbDk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

PiA+ID4gSSBzdXNwZWN0IHRoYXQgb25jZSB3ZSBjYW4gYWdlIGZpbGUgYW5kIGFub255bW91cyBw
YWdlcw0KPiA+ID4gc2VwYXJhdGVseSwgdGhpcyBpc3N1ZSB3aWxsIHJlc29sdmUgaXRzZWxmLiBE
YXZpZCBhbHJlYWR5IGhhcw0KPiA+ID4gc29tZSBjb2RlIGZvciB0aGlzIFsxXS4NCj4gPiA+DQo+
ID4gPiBOb3Qgc3VyZSB3aGVuIGhlIHdpbGwgaGF2ZSB0aW1lIHRvIHB1c2ggaXQgdXBzdHJlYW0s
IGJ1dCBJDQo+ID4gPiBtYXkgY2FydmUgb3V0IHNvbWUgdGltZSB0byB0YWtlIGNhcmUgb2YgaXQg
dGhpcyBtb250aC4NCj4gPiA+DQo+ID4gPiBbMV0gaHR0cHM6Ly9sb3JlLmtlcm5lbC5vcmcvbGlu
dXgtbW0vYWFtNW5PeVhzMXNOZGpUZUBnb29nbGUuY29tLw0KPiA+DQo+ID4gSGksIHRoYW5rcyBm
b3Igc2hhcmluZyB0aGUgaWRlYS4NCj4gPg0KPiA+IFJpZ2h0LCBhIGZldyB3ZWVrcyBhZ28gSSBh
bHNvIGdvdCBpbmZvIGZyb20gQ2FjaHlPUyB0aGF0IHRoZXkgYXJlIHVzaW5nDQo+ID4gZm9sbG93
aW5nIHBhdGNoIGZvciBNR0xSVToNCj4gPg0KPiA+IGh0dHBzOi8vZ2l0aHViLmNvbS9maXJlbHpy
ZC9yZS1zd2FwcGluZXNzDQo+ID4NCj4gPiBUaGUgaWRlYSBpcyBhbHNvIHNwbGl0IHRoZSBzZXEg
bnVtYmVyIGZvciBhbm9uIC8gZmlsZSBzbyBzd2FwcGluZXNzDQo+ID4gd29ya3MgYWdhaW4uDQo+
ID4NCj4gPiBIb3dldmVyLCBJIHJlYWxseSBub3Qgc3VyZSBpZiB0aGlzIGlzIHRoZSByaWdodCBh
cHByb2FjaC4gSXQgY2hhbmdlcw0KPiA+IHRoZSBtb2RlbCBvZiBNR0xSVSBhbmQgdGhpbmdzIGxp
a2UgVFRMIG1heSBubyBsb25nZXIgd29yayBhcyBleHBlY3RlZC4NCj4gPiBBbmQgVFRMIGRvZXMg
c29sdmUgcmVhbCBwcm9ibGVtcyB0b28gKGFsc28gZnJvbSBDYWNoeU9TKToNCj4gPg0KPiA+IGh0
dHBzOi8vZ2l0aHViLmNvbS9maXJlbHpyZC9sZTl1bw0KPiA+DQo+ID4gVFRMIHJlcGxhY2VkIHRo
ZSBsZTkgcGF0Y2ggYWJvdmUgaW4gYSBjbGVhbmVyIHdheSBmb3IgdGhyYXNoaW5nDQo+ID4gcHJl
dmVudGlvbi4NCj4gPg0KPiA+IFJpZ2h0IG5vdyB3ZSBkbyBwYWdlIHRhYmxlIHdhbGsgKGFuZCBp
dCB3YWxrcyBib3RoIGFub24gLyBmb2xpbykNCj4gPiB3aGlsZSBnZW5lcmF0aW5nIG9uZSB1bmlm
aWVkIG5ldyBnZW4sIG1lYW5pbmcgdGhlIGZvbGlvcyBpbiB0aGF0DQo+ID4gZ2VuIGhhdmUgdGhl
IHNhbWUgKG9yIGF0IGxlYXN0IGFsbCBvbGRlciB0aGFuIGEgc3BlY2lmaWMpIGFjY2Vzcw0KPiA+
IHRpbWUsIHdoaWNoIGlzIHVzZWQgYXMgdGhlIG1ldHJpYyBmb3IgVFRMLg0KPiA+DQo+ID4gQmVz
aWRlcywgaGF2aW5nIHVuaWZpZWQgZ2VucyBhbHNvIGhlbHAgaW1wbGVtZW50aW5nIHRoaW5ncyBs
aWtlDQo+ID4gd29ya2luZ3NldCByZXBvcnRpbmcgd2hlcmUgZWFjaCBnZW4gaXMgbGlrZSBhIGJp
biBmb3IgaGlzdG9ncmFtOg0KPiA+DQo+ID4gaHR0cHM6Ly9sd24ubmV0L0FydGljbGVzLzk3Njk4
NS8NCj4gPg0KPiA+IEFnaW5nIHRyaWdnZXJpbmcgY291bGQgYmUgYSBiaXQgbW9yZSBwcm9ibGVt
YXRpYyB0b28uDQo+ID4gSSB0aGluayB0aGUgcmlnaHQgd2F5IGlzIHRvIGp1c3QgZG8gdGhlIGFn
aW5nIGFzeW5jaHJvbm91c2x5LCBZdQ0KPiA+IGV2ZW4gbGVmdCBhIFRPRE8gY29tbWVudCBpbiB2
bXNjYW4uYzoNCj4gPg0KPiA+IC8qDQo+ID4gICogRm9yIGZ1dHVyZSBvcHRpbWl6YXRpb25zOg0K
PiA+ICAqIDEuIERlZmVyIHRyeV90b19pbmNfbWF4X3NlcSgpIHRvIHdvcmtxdWV1ZXMgdG8gcmVk
dWNlIGxhdGVuY3kgZm9yDQo+IG1lbWNnDQo+ID4gICogICAgcmVjbGFpbS4NCj4gPiAgKi8NCj4g
DQo+IEFnaW5nIGFzeW5jaHJvbm91c2x5IGNvdWxkIGJlIGEgc2VwYXJhdGUgdG9waWMsIGFzIHdl
IGNhbg0KPiBkbyBtYW55IHRoaW5ncyBpbiBhbiBhc3luYyBtYW5uZXLigJRzaW1pbGFyIHRvIHBy
b3Bvc2FscyBmb3INCj4gYXN5bmNocm9ub3VzIGNvbXByZXNzaW9uLiBUaGVzZSBhc3luYyBhcHBy
b2FjaGVzIG1heSBpbXByb3ZlDQo+IHBlcmZvcm1hbmNlLCBidXQgdGhleSBhbHNvIGFkZCBjb21w
bGV4aXR54oCUZm9yIGV4YW1wbGUsIG1hbmFnaW5nDQo+IENQVSB1dGlsaXphdGlvbiBvZiByZWNs
YW1hdGlvbiB0aHJlYWRzIHRvIHByZXZlbnQgZGV2aWNlcyBmcm9tDQo+IG92ZXJoZWF0aW5nLg0K
PiANCg0KQXN5bmNocm9ub3VzbHkgcmVjbGFtYXRpb24gY291bGQgaW5kZWVkIGhlbHAod2hlbiBz
d2FwIGlzIGVuYWJsZWQpLg0KV2UgaGF2ZSBhbHNvIHNhdyBzb21lIGltcHJvdmVtZW50cyB3aXRo
IGEgc2ltaWxhciBhcHByb2FjaCBpbg0KQW5kcm9pZCB3b3JrbG9hZHMuIEFzeW5jIGFnaW5nIG1h
a2VzIHN3YXBwaW5lc3MgbW9yZSBlZmZlY3RpdmUNCnNvIHRoYXQgbW9yZSBhbm9ueW1vdXMgcGFn
ZXMgZXZlbnR1YWxseSBiZWNvbWUgcmVjbGFpbWFibGUuDQoNClNpbWlsYXIgdG8gYXN5bmMgYWdp
bmcsIGdpdmluZyBhZ2luZyBtb3JlIG9wcG9ydHVuaXRpZXMgbWF5IGFsc28gaGVscC4NCkZvciBl
eGFtcGxlLCBpbiBzaG91bGRfcnVuX2FnaW5nKCksIHJldHVybiB0cnVlIHdoZW4NCkV2aWN0YWJs
ZSBwYWdlcyA8IE1JTl9MUlVfQkFUQ0guDQpJIGhhdmVuJ3QgdGVzdGVkIHRoaXMgeWV0IGJ1dCBw
bGFuIHRvIHRyeSBpdC4NCg0KPiA+DQo+ID4gVGhlbiwgd2Ugc3RhcnQgdGhlIGFnaW5nIHdoZW4g
ZXZlciB0aGVyZSBpcyBsZXNzIHRoYW4gNCBnZW5zLCBhbmQNCj4gPiBhbGxvdyByZWNsYWltIHRv
IGFsd2F5cyBnbyBvbiBldmVuIGlmIHRoZXJlIGlzIG9ubHkgMiBnZW5zIGxlZnQuDQo+IA0KPiBJ
IGRvbuKAmXQgdGhpbmsgYWxsb3dpbmcgcmVjbGFtYXRpb24gd2l0aCB0d28gZ2VuZXJhdGlvbnMg
bGVmdA0KPiB3aWxsIHJlc29sdmUgdGhlIHByb2JsZW0uIFRoZSBmdW5kYW1lbnRhbCBpc3N1ZSB3
aXRoIHNoYXJpbmcgdGhlDQo+IHNhbWUgZ2VuZXJhdGlvbnMgZm9yIGZpbGUgYW5kIGFub24gaXMg
dGhhdCBvbmUgdHlwZSBtdXN0IGNhdGNoDQo+IHVwIHdpdGggdGhlIG90aGVy4oCUZWl0aGVyIHRo
cm91Z2ggcmVjbGFtYXRpb24gb3IgdmlhIHdoYXQgdGhpcw0KPiBwYXRjaCBpcyAoYWRtaXR0ZWRs
eSkgZG9pbmcgYXMgYSB3b3JrYXJvdW5kLiBJZiB3ZSBoYXZlIHRvIGdvDQo+IHRocm91Z2ggcmVj
bGFtYXRpb24sIHRoYXQgZWZmZWN0aXZlbHkgbWFrZXMgc3dhcHBpbmVzcyBpbnZhbGlkDQo+IGFn
YWluLg0KPiANCj4gQWxsb3dpbmcgcmVjbGFtYXRpb24gd2l0aCB0d28gZ2VuZXJhdGlvbnMgbWF5
IGxldCBvbmUgdHlwZSBtb3ZlDQo+IGFoZWFkIGJyaWVmbHksIGJ1dCBvdmVyIGEgc21vb3RoZWQg
dGltZSB3aW5kb3cgdGhlcmUgaXMgbm8gcmVhbA0KPiBkaWZmZXJlbmNlLCBhcyB0aGUgb3RoZXIg
dHlwZSBzdGlsbCBoYXMgdG8gY2F0Y2ggdXAgd2l0aCB0aGUgb25lDQo+IHRoYXQgaGFzIGZld2Vy
IGdlbmVyYXRpb25zIGxlZnQuDQo+IA0KDQpUaGF0IGlzIHRydWUuDQoNCkluIHNvbWUgcHJldmlv
dXMgZXhwZXJpbWVudHMgb24gQW5kcm9pZCB3ZSBvYnNlcnZlZCB0aGF0IHdoZW4gdGFza3MNCmFy
ZSAqZnJvemVuKiBhbmQgYWdpbmcgaXMgdHJpZ2dlcmVkIHZpYSB0aGUgZGVidWdmcyBpbnRlcmZh
Y2UsIHBhZ2VzIG1heQ0KZ3JhZHVhbGx5IGFjY3VtdWxhdGUgaW50byBhIHNpbmdsZSBnZW5lcmF0
aW9uLiBJbiB0aGF0IHN0YXRlIHRoZSBNR0xSVQ0KcmVjbGFpbSBwYXR0ZXJuIGNvbnRyb2xsZWQg
Ynkgc3dhcHBpbmVzcyBiZWNvbWVzIHZlcnkgc2ltaWxhciB0bw0KY2xhc3NpYyBMUlUgcmVjbGFp
bS4NCg0KPiA+DQo+ID4gVGhlIHBlcmZvcm1hbmNlIHdvdWxkIGJlIGJldHRlciBzaW5jZSB0aGUg
aXMgbm8gbW9yZSBibG9ja2luZw0KPiA+IG9uIGFnaW5nLCBubyBjaGFuZ2UgdG8gZXhpc3Rpbmcg
bW9kZWwsIGFuZCB0aGUgY2hhbmdlIHNob3VsZA0KPiA+IGJlIHNtYWxsZXIgYW5kIGVhc2llciB0
byByZXZpZXcgSUlVQy4NCj4gPg0KPiA+IE9uZSBjb25jZXJuaW5nIHBhcnQgaXMgZG9pbmcgcmVj
bGFpbSB3aGlsZSBvbmx5IGhhdmluZyAyIGdlbnMgbGVmdC4NCj4gPiBJIHRoaW5rIGl0IHNlZW1z
IE9LLiBJdCBzaG91bGQgYmUgcmFyZSBhcyAzIGdlbnMgYWN0IGFzIGEgYnVmZmVyDQo+ID4gYWxy
ZWFkeSwgaGF2aW5nIG9ubHkgMiBnZW5zIGxlZnQgbWVhbnMgdGhlIGFzeW5jIGFnaW5nIGNhbid0
IGNhdGNoDQo+ID4gdXAgYW5kIHN5c3RlbSBpcyB1bmRlciBleHRyZW1lIHByZXNzdXJlIHNvIGl0
J3MgdW5saWtlbHkgdGhlIGZvbGlvcw0KPiA+IHdpbGwgZ2V0IGFjY2VzcyBlbm91Z2ggdGltZXMg
dG8gZ2V0IG1lYW5pbmdmdWwgaGVhdCBpbmZvLCBhbmQNCj4gPiByZWZhdWx0IHdpbGwgYmUgbW9y
ZSBtZWFuaW5nZnVsIGhlbHAgdG8gc29ydGluZyBvdXQgdGhlIHdvcmtpbmdzZXQ6DQo+ID4NCj4g
PiBodHRwczovL2x3bi5uZXQvQXJ0aWNsZXMvOTQ1MjY2Lw0KPiA+DQo+ID4gQ2dyb3VwIHJlY2xh
aW0gY2FuIGRvIHNvbWUgdGhyb3R0bGluZyBvbiB0aGF0IHRvbywgYW5kIGtzd2FwZCBjYW4NCj4g
PiBzdGlsbCBkbyBhZ2luZyBzeW5jaHJvbmljYWxseS4NCj4gPg0KPiA+IEp1c3Qgc29tZSBpZGVh
cywgd2UgbWF5IG5lZWQgdG8gZG8gc29tZSB0ZXN0IGFuZCBiZW5jaG1hcmsNCj4gPiB0byBmaWd1
cmUgb3V0IHdoaWNoIGlzIHRoZSBiZXN0IHNvbHV0aW9uLiBEaXNjdXNzaW9uDQo+ID4gaXMgd2Vs
Y29tZWQhIDpEDQo+IA0KPiBNYXliZSB3ZSBjYW4gc3RpbGwgZmluZCBhIHdheSB0byBhZGRyZXNz
IHRoZSBjb25jZXJucyB5b3UgcmFpc2VkDQo+IGFib3ZlLCBhcyB3ZWxsIGFzIFRUTOKAlGZvciBl
eGFtcGxlLCBieSB1c2luZyBzZXBhcmF0ZSB0aW1lc3RhbXBzDQo+IGZvciBhbm9uIGFuZCBmaWxl
IHBhZ2VzLg0KPiANCj4gVGhhbmtzDQo+IEJhcnJ5DQoNCkJlc3QsDQpaaWNoZW5nDQo=


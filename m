Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 589C6D3B7E5
	for <linux-mm@archiver.kernel.org>; Mon, 29 Dec 2025 04:01:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 99DDE6B0088; Sun, 28 Dec 2025 23:01:54 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 954B06B0089; Sun, 28 Dec 2025 23:01:54 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8814B6B008A; Sun, 28 Dec 2025 23:01:54 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 7A9156B0088
	for <linux-mm@kvack.org>; Sun, 28 Dec 2025 23:01:54 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 25C24BB0AB
	for <linux-mm@kvack.org>; Mon, 29 Dec 2025 04:01:54 +0000 (UTC)
X-FDA: 84271160148.25.4E024AF
Received: from mta20.hihonor.com (mta20.honor.com [81.70.206.69])
	by imf26.hostedemail.com (Postfix) with ESMTP id 2803614000B
	for <linux-mm@kvack.org>; Mon, 29 Dec 2025 04:01:50 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=none;
	spf=pass (imf26.hostedemail.com: domain of yuanlinyu@honor.com designates 81.70.206.69 as permitted sender) smtp.mailfrom=yuanlinyu@honor.com;
	dmarc=pass (policy=none) header.from=honor.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766980912;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=rojuF6qs0MzToAaFXa+KuXKawYXFL2AL5udxghRv4cg=;
	b=Dcoq7n1bQZqAbxJoy3bYwFrBT9gWJ40F9AunhuM7wSr2WacY2hHZ2hJmj7hZ6nEbxvEf34
	M2e8s6TK7HgdWpNUGDpum9Yyt5pncagxOSpEyL+5VnwTs1pbRWzqUCDc6H8CvjbgALZlgV
	K7O0UPHeINAQXhrajaqFPC4e/EIUK6A=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766980912; a=rsa-sha256;
	cv=none;
	b=5KNIVz2r6EXEmwex3PaXXTCCh6zKY3gBijYncfvhofonOijHX9jnJ8Kpb6XMATohgf+tj8
	FzgGx5Bq4Kbkgd2PyOdbUQgVcLOs9lTFr4Yw/HNtMxH/VQN18u1otHf6qVlQNDO7EJT/9o
	G06JaXLZ/mlHqLcurQmKpWNihualsxk=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=none;
	spf=pass (imf26.hostedemail.com: domain of yuanlinyu@honor.com designates 81.70.206.69 as permitted sender) smtp.mailfrom=yuanlinyu@honor.com;
	dmarc=pass (policy=none) header.from=honor.com
Received: from w003.hihonor.com (unknown [10.68.17.88])
	by mta20.hihonor.com (SkyGuard) with ESMTPS id 4dfjBy5jppzYlJgm;
	Mon, 29 Dec 2025 11:59:06 +0800 (CST)
Received: from w025.hihonor.com (10.68.28.69) by w003.hihonor.com
 (10.68.17.88) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.27; Mon, 29 Dec
 2025 12:01:46 +0800
Received: from w025.hihonor.com (10.68.28.69) by w025.hihonor.com
 (10.68.28.69) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.27; Mon, 29 Dec
 2025 12:01:45 +0800
Received: from w025.hihonor.com ([fe80::5a3b:9b85:bbde:73b9]) by
 w025.hihonor.com ([fe80::5a3b:9b85:bbde:73b9%14]) with mapi id
 15.02.2562.027; Mon, 29 Dec 2025 12:01:45 +0800
From: yuanlinyu <yuanlinyu@honor.com>
To: Marco Elver <elver@google.com>
CC: Alexander Potapenko <glider@google.com>, Dmitry Vyukov
	<dvyukov@google.com>, Andrew Morton <akpm@linux-foundation.org>, Huacai Chen
	<chenhuacai@kernel.org>, WANG Xuerui <kernel@xen0n.name>,
	"kasan-dev@googlegroups.com" <kasan-dev@googlegroups.com>,
	"linux-mm@kvack.org" <linux-mm@kvack.org>, "loongarch@lists.linux.dev"
	<loongarch@lists.linux.dev>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v2 2/2] kfence: allow change number of object by early
 parameter
Thread-Topic: [PATCH v2 2/2] kfence: allow change number of object by early
 parameter
Thread-Index: AQHcb+kJOevioCwokUWRSuHGy2xym7UmkpaAgACVZ/D//4LNgIARZBYw
Date: Mon, 29 Dec 2025 04:01:45 +0000
Message-ID: <2ff11f959e78405088865c6d61535bfc@honor.com>
References: <20251218063916.1433615-1-yuanlinyu@honor.com>
 <20251218063916.1433615-3-yuanlinyu@honor.com>
 <aUPB18Xeh1BhF9GS@elver.google.com>
 <7334df3287534327a3e4a09c5c8d9432@honor.com>
 <CANpmjNMmiXjifpc9LdCVi5jzzKU3sgb0iJn7P7TMFMNqDH7TbA@mail.gmail.com>
In-Reply-To: <CANpmjNMmiXjifpc9LdCVi5jzzKU3sgb0iJn7P7TMFMNqDH7TbA@mail.gmail.com>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-originating-ip: [10.165.1.160]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-Stat-Signature: dzatnje8kzggqemdkgw545qbnww1ntf3
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 2803614000B
X-Rspam-User: 
X-HE-Tag: 1766980910-276610
X-HE-Meta: U2FsdGVkX1+9K7cJ50QapG+JOQ4BO4JQ1XQoAzUpXslKV0IYycf8ibTFW4nPkACoVVQvrgSzZWUxde63cBG+1pW9ApfJOppVcrJM++Zoi/UDimwePNBRptuv0y9WDG31S7tM6gxUh6D06vEo37Ixs0q5lz6KB+emjMV63MkrPWsYiPJcfbJgyOZ2QTDliYRgiuN1GTFmhhIC9ruitj5Wwi7AGnrfG1wHuEB7soCOoZo0TZv8fJTRhPZ4ZelybM2dhiIbKisNp3v0qZuHMWnQo9zRv299NQfd16e7nj72CXpiaB22DjXkZqPXwq+BVbjVHuw4hWepURBIK+YGVDfnnUKum74NeC9m1f7Hh0DWQ/vWbBH7Wdb3/IRlZZgBIOus6FXNiqTipIMFPBU2FuqMPaEx1K8oGGIe/3rPQI1CHr4iCleaoi5IcNBbDIn2vkBFIwL/+8QecX/vqmxM6sbEY6MpLax4XoD0HsKmP85CqmZRuJ7UgMtNS4aHiGNALJWAHqW6wqwh78mIIpQbb3BBB4QI3wfIgDpK0hiG1Bf8sZEc0TqNVDloNwh1MRrDBRI+iGeeiNNQVm5eItEtHWQTP4MV2ZzscPLwQEpzGDxVr5CH+hkGRHde5NwFNhsG+iFv/pNy0xlbkMaso18ynsZ6ckKeJWxo1gvfgHB9uHWHb32k5hldNiOiuL/tywPWGV3+RnBpS1enLaNiE+YD0K5l/KXyYsFIWW/POplCs/94akSU3QeN6sf6G/gO8sCbzkt45IMJ2ulyNEgJw4RElV+jfCCEBMMT+lDVkQM3h4/bA8ep8aglq5y1SZeMIzbpV5cQVYXMzMzjHNNvCcSATft1DmpmBshyIaM/KqjlOx5I6+BUl1xtWl1ukpNC4wvSQcyMe6T3NA7jX6lbH2/7C339e1f/POWMlQ8whipbfVWT301z+dJ/rwt1mlEkK4q3LvSlWlLRleH8Bwr86XWA4OU
 wAkSO7Tf
 DegW0OCWng81L4GkS94PcMAfUeRW20sP60V+ntk+o7k2JyY7QxkbJBodhOmKDvJNvT6T9I4f7thN9PkTFItopWx3zdygDYlZEaOKvriWECjoEtdlvGRxL8vFNgc4wYXYKeurbUEwcD9u9YZk5Di7IQP6fqDhIfhxBPdu51SB+MEmNxa92ml5wu/Gh3rojHLmLC5zYEjWkCgF1tK78nU/1sNKHytesrwZYO9eY4j9E73SG7wh+PWJU0GXurEuinJTJsPW41+VHPnKxMTaT9XjkZtU0rPJRkrn7yKmwJOH6pgl88/bHZ26L9ZBYwfW1396pP4RgaUDdQSYFP8I5Y04DrXUZvhMn+/4PLyleswxaYHKUGvLGx+wKnbK8d0RgIu5mws3S3eGxbrufbQ/fhX/VZy+no/UmAvdZG+vBXmYB8PDsVnQTAaJaifBqO8xWoBl627muDtGCSIKWdgEhcMxC3WwVFlaFQ1jfEwdPglsmUj3ccdi1y59T+YHOgAe3Zh0gUDH9dbz8aPXXEcd1KsYGeOJoS7J7WIzw1Bq9gqN0biqf18xt59iLDdwYxZ9DODnoKXmXlab7vomnUoTZ3nimq4VoXlSWLsGsxCDHp+CLYvSOZAtMU7QrBJMtPg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

PiBGcm9tOiBNYXJjbyBFbHZlciA8ZWx2ZXJAZ29vZ2xlLmNvbT4NCj4gU2VudDogVGh1cnNkYXks
IERlY2VtYmVyIDE4LCAyMDI1IDY6MjQgUE0NCj4gVG86IHl1YW5saW55dSA8eXVhbmxpbnl1QGhv
bm9yLmNvbT4NCj4gQ2M6IEFsZXhhbmRlciBQb3RhcGVua28gPGdsaWRlckBnb29nbGUuY29tPjsg
RG1pdHJ5IFZ5dWtvdg0KPiA8ZHZ5dWtvdkBnb29nbGUuY29tPjsgQW5kcmV3IE1vcnRvbiA8YWtw
bUBsaW51eC1mb3VuZGF0aW9uLm9yZz47DQo+IEh1YWNhaSBDaGVuIDxjaGVuaHVhY2FpQGtlcm5l
bC5vcmc+OyBXQU5HIFh1ZXJ1aSA8a2VybmVsQHhlbjBuLm5hbWU+Ow0KPiBrYXNhbi1kZXZAZ29v
Z2xlZ3JvdXBzLmNvbTsgbGludXgtbW1Aa3ZhY2sub3JnOyBsb29uZ2FyY2hAbGlzdHMubGludXgu
ZGV2Ow0KPiBsaW51eC1rZXJuZWxAdmdlci5rZXJuZWwub3JnDQo+IFN1YmplY3Q6IFJlOiBbUEFU
Q0ggdjIgMi8yXSBrZmVuY2U6IGFsbG93IGNoYW5nZSBudW1iZXIgb2Ygb2JqZWN0IGJ5IGVhcmx5
DQo+IHBhcmFtZXRlcg0KDQoNCj4gPiBDb3VsZCB5b3Ugc2hhcmUgdGhlIGJldHRlciBkZXNpZ24g
aWRlYSA/DQo+IA0KPiBIb3QtcGF0Y2hhYmxlIGNvbnN0YW50cywgc2ltaWxhciB0byBzdGF0aWMg
YnJhbmNoZXMvanVtcCBsYWJlbHMuIFRoaXMNCj4gaGFkIGJlZW4gZGlzY3Vzc2VkIGluIHRoZSBw
YXN0IChjYW4ndCBmaW5kIHRoZSBsaW5rIG5vdyksIGJ1dCBpdCdzIG5vdA0KPiB0cml2aWFsIHRv
IGltcGxlbWVudCB1bmZvcnR1bmF0ZWx5Lg0KPiANCg0KSGkgTWFyY28sDQoNCklmIHlvdSBoYXZl
IGNvbmNlcm4gYWJvdXQgb25lIG1vcmUgZ2xvYmFsLCANCg0KaG93IGFib3V0IGJlbG93IGNvZGUg
Pw0KDQovKiBUaGUgcG9vbCBvZiBwYWdlcyB1c2VkIGZvciBndWFyZCBwYWdlcyBhbmQgb2JqZWN0
cyB3aXRoIG51bWJlciBvZiBvYmplY3RzIGF0IGxvd2VyIGJpdHMgLiAqLw0KdW5zaWduZWQgbG9u
ZyBfX2tmZW5jZV9wb29sX29iamVjdHMgX19yZWFkX21vc3RseTsNCg0Kc3RhdGljIF9fYWx3YXlz
X2lubGluZSBib29sIGlzX2tmZW5jZV9hZGRyZXNzKGNvbnN0IHZvaWQgKmFkZHIpDQp7DQoJcmV0
dXJuIHVubGlrZWx5KCh1bnNpZ25lZCBsb25nKSgoY2hhciAqKWFkZHIgLSBLRkVOQ0VfUE9PTF9B
RERSKSA8IEtGRU5DRV9QT09MX0xFTiAmJiBfX2tmZW5jZV9wb29sX29iamVjdHMpOw0KfQ0KDQpJ
dCBtYXkgZ2VuZXJhdGUgb25lIG9yIHR3byBtb3JlIGluc3RydWN0aW9uIHdoZW4gY29tcGFyZSB3
aXRoIG9yaWdpbmFsIHBhdGNoLg0KDQoNCg==


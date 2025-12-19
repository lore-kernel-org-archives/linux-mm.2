Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B40A9D7494F
	for <linux-mm@archiver.kernel.org>; Fri, 19 Dec 2025 04:36:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DFF886B0088; Thu, 18 Dec 2025 23:36:13 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DACFF6B0089; Thu, 18 Dec 2025 23:36:13 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CBAF86B008A; Thu, 18 Dec 2025 23:36:13 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id B741D6B0088
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 23:36:13 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 33D88B9586
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 04:36:13 +0000 (UTC)
X-FDA: 84234958626.15.7E099B9
Received: from mta20.hihonor.com (mta20.hihonor.com [81.70.206.69])
	by imf17.hostedemail.com (Postfix) with ESMTP id 168AC40004
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 04:36:08 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=honor.com;
	spf=pass (imf17.hostedemail.com: domain of yuanlinyu@honor.com designates 81.70.206.69 as permitted sender) smtp.mailfrom=yuanlinyu@honor.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766118971; a=rsa-sha256;
	cv=none;
	b=rV9zCfTQtx+DR7VAu31oSRKaPzgwE7rJyu3pQ5zwSVppK2hsDI2c8YI1f+81WEukXOltzn
	WyVs4j7V9QIRFbBykYAQfmaEfQkuiQTCp/4AdbzKeYoXp7ALg2/rO/mRso3YI+uBkOD83C
	7nUiK9QnKoI8Ca562iT3n+98p+ganPE=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=honor.com;
	spf=pass (imf17.hostedemail.com: domain of yuanlinyu@honor.com designates 81.70.206.69 as permitted sender) smtp.mailfrom=yuanlinyu@honor.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766118971;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=TBeoBMXlMEVhwhMkEcXIUeqtkasMEWs5iVpIxMFXugQ=;
	b=YwROfJGzL58xc7UbCbqYT1Eg1q3f8dECpp4ROr2sZzftcyzNykK5b8rFkC6iqYqjjmkFXS
	OQg8uLiYvFat4LzzNPXNPPC9O3GK8kU90ablZPNlSpPyuBngaTGD89hgLOJ6ocEF0Lj5uz
	oqISl4TDo6RteQcwNt6Jb26OPnW+EbU=
Received: from w012.hihonor.com (unknown [10.68.27.189])
	by mta20.hihonor.com (SkyGuard) with ESMTPS id 4dXZRC3cNKzYlLgM;
	Fri, 19 Dec 2025 12:33:27 +0800 (CST)
Received: from w022.hihonor.com (10.68.16.247) by w012.hihonor.com
 (10.68.27.189) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.27; Fri, 19 Dec
 2025 12:36:01 +0800
Received: from w025.hihonor.com (10.68.28.69) by w022.hihonor.com
 (10.68.16.247) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.27; Fri, 19 Dec
 2025 12:36:01 +0800
Received: from w025.hihonor.com ([fe80::5a3b:9b85:bbde:73b9]) by
 w025.hihonor.com ([fe80::5a3b:9b85:bbde:73b9%14]) with mapi id
 15.02.2562.027; Fri, 19 Dec 2025 12:36:01 +0800
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
Thread-Index: AQHcb+kJOevioCwokUWRSuHGy2xym7UmkpaAgACVZ/D//4LNgIABtVUA
Date: Fri, 19 Dec 2025 04:36:01 +0000
Message-ID: <a5937489d22f450eaecca610d8aef6c9@honor.com>
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
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 168AC40004
X-Stat-Signature: chjqh33zm9qkxpjiktdgk77fhafpyz8y
X-HE-Tag: 1766118968-569838
X-HE-Meta: U2FsdGVkX1/FsYkAhULtG+ndf0MFdLmk2G2/LQsujY01hEZWGevKRtabNfrEHEaJbc53owGDrGOaru9lo/jnh46CkRaIJe5Z1Kgj0rLIukUSETTf2f/oWIQazaoavmF3MpUzSEmHGVz/C2zDgW1sFDZ8hzuJzpvZLp4/eai6iddWHqoq3p4Ktpq4DCujZwCTT5yMfM0UnneatgeoPlR4oxwrlDi8UydciuYbdzyLoV1hdBxCk+A47ThXOqy3u2HmurWZ12xP4SZ/dVEgUvqRlFXfVMg/OjIWMh8b4gSbSe4rL8lzO5hn9NxTTl4ZlaJUbftd9ueccHCxZ1CveHgFYQ9JfqB6tOjtk/PqRgxvjz6C32SFkHel1g+ilGCsnxAyfhWyjvmHsRV+tqo3pHbG8fcPnGraalgRJauJvlayIPOBs/D3yIpUVwdcMe/OWPOhBFOeK7CsAY14GMBzyg391PiAOUdrkpMVTc5Pkf6Q0jM1g6O0A5QtSmxZcIh6yq9XOKbYIfOK0q45k2WraxOa1GhG8Lcne1wiceFhneBLaolTyVavFA3xH0lVl1E05PeTl3pjG0K1VA45HxXcU5Y8ROfp60vv69+bZoCIs+z9KohhQBv3L59bPVeDLB6R/VjvqoMGf4zDZApk10hKGmPWbulIRxTom5VS68i3pGUL98tjsBMZHJOIwpDzCcpvp/776eCMqI3WKGgUCa/+s0VbfkUx2q95E+kDmwFY/Bpg+rz2zZY9fO6TUjc9wPsEQnNGYfQyeqFR0YZEkZhekP0TdaAHDJc7/O0DDV6EXa2Ev4QXDoCjWEHn/ucSRDQO9TmoHY8ZOMmyIUyB8cCTb+Vr9bgm3LlJ538PXr1sqZgBJ6uCt7tXiPsRgwEVNMhXEXnR1N+lzNPfD0f3i+KS3L8Nv1oZ8y9NOZfKKUNqxJnhDP4Cs7d069x9gTfPrGi34eKttXwHDN8cckhrxoeXLKQ
 5IEB3AZe
 pk2ZTpghV1G5RPro+O7+fWU1/VMc5vTYYQiGXSU2XmXCLZ/DstJCP/n+za6rG7h/K6pE5Q2ehTOb3BqnIEa6WMKAsVP4h7c6mrTF3IzxKX+qs5QYsF+Cld7a06HUy0g0lVqic4I9TMxLuiRqo/o4xSh4cU3bTDayNGwVawJdL2xviXaBL1Nfw24UzdgzlTmAT+2GpGJow8KNBhTor098hsJiitdSa2SixCzahWcYwAny490kwMXUZNVO6ti+Wi0O+ArtI1Pp+fLgZyLhMJ3gVoQhAHhfzQHVgWku40CCcgDCBKY7Fj9EsI1k3E4xcOSI3/yFRpy38Ex+Pjer/1fOcq+G6tw/DROPR8I/7NxJMTDp7euKWRsn+VXmrj7R+hQjtPjgptOtgKCCnVZ5X3qskWXQ64SpGw7tCGeoYBO1gee7DGafFke3hx6qHT1CNYV4JEwCdqynZ0GKPQM07nfIKFQb5ukLqvgB8L+v2jR+scvG6WA0M0KTTXs9I2PVYz72WIXn0npt2TlXAGQxaG3BCEB65fS5V4TNBVvW/Pd8ga+zlTTO+sCeajy1+WQ4bEfy5iZCEhIRTN4Lf8xAU8ngceVIlkKaZzLS74dq+Va6ZRlGin3rvfJz50rTfryRZKf1BBNj6ldvPzmjOGADNptf2WeFyRo13FUHg1ykw9gnai0Osg9fRsdiBN46E+swxQ4fp7TzhuGTofHtDjfE=
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
DQo+IHBhcmFtZXRlcg0KPiANCj4gT24gVGh1LCAxOCBEZWMgMjAyNSBhdCAxMToxOCwgeXVhbmxp
bnl1IDx5dWFubGlueXVAaG9ub3IuY29tPiB3cm90ZToNCj4gPg0KPiA+ID4gRnJvbTogTWFyY28g
RWx2ZXIgPGVsdmVyQGdvb2dsZS5jb20+DQo+ID4gRG8geW91IG1lYW4gcGVyZm9ybWFuY2UgY3Jp
dGljYWwgYnkgYWNjZXNzIGdsb2JhbCBkYXRhID8NCj4gPiBJdCBhbHJlYWR5IGFjY2VzcyBfX2tm
ZW5jZV9wb29sIGdsb2JhbCBkYXRhLg0KPiA+IEFkZCBvbmUgbW9yZSBnbG9iYWwgZGF0YSBhY2Nl
cHRhYmxlIGhlcmUgPw0KPiA+DQo+ID4gT3RoZXIgcGxhY2UgbWF5IGFjY2VzcyBnbG9iYWwgZGF0
YSBpbmRlZWQgPw0KPiANCj4gaXNfa2ZlbmNlX2FkZHJlc3MoKSBpcyB1c2VkIGluIHRoZSBzbHVi
IGZhc3QgcGF0aCwgYW5kIGFub3RoZXIgbG9hZCBpcw0KPiBvbmUgbW9yZSBpbnN0cnVjdGlvbiBp
biB0aGUgZmFzdCBwYXRoLiBXZSBoYXZlIGF2b2lkZWQgdGhpcyB0aHVzIGZhcg0KPiBmb3IgdGhp
cyByZWFzb24uDQo+IA0KPiA+IEkgZG9uJ3Qga25vdyBpZiBhbGwgbGludXggcmVsZWFzZSBsaWtl
IHVidW50dSBlbmFibGUga2ZlbmNlIG9yIG5vdC4NCj4gPiBJIG9ubHkga25vdyBpdCB0dXJuIG9u
IGRlZmF1bHQgb24gYW5kcm9pZCBkZXZpY2UuDQo+IA0KPiBUaGlzIGlzIGlycmVsZXZhbnQuDQo+
IA0KPiA+ID4gV2hpbGUgSSB0aGluayB0aGUgY2hhbmdlIGl0c2VsZiB3b3VsZCBiZSB1c2VmdWwg
dG8gaGF2ZSBldmVudHVhbGx5LCBhDQo+ID4gPiBiZXR0ZXIgZGVzaWduIG1pZ2h0IGJlIG5lZWRl
ZC4gSXQncyB1bmNsZWFyIHRvIG1lIHdoYXQgdGhlIHBlcmYgaW1wYWN0DQo+ID4NCj4gPiBDb3Vs
ZCB5b3Ugc2hhcmUgdGhlIGJldHRlciBkZXNpZ24gaWRlYSA/DQo+IA0KPiBIb3QtcGF0Y2hhYmxl
IGNvbnN0YW50cywgc2ltaWxhciB0byBzdGF0aWMgYnJhbmNoZXMvanVtcCBsYWJlbHMuIFRoaXMN
Cj4gaGFkIGJlZW4gZGlzY3Vzc2VkIGluIHRoZSBwYXN0IChjYW4ndCBmaW5kIHRoZSBsaW5rIG5v
dyksIGJ1dCBpdCdzIG5vdA0KPiB0cml2aWFsIHRvIGltcGxlbWVudCB1bmZvcnR1bmF0ZWx5Lg0K
DQppcyBpdCBwb3NzaWJsZSBhZGQgdGFnIHRvIGtmZW5jZSBhZGRyZXNzIGFuZCBvbmx5IGNoZWNr
IGFkZHJlc3MgaXRzZWxmID8NCg0KPiANCj4gQW4gb3B0aW9uIHRoYXQgd291bGQgZW5hYmxlL2Rp
c2FibGUgdGhlIGNvbW1hbmQtbGluZSBjaGFuZ2VhYmxlIG51bWJlcg0KPiBvZiBvYmplY3RzLCBp
LmUgb25lIHZlcnNpb24gdGhhdCBhdm9pZHMgdGhlIGxvYWQgaW4gdGhlIGZhc3QgcGF0aCBhbmQN
Cj4gb25lIHZlcnNpb24gdGhhdCBlbmFibGVzIGFsbCB0aGUgYml0cyB0aGF0IHlvdSBhZGRlZCBo
ZXJlLiBCdXQgSSdkDQo+IHJhdGhlciBhdm9pZCB0aGlzIGlmIHBvc3NpYmxlLg0KDQpZZXMsIGl0
IHNob3VsZCBhdm9pZCwgdGhlIHB1cnBvc2UgaXMgd2l0aG91dCBjb21waWxlIHRoZSBrZXJuZWwu
DQoNCj4gDQo+IEFzIHN1Y2gsIHBsZWFzZSBkbyBiZW5jaG1hcmsgYW5kIGFuYWx5emUgdGhlIGdl
bmVyYXRlZCBjb2RlIGluIHRoZQ0KPiBhbGxvY2F0b3IgZmFzdCBwYXRoICh5b3Ugc2hvdWxkIHNl
ZSBhIGxvYWQgdG8gdGhlIG5ldyBnbG9iYWwgeW91DQo+IGFkZGVkKS4gbGx2bS1tY2EgWzFdIG1p
Z2h0IGhlbHAgeW91IHdpdGggYW5hbHlzaXMuDQo+IA0KPiBbMV0gaHR0cHM6Ly9sbHZtLm9yZy9k
b2NzL0NvbW1hbmRHdWlkZS9sbHZtLW1jYS5odG1sDQoNClRoYW5rcywgd2lsbCBsZWFybiBpdA0K
DQo=


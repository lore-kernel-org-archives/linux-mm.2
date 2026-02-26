Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6DDFFFCE074
	for <linux-mm@archiver.kernel.org>; Thu, 26 Feb 2026 13:06:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8B5746B0005; Thu, 26 Feb 2026 08:06:22 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 896B36B0089; Thu, 26 Feb 2026 08:06:22 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7C0096B008A; Thu, 26 Feb 2026 08:06:22 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 685926B0005
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 08:06:22 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 1FFEE55F38
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 13:06:22 +0000 (UTC)
X-FDA: 84486631404.02.763EFAD
Received: from mta21.hihonor.com (mta21.honor.com [81.70.160.142])
	by imf14.hostedemail.com (Postfix) with ESMTP id 704E8100014
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 13:06:19 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=honor.com;
	spf=pass (imf14.hostedemail.com: domain of wangzicheng@honor.com designates 81.70.160.142 as permitted sender) smtp.mailfrom=wangzicheng@honor.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772111180;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=h1nIKrqhG2XNbLVqQIbEmHgSnvWcgHzz5Au9PtQRLFM=;
	b=Qzh7BSTdI81Gyi9T08XGglq8s4kgXMBbvD5ikRLuB67iOgY9DkaJvqRfleV3muz8yyRbcj
	F1Q9YHo763hmDNxSJ8r/U10qNCzzO0zzrKSkIX6NWjMBe3oFqOPZsAPTzODl8OP4k75PRv
	HuN9vcWrZgn9W+0GUMgVciDBkvuEjEk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772111180; a=rsa-sha256;
	cv=none;
	b=RaehSfUVTCT9pcrznYbIupYTtjQ58hRN7iDGI9kxpv6eDMC3femZN0JDKK6zGlvKi43qEg
	V+jrXvLyAf1giUhsipNXXYOXdSYyp+tWRJYGBK0Utwww49ipd3fTmG9xJKfPk/TAVqP7NM
	sN7FbjoEY5pBNrQeS8siAnlF+15mWFU=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=honor.com;
	spf=pass (imf14.hostedemail.com: domain of wangzicheng@honor.com designates 81.70.160.142 as permitted sender) smtp.mailfrom=wangzicheng@honor.com
Received: from w013.hihonor.com (unknown [10.68.26.19])
	by mta21.hihonor.com (SkyGuard) with ESMTPS id 4fMBT00hdQzYlKcg;
	Thu, 26 Feb 2026 21:02:44 +0800 (CST)
Received: from a006.hihonor.com (10.68.23.242) by w013.hihonor.com
 (10.68.26.19) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.27; Thu, 26 Feb
 2026 21:06:12 +0800
Received: from w002.hihonor.com (10.68.28.120) by a006.hihonor.com
 (10.68.23.242) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.27; Thu, 26 Feb
 2026 21:06:11 +0800
Received: from w002.hihonor.com ([fe80::ef6f:d9c5:cf75:d4d3]) by
 w002.hihonor.com ([fe80::ef6f:d9c5:cf75:d4d3%14]) with mapi id
 15.02.2562.027; Thu, 26 Feb 2026 21:06:11 +0800
From: wangzicheng <wangzicheng@honor.com>
To: Kalesh Singh <kaleshsingh@google.com>
CC: Suren Baghdasaryan <surenb@google.com>,
	"lsf-pc@lists.linux-foundation.org" <lsf-pc@lists.linux-foundation.org>,
	"linux-mm@kvack.org" <linux-mm@kvack.org>, wangxin 00023513
	<wangxin23@honor.com>, gao xu <gaoxu2@honor.com>, wangtao
	<tao.wangtao@honor.com>, liulu 00013167 <liulu.liu@honor.com>, zhouxiaolong
	<zhouxiaolong9@honor.com>, linkunli <linkunli@honor.com>,
	"kasong@tencent.com" <kasong@tencent.com>, "21cnbao@gmail.com"
	<21cnbao@gmail.com>, "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
	"axelrasmussen@google.com" <axelrasmussen@google.com>, "yuanchu@google.com"
	<yuanchu@google.com>, "weixugc@google.com" <weixugc@google.com>, Randy Dunlap
	<rdunlap@infradead.org>, "Liam.Howlett@oracle.com" <Liam.Howlett@oracle.com>,
	"willy@infradead.org" <willy@infradead.org>, yangxuzhe 00017436
	<yangxuzhe@honor.com>, "T.J. Mercier" <tjmercier@google.com>, android-mm
	<android-mm@google.com>, "ryncsn@gmail.com" <ryncsn@gmail.com>
Subject: RE: [LSF/MM/BPF TOPIC] MGLRU on Android: Real-World Problems and
 Challenges
Thread-Topic: [LSF/MM/BPF TOPIC] MGLRU on Android: Real-World Problems and
 Challenges
Thread-Index: AQHcpbCW9Jb7JciVVEirgKqS2Lh6gbWTO+JQgAB7BoCAAT0bIA==
Date: Thu, 26 Feb 2026 13:06:11 +0000
Message-ID: <586d56f766bf4181b99d6ba8106ebe0e@honor.com>
References: <e5c8b5b9e7574dce8e4d4744595123e2@honor.com>
 <CAJuCfpHzTdwcGh8wXetEcAy-93-WqPmoyDnbC8UhzGttpcm_Cw@mail.gmail.com>
 <e3734e2cfac3403da02213b64af8c5b4@honor.com>
 <CAC_TJveNB_beemBUdJ02tYpTj5c2Po6zQAMRzdFQD5WJKfTacQ@mail.gmail.com>
In-Reply-To: <CAC_TJveNB_beemBUdJ02tYpTj5c2Po6zQAMRzdFQD5WJKfTacQ@mail.gmail.com>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-originating-ip: [10.163.18.229]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-Rspam-User: 
X-Stat-Signature: ogn9wyygmcer4cuz3hy4ago8pbcqsrs8
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 704E8100014
X-HE-Tag: 1772111179-703354
X-HE-Meta: U2FsdGVkX18AghdN5gP+ma0GxXj/Sa8ZUrZ/OiO4zMk6QFMLEa5RUNZGOG2OSnbb8znB+OKm+miviTWduc4nzCbDvJye/ET9WJwO1RlqHnCnxN+gvLjSVL4xuXekHPU2LsXQwMXK4Z64dOttW6+ALWFXsCpi1JWnekYUPi2v881MsrtHBeS1rpKCEegohsXPwyWFTZbj9BJS7fWSkefjySyz+eNgRTPrtDZSKhLxMnpWu49DOPzaivVLJhKDpknL6O4947v7bDT/S//RjOxLbECMD5Nra6ZDcFcEE8DtTEZ689+J7trqDhN4zIRXwJjDo8xV0UwPHKt6T8dETPTJGBFs3f55wuBDv6iC3xKmCzC0Cd7eqnrisjjmS26IWk9XSjkLnu26VNlLw/XMCxFq9ZvzgtOMI/y2fRuZBoGfSF/CWSnsVTG33yU40blibbZnRmY6OYkluIcbLIjgklWJYpVOKS9P2DcCk1KPFVZR2AKIezGv7jZnsely/9jxpC0yCETMR5fgwnQwh2bzVgXrehdlIwunDLJ6K3NN0BHeBj3EOi2vn4VSCtWXLoYQTkuswJhMBqIOtTljVnNFtr5zsqVs+npkoZUqmpCZqzSji0ZvHMnhv6PXFmfzPZUc3J3w1csDVYd1Ue19DTxDYdFPcDc99D1GiF78Q1rLRcQjIYoDXXvLfBKNFBbr0tApsN4LYgsAkwNotZqyiwcljMjaH3cXXP+M4oBoBUcxpP+VLN9QS8GWhiXvEQp7+Pt9wHGKd+7oT84PaB+PxXJFTXbkcb3wDY95MxfKvLpaNHg5VtGlbj7gE6wq5l7vPR7x2c9xbU4eHVpluDXN2vT/utrpADTqun1WVlAbYm1TePtZCcESby3mqBYKycKf40BraN22CfFA5UMkoNNXWF2fjPObzoTLSWu2a7mAAlsBhU6KxV1eywGX4ttz7C7fgqmpsR1xTcdKhCko+lqTZGfhXV7
 2t4ijnYz
 1wH6IXt6uxEb0p/sT8sxk/DkgWtoW+c5tFSj2wwRvjQdJmr0mkOeZ+hVO9nRaWeLWX8Gk8j+i8VTfJjza6M1oupeff86F2WZYkuPTllx+vz3DHCbUaiJ2S8XNYs+DTvtrkzwkr7ZuO/BkupMGlbrFUeJXqpS0OB2Mqw7gVMCqiDrrGL2SU+ERwhtLLotjGAe4TDokxMkMNzavqxuxWA4dSVavvoCdMIzaGYkcEgQ686L+gKlQelUgL4PbHdTo85QQZEAfObMb3isIao6irEtIL6XmM8pjiVDV5tzK7FP+Kp56PS3G7o3C+eHz2klDJ6v3ChPo1ve3NyyPhHXicKzHT8UJg8qGsnh3ZI0ZbCd5M2UogzENsm95hyqsKPIsu50tTlBxPNSc1eTQjaYx9UzBifkyROk5YuenYVsp45oQ2QmbsMLhCfcnym7+EaFTRa+IgeV/+FVuxq5XlkE2+ZZldAPKwH2H2/Jx4GFwARKm/xQcqlsQgFDUYECu0Rl4fRE5CTONzUuATz2kgj3G09doPdqxuA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

PiA+ID4gPg0KPiA+ID4gPiBXZSBhcmUgaGFwcHkgdG8gc2hhcmUgbW9yZSBkZXRhaWxlZCBkYXRh
IGFuZCBleHBlcmltZW50cyBhbmQgdG8gaGVscA0KPiA+ID4gPiB3aXRoIFBvQ3MgYW5kIGxhcmdl
LXNjYWxlIHZhbGlkYXRpb24gaWYgdGhlcmUgaXMgaW50ZXJlc3QgaW4NCj4gPiA+ID4gcHVyc3Vp
bmcgdGhlc2UgZGlyZWN0aW9ucy4NCj4gDQo+IEhpIFppY2hlbmcsDQo+IA0KPiBJIHdvdWxkIGJl
IHZlcnkgaW50ZXJlc3RlZCBpbiBqb2luaW5nIHRoaXMgZGlzY3Vzc2lvbiBhdCBMU0YvTU0gYXMg
d2VsbC4NCj4gDQo+IEkgYWN0dWFsbHkganVzdCByZXBsaWVkIHRvIEthaXJ1aSdzIE1HTFJVIHRo
cmVhZCBub3Rpbmcgc29tZSBzaW1pbGFyDQo+IG9ic2VydmF0aW9ucyB3ZSd2ZSBtYWRlIHdoaWxl
IGV2YWx1YXRpbmcgTUdMUlUgWzFdLiBJIHRoaW5rIHlvdXINCj4gZmluZGluZ3MgaW4gUTMgcmVn
YXJkaW5nIGhpZ2ggcmVjbGFpbSBjb3N0cyBhbmQgdGFza3Mgd2FpdGluZyBpbg0KPiB1bmludGVy
cnVwdGlibGUgc2xlZXAgY29ycm9ib3JhdGUgdGhlIGluY3JlYXNlZCBkaXJlY3QgcmVjbGFpbSB0
YWlsDQo+IGxhdGVuY2llcyB3ZSBoYXZlIGJlZW4gaW52ZXN0aWdhdGluZyBvbiBvdXIgZW5kLg0K
PiANCj4gSXQgd2lsbCBiZSB2YWx1YWJsZSB0byBkaXNjdXNzIHlvdXIgbGFyZ2Utc2NhbGUgZmll
bGQgZGF0YSBhbmQgc2VlIGhvdw0KPiB0aGUgd29ya2Fyb3VuZHMgeW91J3ZlIGltcGxlbWVudGVk
IG1pZ2h0IGluZm9ybSB0aGUgdXBzdHJlYW0NCj4gZGlzY3Vzc2lvbnMgYWxvbmdzaWRlIEthaXJ1
aSdzIHByb3Bvc2Fscy4NCj4gDQo+IFsxXQ0KPiBodHRwczovL2xvcmUua2VybmVsLm9yZy9hbGwv
Q0FDX1RKdmZpXzVuMmNyR0hiUlZPMFI4amRZY1NDbWd6VUpQemh0U3YNCj4gV2VDTjZmQ2JRZ0Bt
YWlsLmdtYWlsLmNvbS8jdA0KPiANCj4gVGhhbmtzLA0KPiBLYWxlc2gNCj4gDQpIaSBLYWxlc2gs
DQoNClRoYW5rcyBmb3IgZm9sbG93aW5nIHVwIGFuZCBmb3Igc2hhcmluZyB5b3VyIG9ic2VydmF0
aW9ucy4NCkZvciBRMywgd2UgaGF2ZSBvbmx5IHRyaWVkIHNvbWUgYXBwcm9hY2hlcyBzbyBmYXIg
YW5kIGRvbuKAmXQgaGF2ZSBhIHNvbGlkIHNvbHV0aW9uIHlldC4NCldl4oCZZCBiZSBoYXBweSB0
byBzaGFyZSBvdXIgZmllbGQgZGF0YSBhbmQgc29tZSBQZXJmZXR0byB0cmFjZXMuIFdlIGJlbGll
dmUgaXQgd291bGQgDQpiZSB2ZXJ5IGhlbHBmdWwgdG8gZGlzY3VzcyB3aXRoIHlvdSBhbmQgS2Fp
cnVpIGF0IExTRi9NTS9CUEYuDQoNCkJlc3QsDQpaaWNoZW5nDQoNCj4gPiA+DQo+ID4gPiBGb3Ig
b2J2aW91cyByZWFzb25zIEknbSBpbnRlcmVzdGVkIGluIHRoaXMgZGlzY3Vzc2lvbi4gV2UgYWxz
byBub3RpY2UNCj4gPiA+IHNvbWUgc2hvcnRjb21pbmdzIG9mIE1HTFJVIGFuZCB3b3VsZCBsaWtl
IHRvIGNvbGxhYm9yYXRlIG9uIHJlc29sdmluZw0KPiA+ID4gdGhlbS4NCj4gPiA+IFRoYW5rcywN
Cj4gPiA+IFN1cmVuLg0KPiA+ID4NCj4gPiBIaSBTdXJlbiwNCj4gPg0KPiA+IHRoYW5rcywgd2Xi
gJlkIGJlIHZlcnkgaGFwcHkgdG8gd29yayB0b2dldGhlciBvbiB0aGlzLg0KPiA+DQo+ID4gPiA+
DQo+ID4gPiA+IFJlZmVyZW5jZQ0KPiA+ID4gPiBbMV0gaHR0cHM6Ly9sb3JlLmtlcm5lbC5vcmcv
bGludXgtbW0vMjAyNTExMjgwMjUzMTUuMzUyMDY4OS0xLQ0KPiA+ID4gd2FuZ3ppY2hlbmdAaG9u
b3IuY29tLw0KPiA+ID4gPiBbMl0gaHR0cHM6Ly9hbmRyb2lkLQ0KPiA+ID4gcmV2aWV3Lmdvb2ds
ZXNvdXJjZS5jb20vYy9rZXJuZWwvY29tbW9uLysvMzg2NjU1NA0KPiA+ID4gPiBbM10gaHR0cHM6
Ly9hbmRyb2lkLQ0KPiA+ID4gcmV2aWV3Lmdvb2dsZXNvdXJjZS5jb20vYy9rZXJuZWwvY29tbW9u
LysvMzg3MDkyMA0KPiA+ID4gPiBbNF0gaHR0cHM6Ly9sd24ubmV0L0FydGljbGVzLzEwNTE4ODIv
DQo+ID4gPiA+DQo+ID4gPiA+IC0tDQo+ID4gPiA+IEJlc3QgcmVnYXJkcywgYW5kIHdpc2hpbmcg
eW91IGEgcHJvc3Blcm91cyBZZWFyIG9mIHRoZSBIb3JzZSwNCj4gPiA+ID4gWmljaGVuZyBXYW5n
DQo=


Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0228DF433E2
	for <linux-mm@archiver.kernel.org>; Thu, 16 Apr 2026 05:18:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 530B86B0089; Thu, 16 Apr 2026 01:18:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 507DA6B0092; Thu, 16 Apr 2026 01:18:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 445276B0093; Thu, 16 Apr 2026 01:18:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 3250C6B0089
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 01:18:56 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id D0706E449D
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 05:18:55 +0000 (UTC)
X-FDA: 84663264630.20.989512E
Received: from outboundhk.mxmail.xiaomi.com (outboundhk.mxmail.xiaomi.com [118.143.206.90])
	by imf27.hostedemail.com (Postfix) with ESMTP id 0399140004
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 05:18:52 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=none;
	spf=pass (imf27.hostedemail.com: domain of gaoxiang17@xiaomi.com designates 118.143.206.90 as permitted sender) smtp.mailfrom=gaoxiang17@xiaomi.com;
	dmarc=pass (policy=quarantine) header.from=xiaomi.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776316734;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=YxVNuvv5bUu/1HJS/apiy6Hv/k96cSqScBmT4AylQqg=;
	b=GzEnETrv6fy8rAwI1+cE2qZA7g+Vzhftkxg0+w2hk44+JXaIX+sApAlr02pE4XLtB2oV94
	yUR0Gkpe6YkJkjSeaFdyYrRRKZg2JftFX84YLoBZjyyp+nKqSX+6K/T5lpHntd5cZ1jFeq
	G3LjWwClIBZLTYVQYj93dkGwITTlrdo=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776316734; a=rsa-sha256;
	cv=none;
	b=qHyCu2bMR/71i3OhV1Hgb0YK4xBrkc9ZaQYlypOwZSdQF/K9bKTVQIqkNTC4SKdardNcme
	KjY9YDJbEfplsSDkM28icAPYJ2a4YLIYFEiSnlg9u7ezwxGRh+vjXbz8ehiI3RMdIMqOwR
	XRj/qdumFar8fgP6sUbBxxe13iKbIN4=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=none;
	spf=pass (imf27.hostedemail.com: domain of gaoxiang17@xiaomi.com designates 118.143.206.90 as permitted sender) smtp.mailfrom=gaoxiang17@xiaomi.com;
	dmarc=pass (policy=quarantine) header.from=xiaomi.com
X-CSE-ConnectionGUID: fsAn/7xlRtaNlSa4o5ibuA==
X-CSE-MsgGUID: bBpnYd99TDeU60/GgpChUA==
X-IronPort-AV: E=Sophos;i="6.23,181,1770566400"; 
   d="scan'208,217";a="146821604"
From: =?gb2312?B?uN/P6A==?= <gaoxiang17@xiaomi.com>
To: Donet Tom <donettom@linux.ibm.com>, Xiang Gao <gxxa03070307@gmail.com>,
	"akpm@linux-foundation.org" <akpm@linux-foundation.org>,
	"axelrasmussen@google.com" <axelrasmussen@google.com>, "yuanchu@google.com"
	<yuanchu@google.com>, "hannes@cmpxchg.org" <hannes@cmpxchg.org>
CC: "weixugc@google.com" <weixugc@google.com>, "david@kernel.org"
	<david@kernel.org>, "mhocko@kernel.org" <mhocko@kernel.org>,
	"zhengqi.arch@bytedance.com" <zhengqi.arch@bytedance.com>,
	"shakeel.butt@linux.dev" <shakeel.butt@linux.dev>, "ljs@kernel.org"
	<ljs@kernel.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: =?gb2312?B?tPC4tDogW0V4dGVybmFsIE1haWxdUmU6IFtQQVRDSF0gbW0vdm1zY2FuOiBm?=
 =?gb2312?Q?ix_typos_in_comments?=
Thread-Topic: [External Mail]Re: [PATCH] mm/vmscan: fix typos in comments
Thread-Index: AQHczVs0wTtTiYGS9UukkTMaiPUrc7XhJR+D
Date: Thu, 16 Apr 2026 05:18:49 +0000
Message-ID: <cdeeca7614ea4fac8449b581b1a13f6d@xiaomi.com>
References: <20260416024248.687943-1-gxxa03070307@gmail.com>,<87167cf2-5851-46a5-99bf-deb5894ff214@linux.ibm.com>
In-Reply-To: <87167cf2-5851-46a5-99bf-deb5894ff214@linux.ibm.com>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-originating-ip: [10.237.88.13]
Content-Type: multipart/alternative;
	boundary="_000_cdeeca7614ea4fac8449b581b1a13f6dxiaomicom_"
MIME-Version: 1.0
X-Rspamd-Queue-Id: 0399140004
X-Rspamd-Server: rspam07
X-Stat-Signature: cuwzqz4hz9yq47oh3tobut44fuz5iemc
X-Rspam-User: 
X-HE-Tag: 1776316732-381504
X-HE-Meta: U2FsdGVkX18hTTnCa5GgRkq+/jedmi2y8lrjMhJIgZagpPO4dSu2zRI7TteqmEfGaqjXFB/4DIYgj0fI+Pp4ea+oGZzLNHKDKCcN2WutwnZIScO6gTXlkUFe+xiSBZnNhE9BJdcUvBd9OWleOzTCGKpvHiv/D2RtIcIIz9mS4ABDcH722vu1WBORXPIfRAlQ+HSQPnjCncrGeZlmuzJu+XrMTnUWsM3U/oP2ZCEdftsYnqzckTytrp2o70roqr5mo44SWja9P64iKtsJofqti2ixtjBsCZAWg75NUdy+212eOxAbPdZHA/EmkL63y0EUXLBQPmxV+MGgPATLX6x2upZN2I/TajSzMLGrh4y4ShoaE4Cc03GC6q5u+SvEMXviJhNLpgHHOHM7PJpp7TXfx3kIa0dbBf39JI1elIjJfCSCmzW8zZtoJ9sNpeceLoQVrUFN3HnMlepxLQAiX6XC68VfbSHJIYeJpmqFjsCimDK4MHFZr1igVr2x632ISf81qxa3DMTp3AkssPnJBaYdlQihwFE2YrWsw+sUy7v3n+kr8LFpdfLFikCwiXZdD3EqhRYkt8Syr12WNmxsJm+uy78AOIpjVuM017vbk7xBoNkqaEZ+20u6XLg40lrX5r9KjvllnVZLNhybhBmeLnAE1id+LWdjI1nX5dx2oh+1Py+2L7W3pEVH+zFzrO7Tgee7ATmK+Z6AetAxDoUld3bp4NrM7yai79W6VjDs/qhn2A7WJWeMXqdtFSiHp+pe74KIjLH7RZLcwoCfldwMLZueld7TAAgkmpR14k7k63UFqrKhX6qjRXajufjC2ZbScLzZ6vL39LKSYLEZj7HxjECVCTatuG6tXzSZtApZ3zcDyNHYOQy4NYc3oW569jBWaBncJxcHQ1wPJXgNhtxOM1A2FayUCNojKVJ5s7Zf2KaoZxO25SonMvcQTNyOVdwCzFYlhwimGMzKVhEbAMUTtLb
 Trbw4hgs
 JZrAfGUVtgo41g+uvvuT+erJV1KcEv0wofdabNFIi+LgiKtJsNCejjFv+JsfMmETtZm2sJRv6Isjt3mhgxC9TARFwNJRJUJsKt/H9m7/RvbcwUe+FFewQujcMkwlckzX2VMbWjMnnfVTUtNIncC7A7Mf9hLQ4dVdZScZGs800nZcQuanf0fwiZV151OWxfFEPdiYY12Q5GVnA8SYtRAq9Hu6n3s3UHnyWylKu7WoYDhxNmdpTAs6xa+8udFiXQdDBvE6nKzZMRQmHv8yqfHz1ECOEyOLHB1oQzbIZXhVbmrXBlWMmiUOij2TtLDMOVzlCAaPV2bbgN286x+xzYaETd0+ufBrbjiWiVCisjQg6yWfyZDDvYuslxZUVtLKjZTl3NixFrpyK5TIWwreFhlMYuiW/QNoike4O/lVfD8PkJqiAk7bZyyXLLuF+p5j4eBQWiG5E2r4G+UzK0EQjE1NC1IRLUusO+hxhvEPBDBBADHWPFEzYSOYKHVvFrAShsc9iOFSdx30p/otIU4TUtBrReI+IrJFOZsiB4ODJ1re4cBt1LWp5MHUTw32qRLnKl7bESZ8H6xWzIwVSS/sHVyNSVEadavYRqftNdR0BjuXu76nq+UBnAZMMHbSpJiCfH4vV9FocO/fuGFhrg/HmEGDQUmARUjxJFWchpiFk6VhAavUfgqUXLojpm7px+i8PSYxJ7rnw
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

--_000_cdeeca7614ea4fac8449b581b1a13f6dxiaomicom_
Content-Type: text/plain; charset="gb2312"
Content-Transfer-Encoding: base64

SGksDQoNClRoYW5rcyBmb3IgY2F0Y2hpbmcgdGhpcy4gSSdsbCBmaXggdGhlIFNpZ25lZC1vZmYt
YnkgbmFtZSBtaXNtYXRjaCBhbmQgc2VuZCBhIHYyLg0KDQpCZXN0IHJlZ2FyZHMsWGlhbmcgR2Fv
DQoNCl9fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fDQq3orz+yMs6IERvbmV0IFRvbSA8
ZG9uZXR0b21AbGludXguaWJtLmNvbT4NCreiy83KsbzkOiAyMDI2xOo01MIxNsjVIDEyOjQwOjEy
DQrK1bz+yMs6IFhpYW5nIEdhbzsgYWtwbUBsaW51eC1mb3VuZGF0aW9uLm9yZzsgYXhlbHJhc211
c3NlbkBnb29nbGUuY29tOyB5dWFuY2h1QGdvb2dsZS5jb207IGhhbm5lc0BjbXB4Y2hnLm9yZw0K
s63LzTogd2VpeHVnY0Bnb29nbGUuY29tOyBkYXZpZEBrZXJuZWwub3JnOyBtaG9ja29Aa2VybmVs
Lm9yZzsgemhlbmdxaS5hcmNoQGJ5dGVkYW5jZS5jb207IHNoYWtlZWwuYnV0dEBsaW51eC5kZXY7
IGxqc0BrZXJuZWwub3JnOyBsaW51eC1tbUBrdmFjay5vcmc7IGxpbnV4LWtlcm5lbEB2Z2VyLmtl
cm5lbC5vcmc7ILjfz+gNCtb3zOI6IFtFeHRlcm5hbCBNYWlsXVJlOiBbUEFUQ0hdIG1tL3Ztc2Nh
bjogZml4IHR5cG9zIGluIGNvbW1lbnRzDQoNClvN4rK/08q8/l0gtMvTyrz+wLTUtNPa0KHD17mr
y77N4rK/o6zH6733yfe0psDtoaPI9LbU08q8/rCyyKvQ1LTm0smjrMfrvavTyrz+16q3orj4bWlz
ZWNAeGlhb21pLmNvbb340NC3tMChDQoNCkhpDQoNCk9uIDQvMTYvMjYgODoxMiBBTSwgWGlhbmcg
R2FvIHdyb3RlOg0KPiBGcm9tOiBYaWFuZyBHYW8gPGdhb3hpYW5nMTdAeGlhb21pLmNvbT4NCj4N
Cj4gRml4IHRocmVlIHR5cG9zIGluIGNvbW1lbnRzOg0KPg0KPiAtIExpbmUgMTEyOiAiem9tZV9y
ZWNsYWltX21vZGUiIC0+ICJ6b25lX3JlY2xhaW1fbW9kZSINCj4gLSBMaW5lIDYyMDg6ICJwcmlv
aXRpZXMiIC0+ICJwcmlvcml0aWVzIg0KPiAtIExpbmUgNzA2NzogInRoYXQgdGhhdCBoaWdoIiAt
PiAidGhhdCB0aGUgaGlnaCIgKGR1cGxpY2F0ZWQgd29yZCkNCj4NCj4gU2lnbmVkLW9mZi1ieTog
Z2FveGlhbmcxNyA8Z2FveGlhbmcxN0B4aWFvbWkuY29tPg0KDQoNCkkgYW0gc2VlaW5nIGJlbG93
IGlzc3VlIHdpdGggY2hlY2twYXRjaC5wbA0KDQouL3NjcmlwdHMvY2hlY2twYXRjaC5wbCAtLXN0
cmljdCAwMDAxLW1tLXZtc2Nhbi1maXgtdHlwb3MtaW4tY29tbWVudHMucGF0Y2gNCldBUk5JTkc6
IEZyb206L1NpZ25lZC1vZmYtYnk6IGVtYWlsIG5hbWUgbWlzbWF0Y2g6ICdGcm9tOiBYaWFuZyBH
YW8NCjxnYW94aWFuZzE3QHhpYW9taS5jb20+JyAhPSAnU2lnbmVkLW9mZi1ieTogZ2FveGlhbmcx
Nw0KPGdhb3hpYW5nMTdAeGlhb21pLmNvbT4nDQoNCnRvdGFsOiAwIGVycm9ycywgMSB3YXJuaW5n
cywgMCBjaGVja3MsIDI0IGxpbmVzIGNoZWNrZWQNCg0KPiAtLS0NCj4gICBtbS92bXNjYW4uYyB8
IDYgKysrLS0tDQo+ICAgMSBmaWxlIGNoYW5nZWQsIDMgaW5zZXJ0aW9ucygrKSwgMyBkZWxldGlv
bnMoLSkNCj4NCj4gZGlmZiAtLWdpdCBhL21tL3Ztc2Nhbi5jIGIvbW0vdm1zY2FuLmMNCj4gaW5k
ZXggMGZjOTM3M2U4MjUxLi43MTBmYmUxZWUxNTEgMTAwNjQ0DQo+IC0tLSBhL21tL3Ztc2Nhbi5j
DQo+ICsrKyBiL21tL3Ztc2Nhbi5jDQo+IEBAIC0xMDksNyArMTA5LDcgQEAgc3RydWN0IHNjYW5f
Y29udHJvbCB7DQo+ICAgICAgIC8qIHpvbmVfcmVjbGFpbV9tb2RlICovDQo+ICAgICAgIHVuc2ln
bmVkIGludCBtYXlfdW5tYXA6MTsNCj4NCj4gLSAgICAgLyogem9tZV9yZWNsYWltX21vZGUsIGJv
b3N0IHJlY2xhaW0sIGNncm91cCByZXN0cmljdGlvbnMgKi8NCj4gKyAgICAgLyogem9uZV9yZWNs
YWltX21vZGUsIGJvb3N0IHJlY2xhaW0sIGNncm91cCByZXN0cmljdGlvbnMgKi8NCj4gICAgICAg
dW5zaWduZWQgaW50IG1heV9zd2FwOjE7DQo+DQo+ICAgICAgIC8qIE5vdCBhbGxvdyBjYWNoZV90
cmltX21vZGUgdG8gYmUgdHVybmVkIG9uIGFzIHBhcnQgb2YgcmVjbGFpbT8gKi8NCj4gQEAgLTYy
MDUsNyArNjIwNSw3IEBAIHN0YXRpYyB2b2lkIGNvbnNpZGVyX3JlY2xhaW1fdGhyb3R0bGUocGdf
ZGF0YV90ICpwZ2RhdCwgc3RydWN0IHNjYW5fY29udHJvbCAqc2MpDQo+ICAgICAgIGlmIChjdXJy
ZW50X2lzX2tzd2FwZCgpIHx8IGNncm91cF9yZWNsYWltKHNjKSkNCj4gICAgICAgICAgICAgICBy
ZXR1cm47DQo+DQo+IC0gICAgIC8qIFRocm90dGxlIGlmIG1ha2luZyBubyBwcm9ncmVzcyBhdCBo
aWdoIHByaW9pdGllcy4gKi8NCj4gKyAgICAgLyogVGhyb3R0bGUgaWYgbWFraW5nIG5vIHByb2dy
ZXNzIGF0IGhpZ2ggcHJpb3JpdGllcy4gKi8NCj4gICAgICAgaWYgKHNjLT5wcmlvcml0eSA9PSAx
ICYmICFzYy0+bnJfcmVjbGFpbWVkKQ0KPiAgICAgICAgICAgICAgIHJlY2xhaW1fdGhyb3R0bGUo
cGdkYXQsIFZNU0NBTl9USFJPVFRMRV9OT1BST0dSRVNTKTsNCj4gICB9DQo+IEBAIC03MDY0LDcg
KzcwNjQsNyBAQCBzdGF0aWMgaW50IGJhbGFuY2VfcGdkYXQocGdfZGF0YV90ICpwZ2RhdCwgaW50
IG9yZGVyLCBpbnQgaGlnaGVzdF96b25laWR4KQ0KPg0KPiAgICAgICAgICAgICAgIC8qDQo+ICAg
ICAgICAgICAgICAgICogVGhlcmUgc2hvdWxkIGJlIG5vIG5lZWQgdG8gcmFpc2UgdGhlIHNjYW5u
aW5nIHByaW9yaXR5IGlmDQo+IC0gICAgICAgICAgICAgICogZW5vdWdoIHBhZ2VzIGFyZSBhbHJl
YWR5IGJlaW5nIHNjYW5uZWQgdGhhdCB0aGF0IGhpZ2gNCj4gKyAgICAgICAgICAgICAgKiBlbm91
Z2ggcGFnZXMgYXJlIGFscmVhZHkgYmVpbmcgc2Nhbm5lZCB0aGF0IHRoZSBoaWdoDQo+ICAgICAg
ICAgICAgICAgICogd2F0ZXJtYXJrIHdvdWxkIGJlIG1ldCBhdCAxMDAlIGVmZmljaWVuY3kuDQo+
ICAgICAgICAgICAgICAgICovDQo+ICAgICAgICAgICAgICAgaWYgKGtzd2FwZF9zaHJpbmtfbm9k
ZShwZ2RhdCwgJnNjKSkNCg==

--_000_cdeeca7614ea4fac8449b581b1a13f6dxiaomicom_
Content-Type: text/html; charset="gb2312"
Content-Transfer-Encoding: quoted-printable

<html>
<head>
<meta http-equiv=3D"Content-Type" content=3D"text/html; charset=3Dgb2312">
<style type=3D"text/css" style=3D"display:none;"><!-- P {margin-top:0;margi=
n-bottom:0;} --></style>
</head>
<body dir=3D"ltr">
<div id=3D"divtagdefaultwrapper" style=3D"font-size:12pt;color:#000000;font=
-family:Calibri,Helvetica,sans-serif;" dir=3D"ltr">
<p></p>
<div data-page-id=3D"RLYad2SOQotXsUxobDPc7gtYnbh" data-lark-html-role=3D"ro=
ot" data-docx-has-block-data=3D"false">
<div class=3D"ace-line ace-line old-record-id-doxcn1cNS5NzmxyKhjy05SZUlph">=
Hi,</div>
<div class=3D"ace-line ace-line old-record-id-doxcn1cNS5NzmxyKhjy05SZUlph">=
<br>
</div>
<div class=3D"ace-line ace-line old-record-id-doxcnlvaZjiwI9ThbBzTEqHtjVb">=
Thanks for catching this. I'll fix the Signed-off-by name mismatch and send=
 a v2.</div>
<div class=3D"ace-line ace-line old-record-id-doxcnlvaZjiwI9ThbBzTEqHtjVb">=
<br>
</div>
<div class=3D"ace-line ace-line old-record-id-doxcnXMTc76rNTbAbIqgKGNBcLd">=
Best regards,Xiang Gao</div>
</div>
<span data-lark-record-data=3D"{&quot;isCut&quot;:false,&quot;rootId&quot;:=
&quot;RLYad2SOQotXsUxobDPc7gtYnbh&quot;,&quot;parentId&quot;:&quot;RLYad2SO=
QotXsUxobDPc7gtYnbh&quot;,&quot;blockIds&quot;:[2,3,4],&quot;recordIds&quot=
;:[&quot;doxcn1cNS5NzmxyKhjy05SZUlph&quot;,&quot;doxcnlvaZjiwI9ThbBzTEqHtjV=
b&quot;,&quot;doxcnXMTc76rNTbAbIqgKGNBcLd&quot;],&quot;recordMap&quot;:{&qu=
ot;doxcn1cNS5NzmxyKhjy05SZUlph&quot;:{&quot;id&quot;:&quot;doxcn1cNS5NzmxyK=
hjy05SZUlph&quot;,&quot;snapshot&quot;:{&quot;type&quot;:&quot;text&quot;,&=
quot;parent_id&quot;:&quot;RLYad2SOQotXsUxobDPc7gtYnbh&quot;,&quot;comments=
&quot;:null,&quot;revisions&quot;:null,&quot;locked&quot;:false,&quot;hidde=
n&quot;:false,&quot;author&quot;:&quot;7484727598392606721&quot;,&quot;chil=
dren&quot;:[],&quot;text&quot;:{&quot;initialAttributedTexts&quot;:{&quot;t=
ext&quot;:{&quot;0&quot;:&quot;Hi,&quot;},&quot;attribs&quot;:{&quot;0&quot=
;:&quot;*0&#43;3&quot;}},&quot;apool&quot;:{&quot;numToAttrib&quot;:{&quot;=
0&quot;:[&quot;author&quot;,&quot;7484727598392606721&quot;]},&quot;nextNum=
&quot;:1}},&quot;align&quot;:&quot;&quot;}},&quot;doxcnlvaZjiwI9ThbBzTEqHtj=
Vb&quot;:{&quot;id&quot;:&quot;doxcnlvaZjiwI9ThbBzTEqHtjVb&quot;,&quot;snap=
shot&quot;:{&quot;type&quot;:&quot;text&quot;,&quot;parent_id&quot;:&quot;R=
LYad2SOQotXsUxobDPc7gtYnbh&quot;,&quot;comments&quot;:null,&quot;revisions&=
quot;:null,&quot;locked&quot;:false,&quot;hidden&quot;:false,&quot;author&q=
uot;:&quot;7484727598392606721&quot;,&quot;children&quot;:[],&quot;text&quo=
t;:{&quot;apool&quot;:{&quot;nextNum&quot;:1,&quot;numToAttrib&quot;:{&quot=
;0&quot;:[&quot;author&quot;,&quot;7484727598392606721&quot;]}},&quot;initi=
alAttributedTexts&quot;:{&quot;attribs&quot;:{&quot;0&quot;:&quot;*0&#43;29=
&quot;},&quot;text&quot;:{&quot;0&quot;:&quot;Thanks for catching this. I'l=
l fix the Signed-off-by name mismatch and send a v2.&quot;}}},&quot;align&q=
uot;:&quot;&quot;}},&quot;doxcnXMTc76rNTbAbIqgKGNBcLd&quot;:{&quot;id&quot;=
:&quot;doxcnXMTc76rNTbAbIqgKGNBcLd&quot;,&quot;snapshot&quot;:{&quot;type&q=
uot;:&quot;text&quot;,&quot;parent_id&quot;:&quot;RLYad2SOQotXsUxobDPc7gtYn=
bh&quot;,&quot;comments&quot;:null,&quot;revisions&quot;:null,&quot;locked&=
quot;:false,&quot;hidden&quot;:false,&quot;author&quot;:&quot;7484727598392=
606721&quot;,&quot;children&quot;:[],&quot;text&quot;:{&quot;initialAttribu=
tedTexts&quot;:{&quot;text&quot;:{&quot;0&quot;:&quot;Best regards,Xiang Ga=
o&quot;},&quot;attribs&quot;:{&quot;0&quot;:&quot;*0&#43;m&quot;}},&quot;ap=
ool&quot;:{&quot;numToAttrib&quot;:{&quot;0&quot;:[&quot;author&quot;,&quot=
;7484727598392606721&quot;]},&quot;nextNum&quot;:1}},&quot;align&quot;:&quo=
t;&quot;}},&quot;RLYad2SOQotXsUxobDPc7gtYnbh&quot;:{&quot;id&quot;:&quot;RL=
Yad2SOQotXsUxobDPc7gtYnbh&quot;,&quot;snapshot&quot;:{&quot;type&quot;:&quo=
t;page&quot;,&quot;parent_id&quot;:&quot;&quot;,&quot;comments&quot;:[],&qu=
ot;revisions&quot;:[],&quot;locked&quot;:false,&quot;hidden&quot;:false,&qu=
ot;author&quot;:&quot;7484727598392606721&quot;,&quot;children&quot;:[&quot=
;doxcn1cNS5NzmxyKhjy05SZUlph&quot;,&quot;doxcnlvaZjiwI9ThbBzTEqHtjVb&quot;,=
&quot;doxcnXMTc76rNTbAbIqgKGNBcLd&quot;],&quot;text&quot;:{&quot;apool&quot=
;:{&quot;nextNum&quot;:1,&quot;numToAttrib&quot;:{&quot;0&quot;:[&quot;auth=
or&quot;,&quot;7484727598392606721&quot;]}},&quot;initialAttributedTexts&qu=
ot;:{&quot;attribs&quot;:{&quot;0&quot;:&quot;*0&#43;1d&quot;},&quot;text&q=
uot;:{&quot;0&quot;:&quot;Reply: Fix typos in comments - checkpatch warning=
&quot;}}},&quot;align&quot;:&quot;&quot;,&quot;doc_info&quot;:{&quot;editor=
s&quot;:[&quot;7484727598392606721&quot;],&quot;options&quot;:[&quot;editor=
s&quot;,&quot;edit_time&quot;],&quot;deleted_editors&quot;:null,&quot;optio=
n_modified&quot;:null}}}},&quot;payloadMap&quot;:{&quot;doxcn1cNS5NzmxyKhjy=
05SZUlph&quot;:{&quot;level&quot;:1},&quot;doxcnlvaZjiwI9ThbBzTEqHtjVb&quot=
;:{&quot;level&quot;:1},&quot;doxcnXMTc76rNTbAbIqgKGNBcLd&quot;:{&quot;leve=
l&quot;:1}},&quot;extra&quot;:{&quot;channel&quot;:&quot;saas&quot;,&quot;p=
asteRandomId&quot;:&quot;fd87a4c8-8b96-4bbe-8eff-1fe858a0c457&quot;,&quot;m=
ention_page_title&quot;:{},&quot;external_mention_url&quot;:{},&quot;isEqua=
lBlockSelection&quot;:true},&quot;isKeepQuoteContainer&quot;:false,&quot;se=
lection&quot;:[{&quot;id&quot;:2,&quot;type&quot;:&quot;text&quot;,&quot;se=
lection&quot;:{&quot;start&quot;:0,&quot;end&quot;:3},&quot;recordId&quot;:=
&quot;doxcn1cNS5NzmxyKhjy05SZUlph&quot;},{&quot;id&quot;:3,&quot;type&quot;=
:&quot;text&quot;,&quot;selection&quot;:{&quot;start&quot;:0,&quot;end&quot=
;:81},&quot;recordId&quot;:&quot;doxcnlvaZjiwI9ThbBzTEqHtjVb&quot;},{&quot;=
id&quot;:4,&quot;type&quot;:&quot;text&quot;,&quot;selection&quot;:{&quot;s=
tart&quot;:0,&quot;end&quot;:22},&quot;recordId&quot;:&quot;doxcnXMTc76rNTb=
AbIqgKGNBcLd&quot;}],&quot;pasteFlag&quot;:&quot;1e12da80-4231-4db6-a5a8-08=
4982c32e32&quot;}" data-lark-record-format=3D"docx/record" class=3D"lark-re=
cord-clipboard"></span>
<div dir=3D"ltr">
<div id=3D"x_divtagdefaultwrapper" dir=3D"ltr" style=3D"font-size: 12pt; co=
lor: rgb(0, 0, 0); font-family: Calibri, Helvetica, sans-serif, EmojiFont, =
&quot;Apple Color Emoji&quot;, &quot;Segoe UI Emoji&quot;, NotoColorEmoji, =
&quot;Segoe UI Symbol&quot;, &quot;Android Emoji&quot;, EmojiSymbols;">
<p></p>
</div>
<hr tabindex=3D"-1" style=3D"display:inline-block; width:98%">
<div id=3D"x_divRplyFwdMsg" dir=3D"ltr"><font face=3D"Calibri, sans-serif" =
color=3D"#000000" style=3D"font-size:11pt"><b>=B7=A2=BC=FE=C8=CB:</b> Donet=
 Tom &lt;donettom@linux.ibm.com&gt;<br>
<b>=B7=A2=CB=CD=CA=B1=BC=E4:</b> 2026=C4=EA4=D4=C216=C8=D5 12:40:12<br>
<b>=CA=D5=BC=FE=C8=CB:</b> Xiang Gao; akpm@linux-foundation.org; axelrasmus=
sen@google.com; yuanchu@google.com; hannes@cmpxchg.org<br>
<b>=B3=AD=CB=CD:</b> weixugc@google.com; david@kernel.org; mhocko@kernel.or=
g; zhengqi.arch@bytedance.com; shakeel.butt@linux.dev; ljs@kernel.org; linu=
x-mm@kvack.org; linux-kernel@vger.kernel.org; =B8=DF=CF=E8<br>
<b>=D6=F7=CC=E2:</b> [External Mail]Re: [PATCH] mm/vmscan: fix typos in com=
ments</font>
<div>&nbsp;</div>
</div>
</div>
<font size=3D"2"><span style=3D"font-size:10pt">
<div class=3D"PlainText">[=CD=E2=B2=BF=D3=CA=BC=FE] =B4=CB=D3=CA=BC=FE=C0=
=B4=D4=B4=D3=DA=D0=A1=C3=D7=B9=AB=CB=BE=CD=E2=B2=BF=A3=AC=C7=EB=BD=F7=C9=F7=
=B4=A6=C0=ED=A1=A3=C8=F4=B6=D4=D3=CA=BC=FE=B0=B2=C8=AB=D0=D4=B4=E6=D2=C9=A3=
=AC=C7=EB=BD=AB=D3=CA=BC=FE=D7=AA=B7=A2=B8=F8misec@xiaomi.com=BD=F8=D0=D0=
=B7=B4=C0=A1<br>
<br>
Hi<br>
<br>
On 4/16/26 8:12 AM, Xiang Gao wrote:<br>
&gt; From: Xiang Gao &lt;gaoxiang17@xiaomi.com&gt;<br>
&gt;<br>
&gt; Fix three typos in comments:<br>
&gt;<br>
&gt; - Line 112: &quot;zome_reclaim_mode&quot; -&gt; &quot;zone_reclaim_mod=
e&quot;<br>
&gt; - Line 6208: &quot;prioities&quot; -&gt; &quot;priorities&quot;<br>
&gt; - Line 7067: &quot;that that high&quot; -&gt; &quot;that the high&quot=
; (duplicated word)<br>
&gt;<br>
&gt; Signed-off-by: gaoxiang17 &lt;gaoxiang17@xiaomi.com&gt;<br>
<br>
<br>
I am seeing below issue with checkpatch.pl<br>
<br>
./scripts/checkpatch.pl --strict 0001-mm-vmscan-fix-typos-in-comments.patch=
<br>
WARNING: From:/Signed-off-by: email name mismatch: 'From: Xiang Gao<br>
&lt;gaoxiang17@xiaomi.com&gt;' !=3D 'Signed-off-by: gaoxiang17<br>
&lt;gaoxiang17@xiaomi.com&gt;'<br>
<br>
total: 0 errors, 1 warnings, 0 checks, 24 lines checked<br>
<br>
&gt; ---<br>
&gt;&nbsp;&nbsp; mm/vmscan.c | 6 &#43;&#43;&#43;---<br>
&gt;&nbsp;&nbsp; 1 file changed, 3 insertions(&#43;), 3 deletions(-)<br>
&gt;<br>
&gt; diff --git a/mm/vmscan.c b/mm/vmscan.c<br>
&gt; index 0fc9373e8251..710fbe1ee151 100644<br>
&gt; --- a/mm/vmscan.c<br>
&gt; &#43;&#43;&#43; b/mm/vmscan.c<br>
&gt; @@ -109,7 &#43;109,7 @@ struct scan_control {<br>
&gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; /* zone_reclaim_mode */<br>
&gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; unsigned int may_unmap:1;<br>
&gt;<br>
&gt; -&nbsp;&nbsp;&nbsp;&nbsp; /* zome_reclaim_mode, boost reclaim, cgroup =
restrictions */<br>
&gt; &#43;&nbsp;&nbsp;&nbsp;&nbsp; /* zone_reclaim_mode, boost reclaim, cgr=
oup restrictions */<br>
&gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; unsigned int may_swap:1;<br>
&gt;<br>
&gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; /* Not allow cache_trim_mode to be=
 turned on as part of reclaim? */<br>
&gt; @@ -6205,7 &#43;6205,7 @@ static void consider_reclaim_throttle(pg_dat=
a_t *pgdat, struct scan_control *sc)<br>
&gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; if (current_is_kswapd() || cgroup_=
reclaim(sc))<br>
&gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp; return;<br>
&gt;<br>
&gt; -&nbsp;&nbsp;&nbsp;&nbsp; /* Throttle if making no progress at high pr=
ioities. */<br>
&gt; &#43;&nbsp;&nbsp;&nbsp;&nbsp; /* Throttle if making no progress at hig=
h priorities. */<br>
&gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; if (sc-&gt;priority =3D=3D 1 &amp;=
&amp; !sc-&gt;nr_reclaimed)<br>
&gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp; reclaim_throttle(pgdat, VMSCAN_THROTTLE_NOPROGRESS);<br>
&gt;&nbsp;&nbsp; }<br>
&gt; @@ -7064,7 &#43;7064,7 @@ static int balance_pgdat(pg_data_t *pgdat, i=
nt order, int highest_zoneidx)<br>
&gt;<br>
&gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp; /*<br>
&gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp; * There should be no need to raise the scanning priorit=
y if<br>
&gt; -&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp; * enough pages are already being scanned that that high<br>
&gt; &#43;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp; * enough pages are already being scanned that the high<br>
&gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp; * watermark would be met at 100% efficiency.<br>
&gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp; */<br>
&gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp; if (kswapd_shrink_node(pgdat, &amp;sc))<br>
</div>
</span></font></div>
</body>
</html>

--_000_cdeeca7614ea4fac8449b581b1a13f6dxiaomicom_--


Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9B96FF428FF
	for <linux-mm@archiver.kernel.org>; Thu, 16 Apr 2026 06:23:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 087726B0089; Thu, 16 Apr 2026 02:23:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 05EB46B008A; Thu, 16 Apr 2026 02:23:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EDE2C6B008C; Thu, 16 Apr 2026 02:23:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id DD8DB6B0089
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 02:23:14 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 9EB4C8AFAF
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 06:23:14 +0000 (UTC)
X-FDA: 84663426708.29.19EFAC8
Received: from outboundhk.mxmail.xiaomi.com (outboundhk.mxmail.xiaomi.com [118.143.206.90])
	by imf26.hostedemail.com (Postfix) with ESMTP id A1305140008
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 06:23:11 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=none;
	spf=pass (imf26.hostedemail.com: domain of gaoxiang17@xiaomi.com designates 118.143.206.90 as permitted sender) smtp.mailfrom=gaoxiang17@xiaomi.com;
	dmarc=pass (policy=quarantine) header.from=xiaomi.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776320592;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Ay9kfDrMx+uM11agMZZBz9ju1sxWM63g53vEeEiVkhg=;
	b=sPN5BTViykwnqx6mSRtEmUMFmp9iyPSbiuveJwmbab2uIwjz7u2TlxFUSXnyNLjs1m3wkr
	NkkdlqXdgEsLycRbM3VIB31YhRO30o/exnuLBxGTa5e+qXoi4ilvqhPjtv3+NFDWWoTpyt
	Y/rMM5ObyFZ6D3sQhh5ifce72NCAeKc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776320592; a=rsa-sha256;
	cv=none;
	b=vRN8nUr8htpMeNcX4Fe6oOTCUsB2OwjMO4YfYqsnHirHVihw/f5LkyGZhkwz/FKRaCm6cL
	Ymmaj5DD352cSefAqFY05aD2ky14NmT+e+45zBkbPRChWteCUY2iZQ79pKAbryxcwMe5DA
	qX14R+0sfr0Q92MIKFnC9ctNSUrPye4=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=none;
	spf=pass (imf26.hostedemail.com: domain of gaoxiang17@xiaomi.com designates 118.143.206.90 as permitted sender) smtp.mailfrom=gaoxiang17@xiaomi.com;
	dmarc=pass (policy=quarantine) header.from=xiaomi.com
X-CSE-ConnectionGUID: qkiTDL4DTcu3z9dJkfOgYw==
X-CSE-MsgGUID: j1phd4hgSPuCRjGJc6Es1g==
X-IronPort-AV: E=Sophos;i="6.23,181,1770566400"; 
   d="scan'208,217";a="146829363"
From: =?gb2312?B?uN/P6A==?= <gaoxiang17@xiaomi.com>
To: Donet Tom <donettom@linux.ibm.com>, Xiang Gao <gxxa03070307@gmail.com>,
	"akpm@linux-foundation.org" <akpm@linux-foundation.org>,
	"axelrasmussen@google.com" <axelrasmussen@google.com>, "yuanchu@google.com"
	<yuanchu@google.com>, "hannes@cmpxchg.org" <hannes@cmpxchg.org>
CC: "weixugc@google.com" <weixugc@google.com>, "david@kernel.org"
	<david@kernel.org>, "mhocko@kernel.org" <mhocko@kernel.org>,
	"zhengqi.arch@bytedance.com" <zhengqi.arch@bytedance.com>,
	"shakeel.butt@linux.dev" <shakeel.butt@linux.dev>, "ljs@kernel.org"
	<ljs@kernel.org>, "baohua@kernel.org" <baohua@kernel.org>,
	"linux-mm@kvack.org" <linux-mm@kvack.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>
Subject: =?gb2312?B?tPC4tDogW0V4dGVybmFsIE1haWxdUmU6IFtQQVRDSCB2Ml0gbW0vdm1zY2Fu?=
 =?gb2312?Q?:_fix_typos_in_comments?=
Thread-Topic: [External Mail]Re: [PATCH v2] mm/vmscan: fix typos in comments
Thread-Index: AQHczWSlSWKMFo0SjkWhpn9x7qPh7LXhOCyJ
Date: Thu, 16 Apr 2026 06:23:08 +0000
Message-ID: <a03cb4aae2b645d3a78905425d0e2ecd@xiaomi.com>
References: <20260416024248.687943-1-gxxa03070307@gmail.com>
 <20260416051533.708909-1-gxxa03070307@gmail.com>,<3d445fdf-6bbf-4d67-8a4f-eac7b5138ada@linux.ibm.com>
In-Reply-To: <3d445fdf-6bbf-4d67-8a4f-eac7b5138ada@linux.ibm.com>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-originating-ip: [10.237.88.13]
Content-Type: multipart/alternative;
	boundary="_000_a03cb4aae2b645d3a78905425d0e2ecdxiaomicom_"
MIME-Version: 1.0
X-Stat-Signature: 6qdi777ni51mjdm7bpfpsnxjy3c5dk6b
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: A1305140008
X-Rspam-User: 
X-HE-Tag: 1776320591-679913
X-HE-Meta: U2FsdGVkX19Djx0U0/TaKOIaGAYODQ63IL8YHhNaviTomu9wLo+Vg9lXHBaJgtET0vOd2jK5oMVlMZ1vxfuiIhkacn4RRqM0QdbjVLzlTv5KQ9tJBHjAunPlVjD2fQkhTwMYB43ONT46fwAsb8Vx+bfD8BTlD26TDcvYNkcYtLqCnRyjWjzdjnKHfXHfHPDcLl/Wd6keHCxa/JKzj33KB3WSiKktZed0dqf61FT8+tYozUVEI1Zoyanx33/+JKw+5Fs71333DzydCCrMGecXtVYlekD8bDI0hoCWO954S+gA6mwd5G1591z/xPuLcFSs6mT6FqtvOgfAczp5AWjJIgMfgcy7CTO7lAqrw8tbBSoJDLLv+opP2jqo2PTNb4OByO098fNUc+KvMA7Ha5nw0Kr2ly4y1VaExWpnJ56XgkiRgk0C36ZWWeNdzgq+ka5K2Fufa0Y8qQE7p9NyScEICw9HzYQVBNNqDCRsctYKbbN1Rav1K6D7F/NhoSqbJtgusGA3AKHnTY+AZ9PMI4E0CumdJ7v04YzdDcEXowkwAwdVKSnZWbbgmlJWva49+razz658UCFYfHEhqS40NN2Z/xS4nb05+SrWv56rLwksAomhNu1od99u0kMSLnIZK73jEt4irWnPMv4NXwnO3sCvMLBcUv/YI4/QbXOHkal+haulmFWexwZFoUpxXA67be73anamqfgUlvk1IwZ72DsQ291/VQIV5rKceKvJifZPR/Hv/D05BJBa5Yf2emEI0aFe29kf9QUVj/FNSrLP3L3BviifHMaJrNALVbgK6g0Yr/3gqzxYeXfxGxo3tduThM7gBagj4YBXDC6DCbpu/9+dS4U30zTBaLk11UsUwBk2X6aZX/xmoBXBZDCk9wBJ0NsDTKd89RE2Fy4z4CK10ocb4Md1vR0VJn6SADYisaZEXX5Qr1K2FQnuYfqda8EE8cGiiwLej9njIh5mmvqQ8bt
 NtuL3B9r
 fkBVDcP4yrtiMQ3BDu1HNppImIkSf8QwSWoKmqETL+QLEXY7f0SOcj2eWXiI0niS2JyBsJRmrYtEXv+pEAdYWqe7cRzzizAcmFiSSJ4cNII16Av6pPr0iK+ijwOIPR09kvuWFqRLQOi5Wodewhkv1AjmpooZEtGsumgbxjtIPZvOjrXrFWgWpe5L9qZ/OO/VwLKMI5mU8PoiN0pH9mWt7L5rFv1tMJXekxhbmUWpY/Llu1FEDfEpAkWZGxcWajNnrQMnvfBDhmeu8RAaYbKy+agdTRsVqG8jzjL3bOiFXkhC1e8Hw7U1npC2YrohxEV9DBh5EoSbHtgkTMIcvHVp36LwbUgYlObHWj6L9f1dkz2yClCU5yzdRuixi/UoiQvFESOQxkhksUaOx6nfGOnSeS0xTT0lVzFDs68Kt7bL4cWbGACcGjZNqLcVRdDDtkcCIZsVCW+kT/yuDZpnUJgiNlZPQToPerBtqMC7PynEohitMt+/AVqd5xh5p0YVUVGi9vgmh5QwvlJpxke57sJRJWOxxizg2vQcICc7CuDAAX4Y1Vwi1BM5rHxdJ/quQ5TxSOO8+EcX2Kp7MolLQbl8/Wzqy7045Rc/9pGud9BH2QgrXXOJaPEiCzdp8jfnJ6XGibZonp6d0OcukUfFjNM/YUcj7Ipi3RtZ40ded7Flfv+a+pR7l09l8hiXJ8mIP/DuUypYb7gZ3G+F6pHs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

--_000_a03cb4aae2b645d3a78905425d0e2ecdxiaomicom_
Content-Type: text/plain; charset="gb2312"
Content-Transfer-Encoding: base64

b2ssIHRoYW5rcy4NCg0KX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX18NCreivP7Iyzog
RG9uZXQgVG9tIDxkb25ldHRvbUBsaW51eC5pYm0uY29tPg0Kt6LLzcqxvOQ6IDIwMjbE6jTUwjE2
yNUgMTM6NDc6MjkNCsrVvP7IyzogWGlhbmcgR2FvOyBha3BtQGxpbnV4LWZvdW5kYXRpb24ub3Jn
OyBheGVscmFzbXVzc2VuQGdvb2dsZS5jb207IHl1YW5jaHVAZ29vZ2xlLmNvbTsgaGFubmVzQGNt
cHhjaGcub3JnDQqzrcvNOiB3ZWl4dWdjQGdvb2dsZS5jb207IGRhdmlkQGtlcm5lbC5vcmc7IG1o
b2Nrb0BrZXJuZWwub3JnOyB6aGVuZ3FpLmFyY2hAYnl0ZWRhbmNlLmNvbTsgc2hha2VlbC5idXR0
QGxpbnV4LmRldjsgbGpzQGtlcm5lbC5vcmc7IGJhb2h1YUBrZXJuZWwub3JnOyBsaW51eC1tbUBr
dmFjay5vcmc7IGxpbnV4LWtlcm5lbEB2Z2VyLmtlcm5lbC5vcmc7ILjfz+gNCtb3zOI6IFtFeHRl
cm5hbCBNYWlsXVJlOiBbUEFUQ0ggdjJdIG1tL3Ztc2NhbjogZml4IHR5cG9zIGluIGNvbW1lbnRz
DQoNCg0KW83isr/Tyrz+XSC0y9PKvP7AtNS009rQocPXuavLvs3isr+jrMfrvffJ97SmwO2ho8j0
ttTTyrz+sLLIq9DUtObSyaOsx+u9q9PKvP7XqreiuPhtaXNlY0B4aWFvbWkuY29tvfjQ0Le0wKEN
Cg0KSGkNCg0KT24gNC8xNi8yNiAxMDo0NSBBTSwgWGlhbmcgR2FvIHdyb3RlOg0KDQpGcm9tOiBY
aWFuZyBHYW8gPGdhb3hpYW5nMTdAeGlhb21pLmNvbT48bWFpbHRvOmdhb3hpYW5nMTdAeGlhb21p
LmNvbT4NCg0KRml4IHRocmVlIHR5cG9zIGluIGNvbW1lbnRzOg0KDQotIExpbmUgMTEyOiAiem9t
ZV9yZWNsYWltX21vZGUiIC0+ICJ6b25lX3JlY2xhaW1fbW9kZSINCi0gTGluZSA2MjA4OiAicHJp
b2l0aWVzIiAtPiAicHJpb3JpdGllcyINCi0gTGluZSA3MDY3OiAidGhhdCB0aGF0IGhpZ2giIC0+
ICJ0aGF0IHRoZSBoaWdoIiAoZHVwbGljYXRlZCB3b3JkKQ0KDQpTaWduZWQtb2ZmLWJ5OiBYaWFu
ZyBHYW8gPGdhb3hpYW5nMTdAeGlhb21pLmNvbT48bWFpbHRvOmdhb3hpYW5nMTdAeGlhb21pLmNv
bT4NClJldmlld2VkLWJ5OiBCYXJyeSBTb25nIDxiYW9odWFAa2VybmVsLm9yZz48bWFpbHRvOmJh
b2h1YUBrZXJuZWwub3JnPg0KDQoNCg0KSXQgbWlnaHQgYmUgYmV0dGVyIHRvIHNlbmQgdjIgYXMg
YSBuZXcgc2VyaWVzIG5leHQgdGltZSChqmp1c3QgYSBzdWdnZXN0aW9uLg0KDQoNCkxHVE0gUmV2
aWV3ZWQgYnk6IERvbmV0IFRvbSA8ZG9uZXR0b21AbGludXguaWJtLmNvbT48bWFpbHRvOmRvbmV0
dG9tQGxpbnV4LmlibS5jb20+IC1Eb25ldA0KDQoNCg0KLS0tDQogbW0vdm1zY2FuLmMgfCA2ICsr
Ky0tLQ0KIDEgZmlsZSBjaGFuZ2VkLCAzIGluc2VydGlvbnMoKyksIDMgZGVsZXRpb25zKC0pDQoN
CmRpZmYgLS1naXQgYS9tbS92bXNjYW4uYyBiL21tL3Ztc2Nhbi5jDQppbmRleCAwZmM5MzczZTgy
NTEuLjcxMGZiZTFlZTE1MSAxMDA2NDQNCi0tLSBhL21tL3Ztc2Nhbi5jDQorKysgYi9tbS92bXNj
YW4uYw0KQEAgLTEwOSw3ICsxMDksNyBAQCBzdHJ1Y3Qgc2Nhbl9jb250cm9sIHsNCiAgICAgICAg
Lyogem9uZV9yZWNsYWltX21vZGUgKi8NCiAgICAgICAgdW5zaWduZWQgaW50IG1heV91bm1hcDox
Ow0KDQotICAgICAgIC8qIHpvbWVfcmVjbGFpbV9tb2RlLCBib29zdCByZWNsYWltLCBjZ3JvdXAg
cmVzdHJpY3Rpb25zICovDQorICAgICAgIC8qIHpvbmVfcmVjbGFpbV9tb2RlLCBib29zdCByZWNs
YWltLCBjZ3JvdXAgcmVzdHJpY3Rpb25zICovDQogICAgICAgIHVuc2lnbmVkIGludCBtYXlfc3dh
cDoxOw0KDQogICAgICAgIC8qIE5vdCBhbGxvdyBjYWNoZV90cmltX21vZGUgdG8gYmUgdHVybmVk
IG9uIGFzIHBhcnQgb2YgcmVjbGFpbT8gKi8NCkBAIC02MjA1LDcgKzYyMDUsNyBAQCBzdGF0aWMg
dm9pZCBjb25zaWRlcl9yZWNsYWltX3Rocm90dGxlKHBnX2RhdGFfdCAqcGdkYXQsIHN0cnVjdCBz
Y2FuX2NvbnRyb2wgKnNjKQ0KICAgICAgICBpZiAoY3VycmVudF9pc19rc3dhcGQoKSB8fCBjZ3Jv
dXBfcmVjbGFpbShzYykpDQogICAgICAgICAgICAgICAgcmV0dXJuOw0KDQotICAgICAgIC8qIFRo
cm90dGxlIGlmIG1ha2luZyBubyBwcm9ncmVzcyBhdCBoaWdoIHByaW9pdGllcy4gKi8NCisgICAg
ICAgLyogVGhyb3R0bGUgaWYgbWFraW5nIG5vIHByb2dyZXNzIGF0IGhpZ2ggcHJpb3JpdGllcy4g
Ki8NCiAgICAgICAgaWYgKHNjLT5wcmlvcml0eSA9PSAxICYmICFzYy0+bnJfcmVjbGFpbWVkKQ0K
ICAgICAgICAgICAgICAgIHJlY2xhaW1fdGhyb3R0bGUocGdkYXQsIFZNU0NBTl9USFJPVFRMRV9O
T1BST0dSRVNTKTsNCiB9DQpAQCAtNzA2NCw3ICs3MDY0LDcgQEAgc3RhdGljIGludCBiYWxhbmNl
X3BnZGF0KHBnX2RhdGFfdCAqcGdkYXQsIGludCBvcmRlciwgaW50IGhpZ2hlc3Rfem9uZWlkeCkN
Cg0KICAgICAgICAgICAgICAgIC8qDQogICAgICAgICAgICAgICAgICogVGhlcmUgc2hvdWxkIGJl
IG5vIG5lZWQgdG8gcmFpc2UgdGhlIHNjYW5uaW5nIHByaW9yaXR5IGlmDQotICAgICAgICAgICAg
ICAgICogZW5vdWdoIHBhZ2VzIGFyZSBhbHJlYWR5IGJlaW5nIHNjYW5uZWQgdGhhdCB0aGF0IGhp
Z2gNCisgICAgICAgICAgICAgICAgKiBlbm91Z2ggcGFnZXMgYXJlIGFscmVhZHkgYmVpbmcgc2Nh
bm5lZCB0aGF0IHRoZSBoaWdoDQogICAgICAgICAgICAgICAgICogd2F0ZXJtYXJrIHdvdWxkIGJl
IG1ldCBhdCAxMDAlIGVmZmljaWVuY3kuDQogICAgICAgICAgICAgICAgICovDQogICAgICAgICAg
ICAgICAgaWYgKGtzd2FwZF9zaHJpbmtfbm9kZShwZ2RhdCwgJnNjKSkNCg0K

--_000_a03cb4aae2b645d3a78905425d0e2ecdxiaomicom_
Content-Type: text/html; charset="gb2312"
Content-Transfer-Encoding: quoted-printable

<!DOCTYPE html>
<html>
<head>
<meta http-equiv=3D"Content-Type" content=3D"text/html; charset=3Dgb2312">
</head>
<body>
<style type=3D"text/css" style=3D"display:none;"><!-- P {margin-top:0;margi=
n-bottom:0;} --></style>
<div id=3D"divtagdefaultwrapper" style=3D"font-size:12pt;color:#000000;font=
-family:Calibri,Helvetica,sans-serif;" dir=3D"ltr">
<p>ok, thanks.</p>
</div>
<hr style=3D"display:inline-block;width:98%" tabindex=3D"-1">
<div id=3D"divRplyFwdMsg" dir=3D"ltr"><font face=3D"Calibri, sans-serif" st=
yle=3D"font-size:11pt" color=3D"#000000"><b>=B7=A2=BC=FE=C8=CB:</b> Donet T=
om &lt;donettom@linux.ibm.com&gt;<br>
<b>=B7=A2=CB=CD=CA=B1=BC=E4:</b> 2026=C4=EA4=D4=C216=C8=D5 13:47:29<br>
<b>=CA=D5=BC=FE=C8=CB:</b> Xiang Gao; akpm@linux-foundation.org; axelrasmus=
sen@google.com; yuanchu@google.com; hannes@cmpxchg.org<br>
<b>=B3=AD=CB=CD:</b> weixugc@google.com; david@kernel.org; mhocko@kernel.or=
g; zhengqi.arch@bytedance.com; shakeel.butt@linux.dev; ljs@kernel.org; baoh=
ua@kernel.org; linux-mm@kvack.org; linux-kernel@vger.kernel.org; =B8=DF=CF=
=E8<br>
<b>=D6=F7=CC=E2:</b> [External Mail]Re: [PATCH v2] mm/vmscan: fix typos in =
comments</font>
<div>&nbsp;</div>
</div>
<div>
<p style=3D"border:1px; border-style:solid; border-color: #FECF8C; backgrou=
nd-color: #FECF8C; padding: 0.3em;">
<span style=3D"font-size:12.0pt;color:black;"><b>[=CD=E2=B2=BF=D3=CA=BC=FE]=
</span></b> <span style=3D"font-size:10.0pt;color:black">
=B4=CB=D3=CA=BC=FE=C0=B4=D4=B4=D3=DA=D0=A1=C3=D7=B9=AB=CB=BE=CD=E2=B2=BF=A3=
=AC=C7=EB=BD=F7=C9=F7=B4=A6=C0=ED=A1=A3=C8=F4=B6=D4=D3=CA=BC=FE=B0=B2=C8=AB=
=D0=D4=B4=E6=D2=C9=A3=AC=C7=EB=BD=AB=D3=CA=BC=FE=D7=AA=B7=A2=B8=F8misec@xia=
omi.com=BD=F8=D0=D0=B7=B4=C0=A1</span></p>
<div>
<p><font face=3D"monospace">Hi</font></p>
<div class=3D"moz-cite-prefix">On 4/16/26 10:45 AM, Xiang Gao wrote:<br>
</div>
<blockquote type=3D"cite" cite=3D"mid:20260416051533.708909-1-gxxa03070307@=
gmail.com">
<pre wrap=3D"" class=3D"moz-quote-pre">From: Xiang Gao <a class=3D"moz-txt-=
link-rfc2396E" href=3D"mailto:gaoxiang17@xiaomi.com">&lt;gaoxiang17@xiaomi.=
com&gt;</a>

Fix three typos in comments:

- Line 112: &quot;zome_reclaim_mode&quot; -&gt; &quot;zone_reclaim_mode&quo=
t;
- Line 6208: &quot;prioities&quot; -&gt; &quot;priorities&quot;
- Line 7067: &quot;that that high&quot; -&gt; &quot;that the high&quot; (du=
plicated word)

Signed-off-by: Xiang Gao <a class=3D"moz-txt-link-rfc2396E" href=3D"mailto:=
gaoxiang17@xiaomi.com">&lt;gaoxiang17@xiaomi.com&gt;</a>
Reviewed-by: Barry Song <a class=3D"moz-txt-link-rfc2396E" href=3D"mailto:b=
aohua@kernel.org">&lt;baohua@kernel.org&gt;</a>
</pre>
<p><br>
</p>
<pre wrap=3D"" class=3D"moz-quote-pre"></pre>
</blockquote>
<p><font face=3D"monospace"><br>
It might be better to send v2 as a new series next time =A1=AAjust a sugges=
tion.<br>
<br>
</font></p>
<p id=3D"b" style=3D"overflow-wrap: anywhere; font-size: 13px; font-family:=
 monospace; background: rgb(255, 255, 255); color: rgb(0, 0, 51); white-spa=
ce: pre-wrap; font-style: normal; font-variant-ligatures: normal; font-vari=
ant-caps: normal; font-weight: 400; letter-spacing: normal; orphans: 2; tex=
t-align: start; text-indent: 0px; text-transform: none; widows: 2; word-spa=
cing: 0px; -webkit-text-stroke-width: 0px; text-decoration-thickness: initi=
al; text-decoration-style: initial; text-decoration-color: initial;">
LGTM Reviewed by: Donet Tom <a class=3D"moz-txt-link-rfc2396E" href=3D"mail=
to:donettom@linux.ibm.com">
&lt;donettom@linux.ibm.com&gt;</a> -Donet</p>
<p><br>
</p>
<blockquote type=3D"cite" cite=3D"mid:20260416051533.708909-1-gxxa03070307@=
gmail.com">
<pre wrap=3D"" class=3D"moz-quote-pre">
---
 mm/vmscan.c | 6 &#43;&#43;&#43;---
 1 file changed, 3 insertions(&#43;), 3 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 0fc9373e8251..710fbe1ee151 100644
--- a/mm/vmscan.c
&#43;&#43;&#43; b/mm/vmscan.c
@@ -109,7 &#43;109,7 @@ struct scan_control {
 	/* zone_reclaim_mode */
 	unsigned int may_unmap:1;
=20
-	/* zome_reclaim_mode, boost reclaim, cgroup restrictions */
&#43;	/* zone_reclaim_mode, boost reclaim, cgroup restrictions */
 	unsigned int may_swap:1;
=20
 	/* Not allow cache_trim_mode to be turned on as part of reclaim? */
@@ -6205,7 &#43;6205,7 @@ static void consider_reclaim_throttle(pg_data_t *=
pgdat, struct scan_control *sc)
 	if (current_is_kswapd() || cgroup_reclaim(sc))
 		return;
=20
-	/* Throttle if making no progress at high prioities. */
&#43;	/* Throttle if making no progress at high priorities. */
 	if (sc-&gt;priority =3D=3D 1 &amp;&amp; !sc-&gt;nr_reclaimed)
 		reclaim_throttle(pgdat, VMSCAN_THROTTLE_NOPROGRESS);
 }
@@ -7064,7 &#43;7064,7 @@ static int balance_pgdat(pg_data_t *pgdat, int or=
der, int highest_zoneidx)
=20
 		/*
 		 * There should be no need to raise the scanning priority if
-		 * enough pages are already being scanned that that high
&#43;		 * enough pages are already being scanned that the high
 		 * watermark would be met at 100% efficiency.
 		 */
 		if (kswapd_shrink_node(pgdat, &amp;sc))
</pre>
</blockquote>
</div>
</div>
</body>
</html>

--_000_a03cb4aae2b645d3a78905425d0e2ecdxiaomicom_--


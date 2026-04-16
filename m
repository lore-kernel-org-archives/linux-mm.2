Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 323FCF433FE
	for <linux-mm@archiver.kernel.org>; Thu, 16 Apr 2026 06:26:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 965BF6B008C; Thu, 16 Apr 2026 02:26:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 93D316B0092; Thu, 16 Apr 2026 02:26:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 87A906B0093; Thu, 16 Apr 2026 02:26:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 745B16B008C
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 02:26:27 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 0DBB513B917
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 06:26:27 +0000 (UTC)
X-FDA: 84663434814.27.A85818E
Received: from outboundhk.mxmail.xiaomi.com (outboundhk.mxmail.xiaomi.com [207.226.244.123])
	by imf24.hostedemail.com (Postfix) with ESMTP id 6B94A180005
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 06:26:18 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=xiaomi.com;
	spf=pass (imf24.hostedemail.com: domain of gaoxiang17@xiaomi.com designates 207.226.244.123 as permitted sender) smtp.mailfrom=gaoxiang17@xiaomi.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776320785;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=lnhS5Pc/r5EZVM+ByN0En3125fjO5BelGSrSVj5zf4M=;
	b=DkX5AfYRo5RLBz03rt5YuGH6g2If+cXwReWVphOUYevJuBvX1OelVx1KqVN7wk1G43LZD3
	8lb13nToJgPtfilO7P1iQiuPeSWxz/Y8Btr5Doa0Ud0DNwu4680bRf1Q+gTsKxdHOjlHnw
	OzCac8dOjZcCuKovlIgET6866a0s5Fw=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=xiaomi.com;
	spf=pass (imf24.hostedemail.com: domain of gaoxiang17@xiaomi.com designates 207.226.244.123 as permitted sender) smtp.mailfrom=gaoxiang17@xiaomi.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776320785; a=rsa-sha256;
	cv=none;
	b=iWPN0N4HAkhRX/wbeJ3R1RmQtUAqcN+dmKRdvwtlP0GLESi7JPIkPju9VThVXpBbmcUm1S
	XzPbhLyHQqscNTvefAq01ZS7WCYKJEXFkOMFz+ESgg6GfGCDYQy5RkNhPD8pLQCCjgjZap
	SA5IYn4mD0tr348pfHt8vU4BBkOsqRw=
X-CSE-ConnectionGUID: FHr533+7TRutS/a2xWP5jw==
X-CSE-MsgGUID: AkbmJGO/TSOHkSMIeqXWqg==
X-IronPort-AV: E=Sophos;i="6.23,181,1770566400"; 
   d="scan'208,217";a="173025905"
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
Thread-Index: AQHczWSlSWKMFo0SjkWhpn9x7qPh7LXhOPLO
Date: Thu, 16 Apr 2026 06:25:52 +0000
Message-ID: <3f9b2425baf24df6a13a796e3a385ea3@xiaomi.com>
References: <20260416024248.687943-1-gxxa03070307@gmail.com>
 <20260416051533.708909-1-gxxa03070307@gmail.com>,<3d445fdf-6bbf-4d67-8a4f-eac7b5138ada@linux.ibm.com>
In-Reply-To: <3d445fdf-6bbf-4d67-8a4f-eac7b5138ada@linux.ibm.com>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-originating-ip: [10.237.88.13]
Content-Type: multipart/alternative;
	boundary="_000_3f9b2425baf24df6a13a796e3a385ea3xiaomicom_"
MIME-Version: 1.0
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 6B94A180005
X-Stat-Signature: wzu85nwfefry4np3y6r3xmzwbh8uwb54
X-HE-Tag: 1776320778-56315
X-HE-Meta: U2FsdGVkX19EhgNMZZvh/pS930kQGcWJpl6siK7gqKy1BD58cr6dYkh7MGOPPb4ecJB0H6B82R0x24vrQ5fyxE836YkemhmFBNEvsn9zJmomLPe3ckl0JBW43pbDZYqNpR5TnhWSVOADU2UkZ8tDhMmyyqJV8D4hQgbaRgKMRGv9+eBNrGqUBGw4+DOp7yjPE2MNBMBUjp1uYuW8X6ga21nlnfwVRRlFXNIwjtQ2ZM/qBWtR1wcmBO+z/uLNM2Gmcc9hFCaqUqmVSrA8odZs0L9mceQokBsA7LdGw+XrzqdMsTiVoxmFySvT3SXHj0JR/tvpUdRrWXSADJpqTk9gWj7V+0Nunqavj+3h+INIUxh/VbSZwZ6ZUq7ffWss7fMBtwLjr1X9W947UXVP7jE2RNJpJ552qNHjTH0Hq677PPxcsrntZZUYZsFSqgKot9VRMD++aRWkj55ZklQDf+2bVfALu5+hAnbu7F+RVm/iHZXJm+9+rPL6z1oNVfA8HmJMgUW0/GItsptIgDKkHJk9wegIUgtYJ83EYX5IHVNVSOg6be69FCp9PVeeAiyZI0q8aHxCTIaeNiGQ4TkCyDmhyQTuByUI9r1EaMoC7h0sLyv+v3r76ffQyby2qooJylB4uT+MoIcwIYvfo5VFggOU7nT9J7sL/lPDV+PGd+L1nBncW8geiVQ0zKokkVyy7tqNTVbWaISjDlBa88JoQBMlS/PYH/p5H2QM7o1YxBvkrCnoJoV4TzVfzij8aAMm+SanRS8n6bRnzaAX+GlRdcv09gowNNUXOci26SD6bmiufMUf26HfKFGTsj+crrVJhDgPM6BB+UELlMVioWN3Cx2zWFkpZyE2XDTgjQWKoyGXwmuwRCln6HtS+qV10WNSrCKliYvfL7zA7W/bH4DTd2A9fhe/vEo9aaA+zrmIZtpUKqjWWMHZ2CDoEF3eMSs7GtUu5zYWYQU/fTwYYJb/Iqf
 osfxKQaG
 CV7h/1+Er2m9qiKo4LVr4MJsactbMTOzmOyjn5PDpOi9BuglT7PDZq7wZddi6bHI2xZB43vKkaGy7wRamoi+4mfTA9QYjsD6BY4hTLfZr13rrNOL2YiBXpzZlrgV09W8TY3ZVJEE4KnZnkD+muS0Ogxpq3wBYUPnoVLgz4I8uRs7FX1PjaobE42ppgiLapubYP09O2xdhFcTOq26NM+w0yN7PUEvCTa+uC/z52s76zwubIBUk4HxMMl8CNCXhrRekEh3O0R0F2/gxqfISfge7WNkLnnEjkoP6mS5wKvXlPcLiwT5t/51ABwSJrMEZyOce/BhB8H4tP9bMd/z6+JhCR2eKxr6zb5c0feeNuhZITLWUxCJjdcMbWaUhDM7uRJLIbt1WKV6BMNocyQ7UXs5qR4pHd3DEDgQrYo/LIp01PhTuy3Ei8HY++Nz0JyD6rszjR+3nSeE/Tjnfdf1a4rRy0nKSDoHuYpm5CfXmWSPzElutStX4gszy2Q2qRMTlvipWU1xxOHZ+8dZD3ofPTDI8tAcStQ3zd65I/w+AFsMhaQw7lWuQU6ig3nq5NWrZRG9g39adhDLfmRViIb2ioYziCLguCKFZDRO81ZeP0G2TFiwiJWA1RyG5zorPXYVU0EBwpfyil7VG7JC3vOpBuKA3F0D4Ghd6ekTdf1OZwTgZrp4z06YiSTAlQn1PLf8iMJv6p13LSMPAgNsa1z2XJkYZSDQJ0A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

--_000_3f9b2425baf24df6a13a796e3a385ea3xiaomicom_
Content-Type: text/plain; charset="gb2312"
Content-Transfer-Encoding: base64

SSd2ZSBzZW50IHRoZSB1cGRhdGVkIHBhdGNoZXMgYXMgdjMgd2l0aCB5b3VyIFJldmlld2VkLWJ5
IHRhZyBpbmNsdWRlZC4gVGhhbmsgeW91IGZvciB0aGUgcmV2aWV3IGFuZCB0aGUgc3VnZ2VzdGlv
biChqiBJJ2xsIHNlbmQgdjIvdjMgYXMgbmV3IHNlcmllcyBnb2luZyBmb3J3YXJkLg0KDQpfX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fXw0Kt6K8/sjLOiBEb25ldCBUb20gPGRvbmV0dG9t
QGxpbnV4LmlibS5jb20+DQq3osvNyrG85DogMjAyNsTqNNTCMTbI1SAxMzo0NzoyOQ0KytW8/sjL
OiBYaWFuZyBHYW87IGFrcG1AbGludXgtZm91bmRhdGlvbi5vcmc7IGF4ZWxyYXNtdXNzZW5AZ29v
Z2xlLmNvbTsgeXVhbmNodUBnb29nbGUuY29tOyBoYW5uZXNAY21weGNoZy5vcmcNCrOty806IHdl
aXh1Z2NAZ29vZ2xlLmNvbTsgZGF2aWRAa2VybmVsLm9yZzsgbWhvY2tvQGtlcm5lbC5vcmc7IHpo
ZW5ncWkuYXJjaEBieXRlZGFuY2UuY29tOyBzaGFrZWVsLmJ1dHRAbGludXguZGV2OyBsanNAa2Vy
bmVsLm9yZzsgYmFvaHVhQGtlcm5lbC5vcmc7IGxpbnV4LW1tQGt2YWNrLm9yZzsgbGludXgta2Vy
bmVsQHZnZXIua2VybmVsLm9yZzsguN/P6A0K1vfM4jogW0V4dGVybmFsIE1haWxdUmU6IFtQQVRD
SCB2Ml0gbW0vdm1zY2FuOiBmaXggdHlwb3MgaW4gY29tbWVudHMNCg0KDQpbzeKyv9PKvP5dILTL
08q8/sC01LTT2tChw9e5q8u+zeKyv6Osx+u998n3tKbA7aGjyPS21NPKvP6wssir0NS05tLJo6zH
672r08q8/teqt6K4+G1pc2VjQHhpYW9taS5jb229+NDQt7TAoQ0KDQpIaQ0KDQpPbiA0LzE2LzI2
IDEwOjQ1IEFNLCBYaWFuZyBHYW8gd3JvdGU6DQoNCkZyb206IFhpYW5nIEdhbyA8Z2FveGlhbmcx
N0B4aWFvbWkuY29tPjxtYWlsdG86Z2FveGlhbmcxN0B4aWFvbWkuY29tPg0KDQpGaXggdGhyZWUg
dHlwb3MgaW4gY29tbWVudHM6DQoNCi0gTGluZSAxMTI6ICJ6b21lX3JlY2xhaW1fbW9kZSIgLT4g
InpvbmVfcmVjbGFpbV9tb2RlIg0KLSBMaW5lIDYyMDg6ICJwcmlvaXRpZXMiIC0+ICJwcmlvcml0
aWVzIg0KLSBMaW5lIDcwNjc6ICJ0aGF0IHRoYXQgaGlnaCIgLT4gInRoYXQgdGhlIGhpZ2giIChk
dXBsaWNhdGVkIHdvcmQpDQoNClNpZ25lZC1vZmYtYnk6IFhpYW5nIEdhbyA8Z2FveGlhbmcxN0B4
aWFvbWkuY29tPjxtYWlsdG86Z2FveGlhbmcxN0B4aWFvbWkuY29tPg0KUmV2aWV3ZWQtYnk6IEJh
cnJ5IFNvbmcgPGJhb2h1YUBrZXJuZWwub3JnPjxtYWlsdG86YmFvaHVhQGtlcm5lbC5vcmc+DQoN
Cg0KDQpJdCBtaWdodCBiZSBiZXR0ZXIgdG8gc2VuZCB2MiBhcyBhIG5ldyBzZXJpZXMgbmV4dCB0
aW1lIKGqanVzdCBhIHN1Z2dlc3Rpb24uDQoNCg0KTEdUTSBSZXZpZXdlZCBieTogRG9uZXQgVG9t
IDxkb25ldHRvbUBsaW51eC5pYm0uY29tPjxtYWlsdG86ZG9uZXR0b21AbGludXguaWJtLmNvbT4g
LURvbmV0DQoNCg0KDQotLS0NCiBtbS92bXNjYW4uYyB8IDYgKysrLS0tDQogMSBmaWxlIGNoYW5n
ZWQsIDMgaW5zZXJ0aW9ucygrKSwgMyBkZWxldGlvbnMoLSkNCg0KZGlmZiAtLWdpdCBhL21tL3Zt
c2Nhbi5jIGIvbW0vdm1zY2FuLmMNCmluZGV4IDBmYzkzNzNlODI1MS4uNzEwZmJlMWVlMTUxIDEw
MDY0NA0KLS0tIGEvbW0vdm1zY2FuLmMNCisrKyBiL21tL3Ztc2Nhbi5jDQpAQCAtMTA5LDcgKzEw
OSw3IEBAIHN0cnVjdCBzY2FuX2NvbnRyb2wgew0KICAgICAgICAvKiB6b25lX3JlY2xhaW1fbW9k
ZSAqLw0KICAgICAgICB1bnNpZ25lZCBpbnQgbWF5X3VubWFwOjE7DQoNCi0gICAgICAgLyogem9t
ZV9yZWNsYWltX21vZGUsIGJvb3N0IHJlY2xhaW0sIGNncm91cCByZXN0cmljdGlvbnMgKi8NCisg
ICAgICAgLyogem9uZV9yZWNsYWltX21vZGUsIGJvb3N0IHJlY2xhaW0sIGNncm91cCByZXN0cmlj
dGlvbnMgKi8NCiAgICAgICAgdW5zaWduZWQgaW50IG1heV9zd2FwOjE7DQoNCiAgICAgICAgLyog
Tm90IGFsbG93IGNhY2hlX3RyaW1fbW9kZSB0byBiZSB0dXJuZWQgb24gYXMgcGFydCBvZiByZWNs
YWltPyAqLw0KQEAgLTYyMDUsNyArNjIwNSw3IEBAIHN0YXRpYyB2b2lkIGNvbnNpZGVyX3JlY2xh
aW1fdGhyb3R0bGUocGdfZGF0YV90ICpwZ2RhdCwgc3RydWN0IHNjYW5fY29udHJvbCAqc2MpDQog
ICAgICAgIGlmIChjdXJyZW50X2lzX2tzd2FwZCgpIHx8IGNncm91cF9yZWNsYWltKHNjKSkNCiAg
ICAgICAgICAgICAgICByZXR1cm47DQoNCi0gICAgICAgLyogVGhyb3R0bGUgaWYgbWFraW5nIG5v
IHByb2dyZXNzIGF0IGhpZ2ggcHJpb2l0aWVzLiAqLw0KKyAgICAgICAvKiBUaHJvdHRsZSBpZiBt
YWtpbmcgbm8gcHJvZ3Jlc3MgYXQgaGlnaCBwcmlvcml0aWVzLiAqLw0KICAgICAgICBpZiAoc2Mt
PnByaW9yaXR5ID09IDEgJiYgIXNjLT5ucl9yZWNsYWltZWQpDQogICAgICAgICAgICAgICAgcmVj
bGFpbV90aHJvdHRsZShwZ2RhdCwgVk1TQ0FOX1RIUk9UVExFX05PUFJPR1JFU1MpOw0KIH0NCkBA
IC03MDY0LDcgKzcwNjQsNyBAQCBzdGF0aWMgaW50IGJhbGFuY2VfcGdkYXQocGdfZGF0YV90ICpw
Z2RhdCwgaW50IG9yZGVyLCBpbnQgaGlnaGVzdF96b25laWR4KQ0KDQogICAgICAgICAgICAgICAg
LyoNCiAgICAgICAgICAgICAgICAgKiBUaGVyZSBzaG91bGQgYmUgbm8gbmVlZCB0byByYWlzZSB0
aGUgc2Nhbm5pbmcgcHJpb3JpdHkgaWYNCi0gICAgICAgICAgICAgICAgKiBlbm91Z2ggcGFnZXMg
YXJlIGFscmVhZHkgYmVpbmcgc2Nhbm5lZCB0aGF0IHRoYXQgaGlnaA0KKyAgICAgICAgICAgICAg
ICAqIGVub3VnaCBwYWdlcyBhcmUgYWxyZWFkeSBiZWluZyBzY2FubmVkIHRoYXQgdGhlIGhpZ2gN
CiAgICAgICAgICAgICAgICAgKiB3YXRlcm1hcmsgd291bGQgYmUgbWV0IGF0IDEwMCUgZWZmaWNp
ZW5jeS4NCiAgICAgICAgICAgICAgICAgKi8NCiAgICAgICAgICAgICAgICBpZiAoa3N3YXBkX3No
cmlua19ub2RlKHBnZGF0LCAmc2MpKQ0KDQo=

--_000_3f9b2425baf24df6a13a796e3a385ea3xiaomicom_
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
<p><span>I've sent the updated patches as v3 with your Reviewed-by tag incl=
uded. Thank you for the review and the suggestion =A1=AA I'll send v2/v3 as=
 new series going forward.</span><br>
</p>
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

--_000_3f9b2425baf24df6a13a796e3a385ea3xiaomicom_--


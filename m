Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1BF9ECA0EF8
	for <linux-mm@archiver.kernel.org>; Wed, 20 Aug 2025 01:56:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A79CA8E001A; Tue, 19 Aug 2025 21:56:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A29BA8E0011; Tue, 19 Aug 2025 21:56:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 93F8F8E001A; Tue, 19 Aug 2025 21:56:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 8525A8E0011
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 21:56:02 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 53A131DC843
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 01:56:02 +0000 (UTC)
X-FDA: 83795470164.11.3C27243
Received: from outboundhk.mxmail.xiaomi.com (outboundhk.mxmail.xiaomi.com [207.226.244.123])
	by imf03.hostedemail.com (Postfix) with ESMTP id B4C2B2000C
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 01:55:59 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=none;
	spf=pass (imf03.hostedemail.com: domain of gaoxiang17@xiaomi.com designates 207.226.244.123 as permitted sender) smtp.mailfrom=gaoxiang17@xiaomi.com;
	dmarc=pass (policy=quarantine) header.from=xiaomi.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755654960;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=/PxZ0K/imORV5g/LbBX2rwLWmVTf8kpJO8I5B8T+A/w=;
	b=KDUG6BYsD19PqvrhpbgFzP056OomM3hWobpl1MVCBa8xt1MNRv7GSFcNiKZg7Fumr6zn2T
	2XyLpJRQhiDeFDykpU4nr15Mp0vBBGbipMaScfnmNkWlnb6tS35IJc7SvGmKexsV3lvoYe
	eJDlgBKycJdJPcgBcBdjtbo4LWrph+o=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=none;
	spf=pass (imf03.hostedemail.com: domain of gaoxiang17@xiaomi.com designates 207.226.244.123 as permitted sender) smtp.mailfrom=gaoxiang17@xiaomi.com;
	dmarc=pass (policy=quarantine) header.from=xiaomi.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755654960; a=rsa-sha256;
	cv=none;
	b=L0cBN9sxCk9dh9j7y8AJASGJl+ofSl7iEVptc5BeMD5NZrI2506eL3ce27ptxUu6sTyPiI
	85RYoABUk0+Enzpg1AvwVf/zz6sU9iXVHGq8yZ9Up0u0Tja5dMPPvKpzr1icBbfE0Ocp4+
	usaVDhbSxvq1LUquSaRWCuAfVr/RjjM=
X-CSE-ConnectionGUID: yX7lUAPcT1u07ynrPc99QQ==
X-CSE-MsgGUID: rTZUvJXASOS4K+xmuJuAJg==
X-IronPort-AV: E=Sophos;i="6.17,302,1747670400"; 
   d="scan'208,217";a="149743449"
From: =?gb2312?B?uN/P6A==?= <gaoxiang17@xiaomi.com>
To: Andrew Morton <akpm@linux-foundation.org>, Xiang Gao
	<gxxa03070307@gmail.com>
CC: "david@redhat.com" <david@redhat.com>, "lorenzo.stoakes@oracle.com"
	<lorenzo.stoakes@oracle.com>, "Liam.Howlett@oracle.com"
	<Liam.Howlett@oracle.com>, "vbabka@suse.cz" <vbabka@suse.cz>,
	"rppt@kernel.org" <rppt@kernel.org>, "surenb@google.com" <surenb@google.com>,
	"mhocko@suse.com" <mhocko@suse.com>, "linux-mm@kvack.org"
	<linux-mm@kvack.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>
Subject: =?gb2312?B?tPC4tDogW0V4dGVybmFsIE1haWxdUmU6IFtQQVRDSF0gbW0vY21hOiBhZGQg?=
 =?gb2312?B?J2F2YWlsYWJsZSBjb3VudCcgYW5kICd0b3RhbCBjb3VudCcgdG8gdHJhY2Vf?=
 =?gb2312?B?Y21hX2FsbG9jX3N0YXJ0?=
Thread-Topic: [External Mail]Re: [PATCH] mm/cma: add 'available count' and
 'total count' to trace_cma_alloc_start
Thread-Index: AQHcEWnAKHGWgRYZJUe2Ap56P51y5LRqx/cW
Date: Wed, 20 Aug 2025 01:55:42 +0000
Message-ID: <2a67b098459f4f40b2d5f8b40d260aa5@xiaomi.com>
References: <20250819134817.247495-1-gxxa03070307@gmail.com>,<20250819173115.55194150617998021b4130b9@linux-foundation.org>
In-Reply-To: <20250819173115.55194150617998021b4130b9@linux-foundation.org>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-originating-ip: [10.237.88.13]
Content-Type: multipart/alternative;
	boundary="_000_2a67b098459f4f40b2d5f8b40d260aa5xiaomicom_"
MIME-Version: 1.0
X-Rspamd-Queue-Id: B4C2B2000C
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: 91wa8g9qemzw8cnqiie8i5g1nqa5ic9t
X-HE-Tag: 1755654959-908599
X-HE-Meta: U2FsdGVkX18wOq0FPmvwwDFsERguolY0+HerFMZoqWohevMQ3f5SmsFKGmIMMLFnwbBevxks5XZNl2uk3toiSjx8GDMD3ISiXs335I14YMCGUVqLMagX7r7TT4bQrwlOwgedxy4SSQYhgbrhq68e75CS8M3wGfH4AVrN90qd68848hcTSeSHKnx9ybjhnPQF/LF8JnRUwiu1NIMi9S/ClD4d2mVyyhRE9STX8oFPP7oo6zca74ffxLD6UX8g9v9HzCZ23AEBUCfXovD+Li2xN0qVRmdc31K5Gedj0bRt4tdIaCTJQCa++b8T8df/LSmnUimiT3YNWOc40mEpa3JGTCz/pdwDXoeBCgjmzDXih9yAN/SPLD213GxRAcEySdKLMUl/MsjFh5rJZS5c31hx/aMEgzSy5t/OZk8MviNNjZCFwYdnb2M7W43zZijhl2bpplpwd3qBJ0KyfSPmTrNgDc5otUu+dsYr7o+XCOx2L1icXxFtnhCc7GD92d6VOsye25YGWD0KQtBAtMgUCpnQkDWk7qmKcSMCIsS0UiZxcR6f0l6lB6tq1ISQ2+lKxwpSljh0TOmZtIJic8GJTESaPWAbGh7Y4E1E9kruJoRaWW9Lehdbj45WL4WtawQQNWsj7luoSMjqoBKtHhfdjrP6wcTYfjVXKvQax3MHVdSNd5TLuQkzUqYTPaM4ZDqNuIe5PdKAOgQ8TubIhwOGNhu3GvZ77i0pSPGrLDCaZ0fE4/wLebkecavuK9Gie+fqNaz14J20d4H9eM3QVvbRLd/7c0Q8euTSclF0056YI35gUI0rLXqeFQ87fZOu9a5pg8WT3/42MY1me6Ng/KJOpC+GJvgBuHpAAf2XFE/2fMSUFJWW1Q7NSoRk0ge1QluuMK4r1dqdwNpFWov/58sELio9cUqdHWRkiUA7M3oHZKOYbEQdP+G7+0KHsekte1lXD9ZeVIbgWnABMcLYbn3Zf1h
 PcGpGH84
 YsW4elz9jAd/RQ1xt6sr4Q82dYCuhHRZe5VdwR3gf9x+IQkfbeUVQt9kzQW6rl5/F4UMOTHgCF0y8Den6AQzikVrX78Tv/ijpoZCAQex4pLrcNbA6YEO/x/0mFLKYj6RGBL1R+IJzS+iAaKpfIdUnEDIzGtdsThwNi5hiC5EMYpcZ6m+K9LKgkQXIaIvqSHJWHJh/N/EFKLvcQvJR9YfaGiFiDLZUl7N00/aAtsDumfbJDHwF9kmOOSM3dFSL75kwcU7MV7K6IMiguJvqBs0XOu/x577JZBvyTC21dVOwiN9x0rSQHa4TQw1XgxKBQkKn7exZ2j+QcWMZAIN6lOlCV8lrmrQ1bgj7CeorrPvYUJXAavSuQ/RLcEBCAyFhepBf+rCI8IiscnOjtXy/1NVckiZr0zYddpBjwSI61N0xJh2GCdIq0bbU2C/VpUvE6Syhv48QM5gMH71hRAr8/VBMiTSlUlBEvtVTJQnMNjoEyMotnUEXwyvfZ022liwsyDCvEQcLxAEzispioLf4EfGX+gT/gLDCM+9WrBDWCMf9QJT74uLWi5VsUHCD66xLmwxBRP2asu2RV1oFW8PhrHAD1ggEXlvAjUQ/z055NX/KKvLyNaXFr9nXFhLGwoW7FzCwnWGGNIzZsnf0hgfPj0+j4LYkQ8u4Oyp6Uy0Rw72+BU2yaQpdsuofxq7Vj08fxValgtik8GL5EBE5hdUPIv1wnfQe4B47D9nYSD/JhNiZpoTRKkHoTyqy7aWCaMjdzs5fCZOdfHao9p7/Bnc=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

--_000_2a67b098459f4f40b2d5f8b40d260aa5xiaomicom_
Content-Type: text/plain; charset="gb2312"
Content-Transfer-Encoding: base64

DQpTb3JyeSwgSSd2ZSBjaGFuZ2VkIGl0Lg0KDQpfX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fXw0Kt6K8/sjLOiBBbmRyZXcgTW9ydG9uIDxha3BtQGxpbnV4LWZvdW5kYXRpb24ub3JnPg0K
t6LLzcqxvOQ6IDIwMjXE6jjUwjIwyNUgODozMToxNQ0KytW8/sjLOiBYaWFuZyBHYW8NCrOty806
IGRhdmlkQHJlZGhhdC5jb207IGxvcmVuem8uc3RvYWtlc0BvcmFjbGUuY29tOyBMaWFtLkhvd2xl
dHRAb3JhY2xlLmNvbTsgdmJhYmthQHN1c2UuY3o7IHJwcHRAa2VybmVsLm9yZzsgc3VyZW5iQGdv
b2dsZS5jb207IG1ob2Nrb0BzdXNlLmNvbTsgbGludXgtbW1Aa3ZhY2sub3JnOyBsaW51eC1rZXJu
ZWxAdmdlci5rZXJuZWwub3JnOyC438/oDQrW98ziOiBbRXh0ZXJuYWwgTWFpbF1SZTogW1BBVENI
XSBtbS9jbWE6IGFkZCAnYXZhaWxhYmxlIGNvdW50JyBhbmQgJ3RvdGFsIGNvdW50JyB0byB0cmFj
ZV9jbWFfYWxsb2Nfc3RhcnQNCg0KW83isr/Tyrz+XSC0y9PKvP7AtNS009rQocPXuavLvs3isr+j
rMfrvffJ97SmwO2ho8j0ttTTyrz+sLLIq9DUtObSyaOsx+u9q9PKvP7XqreiuPhtaXNlY0B4aWFv
bWkuY29tvfjQ0Le0wKENCg0KT24gVHVlLCAxOSBBdWcgMjAyNSAyMTo0ODoxNyArMDgwMCBYaWFu
ZyBHYW8gPGd4eGEwMzA3MDMwN0BnbWFpbC5jb20+IHdyb3RlOg0KDQo+IEZyb206IGdhb3hpYW5n
MTcgPGdhb3hpYW5nMTdAeGlhb21pLmNvbT4NCj4NCj4gVGhpcyBtYWtlcyBjbWEgaW5mbyBtb3Jl
IGludHVpdGl2ZSBkdXJpbmcgZGVidWdnaW5nLg0KPg0KPiAuLi4NCj4NCj4gLS0tIGEvaW5jbHVk
ZS90cmFjZS9ldmVudHMvY21hLmgNCj4gKysrIGIvaW5jbHVkZS90cmFjZS9ldmVudHMvY21hLmgN
Cj4NCj4gLi4uDQo+DQo+ICAgICAgIFRQX1NUUlVDVF9fZW50cnkoDQo+ICAgICAgICAgICAgICAg
X19zdHJpbmcobmFtZSwgbmFtZSkNCj4gLSAgICAgICAgICAgICBfX2ZpZWxkKHVuc2lnbmVkIGxv
bmcsIGNvdW50KQ0KPiArICAgICAgICAgICAgIF9fZmllbGQodW5zaWduZWQgbG9uZywgcmVxdWVz
dF9jb3VudCkNCj4gKyAgICAgICAgICAgICBfX2ZpZWxkKHVuc2lnbmVkIGxvbmcsIGF2YWlsYWJs
ZV9jb3VudCkNCj4gKyAgICAgICAgICAgICBfX2ZpZWxkKHVuc2lnbmVkIGxvbmcsIHRvdGFsX2Nv
dW50KQ0KPiAgICAgICAgICAgICAgIF9fZmllbGQodW5zaWduZWQgaW50LCBhbGlnbikNCj4gICAg
ICAgKSwNCj4NCj4gICAgICAgVFBfZmFzdF9hc3NpZ24oDQo+ICAgICAgICAgICAgICAgX19hc3Np
Z25fc3RyKG5hbWUpOw0KPiAtICAgICAgICAgICAgIF9fZW50cnktPmNvdW50ID0gY291bnQ7DQo+
ICsgICAgICAgICAgICAgX19lbnRyeS0+Y291bnQgPSByZXF1ZXN0X2NvdW50Ow0KPiArICAgICAg
ICAgICAgIF9fZW50cnktPmF2YWlsYWJsZV9jb3VudCA9IGF2YWlsYWJsZV9jb3VudDsNCj4gKyAg
ICAgICAgICAgICBfX2VudHJ5LT50b3RhbF9jb3VudCA9IHRvdGFsX2NvdW50Ow0KPiAgICAgICAg
ICAgICAgIF9fZW50cnktPmFsaWduID0gYWxpZ247DQo+ICAgICAgICksDQo+DQo+ICAgICAgIFRQ
X3ByaW50aygibmFtZT0lcyBjb3VudD0lbHUgYWxpZ249JXUiLA0KPiAgICAgICAgICAgICAgICAg
X19nZXRfc3RyKG5hbWUpLA0KPiAtICAgICAgICAgICAgICAgX19lbnRyeS0+Y291bnQsDQo+ICsg
ICAgICAgICAgICAgICBfX2VudHJ5LT5yZXF1ZXN0X2NvdW50LA0KPiArICAgICAgICAgICAgICAg
X19lbnRyeS0+YXZhaWxhYmxlX2NvdW50LA0KPiArICAgICAgICAgICAgICAgX19lbnRyeS0+dG90
YWxfY291bnQsDQo+ICAgICAgICAgICAgICAgICBfX2VudHJ5LT5hbGlnbikNCg0KYWRkcyB0aHJl
ZSBhcmdzIHRvIHRoZSBwcmludGsgYnV0IGRpZG4ndCBhZGQgdGhlaXIgY29udmVyc2lvbnMgdG8g
dGhlDQpwcmludGsgY29udHJvbCBzdHJpbmc/DQoNCg0K

--_000_2a67b098459f4f40b2d5f8b40d260aa5xiaomicom_
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
<p><br>
</p>
<meta content=3D"text/html; charset=3DUTF-8">
<div dir=3D"ltr">
<div id=3D"x_divtagdefaultwrapper" dir=3D"ltr" style=3D"font-size: 12pt; co=
lor: rgb(0, 0, 0); font-family: Calibri, Helvetica, sans-serif, EmojiFont, =
&quot;Apple Color Emoji&quot;, &quot;Segoe UI Emoji&quot;, NotoColorEmoji, =
&quot;Segoe UI Symbol&quot;, &quot;Android Emoji&quot;, EmojiSymbols;">
<p></p>
<div>Sorry, I've changed it.<br>
</div>
<p></p>
</div>
<hr tabindex=3D"-1" style=3D"display:inline-block; width:98%">
<div id=3D"x_divRplyFwdMsg" dir=3D"ltr"><font face=3D"Calibri, sans-serif" =
color=3D"#000000" style=3D"font-size:11pt"><b>=B7=A2=BC=FE=C8=CB:</b> Andre=
w Morton &lt;akpm@linux-foundation.org&gt;<br>
<b>=B7=A2=CB=CD=CA=B1=BC=E4:</b> 2025=C4=EA8=D4=C220=C8=D5 8:31:15<br>
<b>=CA=D5=BC=FE=C8=CB:</b> Xiang Gao<br>
<b>=B3=AD=CB=CD:</b> david@redhat.com; lorenzo.stoakes@oracle.com; Liam.How=
lett@oracle.com; vbabka@suse.cz; rppt@kernel.org; surenb@google.com; mhocko=
@suse.com; linux-mm@kvack.org; linux-kernel@vger.kernel.org; =B8=DF=CF=E8<b=
r>
<b>=D6=F7=CC=E2:</b> [External Mail]Re: [PATCH] mm/cma: add 'available coun=
t' and 'total count' to trace_cma_alloc_start</font>
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
On Tue, 19 Aug 2025 21:48:17 &#43;0800 Xiang Gao &lt;gxxa03070307@gmail.com=
&gt; wrote:<br>
<br>
&gt; From: gaoxiang17 &lt;gaoxiang17@xiaomi.com&gt;<br>
&gt;<br>
&gt; This makes cma info more intuitive during debugging.<br>
&gt;<br>
&gt; ...<br>
&gt;<br>
&gt; --- a/include/trace/events/cma.h<br>
&gt; &#43;&#43;&#43; b/include/trace/events/cma.h<br>
&gt;<br>
&gt; ...<br>
&gt;<br>
&gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; TP_STRUCT__entry(<br>
&gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp; __string(name, name)<br>
&gt; -&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp; __field(unsigned long, count)<br>
&gt; &#43;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp; __field(unsigned long, request_count)<br>
&gt; &#43;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp; __field(unsigned long, available_count)<br>
&gt; &#43;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp; __field(unsigned long, total_count)<br>
&gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp; __field(unsigned int, align)<br>
&gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; ),<br>
&gt;<br>
&gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; TP_fast_assign(<br>
&gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp; __assign_str(name);<br>
&gt; -&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp; __entry-&gt;count =3D count;<br>
&gt; &#43;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp; __entry-&gt;count =3D request_count;<br>
&gt; &#43;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp; __entry-&gt;available_count =3D available_count;<br>
&gt; &#43;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp; __entry-&gt;total_count =3D total_count;<br>
&gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp; __entry-&gt;align =3D align;<br>
&gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; ),<br>
&gt;<br>
&gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; TP_printk(&quot;name=3D%s count=3D=
%lu align=3D%u&quot;,<br>
&gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp; __get_str(name),<br>
&gt; -&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp; __entry-&gt;count,<br>
&gt; &#43;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp; __entry-&gt;request_count,<br>
&gt; &#43;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp; __entry-&gt;available_count,<br>
&gt; &#43;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp; __entry-&gt;total_count,<br>
&gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp; __entry-&gt;align)<br>
<br>
adds three args to the printk but didn't add their conversions to the<br>
printk control string?<br>
<br>
<br>
</div>
</span></font></div>
</body>
</html>

--_000_2a67b098459f4f40b2d5f8b40d260aa5xiaomicom_--


Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 09371CA0EF8
	for <linux-mm@archiver.kernel.org>; Wed, 20 Aug 2025 01:55:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A51E88E0019; Tue, 19 Aug 2025 21:55:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A2D228E0011; Tue, 19 Aug 2025 21:55:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9670A8E0019; Tue, 19 Aug 2025 21:55:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 809868E0011
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 21:55:58 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 2A2241602DE
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 01:55:58 +0000 (UTC)
X-FDA: 83795469996.08.B3F9D62
Received: from outboundhk.mxmail.xiaomi.com (outboundhk.mxmail.xiaomi.com [207.226.244.123])
	by imf03.hostedemail.com (Postfix) with ESMTP id ADF4920005
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 01:55:54 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=none;
	spf=pass (imf03.hostedemail.com: domain of gaoxiang17@xiaomi.com designates 207.226.244.123 as permitted sender) smtp.mailfrom=gaoxiang17@xiaomi.com;
	dmarc=pass (policy=quarantine) header.from=xiaomi.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755654956;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Q2g3EA4kWm6na+gD/Ljp+NpoQhfWOLU2hpuvmfIf2bc=;
	b=KUf/g2EXwxa/+YTRnlZfJ1RS6PuSOo5tVAwQNsN92BVrDt7mQo4wfL+J+BVeZajjY6zfsp
	bLaeSF+ges73v6xxelbOWOJLu7tCDby0CugVLwaKABrlMotlsKCCYfkGe7aLTxx2H/OjHs
	1QghCTgpKwFRhLIlSKSlTORhYMeEjGs=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=none;
	spf=pass (imf03.hostedemail.com: domain of gaoxiang17@xiaomi.com designates 207.226.244.123 as permitted sender) smtp.mailfrom=gaoxiang17@xiaomi.com;
	dmarc=pass (policy=quarantine) header.from=xiaomi.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755654956; a=rsa-sha256;
	cv=none;
	b=nAsUAYWIRTxIaftOiFUZR2i6Xe+SjUeCP+Pb7aXhKrZH+korUu6R36BQJvb8KEvlyqzUGY
	nXJPl2QCZHXbwFe8LZupdAG0TiSdPS1RNAxUXvTT4TIIplpxaeJ069JlvOSJuiZUHiWR1c
	mroZ9AkWsdLcbxC1dBw7Sap4Q2gYlRY=
X-CSE-ConnectionGUID: RodKwbvQS6uV/A4BPurz+w==
X-CSE-MsgGUID: Nbt86NviSBGF1HVo8Wodiw==
X-IronPort-AV: E=Sophos;i="6.17,302,1747670400"; 
   d="scan'208,217";a="149743428"
From: =?gb2312?B?uN/P6A==?= <gaoxiang17@xiaomi.com>
To: David Hildenbrand <david@redhat.com>, Xiang Gao <gxxa03070307@gmail.com>,
	"akpm@linux-foundation.org" <akpm@linux-foundation.org>
CC: "lorenzo.stoakes@oracle.com" <lorenzo.stoakes@oracle.com>,
	"Liam.Howlett@oracle.com" <Liam.Howlett@oracle.com>, "vbabka@suse.cz"
	<vbabka@suse.cz>, "rppt@kernel.org" <rppt@kernel.org>, "surenb@google.com"
	<surenb@google.com>, "mhocko@suse.com" <mhocko@suse.com>,
	"linux-mm@kvack.org" <linux-mm@kvack.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>
Subject: =?gb2312?B?tPC4tDogW0V4dGVybmFsIE1haWxdUmU6IFtQQVRDSF0gbW0vY21hOiBhZGQg?=
 =?gb2312?B?J2F2YWlsYWJsZSBjb3VudCcgYW5kICd0b3RhbCBjb3VudCcgdG8gdHJhY2Vf?=
 =?gb2312?B?Y21hX2FsbG9jX3N0YXJ0?=
Thread-Topic: [External Mail]Re: [PATCH] mm/cma: add 'available count' and
 'total count' to trace_cma_alloc_start
Thread-Index: AQHcET3fzZXiZdVl50C+PBdtvOGVB7RqyGUg
Date: Wed, 20 Aug 2025 01:55:35 +0000
Message-ID: <bc48e01034b84b0fb29dc349b43f1bfa@xiaomi.com>
References: <20250819134817.247495-1-gxxa03070307@gmail.com>,<41f0e713-7f2a-4c31-a48d-50b8d05f40b8@redhat.com>
In-Reply-To: <41f0e713-7f2a-4c31-a48d-50b8d05f40b8@redhat.com>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-originating-ip: [10.237.88.13]
Content-Type: multipart/alternative;
	boundary="_000_bc48e01034b84b0fb29dc349b43f1bfaxiaomicom_"
MIME-Version: 1.0
X-Rspamd-Queue-Id: ADF4920005
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: sbqnawydsnsk8itj8zpkyg6qgu8z38xg
X-HE-Tag: 1755654954-457752
X-HE-Meta: U2FsdGVkX1/TdzieFFae0UZ2w3ogmw+67P43fBuJbhdAEYwLVKG4TXGiA/YJefXT2lK5Tm9RgUNsTPn7079zelALcrAjp42b7+LF64d4yceTQPs+rWZPr1hQGGIg50GvGUuuGKzvwE8OIxTbfcbv484vhISqfV9WPMfrWqTblV98yqu33WW319qIGsjjzPi5sqoQ9PBtsf5khlhBEcjsYo9AVMc4scbgSHwdgKT6TfaG/LO2AOjd/Xjminz38GN8wVZCxjBMobVmvIrUQFBdVvw3cWBs9O7aNUNx6DhD2tT9RYq9yiWHkXku/Vu+SbI2M5GLMP1RBxbstuXuywwOTLRwF4iqREdi/ZiBWz4R3a27cGdoDMTyIWOYm1pCMru5gP74bXf1d+8Qjqzn4N3Kz6FHN36CMeU5cGzz7+3YDwiKNOHhPJ9uJbQ1EzzBA7iTfjwZA9yVOIO8Xqy+Fpwg+fPJ/Jiw9YbYSyH9xaXb8kXRQi6G6qTVJien20EhhOAjdSODpWXehTyjlK8t5khqapvfteaQgZlAsyxUnpSFwwY4mFuXAS0a+XSaM1VJ9zgoFSC/2a98338Dz5DamodFc2KpYFETVklw75pEsJ27e+vjHkjoFqodEkTxSjfJstG3dZt8uDTEEuJCJ+5c/atClhQJhBskcfZq2SKysgjwZs9gQXJj74VkeNLSBJiEWBxAFl6EaKXeWt7iRNefzFyJAfsAF9g5Xj5peigQK5oE0B1KbdUXPhPZg+I18Dy4ognOoGZ6G1eBT9Sq89UQuaEHpZw/X2dHqvk2u4lD8hUzO6r7AWvXnbC/6ecJ7nliwHfKjPM1D9lOkcuJ3bo36e0s1Mo2fcZvspnz/fyytTjOeiJ7SRP9hIRr32UEw5xZZLIjlTe5NAtgwbsljKHN1sYrdNadWfwLwy7UXMhlcJX569ojrZpQp66WXUsMd6JPELlPXtiQlGU0eHIU0j+3WoY
 2rNiJke2
 vZkvZpfLvyrY1ETBn2TSF1VWv2xQ8pQY4zSSaPXOSJhAaua9TFSRojuawEpD5/axOLe9l4w0468rls3wZmOLlL90zXUzvPqckFy803y8ywKTMAn0C6Zm4F9tFX368q33YBCjulg+exySUulixYSNpYoEf63XEzKO9LcgLDFRrLzWqhktBkQF9X9JMZWJCX/UVUzqVwMLkBHmn0hsAyX84pns8pE8KJcTbzaEfjjhiPAlHOBn1tTrBs4oG4tCc1wtCXRas9rRQDX0LiMEXQ7Og6RMfndhf0LaggNbetRyhSUfdhXcaeaylTH/kfRoO53Biz2yZP8Q46Gn5xV2p+M7DBQdFGl7JMscu2UXh5lGegkgMaEeL6RxjqWECvbq7T2Ku6ulhfVSM+fDLwiymEKJ6OLfijdUzuin62jS2q6PjHWvPpCoiDxNEm7NDkfFBhT3uHeJBhwMOzERtdvvnEBvb4pwKhwwLEGqc8z4TC5OxXoJBslXbZGruqqZbTFUnBa8zq9wmajpz35dzd3uHPweJ8YhxE59AlOkAj/Y5DiLqau5vZJSTeGw6YLG+G5L0/SuhZxJbyTKPjGPwL+aUOT2Jlg94nZvZEgK8dmuYKoPIskj9AUaSwDlrqyhAtA7G2jxvqdXyOpj9nyjepp5UUqR5MaoPA429O3mmj5YBtHEuOrlnMjn0hI70L1EGPr6lZF72Jrh/+AH5O77wrWbMNqnut52hyA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

--_000_bc48e01034b84b0fb29dc349b43f1bfaxiaomicom_
Content-Type: text/plain; charset="gb2312"
Content-Transfer-Encoding: base64

DQpvaywgdGhpbmtzDQoNCl9fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fDQq3orz+yMs6
IERhdmlkIEhpbGRlbmJyYW5kIDxkYXZpZEByZWRoYXQuY29tPg0Kt6LLzcqxvOQ6IDIwMjXE6jjU
wjIwyNUgMzoxNzowNg0KytW8/sjLOiBYaWFuZyBHYW87IGFrcG1AbGludXgtZm91bmRhdGlvbi5v
cmcNCrOty806IGxvcmVuem8uc3RvYWtlc0BvcmFjbGUuY29tOyBMaWFtLkhvd2xldHRAb3JhY2xl
LmNvbTsgdmJhYmthQHN1c2UuY3o7IHJwcHRAa2VybmVsLm9yZzsgc3VyZW5iQGdvb2dsZS5jb207
IG1ob2Nrb0BzdXNlLmNvbTsgbGludXgtbW1Aa3ZhY2sub3JnOyBsaW51eC1rZXJuZWxAdmdlci5r
ZXJuZWwub3JnOyC438/oDQrW98ziOiBbRXh0ZXJuYWwgTWFpbF1SZTogW1BBVENIXSBtbS9jbWE6
IGFkZCAnYXZhaWxhYmxlIGNvdW50JyBhbmQgJ3RvdGFsIGNvdW50JyB0byB0cmFjZV9jbWFfYWxs
b2Nfc3RhcnQNCg0KW83isr/Tyrz+XSC0y9PKvP7AtNS009rQocPXuavLvs3isr+jrMfrvffJ97Sm
wO2ho8j0ttTTyrz+sLLIq9DUtObSyaOsx+u9q9PKvP7XqreiuPhtaXNlY0B4aWFvbWkuY29tvfjQ
0Le0wKENCg0KT24gMTkuMDguMjUgMTU6NDgsIFhpYW5nIEdhbyB3cm90ZToNCj4gRnJvbTogZ2Fv
eGlhbmcxNyA8Z2FveGlhbmcxN0B4aWFvbWkuY29tPg0KPg0KPiBUaGlzIG1ha2VzIGNtYSBpbmZv
IG1vcmUgaW50dWl0aXZlIGR1cmluZyBkZWJ1Z2dpbmcuDQo+DQo+IFNpZ25lZC1vZmYtYnk6IGdh
b3hpYW5nMTcgPGdhb3hpYW5nMTdAeGlhb21pLmNvbT4NCj4gLS0tDQoNCkZvciB0aGUgbmV4dCB0
aW1lOiB5b3Ugc2hvdWxkIGhhdmUgaW5kaWNhdGVkIHRoYXQgdGhpcyBpcyB2MiAoW1BBVENIDQp2
Ml0pIGFuZCBicmllZmx5IGRlc2NyaWJlZCB1bmRlciB0aGUgIi0tLSIgdGhlIGNoYW5nZXMgYmV0
d2VlbiB2MSBhbmQgdjIuDQoNCkFja2VkLWJ5OiBEYXZpZCBIaWxkZW5icmFuZCA8ZGF2aWRAcmVk
aGF0LmNvbT4NCg0KLS0NCkNoZWVycw0KDQpEYXZpZCAvIGRoaWxkZW5iDQoNCg==

--_000_bc48e01034b84b0fb29dc349b43f1bfaxiaomicom_
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
<p>ok, thinks</p>
</div>
<hr tabindex=3D"-1" style=3D"display:inline-block; width:98%">
<div id=3D"x_divRplyFwdMsg" dir=3D"ltr"><font face=3D"Calibri, sans-serif" =
color=3D"#000000" style=3D"font-size:11pt"><b>=B7=A2=BC=FE=C8=CB:</b> David=
 Hildenbrand &lt;david@redhat.com&gt;<br>
<b>=B7=A2=CB=CD=CA=B1=BC=E4:</b> 2025=C4=EA8=D4=C220=C8=D5 3:17:06<br>
<b>=CA=D5=BC=FE=C8=CB:</b> Xiang Gao; akpm@linux-foundation.org<br>
<b>=B3=AD=CB=CD:</b> lorenzo.stoakes@oracle.com; Liam.Howlett@oracle.com; v=
babka@suse.cz; rppt@kernel.org; surenb@google.com; mhocko@suse.com; linux-m=
m@kvack.org; linux-kernel@vger.kernel.org; =B8=DF=CF=E8<br>
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
On 19.08.25 15:48, Xiang Gao wrote:<br>
&gt; From: gaoxiang17 &lt;gaoxiang17@xiaomi.com&gt;<br>
&gt;<br>
&gt; This makes cma info more intuitive during debugging.<br>
&gt;<br>
&gt; Signed-off-by: gaoxiang17 &lt;gaoxiang17@xiaomi.com&gt;<br>
&gt; ---<br>
<br>
For the next time: you should have indicated that this is v2 ([PATCH<br>
v2]) and briefly described under the &quot;---&quot; the changes between v1=
 and v2.<br>
<br>
Acked-by: David Hildenbrand &lt;david@redhat.com&gt;<br>
<br>
--<br>
Cheers<br>
<br>
David / dhildenb<br>
<br>
</div>
</span></font></div>
</body>
</html>

--_000_bc48e01034b84b0fb29dc349b43f1bfaxiaomicom_--


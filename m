Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AC3BCC5B56A
	for <linux-mm@archiver.kernel.org>; Wed, 12 Aug 2026 13:21:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 51B7C6B0209; Wed, 12 Aug 2026 09:21:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4CBB16B020B; Wed, 12 Aug 2026 09:21:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 40BD06B020C; Wed, 12 Aug 2026 09:21:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 05CEC6B0209
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 09:21:39 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 72C02A035B
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 13:21:39 +0000 (UTC)
X-FDA: 85092679518.02.3148DA1
Received: from outboundhk.mxmail.xiaomi.com (outboundhk.mxmail.xiaomi.com [118.143.206.90])
	by imf04.hostedemail.com (Postfix) with ESMTP id 6BAFB4000A
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 13:21:33 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=xiaomi.com;
	spf=pass (imf04.hostedemail.com: domain of gaoxiang17@xiaomi.com designates 118.143.206.90 as permitted sender) smtp.mailfrom=gaoxiang17@xiaomi.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786540897;
	b=seKZOgiLyUhAkDwtDmmrFvbVnxm1Nz+NCN3aRlnoJXEPrE5IkNV3+JrJxggtcTU1nHX4Vg
	HfwSu4rVFXgbQw6Nu/vFzt8EIkb7IukidUyHvIdwmqiucfG/BUf/cc7+qTuLRQFtNh3I1n
	ow6/oIX+njJC3TvFKqPOdJ54f0Z6684=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=xiaomi.com;
	spf=pass (imf04.hostedemail.com: domain of gaoxiang17@xiaomi.com designates 118.143.206.90 as permitted sender) smtp.mailfrom=gaoxiang17@xiaomi.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786540897;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=UX/pMAx7SWqbMxw3Wa1pLWOShmrf7BHgzWflqvh2wbQ=;
	b=IN2VvTXSjexsB2iZjBwe/v+2y/sag2rV+kjWTQSLDq+55GFRYgsnEXbP9J0pxztSDAHXZm
	36pE6uvIZjg0nVqlYaxwU8vJAwoRdO5wIY09AnPjyxRA30Cwtjf/H+f1CzjiqdagqTFqmt
	kX1qLWTYPTxOpLve5XEP4KhyT2u5ZHU=
X-CSE-ConnectionGUID: 1UgUDRZ1QNivzZEq0+sAiA==
X-CSE-MsgGUID: clK7nHn8Q7yVdSSwnMxQoQ==
X-IronPort-AV: E=Sophos;i="6.25,219,1779120000"; 
   d="scan'208,217";a="159081093"
From: =?gb2312?B?uN/P6A==?= <gaoxiang17@xiaomi.com>
To: Steven Rostedt <rostedt@goodmis.org>, Xiang Gao <gxxa03070307@gmail.com>
CC: Masami Hiramatsu <mhiramat@kernel.org>, Mathieu Desnoyers
	<mathieu.desnoyers@efficios.com>, Lorenzo Stoakes <ljs@kernel.org>, gao xu
	<gaoxu2@honor.com>, =?gb2312?B?06G0sw==?= <yinchuang1@xiaomi.com>,
	"linux-trace-kernel@vger.kernel.org" <linux-trace-kernel@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: =?gb2312?B?tPC4tDogW0V4dGVybmFsIE1haWxdUmU6IFtSRkNdIHRyYWNpbmc6IGFnZ3Jl?=
 =?gb2312?Q?gate_ring-buffer_usage_statistics?=
Thread-Topic: [External Mail]Re: [RFC] tracing: aggregate ring-buffer usage
 statistics
Thread-Index: AQHdKZr3AIp7eq0PuUyEknsvZXxszLaaZZoy
Date: Wed, 12 Aug 2026 13:21:29 +0000
Message-ID: <cd441eb194d54265b1bf9ab659716c45@xiaomi.com>
References: <20260811114818.1449933-1-gaoxiang17@xiaomi.com>,<20260811100830.7976bbe8@gandalf.local.home>
In-Reply-To: <20260811100830.7976bbe8@gandalf.local.home>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-originating-ip: [10.237.8.166]
Content-Type: multipart/alternative;
	boundary="_000_cd441eb194d54265b1bf9ab659716c45xiaomicom_"
MIME-Version: 1.0
X-Rspamd-Queue-Id: 6BAFB4000A
X-Rspam-User: 
X-Stat-Signature: 1n9fbwbn6bugtiqygcudx1pigjnje19y
X-Rspamd-Server: rspam06
X-HE-Tag: 1786540893-533192
X-HE-Meta: U2FsdGVkX18WULQh0FG5mREQDVGDlkmpRvAFLl8X/7qLvAk6DnT+NMVf2LlYLJfqZsv0AwJ9Crw1f6SQikbXePWSnRmPUYi+VzsTgLWU/4YQD9X5cjw+OtH7fY7tFbvdDADvsf+RRPJ2f0smNB6dZG1XtsoEMD3f0OQyXLZo6r/VdCmhPwAyRK5JkN6Hhi4a69ZvdIVbRQYY2PJf73k/SbGjMgVhKS56iTvnfO3EpYFIiH/Cy3iTTgtcXgiGszgEl3RHAFQgWE+rd01wR+RzXPOrxAC45gzOmOlKjmEtbSQm8mNNFZVTOeDVe1OXYBxTFxkng35yn7EdYhoSOcPwFjQ9N+Flu+kbvFm+RogeMkC8F0xe3Xh+uo1mg9C0j+CFP9rYLqnaCyBSShfr9vhHqWf7QBAqQJWAXU7ReL0gSeZnNjnCVUHPLRqfQrga6jlxqqutvhiweyxXiFKRTMvT2+6MEQUwGLmo6WSJmienazdp7ARtoCXOlrmfu85sWvNIDaqrovHqnhgoOJfn9wXykL5QcZJM6BlIa94eS0i1WRHMS4t23glU7RJv7PuE3W/lZhcTHTFIgvF4OdFZnfS11qSqKcVWkQMyN2BSATEn7C7T5YlpwcmnG3fx2CMyVy62NEIsUTrLpgl/l+aBSGfc09M5C4hhRs+nPiTWUNTWgH88xdaIX6/wYYGgjxQUHWENUGq4W3+/srvkZCEU0SXBUpjF1Oa+BEGS3Q5pnNxJSk7N6q0Yt6fExOX4HSVLZyCGnZjgZAx633PC1fTI4OgB23AWHNZExtUqrPpcbWJ5lmZxCRNgwOOq+QoQ/q7Rv99TcxvE1re3YaFClW73cm/B058C2SQl5pb30U0EQpqDiOqlda9lKZD0SNl14s2yG0nmE4A8qqnowERAZP4RAhrkLiRV3AEhz22shOKhWc+emlP6Ys5obXrWIbBMlE7LL59CNBdxjKTKjFo6PI+VElJ
 llGaj9ds
 ILD8KiF4TdM2XJj5xFI4CILkzFCYXU3MVc0pqmkyhXN3pqqhCVzozwKhKS/zzLvhviywkyqwTouIkjrMlTGegsGX/B6ArXnuUh5+ZvnkDgoGzol9l0LSVxr+QC12lXqOJ7p/Xb2xddf1lMQNpIRXS3zsvDbBg4nYFo5peiJDgdjWsxbKsmI++8VHxSmpM3I0tqGddxB/35n9vv6c//HY7FBmFBxr4oF0usPLr7Ap+h/t4qYDXOqOXqxRLixcRbbgwx/3RALTJ55C8obA7VUci7lRqPedOA3cfW2i5Gi5BOuwr4V6vFpJ2ZmQ3YYQMw+3uV9m28BnU5vBFOq3/ta37YzucWGa9zM91FUEUXIKy/7d/vDz4EaEYxobPgzFDBU/5Yr29PNSCmeVudSGMEtFyz+tFCMmMtZnw7sbz4ntiuTQ4KPDHKFRXJIO2/+LvCACg6WFzg7njhjXrGZlP6Vlj+EBUXz8syZRXWd0nN0wFKOUTrnoybtXx7fSAW/TPz5KbZSfNjZ8UDfLdX0MsgD6OBK4ZdgH2iozXbT9a8H9cK3MqZR/jG8IS2NuUZw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

--_000_cd441eb194d54265b1bf9ab659716c45xiaomicom_
Content-Type: text/plain; charset="gb2312"
Content-Transfer-Encoding: base64

DQpUaGFua3MsIFN0ZXZlLg0KDQpGb3IgdGhlIGluaXRpYWwgaW1wbGVtZW50YXRpb24sIEkgcGxh
biB0byBhZGQ6DQoNCiAgL3N5cy9rZXJuZWwvdHJhY2luZy90cmFjZV9zdGF0cy90b3RhbF9tZW1v
cnlfa2INCg0KVGhlIGZpbGUgd291bGQgdXNlIGFuIGV4dGVuc2libGUga2V5L3ZhbHVlIGZvcm1h
dC4gSW5pdGlhbGx5IGl0IHdvdWxkDQpyZXBvcnQgdGhlIHJpbmctYnVmZmVyIGRhdGEgY2FwYWNp
dHk6DQoNCiAgdG90YWw6ICAgICAgICAgICAgICAgICAgIDM5NTY2NA0KICByaW5nX2J1ZmZlcjog
ICAgICAgICAgICAgMzk1NjY0DQogIHJpbmdfYnVmZmVyX2xpdmU6ICAgICAgICAzOTU1NDQNCiAg
cmluZ19idWZmZXJfc25hcHNob3Q6ICAgICAgIDEyMA0KDQpIZXJlLCByaW5nX2J1ZmZlciBpcyB0
aGUgc3VtIG9mIHJpbmdfYnVmZmVyX2xpdmUgYW5kDQpyaW5nX2J1ZmZlcl9zbmFwc2hvdC4gVGhl
IHZhbHVlcyBjb3ZlciB0aGUgZ2xvYmFsIHRyYWNlIGFycmF5IGFuZCBhbGwNCnRyYWNpbmcgaW5z
dGFuY2VzIGFjcm9zcyBhbGwgdHJhY2luZyBDUFVzLg0KDQpBZGRpdGlvbmFsIGFjY291bnRlZCBj
YXRlZ29yaWVzLCBzdWNoIGFzIGV2ZW50IG1lbW9yeSwgY291bGQgYmUgYXBwZW5kZWQNCmxhdGVy
IGFuZCBpbmNsdWRlZCBpbiB0b3RhbC4gUGVyLUNQVSBzdGF0aXN0aWNzIGNvdWxkIGJlIGV4cG9z
ZWQNCnNlcGFyYXRlbHkgdW5kZXIgdHJhY2Vfc3RhdHMvcGVyX2NwdS9jcHVOLyB0byBhdm9pZCBt
aXhpbmcgYWdncmVnYXRlIGFuZA0KcGVyLUNQVSB2YWx1ZXMgaW4gb25lIGZpbGUuDQoNClVzZXJz
cGFjZSB3b3VsZCBwYXJzZSBmaWVsZHMgYnkgbmFtZSBhbmQgaWdub3JlIHVua25vd24gZmllbGRz
LCBzbyBuZXcNCmNhdGVnb3JpZXMgY2FuIGJlIGFkZGVkIHdpdGhvdXQgY2hhbmdpbmcgdGhlIGV4
aXN0aW5nIGZvcm1hdC4NCg0KRG9lcyB0aGlzIGluaXRpYWwgZm9ybWF0IGxvb2sgcmVhc29uYWJs
ZT8NCg0KVGhhbmtzLA0KWGlhbmcNCg0KDQoNCl9fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fDQq3orz+yMs6IFN0ZXZlbiBSb3N0ZWR0IDxyb3N0ZWR0QGdvb2RtaXMub3JnPg0Kt6LLzcqx
vOQ6IDIwMjbE6jjUwjExyNUgMjI6MDg6MzANCsrVvP7IyzogWGlhbmcgR2FvDQqzrcvNOiBNYXNh
bWkgSGlyYW1hdHN1OyBNYXRoaWV1IERlc25veWVyczsgTG9yZW56byBTdG9ha2VzOyBnYW8geHU7
INOhtLM7IGxpbnV4LXRyYWNlLWtlcm5lbEB2Z2VyLmtlcm5lbC5vcmc7IGxpbnV4LWtlcm5lbEB2
Z2VyLmtlcm5lbC5vcmc7IGxpbnV4LW1tQGt2YWNrLm9yZzsguN/P6A0K1vfM4jogW0V4dGVybmFs
IE1haWxdUmU6IFtSRkNdIHRyYWNpbmc6IGFnZ3JlZ2F0ZSByaW5nLWJ1ZmZlciB1c2FnZSBzdGF0
aXN0aWNzDQoNClvN4rK/08q8/l0gtMvTyrz+wLTUtNPa0KHD17mry77N4rK/o6zH6733yfe0psDt
oaPI9LbU08q8/rCyyKvQ1LTm0smjrMfrvavTyrz+16q3orj4bWlzZWNAeGlhb21pLmNvbb340NC3
tMChDQoNCk9uIFR1ZSwgMTEgQXVnIDIwMjYgMTk6NDg6MTggKzA4MDANClhpYW5nIEdhbyA8Z3h4
YTAzMDcwMzA3QGdtYWlsLmNvbT4gd3JvdGU6DQoNCj4gT25lIHBvc3NpYmxlIGludGVyZmFjZSB3
b3VsZCBiZSB1bmRlcjoNCj4NCj4gICAvc3lzL2tlcm5lbC90cmFjaW5nL3RyYWNlX3N0YXRzLw0K
Pg0KPiBJdCBjb3VsZCBwcm92aWRlIGFuIGFnZ3JlZ2F0ZSBidWZmZXIgdmFsdWUgdG9nZXRoZXIg
d2l0aCBhIGJyZWFrZG93bg0KPiBmb3IgbWFpbiBhbmQgc25hcHNob3QgYnVmZmVycy4gUGVyLUNQ
VSBzdGF0aXN0aWNzIGNvdWxkIGFsc28gYmUgYWRkZWQNCj4gaWYgdXNlZnVsLg0KDQpBcyBJIHBy
ZXZpb3VzIHNhaWQuIEknbSBPSyB3aXRoIGFkZGluZyBhIGZpbGUgdGhlcmUuDQoNCi0tIFN0ZXZl
DQo=

--_000_cd441eb194d54265b1bf9ab659716c45xiaomicom_
Content-Type: text/html; charset="gb2312"
Content-Transfer-Encoding: quoted-printable

<html>
<head>
<meta http-equiv=3D"Content-Type" content=3D"text/html; charset=3Dgb2312">
<meta name=3D"Generator" content=3D"Microsoft Exchange Server">
<!-- converted from text --><style><!-- .EmailQuote { margin-left: 1pt; pad=
ding-left: 4pt; border-left: #800000 2px solid; } --></style>
</head>
<body>
<meta content=3D"text/html; charset=3DUTF-8">
<style type=3D"text/css" style=3D"">
<!--
p
	{margin-top:0;
	margin-bottom:0}
-->
</style>
<div dir=3D"ltr">
<div id=3D"x_divtagdefaultwrapper" dir=3D"ltr" style=3D"font-size:12pt; col=
or:#000000; font-family:Calibri,Helvetica,sans-serif">
<p></p>
<div><br>
</div>
<div>Thanks, Steve.</div>
<div><br>
</div>
<div>For the initial implementation, I plan to add:</div>
<div><br>
</div>
<div>&nbsp; /sys/kernel/tracing/trace_stats/total_memory_kb</div>
<div><br>
</div>
<div>The file would use an extensible key/value format. Initially it would<=
/div>
<div>report the ring-buffer data capacity:</div>
<div><br>
</div>
<div>&nbsp; total:&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &=
nbsp; &nbsp;395664</div>
<div>&nbsp; ring_buffer:&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;395=
664</div>
<div>&nbsp; ring_buffer_live:&nbsp; &nbsp; &nbsp; &nbsp; 395544</div>
<div>&nbsp; ring_buffer_snapshot:&nbsp; &nbsp; &nbsp; &nbsp;120</div>
<div><br>
</div>
<div>Here, ring_buffer is the sum of ring_buffer_live and</div>
<div>ring_buffer_snapshot. The values cover the global trace array and all<=
/div>
<div>tracing instances across all tracing CPUs.</div>
<div><br>
</div>
<div>Additional accounted categories, such as event memory, could be append=
ed</div>
<div>later and included in total. Per-CPU statistics could be exposed</div>
<div>separately under trace_stats/per_cpu/cpuN/ to avoid mixing aggregate a=
nd</div>
<div>per-CPU values in one file.</div>
<div><br>
</div>
<div>Userspace would parse fields by name and ignore unknown fields, so new=
</div>
<div>categories can be added without changing the existing format.</div>
<div><br>
</div>
<div>Does this initial format look reasonable?</div>
<div><br>
</div>
<div>Thanks,</div>
<div>Xiang</div>
<div><br>
</div>
<br>
<p></p>
</div>
<hr tabindex=3D"-1" style=3D"display:inline-block; width:98%">
<div id=3D"x_divRplyFwdMsg" dir=3D"ltr"><font face=3D"Calibri, sans-serif" =
color=3D"#000000" style=3D"font-size:11pt"><b>=B7=A2=BC=FE=C8=CB:</b> Steve=
n Rostedt &lt;rostedt@goodmis.org&gt;<br>
<b>=B7=A2=CB=CD=CA=B1=BC=E4:</b> 2026=C4=EA8=D4=C211=C8=D5 22:08:30<br>
<b>=CA=D5=BC=FE=C8=CB:</b> Xiang Gao<br>
<b>=B3=AD=CB=CD:</b> Masami Hiramatsu; Mathieu Desnoyers; Lorenzo Stoakes; =
gao xu; =D3=A1=B4=B3; linux-trace-kernel@vger.kernel.org; linux-kernel@vger=
.kernel.org; linux-mm@kvack.org; =B8=DF=CF=E8<br>
<b>=D6=F7=CC=E2:</b> [External Mail]Re: [RFC] tracing: aggregate ring-buffe=
r usage statistics</font>
<div>&nbsp;</div>
</div>
</div>
<font size=3D"2"><span style=3D"font-size:10pt;">
<div class=3D"PlainText">[=CD=E2=B2=BF=D3=CA=BC=FE] =B4=CB=D3=CA=BC=FE=C0=
=B4=D4=B4=D3=DA=D0=A1=C3=D7=B9=AB=CB=BE=CD=E2=B2=BF=A3=AC=C7=EB=BD=F7=C9=F7=
=B4=A6=C0=ED=A1=A3=C8=F4=B6=D4=D3=CA=BC=FE=B0=B2=C8=AB=D0=D4=B4=E6=D2=C9=A3=
=AC=C7=EB=BD=AB=D3=CA=BC=FE=D7=AA=B7=A2=B8=F8misec@xiaomi.com=BD=F8=D0=D0=
=B7=B4=C0=A1<br>
<br>
On Tue, 11 Aug 2026 19:48:18 &#43;0800<br>
Xiang Gao &lt;gxxa03070307@gmail.com&gt; wrote:<br>
<br>
&gt; One possible interface would be under:<br>
&gt;<br>
&gt;&nbsp;&nbsp; /sys/kernel/tracing/trace_stats/<br>
&gt;<br>
&gt; It could provide an aggregate buffer value together with a breakdown<b=
r>
&gt; for main and snapshot buffers. Per-CPU statistics could also be added<=
br>
&gt; if useful.<br>
<br>
As I previous said. I'm OK with adding a file there.<br>
<br>
-- Steve<br>
</div>
</span></font>
</body>
</html>

--_000_cd441eb194d54265b1bf9ab659716c45xiaomicom_--


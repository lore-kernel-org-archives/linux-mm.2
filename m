Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A04BD10BA431
	for <linux-mm@archiver.kernel.org>; Fri, 27 Mar 2026 07:08:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EB3666B00BF; Fri, 27 Mar 2026 03:08:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E649F6B00C1; Fri, 27 Mar 2026 03:08:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D7A936B00C2; Fri, 27 Mar 2026 03:08:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C3D956B00BF
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 03:08:32 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 8FA815D533
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 07:08:32 +0000 (UTC)
X-FDA: 84590964864.28.9EDE7EF
Received: from m16.mail.126.com (m16.mail.126.com [117.135.210.7])
	by imf21.hostedemail.com (Postfix) with ESMTP id BFAE11C000A
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 07:08:28 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=126.com header.s=s110527 header.b="Y v/QGVv";
	spf=pass (imf21.hostedemail.com: domain of zhongling0719@126.com designates 117.135.210.7 as permitted sender) smtp.mailfrom=zhongling0719@126.com;
	dmarc=pass (policy=none) header.from=126.com
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=126.com header.s=s110527 header.b="Y v/QGVv";
	spf=pass (imf21.hostedemail.com: domain of zhongling0719@126.com designates 117.135.210.7 as permitted sender) smtp.mailfrom=zhongling0719@126.com;
	dmarc=pass (policy=none) header.from=126.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774595309; a=rsa-sha256;
	cv=none;
	b=RbxL1gEMOQkUQOJeVYIhy8ZKc2v+kNtxnbFDEg1BlVlv+bvVrqVq9ipFUHuBimP9qPbMwf
	+aKdDEo5h6Tbz+q1k5jMvzaTNXeESrH+OKDU2sbhS8hNK3TpdBqRAb8Sb97jR94zwCBvLc
	bN54zu/LWQCOBtUV8dXPO8rwGWtC8vw=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774595309;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8bvUwVBPfQi3FOWdUuoE5RWQG+O5ir/y/eRGONnxYWw=;
	b=1lD8V/Zy2fHyhYGLzLJ8gON9Q2cyhtvBqcNstrBEqcM5FM8OI2vnZ2+d8dKeWDhvvs60ca
	/duDCOxJRYTlmeYtWUOBedQ/uAwPStgTpRZjuKEO3wfAMgVAC426ro+NIo59wwk3SmeOqv
	HWfJq9lLHkRIsxxvAibHZ8dl6cgfbtw=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=126.com;
	s=s110527; h=Date:From:To:Subject:Content-Type:MIME-Version:
	Message-ID; bh=8bvUwVBPfQi3FOWdUuoE5RWQG+O5ir/y/eRGONnxYWw=; b=Y
	v/QGVvbs8tTE4j+83tNf0/g6WKlaUgiM1ePZm8043DgRVTLyTzka8cnMcOubYWpL
	ulk1yi1K5h+7EU2QqATcdhcZYgYdRCsFyDgBdWPNWPtXhxtVh6PjqCqkH6rETxZb
	YQ8653OBkmpJfCq8Lr+zYbxfZFGWafl+CetPRldyMs=
Received: from zhongling0719$126.com ( [112.64.161.44] ) by
 ajax-webmail-wmsvr-41-114 (Coremail) ; Fri, 27 Mar 2026 15:08:05 +0800
 (CST)
X-Originating-IP: [112.64.161.44]
Date: Fri, 27 Mar 2026 15:08:05 +0800 (CST)
From: dd  <zhongling0719@126.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
Cc: zenghongling <zenghongling@kylinos.cn>, dennis@kernel.org, tj@kernel.org,
	cl@gentwo.org, linux-mm@kvack.org
Subject: Re:Re: [PATCH] mm/percpu-internal.h: optimise pcpu_chunk_struct to
 save memory
X-Priority: 3
X-Mailer: Coremail Webmail Server Version 2023.4-cmXT build
 20251222(83accb85) Copyright (c) 2002-2026 www.mailtech.cn 126com
In-Reply-To: <20260326221641.7a2edff04ebb51561c8818e4@linux-foundation.org>
References: <20260305073043.571691-1-zenghongling@kylinos.cn>
 <20260326221641.7a2edff04ebb51561c8818e4@linux-foundation.org>
X-NTES-SC: AL_Qu2cBvmSukoj4yGYbOkfnk4Vjuc2X8O5v/ku1YBSc8oOlDnxxDoaXX9lL0XY7tOiBgKFnyevdAdj8PZ8bYtjGRqa2EfoU3TDjSBosvTGGA==
Content-Type: multipart/alternative; 
	boundary="----=_Part_79092_165404979.1774595285114"
MIME-Version: 1.0
Message-ID: <2fcf4b59.518a.19d2e1f207b.Coremail.zhongling0719@126.com>
X-Coremail-Locale: zh_CN
X-CM-TRANSID:cikvCgD3N5jVLMZppUBrAA--.15484W
X-CM-SenderInfo: x2kr0wpolqwiqxrzqiyswou0bp/xtbBrxVMHWnGLNXSdQAA3a
X-Coremail-Antispam: 1U5529EdanIXcx71UUUUU7vcSsGvfC2KfnxnUU==
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: BFAE11C000A
X-Stat-Signature: 37jm6cxcinasgrguf46b8jci5sefjz19
X-Rspam-User: 
X-HE-Tag: 1774595308-275629
X-HE-Meta: U2FsdGVkX18BnH68ifOYqAv1eRAoFwxWjW7Oh6N/fzEtgIrwvjXpjsJfwvJraUhDkHpOtgqZawaYzHU80Gvk7tY4boea/Qka+mjvDmxPVathcvD2TTRba2yPh8iTT03MDasFkYWPTSImyhneZZSuVINrAcWDdgyQ7j8Hcs7T/conEwsELMZiRq5Z/z1xxaisDvJJJSbSJ9YJK1HUDYgGilmSf+KU8NfJcJgH0g8g1wysu8x28SVTLzilzhcZiEPHHg1R0xnOlfQcE1+5SSw97lgKcv2DiusnU1A5+YeT2gzFtti1ttD9zQifJUHJFXDbYaE6JcWNCP0YaioQ4sMjWhZatGIFNFHpbsbUNe2zXiqjvOvdTT35t2G8obocUHjVWCmcM3qdiKC2/LdT54iKNk8J2t6FRFCWKAT/iA347NSiVbem1gH5QRSWyVN5O4h7nnPGBTQKFXECNIPFDXeQk88EBIMhDKYlU2ARIbgdpUodUJNCc2YHTE3v8V/tFKdI/9GRyOyEI/paXMXtNFlWvg/4vu8MZNc+HrZh7pPq2Y0XtzhET8P3M2YMKLG4rajfPEfleyK+BpA5vMSDC5F/iGJuIsr4zXbeQkQOw0njx11cw7k28ZzNyRQxtw6fe++A3F7MwxysV9BXLzn6Jy9mVngeJm+3hrV6XtMUk8mAtmzOxa1rOcvVm1eeAt0yVFfyUYiHeiW2bNVc9A0z3eamWi4kZkP7W6zk8ftvAHtUZIdZ2gK+JuFwy/W9XCVIsZglICn6WlNeYLQ+lU7A3oVy3Lw8wfiQDZjdK0ulA4L2KFL6kPB7pASKvzWWqk4HMcNjMvTw9HdCcUVkC2F2ErdU26f03MbvUWuFAnzOWGCdEZrNMOzgnqwNqab0tJUi1dNVxYt+E2rJgWwWKuLSF0448PdtFlKS9a3sq1kKCZFmLK0xTdjJL3kB5nZZ/DYG3h136V/OqgwbitRoE7YcWtY
 0nQYGqp2
 NzxR14ISl+Fy+L2UFAqmxgOJH20ZDdkFMA49GD/YQVlfrGICi+Y/QMifXyz+168fcOwoMhhegVGENje058Elc9Grt5rycYCr4kaTABz8iF9v8sRce7eHI8sp1rpIAga2ZJhk9z4SuWG3Zd3s7ZPa7g4GossF1zgD2XlqNVVQzmNmDxSlZehKuozQtWHOu5aemCf6NthmioXUsw2imx4fp2CaTFy0bR62JVqts5fTezK5rV+chrCLYUPbYm3MNowfAZSh+dG+rrJSu1RtiO7gOFOmfvqrsDbYt4Pnv2KYEIqr3GpEjO6kbL49PjPLxcItK8obUBlBxSWM4fueDC6hNx/GaxVdL6g+mBf2Y3tQNSOzG4GD5eghAXKiMRhVYfndz1tOxJHcquVs47jNNK/5SJV752kIurVyzMXawWt61A5hm73DmaP33HaM9rG6IuoLvMaCfbssfkAf7kpRIUl0CP+vnId/PS/mehEx2NW3bC3sqwy1Yxp80/06ISBh5ZaG5txpTSrM5RPf7MdWYgP4Zu8PSyKSRHfF+Q5JQLmGaNMhNbXuwAMF7N0nPnPXqkA/kftNdQ60v+ItiujfFfB4mg7EwnvRS+3jmc/oLmqnvuK2ZM6OpD+4MUgSCkkqdNe3jI1N5nY6dStf4d0V3dDZB39KoIkXBBcQB8yIPnqMpLBtWOT6ec6VcUj26n56WYCBlKnl6pt9Pmr7vz7IixA9htZzLCA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

------=_Part_79092_165404979.1774595285114
Content-Type: text/plain; charset=GBK
Content-Transfer-Encoding: base64

SGk6CiAgICAgIFlvdSBtYXkgcmVmZXIgdG8gdGhlIHBhaG9sZSB0ZXN0IHJlc3VsdHMgYmVmb3Jl
IGFuZCBhZnRlciB0aGUgbW9kaWZpY2F0aW9uLiBUaGUgb2Zmc2V0cyBvZiBvdGhlciBtZW1iZXJz
IHJlbWFpbiB1bmNoYW5nZWQuIE9yaWdpbmFsbHksIG5yX2VtcHR5X3BvcF9wYWdlc3dhcyBwbGFj
ZWQgYWxvbmUgYXQgdGhlIGJlZ2lubmluZyBvZiB0aGUgdGhpcmQgY2FjaGUgbGluZS4gCkFmdGVy
IHRoZSBtb2RpZmljYXRpb24sIGl0IGhhcyBiZWVuIG1vdmVkIHRvIHRoZSBlbmQgb2YgdGhlIHNl
Y29uZCBjYWNoZSBsaW5lLgoKClRoYW5rcy4KQXQgMjAyNi0wMy0yNyAxMzoxNjo0MSwgIkFuZHJl
dyBNb3J0b24iIDxha3BtQGxpbnV4LWZvdW5kYXRpb24ub3JnPiB3cm90ZToKPk9uIFRodSwgIDUg
TWFyIDIwMjYgMTU6MzA6NDMgKzA4MDAgemVuZ2hvbmdsaW5nIDx6ZW5naG9uZ2xpbmdAa3lsaW5v
cy5jbj4gd3JvdGU6Cj4KPj4gU3ViamVjdDogW1BBVENIXSBtbS9wZXJjcHUtaW50ZXJuYWwuaDog
b3B0aW1pc2UgcGNwdV9jaHVua19zdHJ1Y3QgdG8gc2F2ZSBtZW1vcnkKPgo+VGhlcmUgaXMgbm8g
cGNwdV9jaHVua19zdHJ1Y3QsICBJJ2xsIGNoYW5nZSB0aGlzIHRvICJzdHJ1Y3QgcGNwdV9jaHVu
ayIuCj4KPj4gRGF0ZTogVGh1LCAgNSBNYXIgMjAyNiAxNTozMDo0MyArMDgwMAo+PiBTZW5kZXI6
IG93bmVyLWxpbnV4LW1tQGt2YWNrLm9yZwo+PiBYLU1haWxlcjogZ2l0LXNlbmQtZW1haWwgMi4y
NS4xCj4+IAo+PiBUaGUgcGNwdV9jaHVua19zdHJ1Y3QgaGFzIGEgaG9sZSBvZiA0IGJ5dGVzIGFu
ZCBwdXNoZXMgdGhlIHN0cnVjdCB0byB0aHJlZQo+PiBjYWNoZWxpbmVzLiAgUmVsb2NhdGluZyB0
aGUgdGhyZWUgYm9vbGVhbnMgdXB3YXJkcyBhbGxvd3MgZm9yIHRoZSBzdHJ1Y3QKPj4gdG8gb25s
eSB1c2UgdHdvIGNhY2hlbGluZXMuCj4KPmJlZm9yZToKPgo+KGdkYikgcCBzaXplb2Yoc3RydWN0
IHBjcHVfY2h1bmspCj4kMiA9IDI1Ngo+Cj5hZnRlcjoKPgo+KGdkYikgcCBzaXplb2Yoc3RydWN0
IHBjcHVfY2h1bmspCj4kMSA9IDE5Mgo+Cj5UaGF0J3MgcmVtYXJrYWJsZS4gIEl0IHdhcyBhbiBh
bGxtb2Rjb25maWcgYnVpbGQgd2hpY2ggdGVuZHMgdG8gYWRkCj5ibG9hdCwgYnV0IHRoZSBvbmx5
IHNvdXJjZS1sZXZlbCBhbHRlcmF0aW9uIHdhcyB0aGlzIHBhdGNoLgo+Cj4KPkFub3RoZXIgY29u
c2lkZXJhdGlvbiBoZXJlIGlzIHRoYXQgbW92aW5nIG1lbWJlcnMgYXJvdW5kIGNhbiBoYXZlIGEK
PnBlcmZvcm1hbmNlIGltcGFjdCAtIGl0IGNhbiBjYXVzZSBtb3JlIChvciBsZXNzKSBjYWNoZWxp
bmUKPmludmFsaWRhdGlvbnMuICBJIHdvcnJ5IHRoYXQgYmVjYXVzZSBzb21lb25lIGhhcyBjYXJl
ZnVsbHkgY29tbWVudGVkCj5hbGwgdGhlIG1lbWJlciBvZmZzZXRzLCB0aGlzIG1pZ2h0IGhhdmUg
YmVlbiBhIGNvbnNpZGVyYXRpb24uCj4KPkFsc28gSSB0aGluayB5b3VyIHBhdGNoIG1heSBoYXZl
IG1hZGUgdGhvc2UgY29tbWVudHMgaW5jb3JyZWN0Pwo+Cj4KPkRlbm5pcywgVGVqdW4sIENocmlz
dG9waDogSSB0aGluayB3ZSB3YW50IHRoaXMgc3BhY2Ugc2F2aW5nLiAgQ2FuCj55b3UgcGxlYXNl
IGFkdmlzZT8KPgo+VGhhbmtzLgo=
------=_Part_79092_165404979.1774595285114
Content-Type: text/html; charset=GBK
Content-Transfer-Encoding: base64

PGRpdiBkYXRhLW50ZXM9Im50ZXNfbWFpbF9ib2R5X3Jvb3QiIHN0eWxlPSJsaW5lLWhlaWdodDox
Ljc7Y29sb3I6IzAwMDAwMDtmb250LXNpemU6MTRweDtmb250LWZhbWlseTpBcmlhbCI+PGRpdiBp
ZD0ic3BuRWRpdG9yQ29udGVudCI+PGRpdiBzdHlsZT0ibWFyZ2luOiAwOyI+SGk6PC9kaXY+PGRp
diBzdHlsZT0ibWFyZ2luOiAwOyI+Jm5ic3A7ICZuYnNwOyAmbmJzcDsgWW91IG1heSByZWZlciB0
byB0aGUgcGFob2xlIHRlc3QgcmVzdWx0cyBiZWZvcmUgYW5kIGFmdGVyIHRoZSBtb2RpZmljYXRp
b24uIFRoZSBvZmZzZXRzIG9mIG90aGVyIG1lbWJlcnMgcmVtYWluIHVuY2hhbmdlZC4gT3JpZ2lu
YWxseSwgPGNvZGUgY2xhc3M9Imh5Yy1jb21tb24tbWFya2Rvd25fX2NvZGVfX2lubGluZSI+bnJf
ZW1wdHlfcG9wX3BhZ2VzPC9jb2RlPndhcyBwbGFjZWQgYWxvbmUgYXQgdGhlIGJlZ2lubmluZyBv
ZiB0aGUgdGhpcmQgY2FjaGUgbGluZS4mbmJzcDs8L2Rpdj48ZGl2IHN0eWxlPSJtYXJnaW46IDA7
Ij5BZnRlciB0aGUgbW9kaWZpY2F0aW9uLCBpdCBoYXMgYmVlbiBtb3ZlZCB0byB0aGUgZW5kIG9m
IHRoZSBzZWNvbmQgY2FjaGUgbGluZS48L2Rpdj48ZGl2IHN0eWxlPSJtYXJnaW46IDA7Ij48YnI+
PC9kaXY+PGRpdiBzdHlsZT0ibWFyZ2luOiAwOyI+VGhhbmtzLjwvZGl2PjwvZGl2PjxwcmU+QXQg
MjAyNi0wMy0yNyAxMzoxNjo0MSwgIkFuZHJldyBNb3J0b24iICZsdDtha3BtQGxpbnV4LWZvdW5k
YXRpb24ub3JnJmd0OyB3cm90ZToKJmd0O09uIFRodSwgIDUgTWFyIDIwMjYgMTU6MzA6NDMgKzA4
MDAgemVuZ2hvbmdsaW5nICZsdDt6ZW5naG9uZ2xpbmdAa3lsaW5vcy5jbiZndDsgd3JvdGU6CiZn
dDsKJmd0OyZndDsgU3ViamVjdDogW1BBVENIXSBtbS9wZXJjcHUtaW50ZXJuYWwuaDogb3B0aW1p
c2UgcGNwdV9jaHVua19zdHJ1Y3QgdG8gc2F2ZSBtZW1vcnkKJmd0OwomZ3Q7VGhlcmUgaXMgbm8g
cGNwdV9jaHVua19zdHJ1Y3QsICBJJ2xsIGNoYW5nZSB0aGlzIHRvICJzdHJ1Y3QgcGNwdV9jaHVu
ayIuCiZndDsKJmd0OyZndDsgRGF0ZTogVGh1LCAgNSBNYXIgMjAyNiAxNTozMDo0MyArMDgwMAom
Z3Q7Jmd0OyBTZW5kZXI6IG93bmVyLWxpbnV4LW1tQGt2YWNrLm9yZwomZ3Q7Jmd0OyBYLU1haWxl
cjogZ2l0LXNlbmQtZW1haWwgMi4yNS4xCiZndDsmZ3Q7IAomZ3Q7Jmd0OyBUaGUgcGNwdV9jaHVu
a19zdHJ1Y3QgaGFzIGEgaG9sZSBvZiA0IGJ5dGVzIGFuZCBwdXNoZXMgdGhlIHN0cnVjdCB0byB0
aHJlZQomZ3Q7Jmd0OyBjYWNoZWxpbmVzLiAgUmVsb2NhdGluZyB0aGUgdGhyZWUgYm9vbGVhbnMg
dXB3YXJkcyBhbGxvd3MgZm9yIHRoZSBzdHJ1Y3QKJmd0OyZndDsgdG8gb25seSB1c2UgdHdvIGNh
Y2hlbGluZXMuCiZndDsKJmd0O2JlZm9yZToKJmd0OwomZ3Q7KGdkYikgcCBzaXplb2Yoc3RydWN0
IHBjcHVfY2h1bmspCiZndDskMiA9IDI1NgomZ3Q7CiZndDthZnRlcjoKJmd0OwomZ3Q7KGdkYikg
cCBzaXplb2Yoc3RydWN0IHBjcHVfY2h1bmspCiZndDskMSA9IDE5MgomZ3Q7CiZndDtUaGF0J3Mg
cmVtYXJrYWJsZS4gIEl0IHdhcyBhbiBhbGxtb2Rjb25maWcgYnVpbGQgd2hpY2ggdGVuZHMgdG8g
YWRkCiZndDtibG9hdCwgYnV0IHRoZSBvbmx5IHNvdXJjZS1sZXZlbCBhbHRlcmF0aW9uIHdhcyB0
aGlzIHBhdGNoLgomZ3Q7CiZndDsKJmd0O0Fub3RoZXIgY29uc2lkZXJhdGlvbiBoZXJlIGlzIHRo
YXQgbW92aW5nIG1lbWJlcnMgYXJvdW5kIGNhbiBoYXZlIGEKJmd0O3BlcmZvcm1hbmNlIGltcGFj
dCAtIGl0IGNhbiBjYXVzZSBtb3JlIChvciBsZXNzKSBjYWNoZWxpbmUKJmd0O2ludmFsaWRhdGlv
bnMuICBJIHdvcnJ5IHRoYXQgYmVjYXVzZSBzb21lb25lIGhhcyBjYXJlZnVsbHkgY29tbWVudGVk
CiZndDthbGwgdGhlIG1lbWJlciBvZmZzZXRzLCB0aGlzIG1pZ2h0IGhhdmUgYmVlbiBhIGNvbnNp
ZGVyYXRpb24uCiZndDsKJmd0O0Fsc28gSSB0aGluayB5b3VyIHBhdGNoIG1heSBoYXZlIG1hZGUg
dGhvc2UgY29tbWVudHMgaW5jb3JyZWN0PwomZ3Q7CiZndDsKJmd0O0Rlbm5pcywgVGVqdW4sIENo
cmlzdG9waDogSSB0aGluayB3ZSB3YW50IHRoaXMgc3BhY2Ugc2F2aW5nLiAgQ2FuCiZndDt5b3Ug
cGxlYXNlIGFkdmlzZT8KJmd0OwomZ3Q7VGhhbmtzLgo8L3ByZT48L2Rpdj4=
------=_Part_79092_165404979.1774595285114--



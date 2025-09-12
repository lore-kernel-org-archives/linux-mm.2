Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 07BFDCAC58E
	for <linux-mm@archiver.kernel.org>; Fri, 12 Sep 2025 02:02:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5E9018E0008; Thu, 11 Sep 2025 22:02:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5992F8E0006; Thu, 11 Sep 2025 22:02:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 487C88E0008; Thu, 11 Sep 2025 22:02:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 309AD8E0006
	for <linux-mm@kvack.org>; Thu, 11 Sep 2025 22:02:45 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id B6F6811A94C
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 02:02:44 +0000 (UTC)
X-FDA: 83878949448.22.B8F0675
Received: from m16.mail.163.com (m16.mail.163.com [117.135.210.3])
	by imf27.hostedemail.com (Postfix) with ESMTP id 8E5D14000A
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 02:02:41 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=fail ("body hash did not verify") header.d=163.com header.s=s110527 header.b="G 5kpzQV";
	spf=pass (imf27.hostedemail.com: domain of 00107082@163.com designates 117.135.210.3 as permitted sender) smtp.mailfrom=00107082@163.com;
	dmarc=pass (policy=none) header.from=163.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757642562;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LJmEQZs13F/FHF4ypoYTiLXFKxIIeE3eH7OBaf23C2g=;
	b=tpnaRqSpZaAj3l9RBt8ry9m/yD89Ui4rOWjNpZBWCWCdErxoGoc4BKGMVf3kNDkwlpHquW
	XWPFk5k22WPE2t1Zg54jLcukQNmMmdWrdiTSTIhmml/XHtFGl7L+z1VFJyvHDy/zEWLpJQ
	dMlBBRED8eJyahtLENbmtpdToFyw1Wc=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=fail ("body hash did not verify") header.d=163.com header.s=s110527 header.b="G 5kpzQV";
	spf=pass (imf27.hostedemail.com: domain of 00107082@163.com designates 117.135.210.3 as permitted sender) smtp.mailfrom=00107082@163.com;
	dmarc=pass (policy=none) header.from=163.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757642562; a=rsa-sha256;
	cv=none;
	b=7f+Tv0NavhrTrQX0TT2tQ+ELXmmJMLEZZP9gwIyXvhlB1tbVTu5/u0otvI0BMsb5agvUbk
	+wSMgF9fJ82qMextgRz/1Ub2QOy12POTl5dOtSeDXWcyQ1mqnx3Angg9hmnnd2zKx/jxKF
	8qe4oDvXkT1MEbKdCLsal1iKTFPIFn8=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=Date:From:To:Subject:Content-Type:MIME-Version:
	Message-ID; bh=2gaxk0ynRjWPbUcOPBABXZM/j5g3V2zX3Gie3kenttI=; b=G
	5kpzQVc/csgYi0KfemtadKSsFnjqAUJEuEWUWMt5Q38igTntyww6fnpNtY8bzt/g
	uXnMSbeZL0Hn+nHUKpP3gh+IXEhhMNwbfubBHyuV5EXpj7S6PyF0iMg6aJlQnNQ5
	fbBThsArpU+0JHVoKYazWINNDhy15RrDfOGrtAxVd8=
Received: from 00107082$163.com ( [111.35.190.173] ) by
 ajax-webmail-wmsvr-40-123 (Coremail) ; Fri, 12 Sep 2025 10:02:22 +0800
 (CST)
X-Originating-IP: [111.35.190.173]
Date: Fri, 12 Sep 2025 10:02:22 +0800 (CST)
From: "David Wang" <00107082@163.com>
To: "Suren Baghdasaryan" <surenb@google.com>
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
	"Usama Arif" <usamaarif642@gmail.com>,
	"Yueyang Pan" <pyyjason@gmail.com>, kent.overstreet@linux.dev,
	vbabka@suse.cz, hannes@cmpxchg.org, rientjes@google.com,
	roman.gushchin@linux.dev, harry.yoo@oracle.com,
	shakeel.butt@linux.dev, pasha.tatashin@soleen.com,
	souravpanda@google.com, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] alloc_tag: mark inaccurate allocation counters in
 /proc/allocinfo output
X-Priority: 3
X-Mailer: Coremail Webmail Server Version 2023.4-cmXT build
 20250723(a044bf12) Copyright (c) 2002-2025 www.mailtech.cn 163com
In-Reply-To: <CAJuCfpEoWtgv8k4vApkGsNNUYFBnvS-N2DPQu2JrreCUPbT5dA@mail.gmail.com>
References: <20250909234942.1104356-1-surenb@google.com>
 <20cafc1c.a658.199394de44e.Coremail.00107082@163.com>
 <aMLvCCZbmpSE/aql@devbig569.cln6.facebook.com>
 <902f5f32-2f03-4230-aab0-a886fd8e4793@gmail.com>
 <20250911143132.ca88948c48df874f71983218@linux-foundation.org>
 <CAJuCfpEoWtgv8k4vApkGsNNUYFBnvS-N2DPQu2JrreCUPbT5dA@mail.gmail.com>
X-NTES-SC: AL_Qu2eBfqfvU0v5CKbZukZnEYQheY4XMKyuPkg1YJXOp80kSTOyB09YWNjB0v388e2MQqGmxSvbTF3wc5YRbl+baiNah29d8FEZXTnPdap4JF1
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset=UTF-8
MIME-Version: 1.0
Message-ID: <1880ff7f.1d98.1993ba8cca1.Coremail.00107082@163.com>
X-Coremail-Locale: zh_CN
X-CM-TRANSID:eygvCgD3v7Mvf8NorwgGAA--.15023W
X-CM-SenderInfo: qqqrilqqysqiywtou0bp/1tbiMxTGqmjDX53NQAADss
X-Coremail-Antispam: 1U5529EdanIXcx71UUUUU7vcSsGvfC2KfnxnUU==
X-Rspamd-Queue-Id: 8E5D14000A
X-Stat-Signature: ntfciaa17fcm599xy3netmmwgd86c65s
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1757642561-928963
X-HE-Meta: U2FsdGVkX1+yc67mNelB3pUT2ayR8iYeb7gOkrjH9qVwbtYD8m+UNtiBaMGY8fFoEh/ai6MJtbBIijJTT9mZREKk/IidY/Pwg1NeRsoGLIxz+0G0TcA5K+sdt9EitJo538h6yNa+T+yOavlfQFiIWZr4iRFgFsPAj592kN8YqsgBHWXWaMi7wIqAArt+1L8zXy8s5mzxvr5InbER7fW3ksG5xB+Xjtn/V4JjSwbY66GpcvuxNFNxEFHH3ZgivoeE8GIwYrO7JaB/q1Tk1uRbo2SrwcGT9fYmYFJGneTYFIysvLGIm1/24CNWho0h3imC6ey/o+/fmhNwHT+Nu+8pHqzKBIZnQDQnw3kmLt1SzHGfP1B4aDdRXYO6kJTmSA9KgazMgzp+Du5P5B6gf72Xx9m37SH1RTXZavpkiodZg2AJwEXJgyXiQP8Pt+mjYkDM1+MJmgN3nEWjKnPii0huvDO/MK0r9qWDU8DJ3gB7YOwBHLBVY0di2y5ZjoICi5rcYf9kRhYjEQzxr3y/B2dpQ4hosT90FCUrUiqIzZ7wTdaMpm4g34T0zF/WqPAccBxg84pv+xrbdGzhITmIYTYI7XxiMDXzGkP2YwnR3pIJKUPAazR7La/uZ9OaxmHGcfWnc6MVjznSR3f7Nzoek8yoqijaq+Bt1bRn8p5APTrp/T7SXBh/yU15Gipk8AV7cmygW0U2Y7l/ZiU6WjHPSbbTgQ8bcbsEmn8SOnPGHcQ06BqMysX1k5uNWlNN4Ud2Bgocty+Swe3KgYjvKQSx/Et0LWwCcz5NXV6ABpSvlLpXqQc6qUywb1JWQqNNdn3KHqtRJLvPexgHUbxQ9CbLo8VFI48jFjMaNCR29U0XGwk3VE6RS64eFeYZc0qJ1L9cRvXv//r7tI+wovgIkMgPp3I/ml7do30HX1R/BWBGFmbKEqonakF4xFNfyqWc0a7VpKXqmhGYtynxDsFeqXBSZGi
 kT48Ct7N
 pPpYwejoYtP5WVhYpyN3Q06wHrF9Wxkw5A9uLgd4wa9pQ2O8AXvVSExb5FkyxyZ2goragkQNR95LaO4Xbs0DxSRo/wDwrCi7x9XT7Hnm5KgUzF3grK7mNfn09be6J5l+90PIQg7t/7EEDG62KZBVOiEOlm+6gUtlSG3Exc0Uulh4wMknpnIA8Q27hNOvvMVbhyZ1k8p89+orjXZ+jZE4SyF5jmwUlb636cFRN/+VXhdyq9zmFpgt7Y5Dw+wK7BoqvYVUnSQIyCaXGiwqfgwPi9JkWZH1LYY+nc2SikO3f1XfIb2OhMtOQF2W3sMjIv+iv/c8+3ufDQE5V42tI+t7+eNXXZoNgWmWgjTYdxV5f2BKQdHkAAMh5J0tUFwkUEqQuQSYbbKpMBjhBgjv9YI4HpStnG5+dsYZU7NWl21ei+FWoBgs1ugoKzJYSfcOINg9C+STWa9od5qwrbCVoF2JMP2e6xqT6XMOlq7aQGDrWIsZWrECz2cByNsP8EkzQtVpQwDahDUYTBFaA4kR+5EWHHhwX8FscMFHOYSyqaU0OOKsIUeQ5Ht9BLAIm6GXAJS5ThJqzyfvwgCPIi3iA/LYkwjiVTFOlvnZwAa5ZY3Q1dV0C5uFVd+RfdiSxQyA1zLnQxgQJhIijF7QpF73UHTVW76MltfSc6b58/Srx15Piz7G9ESBelidBYYncEg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

CkF0IDIwMjUtMDktMTIgMDg6MjU6MTIsICJTdXJlbiBCYWdoZGFzYXJ5YW4iIDxzdXJlbmJAZ29v
Z2xlLmNvbT4gd3JvdGU6Cj5PbiBUaHUsIFNlcCAxMSwgMjAyNSBhdCAyOjMx4oCvUE0gQW5kcmV3
IE1vcnRvbiA8YWtwbUBsaW51eC1mb3VuZGF0aW9uLm9yZz4gd3JvdGU6Cj4+Cj4+IE9uIFRodSwg
MTEgU2VwIDIwMjUgMTI6MDA6MjMgLTA0MDAgVXNhbWEgQXJpZiA8dXNhbWFhcmlmNjQyQGdtYWls
LmNvbT4gd3JvdGU6Cj4+Cj4+ID4gPiBJIHRoaW5rIHNpbXBseSBhZGRpbmcgKiB0byB0aGUgZW5k
IG9mIGZ1bmN0aW9uIG5hbWUgb3IgZmlsZW5hbWUgaXMgc3VmZmljaWVudAo+PiA+ID4gYXMgdGhl
eSBhcmUgYWxyZWFkeSBzdHIuCj4+ID4gPgo+PiA+Cj4+ID4gSW5zdGVhZCBvZjoKPj4gPgo+PiA+
IDQ5MTUyKiAgICAgIDQ4KiBhcmNoL3g4Ni9rZXJuZWwvY3B1L21jZS9jb3JlLmM6MjcwOSBmdW5j
Om1jZV9kZXZpY2VfY3JlYXRlCj4+ID4KPj4gPiBDb3VsZCB3ZSBkbyBzb21ldGhpbmcgbGlrZToK
Pj4gPgo+PiA+IDQ5MTUyICAgICAgNDggYXJjaC94ODYva2VybmVsL2NwdS9tY2UvY29yZS5jOjI3
MDkgZnVuYzptY2VfZGV2aWNlX2NyZWF0ZShpbmFjY3VyYXRlKQo+Pgo+PiBDYW4gd2UgYWRkIGFu
b3RoZXIgcm93LCBzYXlpbmcgInRoZSBwcmV2aW91cyByb3cgd2FzIGluYWNjdXJhdGUiPyAgSQo+
PiBndWVzcyB0aGF0IHdvdWxkIGJyZWFrIHBhcnNlcnMgYWxzby4KPj4KPj4KPj4KPj4gSSBkb24n
dCBrbm93IGlmIHRoaXMgd2FzIGJ5IGRlc2lnbiwgYnV0IHRoZSBwcmVzZW50IGZvcm1hdCBkb2Vz
IHByb3ZpZGUKPj4gZXh0ZW5zaWJpbGl0eS4gIEl0IGlzIGJhc2ljYWxseQo+Pgo+PiAgICAgICAg
IE5OTk4gTk5OIG5hbWU6dmFsdWUgbmFtZTp2YWx1ZQo+Pgo+PiBvbmUgY291bGQgYXJndWFibHkg
YXBwZW5kIGEgdGhpcmQgbmFtZTp2YWx1ZSBhbmQgaG9wZSB0aGF0IGF1dGhvcnMgb2YKPj4gZXhp
c3RpbmcgcGFyc2VycyBmaWd1cmVkIHRoaXMgb3V0Lgo+Cj5BY3R1YWxseSB0aGF0IHNvdW5kcyBs
aWtlIHRoZSBiZXN0IGlkZWEgc28gZmFyLiBDdXJyZW50bHkgdGhlIGZvcm1hdCBpczoKPgo+PGJ5
dGVzPiA8Y291bnQ+IDxmaWxlPjo8bGluZT4gWzxtb2R1bGU+XSBmdW5jOjxmdW5jdGlvbj4KPgo+
V2UgY2FuIGFkb3B0IGEgcnVsZSB0aGF0IGFmdGVyIHRoaXMsIHRoZSBsaW5lIGNhbiBjb250YWlu
IGFkZGl0aW9uYWwKPmtleTp2YWx1ZSBwYWlycy4gSW4gdGhhdCBjYXNlIGZvciBpbmFjY3VyYXRl
IGxpbmVzIHdlIGNhbiBhZGQ6Cj4KPjQ5MTUyICAgICAgNDggYXJjaC94ODYva2VybmVsL2NwdS9t
Y2UvY29yZS5jOjI3MDkKPmZ1bmM6bWNlX2RldmljZV9jcmVhdGUgYWNjdXJhdGU6bm8KPgo+SW4g
dGhlIGZ1dHVyZSB3ZSBjYW4gYXBwZW5kIG1vcmUga2V5OnZhbHVlIHBhaXJzIGlmIHdlIG5lZWQg
dGhlbS4KPlBhcnNlcnMgd2hpY2ggZG9uJ3Qga25vdyBob3cgdG8gcGFyc2UgYSBuZXcga2V5IGNh
biBzaW1wbHkgaWdub3JlCj50aGVtLgo+Cj5Eb2VzIHRoYXQgc291bmQgZ29vZCB0byBldmVyeW9u
ZT8KClRoaXMgbG9va3MgZ29vZCB0byBtZSwgYXQgbGVhc3QgZm9yIG15IHRvb2xzLiA6KQpPbiBt
eSBzeXN0ZW0sIHRoZXJlIGFyZSA0SysgbGluZXMgb2YgaXRlbXMsIGVhY2ggYnl0ZSBhZGRlZCB3
b3VsZCBpbmNyZWFzZSA0SytieXRlcyBmb3Igb25lIHJlYWQsCmJ1dCBnb29kIHRoaW5nIGlzIG5v
cm1hbGx5ICJhY2N1cmF0ZTpubyIgd291bGQgbm90IHNob3cgdXAuIAoKRGF2aWQKCj4KPj4KPj4K
Pj4gV2hhdGV2LiAgSSdsbCBkcm9wIHRoaXMgdmVyc2lvbiBmcm9tIG1tLmdpdC4K


Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 07D0BE9B24E
	for <linux-mm@archiver.kernel.org>; Tue, 24 Feb 2026 11:16:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3FAEA6B0088; Tue, 24 Feb 2026 06:16:10 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3A82D6B0089; Tue, 24 Feb 2026 06:16:10 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2B4A36B008A; Tue, 24 Feb 2026 06:16:10 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 15BC26B0088
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 06:16:10 -0500 (EST)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id B322A1404AC
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 11:16:09 +0000 (UTC)
X-FDA: 84479096058.13.646A4B6
Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.4])
	by imf11.hostedemail.com (Postfix) with ESMTP id A0A2040007
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 11:16:06 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b="W +FzX9P";
	spf=pass (imf11.hostedemail.com: domain of 00107082@163.com designates 220.197.31.4 as permitted sender) smtp.mailfrom=00107082@163.com;
	dmarc=pass (policy=none) header.from=163.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771931767;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3MX6iVaxWacKaq1mv6fxAgl2nD/JY+roa/MoMz29xJI=;
	b=cii2IDq1pfbhenbvggX+04PFuVoH6U/Gr+mNdkoAkyIv6vZSOW4r0IACoNPl064Gp2oPGB
	yXZa6w6pt5WYgVSIn1rmrKFba4uGzED4C+bOzPru7V+8fkOnletHqYgkmrSz2PyJ8JcvZr
	v5qhukN1M3Eai7i1F0OIZrR42934lmY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771931767; a=rsa-sha256;
	cv=none;
	b=MFb6eT7G2QHDc80Uno2237cIrBkLADgg0DyWzQpAgh7yKGAjEusY7lxPNemV5Wq+qzZVm9
	0/OY5nW//viygXbBi/Gw+95czdDbCj2x/MNl9feoal2BmOpddLvd7JtN2shHedIpPyAUcZ
	bp1SWmB33v4CwQ29ckAeDbFqyaxzniE=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b="W +FzX9P";
	spf=pass (imf11.hostedemail.com: domain of 00107082@163.com designates 220.197.31.4 as permitted sender) smtp.mailfrom=00107082@163.com;
	dmarc=pass (policy=none) header.from=163.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=Date:From:To:Subject:Content-Type:MIME-Version:
	Message-ID; bh=3MX6iVaxWacKaq1mv6fxAgl2nD/JY+roa/MoMz29xJI=; b=W
	+FzX9Plts/jYH5/R2n1mo+C4gLRdvCk5aFHsfreqrGLuiOmGwASqoWfjtPowtBTU
	9N3DxWYYc7VmrbA5s30CvuATQml/72QXtOWmVKrJ137ZNvlYegU7/PkPo/9FmQLp
	RWYLirH0XoVXBwp6GDoBXFz31C9m860C5iQoGHFV2Y=
Received: from 00107082$163.com ( [111.35.188.114] ) by
 ajax-webmail-wmsvr-40-141 (Coremail) ; Tue, 24 Feb 2026 19:15:32 +0800
 (CST)
X-Originating-IP: [111.35.188.114]
Date: Tue, 24 Feb 2026 19:15:32 +0800 (CST)
From: "David Wang" <00107082@163.com>
To: "Suren Baghdasaryan" <surenb@google.com>
Cc: "Vlastimil Babka" <vbabka@suse.com>, vbabka@suse.cz, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, "Harry Yoo" <harry.yoo@oracle.com>
Subject: Re: [7.0-rc1] codetag: kernel warning "alloc_tag was not set"
 during boot
X-Priority: 3
X-Mailer: Coremail Webmail Server Version 2023.4-cmXT build
 20251222(83accb85) Copyright (c) 2002-2026 www.mailtech.cn 163com
In-Reply-To: <CAJuCfpEsykCarj6_k5T9EeLDfsA0fFL182g1hQ+tb-7EM=izsw@mail.gmail.com>
References: <20260223155128.3849-1-00107082@163.com>
 <6ca5f70c-43c5-4ba3-bdc4-8c48607dbe7c@suse.com>
 <37bbaa9.1831.19c8d7a2cac.Coremail.00107082@163.com>
 <CAJuCfpEsykCarj6_k5T9EeLDfsA0fFL182g1hQ+tb-7EM=izsw@mail.gmail.com>
X-NTES-SC: AL_Qu2cA/WYvk8o5CGQZekXn0oTju85XMCzuv8j3YJeN500sibtxwsgQ0FCLUnW89i9BgeeqR+HSjV00c53QaJyTo42A4iqg6su1q34LrTo9XmF
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset=UTF-8
MIME-Version: 1.0
Message-ID: <1fc0ba5b.691c.19c8f5c88e1.Coremail.00107082@163.com>
X-Coremail-Locale: zh_CN
X-CM-TRANSID:jSgvCgDXF1JViJ1pe7RsAA--.46470W
X-CM-SenderInfo: qqqrilqqysqiywtou0bp/xtbC7RX4o2mdiFXgsAAA3a
X-Coremail-Antispam: 1U5529EdanIXcx71UUUUU7vcSsGvfC2KfnxnUU==
X-Rspam-User: 
X-Stat-Signature: mhmrfq1q8ir3oa4n5juth3dkzc5gfkkk
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: A0A2040007
X-HE-Tag: 1771931766-645324
X-HE-Meta: U2FsdGVkX1+LWxAnZlr6rd5Ng599OWP/PoWUD0v+hKP+B4h2mkCYkwGCgaYI4y/y0nW3SvBvVq8Z+KXaK1k+za1ZJlsd2CptQ1HO41bQhS+jC0XwAmV4A3IPIkvDCZj4+1aE4FXufEw6XQZRWLyZo5AqJ57U6nhyq7zDpwOIIaWE1F8KjEO7skVbsVB/b5F9RO2luBn/Pk1yqV4WlFqk3efG7LnXp0w9TPvXIZ+xOPuh1bYezEQ5nBAQNWMVQABvcPosdhoikBJDpl34YI2SFr6jM3Q3jBcHlpmaivXhvwJaOaQgTgePNND8sYxPBi5gAjpeCCkNnNzvXRtguuTxrZMB7j4GHGBfjvQXFbfFrpADdD/FVn6PRy6IFgyFB7WpKKZKMP5CDFrjCjSRdr/bOcHhLH88c1PsdU3iUU/yaAQ1qk8g1UX5pywVaWQ7AepazWWAa2G2SanbUHSca/dWnMPw6CAYy7IIptIoXLQZPCXh9mF/iYbkyZTYeocOhL1rjjCtsUU4xhpH281IO/pWS4YOaX0qSSQBv1gGgd9aeE3SbFMYIOiVAMD9w9Po8AzfGH9Ww/jc+O4HVswpij7yMhwtuzdjaTnj0M12ya6qaXZIFJ22dk9AS+Ec/Z1cz5Yh6HRp22qPnzKW9+fIGz66zDrBLTVU3cVC/mQWR8bohvB6TbjSlLiwBNwdrxE0pIlvFTb6DFatn02nA8ZnR7rQlflSYFojCNV40UyHWiSY1BmyICCHhukEZIIOiL5m5gUT7iMFrZxbJum1fHXT0CopJOqkfEO95F3hBpteGkUKPID1hbBnYcZrHbIHAP7ZOdBaeJbC/Y5TnaZynKWsIr7J4xNWmaZOVUeRLq9Ee89CaqMRuo9YS60sDgXX+fha0Y8LjeYAxFraOtfqp2wfyGjQmz3+sWvSt9HVVsNcdhV2VvSz4XKtrcW2pdjBBxasWWl4V5H63xsZrKd2Haxoy8M
 XEVbrOP8
 OnKZKNzaH9EgqM5y0zP3p72dQK8/xGMgFKMA/d5CtT1sx2JTYjhuTFGYWJhuNDx4kEnEzvtJf8ZMwuOCngsa23kgPdHU9QADQ7aDk1wiYq74UJ1svq0CZ1ZR7ELrYtGjfJXDcbOSK0Vwd6cwupIe25n8jmZk1JRyTogMg7XjZF8WiNMo2sAEEd+juo0YV0a9LfNoSedvLd4H8cNrdt2cZcisyfPtR8x/tENRoxH19/73N0KetfQKnBjkFP5aJjKKNpJk2rdlL9OyqtVvdHR4JLGJ+pqlmquk2DHCcoFxBW/wwbaoiTi/LmPibE2Ejs0v1sx12kFOK5xqcrvTz6uYatAFFHo42sKWvKJRwoMx/UlRVi8GaJU4LYxA6GRewJzM55gh7zceGvBi/tGNvkcn8pzBQqQyaZ6it6Uj0NP0LfKXGWrpvLyGHzhmLXli9f0rG5k88ZZSRllRvNPc/K8c0vEMpkrRIF5LRhv+rrf9x8/kKs0+71TJ7pIOqzciw+rub5cMiaMA16XzHD/7aOY/o42hb4SeV4m+8wpXih/fBbhzZfHKVxezTuVau3WPgcFl17k2rCXpSog8EBnuEVVLLIHTXFoiiqiI2VrNpffgvYtqfMb1g/fOwH77hmDd3NqgrOf7vXnt/Gq9OQckfhLn0+TZom4XIsAiE8zvO
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

CgoKQXQgMjAyNi0wMi0yNCAxNTowNzowOCwgIlN1cmVuIEJhZ2hkYXNhcnlhbiIgPHN1cmVuYkBn
b29nbGUuY29tPiB3cm90ZToKPk9uIE1vbiwgRmViIDIzLCAyMDI2IGF0IDY6MjjigK9QTSBEYXZp
ZCBXYW5nIDwwMDEwNzA4MkAxNjMuY29tPiB3cm90ZToKPj4KPj4KPj4gQXQgMjAyNi0wMi0yNCAw
MToxODozMiwgIlZsYXN0aW1pbCBCYWJrYSIgPHZiYWJrYUBzdXNlLmNvbT4gd3JvdGU6Cj4+ID5P
biAyLzIzLzI2IDE2OjUxLCBEYXZpZCBXYW5nIHdyb3RlOgo+PiA+PiBIaSwKPj4gPj4KPj4gPj4g
V2hlbiB1cGdyYWRlIHRvIDcuMC4wLXJjMSwgY2F1Z2h0IGEga2VybmVsIFdBUk4gZHVyaW5nIGJv
b3Q6Cj4+ID4KPj4gPldvdWxkIHRoaXMgcG9zc2libHkgaGVscD8gKGl0IHByb2JhYmx5IHNob3Vs
ZG4ndCBidXQgbGV0J3Mgc2VlKQo+PiA+aHR0cHM6Ly9sb3JlLmtlcm5lbC5vcmcvYWxsLzIwMjYw
MjIzMDc1ODA5LjE5MjY1LTEtaGFycnkueW9vQG9yYWNsZS5jb20vCj4+ID4KPj4KPj4gSGksCj4+
IEkgdHJpZWQgdGhpcyBwYXRjaCwgYnV0IHNhZGx5LCBpdCBkb2Vzbid0IGhlbHAgd2l0aCB0aGUg
d2FybmluZyBvbiBteSBzeXN0ZW0uLi4KPgo+VW5mb3J0dW5hdGVseSBJIGNhbid0IGJvb3QgZmFy
IGVub3VnaCB3aXRoIHlvdXIgY29uZmlnIHRvIGdldCB0aGF0IHdhcm5pbmcuCj4KPllvdSBtaWdo
dCBiZSBhYmxlIHRvIHRyYWNrIGRvd24gd2hpY2ggYWxsb2NhdGlvbiBkb2VzIG5vdCBnZXQgaXRz
IHRhZwo+YnkgZmlyc3QgY2hlY2tpbmcgZm9yIGN1cnJlbnQtPmFsbG9jX3RhZz09TlVMTCBpbnNp
ZGUKPl9fYWxsb2NfdGFnZ2luZ19zbGFiX2FsbG9jX2hvb2soKSBhbmQgZHVtcCB0aGUgc3RhY2sg
aWYgdGhhdCBoYXBwZW5zLgo+SWYgdGhlcmUgYXJlIG5vIGhpdHMgKHdoaWNoIGlzIHByb2JhYmx5
IHdoYXQgd2lsbCBoYXBwZW4pIHlvdSBjYW4gZG8KPnRoZSBzYW1lIHdoaWxlIGNoZWNraW5nIGZv
ciBvYmpfZXh0cz09TlVMTC4gSSBzdXNwZWN0IHRoYXQgY29uZGl0aW9uCj53aWxsIGhpdCBtdWx0
aXBsZSB0aW1lcyBhbmQgb25lIG9mIHRob3NlIHdpbGwgbGlrZWx5IGJlIHRoZSBjYXVzZSBvZgo+
dGhpcyB3YXJuaW5nLiBJJ2xsIGxvb2sgaW50byB0aGlzIG1vcmUgdG9tb3Jyb3cgaWYgdGhlIGNh
dXNlIGlzIG5vdAo+Zm91bmQgYnkgdGhlbi4KCkkgdGhyb3cgaW4gc29tZSBkZWJ1ZyBjb2RlIDoK
CmlmZiAtLWdpdCBhL21tL3NsdWIuYyBiL21tL3NsdWIuYwppbmRleCA4NjI2NDJjMTY1ZWQuLjJm
NzJmYmFlNGVjYyAxMDA2NDQKLS0tIGEvbW0vc2x1Yi5jCisrKyBiL21tL3NsdWIuYwpAQCAtMjM3
NSw2ICsyMzc1LDE0IEBAIF9fYWxsb2NfdGFnZ2luZ19zbGFiX2FsbG9jX2hvb2soc3RydWN0IGtt
ZW1fY2FjaGUgKnMsIHZvaWQgKm9iamVjdCwgZ2ZwX3QgZmxhZ3MpCiAgICAgICAgICogY2hlY2sg
c2hvdWxkIGJlIGFkZGVkIGJlZm9yZSBhbGxvY190YWdfYWRkKCkuCiAgICAgICAgICovCiAgICAg
ICAgaWYgKG9ial9leHRzKSB7CisgICAgICAgICAgICAgICBpZiAoIWN1cnJlbnQtPmFsbG9jX3Rh
ZykgeworICAgICAgICAgICAgICAgICAgICAgICBzdGF0aWMgaW50IGNvdW50ZXI9MDsKKyAgICAg
ICAgICAgICAgICAgICAgICAgaWYgKGNvdW50ZXI9PTApIHsKKyAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICBwcl93YXJuKCJvYmplY3RfZXh0cyAmICFjdXJyZW50LT5hbGxvY190YWciKTsK
KyAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICBkdW1wX3N0YWNrKCk7CisgICAgICAgICAg
ICAgICAgICAgICAgIH0KKyAgICAgICAgICAgICAgICAgICAgICAgY291bnRlcisrOworICAgICAg
ICAgICAgICAgfQogICAgICAgICAgICAgICAgdW5zaWduZWQgaW50IG9ial9pZHggPSBvYmpfdG9f
aW5kZXgocywgc2xhYiwgb2JqZWN0KTsKIAogICAgICAgICAgICAgICAgZ2V0X3NsYWJfb2JqX2V4
dHMob2JqX2V4dHMpOwpAQCAtMjM4Miw2ICsyMzkwLDE0IEBAIF9fYWxsb2NfdGFnZ2luZ19zbGFi
X2FsbG9jX2hvb2soc3RydWN0IGttZW1fY2FjaGUgKnMsIHZvaWQgKm9iamVjdCwgZ2ZwX3QgZmxh
Z3MpCiAgICAgICAgICAgICAgICBhbGxvY190YWdfYWRkKCZvYmpfZXh0LT5yZWYsIGN1cnJlbnQt
PmFsbG9jX3RhZywgcy0+c2l6ZSk7CiAgICAgICAgICAgICAgICBwdXRfc2xhYl9vYmpfZXh0cyhv
YmpfZXh0cyk7CiAgICAgICAgfSBlbHNlIHsKKyAgICAgICAgICAgICAgIGlmICghY3VycmVudC0+
YWxsb2NfdGFnKSB7CisgICAgICAgICAgICAgICAgICAgICAgIHN0YXRpYyBpbnQgY291bnRlcj0w
OworICAgICAgICAgICAgICAgICAgICAgICBpZiAoY291bnRlcj09MCkgeworICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgIHByX3dhcm4oIiFvYmplY3RfZXh0cyAmICFjdXJyZW50LT5hbGxv
Y190YWciKTsKKyAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICBkdW1wX3N0YWNrKCk7Cisg
ICAgICAgICAgICAgICAgICAgICAgIH0KKyAgICAgICAgICAgICAgICAgICAgICAgY291bnRlcisr
OworICAgICAgICAgICAgICAgfQogICAgICAgICAgICAgICAgYWxsb2NfdGFnX3NldF9pbmFjY3Vy
YXRlKGN1cnJlbnQtPmFsbG9jX3RhZyk7CiAgICAgICAgfQogfQoKCkJ1dCBuZWl0aGVyICJvYmpl
Y3RfZXh0cyAmICFjdXJyZW50LT5hbGxvY190YWciIG5vciAiIW9iamVjdF9leHRzICYgIWN1cnJl
bnQtPmFsbG9jX3RhZyIgd2FzIGV2ZXIgaGl0LgoKClNvbWUgdXBkYXRlOgoxLiBTYW1lIHdhcm5p
bmcgc2hvd3MgdXAgd2l0aCBteSBLVk0gb24gdGhlIHNhbWUgaG9zdC4gIAoyLiByZXZlcnRpbmcg
OTEzZmZkM2ExYmY1IGNhbiBtYWtlIHRoZSB3YXJuaW5nIGdvIGF3YXkuCgoKRGF2aWQKCj4KPj4K
Pj4KPj4K


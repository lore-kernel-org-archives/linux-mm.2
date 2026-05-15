Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 19102CD4851
	for <linux-mm@archiver.kernel.org>; Fri, 15 May 2026 08:24:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 797176B00C7; Fri, 15 May 2026 04:24:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 747486B00C9; Fri, 15 May 2026 04:24:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 65CE36B00CE; Fri, 15 May 2026 04:24:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 53BA76B00C7
	for <linux-mm@kvack.org>; Fri, 15 May 2026 04:24:24 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 093461C1B94
	for <linux-mm@kvack.org>; Fri, 15 May 2026 08:24:24 +0000 (UTC)
X-FDA: 84768967248.26.55220BC
Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.4])
	by imf01.hostedemail.com (Postfix) with ESMTP id C2A5A40005
	for <linux-mm@kvack.org>; Fri, 15 May 2026 08:24:20 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b="G seDukq";
	spf=pass (imf01.hostedemail.com: domain of a929244872@163.com designates 220.197.31.4 as permitted sender) smtp.mailfrom=a929244872@163.com;
	dmarc=pass (policy=none) header.from=163.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778833462;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vPTHuJ4A5mmeJNqHautqNZjOtj9RGP06NLkcj78vbtg=;
	b=PCR0hPdO8gdci96yv/dVW1Lnlw9t87rwT35CCrmquSBpvG7Jl5loocd6CxiofxIg9bx2+B
	kY5ebTW+LhIah4nhUSTPm4P37YlO30zYn85/zHP/gApKR19VJ0jUrk9dV+sSsy8W942/O5
	7THFibxHdPlT+iJbp4LIQ9Zx/JWZ+78=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b="G seDukq";
	spf=pass (imf01.hostedemail.com: domain of a929244872@163.com designates 220.197.31.4 as permitted sender) smtp.mailfrom=a929244872@163.com;
	dmarc=pass (policy=none) header.from=163.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778833462; a=rsa-sha256;
	cv=none;
	b=MfZ/IJGmG2tkTYjDJKVbSkmBSfNCR0IXK+xiMsY7hNFJ2emALOiR5a9knbq6iRswNt4wky
	OQ18pZzaxOte3Ae9yukPwkUxenubtDv0L86YTSkAm9nr/Gn8fONzR0Db0hvbPkoGoq8oXO
	0khGVvu7/VVxJzWZzRh+6w5y/UKOs44=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=Date:From:To:Subject:Content-Type:MIME-Version:
	Message-ID; bh=vPTHuJ4A5mmeJNqHautqNZjOtj9RGP06NLkcj78vbtg=; b=G
	seDukqGqpMwFL6lgZs6m3SAB3NqYyD7TX4C8soK8KfkT5Xtx8XwE90LlbL+smA+6
	j6KaiGsJ7JPqUhYmYAVnV9vXpcvGf1Iayw3Opr0kN66QuB3mrRX0MGP66aU6Wt58
	deKG61NvbyhyZ+NoIfMp1K5TnL75EPU/VI17jG7d44=
Received: from a929244872$163.com ( [39.170.110.122] ) by
 ajax-webmail-wmsvr-40-114 (Coremail) ; Fri, 15 May 2026 16:23:42 +0800
 (CST)
X-Originating-IP: [39.170.110.122]
Date: Fri, 15 May 2026 16:23:42 +0800 (CST)
From: "wang wei" <a929244872@163.com>
To: "Minchan Kim" <minchan@kernel.org>
Cc: richardycc@google.com, akpm@linux-foundation.org, axboe@kernel.dk,
	bgeffon@google.com, linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	liumartin@google.com, senozhatsky@chromium.org,
	stable@vger.kernel.org
Subject: Re:Re: [PATCH] Re:[PATCH v3] zram: fix use-after-free in
 zram_writeback_endio
X-Priority: 3
X-Mailer: Coremail Webmail Server Version 2023.4-cmXT build
 20260403(27802f6d) Copyright (c) 2002-2026 www.mailtech.cn 163com
In-Reply-To: <agZGfRoVRPKW3LEU@google.com>
References: <20260512074918.2606208-1-richardycc@google.com>
 <20260513140218.7425-1-a929244872@163.com> <agZGfRoVRPKW3LEU@google.com>
X-NTES-SC: AL_Qu2cCvSYvEwp5CaZYOkcmU4UjuY4UMa2vvwg3YBXc/oEowXR/AcGdHlMF1rX3OyjDw+diBqvbBdgztt4fo5WmcynqugMuuDbPdXvje7Qiw==
Content-Type: multipart/alternative; 
	boundary="----=_Part_110532_1493370885.1778833422623"
MIME-Version: 1.0
Message-ID: <3e3db45e.7227.19e2abbf91f.Coremail.a929244872@163.com>
X-Coremail-Locale: zh_CN
X-CM-TRANSID:cigvCgDnL1AO2AZqYkakAA--.10690W
X-CM-SenderInfo: jdzsmjiuuylji6rwjhhfrp/xtbC6Q5V+2oG2A59awAA3l
X-Coremail-Antispam: 1U5529EdanIXcx71UUUUU7vcSsGvfC2KfnxnUU==
X-Rspam-User: 
X-Rspamd-Queue-Id: C2A5A40005
X-Rspamd-Server: rspam06
X-Stat-Signature: af8ms9gomri5a1sppdx8y97bxbyrrn84
X-HE-Tag: 1778833460-785323
X-HE-Meta: U2FsdGVkX18+YCyzH9tcJoBpZiDA+rdH1CY1Ju/6PTEy4YBN5akAaEA6hBbnyNSArqlIkWTEEX9TkOC9ZcgoaV//Vs127rHwRLS3iGS8xaV9mt4Y1FMkIkaSuLS6PJ661AysxHKSfcNIBHBxpXwJXFV6eoSu6HRdEr7Zh8EZvLYJWnL9J5k9TtDNqNi9dFAlgxAqn/4Utf2ohS5rq7YsM4t4SgUX2pK947H2k3UAuZG82TDdvWxpTcD34r/TJifwzuK9YEOIyb3DI98+F4QirN3yRDM+KrAt2b4rto6JCy28xk1IhmROzS17ybO3X/SmNujKOe6XEQEt4aAhVPFbOvR3D99anMgPED9o4owITFC+1QNqq0qrXMl1FujPtL3KcaUtPnmPquiJwi+T2WoeH0TFqLsizZzHWND6A8Hw0ND9/vwle2Rsq28TkUPPTsqxyUziRKlda2pp45Tf7x+JHOHKh+APV44O8MDIP1kXgeeQ36sk1c+TO2ymLiYFAavsyoqdDaXTkaGQdAaGYaGe3pKYUbInLbyv2ZQ+sxfbVfr5hwirG1ToqcAuau1pNyxgj9asiivj8wOBgdIustKh0a16MR4J8Vi7C1axqD2EhlASGUyK9i0k68+05L7zGmH0UVRMQhEPe9p0sb9Cgu4Tu0YlvuoTEDkr4eryF2lhMlaTPVIlc2yhxrqPwARWYfqTdaGhrtMPEcWuZEHWaCRzvgtZJZ+H2lGtq9wlz6wS7r78AMhD93hDQ8F5BJFmXfSbL6HnLNRjcqMFQyrauD9QPTfT5cfwV9OZHJ39JTfuP0Z1pMjIbPqO3TODpjuxv/n5i6mCYnc+prxeO7NtXNl9rlSszGpZp2UPTLCH94pimC4alI9atFimMV+uVrj/SCZtHajFVHiBePqnpqS6TJOSvpT/JQ8mdSeso5Ajku/oOaPASV2r4fpcTGqkzG0noSCR0+6V11yCcBsV9eghYVv
 4/6+FB+R
 mj04UofInh8DnzIaZr6eFcIEhKUKCablqWW/ox+Ym3Ik7s6HGW1+ZFfe032fyYIYL4pbnJiRPQeBQH74Tsl1ZAg2AIfjpj+U+0j9iT8jVSHjDu5Sck4AdDryx9fPW+ztB1yA+vYnztiBgoHde3+LHBMUSTIJ+aVLkZSC7y5i60SZOFGTf9h1v0FVrBQfACSgI1spBvnvmZDYmIXEooghEwXzk1yRQ2dqv4VLS5ab4CnPSPmFfYKjg/taUNkKXb4HTIEhBosJ5Q92Mv1QCUyjv8b5nR3WSMjNDceS/Jicqx0unVgD+LGOLs8qGJJKeSz0Gn2hn8FCtNkJBFJDuZCWHIcYhDjSL8GCka6H7JKGlEUgWT6+4UM83Pd0QsQt9qHdUZebcMPhsvCjz01nTxdj2QTTNnpZsaos+TisEL8CoK1g/YlbR/Kaa27eEZCLscG1rIuRgLC2uSOgZfo5mXRznV4I6d1j2im6JzejKzb2v4gzrAbp0BnHpKjW/DZralZWl81qDZB2dikdw/RQ+z7O/CSNxPQqRqu6z2ItB16WRX/gQUVFnq2sjBBMejjlTj/ElAJiUQ6rZYIDvVTLHATs9rksdhDhZB1T6VvNjBkGYBxK9DctnpZVjFAUBiI7knAtwbY934k3NF83tc47Vca742/i2NA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

------=_Part_110532_1493370885.1778833422623
Content-Type: text/plain; charset=GBK
Content-Transfer-Encoding: base64

QXQgMjAyNi0wNS0xNSAwNjowMjozNywgIk1pbmNoYW4gS2ltIiA8bWluY2hhbkBrZXJuZWwub3Jn
PiB3cm90ZToKPk9uIFdlZCwgTWF5IDEzLCAyMDI2IGF0IDEwOjAyOjE4UE0gKzA4MDAsIHdhbmcg
d2VpIHdyb3RlOgo+PiA+QEAgLTg0Nyw3ICs4NDksNyBAQCBzdGF0aWMgdm9pZCByZWxlYXNlX3di
X2N0bChzdHJ1Y3QgenJhbV93Yl9jdGwgKndiX2N0bCkKPj4gPiAJCXJlbGVhc2Vfd2JfcmVxKHJl
cSk7Cj4+ID4gCX0KPj4gPgo+PiA+LQlrZnJlZSh3Yl9jdGwpOwo+PiA+KwlrZnJlZV9yY3Uod2Jf
Y3RsLCByY3UpOwo+PiA+IH0KPj4gCj4+IERvIHdlIG5lZWQgdG8gYWRkIGEgJ3JjdV9hc3NpZ25f
cG9pbnRlcih3Yl9jdGwsIE5VTEwpOycgYmVmb3JlICdrZnJlZV9yY3Uod2JfY3RsLCByY3UpJz8K
Pj4gCj4+IFNpZ25lZC1vZmYtYnk6IHdhbmcgd2VpIDxhOTI5MjQ0ODcyQDE2My5jb20+Cj4KPldo
eSBkbyB3ZSBuZWVkIGl0Pwo+Cj5NeSB1bmRlcnN0YW5kaW5nIGlzIHJjdV9hc3NpZ25fcG9pbnRl
cigpIGlzIHR5cGljYWxseSB1c2VkIHRvIHB1Ymxpc2ggTlVMTCB0bwo+YSBzaGFyZWQgcG9pbnRl
ciB2YXJpYWJsZSBzbyB0aGF0IGZ1dHVyZSBSQ1UgcmVhZGVycyAodXNpbmcgcmN1X2RlcmVmZXJl
bmNlKQo+d29uJ3QgYWNjZXNzIHRoZSBvYmplY3QgYmVmb3JlIGtmcmVlX3JjdSgpLgoKVGhhdCdz
IGV4YWN0bHkgd2hhdCBJJ20gd29ycmllZCBpcyB0aGF0IHNvbWUgcHJvY2VzcyBtaWdodCBhY2Nl
c3Mgd2JfY3RsIGJlZm9yZSBrZnJlZV9yY3QoKS4KCgo+SG93ZXZlciwgaW4gb3VyIGNhc2UsIHdi
X2N0bCBpcyBub3Qgc3RvcmVkIGluIGFueSBzaGFyZWQgcG9pbnRlciB2YXJpYWJsZS4KPkl0IGlz
IGEgbG9jYWwgdmFyaWFibGUgaW4gd3JpdGViYWNrX3N0b3JlKCkgYW5kIFJDVSByZWFkZXJzICh6
cmFtX3dyaXRlYmFja19lbmRpbykKPmRvIG5vdCBsb29rIHVwIHdiX2N0bCBmcm9tIGEgc2hhcmVk
IHBvaW50ZXIuIFRoZXkgb2J0YWluIGl0IGRpcmVjdGx5IGZyb20KPmJpby0+YmlfcHJpdmF0ZSBv
ZiB0aGUgc3BlY2lmaWMgYmlvIHRoZXkgYXJlIGNvbXBsZXRpbmcuCgpUaGFuayB5b3UgZm9yIHRo
ZSBsZXNzb25lczsgSSByZWFsaXplIG15IHdvcnJpZXMgd2VyZSB1bm5lY2Vzc2FyeS4KCgo+UGxl
YXNlIGxldCBtZSBrbm93IGlmIEkgbWlzc2VkIGFueXRoaW5nLgo=
------=_Part_110532_1493370885.1778833422623
Content-Type: text/html; charset=GBK
Content-Transfer-Encoding: base64

PGRpdiBkYXRhLW50ZXM9Im50ZXNfbWFpbF9ib2R5X3Jvb3QiIHN0eWxlPSJsaW5lLWhlaWdodDox
Ljc7Y29sb3I6IzAwMDAwMDtmb250LXNpemU6MTRweDtmb250LWZhbWlseTpBcmlhbCI+PGRpdiBz
dHlsZT0ibWFyZ2luOiAwOyI+QXQgMjAyNi0wNS0xNSAwNjowMjozNywgIk1pbmNoYW4gS2ltIiAm
bHQ7bWluY2hhbkBrZXJuZWwub3JnJmd0OyB3cm90ZTo8L2Rpdj48cHJlPiZndDtPbiBXZWQsIE1h
eSAxMywgMjAyNiBhdCAxMDowMjoxOFBNICswODAwLCB3YW5nIHdlaSB3cm90ZToKJmd0OyZndDsg
Jmd0O0BAIC04NDcsNyArODQ5LDcgQEAgc3RhdGljIHZvaWQgcmVsZWFzZV93Yl9jdGwoc3RydWN0
IHpyYW1fd2JfY3RsICp3Yl9jdGwpCiZndDsmZ3Q7ICZndDsgCQlyZWxlYXNlX3diX3JlcShyZXEp
OwomZ3Q7Jmd0OyAmZ3Q7IAl9CiZndDsmZ3Q7ICZndDsKJmd0OyZndDsgJmd0Oy0Ja2ZyZWUod2Jf
Y3RsKTsKJmd0OyZndDsgJmd0OysJa2ZyZWVfcmN1KHdiX2N0bCwgcmN1KTsKJmd0OyZndDsgJmd0
OyB9CiZndDsmZ3Q7IAomZ3Q7Jmd0OyBEbyB3ZSBuZWVkIHRvIGFkZCBhICdyY3VfYXNzaWduX3Bv
aW50ZXIod2JfY3RsLCBOVUxMKTsnIGJlZm9yZSAna2ZyZWVfcmN1KHdiX2N0bCwgcmN1KSc/CiZn
dDsmZ3Q7IAomZ3Q7Jmd0OyBTaWduZWQtb2ZmLWJ5OiB3YW5nIHdlaSAmbHQ7YTkyOTI0NDg3MkAx
NjMuY29tJmd0OwomZ3Q7CiZndDtXaHkgZG8gd2UgbmVlZCBpdD8KJmd0OwomZ3Q7TXkgdW5kZXJz
dGFuZGluZyBpcyByY3VfYXNzaWduX3BvaW50ZXIoKSBpcyB0eXBpY2FsbHkgdXNlZCB0byBwdWJs
aXNoIE5VTEwgdG8KJmd0O2Egc2hhcmVkIHBvaW50ZXIgdmFyaWFibGUgc28gdGhhdCBmdXR1cmUg
UkNVIHJlYWRlcnMgKHVzaW5nIHJjdV9kZXJlZmVyZW5jZSkKJmd0O3dvbid0IGFjY2VzcyB0aGUg
b2JqZWN0IGJlZm9yZSBrZnJlZV9yY3UoKS4KPGRpdj4KPC9kaXY+PGRpdj5UaGF0J3MgZXhhY3Rs
eSB3aGF0IEknbSB3b3JyaWVkIGlzIHRoYXQgc29tZSBwcm9jZXNzIG1pZ2h0IGFjY2VzcyB3Yl9j
dGwgYmVmb3JlIGtmcmVlX3JjdCgpLjwvZGl2PjxkaXY+PGJyPjwvZGl2PiZndDtIb3dldmVyLCBp
biBvdXIgY2FzZSwgd2JfY3RsIGlzIG5vdCBzdG9yZWQgaW4gYW55IHNoYXJlZCBwb2ludGVyIHZh
cmlhYmxlLgomZ3Q7SXQgaXMgYSBsb2NhbCB2YXJpYWJsZSBpbiB3cml0ZWJhY2tfc3RvcmUoKSBh
bmQgUkNVIHJlYWRlcnMgKHpyYW1fd3JpdGViYWNrX2VuZGlvKQomZ3Q7ZG8gbm90IGxvb2sgdXAg
d2JfY3RsIGZyb20gYSBzaGFyZWQgcG9pbnRlci4gVGhleSBvYnRhaW4gaXQgZGlyZWN0bHkgZnJv
bQomZ3Q7YmlvLSZndDtiaV9wcml2YXRlIG9mIHRoZSBzcGVjaWZpYyBiaW8gdGhleSBhcmUgY29t
cGxldGluZy4KPGRpdj4KPC9kaXY+PGRpdj5UaGFuayB5b3UgZm9yIHRoZSBsZXNzb25lczsgSSBy
ZWFsaXplIG15IHdvcnJpZXMgd2VyZSB1bm5lY2Vzc2FyeS48L2Rpdj48ZGl2Pjxicj48L2Rpdj4m
Z3Q7UGxlYXNlIGxldCBtZSBrbm93IGlmIEkgbWlzc2VkIGFueXRoaW5nLgo8L3ByZT48L2Rpdj4=

------=_Part_110532_1493370885.1778833422623--



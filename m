Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2FBCFD3B7E5
	for <linux-mm@archiver.kernel.org>; Mon, 29 Dec 2025 13:52:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0B52E6B0088; Mon, 29 Dec 2025 08:52:36 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 039506B0089; Mon, 29 Dec 2025 08:52:35 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E87206B008A; Mon, 29 Dec 2025 08:52:35 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id D1B6B6B0088
	for <linux-mm@kvack.org>; Mon, 29 Dec 2025 08:52:35 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 96E7313C9AA
	for <linux-mm@kvack.org>; Mon, 29 Dec 2025 13:52:35 +0000 (UTC)
X-FDA: 84272648670.01.0B13C27
Received: from out162-62-57-49.mail.qq.com (out162-62-57-49.mail.qq.com [162.62.57.49])
	by imf06.hostedemail.com (Postfix) with ESMTP id 1D01F180005
	for <linux-mm@kvack.org>; Mon, 29 Dec 2025 13:52:32 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=qq.com header.s=s201512 header.b=EhU8n3C9;
	dmarc=pass (policy=quarantine) header.from=qq.com;
	spf=pass (imf06.hostedemail.com: domain of shengminghu512@qq.com designates 162.62.57.49 as permitted sender) smtp.mailfrom=shengminghu512@qq.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767016353; a=rsa-sha256;
	cv=none;
	b=WzNtQRUq6xRcDOb+vQJ9iCKgQvouAhFzzRwMe1G4AmHRUJtVMAXiB5/aPdKL/SNAhNwvtu
	OqHl4kTkK+oKmY8t2P8eyJiUe6mkXUqtJ/ZpjGjAREMJ9hfFLx6vq6QOB+5NQaf+QligQS
	I8rHx3z8UinaO385NKlV9yCIXH2Urkc=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=qq.com header.s=s201512 header.b=EhU8n3C9;
	dmarc=pass (policy=quarantine) header.from=qq.com;
	spf=pass (imf06.hostedemail.com: domain of shengminghu512@qq.com designates 162.62.57.49 as permitted sender) smtp.mailfrom=shengminghu512@qq.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767016353;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=nWViOYG5nQtBSh3p8ODsoW76RNAZ8UQcf6TMM443Gu0=;
	b=1zrWqwb6F7sbx12XZxN77Nuu1LRYDz3j7uA7zULayVAWLBqENUvcuJ3CFCtMlUPg7hRiGk
	jEoAmnzXF7Wp6zn6W4U0GzZTgwN44j84ADIbY3GPK9ucBQsyvkbK4TkDBXFU1Q7gTJKaoL
	w07ufR1+RkOuB4e897gRW5zZO+ZCjM4=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qq.com; s=s201512;
	t=1767016348; bh=nWViOYG5nQtBSh3p8ODsoW76RNAZ8UQcf6TMM443Gu0=;
	h=From:To:Cc:Subject:Date;
	b=EhU8n3C9vZl4lN04sG0aNpSVXTCuuSzKLF0OjpiuTG4r2A6sJdGYw48kauk8oWAqj
	 SpftIRXsu7jA3WTgnzp9YkDlE+ONqbPKX9SIp7odOp0tDMp8JGy6NWTYDQMDD2Gtur
	 +yhnBHAY0gDA0a1h+Ov03Y/uD905wd+O0zXtFKS0=
X-QQ-XMRINFO: M/715EihBoGS47X28/vv4NpnfpeBLnr4Qg==
X-QQ-XMAILINFO: MnT+Yx1vzy5SFmSrmdJxtWxI82SioVl9zGF6EDaZdkuwtTFrHkdcUeDwcvBw8e
	 0m03cYyyoHJ9WDJwDeves081lc4jvyQjKB0ZDMnc9hYIC6/LaL6DSkQ7SREXsHY6MJWygm6sIaWm9
	 3v7VAUkOunqJkP+h0RvqU8BOxocWEU4GKSUX7RUY8+KBaEmT8THkIsfcHdOxM6iCa+47yDOZ5C8e5
	 Dc+4mJN+0Sz1AXNISg/Dj+It75XQWVGLKCXngxj9XL+5LklXByfTnlyVTdj0B0iqBrC1BJl0Qw/Al
	 Bxx6Hg6oQCFmUnK3Ygp0U0uj4NISDZOcweKegxbc0abPohTkK5EYw7V3E+4Ut6knQe7LwMMmuWv8f
	 P4qa2pm3FGoFYaazZohU49RjhwUKy0YslMdkXnm//ue1ZHqdnZ8XN47RI3OqTx1qG80Edb+krRV0Z
	 L+nfwommQ/0I7iIbyRLi9l5Dh0d5bc0uVJaiRbGsOA6EzS0sYfJCe3qdKaYJbM/nnNbOySkk1hwi6
	 uPEGOaBGfXmSUmXha9vq4PsysKB1tQWgYokHJ+KjbHJUUd6GLLsbql7H/9CDjDctEEpFtbkEG3tqG
	 /mLzULKyyJ0Cp0JHHLh572VTAO2feAgKFjopyVgCOoeJr1fA3P0rnsKhHeJYxnd4phezGBW9RtST3
	 JW1CNpMFNAc+oETENHzLqaabMHIpSFs7mssasIvy4Sm/8XrmMacjlPW23D0O2NJboNs6rJKb1efdZ
	 hhTEQnzSg+aaMzNWqIcI5v3v5cKGAIWkMOpmKqDTirnBgqId025Oc9JsPPp7Z2uEJlQm+fvOCuaO1
	 YG7eq9q4eRo5aJP28LnIhHBfZxcSrLEdcmXL57xbQIHYZX0aIkyDBYYSlZ4yiuIGgAe4rbt679uhX
	 6KEuLt6S0MDweb1bJ0/u7v5dFZSZoIZua8TuqsF+4u7Z5Tx8L+gcOwWwYQHA6aG5+vh0qNYsZGqSw
	 m8paVugFZYZHIKn5er8M9DoSsSFfaRiH51y51QRGEOIb91nQHk1yuz9tELu8BxMb4AMcchAGe8544
	 zMC9ncDx0WaQqfRVzglA39Z3nwmEQGttSbw12++9K4izU5lVEmL0FI85DXGZ4WkUI5K6sPtP5LkS+
	 hdfSJNZgUEJmAeBL/JMY5EmtiQnYyJcw9T5azRmk0o1Zlg==
From: "=?utf-8?B?c2hlbmdtaW5naHU1MTI=?=" <shengminghu512@qq.com>
To: "=?utf-8?B?YWtwbQ==?=" <akpm@linux-foundation.org>, "=?utf-8?B?ZGF2aWQ=?=" <david@kernel.org>, "=?utf-8?B?cnBwdA==?=" <rppt@kernel.org>
Cc: "=?utf-8?B?bG9yZW56by5zdG9ha2Vz?=" <lorenzo.stoakes@oracle.com>, "=?utf-8?B?TGlhbS5Ib3dsZXR0?=" <Liam.Howlett@oracle.com>, "=?utf-8?B?dmJhYmth?=" <vbabka@suse.cz>, "=?utf-8?B?c3VyZW5i?=" <surenb@google.com>, "=?utf-8?B?bWhvY2tv?=" <mhocko@suse.com>, "=?utf-8?B?bGludXgtbW0=?=" <linux-mm@kvack.org>, "=?utf-8?B?bGludXgta2VybmVs?=" <linux-kernel@vger.kernel.org>, "=?utf-8?B?aHUuc2hlbmdtaW5n?=" <hu.shengming@zte.com.cn>, "=?utf-8?B?emhhbmcucnVu?=" <zhang.run@zte.com.cn>
Subject: [PATCH v2] mm/memblock: drop redundant 'struct page *' argument from memblock_free_pages()
Mime-Version: 1.0
Content-Type: text/plain;
	charset="utf-8"
Content-Transfer-Encoding: base64
Date: Mon, 29 Dec 2025 21:52:27 +0800
X-Priority: 3
Message-ID: <tencent_F741CE6ECC49EE099736685E60C0DBD4A209@qq.com>
X-QQ-MIME: TCMime 1.0 by Tencent
X-Mailer: QQMail 2.x
X-QQ-Mailer: QQMail 2.x
X-QQ-mid: xmsepub7-0t1767016347tomwbdp83
X-Rspamd-Queue-Id: 1D01F180005
X-Stat-Signature: j7y4fiwe4awstgqa6o1em6zyec5qkura
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1767016352-292627
X-HE-Meta: U2FsdGVkX1878MkCTeWbY3ta1ZunoIymm15vcNDFi6InBpVWcBBCwgeYZnkRJD+mmgOGqtbrjh3Y4ylAxKMSQ2lAcV20e+8iXYdqo9WPD8DXwwStLPUT+31a/1Hq4YLiNbmoXpFUtJbO+QIiU6uOeTFEh+6pXTwzzw5ob4YIEIgm+PLg/d6ay0x+NQjOIyOFJYVvxQW1D8pUU2C6TZC2MirbPEc79SeqVAexZ2EbXqD8/YCX7c6zuadkoHg+tZEvmRKQda2l3OatJFbGyOTq23rzjCE6AkFkEOLBKim5xrjEBleb2g5yu4r5JtEQqT2PT0BLf5gdihF3Ea/yK/cnxeq5Z/hZr5b42aWN8eIqoyJgKA9bO1qSR4DBbyGQVtb23z+U/jcCmF2Y2vyGMmf0sw/Tj4OKzvznHyGzAsCrj9Wwh1ARYKDavWjiVXb/m3jtcR0t697UKPDUmCa748/K0H2Qc3kZtGGUEMCEn/dBZtWIwbSoyyooJV1EKPeYO1KV3c4gyfPOEIP97p8R7NfrrFWBVA8SYnn6qq6s7wqhii1B6tA2/J9nVRAOxRbm13DDyRhOSrWpYZUcPlBLed/gvMp3iF6JYOEteRudWU7FB/WmH1TyoPtAihFW/Yu13HzigRGKRcU+KrYW/bCCPxKfHNCwM+k4OJR1UDHRL2XD7G9Pcbl9WOmSR4LR+V5+GUosS1l345MJFH664FSwbVuRgZDo5S8cK7dFZyJ80SmAxizS20ZY8/qeTBaXUgt1dhZkLGylJyir0EzyMkkce3Ps+M4ts+2EsGHNZnZLZ92QpOTMrfrfuAp7Q4iHYlG+ngL0G5ggKGrCk7J4NIW+nZkZiFb6oIiUQqibqqHhA60ncMp6VTh2XKQSo4ykTAdXmQ8o0TqZkl1inPkIENGKPOi6o0ayPoQS+XQY20Wf/BXd9X9Mj4bBR87dBR0r5zG3ByUzDTb3quX8GTJmoAgXLnT
 9aBPeqr0
 d/MbgR7eKyzkGWaoF6r+PBCcGMdXqOLC6MI8Ir01d1RFeDuDml2EUyoV+rZXdzTTrGn41pgnq319TjC3h5CgJverGFW7k0noOxByrkCBO/xoE69FQECE1IauUuJM3oo+695uU+lqga9U2tppqpkFOlm0VeuQBRtN2AQR78hxBpNZRBQGzJfK30xsgcw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

RnJvbTogU2hlbmdtaW5nIEh1IDxodS5zaGVuZ21pbmdAenRlLmNvbS5jbj4NCg0KbWVtYmxv
Y2tfZnJlZV9wYWdlcygpIGN1cnJlbnRseSB0YWtlcyBib3RoIGEgc3RydWN0IHBhZ2UgKiBh
bmQgdGhlDQpjb3JyZXNwb25kaW5nIFBGTi4gVGhlIHBhZ2UgcG9pbnRlciBpcyBhbHdheXMg
ZGVyaXZlZCBmcm9tIHRoZSBQRk4gYXQNCmNhbGwgc2l0ZXMgKHBmbl90b19wYWdlKHBmbikp
LCBtYWtpbmcgdGhlIHBhcmFtZXRlciByZWR1bmRhbnQgYW5kIGFsc28NCmFsbG93aW5nIGFj
Y2lkZW50YWwgbWlzbWF0Y2hlcyBiZXR3ZWVuIHRoZSB0d28gYXJndW1lbnRzLg0KDQpTaW1w
bGlmeSB0aGUgaW50ZXJmYWNlIGJ5IHJlbW92aW5nIHRoZSBzdHJ1Y3QgcGFnZSAqIGFyZ3Vt
ZW50IGFuZA0KZGVyaXZpbmcgdGhlIHBhZ2UgbG9jYWxseSBmcm9tIHRoZSBQRk4sIGFmdGVy
IHRoZSBkZWZlcnJlZCBzdHJ1Y3QgcGFnZQ0KaW5pdGlhbGl6YXRpb24gY2hlY2suIFRoaXMg
a2VlcHMgdGhlIGJlaGF2aW9yIHVuY2hhbmdlZCB3aGlsZSBtYWtpbmcNCnRoZSBoZWxwZXIg
aGFyZGVyIHRvIG1pc3VzZS4NCg0KU2lnbmVkLW9mZi1ieTogU2hlbmdtaW5nIEh1IDxodS5z
aGVuZ21pbmdAenRlLmNvbS5jbj4NCi0tLQ0KQ2hhbmdlcyBmcm9tIHYxOg0KaHR0cHM6Ly9s
b3JlLmtlcm5lbC5vcmcvYWxsL3RlbmNlbnRfNjAwRDFCQ0M1RTFCNURCNERERDk4Njc5REE3
REMzMTIzQzA2QHFxLmNvbS8NCi0gSW5pdGlhbGl6ZSB0aGUgcGFnZSB2YXJpYWJsZSBhdCBk
ZWNsYXJhdGlvbg0KDQogbW0vaW50ZXJuYWwuaCAgICAgICAgICAgICAgICAgICAgIHwgMyAr
LS0NCiBtbS9tZW1ibG9jay5jICAgICAgICAgICAgICAgICAgICAgfCA0ICsrLS0NCiBtbS9t
bV9pbml0LmMgICAgICAgICAgICAgICAgICAgICAgfCA1ICsrKy0tDQogdG9vbHMvdGVzdGlu
Zy9tZW1ibG9jay9pbnRlcm5hbC5oIHwgMyArLS0NCiA0IGZpbGVzIGNoYW5nZWQsIDcgaW5z
ZXJ0aW9ucygrKSwgOCBkZWxldGlvbnMoLSkNCg0KZGlmZiAtLWdpdCBhL21tL2ludGVybmFs
LmggYi9tbS9pbnRlcm5hbC5oDQppbmRleCBlNDMwZGE5MDAuLjVmOTNlZTE0NSAxMDA2NDQN
Ci0tLSBhL21tL2ludGVybmFsLmgNCisrKyBiL21tL2ludGVybmFsLmgNCkBAIC03NDIsOCAr
NzQyLDcgQEAgc3RhdGljIGlubGluZSB2b2lkIGNsZWFyX3pvbmVfY29udGlndW91cyhzdHJ1
Y3Qgem9uZSAqem9uZSkNCiBleHRlcm4gaW50IF9faXNvbGF0ZV9mcmVlX3BhZ2Uoc3RydWN0
IHBhZ2UgKnBhZ2UsIHVuc2lnbmVkIGludCBvcmRlcik7DQogZXh0ZXJuIHZvaWQgX19wdXRi
YWNrX2lzb2xhdGVkX3BhZ2Uoc3RydWN0IHBhZ2UgKnBhZ2UsIHVuc2lnbmVkIGludCBvcmRl
ciwNCiAJCQkJICAgIGludCBtdCk7DQotZXh0ZXJuIHZvaWQgbWVtYmxvY2tfZnJlZV9wYWdl
cyhzdHJ1Y3QgcGFnZSAqcGFnZSwgdW5zaWduZWQgbG9uZyBwZm4sDQotCQkJCQl1bnNpZ25l
ZCBpbnQgb3JkZXIpOw0KK2V4dGVybiB2b2lkIG1lbWJsb2NrX2ZyZWVfcGFnZXModW5zaWdu
ZWQgbG9uZyBwZm4sIHVuc2lnbmVkIGludCBvcmRlcik7DQogZXh0ZXJuIHZvaWQgX19mcmVl
X3BhZ2VzX2NvcmUoc3RydWN0IHBhZ2UgKnBhZ2UsIHVuc2lnbmVkIGludCBvcmRlciwNCiAJ
CWVudW0gbWVtaW5pdF9jb250ZXh0IGNvbnRleHQpOw0KIA0KZGlmZiAtLWdpdCBhL21tL21l
bWJsb2NrLmMgYi9tbS9tZW1ibG9jay5jDQppbmRleCA5MDVkMDZiMTYuLjZlMTFmODFjNCAx
MDA2NDQNCi0tLSBhL21tL21lbWJsb2NrLmMNCisrKyBiL21tL21lbWJsb2NrLmMNCkBAIC0x
NzcxLDcgKzE3NzEsNyBAQCB2b2lkIF9faW5pdCBtZW1ibG9ja19mcmVlX2xhdGUocGh5c19h
ZGRyX3QgYmFzZSwgcGh5c19hZGRyX3Qgc2l6ZSkNCiAJZW5kID0gUEZOX0RPV04oYmFzZSAr
IHNpemUpOw0KIA0KIAlmb3IgKDsgY3Vyc29yIDwgZW5kOyBjdXJzb3IrKykgew0KLQkJbWVt
YmxvY2tfZnJlZV9wYWdlcyhwZm5fdG9fcGFnZShjdXJzb3IpLCBjdXJzb3IsIDApOw0KKwkJ
bWVtYmxvY2tfZnJlZV9wYWdlcyhjdXJzb3IsIDApOw0KIAkJdG90YWxyYW1fcGFnZXNfaW5j
KCk7DQogCX0NCiB9DQpAQCAtMjIxNiw3ICsyMjE2LDcgQEAgc3RhdGljIHZvaWQgX19pbml0
IF9fZnJlZV9wYWdlc19tZW1vcnkodW5zaWduZWQgbG9uZyBzdGFydCwgdW5zaWduZWQgbG9u
ZyBlbmQpDQogCQl3aGlsZSAoc3RhcnQgKyAoMVVMIDw8IG9yZGVyKSA+IGVuZCkNCiAJCQlv
cmRlci0tOw0KIA0KLQkJbWVtYmxvY2tfZnJlZV9wYWdlcyhwZm5fdG9fcGFnZShzdGFydCks
IHN0YXJ0LCBvcmRlcik7DQorCQltZW1ibG9ja19mcmVlX3BhZ2VzKHN0YXJ0LCBvcmRlcik7
DQogDQogCQlzdGFydCArPSAoMVVMIDw8IG9yZGVyKTsNCiAJfQ0KZGlmZiAtLWdpdCBhL21t
L21tX2luaXQuYyBiL21tL21tX2luaXQuYw0KaW5kZXggZmMyYTZmMWU1Li5kNWI5MTYwMmYg
MTAwNjQ0DQotLS0gYS9tbS9tbV9pbml0LmMNCisrKyBiL21tL21tX2luaXQuYw0KQEAgLTI0
ODAsOSArMjQ4MCwxMCBAQCB2b2lkICpfX2luaXQgYWxsb2NfbGFyZ2Vfc3lzdGVtX2hhc2go
Y29uc3QgY2hhciAqdGFibGVuYW1lLA0KIAlyZXR1cm4gdGFibGU7DQogfQ0KIA0KLXZvaWQg
X19pbml0IG1lbWJsb2NrX2ZyZWVfcGFnZXMoc3RydWN0IHBhZ2UgKnBhZ2UsIHVuc2lnbmVk
IGxvbmcgcGZuLA0KLQkJCQkJCQl1bnNpZ25lZCBpbnQgb3JkZXIpDQordm9pZCBfX2luaXQg
bWVtYmxvY2tfZnJlZV9wYWdlcyh1bnNpZ25lZCBsb25nIHBmbiwgdW5zaWduZWQgaW50IG9y
ZGVyKQ0KIHsNCisJc3RydWN0IHBhZ2UgKnBhZ2UgPSBwZm5fdG9fcGFnZShwZm4pOw0KKw0K
IAlpZiAoSVNfRU5BQkxFRChDT05GSUdfREVGRVJSRURfU1RSVUNUX1BBR0VfSU5JVCkpIHsN
CiAJCWludCBuaWQgPSBlYXJseV9wZm5fdG9fbmlkKHBmbik7DQogDQpkaWZmIC0tZ2l0IGEv
dG9vbHMvdGVzdGluZy9tZW1ibG9jay9pbnRlcm5hbC5oIGIvdG9vbHMvdGVzdGluZy9tZW1i
bG9jay9pbnRlcm5hbC5oDQppbmRleCAwYWI0YjUzYmIuLjAwOWI5N2JiZCAxMDA2NDQNCi0t
LSBhL3Rvb2xzL3Rlc3RpbmcvbWVtYmxvY2svaW50ZXJuYWwuaA0KKysrIGIvdG9vbHMvdGVz
dGluZy9tZW1ibG9jay9pbnRlcm5hbC5oDQpAQCAtMTUsOCArMTUsNyBAQCBib29sIG1pcnJv
cmVkX2tlcm5lbGNvcmUgPSBmYWxzZTsNCiANCiBzdHJ1Y3QgcGFnZSB7fTsNCiANCi12b2lk
IG1lbWJsb2NrX2ZyZWVfcGFnZXMoc3RydWN0IHBhZ2UgKnBhZ2UsIHVuc2lnbmVkIGxvbmcg
cGZuLA0KLQkJCSB1bnNpZ25lZCBpbnQgb3JkZXIpDQordm9pZCBtZW1ibG9ja19mcmVlX3Bh
Z2VzKHVuc2lnbmVkIGxvbmcgcGZuLCB1bnNpZ25lZCBpbnQgb3JkZXIpDQogew0KIH0NCiAN
Ci0tIA0KMi4yNS4xDQo=



Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DF586D3B7E5
	for <linux-mm@archiver.kernel.org>; Sun, 28 Dec 2025 11:39:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C49F96B0005; Sun, 28 Dec 2025 06:39:04 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BF76D6B0089; Sun, 28 Dec 2025 06:39:04 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AF6996B008A; Sun, 28 Dec 2025 06:39:04 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 9CA9A6B0005
	for <linux-mm@kvack.org>; Sun, 28 Dec 2025 06:39:04 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 80512117D5E
	for <linux-mm@kvack.org>; Sun, 28 Dec 2025 11:38:59 +0000 (UTC)
X-FDA: 84268683198.26.3B777B3
Received: from out162-62-57-137.mail.qq.com (out162-62-57-137.mail.qq.com [162.62.57.137])
	by imf03.hostedemail.com (Postfix) with ESMTP id 006AD20005
	for <linux-mm@kvack.org>; Sun, 28 Dec 2025 11:38:56 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=qq.com header.s=s201512 header.b=YS6sbKSr;
	dmarc=pass (policy=quarantine) header.from=qq.com;
	spf=pass (imf03.hostedemail.com: domain of shengminghu512@qq.com designates 162.62.57.137 as permitted sender) smtp.mailfrom=shengminghu512@qq.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766921937; a=rsa-sha256;
	cv=none;
	b=Kbjftw68yCXcbtNnU6y4Vp6EzaczsZ5kGx0WXw5GQ2UQBrSiIxwRuisaTtZdCjXlXTZ0FC
	svlXGMHXMYBQQ88tL2r9yX/vlOSDPWv3Z+UJzDif/cVExxjI8qffo8U74OT9V8LihHdKom
	ELjwnM53v5V+tXT6sRFNX0ue+lkgemM=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=qq.com header.s=s201512 header.b=YS6sbKSr;
	dmarc=pass (policy=quarantine) header.from=qq.com;
	spf=pass (imf03.hostedemail.com: domain of shengminghu512@qq.com designates 162.62.57.137 as permitted sender) smtp.mailfrom=shengminghu512@qq.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766921937;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=JBiEhZG23nF7rzr99o5QrN66XJYyhdsq5looOF7JCQc=;
	b=npXeXJbmbPCo5UPZkLWQjjmUpic6wsoYYcT/+DmMe+UCNI7AOvpvcQqUICMBkf6pkyfNZK
	Mny+s+p3UEk5nOhsbwCXEBxZTcjIevWMFcaNGxzy+NxXqnpKLVAHqK7S0LgavoG0hV+8Pl
	OJfWalOrSgUqWPrrS/E1BlJRnmnl+B4=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qq.com; s=s201512;
	t=1766921931; bh=JBiEhZG23nF7rzr99o5QrN66XJYyhdsq5looOF7JCQc=;
	h=From:To:Cc:Subject:Date;
	b=YS6sbKSrGQfcf03dLzLa71lxGCncjkCyx1tT8d+rYsAvGMcoQVx0fZS6iGG9VkO9n
	 VHC8cC9Yl9zFjOXs9EgYzbwLVU6mzo4rdC4o7KECSMbO/NTskJFKaJi7PyocIXsJC1
	 TbHjMpwJI9JNryDxCj19DRKGonN5HHVeLyFjdWpg=
X-QQ-XMRINFO: MSVp+SPm3vtSI1QTLgDHQqIV1w2oNKDqfg==
X-QQ-XMAILINFO: NWDimQkHKFPbycjKJXGP9kqLJa0gSkvOigl5hTQJ9KEjwJ9VxRTYFbrIr2n11m
	 0khQ+ahtYdkcu7eKobY0VAqFo5A68PD/ugaDZBLXI6N70I5S+QELSdz7VTaxuuCTmRBhV/bvWHOsE
	 2Zavv35NNsUiQaPeqq8qavLkp4vVzbJ2LH96DCozqGSCj6vU01Qgln6OPNdDTkh/xFoUOYyiP39vr
	 xZnmQiyDPM/6mkd6h/aicd8e0PRQDitm4nIrZB+2DYKJJ+exnw3jRgKabbgGsRrLXVqrr+xaBV824
	 wks3FIFD1CSsfrkCmp8Zhx/wPL0IOMMafDkVg26XHBCiASmjD8wfUmsfam3dWrfIe40zx3ix5hnO+
	 ke5vAK/vbwXI2B56JjOY3pIlo8Qw8cdwM6iTQVArJ/ErJX33rU1hDhQ2HVyFFNNXSCYG067Empq5H
	 lZ2OqN4xwbS1k0ul2+pHblCalxDGwu3tjLfQQsTtfr7Jm4zslny0nRWl6B5I1Sga3j+3G6b9ZjhYy
	 6bUgE5oEFcB47u01bsjHrpBG+zQhOnD8uwde69JzKCawvrmRORBSDEPeymmG64AFrpwNqgerE24Pc
	 hg4+tPAvGlG4gJsOwW8ZAWBDldVDjtGLln1fouDCzJFWIGLnRiUc3bHVHQ/84lAugo9Nc/edOjlqT
	 huIFOryPqa6173uKSFK+kzj4F4vtaz2uCgiAkUz7J4h4Y+fuHupe3jtSHOKxsgkjGDcmL2Za9yvln
	 rUvj1plMCTkt3yaKWnUe5it4/YwCWZO33PG46v/Oalg0ck4oSfcE+yPD/qapsGIQMhax5uB4U+Ijs
	 I7wKdt8vA4UnQYuypMxQsUNR0t308sb2tkEfL2HZUtIxzz2Gq2tI2/wvAIvCw7DCqt1yT3FmbjYG5
	 hbgpXMnlb02zGOmBJb/w1QbGNr5Nhh5MlPag+NP9AIJ7JUbT1FqJ3pM41m1TsJDaSupPZwH7RzndZ
	 NEpLVVHyShghFueBocKNO0+c5xqL3J3SHKkKB7T4imq5ez72b/XvA1+oWK4mhaP6uFMorV76KUuQ4
	 VBuIP0KEKbAQGoX3JLhyr9HwXFh3pgD+vodmNyIiBoX50mVPj1kU7SMChHqBIkf+h8AcfbD2PeH2l
	 2Ri1RHNaP+ruMA==
From: "=?utf-8?B?c2hlbmdtaW5naHU1MTI=?=" <shengminghu512@qq.com>
To: "=?utf-8?B?YWtwbQ==?=" <akpm@linux-foundation.org>, "=?utf-8?B?ZGF2aWQ=?=" <david@kernel.org>
Cc: "=?utf-8?B?bG9yZW56by5zdG9ha2Vz?=" <lorenzo.stoakes@oracle.com>, "=?utf-8?B?TGlhbS5Ib3dsZXR0?=" <Liam.Howlett@oracle.com>, "=?utf-8?B?dmJhYmth?=" <vbabka@suse.cz>, "=?utf-8?B?cnBwdA==?=" <rppt@kernel.org>, "=?utf-8?B?c3VyZW5i?=" <surenb@google.com>, "=?utf-8?B?bWhvY2tv?=" <mhocko@suse.com>, "=?utf-8?B?bGludXgtbW0=?=" <linux-mm@kvack.org>, "=?utf-8?B?bGludXgta2VybmVs?=" <linux-kernel@vger.kernel.org>, "=?utf-8?B?aHUuc2hlbmdtaW5n?=" <hu.shengming@zte.com.cn>, "=?utf-8?B?emhhbmcucnVu?=" <zhang.run@zte.com.cn>
Subject: [PATCH] mm/memblock: drop redundant 'struct page *' argument from memblock_free_pages()
Mime-Version: 1.0
Content-Type: text/plain;
	charset="utf-8"
Content-Transfer-Encoding: base64
Date: Sun, 28 Dec 2025 19:38:50 +0800
X-Priority: 3
Message-ID: <tencent_600D1BCC5E1B5DB4DDD98679DA7DC3123C06@qq.com>
X-QQ-MIME: TCMime 1.0 by Tencent
X-Mailer: QQMail 2.x
X-QQ-Mailer: QQMail 2.x
X-QQ-mid: xmsepub7-0t1766921930t1ujyp4gm
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 006AD20005
X-Stat-Signature: sytmypd6zcsozei71wjnup8homowoqq6
X-Rspam-User: 
X-HE-Tag: 1766921936-689981
X-HE-Meta: U2FsdGVkX1+uEgAzVBzJUM3HH2EkP0M13Rt1C3bBk8orZ3Yq0wzldRP9phMMH0PFumPgQo8+Gom4VHuxfz6fHfbtnHeg3d9dHHwjqZJ7g8y1LLLMm5SknQcPl0DXCWAbGVnwI3opiTCe2NEIu9GAke7/08L/K2u2S6MqLFzkMQZLmq3V+Vld2XWjG/r38SykpsoQ3wJGn8eu/ba8Vs7D3/GeZh1EtBwUGUXw1kGtFpibDCHGdK/uvx+gyKNUgICZXxu6yRw1EZ0I/Tb5a2GzIpnZ59XDr1SU+ebi+FoOLs2+KE7kB9evJz1DRQQaz0J2QqejXfQb64pj6+3ExXMqK7s0dN+n3akr4rrDfRxt0+gQG0IrInotbtg1XrXMxshglN3Zc7HAEMYc3HqB0Py+rTyCEyfM1ViTlJdEjkI2lRdakSPFC12ZxS5yJ8bsraBChSqnVFDSWBJ/PzfVVMoNny2juIBX4kK7TBTRZDwi+1xvzwKW9U6buQNMShzPl6dvAJ3fQUZrHcHD8ZPBIgBcCm+CQOecEgmmvQaeKisfjAqlK6DXIztLMOvxnt9almxw6i3ByhFThsZ6W5IsjnyYFmlJM135VHyXhSVBLPnXMH33J76SBWbfZWPF471EyCYB63alRhlCIChlGqtkJCpW5Fed5lwQ4KuJPe9/syZS5eiIpV1g28CtpUMAF5dzo2iyK868QYJlkdET6gEIkzpQDtUqXEimp7j+dxqGy7CvjQ2M9W8nEQFr39LTVWbySKd5gb20vj76ENzbVWCLIyMFPZb/FnZely4VZ59PBtrWaUkB2briyRCikeGOraPqMRCvmSCtljRCRljmYXIsXgdk9i/5K58sOIHXI+xbaxIGT3wrJyYUcBVsk+Me1h1rZRd49JJSM6IjIf+8UgKkFrPuBPhRtJVnAnltsoSwul8onts4g0T/1xTXY9LfejzeynyUK+/gPI/tn6a5zpo+/RS
 9kt9fLiH
 TsggqmsSxDq7SQ9V4FrI2+scXF4ntCVvC4ZWYiA3ivmFXrb+v0eZQlSLHQqiKSbvgghRBIgHE7v3qJpL3rolnb8yBz2UgD59BfFag2s2nRu4QOdU3FQ0joE6N5d0LTfqwfP1VU34wF02P21XEjWGWWPnDPb2zlShYlYWs3hMYAWzo2L+AgrxnljECAjiYjH0/zTUW8KMo2i7hOYYMOLrq5YbfHGoMuC5wmpxXZx8EhEXYECO0NedKXg4YBdS+s+Uey3SD3JObqcTIZYsV8PPMIhXjSZjE3/gU+mz/axWeNVCRNn3M7Qiu8ekuhwnjRkccgTtSbeA6uEEm1f/Y32spTUOPm1fuRlEan98by5bE0U9DkUu3nKpPJJOFlvZgjxh06vThOayWTpxgWBHOzS9phsSdPw3DqsYQHxSG1tiy0KyuNeHrO5e8m/udYAn549zCGNVRVD1C9ZZAQon20QNP+azZXoIF5IyF3Jrp0OwzEqD+0LGEUQBy0OVLZFIWFUYTkSoODfwFhNt3R+GVN4A4eHK+/z3l/Hsp1Gj8
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
aGVuZ21pbmdAenRlLmNvbS5jbj4NCi0tLQ0KIG1tL2ludGVybmFsLmggICAgICAgICAgICAg
ICAgICAgICB8IDMgKy0tDQogbW0vbWVtYmxvY2suYyAgICAgICAgICAgICAgICAgICAgIHwg
NCArKy0tDQogbW0vbW1faW5pdC5jICAgICAgICAgICAgICAgICAgICAgIHwgNyArKysrKy0t
DQogdG9vbHMvdGVzdGluZy9tZW1ibG9jay9pbnRlcm5hbC5oIHwgMyArLS0NCiA0IGZpbGVz
IGNoYW5nZWQsIDkgaW5zZXJ0aW9ucygrKSwgOCBkZWxldGlvbnMoLSkNCg0KZGlmZiAtLWdp
dCBhL21tL2ludGVybmFsLmggYi9tbS9pbnRlcm5hbC5oDQppbmRleCBlNDMwZGE5MDAuLjVm
OTNlZTE0NSAxMDA2NDQNCi0tLSBhL21tL2ludGVybmFsLmgNCisrKyBiL21tL2ludGVybmFs
LmgNCkBAIC03NDIsOCArNzQyLDcgQEAgc3RhdGljIGlubGluZSB2b2lkIGNsZWFyX3pvbmVf
Y29udGlndW91cyhzdHJ1Y3Qgem9uZSAqem9uZSkNCiBleHRlcm4gaW50IF9faXNvbGF0ZV9m
cmVlX3BhZ2Uoc3RydWN0IHBhZ2UgKnBhZ2UsIHVuc2lnbmVkIGludCBvcmRlcik7DQogZXh0
ZXJuIHZvaWQgX19wdXRiYWNrX2lzb2xhdGVkX3BhZ2Uoc3RydWN0IHBhZ2UgKnBhZ2UsIHVu
c2lnbmVkIGludCBvcmRlciwNCiAJCQkJICAgIGludCBtdCk7DQotZXh0ZXJuIHZvaWQgbWVt
YmxvY2tfZnJlZV9wYWdlcyhzdHJ1Y3QgcGFnZSAqcGFnZSwgdW5zaWduZWQgbG9uZyBwZm4s
DQotCQkJCQl1bnNpZ25lZCBpbnQgb3JkZXIpOw0KK2V4dGVybiB2b2lkIG1lbWJsb2NrX2Zy
ZWVfcGFnZXModW5zaWduZWQgbG9uZyBwZm4sIHVuc2lnbmVkIGludCBvcmRlcik7DQogZXh0
ZXJuIHZvaWQgX19mcmVlX3BhZ2VzX2NvcmUoc3RydWN0IHBhZ2UgKnBhZ2UsIHVuc2lnbmVk
IGludCBvcmRlciwNCiAJCWVudW0gbWVtaW5pdF9jb250ZXh0IGNvbnRleHQpOw0KIA0KZGlm
ZiAtLWdpdCBhL21tL21lbWJsb2NrLmMgYi9tbS9tZW1ibG9jay5jDQppbmRleCA5MDVkMDZi
MTYuLjZlMTFmODFjNCAxMDA2NDQNCi0tLSBhL21tL21lbWJsb2NrLmMNCisrKyBiL21tL21l
bWJsb2NrLmMNCkBAIC0xNzcxLDcgKzE3NzEsNyBAQCB2b2lkIF9faW5pdCBtZW1ibG9ja19m
cmVlX2xhdGUocGh5c19hZGRyX3QgYmFzZSwgcGh5c19hZGRyX3Qgc2l6ZSkNCiAJZW5kID0g
UEZOX0RPV04oYmFzZSArIHNpemUpOw0KIA0KIAlmb3IgKDsgY3Vyc29yIDwgZW5kOyBjdXJz
b3IrKykgew0KLQkJbWVtYmxvY2tfZnJlZV9wYWdlcyhwZm5fdG9fcGFnZShjdXJzb3IpLCBj
dXJzb3IsIDApOw0KKwkJbWVtYmxvY2tfZnJlZV9wYWdlcyhjdXJzb3IsIDApOw0KIAkJdG90
YWxyYW1fcGFnZXNfaW5jKCk7DQogCX0NCiB9DQpAQCAtMjIxNiw3ICsyMjE2LDcgQEAgc3Rh
dGljIHZvaWQgX19pbml0IF9fZnJlZV9wYWdlc19tZW1vcnkodW5zaWduZWQgbG9uZyBzdGFy
dCwgdW5zaWduZWQgbG9uZyBlbmQpDQogCQl3aGlsZSAoc3RhcnQgKyAoMVVMIDw8IG9yZGVy
KSA+IGVuZCkNCiAJCQlvcmRlci0tOw0KIA0KLQkJbWVtYmxvY2tfZnJlZV9wYWdlcyhwZm5f
dG9fcGFnZShzdGFydCksIHN0YXJ0LCBvcmRlcik7DQorCQltZW1ibG9ja19mcmVlX3BhZ2Vz
KHN0YXJ0LCBvcmRlcik7DQogDQogCQlzdGFydCArPSAoMVVMIDw8IG9yZGVyKTsNCiAJfQ0K
ZGlmZiAtLWdpdCBhL21tL21tX2luaXQuYyBiL21tL21tX2luaXQuYw0KaW5kZXggZmMyYTZm
MWU1Li44ZTk1ZDY1Y2YgMTAwNjQ0DQotLS0gYS9tbS9tbV9pbml0LmMNCisrKyBiL21tL21t
X2luaXQuYw0KQEAgLTI0ODAsOSArMjQ4MCwxMCBAQCB2b2lkICpfX2luaXQgYWxsb2NfbGFy
Z2Vfc3lzdGVtX2hhc2goY29uc3QgY2hhciAqdGFibGVuYW1lLA0KIAlyZXR1cm4gdGFibGU7
DQogfQ0KIA0KLXZvaWQgX19pbml0IG1lbWJsb2NrX2ZyZWVfcGFnZXMoc3RydWN0IHBhZ2Ug
KnBhZ2UsIHVuc2lnbmVkIGxvbmcgcGZuLA0KLQkJCQkJCQl1bnNpZ25lZCBpbnQgb3JkZXIp
DQordm9pZCBfX2luaXQgbWVtYmxvY2tfZnJlZV9wYWdlcyh1bnNpZ25lZCBsb25nIHBmbiwg
dW5zaWduZWQgaW50IG9yZGVyKQ0KIHsNCisJc3RydWN0IHBhZ2UgKnBhZ2U7DQorDQogCWlm
IChJU19FTkFCTEVEKENPTkZJR19ERUZFUlJFRF9TVFJVQ1RfUEFHRV9JTklUKSkgew0KIAkJ
aW50IG5pZCA9IGVhcmx5X3Bmbl90b19uaWQocGZuKTsNCiANCkBAIC0yNDkwLDYgKzI0OTEs
OCBAQCB2b2lkIF9faW5pdCBtZW1ibG9ja19mcmVlX3BhZ2VzKHN0cnVjdCBwYWdlICpwYWdl
LCB1bnNpZ25lZCBsb25nIHBmbiwNCiAJCQlyZXR1cm47DQogCX0NCiANCisJcGFnZSA9IHBm
bl90b19wYWdlKHBmbik7DQorDQogCWlmICgha21zYW5fbWVtYmxvY2tfZnJlZV9wYWdlcyhw
YWdlLCBvcmRlcikpIHsNCiAJCS8qIEtNU0FOIHdpbGwgdGFrZSBjYXJlIG9mIHRoZXNlIHBh
Z2VzLiAqLw0KIAkJcmV0dXJuOw0KZGlmZiAtLWdpdCBhL3Rvb2xzL3Rlc3RpbmcvbWVtYmxv
Y2svaW50ZXJuYWwuaCBiL3Rvb2xzL3Rlc3RpbmcvbWVtYmxvY2svaW50ZXJuYWwuaA0KaW5k
ZXggMGFiNGI1M2JiLi4wMDliOTdiYmQgMTAwNjQ0DQotLS0gYS90b29scy90ZXN0aW5nL21l
bWJsb2NrL2ludGVybmFsLmgNCisrKyBiL3Rvb2xzL3Rlc3RpbmcvbWVtYmxvY2svaW50ZXJu
YWwuaA0KQEAgLTE1LDggKzE1LDcgQEAgYm9vbCBtaXJyb3JlZF9rZXJuZWxjb3JlID0gZmFs
c2U7DQogDQogc3RydWN0IHBhZ2Uge307DQogDQotdm9pZCBtZW1ibG9ja19mcmVlX3BhZ2Vz
KHN0cnVjdCBwYWdlICpwYWdlLCB1bnNpZ25lZCBsb25nIHBmbiwNCi0JCQkgdW5zaWduZWQg
aW50IG9yZGVyKQ0KK3ZvaWQgbWVtYmxvY2tfZnJlZV9wYWdlcyh1bnNpZ25lZCBsb25nIHBm
biwgdW5zaWduZWQgaW50IG9yZGVyKQ0KIHsNCiB9DQogDQotLSANCjIuMjUuMQ0K



Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 96017C9832F
	for <linux-mm@archiver.kernel.org>; Sun, 18 Jan 2026 08:58:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DA3976B0005; Sun, 18 Jan 2026 03:58:51 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D513C6B0089; Sun, 18 Jan 2026 03:58:51 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C337F6B008A; Sun, 18 Jan 2026 03:58:51 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id B42716B0005
	for <linux-mm@kvack.org>; Sun, 18 Jan 2026 03:58:51 -0500 (EST)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 6DF1B1A04AB
	for <linux-mm@kvack.org>; Sun, 18 Jan 2026 08:58:51 +0000 (UTC)
X-FDA: 84344484462.13.7D2121C
Received: from out162-62-57-87.mail.qq.com (out162-62-57-87.mail.qq.com [162.62.57.87])
	by imf01.hostedemail.com (Postfix) with ESMTP id 30FDC40006
	for <linux-mm@kvack.org>; Sun, 18 Jan 2026 08:58:47 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=qq.com header.s=s201512 header.b=yTi9rETU;
	dmarc=pass (policy=quarantine) header.from=qq.com;
	spf=pass (imf01.hostedemail.com: domain of chaojibjt@qq.com designates 162.62.57.87 as permitted sender) smtp.mailfrom=chaojibjt@qq.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768726729; a=rsa-sha256;
	cv=none;
	b=hYBfWvfWTgLUX66tvTQ+O4Ba6Bl6efoxWmxLGDn/RoiY3FoF6Vznd1+aTjoBB8nhWW9TqK
	VPJ1PbniimlTuOjvtGDAPzIwjIfyIY+YSSXT5sGObiNogJmemltbehjpE5gubBApRAsd2x
	YWP4V2m1Xsa5//QKLnviqD/QLX3geSI=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=qq.com header.s=s201512 header.b=yTi9rETU;
	dmarc=pass (policy=quarantine) header.from=qq.com;
	spf=pass (imf01.hostedemail.com: domain of chaojibjt@qq.com designates 162.62.57.87 as permitted sender) smtp.mailfrom=chaojibjt@qq.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768726729;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=OlxeLy5spgxqbI1wSN+vxp1/XaJj0Yyjg5jnVf4t/ps=;
	b=MIUIxdoGuYKfOemh2OFxjse8sm4sKMxOYIg3oiUGKGN50O+q5Ie9l47P1Hdrzv/r9Q8kIa
	yAVqpRIDYSHpVkk8vTl81Y1oD7qYmci5Uu7o/+jb1tgDa2xaRjVNw4oGBhng4XL5nSFp2h
	LS5sas1KI8ihNZm/AHyZvPYgSFOyT24=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qq.com; s=s201512;
	t=1768726717; bh=OlxeLy5spgxqbI1wSN+vxp1/XaJj0Yyjg5jnVf4t/ps=;
	h=From:To:Subject:Date;
	b=yTi9rETUiBE8IjJzYtPkhZjwCCN2KkUj6kP7qPFEwMlg/EsidDpKCLY5AqdyTswsh
	 uJdoxzc93VBIi6G9oRqoQshyRHFNJXIXGsQqyyyuSBAYdGA4WAdpTqh0OxTtdt76II
	 /ogRUNV7rKhBfgS/KRERlbWAJdodx2DnWO57fLpU=
X-QQ-XMRINFO: NI4Ajvh11aEjEMj13RCX7UuhPEoou2bs1g==
X-QQ-XMAILINFO: MWNwDy/40KWdvD/7sJ/aDp3KsbyRyzHowUrMlaiXb8nXyBXjKmC2UrDRoLUy2e
	 EKnThafxFHfW/EHsoLAYOmxdEPBdwEcBFmVns0Ylp3t1EkZEGqcdaZEh7pAXDppYGEtZldinhKLPg
	 fWjTPuS9kRApGK90Ir0GEmGjnO8RZ4Xb7J8n4sXv4gdgDd/yQc9Lozlw30cDKURDTT2THr/jt4mbt
	 52Yqdm1npkjCBqeSeOWSrjbeFgZpiWhF0GqG/YtT/sOIxTTNGqvuqy53MR/lzAIeVIDYel2A1P03G
	 Uf+08SWwt5UvmBecJCUuOCn0LIwhp2+cYzR992/RloT4KXDsbX4hMjtgbqCN03XpI7YQGbFNsTGj5
	 E7jE6Hg2GMVRJZhbZ8yWyucgw44D1gx0PALuTKziJU/A2kDExQSbRpsT3/JaknmlKK6OFzRFrTOEH
	 ryMHeuIBCvMfW6gf74uKVtQvXSaxzRyCMP5sGNTgsUfNXDY3rAU/4EmO4gYYdQUYtzC+TbnVYDZne
	 PPNjrkR7VgGf3sdqWENp2rp052A+R22v8X3r6AdoBgzElDI17E0XHGyFOB/jjn6iW4rKD8q9kq/Y7
	 ZduxE2eWn9sYgln/2LQN5uQQc4agfW9FCLHh6wIZaoQeAyfOXKFl+TzC0puLpoQhHc9qdSNMdUiPF
	 reejBhOrTv50FpfBBUb1lMEmZn1CXUb0fYb9e02F1VrFiKYXXIUFmtPXYP/0S5m/yPtBCmB2FWaez
	 ADu1DqSrzuHWNmH1aqeu4CipJhbcrhYm6EOhsueqpkpR+n72sHoSb+jWhVYuZlR88aF53+nu6GwZR
	 3sekcS6MtLa9I/6NlPWStLex9KyVWRh6S5dr4bBAdfyjFqMC8btZf2Br9aZgj4W70LS6rRKhpE3SJ
	 sbmtKrd0BXano7/JJX0MMwacwj6hLJqpBH8zxVyUFZkNaGUTsgcW7J2UWVoyUQrUcXLL12ul2vRm3
	 oSibfdf4IqoUzHwPKwBvZKM61g6PntF1iCpYwrr6XxdJFBsjastAbsugIjcK8kTmxhBk0L/nB2yhb
	 NdJXfjABtVu3dxV7avPhMFLAZSbl96knQv/9sBlwLUdg73pP3dXtBG6WBNAPbDmcN7+la
From: "=?utf-8?B?SW5maW5pdHk=?=" <chaojibjt@qq.com>
To: "=?utf-8?B?bGludXgtbW0=?=" <linux-mm@kvack.org>
Subject: [HELP] Request for assistance to upstream an Android memory optimization (Multi_Freearea)
Mime-Version: 1.0
Content-Type: text/plain;
	charset="utf-8"
Content-Transfer-Encoding: base64
Date: Sun, 18 Jan 2026 16:58:36 +0800
X-Priority: 3
Message-ID: <tencent_1B6C070183FB1FEA24C7AF846403A868B00A@qq.com>
X-QQ-MIME: TCMime 1.0 by Tencent
X-Mailer: QQMail 2.x
X-QQ-Mailer: QQMail 2.x
X-QQ-mid: xmsezb18-0t1768726716tvpg7ecf0
X-Rspamd-Queue-Id: 30FDC40006
X-Rspamd-Server: rspam06
X-Stat-Signature: 4g9xnfier15tcfu1yar9oac9tnf8b46x
X-Rspam-User: 
X-HE-Tag: 1768726727-777109
X-HE-Meta: U2FsdGVkX18t62BfcC0wcEtrjr2JqHe97U4WG7f37QV6pKAjhbQAzpp9HFxc5osnQ3HOhcwYF1Z/3Hb3uUrTD+77r8gkE7SHo2YskHlh5btKLP+BQAJXMzj3nOrTc/SEwsV7i92VQeShCtFwFOE44TXKuhkg0rXGI2guCB5bNt9kV6/1TetNdbWi+IDpdexTKQ7EyF0aYXR+6VcaRWUu//uFn+AoMUYI6DWH8GA7xpZvcWp6Z+igU1ObnYzzZIM+mVCxaA16SnfMXquWSJSn6lv0zDq7mOSEjc7soP5GGnW4HUNs5JJpGcXGLVM9yb4+C30wBOf9uFGd0h0VPAEPPqkmp9r2WonitJ7t16RQiDLXqaX71N0+ILifOl3xyN5hyY/Q7immsyWWUCls/K31QcuUUhtsix+v80LY8lSMxYcwYok/V/UCFDO2MakfJORITyv+n/hYda0qYi/sKBBD+KR6Hl9BegTCryPMdKBFoCrlAdKXxCUdovLNmelCAzD0wNTWUBm7LE68eg9lUcBrjX5YAU59xl9I8qQ9nCt45aGxRmdaIDscku2czPLJc58DmMoyMY1T3dW2AADo+XWqOVbRzkLcIkzgdh4AKqlbaH38b2eYvRN8C5uV9LU0RCPouqWu8ttQ7QKISqwN+LzQeVHXwlYFjw8rZ+ME76bsHWhMxInZME2iCQtTALIYx9PbGZGTw/6K+ncFRjz9iQbCZQilnDugKZWsP/Wb/LdNDsTOwFovvFeEi3Cyw+4KQIGp8kz09nWvFleTCOpWVSn/DBu99dT4R1ANa92Eh0tzYjB2IbhCDPI6I3iy6eBSvXtNYVAaS6kKN4jLCFPmKTgpuuXXs6T0HLTdzeStDMC33JYs2fkYqzi2ma74DEzUySyTDQ9+k3r4HzfORfiVBqDLERUKtcI+F3pf4MrRB8SU2ZSXW57GBMWDYV2vsiDBE5DRdThnoRUdfk2TUX3yJI7
 3iHJ+VMx
 b8treqSWKfw2zyfYY1ENNXyX4nVizoeAPV14EGS4OaVn3h/ZfQ5NspW91fDRry0VqG9Zaj3oxsclidLse5Yq4EG2ehnyhyk7XOddvVSywIJz2G9y5xy6TDDmYOigKlF98V73qqgMu0v4d2RM40G+DXVKiy9qItiXXL94C0ZvHkS0exFEH921fdaOfq9KNFOKClRzbvt/VETN7ifCKJW51ev9gNFCvmBMSG969BFrQX1CgRJqbEapS5Duilh93/aIYYUdvMt5tt9s9jvTmQhkjl55vteJ4M7a4YGiaq6wbs6qbDBPeKrVVvM59IcGCos6ar3e415V6Ns/YMOXniXBnR+U3AHIxzlFDmiks6UhqOBm1oNrf67sSBpeSGbrAvYjUlS4NaOyvGSAB1dDqkxee5EOH5gq6DNys+JyA7JzYiF9iJ6z1foN8ae24HLj0K0ZAtxCZzgO0HKsDDEg+Neoego+KDOOjPhkIq6Thksuf0jiSuPuMPdTzFd4REQ==
X-Bogosity: Unsure, tests=bogofilter, spamicity=0.454094, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

SGVsbG8sDQoNCkkgYW0gYSBub24tdGVjaG5pY2FsIHVzZXIgd2hvIGNhbWUgYWNyb3NzIGFu
IGludGVyZXN0aW5nIG1lbW9yeSBvcHRpbWl6YXRpb24NCmluIHRoZSBBbmRyb2lkIGtlcm5l
bCB0cmVlLCBhbmQgSSdtIHNlZWtpbmcgZ3VpZGFuY2Ugb24gd2hldGhlci9ob3cgaXQgbWln
aHQNCmJlIGNvbnNpZGVyZWQgZm9yIHVwc3RyZWFtIGluY2x1c2lvbi4NCg0KT3B0aW1pemF0
aW9uOiBNdWx0aV9GcmVlYXJlYQ0KTGluazogaHR0cHM6Ly9hbmRyb2lkLXJldmlldy5nb29n
bGVzb3VyY2UuY29tL2Mva2VybmVsL2NvbW1vbi8rLzI5NDI1MzANCg0KQnJpZWYgZGVzY3Jp
cHRpb246DQotIERpdmlkZXMgbWVtb3J5IGludG8gc2VnbWVudHMgYnkgUEZOIHJhbmdlIHRv
IHJlZHVjZSBleHRlcm5hbCBmcmFnbWVudGF0aW9uDQotIFRlc3RlZCBvbiBBbmRyb2lkIHdp
dGgga2VybmVsIDUuMTAsIHNob3dpbmcgOTUuNiUgcmVkdWN0aW9uIGluIENPTVBBQ1RTVEFM
TA0KLSBBdXRob3I6IGxpcGVpZmVuZyBmcm9tIE9QUE8NCg0KQXMgSSdtIG5vdCBhIGtlcm5l
bCBkZXZlbG9wZXIsIEknbSByZWFjaGluZyBvdXQgdG8gYXNrOg0KMS4gSXMgdGhpcyB0eXBl
IG9mIG9wdGltaXphdGlvbiBwb3RlbnRpYWxseSBzdWl0YWJsZSBmb3IgbWFpbmxpbmU/DQoy
LiBXaGF0IHdvdWxkIGJlIHRoZSBwcm9wZXIgcHJvY2VzcyB0byBoYXZlIGl0IGV2YWx1YXRl
ZD8NCjMuIENvdWxkIHNvbWVvbmUgd2l0aCBleHBlcnRpc2UgaW4gbWVtb3J5IG1hbmFnZW1l
bnQgdGFrZSBhIGxvb2s/DQoNCkkgdW5kZXJzdGFuZCB0aGlzIG1heSBub3QgYmUgdGhlIHR5
cGljYWwgdGVjaG5pY2FsIHBhdGNoIHN1Ym1pc3Npb24sIGJ1dCBJDQpiZWxpZXZlIHRoZSBv
cHRpbWl6YXRpb24gaGFzIG1lcml0IGFuZCB3YW50ZWQgdG8gYnJpbmcgaXQgdG8gYXR0ZW50
aW9uLg0KDQpUaGFuayB5b3UgZm9yIGFueSBndWlkYW5jZSB5b3UgY2FuIHByb3ZpZGUuDQoN
ClNpbmNlcmVseSwNCkpvaG4=



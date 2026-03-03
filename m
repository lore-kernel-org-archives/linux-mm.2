Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 55607EB365A
	for <linux-mm@archiver.kernel.org>; Tue,  3 Mar 2026 02:53:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7E61E6B00AD; Mon,  2 Mar 2026 21:53:00 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 794AE6B00AE; Mon,  2 Mar 2026 21:53:00 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 692DD6B00AF; Mon,  2 Mar 2026 21:53:00 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 4762E6B00AD
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 21:53:00 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id EA6F11A0562
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 02:52:59 +0000 (UTC)
X-FDA: 84503229678.25.A7503B8
Received: from gateway1.sungrowpower.com (unknown [202.111.193.14])
	by imf29.hostedemail.com (Postfix) with SMTP id 663D4120009
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 02:52:57 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=sungrowpower.com;
	spf=pass (imf29.hostedemail.com: domain of liying3@sungrowpower.com designates 202.111.193.14 as permitted sender) smtp.mailfrom=liying3@sungrowpower.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772506378;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references; bh=ue4tuxh1b66RpBQXtUSH4eLp5+2no34SgecGGEES3Uo=;
	b=PDvSyW9JP68zQ8ORoUzfnEVY7UmYLp//HQ8uuOlCOMBvyuH9XUNKRRB189XuIaiA0V9K0F
	Z9UKFwaKPQxetmPFoGUMY+aUy5OWgQQtZ5fRtKGD5lZ95csMTLxNzZpWIshWf6xq6Ur8EW
	df5pCUNtj/rrDF4yrHv3qcCOx6xxWS0=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=sungrowpower.com;
	spf=pass (imf29.hostedemail.com: domain of liying3@sungrowpower.com designates 202.111.193.14 as permitted sender) smtp.mailfrom=liying3@sungrowpower.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772506378; a=rsa-sha256;
	cv=none;
	b=lmTKje84HxUZVkzToaVUZS9IxpBp8hjAhJ7AVBFibTGmdFJpYK3cWXj/szLaRTyyeEWQ5P
	8MSvs2nY+eOYJXO1SrynDBArWjByThKATeTT9j5OgI77yKwr2bXoi1As8diRhyraS39URT
	W4L5Kjkx0oL3DmQQRlQzT50KG5U6nmg=
Received: from liying3-L1 (unknown [112.28.154.154])
	by email-gw.sungrowpower.com (MailData Gateway V2.8.8) with ESMTPSA id B0C21209AF295;
	Tue,  3 Mar 2026 10:52:51 +0800 (CST)
Date: Tue, 3 Mar 2026 10:52:51 +0800
X-MD-Sfrom: liying3@sungrowpower.com
X-MD-SrcIP: 112.28.154.154
From: "liying3@sungrowpower.com" <liying3@sungrowpower.com>
To: akpm <akpm@linux-foundation.org>
Cc: linux-mm <linux-mm@kvack.org>, 
	linux-kernel <linux-kernel@vger.kernel.org>, 
	victor7q <victor7q@163.com>
Subject: [BUG] mm/mempolicy: possible double-unlock in migrate_to_node() on 6.6
X-Priority: 3
X-GUID: E7186026-2565-4491-8745-B1261EC385CD
X-Has-Attach: no
X-Mailer: Foxmail 7.2.25.398[cn]
Mime-Version: 1.0
Message-ID: <2026030310525141773825@sungrowpower.com>
Content-Type: multipart/alternative;
	boundary="----=_001_NextPart311561431666_=----"
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 663D4120009
X-Stat-Signature: 97r7fdopjhf91ekgeagqkz6gsmnb68fi
X-Rspam-User: 
X-HE-Tag: 1772506377-249797
X-HE-Meta: U2FsdGVkX1/55IXiTlTdZu2ITj0evKbEPdpHh9ZjTwreLhvC4yU5sfxFdrTUzWMS4YgBgRrZTb3pREY9+3e4QoEfKrTj+pi/Wusn4TcG2YgUNwtXoDvyNz6pogK6nJzQPlcqcOCJd3ZR6kXsS64Dc46d1zOZYTN6K1aFCyjp0evttMToFjMw6/03DsMN91WIbD+sxe0Ko1ZLj+bGqibR1CqCF4ojq8ECCcGsY2xo0sjRdO5xPp1l965YJsvGZ8jPvq1FB72NSiQQlUc8plGi1TuTc/NEf0eFNyuKzHkd0i66sQdrqGecz0cq2EUDRYL31RgoiuWXjIQz9P9q/d80GtmYkfy1jJta7780uZdIsyDamQ2bP/izSl4EdiECR2q+pvalN8U4x5vssc9FEoynUrteoM3XKwfvHZxKO+bXrMNUSY3VWlRmAQgHKPfFwOduv2aPY5E9KuPRq94ZJkvTcIeJjyeyR9cOpru1mznFNweLqod0VUIw0jsmrakQbwYt8uCtk630OJowg/ANDT+thnjhAOavrHxkIYzpqIl5LDJ5Pq8ZxaDoL5kBgEdCB9nA7fJwb8uPhtk+fzkKCcr+FN6NGR03yDUyEwYSS+WwHOtN/vL9ndPJ4uKfRz3I0HM53l7jqWaEbBtlIpwR3kQiv8R0pulff/vP6T/tv8f3NIkkyh8hrZE6AeATGA0laiGIrsyqudQfWQhl73AAkpk4uIWDHODDni57bxQwi6itPeX1ISMelUnxCMGG4N3K3Vb8z7pGK734egYVv7YnDLciDRSWHCf7d+XXuV7Apu+zyF2KIxDzobxHv/5QQowW626RTfGtvMI8p1zYTpLoS1JnYC01d0Ebt3e1pep+/cIw5TG7KJ6Bd82XRs+gV0MlJGJfrhDmxJmkejo5+ozgpKtAc3vBqJ7oyYwl1luWgT2vkvGD/FhvOsjNTeP5LATIBvyNFhha8Ab7FvdKRAO/6PM
 gu1eaNh4
 x66/b8Bscgh9EgjoGP0O9O6sVx3Gpb55USeUJknO8CBkRNIrB9wSnf98OVJN2SkO1Q8ULogI3itLEMab0wSafk2sAFoH2YHobRZop7/UhkKTd2TsLhPdewiV9SCKCzmn+2RUAn0kUtEVE4SrJEhgo8yXdMUJbVgqJFbfDYu604W5WxQhqDV9QWDBi7HrEf2hcWHK/9S47BfVH4nu4/afZcZM9/X+bp6Vd25PR3F6sFGaLItK04WLI8f2AnohTPdxCFKz2jDpKBnxzZn+RV0wWMBHPL9AJcSuiS6AYV+DnjWxvxeV80uDjXF7j4G+dibxB1LWtDUqSZxAGeoywMnhdAM5poKfpjS6va0tHpfI2zv4Nns3FMSru4jZMCuE8XItmtuFQqJUYPefGddpta3JT4BNdvdiDxyMd/sut9CShn73w47s4MnjJ7yXt4jnmg7SvGUNFlGPhckW0eTKlr8MBCXfqN/eEWg7e/FS6af1GuWrS/pE9y5kt26LYxT1qSk7aBfs/6usL70P3UFwarnqHrxMA6DoJjiKgwboP4boKmnUP0d9EICmWx6NBRKvous58Z8d7EsI2zzCbKBhLNAE4Dufs1PvCwsX/QSinKuclQUdTiGFh75+bPCdtkwRLCvwlNPW+wMDkrcKLpWbVJjE/r2o9wEvwxqFfVDFJ8KJ3/F1NabnedgldfldRGZ0ss8SfhZpm6HMd4xWWmN/wXzAFr17GXFXNbWPtXm4/hI9BjSARzc57rNZb8pR+i3FolU9bpZOT
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This is a multi-part message in MIME format.

------=_001_NextPart311561431666_=----
Content-Type: text/plain;
	charset="GB2312"
Content-Transfer-Encoding: base64

SGkgQW5kcmV3LA0KDQpJIGZvdW5kIHRoYXQgYSBmaXggaXMgcmVxdWlyZWQgZm9yIHRoaXMgc3Vi
bWlzc2lvbiBpbiBicmFuY2ggNi42Lg0KaHR0cHM6Ly9naXQua2VybmVsLm9yZy9wdWIvc2NtL2xp
bnV4L2tlcm5lbC9naXQvc3RhYmxlL2xpbnV4LmdpdC9jb21taXQvP2lkPWExM2IyYjliMGIwYjA0
NjEyYzdkODFlM2IzZGZiNDg1YzVmN2FiYzMgDQoNClJlZ2FyZGluZyB0aGUgZGlmZmVyZW5jZSBi
ZXR3ZWVuIGJyYW5jaGVzIDYuNiBhbmQgNi4xMiwgaW4gYnJhbmNoIDYuNiwgbW1hcF9yZWFkX2xv
Y2soKSBhbmQgbW1hcF9yZWFkX3VubG9jaygpIGFyZSBjYWxsZWQgb3V0c2lkZSB0aGUgbWlncmF0
ZV90b19ub2RlKCkgZnVuY3Rpb24uIA0KVGhlcmVmb3JlLCBtbWFwX3JlYWRfdW5sb2NrKG1tKSBz
aG91bGQgbm90IGJlIGludm9rZWQgaW5zaWRlIG1pZ3JhdGVfdG9fbm9kZSgpOyBvdGhlcndpc2Us
IGl0IHdvdWxkIHJlc3VsdCBpbiBhIGRvdWJsZSB1bmxvY2sgb2YgdGhlIG1tLg0KZGlmZiAtLWdp
dCBhL21tL21lbXBvbGljeS5jIGIvbW0vbWVtcG9saWN5LmMNCmluZGV4IDU0ZjFiNzhkMWIyYzBm
Li45NGM3NGM1OTRkMTAyYSAxMDA2NDQNCi0tLSBhL21tL21lbXBvbGljeS5jDQorKysgYi9tbS9t
ZW1wb2xpY3kuYw0KQEAgLTEwNzEsNiArMTA3MSwxMCBAQCBzdGF0aWMgbG9uZyBtaWdyYXRlX3Rv
X25vZGUoc3RydWN0IG1tX3N0cnVjdCAqbW0sIGludCBzb3VyY2UsIGludCBkZXN0LA0KVk1fQlVH
X09OKCEoZmxhZ3MgJiAoTVBPTF9NRl9NT1ZFIHwgTVBPTF9NRl9NT1ZFX0FMTCkpKTsNCnZtYSA9
IGZpbmRfdm1hKG1tLCAwKTsNCisgaWYgKHVubGlrZWx5KCF2bWEpKSB7DQorIG1tYXBfcmVhZF91
bmxvY2sobW0pOyAvLyB0aGlzIGxpbmUgc2hvdWxkIGJlIGRlbGV0ZWQNCisgcmV0dXJuIDA7DQor
IH0NCi8qDQoqIFRoaXMgZG9lcyBub3QgbWlncmF0ZSB0aGUgcmFuZ2UsIGJ1dCBpc29sYXRlcyBh
bGwgcGFnZXMgdGhhdA0KDQoNCg0KQmVzdCBSZWdhcmRzLA0KTGkgWWluZyAsIExpZ2h0IFN0b3Jh
Z2UgR3JvdXAuICBTZW5pb3IgRW1iZWRkZWQgU29mdHdhcmUgRW5naW5lZXINClRlbDogLaO7IEZh
eDogLQ0KTW9iaWxlOiArODYtMTU2NTE5NjM5ODENCmxpeWluZzNAc3VuZ3Jvd3Bvd2VyLmNvbSAN
Cnd3dy5zdW5ncm93cG93ZXIuY29tDQpTVU5HUk9XIFBPV0VSIFNVUFBMWSBDby4sIEx0ZC4gDQpB
ZGQ6IE5vLjE2OTkgWGl5b3UgUmQuLCBOZXcgJiBIaWdoIFRlY2hub2xvZ3kgSW5kdXN0cmlhbCBE
ZXZlbG9wbWVudCBab25lLCBIZWZlaSwgUC4gUi4gQ2hpbmEuLCAyMzAwODgNCg==

------=_001_NextPart311561431666_=----
Content-Type: text/html;
	charset="GB2312"
Content-Transfer-Encoding: quoted-printable

<html><head><meta http-equiv=3D"content-type" content=3D"text/html; charse=
t=3DGB2312"><style>body { line-height: 1.5; }p { margin-top: 0px; margin-b=
ottom: 0px; }body { font-size: 14px; font-family: "Microsoft YaHei UI"; co=
lor: rgb(0, 0, 0); line-height: 1.5; }</style></head><body>=0A<div><span><=
/span>Hi&nbsp;Andrew,</div><div><br></div><div><span style=3D"color: rgb(1=
5, 17, 21); font-family: quote-cjk-patch, Inter, system-ui, -apple-system,=
 BlinkMacSystemFont, &quot;Segoe UI&quot;, Roboto, Oxygen, Ubuntu, Cantare=
ll, &quot;Open Sans&quot;, &quot;Helvetica Neue&quot;, sans-serif; font-si=
ze: 16px;">I found that a fix is required for this submission in branch 6.=
6.</span></div><div><a href=3D"https://git.kernel.org/pub/scm/linux/kernel=
/git/stable/linux.git/commit/?id=3Da13b2b9b0b0b04612c7d81e3b3dfb485c5f7abc=
3" style=3D"background-color: transparent;" class=3D"">https://git.kernel.=
org/pub/scm/linux/kernel/git/stable/linux.git/commit/?id=3Da13b2b9b0b0b046=
12c7d81e3b3dfb485c5f7abc3</a><span style=3D"color: rgb(0, 0, 0); backgroun=
d-color: rgba(0, 0, 0, 0);">&nbsp;</span></div><div><span style=3D"color: =
rgb(0, 0, 0); background-color: rgba(0, 0, 0, 0);"><br></span></div><div><=
span style=3D"color: rgb(15, 17, 21); font-family: quote-cjk-patch, Inter,=
 system-ui, -apple-system, BlinkMacSystemFont, &quot;Segoe UI&quot;, Robot=
o, Oxygen, Ubuntu, Cantarell, &quot;Open Sans&quot;, &quot;Helvetica Neue&=
quot;, sans-serif; font-size: 16px;">Regarding the difference between bran=
ches 6.6 and 6.12, in branch 6.6,&nbsp;</span><code style=3D"box-sizing: b=
order-box; font-family: var(--ds-font-family-code); background-color: var(=
--dsw-alias-markdown-inline-code); border-radius: 6px; align-items: center=
; padding: 0px 5px; display: inline-flex; color: rgb(15, 17, 21); font-siz=
e: 0.875em !important;">mmap_read_lock()</code><span style=3D"color: rgb(1=
5, 17, 21); font-family: quote-cjk-patch, Inter, system-ui, -apple-system,=
 BlinkMacSystemFont, &quot;Segoe UI&quot;, Roboto, Oxygen, Ubuntu, Cantare=
ll, &quot;Open Sans&quot;, &quot;Helvetica Neue&quot;, sans-serif; font-si=
ze: 16px;">&nbsp;and&nbsp;</span><code style=3D"box-sizing: border-box; fo=
nt-family: var(--ds-font-family-code); background-color: var(--dsw-alias-m=
arkdown-inline-code); border-radius: 6px; align-items: center; padding: 0p=
x 5px; display: inline-flex; color: rgb(15, 17, 21); font-size: 0.875em !i=
mportant;">mmap_read_unlock()</code><span style=3D"color: rgb(15, 17, 21);=
 font-family: quote-cjk-patch, Inter, system-ui, -apple-system, BlinkMacSy=
stemFont, &quot;Segoe UI&quot;, Roboto, Oxygen, Ubuntu, Cantarell, &quot;O=
pen Sans&quot;, &quot;Helvetica Neue&quot;, sans-serif; font-size: 16px;">=
&nbsp;are called outside the&nbsp;</span><code style=3D"box-sizing: border=
-box; font-family: var(--ds-font-family-code); background-color: var(--dsw=
-alias-markdown-inline-code); border-radius: 6px; align-items: center; pad=
ding: 0px 5px; display: inline-flex; color: rgb(15, 17, 21); font-size: 0.=
875em !important;">migrate_to_node()</code><span style=3D"color: rgb(15, 1=
7, 21); font-family: quote-cjk-patch, Inter, system-ui, -apple-system, Bli=
nkMacSystemFont, &quot;Segoe UI&quot;, Roboto, Oxygen, Ubuntu, Cantarell, =
&quot;Open Sans&quot;, &quot;Helvetica Neue&quot;, sans-serif; font-size: =
16px;">&nbsp;function.&nbsp;</span></div><div><span style=3D"color: rgb(15=
, 17, 21); font-family: quote-cjk-patch, Inter, system-ui, -apple-system, =
BlinkMacSystemFont, &quot;Segoe UI&quot;, Roboto, Oxygen, Ubuntu, Cantarel=
l, &quot;Open Sans&quot;, &quot;Helvetica Neue&quot;, sans-serif; font-siz=
e: 16px;">Therefore,&nbsp;</span><code style=3D"box-sizing: border-box; fo=
nt-family: var(--ds-font-family-code); background-color: var(--dsw-alias-m=
arkdown-inline-code); border-radius: 6px; align-items: center; padding: 0p=
x 5px; display: inline-flex; color: rgb(15, 17, 21); font-size: 0.875em !i=
mportant;">mmap_read_unlock(mm)</code><span style=3D"color: rgb(15, 17, 21=
); font-family: quote-cjk-patch, Inter, system-ui, -apple-system, BlinkMac=
SystemFont, &quot;Segoe UI&quot;, Roboto, Oxygen, Ubuntu, Cantarell, &quot=
;Open Sans&quot;, &quot;Helvetica Neue&quot;, sans-serif; font-size: 16px;=
">&nbsp;should not be invoked inside&nbsp;</span><code style=3D"box-sizing=
: border-box; font-family: var(--ds-font-family-code); background-color: v=
ar(--dsw-alias-markdown-inline-code); border-radius: 6px; align-items: cen=
ter; padding: 0px 5px; display: inline-flex; color: rgb(15, 17, 21); font-=
size: 0.875em !important;">migrate_to_node()</code><span style=3D"color: r=
gb(15, 17, 21); font-family: quote-cjk-patch, Inter, system-ui, -apple-sys=
tem, BlinkMacSystemFont, &quot;Segoe UI&quot;, Roboto, Oxygen, Ubuntu, Can=
tarell, &quot;Open Sans&quot;, &quot;Helvetica Neue&quot;, sans-serif; fon=
t-size: 16px;">; otherwise, it would result in a double unlock of the&nbsp=
;</span><code style=3D"box-sizing: border-box; font-family: var(--ds-font-=
family-code); background-color: var(--dsw-alias-markdown-inline-code); bor=
der-radius: 6px; align-items: center; padding: 0px 5px; display: inline-fl=
ex; color: rgb(15, 17, 21); font-size: 0.875em !important;">mm</code><span=
 style=3D"color: rgb(15, 17, 21); font-family: quote-cjk-patch, Inter, sys=
tem-ui, -apple-system, BlinkMacSystemFont, &quot;Segoe UI&quot;, Roboto, O=
xygen, Ubuntu, Cantarell, &quot;Open Sans&quot;, &quot;Helvetica Neue&quot=
;, sans-serif; font-size: 16px;">.</span></div><div><span style=3D"text-de=
coration-thickness: initial; text-decoration-style: initial; text-decorati=
on-color: initial;"><div class=3D"head" style=3D"font-weight: bold; margin=
-top: 1em; font-family: &quot;Source Code Pro&quot;, &quot;Courier New&quo=
t;, monospace; font-size: 13.3333px; white-space: pre;">diff --git a/mm/me=
mpolicy.c b/mm/mempolicy.c<br>index 54f1b78d1b2c0f..94c74c594d102a 100644<=
br>--- a/<a href=3D"https://git.kernel.org/pub/scm/linux/kernel/git/stable=
/linux.git/tree/mm/mempolicy.c?id=3Dcc424890b06ba1d41d7ec99984b65592184adf=
0b" style=3D"color: blue; text-decoration-line: none;">mm/mempolicy.c</a><=
br>+++ b/<a href=3D"https://git.kernel.org/pub/scm/linux/kernel/git/stable=
/linux.git/tree/mm/mempolicy.c?id=3Da13b2b9b0b0b04612c7d81e3b3dfb485c5f7ab=
c3" style=3D"color: blue; text-decoration-line: none;">mm/mempolicy.c</a><=
/div><div class=3D"hunk" style=3D"color: rgb(0, 0, 153); font-family: &quo=
t;Source Code Pro&quot;, &quot;Courier New&quot;, monospace; font-size: 13=
.3333px; white-space: pre;">@@ -1071,6 +1071,10 @@ static long migrate_to_=
node(struct mm_struct *mm, int source, int dest,</div><div class=3D"ctx" s=
tyle=3D"color: rgb(51, 51, 51); font-family: &quot;Source Code Pro&quot;, =
&quot;Courier New&quot;, monospace; font-size: 13.3333px; white-space: pre=
;"> </div><div class=3D"ctx" style=3D"color: rgb(51, 51, 51); font-family:=
 &quot;Source Code Pro&quot;, &quot;Courier New&quot;, monospace; font-siz=
e: 13.3333px; white-space: pre;"> 	VM_BUG_ON(!(flags &amp; (MPOL_MF_MOVE |=
 MPOL_MF_MOVE_ALL)));</div><div class=3D"ctx" style=3D"color: rgb(51, 51, =
51); font-family: &quot;Source Code Pro&quot;, &quot;Courier New&quot;, mo=
nospace; font-size: 13.3333px; white-space: pre;"> 	vma =3D find_vma(mm, 0=
);</div><div class=3D"add" style=3D"color: green; font-family: &quot;Sourc=
e Code Pro&quot;, &quot;Courier New&quot;, monospace; font-size: 13.3333px=
; white-space: pre;">+	if (unlikely(!vma)) {</div><div class=3D"add" style=
=3D"font-family: &quot;Source Code Pro&quot;, &quot;Courier New&quot;, mon=
ospace; font-size: 13.3333px; white-space: pre;"><span style=3D"color: gre=
en;">+		mmap_read_unlock(mm);         </span><font color=3D"#ff0000">// th=
is line should be deleted</font></div><div class=3D"add" style=3D"color: g=
reen; font-family: &quot;Source Code Pro&quot;, &quot;Courier New&quot;, m=
onospace; font-size: 13.3333px; white-space: pre;">+		return 0;</div><div =
class=3D"add" style=3D"color: green; font-family: &quot;Source Code Pro&qu=
ot;, &quot;Courier New&quot;, monospace; font-size: 13.3333px; white-space=
: pre;">+	}</div><div class=3D"ctx" style=3D"color: rgb(51, 51, 51); font-=
family: &quot;Source Code Pro&quot;, &quot;Courier New&quot;, monospace; f=
ont-size: 13.3333px; white-space: pre;"> </div><div class=3D"ctx" style=3D=
"color: rgb(51, 51, 51); font-family: &quot;Source Code Pro&quot;, &quot;C=
ourier New&quot;, monospace; font-size: 13.3333px; white-space: pre;"> 	/*=
</div><div class=3D"ctx" style=3D"color: rgb(51, 51, 51); font-family: &qu=
ot;Source Code Pro&quot;, &quot;Courier New&quot;, monospace; font-size: 1=
3.3333px; white-space: pre;"> 	 * This does not migrate the range, but iso=
lates all pages that</div></span></div><span style=3D"color: rgb(0, 0, 0);=
 background-color: rgba(0, 0, 0, 0);"></span>=0A<div><br></div><hr style=
=3D"width: 210px; height: 1px;" color=3D"#b5c4df" size=3D"1" align=3D"left=
">=0A<div><span><div style=3D"margin: 10px;"><!--[if gte mso 9]><xml>=0A <=
o:OfficeDocumentSettings>=0A  <o:TargetScreenSize>800x600</o:TargetScreenS=
ize>=0A </o:OfficeDocumentSettings>=0A</xml><![endif]-->=0A<!--[if gte mso=
 9]><xml>=0A <w:WordDocument>=0A  <w:View>Normal</w:View>=0A  <w:Zoom>0</w=
:Zoom>=0A  <w:TrackMoves></w:TrackMoves>=0A  <w:TrackFormatting></w:TrackF=
ormatting>=0A  <w:PunctuationKerning></w:PunctuationKerning>=0A  <w:Drawin=
gGridVerticalSpacing>7.8 =B0=F5</w:DrawingGridVerticalSpacing>=0A  <w:Disp=
layHorizontalDrawingGridEvery>0</w:DisplayHorizontalDrawingGridEvery>=0A  =
<w:DisplayVerticalDrawingGridEvery>2</w:DisplayVerticalDrawingGridEvery>=
=0A  <w:ValidateAgainstSchemas></w:ValidateAgainstSchemas>=0A  <w:SaveIfXM=
LInvalid>false</w:SaveIfXMLInvalid>=0A  <w:IgnoreMixedContent>false</w:Ign=
oreMixedContent>=0A  <w:AlwaysShowPlaceholderText>false</w:AlwaysShowPlace=
holderText>=0A  <w:DoNotPromoteQF></w:DoNotPromoteQF>=0A  <w:LidThemeOther=
>EN-US</w:LidThemeOther>=0A  <w:LidThemeAsian>ZH-CN</w:LidThemeAsian>=0A  =
<w:LidThemeComplexScript>X-NONE</w:LidThemeComplexScript>=0A  <w:Compatibi=
lity>=0A   <w:SpaceForUL></w:SpaceForUL>=0A   <w:BalanceSingleByteDoubleBy=
teWidth></w:BalanceSingleByteDoubleByteWidth>=0A   <w:DoNotLeaveBackslashA=
lone></w:DoNotLeaveBackslashAlone>=0A   <w:ULTrailSpace></w:ULTrailSpace>=
=0A   <w:DoNotExpandShiftReturn></w:DoNotExpandShiftReturn>=0A   <w:Adjust=
LineHeightInTable></w:AdjustLineHeightInTable>=0A   <w:BreakWrappedTables>=
</w:BreakWrappedTables>=0A   <w:SnapToGridInCell></w:SnapToGridInCell>=0A =
  <w:WrapTextWithPunct></w:WrapTextWithPunct>=0A   <w:UseAsianBreakRules><=
/w:UseAsianBreakRules>=0A   <w:DontGrowAutofit></w:DontGrowAutofit>=0A   <=
w:SplitPgBreakAndParaMark></w:SplitPgBreakAndParaMark>=0A   <w:EnableOpenT=
ypeKerning></w:EnableOpenTypeKerning>=0A   <w:DontFlipMirrorIndents></w:Do=
ntFlipMirrorIndents>=0A   <w:OverrideTableStyleHps></w:OverrideTableStyleH=
ps>=0A   <w:UseFELayout></w:UseFELayout>=0A  </w:Compatibility>=0A  <w:Bro=
wserLevel>MicrosoftInternetExplorer4</w:BrowserLevel>=0A  <m:mathPr>=0A   =
<m:mathFont m:val=3D"Cambria Math"></m:mathFont>=0A   <m:brkBin m:val=3D"b=
efore"></m:brkBin>=0A   <m:brkBinSub m:val=3D"&#45;-"></m:brkBinSub>=0A   =
<m:smallFrac m:val=3D"off"></m:smallFrac>=0A   <m:dispDef></m:dispDef>=0A =
  <m:lMargin m:val=3D"0"></m:lMargin>=0A   <m:rMargin m:val=3D"0"></m:rMar=
gin>=0A   <m:defJc m:val=3D"centerGroup"></m:defJc>=0A   <m:wrapIndent m:v=
al=3D"1440"></m:wrapIndent>=0A   <m:intLim m:val=3D"subSup"></m:intLim>=0A=
   <m:naryLim m:val=3D"undOvr"></m:naryLim>=0A  </m:mathPr></w:WordDocumen=
t>=0A</xml><![endif]--><!--[if gte mso 9]><xml>=0A <w:LatentStyles DefLock=
edState=3D"false" DefUnhideWhenUsed=3D"false"=0A  DefSemiHidden=3D"false" =
DefQFormat=3D"false" DefPriority=3D"99"=0A  LatentStyleCount=3D"375">=0A  =
<w:LsdException Locked=3D"false" Priority=3D"0" QFormat=3D"true" Name=3D"N=
ormal"></w:LsdException>=0A  <w:LsdException Locked=3D"false" Priority=3D"=
9" QFormat=3D"true" Name=3D"heading 1"></w:LsdException>=0A  <w:LsdExcepti=
on Locked=3D"false" Priority=3D"9" SemiHidden=3D"true"=0A   UnhideWhenUsed=
=3D"true" QFormat=3D"true" Name=3D"heading 2"></w:LsdException>=0A  <w:Lsd=
Exception Locked=3D"false" Priority=3D"9" SemiHidden=3D"true"=0A   UnhideW=
henUsed=3D"true" QFormat=3D"true" Name=3D"heading 3"></w:LsdException>=0A =
 <w:LsdException Locked=3D"false" Priority=3D"9" SemiHidden=3D"true"=0A   =
UnhideWhenUsed=3D"true" QFormat=3D"true" Name=3D"heading 4"></w:LsdExcepti=
on>=0A  <w:LsdException Locked=3D"false" Priority=3D"9" SemiHidden=3D"true=
"=0A   UnhideWhenUsed=3D"true" QFormat=3D"true" Name=3D"heading 5"></w:Lsd=
Exception>=0A  <w:LsdException Locked=3D"false" Priority=3D"9" SemiHidden=
=3D"true"=0A   UnhideWhenUsed=3D"true" QFormat=3D"true" Name=3D"heading 6"=
></w:LsdException>=0A  <w:LsdException Locked=3D"false" Priority=3D"9" Sem=
iHidden=3D"true"=0A   UnhideWhenUsed=3D"true" QFormat=3D"true" Name=3D"hea=
ding 7"></w:LsdException>=0A  <w:LsdException Locked=3D"false" Priority=3D=
"9" SemiHidden=3D"true"=0A   UnhideWhenUsed=3D"true" QFormat=3D"true" Name=
=3D"heading 8"></w:LsdException>=0A  <w:LsdException Locked=3D"false" Prio=
rity=3D"9" SemiHidden=3D"true"=0A   UnhideWhenUsed=3D"true" QFormat=3D"tru=
e" Name=3D"heading 9"></w:LsdException>=0A  <w:LsdException Locked=3D"fals=
e" SemiHidden=3D"true" UnhideWhenUsed=3D"true"=0A   Name=3D"index 1"></w:L=
sdException>=0A  <w:LsdException Locked=3D"false" SemiHidden=3D"true" Unhi=
deWhenUsed=3D"true"=0A   Name=3D"index 2"></w:LsdException>=0A  <w:LsdExce=
ption Locked=3D"false" SemiHidden=3D"true" UnhideWhenUsed=3D"true"=0A   Na=
me=3D"index 3"></w:LsdException>=0A  <w:LsdException Locked=3D"false" Semi=
Hidden=3D"true" UnhideWhenUsed=3D"true"=0A   Name=3D"index 4"></w:LsdExcep=
tion>=0A  <w:LsdException Locked=3D"false" SemiHidden=3D"true" UnhideWhenU=
sed=3D"true"=0A   Name=3D"index 5"></w:LsdException>=0A  <w:LsdException L=
ocked=3D"false" SemiHidden=3D"true" UnhideWhenUsed=3D"true"=0A   Name=3D"i=
ndex 6"></w:LsdException>=0A  <w:LsdException Locked=3D"false" SemiHidden=
=3D"true" UnhideWhenUsed=3D"true"=0A   Name=3D"index 7"></w:LsdException>=
=0A  <w:LsdException Locked=3D"false" SemiHidden=3D"true" UnhideWhenUsed=
=3D"true"=0A   Name=3D"index 8"></w:LsdException>=0A  <w:LsdException Lock=
ed=3D"false" SemiHidden=3D"true" UnhideWhenUsed=3D"true"=0A   Name=3D"inde=
x 9"></w:LsdException>=0A  <w:LsdException Locked=3D"false" Priority=3D"39=
" SemiHidden=3D"true"=0A   UnhideWhenUsed=3D"true" Name=3D"toc 1"></w:LsdE=
xception>=0A  <w:LsdException Locked=3D"false" Priority=3D"39" SemiHidden=
=3D"true"=0A   UnhideWhenUsed=3D"true" Name=3D"toc 2"></w:LsdException>=0A=
  <w:LsdException Locked=3D"false" Priority=3D"39" SemiHidden=3D"true"=0A =
  UnhideWhenUsed=3D"true" Name=3D"toc 3"></w:LsdException>=0A  <w:LsdExcep=
tion Locked=3D"false" Priority=3D"39" SemiHidden=3D"true"=0A   UnhideWhenU=
sed=3D"true" Name=3D"toc 4"></w:LsdException>=0A  <w:LsdException Locked=
=3D"false" Priority=3D"39" SemiHidden=3D"true"=0A   UnhideWhenUsed=3D"true=
" Name=3D"toc 5"></w:LsdException>=0A  <w:LsdException Locked=3D"false" Pr=
iority=3D"39" SemiHidden=3D"true"=0A   UnhideWhenUsed=3D"true" Name=3D"toc=
 6"></w:LsdException>=0A  <w:LsdException Locked=3D"false" Priority=3D"39"=
 SemiHidden=3D"true"=0A   UnhideWhenUsed=3D"true" Name=3D"toc 7"></w:LsdEx=
ception>=0A  <w:LsdException Locked=3D"false" Priority=3D"39" SemiHidden=
=3D"true"=0A   UnhideWhenUsed=3D"true" Name=3D"toc 8"></w:LsdException>=0A=
  <w:LsdException Locked=3D"false" Priority=3D"39" SemiHidden=3D"true"=0A =
  UnhideWhenUsed=3D"true" Name=3D"toc 9"></w:LsdException>=0A  <w:LsdExcep=
tion Locked=3D"false" SemiHidden=3D"true" UnhideWhenUsed=3D"true"=0A   Nam=
e=3D"Normal Indent"></w:LsdException>=0A  <w:LsdException Locked=3D"false"=
 SemiHidden=3D"true" UnhideWhenUsed=3D"true"=0A   Name=3D"footnote text"><=
/w:LsdException>=0A  <w:LsdException Locked=3D"false" SemiHidden=3D"true" =
UnhideWhenUsed=3D"true"=0A   Name=3D"annotation text"></w:LsdException>=0A=
  <w:LsdException Locked=3D"false" SemiHidden=3D"true" UnhideWhenUsed=3D"t=
rue"=0A   Name=3D"header"></w:LsdException>=0A  <w:LsdException Locked=3D"=
false" SemiHidden=3D"true" UnhideWhenUsed=3D"true"=0A   Name=3D"footer"></=
w:LsdException>=0A  <w:LsdException Locked=3D"false" SemiHidden=3D"true" U=
nhideWhenUsed=3D"true"=0A   Name=3D"index heading"></w:LsdException>=0A  <=
w:LsdException Locked=3D"false" Priority=3D"35" SemiHidden=3D"true"=0A   U=
nhideWhenUsed=3D"true" QFormat=3D"true" Name=3D"caption"></w:LsdException>=
=0A  <w:LsdException Locked=3D"false" SemiHidden=3D"true" UnhideWhenUsed=
=3D"true"=0A   Name=3D"table of figures"></w:LsdException>=0A  <w:LsdExcep=
tion Locked=3D"false" SemiHidden=3D"true" UnhideWhenUsed=3D"true"=0A   Nam=
e=3D"envelope address"></w:LsdException>=0A  <w:LsdException Locked=3D"fal=
se" SemiHidden=3D"true" UnhideWhenUsed=3D"true"=0A   Name=3D"envelope retu=
rn"></w:LsdException>=0A  <w:LsdException Locked=3D"false" SemiHidden=3D"t=
rue" UnhideWhenUsed=3D"true"=0A   Name=3D"footnote reference"></w:LsdExcep=
tion>=0A  <w:LsdException Locked=3D"false" SemiHidden=3D"true" UnhideWhenU=
sed=3D"true"=0A   Name=3D"annotation reference"></w:LsdException>=0A  <w:L=
sdException Locked=3D"false" SemiHidden=3D"true" UnhideWhenUsed=3D"true"=
=0A   Name=3D"line number"></w:LsdException>=0A  <w:LsdException Locked=3D=
"false" SemiHidden=3D"true" UnhideWhenUsed=3D"true"=0A   Name=3D"page numb=
er"></w:LsdException>=0A  <w:LsdException Locked=3D"false" SemiHidden=3D"t=
rue" UnhideWhenUsed=3D"true"=0A   Name=3D"endnote reference"></w:LsdExcept=
ion>=0A  <w:LsdException Locked=3D"false" SemiHidden=3D"true" UnhideWhenUs=
ed=3D"true"=0A   Name=3D"endnote text"></w:LsdException>=0A  <w:LsdExcepti=
on Locked=3D"false" SemiHidden=3D"true" UnhideWhenUsed=3D"true"=0A   Name=
=3D"table of authorities"></w:LsdException>=0A  <w:LsdException Locked=3D"=
false" SemiHidden=3D"true" UnhideWhenUsed=3D"true"=0A   Name=3D"macro"></w=
:LsdException>=0A  <w:LsdException Locked=3D"false" SemiHidden=3D"true" Un=
hideWhenUsed=3D"true"=0A   Name=3D"toa heading"></w:LsdException>=0A  <w:L=
sdException Locked=3D"false" SemiHidden=3D"true" UnhideWhenUsed=3D"true"=
=0A   Name=3D"List"></w:LsdException>=0A  <w:LsdException Locked=3D"false"=
 SemiHidden=3D"true" UnhideWhenUsed=3D"true"=0A   Name=3D"List Bullet"></w=
:LsdException>=0A  <w:LsdException Locked=3D"false" SemiHidden=3D"true" Un=
hideWhenUsed=3D"true"=0A   Name=3D"List Number"></w:LsdException>=0A  <w:L=
sdException Locked=3D"false" SemiHidden=3D"true" UnhideWhenUsed=3D"true"=
=0A   Name=3D"List 2"></w:LsdException>=0A  <w:LsdException Locked=3D"fals=
e" SemiHidden=3D"true" UnhideWhenUsed=3D"true"=0A   Name=3D"List 3"></w:Ls=
dException>=0A  <w:LsdException Locked=3D"false" SemiHidden=3D"true" Unhid=
eWhenUsed=3D"true"=0A   Name=3D"List 4"></w:LsdException>=0A  <w:LsdExcept=
ion Locked=3D"false" SemiHidden=3D"true" UnhideWhenUsed=3D"true"=0A   Name=
=3D"List 5"></w:LsdException>=0A  <w:LsdException Locked=3D"false" SemiHid=
den=3D"true" UnhideWhenUsed=3D"true"=0A   Name=3D"List Bullet 2"></w:LsdEx=
ception>=0A  <w:LsdException Locked=3D"false" SemiHidden=3D"true" UnhideWh=
enUsed=3D"true"=0A   Name=3D"List Bullet 3"></w:LsdException>=0A  <w:LsdEx=
ception Locked=3D"false" SemiHidden=3D"true" UnhideWhenUsed=3D"true"=0A   =
Name=3D"List Bullet 4"></w:LsdException>=0A  <w:LsdException Locked=3D"fal=
se" SemiHidden=3D"true" UnhideWhenUsed=3D"true"=0A   Name=3D"List Bullet 5=
"></w:LsdException>=0A  <w:LsdException Locked=3D"false" SemiHidden=3D"tru=
e" UnhideWhenUsed=3D"true"=0A   Name=3D"List Number 2"></w:LsdException>=
=0A  <w:LsdException Locked=3D"false" SemiHidden=3D"true" UnhideWhenUsed=
=3D"true"=0A   Name=3D"List Number 3"></w:LsdException>=0A  <w:LsdExceptio=
n Locked=3D"false" SemiHidden=3D"true" UnhideWhenUsed=3D"true"=0A   Name=
=3D"List Number 4"></w:LsdException>=0A  <w:LsdException Locked=3D"false" =
SemiHidden=3D"true" UnhideWhenUsed=3D"true"=0A   Name=3D"List Number 5"></=
w:LsdException>=0A  <w:LsdException Locked=3D"false" Priority=3D"10" QForm=
at=3D"true" Name=3D"Title"></w:LsdException>=0A  <w:LsdException Locked=3D=
"false" SemiHidden=3D"true" UnhideWhenUsed=3D"true"=0A   Name=3D"Closing">=
</w:LsdException>=0A  <w:LsdException Locked=3D"false" SemiHidden=3D"true"=
 UnhideWhenUsed=3D"true"=0A   Name=3D"Signature"></w:LsdException>=0A  <w:=
LsdException Locked=3D"false" Priority=3D"0" SemiHidden=3D"true"=0A   Unhi=
deWhenUsed=3D"true" Name=3D"Default Paragraph Font"></w:LsdException>=0A  =
<w:LsdException Locked=3D"false" SemiHidden=3D"true" UnhideWhenUsed=3D"tru=
e"=0A   Name=3D"Body Text"></w:LsdException>=0A  <w:LsdException Locked=3D=
"false" SemiHidden=3D"true" UnhideWhenUsed=3D"true"=0A   Name=3D"Body Text=
 Indent"></w:LsdException>=0A  <w:LsdException Locked=3D"false" SemiHidden=
=3D"true" UnhideWhenUsed=3D"true"=0A   Name=3D"List Continue"></w:LsdExcep=
tion>=0A  <w:LsdException Locked=3D"false" SemiHidden=3D"true" UnhideWhenU=
sed=3D"true"=0A   Name=3D"List Continue 2"></w:LsdException>=0A  <w:LsdExc=
eption Locked=3D"false" SemiHidden=3D"true" UnhideWhenUsed=3D"true"=0A   N=
ame=3D"List Continue 3"></w:LsdException>=0A  <w:LsdException Locked=3D"fa=
lse" SemiHidden=3D"true" UnhideWhenUsed=3D"true"=0A   Name=3D"List Continu=
e 4"></w:LsdException>=0A  <w:LsdException Locked=3D"false" SemiHidden=3D"=
true" UnhideWhenUsed=3D"true"=0A   Name=3D"List Continue 5"></w:LsdExcepti=
on>=0A  <w:LsdException Locked=3D"false" SemiHidden=3D"true" UnhideWhenUse=
d=3D"true"=0A   Name=3D"Message Header"></w:LsdException>=0A  <w:LsdExcept=
ion Locked=3D"false" Priority=3D"11" QFormat=3D"true" Name=3D"Subtitle"></=
w:LsdException>=0A  <w:LsdException Locked=3D"false" SemiHidden=3D"true" U=
nhideWhenUsed=3D"true"=0A   Name=3D"Salutation"></w:LsdException>=0A  <w:L=
sdException Locked=3D"false" SemiHidden=3D"true" UnhideWhenUsed=3D"true"=
=0A   Name=3D"Date"></w:LsdException>=0A  <w:LsdException Locked=3D"false"=
 SemiHidden=3D"true" UnhideWhenUsed=3D"true"=0A   Name=3D"Body Text First =
Indent"></w:LsdException>=0A  <w:LsdException Locked=3D"false" SemiHidden=
=3D"true" UnhideWhenUsed=3D"true"=0A   Name=3D"Body Text First Indent 2"><=
/w:LsdException>=0A  <w:LsdException Locked=3D"false" SemiHidden=3D"true" =
UnhideWhenUsed=3D"true"=0A   Name=3D"Note Heading"></w:LsdException>=0A  <=
w:LsdException Locked=3D"false" SemiHidden=3D"true" UnhideWhenUsed=3D"true=
"=0A   Name=3D"Body Text 2"></w:LsdException>=0A  <w:LsdException Locked=
=3D"false" SemiHidden=3D"true" UnhideWhenUsed=3D"true"=0A   Name=3D"Body T=
ext 3"></w:LsdException>=0A  <w:LsdException Locked=3D"false" SemiHidden=
=3D"true" UnhideWhenUsed=3D"true"=0A   Name=3D"Body Text Indent 2"></w:Lsd=
Exception>=0A  <w:LsdException Locked=3D"false" SemiHidden=3D"true" Unhide=
WhenUsed=3D"true"=0A   Name=3D"Body Text Indent 3"></w:LsdException>=0A  <=
w:LsdException Locked=3D"false" SemiHidden=3D"true" UnhideWhenUsed=3D"true=
"=0A   Name=3D"Block Text"></w:LsdException>=0A  <w:LsdException Locked=3D=
"false" SemiHidden=3D"true" UnhideWhenUsed=3D"true"=0A   Name=3D"Hyperlink=
"></w:LsdException>=0A  <w:LsdException Locked=3D"false" SemiHidden=3D"tru=
e" UnhideWhenUsed=3D"true"=0A   Name=3D"FollowedHyperlink"></w:LsdExceptio=
n>=0A  <w:LsdException Locked=3D"false" Priority=3D"22" QFormat=3D"true" N=
ame=3D"Strong"></w:LsdException>=0A  <w:LsdException Locked=3D"false" Prio=
rity=3D"20" QFormat=3D"true" Name=3D"Emphasis"></w:LsdException>=0A  <w:Ls=
dException Locked=3D"false" SemiHidden=3D"true" UnhideWhenUsed=3D"true"=0A=
   Name=3D"Document Map"></w:LsdException>=0A  <w:LsdException Locked=3D"f=
alse" SemiHidden=3D"true" UnhideWhenUsed=3D"true"=0A   Name=3D"Plain Text"=
></w:LsdException>=0A  <w:LsdException Locked=3D"false" SemiHidden=3D"true=
" UnhideWhenUsed=3D"true"=0A   Name=3D"E-mail Signature"></w:LsdException>=
=0A  <w:LsdException Locked=3D"false" SemiHidden=3D"true" UnhideWhenUsed=
=3D"true"=0A   Name=3D"HTML Top of Form"></w:LsdException>=0A  <w:LsdExcep=
tion Locked=3D"false" SemiHidden=3D"true" UnhideWhenUsed=3D"true"=0A   Nam=
e=3D"HTML Bottom of Form"></w:LsdException>=0A  <w:LsdException Locked=3D"=
false" SemiHidden=3D"true" UnhideWhenUsed=3D"true"=0A   Name=3D"Normal (We=
b)"></w:LsdException>=0A  <w:LsdException Locked=3D"false" SemiHidden=3D"t=
rue" UnhideWhenUsed=3D"true"=0A   Name=3D"HTML Acronym"></w:LsdException>=
=0A  <w:LsdException Locked=3D"false" SemiHidden=3D"true" UnhideWhenUsed=
=3D"true"=0A   Name=3D"HTML Address"></w:LsdException>=0A  <w:LsdException=
 Locked=3D"false" SemiHidden=3D"true" UnhideWhenUsed=3D"true"=0A   Name=3D=
"HTML Cite"></w:LsdException>=0A  <w:LsdException Locked=3D"false" SemiHid=
den=3D"true" UnhideWhenUsed=3D"true"=0A   Name=3D"HTML Code"></w:LsdExcept=
ion>=0A  <w:LsdException Locked=3D"false" SemiHidden=3D"true" UnhideWhenUs=
ed=3D"true"=0A   Name=3D"HTML Definition"></w:LsdException>=0A  <w:LsdExce=
ption Locked=3D"false" SemiHidden=3D"true" UnhideWhenUsed=3D"true"=0A   Na=
me=3D"HTML Keyboard"></w:LsdException>=0A  <w:LsdException Locked=3D"false=
" SemiHidden=3D"true" UnhideWhenUsed=3D"true"=0A   Name=3D"HTML Preformatt=
ed"></w:LsdException>=0A  <w:LsdException Locked=3D"false" SemiHidden=3D"t=
rue" UnhideWhenUsed=3D"true"=0A   Name=3D"HTML Sample"></w:LsdException>=
=0A  <w:LsdException Locked=3D"false" SemiHidden=3D"true" UnhideWhenUsed=
=3D"true"=0A   Name=3D"HTML Typewriter"></w:LsdException>=0A  <w:LsdExcept=
ion Locked=3D"false" SemiHidden=3D"true" UnhideWhenUsed=3D"true"=0A   Name=
=3D"HTML Variable"></w:LsdException>=0A  <w:LsdException Locked=3D"false" =
SemiHidden=3D"true" UnhideWhenUsed=3D"true"=0A   Name=3D"Normal Table"></w=
:LsdException>=0A  <w:LsdException Locked=3D"false" SemiHidden=3D"true" Un=
hideWhenUsed=3D"true"=0A   Name=3D"annotation subject"></w:LsdException>=
=0A  <w:LsdException Locked=3D"false" SemiHidden=3D"true" UnhideWhenUsed=
=3D"true"=0A   Name=3D"No List"></w:LsdException>=0A  <w:LsdException Lock=
ed=3D"false" SemiHidden=3D"true" UnhideWhenUsed=3D"true"=0A   Name=3D"Outl=
ine List 1"></w:LsdException>=0A  <w:LsdException Locked=3D"false" SemiHid=
den=3D"true" UnhideWhenUsed=3D"true"=0A   Name=3D"Outline List 2"></w:LsdE=
xception>=0A  <w:LsdException Locked=3D"false" SemiHidden=3D"true" UnhideW=
henUsed=3D"true"=0A   Name=3D"Outline List 3"></w:LsdException>=0A  <w:Lsd=
Exception Locked=3D"false" SemiHidden=3D"true" UnhideWhenUsed=3D"true"=0A =
  Name=3D"Table Simple 1"></w:LsdException>=0A  <w:LsdException Locked=3D"=
false" SemiHidden=3D"true" UnhideWhenUsed=3D"true"=0A   Name=3D"Table Simp=
le 2"></w:LsdException>=0A  <w:LsdException Locked=3D"false" SemiHidden=3D=
"true" UnhideWhenUsed=3D"true"=0A   Name=3D"Table Simple 3"></w:LsdExcepti=
on>=0A  <w:LsdException Locked=3D"false" SemiHidden=3D"true" UnhideWhenUse=
d=3D"true"=0A   Name=3D"Table Classic 1"></w:LsdException>=0A  <w:LsdExcep=
tion Locked=3D"false" SemiHidden=3D"true" UnhideWhenUsed=3D"true"=0A   Nam=
e=3D"Table Classic 2"></w:LsdException>=0A  <w:LsdException Locked=3D"fals=
e" SemiHidden=3D"true" UnhideWhenUsed=3D"true"=0A   Name=3D"Table Classic =
3"></w:LsdException>=0A  <w:LsdException Locked=3D"false" SemiHidden=3D"tr=
ue" UnhideWhenUsed=3D"true"=0A   Name=3D"Table Classic 4"></w:LsdException=
>=0A  <w:LsdException Locked=3D"false" SemiHidden=3D"true" UnhideWhenUsed=
=3D"true"=0A   Name=3D"Table Colorful 1"></w:LsdException>=0A  <w:LsdExcep=
tion Locked=3D"false" SemiHidden=3D"true" UnhideWhenUsed=3D"true"=0A   Nam=
e=3D"Table Colorful 2"></w:LsdException>=0A  <w:LsdException Locked=3D"fal=
se" SemiHidden=3D"true" UnhideWhenUsed=3D"true"=0A   Name=3D"Table Colorfu=
l 3"></w:LsdException>=0A  <w:LsdException Locked=3D"false" SemiHidden=3D"=
true" UnhideWhenUsed=3D"true"=0A   Name=3D"Table Columns 1"></w:LsdExcepti=
on>=0A  <w:LsdException Locked=3D"false" SemiHidden=3D"true" UnhideWhenUse=
d=3D"true"=0A   Name=3D"Table Columns 2"></w:LsdException>=0A  <w:LsdExcep=
tion Locked=3D"false" SemiHidden=3D"true" UnhideWhenUsed=3D"true"=0A   Nam=
e=3D"Table Columns 3"></w:LsdException>=0A  <w:LsdException Locked=3D"fals=
e" SemiHidden=3D"true" UnhideWhenUsed=3D"true"=0A   Name=3D"Table Columns =
4"></w:LsdException>=0A  <w:LsdException Locked=3D"false" SemiHidden=3D"tr=
ue" UnhideWhenUsed=3D"true"=0A   Name=3D"Table Columns 5"></w:LsdException=
>=0A  <w:LsdException Locked=3D"false" SemiHidden=3D"true" UnhideWhenUsed=
=3D"true"=0A   Name=3D"Table Grid 1"></w:LsdException>=0A  <w:LsdException=
 Locked=3D"false" SemiHidden=3D"true" UnhideWhenUsed=3D"true"=0A   Name=3D=
"Table Grid 2"></w:LsdException>=0A  <w:LsdException Locked=3D"false" Semi=
Hidden=3D"true" UnhideWhenUsed=3D"true"=0A   Name=3D"Table Grid 3"></w:Lsd=
Exception>=0A  <w:LsdException Locked=3D"false" SemiHidden=3D"true" Unhide=
WhenUsed=3D"true"=0A   Name=3D"Table Grid 4"></w:LsdException>=0A  <w:LsdE=
xception Locked=3D"false" SemiHidden=3D"true" UnhideWhenUsed=3D"true"=0A  =
 Name=3D"Table Grid 5"></w:LsdException>=0A  <w:LsdException Locked=3D"fal=
se" SemiHidden=3D"true" UnhideWhenUsed=3D"true"=0A   Name=3D"Table Grid 6"=
></w:LsdException>=0A  <w:LsdException Locked=3D"false" SemiHidden=3D"true=
" UnhideWhenUsed=3D"true"=0A   Name=3D"Table Grid 7"></w:LsdException>=0A =
 <w:LsdException Locked=3D"false" SemiHidden=3D"true" UnhideWhenUsed=3D"tr=
ue"=0A   Name=3D"Table Grid 8"></w:LsdException>=0A  <w:LsdException Locke=
d=3D"false" SemiHidden=3D"true" UnhideWhenUsed=3D"true"=0A   Name=3D"Table=
 List 1"></w:LsdException>=0A  <w:LsdException Locked=3D"false" SemiHidden=
=3D"true" UnhideWhenUsed=3D"true"=0A   Name=3D"Table List 2"></w:LsdExcept=
ion>=0A  <w:LsdException Locked=3D"false" SemiHidden=3D"true" UnhideWhenUs=
ed=3D"true"=0A   Name=3D"Table List 3"></w:LsdException>=0A  <w:LsdExcepti=
on Locked=3D"false" SemiHidden=3D"true" UnhideWhenUsed=3D"true"=0A   Name=
=3D"Table List 4"></w:LsdException>=0A  <w:LsdException Locked=3D"false" S=
emiHidden=3D"true" UnhideWhenUsed=3D"true"=0A   Name=3D"Table List 5"></w:=
LsdException>=0A  <w:LsdException Locked=3D"false" SemiHidden=3D"true" Unh=
ideWhenUsed=3D"true"=0A   Name=3D"Table List 6"></w:LsdException>=0A  <w:L=
sdException Locked=3D"false" SemiHidden=3D"true" UnhideWhenUsed=3D"true"=
=0A   Name=3D"Table List 7"></w:LsdException>=0A  <w:LsdException Locked=
=3D"false" SemiHidden=3D"true" UnhideWhenUsed=3D"true"=0A   Name=3D"Table =
List 8"></w:LsdException>=0A  <w:LsdException Locked=3D"false" SemiHidden=
=3D"true" UnhideWhenUsed=3D"true"=0A   Name=3D"Table 3D effects 1"></w:Lsd=
Exception>=0A  <w:LsdException Locked=3D"false" SemiHidden=3D"true" Unhide=
WhenUsed=3D"true"=0A   Name=3D"Table 3D effects 2"></w:LsdException>=0A  <=
w:LsdException Locked=3D"false" SemiHidden=3D"true" UnhideWhenUsed=3D"true=
"=0A   Name=3D"Table 3D effects 3"></w:LsdException>=0A  <w:LsdException L=
ocked=3D"false" SemiHidden=3D"true" UnhideWhenUsed=3D"true"=0A   Name=3D"T=
able Contemporary"></w:LsdException>=0A  <w:LsdException Locked=3D"false" =
SemiHidden=3D"true" UnhideWhenUsed=3D"true"=0A   Name=3D"Table Elegant"></=
w:LsdException>=0A  <w:LsdException Locked=3D"false" SemiHidden=3D"true" U=
nhideWhenUsed=3D"true"=0A   Name=3D"Table Professional"></w:LsdException>=
=0A  <w:LsdException Locked=3D"false" SemiHidden=3D"true" UnhideWhenUsed=
=3D"true"=0A   Name=3D"Table Subtle 1"></w:LsdException>=0A  <w:LsdExcepti=
on Locked=3D"false" SemiHidden=3D"true" UnhideWhenUsed=3D"true"=0A   Name=
=3D"Table Subtle 2"></w:LsdException>=0A  <w:LsdException Locked=3D"false"=
 SemiHidden=3D"true" UnhideWhenUsed=3D"true"=0A   Name=3D"Table Web 1"></w=
:LsdException>=0A  <w:LsdException Locked=3D"false" SemiHidden=3D"true" Un=
hideWhenUsed=3D"true"=0A   Name=3D"Table Web 2"></w:LsdException>=0A  <w:L=
sdException Locked=3D"false" SemiHidden=3D"true" UnhideWhenUsed=3D"true"=
=0A   Name=3D"Table Web 3"></w:LsdException>=0A  <w:LsdException Locked=3D=
"false" SemiHidden=3D"true" UnhideWhenUsed=3D"true"=0A   Name=3D"Balloon T=
ext"></w:LsdException>=0A  <w:LsdException Locked=3D"false" Priority=3D"39=
" Name=3D"Table Grid"></w:LsdException>=0A  <w:LsdException Locked=3D"fals=
e" SemiHidden=3D"true" UnhideWhenUsed=3D"true"=0A   Name=3D"Table Theme"><=
/w:LsdException>=0A  <w:LsdException Locked=3D"false" SemiHidden=3D"true" =
Name=3D"Placeholder Text"></w:LsdException>=0A  <w:LsdException Locked=3D"=
false" Priority=3D"1" QFormat=3D"true" Name=3D"No Spacing"></w:LsdExceptio=
n>=0A  <w:LsdException Locked=3D"false" Priority=3D"60" Name=3D"Light Shad=
ing"></w:LsdException>=0A  <w:LsdException Locked=3D"false" Priority=3D"61=
" Name=3D"Light List"></w:LsdException>=0A  <w:LsdException Locked=3D"fals=
e" Priority=3D"62" Name=3D"Light Grid"></w:LsdException>=0A  <w:LsdExcepti=
on Locked=3D"false" Priority=3D"63" Name=3D"Medium Shading 1"></w:LsdExcep=
tion>=0A  <w:LsdException Locked=3D"false" Priority=3D"64" Name=3D"Medium =
Shading 2"></w:LsdException>=0A  <w:LsdException Locked=3D"false" Priority=
=3D"65" Name=3D"Medium List 1"></w:LsdException>=0A  <w:LsdException Locke=
d=3D"false" Priority=3D"66" Name=3D"Medium List 2"></w:LsdException>=0A  <=
w:LsdException Locked=3D"false" Priority=3D"67" Name=3D"Medium Grid 1"></w=
:LsdException>=0A  <w:LsdException Locked=3D"false" Priority=3D"68" Name=
=3D"Medium Grid 2"></w:LsdException>=0A  <w:LsdException Locked=3D"false" =
Priority=3D"69" Name=3D"Medium Grid 3"></w:LsdException>=0A  <w:LsdExcepti=
on Locked=3D"false" Priority=3D"70" Name=3D"Dark List"></w:LsdException>=
=0A  <w:LsdException Locked=3D"false" Priority=3D"71" Name=3D"Colorful Sha=
ding"></w:LsdException>=0A  <w:LsdException Locked=3D"false" Priority=3D"7=
2" Name=3D"Colorful List"></w:LsdException>=0A  <w:LsdException Locked=3D"=
false" Priority=3D"73" Name=3D"Colorful Grid"></w:LsdException>=0A  <w:Lsd=
Exception Locked=3D"false" Priority=3D"60" Name=3D"Light Shading Accent 1"=
></w:LsdException>=0A  <w:LsdException Locked=3D"false" Priority=3D"61" Na=
me=3D"Light List Accent 1"></w:LsdException>=0A  <w:LsdException Locked=3D=
"false" Priority=3D"62" Name=3D"Light Grid Accent 1"></w:LsdException>=0A =
 <w:LsdException Locked=3D"false" Priority=3D"63" Name=3D"Medium Shading 1=
 Accent 1"></w:LsdException>=0A  <w:LsdException Locked=3D"false" Priority=
=3D"64" Name=3D"Medium Shading 2 Accent 1"></w:LsdException>=0A  <w:LsdExc=
eption Locked=3D"false" Priority=3D"65" Name=3D"Medium List 1 Accent 1"></=
w:LsdException>=0A  <w:LsdException Locked=3D"false" SemiHidden=3D"true" N=
ame=3D"Revision"></w:LsdException>=0A  <w:LsdException Locked=3D"false" Pr=
iority=3D"34" QFormat=3D"true"=0A   Name=3D"List Paragraph"></w:LsdExcepti=
on>=0A  <w:LsdException Locked=3D"false" Priority=3D"29" QFormat=3D"true" =
Name=3D"Quote"></w:LsdException>=0A  <w:LsdException Locked=3D"false" Prio=
rity=3D"30" QFormat=3D"true"=0A   Name=3D"Intense Quote"></w:LsdException>=
=0A  <w:LsdException Locked=3D"false" Priority=3D"66" Name=3D"Medium List =
2 Accent 1"></w:LsdException>=0A  <w:LsdException Locked=3D"false" Priorit=
y=3D"67" Name=3D"Medium Grid 1 Accent 1"></w:LsdException>=0A  <w:LsdExcep=
tion Locked=3D"false" Priority=3D"68" Name=3D"Medium Grid 2 Accent 1"></w:=
LsdException>=0A  <w:LsdException Locked=3D"false" Priority=3D"69" Name=3D=
"Medium Grid 3 Accent 1"></w:LsdException>=0A  <w:LsdException Locked=3D"f=
alse" Priority=3D"70" Name=3D"Dark List Accent 1"></w:LsdException>=0A  <w=
:LsdException Locked=3D"false" Priority=3D"71" Name=3D"Colorful Shading Ac=
cent 1"></w:LsdException>=0A  <w:LsdException Locked=3D"false" Priority=3D=
"72" Name=3D"Colorful List Accent 1"></w:LsdException>=0A  <w:LsdException=
 Locked=3D"false" Priority=3D"73" Name=3D"Colorful Grid Accent 1"></w:LsdE=
xception>=0A  <w:LsdException Locked=3D"false" Priority=3D"60" Name=3D"Lig=
ht Shading Accent 2"></w:LsdException>=0A  <w:LsdException Locked=3D"false=
" Priority=3D"61" Name=3D"Light List Accent 2"></w:LsdException>=0A  <w:Ls=
dException Locked=3D"false" Priority=3D"62" Name=3D"Light Grid Accent 2"><=
/w:LsdException>=0A  <w:LsdException Locked=3D"false" Priority=3D"63" Name=
=3D"Medium Shading 1 Accent 2"></w:LsdException>=0A  <w:LsdException Locke=
d=3D"false" Priority=3D"64" Name=3D"Medium Shading 2 Accent 2"></w:LsdExce=
ption>=0A  <w:LsdException Locked=3D"false" Priority=3D"65" Name=3D"Medium=
 List 1 Accent 2"></w:LsdException>=0A  <w:LsdException Locked=3D"false" P=
riority=3D"66" Name=3D"Medium List 2 Accent 2"></w:LsdException>=0A  <w:Ls=
dException Locked=3D"false" Priority=3D"67" Name=3D"Medium Grid 1 Accent 2=
"></w:LsdException>=0A  <w:LsdException Locked=3D"false" Priority=3D"68" N=
ame=3D"Medium Grid 2 Accent 2"></w:LsdException>=0A  <w:LsdException Locke=
d=3D"false" Priority=3D"69" Name=3D"Medium Grid 3 Accent 2"></w:LsdExcepti=
on>=0A  <w:LsdException Locked=3D"false" Priority=3D"70" Name=3D"Dark List=
 Accent 2"></w:LsdException>=0A  <w:LsdException Locked=3D"false" Priority=
=3D"71" Name=3D"Colorful Shading Accent 2"></w:LsdException>=0A  <w:LsdExc=
eption Locked=3D"false" Priority=3D"72" Name=3D"Colorful List Accent 2"></=
w:LsdException>=0A  <w:LsdException Locked=3D"false" Priority=3D"73" Name=
=3D"Colorful Grid Accent 2"></w:LsdException>=0A  <w:LsdException Locked=
=3D"false" Priority=3D"60" Name=3D"Light Shading Accent 3"></w:LsdExceptio=
n>=0A  <w:LsdException Locked=3D"false" Priority=3D"61" Name=3D"Light List=
 Accent 3"></w:LsdException>=0A  <w:LsdException Locked=3D"false" Priority=
=3D"62" Name=3D"Light Grid Accent 3"></w:LsdException>=0A  <w:LsdException=
 Locked=3D"false" Priority=3D"63" Name=3D"Medium Shading 1 Accent 3"></w:L=
sdException>=0A  <w:LsdException Locked=3D"false" Priority=3D"64" Name=3D"=
Medium Shading 2 Accent 3"></w:LsdException>=0A  <w:LsdException Locked=3D=
"false" Priority=3D"65" Name=3D"Medium List 1 Accent 3"></w:LsdException>=
=0A  <w:LsdException Locked=3D"false" Priority=3D"66" Name=3D"Medium List =
2 Accent 3"></w:LsdException>=0A  <w:LsdException Locked=3D"false" Priorit=
y=3D"67" Name=3D"Medium Grid 1 Accent 3"></w:LsdException>=0A  <w:LsdExcep=
tion Locked=3D"false" Priority=3D"68" Name=3D"Medium Grid 2 Accent 3"></w:=
LsdException>=0A  <w:LsdException Locked=3D"false" Priority=3D"69" Name=3D=
"Medium Grid 3 Accent 3"></w:LsdException>=0A  <w:LsdException Locked=3D"f=
alse" Priority=3D"70" Name=3D"Dark List Accent 3"></w:LsdException>=0A  <w=
:LsdException Locked=3D"false" Priority=3D"71" Name=3D"Colorful Shading Ac=
cent 3"></w:LsdException>=0A  <w:LsdException Locked=3D"false" Priority=3D=
"72" Name=3D"Colorful List Accent 3"></w:LsdException>=0A  <w:LsdException=
 Locked=3D"false" Priority=3D"73" Name=3D"Colorful Grid Accent 3"></w:LsdE=
xception>=0A  <w:LsdException Locked=3D"false" Priority=3D"60" Name=3D"Lig=
ht Shading Accent 4"></w:LsdException>=0A  <w:LsdException Locked=3D"false=
" Priority=3D"61" Name=3D"Light List Accent 4"></w:LsdException>=0A  <w:Ls=
dException Locked=3D"false" Priority=3D"62" Name=3D"Light Grid Accent 4"><=
/w:LsdException>=0A  <w:LsdException Locked=3D"false" Priority=3D"63" Name=
=3D"Medium Shading 1 Accent 4"></w:LsdException>=0A  <w:LsdException Locke=
d=3D"false" Priority=3D"64" Name=3D"Medium Shading 2 Accent 4"></w:LsdExce=
ption>=0A  <w:LsdException Locked=3D"false" Priority=3D"65" Name=3D"Medium=
 List 1 Accent 4"></w:LsdException>=0A  <w:LsdException Locked=3D"false" P=
riority=3D"66" Name=3D"Medium List 2 Accent 4"></w:LsdException>=0A  <w:Ls=
dException Locked=3D"false" Priority=3D"67" Name=3D"Medium Grid 1 Accent 4=
"></w:LsdException>=0A  <w:LsdException Locked=3D"false" Priority=3D"68" N=
ame=3D"Medium Grid 2 Accent 4"></w:LsdException>=0A  <w:LsdException Locke=
d=3D"false" Priority=3D"69" Name=3D"Medium Grid 3 Accent 4"></w:LsdExcepti=
on>=0A  <w:LsdException Locked=3D"false" Priority=3D"70" Name=3D"Dark List=
 Accent 4"></w:LsdException>=0A  <w:LsdException Locked=3D"false" Priority=
=3D"71" Name=3D"Colorful Shading Accent 4"></w:LsdException>=0A  <w:LsdExc=
eption Locked=3D"false" Priority=3D"72" Name=3D"Colorful List Accent 4"></=
w:LsdException>=0A  <w:LsdException Locked=3D"false" Priority=3D"73" Name=
=3D"Colorful Grid Accent 4"></w:LsdException>=0A  <w:LsdException Locked=
=3D"false" Priority=3D"60" Name=3D"Light Shading Accent 5"></w:LsdExceptio=
n>=0A  <w:LsdException Locked=3D"false" Priority=3D"61" Name=3D"Light List=
 Accent 5"></w:LsdException>=0A  <w:LsdException Locked=3D"false" Priority=
=3D"62" Name=3D"Light Grid Accent 5"></w:LsdException>=0A  <w:LsdException=
 Locked=3D"false" Priority=3D"63" Name=3D"Medium Shading 1 Accent 5"></w:L=
sdException>=0A  <w:LsdException Locked=3D"false" Priority=3D"64" Name=3D"=
Medium Shading 2 Accent 5"></w:LsdException>=0A  <w:LsdException Locked=3D=
"false" Priority=3D"65" Name=3D"Medium List 1 Accent 5"></w:LsdException>=
=0A  <w:LsdException Locked=3D"false" Priority=3D"66" Name=3D"Medium List =
2 Accent 5"></w:LsdException>=0A  <w:LsdException Locked=3D"false" Priorit=
y=3D"67" Name=3D"Medium Grid 1 Accent 5"></w:LsdException>=0A  <w:LsdExcep=
tion Locked=3D"false" Priority=3D"68" Name=3D"Medium Grid 2 Accent 5"></w:=
LsdException>=0A  <w:LsdException Locked=3D"false" Priority=3D"69" Name=3D=
"Medium Grid 3 Accent 5"></w:LsdException>=0A  <w:LsdException Locked=3D"f=
alse" Priority=3D"70" Name=3D"Dark List Accent 5"></w:LsdException>=0A  <w=
:LsdException Locked=3D"false" Priority=3D"71" Name=3D"Colorful Shading Ac=
cent 5"></w:LsdException>=0A  <w:LsdException Locked=3D"false" Priority=3D=
"72" Name=3D"Colorful List Accent 5"></w:LsdException>=0A  <w:LsdException=
 Locked=3D"false" Priority=3D"73" Name=3D"Colorful Grid Accent 5"></w:LsdE=
xception>=0A  <w:LsdException Locked=3D"false" Priority=3D"60" Name=3D"Lig=
ht Shading Accent 6"></w:LsdException>=0A  <w:LsdException Locked=3D"false=
" Priority=3D"61" Name=3D"Light List Accent 6"></w:LsdException>=0A  <w:Ls=
dException Locked=3D"false" Priority=3D"62" Name=3D"Light Grid Accent 6"><=
/w:LsdException>=0A  <w:LsdException Locked=3D"false" Priority=3D"63" Name=
=3D"Medium Shading 1 Accent 6"></w:LsdException>=0A  <w:LsdException Locke=
d=3D"false" Priority=3D"64" Name=3D"Medium Shading 2 Accent 6"></w:LsdExce=
ption>=0A  <w:LsdException Locked=3D"false" Priority=3D"65" Name=3D"Medium=
 List 1 Accent 6"></w:LsdException>=0A  <w:LsdException Locked=3D"false" P=
riority=3D"66" Name=3D"Medium List 2 Accent 6"></w:LsdException>=0A  <w:Ls=
dException Locked=3D"false" Priority=3D"67" Name=3D"Medium Grid 1 Accent 6=
"></w:LsdException>=0A  <w:LsdException Locked=3D"false" Priority=3D"68" N=
ame=3D"Medium Grid 2 Accent 6"></w:LsdException>=0A  <w:LsdException Locke=
d=3D"false" Priority=3D"69" Name=3D"Medium Grid 3 Accent 6"></w:LsdExcepti=
on>=0A  <w:LsdException Locked=3D"false" Priority=3D"70" Name=3D"Dark List=
 Accent 6"></w:LsdException>=0A  <w:LsdException Locked=3D"false" Priority=
=3D"71" Name=3D"Colorful Shading Accent 6"></w:LsdException>=0A  <w:LsdExc=
eption Locked=3D"false" Priority=3D"72" Name=3D"Colorful List Accent 6"></=
w:LsdException>=0A  <w:LsdException Locked=3D"false" Priority=3D"73" Name=
=3D"Colorful Grid Accent 6"></w:LsdException>=0A  <w:LsdException Locked=
=3D"false" Priority=3D"19" QFormat=3D"true"=0A   Name=3D"Subtle Emphasis">=
</w:LsdException>=0A  <w:LsdException Locked=3D"false" Priority=3D"21" QFo=
rmat=3D"true"=0A   Name=3D"Intense Emphasis"></w:LsdException>=0A  <w:LsdE=
xception Locked=3D"false" Priority=3D"31" QFormat=3D"true"=0A   Name=3D"Su=
btle Reference"></w:LsdException>=0A  <w:LsdException Locked=3D"false" Pri=
ority=3D"32" QFormat=3D"true"=0A   Name=3D"Intense Reference"></w:LsdExcep=
tion>=0A  <w:LsdException Locked=3D"false" Priority=3D"33" QFormat=3D"true=
" Name=3D"Book Title"></w:LsdException>=0A  <w:LsdException Locked=3D"fals=
e" Priority=3D"37" SemiHidden=3D"true"=0A   UnhideWhenUsed=3D"true" Name=
=3D"Bibliography"></w:LsdException>=0A  <w:LsdException Locked=3D"false" P=
riority=3D"39" SemiHidden=3D"true"=0A   UnhideWhenUsed=3D"true" QFormat=3D=
"true" Name=3D"TOC Heading"></w:LsdException>=0A  <w:LsdException Locked=
=3D"false" Priority=3D"41" Name=3D"Plain Table 1"></w:LsdException>=0A  <w=
:LsdException Locked=3D"false" Priority=3D"42" Name=3D"Plain Table 2"></w:=
LsdException>=0A  <w:LsdException Locked=3D"false" Priority=3D"43" Name=3D=
"Plain Table 3"></w:LsdException>=0A  <w:LsdException Locked=3D"false" Pri=
ority=3D"44" Name=3D"Plain Table 4"></w:LsdException>=0A  <w:LsdException =
Locked=3D"false" Priority=3D"45" Name=3D"Plain Table 5"></w:LsdException>=
=0A  <w:LsdException Locked=3D"false" Priority=3D"40" Name=3D"Grid Table L=
ight"></w:LsdException>=0A  <w:LsdException Locked=3D"false" Priority=3D"4=
6" Name=3D"Grid Table 1 Light"></w:LsdException>=0A  <w:LsdException Locke=
d=3D"false" Priority=3D"47" Name=3D"Grid Table 2"></w:LsdException>=0A  <w=
:LsdException Locked=3D"false" Priority=3D"48" Name=3D"Grid Table 3"></w:L=
sdException>=0A  <w:LsdException Locked=3D"false" Priority=3D"49" Name=3D"=
Grid Table 4"></w:LsdException>=0A  <w:LsdException Locked=3D"false" Prior=
ity=3D"50" Name=3D"Grid Table 5 Dark"></w:LsdException>=0A  <w:LsdExceptio=
n Locked=3D"false" Priority=3D"51" Name=3D"Grid Table 6 Colorful"></w:LsdE=
xception>=0A  <w:LsdException Locked=3D"false" Priority=3D"52" Name=3D"Gri=
d Table 7 Colorful"></w:LsdException>=0A  <w:LsdException Locked=3D"false"=
 Priority=3D"46"=0A   Name=3D"Grid Table 1 Light Accent 1"></w:LsdExceptio=
n>=0A  <w:LsdException Locked=3D"false" Priority=3D"47" Name=3D"Grid Table=
 2 Accent 1"></w:LsdException>=0A  <w:LsdException Locked=3D"false" Priori=
ty=3D"48" Name=3D"Grid Table 3 Accent 1"></w:LsdException>=0A  <w:LsdExcep=
tion Locked=3D"false" Priority=3D"49" Name=3D"Grid Table 4 Accent 1"></w:L=
sdException>=0A  <w:LsdException Locked=3D"false" Priority=3D"50" Name=3D"=
Grid Table 5 Dark Accent 1"></w:LsdException>=0A  <w:LsdException Locked=
=3D"false" Priority=3D"51"=0A   Name=3D"Grid Table 6 Colorful Accent 1"></=
w:LsdException>=0A  <w:LsdException Locked=3D"false" Priority=3D"52"=0A   =
Name=3D"Grid Table 7 Colorful Accent 1"></w:LsdException>=0A  <w:LsdExcept=
ion Locked=3D"false" Priority=3D"46"=0A   Name=3D"Grid Table 1 Light Accen=
t 2"></w:LsdException>=0A  <w:LsdException Locked=3D"false" Priority=3D"47=
" Name=3D"Grid Table 2 Accent 2"></w:LsdException>=0A  <w:LsdException Loc=
ked=3D"false" Priority=3D"48" Name=3D"Grid Table 3 Accent 2"></w:LsdExcept=
ion>=0A  <w:LsdException Locked=3D"false" Priority=3D"49" Name=3D"Grid Tab=
le 4 Accent 2"></w:LsdException>=0A  <w:LsdException Locked=3D"false" Prio=
rity=3D"50" Name=3D"Grid Table 5 Dark Accent 2"></w:LsdException>=0A  <w:L=
sdException Locked=3D"false" Priority=3D"51"=0A   Name=3D"Grid Table 6 Col=
orful Accent 2"></w:LsdException>=0A  <w:LsdException Locked=3D"false" Pri=
ority=3D"52"=0A   Name=3D"Grid Table 7 Colorful Accent 2"></w:LsdException=
>=0A  <w:LsdException Locked=3D"false" Priority=3D"46"=0A   Name=3D"Grid T=
able 1 Light Accent 3"></w:LsdException>=0A  <w:LsdException Locked=3D"fal=
se" Priority=3D"47" Name=3D"Grid Table 2 Accent 3"></w:LsdException>=0A  <=
w:LsdException Locked=3D"false" Priority=3D"48" Name=3D"Grid Table 3 Accen=
t 3"></w:LsdException>=0A  <w:LsdException Locked=3D"false" Priority=3D"49=
" Name=3D"Grid Table 4 Accent 3"></w:LsdException>=0A  <w:LsdException Loc=
ked=3D"false" Priority=3D"50" Name=3D"Grid Table 5 Dark Accent 3"></w:LsdE=
xception>=0A  <w:LsdException Locked=3D"false" Priority=3D"51"=0A   Name=
=3D"Grid Table 6 Colorful Accent 3"></w:LsdException>=0A  <w:LsdException =
Locked=3D"false" Priority=3D"52"=0A   Name=3D"Grid Table 7 Colorful Accent=
 3"></w:LsdException>=0A  <w:LsdException Locked=3D"false" Priority=3D"46"=
=0A   Name=3D"Grid Table 1 Light Accent 4"></w:LsdException>=0A  <w:LsdExc=
eption Locked=3D"false" Priority=3D"47" Name=3D"Grid Table 2 Accent 4"></w=
:LsdException>=0A  <w:LsdException Locked=3D"false" Priority=3D"48" Name=
=3D"Grid Table 3 Accent 4"></w:LsdException>=0A  <w:LsdException Locked=3D=
"false" Priority=3D"49" Name=3D"Grid Table 4 Accent 4"></w:LsdException>=
=0A  <w:LsdException Locked=3D"false" Priority=3D"50" Name=3D"Grid Table 5=
 Dark Accent 4"></w:LsdException>=0A  <w:LsdException Locked=3D"false" Pri=
ority=3D"51"=0A   Name=3D"Grid Table 6 Colorful Accent 4"></w:LsdException=
>=0A  <w:LsdException Locked=3D"false" Priority=3D"52"=0A   Name=3D"Grid T=
able 7 Colorful Accent 4"></w:LsdException>=0A  <w:LsdException Locked=3D"=
false" Priority=3D"46"=0A   Name=3D"Grid Table 1 Light Accent 5"></w:LsdEx=
ception>=0A  <w:LsdException Locked=3D"false" Priority=3D"47" Name=3D"Grid=
 Table 2 Accent 5"></w:LsdException>=0A  <w:LsdException Locked=3D"false" =
Priority=3D"48" Name=3D"Grid Table 3 Accent 5"></w:LsdException>=0A  <w:Ls=
dException Locked=3D"false" Priority=3D"49" Name=3D"Grid Table 4 Accent 5"=
></w:LsdException>=0A  <w:LsdException Locked=3D"false" Priority=3D"50" Na=
me=3D"Grid Table 5 Dark Accent 5"></w:LsdException>=0A  <w:LsdException Lo=
cked=3D"false" Priority=3D"51"=0A   Name=3D"Grid Table 6 Colorful Accent 5=
"></w:LsdException>=0A  <w:LsdException Locked=3D"false" Priority=3D"52"=
=0A   Name=3D"Grid Table 7 Colorful Accent 5"></w:LsdException>=0A  <w:Lsd=
Exception Locked=3D"false" Priority=3D"46"=0A   Name=3D"Grid Table 1 Light=
 Accent 6"></w:LsdException>=0A  <w:LsdException Locked=3D"false" Priority=
=3D"47" Name=3D"Grid Table 2 Accent 6"></w:LsdException>=0A  <w:LsdExcepti=
on Locked=3D"false" Priority=3D"48" Name=3D"Grid Table 3 Accent 6"></w:Lsd=
Exception>=0A  <w:LsdException Locked=3D"false" Priority=3D"49" Name=3D"Gr=
id Table 4 Accent 6"></w:LsdException>=0A  <w:LsdException Locked=3D"false=
" Priority=3D"50" Name=3D"Grid Table 5 Dark Accent 6"></w:LsdException>=0A=
  <w:LsdException Locked=3D"false" Priority=3D"51"=0A   Name=3D"Grid Table=
 6 Colorful Accent 6"></w:LsdException>=0A  <w:LsdException Locked=3D"fals=
e" Priority=3D"52"=0A   Name=3D"Grid Table 7 Colorful Accent 6"></w:LsdExc=
eption>=0A  <w:LsdException Locked=3D"false" Priority=3D"46" Name=3D"List =
Table 1 Light"></w:LsdException>=0A  <w:LsdException Locked=3D"false" Prio=
rity=3D"47" Name=3D"List Table 2"></w:LsdException>=0A  <w:LsdException Lo=
cked=3D"false" Priority=3D"48" Name=3D"List Table 3"></w:LsdException>=0A =
 <w:LsdException Locked=3D"false" Priority=3D"49" Name=3D"List Table 4"></=
w:LsdException>=0A  <w:LsdException Locked=3D"false" Priority=3D"50" Name=
=3D"List Table 5 Dark"></w:LsdException>=0A  <w:LsdException Locked=3D"fal=
se" Priority=3D"51" Name=3D"List Table 6 Colorful"></w:LsdException>=0A  <=
w:LsdException Locked=3D"false" Priority=3D"52" Name=3D"List Table 7 Color=
ful"></w:LsdException>=0A  <w:LsdException Locked=3D"false" Priority=3D"46=
"=0A   Name=3D"List Table 1 Light Accent 1"></w:LsdException>=0A  <w:LsdEx=
ception Locked=3D"false" Priority=3D"47" Name=3D"List Table 2 Accent 1"></=
w:LsdException>=0A  <w:LsdException Locked=3D"false" Priority=3D"48" Name=
=3D"List Table 3 Accent 1"></w:LsdException>=0A  <w:LsdException Locked=3D=
"false" Priority=3D"49" Name=3D"List Table 4 Accent 1"></w:LsdException>=
=0A  <w:LsdException Locked=3D"false" Priority=3D"50" Name=3D"List Table 5=
 Dark Accent 1"></w:LsdException>=0A  <w:LsdException Locked=3D"false" Pri=
ority=3D"51"=0A   Name=3D"List Table 6 Colorful Accent 1"></w:LsdException=
>=0A  <w:LsdException Locked=3D"false" Priority=3D"52"=0A   Name=3D"List T=
able 7 Colorful Accent 1"></w:LsdException>=0A  <w:LsdException Locked=3D"=
false" Priority=3D"46"=0A   Name=3D"List Table 1 Light Accent 2"></w:LsdEx=
ception>=0A  <w:LsdException Locked=3D"false" Priority=3D"47" Name=3D"List=
 Table 2 Accent 2"></w:LsdException>=0A  <w:LsdException Locked=3D"false" =
Priority=3D"48" Name=3D"List Table 3 Accent 2"></w:LsdException>=0A  <w:Ls=
dException Locked=3D"false" Priority=3D"49" Name=3D"List Table 4 Accent 2"=
></w:LsdException>=0A  <w:LsdException Locked=3D"false" Priority=3D"50" Na=
me=3D"List Table 5 Dark Accent 2"></w:LsdException>=0A  <w:LsdException Lo=
cked=3D"false" Priority=3D"51"=0A   Name=3D"List Table 6 Colorful Accent 2=
"></w:LsdException>=0A  <w:LsdException Locked=3D"false" Priority=3D"52"=
=0A   Name=3D"List Table 7 Colorful Accent 2"></w:LsdException>=0A  <w:Lsd=
Exception Locked=3D"false" Priority=3D"46"=0A   Name=3D"List Table 1 Light=
 Accent 3"></w:LsdException>=0A  <w:LsdException Locked=3D"false" Priority=
=3D"47" Name=3D"List Table 2 Accent 3"></w:LsdException>=0A  <w:LsdExcepti=
on Locked=3D"false" Priority=3D"48" Name=3D"List Table 3 Accent 3"></w:Lsd=
Exception>=0A  <w:LsdException Locked=3D"false" Priority=3D"49" Name=3D"Li=
st Table 4 Accent 3"></w:LsdException>=0A  <w:LsdException Locked=3D"false=
" Priority=3D"50" Name=3D"List Table 5 Dark Accent 3"></w:LsdException>=0A=
  <w:LsdException Locked=3D"false" Priority=3D"51"=0A   Name=3D"List Table=
 6 Colorful Accent 3"></w:LsdException>=0A  <w:LsdException Locked=3D"fals=
e" Priority=3D"52"=0A   Name=3D"List Table 7 Colorful Accent 3"></w:LsdExc=
eption>=0A  <w:LsdException Locked=3D"false" Priority=3D"46"=0A   Name=3D"=
List Table 1 Light Accent 4"></w:LsdException>=0A  <w:LsdException Locked=
=3D"false" Priority=3D"47" Name=3D"List Table 2 Accent 4"></w:LsdException=
>=0A  <w:LsdException Locked=3D"false" Priority=3D"48" Name=3D"List Table =
3 Accent 4"></w:LsdException>=0A  <w:LsdException Locked=3D"false" Priorit=
y=3D"49" Name=3D"List Table 4 Accent 4"></w:LsdException>=0A  <w:LsdExcept=
ion Locked=3D"false" Priority=3D"50" Name=3D"List Table 5 Dark Accent 4"><=
/w:LsdException>=0A  <w:LsdException Locked=3D"false" Priority=3D"51"=0A  =
 Name=3D"List Table 6 Colorful Accent 4"></w:LsdException>=0A  <w:LsdExcep=
tion Locked=3D"false" Priority=3D"52"=0A   Name=3D"List Table 7 Colorful A=
ccent 4"></w:LsdException>=0A  <w:LsdException Locked=3D"false" Priority=
=3D"46"=0A   Name=3D"List Table 1 Light Accent 5"></w:LsdException>=0A  <w=
:LsdException Locked=3D"false" Priority=3D"47" Name=3D"List Table 2 Accent=
 5"></w:LsdException>=0A  <w:LsdException Locked=3D"false" Priority=3D"48"=
 Name=3D"List Table 3 Accent 5"></w:LsdException>=0A  <w:LsdException Lock=
ed=3D"false" Priority=3D"49" Name=3D"List Table 4 Accent 5"></w:LsdExcepti=
on>=0A  <w:LsdException Locked=3D"false" Priority=3D"50" Name=3D"List Tabl=
e 5 Dark Accent 5"></w:LsdException>=0A  <w:LsdException Locked=3D"false" =
Priority=3D"51"=0A   Name=3D"List Table 6 Colorful Accent 5"></w:LsdExcept=
ion>=0A  <w:LsdException Locked=3D"false" Priority=3D"52"=0A   Name=3D"Lis=
t Table 7 Colorful Accent 5"></w:LsdException>=0A  <w:LsdException Locked=
=3D"false" Priority=3D"46"=0A   Name=3D"List Table 1 Light Accent 6"></w:L=
sdException>=0A  <w:LsdException Locked=3D"false" Priority=3D"47" Name=3D"=
List Table 2 Accent 6"></w:LsdException>=0A  <w:LsdException Locked=3D"fal=
se" Priority=3D"48" Name=3D"List Table 3 Accent 6"></w:LsdException>=0A  <=
w:LsdException Locked=3D"false" Priority=3D"49" Name=3D"List Table 4 Accen=
t 6"></w:LsdException>=0A  <w:LsdException Locked=3D"false" Priority=3D"50=
" Name=3D"List Table 5 Dark Accent 6"></w:LsdException>=0A  <w:LsdExceptio=
n Locked=3D"false" Priority=3D"51"=0A   Name=3D"List Table 6 Colorful Acce=
nt 6"></w:LsdException>=0A  <w:LsdException Locked=3D"false" Priority=3D"5=
2"=0A   Name=3D"List Table 7 Colorful Accent 6"></w:LsdException>=0A  <w:L=
sdException Locked=3D"false" SemiHidden=3D"true" UnhideWhenUsed=3D"true"=
=0A   Name=3D"Mention"></w:LsdException>=0A  <w:LsdException Locked=3D"fal=
se" SemiHidden=3D"true" UnhideWhenUsed=3D"true"=0A   Name=3D"Smart Hyperli=
nk"></w:LsdException>=0A  <w:LsdException Locked=3D"false" SemiHidden=3D"t=
rue" UnhideWhenUsed=3D"true"=0A   Name=3D"Hashtag"></w:LsdException>=0A  <=
w:LsdException Locked=3D"false" SemiHidden=3D"true" UnhideWhenUsed=3D"true=
"=0A   Name=3D"Unresolved Mention"></w:LsdException>=0A </w:LatentStyles>=
=0A</xml><![endif]-->=0A<!--[if gte mso 10]>=0A<style>=0A /* Style Definit=
ions */=0A table.MsoNormalTable=0A	{mso-style-name:=C6=D5=CD=A8=B1=ED=B8=
=F1;=0A	mso-tstyle-rowband-size:0;=0A	mso-tstyle-colband-size:0;=0A	mso-st=
yle-noshow:yes;=0A	mso-style-priority:99;=0A	mso-style-parent:"";=0A	mso-p=
adding-alt:0cm 5.4pt 0cm 5.4pt;=0A	mso-para-margin:0cm;=0A	mso-para-margin=
-bottom:.0001pt;=0A	mso-pagination:widow-orphan;=0A	font-size:10.0pt;=0A	f=
ont-family:"Times New Roman",serif;}=0A</style>=0A<![endif]-->=0A<!--Start=
Fragment-->=0A<p class=3D"MsoNormal" style=3D"margin: 0cm 0cm 0.0001pt; li=
ne-height: 16pt; background-image: initial; background-position: initial; =
background-size: initial; background-repeat: initial; background-attachmen=
t: initial; background-origin: initial; background-clip: initial; text-ali=
gn: justify;"><font color=3D"#969696" face=3D"Arial, sans-serif"><span sty=
le=3D"font-size: 12px;">Best Regards,</span></font></p><p class=3D"MsoNorm=
al" style=3D"margin: 0cm 0cm 0.0001pt; line-height: 16pt; background-image=
: initial; background-position: initial; background-size: initial; backgro=
und-repeat: initial; background-attachment: initial; background-origin: in=
itial; background-clip: initial; text-align: justify;"><font color=3D"#969=
696" face=3D"Arial, sans-serif"><span style=3D"font-size: 12px;">Li Ying ,=
 Light Storage Group.&nbsp; Senior Embedded Software Engineer</span></font=
></p><p class=3D"MsoNormal" style=3D"margin: 0cm 0cm 0.0001pt; line-height=
: 16pt; background-image: initial; background-position: initial; backgroun=
d-size: initial; background-repeat: initial; background-attachment: initia=
l; background-origin: initial; background-clip: initial; text-align: justi=
fy;"><font color=3D"#969696" face=3D"Arial, sans-serif"><span style=3D"fon=
t-size: 12px;">Tel: -=A3=BB Fax: -</span></font></p><p class=3D"MsoNormal"=
 style=3D"margin: 0cm 0cm 0.0001pt; line-height: 16pt; background-image: i=
nitial; background-position: initial; background-size: initial; background=
-repeat: initial; background-attachment: initial; background-origin: initi=
al; background-clip: initial; text-align: justify;"><font color=3D"#969696=
" face=3D"Arial, sans-serif"><span style=3D"font-size: 12px;">Mobile: +86-=
15651963981</span></font></p><p class=3D"MsoNormal" style=3D"margin: 0cm 0=
cm 0.0001pt; line-height: 16pt; background-image: initial; background-posi=
tion: initial; background-size: initial; background-repeat: initial; backg=
round-attachment: initial; background-origin: initial; background-clip: in=
itial; text-align: justify;"><font color=3D"#969696" face=3D"Arial, sans-s=
erif"><span style=3D"font-size: 12px;">liying3@sungrowpower.com&nbsp;</spa=
n></font></p><p class=3D"MsoNormal" style=3D"margin: 0cm 0cm 0.0001pt; lin=
e-height: 16pt; background-image: initial; background-position: initial; b=
ackground-size: initial; background-repeat: initial; background-attachment=
: initial; background-origin: initial; background-clip: initial; text-alig=
n: justify;"><font color=3D"#969696" face=3D"Arial, sans-serif"><span styl=
e=3D"font-size: 12px;">www.sungrowpower.com</span></font></p><p class=3D"M=
soNormal" style=3D"margin: 0cm 0cm 0.0001pt; line-height: 16pt; background=
-image: initial; background-position: initial; background-size: initial; b=
ackground-repeat: initial; background-attachment: initial; background-orig=
in: initial; background-clip: initial; text-align: justify;"><font color=
=3D"#969696" face=3D"Arial, sans-serif"><span style=3D"font-size: 12px;">S=
UNGROW POWER SUPPLY Co., Ltd.&nbsp;</span></font></p><p class=3D"MsoNormal=
" style=3D"margin: 0cm 0cm 0.0001pt; line-height: 16pt; background-image: =
initial; background-position: initial; background-size: initial; backgroun=
d-repeat: initial; background-attachment: initial; background-origin: init=
ial; background-clip: initial; text-align: justify;"><font color=3D"#96969=
6" face=3D"Arial, sans-serif"><span style=3D"font-size: 12px;">Add: No.169=
9 Xiyou Rd., New &amp; High Technology Industrial Development Zone, Hefei,=
 P. R. China., 230088</span></font></p><p class=3D"MsoNormal" align=3D"lef=
t" style=3D"font-size: 10.5pt; font-family: &quot;Times New Roman&quot;, s=
erif; margin: 0cm 0cm 0.0001pt; text-align: justify; line-height: 15pt;"><=
!--EndFragment--></p></div></span></div>=0A</body></html>
------=_001_NextPart311561431666_=------
akpm@linux-foundation.org;linux-mm@kvack.org;linux-kernel@vger.kernel.org;victor7q@163.com;


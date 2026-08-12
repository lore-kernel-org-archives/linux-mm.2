Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8278DC5B56A
	for <linux-mm@archiver.kernel.org>; Wed, 12 Aug 2026 09:33:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7065F6B00D9; Wed, 12 Aug 2026 05:33:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6B6896B00EA; Wed, 12 Aug 2026 05:33:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5CC256B00EB; Wed, 12 Aug 2026 05:33:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 291EE6B00D9
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 05:33:26 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id B0ED91C01E7
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 09:33:25 +0000 (UTC)
X-FDA: 85092104370.22.C6BA6EC
Received: from m16.mail.163.com (m16.mail.163.com [117.135.210.4])
	by imf30.hostedemail.com (Postfix) with ESMTP id 8528E80005
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 09:33:22 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b="q GdZ/nU";
	spf=pass (imf30.hostedemail.com: domain of liuqiangneo@163.com designates 117.135.210.4 as permitted sender) smtp.mailfrom=liuqiangneo@163.com;
	dmarc=pass (policy=none) header.from=163.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786527203;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fXsqFsUl/261Fe7lZqTMd8C6ZXZ+LetnDxGPsYaO2Lw=;
	b=xSfB8TRf2DwO11fIueITvIFPy0KWWxYpGcZzp+ouQbYAh3duA4kGtkYwW1MS5fd5MPuTwW
	pBwYbRcCIbohXCHyr4TizxDVjnMhuT6xw/Ty1T2o27ei6SCKpxsJQSUVREgr7hs1R8a3m8
	6ebzPwmqIR2WTOA9xNMz3ag3ODZKPtU=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b="q GdZ/nU";
	spf=pass (imf30.hostedemail.com: domain of liuqiangneo@163.com designates 117.135.210.4 as permitted sender) smtp.mailfrom=liuqiangneo@163.com;
	dmarc=pass (policy=none) header.from=163.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786527203;
	b=ObVlkJK0HVB+TGbnheA64WKkrTI1NzkIOeH5sZMjyz03clUQ8zw4nrEmvvuxHjLtT/4dGX
	fDDwMmYT0PlXpbtKPKiCs4dekcsKpmAgUVXBjUg9BNDMvMk7Q/KK4hH1QB8AnsHqALVZPi
	ijHykPMWO6DoMcaeWW+n0xGqikpiHmk=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=Date:From:To:Subject:Content-Type:MIME-Version:
	Message-ID; bh=fXsqFsUl/261Fe7lZqTMd8C6ZXZ+LetnDxGPsYaO2Lw=; b=q
	GdZ/nUqH4xw34+3bZNtJyTHo+KQZI7HbZ+JYSXiM7nmLNj9RwFR9JkaiC0T6BEcW
	Tbe58kD7HCZAlEW6ZUpbFGCHFloxo1ZGCwvtDRufO88dJRGW6+Gl0okjDW3j4WnY
	ZcAcz7UxgZQRUmgiNU+8VHs20bscTuILsXd/QuoOoA=
Received: from liuqiangneo$163.com ( [116.128.244.169] ) by
 ajax-webmail-wmsvr-40-137 (Coremail) ; Wed, 12 Aug 2026 17:33:06 +0800
 (CST)
X-Originating-IP: [116.128.244.169]
Date: Wed, 12 Aug 2026 17:33:06 +0800 (CST)
From: =?GBK?B?wfXHvyA=?= <liuqiangneo@163.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
Cc: jgg@ziepe.ca, leon@kernel.org, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, "Qiang Liu" <liuqiang@kylinos.cn>
Subject: Re:Re: [PATCH] lib/test_hmm: fix NULL deref and wrong direction in
 devmem fault debug message
X-Priority: 3
X-Mailer: Coremail Webmail Server Version 2023.4-cmXT build
 20260511(2e539873) Copyright (c) 2002-2026 www.mailtech.cn 163com
In-Reply-To: <20260811182440.79cf147171dc7f87762a949d@linux-foundation.org>
References: <20260811092256.102101-1-liuqiangneo@163.com>
 <20260811182440.79cf147171dc7f87762a949d@linux-foundation.org>
X-NTES-SC: AL_Qu2TBPmZuEkj4CmaYukcmkgRge48XcqxuPwk1Ydec9MFlCX0xSsnVGFMOHDa/du2JS20kwGYdBlw58N7eJtH96cfkAzuicCzOmVmSwdtHg==
Content-Type: multipart/alternative; 
	boundary="----=_Part_111827_1436578456.1786527186935"
MIME-Version: 1.0
Message-ID: <239a88d4.73b3.19ff5517ff8.Coremail.liuqiangneo@163.com>
X-Coremail-Locale: zh_CN
X-CM-TRANSID:iSgvCgDnL9zTPXxqZmkwAA--.6573W
X-CM-SenderInfo: 5olx1xxdqj0vrr6rljoofrz/xtbC4BI9nmp8PdLD5wAA3M
X-Coremail-Antispam: 1U5529EdanIXcx71UUUUU7vcSsGvfC2KfnxnUU==
X-Stat-Signature: 1bcp8od4kp5jjsnf4wmby4c46awwyha9
X-Rspamd-Queue-Id: 8528E80005
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1786527202-755077
X-HE-Meta: U2FsdGVkX1/CGPPOEkHwDPpSyG8r3Q2zmWN9NlgMK1gXLmsZx1OaUMYPhOWv0xQsW5mAPcAtuxGr4PQEbBUIPsi8HQROSsJTxu950lD+4JT0FwlKj2vcANkNnB17/37TzwXUsAFxYK754vZ41+esRvosvNdWSDxsedTeyLm82QdiAIPtb/kZXF/ycmyG/Nh3t1uO9y97sZDsJWcUzm/Jn/9c01+C8FUm1W/3Gw5fYed7sG3lodZXqsiO3aeuXctFa69Lg6DEKFwZxWN1Qc9CZbrO39dBf1XECYYTPXDd9HSrqFI7juh3N/DneGqkLvDAKfQodeL1358l/0X9jqEofQHTfQPYrUrFwow8BR4R5ZvH2LOE7agjTotbpiKkm0KdTiyCKEfPrmOqHiyjl2LGNn7GJlqEmqEKYNdHjVChqDW98YQxx3PX8rw5RJuWGEx3+z3xczAfVX4d3SyGINQlfuwBnx2r3A6npXT6ylHvEUOCtVHk8+HeT1wyr/0lx9lRJINozzVYyLrgTqHviMap2o3NeuS5e3GOGXse3iBlwbt8oLFjczyy8V9iq+R3sK3E9Dy+vIeSqVu31iF2BzfdYigDgGTwcknU8winzZFUpPHAcyb/Xkylyrh+2DtSUgo7o7Jp0ATgoj2BIWNoTlvR6Wn2mvgRJfD9xTxH+zMuuHkec73ugy6jXBTyX7yiOIjW3nvrfiUdB5j1L5ix/kkb60TYJqLfXjhGN+xN1y6uSymT4zk9QHDTj4DrgqRmSC/7h4fGZiOXx31L0RrsfsmCpOHkpHWEpYiJovgjSkrAq9ZVXqWyNuPKCoyXas95sxhEqrVt2D6weRdNcYLoaqV4xvsiEDXRxR56lqb+FZwa1CCmgOFv2R6Rb5A5RE1HKL+4TNl6d5H9HApG8rh01xFnbttq+Xf0Q9Lna5O4Q4eRbA36Fjk3qbsSNTtLIIqvOB/SH7QjP8i6K7I7D9ceUPX
 JZJ/RQdx
 Cc2uLcEMqyENUEKWKKz1mH2cflaHfj++E4x2K3udcMyIfLpIzF9paEjyPax2+oakQmw+h801Gk4HmAQKBaGgKmdEJbnYoHidpkENbUOAargRmmonWM1yzdHWX73/5nkAzxqqqMjXdivZFb0Ktsn+Z7znc6VqkgiBEAYOpTM3sitSlpUuzhW8L5P1RzWcv5OSTh3bdUvNtlMdrtzy/tnV3ln/SXVWsPo9DuNfi96UdiAY06c97zo7MYaYkLeWxB82pLeRdxJde1oym7kUT2YQTjfNFy9eneyfaROWRn1DeRpE+tCykSZTLGsPdDHO9GOzploL9AzmF1TxwggSbSdLCXf8DdJAX8PvpG2H8q7yYUpu0JcHtEa9Uh8Sf014XSTPTeOf2eo8O7PObcLqrAXolx/R+8V7D6QSYEHbvB8B5XUMnpLbVxdnXJemH2rl/BuMsSrYNFX6UIDQYeyUALcDzt/8XCDr3+TBuHbWo4w1pWgz4PTvghXfHXTdxR9aEa22iWOh6F5K5di4miaJkpvJCsz5SiF4JMf7g9UJpF8woPr/oftG4cC6mqgbfFGkY6NK/KoVr6MjyxsQgTckShjYfqIZ8iyIhqr64KcYfzcMydL5rYH19pEercvBiaRWFa6wzfsLv8T1KsGqz9sdXqZHmF/rw/C9mLXrJszNl7f1hybCqYt679OnMA7C0V2NAVVF4o4ExQ4YKFWVqLAL5CWTzk6gTo7e0Camf8d5PlgaGrW8J5tE/skY17jnnzhWZTK3uKFqlRi0w8hSdM5U=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

------=_Part_111827_1436578456.1786527186935
Content-Type: text/plain; charset=GBK
Content-Transfer-Encoding: base64

SGkgQW5kcmV3LAoKICBUaGFua3MgZm9yIHRha2luZyBhIGxvb2suCgoKICBTb3JyeSwgdGhlIHBy
ZXZpb3VzIHZlcnNpb24gd2FzIGJhc2VkIG9uIG1tLWV2ZXJ5dGhpbmcuCiAgSSd2ZSBub3cgcmVi
YXNlZCBvbnRvIG1tLW5ldyBhbmQgcmVzZW50IGFzIHYyLgogIEkgY29tcGFyZWQgYWdhaW5zdAog
IGh0dHBzOi8vZ2l0Lmtlcm5lbC5vcmcvcHViL3NjbS9saW51eC9rZXJuZWwvZ2l0L2FrcG0vbW0u
Z2l0L2xvZy8/aD1tbS1uZXcKICBhbmQgdGhlIGNvZGUgbWF0Y2hlcyB0aGUgcGF0Y2ggY29udGV4
dC4KCgogIHYyOmh0dHBzOi8vbG9yZS5rZXJuZWwub3JnL2FsbC8yMDI2MDgxMjA5Mjg1Ni41NTI5
Ni0xLWxpdXFpYW5nbmVvQDE2My5jb20vCgoKCi0tCgpUaGFua3MKCgpCZXN0IFJlZ2FyZHMKCgpR
aWFuZwoKCgoKCkF0IDIwMjYtMDgtMTIgMDk6MjQ6NDAsICJBbmRyZXcgTW9ydG9uIiA8YWtwbUBs
aW51eC1mb3VuZGF0aW9uLm9yZz4gd3JvdGU6Cj5PbiBUdWUsIDExIEF1ZyAyMDI2IDE3OjIyOjU1
ICswODAwIGxpdXFpYW5nbmVvQDE2My5jb20gd3JvdGU6Cj4KPj4gRnJvbTogUWlhbmcgTGl1IDxs
aXVxaWFuZ0BreWxpbm9zLmNuPgo+PiAKPj4gTW92ZSBwcl9kZWJ1ZygpIGluc2lkZSB0aGUgYGlm
IChkcGFnZSlgIGJsb2NrIHRvIGF2b2lkIGEgTlVMTCBkZXJlZiwKPj4gYW5kIGZpeCB0aGUgZGly
ZWN0aW9uIGxhYmVsIGZyb20gInN5cyB0byBkZXYiIHRvICJkZXYgdG8gc3lzIiB0byBtYXRjaAo+
PiB0aGUgZGV2aWNlLXRvLXN5c3RlbSBjb3B5Lgo+PiAKPj4gLi4uCj4+Cj4+IC0tLSBhL2xpYi90
ZXN0X2htbS5jCj4+ICsrKyBiL2xpYi90ZXN0X2htbS5jCj4+IEBAIC0xMTUxLDEwICsxMTUxLDkg
QEAgc3RhdGljIHZtX2ZhdWx0X3QgZG1pcnJvcl9kZXZtZW1fZmF1bHRfYWxsb2NfYW5kX2NvcHko
c3RydWN0IG1pZ3JhdGVfdm1hICphcmdzLAo+PiAgCQlpZiAoIWRwYWdlICYmICFvcmRlcikKPj4g
IAkJCXJldHVybiBWTV9GQVVMVF9PT007Cj4+ICAKPj4gLQkJcHJfZGVidWcoIm1pZ3JhdGluZyBm
cm9tIHN5cyB0byBkZXYgcGZuIHNyYzogMHglbHggcGZuIGRzdDogMHglbHhcbiIsCj4+IC0JCQkJ
cGFnZV90b19wZm4oc3BhZ2UpLCBwYWdlX3RvX3BmbihkcGFnZSkpOwo+PiAtCj4+ICAJCWlmIChk
cGFnZSkgewo+PiArCQkJcHJfZGVidWcoIm1pZ3JhdGluZyBmcm9tIGRldiB0byBzeXMgcGZuIHNy
YzogMHglbHggcGZuIGRzdDogMHglbHhcbiIsCj4+ICsJCQkJIHBhZ2VfdG9fcGZuKHNwYWdlKSwg
cGFnZV90b19wZm4oZHBhZ2UpKTsKPj4gIAkJCWxvY2tfcGFnZShkcGFnZSk7Cj4+ICAJCQkqZHN0
IHw9IG1pZ3JhdGVfcGZuKHBhZ2VfdG9fcGZuKGRwYWdlKSk7Cj4+ICAJCX0KPgo+Q3VycmVudCBr
ZXJuZWwgY29kZSBkb2Vzbid0IGxvb2sgbGlrZSB0aGlzPwo=
------=_Part_111827_1436578456.1786527186935
Content-Type: text/html; charset=GBK
Content-Transfer-Encoding: base64

PGRpdiBkYXRhLW50ZXM9Im50ZXNfbWFpbF9ib2R5X3Jvb3QiIHN0eWxlPSJsaW5lLWhlaWdodDox
Ljc7Y29sb3I6IzAwMDAwMDtmb250LXNpemU6MTRweDtmb250LWZhbWlseTpDb3VyaWVyIj48ZGl2
IGlkPSJzcG5FZGl0b3JDb250ZW50Ij48ZGl2IHN0eWxlPSJtYXJnaW46IDA7Ij48c3BhbiBzdHls
ZT0iZm9udC1mYW1pbHk6IG1vbm9zcGFjZTsiPkhpIEFuZHJldyw8YnI+PGJyPiZuYnNwOyBUaGFu
a3MgZm9yIHRha2luZyBhIGxvb2suPC9zcGFuPjwvZGl2PjxkaXYgc3R5bGU9Im1hcmdpbjogMDsi
Pjxicj48L2Rpdj48ZGl2IHN0eWxlPSJtYXJnaW46IDA7Ij48c3BhbiBzdHlsZT0iZm9udC1mYW1p
bHk6IG1vbm9zcGFjZTsiPiZuYnNwOyBTb3JyeSwgdGhlIHByZXZpb3VzIHZlcnNpb24gd2FzIGJh
c2VkIG9uIG1tLWV2ZXJ5dGhpbmcuPC9zcGFuPjwvZGl2PjxkaXYgc3R5bGU9Im1hcmdpbjogMDsi
PjxzcGFuIHN0eWxlPSJmb250LWZhbWlseTogbW9ub3NwYWNlOyI+Jm5ic3A7IEkndmUgbm93IHJl
YmFzZWQgb250byBtbS1uZXcgYW5kIHJlc2VudCBhcyB2Mi48L3NwYW4+PC9kaXY+PGRpdiBzdHls
ZT0ibWFyZ2luOiAwOyI+PHNwYW4gc3R5bGU9ImZvbnQtZmFtaWx5OiBtb25vc3BhY2U7Ij4mbmJz
cDsgSSBjb21wYXJlZCBhZ2FpbnN0PGJyPiZuYnNwOyBodHRwczovL2dpdC5rZXJuZWwub3JnL3B1
Yi9zY20vbGludXgva2VybmVsL2dpdC9ha3BtL21tLmdpdC9sb2cvP2g9bW0tbmV3PGJyPiZuYnNw
OyBhbmQgdGhlIGNvZGUgbWF0Y2hlcyB0aGUgcGF0Y2ggY29udGV4dC48L3NwYW4+PC9kaXY+PGRp
diBzdHlsZT0ibWFyZ2luOiAwOyI+PGJyPjwvZGl2PjxkaXYgc3R5bGU9Im1hcmdpbjogMDsiPjxz
cGFuIHN0eWxlPSJmb250LWZhbWlseTogbW9ub3NwYWNlOyI+Jm5ic3A7IHYyOjxhIGhyZWY9Imh0
dHBzOi8vbG9yZS5rZXJuZWwub3JnL2FsbC8yMDI2MDgxMjA5Mjg1Ni41NTI5Ni0xLWxpdXFpYW5n
bmVvQDE2My5jb20vIj5odHRwczovL2xvcmUua2VybmVsLm9yZy9hbGwvMjAyNjA4MTIwOTI4NTYu
NTUyOTYtMS1saXVxaWFuZ25lb0AxNjMuY29tLzwvYT48L3NwYW4+PC9kaXY+PGRpdiBzdHlsZT0i
bWFyZ2luOiAwOyI+PHNwYW4gc3R5bGU9ImZvbnQtZmFtaWx5OiBtb25vc3BhY2U7Ij48YnI+PC9z
cGFuPjwvZGl2PjwvZGl2PjxkaXYgc3R5bGU9InBvc2l0aW9uOnJlbGF0aXZlO3pvb206MSI+PHAg
c3R5bGU9Im1hcmdpbjogMCI+PHNwYW4gc3R5bGU9ImZvbnQtZmFtaWx5OiBtb25vc3BhY2U7Ij4t
LTwvc3Bhbj48L3A+PGRpdiBpZD0iYiI+PHNwYW4gc3R5bGU9ImZvbnQtZmFtaWx5OiBtb25vc3Bh
Y2U7Ij5UaGFua3M8L3NwYW4+PC9kaXY+PGRpdj48YnI+PC9kaXY+PGRpdj48c3BhbiBzdHlsZT0i
Zm9udC1mYW1pbHk6IG1vbm9zcGFjZTsiPkJlc3QgUmVnYXJkczwvc3Bhbj48L2Rpdj48ZGl2Pjxi
cj48L2Rpdj48ZGl2PjxzcGFuIHN0eWxlPSJmb250LWZhbWlseTogbW9ub3NwYWNlOyI+UWlhbmc8
L3NwYW4+PC9kaXY+PGRpdj48YnI+PC9kaXY+PGRpdiBzdHlsZT0iY2xlYXI6Ym90aCI+PC9kaXY+
PC9kaXY+PGRpdiBpZD0iZGl2TmV0ZWFzZU1haWxDYXJkIj48L2Rpdj48ZGl2IHN0eWxlPSJtYXJn
aW46IDA7Ij48YnI+PC9kaXY+PHByZT48YnI+QXQgMjAyNi0wOC0xMiAwOToyNDo0MCwgIkFuZHJl
dyBNb3J0b24iICZsdDtha3BtQGxpbnV4LWZvdW5kYXRpb24ub3JnJmd0OyB3cm90ZToKJmd0O09u
IFR1ZSwgMTEgQXVnIDIwMjYgMTc6MjI6NTUgKzA4MDAgbGl1cWlhbmduZW9AMTYzLmNvbSB3cm90
ZToKJmd0OwomZ3Q7Jmd0OyBGcm9tOiBRaWFuZyBMaXUgJmx0O2xpdXFpYW5nQGt5bGlub3MuY24m
Z3Q7CiZndDsmZ3Q7IAomZ3Q7Jmd0OyBNb3ZlIHByX2RlYnVnKCkgaW5zaWRlIHRoZSBgaWYgKGRw
YWdlKWAgYmxvY2sgdG8gYXZvaWQgYSBOVUxMIGRlcmVmLAomZ3Q7Jmd0OyBhbmQgZml4IHRoZSBk
aXJlY3Rpb24gbGFiZWwgZnJvbSAic3lzIHRvIGRldiIgdG8gImRldiB0byBzeXMiIHRvIG1hdGNo
CiZndDsmZ3Q7IHRoZSBkZXZpY2UtdG8tc3lzdGVtIGNvcHkuCiZndDsmZ3Q7IAomZ3Q7Jmd0OyAu
Li4KJmd0OyZndDsKJmd0OyZndDsgLS0tIGEvbGliL3Rlc3RfaG1tLmMKJmd0OyZndDsgKysrIGIv
bGliL3Rlc3RfaG1tLmMKJmd0OyZndDsgQEAgLTExNTEsMTAgKzExNTEsOSBAQCBzdGF0aWMgdm1f
ZmF1bHRfdCBkbWlycm9yX2Rldm1lbV9mYXVsdF9hbGxvY19hbmRfY29weShzdHJ1Y3QgbWlncmF0
ZV92bWEgKmFyZ3MsCiZndDsmZ3Q7ICAJCWlmICghZHBhZ2UgJmFtcDsmYW1wOyAhb3JkZXIpCiZn
dDsmZ3Q7ICAJCQlyZXR1cm4gVk1fRkFVTFRfT09NOwomZ3Q7Jmd0OyAgCiZndDsmZ3Q7IC0JCXBy
X2RlYnVnKCJtaWdyYXRpbmcgZnJvbSBzeXMgdG8gZGV2IHBmbiBzcmM6IDB4JWx4IHBmbiBkc3Q6
IDB4JWx4XG4iLAomZ3Q7Jmd0OyAtCQkJCXBhZ2VfdG9fcGZuKHNwYWdlKSwgcGFnZV90b19wZm4o
ZHBhZ2UpKTsKJmd0OyZndDsgLQomZ3Q7Jmd0OyAgCQlpZiAoZHBhZ2UpIHsKJmd0OyZndDsgKwkJ
CXByX2RlYnVnKCJtaWdyYXRpbmcgZnJvbSBkZXYgdG8gc3lzIHBmbiBzcmM6IDB4JWx4IHBmbiBk
c3Q6IDB4JWx4XG4iLAomZ3Q7Jmd0OyArCQkJCSBwYWdlX3RvX3BmbihzcGFnZSksIHBhZ2VfdG9f
cGZuKGRwYWdlKSk7CiZndDsmZ3Q7ICAJCQlsb2NrX3BhZ2UoZHBhZ2UpOwomZ3Q7Jmd0OyAgCQkJ
KmRzdCB8PSBtaWdyYXRlX3BmbihwYWdlX3RvX3BmbihkcGFnZSkpOwomZ3Q7Jmd0OyAgCQl9CiZn
dDsKJmd0O0N1cnJlbnQga2VybmVsIGNvZGUgZG9lc24ndCBsb29rIGxpa2UgdGhpcz8KPC9wcmU+
PC9kaXY+
------=_Part_111827_1436578456.1786527186935--



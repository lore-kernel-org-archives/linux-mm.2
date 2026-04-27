Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4C9FEFF885E
	for <linux-mm@archiver.kernel.org>; Mon, 27 Apr 2026 11:14:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A32876B008A; Mon, 27 Apr 2026 07:14:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9E33F6B008C; Mon, 27 Apr 2026 07:14:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8F90F6B0092; Mon, 27 Apr 2026 07:14:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7D7596B008A
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 07:14:32 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 14D24160179
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 11:14:32 +0000 (UTC)
X-FDA: 84704077584.10.7F7EF13
Received: from zg8tmja5ljk3lje4ms43mwaa.icoremail.net (zg8tmja5ljk3lje4ms43mwaa.icoremail.net [209.97.181.73])
	by imf07.hostedemail.com (Postfix) with ESMTP id AF40940005
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 11:14:27 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=none ("invalid DKIM record") header.d=stu.xidian.edu.cn header.s=dkim header.b=FvxlLG7U;
	dmarc=pass (policy=quarantine) header.from=xidian.edu.cn;
	spf=pass (imf07.hostedemail.com: domain of 25181214217@stu.xidian.edu.cn designates 209.97.181.73 as permitted sender) smtp.mailfrom=25181214217@stu.xidian.edu.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777288470;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=L/uvrT/xDOtwHjlWiwTHD3FLPmC0OEW58oN1HYaa82Y=;
	b=1I3tGyrbjGSoK/NOFMtdcDZv/4lQsMDIzOkqM+9XDTcgYlBW8iOL5exN44G9SH52gYZh8/
	FM9LOhQv/nUqHinPWibHdGD4Jxmn8UTXkDotb0jOorlTveD7DHnBPC5AcENziRzG2Hv+AN
	H9nkALN5g1oxyPuzLisW1Qx5W3i6fZ8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777288470; a=rsa-sha256;
	cv=none;
	b=bs1bsPhXQkWVGW+U7rB98Z7sHpd+YUjnrw3AIlkHNI9GUqU0EUvfSPPAnFA2xGeBJ6qaKt
	wgdR4km6RHYndzLwYua7lbNzvmV2bFV1pCSUYsQtgWlcWq3KfZ9agxlN+pmCJNFPvTKOFW
	VoQKkF67kkOtnBHoRE0lkMn1z2AOPk0=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=none ("invalid DKIM record") header.d=stu.xidian.edu.cn header.s=dkim header.b=FvxlLG7U;
	dmarc=pass (policy=quarantine) header.from=xidian.edu.cn;
	spf=pass (imf07.hostedemail.com: domain of 25181214217@stu.xidian.edu.cn designates 209.97.181.73 as permitted sender) smtp.mailfrom=25181214217@stu.xidian.edu.cn
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=stu.xidian.edu.cn; s=dkim; h=Received:Date:From:To:Cc:Subject:
	In-Reply-To:References:Content-Transfer-Encoding:Content-Type:
	MIME-Version:Message-ID; bh=hEIoJhqh/zWnySkdcoflORMGvdbU+sorVFxn
	yLsoHvU=; b=FvxlLG7U0AFXFnzZ2goEkrhMSnYsautMiAcm911GK+z00emA3iKC
	u8fZ68B/1E7kLvLyA3q9Ah7ApAUwPkvApxUzHKTOR1YR2o92/1Zxm6MSXjyDFv3q
	202Dbv+Q7LhN5q6YuKOz+MqKzsWwjcyTa+d1JyihTao1CW6aFQjViww=
Received: from 25181214217$stu.xidian.edu.cn ( [113.200.174.80] ) by
 ajax-webmail-hzbj-edu-front-4.icoremail.net (Coremail) ; Mon, 27 Apr 2026
 19:14:20 +0800 (GMT+08:00)
X-Originating-IP: [113.200.174.80]
Date: Mon, 27 Apr 2026 19:14:20 +0800 (GMT+08:00)
X-CM-HeaderCharset: UTF-8
From: =?UTF-8?B?546L5piO54Wc?= <25181214217@stu.xidian.edu.cn>
To: "David Hildenbrand (Arm)" <david@kernel.org>, muchun.song@linux.dev
Cc: "Muchun Song" <muchun.song@linux.dev>, Liam.Howlett@oracle.com,
	akpm@linux-foundation.org, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, vbabka@kernel.org, jannh@google.com,
	pfalcato@suse.de, osalvador@suse.de, ljs@kernel.org
Subject: Re: Re: [RFC PATCH] mm/hugetlb: fix resv_map memory leak in
 __mmap_region error path
X-Priority: 3
X-Mailer: Coremail Webmail Server Version 2024.3-cmXT6 build
 20250410(2f5ccd7f) Copyright (c) 2002-2026 www.mailtech.cn
 mispb-8dfce572-2f24-404d-b59d-0dd2e304114c-icoremail.cn
In-Reply-To: <7afd4504-1d2e-429f-ae6e-136414a9d4b8@kernel.org>
References: <20260425070700.562229-1-25181214217@stu.xidian.edu.cn>
 <BCFCF1D6-8F39-4E60-AD86-0ECF799FFD9D@linux.dev>
 <7afd4504-1d2e-429f-ae6e-136414a9d4b8@kernel.org>
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset=UTF-8
MIME-Version: 1.0
Message-ID: <4155b8e4.8e25.19dcea5b9d4.Coremail.25181214217@stu.xidian.edu.cn>
X-Coremail-Locale: zh_CN
X-CM-TRANSID:BrQMCkC2XbkNRe9pUEfJAQ--.45605W
X-CM-SenderInfo: qsvrmiqsrujiux6v33wo0lvxldqovvfxof0/1tbiAQUQEWnuLFp0b
	gACss
X-Coremail-Antispam: 1Ur529EdanIXcx71UUUUU7IcSsGvfJ3iIAIbVAYjsxI4VWxJw
	CS07vEb4IE77IF4wCS07vE1I0E4x80FVAKz4kxMIAIbVAFxVCaYxvI4VCIwcAKzIAtYxBI
	daVFxhVjvjDU=
X-Rspam-User: 
X-Rspamd-Queue-Id: AF40940005
X-Rspamd-Server: rspam04
X-Stat-Signature: 9immd59ank1aftnzo9a9bj4dgcmbn6ao
X-HE-Tag: 1777288467-62724
X-HE-Meta: U2FsdGVkX19ZPeiFT+nRxXW7C6xgsBQqWBx7q60wTEpsSMoeUHyv4JN4D9mQI84CZQrrdj3Jexl1+KMccHMFeVmrwiR+o2bRD1ntD84R0VH4C0wxvIgbGK3ZJmTVymFTNFutKg1Y+2EMzNn4LBeyNNPDT6iuYDykXE9ciGB6NfhE7QyQG5MCi6e4GJFYq3i6T2EqpVlUolAiXAtsTV/TVTUq670z4gB0nzLxDKBM1t6t8Y9rfRMpe2F52PM4rV+SUagBF3rPV2mTk8tuAX6ZxWwIU5VLVmWT8cedp9T5fBHmLxg9EioJnZYnhvCb343AQTfBC2ZtcN3AyMF+GC9cSuAVkotYRJrmbBKjXUbrQEbdRu7q+OHqvfjFr3t9nSoMkLMAYTCBVuIiv2Ct0GOBtuTep81R3fe9OltIk685aVtTRqQuh44tjS2WzXVO2FLKqbsTKuHKQwPjG2CeheP+2P+jseGhxVtqbT5WlUhuNbZIYtsVsfiofeXZwDCMg9DLbu+dvUqFamz7en81FM4Vf9bnDGVhDhTcX+CUhRusUM0Dc0SiHPqIHJ0UlzYZfURcW7+3F/C4Hq+ACpFKjZn6sn+8yEriyrtSdFpZa1pT9Kpg74tOtYl3pdRUau2OJC5iZ/mjNHaFbBr0IXWs55D1i11CY0g0JEYcvAHDevQmDWSqG6U+KNtkJ0X8GOcO+6RsfONpVPsksN137jXEB58NmIRl7nfoN7ewAGit91QoR8Njze89L+xeghOSoxSUyTvP2ysA8H4mjc5sR4AInpnMjNK/y892W34w5d6sJJQ3ELafgMCXt9+KFXhxPrg9SijPipmFpCtORb9xDhPHPjjqreJKVvO4JkhuJpniFRmfrNe2pS0hn/vJXePeOQ7/s582pJbyqQYNheil6xAqy+QCbdCIxtQDmJx0MUMYJ20Jwdc7uDYAbjevEopVGgEsX+J+EisjB0bBTM0Y/J+2Xc4
 VrbXUAyk
 FEJXmL+q8WG7YKk94Tx+yJdyIjOjhB4vFQV7hoi0ZqkjyZawxQ8+xDJ+depmoTpKF1nP4TlpgyBFlRSNrm3iV/IB+sQmbcYQ+fURWDlL0iKXrp9a44xWhDe5cTKf9hz7NAacHFeCNdrRTEBFVNd0G+3vDR/p6uJ7USHwLyJJwvNlOByWlRXl+bd7g6dZkTDL28NSONbnaImfkiCHbHnTZLJj6IolForASpXF8ihDDf1bskQuMBA4ZQjzrNnWM3tVscnrNqP0j2dIY0ZSScla6EYukp52IxR2/pqt9uk/+J56crQU7EyAWBKBIHo+wZUVJONOYnZ9RyCvNGFqHvHd/6f5etuZ787zAh2t9J8ddW0qAm5umyFZXz35Q1uQsVxUN/dUgOy79ZcfMk5j5uGSKwyQNTvwEGwSKrcogRktu50WeJiXKb/dgLiPCc+K6FI4ByulGBFp8oUVcpfu5PXGWU+KyvuZT2y0kQveFxS96zTk5xL3fmV8vmOXfgRG7QwSo68buhnrBWm7rTtQ1B34Jn8xZrrRbJmw3tNP31i7NtZk3Gs88r1zEWUl7gTN1Y0J7kQSar763swuKXswe0ZlugTZGOcOmkdx2wIHzCqvq6BPAsHj19BLU2sHJ3nX+jt51bsdee6jzi2WNAmo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

SGkgTXVjaHVuIGFuZCBEYXZpZCwKClRoYW5rcyBhIGxvdCBmb3IgdGFraW5nIHRoZSB0aW1lIHRv
IHJldmlldyEKCj4gQXQgbGVhc3QgZm9yIG1lLCBpdCBpcyBub3QgZ29vZCBuYW1lIHRvIGRpc3Rp
bmd1aXNoIGl0IGZyb20gZXJyb3JfaG9vay4KPiBhYm9ydF9tbWFwX3ByZXBhcmU/IEkgYW0gbm90
IHN1cmUgaWYgaXQgaXMgYSBnb29kIHNvbHV0aW9uLCBDYyBvdGhlcgo+IE1NIG1haW50YWluZXJz
IGFzIHdlbGwuCgpJIGNvbXBsZXRlbHkgYWdyZWUuIGBhYm9ydF9tbWFwX3ByZXBhcmVgIGlzIGlu
ZGVlZCBtdWNoIGNsZWFyZXIgYW5kIG1vcmUgc3BlY2lmaWMgdG8gaXRzIHB1cnBvc2UuIEkgd2ls
bCB1cGRhdGUgdGhlIG5hbWluZyBpbiB0aGUgdjIgcGF0Y2guCgo+IFBsZWFzZSB1c2UgLi9zY3Jp
cHRzL2dldF9tYWludGFpbmVyLnBsIHRvIGdldCBmdWxsIG1haWwgbGlzdCBmb3IgQ2MvVG8gc2lu
Y2UKPiBpdCBpcyBub3Qgb25seSByZWxhdGVkIHRvIEh1Z2VUTEIgc3Vic3lzdGVtLgoKSSBhcG9s
b2dpemUgZm9yIHRoZSBtaXNzaW5nIENDcy4gSSBkaWQgZ2VuZXJhdGUgdGhlIGZ1bGwgbGlzdCB1
c2luZyBgZ2V0X21haW50YWluZXIucGxgLCBidXQgdGhlIFNNVFAgc2VydmVyIG9mIFhpZGlhbiBV
bml2ZXJzaXR5IGRyb3BzIGVtYWlscyB3aXRoIHRvbyBtYW55IGZvcmVpZ24gcmVjaXBpZW50cyBk
dWUgdG8gc3RyaWN0IGFudGktc3BhbSBwb2xpY2llcy4gSSBoYWQgdG8gaGVhdmlseSB0cmltIHRo
ZSBDQyBsaXN0IGp1c3QgdG8gZ2V0IHRoZSBSRkMgcGF0Y2ggZGVsaXZlcmVkLiBJIHdpbGwgdHJ5
IHRvIHVzZSBhbiBhbHRlcm5hdGl2ZSBlbWFpbCBvciBjaHVuayB0aGUgQ0NzIHRvIGVuc3VyZSBh
bGwgcmVsZXZhbnQgYXV0aG9ycyBhcmUgaW5jbHVkZWQgaW4gdGhlIG5leHQgdmVyc2lvbi4KCkkg
d2lsbCBob2xkIG9mZiBvbiBzZW5kaW5nIHRoZSB2MiBwYXRjaCB1bnRpbCBMb3JlbnpvIHNoYXJl
cyBoaXMgdGhvdWdodHMgb24gd2hldGhlciB0aGlzIGFyY2hpdGVjdHVyYWwgYXBwcm9hY2ggaXMg
dGhlIHJpZ2h0IHdheSB0byBnby4KCkJlc3QgcmVnYXJkcywKTWluZ3l1CgoKPiAtLS0tLeWOn+Wn
i+mCruS7ti0tLS0tCj4g5Y+R5Lu25Lq6OiAiRGF2aWQgSGlsZGVuYnJhbmQgKEFybSkiIDxkYXZp
ZEBrZXJuZWwub3JnPgo+IOWPkemAgeaXtumXtDoyMDI2LTA0LTI3IDE2OjE3OjIzICjmmJ/mnJ/k
uIApCj4g5pS25Lu25Lq6OiAiTXVjaHVuIFNvbmciIDxtdWNodW4uc29uZ0BsaW51eC5kZXY+LCAi
TWluZ3l1IFdhbmciIDwyNTE4MTIxNDIxN0BzdHUueGlkaWFuLmVkdS5jbj4KPiDmioTpgIE6IExp
YW0uSG93bGV0dEBvcmFjbGUuY29tLCBha3BtQGxpbnV4LWZvdW5kYXRpb24ub3JnLCBsaW51eC1t
bUBrdmFjay5vcmcsIGxpbnV4LWtlcm5lbEB2Z2VyLmtlcm5lbC5vcmcsIGxqc0BrZXJuZWwub3Jn
LCB2YmFia2FAa2VybmVsLm9yZywgamFubmhAZ29vZ2xlLmNvbSwgcGZhbGNhdG9Ac3VzZS5kZSwg
b3NhbHZhZG9yQHN1c2UuZGUKPiDkuLvpopg6IFJlOiBbUkZDIFBBVENIXSBtbS9odWdldGxiOiBm
aXggcmVzdl9tYXAgbWVtb3J5IGxlYWsgaW4gX19tbWFwX3JlZ2lvbiBlcnJvciBwYXRoCj4gCj4g
Cj4gPj4gCS8qCj4gPj4gCSAqIFdlIGNhbm5vdCBwZXJtaXQgdGhlIHJtYXAgZmluZGluZyB0aGlz
IFZNQSBpbiB0aGUgdGltZQo+ID4+IAkgKiBiZXR3ZWVuIHRoZSBWTUEgYmVpbmcgaW5zZXJ0ZWQg
aW50byB0aGUgVk1BIHRyZWUgYW5kIHRoZQo+ID4+IGRpZmYgLS1naXQgYS9pbmNsdWRlL2xpbnV4
L21tX3R5cGVzLmggYi9pbmNsdWRlL2xpbnV4L21tX3R5cGVzLmgKPiA+PiBpbmRleCBhMzA4ZTJj
MjNiODIuLjkzMjBmNjY5OWZhOSAxMDA2NDQKPiA+PiAtLS0gYS9pbmNsdWRlL2xpbnV4L21tX3R5
cGVzLmgKPiA+PiArKysgYi9pbmNsdWRlL2xpbnV4L21tX3R5cGVzLmgKPiA+PiBAQCAtODYxLDYg
Kzg2MSw4IEBAIHN0cnVjdCBtbWFwX2FjdGlvbiB7Cj4gPj4gKiBpdCBpcyBub3QgdmFsaWQgdG8g
Y2xlYXIgdGhlIGVycm9yIGhlcmUuCj4gPj4gKi8KPiA+PiAJaW50ICgqZXJyb3JfaG9vaykoaW50
IGVycik7Cj4gPj4gKyAKPiA+PiArIAl2b2lkICgqYWJvcnRfaG9vaykoc3RydWN0IHZtX2FyZWFf
ZGVzYyAqZGVzYyk7Cj4gPiAKPiA+IEF0IGxlYXN0IGZvciBtZSwgaXQgaXMgbm90IGdvb2QgbmFt
ZSB0byBkaXN0aW5ndWlzaCBpdCBmcm9tIGVycm9yX2hvb2suCj4gPiBhYm9ydF9tbWFwX3ByZXBh
cmU/IEkgYW0gbm90IHN1cmUgaWYgaXQgaXMgYSBnb29kIHNvbHV0aW9uLCBDYyBvdGhlcgo+ID4g
TU0gbWFpbnRhaW5lcnMgYXMgd2VsbC4KPiA+Cj4gCj4gSSdtIHN1cmUgTG9yZW56byB3aWxsIHBy
b3ZpZGUgZmVlZGJhY2sgaGVyZSA6KQo+IAo+IC0tIAo+IENoZWVycywKPiAKPiBEYXZpZAo=


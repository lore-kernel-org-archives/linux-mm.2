Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A34BDCF6BE4
	for <linux-mm@archiver.kernel.org>; Wed,  7 Jan 2026 05:48:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 183CD6B0092; Wed,  7 Jan 2026 00:48:18 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 131CD6B0093; Wed,  7 Jan 2026 00:48:18 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 030E86B0095; Wed,  7 Jan 2026 00:48:17 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id E71B46B0092
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 00:48:17 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id B83C1140149
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 05:48:17 +0000 (UTC)
X-FDA: 84304087434.04.908E326
Received: from zg8tmtyylji0my4xnjqumte4.icoremail.net (zg8tmtyylji0my4xnjqumte4.icoremail.net [162.243.164.118])
	by imf12.hostedemail.com (Postfix) with ESMTP id 4F73B40007
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 05:48:14 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=none ("invalid DKIM record") header.d=stu.xidian.edu.cn header.s=dkim header.b=jNu51oMK;
	dmarc=pass (policy=quarantine) header.from=xidian.edu.cn;
	spf=pass (imf12.hostedemail.com: domain of wangzhi_xd@stu.xidian.edu.cn designates 162.243.164.118 as permitted sender) smtp.mailfrom=wangzhi_xd@stu.xidian.edu.cn
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767764895; a=rsa-sha256;
	cv=none;
	b=KIyQpvs2rXaS8m/sKO/5aOGYNevNqwWu8xQYm/BmN+QPsdzd3OYLuPGshiBsz6pZ+zP7MF
	sU9IFzVovWAro3UQgF/YEwNPrMeknq31vy2eJT6TxHz84Sj575ONjrir/1P1/P6s9U5L4h
	AfO+u8LCMjl2eKKvcltlLebupdGg+BY=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=none ("invalid DKIM record") header.d=stu.xidian.edu.cn header.s=dkim header.b=jNu51oMK;
	dmarc=pass (policy=quarantine) header.from=xidian.edu.cn;
	spf=pass (imf12.hostedemail.com: domain of wangzhi_xd@stu.xidian.edu.cn designates 162.243.164.118 as permitted sender) smtp.mailfrom=wangzhi_xd@stu.xidian.edu.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767764895;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=GIj9mY2sobu2vYVVnyzaDGBHzr1Zh/Ll4Xn/j0eWQU8=;
	b=zoUfrcoABu12u6RLA1D/27HD0j69XIhOHMEZAhZxnyMjZuAV5klicJrtRrxZf/FSeu1tV5
	KWgokjQJQZxT+6c5CK4zpCSyJ6nMV/yttKbLkzCkipyNcEAjWTFrw08OYgBUPBCdrNrh7J
	+YVJUbyM4bnHw4FY2EmUiLIKbV23R1Y=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=stu.xidian.edu.cn; s=dkim; h=Received:Date:From:To:Cc:Subject:
	Content-Transfer-Encoding:Content-Type:MIME-Version:Message-ID;
	bh=d2EYuNqZrTHUae/ttK0jTaV6hQZFNZzEEZqf0PfS/hQ=; b=jNu51oMKck+uO
	rQAznQyplFBlDiQKwdtgsd0/6kL6xXvmy7UlqlONbXX3h/y1pyBFRU1YYDB2XuSX
	LIFnkprDa78jhc/UmeOJH3xbROATPCGQ8s1LfdysAnAWCtAjRJ2kBBB09PElO2aa
	VwTaFO5MqtUWQEYDtrBBj7ZB0aPybY=
Received: from wangzhi_xd$stu.xidian.edu.cn ( [113.200.174.102] ) by
 ajax-webmail-hzbj-edu-front-4.icoremail.net (Coremail) ; Wed, 7 Jan 2026
 13:48:01 +0800 (GMT+08:00)
X-Originating-IP: [113.200.174.102]
Date: Wed, 7 Jan 2026 13:48:01 +0800 (GMT+08:00)
X-CM-HeaderCharset: UTF-8
From: =?UTF-8?B?546L5b+X?= <wangzhi_xd@stu.xidian.edu.cn>
To: linux-kernel@vger.kernel.org
Cc: rcu@vger.kernel.org, dri-devel@lists.freedesktop.org, linux-mm@kvack.org,
	x86@kernel.org, paulmck@kernel.org, tglx@linutronix.de,
	peterz@infradead.org, akpm@linux-foundation.org,
	syzkaller-bugs@googlegroups.com
Subject: [BUG] rcu: stall detected in drm_ioctl with PREEMPT(full) during
 DRM vblank and printk
X-Priority: 3
X-Mailer: Coremail Webmail Server Version 2024.3-cmXT6 build
 20250410(2f5ccd7f) Copyright (c) 2002-2026 www.mailtech.cn
 mispb-8dfce572-2f24-404d-b59d-0dd2e304114c-icoremail.cn
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset=UTF-8
MIME-Version: 1.0
Message-ID: <277e7e8c.a60a.19b96ff6f72.Coremail.wangzhi_xd@stu.xidian.edu.cn>
X-Coremail-Locale: zh_CN
X-CM-TRANSID:BrQMCkBWudyS811pE5j2AA--.15124W
X-CM-SenderInfo: qstqimqsqqliuu6v33wo0lvxldqovvfxof0/1tbiAgUECGlaeE5zG
	AAFsg
X-Coremail-Antispam: 1Ur529EdanIXcx71UUUUU7IcSsGvfJ3iIAIbVAYjsxI4VW3Jw
	CS07vEb4IE77IF4wCS07vE1I0E4x80FVAKz4kxMIAIbVAFxVCaYxvI4VCIwcAKzIAtYxBI
	daVFxhVjvjDU=
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 4F73B40007
X-Stat-Signature: jgcbfuncmfhqcxpekqm9b844b43uonyy
X-Rspam-User: 
X-HE-Tag: 1767764894-211720
X-HE-Meta: U2FsdGVkX19r+SY0Mg+yrUyk73+tbXDjIEUc6rOCwOHCSzB8xVL+poqYl+7SQM58R11p3RgvvuOrLSIy5xUbhxw4yIl1a60OiLbIUZVC0HFFSLrjpEo60QpNxLQJatB+yiToBfgY/RESJ6Ra7b3ZE+39wXw9CGd+EoL7JCcsa2LKn0oCrJXoW4znViYpu96/OcfW0z/8kIbPE1rodU7oGpaWlEdQg7rtOaubntjGt7U3A3WkgFp1ZPAjRj67ShDXvpt649yje7TLDZFyOKwxRM4mPxuof8tH3ownkiiajLXKpBIuQuL+LoF2DV6Y2qhG3mczI+krDxMU77aRu6Qw6MI/30HYWIu68UcA1rbuEChXcoED5talC3kZVxGTEK8iMv42o6WnvmK7pH1GalOV+hIgY4LrVO8G/zUNnCbgiEjxgCtLpe69RgJIED8mmVj8XtlzdDXDpHd9Xlsr4//9RsvuqlE6bq0aXVENZ6I7/T1Xmv0bVDgAPzsC7z/AtL+eAZl7THUM3I5WOSCY+u0zXTO1kAPELXgpAWtc8Acpy6OpwTFvdMc9VifrAhz+lX2eFS/jwi53ZulXSu9kopOUHBwf6vK781oWUEZ0aXVYwSldcZ5QLxqim3Lse+WPmg3HdNjFkkTxMvUVKAsKY5sHuDv1ovZ5r5aJEUXmrJ8krQzh0r1G6hdk0j14ZpdtD4tvBGTnMkvnGN6eMlhXPITjZbSecNzxO8qbpCJyxy/vqL7+pGb1hWILDbF6w9j4k4Y5jYoccz32dlGKIGCMIoKKx6UJORObXbjHZn1aYiKRWxrwpevk+67ZkERRWMEg/szHq7azXK7uy3ZpmCXRbv4TkASSf/gXuf4GYKq1T/j1782dFUqTlPR80EcjfUdceVZRWqyafvNEAOYJ/CDBIJJkH0AZrif75S905ntbyMyQrccpTkoNIBWuWyMHQ8a1vbjuxP1iOsfAWzLJ1TItRYb
 eOK90v5/
 BLGnDX+pvUnfpd6T9OXWqVin4BY0tMqcJ3bW9PdHHOLQJG/8sNzSuczbUBhbZFv3kZnPdnTQYMViGnzmxUB/+JSc7jB8rtW1Do5b1r0jH2zOfmbMy2Es5chjROGTKCc5qzY4GpLee6jNbMVjPk0L0cL1L2GVBkhWMUdq4LPsG7WpJWpWh2Liz/bhBKlB7rDpkp5ocZp8WPYlUbUPTXety3GSV1/U2G6J4wlzgih9yGR9VUzoMJTLlczyZtChdQ59EbKhhdoPtGZawQsQ1i2kKk2G9UKonvmjO3gHbIPWjh4DnsyJhFOlNG9eyZpi4MX2oK4C9RhyRDUXgdGqy7NilGlePA0klFgwG2bfCW00SIkgpXz6+ropK1oeFgRGDE9K6uPN8nujmBkIp7q8rlrVkKbsysxutF0ec72ChrKuqsWBhttffuys2N/Ye3scdIoRXvOL2YhVRkaxLTTQ8Do/EVqA34b44QHZdQqEu2liS/HKm8KHTHfKhLbc/KQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

SGVsbG8sCgpJIGFtIHJlcG9ydGluZyBhbiBSQ1Ugc3RhbGwgZGV0ZWN0ZWQgZHVyaW5nIHN5emth
bGxlci1zdHlsZSBmdXp6IHRlc3RpbmcuClRoZSBzdGFsbCBpcyByZXBvcnRlZCB3aGlsZSBleGVj
dXRpbmcgZHJtX2lvY3RsKCksIHdpdGggQ1BVcyBzcGlubmluZyBpbgpuYXRpdmVfcXVldWVkX3Nw
aW5fbG9ja19zbG93cGF0aCgpIGluIERSTSB2YmxhbmsgaGFuZGxpbmcgYW5kIERSTSBmaWxlCmNs
ZWFudXAgcGF0aHMuIFdpdGggUFJFRU1QVChmdWxsKSBlbmFibGVkLCB0aGUgcmN1X3ByZWVtcHQg
Z3JhY2UtcGVyaW9kCmt0aHJlYWQgaXMgc3RhcnZlZCBmb3Igb3ZlciAxMCBzZWNvbmRzLgoKPT09
IFN1bW1hcnkgPT09ClRoZSBrZXJuZWwgcmVwb3J0czoKSU5GTzogcmN1IGRldGVjdGVkIHN0YWxs
IGluIGRybV9pb2N0bApyY3VfcHJlZW1wdCBrdGhyZWFkIHN0YXJ2ZWQgZm9yIG92ZXIgMTAwMDAg
amlmZmllcwpNdWx0aXBsZSBDUFVzIGFyZSBvYnNlcnZlZCBzcGlubmluZyBpbiBuYXRpdmVfcXVl
dWVkX3NwaW5fbG9ja19zbG93cGF0aCgpCmluc2lkZSBEUk0tcmVsYXRlZCBjb2RlIHBhdGhzLCB3
aGlsZSB0aGUgUkNVIGdyYWNlIHBlcmlvZCBmYWlscyB0bwpjb21wbGV0ZS4KCj09PSBFbnZpcm9u
bWVudCA9PT0KS2VybmVsOiA2LjE4LjAgKGxvY2FsbHkgYnVpbHQpCkNvbmZpZzogUFJFRU1QVChm
dWxsKQpBcmNoOiB4ODZfNjQKSGFyZHdhcmU6IFFFTVUgU3RhbmRhcmQgUEMgKGk0NDBGWCArIFBJ
SVgpCldvcmtsb2FkOiBzeXotZXhlY3V0b3IgKHN5emthbGxlci1zdHlsZSBmdXp6aW5nKQoKPT09
IFRyaWdnZXJpbmcgY29udGV4dCA9PT0KVGhlIHN0YWxsIGlzIGRldGVjdGVkIHdoaWxlIGEgdXNl
cnNwYWNlIHN5emthbGxlciBleGVjdXRvciBpc3N1ZXMgRFJNCmlvY3Rscy4gVGhlIG1haW4gdGFz
ayBjb250ZXh0IGlzOgpkcm1faW9jdGwKZHJtX2lvY3RsX2tlcm5lbApkcm1fbW9kZV9jcmVhdGVi
bG9iX2lvY3RsCmRybV9wcm9wZXJ0eV9jcmVhdGVfYmxvYgpfX2t2bWFsbG9jX25vZGVfbm9wcm9m
CkF0IHRoZSBzYW1lIHRpbWUsIG90aGVyIENQVXMgYXJlIGV4ZWN1dGluZyBEUk0gdmJsYW5rIHNp
bXVsYXRpb24gaW4KaW50ZXJydXB0IGNvbnRleHQgYW5kIERSTSBmaWxlIHRlYXJkb3duIHBhdGhz
LgoKPT09IFdhcm5pbmcgZGV0YWlscyA9PT0KUkNVIHJlcG9ydHM6CklORk86IHJjdV9wcmVlbXB0
IGRldGVjdGVkIHN0YWxscyBvbiBDUFVzL3Rhc2tzCnJjdV9wcmVlbXB0IGt0aHJlYWQgdGltZXIg
d2FrZXVwIGRpZG4ndCBoYXBwZW4gZm9yIH4xMDQ1MCBqaWZmaWVzCnJjdV9wcmVlbXB0IGt0aHJl
YWQgc3RhcnZlZCBmb3Igb3ZlciAxMDQ1MCBqaWZmaWVzClVubGVzcyByY3VfcHJlZW1wdCBrdGhy
ZWFkIGdldHMgc3VmZmljaWVudCBDUFUgdGltZSwKT09NIGlzIG5vdyBleHBlY3RlZCBiZWhhdmlv
ci4KCj09PSBDYWxsIHRyYWNlID09PQpDUFUgMiAoSVJRIGNvbnRleHQpOgpuYXRpdmVfcXVldWVk
X3NwaW5fbG9ja19zbG93cGF0aApkcm1faGFuZGxlX3ZibGFuawp2a21zX3ZibGFua19zaW11bGF0
ZQpocnRpbWVyX2ludGVycnVwdApzeXN2ZWNfYXBpY190aW1lcl9pbnRlcnJ1cHQKQ1BVIDIgKHRh
c2sgY29udGV4dCk6CmNvbnNvbGVfZmx1c2hfYWxsCmNvbnNvbGVfdW5sb2NrCnZwcmludGtfZW1p
dApzaG93X2ZyZWVfYXJlYXMKd2Fybl9hbGxvYwpfX3ZtYWxsb2Nfbm9kZV9yYW5nZV9ub3Byb2YK
ZHJtX3Byb3BlcnR5X2NyZWF0ZV9ibG9iCmRybV9tb2RlX2NyZWF0ZWJsb2JfaW9jdGwKZHJtX2lv
Y3RsCl9feDY0X3N5c19pb2N0bApDUFUgMSAodGFzayBjb250ZXh0KToKbmF0aXZlX3F1ZXVlZF9z
cGluX2xvY2tfc2xvd3BhdGgKZHJtX2ZpbGVfZnJlZQpkcm1fY2xvc2VfaGVscGVyCmRybV9yZWxl
YXNlCl9fZnB1dAp0YXNrX3dvcmtfcnVuCmV4aXRfdG9fdXNlcl9tb2RlX2xvb3AKUkNVIEdQIGt0
aHJlYWQ6CnJjdV9ncF9mcXNfbG9vcApyY3VfZ3Bfa3RocmVhZAoKPT09IE9ic2VydmF0aW9ucyA9
PT0KVGhlIHN0YWxsIGFwcGVhcnMgdG8gaW52b2x2ZSBjb250ZW50aW9uIGJldHdlZW46CkRSTSB2
YmxhbmsgaGFuZGxpbmcgYWNxdWlyaW5nIHNwaW5sb2NrcyBpbiBpbnRlcnJ1cHQgY29udGV4dApE
Uk0gaW9jdGwgcGF0aHMgcGVyZm9ybWluZyBtZW1vcnkgYWxsb2NhdGlvbiBhbmQgZW1pdHRpbmcg
cHJpbnRrCkRSTSBmaWxlIGNsZWFudXAgcGF0aHMgaG9sZGluZyBEUk0tcmVsYXRlZCBzcGlubG9j
a3MKUFJFRU1QVChmdWxsKSBzY2hlZHVsaW5nLCB3aGljaCBhbXBsaWZpZXMgbG9jayBjb250ZW50
aW9uIGFuZCBkZWxheXMKdGhlIHJjdV9wcmVlbXB0IGdyYWNlLXBlcmlvZCBrdGhyZWFkCk11bHRp
cGxlIENQVXMgc3BpbiBpbiBuYXRpdmVfcXVldWVkX3NwaW5fbG9ja19zbG93cGF0aCgpLCBwcmV2
ZW50aW5nIHRoZQpSQ1UgR1Aga3RocmVhZCBmcm9tIHJ1bm5pbmcgYW5kIGNvbXBsZXRpbmcgdGhl
IGdyYWNlIHBlcmlvZC4KCj09PSBSZXByb2R1Y2VyID09PQpObyBzdGFuZGFsb25lIHJlcHJvZHVj
ZXIgaXMgY3VycmVudGx5IGF2YWlsYWJsZS4KVGhlIGlzc3VlIHdhcyBvYnNlcnZlZCBkdXJpbmcg
c3l6a2FsbGVyLXN0eWxlIGZ1enogdGVzdGluZy4KCj09PSBFeHBlY3RlZCBiZWhhdmlvciA9PT0K
RFJNIGlvY3RscywgdmJsYW5rIGhhbmRsaW5nLCBhbmQgZmlsZSBjbGVhbnVwIHNob3VsZCBub3Qg
bGVhZCB0bwpwcm9sb25nZWQgUkNVIHN0YWxscywgZXZlbiB1bmRlciBhZHZlcnNhcmlhbCBvciBt
YWxmb3JtZWQgdXNlcnNwYWNlCndvcmtsb2Fkcy4KCj09PSBBY3R1YWwgYmVoYXZpb3IgPT09ClJD
VSByZXBvcnRzIHByb2xvbmdlZCBzdGFsbHMsIENQVXMgc3BpbiBpbgpuYXRpdmVfcXVldWVkX3Nw
aW5fbG9ja19zbG93cGF0aCgpLCBhbmQgdGhlIHJjdV9wcmVlbXB0IGdyYWNlLXBlcmlvZAprdGhy
ZWFkIGlzIHN0YXJ2ZWQgZm9yIG1vcmUgdGhhbiAxMCBzZWNvbmRzLgoKPT09IE5vdGVzID09PQpU
aGlzIGlzc3VlIGhhcyBiZWVuIG9ic2VydmVkIG11bHRpcGxlIHRpbWVzIHVuZGVyIGZ1enppbmcg
d29ya2xvYWRzLgpBZGRpdGlvbmFsIGxvZ3MsIGtlcm5lbCBjb25maWd1cmF0aW9uLCBvciBmdXJ0
aGVyIHRyYWNlcyBjYW4gYmUKcHJvdmlkZWQgaWYgbmVlZGVkLgoKUmVwb3J0ZWQtYnk6ClpoaSBX
YW5nCg==


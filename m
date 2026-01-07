Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2E5AACF6BF1
	for <linux-mm@archiver.kernel.org>; Wed,  7 Jan 2026 05:52:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8B77C6B0098; Wed,  7 Jan 2026 00:52:27 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 863F26B0099; Wed,  7 Jan 2026 00:52:27 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 791826B009B; Wed,  7 Jan 2026 00:52:27 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 6A4126B0098
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 00:52:27 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 1A96316017A
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 05:52:27 +0000 (UTC)
X-FDA: 84304097934.23.56F7CAF
Received: from sgoci-sdnproxy-4.icoremail.net (sgoci-sdnproxy-4.icoremail.net [129.150.39.64])
	by imf06.hostedemail.com (Postfix) with ESMTP id 0378E180002
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 05:52:23 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=none ("invalid DKIM record") header.d=stu.xidian.edu.cn header.s=dkim header.b=bKHgVYuH;
	dmarc=pass (policy=quarantine) header.from=xidian.edu.cn;
	spf=pass (imf06.hostedemail.com: domain of 23009200614@stu.xidian.edu.cn designates 129.150.39.64 as permitted sender) smtp.mailfrom=23009200614@stu.xidian.edu.cn
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767765145; a=rsa-sha256;
	cv=none;
	b=0VAWuprwl8vyVknArK/r66lSRfCMtRTudsVZgqzrTJ4zJQ0Q475jdCCpJMjcBx3Z5P6aui
	fJX5Jj4PhJqUgG9ahDWwVHhNjoBrqUKqSGcx2egOpU2aCKa4GR8OLZlBre208dbvQZPkHq
	CSM5Kk7CKZ7CLqorNggENZwRDjcNoak=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=none ("invalid DKIM record") header.d=stu.xidian.edu.cn header.s=dkim header.b=bKHgVYuH;
	dmarc=pass (policy=quarantine) header.from=xidian.edu.cn;
	spf=pass (imf06.hostedemail.com: domain of 23009200614@stu.xidian.edu.cn designates 129.150.39.64 as permitted sender) smtp.mailfrom=23009200614@stu.xidian.edu.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767765145;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=8fKyw5yntJAjVsHlfYBULr/aVW76nzMzbSazIgEJOdo=;
	b=E5TDDlTBmXQI6jx31fMWQoUZx59Xbxpt7OIVUsX3zW+fGaWTulPTn5PSFvhBjo6Whbj+PH
	n2Iqj/VBFELdEbMDS8RA4sg5jM8+dBqc7sYkGsxMmEWs8lkY6yHgBLjXzBJwd6frvy5zHa
	UAejrPxxB3XlHtv17SbPhqU/GvG9oww=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=stu.xidian.edu.cn; s=dkim; h=Received:Date:From:To:Cc:Subject:
	Content-Transfer-Encoding:Content-Type:MIME-Version:Message-ID;
	bh=IJW2c0Rxs/6iJSqkH1wrdTI0L1JryyoJLM5/DF3caKY=; b=bKHgVYuHIk8yr
	Lwr16266ZXpIxuFtoMCwX3nBNb2v/247VS7YL/7CYabOsQ5gITAzUyito0tZpPQu
	yUYm0MMGG+Vy2N+S6blAGpS/CQUpYy9fMYDmQeedyX/Vk+vfxl2QeUgykY/h4rnA
	e2d8SkWOPmijDkIET579SCxdPNJFls=
Received: from 23009200614$stu.xidian.edu.cn ( [113.200.174.102] ) by
 ajax-webmail-hzbj-edu-front-4.icoremail.net (Coremail) ; Wed, 7 Jan 2026
 13:52:11 +0800 (GMT+08:00)
X-Originating-IP: [113.200.174.102]
Date: Wed, 7 Jan 2026 13:52:11 +0800 (GMT+08:00)
X-CM-HeaderCharset: UTF-8
From: =?UTF-8?B?546L5b+X?= <23009200614@stu.xidian.edu.cn>
To: linux-kernel@vger.kernel.org
Cc: rcu@vger.kernel.org, linux-mm@kvack.org, dri-devel@lists.freedesktop.org,
	x86@kernel.org, paulmck@kernel.org, tglx@linutronix.de,
	peterz@infradead.org, akpm@linux-foundation.org,
	syzkaller-bugs@googlegroups.com
Subject: [BUG] rcu: stall detected in sys_mmap with PREEMPT(full) involving
 timer softirq and DRM vblank disable
X-Priority: 3
X-Mailer: Coremail Webmail Server Version 2024.3-cmXT6 build
 20250410(2f5ccd7f) Copyright (c) 2002-2026 www.mailtech.cn
 mispb-8dfce572-2f24-404d-b59d-0dd2e304114c-icoremail.cn
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset=UTF-8
MIME-Version: 1.0
Message-ID: <6b7e2fac.a60e.19b97034116.Coremail.23009200614@stu.xidian.edu.cn>
X-Coremail-Locale: zh_CN
X-CM-TRANSID:BrQMCkA2nuGL9F1pQZz2AA--.15048W
X-CM-SenderInfo: qstqimqsqqliuu6v33wo0lvxldqovvfxof0/1tbiAgUECGlaeE5zG
	AAIst
X-Coremail-Antispam: 1Ur529EdanIXcx71UUUUU7IcSsGvfJ3iIAIbVAYjsxI4VWDJw
	CS07vEb4IE77IF4wCS07vE1I0E4x80FVAKz4kxMIAIbVAFxVCaYxvI4VCIwcAKzIAtYxBI
	daVFxhVjvjDU=
X-Rspamd-Queue-Id: 0378E180002
X-Rspamd-Server: rspam03
X-Stat-Signature: ftg3e1xoh4q4r4wfszgdoqje4uwizugg
X-Rspam-User: 
X-HE-Tag: 1767765143-638536
X-HE-Meta: U2FsdGVkX19e152kTusDun7gqeGgojD/ga/eAvA6cShY6k+kSS8t3uG0DVADwWzPxBooqd2JMqPLgbj0ArIBdfh+rqEHCYFeLc6ef02i2ico9pUwyIPoE6nscFe+zr7fLjbGVmE9NpCzhWgoQ8L9NW012wFaw5ToIwKoTU30Kssf5zvnAFYx9L1Gwvome/Rb6XosIOkgiHR08UFcwyEF7Gm0fTx9G0CIfaHnw92i0U//ILvHpJTmt96iOHlmzjPUUQvp+xicnVg/dybyCu1e85v1p0NfSabD9d+2qfKeSOv3ugEiPkXGr6oEdmUu/DAO1LazvJ/+2S0x/0UJYajvRJ2q3XsEwpQ2dK4U5YGoABRjEKT7Y5RS9B5PjkqtJut4fKLNQU41xolZWQ6mJGx5FlPL25wjKpTezVhpdBWhIkAhaa9Fli9ctb6npmemAIZg1AJGLi0X53Ym9+kIL1q57LmufUZAERnQ7CIS89j15QjMw3+FmtbUmLq1VvBf46E2mb101D7yWzOmQc4235B4pPH907ySU51vgcNWrEX1ykBkqpKktkMeLooqgYLNLCRVAPL/+sT3dEuM9+tI5LaNSZBbzvz9pRDd8Fc4eMqENzKYIbcerwfPBz6KnaoZ0XyQeUX8LMxel4Sn4umbmgXC039fuZeIQyF7NtdmHhvlMXcJN/xJt1bOLP/QGfLllYV9oajVLab+h6xrAF62g2FbEUaKFfgLGWL/odhCr7OBXWSqlBtMtriVFPKbg16CTE69TUz0dIpkqsPzhtj8bh5iEpe87m3vvaZFAb0vg0wEMcBn0RMNqM+G6NEqX0IJun+1mPdBP1V2isgjC+jgYb+Xv08A2bZL/rIrryXVoEbQXZJ6lVrtqCkeoTQsA0Ilg6AmLBl7v4SBMMDQ8yG6whxcyMNY12ZTRtLSTqO51oSNegq7cFk4C3icoYo1sTvauHDWriBTiVpaM5apFqcUgV7
 tS5HkezV
 uTLTWYB7+RvduHcme82tYoI6JL4xVuAaJAzTPz9YtQXnwn1+OGJocoSZRjwgV9euSuXvyTzTZMZBEBlPblxv0vT+mkfOVi9BDjngsIOyBwpzvGCNB22jfusV2pDPYduqQSdjFHlHEfMSYTPWVrFdMhqgeD54KgQwHRBBjXl0w1KHKA6eH7PbzBJLoKnwRfES/h2xMmEwSlxsFNBdDFgoz/BNznj0+4aWENTH71wnzmUj549CG/xEZkHJGM5ahfrNv+WQzsxd1uyEBxeyen4fpoFHKgcCEKkPO+KaSadWbwhVHUWh7GBhRzc4yvPmuZmcUa7HBjyTjgtD2SGX7cPLUH3DQwaVH+ejfe8wJ+SxC/vN8lTZo3Mj2Mu8Ypdfuw6n6NqvzK+l+TfH7l/3is8TUjsdydetmEfqY8HNLGuYxlRmW0A+i9wsfCYu93PQDnJNjtYGMYEzNAlLANjLKfR4wrnCGVTRUP7J+AEQaSj0Pwv+aKYb2++wkfFayVw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

SGVsbG8sCgpJIGFtIHJlcG9ydGluZyBhbiBSQ1Ugc3RhbGwgZGV0ZWN0ZWQgZHVyaW5nIHN5emth
bGxlci1zdHlsZSBmdXp6IHRlc3RpbmcuClRoZSBzdGFsbCBpcyByZXBvcnRlZCB3aGlsZSBleGVj
dXRpbmcgc3lzX21tYXAoKSwgd2l0aCB0aGUKcmN1X3ByZWVtcHQgZ3JhY2UtcGVyaW9kIGt0aHJl
YWQgc3RhcnZlZCBmb3Igb3ZlciAxMCBzZWNvbmRzLiBUaGUKb2JzZXJ2ZWQgc3RhY2tzIGludm9s
dmUgbWVtb3J5IGZhdWx0IGhhbmRsaW5nLCB0aW1lciBzb2Z0aXJxIHByb2Nlc3NpbmcsCmFuZCBE
Uk0gdmJsYW5rIGRpc2FibGUgcGF0aHMuIFdpdGggUFJFRU1QVChmdWxsKSBlbmFibGVkLCB0aGUg
UkNVIGdyYWNlCnBlcmlvZCBmYWlscyB0byBjb21wbGV0ZS4KCj09PSBTdW1tYXJ5ID09PQpUaGUg
a2VybmVsIHJlcG9ydHM6CklORk86IHJjdSBkZXRlY3RlZCBzdGFsbCBpbiBzeXNfbW1hcApyY3Vf
cHJlZW1wdCBrdGhyZWFkIHN0YXJ2ZWQgZm9yIG92ZXIgMTAwMDAgamlmZmllcwpSQ1UgcmVwb3J0
cyB0aGF0IGFsbCBxdWllc2NlbnQgc3RhdGVzIGhhdmUgYmVlbiBzZWVuLCB5ZXQgdGhlCmdyYWNl
LXBlcmlvZCBrdGhyZWFkIGRvZXMgbm90IHJlY2VpdmUgc3VmZmljaWVudCBDUFUgdGltZSB0byBh
ZHZhbmNlCnRoZSBncmFjZSBwZXJpb2QuCgo9PT0gRW52aXJvbm1lbnQgPT09Cktlcm5lbDogNi4x
OC4wIChsb2NhbGx5IGJ1aWx0KQpDb25maWc6IFBSRUVNUFQoZnVsbCkKQXJjaDogeDg2XzY0Ckhh
cmR3YXJlOiBRRU1VIFN0YW5kYXJkIFBDIChpNDQwRlggKyBQSUlYKQpXb3JrbG9hZDogc3l6LWV4
ZWN1dG9yIChzeXprYWxsZXItc3R5bGUgZnV6emluZykKCj09PSBUcmlnZ2VyaW5nIGNvbnRleHQg
PT09ClRoZSBzdGFsbCBpcyBkZXRlY3RlZCB3aGlsZSBhIHN5emthbGxlciBleGVjdXRvciBpc3N1
ZXMgc3lzX21tYXAoKQpjYWxscy4gVGhlIG1haW4gdGFzayBjb250ZXh0IGludm9sdmVzIHBhZ2Ug
ZmF1bHQgaGFuZGxpbmcgYW5kIG1lbW9yeQphbGxvY2F0aW9uOgpzeXNfbW1hcAp2bV9tbWFwX3Bn
b2ZmCl9fbW1fcG9wdWxhdGUKcG9wdWxhdGVfdm1hX3BhZ2VfcmFuZ2UKX19nZXRfdXNlcl9wYWdl
cwpoYW5kbGVfbW1fZmF1bHQKZG9fcHRlX21pc3NpbmcKZ2V0X3BhZ2VfZnJvbV9mcmVlbGlzdApD
b25jdXJyZW50bHksIHRpbWVyIHNvZnRpcnEgcHJvY2Vzc2luZyBleGVjdXRlcyBEUk0gdmJsYW5r
IGRpc2FibGUKbG9naWMuCgo9PT0gV2FybmluZyBkZXRhaWxzID09PQpSQ1UgcmVwb3J0czoKSU5G
TzogcmN1X3ByZWVtcHQgZGV0ZWN0ZWQgc3RhbGxzIG9uIENQVXMvdGFza3MKcmN1X3ByZWVtcHQg
a3RocmVhZCB0aW1lciB3YWtldXAgZGlkbid0IGhhcHBlbiBmb3IgfjEwNDk4IGppZmZpZXMKcmN1
X3ByZWVtcHQga3RocmVhZCBzdGFydmVkIGZvciBvdmVyIH4xMDQ5OCBqaWZmaWVzClBvc3NpYmxl
IHRpbWVyIGhhbmRsaW5nIGlzc3VlIG9uIGNwdT0zClVubGVzcyByY3VfcHJlZW1wdCBrdGhyZWFk
IGdldHMgc3VmZmljaWVudCBDUFUgdGltZSwKT09NIGlzIG5vdyBleHBlY3RlZCBiZWhhdmlvci4K
Cj09PSBDYWxsIHRyYWNlID09PQpDUFUgMyAodGltZXIgc29mdGlycSAvIElSUSBjb250ZXh0KToK
X19sb2NrX2FjcXVpcmUKX3Jhd19zcGluX2xvY2tfaXJxc2F2ZQpocnRpbWVyX3RyeV90b19jYW5j
ZWwKaHJ0aW1lcl9jYW5jZWwKZHJtX3ZibGFua19kaXNhYmxlX2FuZF9zYXZlCnZibGFua19kaXNh
YmxlX2ZuCmNhbGxfdGltZXJfZm4KcnVuX3RpbWVyX3NvZnRpcnEKX19pcnFfZXhpdF9yY3UKc3lz
dmVjX2FwaWNfdGltZXJfaW50ZXJydXB0CkNQVSAzICh0YXNrIGNvbnRleHQpOgpsb2NrX3JlbGVh
c2UKX19zZXRfcGFnZV9vd25lcgpwb3N0X2FsbG9jX2hvb2sKZ2V0X3BhZ2VfZnJvbV9mcmVlbGlz
dApkb19wdGVfbWlzc2luZwpoYW5kbGVfbW1fZmF1bHQKX19nZXRfdXNlcl9wYWdlcwpwb3B1bGF0
ZV92bWFfcGFnZV9yYW5nZQpfX21tX3BvcHVsYXRlCnZtX21tYXBfcGdvZmYKX194NjRfc3lzX21t
YXAKUkNVIEdQIGt0aHJlYWQ6CnJjdV9ncF9mcXNfbG9vcApyY3VfZ3Bfa3RocmVhZAoKPT09IE9i
c2VydmF0aW9ucyA9PT0KVGhlIHN0YWxsIGFwcGVhcnMgdG8gaW52b2x2ZSBhbiBpbnRlcmFjdGlv
biBiZXR3ZWVuOgpzeXNfbW1hcCgpIHBhZ2UgZmF1bHQgYW5kIG1lbW9yeSBhbGxvY2F0aW9uIHBh
dGhzClRpbWVyIHNvZnRpcnEgcHJvY2Vzc2luZwpEUk0gdmJsYW5rIGRpc2FibGUgbG9naWMgYWNx
dWlyaW5nIHNwaW5sb2NrcwpQUkVFTVBUKGZ1bGwpIHNjaGVkdWxpbmcgYW5kIGxvY2tkZXAgaW5z
dHJ1bWVudGF0aW9uClRoZSBSQ1UgZ3JhY2UtcGVyaW9kIGt0aHJlYWQgcmVwb3J0cyB0aGF0IGFs
bCBxdWllc2NlbnQgc3RhdGVzIGhhdmUgYmVlbgpvYnNlcnZlZCwgYnV0IHJlbWFpbnMgc3RhcnZl
ZCBvZiBDUFUgdGltZSBmb3Igb3ZlciAxMCBzZWNvbmRzLCBzdWdnZXN0aW5nCnN5c3RlbS13aWRl
IHNjaGVkdWxpbmcgb3IgaW50ZXJydXB0L3NvZnRpcnEgaW50ZXJmZXJlbmNlIHJhdGhlciB0aGFu
IGEKc2luZ2xlIGJsb2NrZWQgQ1BVLgoKPT09IFJlcHJvZHVjZXIgPT09Ck5vIHN0YW5kYWxvbmUg
cmVwcm9kdWNlciBpcyBjdXJyZW50bHkgYXZhaWxhYmxlLgpUaGUgaXNzdWUgd2FzIG9ic2VydmVk
IGR1cmluZyBzeXprYWxsZXItc3R5bGUgZnV6eiB0ZXN0aW5nLgoKPT09IEV4cGVjdGVkIGJlaGF2
aW9yID09PQpNZW1vcnkgbWFuYWdlbWVudCBvcGVyYXRpb25zIHN1Y2ggYXMgc3lzX21tYXAoKSBz
aG91bGQgbm90IGxlYWQgdG8KcHJvbG9uZ2VkIFJDVSBzdGFsbHMsIGV2ZW4gdW5kZXIgYWR2ZXJz
YXJpYWwgb3IgbWFsZm9ybWVkIHVzZXJzcGFjZQp3b3JrbG9hZHMuCgo9PT0gQWN0dWFsIGJlaGF2
aW9yID09PQpSQ1UgcmVwb3J0cyBwcm9sb25nZWQgc3RhbGxzLCB0aGUgcmN1X3ByZWVtcHQgZ3Jh
Y2UtcGVyaW9kIGt0aHJlYWQgaXMKc3RhcnZlZCBmb3Igb3ZlciAxMCBzZWNvbmRzLCBhbmQgdGhl
IGtlcm5lbCB3YXJucyB0aGF0IE9PTSBiZWhhdmlvciBtYXkKb2NjdXIuCgo9PT0gTm90ZXMgPT09
ClRoaXMgaXNzdWUgaGFzIGJlZW4gb2JzZXJ2ZWQgcmVwZWF0ZWRseSB1bmRlciBmdXp6aW5nIHdv
cmtsb2Fkcy4KQWRkaXRpb25hbCBsb2dzLCBrZXJuZWwgY29uZmlndXJhdGlvbiwgb3IgZnVydGhl
ciB0cmFjZXMgY2FuIGJlIHByb3ZpZGVkCnVwb24gcmVxdWVzdC4KClJlcG9ydGVkLWJ5OgpaaGkg
V2FuZwo=


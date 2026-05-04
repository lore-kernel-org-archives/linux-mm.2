Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B1A92FF885A
	for <linux-mm@archiver.kernel.org>; Mon,  4 May 2026 20:17:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B22536B0088; Mon,  4 May 2026 16:17:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AD35E6B008A; Mon,  4 May 2026 16:17:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9E9106B008C; Mon,  4 May 2026 16:17:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 880296B0088
	for <linux-mm@kvack.org>; Mon,  4 May 2026 16:17:55 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id D5B56160180
	for <linux-mm@kvack.org>; Mon,  4 May 2026 20:17:54 +0000 (UTC)
X-FDA: 84730848468.01.0F4E2DB
Received: from embla.dev.snart.me (embla.dev.snart.me [54.252.183.203])
	by imf20.hostedemail.com (Postfix) with ESMTP id 947D21C0015
	for <linux-mm@kvack.org>; Mon,  4 May 2026 20:17:52 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=none;
	spf=pass (imf20.hostedemail.com: domain of dxdt@dev.snart.me designates 54.252.183.203 as permitted sender) smtp.mailfrom=dxdt@dev.snart.me;
	dmarc=pass (policy=reject) header.from=dev.snart.me
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777925873;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=XBCWx0m8bb3GJusI0mviL4YlaAPRihO9FHtlhisSfT8=;
	b=jDeAbWgtVxoyhYFmTjnNK1AN9M6SKLsjAOCKgRd/7M+3a34ZUbhyUr7EvxgsccGyybG+kp
	Hfu6gVu9WcwvHN5BdsUVAsVAGDDCULZP7XEPpLHrwDBMmx5Fk4cGzpmTl7sSFnDWJB83q3
	hFmAalhYy86ltNGMBGIDSDqvIm0Fhj4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777925873; a=rsa-sha256;
	cv=none;
	b=j5mLc8j5c7efQoIelsCKXnTlYPmg6Ra/GiFC/KI6b9G07aMveGESoz6MYIA4ABDktLU1IK
	pI2rZNhODHDsE85zxld/aJGT75Xqt2RRrR/9GJyLZQkexK+by3n7cph/GupwD7g7AP3hGo
	iqZvxqYF8zwZK96Ksscl8CV8G0gDNQY=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=none;
	spf=pass (imf20.hostedemail.com: domain of dxdt@dev.snart.me designates 54.252.183.203 as permitted sender) smtp.mailfrom=dxdt@dev.snart.me;
	dmarc=pass (policy=reject) header.from=dev.snart.me
Received: from embla.dev.snart.me (localhost [IPv6:::1])
	by embla.dev.snart.me (Postfix) with ESMTP id CF49C1D490;
	Mon,  4 May 2026 20:17:48 +0000 (UTC)
Received: from [192.168.1.18] ([182.226.25.243])
	by embla.dev.snart.me with ESMTPSA
	id kpfYIez++GlJJwEA8KYfjw
	(envelope-from <dxdt@dev.snart.me>); Mon, 04 May 2026 20:17:48 +0000
Content-Type: multipart/mixed; boundary="------------k0h9QtSMARiwiU4a30pozDMq"
Message-ID: <2956b248-c79f-4eae-8bfc-81178b5899af@dev.snart.me>
Date: Tue, 5 May 2026 05:17:44 +0900
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: David Timber <dxdt@dev.snart.me>
Subject: Re: [syzbot] [mm?] [f2fs?] [exfat?] memory leak in __kfree_rcu_sheaf
To: syzbot <syzbot+cae7809e9dc1459e4e63@syzkaller.appspotmail.com>
Cc: linux-f2fs-devel@lists.sourceforge.net, linux-fsdevel@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 syzkaller-bugs@googlegroups.com
References: <698a26d3.050a0220.3b3015.007e.GAE@google.com>
Content-Language: en-US, ko
Autocrypt: addr=dxdt@dev.snart.me; keydata=
 xjMEYmJg1hYJKwYBBAHaRw8BAQdAf5E+ri1XLtjqYbZdHOyc8oS+1/XJ5bSlbx5WHXmVBZzN
 IERhdmlkIFRpbWJlciA8ZHhkdEBkZXYuc25hcnQubWU+wpQEExYKADwWIQQn/Jn96EMUaIoF
 X+T/ldyyrZpWaAUCYmJg1gIbAwULCQgHAgMiAgEGFQoJCAsCBBYCAwECHgcCF4AACgkQ/5Xc
 sq2aVmjJZwD8COjPlUwccrlRvbNQ6f87DWchtYO0o8W2DNRM3RLps0EA/jEhIbRV6AsyC8jr
 30Ut3aJ3/mO/6G4sLj7OvkEEBH0MzjgEYmJg1hIKKwYBBAGXVQEFAQEHQFpgtIgaByv9lIEY
 EmpavMO0pYjtu7TMJynwdnGYkN9LAwEIB8J4BBgWCgAgFiEEJ/yZ/ehDFGiKBV/k/5Xcsq2a
 VmgFAmJiYNYCGwwACgkQ/5Xcsq2aVmhFCwEA0kM9VyYB4bLCM7+SuXUUH+5Ec99Nj4RXxFad
 Key9GuwA/2BZK6bNyrLSfEk2JDRoskqf7OIL0wa6JOD5SrBnMe8E
In-Reply-To: <698a26d3.050a0220.3b3015.007e.GAE@google.com>
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 947D21C0015
X-Stat-Signature: zcje7gtnut5myo4boqxuat3pronnjq1o
X-Rspam-User: 
X-HE-Tag: 1777925872-801713
X-HE-Meta: U2FsdGVkX1/wFxQLhIHPv1BhWna+guO9EPCDYLTSjg/gj+0sR4pCvp32lKWawxMEne7oEyaJBBEYFxCtR7yj4a/lpHxSr/YP+ql6juQ3SipHRSCzpb1jyt1VrloNRqEDrN9Y5ptkuYYh9ihWzyKiUdB1NQYDCmns+Vmf952mboE3Z6XXRbQSTRlysf2daqbDpUl1C+XWehJYAHRn8l5ddOzy1x8pKYp8d4l/kyLLWm2yFVnKIoDzx8oDUG7/lqnAoxx0KfMQEbxObaz8PDP5/SWQ6AMdo157GXpocB7rq4WdSwoPTaoFqrAe20TuiFe4Sjk/KI9TRacafacaq5z635DLbHstkgXVzTjiLcbxB1Oiv454uM5n6m2mD3b352vvwI0ETFmhZYw0zvZH/kz26FT8YdZkFxY7klE+rwL+yvOMabL78lRhFkFNAC9yuZu5VbqTWqaRciV9h5krsj+/W8PqQqCD2rPsg1NqM8IhRjE0Den8ccGPTZPhUDf7QeymPk4KJ2gwQqhGgLIBfoG2gsB0FwmWueuhgXPYxvIt/tBr7WTU0GjvfAymlPkE/0ILW4h1fC3RaYKXfnnGNYE4mK6qj0XNuGXRrev8P+/8KACG48msnhEl2VII913TNw9+zoLV/tbDUoKIHsXcOqkEYkU4uqraNtXhaHB7mUuhZZ4uDtAGOmRU82uUFrvigLd/2gLX/4HutB0scoKdXEnWvwq+MbJiyqM87iJLYuhCUqU9cYtymgCgkkDef5N59k3WtRlBrUln8v4MEyq7kuF7fuQnxL2R42Ih1GjJNVTdpAQ6A5lCPJzq6Z1TXxHXco4Tz2GhbpP4mWH4qSXabFUCn+V2BsCmgSdSqT2ewy6aFRWLXqwMSURNbqoeYWeR/ReW+VJeXHB/5T/F6rKCncVYNevB5GWceIxKHC3q9uvOyqZgPPzzgyJUnwpAigCV8Z6sE9y5DzUipEGrpySU7ua
 iin0vElR
 I3clnpraJVymSikiMA38TnvWRE+lIHDPnK5R3443xgyi+1FNzttBYy/YA7iUFtpGfbgius1E+MxuQeGpr6EB0JpDLdRScCnvD05jqL8avX2z1dG3IPWZTGaZSsTYcS2gOsXQSbDjcA3fRkNtknt8GQFZClLSuFKezbkbBEozJb0cSrduaNSBdRMXsaCaLlCGo7pOO+5OsdaQR+T/pafM+MyYgARkhTaTH+ChGuWnsREwqkIJyDA7TnYManehvIPH9jdElEHoNyNUGLwcRqXi4fm7U1CPHkiw4MMxbsH9+8buaOgnVo7ZuyJs2wlDo3XEdhwrKeLgDgpvEnZRKPUopzRP4kwF0l/z8wjuu3tIQAbjyrJuE3rgetP2gu//Fnr/q2tJ+tCZeUGFkpFya8BFj64LTz4Hw2Hi9Q5jDTw3OrlJlxTfQ/3XTGemH173w6IFI8yx+3/SIRknITcuvwZ/7k5W1+EBE90N2HiJhitBs9Wddt8zC2tAGZhoKo8cgn98DqEgOCWV4ZgWGu083FWoxbRN3NeaKdUd7amIWwjcPL+GDPiUkX7t9e/ghKhPlG392pOzLhtUpeCvyg6UBaB0hYMXSo+rQaQkQGa7wokEnZaWA+u035V77GODOhRiP62zYbkpT0qZX3IGLtRalN6OXbgBDXUw+pagh8aHG87QCZMHaoxfCPYgIwY+5jPwAoQlvz2uX6nvyfIhDfyXPQcPscQeLtIYAgomsQwNQfBJKhJn/ugYtGhc5lBaIgiFnmxj3rsrEsc8/7tEUbnmh4V0wzSHV6g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This is a multi-part message in MIME format.
--------------k0h9QtSMARiwiU4a30pozDMq
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

#syz test
--------------k0h9QtSMARiwiU4a30pozDMq
Content-Type: text/x-patch; charset=UTF-8;
 name="syz-cae7809e9dc1459e4e63.f2fs-use-after-free.patch"
Content-Disposition: attachment;
 filename="syz-cae7809e9dc1459e4e63.f2fs-use-after-free.patch"
Content-Transfer-Encoding: base64

ZGlmZiAtLWdpdCBhL2ZzL2YyZnMvc3VwZXIuYyBiL2ZzL2YyZnMvc3VwZXIuYwppbmRleCBj
NGMyMjVlMDlkYzQuLjVhMzhiNzQ3NTdjYSAxMDA2NDQKLS0tIGEvZnMvZjJmcy9zdXBlci5j
CisrKyBiL2ZzL2YyZnMvc3VwZXIuYwpAQCAtNDU5NSw2ICs0NTk1LDggQEAgdm9pZCBmMmZz
X2hhbmRsZV9lcnJvcihzdHJ1Y3QgZjJmc19zYl9pbmZvICpzYmksIHVuc2lnbmVkIGNoYXIg
ZXJyb3IpCiAJCXJldHVybjsKIAlpZiAoIXRlc3RfYml0KGVycm9yLCAodW5zaWduZWQgbG9u
ZyAqKXNiaS0+ZXJyb3JzKSkKIAkJcmV0dXJuOworCisJZjJmc19ub3RpY2Uoc2JpLCAic19l
cnJvcl93b3JrIHNjaGVkdWxlZCBpbiBmMmZzX2hhbmRsZV9lcnJvcigpIGJ5IHNiaSBhdCAl
cCIsIHNiaSk7CiAJc2NoZWR1bGVfd29yaygmc2JpLT5zX2Vycm9yX3dvcmspOwogfQogCkBA
IC00NjIxLDYgKzQ2MjMsNyBAQCB2b2lkIGYyZnNfaGFuZGxlX2NyaXRpY2FsX2Vycm9yKHN0
cnVjdCBmMmZzX3NiX2luZm8gKnNiaSwgdW5zaWduZWQgY2hhciByZWFzb24pCiAJCSAqIGlu
IG9yZGVyIHRvIGF2b2lkIHBvdGVudGlhbCBkZWFkbG9jayB3aGVuIHJ1bm5pbmcgaW50bwog
CQkgKiBmMmZzX3JlY29yZF9zdG9wX3JlYXNvbigpIHN5bmNocm9ub3VzbHkuCiAJCSAqLwor
CQlmMmZzX25vdGljZShzYmksICJzX2Vycm9yX3dvcmsgc2NoZWR1bGVkIGluIGYyZnNfaGFu
ZGxlX2NyaXRpY2FsX2Vycm9yKCkgYnkgc2JpIGF0ICVwIiwgc2JpKTsKIAkJc2NoZWR1bGVf
d29yaygmc2JpLT5zX2Vycm9yX3dvcmspOwogCX0KIApAQCAtNDY2Niw2ICs0NjY5LDEwIEBA
IHN0YXRpYyB2b2lkIGYyZnNfcmVjb3JkX2Vycm9yX3dvcmsoc3RydWN0IHdvcmtfc3RydWN0
ICp3b3JrKQogCXN0cnVjdCBmMmZzX3NiX2luZm8gKnNiaSA9IGNvbnRhaW5lcl9vZih3b3Jr
LAogCQkJCQlzdHJ1Y3QgZjJmc19zYl9pbmZvLCBzX2Vycm9yX3dvcmspOwogCisJZjJmc19u
b3RpY2Uoc2JpLCAiZjJmc19yZWNvcmRfZXJyb3Jfd29yaygpIik7CisJaWYgKHVubGlrZWx5
KGlzX3NiaV9mbGFnX3NldChzYmksIFNCSV9JU19DTE9TRSkpKQorCQlwYW5pYygiISEhIHNi
aSBhdCAlcCB1c2VkIGFmdGVyIGZyZWVpbmcgISEhIiwgc2JpKTsKKwogCWYyZnNfcmVjb3Jk
X3N0b3BfcmVhc29uKHNiaSk7CiB9CiAKQEAgLTU0NTQsNiArNTQ2MSw3IEBAIHN0YXRpYyB2
b2lkIGtpbGxfZjJmc19zdXBlcihzdHJ1Y3Qgc3VwZXJfYmxvY2sgKnNiKQogCWtpbGxfYmxv
Y2tfc3VwZXIoc2IpOwogCS8qIFJlbGVhc2UgYmxvY2sgZGV2aWNlcyBsYXN0LCBhZnRlciBm
c2NyeXB0X2Rlc3Ryb3lfa2V5cmluZygpLiAqLwogCWlmIChzYmkpIHsKKwkJZjJmc19ub3Rp
Y2Uoc2JpLCAiZnJlZWluZyBzYmkgYXQgJXB4IGluIGtpbGxfZjJmc19zdXBlcigpIiwgc2Jp
KTsKIAkJZGVzdHJveV9kZXZpY2VfbGlzdChzYmkpOwogCQlrZnJlZShzYmkpOwogCQlzYi0+
c19mc19pbmZvID0gTlVMTDsK

--------------k0h9QtSMARiwiU4a30pozDMq--


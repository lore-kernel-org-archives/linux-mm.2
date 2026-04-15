Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6B312F433C5
	for <linux-mm@archiver.kernel.org>; Wed, 15 Apr 2026 21:31:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CD0616B0005; Wed, 15 Apr 2026 17:31:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C80D36B0089; Wed, 15 Apr 2026 17:31:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B49486B008A; Wed, 15 Apr 2026 17:31:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9C6E06B0005
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 17:31:49 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 4C914C22C6
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 21:31:49 +0000 (UTC)
X-FDA: 84662087538.07.628B3A0
Received: from mail-m829.xmail.ntesmail.com (mail-m829.xmail.ntesmail.com [156.224.82.9])
	by imf23.hostedemail.com (Postfix) with ESMTP id A84C8140004
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 21:31:45 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=stu.pku.edu.cn header.s=default header.b=Ehi4Dqg9;
	spf=pass (imf23.hostedemail.com: domain of lty218@stu.pku.edu.cn designates 156.224.82.9 as permitted sender) smtp.mailfrom=lty218@stu.pku.edu.cn;
	dmarc=pass (policy=quarantine) header.from=stu.pku.edu.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776288707;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=aZbUgp64XacVM8lkJi7UE9UxRon+K33kvCQUK3GQR44=;
	b=gsKiKLtBDvU/21mgMLgEVy10dwYycgynWo56FSKLGrrVk7Z+UBmQRk+VpfprylJ7B28HhK
	I0WL4ioHZ+fZj80yY4N4OZ7yOnanrTH2h70d9FQVK2AY2L9aUacWyowdZeEtkd6RL/SF/2
	UxIgRvs8dEdMe6tBPjhk3YFkov9T59Y=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=stu.pku.edu.cn header.s=default header.b=Ehi4Dqg9;
	spf=pass (imf23.hostedemail.com: domain of lty218@stu.pku.edu.cn designates 156.224.82.9 as permitted sender) smtp.mailfrom=lty218@stu.pku.edu.cn;
	dmarc=pass (policy=quarantine) header.from=stu.pku.edu.cn
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776288707; a=rsa-sha256;
	cv=none;
	b=Hi9S2udNCzCwfjwF6D/WyjBUpgfpSYO/htgXB7LAzhTey8C1IYPIzJ4R3ZlFQ6pV8O1QFV
	39x0pJ2ZEuhh3ozxY0CnJ5A1U7Pq0YKz9MqbKWGGhtJEVVrfz4/EyUzmYJNRPsQ/eJPKuJ
	WHF7JqdS6bBqfTtMAvMbVJgNIYPN8pg=
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: base64
Message-ID: <ANkACwCPKD1-dx0ANXSaJ4oj.1.1776288701001.Hmail.2200013188@stu.pku.edu.cn>
To: x86 <x86@kernel.org>, tglx <tglx@kernel.org>, mingo <mingo@redhat.com>, 
	bp <bp@alien8.de>, "dave.hansen" <dave.hansen@linux.intel.com>, 
	akpm <akpm@linux-foundation.org>, rppt <rppt@kernel.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>, 
	luto <luto@kernel.org>, peterz <peterz@infradead.org>, 
	hpa <hpa@zytor.com>, 
	"zhaoruilin22@mails.ucas.ac.cn" <zhaoruilin22@mails.ucas.ac.cn>, 
	xujiakai2025 <xujiakai2025@iscas.ac.cn>
Subject: =?UTF-8?B?W1JFUE9SVF0geDg2L3RvcG9sb2d5OiB3YXJuaW5nIGluIHNldF9jcHVfc2libGluZ19tYXAoKSB3aXRoIG51bWE9ZmFrZT0yIG9uIG5vbi1OVU1BIHg4NiBndWVzdA==?=
X-Priority: 3
X-Mailer: HMail Webmail Server V2.0 Copyright (c) 2016-163.com Sirius_WEB_WIN_1.61.0
X-Originating-IP: 240c:c001:1:2e07:d16d:209a:fff3:5532
MIME-Version: 1.0
Received: from 2200013188@stu.pku.edu.cn( [240c:c001:1:2e07:d16d:209a:fff3:5532] ) by ajax-webmail ( [127.0.0.1] ) ; Thu, 16 Apr 2026 05:31:41 +0800 (GMT+08:00)
From: Tianyu Li <lty218@stu.pku.edu.cn>
Date: Thu, 16 Apr 2026 05:31:41 +0800 (GMT+08:00)
X-HM-Tid: 0a9d9300348909b6kunma0ded70e4e3f
X-HM-MType: 1
X-HM-NTES-SC: AL0_4z5B86Wr4Tz9jdMF+bhXMY6MNbudcqqq4T7UDQ1WJ2OfTd1H/J4vz71Ydu
	XHL3dOVORz55HdhoZZXeicv4a2twxq1tZCKLDzHF2UrjkQ+WWpA2TFwCKpLep5mvyylBEiNAANIU
	DGMKsEX74FlD4ppO2yz/kfzgZFi2yHHFPGS/k=
X-HM-Spam-Status: e1kfGhgUHx5ZQUpXWQgPGg8OCBgUHx5ZQUlOS1dZFg8aDwILHllBWSg2Ly
	tZV1koWUFITzdXWS1ZQUlXWQ8JGhUIEh9ZQVkaQh9IVhgfSR1MSR8eSkIfSFYVFAkWGhdVEwETFh
	oSFyQUDg9ZV1kYEgtZQVlJT0sYQRhLS0pBSkFJHktMQR9KTR9BSUtCGkEdHR1IQU5OSElZV1kWGg
	8SFR0UWUFZT0tIVUpLSEpOTkhVSktLVUpCS0tZBg++
DKIM-Signature: a=rsa-sha256;
	b=Ehi4Dqg9eJUqXmkONvjiElv47+SZYghG4+dLeuBd6GZtSY2yq1eIFt4MPzCQptcKjzwC5yu+7QOM0Jsh0P4w4zjPwrcrZjZ73nlwNe37WD575qosE+4Bq1EGGmK25iF0s8nOc4RElWe/cT6aHcY9qH3ipGAc0kalp3Gvv8GmUSw=; s=default; c=relaxed/relaxed; d=stu.pku.edu.cn; v=1;
	bh=aZbUgp64XacVM8lkJi7UE9UxRon+K33kvCQUK3GQR44=;
	h=date:mime-version:subject:message-id:from;
X-Stat-Signature: xxes6zqtto6rz6dawr4iag51u3crpwhe
X-Rspamd-Queue-Id: A84C8140004
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1776288705-393456
X-HE-Meta: U2FsdGVkX1/pnAeRz3smb0e+YY0PFCuSmcRF7vJq6vZM2Y3cz7/4g1Ev64T+3RP0lfb6gvyGptm20z2P06apIoFRilNnlsZu51SujpGOVtWaxG/m4ybEJwzOHXglmWDOKlAgPZfdpWgLFF1gywNjXP4jxcCcwNyTQfnX210oNdaTPlSrMFdMEnazP7SfWRo8OhJURRiKIUxAJ0CmbffdnQS8mPOake1IdRdLM6WR0DP2+8bcyC/4C91haIT6KOM7jJVnl/o82soha6w0apvxWjazFkOJFM8yUOP3+hwJor7CA8Vs/xxCf4KtfD8p527kn9J3Bpx7xZ/BC4dpIw6xrgFRP0u6qqsIgXLqLPl6Hp8rjQWPP7TaroNwGfTkford53WNDdtUmdmwBs7vn3CkJkyWMzauBAipx+7b3mw83JB53KGZcPCXmqnaJT6CMuCOXaUqRM+GmaHN15FzLWjUQwP1PsUq/Zg9vphmV9GPvCX8NzONxnG1FB4eDdA00/6SVkaEJIfp+shxYvfwTpDRRvh4CohG77m2EQtCY2CFZd7MoGDH9Y0eXiUcOfF0e2+ojl6fmS2ZQC4gqOGdEZdAG2VAQUeGH79PeslGSF6qK0t3PMnbUFpuZdWjW660BjHzHVmiKUnHf4AInUd3SmkIITsKOx07wQQogCWBc27EVQPudc8kDW9UOZYbQV4ySJZJxjhxqeRMCP8Nq7dJPFCfDuWVQL/Wq7jAWZ+3S9Uf5lADcTwHnomojMhIYp0nUMTH0KZx4WUFxQ2G4qkJDTfI48/fh9P60UJoGxa9ENJmzt6vEeywlDIUxS1bksFuvGhDSMAb3w8CoCPvl1Kw+yQxkYW6JIDbwBWMIPrWNyBQn4UUkXggwqSYWMFh7rWHk7i4HvNHFKG3W+FPafWQ6nLDHxGkvFdGUhwy8/urWJCN7CU76XMHvUIJKtsXUzH93MvMk7PpdlAP+wBnhxzjGKA
 ptJ7ZSHX
 Uwf6KMx8nH0gUolYgRLB6bksddr/hrt9IO4XH00AbEWW2MHp9Ebnheo8MnD9qtzbsFAGJpmTQwkBZs0rL2uo+QIR+ja8Vx39w4fCmeuFKBji0AKVXtE+cl+BYa+XiS1oldu9GPx6ArzK9uR2LINasRUh/SwuYAyzJq5++mf6E/+AZTl1K/lFZf/vJ3tFmAfj3JAbG+uCibbOkLXU3CikPr3ZZCgqJqLObGL7lF9zMIE5MjTkYsqwZqE3VPJaxkAdz0lWbtzg3yTSdks/WXqABjqPpxgQMTtWBU5XknhBth29LKNGwM5bnbeHfh3JES1b/WVqpcH/1dUBjY8GCdbiuO7igFmsMd+/KIM0ZzZIhsGC6V1RsXqh+I86NOzRVhTGi5vPGmDRPAtY3ii3wuDQaEmjXJLHLmFiViUKT1DOB5MpDQuJdTeCF0qPdLCw8xH341q/A7nI0H7NNvKQAef+eXmhwjxydWke8j7Vgci3cDfcfwGgk4YDEgyT7XKzAEL0WBEq67Qnt5vet8rnwNBHUocJZAiQ/OEqYdb5CPrXlxiWRiopMZ1uj/tO6/aLtQyNf+ugqHv+XqUYNBv4yDEmWVAu+rEUUDgmSyxMOzkDQCTlDZS8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

SGVsbG8sCgpXZSByZXByb2R1Y2VkIHRoaXMgb24gNy4wLXJjNyB1bmRlciBzeXprYWxsZXItc3R5
bGUgd29ya2xvYWRzLgoKVGhlIGlzc3VlIGlzIGEgYm9vdC10aW1lIHdhcm5pbmcgaW4gc2V0X2Nw
dV9zaWJsaW5nX21hcCgpIG9uIAp4ODYgd2hpbGUgYm9vdGluZyBhIG5vbi1OVU1BIEtWTSBndWVz
dCB3aXRoIG51bWE9ZmFrZT0yLgoKVGhlIHdhcm5pbmcgbG9va3MgcmVwcm9kdWNpYmxlIGFuZCBz
ZWVtcyB0byBjb21lIGZyb20gYW4gCmludGVyYWN0aW9uIGJldHdlZW4geDg2IHRvcG9sb2d5IHZh
bGlkYXRpb24gYW5kIE5VTUEgZW11bGF0aW9uLCAKcmF0aGVyIHRoYW4gZnJvbSBhIHJlYWwgaGFy
ZHdhcmUgdG9wb2xvZ3kgaW5jb25zaXN0ZW5jeS4KCkVudmlyb25tZW50OgotIG1hY2hpbmU6IFFF
TVUvS1ZNIGd1ZXN0Ci0gQ1BVIHRvcG9sb2d5IGZyb20gYm9vdCBsb2c6CiAgTWF4LiBsb2dpY2Fs
IHBhY2thZ2VzOiAxCiAgTnVtLiBub2RlcyBwZXIgcGFja2FnZTogMQogIE1heC4gdGhyZWFkcyBw
ZXIgY29yZTogMQogIE51bS4gY29yZXMgcGVyIHBhY2thZ2U6IDQKLSByZWxldmFudCBjbWRsaW5l
IGZyYWdtZW50OgogIG51bWE9ZmFrZT0yIHBhbmljX29uX3dhcm49MQoKT2JzZXJ2ZWQgd2Fybmlu
ZzoKV0FSTklORzogYXJjaC94ODYva2VybmVsL3NtcGJvb3QuYzo2OTggYXQgCnNldF9jcHVfc2li
bGluZ19tYXArMHgxMjA1LzB4MWYxMApDUFU6IDEgUElEOiAwIENvbW06IHN3YXBwZXIvMQpSSVA6
IHNldF9jcHVfc2libGluZ19tYXArMHgxMjA1LzB4MWYxMCAKYXJjaC94ODYva2VybmVsL3NtcGJv
b3QuYzo2OTgKQ2FsbCBUcmFjZToKIGFwX3N0YXJ0aW5nIGFyY2gveDg2L2tlcm5lbC9zbXBib290
LmM6MTk2IFtpbmxpbmVdCiBzdGFydF9zZWNvbmRhcnkrMHhkOC8weDJkMCBhcmNoL3g4Ni9rZXJu
ZWwvc21wYm9vdC5jOjI4MAogY29tbW9uX3N0YXJ0dXBfNjQrMHgxM2UvMHgxNDgKCkF0IHRoZSBz
YW1lIHRpbWUsIHRoZSBsb2cgc2hvd3MgdGhhdCBOVU1BIHdhcyBlbXVsYXRlZDoKRmFraW5nIG5v
ZGUgMCBhdCAuLi4KRmFraW5nIG5vZGUgMSBhdCAuLi4KCk15IHJlYWRpbmcgb2YgdGhlIGNvZGUg
aXM6CgoxLiBzZXRfY3B1X3NpYmxpbmdfbWFwKCkgYnVpbGRzIFNNVC9MTEMvTDIvZGllIHJlbGF0
aW9uc2hpcHMgCmFuZCBjYWxscyB0b3BvbG9neV9zYW5lKCkgYmVmb3JlIGFjY2VwdGluZyBzb21l
IG9mIHRob3NlIApyZWxhdGlvbnNoaXBzLgoKMi4gdG9wb2xvZ3lfc2FuZSgpIHdhcm5zIGlmIHR3
byB0b3BvbG9neS1yZWxhdGVkIENQVXMgYXJlIG5vdCAKb24gdGhlIHNhbWUgTlVNQSBub2RlLgoK
My4gSW4gdGhlIE5VTUEgZW11bGF0aW9uIC8gZmFrZSBub2RlIGNhc2UsIHRoZSBDUFUtdG8tbm9k
ZSAKbWFwcGluZyBjYW4gYmUgcmV3cml0dGVuIGluIHRlcm1zIG9mIGVtdWxhdGVkIG5vZGUgSURz
LCBldmVuIAp3aGVuIHRoZSB1bmRlcmx5aW5nIENQVS9wYWNrYWdlIHRvcG9sb2d5IGlzIHN0aWxs
IGEgc2luZ2xlIApwaHlzaWNhbCBub2RlLgoKNC4gVGhhdCBjYW4gbWFrZSBDUFVzIGZyb20gdGhl
IHNhbWUgcGFja2FnZSAvIGNhY2hlIGRvbWFpbiAKYXBwZWFyIHRvIGJlIG9uIGRpZmZlcmVudCBl
bXVsYXRlZCBub2Rlcywgd2hpY2ggdGhlbiB0cmlnZ2VycyAKdGhlIHdhcm5pbmcuCgpTbyB0aGlz
IGxvb2tzIGxlc3MgbGlrZSBhIHJlYWwgdG9wb2xvZ3kgYnVnIGFuZCBtb3JlIGxpa2UgYW4gCm92
ZXItc3RyaWN0IHdhcm5pbmcgdW5kZXIgbnVtYT1mYWtlPSAvIE5VTUEgZW11bGF0aW9uLgoKV291
bGQgaXQgbWFrZSBzZW5zZSB0byBzdXBwcmVzcyBvciByZWxheCB0aGlzIHdhcm5pbmcgZm9yIE5V
TUEgCmVtdWxhdGlvbiwgaW5zdGVhZCBvZiB0cmVhdGluZyBpdCBhcyBhIHJlYWwgdG9wb2xvZ3kg
aW5jb25zaXN0ZW5jeT8KCklmIHVzZWZ1bCwgSSBjYW4gYWxzbyB0dXJuIHRoaXMgaW50byBhIHNt
YWxsIHBhdGNoIG9uY2UgdGhlIApwcmVmZXJyZWQgZGlyZWN0aW9uIGlzIGNsZWFyLgoKVGhhbmtz
Lg==


Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 37407CD3427
	for <linux-mm@archiver.kernel.org>; Mon,  4 May 2026 20:26:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5D7BC6B0088; Mon,  4 May 2026 16:26:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 588656B008A; Mon,  4 May 2026 16:26:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 49F566B008C; Mon,  4 May 2026 16:26:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 3EC2F6B0088
	for <linux-mm@kvack.org>; Mon,  4 May 2026 16:26:10 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id DB048140208
	for <linux-mm@kvack.org>; Mon,  4 May 2026 20:26:09 +0000 (UTC)
X-FDA: 84730869258.18.2A37DC9
Received: from embla.dev.snart.me (embla.dev.snart.me [54.252.183.203])
	by imf12.hostedemail.com (Postfix) with ESMTP id D60B04000C
	for <linux-mm@kvack.org>; Mon,  4 May 2026 20:26:07 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=reject) header.from=dev.snart.me;
	spf=pass (imf12.hostedemail.com: domain of dxdt@dev.snart.me designates 54.252.183.203 as permitted sender) smtp.mailfrom=dxdt@dev.snart.me
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777926368;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=5wLVemXqI5XtogvSMfyxXKUc5BMAPV85CSbBsm7nmCU=;
	b=5SSLtI14KPqjjddY3dsGwH1U9oA8B9j5AThdCdkTE4fM+27V7twQPPlfZsvmLpKsKH5AFk
	Fwgaw9yF2PiryJkOv2jSPDjgK7XWuCU5ZewEznaJvTtmMFkGZCHk3TZ+cp9O+7hfR2MrqV
	JBZOSkDKFMXf5AW3/l+ueOysrQkl6/E=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=reject) header.from=dev.snart.me;
	spf=pass (imf12.hostedemail.com: domain of dxdt@dev.snart.me designates 54.252.183.203 as permitted sender) smtp.mailfrom=dxdt@dev.snart.me
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777926368; a=rsa-sha256;
	cv=none;
	b=e0tJ4R7weiEs6QxUwiEiVQJJxT6gnV4usMTWJrscToQLn7LidexLIPNgVuRoMzFZCwJgTO
	OL6vUVBu2P/G22t1iKPZ6opM5YMUaj9wjmrDDLEftfqQvAwCzUIDw97fO7AllO2XQ9fFgz
	eQP7I2iCn/ycnpLL8X39+5H+whaHPTg=
Received: from embla.dev.snart.me (localhost [IPv6:::1])
	by embla.dev.snart.me (Postfix) with ESMTP id 683EC1D490;
	Mon,  4 May 2026 20:26:04 +0000 (UTC)
Received: from [192.168.1.18] ([182.226.25.243])
	by embla.dev.snart.me with ESMTPSA
	id lSeiCNwA+WnyJwEA8KYfjw
	(envelope-from <dxdt@dev.snart.me>); Mon, 04 May 2026 20:26:04 +0000
Content-Type: multipart/mixed; boundary="------------SgzrhKw02r9lKy3Uyqq9E2Ky"
Message-ID: <13bb1c13-98b6-4a4a-b03d-ba0f88680f1e@dev.snart.me>
Date: Tue, 5 May 2026 05:26:03 +0900
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
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: D60B04000C
X-Stat-Signature: rynd9uhz6m9zrjz8p3zto49xmdtoe8pp
X-HE-Tag: 1777926367-911464
X-HE-Meta: U2FsdGVkX18Imyfpbwa+bzzTpBZbFuZtzgipn76A952THc55LY02Hlx3Mn6A7vS3xIv5PRQQ1OHdYfWF5LIXuPYGa7NOywy2DDRYkyFCKvmgbEZhzUND5FVyxYXjZRam37BeJgSouAUhh9agrfdVhtymKzUIQgMHd9h0LP0BoE3O0VJvw4MR0Oq9O1JyFXuCQQ2XtVrt/osFuRiM1mi7sd8Zz+gNG67frtp9rn1HAI3fAcb8ZJs5NirONUVTAMWJLNkT5yP8T1BwtZAn2q4J0P8jcLqKOCxxrDcmKdXYEqP6I3Yj8haM/SwuCQdNf0enYstIEo7FjINYVf0C2mkpGw128pxug50Cwjkj4vBK/naahuk+KiFCFEPElk8zmCaHVgpahNlPKyvkQfZAflCvR60wSixUCTUaDnTU5mWTTopUR2pnv73iWw9AfcIeRR4ikZFg19WWu5yc0CwVbYxMQDKcBiUwZaHhgySdA5NGaMxeBs36+2XGbBp//5ii1CfZQTYA/q8J9hSZKVhrzp9HIn+ngOXGC408bdQdFGm3ztYJHO44QtlREHhP564WhoWgbgxx7Kjb4H9ExW1zmOQaDsdIh5QG9EI9V8xeVL/vgK5LJ+UBKaqRoYqpmMofz2aflxvj3dJeq6haIAYUXjSMs9BDrCgZ3EacCko1IuyzZcIdX2sYjzacdlYgF7RquXm3k4V59SE8E6tUbwXEeNg2/tQfbVFmM2z+XA2tnIbfHww77OW/w3cAKtQHQim11A4WZEfsY+4Kc/dSB3ByNq4AswofU1mFc4AL+nNGLSIaML7tGm3fgnn3xS/7VFM3n/AaI7B13hfzIfJx9B7HqXHKCG4GJJ91y4ijotQxTw3lrD6LXGrPQtZebfIyyfVK4maN69ygu1t4qX9EAmPYEXsp1/ziJYbvIxrDQp0PNBEcFSlpbHhx3sVt71KyB+bnXiUaY8+MVuJUQuiPluAhzR0
 wovmQ6jm
 MZxObcdPhc9A2ciqdxuRCy4fV2XcUbfTasLim6k06QOK4d9oMbtUzWw8H1iDsvydIXUdtmmQIEN9pa+4LW33Fbsrx0hjJb20kiL4W2Ko+ru7EpmegfL2tfPaSk10kBSxENMwdjdbdGmc9ZMSEoHjncDvEoJY0fQyKI/gTeEEU3ApXE2/l31S9Nizg0gyHZfwxee2k0yC1SmEvzE2ykx1Fk/PTG49zU+jvC2O/JLwc6z/RXC26nkN47WutWnHp2CCUFrQSczV4EVwVHynw3im6zReUpbH5jwZBoPlJnZOHnHCggmyzSFG9U9lFEWPukclRp5OpBjyJMOWVeonqwqs02LQ7+9UzaKCddblsxR4S6lDnObsZsY8dTUHzWMtT3l498I0Fz/ccmkZPM7fo1Umqvax9k8ZVxlNnk8z1gMrD0KEYhzsGoAk02FaS/zbyfbr0k9kdkCodPSJdUY5+PLVV7skwk1ofXQSRYnNDGFF1e2LwxE+pAT5kT8UTChbcbVsNIyp0waC8ul6/KiuXtCoShPo2793E9DMY7jqT18n67teFEiktzdI2j81k7TnjUCHRqbhY87hz1a0lLuQKUifwb9dtMm5Uj1zsH2nsiYf5lQNYS6vJCCl3G8RtGzHde7goHyuZFA3lAMPiGCH9XffFP3mvqTEzktF43a52bslsVMiRyupD8/+OMVMgA+YdzIzRszWQnpNxt3fIfdICpvfRxabd7XGAaCfRZbxKUdDQMahAXB5qRkQfgb7gMq9NFOZNJQTV+wRpqFPcQrblVr5vz5prL5F7vEObxpruZtumNKpfnmvro7r3oXD2yw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This is a multi-part message in MIME format.
--------------SgzrhKw02r9lKy3Uyqq9E2Ky
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

#syz test
--------------SgzrhKw02r9lKy3Uyqq9E2Ky
Content-Type: text/x-patch; charset=UTF-8;
 name="syz-cae7809e9dc1459e4e63.f2fs-dont-use-after-free.patch"
Content-Disposition: attachment;
 filename="syz-cae7809e9dc1459e4e63.f2fs-dont-use-after-free.patch"
Content-Transfer-Encoding: base64

ZGlmZiAtLWdpdCBhL2ZzL2YyZnMvc3VwZXIuYyBiL2ZzL2YyZnMvc3VwZXIuYwppbmRleCBj
NGMyMjVlMDlkYzQuLjdhYmE5OWUxZjkzZiAxMDA2NDQKLS0tIGEvZnMvZjJmcy9zdXBlci5j
CisrKyBiL2ZzL2YyZnMvc3VwZXIuYwpAQCAtNDU5NSw2ICs0NTk1LDEyIEBAIHZvaWQgZjJm
c19oYW5kbGVfZXJyb3Ioc3RydWN0IGYyZnNfc2JfaW5mbyAqc2JpLCB1bnNpZ25lZCBjaGFy
IGVycm9yKQogCQlyZXR1cm47CiAJaWYgKCF0ZXN0X2JpdChlcnJvciwgKHVuc2lnbmVkIGxv
bmcgKilzYmktPmVycm9ycykpCiAJCXJldHVybjsKKworCWlmICh1bmxpa2VseShpc19zYmlf
ZmxhZ19zZXQoc2JpLCBTQklfSVNfQ0xPU0UpKSkgeworCQlmMmZzX3dhcm4oc2JpLCAiZjJm
c19oYW5kbGVfZXJyb3IoKSBjYWxsZWQgdXBvbiBzYl9wdXQiKTsKKwkJcmV0dXJuOworCX0K
KwogCXNjaGVkdWxlX3dvcmsoJnNiaS0+c19lcnJvcl93b3JrKTsKIH0KIApAQCAtNDYyMSw3
ICs0NjI3LDEwIEBAIHZvaWQgZjJmc19oYW5kbGVfY3JpdGljYWxfZXJyb3Ioc3RydWN0IGYy
ZnNfc2JfaW5mbyAqc2JpLCB1bnNpZ25lZCBjaGFyIHJlYXNvbikKIAkJICogaW4gb3JkZXIg
dG8gYXZvaWQgcG90ZW50aWFsIGRlYWRsb2NrIHdoZW4gcnVubmluZyBpbnRvCiAJCSAqIGYy
ZnNfcmVjb3JkX3N0b3BfcmVhc29uKCkgc3luY2hyb25vdXNseS4KIAkJICovCi0JCXNjaGVk
dWxlX3dvcmsoJnNiaS0+c19lcnJvcl93b3JrKTsKKwkJaWYgKHVubGlrZWx5KGlzX3NiaV9m
bGFnX3NldChzYmksIFNCSV9JU19DTE9TRSkpKQorCQkJZjJmc193YXJuKHNiaSwgImYyZnNf
aGFuZGxlX2NyaXRpY2FsX2Vycm9yKCkgY2FsbGVkIHVwb24gc2JfcHV0Iik7CisJCWVsc2UK
KwkJCXNjaGVkdWxlX3dvcmsoJnNiaS0+c19lcnJvcl93b3JrKTsKIAl9CiAKIAkvKgo=

--------------SgzrhKw02r9lKy3Uyqq9E2Ky--


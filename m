Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8F539FF885A
	for <linux-mm@archiver.kernel.org>; Sun,  3 May 2026 06:00:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 741A56B0005; Sun,  3 May 2026 02:00:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6F3026B008A; Sun,  3 May 2026 02:00:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 607F66B008C; Sun,  3 May 2026 02:00:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 4B9C36B0005
	for <linux-mm@kvack.org>; Sun,  3 May 2026 02:00:25 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id CAF7B1406DD
	for <linux-mm@kvack.org>; Sun,  3 May 2026 06:00:24 +0000 (UTC)
X-FDA: 84725058768.06.3AC5177
Received: from embla.dev.snart.me (embla.dev.snart.me [54.252.183.203])
	by imf21.hostedemail.com (Postfix) with ESMTP id 982BC1C0016
	for <linux-mm@kvack.org>; Sun,  3 May 2026 06:00:22 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=none;
	spf=pass (imf21.hostedemail.com: domain of dxdt@dev.snart.me designates 54.252.183.203 as permitted sender) smtp.mailfrom=dxdt@dev.snart.me;
	dmarc=pass (policy=reject) header.from=dev.snart.me
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777788023;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=wO8rjCYdIBcW/Y7koahzQo+OytF/YnJYooGQ+ycDZ4w=;
	b=MIQNOK9clO03BSikEOXbtZV4y3WVUMJ+fEiBeIgCGwqHFW6YnSZlN/dn0Feu9Q+ozwO2uk
	NGRiuhHrH/pb+cxZxOAD35YUqCgPZZkEjwGdEOTWlR3cbo7Fjpr9av1BlgLAgmx263EqB9
	Q/taN2AFOZxmbsOeAPxv85SAL4NqsgM=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=none;
	spf=pass (imf21.hostedemail.com: domain of dxdt@dev.snart.me designates 54.252.183.203 as permitted sender) smtp.mailfrom=dxdt@dev.snart.me;
	dmarc=pass (policy=reject) header.from=dev.snart.me
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777788023; a=rsa-sha256;
	cv=none;
	b=XwlwXKOG74V8RSgzT9LFyD1YLfLvqXCWY0yxB71ChmQWnXzb36XIov1F5qOfEAfLW+qO11
	1ocWbDjLTCki9NXNw45RCojFaHeZ+ewzttsl4+U3aGSd58d0Mga3JI9mRcqyLirh9peSv1
	gvoElKYS7fVSuCHnMq/m0ZF2KgQGwsw=
Received: from embla.dev.snart.me (localhost [IPv6:::1])
	by embla.dev.snart.me (Postfix) with ESMTP id B5BC91D490;
	Sun,  3 May 2026 06:00:18 +0000 (UTC)
Received: from [192.168.1.18] ([182.226.25.243])
	by embla.dev.snart.me with ESMTPSA
	id 1TKCGXLk9mlxkwAA8KYfjw
	(envelope-from <dxdt@dev.snart.me>); Sun, 03 May 2026 06:00:18 +0000
Content-Type: multipart/mixed; boundary="------------GQoHdbbTEYRjJyiNyC5SxWyd"
Message-ID: <4b30ba28-6f75-43a1-a108-5c0288ab021a@dev.snart.me>
Date: Sun, 3 May 2026 15:00:14 +0900
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
X-Stat-Signature: 8r6uzf4zosdpxp7r1ikpsmnitu7r5yrm
X-Rspamd-Queue-Id: 982BC1C0016
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1777788022-343900
X-HE-Meta: U2FsdGVkX19ylyjE/5eb2Tj0rKMFh1xRPAwK3umcBElbObE8Hs+LtwPSZ3pcHAeCUSLPYWTMReOtMy5xzO6wm95gyODxjMDN2IM9qtDDZ3FleOzIg99lxlHwAibuWMHu2OH45s2gUl8tXT5qFxx2MT3DHF5QLwh6+TcClJCMUXoysmVTTGzJSz/bY5rmepdL6vDctc4iXyYpD5lJ1he1HgY0lqyX4Zy1QB6kzGvHhgZJGSSo4IEk7Q59dsLkf6EtlJd63KbRCv7ARXabVUwwvqeD3rXkLcWq5mHT+Ktw2i0Ril5ycEb00Kf5QEkIEsNsLnRkkwlg817WYvvM8wfv5UGR41I9IbydmJdlF2yaNOy2XYLqdHdJJC/PnbK1mSsUqPCJ8H0qI8GBMqhY/lx1Gf3YjeTNznxD+4xBawPrENsJeNR497aZaW1ezoITVPvdGfBWhyudhHMcdVH7/tFn90gDh5wGgVCF2Pd0URAOFuWmKOI4ruPuoUu87SaqvxFZyiXeFxk95JVnAL5AY5vIJjK61ORfO+ySyLaAGUwBcVRSyUNqa4qSQHbI0GocsfFbS/P2QJAFWcVy+I3fnN8yNaGEFcZdx7fKiBlHVnOhfUPReQcaii1n7Xw0j7SojGgHXBHpl1sQu99sOdVrbHPSWHqwwrleRaaVuDzmRkFXpd1NWbU1c0ck6OTWSPtaUlZHntE/tLSI6u+eYtx+H6ZPeX0lgk5tYpFBBvwpyS/3IKLvzkureKqHnxQkqyl0X9HjEm0Mzn32GiLxy0s2wCvDVtSpL6ANh76qveic562l07spAYgVfw8++aB9BfFHk1Fk/nwiusDJTgxxdhhR2ZCCBRy7FeNWMV5zPMwr6U+E8TOYaLTjbIF0myKe4X3vGRTD4sSt5tTMJwJfp+39vsptHSnQwmX5IhNinyfyYi9AJFkeZMikFUr95iahkEEuiVNkc9pgL98mcNoFOQfJjaW
 NFAIIMLB
 fz7mMdKIhW1RGzrjZJv1wBmWq5qOa4bYvIknnhiGGUARVYQDKXxBZ9xF5xzOGv4UA/ixVTB/kQQ4xFyTeuplNiVaVz1Z5LNQi8FOWodcOI049Oktat3pBKeywL3hcBeZAPXamzdAxBlMAvItxav/j557lxt02yf3poz64zFysvAIowqd34YPCsjOENLVlp4R6nOEwrzdDikSC/1hEz0rD2B3MFown5IuibJ2DTCQKtMM4Fy8g7NW8Msr/QVUTg+7GPXRAf765OQFQBNRy75KBPoiWuGNKcuWL4S3M0YKyQybBZgcGUFpXQCfrlUb/lvYo+05eAZhnNTrDUYMJ2UJhpi2kL2X+Httyi9/Mm8Fk/vawF7y9aEE+NSAhOhkD3Sz25zEizHotV84g1a9tLodM4pL4Ccpl1Rjar5iGTWWNzjTXLdiCx9YoaysqZ1X4QUc7CVoQdGioVAPcH6Dw6d90oASuHJFQ02ZJ6vHPxHi0z3zY/HP5Hud8KrHfTArmBQLDTID5GG4KC/jB0OWfeeM/wQnQ1Ba/7fICeLKqT2oBG4CX1y3qzUw6xZjuVsTMSZ9H00NsCFz3B5cUFKIDTSAqupdgEE0sFd5DpTGe7jIKBBinsXvLV3C71ykicm01ZaUW8+9smwJ6A7mY2RFa76eOyIkYIkjL60CXNZaBdu5zs/HBhaVSjngEMkJWpV22MynI8Hcmxee81Ri1vgbyzFzznU5jTMEsRZQkFUn8WwQwmd4q9pgevHcJf5cCHb8ZWF7L0cWylMo1x81St09wzpaCiatTUh9xWhaZn+5oIewmzv/TmRZl+cN+Rfc+IXGk4LzAjYoTwaBELiBF0fc0yxXvpsqDYg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This is a multi-part message in MIME format.
--------------GQoHdbbTEYRjJyiNyC5SxWyd
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

#syz test
--------------GQoHdbbTEYRjJyiNyC5SxWyd
Content-Type: text/x-patch; charset=UTF-8;
 name="syz-cae7809e9dc1459e4e63.patch"
Content-Disposition: attachment; filename="syz-cae7809e9dc1459e4e63.patch"
Content-Transfer-Encoding: base64

ZGlmZiAtLWdpdCBhL2ZzL2V4ZmF0L3N1cGVyLmMgYi9mcy9leGZhdC9zdXBlci5jCmluZGV4
IDk1ZDg3ZTJkNzcxNy4uZGYxMGQ5YTc5YTI5IDEwMDY0NAotLS0gYS9mcy9leGZhdC9zdXBl
ci5jCisrKyBiL2ZzL2V4ZmF0L3N1cGVyLmMKQEAgLTY1Niw2ICs2NTYsNyBAQCBzdGF0aWMg
aW50IF9fZXhmYXRfZmlsbF9zdXBlcihzdHJ1Y3Qgc3VwZXJfYmxvY2sgKnNiLAogZnJlZV9h
bGxvY19iaXRtYXA6CiAJZXhmYXRfZnJlZV9iaXRtYXAoc2JpKTsKIGZyZWVfYmg6CisJZXhm
YXRfZnJlZV91cGNhc2VfdGFibGUoc2JpKTsKIAlicmVsc2Uoc2JpLT5ib290X2JoKTsKIAly
ZXR1cm4gcmV0OwogfQpAQCAtNzUyLDYgKzc1Myw3IEBAIHN0YXRpYyBpbnQgZXhmYXRfZ2V0
X3RyZWUoc3RydWN0IGZzX2NvbnRleHQgKmZjKQogCiBzdGF0aWMgdm9pZCBleGZhdF9mcmVl
X3NiaShzdHJ1Y3QgZXhmYXRfc2JfaW5mbyAqc2JpKQogeworCWV4ZmF0X2ZyZWVfdXBjYXNl
X3RhYmxlKHNiaSk7CiAJZXhmYXRfZnJlZV9pb2NoYXJzZXQoc2JpKTsKIAlrZnJlZShzYmkp
OwogfQo=
--------------GQoHdbbTEYRjJyiNyC5SxWyd
Content-Type: text/x-patch; charset=UTF-8;
 name="syz-cae7809e9dc1459e4e63.f2fs-crippled.patch"
Content-Disposition: attachment;
 filename="syz-cae7809e9dc1459e4e63.f2fs-crippled.patch"
Content-Transfer-Encoding: base64

ZGlmZiAtLWdpdCBhL2ZzL2YyZnMvc3VwZXIuYyBiL2ZzL2YyZnMvc3VwZXIuYwppbmRleCBj
NGMyMjVlMDlkYzQuLmZkMjQ5OWZlMTU2YiAxMDA2NDQKLS0tIGEvZnMvZjJmcy9zdXBlci5j
CisrKyBiL2ZzL2YyZnMvc3VwZXIuYwpAQCAtNTM4OCw3ICs1Mzg4LDEwIEBAIHN0YXRpYyBp
bnQgZjJmc19maWxsX3N1cGVyKHN0cnVjdCBzdXBlcl9ibG9jayAqc2IsIHN0cnVjdCBmc19j
b250ZXh0ICpmYykKIAogc3RhdGljIGludCBmMmZzX2dldF90cmVlKHN0cnVjdCBmc19jb250
ZXh0ICpmYykKIHsKLQlyZXR1cm4gZ2V0X3RyZWVfYmRldihmYywgZjJmc19maWxsX3N1cGVy
KTsKKwlpZiAodHJ1ZSkKKwkJcmV0dXJuIC1FTk9NRU07CisJZWxzZQorCQlyZXR1cm4gZ2V0
X3RyZWVfYmRldihmYywgZjJmc19maWxsX3N1cGVyKTsKIH0KIAogc3RhdGljIGludCBmMmZz
X3JlY29uZmlndXJlKHN0cnVjdCBmc19jb250ZXh0ICpmYykK

--------------GQoHdbbTEYRjJyiNyC5SxWyd--


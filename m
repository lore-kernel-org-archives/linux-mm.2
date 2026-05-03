Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AED4FFF886F
	for <linux-mm@archiver.kernel.org>; Sun,  3 May 2026 06:05:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E00406B0005; Sun,  3 May 2026 02:05:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DB1C96B008C; Sun,  3 May 2026 02:05:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CC5AF6B0092; Sun,  3 May 2026 02:05:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id BCE216B0005
	for <linux-mm@kvack.org>; Sun,  3 May 2026 02:05:23 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 59D1F1C0670
	for <linux-mm@kvack.org>; Sun,  3 May 2026 06:05:23 +0000 (UTC)
X-FDA: 84725071326.16.B7BF5FC
Received: from embla.dev.snart.me (embla.dev.snart.me [54.252.183.203])
	by imf21.hostedemail.com (Postfix) with ESMTP id 582801C000D
	for <linux-mm@kvack.org>; Sun,  3 May 2026 06:05:21 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=reject) header.from=dev.snart.me;
	spf=pass (imf21.hostedemail.com: domain of dxdt@dev.snart.me designates 54.252.183.203 as permitted sender) smtp.mailfrom=dxdt@dev.snart.me
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777788321;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=J8c7SmBQ01EtqJJQTtwM21E2eMDYKtcol6ObEcRtRhQ=;
	b=zkRU3du1MFJ0FldmJGF6cXD/H+E/DtsPiT00VY0hFo5at1QTQdeCY04106pAPSI7loXw6w
	Z3bbTmKUS41O9X6b+J5oVlcrBjmPLATDLzQoLcAiIqQeuJZpAA5aEewE29B35foMGJVCle
	CFD5DdTnXg3D/8oIDshdW9mEIZ/cpCw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777788321; a=rsa-sha256;
	cv=none;
	b=fzt9gjUdST6enyRRJiiPbETxhvEj1yRr5GHGf+aDhH669SYkZ99Wq6/f6Z3RWjZp6wtD9D
	F47tqbiyEL0rlnXvsoqd009zeAjaeL8xFbBy9pQQwyD1ivH6DHjtUFm6eK3utXqCZwlvN7
	oZrsCzHGoUKa0FvrZDfKkHGAjRrYah4=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=reject) header.from=dev.snart.me;
	spf=pass (imf21.hostedemail.com: domain of dxdt@dev.snart.me designates 54.252.183.203 as permitted sender) smtp.mailfrom=dxdt@dev.snart.me
Received: from embla.dev.snart.me (localhost [IPv6:::1])
	by embla.dev.snart.me (Postfix) with ESMTP id 0785A1D490;
	Sun,  3 May 2026 06:05:17 +0000 (UTC)
Received: from [192.168.1.18] ([182.226.25.243])
	by embla.dev.snart.me with ESMTPSA
	id jrXWKp3l9mnSkwAA8KYfjw
	(envelope-from <dxdt@dev.snart.me>); Sun, 03 May 2026 06:05:17 +0000
Content-Type: multipart/mixed; boundary="------------EE7yNjuyaUTamfcM6BvJA0BI"
Message-ID: <e50ceb6c-4239-4009-9578-51ece89fdc77@dev.snart.me>
Date: Sun, 3 May 2026 15:05:16 +0900
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
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 582801C000D
X-Rspam-User: 
X-Stat-Signature: 838ei1mxpmbqncoaz4111khn5fzb1c1r
X-HE-Tag: 1777788321-994158
X-HE-Meta: U2FsdGVkX1/qdlLquZYE8onDKXGFn4azwafDAxqLDy+2BFdEWX05tnbR0Tio8BnGxDrKpr54+5yo+wLGfkQjn0JX02VG+g92t4s9dukInMxTG67hNHaP+ysVmXM6EQ9UNS7QQWGQrL2MefxZR4ki8M34R4okzLg0MHKNRlP/bT6MkJF7T3nyQ0JX/01wfATrI3kqmF7NR1v1IJ7psmw4t1WkRUwwhZQTEZB//Jx06/juFLYopcJybvNjJKiolethDEG3NWPw/5sVgWVW+OrsnV1iLekiML6A9TqYKdjpTzud6PAeH+a7ArG/HOfdZJTVNRE4lujjoKYgJaQXOskXrrUfLEzf4mJ6o8Lr00R/tq9X3GOlQ7IaV6mTav6brpAWAPSRwns2J9IMsJgG7dyH3Ih3W7/72SLrnJkTv60lLw4dnWugZcOErS+sUooftLPSQWTiFq/cZ4WgAG1dpIGelMv6L0FFQu+8Z1Pdldr7ssecBdbWLO+nZSJHdEA0+6Huait/H5I1c3jJH2kFGilh0aMf8QrOL3PJYg2Fm1oXz9LDThP3hNflRw6CpJjPmwClOiQM7h6mshXpwEZSj6z5Xc5fwNOpg1PfRRSHBO6fNUqdJhL3XZxcLMgTSQP9hg6U/aeeaD+BIyRmZVClGyl4JeabzzBN9CNz5Sbp/LE1G9x8ibNsJwYIlbRkajw7/VcoMluzyqghyPq/AlJzej2+AGoosA/n5YXQtDQL3U0ssWi/j3Ex/u77U95Jt4ZX2RhsYBillzUb6DDIiiLvopHg4NgIcTIBKjyfkpq/TF72t5FqdLHlFaN7p4jRzVqGnz6rA27mNPsldardXOg8zIxI9SR4TvOGCR/LswFNsjYk7qWybANStNtw3bB2YVxFpU/NrOAIQSxDomGnAq8v44TPG1F++6/WHwHnS+mshFTN2RdYiC2MLrb1POoouNbuJlhJs5z/SSg25noQ4AbhYRj
 7Bf/TuC/
 Eoi2BJcHtNhwyO3SBkt6roigbHftndpm/8aMWndCB2zRKGEk2qKLUiQKNLRAbzVSr69P/sGUr0KDnw+FN1Pmx1OhsSW4eGMHPC1wZQVuEzfX6+lT7hsLrfeDMAhJ5exheifEUwh1PfMxexuPaSgHYtziYRF4UgqvDBfKHrAH29GJDakMGH2JWbpkIZGq1KI6/iiB7HfW4qlG64fHUyy7XtUEaXYrH2ZdQacgLepSttHyuWnI4oc7rThl9cV5P3U52YF3yJGaByAXOTW9SXXr1okOTjew6Jpsu+uhOagbeN1L1Eo8cmUqVrYHAS3gYsTOuPMB0Pzxrn5yVoLFCyFJot1xhkaZRGjs/oRPz+T27zj/Kntne7GEa768ENpL/W/9nNouNs2kp2FEMaiY3pVHwcE2Z0EfKB03zuKm4+EfjHyYsr1qIAdO4d7oVlDVt5pS1ooUPLlfTLb6d9FEBhxw8lbMB1PIvXBsUhmRZVIYiBpa74aoo746fLJyeThmcg1DNhGbe+het1/uoeDr/B0vpyjXKry/MWMh8QHi+8TbSTdswh/2fSppPam8aH/vd2aYADb6P+HG6ecSWJbsUe6+KZCVwY62J40CwbjePrqJ5Zsc8vn+VQDQ/+NiSHTE5FrFaEvW9haq6PdFim8bnplidyjx+FQ6H/SqK/1UzRDP9gMTmvGqsRE4YRhtDCwL8GQpV7pDCt+wJJgp800xuYmipD0e4bw2ly0vQBAzFfL8/ZNpos0Od+7hPVEk/BesGuFli2vYltgY72Dg2agMveU9lCAaDdp8g1SwbMKfr3kx+gfzDjZiFoItrwhN/BA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This is a multi-part message in MIME format.
--------------EE7yNjuyaUTamfcM6BvJA0BI
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

#syz test
--------------EE7yNjuyaUTamfcM6BvJA0BI
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

--------------EE7yNjuyaUTamfcM6BvJA0BI--


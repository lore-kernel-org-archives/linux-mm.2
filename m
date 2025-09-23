Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 978E2CAC5AC
	for <linux-mm@archiver.kernel.org>; Tue, 23 Sep 2025 14:57:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A9C728E0005; Tue, 23 Sep 2025 10:57:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A4D2A8E0001; Tue, 23 Sep 2025 10:57:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 915218E0005; Tue, 23 Sep 2025 10:57:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 79D0D8E0001
	for <linux-mm@kvack.org>; Tue, 23 Sep 2025 10:57:41 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 3E0351A02CB
	for <linux-mm@kvack.org>; Tue, 23 Sep 2025 14:57:41 +0000 (UTC)
X-FDA: 83920819122.05.B2ABBAA
Received: from out203-205-221-231.mail.qq.com (out203-205-221-231.mail.qq.com [203.205.221.231])
	by imf05.hostedemail.com (Postfix) with ESMTP id 44F7E100012
	for <linux-mm@kvack.org>; Tue, 23 Sep 2025 14:57:37 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=qq.com header.s=s201512 header.b=dgrlkJ3s;
	spf=pass (imf05.hostedemail.com: domain of shengminghu512@qq.com designates 203.205.221.231 as permitted sender) smtp.mailfrom=shengminghu512@qq.com;
	dmarc=pass (policy=quarantine) header.from=qq.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758639459;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=H/DoxZF7P4nKqwBqst7vh1I9d9VymNgrxJ0Xnlc4ZXo=;
	b=3FqZ9LMOsWgDLFjIM+w6zwXhSeDtO0m5s+CFMJemxOzCnLWWL8gROpLg18cgVpiYwPm7VW
	zv7U8sdahIS91kp23Ny+k/UYLA5xtdqb6ydzOX0PZDFpgThj7kmZsJwPDPEbZAXaNl5cdm
	9sHRY4kkHA0cEgbV6G+A9MoH8tfUEWo=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758639459; a=rsa-sha256;
	cv=none;
	b=R0yh+vnkrkPOTfS4BSxBTYOWOVnfaNax/jdtAW1xOg1X2enNU2Z0bAXQ0km0aP2Kqg/58r
	7AseM1xd9K57unGW7gQMPJ0WYY5MJXZDleBqbb2+CD/nokivw4YXJ3VNOze6MSGhw1NaWy
	2z9I8Nd7R/hwTlwCf36kWLzO5nJ7Qzw=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=qq.com header.s=s201512 header.b=dgrlkJ3s;
	spf=pass (imf05.hostedemail.com: domain of shengminghu512@qq.com designates 203.205.221.231 as permitted sender) smtp.mailfrom=shengminghu512@qq.com;
	dmarc=pass (policy=quarantine) header.from=qq.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qq.com; s=s201512;
	t=1758639451; bh=H/DoxZF7P4nKqwBqst7vh1I9d9VymNgrxJ0Xnlc4ZXo=;
	h=From:To:Cc:Subject:Date;
	b=dgrlkJ3sJ812phOlwAvQZmFlxNMjC7RGZKFjihDu/LYsr20R9XplyGnCqNqS7HIx3
	 tCcCOjrZCZjtNjDHD9WrcadF67WbHHTYdlw+0R2I09lQIZDoxk9N3E6ImiNwrxP0K8
	 Q22WmXHxR1eG7c4w4Qf2dwNGY7a4QcPl1gG7k+do=
X-QQ-XMRINFO: OWPUhxQsoeAVDbp3OJHYyFg=
X-QQ-XMAILINFO: N+XrBeZ/LGN6CuENrvAnMc4J53T/tB/LXoiayzw4dNn1ZjfUy5T2NEr1Y6v78s
	 7s9Q9fJoa4gLONPRl99j6O5t50LhRJcj1QXsLtv5zuVQQDkHi6ebTbZthXmOWjmZ9xwbaPdZEzGCg
	 wGO8N/rinrEVvaoBCeztVRLUhi8IF0QUbS+Vl6TDsgh1+q6GXbF82Zm3nqSNlVW0Wwqxj49ulY1qZ
	 cORLaKqyas4IxU7drT+G16XcT7MDJwpGw4k45RTCApRv9bbz3w2Wir6dxFpSZoRnGTWQSbZsW567S
	 pUq2HFu4V9Z5CSGpr8gqL/Aaq5EOKXkipW7wlmeix912747B2etp0QrD6l2tgxf14cIRAX0zUDqwb
	 TchtBBMwMjnE1HoqBmUWm+r5lA+Xlcsr2QctR0YqDrvDmMam00gcQJqfedFUKItaOdVhmCImlEikg
	 SUdVjukTnxe0XQmJij+UrV9JV6r0Zef3D9fCaeGq0hTiktn/B1dHfEw3AIs8NweoTEcTdsw8cxvKL
	 BpszuypnKF3wNSphLRBJIpcZxkxWRNs8ULsTuPlPMIVHIxOXWF1GgAAGMZuKhzh1Q8LVhof7OW15c
	 LWV47xRGL/w0zdfpsFACv+N+C0dFOxse4eIHr7Zz5SclBpMxU6NWdHZVAIqlECHTzoyXgeSl7VyIa
	 Jp4WWsPn4573hMZFXTSSfJCzpB0e1RJjc9UvD07PR6LUP/PiceRWfZlCnwdTMBI47zTQx0vWx2Tjd
	 H8vjV0A7Civv3b/arU9lKzH2500hnhKpttdTOqv8jeuvuo6gjEe39z8Ty9OCFNRuTawX04EmXE9YW
	 Uk87H/8kEUzm7WcE7gQH3OkuadRS2UBYN8iVvEMrWq+DBnXxhHSM0vvnUY7LPyk6Na5IKU1Tltm9r
	 6YlIQRas3LTrbMXC6IFNsI4FVbk8az1tsXkXQCn9aEllV7Xd5QV5yHAAkVyC2xrd6zwwn2SD67AYo
	 PIYtaK89QgLJ7aOmVQxlwHlvbnj4kD1LFnGU8CYTyjDVk5Pc9o26Lj9fMHOQh5kEwAWt5C6VYW6Av
	 SG4cg/tFieBsydgUTM5kpN+d4mfFHYOfIBuzsBp1H1YY3bOS/iySv1PlZdG3TxI1esvwPwfP+INPD
	 hdRcvs+CihQk5ZrQorJQamgDAFhei2SzQvqRuebxbEe1xICR9FDhTWIAf4vHQbEddV8qrfHf61fu+
	 w==
From: "=?utf-8?B?c2hlbmdtaW5naHU1MTI=?=" <shengminghu512@qq.com>
To: "=?utf-8?B?bGlubWlhb2hl?=" <linmiaohe@huawei.com>, "=?utf-8?B?bmFvLmhvcmlndWNoaQ==?=" <nao.horiguchi@gmail.com>, "=?utf-8?B?YWtwbQ==?=" <akpm@linux-foundation.org>
Cc: "=?utf-8?B?bGludXgtbW0=?=" <linux-mm@kvack.org>, "=?utf-8?B?bGludXgta2VybmVs?=" <linux-kernel@vger.kernel.org>, "=?utf-8?B?aHUuc2hlbmdtaW5n?=" <hu.shengming@zte.com.cn>, "=?utf-8?B?c2hlbmdtaW5naHU1MTI=?=" <shengminghu512@qq.com>, "=?utf-8?B?emhhbmcucnVu?=" <zhang.run@zte.com.cn>
Subject: [PATCH V2] mm/memory-failure: Ensure collect_procs is retried when  unmap fails
Mime-Version: 1.0
Content-Type: text/plain;
	charset="utf-8"
Content-Transfer-Encoding: base64
Date: Tue, 23 Sep 2025 22:57:09 +0800
X-Priority: 3
Message-ID: <tencent_EDEED996FC685E61AADA14A23BCE9CCDAF09@qq.com>
X-QQ-MIME: TCMime 1.0 by Tencent
X-Mailer: QQMail 2.x
X-QQ-Mailer: QQMail 2.x
X-QQ-mid: xmsezc43-1t1758639429tsinbf3h5
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 44F7E100012
X-Stat-Signature: p5hxjks34fg9xgftogj8t9jqtiskzfts
X-Rspam-User: 
X-HE-Tag: 1758639457-131720
X-HE-Meta: U2FsdGVkX1+jFYIrBXbXdWK8nGk3OAwrYpUHagsyWJ1N5iN3cYWpr1i4Y8ZexoatXa5fO3VfYpdY8If70oOv5D53q6Xg5gzZZnYasAHAibjEey5q7AQpQLcHG1Kb9mGA24weSWAMIEAi1x4u4UKZThP3Q5Y2QH7Zde8GRSIbB3Iu6U5T2xxU6bvn8xAuocSnvxd0Lx7D2MO7PyU/fQYqxNZ79oYYWrS2RKKy7fbvUbJMgfbGqPr3POofVis4TZVc1H7LRRuhh3rN4MBjffYHT67ikdAyiBsAZrI16f4323C+56CoKe1zTHEzRH+UuS1DmXrbJHUsPtJmhUJT7BvmHU0mM5E7XLK0Y0fNJDLanCrUtvxsGJhUubMvdeIMzRKoRIO14Wg8iCaL9Qe1Cfkq6aZPdbeNfBYSCeD8XmXD+MqhcOuIYUGpuZTw6+xGJkxw98vqqWkRXUbRBCqD/36g+StHgR4o1XuNoUeyqWqjpygZXlTEttc0HQp1UNOxUmTxotLNB+JTX7lm6dtra3NBl1dVLRqROcDJr39xcN2KOFOnCsXMab/0VsuwKMBlt1SU7QWY6b4o2q/hgoj669OrwfxWYkDH7VQW5WA1PvBeWaH1oSz63Rci8gIR2I7Wt8yvDAWqS3p4+hcdyHOzX8MLY1TiiEQ5fPM5+ygQB+lXo5KgflJKYGyTFm78CfvJpdV2zJOT5hNwWukAdgv4FZT7CG72hiTlDrfoqwkOfAMeYZo/jVlEayl0HaNs3OFh3FhXe1XBuU96tyA5hDy50oLJ6xMplaBh8QzlowCPdpRHsbKTi+hib6+OI8Ores4YiJtJd5PgwWVVyApkxRW/6dcK+RkUmkcK+8gV1hEtTALYSsxej59lq+5GvUYD3FCbAN/k5WI+yAM0rQyUu0cpus/vg6ERh7Swqkd3VBo9/XuLkAEE3808PdtDLgBpaVfsLAG/6G0hbvukicjawulXXlu
 vnjBOi55
 0wplj1/tE/yTN3VoJ9D/cHf2zo8kOcE4Qsy8tbFb3nuNJy0D/puulr0lSZqen1mMndng7WpSeOvk9jTL4LT4ZpLT15dbGFW6HwJFug+Ng76by485uaf0/9b/GZzUUYiW5qo3a854XGTdlQ9heq+mBE+f4mBYDgiUjOX1XH+3CQlrWH5tZqXcAVCrFAYn+RCJXiEyrLmdNzUR7gLOawQt4LpAQKIDQ3IRazBahqQ9hkMtdAVb47GeCOWB09wNdryoCznEnDrJZYxYHHOfMM9gosCTyJK+VgG/NXXWTWuv0s1AIgh9dOjJ4uN7ZkmIEDnTYPnnpbyvXIS6P2EPp8upaDwxaGBON6X3GCHzvmCNbnibTHbBqGQLZ303kkV7YaSbwPr+0HCcq83sZ1YK9OR5qNQ/8CLRvvf5298YPkapSAeyRc53/5Nym/Kqbl0At41Zt1QSa/376vktJddXlZ3uj07kEmmW6gRrN+9b7Lt/18qTTtKjKh2Fx17gqxiXRXVVPNLogpVY7qzJ9B06Xt9wOKUikcZH9DP/ozkcU9BJ1v2fvlCdCkhTckDuSW8YgTXXObEI6BjydFHJRZ6GI6xIAJ+LjFbqja8ufj/eJpzTWi5DCxjbS1n3Mdup8zdwkL2hxO88QSF1lH6S4Hnk=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

RnJvbTogU2hlbmdtaW5nIEh1IDxzaGVuZ21pbmdodTUxMkBxcS5jb20+CkRhdGU6IFR1ZSwg
MjMgU2VwIDIwMjUgMjA6NTY6MjggKzA4MDAKU3ViamVjdDogW1BBVENIIFYyXSBtbS9tZW1v
cnktZmFpbHVyZTogRW5zdXJlIGNvbGxlY3RfcHJvY3MgaXMgcmV0cmllZCB3aGVuCiB1bm1h
cCBmYWlscwoKSW4gdGhlIG1lbW9yeV9mYWlsdXJlIHByb2Nlc3MsIGlmIGNvbGxlY3RfcHJv
Y3MgaXMgbm90IGV4ZWN1dGVkIHdpdGggdGhlCmZsYWcgc2V0LCB0aGUgdG9fa2lsbCBsaXN0
IG1heSBiZSBlbXB0eS4gRXZlbiBpZiB0aGVyZSBhcmUgcGFnZXMgdGhhdCBmYWlsCnRvIGJl
IHVubWFwcGVkLCBTSUdLSUxMIG9yIFNJR0JVUyBjYW5ub3QgYmUgc2VudCB0byB0aGUgcHJv
Y2VzcyB2aWEKY29sbGVjdF9wcm9jcy4KClRoaXMgcGF0Y2ggZml4ZXMgdGhlIGlzc3VlIGJ5
IHJlLWV4ZWN1dGluZyBjb2xsZWN0X3Byb2NzIHdoZW4gdGhlIHRvX2tpbGwKbGlzdCBpcyBl
bXB0eSBhbmQgdW5tYXAgZmFpbHMuIFRoaXMgY29sbGVjdHMgcHJvY2Vzc2VzIHdpdGggdW5t
YXAgZmFpbHVyZXMKaW50byB0aGUgdG9fa2lsbCBsaXN0LCBhbGxvd2luZyBTSUdCVVMgb3Ig
U0lHS0lMTCB0byB0ZXJtaW5hdGUgdGhlbSBpbgpzdWJzZXF1ZW50IGNvZGUuCgpWMjoKICAt
IFJlc2VudCBhcyBwbGFpbiB0ZXh0IChwcmV2aW91cyB2ZXJzaW9uIHdhcyBIVE1MKS4KICAt
IE5vIGZ1bmN0aW9uYWwgY2hhbmdlcy4KClNpZ25lZC1vZmYtYnk6IFNoZW5nbWluZyBIdSA8
aHUuc2hlbmdtaW5nQHp0ZS5jb20uY24+Ci0tLQogbW0vbWVtb3J5LWZhaWx1cmUuYyB8IDUg
KysrKy0KIDEgZmlsZSBjaGFuZ2VkLCA0IGluc2VydGlvbnMoKyksIDEgZGVsZXRpb24oLSkK
CmRpZmYgLS1naXQgYS9tbS9tZW1vcnktZmFpbHVyZS5jIGIvbW0vbWVtb3J5LWZhaWx1cmUu
YwppbmRleCBhMjQ4MDZiYjhlODIuLjgxNTc4MjNjN2ZiNyAxMDA2NDQKLS0tIGEvbW0vbWVt
b3J5LWZhaWx1cmUuYworKysgYi9tbS9tZW1vcnktZmFpbHVyZS5jCkBAIC0xNjAwLDkgKzE2
MDAsMTIgQEAgc3RhdGljIGJvb2wgaHdwb2lzb25fdXNlcl9tYXBwaW5ncyhzdHJ1Y3QgZm9s
aW8gKmZvbGlvLCBzdHJ1Y3QgcGFnZSAqcCwKIAljb2xsZWN0X3Byb2NzKGZvbGlvLCBwLCAm
dG9raWxsLCBmbGFncyAmIE1GX0FDVElPTl9SRVFVSVJFRCk7CiAKIAl1bm1hcF9zdWNjZXNz
ID0gIXVubWFwX3BvaXNvbmVkX2ZvbGlvKGZvbGlvLCBwZm4sIGZsYWdzICYgTUZfTVVTVF9L
SUxMKTsKLQlpZiAoIXVubWFwX3N1Y2Nlc3MpCisJaWYgKCF1bm1hcF9zdWNjZXNzKSB7CiAJ
CXByX2VycigiJSNseDogZmFpbGVkIHRvIHVubWFwIHBhZ2UgKGZvbGlvIG1hcGNvdW50PSVk
KVxuIiwKIAkJICAgICAgIHBmbiwgZm9saW9fbWFwY291bnQoZm9saW8pKTsKKwkJaWYgKGxp
c3RfZW1wdHkoJnRva2lsbCkpCisJCQljb2xsZWN0X3Byb2NzKGZvbGlvLCBwLCAmdG9raWxs
LCAxKTsKKwl9CiAKIAkvKgogCSAqIHRyeV90b191bm1hcCgpIG1pZ2h0IHB1dCBtbG9ja2Vk
IHBhZ2UgaW4gbHJ1IGNhY2hlLCBzbyBjYWxsCi0tIAoyLjI1LjE=



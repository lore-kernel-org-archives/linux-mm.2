Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3235D606A31E
	for <linux-mm@archiver.kernel.org>; Mon, 26 Oct 2026 20:17:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=proton.me header.i=@proton.me header.a=rsa-sha256 header.s=yvlmz5wuurh5rfsoiol3dfcmfy.protonmail2 header.b=zU2lBZAR
Received: by kanga.kvack.org (Postfix)
	id 36B206B05B0; Mon, 26 Oct 2026 16:17:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 31C176B05B1; Mon, 26 Oct 2026 16:17:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 230896B05B2; Mon, 26 Oct 2026 16:17:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id E84BB6B05B0
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 16:17:37 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 78BDAA088E
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 20:17:37 +0000 (UTC)
X-FDA: 85365887754.19.81A4B20
Received: from mail-10697.protonmail.ch (mail-10697.protonmail.ch [79.135.106.97])
	by imf21.hostedemail.com (Postfix) with ESMTP id D475F1C0010
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 20:17:35 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=proton.me header.s=yvlmz5wuurh5rfsoiol3dfcmfy.protonmail2 header.b=zU2lBZAR;
	spf=pass (imf21.hostedemail.com: domain of BoxStrikesTeam@proton.me designates 79.135.106.97 as permitted sender) smtp.mailfrom=BoxStrikesTeam@proton.me;
	dmarc=pass (policy=quarantine) header.from=proton.me
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793045856;
	b=6gd3IyHVJccnFX58G3URma5jqskua7g4LKnmAR98o/dcN9HtY5jeTEGKXhU47/qk2W7MPk
	pIWO0k5olOFSPWRAMBdRDdweWJSH2ohEh3LkdrOoEzYJAbjN94w3ne+6iwco38u8ZYh75j
	9QEQibA+uVCgaHMZVSf7/fT0qcUVUmc=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=proton.me header.s=yvlmz5wuurh5rfsoiol3dfcmfy.protonmail2 header.b=zU2lBZAR;
	spf=pass (imf21.hostedemail.com: domain of BoxStrikesTeam@proton.me designates 79.135.106.97 as permitted sender) smtp.mailfrom=BoxStrikesTeam@proton.me;
	dmarc=pass (policy=quarantine) header.from=proton.me
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793045856;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=sVSjN/XqWDLZDr7IXQQnJDQT7Ga3u1tyb5UkYEWZhRk=;
	b=RE4tP/4xD3N/AC/b3sY7n40r70vPYaPl+HbEvd8T/TeimbfniN+mA/q9GAb436OMgHBt3p
	/joVN18g/i7VKsVZB8y0gpzD6qMpZ9Vm8CZWbo8Wax/iSgGWcXIuoSsAUuO+ZHK4WvPHtG
	kC59LxrCJdgynJYZsgk3SJUzyrTVsSc=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=proton.me;
	s=yvlmz5wuurh5rfsoiol3dfcmfy.protonmail2; t=1793045853;
	x=1793305053; bh=sVSjN/XqWDLZDr7IXQQnJDQT7Ga3u1tyb5UkYEWZhRk=;
	h=Date:To:From:Cc:Subject:Message-ID:Feedback-ID:From:To:Cc:Date:
	 Subject:Reply-To:Feedback-ID:Message-ID:BIMI-Selector;
	b=zU2lBZAR2+tXbDzRvPC8eEgaPslt5ccH5CgJ6w6DgGQIWCDYiaWlrkAc90YdsVG0H
	 iMeWt3zEBBBZwAF01E+bVRJYqKV6oPWPndut+foblGBxfiG8SXEUiLEIlLly/x94nr
	 TQ8tFAiYAf2rJBwCoEx0POuwvDgGv9xXvOwQLMHabQVY4/4h8O21RIPM3zdREbOqOs
	 DIhPCcoXZRa2ylzG2mRWwlKunEdsbcOescd62Pk7phVGhshd3wDWMvJovMYgAs6oZ4
	 5pxZdgru7l4ckNfqzdsR+ZiqdQ8WNqZ6vc1HEPMD6uNrfqyQ0ZHLf8nb6sgvW2R1J1
	 eIfaJvPymTZtg==
Date: Mon, 26 Oct 2026 20:17:26 +0000
To: "brauner@kernel.org" <brauner@kernel.org>, "kees@kernel.org" <kees@kernel.org>, "rostedt@goodmis.org" <rostedt@goodmis.org>
From: BoxStrikesTeam <BoxStrikesTeam@proton.me>
Cc: "viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>, "jack@suse.cz" <jack@suse.cz>, "mhiramat@kernel.org" <mhiramat@kernel.org>, "mathieu.desnoyers@efficios.com" <mathieu.desnoyers@efficios.com>, "jkoolstra@xs4all.nl" <jkoolstra@xs4all.nl>, "farid.m.zakaria@gmail.com" <farid.m.zakaria@gmail.com>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, "linux-trace-kernel@vger.kernel.org" <linux-trace-kernel@vger.kernel.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "bpf@vger.kernel.org" <bpf@vger.kernel.org>
Subject: [RFC PATCH] binfmt_misc: add binfmt_misc_select tracepoint
Message-ID: <cmtfuzYFZMj7WozUoEjFs3RxYWe9UgdY5rK3ZGT7CPwO1mpemvEwNhG4v5ucoKBgUHMqFa7kSzOvLjFcVcxAybfmKdURZ4h-qoKX1lHXlAA=@proton.me>
Feedback-ID: 205449183:user:proton
X-Pm-Message-ID: c38ae376d3bc2a6c337eca8d28b04e53faf2a787
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/mixed;
 boundary="b1=_kzBFLx7iHgjUHNurMWuTQCh250lsH2OVRDJ5zxSdQ4M"
X-Stat-Signature: oa1f8y6gzqdcreauyop3s3uotw17w8mn
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: D475F1C0010
X-Rspam-User: 
X-HE-Tag: 1793045855-16865
X-HE-Meta: U2FsdGVkX1/SCUUS8G8+h+uoXxP5CclgnWefJspg0AzhIwTK276o1yD7vJLrqhlNsRbUfed+IerZ4pQmQuPKnN/s1WDhVLR6yWVrAf1Rneleqy9kQfryqA0pW1RZv646c9ZiyR6EeAYrSByWnCpm66G8CEMRDZJw8PvtJGaGTG8dSXB6pmN3FUOmIuS1XfaDQ+Y2mYpD8sRtMECF6sclWxGqtXfoLb+jLjeQ5zGo8VrpVBgFgztQKX7JVPbVJEcLTEwaj2iDvHWadD5HsIlhtsdtOrueKMkaItTTysFc39EXiRU8NitLDOqGPo2+r68Hk+OGS5rLWdsU01zMvF3FBFwYR+q03RtJIpaKta4mU7eDBdgInxWrs0BxvSQPhfxYrBVwwFroScwPl6sNfLDq6RTzHMPhntxg55ez/oLC9gNXXjhfdpEOgN3e2a+SYMN1umHCMtWRYg9O6GKpVIvSoZcFhodY5xgZDMPhT0ZS27uTH8HolfIFFybN4ughvk/6EJD6Sg0fnZSPttdiB2pD7R5Nau0ZwMfRjOADs6SZ3awjtZc/pzL/PAURleEXnThQT2U6brgRiv49g63G4NCOuMT/K8fwtOvNA3f4DSpsQn1Hfr/m3m2Hm459R5+r9rSHNzXvHLMkRnrM580V/RyoUGOSV2RgBFrAJG0oNS/vFnHDjKuhwhybMTCBwRiDUJJIzkKXWFBO/Z1Xe+Jgmj9s+YqcK85nawxkYtEe38cRgjKiQ6QzNBBMPG+7DpRfSe5zPI13KS9L6u1fxQ99yukdPaQucZx3OVu85N7eb6sEEfVkv+G52BGTvqt4PVQiZug7NC+vMKHSPIXgst2DxVwW8Ix8X/Z2Oc/RhEcahAw+QgtTEk13sJ0HD6oNcBpaozQYoWR5W8GkhTlVV5mj0/jjBVKZ5mdKtL2HoM2xmvuq0GPifEPyF/p2Yjz0JTjjEcW9/wft5stof6Ua+D9XGi8
 JjfeHPln
 T19bL2QeIjybaCD9q2xNp3ZX4+yjFoeIMmuF/B52n4jbIIolj+tZQBP1C2LlIsFl99dxUC2IvKvygEKCmHG0gezrn+yNH6SloYCcYsxS8msVvQxctHPxz6zu3As4q7BrYlYvVzFxvqFD6l62rI5NrDeUvwp49b1xFW4URId/NEc/ciZF+NtlDAC+SaYcnHhKmsaNvh9y4/l/bEi+rbK77KDGW3BycxRlD59Rbgg9FzK2QC7VveA+DZriyXBr7pnGTy5BI8O2833+jvDlUbZYkcKIA3nofdSnEhstnlM31sOw/fjHRnRwRGIF062PEa/1NqTuL6NycbewEgTVw7RIN8NryOsCIi+u5X3lDW58ikt2hwP3LjuNo4njXeGZGldqMmqJ9phUxKeLtuW3XK5sya4pEuhibkm7tM8GAXT5SuMDbrMrapKUn4AJDH/a5zSijVdmaFeh0kEEWcQgbg2g54SimqB7tvAxhxvxTtiopW9fzeojA5r1vqYkRTx6Xk6Zo5Sb1FUzXQGlpZ121ogn55zPimmXVy0i2GaHhJeGheqyIT4a1WpxCyU7Ld9zysXBOJ/aydJMiW3RcVESWKFkruHim8YSoUC/7iBqR+2sVpoNQB20UnH0I5ppLmrfuLkMyuzNSomDBclcLE/ICpOnh0mCPgapXUqMK6Vi/lPtdvZru3vLX6Cir1ByszX7JeOsUVbgj3g/ycpM0oxj8wvUqYAJO9u/mlDoMQb6w
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

--b1=_kzBFLx7iHgjUHNurMWuTQCh250lsH2OVRDJ5zxSdQ4M
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Hi,

This is an RFC patch for a binfmt_misc_select tracepoint. The patch
was tested on v7.3-rc7, but I currently have limited computer access
and no usable SMTP setup, so I could not send it with git send-email.
I know patches should be inline; the patch is attached as
0001-binfmt_misc-select-tracepoint.patch, and I can resend it inline
once I have access to a suitable environment.
--b1=_kzBFLx7iHgjUHNurMWuTQCh250lsH2OVRDJ5zxSdQ4M
Content-Type: text/x-diff; name=0001-binfmt_misc-select-tracepoint.patch
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename=0001-binfmt_misc-select-tracepoint.patch

RnJvbTogRW5lc2hhbiBFcmRvxJ9hbiBLYXJhY2EgPEJveFN0cmlrZXNUZWFtQHByb3Rvbi5tZT4K
U3ViamVjdDogW1JGQyBQQVRDSF0gYmluZm10X21pc2M6IGFkZCBiaW5mbXRfbWlzY19zZWxlY3Qg
dHJhY2Vwb2ludAoKQSBiaW5mbXRfbWlzYyBlbnRyeSBjYW4gc2VsZWN0IGFuIGludGVycHJldGVy
IGZvciBhbiBleGVjLiAgV2l0aCBhIEJQRgonQicgaGFuZGxlciwgdGhhdCBzZWxlY3Rpb24gY2Fu
IGJlIG1hZGUgYnkgYSBCUEYgc3RydWN0X29wcyBwcm9ncmFtLgpUaGUga2VybmVsIGNvbW1pdHMg
dGhlIGRlY2lzaW9uIGluIGJwcm0tPmludGVycCBhbmQgYnBybS0+ZmxhZ3MsIGJ1dCBpdApkb2Vz
IG5vdCBlbWl0IGFuIGV2ZW50IGF0IHRoZSBzZWxlY3Rpb24gcG9pbnQuCgpFeGlzdGluZyBvYnNl
cnZlcnMgaGF2ZSB0byByZWNvbnN0cnVjdCB0aGUgZGVjaXNpb24gZnJvbQovcHJvYy9QSUQvZXhl
LCBBVF9FWEVDRkQsIEFUX0ZMQUdTLCBvciAvcHJvYy9QSUQvbWFwcy4gIFRoZXNlIHNvdXJjZXMK
YXJlIG1vZGUtZGVwZW5kZW50OiBhIHRyYW5zcGFyZW50IGRpc3BhdGNoIHN0aWxsIHJlcG9ydHMg
dGhlIG9yaWdpbmFsCmJpbmFyeSBpbiAvcHJvYy9QSUQvZXhlLCBhbmQgYSBzaG9ydC1saXZlZCBw
cm9jZXNzIGNhbiBleGl0IGJlZm9yZSB0aGUKb2JzZXJ2ZXIgcmVhZHMgaXQuICBBIGNsYXNzaWMg
ZGlzcGF0Y2ggcmVwb3J0cyB0aGUgaW50ZXJwcmV0ZXIsIGJ1dApub3Qgd2hpY2ggaGFuZGxlciBz
ZWxlY3RlZCBpdCBvciB3aGljaCBpbnZvY2F0aW9uIGZsYWdzIHdlcmUgdXNlZC4KCkFkZCBhIHRy
YWNlcG9pbnQgYWZ0ZXIgdGhlIGludGVycHJldGVyIGFuZCB0aGUgaW52b2NhdGlvbiBmbGFncyBh
cmUKc2VsZWN0ZWQuICBJdCByZXBvcnRzIHRoZSBiaW5hcnkgZmlsZW5hbWUsIHRoZSBzZWxlY3Rl
ZCBpbnRlcnByZXRlciwKdGhlIGhhbmRsZXIgbmFtZSAoZm9yIEJQRiBoYW5kbGVycyksIHRoZSBp
bnZvY2F0aW9uIGZsYWdzLCBhbmQgdGhlCnBpZC4gIFRoZSBmbGFncyBhcmUgbWFza2VkIHdpdGgg
TUlTQ19GTVRfSU5WT0NBVElPTl9GTEFHUyBzbyB0aGF0CnN0YXRpYyBlbnRyeSBzdGF0ZSBkb2Vz
IG5vdCBsZWFrIGludG8gdGhlIGV2ZW50LgoKVGhlIHRyYWNlcG9pbnQgaXMgb2JzZXJ2YWJpbGl0
eSBvbmx5OyBpdCBkb2VzIG5vdCBjaGFuZ2UgZXhlYwpiZWhhdmlvci4KCkFzc2lzdGVkLWJ5OiBM
TE0KU2lnbmVkLW9mZi1ieTogRW5lc2hhbiBFcmRvxJ9hbiBLYXJhY2EgPEJveFN0cmlrZXNUZWFt
QHByb3Rvbi5tZT4KLS0tCgpUaGlzIGlzIGFuIFJGQy4gIEEgc21hbGwgUG9DIGFuZCBzaG9ydCBB
L0IgcmVzdWx0cyBhcmUgYXZhaWxhYmxlIGZvcgpjb250ZXh0OyB0aGV5IGFyZSBub3QgbmVlZGVk
IHRvIHJldmlldyB0aGUgcGF0Y2guCgogZnMvYmluZm10X21pc2MuYyAgICAgICAgICAgICAgICAg
IHwgIDggKysrKysrKysKIGluY2x1ZGUvdHJhY2UvZXZlbnRzL2JpbmZtdF9taXNjLmggfCA1MiAr
KysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKwogMiBmaWxlcyBjaGFuZ2VkLCA2
MCBpbnNlcnRpb25zKCspCgpkaWZmIC0tZ2l0IGEvZnMvYmluZm10X21pc2MuYyBiL2ZzL2JpbmZt
dF9taXNjLmMKLS0tIGEvZnMvYmluZm10X21pc2MuYworKysgYi9mcy9iaW5mbXRfbWlzYy5jCkBA
IC00MSw2ICs0MSw5IEBACiAKICNpbmNsdWRlICJpbnRlcm5hbC5oIgogCisjZGVmaW5lIENSRUFU
RV9UUkFDRV9QT0lOVFMKKyNpbmNsdWRlIDx0cmFjZS9ldmVudHMvYmluZm10X21pc2MuaD4KKwog
LyogRW50cnkgc3RhdHVzIGFuZCBtYXRjaCB0eXBlIGJpdCBudW1iZXJzLiAqLwogZW51bSBiaW5m
bXRfbWlzY19lbnRyeV9iaXRzIHsKIAlNSVNDX0ZNVF9FTkFCTEVEX0JJVAk9IDAsCkBAIC02NDQs
NiArNjQ3LDExIEBACiAKIAlmbGFncyA9IGVudHJ5X2ludm9jYXRpb25fZmxhZ3MoZm10LCBicHJt
KTsKIAorCXRyYWNlX2JpbmZtdF9taXNjX3NlbGVjdChicHJtLCBpbnRlcnByZXRlciwKKwkJCQkg
dGVzdF9iaXQoTUlTQ19GTVRfQlBGX0JJVCwgJmZtdC0+ZmxhZ3MpID8KKwkJCQkgZm10LT5icGZf
b3BzLT5uYW1lIDogIiIsCisJCQkJIGZsYWdzICYgTUlTQ19GTVRfSU5WT0NBVElPTl9GTEFHUyk7
CisKIAkvKiBObyBhcmd2IGlzIGJ1aWx0IGZvciBhIHN0YWdlZCBhcmd1bWVudCB0byBsYW5kIGlu
LiAqLwogCWlmICgoZmxhZ3MgJiAoTUlTQ19GTVRfTE9BREVSIHwgTUlTQ19GTVRfVFJBTlNQQVJF
TlQpKSAmJgogCSAgICBicHJtLT5icGZfaW50ZXJwX2FyZykKCmRpZmYgLS1naXQgYS9pbmNsdWRl
L3RyYWNlL2V2ZW50cy9iaW5mbXRfbWlzYy5oIGIvaW5jbHVkZS90cmFjZS9ldmVudHMvYmluZm10
X21pc2MuaApuZXcgZmlsZSBtb2RlIDEwMDY0NAotLS0gL2Rldi9udWxsCisrKyBiL2luY2x1ZGUv
dHJhY2UvZXZlbnRzL2JpbmZtdF9taXNjLmgKQEAgLTAsMCArMSw1MiBAQAorLyogU1BEWC1MaWNl
bnNlLUlkZW50aWZpZXI6IEdQTC0yLjAgKi8KKy8qCisgKiBUcmFjZXBvaW50IGZvciBiaW5mbXRf
bWlzYyBiaW5hcnkgdHlwZSBoYW5kbGVyIGRpc3BhdGNoLgorICoKKyAqIEZpcmVzIG9uY2UgZm9y
IGV2ZXJ5IGV4ZWMgYSBiaW5mbXRfbWlzYyBlbnRyeSBtYXRjaGVzLCBhZnRlciB0aGUKKyAqIGlu
dGVycHJldGVyIGFuZCB0aGUgaW52b2NhdGlvbiBmbGFncyBoYXZlIGJlZW4gc2VsZWN0ZWQuIFVu
bGlrZQorICogc2NoZWRfcHJvY2Vzc19leGVjICh3aGljaCByZXBvcnRzIGJwcm0tPmZpbGVuYW1l
KSBhbmQgL3Byb2MvUElEL2V4ZQorICogKHdoaWNoIGEgdHJhbnNwYXJlbnQgZGlzcGF0Y2ggc2V0
cyB0byB0aGUgYmluYXJ5KSwgdGhpcyByZXBvcnRzIHRoZQorICogaW50ZXJwcmV0ZXIgdGhhdCBh
Y3R1YWxseSBydW5zLCBzbyBvYnNlcnZlcnMgY2FuIHNlZSB0aHJvdWdoIGEKKyAqIHRyYW5zcGFy
ZW50IGRpc3BhdGNoLgorICovCisjdW5kZWYgVFJBQ0VfU1lTVEVNCisjZGVmaW5lIFRSQUNFX1NZ
U1RFTSBiaW5mbXRfbWlzYworCisjaWYgIWRlZmluZWQoX1RSQUNFX0JJTkZNVF9NSVNDX0gpIHx8
IGRlZmluZWQoVFJBQ0VfSEVBREVSX01VTFRJX1JFQUQpCisjZGVmaW5lIF9UUkFDRV9CSU5GTVRf
TUlTQ19ICisKKyNpbmNsdWRlIDxsaW51eC90cmFjZXBvaW50Lmg+CisjaW5jbHVkZSA8bGludXgv
YmluZm10cy5oPgorCitUUkFDRV9FVkVOVChiaW5mbXRfbWlzY19zZWxlY3QsCisKKwlUUF9QUk9U
TyhzdHJ1Y3QgbGludXhfYmlucHJtICpicHJtLCBjb25zdCBjaGFyICppbnRlcnAsCisJCSBjb25z
dCBjaGFyICpoYW5kbGVyLCB1bnNpZ25lZCBsb25nIGZsYWdzKSwKKworCVRQX0FSR1MoYnBybSwg
aW50ZXJwLCBoYW5kbGVyLCBmbGFncyksCisKKwlUUF9TVFJVQ1RfX2VudHJ5KAorCQlfX3N0cmlu
ZyhmaWxlbmFtZSwJYnBybS0+ZmlsZW5hbWUpCisJCV9fc3RyaW5nKGludGVycCwJaW50ZXJwKQor
CQlfX3N0cmluZyhoYW5kbGVyLAloYW5kbGVyKQorCQlfX2ZpZWxkKHVuc2lnbmVkIGxvbmcsCWZs
YWdzKQorCQlfX2ZpZWxkKHBpZF90LAkJcGlkKQorCSksCisKKwlUUF9mYXN0X2Fzc2lnbigKKwkJ
X19hc3NpZ25fc3RyKGZpbGVuYW1lKTsKKwkJX19hc3NpZ25fc3RyKGludGVycCk7CisJCV9fYXNz
aWduX3N0cihoYW5kbGVyKTsKKwkJX19lbnRyeS0+ZmxhZ3MgPSBmbGFnczsKKwkJX19lbnRyeS0+
cGlkID0gY3VycmVudC0+cGlkOworCSksCisKKwlUUF9wcmludGsoInBpZD0lZCBmaWxlbmFtZT0l
cyBpbnRlcnA9JXMgaGFuZGxlcj0lcyBmbGFncz0lI2x4IiwKKwkJICBfX2VudHJ5LT5waWQsIF9f
Z2V0X3N0cihmaWxlbmFtZSksIF9fZ2V0X3N0cihpbnRlcnApLAorCQkgIF9fZ2V0X3N0cihoYW5k
bGVyKSwgX19lbnRyeS0+ZmxhZ3MpCispOworCisjZW5kaWYgLyogX1RSQUNFX0JJTkZNVF9NSVND
X0ggKi8KKworLyogVGhpcyBwYXJ0IG11c3QgYmUgb3V0c2lkZSBwcm90ZWN0aW9uICovCisjaW5j
bHVkZSA8dHJhY2UvZGVmaW5lX3RyYWNlLmg+Cg==

--b1=_kzBFLx7iHgjUHNurMWuTQCh250lsH2OVRDJ5zxSdQ4M--



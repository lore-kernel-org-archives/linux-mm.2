Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CB0B6606A31E
	for <linux-mm@archiver.kernel.org>; Tue, 24 Nov 2026 23:20:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=zte.com.cn header.i=@zte.com.cn header.a=rsa-sha256 header.s=z202610 header.b=A6xuHlvK
Received: by kanga.kvack.org (Postfix)
	id C00486B08A5; Tue, 24 Nov 2026 18:20:06 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BB08B6B08A7; Tue, 24 Nov 2026 18:20:06 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AC5C86B08A8; Tue, 24 Nov 2026 18:20:06 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 8384E6B08A5
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 18:20:06 -0500 (EST)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id EFFA640D93
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 23:20:05 +0000 (UTC)
X-FDA: 85471582770.22.227A0FA
Received: from mxhk.zte.com.cn (mxhk.zte.com.cn [160.30.148.34])
	by imf18.hostedemail.com (Postfix) with ESMTP id A530C1C000B
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 23:20:02 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=zte.com.cn header.s=z202610 header.b=A6xuHlvK;
	dmarc=pass (policy=none) header.from=zte.com.cn;
	spf=pass (imf18.hostedemail.com: domain of li.hanting@zte.com.cn designates 160.30.148.34 as permitted sender) smtp.mailfrom=li.hanting@zte.com.cn
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795562404;
	b=tG3V2EE2m3KCQPPH+/P96x0veSaznOO5nYJR2/xU5UG4fH1SuAzAKvL/4hbv0CdYABg1U/
	W/DQZXljQUz7A1r+m/kw6heZpPSlqoCYx39jSngwMrJb2cIpC/nK5N+qKbMQEawAQ0cvQ3
	Geqc7JF+IIPAGnMAeud5nfMLxkerCKo=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795562404;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ODQqC4G8YdsKlDot+/XCvDKTu5dDNTMt2mfmwUAVNKg=;
	b=AWwirjg14nAh5VkaTZ2a94xEf3cjqbxkHxPCQWku7DwoMcX2K/67gGDgcRxbQ7Zliwgx9f
	eV85bs4rnyOu4x/C8FkAxuict16MUgvLwB3dCVewqrhDbraUhwzhArnjK3edSMYDVxzNf/
	jScQ4GJrsyS17BuaWuQH2Q4pq4L4M1E=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=zte.com.cn header.s=z202610 header.b=A6xuHlvK;
	dmarc=pass (policy=none) header.from=zte.com.cn;
	spf=pass (imf18.hostedemail.com: domain of li.hanting@zte.com.cn designates 160.30.148.34 as permitted sender) smtp.mailfrom=li.hanting@zte.com.cn
Received: from mse-fl2.zte.com.cn (unknown [10.5.228.133])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mxhk.zte.com.cn (FangMail) with ESMTPS id 4jYzL66tCjz5BNRf;
	Wed, 25 Nov 2026 07:19:58 +0800 (CST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=zte.com.cn;
	s=z202610; t=1795562399;
	bh=w1r8qFpNWXA6GnTffek1Fds0XxljiMHrLTjTrejZ8d4=;
	h=In-Reply-To:References:Date:From:To:Cc:Subject;
	b=A6xuHlvKviVsFtyEqkvq4sozy3awRZYpQZhKSYy4RvwBVx3RAdztpQIEaTVxAVweB
	 5uVihBQIF34WFeHlO6hZc1DU0XeeIMruAZ/UH8uWAlamyg3mVjDmkg36T3bRkW7BAI
	 SUjADTJRLGKqCTL8Cu/M7pRM2nNe0LmmhTZho+3jqTolA91dno8Eu1bYcfo4WGsCBz
	 rvShS5FM2AxzlK14vmTBcO9JztaUr67lhCPUhTUTww81yXUZF/RHxd80lcINrKUHBO
	 gFegbOz4X2LQwUONxh9cUlsnmvpajDQT9YuURqaXezoMPzb0qK5C37ymwOclYDK1vt
	 qniOuryRAN1Og==
Received: (from root@localhost)
	by mse-fl2.zte.com.cn id 6AONJwrr001030;
	Wed, 25 Nov 2026 07:19:58 +0800 (+08)
	(envelope-from li.hanting@zte.com.cn)
Message-Id: <202611242319.6AONJwrr001030@mse-fl2.zte.com.cn>
Received: from njb2app05.zte.com.cn ([10.55.22.121])
	by mse-fl2.zte.com.cn with SMTP id 6AO8PTJG079320;
	Tue, 24 Nov 2026 16:25:30 +0800 (+08)
	(envelope-from li.hanting@zte.com.cn)
Received: from mapi (njy2app03[null])
	by mapi (Zmail) with MAPI id mid203;
	Tue, 24 Nov 2026 16:25:32 +0800 (CST)
X-Zmail-TransId: 2afb6b0549fcbb2-fb9c7
X-Mailer: Zmail v1.0
In-Reply-To: <CAMZfGtX4E96XN7suB9=0=xg8k9=S9Qe9otWYjH02oDtKPyXbkA@mail.gmail.com>
References: 202611240743.6AO7homY042860@mse-db.zte.com.cn,CAMZfGtX4E96XN7suB9=0=xg8k9=S9Qe9otWYjH02oDtKPyXbkA@mail.gmail.com
Date: Tue, 24 Nov 2026 16:25:32 +0800 (CST)
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
From: <li.hanting@zte.com.cn>
To: <songmuchun@bytedance.com>
Cc: <palmer@dabbelt.com>, <pjw@kernel.org>, <aou@eecs.berkeley.edu>,
        <alex@ghiti.fr>, <linux-riscv@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>,
        <akpm@linux-foundation.org>, <rppt@kernel.org>,
        <muchun.song@linux.dev>
Subject: =?UTF-8?B?UmU6IFtQQVRDSCB2M10gcmlzY3Y6IG1tOiBGaXggc3BsaXQgbGluZWFyIG1hcCBwYWdlIHRhYmxlIGFsbG9jYXRpb24=?=
Content-Type: multipart/mixed;
	boundary="=====_001_next====="
X-MAIL:mse-fl2.zte.com.cn 6AONJwrr001030
X-MSS: AUDITRELEASE@mse-fl2.zte.com.cn
X-TLS: YES
X-ENVELOPE-SENDER: li.hanting@zte.com.cn
X-SOURCE-IP: 10.5.228.133 unknown Wed, 25 Nov 2026 07:19:59 +0800
X-CLEAN: YES
X-Fangmail-Anti-Spam-Filtered: true
X-Fangmail-MID-QID: 6B061B9E.000/4jYzL66tCjz5BNRf
X-Rspamd-Server: rspam04
X-Rspam-User:
X-Rspamd-Queue-Id: A530C1C000B
X-Stat-Signature: wizz4wnfux1ixcf17n85j39n6nib1zrz
X-Spam-Status: No, score=-2.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,HTML_MESSAGE,
	MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_PASS,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=no autolearn_force=no version=4.0.1
X-HE-Tag: 1795562402-402546
X-HE-Meta: U2FsdGVkX189qtChYe994ZJQIb17KXUlFUmrymlh2fFLHyz0lF32FV5sYezH+XarJ0LXFj8qwxSDHEg/SpLOtQDLroVzI8YkpJj2Dw10MBn2TUk9PP1FAqNF63nh9Kwaxm3j1st0nNSeIMcPTnWf7QTStiZhSE++TgbORkLkDZlWIhvrLSadoorr+I/9f9CeHHjzrVFl+94U6ZKXLvHD2okoBRSVpyDBbkovLt2SF+5+nNG7R1pyJNSaDRQJhCU/cV1tQEEPI2zd2q17fsfDCKzIuYEMiZi9VP4x5UJp3BhOSgSJKDDKPyKrnO0jATOPp7RHDpkGXDNwiMpOc4EY9bfXkDG7HT1T6eUwl2Rfx8CFyA0Q9YykyySLozNVwqQG1Eb2i2u6znyNtcl7n2m7qg79I7ylFWDqR5XGzb+i1IXYgZesyuSX7U1WrkkkkcgrMYIPLyiMlPFpihw69CAi/N2DEZZGQ1N/LZIN09XAUMQgzgjB6427N0S5S0JIMEAmOWXXILnA6GVsfmO1GEKMQyCOAp3saLsSeKB7GS/7GGRvy6oiGxnic6ypy0oq16OciD4SDpG9bHKCtLzV0UsZh44bOGs8XPPRfBl5OSlRGkKsuiBgeXqMBBfy2rHjCSBoQt8pHqaxXPdN/wni43z4rgdFz3Glif8WoZWOQpBGvUkpuc7j8J73v7+ROKAoygQCI8DQVpmv9XSBXjbapm/f1iN8kWlF3emfsL7IsQ7NiBvj8sUEbQcjmsP7PgsHRsbzUG1cOLzvOLn5qOSOfX7dK5H4EzXSvkeidd5/ip3E4gwxUeD0f5AYA1KnCZMm/n6EoBV+s3JvZRxKGYK4gWk9l9EI2vVTXS4l9wKQmmJKGRvrGGcQHmDmTs+ZIAFzCKmZKbHitB6KH94CaiXXw6n+aVGAOAONk1Qe2mNZTS2DXVVoqcxeovNWht8dM1q+pumTl6mVUcn7+rzzWTLpoJS
 lrj8PEDf
 1VzgaMDKnk0xW5kMHN/bCTFUbT7y5942R1iBOHALIcG4W/wWYbX07pPwo8tWVVVMNs8+2WngX5Z+G5+JssM6FQFewwo+3TZj72K+qIO3t2CQrCIViFQ1ucjtUyDP0XHc+1MhebYG9AkG0Aop2iQbMyrEwgcsLmPC4g99HjyQ7SIqz4+872CbBnDPmpxDAP7U3/LupeAb2+LuQRTCoOO7nBInJmEGEU1E9ESNjzkhw+JDSYpWkzFrkip3GYCYzag+B/XPBAHkyANWgb4t6cViI88Orc9YVd71Q1tcCf0MCQmwAYxttDbdRNO8yWEFAPRCWhwJyEENY8njeqe67qNsKXud8UvgYKWnQpyieQrdjAeA9fhXGlb3SBt+MxwOMGPtwBk3qerabU5hgnG6BjWmJrctfdIW0gxnlEalFhdj558pFDMhQt2nLxfmw8XCc31NVV+GUVmUNFblriNy8MewyPRSxxmk43avfxmOng3GSP2ANyUgOMXAr+OhHCPfETX1zAsgq1qo0uYb+kH0syaswCpRc+RDCiXZFUYUe/43IKOeu9TRw7uH274Q5f1cjIO9bbY34Rgx5l1pfBkDo7jRjLWics5Sa6EWj6jHnh9FoTf9jZJMrWuowKvjlu2Uxq8XrJYaQKv2gyO9dhkfUnw5eOHIGdVvoREaJYw5/QtK3xcbpuXs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



--=====_001_next=====
Content-Type: multipart/related;
	boundary="=====_002_next====="


--=====_002_next=====
Content-Type: multipart/alternative;
	boundary="=====_003_next====="


--=====_003_next=====
Content-Type: text/plain;
	charset="UTF-8"
Content-Transfer-Encoding: base64

SGkgTXVjaHVuLA0KDQpUaGFua3MgYSBsb3QgZm9yIHRoZSByZXZpZXchDQoNCkFuZCBteSBhcG9s
b2dpZXMgZm9yIG1pc3NpbmcgeW91ciBsaW51eC5kZXYgYWRkcmVzcyBpbiB0aGUgQ2MNCmxpc3Qu
IFRoYXQgd2FzIG15IG92ZXJzaWdodCAtIEkgcmV1c2VkIHRoZSBhZGRyZXNzIGZyb20geW91cg0K
aG90LXJlbW92ZSBzZXJpZXMgaW5zdGVhZCBvZiByZXBseWluZyB0byB0aGUgb25lIHlvdSBhY3R1
YWxseQ0Kd3JvdGUgZnJvbS4gSSBoYXZlIGl0IG5vdGVkIG5vdywgYW5kIGFsbCBmdXJ0aGVyIHJl
cGxpZXMgYW5kDQp2ZXJzaW9ucyBvZiB0aGlzIHBhdGNoIHdpbGwgY2MgaXQuDQoNCkdsYWQgdGhl
IGNoYW5nZXMgbG9vayBnb29kIHRvIHlvdS4NCg0KQmVzdCByZWdhcmRzLA0KSGFudGluZyBMaQ==

--=====_003_next=====
Content-Type: text/html ;
	charset="UTF-8"
Content-Transfer-Encoding: base64

PGRpdiBjbGFzcz0iemNvbnRlbnRSb3ciPjxkaXYgc3R5bGU9ImxpbmUtaGVpZ2h0OjEuNSI+SGkg
TXVjaHVuLDwvZGl2PjxkaXYgc3R5bGU9ImxpbmUtaGVpZ2h0OjEuNSI+PGJyPjwvZGl2PjxkaXYg
c3R5bGU9ImxpbmUtaGVpZ2h0OjEuNSI+VGhhbmtzIGEgbG90IGZvciB0aGUgcmV2aWV3ITwvZGl2
PjxkaXYgc3R5bGU9ImxpbmUtaGVpZ2h0OjEuNSI+PGJyPjwvZGl2PjxkaXYgc3R5bGU9ImxpbmUt
aGVpZ2h0OjEuNSI+QW5kIG15IGFwb2xvZ2llcyBmb3IgbWlzc2luZyB5b3VyIGxpbnV4LmRldiBh
ZGRyZXNzIGluIHRoZSBDYzwvZGl2PjxkaXYgc3R5bGU9ImxpbmUtaGVpZ2h0OjEuNSI+bGlzdC4g
VGhhdCB3YXMgbXkgb3ZlcnNpZ2h0IC0gSSByZXVzZWQgdGhlIGFkZHJlc3MgZnJvbSB5b3VyPC9k
aXY+PGRpdiBzdHlsZT0ibGluZS1oZWlnaHQ6MS41Ij5ob3QtcmVtb3ZlIHNlcmllcyBpbnN0ZWFk
IG9mIHJlcGx5aW5nIHRvIHRoZSBvbmUgeW91IGFjdHVhbGx5PC9kaXY+PGRpdiBzdHlsZT0ibGlu
ZS1oZWlnaHQ6MS41Ij53cm90ZSBmcm9tLiBJIGhhdmUgaXQgbm90ZWQgbm93LCBhbmQgYWxsIGZ1
cnRoZXIgcmVwbGllcyBhbmQ8L2Rpdj48ZGl2IHN0eWxlPSJsaW5lLWhlaWdodDoxLjUiPnZlcnNp
b25zIG9mIHRoaXMgcGF0Y2ggd2lsbCBjYyBpdC48L2Rpdj48ZGl2IHN0eWxlPSJsaW5lLWhlaWdo
dDoxLjUiPjxicj48L2Rpdj48ZGl2IHN0eWxlPSJsaW5lLWhlaWdodDoxLjUiPkdsYWQgdGhlIGNo
YW5nZXMgbG9vayBnb29kIHRvIHlvdS48L2Rpdj48ZGl2IHN0eWxlPSJsaW5lLWhlaWdodDoxLjUi
Pjxicj48L2Rpdj48ZGl2IHN0eWxlPSJsaW5lLWhlaWdodDoxLjUiPkJlc3QgcmVnYXJkcyw8L2Rp
dj48ZGl2IHN0eWxlPSJsaW5lLWhlaWdodDoxLjUiPkhhbnRpbmcgTGk8L2Rpdj48ZGl2IHN0eWxl
PSJmb250LXNpemU6MTRweDtmb250LWZhbWlseTrlvq7ova/pm4Xpu5EsTWljcm9zb2Z0IFlhSGVp
O2xpbmUtaGVpZ2h0OjEuNSI+PGJyPjwvZGl2PjxkaXYgc3R5bGU9ImZvbnQtc2l6ZToxNHB4O2Zv
bnQtZmFtaWx5OuW+rui9r+mbhem7kSxNaWNyb3NvZnQgWWFIZWk7bGluZS1oZWlnaHQ6MS41Ij48
YnI+PC9kaXY+PGRpdiBzdHlsZT0iZm9udC1zaXplOjE0cHg7Zm9udC1mYW1pbHk65b6u6L2v6ZuF
6buRLE1pY3Jvc29mdCBZYUhlaTtsaW5lLWhlaWdodDoxLjUiPjxicj48L2Rpdj48ZGl2IHN0eWxl
PSJmb250LXNpemU6MTRweDtmb250LWZhbWlseTrlvq7ova/pm4Xpu5EsTWljcm9zb2Z0IFlhSGVp
O2xpbmUtaGVpZ2h0OjEuNSI+PGJyPjwvZGl2PjxkaXYgc3R5bGU9ImxpbmUtaGVpZ2h0OjEuNSIg
Y2xhc3M9InpNYWlsU2lnbiI+PC9kaXY+PGRpdiBzdHlsZT0ibGluZS1oZWlnaHQ6MS41IiBjbGFz
cz0iek1haWxGcm9tIj48L2Rpdj48L2Rpdj4=


--=====_003_next=====--

--=====_002_next=====--

--=====_001_next=====--



Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0A29BCD5BB1
	for <linux-mm@archiver.kernel.org>; Mon, 25 May 2026 12:28:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 68E4A6B009F; Mon, 25 May 2026 08:28:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 640226B00A0; Mon, 25 May 2026 08:28:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5557F6B00A1; Mon, 25 May 2026 08:28:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3CBFF6B009F
	for <linux-mm@kvack.org>; Mon, 25 May 2026 08:28:37 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id DBEB18F61E
	for <linux-mm@kvack.org>; Mon, 25 May 2026 12:28:36 +0000 (UTC)
X-FDA: 84805870632.04.C78CA18
Received: from fout-b3-smtp.messagingengine.com (fout-b3-smtp.messagingengine.com [202.12.124.146])
	by imf07.hostedemail.com (Postfix) with ESMTP id 056CE40009
	for <linux-mm@kvack.org>; Mon, 25 May 2026 12:28:34 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm2 header.b="q aXnPfH";
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b=vd2zvtOn;
	spf=pass (imf07.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.146 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779712115;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5z6TOKC44Fom90zzK05w0S0DYgDpJ2fMK4Tu/FRMg7s=;
	b=LtM4FUGl0B5p975qN1OLQTldBIggWXXZ7OQmir0sm0PnC6jOaDaIRkk2YyvbecR1NPhF7e
	fNbaGwmlimQbsO+p4RN6tiFsVzLacpka+UzQB8E71XrQv49RXfwJAM4AIfrMjsEVjkMKzA
	Zp4AYGvdg3tOkKBi3M9rEdH9Bm3xYZ4=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm2 header.b="q aXnPfH";
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b=vd2zvtOn;
	spf=pass (imf07.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.146 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779712115; a=rsa-sha256;
	cv=none;
	b=gAlYC8tVHfjQN4ZgCW57LwOT4zoeWbSTPTY99G/b4l4mivfyHKhdHAuwywW/za+na6TXOd
	zoZ0wlmdEMtmZsLve6kby2Qc5c6+ADTLAEn7AT+u9dQ6Vb1hmqgLBn3ncID1HrBV+1LNxL
	tuyUuA8tTVScLyOCBlxDlTq67JAUfKk=
Received: from phl-compute-12.internal (phl-compute-12.internal [10.202.2.52])
	by mailfout.stl.internal (Postfix) with ESMTP id 2C4BD1D000FD;
	Mon, 25 May 2026 08:28:34 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-12.internal (MEProxy); Mon, 25 May 2026 08:28:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-transfer-encoding:content-type:date:date:from
	:from:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm2; t=1779712114; x=
	1779798514; bh=5z6TOKC44Fom90zzK05w0S0DYgDpJ2fMK4Tu/FRMg7s=; b=q
	aXnPfHgvSZUfXM1G8PRYmXfunhhMEI7Aa1J3ib5KkSkDi/bjGzRFwXQuzFv97MXV
	oT18203wvASLhvzdsgz6RVu0bfh+XOOByAwbM1THjaVyXNpJMRaZOHqSaDrs4SEo
	lr3HBv8jKkfsOduvKEQJcMquq3wqt1O/YChi8uO9MpJ7heizp/oVShQQk54q39jL
	r0UJM8o/cAfNay4kfr71ZExyKiU0n1nZvEuKUdwl4P1G/E9ZqtNPAajR0wM1nqam
	+gyhS202/qhioxc1yigkClAv9BSxN3b38DT6N9d+SzRhM9y97QeM26s2X2pXG53P
	s8SdUvXPOaw+7sLBA0l9g==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to:x-me-proxy:x-me-sender
	:x-me-sender:x-sasl-enc; s=fm3; t=1779712114; x=1779798514; bh=5
	z6TOKC44Fom90zzK05w0S0DYgDpJ2fMK4Tu/FRMg7s=; b=vd2zvtOntBB/9gIdx
	LcTvyVRBEkt94blZhS0+C40I/7wlcrWiK4rnOjnu/9r0PYal2sav1Mq4bDyEz2Wr
	EDd1HmS8F3GCg2nRMWSwI+h6QaRrLD/1Dqf6SbRl50HLeCttqbfkMCUgwihm0CtM
	PBuJLN4sGp+t03nM9Wb5yp3rvM5A3uBSs6EgK1OVffE9Q1oBKI6Sz5hPTPk8MJ4e
	zrFlKUgmZhad4oO4nCLTYeAby0moQL8tM8ejPg4tCd4wM/IsZsya85SKTS9e4NOn
	XgntOpbC90Ndy5kRhRUXuk0D1UThBkb1egopDR+MSWz9KqYyEDriy9n4H113qofT
	Jf7Qw==
X-ME-Sender: <xms:cUAUaszITRQkIWaToCAWt6E8OwqIMsumT17mAPrzrDD5OrhlzBLJKg>
    <xme:cUAUas2tYQNzrvgTL0WzVUMPCF7Uym_f-XHq2dmax8WirWuiiJfMcHCKnAmmu6o_n
    SdsKiowyiGw9GYYm03lhadXY_8cfHFxoi9MkEh0EXnSpzF-Zb-GKw>
X-ME-Received: <xmr:cUAUaixnX6W97r_-ixmRa1IlMILVulRSR79qp_gcA7eaMB0eC7hnHT20elcxoQ>
X-ME-Proxy-Cause: dmFkZTFmLVSfYhEWaVm8N1lz0MjOBghKLhOnNQasw0tsXAFLPpbR/4+mrCYwWk/E423Vc2
    6B1s9iPuQgs3hGAiq/KhPqohuBMRIerNkWvsfuc3WkOHbHUNY5UmaGor5ig336hIeD+vak
    qB6bs2DTG0sfepDSzSArpLeFa7+n1qOspSUGgNQVB9KbSSFSgvHhLwD2o5NL2Su7Xc1htX
    UOwFpxHBdUGOki2ZYo2cYxe64jTF4NfawVkw4Ja9Vghy7E0XBO4BxqVYRhKiY6uJ4G3d/o
    hkvinoVmY3c44Mzh6S5sf4JfJ6aY+LIcesX0uapyNnoENtY2BlNnzIGDNJPpi4n9s/a/DJ
    LprHi7FiSE/fgYhxe/BjuSpyeQPnWSEilT39t/aKOY8t9gYUecDfv8L9eVhRUAhg74qkQ/
    WqRlJeyvs19duWwI/bl1do5AYCuIiTqFWjbSaleBXTaUcEh4sTJWY/csmgp461OAUy56z9
    oVRZMyXj2SfXFOdoVlcYJvliB4O8sxkT8audmLmaaZiILjwzOk4BiMzV7TFjYVjXFnmDan
    iTX2hUScootmpEfESLz9WNnPcY//s7On4y4owMGES5ADVrpWGavj7sDTfCZEoRfxavPA8f
    tIEZUpx2PEaoL3MXTHZgROjd9rz9rCY74HFOm0laqi4pYQZMmBLvwFUlt5pg
X-ME-Proxy: <xmx:cUAUahV3VZVwnNK6Hd56vGW6NYJgOlYiA49Gf5ao67-Od2d8Se51Gg>
    <xmx:cUAUau9p2rf2NH5T0ODayQc-Lnas6iAqNvsT7VvUT0h4WnwUOLpWhg>
    <xmx:cUAUaktMgkY4oXzN1YhQlBugV9RdWSDIc8RrLWE0gvYf4b6UW99uRg>
    <xmx:cUAUau1G6ggS0JSdcFSfbzg5zYd0Mu1m8cSAJU3_kILGEtmcxJZhOg>
    <xmx:ckAUaofKTOprT1I5B1WHOsb7JPXKL6UUlECTUShxlJAuwOG1Inle3Pog>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 25 May 2026 08:28:33 -0400 (EDT)
From: Kiryl Shutsemau <kirill@shutemov.name>
To: alx@kernel.org
Cc: linux-man@vger.kernel.org,
	linux-mm@kvack.org,
	akpm@linux-foundation.org,
	rppt@kernel.org,
	peterx@redhat.com,
	david@kernel.org,
	kernel-team@meta.com,
	Kiryl Shutsemau <kirill@shutemov.name>,
	Kiryl Shutsemau <kas@kernel.org>
Subject: [PATCH man-pages v1 4/6] UFFDIO_API.2const: Document UFFD_FEATURE_RWP{,_ASYNC} and 1 << _UFFDIO_SET_MODE
Date: Mon, 25 May 2026 13:28:14 +0100
Message-ID: <20260525122816.1956804-5-kirill@shutemov.name>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260525122816.1956804-1-kirill@shutemov.name>
References: <20260525122816.1956804-1-kirill@shutemov.name>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 056CE40009
X-Stat-Signature: o9kqruseu6gqufndou1s6sajkzazkuc7
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1779712114-83345
X-HE-Meta: U2FsdGVkX18+GLnr9uRDYjKIr1FnAXvGaG337K+PJnAZmzCFYNCbq1nB+z6x5H6qspgFKBHO1yhern8Wa4pze5cwq6CQ1Y2VFmPW82K2h3qBHXqel6yXFluCsVhjAWAjANBDgxjV+5S/1LYf57q0qqFmj6nKodX4agqUwXh1GFsSPVrTFHBPdd5qBf51aBPLqr28rh+feDARBS90kM8Dif03nRiSZu42KC71U+t6CzIYoMDSGWfaipgbcVIuH2AYZ4bchHWS74/C46xNh/4xb3Qnq7ipXPjHAON+RYzMvFLya9Kg76qnsG5grqRY6rzcj3s6XO+VqMurjae9gUFFwZAQ/8Gf95p37d/wbtMJco0e4E+to3+Y/JhB8biDWqOLMhJqXLflVhCiLZjdPkKs+lXWT+03EMpqAiN6u1goH/pKobS2Gv4ro/Tuv4AD5dM+iPZ35EVeVqa/ieB4RDmrfhj4MrdVcGes2x3XUaTou6qPEhmNODAt9YI/kw+/vW8IDitIyEqM535PTKvx58kKWEfTJr4rYM93fftIK0epVbTt8M6tPJgcn/eH+MSwaV+5dmjJ5al6FJLaDGsLID/kdlkloZ9qgFt0RmfQLh9d5rslcR0dSC97hxa2pJzZ8gUZOSV0HLXGCZcUDvfupqocP0p7Xs+6+z8CuS96pVD9by7RGWE8aILAweM/XBG9xBJrGHNb2f/2VTLv47E61Mx05HYiVPXuXZbtwLXl/j0+aAaMseNdsuJkRepCRc6VWQqWtqkd7h686hNHQLbKBFCtv+DCKfspHEOiKLb3TWM32NKFnzG6r/mHiUUPUuxnOaXqHLCZ57tK3/zlgsIzE2M6sT0BqWN0G2B/rtSDAsdVe0N6oFoGVEZPx7dpWZ+7SsgL33gY4h4QZb60h1kOZwqh9+IVe2rjojiq3rvagsOAf16Ycke+qNBAce2jMyiwTQBMWdNCl5/bcmpSmYRTMPK
 FsGwZKuc
 X+ymTMqhk+AWgbajMWtziKzjDCl70tvmZ9LYJouyILnW6uQ16QLkpaX7Dso1wYHB13yAQyoBESEIGmw+eofMnws8Hj9GuyCRNrDdvRvw4ljfmOcbbzSoJNp0DS91dxHQBhkBHULajtsKl/4X7GByGM3WxY8P+X8rskaCrpWivfRrC7MkLaXdpQNYVKwk5t+Gg5LB0SlsTdujoSghLc1ZECgjXYK0rKX/6kXObIFYD2yVVr0q/6HrYdo7WDQKo9Q8ykDdA9zjRWHOqZZMJIP2sELba6oGJTj29zuQRZBwI8LtQL9HCmS75W1mnQyUmnZoBrIzA5o93Vvx8BDn3SiXh8ZcWzYcys70uE8wiJAhcLdoDlynyDqglrGJg3eN2EV5mEtG0Wx87v9KjWTkc1cvFMV1zuXD1IDLXvOJbEDxYuPRsMjbkiKTyAAawSNmrAORFGJ/uDeQBO/Q6///1E4XcnZMutsqjnXEEqFc8IwEwRqXzovidSgJJ2vv1Dg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add the two RWP feature bits introduced in Linux 7.2:

  UFFD_FEATURE_RWP        gates UFFDIO_REGISTER_MODE_RWP and the
                          UFFDIO_RWPROTECT(2const) ioctl.
  UFFD_FEATURE_RWP_ASYNC  in-kernel resolution of RWP faults without
                          delivering a notification; requires
                          UFFD_FEATURE_RWP to be set in the same
                          UFFDIO_API call.

Also document 1 << _UFFDIO_SET_MODE in argp->ioctls, the
file-descriptor-level bit that advertises UFFDIO_SET_MODE(2const) for
toggling UFFD_FEATURE_RWP_ASYNC at runtime; it is independent of any
registered range.

The existing page intro already describes UFFDIO_API returning EINVAL
on unsupported feature bits and the temporary-uffd probe pattern, so
the new TP entries do not re-state that.

Signed-off-by: Kiryl Shutsemau <kas@kernel.org>
---
 man/man2const/UFFDIO_API.2const | 29 +++++++++++++++++++++++++++++
 1 file changed, 29 insertions(+)

diff --git a/man/man2const/UFFDIO_API.2const b/man/man2const/UFFDIO_API.2const
index e894114bb8e2..d2819f009f97 100644
--- a/man/man2const/UFFDIO_API.2const
+++ b/man/man2const/UFFDIO_API.2const
@@ -213,6 +213,28 @@ If this feature bit is set,
 the kernel supports resolving faults with the
 .B UFFDIO_MOVE
 ioctl.
+.TP
+.BR UFFD_FEATURE_RWP " (since Linux 7.2)"
+If this feature bit is set,
+the kernel supports read-write protection tracking, and the
+.B UFFDIO_REGISTER_MODE_RWP
+registration mode and the
+.B UFFDIO_RWPROTECT
+ioctl become available.
+.TP
+.BR UFFD_FEATURE_RWP_ASYNC " (since Linux 7.2)"
+If this feature bit is set,
+the kernel will resolve read-write protect faults in place without
+delivering a notification, automatically restoring page permissions and
+letting the faulted thread continue.
+This bit requires
+.B UFFD_FEATURE_RWP
+to be set in the same
+.B UFFDIO_API
+call.
+The async mode can also be toggled at runtime using the
+.BR UFFDIO_SET_MODE (2const)
+ioctl.
 .P
 The returned
 .I argp->ioctls
@@ -234,6 +256,13 @@ operation is supported.
 The
 .B UFFDIO_UNREGISTER
 operation is supported.
+.TP
+.BR "1 << _UFFDIO_SET_MODE" " (since Linux 7.2)"
+The
+.B UFFDIO_SET_MODE
+operation is supported.
+This is a file-descriptor-level ioctl and is reported once per
+userfaultfd, independent of any registered range.
 .SH RETURN VALUE
 On success,
 0 is returned.
-- 
2.54.0



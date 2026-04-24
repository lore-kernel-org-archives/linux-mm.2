Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2C460FED3E6
	for <linux-mm@archiver.kernel.org>; Fri, 24 Apr 2026 17:58:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 964036B0005; Fri, 24 Apr 2026 13:58:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 93C0E6B008A; Fri, 24 Apr 2026 13:58:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 87A2E6B008C; Fri, 24 Apr 2026 13:58:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 76BC76B0005
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 13:58:45 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 09C631A029A
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 17:58:45 +0000 (UTC)
X-FDA: 84694209810.20.87AFA7D
Received: from mout-p-102.mailbox.org (mout-p-102.mailbox.org [80.241.56.152])
	by imf09.hostedemail.com (Postfix) with ESMTP id 3AA8B140011
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 17:58:42 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=mailbox.org header.s=mail20150812 header.b=R9qkjMSy;
	dkim=pass header.d=mailbox.org header.s=mail20150812 header.b=pwT3bnAO;
	spf=pass (imf09.hostedemail.com: domain of manuelebner@mailbox.org designates 80.241.56.152 as permitted sender) smtp.mailfrom=manuelebner@mailbox.org;
	dmarc=pass (policy=reject) header.from=mailbox.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777053523;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qbmj4N7zVRXMGmZLFvMThNK9FT5J1PyFY4flNNsMSN8=;
	b=FcRM+tJqkrEN2U8Vs9K3F84Hb8C7F+rpXeJKIlTIjgJ8m1f0nOrzjBdPpT/vDCGIJqnxBc
	kCmCoqIO7v47QWiqjZpV94wZRQPzK9Gf94H+06WnEOqoA7vXzU+PokHUIkHIwDP/0CaHsn
	UeG25CoyUV6NwRxzCgC9bCEIUGJncw4=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=mailbox.org header.s=mail20150812 header.b=R9qkjMSy;
	dkim=pass header.d=mailbox.org header.s=mail20150812 header.b=pwT3bnAO;
	spf=pass (imf09.hostedemail.com: domain of manuelebner@mailbox.org designates 80.241.56.152 as permitted sender) smtp.mailfrom=manuelebner@mailbox.org;
	dmarc=pass (policy=reject) header.from=mailbox.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777053523; a=rsa-sha256;
	cv=none;
	b=vWeQQ+h4nqLY4luvS+LF1XtQAzPoWChQorwyjvG819kLq+F8mInS0NASluxXokGMpFt5I6
	9aUm0LuV7q34qdCfOks9I9F7oTXe8VGKXZw90KO5mio6ZgjFCMqsPq9X1ws25i6OAL86oM
	wkjkvld7HOjO62f3CnDgGMjkJpEOYVQ=
Received: from smtp102.mailbox.org (smtp102.mailbox.org [10.196.197.102])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by mout-p-102.mailbox.org (Postfix) with ESMTPS id 4g2LL85nN1z9vH2;
	Fri, 24 Apr 2026 19:58:40 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mailbox.org; s=mail20150812;
	t=1777053520;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=qbmj4N7zVRXMGmZLFvMThNK9FT5J1PyFY4flNNsMSN8=;
	b=R9qkjMSyiwaQjWRzXBNpTSUIWbWsAfXsv49hFEeAOdYYlwR+JiW6o+S45yOmPKBHGQVUpT
	1O8J6J9TvxacnjFiCOyHVnsPZ0KvjnzBJDNVv+j6pQ4/ovOO99PEbPHzkgagw0ANLSUwi1
	EgWR63TXF30/qVnUEx/blRgVibsi3Qi4/SC9geXIeGR3o9qHtjk6GkXzG5qv8BTJlAwUZU
	ZQTZCxH9OzeEsc5NAFMLwxs27CecxtJKIf3NVZFhmXVZREYPmdm1IrUpoFJsSFqy+KJrXb
	X6qkle2GxesheTs8L4DSU/EE9cSPl5UJDm7C4gGSmcLe407g73hl/0qxg/6amg==
From: Manuel Ebner <manuelebner@mailbox.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mailbox.org; s=mail20150812;
	t=1777053519;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=qbmj4N7zVRXMGmZLFvMThNK9FT5J1PyFY4flNNsMSN8=;
	b=pwT3bnAOb25Bn9wWaYULL37PxonTvnBMeSVvOzX9cI6Q8bdWB6m0RNqSW4mp5GcFT86Dml
	YPt1tzGS2UP5PiuFkJ+Sq69vvixA7YUSmUqC3+b5BZuY2S+nPBUP4pI9ISYnqfsx6SFUDr
	ZfAxlDErVCukSTZgDzhz5AARbasAUmDGECgNs+AVqhu0U5r3bCqnrzXdch6zC+O4PTc1VE
	1YywZhgGJ9Hh7OwvqnY3rwCNIa7UoC4evGzCq4OdTJ4ACgD7OUr5w2HBvOpmLvUXeQLDVW
	3YEs13xtO8IfshXpfKUsAuETjeaCHnf77FD8c3SVVQSKSOZ6JE9oQfoNXBzGAA==
To: Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	linux-doc@vger.kernel.org,
	Kees Cook <kees@kernel.org>,
	linux-kernel@vger.kernel.org
Cc: workflows@vger.kernel.org,
	linux-mm@kvack.org,
	Geert Uytterhoeven <geert@linux-m68k.org>,
	Manuel Ebner <manuelebner@mailbox.org>
Subject: [PATCH v3 3/3] Documentation: deprecated.rst: kmalloc-family: mark argument as optional
Date: Fri, 24 Apr 2026 19:57:41 +0200
Message-ID: <20260424175740.258522-2-manuelebner@mailbox.org>
In-Reply-To: <20260424174743.257951-2-manuelebner@mailbox.org>
References: <20260424174743.257951-2-manuelebner@mailbox.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-MBO-RS-ID: ea0f62450519231096e
X-MBO-RS-META: bw1i5j7yaog7suqknwjmjp5j44mwcpws
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 3AA8B140011
X-Stat-Signature: 1ecb6g6gowk6fjoghaq96o9d4ic6hi1b
X-Rspam-User: 
X-HE-Tag: 1777053522-362933
X-HE-Meta: U2FsdGVkX1/Bf5vccoKkzcigo/u8Op0TwEtTqmzpPkWMPFtGD4F1tfWnxc7PMqGSydpZu6ppvuX7Wx/4YFAmoIRC6YfjKmyD6F9PrJ3bio862ojYVldHtP3oeAAOMkc15nRdlbleBiNGbqZ63mNL6cCI58a7TzzJF27gOd3PyCnJ/4irT+wA4PseIgbrOvWPq4FMsFSUoFCQDaXULei8tRc7zU+CR6juPRzS0yqyZ5KXtktQEWDbo+1mHsA8CLHsK9hNiLyOp4MzJ4uEoJU3dCHAgFIKs3aU66VnubY1NipVNyh9SxMdu2+WoiJeGq4cSBIGM+gTdEM3NKKCPJuTWzuKlAWOP5CFvTBURMHrimkQxQ5jKl7FDz9pYod8tBvWBmwygtdNU93Guy+nNqucuU8YoI88Y62K+sgSxMDRvcR/d/G7mQkCuF1qS2DpAxd/GG9DXB1+tynH9D51M31XEyy//wcSUkTri20Sn8216eHDMs0Me9jSo5jRdJBowyG7vQtPVOzd9egXcJkbXFd5CisnhOWoe4lPGPojdEtq8muIM09kAYYlAxQbqLSVSTAVMePtQM90JwnIAJKqcf3+dqgoMcbjjG13HFuy+sTtR3wuZfdD4tMzwDi4phMM0bTlHSc5nUTSVTXdRVkBrBXBVM9XNc8ou9iWbjXiR7i/UYu9aRfRnkCxDGmelk0zU0ane8vz5Hv89RRdjjNCRO/AeUoZWhJSHkzy8BSWJoJsIKp8Wq92Uo3ClyOnBSuNc034O6Io/xD4fMkMudKk5t2mkX3G2pA+wN4qm+9CyqZ4iOxM/2q+XLHw0yvc/lJ98UC1jLq8BMrSWd5S1k6JC5uMy+nSn9vSP23Efpk0/GQrUYmGDqzxqP/p7bFA/khyBUMmyikmAXGaFTi7qqDEk3FzGwuMdeUBgfguY2N63bHkiunBi16Xx0rMnL5hZ7jDTfCqzawaFvB+sKG0XaauBLq
 XHHv4I7r
 Pp/DBdlyaKZF0QoZ/R5GYSZbLaPLk5yrNMB/boktm2uWFzNy4WgkFTXdG0haJd0/qr8H0ryXLkDNNuV+CmN/O2hl4C9/i73v8Pm4N8OnNzwiHuM/YfORg3TjloiCOAJh9jZ5rUN6UVpleHrv5l7cxoTqFCF/8Bc1zY+BDjHmWJRRehG8WZH9fUeiyceZnMAwvJBEoTIm8jLRu4xO4IduJvXyFp1mWUnnbzFTM/gj0Cy+MnJDjPYV9PP3dJclaRvRa4r2E9wndFOYQ79mhgR/prZAp2J7+iLzFqqje+o1BP4U9qEEVB1nCF0rz9g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

put the optional argument (gfp) in square brackets
add whitespace for readability

eg. ptr = kmalloc_obj(*ptr, gfp);
 -> ptr = kmalloc_obj(*ptr [, gfp] );

Signed-off-by: Manuel Ebner <manuelebner@mailbox.org>
---
 Documentation/process/deprecated.rst | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/Documentation/process/deprecated.rst b/Documentation/process/deprecated.rst
index fed56864d036..b431993fd08e 100644
--- a/Documentation/process/deprecated.rst
+++ b/Documentation/process/deprecated.rst
@@ -392,12 +392,12 @@ allocations. For example, these open coded assignments::
 
 become, respectively::
 
-	ptr = kmalloc_obj(*ptr, gfp);
-	ptr = kzalloc_obj(*ptr, gfp);
-	ptr = kmalloc_objs(*ptr, count, gfp);
-	ptr = kzalloc_objs(*ptr, count, gfp);
-	ptr = kmalloc_flex(*ptr, flex_member, count, gfp);
-	__auto_type ptr = kmalloc_obj(struct foo, gfp);
+	ptr = kmalloc_obj(*ptr [, gfp] );
+	ptr = kzalloc_obj(*ptr [, gfp] );
+	ptr = kmalloc_objs(*ptr, count [, gfp] );
+	ptr = kzalloc_objs(*ptr, count [, gfp] );
+	ptr = kmalloc_flex(*ptr, flex_member, count [, gfp] );
+	__auto_type ptr = kmalloc_obj(struct foo [, gfp] );
 
 If `ptr->flex_member` is annotated with __counted_by(), the allocation
 will automatically fail if `count` is larger than the maximum
-- 
2.53.0



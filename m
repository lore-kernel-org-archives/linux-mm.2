Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A8B18CD5BD1
	for <linux-mm@archiver.kernel.org>; Thu, 28 May 2026 10:24:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4980F6B00BA; Thu, 28 May 2026 06:24:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3FB506B00BC; Thu, 28 May 2026 06:24:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 335586B00BA; Thu, 28 May 2026 06:24:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 15EF16B00BA
	for <linux-mm@kvack.org>; Thu, 28 May 2026 06:24:38 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id C960F4079A
	for <linux-mm@kvack.org>; Thu, 28 May 2026 10:24:37 +0000 (UTC)
X-FDA: 84816444594.29.691E31E
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf04.hostedemail.com (Postfix) with ESMTP id 3362D40007
	for <linux-mm@kvack.org>; Thu, 28 May 2026 10:24:36 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jDLFSNtp;
	spf=pass (imf04.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779963876;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=d+AhWlAChbSoPeU9eNoAX+z4q2Nry8L3D0tILMGrjBs=;
	b=StiRQNvMdUxIFOaIXQj3cbptvMyiJNVa0hyKBdAGB1AAXX8UfRTndpkNwSxP5YQnSgXuDT
	UokjGhxilTjOXyfo4rldjPaicjtz1PV/iZ2PIGZMwwNd8iKKFbuFrpagdcKIC/5xqkJLbD
	rkwAFhMSVsjl7HHgrbpeIP8hLe2/NLA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779963876; a=rsa-sha256;
	cv=none;
	b=qgmS1TXcAzpQB51nJj0uqDMCcjE2Vk6/KFh98coGLpahd75snXyZOhgqM/gIV5niqf2h7V
	sAd5dsmhNXY0pGgUlSWKY5ZQTFzDqIpIRO/xzpAfihR6KN/MNJdMFr4t7WuFulYyhpVlCP
	mDnTcmfXBTPZ81rG+ehKAqo//wOS2aQ=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jDLFSNtp;
	spf=pass (imf04.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id CD0A9605A7;
	Thu, 28 May 2026 10:24:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2049C1F000E9;
	Thu, 28 May 2026 10:24:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779963875;
	bh=d+AhWlAChbSoPeU9eNoAX+z4q2Nry8L3D0tILMGrjBs=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=jDLFSNtpWZ4SFcdq99qvcWECTH5S6J0WzXpd+KaYIl/yvHuKNiW3aEio9nYC9+2RK
	 4x4JWGPm+LvHELdJtX30I/kqk2y4PeDX9Ki9+JljaVcJ39Ai6WaElHwymwfd2codid
	 UcL04/DHTGnP5xbgzH9HquhxgUra/Fo7vAyIaS+Jy40mY6StyQDvbw0grM5SeHpSSi
	 CvI2iQSYk66M9SxrrUrDE6dbqxjJO/n7WtGTtrp4XQK3Tw2EC86lnmILQf8b2OGU0c
	 hXK7vagS6/sY0DL5nVWKo6dnl/u0On2wLsBckqDx194Wifl95S2QxFm24qwABEfa+l
	 bRWrVnE2bpnxg==
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Date: Thu, 28 May 2026 13:24:20 +0300
Subject: [PATCH 4/4] vc_screen: replace __get_free_pages() with kmalloc()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260528-b4-tty-v1-4-9da9f7aec5f2@kernel.org>
References: <20260528-b4-tty-v1-0-9da9f7aec5f2@kernel.org>
In-Reply-To: <20260528-b4-tty-v1-0-9da9f7aec5f2@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
 Jiri Slaby <jirislaby@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>, linux-kernel@vger.kernel.org, 
 linux-mm@kvack.org, linux-serial@vger.kernel.org
X-Mailer: b4 0.15.2
X-Rspam-User: 
X-Rspamd-Queue-Id: 3362D40007
X-Stat-Signature: r7qmxfd13fz35ub871u5pa4bgdcetya5
X-Rspamd-Server: rspam06
X-HE-Tag: 1779963876-244
X-HE-Meta: U2FsdGVkX1/uH2tHFctSlusL5W+5khqnP1PFO4opItakAVG3gCEq11aaqlsrdiZzE10l9m6nNj2RXw9+voQ/tXATR0wvTR8Hj+UhOrrSvDnGYfltr9GL8PmRdQLnhqBX7acHI/L2RWuzMLu3qoJxAkml+2yR22lKPMQ0QL9/oqgYMG2xUU5u6rdpyrKtWupKV6Arl2tI2biLBipB/lirNBptY++Hov5OSCv9Nf5kP8ho/SGAmMkShHg4iRaSBEy7rGSpBV4uxFtCcQeGYkheg5sX7C/XiJ59185CffDUfT3vtVRpr9gDdpYEnu5Gcyrg9wX37OWBAPcKzjL93k0XXqLeext/n94pvhShgnr4nYMjdEbnKX2jaL41xJ8A6uuXzH9TdLWHKqxrmIMxuAAzNXEKG772SFWS292BuaURhvpBMivMzdBGHN9nzUQTaUcTTWZUDAyqs9nTlVRVsYcjSyk9Zqxrm79vt1bHigfC1xrkwKfd0aX3rSChJJD52YSV6bdHyhajv1HpqOcbqnIHTRCoRD5A29idoVq3DZSzRswzn/f+gJC+QF3rT5YjXpOEWIvnVXfUSSM4ufL1Nlo8dC2pBOMzRxCGcwP8tsYXdmAyGuTiBaNLWs7P1PcZUP0XBbnFJ3qHehVxfuI0vWPLoGzSUewra1wNJCY9liZix4+BI+KQ1nBUqs/P/xSP6IspgfiSZ2Kh8HQATmAwbbr84mvzk2VaeeXMxmUTF+HaW5BvfTGVysRZDqLpDk2CgD9uvh1fyj9wHO4lFSzZOhg7f4n+md7tO2YXrIw4PbE0VkOFo8qJj5z32xh2hVibyBQLqHgE+2DeYzMVnpnuLBPhXZwdk0eFHjxHu3pHomAdB/7S6Fw46m6b8pWPdO9rLI594fm2wka88Hz3j4SPoMxcR/vL21jTNR5lmATlQWJWQ7rgg1nN8FLrGPHi91LAMF62v7xJ7VKollsb/TLSIgn
 ar8Q93QW
 HrcqXuAIbhKv4EYpgQibG7mWBKtOijdDgQ73ufaQvmCu2cwBrHVBnKsAFu+IeGtFFHebmzgQcQmD7gQdVOcReiUluPg3ESwtpRImXVWLm4aA1dWpb8czBr+zB2LPfCKnstArEZFDW8L/DJw5LKassijZRSvqNxy4h74nhUJ4AqVX0Oa0shZBNO77Wsmo9FJco2Tmd8p6NAejGe54dzoMV4AgnAArwOoIfVQd2UKKJPVYeeOZ5ndKBlqmmUmJXGfPrgb4q0O4ypTg8r9o32ZmUjsNVKndrsE+NmULg2eQrPwbViiFiakHRvprL6Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

vcs_read() and vcs_write() allocate staging buffers with
__get_free_pages().

These buffers can be allocated with kmalloc() as there's nothing special
about them to go directly to the page allocator.

kmalloc() provides a better API that does not require ugly casts and it's a
modern way of saying "I need a page-sized buffer"

Replace use of __get_free_page() with kmalloc() and drop unused now
DEFINE_FREE(free_page_ptr ...)

Link: https://lore.kernel.org/all/700c5a5f-3128-4671-99aa-827ca73f5cdf@kernel.org
Link: https://lore.kernel.org/all/635405e4-9423-4a25-a6e7-e03c8ea0bcbe@redhat.com
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 drivers/tty/vt/vc_screen.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/tty/vt/vc_screen.c b/drivers/tty/vt/vc_screen.c
index 4d2d46c95fef..386c80efc672 100644
--- a/drivers/tty/vt/vc_screen.c
+++ b/drivers/tty/vt/vc_screen.c
@@ -53,8 +53,6 @@
 #define HEADER_SIZE	4u
 #define CON_BUF_SIZE (IS_ENABLED(CONFIG_BASE_SMALL) ? 256 : PAGE_SIZE)
 
-DEFINE_FREE(free_page_ptr, void *, if (_T) free_page((unsigned long)_T));
-
 /*
  * Our minor space:
  *
@@ -371,7 +369,7 @@ vcs_read(struct file *file, char __user *buf, size_t count, loff_t *ppos)
 	loff_t pos;
 	bool viewed, attr, uni_mode;
 
-	char *con_buf __free(free_page_ptr) = (char *)__get_free_page(GFP_KERNEL);
+	char *con_buf __free(kfree) = kmalloc(PAGE_SIZE, GFP_KERNEL);
 	if (!con_buf)
 		return -ENOMEM;
 
@@ -596,7 +594,7 @@ vcs_write(struct file *file, const char __user *buf, size_t count, loff_t *ppos)
 	if (use_unicode(inode))
 		return -EOPNOTSUPP;
 
-	char *con_buf __free(free_page_ptr) = (char *)__get_free_page(GFP_KERNEL);
+	char *con_buf __free(kfree) = kmalloc(PAGE_SIZE, GFP_KERNEL);
 	if (!con_buf)
 		return -ENOMEM;
 

-- 
2.53.0



Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 965C3606A321
	for <linux-mm@archiver.kernel.org>; Thu, 12 Nov 2026 11:51:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=debian.org header.i=@debian.org header.a=rsa-sha256 header.s=smtpauto.stravinsky header.b=nGqxesdb
Received: by kanga.kvack.org (Postfix)
	id B885D6B05B1; Thu, 12 Nov 2026 06:51:20 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B38CF6B05B2; Thu, 12 Nov 2026 06:51:20 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A2A246B05B7; Thu, 12 Nov 2026 06:51:20 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 76CE06B05B1
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 06:51:20 -0500 (EST)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 08DCF14055F
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 11:51:19 +0000 (UTC)
X-FDA: 85426301520.29.E96B89D
Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	by imf12.hostedemail.com (Postfix) with ESMTP id 2109C40003
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 11:51:17 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=nGqxesdb;
	dmarc=pass (policy=none) header.from=debian.org;
	spf=pass (imf12.hostedemail.com: domain of leitao@debian.org designates 82.195.75.108 as permitted sender) smtp.mailfrom=leitao@debian.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794484278;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=g7FWRyAWx3iB3hlRZqVCNdy5X/7Do0taWr0Tn8+qOx8=;
	b=TUYY4kBuoTgTXOtVVE5iR98M21dDkd/w8gyYe3wLNq1onQh/bD/KWsHl+uxItQWHAKrUYL
	J+YNs32dF2veBwRHJMEEIciBcWrYq7twz63uLVjrfOWK8k6Vu7wqugiaWd7iORr0E/C9cr
	MKFux0ZyDWbaMzx+2SqZmRYN/y8uUF0=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=nGqxesdb;
	dmarc=pass (policy=none) header.from=debian.org;
	spf=pass (imf12.hostedemail.com: domain of leitao@debian.org designates 82.195.75.108 as permitted sender) smtp.mailfrom=leitao@debian.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794484278;
	b=FtpFMk8/bNuMAB8gCVRv1jsC/VBKjgoc2y6omEgiOpunY7VIbsKB7PkVpIGQxae3nePWzq
	uyU+kNMoC05+No1+uf0ABzvH5WbEF7H4SmiPgTXp596tVckUqK0rbEWaEN4zNZ6oXGPYwk
	mwp9pexhYMK3tiRn+eTfAL2LHVjAFJs=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:Cc:To:Message-Id:
	Content-Transfer-Encoding:Content-Type:MIME-Version:Subject:Date:From:
	Reply-To:Content-ID:Content-Description:In-Reply-To:References;
	bh=g7FWRyAWx3iB3hlRZqVCNdy5X/7Do0taWr0Tn8+qOx8=; b=nGqxesdbR6d9Ua9L5bkKBBOjTh
	QgctO79YpZ67I/sIEPJREr9odbEn46+T5jArFC2qvjaSlHzKVoJFT68z5nEpJ2m3KSD8cX6e4q+0E
	4LVcnUroWVuHJwVAi+imRMbSvxMcbw1DtgNOxDad6JaHMTLv8vTq3qvi/JpJJr1XokqiU6NTKVlNk
	BuxgTME0IfkiV5dHsySQOwRX7AsDfbolv/zREnYR71PAsDy3EZEfwbiu/1hWBfRHLngjklD6cjZPe
	Rnm7TogyRoZwEA5xHu3Z65nis7i7sKT/asvrrP/oEpqs676c4vzajclvUX9pWeRKs6Zvh6t/AQc8j
	uenTHG0w==;
Received: from authenticated-user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.96)
	(envelope-from <leitao@debian.org>)
	id 1xRTKg-00DwvO-2J;
	Thu, 12 Nov 2026 11:51:10 +0000
From: Breno Leitao <leitao@debian.org>
Date: Thu, 12 Nov 2026 03:48:01 -0800
Subject: [PATCH] mm: kmemleak: drop kmemleak_lock in scan_block() when it
 is contended
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261112-kmemleak-scan-lock-break-v1-1-95808108d03c@debian.org>
X-B4-Tracking: v=1; b=H4sIAHGn9WoC/x3MywqAIBCF4VeJWTeQRtdXiRZmYw2WhUIE0rtnn
 d23OH+EQJ4pQJ9F8HRx4MMliDwDvSq3EPKcDLKQtUhDu9O+kbIYtHK4Hdri5D83U9eKlkypZQX
 pfnoyfP/pYXyeF+laqspqAAAA
X-Change-ID: 20261111-kmemleak-scan-lock-break-7b9818ef3c25
To: Catalin Marinas <catalin.marinas@arm.com>, 
 Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, vlad.wing@gmail.com, 
 harry@kernel.org, kernel-team@meta.com, Breno Leitao <leitao@debian.org>
X-Mailer: b4 0.15-dev-47773
X-Developer-Signature: v=1; a=openpgp-sha256; l=3656; i=leitao@debian.org;
 h=from:subject:message-id; bh=5T6aw43QawtVXoj03pz2K45DQEaN5hI2WF6eNsaihxk=;
 b=owEBbQKS/ZANAwAIATWjk5/8eHdtAcsmYgBq9agrMcaniPNKq+f+xzNvrI/ZBfuc29YpGKNtc
 sAnAZOJ/nSJAjMEAAEIAB0WIQSshTmm6PRnAspKQ5s1o5Of/Hh3bQUCavWoKwAKCRA1o5Of/Hh3
 bRw9EACJvTJW9K5mhUfirEyEVQ7Lx169JsyzK8Pr3C3zk4+GuqS1zUsehkhFsfBw4NPj50QHuZY
 rOoLy6jTBW53IJp+y49qmaIcq4PflE8OFKmcN+HXWjotnfNMgkba+Es9AM5iAAQjXo4CqpSvsGw
 JFa92bugEDjpOtSE2ypXIZ/yo1ikNPHZJpZEiZL2Td5N9pZhm63fUDHq25lR5KWPzQiCHfBzRG1
 G1Co7fSMivFc4a+QPe+GRdkvoyo/V6yDLstg0XLnhejUI/Sk0bvdWltBziLhNgVqq4IxT4XhGwJ
 OuNkZUalLv/eMHTyQ12KmpPd59Dsx+NooOpCv9COmBzFiTAQRPCkzeihgx75dM2kiOixvAu3pxy
 uhjODEH59TxiYxICL/kC4Qrj+OcsToEJVpsdu7GThI+9NrMKHlcfVAm/H6DQt4tImOxCr19UK4c
 uuDtrBNMbAncBqme2egCrCrxABykQb7BWBmNdwMe/w1u3HTojKQpA5oL1RbkJ+UxuI3g6Vz7AVN
 u07eok+uVTMf2I0fexXIYzaU4FsbIYfhJHoGZx65zkUo4B1OO/r5a3FvrbzZzS525RIbOKJNu0Y
 XDJqHj3boK7l81n7AnCDbtAceVcgiol7/zq91i441F+RkOarNH94tKOKrHSqqSDbBWTj7mGkxam
 cmE63B5CpL/q1aQ==
X-Developer-Key: i=leitao@debian.org; a=openpgp;
 fpr=AC8539A6E8F46702CA4A439B35A3939FFC78776D
X-Debian-User: leitao
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 2109C40003
X-Stat-Signature: 4xbbjnkrf1p4xaguwq3ppco9uenemb9a
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794484277-730520
X-HE-Meta: U2FsdGVkX1+IqbRSw+coFla51aQgMGMJiNIlCZ2mr5CAyI7xMYU9uOCODXNLF/MBJYM6ki3quhC4ILJ6gCgPr5vbJ/KB78GTeFYqpaTyZf2TCOq9PnfBHHB+FUJh0vxnzLJeAaAI+DRABIS5bda5CS2asj0P8WMO3oHFbKl8ijJZChDh7Hobnu4P5RwH79TJUnJB/o2MqoQ/BD0hWNikGe6HhEoOUwIAgtHfjRY6nVYauRnjuuS1CasGPGFtssxp5a0GuOVYcYsYreH3y+vBnMPW5/jUDmLQNcom7g31fd6hnj0rNtLReRIVJzQvxyVv/uzwN4VkpYsXyal9MfnJnJaYBZQuZFOpLmkjHd3mpeo5obUk3MilGQrljp5gS0B8Sk26nQq5SEEbKZk0qerr0tE3PIfzx38lf7gPN3kIaPRvWkNGsCCTkDzERe0nOmesAP3cLNzyM4XijN0hdGZ0huomDcBu11pxLVusIc3EDyeXWxDN2HjubCM9SrH62pbFN2lvseJ5i4sbaNSB2VJi1ZWGGZGAcsh6ibpBQeHs9cwf1fk88dTq1ahNN+kKzmiwlW6M5U8itvIrs99SHZT7160EKQl6ckWuYPpVNf9Wp4qgKZeGSI3bA9tUht8OwxaLJ+i7qwEvdt59E1fBhWbQ6xR9Le43kzL0EseDS62pA0mlgi63mTyBluGq+I5PR7UZoAgghVDsl2CngM9WpOxGs470G196tcfKXuT7JDOWOMm6WsWs010nWm+tAO3MIrS5vDy/vGsi3mq69KZwisVDhgcrTC7pgWpVFoi5EixDLjqVKGg6ymHMxNZdmqFA7sWVvd2v06QneRC/jQoSZlFEAIpgJM/vd6Y8XmwnfTcEYXvudovOFTk+wnh2ek0HyBaIfIX7z5uWIGYm43HEvggrRxONVEuqi3erFGTjQLc+Oj7Dnc/Rxyxk6Xuatorr+BxRMbogCATq6pfzlZHUHxq
 3ye8fBBx
 idJ9hPFZeqVBSLTuB+PiBm0cykivJyj8fDlz5yLfWVJGCm/QyQ6f3gBt2/tqYES1wSNbk5xvCAzKnWa6/EnWTVbRfQ/QCl4dLd+hO7i6NyWq10hmd2hVMe9dMGa9aY8E5mhe0G9chvcLiX5Uvo7FsXR8kUN9eGoCq3vHB17loztPQwk55ymGlht8iPrysh1yDA8m1m2fbOlnJBoqFoS8nQhZdmvsZBDTCjhLbbgXaSMJFiVPIJNBrNBh5edOdmtCs+K5Sv0HsNCv9laNXW/a7+qCq5kq8xzSxG8CSbO07RhmUkTOd3TrALoUXGKd/TuLmrhO7ih7t99MgXDjzoWgf7R0lgFU9X8tCD1N4AAsGh/ofqs8OvxsPeE8kIOtxZ2mUkMQ8IKvJMDUdaHgbJaToRg0VNw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

kernel_lock is a damn hot lock, used on allocations, free, NET_RX, etc.
It is also used on the scan, so, while scanning, most of the system is
mostly waiting for the lock.

On meta fleet, this is, by far, the most contented lock. This is not
a big deal, because very few hosts run with kmemleak enabled, but,
I think we can do better here.

scan_block() takes kmemleak_lock once per block and keeps it, with
interrupts disabled, for up to MAX_SCAN_SIZE bytes: 512 words, each
needing up to two object tree lookups. Every allocation and free in the
system needs the same lock to insert or remove its object, so each of
them can wait for a whole block.

Keep taking the lock once per block, but in auto scan mode, check every
64 words whether anybody is waiting for it and, if so, breathe (aka
release it and take it again so that the waiters go first)

Releasing the lock is seems safe because it only keeps the object trees
stable during each lookup, and scan_block() does not use an object found
under it past the word being processed.

Tested in an arm64 KVM guest with 48 vCPUs, KASAN and lockdep, running
stress-ng sock, fork and dentry workers on 8 CPUs during five scans.
The kmemleak_lock wait times of the other CPUs, from the lock_contended
and lock_acquired tracepoints:

                   average     p99     p99.9
  no scan            3.7us    <16us    <32us
  scan, before      15.8us   <256us   <512us
  scan, after       11.7us    <64us   <256us

The cost is a slower scan, as the scanner now queues behind the
waiters: the five scans took 179s instead of 118s.

This patch does not change interactive users (echo scan > kmemleak in
debugfs), given current != scan_thread, and scan_breathe() will not be
called.

Signed-off-by: Breno Leitao <leitao@debian.org>
---
 mm/kmemleak.c | 21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)

diff --git a/mm/kmemleak.c b/mm/kmemleak.c
index 1bca27787df625..da6d1dcdd6f6ad 100644
--- a/mm/kmemleak.c
+++ b/mm/kmemleak.c
@@ -112,6 +112,7 @@
 #define SECS_FIRST_SCAN		60	/* delay before the first scan */
 #define SECS_SCAN_WAIT		600	/* subsequent auto scanning delay */
 #define MAX_SCAN_SIZE		4096	/* maximum size of a scanned block */
+#define SCAN_LOCK_BATCH		64	/* words between lock waiter checks */
 
 #define BYTES_PER_POINTER	sizeof(void *)
 
@@ -1539,6 +1540,18 @@ static int scan_should_stop(void)
 	return signal_pending(current);
 }
 
+/*
+ * Release kmemleak_lock and take it again if anybody is waiting for it, so
+ * that allocations and frees do not have to wait for a whole block.
+ */
+static void scan_breathe(unsigned long *flags)
+{
+	if (raw_spin_is_contended(&kmemleak_lock)) {
+		raw_spin_unlock_irqrestore(&kmemleak_lock, *flags);
+		raw_spin_lock_irqsave(&kmemleak_lock, *flags);
+	}
+}
+
 /*
  * Scan a memory block (exclusive range) for valid pointers and add those
  * found to the gray list. Return non-zero if the scan was interrupted.
@@ -1561,6 +1574,14 @@ static int scan_block(void *_start, void *_end,
 			break;
 		}
 
+		/*
+		 * Only the background scan thread breathes, scans requested
+		 * through debugfs keep the lock and finish sooner.
+		 */
+		if (current == scan_thread && ptr != start &&
+		    !((ptr - start) % SCAN_LOCK_BATCH))
+			scan_breathe(&flags);
+
 		kasan_disable_current();
 		pointer = *(unsigned long *)kasan_reset_tag((void *)ptr);
 		kasan_enable_current();

---
base-commit: 793807ca13bf3072fc6d16ce6d90e9ab9beff2a5
change-id: 20261111-kmemleak-scan-lock-break-7b9818ef3c25

Best regards,
--  
Breno Leitao <leitao@debian.org>



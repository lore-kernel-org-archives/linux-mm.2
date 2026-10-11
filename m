Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 96130CA9EC9
	for <linux-mm@archiver.kernel.org>; Sun, 11 Oct 2026 11:51:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7E9736B0088; Sun, 11 Oct 2026 07:51:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 79A926B008A; Sun, 11 Oct 2026 07:51:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6D6C16B008C; Sun, 11 Oct 2026 07:51:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 4EE916B0088
	for <linux-mm@kvack.org>; Sun, 11 Oct 2026 07:51:48 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id C638D1C40DD
	for <linux-mm@kvack.org>; Sun, 11 Oct 2026 11:51:47 +0000 (UTC)
X-FDA: 85310181054.12.3896A90
Received: from outgoing2021.csail.mit.edu (outgoing2021.csail.mit.edu [128.30.2.78])
	by imf13.hostedemail.com (Postfix) with ESMTP id 1A39E20006
	for <linux-mm@kvack.org>; Sun, 11 Oct 2026 11:51:45 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=mit.edu;
	spf=pass (imf13.hostedemail.com: domain of nickolai@csail.mit.edu designates 128.30.2.78 as permitted sender) smtp.mailfrom=nickolai@csail.mit.edu
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791719506;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=WtKQiUmXAQCwelisq+SSeZKm6f3CkNSfUWX4ra6ZfX8=;
	b=WfLOlTIRaQZuJpIB7uQ9puaKk77UYEdbxSVLiRCFPSyaTlg4uTbYVJFoUBRFdNv71UD7zF
	AmY3Qw0OwXRlVPnDc2U+uBhEVzs2Oxy0ctDXHVFEe8t1hddIlpFw6zy2Rr6CBSwJDqnrbf
	zM05XhBKAZ3J8NV9hmoiekK2DvMrUdE=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=mit.edu;
	spf=pass (imf13.hostedemail.com: domain of nickolai@csail.mit.edu designates 128.30.2.78 as permitted sender) smtp.mailfrom=nickolai@csail.mit.edu
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791719506;
	b=VN7cVEnEI1e2viTszIp43a8vxoGY9kATc52AY4nq3gmiBhR1VkeMeAtyHfwuCUro+EwePX
	exb/aKohwmaK6vcihJSi+MoJvvfJhY2GbAfknLt5zeC523lDlciJ6VRQ5ZZcrCbOYuguHU
	gmJWKZdHveNAEXrFD8yt4QnK1mJ4M7s=
Received: from escalante.csail.mit.edu ([128.52.128.198])
	by outgoing2021.csail.mit.edu with esmtp (Exim 4.95)
	(envelope-from <nickolai@csail.mit.edu>)
	id 1xFs5f-00A4OF-Qx;
	Sun, 11 Oct 2026 07:51:43 -0400
From: Nickolai Zeldovich <nickolai@csail.mit.edu>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Nickolai Zeldovich <nickolai@csail.mit.edu>,
	Adam Harshbarger <handyhandyman.adam@gmail.com>,
	I Hsin Cheng <richard120310@gmail.com>,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH v2] lib/plist: add a plist_test case for plist_requeue() on the last priority bucket
Date: Sun, 11 Oct 2026 07:51:34 -0400
Message-ID: <20261011115136.767838-1-nickolai@csail.mit.edu>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261010211804.2d8a5f6180c74b08e18ad48a@linux-foundation.org>
References: <20261010211804.2d8a5f6180c74b08e18ad48a@linux-foundation.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 1A39E20006
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-Stat-Signature: prp8grb6extunu7iid4trd6acsg3ykc3
X-HE-Tag: 1791719505-789113
X-HE-Meta: U2FsdGVkX1+hHAzlqUyKUqhpCvUSLH7mtxOjh2Q0yTsH4Yc0fu7ZqUYdqJr0/62xTjbe4k8u+oOG4PEj3gWNl7WPfyyiaZnCpC40Vfu6fS1I3mkUew7PqU7k21KXuNDcfXZClNJzgG/rjXrXTQhD2fMK6fi3v10EDljQjyDwMEZuXBV7Jc26HiVuOtuMPErvy6T5x0K029ttF+3xOM3+2qYQkZvnEJFW4agDzF+7qPIB9NMgiNzzfLtGEgiS5VP1dexoPWd82Q5cVkLnhXSNHgQidty7uB/wUPcUVBMQL1YE2imvxdxTg1uCk9RtjbxiwhDM8+ztJhV9HacPwYhrvSEbrBpV25nmEH6RGKHQpwqqvY8wsGdFHLzZf4z/NmLN19yEI6C0rajottjq3QbX6GRkrkgP24OgHMx1O1Q0E0UHAkO4gqyAOr5sD+jsy0060wUCjUxl5U3UhN4MYqH+n160HVpwn7PQC3kGHhmzWlxDE4+ibhJMv6B+0VwuS92MvAtmW1jSVnVQ0xEbpaRaFb56M2lzEzmVMkOY7864qhkQdQ/MP3vCGsuD6GE72T+8Kjsq3DvlcsoppOoKFklOPycwCunjoNv2wnIAMG683Nh7oH1SHKbtdpVoIzUDCHV5XADh77Z+3HpvL7QVT1pozwaS5myM8LOoaneIVX83vWoDCP5bavvB0Q7t8/nW4Bz6FSmUr1Kx4aGY6M2KNmSdq1dYKma9qGHBm/wDknrIUWrTyxK52PmBYnp8KP50F7d21HaSEY5YNRf0Au+MTZ6HmoCEBNeNqA1dyifj+gah5RrYVtMn97KYQsZeTZn6aujzmxe9/wUtygi51Fiqg4VU2EFmAeaL2irxagylQlaGjioT3DVtMCfOKnxWDVfpCOrr55D7++stpWi9whxcp0y75bX+kSSooeE8iTCAK2huo30fLR2ctAMy7WKsm8o05CQItgrCsK7JWtyHezKNeJW
 rFygngiU
 igsxMzsr85K1eWa4E1F/KncN0mYyRvi2oTKokTEgVb47DduvPlujByRCStlc5BAAuarGTCWqqdHzCIu7pNJIvEiUNJWxAmgWDDN7qJDyxZ0O13T8xaPpI70yR/jeepPsqQuDexP14tTEQm2Y/cQCTf7zKMaR3kb2PPBw3cHUV3QR643sPXZcAy6pZspsprRv7+mCWKHjozqKx6O7qyQZAZT1bsl6EALFEk1qQZPZiopUY/PMSA/bZ/ZvM4GIGhZ03U0uasRJusY/djnoHkU4xdiLJDmROsvt9dJcChQ+VPdpAJMRqPia8PzibVNRFCwpjSSak
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The plist_requeue() shortcut inserted the node at the head of the list
when the node was the first of the last priority bucket and had a
successor of the same priority, with an earlier bucket present (fixed
by "lib/plist: fix plist_requeue() corrupting order in the last
bucket").  The CONFIG_DEBUG_PLIST self-test did not catch it: it only
requeues nodes it has just added, which are always the last of their
bucket, so plist_requeue() returned early every time.

Add a deterministic case for the failing shape: A(1) B(2) C(2), requeue
B.  The expected result is A(1) C(2) B(2), with B at the end of the
list; the broken shortcut produced B(2) A(1) C(2).  Check it with a
WARN() rather than a BUG_ON(), and skip plist_test_check() when the
warning fires, since its BUG_ON()s would stop the boot on the misordered
list; the node_list and prio_list links of the result are still verified
by plist_test_check() when the order is right.

Boot-tested on QEMU virt with a riscv64 defconfig kernel plus
CONFIG_DEBUG_PLIST=y, built with LLVM=1.  With the fix applied the test
passes and the boot proceeds.  With the fix reverted the warning fires at
boot and the boot proceeds:

  [    0.864761] start plist test
  [    0.871849] ------------[ cut here ]------------
  [    0.871905] plist_requeue() put the node in front of the list
  [    0.872921] WARNING: lib/plist.c:295 at plist_test+0x33a/0x342, CPU#0: swapper/0/1
  ...
  [    0.885968] ---[ end trace 0000000000000000 ]---
  [    0.887060] end plist test

Assisted-by: LLM
Signed-off-by: Nickolai Zeldovich <nickolai@csail.mit.edu>
---
v2: per Andrew's review of v1,
    https://lore.kernel.org/lkml/20261010211804.2d8a5f6180c74b08e18ad48a@linux-foundation.org/
  - WARN() instead of BUG_ON(), and plist_test_check() is skipped when
    the warning fires, so a broken plist_requeue() no longer stops the
    boot at this test.
  - Boot-tested on QEMU virt, both with the queued fix (test passes)
    and without it (warning fires, boot continues).
  - Applies on top of "lib/plist: fix plist_requeue() corrupting order
    in the last bucket" (Adam Harshbarger).
v1: https://lore.kernel.org/lkml/20261011012245.765558-1-nickolai@csail.mit.edu/

 lib/plist.c | 21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)

diff --git a/lib/plist.c b/lib/plist.c
index b0273533c04d..9591c38e8ad6 100644
--- a/lib/plist.c
+++ b/lib/plist.c
@@ -283,6 +283,27 @@ static int  __init plist_test(void)
 		plist_test_check(nr_expect);
 	}
 
+	/*
+	 * Requeue a node which is the first of the last priority run and has
+	 * a successor of the same priority, with an earlier run present: the
+	 * shortcut in plist_requeue() must append it at the end of the list,
+	 * not in front of the first run.  The random test above never
+	 * exercises this, since it only requeues nodes it has just added,
+	 * which are always the last of their run.  On failure warn and skip
+	 * plist_test_check(), which would BUG_ON() the misordered list.
+	 */
+	plist_head_init(&test_head);
+	for (i = 0; i < 3; i++) {
+		plist_node_init(test_node + i, i ? 2 : 1);
+		plist_add(test_node + i, &test_head);
+	}
+	plist_test_requeue(test_node + 1);
+	if (!WARN(plist_last(&test_head) != test_node + 1,
+		  "plist_requeue() put the node in front of the list\n"))
+		plist_test_check(3);
+	for (i = 0; i < 3; i++)
+		plist_del(test_node + i, &test_head);
+
 	printk(KERN_DEBUG "end plist test\n");
 
 	/* Worst case test for plist_add() */
-- 
2.55.0



Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A78D7C88E53
	for <linux-mm@archiver.kernel.org>; Tue, 15 Sep 2026 03:17:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 58B176B00B4; Mon, 14 Sep 2026 23:17:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 55F976B00B8; Mon, 14 Sep 2026 23:17:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4004A6B00B6; Mon, 14 Sep 2026 23:17:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 146B76B00B5
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 23:17:10 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 8B925A02F2
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 03:17:09 +0000 (UTC)
X-FDA: 85214535378.16.50861F6
Received: from lgeamrelo07.lge.com (lgeamrelo07.lge.com [156.147.51.103])
	by imf31.hostedemail.com (Postfix) with ESMTP id 4AEDE20004
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 03:17:06 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=none;
	spf=pass (imf31.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.51.103 as permitted sender) smtp.mailfrom=youngjun.park@lge.com;
	dmarc=pass (policy=none) header.from=lge.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789442228;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Eer56DhR604HYEjAHrP8oVdz3WBkoShgWMauEX5BDds=;
	b=5xREeKIhlK+qRe9ds6XjxgBGBQPthydXFJxshPA1ZY5i7CI2l41q08kksjNywP3/2sMws9
	qAXNabY4S1MdkRp2bkYr542N6XHldkY9000809WOhXHY5YNFTfmW26wk9xlK9AGXa4daxj
	Shd6IGvjWiKQYwQS97nEBiBnxoGKEfk=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789442228;
	b=logFJ96Lhvx/tnfuaANgYMnpqD8fHmJjmajH7HwZuq5ktnQ0qz1gAzmJoJ2TvY+vjywJxh
	oKhY7l4o6bXnJTw6jA0IPzi+yopabRT62xr/03VaqpwuKcBMJmXzN29I+9ofAEVJFZNiFx
	G891QKBpZ4J4fjw40/3FRv5GXelaNMw=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=none;
	spf=pass (imf31.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.51.103 as permitted sender) smtp.mailfrom=youngjun.park@lge.com;
	dmarc=pass (policy=none) header.from=lge.com
Received: from unknown (HELO yjaykim-PowerEdge-T330.lge.net) (10.177.112.156)
	by 156.147.51.103 with ESMTP; 15 Sep 2026 12:17:03 +0900
X-Original-SENDERIP: 10.177.112.156
X-Original-MAILFROM: youngjun.park@lge.com
From: Youngjun Park <youngjun.park@lge.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	"Rafael J. Wysocki" <rafael@kernel.org>,
	Kairui Song <kasong@tencent.com>,
	Chris Li <chrisl@kernel.org>
Cc: Kemeng Shi <shikemeng@huaweicloud.com>,
	Nhat Pham <nphamcs@gmail.com>,
	Baoquan He <baoquan.he@linux.dev>,
	Barry Song <baohua@kernel.org>,
	Pavel Machek <pavel@kernel.org>,
	Len Brown <lenb@kernel.org>,
	linux-mm@kvack.org,
	linux-pm@vger.kernel.org,
	her0gyugyu@gmail.com,
	youngjun.park@lge.com,
	taejoon.song@lge.com
Subject: [RFC PATCH 01/10] PM: hibernate: give the image's swap slots back when test_resume fails
Date: Tue, 15 Sep 2026 12:16:49 +0900
Message-Id: <20260915031658.1505680-2-youngjun.park@lge.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260915031658.1505680-1-youngjun.park@lge.com>
References: <20260915031658.1505680-1-youngjun.park@lge.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: cz811rfqszx1hhxuageou8dbofd8y5oa
X-Rspam-User: 
X-Rspamd-Queue-Id: 4AEDE20004
X-Rspamd-Server: rspam03
X-HE-Tag: 1789442226-52986
X-HE-Meta: U2FsdGVkX18/EuITrTyHwvgyK6kRDPpHUTzuXQdFAlS5TTx+Uu3D+EEfBG8oSa+fmSVrl7rRYMR7KXZpA6jbWRAIbPG0HL2rSpup4cNiznu/qWVC1bNKfW25oFzw6pGd1CJKZqGHOwFSpzWdBFCxwIUyHZwp0Mdr9O46BBK2CIsOO+q5fPNuAqtsSxdPScjAZxW/vYIAqPt/qKDUvjep0h6/cUwAWPtZ95R7PtEilr1jxC5VdfknfC+w4HD1S3+iyC97QinxaDurMxdrxPxdEUpVq+6hLHFUkurT1q2ElB1qSjm7x8MuqEsHdYSZ+ZKwoSoBf4/Sl5QB+m77rbYgnerTKnak/9xULDg98cMk4D4l01vz/Aai95rmIksIgC6YO1igHfVkihsI0oRFrdD4h7TFz0WEX3H2nMLnU+G4jGO0Xs51BzqZAKLHA2+ncFI8y5iroGMig4ffqX7zNOLQiszGUlQrYBszGREMseEDJeSLINiXR4zcu7yEw2utknD+O6Aiz+ne34eWLHE1bT97UYXDIMPYds+mQo5QVPAscFJ2ZzsEi66as3PM4uC3f6tPWCV3JowAphuCrW7Ag/iZXYaNqbHmrXFdSG0Ic0V63pyPeJ2V0J5ArS/MFVNr5CSCM+ZoyvZNIbLFNUob535xkY+EhFMYGYyQwK9sbCNkoCER0tvr/2d1lpvnmzMG50zEdmoNpY0Q/BBUl8yjVHGHd2EkSsztRR++WLJKFPagZotciTr6AAoeN0N88+hQOQ8tFewQZ9g5Sp5ztPdcEiBuVdGqVKHOkxeaM+iG78+6AIqI36p2ttGTCsuug31c4WV7MgE78N28Ysl23xjSnOlu29C/x+6KgDUEVr5Mej+zewP7Y1Edoi5Xz4CnGuEfuKjxfxbnfqk0MnstCRiHZ4syCFR008Yvw4JiSRqb+7ru1wny6VkiHBBnqOw4DBC4fF5J92Zg7gxaJm3n+EzAKhy
 0B6Sb4Y9
 Jlq+fGcrV6ZPlwqhEZdYboi0n85ZHu5ItyznGUg2R8KCNiRE7CS0PyxAGxLPLll3Jv27ZmOBPpTxqkHutoq2ALxiZCW4iyyd30YX5p5W3i0WQ/u0Wa/5gxYmqLeZ1TcBGC+E9Mkysip/uGxiz2jIovd/WdrpgecUBrBc/P3xMwy0fX8BoadXwopl5YaUV+e69qDDNuUktpW21NPs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

test_resume writes an image and loads it straight back without powering
off.  When the load fails nothing gives the image's swap slots back.
They stay allocated for as long as the system runs, and swapoff on that
device cannot finish, since the slots belong to no process.

Tested by forcing the restore to fail in test_resume mode.

Fixes: fe12c00d21bb ("PM / hibernate: Introduce test_resume mode for hibernation")
Assisted-by: Claude:claude-fable-5
Signed-off-by: Youngjun Park <youngjun.park@lge.com>
---
 kernel/power/hibernate.c |  6 +++++-
 kernel/power/power.h     |  1 +
 kernel/power/swap.c      | 12 ++++++++++++
 3 files changed, 18 insertions(+), 1 deletion(-)

diff --git a/kernel/power/hibernate.c b/kernel/power/hibernate.c
index d2479c69d71a..907d791b85ad 100644
--- a/kernel/power/hibernate.c
+++ b/kernel/power/hibernate.c
@@ -857,8 +857,12 @@ int hibernate(void)
 	if (snapshot_test) {
 		pm_pr_dbg("Checking hibernation image\n");
 		error = swsusp_check(false);
-		if (!error)
+		if (!error) {
 			error = load_image_and_restore();
+			/* The image was not used, so free its slots. */
+			if (error)
+				swsusp_free_image_slots();
+		}
 	}
 	thaw_processes();
 
diff --git a/kernel/power/power.h b/kernel/power/power.h
index 75b63843886e..9c398cddd0c3 100644
--- a/kernel/power/power.h
+++ b/kernel/power/power.h
@@ -171,6 +171,7 @@ extern void hibernate_release(void);
 extern sector_t alloc_swapdev_block(int swap);
 extern void free_all_swap_pages(int swap);
 extern int swsusp_swap_in_use(void);
+void swsusp_free_image_slots(void);
 
 /*
  * Flags that can be passed from the hibernatig hernel to the "boot" kernel in
diff --git a/kernel/power/swap.c b/kernel/power/swap.c
index c78f1593600b..dc65ec409207 100644
--- a/kernel/power/swap.c
+++ b/kernel/power/swap.c
@@ -1612,6 +1612,18 @@ int swsusp_check(bool exclusive)
 	return error;
 }
 
+/**
+ * swsusp_free_image_slots - Give back the swap slots the image was written to.
+ *
+ * For a path that writes an image and then does not resume from it.  Until
+ * the slots are given back they stay allocated, and swapoff on that device
+ * cannot finish either.
+ */
+void swsusp_free_image_slots(void)
+{
+	free_all_swap_pages(root_swap);
+}
+
 /**
  * swsusp_close - close resume device.
  */
-- 
2.48.1



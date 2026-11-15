Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6412B606A31A
	for <linux-mm@archiver.kernel.org>; Sun, 15 Nov 2026 14:02:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=lOksanS/
Received: by kanga.kvack.org (Postfix)
	id 9099C6B05B0; Sun, 15 Nov 2026 09:02:19 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8939A6B05B1; Sun, 15 Nov 2026 09:02:19 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 70B9C6B05B2; Sun, 15 Nov 2026 09:02:19 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 405366B05B0
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 09:02:19 -0500 (EST)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id BFA188075E
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 14:02:18 +0000 (UTC)
X-FDA: 85437517956.28.E3E15F3
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf10.hostedemail.com (Postfix) with ESMTP id 07DC3C000E
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 14:02:16 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="lOksanS/";
	spf=pass (imf10.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794751337;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=c6eosVpV9md7dDH4Dg9j5xGxupJ1RL325XFcOlNRDkU=;
	b=kavlFidlUP3XZYPDsf6AucnYwfCRC9vstw1LkuQyWHd3vVmImoEbe/42LF4l7HC55zgufC
	IFXJx1J83PH+3zy51uPxvREXwrLEe7vc9LL+pXdeYZqcgOV+hAMYDaCbqStVcrwRsCYNr2
	k3ZlN3gkRx1I5xCZfUTPMQTEbNYroE4=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794751337;
	b=f7vLCXHp2zzdzMScMQqDPIBFl2pcoZHCeG/3YQMOBpli99Db+Z94ND/5GOdntHXWCcSzxD
	gXbMjvxpkSiWuH0yl9Wo3qqQW1QRzQZ+LDei9lIDtGBprtAiKK9CxzE0bF9FQ6KhY062sT
	RF3a/VoEI8NX5JxZMxQlZ5CWd1NJrrU=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="lOksanS/";
	spf=pass (imf10.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 9A64F61413;
	Sun, 15 Nov 2026 14:02:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F3AF1F000C5;
	Sun, 15 Nov 2026 14:02:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794751336;
	bh=c6eosVpV9md7dDH4Dg9j5xGxupJ1RL325XFcOlNRDkU=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=lOksanS/VqnZbRdXu7nBR840FdAclGs5Z+PmqFV3kKfja5rHjnJPZqe/pc7VoV5/s
	 YhNIQhsNZtFLQ4iGgN0xGxKQ9vVvxz5Mcm4wVs/YdwVbRBeZOFiVBdsCG17zj5Cpfu
	 sOO5LrGglgmjkK1AwqwrI2Kutcer8RoRRGdcD+8WpHbb1322gA5vltaSK2i38uBb9I
	 Ijicb7W8qmmdSMq/PEF10VUq1wHK7taw1/uDPE3w0FR5RJ7LPvwRu/mNgP6erhMHGY
	 08ytPETR+u+r9iWoOHE/OtPDAvB55cKDKngLMs3fzuhMDLRhxvJpZ4QYb8cBDkSx6t
	 i+FWaOy+K+ShA==
From: Christian Brauner <brauner@kernel.org>
Date: Sun, 15 Nov 2026 15:01:31 +0100
Subject: [PATCH 01/13] ovl: don't warn when the lazy lowerdata lookup fails
 in ovl_d_real()
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261115-work-ovl-d_real-v1-1-ca155efbcb2e@kernel.org>
References: <20261115-work-ovl-d_real-v1-0-ca155efbcb2e@kernel.org>
In-Reply-To: <20261115-work-ovl-d_real-v1-0-ca155efbcb2e@kernel.org>
To: Amir Goldstein <amir73il@gmail.com>, linux-fsdevel@vger.kernel.org
Cc: Chris Down <chris@chrisdown.name>, Miklos Szeredi <mszeredi@redhat.com>, 
 linux-unionfs@vger.kernel.org, linux-kernel@vger.kernel.org, 
 bpf@vger.kernel.org, linux-trace-kernel@vger.kernel.org, 
 linux-integrity@vger.kernel.org, linux-security-module@vger.kernel.org, 
 linux-mm@kvack.org, "Christian Brauner (Amutable)" <brauner@kernel.org>, 
 stable@vger.kernel.org, Sashiko <sashiko-bot@kernel.org>
X-Mailer: b4 0.17-dev-ce4c1
X-Developer-Signature: v=1; a=openpgp-sha256; l=3156; i=brauner@kernel.org;
 h=from:subject:message-id; bh=Zbi39YqO7L9a16+QLh0UHzMgmw4RUFL6Vukkxu0QXn8=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWT93B2wq/7JO5+brPs++rxTut3jnXzktIT25pkH/hUdE
 Eprz1dh7ShlYRDjYpAVU2RxaDcJl1vOU7HZKFMDZg4rE8gQBi5OAZhIhAPDXwGvnVdyXTZcPXfx
 qOxa+4jMZXy17xbpvc58Y2LnZbRycQcjw5smzY69HhfVVpVI7cvL/53v8DvnY5GP9Xyte6yOubK
 p/AA=
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Stat-Signature: ww7wf5pk1iaskjrdrygf93o4fqaq4wiq
X-Rspamd-Queue-Id: 07DC3C000E
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794751336-284018
X-HE-Meta: U2FsdGVkX19NuOiI3aoS/nsuqh4RxyBlooBBlw12eC90m+vF8JtpV9l9/SctoHXZuoFY+2D43e2ffRQHvFS9WKbV4N97CTS4ZL76rWgJW4NTwzPMJSjWwBw8bVoOV40h88rKCaZ0qr6WBelXlRV48j4BH15TTbhz1UGHO71Q/wvz8QTfuzl/8ddcv9xwlx3vCLMS2Hzm3llDKVrWRyoB3fct61hQ+KDAYcpuxBIu5dVyIS6HBJorQ/xRw7cHeqbOLOCOn6hMGTcp3hi1bnvWPIvCWGK7zH9v/VUbgn8ez7NZTWWgDvKcWDfA6JR96mU0lECdDyd+5SbszEdYCD1ZYTe0zF+4YEcNIGRm/74qrqK8fXASgoyAzQLeYIx0lEbRPxwZB0p3JsnAu2d8hucj4WtrGZ028rRV9RXYUSdUtRJZcLNZgebqbaFhKlHaPIKte6yx/ra00QfU2muIpB4AII/C9C206bDum8nAliJ2/EA+b0Gi/yQ3PWxxoAkTCKbOW5Q5oVgLCUgT9yxa+Ccb4wy0H0pbST6FKmZZeSnQiOnMIQ2PJbTethvmnRHRpzT6cWjJGXgapgvAXb4KVWk8+QHStUf3y7aVww3pl0vtRlGjLs3TwGHcJPORu714Nz7AlGlrenzo6QEnkO41747MutI/+aVKBCS1TdhHLAPd/VAl/aWy5eh2GIn/Xmcgll1EbgpZlz4TWeAK5qyJHmRTlD7Mo41CoURC5nRb254SRW1bygNwGSIUBg+91BW5Gx4/X10P+oipBJa7RHOGvWWlYLrA0P+JJW05DRJPIteCs0bVchLAKphMOegFP3d8bJMMrYcg59VrY6yaFx8MS7o2VVl80TKWPM34XeG1m6T8L+pDzm3IgmRYIeZrHC2JX17nneqDBQUs5pvkpchFF6qeDIGeDtb2AVIZeeT7Iwu6r7yzIMPxhgYzxMK6joXqxpd6ucBbYj4DUBBBr0fJnr6
 OcVpJXBU
 kRbLYSbnnuYLbjxyGC7O33GQHJz7RTkYU+/mVEQmFMeWCGSVgAkJrz7uK9OxJWr6fHSd+pavnIuZ1uIrsC/xTOfuJFxs8r74voDUsVdYovizQk/XmDld7jZCZTbd6n/Lp7YDJdVSi5ur4Nd/Bo1Nk+ZyyBPN+SokfCT2TdWNdoDuf9EozDpY/dOt6sjoQaZRGlU/CfxP+0WfbcPQOWxXl+G9tSlNDjvOX2NLoC6EQnsUExr2UuJ70rCiPTp2jkyqBiaNxxM3pZwjnRgxy8vgAsGzqpIQzH3QlZM36DFRmqebl9kAf/bOEohvY4Lhk3X4zMcPjhYUsXD2xwcY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

ovl_d_real() looks up the data of a metacopy file in a data-only layer
itself if nothing has done that yet. If that lookup fails it WARN()s and
returns the overlayfs dentry.

Commit 42dd69ae1af4 ("ovl: implement lazy lookup of lowerdata in
data-only layers") assumed that the file would be read before
trace_uprobe places a uprobe on it so the data would be there already.

But nothing actually guarantees that. trace_uprobe takes the path from
kern_path() and calls d_real_inode() on it when the event is created and
again when it is enabled. So a uprobe on a metacopy file whose redirect
points at nothing warns twice:

  ovl_d_real(/f, 0): real dentry not found
  WARNING: fs/overlayfs/super.c:79 at ovl_d_real+0xc9/0x210, CPU#2: sh/279
  Call Trace:
   <TASK>
   __trace_uprobe_create+0x1869/0x25b0
   trace_probe_create+0xcc/0xe0
   dyn_event_create+0x46/0x70
   create_or_delete_trace_uprobe+0x3c/0x70
   trace_parse_run_command+0x1a6/0x320
   vfs_write+0x1cd/0xfa0
   ksys_write+0x116/0x250
   do_syscall_64+0x10e/0x5e0
   entry_SYSCALL_64_after_hwframe+0x77/0x7f
   </TASK>

bpf's uprobe_multi does the same.

A failed lookup isn't a bug though. The data can be missing, its verity
digest can be wrong or a signal can interrupt the wait for the inode
lock. ovl_open() simply fails in that case and
ovl_maybe_lookup_lowerdata() already warns ratelimited about failed
lookups. So return the overlayfs dentry without warning. That's what the
WARN() path returned anyway.

Fixes: 42dd69ae1af4 ("ovl: implement lazy lookup of lowerdata in data-only layers")
Fixes: 184996e92e86 ("ovl: Validate verity xattr when resolving lowerdata")
Cc: stable@vger.kernel.org # v6.5+
Reported-by: Sashiko <sashiko-bot@kernel.org>
Closes: https://lore.kernel.org/all/sashiko-outbox-214581@kernel.org
Reported-by: Chris Down <chris@chrisdown.name>
Closes: https://lore.kernel.org/all/20261114120557.4bc1eb6e57218cdc@chrisdown.name
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 fs/overlayfs/super.c | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
index 08695a99f4f93..1985b553a47b7 100644
--- a/fs/overlayfs/super.c
+++ b/fs/overlayfs/super.c
@@ -58,15 +58,13 @@ static struct dentry *ovl_d_real(struct dentry *dentry, enum d_real_type type)
 
 	/*
 	 * Best effort lazy lookup of lowerdata for D_REAL_DATA case to return
-	 * the real lowerdata dentry.  The only current caller of d_real() with
-	 * D_REAL_DATA is d_real_inode() from trace_uprobe and this caller is
-	 * likely going to be followed reading from the file, before placing
-	 * uprobes on offset within the file, so lowerdata should be available
-	 * when setting the uprobe.
+	 * the real lowerdata dentry. Callers may ask for files that were never
+	 * opened, e.g. for uprobes or O_PATH files, so the lookup can fail
+	 * here. Return the overlayfs dentry then.
 	 */
 	err = ovl_verify_lowerdata(dentry);
 	if (err)
-		goto bug;
+		return dentry;
 	lower = ovl_dentry_lowerdata(dentry);
 	if (!lower)
 		goto bug;

-- 
2.53.0



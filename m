Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C28E9606A891
	for <linux-mm@archiver.kernel.org>; Mon, 16 Nov 2026 09:44:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=TDt51YLN
Received: by kanga.kvack.org (Postfix)
	id BBF0C6B05B2; Mon, 16 Nov 2026 04:44:43 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B6E556B05B1; Mon, 16 Nov 2026 04:44:43 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A0ECB6B05B2; Mon, 16 Nov 2026 04:44:43 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 6A25C6B05B0
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 04:44:43 -0500 (EST)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 3AD301C4025
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 09:44:42 +0000 (UTC)
X-FDA: 85440497604.03.B88A878
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf08.hostedemail.com (Postfix) with ESMTP id 65E9C16000C
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 09:44:40 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=TDt51YLN;
	spf=pass (imf08.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794822280;
	b=CVP3kqa/WoNlx/XrObcQfEEc6BiEau5U6FLHJcHbcyil01SKEePHPWRC1yor+8j3Zff0Om
	Ml53TbqFwoLYY3VcIoBkGkARiNaiWqutiX8p+xWY6lZVeP57lw5HN8k07wTuo0w6lqbsiu
	RI0G3CDYEhpBr3FCnP1Zzc4uLZemMsE=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=TDt51YLN;
	spf=pass (imf08.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794822280;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pRTBIPRlWjCyGy6DSOqYG8UUMpJ1tanhgwPOwhgNUk0=;
	b=vP/quCazIaKSJBFRExn1CZYVq7LQVN6ZowMJjTqo2KzJ2arqF6JJvqxURmeo4928U60YB9
	8XKaCKHFOoCnbNsVWIyWRa1mTMlmIRYICRsXlrm1GoK3JPIlt8smyPWevHKNNA4uWPltHt
	feUZlKmD0SO1d1baBW6HM2hNRECLhos=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id B226741083;
	Mon, 16 Nov 2026 09:44:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 763DF1F000C7;
	Mon, 16 Nov 2026 09:44:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794822279;
	bh=pRTBIPRlWjCyGy6DSOqYG8UUMpJ1tanhgwPOwhgNUk0=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=TDt51YLNjcsMzp8aXE/4qpR56L2VTw3XE0lOPPyc2yStU0KrgrnBfGEChWObjXCUB
	 WrIpav1ixgpcfR4ZODZByfoK7gNQD4nzjiOEKH46gETUB1txk83a4IzI5/6Ke2cTm+
	 Jk/2f9UDj0D4dw1fskY/ObWaRKRDp6viyE2ebl80qR8MLrxMV6uAX/8d2erTjukJJ4
	 UanTjbkjSAKVU1Bt88DtWmus3GDoAPyXhOtWGSWqBbts55ddLulokjpuhHTxPnrM4j
	 prH19F5n1/C23v7HYBitfujHpZIzQ4XNsAh19O7TXwD1CE1nRtxlZPo1bCJYL35qLv
	 V5YsINXiIKiew==
From: Christian Brauner <brauner@kernel.org>
Date: Mon, 16 Nov 2026 10:43:58 +0100
Subject: [PATCH v2 01/13] ovl: don't warn when the lazy lowerdata lookup
 fails in ovl_d_real()
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261116-work-ovl-d_real-v2-1-90564c4ae347@kernel.org>
References: <20261116-work-ovl-d_real-v2-0-90564c4ae347@kernel.org>
In-Reply-To: <20261116-work-ovl-d_real-v2-0-90564c4ae347@kernel.org>
To: Amir Goldstein <amir73il@gmail.com>, linux-fsdevel@vger.kernel.org
Cc: Chris Down <chris@chrisdown.name>, Miklos Szeredi <mszeredi@redhat.com>, 
 linux-unionfs@vger.kernel.org, linux-kernel@vger.kernel.org, 
 bpf@vger.kernel.org, linux-trace-kernel@vger.kernel.org, 
 linux-integrity@vger.kernel.org, linux-security-module@vger.kernel.org, 
 linux-mm@kvack.org, "Christian Brauner (Amutable)" <brauner@kernel.org>, 
 stable@vger.kernel.org, Sashiko <sashiko-bot@kernel.org>
X-Mailer: b4 0.17-dev-ce4c1
X-Developer-Signature: v=1; a=openpgp-sha256; l=3129; i=brauner@kernel.org;
 h=from:subject:message-id; bh=uYRKZhpxLqg+b2YtgoKzFfW4tIoikMLXLGY4NolC2mc=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWT9upB/Mvnog+7jLLobGzkPh0yOt7CKEq3b+mdPBrPbN
 Amd7qNPO0pZGMS4GGTFFFkc2k3C5ZbzVGw2ytSAmcPKBDKEgYtTACYSbszwP+wNX+dv2/S6ty8T
 13f+aN/q/89lzlrngmDGn0uu/RIQms/wv8i129CnNNlBQp354eka2WLrV+IsFnESzvL7v9zYIP+
 dFQA=
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 65E9C16000C
X-Stat-Signature: 4c5od3nzag3g54w3intddn1eesxp3cwe
X-Rspam-User: 
X-HE-Tag: 1794822280-967952
X-HE-Meta: U2FsdGVkX1+R/g6SEhjDmy1Ny/EcfXTfkd3XaT7r+7PvhFWA+DP54h7+VRCzR0YqRla/1npTHBdazyICy2M0cgF+Xsi1R0SFh+fQc5qI0yzQKq6xXfk1urQHZcxodLP05O8L8X/Eq1O1VVSnd0LXze/eKNoaoJPdTfMqtvjHhRQR30cro5dHJVXCT0ksPQ+xDh+ons3zoEW7EEBwGwI5F+7eXBavHeB0mzVUF/WR6LpytBveVCmhdGptyYiEE4yRldub2qPDAMnZQwl84JkkKh8bAX6FqFPMV/Y5YZdUy7u7LuAEvIntgIrOorOyt40HK2bKkhdyt3DEtjNQrdq/6CEhA/yIgX6O+wYbrhFVxOBbgTpdc+LkROqaPmktBvLWqlFCQ5UQBuagiG4geYgdIH+vbZB0xusifhBEPfp4dxkfKGOronmrCWJu25VRwYoEw3KV7eUI0TikYkVm0SYv/2HQr0SEPBvQ0NkBFwKf8pJEKhY3kepXqwkoFtWJzCvsJiz8D/TPBVj+8rNY473EX7oIr0NLtWUQhNPolVWW64adWhYK+Sr5zu2I0+HmORswC42H3ubPOrX9HrHyHLGhdtLzskLJpJpZSrz8cOQsALjsRy38n245aKtFSJ5a9mfGFZT3qqMNEO6kECABIH9QI2t+h3YADcVuOJpVkvSltQi5By/h3gb44N/GuiN+mCshy/4QP6jV9AJz5qVpQ0fqzfYiTmsB4fqWQe/jdJ3ZmolcbIt/iGZYcvdynpzVTGdize2QFkGRGrapiA/WDCx50ECBLIk+bpEbpc7/sLetxfUPM5rSWVx6wUqAf731NLcIgZMdhP4Uooy6e29t0IzxXCqIxvlENcmaTNF3p9JA1Ml7IdCUTPzrdeS1MJsNHoHRqnvHhECyttlQ0YgJsX/JwAUCYYwPcgA121RIK4WJeDz7G27AGFyVcHVEBBMoCKf28LWrS9OKA3FogihapgO
 s4BPES37
 9lhvPgKmuBoNeWRMNIpQFrZ6Ta1Ow7bx+DnUAm5jo+Mv4csrdTVq1Ng+/AWELhe7iY8u8KDRDjDj4uJUrvV4rHMkeVaDUUmP4RDq47chTHsLbmg0kMdKrGZvwLip1cSUPx3TJW/T3rap0el2clov0Awbn2Jqjy476y7ecHHskgUsdTlofnIDNF17t7s59SIRMsIq6C6cfuY5LiSK3t0X1hCSDCFngRd04QO0k2FtQ09uhJaSbjs4jdyrYTbx/sdChaWP28XdqS9M3FaMsPtSmMeiBZjRQaE2xjVzPKqVd3AeP5f7penSo0SKkgrGDyrtPlcxH
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
Cc: stable@vger.kernel.org # v6.5+
Reported-by: Sashiko <sashiko-bot@kernel.org>
Closes: https://lore.kernel.org/all/sashiko-outbox-214581@kernel.org
Reported-by: Chris Down <chris@chrisdown.name>
Closes: https://lore.kernel.org/all/20261114120557.4bc1eb6e57218cdc@chrisdown.name
Reviewed-by: Amir Goldstein <amir73il@gmail.com>
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



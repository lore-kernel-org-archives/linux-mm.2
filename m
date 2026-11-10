Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 582366072642
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 09:18:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=AKiKVGQv
Received: by kanga.kvack.org (Postfix)
	id 706F96B05D3; Tue, 10 Nov 2026 04:18:10 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6DE666B05D4; Tue, 10 Nov 2026 04:18:10 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5CD406B05D5; Tue, 10 Nov 2026 04:18:10 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 373516B05D3
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 04:18:10 -0500 (EST)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id D564EA83E5
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 09:18:09 +0000 (UTC)
X-FDA: 85418657898.06.BE78362
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf29.hostedemail.com (Postfix) with ESMTP id 26365120005
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 09:18:07 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=AKiKVGQv;
	spf=pass (imf29.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794302288;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NCl9sz2+KP+iZeUL45ewnMArN+IoDGg4CzU35zEH9JM=;
	b=YSH+YAVi+J+cH8iagKuyZ8PzWrywe0RAR00dLGfyqj6EZP9B8lJVhXxq0BzA61G9AYP8K5
	TYL+p7cRsnWXeZJL+Y1J94pYIazwZblDMjMuuEl+3BsFsksP0KCt5mU040mEnTEKgdVPHX
	3CEz20Ob1hYYpcjLN3mLEbClaAfiL84=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794302288;
	b=qCVsvXdfv1pWAGJ1fu10Lg7AKfHhA3kAs0VcnEIJxS+kBfgFzEyxJZ99Aq5ZKEZwynhVxi
	gyn1XAy0LjGYTQHwhO5sy2WipFTQzoQ3IfkB8a2vAo9jYhuz8TvM1umTU9LqA2hDxs4fxU
	YnJY9+cGFM/wHfEQd1evDGN9mPJGDQM=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=AKiKVGQv;
	spf=pass (imf29.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 79AAF40AE3;
	Tue, 10 Nov 2026 09:18:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B6791F008A5;
	Tue, 10 Nov 2026 09:18:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794302287;
	bh=NCl9sz2+KP+iZeUL45ewnMArN+IoDGg4CzU35zEH9JM=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=AKiKVGQv0VSeP3wz5if0whUbSvt8YZc7Rh/UCgNkZ5tAH/0Cn0M1DyPvV4tLz3iRR
	 G++AKQ+OJy0M5xoApzZVJUGfdnk89qWIzjAeHEzQ0VsM3A9XZIXAidiDTQzcrQeU+R
	 3rWxkhJkXNAubBNR1QnfHf9O2vWsnxzfQrCYIbzpO8jnSSwVS8AHsMvUUDUcP3yr1C
	 GP65RCivYHVcDBwaFck+SBpAEkBxDBlfFtPEB9HKpyoLRJ7YlEMMxyxLgDLGnXyKsO
	 jMd1X4p2pDleOJUsA8gNdHxO88FTvsmiSbxXo2XRHLCCB0IkrdjNF9sWn589dFrNxg
	 b3gptLSM2NQag==
From: Christian Brauner <brauner@kernel.org>
Date: Tue, 10 Nov 2026 10:14:35 +0100
Subject: [PATCH RFC 19/41] smack: use fc_init_pseudo() for smackfs
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261110-work-loop-pseudo-v1-19-4c998976c6c7@kernel.org>
References: <20261110-work-loop-pseudo-v1-0-4c998976c6c7@kernel.org>
In-Reply-To: <20261110-work-loop-pseudo-v1-0-4c998976c6c7@kernel.org>
To: linux-fsdevel@vger.kernel.org
Cc: Jann Horn <jannh@google.com>, Chris Mason <mason@kernel.org>, 
 Josef Bacik <josef@toxicpanda.com>, Christoph Hellwig <hch@lst.de>, 
 linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-nvme@lists.infradead.org, Alexander Viro <viro@zeniv.linux.org.uk>, 
 Jan Kara <jack@suse.cz>, linux-scsi@vger.kernel.org, 
 target-devel@vger.kernel.org, driver-core@lists.linux.dev, 
 linux-mm@kvack.org, bpf@vger.kernel.org, 
 linux-security-module@vger.kernel.org, selinux@vger.kernel.org, 
 apparmor@lists.ubuntu.com, linux-nfs@vger.kernel.org, 
 netdev@vger.kernel.org, fuse-devel@lists.linux.dev, 
 linux-efi@vger.kernel.org, xen-devel@lists.xenproject.org, 
 ocfs2-devel@lists.linux.dev, linux-s390@vger.kernel.org, 
 linuxppc-dev@lists.ozlabs.org, linux-usb@vger.kernel.org, 
 Amir Goldstein <amir73il@gmail.com>, linux-erofs@lists.ozlabs.org, 
 linux-kselftest@vger.kernel.org, 
 "Christian Brauner (Amutable)" <brauner@kernel.org>
X-Mailer: b4 0.17-dev-ce4c1
X-Developer-Signature: v=1; a=openpgp-sha256; l=905; i=brauner@kernel.org;
 h=from:subject:message-id; bh=A5eRYdoLLChIDmTrXY0x54/6SOLidXbGtpe0eaaqmts=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWR9erDq4LSrtvN2M7bp7Emc1fTAaOdWf5uWkMcflm/7d
 +7rollKKzpKWRjEuBhkxRRZHNpNwuWW81RsNsrUgJnDygQyhIGLUwAm0ufE8E+zd0p+T0Hsa+uF
 Mw++mb+hj4txpnJKwWSB7PycaYbfRW4z/DO+trk2+ZWHe8aRvdM3b9Wd4OG8aVvniUtcPdF/ba1
 FclkB
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Stat-Signature: u7hkc7rs76q439x4158b5u8b813h1gf6
X-Rspamd-Queue-Id: 26365120005
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794302287-676828
X-HE-Meta: U2FsdGVkX1/3j3qC2dbG8USqOkbjB33D9wtEMSPY96f7hIrxBjskHJex9+grDbtztkBB4KgS5QPSQlE4XE79vZdio8e616nT0DVX4eIB0RUcCxPeb+zvoGqLiMS0+T84ig2BF1daiPDrUKlg6u9nh9ZubmPKu/HVm+aIusfKdGDumDX0Sv+O3mCsymQOtK4kf9fRLFtdr4pGn4OYtNX2l5ZcuRGD4q740L9dqcLirwSjxa5p4Vll/0uM/GzEi9FFgjkuDSloNDBqRlru3vTiJjJdc0F+fi3D1BwKxU10+c0XxtkPL23C6f1vCd7SRhu+W8h/lJH7n8qBLsIbH7T2FRD4vI86KnkbU/qJ77ZgKg57Mh1xHNTCWP8tpjB0HmTgAwO3yim7C+w3eapqP9Hdnq9RAlI3bYtR+5CWTuXz3YLWx8YNa45xcdCowzIw3p3FveEu7sNrPNIPUjx0fzRvcB1r5IT0eJvPrGmGzIorX9M6jyxIsAaBvGeeexIc0ltEaNccE6BS5fhuK29H4b+9BIqGH6auQycVb17ihPSMjAcPL3OD0Eh8hcnkY3Io9NnOcO58nWI0UjVSpDX7K9VQw38GrAoFei1G1OlKWc/I8Z3MK6rPhnljL9ENTBb9cbKXQ7gBfkdVp9W8VLDYlzQhLyMreyQEdaIjY6no7Rcz9vvV1VtiM4oDlHKQik0j6xwrpNHbBRAivU6/foUs1K16kxag4W0wMfXTFVKZbzYbxQi2Hik5RBjw+sb0Gj2dwgDnNC57Mgy6BIRnNl6HHRlUPaQI0g4VEQfMm1hxGsSE8ptAgs6B18UUiUC+/myYaQ2khRJRWh5FPoM4OGoWJXNgfmRkWBpawoox493tSEuLFJKRYLu6EKBPg8VjlUWbWGv+epU/VzS0TdH2vvMfmF2DAW2vIMJilS9xkMBZpMuoRng+uln5lWPX594WuPp66lcAzLsXT01X6osI2HuPP6N
 QvVoOTnP
 JL0ZFLdfc9IkGpRZqL9jcGhBcCcD1GBvB0e3FP0KBrNmsbl4XZnaAbAkGh2gPN6BU5RbAFjNYowzBCJVez4PxsRr2YT6W2HA4DxFfyrQrt8uXSBTIKZG3dfX2mn3FDZY6iaU0wBeCJqumvd77Ld6TNv7KxKkAPhwZkLdTzrTnqy8bwNqyRhZrxMUqhsSNyhyG/pltkWb7O6ImROgKMeHEuaGDKQvoY7aCye+JQe9yj7J43+5nXDKZAeGXNL/PZY/LO9PwZdaB9QZoBfuIytH+/0OlkB6JNqG4dgIBxuAaSQYHWT8ojkTu0cfV+BEEMg8+rmCvRg0ie0ElsM5KvHPCaiEeLur0CpS713YxYBSDbckiaXY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Initialize smackfs as a pseudo filesystem. This raises SB_I_PSEUDO and
also SB_I_NOEXEC and SB_I_NODEV. smackfs never holds executables or
device nodes.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 security/smack/smackfs.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/security/smack/smackfs.c b/security/smack/smackfs.c
index a72bc7fabea9..4a56bbeaeca3 100644
--- a/security/smack/smackfs.c
+++ b/security/smack/smackfs.c
@@ -25,6 +25,7 @@
 #include <linux/magic.h>
 #include <linux/mount.h>
 #include <linux/fs_context.h>
+#include <linux/pseudo_fs.h>
 #include "smack.h"
 
 #define BEBITS	(sizeof(__be32) * 8)
@@ -2880,6 +2881,7 @@ static const struct fs_context_operations smk_context_ops = {
  */
 static int smk_init_fs_context(struct fs_context *fc)
 {
+	fc_init_pseudo(fc);
 	fc->ops = &smk_context_ops;
 	return 0;
 }

-- 
2.53.0



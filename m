Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 549AA6097046
	for <linux-mm@archiver.kernel.org>; Mon,  2 Nov 2026 15:02:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=d/TU5Bzo
Received: by kanga.kvack.org (Postfix)
	id 6E8046B05C0; Mon,  2 Nov 2026 10:02:30 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6BFD16B05C1; Mon,  2 Nov 2026 10:02:30 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5D5566B05C4; Mon,  2 Nov 2026 10:02:30 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3CC746B05C0
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 10:02:30 -0500 (EST)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id C2C53140175
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 15:02:29 +0000 (UTC)
X-FDA: 85390495218.25.940A68D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf18.hostedemail.com (Postfix) with ESMTP id D6A311C0019
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 15:02:27 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="d/TU5Bzo";
	spf=pass (imf18.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793631748;
	b=7/kIsc7p8BOrjdgN8mVhPqwP/Nk7iVABmVJGw+x+3toLOwkTfAJTc82OeDB8t+/p5UbSXr
	mWy9fqphC6thD4ruapJRWewE2MGFG+3cz/WXGwkotLwKDAfnNRUqFo7EFzwcczROtp4D8A
	qp+xRpy4ukN6PVdCEeB+ii7tYtNBWag=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="d/TU5Bzo";
	spf=pass (imf18.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793631748;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qVgyj+FYQ9g7uHqmkN/6kOivRqdCDmjAyQM7m79vY9A=;
	b=yrnkK49hf0MGXOAPClAtuI7L6zykb/jop2yJNsPqtZ35pZ1x5Sgx+iOakDrAnlkMhFUy/p
	A/PgRMcl8n+Uo5gFiuG0gN+kxVIn3qEREFRaxL1423SQESRrRcX9WYCFeEjQCAG0wl6XT4
	WQljhjNQOPYlsqUhspylhFVUC8LGF70=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 29E534085D;
	Mon,  2 Nov 2026 15:02:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 174411F00A17;
	Mon,  2 Nov 2026 15:02:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793631747;
	bh=qVgyj+FYQ9g7uHqmkN/6kOivRqdCDmjAyQM7m79vY9A=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=d/TU5BzoI0BtvHfYzajrrcPl1GXVCryRY1Ut48y/GJIvjjd3K9tAkOPoaubnTH8Cj
	 sK1647iQobp60ZY24tDMaAx9NsKxFNjymF5IY5h/cKkK9nGKkyHoV7CZDZf8JNbRww
	 IRIPJfTF97vUVSY7NrIvF3mdu1MbBY5I5i7z+xiQlEEZ26yJHEdd7bH89Gqlbow2Ks
	 Vg0J9epC20U9E4NUHIBDGai+NMTOFT3rd71sgkTUJULyeOxAVxvB4aiLpCaS0sj7+K
	 C1HjOmzglPQcf1LCUAmDC0bN3L5TxoShuNDSEnm0bhASQBWbCYoW6wiUfo3S3aSY11
	 bUEfQJ+ZWGIIw==
From: Christian Brauner <brauner@kernel.org>
Date: Mon, 02 Nov 2026 16:01:29 +0100
Subject: [PATCH RFC 02/22] ARM: alignment: let procfs copy in writes
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261102-work-procfs-arch-v1-2-c9492ab08480@kernel.org>
References: <20261102-work-procfs-arch-v1-0-c9492ab08480@kernel.org>
In-Reply-To: <20261102-work-procfs-arch-v1-0-c9492ab08480@kernel.org>
To: linux-fsdevel@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>, 
 Jann Horn <jannh@google.com>, Josef Bacik <josef@toxicpanda.com>, 
 Chris Mason <mason@kernel.org>, Jeff Layton <jlayton@kernel.org>, 
 NeilBrown <neil@brown.name>, Eric Dumazet <edumazet@kernel.org>, 
 Thomas Gleixner <tglx@kernel.org>, Al Viro <viro@zeniv.linux.org.uk>, 
 Jonathan Corbet <corbet@lwn.net>, Christoph Hellwig <hch@lst.de>, 
 Greg Kroah-Hartman <gregkh@suse.de>, 
 Joel Granados <joel.granados@kernel.org>, Kees Cook <kees@kernel.org>, 
 Jan Kara <jack@suse.cz>, Jan Kara <jack@suse.com>, 
 linux-kernel@vger.kernel.org, linux-nfs@vger.kernel.org, 
 linux-acpi@vger.kernel.org, linux-kselftest@vger.kernel.org, 
 linux-s390@vger.kernel.org, linux-scsi@vger.kernel.org, 
 linux-um@lists.infradead.org, linux-wireless@vger.kernel.org, 
 linuxppc-dev@lists.ozlabs.org, netdev@vger.kernel.org, 
 ntfs3@lists.linux.dev, platform-driver-x86@vger.kernel.org, 
 coreteam@netfilter.org, kexec@lists.infradead.org, 
 linux-pci@vger.kernel.org, linux-sound@vger.kernel.org, 
 netfilter-devel@vger.kernel.org, dri-devel@lists.freedesktop.org, 
 ibm-acpi-devel@lists.sourceforge.net, jfs-discussion@lists.sourceforge.net, 
 linux-alpha@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
 linux-cifs@vger.kernel.org, linux-fbdev@vger.kernel.org, 
 linux-hwmon@vger.kernel.org, linux-mm@kvack.org, linux-sh@vger.kernel.org, 
 linux-usb@vger.kernel.org, samba-technical@lists.samba.org, 
 sparclinux@vger.kernel.org, linux-m68k@lists.linux-m68k.org, 
 linux-doc@vger.kernel.org, linux-serial@vger.kernel.org, 
 linux-atm-general@lists.sourceforge.net, Takashi Iwai <tiwai@suse.de>, 
 linux-input@vger.kernel.org, linux-raid@vger.kernel.org, 
 linux-ext4@vger.kernel.org, linux-modules@vger.kernel.org, 
 linux-debuggers@vger.kernel.org, 
 "Christian Brauner (Amutable)" <brauner@kernel.org>, 
 Chuck Lever <cel@kernel.org>
X-Mailer: b4 0.17-dev
X-Rspam-User: 
X-Rspamd-Queue-Id: D6A311C0019
X-Stat-Signature: qe3ar85ii58bfyhrsm3q6qpz14bugr1z
X-Rspamd-Server: rspam01
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-HE-Tag: 1793631747-288684
X-HE-Meta: U2FsdGVkX19gJHc99Cxi0O6UW1SoRvE4hBcFuEQJAWChs0uV59ydLeQIp+0ZsbZPfDPV+/JbHbRX6+TdYHuyEe+7mjh/etS3ZwMvo7cQhmHK74Uo5/7yDDgYRb+lqpbKz7GxdjjRuvEEEVhwcW5pqCA6LYxkKlbs1wStUDK+wQxM47WxnZCrXI3OULFIgXL5QqgpTUV+Z89msA6iUvzFx2S1Da+E7SWe6IFWKXADVbr4x/mJauCK+csJ8XNmrtGi1wK+izmAIW+SbmY9CptTVJt7EqdgSswafAJrHeOOf+cqRmLk6yiS+9z7G4v2WrCwqpE9WVa+St/CCSkiXqZrZ8N73SfbAUhLWvTnImI/OrlpTVVxNuYCrEXqKB1XMyT6d+CDBJ8XB50kFWF3bGNZdmNEc1qqtuodq6g9IhNR7Ga/AflMocaIim5BSW2JPhy3hOHVbntUurJ865NX1K8VN+nFQFpxUjwJEIkB8eW0iojvJxgkAZ0sim8kvTPTyBHBshpxgAt0skHkZQR8c2xybs7oCBgTgGVb/Zwl6ZBod/uoEY7U28H32/OLjX8h/HmgKI/4I+RuVUt0Fmlc3ghavVs1KPCNXVAjyn/BpZ92yd7rSBpVetqPBbbL+GMDTTpVORn/9h5x8vjoKdgnTRjhiZxBT92l+dUeVgWEoIS/O5SdY6jYwHC24lwO75v57pwmuZEwzVWWQo97y9fj8cNvxiZdLgs+QK+JpFbOOBkQarxIfUbPV+8iFslTrQHZTVPW2PqWTaAU87w7y5JOFG2u+MWBNk1Ja8xBTkYdlYnSEXV7cBhykBgDwfpkDsyZFgWvaUZVzikMlKn2KE7YIhUm+GcY6KAN6vOB4TMgWUMpyShR9j4DuJfxIAGrOwy0KOgAAg0hhN/hk5wMpVxVBiTnMq60pP9iL2ijR+bSk0DdS73/nVgdLYVFcr5Ton9nWB7CZ46mLzERIn7UmE3u2Ba
 tW1uHIiw
 FewLzLXMeXG0K3pXEwwlCnOnzG+wSB5io3sSEZrl+mj/nx2ZbC9RBlaEge7hGLXq4KUHLnk/nRg8dfEgVGEuaaSUzdNhf1x7jaxK8K1byYfI26WyIYXYEj007+ebKF9W+zaexHOtRmIlgEJq3DQMV4r8nFnTlhsfCnNORcWNBuQojTYD0SEKvRAOfLS6QBOCCQ4KK0EtzhpLU1cSOl0YGL84WjtqlLO4Ft/Yl9IlQ65felDIPwRoOc5h0y8JSXJQABfxw6ag/wBQc3jClqaqPq6ezFKxJIyqFG7IJ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Implement ->proc_write_buf() so procfs copies in what is written to
/proc/cpu/alignment before it pins the entry, and take the mode from
that copy. Writes larger than PAGE_SIZE - 1 bytes fail with -EINVAL now.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 arch/arm/mm/alignment.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/arch/arm/mm/alignment.c b/arch/arm/mm/alignment.c
index 3e5e30968634..11ceefdfa388 100644
--- a/arch/arm/mm/alignment.c
+++ b/arch/arm/mm/alignment.c
@@ -144,14 +144,13 @@ static int alignment_proc_show(struct seq_file *m, void *v)
 	return 0;
 }
 
-static ssize_t alignment_proc_write(struct file *file, const char __user *buffer,
+static ssize_t alignment_proc_write(struct file *file, char *buffer,
 				    size_t count, loff_t *pos)
 {
 	char mode;
 
 	if (count > 0) {
-		if (get_user(mode, buffer))
-			return -EFAULT;
+		mode = buffer[0];
 		if (mode >= '0' && mode <= '5')
 			ai_usermode = safe_usermode(mode - '0', true);
 	}
@@ -160,7 +159,7 @@ static ssize_t alignment_proc_write(struct file *file, const char __user *buffer
 
 static const struct proc_ops alignment_proc_ops = {
 	.proc_show	= alignment_proc_show,
-	.proc_write	= alignment_proc_write,
+	.proc_write_buf	= alignment_proc_write,
 };
 #endif /* CONFIG_PROC_FS */
 

-- 
2.53.0



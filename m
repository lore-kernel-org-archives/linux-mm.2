Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8164C6081746
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 19:38:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=EaLRWWjc
Received: by kanga.kvack.org (Postfix)
	id 942F56B05BE; Wed,  4 Nov 2026 14:38:37 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8F4D76B05D9; Wed,  4 Nov 2026 14:38:37 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7BAC06B05EC; Wed,  4 Nov 2026 14:38:37 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 508E76B05BE
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 14:38:37 -0500 (EST)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id E23A616085A
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 19:38:36 +0000 (UTC)
X-FDA: 85398448632.18.1EB09CA
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf17.hostedemail.com (Postfix) with ESMTP id 1F53340005
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 19:38:34 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=EaLRWWjc;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793821115;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XEKsvRvbQWppTyh1wQqi6XPYHGzRxd9NXleDa7PK/rs=;
	b=TZWhux87tINlPYpmgK2wEI3XR7Y2UMvcxAeSq8UJDavIvqJZkHoU8JXX6zlALabbeV2LEf
	eV4rETa6nRhVBiLVtzPspvgnWfpf6Y8+tIE0aZLapeHCFAdIMlrYz3+lYJ90KABlKTWu97
	sxnF0yskVwernpW53yJHIZOlXCmpCHE=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793821115;
	b=hpA5m8vwo1I6irD7VQnhJD6Ux1t588eenJ8QFVGNRT/YNRe7HYAyOTV26ypRfUfz0a/VyW
	ZGa4OTtkUweIuZ1Qm7pzqt2XOq6hvNGs0wYxN1guEl8LVBYhtZ0yveWVuqtRvDdLuqUmRo
	lToabD8psPjmRH3mUyPwdIAhMD7Hmcc=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=EaLRWWjc;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 75DDA406FD;
	Wed,  4 Nov 2026 19:38:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55DFA1F000C1;
	Wed,  4 Nov 2026 19:38:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793821114;
	bh=XEKsvRvbQWppTyh1wQqi6XPYHGzRxd9NXleDa7PK/rs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EaLRWWjcN4LLtMOZCh1DK40g1/b6+I6lfVBt9n9EF90MTHukgj10jc7nnxg9IofMR
	 GsjkGzfQKuhKOZ+n3/LW++jhgPDusZmmjz6slzPCN4lXGLSEShUFZEJIC20Khv1Qea
	 BGx6s9+LOr0H4FffGoKVCTJI6Ox55pPB2uJk3qh/GT5DTKhi1tn3D4FIlveOjDIU6b
	 mKrYG8hw6tkNgyXfyvZin/Q7MUwaN2ZXQsXOtudCeeuRmmy8PaA7teUhlewcJMvgHe
	 mVgidIbouLxKCLXkR7E6TgFrG6bkV22opE3xoLYbtq0zUE746RrGpkbGpCqYQxYjdM
	 22p7i8EAfY8SA==
From: Christian Brauner <brauner@kernel.org>
To: linux-fsdevel@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
	Jann Horn <jannh@google.com>,
	Josef Bacik <josef@toxicpanda.com>,
	Chris Mason <mason@kernel.org>,
	Jeff Layton <jlayton@kernel.org>,
	NeilBrown <neil@brown.name>,
	Eric Dumazet <edumazet@kernel.org>,
	Thomas Gleixner <tglx@kernel.org>,
	Al Viro <viro@zeniv.linux.org.uk>,
	Jonathan Corbet <corbet@lwn.net>,
	Christoph Hellwig <hch@lst.de>,
	Greg Kroah-Hartman <gregkh@suse.de>,
	Joel Granados <joel.granados@kernel.org>,
	Kees Cook <kees@kernel.org>,
	Jan Kara <jack@suse.cz>,
	Jan Kara <jack@suse.com>,
	linux-kernel@vger.kernel.org,
	linux-nfs@vger.kernel.org,
	linux-acpi@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-s390@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	linux-um@lists.infradead.org,
	linux-wireless@vger.kernel.org,
	linuxppc-dev@lists.ozlabs.org,
	netdev@vger.kernel.org,
	ntfs3@lists.linux.dev,
	platform-driver-x86@vger.kernel.org,
	coreteam@netfilter.org,
	kexec@lists.infradead.org,
	linux-pci@vger.kernel.org,
	linux-sound@vger.kernel.org,
	netfilter-devel@vger.kernel.org,
	dri-devel@lists.freedesktop.org,
	ibm-acpi-devel@lists.sourceforge.net,
	jfs-discussion@lists.sourceforge.net,
	linux-alpha@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-cifs@vger.kernel.org,
	linux-fbdev@vger.kernel.org,
	linux-hwmon@vger.kernel.org,
	linux-mm@kvack.org,
	linux-sh@vger.kernel.org,
	linux-usb@vger.kernel.org,
	samba-technical@lists.samba.org,
	sparclinux@vger.kernel.org,
	linux-m68k@lists.linux-m68k.org,
	linux-doc@vger.kernel.org,
	linux-serial@vger.kernel.org,
	linux-atm-general@lists.sourceforge.net,
	Takashi Iwai <tiwai@suse.de>,
	linux-input@vger.kernel.org,
	linux-raid@vger.kernel.org,
	linux-ext4@vger.kernel.org,
	linux-modules@vger.kernel.org,
	linux-debuggers@vger.kernel.org,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Chuck Lever <cel@kernel.org>
Subject: [PATCH RESEND v2 11/23] sparc: led: let procfs copy in writes
Date: Wed,  4 Nov 2026 20:38:20 +0100
Message-ID: <20261104-work-procfs-arch-v2-11-2aeb952c9597@kernel.org>
In-Reply-To: <20261104-work-procfs-arch-v2-0-2aeb952c9597@kernel.org>
References: <20261104-work-procfs-arch-v2-0-2aeb952c9597@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
X-Mailer: b4 0.17-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=1493; i=brauner@kernel.org; h=from:subject:message-id; bh=AqaUJeRV3kbpXVh8nmhEIr+kHQG3PHbqm52TQh+zorQ=; b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWS97vjpvd0rM2/K/IZazunNazZslZwnnKe7oWiOz5a9r +eECD5T7yhlYRDjYpAVU2RxaDcJl1vOU7HZKFMDZg4rE8gQBi5OAZhIaCUjw8/DEZOOcC31OhN2 f1ax7FPvDa8lyu+sOCFkmxv8bxebMA8jw8uyVjH2g1fyQq9GrFjLuy9g09x/Z3+8EmheILZS646 OBgMA
X-Developer-Key: i=brauner@kernel.org; a=openpgp; fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
Content-Transfer-Encoding: 8bit
X-Stat-Signature: zjmuu5gs7omcbbszq1rsrknbfcg78umf
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 1F53340005
X-HE-Tag: 1793821114-706952
X-HE-Meta: U2FsdGVkX1/Y8FOKMcdBv+BLNgnHK0b/rjj+iRFxgCe70ICIgfiW3Cep13R6PTQ+3HKSHBrKLDNjsHgafn4SA4yrx3qNZcS8dn+OVH8WOI3eAX6Agy62qmdwbPoIZWNNu2G1/Bd6vg7068qsgbBllG/FiJj6d2/LczVukkbRR+gYZi0ziWR1nLhjYyXt+6aL89Efw1VbixN0JrurbWQdlqVGXbs47whkZefIcodzGl5n+LKlGqmcupXDkD2yfcklLCiT9jENmnm22gqO3CxC6JC4XmC43qAtIE0rMIVntJixA6W0U/GlmtVK6FbsQnHimlaEr0cUXmvUKNLQHz+hkQUBm1qk16YMYJ4Pnb2Y7aTCdLWDiYlp7rSVPP76R0N+19pD7p/kHFgRhgdAAlCCcqMCh3Yb0XcganPTgpAHkzJ9/I09vbprofQ1cPjF5kancubpGcdN3F5F94Pjzbk1uVCsgohN/TKZbuQyYf3EQgYLv+bOGiWw1yu8qhRDMDoW71q1rzJYTMNDS3pwgaatreUkWS3oYE9AW4d/AEQRxl9nYps7YW/efdzscBr4GuaDyIKRZrvvDUIDTowFExQ/habUHxMSevRymbICq5qb+m2jhwpgr3L9KfnqggkLmCnnAr8g4Wtr2BK9TYrYSm5ylOIA4ZJF79pioZvSy0vTch/pvBq3WzNApXbJJam8x+Lz0JJyWuieoAPheAM907eEUKAGMpIuPLZ9T29sCDBA8xObGLafzrlN1dgudCkQIcoHAjjQksw7PiVDXr+XIjFnAFXbmDFEj8/AJY5RPCYmiQhmdTSWsuXAKNj7BiAa5q8ZXGAniovZK9creGAkCnAf/s9mZHZzHmTvTJFSsZlWnYMxSJvYz6zJJ5w/g/FZ3hLXUKHx1C2R4OCl2GllRb+imatmML9rtPzmciWp6jeSYwzqasXaQAKiBE12vYqyqACRMVCy10Icx5U/4EoPOiZ
 3e1NiQqR
 Q1CAuc9NOuTTJ9oq8z1RLAIhGutdqUYu9PJIBACbn2G4f3JAy89B9bcezOCPE0Hb67sZwDnOTQu/3ryAH+IBbLCj0ncBIcOJmsK5vs2N93BOowIxMU++UHfL3xE11iJjcOd6BfkshLi0hNgLgEUO1wCGFPhpDzJe6d9Mak5M8CG9jGeMooCrpSYaAMf75qeOYw+siPVOaarxpD8JBgi19/bl+XUBvF5Mp4t4yjZ103im9xV2aLWuSB5RwEbnA95iTO7gqg99fvOwQKwPOdp5XxnM3s6LPYenzJL6k
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Implement ->proc_write_buf() so procfs copies in what is written to
/proc/led before it pins the entry, and parse the command from that
copy. Writes larger than PAGE_SIZE - 1 bytes fail with -EINVAL now.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 arch/sparc/kernel/led.c | 12 +++---------
 1 file changed, 3 insertions(+), 9 deletions(-)

diff --git a/arch/sparc/kernel/led.c b/arch/sparc/kernel/led.c
index 0f7376b51a04..1f244e394207 100644
--- a/arch/sparc/kernel/led.c
+++ b/arch/sparc/kernel/led.c
@@ -60,18 +60,14 @@ static int led_proc_show(struct seq_file *m, void *v)
 	return 0;
 }
 
-static ssize_t led_proc_write(struct file *file, const char __user *buffer,
+static ssize_t led_proc_write(struct file *file, char *buf,
 			      size_t count, loff_t *ppos)
 {
 	size_t len = count;
-	char *buf = NULL;
 
 	if (count > LED_MAX_LENGTH)
 		count = LED_MAX_LENGTH;
-
-	buf = memdup_user_nul(buffer, count);
-	if (IS_ERR(buf))
-		return PTR_ERR(buf);
+	buf[count] = '\0';
 
 	/* work around \n when echo'ing into proc */
 	if (count > 0 && buf[count - 1] == '\n')
@@ -96,14 +92,12 @@ static ssize_t led_proc_write(struct file *file, const char __user *buffer,
 		auxio_set_led(AUXIO_LED_OFF);
 	}
 
-	kfree(buf);
-
 	return len;
 }
 
 static const struct proc_ops led_proc_ops = {
 	.proc_show	= led_proc_show,
-	.proc_write	= led_proc_write,
+	.proc_write_buf	= led_proc_write,
 };
 #endif
 

-- 
2.53.0



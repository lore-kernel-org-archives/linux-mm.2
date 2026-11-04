Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 53AA46070777
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 19:43:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=HvxkwJrE
Received: by kanga.kvack.org (Postfix)
	id 5CADF6B05D0; Wed,  4 Nov 2026 14:43:58 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 57B796B05D2; Wed,  4 Nov 2026 14:43:58 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 46B926B05D3; Wed,  4 Nov 2026 14:43:58 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 20E176B05D0
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 14:43:58 -0500 (EST)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id B97761A084B
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 19:43:57 +0000 (UTC)
X-FDA: 85398462114.22.1F73B1D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf18.hostedemail.com (Postfix) with ESMTP id EAF6C1C0009
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 19:43:55 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=HvxkwJrE;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793821436;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MXDP9fyzpcc9X8/ROQgrmtpQySITyZcOubu0QYlfW0Q=;
	b=gTg+7ja/db7WpinRONrcgdix+FKsk34NzlU32LyyXYazGRrEsSXOH0kG+YwQjg8FTywMOm
	fv2baS1doS1sIjSbVgUQib9Tybk7E9wABwQ3WBAigr0/C7zJUbh55zfhTdGHmgfTz2mBn8
	wz7VNisALLZ+hIqIBxV+xosvqURMWRs=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=HvxkwJrE;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793821436;
	b=LnNJescS+mMlhA4G8nG95PrkuKovzlf7E7IAxwmhqqbDLMrWGsZDh53vN659rairGmbNND
	5RBSDPuwkzDJmXT5wvirGoKz8bY4t0s2nNKfVbSo6pZaow37IBMrE4zfcl2eUHCk7EWeMb
	YXnvSr/qcDYe7pNFPtINRcVWa3HLUrw=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 3CB81422AB;
	Wed,  4 Nov 2026 19:43:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC5111F000C1;
	Wed,  4 Nov 2026 19:43:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793821435;
	bh=MXDP9fyzpcc9X8/ROQgrmtpQySITyZcOubu0QYlfW0Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HvxkwJrE6yZiYOxFcQMcjejW88ZaW29hTOWaJR9YO5Tvs3/8Ku/knORgdhrkWEZnm
	 FqlvED7tkZyaWujkmmUucC82ygg0xRZPT8t1WYaFWGOQCbuZ5npn6/psp1WJsopeBc
	 /Ip4YEzyI9/mkYahhPxRdv4RqwBmNw3bGEqLSFKH7xSvANy2+6tMJK3oeMT/j06KPr
	 aV1SaTvwJyNaQmYfmPPmd7MRi8vEfKFW5IekI7JTcT9yV8aBpWOQ57VRcmy0cEhZAb
	 MM7IMfpEqYVYfJYvfiLY5AP2A/DDKBQ+DAROllTXi16lENKuE4ydpoDCGxpGPMHxZe
	 bfR3jntxCFu+g==
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
Subject: [PATCH RESEND v2 06/26] md: let procfs own the seq_file of /proc/mdstat
Date: Wed,  4 Nov 2026 20:43:40 +0100
Message-ID: <20261104-work-procfs-drivers-v2-6-245e54e87116@kernel.org>
In-Reply-To: <20261104-work-procfs-drivers-v2-0-245e54e87116@kernel.org>
References: <20261104-work-procfs-drivers-v2-0-245e54e87116@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
X-Mailer: b4 0.17-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=1303; i=brauner@kernel.org; h=from:subject:message-id; bh=rdu1kmejfqc5NG4cwcsJAI4WSVobA0+Qk8YSn4PPNtc=; b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWS97qq6MLvj4dWlPlW/Lu/K/95xU/V2xNJbCyWiD8o4T U+5uk0tsKOUhUGMi0FWTJHFod0kXG45T8Vmo0wNmDmsTCBDGLg4BWAim4wZGb7tvCDdyFbA2D3h xbQ1r407Cl4f1/C3fFQsYPDizr8HIumMDFP6U2beWjP1wmONNb84O1vnWbE1dPszPL6aGeZe9b+ wjBUA
X-Developer-Key: i=brauner@kernel.org; a=openpgp; fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: EAF6C1C0009
X-Stat-Signature: bfjgh39beisya5xdcu6cryeqi89gb1s8
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-HE-Tag: 1793821435-308962
X-HE-Meta: U2FsdGVkX18bvYa5rJgpB357niC0AjpyRJHU6v9gdy6bbzPlEaEWPxXGje6mFbfzCEnDG/RHg3yDWNwy1xAhS0SrYuggAlpxGn+DpstnNUOzAuxBd8saRt2JrdsdOwI81EtYW+LcxjWbkElqcRWVIxKYbME7OyMBaqBFCtSEruhy7hiuK2fuW05C03vP5zfFNU5QqkZ+Ap3r/IEg6ir/Nf3ZHBkalfugy2YTxJwG3Vs0PCmBZdqgC+bGr4KiIGaX2xTRQRqukw0lR4tGes9S2ju6GDSnW8e0FsmDorv1gHrZFOhDDLlgUb+SI/4ZerGycKftX0OE5yN9cTxgBY1iGBHp9G8Bxjuq68E2llLOONaBW/hJmz/NzcXjiXah2u5eto9IW5ZFf0HneY6Jrq1XdtR0XeSJWPAgo6A+ccqEmgUZgfSD2PB2vQUpWor4nyoSJtd6LY1AOTB/vOpF9EispbzZuAY6j31aCIzKXc18IgSnXk1S8zh2Nqb1ktp/YLDAPgstE7J7wJFNKfA3J35uWo0CSEDNYE2de+nGGg5FFPzOsiM3Dv8c2ixJpKtld3Pa10280qcWJKNjA5rahBvFJo+qhDyh7Z9E1idDm55AOyLpOvL6Jq2QnJewzaXZHJhM1Kt9A7cOkxhjkljgLLCBZM0le0Zh4qpN74whrE/F8SOvm8VYq1UiNyYAdlV2OZPxbv250LNIXxGdEvl+/MkzsoFEw7miybleJSl62Q03qStW7saCs6zuSFeN279+6MrRrVjcKnHmhypY3Yr/TnzsYeypen6W7Kt6sJfibi6WaMHiKDYvxnC9QgN2g+Nik/8pwfJcEKJZeDZMt/zBAsIZkQcHdlwgV9WoM82sdeiWaVp9NfbLNaGU1vEXZE69sxZ1p/94j/4HgVN3u7Nd6W6pkLeRm+3wa3JW3TsiS/+qmUmNb9S3UxQ1h7i570q4rakHA4LDJvJ2+1JQBukZVTB
 JELBRxIN
 lDjli7zgZPVvo6RSLquTqT1mrqNHUFD/e05RZpWxxtPsk/GSziXBY+CBBIS7+91Btn1phtdMkI1WX3udp6msyDPkdGok1MjgVLwO8lUixQCT6B3woxtrA77/Qb0XJqXOeETopWBn0sZqKDrQxuDN6kPwNiYNfN534AAG/B4Rg6W62lDp4+LnohFThmf59zyQSdyz7Ipz1Kdzk997KqmVBzG8tXKD4DdveI2pPBGw6ov3tFMtUAJeOU0QeykVlyv1i7yo4/WyBUuZkfjjmL2hSsj+qZ+ODjH5/VKxrb68FPiJaILsutta1Q0PJw45WgyA4P1hQmSll+eszUdq7no5kUuYr/5ExQ9N1wTutWBm4q4Gnun0JSp3HbNNGVjB8lt2jW29HfOn9i3gH5T2JMhoSTfEy4oT1e56E2igjmjVt4jvLnU04bGOKeY7+zemCMKzmjElMl6M3bJ+s1RA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Declare the seq_operations and let procfs open and free the seq_file.
->proc_open() only records the event count for ->proc_poll() now.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 drivers/md/md.c | 15 ++++-----------
 1 file changed, 4 insertions(+), 11 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 03e35386a802..64abf1743e41 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -9167,18 +9167,13 @@ static const struct seq_operations md_seq_ops = {
 	.show   = md_seq_show,
 };
 
+/* procfs opens the seq_file */
 static int md_seq_open(struct inode *inode, struct file *file)
 {
-	struct seq_file *seq;
-	int error;
-
-	error = seq_open(file, &md_seq_ops);
-	if (error)
-		return error;
+	struct seq_file *seq = file->private_data;
 
-	seq = file->private_data;
 	seq->poll_event = atomic_read(&md_event_count);
-	return error;
+	return 0;
 }
 
 static int md_unloading;
@@ -9200,10 +9195,8 @@ static __poll_t mdstat_poll(struct file *filp, poll_table *wait)
 }
 
 static const struct proc_ops mdstat_proc_ops = {
+	.proc_seq_ops	= &md_seq_ops,
 	.proc_open	= md_seq_open,
-	.proc_read	= seq_read,
-	.proc_lseek	= seq_lseek,
-	.proc_release	= seq_release,
 	.proc_poll	= mdstat_poll,
 };
 

-- 
2.53.0



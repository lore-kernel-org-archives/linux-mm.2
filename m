Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CC7886076CDC
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 19:52:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Wdi/cBrV
Received: by kanga.kvack.org (Postfix)
	id E674D6B00EF; Wed,  4 Nov 2026 14:52:38 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E3DD46B05BB; Wed,  4 Nov 2026 14:52:38 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D52C66B05C2; Wed,  4 Nov 2026 14:52:38 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id BDD196B00EF
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 14:52:38 -0500 (EST)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 63D68A06F1
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 19:52:38 +0000 (UTC)
X-FDA: 85398483996.29.79328C7
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf22.hostedemail.com (Postfix) with ESMTP id A1FC5C0002
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 19:52:36 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="Wdi/cBrV";
	spf=pass (imf22.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793821956;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yr3akMspnIWFpqWJkjrAgv6glOgJhJX8fSAifemHFwA=;
	b=nWyzKKW0GVfel8r8hCGtZrKOu2fYUjrwEReNkqqV3P+TOYVZokRWZd4A60CCP1DPypm8jD
	mVkqQgCV9GaxPcMYog4ISbwg8Wh1QYBaM2X31okMR8oyVjtNA7GrhNhgCWPSMLK9vK6jYg
	Xvqsy7q3UtRvVNUTWmx1TUnOnCrO/oA=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793821956;
	b=xHuSZofHO8PiGs0F4RQtX9mrXtrR+4x/boLbvI+1x0PA/W/6vt5jvze/kNeqrbJoT6QbS+
	qTU1QGvPLrEHrbhPIqMkTisSe0Qg3Ewt1K6yTJL/H+LlrrGsH3NgGa1AeO0YFrBl0v9GgV
	fglMYy+YIsb7Nc5tILAcrgK9Rmlb3AE=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="Wdi/cBrV";
	spf=pass (imf22.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id E4D5A408A2;
	Wed,  4 Nov 2026 19:52:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 742AB1F00A17;
	Wed,  4 Nov 2026 19:52:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793821955;
	bh=yr3akMspnIWFpqWJkjrAgv6glOgJhJX8fSAifemHFwA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Wdi/cBrV+aPpgWRwzXpiA+ib3De0K0pQhXbyKJhu1iexPEaDfaOTHNqiiiqzPXo1n
	 sHBvBkYLvUp265kZxirmL7Ost0iN+Glcw1jB+xXLZfNzc7jQ/+vNrfyJuIub3D24aH
	 FJeeaeTI1JKYgVteizb9BzRe2OXphrQw0/Z3qIHs6/g1diX9mzri9ugVAFK0faPBni
	 4fNDrMwo9L4EM/Oii/TzK2gV2q/Po1jRRBmUKKs+oPw3OgQB1bIjbd27ca1yrbdHfk
	 Mgqqa9yGsWvWaLe2ghGBqK/zKktWtu1oUQAE7grmxfWRAs9G65+CGMdjqpjfo1wZXs
	 QP7jFCWB/AzOQ==
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
Subject: [PATCH RESEND v2 11/30] latencytop: let procfs copy in writes to /proc/latency_stats
Date: Wed,  4 Nov 2026 20:52:21 +0100
Message-ID: <20261104-work-procfs-fs-v2-11-319e0f9a8aae@kernel.org>
In-Reply-To: <20261104-work-procfs-fs-v2-0-319e0f9a8aae@kernel.org>
References: <20261104-work-procfs-fs-v2-0-319e0f9a8aae@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
X-Mailer: b4 0.17-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=1161; i=brauner@kernel.org; h=from:subject:message-id; bh=9/PXHkkWFBWwJpiw0GjnsftfBxXIsWStv0RQuWJfsao=; b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWS97rHYoefdeeu3Wu6hdxnVaz7v/WWclHzHXeCSxcHZu dEaxyrZOkpZGMS4GGTFFFkc2k3C5ZbzVGw2ytSAmcPKBDKEgYtTACZiz8Xwz0LT9mYft9DOxTmH s3zMX0Q82m1+d9ocNc7ZMcs3fnzYeY2R4XCAwMyUHolzwR/2ZJ/ocma7der9hQWXfd9w6kXPqxW I5gUA
X-Developer-Key: i=brauner@kernel.org; a=openpgp; fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 7kuwsfhgi4y1e9k64tj9719riu4qm7zb
X-Rspamd-Queue-Id: A1FC5C0002
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-HE-Tag: 1793821956-389232
X-HE-Meta: U2FsdGVkX1/uCBqflYG6t65SwfKXylbELwBPoJtKnbw3B0zPfgG1d8FLQBoQpfYDo2AxXDUzo5TuBvT7koqaqVqyZ0S48uUe/RSRddWme/IxB9xYfQU3ctxbfOWTgoF0XFngVjugqnk6cdtDyDFA68Rexh3WB08sNEauaBCbCv333C0pCtZOtdnY27UAHo6DSa+uqgVUtVxO8BFr3IiLF39jcxth5BBfqivn+PwAjveJUV7auYzdHQ2Sy+t2HxYdq2QaPRQ8TPuRo4izyGT2fWYlTqQBlWhgxDBqDDotL1sQ31sLzjY/4+BbPszJOmyO3rKmn4a0JRA/Mt9gHCyLHTHVm+9WWAyLa85Bqd5SzQzItwREAaJYkFjqp7SFAtAedOzhLEDIS7UolEW+J4rBTTV5neDyOkaB2JLHOOXEj4dc4qlk+ltfJkVYMxOtgwdaSezF2atwCOjp4sVUbQxnGvWHAcMimzwYOdGXcyovIvLZQQkXcrUXtxhSnjirq18y18xFT1TUuekzVVz8ktCyWhMVI3P15KSpc68q177T1qcuAFEFprbM6YUWwLDn18HHFXtANyHMV3l/GQZ0xZ2D6nMM0r/isuUnNFY5afWxZvtFnysitEGRQVL11pFRiGxgU6pL8ZDhXzhzXr03P6rljTjj+Ka3am3Pi7VDY66SIytaiEaca0s9n06yUXXLOLOMOGX8IhAvRc4T+G0Au35aM5vZqSi118dQfV5BKiBY4jKObMc9s8zCB0eRbduof3UtMkWNfOiueLPwJveNJMzLUE7gaBl+GzzmnFeOB8AHfzrbHLL+RgtL2GWERKZdL6G5oRY4E8BfFfsNl87HYWHUlJgMdmlYJ2G8LxziNSidatD0SDU3LIjcRcBN88LYoOeE5QiYg6t6uimImunQfuzkDPefVKlWhjAb9j835XOGNzLDGWDD+8vwBCfX8lRezC2yjmoUShr4VXfq6aUYubm
 tJTqHzMZ
 GcZv6GgyEPuoVDcfmuzUfz4CCuoh+Itl2vJfy0qZyjgTX111JnYk08ZyFQrqfd5pkJl2q3ew8rXG+zd6HcF5DIWQW5kQMKXdPcaLGtBSFUTvs1rQE5tH5Y52av6HtFP5OqV5g3oldb7s/+HqwH+/92Jo8mFdixLuDJcfRy5e7g5CrRz6tb0nfgj+23GtiQzeX2Ol2wSxTGUmBjwrRmSxb0HyANsmFf96cE556hYn4OFJ6zg7mSIUYEZxsd9a2ZjKkFwLJGxoqjvmQ4+jHstDaWBf/Qa2DBIwiLcK4O1DDqJ3Ewo6hHvSYABmBsQgLVBkr5Jan/ZzjyKeFU0OgrXnpJtN09MeeAc8Wm4G27KeKyVreJPa3Hg/2yDCTA3ObQWmBye6vUi04OcsXafQ34alsXMQKLu31LdpTr8ASR5OkfbXUxZmW3Vv4txOsqf47khMeQaCLyy5I5ZSVN7M=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Implement ->proc_write_buf() so procfs copies in what is written before
it pins the entry. The write only clears the statistics and doesn't look
at what was written anyway. Writes larger than PAGE_SIZE - 1 bytes fail
with -EINVAL now.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 kernel/latencytop.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/kernel/latencytop.c b/kernel/latencytop.c
index b764f47606d3..35f73ca07656 100644
--- a/kernel/latencytop.c
+++ b/kernel/latencytop.c
@@ -267,8 +267,7 @@ static int lstats_show(struct seq_file *m, void *v)
 }
 
 static ssize_t
-lstats_write(struct file *file, const char __user *buf, size_t count,
-	     loff_t *offs)
+lstats_write(struct file *file, char *buf, size_t count, loff_t *offs)
 {
 	clear_global_latency_tracing();
 
@@ -277,7 +276,7 @@ lstats_write(struct file *file, const char __user *buf, size_t count,
 
 static const struct proc_ops lstats_proc_ops = {
 	.proc_show	= lstats_show,
-	.proc_write	= lstats_write,
+	.proc_write_buf	= lstats_write,
 };
 
 static int __init init_lstats_procfs(void)

-- 
2.53.0



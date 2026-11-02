Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DCA7F60824C8
	for <linux-mm@archiver.kernel.org>; Mon,  2 Nov 2026 15:23:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=YJCSbelw
Received: by kanga.kvack.org (Postfix)
	id 0A8086B05C6; Mon,  2 Nov 2026 10:23:35 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0801C6B05E8; Mon,  2 Nov 2026 10:23:35 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ED8D96B061C; Mon,  2 Nov 2026 10:23:34 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id CD3F76B05C6
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 10:23:34 -0500 (EST)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 4C9BEC0173
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 15:23:34 +0000 (UTC)
X-FDA: 85390548348.29.EA17B24
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf24.hostedemail.com (Postfix) with ESMTP id 6D46E180004
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 15:23:32 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=YJCSbelw;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793633012;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yr3akMspnIWFpqWJkjrAgv6glOgJhJX8fSAifemHFwA=;
	b=Y02DongtbUQ8/0+5WDTz2Ama3ZdCxOK2WgLpxS3G+WXGG+r9orgaK4zYJwkjK2e/vGwvlJ
	3X7fy3tfMn8ZmTWxP9VuEviHn5cnnAol+cc79u2WSTn4E5BYF7kVWZl6Z+1aUjpkAGzFEQ
	IRB0xoSwF0R8x7etV4O7HH5eGjxHJZo=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=YJCSbelw;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793633012;
	b=N29FzmgQabUJsL8VAgYeIutNpcbUBEbdc9uxmxslx7Na+fgc+RiIj9jXivM3l6u/3U72Ph
	m8hN6VCfsb2jYNrC/FHbe7CQsh2YHl6A3puOENtAXaY6w6Bzuryo3gcpkVKn8NI8n/s8UW
	MGR3FtXMOWDpf0UZi9DXMZW/nSPd/f0=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id C4B3F437DD;
	Mon,  2 Nov 2026 15:23:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9111F1F00A1B;
	Mon,  2 Nov 2026 15:23:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793633011;
	bh=yr3akMspnIWFpqWJkjrAgv6glOgJhJX8fSAifemHFwA=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=YJCSbelwTMu+lkg0XhQdoj8LyLuu8oZ2pe/iy53Q06xxAeDwqlvsnJcfvKWPrL8nO
	 1LPsdJ6f92UxNgYIH2elZX5cKB2Bn/cwnYbrr5FGX2EiostBzZYZDEJohQQBKlZ100
	 p7HUnoW1j6UUmYnSxVo38pqZI9irmD68pXikF1kIKMo2LkpHXgXPDrrJi4p7Z6BTEm
	 Ho/gXdwOiakESPZcb3mkuegm2OWR2/e5jdgZUaERpTqlL7W8/AYhca74N335/39sZi
	 ng2uaNbyx5FiMaSAp2/TUfphsXmLg87fQ3ClWdiErCTiRsq4P0nmjoEgLpLSQ0erqr
	 l9l+F4V475wRA==
From: Christian Brauner <brauner@kernel.org>
Date: Mon, 02 Nov 2026 16:07:21 +0100
Subject: [PATCH RFC 11/27] latencytop: let procfs copy in writes to
 /proc/latency_stats
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261102-work-procfs-fs-v1-11-d09a996317b3@kernel.org>
References: <20261102-work-procfs-fs-v1-0-d09a996317b3@kernel.org>
In-Reply-To: <20261102-work-procfs-fs-v1-0-d09a996317b3@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=1161; i=brauner@kernel.org;
 h=from:subject:message-id; bh=9/PXHkkWFBWwJpiw0GjnsftfBxXIsWStv0RQuWJfsao=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWS9WG6Uxf1FUCLiA19Y3u9pcme5JklFv7e+/n/G+vrUZ
 5GZL6Y4dJSyMIhxMciKKbI4tJuEyy3nqdhslKkBM4eVCWQIAxenAEwkpIORYdf3e/NXsH6/4133
 rv1C3AUbjW+79J6LeEzq8giUbOXbd4uRYa5Xn0HazZ7z2x9NiNU/Zf+6XrKpZKKX2K/DOgyTKn0
 MWQE=
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 6D46E180004
X-Stat-Signature: 6sk5jynf519nqi8w3orj51oaghdi9ydq
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793633012-809205
X-HE-Meta: U2FsdGVkX1+ymS83htK6kkx6WL6p2qHbCwFunW3VygbLvft3aR/QM72GzYLjd17u35SE2sW7KND/+LkEfBRi53CrvrA4BTARsEs3+8F69Kl4kbwTqTgVVnnftnAS84/pJJHiIbpes5rcu5MqwzF9s4EYDL1BYTTZcuPytm1Cj1m45gM0yK94OugEf4coBFakB5qhtVTSfXaoHA8VdZdZ+Z6MwWWUMqqd6o6xP4AZLXSyMAmTSZr3aQQzO/XptXEzd/zHi8w4x0qGtQyqyxexSen6hxHhN/xyR4BQ7Jh54HvLs+psdwfhXEWaz2OMk3Q1OBHITU08z/I8JjdjN0bzQPJMKdgZBi4CwXidrzxrYDbsCrx8XJeYkoTw8wSNiXwhpKEy0Je05re22UM2awkOsT/aGOOM2cfoR0VppAdzzLoUZBMbhH6DyYTPke3xW/s3YYlXYZTk1kzXwmO8KWMBFh9NkRrpBKKfMKV0U5T3v4ey2Jh08Ef8mBfGm4cxI4vIYz/E3CNusSvU1f7WvDX4TBye+AiYo0yyE7StLfMfooEOd/LksQtuMiBVcuIh3oLtPzcEUpGVnVo7qIkPJqdOGpUGS6bcgmfB6HKwM9gQxNY23PkY5MTF1JiLfc/hyqS9IweQ3GocL19zDdnH0LVBJ6wuGC8HMGE+9E1CSbrFBJ1dp+3hjUGZPDD3KVe6rOBEXiMyQcaPYNSwtEps4eLMrzJUzfsAxxu5EzPh/hckN28VzXnA8FBoeDnQ9Zr2gmIfTXCrWTBQBMaD9hK035ZVXFiHBb4uNp8BTR+WMc9UAk0il2dP5lToGMNpVCohDnc63OCJI2KnVlXlK8oNttDmWu3dJyGjKXhzg3apmf44KBKIs2gxTRl+x6ZrXupW9AHqG8mf2ec2QDI5aL88tctbQGWza9jlYJ+uwZieQijd6hUxz8Ynk8qzdlXOwHC/CH7iJ5RjfNBHLltXMGu5ukX
 gpa8ZmjH
 IcyRe7s+POEK68Kevm9fPJFD1sjaMavPFlL0U35pgMV9wDadgrrRDUp8M6PiqabNTY3JlAkm3HZh+je72UL0sxwkyIjC5kEfJNYJAl1jNvcxQC3BLY8W+8JzNhmB9ja+w5FFBvoOXUzkVWFVNEBZZoxRKVE8GwDzWoT6V1liCeiDdZrvMqTOmM43kX3OeSTanGnD9Oajs1ZRMlxvwKQT3mTRXezEa2kADpboXzAzcCKCsvjUg5JAeuPir1FHyXjhlQ4YjQXFmXciAHtHWFLbWDYb62ppSz2KxMuj+7JpGv/FcOvpc0gjTUM1gpNzTO3Umk2zgGBczAjJAn7A=
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



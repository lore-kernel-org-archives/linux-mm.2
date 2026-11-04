Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2F63F606D144
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 19:57:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=UG/CjC9R
Received: by kanga.kvack.org (Postfix)
	id 323426B05E4; Wed,  4 Nov 2026 14:57:05 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2D3D76B05E5; Wed,  4 Nov 2026 14:57:05 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 174EC6B05E6; Wed,  4 Nov 2026 14:57:05 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E7C756B05E4
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 14:57:04 -0500 (EST)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 762B91A0868
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 19:57:04 +0000 (UTC)
X-FDA: 85398495168.13.46BFF23
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf31.hostedemail.com (Postfix) with ESMTP id E3DF420006
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 19:57:03 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="UG/CjC9R";
	spf=pass (imf31.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793822222;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jhlUxShJ2PAnaFYEGZj/acNyvX4jU2/JMVjl8Ac9zMQ=;
	b=789vWQgSsEgTy3zqTRz+CWpTJoQ/VrBsgZw3dWTaiiQQ0XPYisKJB2dCUjvrf+FzRtIhGN
	ITe9Mr0gwYErr3JwwkOsi0be4qIv6gC+jUh3LDM3Hv68Q+YU37jFqw2RQXqZbEOJgQLNa2
	gLBWfnurp4hsWMpIJiqAu9o22ZV0ARA=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793822222;
	b=rXthIOPPmJO9QQPmHYmJd5cksDB4I3oiAW2niDgSLEQjrhAEVn5kiVO6NoHNZ0y47RECAz
	9vfXJ2eLlWAKp0M5IGOnn0KTqhwEAQYRIO0Fs5Y94Gkmy6q/Kbnbu8asOH/nwrwtyskqsq
	/wXDhPcjQm8KCGOyX7EeA76ifwdb3kw=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="UG/CjC9R";
	spf=pass (imf31.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 069EA43957;
	Wed,  4 Nov 2026 19:57:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0749A1F00A16;
	Wed,  4 Nov 2026 19:56:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793822221;
	bh=jhlUxShJ2PAnaFYEGZj/acNyvX4jU2/JMVjl8Ac9zMQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UG/CjC9Rkt2XWe4Y5CTT/ADBXwDaw3htLjr8y5+YgL1YecUa9PaFlx8A+yiHz1SJ8
	 4p/C+A4TJyThvCbT9oVAs12xUwwZfi3gUSQHEi0+ktGxJApT9TgtkZ7MZMIQb0oT1t
	 mimm0lfDVOWpZibb2krg3AKjfKsJ/2wyOhrIZ1/2EFinBMslTP/kS+IH84SFmYH5Eg
	 VqKLbY/k2mFZzsyboc8nkysTN03ogqiKx7Z/2HJ+GsHFrCwFfcOgZMgTbzH7pQ/p84
	 YjMYmkTsQU68yWG3aWhGtTSWVEK+TsxCMKzZUGUkncRJtgioqc9ZXJzF76qWCzLVHP
	 f0H0qGfmOj7IQ==
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
Subject: [PATCH RESEND v2 29/30] kernel/configs: let procfs copy out reads of /proc/config.gz
Date: Wed,  4 Nov 2026 20:56:47 +0100
Message-ID: <20261104-work-procfs-fs-v2-29-319e0f9a8aae@kernel.org>
In-Reply-To: <20261104-work-procfs-fs-v2-0-319e0f9a8aae@kernel.org>
References: <20261104-work-procfs-fs-v2-0-319e0f9a8aae@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
X-Mailer: b4 0.17-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=1297; i=brauner@kernel.org; h=from:subject:message-id; bh=IZ5Jauw3jeCJbbKJV7DoExBPgNJSSia5o6c0KJSA0oY=; b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWS97vHLN0r7IJLRr5y0OmX5Xu/U5sWZHm3lBfWGUlk7h XyrbJ52lLIwiHExyIopsji0m4TLLeep2GyUqQEzh5UJZAgDF6cATMRJnZHhUPftBdnFb3hflihK zLy5v/jL7fC/i5gnv7e8XrfJi+OXEyPDxuIwjmsNi4T7HnqwOKu6dClZ31A1+vC+ycV1bYfyKy1 OAA==
X-Developer-Key: i=brauner@kernel.org; a=openpgp; fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
Content-Transfer-Encoding: 8bit
X-Stat-Signature: j7acryb77twxcw5ex6ycojou5itttyr9
X-Rspamd-Queue-Id: E3DF420006
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-HE-Tag: 1793822223-362028
X-HE-Meta: U2FsdGVkX19snuhUuhhQhlS+Vl5M6Ld91/6QhhcwkjCsgObeos0AuQ/v8zjEP6hHP858vtcIMJUdRLW3n0dVu4mvF/1933kwFke4kNYRGj4vhYLfnKD9YzD4xF8XZIeRt6nM0MGLrIVU+jsh/URcieu9OCfhM4ro2wgbM2rMDa4oqaPWaJwaDhaaOUL0mn1ybGiykeGiwe2ekT0C+MMmF48qXQACTtqU3NayZ8fbsgB9t02yXwwx1vbWim1P3UnRdU0vpE3RFnEHQhqlkMQgL2EzPUpvg6VZMuy7JmpppMzTisXiLG3nGP2jW07ciokGzeprV+jNgF/Q+sYpLejsWVDBQ62Qu3vqxv0wTL+cH5tHYKvKOuUDBT6ceYCZd0qE1R87OSka/3AXmyKTzVsYX1iT/0+x80czEX/mG6dw4TgO5Yd9GT9qN9pYUQ+t5W+Vg57YDUZqN3WfjUVL7xnd+FREIIMKRivWX8VITMLFXXJ0RChufkqP+IcdwPnO2Tz9GBK/AwuSrkbx5KgxN4TcWcENSb4w+GXBAyL9EOZQJ+K6RBO+ZE7N37nJQYzHBsMfgGtFt0LT5nSqzP9NmdlN6nZQLxhy4deQ2dPB3YZYABexM8qJPjva5lFai1yxRvJir7XblyQkSNLvq8z1rczkex7bc2TJ/tLIK6fjNOWDYHZvGnydud1nkkGDirsPI9TMq8fVQee91ZY2vhPLOfDH1wZrYGbHkslfovo43oHnHziJJF/S8BSmK2/N6yhD/VFauoPonSu03y2j3Hjok3y6ynEajj1da/+piTgJbNFpSHa6bcGGzfKSQS9+fupGQcguf2b16Wm/j+rz2T5zxV2EPn+lbX1ewc6q9DxwYJAyZ5Yll1HwhFVlKH4ckd5wQz6tIw/vWxZ7DdhXJMdKVeKuG63UrAXOnZYsq/pidamgDNaXx2KqncTh8NgPRRhttnpev9jmn0v20Q7PYirHQG1
 1rDXIeEr
 gE4NWCrBGSSfC/dPyVg8VKn+EsmRd5YBqTndzDatAoiNKZMIfOEZPi2SmqHXmFM0PJ5gf1Bymq1Uc6n5Gd2Zwz58dIcAZlIm2L9+sh/cWr2RX/81uFVoZGml8rPHm23dScRSfNyQKLltdRrx780sb0+ZeRi2chsEwJPegHss+3felP4l6FV4eg/ZBmeOCvoA2KtKPbIhjxQfmj5Jvnd3zO93y3Ixf/lGwOknjou+93K34rPxoL45d4QAQoOjS4DvyXZPsiINifBcR62FuyZHcZaQy9o9LlhDy+8/lkvoBT4w9DH1RxCV2g1uCSN341Md0H+Hr4CjNX0jfMyTiEe0qsl0FUmT9OPH+cPJ/+MxHRwa6nh2YyFiU/JKqpp32RkoBFIuZYrrdISLDXHIOInshqT+09g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Implement ->proc_read_buf() so procfs copies what is read to userspace
after it unpinned the entry. Unloading configs.ko then no longer waits
for a reader that faults on its buffer. /proc/config.gz asks for
PROC_ENTRY_FULL_READS so that reading all of it at once keeps working.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 kernel/configs.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/kernel/configs.c b/kernel/configs.c
index a28c79c5f713..05b12c440168 100644
--- a/kernel/configs.c
+++ b/kernel/configs.c
@@ -38,17 +38,18 @@ extern char kernel_config_data;
 extern char kernel_config_data_end;
 
 static ssize_t
-ikconfig_read_current(struct file *file, char __user *buf,
+ikconfig_read_current(struct file *file, char *buf,
 		      size_t len, loff_t * offset)
 {
-	return simple_read_from_buffer(buf, len, offset,
+	return memory_read_from_buffer(buf, len, offset,
 				       &kernel_config_data,
 				       &kernel_config_data_end -
 				       &kernel_config_data);
 }
 
 static const struct proc_ops config_gz_proc_ops = {
-	.proc_read	= ikconfig_read_current,
+	.proc_flags	= PROC_ENTRY_FULL_READS,
+	.proc_read_buf	= ikconfig_read_current,
 	.proc_lseek	= default_llseek,
 };
 

-- 
2.53.0



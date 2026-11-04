Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B4F6660DD366
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 19:53:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=gqnu7WCa
Received: by kanga.kvack.org (Postfix)
	id D2FB46B05D9; Wed,  4 Nov 2026 14:53:24 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D06316B05DC; Wed,  4 Nov 2026 14:53:24 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C1C6D6B05DE; Wed,  4 Nov 2026 14:53:24 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A777D6B05D9
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 14:53:24 -0500 (EST)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 4539D1A084F
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 19:53:24 +0000 (UTC)
X-FDA: 85398485928.12.C49959C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf12.hostedemail.com (Postfix) with ESMTP id 7849C40004
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 19:53:22 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=gqnu7WCa;
	spf=pass (imf12.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793822002;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4FMH8RRbXwyOGE4j1ACekL014/FVLGRJa3NjwiBwv4k=;
	b=rlgzM6JWTaosovVmfbvTdCnkrqFxVFPRlW/1aD4GZs5eRk8nxUui4LdHuEQZON/4k/IDqh
	H19a/IXDIYfwGwXs/skut71wLYxQMY2Jc3oMQfNjpRzk5gHlOy2y7oT6QQhuZbqbx59fYD
	oea/okvmUPY1LADyF/xW6oJrqIbAfk8=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793822002;
	b=AxXhC+4GmkQMQvQmUxujtPdSKSGablmGQYc5O+GAG4+3pTprmtLSjV9g+CeCNUDim4xHsf
	59eN8CaQJlh7TtPowAVbuap4jTXqMwdQSKR7iGWxFEZdlWIcrTVcAZZu/qGdAeOvWO01tc
	QRa3seJwtAfj9/nIhlaN7W6MuH83pcA=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=gqnu7WCa;
	spf=pass (imf12.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id ACE0C407B2;
	Wed,  4 Nov 2026 19:53:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1749F1F00919;
	Wed,  4 Nov 2026 19:53:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793822001;
	bh=4FMH8RRbXwyOGE4j1ACekL014/FVLGRJa3NjwiBwv4k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gqnu7WCank0HPKzxIIuR0c+Y7qFDIfOx4OhXQRsH+bwXeorJsZ7tfbWZNyh3GbhMt
	 NxTOPufkaHrp11YLfNa93/yXQ6n5h0z6fpBeg6Ly2XOx7LhglEYilynsq/HFu5e5m3
	 ATdWLZ7uW1x0Y8xMKxBVUpJaU7+YU0ZruYzah//QhnYRcr/O7neJgjfCiw3cbGeL0f
	 /scHMQ7wD59wgQWjLWITDYTvE8W4dpcfUNiJQWmwj5fEXCsq8JXV17jYeqe34cF0gX
	 jLq6ATZZOpXLQz2og6LqAuxsn4M17sNhw8oW2RQKUyiL2Rz59/u2T2Au+Zeqcz04DQ
	 gpufF/LrdsChg==
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
Subject: [PATCH RESEND v2 14/30] profiling: let procfs copy in writes to /proc/profile
Date: Wed,  4 Nov 2026 20:53:06 +0100
Message-ID: <20261104-work-procfs-fs-v2-14-319e0f9a8aae@kernel.org>
In-Reply-To: <20261104-work-procfs-fs-v2-0-319e0f9a8aae@kernel.org>
References: <20261104-work-procfs-fs-v2-0-319e0f9a8aae@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
X-Mailer: b4 0.17-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=1504; i=brauner@kernel.org; h=from:subject:message-id; bh=acPYXqQQVYOg2sB+M+GQAGt+iBO20XAT2Sfl3M0drAc=; b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWS97rHOf25YKDbxbO9Bg6IFQW80Jrk2dVu9Wx+89J/Uj +nLeu/rdpSyMIhxMciKKbI4tJuEyy3nqdhslKkBM4eVCWQIAxenAEykIZiRYcq1Of62b8t3Tr08 3yy0w/fMvbrULi7+T2u03cst/b77X2BkOMOyo3gzb8Wco9XFOhk9DzgWqprLqslOEzaU3DZxl4A KIwA=
X-Developer-Key: i=brauner@kernel.org; a=openpgp; fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 6fuhwrqquhkup4j443awkjsndoediwx1
X-Rspamd-Queue-Id: 7849C40004
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-HE-Tag: 1793822002-134043
X-HE-Meta: U2FsdGVkX1/b3qsylpX+sAcAKJ4wHxYFqlpq26JXQIzSXXvgOVviBtZ0BlFCyJLCyIFR1FR0kWaIfSgIVUiFap24JKgGxBJgHo/+ta/1jQvMmVjFni39PKmEatd2Xe79ZebvFc8g2dtAw8AzbnK+cUHKNkaSIAcreNlEr5FMJXwZc6o4M9M52WV7BOwsVZLwl2uOgfTWCdu5koKLHGYSq9KKNdoSd4aROoDypGsO/Elrz9T8G9y1u31MJ2Bq/8yZqZkXu17BbLq699rNFP87mqCBYMhQc8Lzon3UpEXaWMja0XEk27z4pddNuMeRl7L4RdmwP4uY1Gm5xf0/03Mfoi9xsjBbuBLhYiQy9YitomIvSywqUsJt/k7YoYYIGbvIPcCA8JEXt2CYEyv7yJH6ylM8jZbGyyM4pQc8Z3gEBq3xxZlOGHZzsNucm7fihbJKqD5bj5GY7CG8TzSpEkbH38cKVErZgbwoa4OLlqF3W14qkt8Ybw1+mkBlLKZrhrERszZNApxHz4d5xmmh70o3lwiEg/sLXy2sil7wY71h3nnL+MnI1VuhNcfvepPOJ+fJ5aBJ3iL8JIC3gRZUAY/VkWCfnhKRT2TMrNZxMeQPmPx1A9qxToJZOFAes2pkp85fs1FjivIXuAcetlJoCCJ30vXA9wx9MWvnopLGwmUwscNgIqVT+/oZrZlLI+CwyYEfqyRdMM2+uIjfVz/RAj0NJypn15TPsaR7CWnxqNCsLlcYz1VkjSgPffE2n3YzBdb3u6vFT70Crkin3BdbXu7OU2iNsvTIlnWh3szCxfA2IxT/qQ2Ymm5zHUlTEFwiYMpUq+MEzdfhAcB5lxWR12uzaLzIiDDOuRAJJlt5GAVhKbF3h5Ab9wTRTQ4PSt22LsbYNDUfbKnnPs5P5rsLZJdY/2cWRSsBbssLWjk/9bU6ApEn9gweqV1i4CfjfxfsAEJre06MrXIs64NK7ZNQE5S
 Y5AKijTO
 MMXeTZFLw6ZEWDsVWuQr/wJfxwmDwOPqOh4reJzXlJUAGUZHYkfB9VnnX0C9QlJYu+6v7SdfxOI4+eFPPknx7jGcaOznfl2nIHGy6prJHs80tA2kGYiXYQNK10J+ucBK03Pb8tBcSim8AIp4mWjKg4IacswYH7lZEUNv3lpkhQvD1RUoQXAPIB9+QIWBq+/cSJ7TqMGDv1qMJW4c49bMlxsWA0vhtyj6+JneJNBobjtJ454P/olocEsZEx7vSCkHZ/5MsEiA5iCIcpSo3hg92o7FERDJ6ElaWpr9Do0vVxVzsV02uaiMIJU9qFTmaNVSkQ+uZHpJ9pyvbLZJpvDtENBfi9UAFSH75BPOfH0TlEUgqIDw/LeTjL3IhXp1N7O41CETf/oIXgpJmjeq+53dNEEtMlQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Implement ->proc_write_buf() so procfs copies in what is written before
it pins the entry, and take the multiplier from that copy. Writes
larger than PAGE_SIZE - 1 bytes fail with -EINVAL now.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 kernel/profile.c | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/kernel/profile.c b/kernel/profile.c
index 820d5ec909d4..dc2db66a77d2 100644
--- a/kernel/profile.c
+++ b/kernel/profile.c
@@ -189,16 +189,14 @@ int __weak setup_profiling_timer(unsigned mult)
  * Writing a 'profiling multiplier' value into it also re-sets the profiling
  * interrupt frequency, on architectures that support this.
  */
-static ssize_t write_profile(struct file *file, const char __user *buf,
-			     size_t count, loff_t *ppos)
+static ssize_t write_profile(struct file *file, char *buf, size_t count,
+			     loff_t *ppos)
 {
 #ifdef CONFIG_SMP
 	if (count == sizeof(int)) {
 		unsigned int multiplier;
 
-		if (copy_from_user(&multiplier, buf, sizeof(int)))
-			return -EFAULT;
-
+		memcpy(&multiplier, buf, sizeof(int));
 		if (setup_profiling_timer(multiplier))
 			return -EINVAL;
 	}
@@ -209,7 +207,7 @@ static ssize_t write_profile(struct file *file, const char __user *buf,
 
 static const struct proc_ops profile_proc_ops = {
 	.proc_read	= read_profile,
-	.proc_write	= write_profile,
+	.proc_write_buf	= write_profile,
 	.proc_lseek	= default_llseek,
 };
 

-- 
2.53.0



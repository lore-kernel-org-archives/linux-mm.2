Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 69369606B22A
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 17:50:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=TjKPb5Zz
Received: by kanga.kvack.org (Postfix)
	id 51A246B05BE; Wed,  4 Nov 2026 12:50:01 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4CABA6B05BF; Wed,  4 Nov 2026 12:50:01 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 392DD6B05C0; Wed,  4 Nov 2026 12:50:01 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 105536B05BE
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 12:50:01 -0500 (EST)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 95175160777
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 17:50:00 +0000 (UTC)
X-FDA: 85398174960.10.77EFBE5
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf30.hostedemail.com (Postfix) with ESMTP id C2E8580003
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 17:49:58 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=TjKPb5Zz;
	spf=pass (imf30.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793814599;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=weMUCFn2uihXk/tOxGBDEw27Pws++kgwJ6Tcia3ltcw=;
	b=EyFsXkUKzUZhxbs5ZrqGd/FbSGfBWs7USwMFH1Bo1rK60d+5fB7bpqlq072iCwW3W65uV0
	8JPrhX5gvg1bNhCTgZMytTmGBvZugBj2EMwfReIFLLo9OecWMj2PJvgHIuoPNwCiZD7zuP
	4ydnjxFOM/iiKnGMVmCZtiyEXb1ZtE0=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=TjKPb5Zz;
	spf=pass (imf30.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793814599;
	b=spg8iHRX+Q0/vQX3wTkfFTqrgl1BEky/L66C3C95VlwJhZiHknSS6RhylNM1A81V4nafgx
	bDGEpIwnBokCKiC55uHvgDQKLGQPdH205v61odtFQu1rVBe0UtWjqlObh4++YzT407Gi7o
	rXUv329jS+rV4eW29/kiRf9lKZheI2o=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 1227341F95;
	Wed,  4 Nov 2026 17:49:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77A9F1F000C1;
	Wed,  4 Nov 2026 17:49:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793814597;
	bh=weMUCFn2uihXk/tOxGBDEw27Pws++kgwJ6Tcia3ltcw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TjKPb5ZzIiyiPgvuQdFoHuUkVx/a9GRzTloH+KR4l/JxBBb+Ol/moI3iP+vc7jhxh
	 Ps/jhLkGJWT4b45mLDzTmXs0Nq6ur+emr3Mnae7d+PkH9J0ghZeeOzUERLhCb/2x/I
	 Bwr8JHwweuJMSvPLSvB9rFxVcNiRrk8Nku+fNgyLtGVeEaDxUpEY6iJFDv9syz/nxS
	 a2j63GShxcJSlKeqquyWTJ1SJRA6a75PgRtqXfY4thvlg42TMO3Ay+5b5+IY0bEO1l
	 k3RvIz3DDBF5vn8/zalT+H7o+LqH0DwmSQZgpn2Tax7AQIoVLkHn44OG3fzujjSSY4
	 17TkLkudUusDA==
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
	Chuck Lever <cel@kernel.org>,
	stable@vger.kernel.org
Subject: [PATCH v2 19/51] xtensa: simdisk: don't read the file name without the lock
Date: Wed,  4 Nov 2026 18:47:05 +0100
Message-ID: <20261104-work-procfs-bugfixes-v2-19-bbf7d5546809@kernel.org>
In-Reply-To: <20261104-work-procfs-bugfixes-v2-0-bbf7d5546809@kernel.org>
References: <20261104-work-procfs-bugfixes-v2-0-bbf7d5546809@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
X-Mailer: b4 0.17-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=1811; i=brauner@kernel.org; h=from:subject:message-id; bh=wpJfI2N0Y4TYbGny8B/EWcsaN47/8hdz2WKuRaZg6Os=; b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWS9zrtmmihY93BLSLDu9Ie5rjb2qRU3I+zPe+3cqF86e 5KJ7eaZHaUsDGJcDLJiiiwO7Sbhcst5KjYbZWrAzGFlAhnCwMUpABNZeo6R4WJUn/qcs7t1vaJm L5zZ9iJOJiprB/f/Sr7aQnnr1cdmdDIy7M/18T9/7EByzmbvb0u/Gdlr8edumNMXNW0bh1H7s7O CzAA=
X-Developer-Key: i=brauner@kernel.org; a=openpgp; fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
Content-Transfer-Encoding: 8bit
X-Stat-Signature: ezp8hmq9jm1zp75ftq75mae9r813eje1
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-Rspamd-Queue-Id: C2E8580003
X-HE-Tag: 1793814598-677119
X-HE-Meta: U2FsdGVkX19yGeVrMKR9TdVQUZ/L733emw9I0e2dJkVyatY8xAacvJslYi6geP0jniw0dexYIm02KCJ+3uB/gxsyv947sae22ftx45h1pNCSRzMBjtK3ZseRZhVK3Cmmy36YZJolOXkXOfCBG3jcjbM3UsrvNvI+jvYMvtwN12NNNhkrnzp91qTB6Dn3Xf7bCknM5jJAIGU5Imz0HteWOicY4omdrTwDp4TL1tzUOOHJtfOZzQMWmTy+dj+aDuXb9sDlL+ES7FL4BQbEF5hSE34xzL9mzHNKv4XBbleagLrXcfnnLMWat9tUBLOmQjaMOORsU3W67+NHaoAZfgW87XRSlaZSoPlCuus72ZAB24znIKEL/JpJ0DZF6toQX5Mho6q9emOaLSYQY3aF3UvQT3uUJDTzGIftFhjkAtx/cW8hItcKeLjyEr09FmUgtgE8Y9DByrIo6F1/JHVf3m7QIEdG2w6f5fNA2I2EVyHawk4C5YKOzi2oBvfJOaJ56FsBoObBC5LQ+uwf1x9zdWuAmQBIzh4ggZkpJQBdRDc06Yd/+DH7TPhrVoGphqCfFgg1gokCTx7YG036BKEhjTVToC2Slq/LPvdPPEr3tLmfDzsr/PovoFeRzEYGqa02ui6bb8QzsWX0KdbQ8IZeWATlS/ZlqxQYr5lUw0q8AzxjAVWeaiNcmjWOIU4avMU2xlNkJ1bQuygQ0y9om9io5fYG0Lm0egkoZxOydfCjzBRBBbWQULnDGbjfk5f5YVcYYstmT6RvhPhV+XN+lAKi0NxDdWj7CoGCiK9E3KdCZ7oRjOAfcMMggcAJOn/rVW1Yg3+URFxBJ6woOLVVVM69vZccE3uMwAJXAxar9MQI3R3sH9dX8P1fWMRyCJUmSaxpghEjLuQJGZMHh5MZy5icYHLJlTdWN82r+K3vicdi3jPhN58iVxruRVnOCsGPCtbVbPo9mmblILBnn1DCDbqvs2d
 k5wdqxaM
 dQevpJSrsf0irmtoFnQklevk81DYOnNIZNxT67cIDgUNpC77Y4i9QFnA2pZD5q59FDaOeyNId8b5ffuoD8rChPlQTZvrP7nSxVtQcrkrjv/GlndRL57j4v3/B6sVjeLgu87GwkyGbl+2bDXoSqD4P55E8YTYuXLiMzPYp0oLDI78HXQDbDR3R3tkx3FsoeTPwQpHCAM9Jz5Kp/F498Kyg4Q2514eKwFD8Us1Z6pJYQQ8Y2O8ocLk1h1U1yhqiCofEQmYFwxi+0WTxE+ppxQeUEr0ZpXPyGyQOimbxksQkc6qJhGNpgF4eTwJgr5HFoArP45ZcFia9PovORsg9e+qZUNQmBNIacmJ1C7CuFEfvhgihjr9pgKfXR4zpXfJlH4XjgRrwAEJsnONurhaF/BGwDjH1lA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

proc_read_simdisk() looks at dev->filename without holding dev->lock. A
write to the same file detaches the disk and frees the name under the
lock, so a concurrent reader can copy out freed memory. Copy the name
with the lock held.

Fixes: b6c7e873daf7 ("xtensa: ISS: add host file-based simulated disk")
Cc: stable@vger.kernel.org
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 arch/xtensa/platforms/iss/simdisk.c | 25 ++++++++++++-------------
 1 file changed, 12 insertions(+), 13 deletions(-)

diff --git a/arch/xtensa/platforms/iss/simdisk.c b/arch/xtensa/platforms/iss/simdisk.c
index e51edb8cf872..1248d960e5d3 100644
--- a/arch/xtensa/platforms/iss/simdisk.c
+++ b/arch/xtensa/platforms/iss/simdisk.c
@@ -238,22 +238,21 @@ static ssize_t proc_read_simdisk(struct file *file, char __user *buf,
 			size_t size, loff_t *ppos)
 {
 	struct simdisk *dev = pde_data(file_inode(file));
-	const char *s = dev->filename;
-	if (s) {
-		ssize_t len = strlen(s);
-		char *temp = kmalloc(len + 2, GFP_KERNEL);
+	ssize_t len;
+	char *temp;
 
-		if (!temp)
-			return -ENOMEM;
+	/* a write sets at most a page, see proc_write_simdisk() */
+	temp = kmalloc(PAGE_SIZE + 2, GFP_KERNEL);
+	if (!temp)
+		return -ENOMEM;
 
-		len = scnprintf(temp, len + 2, "%s\n", s);
-		len = simple_read_from_buffer(buf, size, ppos,
-					      temp, len);
+	spin_lock(&dev->lock);
+	len = scnprintf(temp, PAGE_SIZE + 2, "%s\n", dev->filename ?: "");
+	spin_unlock(&dev->lock);
 
-		kfree(temp);
-		return len;
-	}
-	return simple_read_from_buffer(buf, size, ppos, "\n", 1);
+	len = simple_read_from_buffer(buf, size, ppos, temp, len);
+	kfree(temp);
+	return len;
 }
 
 static ssize_t proc_write_simdisk(struct file *file, const char __user *buf,

-- 
2.53.0



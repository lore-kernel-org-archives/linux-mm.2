Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E735A606A33B
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 19:20:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=HRxCl+Bf
Received: by kanga.kvack.org (Postfix)
	id 0BD3B6B05CA; Wed,  4 Nov 2026 14:20:54 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 06D9D6B05CB; Wed,  4 Nov 2026 14:20:54 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EA12B6B05CC; Wed,  4 Nov 2026 14:20:53 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id CF1C86B05CA
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 14:20:53 -0500 (EST)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 6B1FC1607BA
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 19:20:53 +0000 (UTC)
X-FDA: 85398403986.26.A744D49
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf23.hostedemail.com (Postfix) with ESMTP id 94EC1140002
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 19:20:51 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=HRxCl+Bf;
	spf=pass (imf23.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793820051;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=weMUCFn2uihXk/tOxGBDEw27Pws++kgwJ6Tcia3ltcw=;
	b=QKBxmHSGWdGdi2rqr0qXTPrClQJtvAglU5v7VDi7To1NnP5I2+LBWFq1cywb1rbnHf8qNO
	9LDyCqCxf0ed/jSx8mBnznFqj4P3XWj19F6E2DU5gdMoDaitj3Tlb7iZHtUxfA8TYu0Zwo
	vR5XfShtl9jppTQHgzbBzURNSwjXaoE=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793820051;
	b=IDOQ+VzekK8AEBjatTQGpSBwG2WYGZu+luR2WaUFzmmLLFBCZr/njQqALnkpBFIgjS8RUQ
	BRpci/mmq3oLbm52NTl5TAqJc5Ild/AoCpMwwTneOi+LJrnnyHl+eS914hDPuRXOpQd1B9
	tq5NKfbJz8pe8andC/kz2Sa+68zkcBs=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=HRxCl+Bf;
	spf=pass (imf23.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 4651760D81;
	Wed,  4 Nov 2026 19:20:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9ED11F0093A;
	Wed,  4 Nov 2026 19:20:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793820051;
	bh=weMUCFn2uihXk/tOxGBDEw27Pws++kgwJ6Tcia3ltcw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HRxCl+Bf2TmTIdvOsOeyzhK8jV+Bfm/AfD9cI3ivj92Dd3pOYsACEhtqy21kBrGn/
	 w5dZIxEHBlkGPyiksDR2eeyKB2QwqkCs8BxVbPOrva8f8+0RyiF4g2ftBS4+38Deq2
	 ECW+IMt2f5f3W9mcjTW+c3CS4ThGnFOYG1d7M9XEv+5D9eIa8f3cQr1EJ+w9iQ/rUC
	 XqEw7LR3pXX6IXRIprFLgivWh1G2NDVohugAan8ecdIvDwRxpUYWViMOW6AbNVUMfk
	 FUYGNVRL6tdh+iW8t1JOxMZYVBhZSDKN5vzmr7c/IALhlwuE9VxTB484IK+SvnVk+v
	 mX/CkL30zPq5w==
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
Subject: [PATCH RESEND v2 19/51] xtensa: simdisk: don't read the file name without the lock
Date: Wed,  4 Nov 2026 20:20:36 +0100
Message-ID: <20261104-work-procfs-bugfixes-v2-19-021c84d852e0@kernel.org>
In-Reply-To: <20261104-work-procfs-bugfixes-v2-0-021c84d852e0@kernel.org>
References: <20261104-work-procfs-bugfixes-v2-0-021c84d852e0@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
X-Mailer: b4 0.17-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=1811; i=brauner@kernel.org; h=from:subject:message-id; bh=wpJfI2N0Y4TYbGny8B/EWcsaN47/8hdz2WKuRaZg6Os=; b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWS9bny056pefW1bw+0G9QWxvIVyC3XrvoZ2bGCV5J46b YcBi0tqRykLgxgXg6yYIotDu0m43HKeis1GmRowc1iZQIYwcHEKwETc3jIyPJ21usJ4wx/59rrj 73oYXwhfmLvodau6v+vZpyZ2wYlGEowMHzItDeUOXp9h3ywj4N1/bRkvB++3BTNNjTf/8um/cn0 /OwA=
X-Developer-Key: i=brauner@kernel.org; a=openpgp; fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam06
X-Stat-Signature: 9qt9g7xse8add9efpu5z1hjh3a8sefh4
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 94EC1140002
X-Rspam-User: 
X-HE-Tag: 1793820051-893967
X-HE-Meta: U2FsdGVkX19k66zziP/zIrPtFyvZ4BsL4a8GXWvKWV9zJXPW8IHz5Nro5iO4qP8OWzRe/ol6JMNP+SPv/0oJ9h2MBu6bNgoN97bSZAmxrYQcZbKBOC7iS+GYVpnmsqdIah7Th7Sb8+RQ4ZtCO5syk+Cf2k60BsJB9S8dckE7Zm2FR9UvN9FEr8YSv2M3NG4edAZH/yqGHasBWZTSTwJrewpVZfJGNmQgwFq+f03v9ZLnmXY9O3W0C6fv5gTEGgA5OV9mH67HqbhtdHxRLHJ5Xq8F2HvvxUGwnCUu+hIGRl4D0o0dzNIMDw584lAQ7xFAYg4EUVKUYTJn/f4VfGoSqocThvfKO1seSKIodJsJbTm4pDLJXI7yv0qOdzqN77msVC9deSMlKb4/j/HmJLvbknjx9+caArQ4bQmi9mvhu6cZUkK3p7rP5kU/RTS6+DfRx8RxyQUegBswCeKABQjDWx2cwo6XumncYfp3tFOYHPUKIhBoi0J1ghiJjZlw9dpsq5SDL9cNHEF6ZtqdXEe7PPcm1qEqIEGHkAsZac020Kg6Aqvr1eZVd4Q3H2iDtbTCBPPU2XwbjI05uOlgjgdbZLNwHV9W2E0N3Rnha1dwIFmHxde248tcGvAceqU846USpVJ4/q1w45iOrUiAEKOkwhzpGuZVmEhLZgFA9F1OnD4lxpoK64G4wb3lHp8nzTFLGFwrlDWxZYJpco8QAJWwHEd2eILkDkUbUFjZjbpkbCjOHi0fQ1ihn1Gpz8x9AZR2xZVhfrwr39qeyLgEMgA7tRgNxd+6FF98clQpc+1Rlw4k8km6VhgqDpRlW92TnIcboO+RO4QHkBynZIQQ/KKtsZkjFcThC6PD/XDDdQu6aJ5W82rgE76alP/ASOnWLEaKznShdFoqUHrG9G/zqrmMp4LqWxfjwDtIOnWYcxQ25C0sGIHi+o7yPfaj/VM6oM8vGKZmvLZdOjsBMcv8juI
 Ks1MIYyg
 gUgt0oSVT4ySfzp8WTVx9qhWn0n3yXBsdENF4e5e0On9Y0lFYEqLWbvr7iABrNhu0CnJdv8SPtym5UvBWrARzfeT89C3MgcsDu0pq9QZK7tCEfnk0XbOl1ZGECO4zryUnBm7v4fzfqOHNQw1xykbve9SZwcGCzk2xfX3+a2CmMqYIb6U0WDcJsvvJzVAYU/FTBKX87gNjoMBCHdRMJ2vaT3dHJ+i41CDMMCELfznEJ8O1KbNGKq+O2Xlvn5fJq3pAsY3VB/eX+4v2HAJ8Tag8Ac3WwP2SYc55k1tSzlhn5sds+Jzv66ef+Qru9lzS1baq9ua3qiXD3pP7AUYCTYFWxQ4QjEDCMhX1c/8u8eJe8zpliDMduQwcAJXYVUy4F0DtGCE0ekcrogJjAtBTU+iUY89q0A==
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



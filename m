Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4BE68606A32C
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 19:06:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=I+rigGmZ
Received: by kanga.kvack.org (Postfix)
	id 4BFDC6B05B6; Wed,  4 Nov 2026 14:06:35 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 497BF6B05C7; Wed,  4 Nov 2026 14:06:35 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3875D6B05C8; Wed,  4 Nov 2026 14:06:35 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 100746B05B6
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 14:06:35 -0500 (EST)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 8865AC082A
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 19:06:33 +0000 (UTC)
X-FDA: 85398367866.05.8C44FDA
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf13.hostedemail.com (Postfix) with ESMTP id BF43B20002
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 19:06:31 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=I+rigGmZ;
	spf=pass (imf13.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793819191;
	b=wsvhJhNAH+37dvrJManLeICBgDlJr3U4vH8rjvcANWYYHBxTvBlcu1zfDj/cu9HuAAkUQq
	tVeYmRImTvct92WD40B/nUNqOl46V1nyW6AZezDu31vB15XdlXouo1doeF3bJ7IpeShxda
	8Q50Jjnp+b0DreVrGsfJtsyDuQIiByU=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=I+rigGmZ;
	spf=pass (imf13.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793819191;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Em8mdDwLTSxa5ZBRNu+oIoQ2F8Zgf6ZNSHVwHsLTxqQ=;
	b=PFmfZ8DKaYkOZr2cBW0foFbGzgutzS0DWaX+BZGBoiCVDTX3PwuWBM2H5EimrKzXlg1Due
	djVFl5TF4u0yXkz0PFbD+CZ5IKROzpNOp+e0E8CjaJCow5KOBZUST3xUtVdd9bRThvonae
	uGIfnFoHeBt5l7n6AnHqEtxDuOFmqow=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 54F2D60A59;
	Wed,  4 Nov 2026 19:06:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C07691F000C1;
	Wed,  4 Nov 2026 19:06:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793819191;
	bh=Em8mdDwLTSxa5ZBRNu+oIoQ2F8Zgf6ZNSHVwHsLTxqQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=I+rigGmZOHwTEm4j8esTdHrM/VIiE0INnQhd67U/op8joUgvrnIpOWQaZW/5O6v8W
	 YxEI7BBt7v7/iIbWMDqC5P5gDErHxVHWNk1oGdOPy0hEJ+WUpryJaozkMYgBUtrWg0
	 sWZCtiuywTFRHSkiBUPK4QLCU0lZ7vJCTHK/XMxCkqriiS2yD20bZTUzzbqGfPLf90
	 fwuSv2m2/wipu/jn3L2lYjPBm4qGv0ChVoXWzavogJKkLpjbp4SSDjOwlmAhi9kDBE
	 eeqtjf+Oh+xvRu78j7yJ+V4rVi+09wJxB+QXcwZqc6PJmh+iNzSxkYcNL9ohdK55Dr
	 qQwSCTNUDjgiw==
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
Subject: [PATCH RESEND v2 01/51] alloc_tag: don't remove /proc/allocinfo under the codetag module lock
Date: Wed,  4 Nov 2026 20:06:06 +0100
Message-ID: <20261104-work-procfs-bugfixes-v2-1-021c84d852e0@kernel.org>
In-Reply-To: <20261104-work-procfs-bugfixes-v2-0-021c84d852e0@kernel.org>
References: <20261104-work-procfs-bugfixes-v2-0-021c84d852e0@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
X-Mailer: b4 0.17-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=3465; i=brauner@kernel.org; h=from:subject:message-id; bh=C5Mw1tWGzCvAVdyOdBCkcSqd8MeBZuRbzsUttoDJMVc=; b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWS9bjx9IHaO3wuTJ1+WO4i+5dMLjYtY9+Wvw48Lyxdt2 LlN5/Ib145SFgYxLgZZMUUWh3aTcLnlPBWbjTI1YOawMoEMYeDiFICJHH3KyLB8S3D4hzs35nf3 6kca3bE/MoFXXPH/QrfldyYEbj711Med4b/vz9/V52SPbSoPmzq9udhnRnl3scqhkl1dHNJhZhI 7fLgB
X-Developer-Key: i=brauner@kernel.org; a=openpgp; fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: BF43B20002
X-Stat-Signature: wbedj4psftesituprjfzcyigbqhxwwcu
X-Rspam-User: 
X-HE-Tag: 1793819191-90302
X-HE-Meta: U2FsdGVkX1/C45GQlZ9F0uV2iRoU0CAOd9xUAjUj0YYAc3QRmxkDv5Xh0jo6YLvOs2LTP3aPi8MqdM1sEDMkfL7M/hysEQfp4jbUsWIuZzMAogDEhX+JvO8AlIE/G0tcS4TUdUBSrr00lXfgpzJuXsOrUBt/oSRRZUvMk6M4clHT8hYg2WOd86FP3g9vg3r4vaVICQSRXtPIvYI87BocMrib4e9W5GldPXIcx3CHUk9BDMM/stPm52CSVPrX6gm8uoBAePCdWqECw0f2iYYj/URthj1D3SWCSLpHYa4jcRl4JjN7ovvYXP25n00JlyJwbpkVNKpcyIIgeuOZNWF8bEiAnSONJPNs3r8cKb6jwJnzriOzDRXPfTskuzhTQ7mwqiBM/0qhsxVyt6+FXd+aVUoMg66xDmUd3Dozhxqt3w8a/vjGLbOftNEFoItfcR/+K+//1XxeXclVCiWkrgTzS7mg3PTlZMiF+5xAHEAQzwMYfMF/jZbrZSjvCIwXEGoB0rqT5IPXDMW/CDPcyl+122om9wwzJBp8aU7ZOkmwnLeyh75605dlMu6Jgy0lKVFqTVl1VzIztVmI5jwug8NQVLL8XgUurhv2W1MKlx4pBF26gtubqfdUxibXGYm+Ov/jxfW4iciyyh9j2RQWH1waFhsYJGTG+JxqOypbMe61FRV9lClLoMz1yVzFwht4/79kQFV+BX1jy7vDPwHA12PK1EDUWmYnxSAPfFtoEPQM2zHOQJg7VLvEsRK9S+8ZPSSCqmw6x7uX/mHfgjQRhKUWfnlBKJHVbIMoGUyxHmtG0+OW/lVZLT28Qv0fG5r1OEu99Kgeq41dmtZ6Io+IdbShxqzMe9PeslNg8k6/E0DZY+vPXfoIssh66lpMeZvSjAnYQVmiSSmNpyLhaDuAYFOUZqXxubd/KERB8CpTobtpdB3CinCZSIJi7vcVpneofO2KXZEDEGjwGdB68N78QcH
 QV9nJogy
 KiVJtMKU2nLGX3LapDUUuKiALEoP7RJrQZtNE+1eWJbvb/1VUkJZn5ekVOwOdEE7I91ezc0BlXrUsGGHHUVSO7GqnazhksE3F0626/VtHB+W2tAjF/ip/sC9P3jPQBJ+aALbDIa8+zuBe0DmANu41e/ZVWGEy/iN4Bbj38SU6M7NoeZwMphji5ePoCtHTqMprDThOlF1charpooY0B2nxmv4noIX1NaLQeTu+dRp/UjNyKKQbgYrOgIRfT+esdMDbysIAhaae3rcj/fEnbnl37np7+v/T5OQL/YMJFUBhREHlvU1qj/utLAVR7Ifio7yjjxJY4kBKZomafiMOyqhSpAMhnig/qHC3aDQLxC019dtDCOUZDafy2z7btHEWizO3smVDDMQ86Ze2k+yRPu7WLGbzrM6kIgB0k5Nx8zMHgePyEFONMmTfeDsxsFlDvPzGIpWkK/v6+sByCExFmRPS8xfspkP95fBXbpTXSXIa4fzK+6A=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

codetag_alloc_module_section() takes the codetag type's mod_lock for
writing and calls reserve_module_tags() with it held. When that can't
reserve the tags, because the section's alignment doesn't fit, because
there are too many tags for the page flag bits or because the memory
for them can't be allocated, it shuts memory allocation profiling down
and removes /proc/allocinfo, still with mod_lock held.

remove_proc_entry() waits until every reader of the entry has let go of
it, and a reader of /proc/allocinfo takes mod_lock for reading in
allocinfo_start() while it holds the entry. So a module load that hits
one of those paths while /proc/allocinfo is being read waits for the
reader and the reader waits for the module load, for good.

Let a work item remove the entry in that case. The profiling is shut
down right away like before, the file just goes a moment later.

Fixes: 4835f747d3ed ("alloc_tag: support for page allocation tag compression")
Cc: stable@vger.kernel.org
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 mm/alloc_tag.c | 27 ++++++++++++++++++++++++---
 1 file changed, 24 insertions(+), 3 deletions(-)

diff --git a/mm/alloc_tag.c b/mm/alloc_tag.c
index 82e2c3448dcf..7d7ad6704953 100644
--- a/mm/alloc_tag.c
+++ b/mm/alloc_tag.c
@@ -15,6 +15,7 @@
 #include <linux/seq_file.h>
 #include <linux/string_choices.h>
 #include <linux/vmalloc.h>
+#include <linux/workqueue.h>
 #include <linux/kmemleak.h>
 #include <uapi/linux/alloc_tag.h>
 
@@ -604,6 +605,26 @@ static void shutdown_mem_profiling(bool remove_file)
 	mem_profiling_support = false;
 }
 
+static void remove_allocinfo_file(struct work_struct *work)
+{
+	remove_proc_entry(ALLOCINFO_FILE_NAME, NULL);
+}
+static DECLARE_WORK(remove_allocinfo_work, remove_allocinfo_file);
+
+/*
+ * A module's tags are reserved with the codetag module lock held for
+ * writing, and a reader of /proc/allocinfo takes that lock with the entry
+ * pinned. Removing the entry there would wait for that reader for good, so
+ * let a work item do it.
+ */
+static void shutdown_mem_profiling_async(void)
+{
+	if (!mem_profiling_support)
+		return;
+	shutdown_mem_profiling(false);
+	schedule_work(&remove_allocinfo_work);
+}
+
 void __init alloc_tag_sec_init(void)
 {
 	struct alloc_tag *last_codetag;
@@ -855,7 +876,7 @@ static void *reserve_module_tags(struct module *mod, unsigned long size,
 		align = 1;
 
 	if (!ensure_alignment(align, &prepend)) {
-		shutdown_mem_profiling(true);
+		shutdown_mem_profiling_async();
 		pr_err("%s: alignment %lu is incompatible with allocation tag indexing. Memory allocation profiling is disabled!\n",
 			mod->name, align);
 		return ERR_PTR(-EINVAL);
@@ -905,14 +926,14 @@ unlock:
 
 		module_tags.size = offset + size;
 		if (mem_alloc_profiling_enabled() && !tags_addressable()) {
-			shutdown_mem_profiling(true);
+			shutdown_mem_profiling_async();
 			pr_warn("With module %s there are too many tags to fit in %d page flag bits. Memory allocation profiling is disabled!\n",
 				mod->name, NR_UNUSED_PAGEFLAG_BITS);
 		}
 
 		grow_res = vm_module_tags_populate();
 		if (grow_res) {
-			shutdown_mem_profiling(true);
+			shutdown_mem_profiling_async();
 			pr_err("Failed to allocate memory for allocation tags in the module %s. Memory allocation profiling is disabled!\n",
 			       mod->name);
 			return ERR_PTR(grow_res);

-- 
2.53.0



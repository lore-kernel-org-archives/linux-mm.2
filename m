Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1197C608BC65
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 19:46:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=JLlSIaOO
Received: by kanga.kvack.org (Postfix)
	id 0EBD46B05B9; Wed,  4 Nov 2026 14:46:12 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0C3AF6B05BD; Wed,  4 Nov 2026 14:46:12 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F1C4C6B05BF; Wed,  4 Nov 2026 14:46:11 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D0AAD6B05B9
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 14:46:11 -0500 (EST)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 5DFD0805AF
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 19:46:11 +0000 (UTC)
X-FDA: 85398467742.14.F6A0AC2
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf07.hostedemail.com (Postfix) with ESMTP id 9306E40003
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 19:46:09 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=JLlSIaOO;
	spf=pass (imf07.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793821569;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kxjspy9ZL+8t9BkjE4oKOSwNeWEzIszQIFkvCyGQz+s=;
	b=6s22hyiqvyaU8ZdDL78OA/R2x4wnhobDQTGPlo7lTE7hzts8sO28uwKL49DZJTNa+joDsL
	rgNRCTFPmjaGeOpc/Vng2033bTGTCJxoXELYOzGr/Ef3R04dtsw03j/YJXRos0GCPKsAHW
	TmZbQdTK8gBvBbeiDc2fkvGrWr4Yy/A=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793821569;
	b=gusuVJrewTyMrFEGYdUkMMqafuMAVAbKW765Tty72m5k98JpnG7Af9afoYNc/bgJRtWxxL
	tPB1zRgLyYKRStTkVaDZFtLRq9JTXWu4Wc6AepsjL0/Fef8UPT5D43rj3iiy4UCxh65iUv
	qHTeacxB18SPyOJlsHdgtUkPsa2f24A=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=JLlSIaOO;
	spf=pass (imf07.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id D3D0D410B4;
	Wed,  4 Nov 2026 19:46:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65D6C1F0093A;
	Wed,  4 Nov 2026 19:45:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793821568;
	bh=kxjspy9ZL+8t9BkjE4oKOSwNeWEzIszQIFkvCyGQz+s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JLlSIaOOfmwiRkeMfAeymPb8iqZ5kInrVHmUVrnnSNEg7lKvYgz5ntp2noxoE0tcJ
	 l5uTCQ7sZmy2Suvt1hJw0D93TFqGQt7g7UN9fx3rFBYNz5jEhGOHAzzDl/HKKcMF7y
	 bPv0idsK5N6TZfoeMHd8ziRguD5j+3OotTsy+8cQCJdsD1QGkEdzpqbTwliR57Yc3V
	 fxjs3NO+XnhCmM3pFy8SWEJgMTtwqv6K2if/idg3x3m7xWzW6qCp+g2LXXBf9Og+g0
	 Ua4thEtjj8fCnZQWbaPMAdEd00vW84we0g2UYCi2t1dBmB5PG3+uFhf7hHN8zgxJsf
	 e0J4kSxqElnkQ==
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
Subject: [PATCH RESEND v2 15/26] scsi: esas2r: let procfs copy the ioctl argument of the ATTONode file
Date: Wed,  4 Nov 2026 20:45:54 +0100
Message-ID: <20261104-work-procfs-drivers-v2-15-245e54e87116@kernel.org>
In-Reply-To: <20261104-work-procfs-drivers-v2-0-245e54e87116@kernel.org>
References: <20261104-work-procfs-drivers-v2-0-245e54e87116@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
X-Mailer: b4 0.17-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=7201; i=brauner@kernel.org; h=from:subject:message-id; bh=8l1z/REgMAV+eMaktVeRDOA8Z1xa02Gmz6227ra7RCg=; b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWS97mqdmnho4rGIo0E99Z2KN122Xz6mVdWe4x8723LZu YbCPfs5O0pZGMS4GGTFFFkc2k3C5ZbzVGw2ytSAmcPKBDKEgYtTACYSf4CRYaOrxDlfxfOr+fIS TrSXHDvi2tTxqfj0PI+ZL6/JL+L3/crw3y9OLNn7yTulZy2MG07VmdU2mhj797PMstYzMkwvW7+ ACQA=
X-Developer-Key: i=brauner@kernel.org; a=openpgp; fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 9306E40003
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-Stat-Signature: w7m43asxxie4bjx971owek1b44uadwo8
X-Rspam-User: 
X-HE-Tag: 1793821569-168923
X-HE-Meta: U2FsdGVkX1/llL8o1hRmvU7SG2Hq6vYp5GbV6yFlMsG8YrzBrP5EsxakfeI0Ga5JJVnpnA4yEtxZjLhus5W64aW8iLun7pLpMkh7eWFsE2yQo6fPFLMmhCDecuWCcDmCmSkaU0+X5QOrjV0ShEhmFS7RbeA5uygQ13oCf+vnTbr9weflLRH/EOa5cnrx7ZDWVdtK5XIOAsu7mUtxWEsg4Ln+jHuL7iAI+npRM01/L8Do5ADHbVuH9Och54/AxyMYX8rF/7CCe4DlKPYCbjjFpS06AYx65T0ciikEeNy4lW7K2467NWQOoBQyQzOmm55WmAhzfJ2e3/wSHMsgtSUZoXMabBPSZcPlpKnZUROBha0dlJDx0885q0lVx22f8Kla4EGXAeiXAf0IhF6Ql6HL5kJEhOT4R2vhOWqBP8UPn/XM4wlMgA2etm1y4LIDpHHFdBm/YPzlpIpLxBx6Geo26srUmLuhw8ejiXTu2iKjBU2u+NcGszZPwCOle6E2vaYpB/9b2DDxTnWMSGJrTtWoLhs7lDpM7wNyqaiXOy1dPgvF+rBkceEr1exOGCY9BfzF/qd1QNVbOZvuQdRmpXAtvsaZRj2PKz11vjiq0KqIrTJRpT+SLQOUZLBtJ44HkPkdQFLODGhzezyqDWVFl40uCapang1xr8Bqthp/vxRcdiO5D6Y07k2Y08+F5pBcR/lrXmRc4nRrDf81CDxKeLI7IlKG5h/o6kZ4JtygUV8GZ9m1MawMwIXpQFlZd0qrJ1rtphBhAPTW8ji7HsvUrUVBxsW5zhR7E40EQlUzFEE1x3E+QM8fjTrKStwwSd0Lfr9VQpzFNujKQSZ15Lwv+lkulM29/yfNaRnjWB2i+2HPEXRy9sN4u0ZLK4FM+rq2A40Ab6iPhPv8DJMPhyWoQMKldMsw5DVEm2s99Mt+3aH+aYtu9y9f1Wj7gTpoklImFf+1FaC+T8Wo9fjlriR4sVN
 aqs+Fa1R
 pO4RvxqnrJecVutX2W8SIEamWcuJ5EnrpkS91I6eP5o4E4pU13J8SU4vaer5m9UWcHZnMB+6goUJ2vFnwXfwEgrbwnATFxhUyTGVuhKhtaaIG8aRG1mV5aLEfHsrUNvbIKmKh7Om85izvBhPzM81QFj8S76HdGhZwUdytFHAndY0p27szIe46+hutRu5UHITouX2Pv60sJDHiHEwjReBcrzu2Zu4hh3qXFj6uWOD6YA+y2pjS0+QmqBkpBeVlonu2TATGDIk4qK4dhk06hKhvgiOFD4lkIGBHOjZMz587uZsiF90g6AtJzyUWOGz88dJuiShjNzicn09gA3ANiVsI3hBDOpzrjEra/RCQTwlhD8WHw2OhuFBDXoW8QARV92OgbeYy+xvoNHC4XWFSvil644o8rg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Move the work of esas2r_ioctl_handler() into esas2r_ioctl_buf() which
works on a kernel copy of struct atto_express_ioctl. The SCSI ioctl and
the character device keep copying in and out in
esas2r_ioctl_handler().

The procfs file implements ->proc_ioctl_buf() with esas2r_ioctl_buf()
and lists every command from EXPRESS_IOCTL_MIN to EXPRESS_IOCTL_MAX, so
procfs copies the struct in before it pins the entry and back out after
unpinning it. Commands outside of that range fail with -ENOTTY instead
of -ENOTSUPP now, a NULL argument with -EFAULT.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 drivers/scsi/esas2r/esas2r.h       |  2 ++
 drivers/scsi/esas2r/esas2r_ioctl.c | 58 ++++++++++++++++++++++----------------
 drivers/scsi/esas2r/esas2r_main.c  | 44 +++++++++++++++++++++++------
 3 files changed, 72 insertions(+), 32 deletions(-)

diff --git a/drivers/scsi/esas2r/esas2r.h b/drivers/scsi/esas2r/esas2r.h
index 10101f50b282..4d75b8adbb3b 100644
--- a/drivers/scsi/esas2r/esas2r.h
+++ b/drivers/scsi/esas2r/esas2r.h
@@ -964,6 +964,8 @@ struct esas2r_adapter {
 const char *esas2r_info(struct Scsi_Host *);
 int esas2r_write_params(struct esas2r_adapter *a, struct esas2r_request *rq,
 			struct esas2r_sas_nvram *data);
+int esas2r_ioctl_buf(void *hostdata, unsigned int cmd,
+		     struct atto_express_ioctl *ioctl);
 int esas2r_ioctl_handler(void *hostdata, unsigned int cmd, void __user *arg);
 int esas2r_ioctl(struct scsi_device *dev, unsigned int cmd, void __user *arg);
 u8 handle_hba_ioctl(struct esas2r_adapter *a,
diff --git a/drivers/scsi/esas2r/esas2r_ioctl.c b/drivers/scsi/esas2r/esas2r_ioctl.c
index 80ae5b9d45db..901c5d40cda8 100644
--- a/drivers/scsi/esas2r/esas2r_ioctl.c
+++ b/drivers/scsi/esas2r/esas2r_ioctl.c
@@ -1279,37 +1279,25 @@ int esas2r_write_params(struct esas2r_adapter *a, struct esas2r_request *rq,
 }
 
 
-/* This function only cares about ATTO-specific ioctls (atto_express_ioctl) */
-int esas2r_ioctl_handler(void *hostdata, unsigned int cmd, void __user *arg)
+/*
+ * This function only cares about ATTO-specific ioctls (atto_express_ioctl).
+ * @ioctl is a kernel copy of what the caller passed. It goes back to the
+ * caller unless this fails.
+ */
+int esas2r_ioctl_buf(void *hostdata, unsigned int cmd,
+		     struct atto_express_ioctl *ioctl)
 {
-	struct atto_express_ioctl *ioctl = NULL;
 	struct esas2r_adapter *a;
 	struct esas2r_request *rq;
 	u16 code;
 	int err;
 
-	esas2r_log(ESAS2R_LOG_DEBG, "ioctl (%p, %x, %p)", hostdata, cmd, arg);
-
-	if ((arg == NULL)
-	    || (cmd < EXPRESS_IOCTL_MIN)
-	    || (cmd > EXPRESS_IOCTL_MAX))
-		return -ENOTSUPP;
-
-	ioctl = memdup_user(arg, sizeof(struct atto_express_ioctl));
-	if (IS_ERR(ioctl)) {
-		esas2r_log(ESAS2R_LOG_WARN,
-			   "ioctl_handler access_ok failed for cmd %u, address %p",
-			   cmd, arg);
-		return PTR_ERR(ioctl);
-	}
-
 	/* verify the signature */
 
 	if (memcmp(ioctl->header.signature,
 		   EXPRESS_IOCTL_SIGNATURE,
 		   EXPRESS_IOCTL_SIGNATURE_SIZE) != 0) {
 		esas2r_log(ESAS2R_LOG_WARN, "invalid signature");
-		kfree(ioctl);
 
 		return -ENOTSUPP;
 	}
@@ -1350,7 +1338,6 @@ int esas2r_ioctl_handler(void *hostdata, unsigned int cmd, void __user *arg)
 			esas2r_adapters[ioctl->header.channel] == NULL) {
 			ioctl->header.return_code = IOCTL_BAD_CHANNEL;
 			esas2r_log(ESAS2R_LOG_WARN, "bad channel value");
-			kfree(ioctl);
 
 			return -ENOTSUPP;
 		}
@@ -1403,7 +1390,6 @@ int esas2r_ioctl_handler(void *hostdata, unsigned int cmd, void __user *arg)
 
 		rq = esas2r_alloc_request(a);
 		if (rq == NULL) {
-			kfree(ioctl);
 			esas2r_log(ESAS2R_LOG_WARN,
 			   "could not allocate an internal request");
 			return -ENOMEM;
@@ -1516,19 +1502,43 @@ ioctl_done:
 
 	}
 
+	return 0;
+}
+
+int esas2r_ioctl_handler(void *hostdata, unsigned int cmd, void __user *arg)
+{
+	struct atto_express_ioctl *ioctl __free(kfree) = NULL;
+	int err;
+
+	esas2r_log(ESAS2R_LOG_DEBG, "ioctl (%p, %x, %p)", hostdata, cmd, arg);
+
+	if ((arg == NULL)
+	    || (cmd < EXPRESS_IOCTL_MIN)
+	    || (cmd > EXPRESS_IOCTL_MAX))
+		return -ENOTSUPP;
+
+	ioctl = memdup_user(arg, sizeof(struct atto_express_ioctl));
+	if (IS_ERR(ioctl)) {
+		esas2r_log(ESAS2R_LOG_WARN,
+			   "ioctl_handler access_ok failed for cmd %u, address %p",
+			   cmd, arg);
+		return PTR_ERR(ioctl);
+	}
+
+	err = esas2r_ioctl_buf(hostdata, cmd, ioctl);
+	if (err)
+		return err;
+
 	/* Always copy the buffer back, if only to pick up the status */
 	err = copy_to_user(arg, ioctl, sizeof(struct atto_express_ioctl));
 	if (err != 0) {
 		esas2r_log(ESAS2R_LOG_WARN,
 			   "ioctl_handler copy_to_user didn't copy everything (err %d, cmd %u)",
 			   err, cmd);
-		kfree(ioctl);
 
 		return -EFAULT;
 	}
 
-	kfree(ioctl);
-
 	return 0;
 }
 
diff --git a/drivers/scsi/esas2r/esas2r_main.c b/drivers/scsi/esas2r/esas2r_main.c
index 75a70ae9441b..720be2a0907d 100644
--- a/drivers/scsi/esas2r/esas2r_main.c
+++ b/drivers/scsi/esas2r/esas2r_main.c
@@ -613,14 +613,6 @@ static const struct file_operations esas2r_proc_fops = {
 	.unlocked_ioctl = esas2r_proc_ioctl,
 };
 
-static const struct proc_ops esas2r_proc_ops = {
-	.proc_lseek		= default_llseek,
-	.proc_ioctl		= esas2r_proc_ioctl,
-#ifdef CONFIG_COMPAT
-	.proc_compat_ioctl	= compat_ptr_ioctl,
-#endif
-};
-
 static struct Scsi_Host *esas2r_proc_host;
 static int esas2r_proc_major;
 
@@ -630,6 +622,42 @@ long esas2r_proc_ioctl(struct file *fp, unsigned int cmd, unsigned long arg)
 				    cmd, (void __user *)arg);
 }
 
+static long esas2r_proc_ioctl_buf(struct file *fp, unsigned int cmd, void *arg)
+{
+	return esas2r_ioctl_buf(esas2r_proc_host->hostdata, cmd, arg);
+}
+
+#define ESAS2R_PROC_IOCTL(_cmd)						\
+	PROC_IOCTL_ARG(_cmd, sizeof(struct atto_express_ioctl),		\
+		       sizeof(struct atto_express_ioctl))
+
+/* esas2r_ioctl_buf() takes every command from EXPRESS_IOCTL_MIN to _MAX. */
+static const struct proc_ioctl_arg esas2r_proc_ioctl_args[] = {
+	ESAS2R_PROC_IOCTL(EXPRESS_IOCTL_RW_FIRMWARE),
+	ESAS2R_PROC_IOCTL(EXPRESS_IOCTL_READ_PARAMS),
+	ESAS2R_PROC_IOCTL(EXPRESS_IOCTL_WRITE_PARAMS),
+	ESAS2R_PROC_IOCTL(EXPRESS_IOCTL_FC_API),
+	ESAS2R_PROC_IOCTL(EXPRESS_IOCTL_GET_CHANNELS),
+	ESAS2R_PROC_IOCTL(EXPRESS_IOCTL_CHAN_INFO),
+	ESAS2R_PROC_IOCTL(EXPRESS_IOCTL_DEFAULT_PARAMS),
+	ESAS2R_PROC_IOCTL(EXPRESS_ADDR_MEMORY),
+	ESAS2R_PROC_IOCTL(EXPRESS_RW_MEMORY),
+	ESAS2R_PROC_IOCTL(EXPRESS_TSDK_DUMP),
+	ESAS2R_PROC_IOCTL(EXPRESS_IOCTL_SMP),
+	ESAS2R_PROC_IOCTL(EXPRESS_CSMI),
+	ESAS2R_PROC_IOCTL(EXPRESS_IOCTL_HBA),
+	ESAS2R_PROC_IOCTL(EXPRESS_IOCTL_VDA),
+	ESAS2R_PROC_IOCTL(EXPRESS_IOCTL_GET_ID),
+	ESAS2R_PROC_IOCTL(EXPRESS_IOCTL_GET_MOD_INFO),
+};
+
+static const struct proc_ops esas2r_proc_ops = {
+	.proc_lseek		= default_llseek,
+	.proc_ioctl_buf		= esas2r_proc_ioctl_buf,
+	.proc_ioctl_args	= esas2r_proc_ioctl_args,
+	.proc_nr_ioctl_args	= ARRAY_SIZE(esas2r_proc_ioctl_args),
+};
+
 static void __exit esas2r_exit(void)
 {
 	esas2r_log(ESAS2R_LOG_INFO, "%s called", __func__);

-- 
2.53.0



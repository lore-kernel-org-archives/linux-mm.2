Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9DACB606F23A
	for <linux-mm@archiver.kernel.org>; Mon,  2 Nov 2026 14:28:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=EUO4pFKl
Received: by kanga.kvack.org (Postfix)
	id C76456B05E1; Mon,  2 Nov 2026 09:28:17 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C4CF66B05E2; Mon,  2 Nov 2026 09:28:17 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B89EE6B05E3; Mon,  2 Nov 2026 09:28:17 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 940DD6B05E1
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 09:28:17 -0500 (EST)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 362AE80112
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 14:28:17 +0000 (UTC)
X-FDA: 85390409034.21.774B66B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf10.hostedemail.com (Postfix) with ESMTP id 5B030C0007
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 14:28:15 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=EUO4pFKl;
	spf=pass (imf10.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793629695;
	b=CICW7z3rxLhyVL19UBf0Lx3KAVmSBbOhHxe44QzOSBr4Rbmd07Hr5cKtFQku5hVPm9YYvo
	6UkbKcRROJVmKuBi6iddlTLr3GG7jdzFBijRSzG/GmcJj6fYQbShIABV5hmS1ASxSYArNL
	K6G4yjGLADpmVve7+3VcKW2C0pWGJN0=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793629695;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1ZOes0sCXeNJHkx8XbBRI4Lha74UqRf0e01UMCXW7Bw=;
	b=JE7di40XYIO/c4/Mu6lTZwpP1KQx6wv3GmtoiKrgaewuEFKn882SPj+yX2c5a2kBEixoFc
	gTZAqz93uuQ6/j/lG61QFeMPAu6WUIMgr6YnaFpWHNkeWUvgWL57lj0aNGg1Ef29qKmmEz
	t/pkT+BOyWLhbeAsdj7/Rbu72kuNjZI=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=EUO4pFKl;
	spf=pass (imf10.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id A831D40F85;
	Mon,  2 Nov 2026 14:28:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1D0D1F00A16;
	Mon,  2 Nov 2026 14:28:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793629694;
	bh=1ZOes0sCXeNJHkx8XbBRI4Lha74UqRf0e01UMCXW7Bw=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=EUO4pFKlhnL5pvQEUCCWvi+78+6q6ZDjIsg25RLdmrCR7DaMvvK7VU6IyXjatgNdA
	 v6HEQdINaxmfpwL2YFS2jHE5mgZGSzD0u2zuKU1c9+C8L4IeSjDRJMsuWNe0QCLWYE
	 HgyuHlkfOpyx10+G5lbOHU8K9XY1lWRM1PLPhSPcCmeOf5pWcbxWRZzIqvBtaEEgcu
	 pLUrAxK6nHoCIsss5clQs1KkJnkGgrrsihUVIBffccQLmDOjMDkbkev4FX0WQJfpGn
	 FiQqi51nTBd2t+6sn7+AKsB+sOUb1ObmcEa84GBOKFz/ycMk49a3RHfimrV1ontC6D
	 8uUxFKZ7AJNfQ==
From: Christian Brauner <brauner@kernel.org>
Date: Mon, 02 Nov 2026 15:21:43 +0100
Subject: [PATCH RFC 28/38] scsi: esas2r: bound the lengths of the HBA, SMP
 and firmware ioctls
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261102-work-procfs-bugfixes-v1-28-59422ed3e465@kernel.org>
References: <20261102-work-procfs-bugfixes-v1-0-59422ed3e465@kernel.org>
In-Reply-To: <20261102-work-procfs-bugfixes-v1-0-59422ed3e465@kernel.org>
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
 Chuck Lever <cel@kernel.org>, stable@vger.kernel.org
X-Mailer: b4 0.17-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=6672; i=brauner@kernel.org;
 h=from:subject:message-id; bh=gYkKA8sDklmz8nTf0EqD2RrY/Q3IBTgyykjWiVDWZYA=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWS9mJPz+N2NHXK/t+en+35gneV78ubBxkVGR/jbO/9sW
 Dbb9di/yx2lLAxiXAyyYoosDu0m4XLLeSo2G2VqwMxhZQIZwsDFKQATkRNhZNimE16dqx5cOOOB
 1nyumpBTfd/0T3+YWsenvUg5fd6+L/wM//N26dx8v26+6gL+G0t3cCusnP/gdPiKe/7rxHbVSdf
 F5fECAA==
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Stat-Signature: pxnt4bygjdh3jb8sn7j8gigqwnuc5csc
X-Rspamd-Queue-Id: 5B030C0007
X-Rspam-User:
X-Rspamd-Server: rspam12
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-HE-Tag: 1793629695-792311
X-HE-Meta: U2FsdGVkX1+uo4i8JE1qf9T019DKBTBOCvwOa5tB25L0SwmPqe6Tgk0b0S0J1N4RaJ4j6VstT2Dav41+TMVfR7MxemBx9Z23uTbXx1ySX/R7/SZaoaMdhx/pVCq055QAE7PPsnrNkMre9ARkx7Xm4G15Guj72vzvj3dAm+mhYUstdK3+2Vt6GDjgthmIvPUmNAo7k8oMl18sNu4fs8NvPvDP8cmNy3hdgef7wR22r3oijVbbk28VbbJ5u3sWHNVggkIj54Gvyd9v6+dGTtaXd5fTxQp+6ytOk8FpbFj3VGE9B6aMsq3Ajd0/nc3HDLonHv5c73iAYK9Bk6d7u9A682poRj4mYexzYd263BErzHXjhGeUZ97taIrXV/He9Wse0xlIA+hurnxmpa/eZ+AyscIlxFhJGpD0iEuiShnGt1qYNbAG0GPLN4OPvf+cHyRVK8Mf+7DOQUC7PsNaI+B8me7xPEq86EgIR2lVHBaPhJTEq36KuIRe38trZhP3ejw2XcaAUkm4ddrhAUVqCWzadTRZ24dYH/f49UrDPrKpcv4KtKtoBqDg/JkUFJCjKcCErWl2GLNxkMuXNE3hrd1eGU154PVkQ49h+WOl0C0W/iUn9QUjWkX3XTMn0+4DpIseAkvu+Ap3X7cttGZ6Di1Q25SXNwzaWu3hxPdIGp9VYhVgEJRN+LiNV3Pi6Wu24zCOEL64t2I+tJae67EsT56kcFbIFpA0zTZ8DMZQ6q1fgvGcXCf7+UC/70IlfecH8JGOSgEpsNUu8OX56frbLp1sQP935ucneWe0GBoNu6l/w7Dgg4B4A0cS+Fn48dRnjmIuneXajBGMX+1/LPfvQ7ABazYaxDWJD2HYEVeCedkAXETcpZUeOvfigfsLMK1U3lW8De+Dzqw5iT9d5K9wYNr4er/B4mV/NFZ6H+yRaZJSXEBROPfmDs3wKtULkFiovTYEBXZ7smKu8qlfA2qlY1a
 ndaW80gs
 tYR3jJFcVOpCTX+M5ygVcG9xbYrny6ibV6MG/P1ogZclGZB0mOAudS1Q2MIPjW7Rv84tHqUrOZktXzMMlZuRpyO8ZVsyV5es0luvaz7B3DwjrRe6i9+KTXE73yrxWsOLNnWRcS5D+XneSjMgOAeQqE2F6p7uti4G4SNM9vFffRMtaFW8s7lT3KoIhJCq8rXcRcXs87EggKstNdVobzGR9u4STSuFe24EjDdbsmOuY96j1by9Kcyoa8Xcnx6zG1JPzsso+sCnGn1SZK1zPhixSnC4FW6NXv5hrr6IYVdLVaZZ0Ck0c/AUO5NAaG4DGUAxbUGB6vZyXw4oXF5k=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

esas2r_ioctl_handler() copies in a struct atto_express_ioctl, a bit over
512k, and hands the union member for the command to the handlers. For
EXPRESS_IOCTL_HBA and EXPRESS_IOCTL_SMP the length of the buffered ioctl
is the size of the member plus lengths that come straight from
userspace:

  bi.length = sizeof(struct atto_ioctl) + ioctl_hba->data_length;

  bi.length = sizeof(struct atto_ioctl_smp)
	    + le32_to_cpu(si->req_length)
	    + le32_to_cpu(si->rsp_length);

handle_buffered_ioctl() copies bi.length bytes from the member into a
DMA buffer and, once the adapter is done, copies the DMA buffer back
over the member. Nothing checks that the lengths fit into the struct
that was copied in. So a large data_length makes it read past the
struct and then write the DMA buffer back over the memory behind it.

The firmware commands pass sizeof(struct atto_express_ioctl) to
esas2r_{read,write}_{fw,fs}() as the length of data.fwrw.image, which
starts 28 bytes into the struct. So they can read and write 28 bytes
past it as well.

The handler is reachable through /proc/scsi/esas2r/ATTONode. It is
created with mode 0, which procfs turns into 0444, and esas2r doesn't
check for a capability anywhere. So any local user can do this on a
machine with such an adapter.

Bound all of these by the room from the member to the end of the
struct. read_hw() passes handle_hba_ioctl() a single struct atto_ioctl
and only ever returns that, so there the data length has to be zero.

Reported-by: Chris Mason <mason@kernel.org>
Fixes: 26780d9e12ed ("[SCSI] esas2r: ATTO Technology ExpressSAS 6G SAS/SATA RAID Adapter Driver")
Cc: stable@vger.kernel.org
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 drivers/scsi/esas2r/esas2r.h       |  2 +-
 drivers/scsi/esas2r/esas2r_ioctl.c | 41 ++++++++++++++++++++++++--------------
 drivers/scsi/esas2r/esas2r_main.c  |  3 ++-
 3 files changed, 29 insertions(+), 17 deletions(-)

diff --git a/drivers/scsi/esas2r/esas2r.h b/drivers/scsi/esas2r/esas2r.h
index a763edd05fe4..10101f50b282 100644
--- a/drivers/scsi/esas2r/esas2r.h
+++ b/drivers/scsi/esas2r/esas2r.h
@@ -967,7 +967,7 @@ int esas2r_write_params(struct esas2r_adapter *a, struct esas2r_request *rq,
 int esas2r_ioctl_handler(void *hostdata, unsigned int cmd, void __user *arg);
 int esas2r_ioctl(struct scsi_device *dev, unsigned int cmd, void __user *arg);
 u8 handle_hba_ioctl(struct esas2r_adapter *a,
-		    struct atto_ioctl *ioctl_hba);
+		    struct atto_ioctl *ioctl_hba, size_t room);
 enum scsi_qc_status esas2r_queuecommand(struct Scsi_Host *host,
 					struct scsi_cmnd *cmd);
 int esas2r_show_info(struct seq_file *m, struct Scsi_Host *sh);
diff --git a/drivers/scsi/esas2r/esas2r_ioctl.c b/drivers/scsi/esas2r/esas2r_ioctl.c
index 3f7c1d131ec3..f99318f61c93 100644
--- a/drivers/scsi/esas2r/esas2r_ioctl.c
+++ b/drivers/scsi/esas2r/esas2r_ioctl.c
@@ -311,17 +311,27 @@ static int smp_ioctl_callback(struct esas2r_adapter *a,
 	return true;
 }
 
+/* The room from @member to the end of a struct atto_express_ioctl. */
+#define EXPRESS_IOCTL_ROOM(member)				\
+	(sizeof(struct atto_express_ioctl) -			\
+	 offsetof(struct atto_express_ioctl, member))
+
 static u8 handle_smp_ioctl(struct esas2r_adapter *a, struct atto_ioctl_smp *si)
 {
 	struct esas2r_buffered_ioctl bi;
+	u64 length = (u64)sizeof(struct atto_ioctl_smp) +
+		     le32_to_cpu(si->req_length) +
+		     le32_to_cpu(si->rsp_length);
+
+	/* The request and the response follow @si in the same buffer. */
+	if (length > EXPRESS_IOCTL_ROOM(data.ioctl_smp))
+		return IOCTL_INVALID_PARAM;
 
 	memset(&bi, 0, sizeof(bi));
 
 	bi.a = a;
 	bi.ioctl = si;
-	bi.length = sizeof(struct atto_ioctl_smp)
-		    + le32_to_cpu(si->req_length)
-		    + le32_to_cpu(si->rsp_length);
+	bi.length = length;
 	bi.offset = 0;
 	bi.callback = smp_ioctl_callback;
 	return handle_buffered_ioctl(&bi);
@@ -1221,11 +1231,16 @@ static void hba_ioctl_done_callback(struct esas2r_adapter *a,
 	}
 }
 
+/* @room is the size of the buffer that starts with @ioctl_hba. */
 u8 handle_hba_ioctl(struct esas2r_adapter *a,
-		    struct atto_ioctl *ioctl_hba)
+		    struct atto_ioctl *ioctl_hba, size_t room)
 {
 	struct esas2r_buffered_ioctl bi;
 
+	/* The data follows @ioctl_hba in the same buffer. */
+	if (ioctl_hba->data_length > room - sizeof(struct atto_ioctl))
+		return IOCTL_INVALID_PARAM;
+
 	memset(&bi, 0, sizeof(bi));
 
 	bi.a = a;
@@ -1349,31 +1364,27 @@ int esas2r_ioctl_handler(void *hostdata, unsigned int cmd, void __user *arg)
 			err = esas2r_write_fw(a,
 					      (char *)ioctl->data.fwrw.image,
 					      0,
-					      sizeof(struct
-						     atto_express_ioctl));
+					      EXPRESS_IOCTL_ROOM(data.fwrw.image));
 
 			if (err >= 0) {
 				err = esas2r_read_fw(a,
 						     (char *)ioctl->data.fwrw.
 						     image,
 						     0,
-						     sizeof(struct
-							    atto_express_ioctl));
+						     EXPRESS_IOCTL_ROOM(data.fwrw.image));
 			}
 		} else if (ioctl->data.fwrw.img_type == FW_IMG_FS_API) {
 			err = esas2r_write_fs(a,
 					      (char *)ioctl->data.fwrw.image,
 					      0,
-					      sizeof(struct
-						     atto_express_ioctl));
+					      EXPRESS_IOCTL_ROOM(data.fwrw.image));
 
 			if (err >= 0) {
 				err = esas2r_read_fs(a,
 						     (char *)ioctl->data.fwrw.
 						     image,
 						     0,
-						     sizeof(struct
-							    atto_express_ioctl));
+						     EXPRESS_IOCTL_ROOM(data.fwrw.image));
 			}
 		} else {
 			ioctl->header.return_code = IOCTL_BAD_FLASH_IMGTYPE;
@@ -1441,9 +1452,9 @@ int esas2r_ioctl_handler(void *hostdata, unsigned int cmd, void __user *arg)
 		break;
 
 	case EXPRESS_IOCTL_HBA:
-		ioctl->header.return_code = handle_hba_ioctl(a,
-							     &ioctl->data.
-							     ioctl_hba);
+		ioctl->header.return_code =
+			handle_hba_ioctl(a, &ioctl->data.ioctl_hba,
+					 EXPRESS_IOCTL_ROOM(data.ioctl_hba));
 		break;
 
 	case EXPRESS_IOCTL_VDA:
diff --git a/drivers/scsi/esas2r/esas2r_main.c b/drivers/scsi/esas2r/esas2r_main.c
index ada278c24c51..75a70ae9441b 100644
--- a/drivers/scsi/esas2r/esas2r_main.c
+++ b/drivers/scsi/esas2r/esas2r_main.c
@@ -178,7 +178,8 @@ static ssize_t read_hw(struct file *file, struct kobject *kobj,
 	if (!a->local_atto_ioctl)
 		return -ENOMEM;
 
-	if (handle_hba_ioctl(a, a->local_atto_ioctl) != IOCTL_SUCCESS)
+	if (handle_hba_ioctl(a, a->local_atto_ioctl,
+			     sizeof(struct atto_ioctl)) != IOCTL_SUCCESS)
 		return -ENOMEM;
 
 	memcpy(buf, a->local_atto_ioctl, length);

-- 
2.53.0



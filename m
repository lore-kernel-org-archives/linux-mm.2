Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 80A826086B95
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 19:26:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Fe+qeY3o
Received: by kanga.kvack.org (Postfix)
	id B275F6B05C8; Wed,  4 Nov 2026 14:26:19 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AFE0C6B05DD; Wed,  4 Nov 2026 14:26:19 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A14326B05DE; Wed,  4 Nov 2026 14:26:19 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 7D7AE6B05C8
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 14:26:19 -0500 (EST)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 2ADDD1A0769
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 19:26:19 +0000 (UTC)
X-FDA: 85398417678.11.783C219
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf06.hostedemail.com (Postfix) with ESMTP id 621C5180004
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 19:26:17 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Fe+qeY3o;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793820377;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XnpcpCSyDLdfO+af8k17UBoE0jHP5SM09VNPrTlP5mU=;
	b=fQRu823+xu+mY4q6JLMjADpa0Vh3hwvzK5J/grCrt53hPU0H5D+YywxkDqs9JnNTFv2EL/
	BmIk5CyWA1z013x6Rfx6vvJtRqVzaxoov/DEIO0EuwlTHZTIw4hdxycDN6sSONd48dNfq1
	2g5sxHkB+h8rbrOPM6i/gNydWtecZ/U=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793820377;
	b=FiFFjV47+TPJ8CtNeelk+NaFlkdTumHeIpSClVyllwtfV/ETkPPFyxHcY/e6lMnxqkfZZ0
	awLvWcNEzmzFVp6dYcWXgnAQyEB0/R/cKZ0V1b+5+TxXJjTWV6S3hA06zClkFNbL+HOHAX
	qxilLDkpAltaWf3iepUiptJuLfUH5eA=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Fe+qeY3o;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id B006840F5F;
	Wed,  4 Nov 2026 19:26:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72DAD1F000C1;
	Wed,  4 Nov 2026 19:26:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793820376;
	bh=XnpcpCSyDLdfO+af8k17UBoE0jHP5SM09VNPrTlP5mU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Fe+qeY3o8miJBk7XZvXWRPJiLnP1GdJPOqLtWaz6J/8VQem5/V0ND1YF0y/caRLDt
	 DgMyPqaYb8QP/iR50E51P8bLvmgXDHfJQAP+4NJ3uCNVkwg8J4gXwnwNVy6o82qXxc
	 G4M//wQeR0/W9Y+xsP86unflMsj2VnJzFCD6/c4qwO8PIZgOw5+bi09ifndSMUg6Pu
	 SBcZj+IhaDAR0z3bc6SfeGcPmjQvgoRYlFKz/iKxUED/8QkGs8uB9cNmos93pL495J
	 NXdA035THee9lHe8V5hdzJBAPFs5jWlBFKpe5bzr3vs+R1j21omP9eJIItBPXuLVUe
	 AfP65GL9MMizQ==
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
Subject: [PATCH RESEND v2 41/51] scsi: esas2r: bound the lengths of the HBA, SMP and firmware ioctls
Date: Wed,  4 Nov 2026 20:26:02 +0100
Message-ID: <20261104-work-procfs-bugfixes-v2-41-021c84d852e0@kernel.org>
In-Reply-To: <20261104-work-procfs-bugfixes-v2-0-021c84d852e0@kernel.org>
References: <20261104-work-procfs-bugfixes-v2-0-021c84d852e0@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
X-Mailer: b4 0.17-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=6672; i=brauner@kernel.org; h=from:subject:message-id; bh=2aMnK188zalc9NOhuhHvIjnHW4mP6VOaoGggC08Jevg=; b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWS9bvw38ZaPqVai5VQBfePvMdFLldYLB/4OlJ7R5jbN+ cnWF7WVHaUsDGJcDLJiiiwO7Sbhcst5KjYbZWrAzGFlAhnCwMUpABNx2czIcNZ6Tv0XfyY9Wfn1 Dz4wh21XeGn22GPftdT+xljFz2cVORkZNr9fFHrlp67vsf/hjvXt0SfXTw4XF5NakZJvybXowMa J/AA=
X-Developer-Key: i=brauner@kernel.org; a=openpgp; fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 5bnmkse8n55a4xzktjw9tek8bidgm644
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 621C5180004
X-HE-Tag: 1793820377-212273
X-HE-Meta: U2FsdGVkX19GlFKKwv6Hlc9gmMdPyaJeMNuvEikb0Ebr6x8Y+lyV8KDEJm2yA+6W0K+DpoeYNfhzqsWflUhdzqJvxmZOZ1Zfy2jTlBERKJBlwV4+ekeL1d64Ni1jS+P7tID/tpAMPCILv3waJJE/lI0dCZEMHDk+4/TQiwKMVLzQcw8pYhQ0mW4TZ6WMbTYPjVz8kHDOg4xEmyr7lfG+NygabsWV5s8OXitcC578vTohuR8OVCnqkkLFM6l/16WIVpjNnNWToRDAeGz6Iq6lGH7II6IfKCv2a06zrQuJQR1HAMvquVSka0tveVeJ1dweYqzvxfOxdkqXF2rrVRMd7vYfel8+bb8D8LU6B09j7La5SLgH7qF6Ke/nuHFPeZYK7R9MhkF6rrRe4o7gygnl4c6IXquad/DQ18l8lpYiLcIWvp0Ev2RDSauBX9xe7TzMFHtMJ/NyrJgYcVNf5BkTAmg6nb1Ih+6UI2uGB9kpGtwQlUL85KlQFy015xu1qNUMQFMyOhTTr8aUARKqo3Nvf5XgjTiCYaRq2zuFdPvi5TqMvw6WqYnPHanFMkBFJIBojkIRh9p++vGMGHxdPJVSD/0P9hghG/czckFBxQesCjZU1c8JpudCv/nv5uycpZMFu8aJEsDnPRzf8bxBDSIYdHcLh8Kxn8n9Pk72JM4YGsap8EqgRfq+pms3e5WWXsrVzd7tXGeZeEiDHO5/D8H2Mn5PgGPuVq2yOF3HdJoAoWxPUufflykHRRVgvUVdZX+7oorj9ZBkVukdjesEWnAoD/4ksKzsMeTEFno4rmFXmaZMZXMzqUVledchpFNI6BByjeUVr02c+aKgMO9/KO/bypJSIaL45NCi1w+UTYUaL2HTPAZzLPvk/vuck+tZDGFDLIo8cOLWEJa9CDc1UY26msZJn30GwXnaESqV+s6vLlO95aRrfDDk5eiFzhaKknA3pRfwNGrJY6QPv7/0BdB
 xbvc3o2N
 k/HCS26cuZaCrxwjxVEtvpwlJBy38IWJcEY7iIBoegIU54grxzxoksDnlmMutfyuyI2n6qNRzjn+yACjkNvpjhGWmFa4GIBxsXB8dSYV082ojipHPDuUcoxuipsUWHA4bWynv2VLniZlUSv2PuLWKPgvooYHv18+at+jSbQuPCUmM5cNTznObwO+gkYkchF0DkO/XGF55msMcDQm8OnGDgoUpGwPiOWA7/a7SpxhX9EUV4rNpGhZeV8dUKVChpx3KeGID+Am0bAEVc4//U/lzetSNnMomJZSvBQFWfJkqMBjV+p5s2HOODcIpnGXL7KetYkt5LPR9sgmflo6rdCfAGlf+g1n0UaDjtFFIFmilc7Y0C66VnYZkVsZgH2QTNgQdqcz++X+LO/KkWZNMN7YASV6Mvw==
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
index c93d9265e100..80ae5b9d45db 100644
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



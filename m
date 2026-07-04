Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 305D0C43458
	for <linux-mm@archiver.kernel.org>; Sat,  4 Jul 2026 06:13:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E61176B00B8; Sat,  4 Jul 2026 02:13:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E12806B00B9; Sat,  4 Jul 2026 02:13:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D29056B00BA; Sat,  4 Jul 2026 02:13:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A0CA56B00B8
	for <linux-mm@kvack.org>; Sat,  4 Jul 2026 02:13:49 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 0A5361C05D0
	for <linux-mm@kvack.org>; Sat,  4 Jul 2026 06:13:49 +0000 (UTC)
X-FDA: 84950078178.07.8F93140
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf11.hostedemail.com (Postfix) with ESMTP id 6CD5D40002
	for <linux-mm@kvack.org>; Sat,  4 Jul 2026 06:13:47 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=XGAx5kJm;
	spf=pass (imf11.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783145627;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pNftAvQH16BxWBwtuSfq3FcInYIuCbQ6Q+AZs1Wj1sE=;
	b=LlTqgHxEbn2FoUp6Y5SMPnfMHY4IpVxexv/4Hc9lfo29BYhad8rSOE6hXlUTAhmJsdguId
	HiEhOca/aF+P1qXtgCCBzteFvbQ5PAgZfjbQw8KhTCg9PClGyWrq/Batfy+Wf42fktEoYl
	oxty7jDGgNQF7aE4JJZRQKRRKL1VPek=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=XGAx5kJm;
	spf=pass (imf11.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783145627;
	b=ofFM2qdMFFj74HOvZmidjUnK0bbKHuSe6R67zJJSKNGl4RtEhBQEUVv+HzTBJeKVujYiqh
	m5u1MAFcuKYlnM1mImClitlLGjhx4bvYcVcBslUk5+el0nGwpPtbAvpnqd8ZpxQn09FlBl
	QlPdlQyjkjA7JhwJQXTlLZAeO7vCjgU=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 08F2C600D8;
	Sat,  4 Jul 2026 06:13:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0C761F000E9;
	Sat,  4 Jul 2026 06:13:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783145626;
	bh=pNftAvQH16BxWBwtuSfq3FcInYIuCbQ6Q+AZs1Wj1sE=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=XGAx5kJmUB4VL+ROOnL0Mh3YYqtNNPySMYBqPBhIv3rySooDU1qGodkCJXr9b2DPS
	 f/V/E8vc8bTe5gicdg5AYZqdqQCOF9ZCjXnF3dC3iER2Y/Awl/Ft9Ni5ZoQdVW8AuY
	 kbYtGVhO2+1ezoaNvfYFH26nqRbkqYL7DTCVcYpDmimBoABCj7YlGEjMX27wz0YBlB
	 c2J/5rxUOHvCLtplPC1hAKkC0QahdJSwcGELBALkujtylmQQkOZ2s+6UcacaZutIoL
	 ZLoiJpv+tbeKPu/qVGCVCu25ELXyvq1u/ewknzu0oeGVUIJyIekbRC6sJBV8vPIpoH
	 SqYPEpUjVlCHQ==
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Date: Sat, 04 Jul 2026 09:13:35 +0300
Subject: [PATCH v2 2/4] scsi: proc: use kmalloc() in proc writers
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260704-b4-scsi-v2-2-7d2d21a810de@kernel.org>
References: <20260704-b4-scsi-v2-0-7d2d21a810de@kernel.org>
In-Reply-To: <20260704-b4-scsi-v2-0-7d2d21a810de@kernel.org>
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Brian King <brking@us.ibm.com>, Hannes Reinecke <hare@suse.com>, 
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>, 
 Matthew Wilcox <willy@infradead.org>, Mike Rapoport <rppt@kernel.org>, 
 Wen Xiong <wenxiong@linux.ibm.com>, linux-kernel@vger.kernel.org, 
 linux-mm@kvack.org, linux-scsi@vger.kernel.org, 
 target-devel@vger.kernel.org, Hannes Reinecke <hare@kernel.org>, 
 John Garry <john.g.garry@oracle.com>
X-Mailer: b4 0.16-dev
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 6CD5D40002
X-Stat-Signature: 8mnun46s5phatfi4imxwf4kpcehpxhfk
X-HE-Tag: 1783145627-604982
X-HE-Meta: U2FsdGVkX18OUKx/2vgPisx6owgyailJyAgfnqtyJujVtLRXjum1WhUNAKaEtgL2uD9oBl5SQolWG2UmaOaue5+D4GhjrDty/t59nq+SQcFmEiwpuVOUEGx7jNGx25gm+kR/90Ewzlxz2viPhwBoRIM5Hyjekzz2p22KiWyZRT9aXCYLaN8LaRez3Qmjuir1qHN7iKuovjaJouBPlV6xqW+2bteZDLk96BXys+U9BzQKS3TybYpyIQdcrIBc2B46kHboTvyCofKzOGp5JHndbKxj3/nlVeNTZQzoKWrqDxEMZpcHVmQFYKuDpCTOZp3r6Ij53W7q7fWaDkd9/k/0NzDPbpuc9wcPgmhn2p4Mdm8MS+KG5u6zfLUofAyr3cn7KhZH83AbC0qf9vax1uOmKHMbB6RGpYZyvX6mtA98JFBBRNJw5WOBIhywek5zEItlp4vDJsPKWddoUjVpvu1Ts3dOe29/zFOE5bjJLYSbMY1GYy//d6X61d/wGpRf1oBvOba/RyK2taJ6BpQeqMNWrFS4z3lwutyKbbHqplyqkI0fkSPjBlHg1Ta5BZOgkBLwO7WW+CnaPI6DCTXsW9sodx869DXkFF4BG2QLkZd0lVXj5VxZOOPzhDxZTeKF40yoSQOwHQDB4Ges+gWo9HMreIxxUvS66ndKzAin2nxvnOLxb4hLCv4de7NGM112u4Zyb9t8YRi0iMTn4D48j+reWzYji9N6XBrBWUhAA0bVctYVDenPgfR4B0gtzhd5lQJNxDlIZvPPrGSZ6xJa8di3QmVnG0BUtmI17jgRtf71egdZX8IODnNMlk82gdFw2YmlOOGoWSrLR2Vcd13u3/Z0f1wGeuyqqqx/3aa6xQFiouOJwyo49ksje3JSbrAGupgZ8PD9JFBMkFaoR33yfZHC52u7X2r6J7RtVSAXozsncehCloB1p8UNl4d1pF7BwQqwTLpAwfjLI1RGAYD2Hb5
 Z1LjOZPN
 llO3XByLY2HXuMXM92BsidxOVP762h36uhT2FmhYw8os5uzXQfpt3V+1r/mATqZi80OlHuUSk438ML7MZqEet7IsT+eduKsACnLSkFtaHxQP1qaWq5USrhdnUNlT63eTPFmtec9uC3nO+a76UsPAKuTRc+s///oME+EZFkKDrmKwRqRDCAYReqUfjP64kqGJsil+fN1cqZUKrrYF15DPcz+htCnr4cOqKZB/mw2q+P+yZ2iW3xR2YLyBMqxAOUbbPlufnGqU5yBEuNNXimucItJ3uWyjZfc9ma4lqdyw+m4PKHQrK8nIN1X/oErIJAjEWC118738inxSdiS/SjEb0ohVywfmWhQ9e5+AkIkqkjKxUGHPl6t3oBCLteg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

proc_scsi_host_write(), proc_scsi_write() and proc_scsi_devinfo_write()
allocate temporary buffers for /proc writes using __get_free_page().

These buffers can be allocated with kmalloc() as there's nothing special
about them to go directly to the page allocator.

kmalloc() provides a better API that does not require ugly casts and
kfree() does not need to know the size of the freed object.

Replace use of __get_free_page() with kmalloc().

Link: https://lore.kernel.org/all/635405e4-9423-4a25-a6e7-e03c8ea0bcbe@redhat.com
Reviewed-by: Hannes Reinecke <hare@kernel.org>
Reviewed-by: John Garry <john.g.garry@oracle.com>
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 drivers/scsi/scsi_devinfo.c | 5 +++--
 drivers/scsi/scsi_proc.c    | 9 +++++----
 2 files changed, 8 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/scsi_devinfo.c b/drivers/scsi/scsi_devinfo.c
index 15ffbe93ac72..2bccadf4f22f 100644
--- a/drivers/scsi/scsi_devinfo.c
+++ b/drivers/scsi/scsi_devinfo.c
@@ -691,7 +691,8 @@ static ssize_t proc_scsi_devinfo_write(struct file *file,
 
 	if (!buf || length>PAGE_SIZE)
 		return -EINVAL;
-	if (!(buffer = (char *) __get_free_page(GFP_KERNEL)))
+	buffer = kmalloc(PAGE_SIZE, GFP_KERNEL);
+	if (!buffer)
 		return -ENOMEM;
 	if (copy_from_user(buffer, buf, length)) {
 		err =-EFAULT;
@@ -708,7 +709,7 @@ static ssize_t proc_scsi_devinfo_write(struct file *file,
 	scsi_dev_info_list_add_str(buffer);
 
 out:
-	free_page((unsigned long)buffer);
+	kfree(buffer);
 	return err;
 }
 
diff --git a/drivers/scsi/scsi_proc.c b/drivers/scsi/scsi_proc.c
index 1799dcae775c..fdc355d783da 100644
--- a/drivers/scsi/scsi_proc.c
+++ b/drivers/scsi/scsi_proc.c
@@ -28,6 +28,7 @@
 #include <linux/mutex.h>
 #include <linux/gfp.h>
 #include <linux/uaccess.h>
+#include <linux/slab.h>
 
 #include <scsi/scsi.h>
 #include <scsi/scsi_device.h>
@@ -74,7 +75,7 @@ static ssize_t proc_scsi_host_write(struct file *file, const char __user *buf,
 	if (!shost->hostt->write_info)
 		return -EINVAL;
 
-	page = (char *)__get_free_page(GFP_KERNEL);
+	page = kmalloc(PAGE_SIZE, GFP_KERNEL);
 	if (page) {
 		ret = -EFAULT;
 		if (copy_from_user(page, buf, count))
@@ -82,7 +83,7 @@ static ssize_t proc_scsi_host_write(struct file *file, const char __user *buf,
 		ret = shost->hostt->write_info(shost, page, count);
 	}
 out:
-	free_page((unsigned long)page);
+	kfree(page);
 	return ret;
 }
 
@@ -412,7 +413,7 @@ static ssize_t proc_scsi_write(struct file *file, const char __user *buf,
 	if (!buf || length > PAGE_SIZE)
 		return -EINVAL;
 
-	buffer = (char *)__get_free_page(GFP_KERNEL);
+	buffer = kmalloc(PAGE_SIZE, GFP_KERNEL);
 	if (!buffer)
 		return -ENOMEM;
 
@@ -467,7 +468,7 @@ static ssize_t proc_scsi_write(struct file *file, const char __user *buf,
 		err = length;
 
  out:
-	free_page((unsigned long)buffer);
+	kfree(buffer);
 	return err;
 }
 

-- 
2.53.0



Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2627ACC6B19
	for <linux-mm@archiver.kernel.org>; Tue, 13 Oct 2026 16:26:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 775EA6B0099; Tue, 13 Oct 2026 12:25:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 74D7D6B009D; Tue, 13 Oct 2026 12:25:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6158C6B009B; Tue, 13 Oct 2026 12:25:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 313BC6B0098
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 12:25:46 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id A2960A8C56
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 16:25:42 +0000 (UTC)
X-FDA: 85318128924.28.4E4C9C4
Received: from mail-pl1-f199.google.com (mail-pl1-f199.google.com [209.85.214.199])
	by imf27.hostedemail.com (Postfix) with ESMTP id EAAC34000A
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 16:25:40 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=YKTWO9CG;
	spf=pass (imf27.hostedemail.com: domain of 3g1vOaggKCNAz8wF7wy62AA270.yA8749GJ-886Hwy6.AD2@flex--dmatlack.bounces.google.com designates 209.85.214.199 as permitted sender) smtp.mailfrom=3g1vOaggKCNAz8wF7wy62AA270.yA8749GJ-886Hwy6.AD2@flex--dmatlack.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791908740;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WNT+jGdaf2aCsQv4VtyLG1DbArni/172oULb9VD6dek=;
	b=WD5R2i1nZ7PtTtv+aNzX+FKeiQfka/qqFTmtU4cBr/0AIC4ralmaUc6mVb2fg1++rjyCrv
	LtvsKwl/a8HLQcl22FA4iUc5b+Ih+67uJQdN24Q8cIvJh6nUczRFRR8wCw18x2sf9bEnLg
	xQQVcht9zJ/kxLM7eaq07mKTc210dsI=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791908740;
	b=eZWQyp0mJVEnqWQD3wZZZIU0Nr/ApvDW3eB5utgWcgnkiONzV3X+HdFHHV79b/I7cRH5dU
	Nnret9jlqwH/jGGnyYFTTPQYWHblog+8Q75XvtEGUofsjOH8owRtX7THvDbSbqegPArosK
	RrrASE4P15Cr+dCbWYOSFUCnrwZJCP4=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=YKTWO9CG;
	spf=pass (imf27.hostedemail.com: domain of 3g1vOaggKCNAz8wF7wy62AA270.yA8749GJ-886Hwy6.AD2@flex--dmatlack.bounces.google.com designates 209.85.214.199 as permitted sender) smtp.mailfrom=3g1vOaggKCNAz8wF7wy62AA270.yA8749GJ-886Hwy6.AD2@flex--dmatlack.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-pl1-f199.google.com with SMTP id d9443c01a7336-2e80f7acc67so33198115ad.2
        for <linux-mm@kvack.org>; Tue, 13 Oct 2026 09:25:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1791908740; x=1792513540; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=WNT+jGdaf2aCsQv4VtyLG1DbArni/172oULb9VD6dek=;
        b=YKTWO9CGP+v2CwR8NVlerEcTggjL34wWk/fcUMldZMx6mKoUiPl7/StTV6F7sx2jUt
         MaQKb3JgbtO3E+wHGB1yz08AaRAoyuQi9pTKAFl838s+zRBg/zDGHKNKTR4L9buBYhAm
         QyR6iVnfzt88jHWkyEtKMeBku1MEU2QSNLkhqzonBrWvSZLiRlAbo1ZdmvEYHzArmXeH
         D1zW98QquWO3MNXQzMfPQqX/GL8zc5BpEybAq8GttjKM7VJd7onr9bm2MPSVRZ95pQge
         1RUp5LFVr9ULSuEI0sauGTIlC/C/qnmc5JXZN7Roo5QCoh+EhE5qTaWQrm4S1kA76nAW
         vMuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791908740; x=1792513540;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=WNT+jGdaf2aCsQv4VtyLG1DbArni/172oULb9VD6dek=;
        b=QM87WLwJn0d9FkG3Ei8nNplmJenIA6rHY2ZOfVLHY6Nb2x1xX4qjEPtciK47UkNEBb
         rU3+3l1mMbzddzwOnGcnf+RB4s6FXaXFXY4M06eRbP2i6y32b7YoT6jCcqR3Ew9uoKhU
         s6sVZ5CkfRbjP5HxKJyVOy/lfFoM/yJHJQzIfa3hKqHPMAisF1hg4RXUWEaI5XZ4wDrq
         dNTCn22ebbuaxwtniRnRCjfvssvbobyUsavOBOpwO3i02gZPWTlOO6amya1XAP8rbObe
         N1JGzktoB+KkcDguCposyMSlRnuew618TwrRmZARk44IHx7PUXNwuassavxUzM8m20nZ
         Rykg==
X-Forwarded-Encrypted: i=1; AKwUvBwrupfN3x9mhi6yrsXs5pSDWe0HdD/x/4Ea0vlvZe4d7/38wccrr+1HvQkLm0h+TeY9L9Wu9om+Ig==@kvack.org
X-Gm-Message-State: AFq9FYL10u0dTWUOQLcCIheaBm/MfVLgEnwLRAFQlFSM6jcKMEwKX+yz
	9YFNXa5ME31Pxvba4+YPFdz0sZqP1UFPgbdHo2sCRXfCF2u2IXcNIciMTCcz8/MRYkB4lgKcyXU
	eHREZMMndkToIxg==
X-Received: from plmm17.prod.google.com ([2002:a17:902:c451:b0:2e8:d79d:4a41])
 (user=dmatlack job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:902:ecc3:b0:2dd:ad73:5b6b with SMTP id d9443c01a7336-2e8429ab7acmr112088205ad.27.1791908739540;
 Tue, 13 Oct 2026 09:25:39 -0700 (PDT)
Date: Tue, 13 Oct 2026 16:25:20 +0000
In-Reply-To: <20261013162529.1928093-1-dmatlack@google.com>
Mime-Version: 1.0
References: <20261013162529.1928093-1-dmatlack@google.com>
X-Mailer: git-send-email 2.56.0.385.gd3acb90ef8-goog
Message-ID: <20261013162529.1928093-5-dmatlack@google.com>
Subject: [PATCH v10 04/13] PCI: liveupdate: Document driver binding responsibilities
From: David Matlack <dmatlack@google.com>
To: kexec@lists.infradead.org, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, linux-pci@vger.kernel.org
Cc: Adithya Jayachandran <ajayachandra@nvidia.com>, Alexander Graf <graf@amazon.com>, 
	Alex Williamson <alex@shazbot.org>, Bjorn Helgaas <bhelgaas@google.com>, Chris Li <chrisl@kernel.org>, 
	David Matlack <dmatlack@google.com>, David Rientjes <rientjes@google.com>, 
	Jacob Pan <jacob.pan@linux.microsoft.com>, Jason Gunthorpe <jgg@nvidia.com>, 
	Jonathan Corbet <corbet@lwn.net>, Josh Hilke <jrhilke@google.com>, Leon Romanovsky <leonro@nvidia.com>, 
	Lukas Wunner <lukas@wunner.de>, Mike Rapoport <rppt@kernel.org>, Parav Pandit <parav@nvidia.com>, 
	Pasha Tatashin <pasha.tatashin@soleen.com>, Pranjal Shrivastava <praan@google.com>, 
	Pratyush Yadav <pratyush@kernel.org>, Randy Dunlap <rdunlap@infradead.org>, 
	Saeed Mahameed <saeedm@nvidia.com>, Samiullah Khawaja <skhawaja@google.com>, 
	Shuah Khan <skhan@linuxfoundation.org>, Vipin Sharma <vipinsh@google.com>, 
	William Tu <witu@nvidia.com>, Yi Liu <yi.l.liu@intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: EAAC34000A
X-Rspam-User: 
X-Stat-Signature: qbwfg6e831k3dq16emorc11wqfnd3rja
X-HE-Tag: 1791908740-729728
X-HE-Meta: U2FsdGVkX1/XfhlSzvno8vC8Bk/5t8+YcnnlZ9Y4HmJ+NjT2/WTHbpgsvNFKrkjR/eV2Lyq1tBh4S2SJVu7fElPq/CPrURFMbMELKYI8clseGvXp/OYsVnrg5TeYmeH35yr+Xp8HvQljQcIm9dftCJqIGGB1POYrz/dqJBcif7Rtx8GOJwfM0gsN/MVM6V4KMDarQcXaNxmL1Rzf1QcUJH2bJyTIqFX/1mLRE0aqDEpv9159NWgqz6Twb3aH9IMN485IhxxxlpYRlekgzJ16e1Q9ex6ZT7fJomyXceU9iEIS2MKpvrvsmcGkGt61HVrvS2KTqG99Ngv7dxXuSGoEVW84Mg517cLCqKW4uvOuSIRir+JyXhRUEtMv6B2avlVgpgC1OeLR4tUEnfKQHQ5sFDZXK4x3vj2XSdmDAblfnBAQQ3faex+ht60KNaR+nXp2Rhptsqauoo6d3XsrO0dWKTOw8i/jCh7/Io5VA4XR1lyGDxdXdrrjgHFdebRw+dJiIJAhNPu5GL/AtyPakZYrVuE9ZIQwXE+p4SUY/yaiFXRP0+htVZalJr1lahpbTakAKVqjm+WU56kxM/OwTiylD6X2Lid3MofsjxFaDwFA+ULb0VFeeZPpyyj454pPuXVcHa2XoLkxYSxZ1Se/0nnF5QQvB7ZNhCjrH8NPqIwoB/BPKCPKytZ6bJb6NYkvTkOB9t/T2t+UPhpfifBwDbD9O8bsqc6AFtXSGbMg3FZ1jfsSxnv4wrkvjS37Z9MnfdwXgC5SnkZrGHxmNvFxOhuh1tGC6Yvh/lLrVCsq7QwxhYHBOT3R6Mo09BnGRhyXtEBCXKNr1YVaveqCbVbjyRvrCNMCFfqCR/MoiWh8xwt9G9X5XaGzYrq80dSDd/y961Z9ixfr/8v42uAHaFUm+XTj/x2b/Hxr8p6fNNznlzFIHRX0zc/s3H6dYlvGiKPXOSHLMdKKmeX9ar73Wr49/zn
 hX8TVK6l
 +vg2iUPkrrWAzqqk900r3j29oJ2QzR1CZAHcVquTbs2yru/cZwdyuoqky0bYVFEW0CufDVmTpn5XT+/wo7OfMGfMwi1NpsSMVrnQi6Q+cpzQh8yZSLvmmrHwqs2n3LDfrrxuv1Mzg84u0Id/AWB+oYkRAD/273qHQqnLOZlyrMaDY0PE1N8sMb5yes/M82HLLriirghakhGrMfCIET8FkAUTGOpCuxP7OICdk3r3ZQS/p4DjTT37XVGxUCfqauNDXDxrTreqj2/IWb/hf4sXlN2qx73SDNEvI0EH0HJygf4Am6BW07vbwEjN2IhxV+cVVVnvC0SFfqtXD884C/VZtxeFbNcjNEwvs+xOoccFT5HKfzdwUVFyNb954cW5fL83fEOzQ4HTxUsF4e9HZjd1lVgwlyE7+U2wgFS6pZTllMjSTqYX4P4kXsg+DWkBuDxKkmq2rnpJZr3o/BoagoNbniZNaYq1qJeyydxTzdMjdSp2Kmoyhfc60uVBe9ccQS4CH4DcuBEyTsCRYRKw26pUOtB85YnJ9rJ2r0br947FlF77UfZ4m1A6Pfb4UzXNA8T/M4QuVC/Tu0otWqhJIO/2U/vt1TirNfgrbY4y9qeLi7QqH9uOOp3CkAHo2eT/r1RaS3yEwtz5aSipnxTe5VdEArhGnf+cVXghsK1tW2CE1FrqoXUc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Document how driver binding works during a Live Update and what the PCI
core expects of drivers and users. Note that this is only a description
of the current division of responsibilities. These can change in the
future if we decide.

Reviewed-by: Pasha Tatashin <pasha.tatashin@soleen.com>
Reviewed-by: Pranjal Shrivastava <praan@google.com>
Reviewed-by: Samiullah Khawaja <skhawaja@google.com>
Signed-off-by: David Matlack <dmatlack@google.com>
---
 drivers/pci/liveupdate.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/drivers/pci/liveupdate.c b/drivers/pci/liveupdate.c
index a1d9b2b1f9e3..d6b659b346bb 100644
--- a/drivers/pci/liveupdate.c
+++ b/drivers/pci/liveupdate.c
@@ -123,6 +123,20 @@
  *
  *  * The device cannot be a Virtual Function (VF).
  *  * The device cannot be behind a PCI-to-PCI bridge.
+ *
+ * Driver Binding
+ * ==============
+ *
+ * In the outgoing kernel, the driver must ensure that it does not release a
+ * device between pci_liveupdate_preserve() and pci_liveupdate_unpreserve().
+ *
+ * In the incoming kernel, the driver must ensure that it does not release a
+ * preserved device between probe() and pci_liveupdate_finish().
+ *
+ * It is the user's responsibility to ensure that incoming preserved devices are
+ * bound to the correct driver. The PCI core does not protect against a device
+ * getting preserved by driver A in the outgoing kernel and then getting bound
+ * to driver B in the incoming kernel.
  */
 
 #define pr_fmt(fmt) "PCI: liveupdate: " fmt
-- 
2.56.0.385.gd3acb90ef8-goog



Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4ACBEC44501
	for <linux-mm@archiver.kernel.org>; Fri, 10 Jul 2026 21:26:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5790F6B00B7; Fri, 10 Jul 2026 17:26:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 550C46B00B8; Fri, 10 Jul 2026 17:26:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 48C8B6B00B9; Fri, 10 Jul 2026 17:26:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 127076B00B7
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 17:26:30 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 5E0B6A045C
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 21:26:29 +0000 (UTC)
X-FDA: 84974150898.24.5C9DB50
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	by imf12.hostedemail.com (Postfix) with ESMTP id AAB1440008
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 21:26:27 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=HfhZ7Njz;
	spf=pass (imf12.hostedemail.com: domain of 3gmNRaggKCOcMVJcUJLTPXXPUN.LXVURWdg-VVTeJLT.XaP@flex--dmatlack.bounces.google.com designates 209.85.215.202 as permitted sender) smtp.mailfrom=3gmNRaggKCOcMVJcUJLTPXXPUN.LXVURWdg-VVTeJLT.XaP@flex--dmatlack.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783718787;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YGoZNXB/ZYxw+GyFT2bV+z2qLaGl3Mol8FyZ542tK3Y=;
	b=3/HFEI5E+03AcQ473VnaS3l/fqghnLxgnvsV89q4JZLhytG6r5o0YmIMwdc+VARx1M64vc
	HBnvFULs3WMkSdYa7OUkq68AIdmY4icwcdNR0md5vs/zngttykwyQZ+jDNyhz1SynfIwoP
	31yD//lrKs5YTm18zUFGaw4hVgdv+3A=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=HfhZ7Njz;
	spf=pass (imf12.hostedemail.com: domain of 3gmNRaggKCOcMVJcUJLTPXXPUN.LXVURWdg-VVTeJLT.XaP@flex--dmatlack.bounces.google.com designates 209.85.215.202 as permitted sender) smtp.mailfrom=3gmNRaggKCOcMVJcUJLTPXXPUN.LXVURWdg-VVTeJLT.XaP@flex--dmatlack.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783718787;
	b=Jh68WYWVDJn1NV9nZC4iZfOsMdfmnf8qdSRKorJtqrwApKAZEAr1azBUk3g2E/L+kKIU+K
	NiO2Lr0XMt8EP135Ia/QoKyqJwRxa6Tktote2IPqbineFIjbnw1Uqayka/9rrcnh9TnyFJ
	2PEQxsgfRyEDWoRREr0LmVjqJNDE7H4=
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-cab3e9cd922so15615a12.0
        for <linux-mm@kvack.org>; Fri, 10 Jul 2026 14:26:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1783718787; x=1784323587; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=YGoZNXB/ZYxw+GyFT2bV+z2qLaGl3Mol8FyZ542tK3Y=;
        b=HfhZ7Njzpfjf94jfxz4N+CaintMULMiELwqQxy49b2AjTSu/IwFAEbX5T7AS2iqpbc
         Ok6snF/JKgqVIUUnYvHqvFRpsvKtd4TnRxJPn9s6fXVi0hpg4+1M+69Z9F4ag6A7/mrG
         uXL35AieodUVNsrtJUH+l8dWrb2l+L8TzytdbiN6tIyMiLANZYDrcOpjMUuCVCNCTODn
         dTtP3swC6apG2trtbSf9QrrfLR9EuH6F2yvXWoEQEaVjtCY4gCmgC+8UXm4J1L+MQv5t
         ACw++04zXLPbtWNEhXKtaZwmUZD5Gtp2yThwW8i6C4UvCv5GrE568o6dk6zwR9W7HJpu
         4wrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783718787; x=1784323587;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=YGoZNXB/ZYxw+GyFT2bV+z2qLaGl3Mol8FyZ542tK3Y=;
        b=aN3+lMlYQ3Ok4MbTSNbngPqgf3Yk3e6J0VjgeH3VQ65idY5L4A/TVKaxCG/FLOaPcg
         brMvMyt2ODBVFLi4ZfFoj8t0wk+xn3XPYwEPD4GHjsctiLI/ILOAIMafBvxvICHPVCcL
         MHf8x12oGoffLgWWfFxaovEK6/MmeD8qYLVD0D7qHAiNVO+cDXS4m06Qsy5xefR34jms
         7kWKa93vhR2Vx/TyCmfA3FcbYzeI9IaR0gx4j1gx3BfDwEterfH66XdxO4f6l1s+kJh9
         aAWnSGD8q9l2gw/0yGQa3z0y1WnOqHTkU9Hl5HYmvbw1tkkhSuYnyFcnvJiEulZGYNws
         db2Q==
X-Forwarded-Encrypted: i=1; AHgh+RpifaZb1CM48qY65lN47+/+WkGgPo7XMfvjoHrsDGKZuI79wtxs6/rnA5N0bzARuZqMV85fwGl72A==@kvack.org
X-Gm-Message-State: AOJu0YwMWqY/qIRnwiKsDo7P8dOugwiR6UAwKeC1wzWCWtCSxUaAQp66
	yhhpnWoNpA5Y939lD6iAGngxC/ALkhPJObgcAttoOxI/bTmKX+zFdWMLyJWa9m3yjnKAuMD38j5
	ZpRN6XOlxbkfy5w==
X-Received: from pghx9.prod.google.com ([2002:a63:f709:0:b0:c85:c772:c6a5])
 (user=dmatlack job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a20:4304:b0:3bf:bde7:d671 with SMTP id adf61e73a8af0-3c11060a6cbmr641192637.20.1783718786556;
 Fri, 10 Jul 2026 14:26:26 -0700 (PDT)
Date: Fri, 10 Jul 2026 21:26:07 +0000
In-Reply-To: <20260710212616.1351130-1-dmatlack@google.com>
Mime-Version: 1.0
References: <20260710212616.1351130-1-dmatlack@google.com>
X-Mailer: git-send-email 2.55.0.795.g602f6c329a-goog
Message-ID: <20260710212616.1351130-5-dmatlack@google.com>
Subject: [PATCH v7 04/12] PCI: liveupdate: Document driver binding responsibilities
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
	Pratyush Yadav <pratyush@kernel.org>, Saeed Mahameed <saeedm@nvidia.com>, 
	Samiullah Khawaja <skhawaja@google.com>, Shuah Khan <skhan@linuxfoundation.org>, 
	Vipin Sharma <vipinsh@google.com>, William Tu <witu@nvidia.com>, Yi Liu <yi.l.liu@intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: AAB1440008
X-Stat-Signature: 9ygige5bbe8rmqakdoh5n4d4qdpcntuo
X-HE-Tag: 1783718787-365736
X-HE-Meta: U2FsdGVkX18GTGqfaQUWwPi+CwdlIy1lAyt75hs5VF/kF6MDSWDD7khAVhbBlNuQ0SWOQFbH588tfHUeYKYNiSuSVUqQaNEQcmFpZjTPmBB2kr2yasPWxWzrCxUbrpa6JW4E1Icw3P/uCP7eRbdhfnNtHmnO96tEMSokC5VawhIXQHR077ep7/3N1/ANvTB2OGD7y/xkconFNe/ZKBQjDUIHKhlgwyJBycla15m6NoHiIt8UxB1wwcYmfj7vBpTHPi6EYn5J1nbNw+z77iHz8WXU/t8blxAe+9uQ8CBeuShAxW1pjXL5kfreuCXO2VPnbAp8sgm7o6+aIXj+IJj6Sh1FZKvXQgNpbYPuapGwGy5Y4mBmqLd+g/Wohng5eeGxsLExDVF4zSrOHPn4QArv79BSW+3Gy/lh4f47TVQEuva4UAkEgIP1t9zfoYgR9qcMX/Jgk0Av309qoI7/nATfHhR1NY1WIBGtNLgz7E2GYWtzYqd27tutS4Rjr1u/kIQJkaEvYWIS6cJXUrKqJufpclJlIU/To4qB9m6KCvi0YZyAXcDCRfjXEO0V7wmJ5GNOtY2eh2G3VZJ9ONnusIo4svhFM5n/6kh6i/2caGjYy64LjhIOteetoSpQUVTwy6i/4kK6AdsXT6sYiQzpzZDM2/ksqPFw0MSUrb0fVuHOhTgFfHDYmPYabTQtXmC7LLonsR/VMSqHfsgjx2Ud7zkGHd6CuM8+mTldbFzjVKhGnkDeTW3zdZmJthNykyC2UIuRTDGNNo/NpNbRYj94BjXXSVeLVkitt4xmIIfnqmfdkT0MCyA1gGbhGDHPSxGTusJSAN3Yj2TjbtKAvyGala30zh5fCWtr+RgqknqzNK1dG0QI/F13G5qRLV19l1G70g85cADRJe3C9098pMgu6TvwWmwD9O8Py46gAYABtB/AEX403f/3GJ5/17JN4IFV9wzNfK+SsyyH9+ZOMnRcc9S
 ETdvrkpO
 OZrWTp5QxpVMf2d1q8iYjAYLh99t3NsQlMdRBTom9cHWXzbYQ9EANORw2j8wPs9DzqKNHdAJZRCdLdl2p+lRQRG2joV0e1C5FNbl7xM6QdbEH30Qne7pGoie7dhOBKLOcgCttlCrBORXlg3dRT66LjRxoVJg2X3+fon+Z4ttPyOuJSi4mad0i9ZYJP4kcz6cuagaL52ZbkwamdQs3mVfQo++FQyPpJS6jneNc4daYqB/oF8B0jXM+Rp0r62FMcauqGG1PeOWAHkWb0AVQFEEa2hxi6k8wy2/HHcBYtqE+LNPel1cljuFs1Y92qrX6yCpXfKF9KaIXXf++BXYGMdHlntCJVt67aak1tVZPEGr7YTpjjxPdlKqYO0OwL+IdejqT5AyU1SM0xU00QJ5xdZsYBOjprSbSKSj9RHkRAzZNbZZHVDy7eFIGAkWR3CKx4hVJFXViCRqNS1Cg1D3C30BLvSzcit7NMTgAZRqdTy5qwshAI9CcU/q0en1mJYiUuq2qJtlUaogh/95Z4inEVHsP1SQGU9/GSocD4fNw8y2BnopxIVDutBmtPDN4vKZwUmMDlHX74fYVc1Ig4F1mQFTAhhFgIXtK7BK7dGoUcWiyH0muljDHdMX/D/HLkXXggRfsmMMueWMr1oSa3y0fNwRXfOJ1pdMJaMYSG+Qlg5v2zF1ZTf8=
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
 drivers/pci/liveupdate.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/drivers/pci/liveupdate.c b/drivers/pci/liveupdate.c
index df6a02240aa4..a067632e70d1 100644
--- a/drivers/pci/liveupdate.c
+++ b/drivers/pci/liveupdate.c
@@ -70,6 +70,22 @@
  * preserved. These may be relaxed in the future:
  *
  *  * The device cannot be a Virtual Function (VF).
+ *
+ * Driver Binding
+ * ==============
+ *
+ * In the outgoing kernel, it is the driver's responsibility to ensure that it
+ * does not release a device between pci_liveupdate_preserve() and
+ * pci_liveupdate_unpreserve().
+ *
+ * In the incoming kernel, it is the driver's responsibility to ensure that it
+ * does not release a preserved device between probe() and
+ * pci_liveupdate_finish().
+ *
+ * It is the user's responsibility to ensure that incoming preserved devices are
+ * bound to the correct driver. i.e. The PCI core does not protect against a
+ * device getting preserved by driver A in the outgoing kernel and then getting
+ * bound to driver B in the incoming kernel. This may change in the future.
  */
 
 #define pr_fmt(fmt) "PCI: " KBUILD_BASENAME ": " fmt
-- 
2.55.0.795.g602f6c329a-goog



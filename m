Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9FFE8D73E8D
	for <linux-mm@archiver.kernel.org>; Thu, 29 Jan 2026 21:25:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4E54E6B008C; Thu, 29 Jan 2026 16:25:46 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 455F16B0093; Thu, 29 Jan 2026 16:25:46 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2A5FF6B0095; Thu, 29 Jan 2026 16:25:46 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 029B46B008C
	for <linux-mm@kvack.org>; Thu, 29 Jan 2026 16:25:46 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id A0DD48B0C7
	for <linux-mm@kvack.org>; Thu, 29 Jan 2026 21:25:45 +0000 (UTC)
X-FDA: 84386283450.21.6FE5F6D
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	by imf06.hostedemail.com (Postfix) with ESMTP id DDAF8180007
	for <linux-mm@kvack.org>; Thu, 29 Jan 2026 21:25:43 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=f7EV+DDF;
	spf=pass (imf06.hostedemail.com: domain of 3VtB7aQgKCDkYhVogVXfbjjbgZ.Xjhgdips-hhfqVXf.jmb@flex--dmatlack.bounces.google.com designates 209.85.216.73 as permitted sender) smtp.mailfrom=3VtB7aQgKCDkYhVogVXfbjjbgZ.Xjhgdips-hhfqVXf.jmb@flex--dmatlack.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769721943;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=u1Z3QHTjPxpYvShlt2cO6c78554A0ZIR6ozbVe3TjI8=;
	b=mJX3fJD9EMqZu2iAFHA05xGNpOZGyrpqMEpWWQEIwI11+hM/lcb93YCD5MO1VUyRSKq/D8
	nglK/utgNY3CsyLSEgxO/NKcrO1Wlj5pvpjxa9CpFZiPulwqDWoySWzKRUUyVMCDGX9Xhn
	urhVGzrkZ/morLDwyjahoOALP1VyIVo=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=f7EV+DDF;
	spf=pass (imf06.hostedemail.com: domain of 3VtB7aQgKCDkYhVogVXfbjjbgZ.Xjhgdips-hhfqVXf.jmb@flex--dmatlack.bounces.google.com designates 209.85.216.73 as permitted sender) smtp.mailfrom=3VtB7aQgKCDkYhVogVXfbjjbgZ.Xjhgdips-hhfqVXf.jmb@flex--dmatlack.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769721943; a=rsa-sha256;
	cv=none;
	b=K+eqFwbDdD2WP4JyuvF675qeFSLJ/u52TO85VYhpUYhpiReuUC1RV/n0clWURtsWCeEZEr
	qAqLhj4+6eVdVGPMJpYmxuitWjYjOjU4bI7WLbqasBzxyWu5+XlFi/8C9F8wjEZU1SBXMq
	oovaN6jZDKOoAbYroBGjzYKmOF9NXEE=
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-352e195f662so1136059a91.2
        for <linux-mm@kvack.org>; Thu, 29 Jan 2026 13:25:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1769721943; x=1770326743; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=u1Z3QHTjPxpYvShlt2cO6c78554A0ZIR6ozbVe3TjI8=;
        b=f7EV+DDF/5IXO6e72BkWyZNFXg5lwV8YQG3o5HU+N2fDDeMpslcchLLDTLUEof+OvV
         bRnhrkZc8/h2vG5E17tIqKtXD1ZTQbxWHe+/Bk0346Gbyl6iHj7h0Qj/LVdQYmH2VljQ
         w10O38c1WVc30Ee8je5qdHUqnnuqdaTnyOCelcJgwxfO9mPX2a0pzoXUnRyDAFML4YhW
         MwhdAMX9FS5URZfI2Yg8Jkn47V5HBE+lLG3DpjxWEL6eJHk6nRWFvOldmFC45AvCVNuH
         3L818pkt/KuX/cckMLXBqSQA93dSj083ZDPQoaa5iCS6BYsSIhMeOWysi16VFyHM8obh
         BW8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769721943; x=1770326743;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=u1Z3QHTjPxpYvShlt2cO6c78554A0ZIR6ozbVe3TjI8=;
        b=DeoGQrjWAw2XxNaPqwU/TatNjqvzikz7n/600k8IuYIG7l4WgYK0/5IysozA7e7+Hj
         NWUkQaGT8tN+KBpR3pU+ry1FM6YBNsK7M7UXDquAytl83yDzc8OczSkUGkvyMh5Va8SK
         smI0ALpDMMqdrQQ9R+3Jvs2OShnlkrF8vTXQk/HuLecT9ragod44eMMc8AfpskKYwGwi
         DuiQenjFpy9gmII+CerbtLw1sl4qH9cXhfLAwCV1ITSXyvGEPxJoHetrRUbXeD1glsY3
         LyWc+gCUtHwZfrnt0qgn3GptHosTZ/ktZaozch+gGwFmV63gEJE2rIXwW0aZ0TJQqFNU
         jrLA==
X-Forwarded-Encrypted: i=1; AJvYcCXQhAgmxTesdJaW8QFhHjeLQ3wwuVK1GVzM56EOTe00FpAaeF0YN6gPeGYC5wufe314B8ZFzLawwQ==@kvack.org
X-Gm-Message-State: AOJu0YzX3Jxlm0LOGjl3gc6upTz6CSmRmcC6+YdVn7UH/CfLGWs8sXXj
	gWRn5NRrsJco6ya8XkSnsZBBV01SnVtObgqMKH94aBk8IPrkew7wuF1G+3eljkJNIL1bmH143Jm
	xSUCzOmPHevQGVA==
X-Received: from pjblb16.prod.google.com ([2002:a17:90b:4a50:b0:352:b92b:ef8])
 (user=dmatlack job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:90b:28c5:b0:343:684c:f8a0 with SMTP id 98e67ed59e1d1-3543b3ae12dmr762757a91.23.1769721942669;
 Thu, 29 Jan 2026 13:25:42 -0800 (PST)
Date: Thu, 29 Jan 2026 21:24:50 +0000
In-Reply-To: <20260129212510.967611-1-dmatlack@google.com>
Mime-Version: 1.0
References: <20260129212510.967611-1-dmatlack@google.com>
X-Mailer: git-send-email 2.53.0.rc1.225.gd81095ad13-goog
Message-ID: <20260129212510.967611-4-dmatlack@google.com>
Subject: [PATCH v2 03/22] PCI: Inherit bus numbers from previous kernel during
 Live Update
From: David Matlack <dmatlack@google.com>
To: Alex Williamson <alex@shazbot.org>
Cc: Adithya Jayachandran <ajayachandra@nvidia.com>, Alexander Graf <graf@amazon.com>, 
	Alex Mastro <amastro@fb.com>, Alistair Popple <apopple@nvidia.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Ankit Agrawal <ankita@nvidia.com>, 
	Bjorn Helgaas <bhelgaas@google.com>, Chris Li <chrisl@kernel.org>, 
	David Matlack <dmatlack@google.com>, David Rientjes <rientjes@google.com>, 
	Jacob Pan <jacob.pan@linux.microsoft.com>, Jason Gunthorpe <jgg@nvidia.com>, 
	Jason Gunthorpe <jgg@ziepe.ca>, Jonathan Corbet <corbet@lwn.net>, Josh Hilke <jrhilke@google.com>, 
	Kevin Tian <kevin.tian@intel.com>, kexec@lists.infradead.org, kvm@vger.kernel.org, 
	Leon Romanovsky <leon@kernel.org>, Leon Romanovsky <leonro@nvidia.com>, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	linux-mm@kvack.org, linux-pci@vger.kernel.org, Lukas Wunner <lukas@wunner.de>, 
	"=?UTF-8?q?Micha=C5=82=20Winiarski?=" <michal.winiarski@intel.com>, Mike Rapoport <rppt@kernel.org>, 
	Parav Pandit <parav@nvidia.com>, Pasha Tatashin <pasha.tatashin@soleen.com>, 
	Pranjal Shrivastava <praan@google.com>, Pratyush Yadav <pratyush@kernel.org>, 
	Raghavendra Rao Ananta <rananta@google.com>, Rodrigo Vivi <rodrigo.vivi@intel.com>, 
	Saeed Mahameed <saeedm@nvidia.com>, Samiullah Khawaja <skhawaja@google.com>, 
	Shuah Khan <skhan@linuxfoundation.org>, 
	"=?UTF-8?q?Thomas=20Hellstr=C3=B6m?=" <thomas.hellstrom@linux.intel.com>, Tomita Moeko <tomitamoeko@gmail.com>, 
	Vipin Sharma <vipinsh@google.com>, Vivek Kasireddy <vivek.kasireddy@intel.com>, 
	William Tu <witu@nvidia.com>, Yi Liu <yi.l.liu@intel.com>, Zhu Yanjun <yanjun.zhu@linux.dev>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: DDAF8180007
X-Stat-Signature: jktcythhb4akigtzq5is1g5ect17njen
X-Rspam-User: 
X-HE-Tag: 1769721943-804143
X-HE-Meta: U2FsdGVkX19iHDFw1/RikAb8sP1/J/yPKFCcFIWhmllPaQG4aUpUxgFTuFoi9/oTeSYz6QkDsiZLi0XxDTxsu5F1I5V6yGYqa477COnIpxyn7XgYtEPOi9J+othJSpwJoZf9DcpQWQaiBAcyySUs9/StbhMibCAmTyElDrj3C8Yw6/uS6YAWadzasiBcCG0a6TvwLeZfJaoRm6WMhi2u5AAx6MGXCUUJftOynhMpMfS/cFcwFeDfVJcVmW2ySF0BBquVyHJ4dxvs+9RybjW5KjKWy798Yr7Wd6SnTnaDyOZI6AvHGPXJgi4Ttw5HZfqj0q6+zbNukpQHMmWzOZo6IMHTpMfAYNxmyBWb+95c6UBK1PSKGbJflsSyNdBAxldxW217htuLmoM+gjEEJb4z72JHGtmx3P6ZadkZj7Fv1TrZ56lsV+JfZtkgDLuBORfHAkgnqVPsjiM2n+iXkkNNZ1Ju26BHbFtzdFbEwUw/JZgSGsmzPCuqLff4X1vXNxOwD9KjHprrUasG/toglYl+nG9ZQuqm5ZvvHD3fTG8yURBwqg5joPILsOvFbfZhmTarIKFWtVUO8osDCOoSkN4Vm0j9UFVlupd3mAGWFyZcmdSzQjxBbCI0WwZU18HdSJhUiPeLczIwuV7GCDYdrshMBHEJo1SK2Pzivvbr2c07uE3KmzMULP79JPXzED9Ndq5EqZHUvYHf9SOiX1xs4C6SbY/+KYoteW/d5dxarVWGV7lMSjaHyxhxLP1IQUu1usgpZy+5p2UhZk6sULxVa019N2QEjZ6hCltEudks3qr0jJUP8OZ0hO8ZNtQIez5+yIXCpZ59SjybfxMxY6HGD1cHLaWfHVblLWgX71MibqXfS9gIUPvZLmKZcm8UDLhibVG9VV0huud++vJJtYGI3FhNnR8axwZRPXVl23RlhKHFnGsrVPu//yU1oAuziTJQfTYdu/PAWiB91fkTx6aP1mE
 CiOKkp9h
 BhY2GzXxE42PUZ0Weuw4+bRhUppZxd3AH3LoCQMWE+IzCDGLJaWdqhM8UkboDHuryYhowuFqsxGmlSVyudlE36PZGmdvSgaehmt/M00U8EjjGxE5M2XDorg96OGM3AXKQ6lmptioC4tYMeN20mSuuQe3wvZQZpdeaFsbP1zR/Eifxu0vD+2x2EAY17XXuLH6N9w+j1/0K9VcQEAMMs7z4kiueiQ4yngWnv1yhzF/Z5hq9bFr/SMTz02ijbOd6PH5NrMJ3uS8k3XUl+j2ViOG5nT6iPlZqHuMt5hiBDcf3RBJneNAybD9yilHbyNVecbGOHgaKV/ZiVoIEDDWNEvsXeDVyhhZKVfJjo8RPkb28RWzYWcYQOSIKFrDcQt5gRSUsHw/uS0rg4VvXI/WfvWA0yqrTgAOcxVDhpiH1N+ZGrWV9arrMSY4TlMwGAvkovKP/Kc47hxixx9V7OCA7JJQxZXF/vWMv24bwv7xhxr9XRQ+MgodS2srzQuLSU4QokYYyXs1gSxRhAyE92H4lnqO6Rx/lSdPNrDYuleNdVo20AnZFpbtMNdfs0+UZSg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Inherit bus numbers from the previous kernel during a Live Update when
one or more PCI devices are being preserved. This is necessary so that
preserved devices can DMA through the IOMMU during a Live Update
(changing bus numbers would break IOMMU translation).

Signed-off-by: David Matlack <dmatlack@google.com>
---
 drivers/pci/probe.c | 21 ++++++++++++++++++---
 1 file changed, 18 insertions(+), 3 deletions(-)

diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c
index af6356c5a156..ca6e5f79debb 100644
--- a/drivers/pci/probe.c
+++ b/drivers/pci/probe.c
@@ -1351,6 +1351,20 @@ static bool pci_ea_fixed_busnrs(struct pci_dev *dev, u8 *sec, u8 *sub)
 	return true;
 }
 
+static bool pci_assign_all_busses(void)
+{
+	/*
+	 * During a Live Update where devices are preserved by the previous
+	 * kernel, inherit all bus numbers assigned by the previous kernel. Bus
+	 * numbers must remain stable for preserved devices so that they can
+	 * perform DMA during the Live Update uninterrupted.
+	 */
+	if (pci_liveupdate_incoming_nr_devices())
+		return false;
+
+	return pcibios_assign_all_busses();
+}
+
 /*
  * pci_scan_bridge_extend() - Scan buses behind a bridge
  * @bus: Parent bus the bridge is on
@@ -1378,6 +1392,7 @@ static int pci_scan_bridge_extend(struct pci_bus *bus, struct pci_dev *dev,
 				  int max, unsigned int available_buses,
 				  int pass)
 {
+	bool assign_all_busses = pci_assign_all_busses();
 	struct pci_bus *child;
 	int is_cardbus = (dev->hdr_type == PCI_HEADER_TYPE_CARDBUS);
 	u32 buses, i, j = 0;
@@ -1424,7 +1439,7 @@ static int pci_scan_bridge_extend(struct pci_bus *bus, struct pci_dev *dev,
 	pci_write_config_word(dev, PCI_BRIDGE_CONTROL,
 			      bctl & ~PCI_BRIDGE_CTL_MASTER_ABORT);
 
-	if ((secondary || subordinate) && !pcibios_assign_all_busses() &&
+	if ((secondary || subordinate) && !assign_all_busses &&
 	    !is_cardbus && !broken) {
 		unsigned int cmax, buses;
 
@@ -1467,7 +1482,7 @@ static int pci_scan_bridge_extend(struct pci_bus *bus, struct pci_dev *dev,
 		 * do in the second pass.
 		 */
 		if (!pass) {
-			if (pcibios_assign_all_busses() || broken || is_cardbus)
+			if (assign_all_busses || broken || is_cardbus)
 
 				/*
 				 * Temporarily disable forwarding of the
@@ -1542,7 +1557,7 @@ static int pci_scan_bridge_extend(struct pci_bus *bus, struct pci_dev *dev,
 							max+i+1))
 					break;
 				while (parent->parent) {
-					if ((!pcibios_assign_all_busses()) &&
+					if (!assign_all_busses &&
 					    (parent->busn_res.end > max) &&
 					    (parent->busn_res.end <= max+i)) {
 						j = 1;
-- 
2.53.0.rc1.225.gd81095ad13-goog



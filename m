Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 24E57606A31B
	for <linux-mm@archiver.kernel.org>; Mon, 19 Oct 2026 21:31:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20251104 header.b=nEPDD9lV
Received: by kanga.kvack.org (Postfix)
	id 20B936B0396; Mon, 19 Oct 2026 17:31:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1E3086B0398; Mon, 19 Oct 2026 17:31:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 05B246B0399; Mon, 19 Oct 2026 17:31:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id CAB1B6B0396
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 17:31:30 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 57474140601
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 21:31:30 +0000 (UTC)
X-FDA: 85340672340.21.06C0AEA
Received: from mail-pl1-f200.google.com (mail-pl1-f200.google.com [209.85.214.200])
	by imf02.hostedemail.com (Postfix) with ESMTP id ACE728000E
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 21:31:28 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=nEPDD9lV;
	spf=pass (imf02.hostedemail.com: domain of 3L4zWaggKCP4jsgzrgiqmuumrk.iusrot03-ssq1giq.uxm@flex--dmatlack.bounces.google.com designates 209.85.214.200 as permitted sender) smtp.mailfrom=3L4zWaggKCP4jsgzrgiqmuumrk.iusrot03-ssq1giq.uxm@flex--dmatlack.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792445488;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zjIHcsp6K5l9uxu4NW3RN2Ki168yByks7xW11UF++V8=;
	b=YDhrt9JUEL0uCSxTGsLawxYVcPK/6NTpckQauFcT2NPVU2JVQbjcNi5hiM+MDEC3ua5L9V
	T92snLWQmuSZsyOQoHZIAKkR+7edr+6EEFURpyFXmAdvpx/wDHlW+ccQtwQYGjzK9CF+xO
	KFWIaoR18oTGVDEL0HH/irxcBNmt0E8=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792445488;
	b=bzKo4ybKN9m0UmnVF45mm0QPFza0q7matAsnYw0QYs1DTvv0IgsxoGDytUavwLetLmDLtx
	DaGxArkFwKCv9K1xVmRHhP0TF8EG0eszOvtfmzbUHJgoi/wza1GZARM1oqirK/GQmZ0oVz
	QrA6fa2xgprIktdg0ix/IVFkm6LGBrU=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=nEPDD9lV;
	spf=pass (imf02.hostedemail.com: domain of 3L4zWaggKCP4jsgzrgiqmuumrk.iusrot03-ssq1giq.uxm@flex--dmatlack.bounces.google.com designates 209.85.214.200 as permitted sender) smtp.mailfrom=3L4zWaggKCP4jsgzrgiqmuumrk.iusrot03-ssq1giq.uxm@flex--dmatlack.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-pl1-f200.google.com with SMTP id d9443c01a7336-2e987ec84afso23017335ad.3
        for <linux-mm@kvack.org>; Mon, 19 Oct 2026 14:31:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1792445487; x=1793050287; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=zjIHcsp6K5l9uxu4NW3RN2Ki168yByks7xW11UF++V8=;
        b=nEPDD9lVYPyFw6HfpJcGp82U3DBL/VE19NdcLLDDTWlm74yQuC9Uq1g+7xrDB87vY2
         ILQRzbmGT1MHofPOrY78zmFEhoiMQRjNVx15Op3UDKjkgazGWba2rnS8VYkCJpBrEU70
         Y8sHYtnhSmaQsYZ8oBLiQPdNHuk3aWWuk3KHcjWGiVZuvulBviYOdoRmHPwdQqfS8WTP
         voKjqktaTXc1r+F1/QerU20Zb31IwBP1UWsXs2h1tOAloKzXFtmOXZ4IkBU1BjT52G8N
         idnEsqEklHbBPN1KlaxEdW8XQVoEuDcH5M4xw6Xvbw1/NhrT9RZ1aNwBfxZM22KpTvpI
         rFCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792445487; x=1793050287;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=zjIHcsp6K5l9uxu4NW3RN2Ki168yByks7xW11UF++V8=;
        b=CeAnqiaSgx5Xu8jGQxiJZEes8y57l+5ioQ/FYB2y6Qo6gbcXZeiCYV5BJ77U1EyZnr
         63GSRqkzx9U0KaPbsTjdFA9QPsmrdtot205EHX2leTiN70YLyz4NMqjV0xFtiYPem0uA
         KbPBeM3KnT/WAH3BQ5me1drqyLlRyel88xeJuEu0BLrB2M8tNIKNr3Aci2Xx9ElRt8xn
         buvdO/SObTm/IBHB6vji6Kp7tNsr2zmW4/J7yTIZdhzmXKSQ0pT927bFkyI1GkAEGpAZ
         jBVd+n+UzriDsXjIJiELFBkDO+nYemg+3A16jBfHV2DqK53NSahBwAkLcCLU+Elj5v5X
         RL4g==
X-Forwarded-Encrypted: i=1; AKwUvBxSD6Y6cxOTpEG21WBk5nv7gk2MYPE2nL0uO/Hy3dCO2hI/6HKHbOxcLGv/A8Um7MGsxBnfUhYF1A==@kvack.org
X-Gm-Message-State: AFq9FYLgYp7A2ZWaZsLPGkSNVnXAJkUOuCrxdUoEnc6qJd8I4w6LSVBd
	49Dci4sSipGcsRVJt38YQMZTv2moi5l0JxN929MXqDUtM7hIwimUWX9cIqK7wWWm+pRhMG9M91o
	e5EBJqak+qBKBSQ==
X-Received: from plbkf3.prod.google.com ([2002:a17:903:5c3:b0:2e5:b8db:503])
 (user=dmatlack job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:902:f711:b0:2e5:dbbb:6c7f with SMTP id d9443c01a7336-2e9a68356a1mr74031665ad.1.1792445487379;
 Mon, 19 Oct 2026 14:31:27 -0700 (PDT)
Date: Mon, 19 Oct 2026 21:30:51 +0000
In-Reply-To: <20261019213054.3157159-1-dmatlack@google.com>
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
References: <20261019213054.3157159-1-dmatlack@google.com>
X-Mailer: git-send-email 2.56.0.212.g129ede20d9-goog
Message-ID: <20261019213054.3157159-8-dmatlack@google.com>
Subject: [PATCH 07/10] PCI: liveupdate: Never assign resources of incoming devices
From: David Matlack <dmatlack@google.com>
To: kexec@lists.infradead.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, linux-pci@vger.kernel.org
Cc: Adithya Jayachandran <ajayachandra@nvidia.com>, Alexander Graf <graf@amazon.com>, 
	Alex Williamson <alex@shazbot.org>, Bjorn Helgaas <bhelgaas@google.com>, 
	David Matlack <dmatlack@google.com>, 
	"=?UTF-8?q?Ilpo=20J=C3=A4rvinen?=" <ilpo.jarvinen@linux.intel.com>, Jacob Pan <jacob.pan@linux.microsoft.com>, 
	Jason Gunthorpe <jgg@nvidia.com>, Josh Hilke <jrhilke@google.com>, Leon Romanovsky <leonro@nvidia.com>, 
	Logan Gunthorpe <logang@deltatee.com>, Lukas Wunner <lukas@wunner.de>, Mike Rapoport <rppt@kernel.org>, 
	Parav Pandit <parav@nvidia.com>, Pasha Tatashin <pasha.tatashin@soleen.com>, 
	Pranjal Shrivastava <praan@google.com>, Pratyush Yadav <pratyush@kernel.org>, 
	Saeed Mahameed <saeedm@nvidia.com>, Samiullah Khawaja <skhawaja@google.com>, 
	Vipin Sharma <vipinsh@google.com>, William Tu <witu@nvidia.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: ACE728000E
X-Stat-Signature: etd3tbowpsurnhdm777wxowuu3f99tbc
X-Rspam-User: 
X-Spam-Status: No, score=-26.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT,USER_IN_DEF_DKIM_WL autolearn=unavailable
	autolearn_force=no version=4.0.1
X-HE-Tag: 1792445488-310893
X-HE-Meta: U2FsdGVkX1+3Vig/r1wJJQAM9DaswjoYpVAYShAi42n9Q0hGuvMH6ORPLE6gQuEMhq8OhUg3xxH5hSWDuDC1aNKc8OAlANT5CDl/pJQ/+VIMPPnhiR5OICjwqLcCrxtE32j9e2GSEszyQa7hyr9m/cp7D6k2vxygICM+nK+hP3GdjwAS33PLlcaYc4K8mRlRegX+WO+vC/DpnOEXvzK2tezfWddrOkD+XI+NHyV/g3c66hmTzu5HZV7GajZaowUGV97APelb0MHHZmZov8NimiIVYocC0Ltbdell5eEhla9cjWmtJdvw+ajscClN9jHcbPIu56KjShpmHzTho2QGshD8E4zEQlNLMCEGc6zkeJbGH3+KgrNY63M0JqyVkFitQl/kr5Nc4OuazDNv+3V+DOtkYNTYp4O78F6JUR9rCCoSDGfESxS9Vw47j+UV0IL0417gABfEJg4A3HHKsg4TS/SoIujxJka057oU1uOatLvWvyiUGxz4PdJaedwZa0GyThUeRLM7ib2Xde506P+kl2qRB4YeO/Nk7AoPH1NR+yQUZc/kYPCWhxXNFImqrN2ouqgQy/zzkN3SryfiTn2/rRX3PfWOctYRyntXyvUbbCae3AJyq8YIzoFUQzgOD2uptYogGugJUAI3GsscMvaizP0G0QB9UaRud0m4AgCmI5msFUD2JSLe7Kh8ZLK90L6MlmcgXIRkHdGYOchIjfpaTRQ5qi20MWKcaap91oOvIWvLg6YU0L1VNa5v8F66SFzp5kDmkPCS4cqP/MVRdxIdFtoI7FTyDMBKCxtQVHfJwHSsjvQUzijnI194UjckkfVIINOoeRge3IpaYJedjHQEN3/4DN8B8seIFlaQByXgxIW0uE+K2Bwx3lp8UWQkIy4WA6Q9YNreDO2w+UiLAPVKm5i/kS2B+4lpVKPQH4lexFwRCFU2TGjXaxk5nj0hOsYBnfYXAAU+/YzTDgyCKZ3
 E3+xbwf5
 gli6hOOKuRXA6Sh/rWyhmBm6+ZMEtYU0mwNFad1/0HEo6JaQIp+MFv2rjRnys0ZX9X1uRbaQQzuNOto3iw5hP5rtJalP4pistgAq7dC2KJGOJ7VXWjvDRIq2nM+X2vFqjJJnIA8bx2ELBToY+6nLfkBjmqgAyDIaQXIiT5LvM2Sx2CXhnOFo92q+TsTobvlx74vwvVu8HORI71facDvl7Mf21SFdz1sChaAIFiumWPsoZW946cKjMFfGz3QO0oni2ZV1WdP4nKEsB/hONsIJeLekBpgJthlPKT+PE7e1o/q57SxYI533PNlXL9pOr00d41vKs5B2cnr3GEive9YTPD6TmCFw+qrJZ2Ba9YLjboz0BcAosy+zBa82IJ98fKWfTYoMwIOEyPv7IDq7Mb6V3xuf0ZTfH/enMReM/NG0hOzEn2sxpfrv4bg70/835y2nDf2j8OiZ+k7WAn/HpbG+h5EWJY6NCjVlIfvKPfHIp2hIFJ0NSA+AkkumL2GvmYXPE5T8B/yzW7gdwFbqEg7ikQ7+c7mAcH6SRQ2iPBrWEdBLX6DPw4KitdFk4TWT+2hWWt+X0hKIAStQEvaGyBpNMObwjtg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Prevent the PCI core from sizing or assigning the resources of incoming
preserved devices by adding a check for pci_liveupdate_is_incoming() to
pdev_resource_assignable(). It is consulted for every resource when
sizing bridge windows, in pbus_size_io() and pbus_size_mem(), and when
building the list of resources to assign, in pdev_sort_resources().

The resources of incoming devices are claimed as programmed by the
previous kernel while scanning, and claimed resources are never sized
or reassigned. However, an incoming device may also have resources that
the previous kernel never assigned an address, e.g. a disabled ROM BAR,
which therefore cannot be claimed. Assigning one of those would write
to the device's BARs, and updating a 64-bit BAR temporarily disables
memory decoding (see pci_std_update_resource()), which would disrupt
memory transactions targeting the device's other BARs, such as P2PDMA,
or MMIO from VMs whose vCPUs keep running during kexec. Leave them
unassigned while the device is incoming instead.

Assisted-by: LLM
Signed-off-by: David Matlack <dmatlack@google.com>
---
 drivers/pci/setup-bus.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/pci/setup-bus.c b/drivers/pci/setup-bus.c
index 4bec76950f46..b82440394ee2 100644
--- a/drivers/pci/setup-bus.c
+++ b/drivers/pci/setup-bus.c
@@ -311,6 +311,10 @@ static bool pdev_resource_assignable(struct pci_dev *dev, struct resource *res)
 	if (pci_resource_is_bridge_win(idx) && res->flags & IORESOURCE_DISABLED)
 		return false;
 
+	/* Devices preserved across Live Update keep their resources */
+	if (pci_liveupdate_is_incoming(dev))
+		return false;
+
 	return true;
 }
 
-- 
2.56.0.212.g129ede20d9-goog



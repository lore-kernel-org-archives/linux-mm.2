Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 08F26C4450C
	for <linux-mm@archiver.kernel.org>; Tue, 14 Jul 2026 15:15:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B45816B00E5; Tue, 14 Jul 2026 11:15:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B1DD66B00E7; Tue, 14 Jul 2026 11:15:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8FB136B00E8; Tue, 14 Jul 2026 11:15:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 5782B6B00E5
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 11:15:16 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id BE23A12041D
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 15:15:15 +0000 (UTC)
X-FDA: 84987730590.13.5D87B2A
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	by imf08.hostedemail.com (Postfix) with ESMTP id 1038F160005
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 15:15:13 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=ts2SoC9Y;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf08.hostedemail.com: domain of 3gFJWagcKCNcOBIBGLA9HH9E7.5HFEBGNQ-FFDO35D.HK9@flex--vipinsh.bounces.google.com designates 209.85.210.202 as permitted sender) smtp.mailfrom=3gFJWagcKCNcOBIBGLA9HH9E7.5HFEBGNQ-FFDO35D.HK9@flex--vipinsh.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784042114;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NOi6e266Y3mSv+Tn1Q4zn00EKJBjh0V4SkK/1ApFkGE=;
	b=OP8/3pB6wgypq5++KK9MULYD7SECbL8iSAPzrABHgtvNqX4C+8j0bjHstxiI/07f852Cjh
	T0dBpwAZ2tMf4f5NgPS1agFN4OxhpIP3X+r4JYzlbuGPJCXZ0saU/BRJMU2vDbfb8Xa0Uq
	Unr6PTpgi0aW7D581PY74b9S8FIUuvw=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=ts2SoC9Y;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf08.hostedemail.com: domain of 3gFJWagcKCNcOBIBGLA9HH9E7.5HFEBGNQ-FFDO35D.HK9@flex--vipinsh.bounces.google.com designates 209.85.210.202 as permitted sender) smtp.mailfrom=3gFJWagcKCNcOBIBGLA9HH9E7.5HFEBGNQ-FFDO35D.HK9@flex--vipinsh.bounces.google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784042114;
	b=07gWgrqExfivyi96BdyRF05OQ9rzSznL59uV7RmMLO4nzKqfEccX2pWa9qCu4fDXdm2G/7
	FSFiQMXcgnjkNxvpKl9/VlUxfdKUkWkYCBfYMAuv/XEnAFUTAQFMRmxZU8Pl4WZLPdhjRo
	wj75Ht8TUV8zoI3XQqdPIUfQd72NFXU=
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-848551b54f5so8620403b3a.0
        for <linux-mm@kvack.org>; Tue, 14 Jul 2026 08:15:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1784042113; x=1784646913; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=NOi6e266Y3mSv+Tn1Q4zn00EKJBjh0V4SkK/1ApFkGE=;
        b=ts2SoC9YBHps7BQBGx24zo/k1DDQpBeiDJcRo+b6+5lvdERaCmj3LRw7xmjb1nQCvL
         LMTw1aPIYq9Shj70H5+2fkofSDqNQ/eC7WutrBCgF7XZQaQ44kAtYyM832sbtzi6d1t9
         e6gBzDwby2OHxvvp/Z8djCKHvnu9DRwcpfN9IhkcIpVrZeQ3+sYwp51ZGNWMGrROSdqS
         Q0bUnPJx4kkURhujfzx+Msj2XJSgFdErLqxtYmgsbudfzAx+/JF5JL7RpGpLClx+7Fi6
         TdUmq8/8BhmgKP1DhJycL6i3zcdf/hLxWOjFMtMeRQQwJ1ZRdj7lQJw4JW/WtzM5On7A
         sGRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784042113; x=1784646913;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=NOi6e266Y3mSv+Tn1Q4zn00EKJBjh0V4SkK/1ApFkGE=;
        b=ULZHuH1VrZzy+ZkUYjO0s4nIcMXB5w/82RJ6qXn8AIKD7cGWK4fMtJ0T+7xXw1juXT
         uaIOgbsuCD7vRcPEgwfE12LFOhcmScjlihF+XIIRb3zP5Zk+RKJduEdpdnjgHLdlzaHX
         mwCrunQ/XoL+ffFGsuiKvbpA4GVNDeKkcSMeBW+JRRDk6eh2d03ra0AGE7zWB1tOhehL
         Wu0Gk+U+2nKfcOaoF8kaHQU+ZQGdMYVk/abnsH5c7CgyntxEoDQ6pOg+AG5SJDiJv3XH
         8X4q1fK/lfyqm/hyrADIQkssYX2KeWLH0YSkkzmb/T2DyTz7pd+nWDk8grNpdH6lBynJ
         OF1g==
X-Forwarded-Encrypted: i=1; AHgh+Rq1/k5JDX4vkEHRPxba8YJTKUrcqP7dYwGbwV+U9inbOs6Cazz//y8OxZ0jhhtaVTtFVprwy2ObTA==@kvack.org
X-Gm-Message-State: AOJu0YxPjzmASxZCljrIJUtk0HwoBK376DT/7XdcgSzDFOFaEhQ3ngx8
	/nKBdkGgkgqz8beDV++/0T/0aC8t7GBb2jtCXv28wTycrwfDpyEAnde7kE6hNoGT6NrP8jLgc2v
	XJLYn/EAcTA==
X-Received: from pfee10.prod.google.com ([2002:a05:6a00:bc8a:b0:847:a829:37d1])
 (user=vipinsh job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:a27:b0:848:2f7a:2e5e
 with SMTP id d2e1a72fcca58-8488976671amr13012571b3a.77.1784042112537; Tue, 14
 Jul 2026 08:15:12 -0700 (PDT)
Date: Tue, 14 Jul 2026 08:14:48 -0700
In-Reply-To: <20260714151505.3466855-1-vipinsh@google.com>
Mime-Version: 1.0
References: <20260714151505.3466855-1-vipinsh@google.com>
X-Mailer: git-send-email 2.55.0.795.g602f6c329a-goog
Message-ID: <20260714151505.3466855-4-vipinsh@google.com>
Subject: [PATCH v5 03/20] vfio/pci: Export vfio_pci_dma_buf_move for vfio-pci module
From: Vipin Sharma <vipinsh@google.com>
To: kexec@lists.infradead.org, linux-kernel@vger.kernel.org, 
	linux-doc@vger.kernel.org, kvm@vger.kernel.org, linux-mm@kvack.org, 
	linux-kselftest@vger.kernel.org
Cc: ajayachandra@nvidia.com, alex@shazbot.org, amastro@fb.com, 
	ankita@nvidia.com, apopple@nvidia.com, bhelgaas@google.com, chrisl@kernel.org, 
	christian.koenig@amd.com, corbet@lwn.net, dmatlack@google.com, 
	graf@amazon.com, jacob.pan@linux.microsoft.com, jgg@nvidia.com, jgg@ziepe.ca, 
	jrhilke@google.com, julianr@linux.ibm.com, kees@kernel.org, 
	kevin.tian@intel.com, leon@kernel.org, leonro@nvidia.com, lukas@wunner.de, 
	mattev@meta.com, michal.winiarski@intel.com, parav@nvidia.com, 
	pasha.tatashin@soleen.com, praan@google.com, pratyush@kernel.org, 
	rananta@google.com, rientjes@google.com, rodrigo.vivi@intel.com, 
	rppt@kernel.org, saeedm@nvidia.com, schnelle@linux.ibm.com, 
	skhan@linuxfoundation.org, skhawaja@google.com, vipinsh@google.com, 
	vivek.kasireddy@intel.com, witu@nvidia.com, yanjun.zhu@linux.dev, 
	yi.l.liu@intel.com
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 1038F160005
X-Stat-Signature: tgkqoas9yqnttz9rifjzgayukn71d8q5
X-Rspam-User: 
X-HE-Tag: 1784042113-690312
X-HE-Meta: U2FsdGVkX1+jlkLeWDd5XISHxAjHiUGPwzc9PcU1IRBnLny6jwCeXFR2DlECPKYBypndtwFlmG21P9fPROepBcYen7LcDNp8wGcRPz+IlkwF7IjWbI6Oili6bsg82bdrRWfxDaH/F4n3vbHylVLmnw34IR/XoXVdU1hCb6wnshzG2cH/mufYoZ/BRJOJNVlLy4bJOxrjE9Eh5jvVsJRuN66gIald1VSkyrjG7eX0SEEI1W9xF4PRuu+rvsywHx3w3PeGgHCMgfOdid6SIvCz1Wgtj7bDod9JLVddlU3Ucn7fPqjT2llSdOY+ZhOSBGbo2hrTvQie+PpouyfYjYmlPC6v7gGlTP+YP9OwFjjP1YkYk/+/ueKHb0zJfFImHbImgDy5mV5jrGFQ/z0IqZ71mrtoVPY95BKQGZBVehOcxuXp8/Y12H2ijZCAPNXD8LbvCYWqcUblKz2VRYNSTSfr5Ao8BEmDDNehKP0NmGbyVlJNBp5MOpx49phtzwFaH4kkqZZq7eqNfe/G20NHlk1B+jbBWeTXd25kXwXwX1IMUp4JM+UsqiMbFll7Ot5wPPdBIWyC3NBr83aqY63n/h4E1VP2G6WzsOkiJne9T28ZT3DxjHn8ofbEIJRuXiMqkzxd5QOCz2qMCL5aPwVhtdyUyL24vF2xF2NDct/bdwF3PljerCjERlXkRrdCIJODmDhqMbsCcAIPVu/TAQEggUApPyXychGN+f/B/x/QWv5BdcrwHJGvTLFQpvbwvVFSSp40zxh1QSY6W6LpMH0ItO5ExfBFSmv3zSFxjR1ZWfcDNOg8+gFa0El3DoQP0myWyB8Z8l8N8xnXwF1c/Zs4M+85Sos2Y35nJEEx/9p4VXXtYbkGXQy7wAGGiRSBHfKoNesa6oWCKKCMzjxHNlwJ9vlLOwCDdAHrSplPfNAVEBf6rQTnIV35o5P4Z3wZG4/uob0yDLj481/zYP+9bLPvQRF
 bDhikuuX
 /RWxDdW9g/yr4wuYS99NlZ1WrxgPV0CSnbcDGC7DOms4n3yjo9gAfVm0UgcuacYT0KWNiBjiQU9v49Tx5FsoPI0x8zDLZBGRG39o3sMAONHggkhCJcTQJjDZm3CNkQ/bo6UlAND7sGkG5fayc71rmOZ9Mq9412ZNVasinhThX0vHIVsbJrp4Y+Be/Fh646Ws8xapHHbah1SZi0XdC2b9pxVLEEwvvgJYshb14TI920p6kk9xK0YIMUxhOtsbbEV/JtWI6MffWKMOgFy00sXvT/7VBH2FtDJxreeCvyQF0hyd7wIPm3Adbatjx3BLZklH0ht++Bcf3aVwZqo/455aPD7CDVy0I8afgzhM5qBEzbgGooN+WzESZyxhbilvv19fNAuGt3qaq9kDTWLp+zawImGKOCuG/x43mehBx8AWdIe/rxpgRpaeHMKgSgZCd+be/djwBMwHXHfR2mq8/REdymioJXwLlpk7zzmQXGXN44fwZE/cfJGRKTnh/hxe6oRj5s9OQOXtAe/GVIBbuxS7coYkVBLlT7H5M6sa4Hp1RLnclzC8rtGgnVTlNhJAYurUXGppCdr5SAkZpjE9xLEcOjDksJf2prLl6gsLmEEK8ywRLgp4VuglJvG5y9chzLdIEdZp4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

VFIO Live update during freeze needs to reset the device before handing
over to next kernel.

Export DMA revoke function which VFIO Live Update will call in its
freeze before reset so that P2P DMA doesn't error out or cause some
other issue.

Signed-off-by: Vipin Sharma <vipinsh@google.com>
---
 drivers/vfio/pci/vfio_pci_dmabuf.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/vfio/pci/vfio_pci_dmabuf.c b/drivers/vfio/pci/vfio_pci_dmabuf.c
index c16f460c01d6..2c05fb5a171a 100644
--- a/drivers/vfio/pci/vfio_pci_dmabuf.c
+++ b/drivers/vfio/pci/vfio_pci_dmabuf.c
@@ -376,6 +376,7 @@ void vfio_pci_dma_buf_move(struct vfio_pci_core_device *vdev, bool revoked)
 		fput(priv->dmabuf->file);
 	}
 }
+EXPORT_SYMBOL_GPL(vfio_pci_dma_buf_move);
 
 void vfio_pci_dma_buf_cleanup(struct vfio_pci_core_device *vdev)
 {
-- 
2.55.0.795.g602f6c329a-goog



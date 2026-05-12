Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 63AF6CD4F40
	for <linux-mm@archiver.kernel.org>; Tue, 12 May 2026 18:49:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D8AB86B0093; Tue, 12 May 2026 14:48:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D16DD6B0096; Tue, 12 May 2026 14:48:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BDF426B0099; Tue, 12 May 2026 14:48:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id A45196B0093
	for <linux-mm@kvack.org>; Tue, 12 May 2026 14:48:57 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 75C691205A9
	for <linux-mm@kvack.org>; Tue, 12 May 2026 18:48:57 +0000 (UTC)
X-FDA: 84759654714.27.98C1680
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	by imf07.hostedemail.com (Postfix) with ESMTP id B61784000E
	for <linux-mm@kvack.org>; Tue, 12 May 2026 18:48:55 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=csmxcO5M;
	spf=pass (imf07.hostedemail.com: domain of 3FnYDaggKCGcIRFYQFHPLTTLQJ.HTRQNSZc-RRPaFHP.TWL@flex--dmatlack.bounces.google.com designates 209.85.210.202 as permitted sender) smtp.mailfrom=3FnYDaggKCGcIRFYQFHPLTTLQJ.HTRQNSZc-RRPaFHP.TWL@flex--dmatlack.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778611735;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OwTVELbnzNRdH2phaBPDBaeaYhhwivLmx4DuUtuYrYk=;
	b=HqK2O3+ibaelltq93mh1tWG1MpjcKhwth+MiY1ewWEPyO0PuRDnqGjAnmYE1OxE2HjuHAM
	VkCo1B2Bx0mweeZWOICwYqbKEbFlnlAbdFLyWnmGosjpTSpjVy0ARn7WO1aXsbYD15EOZl
	o88gzWVLWhJ5DBXUp4YpcSMMep7f330=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=csmxcO5M;
	spf=pass (imf07.hostedemail.com: domain of 3FnYDaggKCGcIRFYQFHPLTTLQJ.HTRQNSZc-RRPaFHP.TWL@flex--dmatlack.bounces.google.com designates 209.85.210.202 as permitted sender) smtp.mailfrom=3FnYDaggKCGcIRFYQFHPLTTLQJ.HTRQNSZc-RRPaFHP.TWL@flex--dmatlack.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778611735; a=rsa-sha256;
	cv=none;
	b=BSsZGrL8mT29BheKYRGzXeFBPQZqheyBsEz98CFouI345Gdi5fnAHso/xEWCqlpN9Sq2uk
	4VFI44mDBdd9aFwF0sa5zrJem1P9Vuu+UDv/FoYeiUjt/bHu1LLAGpuJ5bPAvuyEaLda7M
	gqT1vpdFWNq10N2NFt5nZosymGQCZWM=
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-82f6e6a3a76so6418241b3a.0
        for <linux-mm@kvack.org>; Tue, 12 May 2026 11:48:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1778611734; x=1779216534; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=OwTVELbnzNRdH2phaBPDBaeaYhhwivLmx4DuUtuYrYk=;
        b=csmxcO5MZLd6fBBFhctSSjPqiBym8WHadxJae0tRt8QtPCjdAuvvGeyg6lpjSaw3xS
         L8609mNITyPCqXFP7Uc9wL3jr/JGFagpmK7d6Z0FtLs6ZC6+5KghNQMe/bmBq/W/dKMx
         MBO93kvl0dJc8X32uZeyALFn5L52NhTNBFncLte8JZvR+EtrAj+Mh5OBh4mlcSo/+7SQ
         ah4aYL3pTmTNFQ/wR08WWbJ1kPqRRZLFotuNAyGkm0WTgiOLWeuRn4Gm1biFGd6RqJOj
         fNad5McyK4t0Gy32MDYpPj63cR4fXKaWbhK3PceGMLVEZigLTe/jMdgIDxnwBdDDZ0XQ
         We0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778611735; x=1779216535;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=OwTVELbnzNRdH2phaBPDBaeaYhhwivLmx4DuUtuYrYk=;
        b=q0wyB50XRJmG4i5MrjyTNXInK3hOm/onyco0BI376723jXz1UgBH942RM4WDq9Rli1
         nz72BRuLo927sHGZdPxbTPklccUKoa/IbBnuETCmTzEsvlQU9TdXH3LWzF6xfKYits/Y
         hcMRw0qpnkXjk2jQ4aaFXqrFY/6ZBZL1WL39Fwmqs+PMEFwGiN2D6Aa4una/mI6Qz7TQ
         ypsAmORubavDFWDwb4t1836KS/VNUJrz4q4fKVi8eVzvfStKVfaiB4ICYp9EBghtchhw
         gqhrlfLuF1C7hJ8noewTl6uTA7JEqwg8t887zM5khRyE9Q+NPQnib7fLAukxI6Q4u/FS
         1l+g==
X-Forwarded-Encrypted: i=1; AFNElJ95hWDOhDa7RUHtsO59ukTh28G48Lj1LHaesN4ZFvsifXj+rSErpFnRwZDG6fSFKqj7EruHcYDEqA==@kvack.org
X-Gm-Message-State: AOJu0YwZaJDggbodNqA1XvaBTot+b830emOORSNy65J9O1jxV6KmR9sI
	TtxGxT+Zqi3vSSc/0DvYS85VMlx4qQ3kIqvysd5C8ZY4jZD09EwcYfXPiJulOJta6El37cvgW93
	UZ+9Q9vO8oP533g==
X-Received: from pfbfw6.prod.google.com ([2002:a05:6a00:61c6:b0:83e:c864:caf2])
 (user=dmatlack job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a00:2e83:b0:835:405a:7e62 with SMTP id d2e1a72fcca58-83eebe71c57mr4745750b3a.33.1778611734335;
 Tue, 12 May 2026 11:48:54 -0700 (PDT)
Date: Tue, 12 May 2026 18:48:39 +0000
In-Reply-To: <20260512184846.119396-1-dmatlack@google.com>
Mime-Version: 1.0
References: <20260512184846.119396-1-dmatlack@google.com>
X-Mailer: git-send-email 2.54.0.563.g4f69b47b94-goog
Message-ID: <20260512184846.119396-5-dmatlack@google.com>
Subject: [PATCH v5 04/11] PCI: liveupdate: Document driver binding responsibilities
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
X-Stat-Signature: 5x88thsu5yzj1rpybk7uarxrympwm556
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: B61784000E
X-Rspam-User: 
X-HE-Tag: 1778611735-763171
X-HE-Meta: U2FsdGVkX1+8/hmrpFQO5DAVykNb3zEkJh9KYlhSGtTnMvKiXNxQ2l9lhqpa2crj2Qj4vg8AWFQXkSV9Jlc8OlrQ5xffLm071YUiTe9CfgkLLBfnW/Gt50TCfua0LIDOjeumgNk6ZArwwq6mFkEhUGv5EMgtY3OG7EpqSBOaWcho2d8b2FpzonO1H2g1cPwmfbXwHKoKHWVqtPcf/EweSciyGVh0zVd5Fv44x9xhHwnJ4+w7RdT85NOIGWDFklbfcMrGxR/UTm98QEVpKLJeJT5haCkv5n5a0TQVA0MwgDgnQsw9TEn44eY+Km5fBqvVA3wkTPPykLbYE0GsshKWYYnbWnMTot1Lvh7eZZx5t/UW9Kx6AJF5vmh9tuR6R3ECsHkEI/73DQgQMMK14vDihUAUNku03L4rb8XVTYi9kJT6akPJrFBP5fvVDlt/PP1fCFh0dQsU5JmBp/mdo/oiO8a4eeMwhV0OZJvXoIU7aSbP6K6BY6VoDuGHOs6VUT6Ops8XFgB2HH2oqiFDpdBhGlXwH/AZlhBp/EyqsR9XT1ojxLSHVJnLmZjwOWycBvFkLMzoWl6ZaZD58QZs7o+QOkJJFqV//eXg81T9GOGT+7N5SogE4NEXEY23LY33+tLgddE+UGUiV4rskPf91DPKT9Yxry2nSPvrNmWT48PnI1tnBBO6SkfXrhdi9ITywAKNM9Atk11gBTQgwabywNj8fRSIlGaKw/cGz2UAP2qFCndZ9OtToGE9cv+6nC9gFsMyWR6EGtsG7JNwOowSG07qxmnEoE8BddbOHeHBAgb1f06mFJ5iqMacydZJLGOr1Lc3bK54aPyxVFQYq0scaMiPoZzSR015KXWcPH4j33PqTcyiZ55JzXe5eObOJ9j+hPrJU/rGj3BtdN3GTSFNjkYZrBQnGJatdQjaQZeFlh3luW3OJEAw1g4Gru4yZf9z7UD6zXXsV/oD0I0d/67tWx7
 rzWURsoo
 L0s9XhL0Bk23BEVoBuSfTDRhOMXmoAW4v9nMgoe0qgoJgAQiR+Tyn439N7G0mhJcLoucY9wQbTXr5KUKTlnB70/hTCjfB0i2ZaGTqHdPszi7Knx31Cam8zzDMNaghxG2+wwLSum0ldlZj2BNmRCMEcnug6wU12TPd/gHSGNXTbnJ/Ofa3M7kpAJu3iHAD/h7V+IRa3Z0257islGBSbKxY+4+nYzfYt6oGbOxgE86/wedWd8r1I3FoM863CpqQAGDHFSuqEbcoa0yIxdbsIljfhIoL09GR+2MKh4Ia8FtMeV5FH+3dS66JixT8IzNkKCCvtApSNMnIf+Ym/zMn9gqzHeUwh/I7xJv2zggVLbtdm1j/Ky/XNOE4qbLg9S7PV1HDMqUbZsFKQBOrH+yAa/r0m2IqZ4SzYOkojZTpzi35IYthsPZaP1Oha+qYMKmoxPluOMDWz3Qq20UM/L+C3A+f6b4A1AMwuKtyUdffXA0rqPPJy7ZCh/LGnaWY72ZLUHHi6bRX0FoAj2eHBFS2ANIrlHRR57EHHgZO3gzT6S+xX7OWOQUmtqGKZczGrcV7rPxxn4H1s9HtAmsYLLI=
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

Signed-off-by: David Matlack <dmatlack@google.com>
---
 drivers/pci/liveupdate.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/drivers/pci/liveupdate.c b/drivers/pci/liveupdate.c
index f14396dd1477..d77e64906a25 100644
--- a/drivers/pci/liveupdate.c
+++ b/drivers/pci/liveupdate.c
@@ -77,6 +77,22 @@
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
+ * bound to driver B in the incoming kernel.
  */
 
 #define pr_fmt(fmt) "PCI: liveupdate: " fmt
-- 
2.54.0.563.g4f69b47b94-goog



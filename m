Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 74B19FDEE51
	for <linux-mm@archiver.kernel.org>; Thu, 23 Apr 2026 21:23:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 958706B0095; Thu, 23 Apr 2026 17:23:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 909186B0096; Thu, 23 Apr 2026 17:23:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7D0986B0098; Thu, 23 Apr 2026 17:23:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 63D186B0095
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 17:23:30 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 0AA93160566
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 21:23:30 +0000 (UTC)
X-FDA: 84691096980.25.16D53D0
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	by imf11.hostedemail.com (Postfix) with ESMTP id 4CB0C40008
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 21:23:28 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=eHvdYwTO;
	spf=pass (imf11.hostedemail.com: domain of 3zo3qaQgKCOkOXLeWLNVRZZRWP.NZXWTYfi-XXVgLNV.ZcR@flex--dmatlack.bounces.google.com designates 209.85.214.201 as permitted sender) smtp.mailfrom=3zo3qaQgKCOkOXLeWLNVRZZRWP.NZXWTYfi-XXVgLNV.ZcR@flex--dmatlack.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776979408;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cA/8iRDD7lhVYHGAuqnc3aBzPoZ7lUU2DgL4E3vJPEc=;
	b=qyAoAjD8JfrF6A5bNTrWSOlB9KLGOioxtER1c81PdDTRy9+tHzOnMYPxBopzUyVgDYu3CD
	OxJOI+7VJ/r9JUzkoG6wAg/GJqAYggxt32tKBfRCl1Iwl+HjtWC8XatLH7ykzWxwjoifqY
	x5AYEdYbO/fIYOiktjcDxH8GEGdLFfo=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776979408; a=rsa-sha256;
	cv=none;
	b=HARrRJ/f3vMmC1K79wevDGYoH5CB4eWtNU2zgKfdQWv++MHQ+GGchcvVOHK+358MvWE3Fl
	LnFdQX624a97vc6ueY7WTpAu/90n3JqDBLsf/YZg8iFMA+lPHyU/yKWY7tih+4a4RoHtZd
	jl4swVLNUj8RSl6ZtXsEpucVDVyP+64=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=eHvdYwTO;
	spf=pass (imf11.hostedemail.com: domain of 3zo3qaQgKCOkOXLeWLNVRZZRWP.NZXWTYfi-XXVgLNV.ZcR@flex--dmatlack.bounces.google.com designates 209.85.214.201 as permitted sender) smtp.mailfrom=3zo3qaQgKCOkOXLeWLNVRZZRWP.NZXWTYfi-XXVgLNV.ZcR@flex--dmatlack.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-2b2e91add2aso62181625ad.1
        for <linux-mm@kvack.org>; Thu, 23 Apr 2026 14:23:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1776979407; x=1777584207; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=cA/8iRDD7lhVYHGAuqnc3aBzPoZ7lUU2DgL4E3vJPEc=;
        b=eHvdYwTOIgOB6UDk/4zzZB8GH5IiBcKm9Qh0oxRV62aH9GrdkpHv9oA9S8aVtBs8SM
         bDxPwC9iFPUlqEU1OCn7MsJ9PlC6HPOtnKJnmVnhvdVaPMqhqgJxwgSDmR8qMiTnBwwQ
         mW7of12J8y8ajOx3A/xr8z7W07Eoh0rz5oTpsroFfpcGhV1EWS6sMj80NdU6lK3Z/XKO
         gsgYCH1VhfBAupPR6YPZjaDIX1n96syQiRotmSaQUD7jJJQmiumWfusFHV0/sdA5yvkF
         oQj95vVikBhqRhvIy/+DhLaJpxCIYuBkT8gQaqAW6P2dDGjiv2NIQadmblA27p87/ZBl
         22UA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776979407; x=1777584207;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=cA/8iRDD7lhVYHGAuqnc3aBzPoZ7lUU2DgL4E3vJPEc=;
        b=pGwGWqYIarM23f96qhotFOd5idfpKGZVDlUehbVMFjZqWqjqLJbn0/OV/MP88BGk4G
         s6KEEFFC2LTNxfEh21dA9NUviw9NGFIysLJJTUKD1s3lCWZKq6nLtGWhe4cSv2aPOKgj
         M9aj3jmbm5wT3zVa6u+VnRHISrCxVBz3t1XRJtliNn0qXpSFc+0itSqYSBQyE4C4KkND
         GKmRWI63ssu5FBkSFU4knv5J0+oiers+FA8YjfIVkyES6Si0Ff45qMJzpkR+K/adGQeT
         4FGKtw9yJjt6pdhqb1Krsk7OWGC39h184sOrkd+PwUQSW9xdcudLcce96mHqNN97Xg3m
         StkQ==
X-Forwarded-Encrypted: i=1; AFNElJ8nEN/oP5UXm+Dien4kCG7QWE2o90PFq9tjm1uV9NzgC5NjgIUZaKpTJM12btyk58P5DGmCgDbYTA==@kvack.org
X-Gm-Message-State: AOJu0YyCP8niGVbryjAMyhu3IufJmbFvRDt65V9d6TNwxNESg5apfEv/
	oMidAZ0D0LXQ+LvyrBjIzYfD5Ywgr+w8eew6viPq1mJgMA2uj26Zs4eo1wH6IRXTF+UFO5U/JiQ
	TsX1WiAU+cXDV+g==
X-Received: from pgjm19.prod.google.com ([2002:a63:fd53:0:b0:c79:7f30:5d18])
 (user=dmatlack job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a21:3399:b0:398:7982:21df with SMTP id adf61e73a8af0-3a08d687673mr31625673637.9.1776979406884;
 Thu, 23 Apr 2026 14:23:26 -0700 (PDT)
Date: Thu, 23 Apr 2026 21:23:08 +0000
In-Reply-To: <20260423212316.3431746-1-dmatlack@google.com>
Mime-Version: 1.0
References: <20260423212316.3431746-1-dmatlack@google.com>
X-Mailer: git-send-email 2.54.0.rc2.544.gc7ae2d5bb8-goog
Message-ID: <20260423212316.3431746-5-dmatlack@google.com>
Subject: [PATCH v4 04/11] PCI: liveupdate: Document driver binding responsibilities
From: David Matlack <dmatlack@google.com>
To: iommu@lists.linux.dev, kexec@lists.infradead.org, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	linux-pci@vger.kernel.org
Cc: Adithya Jayachandran <ajayachandra@nvidia.com>, Alexander Graf <graf@amazon.com>, 
	Alex Williamson <alex@shazbot.org>, Bjorn Helgaas <bhelgaas@google.com>, Chris Li <chrisl@kernel.org>, 
	David Matlack <dmatlack@google.com>, David Rientjes <rientjes@google.com>, 
	Jacob Pan <jacob.pan@linux.microsoft.com>, Jason Gunthorpe <jgg@nvidia.com>, 
	Joerg Roedel <joro@8bytes.org>, Jonathan Corbet <corbet@lwn.net>, Josh Hilke <jrhilke@google.com>, 
	Leon Romanovsky <leonro@nvidia.com>, Lukas Wunner <lukas@wunner.de>, Mike Rapoport <rppt@kernel.org>, 
	Parav Pandit <parav@nvidia.com>, Pasha Tatashin <pasha.tatashin@soleen.com>, 
	Pranjal Shrivastava <praan@google.com>, Pratyush Yadav <pratyush@kernel.org>, 
	Robin Murphy <robin.murphy@arm.com>, Saeed Mahameed <saeedm@nvidia.com>, 
	Samiullah Khawaja <skhawaja@google.com>, Shuah Khan <skhan@linuxfoundation.org>, 
	Will Deacon <will@kernel.org>, William Tu <witu@nvidia.com>, Yi Liu <yi.l.liu@intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: xg8qj8myaagie1h4ws5y6unji1i1mdoy
X-Rspam-User: 
X-Rspamd-Queue-Id: 4CB0C40008
X-Rspamd-Server: rspam05
X-HE-Tag: 1776979408-689166
X-HE-Meta: U2FsdGVkX18RRi1whXTH+LCz0F1BW1r5RHbASUCWF8URzzTUxvDoyXdwcgQ+sdA5Gq/JvfCusMVVQiNKqs6VkA2yzAYAZv17Ez2cvasKgdtKWfemcCn5gKZer6ewmIcLA0Azhhb6j4lwCpKU9BmDpi6Ya6RYZpXLor4dD3or6GfInMWY/26qj40TRezLR5WQOwW1mWGHFhZobyAMzrUEihuQhQV7VzSaHdjbAan12jyZjK2607TygD33QrwkyIuuw/6OIQXXkHoKRbcWm5ffrxEL0pvI9l6SCaTCkoo4yqpvHfeYya/aE30lRdQw7bYgfChWqeBmFrMn3eG3Bn45FXJ1OmdzRs/eVB6N1WYn8DI0N4/hQZgtXYHw2eji9s4drfTUwMEmZL4up13AcHy//GfU/NCx20uBJVokRpG0H0/HGpYVjKbVW//FQFc9iIiqih+V6b+lR5kiLwXkCM0KYwuuDZ9E+Vd25FuBCQBOT2mGZTOJTGHc87df7tAWFtKxM9bMXhiFkrdaz0PHy4qaAPxqfmBkCqggXUi3UGfy6FO3dGBGQtXPUMfamhXnxd9VIk6hEsCQSr9ShXAn6q3WqUHjpFjhiG/3F5kS5/UKH/mPTJxl1oPszfXpmySLpd2/dvTt7EOr60GseFEnvUNhHg+a3iDIajA5BVj5VmFKw8cjxbPTg0VvNfnffquQo+VGCPPf+RfVMmL6m/FiFs6hp0hQmQzNYylPrxT2iD2SZ+3VpkRJxDEwNtW25wTZZkrmDHgCwwsSF7xOgjdmSJeOq4gNKIxEkYys6AhuaQqG83rImAJc+6LVbNUJT7iX+QWA2k0ZEx5euPeJVSCKTifyoTPKHmyQrrApuBUyvaPr+7x0BhApcMn5bpygaxuOcbvSQKIBAoBk4ad1/dxyDdwRJlJlQY4BKs+rC7ADKavMLFsO/4OwrSTROKEkw5zh23nCdKeSKkyCvwJ3uwuP2GM
 KflFjVfd
 xP9q3nMznTEV9iJcrKSuO5CvuXzteiMRrxMA9RoFVxUdlFvM3ydA5q+u9RoCbVqKC/abvhhu5Vvk0p5x+1yi0rdgo59LTa7ga1KHLkm87Hxh2Vg7BVe1h7NIFAzroEAd6B/HPBXM2pbb9PvgwadUXZW54CjPIVRajmcK2hTymbyG9ugPwp+pMxQqciA1qYrCkP4sz2zt3d3AG078mucFYG38fERSw6vmHnMQS8KKakuN+nbQHM3v6/KEfpdKB+t9wWGaYD48eC3t0LjQUab25lf6EJoIMyaeDHnYczr9M2gXtAQ3DdySgCQ26LjSG8t6g8fqPDF2Bd5riyGaSkZ7Yg6+QNSCP/CD/ptNMrI750ncMwDqBFRZ4KsjAGUZLdnRFfGxjdsaBmoUtoi8zIrTWtYUWQSMtumjsvY6K1kRU4/rTzk+L0wjB0gSeDurZy/TrWaBmV/QhD78uiGqPpnvQqAbknlWMYrIA2D17ljVDg4Y9cAxCjnNzXJegrlYsY/IVKyYR96bgf9qKVi2qdOCWwy6r/EnNI3mpiEHSpmxEqDQHQ2tZi29pSab4YPYzQSGRThIVqLOtceKOqEFzfzuFpw0+6CZbuyHKp0UPLpJr/1aWFJ5kmpBE4IpNlRdZ2RWKQ5wRSSTrs0B/NejOWq7kcA8NwoMvVUOOZgwWDThh55r3Miw=
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
index e616cecc37c8..c0a30d16d9b8 100644
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
2.54.0.rc2.544.gc7ae2d5bb8-goog



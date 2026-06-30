Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F4031C43458
	for <linux-mm@archiver.kernel.org>; Tue, 30 Jun 2026 22:14:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D6EEC6B00A9; Tue, 30 Jun 2026 18:14:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D1E8A6B00AB; Tue, 30 Jun 2026 18:14:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BBFB66B00AC; Tue, 30 Jun 2026 18:14:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 920966B00A9
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 18:14:44 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 1F1C7120143
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 22:14:44 +0000 (UTC)
X-FDA: 84937984488.21.6BD1F90
Received: from mail-qk1-f170.google.com (mail-qk1-f170.google.com [209.85.222.170])
	by imf16.hostedemail.com (Postfix) with ESMTP id 433FA180007
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 22:14:42 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=hkV7PAYy;
	spf=pass (imf16.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.170 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782857682;
	b=TFHYV7DDdqiRTotTYj+dICa3HI1bEkXss201u0Z3bjlCnugOxvWDzZ8iIseECvOgI/AVkU
	UAHnedTt1RQhMmrZqqKyT3IAGUSkvg8O/oMVL4ZvOVuF7emT6i4dwzt2he/N64/RDLq6KM
	Vi5dCLto/fhxbR1npE0BETkIhpHwPjM=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782857682;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Zvvq7XwN+0vU39EaqWqw5+H08MVeyEUcwD3F1pdYD7Y=;
	b=tbn3t59mkHBqqUkTetKmI+1hdkyf1SOIozUq4OXh3GCTsbdREn0KT86SH0xRLl0yBmwchA
	/6GGDij+hiYmf8t0SwX8LnTKKBPgratwxffrlBa8naVUu6EMlm8xevhf6QhD1f3b/EcgtP
	X2l7a4e8M2ieUnV2KYUbJTGF+GkHWWc=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=hkV7PAYy;
	spf=pass (imf16.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.170 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
Received: by mail-qk1-f170.google.com with SMTP id af79cd13be357-92e4fd65b2bso910685a.0
        for <linux-mm@kvack.org>; Tue, 30 Jun 2026 15:14:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1782857681; x=1783462481; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Zvvq7XwN+0vU39EaqWqw5+H08MVeyEUcwD3F1pdYD7Y=;
        b=hkV7PAYyrFy5N65bS0iq1iz1unYpAgNMKw3EVmB7nDeJeUAjzOYVQ36gCiLzY/alEr
         o9+V6ZfZgfkK4qzqHFVfF5EnicLZ4XF/xHgD9lwDB8iNlpBA79+hFppokGyjmARHiamm
         WkNokS3zWrBkhUfMJCVwcKLE60TtZYycr0YYFj/GNzqIEtwScjfMajGNFRzsDoTEXxdt
         2eYJkKc+Bb0rV1YNkyKx3B0dRytQIlsfHNkhRbTQA/Y26177WCbsXbOv1YZoYaAN1zju
         QD749oFN38XjLdeE7nJHhyQXH/nGvAroGmLgTcJkO9vdCPc0c0aDfVGiX6K9JgRcoCgO
         zV0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782857681; x=1783462481;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Zvvq7XwN+0vU39EaqWqw5+H08MVeyEUcwD3F1pdYD7Y=;
        b=Re+X3u/IA0Hb7KKiFnEWw+55DNg9VbbiEOfYVvuvf6/qdkRB2/osRs28cEE05zfUD0
         pSGeNJehUSFTTdxhOac5HEb7IUTcpNg7RMd+cg1+pWJyqgNMROwdbI0x8NSh+JhOP9qA
         1ufbPUgo8d9uEVZhwnM9DGJSkySRTkiseroFRwQjcFRJuNxMdoQONYVDBrm5dsAsImXF
         blsOHpttVd2aZOamghrhjBMFbrzQ2HFlCgWUwBnJ41sk4xmVvBX3Q8h4k3QtG8+ir1s/
         DQ21XipPBwNxwT+gsMBBYqqORqHDUwNxLHNeGFWiqTNcRLsTmQwFn0nglYQiq3OSnvei
         NJ1A==
X-Gm-Message-State: AOJu0Yycz/G1s3mKEvJix55pLFo5fIlXWwCq+hNT5FzzeaDucA85j1vv
	VSbyLOrLEvuVJNYzy5hIpq2kWY99Ddjfa/rqIoBOoSy/xNAU1k41GIlFDx4SgaQnODKC2AfHkuy
	pt7fA
X-Gm-Gg: AfdE7clTajAeTj8U+iJxkdBgMFpjF2X9kelOa2aHsAAapgVzYb8O+GEN1P3/Wv3gyun
	tyXgwoTzS2o8H2ybSTBsHmai+LEXmFFu8bCUNln0xROJV57QvLI4iZalwhaLnpcAMdf5d4x4HFp
	UikNy9jP+icVeNguOdkpLdwmLOaKIDa1M2oZlMFaKbxC4n+m+73A5J7TW15NSSekDPI9SVcPlAr
	z4ZYPtBWhLaecq89SkaU+IHZOTqbe3jwa799jFeGDMxasb3Jo+dDCDHSyYYVaHYKrK0c618LFPx
	P2V9uk7ChoUnHEmoqTa1jMrSLAo1rPW+8zLyCh2bWi4JeSG9X3iUuBkOpzP64f4DB81xmqOJjWF
	4iGirc9RffzHU0TbiHHhgXRd3vb70g6kWBTeJh/rutYNMf/CL/KB2IalZmcmCVYXvd0eD5LOBW4
	KFuicKC5GkUcOLnuIAh5r1L/mFf/FGT5ZaQEJgsRozWNtx652CG167e9ue08L1UWVuLrCaIV5MU
	ipwe+8=
X-Received: by 2002:a05:620a:6cc6:b0:915:b852:4361 with SMTP id af79cd13be357-92e624e3088mr975087285a.20.1782857681333;
        Tue, 30 Jun 2026 15:14:41 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-92e6213b953sm346810685a.2.2026.06.30.15.14.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Jun 2026 15:14:40 -0700 (PDT)
Date: Tue, 30 Jun 2026 18:14:30 -0400
From: Gregory Price <gourry@gourry.net>
To: linux-mm@kvack.org
Cc: nvdimm@lists.linux.dev, linux-kernel@vger.kernel.org,
	linux-cxl@vger.kernel.org, driver-core@lists.linux.dev,
	linux-kselftest@vger.kernel.org, kernel-team@meta.com,
	david@kernel.org, osalvador@suse.de, gregkh@linuxfoundation.org,
	rafael@kernel.org, dakr@kernel.org, djbw@kernel.org,
	vishal.l.verma@intel.com, dave.jiang@intel.com,
	alison.schofield@intel.com, akpm@linux-foundation.org,
	ljs@kernel.org, liam@infradead.org, vbabka@kernel.org,
	rppt@kernel.org, surenb@google.com, mhocko@suse.com,
	shuah@kernel.org, iweiny@kernel.org,
	Smita.KoralahalliChannabasappa@amd.com, apopple@nvidia.com,
	Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH v6 09/10] dax/kmem: add sysfs interface for atomic
 whole-device hotplug
Message-ID: <akQ_xlJtXNgnGUdf@gourry-fedora-PF4VCD3F>
References: <20260630211842.2252800-1-gourry@gourry.net>
 <20260630211842.2252800-10-gourry@gourry.net>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="Ha7M+e+kLoFbO4pS"
Content-Disposition: inline
In-Reply-To: <20260630211842.2252800-10-gourry@gourry.net>
X-Stat-Signature: 7oywmdq37ra15x7fubdnnm1cfp4ywxyy
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 433FA180007
X-HE-Tag: 1782857682-55495
X-HE-Meta: U2FsdGVkX19I4qWANpkExLt2YFB+tpxAiSn4oDXwAHI6TEWNfm7UGbMR0o90dl7YkkWY6K2yg4sWNmT10x82uNAbA2sFXFf9QBOkexXQWtf287OFxLTucTmN5NIOSKUae5uY9i4bTKSk2lbQ29fJZSjxWsFMPtioRGcmanUnH/+YFXiRevXkHy6DivaLO2PnmB/YGyTmL8U/FFSYHVOXwiGuaLv7KfVKZc2tVfPaTJKX+Bure9uxr0EHWf1hsdonzib3H+t2Vw8VBVyu9VLy3IhxVeLwGA64u6JBii+/bzNS0mjg7BAkCa1O2ZMgy5DTUB9ycljlHlfD+C5/DB7cPAwaSO3SbZZNGo56WuiyDi9ywMG9BdrkYRvOvD0yq5TvIrPA8aRkw0Ik9CF6exm8KNiruj7nYPDSA6+MbXBHzTf8EkGg7mJjLc3Qpj+I2aIeRgDIxWZI83CG00y2XrjTLRPdaPGomtLgfbuct8dL7uog/SEEBY/aQCAlPh569mWhqeGOQNnt3z205dWaYbZ0kIMPbJ3aa4G/vouci6jfYyIqH2Jr9e7Qf8949RbDS0v19UVPj8CAdC1b26PpGaelE6MIA6QiW0FvNmwKMBV7memG8ll+0zwBjJxPc9wCaMRVy0tROuqhjcoSLeCYezxjnJH6Gl4bq9Z9Wp918tfVe7DbltI7q/9o9Lvf7aV58NKl5j6msa49P/g7KMthVQ3W+Ofo0V0dkUwDdOfnmzZrY9yzh88B43x+/ZqyuDiAI/Kz1KMkW+1ir6KkFGwdAKVpok+mwxnrKAc5ALj5Wx+o9G8e6aorFHJwnQ7lRyD55bSL1kANMKig8M7ok9/AleJ8OPFEMj60CUBzC2rLe0oscxwrKg4h54/1XAIKxrZp5M//S9Dnomg8dQYDl5bBLHZD12Eqh0ZhHXzO6XUkTzaGAQ2gxIPKD2vPPxdWH/VW2mSR2GI2obN4elO/vHwdR2K
 NYL2LSQE
 K+baoSpfBrWhpvjlwxPAapOJJy/b6o2UDOmRZNpUXxTAwS4GrHEaJ40sshU0BshOCnE18W4EKZCNM9CmS2GgHR3nYByKcA2FEufZ4VGiBRi9zR6ifMpvrfe5MThoM/VvllEH/kraoL5noJMFMG66Ro09p+ZktU6XXAfVA4sk3bI++g4SzoGphZZcC4BXX5qPxknmebCSrekK02xYS71lFNhwtnKO/UxzbQZuV5TgV8NIJDIiQ18m/majpQ050Uzd4Ep4LMYNXAoPfiaM/n4Xe4E3EfNqOQWynlktKfNdaR6K+7T4h1kbZCJofSYqOw7QSr+ay++UWaDua9GyquuEN4ZjCf7JLS80+ZLB74w6sLXBnrviM+Cjvee6I3IdBmgWsMkmVIlb3uWLEPUeosK1jD5xdrI6s52eehaEt3jgV3sto3n/mwCc7DTxYaKOnApgj+/TUjKsJFDvGenQvBd9WpfmKvg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


--Ha7M+e+kLoFbO4pS
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Jun 30, 2026 at 05:18:41PM -0400, Gregory Price wrote:
> There is no atomic mechanism to offline and remove an entire
> multi-block DAX kmem device.  This is presently done in two steps:

... snip snip snip ...

Sashiko pointed out a false-positive, but adding a fixup patch
here that adds additional consistency.

On total failure - release all resources.  This makes the sysfs
interface consistent with the probe failure path.

Just attaching a fixup here, since technically it's not a bug,
could fold in separately

~Gregory

--Ha7M+e+kLoFbO4pS
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment;
	filename=0001-fixup-dax-kmem-add-sysfs-interface-for-atomic-whole-.patch

From e341860c83fd5d5e8549d8adbf71a484c8990c5f Mon Sep 17 00:00:00 2001
From: Gregory Price <gourry@gourry.net>
Date: Tue, 30 Jun 2026 14:49:06 -0700
Subject: [PATCH] fixup! dax/kmem: add sysfs interface for atomic whole-device
 hotplug

---
 drivers/dax/kmem.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/dax/kmem.c b/drivers/dax/kmem.c
index 19effe0da3dc..f597d8a99c1f 100644
--- a/drivers/dax/kmem.c
+++ b/drivers/dax/kmem.c
@@ -380,8 +380,11 @@ static ssize_t state_store(struct device *dev, struct device_attribute *attr,
 		return rc;
 
 	rc = dax_kmem_do_hotplug(dev_dax, data, online_type);
-	if (rc < 0)
+	if (rc < 0) {
+		/* Total failure, drop the reservations we took. */
+		dax_kmem_cleanup_resources(dev_dax, data);
 		return rc;
+	}
 
 	data->state = online_type;
 	return len;
-- 
2.53.0-Meta


--Ha7M+e+kLoFbO4pS--


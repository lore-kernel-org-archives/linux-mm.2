Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 42991D2168B
	for <linux-mm@archiver.kernel.org>; Thu,  4 Dec 2025 15:10:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1E3766B00C8; Thu,  4 Dec 2025 10:10:19 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0AC0F6B00C9; Thu,  4 Dec 2025 10:10:18 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E40336B00CA; Thu,  4 Dec 2025 10:10:18 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D457E6B00C8
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 10:10:18 -0500 (EST)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 8ED6F1A01EC
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 15:10:18 +0000 (UTC)
X-FDA: 84182124516.13.29D73D8
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf15.hostedemail.com (Postfix) with ESMTP id 07DB7A002A
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 15:10:15 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=GMfw0sxy;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf15.hostedemail.com: domain of peterx@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=peterx@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764861016; a=rsa-sha256;
	cv=none;
	b=jtZ+YySyg+r6Q7kTwEQnmdPFIIn54rUJVmdxV2wnG9/hmqz+/zBWtqHFbdNSR8jA+1Z6cw
	B0eaFp9OyW4eMrFGn12Z6UxBhNWa/dkvk9CcHEfwStHie6S0xUHpar5PNnXVylJMGuLxMK
	2+fjUMcWNZEMpKEyzjo/MYaRTQt6UrU=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=GMfw0sxy;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf15.hostedemail.com: domain of peterx@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=peterx@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764861016;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=i3kfS3mg3HiGefUEuetCpDNaxRxqIsOmdjOWI6Qvpxo=;
	b=RHGS51tMlA7CqScF8FNf2QOl/C15gA7ZhBx08jcx6bhpV72TdSZi2Cf8jusRGA5hhOijC5
	Xiahr0R1yIAsb82rGdAFQf9AsUoJza3P8NZ0IbOsVSyfAMjHqyZZ1j01rVaFw3vkHRmaxA
	NwmPPHouifIq+MGLVbdQ2R3QzLF/JnQ=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1764861015;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=i3kfS3mg3HiGefUEuetCpDNaxRxqIsOmdjOWI6Qvpxo=;
	b=GMfw0sxyCZAMsxxVNUs50CR7L+mT3S596efhlBEPf9Ui+LYzVajWg6oopGrVZoUa62c75A
	f1ZX9XG4yfgEI5FARnb2k35Nn51168eSuiVg4YSszlao9Ky/erN0ix47H91CMfepF3Hm/G
	9X0Pl63K6eMqtfCI+vpzy9f6w70t3Jg=
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com
 [209.85.222.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-189-nEL-NvXOMx2E6J_LrQcFmw-1; Thu, 04 Dec 2025 10:10:14 -0500
X-MC-Unique: nEL-NvXOMx2E6J_LrQcFmw-1
X-Mimecast-MFC-AGG-ID: nEL-NvXOMx2E6J_LrQcFmw_1764861014
Received: by mail-qk1-f197.google.com with SMTP id af79cd13be357-8b244ef3ed4so251282285a.0
        for <linux-mm@kvack.org>; Thu, 04 Dec 2025 07:10:14 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764861013; x=1765465813;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=i3kfS3mg3HiGefUEuetCpDNaxRxqIsOmdjOWI6Qvpxo=;
        b=vmYHNrLqEmvyH7DC7qw7KC1zs1xWvcHIBILebxWjCvs5s6AXgVQe42AAleqnH5buew
         SYPTlFlToT5gslfhNTGetYWeoC2wbdGrw2pyjE3nRNPzgCuvgaO0e5G3OUNpE3G/6z8I
         vHmCowxM2IPeYYcLXSoKJ1keHzfKHWRt95br4pduHHECL2GiIWgfVnQ89JedgD6uUPGG
         O+OnIjhqtCEjKcyiyQ0xZxcE5U4tEWd739mhUFY1hlXZr+uKdJVKp274lbshQkSHxlGW
         eC+emb8T+bZoTNxRGu6qBLVFVEXI6ghQdong+pd158UfopGuGu2vLcVpxS1YAzJzi/Vw
         RNFw==
X-Forwarded-Encrypted: i=1; AJvYcCX387Wb86KnRiUReuRvbBjDe6bubvzqAQQlDobmq/GGL9BJRhKM8stOol6K3Cp88vB+9Qo0INdr8Q==@kvack.org
X-Gm-Message-State: AOJu0YwUrFSjyD5aHF05swFwm3YnuSqF77Ik+wLcb/tFl9Qklx3SdZEv
	fADmTmKu5V7kXw+n4gC2T4i8nKRj8PDcdhFYWJ+8rDEupGqn1ANOfZNMr/coFCiXezcPpqbK38a
	W4Iu2PwlgSgUrOjUtVJAUQQ3RhTcUUa8gFMWylpcP2I/dLal6xs8GiV3iOpHT
X-Gm-Gg: ASbGncsRJsHUein20iHZ9+urPygjyEfujMnGTJFdFfctZRDXVQjmsm9uoRDBUgDHWHN
	5sv/Q0AN/a1hCsV2zpfVRIEil2jaM2vT+90paZX9niFVTm0S+x5feCyibKjRIyIpGM9y56Q+KPO
	Q4Y9dlN2tsXmgRVrylh+OWDoDk1p9HSubaDYCo5flOpPXlTy63iheziOMxaFxEAl42SyVsl8r1Y
	tSRnHX+eGiHZHCP4ryjMQ3Gee3HJHxb8vzaeH5ML9lH06XqtzonZXccZvrC6se+hEffqEtMH3W6
	+EF8m3pQZkTdpfzHY8ZJw/rMSSRWP1AIqHmZcBsXAhnc7+LYmgn1m69GcDfe1+0Q9aAKcVdaRIf
	i
X-Received: by 2002:a05:620a:4095:b0:8b1:c48f:105d with SMTP id af79cd13be357-8b5e773519fmr795856085a.87.1764861012839;
        Thu, 04 Dec 2025 07:10:12 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHBkxqpioh6ZUgFWGNITjXJGV2mFH098xBMOQL61kY3xJnsMn9OK+8WpatADqnDH4w9UHn6yQ==
X-Received: by 2002:a05:620a:4095:b0:8b1:c48f:105d with SMTP id af79cd13be357-8b5e773519fmr795845685a.87.1764861012060;
        Thu, 04 Dec 2025 07:10:12 -0800 (PST)
Received: from x1.com ([142.188.210.156])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8b627a9fd23sm154263285a.46.2025.12.04.07.10.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Dec 2025 07:10:10 -0800 (PST)
From: Peter Xu <peterx@redhat.com>
To: kvm@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Cc: Jason Gunthorpe <jgg@nvidia.com>,
	Nico Pache <npache@redhat.com>,
	Zi Yan <ziy@nvidia.com>,
	Alex Mastro <amastro@fb.com>,
	David Hildenbrand <david@redhat.com>,
	Alex Williamson <alex@shazbot.org>,
	Zhi Wang <zhiw@nvidia.com>,
	David Laight <david.laight.linux@gmail.com>,
	Yi Liu <yi.l.liu@intel.com>,
	Ankit Agrawal <ankita@nvidia.com>,
	peterx@redhat.com,
	Kevin Tian <kevin.tian@intel.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH v2 3/4] vfio: Introduce vfio_device_ops.get_mapping_order hook
Date: Thu,  4 Dec 2025 10:10:02 -0500
Message-ID: <20251204151003.171039-4-peterx@redhat.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20251204151003.171039-1-peterx@redhat.com>
References: <20251204151003.171039-1-peterx@redhat.com>
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 3OWNG9gj4ZL16qIb5vU_Cp-3SmzlRmAtxGd7Lk1GZD4_1764861014
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 07DB7A002A
X-Stat-Signature: uk6w9sbtyxatsd6men59ymicb76ecaou
X-Rspam-User: 
X-HE-Tag: 1764861015-122851
X-HE-Meta: U2FsdGVkX19RgGBYtu1NkrLanRI6awXBWoI/woRK/7eWgVoO62pAZd/nPcC5bZwmONDIdWfBM4vVIGegz4WtG+k9eiQ8+Tp9+tbIHoDaIo09fdd1EfvUBanBhV5f7fWxQ08l4oM2uSwSRxosviXlxUXNlgGjC62OoRzZHrPoCKP8YowHmldbXmD+eJsFvHEWdaKDBiVfzl+/HVPS8ijy9AzW5n5ib4EuGjZbPSYNI9qJ3Um0TQqJeVBCKGZLvgZfnmdMsNLGuf+Px3RzQvGrkBGpobN5/bzrKjlH76tjtj7FzajcuvGWgEZSbybm6wH0OFv76SucnVv3pmrHUazGklfhstEXhAB4QALhe7QjBH55/CFP4CYF5JbDfhe11Nog2AN4nMzR/SoNZkw5gYcAvXmQcaQ2FX89OW2eMs1B2e0eufg0FxdbVNXJndgWhdUyqRFT3ffP5U3/A67yIV9+3jcb+LPDwudgtK+TIdb1v1/Yhl2xGAQmxtjrSlGhCrBrChe/FEJPPPy8fCIWQujLzUykrj09niOOrP9mPXE2U/eAz9dglxQDAUPugjeWqiKA+dM+jFKFgPSrNkZAEMk5s8rpRaEgcsh4IgpbsmBNjHGSnT3tiGzKfDIzDGx3RRls9LVcGAiyEMeOP5UB+iATNnrO124VgH7dpT4uh3Xm2jMx7pyt1Z2wmAbOJIoXUKPTkhQqwXjziBbOBEvKoiCTnVQ18Sa2Lg2jYgpIuu1OH1jLCvbeEsJCVqVGv3Mzi77/itsgzoHs8IVoQ3Vd8NcUv2weWNn9+lfJMsQ9sd/h2lOldIdhDM0BVvRdJfsslZZr+pCyUMp24xzVF8T2JgW65rqa7qiWgy+4ehAfgZuB8fo9/mzwlZWMDbtT9IPG1qoEpiyZS9EhF94d801tip7CVtZQFWrR7E/wfQBxsWHaj2c1rbh3YmGweHRtsNGse9D5rTjEGhB+LdwYXyQKDHg
 JylOClpd
 6MSOL3bhEcgwjUq1ZU6r48VQFafvH/K/+Svu95ADAyMOfTOCP+33niUqiN3BNyoUeYowVuDjoRJfiv70SNcSkOqIK4PVSvcA8Su3j6g28RaGML6eEOEOORGYblBkIeWYFUyACaEtrX8guomE0yJ7RIeIBrAaFzWXLDAFRm0ZHQwRGA69r9MHossxVDLcAM+kKPrm0fDzaQLFm7UfjSerkUL41Mh3c5gv3C3EBmPtn53b7wmdpj97L6qaFsXfnzZVV/KVX/2FDSjydaWHlTlCaZ9+ZfrEIn/qAe3r/wE/vV8A6wJ39i4u9Y63FMeKRL3OhshoymBl/KnHEVcNpx9x+KN2A2uWEUPl8vkpo4xq+kIqdgYH64vZRkcxvhEvvyPVI6pPMFIBrTKikfg1VA/68rliRC9zDaTDl/YU1mt6QoSTAMoQ1iMgHY9rebhC0cGtzZ8A3SOGvydwSXGWGQbr8XcUKyxWw9KoJXhUYdt/cfF1vgBSmp97QW3WbJKebdt5cPDRy63Eoe2nyGpnyZKeBZe9XxF0dwoRZ8AQE1c2V6QGr10ylpB+nxMvLagLKaUaHlq9c9XJlOtWMOuyodIdsY8QXFED1Cn/53HvP/XQblyRAyIU=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add a hook to vfio_device_ops to allow sub-modules provide mapping order
hint for an mmap() request.  When not available, use the default value (0).

Note that this patch will change the code path for vfio on mmap() when
allocating the virtual address range to be mapped, however it should not
change the result of the VA allocated, because the default value (0) should
be the old behavior.

Signed-off-by: Peter Xu <peterx@redhat.com>
---
 drivers/vfio/vfio_main.c | 14 ++++++++++++++
 include/linux/vfio.h     |  5 +++++
 2 files changed, 19 insertions(+)

diff --git a/drivers/vfio/vfio_main.c b/drivers/vfio/vfio_main.c
index 38c8e9350a60e..3f2107ff93e5d 100644
--- a/drivers/vfio/vfio_main.c
+++ b/drivers/vfio/vfio_main.c
@@ -1372,6 +1372,19 @@ static void vfio_device_show_fdinfo(struct seq_file *m, struct file *filep)
 }
 #endif
 
+static int vfio_device_get_mapping_order(struct file *file,
+					 unsigned long pgoff,
+					 size_t len)
+{
+	struct vfio_device_file *df = file->private_data;
+	struct vfio_device *device = df->device;
+
+	if (device->ops->get_mapping_order)
+		return device->ops->get_mapping_order(device, pgoff, len);
+
+	return 0;
+}
+
 const struct file_operations vfio_device_fops = {
 	.owner		= THIS_MODULE,
 	.open		= vfio_device_fops_cdev_open,
@@ -1384,6 +1397,7 @@ const struct file_operations vfio_device_fops = {
 #ifdef CONFIG_PROC_FS
 	.show_fdinfo	= vfio_device_show_fdinfo,
 #endif
+	.get_mapping_order	= vfio_device_get_mapping_order,
 };
 
 static struct vfio_device *vfio_device_from_file(struct file *file)
diff --git a/include/linux/vfio.h b/include/linux/vfio.h
index eb563f538dee5..46a4d85fc4953 100644
--- a/include/linux/vfio.h
+++ b/include/linux/vfio.h
@@ -111,6 +111,8 @@ struct vfio_device {
  * @dma_unmap: Called when userspace unmaps IOVA from the container
  *             this device is attached to.
  * @device_feature: Optional, fill in the VFIO_DEVICE_FEATURE ioctl
+ * @get_mapping_order: Optional, provide mapping order hints for mmap().
+ *                     When unavailable, use the default order (zero).
  */
 struct vfio_device_ops {
 	char	*name;
@@ -139,6 +141,9 @@ struct vfio_device_ops {
 	void	(*dma_unmap)(struct vfio_device *vdev, u64 iova, u64 length);
 	int	(*device_feature)(struct vfio_device *device, u32 flags,
 				  void __user *arg, size_t argsz);
+	int	(*get_mapping_order)(struct vfio_device *device,
+				     unsigned long pgoff,
+				     size_t len);
 };
 
 #if IS_ENABLED(CONFIG_IOMMUFD)
-- 
2.50.1



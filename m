Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 432D5606A82F
	for <linux-mm@archiver.kernel.org>; Sat,  7 Nov 2026 00:41:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=cWvjbw3P
Received: by kanga.kvack.org (Postfix)
	id 3DD716B05FA; Fri,  6 Nov 2026 19:37:22 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 366036B05FB; Fri,  6 Nov 2026 19:37:22 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 27C726B05FC; Fri,  6 Nov 2026 19:37:22 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id F32626B05FA
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 19:37:21 -0500 (EST)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 950B7160210
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 00:37:21 +0000 (UTC)
X-FDA: 85406459082.11.5669F27
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf17.hostedemail.com (Postfix) with ESMTP id 87D994000B
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 00:37:19 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=cWvjbw3P;
	spf=pass (imf17.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	arc=pass ("kernel.org:s=arc20260519:i=1");
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794011839;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vOa35AKjWJ6VWW61koXSqeeldsqxuYZd07yMlZHpYyE=;
	b=PjADT/lkkMakDIcCFFJhS2DkT3m1PvCEykS5821hUHIHbFPE3B80yjZp9eaFpFDk7lijXd
	aXHZn+DwKmwE5tgBNnmrn7bAh/6JzK0cNSFHyXmiA712N/52nxci09T8w1IQ0/WIFB8+E/
	duf7403mudhA4+B33qtotg2A/GiHhL0=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1794011839;
	b=fsOmhvlASdUJm37RXttJOmi+15+FBkB2eNXxX5wtRUlA2cXdseghNpkd436ZRf5wpDODxe
	5M2lRJUq55lre6wNC8dGKt0QgA+Jd3ajZDqHvp2GsELEoEH592fi1euX/5TbzYaeK6nE3W
	D8xOBIfSgW+DYIlP2MwQ+LxYkNPsyK8=
ARC-Authentication-Results: i=2;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=cWvjbw3P;
	spf=pass (imf17.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	arc=pass ("kernel.org:s=arc20260519:i=1");
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id D512E44513;
	Sat,  7 Nov 2026 00:37:18 +0000 (UTC)
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1794011838;
	b=V4DilyVKWOyIVvZdf0SwqxPTaFu/j0tnayeQLJF/ku1/ZKWvJ7Azitd2ZM646L1mCMxW
	 c9hTnFKaxEbhX4IGwMdz7S8cL4UKlOu+0stgpqYzooZVjIS4ybAxz2UAtfxTCwz5TeINg
	 jzeBc2yInbggOvk6A6SpXORj581n6bx378MBOFx8tCbQjbidqrhk9/5IqsBJPjz9gEc9h
	 7j0ykdbdsurFNa+f69wzrVT/HBHcG2fBZtArrFkFNekk23EkIxej+lHa+M1l+aDXj4cBq
	 X8nAvFo5+rsLXsZvBmxBLXH71QJXJI2L0N0c+CK/9+1K/6QRoFgh4CnKvvgpcjd//qQ==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1794011838;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=vOa35AKjWJ6VWW61koXSqeeldsqxuYZd07yMlZHpYyE=;
	b=0/Nd3p1I750O0jxu7/w3NaQt8Qy1vLa64zwVF9jTUALn9Ycur6P8Ho80L+t1dc4DsXf0
	 F07hF735OtrVS8cAbYd/q1vwdrMC5AtbPwnZmd53xEunfPYnouNDJMmxCS44zHeb38Do7
	 A2VDWrESkrkO5ba7eguY3oMwByxF4gRhoOII6Nrffrp0z9DHR7F5KUcd0IgzQD1xyUKkg
	 a9x+KIWL2E355N5Aa4Up2K4J2dNx+pDAZn46NkwYI3FeQWQDG56xI20jEnaWx1zjcub3K
	 pBKK2Ig/3bKMkjjSutatjiU9UlFB0Eau10p/5W9+9IpAST51IJP8AUcMMAIwUFw2emw==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id 557DA1F00903;
	Sat,  7 Nov 2026 00:37:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794011838;
	bh=vOa35AKjWJ6VWW61koXSqeeldsqxuYZd07yMlZHpYyE=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To;
	b=cWvjbw3PmBJHrEY3WmVsEDbMOn6JMyUXv8RoCZCDfJPqUsWNYhOAbT8WGqP3NzNni
	 YXlaFsucvto2gW1G0qJy+/DZvxRXmHUZHYn77C3JGauZv5bGy7s2WBgqhBSo1yX0ST
	 Qt0bxOXy/BlRUa/nhVgktjdsdSo8yloUope+u4+HXo4nuxuFTnSQQuUlOQK18CWNAe
	 iDYdZORi9pcoj4GzwYCoseFgs1Fwkvjv7I4HZ+Dd3TR0ZD5Kz26O3T/w1kMARXBdxB
	 dBtyTCN8KynVvDcEO+yZT7y8b1SGkTsMkXlvbcoN4U0ZUDrfztws7WYdYdo9yKEwib
	 rQqw6OHbO8KKQ==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id 5E71647A14;
	Sat,  7 Nov 2026 00:36:57 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Date: Fri, 06 Nov 2026 16:37:40 -0800
Subject: [PATCH RFC v3 66/88] vfio: Dispatch guest_memfd lookup_pfn_range
 via vfio_device_ops
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Message-Id: <20261106-gmem-alternative-providers-v3-66-8484dde66a7e@google.com>
References: <20261106-gmem-alternative-providers-v3-0-8484dde66a7e@google.com>
In-Reply-To: <20261106-gmem-alternative-providers-v3-0-8484dde66a7e@google.com>
To: Alexey Kardashevskiy <aik@amd.com>, 
 "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>, 
 Christian Brauner <brauner@kernel.org>, 
 David Hildenbrand <david@kernel.org>, David Woodhouse <dwmw2@infradead.org>, 
 Fred Griffoul <fgriffo@amazon.co.uk>, 
 Jacob Pan <jacob.pan@linux.microsoft.com>, Jianxiong Gao <jxgao@google.com>, 
 John Starks <John.Starks@microsoft.com>, 
 Michael Roth <michael.roth@amd.com>, Paolo Bonzini <pbonzini@redhat.com>, 
 Samiullah Khawaja <skhawaja@google.com>, 
 Sean Christopherson <seanjc@google.com>, 
 Suzuki K Poulose <suzuki.poulose@arm.com>, 
 Tarun Sahu <tarunsahu@google.com>, Vishal Annapurve <vannapurve@google.com>, 
 Xu Yilun <yilun.xu@linux.intel.com>, Fuad Tabba <fuad.tabba@linux.dev>
Cc: kvm@vger.kernel.org, linux-doc@vger.kernel.org, 
 linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-kselftest@vger.kernel.org, linux-mm@kvack.org, 
 Ackerley Tng <ackerleytng@google.com>
X-Mailer: b4 0.17-dev
X-Developer-Signature: v=1; a=ed25519-sha256; t=1794011810; l=2394;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=BBsLRY5/zduXiatMpUbbSqrLV52w59feoL+MHLEuZoM=;
 b=7xcifykO14nQsxFEs8sdU2o2UQh7kl92DT/YVnK7Uryfd0l2oNHeq3Pu9Lenfx7JmCK9mvetu
 SSaH9jUPfbAAsKMHNUCvsSRzAHQMcprqLifHfZLn5oE3OIxXZ9WRwNH
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com
Content-Transfer-Encoding: 7bit
X-Stat-Signature: it8d5a5843dj6pgc9q6b87e8uobr9b4n
X-Rspamd-Queue-Id: 87D994000B
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794011839-312156
X-HE-Meta: U2FsdGVkX1/8FxPwy8OXhWJnyEm37ve8KsEesBByzQCUlpiA7Ys+up5WjGVgXNWCSi03hb/q+xP1/vfqlXW/RmZmJv2g/S3WMNUoBvzzCblfIN03crNHAFESMuBw5Ac4zcqhJKPuRoFrZ/SNVw2m8xjr/87FhNz9Ms1HBsQnCHgmpGqcGeSS/5rluQJnlGnGLNTJ9mzNb36J6GZuJijcY4gZI2NYcKHHB9MevlD4cBdwpziE3QuAH8gxsny2/CmprprOxpitOiSRSFU6xh6sFlT6Y+3Ep6dXLYIuLACT1aye2jZTyTsob+5JZp8MLYfzXq5Y39mu6fMjVk90aJnvvqSQghUL6lCbHRTt7OKWg23S09F/JR8Kn/EKniZWeloMlOlrLve4wTOto0NjheqNVD3MaA346H+5BWEfj2/c415lCpFUwh/Sxhcrz/tZQEEX5u+rqaN/h6gS4N5idmRk0EC5bV3ktQBYtQhFMWMgfs2U1O/Xz7HCadjJG6Rqq6LM0PpCOaL4DHAnxcc7ZqsQPTtQ9DhaTP0NbUfVxQ59/JvR+Se+wkQBOFMCZ/qN/JRSwGRQzV2myQfob2mtL6i8xEJPcu9RlNjE4zWxMI4hhvHLhyS3BQ2I4YDd66/L8GIUZm7Q9oaeeebde6T+oGCfNUbmot/AfdFrry7bi3nyP1BNrLUgFBXqAKY8Tu2SMcY7+vc4LdIBo7+lAXzJFUFMEZNSAvDP8uByqQJsT86Z8tGIfZyamOlrntflT7xnJo/YosGP4HDFQqH557bCxlsCf3+zNXMZKHIwMdUU8Ck09x71czs02SK4kD1/6bsP9r3l7rtbda5s4utMShkM5UFmACX+6oDhwblGayfu6bzLlobWRnBU9eFQqrN8ZitM32dSZX/wpbf7Xr3HopSsKBu3Wb5nY7i0IHyBkyYZOnzbpSfiWIrYo8qre5nI6wLfoMs0DPjOoBLzj9zPoPZ+yby
 zOLXyNmK
 5Zo89Nx4mk6hZvk51JJiklkE5yVYXwdbPhaMd0LpxC98yhLGS1t+/jnkwXuDayH88/pZPg9rRSc4W2Oz/WmK/BRAEKWmW1+rR8CudQZ/2dDgt60wj+ax3zAxJyNQGL9wFY+HkysvNvZxNpT59g5vRkTtNtAxZ3ZLVU1PxOWTjBMSdSxiNY4rJp/xM2klHveOZMTPxH+FoS72gwxhPkbqcs4M4hmcDbsWxmXDcKJMHB/UzAzipnw2c4ent83T3nv/7zaWPlG5xCvRy0i4gBOiHZTqOFe/J0qX9O3XGiBi5CXrnFJmLW/v+mb+3isaqrhoKI5RY93yzozz5+tTjoDTsskqdjuogEJaRAQqL4Dkkynri5CDn36YTAgcFSe+TkUHk6YJbtDnM4ChPYD/TlV+It7jkUiZkADYYUZsXV7feCqoHkIO5UIUGpYXV6ByeZ8eyhjCWUwgpSaG3LDy77yhDJ+2kvZR75/u9MMRAU6ptTvmpj3yUdzm8I3nxsMja3Rr4o5mAOwGMZd9/OBDAwj3vy4X+n6HVcPF5aGII+5z8+O/jcmNJ8j5kN7ygeZvGkYUm4iOKkspXDrpSsQZS0hRNlWvab7wchTUULZfVZpcTl6VeViI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Ackerley Tng <ackerleytng@google.com>

When scanning guest_memfd memory ranges for confidential architecture
reclaim or conversion, guest_memfd invokes the .lookup_pfn_range
provider operation to locate backed PFN extents or skip unbacked holes
in bulk.

Implement .lookup_pfn_range on vfio_device_gmem_provider_ops to
dispatch to the bus driver's .gmem_lookup_pfn_range callback on struct
vfio_device_ops. Return -EOPNOTSUPP if the bus driver does not define
the callback.

Signed-off-by: Ackerley Tng <ackerleytng@google.com>
---
 drivers/vfio/vfio_main.c | 15 +++++++++++++++
 include/linux/vfio.h     |  2 ++
 2 files changed, 17 insertions(+)

diff --git a/drivers/vfio/vfio_main.c b/drivers/vfio/vfio_main.c
index fd5f71dfc44b7..1c2811848c775 100644
--- a/drivers/vfio/vfio_main.c
+++ b/drivers/vfio/vfio_main.c
@@ -1636,10 +1636,25 @@ static int vfio_device_gmem_check_set_attributes(void *provider, pgoff_t index,
 						      attributes);
 }
 
+static int vfio_device_gmem_lookup_pfn_range(void *provider, pgoff_t index,
+					     unsigned long *pfn,
+					     size_t *nr_pages)
+{
+	struct file *file = provider;
+	struct vfio_device_file *df = file->private_data;
+	struct vfio_device *device = df->device;
+
+	if (!device->ops->gmem_lookup_pfn_range)
+		return -EOPNOTSUPP;
+
+	return device->ops->gmem_lookup_pfn_range(device, index, pfn, nr_pages);
+}
+
 static const struct guest_memfd_provider_operations vfio_device_gmem_provider_ops = {
 	.attach               = vfio_device_gmem_attach,
 	.release              = vfio_device_gmem_release,
 	.get_pfn              = vfio_device_gmem_get_pfn,
+	.lookup_pfn_range     = vfio_device_gmem_lookup_pfn_range,
 	.mmap                 = vfio_device_gmem_mmap,
 	.check_set_attributes = vfio_device_gmem_check_set_attributes,
 };
diff --git a/include/linux/vfio.h b/include/linux/vfio.h
index aade091a91fe8..8022adedc26a6 100644
--- a/include/linux/vfio.h
+++ b/include/linux/vfio.h
@@ -128,6 +128,8 @@ struct vfio_device_ops {
 	int (*gmem_check_set_attributes)(struct vfio_device *device,
 					 pgoff_t index, size_t nr_pages,
 					 u64 attributes);
+	int (*gmem_lookup_pfn_range)(struct vfio_device *device, pgoff_t index,
+				     unsigned long *pfn, size_t *nr_pages);
 	char	*name;
 	int	(*init)(struct vfio_device *vdev);
 	void	(*release)(struct vfio_device *vdev);

-- 
2.56.0.455.g6c5a503b38-goog




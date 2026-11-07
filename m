Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9440D606A81F
	for <linux-mm@archiver.kernel.org>; Sat,  7 Nov 2026 00:40:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=UyJ8GHMj
Received: by kanga.kvack.org (Postfix)
	id 27E556B05ED; Fri,  6 Nov 2026 19:37:18 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 253FE6B05EB; Fri,  6 Nov 2026 19:37:18 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 11E5F6B05EE; Fri,  6 Nov 2026 19:37:18 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id DCC906B05EB
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 19:37:17 -0500 (EST)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 136A81C224F
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 00:37:17 +0000 (UTC)
X-FDA: 85406458914.15.253E9D1
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf31.hostedemail.com (Postfix) with ESMTP id 05DF520002
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 00:37:14 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=UyJ8GHMj;
	spf=pass (imf31.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	arc=pass ("kernel.org:s=arc20260519:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1794011835;
	b=MGpILhQaEZRcgr37UGRAzn1muOfyv0YKZSFKrVanA3UWg0AIuIve4jv7zU/XpPNjrDuO6D
	tpz2DJ/EvOUm5HscIMlGq/3+0OFDZmm1rgoMP/gbVMyRv+szaAexWkFTr1/1rwGTA/NSLv
	fyHe2iTrAsZz/o6jUQL756m+oIbMGIY=
ARC-Authentication-Results: i=2;
	imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=UyJ8GHMj;
	spf=pass (imf31.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	arc=pass ("kernel.org:s=arc20260519:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794011835;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WKx0S/q4LHoqXh512KCmG0Z59UCrs4m44WNNAgPuWKk=;
	b=YJG3GHHgtv4tJMPLOTCMhS1oYKUljEvcfdorH1SNp5RiVeWYCiwKXCTXXRxLuTGtRrpYaP
	l3ZZ/tKBpKJl7Y2Z1n+Ysu82TpNObkigGsxEYZFtmbYyEKWUjUlCf9DhqJljeiXgF4l3Yf
	FfgKrb1yFg/Ileq3ltuingTX0qzzr00=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id C94B543FB5;
	Sat,  7 Nov 2026 00:37:14 +0000 (UTC)
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1794011834;
	b=ZmP2qen5yy0OlzVCFE7lwuma1KZ3jOYVXli49mLUTIYfHADWurXEV/gxraqWLZTGLPw+
	 X+i3Vzyr58cewRLcYl57BS9qLzdBsjPX9MuTRfcmHWsQd+SMY5tDhwTINF9lIUlZU0o+h
	 80xg4h6yZUTjDU8VavadZYH3w5Fy5tW1dl/UXkz7vd0hjtya04OV/HTnKKXei8qVc0Okx
	 xqRN3FFUgXX7wSCWC2yhENWGUpZtP/ZfxDNy7ofdvWtTo+s/XibxQz+o9j/1Z90NNTN+Q
	 NIDl2oavUHEb47zR6BNwOFbVYjU4A7poHaIXlJiePJrrP0GkPR+ZkvmtaanuKLljlkg==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1794011834;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=WKx0S/q4LHoqXh512KCmG0Z59UCrs4m44WNNAgPuWKk=;
	b=U24hBmLGJCe6mYgwWzIukTbR4l5BmbvH3COYJW3+2whge1FdMZ0TtTzdg8KRjYcFupvf
	 j3yiG80JD4KFdlhKhE3No5Vbg5ayUlm0Tl0ENPwh8enPxCRNIFNBHRjSpa6By+Xp4KgtH
	 uew9q0+1cvfWpsnPtg82m+e0TSY1XMahOgB+VrXtvEpB8AC+c6nsmWI1lv//P8pB0PEkc
	 0ZgKonXXeV0ZzXceiV+pqD/x74yjQaOFdvGMe9gmpNESWRlQ2lRpZ/tmciyMJZBmi+kcc
	 h2kLYF+1mcnMALsx51n7TDTaQ3jMoC5Sk/pE8oDmdakbXA113WrL8++Ox0qM/zzamKw==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id 974B31F00901;
	Sat,  7 Nov 2026 00:37:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794011834;
	bh=WKx0S/q4LHoqXh512KCmG0Z59UCrs4m44WNNAgPuWKk=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To;
	b=UyJ8GHMj7CDmRAOYLqSw+DWPAcD8w6Gzx5bJLyn82vP+WD79hijnDIpIlxfbagNsz
	 yyUVz6uY+zBoedBsPX+mKb2LzO63CBPhBtWBoj1AN7zI2QhcVZVS6Z0p6dYq/h1SGt
	 LpIUF2RAhQ8PAn3xCu+gpMUmfW3N9hqdf1q+XJTP7bAVowIPTvZOEKNi3KTYEbqkEF
	 AL5jWVu6e2l58VkEeCJmLy2l/TO74x53dgm3Xz6x74EKaj5HOUviLw5zhJIGtQeMIL
	 kUgru+3bFcThEc2KPaYVelPgOo6h9MQA5rM6FQ3t9+epnZlwk+Z3NO/5S+xLuBEbN6
	 ygQTX4/AQjG3Q==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id 2035847A04;
	Sat,  7 Nov 2026 00:36:57 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Date: Fri, 06 Nov 2026 16:37:36 -0800
Subject: [PATCH RFC v3 62/88] vfio: Dispatch guest_memfd
 check_set_attributes via vfio_device_ops
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Message-Id: <20261106-gmem-alternative-providers-v3-62-8484dde66a7e@google.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1794011810; l=2646;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=/6avTRCqI4M8/ALHbbIFehsJKaQvoBf+svzx5j3iq8o=;
 b=A/0h+r+KSCP4fQo2hcBDtiJJa5JKzY648tnHJ16FNMD3MSKRsvEZ8EZGzK1oxHVIF1ZwPtJO+
 DRSFyeeW6yzBnvH8OVDGq4XMpFSwBUDkTeKVElbM8BqKXtFQu6mFHma
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com
Content-Transfer-Encoding: 7bit
X-Stat-Signature: kdcauuwwdq781st83xowp4yxj4fcc5bc
X-Rspamd-Queue-Id: 05DF520002
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794011834-847089
X-HE-Meta: U2FsdGVkX18HfuLvn+MfIs0Xut3f65jsbRZCa8f1ODo1aKlGxHJxSELyNNftztGLQ6U61Hqeq5EAeNeAhXH2JTH47mIxEiuoQnS/CZMye+EvgbGwf75n0JI2ZdMeAqU1opo9J1v+A3qlOB5kT586wOnFWh9DTtZ8h8otWFATeDk9OPABTBVmztbHLuAhlcrWfmlg5skJ0mT/n3NASvGE6/Q/73YTuxixLe2CWP59+/LqrekUKlY7zXLyGWwYYvMRDVF+UfZuT/RwfJoNFbXDd98UFb4CYUlcVh4RPOahrdMzbG5xZiNHgIeCQH4SLpA9Zs4q50eLWUNClIR/Oh70rCtJ+uVxxC2aM6WpqAbxfygsjVT1YJu7CoR5/CbKcGrP3vZO/GXthf1QpyP+p7LJNxyLyrkGUjDg5CFwE+jGSUuBn7UTo1j4lw+hdAguRHO7AnqTsAD2hFCQ5VFsE3VsGuKtY6aQWSuKXg964Mjg+f0SNV43JJj5ro7f8dX0pGSnVClAp41n9ukiWFKS4vrAqx76dMgZZHSYdZrV/PFrGWfk8nm6m+O0cWMF8VWsgt1aF9wMgKlTlFWK3FJ3cGIVMrZLUkuN6fSse/nBfGQPFVE5xZCRSvInojFNOcai14OHHdfIUiWkmOWt121HAFZMAp1avwBHuy3oOSpW4vIxC0Yll+gVmPXGPDv5hnKI81iKnT8puygBoLeT6E7QMZGZeteo//RpLMIVUSX96XQOUhyO4MNwJidi9qCich0xwAjBOBY/E54aXb+JsCZqARDAghKDOUrzvbzTaTPHZiinqw8J0u5MCNcjETEw6ko5m0WSYeH27zZmf1dDHsW4xn67jhY9RKYHAC9PU6sH/r+n3gmjw4equWM7qGYp+izQenAcr0CVEEZUcKWZ8MRV7bQCU7sx0+xG1G4E1BzaUbmZmKE4pjvUnH7epK5AjtBi28Y2QDgQz5d2vDGy2bVR6rD
 9KuHnyJe
 /+JPGnusI8hraUEHQ2FfIs94QsVV+8sQt5l0f/BpN1frBDobMbThIb8qTn4fath2C4qhtihONS25z3bMpiDmlA/DnmATF60O1ghnqPt7AojArWu66lKNczesRyxS80DvmBv56y+fAF7MqzLB2ypUoISWHkYDVxLRWk11p/Xg9VKI9Bq/M4XR1PhJy+8tjX1u3hwQ7mbNm1GDNkpAmANw1G44PVepZjMmXeyXVnNhA/FWLAYfbisxoM0ZVpbQjQ00HI1zWnZ6ZkAGrVs53OiuCf/e+V2JXDhAPZx8MEJHH6PeOK/9p0tZaBhRH7IyuIhgsw5Kc6+E+hVc2m2Fk+p2ZB1x79vejpDaHKRO02P1TzVyx5WuaWDf0njw+BMLMdDSp1kx5oUWs3rSxkaFdysZTgdNEtS4qQEu8IaeB8bV96ERadqNRfJkXjHXMrOZV+jnzwQe9HyvXZA3+K2GSIUrqc3ak8Dp4STV6mU31rEkFThzleaFobW+Ye+XwDgdSnn4sHHeGtYsp6ZM6Ef5QTkGP8J7DtLCs3fUsY64LjDIvuqFqP/beampxuW6vR8Kl+mUXMYfrVP/WNOgtXSkAXT3hc7J5zkO6wi7R0jDFVHyviS2jct0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Ackerley Tng <ackerleytng@google.com>

When userspace requests attribute conversion on a guest_memfd file
backed by a VFIO resource descriptor, guest_memfd invokes the
.check_set_attributes provider operation under the exclusive filemap
invalidation lock before committing attribute changes.

Implement .check_set_attributes on vfio_device_gmem_provider_ops to
dispatch to the bus driver's .gmem_check_set_attributes callback on
struct vfio_device_ops if implemented, allowing the driver to inspect
and validate the requested attributes and offset range.

Signed-off-by: Ackerley Tng <ackerleytng@google.com>
---
 drivers/vfio/vfio_main.c | 24 ++++++++++++++++++++----
 include/linux/vfio.h     |  3 +++
 2 files changed, 23 insertions(+), 4 deletions(-)

diff --git a/drivers/vfio/vfio_main.c b/drivers/vfio/vfio_main.c
index 979ed69c5ebf7..e4e7bfe77d03b 100644
--- a/drivers/vfio/vfio_main.c
+++ b/drivers/vfio/vfio_main.c
@@ -1621,11 +1621,27 @@ static int vfio_device_gmem_mmap(void *provider, struct vm_area_struct *vma)
 	return vfio_device_mmap(df->device, vma);
 }
 
+static int vfio_device_gmem_check_set_attributes(void *provider, pgoff_t index,
+						 size_t nr_pages,
+						 u64 attributes)
+{
+	struct file *file = provider;
+	struct vfio_device_file *df = file->private_data;
+	struct vfio_device *device = df->device;
+
+	if (!device->ops->gmem_check_set_attributes)
+		return 0;
+
+	return device->ops->gmem_check_set_attributes(device, index, nr_pages,
+						      attributes);
+}
+
 static const struct guest_memfd_provider_operations vfio_device_gmem_provider_ops = {
-	.attach  = vfio_device_gmem_attach,
-	.release = vfio_device_gmem_release,
-	.get_pfn = vfio_device_gmem_get_pfn,
-	.mmap    = vfio_device_gmem_mmap,
+	.attach               = vfio_device_gmem_attach,
+	.release              = vfio_device_gmem_release,
+	.get_pfn              = vfio_device_gmem_get_pfn,
+	.mmap                 = vfio_device_gmem_mmap,
+	.check_set_attributes = vfio_device_gmem_check_set_attributes,
 };
 #endif
 
diff --git a/include/linux/vfio.h b/include/linux/vfio.h
index 51e04b980a381..ffb01e655735f 100644
--- a/include/linux/vfio.h
+++ b/include/linux/vfio.h
@@ -125,6 +125,9 @@ struct vfio_device_ops {
 	int (*gmem_get_pfn)(struct vfio_device *device, pgoff_t index,
 			    unsigned long *pfn, int *max_order,
 			    u64 *pfn_attrs);
+	int (*gmem_check_set_attributes)(struct vfio_device *device,
+					 pgoff_t index, size_t nr_pages,
+					 u64 attributes);
 	char	*name;
 	int	(*init)(struct vfio_device *vdev);
 	void	(*release)(struct vfio_device *vdev);

-- 
2.56.0.455.g6c5a503b38-goog




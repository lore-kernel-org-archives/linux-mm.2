Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0B957606A81F
	for <linux-mm@archiver.kernel.org>; Sat,  7 Nov 2026 00:40:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Xw3BV2VI
Received: by kanga.kvack.org (Postfix)
	id A6E486B05F1; Fri,  6 Nov 2026 19:37:19 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A1DFB6B05F2; Fri,  6 Nov 2026 19:37:19 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8BE3B6B05F6; Fri,  6 Nov 2026 19:37:19 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 5252C6B05F1
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 19:37:19 -0500 (EST)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id F24CC12024E
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 00:37:18 +0000 (UTC)
X-FDA: 85406458956.27.B48A0A1
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf03.hostedemail.com (Postfix) with ESMTP id D8D9B20006
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 00:37:16 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Xw3BV2VI;
	spf=pass (imf03.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	arc=pass ("kernel.org:s=arc20260519:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794011837;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VQR0WakuaszDqO5R17sC1zMOvvVcE9BE0ownvxB0jTs=;
	b=0UFjtej2IpHfVRh795pT71VNDzrs4A+Oy/BwIwZUJR7tea9ik+zR24tXC3aKiYIoei9oCg
	/S/Ekg/XG7eSX5WINuIgd+jslKDxk/5JtcuMYpkHsrcuA2UgLDP8DBopEqrCBQzA1U0lKR
	6YZuqWGV+jnr3Cg/3+h2nlml77oQHe8=
ARC-Authentication-Results: i=2;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Xw3BV2VI;
	spf=pass (imf03.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	arc=pass ("kernel.org:s=arc20260519:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1794011837;
	b=OzfV4RcVBv81j9VFaO42OFthCsvZI8VomTa7Fg4yG7eDiyoNksfWfl0lhVgNSOtxJlA0Mf
	utwYetgSTOIbbpBH/CgHM9bhVZ/rlaHvTvNSP5/VykkpPgbfFWmZMuOCWemO+fcCcqqTLl
	qYAzOPm2+HMOvve1tJtOqpuCiSzsr4Y=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id A7DF44322C;
	Sat,  7 Nov 2026 00:37:16 +0000 (UTC)
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1794011836;
	b=o0Ii1271i+krwEjn4Tn4bXdjUS4XGg0znAw7PfOsZ0A/sGt2dX+julXBLqNwvxUCE5oy
	 79ntMgrDKKSYJxC5OoBAlLQ6MqXpklQSqmUS3XzTBRLYU8TuFYLL2Hf14XykCN3BLn/kj
	 MyprcHN1DB/TpUVzWHN0d1RvveEvsHd/S41bVbX3G7w+lzeGY7kixjHI+1Z6ozYm6Q/dj
	 LGOF/oNyS9NkiztWJ7U4iaNp5xUPShCOXUbIs31wwgRnOQobRbwAkFnFRlNgBZcx8oBiN
	 /7z6OSbPSMtHN6PY+y/9Ni832G3WosbKnHOLCtEy+97XMwlTD92dlAKJIPLrXM6M9kQ==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1794011836;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=VQR0WakuaszDqO5R17sC1zMOvvVcE9BE0ownvxB0jTs=;
	b=Lsxsx4TrJzn41FFwDbMfhGFbpsrXGjFAqmgNwqsBLbqS5Suh8iFzIoga7gbo8Ph7UuEe
	 PFydi+3fAsBW04gfjKShVuDIztfZx4oxFpFVLxxYbOk4BqL92aPzxhAfbszngC6jwKzef
	 PDjE07s7I/PClPTZmf32GrqdWGWsY8z9mDZOCw0o/9CiEqo+7iJn5aSmiPo5vMiFruRdX
	 49xxLY2UdF0O5cmge9JOpIye37T3l9pzIXDHewcCfCWtb9ijdBAX9gGy/RAin8TOCwO7Q
	 E21+5X6wr+7Shvb6/GPyIGIORYscrdjve9bGotM5Z9yQZ5FjnyRiSNiql8uGSEvX6oA==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id CD55F1F00A05;
	Sat,  7 Nov 2026 00:37:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794011836;
	bh=VQR0WakuaszDqO5R17sC1zMOvvVcE9BE0ownvxB0jTs=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To;
	b=Xw3BV2VIh7HubueaXrhbvOpox2U/SiJK47yyhmnx8lVA2rF1B8o7CFMOy7ECNGyxL
	 GSc/rF/UJeAVt75wNnm1HaKkQbx/waACwiUhvW3oigPkXt/nunoaho/LObiwMmfIRs
	 YW3IlGwud+TZJ0JUZimPMa+QsQVtxRd0+RUgCX0ca2+zhZJFkPrIjlqQFpSFfUqw5T
	 mC0/iHrGPmVsy88+ZXkOM5xn0bp7QIAuIM0rqf6qWzmoev5x46OgchecT/funBNBOq
	 Xx6jKz5BjQ4v3uQVs9ckx3/wgpZzGnmPX0H/FAtv3UXRQY7yPuy93fH8BLCtlnRPvj
	 jh4d1bJsWybyg==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id E5480479F8;
	Sat,  7 Nov 2026 00:36:56 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Date: Fri, 06 Nov 2026 16:37:33 -0800
Subject: [PATCH RFC v3 59/88] vfio: Dispatch guest_memfd get_pfn provider
 op via vfio_device_ops
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Message-Id: <20261106-gmem-alternative-providers-v3-59-8484dde66a7e@google.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1794011810; l=2331;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=xvhk/B5cJ5UV/xewATDcSIWa/TiLlY+J1HVubbWHrTs=;
 b=o7/Mg1zgNXsxxe9h93PAmVT9+adieaG+XGvsvYOAGMQVbFhjEeQODEIVNBVomRcjlxVrpS+fC
 vD5PwxCvv4YA1qhXrdJYU5KtKYsUBP51tja93wBeyuXND0y2TJGrwT/
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com
Content-Transfer-Encoding: 7bit
X-Stat-Signature: qbpypd79jyw41kx4n1m9gc3dkfxhypjr
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: D8D9B20006
X-HE-Tag: 1794011836-839665
X-HE-Meta: U2FsdGVkX1/6myl72mCczKy3rkBfbXcfqFbj4mEgDcF5U/U6hNIgrZgdl3UPS7ebrQbZ0szTKKIqHApxyFgELAoIojg1FvRIuuezB1/dYhIBOY4ECFVoeF5QSvZsDfwdbO6UMyR+KB/QRoZJFoYJw3k3UblRl2DaJU0EkHkY4ROFdHXO0tBFIJUF0Giw8dgDQyV1aV9p33YAuwquQSO1H8SWqvzn7UM0O9noDOFbXXWDf4mssBj2+pB98664qvxOQzanUm8BQt236aQT/dGS3cL3M2qLG6aBOvosRWjh2gq9wuFkOWCIfBO7XBJJzrInVTZ/yeA/qm+2XMTw3tHgLsoRTyozyx4YBVCqgNgx8ROTBoapRXE3jinL15z1UC5BSzTcVTsUib1DPCAE5H5dewfuz4F+osSJ8tgHIud9w5LV/UQ10kuectUCs+A0wxgYaLUnpo9M7Qry/cDwq57yXcMKzvYsgHt2eqwRSh1+VDgxzLqP0EYZ5K75063Fgbc3bSYIUnsfg+X+oQW4XlGSrmmqKS6pbvsJPCQMVH71OtYARnw10YL8o3oBqRplG8Z8CkpG3cyj++T5hDunhvBGEqKVCMnpkIb1Po/IVks/y90Cq6LeLaBTE+FcCfIYKfaRLvG02V+5u06y9mRqrQ+Hb7lW9oYfwNo0TRgjmo5e6TgJmNXwdsdHvuFm5CHnbHzCd6J8hhw8rJwQ0TC3s+1fnlh0Gs6jVK2Dy9WfKCqUE9Z+FA3YzYeqffikiPB+AZv4k+DR6NtTl3DuTROo7WVwky0iWW4f7AZhnCMUaX9jPxykCtLi47V0TZ8wu0RTux6fNJ6VETc96h1P8YKioMYGQVI3z4ZqXZ5RIMQgGmkm7wH79Em1LZh6g2Raufd+zdLKIbM3LxYEUscJVMbvQBVZFwBsqnk2LAEWwyuTIHrAaF7JUkPiLBhYDmEfhoZpTXCsDasCqh37f4AehmJtecA
 OzDDOK2p
 WZjCo9GePNcEjrJF/f7MuAvfs9pkeW+QhdTVdyUyfF+rEUJZclWrQpgvzkBoQxAbdivBtCzyE2cMhm8U3P2pOyHD9xV0XF8IS716yQgAW5hP9NN+mxkjov8og6S3DupE5qyCHE95w/hHMcv5TXaFvBurIc5vzclG4K3flloSPoguaWsMMF+SZBv5n42apTxW8Z06bRE/oMYtDVzXrcRrXrCTyzUisaCe42+6IqdBFzg7bf3WSvDHRpXLQVryrRQhoY8y5Ow0r4SuvCsKjbGAoNj8y3cbXycNC7p5aU4l+xyVhqNoGY4EgPEKAFEiM5lcx2QZUuMuTbUMKsYRBkiB3oq6i1QrAz1Q891Je2FwuA0GA6pgSYXbzp9QkaB7VF6g+HAjBWmSF1RWQVf0AjQO5RqgWnLbrjkFczB2ListT1x49SNPqeefo059mGZwc9ewnBScI1dspf5S9Fnug3imee2AH4wJDzXumYxTL8gdxZkRMiXv3bjqUH7DoQS5IXdxqriuHD1oAOxWRHQN87J1UiGjqW7ctjwDZNvSdkujoF6mhx8e93+j9n0yuUcLHhCL1qV4IBH24cyk9a00KZUOGLgu5p6hkUmG6KIkyENKjHubBRPA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Ackerley Tng <ackerleytng@google.com>

When servicing guest stage-2 page faults or host userspace page faults
on guest_memfd memory backed by a VFIO resource descriptor, guest_memfd
invokes the .get_pfn provider operation under the shared filemap
invalidation lock.

Implement .get_pfn on vfio_device_gmem_provider_ops to dispatch to the
bus driver's .gmem_get_pfn callback on struct vfio_device_ops. Return
-EOPNOTSUPP if the bus driver does not implement the callback. The core
dispatch path avoids acquiring dev_set->lock to satisfy the requirement
that provider callbacks do not acquire locks held during revocation.

Signed-off-by: Ackerley Tng <ackerleytng@google.com>
---
 drivers/vfio/vfio_main.c | 16 ++++++++++++++++
 include/linux/vfio.h     |  3 +++
 2 files changed, 19 insertions(+)

diff --git a/drivers/vfio/vfio_main.c b/drivers/vfio/vfio_main.c
index 618daf8bdaf80..93bd0a200ad22 100644
--- a/drivers/vfio/vfio_main.c
+++ b/drivers/vfio/vfio_main.c
@@ -1589,9 +1589,25 @@ static void vfio_device_gmem_release(void *provider)
 	fput(file);
 }
 
+static int vfio_device_gmem_get_pfn(void *provider, pgoff_t index,
+				    unsigned long *pfn, int *max_order,
+				    u64 *pfn_attrs)
+{
+	struct file *file = provider;
+	struct vfio_device_file *df = file->private_data;
+	struct vfio_device *device = df->device;
+
+	if (!device->ops->gmem_get_pfn)
+		return -EOPNOTSUPP;
+
+	return device->ops->gmem_get_pfn(device, index, pfn, max_order,
+					 pfn_attrs);
+}
+
 static const struct guest_memfd_provider_operations vfio_device_gmem_provider_ops = {
 	.attach  = vfio_device_gmem_attach,
 	.release = vfio_device_gmem_release,
+	.get_pfn = vfio_device_gmem_get_pfn,
 };
 #endif
 
diff --git a/include/linux/vfio.h b/include/linux/vfio.h
index 65dc2cb523351..51e04b980a381 100644
--- a/include/linux/vfio.h
+++ b/include/linux/vfio.h
@@ -122,6 +122,9 @@ struct guest_memfd_provider_operations;
 struct vfio_device_ops {
 	int (*gmem_attach)(struct vfio_device *device);
 	void (*gmem_release)(struct vfio_device *device);
+	int (*gmem_get_pfn)(struct vfio_device *device, pgoff_t index,
+			    unsigned long *pfn, int *max_order,
+			    u64 *pfn_attrs);
 	char	*name;
 	int	(*init)(struct vfio_device *vdev);
 	void	(*release)(struct vfio_device *vdev);

-- 
2.56.0.455.g6c5a503b38-goog




Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D872C606A801
	for <linux-mm@archiver.kernel.org>; Sat,  7 Nov 2026 00:39:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=QlPbt3WL
Received: by kanga.kvack.org (Postfix)
	id 16B8A6B05D8; Fri,  6 Nov 2026 19:37:14 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 11D866B05DC; Fri,  6 Nov 2026 19:37:14 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F26936B05DD; Fri,  6 Nov 2026 19:37:13 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C2BBC6B05D8
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 19:37:13 -0500 (EST)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 68816140252
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 00:37:13 +0000 (UTC)
X-FDA: 85406458746.04.E9A0BBA
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf09.hostedemail.com (Postfix) with ESMTP id 4C1D6140006
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 00:37:11 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=QlPbt3WL;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	arc=pass ("kernel.org:s=arc20260519:i=1");
	spf=pass (imf09.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794011831;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=013TE8/H9UfaaULLHpe/0PdW6Dc40kZ+W5jg572a6sw=;
	b=rqdBLg4xBcua82cWXr9XRo5hjwCc6rfcdBDwKTgGgM9uBrjzXsItw01302yy1jNTDExN9s
	vJHf2VklPYms3Sttnhn2j/VSOKJMow/e4LKdlWlxWuMf2hSNIWECCg1Ij0v+6gF9JIzvBt
	TKvu5WMij8xdcH3whC6EAJvarEwjFCM=
ARC-Authentication-Results: i=2;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=QlPbt3WL;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	arc=pass ("kernel.org:s=arc20260519:i=1");
	spf=pass (imf09.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1794011831;
	b=zqeW+ALOURfKeuEIObhN4fpLjnJFnY509+mc+odtFz4VKZ7l626Ajg3Q82UeD0Yd/TBDCl
	rPHZLHWkXdcy5KOJ+j6P+kTl1w4yipdeurIh7TGGy0RHbEcOp6FsGcmoskprPixVVx2zM/
	E6h3XmuXUMuWCsrMnarl2F41A4MEjzU=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 165A843D2F;
	Sat,  7 Nov 2026 00:37:11 +0000 (UTC)
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1794011831;
	b=uGhXxcCXbpeIV628k+aMbOMdTYZyovKeux7m1rogOjRvELZQfrkTHPt0OkXUpWWGs3W1
	 5kYFGC+uVqv+/f+a6qmXedIIXKt7INeklFG77NNf7nzpB7USDZp7pei1cu6lyWqkCUdh3
	 7X8oMfThHPvllZHOjz7TXublQrY1ZdKEGErcQ4DwTlbB3z5WIBRAW4Sgy1joBt/tOQnt9
	 SIiesW+FSZi7XwKruB2V62wj9onAo9hfhA6gu9XfITzU1HrFaG2rwwnCGuZIr9tt6rcWF
	 qeTAVmHGXlq52K6pMpuq8lwsbqwQp9XrtFcjOd63CI3nYUmrqh+EddXl4vz4oo/8OZg==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1794011831;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=013TE8/H9UfaaULLHpe/0PdW6Dc40kZ+W5jg572a6sw=;
	b=Dts+GmX3FEaWJCsd3zZAut3EZPmLk0HqA5zJ+dN+zl0akI4SfIah1sdBNjJjLu8kjCNB
	 0FYdF1oUa0jrn99be86jgdcbcsIDWIolqbv/SrmfMjDbsgbMTY5xKLt0wCicUf9ZcRWok
	 WI5QP/fG0mF2001o+f8roxQxMNxgarjU8eiVtnxsfL/qdbc7S6MfHbwkh1h73git5YiBh
	 PVRkeLP00ZKOKDcAIKjbXuZxMWWLiqxKofHrYzkAjDmFqs2nAn3UlnJ0P5yf87luT0/JU
	 tGEsVdIZHXR0dmI+Xbd1YGAOuTBIwhFL0xpU3+MekxAQhz7i2wd5jiZTQBQTLTjH2MA==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id 30E171F008A4;
	Sat,  7 Nov 2026 00:37:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794011830;
	bh=013TE8/H9UfaaULLHpe/0PdW6Dc40kZ+W5jg572a6sw=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To;
	b=QlPbt3WLbH1wZg22MADFhgD53xHwV7Qp9/U/C0kT3bpOISuLnRSqcXmVL1BOjkFOY
	 fhULOZm/YmyDzuqWNqYMv2IJiptkG9RUxa1vCpIQhG+uEiP6Qim8wJTXvWGdCCqhZp
	 pTlWWgXQCd8fW76zIqmb1o13n5isj5l2s2QeQOi59JhdmMoWq7XWFp6ufeIiB3DDcA
	 VHaoFXaFbVxT5TaAGQJ9u0tQJN5CHFE6ICBLva+GNDGHEOTACD48pdZe7+PbR6KvwD
	 9TMOhZE4v3qKT1vzGn/xZ0h8U/ZpNvA7usdT1INjXwfetZz+o34mnNzTbeJlnG3jRy
	 Fup5I9P6pDgFw==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id 25249479CB;
	Sat,  7 Nov 2026 00:36:56 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Date: Fri, 06 Nov 2026 16:37:21 -0800
Subject: [PATCH RFC v3 47/88] samples/kvm: Implement put_pfn_range provider
 operation
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Message-Id: <20261106-gmem-alternative-providers-v3-47-8484dde66a7e@google.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1794011810; l=2017;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=EQ1vkfs4Fq6dVy8Tnqa73wtDRnEOHzF5D2kx/MOFQjw=;
 b=qfpeXyJrdfzBNnklBH6lKmbtKPRh5QoMQFABGup6qT5nifmvAegwKuVsurgtDqdWAfCwzbars
 NPUayoqo7OoB5MiAYyY6K29oiVQj15R/7ZFXTkTxKp16tREgjIDIaTq
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 4C1D6140006
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: zh9j8yibhhf1mptr8dgko6g4k8gh8zfr
X-HE-Tag: 1794011831-969716
X-HE-Meta: U2FsdGVkX19l/wcaOuRfBJrswLZ1sTNfXv+qHhS4k0dE5mddsqdhQmyeBEix9q0k9j8pS7PBD4h5eTAqZ9DVsFASyNTnhZLIHXvaqu1Ze10jQHj7yyJY5QIy4xZWEVpTVDfmOT5JGO2a2Jlehlh/cdg0KU9BR6Mt0qL2uFc1aCQ2X44evw2vQHeAyKfET0UpPbSyoIvxwp/q85ekaB1ozoqxGmHAXEc86Pm0c3xXS7LKL7TNK+8knSMZs1KRrv37QajLRi6SZzNO4WR99JbtZAk6P0LlkwpQ/xUpJXkf1IdJoQROQujRE9mBC2n3UUfQyrcLb17k+kjX55fW306EKkssxJ7p0zelPH1zPGlA1APQUgoegsirmeqxoWU8rdjekMDIioKKR0XhCFc++OOJKhtJzjmvrR/rT8NSHNHiSsgwyK5F4NijO5lx08TcjPd1rK9fZJDqLeSRYsSpCm0QHw4e9tIuSb1Oa3u8Bv+3slLX4A0LeL0xwjxGZzqwUoA9neU4Bpa+ubpdIngi5txdcjzVCi1GVwjdDsTeN6hhufIpEiIID+QlrrfdBuGLrHi/JE37LVj/wGS5zMVD4n27UPqkDNH4ZHWYi2D5tJswLQSMQKCToXqfAz6sLofHzKzvta0nsLlfRn3Cvd03iPQnfUSl7D/s41FEyvgJIP3ldv8TjwcvIfk2jrzZ3wYbf+b4u3juPBipgQtIRMvPLJtBvqhe7i6RjdIhSYV1c9Mqu2O4BP2xsjgZnnVEykGZTgrk1ffSsqEidAN8k5bXKBd4evHBmmvG89wQ6VH6oslvf25l4qBQRHW6q0y3rFMobJW1GX85M9jHVBxihevnPzWOElMXV7Oyst3b4rV7pUtIJe6awgEKwEpDjLC7ESOn2X4ykRucp/eHDkPMQTzQJxPYnOFVCK8KTo7nuYjzEdZm86GMxKGW/SGAHZ3GBaBojFnpC+XkHs/UbhP8xn3pR4n
 xgIBB+BM
 Zzicdt/G1ahEEpzTpXrC5k2+ZqHNqeq2UgBY9SxA+yGwVT1aPzgDe0le4Y16Jl/3COOBkJkbqBxSi8KlBbWxQoDFAl7w60GgfA12epGBE0XwRXM1KBASzcABO+aa6iCoqLR8vPKUQELiNt96V3dV3a2sn99O9S9WHdRaz4m95CE3EdkXN/Oo6F2sjpncxpK9W9T4LAmsjMXm6V8hxl2M2Tfxv2VigWUc3eXbnwDZuGmFQMSzNeXdciaW3o5AMVKlJ5N4KxnOndD+lgC4ZPlQKqC+m+YRjVahxJhnFI6uk35Ry9snQmISc9mB6LO/1dCYPFlrpoVhqN+ZcQkVNu9TVk4woKP0nKsTk1u/PxOujUZzcEi4uLSQDbqfG0Hc/o1VneFs8oqofFyZq5IxSO/eF6JrwOfui83BQYwH87FILWZD01E5Wf568YMKALJeaZczncE8jMmhNRoaCpb2Lsr3LVT5zdXueoq4owbO7+3UciJ3XJzJab/m2RqcE6jzvmn6k2sft0l59rnGdn9kEXCirwxEYLmVXFkd/Q73lmOgc9OB4YxJosImJMzXbAKnL3XbuKNQlqMZye0h0I6StNsV8BjnUCqs0H0N9j9E5dN36NV8yszunpwZ1O4VniU4JPgKCdqJsSii7RZ0eVYA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Ackerley Tng <ackerleytng@google.com>

When guest_memfd hole punches or destroys an instance backed by a PFN
provider, it invokes .put_pfn_range to release the physical memory back
to the provider.

Implement the .put_pfn_range callback in mps_gmem_provider_ops to clear
the CMA pages across the released range via clear_highpage(). This
ensures that subsequent accesses to punched ranges observe zeroed memory,
matching POSIX fallocate hole-punching semantics and preventing stale data
from being observed when pages are reused.

Signed-off-by: Ackerley Tng <ackerleytng@google.com>
---
 samples/kvm/memory_provider.c | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/samples/kvm/memory_provider.c b/samples/kvm/memory_provider.c
index 1db69a8f58758..0a03623492f4c 100644
--- a/samples/kvm/memory_provider.c
+++ b/samples/kvm/memory_provider.c
@@ -17,6 +17,7 @@
 #include <linux/file.h>
 #include <linux/fs.h>
 #include <linux/gfp.h>
+#include <linux/highmem.h>
 #include <linux/guest_memfd.h>
 #include <linux/miscdevice.h>
 #include <linux/mm.h>
@@ -198,6 +199,21 @@ static void mp_gmem_release(void *provider)
 	fput(resource_file);
 }
 
+static void mp_gmem_put_pfn_range(void *provider, pgoff_t index,
+				   size_t nr_pages)
+{
+	struct file *resource_file = provider;
+	struct mp_info *info = resource_file->private_data;
+	size_t i;
+
+	if (index >= info->npages)
+		return;
+
+	nr_pages = min_t(size_t, nr_pages, info->npages - index);
+	for (i = 0; i < nr_pages; i++)
+		clear_highpage(info->cma_pages + index + i);
+}
+
 static int mp_gmem_get_pfn(void *provider, pgoff_t index, unsigned long *pfn,
 			   int *max_order, u64 *pfn_attrs)
 {
@@ -226,6 +242,7 @@ static const struct guest_memfd_provider_operations mp_gmem_provider_ops = {
 	.attach		= mp_gmem_attach,
 	.release	= mp_gmem_release,
 	.get_pfn	= mp_gmem_get_pfn,
+	.put_pfn_range	= mp_gmem_put_pfn_range,
 };
 
 static const struct file_operations mp_file_fops = {

-- 
2.56.0.455.g6c5a503b38-goog




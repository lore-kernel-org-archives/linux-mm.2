Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 37B50606A817
	for <linux-mm@archiver.kernel.org>; Sat,  7 Nov 2026 00:40:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=fZubP7QA
Received: by kanga.kvack.org (Postfix)
	id 738896B05EC; Fri,  6 Nov 2026 19:37:18 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6E9BA6B05EE; Fri,  6 Nov 2026 19:37:18 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5FEA96B05EF; Fri,  6 Nov 2026 19:37:18 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 290BB6B05EE
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 19:37:18 -0500 (EST)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id CBB3414021A
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 00:37:17 +0000 (UTC)
X-FDA: 85406458914.09.B5B9FF4
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf16.hostedemail.com (Postfix) with ESMTP id BB0D3180004
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 00:37:15 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=fZubP7QA;
	arc=pass ("kernel.org:s=arc20260519:i=1");
	spf=pass (imf16.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1794011835;
	b=y/X+LuK/VjBL5jCHYO8gzXEB1LktGn6A4vyfEr+ZXXmUxOtHSChj+WRpc8aQ2NZ3mnrRZw
	bzGOhNgrEzRqc/qVM6wvzthUqLv6y0m1D4MxM/t+dvUDvd2FFSjJbzXPCjJhgLawjTRMNu
	jLNQhNdNKTuiv8ghcv10zfbc5T7cmaQ=
ARC-Authentication-Results: i=2;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=fZubP7QA;
	arc=pass ("kernel.org:s=arc20260519:i=1");
	spf=pass (imf16.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794011835;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ThLtXESDEywLNe+6PUXAeNo3xTbTqDf4Iiez1oeCagE=;
	b=ZrbJ1za2ClFPV+3thdkIixASRmNPgKja5umO9mDC4tNAinPtTihJbV+RulsAMfODCV0GOz
	a1mBRt7ZXk73K4VGj465FLHKC8TP52OU9SNm/PQEd2z5p0ZrN5OGuGD7PoNhqIvrtBRdh1
	NzpFDO/fZ0utyn79fnuKvBL6ufx72QY=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 91CF943D2F;
	Sat,  7 Nov 2026 00:37:15 +0000 (UTC)
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1794011835;
	b=tFzfLbsRIT6qvCNKNGzydyyrGTnwSlqIBtm6jma3ppxXmRENrt0cwqZGVFTSHv2znny8
	 mgBIjtwuYdL+Ao6EhO32GLT29z6OUuUpS+wsCV5W5mDQIcPZABiFmrya+H0j4RErmTXcK
	 9qIBC2yLGxCgQxAw/COTMckMJ/4eThLeMIgEkcggXH+snpaWldLY7dqpp3CyGxUQ/l1g+
	 E+MFCAp40LFRAfLou4vF0BmCx/vOSr9HFqmH49To4rLZ9i71Oa7pQcjK/Qk/HVVedyBZz
	 XNr5f1H5tAc2UpjmPSwpKKboJFOhxji6venRwwOX0gMQkMcTFt6eSW9H6HSL1G9M5Zg==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1794011835;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=ThLtXESDEywLNe+6PUXAeNo3xTbTqDf4Iiez1oeCagE=;
	b=xqTCmHVfUDAGWgRkFpsbtqD8WMKkD/vn+1H4quhxUxvVk4p8yOZccy6QDaSx95PQNiER
	 G2F1nDuLWpMXKG2Kf7wm9MeMvh2HsDZM7Z2k45dhFjPWprjZPIM5aFXDDSFR087mrci5S
	 6UGyJrYgRtg754aP1O0Du4VD38wopn2JZek9lqI8YqPR1+AuGDrrNHvku6W9JWDCVrDVi
	 p/1f9PpMNxZtna0q7vXFSUwXyHMqAJub9TxmxpVDFgGwUqdQ/eCHXh35fu1ZTCAjmqRgJ
	 ioLkyq3XiZ/UD+YYyRJEh/mVL9LL7Up4tjOaxuAStX5fn5pcIfekd8ddV83HzJVkQSA==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id 47D6F1F00936;
	Sat,  7 Nov 2026 00:37:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794011835;
	bh=ThLtXESDEywLNe+6PUXAeNo3xTbTqDf4Iiez1oeCagE=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To;
	b=fZubP7QAydGkcR6nUGx88FG88QE66OoNIwBD+IkazW1S0udCjW+ByOwvFBRvdgoFp
	 T7b0NDKQxspmj4akIqa6/SE40/PJZvJJJzlhqJre6sRRlwe9YeRAxRULpuRlVqLKgq
	 9a9PSOci5/6DUX6Yfmwt6+4hODvUY0gKkIpFcpU+z/MkS8EoBd3f94GE+efXjEza19
	 O/F9f7D5DvM3EyUrT7Gn6Ks/TbcXZCxDBCHO6NEXU4hr5WA863sC1NhXTslXqspA8a
	 GRN2xEJAQM+w69D43g3aPipSVj+9hC8IobyB9KN+4ZHN+TQhCwbgtqvv/ZJLfnQJHC
	 IhUy6SgxAL8vQ==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id 359A3479CE;
	Sat,  7 Nov 2026 00:36:56 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Date: Fri, 06 Nov 2026 16:37:22 -0800
Subject: [PATCH RFC v3 48/88] samples/kvm: Support dynamic revocation via
 kvm_gmem_revoke
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Message-Id: <20261106-gmem-alternative-providers-v3-48-8484dde66a7e@google.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1794011810; l=4516;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=GWH3fZv1Ui/TswUwJ0eqio5HJ+BvFDkQT9zu7ehqt4I=;
 b=AzFkXUuX7PNtNJifty2kmSEefU5ky/gpNA1rYMtkZbJqdZY+8jkZospKZCDvQPJBzQdF+Ml6U
 sLn4skqpPUYCfSurKhTcpsfj5F4tNftObwJOwhSniLRdBLcsP/8BjSF
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com
Content-Transfer-Encoding: 7bit
X-Stat-Signature: a99ntfmfhckwy5qm6oa9b3equbja7arh
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: BB0D3180004
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794011835-315756
X-HE-Meta: U2FsdGVkX1+D7nV1A/cL0H2FKTG5/zBbsN0QV2mg6VwaOQ5LQzcwwgfk0CtMhgInH7lvToFbfb2OjiSBkKzwaCmEOpyxGuEP0Nzq+XSoBi1Px/1hAIlmIJfMyljfeonhnRbKI+1HPSJ2DGYp5tQd+LbmTgspv3UxQRWn4tKS8cMha+hhJ5PeNKZLmTEoBaqbj55QALHBtaX/+qLkNdOn3nNqHVotyZn7DLLURLvog1G5FtiM7MUL2zukEeApuEGzFiCjqmtAeLhMYOyBNGXw5LMDjuXNR8fG+A4WBboXhLI6Ax7U3UBokRnLQrz4lO5PGspfeFOkJITN/MiyK1RZ60rMJ8bhOYrM7ZmbKb0om7igIlDuKBDi/VByhfmbmJp+GPkOjHkUldtP6imGCpA6PuhsVjWptpVsnUBO6+uW8QVbz53rIGe4BU8R8ZO3C62xqcT1uB0rLpnMKmWQh2ZUYtYTg/AP/J7Xj4M58FeKfSHGZUxXSRiC+JO2ao2M8iKHW43lRz1N12kpFvZePT1xaNSNuHFb0NwGdUE2dHA8Er2crzuS9up9F4bsqsez9ySKg3oEigHSr6m5YVxiv4MrcXykLbBRWdLaT0WP00eBhUzMfdcsS4Lw81yHIwaffdWk1DkS8ylto8r4Irpa3FqUDHzk1jAXqHW8rDnDeLEAjxYGCOhsw6fEdAMy/zCuw8O0rBUJWOdygT7K/g3lMsS8v1CnFUi1U6H/YF5SmjK6Ke8++1w8jqUZLMmkiBxp/yCmajcrpk24XzQCP/SQm1hEKwpovU1TZLHJ5vxunKMk626w6ubUOrOzQvJjV8N2i/gcKDU4RSG2MbCjCvBAGa4O2wg+VvfMDCjh4xgQkDk/26P9QE12lRoRBEk/PMyB3s1Lo/nEHpn5wfzaJ1H9TKSG0p466rmgADsXl4uPtTl7DHyTJ8+T8nSATDzlelVOFQ/Ch+6xCFLTjzfCHM4OTNy
 bkCuBBfo
 Urwktj2fa4VN3Dqv0nd/25IJBQkuBMBSMJNW3sXsQCU+RalQkKHjT3oVdueHzomUEbMzaubBR6mqGAjSwh5MaOEZXREzC5sinNrh8e55lUKul8dr3g7O5bZ7kGQRbOYdCqoFY/3WDL5cn27MUsZjg0H/ocC5bzaC/TBiRainYh5KeC3/oeA3qVVA1EMjkMrzywfHdwLayleDrP2TLwBPpjs4vt5I5Gh33KXIXa/S/QlgXaeo7fut37McpPh9/Q/5S3gq+SayZICkxtF6zguXpkMMvGRQSG8lYFLeRMTjlvNgXTbqm8OXa92Im5EY6/1iB8elAa8q6zIUlHvZUKomrEWZyBAq0KAu+XDz+bIMEv2GayLGUioMxXyqAdGHb5ZKIMTv9dSiqw2A6Bri2ZhMGo3+5Hxadr7Z4EDgk/dUSUBCflJ03e+3xLBE1mhTsLoAKqB+msgoMHnVn5Txeo68TJmQcWOVLJO5KbEGn5cBGtPrhPj8yWNc96oZ5n0n3SKejvcrLuLGVMhr+SpnWo9T2itv0WBterZfhpdjIriKbD9aaGg1v+04OsdWwlBcAnCYkeQ7uYQEzCI7UXYgw6XN/B3Q9BgsZzwgeHMNbQPSg2vCCKxoUMNcHQ8dlvZyvOzMD0pdkUG6XZpRcAG8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Ackerley Tng <ackerleytng@google.com>

Support dynamic revocation in the sample memory provider module by
calling kvm_gmem_revoke() when pages are marked absent via
MPS_SET_PRESENT.

Note down the attaching gmem inode during .attach() and disallow double
attachment to the same provider file.

Clear the revoked pages after kvm_gmem_revoke() using mps_zero_range()
to ensure that stale data is wiped and cannot be observed when pages are
later marked present or reused.

Regarding locking and ordering:
- In mps_set_present(), mark the absent bitmap first before revoking so
  any concurrent page fault immediately sees the page as absent and
  rejects the lookup with -EFAULT.
- kvm_gmem_revoke() is called under info->lock to fully serialize
  MPS_SET_PRESENT operations against each other and prevent races
  between marking pages absent and present.
- The PFN passed to kvm_gmem_revoke() is derived from info->base_pfn +
  start. The mapping between page index and physical PFN is static and
  immutable for the lifetime of the provider file, ensuring that the
  pfn mapping remains completely stable across the revoke call.
- Passing pfn directly to kvm_gmem_revoke() allows guest_memfd to
  reclaim the physical range directly without calling back into the
  provider. This keeps the lock hierarchy strictly top-down (info->lock
  -> filemap_invalidate_lock -> mmu_lock) with no callbacks or deadlocks.

For now, nothing needs to be done when setting a page present, since users
should (re-)fault and (re-)obtain the PFN via .get_pfn(), to be added in a
later patch.

For users that don't support faulting, like the IOMMU, the counterpart to
kvm_gmem_revoke() will be made available for the first user to indicate
that the memory is now available. guest_memfd should then do the page table
mappings as necessary, based on the shared/private status.

Signed-off-by: Ackerley Tng <ackerleytng@google.com>
---
 samples/Kconfig               |  2 +-
 samples/kvm/memory_provider.c | 33 ++++++++++++++++++++++-----------
 2 files changed, 23 insertions(+), 12 deletions(-)

diff --git a/samples/Kconfig b/samples/Kconfig
index d4e79e1a9286b..4ef9328a91778 100644
--- a/samples/Kconfig
+++ b/samples/Kconfig
@@ -328,7 +328,7 @@ source "samples/damon/Kconfig"
 
 config SAMPLE_KVM_MEMORY_PROVIDER
 	tristate "Build sample memory provider -- loadable module only"
-	depends on CONTIG_ALLOC && X86_64 && m
+	depends on CONTIG_ALLOC && X86_64 && m && KVM_GUEST_MEMFD
 	help
 	  This builds a sample memory provider.
 	  Its files can back a guest_memfd and be mapped by iommufd.
diff --git a/samples/kvm/memory_provider.c b/samples/kvm/memory_provider.c
index 0a03623492f4c..926f3cf68ed49 100644
--- a/samples/kvm/memory_provider.c
+++ b/samples/kvm/memory_provider.c
@@ -43,6 +43,19 @@ struct mp_info {
 	struct inode *gmem_inode;
 };
 
+static void mp_zero_range(struct mp_info *info, pgoff_t index,
+			   size_t nr_pages)
+{
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
 /* Byte range [offset, offset + len) of @info as page indices. */
 static int mp_range(struct mp_info *info, u64 offset, u64 len,
 		    unsigned long *start, unsigned long *end)
@@ -82,12 +95,17 @@ static void mp_set_present(struct mp_info *info, unsigned long start,
 			   unsigned long end, bool present)
 {
 	mutex_lock(&info->lock);
-
-	if (present)
+	if (present) {
 		bitmap_clear(info->absent, start, end - start);
-	else
+	} else {
 		bitmap_set(info->absent, start, end - start);
+		if (info->gmem_inode) {
+			unsigned long pfn = info->base_pfn + start;
 
+			kvm_gmem_revoke(info->gmem_inode, start, end - start, &pfn);
+			mp_zero_range(info, start, end - start);
+		}
+	}
 	mutex_unlock(&info->lock);
 }
 
@@ -203,15 +221,8 @@ static void mp_gmem_put_pfn_range(void *provider, pgoff_t index,
 				   size_t nr_pages)
 {
 	struct file *resource_file = provider;
-	struct mp_info *info = resource_file->private_data;
-	size_t i;
 
-	if (index >= info->npages)
-		return;
-
-	nr_pages = min_t(size_t, nr_pages, info->npages - index);
-	for (i = 0; i < nr_pages; i++)
-		clear_highpage(info->cma_pages + index + i);
+	mp_zero_range(resource_file->private_data, index, nr_pages);
 }
 
 static int mp_gmem_get_pfn(void *provider, pgoff_t index, unsigned long *pfn,

-- 
2.56.0.455.g6c5a503b38-goog




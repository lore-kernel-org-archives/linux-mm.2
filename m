Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7F97E606A31A
	for <linux-mm@archiver.kernel.org>; Thu, 22 Oct 2026 23:31:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ca8ueo2L
Received: by kanga.kvack.org (Postfix)
	id A9EC76B0316; Thu, 22 Oct 2026 19:28:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A77C36B0318; Thu, 22 Oct 2026 19:28:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 98CDE6B031A; Thu, 22 Oct 2026 19:28:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 605B66B0316
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 19:28:36 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id ED55780305
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 23:28:35 +0000 (UTC)
X-FDA: 85351853790.03.743FAC8
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf07.hostedemail.com (Postfix) with ESMTP id D87E040005
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 23:28:33 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ca8ueo2L;
	spf=pass (imf07.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	arc=pass ("kernel.org:s=arc20260519:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792711714;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=v99w5dxZ3ep55xTaoBSOh99kTn+5G5ENEYSH2yCjB/w=;
	b=VX2Wp6sThxJxawqgnUhElw8/n42tgdTPQuNgjE7NVTFVNdSCwbvHuX9JhOfi11nIbZxh87
	+Eeogi0GlcLkBZwb3mWUdILRp27g1mWEDYFFmCh5JxDr7cdyitAsDYAg4KS9XSo5pLPOdu
	iV/woo+jrS6P5vAdafQIyiS3in3Yb2I=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1792711714;
	b=gGpb0O0R5v5tXrWRye4CFb7QVUf/zBZygH9lR4Xk8GUddF1FHNVWoyk63FxdF2/jqILw+J
	yQz8TZsH1noF0LmAszBu+OgBBNOojaVIgwpbagNOaYRk1NeCJtY0IKxdk9FjN6z51kOvgx
	dYYLE2IfXw8M5+oTlzUlbuQAFdn3zUQ=
ARC-Authentication-Results: i=2;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ca8ueo2L;
	spf=pass (imf07.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	arc=pass ("kernel.org:s=arc20260519:i=1")
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 145F4447E9;
	Thu, 22 Oct 2026 23:28:25 +0000 (UTC)
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1792711705;
	b=p1BvIvZFLbRIaSIqOzKK+AHKOsdvsqTIvqkEf7WozPEQAV0ctujEhh2QjO3MzoVsCdZB
	 vfFOYaOExAoV4MKjwIidSgMaAJJ+ErO1bdhF8AaCywnDw0EG4GEaG0XRqtq1unlRRfMAW
	 qqXGtsEB5iSuNkMLonjHh5mNzEURADUX7lczpGsuTi6HTqIgczCyHeX3CDt5vrrOKPtX8
	 OiEmDSTCQlQv5keSuztEfWU5XnzCX7JY+NzqMtQo61+oRDeL+x9hA2FhZo04KutSr/TLL
	 c1kwoKrZRNGZhSbMXxpPsWyUQw93Imb6TmwW7gH0guWZpwg8s0bWOWXYt0I7XQ7Kb4g==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1792711705;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=v99w5dxZ3ep55xTaoBSOh99kTn+5G5ENEYSH2yCjB/w=;
	b=g+5PKxF1wb88sGGlIXcJsguRrUwOScd7TO3RinG+LhFi1o5TUPy4ZdpGky5qkQxVFjEa
	 reIG3+ldXP043aULW9+QB98rEtwQpJ1uO1mPOGH4RmOMt9VkmjByPlIsK7CMprfDBtCH9
	 PGNEr/VoDp/ypnjTSjOL+/TvUwfnsahPyzw5OP6nLRsuaOjlQOuhNJ7bqdOLto6oS00Wo
	 DUJmlnoDkooOvmf1aeIf742Q2wEEYa0WBp66JCozavAkORWqtHh1JNiPw0n9clBa9unaF
	 uVlo5Ytk7FL3em4dvcNjSAimoAC7Xu3l77KoZEmhtARYuRaIiMct0fL7RlkddKQqDZA==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id 391011F01190;
	Thu, 22 Oct 2026 23:28:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792711704;
	bh=v99w5dxZ3ep55xTaoBSOh99kTn+5G5ENEYSH2yCjB/w=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To;
	b=ca8ueo2L1XU02A0VBu+te87wAf50B3Jm+68yRqpgsYTtQwSQILMEdUeKgTyT7pEH9
	 7AzxpJvDpVmNVHmYgkW9l0qerRAuPJ7hUS2DE85gDiSpMoYIIDuISKfrXsT0lGY47T
	 RQlC4GCHWvlCSZ455VzktbvM3B7lIJT/WnSBaPwPgpF+UPPb7UjcJOkQvX9iuhRmLe
	 qXMAcR97PHAdQ42cAJTbELjO2OPwVO3bF3Je05rCkMRMeU1It4/zTwqcAEyIK3VObC
	 dv8GNFa3ldyhZWovs5str6nHIItEKRUkCLVrrFsczBfo+LTh1VRVAID1Px8SCXbSI4
	 zeRrtWq2Hfldw==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id 8327F420FF;
	Thu, 22 Oct 2026 23:27:50 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Date: Thu, 22 Oct 2026 16:28:19 -0700
Subject: [PATCH RFC v2 47/50] samples/kvm: Implement put_pfn_range provider
 operation
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Message-Id: <20261022-gmem-alternative-providers-v2-47-5dd1dc6c660a@google.com>
References: <20261022-gmem-alternative-providers-v2-0-5dd1dc6c660a@google.com>
In-Reply-To: <20261022-gmem-alternative-providers-v2-0-5dd1dc6c660a@google.com>
To: Alex Williamson <alex@shazbot.org>, Alexander Graf <graf@amazon.de>, 
 Alexander Viro <viro@zeniv.linux.org.uk>, 
 Alexey Kardashevskiy <aik@amd.com>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>, 
 Ashish Kalra <ashish.kalra@amd.com>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 Baolu Lu <baolu.lu@linux.intel.com>, Bill Wendling <morbo@google.com>, 
 Borislav Petkov <bp@alien8.de>, Catalin Marinas <catalin.marinas@arm.com>, 
 Christian Brauner <brauner@kernel.org>, 
 =?utf-8?q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>, 
 Connor Williamson <connordw@amazon.com>, 
 Dave Hansen <dave.hansen@linux.intel.com>, 
 Dave Jiang <dave.jiang@intel.com>, David Hildenbrand <david@kernel.org>, 
 David Rientjes <rientjes@google.com>, David Woodhouse <dwmw2@infradead.org>, 
 Erdem Aktas <erdemaktas@google.com>, Frank van der Linden <fvdl@google.com>, 
 Fred Griffoul <fgriffo@amazon.co.uk>, Fred Griffoul <griffoul@gmail.com>, 
 Gregory Price <gourry@gourry.net>, "H. Peter Anvin" <hpa@zytor.com>, 
 Hugh Dickins <hughd@google.com>, Ingo Molnar <mingo@redhat.com>, 
 Jacob Pan <jacob.pan@linux.microsoft.com>, 
 James Houghton <jthoughton@google.com>, Jan Kara <jack@suse.cz>, 
 Jason Gunthorpe <jgg@ziepe.ca>, Jianxiong Gao <jxgao@google.com>, 
 Joerg Roedel <joro@8bytes.org>, Joey Gouly <joey.gouly@arm.com>, 
 John Starks <John.Starks@microsoft.com>, Jonathan Corbet <corbet@lwn.net>, 
 Justin Stitt <justinstitt@google.com>, Kevin Tian <kevin.tian@intel.com>, 
 Lorenzo Stoakes <ljs@kernel.org>, Marc Zyngier <maz@kernel.org>, 
 Michael Roth <michael.roth@amd.com>, Mike Rapoport <rppt@kernel.org>, 
 Nathan Chancellor <nathan@kernel.org>, 
 Nick Desaulniers <ndesaulniers@google.com>, 
 Nicolin Chen <nicolinc@nvidia.com>, Oliver Upton <oupton@kernel.org>, 
 Paolo Bonzini <pbonzini@redhat.com>, Pratyush Yadav <pratyush@kernel.org>, 
 Randy Dunlap <rdunlap@infradead.org>, Robin Murphy <robin.murphy@arm.com>, 
 Samiullah Khawaja <skhawaja@google.com>, 
 Sean Christopherson <seanjc@google.com>, Shuah Khan <shuah@kernel.org>, 
 Steffen Eiden <seiden@linux.ibm.com>, Steven Price <steven.price@arm.com>, 
 Suzuki K Poulose <suzuki.poulose@arm.com>, 
 Tarun Sahu <tarunsahu@google.com>, Thomas Gleixner <tglx@kernel.org>, 
 Tom Lendacky <thomas.lendacky@amd.com>, Tycho Andersen <tycho@kernel.org>, 
 Vishal Annapurve <vannapurve@google.com>, 
 Vlastimil Babka <vbabka@kernel.org>, Will Deacon <will@kernel.org>, 
 Xu Yilun <yilun.xu@linux.intel.com>, Yan Zhao <yan.y.zhao@intel.com>, 
 Zenghui Yu <yuzenghui@huawei.com>, x86@kernel.org, 
 Shuah Khan <skhan@linuxfoundation.org>, Fuad Tabba <fuad.tabba@linux.dev>
Cc: kvm@vger.kernel.org, linux-doc@vger.kernel.org, 
 linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-kselftest@vger.kernel.org, linux-mm@kvack.org, llvm@lists.linux.dev, 
 Ackerley Tng <ackerleytng@google.com>
X-Mailer: b4 0.17-dev
X-Developer-Signature: v=1; a=ed25519-sha256; t=1792711665; l=2119;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=pi2zso59ygjDMW0jQ8vMvbcQ7Mg17Pfm1HpOzHVZMT4=;
 b=FeDMpombwEf/FE13JwARgBMWuXk+ng4trAiHCZK87Mj+RPNNvF/snx58olAl1/HscRsy0XR/d
 fXqX41lY3XdCh+hR/hmQDnI3YEr/FF1ORAq9/bz1EuVkc/iBWwk4zYH
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: D87E040005
X-Stat-Signature: r7z1sm97a1w7p1tfcqjk1t96mbarbtdm
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1792711713-340570
X-HE-Meta: U2FsdGVkX1/Um8NXKEv0XLiSc68VPb3PmZrmAsbVHVrkSA5gP4oOoRt6Zw7OJWnH5YM0cpPqkGWp2nndtLTU2FSHHCscEw20GBeHbdhPGkphqez+wuAkGklHzKC5q0fawm1nj/nPr+m7NAsK0NBUf2aZTIyFNBa141P9dq8EMXnu3r2wRz/fAmPxAsa21+4uNlifQBG4EO5UAFGbbkCMEd+q/qmi71Z+9gw2dTI5eXoLT+EgKZPb5rfb/rylf5PnNzGgetDEEbcS47phep3A15gttynw3McIqAp2ENkBaUvc5Iv2tIJ9sJACAZ4zzc4OWvF2VBPhQsQ30CM3gH0Yt0HlSNa6PlrIhBYGWn/qbIDnePJ6ldYQiHpVefeFeug7RuI2KmANqfWc1jhArJXZuUm2sxk0kC5zaRv0S6FUxy6stYEJKSf+6M5MJrAhfKqrelxaESrAFffkjdzrvMeo0NeV+kFn/QAwBbLRpviPphjrWbSVBrDIR9alLTQPLFAJYLDMa4ROCAVrbA4lpL2pIaEHxqzqVb1wLuTtnsnP9GSrx76eWHhJQwkXaAMncJBe5hD2jP+KE7dEYOTCQQYVUC1LM7hQLKdZzsrY3q5Xg3mD5epUOjwWueOejO7qpQKyDJmK5Cz5TDiwy7gYxjiFMX6IylXNSzDwWkAfRUd3WxmP41c9x3BOZ1VWWF95+IyDc2fhgu7e+9XCkK8pnS3GnmyOt4uxkAsBTRuGS1fL/UlkahJQ+U/lIJtWFZC+X8UuclGjSlILuQqfOYZqthdStOdZ2PMjOBxJpoK7xR+RBLgJ0JhJCAUzTIoCeL1JBL9MJhTPLAmYNV0WJL+ibtLbBCYm14vQi6xjAYJ5wp4EIdQvNmiqkFiopgyzhiquGxQFASjLqk4zkCiwhjgWztVy+pF24mi0JoZYS4MKuAd5GRiG2fWuGFNkcjP1ZBYBNcVYiIdAJhRJ3CpUxXXG9WW
 xC8wDwo3
 24ew2/6Fm+CRJQdulgnHc9FZPbZtl9ha7H6hwfDtwBFYOtMBiXj6HV72+Hidno8/T7f8ZMorEpVi1KKSOwq4Qg1/CjwYRW8EC0Sspn0zWs9T8XP+SikpHRt2wenC85/pUpeSxiNs0ebFBLdiwOXLSA0jXmzYR4Kk6Vv4gkYgdI5yW/1IHxZeU/q1kAUWzMJaTet/bE2rkuAZ3nzIFlUA12WoGqXfa2goCrX8gW+OUcl0t3UHvupHLQdfjqj1kaTQx9DF3uEnTD/as9HnOyf55i7loB38O0ccr1URUlRyWTtjccFAOWFGiomewy4XTcVzr6WwZTKsy5/wD7aaNSfwxosN1kR4+4DzZv1R8qoKvc8V07fYfbau7b9oeXhJ2SmLqzjNPgCJuT1Wsl4VGAbfCf42FvnISHOUEjXk7A0CQ0LkJ+j2xM9NengYyCZBdvqvzKR45uKVZZNHPeyiCQ1UMulFgKvSLLGVUZwBlCq60FEBbngqzhkr6AMYNv3VjV5xAcB0ZiYu1jfdMFQvS+7R9oHG362LpT6SGmqIGj2z6hDa9ypN49/DGBg8JnLoiBIKpigPKRKH3NLIrEp8DyqrZ1YydWUDodRKemiHnWRp6/8i6yLZdILstFBejt5Vt0xRJ4EJ9RIwYe57UkPQ=
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
 samples/kvm/mem_provider_sample.c | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/samples/kvm/mem_provider_sample.c b/samples/kvm/mem_provider_sample.c
index a43c76d2259e7..dee15179959b2 100644
--- a/samples/kvm/mem_provider_sample.c
+++ b/samples/kvm/mem_provider_sample.c
@@ -17,6 +17,7 @@
 #include <linux/file.h>
 #include <linux/fs.h>
 #include <linux/gfp.h>
+#include <linux/highmem.h>
 #include <linux/guest_memfd.h>
 #include <linux/io.h>
 #include <linux/miscdevice.h>
@@ -40,6 +41,21 @@ struct mps_info {
 	unsigned long *absent;		/* taken away by MPS_SET_PRESENT */
 };
 
+static void mps_gmem_put_pfn_range(void *provider, pgoff_t index,
+				   size_t nr_pages)
+{
+	struct file *resource_file = provider;
+	struct mps_info *info = resource_file->private_data;
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
 static int mps_range(struct mps_info *info, u64 offset, u64 len,
 		     unsigned long *start, unsigned long *end)
@@ -155,6 +171,7 @@ static const struct guest_memfd_provider_operations mps_gmem_provider_ops = {
 	.attach		= mps_gmem_attach,
 	.release	= mps_gmem_release,
 	.get_pfn	= mps_gmem_get_pfn,
+	.put_pfn_range	= mps_gmem_put_pfn_range,
 };
 
 static const struct file_operations mps_file_fops = {

-- 
2.56.0.257.gf7497c7d27-goog




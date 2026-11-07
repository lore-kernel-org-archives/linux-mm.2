Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 26ED0606A800
	for <linux-mm@archiver.kernel.org>; Sat,  7 Nov 2026 00:39:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=nMhP82yy
Received: by kanga.kvack.org (Postfix)
	id DA7006B05DA; Fri,  6 Nov 2026 19:37:13 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D04026B05DD; Fri,  6 Nov 2026 19:37:13 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BCB976B05DC; Fri,  6 Nov 2026 19:37:13 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 82F7C6B05DA
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 19:37:13 -0500 (EST)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 2C22CA01DB
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 00:37:13 +0000 (UTC)
X-FDA: 85406458746.15.45BD1E9
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf29.hostedemail.com (Postfix) with ESMTP id 0EFA4120006
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 00:37:10 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=nMhP82yy;
	spf=pass (imf29.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	arc=pass ("kernel.org:s=arc20260519:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794011831;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3GnmpH7dsegBwAqwdCVeM7wi/vP60xMNTkwELMScKI4=;
	b=ogGp3g942gjoU4FV7K3/V60tcnC5LlYDX5YAwIlVCmW4asogbxe67jj8TeDQ7svsKQ0+Oz
	GPSThlZlmoEqapt3WY9WgsaHjsV4RNfyaZWYCO26R+vm4t3p4wPEOY9Z+pYtWDOb2DZx0s
	0ViSZebURLy+LwE+OrjVWd2a37qx5ck=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1794011831;
	b=XHIyCGY3RzuzT2TdZB9WyiHSdjklCCwSky/j3QZTNLvlKQ2P+VBr0fZFiTG0T4p/0x+ZoV
	3bs3S5zVj87rxtJlnj8GukwZj7KiBaxhXpzYMNx9DxKCM2ASG/RDVHvcOqYEWQvinfMIeO
	G5XBiJndN5F7lyk8hl4TApsbnXYsZ24=
ARC-Authentication-Results: i=2;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=nMhP82yy;
	spf=pass (imf29.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	arc=pass ("kernel.org:s=arc20260519:i=1")
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id CC0FF4017F;
	Sat,  7 Nov 2026 00:37:10 +0000 (UTC)
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1794011830;
	b=iRwjCTMB2xPEsm10Ult5vAL/NYGPDVXYJGfMOInsWQhTTGWOjue9Txh7c4x7SURVzzLF
	 fphrSezG0ZX9YY0wsXFYbgKj5PmEB9b6rkuJFtcolB5VwwsvwoODNT6i+DdfXd2QRk6Ha
	 /hMJdHD/waio8CFNigCgPw00ggOKhQ4Bxg3ld3duDD/QN4/i6oTz/MXzbZFGk0Nj+kICc
	 E1WTwEEBd4+JDhmqECA0+2EtSBfeF0hOOr0Oa7flGt31OvmiatHQiN1SAhZYhCR3NdErD
	 eriDhqEYzKOhlarJJVn/OgvKr9uPMyAR5pbpjE+kBlSclJ0IDl/uUt72AVBivgcVg/A==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1794011830;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=3GnmpH7dsegBwAqwdCVeM7wi/vP60xMNTkwELMScKI4=;
	b=JoqKwrnf1UWuwpUBAKVhVQDUPFjoGw5FG1GVTfMg7/PK1EtR60UOKw6JnSAP/lNKRVn4
	 0UqSPleQuXm55X0f5JdIZTWtrVMMiKEcbI54rHDUWnPVIAB4rIhl48NfEyD0M/+FCGV9p
	 UHWBHJFtk9NQkgZhLQ4iXaCqFjiDI5YR2tcqq+93xOTM6cS2VCcGxbzBxb/lEbeSXO6YF
	 yKSLxwXIqrlcah5TYlfUYGpvyOVGGEfQEjQY+ygmU5cuoFWchHjz7rH2Q2qWCrggn+8im
	 nvJp5dfqA85OAAKEcrgc2vBUF/uZAFdXnPHzDwREr+U/hUZKEpKAIFZiRYNsbRS+F8Q==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id ED7F01F00AD2;
	Sat,  7 Nov 2026 00:37:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794011830;
	bh=3GnmpH7dsegBwAqwdCVeM7wi/vP60xMNTkwELMScKI4=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To;
	b=nMhP82yyFkz5GzVdaCsbtel2d/04RF/m8GXflbi8q4zs3xPDZd39sECI0f/vrEZC7
	 2W+fXe7iSCC6ebG9vp6D+MpIvb9UasyH2ZJCnFZOLYDJsNXdio7OOVAN94gts9MzA6
	 TD9xBL2nXmZPXrmnLF+6eJLieIipRspCGQ0Xdy742y9Trl4U7HUlI/ancwOB9TmVKO
	 2lL3Py0MhRC1pzEBqB3C3mMrOTHcm2ET6N+mWHMVE18ZgeaZ9D17t1LI3Kh47qk8vj
	 JDTHdXxXBQk2d3r8kSOjkWEnfGgBBPCiL2j5nbQddOHWJqaGt2crCALGPPWPin9j9y
	 0QBRnFu+qWM8w==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id 15924479C7;
	Sat,  7 Nov 2026 00:36:56 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Date: Fri, 06 Nov 2026 16:37:20 -0800
Subject: [PATCH RFC v3 46/88] samples/kvm: Implement get_pfn provider
 operation
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Message-Id: <20261106-gmem-alternative-providers-v3-46-8484dde66a7e@google.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1794011810; l=2542;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=tCKXiyHtpuefvmYVDpsKn5DHw0pcR3E0UpVIb8EHbec=;
 b=XcS77Ehs2dDxmkzR+K+/PQQXHnS5i/ylsKXkNTcKFJYWNqfe/67XQ4asLhBTtPVhKbokfrsMk
 9fTuOHWRmeiB9cV4r08Y2XGxaZrDeKXDmooUisiB2STC9cUFglVZQI2
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam09
X-Stat-Signature: cfkn9uichz6ke1hjyckgfoca9szkct9z
X-Rspamd-Queue-Id: 0EFA4120006
X-Rspam-User: 
X-HE-Tag: 1794011830-502031
X-HE-Meta: U2FsdGVkX19Yr/nCKqs8jfS7MwsxzKN09zyC+nDWzuzqiXloRIy0IToNuY75U8qk9LmIk+u/qB7QObMJWmBsQpGOqG6ynu4LiSlm9xFaV7ryUOhvC74Rq5PZaZdDjckEsj49C5gk25A0k0WuID0KOjfEQTR/AapkEmJYsB3FNDU2tL20SNJFIi8TOEXYgLHNo4HI+onvGNhQ9OmBYhwR9CHItvPgkVD69WPj+FTetwp/1vJ5pCTtIa/yXI5yy84EzTdlH+NhIMH0Jmwr14Lt2G3jfQS0qD+AGEnCYGsyC9DLtiaKFKA0kRVBfRBmiLVssNTwlb4f88PBUqmdGw/O8ysBuKkoOssq0EwEU4wEchJN+UPB7WJ0SRt+N6w3of1j6yRdk4uOoF/PNe+IhGL2u+Egu6h12Few1gvsaRPTQ4Up9IbvCILHZ0FIYCbLt5Z328gLzq4Qc/MX3IR7ibVPlG8Qx2rORUL7nIcrqWMBFbYqNgSimmq0PrxPum7CUI01poUhS0YDOCGKEnrrNDugk4xI+Rl1ByhQdjjwFTInnKCJ5H81ktKgLozAQ2zk8crIcUJfC94+Z89SrYdF2ZEZVQTvWCGGX0X/RAd0LOpe//mWrTXd7JelXfHkrAu2V843BU/4IoKQOwwvSRF/np/bE1+U8hVBwWLyZuQ/8BpQyYrGKAFrI2PmUzN4dFbp24f7EdZ045hqlf565gYc1VRDsiTNbvwUTMISCIdNg5d7/YMxyLFbAeoXDHGP8M7vAkRlXfgs8NU9AGlSC4rN4rr99Y7uzlQWZYW/2ZilqLRcQ+qIdd4S5dfQupUrJO2F610VvYLA65vIRFOqmQ41vCGRNctfV9wVAjYEQ789r28XrsITTTbq/6hCBNFZdWse2sOw4q+Jnht0aDjj9VVwMdSXQFm0x5zDI/dcpnsghuBPF0reORqBVh/D4Nui7tDx++mhqAQX6vy/y7MfQGys3qD
 vYHN8E2X
 qfbUh4jrbhMuK2GE698rC7T5a34gKL52M3bzqJ01b71piRNRLUDmRvOP56EDawRgOsD/bg2WAWLJ9y8bzUjIds2ga8inqUSHMyg7p0t6RWy3oPehjRp95vhO+28su417JnfZ4IccOCRPKCRi2+wExvJPx6101ws8fg02HdA7J4EYN/Ra+ZUuJXDrTj6BOaG121KkDvoug3uKgUQBYKxdzxomrBnpagEbRLDVcG33BiI/ZYF+88nvSZ3RcXRZy1oyplb9+DqtXA5NfilASF8UeuAyPs38lhOczBbzsY7yvWwnr+8M+76chCZpyUUBpDshjj7b8Ca8+EmPf9BwUACnDPaAM1TcL7XvF3B3oORONYS0UnSTjb4dNBce05dRXT/w0PirmvM77DT64Y6rAEhU/WZbstava/0E9oecVmMcCB/2NN7HxmwFw1R18Ozpvbk5TnLHEkSQYqKqlJZeGhQUsItSTiXgm0KsBQpCOePrzjwDcvmHJJMWAvSwxf/jneU2snAj3seDX5j3ZK8+ICnrML0/NpPYHum7hs2ghl4zFPaXi9xwMvu3AxChqeoM/QB8Xar3RmD+cWejQRCkAFGicPyKbSR1pj1GfHtka
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Ackerley Tng <ackerleytng@google.com>

Implement the .get_pfn callback in mp_gmem_provider_ops to operate as a
direct PFN provider for guest_memfd.

Implementing .get_pfn satisfies guest_memfd's provider operations
requirement, enabling memory_provider files to be attached as
resource_fd memory providers for guest_memfd.

In mp_gmem_get_pfn(), return the physical frame number corresponding to
the requested index from the CMA reservation, returning -EFAULT if the
page was marked absent via MP_SET_PRESENT. Also report
GUEST_MEMFD_PFN_ATTRS_READONLY in pfn_attrs if the page was marked
read-only via MP_SET_READONLY.

Checking test_bit(index, info->absent) and info->read_only is done
locklessly without holding info->lock:
- test_bit() is an atomic memory read.
- Locklessness prevents lock inversion and deadlocks. In guest_memfd,
  the guest page fault path (kvm_gmem_get_pfn()) holds
  filemap_invalidate_lock_shared while calling .get_pfn(). Avoiding
  info->lock in .get_pfn() ensures no lock inversions exist between
  filemap_invalidate_lock and info->lock.
- Similarly, while kvm_gmem_revoke() now takes an explicit pfn and avoids
  calling back into .get_pfn(), avoiding info->lock in .get_pfn() keeps
  the lookup path completely lock-free and robust.

Signed-off-by: Ackerley Tng <ackerleytng@google.com>
---
 samples/kvm/memory_provider.c | 25 +++++++++++++++++++++++++
 1 file changed, 25 insertions(+)

diff --git a/samples/kvm/memory_provider.c b/samples/kvm/memory_provider.c
index 168c1d90edacd..1db69a8f58758 100644
--- a/samples/kvm/memory_provider.c
+++ b/samples/kvm/memory_provider.c
@@ -198,9 +198,34 @@ static void mp_gmem_release(void *provider)
 	fput(resource_file);
 }
 
+static int mp_gmem_get_pfn(void *provider, pgoff_t index, unsigned long *pfn,
+			   int *max_order, u64 *pfn_attrs)
+{
+	struct file *resource_file = provider;
+	struct mp_info *info = resource_file->private_data;
+
+	if (index >= info->npages)
+		return -EINVAL;
+
+	if (test_bit(index, info->absent))
+		return -EFAULT;
+
+	*pfn = info->base_pfn + index;
+	if (max_order)
+		*max_order = 0;
+	if (pfn_attrs) {
+		*pfn_attrs = 0;
+		if (test_bit(index, info->readonly))
+			*pfn_attrs |= GUEST_MEMFD_PFN_ATTRS_READONLY;
+	}
+
+	return 0;
+}
+
 static const struct guest_memfd_provider_operations mp_gmem_provider_ops = {
 	.attach		= mp_gmem_attach,
 	.release	= mp_gmem_release,
+	.get_pfn	= mp_gmem_get_pfn,
 };
 
 static const struct file_operations mp_file_fops = {

-- 
2.56.0.455.g6c5a503b38-goog




Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B9F98606A323
	for <linux-mm@archiver.kernel.org>; Thu, 22 Oct 2026 23:31:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=aiuSsjC7
Received: by kanga.kvack.org (Postfix)
	id A78E26B030C; Thu, 22 Oct 2026 19:28:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A289B6B0316; Thu, 22 Oct 2026 19:28:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 76AEA6B030C; Thu, 22 Oct 2026 19:28:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 4BCC36B0310
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 19:28:34 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id D22761A0343
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 23:28:33 +0000 (UTC)
X-FDA: 85351853706.19.070CA7B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf18.hostedemail.com (Postfix) with ESMTP id B5EBF1C0005
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 23:28:31 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=aiuSsjC7;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	arc=pass ("kernel.org:s=arc20260519:i=1");
	spf=pass (imf18.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792711711;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ROFoDfXLr+8h5XvRPeu91xEdbC3X4qUY2VpZ1ItAUmo=;
	b=e+EA+9MNRqU04e++qE2CxWccKpEajmrJARbi72l3N8nKDHYeiEiT6vlpaOqtKS2MkvC9Ff
	0TWr5fpKpEGP8vA3TyhaYfybh0fVdFO2XtQfQEQ7lFMIlBitKnYVaA31kavb+cHQZtlFdE
	RvhevBLiqQUNj+Q0xlc5+hoHIqpe4Eg=
ARC-Authentication-Results: i=2;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=aiuSsjC7;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	arc=pass ("kernel.org:s=arc20260519:i=1");
	spf=pass (imf18.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1792711711;
	b=uPb0vXLzaIaZdjDC/ost9ec4RAL8tsTf04RDbKOm0nNDbKFmJ/5mqFgR/ykCuwouwlz8Ws
	kMrwCqmr6gTKLA19FITOgXIZYnUl7CCS396KtVaPrBFC3h5IxhlIDOvV7l6m7j4qDZqxwn
	hkl180lqJY2z40Bn20BzaZtPwr0hwl4=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id EF7E744852;
	Thu, 22 Oct 2026 23:28:23 +0000 (UTC)
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1792711703;
	b=iFsNIYy//bJY9LWnPj7fG+/Jc+DNZdtN2FqGFPol3W6BdB5NpR9eQL9zQXD9moialPXB
	 HcmSZAKbYoXLZvjZqfs3aXqI/dvCytMrBr/a3W30dZbQwIGy1XsZvLk+h5HhF51zvl2vY
	 22OeUUglLQGFCw16s546zVS4wTkTwvSBF6nSRFceAPIlnGzUMVYec3upBvWHDbFvS8FjS
	 S5UqEod45y3ZZoEyG6ZJiJjPU3r8ceyX80FlSJUqVLwtuqVSKJMzuvZGG7HT/RHZiAL0E
	 EboT+F62qLq1s9YnSIYbNbGJIfp5qSAapbhkE3tlVD1XU2g/7AZzQ8CMJZj5spyvhmQ==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1792711703;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=ROFoDfXLr+8h5XvRPeu91xEdbC3X4qUY2VpZ1ItAUmo=;
	b=aaWijaK5vV5619erIg/Hy/AOtPTACvBAVumGBSk/CZOWtNEiLx4UIkpKWX881LPJF0L9
	 +gFMP93yvY4Sqkj+8nm+Rg+4aiTQBsHNIu031YwA73GJRmGA7OkwWsqmfxJeY+HYfydKT
	 uXAtg6yKlWB4Beiwgs/7HYT0xycewGB/76uuIOSpcFoHQb89Z80n9pjB+ba95qROvG5VI
	 rxxw2aI3NUJ8wfhwI9xAVUBOVSjGYKc8H1d3vYwMrXu6oT4W0oikvj2QpcO++l8c2z6rn
	 wJNDfrs472bhBs9HkRI0sLOykrvvl9fPJcNseS7HNMp0u0+lKFalE+zbj2rv95EQbUQ==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id F24891F011A0;
	Thu, 22 Oct 2026 23:28:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792711703;
	bh=ROFoDfXLr+8h5XvRPeu91xEdbC3X4qUY2VpZ1ItAUmo=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To;
	b=aiuSsjC7Y5Nab4w/cOkUGIcBTSExvYkyb9+zCvOv/pvi4pkiQ9CUUBvswI8huzck3
	 S89pM8+0E6AX1pW7ujFT1i+Nm+WpyX8ep2J8No98ybSU6I3jZHeYl4W48vTY4y/YV+
	 R6pcqZwd6OvIL+/FpXtP6HNuGc+Aw6jLKifRJ3cZ5joDp8zMWjD/Q17aYXqPC0jjy2
	 78aqcKdcs0XdU/ZTR1kyI64LjcsgDCik/nqHr1pwM2hIiILDahKnSlG5a95dKkHJtC
	 EfzeIr800FDeUTMYlGdPMyqT1MkvprMXY1G5xsHyTvKSnznMz1XlXNhkUU43LtDg11
	 pgdxSMwXitO9Q==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id 9A04442108;
	Thu, 22 Oct 2026 23:27:50 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Date: Thu, 22 Oct 2026 16:28:21 -0700
Subject: [PATCH RFC v2 49/50] samples/kvm: Implement lookup_pfn_range
 provider operation
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Message-Id: <20261022-gmem-alternative-providers-v2-49-5dd1dc6c660a@google.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1792711665; l=1549;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=Mxwswz0tvmW2OjORg6A0NdxFcOvRzA8Ssc3edQQqFSg=;
 b=uAEX7tbJq1SltgB41mlSqmIm26HGCsUypikhFQvshzacFVhKqK4FkVxWyJYlbJKGLQp0VnDdB
 rtv1tClBr/XBhmCLSd6iQcsVFyWoY4LD4toRb9Hbbbcs3BUKSC+/2mC
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: B5EBF1C0005
X-Stat-Signature: otn1djrpxyc9tg9dx5xqhgcka64rddyi
X-Rspamd-Server: rspam04
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1792711711-326940
X-HE-Meta: U2FsdGVkX19CGpGuNYI1SJ39jpd/G0utCvvQXjpdIbB1gSeJdXFMAV+lLzSm8DKOtljUYA65y8cT3CtOfsq0YPY6l4D7fw29BVNaWzFOTakLdKY2HPlBlZP2JSnbgQLTh4AvQRzNHZ/AqPXy5bv09R0pnHVyQ16U2M/xcXNBvIVgCDuEU7xAFfR7s1j2xgsmqvpT08nDSNN7DEmxIT6+vgici82ceU0yrpN6JNmVpOPX9lxflFSllxC71xn0yV6QD0PMfHmVeeYuTZ0TalgiYL8JCZ7+4pUpha4f9tuvRXnKs9Ko7tVufOiaXtk1E1Dc337gYehkYrf81TMtwCEFx5vZ1OSeyg+uH4H9PCWD/SrosfjC0mlBnWoXdiK7CHDmxKA5j1bzlLT7ogcpwgzqaB1mdfa6WVnCmPKHECBD3grWa7RJyfS/wAo7pIUiYQSP7gWCgXqg/+w47GNBcRqQbbHy2yCfjfU2qoyTqC1XgYbp77NUBTCKscYAL7lePYv6wyzMcxy8bKPGXrUaCbu70Cf+LLeZVg9qv9YnvtENi0AIUY4k9VRijK6icvZeMvaNhOYg1gANH2f/Gl6asWlif5Ar62+6X1yfRty02igq+sO5mCFO4/FFyvi2hzv2iR5EJVd6D1dCSSKtB3+RsD9DA665OkxENctKMcjtODhgxVvqTTS7trlkU7U77kGpsWUotDsYCiH6SALTW7v/xA+xXj/xrLUz/xMKaC1ZuCtss0OYHn5FnaP1Pe5xkV4LwKKuOffnOc8KQ0ChWzEBnyC4VGXDhcBTVmezPvjgxpmEUyYQ09KfWVsizwFIMqnzTYYTLJos5FEyzGNTVCpLkN2bVIZkc4vkX8lZznrw3WOWxqhAxvfp9h4XWcjvgtumxy6zMPzrpQoFZ9hkuyvwQR5x4m0Z1qYiQLkwaQ4zqpFzEzRcenfKiJQoEtWfYqtUcqdhMBXUldWA7YLdXoIYgXA
 tFHkWrt/
 8hU898/SrGxqghefERjrA8r2N8pWr1O6zHSibswmOcWJvhHuZdVZyGZ0GP9zs2jK+sNOYUeY4Ax/h4jjDG6/dGI8/UvV6f5FXYck9cyr6eZByXPjXdQk8Vf4Sjva0Lc/5gY23DRT9cwYa/gDA73yTzKnlOXyLtekMPnSiBIRaspYu29vasocMM2rtbekMx1ilMDqUCaYqxPmgL4FQ4+YATJnq45UQzJ4G1hnFIQ0neanJqMKR8euXGDVvdg5pU4X0kstQ1eGKp9MhsGqwUA4DVp6FIsAgG3LFm9NzQVkEyrawshi7GF8MvPnzxbvLVpCBBILvfjL/X/vJ8myXPAc8kVjrEb0KHj68vvEaDPQDHt9g/59JZz291I/cbqeklmfjVj5YxsvtSvKifASYdhuR0VJKwxI+KQsmtqOtH7+KpGP8N4KKb8BAyKxH8zX7eeAEV+LnE8a4qnuAHqeXDSlmDDfypRFiu95D4Lu05vaFFQQa2eoIMuuphhGSkWNOUiThHAQSFzw0qRAr/dyZ1ulzuVZA68n/ic7UEO4umFbsSrRN9a5bG+nhh7qVothfJlgA4DySk+38/Q0N+cy53kZpM8a1tTnm4Jqzpjkp
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Ackerley Tng <ackerleytng@google.com>

Implement .lookup_pfn_range to allow looking up index -> pfn mappings to
satisfy guest_memfd requirements and make this sample memory provider a
valid PFN mode provider.

This sample memory provider performs allocations upfront, so
.lookup_pfn_range doesn't do any allocations anyway and is only slightly
different from .get_pfn.

Signed-off-by: Ackerley Tng <ackerleytng@google.com>
---
 samples/kvm/mem_provider_sample.c | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/samples/kvm/mem_provider_sample.c b/samples/kvm/mem_provider_sample.c
index 3fa0d1a4335b5..5496e0c7864b9 100644
--- a/samples/kvm/mem_provider_sample.c
+++ b/samples/kvm/mem_provider_sample.c
@@ -197,10 +197,28 @@ static int mps_gmem_get_pfn(void *provider, pgoff_t index, unsigned long *pfn,
 	return 0;
 }
 
+static int mps_gmem_lookup_pfn_range(void *provider, pgoff_t index,
+				     unsigned long *pfn, size_t *nr_pages)
+{
+	struct file *resource_file = provider;
+	struct mps_info *info = resource_file->private_data;
+
+	if (index >= info->npages)
+		return -EINVAL;
+
+	if (test_bit(index, info->absent))
+		return -ENOENT;
+
+	*pfn = info->base_pfn + index;
+	*nr_pages = 1;
+	return 0;
+}
+
 static const struct guest_memfd_provider_operations mps_gmem_provider_ops = {
 	.attach		= mps_gmem_attach,
 	.release	= mps_gmem_release,
 	.get_pfn	= mps_gmem_get_pfn,
+	.lookup_pfn_range = mps_gmem_lookup_pfn_range,
 	.put_pfn_range	= mps_gmem_put_pfn_range,
 };
 

-- 
2.56.0.257.gf7497c7d27-goog




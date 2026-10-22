Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 75AA4606A321
	for <linux-mm@archiver.kernel.org>; Thu, 22 Oct 2026 23:30:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=gFJYFEm9
Received: by kanga.kvack.org (Postfix)
	id 9B4906B0308; Thu, 22 Oct 2026 19:28:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 98E776B030A; Thu, 22 Oct 2026 19:28:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 87BFF6B0309; Thu, 22 Oct 2026 19:28:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 559646B02FE
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 19:28:28 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id A4FC6160315
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 23:28:27 +0000 (UTC)
X-FDA: 85351853454.23.4A94B28
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf27.hostedemail.com (Postfix) with ESMTP id ADFCC40007
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 23:28:25 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=gFJYFEm9;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	arc=pass ("kernel.org:s=arc20260519:i=1");
	spf=pass (imf27.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792711705;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GSyw6Ljics0B0SjVoVtEY0jzr9tQ8ltn7Ym8k/iOA0U=;
	b=uckE2y9hQPOphr18FMPKVAS3i3lheDq95RC4vJp2LRX21mtsODB+Fe/5d+O+2ApgHpd7+v
	9XxI7bD3kA5yVr32yQ+/4tEpKbVkZWGKaSxt68pmBG8KW4rFoDlCph8KJ8E/Tkamlo3m2N
	T0tNAZz86UwfG8QcCk1gz4dqS+s5atI=
ARC-Authentication-Results: i=2;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=gFJYFEm9;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	arc=pass ("kernel.org:s=arc20260519:i=1");
	spf=pass (imf27.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1792711705;
	b=y5S5OX5H7qIUc8PDtclKiMW2MqrM5GUlUKQabvU5OpJcQZMilFSYujeLajYhl7CvFX2dnD
	cYP47CgB5Rze0i/KJHsQubBWh3c5whobu3u5RqtoRKGjnUhdSEffclYVUWFfKBVgi3+Myc
	cJBBMuYKzWbCu39J4Nf+o/pm6jFV1Rs=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 565FB60DA5;
	Thu, 22 Oct 2026 23:28:25 +0000 (UTC)
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1792711705;
	b=X9ixk91bXKFYRmardpY49+nfd4BKvfg2Pd/G+kBE5kqIEvUgPlk13M/UsoEl5gI2A0jo
	 yIAz1zbDFZE25o2dvC95O9ns7EPbS/CZhUWgjly2TVniFZrnpFhd23dgBBjlnKOmPmiUE
	 paagw2b19eab3EEDreUaA4yd3clW2WOgAHLKmdrcvTHyvCM87lehF8JJuCxcnAk//9+rM
	 2YOt8R9/rhjlsKOB0qi4emN7VB+OEARHVjOp2/KtVKcXGG+QTJz01UuYQBum8i1kD95Er
	 RddLGHed74sOjLF829mfbBG4bj+pw/Qks0hxQSO1dyk2UntS5xRfOhKrgDeZ0uejkgA==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1792711705;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=GSyw6Ljics0B0SjVoVtEY0jzr9tQ8ltn7Ym8k/iOA0U=;
	b=0y5u8C6lAc1ovphGEpOzYStrbT+SFL7KVRZadS8myc+pxvUrLiKtHHAu66figpIlZZq2
	 PO8qBmTf4wguC7/ScNiyPtJ9VS3VbPmkXo0PeGXSSry2H+zL62c741wQcM3dk/61bp/j7
	 hMncaBDQQnpcaKWnxZSCDoJTeOvFnYbUskAQHSRiZVvhEv+lVIn2vtcEsHWF1CWOlMChU
	 MocuX/3XaFx/D0FuL87/w92Gs0fYKN6O0MfTPacoD6i8Pob13FI5lGMoKylCqn56TaBHC
	 tZ67U4poQUzZaUmg3pPAb3akK+gi+XKA8ahI/67n8H2EIkKcAHo3FHYQtjD6bCwffSQ==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id 853E31F011BF;
	Thu, 22 Oct 2026 23:28:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792711705;
	bh=GSyw6Ljics0B0SjVoVtEY0jzr9tQ8ltn7Ym8k/iOA0U=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To;
	b=gFJYFEm94cycUDvhjQs84BUNbfD12od55Y9D9SwbKwwrcJONMi/Et+yVvxxbwYWNf
	 nl+1iDhlPGLpD3YbiF3rpCV+KjJU1YFOZxMC31fR3LzlUHbKz/8hK1S18s2BF3vlVf
	 XubnMuC5E3T5MbZdJxR9TNFTgUPHuWpPQnvJdHXl/i/FBaWKiXy6y8KytAwkYsN/Ht
	 anQuVCixaHdCS5ujPhRcRrKG5lQ2Ztbt4Xn2lVC+rvrYy3RoSWoIhDNufjrs4IrsfW
	 t8hNPnL0iAjxhZBBlsGveZaC86+YhHaPDhum+CRxmkfmHnayLsPRhewq0VmJg8WZdO
	 MJ9s2pfctyZiw==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id 6D494420F7;
	Thu, 22 Oct 2026 23:27:50 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Date: Thu, 22 Oct 2026 16:28:17 -0700
Subject: [PATCH RFC v2 45/50] samples/kvm: Implement attach and release
 provider ops in sample provider
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Message-Id: <20261022-gmem-alternative-providers-v2-45-5dd1dc6c660a@google.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1792711665; l=1898;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=KGuPGvRWcbKGcEsNC27FbqmF987N6l1g/xr1+ZAzxc4=;
 b=Z8JHLu6Ste4p8ZrYRqK06GDhAVo48QV4XZ+VWzhKHyf7aaqsyXhbrwWLtjaRHzGTMt3dr8qvY
 4A+I9EpN32UAecHoaXDspE+Lg0dT9WcHVIl7AcXBRh4n+ovXjEly61w
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: ADFCC40007
X-Rspam-User: 
X-Stat-Signature: 3jajnc9gyhrmqopz5i1w3x8xmhyc79b9
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam03
X-HE-Tag: 1792711705-495883
X-HE-Meta: U2FsdGVkX18ili5XtnHJEXQp3epVpSDvDjrTqGlKatmUyVvhm4pZJgCOleBgmkGmDeyEsdZSgsZT7s3b81sJk/1aG/BVXQXgkKej2+Y/lgrLdpFm/issP38ftyP6nuKHXhp/kHubQOSdkGacYlnVqhbtCwnB0JHzBNJvI7aFYP8hY+STiotz+3CaaP0OrI41uV3mMW8I8KWHaBE3PeZKVf/rTbc3PfJ70KccY24uEPXr3SHznz83eSlXAaeUpVwWOY/QO75kezG48ZCTpi3gLxslfVldEBew3EPMN1e2e+3CSN9nKNt8/9yQ+629Q3l/ZrkTFdT6m6FOXEQ7pQtiA+4MvpfqhylwCrRoBz/5LvMIO80DBQcR2gHhdXJKsKcJmKjw75jZGKiPS44R+0l95IffanGatNoLBCFWJ5mV419Id31a3aVe0HSJttZp5LAC++XZvZFzSIdI6X9oBuCxGa4VFynBoUasqO3e0uFRxotVVrEQpuotaMNUyfXn59Mv5Lf+zGFKOZOfyfa64wkN9UI7ISyl2aPTH33z9349Zj8/IhfZc5RcJqn2HSeaIeTLTFnEmvmgGz/SQ4jWLcuVqtdlRrn4AjSHRECqA12RmNEbAFatFWuchnHhGMAmrvuwMrX1PE9g9lDFkrMI361f0b93/gUQB2BC7YZhyTUVZKy7Gc1Hr5sJ5+oSdoXWJiroDssYgDyAnHM76u0wKJp85BZ8r8RZmB0Dcvd5djaXTbX160d8997Dm42Z9pULM3jWDEyo/BhnMmSdyRPpVgr8zTh2CVu/mhJaadk3X4VcdFVPLu6fFgFVIUQxGG33F7lbTkHJHLr77rN0nAy5DcMECDiTrU3k6RlULP3PjLIs7lbNGbtXCVyV9/au6ikqMgLsgMyphqvBPJcT2aVng3ZYSkgBo8aY0n6sJyKf3R5AKtHJ1TifNxembjT4Mnu9hMJwHXmS+HkgTKsGKUKO1NO
 BS4DhNXV
 Ar/GnQom0N/m+s7mGE4OLFJ6A9LScl1AP7ZAkAiX334yiBZgekQA1/AvSZke8V9aPHCMRzVX9MgJCVDcNTw4VdkKw1A92fmnRqfv7gWd1BrpObojzWQWHVhKudD4jC0jKC9ofGOwQBQlzOsf/p6FDacv2b/oIhVG5U2Ri2XQnoKiinZnD3j3WRK8Ezk3j18x3xHAIYPxwZiux/Nd1AGGSfD/GOu1Ig33gC8G9zMrifyHERN3c159vWD7J4nmLNxKU/jFPKEFMjrTWLU2QvSWThPFUh51tPlxuHOvkyIJjs0vUTduMUvt4bnkxTVtlMMytPbiS4aZryXXZzLptc5QzQryoe1tELj+l2+CfXQgtsqolkf0GKVbJ5oMufruEd1wE2zj4nLeug63SyheK4LXyWrWgV/4tggvGLxtsufku+6FYE2IWFSgQv7+FaMIfd4lf40zA8I6/rLr/3VCm0c4Tt1O0DdyUZTjEnCq3uz0ImVuFvlCTukaGefN9z9QHE3iaNEEmzMuvLMm1YRjXOH7cAghP9zMpTYnLhbrKk2fwkHmDe4qa018KCF9a6VLQzbexJwOsxT4/7Nxr9PywpQu4vVFxOA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Ackerley Tng <ackerleytng@google.com>

Implement the guest_memfd provider operations in the sample memory
provider module, providing .attach and .release callbacks.

In .attach, take a reference to the provider file (get_file) to keep the
provider context alive while attached. In .release, release the file
reference via fput.

Attach the provider operations to mps_file_fops.gmem_provider_ops so that
provider file descriptors created by the sample module can be passed as
resource_fd to guest_memfd.

Signed-off-by: Ackerley Tng <ackerleytng@google.com>
---
 samples/kvm/mem_provider_sample.c | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/samples/kvm/mem_provider_sample.c b/samples/kvm/mem_provider_sample.c
index 397ebb3773f39..d9e57484c3933 100644
--- a/samples/kvm/mem_provider_sample.c
+++ b/samples/kvm/mem_provider_sample.c
@@ -17,6 +17,7 @@
 #include <linux/file.h>
 #include <linux/fs.h>
 #include <linux/gfp.h>
+#include <linux/guest_memfd.h>
 #include <linux/io.h>
 #include <linux/miscdevice.h>
 #include <linux/mm.h>
@@ -118,11 +119,30 @@ static long mps_file_ioctl(struct file *file, unsigned int cmd,
 	}
 }
 
+static void *mps_gmem_attach(struct inode *gmem_inode,
+			     struct file *resource_file)
+{
+	return get_file(resource_file);
+}
+
+static void mps_gmem_release(void *provider)
+{
+	struct file *resource_file = provider;
+
+	fput(resource_file);
+}
+
+static const struct guest_memfd_provider_operations mps_gmem_provider_ops = {
+	.attach		= mps_gmem_attach,
+	.release	= mps_gmem_release,
+};
+
 static const struct file_operations mps_file_fops = {
 	.owner		= THIS_MODULE,
 	.release	= mps_file_release,
 	.unlocked_ioctl	= mps_file_ioctl,
 	.compat_ioctl	= compat_ptr_ioctl,
+	.gmem_provider_ops = &mps_gmem_provider_ops,
 };
 
 static long mps_ctl_new_file(void __user *uarg)

-- 
2.56.0.257.gf7497c7d27-goog




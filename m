Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4DB5F606A321
	for <linux-mm@archiver.kernel.org>; Thu, 22 Oct 2026 23:29:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ZcoPaP95
Received: by kanga.kvack.org (Postfix)
	id 806DC6B0A3F; Thu, 22 Oct 2026 19:28:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7EA5F6B0A40; Thu, 22 Oct 2026 19:28:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6580B6B0A41; Thu, 22 Oct 2026 19:28:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2E6E96B0A3F
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 19:28:17 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id A8CD6A7D24
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 23:28:16 +0000 (UTC)
X-FDA: 85351852992.04.3B22C41
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf07.hostedemail.com (Postfix) with ESMTP id 55B8B40005
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 23:28:14 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ZcoPaP95;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	arc=pass ("kernel.org:s=arc20260519:i=1");
	spf=pass (imf07.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792711694;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=G5TstA7aG98BVKhMrLt5WSrfSFHxziPmlKTD/kwxSgM=;
	b=VVGnWgiCTHYOVtDdB+yZr5cBFozt1nyYWs1I0SM2KHZdmIZtWtcQ0UWUUSPr6s0kWPbQ/l
	EbdvuLXDh+Q2vusj853TioKU3cuNIhUxOOXz85x4ZKWGV3oEM7yFwIS2xR1H+2qhkjqOuE
	Cu0TG5QmhMzto4DfmEXXa5l16TgZJiw=
ARC-Authentication-Results: i=2;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ZcoPaP95;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	arc=pass ("kernel.org:s=arc20260519:i=1");
	spf=pass (imf07.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1792711694;
	b=6Agdns0CeGtD25CmIqs/OfAW8eGPtFoRvaMWM49WUse8aNEDe1NTGofBR1yCSAZAunezzm
	9TeoBEsoPPiJ6pQxxRFDicmFidkgLZVQZVtrSVNsfo6QP3o17cyiLbT2suYPZhSTgi32pk
	hG1Dl+Ro7wu0eN4Lo8sY86im6io3eX4=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 00B27447BC;
	Thu, 22 Oct 2026 23:28:13 +0000 (UTC)
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1792711692;
	b=u6Fwnmn+U0bpvT9Gtt8VLIvJbMABRFy/V5cCY4o7Y0UCgzgj59oHkl8bCpH6dL7106/N
	 u7GimGII/msUu9pbzLxSqJQs9KhFYBZ88YdqMpt6d3QQkg8ycHQrTVXu+/DQzUlqEq7Wa
	 e8IWFFMr0RFYMpOtzg7yQM87CD2E+4IGQw1z9X8X+euc98eOBc33F4+DI+rW9V0jdAdJo
	 mh5jZyiXGl3HWlb1N3g6p2zkx00KDyZbKzvW19s7rnUo3R+MKaIHHBFmN/f/Jb1avXkIs
	 6AWi5Ug91mlBf33wctcolgAy3zbYlJITA61h7XxslUL+VdqFoJ99mUJf7pIC+WijdnQ==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1792711692;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Content-Transfer-Encoding:Message-Id:References:In-Reply-To:To:Cc:
	 X-Mailer:X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To;
	bh=G5TstA7aG98BVKhMrLt5WSrfSFHxziPmlKTD/kwxSgM=;
	b=J2mEPwPqWDEFFX/p8pYjuZBuH09cWPjVOl4UJI6qwoSz0VdT1Ho4Sftv/quZWC+Wq8NM
	 eOvWpBKQ5lY4rw7F7EcwRJdz75RHQGizdjFwFolKQUG8YpkzyvVgIEXwxHwkYZEVzx5S2
	 +XnIupDGelCJWzUOkrgZ69Qi7/0RHu25gWM/quDcHTNteQw77AGcLgmuZDYTtpQzYBUJG
	 MnPuBMiTlRHOPlZtt0WytB+AHP7an9HZb59uYMxV2an8XZMccCr2xQIZSKOyj6mftUwIH
	 ovwYogb7WXub8PfsiK+eI2vfaaAoRKLBjygicfVKv02erQCyGbzabAuX/cGsOkJ58QQ==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id 9C6D11F0118C;
	Thu, 22 Oct 2026 23:27:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792711692;
	bh=G5TstA7aG98BVKhMrLt5WSrfSFHxziPmlKTD/kwxSgM=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To;
	b=ZcoPaP95tMZgpCkwyOG+PenuIXAgVbgcZvvyhEUnR2+VpnbF6h84d2KkRBeNylYpF
	 y6yuFSNN5YwUsRvNVFCvHYktEK2WLYM2sDaF0D6w7HhyTBcsR6P6oe4x/UitlxFe4A
	 AmjVYa1379DzheQrVRmMM9O6vmELtDeQnqf3eRESzEZqwp0IivCHsMR0pwzFPORZ6R
	 iOGpxOiWkpyZ1NKiRUqIQA8UjIhrfM3PrUerm+BScfJBowCFfKprBt43tJJvSfNrJ+
	 QwAxyL6PipXcjOuTv1eywx4nSA5C4QV5XC4n0FKzJRiWIlhXeUKnNb92mVsoxenYXY
	 3PZdSfYFPh4IQ==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id 3878E42093;
	Thu, 22 Oct 2026 23:27:49 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Date: Thu, 22 Oct 2026 16:27:52 -0700
Subject: [PATCH RFC v2 20/50] samples/kvm: Add a memory provider sample
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261022-gmem-alternative-providers-v2-20-5dd1dc6c660a@google.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1792711665; l=32796;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=jTzxQ6+DvAIALU6sjyAerdStzLYmwnAwb5aNVlqrXkI=;
 b=FhhslEkINBT2XWGv/MWPUdBx5Cr6ktk02GI+AiIGFn4HE8OYFxisEWQXKKXNBxgIxX0O7w5Hy
 QHjitfKKhNCB3O/2jLhEtbmizLihfn0JSrMLT1sewUYdiNGkZ+/d2XB
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com
X-Rspamd-Queue-Id: 55B8B40005
X-Stat-Signature: eyacyrps5h5rwoxtwdeh67zqsoptoyjm
X-Rspamd-Server: rspam04
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1792711694-389301
X-HE-Meta: U2FsdGVkX19ehv/5CKX3Iqyfz4mLy/eBKYsG2HfWz+/5KUBHPAcGr1Fuwd8XsOAgOkgMco7ibS4LiytkJkFETEpzwxR+x4U2R0nqtzxpb50DqcTtB+HQmvvU/H0KrqyP0OqmZyPWnFh5FiGwojEeziVEodIrTdExGSPqs7mVAr7+LKn7/zymKqbDUoNlu4AFCb1ZpR1UQu6VpKt9RhJ45qNnlNY0LofsyN9FeLmFdB1yCrWca53OzBMEWNNM87GOFnbZHVdaP/c6IxJCLzzdm9Edda1K2WEesxFj6SHDbTa7m+nvmqOOXxyYJfyJdMb2NT6FH/baY9NpbNxmv/2b8nSyXUkHkXbcsGQxMLrpUPLUCQyy7mLcge1pXQfH2AUn7JWkb315YZdqCJSaXhM4qIJKQL7i1yZQK1DD1fgjVaRQRLgRyayjuFbLRwfMpFPoV2gua/S5ZqBD7L9X/mPa8QcPcq/Cp1dwi+HY2w/un/4TVvvE15wEUQIn5Em2VY/dqZmyycMSlXRxMlc/xWvuews/M6xLEZO3FHTce3ci51B4gAfbYJvdyAznlH5Rm9AFss4EfLKde5uEu/C/9uQSEXNi86SdZGPnMxu+5B+6Q4s3YTAE3i6X72IlCUngDn1rO9LpA1jHrf+O9tWY975xYPHHsfuwbXYHFWsD6+Ibvw2q4Q922L2Klel5OVRd51UlsRHppbvlB7EcczPmKx/8ECcuRuJQpNr41Fp3OlAj/l3u2QAmsYEwdvMaEigOjanVBHlV9GmEiEwTLBJmXw+cLlYJXn+3fxRCmn4jaTjBurDhodjkkKpjU5LRLtMqUWJT0g7X95ZxVk8OD//ncpH7tZ2idlTkixPjz3lnEwoJhhhHzlaj/ngn8/SF2mRsvHNn+9Vavj47RWcUXXW1LDLgojrKIVbcwXcV/ciCZtHRXcDTBox3eE3BXUs63xkM+43yuFVCN803K7Wc1+y4lQP
 LpZCkVx7
 gdmytfXy/7+DryD05b69nrgib7kB/wm0L7F+/bzJ4qWxarLCadYLYk1BPQq/VUdxSfJXhFze+PzuZ+JgRM4qc+xPP1k7/TE7nW8V95vLQ/Nf9loY9XDdN6rEpzkEfZbIH9yMORmf6+EvZMjwQg0f1PLWWxXnFlCsBDHDuFakfcqeq1LceUoik49o718i5xKenj7Bqtbmb60Jnd6q2g823SJmYJgFIt1MtyA9/HaInDeYwSn5KTsQtvjLcOd0OLvBwrW6PJ1vZoRx0qkTlT7DR1EjIHUEjh4WTeE8XfUC64EPyhg/QXZOf446zuFYXYcOewsVDjyO+dhuhc+cy2h6UeiyvRBQlmO3rNzLnXoctKirQY1D/6k/sg3paVaF17OUmmSE661Wx8E7KGg9sTTsvWcQMZk3F5jYjKRCWeru1TeeMKfaLzAz/YLuBmAJXVeUBzlmEeyd3pyyr1cEeMpNZ/efNMb1KA4U3UStqDm0vcYG5wr+Bmv1aTtFKsJ3kChhsXMC0S1eToEzomZwtePheTfNv/ZIMqPBfqPr61PVbmm1ALYGJlYVND07lufowcz5rfQcayC/ws9bSk50=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Fred Griffoul <fgriffo@amazon.co.uk>

The memory provider interface has no in-tree provider that a VMM can
use.

Add mem_provider_sample. It lends a region, either a fixed range given
with addr= and len= or memory from alloc_contig_pages(), as child files
that a VMM passes to both guest_memfd and iommufd. A control device
moves pages between children, takes them back and makes them read
only, and every change revokes the range. It uses no KVM, dma-buf or
iommufd symbol.

The fixed range is not System RAM, so the sample keeps a write-back
memremap() of it while a file over it may be mapped into userspace.
Without it, PAT would make the range uncached on x86, and the VMM's
mapping would be uncached while the guest's is write-back. The sample
is x86 only, as guest_memfd accepts providers only there.

Signed-off-by: Fred Griffoul <fgriffo@amazon.co.uk>
Signed-off-by: Ackerley Tng <ackerleytng@google.com>
---
 samples/Kconfig                   |  17 +
 samples/Makefile                  |   1 +
 samples/kvm/Makefile              |   2 +
 samples/kvm/mem_provider_sample.c | 855 ++++++++++++++++++++++++++++++++++++++
 samples/kvm/mem_provider_sample.h | 135 ++++++
 5 files changed, 1010 insertions(+)

diff --git a/samples/Kconfig b/samples/Kconfig
index a75e8e78330da..3c870bca076af 100644
--- a/samples/Kconfig
+++ b/samples/Kconfig
@@ -326,6 +326,23 @@ source "samples/rust/Kconfig"
 
 source "samples/damon/Kconfig"
 
+config SAMPLE_KVM_MEM_PROVIDER
+	tristate "Build sample memory provider -- loadable module only"
+	depends on MEM_PROVIDER && CONTIG_ALLOC && X86_64 && m
+	help
+	  This builds a sample memory provider (include/linux/mem_provider.h).
+	  Its files can back a guest_memfd and be mapped by iommufd.  Loaded
+	  with addr= and len=, it lends a fixed physical range that has no
+	  struct page, for example memory hidden with memmap= on the command
+	  line.  Without them, it allocates a contiguous region with
+	  alloc_contig_pages().
+
+	  It shows how a memory owner moves pages between VMs, takes them
+	  back or makes them read only, and how guest_memfd and iommufd
+	  follow each change.
+
+	  If unsure, say N.
+
 endif # SAMPLES
 
 config HAVE_SAMPLE_FTRACE_DIRECT
diff --git a/samples/Makefile b/samples/Makefile
index 07641e177bd8b..e7dfb0bb15a5b 100644
--- a/samples/Makefile
+++ b/samples/Makefile
@@ -37,6 +37,7 @@ obj-$(CONFIG_SAMPLE_TPS6594_PFSM)	+= pfsm/
 subdir-$(CONFIG_SAMPLE_WATCHDOG)	+= watchdog
 subdir-$(CONFIG_SAMPLE_WATCH_QUEUE)	+= watch_queue
 obj-$(CONFIG_SAMPLE_KMEMLEAK)		+= kmemleak/
+obj-$(CONFIG_SAMPLE_KVM_MEM_PROVIDER)	+= kvm/
 obj-$(CONFIG_SAMPLE_CORESIGHT_SYSCFG)	+= coresight/
 obj-$(CONFIG_SAMPLE_FPROBE)		+= fprobe/
 obj-$(CONFIG_SAMPLES_RUST)		+= rust/
diff --git a/samples/kvm/Makefile b/samples/kvm/Makefile
new file mode 100644
index 0000000000000..2ce44fc0aa8e3
--- /dev/null
+++ b/samples/kvm/Makefile
@@ -0,0 +1,2 @@
+# SPDX-License-Identifier: GPL-2.0
+obj-$(CONFIG_SAMPLE_KVM_MEM_PROVIDER) += mem_provider_sample.o
diff --git a/samples/kvm/mem_provider_sample.c b/samples/kvm/mem_provider_sample.c
new file mode 100644
index 0000000000000..8180959ab78ff
--- /dev/null
+++ b/samples/kvm/mem_provider_sample.c
@@ -0,0 +1,855 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * mem_provider_sample - a sample memory provider.
+ *
+ * The module owns a region of physical memory and lends it through provider
+ * files (include/linux/mem_provider.h).  A VMM passes the same file to
+ * KVM_CREATE_GUEST_MEMFD, for the guest, and to IOMMU_IOAS_MAP_FILE, for the
+ * guest's devices.  The module calls neither KVM nor iommufd: it answers
+ * "what is page N" and revokes a range when the answer changes.
+ *
+ * The region is either:
+ *
+ *  - a fixed range given with addr= and len=, which has no struct page, for
+ *    example memory hidden from the kernel with memmap= on the command line;
+ *  - or, without those parameters, a range from alloc_contig_pages().
+ *
+ * The control device /dev/mem_provider_sample creates provider files.
+ * SETUP makes one file over the whole region.  NEW_CHILD carves part of the
+ * region into a child file, and MOVE, DONATE and RECLAIM change which child
+ * has which page.  A page can also be taken away or made read only.  See
+ * mem_provider_sample.h.
+ *
+ * Confidential VMs are not supported.
+ */
+
+#include <linux/anon_inodes.h>
+#include <linux/bitmap.h>
+#include <linux/file.h>
+#include <linux/fs.h>
+#include <linux/gfp.h>
+#include <linux/io.h>
+#include <linux/mem_provider.h>
+#include <linux/miscdevice.h>
+#include <linux/mm.h>
+#include <linux/module.h>
+#include <linux/mutex.h>
+#include <linux/slab.h>
+
+#include "mem_provider_sample.h"
+
+static unsigned long long addr;
+module_param(addr, ullong, 0444);
+MODULE_PARM_DESC(addr,
+		 "Physical base of a region with no struct page (optional)");
+
+static unsigned long long len;
+module_param(len, ullong, 0444);
+MODULE_PARM_DESC(len, "Size in bytes of that region (optional)");
+
+/*
+ * One provider file.
+ *
+ * Lock order: mps_root.lock, then mps_info.lock, then the consumers' locks
+ * (taken by their revoke callbacks).  get_page() takes no lock, so a
+ * consumer can call it from its fault paths and its revoke callback.
+ */
+struct mps_info {
+	struct mem_provider_file mpf;
+	struct mutex lock;		/* the bitmaps */
+
+	unsigned long base_pfn;
+	unsigned long npages;
+	struct page *cma_pages;		/* from alloc_contig_pages(), or NULL */
+	bool fixed;			/* a SETUP file over addr=/len= */
+	bool mmap_capable;
+	bool fixed_wb;			/* holds a ref on the fixed-region WB alias */
+
+	unsigned long *absent;		/* taken away by CTL_SET_PRESENT */
+	unsigned long *readonly;
+
+	/*
+	 * A child of the root: its first page in the root, and the pages it
+	 * has.  NULL @owned for a file made by SETUP, which has all its pages.
+	 */
+	unsigned long root_index;
+	unsigned long *owned;
+	struct list_head root_link;	/* mps_root.children, mps_root.lock */
+};
+
+/*
+ * The root region, owned by the control device.  Changes of ownership run
+ * under @lock, which is taken before any child's lock.
+ */
+static struct mps_root {
+	struct mutex lock;		/* everything below */
+	unsigned long base_pfn;
+	unsigned long npages;
+	struct page *cma_pages;
+	unsigned long *owned;		/* pages that a child has */
+	unsigned long *donated;		/* pages kept at the root */
+	struct list_head children;
+	/*
+	 * The addr=/len= region is used either by one SETUP file or by the
+	 * root, never by both, so that its frames have one owner.
+	 */
+	bool fixed_setup;
+	/* Files over the fixed region that may be mapped into userspace. */
+	unsigned int fixed_wb_users;
+} mps_root;
+
+/*
+ * A write-back mapping of the addr=/len= region, held while any file over it
+ * may be mapped into userspace (counted by mps_root.fixed_wb_users).  Without
+ * it, PAT makes the range uncached on x86, and the VMM's mapping would be
+ * uncached while the guest's is write-back.  PAT may still give a weaker type
+ * if the MTRRs do not mark the range write-back.
+ */
+static void *mps_fixed_wb;
+
+/* A file over the fixed region whose pages the host may map. */
+static bool mps_over_fixed_mappable(struct mps_info *info)
+{
+	return addr && len && !info->cma_pages && info->mmap_capable;
+}
+
+/*
+ * Hold a write-back mapping of the fixed region while any file over it may be
+ * mapped into userspace.  Called under mps_root.lock.
+ */
+static int mps_fixed_wb_get(void)
+{
+	if (mps_root.fixed_wb_users == 0) {
+		mps_fixed_wb = memremap(addr, len, MEMREMAP_WB);
+		if (!mps_fixed_wb)
+			return -ENOMEM;
+	}
+	mps_root.fixed_wb_users++;
+	return 0;
+}
+
+static void mps_fixed_wb_put(void)
+{
+	if (--mps_root.fixed_wb_users == 0) {
+		memunmap(mps_fixed_wb);
+		mps_fixed_wb = NULL;
+	}
+}
+
+/* Does @info have page @index now?  Called with or without info->lock. */
+static bool mps_page_present(struct mps_info *info, unsigned long index)
+{
+	if (info->owned && !test_bit(index, info->owned))
+		return false;
+	return !test_bit(index, info->absent);
+}
+
+/*
+ * The length of the run from @index of pages with the same state as @index:
+ * present, and the same read-only bit.
+ */
+static unsigned long mps_run(struct mps_info *info, unsigned long index)
+{
+	unsigned long end = info->npages;
+
+	end = min(end, find_next_bit(info->absent, info->npages, index + 1));
+	if (info->owned)
+		end = min(end, find_next_zero_bit(info->owned, info->npages,
+						  index + 1));
+	if (test_bit(index, info->readonly))
+		end = min(end, find_next_zero_bit(info->readonly, info->npages,
+						  index + 1));
+	else
+		end = min(end, find_next_bit(info->readonly, info->npages,
+					     index + 1));
+	return end - index;
+}
+
+/* ---- Provider operations ------------------------------------------------ */
+
+static struct mem_provider_file *
+mps_mp_attach(struct file *file, loff_t size)
+{
+	struct mps_info *info = file->private_data;
+
+	if (size > (loff_t)info->npages << PAGE_SHIFT)
+		return ERR_PTR(-EINVAL);
+	return &info->mpf;
+}
+
+static void mps_mp_detach(struct mem_provider_file *mpf)
+{
+}
+
+/*
+ * Reads the bitmaps without info->lock.  A change runs under the lock and
+ * revokes the range afterwards, so an answer that a change makes out of date
+ * is dropped by the consumer.
+ */
+static int mps_mp_get_page(struct mem_provider_file *mpf, pgoff_t index,
+			   unsigned long *pfn, int *max_order, u32 *attrs)
+{
+	struct mps_info *info = container_of(mpf, struct mps_info, mpf);
+	unsigned long run;
+
+	if (index >= info->npages)
+		return -EINVAL;
+
+	if (!mps_page_present(info, index))
+		return -EFAULT;
+
+	/* The aligned block around @index must be one run. */
+	run = mps_run(info, index);
+	while (*max_order) {
+		unsigned long first = ALIGN_DOWN(index, 1UL << *max_order);
+
+		if (first + (1UL << *max_order) <= index + run &&
+		    (first == index || mps_page_present(info, first)) &&
+		    mps_run(info, first) >= 1UL << *max_order)
+			break;
+		(*max_order)--;
+	}
+
+	*pfn = info->base_pfn + index;
+	if (test_bit(index, info->readonly))
+		*attrs |= MEM_PROVIDER_ATTR_READONLY;
+	/* The creator of the file decides whether the host may map it. */
+	if (!info->mmap_capable)
+		*attrs |= MEM_PROVIDER_ATTR_NO_USER_MAP;
+	return 0;
+}
+
+static const struct mem_provider_ops mps_mp_ops = {
+	.attach		= mps_mp_attach,
+	.detach		= mps_mp_detach,
+	.get_page	= mps_mp_get_page,
+};
+
+/* Tell the consumers that pages [start, end) of @info changed. */
+static void mps_revoke(struct mps_info *info, unsigned long start,
+		       unsigned long end)
+{
+	if (end > start)
+		mem_provider_revoke(&info->mpf, (loff_t)start << PAGE_SHIFT,
+				    (loff_t)(end - start) << PAGE_SHIFT);
+}
+
+/* ---- Provider file ------------------------------------------------------ */
+
+/* Byte range [offset, offset + len) of @info as page indices. */
+static int mps_range(struct mps_info *info, u64 offset, u64 len,
+		     unsigned long *start, unsigned long *end)
+{
+	if (!len || !PAGE_ALIGNED(offset) || !PAGE_ALIGNED(len))
+		return -EINVAL;
+	*start = offset >> PAGE_SHIFT;
+	*end = *start + (len >> PAGE_SHIFT);
+	if (*end > info->npages || *end < *start)
+		return -EINVAL;
+	return 0;
+}
+
+static void mps_set_readonly(struct mps_info *info, unsigned long start,
+			     unsigned long end, bool readonly)
+{
+	mutex_lock(&info->lock);
+	if (readonly)
+		bitmap_set(info->readonly, start, end - start);
+	else
+		bitmap_clear(info->readonly, start, end - start);
+	mps_revoke(info, start, end);
+	mutex_unlock(&info->lock);
+}
+
+static void mps_set_present(struct mps_info *info, unsigned long start,
+			    unsigned long end, bool present)
+{
+	mutex_lock(&info->lock);
+	if (present)
+		bitmap_clear(info->absent, start, end - start);
+	else
+		bitmap_set(info->absent, start, end - start);
+	mps_revoke(info, start, end);
+	mutex_unlock(&info->lock);
+}
+
+static long mps_get_stats(struct mps_info *info, void __user *uarg)
+{
+	struct mps_stats st = {};
+
+	mutex_lock(&info->lock);
+	st.region_offset = (u64)info->root_index << PAGE_SHIFT;
+	st.region_len = (u64)info->npages << PAGE_SHIFT;
+	st.owned_pages = info->owned ?
+		bitmap_weight(info->owned, info->npages) : info->npages;
+	st.absent_pages = bitmap_weight(info->absent, info->npages);
+	st.readonly_pages = bitmap_weight(info->readonly, info->npages);
+	mutex_unlock(&info->lock);
+
+	return copy_to_user(uarg, &st, sizeof(st)) ? -EFAULT : 0;
+}
+
+/*
+ * A child fd is read-only to its holder: only GET_STATS.  The owner changes a
+ * child's pages through the control device (MPS_CTL_SET_PRESENT and
+ * MPS_CTL_SET_READONLY), so a VMM that holds a child cannot.
+ */
+static long mps_file_ioctl(struct file *file, unsigned int cmd,
+			   unsigned long arg)
+{
+	struct mps_info *info = file->private_data;
+	void __user *uarg = (void __user *)arg;
+
+	if (cmd == MPS_GET_STATS)
+		return mps_get_stats(info, uarg);
+	return -ENOTTY;
+}
+
+/* Every consumer has detached: each one holds a reference to the file. */
+static int mps_file_release(struct inode *inode, struct file *file)
+{
+	struct mps_info *info = file->private_data;
+	unsigned long i;
+
+	/*
+	 * A child gives the pages it has back to the root.  Pages it donated
+	 * stay at the root, and pages moved out belong to another child.
+	 */
+	if (info->owned) {
+		mutex_lock(&mps_root.lock);
+		list_del(&info->root_link);
+		for_each_set_bit(i, info->owned, info->npages)
+			__clear_bit(info->root_index + i, mps_root.owned);
+		mutex_unlock(&mps_root.lock);
+		bitmap_free(info->owned);
+	}
+	if (addr && len && !info->cma_pages) {
+		mutex_lock(&mps_root.lock);
+		if (info->fixed)
+			mps_root.fixed_setup = false;
+		if (info->fixed_wb)
+			mps_fixed_wb_put();
+		mutex_unlock(&mps_root.lock);
+	}
+
+	if (info->cma_pages)
+		free_contig_range(info->base_pfn, info->npages);
+	bitmap_free(info->absent);
+	bitmap_free(info->readonly);
+	kfree(info);
+	return 0;
+}
+
+static const struct mem_provider_fops mps_file_fops = {
+	.fops = {
+		.owner		= THIS_MODULE,
+		.fop_flags	= FOP_MEM_PROVIDER,
+		.release	= mps_file_release,
+		.unlocked_ioctl	= mps_file_ioctl,
+		.compat_ioctl	= compat_ptr_ioctl,
+	},
+	.ops = &mps_mp_ops,
+};
+
+/*
+ * Make a provider file over [base_pfn, base_pfn + npages).  The fd is
+ * reserved but not installed, so that the caller can finish setting up
+ * @info before another thread can reach it.
+ */
+static int mps_new_file(unsigned long base_pfn, unsigned long npages,
+			u32 flags, struct mps_info **infop,
+			 struct file **filep)
+{
+	struct mps_info *info;
+	struct file *file;
+	int fd, ret;
+
+	info = kzalloc_obj(*info);
+	if (!info)
+		return -ENOMEM;
+	mem_provider_file_init(&info->mpf);
+	info->base_pfn = base_pfn;
+	info->npages = npages;
+	info->mmap_capable = flags & MPS_FLAG_MMAP_CAPABLE;
+	info->absent = bitmap_zalloc(npages, GFP_KERNEL);
+	info->readonly = bitmap_zalloc(npages, GFP_KERNEL);
+	if (!info->absent || !info->readonly) {
+		ret = -ENOMEM;
+		goto err_free;
+	}
+	mutex_init(&info->lock);
+	INIT_LIST_HEAD(&info->root_link);
+
+	fd = get_unused_fd_flags(O_CLOEXEC);
+	if (fd < 0) {
+		ret = fd;
+		goto err_free;
+	}
+	file = anon_inode_getfile("[mem-provider-sample]", &mps_file_fops.fops,
+				  info, O_RDWR);
+	if (IS_ERR(file)) {
+		put_unused_fd(fd);
+		ret = PTR_ERR(file);
+		goto err_free;
+	}
+	*infop = info;
+	*filep = file;
+	return fd;
+
+err_free:
+	bitmap_free(info->absent);
+	bitmap_free(info->readonly);
+	kfree(info);
+	return ret;
+}
+
+static struct page *mps_alloc_region(unsigned long npages)
+{
+	struct page *pages;
+
+	pages = alloc_contig_pages(npages, GFP_KERNEL | __GFP_ZERO,
+				   numa_node_id(), NULL);
+	return pages;
+}
+
+static long mps_ctl_setup(void __user *uarg)
+{
+	struct mps_setup setup;
+	unsigned long base_pfn, npages;
+	struct page *pages = NULL;
+	struct mps_info *info;
+	struct file *file;
+	int fd;
+
+	if (copy_from_user(&setup, uarg, sizeof(setup)))
+		return -EFAULT;
+	if ((setup.flags & ~MPS_FLAG_MMAP_CAPABLE) || setup.pad)
+		return -EINVAL;
+
+	if (addr && len) {
+		/* The fixed region has one owner: this file or the root. */
+		mutex_lock(&mps_root.lock);
+		if (mps_root.fixed_setup || mps_root.npages) {
+			mutex_unlock(&mps_root.lock);
+			return -EBUSY;
+		}
+		fd = mps_new_file(addr >> PAGE_SHIFT, len >> PAGE_SHIFT,
+				  setup.flags, &info, &file);
+		if (fd >= 0 && mps_over_fixed_mappable(info)) {
+			if (mps_fixed_wb_get()) {
+				put_unused_fd(fd);
+				fput(file);
+				fd = -ENOMEM;
+			} else {
+				info->fixed_wb = true;
+			}
+		}
+		if (fd >= 0) {
+			info->fixed = true;
+			mps_root.fixed_setup = true;
+		}
+		mutex_unlock(&mps_root.lock);
+		if (fd >= 0)
+			fd_install(fd, file);
+		return fd;
+	}
+
+	if (!setup.size || !PAGE_ALIGNED(setup.size))
+		return -EINVAL;
+	npages = setup.size >> PAGE_SHIFT;
+	pages = mps_alloc_region(npages);
+	if (!pages)
+		return -ENOMEM;
+	base_pfn = page_to_pfn(pages);
+
+	fd = mps_new_file(base_pfn, npages, setup.flags, &info, &file);
+	if (fd < 0) {
+		free_contig_range(base_pfn, npages);
+		return fd;
+	}
+	info->cma_pages = pages;
+	fd_install(fd, file);
+	return fd;
+}
+
+/* ---- Root and children -------------------------------------------------- */
+
+/* Create the root on the first NEW_CHILD, from addr=/len= or of @size. */
+static int mps_root_ensure(u64 size)
+{
+	struct page *pages = NULL;
+	unsigned long npages;
+
+	lockdep_assert_held(&mps_root.lock);
+	if (mps_root.npages)
+		return 0;
+
+	if (addr && len) {
+		if (mps_root.fixed_setup)
+			return -EBUSY;
+		mps_root.base_pfn = addr >> PAGE_SHIFT;
+		npages = len >> PAGE_SHIFT;
+	} else {
+		if (!size || !PAGE_ALIGNED(size))
+			return -EINVAL;
+		npages = size >> PAGE_SHIFT;
+		pages = mps_alloc_region(npages);
+		if (!pages)
+			return -ENOMEM;
+		mps_root.base_pfn = page_to_pfn(pages);
+	}
+	mps_root.owned = bitmap_zalloc(npages, GFP_KERNEL);
+	mps_root.donated = bitmap_zalloc(npages, GFP_KERNEL);
+	if (!mps_root.owned || !mps_root.donated) {
+		bitmap_free(mps_root.owned);
+		bitmap_free(mps_root.donated);
+		mps_root.owned = NULL;
+		mps_root.donated = NULL;
+		if (pages)
+			free_contig_range(page_to_pfn(pages), npages);
+		return -ENOMEM;
+	}
+	mps_root.cma_pages = pages;
+	mps_root.npages = npages;
+	return 0;
+}
+
+static void mps_root_teardown(void)
+{
+	if (!mps_root.npages)
+		return;
+	WARN_ON(!list_empty(&mps_root.children));
+	if (mps_root.cma_pages)
+		free_contig_range(mps_root.base_pfn, mps_root.npages);
+	bitmap_free(mps_root.owned);
+	bitmap_free(mps_root.donated);
+}
+
+/* A page-aligned byte range of the root as page indices [first, last). */
+static int mps_root_range(u64 offset, u64 length, unsigned long *first,
+			  unsigned long *last)
+{
+	if (!length || !PAGE_ALIGNED(offset) || !PAGE_ALIGNED(length))
+		return -EINVAL;
+	*first = offset >> PAGE_SHIFT;
+	*last = *first + (length >> PAGE_SHIFT);
+	if (*last <= *first || *last > mps_root.npages)
+		return -EINVAL;
+	return 0;
+}
+
+/* Return a referenced child file made by NEW_CHILD. */
+static struct file *mps_get_child(int fd, struct mps_info **infop)
+{
+	struct file *file = fget(fd);
+
+	if (!file)
+		return ERR_PTR(-EBADF);
+	if (file->f_op != &mps_file_fops.fops ||
+	    !((struct mps_info *)file->private_data)->owned) {
+		fput(file);
+		return ERR_PTR(-EINVAL);
+	}
+	*infop = file->private_data;
+	return file;
+}
+
+static long mps_ctl_new_child(void __user *uarg)
+{
+	struct mps_new_child nc;
+	unsigned long first, last, i, grant = 0;
+	struct mps_info *info;
+	unsigned long *owned;
+	struct file *file;
+	int fd, ret;
+
+	if (copy_from_user(&nc, uarg, sizeof(nc)))
+		return -EFAULT;
+	if ((nc.flags & ~MPS_FLAG_MMAP_CAPABLE) || nc.pad)
+		return -EINVAL;
+
+	mutex_lock(&mps_root.lock);
+	ret = mps_root_ensure(nc.offset + nc.len);
+	if (ret)
+		goto out_unlock;
+	ret = mps_root_range(nc.offset, nc.len, &first, &last);
+	if (ret)
+		goto out_unlock;
+
+	/* A child that would get no page is likely a mistake. */
+	for (i = first; i < last; i++)
+		if (!test_bit(i, mps_root.owned) &&
+		    !test_bit(i, mps_root.donated))
+			grant++;
+	if (!grant) {
+		ret = -EBUSY;
+		goto out_unlock;
+	}
+
+	owned = bitmap_zalloc(last - first, GFP_KERNEL);
+	if (!owned) {
+		ret = -ENOMEM;
+		goto out_unlock;
+	}
+	fd = mps_new_file(mps_root.base_pfn + first, last - first, nc.flags,
+			  &info, &file);
+	if (fd < 0) {
+		bitmap_free(owned);
+		ret = fd;
+		goto out_unlock;
+	}
+	if (mps_over_fixed_mappable(info)) {
+		if (mps_fixed_wb_get()) {
+			put_unused_fd(fd);
+			fput(file);
+			bitmap_free(owned);
+			ret = -ENOMEM;
+			goto out_unlock;
+		}
+		info->fixed_wb = true;
+	}
+
+	/* No other thread can reach the child until fd_install(). */
+	for (i = first; i < last; i++) {
+		if (test_bit(i, mps_root.owned) ||
+		    test_bit(i, mps_root.donated))
+			continue;
+		__set_bit(i - first, owned);
+		__set_bit(i, mps_root.owned);
+	}
+	info->owned = owned;
+	info->root_index = first;
+	list_add(&info->root_link, &mps_root.children);
+	mutex_unlock(&mps_root.lock);
+	fd_install(fd, file);
+	return fd;
+
+out_unlock:
+	mutex_unlock(&mps_root.lock);
+	return ret;
+}
+
+/* Take [first, last) of the root from @info.  Called under mps_root.lock. */
+static void mps_child_lose(struct mps_info *info, unsigned long first,
+			   unsigned long last)
+{
+	unsigned long s = first - info->root_index;
+	unsigned long e = last - info->root_index;
+
+	mutex_lock(&info->lock);
+	bitmap_clear(info->owned, s, e - s);
+	mps_revoke(info, s, e);
+	mutex_unlock(&info->lock);
+	bitmap_clear(mps_root.owned, first, last - first);
+}
+
+/* Give [first, last) of the root to @info.  Called under mps_root.lock. */
+static void mps_child_gain(struct mps_info *info, unsigned long first,
+			   unsigned long last)
+{
+	unsigned long s = first - info->root_index;
+	unsigned long e = last - info->root_index;
+
+	mutex_lock(&info->lock);
+	bitmap_set(info->owned, s, e - s);
+	mps_revoke(info, s, e);
+	mutex_unlock(&info->lock);
+	bitmap_set(mps_root.owned, first, last - first);
+}
+
+static bool mps_child_covers(struct mps_info *info, unsigned long first,
+			     unsigned long last)
+{
+	return first >= info->root_index &&
+	       last <= info->root_index + info->npages;
+}
+
+static bool mps_child_owns(struct mps_info *info, unsigned long first,
+			   unsigned long last)
+{
+	unsigned long s = first - info->root_index;
+	unsigned long e = last - info->root_index;
+
+	return mps_child_covers(info, first, last) &&
+	       find_next_zero_bit(info->owned, e, s) >= e;
+}
+
+static long mps_ctl_move(void __user *uarg)
+{
+	struct mps_move mv;
+	struct mps_info *src, *dst;
+	unsigned long first, last;
+	struct file *sf, *df;
+	long ret;
+
+	if (copy_from_user(&mv, uarg, sizeof(mv)))
+		return -EFAULT;
+	sf = mps_get_child(mv.src_fd, &src);
+	if (IS_ERR(sf))
+		return PTR_ERR(sf);
+	df = mps_get_child(mv.dst_fd, &dst);
+	if (IS_ERR(df)) {
+		fput(sf);
+		return PTR_ERR(df);
+	}
+
+	mutex_lock(&mps_root.lock);
+	ret = mps_root_range(mv.offset, mv.len, &first, &last);
+	if (ret)
+		goto out;
+	if (src == dst || !mps_child_owns(src, first, last) ||
+	    !mps_child_covers(dst, first, last)) {
+		ret = -EINVAL;
+		goto out;
+	}
+	/* Revoke from the source before the destination gets the pages. */
+	mps_child_lose(src, first, last);
+	mps_child_gain(dst, first, last);
+out:
+	mutex_unlock(&mps_root.lock);
+	fput(df);
+	fput(sf);
+	return ret;
+}
+
+static long mps_ctl_donate(void __user *uarg, bool reclaim)
+{
+	struct mps_donate d;
+	unsigned long first, last;
+	struct mps_info *info;
+	struct file *file;
+	long ret;
+
+	if (copy_from_user(&d, uarg, sizeof(d)))
+		return -EFAULT;
+	if (d.pad)
+		return -EINVAL;
+	file = mps_get_child(d.fd, &info);
+	if (IS_ERR(file))
+		return PTR_ERR(file);
+
+	mutex_lock(&mps_root.lock);
+	ret = mps_root_range(d.offset, d.len, &first, &last);
+	if (ret)
+		goto out;
+	if (!reclaim) {
+		if (!mps_child_owns(info, first, last)) {
+			ret = -EINVAL;
+			goto out;
+		}
+		mps_child_lose(info, first, last);
+		bitmap_set(mps_root.donated, first, last - first);
+	} else {
+		if (!mps_child_covers(info, first, last) ||
+		    find_next_zero_bit(mps_root.donated, last, first) < last) {
+			ret = -EINVAL;
+			goto out;
+		}
+		bitmap_clear(mps_root.donated, first, last - first);
+		mps_child_gain(info, first, last);
+	}
+out:
+	mutex_unlock(&mps_root.lock);
+	fput(file);
+	return ret;
+}
+
+/*
+ * CTL_SET_READONLY and CTL_SET_PRESENT change a child's pages, by the owner on
+ * the control device.  A VMM that holds the child fd cannot, so it cannot undo
+ * them.
+ */
+static long mps_ctl_set_range(void __user *uarg, bool readonly)
+{
+	struct mps_ctl_range cr;
+	unsigned long start, end;
+	struct mps_info *info;
+	struct file *file;
+	int ret;
+
+	if (copy_from_user(&cr, uarg, sizeof(cr)))
+		return -EFAULT;
+	if (cr.value > 1)
+		return -EINVAL;
+	file = mps_get_child(cr.fd, &info);
+	if (IS_ERR(file))
+		return PTR_ERR(file);
+	ret = mps_range(info, cr.offset, cr.len, &start, &end);
+	if (!ret) {
+		if (readonly)
+			mps_set_readonly(info, start, end, cr.value);
+		else
+			mps_set_present(info, start, end, cr.value);
+	}
+	fput(file);
+	return ret;
+}
+
+static long mps_ctl_ioctl(struct file *file, unsigned int cmd,
+			  unsigned long arg)
+{
+	void __user *uarg = (void __user *)arg;
+
+	switch (cmd) {
+	case MPS_SETUP:
+		return mps_ctl_setup(uarg);
+	case MPS_NEW_CHILD:
+		return mps_ctl_new_child(uarg);
+	case MPS_MOVE:
+		return mps_ctl_move(uarg);
+	case MPS_DONATE:
+		return mps_ctl_donate(uarg, false);
+	case MPS_RECLAIM:
+		return mps_ctl_donate(uarg, true);
+	case MPS_CTL_SET_READONLY:
+		return mps_ctl_set_range(uarg, true);
+	case MPS_CTL_SET_PRESENT:
+		return mps_ctl_set_range(uarg, false);
+	default:
+		return -ENOTTY;
+	}
+}
+
+static const struct file_operations mps_ctl_fops = {
+	.owner		= THIS_MODULE,
+	.unlocked_ioctl	= mps_ctl_ioctl,
+	.compat_ioctl	= compat_ptr_ioctl,
+};
+
+static struct miscdevice mps_dev = {
+	.minor	= MISC_DYNAMIC_MINOR,
+	.name	= "mem_provider_sample",
+	.fops	= &mps_ctl_fops,
+};
+
+static int __init mps_init(void)
+{
+	int ret;
+
+	if ((addr || len) &&
+	    (!addr || !len || !PAGE_ALIGNED(addr) || !PAGE_ALIGNED(len))) {
+		pr_err("mem_provider_sample: addr= and len= must both be set and page aligned\n");
+		return -EINVAL;
+	}
+
+	mutex_init(&mps_root.lock);
+	INIT_LIST_HEAD(&mps_root.children);
+
+	ret = misc_register(&mps_dev);
+	if (ret)
+		return ret;
+	return 0;
+}
+module_init(mps_init);
+
+static void __exit mps_exit(void)
+{
+	misc_deregister(&mps_dev);
+	mps_root_teardown();
+	if (mps_fixed_wb)
+		memunmap(mps_fixed_wb);
+}
+module_exit(mps_exit);
+
+MODULE_LICENSE("GPL");
+MODULE_DESCRIPTION("Sample memory provider for guest_memfd and iommufd");
diff --git a/samples/kvm/mem_provider_sample.h b/samples/kvm/mem_provider_sample.h
new file mode 100644
index 0000000000000..0e036d1c76a45
--- /dev/null
+++ b/samples/kvm/mem_provider_sample.h
@@ -0,0 +1,135 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef _SAMPLES_KVM_MEM_PROVIDER_SAMPLE_H
+#define _SAMPLES_KVM_MEM_PROVIDER_SAMPLE_H
+
+#include <linux/ioctl.h>
+#include <linux/types.h>
+
+/*
+ * A sample memory provider (include/linux/mem_provider.h).
+ *
+ * Every fd that this module returns is a provider file.  Pass it as
+ * resource_fd to KVM_CREATE_GUEST_MEMFD with GUEST_MEMFD_FLAG_USE_RESOURCE,
+ * and as fd to IOMMU_IOAS_MAP_FILE.  Both consumers follow every change that
+ * the ioctls below make.
+ */
+
+/* Flags for struct mps_setup and struct mps_new_child */
+/* The host may map the pages; otherwise they are NO_USER_MAP */
+#define MPS_FLAG_MMAP_CAPABLE	(1u << 0)
+
+/*
+ * ioctl on /dev/mem_provider_sample: create a provider fd.
+ *
+ * If the module was loaded with addr= and len=, the fd covers that fixed
+ * range, which has no struct page, and @size is ignored.  The fixed range
+ * then has one owner.  SETUP fails with -EBUSY while a SETUP file uses it,
+ * or once the first MPS_NEW_CHILD has made it the root of the children, which
+ * lasts until the module is unloaded.  MPS_NEW_CHILD fails with -EBUSY while
+ * a SETUP file uses it.  Otherwise the fd covers @size bytes from
+ * alloc_contig_pages().
+ */
+struct mps_setup {
+	__u32 flags;	/* MPS_FLAG_* */
+	__u32 pad;
+	__u64 size;	/* bytes, page aligned */
+};
+
+#define MPS_IOCTL_BASE		'P'
+#define MPS_SETUP \
+	_IOW(MPS_IOCTL_BASE, 1, struct mps_setup)
+
+/*
+ * ---- A tree of owners --------------------------------------------------
+ *
+ * The control device owns one region, the root.  NEW_CHILD carves part of
+ * it into a new provider fd for one VM.  The owner can MOVE pages between
+ * children, DONATE pages to the root, so that no child has them, and
+ * RECLAIM them.  Each change revokes the range, so KVM and iommufd follow.
+ *
+ * The owner changes a child's pages through the control device
+ * (CTL_SET_READONLY, CTL_SET_PRESENT).  A child fd is read-only to its
+ * holder: a VMM can only GET_STATS, never change the memory.
+ */
+
+/*
+ * ioctl on /dev/mem_provider_sample: carve [@offset, @offset + @len) of the
+ * root into a new child fd.  The child gets every page of the range that no
+ * other child has and that is not donated.  Ranges of children may overlap,
+ * which is how a page can MOVE between them.  Returns the child fd.
+ */
+struct mps_new_child {
+	__u32 flags;	/* MPS_FLAG_* */
+	__u32 pad;
+	__u64 offset;	/* bytes into the root, page aligned */
+	__u64 len;	/* bytes, page aligned */
+};
+
+#define MPS_NEW_CHILD \
+	_IOW(MPS_IOCTL_BASE, 5, struct mps_new_child)
+
+/*
+ * ioctl on /dev/mem_provider_sample: move [@offset, @offset + @len) of the root
+ * from child @src_fd to child @dst_fd.  @src_fd must have every page of the
+ * range, and the range must be inside @dst_fd's.  The pages are revoked from
+ * the source before the destination gets them, so the consumers of the two
+ * children never map them at the same time.
+ */
+struct mps_move {
+	__s32 src_fd;
+	__s32 dst_fd;
+	__u64 offset;	/* bytes into the root, page aligned */
+	__u64 len;	/* bytes, page aligned */
+};
+
+#define MPS_MOVE \
+	_IOW(MPS_IOCTL_BASE, 6, struct mps_move)
+
+/*
+ * ioctls on /dev/mem_provider_sample: DONATE takes [@offset, @offset + @len) of
+ * the root from child @fd, which must have all of it, and keeps it at the
+ * root.  RECLAIM gives a donated range to child @fd, whose range must
+ * contain it.  The sample does not scrub the pages.
+ */
+struct mps_donate {
+	__s32 fd;
+	__u32 pad;
+	__u64 offset;	/* bytes into the root, page aligned */
+	__u64 len;	/* bytes, page aligned */
+};
+
+#define MPS_DONATE \
+	_IOW(MPS_IOCTL_BASE, 7, struct mps_donate)
+#define MPS_RECLAIM \
+	_IOW(MPS_IOCTL_BASE, 8, struct mps_donate)
+
+/* ioctl on a child fd: read the child's state, for tests. */
+struct mps_stats {
+	__u64 region_offset;	/* the child's range in the root */
+	__u64 region_len;
+	__u64 owned_pages;	/* pages the child has */
+	__u64 absent_pages;	/* pages taken away by CTL_SET_PRESENT */
+	__u64 readonly_pages;
+};
+
+#define MPS_GET_STATS \
+	_IOR(MPS_IOCTL_BASE, 10, struct mps_stats)
+
+/*
+ * ioctls on /dev/mem_provider_sample: CTL_SET_READONLY or CTL_SET_PRESENT on
+ * child @fd, by the owner.  @value is the readonly or present value, and
+ * @offset and @len are a byte range within the child, page aligned.
+ */
+struct mps_ctl_range {
+	__s32 fd;
+	__u32 value;
+	__u64 offset;	/* bytes into the child, page aligned */
+	__u64 len;	/* bytes, page aligned */
+};
+
+#define MPS_CTL_SET_READONLY \
+	_IOW(MPS_IOCTL_BASE, 11, struct mps_ctl_range)
+#define MPS_CTL_SET_PRESENT \
+	_IOW(MPS_IOCTL_BASE, 12, struct mps_ctl_range)
+
+#endif /* _SAMPLES_KVM_MEM_PROVIDER_SAMPLE_H */

-- 
2.56.0.257.gf7497c7d27-goog




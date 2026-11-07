Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6FC4C606BFC8
	for <linux-mm@archiver.kernel.org>; Sat,  7 Nov 2026 00:39:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=cpHWLxJK
Received: by kanga.kvack.org (Postfix)
	id C1CEC6B05D7; Fri,  6 Nov 2026 19:37:13 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BA30D6B05DE; Fri,  6 Nov 2026 19:37:13 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9A9296B05D8; Fri,  6 Nov 2026 19:37:13 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 649D56B05D8
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 19:37:13 -0500 (EST)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 0760E8026A
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 00:37:13 +0000 (UTC)
X-FDA: 85406458746.07.FE45763
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf09.hostedemail.com (Postfix) with ESMTP id EA01514000D
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 00:37:10 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=cpHWLxJK;
	spf=pass (imf09.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	arc=pass ("kernel.org:s=arc20260519:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1794011831;
	b=XyvDIx9vP2v0ha7fZFmywBgkyPUic18CQG0lCd7g3Z7gOwS9Vcn5P7zuhQsJzadhcETokQ
	rWHb9+oqcIB1wK+ZEwcUuCdHKb3kSYkZiDOkLyG54lvYmnm5GY5ptqpea1yX1pzU43xAE8
	9WAwRCUpJ+5vhNJfkwQuV++X+JxKMVg=
ARC-Authentication-Results: i=2;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=cpHWLxJK;
	spf=pass (imf09.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	arc=pass ("kernel.org:s=arc20260519:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794011831;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1pCSunxlZGtDuCXdYB75wFXTfLNCc/lfSGqnGUAN2tc=;
	b=x4exIMgWnOSnJ16uBIEOlNDNMOdkuebS02+mgH6rp/fxUdXynxrMABw3JiNx+YLbU/OHVa
	ubpCccyOmgN0iiUW9joAJ3AKTgQLiN4J3GnA3ZAi6ypj7/FfCBw7TwSPVc6lOXoCi0mhJn
	eMfEy8uR8GdNNrR3t3qb9Gu1ucNSmqM=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 8E4BE60E0F;
	Sat,  7 Nov 2026 00:37:10 +0000 (UTC)
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1794011830;
	b=ZkBb4o1iDukY5E+BLQHTMaXApti41QAnALP36KbWvjpybrv2F0C8GmhS5XPWhJbsZqDw
	 JG419A4C2Jwl6Fn8C72BAcOzHyOZxL+k07rvae/sS79kc79T3O5FAf1yVe7CkII0r2Nhx
	 vaNuMs1n7SB7X5jNT77ErApOPzRUVNv9gyUfylJXUcnO5Fth5cr0xpW1i+F7nymzLLOQn
	 tq4BPqwhZNs8yKuK+LNyYGKVKH26dglKHY5F9BhCkfIAH7NzeQzmUfX+6GBXIStlyk/+k
	 OQO+o/36JHzV3KDBDNgIE3TAi6itva/YTRBYVISlrS/9m4ILgMNy/BBcPp29sxOqAvQ==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1794011830;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Content-Transfer-Encoding:Message-Id:References:In-Reply-To:To:Cc:
	 X-Mailer:X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To;
	bh=1pCSunxlZGtDuCXdYB75wFXTfLNCc/lfSGqnGUAN2tc=;
	b=O6uZcIEiTTqBcu3V56RgohfosHZBNWytQs/76vOiSga+Pmqm6CzBqnrUqGBssA9RT9/y
	 uIlFjuHDJziHxkiuNjBF4OI0RQ/cAzEAI165Nq6qzT+fEBjsVOethtNxXEiHUtFFOswGH
	 +Qxktc1A5V41tTiIV8dSkMHJX+QjWpMv7E4UTZOXb3FOsf8ALxJ2OZdz3A53ZR2atbMTI
	 rSY5EuK8YOgGLP0xw0dLPqNfBt9cxALhs8zR3mgY0qFmTWByuO1dKubE1tx+MH9MCCkUN
	 lNoDfBHHoLcnFC6i8IJ1JDbvLSxjMmpvUK7AicllpnaalxGGCeZLFL/SiKVq1CyJrRg==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id 4F3E31F00921;
	Sat,  7 Nov 2026 00:36:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794011830;
	bh=1pCSunxlZGtDuCXdYB75wFXTfLNCc/lfSGqnGUAN2tc=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To;
	b=cpHWLxJKy3/cLvXieHb1nlxWpIcSIVE/RG/jpbZfdbKA4m6D8tG5NnR7LegC64l5k
	 M7m2yZiHxEptu6las5yte/dyHT2buTNqQq8E99sj6BvOLhNr8RvlyA3dRm5STLaIxG
	 xq0ayOTVP4CSeokCFeOAvOKNrrK/Do9BRDpkWbQJTR8iFHyaHfIw8i1uCipQjS/2GN
	 jY47jPMVn06obn3D3ad4RQ0uHCYpWKz4ol2gKzwq69f5Cj+e0twjEwH+fbuHQuGNI6
	 xO08LDIXC8TdBQvEc5MKXc7yDdnLqd6NDz4RydL46VTHirnNTLXhb0YSeHp/w5IFQP
	 B57q4j8XVad+w==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id 55EDF47963;
	Sat,  7 Nov 2026 00:36:54 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Date: Fri, 06 Nov 2026 16:36:54 -0800
Subject: [PATCH RFC v3 20/88] samples/kvm: Introduce memory provider module
 skeleton
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261106-gmem-alternative-providers-v3-20-8484dde66a7e@google.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1794011809; l=3200;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=nt2cs3RpI5IUFgJs4dsgiWZl0HfyGKiOhLkBsycGpfo=;
 b=4cdyeAJ7HccYK8NGv9Q29bFTAR/IcMhIOFe8+7RU78D738bkU/WshB9UbwT/KAILWqam4ykOd
 CO6Tw3GiatGC9mriP8x0CMuJxG1AZn5inkS4uDdxzwnFtZL/sbetXox
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com
X-Stat-Signature: mk9kh9xs61upq8m5f7jro9kmkfputbye
X-Rspamd-Queue-Id: EA01514000D
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794011830-470061
X-HE-Meta: U2FsdGVkX18YfAK4eofHD78wujXl3qaTx/B0U3F0t0Bcxl0+cI3uGiQeKxkkR5eb7UMlXF8MHw2OWAIro1HCDbUrNRx3ZEQjkVA7J0c6FLGjKuomEKt5wnqQYAri9GbKfqWhWCbi8n7Geex0wffkZ+iGmC4T2E/wiElJqtYuZX6l1LkpRQHIVL6+4lENmoGUK5Hm5lPh8L1LaLw14dkpUPnYu4kJjIk5n1L69HUYbAGmptrBdQlSqFXQasBBfDtAtUoYGC4hEu3QkFjsGYyOp9L0Mh9/3XBybqc63XJqTSmttdz/azxZw3P7RHHuOSuOmxsxaWL+g+RBBzHqRvJb9osRKi3QCDgccAmQWbPCy1K54jcmjFzyxbkOKZ3zujtUkv+C4drHzaQMWbQiJTOfTbiRcDe5jLMiaOXGgLAN+ikfF+i+hv+V+soxyzfSGW6fVXwS+fLG43j/CrA8sX48ye7caLVSognaKmUhR1o2LPBGjTXmTRhgT1MGMjz8eBL20fidyvJvKZsY98fhj/EUd4tgV6f8Qx5jLTei3LUf7LSbViiwkCh/wQIaVLapXajaIFn6eDuNNBDfHfgYhTHwafTT7gDe98mA2CuTeXIyp5rwdasHrG7JrpUCdu98tlBiW/fPiP1tSDnfhV6xn6Lqri27UVhDHPJyVFRCvuyoTBJXpnm2MkiqfMUnD01SI0wxEeMkMCz5HWFf4b9kmS3UsHmz5GmCeuDzIMgTKB3GzuY/PvdjG6rbDp+P+cm9xsMEKhvBCt9zS/F9KMnJoh9h/dkGH1jB0sDp48Rk3E2CJUg5i3matxfjtzOwyUovl2/kCov3djPgg5jqBWXLcIjQTsRoef0HqfKHHOnOV6XODq+r1jUQo2bA2qU+80yIAYaF2a2lEf9YLxQ7KoH3NNaIOHcUZGrWeHO/s9lrc95q9/Re+DZpFrNW7ZCgRBiI4I78Ri4o3z46v+vXo/MfHdR
 GC1rCdVJ
 vlQ99YSVrYbDvmu6nXYOHnoWbn4VjeDldf0CfmdJcEtR2LICzJKF92KNTGDjUfPAr0Fiq2/nzOq8kwFWfgEQUH/oJXbdPbZv3xkCctK+t7mgCU4uEuaTQYNH3Cd/a7Yhk4/P+aj3Tp793vnvSkOLDjn4+W3YPpMM9Y3p5TvVF72dHoesuJHj14vVln+NK+j20PybJGojySp9ptEhJ/5SSb0eA1AGiS38lZStMTehe/tw+pXa9ITxtQKv+EaY5f+YsDe/ZFz3DUojtufT5adj1c9cb69Rn0LY2Yc+DjmE2zIaO97zu0aeNL3eHEa546R6xxQaKOEe7uJfg8rNm1cZGDuJWty6XrKGfwJFRA4vDNpm8iadyLWTRTAo8R0cVb+PsaouAmfPB2f7p5EGvGk8sDzGbrLj/TKfytp99lK2rPDOayGQdo/YAOegcX0sppyttL9jtPqFx5yvQHOWdTMMB7Ha90eYYKS12roaiDRUQhuZUNC0CrVBKWX6nuo0hvAcrPi+SQCBzrmW+WIix++qcTiSXuytkgTbiDTi5ZmWcZHr2+VYyXUe75T3646rJ0/OgRaYfy6212++W2Xk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Fred Griffoul <fgriffo@amazon.co.uk>

Introduce the memory provider sample module skeleton under samples/kvm/.

The memory provider module will serve as a sample in-tree memory provider
for guest_memfd and iommufd. Register a miscdevice at /dev/memory_provider
upon module initialization and deregister it upon module exit.

Co-developed-by: Ackerley Tng <ackerleytng@google.com>
Signed-off-by: Ackerley Tng <ackerleytng@google.com>
Signed-off-by: Fred Griffoul <fgriffo@amazon.co.uk>
---
 samples/Kconfig               | 11 +++++++++++
 samples/Makefile              |  1 +
 samples/kvm/Makefile          |  2 ++
 samples/kvm/memory_provider.c | 35 +++++++++++++++++++++++++++++++++++
 4 files changed, 49 insertions(+)

diff --git a/samples/Kconfig b/samples/Kconfig
index a75e8e78330da..d4e79e1a9286b 100644
--- a/samples/Kconfig
+++ b/samples/Kconfig
@@ -326,6 +326,17 @@ source "samples/rust/Kconfig"
 
 source "samples/damon/Kconfig"
 
+config SAMPLE_KVM_MEMORY_PROVIDER
+	tristate "Build sample memory provider -- loadable module only"
+	depends on CONTIG_ALLOC && X86_64 && m
+	help
+	  This builds a sample memory provider.
+	  Its files can back a guest_memfd and be mapped by iommufd.
+	  It allocates a contiguous region with alloc_contig_pages()
+	  and carves out child provider files on the fly.
+
+	  If unsure, say N.
+
 endif # SAMPLES
 
 config HAVE_SAMPLE_FTRACE_DIRECT
diff --git a/samples/Makefile b/samples/Makefile
index 07641e177bd8b..3933ef6a323ed 100644
--- a/samples/Makefile
+++ b/samples/Makefile
@@ -37,6 +37,7 @@ obj-$(CONFIG_SAMPLE_TPS6594_PFSM)	+= pfsm/
 subdir-$(CONFIG_SAMPLE_WATCHDOG)	+= watchdog
 subdir-$(CONFIG_SAMPLE_WATCH_QUEUE)	+= watch_queue
 obj-$(CONFIG_SAMPLE_KMEMLEAK)		+= kmemleak/
+obj-$(CONFIG_SAMPLE_KVM_MEMORY_PROVIDER)	+= kvm/
 obj-$(CONFIG_SAMPLE_CORESIGHT_SYSCFG)	+= coresight/
 obj-$(CONFIG_SAMPLE_FPROBE)		+= fprobe/
 obj-$(CONFIG_SAMPLES_RUST)		+= rust/
diff --git a/samples/kvm/Makefile b/samples/kvm/Makefile
new file mode 100644
index 0000000000000..9668dc57aa458
--- /dev/null
+++ b/samples/kvm/Makefile
@@ -0,0 +1,2 @@
+# SPDX-License-Identifier: GPL-2.0
+obj-$(CONFIG_SAMPLE_KVM_MEMORY_PROVIDER) += memory_provider.o
diff --git a/samples/kvm/memory_provider.c b/samples/kvm/memory_provider.c
new file mode 100644
index 0000000000000..d5272cb88b758
--- /dev/null
+++ b/samples/kvm/memory_provider.c
@@ -0,0 +1,35 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * memory_provider - a sample memory provider.
+ *
+ * Confidential VMs are not supported.
+ */
+
+#include <linux/fs.h>
+#include <linux/miscdevice.h>
+#include <linux/module.h>
+
+static const struct file_operations mp_ctl_fops = {
+	.owner		= THIS_MODULE,
+};
+
+static struct miscdevice mp_dev = {
+	.minor	= MISC_DYNAMIC_MINOR,
+	.name	= "memory_provider",
+	.fops	= &mp_ctl_fops,
+};
+
+static int __init mp_init(void)
+{
+	return misc_register(&mp_dev);
+}
+module_init(mp_init);
+
+static void __exit mp_exit(void)
+{
+	misc_deregister(&mp_dev);
+}
+module_exit(mp_exit);
+
+MODULE_LICENSE("GPL");
+MODULE_DESCRIPTION("Sample memory provider for guest_memfd and iommufd");

-- 
2.56.0.455.g6c5a503b38-goog




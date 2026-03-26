Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1563410AB833
	for <linux-mm@archiver.kernel.org>; Thu, 26 Mar 2026 23:37:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7A1E26B0005; Thu, 26 Mar 2026 19:37:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 778DC6B0089; Thu, 26 Mar 2026 19:37:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5F3686B0092; Thu, 26 Mar 2026 19:37:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 48B8B6B0005
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 19:37:06 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id D16098D2CE
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 23:37:05 +0000 (UTC)
X-FDA: 84589827210.28.135FFEA
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	by imf16.hostedemail.com (Postfix) with ESMTP id 0FCF3180006
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 23:37:03 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=TpCKsRDZ;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf16.hostedemail.com: domain of 3HsPFaQsKCBErt1v82vFA4xx55x2v.t532z4BE-331Crt1.58x@flex--ackerleytng.bounces.google.com designates 209.85.210.202 as permitted sender) smtp.mailfrom=3HsPFaQsKCBErt1v82vFA4xx55x2v.t532z4BE-331Crt1.58x@flex--ackerleytng.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774568224;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=anFkcCozf8v6Cel8diSJv50ROa2IxgRDEcI6Q1pEpvA=;
	b=uKI85Ab4Ma0XuLCxXQuedY3CCvjhMK7xK3n60+sG70OIZ0Dn0/bneckrvAugBTRx43RAnH
	J1bjvn5LlPjEFShJuu+Pc6HtOpe9fODjvwF0FfsTHn/bOLjCs0v5yCilfxCqfRb6ZAbqfI
	YIoY/bWrbIg6ZeM7VIQBKn3qRcTBYao=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774568224; a=rsa-sha256;
	cv=none;
	b=Ho2bHx3sA0XaXLYjuQejySGq08MDF9qAgOPiCNdajS+9KFFg/DAi/lm4EwWS5JRdwTrZE4
	sSPWAqybzTY7sAK8OVp050DOVAFkx1C7LZ/+tWJh693ISY81sLXPzaH77AE0RY8fbIz0d1
	7dC4pi8ndEqWO5RsuW6cpXkPD1vxmQI=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=TpCKsRDZ;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf16.hostedemail.com: domain of 3HsPFaQsKCBErt1v82vFA4xx55x2v.t532z4BE-331Crt1.58x@flex--ackerleytng.bounces.google.com designates 209.85.210.202 as permitted sender) smtp.mailfrom=3HsPFaQsKCBErt1v82vFA4xx55x2v.t532z4BE-331Crt1.58x@flex--ackerleytng.bounces.google.com
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-82c7a84a43eso3207505b3a.0
        for <linux-mm@kvack.org>; Thu, 26 Mar 2026 16:37:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1774568223; x=1775173023; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=anFkcCozf8v6Cel8diSJv50ROa2IxgRDEcI6Q1pEpvA=;
        b=TpCKsRDZSVij/OdPkkLGwbcr3LS3KhyNYwqCtVcju7mUHvWgcaGOpG+kSgPAVEKzzp
         sawA9TO3xzY2ZOfmgvwFSKfeE3GlhTXWKMga6upsurGz6Kt39zhx0ny1fgaosUKUv7wl
         eFcAmAWc7TOCJHxGce1h2SzG1tXFtaYfokPiET2ETejQsYJ6he6+b9jpOutogCpR8g9P
         /yw7oAWZszQRAHBJHheKA1ZfXpDYYC+OgWkSBf6xqJ/V/D5BTG0X8ZCtA7/wGabNBOgU
         ifKB1AbjGQ2/Nyw+ZVKKlMgky75kiHC4PNW2MVnpuuydF9hQpPBRzqodJ3VHaSE3oF3g
         c0NA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774568223; x=1775173023;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=anFkcCozf8v6Cel8diSJv50ROa2IxgRDEcI6Q1pEpvA=;
        b=YBJzD6hMmFxxggsuxM2VGXs/UeTBHxoxpBss1tyqoYvRRlbYTQAeex4wzTxEckepj0
         oK2biANImMMhVN4VOCdMYVAsSqNThnMGX6ByGFJpaO9dAepe/yinUg4Uskg7wBwtcW08
         qAmgv3GKAVFWXEdHUMiNU4xokO/uV9j1cza84CvPRL+k/7ZPfflJPX18vxlICtdw4SaM
         aH/bES+yKWNOo1u95/UrwCKNEy6B8gxoR1Ry3afGLkKOv6Sz1ardsy/rsjn1GDRd7r8v
         YPAoOWXs+kvUvYcz7CWlJtSLLuYjPphn37SSMbPfZS6bcuNgnLestHJjT9khz9cYUryz
         enbg==
X-Forwarded-Encrypted: i=1; AJvYcCVFRYNMfO6bS6YVsAClKU75Rh8at772jPd1g1NIgtDiEjVh1NgA/8sdZTvD/3vIk1nDGS0oVkdtJQ==@kvack.org
X-Gm-Message-State: AOJu0Yw6rmI+qI0PW+XWk2K0qZiudRk02mSEYU/Gij5/Bxp3Oo6WbVKl
	k5OKASiJCKTwerQbtTKX4yIXbV+5Z0X/BS1hwH1aAY8EauSoCt+mUjReUJcrHkCIh8EO39gQq33
	Am0yMzUefNVsBQPuMB86jODuQwA==
X-Received: from pfbbe3.prod.google.com ([2002:a05:6a00:1f03:b0:82c:70d1:f303])
 (user=ackerleytng job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a00:2d86:b0:823:1212:8e87 with SMTP id d2e1a72fcca58-82c95ebf212mr318666b3a.32.1774568222396;
 Thu, 26 Mar 2026 16:37:02 -0700 (PDT)
Date: Thu, 26 Mar 2026 16:36:40 -0700
In-Reply-To: <cover.1774568083.git.ackerleytng@google.com>
Mime-Version: 1.0
References: <20260326-gmem-inplace-conversion-v4-0-e202fe950ffd@google.com> <cover.1774568083.git.ackerleytng@google.com>
X-Mailer: git-send-email 2.53.0.1018.g2bb0e51243-goog
Message-ID: <a31bee8e57f464078672a95b638724e1cad423ba.1774568083.git.ackerleytng@google.com>
Subject: [POC PATCH 2/6] KVM: selftests: Call snp_launch_update_data()
 providing copy of memory
From: Ackerley Tng <ackerleytng@google.com>
To: ackerleytng@google.com
Cc: aik@amd.com, akpm@linux-foundation.org, andrew.jones@linux.dev, 
	aneesh.kumar@kernel.org, axelrasmussen@google.com, baohua@kernel.org, 
	bhe@redhat.com, binbin.wu@linux.intel.com, bp@alien8.de, brauner@kernel.org, 
	chao.p.peng@linux.intel.com, chrisl@kernel.org, corbet@lwn.net, 
	dave.hansen@linux.intel.com, david@kernel.org, forkloop@google.com, 
	hpa@zytor.com, ira.weiny@intel.com, jgg@ziepe.ca, jmattson@google.com, 
	jroedel@suse.de, jthoughton@google.com, kasong@tencent.com, 
	kvm@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-mm@kvack.org, 
	linux-trace-kernel@vger.kernel.org, mathieu.desnoyers@efficios.com, 
	mhiramat@kernel.org, michael.roth@amd.com, mingo@redhat.com, 
	nphamcs@gmail.com, oupton@kernel.org, pankaj.gupta@amd.com, 
	pbonzini@redhat.com, pratyush@kernel.org, qperret@google.com, 
	rick.p.edgecombe@intel.com, rientjes@google.com, rostedt@goodmis.org, 
	seanjc@google.com, shikemeng@huaweicloud.com, shivankg@amd.com, 
	shuah@kernel.org, skhan@linuxfoundation.org, steven.price@arm.com, 
	suzuki.poulose@arm.com, tabba@google.com, tglx@kernel.org, 
	vannapurve@google.com, vbabka@kernel.org, weixugc@google.com, 
	willy@infradead.org, wyihan@google.com, x86@kernel.org, yan.y.zhao@intel.com, 
	yuanchu@google.com
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: 0FCF3180006
X-Stat-Signature: sw7868ihb5tgd5z4smmgp8q6hqetes56
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1774568223-51386
X-HE-Meta: U2FsdGVkX1/qicErqAHFjWMCJbYJXP3peapDgsRzMJu2L79HYTU3VQrAUZ7DdSI20yoCrOveV/cqE3ejoXza14SfE09XoETWuxBHVf/055+ngWAYk0sc9Du72u9iIctdLU/DmGxLI1/d3yCXh0so2573evDDGehohXYDEsBEdnwChMS4479WL4XGBVMuuGcRKCwe8e91z94JaHkyXHoe8wOhzG7fdzY2VIOBt6TizFAJ3cRkqu68jcXYAWDTW2EwBnqHvtbH4VAc+LJsRDRT1XLxgWx33u9aCpK64ayhV3jOLwVhdanlbGFnyDUPraskg7I0Ugm25/t9ZPvIsifJDq2m3eZYCZZx0PfwY4PZA1oALmK9bEC3fZJFIXarsFekO+U5DQsO4/q4juL2Oyx14ea3FBPd0wl/pFFw0KwK31Od2zVH/g2d54u184XFQBI27EbxAy3QKgs2qr1Y1tIr83ZU3ZHgTHg0SLA50ohGOnCHn8Pp9WGtJKoF0GTRO5yWsJZsCl3ZXRlkehsZDRD89Pd9QunZABomBFrAKjII9bSBUR7kb5toHDhHVm6bLb2eQlZpUJTC5BytPUXYy+IMy5ZYkJVocfSoOhJTHJ74UGR7QUmXaziVH5VNnfaae5sF8zPwme6a4cKBOwwVUlvzZI/EgE6ZsvZiXN647+gXyiGPqps9S/G9qdcWLa2UEKUc+qIpoKrgbKygnhVErHLllEW89nabIQk0C4PVnWhvgp4WRDPvB0o+PuRqdo3nMpQV7Vm7DEaT1goI0vw5mRbDx7CVs8ykgCwqJ2x3uB7PhiSrYG+H5+5cpU5um1Wem6fZ5baTlpdaYc3ZsKSI7dbXLVEdntm5Qx5ltrIP1c77+RVnCUivMyuXsvEyJkLOIbSyZ2zU0OxC9vuNiRarCszLhPti840gH1yYYnAGlKI7oe1c2Dozy0jTaJMYZK9azyeT8EYSLoqgqg+vyU4DCZ7
 Q8KF9gAj
 DAVJpHiKdRuvkhy2sofTkBIEb2uhfSjDNREDpnGLayrbdKDiHVIShfMPJuWh1ZVZZHr89AdWL0itMeVF1476atJMMBY6FVU4HlhreX2gXVlncYAsN+edEC1mAodcYFg1sw1+10ar9zOt8TVrZaIKEKhA2gIfWriPZHs4rIga8oLKmewm1KO+xCGrIkkeMQ39iS80LeRM8+ZXRd3m01O/JeE9YTnCPp5SMNEjvfXEaxJHtxkHDAVtMVnllDf3BcIYr1LyKm+s7kSBEZFLYLo61PSxgCYExxilzW6Y+Cz5L9MJyq49sV7lMibyWRyvlAPsB/29mZmxIEzDCyUGUrxPQ34RPq3Pm7So9L0z1IEEFkFi9vaW+9acH+6OknG8TielLv82yEU1UmKzh2rQZW6bMgX1Pk3RRqEQX4y6L2C6uZmsywC3ScG6QufmO502u9y9e0rxCzi0If6OQC6fGS7450Jrq2nlL94qfoDW3YJSPBnci5awVihA0OwuMLkLRetliZ5QanAZ++pBFBIn/IP4gEfByYg9pOpU/USQTCh/U/wdzMqJKVV6PV/JRA35At4LSELSEkzAGTgGfJ5/UMEy0GLDlgB5ziNkzW6KZuDS4zqKtwAFIHCB+D4FePKOHs+HBMbQ6AsFntwp9Ff8p++fdu5ebnhKyy01hDfRyHKi73YKjlsPf8T2elCJQzlwTC2PLBExt41Fw12otL8P/1PCub4e3IA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Call snp_launch_update_data() providing a copy of the memory to be
loaded. KVM_SEV_SNP_LAUNCH_UPDATE populates memory into private memory by
first GUP-ing the source memory, then encrypting it into private memory.

The hva that was specified as the source is in this case also the
destination where the private memory will be placed after encryption.

KVM_SEV_SNP_LAUNCH_UPDATE requires the destination to be private memory,
but private memory cannot be accessed by the host and hence cannot be
GUP-ed. Hence, make a copy of the memory to be loaded, and use that as the
source, so that the source can be GUP-ed, and the destination is still
private.

Signed-off-by: Ackerley Tng <ackerleytng@google.com>
---
 tools/testing/selftests/kvm/lib/x86/sev.c | 35 +++++++++++++++++++----
 1 file changed, 29 insertions(+), 6 deletions(-)

diff --git a/tools/testing/selftests/kvm/lib/x86/sev.c b/tools/testing/selftests/kvm/lib/x86/sev.c
index d3a7241e5fc13..1b937034a5c11 100644
--- a/tools/testing/selftests/kvm/lib/x86/sev.c
+++ b/tools/testing/selftests/kvm/lib/x86/sev.c
@@ -1,6 +1,7 @@
 // SPDX-License-Identifier: GPL-2.0-only
 #include <stdint.h>
 #include <stdbool.h>
+#include <sys/mman.h>
 
 #include "sev.h"
 
@@ -31,17 +32,39 @@ static void encrypt_region(struct kvm_vm *vm, struct userspace_mem_region *regio
 	sparsebit_for_each_set_range(protected_phy_pages, i, j) {
 		const uint64_t size = (j - i + 1) * vm->page_size;
 		const uint64_t offset = (i - lowest_page_in_region) * vm->page_size;
+		void *source;
+
+		/*
+		 * Is SNP the only place where private=true? If yes,
+		 * then we don't need the private parameter, we can
+		 * just check if the vm is SNP. Or maybe it depends on
+		 * whether TDX, etc use the private parameter.
+		 */
+		if (private) {
+			const void *hva = addr_gpa2hva(vm, gpa_base + offset);
+
+			source = kvm_mmap(size, PROT_READ | PROT_WRITE,
+					  MAP_ANONYMOUS | MAP_PRIVATE, -1);
+			/*
+			 * Make a copy before setting private, because
+			 * snp_launch_update_data() needs to GUP the
+			 * source, and private memory cannot be
+			 * GUP-ed.
+			 */
+			memcpy(source, hva, size);
 
-		if (private)
 			vm_mem_set_private(vm, gpa_base + offset, size, 0);
+		}
 
-		if (is_sev_snp_vm(vm))
+		if (is_sev_snp_vm(vm)) {
 			snp_launch_update_data(vm, gpa_base + offset,
-					       (uint64_t)addr_gpa2hva(vm, gpa_base + offset),
-					       size, page_type);
-		else
-			sev_launch_update_data(vm, gpa_base + offset, size);
+					       (uint64_t)source, size,
+					       page_type);
 
+			kvm_munmap(source, size);
+		} else {
+			sev_launch_update_data(vm, gpa_base + offset, size);
+		}
 	}
 }
 
-- 
2.53.0.1018.g2bb0e51243-goog



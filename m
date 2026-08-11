Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D7CD8C5B56A
	for <linux-mm@archiver.kernel.org>; Tue, 11 Aug 2026 16:27:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E7B2E6B00A6; Tue, 11 Aug 2026 12:27:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DDD9F6B00A7; Tue, 11 Aug 2026 12:27:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D1B026B00A9; Tue, 11 Aug 2026 12:27:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B274E6B00A6
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 12:27:20 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 488581C0065
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 16:27:20 +0000 (UTC)
X-FDA: 85089518640.07.E1F9F3C
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf13.hostedemail.com (Postfix) with ESMTP id A9C4020010
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 16:27:18 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=U3hKLmyE;
	spf=pass (imf13.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786465638;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=abxli+Hzhv9GVR5sItE1YFTra2NUUXXbp3pvRn5p7EU=;
	b=yIbmd+XSy/5e16qLQf2WnIPK1wL+dsdrYBzlDOokvwKsuyz8vhAXRwU9LUPcexDxrkVwrH
	zadn6e5JVKwhgLYeqCBQs5HkGkj/xRvg4kFwi+J6ovTZFsHmesM3DnfNG+K98B4QsDxqFj
	ARFSqcwyaCD2xSeJPQjE+daet3hbkno=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786465638;
	b=qDMvyBVYCdhHifmsYQQI8e0U4FPdRPaTeRI9CGA7y3Na2s/h5XzeeXARDjrWOXeSqco3/E
	CIweJrWoYRaCfkSgFMRt+VSjj5as3DVeNH6LRwv6EL2QM57gTHLdWlgBcttEPf36P73hm3
	+HHVXHWjGzDicu2/jpCL+FYN9YtbASo=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=U3hKLmyE;
	spf=pass (imf13.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 38D5C600AE;
	Tue, 11 Aug 2026 16:27:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CCD631F000E9;
	Tue, 11 Aug 2026 16:27:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786465637;
	bh=abxli+Hzhv9GVR5sItE1YFTra2NUUXXbp3pvRn5p7EU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=U3hKLmyE9986h21u1I/RYnOIZZQXOwKmw5BknJic+XPSFq11Z0jpodg9LbbUjqcsR
	 8THgcVfT6zhyVwsyzYmZnBzOZyIp+7YNYIFjtnYwtNZ8jnTjFX6rO9nJbo4Ve/XX0E
	 vsrtZo+G8TdCC2Lu68eihAUSbYyTwKrXBEqHecknJ+dKLoyFUfYqeGbyJcC4k1ZmhK
	 hy88SyPClFgmp65Gsbp5TGsynaCq0AcUzDed1/fEyLth93t/k3+ip+/8LJO/YL+KZx
	 BrOBxNM9dluoM1mXwFfPGo2HQnxfToZ2WHB2TDklPUqt0riNb8HrROcTv4SfH2Cm3y
	 HAYOnlFhz6v7Q==
From: Pratyush Yadav <pratyush@kernel.org>
To: Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Mike Rapoport <rppt@kernel.org>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Pratyush Yadav <pratyush@kernel.org>,
	Alexander Graf <graf@amazon.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Thomas Gleixner <tglx@kernel.org>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Ard Biesheuvel <ardb@kernel.org>,
	Ilias Apalodimas <ilias.apalodimas@linaro.org>,
	Rob Herring <robh@kernel.org>,
	Saravana Kannan <saravanak@kernel.org>,
	Arnd Bergmann <arnd@arndb.de>,
	Baoquan He <baoquan.he@linux.dev>
Cc: x86@kernel.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	kexec@lists.infradead.org,
	linux-mm@kvack.org,
	linux-efi@vger.kernel.org,
	devicetree@vger.kernel.org,
	linux-arch@vger.kernel.org
Subject: [PATCH 4/4] kho: rename kho_scratch= commandline parameter to kho_bootmem=
Date: Tue, 11 Aug 2026 18:26:40 +0200
Message-ID: <20260811162642.3504565-5-pratyush@kernel.org>
X-Mailer: git-send-email 2.55.0.679.g6767b8d81c-goog
In-Reply-To: <20260811162642.3504565-1-pratyush@kernel.org>
References: <20260811162642.3504565-1-pratyush@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: ybzu5pk4yjkrtmdqwm9xqp4ceqwu9nbg
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: A9C4020010
X-HE-Tag: 1786465638-961374
X-HE-Meta: U2FsdGVkX1+e1z8zBnNWB7N915n06WzhXXFb1QOmgr3SIq/PNfOH2HQh7J8TqaFbjeU01lRrEEOfu1/K8UXBovDed5Lyceh5OTiH9a3Vu5esT6ulo807P0rBpicOeUrviWTbkzNqqpTSroby+s0x++eDN7ySMqwhj6fyeUYrQMvAvflM46Uumtc4Ju+K41yoBRDP67ieWD/9jlhh8XPJEFnX/1K8O9wGXvByaLc+vJt2yKTyo33qzU/YIqyA/6JSLOa6t/8RwGbz/0WjMtn4wvvkDTAQRphJOsuId5n1ByfcgFQ4NCAdsNY6w4ce7SKfogo55AMP+LT6oVo/9J/OQ+PRsOL+EzcY92zWCyhfODV74oqZ1Ef3QlRQZYg7IyxVFK8J0YkX0sWn2hnGJW/gVsp3hVNTnWYRJN7wPn9tlx9oWMMwlz12Wv0cdzkM0Nu6DLdAFHmj9AfPcq7kU3P0LHUsDO8DDSalGcN8enk6txo3tFSLHzDBqTU2PWY4gLCN9anelJ7B42IIaEp3h5hV2rRMcVMLVPPq0O7qyRA9Tf6Xa/CAn4nwd/jH25FQ2sa0UlxWs9ZBVkHSzEi5OfXD18OeGbReAHFz+vFvn1cN2Zj4a9i0Jkj9i6grWPA89ZIfjpj8REiR6wmwqtJenUQi+6Sm68Cnz+4ezUKMEMzxu3ZQjxhhmJkmBQdcwktHvNnfq2z+DzhiNTqXCRe34pZYcuYr0DZF8DYxkLDnGOD2dPqXfsG7pMAPFTIuInVcMHwEFK7XTtSeOiWa73CDI9bEVFSW+O37SqqPx4eBztf++fsUyppfqkThc/gzqto7KyIUtnaKDoztOq9zx8G7wICm8Z/NBaEFuq7bywPnHVy4iaJQZR2/WY0mECBaA5wBEDRGDsW4JwPJAJO0UGPLXjWIllXB4DSo3sfuzQroq4PyZj8PF9zCfqCfdSHcSYxk6mxj3IvRu+OTCC4gms9ZQnt
 C9qI5xOT
 B6LbmH7AiZxByhQKHR4e3vnLb9783jzVzh3DwRivhbit2gHIhUOwk6yUgGms5rZ61GUwhITpmBP6nJ8YmYuzeHSx4aGtuZbaKg70NGxNzevtZLXEW2dkBMsjKiM0hN5UPq+hdev1j0nalPBtFAhs7X2z9ZGTwCqU8R/8eBs8jrBCX8C3A/KlB7GZ64WKZjfChFF10cWOgVIsmh7fhsj9Bq2pcLPd2cCtPupVRF9gnAGcSamyU6I8UcaeCO732TO1KPg+EiybQFvbuL6GgOhxTJ/qiPPXRMHNgL2iR
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Pratyush Yadav (Google)" <pratyush@kernel.org>

KHO now no longer uses "scratch" to describe the memory areas passed by
previous kernel. Instead, it calls them boot memory, or bootmem in
short. Rename the kho_scratch= commandline parameter to reflect this
terminology change.

Signed-off-by: Pratyush Yadav (Google) <pratyush@kernel.org>
---
 Documentation/admin-guide/kernel-parameters.txt | 2 +-
 Documentation/admin-guide/mm/kho.rst            | 4 ++--
 kernel/liveupdate/kexec_handover.c              | 6 +++---
 3 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
index e2212f058812..a03927ffb85d 100644
--- a/Documentation/admin-guide/kernel-parameters.txt
+++ b/Documentation/admin-guide/kernel-parameters.txt
@@ -2989,7 +2989,7 @@ Kernel parameters
 			"0" | "off" | "n" - kexec handover is disabled
 			"1" | "on" | "y" - kexec handover is enabled
 
-	kho_scratch=	[KEXEC,EARLY]
+	kho_bootmem=	[KEXEC,EARLY]
 			Format: ll[KMG],mm[KMG],nn[KMG] | nn%
 
 			Defines the size of the KHO boot memory region. The
diff --git a/Documentation/admin-guide/mm/kho.rst b/Documentation/admin-guide/mm/kho.rst
index 4fae09096038..f14c8d9ad6a4 100644
--- a/Documentation/admin-guide/mm/kho.rst
+++ b/Documentation/admin-guide/mm/kho.rst
@@ -20,8 +20,8 @@ need to enable if you would like to preserve their respective state across
 kexec.
 
 To use KHO, please boot the kernel with the ``kho=on`` command line
-parameter. You may use ``kho_scratch`` parameter to define size of the
-boot memory regions. For example ``kho_scratch=16M,512M,256M`` will reserve a
+parameter. You may use ``kho_bootmem`` parameter to define size of the
+boot memory regions. For example ``kho_bootmem=16M,512M,256M`` will reserve a
 16 MiB low memory bootmem area, a 512 MiB global bootmem region, and 256 MiB
 per NUMA node bootmem regions on boot.
 
diff --git a/kernel/liveupdate/kexec_handover.c b/kernel/liveupdate/kexec_handover.c
index 3bfdbe86aaf9..da8d5ecb915b 100644
--- a/kernel/liveupdate/kexec_handover.c
+++ b/kernel/liveupdate/kexec_handover.c
@@ -669,12 +669,12 @@ unsigned int kho_bootmem_cnt;
  * The bootmem areas are scaled by default as percent of memory allocated from
  * memblock. A user can override the scale with command line parameter:
  *
- * kho_scratch=N%
+ * kho_bootmem=N%
  *
  * It is also possible to explicitly define size for a lowmem, a global and
  * per-node bootmem areas:
  *
- * kho_scratch=l[KMG],n[KMG],m[KMG]
+ * kho_bootmem=l[KMG],n[KMG],m[KMG]
  *
  * The explicit size definition takes precedence over scale definition.
  */
@@ -749,7 +749,7 @@ static int __init kho_parse_bootmem_size(char *p)
 
 	return 0;
 }
-early_param("kho_scratch", kho_parse_bootmem_size);
+early_param("kho_bootmem", kho_parse_bootmem_size);
 
 static void __init bootmem_size_update(void)
 {
-- 
2.55.0.679.g6767b8d81c-goog



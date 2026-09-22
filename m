Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C9FF3C982F1
	for <linux-mm@archiver.kernel.org>; Tue, 22 Sep 2026 04:14:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A24886B00AA; Tue, 22 Sep 2026 00:14:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9AE2E6B00AB; Tue, 22 Sep 2026 00:14:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8009B6B00AC; Tue, 22 Sep 2026 00:14:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 4FD906B00AA
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 00:14:04 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 5805A12034A
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 04:14:03 +0000 (UTC)
X-FDA: 85240080366.09.0B58FEF
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf29.hostedemail.com (Postfix) with ESMTP id D0C3D120002
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 04:14:01 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=lNK1gNgS;
	spf=pass (imf29.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790050441;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3JhbkvL+0f8gvXye8KGOOiOlIpLpto8LiGmguIZMevY=;
	b=q8ayEEqw90+YPi7slOUQlc5v0hCSlJMLadbRBHo/3XC+4/TEgkJ//GLAlj4aVNuUGYSZc2
	YoTGucBgfoR/ktjSFXlDo+yz6EkgQD+o7X2RNM9mbFqfDp0fjv/5Y5se2FW4bIWagcWN59
	PM9QNBKKGwubxfjA6PZ1SsByqnhvjcY=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=lNK1gNgS;
	spf=pass (imf29.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790050441;
	b=S6SgDT6YtlRLA3G7xBTPov/fxA/viPkZZ+kUhkAjwQH3AL2sBijyBJITlkXSWJW4piPX51
	Sb26nyqOZXmsDVqd15RnwUkka8aXhKtCkef1fFtFMwHeyrwiW179GaRRfc+NQnMfdNcV2D
	TsAN0aCOPtOoFQmvEoXSUzx2KACgG50=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 902F460236;
	Tue, 22 Sep 2026 04:14:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 477B01F000FF;
	Tue, 22 Sep 2026 04:13:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790050440;
	bh=3JhbkvL+0f8gvXye8KGOOiOlIpLpto8LiGmguIZMevY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lNK1gNgShJJpusLlZPOmjVBfk/yMx/e4K7M/fOX449kJiCAMPuoIP0wPz99MYiEPk
	 moidshyK8kQSZv4gEJRA0Pglkggl8AXaRI0oTuz6P/YUWZfwhRv3EUs0GPyRU9oD0m
	 DPlnk9bJmyB1bKQzY9a5yXfJEZpedncnBnPic6OTPA4IOIqeGLYtMKlummlBXb/apz
	 4XWA9rdTaHLORV4+DmBLyct59dfMpLSbNsx7Nv77bTjg5dSwhXQOoY7wM8ceFqXwFw
	 QMwyRjlT7mGCTtVnRT9/RwXWri9F/XB/SIJLX0NjGZIjSKApwSf6ITh9Xm8iX0XsQh
	 rOyCMTm7zwOCA==
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
Subject: [PATCH v3 4/4] kho: rename kho_scratch= commandline parameter to kho_bootmem=
Date: Tue, 22 Sep 2026 06:13:16 +0200
Message-ID: <20260922041321.233986-5-pratyush@kernel.org>
X-Mailer: git-send-email 2.55.0.1082.g2b9226bbc0-goog
In-Reply-To: <20260922041321.233986-1-pratyush@kernel.org>
References: <20260922041321.233986-1-pratyush@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: D0C3D120002
X-Stat-Signature: nxfb96gz7cuxwxsq94kjqex6m1wguj5p
X-Rspam-User: 
X-HE-Tag: 1790050441-937596
X-HE-Meta: U2FsdGVkX1/phuNXQu3QOBKkN3UzLhT2eIH8nDwHc0AdaOXmwBbPMfTDBEfYWa23ozfwodBPN99p1hCDIucSNOOoayqqnGNVrLBaaFi1OaT57d1ADQ4oDuixjj83sXsNXvwv0j2UnW/sNB3S4XAiZgyHreU9UME4wO7VTuG/YyTUHeRPZhmmITXWhQhndkrcQzoGWO4r6PjeRd4a3JaN2tNrab/p7N6zc/1ws3RdRUQTuJV5ALIfTSKT6mjOvFrjWCJ++wA4p+1xvJhontfgNzYvUXh0jB3wnzxcs8u8JQWfnNmEAMP2tKbxFfqUaTgljnQV+pNF6p/Q6zpEhMHN6gDSAoKNC3rxGiFWH45oyS7mlLb7CgfOYKTDAu7Tx6bEJV0oTKSIx47cX8fZxKRdNv7RGgqP+9YdyNvmEtYPCbJLLeR8o1txZm7DlPpbOPrXqGmSYYtmyP6azWFlxZQIJrsxwOrIcowi8dIL6aaNSgRSOQXmkb7Ia8Y/AvHOAB3LHSFnjWiNpjYsdyiE9Anb/JXK8SThkEcz0itPKhhv7ekSHascgLw9QinhNquUozU5qUr97HFcsQZi810ZYFCKVu2s2GoF02wqYOiyK5xRL1QFo9LgxQCn1W1XwAKlpsmaVvai9FB+G+mB6CYZaSj5BWddDXF18i9t+8zvafJJN0v9u3Xej2moPdRezHgVXI4H+4Vw+/xPUkPMTQ8WR3AVdX9Gi6xooBKO35Zbnxpe0UsikrS+R1yHiuUgjdvJtgbnY6VmmLcrUHBDtGS6cav2cqqJ8ZFPisKK2QGFcVXcS0q0vu/H2+PnP0q+cN8CxXtLY1P5fcskt0Tv2XTnfJaPmXz8dCYcIttl7aVNFc/MGIUTlV6JOPwnLzALvmZd8KuTlNHqxxfRXlQjN8FvmtfPJwWMUeNJLF2rxhbNS6w9CGSJ5zZZ6WFAVLGb3fvqTM891AJ6F7N0L3yhzKVDUeJ
 /u/nlier
 EFOCvPPOf2RO1sTKkGF0OPSVNIl7a+vGaJCKGCkqql91ZrKLLvn26UOrAZ4i2QuoZXolkD9Ae19BCZC7WvctOpgQENLUlNRjUVztucg662HCW/iLOGLqxSAHSErdHNSlemYLjEL+nVOVfQ3cXPRentfpBea+ARlQuxBUk5d8pajozv0kjvvk9Xbe+O1TdFEb8AzVsJyWk2vsOWk7rEzn0qlrFcoLGT383PeBpW4nKFrLi/jZayF4tJnd4MLncxr4U1bHR5GIj6sd3Uijcxafpnp8sac1wPlepFUiXelj2sOrX/h5srhUavLrAwhdi9O4bQ+14WYsjBTvcIzB6DFYeySyEXx5qv6S1n6LaEMNJpbwEuBEf1e7rUz+uzXtlVTlrt3tvyjWDXL8RT/Uk8QVuf52oPA==
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
index 6132fa73382a..8a42a924f133 100644
--- a/Documentation/admin-guide/kernel-parameters.txt
+++ b/Documentation/admin-guide/kernel-parameters.txt
@@ -3031,7 +3031,7 @@ Kernel parameters
 			"0" | "off" | "n" - kexec handover is disabled
 			"1" | "on" | "y" - kexec handover is enabled
 
-	kho_scratch=	[KEXEC,EARLY]
+	kho_bootmem=	[KEXEC,EARLY]
 			Format: ll[KMG],mm[KMG],nn[KMG] | nn%
 
 			Defines the size of the KHO boot memory region. The
diff --git a/Documentation/admin-guide/mm/kho.rst b/Documentation/admin-guide/mm/kho.rst
index a6a09b693413..902d171a780a 100644
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
index fe4b76ff5a2c..7018e25e4eda 100644
--- a/kernel/liveupdate/kexec_handover.c
+++ b/kernel/liveupdate/kexec_handover.c
@@ -671,12 +671,12 @@ unsigned int kho_bootmem_cnt;
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
@@ -751,7 +751,7 @@ static int __init kho_parse_bootmem_size(char *p)
 
 	return 0;
 }
-early_param("kho_scratch", kho_parse_bootmem_size);
+early_param("kho_bootmem", kho_parse_bootmem_size);
 
 static void __init bootmem_size_update(void)
 {
-- 
2.55.0.1082.g2b9226bbc0-goog



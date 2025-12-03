Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 959DFD116F3
	for <linux-mm@archiver.kernel.org>; Wed,  3 Dec 2025 08:19:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DB18D6B0029; Wed,  3 Dec 2025 03:19:02 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D89B86B002A; Wed,  3 Dec 2025 03:19:02 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C77D76B002B; Wed,  3 Dec 2025 03:19:02 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id AF8176B0029
	for <linux-mm@kvack.org>; Wed,  3 Dec 2025 03:19:02 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 5E63513B2FF
	for <linux-mm@kvack.org>; Wed,  3 Dec 2025 08:19:02 +0000 (UTC)
X-FDA: 84177459324.24.D1472DD
Received: from mail-qk1-f180.google.com (mail-qk1-f180.google.com [209.85.222.180])
	by imf25.hostedemail.com (Postfix) with ESMTP id 62BACA0005
	for <linux-mm@kvack.org>; Wed,  3 Dec 2025 08:19:00 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=abF7PT5a;
	spf=pass (imf25.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.180 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764749940;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bVMfaK9DBSZeHHhZl60d3mvaanEQhm1Qa80beqsAfnE=;
	b=uemuRYdDzn0VlELJgVtKwfc27wkWapIMljvK9b3+4baHs755n1sMY3OTaiubKLHHQDhZ1J
	a9DLStLgU/KnbHqU7ek/yr/IDKusV3gVyPT6Ojj3YdBEqH/BKazeYkucCx2R/XxdHfHXuT
	vsnaau+GbUJO2INEcgQQusDzODVivbE=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=abF7PT5a;
	spf=pass (imf25.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.180 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764749940; a=rsa-sha256;
	cv=none;
	b=haXl0QgXvgr1MIe4dzPAESNAg+mZOcRdEI5Imv92r7FGrR5ntxZU1/qQQ7n7PngLawxBIf
	MTi5T7DnxbKvXlfjwcDn7oK16DhMdftSxp3H8eiT/kkrk35PQuQDODH5gsmTHQ9tuDjIB/
	9zsCEakZtl7SV37XDZF1IPLJXRVhtcY=
Received: by mail-qk1-f180.google.com with SMTP id af79cd13be357-8b22624bcdaso740727085a.3
        for <linux-mm@kvack.org>; Wed, 03 Dec 2025 00:19:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1764749939; x=1765354739; darn=kvack.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=bVMfaK9DBSZeHHhZl60d3mvaanEQhm1Qa80beqsAfnE=;
        b=abF7PT5a2N303vI2Hrqn2C6mHozyRXnIZDOw9rZW+SIFexsvHOEeqhrcgaujBE5tsT
         xHm49wRAtW2xDwmmWtlz0f08GCstXU7vuKNczc1xTgZpq+oMVNfytVbczMKHrNvKDvdg
         IA9cK06/8/HtbWoTraItRy1CsLSoeTTSlh0xTilrh7kWoGWaO+WWFscpcq4adL9xHu7L
         6vuU/RAs8f2exPECK6GvK6sk3cZDPGYrOaPY9FUSeo9BF07W/ZpBhta5nfvQ9sD+lbhA
         PhYjk1/wIsDSyEI5v/3TIwVVoJQU2FNe5WtHmaz6T5D3cJ3sC9sVl3kPNb/FKSo7Zl0y
         kXtA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764749939; x=1765354739;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=bVMfaK9DBSZeHHhZl60d3mvaanEQhm1Qa80beqsAfnE=;
        b=Oy/YCF2a46SG4C57G4P8GxnN0hlDAVHOKVxnH74Bwa2nLEIcmM5iCvXSeB3X/emnZb
         Nx0mil7BFdd1xFB8GYP1oJ6uK9uefM7i/xS9tiz4hwqYhjv00kSVy+OJg6CWvBCJVQNH
         oXcIRzJj4AlQxv0CArpBudoojYgQ4rvYSuDAy56DPC5TLBqLqktQ3Sp9kFtP0LrgAxL9
         tjzsYYIq6wDrKWC/Z/9iEq6vwaYW1LS9zYV9hx+j9Z5Xoi0FrULAyEu5rIYJBfdWPqxZ
         frPICYzP1ZjyNK1EP3rd1sttqJQbOfFKInxhpYYL17pjvLivGUDzSwjP+wRuZX8KlzD8
         /woA==
X-Gm-Message-State: AOJu0Yzl6N8quN98ffMfxAM7S/3sJjVtUEJF1kdDRin6I9sK8Pfi6M+O
	95Ic3MxVHc9OowzUtbHlCDsm314erOfGJzpgSOe36JJj4jKiJgeFnvQotxBXAuDsrAyP+6x2uFG
	jfw0D
X-Gm-Gg: ASbGncvyP1qae1Q7zi61XfI30uJd3jUIVuekM8r5hDsHPsKW3qavIW1YwAjL6Ulu8o7
	yUq2y+cf5eSOVE+gFbjZTHQ3KSjNp28Kk4WLFPytBa1SauVygkmqvF7SzfccBZW83YcNdEF/sz6
	KgniLH1mBEJPCT2KTec0NRx0z1+NbWiebRu7Cd4/8y4rStPaK6PQ79XB5Vx1CvwJ/hpWtCsCW6V
	p7xpP4dgP5QJvVfkrQ+ggBLG1UDvVr987eR/GdLHqMXfALN57LxAOxFgNsURbXNWnsm8tc+Dyll
	arfiH/oTDx79LsHUU1jiBeh7w0JxwYw4VvtIF72LVSV7+fYUJV8N3t186q7K8I9z+1I0Xe6ZxAu
	L4Gg7OOrPJVG2XiGRMa8O7ElGkI7hcoi15fvdKLmYw8mO1J4/QPRkIZk/TCEh3jeTJ8Cgw3tbcM
	/qTadhqaBXLyhzjdv1WSDt0azidmT3AwokjNkO98JVLdjK4SZ0vSxGf4st8DzS61ylNxVRSYsF0
	MF74Yst
X-Google-Smtp-Source: AGHT+IF4V6+inMElcPd4cBToKnPH8czckhw4VafyJlwLQUg3slsWJlJvUS2iV4QYV/TfdfS2eCsT0g==
X-Received: by 2002:a05:620a:3189:b0:8b2:eefb:c899 with SMTP id af79cd13be357-8b5e68a302fmr153138385a.71.1764749939365;
        Wed, 03 Dec 2025 00:18:59 -0800 (PST)
Received: from gourry-fedora-PF4VCD3F (pool-96-255-20-138.washdc.ftas.verizon.net. [96.255.20.138])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8b52a1de6b8sm1275953785a.54.2025.12.03.00.18.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Dec 2025 00:18:58 -0800 (PST)
Date: Wed, 3 Dec 2025 03:18:57 -0500
From: Gregory Price <gourry@gourry.net>
To: Jayaraj Rajappan <jayarajpr@gmail.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	lorenzo.stoakes@oracle.com
Subject: Re: Calls to do_swap_page() from handle_pte_fault() on a system
 where swap is not configured
Message-ID: <aS_ycQQh5n1cVIRk@gourry-fedora-PF4VCD3F>
References: <CAEJW1wECyPh-wbgnnoOGY460ido=U2A3rPhF1FQAv7txed1-Rw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAEJW1wECyPh-wbgnnoOGY460ido=U2A3rPhF1FQAv7txed1-Rw@mail.gmail.com>
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 62BACA0005
X-Stat-Signature: keqm6ja19w1xtrmr99m8t6wdfewymtmc
X-Rspam-User: 
X-HE-Tag: 1764749940-822418
X-HE-Meta: U2FsdGVkX19A7kkcs32lE+400bXKtU9NaE0MGqFrNP6eCE3l4Pwrm2snOTm7U0i93GTIGzYW2xzYrNlpQ99noBM/LRQyQxqwBBEVWmOH2mhhUl0W5R18YFq4eJPyRdo8sfS/V/izMMzDhC+GYkkTzrFXf12+YByzK/WJEnbGmPSK4Pe8dQRjah7rNrCKwlQRuOKPdjrt7DonHdBI+8S/WM0CGWu/OcL90N80orjkvawuMuEdpZMkp15dA0K1052nVD7cithERLR+elFzIjDd9bb19WPZQZVROGGhovdgq2Gd9WM3lF8LmyymVYZDGT1lzc+jw/uZ1pJibONdfTPP27djEPZnVtFNDVCaYkIkBvBjoqaIDL+2PU95PN2WJ2ue9jo6+FGu5qufHi70PH3MXZ2YlJYsN0/Wi6EQxYy3wo5x6MKNWL6IMetsWkFJllXb8lF9L4Jh/yq43EgMN2mZZmUS7ISLJXnYUIAWtPEu98kNmzPJFAfxC4kkZX/d3tFhUyf8CEm/nKRh5KvcVkCDIyBnFSSLvvw94i7MeW6LwKxqLZEm0PArzJ2LSmQ3nMe0Or6tQbjnOb3nTsmIqVnSk+9ZvYABG18aFqTudWkfdhyqb3UpQenOe5/BMOEG8pKBn47Eqwh+xu/rFJg/b4J7CQjYCYrawad2g/gicjknnHgGGz0oDt/t8oxXpLbGcigySol1VFy2dWdGJyElieUXbdjWPpcz8JV0i0W3EJnJLERWev0RY3ZCNPjI2Gj60Qzo68LnUZ/6UlxmaiyPMybSgZ8w6RPQqKPg+Dl56ToV4LKH4fWr/7r9iNhnayXdIfG2wAs0l20dkQbGxoZ10IUSRgFc7TRWul9swWBrLK5RCn/gDV99s6U2v3DEK27HBtZkKHEvvv1G0EbsySaPXxc30s31lO9PT2Ko+vjWU30ZUtRFAFNOyLBMBHTyXMn3z5lzmuPBgXE5dUmfO4B8Vh/
 YqNGfQhf
 j00lTgUYOXfLcWQrnjeDNm31MfDWX5HHeQ8qwPEZLmxC1qQSrfdjFsrXgnmhhDI6nbYiAHMjaRiCbLIv5qxCuP9FwBGiBNCa0FO4rR8Ma7c5SJgzNdZWednnDQH7XpuTB375/cknKBdDm7yWSOwxnBRtO9GL6YWoxuReUznA/Db64QVjmgCMx0oVk+DHk38D71+kBh7f3uWbhf3JbKd/8WaUfUx5IE9FkBK61fK7NgUeklzEe83NBEqFjRHxVmsG+8d/St+4A3eQpBXpSjOA4qi4nniMK9Rt4n1QVlSFJ1Mt4rSRXIhz+TcYm6gStxnRIMhP7aBTrri+y5t0R2yLIcVlrViH0Eewgj2taeNCP/WdCyExUzRhRE6SbPabRokN0aczNU6ziTYXr62SnhRiLjwQWNvcNUJzdBT0SfmkZ0sz1eUPvWdZaMr6+ljNSUdoPrqQbyjoNGRrUXtjXWrmNXC8Wu74NEp3ZT12kOf4fQKL+Tcc/XyvBJ9c26UkKaUy7Z1nFKSTgpN4an1z0JrcEMqQ05A==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Dec 03, 2025 at 01:11:24PM +0530, Jayaraj Rajappan wrote:
> Hi,
> 
> On a system where swap is not configured, profiling using Linux "perf"
> tool shows that do_swap_page() gets called from handle_pte_fault().
> Kernel version is 5.14.0. HugePages are disabled on the system. Trying
> to understand what could cause do_swap_page() to be called when there
> is no swap configured on the system.
> 

all do_swap_page() call means is that the PTE is valid (something is
there) but not present (the present-bit is not set, or whatever that
particular architecture considers is present is not met)

static vm_fault_t handle_pte_fault(struct vm_fault *vmf)
{
...
        if (!vmf->pte)
                return do_pte_missing(vmf);

        if (!pte_present(vmf->orig_pte))
                return do_swap_page(vmf);
}


There are other non-swap swap-entries that are handled by the same code.
Transient migrations, device private, etc etc.

swap-entries are being renamed "softleaf" entries here shortly:
https://lore.kernel.org/linux-mm/cover.1762812360.git.lorenzo.stoakes@oracle.com/

So it means "a software-entry is present" which could be any of:
enum softleaf_type {
	/* Fundamental types. */
	SOFTLEAF_NONE,
	SOFTLEAF_SWAP,
	/* Migration types. */
	SOFTLEAF_MIGRATION_READ,
	SOFTLEAF_MIGRATION_READ_EXCLUSIVE,
	SOFTLEAF_MIGRATION_WRITE,
	/* Device types. */
	SOFTLEAF_DEVICE_PRIVATE_READ,
	SOFTLEAF_DEVICE_PRIVATE_WRITE,
	SOFTLEAF_DEVICE_EXCLUSIVE,
	/* H/W posion types. */
	SOFTLEAF_HWPOISON,
	/* Marker types. */
	SOFTLEAF_MARKER,
};

-------

+Cc Lorenzo:

do_swap_page() is a stale name now probably?

I know there was a hold-off on changing actual swap code, but maybe
worth changing do_swap_page -> do_softleaf_page?

Not build or anything tested (sorry it's 3am insomnia time), basically just:

s/do_swap_page/do_softleaf_page
s/DO_SWAP_PAGE/DO_SOFTLEAF_PAGE

No clue what's up with the special sparc stuff.

~Gregory

-------

From 92de7131f74b9300ea711ceae98bbe137cf0058f Mon Sep 17 00:00:00 2001
From: Gregory Price <gourry@gourry.net>
Date: Wed, 3 Dec 2025 03:12:44 -0500
Subject: [PATCH] mm: rename do_swap_page to do_softleaf_page

do_swap_page is a stale function name with introductio of softleaf.

Signed-off-by: Gregory Price <gourry@gourry.net>
---
 Documentation/admin-guide/mm/ksm.rst                   |  2 +-
 Documentation/gpu/rfc/gpusvm.rst                       |  2 +-
 .../translations/zh_CN/admin-guide/mm/ksm.rst          |  2 +-
 .../translations/zh_TW/admin-guide/mm/ksm.rst          |  2 +-
 arch/sparc/include/asm/pgtable_64.h                    |  4 ++--
 include/linux/ksm.h                                    |  4 ++--
 include/linux/pgtable.h                                | 10 +++++-----
 mm/internal.h                                          |  2 +-
 mm/khugepaged.c                                        |  6 +++---
 mm/ksm.c                                               |  2 +-
 mm/memory-failure.c                                    |  2 +-
 mm/memory.c                                            | 10 +++++-----
 mm/page_io.c                                           |  2 +-
 mm/rmap.c                                              |  4 ++--
 mm/shmem.c                                             |  2 +-
 mm/swapfile.c                                          |  6 +++---
 mm/zswap.c                                             |  4 ++--
 17 files changed, 33 insertions(+), 33 deletions(-)

diff --git a/Documentation/admin-guide/mm/ksm.rst b/Documentation/admin-guide/mm/ksm.rst
index ad8e7a41f3b5..4c660dbc908e 100644
--- a/Documentation/admin-guide/mm/ksm.rst
+++ b/Documentation/admin-guide/mm/ksm.rst
@@ -286,7 +286,7 @@ cow_ksm
 
 ksm_swpin_copy
 	is incremented every time a KSM page is copied when swapping in
-	note that KSM page might be copied when swapping in because do_swap_page()
+	note that KSM page might be copied when swapping in because do_softleaf_page()
 	cannot do all the locking needed to reconstitute a cross-anon_vma KSM page.
 
 Advisor
diff --git a/Documentation/gpu/rfc/gpusvm.rst b/Documentation/gpu/rfc/gpusvm.rst
index 469db1372f16..3a444bf2768b 100644
--- a/Documentation/gpu/rfc/gpusvm.rst
+++ b/Documentation/gpu/rfc/gpusvm.rst
@@ -14,7 +14,7 @@ Agreed upon design principles
 	  this path. These are not required and generally a bad idea to
 	  invent driver defined locks to seal core MM races.
 	* An example of a driver-specific lock causing issues occurred before
-	  fixing do_swap_page to lock the faulting page. A driver-exclusive lock
+	  fixing do_softleaf_page to lock the faulting page. A driver-exclusive lock
 	  in migrate_to_ram produced a stable livelock if enough threads read
 	  the faulting page.
 	* Partial migration is supported (i.e., a subset of pages attempting to
diff --git a/Documentation/translations/zh_CN/admin-guide/mm/ksm.rst b/Documentation/translations/zh_CN/admin-guide/mm/ksm.rst
index 0029c4fd2201..269cb94362ce 100644
--- a/Documentation/translations/zh_CN/admin-guide/mm/ksm.rst
+++ b/Documentation/translations/zh_CN/admin-guide/mm/ksm.rst
@@ -191,7 +191,7 @@ cow_ksm
 
 ksm_swpin_copy
         在换入时，每次KSM页被复制时都会被递增。请注意，KSM页在换入时可能会被复
-        制，因为do_swap_page()不能做所有的锁，而需要重组一个跨anon_vma的KSM页。
+        制，因为do_softleaf_page()不能做所有的锁，而需要重组一个跨anon_vma的KSM页。
 
 --
 Izik Eidus,
diff --git a/Documentation/translations/zh_TW/admin-guide/mm/ksm.rst b/Documentation/translations/zh_TW/admin-guide/mm/ksm.rst
index 1b4944b3cf61..afea57754c41 100644
--- a/Documentation/translations/zh_TW/admin-guide/mm/ksm.rst
+++ b/Documentation/translations/zh_TW/admin-guide/mm/ksm.rst
@@ -191,7 +191,7 @@ cow_ksm
 
 ksm_swpin_copy
         在換入時，每次KSM頁被複制時都會被遞增。請注意，KSM頁在換入時可能會被複
-        制，因爲do_swap_page()不能做所有的鎖，而需要重組一個跨anon_vma的KSM頁。
+        制，因爲do_softleaf_page()不能做所有的鎖，而需要重組一個跨anon_vma的KSM頁。
 
 --
 Izik Eidus,
diff --git a/arch/sparc/include/asm/pgtable_64.h b/arch/sparc/include/asm/pgtable_64.h
index 615f460c50af..7fee128daf03 100644
--- a/arch/sparc/include/asm/pgtable_64.h
+++ b/arch/sparc/include/asm/pgtable_64.h
@@ -1054,8 +1054,8 @@ void adi_restore_tags(struct mm_struct *mm, struct vm_area_struct *vma,
 int adi_save_tags(struct mm_struct *mm, struct vm_area_struct *vma,
 		  unsigned long addr, pte_t oldpte);
 
-#define __HAVE_ARCH_DO_SWAP_PAGE
-static inline void arch_do_swap_page(struct mm_struct *mm,
+#define __HAVE_ARCH_DO_SOFTLEAF_PAGE
+static inline void arch_do_softleaf_page(struct mm_struct *mm,
 				     struct vm_area_struct *vma,
 				     unsigned long addr,
 				     pte_t pte, pte_t oldpte)
diff --git a/include/linux/ksm.h b/include/linux/ksm.h
index c982694c987b..a024ca1bae3a 100644
--- a/include/linux/ksm.h
+++ b/include/linux/ksm.h
@@ -81,10 +81,10 @@ static inline void ksm_exit(struct mm_struct *mm)
 }
 
 /*
- * When do_swap_page() first faults in from swap what used to be a KSM page,
+ * When do_softleaf_page() first faults in from swap what used to be a KSM page,
  * no problem, it will be assigned to this vma's anon_vma; but thereafter,
  * it might be faulted into a different anon_vma (or perhaps to a different
- * offset in the same anon_vma).  do_swap_page() cannot do all the locking
+ * offset in the same anon_vma).  do_softleaf_page() cannot do all the locking
  * needed to reconstitute a cross-anon_vma KSM page: for now it has to make
  * a copy, and leave remerging the pages to a later pass of ksmd.
  *
diff --git a/include/linux/pgtable.h b/include/linux/pgtable.h
index b13b6f42be3c..21262969b6b3 100644
--- a/include/linux/pgtable.h
+++ b/include/linux/pgtable.h
@@ -1142,8 +1142,8 @@ static inline int pgd_same(pgd_t pgd_a, pgd_t pgd_b)
 }
 #endif
 
-#ifndef __HAVE_ARCH_DO_SWAP_PAGE
-static inline void arch_do_swap_page_nr(struct mm_struct *mm,
+#ifndef __HAVE_ARCH_DO_SOFTLEAF_PAGE
+static inline void arch_do_softleaf_page_nr(struct mm_struct *mm,
 				     struct vm_area_struct *vma,
 				     unsigned long addr,
 				     pte_t pte, pte_t oldpte,
@@ -1157,17 +1157,17 @@ static inline void arch_do_swap_page_nr(struct mm_struct *mm,
  * page is being swapped out, this metadata must be saved so it can be
  * restored when the page is swapped back in. SPARC M7 and newer
  * processors support an ADI (Application Data Integrity) tag for the
- * page as metadata for the page. arch_do_swap_page() can restore this
+ * page as metadata for the page. arch_do_softleaf_page() can restore this
  * metadata when a page is swapped back in.
  */
-static inline void arch_do_swap_page_nr(struct mm_struct *mm,
+static inline void arch_do_softleaf_page_nr(struct mm_struct *mm,
 					struct vm_area_struct *vma,
 					unsigned long addr,
 					pte_t pte, pte_t oldpte,
 					int nr)
 {
 	for (int i = 0; i < nr; i++) {
-		arch_do_swap_page(vma->vm_mm, vma, addr + i * PAGE_SIZE,
+		arch_do_softleaf_page(vma->vm_mm, vma, addr + i * PAGE_SIZE,
 				pte_advance_pfn(pte, i),
 				pte_advance_pfn(oldpte, i));
 	}
diff --git a/mm/internal.h b/mm/internal.h
index 04c307ee33ae..7019db4f6dd6 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -436,7 +436,7 @@ static inline vm_fault_t vmf_anon_prepare(struct vm_fault *vmf)
 	return ret;
 }
 
-vm_fault_t do_swap_page(struct vm_fault *vmf);
+vm_fault_t do_softleaf_page(struct vm_fault *vmf);
 void folio_rotate_reclaimable(struct folio *folio);
 bool __folio_end_writeback(struct folio *folio);
 void deactivate_file_folio(struct folio *folio);
diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index 89c33ef7aac3..a6e09e94834c 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -1007,7 +1007,7 @@ static int __collapse_huge_page_swapin(struct mm_struct *mm,
 		if (!pte++) {
 			/*
 			 * Here the ptl is only used to check pte_same() in
-			 * do_swap_page(), so readonly version is enough.
+			 * do_softleaf_page(), so readonly version is enough.
 			 */
 			pte = pte_offset_map_ro_nolock(mm, pmd, addr, &ptl);
 			if (!pte) {
@@ -1024,12 +1024,12 @@ static int __collapse_huge_page_swapin(struct mm_struct *mm,
 
 		vmf.pte = pte;
 		vmf.ptl = ptl;
-		ret = do_swap_page(&vmf);
+		ret = do_softleaf_page(&vmf);
 		/* Which unmaps pte (after perhaps re-checking the entry) */
 		pte = NULL;
 
 		/*
-		 * do_swap_page returns VM_FAULT_RETRY with released mmap_lock.
+		 * do_softleaf_page returns VM_FAULT_RETRY with released mmap_lock.
 		 * Note we treat VM_FAULT_RETRY as VM_FAULT_ERROR here because
 		 * we do not retry here and swap entry will remain in pagetable
 		 * resulting in later failure.
diff --git a/mm/ksm.c b/mm/ksm.c
index cfc182255c7b..002140f01bf5 100644
--- a/mm/ksm.c
+++ b/mm/ksm.c
@@ -3124,7 +3124,7 @@ struct folio *ksm_might_need_to_copy(struct folio *folio,
 	if (PageHWPoison(page))
 		return ERR_PTR(-EHWPOISON);
 	if (!folio_test_uptodate(folio))
-		return folio;		/* let do_swap_page report the error */
+		return folio;		/* let do_softleaf_page report the error */
 
 	new_folio = vma_alloc_folio(GFP_HIGHUSER_MOVABLE, 0, vma, addr);
 	if (new_folio &&
diff --git a/mm/memory-failure.c b/mm/memory-failure.c
index fbc5a01260c8..07e3a17af119 100644
--- a/mm/memory-failure.c
+++ b/mm/memory-failure.c
@@ -1104,7 +1104,7 @@ static int me_pagecache_dirty(struct page_state *ps, struct page *p)
  *      - but keep in the swap cache, so that when we return to it on
  *        a later page fault, we know the application is accessing
  *        corrupted data and shall be killed (we installed simple
- *        interception code in do_swap_page to catch it).
+ *        interception code in do_softleaf_page to catch it).
  *
  * Clean swap cache pages can be directly isolated. A later page fault will
  * bring in the known good data from disk.
diff --git a/mm/memory.c b/mm/memory.c
index 6675e87eb7dd..6d31eda830a5 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -3371,7 +3371,7 @@ int apply_to_existing_page_range(struct mm_struct *mm, unsigned long addr,
  * handle_pte_fault chooses page fault handler according to an entry which was
  * read non-atomically.  Before making any commitment, on those architectures
  * or configurations (e.g. i386 with PAE) which might give a mix of unmatched
- * parts, do_swap_page must check under lock before unmapping the pte and
+ * parts, do_softleaf_page must check under lock before unmapping the pte and
  * proceeding (but do_wp_page is only called after already making such a check;
  * and do_anonymous_page can safely check later on).
  */
@@ -4569,7 +4569,7 @@ static struct folio *alloc_swap_folio(struct vm_fault *vmf)
 		goto fallback;
 
 	/*
-	 * For do_swap_page, find the highest order where the aligned range is
+	 * For do_softleaf_page, find the highest order where the aligned range is
 	 * completely swap entries with contiguous swap offsets.
 	 */
 	order = highest_order(orders);
@@ -4618,7 +4618,7 @@ static DECLARE_WAIT_QUEUE_HEAD(swapcache_wq);
  * We return with the mmap_lock locked or unlocked in the same cases
  * as does filemap_fault().
  */
-vm_fault_t do_swap_page(struct vm_fault *vmf)
+vm_fault_t do_softleaf_page(struct vm_fault *vmf)
 {
 	struct vm_area_struct *vma = vmf->vma;
 	struct folio *swapcache, *folio = NULL;
@@ -5008,7 +5008,7 @@ vm_fault_t do_swap_page(struct vm_fault *vmf)
 	VM_BUG_ON(!folio_test_anon(folio) ||
 			(pte_write(pte) && !PageAnonExclusive(page)));
 	set_ptes(vma->vm_mm, address, ptep, pte, nr_pages);
-	arch_do_swap_page_nr(vma->vm_mm, vma, address,
+	arch_do_softleaf_page_nr(vma->vm_mm, vma, address,
 			pte, pte, nr_pages);
 
 	folio_unlock(folio);
@@ -6234,7 +6234,7 @@ static vm_fault_t handle_pte_fault(struct vm_fault *vmf)
 		return do_pte_missing(vmf);
 
 	if (!pte_present(vmf->orig_pte))
-		return do_swap_page(vmf);
+		return do_softleaf_page(vmf);
 
 	if (pte_protnone(vmf->orig_pte) && vma_is_accessible(vmf->vma))
 		return do_numa_page(vmf);
diff --git a/mm/page_io.c b/mm/page_io.c
index 3c342db77ce3..3bcc8487b600 100644
--- a/mm/page_io.c
+++ b/mm/page_io.c
@@ -514,7 +514,7 @@ static bool swap_read_folio_zeromap(struct folio *folio)
 	/*
 	 * Swapping in a large folio that is partially in the zeromap is not
 	 * currently handled. Return true without marking the folio uptodate so
-	 * that an IO error is emitted (e.g. do_swap_page() will sigbus).
+	 * that an IO error is emitted (e.g. do_softleaf_page() will sigbus).
 	 */
 	if (WARN_ON_ONCE(swap_zeromap_batch(folio->swap, nr_pages,
 			&is_zeromap) != nr_pages))
diff --git a/mm/rmap.c b/mm/rmap.c
index f955f02d570e..21c3a40ee824 100644
--- a/mm/rmap.c
+++ b/mm/rmap.c
@@ -2535,7 +2535,7 @@ static bool try_to_migrate_one(struct folio *folio, struct vm_area_struct *vma,
 
 			/*
 			 * Store the pfn of the page in a special migration
-			 * pte. do_swap_page() will wait until the migration
+			 * pte. do_softleaf_page() will wait until the migration
 			 * pte is removed and then restart fault handling.
 			 */
 			if (writable)
@@ -2755,7 +2755,7 @@ struct page *make_device_exclusive(struct mm_struct *mm, unsigned long addr,
 
 	/*
 	 * Store the pfn of the page in a special device-exclusive PFN swap PTE.
-	 * do_swap_page() will trigger the conversion back while holding the
+	 * do_softleaf_page() will trigger the conversion back while holding the
 	 * folio lock.
 	 */
 	entry = make_device_exclusive_entry(page_to_pfn(page));
diff --git a/mm/shmem.c b/mm/shmem.c
index ad18172ff831..7fa65a8501b4 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -2092,7 +2092,7 @@ static struct folio *shmem_swap_alloc_folio(struct inode *inode,
  * we may need to copy to a suitable page before moving to filecache.
  *
  * In a future release, this may well be extended to respect cpuset and
- * NUMA mempolicy, and applied also to anonymous pages in do_swap_page();
+ * NUMA mempolicy, and applied also to anonymous pages in do_softleaf_page();
  * but for now it is a simple matter of zone.
  */
 static bool shmem_should_replace_folio(struct folio *folio, gfp_t gfp)
diff --git a/mm/swapfile.c b/mm/swapfile.c
index d12332423a06..40039586f56e 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -1568,7 +1568,7 @@ static unsigned char swap_entry_put_locked(struct swap_info_struct *si,
  * example, the following situation is possible.
  *
  *   CPU1				CPU2
- *   do_swap_page()
+ *   do_softleaf_page()
  *     ...				swapoff+swapon
  *     __read_swap_cache_async()
  *       swapcache_prepare()
@@ -1578,7 +1578,7 @@ static unsigned char swap_entry_put_locked(struct swap_info_struct *si,
  *
  * In __swap_duplicate(), the swap_map need to be checked before
  * changing partly because the specified swap entry may be for another
- * swap device which has been swapoff.  And in do_swap_page(), after
+ * swap device which has been swapoff.  And in do_softleaf_page(), after
  * the page is read from the swap device, the PTE is verified not
  * changed with the page table locked to check whether the swap device
  * has been swapoff or swapoff+swapon.
@@ -2201,7 +2201,7 @@ static int unuse_pte(struct vm_area_struct *vma, pmd_t *pmd,
 		rmap_t rmap_flags = RMAP_NONE;
 
 		/*
-		 * See do_swap_page(): writeback would be problematic.
+		 * See do_softleaf_page(): writeback would be problematic.
 		 * However, we do a folio_wait_writeback() just before this
 		 * call and have the folio locked.
 		 */
diff --git a/mm/zswap.c b/mm/zswap.c
index 5d0f8b13a958..db85ad97ccdb 100644
--- a/mm/zswap.c
+++ b/mm/zswap.c
@@ -1586,13 +1586,13 @@ bool zswap_store(struct folio *folio)
  *
  *  -EIO: if the swapped out content was in zswap, but could not be loaded
  *  into the page due to a decompression failure. The folio is unlocked, but
- *  NOT marked up-to-date, so that an IO error is emitted (e.g. do_swap_page()
+ *  NOT marked up-to-date, so that an IO error is emitted (e.g. do_softleaf_page()
  *  will SIGBUS).
  *
  *  -EINVAL: if the swapped out content was in zswap, but the page belongs
  *  to a large folio, which is not supported by zswap. The folio is unlocked,
  *  but NOT marked up-to-date, so that an IO error is emitted (e.g.
- *  do_swap_page() will SIGBUS).
+ *  do_softleaf_page() will SIGBUS).
  *
  *  -ENOENT: if the swapped out content was not in zswap. The folio remains
  *  locked on return.
-- 
2.52.0



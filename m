Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0E299606A31B
	for <linux-mm@archiver.kernel.org>; Fri, 23 Oct 2026 06:35:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=bytedance.com header.i=@bytedance.com header.a=rsa-sha256 header.s=google header.b=YUNX+93e
Received: by kanga.kvack.org (Postfix)
	id 21F1D6B0AF4; Fri, 23 Oct 2026 02:35:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1F6E16B0AF6; Fri, 23 Oct 2026 02:35:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 134416B0AF7; Fri, 23 Oct 2026 02:35:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id DEC506B0AF4
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 02:35:06 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id D3834120293
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 06:35:04 +0000 (UTC)
X-FDA: 85352928528.28.0C129A9
Received: from mail-pg1-f181.google.com (mail-pg1-f181.google.com [209.85.215.181])
	by imf18.hostedemail.com (Postfix) with ESMTP id D681D1C0007
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 06:35:02 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=YUNX+93e;
	spf=pass (imf18.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.215.181 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792737302;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dMWdlBhmxnvLIraZEDjRljS62kPMNDcGFS9KF9CUDaQ=;
	b=AhHDBywCOJJeU2HgktKuxL6BRY7+2K2CaeqCRDtBO3RXYLuA56Ldz/noKfJZ94vjNNZH+F
	5+XEfIUmjzbK9HLiHCEIG1AlcKEANzCMAxOU4jezkHf20SI08mrPuGoqWScZR5hDYBl1It
	Dc73MtyE5eCX9z5kVV9kGBm97RDhAOk=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792737302;
	b=T9eA/fv24vA/PsFLtxaBBD19j0JR7racx0Nnt6W5MLCw+1Qu3OuG31UAIrSol7XDgxJe3R
	1+gDJGfhaItmkncBfmK4whiqzxwZrD0TR9x3LkasT/Wpv/VzqmEQCyzw1176mapaWOvRND
	rIVNE8gCuSWrfYmPOFt/Kuztd2BBIms=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=YUNX+93e;
	spf=pass (imf18.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.215.181 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
Received: by mail-pg1-f181.google.com with SMTP id 41be03b00d2f7-cd623dfe420so400942a12.0
        for <linux-mm@kvack.org>; Thu, 22 Oct 2026 23:35:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1792737302; x=1793342102; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=dMWdlBhmxnvLIraZEDjRljS62kPMNDcGFS9KF9CUDaQ=;
        b=YUNX+93eJLT7cU4gpb40Y5VtmBtbaUsLSl4Gackbo9neRdySEz7mznlRzTN5/i9AGC
         7kFbQuKNq/ifvt+od1L9a22tBukJpV9FXxJOefeq3e4fuoKVyPYX2tTbhPUbkWASl3SX
         swrxoisi4PpRaFWSn12No/r/qh5hMGuzFctcBXoqTa2zFsngvxv7WhYytKxULW8V91h1
         iOMuk89CyJ3+ZDoGwViHT6BkVkpRqd3lHx2qZ8yI5LGXJjFL3n71qgmiPRxGiHijoIGr
         xWdMmQECPKTr0GGo6cOWnm9zhRvJ1C5306Oo/TA2Otz0/ve0awRUrxT2JRgeI92VvwQ6
         rS8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792737302; x=1793342102;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=dMWdlBhmxnvLIraZEDjRljS62kPMNDcGFS9KF9CUDaQ=;
        b=BsOS3Ris1FqwebWViq83zfCbrWlTZ/lyVYlIxMRMGoKTOHaHPPCwcnL9yHnR5MtV7e
         zc25d+BucZKnL5sKuF8CbEXmpr72EXaOFNQHHnrV+Ot9gsqG7CPJ7BkdOp/HKkbuPBbF
         01pKNI8eFCWyagrGzGNkenGUX4TynyjkAit+YqGZgK/fqoXQI1oSpqW/PruxNJRPRp4U
         qgIWEXp6XboP7WbR0mzTbhfUPqzk0dzCEnk5r+vRtYWUstgT0jgXWSnuKVm5Non/Me2/
         nOQlmT1GoBjgYzKR+DPo+//pu48LK+cdn13cStCR84MN1aeNy8TF40uwiNcyRF767eeh
         bPNQ==
X-Forwarded-Encrypted: i=1; AKwUvBwhY5Jqyna/dyYzvKua3p5kPIuiRgU4BMk4LG3pv5rJqWFIv8n7q+g0ih/7JAEQYSDsksWv3xqf0w==@kvack.org
X-Gm-Message-State: AFq9FYLTzkeTIVZwdpu5mmyCuCL0D700/9RCsAK7P+jjRhEzX47xUdsQ
	zeNz1xJYSB86UeqLxAizdHamWcbnqwlmp36FWBgusxGUFBrLbfYEZMWjGBr8XaxSz3Y=
X-Gm-Gg: AYBFou0+dfRCLUVg82OsXoGIkrThFoXC+Zwq7vxARjTNpZKh9OLFobsiApdqw5J2n4s
	EmeFOYRYRsFC36LhM4sX56dFd7PcPSaM+zj7SeIXvXDfxkHcvXcaxZWtn9bmcHItsWBQ7V2eBVO
	xfK5a7XuwQKF/qm+1sJfV6ItGsuCmRrUSrZsaJoI3rQRhTSd5mgmGRC5lbvGQjQxc5a+LTCDkJt
	rI0wjy9ZDuB2URvcfyOMOtHfeKjvdufC+jOvV3aXo4zPRLw3KrWhYIDMkSWxTQC9NxFjCdgwEBz
	T/Ukn85KZ6eBm1VHzbY+kV7W5zzY8DwefuwiQFHqcJkEzI0vswriAtolhR65SxFIDXapzh9zlyM
	LITznptviCmAvErafAdpEXPmyoH59iPQaWpVMNsvDcuR9wqQD5fODiND8Yku24kCkdAFxGqy2HY
	X6NQ26BWoq6umEc8O/yh8awFve5Q2EKGZc52XoP6hmAOZ7VOxwwTPvEuRwuST0oi6SVIOkxs2Fy
	JgtrfGL59vv8PYp55FHEVzVrXqjol8TFJxWe7nPW2r+BOGPEwA6Li0cmkjMsvcVrHBIoR87elQq
	ZhwCipwnElCxW6giaqIK9II=
X-Received: by 2002:a17:90b:33cc:b0:3ac:7556:8eec with SMTP id 98e67ed59e1d1-3adce0ce647mr1174819a91.39.1792737301360;
        Thu, 22 Oct 2026 23:35:01 -0700 (PDT)
Received: from n232-176-004.byted.org ([36.110.163.103])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3add246f308sm575202a91.0.2026.10.22.23.34.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Oct 2026 23:35:00 -0700 (PDT)
From: Muchun Song <songmuchun@bytedance.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@kernel.org>,
	Oscar Salvador <osalvador@suse.de>,
	Dave Hansen <dave.hansen@intel.com>,
	Paul Walmsley <pjw@kernel.org>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Albert Ou <aou@eecs.berkeley.edu>,
	Alexandre Ghiti <alex@ghiti.fr>,
	=?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn@rivosinc.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Kevin Brodsky <kevin.brodsky@arm.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Alistair Popple <apopple@nvidia.com>,
	linux-mm@kvack.org,
	linux-riscv@lists.infradead.org,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org,
	Muchun Song <muchun.song@linux.dev>,
	Muchun Song <songmuchun@bytedance.com>
Subject: [PATCH v3 4/4] arm64/mm: fix destructor for unconstructed hotplug page tables
Date: Fri, 23 Oct 2026 14:34:28 +0800
Message-ID: <20261023063428.3658761-5-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20261023063428.3658761-1-songmuchun@bytedance.com>
References: <20261023063428.3658761-1-songmuchun@bytedance.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: D681D1C0007
X-Stat-Signature: r9zqcuz3q4bcam93mm6wabqutf5nu8ds
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1792737302-443648
X-HE-Meta: U2FsdGVkX18cc0z4xNC5hufRm/ngJaVRc1Pltx1DxA2jH/AcfErG/OtLTBJJAF95mQCGG3/3RdqetFwX97lFocD9GzM9kKlVnL9yoJiqkV9I19wE7NKknUA3Y0XjnhUIECvJ9p7iEkOi4rVsNpPLZ2wt7u/L5M98lHt2A3bd6ucE52gOADb4teMnfUUvGyiS1Oq8yuWpbhw4oF0B3a/Xrdq6QGY3AqXZBVKrC+by/ab4xY/ExZdRQ0iAfk8CGFV96jBG2eh4owidgVOjliHx+U7o1nO44KpQNeJ7GElezSTt3Vlu7vCClVWdoBRr5gf2U4CC2qThLECvCVW2fgP4HppDZYlJxMJkSRBDA40XuCIEayXEeO5KArvanZ1aWgKvPp0P5UVR6kN3/wJFbDvTMYHDDHh0p/ixclG08prx65LjgEaYABmcMOZS37cliUdUbCsgPXX1+hEEpCQDXGpsaHdhtu0U2aUYA+h4MQQlMCQHMEwNDWDr+K3kjPKkLAaiG/vg+R9xalPy6lwkyMfx5Rfd1CSC99wktN7J6yvq/PsARezYI9Aqyahp2o203Nqe2xHQ18E00jKZQNQS5tXucUrkK/zFFdDpquMbPmYpiZAY4W4yX5h4ldm0K+GmWgzVBOClV2L9Uc3J/3OMn3Ze86vdnSLFb31ZGxMOfhfAyPv4ygtd5jsyh14dQrxBQT5FPDnbzII++AGnZDpxtZvi0DpM2G4Xd3Ly3LZDoUPiEy/t4Mz7qFH2xxcpehRoCigXc1+Xk/pz7sSddAaxLLGKUWliu5XZ36+MZviEe6kJzMIUMqdfOY/u6BMkSEGROT7ePVa97qiB38G9UnNd47MejSVG+zt7jJSjITScykslloNKjdljqLFzT/7RRl2ZHl/a8Ogb0+4X8gxptk3pz4WfLlnyOIIdehr5TkzrpWKW3YRW+RVU1Osb8BETRNP1fcq6XFI/qYAJdKYWMZbWDGr
 6vFJOiKE
 WBeHwELZF8sxmjIhqsj9CJo86Rb5rBsOoRUpNosbrWnzEB0Xn8FggFTaFBU9it8/Xu40n9xUWRAZPTyt3tImny6QA/mCBb2vZ+dKPVZ0O7PVt7bY3PlZXrFHjG0KiMWDfRcAPYTYiNVuzRljU/bEHaOcuYXmmgkFKzOTdQB+h/JB6V0vEWdtaDRX6z7AHDHMo3icsDOZ72opOvsxh4si15DrM2K2Mj9tAnTSnyxw6Pzv+E8v9rF7wTSufoJya08wv++ReH6qPD2INhRFSiatsxrDXuY+DP5iDU0pdgs5TG3xfBx1ocxCHA9PwkR8juYUWjpSEKVgwXL1fvwuup+5TlQ4dJDdvTnUIrxgThJY8mu5h8e0Xj3WFGPJSu5bLcEIsp16HMzOJFEhv/z8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Commit c594b83457cc ("arm64: mm: call pagetable dtor when freeing
hot-removed page tables") made free_hotplug_pgtable_page()
unconditionally run the page-table destructor. This matches page tables
allocated by the arm64 mapping code, which runs the corresponding
constructors.

However, arm64 also uses the generic sparse-vmemmap population code.
Runtime intermediate page tables allocated by that code do not run a
page-table constructor. Freeing one during memory hot-remove therefore
runs a destructor without a matching constructor and corrupts
NR_PAGETABLE accounting.

Free intermediate page-table pages through pagetable_free(). It runs the
destructor only for constructor-backed pages and then releases the page
through the page-table freeing path.

Fixes: c594b83457cc ("arm64: mm: call pagetable dtor when freeing hot-removed page tables")
Cc: stable@vger.kernel.org
Assisted-by: LLM
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Reviewed-by: Kevin Brodsky <kevin.brodsky@arm.com>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
---
v3:
- Collect Acked-by from David Hildenbrand
- Collect Reviewed-by from Kevin Brodsky

v2:
- Free intermediate tables through pagetable_free() (suggested by David
  Hildenbrand)
- Update the commit message for the page-table freeing path
---
 arch/arm64/mm/mmu.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/arch/arm64/mm/mmu.c b/arch/arm64/mm/mmu.c
index 79d90226fd5d..4dce8fa227c3 100644
--- a/arch/arm64/mm/mmu.c
+++ b/arch/arm64/mm/mmu.c
@@ -1495,8 +1495,7 @@ static void free_hotplug_page_range(struct page *page, size_t size,
 
 static void free_hotplug_pgtable_page(struct page *page)
 {
-	pagetable_dtor(page_ptdesc(page));
-	free_hotplug_page_range(page, PAGE_SIZE, NULL);
+	pagetable_free(page_ptdesc(page));
 }
 
 static bool pgtable_range_aligned(unsigned long start, unsigned long end,
-- 
2.54.0



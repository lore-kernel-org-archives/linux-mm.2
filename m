Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D4AECCA6004
	for <linux-mm@archiver.kernel.org>; Sat, 10 Oct 2026 11:26:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D2FB46B0099; Sat, 10 Oct 2026 07:26:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CE03E6B009B; Sat, 10 Oct 2026 07:26:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BF5CB6B009D; Sat, 10 Oct 2026 07:26:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 9D1CD6B0099
	for <linux-mm@kvack.org>; Sat, 10 Oct 2026 07:26:28 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 2E71B4056A
	for <linux-mm@kvack.org>; Sat, 10 Oct 2026 11:26:28 +0000 (UTC)
X-FDA: 85306488456.01.FDC53E5
Received: from mail-pj1-f43.google.com (mail-pj1-f43.google.com [209.85.216.43])
	by imf25.hostedemail.com (Postfix) with ESMTP id 36769A0002
	for <linux-mm@kvack.org>; Sat, 10 Oct 2026 11:26:26 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=iTRMeiXe;
	spf=pass (imf25.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.216.43 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791631586;
	b=ksQq+pMxZ3QgrJghpyKVstVU9BjN/lDy4PRX3avZYb/bUuPjzMOUkOKz/NRCQZaPdEmNXK
	1ZhURBy0g7eDDmuSwLKzYHp0sIBjgIQq3R8gPVmbZ8F6vGa84UHmrZRdG9hgMNlqHhPOwa
	0/o5CMxdxkFixgcuPbowGoLyOesZHmc=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=iTRMeiXe;
	spf=pass (imf25.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.216.43 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791631586;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nwX2V/6o0Kptw/VlXJ/4Jp9bBaiXMijAHR2YrE2LL1c=;
	b=14AnVz1EvIp3wYmlkXL96su87x7ZwOTaILcFOOhkEUGSj3zS/cqHC+hH2m6JSNfEeUIb4I
	v9E8g53x/40xIWHju51mZ8Un02UjMWyVtNqe7tLTYAEn3RenG03Mc12oBFhqwrYusIOBy3
	z+EvgzEBYl4gRvg3w2j8Dz5a2hOWooE=
Received: by mail-pj1-f43.google.com with SMTP id 98e67ed59e1d1-38759bcd877so274492a91.2
        for <linux-mm@kvack.org>; Sat, 10 Oct 2026 04:26:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1791631585; x=1792236385; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=nwX2V/6o0Kptw/VlXJ/4Jp9bBaiXMijAHR2YrE2LL1c=;
        b=iTRMeiXeiAQJJfuQaTEk5c6RHdnBtfhlJjvGNP+GnLNhsWhkelYJxVh1y2zpTCngta
         00k3mUh2Uee0YroPug2cFP0sLQmEBf37I8S9Y4ptWVV5Nj/5mI456f4iYeJ55UEio0Qm
         9kjgn2OJcaf80WUYaY4+Gz7deAFXQNZgktRXw9bJyJh5qDGdhATQM+lHc1lHcTwbGxBZ
         JOpX93gtqhfwoPv7BSpJSuQ75gWd/XIMSyCqGBr0DODyB155keHIEbzAJt/OxgM/uxaC
         x9tBj2cxA7rn0b6roiyHKfnsjqCM94uvUoOVRAMciR6xr9h2oVVXwz8b8ZVwv0ali8U/
         eGZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791631585; x=1792236385;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=nwX2V/6o0Kptw/VlXJ/4Jp9bBaiXMijAHR2YrE2LL1c=;
        b=1LEWbR7XR7QumYq29G6U1dObY0u3L4u6C2fhzPciiAL99idpzMSXxKSCULuMCk1tye
         Y1rsw0iXSLwR3wq5KBJR0+IkzjkzWBfZyjNUAzrNgo+pXhPNSvR4Je3gflJ5m1eb5QDb
         kbVWBu0UobHJZ9ozuF7xBXbsqj0WQRgOWX1vabmPwrSt4p3FFCv3WIT4Va0IbZoP0HnV
         Fnmeev8eAqLt1FplWzmklftyi89629hF3WLT1f8yp8BZzQIdlWOUJpO1oqslR4J+mtm5
         rkihUsjcpdtQOedQN1LXYdPo67kck58dFFvZJ6HuFeDvx0S5sRI85OUTJoWOc6fZ8O3v
         tEpA==
X-Forwarded-Encrypted: i=1; AKwUvByF6KedURc+LdkV4kyYI6HnhaCuDXhPjqj8JzBpaLJji2UmaHVrvC++lmpIqQyX6Gk1P42JpfA/0g==@kvack.org
X-Gm-Message-State: AFq9FYLHNvY2qnJ2VXyLdrh/hHlHY8luapMl4cXEfnnq1+I7bFrALtXp
	Ya4xiotQI2zp+arBpfg8XGHyJtjfVZ+lTXHlwUcVqKxj/3YSjf6XXrgNlJLGhlpk0rk=
X-Gm-Gg: AYBFou06H/iczh6VQScYUiM2ZiFw2o3vsHB/kEAJw38TWXz+4PhzyE2ttQWKyQcz5qV
	C+uWX4GIN072qVIw6hZsWxqn24G8vsVQG+gGJpzmfayx8J9qgqWh9gavd98bNFBHYRu2ZIZDMuy
	dCeuYNlAlSwwUvhIWrpKU1MVYRPKbHqtuw2h9mDQq6PMgN1ObQ4OolAZvvAK2K+yv0UsG0M38Y1
	OcKm5l938JdWPm60+BQMvzS6y0zwOVdVhemZcHxcFKgAW/Oth39yrh3bh9TqnpsIbWX4kKg+X7P
	Dfu8DIZ7rWRBBVMJUra/zSi1XJ0ZBhRzPKoQCL2qKwc8hh0MP7ybB/bnEz1zbs7b1kYE+zPZp3o
	3PRypPsdGmwTlkou0BJopGysQf1oVHjZAQjL/VN+7hV5aN9UOVxzqUbEolpQEIkWINOtA4ocyfG
	2fGkD8uvFLQ0DHk9cfv9mTEldVDzTLWCVUuiJ4S7Gy1HJKEhWYhzCBmqOQ7ZLEu2nSpPEP/Nzo3
	X0VVBcE6Ktsu72icvT33a/T4gsj/POgc8gPMg==
X-Received: by 2002:a17:90a:e7ce:b0:3a4:ef4a:4f12 with SMTP id 98e67ed59e1d1-3ab3b01ccf0mr3608742a91.61.1791631584895;
        Sat, 10 Oct 2026 04:26:24 -0700 (PDT)
Received: from G6L4RL2QG9.bytedance.net ([139.177.225.249])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3ab3690474esm7900233a91.0.2026.10.10.04.26.16
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Sat, 10 Oct 2026 04:26:24 -0700 (PDT)
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
Subject: [PATCH v2 4/4] arm64/mm: fix destructor for unconstructed hotplug page tables
Date: Sat, 10 Oct 2026 19:24:57 +0800
Message-ID: <20261010112457.49485-5-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20261010112457.49485-1-songmuchun@bytedance.com>
References: <20261010112457.49485-1-songmuchun@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 36769A0002
X-Rspam-User: 
X-Stat-Signature: 5xcphpi8ii7kwd1bikbtidazpm8gbk5i
X-HE-Tag: 1791631586-508393
X-HE-Meta: U2FsdGVkX18vJjUYMW3DNcaZt7PAQotxDnoIzNeApt6QO8HRyj2U8mHvTbZ3JDxZVxUT4YsYVnjFKM10P2N7X+dbl5fd+/6oCdwP90iA51JnFTrh6E2Ep3uZSQVPhi7UP5ZOeiaIHeZ75SU6lwDIE2QAX5Ddc9XVY2USIVaMTq7Ag0GFqZHf+pwoeNaHzuDlRsE0LU5rGmCVA7rNdiTQXy0bK9OQrc1BjwePBa/b8e6+XO7Syk77o0s5dJLg/sc891ZkhvGpXDQvu3+/LE762F5wVvvQqqQDdWnoOq0xR10iqAIZv320PzVBAXzmPj3rBAGpwOfs6Abg0mTyWU2ixghHbTay8jHUXo3J4XW9ZaUEsTt25IlbTXR2pmOclh3mwcF0HH7GE27nPA2zwGH6XAwu50NrXMLWBkvK5IEjktlr54/7YLTKtgP/l58XHD0pnJmYdkMZvuGoH5j+Vg1E1iXI8HwoK73zrwCJvZZfiTrpg8r4OKnc6tpReGbWKDs/dUf7tkkhDNywAtRG/bE/YBVoBvGtmr/T+pTLi4RPg3YXPUQTS4xEzgxxLObkd853rcLve1T0Uoi/fLUgSsHd4bq7ki4o4lstUgmPwRnqz7C+v/OrI/l4S1kpjsYsRkx4TS6XjNHaZAa/P01OqmjhGuLgU/KUXFiaJOwJap5C0kFIie7cx5tM1Jrp5AjfXq69aPESLuossi4fIGYVF/SCJYtrKrr3odVul+ePoqXVgnr0m8dElJ6fU2ApZj4dodPwSqKNTRH8ZGWDjrj3GmxrF/NnKD8KYNwh5HqzYOuDmD9zC1wFAAYa69/rU6liRzEPlXpbc7WeaJ99VkydOmyDwQVYZdFabSU9Eql37/cLx8skJICuBIx7xwrJJ7VniGm+1oT/peIV4Jjj89rqVhvskFOTVwOzlZOltHDKx9GvmU5jFvBTvKnK0aD0HBcht+CW+Nh5ImND1hh5komjvCF
 nDK5alnk
 T2DQEvOfNuhna+HcVphlWyi5ppR59FUKMK2pAeIMVWzupVbMOyCRBJTmFmFBNpjGf7ZO2jaq6A0a9zXasmGU28TewU1OF6P+7PQ11rc+b4dt7clgjhCppTGEBZjW81P2w85sJUkmDVGOZBbAxjTHw3NgiAY0ir1dOu+uHaO8tB4FLzlJ730SQiLSH9r+DFAZxdf6dEbRb76M3XdRrt6ktDIkn21ez6CCW2MIEcrvW6za+aK4GQ+XwqRGssbKFGcOC/yUU6ENWTDu+nrlSaXmxW46zNiKuQQ205DlHF3B6bAfT9uJwufJf+obR1cQ1LyDGf+vCt7G2Rgcj+cA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

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
---
v2:
- Free intermediate tables through pagetable_free() (suggested by David
  Hildenbrand)
- Update the commit message for the page-table freeing path
---
 arch/arm64/mm/mmu.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/arch/arm64/mm/mmu.c b/arch/arm64/mm/mmu.c
index 7343ac9294f8..26a8c665ae52 100644
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



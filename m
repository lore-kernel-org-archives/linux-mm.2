Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2115EECD6E0
	for <linux-mm@archiver.kernel.org>; Wed, 11 Feb 2026 19:52:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 839D76B0089; Wed, 11 Feb 2026 14:52:50 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 80DA86B008A; Wed, 11 Feb 2026 14:52:50 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6D22F6B008C; Wed, 11 Feb 2026 14:52:50 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 56B1B6B0089
	for <linux-mm@kvack.org>; Wed, 11 Feb 2026 14:52:50 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id D9B145911E
	for <linux-mm@kvack.org>; Wed, 11 Feb 2026 19:52:49 +0000 (UTC)
X-FDA: 84433223658.28.E3E83BF
Received: from mail-dy1-f182.google.com (mail-dy1-f182.google.com [74.125.82.182])
	by imf24.hostedemail.com (Postfix) with ESMTP id C64A3180006
	for <linux-mm@kvack.org>; Wed, 11 Feb 2026 19:52:47 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=UnWs+rmR;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf24.hostedemail.com: domain of vishal.moola@gmail.com designates 74.125.82.182 as permitted sender) smtp.mailfrom=vishal.moola@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770839567;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PW0O7GWcMWLn2TYy5yKCekih8BmMZppbzDUWkPTzKZs=;
	b=MijcOqZi1oH8ustjQsp13rAp878kLGhZOsG0gBKerJN82owNAH4ZUFklWHEsWt8ypEAG7f
	CJHfDPuSkMpJ3cS01flR0ZAFJtl0Kn2WCbORlJ4bmdmSfb2KhwFZ+F3QfgXj3ZZqVG6tsh
	M1tHJNwjDOEtKCdraVX76f4PHp16oxE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770839567; a=rsa-sha256;
	cv=none;
	b=kv84mIvQQvL+JQf5ZD9X02nE+VtSQ2uwKn0SltWk5DH5458EtChKCedWEuNkLJKeeJgdZs
	BZfyMEtT15QljtqoaRDwRGvdF9HWg+zEIQFRyzCxNbiuU26/z0joxQdnLB2NjkOr2yEKG4
	el7bi/gkKmmkteq2hhH796zoPfC/+cY=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=UnWs+rmR;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf24.hostedemail.com: domain of vishal.moola@gmail.com designates 74.125.82.182 as permitted sender) smtp.mailfrom=vishal.moola@gmail.com
Received: by mail-dy1-f182.google.com with SMTP id 5a478bee46e88-2b86671f87eso483443eec.0
        for <linux-mm@kvack.org>; Wed, 11 Feb 2026 11:52:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1770839566; x=1771444366; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=PW0O7GWcMWLn2TYy5yKCekih8BmMZppbzDUWkPTzKZs=;
        b=UnWs+rmR4VMKBXvvss41HF6hqCcr4GP8JET/V4OzLQf2bCYh52wDVkocdwdkYe8MXC
         o1JZ1yo9BE413pyOXHiFlMD5hrcslN9hTnWIzk7h8VHhEZ0HZjlCMWW1gnUZFXDmD2Ep
         eJR367j3LSgbcK3kuI4XCVlzLGjIivVI4+qUJ9oFWcIx0UucJSPiAm/vJKMYlHReCdgS
         LXKSB4uK+uiqAzX4YcVthGFsd+2HgD4cOiB+16346HvGEs1+rJFkSi+P3jbmw4oZy502
         BQ2i38kSBYFrPvT5HXrojT/1v4fW8NJqJNaAOekwrTSCuLqUbtF4x5DN0+daG6Wz3VD2
         SqVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770839566; x=1771444366;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=PW0O7GWcMWLn2TYy5yKCekih8BmMZppbzDUWkPTzKZs=;
        b=hwL0Om6D1YvNQ3ld9FyestAPcnRmyD6wWET19OZ4CsOX4ey0ASgjHhesLEj+GAuGYt
         ph0E+WDk7qNIlRMWX1RXlUyFvb+IHuRFd1YmTjT7IFNc87HzgAvJs+eM/JZ+PkO7PmIy
         LZTgXALtpe0gCjKPb84lqdbWgO9MNO10h2sh3tAv7eBxTZc7E0dBV8slE8/yjv69y5Xt
         5sN9bQhObRAmgKYt5UcdjC8zEliNQ3a5Nmz8v1HrAUPdRqSBbk+LzV5GCX1F1I+fR+Qs
         HEjEz7pdjC3/MWGZTGdDGlj/iCO8ieL/x77qQKl/ul7nz0/TCPx2TIiCfjSVBVEnC+1H
         aZBQ==
X-Forwarded-Encrypted: i=1; AJvYcCWhwpAK/jOKq3pBqkl3yRyedlWNJVjskFksw9Gdq6spLf2ULMpHgw+LGXbYZhR7TxkzJXcKSHrNQg==@kvack.org
X-Gm-Message-State: AOJu0YzqJlw6bRkPKc3LNX/g20QoM4njc3/1UQrXdAek/HC3jnCzYmAA
	iLrP5ST47a/Cqg4dI/uEC7zdMB2yuZsFWGnvcrBla/FT2wtlEq0ZP1Gs
X-Gm-Gg: AZuq6aLg8nkwcOsB3+2on02jStrjJ0O7HngIt+OGT0YQMj0pn5vshRvs8ljuEM7F3a/
	gPGFjaJOo3iqVQk83XkcooEGioX0pMAMez1ermf8V1M9hSxLY/atWxRZkNV/BKpdKdYIJ9faqGU
	0yokPEk974x0HYTnbawAJhZFd45BJ+awoTp5BP65YXAMBJuCr8pGPVp9A/uewhgRL78unvaVuCK
	CJzvSabis0RTqEInHcZK8dwvBm4121BgrDrJJYHzduwOb7UfOpBBbap+wvt3cLqhU3ieuHWBjbA
	Z3sd+XJbJPpBG+PP5+XCORxgGkohZLSpoCw4RumPGd2lnxc7onWd9IaC5UXuWk54bpnksJcT2Z1
	s/xWG3zUlD9o/aqZTDd3tAbC8gxatsES4J1ghV6vvH3til8I0mMMY0XaJ2UNsIuYtwaTiuDlUHS
	Tl3CDKySfXvBcACI39bAg3HfPRUYFqzMMyQzx1oxH4LXcqLxeL/ctXcUrsn0LOCHT0/A==
X-Received: by 2002:a05:7300:7ba0:b0:2b7:12f8:5eea with SMTP id 5a478bee46e88-2baa7f682f7mr297764eec.9.1770839566550;
        Wed, 11 Feb 2026 11:52:46 -0800 (PST)
Received: from fedora (c-67-164-59-41.hsd1.ca.comcast.net. [67.164.59.41])
        by smtp.googlemail.com with ESMTPSA id 5a478bee46e88-2ba9dcfe6b7sm2426463eec.29.2026.02.11.11.52.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Feb 2026 11:52:45 -0800 (PST)
From: "Vishal Moola (Oracle)" <vishal.moola@gmail.com>
To: linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	x86@kernel.org,
	"Mike Rapoport (Microsoft)" <rppt@kernel.org>
Cc: akpm@linux-foundation.org,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Andy Lutomirski <luto@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	"Vishal Moola (Oracle)" <vishal.moola@gmail.com>,
	Dave Hansen <dave.hansen@intel.com>
Subject: [PATCH v5 1/4] mm: Add address apis for ptdescs
Date: Wed, 11 Feb 2026 11:52:30 -0800
Message-ID: <20260211195233.368497-2-vishal.moola@gmail.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260211195233.368497-1-vishal.moola@gmail.com>
References: <20260211195233.368497-1-vishal.moola@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: C64A3180006
X-Stat-Signature: 1hmteafwf1jh91bta3w64fz8ehh39qiz
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1770839567-844464
X-HE-Meta: U2FsdGVkX1+mM7sEC4DpZGeCrIbhbo7LSjdxhlBlxf7oGXe7KCT/oKyAvQpiukXesdd2qi/HQpyHjjbK177hp9rc3WDEaarmW2mqj7eql/Udu6Z3OkTCnrRSuaxIFC67yyFCnff4ySUiHQwBuShxnQ1206egphEv8TFwMz6WJMk3zPZjaAOooOhRmAZ+o6hs0+EzrbnZBa+J5xMnf1Kwa1i5OAOQGSK2FvDZEeiltBM9JYqYI7A4Tt88RgV9jhklmFaHSssVHZFj8rjWLT1JUye6qFwqtkyTv51Xy0aQfdynEVaHbaWwaCctB3OSrl3UbekBGFjVhDBSssAYiFH9HS6dB1CEwxFA3lRDNwSQ2J7LrCDxuCJHIMn/mBY4eNzwDHdUujhqpTtDYpWS/MYgmVYuiW8F9puWw7WpisEtYOY4TyKkzpLba594DKYZAFDtifMRpH16MyhKry79TQQGhXHJlpcmA1uDQZsfNjryPbIOcD5VV23F9oQgBjLyfJu0wxohS9ApYF7dGT6Wi+Uy5p9sQi6dOajkCdG3T1/diHxsLD83OgZhUsJyKvorAuqMyErXNTwZU6+Q4/zZsLkCrQKZMqVf2deZ8tXspstzoUZWH/3eOm1zFizn271UK9PHbZzORlriAdhBd5g4nS3s0d8KSicdUGkMadIRTaUg6FjQO66MXt1mPU3Id/NYDqd+F+0aQjhMNj2zDf5uVQKx7K95q4cqc54AVMzitjHiC4ff7GISKxbWB2h5MhedPSKo1oBDy/WtY3C0csjZDI4c4YWD+NUGceS1uKXR0i5S0VD6mEITfiQBG2TBawUsf4pjSnqZeea714P/IwqmAl6lSU7Zdgj4i7h3DC8JOHUg54PKCLMKrASYvYukkrL8gYsYeRO2V4tTAYYUq+KIIZCb4ICFk6o2NXUtF4CAagmd/equu5qDm9cTSLDatJ+U3Mmn74ujBFlSQsNBdXGD4DB
 atCmajip
 bT1M3BZuCI0YBoqi0OgadXcaPP/1XuL+E3d0Z3ElyJPbUQ0cRwHYzw1fVeYwQY5a+7hjHYXyyLL0hrUnO/I2R6ToBHafuePJdObTQTGkE4WCZD3jIwbLhb1aPJiUZ/d9uy63C30Lk07WJCxnrDBcvJAxwl9+dHf0fE7sTGqfPoOvGFNKgWUhXLWBIHn5/Uo7QE9aA5nbPCDVos0vvksM5ut3oYh/7FsnJ4H6edzOb/s/pCmm1AA7t7JaG6Qpp33Vo6hROanco4Wleb2KKXyux8HQu3Avy63tCcGHQkqEq6CTnJV4MA+1L2hYFf/PV3jaHeUXPdoOTvvbFR6wpapRJT5S56GBeERalK3u/69l7IsI9Bj4hfXXq6t70qak7jiu/ynTbWeRUDwsy7gboVEGtwSm5CYBlYq3G7cyKNd5SNCRLoUyi6pKbFkF2g+zJ+VBDpqc6oWL7srlLEZqKUwqEqyRNt3rZLn9N+hye62foe0ms3Rj9oJWVeK6wmWclbR+1XdDmX8dQQ7qxARUuQYiXnCrHolQeXRrmH339oeiqIcEALaLlxQl5mEBmSceyt6PKOPrMQ7ypfUfDiM446l+oJT7Sh1u7w2sX1opvz3fg92SVnI1G+Fd9i7QUeg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Architectures frequently only care about the address associated with a
page table. The current ptdesc api forced callers to acquire a ptdesc to
use them. Add more apis to abstract ptdescs away from architectures that
don't need the descriptor.

Add pgtable_alloc_addr() and pgtable_free_addr() to operate on the
underlying addresses associated with page table descriptors, similar to
get_free_pages() and free_pages(). Zero the allocations since
theres no reason to want a page table with stale data.

Have pgtable_alloc_addr() return a void pointer. This will simplify code
for callers since they all want pointers.

Suggested-by: Dave Hansen <dave.hansen@intel.com>
Signed-off-by: Vishal Moola (Oracle) <vishal.moola@gmail.com>
---
 include/linux/mm.h |  4 ++++
 mm/memory.c        | 34 ++++++++++++++++++++++++++++++++++
 2 files changed, 38 insertions(+)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index f8a8fd47399c..9b6d3d910990 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -3419,6 +3419,10 @@ static inline void __pagetable_free(struct ptdesc *pt)
 	__free_pages(page, compound_order(page));
 }
 
+void *pgtable_alloc_addr_noprof(gfp_t gfp, unsigned int order);
+#define pgtable_alloc_addr(...)     alloc_hooks(pgtable_alloc_addr_noprof(__VA_ARGS__))
+void pgtable_free_addr(const void *addr);
+
 #ifdef CONFIG_ASYNC_KERNEL_PGTABLE_FREE
 void pagetable_free_kernel(struct ptdesc *pt);
 #else
diff --git a/mm/memory.c b/mm/memory.c
index 1a26947ed8cd..b9653377d647 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -7452,6 +7452,40 @@ long copy_folio_from_user(struct folio *dst_folio,
 }
 #endif /* CONFIG_TRANSPARENT_HUGEPAGE || CONFIG_HUGETLBFS */
 
+/**
+ * pgtable_alloc_addr - Allocate pagetables to get an address
+ * @gfp:       GFP flags
+ * @order:     desired pagetable order
+ *
+ * pgtable_alloc_addr is like pagetable_alloc. This is for callers who only want a
+ * page table's address, not its ptdesc.
+ *
+ * Return: The address associated with the allocated page table, or 0 on
+ * failure.
+ */
+void *pgtable_alloc_addr_noprof(gfp_t gfp, unsigned int order)
+{
+	struct ptdesc *ptdesc = pagetable_alloc_noprof(gfp | __GFP_ZERO, order);
+
+	if (!ptdesc)
+		return 0;
+	return ptdesc_address(ptdesc);
+}
+
+/**
+ * pgtable_free_addr - Free pagetables by address
+ * @addr:      The virtual address from pgtable_alloc()
+ *
+ * This function is for callers who have the address but no ptdesc. If you
+ * have the ptdesc, use pagetable_free() instead.
+ */
+void pgtable_free_addr(const void *addr)
+{
+	struct ptdesc *ptdesc = virt_to_ptdesc(addr);
+
+	pagetable_free(ptdesc);
+}
+
 #if defined(CONFIG_SPLIT_PTE_PTLOCKS) && ALLOC_SPLIT_PTLOCKS
 
 static struct kmem_cache *page_ptl_cachep;
-- 
2.52.0



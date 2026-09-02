Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2530FC61DD6
	for <linux-mm@archiver.kernel.org>; Wed,  2 Sep 2026 11:59:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 327586B00D9; Wed,  2 Sep 2026 07:59:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2FFB36B00DB; Wed,  2 Sep 2026 07:59:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 215CE6B00DC; Wed,  2 Sep 2026 07:59:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id E60C76B00D9
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 07:59:01 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 76106A01D8
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 11:59:01 +0000 (UTC)
X-FDA: 85168676082.23.8A1F5F1
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf11.hostedemail.com (Postfix) with ESMTP id AB47A40002
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 11:58:59 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=bafAV6hH;
	spf=pass (imf11.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788350339;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3sCP0b9sOOcAdxX/GD49ZOurKEOX1A6+00HQH6tMSsA=;
	b=hGRDHUeHGpAiQmO5RzO7X1Z9Futsa1lFvfU6Ky/lkUUD50KaVNSC8i1eLLRRGBtfL7k3br
	pUpiHHzG7O0K7AvNjBOtfHUCr2iMAfX5EPRP2SrGQUCN6Kpzo47ZFsU7/XZnS6RLjCA7kb
	UHtGkK6O60Y2vCFJqHJPDHeIIwAav0c=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=bafAV6hH;
	spf=pass (imf11.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788350339;
	b=5yNGuLr3nS4qRzJisG8YYc4VPYv3FWhVZBX5D7768SQe30ogg/9qipfhqadZXCWqq5Ap+1
	QTt4UY4/AMt/JdKVCDGaOow3cgWYRZmja6t5gvHg030sMtXBxPexhKgwlSKVm8SmGluqLX
	KMeGUYyHPa1v/bDo2mrnpI/CpA79EHY=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 3E1291682;
	Wed,  2 Sep 2026 04:58:55 -0700 (PDT)
Received: from e129823.arm.com (e129823.arm.com [10.2.213.3])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id BB8893F85F;
	Wed,  2 Sep 2026 04:58:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1788350339; bh=tVsLkLa07A4zHI8m1tAgMomiiERETV6ZHmwKKYasnOU=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=bafAV6hHiMWf7UFGA2Jb1tgbVdcqzDWS6a4NkdWW3RSDN7omcp+MQvC85a47sP/CH
	 4AmzPQ2CiW6I0PTr+lcmGRlI3chW+Y8qNRmEJ/GXdjP+VVEtJXdyRwOER+zjM60QbL
	 i4BmSXa8lfT+QCHzh7jE+OXdMQsSLpM15Zhbg3fs=
From: Yeoreum Yun <yeoreum.yun@arm.com>
Date: Wed, 02 Sep 2026 12:56:21 +0100
Subject: [PATCH RFC v3 19/21] mm/pgtable: disallow calling
 (pgd|p4d|pud)_page, pgd_page_vaddr() and (p4d|pud)_pgtable with dummy
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260902-dummy_ptxp3-v3-19-5d8f5b17c25c@arm.com>
References: <20260902-dummy_ptxp3-v3-0-5d8f5b17c25c@arm.com>
In-Reply-To: <20260902-dummy_ptxp3-v3-0-5d8f5b17c25c@arm.com>
To: Russell King <linux@armlinux.org.uk>, 
 Huacai Chen <chenhuacai@kernel.org>, WANG Xuerui <kernel@xen0n.name>, 
 Thomas Bogendoerfer <tsbogend@alpha.franken.de>, 
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
 Arnd Bergmann <arnd@arndb.de>, Andrew Morton <akpm@linux-foundation.org>, 
 Kairui Song <kasong@tencent.com>, Qi Zheng <qi.zheng@linux.dev>, 
 Shakeel Butt <shakeel.butt@linux.dev>, Barry Song <baohua@kernel.org>, 
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
 Wei Xu <weixugc@google.com>, Johannes Weiner <hannes@cmpxchg.org>, 
 David Hildenbrand <david@kernel.org>, Michal Hocko <mhocko@kernel.org>, 
 Lorenzo Stoakes <ljs@kernel.org>, Tianrui Zhao <zhaotianrui@loongson.cn>, 
 Bibo Mao <maobibo@loongson.cn>, Anup Patel <anup@brainfault.org>, 
 Atish Patra <atish.patra@linux.dev>, Paul Walmsley <pjw@kernel.org>, 
 Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
 Alexandre Ghiti <alex@ghiti.fr>, Dave Hansen <dave.hansen@linux.intel.com>, 
 Andy Lutomirski <luto@kernel.org>, Peter Zijlstra <peterz@infradead.org>, 
 Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, 
 Borislav Petkov <bp@alien8.de>, x86@kernel.org, 
 "H. Peter Anvin" <hpa@zytor.com>, "Liam R. Howlett" <liam@infradead.org>, 
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
 Jonas Bonn <jonas@southpole.se>, 
 Stefan Kristiansson <stefan.kristiansson@saunalahti.fi>, 
 Stafford Horne <shorne@gmail.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
 loongarch@lists.linux.dev, linux-mips@vger.kernel.org, 
 linux-arch@vger.kernel.org, linux-mm@kvack.org, kvm@vger.kernel.org, 
 kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org, 
 linux-openrisc@vger.kernel.org, Yeoreum Yun <yeoreum.yun@arm.com>
X-Mailer: b4 0.13.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=3262; i=yeoreum.yun@arm.com;
 h=from:subject:message-id; bh=xhnn2pyfM9DLAHxbEw+j70fkBp5Hs9TfkBrZfLGw5KQ=;
 b=owEB7QES/pANAwAKAW3Vw9FaxTEzAcsmYgBqmA7qBnMyLZ0jKZbEx3DR97rH4+JY9IdCSD3OC
 ACU8w0jvsuJAbMEAAEKAB0WIQQtg+CS3QUzuFh1pJ1t1cPRWsUxMwUCapgO6gAKCRBt1cPRWsUx
 M1RlDACrNDx66AL+YlaceCy5fdL7utwGqmHqfKH4VSWSBKjq1xfzNL8PDRPqGW56m2nSz0oARim
 kR9d5Qen3Im7+xmbnh920AbeAyU1d+WW1h6jXmyptFSppLZDGhPesgf+Y3WdqDgu3gw0nG3c9Tu
 WU5E0d/FC72hOr8JAUhAJ9Dph9w6sm97I8Me0G+h/IBzGomkb9pVP+L4AuY9f7brkKVuRzBG6mv
 yLWWjBoEuzxGet3Swlt6wrXQtkblT5N/VCGbrkX+P79VNjv/NHlZ+8Iy7Rp8UvaKklrUTE/0o6/
 gjm7zRus6ux+diSIo8r+TCsBwZe70whQLrtgQz7acxhsCFWMq8wMXcNkSXKi1Hwk6kwZzqoGnBt
 q0i4gZzhOj7Ouhbuptq1nX5OXdAxNezenqC6qupYJUnLCBJwJ5PAnpwkMeDRv4Db32ENM0HtfSf
 N/kEaP+Gk6HX4bkAietsNqW5YNEMTF81R4dM0W/ru9ZfLn8tD6EWdADBsCIlah027kv/w=
X-Developer-Key: i=yeoreum.yun@arm.com; a=openpgp;
 fpr=2D83E092DD0533B85875A49D6DD5C3D15AC53133
X-Stat-Signature: dpa8yprfepk5njs9c4uicrwb9o4yi3s3
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: AB47A40002
X-Rspam-User: 
X-HE-Tag: 1788350339-903601
X-HE-Meta: U2FsdGVkX1+pS8tunX8ztozfh52uszywVXHaLVxK1doRYYeJ0na4e38nAShFD41ZQTY78xjEfGJq2V7J1b5JFJaSwSpCWn4phpaE2inSnnt4ipzNHQFdGU8OJ6Dbl+fRxVkpTyYJqPvYC5skhr5j4n2gQojX8xrw52l5xzeS57z//Pm6ghutuAAykZCT7Y+bdSY/qcF6+8nqZavm6CXzQTPwxj6Fpr3P/7dwaPCRFPRODvoAlrEc8XLhVjNy9TEnQGYPIfNtDq26mIYqgRSM9PgWhkNqj/+0XHGCc+uxZ5rXMAauJcn5NJp90G6s0Wnlc8ycxDGu6TsOirDyGXgDI7mj+GykYgVjvcPWkW2viSRlH5A4J0UmG5ZX8WPKyU7E67YfpcWp9s9JrUr6nb1LR+MyalWvGiF9oPga0kEpCx61DIwk60hG9rP//1nHMov9hNv051GOxQvJKtdhem7XWVXpT7B0L/8pjNguCnwEwDf/Az7m/w+nh+ASmGSN4ypkt2rop4OC7gw9R171kmM34IemdCvBAHjpzriuEMd+lDRIqwXCksV/N1aPpP8qMzz9btJbiFcm9HrfoHFRDp3A+vSF7E+r0j8wBqB6ACKIwWmZRy/g+tks/yior5ckVTfk9ZjI4jidKe2D2obISfHzepN/JlM20BFQ8zhUd0GuNhfVjO7/ThEpydYpVuHZHTE8ZCueb+GOhg+mLlcmyRkrKM4pBDlVRPgw17HDS5GrWohZONt4DFVl4lnByWIV3hW4JzSD8N5Sl/4kafk5Y4a/e+wmdLbUdW0Yvz7LcP9cqmNQJLsGbo/ktF9xgwEkFIEgPbp3FUeNPADXSnRuz3LgPwbzJSef0Vc59lZiSaGJL1c3HNkdp9JiTxQCybEjcA/Q9rD/xU/KV0xLVzct2cQZSEXk0R9geZzNjhqUwpbOyh4l3s4k75RUrdvA5xlXz4hkx12R2eTUU3orD6fUDxW
 iJc2BPqS
 3mSHa81JAofHL4f1uJMD57v5hEI//NRho1mi1qHh+za+059ogHGHR+kLlmRThNPg4tlvGVNMkG6pLf4Fqp/3HT/FbW6EPjwY6deF7R/zRH/L75xivOx+MoJCqkhiigYmrefedJ5unssSMN7RiPIIe04MIfq7O0Ybixi+YJ2a5ppvwJJyInDR3ImzFOKba2z+gjhhwqFjxyvS3O8zjiasX+Ov2OnBMYKonLpHsKDe/NoIXdPRvRyjckFwS9HmwepIKH8bLq9ipOvgGsMeycAGa6h1hB9T/z9Ai7TjIkBuWWsSajW1KllRWhMc6nmcntC0aRhUJH5o3r04yK1o=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "David Hildenbrand (Arm)" <david@kernel.org>

These helpers silently fallback to the folded helpers. With e.g., pdgp_get()
returning dummy values, pgd_page_vaddr(pgdp_get(pgdp)) will now behave
differently than pgd_page_vaddr(*pgdp).

Disallow calling (pgd|p4d|pud)_page() entirely, and catch when passing a
dummy value to pgd_page_vaddr() and (p4d|pud)_pgtable.
This will catch most abuse of dummy pXdp value at compile time --
so far there were none, and it better stay that way.

Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
Co-developed-by: Yeoreum Yun <yeoreum.yun@arm.com>
Signed-off-by: Yeoreum Yun <yeoreum.yun@arm.com>
---
 include/asm-generic/pgtable-nop4d.h | 8 ++++++--
 include/asm-generic/pgtable-nopmd.h | 8 ++++++--
 include/asm-generic/pgtable-nopud.h | 8 ++++++--
 3 files changed, 18 insertions(+), 6 deletions(-)

diff --git a/include/asm-generic/pgtable-nop4d.h b/include/asm-generic/pgtable-nop4d.h
index 2d86325235da..d2dccf7542da 100644
--- a/include/asm-generic/pgtable-nop4d.h
+++ b/include/asm-generic/pgtable-nop4d.h
@@ -70,8 +70,12 @@ static __always_inline p4d_t *__p4d_offset_lockless(pgd_t *pgdp, pgd_t pgd,
 #define p4d_val(x)				(pgd_val((x).pgd))
 #define __p4d(x)				((p4d_t) { __pgd(x) })
 
-#define pgd_page(pgd)				(p4d_page((p4d_t){ pgd }))
-#define pgd_page_vaddr(pgd)			((unsigned long)(p4d_pgtable((p4d_t){ pgd })))
+#define pgd_page(pgd)				({ BUILD_BUG(); (struct page *)NULL; })
+#define pgd_page_vaddr(pgd)						\
+({ 									\
+	pgd_check_dummy(pgd);						\
+	(unsigned long)p4d_pgtable((p4d_t) { pgd });			\
+})
 
 /*
  * allocating and freeing a p4d is trivial: the 1-entry p4d is
diff --git a/include/asm-generic/pgtable-nopmd.h b/include/asm-generic/pgtable-nopmd.h
index bd40d3a5743f..2afbf2d8659d 100644
--- a/include/asm-generic/pgtable-nopmd.h
+++ b/include/asm-generic/pgtable-nopmd.h
@@ -79,8 +79,12 @@ static __always_inline pmd_t *__pmd_offset_lockless(pud_t *pudp, pud_t pud,
 #define pmd_val(x)				(pud_val((x).pud))
 #define __pmd(x)				((pmd_t) { __pud(x) } )
 
-#define pud_page(pud)				(pmd_page((pmd_t){ pud }))
-#define pud_pgtable(pud)			((pmd_t *)(pmd_page_vaddr((pmd_t){ pud })))
+#define pud_page(pud)				({ BUILD_BUG(); (struct page *)NULL; })
+#define pud_pgtable(pud)						\
+({									\
+	pud_check_dummy(pud);						\
+	((pmd_t *)(pmd_page_vaddr((pmd_t) { pud })));			\
+})
 
 /*
  * allocating and freeing a pmd is trivial: the 1-entry pmd is
diff --git a/include/asm-generic/pgtable-nopud.h b/include/asm-generic/pgtable-nopud.h
index 7475d0bd0f2e..3264673c0c38 100644
--- a/include/asm-generic/pgtable-nopud.h
+++ b/include/asm-generic/pgtable-nopud.h
@@ -77,8 +77,12 @@ static __always_inline pud_t *__pud_offset_lockless(p4d_t *p4dp, p4d_t p4d,
 #define pud_val(x)				(p4d_val((x).p4d))
 #define __pud(x)				((pud_t) { __p4d(x) })
 
-#define p4d_page(p4d)				(pud_page((pud_t){ p4d }))
-#define p4d_pgtable(p4d)			((pud_t *)(pud_pgtable((pud_t){ p4d })))
+#define p4d_page(p4d)				({ BUILD_BUG(); (struct page *)NULL; })
+#define p4d_pgtable(p4d)						\
+({									\
+	p4d_check_dummy(p4d);						\
+	((pud_t *)(pud_pgtable((pud_t) { p4d })));			\
+})
 
 /*
  * allocating and freeing a pud is trivial: the 1-entry pud is

-- 
2.43.0



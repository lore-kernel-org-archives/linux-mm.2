Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EA0C5C54FD2
	for <linux-mm@archiver.kernel.org>; Thu, 30 Jul 2026 09:07:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B38E46B00A2; Thu, 30 Jul 2026 05:07:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B10136B00A3; Thu, 30 Jul 2026 05:07:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9B0BF6B00A4; Thu, 30 Jul 2026 05:07:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 62CAC6B00A2
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 05:07:17 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id DC425160890
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 09:07:15 +0000 (UTC)
X-FDA: 85044864030.17.4A2E4A8
Received: from mail-pf1-f172.google.com (mail-pf1-f172.google.com [209.85.210.172])
	by imf17.hostedemail.com (Postfix) with ESMTP id 0FB7540011
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 09:07:13 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=HpcPmVYQ;
	spf=pass (imf17.hostedemail.com: domain of xueyuan.chen21@gmail.com designates 209.85.210.172 as permitted sender) smtp.mailfrom=xueyuan.chen21@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785402434;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ObdtBSjlBwpgFGsbg/wrosB7LM91UtGEZki+/E5+WZ0=;
	b=opM5LyPOGCNet5UQCFrWIu/IyAI2MdxH3hvDO6Lt2RCGb7D+qP19loe5SK2+nr7KpxWzeD
	jzfbkylNR9HnrUXzBO+/N2zjxkgcqlOGQIFIzQJPO0wYGQATvLKvuuooOjjl3QPyBMHY3r
	2irFXtqAY/yTGS6ek4YKpoqXpDvJ8b0=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785402434;
	b=nc4AqMoka6dtHpThcE8FbyOlDvQfNyhOpajjetYxdBMIwf8qEabPxb6icSgqOYwwx7sYuP
	BZd67nrQ0hDLL3SFAqwXbcu0uRCXMdmXGT0HyjVgA03Gos9z1iNK0ro/QVmCNqQ/Rk+69+
	ifDIVWHUq2cVA+vW6K/O4WJYxG4qSrI=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=HpcPmVYQ;
	spf=pass (imf17.hostedemail.com: domain of xueyuan.chen21@gmail.com designates 209.85.210.172 as permitted sender) smtp.mailfrom=xueyuan.chen21@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pf1-f172.google.com with SMTP id d2e1a72fcca58-84eb072307dso166940b3a.2
        for <linux-mm@kvack.org>; Thu, 30 Jul 2026 02:07:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785402433; x=1786007233; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=ObdtBSjlBwpgFGsbg/wrosB7LM91UtGEZki+/E5+WZ0=;
        b=HpcPmVYQmdW8DpjICuy2hYO9QSVIObshtBh8VNhOR4un5NuGczFlRxPDvOwJAHDbcA
         IRU+7pqqv1iw0Z3S2+DBZ5IHq9UQJhx/tGEEbngqBojfsDcid5aOPmqXhlhMB5VtDVkl
         OUYVfVKi8JoXrIKLtM91wX4aJgTFZ5JWyEwPa9jxzXYTMcCeoyN8/nRHd7QQP7lARtF7
         3ORtu4T5Pih6iU3EfM5yxMyqJOrJk5jleKKgCpAkCHKIapn95TsIKoQPkeqFe1naq6l7
         b3R2co7T/dsaH382ufv5mwKnlTWL4K8A4jCHjUCQSqhJ+bDWfgelHFz39qCWotmZRxx3
         w+Kg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785402433; x=1786007233;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=ObdtBSjlBwpgFGsbg/wrosB7LM91UtGEZki+/E5+WZ0=;
        b=IBa4l6jRv6ui290BpmXa/gqVQpDHKTMcrXkHehHw3T/WsBJWHXkkh/rTzaNGX/l3e/
         dBSVcR8ut+A0597nEX53Q5fdcTTzJhX0iTHNySgauswHwvxU6/1zUYsdD0vQ2ifPubG+
         4UUR7uW8MdoArG35AcHeifaGf4dpQV4Yhau/eelEgwKui41/NjqaW6CrZYBP9qZev6xn
         L3a8u6QetIj2tKmhllVSVg3IXSlhkB1ZnKaujDF1UHcmsOhBut3VUJMuBJdvNMfQoGL3
         P94uCLJmkGXQqc2jknaPS0Ga+V9jvCq87dIg/2vQoYiZRWYL9HmOoIQfHjh7EFgU+KbZ
         32tA==
X-Forwarded-Encrypted: i=1; AHgh+RrHXHZ2e7aQjViVfI3u2lPuV+MeScMwDeJipFPn4rkernCBwuCAd/f52jCvHZNQYskGA21BnxHPMg==@kvack.org
X-Gm-Message-State: AOJu0YyTifYjjcRLinkzI1dWp26SHfVHUIoCXrHUHwIFzyGYoKRPJPdR
	ctE5FfpM3qn5uaVJEntGzH8ihRmE/V/CkeitHyQHn9U6ruxGST48seoq
X-Gm-Gg: AR+sD11fNn2QyfcgNd1eN835SmsElB6ry1sLIzhL+5Ad5fRTTNmplS3mLKbdWQwwHVE
	HPwRPKOlh7FzcrMY1k45w6dwn1I1Bu9odBJcWBC9X4PTSpqNV4uUVy4OEda19mGVqoUPsrSAK7N
	yStHR42ZOEW8wHBV/ri2JfknasMFuqIZAol9kR/3CrYRnS9EP7LJn1KIOryO6baQgrdHOc5iYXs
	+kHBN4eqVLcdGgNjMNyXVP8ech8iFIpVueNk8Of1KpjjGJgVC63OSgJSJNkTlBgpo6bKNiNa7VL
	0wfwLTGkjIpWs//81P7G3S9WvYwVBQL+u1mU8AuQMCKB9pC8pNgt1PtShPj+9kuX/UmyONgt3bW
	D/C3dFkQT55R2svYrNlPEF85Uo8zxpuJPMUgi0mRdp7XwFEMkINE21tCWsz5YGhSvOhp5hX4sBQ
	vrz/7VfuE7a+NC/DCMxh8gM9NHyt+zNVVdjIhhMj/25R9kA3mjFfTn6DF15asRrTdY1Nlw8Mr+c
	0Ly4PnceaePHyJQa9RbvGaW694fI2wuDe0GM56zbVtZZDxp5pkb
X-Received: by 2002:a05:6a21:487:b0:3bf:99ea:aeb2 with SMTP id adf61e73a8af0-3c900bbd69cmr2478612637.4.1785402432765;
        Thu, 30 Jul 2026 02:07:12 -0700 (PDT)
Received: from debian.lan ([155.117.85.23])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-cbdba447107sm1902510a12.21.2026.07.30.02.07.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Jul 2026 02:07:12 -0700 (PDT)
From: Xueyuan Chen <xueyuan.chen21@gmail.com>
To: akpm@linux-foundation.org
Cc: david@kernel.org,
	ljs@kernel.org,
	usama.arif@linux.dev,
	catalin.marinas@arm.com,
	will@kernel.org,
	linux-arm-kernel@lists.infradead.org,
	tglx@kernel.org,
	mingo@redhat.com,
	bp@alien8.de,
	dave.hansen@linux.intel.com,
	x86@kernel.org,
	hpa@zytor.com,
	rppt@kernel.org,
	ryan.roberts@arm.com,
	ziy@nvidia.com,
	baohua@kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Xueyuan Chen <xueyuan.chen21@gmail.com>,
	Lance Yang <lance.yang@linux.dev>
Subject: [PATCH v6 2/3] arm64/mm: add set_direct_map_ro_noflush()
Date: Thu, 30 Jul 2026 17:06:46 +0800
Message-ID: <20260730090647.2401252-3-xueyuan.chen21@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260730090647.2401252-1-xueyuan.chen21@gmail.com>
References: <20260730090647.2401252-1-xueyuan.chen21@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 0FB7540011
X-Stat-Signature: izo7by6p53zqigjw9dqyxfsogczecrjk
X-Rspam-User: 
X-HE-Tag: 1785402433-734510
X-HE-Meta: U2FsdGVkX19abWXTmcPMQwvXI0Jbq0TAKIbEpTL9gnFIKeQLsRMx44KUTg0dStAN2QLL2WdLKzFBn5W5IMVATRdczDJcrK+WGEMJL/pra4xNw6Q6+NEnAn4Ydh5qnO6IXWYCmRhQ294Kk6x99OyeC1uUA6LVcKCtr5bCFXYw4Qs22crJ1EFwM+Svgh+iKxKsT4feR7gWwbXRPZndwL9DSsmc6o/2DqlFJng31cwyDKs7v4NvwGqgwDUoAoK07Y8YboDtx67Z/rqqjYEKD+PrmQKKEFyrCZcf2VlnkiWzEJOe0t57cnX3pghlS6ekIRO63OMFdfRaE3r1l4k24pflO82iOYHy73RaienzP/qHqEMpOpB5KNDx/tPGU+p3/ivrNYgygdzaKo/s0kwJhBzVHRB+Bd5i9CmhDU0I7A7DdNgG3Qzcw7fCJXYFwnhwUA6tVSQEpGK7v1h5eQ52/vVKYKJLu62aqSNeU3PvlRPFu6GR/PFI8970GuqE+2uATs6bl80KCYAbmh9AVMpUVf3gwOTRLsqfIgZPkvCdVHUCYbDbiLtezGXwn4gkKztEQmZgQgkXWjyeKnIkDKCywthsDsJ6U+wXNhtlINIot6+vclOFZsgWQ8LJ880tXhSPGUssFrH26H5XMbBI4tv207JMmau8kK9D+GuCGFe0FnIn30CImKkBzX17AV6WiNuf0waEHpJC6MZMkfryhoankul2RRm6CeHznAmnLRaciZ0/ijO/JvWvUBI5T8YZ9iExVObMgevr6j0R9YzF3dnPweo4ac70SmYyclFP2hxpAMUPhGOtwFnOhJj6MtAD4hgEis2FRXKQLjIn6xJxHeKxH8e3BhtnAhLFZVarSi5sTSKFK0OSCF86afTlKlVJtA22dKeP9FAC/c2nqCnFheeCHtyJJS6I11kSlQ+bxFpVk+RNh9mfd8xiXpN/2CvBkqLL8iwTVy879JDICBn7J/RFXYO
 ydRZlrBL
 C0QY7WbzZI0ek8HbU2AQ7NA9WPPv4KJYKTfK4B5az8IwlJXVvvrzKe6pRKeDU/NiDKg8wkzvYmupcU5LpK6u957MYqWXcwmzbsLBr3M4YBoudyJKL/PJIJ0r4IPzRQ9iGashN9BpqS43KVi8Xz1Mmb1YvdgNkXX7xU7mcaltJ7KMtfvI5uQ9ui87u0ZfeJuJrrkdGSBTSw8UbjJGWNo9mge6GQrIr+RJqkaI8qEL88UcWlko+4ilja3hC16qwC4HYOm3SDXQrjDngHVDtW38stKCT43XJpMhMB/a/9qpcf5osVVLgYKDTedCRKj1GHVcnDnlGvUuVoOvr4J3pIKGRDO7R8hslaSGoPwDeY7a/rom4utDrtacnCU8OevhY3yQl9n+c9RgRfS6sCNTvmHS4O15Xh6ZJ1uQQzVBKK87w5KVq2aaz7gV4xeimYxBHWQ9uSWzIaPQdNGrE+PeoeCTfh+t2MyYZe/fdRcFlrwswVcr3hJohoqC+ffVP6cycWU5jWqmfpWrHzbEEUi2LEnKOkvHoMroYuGx6DNyv
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Implement set_direct_map_ro_noflush() for arm64 with update_range_prot() on
the linear map, setting PTE_RDONLY and clearing PTE_WRITE. Keep the
existing can_set_direct_map() guard and leave TLB invalidation to the
caller.

Co-developed-by: Lance Yang <lance.yang@linux.dev>
Signed-off-by: Lance Yang <lance.yang@linux.dev>
Signed-off-by: Xueyuan Chen <xueyuan.chen21@gmail.com>
---
 arch/arm64/include/asm/set_memory.h |  2 ++
 arch/arm64/mm/pageattr.c            | 10 ++++++++++
 2 files changed, 12 insertions(+)

diff --git a/arch/arm64/include/asm/set_memory.h b/arch/arm64/include/asm/set_memory.h
index 90f61b17275e..7083260303c3 100644
--- a/arch/arm64/include/asm/set_memory.h
+++ b/arch/arm64/include/asm/set_memory.h
@@ -14,6 +14,8 @@ int set_memory_valid(unsigned long addr, int numpages, int enable);
 int set_direct_map_invalid_noflush(struct page *page);
 int set_direct_map_default_noflush(struct page *page);
 int set_direct_map_valid_noflush(struct page *page, unsigned nr, bool valid);
+int set_direct_map_ro_noflush(const void *addr, unsigned long nr_pages);
+#define set_direct_map_ro_noflush set_direct_map_ro_noflush
 bool kernel_page_present(struct page *page);
 
 int set_memory_encrypted(unsigned long addr, int numpages);
diff --git a/arch/arm64/mm/pageattr.c b/arch/arm64/mm/pageattr.c
index ce035e1b4eaf..c51236b61651 100644
--- a/arch/arm64/mm/pageattr.c
+++ b/arch/arm64/mm/pageattr.c
@@ -365,6 +365,16 @@ int set_direct_map_valid_noflush(struct page *page, unsigned nr, bool valid)
 	return set_memory_valid(addr, nr, valid);
 }
 
+int set_direct_map_ro_noflush(const void *addr, unsigned long nr_pages)
+{
+	if (!can_set_direct_map())
+		return 0;
+
+	return update_range_prot((unsigned long)addr, PAGE_SIZE * nr_pages,
+				 __pgprot(PTE_RDONLY),
+				 __pgprot(PTE_WRITE));
+}
+
 #ifdef CONFIG_DEBUG_PAGEALLOC
 /*
  * This is - apart from the return value - doing the same
-- 
2.47.3



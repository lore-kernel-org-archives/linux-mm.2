Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0BFE4C982D0
	for <linux-mm@archiver.kernel.org>; Thu, 17 Sep 2026 20:45:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 199626B0099; Thu, 17 Sep 2026 16:45:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 122F86B009B; Thu, 17 Sep 2026 16:45:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 010A66B009D; Thu, 17 Sep 2026 16:45:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C67BA6B0099
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 16:45:15 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 62EDC1604C7
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 20:45:15 +0000 (UTC)
X-FDA: 85224434190.27.CC3E6CB
Received: from mail-pl1-f197.google.com (mail-pl1-f197.google.com [209.85.214.197])
	by imf05.hostedemail.com (Postfix) with ESMTP id 8B7C6100002
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 20:45:13 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=ndqakYgs;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf05.hostedemail.com: domain of 3WFGsagYKCAk57rqjwpxxpun.lxvurw36-vvt4jlt.x0p@flex--wyihan.bounces.google.com designates 209.85.214.197 as permitted sender) smtp.mailfrom=3WFGsagYKCAk57rqjwpxxpun.lxvurw36-vvt4jlt.x0p@flex--wyihan.bounces.google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789677913;
	b=3g4/8R7D29MPPFl8ABuk0iP52AHaJKggzsi07cz7qEKU/tG1m+/2pQbZFA+kKpUZAQcTWd
	y5HAkaQxQz4j/7jKrr4ecTED6B+hkWAuNuDbnD7kyLFoz3ibnpHjGuzS2Kmksbwy03gaR4
	BkYnY/DouQzRPsXjwrhwemlcFTo0JTc=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=ndqakYgs;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf05.hostedemail.com: domain of 3WFGsagYKCAk57rqjwpxxpun.lxvurw36-vvt4jlt.x0p@flex--wyihan.bounces.google.com designates 209.85.214.197 as permitted sender) smtp.mailfrom=3WFGsagYKCAk57rqjwpxxpun.lxvurw36-vvt4jlt.x0p@flex--wyihan.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789677913;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GhFaT1pWqaSYrZ5igcNnVG6b2J5qZxAlydhAJEnR0ZM=;
	b=JUpEBRTRAsh0HNe5Jz5oZOFuDJsBTWgAD2LmfCKQD+BisTzjHLtqTHP6GkGEtpNjtp1Qtk
	x2BePSzM5afknuZR767ycdbSFG1rjmWt2QecrJd33jDRBQ5fU633k9cWQeeOQb/lIr1ykA
	ZoUjI8Xso/WhKXeAm/OICYQ+P+8bU1g=
Received: by mail-pl1-f197.google.com with SMTP id d9443c01a7336-2dd753a52bbso1434455ad.0
        for <linux-mm@kvack.org>; Thu, 17 Sep 2026 13:45:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1789677912; x=1790282712; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=GhFaT1pWqaSYrZ5igcNnVG6b2J5qZxAlydhAJEnR0ZM=;
        b=ndqakYgsB0UHsfa8H2l3N6BvFmhi5j5TuH5NkPvPjO9ArBl/eFs9oVVdzBVZ1VRiy2
         9yb97AGsHHWtbFK8VUu8PVyYUH4dlALtlDRuH3BxncRHKtyD+5KdFig+MtpSjDr0fJR7
         lnthW59akdi/XPK6iZdaLg0McOlxdbOuPb5NtrEvVtYudkdjDZnrtP4Nb4KXaMSmSYo0
         Hgghk980+XX39zDi6DL4oKWsU0//G+3Lo/BQMOtiBSnmbpKE+F43kmrbH7jjIf94hYzJ
         JbAsXglmwNejT3TBwdPWTewTGs4r7DA0ojbS0mx48qKPCIzxWXqiFcDLI73lyefFinp4
         hC2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789677912; x=1790282712;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=GhFaT1pWqaSYrZ5igcNnVG6b2J5qZxAlydhAJEnR0ZM=;
        b=DtusvrcxZSog4bgpu1JHeldWp3hf/2mfUuqe4DTLgeWxveW5H4XYI8qk4iJjm6iNY3
         g4POPoZdu0MuEMvKTGF3x/MfHaUKouBH4HhAhsIRRH4Z4Nf2z6Dr1iV5T/WxJCPRetY6
         Xe0MUHKL+tOHaJ5d3OnfU32vDTfG6W/qVGHSyv2CuZ1eIuzoqOjwC9IxkbHtqy8q4zHZ
         DMaTWzAHzRvLogCs2klwqEjFLbEYUAItj+taFMvCg4+gWPgKyuxM9p51Mwr6uLglQJ3f
         H8uBqOAl8iN/uLUfZQKCHrXhPzKQwk1mjmr51IM6EoYt2bXx967mGFs0lxmZEpIqOMAW
         nTag==
X-Forwarded-Encrypted: i=1; AKwUvBw3tPiJOSTjjAyWb0gMoIXObOiTaCxODykEax+4w6XMQ4qFWUYQjYc8ydkYKxaQP6JP4QwKdryEAQ==@kvack.org
X-Gm-Message-State: AFuF++lyjZ2i8qiaBeiW/qJCVrhkaY23H4P46ZsxrKfSfQ4h3gTKo3CG
	6xaaEfuhF+ZCrz2iyqNmSF1TjFVqLp3dpbhuU73JQW6zXSnAcvFRqWjkS4Uthz4TG61M4xZAAij
	gtFAylQ==
X-Received: from pjzm16.prod.google.com ([2002:a17:90b:690:b0:39d:9b47:4551])
 (user=wyihan job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:224c:b0:39b:61f1:8032
 with SMTP id 98e67ed59e1d1-39e54e7c18emr677747a91.16.1789677912150; Thu, 17
 Sep 2026 13:45:12 -0700 (PDT)
Date: Thu, 17 Sep 2026 20:43:51 +0000
In-Reply-To: <20260917-memory-failure-mf-delayed-fix-v6-0-4b00856b5364@google.com>
Mime-Version: 1.0
References: <20260917-memory-failure-mf-delayed-fix-v6-0-4b00856b5364@google.com>
X-Developer-Key: i=wyihan@google.com; a=ed25519; pk=cRi0fKzS5BMxlHyHY2pJv3w/1zcgfYKr6EYGYppdMYc=
X-Developer-Signature: v=1; a=ed25519-sha256; t=1789677906; l=5191;
 i=wyihan@google.com; s=20260319; h=from:subject:message-id;
 bh=oCZbQTSw2Yyl7B5BQDviNb8o0kDmMbfd/szlr3bi9Xc=; b=2sjWrqtdOcssMiZtTNK//2RmRxIpXb5yhivrXeyIB1v0t2FyBFn36kmbEWN2P8Ax0XR7UqVYg
 PdjG1ilLGPiDeSDyMaCfp7cPG5UuHvIdRtwg6rJOtaSMWsW7wX2rc6R
X-Mailer: b4 0.14.3
Message-ID: <20260917-memory-failure-mf-delayed-fix-v6-5-4b00856b5364@google.com>
Subject: [PATCH v6 5/5] mm: selftests: Add shmem into memory failure test
From: Lisa Wang <wyihan@google.com>
To: Miaohe Lin <linmiaohe@huawei.com>, Naoya Horiguchi <nao.horiguchi@gmail.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Paolo Bonzini <pbonzini@redhat.com>, 
	Shuah Khan <shuah@kernel.org>, Hugh Dickins <hughd@google.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, David Hildenbrand <david@kernel.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, Andi Kleen <andi@firstfloor.org>, 
	Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>, Rik van Riel <riel@redhat.com>, 
	Yu Zhang <yu.c.zhang@linux.intel.com>, Lorenzo Stoakes <ljs@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>
Cc: rientjes@google.com, seanjc@google.com, ackerleytng@google.com, 
	vannapurve@google.com, michael.roth@amd.com, jiaqiyan@google.com, 
	tabba@google.com, dave.hansen@linux.intel.com, Lisa Wang <wyihan@google.com>, 
	Isaku Yamahata <isaku.yamahata@intel.com>, Xiaoyao Li <xiaoyao.li@intel.com>
Content-Type: text/plain; charset="utf-8"
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 8B7C6100002
X-Stat-Signature: h6adjzqarmciuto9sjmdshnf5n95j35b
X-HE-Tag: 1789677913-288350
X-HE-Meta: U2FsdGVkX1/3Pv5ZPCt4/YT5Zxmqujz1n+DJpQNuVU7hLsveIVUsTpSW44vfkUgg7UERyEP1dz921GLcLp8vR3rAZOf7XMjYD3+qDuUGKvuydz/Sth/IPt5ExGj77AdFYCs2wHzmpRfogZhpjwpMdNHyPVGdN7xPkV7y/BB8C0Ruu5r1I6ltJ5SB2+32/DN3FMf9yAsvoLPp6tosSlSaqqjUSOmRSJ0MWtfGczATR4zoGbwDlgmipg7LaXACaFg1mSn3m3LkGXm75H1M9TCHDyoN6SrUpX3Ny6DBbIBWcWRV5xi2k4wDpQnjGQ/chQicVCKA+/8fWElC2VtBLg7XITj+I5LZBjNq7eehy3JDStrGx7lhgDQI4E801kZ+ks7xc6NODHYgZ26MbhNl4tfUK5y1B89+7HT14SSnvQAqsQk6n8h8hdCxzvhL3jflz2OiGtDba1jNVanpDROTt/7Gq0IwAngCAuWVtTJyFwDGKDRCOAkzdGVsq10G9Q0Zikt5w15yIQWT9QYir+S5So0zMvwC/nJ2hVFu4Qq2dktmP4JgWDlGrMgqiL9a6X9ewbW6YOucQCFiCKhURvv/oP6niML/8Uo4J/7i33KAoKoC3kBd9T4QwlSU4OodNmCXVgiQDpodcwMvEVLpEfvdMeN+C4vpeAqhjUR2wQMhYgzXzoL22xBFkfp1zT47/r6zbgukT+ej+r5agRGz41tV4G/xWEu1ih/iHM0EfFL08/XWxcDEZR77syj+nvVV/GlVEpIGrlKxjsOj1xS0b/2qaQh1wIC8F7t9HSr0ja02y1XXIiZFfxhJfjqu753c2LgxNOStXHg4ZGle2RkvM4SwHxu63zyGBqq0vyhr01urxYAZdlJymVhH5QT5NRLdeiV81k0PtQPSl+QFNRkr8ycqtvna8y5H7GsnkstMqS5MwIH6rZ0mBjP2hNtI1dF/xBGwjNstc5cjfkt5HMsReHJ/ube
 CwIsc2Jn
 STLR57epSA/G/sZgedHBZSspvUbD4p8k1w7vMzsaKD2aWsuCUUBYSO8tTPKC81044F9lNl6y21fANvCdeWqyVJBMBw+PfzMiYruVlQIm6WoUSVdrcB8mABVWJAq+YyteTtmsSe50e2m/klcYb1F7HhaIp5UpExPebVOWz0Au9lxxyeHFUlq+8giFQK72vbnYCh7RCqIkTiOz8R3MhwUt6Mp5qIkzlkGwbERTNpVqfUM+jLav/lsD3ajQz1bkNgr+4u5H1vzHPK94oo0S9I0yyCu8jJG/5hsemZjJcaAAxGD63cBBPQX0OdI/yNV1L3c8scgXn419BzmEPxJPk8Mbq5YEDd/4VN8cs5Ul5RwxhX3aBlKer+WgZXjs7qMYfn4+T+AJtOZRiJ3X1+aR9iJRVx6JsgDNxzO+OVKakhQMRXUT5hl7SiieAW//bSAjpHTTVjLOnVK3wim5gjH9Ct1aUP0EIBWL9Kr2v4Uyru3ujCdTYpdxMmYwX9bya8vDjY/ChAS2YiPp+RN2tNxpmMPZgcXrZe18SoGB/djIUlovBUj7IFtMVbhKqFEVPzV3+NIj1k1xlZTwybGdxk1CxsXcThxWTDmobTANJH77VHBgQqnz6Xd5bqLCjharLwLmGLbmm6ymdEadSdg14V94=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add a shmem memory failure selftest to test the shmem memory failure is
correct after modifying shmem return value.

Specifically, test the expected behavior under various scenarios
combining page dirtiness (dirty vs clean) and failure types (hard vs
soft):
+ Dirty + Hard: Trigger a SIGBUS on injection, and trigger another
  SIGBUS when reading the page again.
+ Dirty + Soft: No SIGBUS is triggered, and the original value can be
  read successfully.
+ Clean + Hard: No SIGBUS is triggered on injection, but trigger a
  SIGBUS when trying to read the page again.
+ Clean + Soft: No SIGBUS is triggered, and the page can be read
  successfully.

Acked-by: Miaohe Lin <linmiaohe@huawei.com>
Signed-off-by: Lisa Wang <wyihan@google.com>
---
 tools/testing/selftests/mm/memory-failure.c | 114 +++++++++++++++++++++++++++-
 1 file changed, 111 insertions(+), 3 deletions(-)

diff --git a/tools/testing/selftests/mm/memory-failure.c b/tools/testing/selftests/mm/memory-failure.c
index 1a5a32e22cce..d5d17a262c00 100644
--- a/tools/testing/selftests/mm/memory-failure.c
+++ b/tools/testing/selftests/mm/memory-failure.c
@@ -29,9 +29,14 @@ enum result_type {
 	MADV_HARD_ANON,
 	MADV_HARD_CLEAN_PAGECACHE,
 	MADV_HARD_DIRTY_PAGECACHE,
+	MADV_HARD_CLEAN_SHMEM,
+	MADV_HARD_DIRTY_SHMEM,
 	MADV_SOFT_ANON,
 	MADV_SOFT_CLEAN_PAGECACHE,
 	MADV_SOFT_DIRTY_PAGECACHE,
+	MADV_SOFT_CLEAN_SHMEM,
+	MADV_SOFT_DIRTY_SHMEM,
+	READ_ERROR,
 };
 
 static jmp_buf signal_jmp_buf;
@@ -157,17 +162,22 @@ static void check(struct __test_metadata *_metadata, FIXTURE_DATA(memory_failure
 	case MADV_HARD_CLEAN_PAGECACHE:
 	case MADV_SOFT_CLEAN_PAGECACHE:
 	case MADV_SOFT_DIRTY_PAGECACHE:
-		/* It is not expected to receive a SIGBUS signal. */
-		ASSERT_EQ(setjmp, 0);
-
+	case MADV_SOFT_DIRTY_SHMEM:
 		/* The page content should remain unchanged. */
 		ASSERT_TRUE(check_memory(vaddr, self->page_size));
+		/* FALLTHORUGH */
+	case MADV_HARD_CLEAN_SHMEM:
+	case MADV_SOFT_CLEAN_SHMEM:
+		/* It is not expected to receive a SIGBUS signal. */
+		ASSERT_EQ(setjmp, 0);
 
 		/* The backing pfn of addr should have changed. */
 		ASSERT_NE(pagemap_get_pfn(self->pagemap_fd, vaddr), self->pfn);
 		break;
 	case MADV_HARD_ANON:
 	case MADV_HARD_DIRTY_PAGECACHE:
+	case MADV_HARD_DIRTY_SHMEM:
+	case READ_ERROR:
 		/* The SIGBUS signal should have been received. */
 		ASSERT_EQ(setjmp, 1);
 
@@ -263,6 +273,20 @@ static int prepare_file(const char *fname, unsigned long size)
 	return fd;
 }
 
+static int prepare_shmem(const char *fname, unsigned long size)
+{
+	int fd;
+
+	fd = memfd_create(fname, 0);
+	if (fd < 0)
+		return -1;
+	if (ftruncate(fd, size) < 0) {
+		close(fd);
+		return -1;
+	}
+	return fd;
+}
+
 /* Borrowed from mm/gup_longterm.c. */
 static int get_fs_type(int fd)
 {
@@ -355,4 +379,88 @@ TEST_F(memory_failure, dirty_pagecache)
 	ASSERT_EQ(close(fd), 0);
 }
 
+TEST_F(memory_failure, dirty_shmem)
+{
+	int fd;
+	char *addr;
+	int ret;
+
+	fd = prepare_shmem("shmem-file", self->page_size);
+	if (fd < 0)
+		SKIP(return, "failed to open test shmem-file.\n");
+
+	addr = mmap(0, self->page_size, PROT_READ | PROT_WRITE,
+		    MAP_SHARED, fd, 0);
+	if (addr == MAP_FAILED) {
+		close(fd);
+		SKIP(return, "mmap failed, not enough memory.\n");
+	}
+	memset(addr, 0xce, self->page_size);
+
+	prepare(_metadata, self, addr);
+
+	ret = sigsetjmp(signal_jmp_buf, 1);
+	if (!ret && !self->injection_attempted) {
+		self->injection_attempted = true;
+		ASSERT_EQ(variant->inject(self, addr), 0);
+	}
+
+	if (variant->type == MADV_HARD) {
+		check(_metadata, self, addr, MADV_HARD_DIRTY_SHMEM, ret);
+		ret = sigsetjmp(signal_jmp_buf, 1);
+		if (ret == 0)
+			FORCE_READ(*addr);
+		check(_metadata, self, addr, READ_ERROR, ret);
+	} else {
+		check(_metadata, self, addr, MADV_SOFT_DIRTY_SHMEM, ret);
+	}
+
+	ASSERT_EQ(munmap(addr, self->page_size), 0);
+
+	ASSERT_EQ(close(fd), 0);
+}
+
+TEST_F(memory_failure, clean_shmem)
+{
+	int fd;
+	char *addr;
+	int ret;
+
+	fd = prepare_shmem("shmem-file", self->page_size);
+	if (fd < 0)
+		SKIP(return, "failed to open test shmem-file.\n");
+
+	addr = mmap(0, self->page_size, PROT_READ | PROT_WRITE,
+		    MAP_SHARED, fd, 0);
+	if (addr == MAP_FAILED) {
+		close(fd);
+		SKIP(return, "mmap failed, not enough memory.\n");
+	}
+	FORCE_READ(*addr);
+
+	prepare(_metadata, self, addr);
+
+	ret = sigsetjmp(signal_jmp_buf, 1);
+	if (!ret && !self->injection_attempted) {
+		self->injection_attempted = true;
+		ASSERT_EQ(variant->inject(self, addr), 0);
+	}
+
+	if (variant->type == MADV_HARD) {
+		check(_metadata, self, addr, MADV_HARD_CLEAN_SHMEM, ret);
+		ret = sigsetjmp(signal_jmp_buf, 1);
+		if (ret == 0)
+			FORCE_READ(*addr);
+		check(_metadata, self, addr, READ_ERROR, ret);
+	} else {
+		/* Test the address accessability without check_memory(). */
+		FORCE_READ(*addr);
+		check(_metadata, self, addr, MADV_SOFT_CLEAN_SHMEM, ret);
+	}
+
+	ASSERT_EQ(munmap(addr, self->page_size), 0);
+
+	ASSERT_EQ(close(fd), 0);
+}
+
 TEST_HARNESS_MAIN

-- 
2.55.0.1082.g2b9226bbc0-goog



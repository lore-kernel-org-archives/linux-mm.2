Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0650DE98DEE
	for <linux-mm@archiver.kernel.org>; Mon, 23 Feb 2026 07:05:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 00CA86B009B; Mon, 23 Feb 2026 02:05:09 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E9ADD6B009D; Mon, 23 Feb 2026 02:05:08 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D5C7D6B009F; Mon, 23 Feb 2026 02:05:08 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id B58AA6B009B
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 02:05:08 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 3D0A013BC05
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 07:05:08 +0000 (UTC)
X-FDA: 84474834696.10.2601382
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	by imf13.hostedemail.com (Postfix) with ESMTP id 87D652000D
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 07:05:06 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=MIlMDC+E;
	spf=pass (imf13.hostedemail.com: domain of 3IfybaQsKCNw8AICPJCWRLEEMMEJC.AMKJGLSV-KKIT8AI.MPE@flex--ackerleytng.bounces.google.com designates 209.85.216.73 as permitted sender) smtp.mailfrom=3IfybaQsKCNw8AICPJCWRLEEMMEJC.AMKJGLSV-KKIT8AI.MPE@flex--ackerleytng.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771830306;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RvAUEDsFvuEub5+rTz247CsIuwfFrabNfZjGGUr2GkQ=;
	b=mxvyGnZAT/nJj7LY8i5JPkpcBSSpfqmFeIhV1Xc1X2M8uMXt/0En5ksiKgXYgQgHIfmHER
	4seNYcvrpaSuD5/6xm+wnyUVpZFslQO0SiYUGYFtnC/XvH3LVwrH7shPqaBGzfuTPH/+wa
	dhQ8V04ll8TWb8MkG6xO+XuQpbfOJig=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=MIlMDC+E;
	spf=pass (imf13.hostedemail.com: domain of 3IfybaQsKCNw8AICPJCWRLEEMMEJC.AMKJGLSV-KKIT8AI.MPE@flex--ackerleytng.bounces.google.com designates 209.85.216.73 as permitted sender) smtp.mailfrom=3IfybaQsKCNw8AICPJCWRLEEMMEJC.AMKJGLSV-KKIT8AI.MPE@flex--ackerleytng.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771830306; a=rsa-sha256;
	cv=none;
	b=ItDLAIcZsaDTbkwmPoNIKlCcMcG40FZXyVF4/ObuNMQD2oQZd7vwh0Js/Ti/grTDB5Tsz8
	mjWioeUnC89h648UskqsozagFvLIg1o9kSRgIktH9yJglM4jdC4LVNFXhE+/ml5ZcB5Syl
	IvDfIZnHH7/x0gqQ1FHQ9zIkJvPcRFs=
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-354c72d23dfso28781256a91.2
        for <linux-mm@kvack.org>; Sun, 22 Feb 2026 23:05:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1771830305; x=1772435105; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=RvAUEDsFvuEub5+rTz247CsIuwfFrabNfZjGGUr2GkQ=;
        b=MIlMDC+ESwwNArTx2FhK6ICvFuCQrcBsJDrpDRgBlcdZphZ+QAZVW3xE0FGYbR92M8
         YljpjyBRThStmBwuMRxQvdzegzTQvwsVCNUcm515WQuhfkZntiU4RXvUi6hqi40VdrF9
         RChYs/PXN63O124yptoCMMxpVq6uZQ6su1ncJhvbhumE78JGL4bKkKoXHKOzAlHEw2W8
         9P1QS5yXzOu47DlEPo+2iEb6Tm0yrIC41HQjonqY9ZoJ3zFHhdXcSYaMMdK0vEsYmkF0
         dvGOhXLjBMl7TuSpiFdAyBgq+R4c9UcvyP1Hm01GNjKCCQWVODCFhYa/J7/sqcKjnAeM
         Tjjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771830305; x=1772435105;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=RvAUEDsFvuEub5+rTz247CsIuwfFrabNfZjGGUr2GkQ=;
        b=qRtcWjWIDpq4kFXGiQEZZi0ho29AUdAJvEK/3VY+yQQGWdvKgDGa/vheV2XHCe2KJV
         lOX6WFBcpXrk8MsuCQJvIUR4h9zv9/jycs+kicfaXTjR1yV2vTfmb9tFBiUB46Fs97kh
         s5ciCWs4NsC5z6l+mG5Nly2wyhKl6LuwPX3LVC56fVdMohE+zy7WX6fFrphxGyAg1M37
         9tA9S+PqjblUJ98nUFxK/5daHjdS9ngUxiq3egnt2YqNL9ErPsXouUvNbxCw5HiYbhy6
         3GxdmPmfbSkOJDvw+y7RuuOi+TPpc3MBLXletNTmbdt4Ihuwv1d53lI+O4DLLkoTPJN8
         7ypA==
X-Gm-Message-State: AOJu0Yw/I5iY6H+5r0Z0bEntj12XrLHG+7aLiAMgGbWYOxN7qvvOjHgq
	jrWPmoFhPf1ODFs0UdckdySYyQsXFE53gdwiI9Zuya1Hh/yUbMdABs6Hyyz4dKM1XdQ0t7KdB/M
	gAygUkBETOvWSnz8fPxAlKyMyVSPDO2+oIMrSR7UsSgrb9QhC3DiKQBTCXeW1vNOWMTOrXuFZBp
	JtzUZo8aXrC2MmOZYGhiZYLeiCzNwRhwV3lekTJYIl27j0NpYG2F40eNf9Cw==
X-Received: from pjl15.prod.google.com ([2002:a17:90b:2f8f:b0:34a:a9d5:99d6])
 (user=ackerleytng job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:90b:4987:b0:339:ec9c:b275 with SMTP id 98e67ed59e1d1-358ae7e86a8mr7189605a91.6.1771830305202;
 Sun, 22 Feb 2026 23:05:05 -0800 (PST)
Date: Mon, 23 Feb 2026 07:04:43 +0000
In-Reply-To: <cover.1771826352.git.ackerleytng@google.com>
Mime-Version: 1.0
References: <cover.1771826352.git.ackerleytng@google.com>
X-Mailer: git-send-email 2.53.0.345.g96ddfc5eaa-goog
Message-ID: <3ddd0a3f248de622221c67d3a16ca058e77e74e5.1771826352.git.ackerleytng@google.com>
Subject: [RFC PATCH v1 10/10] KVM: selftests: Test that st_blocks is updated
 on allocation
From: Ackerley Tng <ackerleytng@google.com>
To: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, kvm@vger.kernel.org, 
	linux-kselftest@vger.kernel.org
Cc: akpm@linux-foundation.org, david@kernel.org, lorenzo.stoakes@oracle.com, 
	Liam.Howlett@oracle.com, vbabka@suse.cz, rppt@kernel.org, surenb@google.com, 
	mhocko@suse.com, willy@infradead.org, pbonzini@redhat.com, shuah@kernel.org, 
	ackerleytng@google.com, seanjc@google.com, shivankg@amd.com, 
	rick.p.edgecombe@intel.com, yan.y.zhao@intel.com, rientjes@google.com, 
	fvdl@google.com, jthoughton@google.com, vannapurve@google.com, 
	pratyush@kernel.org, pasha.tatashin@soleen.com, kalyazin@amazon.com, 
	tabba@google.com, michael.roth@amd.com
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 87D652000D
X-Stat-Signature: fs1bgb8ti93pp9pzd74b1p6twmco75z8
X-Rspam-User: 
X-HE-Tag: 1771830306-768158
X-HE-Meta: U2FsdGVkX1+R4m49C1PPRqCqC1YkhcSyHBNJLtm5GJTrSbhM7uPx1h8bBeEud/F6N8172O1AsWfYMfo+hypcNhxh2dUMMSL+viH0eRJmQfiPX459RIfe1mLR4GkrsQuBbKIbtKgVLImXlaJtSsck0YScretYWR8qlBxzEkvxGL1QP4GhiFmTHLKIfMj1jhqVnBgefLj1WPsThEf5ep3Yy5Om7u6nNhu3K5O5otY7j7YBOgEhiffIdwWlOjwED6v3m0nzauZPo3f7aQfF3m6dthVr7fJvXmgnoWPNLl45NA2VH3+gx1OuuzEUOlTBR8xf+VKYB5pnqweuiqQKTs41/p8Z/okWdIKo9YL+8TxKKdF/KcQgCLzJ7y6+WkSerQ8dPnWGbHMdYh3Zcc/Fym2adsUPRVWWZ2Z5Hm7CujwmNAbG+lH4vFRZxQkUAWVsPrLaOmZIEtAAuqN+XIehpZRs3AiGHiM2eYFaCVT1yWpY5m21CHlTMed2o5tYgfZCYgLXPs7xRaKcqm7BECaq4ql3GUCmiTfy7nD1+xLLsMlHXZMN2SIi2/FgUYru/7ReRIAiIFNyQGxr8N7VHoNCTE6vb3JKd++HseMmvYX9jtlSKyK+ky+WogylhMagmEwsUDRMmE9BJzEB8cS4vkhRyqqVki7XQt+pKf0nxZsORutoVbjCenK0EYZoz1jTX7k08REtL/cVi/VqR/ZmVh17MaTITw9murdOofQmGv+GZJITAkLvaE7Ug1DGBWO7gD5dbn6tllBqqARsUQHfiBqI5PchoAa8iHsbI5VlvcYwXwV0QXaAGNBoX/078QfdnMb1nCO4/Tr0QSgi/lSsx9oUO3t8iG3mY6FuFf3dRhzLGU2AhfIsu/dt2h3awkUGdRKXjDGmUVodM/PWB2uMhs/SHjg35t6qybpXy5bYxH7mqPy9uF2yL0unvXk9SzmejKGtPr8TYQFRVh0UXKLwwZMV/8l
 l2O4sNsI
 13o3qvRbwClQudjob/Bsxsr7yYVtNjXwwojjy1kF/rxlp9iyShKgLIiogI1q6IYnZswJJx/hy+W38vT7HGwkWjTj7hs6mCqQfBoaRQNpOsaoM9mnybarKDUIRtNArEfm3aY6K+9tajsWN8rvdhmQEAqkbCBiMMzsmL/lbnuIyszqdRbzXFfe348M+zfIGD7QXsQAZgs10SNKpoFT9n7Lz0XzQQVnkSxGcqeL0RquS6QqqaQl32zaoroJlXrmNIj4QTA86gDAkbKjnCvMmYwoGzE9FRA4jzWYyDwEq9qg8DpWKIhonjI7z091MdyXUsA+VkwQpHHLPs/n1ePqUyEtW8YhL1q+L64HAIQagzAKhZIor/wXstgEMeVvndKT3yHHcld9dCBoRtncrJ094mrt5+nhRfuFJWh4FkIFTyaAXTAx9nQuKKMcFyKOjdkAO7ICIPpTy1VzD7xf3TLJpGi9nD2msm+M/rDdphPne2xihieQYdPOTotvGryKUy3jaeO2Po2H+GjXSJHz6KVodAYVuerW0CwFlMnlcdEO9TD947qDbxYBEdl77yboT2C+REWkxi391uHozzTwR+ulg4FNgPig/H4rQHFK+XrmMhEPYKKb6kc+AjS+XIwl/ODbRGMevefBYjCMSZIU2emX97nRK64UF+sEy4o0HwXzkDnf8gWi0y/xIlORZU2FLgqIw0KlSbyZtP8YeBocjxt9Nul4K2H0bxw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The st_blocks field reported by fstat should reflect the number of
allocated 512-byte blocks for the guest memfd file.

Extend the fallocate test to verify that st_blocks is correctly updated
when memory is allocated or deallocated via
fallocate(FALLOC_FL_PUNCH_HOLE).

Add checks after each fallocate call to ensure that st_blocks increases on
allocation, decreases when a hole is punched, and is restored when the hole
is re-allocated. Also verify that st_blocks remains unchanged for failing
fallocate calls.

Signed-off-by: Ackerley Tng <ackerleytng@google.com>
---
 tools/testing/selftests/kvm/guest_memfd_test.c | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/tools/testing/selftests/kvm/guest_memfd_test.c b/tools/testing/selftests/kvm/guest_memfd_test.c
index 81387f06e770a..89228d73fa736 100644
--- a/tools/testing/selftests/kvm/guest_memfd_test.c
+++ b/tools/testing/selftests/kvm/guest_memfd_test.c
@@ -218,41 +218,58 @@ static void test_file_size(int fd, size_t total_size)
 	TEST_ASSERT_EQ(sb.st_blksize, page_size);
 }
 
+static void assert_st_blocks_matches_size(int fd, size_t expected_size)
+{
+	struct stat sb;
+
+	kvm_fstat(fd, &sb);
+	TEST_ASSERT_EQ(sb.st_blocks, expected_size / 512);
+}
+
 static void test_fallocate(int fd, size_t total_size)
 {
 	int ret;
 
 	ret = fallocate(fd, FALLOC_FL_KEEP_SIZE, 0, total_size);
 	TEST_ASSERT(!ret, "fallocate with aligned offset and size should succeed");
+	assert_st_blocks_matches_size(fd, total_size);
 
 	ret = fallocate(fd, FALLOC_FL_KEEP_SIZE | FALLOC_FL_PUNCH_HOLE,
 			page_size - 1, page_size);
 	TEST_ASSERT(ret, "fallocate with unaligned offset should fail");
+	assert_st_blocks_matches_size(fd, total_size);
 
 	ret = fallocate(fd, FALLOC_FL_KEEP_SIZE, total_size, page_size);
 	TEST_ASSERT(ret, "fallocate beginning at total_size should fail");
+	assert_st_blocks_matches_size(fd, total_size);
 
 	ret = fallocate(fd, FALLOC_FL_KEEP_SIZE, total_size + page_size, page_size);
 	TEST_ASSERT(ret, "fallocate beginning after total_size should fail");
+	assert_st_blocks_matches_size(fd, total_size);
 
 	ret = fallocate(fd, FALLOC_FL_KEEP_SIZE | FALLOC_FL_PUNCH_HOLE,
 			total_size, page_size);
 	TEST_ASSERT(!ret, "fallocate(PUNCH_HOLE) at total_size should succeed");
+	assert_st_blocks_matches_size(fd, total_size);
 
 	ret = fallocate(fd, FALLOC_FL_KEEP_SIZE | FALLOC_FL_PUNCH_HOLE,
 			total_size + page_size, page_size);
 	TEST_ASSERT(!ret, "fallocate(PUNCH_HOLE) after total_size should succeed");
+	assert_st_blocks_matches_size(fd, total_size);
 
 	ret = fallocate(fd, FALLOC_FL_KEEP_SIZE | FALLOC_FL_PUNCH_HOLE,
 			page_size, page_size - 1);
 	TEST_ASSERT(ret, "fallocate with unaligned size should fail");
+	assert_st_blocks_matches_size(fd, total_size);
 
 	ret = fallocate(fd, FALLOC_FL_KEEP_SIZE | FALLOC_FL_PUNCH_HOLE,
 			page_size, page_size);
 	TEST_ASSERT(!ret, "fallocate(PUNCH_HOLE) with aligned offset and size should succeed");
+	assert_st_blocks_matches_size(fd, total_size - page_size);
 
 	ret = fallocate(fd, FALLOC_FL_KEEP_SIZE, page_size, page_size);
 	TEST_ASSERT(!ret, "fallocate to restore punched hole should succeed");
+	assert_st_blocks_matches_size(fd, total_size);
 }
 
 static void test_invalid_punch_hole(int fd, size_t total_size)
-- 
2.53.0.345.g96ddfc5eaa-goog



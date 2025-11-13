Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 26B92CD4F2F
	for <linux-mm@archiver.kernel.org>; Thu, 13 Nov 2025 03:46:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9EF848E0005; Wed, 12 Nov 2025 22:46:30 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9C7278E0003; Wed, 12 Nov 2025 22:46:30 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 908EE8E0005; Wed, 12 Nov 2025 22:46:30 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7D6478E0003
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 22:46:30 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 0C8E3C07B8
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 03:46:30 +0000 (UTC)
X-FDA: 84104196540.17.96F5BF2
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	by imf08.hostedemail.com (Postfix) with ESMTP id 6046C16000B
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 03:46:28 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=BNDp9rsJ;
	spf=pass (imf08.hostedemail.com: domain of 3k1QVaQgKCOAEONNCOCUIQQING.EQONKPWZ-OOMXCEM.QTI@flex--cmllamas.bounces.google.com designates 209.85.214.202 as permitted sender) smtp.mailfrom=3k1QVaQgKCOAEONNCOCUIQQING.EQONKPWZ-OOMXCEM.QTI@flex--cmllamas.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763005588;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=adduDIgHwGkFi5eI+DMenkw4/FG0bTrtUTxhLb5vmxg=;
	b=F77PGm903dGK/AbR4d5R18Nz8u/0oroTehgU5JxaTRKVK9gzDTNCrIlS6gxIM9Jo78D3mg
	GD3KlfvlIMJTyeE4VKVwtu7bu2ysls4+dzNycFuMFTB4qTryrDkmlGIGvGAarWM9fI7Fdo
	ROisSqOCmSPepjoItUSc7bihhxuqPkM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763005588; a=rsa-sha256;
	cv=none;
	b=r7bsGnV4ZJ6t7aH7+dQ5vUPJiOkxgekvgI8rCL+yrK3eRy0sEhvviYUkvVuH0lTQTMyq88
	2HVZEkaHR2n8eSRY3TWDCny+dSISq+qb6yo2xYs6unZ29U0F5sgpnG2xqrqZQY4pepa3AV
	v3r1SF4WJzlpcbGDphAGx4uZv5dFUhI=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=BNDp9rsJ;
	spf=pass (imf08.hostedemail.com: domain of 3k1QVaQgKCOAEONNCOCUIQQING.EQONKPWZ-OOMXCEM.QTI@flex--cmllamas.bounces.google.com designates 209.85.214.202 as permitted sender) smtp.mailfrom=3k1QVaQgKCOAEONNCOCUIQQING.EQONKPWZ-OOMXCEM.QTI@flex--cmllamas.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-298535ef0ccso4385345ad.3
        for <linux-mm@kvack.org>; Wed, 12 Nov 2025 19:46:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1763005587; x=1763610387; darn=kvack.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=adduDIgHwGkFi5eI+DMenkw4/FG0bTrtUTxhLb5vmxg=;
        b=BNDp9rsJFVV1a1jHvHxmidmBoG6++uBU6wZeBt2NRcQS67JDE2SQEKEZeZ48zqXmv+
         1yEmAeahUc0xW3RLfk1784CijhtcbRqHQ4uBTzUxPYbMa9fYiJFiO4viUUNED3qwQmJf
         SvOAgjRjb/zeaCxIaaQwUoHQ1JLJo5j2in5yZ2P0aAVN/vgKkQY1sDUYn8YRVUeiuIpN
         uOa7603AljQKhoxjnVI/KNbELcZZ42RKfDHLdgqYOi+FhBgFQlosIgXZbEMlWf/km91a
         3BOgTO7nYGzMWbLCNz/5G2VRVmsKsCz4CYAw2K/npRWLS4xXxlV3bfLQ/JvuuV+Ov3/y
         cpew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763005587; x=1763610387;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=adduDIgHwGkFi5eI+DMenkw4/FG0bTrtUTxhLb5vmxg=;
        b=TECYJ7kdXG7WEhtbQNIn6h8YsLN07ds84dbK/236BVl0i95rtwh59c1gZgbVWxFuyR
         wn9QSyoI5WxIoKpGb4ID/UmdgWQvZLo2kP/s92yywKzLbD0DRBIUVjGRbumboQwAwz7R
         A4NRth2NenGUWhxSvw2MXdpq94p52quRNtIBodU+67+dLOeGRN0Ehf8D/6xObF+nwCQH
         GZbyHLtKVvk65RetrlnVkwJBWrzAwn4/Qm+On7oxAYWxRyCLAVnUWi6OTApDJBNOuscl
         cG8CurzqQgo+1O82EM9FSHoRR+cd/IkIVfki/GOfZ2uMlAfKk0Krypifn+p5n9ubKNvP
         KQaQ==
X-Forwarded-Encrypted: i=1; AJvYcCXxexNt1jCfpEMWqowUrfAIyey+AstV7D9M2KTPImcBVvpI87tIr4QpeoSrWG9fpkf2zQKeyYK1BA==@kvack.org
X-Gm-Message-State: AOJu0YzyjWMg18y8VVGhhs+VL60reO5SigFp+AY3jDboe0YnZyna/oZS
	9JAN0AfBgXEIHtPjWCdCGGBii7Sjbrp+xnfi8iGI0H0zltPMqF7+xR2Drv0WhBQ7XyP780bAK2L
	SObsH7b4CknlWsg==
X-Google-Smtp-Source: AGHT+IGEXQEv1ck2MMfwU6rgK0ZJutzaTXShQnbjZpIAo+t8a2V6IvSghLh5iFSwIMiZroqb5nh669NLVFj+pQ==
X-Received: from dlbrp1.prod.google.com ([2002:a05:7022:1601:b0:119:49ca:6b84])
 (user=cmllamas job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:903:2406:b0:298:4f73:d872 with SMTP id d9443c01a7336-2984f73d8d1mr72305215ad.21.1763005587061;
 Wed, 12 Nov 2025 19:46:27 -0800 (PST)
Date: Thu, 13 Nov 2025 03:46:22 +0000
Mime-Version: 1.0
X-Mailer: git-send-email 2.51.2.1041.gc1ab5b90ca-goog
Message-ID: <20251113034623.3127012-1-cmllamas@google.com>
Subject: [PATCH] selftests/mm: fix division-by-zero in uffd-unit-tests
From: Carlos Llamas <cmllamas@google.com>
To: Andrew Morton <akpm@linux-foundation.org>, Peter Xu <peterx@redhat.com>, 
	David Hildenbrand <david@redhat.com>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@suse.cz>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Shuah Khan <shuah@kernel.org>, Ujwal Kundur <ujwal.kundur@gmail.com>, 
	Brendan Jackman <jackmanb@google.com>
Cc: kernel-team@android.com, linux-kernel@vger.kernel.org, 
	Carlos Llamas <cmllamas@google.com>, stable@vger.kernel.org, 
	"open list:MEMORY MANAGEMENT - USERFAULTFD" <linux-mm@kvack.org>, 
	"open list:KERNEL SELFTEST FRAMEWORK" <linux-kselftest@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: 7bsm3bcrgwun84rp1kfuqyo873b3xyre
X-Rspam-User: 
X-Rspamd-Queue-Id: 6046C16000B
X-Rspamd-Server: rspam01
X-HE-Tag: 1763005588-257893
X-HE-Meta: U2FsdGVkX1/IGOMu/cj9KMHsmGGb1NwoXf2aB0SiQ07+zu9vTmW3o8k6DawaFvunz0ZI2MXerlKNniyJri2jBjYn4cgkX1ZqdyT+N4Ss71ktdeQrDconynWEyD8afO5zRnWHnsR9OQWNJBq3LOgeQfFavRM6hEEES2vNdQYHNivyNqaMf1hQyPAJrzYUGvnxcVDqgIieI8jqMpqHAyFRe7HkmKly5+lx3O8+ZTgDABRh5zWv44ITKqAf+VZ8fgYuU9ojtuFMgvhe/4Y3w6mtRqtWQyDGxRkANEICUb1ulDbM6RoEuc134uZW5ngItL9s6WkHUxWckZ9N2b4C2S34NudHHlBFeb8OjS5nwdg4++1UcQO9XrdP9PrIgCroXTCtCH3vwi+nCZpFPnt+fBZL8tCzy15FwHx6owRqCMen1pYJlLe79pSHR6t/hf95fV6I2Q7F/f157g9F5RyIzoDMv/6rc0/ow4QMBAUyb8gdoS/qnIB6fGdJBDX5uhImY4ErO+yR46ddg9ondNXkX+Til7HuLSk67ypU4aOCYkW5JaEWNQdpfyzLA4RDstx3kH49YEC4vEiqey0m6NrQxo7otElLaevHUP7n9TrVYBVw+dQOPR+GM8arZAURNmJGFK7LWHPW6TaHCOx27cMzEdLC5LMVVzGorHt/WTIhobATCBtG+aGRPw92dRSgpDPhUBatiEcF/uEs8H7ojT2ln9peaqh8Txl/s0AahJ8vjSzAVCmG6m3A0bBuDywr+CUW2FXRgL0vggWjnwoQATX29ApTgtMAsalfoIqOKu9OH1kKHAnw9uUEgvbbLOUgJlNQZfohxggKtFjKAl+nXDlN7CZel2bcBGhVNNqYMq8Tnz2rjj5EU+9ZP0uy+xrTUNzzW4DEwl2WtiVvYp1f7HsS5ZYWXrXE3VE1dLwcyXn4LIhNcEpnmV58xmDQAOA+0KZ3L3X0act8fyJeUaqw6E1NbN6
 Iu+y9J6i
 s2EFWaKkXqSAG9LYGsTEq90dBty0yPJLZSuCSN9Ym9ZiqzDA5r5QbbSP91pBIZL0culI6fdGeBErhFJmYSznxlEj8xV3eS/yjoR+wtdLwGGAv0QDI6R5O9HkLz1+PFHMeahPyihrE3SlSqrctH9R3zpVSeLbQe+X+gIItv+eM/ecCg0bYLDp7ft7Ornh7SCTS+qjDuGMjpF+bqVF4SJP36NOp4FnrcCP5vjJ1nsQB8vkcKluAEUZSzZK1s82uwoGYeAAsewnVO1qO/zkggDOseRhfTbJd/KNVCbRmSPlX2jgEr2+dnEeFJnFWtmv7CdVSe4EZ87Gt04KaVfsrZDVp5kIdGtgUqoxASoht0rlWdfC4HK4wyRQm4Dcmj2H58enebNbcQnNIXFsHMiv7T9ncGxHfExBOCqNcIKb3L/KPuXJD+OC9YzEMz1c637p8/txRHn7knOBDqjzaSliYsX1jAdURYDD1RwHWplsST64h4JMUZM3cbzEetBWCdjCMOwyNa4rYZzdiT+pNQ0R7aGnemC37jASQqBVj3u1sxoPZ+kmXl6SniZz/jc8I9H2OfRAgytxKejXCjz/jnDQOQ9xWBu8Xt5giXh4rHWgNEfC3E+mYs0n/e/qjS4Vlqmfot/yNmWa+70qebqN53jW3kRdZdKH+Xw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Commit 4dfd4bba8578 ("selftests/mm/uffd: refactor non-composite global
vars into struct") moved some of the operations previously implemented
in uffd_setup_environment() earlier in the main test loop.

The calculation of nr_pages, which involves a division by page_size, now
occurs before checking that default_huge_page_size() returns a non-zero
This leads to a division-by-zero error on systems with !CONFIG_HUGETLB.

Fix this by relocating the non-zero page_size check before the nr_pages
calculation, as it was originally implemented.

Cc: stable@vger.kernel.org
Fixes: 4dfd4bba8578 ("selftests/mm/uffd: refactor non-composite global vars into struct")
Signed-off-by: Carlos Llamas <cmllamas@google.com>
---
 tools/testing/selftests/mm/uffd-unit-tests.c | 15 +++++++--------
 1 file changed, 7 insertions(+), 8 deletions(-)

diff --git a/tools/testing/selftests/mm/uffd-unit-tests.c b/tools/testing/selftests/mm/uffd-unit-tests.c
index 9e3be2ee7f1b..f917b4c4c943 100644
--- a/tools/testing/selftests/mm/uffd-unit-tests.c
+++ b/tools/testing/selftests/mm/uffd-unit-tests.c
@@ -1758,10 +1758,15 @@ int main(int argc, char *argv[])
 			uffd_test_ops = mem_type->mem_ops;
 			uffd_test_case_ops = test->test_case_ops;
 
-			if (mem_type->mem_flag & (MEM_HUGETLB_PRIVATE | MEM_HUGETLB))
+			if (mem_type->mem_flag & (MEM_HUGETLB_PRIVATE | MEM_HUGETLB)) {
 				gopts.page_size = default_huge_page_size();
-			else
+				if (gopts.page_size == 0) {
+					uffd_test_skip("huge page size is 0, feature missing?");
+					continue;
+				}
+			} else {
 				gopts.page_size = psize();
+			}
 
 			/* Ensure we have at least 2 pages */
 			gopts.nr_pages = MAX(UFFD_TEST_MEM_SIZE, gopts.page_size * 2)
@@ -1776,12 +1781,6 @@ int main(int argc, char *argv[])
 				continue;
 
 			uffd_test_start("%s on %s", test->name, mem_type->name);
-			if ((mem_type->mem_flag == MEM_HUGETLB ||
-			    mem_type->mem_flag == MEM_HUGETLB_PRIVATE) &&
-			    (default_huge_page_size() == 0)) {
-				uffd_test_skip("huge page size is 0, feature missing?");
-				continue;
-			}
 			if (!uffd_feature_supported(test)) {
 				uffd_test_skip("feature missing");
 				continue;
-- 
2.51.2.1041.gc1ab5b90ca-goog



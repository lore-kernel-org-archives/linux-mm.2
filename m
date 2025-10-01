Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EA3E5CAC5BB
	for <linux-mm@archiver.kernel.org>; Wed,  1 Oct 2025 17:56:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5277E8E000B; Wed,  1 Oct 2025 13:56:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4FECA8E0002; Wed,  1 Oct 2025 13:56:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 414A28E000B; Wed,  1 Oct 2025 13:56:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 2D9E98E0002
	for <linux-mm@kvack.org>; Wed,  1 Oct 2025 13:56:40 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id E55561401E8
	for <linux-mm@kvack.org>; Wed,  1 Oct 2025 17:56:39 +0000 (UTC)
X-FDA: 83950300518.28.63EA265
Received: from fanzine2.igalia.com (fanzine2.igalia.com [213.97.179.56])
	by imf16.hostedemail.com (Postfix) with ESMTP id 3BB1C180005
	for <linux-mm@kvack.org>; Wed,  1 Oct 2025 17:56:37 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=igalia.com header.s=20170329 header.b=dD3pr7mI;
	spf=pass (imf16.hostedemail.com: domain of mfo@igalia.com designates 213.97.179.56 as permitted sender) smtp.mailfrom=mfo@igalia.com;
	dmarc=pass (policy=none) header.from=igalia.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759341398;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sGokdKfJ/nczLFQrrcykX4jGc1e0TlOvSMvafR6R/Tw=;
	b=ssjX5QeSLE0jaWEMeHiJpKze/sGyRNsz9OdFDjity7B5h01dThik6QyJbO0b2CHsArBLbn
	Re9jYlLZPYftywii274jLecRkmxHGw5Gi1E7kpKxwt2c7s/DlvXcNUCfIcR5ZORBM5c8k8
	5Vsdp+5gicN3W2VMg4A97diGReLD1qk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759341398; a=rsa-sha256;
	cv=none;
	b=AO78N0n63RSE2rGm9iVKPp9jNnWCM68UG49k0/5yevZ21BzzpnNXf0VzkuZO6Gi/GBYUbG
	lwXowLqACNH5fnDvoAJxGCKSL1wKrZNS7q5ETraBXPOYpe9BWsq6qY2Rdssz7GDvdTA2Df
	FwP56xvxMr/z9lZesTNydvh+Aw9vlU8=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=igalia.com header.s=20170329 header.b=dD3pr7mI;
	spf=pass (imf16.hostedemail.com: domain of mfo@igalia.com designates 213.97.179.56 as permitted sender) smtp.mailfrom=mfo@igalia.com;
	dmarc=pass (policy=none) header.from=igalia.com
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=igalia.com;
	s=20170329; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=sGokdKfJ/nczLFQrrcykX4jGc1e0TlOvSMvafR6R/Tw=; b=dD3pr7mIhhMXSbQjUnGdZ4gU/a
	WIt+5Qj6yv0UttvV4urtza6p349IrHhOZ0v6rGXhavI/sRq8V3HJx8wUKNY6fJMwbuI141X/hvjMz
	GsbgA5WTysJ7NLtlWWOKgtJbNbJKOtubZkSi7b7fGGRFPsG8pLb5TYqQ3Ugkmu0Rwfpf4eJv9M65R
	FWEJV1Lk9Nelf7VCvLG3uIQyq34Uij81y9B86ziWh9sn7IxKL/zwZV/2H01SV0kJQ18aQ81P7d0zj
	xGr18N+9DMT+PGVhKD+8q7eMGAVtTXKYupAyS+1wnOi43dkyqxmnzputIA88kHicQAHQYS+OC0X0H
	Gqj58U6w==;
Received: from [179.159.118.139] (helo=localhost.localdomain)
	by fanzine2.igalia.com with esmtpsa 
	(Cipher TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256) (Exim)
	id 1v4144-002xd4-W0; Wed, 01 Oct 2025 19:56:33 +0200
From: Mauricio Faria de Oliveira <mfo@igalia.com>
To: Michal Hocko <mhocko@suse.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: Oscar Salvador <osalvador@suse.de>,
	Suren Baghdasaryan <surenb@google.com>,
	Brendan Jackman <jackmanb@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Zi Yan <ziy@nvidia.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	kernel-dev@igalia.com
Subject: [PATCH v2 3/5] mm/page_owner: add debugfs file 'show_handles'
Date: Wed,  1 Oct 2025 14:56:09 -0300
Message-ID: <20251001175611.575861-4-mfo@igalia.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20251001175611.575861-1-mfo@igalia.com>
References: <20251001175611.575861-1-mfo@igalia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 3BB1C180005
X-Stat-Signature: xo8pwznsrpy4cch54yfczu756uxnn7uc
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1759341397-433934
X-HE-Meta: U2FsdGVkX1++0Dk4GxcXaZQZaqgfvsgJcZfJR08Vq3k4vvhBMCRRogli1iLYVth4fsad2KNpuuCvnnzMljvm5ok9wsttYXWHxmf3fDCVCt9ZqdYauQeL63xe9gIClvYy3OhIU4EYGQi2Na7/wQeGEZJiwdRVAFXNh3/wqB4tBKuY/yJPP3ygKpaEBmiPy1H2sv0XJBDjxWQ1XsrWRNRWYfJVAopmy9moga/sHxuh4uRr1ZASH/W8WD9G7TXyYugohbFYr8D9YY85jrqd9maD/LvSUcbiL9FVXITssetFE1VqOORHmYyc7GHwE+QgrNvSEqBNKzsOgJGH6crt7+0m0kO9lkVDb55I15xqYzkRH+HAJJ7+du3TH82Ip4JTU5W1WesX9yKQ/eCOhVI8OtTMLTwrJNAVtICP2v52A8UO7VJ5X77LRzpnp3ELaOffmKHnbtOrpBdjK9yg1KuKMqpEh1TamSD/1KQ2I+koUL149Ys70FYmMCoXZk6r6VtaYYXC86D3RP9+V9f/xlHYc6lxeYZwSUCMTqjNRHfFTYtkTR4k3gAxiL2R4dEuLSOcF5yn2ZPeARweG27xoX3KkgUSN/D1C7aDj9tXWEGswdb5sLHsxCACZkKEtyjZHUMXszpOVbKJEJaqN4whDipJGfiBguPDThY44HsEvudU5W351U76TsVSHo3KEXZWJSDfkr/obIAhDEEFSa6Ceq7JlLsQwfsWdeJCgYRHYRysClg59zjLt6fCbyN/LVX+XiT21RkK4nC+GotB2uzU/cbnhm63sbxFBaAkJZJhrp9e0YY61435m39iMCKf2mdsQTkaL57IWvp3RJsOigO9LtEyI+lEtt7wEGR7FP76hHjxU//j1I0jBT8BYE1lH9aqGB+zOvUoGzw1IcVBRTDUM81LGm5Van4pCNptF2uZ8Tdq1c6fX66OL6+BfR9Ov0xbX2ZVEOHPg3qSP+2BQyENZ6adIBu
 OlcHlVJ6
 v9M7v41fwDauDqLtTorYjDJYeHG9HwV0supyLsUKdGbqnYFsTYw6K/1vT5fRH8in/PrjjpZHFYtzoaX2WFhCfR1exHIHdj1BPclUZTclmb1Y3Ppi5KqdgJZUxqrzOwZtlgueBJPoFYmIydmbSifvcD0OEXnWVRjqCNWFgiWY6zQr26nwwp7LpLo3IBFKtOSP0TeAgopw+5IFy4476AHcIpXZsfzgyWj8L9+mEz3toAgrRbjiyHCIQ6WpHXsdsDSqJgnQq7iRrQRl+AbixQccBiC6Xg65Mc6uYc20mh29ksNalytHQUzcQstq3R3em2ve9cNGz9MSkQIgoM/q9ZYwU+lsM470TVb9iixYa
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add the flag STACK_PRINT_FLAG_HANDLE to print a stack's handle number
from stackdepot, and add the file 'show_handles' to show just handles
and their number of pages.

This is similar to 'show_stacks', with handles instead of stack traces.

Signed-off-by: Mauricio Faria de Oliveira <mfo@igalia.com>
---
 mm/page_owner.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/mm/page_owner.c b/mm/page_owner.c
index e983ac21a4db..5d488fce0e3d 100644
--- a/mm/page_owner.c
+++ b/mm/page_owner.c
@@ -47,6 +47,7 @@ static DEFINE_SPINLOCK(stack_list_lock);
 
 #define STACK_PRINT_FLAG_STACK		0x1
 #define STACK_PRINT_FLAG_PAGES		0x2
+#define STACK_PRINT_FLAG_HANDLE		0x4
 
 struct stack_print_ctx {
 	struct stack *stack;
@@ -921,6 +922,8 @@ static int stack_print(struct seq_file *m, void *v)
 		for (i = 0; i < nr_entries; i++)
 			seq_printf(m, " %pS\n", (void *)entries[i]);
 	}
+	if (ctx->flags & STACK_PRINT_FLAG_HANDLE)
+		seq_printf(m, "handle: %d\n", stack_record->handle.handle);
 	if (ctx->flags & STACK_PRINT_FLAG_PAGES)
 		seq_printf(m, "nr_base_pages: %d\n\n", nr_base_pages);
 
@@ -992,6 +995,10 @@ static int __init pageowner_init(void)
 			    (void *)(STACK_PRINT_FLAG_STACK |
 				     STACK_PRINT_FLAG_PAGES),
 			    &page_owner_stack_operations);
+	debugfs_create_file("show_handles", 0400, dir,
+			    (void *)(STACK_PRINT_FLAG_HANDLE |
+				     STACK_PRINT_FLAG_PAGES),
+			    &page_owner_stack_operations);
 	debugfs_create_file("count_threshold", 0600, dir, NULL,
 			    &proc_page_owner_threshold);
 
-- 
2.48.1



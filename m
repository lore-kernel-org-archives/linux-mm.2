Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2A62560A6F74
	for <linux-mm@archiver.kernel.org>; Thu,  5 Nov 2026 17:18:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=K9O2G8Yz
Received: by kanga.kvack.org (Postfix)
	id 3856A6B05B1; Thu,  5 Nov 2026 12:18:08 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 35CB56B05B2; Thu,  5 Nov 2026 12:18:08 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 29C8B6B05B3; Thu,  5 Nov 2026 12:18:08 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 08D606B05B1
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 12:18:07 -0500 (EST)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 85EA480BA7
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 17:18:07 +0000 (UTC)
X-FDA: 85401723414.24.82FE41F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf08.hostedemail.com (Postfix) with ESMTP id CF81316000B
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 17:18:05 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=K9O2G8Yz;
	spf=pass (imf08.hostedemail.com: domain of sashal@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashal@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793899085;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cnrI57QF8Fc5FVL2hKHHxcPlXuuT1mdxMhbpS4reWKA=;
	b=GQyetDaG/BXt7mQnYZyMYzYZuaCrxCXhhpWhR6rdZafDtqI3W+A6N/cvx8fdNKuJa1ZAQg
	TxHqcbCLm+UaKpg8NlpDPfIrQZ/zR3dG9GXHSlMJ0yKCrSpsibWOCONQ6fjWtss8cN4CiA
	aCDNoIuzAhRiC7CI/qm0udXEVQv+w1g=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793899085;
	b=myNMc9/nlyr8ngF8M9GmXWuNdDtK+9w7feOLlPA7fF8iRKobVRedrM4tv+iwGIX61/Q//s
	f4X6hmmMMeAfoUOBPTfGOJC9T9feJsmHBY4Gih4gZjPHArwOmmOzouvn98r9nbwaQH4eTX
	EgYmjya2ngwXC8XRnERgdNUd6O+fo4c=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=K9O2G8Yz;
	spf=pass (imf08.hostedemail.com: domain of sashal@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashal@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 03E5741259;
	Thu,  5 Nov 2026 17:18:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC5681F00A16;
	Thu,  5 Nov 2026 17:18:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793899084;
	bh=cnrI57QF8Fc5FVL2hKHHxcPlXuuT1mdxMhbpS4reWKA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=K9O2G8YzRnYSIuxoW620dpj0bwh2tsHqX6Q6mq9Aa9yqXIBDoh3pqyBDD1QhJyabn
	 uXNtwhGZHZge4HH2lwIJ0LEaxGiKbCcB/tPLNiPYmqMIYSOi9d65AVJA+SgWSvSuvx
	 WZ7tA4QXTnpROLoVyKInfLQi6NwI73FKb/m/SLwlyxEJ6EyJyZbzgShjvVH6CaTo2T
	 0ouR1dLrPKVvnya415WLSD7KYfGmQacuH2LC6Mz3WKRZ2Jmp420gYP/N3kHvmbLiaw
	 abMwxm+neuwWqd2RQ8aUdwdaanflIF4cdWPXeCJAYy63QbElg0aRm+RmUWfJobURT5
	 I708fgiz3cOFQ==
From: Sasha Levin <sashal@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Zi Yan <ziy@nvidia.com>,
	David Hildenbrand <david@kernel.org>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Nico Pache <nico.pache@linux.dev>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>,
	Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>,
	Usama Arif <usama.arif@linux.dev>,
	Kiryl Shutsemau <kas@kernel.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Shuah Khan <shuah@kernel.org>,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] selftests/mm: add CONFIG_DEBUG_FS to the config fragment
Date: Thu,  5 Nov 2026 12:18:01 -0500
Message-ID: <20261105171801.2189772-1-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <4B926B36-D797-4861-B6D6-27E8D7870287@nvidia.com>
References: <20261105030242.1241448-1-sashal@kernel.org> <4B926B36-D797-4861-B6D6-27E8D7870287@nvidia.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam09
X-Stat-Signature: jii9dqynqqkt6q3zsya7gd8i65us4baf
X-Rspamd-Queue-Id: CF81316000B
X-Rspam-User: 
X-HE-Tag: 1793899085-308256
X-HE-Meta: U2FsdGVkX1/AgopXColccLooTWpzmPKYG/Nm3ePLmHZF4w1fyj9bwkNiGANbAPgcCAFNMXkV1kgz9An+LFnJI+7Fgf3Nr4REoM5ec1hJv1VXcpIssJFJFN4Qvc/Ly5xeA4S2Il7YuagSPwpl+WA+/btxqRfnnaPwx/nk5eZmIs2P7nZSroABfyHdj99oW2QdlmXHZCMKAYKy78MLXZAjj3jcuAdjKiKB3iUiSpHGWxk1DrUwN5MqS491NvLHcIofchPQiFTJUfpZFutiJtS3Ljzaa10V9of7eLpo2iKlCwicrgFyUwm32EWKLFZ0jJP5EwSHOEp0bpk09QH7UXHJNWBglwhX4lBmwCEEf+Mq7WoQmYaKSbL022gLV0Hzlg4rlWagi34MfaZvdXgnIl0RfKiAj1ppn405bDyuRW1APH1S/tYCevrGS26OHNMLpCphXNSrpe6TL8kRpoOBSMRt22JxdWAKFygKen1bEr6HrGzECEIwwJ08iJlBX87wxmLBEyFpEg/8RtVzyNQMr9K3weWocfLPbLEOanDqgS5xTrHlZY4XyQ24uxWtFVKpk1nhpLo0yNePFjstRs+1DSwgMivAHWzYJXKhHyvFGhIMbPx5YIOv+UaD9UAm9/AnqKzPLZKfw6p9b/tUKNB3VrtZZA9hG7fJrFHGurUzqRd9EqtwQOM0E9Jbp/hC5A69zVKG9QBaAR5qEyemrR1x9DHKYUV7XH1CMkHsMAHGCq6yl7o4VhqZzK1LEDeCpu1oMmNG2pcfd7d1BYlif8AoZd+WmU7cspRUOiI8VDzy/chMtOq7kLpHFIevNB5q42QPQIoDcCTrGOw2BQcxRgkjWVCbwnCqr5jjUrfKMpRIJgIH5NJcwJVwvIArBWC28XQX0QXTeaMB9NrhREBCPyGxzojaZ3rcPOfeckwHFvJVHMAuBLyKGXdO4Exuz7IVWNZoBKhCuTxU5wx/iWy0DrLicyl
 vpjMdXJt
 QuyibSenPHcN8UG2RLZAaU6YOd9gxVnBd8J6sgyNSCl9j7/BF7oMHpengwUNA0oxIBjAl6BBSMFnZmmPqLkotH2KMlYEALmPlN4UVOa3crv47ix92DRNx5TojgZK9uvuakqQA7a511RdYfPawbR1YNGq/E9mWFGeVr7OyEgJu8EC8BwQ69Oj1bJBJYJ/pbggWC2v3w980PhTxlZ7f93yb0LuYoInRDhOuqltnJ5Ld+xuOyQL8AfrdrUFVvpA1HQkmdE/vPLdG/3BbIitdYRWsqCZCR+at5mJycRypwlzZGokCa4qWohvV8mbSdw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

The split_huge_page and gup tests need debugfs, and CONFIG_GUP_TEST
depends on it. Add CONFIG_DEBUG_FS=y to the fragment.

Suggested-by: Zi Yan <ziy@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
Merged into an x86_64 tinyconfig, the fragment leaves CONFIG_DEBUG_FS
and CONFIG_GUP_TEST unset without this change and sets both with it.
x86_64_defconfig already has CONFIG_DEBUG_FS=y and is unaffected.

 tools/testing/selftests/mm/config | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/testing/selftests/mm/config b/tools/testing/selftests/mm/config
index 06f78bd232e2e..ff85b358d04cc 100644
--- a/tools/testing/selftests/mm/config
+++ b/tools/testing/selftests/mm/config
@@ -4,6 +4,7 @@ CONFIG_PTE_MARKER_UFFD_WP=y
 CONFIG_TEST_VMALLOC=m
 CONFIG_DEVICE_PRIVATE=y
 CONFIG_TEST_HMM=m
+CONFIG_DEBUG_FS=y
 CONFIG_GUP_TEST=y
 CONFIG_TRANSPARENT_HUGEPAGE=y
 CONFIG_MEM_SOFT_DIRTY=y

base-commit: dba8aba0a9a00ff781c03d82ae534fc6f8c2e263
-- 
2.53.0



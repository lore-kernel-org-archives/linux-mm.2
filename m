Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B2E73CE7AEA
	for <linux-mm@archiver.kernel.org>; Fri, 14 Nov 2025 11:14:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 095468E0014; Fri, 14 Nov 2025 06:14:09 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 06CD18E0002; Fri, 14 Nov 2025 06:14:09 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EC4348E0014; Fri, 14 Nov 2025 06:14:08 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id DC26B8E0002
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 06:14:08 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id A492B1602FF
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 11:14:08 +0000 (UTC)
X-FDA: 84108953376.22.BB8B443
Received: from out-180.mta0.migadu.com (out-180.mta0.migadu.com [91.218.175.180])
	by imf06.hostedemail.com (Postfix) with ESMTP id E674718000C
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 11:14:06 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=L48H43W4;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf06.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.180 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763118847; a=rsa-sha256;
	cv=none;
	b=t7VR+hFFha6yN3vrPwTgOLpC89BkqIP4q9dpPbf1XdhXhWcSQMH41dYhr6w1KEnSmomn5Z
	4iJc0G0Gh3UGK8x0DC4UbAu1qAlQ5+Lu8XVPtYOlMCA3xQQD4imp8nomlThEHlMfGuFIYV
	MEmLxVn3HE9ivqac4M0upxTUxxiXkxo=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=L48H43W4;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf06.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.180 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763118847;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nUnrWplutHBzvgR2dvaxPt91n3EUIlT8RN+kjzr9YeU=;
	b=A0680NvKAAB7+fm49Q6S1uX9dgVDvms6Pe06GQPQ0KI38XT0nTsbdklYyn0xRIFw/U/cc6
	33kZ7OJh7SVqU7UYJlN3YOqC28hbLfiw+YJJtVUB8CuW0gHGjMw8fwaOlCynzreqFvzgh2
	5TKAkCzrm0y217R4jG+3kSZ2Ne/2nBw=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1763118845;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=nUnrWplutHBzvgR2dvaxPt91n3EUIlT8RN+kjzr9YeU=;
	b=L48H43W4jFZRnZVw9O79JRiRB5m9aw/GV0MPdZjIrgDSOzS1xJajXCccgoMGVVyjHQVMx8
	ixGDGcGZ9+fwVuXGogoz7wJwNfE66muSzsaVj6jY+ONOTTSdEs5AZWkbAoLKzZN3TJkNEr
	SLREeZzO+x0CEbQrd41ME+/n9u8TpH4=
From: Qi Zheng <qi.zheng@linux.dev>
To: will@kernel.org,
	aneesh.kumar@kernel.org,
	npiggin@gmail.com,
	peterz@infradead.org,
	dev.jain@arm.com,
	akpm@linux-foundation.org,
	david@redhat.com,
	ioworker0@gmail.com
Cc: linux-arch@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-alpha@vger.kernel.org,
	linux-snps-arc@lists.infradead.org,
	loongarch@lists.linux.dev,
	linux-mips@vger.kernel.org,
	linux-parisc@vger.kernel.org,
	linux-um@lists.infradead.org,
	Qi Zheng <zhengqi.arch@bytedance.com>,
	Richard Weinberger <richard@nod.at>,
	Anton Ivanov <anton.ivanov@cambridgegreys.com>,
	Johannes Berg <johannes@sipsolutions.net>
Subject: [PATCH 6/7] um: mm: enable MMU_GATHER_RCU_TABLE_FREE
Date: Fri, 14 Nov 2025 19:11:20 +0800
Message-ID: <27f173b0fc6fdf92104721fc3daba8d7d9d31e2f.1763117269.git.zhengqi.arch@bytedance.com>
In-Reply-To: <cover.1763117269.git.zhengqi.arch@bytedance.com>
References: <cover.1763117269.git.zhengqi.arch@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: E674718000C
X-Stat-Signature: 5wezx7din4wqa17b9k8n7jhoq5ihiq48
X-Rspam-User: 
X-HE-Tag: 1763118846-720973
X-HE-Meta: U2FsdGVkX19jYUaiT/8U4j/vxoj9391PpD8ol55LkrfaBZwcrAejgdLX3xsZpEJLWsjfgou4S39h8TcIypEbeRFDdYBRhVr3calNEVvn5J06rkeDxAIRru1SY4yqaYOsBAC7qYPOhoylhaLJfT3M02/a9h47/vWn9L19KPKdrR+ppSWtbl4v7iaZSjJp+1rnmGgI7KZ6EXrCqn4MPAkhsR/V6cZj+dbbsHHQenOS4aLWIVQoM2K+DsOZs9SpJ8OVN2KPf9tWVIa54zx1z8hH6S419QkSK56inmc9qCT1M28QSzZABNwEfL5EQT1NoUbgRhJKDMN6DZBa7nZyUrplGQc7sG0nNNQf2r0GoOY8QfLEHcBO4V77HcITUkfIfJlEw7pwWyd5/Y9tgHnmUXDfGK5bHdgZ8MCDIsUEMcS6d9O+9dYey/w7fxhf6uqhYBVTOdcs7HXeqVAEwiyTYwf5Qt9rslm0v/5pCj9QuVGrN2FVuX+dcAQo1crt+Ad9FCCarLcwj/KHNSNU6v7BXu6PN1eL3fbB9KVCutXmCSBRDr8ozMy48aPzkm0XIRyxH/7GYEsVdmkB3xMcWkHaWH6Jp1fM6mzLymJPO4wkSpFsZF6NQ7+QJRm7oI2G67dQH0joR9cCl1olmK+cyV00wTt3LzLbhDr/AfuCk1c56sPa+xXaNWqtYhddcZsn+hPQwDGFJ9+B2XQUgl4c9WGAi7ybGkHsmQmyhcMPbE14OeiJQT0F1NBn/nI8SVYRn6ziquFUbeP0DAskIonpF6bfS1Ln9ykK7pTwVjTy6CTkqfttTvNtbOFqqdXPQgdlppnsxP5PEBcj8hqA5YavKEXHrb7YRUPqAMW5nWVRTfH+keRFnAt6wndkCBQLDoPMJec+IH5C5xf+JUZlVyuVGH9Rt0uoEnZ5NRjhkrGqaIyXu+LOX6Z0nqBGmrSxbxw+KndFwNthhHN6ilhWrZWXqm90AZz
 dQ0l0zPQ
 ecLpuDRN8G6CYJU3JxR+CYWMu7sDOFlajbMvGiawBoZMUc2qN5yzSPGxju95OKTdrqSs9bi2AyB8N/TPj7LVk2LFuUS1R2Be3A9qAdm2zsuN/UwYTAX1HJxfFw+yvSdutwFKbvrwU83hgBu8pwFxy0PcK3xX92/7jRIUNADD/EtoyO2B142rQ4BxjcWzxsml8RBpVAOFaFSEUKgzq1DoweDTnmbZvy2NIZbN9fRc/QNzcddNNY4OSJbMiKlxdXan8R1dLuZ0ZohTQX88/okY9q55hncmfZ1Xtv5oKqvQGNCqdUxBNeq0uhIF9EK3rxEZhoVqEw6lIZIt4YaHv74oai1m1RHrsJ9wzkrNn
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Qi Zheng <zhengqi.arch@bytedance.com>

On a 64-bit system, madvise(MADV_DONTNEED) may cause a large number of
empty PTE page table pages (such as 100GB+). To resolve this problem,
first enable MMU_GATHER_RCU_TABLE_FREE to prepare for enabling the
PT_RECLAIM feature, which resolves this problem.

Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
Cc: Richard Weinberger <richard@nod.at>
Cc: Anton Ivanov <anton.ivanov@cambridgegreys.com>
Cc: Johannes Berg <johannes@sipsolutions.net>
---
 arch/um/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/um/Kconfig b/arch/um/Kconfig
index 097c6a6265ef3..47a41bc77bb24 100644
--- a/arch/um/Kconfig
+++ b/arch/um/Kconfig
@@ -41,6 +41,7 @@ config UML
 	select HAVE_SYSCALL_TRACEPOINTS
 	select THREAD_INFO_IN_TASK
 	select SPARSE_IRQ
+	select MMU_GATHER_RCU_TABLE_FREE
 
 config MMU
 	bool
-- 
2.20.1



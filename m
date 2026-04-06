Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5F05EF46C45
	for <linux-mm@archiver.kernel.org>; Mon,  6 Apr 2026 14:21:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C7EF36B00D7; Mon,  6 Apr 2026 10:21:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C56506B00D8; Mon,  6 Apr 2026 10:21:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B93456B00D9; Mon,  6 Apr 2026 10:21:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A9D456B00D7
	for <linux-mm@kvack.org>; Mon,  6 Apr 2026 10:21:17 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 680AF589C2
	for <linux-mm@kvack.org>; Mon,  6 Apr 2026 14:21:17 +0000 (UTC)
X-FDA: 84628343394.25.F6A2F87
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf22.hostedemail.com (Postfix) with ESMTP id B7FEAC0010
	for <linux-mm@kvack.org>; Mon,  6 Apr 2026 14:21:15 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="F26V/ngD";
	spf=pass (imf22.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775485275;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FXA6sPDV6T7/i7t4cfnDVP9gKpNUMqTULWLo+ZC9cdU=;
	b=NHD5H4Po0ANN1nYKXZVbL6JyK/derdD9E9cHl1zj/HE1a5t+GCQBRUXPtyt7vKTwtRfZv5
	LuG70M5l6dq8VvJ4zqCbXYGOOKSXgqmyG9Ef7iKXyqJ8T2trXZ/XVXyYoTBeNscY4KLXE4
	NZmUXAZi+frBM0Jwt3R/QtfobOLFjj8=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="F26V/ngD";
	spf=pass (imf22.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775485275; a=rsa-sha256;
	cv=none;
	b=sqSiyD7iIM/iOa5S3Y5lsmvxk+eVSvx/gUkUwLxrPY8ThcfDQuk6c9Zh4g2XwMcW/HJ/fn
	QXbVGfkxsuXhOCFwIW088pYatx1nV5rsNrqjE6mwXuu5/tDx7fWLmyuhBY2ATa70Bhd/0k
	EARuZvnW/3YpBYti3DDPaOk+TeyUdzM=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id DA39E441A2;
	Mon,  6 Apr 2026 14:21:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7AFD7C4AF0B;
	Mon,  6 Apr 2026 14:21:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775485274;
	bh=1E1PaJAheFq68IlA7LKJisHu/YP5aoXijmYjIj2LOcM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=F26V/ngDISfUxXDEjbjCfD4dgkfEyZ7yLYKiAYXU3dZvt78HSd6yW8f/Aynk1/ykz
	 dllKi8Ge+eEDBUDSMJcm4pet77fXPNXVfpxmenPaAYUalmvRMQuMqV7m3v5ZEZyk6y
	 CSaDsayvVihY6TsIPfkAQWIlNwpyo5mOUSqxnmEUjPJW79Gn56z7kfUMOCjCzUVFiH
	 mNbeavG5e8L4W1vXgjmAUZFpDHvHIThbOO5blkWTfYvD+gOw9bYWOyjHm4bJjsHrfH
	 zfsvpZ+RvnxS5EuPznLvW10btFFCYHU1ihazksnij/taKvU5pOSgnlHgx2s5Hkukzx
	 UiVe4U+7kYhpQ==
From: Mike Rapoport <rppt@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>,
	Barry Song <baohua@kernel.org>,
	Dev Jain <dev.jain@arm.com>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	John Hubbard <jhubbard@nvidia.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Lance Yang <lance.yang@linux.dev>,
	Leon Romanovsky <leon@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Mark Brown <broonie@kernel.org>,
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Nico Pache <npache@redhat.com>,
	Peter Xu <peterx@redhat.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Shuah Khan <shuah@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Zi Yan <ziy@nvidia.com>,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 36/53] selftests/mm: hugetlb-madvise: add setup of HugeTLB pages
Date: Mon,  6 Apr 2026 17:17:18 +0300
Message-ID: <20260406141735.2179309-37-rppt@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260406141735.2179309-1-rppt@kernel.org>
References: <20260406141735.2179309-1-rppt@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: B7FEAC0010
X-Stat-Signature: kfxnff7178gfnadpfts9zbnp651ti6d8
X-Rspamd-Server: rspam06
X-HE-Tag: 1775485275-624091
X-HE-Meta: U2FsdGVkX1/Lin9rzRQwl8M4hIUdNJ0RUlGYs84eCDs4+CsskFDXI9bjjdp6aisCFLL3CzHggAlY/lecJrCgGeHcaRP1JMzPzL2MSHUA9pCYKTLxLtTbQlkFyG7GxjjNK6TCTqlgg3TnjdExUvIS/z+nTzu7mFq6c5fQck/q901PdbZpZisE7zJxhiTKyP5MnKLK8uvy8iWarV15tBOypw0wJeVWrBXxpG4U703eYauznjRpZBa5qftaNA88j1Xj8gq1vMhOBxx6hiFYL6w1ce8zZxhoeyIg8AVtNH7m3nNRWGc1B2GMGovEUFOuozuK9QvCfsQAHxcRI9fEn1oeoNEgJ6lLlvPwQN+dyBYF5TznWGpE8cUr8KJToxD6QUf1HI7/9vb0p9x75INfBg1C+a95X6qzcEXfANcLe2ZvE7hsY5qUUEzSTR6Q3XJcgOBrlZRvcMuKq5FUsfkFkmGBsK4Z6a2JyhUgc/Xf3UTT3bsOX3V+wsDfGGt29whZRdnBiJEBcEezpvKKaTp2dGO6niDcO5MF8l2vC9nf/1KTjvM30Ol22ghLadkzlV9Hl+guXeD9CtJQWmkirZ1aQiwy2wagB6DNtI5LbBLxTQQxQsmAUHw8H73EbWhJEiHatK/fLtPmY01uaw4SkJ9LI7CmMF8fMav4yByzEu/X2B3VxjlGW9jBTusJ/7/1+NtkC0KZ0/AjRPRjAluu2sD53xvD+4OdVGEe1nrPQXMWyTBfDy6G8PqxBdEhsw53FpOJlMjp+cgUb2KoTYjQNJKcGjMHlLRee56eKvv+mR+/prUxo+XunmVdZFsQZysRn7efWPTEc1feAyRFHyzb7sgSdfzrJM5MtIKgHmjpa7tEe945mNMJOUEo5MHUqwElGJb9DlFdA9aTRI5NxGIyJTHTDFiIUuo3KEN2p3JeipM7g9FiV+Xo9DGkMWkfFeWdMuQDwckyZAIFqtAxiNxzvIru+QU
 BUWOpf4+
 v6+HIPOummC2+TvgVies1FAZrpThLj9NBr41dpZg9SGQqWUptg1+64lOXe3akSNrOy8gTOEFQAGZCsqHqf+4Pf57+nVmFUHmi/8ch5uHJ8zxRsN3IdLb5wA0dDs9n8aJ0hbYUnYdxjpnjBQeK8qSBk3+PSG9SkVM7t057pLFXO5W2wenRPau8M/McOooh4ILBeqHa+TtIiTDTnxnuDEq4GwjIi7XQqG9iAkDhW7tpoX+K8CI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>

hugetlb-madvise test skips testing if there are no free huge pages
prepared by a wrapper script.

Add setup of HugeTLB pages to the test and make sure that the original
settings are restored on the test exit.

Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 tools/testing/selftests/mm/hugetlb-madvise.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/mm/hugetlb-madvise.c b/tools/testing/selftests/mm/hugetlb-madvise.c
index 3c08eb6db6a2..b20648d025e6 100644
--- a/tools/testing/selftests/mm/hugetlb-madvise.c
+++ b/tools/testing/selftests/mm/hugetlb-madvise.c
@@ -68,9 +68,9 @@ int main(int argc, char **argv)
 	if (!base_page_size)
 		ksft_exit_fail_msg("Unable to determine base page size\n");
 
+	if (!hugetlb_setup_default(MIN_FREE_PAGES))
+		ksft_exit_skip("Not enough free huge pages (have %lu, need %d)\n", hugetlb_free_default_pages(), MIN_FREE_PAGES);
 	free_hugepages = hugetlb_free_default_pages();
-	if (free_hugepages < MIN_FREE_PAGES)
-		ksft_exit_skip("Not enough free huge pages (have %lu, need %d)\n", free_hugepages, MIN_FREE_PAGES);
 
 	fd = memfd_create(argv[0], MFD_HUGETLB);
 	if (fd < 0)
-- 
2.53.0



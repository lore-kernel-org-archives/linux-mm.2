Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A2BDAFF885A
	for <linux-mm@archiver.kernel.org>; Tue, 28 Apr 2026 20:46:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 191B66B00D9; Tue, 28 Apr 2026 16:46:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1683E6B00DB; Tue, 28 Apr 2026 16:46:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 07E836B00DC; Tue, 28 Apr 2026 16:46:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id EB13E6B00D9
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 16:46:50 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id B8BE9A0358
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 20:46:50 +0000 (UTC)
X-FDA: 84709148580.21.8E09478
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf17.hostedemail.com (Postfix) with ESMTP id 2A90D40006
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 20:46:49 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=PRU3DXRA;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777409209;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xZoDhbWNEouwgaGlkfkUpjJoSc42y7xWd91vFax7+2Q=;
	b=PeSwkMUS9+rDP+sndJvfjw3A3phnn3E7RpJBlf5fTRsq7gpQHV8qzSp/4m/9TI839aJYMV
	XsCzMIYRUUYahMj+wQkr4Ie27J9E1EDC3fpELz2hP6jNmkACmkEHxqXI6ZRLPpT0+rwTzz
	9R0Z69Mxd1zpEdFt0jcRdxXJMQ28SE4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777409209; a=rsa-sha256;
	cv=none;
	b=C9QNOoe/pJzY88seW//4OB1+dQl5m3BaJk/ZlQAMv3jgmJJFNCZYehDABjtIM1CyDtwkuV
	DaK/NawSdIQ67GzmzEoijIKa3H/BZiT21zlR5HoLieNy4/dCF2mb4Oa9NO5JjEJDIwM74J
	RbOmXXr++qJxK08LWxlrGsQvroBATVg=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=PRU3DXRA;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id A8DF461334;
	Tue, 28 Apr 2026 20:46:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E4D5C2BCAF;
	Tue, 28 Apr 2026 20:46:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777409208;
	bh=ib9LXsJztlT6AS3f5wMdXHDwOYMXkAdeN957x1qT4BE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PRU3DXRA2mjPTJz0dlKDBKxbR8oyutEeJ5qREI7hgZj7tTUBuFefszFirMwxHaZtA
	 wcQno4kZaVZxipoEstFNRT5Kx6+fsqYyjTZeXq2r+uZZ/p9PwSFe7IQwRuDrRPkyHj
	 3k7s3R1pNVsDvBBxWbiqgFyt5/iafBc8nmxOGuREw7X1QZ1ibJ4rfhmCpwKxnJFocc
	 Gib7jpuSTVpA7GOrnpeS/LZ2KSmKYszWeZxfeWWNsvLzC07UiHqaygD+5A3xv78Te+
	 ni1bxIYZndp3tm7D4+ge+z8JMBNAUIcSn0XMAYNfn/WJVbwmWhe8BodXzGn0I3MkAm
	 aJhXzi8/kqPlg==
From: Mike Rapoport <rppt@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>,
	Barry Song <baohua@kernel.org>,
	Dev Jain <dev.jain@arm.com>,
	Donet Tom <donettom@linux.ibm.com>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	John Hubbard <jhubbard@nvidia.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Lance Yang <lance.yang@linux.dev>,
	Leon Romanovsky <leon@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Luiz Capitulino <luizcap@redhat.com>,
	Mark Brown <broonie@kernel.org>,
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Nico Pache <npache@redhat.com>,
	Peter Xu <peterx@redhat.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Sarthak Sharma <sarthak.sharma@arm.com>,
	Shuah Khan <shuah@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Zi Yan <ziy@nvidia.com>,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH v3 36/54] selftests/mm: hugetlb_fault_after_madv: add setup of HugeTLB pages
Date: Tue, 28 Apr 2026 23:42:22 +0300
Message-ID: <20260428204240.1924129-37-rppt@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260428204240.1924129-1-rppt@kernel.org>
References: <20260428204240.1924129-1-rppt@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 2A90D40006
X-Rspamd-Server: rspam04
X-Stat-Signature: g6djdybes7wwp7obt5rucy94efhxhxty
X-HE-Tag: 1777409209-115693
X-HE-Meta: U2FsdGVkX1/Bd15lGN1FbLvCDEzvGbSlIxkd3c+3iAlFu4F7DY28sZxuhUyDmGfYdnY5jckLzZqkEh1vomNDEMj3Ectt5fO33wyN7Jpr+RJhxWBLiN0GvkgR0xzQOCek/fV59cUDeBx+uvEM5NgwcKMHtSrm69nEiFcYjPaNDUqUjpmbdRyQL/iyCWLlzOzMPIKn0nWJ7oxZAs0QKXf2awR4IJdoonE3K/ctq+tcM0/Iog/i4m1kxvv0fJ/6n5k0ZzRjRG1qpHK/zDgTKgkJnaJ7lD44Dg7lrLNljIsRzNgq3L8EkLXn+pBs0ixmgJJtyz/ALfucFi0bVR12rof4DAD8k8cTLGYKrMUb66JQ63dCH2pgODMho7MKKXdhUrG+ePQYc0fs2VeVpGmFXse09qO1esCW5QM+w6gBdshyn9m4X9a5cJ4gIqX3lrJ3Y3uG2p/DilpkqCCw7rUWgbiN3z0J/sWBdgVmD9g9E+sRWA6bJWxjvlLliIxzZiuoAe7y6uSKkq9r6oJwI/ExF+EMBzIWQs8Nrpc1ZX2VVuedsNccZK46YyPVTkh9zX06NDnYl9TkcbRYUO2CNyGZu62N3GN6jY52c1PA4ZhVO3aSPQ31M79kNd3KJuH02yWeOJnqWZyGzRStIFdsTlyP1VKtJvAqZv/4DwAXcdZjNZRS5zjHnrS/VdJUa13LKQC7Ep2zhEDP9TjHdn9wD6yiCPL0m5kEjiMDudnX08oHlNHuk2Dt5sUK+Svb7wjZXSjYuwcO79G/c76dLRXSYFOOBvx2SY2jspeAZ8Clo2IGbMzHX79FrqUIN93JgSjcw4ca5krSL4g/FAWA2vTgLrI/xQ3QbdRs54hhvwsJ5i4+e582O91zV4hGw84fWwcSMUO71U581yr3WRmc1IvvNKQxanq6/KInoeiZcUQQ/PU6b68xrgKYlL1uVcRY2eij4Ozyr3cFajK43rQBW3NlkiPKfWh
 dgfVpXKD
 NSSKldZ9VDHZPQt9+zVJryc8Zoaxs206ODSt9+te5ZRr6NWP5idj3vW7IxdHbyyyEH6P1NITMVv/z3DF66SDktgC9CJ2gLgEMA84Ko9IRrbfDydUUvW1wGJoS0y52q8KuZ14lrZGX1SjckmTQ6Q0pRj/qaM5GT9hD3RNK+9epK55bvF24IRQKLWksdeGJHY4J+5rozu21DolHACFNBdDEBvYmWc+t2yeQScoA8yhAToyybyiSj1Mz+A4h37rnaqTgvwRJ5qoAuO2H4iRs/vMjFf2HH73iZlXb2lGN
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>

hugetlb_fault_after_madv test skips testing if there are no free huge
pages prepared by a wrapper script.

Add setup of HugeTLB pages to the test and make sure that the original
settings are restored on the test exit.

Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 tools/testing/selftests/mm/hugetlb_fault_after_madv.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/tools/testing/selftests/mm/hugetlb_fault_after_madv.c b/tools/testing/selftests/mm/hugetlb_fault_after_madv.c
index c718dd065d53..481863cc5fda 100644
--- a/tools/testing/selftests/mm/hugetlb_fault_after_madv.c
+++ b/tools/testing/selftests/mm/hugetlb_fault_after_madv.c
@@ -54,7 +54,6 @@ void *madv(void *unused)
 
 int main(void)
 {
-	unsigned long free_hugepages;
 	pthread_t thread1, thread2;
 	/*
 	 * On kernel 6.4, we are able to reproduce the problem with ~1000
@@ -78,10 +77,9 @@ int main(void)
 	ksft_print_msg("[INFO] detected default hugetlb page size: %zu KiB\n",
 		       huge_page_size / 1024);
 
-	free_hugepages = hugetlb_free_default_pages();
-	if (free_hugepages != 1) {
+	if (!hugetlb_setup_default(1)) {
 		ksft_exit_skip("This test needs one and only one page to execute. Got %lu\n",
-			       free_hugepages);
+			       hugetlb_free_default_pages());
 	}
 
 	while (max--) {
-- 
2.53.0



Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E4004CD37BE
	for <linux-mm@archiver.kernel.org>; Mon, 11 May 2026 16:34:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5612F6B0133; Mon, 11 May 2026 12:34:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 510E26B0134; Mon, 11 May 2026 12:34:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3FFFD6B0135; Mon, 11 May 2026 12:34:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 2C06D6B0133
	for <linux-mm@kvack.org>; Mon, 11 May 2026 12:34:13 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id E42CAC0A7E
	for <linux-mm@kvack.org>; Mon, 11 May 2026 16:34:12 +0000 (UTC)
X-FDA: 84755686344.06.2A82B15
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf19.hostedemail.com (Postfix) with ESMTP id 652121A0019
	for <linux-mm@kvack.org>; Mon, 11 May 2026 16:34:11 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=lM+7PjhX;
	spf=pass (imf19.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778517251;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ueoixsrAO4+WxOpYwADRosy+SnERZ+evkoQJ6Iz1k58=;
	b=NO0InconLfpM8yYJWjNOmysyE8oBabdO/emZZY33mcqL3yhWW3/EcNqEeJy9w1SF2vg2JK
	nISASeBC/OcTjlO86V3Tr/pCKlArTOE291kLWMGUZjUbrXeNafhQ5oSoV8I5yhP02nF7bD
	VvZ39R4inq3NsJomk5LiCl850w34nCU=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=lM+7PjhX;
	spf=pass (imf19.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778517251; a=rsa-sha256;
	cv=none;
	b=FoTr2ijn99ovnteo1LMCtpQ8lN2pxnKmYn4h7ynuNsMgSDpqn4I6axIKZ1DpGRXrA8UmmR
	mR9SbLtmeV4nKXI2ay3YlF4HSi2SiDET5UUqDpZ+kPIClkYzr4vrlp6Xg+LwdfSAJbf3Sb
	CK4Q1nouNyPhJ7nMXKykSmkTjNQcVaU=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id C037D60103;
	Mon, 11 May 2026 16:34:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 761D8C2BCB0;
	Mon, 11 May 2026 16:34:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778517250;
	bh=yChvoRymHflrXb3JZQRkvSGXKQqYnoAHN1ddQ8bY1D4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lM+7PjhX3EXRh7KJtDecSDPvtHHXxcRwoXr7wlOrINXw0adosyLgo0eTTxlegEGrD
	 BGUmH/pFo3BKKC7sAaiFAWMPE6D4fpWQ1442O5+Nrx7gPdboA/mqXtfx+tCE6oc8i+
	 f1JRwQshJYRGpobjICsnD85mtNwWNm1swVOEYT2VkbtkBzpIfG44E7Mt7V+DlLOpmg
	 ZXvE4rdDNHDKxsGFe9RlEgqipz/akUQfj+j1g9Dx6eUo0jGnRNsu21aZrJDqV2k8NR
	 9ebUqLBWIgUHtSebSnVMaQCx+cr0Ljcs6cJQqfbQZcQ6zn2vz9FQlJhgzErLBXdMr+
	 m01xeNyHx1pzw==
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
	Li Wang <li.wang@linux.dev>,
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
Subject: [PATCH v4 49/55] selftests/mm: uffd-stress: use hugetlb_save and alloc huge pages
Date: Mon, 11 May 2026 19:28:33 +0300
Message-ID: <20260511162840.375890-50-rppt@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260511162840.375890-1-rppt@kernel.org>
References: <20260511162840.375890-1-rppt@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 652121A0019
X-Stat-Signature: 4hcxbzjwn9hz6xiuokthcc789exh3coa
X-HE-Tag: 1778517251-779888
X-HE-Meta: U2FsdGVkX1+QnojnmeMzubspxNUQVKOxTWOU4J4P6B3ORsOXP3w44VLIvtAqYaYf7S3ew28LswMyPzMjqVnA/F37GiLkgFre5QUzoxuAPZEoUO9zJGQdY4gK7y5wTT1QF71H71OxUJjG939GZIm9Jzh0R4q2WaL5ox5tlmwOt3AMBmz5e4tJIQPYPBSkEj8mJ9CxiZD9FMkKMpZqqjIBhuVObhY2JtzZch7aePkcJFvNQoOYA9j0huiuJYH+4E/Zb4hFCYSf1Y8eEM6nRQrrhepzEzrjq3BFOfzTOVqHVnmMt2mLu54EWwB3cPop4c5NNvgmrnaSBzLSE0gjRYCvU4lQdcvTgr/VDZLrl50mAqydsx9Ku2/ZafkembDeKIZKr1VSeXbqDBSwJc18P5YvOznJObuxMaRhVLNiEyM5jvy/RsTNvYuumVGz7dtZCd9ozalpsRDHAfRElI/yoUqJkZseL6IGnxag4nSCCR+pW9kbjMBt/sEwG8QBJMUnEdGp3tpoeifHoxY6g96PqNx+fVz5mhZTybDBylBniEoPW/N3UnkM/8DzIA8YBGR6oRN03ik7vHxpPpbXaWKhT/DNwL6cQ7HdGEi4SgCRqX8Eh7mgmwQOU+9M41lp4c5GwlMWuaLfl7QyMgPy65LilAmkIa3fvgmwuOyo4DQpSuuAnkDN0MKAy7wdec1PNb1N0Vm9uQzpt5SrrqzKMKBuYjqK8h7WV8U6F6GKyxSN2IF1W7iMSDArL+4W9Pu31Cyi8dPYnHTqfUA+wpRmY0ELcgDUZucJ+8cH0WStHrW5Hf2Qwt6ZuiVqkGwqWkacP2d4aMwSgEMJscD8avX/vK0Azpif3Jl8Qqu7HaNOeB56sXeACfCCzz0x/FKwit+dK2Pm/AEq9RQjnKtw8yWv1uIqNrMCK8ZDNnqn5ZDK402m8/9o7uuern7nv94iHHx58UHl9lUievLbG14I3igvWDZ3hgq
 Z6sDpINP
 bqHP3s/HzyCUUJ17pooWnA9ywFxy64XXahCNsnc0B8zKOZkfT1S8d3FqucuWAqAiGycHyqG4dRhUM+PHDeXzJkt/HyZik0AP1nEZF1JXefAUSHkbpu+7sVHB//8X1VTTtkszZ5JsC5gpBQzb0X0V6o5HumkpKxbvg3xna2RYnRRcB4STzbywhZw3vdzL54RFWLonIuo5drYzdUFT/teUW5jcnJfM8NsfENtaAFd4Jt1V1Ux2A/EqhrwXPbdUwv+rdh5vdW470VEnclg1+VmKtf336IaE3Dqd7YLMD03//oqxK8VNRKK9tziC/Jr1Y+cLKQjJt+JO9vAwmT+YSfoUgi4iSQddqH1ED4ftpLHCJyhrRwt8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>

uffd-stress skips HugeTLB tests if there are no free huge pages prepared
by a wrapper script.

Add setup of HugeTLB pages to the test and make sure that the original
settings are restored on the test exit.

Tested-by: Luiz Capitulino <luizcap@redhat.com>
Tested-by: Sarthak Sharma <sarthak.sharma@arm.com>
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 tools/testing/selftests/mm/uffd-stress.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/tools/testing/selftests/mm/uffd-stress.c b/tools/testing/selftests/mm/uffd-stress.c
index 7c719d789249..43cc79590136 100644
--- a/tools/testing/selftests/mm/uffd-stress.c
+++ b/tools/testing/selftests/mm/uffd-stress.c
@@ -480,9 +480,12 @@ int main(int argc, char **argv)
 	 * Ensure nr_parallel - 1 hugepages on top of that to account
 	 * for racy extra reservation of hugepages.
 	 */
-	if (gopts->test_type == TEST_HUGETLB &&
-	   hugetlb_free_default_pages() < 2 * (bytes / gopts->page_size) + gopts->nr_parallel - 1)
-		ksft_exit_skip("Skipping userfaultfd... not enough hugepages\n");
+	if (gopts->test_type == TEST_HUGETLB) {
+		unsigned long nr = 2 * (bytes / gopts->page_size) + gopts->nr_parallel - 1;
+
+		if (!hugetlb_setup_default(nr))
+			ksft_exit_skip("Skipping userfaultfd... not enough hugepages\n");
+	}
 
 	gopts->nr_pages_per_cpu = bytes / gopts->page_size / gopts->nr_parallel;
 	if (!gopts->nr_pages_per_cpu) {
-- 
2.53.0



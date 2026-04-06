Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3F5C4F46C46
	for <linux-mm@archiver.kernel.org>; Mon,  6 Apr 2026 14:21:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A358A6B00E7; Mon,  6 Apr 2026 10:21:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A0DD96B00E9; Mon,  6 Apr 2026 10:21:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 94A6D6B00EA; Mon,  6 Apr 2026 10:21:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 865716B00E7
	for <linux-mm@kvack.org>; Mon,  6 Apr 2026 10:21:52 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 2986713AC31
	for <linux-mm@kvack.org>; Mon,  6 Apr 2026 14:21:52 +0000 (UTC)
X-FDA: 84628344864.22.5BB1688
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf15.hostedemail.com (Postfix) with ESMTP id 52BACA000C
	for <linux-mm@kvack.org>; Mon,  6 Apr 2026 14:21:50 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=mCdMMrXM;
	spf=pass (imf15.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775485310;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=82j2GDo8UgUUYolGlm6QTZNMCQT1YWNRMIaDJGByQog=;
	b=jCBH/pcd1TtgENKs+5iN5Zq06ppjKyDmUURAN4xhUMFx8JKyIi0f7FBRkITDTN7Ltt1AEC
	nOH78ShWxv68/2OBRsVUEdZpibMnSacgigFd801BrZ5GR9foPqAGg77sTKVwlNbLgc4I2l
	nlOvFhKDFJC0kD1cwpI0f3sPBvOfCu0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775485310; a=rsa-sha256;
	cv=none;
	b=BzaaTk8ShdlIymZScym3A1VpbvQueqawAltiIW8Xua6ePTltaQXw6lDUquewh2eeAESIG7
	8KVy3Uduc6jdBXcOw5ipHV7NOccYoCblvQvBo89/0bZbmncwmxusH/Nmv+7kpKhRb527zE
	W1UxQy4novxuhR/PKO4jjHeUeO7cBUc=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=mCdMMrXM;
	spf=pass (imf15.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 768CD40619;
	Mon,  6 Apr 2026 14:21:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15A5FC4CEF7;
	Mon,  6 Apr 2026 14:21:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775485309;
	bh=XUYa2AHXODnUwL+2gtS49wymmJEGg8QhpNWWbUz0fDg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mCdMMrXMCaE63glUC3PQoRjNenlzBJV1SZ2AIQVxmR8JJiom0kW//1iJtNFKUfSbR
	 WL9hfkjDzD1qJeWKlddwetkCAD0dw3ZmORaDZA8t6KPTitUQ3BLlJIAOsAv/smIcI6
	 lchB/kbjP8e+9dkLeEmbcCAIfSE88BKFokS6mis0RfUaSZ49YcRpyTFAEbtrTKkurd
	 88GWj3eoxU/kQSkipFkAC0qR1lEiM8QV8Mh/UPimQRatYTdnJk0c5sSbsyUiMOLEUL
	 VaFy4JtAUPncOEQ5+Y/bMuE25B+6f9ca2M1eBVmmjDJU1u+EVzvqRuSNsrwgGgNy7Q
	 3cwi415eJxxuA==
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
Subject: [PATCH 42/53] selftests/mm: hugetlb-vmemmap: add setup of HugeTLB pages
Date: Mon,  6 Apr 2026 17:17:24 +0300
Message-ID: <20260406141735.2179309-43-rppt@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260406141735.2179309-1-rppt@kernel.org>
References: <20260406141735.2179309-1-rppt@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 52BACA000C
X-Stat-Signature: kmc81qhopgzgcx9ny84c61j4nrg6diar
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1775485310-974854
X-HE-Meta: U2FsdGVkX19A9wuVqk9vv9gtiKKjULIFKQaLfuePmpqGKkZh5JKLOUBTGO0RDsovFZuPZOpX0jnllHu03ApOSESn0AslN/JxyNSl9dDdGNNE76Ozw1ro9j9PNfUJESyvpdCIyIxebsZehrY8EPhdyzMcGur3uAs9NValbxZLdH926wapy4eQu3aMgJwEv/lDmkSCb53OXGT8X0l+fb4okMj+QrkusgkVpBRbZ0cdP+cogK6yyChdvyQ+jK6SyNtm1X24MbvEft15u6DNnvoXO2NylL7zOoxeEKWf8xuI92ulekXYj56bDS73MPYgFx7g0lRmp1cmcmVDC0DDoge59x8lI6OmMd6etfgOQqziGEI3Q+aYHT4ivAYtYo9s1ME56AdZAbIYiXeR9PSVYWhJDTepkwWwhQUFclswTlin9jzFYQjGOivFGf6kl8nyAbb81GrM1BbQj5TP9mXKyyB/12oZLgbnSkic4VjjJBd87s6BKlRe3Py61gflBTK2T8GrKgeufJI6iqQHhQ9VOlQWLcQFh0j+hRIMrOJeLAYPR4XWgT4PUqdwfzhitm11DUfbj7BbTGt8rb4zIoVu4TlzgF9JlXfykhlEL4LkfUfhTwu9eNtZdmVVfGNmrsM92rQP0N/Ge1t4fdTOIiWJiuCcREB1mx04KZHCjOevU8QbVr0ZyBEJEbkL2ZhEUX7SGle9UyXWuBzvfhHd/a7euKxA9Y4w+mgyHGQ9BHaLME0sqfAeTLhX3H+OWuV+Rb5LHMfCbNJ8GZmSaGIghFaOk/VvTLCdxuxnJWGpHvB7wLIZlALD9Qp12vkDP1Y3kikw58iNjm2ZdCX8bX53XfRSkE3mOfyZdVA7RAL+h4bKtDgquT//30GHR5GtCy/bZtb5np+lPQhN9kHCc5tDeas8fPH0CxwkqgsZx4FHWD5yVBPTvhNksOZ53QeR5g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>

hugetlb-vmemmap test fails if there are no free huge pages prepared by a
wrapper script.

Add setup of HugeTLB pages to the test and make sure that the original
settings are restored on the test exit.

Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 tools/testing/selftests/mm/hugetlb-vmemmap.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/tools/testing/selftests/mm/hugetlb-vmemmap.c b/tools/testing/selftests/mm/hugetlb-vmemmap.c
index af5786bebfd1..507df78a158d 100644
--- a/tools/testing/selftests/mm/hugetlb-vmemmap.c
+++ b/tools/testing/selftests/mm/hugetlb-vmemmap.c
@@ -97,6 +97,9 @@ int main(int argc, char **argv)
 	ksft_print_header();
 	ksft_set_plan(1);
 
+	if (!hugetlb_setup_default(1))
+		ksft_exit_skip("Not enough free huge pages\n");
+
 	pagesize  = psize();
 	maplength = default_huge_page_size();
 	if (!maplength)
-- 
2.53.0



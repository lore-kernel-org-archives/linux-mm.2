Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E9C03C982D0
	for <linux-mm@archiver.kernel.org>; Thu, 17 Sep 2026 11:20:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EAD486B0099; Thu, 17 Sep 2026 07:20:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E5E1B6B009B; Thu, 17 Sep 2026 07:20:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D9CAB6B009D; Thu, 17 Sep 2026 07:20:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A790A6B0099
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 07:20:31 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 3D7AF1602E0
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 11:20:31 +0000 (UTC)
X-FDA: 85223011062.13.DFCA733
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf22.hostedemail.com (Postfix) with ESMTP id 730C2C0004
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 11:20:29 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=abJKCI3W;
	spf=pass (imf22.hostedemail.com: domain of sarthak.sharma@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=sarthak.sharma@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789644029;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Wn6QDxHqBbYWS3z1Tne4Sz7nvQnXp50VSfbuxELhNfY=;
	b=AfjWgvR2YEo71TNVSZ3bLlTIVB2ZL/9CrMqbZXheiKZw2pq5UjNtLAHU2i3mdpF0KRGJSX
	59/pBb//kRpaiq7YJ9x+wf3W06k+bKkIMg3OrqBF4JE9pnSYiol4LN/w/LzO8hjvTpB7Gi
	pvBh0Fl6G3MQ2f0ULXxxghjIMFnBe20=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=abJKCI3W;
	spf=pass (imf22.hostedemail.com: domain of sarthak.sharma@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=sarthak.sharma@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789644029;
	b=WLTEtuz3/FH1NmfrhVk5Am0wg1FhO1s1j0L4WjJylZSptIUpIqtPuW4Wt1Nb5Il47mLoVz
	sHLDHJUj7gnpUljJls5ue/TgSMxK7u0Vy1uhWTN8EH6pUAg9n73DJfZNkVxepdVwHNtmFH
	gB4AG2Og+A4grc9rLMGPuh69lJCiT2s=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 0270E1F91;
	Thu, 17 Sep 2026 04:20:25 -0700 (PDT)
Received: from a081061.blr.arm.com (a081061.arm.com [10.164.19.84])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 4426B3F7B4;
	Thu, 17 Sep 2026 04:20:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1789644028; bh=EBDy9kiw0ETUnAFTA1nwc+a5WpGr3AW/5ybohYQb77I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=abJKCI3W5ejqlA1/+Qn5Ky+QWyIO8EvU9TG6NyAWFrVO8SDaurv5n3BuV+0KUhHcR
	 nNjB5ezosZX0vlC9s0hkk27ZqylVrtNdTrcCcPsCb1Jq3MjiwZc3DFRavlFLFaz0Pv
	 OYi7aLb9rvvjhEDVgmX7PXzqpKxlj+3nHy0vi7Jg=
From: Sarthak Sharma <sarthak.sharma@arm.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R . Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Shuah Khan <shuah@kernel.org>,
	John Hubbard <jhubbard@nvidia.com>,
	Kalesh Singh <kaleshsingh@google.com>,
	Anshuman Khandual <anshuman.khandual@arm.com>,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Sarthak Sharma <sarthak.sharma@arm.com>
Subject: [PATCH 5/9] selftests/mm: mremap_test: fail on data corruption
Date: Thu, 17 Sep 2026 16:49:47 +0530
Message-ID: <20260917111951.188266-6-sarthak.sharma@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260917111951.188266-1-sarthak.sharma@arm.com>
References: <20260917111951.188266-1-sarthak.sharma@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 730C2C0004
X-Stat-Signature: gawrjjzn8ez6z5haa7rp6kmt4qexeaho
X-Rspam-User: 
X-HE-Tag: 1789644029-889459
X-HE-Meta: U2FsdGVkX1+ZlvJSXPiFM4LaF+ypy1itNFkIGpcx1jeH3xDy2A+zxJaQlyIeVp5S2wGgpU7WGoIAElPrVBVU1f9Gff8N815aZLp3FLbgVRMZocrXq+LbyV6IXhf+yIyhnRvy0Et2ycKYWg+V+FRhBU4mX/f/z9IUUre3MA2Yg+qc0a5BFcS85DsO6yFVtd013sc6PULaXnY74CVuyji7QetguCpfGtwImZ/PNVcbCKZP6wjlpJ3GTZopWV3uhhnzKMQ34aeNElD2lNAxey+VQbA6Vr0sz7VsWMt4XXFncEhrZm1j9BvQ9uNaZnyqUGaskkgPzl2kuI5DXbq4xxFVblkFB+QBMftali6208mTfKrXIJgd/aVFzHg8SpYKXZ+6bPAEvBK8FnmQjlOHlsXklE4uicEn/Jcy5arnb25fyA86OhOr3wfoi2Qq+1ziRN5k5h9r5lIAZIbpkjiREIKqbSyH5A3g8ZP3nKniPTrmCElDhSY2pxT17mERXoBo3WCUPseOldDuT8AjgGHCLW5lHWz4QWfxVaGXZpY2PzNCTC6zwOpdio444Ls0Wog1brO5M4YsBc0PLr1FSAsxMNlh7iMnIyADD73VZDjk2ACG3qaitCSTcqOADO3d2RvT1YBENCjq/O2BtgXsAIakyuSS579pkrR/Ep+4Jb2vlu8ylTmUROexe1TVwf9dlLfYWLO6A7oRMWO4UeHZH28fJcyoTBfM6gpOOtqnqFXDvQe4eT7GSygZxoa6gX9gTivJbmFDm5cF2u5vCLYEwDvYP4gmdQ97xtfOvqBfM5rZ2WAayRhkfZ97Y35BV3KGBhw/M/NsgUdZPMMY8gyfcsD3uZabVDPpjv4PZtNiwx+ArZPsL7nigfLaGbyuGZeckqj9VenYyJL0EvGdYXukggxzo6JmA+XnYfrxOr7sEYGGtaF4NiaUaajdm+dgbDLyEuMFOdfVsxrOl1raSO9MB+4s8Yf
 5WZ/HjCv
 r1jwJQgOEcB5hmt6AAJX/YfPs8UlpWtuXOCssronoTG7dKD8nuj74V+qzQvtmL9bgbaT9Wr1C77LH+m8kFhbojYxV93wk4SqbqAJJyhPpsZcKYRo/vgGGFZ4mXMUJHFb14Ua+jUA90HZk5eVQCk4LL1dEY3Jc1kD+h0C3kV3n6ltKFoXUmWP93Nwoy0RKlkSl3nWBRdjt5VuLbaCIRhvPhjLl7UWiGmrFDL8MMJbskc/o3maSdFK+X9uLbhiwTd8ANiB5zinrCwiLaPhZOtxqPZdoYcoIrhKvcMA76SyrbqEqQ1I=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

In mremap_move_multiple_vmas_split(), if data is corrupted
after mremap, the control jumps to cleanup without marking
the test as failed.

Set success to false before moving to cleanup.

Fixes: 7d6597dfef11 ("tools/testing/selftests: explicitly test split multi VMA mremap move")
Signed-off-by: Sarthak Sharma <sarthak.sharma@arm.com>
---
 tools/testing/selftests/mm/mremap_test.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/testing/selftests/mm/mremap_test.c b/tools/testing/selftests/mm/mremap_test.c
index 869df22d46db..3b42c4f2473c 100644
--- a/tools/testing/selftests/mm/mremap_test.c
+++ b/tools/testing/selftests/mm/mremap_test.c
@@ -691,6 +691,7 @@ static void mremap_move_multiple_vmas_split(unsigned int pattern_seed,
 			if (chr != buf[j]) {
 				ksft_print_msg("page %d offset %d corrupted, expected %d got %d\n",
 					       i, j, chr, buf[j]);
+				success = false;
 				goto out_unmap;
 			}
 		}
-- 
2.53.0



Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 43D13FF886D
	for <linux-mm@archiver.kernel.org>; Tue, 28 Apr 2026 20:46:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ADF666B00DB; Tue, 28 Apr 2026 16:46:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A8FFE6B00DD; Tue, 28 Apr 2026 16:46:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9A6756B00DE; Tue, 28 Apr 2026 16:46:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 882FB6B00DB
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 16:46:57 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 4ED65140269
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 20:46:57 +0000 (UTC)
X-FDA: 84709148874.26.8DBEA32
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf18.hostedemail.com (Postfix) with ESMTP id ABCF11C0009
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 20:46:55 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=RfTZR8A5;
	spf=pass (imf18.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777409215;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FXA6sPDV6T7/i7t4cfnDVP9gKpNUMqTULWLo+ZC9cdU=;
	b=5UwrgXfyzUUAaIYfHvqzj/gOauzKy3GFUcHY5xvG/sHc0mgM4Q7be9D4sSJMH8VVCcf7vp
	34KeMPoL/TReEqVWpalj7D7iapw0LoOz1h6kBEOZzhW8lpCMPYQxoh77nL4SK8htVQHt4G
	WIuVDCyfCKpFGhzZbyRDH3OadiNQLuo=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777409215; a=rsa-sha256;
	cv=none;
	b=mOkrLd8pbkV6OP+mBmhvxsK5YvqVqnZUgDb1W4JG/aIpZM2UykhG9aHSrLxTHgsshYcHTE
	Fy1qI+Ple9Hl3gkOFgLGqTl+CtjVMdOKR7p0aUoCLP8PdFlpgknE0yv6XJviUwC8wHLz5r
	wFTPd4HGbXzEM4RVl0fmuoAkpNwDjlw=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=RfTZR8A5;
	spf=pass (imf18.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 4094961333;
	Tue, 28 Apr 2026 20:46:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DAF63C4AF09;
	Tue, 28 Apr 2026 20:46:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777409214;
	bh=1E1PaJAheFq68IlA7LKJisHu/YP5aoXijmYjIj2LOcM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RfTZR8A5NSaVcxV4oFGcISWB69/39YfEdkoN6L1MZWM+kttqU+LmX2bZHSnp0cWRa
	 dwWrhk4La8ShLvJv2Ji3jwOgArl4fxnmsZv2Uguy/wDmYCATYP/MrUlCByI0rYFmSi
	 iYlU6oNDU8Q3fV8whf1+Ll91KGJb6QpnSjR0urln9RbYBuEQwBhsa3ReYgrmJ48g4z
	 wNBHtqFcFB5/EMiEoDB3JDRsxbF69nXhyXU++Qs/Nu++cIO2iilaHSp5ccDNRY5ngm
	 sIDB6GzwRbOrbXw6DTIMzBKiDU057XAQF+6oHTVq/WiesNC1Ti+jzqQkv4bobaT70z
	 Urg8jyOsVksbw==
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
Subject: [PATCH v3 37/54] selftests/mm: hugetlb-madvise: add setup of HugeTLB pages
Date: Tue, 28 Apr 2026 23:42:23 +0300
Message-ID: <20260428204240.1924129-38-rppt@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260428204240.1924129-1-rppt@kernel.org>
References: <20260428204240.1924129-1-rppt@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: ABCF11C0009
X-Rspam-User: 
X-Stat-Signature: heh6rt6xqb13f5f7jcbe48ke5pcytzjy
X-HE-Tag: 1777409215-205161
X-HE-Meta: U2FsdGVkX1+MHAgzJeiaE2Rw52zCaoO85QKeESd4hg5v/qpZg5bm4nKv8iiRTfvzmc1AWY5b0cfhPU76IK3xgnwdj/733MQJA8Ni7O6gRI2b2neHFpvtatyKvZzFoL5lilCuKU8UQaP1ePJkDV930Q5rbKbC6viI0zgd6zdbIP/OCRPszViNwnBPsAU2gW7DX3hphAIL/jiWTgM4IWHBAJM6NlQFdjpHsGaaPNjDXJ4ZRq+n2psyHW5KSR3tfcBUr6rAgqAK80Q7nv1y7XYCbcGXymLHVlv4YGXY5ymY3GdAJ8SBkCF/EtANZUWTqJEjmKvVt9R5WL8FJSMvWF3F52fv/mud6RRKHgl+osXhTu9lc1/sNQhpK2VBdUr5AaJh+/r9eG3QXS8bma4biCQFItLMP0/VW7T+Fj7QnpWpwEiQVpWaCqo+d0whO7rNsYN3NpRhPDXpbOZ0lYlbVX1FKfiU1gygNaEu6guFqNv0CkMVOrGZcD4aYfl0wkdySFlndYHjXWYDXY1eQ2zbCJrzgHLOt1eAEp15/cHJy82RoE8bdLP5MDJ8Q8x1+5C9TwcumccVTimhd3lAjSdPksV+Vhhw9vkfy4Zf5m4pweJcboF5PdSjwkaD2xKDgpSdwfnsTYIiXoQNaJ+GUdn0Ee9O87BYa65lvgIuJj5j6X+oAz2n1kwTfvDmecyCOM4LOUqmuVyop5S136ovfI8ODxK22NdEF8PfJ61BqWNacQ48WLTZwf3/FEyFjHzjEvt+ttHX4SbzbJGYUC1ONbXH4W4J+JKlCG1dFUXX/PqNNCCEGqujbszGe0WsZppiNqleM2m+N6ApUAsVd40l637+DzZ5Pa3+8Gq3gSpSgmzSKDUwcQjsezM9h+Ex8T33/ywSZpog3wk7JKOJB8jtFo6p10gyXde20oYAsN1O/snq/RTDbbqGpsds/CTuj42mLfiZ2D9dV9Gmhtk0pNMkr3zOsFq
 foCXk+rb
 r/iME0Kv5z29MKa0yVV4Qver+RO7eoB0Z6tm1mn8LFpJFuK4fZPJbWN4/+pFL+odMbgmsGwH1tbQq5gcM+xf6JktjwUDbRYomQZ6H8eGwYRYLVJ/fjxuZPBqh708Md8H89aW4P3KOSKI4x9ilNH1jp8SnTFImaV3oBc/v3zCX9eSBwBe/5mfN8pAs1S8eXKJX3jT0LfGq+P7pnhkE6jbWZvcZuU/MFU1AJl7cOgKboSi4Oqo=
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



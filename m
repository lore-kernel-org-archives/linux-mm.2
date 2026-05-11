Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0838BCD4840
	for <linux-mm@archiver.kernel.org>; Mon, 11 May 2026 16:32:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 732006B0112; Mon, 11 May 2026 12:32:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6E84F6B0114; Mon, 11 May 2026 12:32:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5D1766B0115; Mon, 11 May 2026 12:32:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 47CD56B0112
	for <linux-mm@kvack.org>; Mon, 11 May 2026 12:32:28 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 18C731601ED
	for <linux-mm@kvack.org>; Mon, 11 May 2026 16:32:28 +0000 (UTC)
X-FDA: 84755681976.16.0910842
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf25.hostedemail.com (Postfix) with ESMTP id 68674A0008
	for <linux-mm@kvack.org>; Mon, 11 May 2026 16:32:26 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="e9kUymH/";
	spf=pass (imf25.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778517146;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fKeIwZ9UbNFO25xhYITmp48Zq6eW3mOmCGwrKn13SAA=;
	b=y0R3rbYwpjrQDOSNWfFobTpiwQ49GX2QwjtpUyukUphTb4irIzyLUZCqo8Dcf1ErlCgwzv
	yFHrtzNqt1iYj8Dz5QUkbqMxqV4yPcwOFvk8n/bwOBTnC0l2nTuN/ePYNSelfTd2wE50ZI
	KJ5vJJCaTIz7yCzXb0KlI09bRMtB4yA=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="e9kUymH/";
	spf=pass (imf25.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778517146; a=rsa-sha256;
	cv=none;
	b=S0gY6+FcejpxtM64FE9O3+tHfcYa8y7kAbP9NEI2PKGLJ8QKwrUpV3BT7ftfVWYlbA8XBG
	lN9D7eSqx2lbU1WAVq2IrLyJ2KTdiVnXg/PoOeRrS6z+npLP32jDUW44+JN85bizSE3gMn
	hTgNTyMxwP/DJM3QoPL4Zvqq1/kULzM=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id E61EB60120;
	Mon, 11 May 2026 16:32:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B2ECC2BCB0;
	Mon, 11 May 2026 16:32:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778517145;
	bh=lA3bDepyp/KwvwswSh+ZEnsgnt+UniCEkPXwbD7q5uk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=e9kUymH/p70j9GGaBVXch80X7FOdrlg68SCppYlJo3m3mXNbvnCArzXhbuOo7t2h2
	 EKsMQiD8F+uwMFZWpfs4Djtuklt790IpQsjhkb90AXp4k8pFDjJRVI4cf5b+3x+sl5
	 w+zahcfQYi5CKy0BD8nS2fkYCYQ0HwN7WpjMCr2rgO92oLsDDQdB9mSgzX90BsX2BV
	 2RSOARreDsvUTgWiHaDoaYLCm/HOSI9+5lXFvhzi+Nu2saajYli2wuVgPMFgwgxGYS
	 YSiU+TKOYvLIGDnwISBdSeRPbrFnWqxo45ZR0nuAVuVEeYKaorLRZTggepWhhHAi7X
	 xAAIdtXkZ2jzQ==
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
Subject: [PATCH v4 33/55] selftests/mm: gup_longterm: add setup of HugeTLB pages
Date: Mon, 11 May 2026 19:28:17 +0300
Message-ID: <20260511162840.375890-34-rppt@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260511162840.375890-1-rppt@kernel.org>
References: <20260511162840.375890-1-rppt@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 55z1o3b8xrhuk81m3k5no31aemmmkhzm
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 68674A0008
X-Rspam-User: 
X-HE-Tag: 1778517146-564307
X-HE-Meta: U2FsdGVkX1/urCbUftKiAW8CXNOEFJ2y0+KoJX8jnzYIu9rYkk1QfrzCCLKqmZVblG9O/i8sV8b/4lCz7c4qG/939soe8jTk1Y4ZJSsQ52fb4m0CQ5gZqBzPbM/rz3LCqBXdPUVNeGIjls7GcAbqkOaDqCpNjSaDPkthn6VKVPlAiwLrpP90RUUzwChhxqgh4cgWiEUXgfTe2cg651wWxHZ8q26ubZua4aGd/KK7abaqk0ZKx4oouN6qfi3kIU+IuzsbhUg9L1Yds2IhMqHO70u/68K7fkuUzTm8QdLrK/XlS+OxQrKNrWQ7jIHtXehhenbXmkpdjk+sOw643tyW+33jL17CrUAcOFciXvWRlX0WeCm+CC5/mhAzp386mu7olBUzik6ipHa5jfpFPBr/vZGNYyvCXAJGT0TpgR51OV2lzfXDf2IVJph+e81+ZXGvm9KqE01McH6brUJlEoI99bAKIPX/SGhby36pL4uO3U06JgeeT8f2R7dMluawhca8ouFPXre1BjpL442VZLvjej0OujzXX7DksCYlkxna173Xuo7aoD9MzFRtatV2oov6012pQzheqVuqIYMPbZ9Q/rXjDduzbymt8CpPdC1jB7TRkd775FCrcVYHBJKI6ozvUja4WnlPy6EwYwwdxEXPtR5AtUpKQGI6UYFd2YgSBeUa04xYav7C9vN6wOo7UJxnjku6qDNIkINA34Lc3RKYSeyXTGVyOoUZ69J5rTUgQNcCMPMO2jf0myuC3SOlQq6KgzRFBz8x860ssV2Y4PLb5wjCzOV1GlhpEUEYh1gh31rHZn+/9swplXFS/AwWTRgnTCurZBU0lEg1VmeNKAitYYnSdlTlT6HesVjZGD09ixYDcuRTzpl1NDggqQho0oG8M5uv5JEb15f4Za+LRzVVngYh1mmbOQDOoijIm+CL+sgP5W43/55iODe1O+TRlvW/WXY44UzxJJECp2aQ/1V
 mKWv2/SH
 jyX12RTLKjpj8wtcShZKjwuzvNL0tdjRJsX/v1+N0WUh3T6kWy8yV4rlB3KtSzQC+k1BX2k8SFsEvNakyMfc5S3QAD0WiwFdSCM/9PWIpXNMPAxYnp4dg3LUGGyfKsIcBnEmSdwo+hK7Dl8qae7Csk/NYE2r7GuARNkzJyK9poQLH4EFdBLUDne5fDKmZXT5Vp9YMggKjTYdkmuRj0EqB1AZHpAM7i9ql+oOVXomGin2JT4VQLLtVoau6qXMb4PzwMpZy43/1S4TFoQN+vSSCikgKKAcChznt7JFEnM/Ij0vrGuuTfCfrLH00oppTtesU0UlpIrY/1F2nKXz/YpPyhzeI1g0if9cqxVdxPZLeU4ph6Xc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>

gup_longterm tests skips HugeTLB tests if there are no free huge pages
prepared by a wrapper script.

Add setup of HugeTLB pages to the test and make sure that the original
settings are restored on the test exit.

Tested-by: Luiz Capitulino <luizcap@redhat.com>
Tested-by: Sarthak Sharma <sarthak.sharma@arm.com>
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 tools/testing/selftests/mm/gup_longterm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/mm/gup_longterm.c b/tools/testing/selftests/mm/gup_longterm.c
index 96dae0acd11a..eb8963e9d98f 100644
--- a/tools/testing/selftests/mm/gup_longterm.c
+++ b/tools/testing/selftests/mm/gup_longterm.c
@@ -510,7 +510,7 @@ int main(int argc, char **argv)
 	int i;
 
 	pagesize = getpagesize();
-	nr_hugetlbsizes = detect_hugetlb_page_sizes(hugetlbsizes,
+	nr_hugetlbsizes = hugetlb_setup(2, hugetlbsizes,
 						    ARRAY_SIZE(hugetlbsizes));
 
 	ksft_print_header();
-- 
2.53.0



Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 40745C982D2
	for <linux-mm@archiver.kernel.org>; Fri, 18 Sep 2026 02:56:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 14FBE6B0099; Thu, 17 Sep 2026 22:56:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 100996B009B; Thu, 17 Sep 2026 22:56:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 03D906B009D; Thu, 17 Sep 2026 22:56:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id CA5B86B0099
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 22:56:47 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 0FE9016055A
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 02:56:47 +0000 (UTC)
X-FDA: 85225370454.12.822C649
Received: from mta0.migadu.com (out-113.mta0.migadu.com [91.218.175.113])
	by imf22.hostedemail.com (Postfix) with ESMTP id 0947FC0002
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 02:56:44 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=RVtnNC4B;
	spf=pass (imf22.hostedemail.com: domain of hongfu.li@linux.dev designates 91.218.175.113 as permitted sender) smtp.mailfrom=hongfu.li@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789700205;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AvwRaCLRduaPl7ofTHk3iFiEtLJyO8gnaiI+z7ReKBY=;
	b=0uHKcCTgmh8zzUzG8QJ7B4xJU8VJmtxmLY3kCq8DIGgoamlGMvV36q89xYL7pgp06i4UuH
	AIxytC+N9G/JrDkub9tWnMJYzMN3Oo77BL1V5//E/jD3iLspHHod31qiO4Haxp5+sqwvcS
	jbMAF7qB1M0A4+C5pQJ+9ZsgXsXkjCg=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=RVtnNC4B;
	spf=pass (imf22.hostedemail.com: domain of hongfu.li@linux.dev designates 91.218.175.113 as permitted sender) smtp.mailfrom=hongfu.li@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789700205;
	b=qP5AeQD3C3fAfdOShHNPvPJjo4Z67VbUZwOuPWJsBy8DGakxvv83xDyGS6LlEuFQNUT/cZ
	+JUOF1y9hRD21oJmixJn7QDqKjW9Up4tqV/DhpVQf8MmSHsjMQhoeVfIC9Z9PionCZuPf0
	NBxVIp18ltsw6Ttpz8w+E6zAAihWwEg=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=gMDNPKvkl43rEG07pQr1WtDNrBKGvQm6RDcbilGOvZc=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789700203; v=1; x=1790305003;
 b=RVtnNC4BK8QGmcO/exyqydAFSTV0YeirNb6Zjy8DVOkPRyRDYF51Et9DT/CT1DoWRv0vOBfC
 3j5NVNTKV90jkAl90kIK7SHumrAcgjCA2Kff17jp6v378K1mNF6UZLtD7DJs5F/u2OE41Oq/WPA
 gTkLOLsJbVmHP1UsH5tHoBDg=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 7c6d4e5d4c2fa1a8;
	Fri, 18 Sep 2026 02:56:43 +0000
X-Mizu-Trace-ID: 7c6d4e5d4c2fa1a8
X-Migadu-Flow: FLOW_OUT
From: Hongfu Li <hongfu.li@linux.dev>
Date: Fri, 18 Sep 2026 10:56:11 +0800
Subject: [PATCH v2 2/2] mm/hugetlb_cgroup: move per-node usage on cgroup
 reparenting
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260918-for-hugetlb-charge-v2-2-2b6d8c2bdc36@kylinos.cn>
References: <20260918-for-hugetlb-charge-v2-0-2b6d8c2bdc36@kylinos.cn>
In-Reply-To: <20260918-for-hugetlb-charge-v2-0-2b6d8c2bdc36@kylinos.cn>
To: Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>, 
 David Hildenbrand <david@kernel.org>, 
 Andrew Morton <akpm@linux-foundation.org>, Kees Cook <kees@kernel.org>, 
 Colin Ian King <colin.i.king@gmail.com>, 
 Shakeel Butt <shakeel.butt@linux.dev>, 
 Mina Almasry <almasrymina@google.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>, linux-mm@kvack.org, 
 linux-kernel@vger.kernel.org, hongfu.li@linux.dev, 
 Hongfu Li <lihongfu@kylinos.cn>, stable@vger.kernel.org
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1789700179; l=1276;
 i=lihongfu@kylinos.cn; s=20260915; h=from:subject:message-id;
 bh=p5jmZoyk44qDQ7+C6YBxS0kRkY10Qpp1sAnAzxNdFPA=;
 b=/OH25k+LSrmo9fr0WYUNPHD73MaTB/ENpGnDv0ALWpziXS1YtqPaTv68o6yipqVlSRX790FDr
 6/Vk99IKXd2BHsD8X1lyrY7kNMYA3qPzOg2e3pqVT/57VMQckpUFdKU
X-Developer-Key: i=lihongfu@kylinos.cn; a=ed25519;
 pk=rUpDSpB3neoNZRlGG6dHlFb3RepiJakcev+ucyqaZzw=
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 0947FC0002
X-Stat-Signature: 9qy8hi9er9d7o6fxiefmdc6qo4bcug17
X-Rspam-User: 
X-HE-Tag: 1789700204-444231
X-HE-Meta: U2FsdGVkX19MSOcpOma6w3bvCtDLlDTi4MsULDGpyWkMYNu59rMNkQ6MB9q1Bv1ImHrQRqYEtcfVcCsBi6qaWCvZkySZKOM7I6UVD8WaFvYQ/ngetoOzndtJolb3w18QmCArtFHnmT0EZEyjtDMf/EQlEUnZqOkpw2UjHz76c0hfMOQKdcWkjHMRx8i7jpQTjZ3DUm9yocumSB7HRLnP3//d+pm0LCxIH0Z8LnGn643XfTDUYpj84+pRBPePHA/Wt6vANqnCsQSY3HlLzDuEtvOE+h6oEyOw9P0kCVA2eZ2VGIK9AQxYtCoYi5tZr/jpxO4VxTO0pSY+tfby6AUrsysgSQcyagnAiMmW+J9opg6GRzT5PrwfCfcendAasAuhoKnX8VI68bfLvkq16M6eMn0u/SaC21iugW+1Mfh0OQ/dAqkRWXlzfnPwnsME05bxFO1//G/VkgdSdDrJLr8pLJwZPyzm9IbE8JN3/jUwf/D3IIRJ+de95qI0DAFJ2fvhkLYnO6kamJn/7c8T3k52GjjTwbFMUnZkzLBg6X4twwPUxIfhLIHNGqKxlpgZGQE4WXP4tFO1HvaPm5pwAvSkj1G2/YTc8I9+Ii60JLa4udt9TkTtyYXtzn1oRNEg3KL7qRVCIyyQlGmeAs7emKK2auKZFfZBG9yc1QpDYZ8cza6kMR1kWMk5SxcWoU797ELUFNi0CaXthJKJE750o5G9uBCy7C34knW5wj/Dl0r1PC6shnWEa0L7AdAJSW0CejOF4mHGceq+ICzTDrP289FiROUaPp/8ypz/9Ddo1jZkakUDo0yOkLoK9R9Vpo5Axet48dj2F4VrWjuffDdRYhTEnxnDlRE9kYHWpaOb8tnh4emlYfiiTW0fZgaKLr8LXMrT08cQ7Z956dokmi5Q6rqz6zw9LZPnSrApi9oA3g4udAIYS0MRch0rriBcpXQYmU/PEejqKtox1dohDHpqaFx
 4/zN3dj1
 4YAkhF3dMLXA1Cn/N5NdnAWe9JWejw2lTOu6duVuVykciKC7ZW4lYVZDYhhK+/cz9voAus4nSHgg2TYPGBvDfqmaUD1Z9OH8UJvGfDkUhDjJeo+uX5+Zt0G2v6zpyJTlgz9YMhVYSoxf5mAUbkY8j6uP+rQVRyj3shYuzGfaq5KEvi46eK11lbL2/j+/sJ+8jnn7A7Vw7oEcIrujCdipLHy4VzttXfBcBmBns3ajhlb1Or7PzA7bocyP2d0T6xnl1V4ck62dmgYOB2ljEB+vMG+dCVBcDVyG4QLoaYyQQ5LUGCR9IB6c+ZOrmLnZA5s9GDxlEP83DeC3URMRI2mC53eh6SQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Hongfu Li <lihongfu@kylinos.cn>

hugetlb_cgroup_css_offline() hands the folios of a dying cgroup over to
its parent with hugetlb_cgroup_move_parent(), which moves the page_counter
charges and the hugetlb_cgroup pointer of the folio but not its per-node
usage.  The parent's hugetlb.<size>.numa_stat is short by that usage while
they are charged, and underflows once they are freed, exposing incorrect
per-node usage values to userspace.

Move the per-node usage to the parent as well.  The folios keep their node
here, so only the cgroup which holds the usage changes.

Fixes: f47761999052 ("hugetlb: add hugetlb.*.numa_stat file")
Cc: stable@vger.kernel.org
Signed-off-by: Hongfu Li <lihongfu@kylinos.cn>
Acked-by: Muchun Song <muchun.song@linux.dev>
---
 mm/hugetlb_cgroup.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/mm/hugetlb_cgroup.c b/mm/hugetlb_cgroup.c
index 7cf7c18119b4..3fb41311e4c7 100644
--- a/mm/hugetlb_cgroup.c
+++ b/mm/hugetlb_cgroup.c
@@ -241,6 +241,8 @@ static void hugetlb_cgroup_move_parent(int idx, struct hugetlb_cgroup *h_cg,
 	/* Take the pages off the local counter */
 	page_counter_cancel(counter, nr_pages);
 
+	hugetlb_cgroup_move_usage(h_cg, parent, folio, folio);
+
 	set_hugetlb_cgroup(folio, parent);
 out:
 	return;

-- 
2.54.0



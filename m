Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 72FC8606A31C
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 22:57:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.a=rsa-sha256 header.s=amazoncorp2 header.b=rtQa9mZM
Received: by kanga.kvack.org (Postfix)
	id 8670E6B05BB; Tue, 10 Nov 2026 17:57:52 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 817686B05BC; Tue, 10 Nov 2026 17:57:52 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6E1BF6B05BD; Tue, 10 Nov 2026 17:57:52 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 477026B05BB
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 17:57:52 -0500 (EST)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 53222160182
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 22:57:50 +0000 (UTC)
X-FDA: 85420723500.11.3E8A939
Received: from pdx-out-012.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-012.esa.us-west-2.outbound.mail-perimeter.amazon.com [35.162.73.231])
	by imf06.hostedemail.com (Postfix) with ESMTP id C692E180004
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 22:57:47 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=rtQa9mZM;
	spf=pass (imf06.hostedemail.com: domain of "prvs=767c605bb=mkbund@amazon.com" designates 35.162.73.231 as permitted sender) smtp.mailfrom="prvs=767c605bb=mkbund@amazon.com";
	dmarc=pass (policy=quarantine) header.from=amazon.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794351468;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KCrohZMPQ49/6mvhlHcErh3G9zGs/xibKV8aanZizrM=;
	b=mdSwbvAEspGzUVUgTQCW19WyTBvChSERp/VcfCccUG8MVCm7eN4+JUe4IqEFy2GPx7VM62
	01roODuYTVFRwcZpj0E7Kcb2cMDL5ggmPb7tB5ZlUZhNAL8yxPTkUbyVKyaghvEYFmihoS
	SMPrwSxfoS72aWc+JR2CqIiIzgwB/9A=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794351468;
	b=ELRWAlqbRJARjmqss+kFi5dPEN3LmUXzVov6Y8byBqRru4ZttLSWqpi6gJtrgXQTRLWl1q
	1lLISo3tTSoA5rJ0kJlfR9ieFf1FmB4FF0rq0qf0PpyDNdI3LnCc0xwXnUnkj/OpmgQUU/
	vFlkS1gE+gi5ZJITSdWM6m8nJwGO24g=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=rtQa9mZM;
	spf=pass (imf06.hostedemail.com: domain of "prvs=767c605bb=mkbund@amazon.com" designates 35.162.73.231 as permitted sender) smtp.mailfrom="prvs=767c605bb=mkbund@amazon.com";
	dmarc=pass (policy=quarantine) header.from=amazon.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1794351468; x=1825887468;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=KCrohZMPQ49/6mvhlHcErh3G9zGs/xibKV8aanZizrM=;
  b=rtQa9mZM1U3rEd8QYNITXl5SAmZ8dr7Xh5l5mLJ5u5ow0mQSEP6/cVDj
   Y24jMdEXNq4neyZNkyz5eoFfyCsBbnkYJMISD0HN5Y2Id5vHvZmsrZ7S0
   u7zTk7HHMUNS4G1Tt+bnU2frTc2ws0gBH4R5jRrAWgkcoHIrIcC0y6l91
   80gVIhgF4Z5mEcN/02+fj36V8VN1Y6U+nMxXeWudhLWER2J1S47rt6Vtn
   oAgunl6xzFpUDQJTi3Lq8ZKEVIAdPdFaZsNiX24IOWnccINEpKw51bN7Q
   IqXi05G1xS6pY+Je/sWDHPqe3BB0h8Ufwy9KVmihx6hzHUQ2AcenMWX6W
   w==;
X-CSE-ConnectionGUID: HdsSGMfTQ8uu4ZlcpBxg8g==
X-CSE-MsgGUID: pbzLt/NVSYesoRccpqMgyA==
X-IronPort-AV: E=Sophos;i="6.27,206,1787011200"; 
   d="scan'208";a="33476163"
Received: from ip-10-5-9-48.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.9.48])
  by internal-pdx-out-012.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Nov 2026 22:57:46 +0000
Received: from EX19MTAUWB001.ant.amazon.com [205.251.233.104:10377]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.5.141:2525] with esmtp (Farcaster)
 id bfb556e2-6c58-4936-b169-98b50b90d9a0; Tue, 10 Nov 2026 22:57:46 +0000 (UTC)
X-Farcaster-Flow-ID: bfb556e2-6c58-4936-b169-98b50b90d9a0
Received: from EX19D001UWA001.ant.amazon.com (10.13.138.214) by
 EX19MTAUWB001.ant.amazon.com (10.250.64.248) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.56;
 Tue, 10 Nov 2026 22:57:46 +0000
Received: from dev-dsk-mkbund-2b-9ea2efba.us-west-2.amazon.com (10.2.100.138)
 by EX19D001UWA001.ant.amazon.com (10.13.138.214) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.56;
 Tue, 10 Nov 2026 22:57:46 +0000
From: Mark Bundschuh <mkbund@amazon.com>
To: <muchun.song@linux.dev>, <akpm@linux-foundation.org>
CC: <osalvador@suse.de>, <david@kernel.org>, <jiaqiyan@google.com>,
	<linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>, Mark Bundschuh
	<mkbund@amazon.com>
Subject: Re: [PATCH v2] mm/hugetlb: add htlb_dissolve vmstat event
Date: Tue, 10 Nov 2026 22:57:34 +0000
Message-ID: <20261110225734.3549172-1-mkbund@amazon.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <D6862DF6-34D8-44B9-8412-B241812F6754@linux.dev>
References: <D6862DF6-34D8-44B9-8412-B241812F6754@linux.dev>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: EX19D031UWC002.ant.amazon.com (10.13.139.212) To
 EX19D001UWA001.ant.amazon.com (10.13.138.214)
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: C692E180004
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: ock71jqqbgdadcoqrfcja44arupbfw4k
X-Rspam-User: 
X-HE-Tag: 1794351467-590080
X-HE-Meta: U2FsdGVkX19C3+BYclasi2fAdjn1GCLpUQ4YiaiH6Y2AMIInxBewLle9560oHsicey09MFD2be8zPb8Bhn9tsqXXx8HxxAhRKTh8LPrWJLhadWKCaPbD3L4aaIJVjjbnUlcJw9gJscaQ70/j+oxYRwWi1uBf114wovwUZVegDpOarBbc6vmQockF/ktPbzOpDHWST6Pb0c0Ylx3JH8mUUwr2806PTtWRhc+tnW1wxvkh8s15/HB9DGT8gEAfwGUqKPShXezBCJiwrKlVRsJVjR+j8ZpXZkRHs0i7E3SYQnb0KL6naioqsEgYlDEC8CTg3VzLqwYWhSm9zktiyVPonXYs1MnzD+6l3vB42CuPNTiWk357cHOZvSa2CGvghuyQut8bhFcXrTV0/yMpESGsSgU8sDyio5B9dXWCpUnJFt5bYFDdZnB/UtfWsCmNnag22LFug+1E98XHOYJerDP0p0EkFJVT8OIfSID+jzU+1/HUit63uYfRdvCCV06hBN9T+HppQwUVaMaH8c6rw3t6UKt5N7OJZq9Fn/5GFInPA5sUufqzLkIjy2aZkHvbwPLpb6xMcjXT5ehbeWqEarZk7+lZbJzDZaAZnEMtv/AK3YTSXwvMoMEG4Ki+/UgZxbi9powtZzinV+nS9gnURNcZzWAYMo6yXbfmI9jDTNdCFxdi2Pwcxi5Xzx/YWEkrPcuWZ3GFtX5z4oZmwhMVHY1k+aBqwUqI91usYMvSPULL4HerCGOTmjysQRg7IS8F9wqsArHIFgAgxiO4DzzoQJ2wnXjSKv4sDFNqUha8gNgp4iAMxWJwq/d6OFKf+coDi8MvMRS57rlzmNn0xn34zJWpjv43vfRjRPhgr6XRTxzyRK+XXylzFH1vhDRMTaNRcKYC1Mfo7UkhAONXPsqUjVXe7jZCpZL3Cpj0TtAzWgvlUf/JBbE0Z2SqkTZbZ1hq0CSlwdi7dr1RqXAdS1YIJBx
 /GBXn6WF
 IrJDEw+IsyAvnhszjUQB1ShSowC3sZqEXWyv4IzQp79t8oMCsMoIrQl4FhD+mLOQC7dQh07S88mTKij/KXEXn16dGaWu4rWCIpcLHNwdfQiZ4PgABKwhUP5LjsfG2TEWfQekTK55SzTZ6Ez+s5TbdQ1Eze9olMCIADcdS1uq4HifXMXUBSKk5tX8lCD+nYGapXkipWrLbxn1CDQP9rSSoYTdKY7EBlXKilcD/Z+FD7y5H5whOPRvjnEsaTYDo9deSX57Wk1jsJWcl0i5JNjXAI6CXkbxGHA6/xj+cHqGIZ1SiA5UbAlqvMYhUatLBNanFuDzx4meS0cygsx/E9DbjhrG7KVwV2AX/V1Bl9dAXRK7o9K3/VRbiTFqbzIhPItF3+906xbQqqpP8Qd7B7sj8EN2LhGZCh68KRfQfSztM+u2hqUO8+osi+qGygmdeRsx3iCukmsZsLe7C9m1WozECbE+V7LiOVAwSCwaCud4m6F3wSMN2Qcbq2wF+6NhVNA9LKmfh1mFI0JMFH5KlY06ulS5pM6rmT5oh6lI1Phaf9SL09ahp51oLMsqqCpAnup5t62+LgDrC2VcBmo7sCfck4yPq0s9EzolpKC1yqZ5cIU1kaOUEwD4Ft5rJpcmtozr9QO3J1ITcCK59B7yNbQp4sMo8kjGIJgr5uy9oWw1ErwXWBGNClH0ohXPDSEGV5QecgzCK5dwaAfquVpEq7oZ2JKxGRqcubWO/N0Jk
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi Andrew and Muchun,

Thanks, fair questions. Some context: a management agent offlined memory
blocks on a host using huge pages. Each offline dissolved the free huge
pages in the block and lowered nr_hugepages, and later the workload
failed to get its pages. It took me a while to work out that the
offlines, not another process writing to nr_hugepages, were what had
shrunk the pool. The counter was meant to make that visible.

Thinking about it more, the offline itself is already visible (a
successful offline sends a uevent, and auditctl can log who started it).
So I don't think this needs a counter. Please drop it.

Thanks,
Mark


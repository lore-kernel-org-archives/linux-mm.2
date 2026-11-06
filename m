Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 71273606A326
	for <linux-mm@archiver.kernel.org>; Fri,  6 Nov 2026 22:08:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=amazon.com header.i=@amazon.com header.a=rsa-sha256 header.s=amazoncorp2 header.b=ecPZ3+BR
Received: by kanga.kvack.org (Postfix)
	id 758B56B05C1; Fri,  6 Nov 2026 17:08:52 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 693DA6B05C2; Fri,  6 Nov 2026 17:08:52 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4E6626B05C3; Fri,  6 Nov 2026 17:08:52 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 292E36B05C1
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 17:08:52 -0500 (EST)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id B91CB14023A
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 22:08:50 +0000 (UTC)
X-FDA: 85406084820.14.6F00671
Received: from pdx-out-010.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-010.esa.us-west-2.outbound.mail-perimeter.amazon.com [52.12.53.23])
	by imf09.hostedemail.com (Postfix) with ESMTP id 90076140006
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 22:08:48 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=ecPZ3+BR;
	dmarc=pass (policy=quarantine) header.from=amazon.com;
	spf=pass (imf09.hostedemail.com: domain of "prvs=76345edb3=mkbund@amazon.com" designates 52.12.53.23 as permitted sender) smtp.mailfrom="prvs=76345edb3=mkbund@amazon.com"
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794002928;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=muzx4GYyxmP6TkX6aslSzN0rCHQo8+v8e9kqEllWsZY=;
	b=vpcLirB3RyVvEAEQXbITz0scrRXkCxiCunEkuF5Y1tjBFciNP/dbYUX7UmRJr5hk0y3jjh
	2X/Slh0OYsr5yj/YX8svQAGDG5qlf9oBu1fu1F7q6FT6nbBnO02CbjKrCuYvyM3UqNORYJ
	Tq4gl2hKcFLmw/IgYPdrtqB4AbM5W1k=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=ecPZ3+BR;
	dmarc=pass (policy=quarantine) header.from=amazon.com;
	spf=pass (imf09.hostedemail.com: domain of "prvs=76345edb3=mkbund@amazon.com" designates 52.12.53.23 as permitted sender) smtp.mailfrom="prvs=76345edb3=mkbund@amazon.com"
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794002928;
	b=Tzg8H397ARlDxZ4foZsfMEV/k3C+De4BdFtsbuh5NMy6cub26ehHtye+rzTrmXufoYLhmN
	DggwJWCtFryLK5FiEsSDaQIP2SwyWe6EHOAFLxk73rf/ywmBAomudgMGTrFYPEqg3agMG9
	nKqB8NssIdhkwKeF89Rqhkx/3qsVBkU=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1794002928; x=1825538928;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=muzx4GYyxmP6TkX6aslSzN0rCHQo8+v8e9kqEllWsZY=;
  b=ecPZ3+BRr1BL8dnjLAZvcbWVisikFoltfD3Ipzu6khuO+eQu2HLN1bmW
   LND3u/ZHeLtLJkKr8MyzMBRH6snT2IZTu5LNAnKmml0Ffn+6S2rQ3AroD
   rjC089ZVanVQMsZDHxKanWDaFstgkDIXii2QEZUQmpur+zeHil0rcVkEg
   Eq1VBB7dE6acNXVVXOxQnwlWKgtktQb6VYJgXS6Lg219eolmIj/ekBCwZ
   ciNY9qwa+QNuRc6A80RH4JrvHcCqIZBgf5vAvERS/8qGulWtNJW8uiOWy
   qMzhE3/k/CccpakcHbjXndPHSeso69SmeDOq37uPvoMBYNoeQV9x1IMl9
   A==;
X-CSE-ConnectionGUID: OxSyhlhaRsCTCzTLCCHFUg==
X-CSE-MsgGUID: Jqe4UQgCR4CU+k85J01HRw==
X-IronPort-AV: E=Sophos;i="6.27,199,1787011200"; 
   d="scan'208";a="33227437"
Received: from ip-10-5-6-203.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.6.203])
  by internal-pdx-out-010.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Nov 2026 22:08:47 +0000
Received: from EX19MTAUWC002.ant.amazon.com [205.251.233.111:23494]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.7.65:2525] with esmtp (Farcaster)
 id 28f3d51a-68ed-45fa-9a7e-5a3d96734e58; Fri, 6 Nov 2026 22:08:47 +0000 (UTC)
X-Farcaster-Flow-ID: 28f3d51a-68ed-45fa-9a7e-5a3d96734e58
Received: from EX19D001UWA001.ant.amazon.com (10.13.138.214) by
 EX19MTAUWC002.ant.amazon.com (10.250.64.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.56;
 Fri, 6 Nov 2026 22:08:46 +0000
Received: from dev-dsk-mkbund-2b-9ea2efba.us-west-2.amazon.com (10.2.100.138)
 by EX19D001UWA001.ant.amazon.com (10.13.138.214) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.56;
 Fri, 6 Nov 2026 22:08:46 +0000
From: Mark Bundschuh <mkbund@amazon.com>
To: <stable@vger.kernel.org>
CC: <sashal@kernel.org>, <linux-mm@kvack.org>, <david@kernel.org>, "Mark
 Bundschuh" <mkbund@amazon.com>
Subject: [PATCH v2 6.12 0/2] mm: replace free hugepage folios after migration
Date: Fri, 6 Nov 2026 22:08:33 +0000
Message-ID: <20261106220835.2878368-1-mkbund@amazon.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20261105070442.3101877-1-mkbund@amazon.com>
References: <20261105070442.3101877-1-mkbund@amazon.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: EX19D031UWC004.ant.amazon.com (10.13.139.246) To
 EX19D001UWA001.ant.amazon.com (10.13.138.214)
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 90076140006
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	UNPARSEABLE_RELAY,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=4.0.1
X-Stat-Signature: 13y83pp5yiwosk1b1g3hqhjnsm649d6x
X-HE-Tag: 1794002928-371259
X-HE-Meta: U2FsdGVkX1/WUNO+quYUOYzfJ7Bx8+hX3w7v8YOPTqPqTZAK2sD+yTFPfniKPj7P5tVr08Y8cHXbnBAqDQ7Z8tiqIzxVImeaPfUled5rRpkQAgM9thYGNovFIRk1/hvzw/vHsu/mCG+UKJdb0N4TDLwUnx+IKTuCDgsKA/V5LgQlWFIBwXvt5w7UfRvizQ/tLK9qGbwN0XyshrhsbzZgzTmGRJyVnK2hBZARpDJzmXN/+aA1blmMZ2I14GIKi8o64WY73JhypVxlM+s8OeF0EUfUUEH4e6pq4Rr22XnKuJ4nZq0xZV/IVOGma8MMu94JisLAJmcd0ZEUIXdXH8N/kz7eS2gbHHSLyaSzP9Vaqwn2/dw0JdvsmftAV5mmyN7RKitraaVjaEc2GqTuxrhB7rn2KW9zQjctdT2uL2k3E6PN8McwS2gk4nY72kZAuFfOWGhB2wHRxzfjcYYfwyLOT53RND142BWWaE6IuY+kvV8xzzHRXQi7+nijCzyGbkv8VhsJ18z9yr5IO3vjmE7NZQlxrsbt3Mf7vxhOHmNnNvxPmOvvinQZNPqd1ZFWxuiq58V1lOUZpuxzV2rpRnDL7dfBYvp0AfJnRYf9LRg3KRSZPBanjbYACFV7PXBU12zhyu0L/kZd1jVPswNrSQH9C32oBeb2794itYUlG+ozstr1KMoS2cPz/8wzAFu0Ex4jmlEe7oUFWLgC6s9dOX79E9EowiTNWk4KrWKCAfVHvAJ+I5XnDf5E4yv7GUlJirMybKXd7FtcLkNE2hmXE3V0R4OXkCenvC7ys59D4EmyVE47HtJ81behMBZ5eLtivhYp+mq7a0FDtCYGoUKy7FQOy1aN5YKAYhViYKbHMHidLHb547i5huHdBrW5hroiDlZ5PC9jWS2TqApH54CHe78aRTPaxyq67vY54CBokEIpdi908w/D5H2/v09f1XqGmWWHICMMD/ExL7EpyPxcuk+
 x1IPtZqQ
 YtOvJoGNX7zvon9WpfbmkcWOQGRM1xMg0rVwum0e8rnSNzWl2nzR+9nrmDcugm2WfN/43PMB08Z/66GBcNKXuyFG/2oQ1VcoeUI6FRU6IJnkK3eSUFTgdpi3dwlZDuqIGkFWlGNBJXoM88bm5njK80Acncs7HgImgwwrQpNksiDHIYujQgdG2F2Fof8IYZQ5LvKmLO78ekQxJ8bJZYqPTDY7bE3CY6JCWvxD4VuV4axW1kC5AquYpHqclVtALzWZwexBJuneXzZaEJvMJG2Nr3zI0j89jl/o4MEQ2UC/xvkzShBWFFAGJKF9Rn67csOS7Ukj8B84UxKhiM6oAsfexLG36yPTyJBNrX/aiVVkufxHJiJ05bnglTE8VKSymJgnU1yX9BqMUbQGcwi5aS467TU0/zxm7UcolTCjLrKDkqj6JughvF/XIyxRsjt5gCBqJqGi6oCO8sFsaegghE+p7JZge8YlU2nj6TKs1zK2xGQoMWpLxb8e1Uozb3izKROtxpBPdFNqfVDr0eplep2RQB4IAn+OQmlfHRHCm18Evfb3QuvMjdY+X2qEbYhUWrCcMIj4oZfesU+SWPhO0o/SG8zJqj4x+QCDH+T6xEx9WYjCg308U9Xb07RWlBOc/HEHWdU/Rg1DntWh4M3TxcCetd4a0H2B0gAiqk9fozvKvr7xofNkd43LrCkHois4p01/ON9+t79AaxXNaa46HjKm22hk6qQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Full backport of 04f13d241b8b ("mm: replace free hugepage folios after
migration") with its fix 113ed54ad276.

Tested in a VM on 6.12.115: memory offline of a block with mapped huge
pages no longer livelocks, and cma_alloc() over mapped huge pages now
succeeds (it failed on 6.12.115 and with v1).

v1: https://lore.kernel.org/all/20261105070442.3101877-1-mkbund@amazon.com/

Ge Yang (1):
  mm/hugetlb: fix kernel NULL pointer dereference when replacing free
    hugetlb folios

yangge (1):
  mm: replace free hugepage folios after migration

 include/linux/hugetlb.h |  7 ++++++
 mm/hugetlb.c            | 50 +++++++++++++++++++++++++++++++++++++++++
 mm/page_alloc.c         | 12 +++++++++-
 3 files changed, 68 insertions(+), 1 deletion(-)

-- 
2.50.1



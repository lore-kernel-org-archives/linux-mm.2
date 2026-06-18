Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 69897CD98E2
	for <linux-mm@archiver.kernel.org>; Thu, 18 Jun 2026 09:29:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B74B66B00BE; Thu, 18 Jun 2026 05:29:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B259D6B00C3; Thu, 18 Jun 2026 05:29:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A63126B00C4; Thu, 18 Jun 2026 05:29:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 52FF76B00BE
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 05:29:06 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id D80B81C49AD
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 09:29:00 +0000 (UTC)
X-FDA: 84892509240.16.4CB9CC0
Received: from canpmsgout05.his.huawei.com (canpmsgout05.his.huawei.com [113.46.200.220])
	by imf22.hostedemail.com (Postfix) with ESMTP id 48FE2C0002
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 09:28:58 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=K81Flbbo;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf22.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 113.46.200.220 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781774939;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=kdQ+fAyMP74UWtOzmq0mdTNvwK5wpYyG8KFA/X4ha9A=;
	b=mwNF2dpvq1Or/FMbedx7LbgwL6hMqwfN3SjALDK3RrSoo490mvnzXn8srvdPg+jLdIODMi
	jj/3OpOssXSXkUNZxm2lhj5QFFyAnaHaqrP1vXzCMYTiDtpQ/Arm4jyxkBlLovaUy7ne3F
	kujMK48sq1Sf3EDEn3S5GFt7BKW4SG8=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=K81Flbbo;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf22.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 113.46.200.220 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781774939;
	b=BXZufhe/6w7nIC6oOHx0qs0EUr3coyxTGwAxOy6sDGtoON7jnBxQNHtCAMFJ/fdmX3OICG
	VYI201IMMbfkbtmQZbBBl95jOq9A7xe6o9QpRYM1MYx4e1Bv6bALFbqJIKrOVvQ21Z1C3Y
	se7NXZyfTREk9bE0oVwLn+BCqZ+pqjU=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=kdQ+fAyMP74UWtOzmq0mdTNvwK5wpYyG8KFA/X4ha9A=;
	b=K81FlbboThac/hLbjufb3GvH5WpYbIkkH+dM+cQrkdSMAkRNEhbSbyZlFowQhNzKjQv3cLvwB
	HkvFgaxGOSckjYJggdj84CJ3z7R/TxuzAi6mBLZxNvFt9CIrsgyFMJSvdl9FwnPohWKSjp5poNk
	UCeiYP9G2VxLy6OCvxZgjoA=
Received: from mail.maildlp.com (unknown [172.19.162.140])
	by canpmsgout05.his.huawei.com (SkyGuard) with ESMTPS id 4ggwDL6LsWz12LF9;
	Thu, 18 Jun 2026 17:20:02 +0800 (CST)
Received: from dggpemf100008.china.huawei.com (unknown [7.185.36.138])
	by mail.maildlp.com (Postfix) with ESMTPS id 5EB5F20104;
	Thu, 18 Jun 2026 17:28:53 +0800 (CST)
Received: from localhost.localdomain (10.50.87.83) by
 dggpemf100008.china.huawei.com (7.185.36.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Thu, 18 Jun 2026 17:28:52 +0800
From: Kefeng Wang <wangkefeng.wang@huawei.com>
To: Andrew Morton <akpm@linux-foundation.org>
CC: David Hildenbrand <david@kernel.org>, Zi Yan <ziy@nvidia.com>, "Liam R.
 Howlett" <liam@infradead.org>, Lorenzo Stoakes <ljs@kernel.org>, Vlastimil
 Babka <vbabka@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
	<linux-mm@kvack.org>, Kefeng Wang <wangkefeng.wang@huawei.com>
Subject: [PATCH v2 0/4] mm: convert to walk_page_range_vma() to eliminate find_vma()
Date: Thu, 18 Jun 2026 17:28:41 +0800
Message-ID: <20260618092845.3905740-1-wangkefeng.wang@huawei.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.50.87.83]
X-ClientProxiedBy: kwepems200001.china.huawei.com (7.221.188.67) To
 dggpemf100008.china.huawei.com (7.185.36.138)
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 48FE2C0002
X-Stat-Signature: e9f7qotenzr1kdqgcqdjrtxa581cstj5
X-HE-Tag: 1781774938-961538
X-HE-Meta: U2FsdGVkX1+yIbLWHno2dRJ2glzJcWIGSqdpw5X68IxBM31vHNM+4l7pdkELjsimmXaIJQpHaxv5Pbpw14ta05ZGywt4tcNXosIQbswHOsKkZx/GL7FmoK4+5TC2G6FvLxef3kn0ENqyiEor9MtwzOs/7EqfGFIg8MO0iAXEcfdXEzomRDlHlkEcAhXpnGg8Swv/jtmst56MVua6oz50Ybi9/xUd/1k4evzILpFksHYtZop9Fk23vubDFPB7xcerqkNjFERZA5i5tTP3DL7LSK6YPz9/EoFKsTshtuHcopwCZCX+ZNHtow4NnySOVm4Omz37yU9ftUGYjcCsO47Vj1ef+GDuTR11zth+WvfN0o+ymltd5H3UdwwiNuL9KMmBfGlmKua52FldAJmjqXcIcOi8FF58P5ShqoGwIZdPD1we3ruc41wNTx3orxwRtFqaTf6RkTOrcTlZiz9buvUBKjWKzur4pgMotow0HVhYVMfxQDysS8yaRWadadwynLlLuadsC89RhcaLJgyArTzDjdSrDULV9D5TPCkhveaTLgORfOezGeh7tNsT8nBFabUNmxZOb2Rc4dVYcLEdsaa6QzihHCDdPn6TCou5hsbiQJcYvvn2HwC9rNje2KRi1Lwufvs1CK96QPfDo04WKdCTgmcZO6Cv6xVpAmH/H4JEPpRFbTrOHrCElBRL6RZSMUOHVEAxGzr1nWIOU2cq4A2l81N/O228HsQe61Xs97qKaH3YjKVco24OhvZpC4mRY72LSpT1OFm4JgsqCR2sxmcmEsMdC9EKgwLbTWED310CrVKRsRLxv8vAgt4ZuZB23wxF5E9pMg4zh5nLZfb4b1ewd/SkKBmmlnYYK8ee51unkSiUdpJebuv2nQl+q+t14QYcabEiplWJkzxvNh2ox4fQ0ZrACeMsywgqgH0gwfstqkd0+ojjA8BFfM5Pu7pz2GI7YPMifhauJ4BmiM4MgHp
 g/AfGbqB
 KoAXZb6bQv1lpctFWo8b4upp2gZG0cND4QdaKow8qKX504vkCDA/AJntr0e2psEnQ03SOtj2eleHM297aYtijbXm6cScQeM9hL+WHTrMPztXKK0cL2AEToQLot7sJ3UodssMheEFROFBElbLiLSwRVezI7NkscYRW112F561+cThfk/WKUlWjK3ujSIRbhr2kK+sPcDshDaEb/8e8bEatacA5xVLO9SqKTfAWW0TfEXOajTIBJDMy7bvP7o6alekefmW64zSyy7GC6WTmkJZ/xDM7HaZmh5PXAO2AnVhqQK7V/IYQG2+Hwp9yavzhTK0rjeT+g+9p5Y79uXgHbsa46mUuIg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

walk_page_range() performs a find_vma() lookup on each page table walk.
For callers that already hold a valid VMA and operate on a known
single-VMA range, this lookup is redundant. Replace walk_page_range()
with walk_page_range_vma() where the caller guarantees single-VMA
semantics.

v2:
- Address comments from Zi and David
  - per-vma optimization is separated out
  - Remove unneeded prot_none_test()
  - Fix some spells and collect ACK/RB

Kefeng Wang (4):
  mm: mincore: use walk_page_range_vma() in do_mincore()
  mm: mprotect: use walk_page_range_vma() in mprotect_fixup()
  mm: mlock: use walk_page_range_vma() in mlock_vma_pages_range()
  mm: migrate_device: use walk_page_range_vma() in migrate_vma_collect()

 mm/migrate_device.c |  2 +-
 mm/mincore.c        | 16 +++++++++++++++-
 mm/mlock.c          |  2 +-
 mm/mprotect.c       |  9 +--------
 4 files changed, 18 insertions(+), 11 deletions(-)

-- 
2.27.0



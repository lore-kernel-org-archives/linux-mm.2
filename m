Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C82ECCDB479
	for <linux-mm@archiver.kernel.org>; Thu, 25 Jun 2026 01:51:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8F1A36B008A; Wed, 24 Jun 2026 21:51:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8A2576B0093; Wed, 24 Jun 2026 21:51:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7DFDD6B0096; Wed, 24 Jun 2026 21:51:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 561D06B008A
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 21:51:21 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id D06A81C5932
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 01:51:20 +0000 (UTC)
X-FDA: 84916757520.20.1FA8714
Received: from shelob.surriel.com (shelob.surriel.com [96.67.55.147])
	by imf20.hostedemail.com (Postfix) with ESMTP id 4D5DC1C0005
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 01:51:19 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b=ODj1knlQ;
	spf=pass (imf20.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782352279;
	b=l58XmvD97a0rDscWbBtniS0QBFRmBqt8Ae5D73qZmerunupb6ciTIVy9RH/kUZmaoHgQdI
	txhEXLKx5m5nFM7rrFVjsH597VG4RF/hSD8P0gde6SXleUvSDs69jH/1YlCdaRtqdn6mbN
	kfR1hBszRPr/5RVx2b6VmBkafZxkdLk=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782352279;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=u9HU7XV4dq9bzcetrDqyjXjgnqFK6qdyibEIPnwFXAg=;
	b=e3MB9+Y9EoOAppZfJfoUpGCl04cU46JknUUx0rwfGDto1DGeXNY3T3/iWS9MjXcUyzoqVo
	vOhZ5bvYeWKkFmLRFHvjAG71UpCyA0pew5djQxO0UhD+8MMOQ/FNUUmDNkX89V0IPPyFfz
	1/OF1Onewi+PVDv8/gJnUBu7l1Eld2E=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b=ODj1knlQ;
	spf=pass (imf20.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com;
	dmarc=none
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=surriel.com
	; s=mail; h=Content-Transfer-Encoding:MIME-Version:Message-ID:Date:Subject:Cc
	:To:From:Sender:Reply-To:Content-Type:Content-ID:Content-Description:
	Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=u9HU7XV4dq9bzcetrDqyjXjgnqFK6qdyibEIPnwFXAg=; b=ODj1knlQNZAy0yrvLN7Z15LCBx
	ysHnlztoHQ7aTa7FssgKHAVYUrCSlGDZlIqDSnU6A1FCo4HgVN79HBGSPaJGqsjBs8GpHDZOGDorZ
	uscMtkjdU+sdyVwn8Udr2eE6h+tQOkvFhE1yp/7DUz/81EBfL83H87eBRNPt3vaLqJ0/tMpm2YUJa
	8NxufMa51SKQmpUifkTE1lCC+HWUfMrltX3LKjivhDrgWa1i5AWz2RfORFjYoZ38wM/WdmbBXmRb3
	sUT7AfUFQc6JyYa1VioPYZL/qIpaBdGMHWH6tWUvW0kP0lJJFbzGkGITBG191kWMqnf68ILtPojDv
	zusnuohQ==;
Received: from fangorn.home.surriel.com ([10.0.13.7])
	by shelob.surriel.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.97.1)
	(envelope-from <riel@surriel.com>)
	id 1wcZF7-0000000043x-3LaP;
	Wed, 24 Jun 2026 21:51:01 -0400
From: Rik van Riel <riel@surriel.com>
To: linux-kernel@vger.kernel.org
Cc: Rik van Riel <riel@surriel.com>,
	x86@kernel.org,
	linux-mm@kvack.org,
	"Thomas Gleixner" <tglx@kernel.org>,
	"Ingo Molnar" <mingo@redhat.com>,
	"Dmitry Ilvokhin" <d@ilvokhin.com>,
	"Borislav Petkov" <bp@alien8.de>,
	"Dave Hansen" <dave.hansen@linux.intel.com>,
	"Andrew Morton" <akpm@linux-foundation.org>,
	"David Hildenbrand" <david@kernel.org>,
	"Lorenzo Stoakes" <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	"Vlastimil Babka" <vbabka@kernel.org>,
	"Suren Baghdasaryan" <surenb@google.com>,
	kernel-team@meta.com
Subject: [PATCH v2 0/3] mm: __access_remote_vm with per-VMA lock
Date: Wed, 24 Jun 2026 21:50:50 -0400
Message-ID: <20260625015053.2445008-1-riel@surriel.com>
X-Mailer: git-send-email 2.54.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 4D5DC1C0005
X-Rspam-User: 
X-Stat-Signature: 7gq79wk3oetrstn17fadq4akgmq8ic3k
X-HE-Tag: 1782352279-737253
X-HE-Meta: U2FsdGVkX1/2XWtT6miRjPGvCVOEkitVSDcTMJ6sQks826E5yWvk6aEPE26+lLXL0ubVADxPdv3myJorjtmVL8GV7Hkis5nC/emDIe7mSMcVZuEDCTpdH87WMvcYpwVoT8Rcq28nYC1VyGIOlL53Jw+4vpP5jZAzcUCFqp1rEgJnNYo5+sKoFX81ZpzkcOcWF0tmb50NJogo0IgzkSGkOLZ/wr2gTTwkGVRorxLQYWmIdT6yNq9lFT7t+Q17wn84/ShEouP3i4Wyz7QlItk1Hz6RsRJRoAgIGzYHvcKxfB0Q5gESSR8TloKExI1DslzCXtkLt84jZqpBfDdG2HjH2lusEofzQiuoij3b4By+WcJRdJ0I4kFIK4B3w2cGRBAdIb4S4gCqJXJWBdMJ1qbUmYIx9H9Shztz6IDrDdcdc5bot8PG4MGjOkwXt3xHPuug009VjvzVqnsZE4nm/XissKPg7b5EoSdFQkaiQaku4YKinxnHDKjJQ/ZVKEWn6qrY9Ok+PKndOf66uO8ENlao2P64+t80SzkasUzhkxZRiTnYq4PDl2Con14DWlIKZlrwZ79IsG2WuJiDiZpy9snj0PDTD95d5waZynRJ87BlfNKUrqZW3LTK9AGQmuWPSJRcTAEZExFG7MFMkxDnrfSZ9perZx3Ioiqp884Wz+3nErW8JdNMbgvYumWCzzFe4RV60UI5z8W+d05uIpMyjctpw7XyzUQcOj0nXWEoH0DfstZ2CxIaOM/uwBb+X2+MTzzs58HsRszxcnjvQY4yyhCwe0jzTtAavdTDD/lI+sL07G3+BvjGEIzV4ROQwrqreO6sZTEpCLldPqDKTbN9F3A4Hcup76jUQGLwhiz8598fBuP/sOL+aUBEJk6Ir+9NqH3qvRa0ZRkCqv+xhI75p5KatfYEBdcx1tHpyps+buqZQy1S9S6JXvcjIkcPUl4XN5NkyWO0xubAJBC+pJnQMnY
 Cdcz3VD7
 34/qcslK3QVzsg22IW9QfUf7z7m35W1FmSSkveUoZ3h3Frqnv7k83Ag5G+FpQlUVKQu2/D74wMpPRh2bO3cPzisWzBw5c9aYkG+wcr73D85H7APPBXB5peAm3oYlcaJo5prCKcl0JzhILE1bcHD3zZUGygnWevmjERq8qzwWiOqcUKR4eqCkwBTLgHbkklVxinnqB1sKC+RPYY63kVbeDIfkFSFx+29Sre3j+LDsMpSDSHKh+omxefEJRtccLzE9lHvEP
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Sometimes processes can get stuck with the mmap_lock held for
a long time. This slows down, and can even prevent system monitoring
tools from assessing and logging the situation, because they themselves
end up getting stuck on the mmap_lock.

However, with the introduction of per-VMA locks, we can improve the
reliability of system monitoring, and generally speed up __access_remote_vm
under mmap_loc contention, by adding a fast path that does not require
the process-wide mmap_lock.

This fast path is only compiled in and used when it is safe to do so,
meaning a kernel with per-VMA locks, RCU pgae table freeing, the VMA
is not hugetlbfs, iomap, pfnmap, etc...

v2:
 - simplify the code, which should be ok because these copies are < PAGE_SIZE
 - clean up the code
 - fix locking wrt tlb_remove_table_sync_one()
 - hopefully address all the other comments


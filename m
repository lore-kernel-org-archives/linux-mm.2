Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 95A2DC5CFDB
	for <linux-mm@archiver.kernel.org>; Thu, 13 Aug 2026 09:34:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8BC4E6B0455; Thu, 13 Aug 2026 05:34:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 86C946B0457; Thu, 13 Aug 2026 05:34:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 70DD26B0458; Thu, 13 Aug 2026 05:34:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 4324C6B0455
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 05:34:19 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id A129912054A
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 09:34:18 +0000 (UTC)
X-FDA: 85095735396.16.2736A9C
Received: from mta1.migadu.com (out-91.mta1.migadu.com [95.215.58.91])
	by imf10.hostedemail.com (Postfix) with ESMTP id C23CDC0004
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 09:34:16 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="Ve/BuX7Y";
	spf=pass (imf10.hostedemail.com: domain of hao.ge@linux.dev designates 95.215.58.91 as permitted sender) smtp.mailfrom=hao.ge@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786613656;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Zyjkd+cvn/7XeIzSsbDCrHYD58chJDf4uurPgDEzVNY=;
	b=sxhQcpNglLCWHPjC1UolX3B76R2BlftStR7ygC3OhfN+xKfePFf8Kk/4XP5xIuNXoZshUN
	eIU3+oSPWScTuU6KsNbshsZ0lx1zvOiSeGBjSZJq3HKm57fTU2/hPAv+JAzOJyKs413hGD
	5/HRnj4EFPLI+wbuSefcrHBlzK8iMF0=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="Ve/BuX7Y";
	spf=pass (imf10.hostedemail.com: domain of hao.ge@linux.dev designates 95.215.58.91 as permitted sender) smtp.mailfrom=hao.ge@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786613656;
	b=W06WkMRWU0UXlPWvnCeem1SNjaZj5/44gaAxvhVEoJ8FGulMZbYpp9lLssRpYG8KSvSOGo
	b7tnm22fdnzjCj16Xwe0Nncio/8fEdI4iN1KaD/ENlrQiP1s9qIasypdgEL+HakfomsST7
	Eq6LNfoIIxOnzrJ8at93dErZwdvF8LA=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=hPN6+ldNa92yVfg5JXt1vgfrSMYfaiItc5ke6iFo9is=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1786613655; v=1; x=1787218455;
 b=Ve/BuX7YWVqBo/ABZYgyXwpdHXANW8oh1K46WtEot5WlWwmlYaJrvYjXQhvPqtcxqNv57CDf
 J3fVIefYJeNAyVzqJeKfPvoOncCJ+do2gCvzPN3p5/YS+zYWDfd1LnSSeOla5eG+PQtsyl95qRp
 iuKV9mdSoApubKNnmXlRU5JM=
X-Envelope-To: linux-mm@kvack.org
Received: from localhost.localdomain (116.128.244.169)
	by smtp.migadu.com with ESMTPS id 20da645f262052b9;
	Thu, 13 Aug 2026 09:34:15 +0000
X-Migadu-Flow: FLOW_OUT
From: Hao Ge <hao.ge@linux.dev>
To: Suren Baghdasaryan <surenb@google.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Luis Chamberlain <mcgrof@kernel.org>,
	Petr Pavlu <petr.pavlu@suse.com>,
	Daniel Gomez <da.gomez@kernel.org>,
	Sami Tolvanen <samitolvanen@google.com>,
	Aaron Tomlin <atomlin@atomlin.com>
Cc: linux-modules@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	Hao Ge <hao.ge@linux.dev>
Subject: [RFC PATCH 3/3] alloc_tag: remove /proc/allocinfo outside of mod_lock
Date: Thu, 13 Aug 2026 17:34:21 +0800
Message-Id: <20260813093421.135230-4-hao.ge@linux.dev>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260813093421.135230-1-hao.ge@linux.dev>
References: <20260813093421.135230-1-hao.ge@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: csxaiiowz74n889sfhd6dhridhcmnrpy
X-Rspamd-Queue-Id: C23CDC0004
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1786613656-67706
X-HE-Meta: U2FsdGVkX180bvkpX49U3AuoTrhcqhwQy6AWaRVpQPlPPpktZFCKW1PMuir2uos1aWcMKIocJKPtE+ACbqtAGDzAEsz/RxmshXdc+HOnZsSEXBWT/Oj45TBYijx52+6WnZKelB2EBYJTBRrPmffCwMgicpLubjMNI4Oxz5La+qmZr2/Mn0i2TS1EYjPEEmuZTowKxQxQwyiK+hAwrGHNokLrMDZ4WQ2sH22c/EW7d1C4MdGj6EK5aQLsAoG7rA7NfCFqLPQKuv4FVXNdI0hqinksVSwPZzvuLAAXuTy1YNi6EwAM/WByrWk18sFakc6lJAfi97MyuQh7GyPUsc6S6yE3+fkWnaPa5/WLs4jgYiPVkKzCFO6fHv2ZciA3CxbYZTA9H57IfHpzGsFoEetMTaoBuK/8ViZEU/60EShXc6t1z6s15Y8lXFXGJFFJw01OGLHxEXenWIYTYgTvNt62QlZ667zYQJNComzT/jPO8FpPCNqjUhuQmIUi3DT0UJfci0LXC4OoeCf6GtfH+70/ysggaDjuoEephTgbzvgthCTrnHTiSA0ar3yohLXYjRvZUG6jM9FWmca4srPA+ph/bSPoLAp2WpcDObGcPG13m/0OJyC+Lv1RDQTgczVeni2LS+t64rENZlYRhwrM67+qbLQiRYnfEtibarwadET6JYiI4GwXb2pvV4ORakJxOaoeVaIEosz7++YNb8LJdMzw+I1/Jhq2IJMAOAjZN2ZNRjCKU9oSBJtzIdtCeSjv9mbJbOXmO/u1psmzuETX281ojBEw+nRzT+6a6O69j1Pdi4lATRhtwbr1/tiZi19YocSEN0wpxOw63+BZ64GooUyx8sB+Z66CSL0ykKsddu7I9OPXCs+CIXMw2A1Y5Jfn3KSWm61UCi+N4lvomuQ76cJHlvhNqd98Fp6ojKgU/uIMjwyNocUnE8DeHSZ9ARAyy7FWLT7JvRT7xgB14vTlXVd
 eVjS0HTX
 7WeCHg8TX7LJtb2M0eXQF85JyU5rNcg8xg4598piGTmtbq4r0wdEtuufBs/S8qsRseOmHa63urTqK400vGaQxquTwJe2sNKqfgWrq8IZOcGTcKmvL59A+eXtb30YWV/d74rPLw3PtlWIWIG7HlqxMUfH+83rbdjMD6yUCffSwgU2bzD0Q+oxaxvUTekvwz3gKpLeAhGhSKZT72upbZogbtvOMuc+mf6BXwWkY8X9TiN2Oam4tbbvj9jyBWfxJzogiey71LpmcPh19UDIXqXNYq+QwLw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

shutdown_mem_profiling() calls remove_proc_entry() from
reserve_module_tags(), which runs under mod_lock held for write.
remove_proc_entry() waits for readers, and a reader takes mod_lock for
read in allocinfo_start():

  CPU0 (insmod)                      CPU1 (read /proc/allocinfo)
  ----------------                   ----------------------------
  reserve_module_tags()
    down_write(&mod_lock)  [held]
                                     use_pde()            [in_use++]
                                     allocinfo_start()
                                       down_read(&mod_lock)  <- blocks
    shutdown_mem_profiling()
      remove_proc_entry()
        wait for in_use == 0         <- blocks

Move remove_proc_entry() to a workqueue.

Fixes: 4835f747d3ed ("alloc_tag: support for page allocation tag compression")
Signed-off-by: Hao Ge <hao.ge@linux.dev>
---
 mm/alloc_tag.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/mm/alloc_tag.c b/mm/alloc_tag.c
index 7481180dadd2..b80f5a151f28 100644
--- a/mm/alloc_tag.c
+++ b/mm/alloc_tag.c
@@ -591,6 +591,13 @@ void pgalloc_tag_swap(struct folio *new, struct folio *old)
 	put_page_tag_ref(handle_new);
 }
 
+static void remove_allocinfo_file(struct work_struct *work)
+{
+	remove_proc_entry(ALLOCINFO_FILE_NAME, NULL);
+}
+
+static DECLARE_WORK(remove_allocinfo_work, remove_allocinfo_file);
+
 static void shutdown_mem_profiling(bool remove_file)
 {
 	if (mem_alloc_profiling_enabled())
@@ -600,7 +607,7 @@ static void shutdown_mem_profiling(bool remove_file)
 		return;
 
 	if (remove_file)
-		remove_proc_entry(ALLOCINFO_FILE_NAME, NULL);
+		schedule_work(&remove_allocinfo_work);
 	mem_profiling_support = false;
 }
 
-- 
2.25.1



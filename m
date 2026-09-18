Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 37EB7C982DC
	for <linux-mm@archiver.kernel.org>; Fri, 18 Sep 2026 11:27:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4DA676B009D; Fri, 18 Sep 2026 07:27:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 48BE86B009E; Fri, 18 Sep 2026 07:27:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3A1C86B009F; Fri, 18 Sep 2026 07:27:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 1CAD66B009D
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 07:27:36 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 409294066A
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 11:27:35 +0000 (UTC)
X-FDA: 85226657670.16.1B3AB07
Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	by imf09.hostedemail.com (Postfix) with ESMTP id 6E9C2140004
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 11:27:33 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=rVijSmRr;
	spf=pass (imf09.hostedemail.com: domain of leitao@debian.org designates 82.195.75.108 as permitted sender) smtp.mailfrom=leitao@debian.org;
	dmarc=pass (policy=none) header.from=debian.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789730853;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=g2dHWBlF2h2VLId3fgErv67RQdJUNg2b5tSkFjp3B+g=;
	b=vqacCEvMui/2lva0grE8yqm+AfMGyG6xZvUvZiuII/OprtlbomSniZu1BMoY/Q4MfH1co/
	8KZqSwk8ZGtGBmagTt/mJyV2br3QbLGjAEI5+qTY4H9ol40u+MOiS/6+FdexdvwuxM7GJP
	jiWM4Y7qWBLD1X4AU6JN+DyXejKNShY=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789730853;
	b=TegzWd+KytQ+Lt7D1kLaISS4RYbp6r9gBxV3TeAAjrCeM7MwQr74rDOa7X0GaafDyAyuLd
	8Xck85HtQzz9aujdWDcqH6RCu/RLgbIjBE++KBl43kJC1F1dE0F++FZaAhn0LfT1Jbi97W
	2W8Pfa3oI2dwQmiF23sK+qKfH2+ASQs=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=rVijSmRr;
	spf=pass (imf09.hostedemail.com: domain of leitao@debian.org designates 82.195.75.108 as permitted sender) smtp.mailfrom=leitao@debian.org;
	dmarc=pass (policy=none) header.from=debian.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:Cc:To:Message-Id:
	Content-Transfer-Encoding:Content-Type:MIME-Version:Subject:Date:From:
	Reply-To:Content-ID:Content-Description:In-Reply-To:References;
	bh=g2dHWBlF2h2VLId3fgErv67RQdJUNg2b5tSkFjp3B+g=; b=rVijSmRrA8lz+iqY4PR5LEuTdU
	HJR5o4zgFaqkLhUgwAIY2VSAvTwpblemHbiML73A+MmxgGE3WU1//Mp5x1MauTSNjgEl5quI0ENgB
	4TjX16rYiEhIEwV9aKez0BXx7y4qfuo57rInPJTrbH8kPAXkRJQhCufUq6lDa9jcxVaOABlJdr50g
	h36VFene43tCQh+TUyQniE7MzHf+OdY+c2B137tFy1f3z6C9YU2D0tvQ3zaHf+rmwE76ShJcEQG1g
	FZHHyCjg/y5QApMnaETN6iAaj7xrDcvF9GBFPB3wdVsXltSA5EhZXI/qwj79Aw1RzZb3OqhXBPe9A
	JAVBYT5A==;
Received: from authenticated-user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.96)
	(envelope-from <leitao@debian.org>)
	id 1x7WkN-006gV4-1R;
	Fri, 18 Sep 2026 11:27:15 +0000
From: Breno Leitao <leitao@debian.org>
Date: Fri, 18 Sep 2026 04:24:37 -0700
Subject: [PATCH] mm/shmem: report RCU-tasks quiescent states while undoing
 a range
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260918-shmem-tasks-rcu-v1-1-79acf91a2569@debian.org>
X-B4-Tracking: v=1; b=H4sIAHUfrWoC/yXMQQqDMBBG4avIrB2IBrT2KuIixt86Fa1kVATx7
 qbt8lu8d5IiCJSeyUkBu6h85ogsTcgPbn6BpYum3OSFqbIH6zBh4tXpqBz8xkULWzqU1vSWYrU
 E9HL8jnXzt27tG379bui6bu5gN1pzAAAA
X-Change-ID: 20260918-shmem-tasks-rcu-6be37ae730f3
To: Hugh Dickins <hughd@google.com>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 "Paul E. McKenney" <paulmck@kernel.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, kernel-team@meta.com, 
 stable@vger.kernel.org, Breno Leitao <leitao@debian.org>
X-Mailer: b4 0.15-dev-47773
X-Developer-Signature: v=1; a=openpgp-sha256; l=1826; i=leitao@debian.org;
 h=from:subject:message-id; bh=eZbZRybmvbmsk4XGwSN+uF/t4tuxC4PxmlKfpNHKNvc=;
 b=owEBbQKS/ZANAwAIATWjk5/8eHdtAcsmYgBqrSAPgk5hcnjQgEmmh64DV7Rb8qMEEDXgawjlV
 DOSg4Nw0sCJAjMEAAEIAB0WIQSshTmm6PRnAspKQ5s1o5Of/Hh3bQUCaq0gDwAKCRA1o5Of/Hh3
 bfopD/4jpfXFv7nsm1ZRGAs+v/gSWTu7RgJ0dXlL9sIeZ3yno3H077vLuGyAQ4GOGRRLNXd8MUN
 TubSSof/1AB/Ub0fGl7lCs+W+NNTxIJ0DYz9GhdNM2yGtPxn+KJcSU5bnymtiGH699KkYojmf6M
 SrhTvxzVf1r4lERIC+GOKLWqoueBHmLE3DqswWifI0YBtoObaRWeP05J9axBSpXhGsD4girbfH4
 ePacexgDRuq9VoSV5UwudGR6VyVKV1/ypoY93bR7xGOtnotDHByGGulslCTFYyWQYqrwpnQLxSi
 6k0QMHu9jpSH0iOSFdkRxAfSzH1+dvrAH97dB374O7+yudgn9ofEnR9S2z7lxAvBJ+/8Gys2Ira
 PnCyyzSKkd6cuQn9z/nCFzf0OyxIEoCkmtlvsVwGOORhAqavpvIFhG1tlj1Umv3RMJxrM5YXEdM
 hsVZNSkhmKdZZC8VsplaX8ggJC1KTIFY0MC/OOVMbsRSFA0k+6Xmb1im0P4900mEKRZ0NBlSv4G
 5LDwvJ+VHwYOgVEMG8Ov6qR9fn9jV9KiNpSQigbxod6pMH61lny+s6aIH4ckrAAHYZ6lBk4bZPL
 +MtYyqYwMcwfS6Afo2gaxn+iPlBmqwAccoWTPqr+3WUmhgFAAeC0B+avIpaBUxlXwvqy5g0aAUP
 yLSTb32L6gOVroQ==
X-Developer-Key: i=leitao@debian.org; a=openpgp;
 fpr=AC8539A6E8F46702CA4A439B35A3939FFC78776D
X-Debian-User: leitao
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: e1f1i1y51ttu3g1qdi8bjnhefcmdt138
X-Rspamd-Queue-Id: 6E9C2140004
X-HE-Tag: 1789730853-782902
X-HE-Meta: U2FsdGVkX1/6zpO7nFUp0nCtw3wiJ21vllxNKFuGNraGkmz+pYdCafby5hx4SnIHq2/zUS/p/Q3gZ5MZqWscsp3oVTSHHE7YIHIi978zSPSoPjbErjb9+RpsjtBFvOLry2bPdK67rXyW/vEFAkGVPttToNo9Tx7BdAlfvm8gSX9TwBqQMUHYvIHSx2pmu8LmiWBzrfphZqqW5Tui8xuoF2MeaJ8t2gMmprlrbwdZqULy5sxqxjHjZg5oiTuvOpSZ7xg0lH5zPmBPYXTBVj4m8yUJvrFReXuP4uaWV1JqHDFkLdjIMDZ5/IPDcJqlL+ZtupiVw317NGKaRt6MLKfThz9c4SVZ5xSt0muCJVp4GFP+FlJbdJXWYyFxpA94airFU5PNuwfQuDrb3UXvKC5nk4wsXwqMVW7x67nBtWMa4/w+v+JcpBVl5BpkzYndSoPmBaFWPM+WTUpkws0rT89N/B2TvriV0uBQl0xBjR8M54O0fYvobb4GsykcgSqNu2kYmqjQZUc10taxjGIlwYxDUJ+LPwY2N77yiC+/tpY3qhYhU72Mdod/GxZBLn8SktchyaoflgnVd5jsi1eTDB1gt8Xz+7dhcEFIt+gTq2op6HsFjAsC7soNd6DXd67Qpnil5Ps6QsqldhzGfnEW4aVEHs0mv17VFdHieNn3p0fRfR48ZQhVIf2Lq5lZA8wWoQwNur+czG2l8K4d1TGWtwdpD0NxuksxEkSkaDTJbhyI7vjZFE7Lg6lMbdR+z7aaUUTYNZif4u/rFe3zPN5IPLmUVdYOwUipUODPKoHI1wap23w89GGS5pEyII09WGJGTIVZg1O99jlaOMaJH8tjxV5aqVAujiTpeqsNXdMatNQZ0gHKoC44y7Zg++c5BQD8WD7LJAuU1/qD70NRzky1Cfg254xFaqG2/m4ANj2OpED6eNlX2yJgN9xKacmGpNp9Dx6OBKFmYipDsdMwzepERxV
 oHX5N5FP
 VcXOdPlg8T8BndR8TxkGtAOGnFo4E1Enr+zib715VzAjXED98+KbrOL3cVmUGKOK2fEekX78bPakPJgSZblNbrF9I8rawzZTittEVLkLBphFYFBVkGLJB3yjRTnQkTAXem7sIHaYBTxD5dpZNT3SwUiVR3E/iuJlavZgPSnuCO9+qNL3+ciQC2kCJeemH+BKnayHaJraMbnOQBf5sYR8T3F99oAKyYXM9Qno4ItTmHWg4SRi+8LMEUHD2SKXpc6yuPxhhh6H5YV4/mqFAubAZ8StneCoPeVndukW3NM+BTfI+gI697NX+QLVo6w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This shows up in the Meta fleet on ftruncate() of large tmpfs files:

  INFO: rcu_tasks detected stalls on tasks:
  00000000752fd185: .. nvcsw: 59455/59455 holdout: 1 idle_cpu: -1/0
  task:rocksdb:bottom  state:R  running task
    __folio_split
    find_get_entry
    find_get_entries
    truncate_inode_partial_folio
    shmem_undo_range
    shmem_setattr
    notify_change
    do_ftruncate
    __x64_sys_ftruncate
    do_syscall_64

shmem_undo_range() walks the whole of the requested range in folio_batch
sized steps, twice, and its two cond_resched() calls are the only
reschedule points in that walk.

cond_resched() is not an RCU-tasks quiescent state.  Use
cond_resched_tasks_rcu_qs() at both points so the walk reports an
RCU-tasks quiescent state as it proceeds.

Fixes: 8315f42295d2 ("rcu: Add call_rcu_tasks()")
Cc: stable@vger.kernel.org
Signed-off-by: Breno Leitao <leitao@debian.org>
---
 mm/shmem.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/mm/shmem.c b/mm/shmem.c
index b572c60f2af85..bf48cb49565ea 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -1367,7 +1367,7 @@ static void shmem_undo_range(struct inode *inode, loff_t lstart, uoff_t lend,
 		}
 		folio_batch_remove_exceptionals(&fbatch);
 		folio_batch_release(&fbatch);
-		cond_resched();
+		cond_resched_tasks_rcu_qs();
 	}
 
 	/*
@@ -1408,7 +1408,7 @@ static void shmem_undo_range(struct inode *inode, loff_t lstart, uoff_t lend,
 
 	index = start;
 	while (index < end) {
-		cond_resched();
+		cond_resched_tasks_rcu_qs();
 
 		if (!find_get_entries(mapping, &index, end - 1, &fbatch,
 				indices)) {

---
base-commit: e657a464aba873f5eaf3ca821b6e4016674492d6
change-id: 20260918-shmem-tasks-rcu-6be37ae730f3

Best regards,
--  
Breno Leitao <leitao@debian.org>



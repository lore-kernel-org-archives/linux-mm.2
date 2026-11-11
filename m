Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F22C3606A33A
	for <linux-mm@archiver.kernel.org>; Wed, 11 Nov 2026 06:46:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=cmss.chinamobile.com header.i=@cmss.chinamobile.com header.a=rsa-sha256 header.s=default header.b=XSCYPU7A
Received: by kanga.kvack.org (Postfix)
	id 12A706B05B1; Wed, 11 Nov 2026 01:46:56 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 102496B05B2; Wed, 11 Nov 2026 01:46:56 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 01B846B05B3; Wed, 11 Nov 2026 01:46:55 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D46F06B05B1
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 01:46:55 -0500 (EST)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id D923E801F9
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 06:46:53 +0000 (UTC)
X-FDA: 85421905506.20.AB37AF6
Received: from cmccmta2.chinamobile.com (cmccmta2.chinamobile.com [111.22.67.135])
	by imf05.hostedemail.com (Postfix) with ESMTP id A10E9100005
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 06:46:49 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=fail ("body hash did not verify") header.d=cmss.chinamobile.com header.s=default header.b=XSCYPU7A;
	spf=pass (imf05.hostedemail.com: domain of zhujun2@cmss.chinamobile.com designates 111.22.67.135 as permitted sender) smtp.mailfrom=zhujun2@cmss.chinamobile.com;
	dmarc=pass (policy=none) header.from=cmss.chinamobile.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794379612;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=1zOfDWlY9E9tUb8YUI6fsfw2lGwWkARTEb35JoGHspk=;
	b=FuZYjzby3rFmIqYiahlHKvWmloDzp7gMR8t2i2DnS+Gl7isEB+jJGmIsVwMmtWr8dFdRtN
	FuOg/ArhG89ONRhJa1KgPHmdHFnfV5psaR9E156Zths8Wxod4CQSun9eOWmkWhvy9BfdUM
	wCVMilUzcf/0cqgj7wcA+tgS5QVyY1Y=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794379612;
	b=oqjt2aMbvuSttn5m99HtZG1LJGLot9a/Glg2oFhlxBEttJc6ocHbgTRnFLnj7dhbe8ItOf
	S+Z/Sd4c4uoVsRfxYvOL1T4qZryIe6tAHMqXGzhXoDdleNCVCwYGVMGwsSSa/zNK3tL4b2
	jVFkjVL0XfaW0L+WvwARpp6gWuLCf48=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=fail ("body hash did not verify") header.d=cmss.chinamobile.com header.s=default header.b=XSCYPU7A;
	spf=pass (imf05.hostedemail.com: domain of zhujun2@cmss.chinamobile.com designates 111.22.67.135 as permitted sender) smtp.mailfrom=zhujun2@cmss.chinamobile.com;
	dmarc=pass (policy=none) header.from=cmss.chinamobile.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=cmss.chinamobile.com; s=default; l=0;
	h=from:subject:message-id:to:cc:mime-version;
	bh=47DEQpj8HBSa+/TImW+5JCeuQeRkm5NMpJWZG3hSuFU=;
	b=XSCYPU7AeqaH6GEWuQCl0edE9BZx3+FzR9VaN1wQJKGTMuVUMmho+zW1/2g5sfYlh4MA1Kjb1jD9v
	 Xu8SRnmZsQfxOrG0q0Tl5I/XkxYIrzPVs1hhlBWZ157AxR3Q5pTel8AJ7LGDw4drLs6uMWN9o6+Xh3
	 myuDw044Vlkn/pik=
X-RM-TagInfo: emlType=0                                       
X-RM-SPAM-FLAG:00000000
Received:from spf.mail.chinamobile.com (unknown[10.188.0.87])
	by rmmx-syy-dmz-app07-12007 (RichMail) with SMTP id 2ee76af40f546b2-d5fd9;
	Wed, 11 Nov 2026 14:46:44 +0800 (CST)
X-RM-TRANSID:2ee76af40f546b2-d5fd9
X-RM-TagInfo: emlType=0                                       
X-RM-SPAM-FLAG:00000000
Received:from devin-VMware-Virtual-Platform.localdomain (unknown[10.55.1.72])
	by rmsmtp-syy-appsvr01-12001 (RichMail) with SMTP id 2ee16af40f51e23-d1f1d;
	Wed, 11 Nov 2026 14:46:44 +0800 (CST)
X-RM-TRANSID:2ee16af40f51e23-d1f1d
From: Zhu Jun <zhujun2@cmss.chinamobile.com>
To: jack@suse.cz
Cc: willy@infradead.org,
	akpm@linux-foundation.org,
	linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	syzbot+c4e217748763d41236ee@syzkaller.appspotmail.com,
	Zhu Jun <zhujun2@cmss.chinamobile.com>
Subject: [PATCH] writeback: mark concurrent accesses to the aging period time
Date: Wed, 11 Nov 2026 14:46:42 +0800
Message-ID: <20261111064642.17114-1-zhujun2@cmss.chinamobile.com>
X-Mailer: git-send-email 2.51.0
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam09
X-Stat-Signature: 338eu46mrgz196icw17fwcgbzcdnj3xu
X-Rspamd-Queue-Id: A10E9100005
X-Rspam-User: 
X-HE-Tag: 1794379609-805234
X-HE-Meta: U2FsdGVkX1/jecWy8tCJJXDgeIExTQRKIfX2h5jyoQp0WSbLsKQzuiLavzmp2hi505TI/i0sAoL+agcsHTD+5whHfHO8haOv6qL7ly4NvuLP4qbLYlnE95uog06sO6rLVxAYDWfsG5p2RRn/ggahLi5caaAzyXBLTMrtTwcKQyLmYlxh/O6DfMQUkcSCtA7kC0mF7lyPIYZjaapz4e/jalgN7ru6fUaoepEcQ1US3u6b1js833cFnQzAEDltOb2XsMqVAmM0/1+gtrCeya7VSRWmRsB+BYnb0FI2OK6ITnv00HkvSmuQ7P0lAdw1L0CcDu5b4UFKUfKxECjg8V4TLuOsSiPkP/BpjjJHDqL2DDub+EdGC3W9J/QfnL2fm7Gp9lM5vdy8LRlCPoEwgeoDpSIRjmfHlwY4xs0uX7yREVJ8obNew+U4gESE/GCtOEqlHNYUFvQYl8hyq//N4b637fVUO3grjXCnJYjowDolIakH3ovE9yGzMGaoRkfbOYlwN7+6qTACDzokHDAkHf04+f65rAaJePEVccdQcXD1EA+gCL8J1kD6tBveIrW9p4+Bu2ytfVUSQk7IE3A7cBJsTrCs/kPPFPEFWx7MdHUTG+45jNOZuLc/H6w/+vnigM0Ou0FgZbf2HU6/xUx+ErwbOEX5oQFBr69bt8oQBTSVTPs3eVWr4dxBWMvtoEgDGBxXzsAH10oDPBSCxft0UorMK1xYlHLQfzuc4V/aAn05NNk6bEQvFCkpeupZ2qixfiyH5sjcyluNTcFg7wKhDimxwKYiDSqENOfp2AJ8AVqx4Sfb65OwobrVupBZ3vrGZaam5OvFcnkc0B4QHZxcEcZm4syQShQS2dwzkklRbhiKl+evqADX80uzzWonmZEhF3JbOpkFKucHBlhTARyZotkuYiVpGzLI9b1M9TqSR/ZIZNEfaNoElMriy0pVGb1ctMu9Cgho1q/6XoEBZouWdd1
 Akb3NxW8
 RXBW6oH9sKv4u5tMLbXLnT1b4abd7M9dlkCcK1gWqxdBvId0cbrgjcawwXeRK7y2ahdrsRHl290q7zVcs/ugxD4qnjbqNRdwHNQAqrOdn8pwL/D++Wokd/rXzQgPcANp0Mr+sHOmRvgoKWt4up24WqKLeHepttCppTpMYulss6PhaRKSCKkH7LDcXV+MA3tVm7CTEyAQvwoKpVWiusZyAMltsgK2d98YkigZiqwVFIasbZDtF95RliEBQgF+o/lvzlxFHI6A8OuN4sLY8Lk0COMoslM3+31aE89zyZVtNYmB90RK0IVnF7ouck2oLVEyXWtRHbFz6ZRad9bafXqZvXlNXupQof7qq1Kz7mNDwP3iVXYOwwZCMVXihK1wzOki3yDBMdXSszob4agB5oNpdAi1xktJ0tbj/cQREyglEerrqi3a2HWGJLj/tiNU+bx2bILodB6VTtmEsFHe7dsh2W5hWNUweqd+Y6io6CAzit/TQQAKptd41dDOOUQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Writeback completion and the aging timer access dom->period_time without
a common lock. Concurrent restarts are deliberately allowed, since an
approximate aging deadline is sufficient, but the plain reads and writes
cause KCSAN reports.

Use READ_ONCE() and WRITE_ONCE() for the shared deadline. Keep a local
copy when calculating and scheduling a deadline so that each calculation
uses one snapshot.

Fixes: eb608e3a344b ("block: Convert BDI proportion calculations to flexible proportions")
Signed-off-by: Zhu Jun <zhujun2@cmss.chinamobile.com>
---
 mm/page-writeback.c | 19 ++++++++++++-------
 1 file changed, 12 insertions(+), 7 deletions(-)

diff --git a/mm/page-writeback.c b/mm/page-writeback.c
index 0694ec4098f6..fd75f46f744a 100644
--- a/mm/page-writeback.c
+++ b/mm/page-writeback.c
@@ -550,18 +550,21 @@ static void wb_domain_writeout_add(struct wb_domain *dom,
 				   struct fprop_local_percpu *completions,
 				   unsigned int max_prop_frac, long nr)
 {
+	unsigned long period_time;
+
 	__fprop_add_percpu_max(&dom->completions, completions,
 			       max_prop_frac, nr);
 	/* First event after period switching was turned off? */
-	if (unlikely(!dom->period_time)) {
+	if (unlikely(!READ_ONCE(dom->period_time))) {
 		/*
 		 * We can race with other wb_domain_writeout_add calls here but
 		 * it does not cause any harm since the resulting time when
 		 * timer will fire and what is in writeout_period_time will be
 		 * roughly the same.
 		 */
-		dom->period_time = wp_next_time(jiffies);
-		mod_timer(&dom->period_timer, dom->period_time);
+		period_time = wp_next_time(jiffies);
+		WRITE_ONCE(dom->period_time, period_time);
+		mod_timer(&dom->period_timer, period_time);
 	}
 }
 
@@ -590,19 +593,21 @@ static inline void __wb_writeout_add(struct bdi_writeback *wb, long nr)
 static void writeout_period(struct timer_list *t)
 {
 	struct wb_domain *dom = timer_container_of(dom, t, period_timer);
-	int miss_periods = (jiffies - dom->period_time) /
+	unsigned long period_time = READ_ONCE(dom->period_time);
+	int miss_periods = (jiffies - period_time) /
 						 VM_COMPLETIONS_PERIOD_LEN;
 
 	if (fprop_new_period(&dom->completions, miss_periods + 1)) {
-		dom->period_time = wp_next_time(dom->period_time +
+		period_time = wp_next_time(period_time +
 				miss_periods * VM_COMPLETIONS_PERIOD_LEN);
-		mod_timer(&dom->period_timer, dom->period_time);
+		WRITE_ONCE(dom->period_time, period_time);
+		mod_timer(&dom->period_timer, period_time);
 	} else {
 		/*
 		 * Aging has zeroed all fractions. Stop wasting CPU on period
 		 * updates.
 		 */
-		dom->period_time = 0;
+		WRITE_ONCE(dom->period_time, 0);
 	}
 }
 
-- 
2.51.0




Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 44409C61DBD
	for <linux-mm@archiver.kernel.org>; Thu, 27 Aug 2026 02:55:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3F3BA6B0088; Wed, 26 Aug 2026 22:55:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 37E456B008A; Wed, 26 Aug 2026 22:55:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 248DB6B0096; Wed, 26 Aug 2026 22:55:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id F3EF06B0088
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 22:55:22 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 6096FA3A7C
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 02:55:22 +0000 (UTC)
X-FDA: 85145533284.17.6F716E2
Received: from mta0.migadu.com (out-7.mta0.migadu.com [91.218.175.7])
	by imf28.hostedemail.com (Postfix) with ESMTP id D5968C0008
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 02:55:18 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="YHxc8c/K";
	spf=pass (imf28.hostedemail.com: domain of jiayuan.chen@linux.dev designates 91.218.175.7 as permitted sender) smtp.mailfrom=jiayuan.chen@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787799320;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=hkac0dnaKQb5wpd+29BsnpiuGqW6sgLTt78LF3j61K4=;
	b=5KiqyKMGizBwmHcIOs8fh0Ms+psp1oofQVNVLHBeJxVPN/TIXvOwx2oTDFWXxVFdUfWUzu
	BtXJnhGjCIbux/AdBp4D6WjbZ5XJLT8AiPmjcEfYwtH1W/qDh2+KcEPwGPRbXef7rQbG2o
	g33gd63DS7Rf19iKgVCW8pdUt2HCTDc=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787799320;
	b=oH28IOTgKL1AKRb3GhiHuWVss12DyVO3xbVfkiePfSawkRbOGbboAr86ByIQqr3fozSgn6
	0lsBUi0Hck3BIItSMdo8beW5AUhzdcW4ynT+kxBPqzzfSZQ39PIJS4pSO+MSIJRYmXJqt/
	2PBZvTpZo/zI4evUJRdRn/WICWTqjYY=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="YHxc8c/K";
	spf=pass (imf28.hostedemail.com: domain of jiayuan.chen@linux.dev designates 91.218.175.7 as permitted sender) smtp.mailfrom=jiayuan.chen@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=+WYQTsDYVTtYJtW2ln0YBQa4L8nYSewLmll/nAIQFt8=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1787799315; v=1; x=1788404115;
 b=YHxc8c/K1aRBnoUqGWDsmc0GsN66KPh1fJB3gEkKaJiSA6YzwfSggrevRL/IDTJ2igKJIDdc
 nX+GlABx1SURQMeC/j5Yh5jT3ydmLI3yWUzGFPj6+r+fM7pvipNQlqr8thzgT4PPvwB+VaS+H2v
 2t4SXudkYr8WGovOZ5Srvm9c=
X-Envelope-To: linux-mm@kvack.org
Received: from localhost.localdomain (147.136.157.3)
	by smtp.migadu.com with ESMTPS id 1c0d3bd05cbfb2fd;
	Thu, 27 Aug 2026 02:55:15 +0000
X-Mizu-Trace-ID: 1c0d3bd05cbfb2fd
X-Migadu-Flow: FLOW_OUT
From: Jiayuan Chen <jiayuan.chen@linux.dev>
To: linux-mm@kvack.org
Cc: Jiayuan Chen <jiayuan.chen@linux.dev>,
	stable@vger.kernel.org,
	syzbot+ced4d9a8cadb5ef3adae@syzkaller.appspotmail.com,
	Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	Yosry Ahmed <yosry@kernel.org>,
	Chris Li <chrisl@kernel.org>,
	Jens Axboe <axboe@kernel.dk>,
	Jan Kara <jack@suse.cz>,
	Tejun Heo <tj@kernel.org>,
	cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] mm/memcontrol: fix data-race on reading jiffies_64
Date: Thu, 27 Aug 2026 10:54:56 +0800
Message-ID: <20260827025457.116191-1-jiayuan.chen@linux.dev>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: wgqwkt3bhm5h3uogmjkbepgndsnbkjf1
X-Rspamd-Queue-Id: D5968C0008
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1787799318-435089
X-HE-Meta: U2FsdGVkX19UnrA/J5zO2Anv3l1jbmQZhTs3JGa1HhD0mHl2T/Uzn4t/AmwGk/nXq7R86d29mN09adtKqoqFItc/+VE5f4asdM1Y16bPsbwEIZKxyua0ppteQJSgew7AwxiPmDFvzyDybznfbjSB0WKmyTklccW7/wU3IOFtyKQeVMhuzvvOkzLaLD3boF1/suXHpQkaVkjwcb7S2AfVkx75w5BhZQCer57h6IVWrhanZtR4iG2S3De68Lofj1n45DC+LBNj+LdAC03Kswz8+TGzDKjCWqkPaQTN3gPcEm74G6D3fbU+L8kGH37yj2eDZM0IoYSbxSnQODdmqrQUkxweUyg/Ro2disQKzwndYFfI5cKJXf1l8qPWF2sWuXnUfEO/qJBcB8N1uupGz72PkbYb8CgGQqHwF/s9A39+BtK7tNVETMvKLpW+YHvTBqzyBMxRjM/knaTXroQeqAOAtZ9LS8I2foKmc9cuL8s135AhxNAWqks2lfNliy/8yE67fMLaQPudqf3BotMCyQ0Vi1jrs3yQ4tp3GihymOP3EdmpCgC4k9i5ujlHAcFGuBSgzziu/7mPV5jWrGEc7d5rjX0gl/0nXF+5ahkEwsZY9rw/HZmJ7EIgz3mlLDsjmY//hLtsDTPNG7xj7ltUlzKGNFiKTPO+EQfvKhzWYOyEr+uLtBICeuNDFEU3NY3/9qUiYCOG8B4y98o3cF7v1T+UoTbAJW4npCcxiPqApDU+MG9sEfWErxKvDaDeSyGvdOpzErWhW70h0pm8iB7gvhIltrXhgwn4IZfLvj86H0NKku0DB3JFSBB+erus6GpK9Y18j8HOiWdM/IuzSWqmOumMzoiamvYWiNX45aY1NxKc739oTg4RQd2xCffiR5J+g73tlQGeBWcGiFuyjP3DT/hkPT6uLDEtQL/n8CKpAMe+Y76tQ6ILB1/+4go/nVdO3lbJcB1nxjVg6Miv/1cOngz
 7S1nrAWX
 +r2LsexvJpszuz6B6R/auzcu/uEmjxBrtU9WzvpaP18039ct1gQDOo8MsHu7HEVu13I0tsFp5bMdH8bBxSYn2hk99p1ni91CagNmn6w+a/0dHmJ7y7Tg7/X60aVEQxGWr9Z3MgiCXQdhU6dveSFI8Y7Mj3OXlP396xRfWZFb6p/lVj50GIeST9PSpHVP0RdRTzz6t106KtiayNcaFOn8StSQpz+8bdVp38WZZzyLBRLdIt7Xltpy3CV1fKBtE8oMouriA+jk49aJMQTWIQNZBv5b3F9dR+nUxU11LAbJvszJz+9JDtspxqxfYYp7evSQVZuX/IXFwXZKN0s3gpWcQYJpX39xULbtUCph4qQA4hW61lBBH+y8pZCFUXItfD04hTklqsfvubdpO/6alRztmXiLNuITJ1BSn36GblcO0uNf7j3twOcFw7OMyz767U0qjG/eHPWsY8b7mryQGleHN+U6/dlCEgjQrN0/GkpIk/aj/WRc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

KCSAN reported a data-race between tick_do_update_jiffies64() updating
jiffies_64 and mem_cgroup_flush_stats_ratelimited() reading it directly.

Unlike jiffies, jiffies_64 is not volatile, so raw reads are plain
accesses and can even be torn on 32-bit. Use get_jiffies_64() instead,
and fix the same pattern in mem_cgroup_flush_foreign().

Cc: <stable@vger.kernel.org>
Fixes: 508bed884767 ("mm: memcg: change flush_next_time to flush_last_time")
Fixes: 97b27821b485 ("writeback, memcg: Implement foreign dirty flushing")
Reported-by: syzbot+ced4d9a8cadb5ef3adae@syzkaller.appspotmail.com
Signed-off-by: Jiayuan Chen <jiayuan.chen@linux.dev>
---
feel free to drop Fixes tag.
---
 mm/memcontrol.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 11b85f4b6828..5a3fe057debc 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -757,7 +757,7 @@ static void __mem_cgroup_flush_stats(struct mem_cgroup *memcg, bool force)
 		return;
 
 	if (mem_cgroup_is_root(memcg))
-		WRITE_ONCE(flush_last_time, jiffies_64);
+		WRITE_ONCE(flush_last_time, get_jiffies_64());
 
 	css_rstat_flush(&memcg->css);
 }
@@ -785,7 +785,7 @@ void mem_cgroup_flush_stats(struct mem_cgroup *memcg)
 void mem_cgroup_flush_stats_ratelimited(struct mem_cgroup *memcg)
 {
 	/* Only flush if the periodic flusher is one full cycle late */
-	if (time_after64(jiffies_64, READ_ONCE(flush_last_time) + 2*FLUSH_TIME))
+	if (time_after64(get_jiffies_64(), READ_ONCE(flush_last_time) + 2 * FLUSH_TIME))
 		mem_cgroup_flush_stats(memcg);
 }
 
@@ -3945,7 +3945,7 @@ void mem_cgroup_flush_foreign(struct bdi_writeback *wb)
 {
 	struct mem_cgroup *memcg = mem_cgroup_from_css(wb->memcg_css);
 	unsigned long intv = msecs_to_jiffies(dirty_expire_interval * 10);
-	u64 now = jiffies_64;
+	u64 now = get_jiffies_64();
 	int i;
 
 	for (i = 0; i < MEMCG_CGWB_FRN_CNT; i++) {
-- 
2.43.0



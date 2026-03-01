Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A8507FD0049
	for <linux-mm@archiver.kernel.org>; Sun,  1 Mar 2026 02:02:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 21B356B0005; Sat, 28 Feb 2026 21:02:23 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1BF286B008C; Sat, 28 Feb 2026 21:02:23 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0C7FC6B0092; Sat, 28 Feb 2026 21:02:23 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id ED1B76B0005
	for <linux-mm@kvack.org>; Sat, 28 Feb 2026 21:02:22 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id A81FD160423
	for <linux-mm@kvack.org>; Sun,  1 Mar 2026 02:02:22 +0000 (UTC)
X-FDA: 84495844524.11.02F6240
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf21.hostedemail.com (Postfix) with ESMTP id DDBA61C0005
	for <linux-mm@kvack.org>; Sun,  1 Mar 2026 02:02:20 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ONGB+0ur;
	spf=pass (imf21.hostedemail.com: domain of sashal@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashal@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772330541;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=6GlmIRh/nesDVqKuzZ/3yvbmeG9BHHNFtlgcVquEI3s=;
	b=74r0CjusavNWf//RfdIugN9/iCOMWXRLE7/04dOZxDgMG2BChV5LvvsdthRFyqt/valaMC
	GXUtUsJY5+8iyhp7X1voGU+fDcj2jsRItO2Q87OohY7eWMqsJNT5iWhsARq5kWXH+L2yzm
	pYfESsE961UJH1NFDDCkJigifOat9hI=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ONGB+0ur;
	spf=pass (imf21.hostedemail.com: domain of sashal@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashal@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772330541; a=rsa-sha256;
	cv=none;
	b=34XHgNh507kZ3qo33+xn96+BI5irm/nz+MaeiU5FJG3VuvSpzQ1/SadCtI6FX81V1A80Y1
	10UXrzMQjMzmaOf2DT91wqlVHi+3FLuJBOkiQXNsQYrxph1EhPncGIsnV7y9M+dmNThGZd
	FDjcxT2fH2N0//yoA7Ztuti3W4Xdofs=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 1DE3042A6C;
	Sun,  1 Mar 2026 02:02:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C272C19421;
	Sun,  1 Mar 2026 02:02:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772330540;
	bh=gyHLIme4Zxxpm9s3ApVCT8pZuMPYNNMzWWnduqNLjSg=;
	h=From:To:Cc:Subject:Date:From;
	b=ONGB+0urNt5RSoHxWAVIAioKLDoHkxoHuSNl65BdVpwLg9EKX8mpd0AfDdf4FAQ70
	 rjkTqs0MKxS9XZxsKH13ZwzcndAGHX+v5OcSwIzsn8HDAqtNbm3/A4lkSCqf5PSA29
	 ZsOmTHV9C7xKPt9KR9ex129zvhUylQ2u0z9p23DSfD2iQ2YxKNW0lkY23kG5bj4BJi
	 7/bz9oL/cETAS5puhfManTNyxGBuJS6z2ZYKPjXLvelXBjs1PKjiLC6Rs6d46xW76q
	 pZ09Eihvn9jOoilaZan2f+NTDSrKgCtesSGqXZ19vz5bU+J827v9s3w6RJ2IScS49s
	 DBSsbQKTuGsbA==
From: Sasha Levin <sashal@kernel.org>
To: stable@vger.kernel.org,
	kartikey406@gmail.com
Cc: syzbot+d8d4c31d40f868eaea30@syzkaller.appspotmail.com,
	Uladzislau Rezki <urezki@gmail.com>,
	Hillf Danton <hdanton@sina.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-mm@kvack.org
Subject: FAILED: Patch "mm/vmalloc: prevent RCU stalls in kasan_release_vmalloc_node" failed to apply to 5.10-stable tree
Date: Sat, 28 Feb 2026 21:02:17 -0500
Message-ID: <20260301020218.1729955-1-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
MIME-Version: 1.0
X-Patchwork-Hint: ignore
X-stable: review
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: DDBA61C0005
X-Stat-Signature: g14dfcnjobtr4kzhueijchwjsa89aq1a
X-Rspam-User: 
X-HE-Tag: 1772330540-350856
X-HE-Meta: U2FsdGVkX19mjSuG15cshvHuvuHSsgvZ2WcWDcsIthNNCPjjOG4sA4QFH2joagz5z7SQ9hssNUaQBM7EPtIKRAjL8gT48uiLY9nenk6mu7xVDbJpMBsogzUAmPX9PSyNIOeOr31VFJV2rEJUcg3DxRG/CvFpQjvsFKYJAfjuTr7iQ+MOTLAYd0FqW0WWo/8nxSOFgzo7mJ3upnosfITwCBvdHRw8mhEhsI4WI/KrsDsIiwKCYysp4dwSgtYF5RmqAAKPum3bR5VBywUVoCKFPe6bE2jB9dMQqbhDS1QfD1wROrU4bPRbXdUruv+p21OGl5dvtmllTn+5swEiqcermeT1ohLzwuLfSnQ1t9aqKBZpdyB+YWYNln8kf1fH7Km1AHEBrDFUY8XX8ykEW6MtqyjfawcThlbdbLFzBGVLIj69UpjybICNnf8Bz/FPuFExB3Eo11npQrXHMdel5c7VktIYO6u5J9Gut0db2xjhRtC3ZCmGT9ekw4W3F9iHC8EImWsKel4M18L67Ck8gGuyBOEOPVC9uL+r8LmKCIowQ9lP5TgWCNspOmbsUmEXEkhBZUOO+DoEBXo2XURvNc5XDROJA4CKhaeRlYJCFFSIRwDDPVAC1aIcNLAbseymS0iiKnC4KVEpU77mYs1jUoXI38Ks/RH+rOBn3u4av+t2D25WbJDWS0OPv4uv6LHNKsB8W142/Bva1d6RX+6qP+Xa7yv2DTvhwOHKsJogMEkR3HCLLLW7c2IcQm5a9uy09UkGRZbewznQLMuFV80NWg76E5DrNIy9G5jRrLkiPJubn/wlXtZ8GdpoPm7jZurz+u7/SDSCZJwlaJxBb/nR3x/n2HbR/sGSgIyXBY0hxNw95nNum0x5Jasx/rzbigywjz1NnmNODOo3OCBGQojHKve51NFogLMwbRKII3kW1AG1RWehnrC+aTM/cE2eXiVgE7qTHcVGLzCGF9lfHCL2H0b
 lEti3zo1
 IkEb4fgnaNwmSutzhh9dc3gsPkCEybMKUy9dGmBjP6WZOLS5DPOmpbRlSZiUsI9ogobzbWqUtXLoZNdYVN1XxAiEtpct5O57oyN4WEYjc9tWx1fP2qTkysWDOhdqsFGg6O26Ioj5v25uO56Xjhue+b1iT3Nk90UTX2pRwmaTplZ9CnwFgL0+5GJ3sgTenDIveCE5MqkO/5ltGWizpDa7U07VMngfbQo2J5/M7QkY6HkepeZEqdEJ80nzaoDlS+dgwlGzXiBn1coVXVnqEUmkRSrBWrp+s0RVhA2n0J08ZA1dkgdnyCsLz3la5J3OSzrNOD9uZiQDkm4qozoyBw/86Pm4EVaiCsL71MAmh667hWMsi0stCN7UVgvwi1SpQsRYNXBD8lwiu6SC2tx54wOTxELNrBpqTBASuFYYi3qjdUOlk0nPZdEtVCI+gXydQF+BgUBs+Zf+x11UuHLx5Ro2cF0m9+y/lWHOzsRhQfRKxmeaxFW7LpWgkyjvdU/BG7ubWtrVlxHnlWO5/XecWorsVDAKSX/aygaQm6u8XVKqvztfGOfjQiubNPhi/UAZ9AcpqaC7Knfb+IIJjOuf6pc/yken4tQuGHh6q5t+YFeSBo152tt9U2tzpVPvy/VE1Q75IWuHC+iE0prNwLqE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The patch below does not apply to the 5.10-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

Thanks,
Sasha

------------------ original commit in Linus's tree ------------------

From 5747435e0fd474c24530ef1a6822f47e7d264b27 Mon Sep 17 00:00:00 2001
From: Deepanshu Kartikey <kartikey406@gmail.com>
Date: Mon, 12 Jan 2026 16:06:12 +0530
Subject: [PATCH] mm/vmalloc: prevent RCU stalls in kasan_release_vmalloc_node

When CONFIG_PAGE_OWNER is enabled, freeing KASAN shadow pages during
vmalloc cleanup triggers expensive stack unwinding that acquires RCU read
locks.  Processing a large purge_list without rescheduling can cause the
task to hold CPU for extended periods (10+ seconds), leading to RCU stalls
and potential OOM conditions.

The issue manifests in purge_vmap_node() -> kasan_release_vmalloc_node()
where iterating through hundreds or thousands of vmap_area entries and
freeing their associated shadow pages causes:

  rcu: INFO: rcu_preempt detected stalls on CPUs/tasks:
  rcu: Tasks blocked on level-0 rcu_node (CPUs 0-1): P6229/1:b..l
  ...
  task:kworker/0:17 state:R running task stack:28840 pid:6229
  ...
  kasan_release_vmalloc_node+0x1ba/0xad0 mm/vmalloc.c:2299
  purge_vmap_node+0x1ba/0xad0 mm/vmalloc.c:2299

Each call to kasan_release_vmalloc() can free many pages, and with
page_owner tracking, each free triggers save_stack() which performs stack
unwinding under RCU read lock.  Without yielding, this creates an
unbounded RCU critical section.

Add periodic cond_resched() calls within the loop to allow:
- RCU grace periods to complete
- Other tasks to run
- Scheduler to preempt when needed

The fix uses need_resched() for immediate response under load, with a
batch count of 32 as a guaranteed upper bound to prevent worst-case stalls
even under light load.

Link: https://lkml.kernel.org/r/20260112103612.627247-1-kartikey406@gmail.com
Signed-off-by: Deepanshu Kartikey <kartikey406@gmail.com>
Reported-by: syzbot+d8d4c31d40f868eaea30@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=d8d4c31d40f868eaea30
Link: https://lore.kernel.org/all/20260112084723.622910-1-kartikey406@gmail.com/T/ [v1]
Suggested-by: Uladzislau Rezki <urezki@gmail.com>
Reviewed-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
Cc: Hillf Danton <hdanton@sina.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---
 mm/vmalloc.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index 32d6ee92d4ff8..ca4c653286870 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -2273,11 +2273,14 @@ decay_va_pool_node(struct vmap_node *vn, bool full_decay)
 	reclaim_list_global(&decay_list);
 }
 
+#define KASAN_RELEASE_BATCH_SIZE 32
+
 static void
 kasan_release_vmalloc_node(struct vmap_node *vn)
 {
 	struct vmap_area *va;
 	unsigned long start, end;
+	unsigned int batch_count = 0;
 
 	start = list_first_entry(&vn->purge_list, struct vmap_area, list)->va_start;
 	end = list_last_entry(&vn->purge_list, struct vmap_area, list)->va_end;
@@ -2287,6 +2290,11 @@ kasan_release_vmalloc_node(struct vmap_node *vn)
 			kasan_release_vmalloc(va->va_start, va->va_end,
 				va->va_start, va->va_end,
 				KASAN_VMALLOC_PAGE_RANGE);
+
+		if (need_resched() || (++batch_count >= KASAN_RELEASE_BATCH_SIZE)) {
+			cond_resched();
+			batch_count = 0;
+		}
 	}
 
 	kasan_release_vmalloc(start, end, start, end, KASAN_VMALLOC_TLB_FLUSH);
-- 
2.51.0






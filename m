Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C15AACA5FA1
	for <linux-mm@archiver.kernel.org>; Tue, 29 Sep 2026 01:40:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 997CA6B008A; Mon, 28 Sep 2026 21:40:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 948136B0088; Mon, 28 Sep 2026 21:40:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 79ACA6B0093; Mon, 28 Sep 2026 21:40:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5670B6B0088
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 21:40:53 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id D51D2A6847
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 01:40:52 +0000 (UTC)
X-FDA: 85265095944.02.ED50950
Received: from o1.ptr9745.em.honeycomb.io (o1.ptr9745.em.honeycomb.io [149.72.141.136])
	by imf07.hostedemail.com (Postfix) with ESMTP id D862E40002
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 01:40:50 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=honeycomb.io header.s=s1 header.b=V2CqsPVf;
	spf=pass (imf07.hostedemail.com: domain of "bounces+3311449-c6d3-linux-mm=kvack.org@em.honeycomb.io" designates 149.72.141.136 as permitted sender) smtp.mailfrom="bounces+3311449-c6d3-linux-mm=kvack.org@em.honeycomb.io";
	dmarc=pass (policy=quarantine) header.from=honeycomb.io
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790646051;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dwOFY0qA5zD55AfPP2BhFlWQOukNC8X93CuuDPIXWvE=;
	b=Q7GsE7Ym/clOCmZCYjJXg0pe3t+i6n81KquQuyZfuBSlYFIEWAdJJyjxZKJSxYE5S2LWyj
	l8hE/T7dyHBkQWmE8Jk3pa8gCffNKrLRQM9fiAiNZ6X8XRDBWm+d49WlfRz8EORU+5nUIL
	q7WsCYdtFarX8GViBBQMyoD54n95pXM=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=honeycomb.io header.s=s1 header.b=V2CqsPVf;
	spf=pass (imf07.hostedemail.com: domain of "bounces+3311449-c6d3-linux-mm=kvack.org@em.honeycomb.io" designates 149.72.141.136 as permitted sender) smtp.mailfrom="bounces+3311449-c6d3-linux-mm=kvack.org@em.honeycomb.io";
	dmarc=pass (policy=quarantine) header.from=honeycomb.io
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790646051;
	b=PnTsDEGRCuyihCGIiZwT2RKb722CjhHCz8Rj70XPDz8f/pExQVC0Bm1C7FrkIUFsnCZY2D
	8Zgu2C1JRelFFCq7lMqYLYjrsHJvJcvp9u3QpXhoieKmw0dI3IIevBa8Nd15hKBv5zp2Yq
	7U8HoJSEKBQmPtxugT6bNeLvqZ/2DmU=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=honeycomb.io;
	h=from:date:subject:mime-version:content-type:content-transfer-encoding:
	references:in-reply-to:to:cc:cc:content-type:date:from:subject:to;
	s=s1; t=1790646050;
	bh=dwOFY0qA5zD55AfPP2BhFlWQOukNC8X93CuuDPIXWvE=;
	b=V2CqsPVfJBbfRYyinyh+FJtmr4QhKgpU2YPj/cC4TizZjrjTHayiXpxG7fzxZydRa9Cn
	Xb3qkfdpGKgjJ7V3FJCkHbOT3kj/5EPEIfxIuxmoMd1CWsFNB1Xpu6D4Gp/lQSvkMsYjhN
	Ce3xAxmvJ7Biw4OpnWWr9f4uzsv3TFDqVcAoVADia8UHTS8X5cUxZW1fm1U/Mflx5pvJBj
	l7633gj8MLp2DixCMz6y4KYDD4MUSfUSGUNwn6upzYIJaBrIEa4D/w00pc/Jx8haBD8dpl
	O0oSeHt8yNuU7EN4p5INirNZmtPK0CQqiRL7HDW7aUKwwui+BYmh0zq6tLGEzcRg==
Received: by recvd-b456b577c-x5bcp with SMTP id recvd-b456b577c-x5bcp-1-6ABB1722-1
	2026-09-29 01:40:50.01666974 +0000 UTC m=+366934.602086333
Received: from [127.0.1.1] (unknown)
	by geopod-ismtpd-10 (SG) with ESMTP
	id AT0MDOB4SIWqYp-aCCxf3Q
	Tue, 29 Sep 2026 01:40:49.967 +0000 (UTC)
From: Liz Fong-Jones <lizf@honeycomb.io>
Date: Tue, 29 Sep 2026 01:40:50 +0000 (UTC)
Subject: [PATCH v3 2/2] writeback: kick writeback on a cgwb replaced in
 cgwb_create()
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20260928-wb-dying-cgwb-flush-v3-2-e35374884667@honeycomb.io>
References: <20260928-wb-dying-cgwb-flush-v3-0-e35374884667@honeycomb.io>
In-Reply-To: <20260928-wb-dying-cgwb-flush-v3-0-e35374884667@honeycomb.io>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=3680; i=lizf@honeycomb.io;
 s=gpg; h=from:subject:message-id;
 bh=k3FhHbwW2RXNLjd8N+JMVRKns6C9cTKRbg4ZWValOHo=;
 b=owGbwMvMwMW49NyVx9PXrj/EeFotiSFrt7ji5N3up2wZ3h65byH0uy35g2R5qw8Tz4rMlXNPx
 fkblkpP7WQ0ZmFg5GKQFVNkmR8ddN7Zw0gtS1ieHWYQKxPIFAYuTgGYCM8z9v9uC65uWaFRk6zh
 ctGgONdxk8AVa42LRndfvv9ncPDGSZnWRjG2/uyNlWaXJY+4FS8Ilw3a3KdrdU/reDnD1dIG6cC
 O+udhPE2fHjw/nnHhW5FZVZZvafpt/ZMVsWbqfb6aDRb+p7+f/Vv42tKAxd5btkF2ycuXDC8ybs
 aYB599l+19iln74tWXq6OE4luXe+2anKI/pa1ccXns4vRFdry32lZPkNeQNn/DdyLj1rTG+Zwfq
 8I6XZ9UBbW4dXrfjrt444NgbcUDbjMu/5ZggdSs9cf/MQoZPXi5VLZeR+z3f5utU5R3N//d07wo
 rFfSrqZ26iqhsDY5xqY3RzSyCswED79OvK7ppf5/wy8VAA==
X-Developer-Key: i=lizf@honeycomb.io; a=openpgp;
 fpr=1F7714D7EC3441D2CECC24606A3F8B00FBDDD2A4
X-SG-EID: 
 =?us-ascii?Q?u001=2ECuH7N2XAoeMR1zrzr=2F6NZrhli2vbKPOHff5fJuZuba6ZIE8QPyIf9mn4Y?=
 =?us-ascii?Q?ezqeFFjUkh=2FeROy4LtnO7KN9jZmeQxdL6xrv8qB?=
 =?us-ascii?Q?WzapFsCTIloi2i4Yganbi21=2Flv2BnuBPW4JAD40?=
 =?us-ascii?Q?hFkLgjm1aulnZiC=2FiiZGyYNl2gW7Y77U9KukO1+?=
 =?us-ascii?Q?zWx1I8KsMxq0l7pgvNeTTW2hMi+7AhtkWqN+A19?=
 =?us-ascii?Q?+2cVsVJ2qgPyEX2CDpRR14=3D?=
To: Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, Tejun Heo
	<tj@kernel.org>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, Jens Axboe <axboe@kernel.dk>,
	Andrew Morton <akpm@linux-foundation.org>, Johannes Weiner
	<hannes@cmpxchg.org>, Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt
	<shakeel.butt@linux.dev>, Xin Yin <yinxin.x@bytedance.com>,
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org, ian@honeycomb.io, Liz Fong-Jones
	<lizf@honeycomb.io>
X-Entity-ID: u001.GRlkmHQ+Ka/CKxmoC/CxTw==
X-Stat-Signature: btes3nm5w1xefs6i1kt3udtir5p9ghtn
X-Rspamd-Queue-Id: D862E40002
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1790646050-328375
X-HE-Meta: U2FsdGVkX18C5W8SHOnIdX0uKl/UDZZjUM0TqVB5kg877piAbqROuX1VeanbsOzcie2s7qHkcZDgc1eDnzul5Xpg9z49Bdll+bjpHGFvrf0jLtUbGl+ANByu98GiGQ0B6G3irBhitoBcoJnE35hAY7iu1nb7yihAW9gEzL3bS5QCJAwJLCkJr6JfM9s4nLRpzlBUCu29MQYBBlSYzg5jSHBwi+5DPaflj32alwK8sp9KSsnj8eX3JBP/PzZcz3hBRWab/S4GuKmY3It5SoY7nlYqnwKJzkkjawPpkjkaMeI50X1cFPDo1jhKzLfDfkyVxNLKTYWNFIt+wrWb2s8j0PO/3QlzKwRraLlBEP/zpNRmThXd98IKAANsWv0zQ2Rwx10fyQUEBdd0NcVTXkGFWvafdjOUTgJJU7Hv4mt8X8+OSBN3Eh0bLYbPxVszFebCIPibcmToitXwRBbex6urwL7cpcdqaopWIvHL4FPDggmcyIV2XGdelgcUmSv+bmwk0PxV1GRpy1DSzTRqnc1dpC5Remn0B7z+fx9diFCs0q4XmPRowpk/UhoXbu3VltvXQqbmevcaZUZBYg8Wx2Cq6Nmnlh8aZ8BrgyAFHZBnlrinvQi/EBsUtHD4/S35wP4TAD1PKS+LY4/CrX52D5PfUxXzFt/SNg3vKsmjs4Xkpqh6khlZ6XySFBDaPwISYvhUD9oAntlLp5uwHl0nPc0SYhlW8RrY6Wo07c4WG6v0YxDS5PY3VbKVvqBa3nfmktjM4MXwzbXtDmPZ480yvYD+L9Wth/eJ+31pOvgGZuLhlkyoOTh4Q01Zbw88ojhBQYbloJHaShyK9/VFkIXaPSMdBzv7Mblpwc3VRaa8g4611i+kBqOM4kvCggJvOjQkrl44HMpyoom5/Qx4x+1fFFkjtrolagJ8q1Dqn2QFi1SJs54EINBZQ5A4syyyRAsckKbuDwSu/QdeZCajFEs7tjN
 rEZ1rQui
 mHoz/oZo9ln5vUH9oU+YENGptWtLikGrI+KymA5B+ph3MdK8GbiXoQHv+u3x5cG8ndk2I4rO72P5M3feW/Ha9pvwXh2Do5Tj4EMxppgDZOdlbwl/bS1h/a4rMIZy2cS567EXnV3vFcTuOISoVrgovTcSDaoxZoiRuubsz2hB3s3sS41YaFkRHc1ron8bzCqvGT9wm7kxB0MHqymk16eigZxmvPKeuJ6YAYTEhgEU4YT39nKBEDJMKw3v/noSFtAqo6qSCjvHDh4J3629H18UU9JujB4QL/bQEXGTqrOySZf677PPn8VIBoKy6+rWXT+doO38IrFRohX5KE7l+398hkmvAwFsrPOG2LCKwK6FKqgJ5E5jn4Ei6zmiLTrToKoUGDd5t683L5ptI2sHUW5kOEkCK31hxjLIWe208a8TjEhK1kLrQAvswN04cnWjHqr1lPhd+HevjV4tanOvg3MIKUoCp7mVe43AEr5z1/z/hbgZpR0Wp4uYKgtjgHam6PZ1djIgT7V4Ns7BFS8YfQpn0hUtGoVc+e5Bn71wPeQnqOCrlHVJ5aQGYC54Zhrp33R1yoeZfkQaXolnT5e4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When a live memcg's blkcg association changes, cgwb_create() replaces
its killed wb in bdi->cgwb_tree. The old wb is then out of foreign
flushes' reach, but its inodes can still be dirty, and they only move to
the new wb as they are written back (see wbc_attach_and_unlock_inode()),
which may not start for a while.

Start writeback on the replaced wb after the takeover. cgwb_create()
can run with interrupts disabled (folio_account_dirtied() ->
inode_attach_wb()), so do it after dropping cgwb_lock, and make
wb_wakeup() irq-safe.

Suggested-by: Tejun Heo <tj@kernel.org>
Assisted-by: Claude:claude-opus-5-5 checkpatch sparse
Assisted-by: Claude:claude-fable-5-1
Signed-off-by: Liz Fong-Jones <lizf@honeycomb.io>
---
 fs/fs-writeback.c           |  8 +++++---
 include/linux/backing-dev.h |  1 +
 mm/backing-dev.c            | 15 ++++++++++++++-
 3 files changed, 20 insertions(+), 4 deletions(-)

diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
index d26b2cf05283..b9d69ec0649c 100644
--- a/fs/fs-writeback.c
+++ b/fs/fs-writeback.c
@@ -131,10 +131,12 @@ static bool inode_io_list_move_locked(struct inode *inode,
 
 static void wb_wakeup(struct bdi_writeback *wb)
 {
-	spin_lock_irq(&wb->work_lock);
+	unsigned long flags;
+
+	spin_lock_irqsave(&wb->work_lock, flags);
 	if (test_bit(WB_registered, &wb->state))
 		mod_delayed_work(bdi_wq, &wb->dwork, 0);
-	spin_unlock_irq(&wb->work_lock);
+	spin_unlock_irqrestore(&wb->work_lock, flags);
 }
 
 /*
@@ -1334,7 +1336,7 @@ static unsigned long get_nr_dirty_pages(void)
 		get_nr_dirty_inodes();
 }
 
-static void wb_start_writeback(struct bdi_writeback *wb, enum wb_reason reason)
+void wb_start_writeback(struct bdi_writeback *wb, enum wb_reason reason)
 {
 	if (!wb_has_dirty_io(wb))
 		return;
diff --git a/include/linux/backing-dev.h b/include/linux/backing-dev.h
index f7ef5895625a..7d5e2896711e 100644
--- a/include/linux/backing-dev.h
+++ b/include/linux/backing-dev.h
@@ -37,6 +37,7 @@ void bdi_unregister(struct backing_dev_info *bdi);
 struct backing_dev_info *bdi_alloc(int node_id);
 
 void wb_start_background_writeback(struct bdi_writeback *wb);
+void wb_start_writeback(struct bdi_writeback *wb, enum wb_reason reason);
 void wb_workfn(struct work_struct *work);
 
 void wb_wait_for_completion(struct wb_completion *done);
diff --git a/mm/backing-dev.c b/mm/backing-dev.c
index 839a3c476c5b..0b09c66eafc6 100644
--- a/mm/backing-dev.c
+++ b/mm/backing-dev.c
@@ -676,7 +676,7 @@ static int cgwb_create(struct backing_dev_info *bdi,
 	struct mem_cgroup *memcg;
 	struct cgroup_subsys_state *blkcg_css;
 	struct list_head *memcg_cgwb_list, *blkcg_cgwb_list;
-	struct bdi_writeback *wb, *old_wb;
+	struct bdi_writeback *wb, *old_wb, *kick_wb = NULL;
 	void __rcu **slot;
 	unsigned long flags;
 	int ret = 0;
@@ -748,6 +748,8 @@ static int cgwb_create(struct backing_dev_info *bdi,
 			old_wb = radix_tree_deref_slot_protected(slot, &cgwb_lock);
 			if (wb_dying(old_wb)) {
 				radix_tree_replace_slot(&bdi->cgwb_tree, slot, wb);
+				if (wb_tryget(old_wb))
+					kick_wb = old_wb;
 				ret = 0;
 			} else {
 				ret = -EEXIST;
@@ -763,6 +765,17 @@ static int cgwb_create(struct backing_dev_info *bdi,
 		}
 	}
 	spin_unlock_irqrestore(&cgwb_lock, flags);
+
+	/*
+	 * The replaced wb is out of foreign flushes' reach but may still have
+	 * dirty inodes.  Write it back so that they move over to @wb, see
+	 * wbc_attach_and_unlock_inode().
+	 */
+	if (kick_wb) {
+		wb_start_writeback(kick_wb, WB_REASON_FOREIGN_FLUSH);
+		wb_put(kick_wb);
+	}
+
 	if (ret) {
 		if (ret == -EEXIST)
 			ret = 0;

-- 
2.53.0



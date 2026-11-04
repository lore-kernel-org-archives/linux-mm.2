Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EA89E606A32E
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 13:01:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Kj8h01YM
Received: by kanga.kvack.org (Postfix)
	id 074EB6B05B2; Wed,  4 Nov 2026 08:01:47 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 046DD6B05B4; Wed,  4 Nov 2026 08:01:46 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E736C6B05B2; Wed,  4 Nov 2026 08:01:46 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id B7FA26B05B2
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 08:01:46 -0500 (EST)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id EF4071206A2
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 13:01:45 +0000 (UTC)
X-FDA: 85397448570.18.5680985
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf28.hostedemail.com (Postfix) with ESMTP id B3F99C000A
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 13:01:43 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Kj8h01YM;
	spf=pass (imf28.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793797303;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=O/dxa82xWVm6PMFOoBLZfnKEj8mtykd0dOrhKJ+ZGuY=;
	b=MnBgelvo2hEVKPE2SF0d5//DCfVt9R0MV2B500yWdjjGQ3QX8nkowCUqAZ9Btj+O0Bej34
	LTDHfJwm+hKOUZA29FoaZQB5AizlDj1yiOHyVa3LKFuxuH9GSalm3v70nqBCPw5V1GZtw6
	P9Hga3X3s6JOwRNhZQuQYi/E5URVR8o=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793797303;
	b=Qip9lfaHxG2oetGaWePllINFLEaPNTxJsAgOyUgt0wtZpm6rV+bfPMiR9IZT7Tl6hacGM3
	Yx4KuJ4U2H4Po2dXgzaLzwnPMq7DVAkh5i6WGBhouA6ap6dv1N5IRZlODUTWgOOQXsY9gg
	X6YxtY0iehRpkitkVlf+4kAfwiU/DWg=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Kj8h01YM;
	spf=pass (imf28.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 02A8E41130;
	Wed,  4 Nov 2026 13:01:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49C3C1F00A1E;
	Wed,  4 Nov 2026 13:01:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793797302;
	bh=O/dxa82xWVm6PMFOoBLZfnKEj8mtykd0dOrhKJ+ZGuY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Kj8h01YMHVT7XPUbl54W9a+Cf9NnC3mkXY1i//tL2xAMm2zD9aatg4HZPm7QkL/Qn
	 lWfQpSSIBvn9+NIKtoOTzp+foBpgBYSDmroA9sDxSjRNAk2M5KfsQFXE3zuEvASHKi
	 D6BRxfUo7stWTmzfraDVHwhBzU8r6qP5m+HbdBIUl2krZTPJzmOHQrEeAU8c7aSTjy
	 wKa3HovZ3hGG2NUZYbpoK+NQHAqDJtv3/V2UK1drkUlYXgENsxd5qGIFo1sP6+HzTx
	 9WVE8EqWp9aCpe0rUUm9ywKJkTjjxZT8CthiNA52/YxZwDh6+cVvok28CYKjV6zGlQ
	 IrIKF86VeIVAA==
Received: from phl-compute-10.internal (phl-compute-10.internal [10.202.2.50])
	by mailfauth.ams.internal (Postfix) with ESMTP id 18C311980052;
	Wed,  4 Nov 2026 08:01:35 -0500 (EST)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-10.internal (MEProxy); Wed, 04 Nov 2026 08:01:38 -0500
X-ME-Sender: <xms:rizramMhR3FwPI5-KuM6iDPnV3bRBUy9QeXTrkejJ4rRMuylCN58TQ>
    <xme:rizrar542OiBnGHAuFkdWIy8e2x7ol8kQCXnQx6wC2HaQ4DRLq4PQ8gJ06zgTsl-U
    _Ma_SIThk_Qxy2JzqsisrJZk5r99Js9PW844Dw6hrFURAc3ednGEsRn>
X-ME-Received: <xmr:rizraiY5lXWqOx8hhKxWSZ8JoEgRQ0MeeiV9MDKJXzghgWmQ1Jv_UTF9X2o>
X-ME-Proxy-Cause: dmFkZTGcnWxWNdwzviArTqwO8SleswujEAoF3G5cAnzgWuj9VIXYzVn8L/YtSSoCVpDQCx
    AFAjkaMBKJDECegKseyQPi3BoJ2ULdzgEWHQh0kOOdV3qcZ96T5qYw8zvnYBduU6y+7gOl
    ju1hRqdfaUd029Zpq0M1QKVfvNYpVJXA03mIXM/FVYF2n1TVZdGxcwDBil6kVRafbiJtv0
    QuPNDwYksKVrYzT4QGS7HIxmz8ayVgiPQk5G9zoQji1nSBMTr/zV+0QH6w0a9BT4L54N+d
    cRhB7KhKgiZgmWNJc1G8l9d+gvjQ75B75nEIsy2loqzEXGvtqjUcmfJ5UhZu2fDzNX4RXN
    Sos3iNNV9RQQ+6u4LQiUkpyMrihOoJ01WcTinUsG//G0WyVORGzl/J6YD9u3h+RbNhtPuK
    Fo53IOAMnXTw1Ofxe3I1lptXm4IL/KoDyapzPRkcOl6t9VEJnbx5PTZeXVFOelGmkmiMm9
    fdmKcVmV56TLAB4Vg7nKut/7z2cVFZF/tju/fjr23Njo7juq6GrcVzYUN5TcCWyd4E9zdi
    ZodfXYJg+CHnrHsD4BiEIUjvFnzurjL5k2LpqmWZNqI4QLawAlZOCj1IdOgA9oEt3zaM+h
    w2nWvBmvJsCpEGgu9fY+X7D0puSrcuRoICY+NZKENxCkPLVE2qppRUjbaBaQ
X-ME-Proxy: <xmx:rizrarEHAnpecQdYd6l_ChFGjfCsimVZBZes41VJIZ8nNTxERFIaZA>
    <xmx:rizrauJeS6DfQBn8GD_dijDgSBwrCvzCjm5f2GiHKIZWoCbMD1g8hQ>
    <xmx:rizraiesLrPteMRJHMkuAiPhBBXW0IZGSitpI51cZeyT9uWyCSG0RA>
    <xmx:rizrajacWYJ_3Pmq9yzbtS5qTw-3CspOaj5U9zZ0baQq1kf0hNYK9g>
    <xmx:rizran79poDBkQLiKB8Fk-xAqyX6OLWB3p-ubGRjRyYnUTLmi9-6cZbv>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 4 Nov 2026 08:01:33 -0500 (EST)
From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Matthew Wilcox <willy@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Jan Kara <jack@suse.cz>,
	Hugh Dickins <hughd@google.com>,
	Christian Brauner <brauner@kernel.org>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Harry Yoo <harry@kernel.org>
Cc: Miklos Szeredi <miklos@szeredi.hu>,
	Miaohe Lin <linmiaohe@huawei.com>,
	Naoya Horiguchi <nao.horiguchi@gmail.com>,
	Oscar Salvador <osalvador@suse.de>,
	"Liam R. Howlett" <liam@infradead.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Brendan Jackman <brendan.jackman@linux.dev>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Nico Pache <nico.pache@linux.dev>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>,
	Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>,
	Usama Arif <usama.arif@linux.dev>,
	Kairui Song <kasong@tencent.com>,
	Qi Zheng <qi.zheng@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>,
	Wei Xu <weixugc@google.com>,
	Baoquan He <baoquan.he@linux.dev>,
	"Paul E. McKenney" <paulmck@kernel.org>,
	Pedro Falcato <pfalcato@suse.de>,
	Luis Chamberlain <mcgrof@kernel.org>,
	Ilya Gladyshev <ilya.gladyshev@linux.dev>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	fuse-devel@lists.linux.dev,
	kernel-team@meta.com,
	"Kiryl Shutsemau (Meta)" <kas@kernel.org>
Subject: [RFC PATCH v2 02/18] splice: don't steal page cache folios
Date: Wed,  4 Nov 2026 13:00:58 +0000
Message-ID: <20261104130118.2507513-3-kas@kernel.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20261104130118.2507513-1-kas@kernel.org>
References: <20261104130118.2507513-1-kas@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam09
X-Stat-Signature: ssskd6amqif8cr9ceoaf5inif3gwq8fz
X-Rspamd-Queue-Id: B3F99C000A
X-Rspam-User: 
X-HE-Tag: 1793797303-763979
X-HE-Meta: U2FsdGVkX19hLnP1EvIl/H+JX+VU3D7AWFHYQi9eaPajmBYEHyJ1BfTGUu4q9jQaMc2rlo6w4zUSvVjET0tZRCLthE1xQCEZnkI0LgAOferxK0Zihp9gevaC3Wf12J+fsYM8R5FWkJdnsP2UoxjU3SAfJcHOi+8j+GHIbfBeoeJkRXcXb8TznN3T51QEB7gL+vKlGc5sJiZJ5wtmJmclGWLYj/SmnsClqm+Il4UJWw6ZuJSW4lur/MIxbWre5rwppY8GvbUqvi7ucBSFuj0JdssClHbrGz+Ye16M+QEiOTQv+uA85TdR0NQ/KjncxBYr8MFbtG1/a/j71JmxhE9X0/noD9NlhVXKredAB+vNsZmnNZSzmYKgi21l9QXMEZqD67GsdrnneTE62rvLGsv3+yzl9LgwPiKdyBwZq58TjLFGqwngiwo5005E0EXKS2gNaqScIH6kv9z+EwJ6vCE6yYJ48auOQKpIEf0e/hFBf9CITGCNp+R1TYnosHxWLQN3Ousl8obtw3DqSJh5VYjt+P8uPHYN7T+hi606oigQ3AJGVmXtZCqkAGQoohNds7qMcwbLeV8kaBMVE3sZYjNo3eIQxsTYV4v05w33mis/D6u6JqPKFkcptRnwzZ+mbTLgl7Dmir4akH3hfBN9McNksSALBdQEUlhTIotv/FhVkvRgkh7Vxc6Y1yIFSIb7qTCyTZEfw3MQCeLfZQ+CJWNfsWyR53NphPy8Us15KcFB5hDDMS310g0EAoHo+gy7N6XdzV6gKdRN176TcL6Fo75tOZ6t0kZzbuVuP2acdbIjoqhOBGd1tKYxBHZMIeQ8LYT41voyfwl9uyPesnqtB8zn/jVD5IC7J7UtpE7KUV3UpCL21jdHPapEuemOHs3qfZVEfV0vzaglJsOBP+isKoO7v3d+w4O7BLgKsKQOrjtD/6CQ0oXT8tdQ+jLBoYsmH55HwLsVP5vZtolD5jzciDN
 iEGAcuP/
 l7f1N37C5R4EgbUa/KNbdkOQsQAgL92ky5AMUCyWUf4/OtHJoNMk3Eq9U3YPv77Aos7wk7s6t4Ydw9tu384IgCeaLRBTkQjiDME9c5HD+WP2Utwqh7shJ+kB2jA14DHtx/eU+Yq4j9epnuQkgaAMTywP2WcoAsWT/hFPwqZsFFC1qHaFqczO71+Zbe+bFPWsVPjK2fHuW0PDRaJD3qpChVOdsq+8Uq6NK+8kG080Ca7UgqU+o5EirILVmDIthVm0wqxswKVo1GkvHpT49NDIIyM1xtX09/RpA9eFH9xLwvxY5rJ9SaHlGyNcuMePOwv7fFFUFdyFnm0HbMpd5oUilpG/I4mSIU/B/XlW3A+M9GgYvWtvxw79Nsi4bFwjwEtiQw8js48UCzgYREyU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Linus Torvalds <torvalds@linux-foundation.org>

PG_rcu_free holds back the reuse of a folio's memory until a grace
period after the folio is freed.  A stolen page cache pipe buffer is
reused without being freed: remove_mapping() takes the folio out of the
page cache and the caller keeps it.  fuse_try_move_folio() puts it into
a fuse file, where writes change it under a reader that found it before
the steal.

Drop ->try_steal from page_cache_pipe_buf_ops.  fuse_try_move_folio()
and virtio_console's pipe_to_sg() then copy, as they already do when
stealing fails.  SPLICE_F_MOVE from the page cache into a fuse file or
a virtio console now copies.

Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
[kas: rewrote the changelog]
Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
---
 fs/splice.c | 51 ---------------------------------------------------
 1 file changed, 51 deletions(-)

diff --git a/fs/splice.c b/fs/splice.c
index 9d8f63e2fd1a..0133c2348da0 100644
--- a/fs/splice.c
+++ b/fs/splice.c
@@ -55,56 +55,6 @@ static noinline void pipe_clear_nowait(struct file *file)
 	} while (!try_cmpxchg(&file->f_mode, &fmode, fmode & ~FMODE_NOWAIT));
 }
 
-/*
- * Attempt to steal a page from a pipe buffer. This should perhaps go into
- * a vm helper function, it's already simplified quite a bit by the
- * addition of remove_mapping(). If success is returned, the caller may
- * attempt to reuse this page for another destination.
- */
-static bool page_cache_pipe_buf_try_steal(struct pipe_inode_info *pipe,
-		struct pipe_buffer *buf)
-{
-	struct folio *folio = page_folio(buf->page);
-	struct address_space *mapping;
-
-	folio_lock(folio);
-
-	mapping = folio_mapping(folio);
-	if (mapping) {
-		WARN_ON(!folio_test_uptodate(folio));
-
-		/*
-		 * At least for ext2 with nobh option, we need to wait on
-		 * writeback completing on this folio, since we'll remove it
-		 * from the pagecache.  Otherwise truncate wont wait on the
-		 * folio, allowing the disk blocks to be reused by someone else
-		 * before we actually wrote our data to them. fs corruption
-		 * ensues.
-		 */
-		folio_wait_writeback(folio);
-
-		if (!filemap_release_folio(folio, GFP_KERNEL))
-			goto out_unlock;
-
-		/*
-		 * If we succeeded in removing the mapping, set LRU flag
-		 * and return good.
-		 */
-		if (remove_mapping(mapping, folio)) {
-			buf->flags |= PIPE_BUF_FLAG_LRU;
-			return true;
-		}
-	}
-
-	/*
-	 * Raced with truncate or failed to remove folio from current
-	 * address space, unlock and return failure.
-	 */
-out_unlock:
-	folio_unlock(folio);
-	return false;
-}
-
 static void page_cache_pipe_buf_release(struct pipe_inode_info *pipe,
 					struct pipe_buffer *buf)
 {
@@ -155,7 +105,6 @@ static int page_cache_pipe_buf_confirm(struct pipe_inode_info *pipe,
 const struct pipe_buf_operations page_cache_pipe_buf_ops = {
 	.confirm	= page_cache_pipe_buf_confirm,
 	.release	= page_cache_pipe_buf_release,
-	.try_steal	= page_cache_pipe_buf_try_steal,
 	.get		= generic_pipe_buf_get,
 };
 
-- 
2.54.0



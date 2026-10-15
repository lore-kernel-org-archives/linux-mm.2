Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 59C5ACC6B34
	for <linux-mm@archiver.kernel.org>; Thu, 15 Oct 2026 11:40:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 56BB66B008C; Thu, 15 Oct 2026 07:40:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 51B416B0092; Thu, 15 Oct 2026 07:40:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3E45D6B0095; Thu, 15 Oct 2026 07:40:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 08AA46B008C
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 07:40:50 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 87213C0994
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 11:40:50 +0000 (UTC)
X-FDA: 85324668660.13.AFE1F45
Received: from o1.ptr9745.em.honeycomb.io (o1.ptr9745.em.honeycomb.io [149.72.141.136])
	by imf13.hostedemail.com (Postfix) with ESMTP id 6B7EA2000B
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 11:40:48 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=honeycomb.io header.s=s1 header.b=U8gViLWJ;
	spf=pass (imf13.hostedemail.com: domain of "bounces+3311449-c6d3-linux-mm=kvack.org@em.honeycomb.io" designates 149.72.141.136 as permitted sender) smtp.mailfrom="bounces+3311449-c6d3-linux-mm=kvack.org@em.honeycomb.io";
	dmarc=pass (policy=quarantine) header.from=honeycomb.io
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792064448;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=W1u+B47QVH+BqoNNDPxX4qPg/iyN+d0UIT6/3msYHfQ=;
	b=gLOZv9KQ6+PFDZvJqlQm3OvoV1dD3q3eUI/BUcjwibTMoolJmFGEI33jt7iBFr/GtCF4cx
	v/R5e2W9gJTw0HlDLE7vLEVYSBDUdrMATDgI9t8hTJFf57v2mBKmQ3+ZIlMqsI6q/OhLJ5
	RLne7aK5oQaXrqq/qjGmfqP3x3BjqfA=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792064448;
	b=YanURj717ZZ/mZ3UMeV8/9A+VlyInSBJktmIYFrFGEPSLLxqWC8ENY8psGrF3etvDCr/mh
	Zd4MFNF9FqOhqhTnpHW94CkBvO3M+tBk73qovgaCeC5vIGTgkc12v2rrBMMSyOSauy06r4
	ppyU3kDGuOJSP/TjNpJDKeMC0AkoNws=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=honeycomb.io header.s=s1 header.b=U8gViLWJ;
	spf=pass (imf13.hostedemail.com: domain of "bounces+3311449-c6d3-linux-mm=kvack.org@em.honeycomb.io" designates 149.72.141.136 as permitted sender) smtp.mailfrom="bounces+3311449-c6d3-linux-mm=kvack.org@em.honeycomb.io";
	dmarc=pass (policy=quarantine) header.from=honeycomb.io
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=honeycomb.io;
	h=from:date:subject:mime-version:content-type:content-transfer-encoding:
	references:in-reply-to:to:cc:cc:content-type:date:from:subject:to;
	s=s1; t=1792064447;
	bh=W1u+B47QVH+BqoNNDPxX4qPg/iyN+d0UIT6/3msYHfQ=;
	b=U8gViLWJz/D2S6LgzWMkxHcH/T5PE/ED9CMWPOK8F3I/EwNKdb6nemCx008WA9CdOIBp
	9n+KTQluwT02ucI2WUqpERCOIHn52ugSP3RUnrk2xzkVBLaIJdwcMiATuaQndHqdG897WB
	XHBmBqsHHETX64fqwVoWo0Y4nrUXlOUBcVe5WYtlc1eTbIzfx1lhdZufQVAJclOZ8fX1P4
	+mOdG79oTY1vwidiS5Yvn7ob/szutUjMOnd8GHgTehkuxEnIr36H8/pHDXgFxb6zVXwwd7
	uPL2mEKn7ZG+bDrKH1+nGh50qieK6K1GHuqEwOD+zJJ4k3iKsDy4t8Ij0+XhYW7A==
Received: by recvd-6bcc8657fd-7xfmc with SMTP id recvd-6bcc8657fd-7xfmc-1-6AD0BBBE-5A
	2026-10-15 11:40:46.841842789 +0000 UTC m=+1363199.854799708
Received: from [127.0.1.1] (unknown)
	by geopod-ismtpd-34 (SG) with ESMTP
	id VqFvasx4SLG8b5RDUQfJFg
	Thu, 15 Oct 2026 11:40:46.754 +0000 (UTC)
From: Liz Fong-Jones <lizf@honeycomb.io>
Date: Thu, 15 Oct 2026 11:40:47 +0000 (UTC)
Subject: [PATCH v7 1/3] writeback: clear the old wb's dirty IO state after
 switching inodes
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20261015-wb-dying-cgwb-flush-v7-1-9278d9ebaf5d@honeycomb.io>
References: <20261015-wb-dying-cgwb-flush-v7-0-9278d9ebaf5d@honeycomb.io>
In-Reply-To: <20261015-wb-dying-cgwb-flush-v7-0-9278d9ebaf5d@honeycomb.io>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1745; i=lizf@honeycomb.io;
 s=gpg; h=from:subject:message-id;
 bh=KBWkxkWj46zd0xpwSYEYCzKTU4VSqzbWDHFWbIpbEgE=;
 b=owEBbQGS/pANAwAKAaXO1OOXra/CAcsmYgBq0Lu8rKtwblHFjr9VRJbmtr+LLZ3cYYunp4xOW
 WrZUBkpr4KJATMEAAEKAB0WIQSfW1LPQ0gyJmoTHwelztTjl62vwgUCatC7vAAKCRClztTjl62v
 wp1LCADqhkBoYfmjxiMI2Tf9lnvY+4nejQr0tz3w5LnXY8N8R11E73joo7VVogUf0R/ovhudv8v
 2V9KqUJirxbnh88lQsSqoEjaBPQsved22/sekx2x1ixn+ytyZaY5KSnsoPiv60hKHz8rld6vaZs
 KIAaBczYFhy/bPOtGhW4/DlYGww/wRHyUq28PYO8mkVIOON9rHPeV0Nz+vv4Ax95oYnMesw+RqH
 cut5rYVPbs3bS5pIK6M5eymh6WV3cOa3/SEWIVrXXfXntwyAbrtUfro7Xq0TkkZoesAH2qO/WCk
 sekOINs+cWvCKohc0kKQxlba3IjhAdbczK+672cGv5xp6S7X
X-Developer-Key: i=lizf@honeycomb.io; a=openpgp;
 fpr=1F7714D7EC3441D2CECC24606A3F8B00FBDDD2A4
X-SG-EID: 
 =?us-ascii?Q?u001=2ECuH7N2XAoeMR1zrzr=2F6NZrhli2vbKPOHff5fJuZuba6ZIE8QPyIf9mn4Y?=
 =?us-ascii?Q?ezqeFFjUkh=2FeROy4LtnO7KN9jZmeew8=2FcRq885E?=
 =?us-ascii?Q?u3Ov4f8W5n5pP8=2Fa06ebyKdHexyEXibOUIzFFzp?=
 =?us-ascii?Q?FtJT92p6u4X8vyHcALfAGBnicOn8G3J8x1TTcGY?=
 =?us-ascii?Q?TB=2FIvCs9tCEtiD2Umc1pg0O4Ge963mFHJH1sm92?=
 =?us-ascii?Q?PwkLKgaQIx509V6oLJyOajMcGSmGYc29AWRUieM?= =?us-ascii?Q?5JdT?=
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
X-Rspamd-Queue-Id: 6B7EA2000B
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: gzzbk59jrhb5nfanw7d17bp95zanie5k
X-HE-Tag: 1792064448-86709
X-HE-Meta: U2FsdGVkX19Ti9Ru7zIwrQY42K9BHfhxTMhqwj2THL8l77j6qiYXf76162Oq/7dDsFntpXHda8u1VodgaQofDi9vR13Ok7cXG0pLgPtfeJxU07IcdWYmM8QDdxAWZlSuhAzgfyAc96ynC9HfOJhr4OL+BTCeNZbbykb67Bs40KwXWqzxrcw5+giNHSdxaaUUR22pEoonyK7V6Npt9zeBgoOWkO4WcaBgFMLqu1wJ3Zu9IXYgmcoTLkNT2KBsZoj8/PHf5CUJBhh7lxFXjIr3MwQl4QbPug5ZZ6qDVOEqKK3BGFBmiX5esegL+X+H9y102Qe+AT13sKSqrX5V0TZuuxmVBylihguAwPXM3DqcPRDS2dXXXHNKwd14LXwtQFM199Jfs7dipATfaDVKankSrRD8MWChynrvP1eDx2hG1nldGwBq36dMp1p3V+abok4aODhSrFRum/LZFlJJdA6TuNZ5qodwMUp/ubTqgW42HB9V2wExQJr+trlQxkO2YEAn6Gq0QKFC8ghJioBZN9XsNr/lCgGXCyFadiitKMCDt2Tg+tKoDpyQ/q/aABWOvZJ0yTwfEDbCc6q600l1ZIqgkUmKNlfBFeTKL2uv2glBVSAKVvYnMXcqEmWgZNRoYDi8tW6+/MRpvvGI4/vVjXFtp9n6ehaK8XcDDjKEp5FcsAFtDROyaNblPlf+HrzdX5ryuWy8kcnC89FGrl7joCXPQ7AAYNgu1MsNd8Tx9lwkfMzNXpY1qMfyi4gSG/hfZnxOyalzGqYI8IkX9VVKc7WtnCKMEdIg1Al4utZarGhGWcfq8t1afHkxV4xpCIPbYq7iH2L410uGYKk1xXx5YGxFkThUUoOaX9KzCHAmUOjl3+eEeZOqgZspHCXwfbxnjw654fkn3tjMqxJ6XdfXsFRiAUrOaYz8NJ8v+tqG5XGtjYM2OjYsUzgZqTpDubEZeuNBbAdU8xd0AkxFWcFaylH
 f7wrzseO
 DoUcQQIjnsQTrhzsokdJhleSG7y48XNZOG7o5nuBzdSZTGJqYskkbr0YBjhIdYyqn22qjyXQ6ej5RDQQbBXLiaGHDsf6FaHQKBzS+evQISdOsgkxGK5TlXx2kD21A39GL5FAt/qvM/0+XN8bzok3ldmy/j7/+/BpP6K0oTe0RGlGBlU4Sy7fNkiwnWE9AFuUfr8Zz3y2ZSe7K1dsvNsCZmuf01FkcMcIe34e/QeX6fHpjs/cMvpgLyPfhBR4LQuIzPBco9TKSX3l4FCHgsuAnf7hjcGSeFq4trfsO+neg6lEMrxMvBME6AcKTukYk3X98m/pVJuRggBs0ThbRF3ZLvpNAn57ZUclmccZifhEB/UzlBHzIxZC0hEQYAZgBstWaZIwf0WIzkkodgEmyIoKVJBvekBypifNy7DgwQSmsFvpatUVD8t/kKmQh0rj0ONoFlP0n6ayjwqU5ulTh6CwBVaVyuRHVrO19DCNiyqZlZo6WmTBP4vdI2Fi0Y5gUZtp+Ft7c6qGO4QQkkcme4iEFHsT63K/k4bgHJ7b2
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Switching a dirty inode to another wb can leave WB_has_dirty_io set on
the old one. inode_do_switch_wbs() moves the inode onto new_wb->b_dirty
through inode_io_list_move_locked(), which only updates new_wb, and
nothing calls wb_io_lists_depopulated() on old_wb. A live wb clears the
bit on its next dirty to clean transition, but a wb that gets no more
inodes, such as a dying one, is freed with its avg_write_bandwidth still
in bdi->tot_write_bandwidth, which wb_split_bdi_pages() and
wb_min_max_ratio() divide by.

Call wb_io_lists_depopulated(old_wb) after the switch loop in
process_inode_switch_wbs(), while old_wb->list_lock is still held.

Test: after the last patch in this series switched a replaced wb's dirty
inodes away, BdiWriteBandwidth stayed at 411700 and 407820 kBps with no
writers and b_dirty, b_io and b_more_io all empty; with this patch it
read 0, in 3 of 3 runs.

Suggested-by: Tejun Heo <tj@kernel.org>
Assisted-by: Claude:claude-opus-5-5 checkpatch sparse
Assisted-by: Claude:claude-fable-5-1
Acked-by: Tejun Heo <tj@kernel.org>
Reviewed-by: Jan Kara <jack@suse.cz>
Signed-off-by: Liz Fong-Jones <lizf@honeycomb.io>
---
 fs/fs-writeback.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
index d26b2cf05283..050d507aa554 100644
--- a/fs/fs-writeback.c
+++ b/fs/fs-writeback.c
@@ -566,6 +566,12 @@ static void process_inode_switch_wbs(struct bdi_writeback *new_wb,
 		}
 	}
 
+	/*
+	 * inode_do_switch_wbs() only updates @new_wb's dirty IO state.  Clear
+	 * @old_wb's if its IO lists are now empty.
+	 */
+	wb_io_lists_depopulated(old_wb);
+
 	spin_unlock(&new_wb->list_lock);
 	spin_unlock(&old_wb->list_lock);
 

-- 
2.53.0



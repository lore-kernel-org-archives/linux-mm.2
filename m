Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 71EE4606A31C
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 14:53:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=MaVc7TlE
Received: by kanga.kvack.org (Postfix)
	id A84256B05BA; Tue, 10 Nov 2026 09:53:03 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A35116B05BB; Tue, 10 Nov 2026 09:53:03 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 860D66B05BC; Tue, 10 Nov 2026 09:53:03 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 57F626B05BA
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 09:53:03 -0500 (EST)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id E55631608DB
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 14:53:02 +0000 (UTC)
X-FDA: 85419501804.03.9974D29
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf28.hostedemail.com (Postfix) with ESMTP id EF432C0004
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 14:53:00 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=MaVc7TlE;
	spf=pass (imf28.hostedemail.com: domain of kas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794322381;
	b=EBPZ+RhBG9KhaPxtxbjeLun1l7TLSxg8ueJBw8foS+jnbejvmZIzkvBVc12iXeQw3GTk8c
	MYNX264M99XDoQWMSFMOA0SaD+SCgSzppWP/LymwNVDiBIs0/IR46PK5uiB0ECq4jR0dQZ
	hwuLuwFmtWGQCxB6fKAWOGD9Hbjdccc=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=MaVc7TlE;
	spf=pass (imf28.hostedemail.com: domain of kas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794322381;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7dG4/NDMTYOYfl07jMa01MQBiiZoMUtqo8N33muHYAI=;
	b=vkF+FoMZQZHe6vp0FeRCkZw/xKy4IPF+9Hf7fSUIF50mYMgolHGJf9yOvHI3e6N068P0PC
	nZ0GxuRYkK9KTSUJExy4JquA5DFI113xBsoFxDH/b38uBFlM43X0tspzdXW/wT8SfY97NN
	qkp7yMzCqMH68OYULft1KgTerm6F2MU=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 874D6639C5;
	Tue, 10 Nov 2026 14:53:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D068F1F00921;
	Tue, 10 Nov 2026 14:52:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794322380;
	bh=7dG4/NDMTYOYfl07jMa01MQBiiZoMUtqo8N33muHYAI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MaVc7TlEOKGMYyp+hro+is1cMFWWsQ1mP4Z33ryMG5SeYZDAv77/D8RAivjUXEY+l
	 IJjZKLaDeXSfzj6xZc4o/Klw1iQ1LkD7NNtrCkvjgDJZShbuc2rOApDAGgeh6Io//f
	 SeBysUEGC28DxZ9Tt7O9gmno2DoiJ9kU1/FaELdE6CVhMHA2lwaJ7aViS+oGeF3OxP
	 jUPG4OiepIoac/3JZseXB/U3iot0hBF8gyt5lhrRPgB6mgmY2/CGrQAQBcH5ZRdYbp
	 m0a4kFd304p+BzTfhP4d7J26+hUi8JYvousrkQxODU1FggZHIWL0lRLPO/3KYSzThf
	 r3NjKIte+vuXQ==
Received: from phl-compute-02.internal (phl-compute-02.internal [10.202.2.42])
	by mailfauth.ams.internal (Postfix) with ESMTP id 3A5AF198003A;
	Tue, 10 Nov 2026 09:52:55 -0500 (EST)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-02.internal (MEProxy); Tue, 10 Nov 2026 09:52:57 -0500
X-ME-Sender: <xms:xi_zagw4WeoYpxRyKBG5JZTaEX29ChjFEI59znsedEAc3LYj5hyZCg>
    <xme:xi_zalADPv68oVaOAVGw5tl2Ou0YxpafEENitIenkz_8bjZqDcqAWfzGWycbtaHjs
    AtVobY2cHx7VmZ35zeJqFJejqmqM8fTRbMuQaFrt1BUx2-Dr4ELVI0t>
X-ME-Received: <xmr:xi_zamKIFvn3P3iGzSafumQB-MOW2ZBt9Fx-Z9bfUgnZXXzJuuu3NT-CNPg>
X-ME-Proxy-Cause: dmFkZTGzAp0d7QCfANqgQV3SqAp9E3ejIU9CgJIjCZNQC1XPJVWn299uIoWq4HTg3uzxou
    VcW2In1RCBXXfbaT64IHfNVL8IBe90aLZXPZKpuK00ekN93xm+yjIlb6e6DzLr1dadDNTL
    pUkdrsXoUEMfiTtQnxAyyQ0eJ6q/OsKkRQ9xLALi4ea4xcyA+sruGqyPJEK3OWAd7CNanm
    odUqpeCSt6F+Go5ECG7Cz90wDg2pJfzb9Ccu6bVw8aYM0JyamtNvp9lurJaDNl8eJFbh1V
    ko1vPHhx8+RdtVZUlhBMGeLGAiga+Rb5lbdz3EkPt25TpPWaMyowzruv5FR075oM4YDUa6
    rYGZyw4IYKVsckzU8fgaq6pUh8faEdD9I3N0UE68ZxVuRGAwNzkAYO/Gye1Jes917hAELm
    RGMZfRd1Uh0YW7ruwWWq5zr3FNdgnpbpw36QomassbtsIjFBFgb2Eg5i9+DukDRCE9PHrL
    BFN+GnVuaq9RI7/e4rBfrsQPtwCOb3R3KycgE0QgHlq8NSC1NqQZXoYRw5APt/zC4sLp1H
    j6xNcZBB1kglc2io+pF0mzdYu4L6zcFekBHuespvioNgqulJYwWwi4T+UoaiYpOuyPeIdN
    DA9Hk+cRFtfteOoKSoGjJ7InvVIckFMDMBSMBh0M6hjb//ZKUzFS6lrcHVkg
X-ME-Proxy: <xmx:xi_zagHMkV3r6iVolBMKoRfZ4hPtYzWv6mdjqzmGhlpxIlvpVbPkDw>
    <xmx:xi_zahG2znIN_v8oKray1c3P3x3Mi6_VXCx6SjomduusVLimq8KjCQ>
    <xmx:xi_zaovxtBLV6WnQmGL-Tyd9AqmYyT17gX3knxxhVLYyDQkjO8Dxew>
    <xmx:xi_zasa7xLcJjqmjeF92WMbv35c2pqYAbn-tmlGXXTQK1qHsEBWvtw>
    <xmx:xi_zaqOCwFluxmMIitwg4mkwzwgGBhbUAUj_ZcLWqRfNNFLKr3f9kxba>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 10 Nov 2026 09:52:54 -0500 (EST)
From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>
To: Christian Brauner <brauner@kernel.org>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Miklos Szeredi <miklos@szeredi.hu>,
	Amit Shah <amit@kernel.org>
Cc: "Kiryl Shutsemau (Meta)" <kas@kernel.org>,
	Jan Kara <jack@suse.cz>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	Matthew Wilcox <willy@infradead.org>,
	Zi Yan <ziy@nvidia.com>,
	Bernd Schubert <bschubert@ddn.com>,
	Hugh Dickins <hughd@google.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Arnd Bergmann <arnd@arndb.de>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>,
	linux-fsdevel@vger.kernel.org,
	fuse-devel@lists.linux.dev,
	virtualization@lists.linux.dev,
	netdev@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	kernel-team@meta.com
Subject: [PATCH 2/4] fuse: don't move pipe buffers into the page cache
Date: Tue, 10 Nov 2026 14:52:37 +0000
Message-ID: <20261110145241.536019-3-kas@kernel.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20261110145241.536019-1-kas@kernel.org>
References: <20261110145241.536019-1-kas@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 8k1sce6y55xrd7fn6qskkiu4e5hkwazn
X-Rspamd-Queue-Id: EF432C0004
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794322380-319203
X-HE-Meta: U2FsdGVkX18hc5iXvbuc8S2fumjGGfsXfEc05+XdSWF/Ojbv5Ri97r+qneKn++HlC7H/ySTEodCrjQDaNlVa/1mKd7XMwbPZlcLIq69W2lvFVhmlo/iqxg4hamNEguzeZC4Pz1XZBH/5NxMQ8ztNFHgr/q28Z/ehIso5D3J+ouenAtF/v2XB9t+kfFSHM5zY2eR9Fto8Ep6yXgRi+AddjQvFWtB3++DAxJjG6hZU3hIIpBbThKuNEHmD2n0WPhKFHxgEIufbbyqukfdw2Vv4lFkFbhT2R+cx9nhEzYd+fOxTo8IUktDr1rUZnGe4CRS/h1sTFisAoPh+AubFJZSicsGEex/UPreJ9kDVcezU8s+iO/UhuflqiiyJiwhQiBWTNrSSzX8AHF5IB2Ke/N4Ah7XUUrDgV5ZR+8WSJLrNER7+8HpNhEg28QvXvZojMDfJnNlYqa38wViCdOZ+kMufVZHlgnjITO2IZU8WRbM/90oSJC0gzZ4TNSuJa5znO8kVSURasVL6BGHraVhpD74MVQiR/E/VppuVls7aM2J5lroOdRVGl8hPLsNpKrqx8JcTnqy1ZdSlbO+MBX7ySo26mTmoCkn1GROe5zAJ1OEqGy/wrnJ33OqExb1YOzMaz/xA9sjeXBGXPLgOam5rLEyf0NA7rXk/Z3oZqcwp464vkqgNUngNxWrGifMxL2//0Vt1rnzge61oMOyG8V7/3peYi62wF0YtEgvPzQlvOKQIUu3i/0Vy1SMe4r+QbCEUFziv5E0n6/1vRldesOM7LDnA6WFeSbdehmcPqFlgV2euVVsL8LQzwHudySiwyjjY9R/ebsvZTTyiPeYBY92ffmoytGrLMqX9vIo9A/WOh/kuYR/UTfsheh+XKNIQNXaHKoAoBZFkzYhKwis0w1lGhg4S/pC4Y1ZVX32jPPOgHxGmDV/6Nq/o4sT4mMg3LUywq2ZOs7bGgvS/bmvuc2MnxhL
 1tw+wZ/1
 kJ2v0Ccdo1v15E7/Sget/BgMTkMMawvNRh1HMSytqWxz9mY1ry3Zqr86BcVQY2FReQKIQg7+UkbDJTWTarQjzNjcoaLG/64jPuR5TDGYe0tY9dv7/7gDe5FK4bq2QbxmSrKpQClP773BmseVi2+4f2u34KlFw44pNx1c9i/ue5ZTCLQ+0+iW5UeIQbENfpLmBlOrbwvwIEFGn4t39d+dT24lBh4OBsIbpGlxIXtNyWpcGRPiF503Qt+rS7ApQSce2TupAdIR/dj0p73xHDKVkFGfZP2hJcYJSC61A/w7Yz56C+EtIPETyJ0FiBGOIow7TI5nU
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

A splice() into /dev/fuse with SPLICE_F_MOVE lets the reply to a read
request steal full pages from the pipe.  Each stolen page replaces, in
the fuse file's page cache, the folio that the request allocated.  The
page can be a page cache folio of another file, a page written into the
pipe, or a gifted user page.

Always copy.  The server sees the same data, and the move was a hint
that splice() never promised to honour.

Keep advertising FUSE_SPLICE_MOVE.  libfuse fails the mount of a
filesystem that asks for a capability the kernel does not offer.

Preparation for removing ->try_steal() from pipe buffers.

Suggested-by: David Hildenbrand (Arm) <david@kernel.org>
Suggested-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
---
 fs/fuse/args.h       |   1 -
 fs/fuse/dev.c        | 144 +------------------------------------------
 fs/fuse/file.c       |   1 -
 fs/fuse/fuse_dev_i.h |   1 -
 4 files changed, 3 insertions(+), 144 deletions(-)

diff --git a/fs/fuse/args.h b/fs/fuse/args.h
index 5173264a1261..36ef0c6d5999 100644
--- a/fs/fuse/args.h
+++ b/fs/fuse/args.h
@@ -36,7 +36,6 @@ struct fuse_args {
 	bool user_pages:1;
 	bool out_argvar:1;
 	bool page_zeroing:1;
-	bool page_replace:1;
 	bool may_block:1;
 	bool is_ext:1;
 	bool is_pinned:1;
diff --git a/fs/fuse/dev.c b/fs/fuse/dev.c
index 3641abb90d6b..e7238eed21fb 100644
--- a/fs/fuse/dev.c
+++ b/fs/fuse/dev.c
@@ -1099,128 +1099,6 @@ static int fuse_copy_do(struct fuse_copy_state *cs, void **val, unsigned *size)
 	return ncpy;
 }
 
-static int fuse_check_folio(struct folio *folio)
-{
-	if (folio_mapped(folio) ||
-	    folio->mapping != NULL ||
-	    (folio->flags.f & PAGE_FLAGS_CHECK_AT_PREP &
-	     ~(1 << PG_locked |
-	       1 << PG_referenced |
-	       1 << PG_lru |
-	       1 << PG_active |
-	       1 << PG_workingset |
-	       1 << PG_reclaim |
-	       1 << PG_waiters |
-	       LRU_GEN_MASK | LRU_REFS_MASK))) {
-		dump_page(&folio->page, "fuse: trying to steal weird page");
-		return 1;
-	}
-	return 0;
-}
-
-/*
- * Attempt to steal a page from the splice() pipe and move it into the
- * pagecache. If successful, the pointer in @pagep will be updated. The
- * folio that was originally in @pagep will lose a reference and the new
- * folio returned in @pagep will carry a reference.
- */
-static int fuse_try_move_folio(struct fuse_copy_state *cs, struct folio **foliop)
-{
-	int err;
-	struct folio *oldfolio = *foliop;
-	struct folio *newfolio;
-	struct pipe_buffer *buf = cs->pipebufs;
-
-	folio_get(oldfolio);
-	err = unlock_request(cs->req);
-	if (err)
-		goto out_put_old;
-
-	fuse_copy_finish(cs);
-
-	err = pipe_buf_confirm(cs->pipe, buf);
-	if (err)
-		goto out_put_old;
-
-	BUG_ON(!cs->nr_segs);
-	cs->currbuf = buf;
-	cs->len = buf->len;
-	cs->pipebufs++;
-	cs->nr_segs--;
-
-	if (cs->len != folio_size(oldfolio))
-		goto out_fallback;
-
-	newfolio = page_folio(buf->page);
-
-	if (folio_test_large(newfolio))
-		goto out_fallback;
-
-	/*
-	 * This is a new and locked page, it shouldn't be mapped or
-	 * have any special flags on it
-	 */
-	if (WARN_ON(folio_mapped(oldfolio)))
-		goto out_fallback;
-	if (WARN_ON(folio_has_private(oldfolio)))
-		goto out_fallback;
-	if (WARN_ON(folio_test_dirty(oldfolio) ||
-				folio_test_writeback(oldfolio)))
-		goto out_fallback;
-	if (WARN_ON(folio_test_mlocked(oldfolio)))
-		goto out_fallback;
-
-	if (!pipe_buf_try_steal(cs->pipe, buf))
-		goto out_fallback;
-
-	folio_clear_uptodate(newfolio);
-	folio_clear_mappedtodisk(newfolio);
-
-	if (fuse_check_folio(newfolio) != 0)
-		goto out_fallback_unlock;
-
-	err = lock_request(cs->req);
-	if (err)
-		goto out_fallback_unlock;
-
-	replace_page_cache_folio(oldfolio, newfolio);
-
-	folio_get(newfolio);
-
-	if (!(buf->flags & PIPE_BUF_FLAG_LRU))
-		folio_add_lru(newfolio);
-
-	/*
-	 * Release while we have extra ref on stolen page.  Otherwise
-	 * anon_pipe_buf_release() might think the page can be reused.
-	 */
-	pipe_buf_release(cs->pipe, buf);
-
-	*foliop = newfolio;
-	folio_unlock(oldfolio);
-	/* Drop ref for ap->pages[] array */
-	folio_put(oldfolio);
-	cs->len = 0;
-
-	err = 0;
-out_put_old:
-	/* Drop ref obtained in this function */
-	folio_put(oldfolio);
-	return err;
-
-out_fallback_unlock:
-	folio_unlock(newfolio);
-out_fallback:
-	cs->pg = buf->page;
-	cs->offset = buf->offset;
-
-	err = lock_request(cs->req);
-	if (!err)
-		err = 1;
-
-	goto out_put_old;
-}
-
 static int fuse_ref_folio(struct fuse_copy_state *cs, struct folio *folio,
 			  unsigned offset, unsigned count)
 {
@@ -1275,16 +1153,9 @@ int fuse_copy_folio(struct fuse_copy_state *cs, struct folio **foliop,
 				return fuse_ref_folio(cs, folio, offset, count);
 			}
 		} else if (!cs->len) {
-			if (cs->move_folios && folio &&
-			    offset == 0 && count == folio_size(folio)) {
-				err = fuse_try_move_folio(cs, foliop);
-				if (err <= 0)
-					return err;
-			} else {
-				err = fuse_copy_fill(cs);
-				if (err)
-					return err;
-			}
+			err = fuse_copy_fill(cs);
+			if (err)
+				return err;
 		}
 		if (folio) {
 			void *mapaddr = kmap_local_folio(folio, offset);
@@ -1920,9 +1791,6 @@ static ssize_t fuse_dev_do_write(struct fuse_dev *fud,
 		if (!smp_load_acquire(&fch->initialized) || !fch->connected)
 			goto copy_finish;
 
-		/* Don't try to move folios (yet) */
-		cs->move_folios = false;
-
 		err = fuse_notify(fch->conn, oh.error, nbytes - sizeof(oh), cs);
 		goto copy_finish;
 	}
@@ -1966,8 +1834,6 @@ static ssize_t fuse_dev_do_write(struct fuse_dev *fud,
 	set_bit(FR_LOCKED, &req->flags);
 	spin_unlock(&fpq->lock);
 	cs->req = req;
-	if (!req->args->page_replace)
-		cs->move_folios = false;
 
 	if (oh.error)
 		err = nbytes != sizeof(oh) ? -EINVAL : 0;
@@ -2068,7 +1934,6 @@ static ssize_t fuse_dev_splice_write(struct pipe_inode_info *pipe,
 				goto out_free;
 
 			*obuf = *ibuf;
-			obuf->flags &= ~PIPE_BUF_FLAG_GIFT;
 			obuf->len = rem;
 			ibuf->offset += obuf->len;
 			ibuf->len -= obuf->len;
@@ -2083,9 +1948,6 @@ static ssize_t fuse_dev_splice_write(struct pipe_inode_info *pipe,
 	cs.nr_segs = nbuf;
 	cs.pipe = pipe;
 
-	if (flags & SPLICE_F_MOVE)
-		cs.move_folios = true;
-
 	ret = fuse_dev_do_write(fud, &cs, len);
 
 	pipe_lock(pipe);
diff --git a/fs/fuse/file.c b/fs/fuse/file.c
index d5e1cb53d86a..ab955e4c3e5d 100644
--- a/fs/fuse/file.c
+++ b/fs/fuse/file.c
@@ -1096,7 +1096,6 @@ static void fuse_send_readpages(struct fuse_io_args *ia, struct file *file,
 
 	ap->args.out_pages = true;
 	ap->args.page_zeroing = true;
-	ap->args.page_replace = true;
 
 	/*
 	 * Don't overflow end offset.
diff --git a/fs/fuse/fuse_dev_i.h b/fs/fuse/fuse_dev_i.h
index 4b412a76225f..a90ce26ded31 100644
--- a/fs/fuse/fuse_dev_i.h
+++ b/fs/fuse/fuse_dev_i.h
@@ -326,7 +326,6 @@ struct fuse_copy_state {
 	unsigned int len;
 	unsigned int offset;
 	bool write:1;
-	bool move_folios:1;
 	bool is_uring:1;
 	/* set when the payload is zero-copied. folios are filled in place */
 	bool skip_folio_copy:1;
-- 
2.54.0



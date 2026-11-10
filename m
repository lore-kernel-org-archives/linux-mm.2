Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7DCB5606A334
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 14:53:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=I9Xjpiw6
Received: by kanga.kvack.org (Postfix)
	id 9E7866B05BB; Tue, 10 Nov 2026 09:53:10 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 998AB6B05BC; Tue, 10 Nov 2026 09:53:10 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 812736B05BE; Tue, 10 Nov 2026 09:53:10 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 530636B05BB
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 09:53:10 -0500 (EST)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id DA7911C4320
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 14:53:09 +0000 (UTC)
X-FDA: 85419502098.04.9220355
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf08.hostedemail.com (Postfix) with ESMTP id D9B19160003
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 14:53:07 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=I9Xjpiw6;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf08.hostedemail.com: domain of kas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kas@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794322388;
	b=T8IDZGRu5t89a1LrzriKPWt2tyrSxdSgqUc19+A6vsU7SZFQI0b6VJ3B2hCRXTIxrCuEY/
	FJRoPsTdVshvvELjcxEHnUl5YQ5qqM8mjpCecofRa8FGChiJmRru62SEHNiyysFiwLm6rN
	ug2TJia03qmQBYwJGH8MDDJcdpOuKrc=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794322388;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vXJnmnfnsr5eWSeHa0K3etqyrfF8UK36NYjgCdOCC6k=;
	b=T34ZzH+0REIfkzoRii3uVKRlRlbk5jz/x2KcO8swAii+1N4vRxtnZwx5tMRvWjormr7UqC
	MUp2goqvUHGySoZzJYd2nPSpJeAanFJ3z4v840yPinJAwQ803fOzWOft1DFWLG6TnM33z8
	4OgUpBCz3qqYK2LHuodNkd+lKE8PUno=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=I9Xjpiw6;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf08.hostedemail.com: domain of kas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kas@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 5F565639DE;
	Tue, 10 Nov 2026 14:53:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 215FF1F008A3;
	Tue, 10 Nov 2026 14:53:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794322387;
	bh=vXJnmnfnsr5eWSeHa0K3etqyrfF8UK36NYjgCdOCC6k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=I9Xjpiw6mMCtqOn6JafQqIZNr7WC2/X6o4WJDWoWVS02Fg/zBIfpzEBr9JKov7hTc
	 O3lTCpBwtSfMNReSrYM4yIB5Cc9qh7GfKLAemkRH+LpJSaLSmYTfbPnT6yGmEuqeSf
	 DNGVk/N3rT9mG5KLO3TRWNVbszknRqDAIAudq15qH89Ke0T01umNepyKAQSYjfPZfc
	 kooQPH81UeicnuU2kpQONTkx5kpc6F0trXEurBI+XYaSmdQ1gsQm62uLkJnBRXTVzQ
	 MKvDxZ9aNCaiRuGtoXEr12r0nQAcqS1Y7sPKft8lZfN23MReCzKSboXLMYFsyBztYS
	 selurofTKxY7w==
Received: from phl-compute-05.internal (phl-compute-05.internal [10.202.2.45])
	by mailfauth.ams.internal (Postfix) with ESMTP id 7977D198003A;
	Tue, 10 Nov 2026 09:53:01 -0500 (EST)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-05.internal (MEProxy); Tue, 10 Nov 2026 09:53:03 -0500
X-ME-Sender: <xms:zC_zaqZXFU9ML_bS7mx31XWkHiww2uG0JAbjFyQbB-NPJhHKaDFCbQ>
    <xme:zC_zathV5QfNoiX2k2VV96fpe4j3dOyTFM5jvc-e4ePAodG6M2Wp7Stv5q-JWq1Bu
    -UZJBNsXnA1ubHmTSDJrjpo9x4AGsesjnh0EPj-g-2sBruOCcU_FGTK>
X-ME-Received: <xmr:zC_zaiz7u9XI2O067oEfveMVTpu4dBPddCS_TM-NaqhBPi6IzlLG7jWzO6o>
X-ME-Proxy-Cause: dmFkZTGD2sTgrJUeTY5UcgQtCaOBePSxscDWD3Hg3oyfWkWZonwghfagdzUPwpVCo6p+ah
    RPmbT5HJNOBS1cmURZXQtNYzp7RHrFIqZQP96bnLeib/vXY8/REq7nsdxdpuBWCbMDGPTb
    FktBomwyaihaoKdDGEcRKsKGV+6EYT3RxVWJHcIW3Q3ySxF0ktWMVgCokqtSVFi27eYANM
    a8zLiO3aRBy/cKXa+4f1bKxtIEOKQb9XFI0nrKxhax8VK6C0orRCguRo9T3MAbkGZcM/hW
    mAxjBlTWoBm0WeONWPq1dKUqXpH2G9SamTboeusXlryn9XtW7zeqoRzwm3wi+AVgZZ5EdV
    6wlWwJRjBZ61I9QlU8hJxshsh34VH1K+iczyhZTmKB3d6ZEFJgcUVZNJ8rPfemQNpbTJ2F
    2HiOp3YNEt6353xL8uicY7nOWs/T4bqkD4BGuMV2nvfr3gnWAqgzu+zf2GrYGqzwQG+HbI
    FPVG41GeoSMDQRm03XwJKHk1994K9HdlITbbse4N7vOnz0+PhTqfjxDjUaPBv7divmc1C4
    X6gTBJFDV6vNcPfGBL76ldBsZCWNnYAEeXxQNsf6tCv6qnDgmqeD05sPAvXsASLGlbF6Li
    lMXbNKJ85kQH1bySDDxpiHkdrh4obfRB16fQZ+MLohXdq6MPSY+uiTyqMIyQ
X-ME-Proxy: <xmx:zC_zag65OC2Ibj5MLnzk8YnSMXHK8DjYWaEtOiR88dOVvBWSOyrZtg>
    <xmx:zC_zaj0Na04-fv6euV9fuOyHoExP76s_xkq16RfsNbyiGudeYAKAag>
    <xmx:zC_zap1kO1t5IxSA7yo_NL68nk-U8gav2ioSHHb1gwIp7Lqwkdo2kw>
    <xmx:zC_zaicL3f4ZAzh49E22639SWmm-YQLSfvmhfsMOUJ9dAYYCqstOhA>
    <xmx:zS_zajLLqS8rB4BMbxqVzg7ON77bvaADrtHgPbRcI67m0Xo0qRq6lWtf>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 10 Nov 2026 09:53:00 -0500 (EST)
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
Subject: [PATCH 3/4] splice: remove pipe buffer stealing
Date: Tue, 10 Nov 2026 14:52:38 +0000
Message-ID: <20261110145241.536019-4-kas@kernel.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20261110145241.536019-1-kas@kernel.org>
References: <20261110145241.536019-1-kas@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: D9B19160003
X-Rspamd-Server: rspam12
X-Stat-Signature: u6x4kb3c51nyrhf3xbxdr5z7odxjdbey
X-Rspam-User:
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794322387-828518
X-HE-Meta: U2FsdGVkX1/j6ehFQWGkqoFlT1zUh9Gkt/Uj8347BxzN7vwsZ5dlQPgX4X+eomFV0LHO+RJw5COmNBJ9PxBkSs/KdnWpzXTTThUUOc1I7jMfbfFveLq+leJM0R4U6MFxjEsFEY319mpajRCjiKzBTNyRJV5X+Hc+x3xL7AqdAuQaifalA6AE+3yp24XytFy+p4+owWkO5HG/RBYa/tQW/drtdq66ygGr9q2F3RQsj7IrSOe2zO+JEIg/9Vjmo0iXitQ7Zy8tCU+oMCNSmjmY8xewHGJqkpfkgEJDA1ZF7M+QhC72AguE2ykFeNWBIQzBYr7vvmwJ8wvhUB06jq1DvcdMKmVvLAbAGGbV2BI2WFxQlpaBMyk65nEJSmEmZdtbcYHNPfnLv5fDEW7FRWHjMVoG+TgrQFJkiUAoH/Re+Ufg4D7CwCyilPpNeBMOXKc5LungaKMOUWG3EMbE8A4ZuLeG1UOlI5XKwjRl9Z03mdnB+ihUOsXiBxj2NqPZfqlc2MrlQvcr770RTQqKlKKQomKJ/DblkbFkE0ipj2EtPXxuR8zUt9BawGkUo4AmpzdR5tIqRQdnqxzTB2yFXvWWLtyCbCD7Gl+/9fm9aFOZJySHY3dj8UDNMN/oPrH9t6w7V5t14yAB16gn2JnalMt0Jfn8hITZ6HIwwQATZySwgdtzpFvGaTXzV00pKPTqLjcgFy9P1OvCEibmnGXpcX6i0UYfbsGlY8IijqST7nmfl+fzyP3yclr1YMnljCJeSv0d8q/d/XWFXpyaE3zOdztLLS0Go2C6kPRI+VVLye9z5sd6DnO35CLrTYTTnmUKEWNWKNDsFN4CwFrnfsS/sBQ/OR3nLVX1bh4zNCD7GVQXdba9Q083ukk++UfuDO22oEct5dnefnUWffcHUuKkSy6u78WaTNSKXeWxjiwKHuEq3eMGZGGyqu3cTrSVVyplExy9cehfQm+1jfYc2dEkF6w
 GHXbvHKk
 wCSI1EEEsmNWENKXdxU1WQqxRqzJI7dKxSAOsysLgVToHhfHgU1V5XeBKazJkAKq5f1ub3uCOpvxY+vhRLbH8SGnhCdaWh6SkjxHmEh77dHEoM9ho+d43P/iMhddYNAwPMPPVLcyNU2JXCUgT5kpk2K28LeFTLqlbyaqef+G68w7FpjdS9Y8+FNWQhbln7aLNmRdu0f4NauDZqVnklWfA8rClAmJ1EpxMSAFL6jbx1//2W/pr+0/Tax5YoXBoF6pdlSY9yGzoHOEMrTh+nxLslEmWuoTS30o0etU/O6vmNrIWM0oFL+g03RcRL7lYkqlXHsAs6FLFlmFS8U9dOWM6XBkXxm+nU/ybmLRu2oGVbxvbUsUqO1Rl/30m7ENPznztBVMbEot1UK0tY+Jz+J9p7i/rtelqhO6qEujG2PXzgSZAejhF7zfwO6DGeCA6AG76jkK+jDUxpm7RMQN6i2+JUxO3tw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Nothing calls pipe_buf_try_steal() any more.  Remove ->try_steal() from
struct pipe_buf_operations, its implementations and the exported
generic_pipe_buf_try_steal().

PIPE_BUF_FLAG_LRU and PIPE_BUF_FLAG_GIFT were set only for stealing, and
go too.  page_cache_pipe_buf_release() did nothing but drop the page and
the LRU flag, so page cache and user page buffers use
generic_pipe_buf_release().

vmsplice() still accepts SPLICE_F_GIFT, and splice() SPLICE_F_MOVE.
Both were hints, and nothing acts on them now.

Suggested-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
---
 fs/pipe.c                 | 43 ------------------
 fs/splice.c               | 96 +++------------------------------------
 include/linux/pipe_fs_i.h | 36 ---------------
 kernel/watch_queue.c      |  4 --
 mm/shmem.c                |  7 ---
 5 files changed, 6 insertions(+), 180 deletions(-)

diff --git a/fs/pipe.c b/fs/pipe.c
index 4fa69192e6fb..4c1122597a3c 100644
--- a/fs/pipe.c
+++ b/fs/pipe.c
@@ -222,48 +222,6 @@ static void anon_pipe_buf_release(struct pipe_inode_info *pipe,
 	anon_pipe_put_page(pipe, page);
 }
 
-static bool anon_pipe_buf_try_steal(struct pipe_inode_info *pipe,
-		struct pipe_buffer *buf)
-{
-	struct page *page = buf->page;
-
-	if (page_count(page) != 1)
-		return false;
-	memcg_kmem_uncharge_page(page, 0);
-	__SetPageLocked(page);
-	return true;
-}
-
-/**
- * generic_pipe_buf_try_steal - attempt to take ownership of a &pipe_buffer
- * @pipe:	the pipe that the buffer belongs to
- * @buf:	the buffer to attempt to steal
- *
- * Description:
- *	This function attempts to steal the &struct page attached to
- *	@buf. If successful, this function returns 0 and returns with
- *	the page locked. The caller may then reuse the page for whatever
- *	he wishes; the typical use is insertion into a different file
- *	page cache.
- */
-bool generic_pipe_buf_try_steal(struct pipe_inode_info *pipe,
-		struct pipe_buffer *buf)
-{
-	struct page *page = buf->page;
-
-	/*
-	 * A reference of one is golden, that means that the owner of this
-	 * page is the only one holding a reference to it. lock the page
-	 * and return OK.
-	 */
-	if (page_count(page) == 1) {
-		lock_page(page);
-		return true;
-	}
-	return false;
-}
-EXPORT_SYMBOL(generic_pipe_buf_try_steal);
-
 /**
  * generic_pipe_buf_get - get a reference to a &struct pipe_buffer
  * @pipe:	the pipe that the buffer belongs to
@@ -297,7 +255,6 @@ EXPORT_SYMBOL(generic_pipe_buf_release);
 
 static const struct pipe_buf_operations anon_pipe_buf_ops = {
 	.release	= anon_pipe_buf_release,
-	.try_steal	= anon_pipe_buf_try_steal,
 	.get		= generic_pipe_buf_get,
 };
 
diff --git a/fs/splice.c b/fs/splice.c
index e6d43329ed3f..ba8f6f9aa3f0 100644
--- a/fs/splice.c
+++ b/fs/splice.c
@@ -55,63 +55,6 @@ static noinline void pipe_clear_nowait(struct file *file)
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
-static void page_cache_pipe_buf_release(struct pipe_inode_info *pipe,
-					struct pipe_buffer *buf)
-{
-	put_page(buf->page);
-	buf->flags &= ~PIPE_BUF_FLAG_LRU;
-}
-
 /*
  * Check whether the contents of buf is OK to access. Since the content
  * is a page cache page, IO may be in flight.
@@ -154,24 +97,12 @@ static int page_cache_pipe_buf_confirm(struct pipe_inode_info *pipe,
 
 const struct pipe_buf_operations page_cache_pipe_buf_ops = {
 	.confirm	= page_cache_pipe_buf_confirm,
-	.release	= page_cache_pipe_buf_release,
-	.try_steal	= page_cache_pipe_buf_try_steal,
+	.release	= generic_pipe_buf_release,
 	.get		= generic_pipe_buf_get,
 };
 
-static bool user_page_pipe_buf_try_steal(struct pipe_inode_info *pipe,
-		struct pipe_buffer *buf)
-{
-	if (!(buf->flags & PIPE_BUF_FLAG_GIFT))
-		return false;
-
-	buf->flags |= PIPE_BUF_FLAG_LRU;
-	return generic_pipe_buf_try_steal(pipe, buf);
-}
-
 static const struct pipe_buf_operations user_page_pipe_buf_ops = {
-	.release	= page_cache_pipe_buf_release,
-	.try_steal	= user_page_pipe_buf_try_steal,
+	.release	= generic_pipe_buf_release,
 	.get		= generic_pipe_buf_get,
 };
 
@@ -400,7 +331,6 @@ EXPORT_SYMBOL(copy_splice_read);
 
 const struct pipe_buf_operations default_pipe_buf_ops = {
 	.release	= generic_pipe_buf_release,
-	.try_steal	= generic_pipe_buf_try_steal,
 	.get		= generic_pipe_buf_get,
 };
 
@@ -1469,12 +1399,10 @@ static ssize_t __do_splice(struct file *in, loff_t __user *off_in,
 }
 
 static ssize_t iter_to_pipe(struct iov_iter *from,
-			    struct pipe_inode_info *pipe,
-			    unsigned int flags)
+			    struct pipe_inode_info *pipe)
 {
 	struct pipe_buffer buf = {
 		.ops = &user_page_pipe_buf_ops,
-		.flags = flags
 	};
 	size_t total = 0;
 	ssize_t ret = 0;
@@ -1564,10 +1492,6 @@ static ssize_t vmsplice_to_pipe(struct file *file, struct iov_iter *iter,
 {
 	struct pipe_inode_info *pipe;
 	ssize_t ret = 0;
-	unsigned buf_flag = 0;
-
-	if (flags & SPLICE_F_GIFT)
-		buf_flag = PIPE_BUF_FLAG_GIFT;
 
 	pipe = get_pipe_info(file, true);
 	if (!pipe)
@@ -1578,7 +1502,7 @@ static ssize_t vmsplice_to_pipe(struct file *file, struct iov_iter *iter,
 	pipe_lock(pipe);
 	ret = wait_for_space(pipe, flags);
 	if (!ret)
-		ret = iter_to_pipe(iter, pipe, buf_flag);
+		ret = iter_to_pipe(iter, pipe);
 	pipe_unlock(pipe);
 	if (ret > 0) {
 		wakeup_pipe_readers(pipe);
@@ -1839,11 +1763,7 @@ static int splice_pipe_to_pipe(struct pipe_inode_info *ipipe,
 			}
 			*obuf = *ibuf;
 
-			/*
-			 * Don't inherit the gift and merge flags, we need to
-			 * prevent multiple steals of this page.
-			 */
-			obuf->flags &= ~PIPE_BUF_FLAG_GIFT;
+			/* The page is shared with ipipe: don't append to it */
 			obuf->flags &= ~PIPE_BUF_FLAG_CAN_MERGE;
 
 			obuf->len = len;
@@ -1956,11 +1876,7 @@ static ssize_t link_pipe(struct pipe_inode_info *ipipe,
 
 		*obuf = *ibuf;
 
-		/*
-		 * Don't inherit the gift and merge flag, we need to prevent
-		 * multiple steals of this page.
-		 */
-		obuf->flags &= ~PIPE_BUF_FLAG_GIFT;
+		/* The page is shared with ipipe: don't append to it */
 		obuf->flags &= ~PIPE_BUF_FLAG_CAN_MERGE;
 
 		if (obuf->len > len)
diff --git a/include/linux/pipe_fs_i.h b/include/linux/pipe_fs_i.h
index 6402930282e5..fb6570e80d01 100644
--- a/include/linux/pipe_fs_i.h
+++ b/include/linux/pipe_fs_i.h
@@ -4,9 +4,7 @@
 
 #define PIPE_DEF_BUFFERS	16
 
-#define PIPE_BUF_FLAG_LRU	0x01	/* page is on the LRU */
 #define PIPE_BUF_FLAG_ATOMIC	0x02	/* was atomically mapped */
-#define PIPE_BUF_FLAG_GIFT	0x04	/* page is a gift */
 #define PIPE_BUF_FLAG_PACKET	0x08	/* read() as a packet */
 #define PIPE_BUF_FLAG_CAN_MERGE	0x10	/* can merge buffers */
 #define PIPE_BUF_FLAG_WHOLE	0x20	/* read() must return entire buffer or error */
@@ -127,16 +125,6 @@ struct pipe_inode_info {
 #endif
 };
 
-/*
- * Note on the nesting of these functions:
- *
- * ->confirm()
- *	->try_steal()
- *
- * That is, ->try_steal() must be called on a confirmed buffer.  See below for
- * the meaning of each operation.  Also see the kerneldoc in fs/pipe.c for the
- * pipe and generic variants of these hooks.
- */
 struct pipe_buf_operations {
 	/*
 	 * ->confirm() verifies that the data in the pipe buffer is there
@@ -153,16 +141,6 @@ struct pipe_buf_operations {
 	 */
 	void (*release)(struct pipe_inode_info *, struct pipe_buffer *);
 
-	/*
-	 * Attempt to take ownership of the pipe buffer and its contents.
-	 * ->try_steal() returns %true for success, in which case the contents
-	 * of the pipe (the buf->page) is locked and now completely owned by the
-	 * caller. The page may then be transferred to a different mapping, the
-	 * most often used case is insertion into different file address space
-	 * cache.
-	 */
-	bool (*try_steal)(struct pipe_inode_info *, struct pipe_buffer *);
-
 	/*
 	 * Get a reference to the pipe buffer.
 	 */
@@ -304,19 +282,6 @@ static inline int pipe_buf_confirm(struct pipe_inode_info *pipe,
 	return buf->ops->confirm(pipe, buf);
 }
 
-/**
- * pipe_buf_try_steal - attempt to take ownership of a pipe_buffer
- * @pipe:	the pipe that the buffer belongs to
- * @buf:	the buffer to attempt to steal
- */
-static inline bool pipe_buf_try_steal(struct pipe_inode_info *pipe,
-		struct pipe_buffer *buf)
-{
-	if (!buf->ops->try_steal)
-		return false;
-	return buf->ops->try_steal(pipe, buf);
-}
-
 /* Differs from PIPE_BUF in that PIPE_SIZE is the length of the actual
    memory allocation, whereas PIPE_BUF makes atomicity guarantees.  */
 #define PIPE_SIZE		PAGE_SIZE
@@ -335,7 +300,6 @@ void free_pipe_info(struct pipe_inode_info *);
 
 /* Generic pipe buffer ops functions */
 bool generic_pipe_buf_get(struct pipe_inode_info *, struct pipe_buffer *);
-bool generic_pipe_buf_try_steal(struct pipe_inode_info *, struct pipe_buffer *);
 void generic_pipe_buf_release(struct pipe_inode_info *, struct pipe_buffer *);
 
 extern const struct pipe_buf_operations nosteal_pipe_buf_ops;
diff --git a/kernel/watch_queue.c b/kernel/watch_queue.c
index 453dcf613205..e2bdd5fb0db1 100644
--- a/kernel/watch_queue.c
+++ b/kernel/watch_queue.c
@@ -77,13 +77,9 @@ static void watch_queue_pipe_buf_release(struct pipe_inode_info *pipe,
 	generic_pipe_buf_release(pipe, buf);
 }
 
-// No try_steal function => no stealing
-#define watch_queue_pipe_buf_try_steal NULL
-
 /* New data written to a pipe may be appended to a buffer with this type. */
 static const struct pipe_buf_operations watch_queue_pipe_buf_ops = {
 	.release	= watch_queue_pipe_buf_release,
-	.try_steal	= watch_queue_pipe_buf_try_steal,
 	.get		= generic_pipe_buf_get,
 };
 
diff --git a/mm/shmem.c b/mm/shmem.c
index af21a89abb0f..4a9440a1e1f8 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -3655,15 +3655,8 @@ static void zero_pipe_buf_release(struct pipe_inode_info *pipe,
 {
 }
 
-static bool zero_pipe_buf_try_steal(struct pipe_inode_info *pipe,
-				    struct pipe_buffer *buf)
-{
-	return false;
-}
-
 static const struct pipe_buf_operations zero_pipe_buf_ops = {
 	.release	= zero_pipe_buf_release,
-	.try_steal	= zero_pipe_buf_try_steal,
 	.get		= zero_pipe_buf_get,
 };
 
-- 
2.54.0



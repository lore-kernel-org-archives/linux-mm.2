Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AAA20606A88B
	for <linux-mm@archiver.kernel.org>; Wed, 11 Nov 2026 13:42:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=N1FWFgdc
Received: by kanga.kvack.org (Postfix)
	id 7E4436B05B1; Wed, 11 Nov 2026 08:42:56 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 76DA06B05B2; Wed, 11 Nov 2026 08:42:56 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6353D6B05B3; Wed, 11 Nov 2026 08:42:56 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 38E9E6B05B1
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 08:42:56 -0500 (EST)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id BDF0BC0299
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 13:42:55 +0000 (UTC)
X-FDA: 85422953910.18.A559FC9
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf03.hostedemail.com (Postfix) with ESMTP id 1683820006
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 13:42:53 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=N1FWFgdc;
	spf=pass (imf03.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794404574;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=r2uDapf2vLabhbDFIRRtIj4i5+V0KX58w12edhkpSZU=;
	b=b3LX11+WxmBtZTFNhibfhyzI0foStUkwyPnRIQX4pYxJntMXI03u1GXzbwHix9pvGJJ5I8
	scawCuEKjI5zfhR1r86SvvnpCkH0232seaFcUnrnYxNneCo09rUmYKKn5lfT0WZg8xxDRM
	Ceigryzq/pgu+NJep6A7sZhG/rEEf+w=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794404574;
	b=TJml7kjd0Mi1JkbOZoxgmOo2NLtFjO4sIKtSgeyQbv5CoTEa36cfn7Ck+X8fp7CDYxk0aP
	mq4S09u/SLvdq2YTZGCH/lIJo/uKjj3rZuTCW092wjuwXaYf9aLVHK9Ugz9PmiawiUFT6e
	U0uK6v2wzrsnQQ4kEgVyzoiagNrjmzs=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=N1FWFgdc;
	spf=pass (imf03.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 3C0FA4764C;
	Wed, 11 Nov 2026 13:42:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48B351F00A06;
	Wed, 11 Nov 2026 13:42:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794404573;
	bh=r2uDapf2vLabhbDFIRRtIj4i5+V0KX58w12edhkpSZU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=N1FWFgdc7n3FyJi4mWq7kE7aBBRtNzoz7OTcWnlRMydaapZ3nDIlCS4Okv1TVPC3m
	 JL6rQ4hb45pb3iD/dM5aW7LzXLL/qyYUni1xL1rlyF6YBcPpru6XkKZzzFwowC9Y6y
	 C7NiuCGH+vmHlWX+5tIej70Q1CIcqLl6FT43SjHcnbxrNC7mmiqAQmKBwWSoAD7GLd
	 ArJzKTz6tCYzM+6Y3ek8ew3nEUuf+jxXUBKm3e9gdsw66SDyb8OUIR83eD2WnwijaO
	 dPW/jiYjBeQgF5n7srNsN9thQlouIMfyRaahC/yQazXkj1+PCWlU+Bj+iM7D9axTAT
	 G3hqLCcrRvQ3g==
Date: Wed, 11 Nov 2026 14:42:44 +0100
From: Christian Brauner <brauner@kernel.org>
To: Matthew Wilcox <willy@infradead.org>, 
	Linus Torvalds <torvalds@linux-foundation.org>
Cc: "Kiryl Shutsemau (Meta)" <kas@kernel.org>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Miklos Szeredi <miklos@szeredi.hu>, Amit Shah <amit@kernel.org>, 
	Jan Kara <jack@suse.cz>, "David Hildenbrand (Arm)" <david@kernel.org>, 
	Zi Yan <ziy@nvidia.com>, Bernd Schubert <bschubert@ddn.com>, 
	Hugh Dickins <hughd@google.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Arnd Bergmann <arnd@arndb.de>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "David S. Miller" <davem@davemloft.net>, 
	Eric Dumazet <edumazet@kernel.org>, Jakub Kicinski <kuba@kernel.org>, 
	Paolo Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>, linux-fsdevel@vger.kernel.org, 
	fuse-devel@lists.linux.dev, virtualization@lists.linux.dev, netdev@vger.kernel.org, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, kernel-team@meta.com
Subject: Re: [PATCH 1/4] virtio_console: copy pipe buffers in splice_write()
Message-ID: <20261111-thunfisch-wirbt-waldrand-822275b2d3b1@brauner>
References: <20261110145241.536019-1-kas@kernel.org>
 <20261110145241.536019-2-kas@kernel.org>
 <avNuQqLf9CG9dSsE@casper.infradead.org>
 <20261111-heimreisen-ungeziefer-empfunden-a892571f2c07@brauner>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20261111-heimreisen-ungeziefer-empfunden-a892571f2c07@brauner>
X-Rspamd-Server: rspam06
X-Stat-Signature: inq78ucqdkyp5c3ud39wtwmnokihngrx
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 1683820006
X-Rspam-User: 
X-HE-Tag: 1794404573-916393
X-HE-Meta: U2FsdGVkX19S7NuGdfviDLiinCNDDjLi9kXYxyeRgno0qrjldaoGrdflEH+HBsSi9yAgehOTmL8/R8y3mvKMPMxCoOqG0r+/oQhw+3HR9MvS5t7dfGAVVsimiCFHWbHuFml87GlgtKGRIrMRUqvkNFPt0Dl8eyS3mMWHS3UydiCHhG31zqt4Gal4k5onrmDVTHWF4JROx6fJRula1khGLzsGQF0tZgr5PgZCzlY5xAtRgifV0ifJPR5MRSlURHJle1AHPk9c+jqfLxKZmCRuWfUcBV1n0HgJkSYuYAJvrk9+3HetFmLQPC+YCbAVMUNj81nv/7zDGBxTSIsNipSl03Y41IfWibdETXBqLBCTOF4wyVg9dDrLnQLXpkpwgddrpE6p3myYaoDlRpwTqZgsh5w5MBym7OznOoNDgGS0T3hZGkxE71R0pj65r1/WA+2brhlrgADgDKxwei4Jyr3PW1khpT2SM43hAQpAV12cbftGl4vEK6WIS29A7DEJ1wE435D9rwUR3ZUZzcAH5Ra+KNyx/ux2varJVseXvWxeneFhKVpjruO+UxNxQwoEuH0YsGywb892rijS1ctluzfC7gJIX5vjuQV3b3S+csTm9s0ETR4LZQog/PQvPK2qLm4V75SIUWCGROpLrboDRk5wMGDUWAfFylgT6s2/jTQiTkPusM6/4dmxXIrvq3K/J6e2wykMXprkeChIavM19r+kYJRLXD6XACM6jCSYwKk481jexEjmmVXDXPN/2KQ7VItotdTuihJrrsC3muqGXHvjkAM3u+hli4xgb5scPG/ltvqK8MkpbjJ+2/zx0u9Z4ssSH8nvZ9nI9Ds1KqoViPU50QKgxmP/5fJcZzEcrg9UhLS1AR/m4m4+lsAdjJYmediKB+kJmsLPmSkkYgZuyjgUN+jjD7eSbJK0FQMYwduhIRJETp619KOt4Fh63gOR/MGvF1+eUV+TbZwJoVhwpAT
 7twOKN7f
 NLE4Zyz9Bmipv3fJFjkZXO4EdXfIQTAfdVwWbQ/eOdRyFZsbr9MPgExJtupQ51XTvv7Omf7DHskbuIU6Z+ddEB7WCJtVrIn7grzqF6FMDkZFuw/Oacfb7EatcYVMwiRS5NupbDEwPn1l1Cc9LdYlrP6UIHMi30Gj5p09JMIiOn5NqRjB66I471uWO31cL7ejgeOv9DMIWSsSz0PGsE1HZ3a9ioCAj35xVY5s3ofN0WyooZvoZ35L/jNfX67LIMvtoHnHlllp5x+oqekYrbfKYlR7/Dko+7zKFnraoeJAC7DDapQdKbUQeg0YMmgmjEVjOMT+/PtJAARTF/3Ge+sJhAiDdmq79wt8r1GUE9Njh3FTyCTZI7hM4ASWcLdkL6keL6251aeJkIfL506W6iT1Pe7MvGsD/WwxZ9p3g
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, Nov 11, 2026 at 01:36:37PM +0100, Christian Brauner wrote:
> So we need to copy per page which would fix both.

So the fix below is what we've done before for pipes and I think it's
the right thing to do here too. I put the following on vfs.fixes:

-- >8 --
From: Christian Brauner <brauner@kernel.org>
Subject: [PATCH] virtio_console: copy pipe buffers that span multiple pages

pipe_to_sg() maps buf->page with kmap_local_page() and then copies up
to a page worth of data starting at buf->offset. But kmap_local_page()
only maps a single page and a pipe buffer can span multiple pages of a
compound page with buf->offset pointing past the first one:

- skb_splice_bits() for AF_UNIX and TCP sockets
- tracing_buffers_splice_read() with sub-buffers larger than a page
- fuse_dev_splice_read() which hands out the page cache folios of WRITE
  requests. Those can be large folios since b46e09667411 ("fuse: enable
  large folios").

Without HIGHMEM this happens to work because kmap_local_page() is just
page_address() and a compound page is contiguous in the direct map.
With HIGHMEM the copy reads past the mapping. A fuse server on a 32-bit
HIGHMEM guest that splices a WRITE request into a virtio port crashes:

  BUG: unable to handle page fault for address: fffab000
  #PF: supervisor read access in kernel mode
  #PF: error_code(0x0000) - not-present page
  Oops: Oops: 0000 [#1] SMP
  EIP: pipe_to_sg+0x158/0x1e0
  Call Trace:
   __splice_from_pipe+0xd6/0x1f0
   port_fops_splice_write+0xf9/0x170
   do_splice+0x2c1/0x810
   __ia32_sys_splice+0x2e7/0x310
   ia32_sys_call+0x1916/0x2510
   __do_fast_syscall_32+0xd4/0x550
   do_fast_syscall_32+0x32/0x70
   do_SYSENTER_32+0x15/0x20
   entry_SYSENTER_32+0xa6/0x115

pipe_read() had the same problem and 08aa64796016 ("teach
copy_page_to_iter() to handle compound pages") fixed it by mapping one
subpage at a time. So copy the buffer with copy_page_to_iter() as well.

Fixes: b46e09667411 ("fuse: enable large folios")
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 drivers/char/virtio_console.c | 15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

diff --git a/drivers/char/virtio_console.c b/drivers/char/virtio_console.c
index b1b1aaf43e07e..b93a31b81cf4e 100644
--- a/drivers/char/virtio_console.c
+++ b/drivers/char/virtio_console.c
@@ -12,6 +12,7 @@
 #include <linux/freezer.h>
 #include <linux/fs.h>
 #include <linux/splice.h>
+#include <linux/uio.h>
 #include <linux/pagemap.h>
 #include <linux/idr.h>
 #include <linux/init.h>
@@ -891,8 +892,9 @@ static int pipe_to_sg(struct pipe_inode_info *pipe, struct pipe_buffer *buf,
 {
 	struct sg_list *sgl = sd->u.data;
 	unsigned int offset, len;
+	struct iov_iter to;
 	struct page *page;
-	char *src;
+	struct kvec kv;
 
 	if (sgl->n == sgl->size)
 		return 0;
@@ -907,9 +909,14 @@ static int pipe_to_sg(struct pipe_inode_info *pipe, struct pipe_buffer *buf,
 	if (len + offset > PAGE_SIZE)
 		len = PAGE_SIZE - offset;
 
-	src = kmap_local_page(buf->page);
-	memcpy(page_address(page) + offset, src + buf->offset, len);
-	kunmap_local(src);
+	/* The buffer can span several pages of a compound page. */
+	kv.iov_base = page_address(page) + offset;
+	kv.iov_len = len;
+	iov_iter_kvec(&to, ITER_DEST, &kv, 1, len);
+	if (copy_page_to_iter(buf->page, buf->offset, len, &to) != len) {
+		__free_page(page);
+		return -EFAULT;
+	}
 
 	sg_set_page(&sgl->sg[sgl->n], page, len, offset);
 	sgl->n++;

-- 


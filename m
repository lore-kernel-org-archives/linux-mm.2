Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5D792D64085
	for <linux-mm@archiver.kernel.org>; Wed, 17 Dec 2025 07:33:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C07B06B00B7; Wed, 17 Dec 2025 02:33:35 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BB5006B00B9; Wed, 17 Dec 2025 02:33:35 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ABDD76B00BA; Wed, 17 Dec 2025 02:33:35 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 9444C6B00B7
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 02:33:35 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 54740160946
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 07:33:35 +0000 (UTC)
X-FDA: 84228147990.02.4DD2127
Received: from out-171.mta0.migadu.com (out-171.mta0.migadu.com [91.218.175.171])
	by imf30.hostedemail.com (Postfix) with ESMTP id 5A4C58000C
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 07:33:33 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=kJbEioJK;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf30.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.171 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765956813; a=rsa-sha256;
	cv=none;
	b=ujkr3yWZ2WPVVg9ImEV1V9ksyVwrHRtdULUm9Whfx3T9LCIXUXwufLneC1y6uk/2ZCBO+E
	nA8C7TKNOZmAhLcCNGp1hajhiaEJJzAVojDeo6gXGpGePuk0kCQlXTQUAx02XtLsRRFa1D
	0C+3XJgws5ZcA6iJcBQkMeRj1pT9sE0=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=kJbEioJK;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf30.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.171 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765956813;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ybjrAMMTox2gm0Mz0WWSv3dKHkz7INlbXp2y/b55EKc=;
	b=73kLS1zABRwwhGu867NJgUyVTSapdDGYo4ASCgHJiOiPTsBkf9tCi5qpXAfgnTdJLxsSGe
	+3JYYefauKEGJaTedjnSTd4JSfFoOx6qIa21T6RM35dT9LFsgmpROhWo+6IvP/f/8MOIC+
	rAmyWgurgXmf+QGh5lDLjY6QzoYDRgM=
Date: Tue, 16 Dec 2025 23:33:20 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1765956807;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ybjrAMMTox2gm0Mz0WWSv3dKHkz7INlbXp2y/b55EKc=;
	b=kJbEioJKtAXA6CzgPcHjUNrICvNmMFfoWW6bm+eUPd7eipsqQETPUXNiBWOtJXBYXk89K4
	xJVLMQqDLSBleuaZ/DvrY3vP2VkoFdLWgpPTWvBV6Y2JPvrQ8zD9d136V4lt3P/HugG3Fn
	bJBXRfI6+tn9iwsOM0GpjCrI00w7ioM=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc: Matthew Wilcox <willy@infradead.org>, 
	Linus Torvalds <torvalds@linux-foundation.org>, Christoph Hellwig <hch@infradead.org>, 
	"Darrick J. Wong" <djwong@kernel.org>, SHAURYA RANE <ssrane_b23@ee.vjti.ac.in>, 
	akpm@linux-foundation.org, eddyz87@gmail.com, andrii@kernel.org, ast@kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-kernel-mentees@lists.linux.dev, skhan@linuxfoundation.org, david.hunter.linux@gmail.com, 
	khalid@kernel.org, syzbot+09b7d050e4806540153d@syzkaller.appspotmail.com, 
	bpf <bpf@vger.kernel.org>
Subject: Re: [PATCH] mm/filemap: fix NULL pointer dereference in
 do_read_cache_folio()
Message-ID: <2mfkm3sotjz5tfw6wvtfrwnerae5pqspelyxw6xg6e5glsyaq6@jl73gcvmtve5>
References: <20251114193729.251892-1-ssranevjti@gmail.com>
 <aReUv1kVACh3UKv-@casper.infradead.org>
 <CANNWa07Y_GPKuYNQ0ncWHGa4KX91QFosz6WGJ9P6-AJQniD3zw@mail.gmail.com>
 <aRpQ7LTZDP-Xz-Sr@casper.infradead.org>
 <20251117164155.GB196362@frogsfrogsfrogs>
 <aRtjfN7sC6_Bv4bx@casper.infradead.org>
 <CAEf4BzZu+u-F9SjhcY5GN5vumOi6X=3AwUom+KJXeCpvC+-ppQ@mail.gmail.com>
 <aRxunCkc4VomEUdo@infradead.org>
 <aRySpQbNuw3Y5DN-@casper.infradead.org>
 <CAEf4BzY1fu+7pqotaW6DxH_vvwCY8rTuX=+0RO96-baKJDeB_Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAEf4BzY1fu+7pqotaW6DxH_vvwCY8rTuX=+0RO96-baKJDeB_Q@mail.gmail.com>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 5A4C58000C
X-Stat-Signature: dxrgerd373dd17s9jqzzrz96s8qdzqg7
X-Rspam-User: 
X-HE-Tag: 1765956813-920368
X-HE-Meta: U2FsdGVkX18KfOCugDs6pJBpwd9SKUusI8K0It64yGuCb1JoFOp1dTv8VyorYzmROzsErX9a+5Cyzo6jLpFoWmyYOKDI9ubg4psc0GcDuDNw1pUB0sRbn604CQAVS5bKGqbISAm/voYngl8kSQH0lhxtgnGMo3qE3YIxAs9Js6qyaiXlRtfVegI/KK7CLdl5Qf5T3cFQEZYlJTgZVMKV0zQX8tGDRRRZB7sroExePv1ktcYaea3ex052Z5U20mRXb5MyOxNLA8pMmkbRK4WUE69aiUJFb0TKKsWDeTMjGTQ2uAaJ+4171LUbcvGIhwf4XfKCVNHLC9Ap0f5ngrPmzV9ba54ub6rDp8BM9VbsqE9vuKhEL6uYhqVNUZcgggxeN57ntOdQo4rVPiwzYfbUd/9QvSxqGOet5BcJzJ+sc5t78VTD9ibhzzbINm1CU7Nvwqx9uMf8KpBzcvI0z5Q8qIAk1RYVo8D5bqqgcSdSxT0yPj+EOmmUYT0r9cpP0/hxhe8DdfnpBcabhqtlwqCekDtlAZr+pLCqzZTg9uXX7fNrAJbboAbYfxY0rpzhlJMe+b/o0uynWIdabGn+5OGKCYBBm9/SD8KzqUnTtxBwhSZ95D7VNHjsTe4F3K/Qjd64YSFrvhdGJ8Zb0TtbyWuRHFLvgrhMytf5T/lxSzaEnCg2xp/RY9iNsyXiw3AHKbM+OzWg3CHHKe3rftGvlfKUpiO/z5HMWcdq1rjPYNdxc4Rs7Vv0TrTddOg7Nm+dngXOnP1fJ9Tb+if5D6MtEHNW6jNcpx35ffXDNk3Rs6xX/KMzII7KAxu67IG6vRd/Jx3FryK0t/2mNGt+lXUWIiHFD5s3lUrYDjmcdhaLVEfI+kWEiWtbo7BGJpcHuT25ZOUhap0/vO0qnFI0zAW67/1GlQ3/UpcfTupclJUsy8JrC1jnG8+urZWLxG7d3xARV6QQrw/Q7OXNtOWetVMn2t/
 MgV69Kvk
 NPfJvcdwGTewIceHyaDqMiqBJR6Yp22O2jEM6Lip0cJ6RgfZGJiVZig4phZAgqpj+dUcgCM06KpGClaCYyTzeNCEoPhAmy2Uc2klp5d+7Yn0n2mEFxbL3P8qe02/kEqESNAcT+PBY9oC5aFNA0pkEPsUvTY6YF8yei/nsMYj6YTEKnNy8BK4Mgn7knR1GqKyQYAMY0klemYSX6i4wZoWdyAA2LlIRvhoydN4Jy7yUaieL2FOtB7YeevhRTV/KRJ2UaV1rYD/aLwH31vXr2cr9FjxP/nqhvzFWOxKmMWDVcMtnxGfhx2HUia976hMKM2mlbKQWAczv/nIElsJ0SsjQmcqkgFZvAd5nm9J0onL2edUuJfyV5bOwy+24IRDHXCiPs5/LgqYIJs0orPo9s6UcDS6mSFMcnV3pc34QJMldAn51UizrBb8RpoEwpjpS/njuYJUbVQZYWXA+Mx9Qflmplfmy4aWwIAHlANoD
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Nov 18, 2025 at 11:27:47AM -0800, Andrii Nakryiko wrote:
> On Tue, Nov 18, 2025 at 7:37 AM Matthew Wilcox <willy@infradead.org> wrote:
> >
> > On Tue, Nov 18, 2025 at 05:03:24AM -0800, Christoph Hellwig wrote:
> > > On Mon, Nov 17, 2025 at 10:45:31AM -0800, Andrii Nakryiko wrote:
> > > > As I replied on another email, ideally we'd have some low-level file
> > > > reading interface where we wouldn't have to know about secretmem, or
> > > > XFS+DAX, or whatever other unusual combination of conditions where
> > > > exposed internal APIs like filemap_get_folio() + read_cache_folio()
> > > > can crash.
> > >
> > > The problem is that you did something totally insane and it kinda works
> > > most of the time.
> >
> > ... on 64-bit systems.  The HIGHMEM handling is screwed up too.
> >
> > > But bpf or any other file system consumer has
> > > absolutely not business poking into the page cache to start with.
> >
> > Agreed.
> 
> Then please help make it better, give us interfaces you think are
> appropriate. People do use this functionality in production, it's
> important and we are not going to drop it. In non-sleepable mode it's
> best-effort, if the requested part of the file is paged in, we'll
> successfully read data (such as ELF's build ID), and if not, we'll
> report that to the BPF program as -EFAULT. In sleepable mode, we'll
> wait for that part of the file to be paged in before proceeding.
> PROCMAP_QUERY ioctl() is always in sleepable mode, so it will wait for
> file data to be read.
> 
> If you don't like the implementation, please help improve it, don't
> just request dropping it "because BPF folks" or anything like that.
> 

So, I took a stab at this, particularly based on Willy's suggestions on
IOCB_NOWAIT. This is untested and I am just sharing to show how it looks
like and if there are any concerns. In addition I think I will look into
fstest part as well.

BTW by simple code inspection I already see that IOCB_NOWAIT is not well
respected. For example filemap_read() is doing cond_resched() without
any checks. The readahead i.e. page_cache_sync_ra() can potential take
sleeping locks. Btrfs is taking locks in btrfs_file_read_iter. So, it
seems like this would need extensive testing hopefully for all major
FSes.

Here the draft patch:


From 9652cc97a817fe35e53a7e98a5fbb49c7788c744 Mon Sep 17 00:00:00 2001
From: Shakeel Butt <shakeel.butt@linux.dev>
Date: Tue, 16 Dec 2025 16:53:57 -0800
Subject: [PATCH] lib/buildid: convert freader to use __kernel_read()

Convert the freader file reading implementation from direct page cache
access via filemap_get_folio()/read_cache_folio() to using kernel_read
interfaces.

Add a new __kernel_read_nowait() function that uses IOCB_NOWAIT flag
for non-blocking I/O. This is used when may_fault is false to avoid
blocking on I/O - if data is not immediately available, it returns
-EAGAIN.

For the may_fault case, use the standard __kernel_read() which can
block waiting for I/O.

This simplifies the code by removing the need to manage folios,
kmap/kunmap operations, and page cache locking. It also makes the
code work with filesystems that don't use the page cache directly.

Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
---
 fs/read_write.c         | 18 ++++++++-
 include/linux/buildid.h |  3 --
 include/linux/fs.h      |  1 +
 lib/buildid.c           | 85 +++++++++--------------------------------
 4 files changed, 37 insertions(+), 70 deletions(-)

diff --git a/fs/read_write.c b/fs/read_write.c
index 833bae068770..7a042cfeefec 100644
--- a/fs/read_write.c
+++ b/fs/read_write.c
@@ -503,7 +503,8 @@ static int warn_unsupported(struct file *file, const char *op)
 	return -EINVAL;
 }
 
-ssize_t __kernel_read(struct file *file, void *buf, size_t count, loff_t *pos)
+static ssize_t __kernel_read_internal(struct file *file, void *buf,
+			size_t count, loff_t *pos, int flags)
 {
 	struct kvec iov = {
 		.iov_base	= buf,
@@ -526,6 +527,7 @@ ssize_t __kernel_read(struct file *file, void *buf, size_t count, loff_t *pos)
 
 	init_sync_kiocb(&kiocb, file);
 	kiocb.ki_pos = pos ? *pos : 0;
+	kiocb.ki_flags |= flags;
 	iov_iter_kvec(&iter, ITER_DEST, &iov, 1, iov.iov_len);
 	ret = file->f_op->read_iter(&kiocb, &iter);
 	if (ret > 0) {
@@ -538,6 +540,20 @@ ssize_t __kernel_read(struct file *file, void *buf, size_t count, loff_t *pos)
 	return ret;
 }
 
+ssize_t __kernel_read(struct file *file, void *buf, size_t count, loff_t *pos)
+{
+	return __kernel_read_internal(file, buf, count, pos, 0);
+}
+
+/*
+ * Non-blocking variant of __kernel_read() using IOCB_NOWAIT.
+ * Returns -EAGAIN if the read would block waiting for I/O.
+ */
+ssize_t __kernel_read_nowait(struct file *file, void *buf, size_t count, loff_t *pos)
+{
+	return __kernel_read_internal(file, buf, count, pos, IOCB_NOWAIT);
+}
+
 ssize_t kernel_read(struct file *file, void *buf, size_t count, loff_t *pos)
 {
 	ssize_t ret;
diff --git a/include/linux/buildid.h b/include/linux/buildid.h
index 831c1b4b626c..f1fa220353a2 100644
--- a/include/linux/buildid.h
+++ b/include/linux/buildid.h
@@ -25,9 +25,6 @@ struct freader {
 	union {
 		struct {
 			struct file *file;
-			struct folio *folio;
-			void *addr;
-			loff_t folio_off;
 			bool may_fault;
 		};
 		struct {
diff --git a/include/linux/fs.h b/include/linux/fs.h
index f5c9cf28c4dc..498c804fc0b9 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -2832,6 +2832,7 @@ extern int do_pipe_flags(int *, int);
 
 extern ssize_t kernel_read(struct file *, void *, size_t, loff_t *);
 ssize_t __kernel_read(struct file *file, void *buf, size_t count, loff_t *pos);
+ssize_t __kernel_read_nowait(struct file *file, void *buf, size_t count, loff_t *pos);
 extern ssize_t kernel_write(struct file *, const void *, size_t, loff_t *);
 extern ssize_t __kernel_write(struct file *, const void *, size_t, loff_t *);
 extern struct file * open_exec(const char *);
diff --git a/lib/buildid.c b/lib/buildid.c
index aaf61dfc0919..c9d4491557fe 100644
--- a/lib/buildid.c
+++ b/lib/buildid.c
@@ -5,6 +5,7 @@
 #include <linux/elf.h>
 #include <linux/kernel.h>
 #include <linux/pagemap.h>
+#include <linux/fs.h>
 #include <linux/secretmem.h>
 
 #define BUILD_ID 3
@@ -28,55 +29,35 @@ void freader_init_from_mem(struct freader *r, const char *data, u64 data_sz)
 	r->data_sz = data_sz;
 }
 
-static void freader_put_folio(struct freader *r)
-{
-	if (!r->folio)
-		return;
-	kunmap_local(r->addr);
-	folio_put(r->folio);
-	r->folio = NULL;
-}
-
-static int freader_get_folio(struct freader *r, loff_t file_off)
+/*
+ * Read data from file at specified offset into the freader buffer.
+ * Uses non-blocking I/O when may_fault is false.
+ * Returns 0 on success, negative error code on failure.
+ */
+static int freader_read(struct freader *r, loff_t file_off, size_t sz)
 {
-	/* check if we can just reuse current folio */
-	if (r->folio && file_off >= r->folio_off &&
-	    file_off < r->folio_off + folio_size(r->folio))
-		return 0;
-
-	freader_put_folio(r);
+	ssize_t ret;
+	loff_t pos = file_off;
 
 	/* reject secretmem folios created with memfd_secret() */
 	if (secretmem_mapping(r->file->f_mapping))
 		return -EFAULT;
 
-	r->folio = filemap_get_folio(r->file->f_mapping, file_off >> PAGE_SHIFT);
-
-	/* if sleeping is allowed, wait for the page, if necessary */
-	if (r->may_fault && (IS_ERR(r->folio) || !folio_test_uptodate(r->folio))) {
-		filemap_invalidate_lock_shared(r->file->f_mapping);
-		r->folio = read_cache_folio(r->file->f_mapping, file_off >> PAGE_SHIFT,
-					    NULL, r->file);
-		filemap_invalidate_unlock_shared(r->file->f_mapping);
-	}
+	if (r->may_fault)
+		ret = __kernel_read(r->file, r->buf, sz, &pos);
+	else
+		ret = __kernel_read_nowait(r->file, r->buf, sz, &pos);
 
-	if (IS_ERR(r->folio) || !folio_test_uptodate(r->folio)) {
-		if (!IS_ERR(r->folio))
-			folio_put(r->folio);
-		r->folio = NULL;
+	if (ret < 0)
+		return ret;
+	if (ret != sz)
 		return -EFAULT;
-	}
-
-	r->folio_off = folio_pos(r->folio);
-	r->addr = kmap_local_folio(r->folio, 0);
 
 	return 0;
 }
 
 const void *freader_fetch(struct freader *r, loff_t file_off, size_t sz)
 {
-	size_t folio_sz;
-
 	/* provided internal temporary buffer should be sized correctly */
 	if (WARN_ON(r->buf && sz > r->buf_sz)) {
 		r->err = -E2BIG;
@@ -97,46 +78,18 @@ const void *freader_fetch(struct freader *r, loff_t file_off, size_t sz)
 		return r->data + file_off;
 	}
 
-	/* fetch or reuse folio for given file offset */
-	r->err = freader_get_folio(r, file_off);
+	/* read data from file into buffer */
+	r->err = freader_read(r, file_off, sz);
 	if (r->err)
 		return NULL;
 
-	/* if requested data is crossing folio boundaries, we have to copy
-	 * everything into our local buffer to keep a simple linear memory
-	 * access interface
-	 */
-	folio_sz = folio_size(r->folio);
-	if (file_off + sz > r->folio_off + folio_sz) {
-		u64 part_sz = r->folio_off + folio_sz - file_off, off;
-
-		memcpy(r->buf, r->addr + file_off - r->folio_off, part_sz);
-		off = part_sz;
-
-		while (off < sz) {
-			/* fetch next folio */
-			r->err = freader_get_folio(r, r->folio_off + folio_sz);
-			if (r->err)
-				return NULL;
-			folio_sz = folio_size(r->folio);
-			part_sz = min_t(u64, sz - off, folio_sz);
-			memcpy(r->buf + off, r->addr, part_sz);
-			off += part_sz;
-		}
-
-		return r->buf;
-	}
-
-	/* if data fits in a single folio, just return direct pointer */
-	return r->addr + (file_off - r->folio_off);
+	return r->buf;
 }
 
 void freader_cleanup(struct freader *r)
 {
 	if (!r->buf)
 		return; /* non-file-backed mode */
-
-	freader_put_folio(r);
 }
 
 /*
-- 
2.47.3



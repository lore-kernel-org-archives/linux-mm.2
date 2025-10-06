Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E498ACAC5B8
	for <linux-mm@archiver.kernel.org>; Mon,  6 Oct 2025 11:45:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 330368E0006; Mon,  6 Oct 2025 07:45:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 307FE8E0002; Mon,  6 Oct 2025 07:45:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 21DB18E0006; Mon,  6 Oct 2025 07:45:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 10FAE8E0002
	for <linux-mm@kvack.org>; Mon,  6 Oct 2025 07:45:07 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 6BABBBA09B
	for <linux-mm@kvack.org>; Mon,  6 Oct 2025 11:45:06 +0000 (UTC)
X-FDA: 83967508212.25.E2F0D09
Received: from fhigh-a4-smtp.messagingengine.com (fhigh-a4-smtp.messagingengine.com [103.168.172.155])
	by imf23.hostedemail.com (Postfix) with ESMTP id 4952514000B
	for <linux-mm@kvack.org>; Mon,  6 Oct 2025 11:45:04 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm3 header.b="M XKOjOL";
	dkim=pass header.d=messagingengine.com header.s=fm2 header.b=OPT1V0fd;
	spf=pass (imf23.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.155 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759751104;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HjqEAAukTgzfOHeJKHDdRAAY+8Vu3pAM3H7CL2nOoeI=;
	b=xlnQNJmtT2fA4Dqwxmhk7d0Ijq2e13VqimW3/Xvx6GDc0msH60QLnSAK+k3EjGKG7oZ76I
	9+lNvE0ItX7gqIKkJE8E512kE4BxwXrdiWHYO1epoJ598VTyQpl9+/JFhn2c4Hz7YWan56
	0xEpoU7VMIqjMKSyifR/dNasX1D1lCY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759751104; a=rsa-sha256;
	cv=none;
	b=ePyNnQ/8LyEmvnq4HEvNrGwF1xIVWZrbd8Br+VgXXr2fFi2dPnsQPNQpWrm1k/Oww2t53C
	TMXH6rJa434MgfDQ5ZEOVIAlpCUlM8IXLve6C3qsuSTLUFIgHMgJl9XoWAe25Xyvg75ty5
	LvQUOY0kVNx16ay/XqN6FQ5T2G/81k0=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm3 header.b="M XKOjOL";
	dkim=pass header.d=messagingengine.com header.s=fm2 header.b=OPT1V0fd;
	spf=pass (imf23.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.155 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
Received: from phl-compute-11.internal (phl-compute-11.internal [10.202.2.51])
	by mailfhigh.phl.internal (Postfix) with ESMTP id 7F59414000B7;
	Mon,  6 Oct 2025 07:45:03 -0400 (EDT)
Received: from phl-mailfrontend-02 ([10.202.2.163])
  by phl-compute-11.internal (MEProxy); Mon, 06 Oct 2025 07:45:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-type:content-type:date:date:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm3; t=1759751103; x=
	1759837503; bh=HjqEAAukTgzfOHeJKHDdRAAY+8Vu3pAM3H7CL2nOoeI=; b=M
	XKOjOLhmgf2LnK44hgEMW8QcIjoh9davzquDZHeKPKgpHtmrbSnOHdrqoxDV/cC5
	ABHMLYgzAQPh1+b4wGuPB2koo69Bs+NbUgYU770mmTeUwPyulZz+i2S+Q9mwvxJQ
	wz7QnSL0MA4uXgzbTW9dtZx/6A6C4dekxcyh6XoWkLW+etIQvfmhD9gEY/ObffGx
	GtlcqpnVFuEb+mT5SOQn5MByl0GGxjOuoe6XSzbsBB8TX6rnQNyfj40Ynv3S/p39
	2jHD+fHJPDNgyjrgPCdAZPKnjjfFq93xYW3bm04q0/eWq1fK4kYaZH3G2eUGJ2Tm
	suhjhGv5Z7YimdzEBkSiQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; t=
	1759751103; x=1759837503; bh=HjqEAAukTgzfOHeJKHDdRAAY+8Vu3pAM3H7
	CL2nOoeI=; b=OPT1V0fdLufgqRUk1MBEuWqeTB2fkPeyTQ52GpyFyU5LKgby24H
	2vJY7+Mz+2d+zn7SzP+GJjC4r/AqpF/b319yATcMd2ZSB5uZYSBd6NT3TWTsepTp
	IOVd8JNF4ex3XdNMSA+QpNVyehRgHHBg+5QJGN4UZUX55f75/GXc3fG9NBz1p78g
	DrdYiZ7ZXl9mwPnJYeCVdDCozoELaDn1F1FkBp61TfIXQi0H8dTp1OBownHXrXks
	HoKuSNDuS0UKwHYkyT8xYAeIze1s7UIa6bNHmhwIO/KitOdvOIoAgXyH+6kCpOC9
	dLO2IOtJyu/YUzJtBe9wlLRxHXfE1GC+2sQ==
X-ME-Sender: <xms:vqvjaKNSJbfSKpov_G6G0H4DfcvV8zOj_h2PIm6_o_kraWDtGLniaQ>
    <xme:vqvjaMCi2zvGFfp7Frhp9RrJ8p1FEnvAW_0T4jjAzlhK8D-5PpZ9ywvn3GuwpO75b
    VUDeW0Qzn7y5pbF-VrNhIZ6mTEGpKMHoLp7eMuC8NW2OOSzOrSPbqI>
X-ME-Received: <xmr:vqvjaL6j2rU_yo_zJNTgczcTewGdWWjLCTrQVnOn2BVL73XnKhwNdREF0tbDBw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeeffedrtdeggdeljeegiecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpuffrtefokffrpgfnqfghnecuuegr
    ihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenucfjug
    hrpeffhffvvefukfhfgggtuggjsehttdfstddttddvnecuhfhrohhmpefmihhrhihlucfu
    hhhuthhsvghmrghuuceokhhirhhilhhlsehshhhuthgvmhhovhdrnhgrmhgvqeenucggtf
    frrghtthgvrhhnpeejheeufeduvdfgjeekiedvjedvgeejgfefieetveffhfdtvddtledu
    hfeffeffudenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhroh
    hmpehkihhrihhllhesshhhuhhtvghmohhvrdhnrghmvgdpnhgspghrtghpthhtohepuddt
    pdhmohguvgepshhmthhpohhuthdprhgtphhtthhopehtohhrvhgrlhgusheslhhinhhugi
    dqfhhouhhnuggrthhiohhnrdhorhhgpdhrtghpthhtohepfihilhhlhiesihhnfhhrrggu
    vggrugdrohhrghdprhgtphhtthhopehmtghgrhhofheskhgvrhhnvghlrdhorhhgpdhrtg
    hpthhtoheplhhinhhugidqmhhmsehkvhgrtghkrdhorhhgpdhrtghpthhtoheplhhinhhu
    gidqfhhsuggvvhgvlhesvhhgvghrrdhkvghrnhgvlhdrohhrgh
X-ME-Proxy: <xmx:v6vjaG7jXm1GsW0jvpVHuC1o6oTXB9UWFX_XdxVJiJNAa57UAUW1iw>
    <xmx:v6vjaNQS5HIzmlX0E-LJ0j3ln7s11CHdhrQBlvwSMHWsZV0SSR7oyQ>
    <xmx:v6vjaO-M6MnNIKrP1wGQUIwcgDLhQBJEiD0vSANfYKfHrYBFsbkQ7g>
    <xmx:v6vjaOZ9cZ5PXKYI4VSouKLFqrqpWsCDWWo9xB7rCTCosS2E59h1yQ>
    <xmx:v6vjaPyiyO-m4ZzxGIf5bxczMOjchUSB_v6gHA3oqywItLxZcI9vv-PT>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 6 Oct 2025 07:45:02 -0400 (EDT)
Date: Mon, 6 Oct 2025 12:44:59 +0100
From: Kiryl Shutsemau <kirill@shutemov.name>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Matthew Wilcox <willy@infradead.org>, 
	Luis Chamberlain <mcgrof@kernel.org>, Linux-MM <linux-mm@kvack.org>, linux-fsdevel@vger.kernel.org
Subject: Re: Optimizing small reads
Message-ID: <4bjh23pk56gtnhutt4i46magq74zx3nlkuo4ym2tkn54rv4gjl@rhxb6t6ncewp>
References: <CAHk-=wj00-nGmXEkxY=-=Z_qP6kiGUziSFvxHJ9N-cLWry5zpA@mail.gmail.com>
 <flg637pjmcnxqpgmsgo5yvikwznak2rl4il2srddcui2564br5@zmpwmxibahw2>
 <CAHk-=wgy=oOSu+A3cMfVhBK66zdFsstDV3cgVO-=RF4cJ2bZ+A@mail.gmail.com>
 <CAHk-=whThZaXqDdum21SEWXjKQXmBcFN8E5zStX8W-EMEhAFdQ@mail.gmail.com>
 <a3nryktlvr6raisphhw56mdkvff6zr5athu2bsyiotrtkjchf3@z6rdwygtybft>
 <CAHk-=wg-eq7s8UMogFCS8OJQt9hwajwKP6kzW88avbx+4JXhcA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHk-=wg-eq7s8UMogFCS8OJQt9hwajwKP6kzW88avbx+4JXhcA@mail.gmail.com>
X-Rspamd-Queue-Id: 4952514000B
X-Stat-Signature: fuy3j7eb6j9i38s3iknx473u3qcm3oc5
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1759751104-633030
X-HE-Meta: U2FsdGVkX19B0oaRYDt6Pbompc/om2V79A/ESdqZjh0EYhxs/ofH+ICd8qu7Rfqpbud11+KNuHhsCEV7Z8oElZEkaP9ipfSyUFnGD1wwQ/ePJr/KbuUMHyNmy3cN531vR4qKZvvlufWXstiw0ECBbrPfXVzIitaJYPNEX3hhMk+01Pc4sFbQMo97SCKxGzeeqa+HeezCufghl7bvJ0evi14C2w8S3YkQWg8PTIr/fYJTAxLDVySH8krTyJyTR4uCHawN7AQyO2almj+cbClICmNx4BznmyXV3C3Iy33TAqwSAm6Ibwp/IMENDG4ERuwU+q2qrBfPoMRHCXw2mOvj8VRMQriCRp0Y70ZtaWUz08W3+V+Pg4lZn6UeTZI6zm3TpZQ/u21U1G0361sV1tTMxrhwUANpWjjM0w3R2pH1tgNCvjCfFHdDrqUUVeGLhpoQqVrSssKtgc+gtPjHRxI3vsfXzpCT0bwVbfdOJba8XIPHKK9CX4a41xUd5u+I1zYwL5F8vycPfe+13iA2mxcK3nTP1HfFJlZ5sy4R29quGJYIwmNQHIoDxbaiRZ+o1YxFrlgYsXUBLOMI9w2ogJp5PanX/eSdn3jBdwR4ykBsZIOuQ/EHX3XDeu34OBnF+cbeAhYjsUckjRqOA+QTR5yhJeu1c1+L3l6HHYRr3K2sjSH0tdTebX6+80asRDcim2tOXMN36Heka4M51vmNn9c7nw3OBPfJULUB0sjHMFNmAMuZncEn5v9DIQvE/Si6qWZVC6TEy64MNFYEYcexd2SXA3XxwJEl0U4AZIpmuXecGxiiUucB0baRPQm5dQBpKapA6Pw37NewqdGFqC9ISjn8WZKmnDwl0wWAiuj1AjkYnoIdknr4c3UinJNlutE9dGleotmmYKKMXkey1hj/DGSLUoZcZXN5NTy0CLAb7JNVmgRebCMCO+8sPT75PoN008C2hUINACJpuEWf1bMGXov
 crqKNY4g
 TfDGVTXTekh+jZ4ZNno0YzuYU1TUGTiyMMkA623Z6SgzRk9LGudBLkYusF/qcBKhJGcXqVrvY2GurJu5ObolNwt6tIITuVGvWeVM2hqnd7fFsij8nezBluBJ8wGTkXVvp6gnprpTnxNv6f/NA33d2rlGBaXvzphLJVE3bQaBHFBikz08OoYE2kOg2Aqx2n0oHAvPQr4EmLq7ai/t2FDHIA66sWVPg8UmmNA/ICstgvYulj+CXqWOBuJsBqI7dsRNx14uoll+DaaFDBfbARbQcOKMwaW3iARXoOIYvVcZ8PSbrAp0P6ziQnplHmahJT4r7JXERPGwF7ovDWgkm78Ry+MhnL5yUt321jTqRNiFgEbMI1TY=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Oct 03, 2025 at 10:49:36AM -0700, Linus Torvalds wrote:
> I'd love it if somebody took a look. I'm definitely not going to spend
> any more time on this during the merge window...

Below is my take on this. Lightly tested.

Some notes:

 - Do we want a bounded retry on read_seqcount_retry()?
   Maybe upto 3 iterations?

 - HIGHMEM support is trivial with memcpy_from_file_folio();

 - I opted for late partial read check. It would be nice allow to read
   across PAGE_SIZE boundary as long as it is in the same folio;

 - Move i_size check after uptodate check. It seems to be required
   according to the comment in filemap_read(). But I cannot say I
   understand i_size implications here.

 - Size of area is 256 bytes. I wounder if we want to get the fast read
   to work on full page chunks. Can we dedicate a page per CPU for this?
   I expect it to cover substantially more cases.

Any comments are welcome.

diff --git a/fs/inode.c b/fs/inode.c
index ec9339024ac3..52163d28d630 100644
--- a/fs/inode.c
+++ b/fs/inode.c
@@ -482,6 +482,8 @@ EXPORT_SYMBOL(inc_nlink);
 static void __address_space_init_once(struct address_space *mapping)
 {
 	xa_init_flags(&mapping->i_pages, XA_FLAGS_LOCK_IRQ | XA_FLAGS_ACCOUNT);
+	seqcount_spinlock_init(&mapping->i_pages_delete_seqcnt,
+			       &mapping->i_pages->xa_lock);
 	init_rwsem(&mapping->i_mmap_rwsem);
 	INIT_LIST_HEAD(&mapping->i_private_list);
 	spin_lock_init(&mapping->i_private_lock);
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 9e9d7c757efe..a900214f0f3a 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -522,6 +522,7 @@ struct address_space {
 	struct list_head	i_private_list;
 	struct rw_semaphore	i_mmap_rwsem;
 	void *			i_private_data;
+	seqcount_spinlock_t	i_pages_delete_seqcnt;
 } __attribute__((aligned(sizeof(long)))) __randomize_layout;
 	/*
 	 * On most architectures that alignment is already the case; but
diff --git a/mm/filemap.c b/mm/filemap.c
index 751838ef05e5..fc26c6826392 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -138,8 +138,10 @@ static void page_cache_delete(struct address_space *mapping,
 
 	VM_BUG_ON_FOLIO(!folio_test_locked(folio), folio);
 
+	write_seqcount_begin(&mapping->i_pages_delete_seqcnt);
 	xas_store(&xas, shadow);
 	xas_init_marks(&xas);
+	write_seqcount_end(&mapping->i_pages_delete_seqcnt);
 
 	folio->mapping = NULL;
 	/* Leave folio->index set: truncation lookup relies upon it */
@@ -2659,6 +2661,57 @@ static void filemap_end_dropbehind_read(struct folio *folio)
 	}
 }
 
+static inline unsigned long filemap_fast_read(struct address_space *mapping,
+					      loff_t pos, char *buffer,
+					      size_t size)
+{
+	XA_STATE(xas, &mapping->i_pages, pos >> PAGE_SHIFT);
+	struct folio *folio;
+	loff_t file_size;
+	unsigned int seq;
+
+	lockdep_assert_in_rcu_read_lock();
+
+	seq = read_seqcount_begin(&mapping->i_pages_delete_seqcnt);
+
+	xas_reset(&xas);
+	folio = xas_load(&xas);
+	if (xas_retry(&xas, folio))
+		return 0;
+
+	if (!folio || xa_is_value(folio))
+		return 0;
+
+	if (!folio_test_uptodate(folio))
+		return 0;
+
+	/* No fast-case if readahead is supposed to started */
+	if (folio_test_readahead(folio))
+		return 0;
+	/* .. or mark it accessed */
+	if (!folio_test_referenced(folio))
+		return 0;
+
+	/* i_size check must be after folio_test_uptodate() */
+	file_size = i_size_read(mapping->host);
+	if (unlikely(pos >= file_size))
+		return 0;
+	if (size > file_size - pos)
+		size = file_size - pos;
+
+	/* Do the data copy */
+	if (memcpy_from_file_folio(buffer, folio, pos, size) != size) {
+		/* No partial reads */
+		return 0;
+	}
+
+	/* Give up and go to slow path if raced with page_cache_delete() */
+	if (read_seqcount_retry(&mapping->i_pages_delete_seqcnt, seq))
+		return 0;
+
+	return size;
+}
+
 /**
  * filemap_read - Read data from the page cache.
  * @iocb: The iocb to read.
@@ -2679,7 +2732,10 @@ ssize_t filemap_read(struct kiocb *iocb, struct iov_iter *iter,
 	struct file_ra_state *ra = &filp->f_ra;
 	struct address_space *mapping = filp->f_mapping;
 	struct inode *inode = mapping->host;
-	struct folio_batch fbatch;
+	union {
+		struct folio_batch fbatch;
+		__DECLARE_FLEX_ARRAY(char, buffer);
+	} area __uninitialized;
 	int i, error = 0;
 	bool writably_mapped;
 	loff_t isize, end_offset;
@@ -2693,7 +2749,34 @@ ssize_t filemap_read(struct kiocb *iocb, struct iov_iter *iter,
 		return 0;
 
 	iov_iter_truncate(iter, inode->i_sb->s_maxbytes - iocb->ki_pos);
-	folio_batch_init(&fbatch);
+
+	/*
+	 * Try a quick lockless read into the 'area' union. Note that
+	 * this union is intentionally marked "__uninitialized", because
+	 * any compiler initialization would be pointless since this
+	 * can fill it will garbage.
+	 */
+	if (iov_iter_count(iter) <= sizeof(area)) {
+		size_t count = iov_iter_count(iter);
+
+		/* Let's see if we can just do the read under RCU */
+		rcu_read_lock();
+		count = filemap_fast_read(mapping, iocb->ki_pos, area.buffer, count);
+		rcu_read_unlock();
+		if (count) {
+			size_t copied = copy_to_iter(area.buffer, count, iter);
+			if (unlikely(!copied))
+				return already_read ? already_read : -EFAULT;
+			ra->prev_pos = iocb->ki_pos += copied;
+			file_accessed(filp);
+			return copied + already_read;
+		}
+	}
+
+	/*
+	 * This actually properly initializes the fbatch for the slow case
+	 */
+	folio_batch_init(&area.fbatch);
 
 	do {
 		cond_resched();
@@ -2709,7 +2792,7 @@ ssize_t filemap_read(struct kiocb *iocb, struct iov_iter *iter,
 		if (unlikely(iocb->ki_pos >= i_size_read(inode)))
 			break;
 
-		error = filemap_get_pages(iocb, iter->count, &fbatch, false);
+		error = filemap_get_pages(iocb, iter->count, &area.fbatch, false);
 		if (error < 0)
 			break;
 
@@ -2737,11 +2820,11 @@ ssize_t filemap_read(struct kiocb *iocb, struct iov_iter *iter,
 		 * mark it as accessed the first time.
 		 */
 		if (!pos_same_folio(iocb->ki_pos, last_pos - 1,
-				    fbatch.folios[0]))
-			folio_mark_accessed(fbatch.folios[0]);
+				    area.fbatch.folios[0]))
+			folio_mark_accessed(area.fbatch.folios[0]);
 
-		for (i = 0; i < folio_batch_count(&fbatch); i++) {
-			struct folio *folio = fbatch.folios[i];
+		for (i = 0; i < folio_batch_count(&area.fbatch); i++) {
+			struct folio *folio = area.fbatch.folios[i];
 			size_t fsize = folio_size(folio);
 			size_t offset = iocb->ki_pos & (fsize - 1);
 			size_t bytes = min_t(loff_t, end_offset - iocb->ki_pos,
@@ -2772,13 +2855,13 @@ ssize_t filemap_read(struct kiocb *iocb, struct iov_iter *iter,
 			}
 		}
 put_folios:
-		for (i = 0; i < folio_batch_count(&fbatch); i++) {
-			struct folio *folio = fbatch.folios[i];
+		for (i = 0; i < folio_batch_count(&area.fbatch); i++) {
+			struct folio *folio = area.fbatch.folios[i];
 
 			filemap_end_dropbehind_read(folio);
 			folio_put(folio);
 		}
-		folio_batch_init(&fbatch);
+		folio_batch_init(&area.fbatch);
 	} while (iov_iter_count(iter) && iocb->ki_pos < isize && !error);
 
 	file_accessed(filp);
-- 
  Kiryl Shutsemau / Kirill A. Shutemov


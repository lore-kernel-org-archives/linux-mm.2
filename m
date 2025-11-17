Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5211ACEACEF
	for <linux-mm@archiver.kernel.org>; Mon, 17 Nov 2025 18:03:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B0CEA8E0009; Mon, 17 Nov 2025 13:03:49 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AE48E8E0002; Mon, 17 Nov 2025 13:03:49 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A20DC8E0009; Mon, 17 Nov 2025 13:03:49 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 902C28E0002
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 13:03:49 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 3E38E5733E
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 18:03:49 +0000 (UTC)
X-FDA: 84120872178.21.D59E579
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf02.hostedemail.com (Postfix) with ESMTP id 93B9880003
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 18:03:46 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=eHaFn+bN;
	spf=none (imf02.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763402627;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=U5Cie80ik2JSvccL39+8gipzyyJCojAXux/hEMXLbb0=;
	b=nthBOqChBjhTJAwg7T0nLqKCnQ7bWw1e+0rIV4BpiYs25r1BC7NaxF/erC494jLjPV4Sra
	sJ/K6woWbUGAj5bIN4TPm6iurxD+6pLKF/FVveFpVNzm3m1LB1Ae70S4MGgUZ7zLUw0/qA
	DMuR5pPR0sH14qRFANgtsQbCDAk5qyU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763402627; a=rsa-sha256;
	cv=none;
	b=CB4SeixJEiYUT0BD8dk00zQuApl6CVyCT9CxfsKixZ67xSGJNHXgFYjCy/b8V414nhHTp4
	DNvnxuiSSD8UTg8zYpnZvhv7ttHWTqyi48XAxitSchnR0Xf3mt+2Idmg53RjovNSFpF8hM
	F61+y7JZh/zMKX/FC0JKWbyZp8ZtNXU=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=eHaFn+bN;
	spf=none (imf02.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=U5Cie80ik2JSvccL39+8gipzyyJCojAXux/hEMXLbb0=; b=eHaFn+bNRcbBqqPbDECTU1nha+
	8ki4ktpeVqfjrOojFTJy4b9CsRE7DSDpiExAIK3uzWeofkrlLPwdhdwxMXhHe3VZW8PtST3ZW88Pl
	Mb8itCOIMTljNTR12RzQJWDMna902aYOJpxvJyIfpZR96OFCALwZxEM3RMHkbiIXpi8azElvRRL+o
	LNuvhXUzES1FgnU8cEMpzaBUqAB9XoqOY0mI7SKxuGXU1HMnorWwn+3kNsON1xIn/WQynngm2/gsM
	s8xKMfEQlUL7uY19UD0Cmucf9uEgC4IVsl3h+psRtvvDS6i942u/P+P+TZbpHXhiD2VdxV8kzrBle
	XxvP7Akg==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vL3Zl-0000000EEaq-0Kni;
	Mon, 17 Nov 2025 18:03:41 +0000
Date: Mon, 17 Nov 2025 18:03:40 +0000
From: Matthew Wilcox <willy@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: SHAURYA RANE <ssrane_b23@ee.vjti.ac.in>, akpm@linux-foundation.org,
	shakeel.butt@linux.dev, eddyz87@gmail.com, andrii@kernel.org,
	ast@kernel.org, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, linux-kernel-mentees@lists.linux.dev,
	skhan@linuxfoundation.org, david.hunter.linux@gmail.com,
	khalid@kernel.org,
	syzbot+09b7d050e4806540153d@syzkaller.appspotmail.com
Subject: Re: [PATCH] mm/filemap: fix NULL pointer dereference in
 do_read_cache_folio()
Message-ID: <aRtjfN7sC6_Bv4bx@casper.infradead.org>
References: <20251114193729.251892-1-ssranevjti@gmail.com>
 <aReUv1kVACh3UKv-@casper.infradead.org>
 <CANNWa07Y_GPKuYNQ0ncWHGa4KX91QFosz6WGJ9P6-AJQniD3zw@mail.gmail.com>
 <aRpQ7LTZDP-Xz-Sr@casper.infradead.org>
 <20251117164155.GB196362@frogsfrogsfrogs>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251117164155.GB196362@frogsfrogsfrogs>
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 93B9880003
X-Stat-Signature: ergc15ntojk4dbna7g5gd956ypn39iqr
X-Rspam-User: 
X-HE-Tag: 1763402626-611993
X-HE-Meta: U2FsdGVkX19y+9nb6/lD1G9I3xzuhqZO3x2suD5CN5Y8ouok455SL7y3nTAaWPXzw6Y2H3rDBDHyoughEMJQ1hlzBPvOhuNhVt/xJq//zf96XngtXxgFCWaS64jb2ZncZQjG7cD/grKWwmDSsm43qKGzzlg6jEUdEgj+GTJUbjBm2XrkJ5T0YdEtOtKaLkLkD592OwhTu+uPLMIYqTs8dxn2y28/Yug2FUZ6rFCG++5TlI5LPaEXLLJOboKhXlb3umOQNRpmIJbkMBx8cP4/yG8Lb0E9Xw6xqMDqbnDNtG/A30X1+Usss8M9Ognucl0h/E4Q35qsaRUZp51+bU3ZxWRKiuXW8Kr+TbePmDtLOA25FflB+H1IYfloXFKG4YZ76BdgpfAAYz2lZWjtVrncWBJR6QmY6MtP9GTNpYi6RYkdzfN0OJ9rkPXNSC2gKkThlayp6kR91lpYsvl4S8tCaqUFD9AR5mOHuFkx5mLWJSHKgwI3+uhrfGFYIRmgEQHSLhWs7IvfjYXy90srD/U+3IyLDtiFc2a1yNIQr1vRxPSOwK2tn2yJf+MDeb/qNm9USi31lOpcp4I1devP7MSjGYgwEkNfLjsyDH9EkprJ3rwWj2YKNr5OlAu/mlmGJkptY/M1jmMdaIkwXlnOGRO79QGVSA0J9Q1U67Te8EvM93H1cy8so9Qyfso6mf8sqUDhI91au9wQm7zRTMO6fa7y8gcd67/b9M407g/vwNNz1vjv2m1EBX+EcZWRrX7oV8GgHiT4tecxyG4CGJHJLknBDM57yxJWhgL9lPqqhh6xqBAriQ4IoCu5jHCh5f10C9bBcBcNT49CbjY6kttSVp9GEMmq2wmW+DWU7eT6sbnLn2mtLgmNSDsjA/P1Whibze7xYxIzovy9oGnEnAsylOX9wuVKtlaOM4zHDpMkX33uMxEtC0NdcNDIyzfmC4GiDo6sloB8ZGXOOyvgahT1rIQ
 qGOaqv8u
 qK4qkhVmYpBcMb3S0hGzdHJ4ESx2QeRSgfnbThiCgYKYCGtYzctANwSyMPok3kAk0Xu9S2ESupN9O9Qw1H3pm06OGuNnNA5BNTpuWPz78XxdSJxmEIQO7n1YGibBNmQ/CkMEEtLn9LwETkR0F5KQ05eZOmJpYNiMSlgYS/KAFF2r21uoTp7UrJbkh4FImPb2qtAeY4prJfRkpQEc7ANa51UTwxUU+BiBv3NDXHZOS6teB+XUnXVqi2KBuCUrTfaiPsLjuiXoKffVCUmREI+oV2UeCCqxDPsbkK0kFa5PbAtuYSyeRamDiMd/3MCtf7nwL8yd7eaDui177QESQ01I1mFTKGtaO2ENuZwey1e8nLbnEu52CwcwqkLJ/7lTTTP98Rofyiwsvdzh5Dak=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Nov 17, 2025 at 08:41:55AM -0800, Darrick J. Wong wrote:
> I wondered why this whole thing opencodes kernel_read, but then I
> noticed zero fstests for it and decid*******************************
> *****.

I wondered the same thing!  And the answer is that it's special BPF
stuff:

        /* if sleeping is allowed, wait for the page, if necessary */
        if (r->may_fault && (IS_ERR(r->folio) || !folio_test_uptodate(r->folio))) {
                filemap_invalidate_lock_shared(r->file->f_mapping);
                r->folio = read_cache_folio(r->file->f_mapping, file_off >> PAGE_SHIFT,
                                            NULL, r->file);
                filemap_invalidate_unlock_shared(r->file->f_mapping);
        }

if 'may_fault' (a misnomer since it really means "may sleep"), then we
essentially do kernel_read().

Now, maybe the right thing to do here is rip out almost all of
lib/buildid.c and replace it with an iocb with IOCB_NOWAIT set (or not).
I was hesitant to suggest this earlier as it's a bit of a big ask of
someone who was just trying to submit a one-line change.  But now that
"it's also shmem" has entered the picture, I'm leaning more towards this
approach anyway.

Looking at it though, it's a bit weird that we don't have a
kiocb_read().  It feels like __kernel_read() needs to be split into
half like:

diff --git a/fs/read_write.c b/fs/read_write.c
index 833bae068770..a3bf962836a7 100644
--- a/fs/read_write.c
+++ b/fs/read_write.c
@@ -503,14 +503,29 @@ static int warn_unsupported(struct file *file, const char *op)
 	return -EINVAL;
 }
 
-ssize_t __kernel_read(struct file *file, void *buf, size_t count, loff_t *pos)
+ssize_t kiocb_read(struct kiocb *iocb, void *buf, size_t count)
 {
+	struct file *file = iocb->ki_filp;
 	struct kvec iov = {
 		.iov_base	= buf,
 		.iov_len	= min_t(size_t, count, MAX_RW_COUNT),
 	};
-	struct kiocb kiocb;
 	struct iov_iter iter;
+	int ret;
+
+	iov_iter_kvec(&iter, ITER_DEST, &iov, 1, iov.iov_len);
+	ret = file->f_op->read_iter(iocb, &iter);
+	if (ret > 0) {
+		fsnotify_access(file);
+		add_rchar(current, ret);
+	}
+	inc_syscr(current);
+	return ret;
+}
+
+ssize_t __kernel_read(struct file *file, void *buf, size_t count, loff_t *pos)
+{
+	struct kiocb kiocb;
 	ssize_t ret;
 
 	if (WARN_ON_ONCE(!(file->f_mode & FMODE_READ)))
@@ -526,15 +541,9 @@ ssize_t __kernel_read(struct file *file, void *buf, size_t count, loff_t *pos)
 
 	init_sync_kiocb(&kiocb, file);
 	kiocb.ki_pos = pos ? *pos : 0;
-	iov_iter_kvec(&iter, ITER_DEST, &iov, 1, iov.iov_len);
-	ret = file->f_op->read_iter(&kiocb, &iter);
-	if (ret > 0) {
-		if (pos)
-			*pos = kiocb.ki_pos;
-		fsnotify_access(file);
-		add_rchar(current, ret);
-	}
-	inc_syscr(current);
+	ret = kiocb_read(&kiocb, buf, count);
+	if (pos && ret > 0)
+		*pos = kiocb.ki_pos;
 	return ret;
 }
 


Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8B20A606A32E
	for <linux-mm@archiver.kernel.org>; Wed, 11 Nov 2026 12:36:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=H9+vLzd2
Received: by kanga.kvack.org (Postfix)
	id 78F6E6B00EF; Wed, 11 Nov 2026 07:36:50 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7403F6B05B0; Wed, 11 Nov 2026 07:36:50 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6561E6B05B1; Wed, 11 Nov 2026 07:36:50 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 40D6E6B00EF
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 07:36:50 -0500 (EST)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 18EA68028A
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 12:36:49 +0000 (UTC)
X-FDA: 85422787338.28.F5C047E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf16.hostedemail.com (Postfix) with ESMTP id 5CC99180008
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 12:36:47 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=H9+vLzd2;
	spf=pass (imf16.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794400607;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NA3S0+TcajF90K5hGXvldMp+JqFlXBnQmtQs2Oovhrc=;
	b=yxXrqn/tSevlsHiHVvbdo+Bpq03tcFmWfD+ZNyIczsbrUNLE7KJPeEdvr+8yYesyjOu8fR
	tyrBSmzkY+YCdDWZ9op/nm1vqB+MhWQAsVC5u3XCawK3X0ow2dw+L0kOm1EdZphbZL060t
	SK1EBY+0/Z/wSQuiy8GOengBd+LZD28=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794400607;
	b=02wc1lnDJf/CUinY8jF+z/fDRBK+VLkHTzqRddrGUXGdKJD/jvnrYSUrKS0pLwdCQoYe2s
	bOU8ReUcElgVqf4xL2CdBzAcF9NenZTMubxszLF5qETIRkYpogCTELwNl5OKw/l7HJU63b
	PHRoy1hHgoYwZvU2Rr5Oo0+NYX03WHo=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=H9+vLzd2;
	spf=pass (imf16.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 596C145ABF;
	Wed, 11 Nov 2026 12:36:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB07A1F00A07;
	Wed, 11 Nov 2026 12:36:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794400606;
	bh=NA3S0+TcajF90K5hGXvldMp+JqFlXBnQmtQs2Oovhrc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=H9+vLzd2Lhu/eWWmeDsvRPseso8wUf+PyA2D4q8090P92qb4NNccLDohXyYUMEpnb
	 hf7xzk8PyBrRkszUciwVXEBszNLjVAruA91NZhWmmuH5klyj2fPK3lz/jjQ3qtjSJ5
	 QWvEGKlnB7uHH5OepDSKp0OOexS+hkY4/i5H8NWFyVE617U/vDgqHpECZ9GypiMXft
	 ZhndU/e1LMyGF1CC/qVU0NGj7ESGf5Won6mywMD0lED3dPbzw5yjdvNRqjQzl0N+6E
	 mPPllJ+h5ALbxOucIniGOXGpeJ6E92tSJu/75MFcA7ofbbBw23SCOC2LT23EMRNqKl
	 rxKTcpqwbMw0Q==
Date: Wed, 11 Nov 2026 13:36:37 +0100
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
Message-ID: <20261111-heimreisen-ungeziefer-empfunden-a892571f2c07@brauner>
References: <20261110145241.536019-1-kas@kernel.org>
 <20261110145241.536019-2-kas@kernel.org>
 <avNuQqLf9CG9dSsE@casper.infradead.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <avNuQqLf9CG9dSsE@casper.infradead.org>
X-Rspamd-Server: rspam06
X-Stat-Signature: u4t6e8kw1mfgoqsmqy3dt5sngjar5bje
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 5CC99180008
X-Rspam-User: 
X-HE-Tag: 1794400607-151239
X-HE-Meta: U2FsdGVkX1/s9PPfQ+sLquoOv53fnCzy24/huZj8shvw3+pn5XoiDS/LqG3Xvs7mv8RdEjIwSqucyqOilcQyoxccsn9BIXh1AYqdQFWQkwXVL6fa8IX+hmtPlpQXvF//j8yxlE5iTAyMw1StzKThzv2jfj2QxCqNaPydYXlJRBQM8MjuoRF2EXSn6IlNEm2r6oYv7ZkwBbNAzSEr77Uy3AsD8oSFoih5fovUaQ6XTcHFA9zUoVMXNiYTiy/NL3MARPS6GFfaISXuMVjk7TWfipb6YeH7JM7PUG87fEBM2DNXFWKljw6qSLYRTBrrB8qMOeFQZNukzesr8NNfDQzONgl8wq7bxCoWol/psLHQNo7rEpHZaPfw4o5CEsR/ob4lIEnPsUdZgF8lGgO6zNGTHyRG2d2qd+/l3SCgU+d8UvVwe5e/PcgnbOjTmMoDxDJERI+e3zC0YcFri/za2St4bDWFE031U2ORrmhfkQedig/DuqLuaReaP0hXwUS3MPtb8EkfJBdrqm1JpsaINpc/he2xWt+wT37RQQ0GpMob8ahKkk1IvVGqZq5lJYa7lTzfaISrPCkIMxP4EE9vDSK3JS3gkzqoQp1ZqT9vKMka0y0YkFo5GTmqTs4b93Ol8d817EGfI0od3yT/RN7BmbG1R7SO38Zb0Ct5wYiftNCWtpL8TVyZ44UtDQ18D94YJqHoW7IYmiN8EqKadsJMaNj32W+wo0JiJxC5b+opBtofxotXRnHvHIGFxU/bmjuLWuYWlWRBbC3lbCj0OXSqo399QKPD3dWqRNUxAq5d2Py/0QEE4fw+Xlpp8E7xaHaR9Gc4huYQVSB9PjvLpCHzdtmLd0pOII++VvntfXXzzEbmWyB9i8u7FYFsxD/Z0rWnnojCjghTiQrBjrjsbwRkIv11C/Z3uq0pboU3e+VsflFKBoAgQE3XZAllUGMgETCJDel+Eh+6jssd6L9zIWn1eEQ
 9APodPRU
 U6pxWy5YQUguIXoIRpdtD/GDVvxXCX9H+SpuSGt9h0YcX3jaYCoucmnjg8I8RGfZTiIcVYXioCoTMXWmdCi7BboLWa45AsC00rg9iqZIcyewBPcyu6V5K6GwiMb+5CGxSUhMbnd6HsjKh25O3QDXDCvc8DHDQV7X6bskfsh7vQi3C/NXb6hG1kqvsqL9X0GE1Wr0DYdxblpJ4pLYLTPcby+S4j5aq2nAt9xa9wrsubknxkh9xo/1iHay3QMVIZYNGlFj/38+3aaVJcMsMN08sf87i/smOGhvWHoRhbkXVNbOpuOwd4WSqObBCkxJeQU6DqVzCGa2bKHUvtI/xSJPKaUWq4HU17+ZY031Y
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, Nov 10, 2026 at 07:19:30PM +0000, Matthew Wilcox wrote:
> On Tue, Nov 10, 2026 at 02:52:36PM +0000, Kiryl Shutsemau (Meta) wrote:
> > +	src = kmap_local_page(buf->page);
> > +	memcpy(page_address(page) + offset, src + buf->offset, len);
> > +	kunmap_local(src);
>
> 	memcpy_from_page(page_address(page) + offset, buf->page, buf->offset,
> 			len);

I don't think that works. pipe_to_sg() only clamps len to the
destination page. A pipe buffer however can span multiple pages of a
compound page iircu. And buf->offset can point past the first one.

I found two exmples:

(1) skb_splice_bits() for AF_UNIX and TCP
(2) tracing_buffers_splice_read() with buffer_subbuf_size_kb > 4,

And virtio-trace splices that stuff.

Which means VM_BUG_ON() in memcpy_from_page() fires:

kernel BUG at include/linux/highmem.h:542!
Oops: invalid opcode: 0000 [#1] SMP NOPTI
RIP: 0010:pipe_to_sg+0x130/0x150
Call Trace:
 <TASK>
 __splice_from_pipe+0x92/0x1e0
 port_fops_splice_write+0x13f/0x1a0
 do_splice+0x3b6/0x8e0
 __do_splice+0x20a/0x230
 __x64_sys_splice+0x97/0x130
 do_syscall_64+0xde/0x4b0
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

Fwiw, the open-coded copy is broken as well. Just on HIGHMEM...

Starting with b46e09667411 ("fuse: enable large folios")
fuse_dev_splice_read() hands out large page cache folios and
kmap_local_page() only maps the first page.

So a fuse server on a 32-bit HIGHMEM guest that splices a WRITE request
into a virtio port crashes mainline:

BUG: unable to handle page fault for address: fffab000
#PF: supervisor read access in kernel mode
#PF: error_code(0x0000) - not-present page
EIP: pipe_to_sg+0x184/0x2b0
Call Trace:
 __splice_from_pipe+0xd6/0x1f0
 port_fops_splice_write+0xf9/0x170
 do_splice+0x2c1/0x810
 __ia32_sys_splice+0x2e7/0x310

So we need to copy per page which would fix both.


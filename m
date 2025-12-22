Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 37BD6E6781A
	for <linux-mm@archiver.kernel.org>; Mon, 22 Dec 2025 19:41:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 81EBB6B0088; Mon, 22 Dec 2025 14:41:18 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7FFE16B0089; Mon, 22 Dec 2025 14:41:18 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 729236B008A; Mon, 22 Dec 2025 14:41:18 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 62D196B0088
	for <linux-mm@kvack.org>; Mon, 22 Dec 2025 14:41:18 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 33EEA5891E
	for <linux-mm@kvack.org>; Mon, 22 Dec 2025 19:41:18 +0000 (UTC)
X-FDA: 84248125836.25.9D9790A
Received: from out-179.mta1.migadu.com (out-179.mta1.migadu.com [95.215.58.179])
	by imf09.hostedemail.com (Postfix) with ESMTP id 3FBCC14000A
	for <linux-mm@kvack.org>; Mon, 22 Dec 2025 19:41:16 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Wk98+9ck;
	spf=pass (imf09.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.179 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766432476; a=rsa-sha256;
	cv=none;
	b=bKyFyuT2xXm6pnoCPnTTD/nxALqjJ7ZDMT/57IiKGf+3Bht4KC0iDrc/UoSBjQIAaPiWT1
	ytLJMFJoiWx04RwC4+ijVp/pMkcfVUX3pLAbklNEMYsYar5TDI5DI19ZkyzZq+BVuhz2Fo
	bt9PPDZrcaOrchfs9UKr0rpn/2xb/wk=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Wk98+9ck;
	spf=pass (imf09.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.179 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766432476;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HBdPhxcvOkIIGXIYWQYM6O/Y0FlYFzryvwDPx4PZFuM=;
	b=oWuB185MjkjArMDEwKxvj9SRR5bJsTqlfGoeqCZIm0QZsUt9J9IbgyxK4VqpV5nk5/o/mf
	Ym83Aatf1cyAIEuVVviVlIl8f2T7Cr6JAJwCVCKfUdFqiZFsX27rrH0N2/ddg4WwtIoUXi
	Zi1ER3HFclYzDePjKF/ZoqFeaqnKk94=
Date: Mon, 22 Dec 2025 11:41:07 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1766432473;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=HBdPhxcvOkIIGXIYWQYM6O/Y0FlYFzryvwDPx4PZFuM=;
	b=Wk98+9ckbp5jyANGKAKbT97FXJKGd1XTR154MtCpLTT5tdBRnTwFEHi72KBwuBF/gg/K6o
	8oPGDBxmzSvgpcYhPo/byoaIT1aGfHmwGCJKn7z+quPKKTRLAGyJGagm64wAgjZpLYHJPq
	FPN0Ye9v5CYBeXvgSB9WQTadw8/ZOzM=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Matthew Wilcox <willy@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Andrii Nakryiko <andrii@kernel.org>, Shaurya Rane <ssrane_b23@ee.vjti.ac.in>, 
	"Darrick J . Wong" <djwong@kernel.org>, Christoph Hellwig <hch@infradead.org>, 
	Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, 
	Meta kernel team <kernel-team@meta.com>, bpf@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	syzbot+09b7d050e4806540153d@syzkaller.appspotmail.com, Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH bpf v2] lib/buildid: use __kernel_read() for sleepable
 context
Message-ID: <7gyxkpozyno7hl2jz5k2v2k5yo6gpvr3i5whqrgqlc5eahxvjz@p7p2a2aezsbt>
References: <20251218205505.2415840-1-shakeel.butt@linux.dev>
 <aUSUe9jHnYJ577Gh@casper.infradead.org>
 <3lf3ed3xn2oaenvlqjmypuewtm6gakzbecc7kgqsadggyvdtkr@uyw4boj6igqu>
 <aUTPl35UPcjc66l3@casper.infradead.org>
 <64muytpsnwmjcnc5szbz4gfnh2owgorsfdl5zmomtykptfry4s@tuajoyqmulqc>
 <aUjXxSAD2-c4Ivy1@casper.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aUjXxSAD2-c4Ivy1@casper.infradead.org>
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Queue-Id: 3FBCC14000A
X-Rspamd-Server: rspam04
X-Stat-Signature: 17h1h394tmm64sf63u8wtfuuzebt4y6w
X-HE-Tag: 1766432476-451275
X-HE-Meta: U2FsdGVkX19cVUWqFpEFUJT5rjYTu1G6LJQgI/ZNw1ZSC5LtEk7XrLFlkJB/bh0mn0l2Hrw91BMg2e0Njtw61ORvYBr+Zqxhrlq8lGu6RUtx4bLjLmC97uLqMQRfDSK0FBnERbU4U6fFmZAI2bOLJIUmmECk9d8y1D4NIw5UAo3Wgfyh0F7OI6spphqQusvDWmcfaA3yvbjiGdZs4D/A3NYm4eV3a/JacbBTcGkOkDJCdqBSvC3LONVwSX1d+JdD0sv07V3jVp9WPIUWtO0PmzmCnJT4ZiURm/EDa9tnIAKNSP7veis+VQyn3mgTYZVJUDbxa9UkFLqo5av+Hro6QE56g9QzI/o94m0ASmjQ+yFXj0T+m8NnhnzqzLYh7PRd8buhVwCfidUMjjx6MtZ0+/wxzFwhtcvKDGl1I7glAKNo7IKtG4dpVFho5U6hyBw1pI/k1ky6wApeYvWLDRUdmCO9OGjW6lHffDu9jXznEGD3vWPrbhr9rmLRbbewmkrcXSyBBP1dJ9hIaJ4NJK08haoW41yV/4WC6aJQ46qTkzy9qawawYvBBK+F1l8CMb/cHNIRcv21yoTQIrDt1RDmcZ4VMc2rjFN9gSikDGkXDRFhUQ50hAEKBLc8t2pua7ofrGYSrW4zS6kRvHBqgGRGzU9AcZ5tfel6i8sZA20tGvlR0bP1JUn6E1ccPE4eBKyN6E7WaPS85CcqSZNMaygZ98PmWvq1wcapES7tA+i9GHBDVIcha3M+YxInvhMXXaLZjOYNM85ZCtrUyASAb5ibRy7v/SZZoMAnf3amQzDkQAHmjx/Kfn4QACkDzJvNQ+emdx1J4nZRjbaVLIGrDeO1+2T6izrjly8yFH7+Z6C4f5G9R4+qnQfYsVCuXQE43mgAVHfHSOQqDyUIdv0UPmXBbR0whG6X1A/WVz/SNoM/E5I9f6QEjc98TovzusKVWbiqJZZT0+BM9yrpPuYtybh
 dsOMTOpd
 9v4Emf2UtxXV+rNvUsKKqlLid8LEHYINkL5rhA6w+v4Q0QHYV9rD+eS9iJBaENaheFKp6rPCaPngTUGF8AskefQY7w37bRkBRkBuovXw9K5s3oWv/0i7yjzk6MeN3lwGQBH0c1PoaiSpkkxGCnzdD4TtnFeMDCsUpBZCxPokP2KhXdNO/RxSBJTXmSLwpbcGIQPuxjJLsSHf0Ukvi5aLLvkHHSEuctPgVuhrH+exStFB5PRJzmFzzaNZiEInIEqiQ/qGmODPoMiimaPvVdZcy++KQJ/gEUgtYIjAGAADStPAwcGQjGPo95RMAiZF/qObSz9MYtRpJfeBblucIqYLqg/far6YKLKCGK4XJ
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Dec 22, 2025 at 05:31:50AM +0000, Matthew Wilcox wrote:
> On Thu, Dec 18, 2025 at 09:58:43PM -0800, Shakeel Butt wrote:
> > On Fri, Dec 19, 2025 at 04:07:51AM +0000, Matthew Wilcox wrote:
> > > > I am assuming that __kernel_read() can return less data than the
> > > > requested. Is that assumption incorrect?
> > > 
> > > I think it can, but I don't think a second call will get any more data.
> > > For example, it could hit EOF.  What led you to think that calling it in
> > > a loop was the right approach?
> > 
> > I am kind of following the convention of a userspace application doing
> > read() syscall i.e. repeatedly call read() until you hit an error or EOF
> > in which case 0 will be returned or you successfully read the amount of
> > data you want. I am handling negative error and 0 and for 0, I am
> > returning -EIO as that would be unexpected end of an ELF file.
> 
> Oh, you sweet summer child.  I hope Father Christmas leaves you an
> extra special present in your stocking this week!
> 
> While it would be lovely to believe that userspace does that kind of loop,
> it just doesn't.  That's why mounting NFS filesystems with the "intr"
> option (before I made it a no-op) was dangerous -- userspace just isn't
> prepared for short reads.  I mean, we're lucky if userspace even checks
> for errors, let alone does this kind of advanced "oh, we got fewer bytes
> than we wanted, keep trying" scheme.
> 
> A filesystem's ->read_iter() implementation can stop short of reading
> all bytes requested if:
> 
>  - We hit EIO.  No amount of asking will return more bytes, the data's
>    just not there any more.
>  - We hit EOF.  There's no more data to read.
>  - We're unable to access the buffer.  That's only possible for user
>    buffers, not kernel buffers.
>  - We receive a fatal signal.  I suppose there is the tiniest chance
>    that the I/O completes while we're processing the "we returned early"
>    loop, but in practice, the user has asked that we die now, and even
>    trying again is rude.  Just die as quickly as we can.
> 
> I can't think of any other cases.  It's just not allowed to return
> short reads to userspace (other than EIO/EOF), and that drives all
> the behaviour.

Thanks for the explanation. Is calling kernel_read() again after it
returned less amount of data unsafe or unnecessary?

> 
> > Anyways the question is if __kernel_read() returns less amount of data
> > than requested, should we return error instead of retrying? I looked
> > couple of callers of __kernel_read() & kernel_read(). Some are erroring
> > out if received data is less than requested (e.g. big_key_read()) and
> > some are calling in the loop (e.g. kernel_read_file()).
> 
> kernel_read_file() is wrong.  Thanks for reporting it; I'll send a patch.

There are couple more like do_read() and do_verify() in
drivers/usb/gadget/function/f_mass_storage.c. There might be more but I
have not looked into every caller.


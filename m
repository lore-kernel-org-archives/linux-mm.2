Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 07A98E6748D
	for <linux-mm@archiver.kernel.org>; Mon, 22 Dec 2025 05:32:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D69EA6B0088; Mon, 22 Dec 2025 00:32:06 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D01776B0089; Mon, 22 Dec 2025 00:32:06 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C55656B008A; Mon, 22 Dec 2025 00:32:06 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B597E6B0088
	for <linux-mm@kvack.org>; Mon, 22 Dec 2025 00:32:06 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 6435A1401C4
	for <linux-mm@kvack.org>; Mon, 22 Dec 2025 05:32:06 +0000 (UTC)
X-FDA: 84245985852.25.50A17B9
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf06.hostedemail.com (Postfix) with ESMTP id AFF2C180002
	for <linux-mm@kvack.org>; Mon, 22 Dec 2025 05:32:03 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=sM3F76iy;
	spf=none (imf06.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766381524; a=rsa-sha256;
	cv=none;
	b=Wm1NxabMTyiicN2Y4VAchbPTqP3sM9MGtYRmAvfMubnZUGl+KG32Et20pIZpM7pk9Xqgxs
	Rfj9GPTiuVfi5qJx5wZIm9jffgVAQBoF4mOVw65MXAQnQ3i25w8GSxlGJlMYOT5HF/Hnbl
	AueATTEFY6FuJUnZcUCXTeMVP7J+bcc=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=sM3F76iy;
	spf=none (imf06.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766381524;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lX8y5tr+Ej6/Fte/ET0M0ceaoM1fpFqL+guGVcSXbfw=;
	b=CKEYeQhsuwpQi4VrV9i5ZQmql+ia2CJZgMnFT2jtDvWZ3EikaShEKsjA50KTK7KfofOc2M
	f6vm1eSSDQy1wQVc9scZJGWQFy146P8kVXQVnmOwis3gRAXQQ94i2Vq/zwcrCn1l+CfnbL
	Op0XyHMx0s3QvRLOdYZJgD8mmxoGP6g=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=lX8y5tr+Ej6/Fte/ET0M0ceaoM1fpFqL+guGVcSXbfw=; b=sM3F76iyTio8JB//xIvz/ZMHEM
	ZOZa3523ThrZ7l9UIeOHEaWk3Tx9703GWNeD9Lo6fjjtwWgg9iuVGDZN3POBMeSMWhAvIwIc4WQ8M
	XAwhyFcGyBwNwDP738CoKJvToMayTT3tfX9MBh29ICxHug4rdkyl8evSbU2aQP02XOTyr2umbRM2s
	OM1qG8NqEpITxZfPGCK0yaZKewZMuI8uYYBOUGlzisDCPVXXMvh49vAaP89wGsCWMu+H3loDVsFc0
	gMWRf7aoDM2j4tP3orXqAPkPMHHbX8azIiDTzXBLH7zHc8nL/R7tyguBd+CRFt7oERae2Oh5wvjp7
	6DIPJwvQ==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vXYWM-0000000BFuo-1Fwr;
	Mon, 22 Dec 2025 05:31:50 +0000
Date: Mon, 22 Dec 2025 05:31:50 +0000
From: Matthew Wilcox <willy@infradead.org>
To: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Andrii Nakryiko <andrii@kernel.org>,
	Shaurya Rane <ssrane_b23@ee.vjti.ac.in>,
	"Darrick J . Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@infradead.org>,
	Alexei Starovoitov <ast@kernel.org>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Meta kernel team <kernel-team@meta.com>, bpf@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	syzbot+09b7d050e4806540153d@syzkaller.appspotmail.com,
	Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH bpf v2] lib/buildid: use __kernel_read() for sleepable
 context
Message-ID: <aUjXxSAD2-c4Ivy1@casper.infradead.org>
References: <20251218205505.2415840-1-shakeel.butt@linux.dev>
 <aUSUe9jHnYJ577Gh@casper.infradead.org>
 <3lf3ed3xn2oaenvlqjmypuewtm6gakzbecc7kgqsadggyvdtkr@uyw4boj6igqu>
 <aUTPl35UPcjc66l3@casper.infradead.org>
 <64muytpsnwmjcnc5szbz4gfnh2owgorsfdl5zmomtykptfry4s@tuajoyqmulqc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <64muytpsnwmjcnc5szbz4gfnh2owgorsfdl5zmomtykptfry4s@tuajoyqmulqc>
X-Rspam-User: 
X-Rspamd-Queue-Id: AFF2C180002
X-Rspamd-Server: rspam04
X-Stat-Signature: sm3zdu1o11esz7jkbbh4wuomah4buoor
X-HE-Tag: 1766381523-188425
X-HE-Meta: U2FsdGVkX1+L1Esf1tG2d6BRrEgxGy6aPH2BXmFvbvRzhS/3CMgqNJLTvMH8ba9qXzXIZ2J3WDCL8ou9rDO5Me+gERV3KuYMn0ek0uEXCh3TCd9rWDQNpThSBgFONwQvN3I0jSa0CurvVIf7tMgnFYlDH0TP8Y4cx+J+u5sIhg7IzrV+Ie/1vvFnQk7vmRSw4LqClyoMBfWFHPnen9EgmceY62Op+5rE4Er5WAjC9kcYM8skFFFK4Wt6yvH1uo31TxkkUOm4ODu1pL7LLf9FiRESy5HdUHuWaS5BTt5CHOJFxc4ENH1tKlxHfHPqe3qajXfyfvEacm7gyiCKfINagFBKeHDYnVReVE42+VS1kZnV0I96j9thDjTefL70h5l3G0bLo5E+efQx6qj60EEcnTaj69OfH/89KByObTuyXEfQWsbZomWLRui/Q/r2cSmqXyxeGqsRsHeadtrn9zVI9vVg8tp2h/Xt2m6sZJX7TMm4QPQSgM8ocAiTVdH3ntE1TtUVttc9TgTPPk7FRbyFPfUs0Saq+/VUYvCX5foEvQB6uBTYVHSlVVkmVKM2FrezhfGwxi6S0z6+4zZ3wFRR9hWUFIPJuUBMNdRFYCvpjHIH4DX1JnCg5HD3y1hWGaw4Qsu3muWgfrdKvWGHa+i4iuLXmeSSOUENRe3XCAMQ2b4goynNB9Ww0JQscs4pv7vjGmKV2WLhTWM8DhfUQAk6l0XtUNEjHtaTXG+SFlz1c67XIUAH9KQbJ4EmYsCtTAkVmbqyHtbvcsQGI64qiMuwWJ1KqZWBHoGCw5Zls7XZYT0sxnB9pj4ouXrzoG6da8cuFYxMj9BlS1ZSKflIHRoGb58xXR2/arvkWGuv0fZGLInvDkTcbwvhj7JGPYMokZpgHNecgbKAXu+IthQXqMohQLCpxCk1gTNLaD4B2unSiloxoY2vxScR9sb8DAEAo1qDvAj2p55TiIv02kMVwn2
 B4w1WRTu
 HjGJafFY245xsYeKB2iqJOJEMQ/Ybck5/CS/UHv+4OOp1QBdqwg0Ov0CaOgddi0Gg/sIShkJPNyuzAnaCG7D1fzjiMPgpTxIwXuEJRCqEf1xO9Rsbpn1UihZqe+HrNWsKaVTeDBmuxW9WNeI7U4CNVtoaZjZmbo9FjofZt9iIY+F1zE1J4sYB/Ln31VndjEhunQo1hPnUfQeBpe0ZwYBt0zg+bS5W68gMs1gyszKWqYa/EnYNdf/WzG70stHDn+eiu49O89iXth3qV9jrahSlU5RQaU9/XXW4v9+mNt8jRwsanJVBk0FNyVN7Z7UouosOQYz7WnRWn6TyZ+nZjDWsQkpv57rszVhOe2OiuNFUeigtuHEOexPtKXXUqnWmajIt2tnqAKWExoeehq0=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Dec 18, 2025 at 09:58:43PM -0800, Shakeel Butt wrote:
> On Fri, Dec 19, 2025 at 04:07:51AM +0000, Matthew Wilcox wrote:
> > > I am assuming that __kernel_read() can return less data than the
> > > requested. Is that assumption incorrect?
> > 
> > I think it can, but I don't think a second call will get any more data.
> > For example, it could hit EOF.  What led you to think that calling it in
> > a loop was the right approach?
> 
> I am kind of following the convention of a userspace application doing
> read() syscall i.e. repeatedly call read() until you hit an error or EOF
> in which case 0 will be returned or you successfully read the amount of
> data you want. I am handling negative error and 0 and for 0, I am
> returning -EIO as that would be unexpected end of an ELF file.

Oh, you sweet summer child.  I hope Father Christmas leaves you an
extra special present in your stocking this week!

While it would be lovely to believe that userspace does that kind of loop,
it just doesn't.  That's why mounting NFS filesystems with the "intr"
option (before I made it a no-op) was dangerous -- userspace just isn't
prepared for short reads.  I mean, we're lucky if userspace even checks
for errors, let alone does this kind of advanced "oh, we got fewer bytes
than we wanted, keep trying" scheme.

A filesystem's ->read_iter() implementation can stop short of reading
all bytes requested if:

 - We hit EIO.  No amount of asking will return more bytes, the data's
   just not there any more.
 - We hit EOF.  There's no more data to read.
 - We're unable to access the buffer.  That's only possible for user
   buffers, not kernel buffers.
 - We receive a fatal signal.  I suppose there is the tiniest chance
   that the I/O completes while we're processing the "we returned early"
   loop, but in practice, the user has asked that we die now, and even
   trying again is rude.  Just die as quickly as we can.

I can't think of any other cases.  It's just not allowed to return
short reads to userspace (other than EIO/EOF), and that drives all
the behaviour.

> Anyways the question is if __kernel_read() returns less amount of data
> than requested, should we return error instead of retrying? I looked
> couple of callers of __kernel_read() & kernel_read(). Some are erroring
> out if received data is less than requested (e.g. big_key_read()) and
> some are calling in the loop (e.g. kernel_read_file()).

kernel_read_file() is wrong.  Thanks for reporting it; I'll send a patch.


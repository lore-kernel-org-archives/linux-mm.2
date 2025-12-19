Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 16020D711CA
	for <linux-mm@archiver.kernel.org>; Fri, 19 Dec 2025 05:58:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 354C26B0088; Fri, 19 Dec 2025 00:58:59 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2D81B6B0089; Fri, 19 Dec 2025 00:58:59 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1E37A6B008A; Fri, 19 Dec 2025 00:58:59 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 0E7EB6B0088
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 00:58:59 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id A1EC558DFB
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 05:58:58 +0000 (UTC)
X-FDA: 84235167156.12.97FB684
Received: from out-170.mta1.migadu.com (out-170.mta1.migadu.com [95.215.58.170])
	by imf13.hostedemail.com (Postfix) with ESMTP id 995CC2000B
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 05:58:56 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="B+b/j72d";
	spf=pass (imf13.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.170 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766123937;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4HqcONQ2/Kfp88WL6kDtebaHTkyU0GryyZiYjvEXXW8=;
	b=XMnqIrT8ujhkw1h3kJo4KiugIZa5an+nyxP+a/Y7uuMCIXGfiF33wekv5r7qzAbv9QnJHK
	lCGGzTyFWdwtsuxSGvVBeRdUIsePZCsWsTDQOYr6xHBrIQLxgasNlTE18ENGwTrjCAHDyO
	c5k1gsSNBIw4n0R0j3VCsMLGdYtj67E=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="B+b/j72d";
	spf=pass (imf13.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.170 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766123937; a=rsa-sha256;
	cv=none;
	b=yez2lALX3YNRBZlEOvXs+Py6S1kOaX0BPtt+tuyTNXTzCD/5JSkHgFMlJKuWBa8rdbBxM0
	pEvO1oSNS0w16If2PBoXqzSxjn3ZY8yQCyUVAyK75E03XI6v+5MrqoApE4ogxdN49HoJ8O
	QM1J1Tcw8mvL3McIUuWT491BsUc7RZo=
Date: Thu, 18 Dec 2025 21:58:43 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1766123934;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=4HqcONQ2/Kfp88WL6kDtebaHTkyU0GryyZiYjvEXXW8=;
	b=B+b/j72dwvAoxDdB7jiAaEQfq7UbTcs4Qs+juxF9UnufHwCuRuSPxYgWsdOInVY1ZA+Qgt
	Q3/MPKjEz3nmM9S0Z53adtGmaYLaczFL/AdToDqPU3TW47fSnyyQ5VNtMhMVH43zdwPkJz
	i/v6F2YtnsQ66oXbUiQiChCOBXKxueo=
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
Message-ID: <64muytpsnwmjcnc5szbz4gfnh2owgorsfdl5zmomtykptfry4s@tuajoyqmulqc>
References: <20251218205505.2415840-1-shakeel.butt@linux.dev>
 <aUSUe9jHnYJ577Gh@casper.infradead.org>
 <3lf3ed3xn2oaenvlqjmypuewtm6gakzbecc7kgqsadggyvdtkr@uyw4boj6igqu>
 <aUTPl35UPcjc66l3@casper.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aUTPl35UPcjc66l3@casper.infradead.org>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 995CC2000B
X-Stat-Signature: u9gagsbfeoy4xiiixkge3pfudwg5oxm9
X-Rspam-User: 
X-HE-Tag: 1766123936-848495
X-HE-Meta: U2FsdGVkX19OUtrLx4h5IHfa0mocIekIpvYYH5qq06EhT4QmVpk9awNxsfJu8G9emVl4b86pMTFUuEUfMkznjk74FJ6kiCXUcvAqeyw0IewqSyysC/7iqJ/jXu0ckt5yWNE5R61AuAEIqKeluD7mMNL+7oHDOeNdpfhwpzRzP7A1WUHrrN2pUVWnVx581OukmYGUcaEgOB5ghK5dY3EolgpwyqlbdyjAJo5jWqPSMoslwW4iEV7glGGF+Xq5t9JuloFCMYdm3uH4wV1h3G0y6DTxyDP2bdx9LvcNY2EDP0cAL7Zd5HI9wPy03m64lROXDvVoYCu4dxebaMPWWA1Ap0MLbp/O9yZsLNSfXVSJOV6x3sZA79Ts3us2mXwOy0fnEfK3nT/9vBTEMTM7P9K51NRF/el4bnL/+J1zpmdPhuk9uGg6UhuFTHZljx5bnLeuP68/CA/vAIJhZtJFq+Px/vX3TD8/Xo1x5lh7diaeMADEsGnFHUu3S5xkudShyL0kLUUjO8jbfLeZPDdNAIybngk6oAvoX/5NhSVzXyhuoguBMp7cSF1SW3LZ8ETzlus8+g7ACsoMMPaTjBTEIZ8xM0gi3DGGJ+isz+aOVcNZj98c/u3NmOE7Fc0Np+qo1xB18pnUPm2tGoEqRE/tW5hICaFaMANRbQeweuU6nHRBzgMSF2bsr5UXann3cHcfYwqt4Eqa7w7EIjiV5WvQXBUXcymeWq3gHCaibtCXNaMJxBONFr7jp+l4m/c5ijNXWibCFfRXdmq2pwno2E9F7ZOp3QS0PZDtqrU2DMXso/0fHaRjpFm3CRjMRVVvCOvXkgFbtJV6jNZ8HgvyukDtadUKIUtoNgHm7P/hXaTA6Y+kKzt7lWAZuk8ZhGZwGZoGxDZZPd6kNSb20dxuDqgN9bLBOMtkDSZDlHjH688HbG9/5UjYE6gWJenajud1H+lZDijzJZZ3AirvPPHgKNTEYiA
 x3+K+ZbO
 VNWU9FcaSNvO9L6I/S9uAEtgTelbjUoDnFedD3pJND82S528AgxjcwXNBOnI/gnCDmQYpUR2mp4IJKlfHZNgQ9YquCZmGvhiqwnFwF2PRpRLF7ap5SpOFAU9+1jB+MqGgs0f3FZcz3yfHYhwODIr55EeZzo4wDQTPNVXws/+Wi5D8VSxbNAOGYOUrbMnrLdIb18syWki8qEFgFv5uQ1+w/eyXliq5kG3lCrEi8AuMvj8chl9vwYjXPKdz5GLi/pjImz/lIC+VbZ/GD+B5swuL9CFs22AiwnrlvjCd2FAT5JK/UurYab0Wn7QNor8Xbk3IpIa+9HseMcKkIOBHll+hKgTexhO4sG7zXNPV
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Dec 19, 2025 at 04:07:51AM +0000, Matthew Wilcox wrote:
> On Thu, Dec 18, 2025 at 04:16:40PM -0800, Shakeel Butt wrote:
> > On Thu, Dec 18, 2025 at 11:55:39PM +0000, Matthew Wilcox wrote:
> > > On Thu, Dec 18, 2025 at 12:55:05PM -0800, Shakeel Butt wrote:
> > > > +	do {
> > > > +		ret = __kernel_read(r->file, buf, sz, &pos);
> > > > +		if (ret <= 0) {
> > > > +			r->err = ret ?: -EIO;
> > > > +			return NULL;
> > > > +		}
> > > > +		buf += ret;
> > > > +		sz -= ret;
> > > > +	} while (sz > 0);
> > > 
> > > Why are you doing a loop around __kernel_read()?  eg kernel_read() does
> > > not do a read around __kernel_read().  The callers of kernel_read()
> > > don't do a loop either.  So what makes you think it needs to have a loop
> > > around it?
> > 
> > I am assuming that __kernel_read() can return less data than the
> > requested. Is that assumption incorrect?
> 
> I think it can, but I don't think a second call will get any more data.
> For example, it could hit EOF.  What led you to think that calling it in
> a loop was the right approach?

I am kind of following the convention of a userspace application doing
read() syscall i.e. repeatedly call read() until you hit an error or EOF
in which case 0 will be returned or you successfully read the amount of
data you want. I am handling negative error and 0 and for 0, I am
returning -EIO as that would be unexpected end of an ELF file.

Anyways the question is if __kernel_read() returns less amount of data
than requested, should we return error instead of retrying? I looked
couple of callers of __kernel_read() & kernel_read(). Some are erroring
out if received data is less than requested (e.g. big_key_read()) and
some are calling in the loop (e.g. kernel_read_file()).


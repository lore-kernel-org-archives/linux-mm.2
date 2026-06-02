Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 31430CD6E57
	for <linux-mm@archiver.kernel.org>; Tue,  2 Jun 2026 18:44:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 96EA06B0088; Tue,  2 Jun 2026 14:44:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 91F086B008A; Tue,  2 Jun 2026 14:44:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 80DDB6B008C; Tue,  2 Jun 2026 14:44:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 6DB1B6B0088
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 14:44:45 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 07936C2FFE
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 18:44:45 +0000 (UTC)
X-FDA: 84835848930.16.BCC57EC
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf14.hostedemail.com (Postfix) with ESMTP id 4112610000C
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 18:44:43 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ZkPgGXeJ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of ebiggers@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ebiggers@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780425883;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MLZpb/dBT6Cd/zdymSeQQn2ShIJqYaKuCdbAYTAgCEs=;
	b=ZGJK73zIMNdjnVzkLX1UfxNujdZwooDxl+zvJAPXVaqQoG/Rj/swj50c3DEjLPzQrI5Hck
	NzMne4znbEIhwqhXYQ+7qtgI7VW/VHDkW3L+9PM3jkKIeFoeOSIaOkTC0+ZbbnN2C9FCd/
	YkYi+EsGscLQKFXbatzcnH3hu0vaCEY=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ZkPgGXeJ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of ebiggers@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ebiggers@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780425883;
	b=5tpIUl6EIrNChIrYHCZ+X7ZOjgG0opMb4slYfFQ9peUlpqPb7lFWW4ArwistMVoU3FlYz0
	jrcLFm7TlhB16IlpYZ9B3GSM2kSU9AFgx3WuNXxSlZtRN82c3sXzusO71DrhuVq8KSfYtx
	caAN6tnmuf2Jn8wF2IjwulI8shF+yMk=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 5C43D431CB;
	Tue,  2 Jun 2026 18:44:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 883B11F00893;
	Tue,  2 Jun 2026 18:44:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780425882;
	bh=MLZpb/dBT6Cd/zdymSeQQn2ShIJqYaKuCdbAYTAgCEs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=ZkPgGXeJhcybPoUrwoJsoHbVqWODRisiZEor43NouJ0EOonoHtL5ZjXT5z2iJq2OW
	 GDChFmTvh0mNbkacQwKUaKroi/K5VuMWckc3qDOZkoGWloPBy/BiNDmIsaDfaEbVdt
	 SJIvc7Zr/r1UimXiaMWvOVkDxmTPRqm5nQj0oHRrXQP3pz160C1TveVTP7t69+wX+y
	 4XU2qNwckg8sNPBwiMTbYksGRjLuaZKd4WSdoPd/PXHbT4sUKt38KmcNBD0nQUxgYG
	 yrp+jU8aG/MhN4ziuGvqzI6WZWvejPq1QXRH+RvSiAdjLWhsMCdLfqKnatMcOtteZT
	 VzdugpvG6XUWg==
Date: Tue, 2 Jun 2026 18:44:40 +0000
From: Eric Biggers <ebiggers@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	Al Viro <viro@zeniv.linux.org.uk>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Christian Brauner <brauner@kernel.org>,
	Askar Safin <safinaskar@gmail.com>, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, linux-api@vger.kernel.org,
	netdev@vger.kernel.org, Matthew Wilcox <willy@infradead.org>,
	Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@infradead.org>,
	David Howells <dhowells@redhat.com>,
	Pedro Falcato <pfalcato@suse.de>,
	Miklos Szeredi <miklos@szeredi.hu>, patches@lists.linux.dev,
	linux-fsdevel@vger.kernel.org, Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 0/3] vmsplice: make vmsplice a trivial wrapper for
 preadv2/pwritev2
Message-ID: <20260602184440.GB2503276@google.com>
References: <20260531010107.1953702-1-safinaskar@gmail.com>
 <20260601-enthusiasmus-canceln-anlehnen-0e62317a9784@brauner>
 <CAHk-=wifX_rrDjRGnDnOqE-usptAukuXKrmuPuVDP5bOCBWzGQ@mail.gmail.com>
 <20260601173325.GH2636677@ZenIV>
 <20260601160455.2c187574@gandalf.local.home>
 <20260601172825.a51a588ec1c32617a0e12d78@linux-foundation.org>
 <821ed41e-5b2f-4d17-aeb2-71b0361f8e7f@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <821ed41e-5b2f-4d17-aeb2-71b0361f8e7f@kernel.org>
X-Rspamd-Queue-Id: 4112610000C
X-Rspam-User: 
X-Stat-Signature: hy16qoasykqw733cab9n43wii79then3
X-Rspamd-Server: rspam09
X-HE-Tag: 1780425883-159976
X-HE-Meta: U2FsdGVkX18bkXEk/G1lARfIxMJqrgbJZ8pRTwKw/yL6F7c3/dQ02/ye9XkdNuqx5J/o8nKRP6j3EXWKVxbffJeWhMPPooyB5z6QOed0QSljRE1fF3GLld2o9fJzTYqcQA8jN31EoJ3paqN1aIVygqSK6wqd1TinyZ5Io2i+Nr2WRRv51I04lDvCRienzvZdEJE5nHaJeBo5BjPUZtdGx127O1fMeK9cURYOwHDw9KwRUxvqptHypTB6xHwsz86hsF5n3xUosjcUxDKXz7j2TFgvVNklT75WcUjlwLWmmfVJ6D/wfsJMHu3MpfN+Q548DT5unPMpLTUqqPDIh5peZyaupRtao3TVnDYtbzIRZLHky+GAP6ZH/piNiW8GCVzdpUFhoYiTnNQPthj1Xla37yLLtXyqw6mN45Ga7Qwixo6xryrnh49fBBrK0gEPYmapnzwrv7Y9mgueyM9B4DnJR8GQWAXp7ii/IbVkxv/H6qmCfRFa58Ct9AwLKxJxhcZ1C1MOjWTAz71Knbv6AV7GHBrI2hWvuXiDxpDW8Fi2AcQtN4+mZXe+idAhLQlHxcLqRhSWJ05sRDOMULIlV7CzYBtB8o5fhv9h0dici/EtHBo1YviYgC1Vxhp8LdFpewPsrSEOMEHCp3nuL/VdrwnkHXFES1eQbZ2pVw6W5RmXqYYF2VHt1Q2pGNeFCj3Z2WOyD6cZThr/KKJR+58mW0v63dK87PvFv5AWBAVTr1PNq2Q83fy9mqxeS3POxPN+cOXj+LidIAg+wkrbV+76OmZoZhw7dGFuJVUhotYq91j9K5/wGWYYnD4keYZa4Mu4pwL0A0v+tBeMfW5OeA/0ojWMF6L+qPO+ZhBFLDjkCnvPwdN+pAwjI1qUfHwDisqn0NlFM0rmMJTkg3kaB4qHJmMWjzmBLy+z2hrVJMm8jnRlKM7ClQfCEypM/8ROGYWSXpkKHLPCdFJXKiuAzD1LLip
 jH892/sM
 z1b885hSP0npl7YafsPY/vtOnksOgLgxlpAwAcYZLqKEFERf3SFLWigVRuDE9kRlCUTrUJKYi3jeKoaNKMJwG4e1EinEmh//HJSNAOjbWlfVLTQgWupNfuwrGu/0FgkpEjFE+Q2X6RlwVlmIESUV6f9Vv4OlUOEhoTTyP9WbJnZ5TJqBsg6BqKhxC9m5Ru2+0yEuKywETlpbKunHQCkbzmjqurjRngDv7GSegE36k14vodyhny+rDfVipSOWN/XC0Q6mu58XnTX5AMCe5OQMs8DXJtYK56xYBwK/+qHGI200Jb6rJNnrYHqLlZ9PtSSPYpdaoJ9y4Ft6sZl9fe9CDS99g4TMrUvxKMZqqhn6Ki9+x+TOnX82BalA8biScpx4KEQyMqC9Wz7Qy/mT1CB3ID99Xawxpcj6c5Hc+
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jun 02, 2026 at 10:25:06AM +0200, David Hildenbrand (Arm) wrote:
> On 6/2/26 02:28, Andrew Morton wrote:
> > On Mon, 1 Jun 2026 16:04:55 -0400 Steven Rostedt <rostedt@goodmis.org> wrote:
> > 
> >> On Mon, 1 Jun 2026 18:33:25 +0100
> >> Al Viro <viro@zeniv.linux.org.uk> wrote:
> >>
> >>>
> >>>
> >>> FUSE might be interesting - fuse_dev_splice_read() and its ilk.
> >>> Communications between the kernel and fuse server at least used to
> >>> seriously want that, so that would be one place to look for unhappy
> >>> userland...
> >>>
> >>> splice-related logics in fs/fuse/dev.c is interesting; another place
> >>> like this is kernel/trace/, but I'm less familiar with that one.
> >>>
> >>> rostedt Cc'd (miklos already had been)
> >>
> >> Thanks for the Cc. The tracing ring buffer was specifically made to be used
> >> by splice and the libtracefs has a lot of code to use it as well. As
> >> reading the ring buffer literally swaps out the write portion with a blank
> >> read portion, that portion (sub-buffer) is used to be directly fed into
> >> splice, providing a zero-copy of the trace data from the write of the event
> >> to going into a file.
> >>
> >> trace-cmd defaults to using splice to copy the tracing ring buffer directly
> >> into files to avoid as much copying during live recordings as possible.
> >>
> >> Whatever changes we make, I would like to make sure there's no regressions
> >> in performance of trace-cmd record.
> > 
> > Well yes, The patchset seems sensible from a quality POV.  But to make
> > a decision we should first have a decent understanding of its downside
> > impact.
> 
> I guess most (all?) of us ... dislike ... vmsplice(), so trying to remove it
> entirely is certainly very appealing ...
> 
> > 
> > I haven't seen a description of that impact in the discussion thus far.
> > And that description is owed, please.
> > 
> > I assume a small number of specialized applications are using
> > vmsplice() to great effect?  What are those applications?  What is the
> > impact of this change?
> 
> 
> I did some digging, and the kernel crypto API documents using splice/vmsplice
> for zero-copy[1] and libkcapi [2].
> 
> I did not find performance numbers, how much vmsplice/splice actually gives us.
> Playing with the kcapi-speed tool [3] (specifying --vmsplice vs. --sendmsg)
> doesn't really reveal a big difference at least on my notebook. Not sure if the
> parameters I specify are reasonable.
> 
> I don't know whether downgrading vmsplice to preadv2/pwritev2 would perform
> significantly worse than sendmsg ... and I don't know what the default would
> usually be (default to vmsplice or sendmsg). I might try finding some time to
> play with it more, but I doubt it, so if anybody else has time ... :)

AF_ALG is a mistake and isn't commonly used.  Using a userspace crypto
library is faster and is what almost everyone does anyway, as it avoids
the syscall overhead.  There are many other issues with AF_ALG as well.

7.2 will mark AF_ALG as deprecated, mostly remove AF_ALG's zero-copy
support, and remove AF_ALG's async I/O support:

    https://lore.kernel.org/linux-crypto/20260430011544.31823-1-ebiggers@kernel.org/
    https://lore.kernel.org/linux-crypto/20260504225328.25356-1-ebiggers@kernel.org/
    https://lore.kernel.org/linux-crypto/20260523-af-alg-harden-v1-0-c76755c3a5c5@gmail.com/

In practice, the programs that are keeping Linux distros from disabling
AF_ALG in their kconfig outright are just iwd, cryptsetup, and bluez.
They use AF_ALG just because it was mistakenly thought to be easier than
using a userspace crypto library.  They don't need maximum performance,
nor do they use vmsplice, splice, or sendfile.

There is other highly niche code out there that does implement the
AF_ALG + vmsplice + splice thing, e.g. libkcapi.  But it's just not
enough of a reason to keep zero-copy support, especially considering
that AF_ALG has always been the wrong solution in the first place.  The
fallback to copying the data is fine for this deprecated API.

- Eric


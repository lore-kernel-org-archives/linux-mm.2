Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CC620CD6E7D
	for <linux-mm@archiver.kernel.org>; Fri,  5 Jun 2026 15:42:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1CC866B00A3; Fri,  5 Jun 2026 11:42:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 17D206B00A4; Fri,  5 Jun 2026 11:42:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 06BC96B00A5; Fri,  5 Jun 2026 11:42:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E670C6B00A3
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 11:42:02 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 988F8162136
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 15:42:02 +0000 (UTC)
X-FDA: 84846274884.11.A7CA0FC
Received: from mta1.formilux.org (mta1.formilux.org [51.159.59.229])
	by imf22.hostedemail.com (Postfix) with ESMTP id 5D43AC0012
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 15:42:00 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=1wt.eu header.s=mail header.b="pA/QxHuM";
	dmarc=pass (policy=none) header.from=1wt.eu;
	spf=pass (imf22.hostedemail.com: domain of bounce@1wt.eu designates 51.159.59.229 as permitted sender) smtp.mailfrom=bounce@1wt.eu
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780674121;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=duKO+vzFJ97ZNiF0DbRfLSuX03PYOSVq+ESDQC/usyM=;
	b=BycP+UyoJgcpV38oeFNSTN4jQoZjAf4xnbBZC0sUBIT6P1o+OB2IEf4aWu9xtnPg5xmDNV
	ecX7n/Cm4ozNIDwvynmw0UDiYnXCMeW5W4r+8yJShIfP12mcQCtHoZ/Zd0zgDvThuRm9oD
	gmErNlElRsRu/veBa3Rk8kNIf03Q/fo=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=1wt.eu header.s=mail header.b="pA/QxHuM";
	dmarc=pass (policy=none) header.from=1wt.eu;
	spf=pass (imf22.hostedemail.com: domain of bounce@1wt.eu designates 51.159.59.229 as permitted sender) smtp.mailfrom=bounce@1wt.eu
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780674121;
	b=hzzGCSdRD7MrErh8XGgosWudhP4AP4mIYWs1PPl8o8pERTAxJXiE37EEgBOTHu1SCMp5tq
	KSpy7Of2wqc8SDCDcIPg8n4W4If08MNyLAiaHJYcgsMzmwH0TmCWe8Yxl8rI1vVHMKw/o2
	RCSQKr3PbKAJqBzXHcgegOuqJwdS1Rs=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=1wt.eu; s=mail;
	t=1780674117; bh=duKO+vzFJ97ZNiF0DbRfLSuX03PYOSVq+ESDQC/usyM=;
	h=From:Message-ID:From;
	b=pA/QxHuMTNgLcMbBXWam2O0grD8k/53PmT5oIVHyiwNEJxBKXrLk6Tot5aez/4nrr
	 0FMRtm/B1cHhBHBJWvjbasWgpyMtprd4qPimYB96Zr6vEy1TXL7feuhXHKWwXeoRRI
	 5EU9YQwcSNnMN5TrxvJOsvK2NIIMq+5lGfHdGaV0=
Received: from 1wt.eu (ded1.1wt.eu [163.172.96.212])
	by mta1.formilux.org (Postfix) with ESMTP id C49B4C0A55;
	Fri, 05 Jun 2026 17:41:57 +0200 (CEST)
Date: Fri, 5 Jun 2026 17:41:56 +0200
From: Willy Tarreau <w@1wt.eu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Christian Brauner <brauner@kernel.org>,
        Askar Safin <safinaskar@gmail.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, linux-api@vger.kernel.org, netdev@vger.kernel.org,
        Matthew Wilcox <willy@infradead.org>, Jens Axboe <axboe@kernel.dk>,
        Christoph Hellwig <hch@infradead.org>,
        David Howells <dhowells@redhat.com>,
        David Hildenbrand <david@kernel.org>, Pedro Falcato <pfalcato@suse.de>,
        Miklos Szeredi <miklos@szeredi.hu>, patches@lists.linux.dev,
        linux-fsdevel@vger.kernel.org, Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 0/3] vmsplice: make vmsplice a trivial wrapper for
 preadv2/pwritev2
Message-ID: <aiLuRDJcQMYGuQsc@1wt.eu>
References: <20260601-enthusiasmus-canceln-anlehnen-0e62317a9784@brauner>
 <CAHk-=wifX_rrDjRGnDnOqE-usptAukuXKrmuPuVDP5bOCBWzGQ@mail.gmail.com>
 <20260601173325.GH2636677@ZenIV>
 <20260601160455.2c187574@gandalf.local.home>
 <20260601172825.a51a588ec1c32617a0e12d78@linux-foundation.org>
 <aiEb8CTM-ovMIq7-@1wt.eu>
 <CAHk-=wiQB-j53cTs9kM4UeXoXPaFj78aJe3D6Yp1Fohg7i4tWA@mail.gmail.com>
 <aiGfgRch99l_5z11@1wt.eu>
 <CAHk-=wg0e8pP5haNW4qJP1=QwwUEctwjK5k07sv8bskitoMDgg@mail.gmail.com>
 <aiGkrQnMeyPmEvRB@1wt.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aiGkrQnMeyPmEvRB@1wt.eu>
X-Rspamd-Queue-Id: 5D43AC0012
X-Rspam-User: 
X-Stat-Signature: 84t9skmwz3ix693b47zywud69t5rdz6e
X-Rspamd-Server: rspam09
X-HE-Tag: 1780674120-641972
X-HE-Meta: U2FsdGVkX1/OlAJNBar7qaIJE4fzGbHYB1No5NL3e8a3ZGiso9PylVR0JbILhzXUjsadGAoAFjH6rnGFQpOX7VdUtWb7H5oiZQ+zyLS8cmHGADLhYBH+YU5XK5CCTvpfv611EBbhZmd466EDkyn9fM3OjYXmudReNOhIq2wyJgT6pbLRxsyUY6vRmLQjg2eYNgmueStJ1swkKsd3ykOuPOTPzNYU+qZWC8BOLBJKclgoQJo7eNXL6pGyiSeJ38ZruD4E74ptWcbxf8o8j9uT2yZdN1bU6k1JV2JXsdDBUmLpsrRzIlciNw5aiOBtmaUnUZ6tpytqWZ46gPV+UPlOfbMRfzMYR8sv/Rs2+u3KBarIs93HTUQRBrTFMrjnKS10mYnyNDsslhXuEBx2xRpvHAPjjx8CzloIlu8+rIpYZ8oWIacrXSIAL0XzpTq+BBF0GaY9coyhVXQGAGkNGnO5hjy7QO4OrXNmAFzrBxP2HrC0vTWD85E++b70eN5TRGfzzAOcL+M2CFNXNlcQ2hutlMJmtt4npoxxjuMemEQUg/F7uxA4MWtdm1OnwlyCIhDjvDvZBllW51ofTaMfDE6HhQUGqrwrN2NuVPnMOrqyTNyd5zWRzoCPaseHg76xhDvsT1ARRaKm8/VKVfnI5bI+TGQB7tMx1qd+N1e5h+d/4xaSARBnJ8H/3fyTqXOBskMOhpKh37kJsK8TEMI9j1I7lwG2O6zYkwmpGqgd9jMIR4Us4Pvu6RyMnnF/DLIgZm5bfO5O5aJCqoYgyFwFY//tkgT1x2D/aYAM3oOSwrWP6gTWEME2z3o3rzgMRB/94hpGWvcwvc6ckzJdFBtamgjYgmyxz+dNZPHk2h5f1Z719effMBLH8u3tUHNFVBzBx3fKMPpBjyS1Os+VueopdszoOIqVrO4LiFzSyH19cLyaTE9IMnmqv3FItz6lgisvZVlLegrjXHuPtygf4nqnpyN
 b4UHrJjw
 grqsTIb/bGa+gTo+vW9S0owYDM/iG+vFJk2FEcBN9/WCVswh+4ZIuTwfqinLH2+X2A5gQvZUDfP5mDUWtMiz6GDb0P7oF4eUiZK4jJWB+zeAMebf+DF/3/8Ab2bQG4upctnrsy3TIrOAGOg68GrwgeQ2hPvwSWXfF3Q3PiMuMsuhKgLecS8cVlcDuSzqTzdtHmaR9GVLPLOYGxdmWzm98P9xagc/9WBTT21qnq6/yKR6DJTeFoK7WJhjc0KIFHd0STt6M6vFTwMO3FkHnfjRjVoq/Q1hTfVUzcnldcnT2eoKsQ/TEXe7eChU9lJRqLBOfzOMALsY38GqN8+cC9gzPsEtD7Xxp/LkurSaC755o4/LNV4s8xA3AX7Pz7Lr2w7C5fbsUlhYa7o2mhv0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jun 04, 2026 at 06:15:41PM +0200, Willy Tarreau wrote:
> On Thu, Jun 04, 2026 at 08:58:33AM -0700, Linus Torvalds wrote:
> > On Thu, 4 Jun 2026 at 08:53, Willy Tarreau <w@1wt.eu> wrote:
> > >
> > > > It looks like you're actually doing exactly the thing that I thought
> > > > was crazy and wouldn't even work reliably: you change the
> > > > common_response[] contents dynamically *after* the vmsplice, and
> > > > depend on the fact that changing it in user space changes the buffer
> > > > in the pipe too.
> > >
> > > No no, it's definitely not doing that (or it's a bug, but it's not
> > > supposed to happen). I'm perfectly aware that one must definitely not
> > > do that, and it's a guarantee the user of vmsplice() must provide.
> > 
> > Whew, good.
> > 
> > In that case, can you just try the vmsplice patch series (Christian
> > already found a bug, but I don't think it will necessarily matter in
> > practice - famous last words) and that test patch of mine, and see if
> > it all (a) works for you and (b) if you have any numbers for
> > performance that would be *great*.
> 
> Yes I wanted to do that and noted it on my todo list yesterday when
> noticing the ongoing discussion. Just been super busy with yesterday's
> by-yearly release ;-) But at least I wanted to share quick feedback in
> this thread about existing uses.

OK so I could run the test this afternoon, with:
  - ddd664bbff63 Merge tag 'net-7.1-rc7' of git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net
    (v7.1-rc6-178)

  - the same with Christian's vfs-7.2.vmsplice branch merged into it
    ( 8d86fcfc2857 include/linux/splice.h: trivial fix: declerations -> declarations)

Both show 71-72 Gbps of TLS traffic per core on my test utility (I
stopped at 3 cores since having only 2x100G at the moment), so for
this use case I'm not impacted by the change. I noted that I will
have to reconsider other options for the cache (send(MSG_ZEROCOPY)
probably) but in my case since the code doesn't exist yet it's not
per-se a userland breakage, but a change of plans. I just hope I'll
find my way through the alternate solution.

FWIW for Christian's branch:

Tested-by: Willy Tarreau <w@1wt.eu>

Willy


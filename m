Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5F675CA5FCE
	for <linux-mm@archiver.kernel.org>; Mon,  5 Oct 2026 07:05:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0CF0F6B0088; Mon,  5 Oct 2026 03:05:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 05A486B008C; Mon,  5 Oct 2026 03:05:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EB0826B0092; Mon,  5 Oct 2026 03:05:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id B88416B0088
	for <linux-mm@kvack.org>; Mon,  5 Oct 2026 03:05:16 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id EBFC3C0160
	for <linux-mm@kvack.org>; Mon,  5 Oct 2026 07:05:15 +0000 (UTC)
X-FDA: 85287686190.14.D694AA4
Received: from mta1.migadu.com (out-207.mta1.migadu.com [95.215.58.207])
	by imf08.hostedemail.com (Postfix) with ESMTP id 8103C160009
	for <linux-mm@kvack.org>; Mon,  5 Oct 2026 07:05:13 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=HZeu9daF;
	spf=pass (imf08.hostedemail.com: domain of baoquan.he@linux.dev designates 95.215.58.207 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791183914;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bH7PMnWLfRAZ6aJw4xJIAExG1fi8Ho8tfDjsCBM3Ngk=;
	b=F+o+UZ2XwYZxMPCrAy8b7rfE8fiBF00PAI8SQapE1hjjQc8JR7rnLPGWVYrsuhiOkDj6cB
	k8F621E4pchM3AxU1mCOBYgKt6oYGrsrLezpG/Tctl8gB2iIE+0pR7Sb1K7NGaQLlHMCjJ
	XQ+Mj4d1ymL2QuNYmXUsVjiw4ECqmC0=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=HZeu9daF;
	spf=pass (imf08.hostedemail.com: domain of baoquan.he@linux.dev designates 95.215.58.207 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791183914;
	b=c/KdtU3XyZ5Lw746FbPnCOWCSaNt3gmczz1X8haKCRT7sjMyhJKtUMqpVxYI25s5R9Mmgw
	dQWm6H+42S1JEc/0uhVi/TtbjdmHca8R9K7TEjKsTZD/C83AsamPobzMVgVONebwuYDGuD
	4rdaMloqT+yHIGmS6xOGBCN3DQGQ5vc=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=o4yv2wUb/Ot/RnaUUo13TrZ3HO4rdZeGGRcHPxQjPPg=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1791183911; v=1; x=1791788711;
 b=HZeu9daFa2kblPzFfbzshZQnlZYkHnykwdB2D9bzp5xdFrgs0xbNWo5dWLucwNFnkB/BY0b9
 yNJWIDSkjuTMc5NZN9GA2aDL1myIUD5+W788HaB9BjRqrjhbYxmklIjKTHwV/a1c/XFIXgDV71t
 UM84546LttOU5Wue8nCs+3Ao=
X-Envelope-To: linux-mm@kvack.org
Received: by mta10.migadu.com with ESMTPS id 10a499c38b37761e;
	Mon, 05 Oct 2026 07:05:11 +0000
X-Mizu-Trace-ID: 10a499c38b37761e
X-Migadu-Flow: FLOW_OUT
Date: Mon, 5 Oct 2026 15:05:03 +0800
From: Baoquan He <baoquan.he@linux.dev>
To: Nhat Pham <nphamcs@gmail.com>
Cc: Baoquan He <hebaoquan@kylinos.cn>, linux-mm@kvack.org,
	akpm@linux-foundation.org, chrisl@kernel.org, kasong@tencent.com,
	hannes@cmpxchg.org, baohua@kernel.org, youngjun.park@lge.com,
	david@kernel.org, kunwu.chan@gmail.com, gourry@gourry.net,
	riel@surriel.com, klarasmodin@gmail.com
Subject: Re: [PATCH 00/12] mm, swap: give xswap a physical backend (xswap
 phase II)
Message-ID: <asNMHy0u4_n90QWM@fedora>
References: <20261003005900.909710-1-hebaoquan@kylinos.cn>
 <CAKEwX=ObA6NQg-24jE+BT4QksamwM+hYWWxfYBYa=4mXvC3oUA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAKEwX=ObA6NQg-24jE+BT4QksamwM+hYWWxfYBYa=4mXvC3oUA@mail.gmail.com>
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 8103C160009
X-Rspam-User: 
X-Stat-Signature: 5epnrxs7tnode4fun98ra8kfrxo935qh
X-HE-Tag: 1791183913-911591
X-HE-Meta: U2FsdGVkX1+VGjGgJ7TxxCUQLbcIfLPuwaoAi8jroBwWbdPt4QUBIxjUZy61ix8ZqW4QyfOaHGEi5WKW27lBeeyZFCiEpzmg45fxw5CpdIZY+GIfQ6LTN+JCqsuGclgHpe8fhqDEP8c0M7WQxwBYHZa9Yx1yuviJgsr78woDA3BMgh2bT+o2iqHTGINHMHHQqRRE95ue7NKpYFpgNsT3nFIFeLHIbyKwELpKI9wsKZ7xyw9QXIJZFF664x3l1Ljpr6jlIiLFRtAlV7+axkx59zsPBE1Y+L6MKPeY2xYAu528P9HHMA26zmGbvRQL0Lp0CcRzpIMtnC1oHer/DelzIGXgYBeQPkndMmJB13pizVhgnkW4nGyszD1iXXnmLoiiq+boTMRj8iBSEfPRiLXbC0IIFH/rcD7kTpnrGgHCexb2J+g1mX2IKSLwD304rYrfaCVx4Ya3uf1D13q3fpsuxWwzEdNCwXimVz7vSwTwnpn2om8fnqUpL1oRdIjhF8/uxOQwQEAfN12DNp7zrBIVyPsLEQa21Ix6LzKnx4Hol8/iQdrBvf1/Xa0BD7JmW50qGeA4OLJtcyQj6BVE+CO92HBjxLo3oYrQU6+O26u0RGv7XgoYzPQyIVxixu7F8KRrmrWQMuxdP91UlQ6eCMI3LwG6EhEo0HAEpRWX0KczS16hTvUXdbV2KOpTN4vFPBxJoFlye5QUPUNbtrkhnnp5uLhCOOdw+iMwpJjWhFNvig0hA91rAAO/WKOMsFx/5AFano2bDwXSFNaAw/iBeWfh1D9Je5qp7M3JOpljobEXvohpKQ8cRm4kjDoffYFT8YZ4KvyivzVnepnIjDjlbWGz2VJUNFL7jSWZUbSHBUlyIi25EvLcxrBf7LP1HdoPbS+59YWWM5ySHsehJaGndcMAVRdTsGVdR7AqM7iIe++up2yDz5P2kg5j7+J1MCvgR9/ib1yHMw2r4mvH2DPJMTE
 6uMjdOSy
 g1kgjMVYij0y0/WcEwx2UBAOucp4DtFSessteLvmUVxHnL2Sd4oE5Ixk1QVZcKt4jZ/AXLWwAMnEYPV42zrYSow0IrH+I0QAxxBGlAVjzSUFsl3rHpWSwEha5Kw10K+xz412AOtfKUjAzHme6T9pYMy4QWM4+Oj9d5Q52IfIq6S6qDIz3a351i548FGn5vT0ueFK6gsrkJ+hgtqsNKxzao7hc9ieYOU9r3HhOUhVkeOfaXz8aaQpunYytBOah3g/CYMNhODlFy6sDS2Q8wdRvkrO+Hdad6kBiAVNrsiuvE5SsVXLi/z9MLwUf+n9TgVm2cTLTdAgpoQq1/PXb+kcLAGDbJiNtlOmEEVy+Mf0SMmzqQoO95Eh8sEizge8dshx/VXRr3LsSjzQyLjxQWoLS7lfBEqMGsxXcUPU5pCubpqNQhe9kTEiFgMbntU2u94NlWsTi
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 10/03/26 at 10:35am, Nhat Pham wrote:
> On Sat, Oct 3, 2026 at 1:59 AM Baoquan He <hebaoquan@kylinos.cn> wrote:
> >
> > An xswap entry holds a page in zswap. That works until zswap will not
> > take the page. Then the page has nowhere to go.
> >
> > This series gives an xswap entry a second home. When zswap refuses a page,
> > the entry takes a slot on a real swap device and the data is written
> > there. The xswap entry does not change when the data moves. It is what the
> > process's PTE names, and the physical slot is recorded behind it.
> >
> > Phase II of three. Phase I is the device itself, 14 patches.
> 
> It's not cool to take my idea and code, modify a bit to fit your
> design, then send it out without any proper attribution.

Nhat,

You have made this a public character judgement — "unprofessional and
unethical", "too lazy" — on top of a factual claim about attribution.
I will answer your factual claims completely, and I will correct the
things I did wrong. I will not reply with insults. But I will not leave
it on the record that I "took my idea and code, modify a bit, and sent
it out without attribution", because that is not what the postings show.

The v1 cover dropped the paragraph the RFC had. The RFC carried this
line:

  "This partially refers to Nhat's vswap-v4 series. E.g patch 1 is
   consistent with his patch 3, patch 12/13/14/15 are from his patch 8."

When I rewrote the cover for v1, I had just spent more than a week debugging
that series, and then another day on one intermittent failure that I could
not reproduce. I sent it out that morning and planned to keep testing after.
I simply forgot to copy that paragraph into the new cover. It was not a
deliberate attempt to remove your name. And I am happy now xswap phase II
should satisfy kashiko now.

Second, how xswap started. One time Kairui shared a presentation in public
about swap table and TODO list we can do. I got and idea that we can use swap
table pointer entry to point at zswap entry directly to improve efficiency.
After checking with Kairui I posted the Pointer-entry RFC. With that,
zswap got up to ~20% lower latency and ~10% higher throughput.
- https://lore.kernel.org/all/20260707073215.72183-1-baoquan.he@linux.dev/

Then I posted the ghost-swapfile RFC, which used lazy VM_SPARSE mapping for
the cluster_info[] array from the very beginning. Its cover says: "a sparse
64MB virtual address space is reserved at swapon time ... physical pages for
cluster_info[] structures are allocated only on demand". When I was working
on this part, your vswap was only RFC v1 of 5 patches, more than 2000 lines
of code adding, and RFC v2 of 7 patches, more than 2200 lines of code adding.
And your rfc v1 was not cc-ed to me.

- https://lore.kernel.org/all/20260707082614.95030-1-baoquan.he@linux.dev/

Third, the collaboration. When I posted ghost swapfile RFC, you came and 
added comment. After discussion, You said let's solve one piece at a time,
and I took that seriously. After a week of careful consideration, I laid
out a bottom-up plan — the backend pointer in swap_cluster_info,
dynamic growth first, writeback and rmap after, swap tiering long term. I
did not get a specific technical objection from you.
- https://lore.kernel.org/all/al8ohWshSSZ64AtT@MiWiFi-R3L-srv/

Then I posted the dynamic cluster management foundation on July 27, and its
cover said explicitly:

  "once the dynamic cluster management lands, Nhat's VS series can build
   the per-slot backend pointer, writeback, and rmap on top of it without
   an extra xarray lookup in the cluster access path."

- https://lore.kernel.org/all/20260727135029.1059441-1-baoquan.he@linux.dev/

I didn't touch writeback part and had been waiting for your. I left writeback
alone because the split was that you would do it. I asked Kairui to review
the foundation. He said he was busy with MGLRU and swap core at first, and
when he did look at it he called it "a really smart idea, really good job",
and gave detailed improvement suggestions. Other developers contacted me
privately, saying they were interested in xswap and wanted to help test,
improve or something, I welcomed all of it.

- Kairui: https://lore.kernel.org/all/apVNB2FRTFMDtvGP@KASONG-MC4/

On September 1 Kairui reviewed the xswap v1 series and praised the VM_SPARSE
foundation. On September 2 you replied to that same thread twice in public,
and then wrote to me off-list the same morning.
- Kairui: https://lore.kernel.org/all/apVNB2FRTFMDtvGP@KASONG-MC4/
- your first public reply:
  https://lore.kernel.org/all/CAKEwX=MU9uXVenEu7he+h-Pq7K3BmCGvvKS-KiPK61Xd0ox_mQ@mail.gmail.com/
- your second public reply:
  https://lore.kernel.org/all/CAKEwX=NNzX=sXdqPATrWw7cw7sdG-vOO5LqjH=JnV1YiZLO5MA@mail.gmail.com/

In that message you said you wanted to discuss how we could work together on
xswap and vswap, and you asked for a video call. I agreed. I replied with the
phase split: phase I the VM_SPARSE foundation, phase II writeback/rmap/zero-
page, phase III the zswap xarray removal, and my proposal that you take
phase II while I test and review it. And you can take phase III too if you like.
I also told you I did not like the xarray-based cluster array (struct
swap_cluster_info_dynamic) and the large, intrusive changes it made to the
swap core. You followed up in a friendly way. You said that struct was someone
else's code, that you thought the interface and the use case matter more than
the code design. I was working on an answer to that when, the next day, you
suddenly posted "Path forward for Virtualized Swap?" on the list and made
the whole thing public. To this day, I still do not understand why you reached
me to make a private conversation and got a friendly feedback, then immediately
raised a public mail to put me in the middle of a storm, with a lot of 
your friends coming at me.

What happened next is the part I disliked most. The "Path forward for
Virtualized Swap?" thread filled up with comments on xswap's interface and
use cases — things that are often a one-line change — and almost nothing
on the core design and implementation.

Fourth, writeback. I had already implemented it by then; I held it back
because the split was yours. When the "no writeback" complaint kept coming, I
had to post the writeback RFC on September 20. Johannes then required the memcg
charging changes, so I added them. When you wrote in the v3 thread that
you tried very hard but found building writeback on the xswap foundation was
a lot of work, I told you not to worry, the RFC was posted, and you could
take over the writeback series. I never got a reply from you.

- my reply: https://lore.kernel.org/all/arDSdRDF9CnHjkE0@fedora/

So I did it myself: over the following week I fixed 11 regressions and could
not reproduce one intermittent failure in two days of continuous testing,
and then posted foundation v4, writeback v1 and memcg charging.
- writeback v1:
  https://lore.kernel.org/all/20261003005900.909710-1-hebaoquan@kylinos.cn/

What happens next. I will restore the cover paragraph. If you want to drive
phase II, take it — adjust or rewrite the shared parts, including re-authoring
them. But I am not going to stay quiet while my name is called unprofessional
and unethical over a missing claim in a series that carries your own patch
under your Signed-off-by and whose RFC credited you. "Too lazy to rename a
macro" is not a technical review either.

If your point is that I missed attribution, I hear you, and I am fixing it.
If your point is that I am unethical, I do not accept it, and I want you to
stop saying it.

Baoquan

> 
> Adding a per-cluster array to store backend (in place of the existing
> zswap tree) was my idea. The only difference is you put it in the
> existing struct swap cluster, and I separate that array out into a new
> vswap-only struct to separate the vswap-only metadata:
> 
> https://lore.kernel.org/all/20261003005900.909710-5-hebaoquan@kylinos.cn/
> 
> which, ironically, was also my proposal:
> 
> https://lore.kernel.org/all/CAKEwX=OvR7GbU_9f2h_MtU4m0g6s-esHmNQKYNhJz610M0P3Sw@mail.gmail.com/
> 
> And that's not the only one. I mean, you're too lazy to even rename
> the macros of another mechanism I proposed:
> 
> https://lore.kernel.org/all/?q=SWP_RMAP_CACHE_ONLY
> 
> Yet, my name and my work is not mentioned or acknowledged at all in
> this patch series, other than a small prep patch.
> 
> I have been very polite and deferential so far, trying my best to
> accommodate your use case and innovation as best as I can, even go so
> far as testing and debugging for you, because I want the best swap
> virtualization scheme for the kernel:
> 
> https://lore.kernel.org/all/CAKEwX=Pe+qMZd2xhnU-PAGQtgXkp56c-JwYCbt2Lux9htgB67Q@mail.gmail.com/
> 
> But I believe this has crossed a line. This is a very unprofessional
> and unethical. Be better.


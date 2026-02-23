Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C88B6EC1114
	for <linux-mm@archiver.kernel.org>; Mon, 23 Feb 2026 17:43:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 33FB36B008A; Mon, 23 Feb 2026 12:43:21 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2ED056B0092; Mon, 23 Feb 2026 12:43:21 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1EF626B0093; Mon, 23 Feb 2026 12:43:21 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 0A8406B008A
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 12:43:21 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id A75151B4FA9
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 17:43:20 +0000 (UTC)
X-FDA: 84476442960.10.C5CAAFD
Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
	by imf23.hostedemail.com (Postfix) with ESMTP id 93FDC140005
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 17:43:18 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=GebdygH2;
	spf=pass (imf23.hostedemail.com: domain of kaleshsingh@google.com designates 209.85.214.176 as permitted sender) smtp.mailfrom=kaleshsingh@google.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771868598;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nchrh37I6wEN3HEejFjQWq3au44qPr6w+TKeLWlYsk4=;
	b=ykszbefhzp3ZHRufSUMNxxiVHmcNhECbX6CyQM7OolDVP8rHFxr9kZEg2TJwfbi5OR7gJd
	icaYWwTIfB/OBaDZNYyApKJJBAgIbKzavzHBEWhCHAGoY93crORECsn0dQDe4+mUIDa0//
	1veH7iL2zGoZke+cHvwL4pkLKbtheFk=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1771868598; a=rsa-sha256;
	cv=pass;
	b=eBd7xlGRlzqZikT7XhGqmurI1xaPEITZEew4H/thMkFObr3VoIGdrUTr+UgGQY49DIeshg
	bCxbNzcWW0j9dfWA9gkLY2uSgVlS8MgMx3vyHFJKlTq88ObfcyAwp/PbKLnH5HnSCmphV9
	sqtdWGWH9h3Z8Sz4Sc/fN31U3tI8oaA=
ARC-Authentication-Results: i=2;
	imf23.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=GebdygH2;
	spf=pass (imf23.hostedemail.com: domain of kaleshsingh@google.com designates 209.85.214.176 as permitted sender) smtp.mailfrom=kaleshsingh@google.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-pl1-f176.google.com with SMTP id d9443c01a7336-2aad8123335so1285ad.1
        for <linux-mm@kvack.org>; Mon, 23 Feb 2026 09:43:18 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1771868597; cv=none;
        d=google.com; s=arc-20240605;
        b=C6RHu9SkLmtg3RBPA2N2dUGiN8uS/fK011EKqJ3tfWV9FonsnT6dqW+ba3Gkm9ZtXa
         LmkLNr4Zh8IRvz49lQqmJBxq+U3VLWLIjm3pW+T1jMYDHHEoK07M9SMdAk1g4MxSDh5c
         q8xddIx0rrjMVlw1tb9cmjtS24/zDhqtKCPT23zp2NBlYzJ8h/EpQWvDqN0VvuTbPvHi
         GPyh0kRU3dn0/0qUd1XECqqG4BO9ESE1e8TYqKcWvtjpXR5w724Uq65iHfI2aOZERsZP
         Aas/lPOUt0HWUnzUMHLRvPOvxt++zcEmeaD0epBVugftsl8xOp/1mojdZZGRHl79rhZw
         pK9w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=nchrh37I6wEN3HEejFjQWq3au44qPr6w+TKeLWlYsk4=;
        fh=GrAAB/hNIYOd4OfGYHnM5mNLiV6fs8SLVRQ0GASGqg0=;
        b=JqLJE7z4dCJxR5j46ndlUOaICBCk1AlVaBGgYdOkagb6LQIX/HNpM+pyLX239G+c46
         /kHDrVhqkV4jthCVjZ08MkaN0c5g/KTWsdpoVxFKgjsdav/yxvR1VlzSF1XlUuwhxBvt
         bWiCQSvMDUXC+hgGqNChw/be5KAsc3TOF7lAXoI9HGIfXdi3b3yBoLycrDAZ+WHLXONI
         RXQqVrIU09UMgN2Da6IStC4/L1HRQbZ4sI8kRqCsiGY+E4J+o7luzIHKaTl2sIiYg1Ks
         LFip0WdE4ms9FuGFF1uC0sEdwnoRPmnlnRaJDIy+dUDIGFGQSxfg+Ei5TZZ3ToWTcxUU
         SaKw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1771868597; x=1772473397; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=nchrh37I6wEN3HEejFjQWq3au44qPr6w+TKeLWlYsk4=;
        b=GebdygH2IOIkMu9acIy8/Z+YSJEwi0/SlqCM5/NjjBOwsZP1K3XQGs7X8sOiOhC1Ek
         /+VaHxIi6IGId5zzLIEDAr4JB+SDDNJ0c1/c+1ROsyHfjRLp0w7I0zcqHltvnMqyNw32
         KC1xAOUTBM9KQUHNFV6Mf2JjuegSVreDiVn6FwQHudorezAMx/1oBKUvBtFKgNGzTdOy
         A87P/k0IT2IZQYIqzEwFmzVdVnFIPz+5n7+W5W3T/TGlPhKedzzGRRwgy7HB+Y636zPx
         31p98o9IpEmnEUTHcZdyAgzkJrl/KLDH+i7rr44SlLEDP54bWjhi8s4ib1xwNcFtvM81
         kvxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771868597; x=1772473397;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=nchrh37I6wEN3HEejFjQWq3au44qPr6w+TKeLWlYsk4=;
        b=FxknQCR421J5JGbB9w3Qf9w5fa127HqPAwly8V6Ogv79vTJBu1Accv5ZGT+dkLhDYW
         kVD6w6Otergi/OMrP61tyjrfL3nR+wU8M0KoYc9vghLKt6Pht8sptaAiC+H7j3UlFmXG
         GYq59gPCf9iL46l2b0INwzkyFh8EL8jj8FrGEBhfLjlFdAn2FbRWso4jQNcptWt1Exo8
         sJIGiKxoLWkbJmn3CfrC66loVh421WGZuh/tfeiU3ViaHQp4WcnXlDAtI0QiEbqyJyiH
         cqNievNz8WmCLFBmUWFBaZfA6jrWDpuTdqIBV/4N80v2/m7ldm5qM4ikSJxSEIrCtqe6
         fxRw==
X-Forwarded-Encrypted: i=1; AJvYcCU/Q6m5CqmP1eki+gOwQd++1o20d9Yxx9WsLas5FUqtbgpX1Hxa5nlAjG2D3UArxh3SpcuQAl+5Ww==@kvack.org
X-Gm-Message-State: AOJu0Yw7jBsoIWYLKBR5xJV0ExrIa6/9ab5pzvw0ihmObLfBIoRK5tMA
	27yYK3NfX4T9RsoqPSHT/pE5fQIZIj3pEs7lUTtEFMWr+VMoJeMGmiKTNtKLfhKSXW5xQquph9V
	5GObglv+EvwGkJalhcGMSh1Tk9MjK8sAqyfpgrFJL
X-Gm-Gg: ATEYQzwNJ1jv+DpibCxwwkrJADxrT1Zmte3rxAhAhw/OmeL/rlfnw9skrhTXi0bKcDW
	1GhdztG5BqDIXWyPFJNfcMGFvRTXYYBtTVKdom+lfGpSl+fGk5CXw0OK0cB+s8MAqjyb8YLYUK3
	9uK2WWHqMVKuBHfd0U8/pgzT+OWnPX/ER9sKw1E+bqC9TiN0DbTw7AZGedjJvCDqZkz8pCgt/gP
	QMWmL4I3WygytHgWnuexi94yj3hG4Oa7eVoeiiIjkQUw0wCaUEkUbxhQoFElrt3CpPxoUFq+mqf
	HyJwp8nbTsgVdzAhggRTE0Q3CQsU9//S988=
X-Received: by 2002:a17:903:1746:b0:2a3:cd98:f07 with SMTP id
 d9443c01a7336-2ad75ce8893mr2648175ad.3.1771868596848; Mon, 23 Feb 2026
 09:43:16 -0800 (PST)
MIME-Version: 1.0
References: <20250820010415.699353-1-anthony.yznaga@oracle.com>
 <CAC_TJvcaJdEzK8n9BK0qgEXdzjzXtbA_Zk-ybfmG8kjNExVCzw@mail.gmail.com> <fqabaahjjlmoc2xh4cwh4ykbqyu3rnzvjw5epxi5wwpmgqth7f@d3mqpjozwmo4>
In-Reply-To: <fqabaahjjlmoc2xh4cwh4ykbqyu3rnzvjw5epxi5wwpmgqth7f@d3mqpjozwmo4>
From: Kalesh Singh <kaleshsingh@google.com>
Date: Mon, 23 Feb 2026 09:43:03 -0800
X-Gm-Features: AaiRm50m9UYvsRrMNZGeDJldRqqXCjwlRuVa1vgsK31xKBtD7H4yIH2DN8vqIDQ
Message-ID: <CAC_TJvdRsfzYohiKW=82N8Ofi5V26rX1GS0M8HeaX6CEsgc+PA@mail.gmail.com>
Subject: Re: [PATCH v3 00/22] Add support for shared PTEs across processes
To: Pedro Falcato <pfalcato@suse.de>
Cc: Anthony Yznaga <anthony.yznaga@oracle.com>, linux-mm@kvack.org, 
	akpm@linux-foundation.org, andreyknvl@gmail.com, arnd@arndb.de, bp@alien8.de, 
	brauner@kernel.org, bsegall@google.com, corbet@lwn.net, 
	dave.hansen@linux.intel.com, david@redhat.com, dietmar.eggemann@arm.com, 
	ebiederm@xmission.com, hpa@zytor.com, jakub.wartak@mailbox.org, 
	jannh@google.com, juri.lelli@redhat.com, khalid@kernel.org, 
	liam.howlett@oracle.com, linyongting@bytedance.com, 
	lorenzo.stoakes@oracle.com, luto@kernel.org, markhemm@googlemail.com, 
	maz@kernel.org, mhiramat@kernel.org, mgorman@suse.de, mhocko@suse.com, 
	mingo@redhat.com, muchun.song@linux.dev, neilb@suse.de, osalvador@suse.de, 
	pcc@google.com, peterz@infradead.org, rostedt@goodmis.org, rppt@kernel.org, 
	shakeel.butt@linux.dev, surenb@google.com, tglx@linutronix.de, 
	vasily.averin@linux.dev, vbabka@suse.cz, vincent.guittot@linaro.org, 
	viro@zeniv.linux.org.uk, vschneid@redhat.com, willy@infradead.org, 
	x86@kernel.org, xhao@linux.alibaba.com, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Stat-Signature: nsedou34kynibkjyptje8384re85hwn6
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 93FDC140005
X-HE-Tag: 1771868598-26737
X-HE-Meta: U2FsdGVkX1+HT8UeBBTFjKBTOhgIBfe2r33aG9GjtHWoAQYzrgyhKMakW59kkcQ1aOVuIBS0mB6K2jefxlnK9CFLeig120SBfcDQFtbqvVKrhnHY7125ihTRRtqedm5kbxmJ6G760SKBJH94Qh2rYYy7W5frd0fg9W3pNCOxm6BDm09gQhHnGCd+v+n2DOlUoL0nqiv9fbYiUeE8uqylzJINcUGiR91drYAbT9SsazrB7bReK16TtzNIdBkmiU9P/YN4wLn6b8UqnO+NZ0EEKnUCycmEINW62x+uTOkCmN6rUifrgr4qOEIGNzrhX8KJBSFzhEe1ydCJ3u1b8qBSK0lVB0zknUjKCEDKePBzxsmzVuAu26lKn+azT8RibjbPzTymrr23YY4qHh9qHezGI9mpna8YhaRQDoQJau0fpJTP1OXKsAT0ufbojruy+yLsXwCm9g1yqCvcGC8g4M3AkNAsjjy/hE+LyAGc4FntT8dE500eWi+6jCbYQ78kHBZl9uqxw4lldjzSpyMKZ2fmkkNs28RAFxYjyjuxYgSTIouzyVjfbZm0wGGiy9hEeO1y1MaU+c0HsU1lZ/cJK7hqIv/fkhtHcDlbaKTNUD5njeF3SDJ2we79wwjDFPk6+PuYO2CCKgwBkyxv5Qc5hXUWJBmdFRDthUlGxIo2zpPJJIH69Yq0wsIIvCqYPSWMbPU4aRJxjhbPiHpWNVWk3PyRmmzigY9wlrcevJ+61p1hOXfT4LNs1Zyq0GxXUqkXWoqDMrmiM8DARO+mBxvEGAl2cL8rHBMR8ZgjgzliWU0dL5Xgu+b2FE+TkZjCa73UtJwX5pPGdKCaCrsqT609k+8/9RsQYsjwtCivf6JM9onk1Tz2vmikklV/VjzZIj8ed0q1Pd88vG8VUCYzXrju5+DZwwRpfAVfT2fuo0uBif07Q1grqVOYJESGr0hHAUs2Tpd424FxWMwAfLG3JOUc/zU
 hbuKma3z
 WTeCWCVX9W//o2nlKxrpjOx1g9YAUGOci5zCDPcHOFGRraf8wke+ZJM7/acLuZxjurqA7J2FnD1FnMZ91XfsSW1lLylQzG5S06mXFKop967BiVQBzi9IOpx83htVPvdPeXat5ebyqsG1vpwXsJFxcrAKaDYfN2zvL6CaavhjRSNiy4So5DRCfYedavUyViXZ+m57yXLY6++xbwyxotevDGGZBM/vFv8GPq13ky/5qnKBMyrxCv2Kl2aQSDDx1dwk6Zw9NiTDux0cDaVw=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Feb 21, 2026 at 4:40=E2=80=AFAM Pedro Falcato <pfalcato@suse.de> wr=
ote:
>
> On Fri, Feb 20, 2026 at 01:35:58PM -0800, Kalesh Singh wrote:
> > On Tue, Aug 19, 2025 at 6:57=E2=80=AFPM Anthony Yznaga
> > <anthony.yznaga@oracle.com> wrote:
> > >
> > > Memory pages shared between processes require page table entries
> > > (PTEs) for each process. Each of these PTEs consume some of
> > > the memory and as long as the number of mappings being maintained
> > > is small enough, this space consumed by page tables is not
> > > objectionable. When very few memory pages are shared between
> > > processes, the number of PTEs to maintain is mostly constrained by
> > > the number of pages of memory on the system. As the number of shared
> > > pages and the number of times pages are shared goes up, amount of
> > > memory consumed by page tables starts to become significant. This
> > > issue does not apply to threads. Any number of threads can share the
> > > same pages inside a process while sharing the same PTEs. Extending
> > > this same model to sharing pages across processes can eliminate this
> > > issue for sharing across processes as well.
> > >
> > > <snip>
> > Hi Anthony,
> >
> > Thanks for continuing to push this forward, and apologies for joining
> > this discussion late. I am likely missing some context from the
> > various previous iterations of this feature, but I'd like to throw
> > another use case into the mix to be considered around the design of
> > the sharing API.
> >
> > We are exploring a similar optimization for Android to reduce page
> > table overhead. In Android, we preload many ELF mappings in the Zygote
> > process to help application launch times. Since the Zygote model is
> > fork-but-no-exec, all applications inherit these mappings, which can
> > result in upwards of 200 MB of redundant page table overhead per
> > device.
>
> This can be solved by simply not using the Zygote model :p Or perhaps
> MADV_DONTNEED/straight up unmapping libraries you don't need in the child=
's
> side.

I think that's a separate topic, but that model is used on billions of
client devices :) The common runtime for apps and other core system
code is preloaded to significantly reduce app startup latencies.

>
> >
> > I believe that managing a pseudo-filesystem (msharefs) and mapping via
> > ioctl during process creation could introduce overhead that impacts
> > app startup latency. Ideally, child apps shouldn't be aware of this
> > sharing or need to manage the pseudo-filesystem on their end. To
> > achieve this "transparent" sharing, I would prefer Khalid's previous
> > API from his 2022 RFC [1]. By attaching the shared mm directly to the
> > file's address_space and exposing a MAP_SHARED_PT flag, child apps
> > could transparently inherit the shared page tables during fork().
>
> So, we've discussed this before. I initially liked this idea a lot more.
> However, there are a couple of problems here:
>
> 1) mshare (as in the mshare feature) isn't really aiming for transparent =
here.
> There is e.g a specific need to setup an mshare region, with a few files/=
anon
> there, and then later mprotect/munmap parts of the region - and have it a=
pply
> on every process that has it mapped. This is why we're aiming for differe=
nt
> system calls (not ioctls anymore), doing munmap(mshare_reg, 4096) is ambi=
guous
> as to whether you want to unmap the mshare VMA, or a VMA inside the mshar=
e mm.

Since we are interested in sharing text here, how does this play with
stuff like symbolization for call stacks? I believe this is another
reason where we might want to avoid mapping the pseudo mshare file
wrapper?

>
> 2) Sharing the page table at all (even worse so, Transparently(tm)) is a =
huge
> pain. TLB shootdown becomes much harder, and rmap as-is isn't suited to d=
eal
> with this case. The way things are going with mshare, the container mm wi=
ll
> have one single entry in rmap, and then actually doing the shootdown is a
> huuuuge pain (which, fwiw, will probably need a per-mshare TLB workaround=
),
> because you need to find out and shoot down _every_ mm that has these tab=
les

I agree the TLB shootdowns would be a pain. Perhaps, if there was a
concept of a shared ASID/PCID in the hardware, that would make things
less so ...

> mapped. And then, naturally, since you're sharing page tables, doing A/D =
bit
> collection on these becomes extremely useless - and that will naturally p=
ose
> problems to the reclaim process if you abuse it.

I think in the use case I described, it would mostly be sharing
MAP_PRIVATE stuff, and the access bit should still apply for global
reclaim. However, I agree it becomes difficult to reason especially if
you throw memcgs into the mix.

Thanks,
Kalesh

>
> 3) other misc problems that make it hard to work transparently (VMA align=
ment,
> levels which you may or may not want to share, you need to revisit most p=
age
> table walkers in the kernel to get a completely transparent feature, etc)
>
> >
> > Regarding David's and Matthew's discussion on VMA-modifying functions,
> > I would lean towards the standard VMA manipulating APIs should be
> > preferred over custom ioctls to preserve transparency for user-space.
> > Perhaps whether or not these modifications persist across all sharing
> > processes needs to be configurable? It seems that for database
> > workloads, having the updates reflected everywhere would be the
> > desired behavior. In the use case described for Android, we don't want
> > apps to be able to modify these shared ELF mappings. To handle this,
> > it's likely we would do something like mseal() the VMAs in the dynamic
> > loader before forking.
>
> mshare_mseal!
>
> >
> > Perhaps we could decouple the core sharing logic from the sharing API
> > itself? Since the sharing interface seems one of  the main areas where
> > we don't have a good consensus yet, perhaps we could land the core
> > sharing logic first. Keeping the core infrastructure generic would
>
> I think the core infrastructure is relatively generic (at least the
> small core mm modifications to get this to even work) already, but
> perhaps Anthony can comment on that.
>
> --
> Pedro


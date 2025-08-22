Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C404FCA0EEB
	for <linux-mm@archiver.kernel.org>; Fri, 22 Aug 2025 16:56:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0FB7644014C; Fri, 22 Aug 2025 12:56:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 05BFB8E009D; Fri, 22 Aug 2025 12:56:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E66B444014C; Fri, 22 Aug 2025 12:56:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id D041E8E009D
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 12:56:42 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 81032C0284
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 16:56:42 +0000 (UTC)
X-FDA: 83804997444.16.8355482
Received: from mail-lj1-f169.google.com (mail-lj1-f169.google.com [209.85.208.169])
	by imf21.hostedemail.com (Postfix) with ESMTP id 70B7B1C000F
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 16:56:40 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=TO+toPj4;
	spf=pass (imf21.hostedemail.com: domain of urezki@gmail.com designates 209.85.208.169 as permitted sender) smtp.mailfrom=urezki@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755881800;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=N2HS1dqu0u6/zLIQ0iklKxHGjviVaOOzJ9/vcWLgezc=;
	b=3OkBDOTmdcL6aBEqt77NKOFJg+7R8JrrIkqByMzCdhegtvIPit9fm67E1jC7b/Gs1jp1nF
	1BZZxIWoYSNqXq/F4eIXa9VvP4Q2MqZ3v5xv2dLWAiYtJOTOfE7Gz/LllVTqzIanGlL0ET
	mdPT9y9qUPHcCk7L5+c9mIHtVXTQrgI=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=TO+toPj4;
	spf=pass (imf21.hostedemail.com: domain of urezki@gmail.com designates 209.85.208.169 as permitted sender) smtp.mailfrom=urezki@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755881800; a=rsa-sha256;
	cv=none;
	b=TgP5DhU6xQsOR9E4nxtNxsw2GNWQrn4C4gTuEWA9zcY/uwZhmb097tremfINKpSFbY8VVV
	0usIlMGOHPkIll9GXtSuZ4ImvIG0x9MhTP0rtkgt+0aT7Ftjxa741Yz8EJiw7iAY9asu1/
	rQStLtYQMxNUIPP52pgDuTBpjO6HiSA=
Received: by mail-lj1-f169.google.com with SMTP id 38308e7fff4ca-33548b0f979so17581721fa.3
        for <linux-mm@kvack.org>; Fri, 22 Aug 2025 09:56:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1755881799; x=1756486599; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=N2HS1dqu0u6/zLIQ0iklKxHGjviVaOOzJ9/vcWLgezc=;
        b=TO+toPj4ckezYqBIRa6g1SgvVztf49e8t7PAFQWAihCOHMkf/pb9bn7XmoHAF/+khy
         RYTxrxqJj/jcjMVflZFNwc8/b8mOXk8d4XFt7qJedd0zF0M2aNVZJvUvEK3Hxg8rkhmr
         jHWQ57mIeCQS3aUmJZHu0S1QPZ101FyUo1vYXhmG47KovnN4pye3MZ+8/NMklIZKcNL4
         LP6NglhmW9yo8rITHVZMcoFNsPoUbv+sPOVl+Oe6IZVqOpLuO6Wwxif1TncaKfDCSrFQ
         iOBsbmSLTFw4uB+SFSAHnlIAQ8CSUUzZzLp8sLohotDFRA8PG2d+6mozXjHm2p7vMbZH
         Tj3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755881799; x=1756486599;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=N2HS1dqu0u6/zLIQ0iklKxHGjviVaOOzJ9/vcWLgezc=;
        b=MSf3ics2id647AlU/dzellWen09w1cJVdW/0NLszhQb8R5E4WCPl3RsFzZXk/mdw4i
         IgRAGuzLHdmJeoYcRmB7GAHWcncI3w5XSRfEwLpUNkkIa2qEOO7mOuaf6XffhAS9s7mN
         bsnMSuNeqm0L1mr40I1DrN6aMlzI/cUlQ3NQhKCUPOZ//LeG/ew90V935YL/qr3QFyPm
         6tUPd+Mdg/kVBA8mQWNx25I3PGOgyieQN7NBv9oo4gmMnQS1FK3dTmAM3ASmk2WrZver
         TNoWSbFO4EQagHwWa+5/aWzBdwatNzhOgusAiBGnBoZmHEF6+toDF3/DfuyZ+qfmcNc4
         mc1A==
X-Forwarded-Encrypted: i=1; AJvYcCUOtGLLRDc7BllzxKo9pLrfIGXVgpds94JIc+BA5khueVhP9WV8rxSiOjeIlrFMnw5Z/nggLlSH7Q==@kvack.org
X-Gm-Message-State: AOJu0Ywv/OBPJgN5yeXl1dDl87ZB5AdNy/4PqFji2g0ym/DEGaALbrLM
	VXM8if6ZJAZlu+pnLcObEfld+KzLhsoIpRbk19486LcX1sLeUflUb/rl
X-Gm-Gg: ASbGncsncsRFqLx8qEiRdGoHAeD8ydrkIM8LvLhu9bHcTpY/whRmXAYVKF2RNpfv265
	yR+5p0Erq7ZYpHewxqLso89WHqw4B37DmVdqILpzVyCrZpM54JcELEGBUk2h3xoW8n0eMzS6uoU
	O1blEEUFqXil23OxBUWpIXD28Ay6Hff8KIDMZ2kIb1IMrz/q/QgvleunJ4llhxBKL+dr+TZkOuB
	fnb2SlmScg+lYpLloFs0cPJQUXPL9Sq7JYAWWEzCwwuU156QsP5rohjPkVqbZcWFRMgjaFhpx+L
	MMz5ABpr48265j740+EA4MxoZc7rRofUpJtx4YrzCjbyFM5OxUBulCXYXA5JggkrE7fcwU7IuFW
	VkXvWDaEy5srsx8w/3YA/S4MLSGhaRPPdonQCWIl78S3s7D6hp1YkqLNww/tD
X-Google-Smtp-Source: AGHT+IEz482Su99xoGjjCv8Fw83zS6L5IxLFiEqehcr0KB01nslZsEGNuILSniluBt7EM53KnnAd1w==
X-Received: by 2002:a2e:8890:0:b0:32a:ec98:e15c with SMTP id 38308e7fff4ca-33650e71a01mr8259891fa.19.1755881798161;
        Fri, 22 Aug 2025 09:56:38 -0700 (PDT)
Received: from pc636 (host-95-203-25-178.mobileonline.telia.com. [95.203.25.178])
        by smtp.gmail.com with ESMTPSA id 38308e7fff4ca-3365e5a950csm278111fa.45.2025.08.22.09.56.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 22 Aug 2025 09:56:37 -0700 (PDT)
From: Uladzislau Rezki <urezki@gmail.com>
X-Google-Original-From: Uladzislau Rezki <urezki@pc636>
Date: Fri, 22 Aug 2025 18:56:34 +0200
To: Brendan Jackman <jackmanb@google.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, peterz@infradead.org,
	bp@alien8.de, dave.hansen@linux.intel.com, mingo@redhat.com,
	tglx@linutronix.de, akpm@linux-foundation.org, david@redhat.com,
	derkling@google.com, junaids@google.com,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, reijiw@google.com,
	rientjes@google.com, rppt@kernel.org, vbabka@suse.cz,
	x86@kernel.org, yosry.ahmed@linux.dev,
	Matthew Wilcox <willy@infradead.org>,
	Liam Howlett <liam.howlett@oracle.com>,
	"Kirill A. Shutemov" <kas@kernel.org>,
	Harry Yoo <harry.yoo@oracle.com>, Jann Horn <jannh@google.com>,
	Pedro Falcato <pfalcato@suse.de>, Andy Lutomirski <luto@kernel.org>,
	Josh Poimboeuf <jpoimboe@kernel.org>, Kees Cook <kees@kernel.org>
Subject: Re: [Discuss] First steps for ASI (ASI is fast again)
Message-ID: <aKihQv8fWzZIgnAW@pc636>
References: <20250812173109.295750-1-jackmanb@google.com>
 <cdccc1a6-c348-4cae-ab70-92c5bd3bd9fd@lucifer.local>
 <DC83J9RSZZ0E.3VKGEVIDMSA2R@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DC83J9RSZZ0E.3VKGEVIDMSA2R@google.com>
X-Rspamd-Queue-Id: 70B7B1C000F
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: 9th6kymtczjpmuycootngcrynsbpemqj
X-HE-Tag: 1755881800-847461
X-HE-Meta: U2FsdGVkX1/RvMI9/NebR+/LzVnOVYHPzHQKT9a64Yg5HkUlkTBH487n2QHGBCG6plgsTPrDXLkpUcVOnyNAJ2RBp0ZLRqH8bzXHCRuOvNsfSpEB/0gp0Y5Fh+dY1eKgnU7dfYWsoo8XHX7ymhhfeRu/1g42DghVbYHi0nFJIVzR35ynZFpm7gO/gM+bVkbcb1QK1MrFgIc4yz2VWxO1Vlm9V9l3upZMCbjVUundSyGERjNWiMjC3986c8fmr3SFcV9haWD4v2i9SKPiTajzorCOJr49//+TwygaqxQCqhhCuZFj2OQa/FE2cEnRTDhwDc23WB/EglcJGG1DH8cHrmoW/dqe8UHmso8dpAMMpawNOkDPk7Pd89+CGEeWCu35PwExsYuXHk8+amazV436Cj43jUan5olaVq4olSJ54MIKq2poUhXCK/KepdVR487RvhqMLSxz6qii6j2GIAxbEsZGhMEKOO9d38H3B/BrxTPTB3RxEt59XJhLxejvwlhXeIN4c1oQ166oROPSI7RYm8vjBDuuW4LPPxLFf2PwHHi4d7raqIcg/gxgcPrHC4fvaEGXBhTkt4ZWbua0yIh+fAdQH6SzWUmyUAHgcDfzfI2NpcchLGDPuCFIItkEkfm/U8CMSMnY74BFQWWfCfZmmcc1brIQG06Ji3juHm3OQkawXwdA95lHakq+CH9QU/1WH7ZC9qKAJTJyj7BSasrN4OhJCbCVWL+4ZSf78DXFHMsrQM0Oag5uv0N1+pea9F05IBCIEFStUGzJVqe9anYhEfs4yMPMQ1zwEUmL91KnqFhPhZwd4udIS67NS/wXu1XT3qf1OqWuwSi4ctwuzes3IC4rcZR4E/t/YdJcv2Gfb0oMj8ZNG2YbQdok167fHAletxfjhZscaHwA70sGUfw/07O97B1G0/BHqUnYa7sB0uTK+gdRSsDs4W5A0CXYdRGojh28M2WYavPVz4Y3PS3
 8AFzI0K4
 AlfjDb3cxf2UPjTSoo8zQzk2jJVu4x9WqJw4jB/dsXkR26ENG2XuatJt9ReGYaOZtqVgqfrjMp6vjgXBNo6gm89CTCNI6yqwRVi+pG4fPUtOJjzgP5C4snEWfS4vWl+Vr+ilztd77QK5lm5zpUxW51Z8dIQoxXteBLnvjwq8BHGN2A53akyGvi5SoKs1I/2Y7FbcLhda65Oj6KS+GLYgu+XBP+i1nIRhdStdG2KjcFlzF7nKYO5CyxN9D2N40XpgTwGisvftYQ+xh0g/GJlIiE7/o32vFIlKbgws5JBQB/3CFtzkPEAWapHC4/kLFAHTd6Pg+Kf371QlKSMya6j6p+R0n+H0BoKT7dAKqtdXMkdoYq+ENJzAXwrGszQE5utXqTitw647f8XF3FKUdoKaHGi+8zR56gwbSOUH1Xbz2b+FwFASv2+FeQUAEzfjfOwc+51sk
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 21, 2025 at 12:15:04PM +0000, Brendan Jackman wrote:
> On Thu Aug 21, 2025 at 8:55 AM UTC, Lorenzo Stoakes wrote:
> > +cc Matthew for page cache side
> > +cc Other memory mapping folks for mapping side
> > +cc various x86 folks for x86 side
> > +cc Kees for security side of things
> >
> > On Tue, Aug 12, 2025 at 05:31:09PM +0000, Brendan Jackman wrote:
> >> .:: Intro
> >>
> >> Following up to the plan I posted at [0], I've now prepared an up-to-date ASI
> >> branch that demonstrates a technique for solving the page cache performance
> >> devastation I described in [1]. The branch is at [5].
> >
> > Have looked through your branch at [5], note that the exit_mmap() code is
> > changing very soon see [ljs0]. Also with regard to PGD syncing, Harry introduced
> > a hotfix series recently to address issues around this generalising this PGD
> > sync code which may be usefully relevant to your series.
> >
> > [ljs0]:https://lore.kernel.org/linux-mm/20250815191031.3769540-1-Liam.Howlett@oracle.com/
> > [ljs1]:https://lore.kernel.org/linux-mm/20250818020206.4517-1-harry.yoo@oracle.com/
> 
> Thanks, this is useful info.
> 
> >>
> >> The goal of this prototype is to increase confidence that ASI is viable as a
> >> broad solution for CPU vulnerabilities. (If the community still has to develop
> >> and maintain new mitigations for every individual vuln, because ASI only works
> >> for certain use-cases, then ASI isn't super attractive given its complexity
> >> burden).
> >>
> >> The biggest gap for establishing that confidence was that Google's deployment
> >> still only uses ASI for KVM workloads, not bare-metal processes. And indeed the
> >> page cache turned out to be a massive issue that Google just hasn't run up
> >> against yet internally.
> >>
> >> .:: The "ephmap"
> >>
> >> I won't re-hash the details of the problem here (see [1]) but in short: file
> >> pages aren't mapped into the physmap as seen from ASI's restricted address space.
> >> This causes a major overhead when e.g. read()ing files. The solution we've
> >> always envisaged (and which I very hastily tried to describe at LSF/MM/BPF this
> >> year) was to simply stop read() etc from touching the physmap.
> >>
> >> This is achieved in this prototype by a mechanism that I've called the "ephmap".
> >> The ephmap is a special region of the kernel address space that is local to the
> >> mm (much like the "proclocal" idea from 2019 [2]). Users of the ephmap API can
> >> allocate a subregion of this, and provide pages that get mapped into their
> >> subregion. These subregions are CPU-local. This means that it's cheap to tear
> >> these mappings down, so they can be removed immediately after use (eph =
> >> "ephemeral"), eliminating the need for complex/costly tracking data structures.
> >
> > OK I had a bunch of questions here but looked at the code :)
> >
> > So the idea is we have a per-CPU buffer that is equal to the size of the largest
> > possible folio, for each process.
> >
> > I wonder by the way if we can cache page tables rather than alloc on bring
> > up/tear down? Or just zap? That could help things.
> 
> Yeah if I'm catching your gist correctly, we have done a bit of this in
> the Google-internal version. In cases where it's fine to fail to map
> stuff (as is the case for ephmap users in this branch) you can just have
> a little pool of pre-allocated pagetables that you can allocate from in
> arbitrary contexts. Maybe the ALLOC_TRYLOCK stuff could also be useful
> here, I haven't explored that.
> 
> >>
> >> (You might notice the ephmap is extremely similar to kmap_local_page() - see the
> >> commit that introduces it ("x86: mm: Introduce the ephmap") for discussion).
> >
> > I do wonder if we need to have a separate kmap thing or whether we can just
> > adjust what already exists?
> 
> Yeah, I also wondered this. I think we could potentially just change the
> semantics of kmap_local_page() to suit ASI's needs, but I'm not really
> clear if that's consistent with the design or if there are perf
> concerns regarding its existing usecase. I am hoping once we start to
> get the more basic ASI stuff in, this will be a topic that will interest
> the right people, and I'll be able to get some useful input...
> 
> > Presumably we will restrict ASI support to 64-bit kernels only (starting with
> > and perhaps only for x86-64), so we can avoid the highmem bs.
> 
> Yep.
> 
> >>
> >> The ephmap can then be used for accessing file pages. It's also a generic
> >> mechanism for accessing sensitive data, for example it could be used for
> >> zeroing sensitive pages, or if necessary for copy-on-write of user pages.
> >>
> >> .:: State of the branch
> >>
> >> The branch contains:
> >>
> >> - A rebased version of my "ASI integration for the page allocator" RFC [3]. (Up
> >>   to "mm/page_alloc: Add support for ASI-unmapping pages")
> >> - The rest of ASI's basic functionality (up to "mm: asi: Stop ignoring asi=on
> >>   cmdline flag")
> >> - Some test and observability conveniences (up to "mm: asi: Add a tracepoint for
> >>   ASI page faults")
> >> - A prototype of the new performance improvements (the remainder of the
> >>   branch).
> >>
> >> There's a gradient of quality where the earlier patches are closer to "complete"
> >> and the later ones are increasingly messy and hacky. Comments and commit message
> >> describe lots of the hacky elements but the most important things are:
> >>
> >> 1. The logic to take advantage of the ephmap is stuck directly into mm/shmem.c.
> >>    This is just a shortcut to make its behaviour obvious. Since tmpfs is the
> >>    most extreme case of the read/write slowdown this should give us some idea of
> >>    the performance improvements but it obviously hides a lot of important
> >>    complexity wrt how this would be integrated "for real".
> >
> > Right, at what level do you plan to put the 'real' stuff?
> >
> > generic_file_read_iter() + equivalent or something like this? But then you'd
> > miss some fs obv., so I guess filemap_read()?
> 
> Yeah, just putting it into these generic stuff seemed like the most
> obvious way, but I was also hoping there could be some more general way
> to integrate it into the page cache or even something like the iov
> system. I did not see anything like this yet, but I don't think I've
> done the full quota of code-gazing that I'd need to come up with the
> best idea here. (Also maybe the solution becomes obvious if I can find
> the right pair of eyes).
> 
> Anyway, my hope is that the number of filesystems that are both a) very
> special implementation-wise and b) dear to the hearts of
> performance-sensitive users is quite small, so maybe just injecting into
> the right pre-existing filemap.c helpers, plus one or two
> filesystem-specific additions, already gets us almost all the way there.
> 
> >>
> >> 2. The ephmap implementation is extremely stupid. It only works for the simple
> >>    shmem usecase. I don't think this is really important though, whatever we end
> >>    up with needs to be very simple, and it's not even clear that we actually
> >>    want a whole new subsystem anyway. (e.g. maybe it's better to just adapt
> >>    kmap_local_page() itself).
> >
> > Right just testing stuff out, fair enough. Obviously not an upstremable thing
> > but sort of test case right?
> 
> Yeah exactly. 
> 
> Maybe worth adding here that I explored just using vmalloc's allocator
> for this. My experience was that despite looking quite nicely optimised
> re avoiding synchronisation, just the simple fact of traversing its data
> structures is too slow for this usecase (at least, it did poorly on my
> super-sensitive FIO benchmark setup).
> 
Could you please elaborate here? Which test case and what is a problem
for it?

You can fragment the main KVA space where we use a rb-tree to manage
free blocks. But the question is how important your use case and
workload for you?

Thank you!

--
Uladzislau Rezki


Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A4D84CCFA13
	for <linux-mm@archiver.kernel.org>; Thu,  6 Nov 2025 23:56:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CBCBC8E0005; Thu,  6 Nov 2025 18:56:14 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C938E8E0002; Thu,  6 Nov 2025 18:56:14 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BD1628E0005; Thu,  6 Nov 2025 18:56:14 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id AC1AD8E0002
	for <linux-mm@kvack.org>; Thu,  6 Nov 2025 18:56:14 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 4CAFA87D17
	for <linux-mm@kvack.org>; Thu,  6 Nov 2025 23:56:14 +0000 (UTC)
X-FDA: 84081843468.29.25C8F24
Received: from out-183.mta1.migadu.com (out-183.mta1.migadu.com [95.215.58.183])
	by imf09.hostedemail.com (Postfix) with ESMTP id 5B29914000F
	for <linux-mm@kvack.org>; Thu,  6 Nov 2025 23:56:12 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=j2wvssLd;
	spf=pass (imf09.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.183 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762473372;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wGQCjkfCEjQXXmAAtqWjaaeJ29j6gKbahZ5m7Q+7IDo=;
	b=c5beKGB9pCeVCr5hZs6b2fviGj5USQZZZnD/wEEFd9foaxmt7+ExKlpuF3xwWuwU2XSF8I
	dHh2kM+FQ8cSa0oMKR+t+1wZ3sIU7Sr7olH6kxE6EJSZ0c6jk38pR50ameO3GBVwtfZcvh
	WfwCwcvvIBdORI9z/6Tkd089A4pG9Is=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=j2wvssLd;
	spf=pass (imf09.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.183 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762473372; a=rsa-sha256;
	cv=none;
	b=e7iQyXkEnj0brc38K9Q5bRf7pmGJdypGZkq1P2yx1CRh4icFvwnKtZON/QrHGt0R6FqbUw
	gi1fFva7zM8XS4rVIkX9hPR1/NiQpAIMKFSrcSHaHtyloqsg5h8FlXqhemMJyMquutMWLO
	2+75ONK4fiDmUAITbYws+8H+2PAhg88=
Date: Thu, 6 Nov 2025 15:55:59 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1762473370;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=wGQCjkfCEjQXXmAAtqWjaaeJ29j6gKbahZ5m7Q+7IDo=;
	b=j2wvssLdIAJwGLdiSwv+8Cm3wGBQ0K/g96eIbosBcuZ8GgxR82zGjOHEXkd+yZw5aS+ehK
	VukZps16+SNYzrm3jTCBoYtnZyn9poIBDqK1gzU4tv9o6Q6wUuLAwGm7RzxhKWcvGfwah8
	nTekdmNAQVjsqGbIn5SxwPqdIE/HBlY=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Leon Huang Fu <leon.huangfu@shopee.com>
Cc: akpm@linux-foundation.org, cgroups@vger.kernel.org, corbet@lwn.net, 
	hannes@cmpxchg.org, inwardvessel@gmail.com, jack@suse.cz, joel.granados@kernel.org, 
	kyle.meyer@hpe.com, lance.yang@linux.dev, laoar.shao@gmail.com, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	mclapinski@google.com, mhocko@kernel.org, muchun.song@linux.dev, 
	roman.gushchin@linux.dev, yosry.ahmed@linux.dev
Subject: Re: [PATCH mm-new v2] mm/memcontrol: Flush stats when write stat file
Message-ID: <blygjeudtqyxk7bhw5ycveofo4e322nycxyvupdnzq3eg7qtpo@cya4bifb2dlk>
References: <6kh6hle2xp75hrtikasequ7qvfyginz7pyttltx6pkli26iir5@oqjmglatjg22>
 <20251106033045.41607-1-leon.huangfu@shopee.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251106033045.41607-1-leon.huangfu@shopee.com>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 5B29914000F
X-Stat-Signature: p64jmy7rrswyyoh3tx31ig7trhsiczkb
X-Rspam-User: 
X-HE-Tag: 1762473372-24287
X-HE-Meta: U2FsdGVkX193lHhvUuGznHnj2jTW4YcOoR/9hd3d5GY5+cG0m8D1MVIXkRAMABOEUERqPT9ozR37AEOukD3vPLndHBxVodFfgyhAxO+bYkBiNl2Mpe39bcU+8Cwq5eLoWQCeWigBJ4yw9t/HnVCernusAtDendh94w9xQY9q0wi+NQLz5lHXGSojZ1nuo/+IQLLz5m8yjiEKSk/lWTHoXF6OxxOQyz7DQcb+wm83/5GyL7MeICRhmCOZRnawawlGUNKPbGmDo99KzJxepXUfnEEGrQgeOMW1VnFy3kkCPya1r7I1raM29lhxvMcpGedwVBNtbH8zzRCvryGoddkc2+3gGfBKS6I8ioxQGj45TZlXiEHKl2dxw/8+gQV5fdDylwZXJ3LjdxQHdo4XD3FCn93kBaYbiRUNFKkHi6SJm9R0hqKggl/pGPRC7VPDa73T21k5Na7h4hoip1NHDEL4oRhtmme4EcMh4oGSVy7T9dsqCMvsr8XIUjz5kqowEl9PV2V8NSkpTNdea4335mZA6y/Fv6g2t4PHVyLqGesrU9kj6bmvV/x5+mcGZh9BRPdBTLHcqEP2DmSO2XFul73cCzVzRch+y7OPk6QoDzAlC/2qZmKT/jxyt2hx4d25/Vk+Th5T2IETwwF4jbbYXXFcJ5u7A1xeOKdIgi+HB/FkL3/8QY876ORIW3wC7QDRqEKWIRI9zJpSzrWazEjwCGpsCxRBcb+Med8rxqfHExBRvZmkBdfWCyw9jytYyyxb/iq0/xcVOTpycl/x5BP4KpCpT0Sq6f63dzKIpNZIZlBjUQm1HF6gD24+kDMUFXMfbQGfs0tVChhsMMrAer7qLCnXVGI8k1/HUWUp1qdZxfcHM4Wty6sTNCmAIXjq001GvQhn8Ww4jIbqZk7cMHPXpUBYPqOPoeXY0WShH1N/NiV2XOCxyjmEsBznLvnNfyv71uniARMCCzXr5biZYCVOhI3
 +1oCFjnX
 1pSeXl26kyM6wNsAqp8BoDgt2f3mqwyCGozPup6tvEfnbri/GgoNDaLhial/+ofTvzMJBFg8k7DIcTOdit1lUJp/dZFLnzO9CKR0SlMMT6zMMPvUb56z1bWLUdc/Dg9+Xet6h83r8xvknCY+BCmvJlKQKFLt2ezqaPBd/y+GXePJmCmBb609/3+4XdRDH6oXRTg5SSVRzjpohSrkGRLRYXTrsVjm+44hJf4LdF5RUN7e7NrGj6+QoOzL+TChUlkyvPEyPrwxcwchPwnoyYpOyyUp42g==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Nov 06, 2025 at 11:30:45AM +0800, Leon Huang Fu wrote:
> On Thu, Nov 6, 2025 at 9:19 AM Shakeel Butt <shakeel.butt@linux.dev> wrote:
> >
> > +Yosry, JP
> >
> > On Wed, Nov 05, 2025 at 03:49:16PM +0800, Leon Huang Fu wrote:
> > > On high-core count systems, memory cgroup statistics can become stale
> > > due to per-CPU caching and deferred aggregation. Monitoring tools and
> > > management applications sometimes need guaranteed up-to-date statistics
> > > at specific points in time to make accurate decisions.
> >
> > Can you explain a bit more on your environment where you are seeing
> > stale stats? More specifically, how often the management applications
> > are reading the memcg stats and if these applications are reading memcg
> > stats for each nodes of the cgroup tree.
> >
> > We force flush all the memcg stats at root level every 2 seconds but it
> > seems like that is not enough for your case. I am fine with an explicit
> > way for users to flush the memcg stats. In that way only users who want
> > to has to pay for the flush cost.
> >
> 
> Thanks for the feedback. I encountered this issue while running the LTP
> memcontrol02 test case [1] on a 256-core server with the 6.6.y kernel on XFS,
> where it consistently failed.
> 
> I was aware that Yosry had improved the memory statistics refresh mechanism
> in "mm: memcg: subtree stats flushing and thresholds" [2], so I attempted to
> backport that patchset to 6.6.y [3]. However, even on the 6.15.0-061500-generic
> kernel with those improvements, the test still fails intermittently on XFS.
> 
> I've created a simplified reproducer that mirrors the LTP test behavior. The
> test allocates 50 MiB of page cache and then verifies that memory.current and
> memory.stat's "file" field are approximately equal (within 5% tolerance).
> 
> The failure pattern looks like:
> 
>   After alloc: memory.current=52690944, memory.stat.file=48496640, size=52428800
>   Checks: current>=size=OK, file>0=OK, current~=file(5%)=FAIL
> 
> Here's the reproducer code and test script (attached below for reference).
> 
> To reproduce on XFS:
>   sudo ./run.sh --xfs
>   for i in {1..100}; do sudo ./run.sh --run; echo "==="; sleep 0.1; done
>   sudo ./run.sh --cleanup
> 
> The test fails sporadically, typically a few times out of 100 runs, confirming
> that the improved flush isn't sufficient for this workload pattern.

I was hoping that you have a real world workload/scenario which is
facing this issue. For the test a simple 'sleep 2' would be enough.
Anyways that is not an argument against adding an inteface for flushing.



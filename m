Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 049BC10BA45F
	for <linux-mm@archiver.kernel.org>; Fri, 27 Mar 2026 09:29:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6D5D86B00B7; Fri, 27 Mar 2026 05:29:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6ADCB6B00B9; Fri, 27 Mar 2026 05:29:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5E9D66B00BA; Fri, 27 Mar 2026 05:29:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 4CDD66B00B7
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 05:29:46 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 00B988D881
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 09:29:45 +0000 (UTC)
X-FDA: 84591320772.06.DA33D4B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf18.hostedemail.com (Postfix) with ESMTP id 375EB1C0016
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 09:29:43 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=FjlZkKE8;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774603784;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ea6BXaxWAJFsRDWj64xQAhURBBpzUaWWDRG4Pks7vcQ=;
	b=XQPkQYAWTm3UwKfeUwVtV8qORchl4UU4BX5g/owl1/he55YbEJ8OyiOhTb7THkdzdZytvE
	dsH7XJnyQwRx8xEGBoynaiy2uY92wLHKJNRIka4uivO3JhBm96hn7m5SDp+/YchwIAhbe+
	eCxSIRP+Lb79GMWqIlk/H8F4QM8RXE0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774603784; a=rsa-sha256;
	cv=none;
	b=rTkp+qjxTXxstxXnTK6kIjgXZAKD6vYJiIE/tc7jnGlufm0f+oGE1yWTABSwtfGm+HMoEg
	dk9ETFWGPNkH5hvnnE6lCFsN5Tao4Y8pafUXtxZx/5YsTJdDXCn5WfafhBZ8zgJFkJFDk9
	oo2hBv2W9mG0iAZ6XKXYcdaEAcL3hZY=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=FjlZkKE8;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 3B8E44345F;
	Fri, 27 Mar 2026 09:29:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 551F9C2BC87;
	Fri, 27 Mar 2026 09:29:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774603783;
	bh=vTQoXBzSoGbvJfIlwkPLr8sIT5gradTLmH5Adve2H7w=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=FjlZkKE8ImyH5aLAYpVnl1L7USQiezExCFUH077Y1cCHroDKKUm0fOOJgLUl0w05y
	 LEjQKSwSWuyBS7wNJPO3VqJJstpV2//IQOToWFz83ZZFdFt6zXknDX2lZUPNuSunI0
	 CYfa3dEVNG10jP1Y+3Vu1Vtg4IMovwJbaLVQm7YSZMp8E4OMYFFryxsbA8g2aKaxTO
	 NKWebKSqKv2FDLLqa0gwzzBkqd+Oxqr9hogIj4TH7j3u3VsahyPcyMp3KowI9QptDR
	 altB6XDNGS0Rh5lhLj5DMQBk/5mwjnYgBobt9ksxFvAIHcuVIJGsCHIAFpGntQdsfv
	 ViLKWi/j02lfg==
Date: Fri, 27 Mar 2026 09:29:33 +0000
From: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
To: Vlastimil Babka <vbabka@suse.com>
Cc: Axel Rasmussen <axelrasmussen@google.com>, 
	Michal Hocko <mhocko@suse.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Shakeel Butt <shakeel.butt@linux.dev>, lsf-pc@lists.linux-foundation.org, 
	Johannes Weiner <hannes@cmpxchg.org>, David Hildenbrand <david@kernel.org>, 
	Qi Zheng <zhengqi.arch@bytedance.com>, Chen Ridong <chenridong@huaweicloud.com>, 
	Emil Tsalapatis <emil@etsalapatis.com>, Alexei Starovoitov <ast@kernel.org>, 
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, Kairui Song <ryncsn@gmail.com>, 
	Matthew Wilcox <willy@infradead.org>, Nhat Pham <nphamcs@gmail.com>, Gregory Price <gourry@gourry.net>, 
	Barry Song <21cnbao@gmail.com>, David Stevens <stevensd@google.com>, 
	Vernon Yang <vernon2gm@gmail.com>, David Rientjes <rientjes@google.com>, 
	Kalesh Singh <kaleshsingh@google.com>, wangzicheng <wangzicheng@honor.com>, 
	"T . J . Mercier" <tjmercier@google.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	Suren Baghdasaryan <surenb@google.com>, Meta kernel team <kernel-team@meta.com>, bpf@vger.kernel.org, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, Tal Zussman <tz2294@columbia.edu>
Subject: Re: [Lsf-pc] [LSF/MM/BPF TOPIC] Towards Unified and Extensible
 Memory Reclaim (reclaim_ext)
Message-ID: <bd7099a1-aa15-4c58-875e-1e00624a57ea@lucifer.local>
References: <20260325210637.3704220-1-shakeel.butt@linux.dev>
 <20260325190547.abb7309fb63473b57b7a90a0@linux-foundation.org>
 <acTaRgusrxfCoKqe@tiehlicka>
 <ac05d923-7871-4691-8d26-eff41b3a3db0@lucifer.local>
 <CAJHvVchSfGDubPhir0SgZfr_BcpN5oq_7AY4AZ587_ucgY4Apw@mail.gmail.com>
 <8406d210-4f68-4919-b791-c03c310a8385@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <8406d210-4f68-4919-b791-c03c310a8385@suse.com>
X-Rspamd-Queue-Id: 375EB1C0016
X-Stat-Signature: 4rhg8jtj9rkd1ijo5zc35j6y5e5zgpjf
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1774603783-852563
X-HE-Meta: U2FsdGVkX1/DnoePUSgROybsozHpp02ufPeboLbJWUNwzIm08sAuR4Z/3W9BE1UnA+XKKjfXoSC2LT9zQvSo30gnhLHSCGZszZAB5UCUGYD4mkVgru2VCGOWd9863x0uorIvju8nrBwP9JdhofJaks3o61vL5POZY23pf7vdbMLvEXo7NglvQuxINtugzPSsWJeuWtO5NUpwSHw8dKkyMYASPTsN2mg0ve4ne+tNFWJObUx8wZxNcC5o+IHI8gBPaZjdKUXS92ND9RbfZWIWpUcpA2qqiX/DAYgoL4XyOFeg03pqMoPQiNZEo1ndTfQhhypmeCu1fLXNZTIXKHCV1lXqLxE9fzHFh5FhFp6bmIOeXCbyvT01l3HaONZ5fL+dSKWAepmQnklHPxAAeeUpck2oWp05MMghSjGJPX1fyn++sJg78blzBctHQREbmQE8G1M+AT0X/imsW3mN80umAzM3ml4ZCxFRYde0LdXL4vfEiIuffhYS9cl9st10q90/9CQIckq25YKCOOno9NLx6aajRQVu8uFqO2IDJNWNY0fBvKxl9PFTUb331ZRXXQA8ogUI5OCzdT3DnmOTAPg/85tTURMt77ghwfoYj2s9c28/lfyjdibrXxMlqZcQtzdKuXvariLqnj0lyAyaBFt9TWeJ4le11BME+kr8kfIyWR4bzgnnc8ztOFqgoD9GstCdwIRWHSqLUdtifSgN5hj4G46Y8ntMZBdNUMjNpZImar6E0Kotll62N2PBnEjWQ2rDF6ZL7PYV4jss/OwAs1nbtTR9uhJmoev/5fJpz3IEzT16cbqFJtACs8GJKfVTwmwzr2FwxHvQSc6zlevuGtKFQZ08kzKvFrgUx3/IJVFnO/eLx+af7KAKishfvL9s2kC5gIFon3Wid2j8VsR/x461ZFe1RMwDPgzSsUKQ5QnUF/q4W6DX8Q3a1iYsfp+hJvUo+dWANWxLI7jUkR10JTF
 2rHUnwFS
 iaMHyQvL30pMrPBmF8bt+ZE/B4eXX6AsunCERDz0A19WdjvTJhW3Dp8To1K80aS+nsfbaT1VkCjWdTntCU+17xYO8BESFvcr2SAQHSUFW0rLFrubQM0upT4RrMs/3/j31s/yoOIlxU2ZX8UrE2eC3XfWPoU6WzP5vN0nTQMM88aLAEKl4/gKU9I4Y/ZzuXJwblLXyXBUV/nngDjYHmr4zDPEpIZc3yJOgFowlZzzvqCCQJtifmOyoQTJnvYyGpvpY2WWAXmPjO3n6MPbbfDldou2D4YVhoPNaFI76cHrkzkmngmaoaEeW5S/E2RtzjdLCor3leAD3gf6vp1gGOHXhRTYAbw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Mar 27, 2026 at 09:07:55AM +0100, Vlastimil Babka wrote:
> On 3/26/26 21:02, Axel Rasmussen via Lsf-pc wrote:
> > On Thu, Mar 26, 2026 at 1:02 AM Lorenzo Stoakes (Oracle) <ljs@kernel.org> wrote:
> >>
> >> On Thu, Mar 26, 2026 at 08:03:34AM +0100, Michal Hocko wrote:
> >> > On Wed 25-03-26 19:05:47, Andrew Morton wrote:
> >> > > On Wed, 25 Mar 2026 14:06:37 -0700 Shakeel Butt <shakeel.butt@linux.dev> wrote:
> >> > >
> >> > > > We should unify both algorithms into a single code path.
> >> > >
> >> > > I'm here to ask the questions which others fear will sound dumb.
> >> >
> >> > Not dumb at all and recently discussed here https://lore.kernel.org/all/CAMgjq7AkYOtUL2HuZjBu5dJw=RTL7W2L1+zVv=SCOyHKYwc3AA@mail.gmail.com/T/#u
> >> >
> >> > > Is it indeed the plan to maintain both implementations?  I thought the
> >> > > long-term ambition was to knock MGLRU into shape and to drop the legacy LRU?
> >
> > I think one thing we all agree on at least is, long term, there isn't
> > really a good argument for having > 1 LRU implementation. E.g., we
> > don't believe there are just irreconcilable differences, where one
> > impl is better for some workloads, and another is better for others,
> > and there is no way the two can be converged.
> >
> > On that basis, I would be hesitant to add some complex abstraction
> > layer / reclaim_ops to facilitate having two. It seems ilke it may
> > make things a bit cleaner in the short term, but long term might make
> > that end goal harder (because we'd add the task of cleaning up this
> > abstraction at some point).
> >
> > My preferred way would be more like:
> >
> > - Look for opportunities where we can deduplicate code, but without
> > adding abstraction (e.g., factor out common operations into common
> > functions both impls can call).
> > - Identify gaps where MGLRU performs worse than classic LRU, and close them.
>
> I'm afraid to identify these gaps we'd have to indeed split the MGLRU
> differences (as listed in Shakeel's proposal) in a way that they can be
> tried separately. I recall when MGLRU was proposed, we did argue that it's a
> combination of several things done differently and they should be introduced
> to the existing reclaim and validated separately. But the author refused to
> go that way.

It's unfortunate we were ok with going ahead with this anyway, I hope in the
current mm culture we'd simply say 'ok series doesn't land then'.

It feels like the 'merge by default' stuff has been both a process _and_ a
culture fail for a while honestly.

We are managing arguably _the_ most core part of the kernel (I know people will
argue on that but at it's at least up there :) and almost certainly _the_
subsystem with the most direct route to exploitable security bugs, but we've
been running it with some of the loosest merge criteria in the entire kernel.

It's patently insane.

Things are changing however!

Cheers, Lorenzo


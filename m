Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 52FDEE8B386
	for <linux-mm@archiver.kernel.org>; Wed,  4 Feb 2026 01:12:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5DF596B0005; Tue,  3 Feb 2026 20:12:09 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5B6D86B0088; Tue,  3 Feb 2026 20:12:09 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4B5D16B008A; Tue,  3 Feb 2026 20:12:09 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 34D116B0005
	for <linux-mm@kvack.org>; Tue,  3 Feb 2026 20:12:09 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id A9322140623
	for <linux-mm@kvack.org>; Wed,  4 Feb 2026 01:12:08 +0000 (UTC)
X-FDA: 84404997936.07.2652D70
Received: from lgeamrelo07.lge.com (lgeamrelo07.lge.com [156.147.51.103])
	by imf23.hostedemail.com (Postfix) with ESMTP id E39F6140009
	for <linux-mm@kvack.org>; Wed,  4 Feb 2026 01:12:03 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=none;
	spf=pass (imf23.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.51.103 as permitted sender) smtp.mailfrom=youngjun.park@lge.com;
	dmarc=pass (policy=none) header.from=lge.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770167527;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=4R0bt879oyhIGFlShR/msQBmFfVqEW07jJEPuNoyt/0=;
	b=oUhO6n1dXQQM1UiCspiPT5QTxj4xuubgtzTHHe/zWDh6iQc9+/F+MXSMK5JPnX+B2TZ8Sx
	d3/XQRWI7voYEyEeknsi/ssLa86X22531MjJaJ/B6sgd80S61ZL6z+EjxnSpsMtYeBKElW
	8e53n/fliujTxXokIiGtBLqHN0mhVmw=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=none;
	spf=pass (imf23.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.51.103 as permitted sender) smtp.mailfrom=youngjun.park@lge.com;
	dmarc=pass (policy=none) header.from=lge.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770167527; a=rsa-sha256;
	cv=none;
	b=c/7KunkilsMy3RBOJIZiLi0BN/t/KnIM/jtKQgdVzxKqFsM5PMfI1uHGMC90ojKfnHseZ/
	fgLEdAtelERExRp6Kf6o5V1SVSDjh+cwLoF0RLMWRZ2uJ0edDo90fo1QheL4r5AGv1Hnz0
	NqheCPYeAxnXewlwaKHvqaH02UzgHGI=
Received: from unknown (HELO yjaykim-PowerEdge-T330) (10.177.112.156)
	by 156.147.51.103 with ESMTP; 4 Feb 2026 10:12:00 +0900
X-Original-SENDERIP: 10.177.112.156
X-Original-MAILFROM: youngjun.park@lge.com
Date: Wed, 4 Feb 2026 10:11:59 +0900
From: YoungJun Park <youngjun.park@lge.com>
To: Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>
Cc: akpm@linux-foundation.org, chrisl@kernel.org, kasong@tencent.com,
	hannes@cmpxchg.org, mhocko@kernel.org, roman.gushchin@linux.dev,
	shakeel.butt@linux.dev, muchun.song@linux.dev,
	shikemeng@huaweicloud.com, nphamcs@gmail.com, bhe@redhat.com,
	baohua@kernel.org, cgroups@vger.kernel.org, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, gunho.lee@lge.com,
	taejoon.song@lge.com, youngjun.park@lge.com
Subject: Re: [RFC PATCH v3 3/5] mm: memcontrol: add interface for swap tier
 selection
Message-ID: <aYKc3yFmlZzKG3wr@yjaykim-PowerEdge-T330>
References: <20260131125454.3187546-1-youngjun.park@lge.com>
 <20260131125454.3187546-4-youngjun.park@lge.com>
 <ixlef27mi6vm5pek775kyddai7rkzls6mjo434rvwwp5gulcp5@n3uzy35ta7me>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ixlef27mi6vm5pek775kyddai7rkzls6mjo434rvwwp5gulcp5@n3uzy35ta7me>
X-Stat-Signature: kgofagbndwcebnfsk1ckb66jkygcr6z4
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: E39F6140009
X-HE-Tag: 1770167523-934977
X-HE-Meta: U2FsdGVkX1+uVvIoxrfKRc7mrekeZSCyFhgfBO82oHs/fAUFuipV9gQgAHXMKlLWAac0ZMd/Rv+xLrKRYqWBgOTCY0imafSkY7SSdb3tkSClcUz0dwVfLEe7NIScntgfvyEAnEohvpFL8f4POwXVZhXw956MbCYAg2u7zfyqVi6EV8S7n9bzbP0rUJkvEvL73uo8ygyHOTp9laa5cqq9ejkTrnFAvSS+cvS2p/PLyEGh3aibQmbI0MiCylgB0084+OaUA4OrBfvziLAvJ0o6JM7MnYP9ZP/chbTAfIqmpiYOSwgpQZBjCKkpU9Jum/IrsriQ1wJirHO00qtZwX6R4ooIw9p3UV+m1uTwNPj9P3hbMNl3hQepiPA/ZrYuoT37vnxmCN82Z+WbLxJXsxNVKLa21QMPWlyXzLoYu62z9xZKirj4zIXLSzLR6C08JaCuQZTGdw8p+tImagO1SPbvce93rv0Q5ui6XrohyUZ8j1D6tFI7M/nFoVgf+1Zp9I43j2tOle7q8MyWt5eEglI195DD/zoC06kCle/BUsRI0vIHlJGLj3lYK3vzP9YxTmUS64Q12Y4OxNpyDzW8kaz//PWyQFOqLdu2T4IZEcsLxHORz2yG8QqdQ9AVVNKJ9NlI2Y4SwMmcdMxaxaVrIEJoSZoRdFUQ1ba8u9su87fpEWSUnn/L2+DipcJBvdhNwZZCJHGIXIsYxPBTGznhOMX02eiOrsld7B4Maxox/XSbCPy51jje3MmMJgiQAUzDBqL5wSc661tSHRQJkS2hjmHhySQMHoAV07CaQ6ruu2kXG/Kj1vxHAoXMe4nOrFYIIbUHuTuMLSJ+sLPJkRoPjy4h1m7wYUg5eaI+2CVN2bVBWfPWZnOPm/mmd7Z4cAHVDtDwx6xhIMe9R0uNJN+59S7FqvGdocAapme3gsEKlWoMsfNSrwzp+3zZRWJMUWnZclGB6iwvV+ZxJeZrpQY/ccn
 JA+1kUhy
 lgmCgftxuEZXPzA0KSryXXCVneN2nt45EgrI2h9Rit9hl+sgLFqFZkbcucHAdIgNQ1/gxyIom8UCbQaQktjaoJp4zIO4ITdEN34evuNM4iVxkojoJudOCwsM+9JAr5Mddb/yWmRxLtgvGZYHr7mT8HWafd7A++uD/pfeUDPrVQblnjb1hLEsu4Md2Oqu8JW91/xIMv85Cz2ErjSY2EAdmEg3DdMat+Ni7UFF9oVUs0hAAkAvIbJqloEYnFbmOIl0XVfes/C85gRRjtT0=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Feb 03, 2026 at 11:54:41AM +0100, Michal Koutný wrote:
> Hi.
> 
> This is merely the API feedback.
> 
> (Feedback to the propsed form, I'm not sure whether/how this should
> interact with memory.swap.max (formally cf io.weight).)
> 
> On Sat, Jan 31, 2026 at 09:54:52PM +0900, Youngjun Park <youngjun.park@lge.com> wrote:
> > This patch integrates the swap tier infrastructure with cgroup,
> > enabling the selection of specific swap devices per cgroup by
> > configuring allowed swap tiers.
> > 
> > The new `memory.swap.tiers` interface controls allowed swap tiers via a mask.
> > By default, the mask is set to include all tiers, allowing specific tiers to
> > be excluded or restored. Note that effective tiers are calculated separately
> > using a dedicated mask to respect the cgroup hierarchy. Consequently,
> > configured tiers may differ from effective ones, as they must be a subset
> > of the parent's.
> > 
> > Note that cgroups do not pin swap tiers. This is similar to the
> > `cpuset` controller, which does not prevent CPU hotplug. This
> > approach ensures flexibility by allowing tier configuration changes
> > regardless of cgroup usage.
> > 
> > Signed-off-by: Youngjun Park <youngjun.park@lge.com>
> > ---
> >  Documentation/admin-guide/cgroup-v2.rst | 27 ++++++++
> >  include/linux/memcontrol.h              |  3 +-
> >  mm/memcontrol.c                         | 85 +++++++++++++++++++++++
> >  mm/swap_state.c                         |  6 +-
> >  mm/swap_tier.c                          | 89 ++++++++++++++++++++++++-
> >  mm/swap_tier.h                          | 39 ++++++++++-
> >  mm/swapfile.c                           |  4 ++
> >  7 files changed, 246 insertions(+), 7 deletions(-)
> > 
> > diff --git a/Documentation/admin-guide/cgroup-v2.rst b/Documentation/admin-guide/cgroup-v2.rst
> > index 7f5b59d95fce..776a908ce1b9 100644
> > --- a/Documentation/admin-guide/cgroup-v2.rst
> > +++ b/Documentation/admin-guide/cgroup-v2.rst
> > @@ -1848,6 +1848,33 @@ The following nested keys are defined.
> >  	Swap usage hard limit.  If a cgroup's swap usage reaches this
> >  	limit, anonymous memory of the cgroup will not be swapped out.
> >  
> > +  memory.swap.tiers
> > +        A read-write nested-keyed file which exists on non-root
> 
> "nested-keyed" format is something else in this document's lingo, see
> e.g. io.stat.
> 
> I think you wanted to make this resemble cgroup.subtree_control (which
> is fine).

You are right, I used the wrong expression. 
Simply describing it as a "file" seems sufficient.

> 
> > +        cgroups. The default is to enable all tiers.
> > +
> > +        This interface allows selecting which swap tiers a cgroup can
> > +        use for swapping out memory.
> > +
> > +        The effective tiers are inherited from the parent. Only tiers
> > +        effective in the parent can be effective in the child. However,
> > +        the child can explicitly disable tiers allowed by the parent.
> > +
> > +        When read, the file shows two lines:
> > +          - The first line shows the operation string that was
> > +            written to this file.
> > +          - The second line shows the effective operation after
> > +            merging with parent settings.
> 
> The convention (in cpuset) is to split it in two files like
> memory.swap.tiers and memory.swap.tiers.effective.

I will separate the two according to the convention. 
Thanks for correction.

> > +
> > +        When writing, the format is:
> > +          (+/-)(TIER_NAME) (+/-)(TIER_NAME) ...
> > +
> > +        Valid tier names are those configured in
> > +        /sys/kernel/mm/swap/tiers.
> > +
> > +        Each tier can be prefixed with:
> > +          +    Enable this tier
> > +          -    Disable this tier
> > +
> 
> I believe these are only superficial adjustments not affecting the
> implementation.
> 
> Thanks,
> Michal

Thanks for the review, Michal.
Youngjun Park


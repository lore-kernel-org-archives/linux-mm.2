Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E8E33CD37BE
	for <linux-mm@archiver.kernel.org>; Mon, 11 May 2026 18:14:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 224266B008A; Mon, 11 May 2026 14:14:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1FBAD6B008C; Mon, 11 May 2026 14:14:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1395C6B0093; Mon, 11 May 2026 14:14:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 052CA6B008A
	for <linux-mm@kvack.org>; Mon, 11 May 2026 14:14:30 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id A474C1C05F7
	for <linux-mm@kvack.org>; Mon, 11 May 2026 18:14:29 +0000 (UTC)
X-FDA: 84755939058.07.631ECD8
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf26.hostedemail.com (Postfix) with ESMTP id 81FB4140016
	for <linux-mm@kvack.org>; Mon, 11 May 2026 18:14:27 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Yik00MFs;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of kees@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kees@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778523267;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kpHOxTve9XIr5bxGBFcEdyYj3Fxv9ZQLGiMAU/XtJks=;
	b=dvWqHPaTy2FgI8e8Bbf11RcfcZ3L+ziCfZdBaaXydymtpQ1kCcdfOeHI2cRX8a9rse/oYD
	/Gh+DbEJQvmKIMmAMq9wFjYGKY1yp1onooc11uO/Ox8NqqqmjDxq50gaFfZBXYFvCFP8Qm
	bAtzuGh0TXiFXw80cP1MYSsYUoXuEck=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778523267; a=rsa-sha256;
	cv=none;
	b=yZaOoBmP/AFJhT9nl4UkTv1yvrGO9D4xFlLVQ+F9j4OR6k0UTbLACz88yHhrtOEqhBe88N
	bARl150msOt340UOIZrM5Gw0N9Svl8tbctW9sEfUYmeN0eli0m3cKk17zt1RybdHx4GM6W
	udT1NS2V/caAituXlPJj2C92PMzCumU=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Yik00MFs;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of kees@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kees@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 8ED5842AAB;
	Mon, 11 May 2026 18:14:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6274CC2BCB0;
	Mon, 11 May 2026 18:14:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778523266;
	bh=kYJAjhBLTK5188tkpp895MuAn5ZwQjFTPdmZuwhzdKQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Yik00MFsZZExqbxCaceAPJlMwLQrmJmplumBUszioAlx10aTI4RdUFOzjXo+x+c5u
	 /VZ6lGT4BZS+HALjze4VbOO1Pro9OETfEq58RSG64GOXUNLfBpoyrkzVnsxu2HjQPW
	 gmZdwzKpsmcDJCxfMa1NGnelSgreX+FZK15c0Rs05bF11sNGvdbSuIDjH+/77RO3F/
	 i4eCb0+n3xVp33OV69kdFRqIfPru7ydqw9Q8xz1B73DIYRHGuvEenFrzdyXLnXfzES
	 QUCSmeTH40A82aP4edYnZ8dDwBoXOb+P4FLxUoEv0Y7xclsqSNwlkWKi6e9qcA8e82
	 70fz60b4WW4dA==
Date: Mon, 11 May 2026 11:14:25 -0700
From: Kees Cook <kees@kernel.org>
To: Marco Elver <elver@google.com>
Cc: "Harry Yoo (Oracle)" <harry@kernel.org>,
	"Vlastimil Babka (SUSE)" <vbabka@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Nathan Chancellor <nathan@kernel.org>,
	Nicolas Schier <nsc@kernel.org>, Dennis Zhou <dennis@kernel.org>,
	Tejun Heo <tj@kernel.org>, Christoph Lameter <cl@gentwo.org>,
	Hao Li <hao.li@linux.dev>, David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	"Gustavo A. R. Silva" <gustavoars@kernel.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Alexander Potapenko <glider@google.com>,
	Dmitry Vyukov <dvyukov@google.com>,
	Nick Desaulniers <nick.desaulniers+lkml@gmail.com>,
	Bill Wendling <morbo@google.com>,
	Justin Stitt <justinstitt@google.com>,
	Miguel Ojeda <ojeda@kernel.org>, linux-kbuild@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	linux-hardening@vger.kernel.org, kasan-dev@googlegroups.com,
	llvm@lists.linux.dev, Andrey Konovalov <andreyknvl@gmail.com>,
	Florent Revest <revest@google.com>, Jann Horn <jannh@google.com>,
	KP Singh <kpsingh@kernel.org>,
	Matteo Rizzo <matteorizzo@google.com>,
	GONG Ruiqi <gongruiqi1@huawei.com>
Subject: Re: [PATCH v3 1/2] slab: support for compiler-assisted type-based
 slab cache partitioning
Message-ID: <202605111113.5076F0DC@keescook>
References: <20260424132427.2703076-1-elver@google.com>
 <6f2bd63a-dc02-4631-a3a5-7ec8e58a4a4e@kernel.org>
 <afkOMIPu1WNFE9MS@elver.google.com>
 <CANpmjNM261J5qefMvmUXWZGBVz-KBs7GkbpdNMfTOvNJ-=LiZQ@mail.gmail.com>
 <afz7pZADZPD4mKJr@MacBook-Air.tail10959e.ts.net>
 <af3xcFjrZSZFG846@elver.google.com>
 <rz7dt4wghum6beghfgm6suqje6jeivrensojjalfis5zeuyen7@6bj7kfpqb4q5>
 <CANpmjNNevjTo0uwo3DJdDc=PpQpyzj301kFT39OBoCNLW0A8VQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANpmjNNevjTo0uwo3DJdDc=PpQpyzj301kFT39OBoCNLW0A8VQ@mail.gmail.com>
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 81FB4140016
X-Stat-Signature: 6rxhew1g3ah6zganmbet9f5s4m7917s1
X-Rspam-User: 
X-HE-Tag: 1778523267-166632
X-HE-Meta: U2FsdGVkX193vHS2Mc6RluYuc2aceSA/A4sc9DafVPNZmRYNxgKnoxaZZSkS+/KII696aogFdiAyJpHNHOARsZHhYrQIYUcSrAirvW71BwssYX80K7nWCxUVgTvLgyVVQofZtnKc/qlaoGZYgq7z6oVkAqdE4Pq2l6w5DRL0TXkPBbs90F+L10W6ZT45+89FqTaJ5FJ9BOYv1zXO6uLZ77WE91JfdVMs3Lu57fDSgp/lo9RJIVI4aIwtKrDG14uJn2LD4c35QOUU+Mds+ZcsRmQtq7DZM8TztJPv9d0pYknxi7B7gGjhJdpVfTEesACsFHWhpvrc3014rs4yRoPS3+AeG2oiiD0glXZsHTeTcjEABRoQoGdhmGD0VAjoj8ga498z7PCnCRMSY3ctFZXGMW5+16hnsBRZL3BVlWj9limIztMdXlt5py8du3PrCf6UHQMpeGqW5Vzimq1lcxUyH4BeodyLM+Gh119PLCAy71Y7hBXzrNHdqjyLP8Kowjbu8AjPoHsbtzwZIReB0qrHwuNXa7F/Wy+42iHPe/EflUuG1Gd2nKHJaQgPspBQMZNKYEE23tlioy8cZyKULRIqVW35EivU4w373HG1VFP3ixv/bAxj/MzfMMRNrt2nDyc3ao9WzpOXyFNRMWXi2mLHyFGiN4Vvc3rb5nYhDgu+DfTXPFypifPVmFevIE1Iziubtgtevt3evkkbHdDAQxNzXYwwSqcMTmrw4DrCfLY2gdbmglhBc7pM4x4rwKsl+HnqK1I5K35SCtMxtVgUiv6zjqnJCkFaX9BkxGL3RTetAKWDVTFAzipiPPhK6nzvsfFrsF3KV0OV6j+Hox1ewQyNaSt0Un2G94SlUPQsgmEJ9RF8+flBPWR2qpPcQREjPLAYKjEVOAYD6lceUaQnxTcQjfcevDUWF7OQWhhaPsC0UazzDS4ar/5b0+DbtOE8VRba28vOtBSboWXzm+H7QnC
 VZ6FLbB6
 GjRT2G75KaOBYinq5N9eFCPv0zTw6faYtthE6GVJ8JPoJGbQyuS37huEl2AtSM0VrXArS4wxKjWeGE4rmCtwPh8LE73NH640f5r+WxLvNgSIU0XENwkTowZEKKBpkSp1CDu0i38knmrJ5g4HXZiSX1rjO58tpO9a+Dbs957nx1/CakzuOyBItxD18pxYkjef/ZUblBbFW4e1HJ9YVGcOtvinh8jAwFdnOMZ+bWeSn/GBVmSQxlv16rfu1RbZMoDFARUho5UJ/F5rGZ03QySbjvzxfIMr1dMviz8FNc9LHyox1Wpqk3pLwMzI+d3r7o1nn95Fh0SN+nIC/CwvPt9SdscM8ckmVLCfaxbrLo3ysQh7FXvWb8SKyOXAKPwA2t3O95kyySbb6BnB8AtNGQluRUervM95cmg10clOeaOrclp/HNqEGZMTeMQWu2g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, May 11, 2026 at 11:34:53AM +0200, Marco Elver wrote:
> On Mon, 11 May 2026 at 10:31, 'Harry Yoo (Oracle)' via kasan-dev
> <kasan-dev@googlegroups.com> wrote:
> >
> > On Fri, May 08, 2026 at 04:21:36PM +0200, Marco Elver wrote:
> > > I think I have a solution for this mess, see below.
> > >
> > > I would not send it as 1 series, but only include the slab changes (+
> > > instruction_pointer.h change to introduce _CODE_LOCATION_) as one
> > > series, to go through the slab tree. The rest of the patches would go to
> > > respective arch maintainers.
> >
> > I'm assuming this will be a follow-up and reviewing patch 1
> > (and waiting for Jon's thuoghts on patch 2)
> 
> I'll be sending v4 shortly.
> 
> > > diff --git a/include/linux/instruction_pointer.h b/include/linux/instruction_pointer.h
> > > index aa0b3ffea935..dfe73aafddb8 100644
> > > --- a/include/linux/instruction_pointer.h
> > > +++ b/include/linux/instruction_pointer.h
> > > @@ -8,6 +8,30 @@
> > >
> > >  #ifndef _THIS_IP_
> > >  #define _THIS_IP_  ({ __label__ __here; __here: (unsigned long)&&__here; })
> > > +/*
> > > + * The current generic definition of _THIS_IP_ is considered broken by GCC [1]
> > > + * and Clang [2]. In particular, the address of a label is only expected to be
> > > + * used with a computed goto.
> > > + *
> > > + *   [1] https://gcc.gnu.org/bugzilla/show_bug.cgi?id=120071
> > > + *   [2] https://github.com/llvm/llvm-project/issues/138272
> > > + *
> > > + * Mark it as broken, so that appropriate fallback options can be implemented
> > > + * for architectures that do not define their won _THIS_IP_.

Teeny typo above: "won" -> "own".

> > > + */
> > > +#define HAS_BROKEN_THIS_IP
> > > +#endif
> >
> > As long as _THIS_IP_ is broken on some arches, it cannot be used anyway
> > when in a general API that can be used by arbitrary users?
> 
> It more or less works today, and for debugging or tracing it's "good
> enough" in most cases.
> 
> The plan would be to phase out the generic _THIS_IP_ once all
> architectures have a correct _THIS_IP_ implementation.
> 
> > Is it something that can be fixed in all arches over time?
> 
> Yes, I have patches for that.
> 
> > > +/*
> > > + * _CODE_LOCATION_ provides a unique identifier for the current code location.
> > > + * When _THIS_IP_ is broken (generic version), we fall back to a static marker
> > > + * which guarantees uniqueness and resolves to a constant address at link time,
> > > + * avoiding runtime overhead and compiler optimizations breaking it.
> > > + */
> > > +#ifdef HAS_BROKEN_THIS_IP
> > > +#define _CODE_LOCATION_ ({ static const char __here; (unsigned long)&__here; })
> >
> > Nice!
> >
> > Yes, we don't really need the exact code location
> > for partitioning kmalloc caches.
> >
> > IIRC lockdep does a similar thing to define lock classes (unique for
> > each lock init location)
> >
> > > +#else
> > > +#define _CODE_LOCATION_ _THIS_IP_
> > >  #endif
> >
> > Probably we don't need this fallback?
> 
> x86-64 is the only arch that has working fast _THIS_IP_, and adding
> static __here markers to bss is rather wasteful.
> 
> More architectures will be supporting _THIS_IP_ properly once I get to
> send the patches. The mainstream architectures all have a reasonable
> and fast way to get the current IP, so we don't need to waste bss
> space there.

Thanks for finding a solution for this!

-- 
Kees Cook


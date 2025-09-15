Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C6DCECAC597
	for <linux-mm@archiver.kernel.org>; Mon, 15 Sep 2025 13:44:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2E1018E001B; Mon, 15 Sep 2025 09:44:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2B9118E0018; Mon, 15 Sep 2025 09:44:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1CE778E001B; Mon, 15 Sep 2025 09:44:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 0B0B68E0018
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 09:44:08 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id D0E1BBA94C
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 13:44:07 +0000 (UTC)
X-FDA: 83891603334.21.5849919
Received: from mail-qk1-f175.google.com (mail-qk1-f175.google.com [209.85.222.175])
	by imf07.hostedemail.com (Postfix) with ESMTP id C712F4000C
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 13:44:05 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=cmpxchg-org.20230601.gappssmtp.com header.s=20230601 header.b=l7wYtFmn;
	spf=pass (imf07.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.222.175 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757943846;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=q6oMWOUjEhTHaIkKCNJfxWZcVknSr0QJ4euJbdXpCDU=;
	b=lnjixsjBYA/J8hWLQdSDt9HM2Zskj+DRaPU5MnQthRldilrkfXJwFXTcjF43aRIfBnNJFy
	QOEW9mhHb57ERxLNR5X0PyicCGcKItlee4vPMcXzbuT6+lAVhDlGdLTZNek3SJuQQsYQQ+
	jhoHYodrhO31rFMpGyMGz2bdj2GNJeI=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=cmpxchg-org.20230601.gappssmtp.com header.s=20230601 header.b=l7wYtFmn;
	spf=pass (imf07.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.222.175 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757943846; a=rsa-sha256;
	cv=none;
	b=QCevcB9Tzok4FHD8pKCNmneROtZG8FbXBmx6rI7WThkeD7VDYKR4qDQ2I3ESFrRxXWyfvb
	ec0VJCDgy0IeeA1I+GZVIwXdkLCG9pp0lxH1TADMxvnmxrW2Y3UF0XiW5YWXscrm7UZ4XS
	JHCpvl7c5NH1u69T8KMmkS6HOBAPyww=
Received: by mail-qk1-f175.google.com with SMTP id af79cd13be357-826311c1774so255488885a.2
        for <linux-mm@kvack.org>; Mon, 15 Sep 2025 06:44:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20230601.gappssmtp.com; s=20230601; t=1757943845; x=1758548645; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=q6oMWOUjEhTHaIkKCNJfxWZcVknSr0QJ4euJbdXpCDU=;
        b=l7wYtFmn/k66F6JZ1YPXozda7BGfpNjEF264/odCd290biWnTa5Ou7YF3TMFeaLWyG
         ZWpHNbcwgaCM/av4KQ900Bh5WSPkVvD5MkFzbPZv+JHhDXBCbfYF2d5iR2NIOsL2ZM72
         bihKbl9uBC26+u7K2vwSJRVcgBzdq16Gqk7mKTC86DV5K7Un4XC7bdIWFswoIizfGwxk
         4NxihyHtjT9sDNuSCN63ivJ/KXTmPk9qo6SP6/mZOkaB1VnK5oWTXDqdwh+64fK11DMZ
         DRORtjJ6rQqjYm/RrVSW/MFHsRgV6KAiGRcYDGbWS6qANTtHk0YL9SMx8PjowFb9iXsX
         8tyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757943845; x=1758548645;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=q6oMWOUjEhTHaIkKCNJfxWZcVknSr0QJ4euJbdXpCDU=;
        b=Sgy7YKlMqFuIDLHqQZCa1o0prIXJlfmgtBNCYPxXMR5d31mkUo/g0QsJpU8MhgHxiI
         +YFumnjfFWf7mrOUU8l8CjAlFV865P4OY+p+8hZUoHqjIQAtxwnW8GADESgITa9zMiya
         7s8nESKAJ9jECbsNH/PFk37ylmcCWF/tIkPa2dyLD4YctKM1iBfYwCoVImHfT/0ZHYbw
         1/E7Bvb85kAW5OYOrWvBkQEjAK9lrPbvDbMna1njksEO7dbxap/qbXuObx7wq93l1r1K
         8lJji7wfO5BNm7evix+ciC81MuFXN4JbwXA9CFKYeQAuAz1HhzlBJxnmh158TNl/2t9U
         XSsw==
X-Forwarded-Encrypted: i=1; AJvYcCVqv2mTPA+DMFPVbqpkK2MZdCKITGunvmW9ypPa3UkcuAzHHWNgHVO7Pl+KO8BRil4tPKx1J99c8g==@kvack.org
X-Gm-Message-State: AOJu0YyVFI75E1uOVAXt+6zDes3oLids7jf0gjZfjXeN5rGjMaT4EpPn
	xLLe8Vwud6gZWQCIf25nJS59fj8GaSWM7VZiiTXyyibFYerTwtf0xjcE90wSfapLm8w=
X-Gm-Gg: ASbGncvwJv8tKTrLVk4bLTh+mJ0Lq7NVuZqUP/dPWMV5bm6c2jXXD4pvrYEF4odvxUx
	P1jYjKoCdWq3aGrDTPMlj99OEpqLu8nKdjXnoX4LNn2iXk+6115bjvCgR9liKwcyNELF5Frq3/y
	8PYl+6pIe3I99CqFIu6maQCIaMg1ShQZ0IaTkFDF577VS0czOjRphQyFCVa81pr9npyEP9eGiBp
	y6kq2PGtBoyRjEwuBstWREslXp5vdRgOzGlB7L0nwku+oniPlWR2CCuryNf6jKNAc2iSDhXnuV4
	R5ePCJ+fUouf/6GT8y3erL7FQH4NCvgNAFeCGvvCIZgoQt8f9z4cGZhQBc5uDkujQP2WS12txXr
	mQPRPQS/Jredvr1rfJa50MQAeHm7dzUP9bDy0cSI+1g0=
X-Google-Smtp-Source: AGHT+IEpx1kLk3BJgZa+W6SfvekSSLAHkh6bU7VHRFGYegEO0mCkS/PzSHlaHZMWsZNyeolqd/d0Qw==
X-Received: by 2002:a05:620a:394f:b0:827:d7c3:cde8 with SMTP id af79cd13be357-827d7c3cf5cmr771847485a.57.1757943844439;
        Mon, 15 Sep 2025 06:44:04 -0700 (PDT)
Received: from localhost ([2603:7000:c01:2716:929a:4aff:fe16:c778])
        by smtp.gmail.com with UTF8SMTPSA id 6a1803df08f44-77f44157463sm25210606d6.2.2025.09.15.06.44.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Sep 2025 06:44:03 -0700 (PDT)
Date: Mon, 15 Sep 2025 09:43:59 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: David Hildenbrand <david@redhat.com>
Cc: Kiryl Shutsemau <kas@kernel.org>, Nico Pache <npache@redhat.com>,
	linux-mm@kvack.org, linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-trace-kernel@vger.kernel.org,
	ziy@nvidia.com, baolin.wang@linux.alibaba.com,
	lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com,
	ryan.roberts@arm.com, dev.jain@arm.com, corbet@lwn.net,
	rostedt@goodmis.org, mhiramat@kernel.org,
	mathieu.desnoyers@efficios.com, akpm@linux-foundation.org,
	baohua@kernel.org, willy@infradead.org, peterx@redhat.com,
	wangkefeng.wang@huawei.com, usamaarif642@gmail.com,
	sunnanyong@huawei.com, vishal.moola@gmail.com,
	thomas.hellstrom@linux.intel.com, yang@os.amperecomputing.com,
	aarcange@redhat.com, raquini@redhat.com, anshuman.khandual@arm.com,
	catalin.marinas@arm.com, tiwai@suse.de, will@kernel.org,
	dave.hansen@linux.intel.com, jack@suse.cz, cl@gentwo.org,
	jglisse@google.com, surenb@google.com, zokeefe@google.com,
	rientjes@google.com, mhocko@suse.com, rdunlap@infradead.org,
	hughd@google.com, richard.weiyang@gmail.com, lance.yang@linux.dev,
	vbabka@suse.cz, rppt@kernel.org, jannh@google.com, pfalcato@suse.de
Subject: Re: [PATCH v11 00/15] khugepaged: mTHP support
Message-ID: <20250915134359.GA827803@cmpxchg.org>
References: <20250912032810.197475-1-npache@redhat.com>
 <ppzgohmkll7dbf2aiwhw7f4spf6kxjtwwe3djkx26pwy4ekrnd@mgeantq5sn2z>
 <d0e81c75-ad63-4e37-9948-3ae89bc94334@redhat.com>
 <20250912133701.GA802874@cmpxchg.org>
 <da251159-b39f-467b-a4e3-676aa761c0e8@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <da251159-b39f-467b-a4e3-676aa761c0e8@redhat.com>
X-Rspamd-Queue-Id: C712F4000C
X-Stat-Signature: 436iobhyzyytttxcfrwitq15i1rzshfd
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1757943845-120955
X-HE-Meta: U2FsdGVkX18KWAp/VebhPXARsV3UniHfPlpz8qfltUNIGwCrEo/4ndcjqcYOfpsHXw47IbitUwaFcIos13c0U1G5PAF0DqeS3A8KsFfb4HqBIHk7KtampQlPke8DXjFGgSdflwvcJYmCGBkdUUeBq/tJO8DU8XNlWmdYtF9FpeRoinONPug9cvPF9CV6Y6oMu70Tk/yu3IHsU6HfsTiIvugOkYlQc8hbYWEzNYc8urrvOIDaanSrCgaxOX8RzXXVhygWH5tG5uJqyDtt09nR8yo9w/lE8UyySiehuFxENIkdhioIkG8gGoYcUbgqzLybNflffyiFdNY86fOvm3Rm11LTKg5+lDs9RGuY4dRkwrbPztXmWYJq11J/NIIbXLPcYzNFcQoXwFgPelkF5X1bL4LckpwYmTKJWzw8Ktd1paU1VfclurZFZbEXda2+x6+5C/vyXJOMq8fHotj0GTJvgKsS7zNbUHBcM2zanTUA45k2Q7nvUTLKxPC5rW4M7mBJZjbe05j/Po4GDlYJFBwjcNbMcCTPjJHcKusgpT5io5hIRLTE78FVFJMzTYSd5lmpm1rp1W55kJFGKq9A/M322biOI7qNTpj7Jcm0OuAf+ke88EubKRLOlcmOVSrUgAfGmRHY5oUeKuYwSUbMNn9u3hJjy2Ri8mVnOMNX68jlyuTc3JFgVbMUMqsa/JKW1o0H5Q0Q92D3+g+b8Ir9Fdcok3JDzc4rKmqOADD1UcBNtymiqyjydMHlQ0wR+A0ixnWDMBnvV/nvwmKMgAagD/YGZf3M55yDJC33nJMNjCmgh+ZmfamlCt6wS2ZxxAcBytRN52Nzkm40P/moDMHi89FzR6wjpqOc8czCKtaU5hILzQeS1rjmTyoooGMi6DYosdfux6NXZWKYHegUZErnI685TWjakxXo899RCVVeSzS0O7TIpzEVKStRImxl1M1KOO9aAu148JBZruaXMevhjAX
 6rdAuVEw
 VR5FubJrvR9WJNSpYGFkjiUEPnmzxZHm1oqvQKrNxAAVhaxLlZoAHux3oujJmiOKiWCkzjv7ObfGqXUCB2nrhyN2j4zzbgR2r4xNkBAcB0p/O2i++3QJSYakevaPE4/AO9x75Q2yJMg+56diFup0wUyKfDCONo3iGDV6Kmzq1N6pdjFbR/AOq/bhiXEbH0+of9VDl5ObflbKwUljcQYGqYgc8cjqzU165der1SnXEP6wY/qfGjzrLSUSpC0HzMOAnFQsIXoupaYTBKJ2l0MSHhq0XDHOqB7i44HusegmSRmRPwgp46K8N0qZ2hsLXPB+VPBs5YEvD92R8O1GnBF89dhseSneYT+CFN1PX4NlzHpcd3+myHQ4SI8GttUEdTSZhLqGTF0ggMe6kBPqiN4uKjjzP3dFS8SN1OJ9mMKiuNBMK5n4QirfnT0Gu5HM3qSsa4eoa4eg7dFtsDT0ewcWEY6Q6yO+HexaxNPvP4eQx1OQLPVQ7BCDkuvsdGkbhZ4bXYglmAhPFvvauUMLNsBgNLRKVjD5AIYA6+H88byI+NJVxGdERnjpjJFTbvyc7FqLckDmw
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Sep 12, 2025 at 03:46:36PM +0200, David Hildenbrand wrote:
> On 12.09.25 15:37, Johannes Weiner wrote:
> > On Fri, Sep 12, 2025 at 02:25:31PM +0200, David Hildenbrand wrote:
> >> On 12.09.25 14:19, Kiryl Shutsemau wrote:
> >>> On Thu, Sep 11, 2025 at 09:27:55PM -0600, Nico Pache wrote:
> >>>> The following series provides khugepaged with the capability to collapse
> >>>> anonymous memory regions to mTHPs.
> >>>>
> >>>> To achieve this we generalize the khugepaged functions to no longer depend
> >>>> on PMD_ORDER. Then during the PMD scan, we use a bitmap to track individual
> >>>> pages that are occupied (!none/zero). After the PMD scan is done, we do
> >>>> binary recursion on the bitmap to find the optimal mTHP sizes for the PMD
> >>>> range. The restriction on max_ptes_none is removed during the scan, to make
> >>>> sure we account for the whole PMD range. When no mTHP size is enabled, the
> >>>> legacy behavior of khugepaged is maintained. max_ptes_none will be scaled
> >>>> by the attempted collapse order to determine how full a mTHP must be to be
> >>>> eligible for the collapse to occur. If a mTHP collapse is attempted, but
> >>>> contains swapped out, or shared pages, we don't perform the collapse. It is
> >>>> now also possible to collapse to mTHPs without requiring the PMD THP size
> >>>> to be enabled.
> >>>>
> >>>> When enabling (m)THP sizes, if max_ptes_none >= HPAGE_PMD_NR/2 (255 on
> >>>> 4K page size), it will be automatically capped to HPAGE_PMD_NR/2 - 1 for
> >>>> mTHP collapses to prevent collapse "creep" behavior. This prevents
> >>>> constantly promoting mTHPs to the next available size, which would occur
> >>>> because a collapse introduces more non-zero pages that would satisfy the
> >>>> promotion condition on subsequent scans.
> >>>
> >>> Hm. Maybe instead of capping at HPAGE_PMD_NR/2 - 1 we can count
> >>> all-zeros 4k as none_or_zero? It mirrors the logic of shrinker.
> >>>
> >>
> >> I am all for not adding any more ugliness on top of all the ugliness we
> >> added in the past.
> >>
> >> I will soon propose deprecating that parameter in favor of something
> >> that makes a bit more sense.
> >>
> >> In essence, we'll likely have an "eagerness" parameter that ranges from
> >> 0 to 10. 10 is essentially "always collapse" and 0 "never collapse if
> >> not all is populated".
> >>
> >> In between we will have more flexibility on how to set these values.
> >>
> >> Likely 9 will be around 50% to not even motivate the user to set
> >> something that does not make sense (creep).
> > 
> > One observation we've had from production experiments is that the
> > optimal number here isn't static. If you have plenty of memory, then
> > even very sparse THPs are beneficial.
> 
> Exactly.
> 
> And willy suggested something like "eagerness" similar to "swapinness" 
> that gives us more flexibility when implementing it, including 
> dynamically adjusting the values in the future.

I think we talked past each other a bit here. The point I was trying
to make is that the optimal behavior depends on the pressure situation
inside the kernel; it's fundamentally not something userspace can make
informed choices about.

So for max_ptes_none, the approach is basically: try a few settings
and see which one performs best. Okay, not great. But wouldn't that be
the same for an eagerness setting? What would be the mental model for
the user when configuring this? If it's the same empirical approach,
then the new knob would seem like a lateral move.

It would also be difficult to change the implementation without
risking regressions once production systems are tuned to the old
behavior.

> > An extreme example: if all your THPs have 2/512 pages populated,
> > that's still cutting TLB pressure in half!
> 
> IIRC, you create more pressure on the huge entries, where you might have 
> less TLB entries :) But yes, there can be cases where it is beneficial, 
> if there is absolutely no memory pressure.

Ha, the TLB topology is a whole other can of worms.

We've tried deploying THP on older systems with separate TLB entries
for different page sizes and gave up. It's a nightmare to configure
and very easy to do worse than base pages.

The kernel itself is using a mix of page sizes for the identity
mapping. You basically have to complement the userspace page size
distribution in such a way that you don't compete over the wrong
entries at runtime. It's just stupid. I'm honestly not sure this is
realistically solvable.

So we're deploying THP only on newer AMD machines where TLB entries
are shared.

For split TLBs, we're sticking with hugetlb and trial-and-error.

Please don't build CPUs this way.


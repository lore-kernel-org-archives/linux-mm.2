Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5C18ACA0FED
	for <linux-mm@archiver.kernel.org>; Fri,  5 Sep 2025 10:21:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A31328E0013; Fri,  5 Sep 2025 06:21:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A08C18E0010; Fri,  5 Sep 2025 06:21:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9455A8E0013; Fri,  5 Sep 2025 06:21:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 83D508E0010
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 06:21:37 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 43F4513BE06
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 10:21:37 +0000 (UTC)
X-FDA: 83854805034.22.CB26F79
Received: from fout-a4-smtp.messagingengine.com (fout-a4-smtp.messagingengine.com [103.168.172.147])
	by imf07.hostedemail.com (Postfix) with ESMTP id 4175B40015
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 10:21:35 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm2 header.b="E rdp59R";
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b=Cfg2yOQk;
	spf=pass (imf07.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.147 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757067695;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KMyAzvhpsbESuO7ZV4dp5wQG2uawHByJPfJuMX/sKOE=;
	b=6sGnVDdGJj6LGr4v/34cYNL/vNFbAWF3uJf0+6YAlhE4MV9ylmn2yTK4lyB61O5kCLiVoy
	tKw00vMhw4Bn1YpOdVYgqiMOMTpm9TT9DgKc+i71L0HcX3iZXl5oL8yjVf9O0s4661jDz0
	BYFeVgcbWZIjavWp25HGJUqxtbD/ukQ=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm2 header.b="E rdp59R";
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b=Cfg2yOQk;
	spf=pass (imf07.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.147 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757067695; a=rsa-sha256;
	cv=none;
	b=Of+Vuj+r/werQn4Fun/ptjJot2lZl6BlnGapcAw007LVnm67u9Fj5LYzHSSKQbfctavM9T
	nt9wnJw89r+FIDzTWFqCbgRN7W0txIQXE+dK/XIICzzUCPkKxpb14viyfHrMt1f1vv5Uz/
	w4TQysaTdIt2uM31XIglMAXlM0zwr0M=
Received: from phl-compute-02.internal (phl-compute-02.internal [10.202.2.42])
	by mailfout.phl.internal (Postfix) with ESMTP id 74399EC02FF;
	Fri,  5 Sep 2025 06:21:34 -0400 (EDT)
Received: from phl-mailfrontend-02 ([10.202.2.163])
  by phl-compute-02.internal (MEProxy); Fri, 05 Sep 2025 06:21:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-type:content-type:date:date:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm2; t=1757067694; x=
	1757154094; bh=KMyAzvhpsbESuO7ZV4dp5wQG2uawHByJPfJuMX/sKOE=; b=E
	rdp59Rd0xMPYFx8TrXx8i/1/x/qRfYLxsTX9h3q70m3N82iyuW6RuI/mcKk3s1/t
	atEvPF7fqZu+b/5O1BbDmontss5W75KjT8hmTOmi1Hp82HX0rkVPS1SDMR+YOC2Y
	AiwQ+U/VwsGN203t6aF5LAHa4s2KX25VNPY3qw4dpTl6i8srKZ1RmZ38V+OrXMhc
	ILGejTY6Snm1jO67Sy7lWtR2JdOK65kx8Og82X+ysUIvDhSEscNR0XqqfjeWgipl
	lg6GXdcI8PvGDQ8Gk1vuaf5aPDpNIxfZb6dIqKnjdWkYFk+nCxvXkC+laq7gYZKm
	+NMu7yqvWXU8ris28/klQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=
	1757067694; x=1757154094; bh=KMyAzvhpsbESuO7ZV4dp5wQG2uawHByJPfJ
	uMX/sKOE=; b=Cfg2yOQk3ln9CUXG18L7j1ABUDeih/Brf6lgX17ST2AeLy6tk+4
	mFrQavjaex6UWaD0wCjE4KHL7tNxFVjwT13UEZlSxtfgKVPM29anzkPdQ5ffgHO7
	gFoSYJvRnpWVfo3Dwzlv1ccbeano9j5OKtbkUUd94tkSUgGXwxOlvhL4Z0Y35QN/
	FM5bZ3KKllkOtl4lYuOSu+Azvl/e1lHGiMm/Tl8lZ8rWhaleBqgTAERvMcr4mAl1
	J0sUBgglcvovDmh+NXshJvHDBiJ4Vv03TrTlm7iy0Zbz1CLp07lW8ZnmMknwgmrm
	PBucth8/JJFDxxgXBqIiZJ/NDvk3EpJPUuA==
X-ME-Sender: <xms:rbm6aPH3a-sWzdu6nWBTr9a9lLCXqIiTZe6mE0lIfxQd3NmA0-3rjQ>
    <xme:rbm6aC4hjeMe8eHOuKFU_YPv3K8q0Yl0CjO-mi0gzNSeM0_bXhqSSqFGYOKleYE8w
    -69pCJXNcxhZNy5wBc>
X-ME-Received: <xmr:rbm6aC3SMT4DKsdZ6GLUe3-tuH2B55YyKeDl-DhZrxYZ_x7RvLCJpYtTFWqu>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeeffedrtdeggdekieegucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceurghi
    lhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujfgurh
    epfffhvfevuffkfhggtggujgesthdtsfdttddtvdenucfhrhhomhepmfhirhihlhcuufhh
    uhhtshgvmhgruhcuoehkihhrihhllhesshhhuhhtvghmohhvrdhnrghmvgeqnecuggftrf
    grthhtvghrnhepjeehueefuddvgfejkeeivdejvdegjefgfeeiteevfffhtddvtdeludfh
    feefffdunecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomh
    epkhhirhhilhhlsehshhhuthgvmhhovhdrnhgrmhgvpdhnsggprhgtphhtthhopedvtddp
    mhhouggvpehsmhhtphhouhhtpdhrtghpthhtohepmhhhohgtkhhosehsuhhsvgdrtghomh
    dprhgtphhtthhopegrkhhpmheslhhinhhugidqfhhouhhnuggrthhiohhnrdhorhhgpdhr
    tghpthhtohepuggrvhhiugesrhgvughhrghtrdgtohhmpdhrtghpthhtoheplhhorhgvnh
    iiohdrshhtohgrkhgvshesohhrrggtlhgvrdgtohhmpdhrtghpthhtoheplhhirghmrdhh
    ohiflhgvthhtsehorhgrtghlvgdrtghomhdprhgtphhtthhopehvsggrsghkrgesshhush
    gvrdgtiidprhgtphhtthhopehrphhptheskhgvrhhnvghlrdhorhhgpdhrtghpthhtohep
    shhurhgvnhgssehgohhoghhlvgdrtghomhdprhgtphhtthhopehlihhnuhigqdhmmheskh
    hvrggtkhdrohhrgh
X-ME-Proxy: <xmx:rbm6aGg9dre1oS8kcNXdb8IMc1TsfQjPqV9-VmFJtP2tW38F1vYNiw>
    <xmx:rbm6aGTNGUku_EJgbUdJXrjF8cSXuF9Gc4S_jsuLj7NfrLmqyvy8fw>
    <xmx:rbm6aA5AE3kqieH53odk_39s1DRKD3hONKt4RdFyVhJDFgcrn9P3Ag>
    <xmx:rbm6aGyxeIZBfVmvcnMZkTWvEQqfnPpWgjL38J3waaZ0Y4-gWMR6nw>
    <xmx:rrm6aLzKP_1c0fq0-k0K1hfU3QtoxOrTnPz6eMhRH8TNQyJlqdlbkQ3x>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 5 Sep 2025 06:21:32 -0400 (EDT)
Date: Fri, 5 Sep 2025 11:21:30 +0100
From: Kiryl Shutsemau <kirill@shutemov.name>
To: Michal Hocko <mhocko@suse.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@redhat.com>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	"Liam R . Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@suse.cz>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, linux-mm@kvack.org, 
	Usama Arif <usamaarif642@gmail.com>
Subject: Re: [PATCH] tools/mm: Add madvise tool
Message-ID: <v3rbjkvckce5jck5mugtqmevtrpckr7mqxzkdel4uawuvibikr@zeqfnti5p6zf>
References: <20250904175729.1029735-1-kirill@shutemov.name>
 <aLqqlkTpEM1SkvaE@tiehlicka>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aLqqlkTpEM1SkvaE@tiehlicka>
X-Stat-Signature: eyo5rm1upedwcsg6htyuyiakmp7jq4ia
X-Rspam-User: 
X-Rspamd-Queue-Id: 4175B40015
X-Rspamd-Server: rspam01
X-HE-Tag: 1757067695-343407
X-HE-Meta: U2FsdGVkX1+vyhkMb88fpz91fzFBe0lpsiptmg0fO+tm85vLAKvvyqbTec/IkYSEvqRFk7q+51uB9WLBfBaPJJztczN5IZi1Oa1JZSwBJ3XezGonISjdEvdb9DnxHUZfaKPBJ4VE86HNfSylaSpqvYWSB9HVZGy7K0n+jf0fSKUzSRfyEY3HHooRoA04njvGeWjFYO5kCCf5/PVFhrg9cpk/EybKHlz/B1Zas1pv2pB7dKreTEF5uS91UsCx8cvarMpB2ozUH5M0T/twf31S9Uw4npwlG1D7Q1GOX7f4a4GMDpwmGVSo4SMw+IcsylhENRq4KTd1XTUPvvo15UBXKQnKvWTPLNT9dkYZc1Qu+gziZFFgTwJF3hty0IG9GoX93maCZABJp8Gm3XjG8G6L5huDVweqQke1rerqVkvMe1WFOuCAWcLRyeGLwY4zzSH4fKZl9upCvIx7R8DEDr8J3IwRMqCGVUdvzzGI40tm8usLy6RvtUDzdNvJM9+SNd2xsVmscgPE9NEw1IVhXW04Qxmr2KIphUJcSQ/buNqdAvQS1j8Z9Jx6fjw1Q132IbivlJil42JMFWfTNwz+oNPYB57XmYMOe1RaQ7UZMbkQJTnb6E74XbeiTKyFUJfOJ5roExG1HAUzy5/PCXVJp422uB2Pq7Cqxn27DZVBXsmCJYRJoghsJdBCap5Z6zRY2CwK9rirYrwoSD36jz0WdMmm2mJ+es9Ou0XkGknoSgWAiACGFnO7eHQOmyjUbYNCRkvTdZ1iakDYcAKN6AooyLh+g/5VdnGss4CgbxuLrd+f2CriMh5QamtO5a69spDPzLa/RdQliuxPdNZBVc9eVALZ8by/Rid0uJZLPa+nfaG2qrpnZJutbSqHQvsqhuAG9kcMsjBB3MUYmwdc1p3T8Jka3PSO/77Nkd40LnDQ9LvjILE0nMQxfKWRh7mHXfVGTSV/7L+4feVuA3NQqAKC7Ul
 yphcuHAE
 n17xVLlaEB2ZzcYfwNJ1b1pABeq8oKs000UyvXaJLefjJZC3JRUIzaW7LmcrPjIRQnLN/OGsofzSMcMFP/pp4yxbgydHehQw3/f5sfjY4lSrOXjlZTUT7TmOvl8HxEyMI+3L646GE+1Rd2XpycG8FWjQGAc5H6o/4Qy6W2EZYZ4UYxGrYcPgMlZ8xLk56t3pCB833U1BnaiIa/L3bmMXqrBoKBRGf4MgFjZcBr6YZt/sVJfwLR2w6jGCbdAVbfPyVbsqkEmvmW5azbi/kKJGXj9wMpIw0CoPRwSo1ZCAorre4wOShK84azHj7bT9aq1aoqwepXRiNw9Kn3L5oV0QVn2fnvgewtKSW+owDR5g3BzBJhGOVdFp4yqQhJ8kD6+t57VseTikfKKWdI7w=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Sep 05, 2025 at 11:17:10AM +0200, Michal Hocko wrote:
> On Thu 04-09-25 18:57:29, Kirill A. Shutemov wrote:
> > From: Kiryl Shutsemau <kas@kernel.org>
> > 
> > Add a simple tool that allows to issue an advice on a process or a file.
> > 
> > It can be useful to experiment with effects of an advice on a workload
> > without modifying the workload itself.
> 
> Is there any reason to have this in the tree? This seems like a very
> trivial tools that doesn't really need to be in a lockstep with the
> kernel source.

There's no strong reason to move it in lockstep with kernel code. At
least for now.

The tool is useful to experiment with both kernel and workload behaviour
on an advice. Like, I see some oddities with MADV_COLLAPSE that makes it
give up easily where it shouldn't (will investigate later). I wouldn't
see them otherwise.

But you don't see it fitting kernel tree, I would not push back much.
I found the tool useful and decided to share.

> Also would it make more sense to send the pidfd fd to the tool directly
> so that it can benefit from a racefree pid->fd translation?

Hm. Do we have an easy way to open pidfd from shell?

I am not sure we care that much about the race for this tool.

-- 
  Kiryl Shutsemau / Kirill A. Shutemov


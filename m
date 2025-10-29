Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0A1FACCF9F1
	for <linux-mm@archiver.kernel.org>; Wed, 29 Oct 2025 17:10:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 397EA8E00B4; Wed, 29 Oct 2025 13:10:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 36F1A8E00B2; Wed, 29 Oct 2025 13:10:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2852E8E00B4; Wed, 29 Oct 2025 13:10:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 167B48E00B2
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 13:10:55 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id AF1A513BEAC
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 17:10:54 +0000 (UTC)
X-FDA: 84051791628.22.F5966AA
Received: from flow-b3-smtp.messagingengine.com (flow-b3-smtp.messagingengine.com [202.12.124.138])
	by imf07.hostedemail.com (Postfix) with ESMTP id 900F640002
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 17:10:52 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm1 header.b="P uKPezl";
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b=YDVmwxA5;
	spf=pass (imf07.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.138 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761757852;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=60bBq5IIwMjb0a7pvkC94ERZqp+DD7+pnKJsuAq/LCw=;
	b=u9sb4xWuH4PfBPgFPb3/0LvkzdEjst5XEjSrgB+MiNAceXk9sbdXTMctW4L4c3BjwNJyZ1
	ZvCqhqbI5Tb5IOHnD9meLVmf3RHm6y3kYgv9eISi626+wRN43YgYO6yNBLcMbVcxz/sZ4/
	1FiB+xky1kkq5U78xAQtLGlkLu5oAPg=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm1 header.b="P uKPezl";
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b=YDVmwxA5;
	spf=pass (imf07.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.138 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761757852; a=rsa-sha256;
	cv=none;
	b=axPBulmJhKh6perRworLeAZhe+9QUIWQS/xuCmN+PI2vVnf0mhyK5hcC9g+r0c9tyC/dLd
	s9ybSWbbsOUKVzCvnxMdp3xCuHaBO0Vh+WjmR2c4xfvFaI2+B2ndJ/un15hHWewDEVcHRc
	ZeI8rYBiBRE+so0Yb2T6Aj/EwXimmOY=
Received: from phl-compute-06.internal (phl-compute-06.internal [10.202.2.46])
	by mailflow.stl.internal (Postfix) with ESMTP id A0A32130037A;
	Wed, 29 Oct 2025 13:10:50 -0400 (EDT)
Received: from phl-mailfrontend-02 ([10.202.2.163])
  by phl-compute-06.internal (MEProxy); Wed, 29 Oct 2025 13:10:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-type:content-type:date:date:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm1; t=1761757850; x=
	1761765050; bh=60bBq5IIwMjb0a7pvkC94ERZqp+DD7+pnKJsuAq/LCw=; b=P
	uKPezlySAYOoFeK12sfyCSmkoWdrEnbnG0g5S2Coyv5LMdvXgvsDCmM44I8CSTSp
	9bFIK9UGItinH5OvGS9KsSllF5qYIFi3+aqk7R+HL2BHOwR+eRg5dS2IW64tj7Ou
	e3DH94kl5xQggG+Bl7kK9oqFcTTDmIPoMFGd+FtjorzURIBmALPKiICL+dg0HQJI
	3khE4DDAQjGrl3USb9bUaHRz7Y2gHOHORDB1PukkmeD0laF8n6kUr1nGDOQrc5yi
	GBYZteNjZs5dXC9p6CJAaxhZ5fL8Z3xNUDaBq1dHqUwCt4wgEzruOznaIthwFxDy
	I/dUsvhb96fneKpJasiBQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=
	1761757850; x=1761765050; bh=60bBq5IIwMjb0a7pvkC94ERZqp+DD7+pnKJ
	suAq/LCw=; b=YDVmwxA5juNSdkfC6gTj5fXjErDO2LwaC/xFaMBOJtQhNKaUOtW
	sTT4HSUES4Nyi3qSdkJV4wMFr6PMK2MQbJqaylbA+jw0te64A8X7T321gnAr2hT/
	r/kD1ZcVN0LHIA4u+ZB+ytk+kPgi4r954pS4pxYvCjMn5YBqwr8fIW4IyYRet2A9
	Xc+XjcumRU9wvw4/S8rGmeWWjXrNTLL5OGkF18/o5Ee8i055TKIyasBb0T9rmfAl
	mXEO17hWtFlemZC6lNVZoOortg6T9zgN44ydznaYxy8LJFWneyhl0NHJ4WG5QhJd
	1VS2m0QSp8fgtN8uK81a10EOXECflnI+rrA==
X-ME-Sender: <xms:mEoCacEUnMQhiExXjUB4pIZ--Bn-4wv7TJ4IsSQEquj7XCzc6Z7zvg>
    <xme:mEoCadBSp2M4kTdv8_9pMESGiq45XxTWBumC8KMJptp30-9PyStDYD9zBP0fIAoRU
    edc2Ko_R2QSagUSjRBdYLyaQYEnk9rvBVZxDeZ9IutLgkcBcoLsSqk>
X-ME-Received: <xmr:mEoCaYUyE90O4bXlKsfln2cY1aMntSGLBBELjtTLeluUD_jkutxybVmRM7mvHQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeeffedrtdeggdduieegvdelucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhepfffhvfevuffkfhggtggujgesthdtsfdttddtvdenucfhrhhomhepmfhirhihlhcu
    ufhhuhhtshgvmhgruhcuoehkihhrihhllhesshhhuhhtvghmohhvrdhnrghmvgeqnecugg
    ftrfgrthhtvghrnhepjeehueefuddvgfejkeeivdejvdegjefgfeeiteevfffhtddvtdel
    udfhfeefffdunecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrh
    homhepkhhirhhilhhlsehshhhuthgvmhhovhdrnhgrmhgvpdhnsggprhgtphhtthhopeeg
    gedpmhhouggvpehsmhhtphhouhhtpdhrtghpthhtohepughjfihonhhgsehkvghrnhgvlh
    drohhrghdprhgtphhtthhopehhuhhghhgusehgohhoghhlvgdrtghomhdprhgtphhtthho
    pegrkhhpmheslhhinhhugidqfhhouhhnuggrthhiohhnrdhorhhgpdhrtghpthhtohepug
    grvhhiugesrhgvughhrghtrdgtohhmpdhrtghpthhtohepfihilhhlhiesihhnfhhrrggu
    vggrugdrohhrghdprhgtphhtthhopehvihhrohesiigvnhhivhdrlhhinhhugidrohhrgh
    druhhkpdhrtghpthhtohepsghrrghunhgvrheskhgvrhhnvghlrdhorhhgpdhrtghpthht
    oheplhhorhgvnhiiohdrshhtohgrkhgvshesohhrrggtlhgvrdgtohhmpdhrtghpthhtoh
    eplhhirghmrdhhohiflhgvthhtsehorhgrtghlvgdrtghomh
X-ME-Proxy: <xmx:mEoCacyF1RHVcLYRyFT4ZQDb1NNgXDOsB6KNvUHlEmfjAXEn2bWj3w>
    <xmx:mEoCaV6pztrEFaqdCJZva8ahBL9HhMEY7MOrHpN-4vGFCgfrnjolqg>
    <xmx:mEoCaWZGqLI9Hf_Fglz7txSaT3RQ5YDkSAoAxCEdp-l3xFHBWbO7TQ>
    <xmx:mEoCaTN4Pel5vb9e79uW_KKdyBjAMTX85I0kv0O6VEZmyJtTVseF2Q>
    <xmx:mkoCaYAoznBpCEKhVJp9uKe260T7Urz4KZ0Z3cNh6JDnOlIH9fALLPZg>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 29 Oct 2025 13:10:47 -0400 (EDT)
Date: Wed, 29 Oct 2025 17:10:45 +0000
From: Kiryl Shutsemau <kirill@shutemov.name>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Hugh Dickins <hughd@google.com>, 
	Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@redhat.com>, 
	Matthew Wilcox <willy@infradead.org>, Alexander Viro <viro@zeniv.linux.org.uk>, 
	Christian Brauner <brauner@kernel.org>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@suse.cz>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Rik van Riel <riel@surriel.com>, 
	Harry Yoo <harry.yoo@oracle.com>, Johannes Weiner <hannes@cmpxchg.org>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	Dave Chinner <david@fromorbit.com>, linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCHv2 2/2] mm/truncate: Unmap large folio on split failure
Message-ID: <iqzgqvkin6istylyqqias7bwulhh2s6l6aqepssk6ptfu5dddy@q2rfk3wewcbz>
References: <20251023093251.54146-1-kirill@shutemov.name>
 <20251023093251.54146-3-kirill@shutemov.name>
 <9c7ae4c5-cc63-f11f-c5b0-5d539df153e1@google.com>
 <qte6322kbhn3xydiukyitgn73lbepaqlhqq43mdwhyycgdeuho@5b6wty5mcclt>
 <eaa8023f-f3e1-239d-a020-52f50df873e7@google.com>
 <xsjoxeleyacvqxmxmrw6dxzvo7ilfo7uuvlyli5kohfy4ay6uh@hsrz5jtkgpzp>
 <20251029151947.GM6174@frogsfrogsfrogs>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251029151947.GM6174@frogsfrogsfrogs>
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 900F640002
X-Stat-Signature: s1584xr8kw599e8mib6r4fsx1aso8edk
X-Rspam-User: 
X-HE-Tag: 1761757852-823521
X-HE-Meta: U2FsdGVkX18yL5Vj0pcN/1R2OOErFgZIdi5W8FluM+zCQ9JGMqHTZfrYjNWO7KWc/KwKhs3XJfWVDPQ6c6tUu8fNPR1Yp8yGftef8T2hom+rVskz2/AMUYbRg6o5kc1slp/EBJQg1L3TDn6r7/ONC/h1NuYLwFBjZ9UZebPDOp8nYYROax0Lcf+PkZFC2NF6nKArOakgX5TiTuRAkHX6ghlPzmHx7onaV0v22Vf/u7RnrMP+hMjXtw0OvoPUC3V25Z8GDblGBl/3zmmuGEMxyCIHetkSAiZfLA8z159yNBYfTmwMZTeq3drFAbewY3Dsx7kQbM06kMhBKJqdIotio4GWaL1zTbcOPV97a+hHKJlbQjEFEth5ESjtsPc51dO6KKTkIut4rW+yFwb5Mw++wx+aEE0xZosOM2NxIIzhJyMTy7KvzxoMk1ezas+Qfmea/Nht/PMS/n007KwHUFUAFazy64EfQZTXoJYYhMWkjxVFY/98gqYGPWHxBx4nYxU/BphIbhPz/h8F7KMGbAH/50R4sNaK0u/Ccv4gpidepQw1vaaMXOQLP2In75vvBFL52WFJGS+DNVan4ad4Xs9FpPWKsEDf8VlOVzFL1Z9eebGP7qF0ro26AEz/lUPWWsPepHobsOWA00dS+/kzwXfDd94Xl9J8TKqhuxnfbltJcAgDsl4VgMEsxpU8mfBJYLvuC+LOZq/pkMoE9cPOUsZkGtVJlUKiA8Wn2oKpf1TMxx48czROpnwycSUKQmk88noLqau2QzRqud5vwNWyhWzTxDDvIn/IgrGn5cMtwgaF2/4r7TrxijJIeMffqPXIxalAE75dHETdh66eKCmd8JFbOup7Wb6bXg3t037Ebs3MqYfU4MrDOF74t7nTvA3Is3cnwM5ByxUY92cltsSVnKELIHclZW6C4YkmHl3dyDlQV2YN51nUCsiiVLKbp6Z2+3GyZW19DwsBSmm/o50oTtW
 FI8ac64F
 6NlCKk0MnI0z07vahcc/DIByKyjpsyqt4zDKQaXOr4Fa7Od4pPNVsyVnopQf4QMEYhKnyfTiEFmKFgb5RI5dOYQwc4ZYLfRBYQS4gFIr79+JQTqm/DdLjcBfWFiM1H0tjnIv+vI5D1oqSBjCn+FnlZ62EtcbwV3EJA7ZhuVgnRZezVgAqi1sX+pRQvr8hnfyO5Y4AUpWvrSs08ikijsdwv4ablzgN4Qzrw5fjVN48yLs12NTHFU0xjZA72sPdfhb1wLJN6zcbvhvoLe3Fhf1YlSy+8cj4GT6MMBIDfHQooztuFYvJm4gGo0VYFIE89ljtL6bJoaO1KPBTBazBxZKNGzgGlHE6Ow4I0fJHSxbHLiRooi+Dkv+tlEowL14OUuPv4Wiz4Dw3/W6rxi3OFp8HcYtvavRqOmV0+U96sEvYOo5oEZiQo41ar1nHtLgXAiI0//cK
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Oct 29, 2025 at 08:19:47AM -0700, Darrick J. Wong wrote:
> On Wed, Oct 29, 2025 at 10:21:53AM +0000, Kiryl Shutsemau wrote:
> > On Wed, Oct 29, 2025 at 02:12:48AM -0700, Hugh Dickins wrote:
> > > On Mon, 27 Oct 2025, Kiryl Shutsemau wrote:
> > > > On Mon, Oct 27, 2025 at 03:10:29AM -0700, Hugh Dickins wrote:
> > > ...
> > > > 
> > > > > Aside from shmem/tmpfs, it does seem to me that this patch is
> > > > > doing more work than it needs to (but how many lines of source
> > > > > do we want to add to avoid doing work in the failed split case?):
> > > > > 
> > > > > The intent is to enable SIGBUS beyond EOF: but the changes are
> > > > > being applied unnecessarily to hole-punch in addition to truncation.
> > > > 
> > > > I am not sure much it should apply to hole-punch. Filesystem folks talk
> > > > about writing to a folio beyond round_up(i_size, PAGE_SIZE) being
> > > > problematic for correctness. I have no clue if the same applies to
> > > > writing to hole-punched parts of the folio.
> > > > 
> > > > Dave, any comments?
> > > > 
> > > > Hm. But if it is problematic it has be caught on fault. We don't do
> > > > this. It will be silently mapped.
> > > 
> > > There are strict rules about what happens beyond i_size, hence this
> > > patch.  But hole-punch has no persistent "i_size" to define it, and
> > > silently remapping in a fresh zeroed page is the correct behaviour.
> > 
> > I missed that we seems to be issuing vm_ops->page_mkwrite() on remaping
> > the page, so it is not completely silent for filesystem and can do its
> > thing to re-allocate metadata (or whatever) after hole-punch.
> > 
> > So, I see unmap on punch-hole being justified.
> 
> Most hole punching implementations in filesystems will take i_rwsem and
> mmap_invalidate lock, flush the range to disk and unmap the pagecache
> for all the fsblocks around that range, and only then update the file
> space mappings.  If the unmap fails because a PMD couldn't be split,
> then we'll just return that error to userspace and they can decide what
> to do when fallocate() fails.

Unmap does not fail and PMD can be split at any time. But split of large
folios can fail if there's an external pin on it.

-- 
  Kiryl Shutsemau / Kirill A. Shutemov


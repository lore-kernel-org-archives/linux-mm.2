Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 99F11CCF9EA
	for <linux-mm@archiver.kernel.org>; Mon, 27 Oct 2025 10:40:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D6D5F80034; Mon, 27 Oct 2025 06:40:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D44578000A; Mon, 27 Oct 2025 06:40:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C33C880034; Mon, 27 Oct 2025 06:40:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B01EB8000A
	for <linux-mm@kvack.org>; Mon, 27 Oct 2025 06:40:12 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 36A9B13B0D8
	for <linux-mm@kvack.org>; Mon, 27 Oct 2025 10:40:12 +0000 (UTC)
X-FDA: 84043549464.11.FFC05DC
Received: from flow-a3-smtp.messagingengine.com (flow-a3-smtp.messagingengine.com [103.168.172.138])
	by imf22.hostedemail.com (Postfix) with ESMTP id 1DA7EC0002
	for <linux-mm@kvack.org>; Mon, 27 Oct 2025 10:40:09 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm1 header.b="P CJzgJt";
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b=Xiqxl8wy;
	spf=pass (imf22.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.138 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761561610;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=J5CcOF0C2/ovI9Kf7WL/hZcJiwTY902lhGxvmOPQI6g=;
	b=BFBtSFarsmtQGnnkG3kjm7FMOhvLGQw8w76GRhhBnbkuA+m2pvyzDgfZRm32VvLAMDkrw/
	VE+q80Ub8d3+FENeeLSa/aKn54QvX94DQExeYJXfP7FlH7HmNl6NY7eTAS9xon49PYwoot
	QK6boBD/KYhUVaGTNJNGv6E4ENDcvTs=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761561610; a=rsa-sha256;
	cv=none;
	b=6/T35H2pmLF2qAn+LUvkqVHhleZZRnXo1NNFdU5CZZ/eYDx719062ZNE4BNGFsoHFfBjW3
	sam5CafdzjdwOUK6JEeTLyqc6w/WFknD0CPssi321aBk6z5FgmWeh5BVg7lzi7+914/t5e
	dqeSr/Iz6wT5QFxzhbttXYSrSy+MINY=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm1 header.b="P CJzgJt";
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b=Xiqxl8wy;
	spf=pass (imf22.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.138 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
Received: from phl-compute-08.internal (phl-compute-08.internal [10.202.2.48])
	by mailflow.phl.internal (Postfix) with ESMTP id 35CFB1380262;
	Mon, 27 Oct 2025 06:40:09 -0400 (EDT)
Received: from phl-mailfrontend-01 ([10.202.2.162])
  by phl-compute-08.internal (MEProxy); Mon, 27 Oct 2025 06:40:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-type:content-type:date:date:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm1; t=1761561609; x=
	1761568809; bh=J5CcOF0C2/ovI9Kf7WL/hZcJiwTY902lhGxvmOPQI6g=; b=P
	CJzgJtt5dAoV8zeL8X0lxYn2Qo4veQXJvbY8jGok+uZzilSpisKjhoGQJfzWoWG8
	e4xIs3PJ2lcAGSzXqsi8E5h1bI+cxfwzInHcUwxzavFeTte8tvLPR/JIIsyxnNve
	ohQZ0QEWn7OseFVwoYa+9MWbUD0+oMl0WRIAghIChFDyAMiVSEQMvPVKWiYUy6Ap
	XVC+MbXgPZMhX/FaMvooF0C+Fuxictkz9jFqIWwLKRKke3nX+x8QfSZEtblxnWb3
	6eCE0mY2sqeFfff4voAKEbkXzo2AQI7ogO425Q61OXg6+w8RgaeEazgTDosUzJMG
	f3aZkyCDdDnZ56RJklf8Q==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=
	1761561609; x=1761568809; bh=J5CcOF0C2/ovI9Kf7WL/hZcJiwTY902lhGx
	vmOPQI6g=; b=Xiqxl8wy2eezShYtWPExGsK3jlkuwh5n8AQWQss9+0ok+f+VP41
	UxLy3eaCrWpNHotHsebHtvKgXQgq3OfYSuKcT3BHUR9OwH5nmQ8YkMFuWKMKwtO8
	UqumRJ0dnM7UaWvN2O8FNeUdZPF3Qbue9SDOp7az5Il0pEIVGA5eQHChXvRFzVhu
	eAWaAwIu4y019yhILqjttlQ9U2iltbhok2QlEUQBWn93mGrTds683rekZZbRAev8
	8GPSUV8F85I7Pik9etBXlqldlTd7ZNv9pdfsd93GMOiP1t+bpFn2VU91ZFkfX9or
	jyZZ2BCbXiDTcuYt0NpRnvJc2uzV5/CYQdw==
X-ME-Sender: <xms:B0z_aABhHTXyAc9gywNkg40h5ypJplx0CY0QJx4wrb2xkr7HuebJVQ>
    <xme:B0z_aLliGpToF8gtI04iMoqF2kWSLtUeDvvkn_KHPW8Xy2n2MPFXwOcFLWI9UNMGA
    GB3sTCkq0OQCMgxE-3N-oGTkjPnp6bH4pZYcTIYfmc3Sn9-GOA7KUJs>
X-ME-Received: <xmr:B0z_aGhVGydf4aIWEc5HGCw6Xu9AoTNMwFLQxR1XzhXS37ErkSS1wBKvDK050Q>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeeffedrtdeggdduheejjeeiucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhepfffhvfevuffkfhggtggujgesthdtsfdttddtvdenucfhrhhomhepmfhirhihlhcu
    ufhhuhhtshgvmhgruhcuoehkihhrihhllhesshhhuhhtvghmohhvrdhnrghmvgeqnecugg
    ftrfgrthhtvghrnhepjeehueefuddvgfejkeeivdejvdegjefgfeeiteevfffhtddvtdel
    udfhfeefffdunecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrh
    homhepkhhirhhilhhlsehshhhuthgvmhhovhdrnhgrmhgvpdhnsggprhgtphhtthhopeeg
    gedpmhhouggvpehsmhhtphhouhhtpdhrtghpthhtohephhhughhhugesghhoohhglhgvrd
    gtohhmpdhrtghpthhtoheprghkphhmsehlihhnuhigqdhfohhunhgurghtihhonhdrohhr
    ghdprhgtphhtthhopegurghvihgusehrvgguhhgrthdrtghomhdprhgtphhtthhopeifih
    hllhihsehinhhfrhgruggvrggurdhorhhgpdhrtghpthhtohepvhhirhhoseiivghnihhv
    rdhlihhnuhigrdhorhhgrdhukhdprhgtphhtthhopegsrhgruhhnvghrsehkvghrnhgvlh
    drohhrghdprhgtphhtthhopehlohhrvghniihordhsthhorghkvghssehorhgrtghlvgdr
    tghomhdprhgtphhtthhopehlihgrmhdrhhhofihlvghtthesohhrrggtlhgvrdgtohhmpd
    hrtghpthhtohepvhgsrggskhgrsehsuhhsvgdrtgii
X-ME-Proxy: <xmx:B0z_aD3d7IOpUEH6nfto9rwvKaqbSf02e0QrfL9xl2oaJgtlaI6n0g>
    <xmx:B0z_aCSGhJ3s1q9UrX279aQu7CavvQoSgMNRwLGVVk7lHG3ibPADNg>
    <xmx:B0z_aNbewC8p69Y3STPH3qX6-wLiUX3bimrPjz2qIfrI9Vug-cZuMg>
    <xmx:B0z_aH7actSeoaL6p0LQO9TS_jYBqkikxndFchvqrE14-dndwt-3-g>
    <xmx:CUz_aCh2oiJbFTOucV9lLdCMUcF4Q5ZcIK9KeA9H8wm8Eo4MRa1m6UK2>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 27 Oct 2025 06:40:06 -0400 (EDT)
Date: Mon, 27 Oct 2025 10:40:04 +0000
From: Kiryl Shutsemau <kirill@shutemov.name>
To: Hugh Dickins <hughd@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@redhat.com>, Matthew Wilcox <willy@infradead.org>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Rik van Riel <riel@surriel.com>, 
	Harry Yoo <harry.yoo@oracle.com>, Johannes Weiner <hannes@cmpxchg.org>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	"Darrick J. Wong" <djwong@kernel.org>, Dave Chinner <david@fromorbit.com>, linux-mm@kvack.org, 
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCHv2 2/2] mm/truncate: Unmap large folio on split failure
Message-ID: <qte6322kbhn3xydiukyitgn73lbepaqlhqq43mdwhyycgdeuho@5b6wty5mcclt>
References: <20251023093251.54146-1-kirill@shutemov.name>
 <20251023093251.54146-3-kirill@shutemov.name>
 <9c7ae4c5-cc63-f11f-c5b0-5d539df153e1@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9c7ae4c5-cc63-f11f-c5b0-5d539df153e1@google.com>
X-Rspamd-Server: rspam05
X-Stat-Signature: tdmdfuwj7q7gewcbz3yyxwuyc6r75xuh
X-Rspam-User: 
X-Rspamd-Queue-Id: 1DA7EC0002
X-HE-Tag: 1761561609-950095
X-HE-Meta: U2FsdGVkX18x6pEII6uezyWDLv35BQPa+dHmVMhmD4NerrPdsHQ1tF1Rp5fyV8FwSFgcq6JjzmJBP6yk/PYitQQrRoS/2vrw3tu4RPHD/DcKjeCMzJtFBYRV77ubiVnyVl0pU508PH2jFK8KvLXwXrYSnoAjb8i/LXKlF/Jz9HpdVRTrVwZweVgxgx+Kgynb9RAbJpfSTnnYeOXiYp1cOPeeysHOC+rPi9wZvLVkWG6OyRhG42VKVbV0Cv+r6eenuS1Qgu5hnaxmRO9U7/bL4oJjmI63dTY4788GM45af0UaECUf6QePlRBcRu55LUsZc8SKUumuJcZpoHo3vBGkBXS0KDRhmOue7ZuW9MHDrerd/asO0Q11bzJS0a2NCaWkJrhuYOiP1gVI1oCX5J//SKQnrZHu1dyuKU3bhzStInJ91sTm/9Os7SBLzIc7zs5519QzhXRNXCxng6m3ytM4vHIZvYyUseCxQQpDvoHIQ6cmYvtjfwCmP0P+xAH2Kktx9tK+9DFKyzCuitbZo91rBbvIekn4O+a7qE8ZBB09qP2YJgf3B5LccyUUaxHMUkWxUYVi5TuhMcPoBd2rH3h8xZtDFspmyvdtouLn2I09rGfOtpmuRZ+efE+sd6+ilmFE3WKQDnaG0YEhAGKOJnO7y6tosdhfkoT6MIRsB/aBBwsqBuk9qLGXcW0hW5ItnkzagKmkWVp79sfKfj4QfUDsq3G0YTY7qFQ3oIiiOi8iG8PRtHMfTS3TJ1z+udc0he/C134Tl770SBwzk6bWk303jLIyFNMRs+ZmxEEjYk4IkhRutf7ERweMck/SFRHZw8gm7y4uleWpwQVHNZPI30AM71bgdoO1Ce7lQoPolq8Eg9Tff6z+P+twHQgy0pb+wjM7PgU8j7IoUzRL5+doo2S5XIQW+doOfhwPeyglCj7By/yF1e0Llag6U6eSjIJNcUOjuPiWAZbCV0LLneiirs1
 7DKVdfMe
 WZutObTP6eZUCsTRfWnS1f70BEUmdKKH8Y8NEGXeEvJvaAJFcfEy6Wl0N2VdN1ipLxWw/OvzTxFozucsLbw0dHFLaI7YqyKD/u8OfM+zKF1Ys2KS/wru8+qx2AE2MTa7ZDwbF1792MjiFJgI74WEKyd22XnYbfAopDZ0rUyaRZUJkRXlhy9rfq5gQcx+suQ7P5dVwOpaFwIGjgq6gORq4C1RpLmNVzqxyz/FXhvTEb/tIIYLUucW2KKQV3YWnYOwJY1SXtuOmEbvaA89MNO5VznsQS1xUxYojMt4olTG2mJlIe02H985g26g8lEXCfBdoMGq2OsAG0zi4tgz+SjfKq4D7o7SyYVtOPjOWKM3odOxbxdEXDzYOH9/6Y8JcISrEjb7G2LuvdolaQ3++TYNCpvPEifLGyZEhCgZqFrRz1oXXKS/HrnObq1tvXg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Oct 27, 2025 at 03:10:29AM -0700, Hugh Dickins wrote:
> On Thu, 23 Oct 2025, Kiryl Shutsemau wrote:
> 
> > From: Kiryl Shutsemau <kas@kernel.org>
> > 
> > Accesses within VMA, but beyond i_size rounded up to PAGE_SIZE are
> > supposed to generate SIGBUS.
> > 
> > This behavior might not be respected on truncation.
> > 
> > During truncation, the kernel splits a large folio in order to reclaim
> > memory. As a side effect, it unmaps the folio and destroys PMD mappings
> > of the folio. The folio will be refaulted as PTEs and SIGBUS semantics
> > are preserved.
> > 
> > However, if the split fails, PMD mappings are preserved and the user
> > will not receive SIGBUS on any accesses within the PMD.
> > 
> > Unmap the folio on split failure. It will lead to refault as PTEs and
> > preserve SIGBUS semantics.
> > 
> > Signed-off-by: Kiryl Shutsemau <kas@kernel.org>
> 
> It's taking me too long to understand what truncate_inode_partial_folio()
> had become before your changes, to be very sure of your changes to it.
> 
> But if your commit does indeed achieve what's intended, then I have
> no objection to it applying to shmem/tmpfs as well as other filesystems:
> we always hope that a split will succeed, so I don't mind you tightening
> up what is done when it fails.
> 
> However, a few points that have occurred to me...
> 
> If 1/2's exception for shmem/tmpfs huge=always does the simple thing,
> of just judging by whether a huge page is already there in the file
> (without reference to mount option), which I think is okay: then
> this 2/2 will not be doing anything useful on shmem/tmpfs, because
> when the split fails, the huge page will remain, and after 2/2's
> unmap it will just get remapped by PMD again afterwards, so why
> bother to unmap at all in the shmem/tmpfs case?.
> 
> But it's arguable whether it would then be worth making an
> exception for shmem/tmpfs here in 2/2 - how much do we care about
> optimizing failed splits?  At least a comment I guess, but you
> might prefer to do it quite differently.

It is easy enough to skip unmap for shmem.

> Aside from shmem/tmpfs, it does seem to me that this patch is
> doing more work than it needs to (but how many lines of source
> do we want to add to avoid doing work in the failed split case?):
> 
> The intent is to enable SIGBUS beyond EOF: but the changes are
> being applied unnecessarily to hole-punch in addition to truncation.

I am not sure much it should apply to hole-punch. Filesystem folks talk
about writing to a folio beyond round_up(i_size, PAGE_SIZE) being
problematic for correctness. I have no clue if the same applies to
writing to hole-punched parts of the folio.

Dave, any comments?

Hm. But if it is problematic it has be caught on fault. We don't do
this. It will be silently mapped.

> Does the folio2 part actually need to unmap again?  And if it does,
> then what about when its trylock failed?  But it's hole-punch anyway.

I don't think we can do much for !trylock case, unless we a willing to
upgrade it to folio_lock(). try_to_unmap() requires the folio to be
locked or we will race with fault.

Maybe folio_lock() is not too bad here for freshly split folio.

> And a final nit: I'd delete that WARN_ON(folio_mapped(folio)) myself,
> all it could ever achieve is perhaps a very rare syzbot report which
> nobody would want to spend time on.

David asked for it. I am fine either way.

-- 
  Kiryl Shutsemau / Kirill A. Shutemov


Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5DF6ECCD1AB
	for <linux-mm@archiver.kernel.org>; Wed, 22 Oct 2025 10:00:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BE4948E000F; Wed, 22 Oct 2025 06:00:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BBB728E0002; Wed, 22 Oct 2025 06:00:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AAAB98E000F; Wed, 22 Oct 2025 06:00:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 969138E0002
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 06:00:55 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 5CA9B885E8
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 10:00:55 +0000 (UTC)
X-FDA: 84025306470.17.039BCEE
Received: from flow-b8-smtp.messagingengine.com (flow-b8-smtp.messagingengine.com [202.12.124.143])
	by imf27.hostedemail.com (Postfix) with ESMTP id 489904000F
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 10:00:53 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm1 header.b="Y eMYDZs";
	dkim=pass header.d=messagingengine.com header.s=fm2 header.b=zJXW95sw;
	dmarc=none;
	spf=pass (imf27.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.143 as permitted sender) smtp.mailfrom=kirill@shutemov.name
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761127253; a=rsa-sha256;
	cv=none;
	b=VqcwBfaXVMiI1kP+TPZCQwF2S1ZZoZahWg1iU3iGeYDy7Qc64OJRnCdM9ruXkK/tn1HWUx
	NlJBTqgrVepoGdRYWr8CLjbwEfTUNGxrFKowVzhlEnGKWjhkDx1BqT1zln0cxF+Ya1hHJM
	EYjGczZbJoNhf+ES8gvyOoaQyyf66d4=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm1 header.b="Y eMYDZs";
	dkim=pass header.d=messagingengine.com header.s=fm2 header.b=zJXW95sw;
	dmarc=none;
	spf=pass (imf27.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.143 as permitted sender) smtp.mailfrom=kirill@shutemov.name
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761127253;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8u8y4To0tEWw0CRRVqrcDDxwXTLXCbG926ERuBgD0nU=;
	b=S9Sytdq8S1xvMfisQIMdye5m5qzcK/jFbDiiENAin98/GGqhC3b5t/8aWH3sjlJK1h0I5k
	E1es1PN2HthjJDCFPl4knZzZVXGRj36t5kVdRr7uAbKEQuewsMWKMV4jleSyLOK+w5KALL
	8+leTZjrc6NZuIK84zmbNiwx24Q5XaM=
Received: from phl-compute-01.internal (phl-compute-01.internal [10.202.2.41])
	by mailflow.stl.internal (Postfix) with ESMTP id 051BA13011CA;
	Wed, 22 Oct 2025 06:00:51 -0400 (EDT)
Received: from phl-mailfrontend-01 ([10.202.2.162])
  by phl-compute-01.internal (MEProxy); Wed, 22 Oct 2025 06:00:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-type:content-type:date:date:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm1; t=1761127251; x=
	1761134451; bh=8u8y4To0tEWw0CRRVqrcDDxwXTLXCbG926ERuBgD0nU=; b=Y
	eMYDZsQScFnkdFHzsx2yRGqx7FiBRYjbFbDwpTN9aTuwiJmZvdqb21f2yR67i2+I
	N/viBjZDK6hhsUTMLuoweq9HiPv0fWaAcCjEkDjUp+zU6gDEjE3VdqF0wnFKFm3g
	URotusj/ufAqK78MOMFyXzAs3UqnhdTzJ/g3Vh3qInpjzMOhwIcyfYLjUyuS2YDE
	G1knp9YDRFu/zI6uJgIs7pljcEr9/cHCCn5Q52+WAcRt/jUToQ9jfIQ0kF//PgB4
	BMx/mHgZ921d5qgWwoWtgZUAfUInk3lqT3KExUkjwNxURWBLjuInY4Kb4awhfNQ5
	V4KIip7tU1Qr5ixk7iiOQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; t=
	1761127251; x=1761134451; bh=8u8y4To0tEWw0CRRVqrcDDxwXTLXCbG926E
	RuBgD0nU=; b=zJXW95sw7Ml0P0eQ0f6ppKw0/57o5+f9HNlyC+N7HE7XdE76UQ+
	nUWaTK/fM/FRGgDX6LGasuzlpyQRnIoOY44O55G0b5E+SHJtr6Iy6jNQAHjEi592
	1tWblmF62Ko5c9Dr9NKTUB/PIH0tZUGyDueS4bNtTA/g/pgKpyOfIjbiCZq3Rub5
	OExnteZ840Zi8ikTm63tZFfmhy0wuz7Q4aHjnVJ/YLR/xOCrmt78h756soKPIOEq
	kI1xKEdVckhdsjxE/SGXJclWOQN1UbqZm3WdVcDJpD87xDnxg/+l4ARgWpIs1B+f
	Y8BO+ZSnDjSb/lDqSB+D5D3RV/v7LYLB6lg==
X-ME-Sender: <xms:Uqv4aJ9_pipJeJZzEx7zSMAQrv1Jna9MFFwC49brqIWcqZtyiOtkjQ>
    <xme:Uqv4aCkkckpqUNXE0CGcECjwrJdcOAhzt44cdYsQjrCAx0djnTlEoljKCJY3t_pYR
    omqUIRMLRShv7VSMhrsF2wgBKu5bsVin1r22AFrjaHH3AzFcK1jqgo>
X-ME-Received: <xmr:Uqv4aElMDnujjHu-WBvBp8PsZ5GVb-5JP3DXQWy6ahiTKCSqDIqmhP4uTcFgUg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeeffedrtdeggddugeefvdekucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhepfffhvfevuffkfhggtggujgesthdtsfdttddtvdenucfhrhhomhepmfhirhihlhcu
    ufhhuhhtshgvmhgruhcuoehkihhrihhllhesshhhuhhtvghmohhvrdhnrghmvgeqnecugg
    ftrfgrthhtvghrnhepjeehueefuddvgfejkeeivdejvdegjefgfeeiteevfffhtddvtdel
    udfhfeefffdunecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrh
    homhepkhhirhhilhhlsehshhhuthgvmhhovhdrnhgrmhgvpdhnsggprhgtphhtthhopedv
    vddpmhhouggvpehsmhhtphhouhhtpdhrtghpthhtohepphhfrghltggrthhosehsuhhsvg
    druggvpdhrtghpthhtohepthhorhhvrghlughssehlihhnuhigqdhfohhunhgurghtihho
    nhdrohhrghdprhgtphhtthhopegrkhhpmheslhhinhhugidqfhhouhhnuggrthhiohhnrd
    horhhgpdhrtghpthhtohepuggrvhhiugesrhgvughhrghtrdgtohhmpdhrtghpthhtohep
    fihilhhlhiesihhnfhhrrgguvggrugdrohhrghdprhgtphhtthhopehvihhrohesiigvnh
    hivhdrlhhinhhugidrohhrghdruhhkpdhrtghpthhtohepsghrrghunhgvrheskhgvrhhn
    vghlrdhorhhgpdhrtghpthhtohepjhgrtghksehsuhhsvgdrtgiipdhrtghpthhtoheplh
    hinhhugidqmhhmsehkvhgrtghkrdhorhhg
X-ME-Proxy: <xmx:Uqv4aPjgjuuGBEii7mqfbLzuv9prb0mNFZL58i9IuE9B0a1x-RVFXg>
    <xmx:Uqv4aNXy3LroYwNprzGQ9JZZekfZ67SrQzeq1uEvFBXRhJ9UAqJnSQ>
    <xmx:Uqv4aBgKxXLw8qdx8pKwgxTxsBp2-aHhvBhMnfDlOL9fKOG0j44-nA>
    <xmx:Uqv4aB4c1EtXZtt9qu8JG7J2jjvnnq57AvdHFTFkXZanDr_5YVS6TQ>
    <xmx:U6v4aBM_z9nVkV-txhieRu5kcE2C8ckrvIMcP4fVw6TRrsJzCb_Xj7aC>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 22 Oct 2025 06:00:50 -0400 (EDT)
Date: Wed, 22 Oct 2025 11:00:48 +0100
From: Kiryl Shutsemau <kirill@shutemov.name>
To: Pedro Falcato <pfalcato@suse.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, 
	Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@redhat.com>, 
	Matthew Wilcox <willy@infradead.org>, Alexander Viro <viro@zeniv.linux.org.uk>, 
	Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, linux-mm@kvack.org, 
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/filemap: Implement fast short reads
Message-ID: <djnlhsgjokfx53nvtdhosdfwcoxdl6aaqsmy22ywe22daamsue@uvsbyygxjrhp>
References: <20251017141536.577466-1-kirill@shutemov.name>
 <zuzs6ucmgxujim4fb67tw5izp3w2t5k6dzk2ktntqyuwjva73d@tqgwkk6stpgz>
 <CAHk-=wgw8oZwA6k8rVuzczkZUP26P2MAtFmM4k8TqdtfDr9eTg@mail.gmail.com>
 <2dyj6zrxbd2wjnor2wswis5p5z7brtfgzjnhbexhjsd3kqnvx2@y6i2wnvr6gdr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2dyj6zrxbd2wjnor2wswis5p5z7brtfgzjnhbexhjsd3kqnvx2@y6i2wnvr6gdr>
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 489904000F
X-Stat-Signature: 5mwr3tbbgwpyor6kfpajzr8upcjepfs7
X-HE-Tag: 1761127253-78525
X-HE-Meta: U2FsdGVkX1/Jc9JrgHq5ty3NSrfik5/exV9Hivj84I7izowK2JAKJwT1VIJ2wR4omcHvrtaLqO/F6XkfSCZnwt+/lrg5+/WImMbonodJI39Y3JnD8o8lT8VIbcGk57HpbEYKiySC6fmyKNpMcI96DRJdG6gCFfF4Z7noFH44nVK/4mCqwJ8+zNt5TFyAe0SaagNKoKn9p5AH1chQvjgoxbAh4KvHJtHvGI05d6Mf9rhEz+juc9Bnt+2Nf+L7iK74hp4TtYGnmW7Otd34ZioV/OMO3m1zf03bhNSDySlRyWm67iZH6DeJwezQX8ifbuJQy3hkLsy+sjQJwwodGNgdSuoCa9V/lYIBp3Yy4LHbIs8vxT0KuTCGlrnlVf0L+nvaXuscZtYPyyn2ncubvoPTcZp3rV8MlLqioZYbUSUlYVF23BGq9a523xLKc40lgkYhJBabY0PSSdrF9+6WoNlmS+pvzUYamu2yOyuP1yV5tMiqvAmnCsgM/GYveSIDvlR8p3y0AddEh8uJ6NYBpKA9draVzrAFWg3yF7MyRO1NpUDVqrMHaO3+UARm1nFPjIiE1MozD5plqwYrG6a2T9VebTVi4WryfAMP5qScUgTX0SXd8yVNuAoZrZ6vz4ttZ2xCBSSlAtGgZTWKq+5hzupzdIazctXkYFVDeQZlCgRW8YY3B1ZbF3dhHWIbqHDbX1bZDrfULh8B9BvKOmsNxpwJ4z3KJy4Pxs3H0BTOgzBuLeIEoRpTRyGGbeSNsCdOO9egmzL9V0hCpydaMIp9mlheiEKzuXkeVS4g4DJeyGFMw//Av/sMrbDTM38hDXiqdZYjnVFTPOqOqOVuf2zM0ayVyVE8eZmrSdJKTqIin3L1jd9BYj46D71NcLdadwbnq0J8cEAB0gjKYjgEJz2ZBZrWPNoWs98auYbmbnbzulwCNljIk8z9/p7qs1AEZqB1CCjrhtPZXiy0fxAHGBYbWPX
 hVA1GPHn
 kXveYhOtjF1mvfe+RALGMWWUYqmSkkP54lNmZnr07yKBw60vBjqSGJtyCK9uqrgA4my9z+7jusUzFPxAIfZ16fe3DEIaaTiUPWksqkRtsRornqIoQYusERYi5nAsfOL/elVZlwhrrXdaXbyPQ1YZ1X2oAMQxGRJYlVBs0AlFfHIRIWXhPu9azGxzWSBUkcF8BhO0ney1dZ/kB124uN25s2GAngU/W56DFK0od6mF8Vqju7chWRC3HXZkxdlStvobRe7yPiBCTwrsHiwZDfSLHz7l8pG5n08jryxN0mGSt9qCsJ72wIGyDc0QnaEIgJ35oL4Yn8rkiwgcexQTQxIho9oBtv9Zxw5TFse32B+1XxQW793gBXem0peH0UVUguk6X3CwY/8SZSag0MRv4x49Ftx8GxSLzCjMMonWN0+MbDnwrA11iMZWk+RrASA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Oct 22, 2025 at 08:38:30AM +0100, Pedro Falcato wrote:
> On Tue, Oct 21, 2025 at 09:13:28PM -1000, Linus Torvalds wrote:
> > On Tue, 21 Oct 2025 at 21:08, Pedro Falcato <pfalcato@suse.de> wrote:
> > >
> > > I think we may still have a problematic (rare, possibly theoretical) race here where:
> > >
> > >    T0                                           T1                                              T3
> > > filemap_read_fast_rcu()    |                                                    |
> > >   folio = xas_load(&xas);  |                                                    |
> > >   /* ... */                |  /* truncate or reclaim frees folio, bumps delete  |
> > >                            |     seq */                                         |       folio_alloc() from e.g secretmem
> > >                            |                                                    |       set_direct_map_invalid_noflush(!!)
> > > memcpy_from_file_folio()   |                                                    |
> > >
> > > We may have to use copy_from_kernel_nofault() here? Or is something else stopping this from happening?
> > 
> > Explain how the sequence count doesn't catch this?
> > 
> > We read the sequence count before we do the xas_load(), and we verify
> > it after we've done the memcpy_from_folio.
> > 
> > The whole *point* is that the copy itself is not race-free. That's
> > *why* we do the sequence count.
> > 
> > And only after the sequence count has been verified do we then copy
> > the result to user space.
> > 
> > So the "maybe this buffer content is garbage" happens, but it only
> > happens in the temporary kernel on-stack buffer, not visibly to the
> > user.
> 
> The problem isn't that the contents might be garbage, but that the direct map
> may be swept from under us, as we don't have a reference to the folio. So the
> folio can be transparently freed under us (as designed), but some user can
> call fun stuff like set_direct_map_invalid_noflush() and we're not handling
> any "oopsie we faulted reading the folio" here. The sequence count doesn't
> help here, because we, uhh, faulted. Does this make sense?
> 
> TL;DR I don't think it's safe to touch the direct map of folios we don't own
> without the seatbelt of a copy_from_kernel_nofault or so.

Makes sense. Thanks for catching this!

-- 
  Kiryl Shutsemau / Kirill A. Shutemov


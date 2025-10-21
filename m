Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 33824CCD19F
	for <linux-mm@archiver.kernel.org>; Tue, 21 Oct 2025 06:17:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8E1F88E0009; Tue, 21 Oct 2025 02:17:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 891528E0002; Tue, 21 Oct 2025 02:17:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 788798E0009; Tue, 21 Oct 2025 02:17:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 639B78E0002
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 02:17:19 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 09C791A0430
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 06:17:19 +0000 (UTC)
X-FDA: 84021114198.07.F2DE18D
Received: from flow-b4-smtp.messagingengine.com (flow-b4-smtp.messagingengine.com [202.12.124.139])
	by imf26.hostedemail.com (Postfix) with ESMTP id 1A999140007
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 06:17:16 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm1 header.b="j BkDXb9";
	dkim=pass header.d=messagingengine.com header.s=fm2 header.b=SwGlFmQy;
	spf=pass (imf26.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.139 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761027437;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ThkdY/C21GPPtmJaBNezXHfzXuqV664YAK8ByLyyrfs=;
	b=BH3E4yOfQgNuJ8W8fDjQvit+9Q+y7JKedRMs/AUfufft+SPpjvuxtY/k379qBZcb5uulyd
	B2HPIwwOBc4tIlVqoYYXcXv9tsSQYpZgNnPpF+4q9bZC9I4Gwk/PWEXyzb9ZG/Zu4zXJVK
	GdvqyiZOsCH03dUB9xngLLZBmPQAqX0=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm1 header.b="j BkDXb9";
	dkim=pass header.d=messagingengine.com header.s=fm2 header.b=SwGlFmQy;
	spf=pass (imf26.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.139 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761027437; a=rsa-sha256;
	cv=none;
	b=E+MfIfZ8C/3n+xY2dptA/pjVpAUXXaymTcwU/mkVD89Eg/ueIhkm/O5Y2sgR/gBkwC1dC2
	49BN+b73LKnxXClLzTJdUlQAdsotTbWKyfvzBU463JbL5D0zZp4UxWE5Aq1TQSUoqsLRBr
	Uq2ZLzM4kzfNjAMGfAZl2opHieljFd0=
Received: from phl-compute-10.internal (phl-compute-10.internal [10.202.2.50])
	by mailflow.stl.internal (Postfix) with ESMTP id 0887A1300ACC;
	Tue, 21 Oct 2025 02:17:15 -0400 (EDT)
Received: from phl-mailfrontend-02 ([10.202.2.163])
  by phl-compute-10.internal (MEProxy); Tue, 21 Oct 2025 02:17:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-type:content-type:date:date:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm1; t=1761027434; x=
	1761034634; bh=ThkdY/C21GPPtmJaBNezXHfzXuqV664YAK8ByLyyrfs=; b=j
	BkDXb9FTfW5u1Pbb6r2Zr3VIG72LKLw9nP9YQOlOupyXBz0s755d9Um35dkpZN63
	I0Uef+OM6YOOlLsIcEoJtikl3xyLapw96UV1ssVhuz5QXCPo2hIR3HHuq7tMDGY2
	58mQjV9AmE9WkO5v87YTKv3WvXTH0Mzuv6GrHXpLrn5wVp+uHl9G/UtGuSCPnuZw
	vwEQaWyTRz1KV5apsZKdY+Fq3glU/Km7NFtk1WlTD7H88AOGfKkXC/iENwUf2PPx
	jtjeK0o5qqx8Kh9PGTS744xDLujWknV2MNIOIHRFXPn3GPDa9C4CFI1NHQ1lvMBt
	CSb12LPEGkaw74oFKuCyg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; t=
	1761027434; x=1761034634; bh=ThkdY/C21GPPtmJaBNezXHfzXuqV664YAK8
	ByLyyrfs=; b=SwGlFmQyJV/PUgWB9SDj8yguYqU6M02H/iwHNvXmSHlFlJWSi3H
	kIShHsNjDTPJvlQR1G0NkOXLVQQnarKseCczRENjeW4f2/jTVqqrDnx99y1xAXwD
	7aH71MEqkok1ZR86ML/9a7+bnbqZxsxDD4Xbuf7+uJ3iNt30RCnrRiFrixypWMZJ
	7hn4PFxDdp3x9LU/kfyTjNnUxVFPdp5+uxLLuMNV+oqpqgVqdelQ8yCOFQoMS+Bx
	tQVgcSObMnUNEKS/RRs639uYCuVsXuAy8goq318P6gQSvQsVxv6C6Ev8BEbF13qc
	QtR7z9k+yFXihMGqPAq3DbMQTPF9AoL+qhg==
X-ME-Sender: <xms:aiX3aKJUQ4w9jII6ojRPfsoLw8bmWwE-vMOPiDCVSmdCc_Ma17RgmQ>
    <xme:aiX3aDqx03n7NVDXm4A-71ZXHDANSiXBKGt83n_YX-1pOKqaX2_bd89uKQH9X5lqa
    8rTARffDzmTe9-t-m3BrYAlGNlLG-N5AIfFDyslM2xEczBFctud>
X-ME-Received: <xmr:aiX3aDUg7XIAOg7-dyN3dlAFXSuQfRptLP4PiBaTif9kcg3A516IjBkhKedgew>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeeffedrtdeggddufeelleeiucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhepfffhvfevuffkfhggtggujgesthdtsfdttddtvdenucfhrhhomhepmfhirhihlhcu
    ufhhuhhtshgvmhgruhcuoehkihhrihhllhesshhhuhhtvghmohhvrdhnrghmvgeqnecugg
    ftrfgrthhtvghrnhepjeehueefuddvgfejkeeivdejvdegjefgfeeiteevfffhtddvtdel
    udfhfeefffdunecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrh
    homhepkhhirhhilhhlsehshhhuthgvmhhovhdrnhgrmhgvpdhnsggprhgtphhtthhopeeg
    iedpmhhouggvpehsmhhtphhouhhtpdhrtghpthhtohephhgthhesihhnfhhrrgguvggrug
    drohhrghdprhgtphhtthhopegurghvihgusehfrhhomhhorhgsihhtrdgtohhmpdhrtghp
    thhtoheprghkphhmsehlihhnuhigqdhfohhunhgurghtihhonhdrohhrghdprhgtphhtth
    hopegurghvihgusehrvgguhhgrthdrtghomhdprhgtphhtthhopehhuhhghhgusehgohho
    ghhlvgdrtghomhdprhgtphhtthhopeifihhllhihsehinhhfrhgruggvrggurdhorhhgpd
    hrtghpthhtohepvhhirhhoseiivghnihhvrdhlihhnuhigrdhorhhgrdhukhdprhgtphht
    thhopegsrhgruhhnvghrsehkvghrnhgvlhdrohhrghdprhgtphhtthhopehlohhrvghnii
    hordhsthhorghkvghssehorhgrtghlvgdrtghomh
X-ME-Proxy: <xmx:aiX3aBZnG-ZV_4luYvFZpInhDnYtfDRG7P0tDbPX9MWlT8uXaFOc-w>
    <xmx:aiX3aEviEPwclsfWJ_0iXO_8_Aa55qLyoEWI7vz1M23KTlSqCEu7zw>
    <xmx:aiX3aIoBf-j0YZ_FDUN6TmK2qmANbmPNVQmdG3dyGIdOKBUNaBAt2w>
    <xmx:aiX3aEKaDNlUXOJmV5ONHKDtWHioydnBD5JTyYQJOwskcyh9ar4HbA>
    <xmx:aiX3aOz0zFfSTrsVWO04AryR85bzqMmoIOXlNHl2tcwU4ZwddTs2TMLq>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 21 Oct 2025 02:17:13 -0400 (EDT)
Date: Tue, 21 Oct 2025 07:17:11 +0100
From: Kiryl Shutsemau <kirill@shutemov.name>
To: Christoph Hellwig <hch@infradead.org>
Cc: Dave Chinner <david@fromorbit.com>, 
	Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@redhat.com>, 
	Hugh Dickins <hughd@google.com>, Matthew Wilcox <willy@infradead.org>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Rik van Riel <riel@surriel.com>, 
	Harry Yoo <harry.yoo@oracle.com>, Johannes Weiner <hannes@cmpxchg.org>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	"Darrick J. Wong" <djwong@kernel.org>, linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [RFC, PATCH 0/2] Large folios vs. SIGBUS semantics
Message-ID: <cas6g5sw6bffqo5e634tmyivdamcagoynztic7s53634mv2kwk@6a552oryikew>
References: <20251020163054.1063646-1-kirill@shutemov.name>
 <aPbFgnW1ewPzpBGz@dread.disaster.area>
 <aPckWHAGfH2i3ssV@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aPckWHAGfH2i3ssV@infradead.org>
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 1A999140007
X-Stat-Signature: ahsq1iforyh4bdopmkc13kqrfsyf3941
X-Rspam-User: 
X-HE-Tag: 1761027436-929442
X-HE-Meta: U2FsdGVkX184F9ymUgw9jnsrwYz1jbhQj7ai02rYYsWtIgZBl9pVkuB04BpOixSFf1ggp7YQJH1ZR6/uHYSteD+t5+X/1jWKcQUnZJPKmW+FYn4Smmy57ppq5A5c9biIRLhGQCQpVSsI8Lnnq+iQ7cznGnTRfNc5A3OltC9Pv8vA1q9beoyTadPDy6GK3boWjLoz+CFwgjb49ciKkpbLdpwDs7V/z+13ktr05t4kR3lavZ945SrX+dhyqdUuD3dy2qqApUO2matdz2MvOBibUA+A8/sC4DVCHPvcL0q25g5CWZymzBxKHiGDTX269dS9PC9JGP/fRUS0lYuBtiEpRkfFQLEjTpEjdqcLBjOXT/p3Y3YhzYbIicW8O0jjv4JOll9rJv8OgZyX4HjjRh654WQDYWdBF9e53eK74ktaMBEZ+a+7cTxV2PgExcpRxOukErXhfDENl2LLS72u2Wp0uWa/CFInGqaKUgK4Z8XqUlWIybF+n1oMQMnPMZxxNTcqTPR1vgIgUvtXw545lQsjMksMIyHSOZ+rgPT3fJqNct3dnuLQQgRmw2imwpRtTuzuX4jit/IxMIn8McimDLE6bshztc72wuhLhzWT53jhKtX6neslhmRlIzcFf/qqC/0o7xDVPejs76fwBSCjQUvwBP1BT7fUmj60AU/MWbus0wnYN83BryuODxSbV24NAvPgxzhnufRfcuUlfYDzlwxFZc9vP45E8s02YLz60XTwnEoReuXg19FZs4iX9b6c8R5x63VAD/XM7B/VGZREmK1BBtc/PfQ+G3E/VfRSanfOs0qQtpGXIVzmB3Ftv+UlPl4Om3DLd3VKDc0ezeqVdT1UYitxEm5l0OCIhlukxls+81i5jGzl2xIfAF/FLPVp28IbIHR7RvCBIkWLyTZEzh+IIcKHiYPgTyT03k4/w/zPjPCbegetPvSU5MJxoFVMLlHv4/fD6TvsivPbtpMhTb0
 q5QE5Hhb
 e5ib3OIxLvocfvbIZ/O237M/h/e33r1fvk48MggrNX5Zt2kQmph5qIGwDCGnnOK5PkmDu06iFtBHLvvNsTjzHnH0oLE9LesXSgJD+GvHsJuXf/0FigWpM9FoF/fQ/Y4dSqm6VxMUT8N0weLRUbdNiFaLWWEAE/qCkmMe5cNHhTbu8/IcsyON0Eeud/wbxMQLxQvRDBOBqZyIjtnqmru4jPYD0DM6bqOU9SDak3/85dBS1ysiRI4y+7D5zh7CyjBq8C4slo1N7COI10ZQ4sVUeaMs5CUoR7owUvZ8c+EMrWMqfBTWwlq9S20OfotGPv0Nj3etNGvTAjb8T2vP8lqmMo8saZNgedrBgG+3kzFG810XgMRKGwvF2P0sw0RYeoGimoE1EZ/X67iXZlUrlmPMfnRiVComFn7mqZN7XXqiYCFOBShiv5mdXDZ/DDqhGVBo6n9om
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Oct 20, 2025 at 11:12:40PM -0700, Christoph Hellwig wrote:
> On Tue, Oct 21, 2025 at 10:28:02AM +1100, Dave Chinner wrote:
> > Fundamentally, we really don't care about the mapping/tlb
> > performance of the PTE fragments at EOF. Anyone using files large
> > enough to notice the TLB overhead improvements from mapping large
> > folios is not going to notice that the EOF mapping has a slightly
> > higher TLB miss overhead than everywhere else in the file.
> > 
> > Please jsut fix the regression.
> 
> Yeah.  I'm not even sure why we're having this discussion.  The
> behavior is mandated, we have test cases for it and there is
> literally no practical upside in changing the behavior from what
> we've done forever and what is mandated in Posix.

Okay, will fix.

-- 
  Kiryl Shutsemau / Kirill A. Shutemov


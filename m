Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6E0B8CD4F25
	for <linux-mm@archiver.kernel.org>; Fri, 15 May 2026 00:01:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 982D36B0005; Thu, 14 May 2026 20:01:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9336C6B0088; Thu, 14 May 2026 20:01:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 849AE6B008A; Thu, 14 May 2026 20:01:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 76CC56B0005
	for <linux-mm@kvack.org>; Thu, 14 May 2026 20:01:41 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 28B5CA0764
	for <linux-mm@kvack.org>; Fri, 15 May 2026 00:01:41 +0000 (UTC)
X-FDA: 84767700402.05.8442631
Received: from invmail4.hynix.com (exvmail4.skhynix.com [166.125.252.92])
	by imf22.hostedemail.com (Postfix) with ESMTP id 6B09EC001D
	for <linux-mm@kvack.org>; Fri, 15 May 2026 00:01:38 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	spf=pass (imf22.hostedemail.com: domain of byungchul@sk.com designates 166.125.252.92 as permitted sender) smtp.mailfrom=byungchul@sk.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778803299;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=SV8FHgvgiIzRAdzAytE3mkiNYKJtvFc2urXerM26Cs4=;
	b=FFOrenkp8ANXJhUoUNiWslzRDa9sdwxMv2RbDcGKhiu+ClNFT7KM5t39QF0WMoxRMOPHFZ
	cmcPfQSN+EVk4jA9Jd6qXq6m/NdurDG7BQPppAcqhE3j+eFdv3reZMy8DN6ux/uuMWkMmD
	9pruKUjm1wQBdUMLtkERcD9wInlTnW4=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf22.hostedemail.com: domain of byungchul@sk.com designates 166.125.252.92 as permitted sender) smtp.mailfrom=byungchul@sk.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778803299; a=rsa-sha256;
	cv=none;
	b=Th4ha7/gabtVxoiMb5/HuZYc8BoSk0RSvfiGh+rPubBjtj6AiL1CBKHAFdsDZzbbCXpOG0
	X+aBM3HXgwW/lYnhgv5o3oEv64pMbUBudeAFIeTodSRHrIEj4n0ZNs3BhjbTQm3Yae/3HD
	gB6O8XeBkwvEsHmkbEtc3vqqjZs3Oe4=
X-AuditID: a67dfc5b-c45ff70000001609-85-6a06625d2aa3
Date: Fri, 15 May 2026 09:01:28 +0900
From: Byungchul Park <byungchul@sk.com>
To: Dragos Tatulea <dtatulea@nvidia.com>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>,
	Pedro Falcato <pfalcato@suse.de>,
	"Vlastimil Babka (SUSE)" <vbabka@kernel.org>, linux-mm@kvack.org,
	akpm@linux-foundation.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org, kernel_team@skhynix.com,
	harry.yoo@oracle.com, ast@kernel.org, daniel@iogearbox.net,
	davem@davemloft.net, kuba@kernel.org, hawk@kernel.org,
	john.fastabend@gmail.com, sdf@fomichev.me, saeedm@nvidia.com,
	leon@kernel.org, tariqt@nvidia.com, mbloch@nvidia.com,
	andrew+netdev@lunn.ch, edumazet@google.com, pabeni@redhat.com,
	lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, vbabka@suse.cz,
	rppt@kernel.org, surenb@google.com, mhocko@suse.com,
	horms@kernel.org, jackmanb@google.com, hannes@cmpxchg.org,
	ziy@nvidia.com, ilias.apalodimas@linaro.org, willy@infradead.org,
	brauner@kernel.org, kas@kernel.org, yuzhao@google.com,
	usamaarif642@gmail.com, baolin.wang@linux.alibaba.com,
	almasrymina@google.com, toke@redhat.com, asml.silence@gmail.com,
	bpf@vger.kernel.org, linux-rdma@vger.kernel.org,
	sfr@canb.auug.org.au, dw@davidwei.uk, ap420073@gmail.com
Subject: Re: [PATCH v4] mm: introduce a new page type for page pool in page
 type
Message-ID: <20260515000128.GA7850@system.software.com>
References: <20260224051347.19621-1-byungchul@sk.com>
 <982b9bc1-0a0a-4fc5-8e3a-3672db2b29a1@nvidia.com>
 <4af19eda-c29c-4302-92d5-c0915267fc0c@kernel.org>
 <agRB2QTbzceRgpzX@pedro-suse>
 <1817a749-8232-43ab-a0f5-350e5aade235@kernel.org>
 <f3e38c07-d410-4c8e-a572-68d52dc55353@nvidia.com>
 <20260514085402.GA63255@system.software.com>
 <f4f5e3b2-64c4-4ad2-8678-d29ae08150e6@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f4f5e3b2-64c4-4ad2-8678-d29ae08150e6@nvidia.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Brightmail-Tracker: H4sIAAAAAAAAA02Sa0yTZxTH87zPe6Pa7LE4eabZsnSbGiIMicazbN6yLHmzZRm6L8u8bNW+
	kSKt2ioDki1lNhGZXKYjgVIXUG4CprFIoVUMAgNh3lIDeTetRRx2boiGkoZSFFuM0W+//M//
	/HI+HBFrhrmlosF0UDabdNlaXsWqHi2sSdmxi89KqwungcPZwkPzdC40jHRwEGkJMuBociOY
	itwWYK6zD0Got5+H/3smEZyuCWNw3LCxEGybQeDxBhH8V3GWh7G+UQGaXV9CoP4BCxePtGMY
	Lb3CQ7EtiqEzMiHAzx2NMXGrVYCb7hIOfpupw9BuHRHgltfBw92WOQ4edBezMGA/w8KT8l4M
	gZJN0Fe9BMJ/jiP4t8EhQK+znYHwsZM8DFV6GWjrHBLghK+ah/u2AAJfzygL5bOFPBQ+DLBQ
	VVCCIDodk0+UTXFQ9cddYVOaVKAovNQz/hhL58/8xUjDFb+yknJpkJE8dr8gVbsOSa2NyVKR
	4sOSq+koL7kmjwvSneGLvHSlIspKnnsfSZ6OECMVH57gM5Z8q/pEL2cbcmTzhxu+V2Weq7ei
	/QNJuX5nGW9FvZoilCBSsobOzvSzL3la8QlxZskH9E5jLY4zT1ZQRYnM82KyklrbTsT6KhGT
	v0V6uCsyv5xIttJBe9V8SU3W0QvjzVy8pCGFmPpDp7gXg0V0oPKf+QVMkqny7CFThMQYL6MN
	z8R4nEA20Ee3/SjOb5L3aJe7n4l7KJkT6ZwtKry49C16uVFhyxCxv6a1v6a1v9JWI9yENAZT
	jlFnyF6TmplnMuSm7t5ndKHYt9X/OLutA03e/LobERFpF6q/uc5laThdjiXP2I2oiLWL1SkX
	YpFar8vLl837vjMfypYt3WiZyGqT1OnhH/Qaskd3UN4ry/tl88spIyYstSJbILOFrPUf/+Lj
	2vMNiZ6CdOwevBrYbGxFTaYtTmNQn+Z7sv3AUzfJq83oGlv12VhFxvDy6E+fZyw6tUWt90Z2
	4t9L16cn3b9xtXxk8peU6Kf5pVTDORPfrtyoCV0LdW1fUJcfvPXOV5aaobMk8Wjw/Tey1voe
	e72Vuy+vTH13SqtlLZm61cnYbNE9BxRLiQppAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA02Sa0hTcRjG+Z+7q8FxmZ6Uvqy70sUoersQfig6BIUZFYRdVp5ytk3b1DQI
	Vg4ySbPsonPS8u40rJm6eYnSpa0LhVasbM6snJZppJhrUm1G1Lcfz/P83k8vg0ssZCgjVyUL
	apVMIaVEhGj7+oyl+w5RCStuuYLAUFtDQfVkGlT0WUjw1LgxMJgaEIx7emj41dqBYMzWScHn
	9m8ISm5M4GB4piPAXf8DgbXJjeBT/k0KPnb001Bt3gau8gECWs424tB/4SEF2TovDq2eERrO
	WCp9h+u0NLQX2Ul43pBDwuUfZTg0avto6G4yUNBb84uEgbZsAuz6KgK+XrHh4MqJgg5jMEw8
	HkYwWGGgwVbbiMHE+SIKXhY0YVDf+pKGvC4jBe91LgRd7f0EXJnKpCBzyEVA4ekcBN5J3/GR
	3HESCh/00lGR/GmHg+Lbh0dx/k7Va4x/lX+R4B13H2G8Ve+keaM5ha+rDOezHF04bzado3jz
	t0s0//ZVC8U/zPcSvPXdWt5qGcP47IwRKjpkr2hDnKCQpwrq5RsPiuJvl2tRkj0kzVmbS2mR
	TZKFAhiOXcVNOrpoPxPsAu5tZSnuZ4pdxDkcnmkOYhdz2vo8IguJGJx9w3AZ9zyEv5jFxnCP
	9IXTIzG7hmserib9IwmbiXPOsWLyTxHI2Qs+TAs4G845fg5hWYjxcRhX8ZPxxwHsRu5LjxP5
	eTY7j7vX0InlIrH+P1v/n63/ZxsRbkJBclWqUiZXrF6mORafrpKnLTucqDQj3z+Vn5q6aEHj
	3VvaEMsg6UxxdCeZICFlqZp0ZRviGFwaJF7a7IvEcbL0k4I68YA6RSFo2lAYQ0hDxFv3CAcl
	7FFZsnBMEJIE9d8WYwJCtehsxtzBncL+k7HBuvIhVawy4uuQtRJGtbcu9LQMOJ+aUkwfBicf
	zzrqtiTtQcb1R0I/6d4Heq957+8qch76Pidl890Z6zZ1KJ8kR9m04UXYytj5sbqIPP3eEyVJ
	L9xL7FV97lJRd8vqqbLr2+uOx1wtPtUf17uweUdE82I4sDsyrFRKaOJlkeG4WiP7DVpNal5L
	AwAA
X-CFilter-Loop: Reflected
X-Stat-Signature: wjm5kzcq7443ujksa7jg4zhwq4n3f4b3
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 6B09EC001D
X-Rspam-User: 
X-HE-Tag: 1778803298-35180
X-HE-Meta: U2FsdGVkX19gEWpK9YC728kXAccAr+FnrUmBV04bbH4+iEn5q1Bb9QlY/+snxuQl+TS514zIUfksO87c5k/nxZr0BcaAU/LCpXnvBuhsP07etY004/a8VM1uWp8Og07LuHeBk9K0x3n0Bzd3BdJLYSg5F9kiCdyUfg2hXGvu3uYm9joUcNwEbNNnUaZ+nJzc+TsahDCD7mCXy4N/XlrghKcesmpYmVlZP1AeZLQ20ILTbXDzus1/d5FAodgBqmc0N3YGhWTByw0jRRuT3jhvQCYsqFH719xB02QEJtvVMPBxwQcC2Ln2hXgWvXpol+tJ/xIt5nef8wISDKCIb84agcQYZmVQ3Ymz+ojhIToF+yqp4AMgNsbyxxUpEAloH22O1SFcLGxAzOLkjWeijLoN4/pO7wS8fxZNCJMC4Q4n+a5mwG9wSUXKY1QUOIareyudYhFs4ATLrascXGcEP0huRJleecKa3JU+XbKxhiB6g8U5TcpHdYsscBnNFNF+DScJeONiTUXye2Lky4qZKcVeUwkOC9e9061IPgvFalWK/v6gSAa54dSBmSgnSIm+egLLkk61DSgE82XelssNVndJ3U6gi/kzpWm5RIj52jBqvH9Eu+SqbXLfMOX7sFOjKOo0bnWrw5spqJtjvgLZkCw9CQpk1ArwM/OFLPWuPaHCyCpcP2HCmjI5OGb3sba9lPbH8/K2gQQIelStuNfCapyWavHL/MvaaFkwXvzwguBWOeXwz2mq4XCzR9GbJpOABPG86aTJWbIboI2ooKaTmi9EermEd6O6m3EZcPFzx8tI86lwwU47SAbHQF6/02UxHF+fZS7IK6LTbVwy4ott1PDJuVUfvB+/+e5+0jDeCkq7JvJzbbkh96fXn1NMgn2k6MXBlJw9o66AlgYEmgviAl/I3200uJV3ZZ5j4F6W5jGeP5jkljLj1LmsSHFp2dBXDMqF+aOuAmn65v78cfL4oPT
 /tbj93me
 TOeChdqpcEsDNS/MmfCzf7qopsw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, May 14, 2026 at 11:24:36AM +0200, Dragos Tatulea wrote:
> On 14.05.26 10:54, Byungchul Park wrote:
> > On Wed, May 13, 2026 at 02:06:06PM +0200, Dragos Tatulea wrote:
> >> On 13.05.26 11:36, David Hildenbrand (Arm) wrote:
> >>> On 5/13/26 11:26, Pedro Falcato wrote:
> >>>> On Wed, May 13, 2026 at 11:12:43AM +0200, Vlastimil Babka (SUSE) wrote:
> >>>>> On 5/13/26 11:00, Dragos Tatulea wrote:
> >>>>>>
> >>>>>>
> >>>>>>
> >>>>>> Seems like this patch broke tcp_mmap because
> >>>>>> validate_page_before_insert() returns -EINVAL due
> >>>>>> to a page having a type. Here's the full flow:
> >>>>>>
> >>>>>> getsockopt(TCP_ZEROCOPY_RECEIVE) returns -EINVAL because of the
> >>>>>> below flow in the kernel:
> >>>>>>
> >>>>>> tcp_zerocopy_receive()
> >>>>>> -> tcp_zerocopy_vm_insert_batch()
> >>>>>>   -> vm_insert_pages()
> >>>>>>     -> insert_pages()
> >>>>>>       -> insert_page_in_batch_locked()
> >>>>>>         -> validate_page_before_insert() returns -EINVAL
> >>>>>>            because page_has_type(page) is now true.
> >>>>>>
> >>>>>> The patch below fixes the issue. But is this a valid fix?
> >>>>>
> >>>>> Hmm the check traces back to commit 0ee930e6cafa0 "mm/memory.c: prevent
> >>>>> mapping typed pages to userspace"
> >>>>>
> >>>>>> Pages which use page_type must never be mapped to userspace as it would
> >>>>>> destroy their page type.  Add an explicit check for this instead of
> >>>>>> assuming that kernel drivers always get this right.
> >>>>>
> >>>>> So uh, this doesn't look good I think.
> >>>>
> >>>> Yep, you fundamentally can't map a page with a type as page type aliases with
> >>>> mapcount. Even with the given diff, just mapping it will increment the mapcount
> >>>> and wreak havoc. I think we need to revert this patch for now.
> >>>>
> >>>> I'm not sure what the long term plan for this would be. If page types are moved
> >>>> to memdesc types, then the two stop colliding and that could work. I don't know
> >>>> if that's Willy's plan, however.
> >>>>
> >>>> (then there's the other question: are page pool pages really folios? not really.
> >>>> they are mappable, but they aren't part of the page cache, or anon, nor are
> >>>> they in the LRU or have rmap capabilities. perhaps we need a different memdesc
> >>>> for those. we're one step away from reinventing class polymorphism from first
> >>>> principles ;)
> >>>
> >>> Zi Yan is working on this: non-folio pages would no longer mess with
> >>> rmap/mapcounts, and page table walking code will identify them to be non-folio
> >>> things to skip them.
> >>>
> >>> It will take a while, though ...
> >>>
> >> So do I get it right that the path forward here is to revert this commit [1]
> >> and wait until the work from Zi Yan is ready?
> >
> > I think it's the best way for now.
> >
> Ack. Can you do it please? This is a more complicated revert and the risk that I
> mess it up is higher.

I will.

	Byungchul
> 
> Thanks,
> Dragos
> 
> 


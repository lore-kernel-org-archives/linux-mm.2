Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 87909606A32F
	for <linux-mm@archiver.kernel.org>; Tue, 20 Oct 2026 17:24:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=m4a1CBQI
Received: by kanga.kvack.org (Postfix)
	id B19A56B008A; Tue, 20 Oct 2026 13:24:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AA33E6B0537; Tue, 20 Oct 2026 13:24:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 96A6B6B0538; Tue, 20 Oct 2026 13:24:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 715AD6B008A
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 13:24:40 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id F10D31202D1
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 17:24:39 +0000 (UTC)
X-FDA: 85343679078.13.7EC431C
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf30.hostedemail.com (Postfix) with ESMTP id 6DD178000A
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 17:24:38 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=m4a1CBQI;
	spf=pass (imf30.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792517078;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eIkjRlsFPywszfhUFpbnPpHK8HmKO88itIC4z19/psA=;
	b=EX4rsvhRlNEufdsVqYgrhPmyoqNJPjkkuFcwIymwrtBdxNi2dZoEDIdsq6fxztI2OKam4B
	KGnsIEFMVxwZ+FJoNb7rmx3d74HQSnsbo9SC++WrcvxOmb52kJGLaGQpa/bJwJ854OaD5L
	n+G03Ym0QUTs2N4rDkMlyEP7KUM2Bno=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=m4a1CBQI;
	spf=pass (imf30.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792517078;
	b=PwhV4inyKDLvz8c0CY8GkBpICaVgkgA2JF245QYHgEau8mvv0XMMzvTlxKIbYcayp7kAOu
	CB34nrAUpmHffOLeqSBsyJbbBgcRNBx7ZpMjpYNvgqwKQCjxfqFaUkiMjDVPmwxiSFhYhi
	CcVx5890yGmBcVnrHplpA4oJECNRLW4=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 0F50860D7E;
	Tue, 20 Oct 2026 17:24:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48B6E1F000C9;
	Tue, 20 Oct 2026 17:24:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792517077;
	bh=eIkjRlsFPywszfhUFpbnPpHK8HmKO88itIC4z19/psA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=m4a1CBQI69BfnR6v51xmRl1DWdqoqGsY4yb0Kihckq4c+33a+V/KyXnYJaXsQSg74
	 jTZ1EXsaQkKhCVP4m4qL88RV67sbmshZlLbF/SJ+unh8Hfg3RR0Tq8FobU9CVhGUsP
	 Pnf/vU4gjuVTU9eM0RQ06UOUh+7J/zinSetIXZqYoWgDbPaPwjCT9Kl4RSAlbYwF2r
	 FEsvMuNQRqUKHZwMN4xV6IMD3vgEJlxTcrrPDUsqvOjV3gJjstG47qWEVAQcDKzfwS
	 pg1sfWVAXbMOPf/NMZnyRAPTBEyYJGTp7qLtbJ3XxxcVBciZnkt33WaZem33tCB7jP
	 ahKWX5JZx3+Eg==
Date: Tue, 20 Oct 2026 18:24:31 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Kiryl Shutsemau <kas@kernel.org>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, "Liam R. Howlett" <liam@infradead.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>, 
	Mike Rapoport <rppt@linux.vnet.ibm.com>, Peter Xu <peterx@redhat.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, shaos <shawnq1@163.com>, stable@vger.kernel.org
Subject: Re: [PATCH] mm/vma: avoid broken uffd merge on mremap
Message-ID: <atejkJlBfeX66_7E@gremlin>
References: <20261020-uffd-remap-fix-v1-1-0f34fc181f0a@kernel.org>
 <b61cbf73-b92a-4869-af94-72c30bbe9527@kernel.org>
 <atede4rPZKNVqwDr@thinkstation>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <atede4rPZKNVqwDr@thinkstation>
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 6DD178000A
X-Stat-Signature: 7hendpgmocicbb51o1tqrfx8igfncf5r
X-Rspam-User: 
X-Spam-Status: No, score=-11.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1792517078-470924
X-HE-Meta: U2FsdGVkX1/hzRNfqZN7c1+EKaH0KxzMcGTXq4XNl9mv+UlpKdqVNuFOLE+/iUX5mLANEvzxxBpn4dKOsWsPPo0XtBHU9IaA5nXeao5vcRtauCTBLofxoQ0RKMRU8H89IBqINgKf9dQ9gsZjcAdC0lR9NLuyHZaV1Th1Y9jydkg5+Vlaw3zNYKSlfrfrmeIJy7bHSgTIZSOdErw5Z89A82jUNWIo+q2pnH5DXSODsCq+QpOdShJEqnbcGKPaOxVCv0z0D5pgpVNWon5GTxA/5Hkxr4uq43tVkMR0YjsXD9V5RiCbgVNp39at6k1yBm1w0aFQ9xN8afQgccqwYpA92htZMIrpimARRc0YSJK0Ke8F1vyon0bpsMfOF5fMs2e8JtYPrMfZXD8101w4WG2WD+LLR1sFz4WnZIWh3BJ9qYIRR0lhnmLdpOjW0+cw9VRSFJyIodhR49KZnV3+jZvEauVJCl7GbqRfgdUy+0coqmIr7RnnJcLDeALjh105a0ZADijDvDI4Fy9urRhS528fVqVxljLsoUvooNrrhvQQQ5bd8XLzjrPTqtSoZZlvYFP2Bgkh/jZ9GLnuHGQ++gXplM1MG736d6j8/AbQGBf6YMFo0YwyeUltqgAn3J27Cr6suOjtTf4OjiXFNKL36mh2i7xXwIZ4CHBQeVd/NVx3BZqrLqF9W//vlzcl55aWLF3HgSzhhrF0lzTOw44vZqdJp003L/Xh/H65vbam6fRD5wXKDkAfhwe92kWVc/24tQPDWAb50e2t5qRRZ1/xbHUPmktG1eQy+xL5k0H+kwb1stq+gSeQiwiumUM3mJuWGOT76KndpUyhpaNEfzy8vvEVlPMOlQIJ8FcSyuQd+DnYF/zgYX38gDToYxGeGR59E8Hm300vSfSkikxwWhGDcc7NF6BMzrjAaXlAECf9YqUOd23OAhJqBDr8FJUYlPdQiW/iu3T2EYaBDPAX48SFLHu
 1EyKW9xW
 VnErJY42H9wJoSntk6qbWLS+uwTjlyAl+5Z53IfC6t0lANIF7G0RUHHSzLDRb6+8jIL1c3HA/w4N9zbCG8GuWAh8BFHz5UqiKoODhF56cP2kCVTNnPlvlJrsmMQIEWKAs1amFcGRE9P4G80dBd/lP4g1c6+R/Oaw7fJ2MeUmT1cehzS+9QJVez5c2AuP8Wul9jZ7PA3u/ocmcqVqPl4d8JuIeKZYMxjUoCSV7f1od3Eg/oFbuGnBST6HZtNUwgWomrzgqKq7OuYt3N8fc5M6Zaksxbg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, Oct 20, 2026 at 06:03:03PM +0100, Kiryl Shutsemau wrote:
> On Tue, Oct 20, 2026 at 05:51:12PM +0200, David Hildenbrand (Arm) wrote:
> > @Kiryl that should solve the issue I was raising the other day with leftover
> > uffd PTE bits outside of uffd areas? Can you review?
>
> Yes, it is the same copy_vma() merge.
>
> With the merge refused, the reset in mremap_userfaultfd_prep() only
> covers the moved range, and move_ptes() has already cleared the uffd
> bits there.

Yes, that's my understanding also.

>
> Reviewed-by: Kiryl Shutsemau (Meta) <kas@kernel.org>

Thanks!

>
> P.S. vma_has_uffd_without_event_remap() is a mouthful. With negation in
> the name...

Yeah, I thought so too, but a pre-existing mouthful :) could do with a rename at
some point though!

--
Cheers, Lorenzo


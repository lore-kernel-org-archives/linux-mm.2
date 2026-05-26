Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1C119CD5BC8
	for <linux-mm@archiver.kernel.org>; Tue, 26 May 2026 19:06:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 397B86B0005; Tue, 26 May 2026 15:06:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 348CE6B0088; Tue, 26 May 2026 15:06:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 285CA6B008A; Tue, 26 May 2026 15:06:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1AD176B0088
	for <linux-mm@kvack.org>; Tue, 26 May 2026 15:06:50 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id CB0828F244
	for <linux-mm@kvack.org>; Tue, 26 May 2026 19:06:49 +0000 (UTC)
X-FDA: 84810502938.22.BC0C32F
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf22.hostedemail.com (Postfix) with ESMTP id 66FD7C000E
	for <linux-mm@kvack.org>; Tue, 26 May 2026 19:06:47 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b="SSoMo/TT";
	spf=none (imf22.hostedemail.com: domain of liam@infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=liam@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779822408;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yElmUGyCImwgKtF1iH4Yvj2ic1czWmlIMzdE9kRv7Zg=;
	b=LIl7a0Xn9kwDeK+jGrIcPYqu0JrjMZ4bRmhOQ9hCJ5aRnykqdGUWGeYr7L9ldQsnTWDZ+/
	QzeowiTFtRY3AQOqTOaSmA+E1oW0m5RJ3IrjZ5czaIOiCghuYO2cAxCy7ZAKBQK3tiyUYd
	KElk+Qx0+WJYXjc75mQaRqL0dB5PNtA=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b="SSoMo/TT";
	spf=none (imf22.hostedemail.com: domain of liam@infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=liam@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779822408; a=rsa-sha256;
	cv=none;
	b=xAhTc3i0DCuoRWeXdfVBcOAVq+GlOqKw0HCbvfCCpm78+ZC5gLMQw+MLapjB4y4HGFS7IM
	20+K9EkCd8oAQ2VnwWuR+yQegk34gXhnwAn/02FVwi+CcNBuj/apikNbh1AXkjAU8DtTQH
	ALKWcZv1QidI36DytMcZwF1TVrzmZNs=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=yElmUGyCImwgKtF1iH4Yvj2ic1czWmlIMzdE9kRv7Zg=; b=SSoMo/TTfvWYIG3VRX4oxBCMqm
	8vd+2pPnt3FY8xx9yD21Y4w3tFUXpq2dCyp5DVHD8GT5EC+Nn8qUWBLJJAMvO34cyfKffym62SvXt
	3rw2ErYshlR3R29R/pKOq982E3ENPYTiTL5T3DrvkEKamI7sk5/cej05esQoRCvbQJKsNW5vLsxqP
	iDis9UFbbAS/a3hLyxQJWG6JzzkKKa/VeKJDPs31yKeTnIBbAyYAfvtWvAXuonDXeKu6ftWGSmmq3
	TomSpABF0myCZpNzZJ284TDz2k4q83WRzuUMp2AeQeORvctIzY91AQwGCR+dWWkzkUqWnEIYhLHcO
	Pt2BoxKg==;
Received: from [38.23.173.23] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wRx6y-00000002tKx-3GTg;
	Tue, 26 May 2026 19:06:44 +0000
Date: Tue, 26 May 2026 15:06:25 -0400
From: "Liam R. Howlett" <liam@infradead.org>
To: Lorenzo Stoakes <ljs@kernel.org>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
	David Carlier <devnexen@gmail.com>, Heechan Kang <gganji11@naver.com>, 
	Michael Bommarito <michael.bommarito@gmail.com>, Peter Xu <peterx@redhat.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH RESEND] userfaultfd: snapshot VMA state across
 UFFDIO_COPY retry
Message-ID: <nsdne5n6u5pihaw3tamillmweru2mahnsagmpxx7pkch3sgpa7@p7mdlow24axk>
References: <20260519052516.3315196-1-rppt@kernel.org>
 <a4e9fac5-e674-4528-9815-d588a35fedec@kernel.org>
 <ag2uzVgx2Xl7zi58@kernel.org>
 <e0412898-913e-4a28-b264-36438231d0ec@kernel.org>
 <ag3BNLU1b6p9u_6K@kernel.org>
 <d48f558c-1bed-44d5-bbf6-34782ebf18f2@kernel.org>
 <z6t4kefzgrdiu4zurxt63f3qdyjbjsvgyjnpxjkufj546huf2s@hq6xghp5w4ns>
 <855a00a7-c1f4-4c6d-bd4a-f3ccb0eb1eab@kernel.org>
 <ahW7MaB7Tj0IcnEG@lucifer>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ahW7MaB7Tj0IcnEG@lucifer>
X-Stat-Signature: 97wim9xkrypcpi9on7hoj5bb7xeq6err
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 66FD7C000E
X-HE-Tag: 1779822407-721915
X-HE-Meta: U2FsdGVkX1/VQppxaa69/JMjpJEOf4iSIwNmRmXZJsItt4plVqn2dy8bq/P7KxP1g72v1/A9YQVL1jN87sFYs+ZPKe5TFnVFHeVpwhDrjte74QKbTSKcHLUH1tB7u92XFOJ/q+Y2wDJVxBgmSivV4JgEg0vnBzdF+eSmMdmS+7NfMFs8e0luAwyU+UzzfiwI13d5HBQTRqvtwJ3UxXVucOalq85l/MbqmlIvXAbIEQ+J5gnMK/LsfUig1KM1VFJwORXBEIGSunvK1qH7qomT2nh5psAuXqjBqwcWH1KwGuG7QWBt/prZtUXmyJc/DN400wRra9w1aZQY75qPdtBUZyWZmgfPe40IdMa+PPnYRkNu5NCldxTFHlCCfshkizAepIh1eEtGkvwCczDOZpt+wNr1hgJdU+6e08O3deXQu+uDlfFohzojboMfeH8rz2PbPjsKVkTQkBEKSiUyzNqaZqWOvXS2s9kvIbesC4zUcfFc5GSNRnsD92mbLHCJu8O6tPJ038hrIezKu3kH6lDTEKpbyD8ttQNLFWq8NbBoIFqQ4t9XrEmzn9tiSp7dQ8Y9JYpnH/jqUAxKD4AALAEG0oBsBiDjfA5RwHlT3QkDMFuipAW/wvWyhPupfZeHhMIIm3kU67sfwuDfdbnPmP9E+V+bB/30bxcFY7FeK0pDpP1sEXNPzZL+Dn0jNJYHB92Cwe6Id0dPMDEjnID9r5HLxo8bAnKRYPA8Xxs1HuWr59Dt609n9RhSAKXdtbiwhIKKSmV+9I0wKWx05iiNAWul8BkhcZNhbRkjAKy/0wsxCpgycDfNqspM2nXVlE8mtP/wtmrecldY+pYVgXIJJJ1WPVR731wq81M8aZNXtdUp77dooNOCp2h87pLaHoD1nG9qCjhZTa5KinSFV2sDKFSDsMHtSugFj6SLOxGsXGRFWibjqASyl123GJ6U/6nObUbdcKObakcS+5OW7ZvxQ5V
 JQxr7icO
 9zNwUGtAsJZZG1xpFR7yC8kHfD5yqy24Y2IgONY+9eExVpQfbhMtWWdrJhkjPTj618kN/YJl5a5yroPupBcfI2rwxyHbfzDfc51CPSYe06XUrtGG07HXVIefPjk3+Pq9DQqPtyjSlxXDZ/jBcGJbGAjHsQPv+ONX7uG6WdbaOPWX+dAG3Y0ITiU1O6W84pM7r+LeWP0+7wxuEmwAgBsJeklxCtJBwfQaF9nWlVtnsVI7iMdew2AngduFoY5C9xzotenrjmGU79dbJh+YFv3mDyeNtCgk6egaYBLVW00vaLWmpcJbU+J/im6a9Zj5Y1B1dvvX+PWdjEwb7Dk0B97zNWlK4WRHZd1O+J3QzFTs2y/P3otaOfb1JVrC5WIyd3vqUyD6Bx8d1LmECbCaBFxg8MGM7g5zEoCJGN3g7E1z4e1gnLUej799yT0Y9EUEy9VYCPwVfVu/wmalA0iiGGQ1dXZs2fQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 26/05/26 04:25PM, Lorenzo Stoakes wrote:
> On Tue, May 26, 2026 at 02:47:45PM +0200, David Hildenbrand (Arm) wrote:
> > On 5/25/26 19:12, Liam R. Howlett wrote:
> > > On 26/05/20 04:38PM, David Hildenbrand (Arm) wrote:
> > >> On 5/20/26 16:12, Mike Rapoport wrote:
> > >>>
> > >>> Let me reiterate:
> > >>>
> > >>> A thread doing UFFDIO_COPY releases the VMA in mfill_copy_folio_retry(),
> > >>> re-gets the VMA and checks if the per-MM counter stayed the same.
> > >>>
> > >>> If another thread makes any change to VMA while mfill_copy_folio_retry()
> > >>> waits to re-get the VMA, the counter would be incremented by another
> > >>> thread. mfill_copy_folio_retry() will see the change after mfill_get_vma()
> > >>> and will bail out with -EAGAIN.
> > >>>
> > >>
> > >> Yeah.
> > >
> > > This isn't bulletproof anyways.  The sequence count can wrap.  So, if
> > > someone can replace the vma then cause the sequence counter wrap, then
> > > you can be fooled into thinking it's okay (we had this problem years ago
> > > with the vmacache using a 32 bit counter, iirc).
> >
> > If you can get it to wrap for such short durations, then how would sequence
> > counters possibly work in any reasonable context?

I think the answer is because 1. it may not be a short duration once
we're asking userspace to do things and 2. because we aren't depending
on the sequence number alone, usually.

I don't think we should trust it if we're dropping other
locks/guarantees and waiting on userspace.

> 
> Surely even for a 32-bit value, we can be pretty confident we're not going to
> see a wrap that matters (the seqnum will != the prev seqnum unless 4 billion VMA
> write locks were obtained)?

The vmacache had a similar issue and it was reported as a potential
security problem, which caused it to switch to a 64bit value. [1]  I
mean, it took 40 minutes, but it was possible..

Note that the vmacache was a bit different in that it was invalidating
the cache when the number wrapped.

And the vmacache was mm wide, while the per-vma sequence is mm and
per-vma specific, so it's very much harder to hit a false positive.
But, I guess if you can register a bunch of UFFDs and fork many
processes, you can increase your odds?

If you recall, we did try a 64 bit early on, but switched to a 32bit to
avoid a performance regression.

I think we should take a really hard look at the locking mechanics here
if we're going to try and depend on the sequence number before trusting
it as a correctness guarantee, especially when involving uffd copy.

[1]. https://www.exploit-db.com/exploits/45497

Thanks,
Liam


Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BE8D0CA0FED
	for <linux-mm@archiver.kernel.org>; Wed, 27 Aug 2025 17:45:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 162AE6B0008; Wed, 27 Aug 2025 13:45:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 138B76B0012; Wed, 27 Aug 2025 13:45:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 076426B0022; Wed, 27 Aug 2025 13:45:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id EB4DD6B0008
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 13:45:18 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 7B67584EE9
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 17:45:18 +0000 (UTC)
X-FDA: 83823263916.10.C2D59C3
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf25.hostedemail.com (Postfix) with ESMTP id C8C7BA0007
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 17:45:16 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=nqWg0qOk;
	spf=pass (imf25.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756316716;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SDgmGrewKPcgMJN7yTANkJNnqpiZONDVW+jF9TiuPPE=;
	b=v1Mn//cKyh/FCdpeXVvJdU4Z/dbgVS8mATOHrdjnG2jnwA/VY5xh3/9wE94Wxt9VyWnJjf
	B+0noSCd+CfAOrIElqA6J+bF2d99rBcQREGEVyKvkfSCxorHjrdx1cb588YePBPC/4J3Be
	G6dMkvVOFxDoCH/4oFktpC9YQIgu4UE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756316716; a=rsa-sha256;
	cv=none;
	b=OOup5JQv3pgEFRduaePCCXO8Q3EfscZWcKnbNp2uwTtrWIeZLoEFlp5CzbbLFIg0m3KTjS
	8EPJUQOVKsJ75liIIGWicQAveXSxKDQEEN7BWhc1rAaNFz9FUwOka5gCUmO3OO0AWlvFZ7
	k0IT6u56u5XEZph3gBOQDyo0zosuUxs=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=nqWg0qOk;
	spf=pass (imf25.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 2E3C1600BB;
	Wed, 27 Aug 2025 17:45:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2842C4CEEB;
	Wed, 27 Aug 2025 17:45:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1756316715;
	bh=xNXfkQNLNU/BZsp01k5SlSuBU7HR3c29BlOg7gV0ovI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nqWg0qOkA4M0KvkNSQboRV2/gRMhu963zpbZfFBU2EnOYYCph/tVq8MRRXEQDbrWl
	 UsQEm5EVyNNG0rC9qwR/AORLxw/UPyO3C8fed3sVLzafRYnpt4iFMUFOvk83HWoBpK
	 zl5Sn9VPzhDXM7NqXgauYnK9bvSBe4kQNdG8EI71huvvoL/i79zARblG2+zgpOyNxy
	 CtFtvuNlWHHS8b6eeG4y36AMQACsyvOYiRYExF8Al2418ipTmSkxBWOKQ4wwRFKXnc
	 CBLBkSXX8+HWGTVhRS4DwS0b/KkDSITU2MHY0Xuv6GG6z5OKDXJIg6DdPsqEwXtpuG
	 ZxZkFU/pvlbww==
From: SeongJae Park <sj@kernel.org>
To: Chris Li <chrisl@kernel.org>
Cc: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Chengming Zhou <chengming.zhou@linux.dev>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Nhat Pham <nphamcs@gmail.com>,
	Yosry Ahmed <yosry.ahmed@linux.dev>,
	kernel-team@meta.com,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	Takero Funaki <flintglass@gmail.com>,
	David Hildenbrand <david@redhat.com>,
	Baoquan He <bhe@redhat.com>,
	Barry Song <baohua@kernel.org>,
	Kairui Song <kasong@tencent.com>
Subject: Re: [PATCH v5] mm/zswap: store <PAGE_SIZE compression failed page as-is
Date: Wed, 27 Aug 2025 10:45:13 -0700
Message-Id: <20250827174513.47171-1-sj@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <CACePvbWzyqJJxP8BFXS_NDLcXCz-YXkt8eYBxv3CER9RpnJVXA@mail.gmail.com>
References: 
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: C8C7BA0007
X-Stat-Signature: wbzcq45f7ekzeihh4ydb3agzjyawbi3i
X-Rspam-User: 
X-HE-Tag: 1756316716-414464
X-HE-Meta: U2FsdGVkX19I63riQd1ctBqHZqLwtI3FoW/09JcoqjOquufcmAMz1veHLdr1e6CXu8SDXRS/7Nv0/7v4guMqr7eP44A8oGrUIqkOHrLO0Maf6WVpQ9w9IcPq4Mn9aQb+2yULzHrDgDbdj9+19dmPXDiwIBRAtuq6IRQPGHfRjiwBu5sZcHyNIHdUQf0bxf9SLc7Cd2hcdAIXM4n0CAswGDbWw4aaZchFIQnqOrajvugOpPRFVMWMN6DUxwjBYdAX88WF24746Sg5WgEbdyNQYnw3ru2V1fkAC1rLzUveLwftI36i5b085gGOW21HKzV+eu5YEQnzRzwla07trrbBmLA0zCZARefmetXnaYRxCd7Hvs6jVv3jChRt01d7HAu0QWkAf99mHhSRu6JJkmYXlhYE4+MkgBRlFx0fpOZVI8LT5LqtMmkU3/W6cO2XWlZigbOrMATGOPsT1S8w49hEirX6oNanC2SBEZEPy7K5R2+yGZkLL2RFnC4sRsf0zoLFvBFBa5ijaxUjhVeYAzvajjYiHFNSDu69lBNZ0MdJkyywcrpGWN2HpThfmlQFduNOG1Hnxa7YjVdi3B2pSFzmnXuW8WFvbXtSaCWXrOp6IfL3edDY39Ps8iKw5wIGZgUMNOAPHcZJD3SVGx17VGAGNwkUXwz7V51a7JKCTgbJe5d8VcyRnj5K5wp7RHjbOK3TcVewQE0roOL70or9pPYbXy6PB7annPbU8Q3yQIX6rYz3Pw/Lu0Qtu8Ffb8b3TLuxn2mbBu4WR/CbRyfvGzUqrNs/uXOX1Hwzl1fdTaDT/gqnHyf5Ocm2hFrCxWTan01As95bMA9j53dluXdFNfL1pH9ofXUvjMxlqkLxTWcnN9WGQVBoMLciIZnfZgKhJE1W9RCI86+ixh5IA/X23xGlHo14h1LE4VYfbL2Hj3TqaUXWZT0xfTWe4Y3cfXWG9XwVIVNNgPLEkpIdS3mgT0e
 zmz8hHEt
 LihRI0ExKKUdEVG6SloC0kwgYGDurIXwQCYop4LyFrmeC623nr0OkqZp2UP1JSY1U6TxPgKQxuHFDdPIKareVhkob8R6fLRSeNMt2GtIEXLFxfEs2yacf8zpLW/WdvTISTeVLdQ0DDGxkQevSIjDzsb5n0djlTN/HYIJZR8m7H1gvjlMaxKeXc1O9ooK3cLNRuvTBISdpq+ilM2UYqmuJAw4Fy1DwOkshw36Dr/bwsHSrbgP4mQAc22+RIqJHFDsVoLMJiluEAkydX8oSD2ppOiK/fW1TMswj4YTNt1qXtfsd8BaYVYLebTnk5A==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 27 Aug 2025 10:33:38 -0700 Chris Li <chrisl@kernel.org> wrote:

> On Wed, Aug 27, 2025 at 9:18 AM SeongJae Park <sj@kernel.org> wrote:
> >
> > On Tue, 26 Aug 2025 08:52:35 -0700 Chris Li <chrisl@kernel.org> wrote:
> >
> > > Hi SeongJae,
> > >
> > > I did another pass review on it. This time with the editor so I saw
> > > more source code context and had more feedback.
> > > Mostly just nitpicks. See the detailed comments below.
> >
> > Thank you for your review!
> 
> Thank you for the good work.
> 
> >
> > >
> > > On Fri, Aug 22, 2025 at 12:08 PM SeongJae Park <sj@kernel.org> wrote:
[...]
> > """
> > --- a/mm/zswap.c
> > +++ b/mm/zswap.c
> > @@ -952,6 +952,7 @@ static bool zswap_compress(struct page *page, struct zswap_entry *entry,
> >         struct zpool *zpool;
> >         gfp_t gfp;
> >         u8 *dst;
> > +       bool dst_need_unmap = false;
> 
> A bit nitpicky. That variable name is too long as a C local variable.
> We want local auto variables to be short and sweet. That is why you
> have "dst" rather than  "u8 *destination_compressed_buffer;"
> The local variable name is too long and it can hurt the reading as well.
> Can we have something shorter? e.g. "mapped" or "has_map"

I agree your points, and thank you for suggestions.  I will take "mapped".

[...]
> > > > @@ -1007,6 +1031,14 @@ static bool zswap_decompress(struct zswap_entry *entry, struct folio *folio)
> > > >         acomp_ctx = acomp_ctx_get_cpu_lock(entry->pool);
> > > >         obj = zpool_obj_read_begin(zpool, entry->handle, acomp_ctx->buffer);
> > > >
> > > > +       /* zswap entries of length PAGE_SIZE are not compressed. */
> > > > +       if (entry->length = PAGE_SIZE) {
> > > > +               memcpy_to_folio(folio, 0, obj, entry->length);
> > >
> > > The following read_end() followed by acomp unlock() duplicates the
> > > normal decompress ending sequence. It will create complications when
> > > we modify the normal ending sequence in the future, we need to match
> > > it here.How about just goto the ending sequence and share the same
> > > return path as normal:
> > >
> > >  +                  goto read_done;
> > >
> > > Then insert the read_done label at ending sequence:
> > >
> > >         dlen = acomp_ctx->req->dlen;
> > >
> > > + read_done:
> > >         zpool_obj_read_end(zpool, entry->handle, obj);
> > >         acomp_ctx_put_unlock(acomp_ctx);
> >
> > I agree your concern and this looks good to me :)
> >
> > >
> > > If you adopt that, you also will need to init the comp_ret to "0"
> > > instead of no init value in the beginning of the function:
> > >
> > >         struct crypto_acomp_ctx *acomp_ctx;
> > > -        int decomp_ret, dlen;
> > > +       int decomp_ret = 0, dlen;
> > >         u8 *src, *obj;
> >
> > We may also need to initialize 'dlen' as PAGE_SIZE ?
> 
> If there is a code path can lead to dlen use not initialized value? If
> not then we don't have to assign it.

The success return path of zswap_decompress() checks dlen together with
decomp_ret as below.  So I think we need to initialize dlen, too.  Please let
me know if I'm missing something.

    if (!decomp_ret && dlen == PAGE_SIZE)
            return true;

[...]
> > Thank you for your kind review and nice suggestions!  Since the change is
> > simple, I will post a fixup patch as reply to this, for adopting your
> > suggestions with my additional changes (adding dst_need_unmap bool variable on
> > zswap_compress(), and initializing dlen on zswap_decompress()) if you have no
> > objection or different suggestions for the my addition of the changes.  Please
> > let me know if you have any concern or other suggestions for my suggested
> > additional changes.
> 
> I am fine with a fix up patch or a new version. Does not matter to me
> in the slightest. I care more about the final landing code itself more
> than which vehicle to carry the code.  Assume you do all those fix up
> you mention above, you can have my Ack in your fix up:
> 
> Acked-by: Chris Li <chrisl@kernel.org>

Thank you, Chris!

I will post the fixup by tomorrow morning (Pacific time) unless I
hear other opinions or find my mistakes on the above plan by tonight.


Thanks,
SJ

[...]


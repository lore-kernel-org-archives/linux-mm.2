Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BDDBFC56208
	for <linux-mm@archiver.kernel.org>; Thu,  6 Aug 2026 15:40:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8B6806B007B; Thu,  6 Aug 2026 11:40:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 88DB66B0088; Thu,  6 Aug 2026 11:40:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7A3E56B008A; Thu,  6 Aug 2026 11:40:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 586D46B007B
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 11:40:30 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 59F1780119
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 15:40:28 +0000 (UTC)
X-FDA: 85071256536.25.506DB2A
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf02.hostedemail.com (Postfix) with ESMTP id BA49C8000C
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 15:40:26 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=QDQG44jv;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf02.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786030826;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=X4y0kRDos7SUupJbhbbGh+ICURL3cdgyP3aRACH2kFE=;
	b=8mBxmHzH8ZkAfd5hJYPXRmd2IKTeBUa0I29jEK9KM3Py+C0Sr9Zpw8CJl2vQYEMYvIGZTd
	b0X8YLH0EQCr+gGpgndMjTDZFA0UXbiepn9zu/GtFCODG3wkNURVNwre+0qzAO4Tp8OlIq
	FEKBjUSCNu9yM7VRFrjz1rsy7yr+pv8=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=QDQG44jv;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf02.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786030826;
	b=ai7RC8J3i/s+wKwMXiPN9TsBwWy9UlIh3F2Kr/YOdvxQjYLxqAPrBuQ7MFAaik7ahfKTG5
	ToAyiVsprgbJLMV8XZczvSkM59s8+fre6Tzd3vsNvDbJ2ccr8u7PUM2FcTLe1dXH7120fi
	De2Hu/V2UkXTfKwYa+FJQQ6lxu2fbLQ=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 347D360AB0;
	Thu,  6 Aug 2026 15:40:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B5641F000E9;
	Thu,  6 Aug 2026 15:40:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786030825;
	bh=X4y0kRDos7SUupJbhbbGh+ICURL3cdgyP3aRACH2kFE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=QDQG44jv+J00sxZv6RdnsCugx8JDFPTDhXTeuI64TQoF/ZieSGG4mUm3vzsSHRYh7
	 VDF4qitSAmwAmXy1nMqSXjy64PTc3iipClx03crZnHSHDEioRY7XZkaaMeM4P+Kdsh
	 E9J5l7BqgspPvIpcsEH25RYx0dEx3cZ22+/uAPT1qZBiHcO4fql5Rtyha2uEj+EdJ1
	 5JyNvEL/Fwfp4QRa3bwQEyivfGE8nyz+ScWIikKRjpY92ZFw7mIn/ZWtCMq6n39UI9
	 aztkkLopa+X3dqoQ0V8hXqy5RtpDMtxtiiCYk6H+naUlMyQjG7IsaIOLpwDSGhv6nH
	 zz8c6oqqzk4WQ==
Date: Thu, 6 Aug 2026 16:40:08 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Yunhui Cui <cuiyunhui@bytedance.com>, akpm@linux-foundation.org, 
	liam@infradead.org, vbabka@kernel.org, jannh@google.com, 
	00moses.alexander00@gmail.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	stable@vger.kernel.org
Subject: Re: [PATCH v2] mm/madvise: avoid skipping pages after splitting
 large folios
Message-ID: <anSqbW1w2bDDHpAx@lucifer>
References: <20260806055501.56761-1-cuiyunhui@bytedance.com>
 <anQyoZgi5Urnvvjw@lucifer>
 <919b804b-6f1d-417e-9c0c-d06f50d765d8@kernel.org>
 <anSar_i8UjniSbML@lucifer>
 <a6a9e0cc-e6cf-4f83-b6be-7d64058b8fa6@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a6a9e0cc-e6cf-4f83-b6be-7d64058b8fa6@kernel.org>
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: BA49C8000C
X-Stat-Signature: uw97piu1fxqyybq4adxuax48eogskic4
X-Rspam-User: 
X-HE-Tag: 1786030826-520568
X-HE-Meta: U2FsdGVkX1/ZKv4RteqfUwygd8Qf13BUq5CHckd2JZCWk6KIfUmF2R/sdG6JxLdo4EJrPV3MtWNO4l//C5KRGi/9wAKx5cgl9CQ5IK4y6p4XEbBmU+8vlYKG6gfW6hSNygpNDR6O2RZ4uYs1PE4qv/k+t/S2yRBI1sKzwYWYQYdDVEXsKnwzy38ALBCH0N4Y9atgwVNtVXTG20wPVx7AwtVqBeQ9J+vn3WUvBQcv0NxrbDESTdy2w815ok6NKI9izuPsYmX0xqBGtGFVdCGDwLlVTWo0MVu7aYpO5cjA8DgS15vcIw8CX6lmUsOhCZ7hrcO7jFOJeW/SbqI0GSFOboUCbsXORMwGUD/e4eGAhgQ6tnBC4pBVEyeb1JDq44pkIXsbK/xLSVDPO937U96zQFb76trcgBykB7mzVAy3CM4f3Mf0Dq4VZV6baBQg/9wcdpA6+elH7x4Nm9pcZ7+4kgZS4w7PlajQUq/4OLmUfFX+HFNrbo1D3JMV0J152DeoicEjaHT9I3qXm1O00BGdgRjGNYLovBg+E5+uy6d/vbcY/oEoY7NuKrXqSp1b5Xqf82VP3ABc9V61asrqTyzbqsKjc8hF/9g6LIddDE618/bcEMRoZdtjpeRiEfdgjNVTwznfOuIcTWOIIdJ3Pu6IrSe+GnhFEgzBw1oq+/m0sZTtXQ7hYHjF5TMjbeLDZmz/rHvuLimMso5IJYx74Ijfrtf18K/42XhoHafrNIevm2UEdVkfry8+SqETRF/8eEQNKEpzVER0baSNgMq45Ct/+zqmbCkNsdek+44yWCDoxu691w9HyLUcDfNQUOB0dXfVDHR1dHcxY1Leau0wlqF9ELQWaoM1wOCCRuT18ABBFozWdNXQ+zJo/VU11dpM9FWT1YRZ3el56lFru/bA/C0FJBT0+Y5DA2C9sFuz/5nmJKDeg60BH3Hn7bdkmKHzuO6IWfPD0E/3Qj3d1Z1jWPM
 X+7xzz5t
 svTgWXeucJIr/dOOglHMElcLUK8/NMUD+qcti5nq5MSWo0dRpdfOg6ufzdVM7MrPgdpkEOlJ741ZzZKWuHV/n3/zqEOlBwiQgBUwci+F0k3GiTtxK/hReSIl4fThFNq5+CcFB2cdaXS85dsldd1E/fErFuWBugqIiPbYj6pPvU9duGleE9Pf3/HjB1JUEB/oE8eqt37H9cANiek0+MZ1a1hLiEvMxi4gNAqCXK4kI1BI5hKKq0JYn4RAa0LWrDXm0MPe+yaYJ+D+jNU1rryxzNne8M/0w/cu8HnmYAHxmlKSwkxqIBr7rZ85i05slRQmfu0YhwNg1Pjvz4jk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 06, 2026 at 04:46:10PM +0200, David Hildenbrand (Arm) wrote:
> On 8/6/26 16:34, Lorenzo Stoakes (ARM) wrote:
> > On Thu, Aug 06, 2026 at 01:35:30PM +0200, David Hildenbrand (Arm) wrote:
> >>>
> >>> Let's at least split out the folio check into a helper to make things
> >>> clearer:
> >>>
> >>> static bool poison_splits_folio(const struct folio *folio)
> >>> {
> >>> 	/* Hugetlb is, as always, a world unto itself. */
> >>> 	if (folio_test_hugetlb(folio))
> >>> 		return false;
> >>> 	/* Soft-offline errors out, hwpoison traverse DAX intact. */
> >>> 	if (folio_is_zone_device(folio))
> >>> 		return false;
> >>> 	return true;
> >>> }
> >>>
> >>> Then for your patch:
> >>>
> >>> -		size = PAGE_SIZE;
> >>> -		if (folio_test_hugetlb(folio) || folio_is_zone_device(folio))
> >>> -			size = folio_size(folio);
> >>> +		size = poison_splits_folio(folio) ? PAGE_SIZE : folio_size(folio);
> >>>
> >>> I tried writing something that was neater and nicer but AI kept pointing
> >>> out how it was totally broken and I really really hate this code (not your
> >>> fault :).
> >>
> >> No, I don't think any such special casing on folios is the right way to handle it.
> >
> > I mean the issue here is the stride varies depending on whether the thing is
> > hugetlb or not (and some weird DAX thing), and the poisoning causes a split
> > otherwise so if you want to poison a range you have to account for that.
>
> We GUP'ed a single page and now try to be smart about which other pages we'd GUP
> next.
>
> That's just wrong, and hugetlb special-casing is just ugly.
>
> The problem here is that, if we GUP'ed a page and poisoned it, the GUP'ing the
> next page might fail and we'd return an error.
>
> But maybe that error can simply be handled? We have FOLL_HWPOISON.
>
> So maybe we can just use FOLL_HWPOISON and skip over the entries that already
> return -EHWPOISON?

Yup this is ugly debug code so that works for me.

>
> --
> Cheers,
>
> David

--
Cheers, Lorenzo


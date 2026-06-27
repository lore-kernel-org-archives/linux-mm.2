Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 32C36C43458
	for <linux-mm@archiver.kernel.org>; Sat, 27 Jun 2026 07:10:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0BD176B00A2; Sat, 27 Jun 2026 03:10:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 06EFD6B00A3; Sat, 27 Jun 2026 03:10:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EED986B00A4; Sat, 27 Jun 2026 03:10:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id C7BD16B00A2
	for <linux-mm@kvack.org>; Sat, 27 Jun 2026 03:10:01 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 5379BC3269
	for <linux-mm@kvack.org>; Sat, 27 Jun 2026 07:10:01 +0000 (UTC)
X-FDA: 84924818202.30.F937FCD
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf27.hostedemail.com (Postfix) with ESMTP id 8EC7D40002
	for <linux-mm@kvack.org>; Sat, 27 Jun 2026 07:09:59 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=YE6DRHg5;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782544199;
	b=GpmvgTBbLLEXsvO+kcQdcR2KP9FjHXm+18fAHNFVWGkZQoYO1SxkFxQAb7cY2boeAIgzPx
	+hdKFQSwe0wOhBK682++l0sX2ycEvcxmu1IgZKQ/uiwRudmPRlpQc446Q/OuVk+G5QvFNX
	NJXpYtebntJtnhGn/2Yk1gfpJp77XjQ=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782544199;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RkxCaTnd2sK6v+xwHOrVxAKuz/x2rIMMejz3GlbAyxg=;
	b=GvHHmR0hzpMskxQ7oXXwjOLGuhl7XuElgp8qXY4pbKIgS5yHeigr4T1OwScwI+oKAL1Mxd
	rGXOEMBO5hOE+0fFiouVr+058X/OCVgPAeMjd0vjP7ZgtEv6GyWFJyo28SJg+YWES9bBER
	09+bhXsUvtFbWdwTNU7tJlcS2o1Ai8A=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=YE6DRHg5;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 84C9440BB6;
	Sat, 27 Jun 2026 07:09:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 105151F000E9;
	Sat, 27 Jun 2026 07:09:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782544198;
	bh=RkxCaTnd2sK6v+xwHOrVxAKuz/x2rIMMejz3GlbAyxg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=YE6DRHg5OAhXnrP0hTb+xq+Whe2prBNQhdRLfDxxJ2J1fSZytUVPVcXuRF7M4tJtY
	 XS+186l1rJLTgMeXj/beo9QvAN3sE8qL7CcMPa9//9UOcIxE+ZygiEiNKBcftRC9vZ
	 ZBGJ+wU828QTSAasKojAWXa1kzAtfv0QYFv3sK/g1F3HV5k3cxflqKZwV8BDzAbJba
	 gXQHaJ7KAJzC+IR/O/nSNrsopGWK38NjQl1hj+hpvZQ2Nlw4VaLuRJZ07lr/2Ick8N
	 U8FtTKtMlMX7vhlObYZzhD+JC1mLSPQe1dcRfZDFBG0qR4Mm9gYx9snfYbnSyKQF/w
	 DvQG9FTNnPgyg==
Date: Sat, 27 Jun 2026 08:09:45 +0100
From: Lorenzo Stoakes <ljs@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Rik van Riel <riel@surriel.com>, linux-kernel@vger.kernel.org, 
	x86@kernel.org, linux-mm@kvack.org, Thomas Gleixner <tglx@kernel.org>, 
	Ingo Molnar <mingo@redhat.com>, Dmitry Ilvokhin <d@ilvokhin.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, Andrew Morton <akpm@linux-foundation.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, kernel-team@meta.com
Subject: Re: [PATCH v2 0/3] mm: __access_remote_vm with per-VMA lock
Message-ID: <aj92U3McDAoKNeMB@lucifer>
References: <20260625015053.2445008-1-riel@surriel.com>
 <b0d9ce70-ebb7-4b79-9a35-257b69daff7a@kernel.org>
 <5a4ff628c1b947f9cd4da53e1e64b3934a1f2d9a.camel@surriel.com>
 <05538f68-c3ec-422d-babb-7427068f79f4@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <05538f68-c3ec-422d-babb-7427068f79f4@kernel.org>
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 8EC7D40002
X-Stat-Signature: xpuegmih1zhc7zspyuthtp3oi46jyteq
X-HE-Tag: 1782544199-809053
X-HE-Meta: U2FsdGVkX197qmsKNpTk8Wke4XacAEpp8Z5TvBPqs1eqZzgqatzuX1PwBp1B88zfFeFeYJVLxnLv0aRU41A6Oht+2UqXeMHuup7DtOqnoiLMKU0i/JHNYA8t8j/wraBEQHJ5CvL6wxTJ2aLk1A3zJjdUEyOE9/gdyR7kNlzHK1iBkcA0kUADx0ukzXiSYQx90tR4+x5AFRyooKnLpD/vbAUd6o++1hIaKhGE1Wez0wJ54h6QKfNtirHtwUtlDrjBhy2EcE+Hy1Gy3a200osm5FFAQAhggBWcRUVZJxhRuKtVe3OK9AcRQI4JELYXfsYnOfRkvpt45Y+uDGrI/q0SPvY1E8VoSlhyreW+5Cl9vham2O1/lYtUFHUJo3wdQABlwUSIONB6ZotFU06K3xHKI3EcSzrC/B3fGXhEyKnxB4mO+aApDe0rjYN57C2AdP2UX5BY8Y9nDNAJwPR2c78ELqx7ywAXHKAHT79wJ0lhkY634hdm9iF+4Y3EFCywq9VknM1uBL3UnbyOzHoRbJi9ZPVCfK7PIz2mn0GTbYFp3mx9GIW88CpaqQR66R4HqseyNrvrvrO08VjD7VnCmAmXL6gsEbstRau74mP66El2SyZAUYhjAeG7bomS9a6eMqULHNMFaIcpHQG+Ult9fZXhnstOUSGrKQefL9odY/ImW8dRclDRGfMycKhM0hTOmtKlTCTosmrVWdIfDaRSvNGl332GEYvoWbHRZhPQ3xznfWdfvWbz2Rai2Tsg/z4opZFGS0EYIE6LCqVI+LwAn2885bA0/t0uvaar0eorYUt0Ao5eUxSlg5Cpx5ZNaQiR6Xk7dByQSV9sRFoGoLvV/E4616WBTjA7d6eXzbOc2SPpmCMOJsF2axge74I1EaEbAaGLrAV4nDJQc8YKECw+3Tr/kzoTmqwcN9xF3+YLrqW9yggnibriKgS53Ii5muOqN0K8hFcNJhIw9vpYPrBK12g
 0QM1/5TR
 oKp4DoNgVWp1EMeaejrJPikY9b9zUS5F2f+QYZom3PtHJcbcf0XJKhxWB7TwYniZ+AGLQXN5cnEl0XOAFYc9v60Lk47n/ezagxIc/Vb5Dy9pkA++ejHmr41fIwXpnXnDVr9PtfZ408QMgI7xMysPIpHBmFtX5/8ZB96+krjsElTLaMLnYasg6bW7bj9PXKspof5Fz9ePMOXvyGEG7X/0FSEmixlTM9Ve0NT9ZeYs6gZGO73+asTg+0E5FZZrdPuUMjQ+4p3JZc0cjhh3yRtquAi0pEk9ZO8CA6J2BaogfaaShQjjodfHaJf3+zNPFuCjtsSa2yrertxd8cfk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jun 26, 2026 at 10:33:19PM +0200, David Hildenbrand (Arm) wrote:
> On 6/25/26 13:22, Rik van Riel wrote:
> > On Thu, 2026-06-25 at 08:32 +0200, David Hildenbrand (Arm) wrote:
> >> On 6/25/26 03:50, Rik van Riel wrote:
> >>>
> >>> v2:
> >>>  - simplify the code, which should be ok because these copies are <
> >>> PAGE_SIZE
> >>>  - clean up the code
> >>>  - fix locking wrt tlb_remove_table_sync_one()
> >>>  - hopefully address all the other comments
> >>
> >> You mean, ignoring my comments about not reiplementing GUP entirely?
> >>
> >> NAK
> >
> > Do we actually have a path to doing that?
>
> Well, I know what we do not want to reimplement GUP in some GUP users unless
> really unavoidable. And I want that explored first before moving further into
> this growing complexity in a GUP users.
>
> >
> > I misread that as more of a wish list thing, not
> > as something we could realistically do today.
>
> I really don't know how you concluded that.
>
> I mean, I know, my English is bad, but it's hard for me to get how
>
> 	"Yeah, we're not doing that unless inevitable."
>
> is a wish list.
>
> Yeah, well, ok, my kids treat also a "no" as a wish list ;)
>
> >
> > How would I go about making that mmap_lock-less
> > GUP a reality?
> >
> > What are the prerequisites?
>
> Did you actually read at least some of the stuff I wrote in my mails? You know,
> the ones where you didn't reply to? :)
>
> Seeing a v2 with some weird gup-fast-like looking reimplementatiom (eww) is not
> something I enjoyed at this point. We don't need another set of special page
> table walkers.
>
> We really need someone to look into this with some GUP experience or the
> willingness to properly think the GUP lookup+fault path through, instead of
> adding some creative workarounds to selective GUP user.
>
> I will try to find some time to think it through, but my time would be better
> spent guiding someone (and definitely not someones LLM) to understand
>
> (1) which interface we could start with (as I said, a GUP interface where we
> pass a VMA-lcoked / mm-read-lcoked VMA instead of the MM)
>
> (2) which faults we could automatically resolve under VMA lock (I mentioned
> userfaultfd is tricky but the existing GUP call already doesn't trigger uffd)
>
> (3) whether gup-fast could be reused to some degree, or what it would take in
> order to do that.
>
> --
> Cheers,
>
> David

I agree with everything David said here.

In general Rik do make sure to engage with reviewers during the review and reply
to points raised so we can have a healthy discussion (I see you replied to me
thanks for that! So hopefully this is now resolved).

It'll save you going off and doing X, Y + Z in contradiction of comments you
perhaps missed or felt were nice-to-haves, only to find that they
were in fact critical blockers that prevent your series from being merged.

With review workload as it is this not only saves you time, stress + energy, but
saves your reviewers from the same :)

Generally if there's feedback, response to all of it is expected and really
required, albeit obviously for reasons of economy an aggregrate response or
implied acks on nits are fine.

Thanks, Lorenzo


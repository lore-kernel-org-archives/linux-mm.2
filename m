Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EA767C61DD3
	for <linux-mm@archiver.kernel.org>; Thu,  3 Sep 2026 08:04:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C71026B00CF; Thu,  3 Sep 2026 04:04:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C48006B00D1; Thu,  3 Sep 2026 04:04:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B87866B00D2; Thu,  3 Sep 2026 04:04:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 932596B00CF
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 04:04:55 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 2188A80458
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 08:04:55 +0000 (UTC)
X-FDA: 85171714950.03.F1A9BE3
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf17.hostedemail.com (Postfix) with ESMTP id 717E240003
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 08:04:53 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jUyyKAvQ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788422693;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nik0wTm+JAvs8cZN7JlAAdq521Lm/c+88mnUUFC//R4=;
	b=NnciBNHtQScmiyZd+1nGta0hED1/j4QptWDjtohHIijYojw9GxFlA8CvgBkymUyWH2Hi0B
	CyCtyeYfFAnETKlfwLpaEE7B1N9q3AZV42+w4wpt2wBTQuY+hcJrJX8jSG3/jMiz/2WS9y
	+EETMHnVnziOVHehvZdv8Aq1WCcYFPo=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788422693;
	b=ZcX971bkNu68cSqd85zbDiLkp68GG7Hp6+gzTHUz8EVykhGHw4us5o3gv3UiPjUoTCWj0d
	ZbOuxlVDV6W41tPHBJbqEf08HoGIA+nmtIWH3Ry3kJw7vqracUxOCEz0BY1inS0yTwLd7C
	MnoX8C3q+KKLEGNQzEvxRyDzKj+fQl0=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jUyyKAvQ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 87C7743356;
	Thu,  3 Sep 2026 08:04:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F9A31F000E9;
	Thu,  3 Sep 2026 08:04:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788422692;
	bh=nik0wTm+JAvs8cZN7JlAAdq521Lm/c+88mnUUFC//R4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=jUyyKAvQFpKXEHo2Atpade5J0wfy1AFB0fqkGgJOa8yKzmq5BJ9QpKhNF73PxQp6q
	 djMgOWi1bpqw+KDh5J11hhTA1ywSgPUl/klMK/hMnhJKQNbOgO8+Y2TWMMc4qXYrFx
	 GYMNaw8ICT6/wJnZmkQaAEmo9gO7++djTtBirdbCBsHLCbC2PgW7ao+0dwlxT5TmBT
	 +1TweJIMqStnfbfGl3utjj+BdNFOjYp9SPYZ0rKvy6rTppWVygt9zzStrbH4DPOelP
	 0NQRh3ijzu+TmVTyb2wxZauSsE1G1FEOl29Qs+TSy4pz645AEK5a2hXQrJ+v6wDUV4
	 bTLfVY7bV3ugQ==
Date: Thu, 3 Sep 2026 11:04:44 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc: Christian Borntraeger <borntraeger@linux.ibm.com>,
	Janosch Frank <frankja@linux.ibm.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	David Hildenbrand <david@kernel.org>,
	Heiko Carstens <hca@linux.ibm.com>,
	Sven Schnelle <svens@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Vlastimil Babka <vbabka@kernel.org>, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	linux-s390@vger.kernel.org
Subject: Re: [PATCH 0/4] KVM: s390: replace page allocator calls with
 kzalloc()
Message-ID: <apkqHLgg7nqBiYW7@kernel.org>
References: <20260902-s390-kvm-v1-0-3bc0986550b1@kernel.org>
 <20260902130612.41500808@p-imbrenda>
 <apghz4XAgv0ro15t@kernel.org>
 <20260902165315.06996af6@p-imbrenda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260902165315.06996af6@p-imbrenda>
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 717E240003
X-Stat-Signature: ixz5hnd8gnjarhodcq9r48axof6dm7ae
X-Rspam-User: 
X-HE-Tag: 1788422693-184451
X-HE-Meta: U2FsdGVkX1+JpbQG0KsVqy4cqRbgEKJCmNEVYcWXH5BbspP90sr704xys8pPUVNtgMQEwlkK0BwT0oJljXskiysUOEfgFUMYzHdOodyk7LSKia6dulzTzROmA8BZtHku2siYHFFTssXwxHcrV3jyy/eLqmK2dUc/dI9AQ/3tQNdGLlljVF+lYFIhrGBxbLx9PY6033D5T4ts+zIT72jZqUiNmSwZXJhxPdOoiihMZ77ITXUijsCnNEuD2Q/csvtmw8mGZUzBuQl0f/VNC77wRiRzl9DqfwkrpapO6qSH1KmnEsSV1TbyNFC/gsKPjxEXUVPAyRcZncLSi0NN5mECEVdjs+8yaZu88l5HinuhSLurkzH5Djo7RYlxdNUdZZeziUyvDNbaeevRS5J0RR0TbDt8QRNqIeyfTbV0mrQ0p2jr2Fppl+UhFus4D3xNrlC6WhhpwmQMxLV1L/lcS7zS/JVYDnfSaKK8U3ohTCRt3d2Ag6tOXfa6YSWlyaRHQ2KWbFDlMiKdsUyOqWS4+RLH1EuGKxbOcWPYFAEKyMQg4Tlors16Ozf4eDPu0LuN5McozNLqD0Y+Gx9vOdVAUtJaaNaNg0p+C2Uk2zC1zMPRwnCe5RN0ivtPQj82HdxyjQNXjKhpOJkz+dZ3uF87f+KZKuZs4+IsTneJw9XmIpytoPLPZRW1nLA0LKXVhkZeaFSE/x0gAyvCTczkYs4lNxZk9/SPgkc/Q6tM4+1He1TJI0taQxfz6eWVFuu3UmR1FWEksMKg6U0WMEeCqitcvVDKF6tsSeMkfICY5NjRVgS7ZLWiaEKDbUSgUlq3Bt7ZmY4kmYjNJJQXhAfGTACRwRQjwnWcCfhA2XkXzU8gbfey1Sz3rkAtNVTeb9uDy9/T58s3gF6snaZcYVEv+/chbHtMKUN+x1lk4hYS7zTf9M7LbO+OuptAapIfBbx9HVdi661undD6KUBLaeS+vuInOpV
 tuqEWiOO
 1AdtxOyhXCoZf66bRbKtsIpoRu0jayCcKIQpvO6fBa2H09Ke5jY92Y+wjCnrysTSevznnpLdxsZxw3Ab2FQyl1fZJZQ7zGRBIlu9U4DXw2FnJr3TtIj5IqtVG1ndXrOEPlgj3I5RiVP0LqpV0fMT3BilBgAWO3qS/ySSTEXWO44a2gAMDL9KuVJF8FmC7LlhCuyV1oSr/PTyzS0cNUYj8OyxxnB2S2IO4Cysgt2m4GJaYodNc8Tbciq4Jc7EyUm9yFGO6FDzPsiYg1x7Lrq/7lYCrw/XBieU73pKCs8wSOhUQyms=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Claudio,

On Wed, Sep 02, 2026 at 04:53:15PM +0200, Claudio Imbrenda wrote:
> On Wed, 2 Sep 2026 16:17:03 +0300
> Mike Rapoport <rppt@kernel.org> wrote:
> 
> > On Wed, Sep 02, 2026 at 01:06:12PM +0200, Claudio Imbrenda wrote:
> > > On Wed, 02 Sep 2026 09:15:12 +0300
> > > "Mike Rapoport (Microsoft)" <rppt@kernel.org> wrote:
> > >   
> > > > This is a (small) part of larger work of replacing page allocator calls
> > > > with kmalloc.
> > > 
> > > I have some objections to this series, but not because of what you are
> > > trying to do (which is actually nice).
> > > 
> > > I understand that you probably wanted to touch as little code as
> > > possible,  
> > 
> > Yep :)
> > 
> > > but now since you're rewriting the allocations to use
> > > kmalloc.... I'd like them to be converted to use the __free(kvmalloc)  
> > 
> > You mean __free(kfree)? Sure, I can look into it.
> 
> yep :)

Well, I looked :) 

The only place where __free(kfree) is completely safe is handle_sthyi().

In all the other functions using __free(kfree) creates a mix of of goto
and cleanup helpers and cleanup docs advise against mixing them:

https://docs.kernel.org/core-api/cleanup.html

The cleanup paths are quite involved in these functions so using
__free(kfree) there is really not trivial.

-- 
Sincerely yours,
Mike.


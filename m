Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9B50AC61DD3
	for <linux-mm@archiver.kernel.org>; Tue,  1 Sep 2026 16:10:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B06D96B029D; Tue,  1 Sep 2026 12:10:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AB7686B02A2; Tue,  1 Sep 2026 12:10:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9A55B6B02A3; Tue,  1 Sep 2026 12:10:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 778586B029D
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 12:10:32 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id E77A5C0469
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 16:10:31 +0000 (UTC)
X-FDA: 85165681062.15.7F29993
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf28.hostedemail.com (Postfix) with ESMTP id 3E008C0014
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 16:10:30 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=OC+M8gjg;
	spf=pass (imf28.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788279030;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nU8qGw7zBAB9FyzOBq4+DQ5jWvbJw+bt1tKhVtpbGP0=;
	b=4K2cVdFvUjzf99SiDrrXqSWJZRZ7AH+kgAM9UTC3LaAHCT5EgyT6HAI4Lwk1Xms9IZ7EdO
	5Khupj+mMozkD0flN5qKOR+1Pn/ZDa9K47fj5z1cE1blYzYd8KxdGMixtkoeZrvHOlcgQj
	2Yq4ws2rbh6/u7wPQYaPqdT5de/WwLM=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788279030;
	b=eLoLhxTz/vr8qcikmuQumVee3ESWrdyO5ntvepj0UgX2pakuny0drgD8P/sB3fhg6fLyXz
	HlrvgWYZ3WEHY4QKaIWNn6XvRakJ7yOm8iHVklgKdSdTr0C31yVvU2I25BS43RlMoHs3Vc
	hH6jFuDsVO4SLYgRbcCQQsI+s/N3LXk=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=OC+M8gjg;
	spf=pass (imf28.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id AFF4A6025B;
	Tue,  1 Sep 2026 16:10:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B05851F000E9;
	Tue,  1 Sep 2026 16:10:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788279029;
	bh=nU8qGw7zBAB9FyzOBq4+DQ5jWvbJw+bt1tKhVtpbGP0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=OC+M8gjghk29AmKMTgxa73kHrqTtwQ+sADXbLP4qeJ0bRA4W89p+gz0AH0NEWeqzF
	 c/OsxPewPaN/MTnMv4PdIOEWWT2QtAsiFnmCb9tbONv5xBnfgq4M/3OU+QlzHEIpFB
	 ofgA9PiOgqKv7/aoadrfbnUutyJM/wlWU15Pmg1DoilbqyODrPE//w3eMsGQddefh4
	 Mqp6rBrRST9l9qf+idOM77HA/ROpVNXvAiCR9CtiZftMcbOqQ7hXDbj3uzD72KYvQR
	 bgu03LPdcs2Fw9nf/AuKTqw/+xV/eVWWQQ/vHjFZVYGplm4SAc0cWc7Id9Zj2UPfku
	 3mc+D8yXT7cPA==
Date: Tue, 1 Sep 2026 19:10:21 +0300
From: Mike Rapoport <rppt@kernel.org>
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Lorenzo Stoakes <ljs@kernel.org>, Michal Hocko <mhocko@suse.com>,
	Randy Dunlap <rdunlap@infradead.org>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Suren Baghdasaryan <surenb@google.com>, linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 1/2] docs/core-api: memory-allocation: add
 k[mz]alloc_obj() and clarify kmalloc
Message-ID: <apb47Rsnz1H36SOy@kernel.org>
References: <20260831-docs-memalloc-guide-v1-0-547718c274c1@kernel.org>
 <20260831-docs-memalloc-guide-v1-1-547718c274c1@kernel.org>
 <23db34a1-ba1b-495d-91ea-18419e0dc8df@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <23db34a1-ba1b-495d-91ea-18419e0dc8df@kernel.org>
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 3E008C0014
X-Stat-Signature: 5o4okjhs8656ds41eya1d5qy3f95da6o
X-HE-Tag: 1788279030-774953
X-HE-Meta: U2FsdGVkX19YtjVNfCzxrp+9WXyvYqSraoWg0L/5UfRSX98+T9lw/6ebbqvg+WjkliU032aTXL7E2ilPCHC3SLFB508m/dNa9jdm6uqSD2r2WSa4oukGhtGI3oiFVH4FT9YG8LLSOCgb/2OGHyxK6F9Iv8+uXaAkLEmRE/XIH+/OLWXtTyKkE7on4ZvKDqAscIA3upBCxPTWF3iYMsuiGMODTMS2hu98mZ9Mrd8G0rKxgIwS8ToxXpgEShWFppf9GbnAodzPundAuQxU532MvIiys35mY+ANyPQ/mS3OY5ZOuA/6cMvPIrMuHK23FLuPS/sS5qHet+Wdy3pBzxt0MT/6mcNOvACHuQaLScd6EozpNJuL0eBoLmo2EaBJpYGTDfWcm9T2icxRDkrcPOazXPO5KVt2d6sInCRcwrXt3gJvrzlk5Qlw2rDKHZ0Ia1xO01Sf7YlGX9apMCds2KePKnf2mKW3AV9bF20g31eMtjyGckahHBTZ/uakkNl3dwzjeboHLwcws1XCdlKWTnc2AhHB1DkbQZdZNkXsAfsaH//lrWoaEdhchOJMrek+SW6qAfvbTge/IsNIsyK4MQqHVLjR7ZtGBkhvQ4DLEInIt2yroQt0dZSAPXbRoV3DLV3Mrlm6KJcnJKGn4ULmWHG8TUjFAAfZK/uCf2hUKhX8SWQ+K1SpOOEE9EvqeJsdzclE0X0T7xIhj3jmXHS8IiYB/CmEAJm8sbySYPnrFYuenzJjCEA21ZHjuChsFneTaqfX53fwfQSE270fwhVskTyWBl17oqgXl53cdr0zOUtPTC0OkV2tyz2vIMizZ0FUzJD5X0v2xJ0pjdE2+E25/wJcHdcU2fvhDeo9aqVRrPrM9GZOik7IFn8UQNn3d0S36k2b4/kkENlT2wTDflcBnSAg8rdpdiA+C5M2s1HWwDfe+mF8Zt94AsWEXmCY9vI8I1XbWIituro/pXYGm/j3SyK
 fjQkZXLM
 jSOqowZMferkJQFUZ7CKL+VY5EjO/5oBfEW9zufNDAwQeHy7HsO2SMql/qbi0JooOobZmE11YRjI3wnTGkBEw8IECt0H2Fj/5/GjTbcpfNKQZY2ImzRffsFlTOzObwgGCu2GpRONmppXhH6EFU2uH8hdXheyK82xXQ8/pkeVQIl9E7MvYWcTP1qt9j2FhJ0SPUfyPIZ1XlCD4tfTim/0fj6RUgI1/f+yqDVNUF3Z8By8n+7hcD0As7zF8AdgI0u64xAqFn11lCbHQYWBSqA5mp+xLDs0iVSUEzCZK4WIjh2ygl4iJCObvwEA3Rw02aKxffT4dtrzvZD0cZ0c=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 01, 2026 at 12:17:02PM +0200, Vlastimil Babka (SUSE) wrote:
> On 8/31/26 17:13, Mike Rapoport (Microsoft) wrote:
> > Since v7.0 the most used memory allocation function is kzalloc_obj().
> > 
> > Update hte memory-allocation guide to describe k[mz]alloc_obj() family
> > and make kzalloc_obj() the first answer to "How should I allocate
> > memory?" question.
> > 
> > While on it, clarify description of kmalloc() size limitations.
> > 
> > Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> 
> Acked-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>

Thanks!
 
> Suggestion below:
> 
> > ---
> >  Documentation/core-api/memory-allocation.rst | 30 +++++++++++++++++++++-------
> >  1 file changed, 23 insertions(+), 7 deletions(-)
> > 
> > -For large allocations you can use vmalloc() and vzalloc(), or directly
> > -request pages from the page allocator. The memory allocated by `vmalloc`
> > -and related functions is not physically contiguous.
> > +`kmalloc` always allocates physically contiguous memory and the maximal size of
> > +a chunk that can be allocated with `kmalloc` is limited by `MAX_ORDER`, the
> > +same limit also applies to the page allocator.
> 
> Would it be better to say the maximal size is KMALLOC_MAX_SIZE which is
> derived from page allocator's MAX_PAGE_ORDER? 

My point was that whenever you allocate with kmalloc() the limit is
MAX_PAGE_ORDER, not necessarily for actual slab allocations.

> (Also `MAX_ORDER` doesn't exist anymore)

Will fix.
 
> > +Internally, slab allocator differentiates allocations of different orders and
> > +delegates larger allocations to the page allocator, but for the users of
> > +`kmalloc` family it is entirely transparent.
> > +
> > +For large allocations that do not require physically contiguous memory you can
> > +use vmalloc() and vzalloc() family.
> >  
> >  If you are not sure whether the allocation size is too large for
> >  `kmalloc`, it is possible to use kvmalloc() and its derivatives. It will
> > 
> 

-- 
Sincerely yours,
Mike.


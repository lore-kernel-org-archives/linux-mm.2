Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B6692CC6B34
	for <linux-mm@archiver.kernel.org>; Thu, 15 Oct 2026 10:02:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C813E6B0088; Thu, 15 Oct 2026 06:02:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C593A6B008A; Thu, 15 Oct 2026 06:02:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B703D6B008C; Thu, 15 Oct 2026 06:02:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 99A706B0088
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 06:02:15 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id BDEE6C04EF
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 10:02:14 +0000 (UTC)
X-FDA: 85324420188.23.D03D3EB
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf05.hostedemail.com (Postfix) with ESMTP id 072C510000D
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 10:02:12 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Iko2b0kk;
	spf=pass (imf05.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792058533;
	b=J6DSnTAFRJ6zEoPZTKjoFJ+rIcqHFpvL6/AcfsZqmBUlnh2xEsCp68w8KVJj4rEeK1Yre/
	r67WiMprFpckcOCNm8hey7x9MLA2nxWfjc+mJhE+H4oiHBARSqBbkGZuPq/RaaWOAnbWzP
	Mg5BtiH8mxznKdjICX7tI6j2dtB020E=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Iko2b0kk;
	spf=pass (imf05.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792058533;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5Pqi9+FJ5ewTDOrXx6NJLaiZDN05LqWUpfO1uWA0Wgw=;
	b=EJv8q7k1HdaBXFjjHQJmObXkc6Z3qc5qOCVbEKOAVJg51rP6NIKs+ccej/LDLdVXR5osLf
	9ZeI2nU6AKSLkzg68gywiZAO0WBPl/ykEDC3jWeGD8Cd2sKAjUnFJf2Rc+KsLulO4oSCBK
	6Lycz2dJIGONWakOhYbpwmKIj/8qRF8=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id C3D9B60120;
	Thu, 15 Oct 2026 10:02:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 256631F000C4;
	Thu, 15 Oct 2026 10:02:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792058531;
	bh=5Pqi9+FJ5ewTDOrXx6NJLaiZDN05LqWUpfO1uWA0Wgw=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=Iko2b0kk0bIGk8QVSE1lc+78pqVzKqFb/c6PX07rt8o/L64rRlfyLiAwQAvvm2D2f
	 F1G7/yeHsYCSltPOKzyG4dRvWl2wAq1Ha0lYOadrYRg8C/7VlDR3MhOfmEOuyYI3O6
	 1TR/hjFFUBSJGsWQ/bRc4w/sr6l1jJFyO4MqJ+MrCO//h0SsbVvwQv9lwP5HZZqHsq
	 xlBSvSeMPrQFaVZ5njxYJNPyR9/+2VYRrfm/xfsKCfbTvAsehGYV3ndjTxJxoN5hVZ
	 jav4uXA7zZ5PVeUMKQEjlF2ppEl4ByteA+ZH9MsjRxFrCuLnIOu3m/+n7yq50ydTGC
	 1V4mGjBjkdvAg==
Message-ID: <1f36992d-00c1-4f74-9947-b543ed794cf0@kernel.org>
Date: Thu, 15 Oct 2026 12:02:06 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 0/6] mm: pass alloc_flags through folio, filemap, and
 bulk allocators
Content-Language: en-US
To: Gregory Price <gourry@gourry.net>,
 "David Hildenbrand (Arm)" <david@kernel.org>
Cc: linux-mm@kvack.org, willy@infradead.org, brendan.jackman@linux.dev,
 linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 kernel-team@meta.com, jack@suse.cz, akpm@linux-foundation.org,
 ziy@nvidia.com, joshua.hahnjy@gmail.com, rakie.kim@sk.com,
 ying.huang@linux.alibaba.com, surenb@google.com, mhocko@suse.com,
 hannes@cmpxchg.org
References: <20260923211041.3127588-1-gourry@gourry.net>
 <asdTptfeLkuypU8t@gourry-fedora-PF4VCD3F>
 <df588805-6f97-4ef6-a64f-39222669bf3a@kernel.org>
 <asloWFM96BATH8SB@gourry-fedora-PF4VCD3F>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Autocrypt: addr=vbabka@kernel.org; keydata=
 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
In-Reply-To: <asloWFM96BATH8SB@gourry-fedora-PF4VCD3F>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 072C510000D
X-Rspam-User: 
X-Stat-Signature: 5mwtj3yymdr34ohk19nf485eo4jxbkam
X-HE-Tag: 1792058532-764297
X-HE-Meta: U2FsdGVkX19+hPnDJz8zCDk5yVkQcz9Ny8UtnklSXqlx+6n2lwA5/gNByUrwXlVgX83v/COOJmC5UYpjTNvASw4uKpjDRpv81X9XLAPNIC7JxXN98pnJ7KvA5aUkPX+PpIUmJZ/22unzMpP/sxINZSI2V9GbhrEpzCYbyHtGvAsrdsylUaeiEkBcp4iGnIca48QbC6CragFXdxmRXfD9b8LbFbbN+1HBsU6Iyr87QhlYgth3aUlNcTAyy3yAxDWkEDUdn39RfWOfXU608Ph/+UWOVR1g5VsBTOMyK/Bgr/T0CPKE6TtpsJ+97tQ0pe0BoRBFpo6TDka0Wx7fpzG8LsY/njPpIYCyGScFmmak9VWVZsBg+PCxku1C3jPKJxy3M6FbC+pnydQ3BmOHHXVC6PSb4YANvrnFAcUz2jfzOJBYGp7CluD6PSX8gLBIeJ90TEOriSMN77j+14Pl+x0JXHG2MrsdKqNHoGYtKlt/E2Kn+ckRQJj+3Qh2fYNwuNafKFDXbOV2KpsymrE9lJ8AJ4RTopfjwQ95o4pKnQ/bYHbEbozyaNNWENfO/HA++2yYclGzXT2ybkwSs/wzqTRqqDiOCMDbfua/GyysIPw7cRrIm4HpHPf8RinSaqm36sS/u/l8LLPc9ITakHblfXchL7xmj8D90Q/wlAE6m+fbIOm6kc5GN0oSCVdP0g9q8X/3NaJojCJYZoep4SYWJSwXuS5O53Xd0G4XDZ2jN8oLflQY5oSRNkB7PvkS+RUUzCcFqYcTWezC+mRjBnjr1434RH8nEAVUgYWAM4JAmEOpb6JZFAQNARlKpnPQJ1hkdeTNCLxqeZuzDrJntHAfwc/XKP/+7zO+qQ/bUUKvo2O1r8FXREsD0ymtQbb3qHRlV36CFKzoxQVstR80dt5BXePnl8nujI2NKK/tKVBneUjWPTm+Lt8jMgNh6r2AhhIVPP3ODnMWnCTf1BqrI16QCJw
 XbKWBQws
 /AOBDrVW2MDoEAQQ7Rv3/SKP1OaUlYl2WRlQNMGL9gDXEDV92nsbifKsFKm8s0os3g8M26VZV64Ithia7A3WRKMqmawe6Y4dshDKF7t8BG6/W8M77pg3KiReDa9fFJa9VnfFAFHL5csziSMk5HE5Ip6s7ejXUfJX72j3+VuksL2jxu6gGqmEf6WDxWlkyziYRmdoalofLZbNy5MUehJESOK6xcfOt0OKdRfqoXofLn2ZbW3NkDQ36XdAKFhTTpoS74Ee4xWulrpbqa15YlEIKLKJjCOdBtXO11OOiyGBcEcs4Sq7kFFzQWZ/rziRw5ggNlqJuN36e3Kqz/fFIrSelJAB3VB61NdcZ3mvdjQnIO4v4kDFrzKETPUQbQuTEudfvZmcV
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 10/10/26 01:28, Gregory Price wrote:
> On Fri, Oct 09, 2026 at 10:55:05PM +0200, David Hildenbrand (Arm) wrote:
>> I do agree that two sets of flags is suboptimal, but likely more flexible. I
>> guess an alloc_flags only interface is not easily possible ...

Agree with the alloc_flags option of all the other options.

>> I do wonder whether it should be:
>> 
>> 	typedef int __bitwise alloc_flags_t;
>> 
>> instead of "unsigned int alloc_flags".
>> 
>> ... while at it

Can't hurt, but given how it's internal only it didn't seem that urgent as
for gfp.

> Does it make sense to leave alloc_flags to internal-only state
> and just implement a new flag field?
> 
> gfp_t       -> describe the page (fully public)
> req_t       -> describe the allocator behavior (mm-internal only)
> alloc_flags -> internal allocator state only

Maybe in that case the remaining alloc_flags should just become 1-bit fields
directly in struct alloc_context so we don't manage 3 separate bitwise
types. Or more bits in case of ALLOC_WMARK?

Depends on how much work this would be (and if you want to do it) and how
the result would like.
> typedef int __bitwise pa_req_t; /* Page Allocator Request Flags */
> 
> #define PA_REQ_DEFAULT        0
> #define PA_REQ_NOLOCK         BIT(0) /* from ALLOC_NOLOCK */
> #define PA_REQ_NO_CODETAG     BIT(1) /* from ALLOC_NO_CODETAG */
> #define PA_REQ_SPREAD_DIRTY   BIT(2) /* from __GFP_WRITE */
> #define PA_REQ_DEFER_INIT     BIT(3) /* from __GFP_SKIP_ZERO */
> #define PA_REQ_ZERO_TAGS      BIT(4) /* from __GFP_ZERO_TAGS */
> #define PA_REQ_NO_FALLBACK    BIT(5) /* select no fallback list */
> #define PA_REQ_NO_OOM         BIT(6) /* do not oom */
> 
> Off the bat we recover 2 ALLOC flags and 3 GFP flags. Possibly more with
> a bit more work.
> 
> Then we get:
> 
> #define PA_REQ_PRIVATE        BIT(7) /* allow private node allocation */
> #define PA_REQ_UNMAPPED       BIT(8) /* page must be unmapped */
> 
> And we might not even need a new zonelist for private nodes in this case
> as long as we require internal users to pass PA_REQ_PRIVATE and add a
> function like
> 
> folio_alloc_private(void *owner, ...) {
>    /* validate (pgdat->owner == owner) before allowing allocation */
>    __folio_alloc(..., req | PA_REQ_PRIVATE | PA_REQ_NOFALLBACK, ...);
> }
> 
> User still has the option to request NO_OOM via __GFP_THISNODE :]
> 
> ~Gregory



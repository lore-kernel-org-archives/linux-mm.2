Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0C9F2CC6B2F
	for <linux-mm@archiver.kernel.org>; Thu, 15 Oct 2026 06:42:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C1F346B008C; Thu, 15 Oct 2026 02:42:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BF67F6B0092; Thu, 15 Oct 2026 02:42:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B336C6B0095; Thu, 15 Oct 2026 02:42:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 87EE66B008C
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 02:42:11 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 19131A0953
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 06:42:11 +0000 (UTC)
X-FDA: 85323916062.01.D11A785
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf17.hostedemail.com (Postfix) with ESMTP id 702EC40007
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 06:42:09 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=CN2NexLv;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792046529;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=itTJctx5woTFx1UjaaSxyhEraQjWD0N04fegW0vbHfs=;
	b=FStdiqNUxJ1FQvqDJFDNHzvYD2P7BO2D7TodE1F3xLSpRcX3T+ngYhndLledOG2C5cJr7u
	LlFz3qdKtBmJUEnMVJQT14URJgJXYn6l0cnltz4Hk2Y42PEnK4NLOwTqc3C6b2bO2Zls7/
	QbrVJJBCTB3YkOLCjEHAMEdCRmzflP8=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=CN2NexLv;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792046529;
	b=5lZctJ22+sC4RLAg3/8MTgITEUnqaIqcPJcf25mV0x+hEUVOlwK8xgFA1uB+tIYNVWIHLU
	lF2glHWAGC+7r+k1qUHv/8NZtvJr9WvXlRdY5FHW5ydiRRjKlFXDdqHBWO4NLKl6TqQ+Vf
	RDk5gpAy5xRyi3hMkQPPZ/yQ165QT+A=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 6640F44509;
	Thu, 15 Oct 2026 06:42:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 835E01F000C5;
	Thu, 15 Oct 2026 06:42:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792046528;
	bh=itTJctx5woTFx1UjaaSxyhEraQjWD0N04fegW0vbHfs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=CN2NexLvgNNPX8sikpjWrJgrR5wKMEQLpBaG0IsFIZHnYG9WF9nmHNamMsF5aldIt
	 fOisBJr4bMZZP3kf4ZvgIlQalMUbLoDDwUSgHdhHG5W9A4e0cR/oljA9OLVK/4PNzE
	 WsrfyOTPGcyXOkJSFJyoXg7NdVTMuaX+LZ/NjeS9Y95rehfFIFU3gBW9hM67Rn2spI
	 kFZ9DCETqtoUnRAjy6yN3VcQk3bsvr3h2SPgZkgPvqdQ093Tj4O6Y/U3j/XiD7CGuF
	 OZ5auFV5dDSyvYXejLbYgD3ihc8WUdyyNE47WrQ/ZJ4ErHUHjQfirPFOv67FxiOZSQ
	 7g+05vmfQ138A==
Date: Thu, 15 Oct 2026 09:42:00 +0300
From: Mike Rapoport <rppt@kernel.org>
To: tarunsahu@google.com
Cc: dmatlack@google.com, Pasha Tatashin <pasha.tatashin@soleen.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Pratyush Yadav <pratyush@kernel.org>, kexec@lists.infradead.org,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 1/2] memblock: drop for_each_memblock_type() and open
 code its users
Message-ID: <atB1uG8kLfmZyLIH@kernel.org>
References: <20261008190828.3221718-1-tarunsahu@google.com>
 <as4EcgiBH5jjww42@kernel.org>
 <9huzecdt633e.fsf@tarunix.c.googlers.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9huzecdt633e.fsf@tarunix.c.googlers.com>
X-Stat-Signature: 573nw7m15he43z7hqd3w6uum555d7zq6
X-Rspam-User: 
X-Rspamd-Queue-Id: 702EC40007
X-Rspamd-Server: rspam08
X-HE-Tag: 1792046529-293010
X-HE-Meta: U2FsdGVkX1/nVA+Pc2BY95WWOvAmDdvPE3mXL+6H8u/NCkcAAaREGzuV3yRdVoFiP/9vlGUDZguB7Rvf8vCv7OSnfsj2owKaJZZX5UsQeF9ofko6esyORY9aHFip4+IwsAfAAmly8T57tXEbsY+tlF4aqiORoZYNrwhbrY3tbv+ur6Gnx/uiF+j4bXp2OrNefAYANoCWqXS8aeQsoIwQy4c0ZCTYG/M6vikNqldlXEm8I+3STKJQiCGU+leR0qhBS70ltNhE5pfeEDf19gwhgPOENxkQu2nHjpVpQiXQs59HgN9HgqFy/3EnnAI7sNNxj9YcXaBaKbssi190vZYuAxoWzbkLgoYUjCzlpAIWIsOcq+S5UChx7dw5CioOOx054CMRfw1yQPgJrmOAb5MfR4KANnFClxtyES3E/XyIjArDsn1FFNKGaqwGb4JhF8nxT1/7sgSLPT1v8eI8JcAXA95tDibTKN6teljz/FdMR8vaV+qG9a4FHFezRa6b/KoWgH84IQBrS1D5kyAF2NFXlLKrxOYuzoC4jOkZGhyGA09NVOw2i5/lQktyPvo98Yi3qEIPj2gFAvzrTR1FWFG/JhpkvXfIszib8EAipCD/gAeav7QOMPOZH3g+HUTF2Ft4WuG+OoV/J+MzcHJA9Tb9+3JzcWP8o3Wi5xpecqtCKk101a0xF7PV12ElW1Db29lLQZpLdd/cnagKmGoI44yp+jksxuK9FHNUB38Ks97DK5Z99WfyQkwNSh6f8VQrEwjQ9m8Eb9680Ojy0cb8t6SVQN+kqI3mnaiWsVv/SNt3Jle3GMdPz3KfY18cpr/LN5XgzIpZH6gTOczdTyjELUofD4scmmhR9otDSCt20P7OCdV0wE7r0pNoA8cxAYYFKoE3HewUd/cmuuXEpIMrBsvMCtQxyI00SMQxpokrfRzHCto+9sAAS2Tro21eSrZi7/Ikil+xWb33biO8SLbA3R6
 0ZWHthaw
 fGRRJJcRw6PI0XvfCLC7AEl1eZ67W7TIdlOWn/Xc+1QNFEAcVEZNrjo3xbC6i1o52s4hYGSYgRcwbToLU30Tnw/3L1IO5hnnkXbXNnBb1j+BOSfIRcGqUoyAdOSVR5g/IEIGeW+eswdbAcIiOh5F/EK9NoEtOQ0oiE2Pf0XtkEuYErq8eIxPZETZ9qWlAid/2N/XARtV9nSWL+H98xRbDn9ypTFz7QPDpg/x+eTGnU1cDVstiaBULpVH6fGzdLODC4+zjp6W+zbrWVjNslJu4Twz09ICSZP+Ck0v9YnAohlAxCd4GDkYX+uE/DKMgEF7qm+u3VaH6n7GE6Ix+fgmz1unE0uB1GGYDj8h1
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Oct 13, 2026 at 03:18:45PM +0000, tarunsahu@google.com wrote:
> Mike Rapoport <rppt@kernel.org> writes:
> 
> > Hi Tarun,
> >
> > Please for the next time add the cover-letter when sending more than one
> > patch.
> 
> Thanks Mike for piking up the patches.
> 
> Sure, I will take care of adding the cover-letter.
> 
> You had some nit change suggestion, Let me know if you want
> me send v5 or it is alright.

I fixed some of it when applying and some right now, no need for v5
 
> ~Tarun
> 
> 
> >
> > On Thu, Oct 08, 2026 at 07:08:27PM +0000, Tarun Sahu wrote:
> >> for_each_memblock_type() always starts the iteration at index 0 and its
> >> body is a trivial 'for' loop, so it hides very little. It also gets in
> >> the way of iterating from an arbitrary index, which the next patch
> >> needs.
> >> 
> >> Remove the macro and open code its three users: memblock_add_range(),
> >> memblock_isolate_range() and memblock_dump(). While at it, move the
> >> region pointer into the loop body scope.
> >> 
> >> No functional change.
> >> 
> >> Reviewed-by: Pratyush Yadav <pratyush@kernel.org>
> >> Signed-off-by: Tarun Sahu <tarunsahu@google.com>
> >> ---
> >>  mm/memblock.c | 17 ++++++-----------
> >>  1 file changed, 6 insertions(+), 11 deletions(-)
> >> 
> >> diff --git a/mm/memblock.c b/mm/memblock.c
> >> index f5aaa38cfa31..59dda7d085f3 100644
> >> --- a/mm/memblock.c
> >> +++ b/mm/memblock.c
> >> @@ -155,11 +155,6 @@ struct memblock_type physmem = {
> >>   */
> >>  static __refdata struct memblock_type *memblock_memory = &memblock.memory;
> >>  
> >> -#define for_each_memblock_type(i, memblock_type, rgn)			\
> >> -	for (i = 0, rgn = &memblock_type->regions[0];			\
> >> -	     i < memblock_type->cnt;					\
> >> -	     i++, rgn = &memblock_type->regions[i])
> >> -
> >>  #define memblock_dbg(fmt, ...)						\
> >>  	do {								\
> >>  		if (memblock_debug)					\
> >> @@ -615,7 +610,6 @@ static int __init_memblock memblock_add_range(struct memblock_type *type,
> >>  	phys_addr_t obase = base;
> >>  	phys_addr_t end = base + memblock_cap_size(base, &size);
> >>  	int idx, nr_new, start_rgn = -1, end_rgn;
> >> -	struct memblock_region *rgn;
> >>  
> >>  	if (!size)
> >>  		return 0;
> >> @@ -651,7 +645,8 @@ static int __init_memblock memblock_add_range(struct memblock_type *type,
> >>  	base = obase;
> >>  	nr_new = 0;
> >>  
> >> -	for_each_memblock_type(idx, type, rgn) {
> >> +	for (idx = 0; idx < type->cnt; idx++) {
> >> +		struct memblock_region *rgn = &type->regions[idx];
> >>  		phys_addr_t rbase = rgn->base;
> >>  		phys_addr_t rend = rbase + rgn->size;
> >>  
> >> @@ -815,7 +810,6 @@ static int __init_memblock memblock_isolate_range(struct memblock_type *type,
> >>  {
> >>  	phys_addr_t end = base + memblock_cap_size(base, &size);
> >>  	int idx;
> >> -	struct memblock_region *rgn;
> >>  
> >>  	*start_rgn = *end_rgn = 0;
> >>  
> >> @@ -827,7 +821,8 @@ static int __init_memblock memblock_isolate_range(struct memblock_type *type,
> >>  		if (memblock_double_array(type, base, size) < 0)
> >>  			return -ENOMEM;
> >>  
> >> -	for_each_memblock_type(idx, type, rgn) {
> >> +	for (idx = 0; idx < type->cnt; idx++) {
> >> +		struct memblock_region *rgn = &type->regions[idx];
> >>  		phys_addr_t rbase = rgn->base;
> >>  		phys_addr_t rend = rbase + rgn->size;
> >>  
> >> @@ -2194,11 +2189,11 @@ static void __init_memblock memblock_dump(struct memblock_type *type)
> >>  	phys_addr_t base, end, size;
> >>  	enum memblock_flags flags;
> >>  	int idx;
> >> -	struct memblock_region *rgn;
> >>  
> >>  	pr_info(" %s.cnt  = 0x%lx\n", type->name, type->cnt);
> >>  
> >> -	for_each_memblock_type(idx, type, rgn) {
> >> +	for (idx = 0; idx < type->cnt; idx++) {
> >> +		struct memblock_region *rgn = &type->regions[idx];
> >>  		char nid_buf[32] = "";
> >>  
> >>  		base = rgn->base;
> >> -- 
> >> 2.56.0.385.gd3acb90ef8-goog
> >> 
> >
> > -- 
> > Sincerely yours,
> > Mike.

-- 
Sincerely yours,
Mike.


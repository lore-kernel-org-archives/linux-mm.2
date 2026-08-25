Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 11CC8C61DBE
	for <linux-mm@archiver.kernel.org>; Tue, 25 Aug 2026 11:38:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 03C586B009F; Tue, 25 Aug 2026 07:38:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 012CF6B00B6; Tue, 25 Aug 2026 07:38:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E926B6B00B7; Tue, 25 Aug 2026 07:38:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C860D6B009F
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 07:38:26 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id A85D51603DD
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 11:38:24 +0000 (UTC)
X-FDA: 85139593728.01.D16BD31
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf26.hostedemail.com (Postfix) with ESMTP id 2290F14000B
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 11:38:22 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=nBsTwrPQ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787657903;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kYx8aeMEaBJjieFEUuIAbUN5rp+4oyE9/j58DZHMqKw=;
	b=t66fsLtxF64hg6GTPxD5+Qh6+HU1njuUSJk7DwOgoISZDB8dwr+R5KMFsfW7BFU+x5VDIK
	pHWYkALdRB2+B21hC+d7WII07y/PKTcE045zqXb5dZmAbCI1y4c+EOyvvFOEw2hOpFMQJA
	r0G4dCu0hVVw9QCI2n48JIRuY8e5dgs=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=nBsTwrPQ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787657903;
	b=E2nq+K/jXFjrX+ARlk5VrRo3oikmz2gjprVehkriBjCwAFWnaTmhCAkBN3ElXbD3eKv4T8
	Pl+p3y1jLFTcTpEJQg0E8zLNx1AausLb2PyiW8D8Z+oJTzBBs/9gPDfKWnBK192zoS5Th7
	HRnjHxRV4jqPwtOlR1hQVI5szHFXW6c=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 9BFEA6013A;
	Tue, 25 Aug 2026 11:38:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA1C21F000E9;
	Tue, 25 Aug 2026 11:38:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787657902;
	bh=kYx8aeMEaBJjieFEUuIAbUN5rp+4oyE9/j58DZHMqKw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=nBsTwrPQM1EQ8ZVvH2h8CSQlt+V+fybz/E5HCoH1g/6G4NmVlh47TTU4WNrrp7BTQ
	 otqVRkJ8bbmT80kozyp9ZvsMUg5aBhbrwe0yHgKbbNAYPIhIaQu02bC2LrQk2qqb9n
	 AB75JmSK9W2uBSF4XKy5BXp7jwWI3ljH6atrax4n1CxRmyLlMV1oJg5csmXS2gGHog
	 fQcR4lL4xGda1kycL3mKxp7F7Ho3WSZUcQ7cAfviSNgwcvlbo1IReMLbNd8TfUU4ZO
	 fIgy01nc4DqVMvUcIHG5+dXyvvi1epORsPRXyxX/D1/XsphHrPL3o2MmxlGgrWv3Bf
	 TaHkq6xODc69A==
Date: Tue, 25 Aug 2026 12:38:12 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	Barry Song <baohua@kernel.org>, Dev Jain <dev.jain@arm.com>, Hugh Dickins <hughd@google.com>, 
	Jann Horn <jannh@google.com>, Jason Gunthorpe <jgg@ziepe.ca>, 
	John Hubbard <jhubbard@nvidia.com>, Jonathan Corbet <corbet@lwn.net>, 
	Lance Yang <lance.yang@linux.dev>, "Liam R. Howlett" <liam@infradead.org>, 
	Masami Hiramatsu <mhiramat@kernel.org>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, 
	Michal Hocko <mhocko@suse.com>, Muchun Song <muchun.song@linux.dev>, 
	Nico Pache <nico.pache@linux.dev>, Oscar Salvador <osalvador@suse.de>, 
	Pedro Falcato <pfalcato@suse.de>, Peter Xu <peterx@redhat.com>, 
	Ryan Roberts <ryan.roberts@arm.com>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Shuah Khan <skhan@linuxfoundation.org>, Steven Rostedt <rostedt@goodmis.org>, 
	Suren Baghdasaryan <surenb@google.com>, Usama Arif <usama.arif@linux.dev>, 
	Vlastimil Babka <vbabka@kernel.org>, Zi Yan <ziy@nvidia.com>, linux-doc@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	linux-trace-kernel@vger.kernel.org
Subject: Re: [PATCH 5/6] userfaultfd: decouple fault reason from VMA flags
Message-ID: <ao1-FMVkGlTtGDNy@gremlin>
References: <20260823-uffd-vm-flags-v1-v1-0-3086981b33cf@kernel.org>
 <20260823-uffd-vm-flags-v1-v1-5-3086981b33cf@kernel.org>
 <aoxm4jUrmL1eQlCJ@gremlin>
 <ao1waln1lklfk8th@kernel.org>
 <1bd9eac9-e078-42c2-b12c-bd8b92efeae5@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1bd9eac9-e078-42c2-b12c-bd8b92efeae5@kernel.org>
X-Rspam-User: 
X-Rspamd-Queue-Id: 2290F14000B
X-Rspamd-Server: rspam07
X-Stat-Signature: sjz1p9o6ddgxixhtbsrxwbur68gujca9
X-HE-Tag: 1787657902-232201
X-HE-Meta: U2FsdGVkX18fKZu6VRyxshZ9tuV+6bDn0lbXj9NVeEMxXntuyv0K+ux5/LJv+7Nur+O6WIhYBT+Cuf7VT1pS5OWPnnjcxFiT59gFTbteG4cSxGNzwVdFKmrCTB6QhP9bZrEKNr+AiBPP2Sav/R8JFWEs/wd38aAGBPvDo9c4GQRiHG7NOeOngKNfY6RyIMn1ey3/+acviLyF2XQvairhEum2JiWlCT0Gcd3h6vHEmgHD4vV6qTiSB4e1iRvqLMEE5AtmtiXpkRuXUpwnR5owj00mVbouFsUwzTeQqGBcTaQyNBJX6QxQm1scZWIqUleFqGb2yBBn3KQEIh8wiPLOyi7JXO8yF6nU/u0V6kh3T17b9JPnID1CA3sztgZNqPIJ2ioIxs3XagD+NYwAeq627jBcquLbgHi0tEUqkVYO+Exj0G+uo6XdCecRL0pXPcjmIwAAhCRP/sYSoIMzmpXe5m6tSXUgcvlOYw30RhY5KMVvFYjuTl3SGowOceeYN4N8cVNWvVAmpP8za4DGMalC0TF4lGef+N1pHfEPgA/B+qVPuwv3Mk11B0X8C1VIDTHbzY5Nxqi2RbmEkGtOPXITh4COARxCC9fueZINRlkLwjgp4jC2vK5raX6mxP4EhCqrbrQAjQMNO5qRx5rZi2ze/ThL+s+2HMq1omT2NgJw0jfJ1qqdTncbtE1dFsEglF+VfN74tUcJDn3eIujW1p6HdPPbSORN7df1jF7B5WS73AGp2dK8BFF3ynFjaSn07eIv8DRxaA7RUiKkWckjLkWDBDNADvRnYkbeZlNRpH6rH1Db0ZevOOGzIwwA97yMrUj4oe9K7NkzNkhw/vZvJ0+/0KudMM/3fU6f+bymljxvpSs4K4D9luesrMsRhxpjI/Lr2tR/SD3C2EUX725hC03rTw38kUdIYnXwphLTazhUEBpSDCDLeNRv4yj7Jz49yQBGFn3UnQJCs/gbKPUGWfq
 ou0/TipK
 1cl6IvctZktcRAYKL/33sf8n0cPAZK4YIsHtkK9rgaD9LqVM7uXFIc7kijPDCLaeZVe5jOToiVOSHRAUcAf728kUNp7/SHjuE8oZV/4nMhZwsv5lc2X6cC/UMvqoINUWAlhc2vfYBI9RN+GDOF/tM54W+nI4DMikILauKIr4+YhUsZnFH+6VAiFT/92kG+oV5sTc12oQaQvcYhEeSl53cRe2UyLxdP9SCxM6L6PooqI6MGU7G8+LUsMsYMYO9inYVeGvG
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Aug 25, 2026 at 01:08:33PM +0200, David Hildenbrand (Arm) wrote:
>
> >>> @@ -2793,14 +2793,14 @@ static inline bool userfaultfd_must_wait(struct userfaultfd_ctx *ctx,
> >>>  	 * If VMA has UFFD WP faults enabled and WP fault, wait for userspace to
> >>>  	 * resolve the fault.
> >>>  	 */
> >>> -	if (!pte_write(ptent) && (reason & VM_UFFD_WP))
> >>> +	if (!pte_write(ptent) && (reason & USERFAULT_WP))
> >>
> >> I wonder if you could actually
> >>
> >> You do this quite a lot and they read a bit horribly with the && and & on the
> >> same sight-line. With the changes to the enum proposed above you could do:
> >>
> >> 	if (!pte_write(ptent) && test_bit(reason, USERFAULT_WP_BIT))
> >
> > I find && and & perfectly readable and adding _BIT defines looks really
> > excessive to me.
>
> Yeah, that looks alright to me as well.

I find the general inconsistent different sets of flags/bits but not
really/naming all a bit of a mess.

But these are largely aesthetic and I don't maintain this file so I guess
you guys can live without my tag here...

>
> --
> Cheers,
>
> David

--
Cheers, Lorenzo


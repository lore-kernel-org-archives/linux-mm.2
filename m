Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3713DC5DF70
	for <linux-mm@archiver.kernel.org>; Tue, 18 Aug 2026 08:57:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 50F396B020F; Tue, 18 Aug 2026 04:57:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4C1096B0213; Tue, 18 Aug 2026 04:57:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3AFE66B0246; Tue, 18 Aug 2026 04:57:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 1973E6B020F
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 04:57:05 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id ABEC8A0B85
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 08:57:04 +0000 (UTC)
X-FDA: 85113785568.14.1274F76
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf31.hostedemail.com (Postfix) with ESMTP id 214CB2000A
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 08:57:02 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=oLN6x1RZ;
	spf=pass (imf31.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787043423;
	b=4t0QfgH1gYOe/OcXRQZHocixf3Uo6Q0eU8b1v7+UE2mLX3ZenQnNVIvvEOmm9H+vd1ar1g
	3SL1hCIgIqzGhpMhwW9AP6ScM4s6Mq1xAZ5lwnPHYcXr9NoxZtgx7mGj+Vv8GcBPyMxTCN
	dO64OMWxLobiw4DMNRUgnWcZ15RF/CA=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=oLN6x1RZ;
	spf=pass (imf31.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787043423;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vhY62l99sNhBmAViuWQPBUCeNDQgs5Ra/zZqAiWiAzQ=;
	b=zY2Pztkpc7bzAzZkQiCyh0R6xSYpJ77oTITF5rx5Qy1qH1ZbJ9YG8pBr+TUC9IqzV1WIg5
	Gxp9+/LH3eQKgaOxIJSNQNNLZXMrq8RoNg4BpHA0C66iMRDQqYbVx2gJqs1XDdEzTS7FeE
	VNb3avD/VCYzJj9TTHDOzi3Mb1696eQ=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 9CCB5601FB;
	Tue, 18 Aug 2026 08:57:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3AC71F000E9;
	Tue, 18 Aug 2026 08:56:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787043422;
	bh=vhY62l99sNhBmAViuWQPBUCeNDQgs5Ra/zZqAiWiAzQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=oLN6x1RZlJ6qDs/H+h+Ay61SstBW7/YNPXc3SxbBy86CKNihdgkjOEtYXmxyDnQ+t
	 YCfbtJMKKSRG7TK4/mO5PhDvvOER+hUWg/nmGYqu5fvUNa0jdcwcXHeoUiXpNHSmav
	 zmc2Ahq5b81Iz6OGeB3J2uPQDtGpOhRhfbwnTbqG2DkqH/BqGejtFZmnoIHVT3rmjq
	 79vxQyRlFuMsF6WXXVA2Mj9dWl14eIYDh8+E84tUisTp692XcuouYzbXonB1aIR4SC
	 Xna3tqsQyWClChM6RTfSaLYTYlifyVvlBRfhwJ4YvpBmXMr4lvMSPyhTVcFazGqByP
	 kF8qS4PiZ39XA==
Date: Tue, 18 Aug 2026 09:56:43 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Hongfu Li <hongfu.li@linux.dev>, akpm@linux-foundation.org, 
	liam@infradead.org, lihongfu@kylinos.cn, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, mhocko@suse.com, rppt@kernel.org, surenb@google.com, 
	vbabka@kernel.org
Subject: Re: [PATCH v4] mm: Use a folio in the softleaf_is_device_private path
Message-ID: <aoQXk1PmUDD2hxZF@lucifer>
References: <d0d781bf-43fd-4a59-ae0f-960c1e942f19@kernel.org>
 <20260818021326.5910-1-hongfu.li@linux.dev>
 <f27cc496-d9c8-4642-9d33-15c629623d1f@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f27cc496-d9c8-4642-9d33-15c629623d1f@kernel.org>
X-Rspamd-Queue-Id: 214CB2000A
X-Rspam-User: 
X-Stat-Signature: t3bwh8wfcue63m4cnaz8yuuam44tq48q
X-Rspamd-Server: rspam06
X-HE-Tag: 1787043422-913906
X-HE-Meta: U2FsdGVkX1/iwVK/3qQqz7eHJ9xNwUkm1wCJp12cpOZsiYJYZYD8JPgMLZY7ajS57eg/4inA+33iz/dOKufXdrSklzTXEmLkhpo/I1zeK5vKJVM3bpv8qBcQLi76yDoS9Wh4qHen7qny/P/TA0qTTncD38BQPyjF1441L6fWXdymOcvk8QuJr3EVtfH9Aqe+teTS7s61nYwA2j8TrDd8RLC00+ScYUcGQ9t589Gwqfb1qGpPl0aUmXjUot4S+nFFr6ULJDBiTTcrJZr/f6EPmz9neu47dWRImlF7Y+Y51boTA4nQwzyCceQBJIy1tXhLOI+dBo0tL9LJj4Oj1J4W432cW/DnV5LwgtZu+9Gkwra2zw9y/vmvnHKnA8r9juL5hyVhlbOIRlNqhUYFT12ufuBICkL9xo/oGEAj3WZH59Kt1BKTix8ckYONBIYXYC51xw7bX3oIRhAGLHP673nMivXuxQHo2MGzxke3IsXP63lXbLqFpxF8wsJPilIfdlHAh7nak/zyKCblVnRIcviiApODiNTRzwcuDfR9RI/XYJiPW4fspLqTNzlAH9de4vmG4HDekvAthzVnMAPbOvOJxY3n7LkdIV1DH2BhAQtnWEeDIsxbuIBAkV4neR2XPbSvlq+DpNLsVtlYWPsl9yHZcXO39jFIq6NoVuSWShtO8GgsNzOyJYAvfZV6JhRDMX3VEaLq3rwwxacsq1fm7Z71ttfJaxk9EiJRYmv+ozJkrZp1R0Qk+ayM6XcZccdWiAWHlGuyaAIGYhiCm9+MztZEY4IjLA77nuLgDgP+KgypCwf+RSu4Z/7kKN+sAXP3WybGhHp6UubZOcuZmH8Hv+R9Duy1GUGXI8TFoSc/4+xukpBpc0enelU+N6A8s8zy7nzmRefDxJiegEkZwRyZSg3g36ZxR93G2plr2MCTS6RlPKyRZHma4ksrfC5caI25lwcELMTQbAHus1+mqwaWTF9
 wFOc/Jy2
 Tv+dI7IGIEMHSPi9r32R8+oCc6MYWxH4cq+RYI+05Zzn/1IbkS2czSJdnKI+imWEA7LsRp6SsGO/8/b+uH8d8DydBPwQi0i+LsMhV0IwEnYRGaJhX9dXxux2S+4yX7+w1G4441XBiBpl+duAd2I9t6eQ8SeGTXICmwiFpGcJtJqGXMu85QCb8JHwy5Log5Rvg7lmLQjnhdJGoLFdcWtI/oPx55eeau0hE0nxCLF6cd/IhAFJdalIvUyF7/X1OlcVcg/S841Q8yMXT+Is/GFUhJAu9sUcWarhpLsKeydF5uZR1AAM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Aug 18, 2026 at 09:30:40AM +0200, David Hildenbrand (Arm) wrote:
> On 8/18/26 04:13, Hongfu Li wrote:
> >>> So after migrate_to_ram() the folio might have been split or otherwise somehow
> >>> the page doesn't belong to the same locked, refcount-incremented folio it did
> >>> before?
> >>
> >> I suspect a split.
> >>
> >>>
> >>> That's kinda a footgun... but this documents it at least.
> >>>
> >>> I think a comment explaining how this can happen would be helpful though as this
> >>> doesn't seem intuitive.
> >>
> >> I think, conceptually, calling into something that consumes a page (vmf->page)
> >> always needs care when operating on folios.
> >>
> >> Passing the vmf to some callback might be the odd thing here, because the
> >> vmf->page contract is not really clear.
> >
> > I'm very sorry for introducing this regression.
> > Thank you for identifying and testing this issue.
> >
> > I will double-check this code path and apply your fix to run further
> > tests locally.
> >
> > Would it make sense to add a comment here like the below, to make this
> > subtle behavior clearer for future readers?
> >
> > diff --git a/mm/memory.c b/mm/memory.c
> > index 4134ac607ee0..2b6d6c863ecb 100644
> > --- a/mm/memory.c
> > +++ b/mm/memory.c
> > @@ -4937,6 +4937,12 @@ vm_fault_t do_swap_page(struct vm_fault *vmf)
> >                                 pte_unmap_unlock(vmf->pte, vmf->ptl);
> >                                 pgmap = page_pgmap(vmf->page);
> >                                 ret = pgmap->ops->migrate_to_ram(vmf);
> > +                               /*
> > +                                * migrate_to_ram() can split a large folio, updating
> > +                                * vmf->page to a different folio. Re-fetch folio for
> > +                                * correct unlock/put.
> > +                                */
>
> "migrate_to_ram() might have split the folio."
>
> Should be sufficient I guess.

Agreed, no need for a schloppy long comment here!

	/* migrate_to_ram() might have split the folio. */
	folio = page_folio(vmf->page);

Should be fine.

The commit message should be updated to reflect it too and mention that we are
going from 4 -> 2 compound_head()'s now.

>
> --
> Cheers,
>
> David

--
Cheers, Lorenzo


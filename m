Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AE4DDCD6E56
	for <linux-mm@archiver.kernel.org>; Mon,  1 Jun 2026 09:36:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A4BE86B02F4; Mon,  1 Jun 2026 05:36:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9FD1F6B02F5; Mon,  1 Jun 2026 05:36:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 913776B02F6; Mon,  1 Jun 2026 05:36:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 823FB6B02F4
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 05:36:41 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 28B09120614
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 09:36:41 +0000 (UTC)
X-FDA: 84830839002.01.216ACA0
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf23.hostedemail.com (Postfix) with ESMTP id 81D9F140005
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 09:36:39 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=UY86iIMc;
	spf=pass (imf23.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780306599;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Q964EmR1sb0D+k4HDOGBDHSQElTuA68Eo3PT6Fx+5JM=;
	b=50LCqNMFA5L4PQNCZcQdnPEEnxqnchQXBudyQmgOK+BypMRowIzxvX8p/uaiqBpe92Ci16
	kuRyJzOzbdXUCngIfRXiWt6vrV20KZCotnFmf2qwi11qauZ+gVT9krOlkBUMLyRtEnttn5
	5w7rj41WL6KXntvI/khcihauS4I50To=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=UY86iIMc;
	spf=pass (imf23.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780306599; a=rsa-sha256;
	cv=none;
	b=z9kTDZVdM5HK1DaI+f9jJSTL0QrdVUfTItaI3nsE2Ukh+FAZCDualCVLNAOsf5Yx2J0y1Q
	VfsDDJbkMwJUNZZjbjU05UGZiS5J0bL+uVz0TJUB5nHiH40yUPqAfeZeF00qx9y2YlF2E5
	15l92/u8oKu5bGTWODu6RyIGHRxr804=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 89F9D43718;
	Mon,  1 Jun 2026 09:36:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF18F1F00893;
	Mon,  1 Jun 2026 09:36:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780306598;
	bh=Q964EmR1sb0D+k4HDOGBDHSQElTuA68Eo3PT6Fx+5JM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=UY86iIMcGikyN9u59oMpD3SPoWCDezq083xPacS+VXEBGVM0Lf5REGc9Geud0VJMd
	 wz5dPm+uXnDuXxLBZCE0sM5/ks5eENPD8c0ki6Ad0H1BjivPl3la7dVLMD28shem8B
	 9YyqNliA6iyYU3qZQsPzqxosOKnQuKz37S1O24AHoy8rl2UKjdLWMC8LlI6RiAnkmy
	 nMmpe3XTaxZ0ql3iyP+uJIqh8J/aWVdijHVSnn9tMTcMeseOc9cYfvoxbusgwfN5TT
	 FHSpcMGeULWL/66IrJQHtK4bgI9OOAKqSECrKDsm+XCANmsF35O697XETEu6ZhRhAt
	 TTzrHtzvna0Yg==
Date: Mon, 1 Jun 2026 10:36:33 +0100
From: Lorenzo Stoakes <ljs@kernel.org>
To: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: "Oscar Salvador (SUSE)" <osalvador@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@redhat.com>, 
	Anshuman Khandual <anshuman.khandual@arm.com>, Oscar Salvador <osalvador@suse.de>, 
	Wei Yang <richard.weiyang@gmail.com>, linux-s390@vger.kernel.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] mm/page_vma_mapped_walk: Use ptep_get_lockless() for
 lockless access
Message-ID: <ah1SmDJFAcGdBVvU@lucifer>
References: <20260528075507.1821939-1-agordeev@linux.ibm.com>
 <ahglqif-I4TjFK9X@lucifer>
 <ahhNq0pFKvSKZQbR@localhost.localdomain>
 <07baafe4-7d1c-42b0-9103-3e5666770061-agordeev@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <07baafe4-7d1c-42b0-9103-3e5666770061-agordeev@linux.ibm.com>
X-Stat-Signature: 9xuwkrj78o8ytsa71bjccjxfnwet4zzu
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 81D9F140005
X-HE-Tag: 1780306599-178765
X-HE-Meta: U2FsdGVkX19UsDMO5T9cppuHZ5A+IeG/clJLa/ZABpc3KYtsmgNzk5zuyJsMaflsRl5SVoGkDol6Gq4n/yGyEsLDXBjmxb0J5R8nQIPXO6/fmGs6gvNoADYBKMpzGUR25fFJEB5JuiN3Elp1Isnh/FNBg0R7A6/CKSy2v+0Zs+dz9nFpXWT2/1mD0B2Jwj4KEFbUNfrUDYK2M/NZa1EIUfz//fMPuG7zm4DZGNwGOIbRovTUL+Ge0/V6Z4EywY8CKAIs3Q/KfWllgoB9eVH8oH2Vu/TG0urwklk6a9EBmTDvOvOCfwLu17Z3CSA/OE6i426X4UQJGH9ZiUU7MzseMhazjMmn9E1WmYR7wzQIwhT2CY4qQUMUgFJnBLKS2IFaOUp3NbGDwSIuktlc/d08neq+d8Ib49OrxUWBn+XLWpRTpXrt4k8+pg6vNJLTZrvR91HOkVP++vW1mA2tXfl6YjjulUf3g9AQESGOg6/L1L8IeGEQfyJYhD0In1GH3btPqWOq+y2c+4CW7LxZQauZoFfIrVA/PBRuQsRQylUl3mlGJUpW1MuCcMVcWeeJoAoDb/KAkqP9wKoiCLN8lsoJmZD7mGPtvLJ42PX/W66UraqcMYYqZTUyG4njf/QYu1oqQR6zahpuNq4BDeiaJ7meW04zApi7j1aszkoyfSV/ZgYDeMYD7Jl0uHTP+3UeTiUp/wAjgm1zskRymbdM1ietONd4uQ65Lchj6XxmWv2LiQaDJYicrtsVpCzIqGosyCGBnTJI1xWO8nXNJDzYwOtoQhk2oTqjNil8dKeIBMupLAtBrRNhVLQyEQzsU0NObnS2atzAp6Fi3rTW13Vy9dR4KbcK1QfgEAyPlHBT5f4vVef4zEgkMmy2J5c8u/K9J6N+q9aRXufWwUDLY65OhWapLIz/Bp4w+ZUvGPLzrymMFiJ/lf9h2UGFeZCHNrBzlMPyfKlV9kino/39IDaB4oF
 UHRlIJD+
 +FjVrTW/CdqWSOHO2xZO1u/BiuJc2meAuypRaRGui1iKcmsezIz1tEUDgU2i1Y9RHjBPSlWQvH1kQA0C9lc+GQ/qeH7vKM/6eY4zy3x5gk9v26eS2Stki3dd5kWN4y1LoH5MIHLTQDfQm3XgfUWMxwHA/qgA8bdY2RrV933KAfex5rsfWaVtZDO63DYOK242ptf4tHx7SGbkxJM5HMiNbNg5m5RXl+1naF/Bw+36wvNSCsQ/iCnhxvjJwdlIvOTn9if/+n5BMOcpkGdJYFtnriKeR/ZxQUjSYvZ6GHAUQRF6Zn/s/RsbLs8ljtKXFfh43SMKVT34ZUBrLKO9QBYaxeXQT99H5AZrWguH3Efgv8Jif2eVYP3dr0h44Kw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, May 28, 2026 at 04:30:36PM +0200, Alexander Gordeev wrote:
> On Thu, May 28, 2026 at 04:14:03PM +0200, Oscar Salvador (SUSE) wrote:
> > On Thu, May 28, 2026 at 12:24:35PM +0100, Lorenzo Stoakes wrote:
> > > On Thu, May 28, 2026 at 09:55:07AM +0200, Alexander Gordeev wrote:
> > > > Switch from ptep_get() to ptep_get_lockless() accessor for
> > > > PTE reads when no lock is taken.
> > >
> > > This is an insufficient commit message that's just saying what you're doing,
> > > which isn't very useful.
> > >
> > > Please explain why you're doing this and what the benefit is please.
> >
> > Maybe something like
> >
> > "When not holding the lock, there is a chance that the pte gets modified
> >  under our feet, so we need to use the lockless API to make sure that
> >  the entries remain consistent during the read."
>
> I would gladly use this, if it makes sense for everyone.
>
> @Lorenzo?

Sounds good to me! Thanks

>
> > Only arm64 makes use of it though, due to the contpte stuff and being
> > unable to do it atomically.
>
> Thanks!
>
> > --
> > Oscar Salvador
> > SUSE Labs

Cheers, Lorenzo


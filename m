Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8E39BC5516F
	for <linux-mm@archiver.kernel.org>; Fri, 31 Jul 2026 18:11:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 86C146B00A1; Fri, 31 Jul 2026 14:11:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 842AB6B00A2; Fri, 31 Jul 2026 14:11:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 75B0F6B00A5; Fri, 31 Jul 2026 14:11:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 4BD156B00A1
	for <linux-mm@kvack.org>; Fri, 31 Jul 2026 14:11:25 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id C97081604C9
	for <linux-mm@kvack.org>; Fri, 31 Jul 2026 18:11:24 +0000 (UTC)
X-FDA: 85049864088.24.1B02784
Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	by imf19.hostedemail.com (Postfix) with ESMTP id 205C61A0004
	for <linux-mm@kvack.org>; Fri, 31 Jul 2026 18:11:22 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=NpNsu0N7;
	spf=pass (imf19.hostedemail.com: domain of leitao@debian.org designates 82.195.75.108 as permitted sender) smtp.mailfrom=leitao@debian.org;
	dmarc=pass (policy=none) header.from=debian.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785521483;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qgKGyimHWHWrS7GKqRrXGIY74zPdoBJNUqsWVCUzh6o=;
	b=12HFz3H9+r/aODbLYQ6Qnr2Rq6Ur4q36c5AFe4HxRkdDSOYpcEhLrC6n5wP7cOFJpgZudw
	VzxmFLNCt+TYXB7jo3sHPOiyqcPInCxNdr/zkdG2uWdo4hT691lGthZQT/M8S8yiJEnPy2
	ne1mJ3zveHSUnbGRE4Pc4Bd+iGJM1lo=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785521483;
	b=zwX+GMV1ddeB9krSaByn7EE9XWB2kAhwEljR9c2dzPodza9otz5E8yOrIn6J0I5OJV66vl
	3fxTZM1be4GXxqj8ueMManhaRQxrh4ZnCJ7nPQ/LZ5i4a3x/aOY7AskPNnaabHMDMqLliC
	Tg1MM3QF+qKx3hggbEqnwWCeXRKewBc=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=NpNsu0N7;
	spf=pass (imf19.hostedemail.com: domain of leitao@debian.org designates 82.195.75.108 as permitted sender) smtp.mailfrom=leitao@debian.org;
	dmarc=pass (policy=none) header.from=debian.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:In-Reply-To:Content-Transfer-Encoding:
	Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:
	Reply-To:Content-ID:Content-Description;
	bh=qgKGyimHWHWrS7GKqRrXGIY74zPdoBJNUqsWVCUzh6o=; b=NpNsu0N7Nk2pB2+SdDRWLmEnhq
	d3V0f55YufscXQEl5pXVlXrTfe6VEv5enoXClU+UvZLUheXpGmD0icDh6+RDW+6brJmY0ykZN491y
	A1xHIWBiR1s1YFIYbocN/mYdIbECKTcNF0K/c4B7iVtFc3dauPPx6tHdq6bXLAK6kA1TlIljgzzkK
	ok49T3dq8jmWghghVW4C7/rKanX1I8nIEW4Qtj5xQXKPOzthngAqG9SnnflegVRWO1cyR+3NKVDXd
	u5H1EXCl1XIlFPTevZbJOftj4jCor++oYXF+qJLTcNlVhI2a1hSQKp/sYypSR7HMx8S5fOEvdcA5U
	qVi2hIlA==;
Received: from authenticated-user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.96)
	(envelope-from <leitao@debian.org>)
	id 1wprhK-00AD5R-2f;
	Fri, 31 Jul 2026 18:11:07 +0000
Date: Fri, 31 Jul 2026 11:11:01 -0700
From: Breno Leitao <leitao@debian.org>
To: Pratyush Yadav <pratyush@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Baoquan He <baoquan.he@linux.dev>, 
	Pasha Tatashin <pasha.tatashin@soleen.com>, Miaohe Lin <linmiaohe@huawei.com>, 
	Naoya Horiguchi <nao.horiguchi@gmail.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	kexec@lists.infradead.org, rmikey@meta.com, riel@surriel.com, kernel-team@meta.com, 
	Kiryl Shutsemau <kas@kernel.org>
Subject: Re: [PATCH v2] kexec: keep the next kernel off hardware-poisoned
 pages
Message-ID: <amzkmjkJtLyYnE-y@gmail.com>
References: <20260730-kexec_posioned-v2-1-f92d18551f64@debian.org>
 <2vxzecgj6od4.fsf@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <2vxzecgj6od4.fsf@kernel.org>
X-Debian-User: leitao
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 205C61A0004
X-Stat-Signature: gywtumpk68h4apmo59qxuqu4f598fxjo
X-Rspam-User: 
X-HE-Tag: 1785521482-122689
X-HE-Meta: U2FsdGVkX195FbABST0GEu+55oWi6uP6P/46RAiu7lSawCvQ53YCk9ndi7HS4s0B1GBUPlz5OwNkFErOIBi4OHAMv50YutSgiwnbAH5NMRhE6GiBcUkwyUe/USEYdnnJ+lNgm+u6v6aVPlbyy22OcqbrSca43uHihZkFCons79IWkhjf3lqxTnsB9ipJYr7/NTtRqBDty2ac8CWhQK1At9Td7q6DPZ0wdXZnCERs2AJl/x7DLqeSBLalRC+tKCIPHqTv6cXJ1fp0uTZ8gt2mYL/k5R8F9cBHBJb/Q+tFi9PdRaX+5WbluBcmlKbnEyAnenXhA3dx456toAZobm2C7E4wCVyACgTEIELvKjBuF4qglavQ92nCupxQ+22w5R0Nkp9+3rIBFGv1C7GhrKDKxrM6iK9hSJdpZmikZfKEGQHn4+JRiM9aaG5ozaQGORtCQHO/kqRA/YB6rnkQc//iFrBeGrULRE8so6tNS7RpBYfzIErWiEIevekNJN8/OboJ6rud9b3lSVFZoqXeZ7wUcJ1KW/tZMyyA4G7pniTVVcMzX5o2Cm0uOJb0VHSBD4fUFoJib2NiTPcutiaMt+0uQY0ghE/vsfWFkmJrAT7AlJWffKU75j587cNdSYhQ0RcTFdJ+bsaFbwr2nsm7mKYYOjZVC5uOfva8IFU+48EFkbNLMGJ1k3iInqQLEYRgl8P5uHX3p9azxms/GhoaUdbC9+BfTbMnG9JsZoZq37TSja/APEGqA/FvzH7Hc7bu49UfbXmbHzeOwxfBJNiFC9+dTZ/2n5XLmihKeIWynBIFzP999rHRcIW+73QAUYCZNSkX22ULNZQdYu65fI9FdChX1kgk+t5pfZeCfeMPhTLWQDiJ+/ht0FNTUWioSrJhcGOm06tL6E5pZbtV/B2NHO/P0z1ZGWk8p+i9uD89pQ/eOTg5oOfKpo3NNXRWsfolfbyeUdI8Frjubpv13ScM6nz
 M4r9kpSC
 lWrjlNh/oJcfD0Zwc7Mt7M6VbkeJwAC9YrgIGVRbkMReMPiH1sdqEyoJjqEwig5STm2BnAB24gFBVLJnEFgXz2hn4f1T4NMyz80L7OpyzqX3cUTIddFnqbNjlrhh8BzjmYcc+dYqnKtIid/Uihj90xRecNUHjjN6kLaPPMdI+81OQUg5Ya1HcnRHEjo7kKXL3ICj0GHMc1X5ieuVhjRWgBlZmiFrgjEQDjyOfLQOF5boG9zDbnOQV/owEBSYgUQfnJXom9KpSu0CpH6Vwo01xHcO8ZKW/q1+fo0bs3HAm8PoB8XkASwRC8tg5UeE6xQP2cndeVSnO7+ythprZfW73nm5KBLzvhE0AJpvh
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jul 31, 2026 at 07:49:27PM +0200, Pratyush Yadav wrote:
> > + * return phys_addr_t, thus this "extra" parameter, instead of returning
> > + * the hit.
> > + */
> > +bool range_contains_hwpoison(phys_addr_t start, unsigned long size,
> > +			     phys_addr_t *poison)
> 
> Perhaps
> 
>     phys_addr_t range_last_hwpoison(phys_addr_t start, unsigned long size)  ?
> 
> And if no poisoned page lands here then a default of 0 or ~0UL?

That was my initial preference, but hypothetically phys_addr_t 0 could be
a poisoned page.

I hadn't considered ~0UL as a sentinel — that should work and is a good
suggestion. let me prototype.

Thanks for the review.
--breno


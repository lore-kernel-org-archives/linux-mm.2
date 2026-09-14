Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 76306C88E50
	for <linux-mm@archiver.kernel.org>; Mon, 14 Sep 2026 12:54:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5E30A6B0088; Mon, 14 Sep 2026 08:54:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 593AC6B008C; Mon, 14 Sep 2026 08:54:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 482A96B0095; Mon, 14 Sep 2026 08:54:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1E5C46B0088
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 08:54:51 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id ACC9CA4BB7
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 12:54:50 +0000 (UTC)
X-FDA: 85212362340.19.C696B0C
Received: from fout-b1-smtp.messagingengine.com (fout-b1-smtp.messagingengine.com [202.12.124.144])
	by imf12.hostedemail.com (Postfix) with ESMTP id B4B4940004
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 12:54:48 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm2 header.b="X ScFTxA";
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b=npZ75TKF;
	dmarc=none;
	spf=pass (imf12.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.144 as permitted sender) smtp.mailfrom=kirill@shutemov.name
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789390488;
	b=eG3kXzHA7Ar0HC5PlhElBQveI5noLfw1yvn/8BayV6ET/nP0EYQzImznEt3TNM9X62dkQD
	+VjjqyWIOjYWPMGORGsGdSVU+D806ngEVuaKC+JArta61Fd4RoqTF9Mo7cxDETcP3swcQL
	USpCN2WeuYBqOhFOLZZb1wTC8Lc1cbs=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm2 header.b="X ScFTxA";
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b=npZ75TKF;
	dmarc=none;
	spf=pass (imf12.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.144 as permitted sender) smtp.mailfrom=kirill@shutemov.name
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789390488;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=58HuI72UzzufVKEgM4X9pABwg/YtbZfRPL8mqB0t9wA=;
	b=dWEtOyQp5dQe4dhP6V0CL0IB3AnJBemWSQquk0pFSWR2N+9j/e/laNNvQ1yFUs5y6Xj4dB
	X7CaYsr5oIxOlFa2Lxw4A1S9KrqOB/D2ypq/2c9Md5tVnMaSdH/k9/M5PX+bck7Lk8MwW7
	wIGOVIcPfNrWoM936n+AHwI7J/l3hOo=
Received: from phl-compute-02.internal (phl-compute-02.internal [10.202.2.42])
	by mailfout.stl.internal (Postfix) with ESMTP id 1BE2C1D000B9;
	Mon, 14 Sep 2026 08:54:47 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-02.internal (MEProxy); Mon, 14 Sep 2026 08:54:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-type:content-type:date:date:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm2; t=1789390486; x=
	1789476886; bh=58HuI72UzzufVKEgM4X9pABwg/YtbZfRPL8mqB0t9wA=; b=X
	ScFTxA+nYqYAWWciwS/wfXDPt7L+2Olxix7oQAXauU32RuY+7dlJC7w8hURyOWth
	u1pSeS8IOglcXUpmXYI0nRNKHY/o6QTBYevLz9mbhxVbMWSekbVzYfLUR5BQMGnV
	LoXZtdrlA8xKY4vtZ/7B6vN7+KgVa7T+UUl1Poe0IdPsQbpEKMGUoI+q8i6ytpgU
	JWyg0f6vcNsljTXG4xf7srS2NW7v6OsgbLjNVOt7JO3wpC3jYFmtSI7qqpUz8X2e
	qkD4RToP507RmUoagWp2kqAh/F3w7QDOExCGYChgTKBLAlpACfv/7oWG0B4wuBe7
	n9TM/1+fGnO3mcob7C1UA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=
	1789390486; x=1789476886; bh=58HuI72UzzufVKEgM4X9pABwg/YtbZfRPL8
	mqB0t9wA=; b=npZ75TKFZODpvLZX6x5yyyX8XY8g17pNRzf0tIImPa6pJRZeuIG
	0YVY1oRTGg8df7Z6eIxxz0hIehtWFzSCOyd2TKADDLSPG3xjy49rr34MAAq+29Lt
	savhmUQk7zpP9o7PGIAheQncdL63JHKvXoPR7ngNZ1VWPOYKU6q1kaJF26KGUjae
	3iwDzLwQOK0UIl3dHwsLRLvBenIf11Eu3hJd7t/gd2CPCxdPVTPiswBi3K//VqhY
	Co3le7+a2n7ezI0egPQUHNZhXpgn8YuJwpkkk/T4ZDlMDq9+UHIAKTKWpLjqvbs5
	WQAiyxvTL+vG9Dk3LqgfUn6TFZNG6wZCZQw==
X-ME-Sender: <xms:lu6narPmfpVnstfOzbIhkoHnmNmU8V-Yia576STa6PIzz4ULuY8yIw>
    <xme:lu6najnH8N71sB91W2CZKvfXFMbgineqYsj8SBzzr3zaiSK5tEN05uEWLPGfWFKO3
    zl2M1cpMlOAPbqaKPW6Q7G-c57zFeCBib59DkzOBlqWCWemr5yLNOcs>
X-ME-Received: <xmr:lu6nahqbRiVkSbF9kIwbaxBklQwRUrzD7QibUn9qEJIdPnjdBbyryYpq_nk>
X-ME-Proxy-Cause: dmFkZTEkuE1qsOgHWNd2OJi/yEsB/yNWtkH7YkkdilSZOyWVcpUr7C3FIxlP6mcCehLd48
    KR9hpUt45AE5XRP4aAPuDU9kUileQnSl0/RWstJYNZsUBN3hRAQe3TEpT73wY3cRQ8sG6D
    ZVA+IIhiR21cGIsbwsWUrYJ0grwFLMNYvsvuKwT0L6ql+b5ba1DO7cP2Xz7pVKcNwle5j7
    psSwiANkuSb/y/u9Hr3hLrrVW/pdrXIzE9pfy/yW4ltMw8Yjol9bLoBNYjEv/PKK/qPfFL
    2KJ7pqjxHaFgfPIhMCdBUc1bKT7acJdP3SvNAyfzszQLtU2vMgGXZ6qLjIkn6SPRotbICZ
    hQPH4wCikJyTznNwi7vj5rg5GzLyM9OK1v9ErJClkMQb28ZjgVSboC8IjUJj0LcgEZ0g0+
    mNf/bU6/dEECgqV1eaEkAYDMUHuqDCNku4lVWzRxqvZXdhNTiHKCrSjQaCQcxmxH0zNLxz
    u+pSpaOMhdtP0IzwoXAXTheThWUJ/GqXxE6pxpeZd4u2urZBsLQx9BYySVqZsJQrd2xODK
    2y4l+0xyeknr1coDbB3Btmt9XsX7lbej3PVXDseaNO+Ykqa4uQSc1J3Cr+PZ6GTSjRECa/
    a4u/32yakCAgtWL9DC1RvLUtuk4znNtBYEQYAlG8hUJVEcgzA5eIgVVIOLQg
X-ME-Proxy: <xmx:lu6nan4yiahtUA2GFEJiAgxMP4K-obqDV-RcDXY35niJ-917y_3aiA>
    <xmx:lu6narJr199QHvXRtGDCVBgz3pbLpa0A8xhr40YnEY0Y9QN46eqjrw>
    <xmx:lu6narlHImFxT_2QDLgB29nrLHa5R0mPp1LDND_zD4YPdVsQ-pD_6Q>
    <xmx:lu6naq8Kc79BrM53WoVjOURv-gHn3iL0XwBJEIe8hA-VXB6lxpoAOw>
    <xmx:lu6nancwZbD0qRsRrjf3k0D3eiyVYxmB17rxaSWLekbER7RGtVu1VHGg>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 14 Sep 2026 08:54:45 -0400 (EDT)
Date: Mon, 14 Sep 2026 13:54:44 +0100
From: Kiryl Shutsemau <kirill@shutemov.name>
To: Zi Yan <ziy@nvidia.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	kernel-team@meta.com, "Liam R . Howlett" <liam@infradead.org>, 
	Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
	Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, 
	Usama Arif <usama.arif@linux.dev>, Vlastimil Babka <vbabka@kernel.org>, 
	Jann Horn <jannh@google.com>
Subject: Re: [PATCH v2 11/12] mm/collapse: declare the collapse interface in
 collapse.h
Message-ID: <aqfuZ09c2-yHRUdG@thinkstation>
References: <20260910120238.2529819-1-kirill@shutemov.name>
 <20260910120238.2529819-12-kirill@shutemov.name>
 <DLCPXEXM5YQ3.GPN2LX0UL19T@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DLCPXEXM5YQ3.GPN2LX0UL19T@nvidia.com>
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: B4B4940004
X-Stat-Signature: x5ndfm5nf45uisakpzgmjpbpd8y47irp
X-HE-Tag: 1789390488-214922
X-HE-Meta: U2FsdGVkX19z3Am+R2KjUg0ni9Y/h3oAXXpHtMgg6vSYXQGCEwVbyM84xGI07td9dSuW3z1aBrHt/0D4p7EuL6xRxibVcGB/kz7DEEkYZrLktmWOwk0PWuQWfATo3uomcJo122ACYq0hieloDOxwpcNr6iOcUyFRjZLNjDWWfSImYZ0wvfdNYZ8Xk3u+nui/EuZrcaDyMRKMZKY4LZ+M6WGd9+paozeQGeQPeOGmMp+NhVQpzHl28yY30XXqyPvr/vhrX52UJRs9KeE4bMMVv6xhdl2d2jbGJhtsVW7+2MuScPu0bTGQr0KEwgubB7epUUXWaqHazjswTVpHfrCQC4Xf1WbWWqaieLwzr4+2DkwvQLMqNCXtF93HsNu3fgfMlQg5bG1sHUtcWz2WpM3dnv8eDrPbLkWlFYfjYD2YOJBCBukKhLqa8qpxjEjlAn1tW5hc5sahdQIwNXxDZ4Gyf/+mTMbxUdCgyiYhbPG7+UH/Z4j+Gd79mnuOrT+kQMjsBnFR+gFQSsz9Or/zwUc3kzPuifRz92zbXHFfJr6B9OnlC1zurs2xwaR3Eu3i72P/HHVObHsZmeKu59PBTmllUATAxc33C9GduWs5NUeCVvbd2Qcxrqz6Oas/9A269EZgjIUnxuC/UduGHCN1wFwzEu5eeXcdH85ike9/aX9SqZ8vvr3GW70lUr0FX6w/X+seKCmrVM2QVQVuJ9VTgJVt83XaOs3fLVj8mvS9kW+4dISo+8o/Z2SQ6DcCLe8rmKkywjIxFoiFNjI+KQ0tMjmmRlR5QEBz/iRZfZ3L8Phu1Qb5TQKVFSKtcSRW/iXudNga4gfWGOjRYZ9x+5gi1tQy2GnXN/goXxDThweGazBA5D6Q2wfFu4K7CYWaDxApSk5Ar6zzMWwTwgo7ytqr2NCQAetQqzPquqKEwI7PZRtB6qBHRDNvdbEtigUlnSv1Dn3Gx7OTIV9SIVA2BWAVhjP
 kIpiceRq
 Q84tdBOy6NZyum6viyE4q8Ff6mEwUPMLA0mdJ4OST1ZOgUHDM4Wrb+eArhdMpKttZ784u4jmr521qTG+Y9DIFv8nLyo0v4yXLa0c+cw07ls5GWFxsAmrTm55w8P6josTKybEoBxj4kNiSZDnAinG82CuT40v49rZBEoL1nT2w42X4fb/1tBov1SGtfcOn3QSW3om6xc/5ELx2jwp85Dwt6VrDJrvmQod2zZ21a/tbRSm1qLgrEacMX/nevVnAsAG7PRgngH/P83ww/D4QSweTZT/M+ckYYtlG4mvO3DJxIdWNvrjshMCv//ZCrc0QA3Dk32pZV1S+8q66eYfON6xqN233+xxfcYYiAI+TITcUDNpmlLfev1Vz/f3QtlfI98lCjjakgJxGFOviQoLEnvum2xBtFjMcI3f1sW9DUDYQNF44x0z2eDGwjWEINabHPYRGmBDx
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Sep 11, 2026 at 03:02:22PM -0400, Zi Yan wrote:
> On Thu Sep 10, 2026 at 8:02 AM EDT, Kiryl Shutsemau wrote:
> > diff --git a/mm/collapse.h b/mm/collapse.h
> > index 346859a2184f..1ebbbf63fb25 100644
> > --- a/mm/collapse.h
> > +++ b/mm/collapse.h
> > @@ -106,4 +106,48 @@ struct collapse_control {
> >  	bool scan_retract_only;
> >  };
> >  
> > +/* Which orders a VMA may collapse to, zero when it may not collapse at all */
> > +unsigned long collapse_possible_orders(struct vm_area_struct *vma,
> > +		vm_flags_t vm_flags, enum tva_type tva_flags);
> > +
> > +/*
> > + * A caller states what it allows in cc->policy and then hands over one PTE
> > + * table's worth of a VMA at a time:
> > + *
> > + *     collapse_control_init(cc)         once, before the first table
> > + *     collapse_scan_pmd(vma, addr, ...) per table
> > + *     collapse_run_pmd(mm, addr, cc)    when a scan found work
> > + *     collapse_control_release(cc)      once, when done with the control
> 
> This is a good overview of the workflow.
> 
> > + *
> > + * The caller holds mmap_lock for reading over the scan and passes an address
> > + * within @vma, aligned to the PTE table the scan is to judge.
> > + *
> > + * The scan returns with that lock still held.  It only reads, and almost every
> > + * table it is offered has nothing to collapse, so a caller walks a whole VMA
> > + * under the one lock it took to get there.  SCAN_SUCCEED means there is
> > + * something to collapse; anything else is why there is not.
> > + *
> > + * The run is called without the lock and returns without it, taking what it
> > + * needs in between: what it does -- allocate, isolate, copy, flush -- is slow
> > + * enough that a writer would wait behind it.  The caller gives the lock up
> > + * first, and with it @vma and anything derived under it, so a caller carrying
> > + * on has to look up again with collapse_vma_revalidate().  The run revalidates
> > + * for itself rather than trusting what the scan saw.
> > + *
> > + * A scan that found something has to be run: the file side takes a reference on
> > + * the file while it still has the VMA to take it from, and the run is what
> > + * gives it back.
> > + */
> 
> It might be better to document each function individually about the
> requirements and what each does instead of putting everything above.

I will add a comment to each function at its definition: what it needs,
what it does, and what state the lock is in on entry and exit.

The overview stays. Per-function comments tell you about one call at a
time; the overview is what ties the four together and says in which
order they are made and who holds the lock in between.

-- 
  Kiryl Shutsemau / Kirill A. Shutemov


Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 81BD1C61DD3
	for <linux-mm@archiver.kernel.org>; Thu,  3 Sep 2026 21:19:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 627996B0088; Thu,  3 Sep 2026 17:19:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5B1BB6B008A; Thu,  3 Sep 2026 17:19:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 479C16B008C; Thu,  3 Sep 2026 17:19:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 0D3066B0088
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 17:19:04 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 40F6A16063D
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 21:19:03 +0000 (UTC)
X-FDA: 85173716166.13.E88EBE6
Received: from flow-a1-smtp.messagingengine.com (flow-a1-smtp.messagingengine.com [103.168.172.136])
	by imf15.hostedemail.com (Postfix) with ESMTP id 4DE14A0005
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 21:19:01 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm2 header.b="K kyGpbv";
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b=kTkuY8LX;
	spf=pass (imf15.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.136 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788470341;
	b=tcCYCPge4zow/jZRg0nnCRxQSsBRQPf7xmQkZ/96fjSv8kc0cUL07kosAD1Zq5DE0nft6h
	cYO7o1+hTtFRgAjlDqpEHr9Tx/kDCV5BWxXQcctstyGnq/T2uP3bGxFFhFbPc2xD1pWtg5
	OM8Cl8DnRgQXW2BeZdPnO8CQkOv0Wzg=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788470341;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7ionguWI8woKzL1NBqHJS3q3P7mndBbcfqKVWzugITQ=;
	b=q/S0r7ashxDhRhPJ7uSGWrKyn3Ui9GQfdBsfJNeNSKrTJGLKXBuLqbZsf1lmQ9763YFVnp
	s62izgrfeYZ1dxKQ1P5RXCr8tkFdWOhPhG4VQRpPD2ofstZkIcek/fLUd4ysLUzCAWJVNW
	fE3n2vz2Gw1i4E7mPIR285FuoE8Az0U=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm2 header.b="K kyGpbv";
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b=kTkuY8LX;
	spf=pass (imf15.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.136 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
Received: from phl-compute-02.internal (phl-compute-02.internal [10.202.2.42])
	by mailflow.phl.internal (Postfix) with ESMTP id 9FA10138011F;
	Thu,  3 Sep 2026 17:19:00 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-02.internal (MEProxy); Thu, 03 Sep 2026 17:19:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-type:content-type:date:date:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm2; t=1788470340; x=
	1788477540; bh=7ionguWI8woKzL1NBqHJS3q3P7mndBbcfqKVWzugITQ=; b=K
	kyGpbv/xk3XEBsFODyNNbPNhtISyQzZok3DSPya01CwZV+kwt5ABBw0IE2wyouvP
	IHqmtFW6WGlUtkcORzDbB31AnWdw7VpELOtvXH2xJl1x3D2tPK5IjwZ3Zm1QMpB+
	5V+QiTCpRK7ZO7BxXlINFjTDLTBQJlX4DtHit15mzjLvROVaY/TPHIcC5yM7UnEt
	gmtbLL/EgP+ZZiworifrxEbnvRUlfmfRLY2gbhElz0s8ls/nYBu3luVMWgHI8fbs
	IYELbwLj0Jbm7+LP2Km54IFowHViDWew8ElLhftzeL1WMn15wx1a2hbyyEH8UpfX
	xylcSUduqHOHr9Qt+yweg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=
	1788470340; x=1788477540; bh=7ionguWI8woKzL1NBqHJS3q3P7mndBbcfqK
	VWzugITQ=; b=kTkuY8LXa1IqB74/9oSwScifj+93XwAdFCiALWWa64sFKERxIHL
	NS8dFJd8hGAkJkd5nKNBjL3TLUHl4GZmvq8kG52Z+zH0JhFT3ZF1oFuLXz6bqRFD
	pFhF/qSUizLtgBPD2cvIBS5Hyu87drtjmzAKEKuSJjTH2NDLmUXKqZzbvwndpC6z
	N2ZrIQ+/gB61cN/oQjp5MTDSr642N6d5gGuaWwNr21222k2LgrUPiTbkpFj7eNeP
	DHvRKj/rb1a/GQDRYD2a7sHSHOI9DD/NvbqSweR9DITPUOTW9tvb7F1tebDE2Xsz
	fcT3p+vu78oN1b2Coq0EwAqvKk53sZZ2lRQ==
X-ME-Sender: <xms:ROSZagYsobD3c2h-Wdl89NMeq7pW8NXhglXCCKifbju_BNPJNW2pdQ>
    <xme:ROSZap0zJh7rmWadvXuee5SbWOJ26ZG-pEfGHhTLKo453_ri4jc1oicKGEe4FwsxC
    6_jK6bZKRpNmSGb6SAw8p-4ONFLDkUfwyfGunihJ7mT4DKbX2V9UKdErg>
X-ME-Received: <xmr:ROSZaiGPy-Kk1Tc6ZejicntQeSEiBWSA4zgSf2QV719CnwdtrLGGKO3cCdA>
X-ME-Proxy-Cause: dmFkZTGWigpzmqyNitv9uTrA95IFMdWwGGI+6KZ2VVuNnzRvIZsn+TK1jFAGEicXuZi9Fp
    gbjJlgSD454klJuCw6LuID91eg85v+tMqoS8HqcgIHD/POYyHZkp/Y81BY4mgMKHSq/nEq
    lMZnm/7plL33kQ5/zwiPoew57IMfLMJoPmyCqQWBSu50XV/W58V7YZyrOgDt79AOJKoVk2
    yE0kH2F5YlLH8hGjt/74wtuQ+f1HG0IddTaxUqkd70lEiCOQXcpq+K1xwhLoNiL6Q04fj1
    iNh/8ip0Jr6ZQOXZ26pNHPEf7dA5CPzflnKYQmRIEICzXQu2QLGGYRpKnxizXY8ZopdMqV
    OT4AaxPctccLpPdNEEl1CfqNQm7lV6SBK3S1wvLNMA0TVJUCFXKvIW7Wg/erHe59VbwS1v
    AigM7FUGg0r1denPnQ7Fz5xeh4Wqbw39jffn3NHwbZb38VMoNh2P73RFfWGZ+bx9FPN3Cd
    FhHM/ogmP4MEoclyGTk8qrXmqSXTSN6jX8x2Rnw4GDY5Z9BkdqyuyDkF7HvYwocy4vdv8T
    +S+9EYlb86i8i1d9fn1jvyWziYDd40P6i/2p1SNBYpkp9Y4MYfjQ/9VaH3KXXZNp4jjjr4
    YU7h36T1KQGZBhwDW/T+IQKpz/dO8AUaLvqs9jLlMP2BxYYGl7P1PVFTy1wA
X-ME-Proxy: <xmx:ROSZauNL6rWsY1CL01y1Y_GyPAB3C8IU4O5tv8CkIYwSSz0iJ0T_iw>
    <xmx:ROSZavBdGOal3ndBo3Lgm3UHgKp5dBe1J72GuoDcpvQK58uYXceFfA>
    <xmx:ROSZalxUp2DruySNPqnVYhT9Apl2KORHoSkSNQD3N6d6kxRY4kuzBg>
    <xmx:ROSZajdGCISGV2C1wF07tjd3fqeqDBoW1d90RuwE5PkmaMCSbpprUA>
    <xmx:ROSZaqjqMWUhDWeQ7ym4WLZ4TUWodn2ThDaEnrubTS-psg-s4iunu5Mw>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 3 Sep 2026 17:18:59 -0400 (EDT)
Date: Thu, 3 Sep 2026 22:18:58 +0100
From: Kiryl Shutsemau <kirill@shutemov.name>
To: Pedro Falcato <pfalcato@suse.de>
Cc: akpm@linux-foundation.org, 
	"Matthew Wilcox (Oracle)" <willy@infradead.org>, David Hildenbrand <david@kernel.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Jan Kara <jack@suse.cz>, 
	Rik van Riel <riel@surriel.com>, Harry Yoo <harry@kernel.org>, Lance Yang <lance.yang@linux.dev>, 
	Jann Horn <jannh@google.com>, Alexander Viro <viro@zeniv.linux.org.uk>, 
	Christian Brauner <brauner@kernel.org>, "Darrick J. Wong" <djwong@kernel.org>, 
	Carlos Maiolino <cem@kernel.org>, Usama Arif <usama.arif@linux.dev>, linux-mm@kvack.org, 
	linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	kernel-team@meta.com
Subject: Re: [RFC PATCH 0/5] mm: sub-folio dirty tracking for PTE-mapped mmap
 writes
Message-ID: <apngWgs4OAVFij_7@thinkstation>
References: <20260903182943.662461-1-kirill@shutemov.name>
 <apnO6MyHhCilamqJ@pedro-suse.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <apnO6MyHhCilamqJ@pedro-suse.lan>
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 4DE14A0005
X-Stat-Signature: akot9u5cs8yhfpcj4gaxdoq3bikot3ch
X-HE-Tag: 1788470341-63784
X-HE-Meta: U2FsdGVkX1/N0x4QnMkPTLd2r4Tp3uM2FB32I9UWEuA5cyJHcDiSgbJEA1YINtkReZdnEGQPZTDiIeqqSsQjWR4NAdAAhW6DBYUBrkH9hdJgBD5irlLEXu4scyUqiLk89io/TcbW2I2mzopon55ciyoxRuR2y85CqSyMX2WCo/OhmmKWSgm4wzMOVXbycnCuJ5t46f1SbLAXU8hUJsPgkLdPsOwcMCmChfPzI1qU3NaxKNUEA7nauDh6CnXjXmi0t5ne4cKko1/1IgjR7nqKpywGei0ShFUiRYRfD+IIcdpBp0MWvL1fXsR4b6PAbQwAsHDlFAGRKMVaKjBYeuH0T1DskAJhkNP6eRbtvrJLJkKYoeWHDN+Fnbla/55DKFFwyGgcAbvGm1Z879MFTqdHSqyA2czOmpF+aWNyCXxS//kD+FsCQsgKfkPRHeFAG5ED914ZpQvp27bJKl1MQU99yiKNRwXaJ8ZtK0EBKoCHcF6C48cUPf0j9qmdleQwukZ44wK+hHAqZjrqV62hAYmUBBib9tqDHgkIyV8Wl9baC1ZwixvXG5f+Up76Z46YoD3JWGaUidio73gKJVFUA9jnj1/NXJIqAEiV8vxpFqK2W744e3Fdf64nxZfxzE41FDzfwOQqj+fuYvbWGgLR9DFgQJuehGff2if5R6pJYhwHQWBsgmSToglfTkkHNXlqgfy8E2WxN2qYVecFZdS0ZzKAF6T0NwqUxGRBkU6UXvLLu2N4gReTMETjuxe4TlcLTHmwBjJ2sXRrb7gI4IaXL60W/CNnasBms2A1P6GkbY7zLh89SN1PltjcJoOgjQvDZ6SYE1rJ+swX1x3AZl+H/CC76QMv7zDhWHYaQ8WdZ1Tm8ZThDTJarokkjULeJVF4HeBYJyEAtdDGUaySMOWRRgOiC20xwAfK3t7OSsaVCoUlIjOqWN84nk3EDy6jN/+Tn6N7RPSZWPa6vvYdZPc2VQ0
 015GF6gv
 wxjhMSK4kvIVDKPzgGMICQl2L1/LiJV3febATssAngWqoUM+LFRBrOrElChumgEWX63H/JVnxvYRMZhtb302QxXOEb76sZWwC6Qshdp6fzmM40Lu62ONqOBhd2e+kyTfQJWhoeGuUjqL5/K22yYO5zNnZeCdzhmvt2FOGYwiClsEU5USZkP+60HScAaCkHmVqhh3yUvL1I2SjI3ZBRY4vjBSpXiYgVPOKiMLEmDMznCgOSb5ApLyipiXfyyjPsBXH7SNOlKXRPy1CgMSQULJSCA6OwsxSxnAnDDnujzf0mF90SnS0SluJ/cFnewXvwj8xi4zSsFqqVotINMBwUD65VsRwrx8FwXDJlAWT2yv3Z+xpAjFg+cZJHaUZB5IjGj0yT2NbTzZLNLOrRqlib0X3KU55YI641jhU3UY1r6YpoxPCRDTcfnjXUupyAfv5CBbaFHY7
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Sep 03, 2026 at 08:55:36PM +0100, Pedro Falcato wrote:
> On Thu, Sep 03, 2026 at 07:29:38PM +0100, Kiryl Shutsemau wrote:
> > Narrowing the dirtying at page_mkwrite() time does not work on its own:
> > set_pte_range() batch-maps a whole folio writable on the first shared
> > write fault, so the stores that follow never fault and never reach the
> > filesystem.
> 
> Help me out here: in which case does this happen? page fault handling is a
> mess... I think page_mkwrite is always called, no? in do_shared_fault().

It is always called, but once per folio, not once per page. It is the
filesystem's chance to preallocate whatever it needs to track dirty
state for the *folio*.

Later finish_fault() maps the folio. It tries to map it fully when it
can, so a write fault creates up to 512 writable PTEs on x86. And we
really do need to map the folio fully whenever we can. Otherwise we
significantly undercount mlocked memory. See commit 19773df031bc
("mm/fault: try to map the entire file folio in finish_fault()").

And once the whole folio is mapped with writable PTEs we cannot narrow
the dirtying to a subset of pages. Any of them can turn dirty at any
time, with nothing to record it.

-- 
  Kiryl Shutsemau / Kirill A. Shutemov


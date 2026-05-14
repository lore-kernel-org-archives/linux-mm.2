Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 623C0CD4851
	for <linux-mm@archiver.kernel.org>; Thu, 14 May 2026 07:56:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B2EA56B008A; Thu, 14 May 2026 03:56:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B06FC6B008C; Thu, 14 May 2026 03:56:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A1D486B0092; Thu, 14 May 2026 03:56:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 95CDE6B008A
	for <linux-mm@kvack.org>; Thu, 14 May 2026 03:56:44 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 3B209140559
	for <linux-mm@kvack.org>; Thu, 14 May 2026 07:56:44 +0000 (UTC)
X-FDA: 84765268728.19.1E25F05
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf01.hostedemail.com (Postfix) with ESMTP id 136EC4000D
	for <linux-mm@kvack.org>; Thu, 14 May 2026 07:56:41 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b="x/Erx4Nf";
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=TtIDAUXw;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=tMaeTE1G;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=9xp7FAK6;
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (imf01.hostedemail.com: domain of osalvador@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=osalvador@suse.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778745402; a=rsa-sha256;
	cv=none;
	b=mPBF4QDhDF5EZj7fxrLhoI3yD5GN1uDVGRQzY5xTOHrVLk9fEDaQ7Yq//tiXtiMUU1yzg6
	RNL+5RMY+YHq16JbLN0zGYFRgsdTCjRj3AkJCDNnpyOSSCf4ucRpWK7Kk/rJ7QRzvIMypL
	uHmcBiBSKYlfv0fVNor33m6NPxSkf78=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b="x/Erx4Nf";
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=TtIDAUXw;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=tMaeTE1G;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=9xp7FAK6;
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (imf01.hostedemail.com: domain of osalvador@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=osalvador@suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778745402;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HwFSQfDMERUWUOQUggcVf3A37PosV5rvk/rTsK4+J9I=;
	b=cnrszPLENZIbyPTCKyqZQ1lgRsL5FE44iGB6gDPUMXuq0KBHNjxjPxewD4LpDTDkWfINns
	4OQIXQfYjjtkuEt2Bg5dBe/E1E7d0qiNGzjdFa+tYzCu9KxIfXmys48E5kp3BLC6QwcI26
	4076RhdvTZW/lKZ1su32Dt0CxUX+FcQ=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 99FA567268;
	Thu, 14 May 2026 07:56:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1778745400; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=HwFSQfDMERUWUOQUggcVf3A37PosV5rvk/rTsK4+J9I=;
	b=x/Erx4NfTcSQmE++lS/rrpLvevnL6hKmyXFkXCGeayIxwLjHWwwX2McagtqjNTb3YugtO2
	fDDD+dVjx2/ZpzqBrh70SWeCTtC+cCVZ08KCDTXS8sSUo35IDRInjmppj4F350fopUsA2+
	sW11erwwMBSpZZ1PeXkJhV0EqvWLWVY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1778745400;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=HwFSQfDMERUWUOQUggcVf3A37PosV5rvk/rTsK4+J9I=;
	b=TtIDAUXwuhJFQ9RVUdwnnLdHZh9f/tX90eoRTZvjOqadw2+Gq6IiVFVUdvggEFdrpWmr39
	ixkaEFSsLj4Ab6BA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1778745399; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=HwFSQfDMERUWUOQUggcVf3A37PosV5rvk/rTsK4+J9I=;
	b=tMaeTE1G2wmNettriYEUN+3VtxUt46taiJjVvnpojK7t+/I7V6l0gW9OSFna2xPovLgLK+
	KR/EBBqeUuOFO83iCGMHF/ExytlvZe5KFI8h6tPOpL/R7pLLXF6TTCZa05auq3MCTYPZM7
	woSqnKntB0IyZbX47+1TvXQblkuZYu8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1778745399;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=HwFSQfDMERUWUOQUggcVf3A37PosV5rvk/rTsK4+J9I=;
	b=9xp7FAK6lpGh4FznFoaMpPoctBt32DI1ci1gPtYSNBvJW83BIbcC1xrAO86EVk+nh5MVFj
	8nx4wdp4/toVdrDg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 8D562593A9;
	Thu, 14 May 2026 07:56:38 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id DDAPHzaABWqICgAAD6G6ig
	(envelope-from <osalvador@suse.de>); Thu, 14 May 2026 07:56:38 +0000
Date: Thu, 14 May 2026 09:56:37 +0200
From: Oscar Salvador <osalvador@suse.de>
To: Muchun Song <songmuchun@bytedance.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Muchun Song <muchun.song@linux.dev>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, Nicholas Piggin <npiggin@gmail.com>,
	Christophe Leroy <chleroy@kernel.org>,
	Ackerley Tng <ackerleytng@google.com>,
	Frank van der Linden <fvdl@google.com>, aneesh.kumar@linux.ibm.com,
	joao.m.martins@oracle.com, linux-mm@kvack.org,
	linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 02/69] mm/hugetlb_vmemmap: Fix
 __hugetlb_vmemmap_optimize_folios()
Message-ID: <agWANe6i5gsfXFgP@localhost.localdomain>
References: <20260513130542.35604-1-songmuchun@bytedance.com>
 <20260513130542.35604-3-songmuchun@bytedance.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260513130542.35604-3-songmuchun@bytedance.com>
X-Stat-Signature: dt5j936z3dagwz4t9wmg9zaswuwfidok
X-Rspam-User: 
X-Rspamd-Queue-Id: 136EC4000D
X-Rspamd-Server: rspam07
X-HE-Tag: 1778745401-673194
X-HE-Meta: U2FsdGVkX1/+aKk2UtoWswu6QtobsnOiiQMbGZVry2MflaT++GW23i5k7kDAyUtOve00icsZIILUvll04/SRHRqUQ1oNsUAppa2/97qUbr4R4puCjmsETO1uWdXGrsKStrMM1qtvKfZldD8C+AoMQUFFRqI0tabDrW3QkFsRiRJb6fvwqYuwu9yVi4EHNXgZ5oo21YUsk053GxrXB5AAm9Qo0zzTlxUF0a3Elfh3V4OdWttbqWV6+zJBGpErbWzQhV4l78zKhjWKB+O75/+nj5RJcx5dpxEWcZOWoYIwRtJ9M7RJwP3A6H/bJ7kRMuwLrXjj67T/VNqvIflm1mldrpnYEl3uA/nudUol/ACWQ+SunDxTb0Sf/mNJsv6UJgD7w2U9fs5T0KYd31Uj+2bl3MjYkeTfi3UO28tGtsL9pS/KUxcyrKLhzMeYrIj4ukvJS9POv2AUB8vAWqqWXV+5+Z5ma3MCiAFCb9RTuVpALzzmHj1UlHy7/FqTcUQkRSX3zrpRZUccP9NUZy/hqH0s7ie+/AhCRk65TR4XlEiYrfOLMUC2u/e+3Yw8/mx5MHYq12r2ahDljrNlJXqyQ+fcmv2bQ2ULoXFPFG3Xs7JUygHgGlkLqkFBn76whQ7MbVuqn9STbXrK661ndfpASwmC14M3upDtSz1fFex7jB1/Eq9dtCOsZo05Kzvb5eQqJAhg8Ya+baRHUs6YoQAs+lzo8J9Ef3Z0nLSIRnc0fxlngTSMsEDUX59+2kheK3uoUz64KoZmunsFP5TILHZsIGpPNJtXAzkc048fXELp9rs9RMFJ+sv3A8SAWlg2BjSZaautRud5ghlHMjfwIqCpkYsAJxtCvE2ySjb6RR4J3uPtEUagopWWWsJCya+PzMNufG6QCigQujT2dFtF2p7ajoB5nJPpwEuEf4gcfTk9HMAPZaIC+Uw4nkXM+GqZSMuyE2yUOzFmY1J4QThZKIY0OZ5
 jY8KWN6b
 tTOtq2rxyWylIFElrghDR11aWWit9OrTomAXGXeD82fbnz9ZNUJZAXwwWEtKAyDK5VmydIVrz1PY9jZYd5ixuQb8WKvL4xXhvW78ZKvnOJhDovYxWcqawJX/2KcmDhCqnielKcKm1lMbZSstWbijfqPxJdK3VTHpnKDuuo/P4XlWH+v9OR3Dkvt4OjQTsY4bJPPk/zkfUAJlsFDJGy8RMXaZW55xbCDMPMZ8XY4brYacvn4dC35ObNK6CvO2/7e3yklEZUr/yO84IAbB6+2EDth7Fu6yOXraO9m7rlHL9gArHCsU8TY91cx92s/qrK4/B+p6eO70d6tx6fCI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, May 13, 2026 at 09:04:30PM +0800, Muchun Song wrote:
> __hugetlb_vmemmap_optimize_folios() uses incorrect arguments when handling
> bootmem HugeTLB folios.
> 
> The section number passed to register_page_bootmem_memmap() is derived from
> the vmemmap virtual address of folio->page instead of the folio PFN, so the
> bootmem memmap metadata can be registered against the wrong section. The
> helper is also given HUGETLB_VMEMMAP_RESERVE_SIZE even though it expects a
> page count, not a size in bytes. In addition, the write-protect range is
> based on pages_per_huge_page(h), which does not cover the full HugeTLB
> vmemmap area and can leave part of the shared tail vmemmap mapping writable.
> 
> Fix the section lookup to use folio_pfn(folio), use
> HUGETLB_VMEMMAP_RESERVE_PAGES when registering the reserved memmap pages, and
> use hugetlb_vmemmap_size(h) for the write-protect range.
> 
> Fixes: 752fe17af693 ("mm/hugetlb: add pre-HVO framework")
> Signed-off-by: Muchun Song <songmuchun@bytedance.com>

Acked-by: Oscar Salvador <osalvador@suse.de>

did you observe any Ooops or malfunctioning or was just code reviewing?

 

-- 
Oscar Salvador
SUSE Labs


Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 10A43CD4F25
	for <linux-mm@archiver.kernel.org>; Thu, 14 May 2026 08:00:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 42F926B0088; Thu, 14 May 2026 04:00:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3B9B06B008C; Thu, 14 May 2026 04:00:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 259426B0092; Thu, 14 May 2026 04:00:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 0FBA56B0088
	for <linux-mm@kvack.org>; Thu, 14 May 2026 04:00:24 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id A369F40522
	for <linux-mm@kvack.org>; Thu, 14 May 2026 08:00:23 +0000 (UTC)
X-FDA: 84765277926.08.9CB6B98
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf19.hostedemail.com (Postfix) with ESMTP id 289B41A0012
	for <linux-mm@kvack.org>; Thu, 14 May 2026 08:00:20 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=CJLjzcwG;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=C4248gcx;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=CJLjzcwG;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=C4248gcx;
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (imf19.hostedemail.com: domain of osalvador@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=osalvador@suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778745621;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0ApyV1SJgz5wtbwoXbn/VnkSAGGIM5s57P85+2beKro=;
	b=HWEujhqewAWM539VnlUdmL3RUhyyLNITtXiFX8LTulwJoEQUTGzRKBpYoDWLSA16RvkCQA
	QZcgm26cAHX0qRckHhHBDEgrHZZfFrLNvizZgARmn8X5O8yt6JEe25TyGSndHXLEV5uVyD
	BsPgnzzcjPYlqP/1o7wSoySoqLeIdJg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778745621; a=rsa-sha256;
	cv=none;
	b=c8ntTilxt0FKSgd4LJoH9mfmjBYzk0uOr3Mjtu0+p45ZQA4zq0ny5q8GUvjymLQUiROiHe
	S6EM87DFr5a1/L6ZLUuVnfK583zOBIPxbHwGAskSoij2/XNR8iRTg5jQxebRID2gsKLqKY
	WoFbyof8jEbLfE4h081yGW/QEU1kJbU=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=CJLjzcwG;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=C4248gcx;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=CJLjzcwG;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=C4248gcx;
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (imf19.hostedemail.com: domain of osalvador@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=osalvador@suse.de
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id B0A575E0B4;
	Thu, 14 May 2026 08:00:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1778745619; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=0ApyV1SJgz5wtbwoXbn/VnkSAGGIM5s57P85+2beKro=;
	b=CJLjzcwGlCsOVB9un6xLW22kKcw6V4Xlum6RMNosJGw32EAzNkqaZ0dXBputXg8joCGJh5
	ZC1jpkQXSTxpbM6WBhRM4oeLo+fYzd66yI5ebrozqIG9PAWcPh+1jwQnrrgvtShLJAV6m0
	iztuO6FRDH7X+dSyQAMxzhaR+0Yiy8k=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1778745619;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=0ApyV1SJgz5wtbwoXbn/VnkSAGGIM5s57P85+2beKro=;
	b=C4248gcxLcOZ45VZ6Xk2Ku4O2ABnN9dD5IGpb7ZAPZEdfu+e2hfvYKSUMmGYh5vpD4fT12
	zLyXzyaJCm0GMMAA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1778745619; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=0ApyV1SJgz5wtbwoXbn/VnkSAGGIM5s57P85+2beKro=;
	b=CJLjzcwGlCsOVB9un6xLW22kKcw6V4Xlum6RMNosJGw32EAzNkqaZ0dXBputXg8joCGJh5
	ZC1jpkQXSTxpbM6WBhRM4oeLo+fYzd66yI5ebrozqIG9PAWcPh+1jwQnrrgvtShLJAV6m0
	iztuO6FRDH7X+dSyQAMxzhaR+0Yiy8k=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1778745619;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=0ApyV1SJgz5wtbwoXbn/VnkSAGGIM5s57P85+2beKro=;
	b=C4248gcxLcOZ45VZ6Xk2Ku4O2ABnN9dD5IGpb7ZAPZEdfu+e2hfvYKSUMmGYh5vpD4fT12
	zLyXzyaJCm0GMMAA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id D86D3593AA;
	Thu, 14 May 2026 08:00:18 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 4xHQMhKBBWr/DQAAD6G6ig
	(envelope-from <osalvador@suse.de>); Thu, 14 May 2026 08:00:18 +0000
Date: Thu, 14 May 2026 10:00:17 +0200
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
Subject: Re: [PATCH v2 03/69] powerpc/mm: Fix wrong addr_pfn tracking in
 compound vmemmap population
Message-ID: <agWBEXHO0EfmOWMV@localhost.localdomain>
References: <20260513130542.35604-1-songmuchun@bytedance.com>
 <20260513130542.35604-4-songmuchun@bytedance.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260513130542.35604-4-songmuchun@bytedance.com>
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 289B41A0012
X-Stat-Signature: b9p9oerop3qkx1p133j1nzbd9etnhqjp
X-Rspam-User: 
X-HE-Tag: 1778745620-47517
X-HE-Meta: U2FsdGVkX18mqFzUrnFmX7MVGU0m/izBum8B5PMShNsri8flViWzJpc8R+sq/YVMJZIA46CFHyqDyImBXhhuPbP8HQ9ErQa2CMHr526s9xNlvKMrIh3ZbEmOPrp/DRDqcBChX5BEd/tHeS8fQH3dbproSfVHt+LKmwzACwCUnWA5v2r+K4wuc54FfBU6zHGHmTGFuvYV9CsBweCag7ozoKdLK0TympxtnYMujsXADVLos1lHGfwckvO+GRUvztHXV/rYjVBdyKzxjdJINHHt/fOYKcLz4Jf9f8PkdIZC/mVV43eBB1GRZp+vTDRgxEhw7LqeLHtPE2SDftEoP3X8wBrbwsvE/9gmxZond11hKX7sMnzeOPacEsXBOWg60BwwAX5THOTDwqzYJbckrNO2WWkL1VPQF5/pIIDuJYMg8boXck0jwOBtlg0TYN7oV8R90LgJs5KJN+5jySVNBMUnPbp3vPXcF3fn/B2KkP2TZ4Te6EIMt8k/Tn8SwppRJwIAMNEj7Bhzd8/5e2OmbwoYXNb2/8Pj+tiAzd40GK6UVi2BNKVlxOJTB/8l/6lDejdidsS5uv/Tn1D98qJ+99Fv6K6+CoesjYZHCH//wEuJace4hE0/FM/pd4gSfrgvVGKdOiMTLlbhjijG8dNZydopB3S3LN88kEyiaFFUUfiL6W+wbaU8Dnz3CvuU4FYkksh3K5kIBI5CL3QuaneCWjU+1WFcPa0jNMS5naFrhLjR9dte0wq4i9pmuZWFVVOOtulz8/MUzQFBm04uwVULHg4gMZNrZtNLbLrgYx9WK3hH/J7p06yQoKxkAQ04o5PXogfZFSAcMvlYYtrjFInP3h4tlRanjv4wPUHM0zqwrjQgUn+FuWf3kX1oVVhhF7B345wI3czgFAxpzOlKklHzC9AEe89JSJldH06CigjEQFxDmp/M9/JhGRfBLIJbIG1Zq0a8K6vdEzYdpSXVfX6E+8b
 CC/9RrHq
 wrjwU9xWXTAFc69y8AP5q+b8EsMErodr6/49JE+TdgZOtCSiD3vcOuvCytKTDpz7p3Km2e5u5XwRGZMZE6oIRQKV2zTcT3oLY9pGxCrK9rHyssNoljVszmyaJqsEKNIqzsVGOsB6DHIueJRxzXssQQ4zb5sEFacUHkHW3XzsjjrBbJhIIERsyaFsxWdB8Kd+EmZVC+n2zBeeOGdItwzV5dHpp6qBMzZnO/o8ltiaJcE0xmlqgoWWpG/y8MTxdzxxS3zExLFODwz8OsJYsiX9e0gTrFLdSr8zeAAYODuTdYnHRv2dNr5HYdkKlCBT4CmmxBlklQovSdENt7VE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, May 13, 2026 at 09:04:31PM +0800, Muchun Song wrote:
> vmemmap_populate_compound_pages() uses addr_pfn to determine the PFN
> offset within a compound page and to decide whether the current
> vmemmap slot should be populated as a head page mapping or should reuse
> a tail page mapping.
> 
> However, addr_pfn is advanced manually in parallel with addr.  The loop
> itself progresses in vmemmap address space, so each PAGE_SIZE step in
> addr covers PAGE_SIZE / sizeof(struct page) struct page slots.  Since
> addr_pfn is compared against nr_pages in data-PFN units, it should
> advance by the same number of PFNs.  The existing manual increments do
> not match that and therefore do not reliably track the PFN
> corresponding to the current addr.
> 
> As a result, pfn_offset can be computed from the wrong PFN and the code
> can make the head/tail decision for the wrong compound-page position.
> 
> Fix this by deriving addr_pfn directly from the current vmemmap address
> instead of carrying it as loop state.
> 
> Fixes: f2b79c0d7968 ("powerpc/book3s64/radix: add support for vmemmap optimization for radix")
> Signed-off-by: Muchun Song <songmuchun@bytedance.com>

Acked-by: Oscar Salvador <osalvador@suse.de>

 

-- 
Oscar Salvador
SUSE Labs


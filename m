Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 34791FF8867
	for <linux-mm@archiver.kernel.org>; Wed, 29 Apr 2026 06:54:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 71A056B008A; Wed, 29 Apr 2026 02:54:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6C9FD6B008C; Wed, 29 Apr 2026 02:54:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5B9606B0092; Wed, 29 Apr 2026 02:54:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 4AEE46B008A
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 02:54:26 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 09A8A8C232
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 06:54:26 +0000 (UTC)
X-FDA: 84710679732.13.460B33A
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf16.hostedemail.com (Postfix) with ESMTP id 5D6A718000A
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 06:54:24 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=QjYezp2W;
	spf=pass (imf16.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777445664;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+WbTYahkZU0z2sUJhpTIXGrpScOFWXUM7R/pGUhO8u0=;
	b=SY0OXhWWmujzELLQgSj7WuFxgpNxYa7HgTZqUFqKfUni8udMCpcGnS0Cg8/XwLzbAlS2YR
	fwXalilDtFcBmjuEqILfZ+kFhi1hn7EgVtzFQE6x+3MpEf+b3aNoGgfrM3R4oKkpqcSM45
	/QDg3A5kNuXHc6vzjn/w3kKXuP2FY6s=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777445664; a=rsa-sha256;
	cv=none;
	b=gpslJm+Nltc6KBC+uhe1drHoEzIaocuF53sAq0D0hcdi4/RlorcKFijVQtq+u8ZCR2Q8YL
	NHEg1EsLLzesquXuwxv2NlgPxuhukzgLQrS1NVeT5YV8y/8hyUklNB9fMhT1TUmolvDB9K
	c98WkmhhRaX1Ecrldl4jI//tjY+lOjU=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=QjYezp2W;
	spf=pass (imf16.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 89DAF60583;
	Wed, 29 Apr 2026 06:54:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3CC19C19425;
	Wed, 29 Apr 2026 06:54:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777445663;
	bh=VZhtBpxtU8HwWnxxe7mElHzRTUbl86uTSwoh/+EFdzI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=QjYezp2WABk/jL3hRnX8uE/19RtCgpxR/18bX0qbACdrN/vPKi9wmghBVgVkeuWT/
	 otyKR5y0W7LUENnkCNaLS0Q5nP+qdpr2oHThPhrcsIwdPc813ychE4gYb8ty6jTyOj
	 377di99Rd/I+crzDzejN9wS+Xb8qJvJXFBxigPqEpPhR5VfsksF43m6a7TQXKsH9Ji
	 3/906mdHOKcTMJDMgTKF8SjUVa3IUg5+1/lecu5Cel1eiMVkfoc4DEOJMAJTgF9TvD
	 TDEnySeBIEbY9lUAbCWopWghVONqeUtpXbkvfE8+MpJl626rRTUpPPSIWzDdzwxzNj
	 KaxcWyxQWLGCA==
Date: Wed, 29 Apr 2026 08:54:13 +0200
From: Mike Rapoport <rppt@kernel.org>
To: Muchun Song <muchun.song@linux.dev>
Cc: Muchun Song <songmuchun@bytedance.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Oscar Salvador <osalvador@suse.de>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, Nicholas Piggin <npiggin@gmail.com>,
	Christophe Leroy <chleroy@kernel.org>, aneesh.kumar@linux.ibm.com,
	joao.m.martins@oracle.com, linux-mm@kvack.org,
	linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 10/49] mm: move subsection_map_init() into sparse_init()
Message-ID: <afGrFUXRRONMhFgB@kernel.org>
References: <20260405125240.2558577-1-songmuchun@bytedance.com>
 <20260405125240.2558577-11-songmuchun@bytedance.com>
 <afBcckUTQt-7xPPN@kernel.org>
 <DFB372BA-A262-4507-9280-7C0072280CC4@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DFB372BA-A262-4507-9280-7C0072280CC4@linux.dev>
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 5D6A718000A
X-Stat-Signature: qq7ydp7w4rj5ztgmwbfax9wki6eq7im7
X-Rspam-User: 
X-HE-Tag: 1777445664-183197
X-HE-Meta: U2FsdGVkX18xs0RbYYcJnzQ0PV36Qa3Xouua8l/qbgh47fRBYbOQ9cuC2cnpXL6KQFKjIvU6++ecuSaxUUaIeBHmxIVlfroi4eC8dYkiwU8ypvAV9hTD1V7efHDTLOw4BAzb6lm0K+GHYW4MN5Y5lX+K+zqiMlj+PKFDLMgQ2gFt6koEY0is7pnNP/KN83jsKyGYwYGei4+/HVoiMPImdbyj5gNMEKASe8cCEZLX+PH9WYjE4LfeN+M2wknHHwEJ5FCNjNOIuWGzAlwU0aCVl22T4JoyKdPwo+7+nJox3Dcym4TVi/fKOeKLrUvSveHUhLqXBdgYeOWVp8w/hchiDNosUXDDwZSxUE3bqm8O1IpWLCmPif3AjdYuTd5XBD+ISh4sO1ByBYj5OM1kNhyQwfejPOeXTuqiQAYNtfY4ULnQwFt1gkPNxXuYGYfW4S5GbUrRRZVlb7z34QF9yd6bgz9i2QjwqKdL06ss2lYcjiB9dG13q9lxvXU9bcp1lVS5xCHh8Xvgddr6nrn/h4Jd2f8LxmD0ntVTVHs4+uy/X7BtXgcE/zh/ohTAH14kOBNqNF9Y1KJiqpyBEf5KlYIOPnVJdOay+HuV+ya5dkhuFqfgnCU5vdAQfjN2/GTsmE8P6eOIk+ZFCQO3rptWcRXF9S1n1ILYRCCciP38n92TNdQGyjnPs9x/ClgfWEvQGG2Uu1sJNbZ0F4Wi1OCPYgNriPOKwPbtb7x5ZUq5fzPvioSKFmahCAQ4qoSKe/iQGmAitmjMUE9Tti5iP6IBg2dbGmXnrbBKxYSFyaBiOL3W4qMnouvG+4Z6BjcMB80OneNKdH842DIXU+qxQr22AWEQeSWtovoOLcuhiFSTG0dwE6gmPKXOfxsazgB000d2VdxMUHFvDVk+Lfku2SulidiDtIo45lxGd0JECiwVZLGzohV6qGcK5uk8NPVTZ8O3KynnwQEpCdPsuZ4oHEa85fT
 Yctsn/oF
 gTiABuhYOPRj59r7boH3wrnee4n6zoieyt+vWBO4+pJlh9O3aNehvzRDQFAP9HBm9oovq0YHR2AEQRRJ0euaa2Psz6WQo/XPg/sL9zECwaI0K90HFPHZlyYpHuZxdiCMSnT1VOSC3PIy/ORfx8SpgotVcDoUuG3BoY+0WraaG0FUujtVrHNMmFXyS8VZThbdoiAUHUCjlwRa97bGhBLyeNrGdEpt2UcVAb3QeI+AiM8C0GXd0IcsseLomdgE3xDXzN3XTzI/cz7syUjY31zG3ZK+x/CWcZ2hgrxT8q2vegKetGF2Du2FNm2uG6u25TdRthe57N/7CGcHGgZWfA9G8J04qa+iwyFMwWwbf
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Apr 29, 2026 at 11:06:15AM +0800, Muchun Song wrote:
> 
> 
> > On Apr 28, 2026, at 15:06, Mike Rapoport <rppt@kernel.org> wrote:
> > 
> > On Sun, Apr 05, 2026 at 08:52:01PM +0800, Muchun Song wrote:
> >> Move the initialization of the subsection map from free_area_init()
> >> into sparse_init(). This encapsulates the logic within the sparse
> >> memory initialization code.
> >> 
> >> Signed-off-by: Muchun Song <songmuchun@bytedance.com>
> > 
> > Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> 
> Thanks.
> 
> > 
> >> ---
> >> mm/internal.h       |  5 ++---
> >> mm/mm_init.c        | 10 ++--------
> >> mm/sparse-vmemmap.c | 11 ++++++++++-
> >> mm/sparse.c         |  1 +
> >> 4 files changed, 15 insertions(+), 12 deletions(-)
> >> 
> >> diff --git a/mm/internal.h b/mm/internal.h
> >> index edb1c04d0617..d70075d0e788 100644
> >> --- a/mm/internal.h
> >> +++ b/mm/internal.h
> >> @@ -1004,10 +1004,9 @@ static inline void sparse_init(void) {}
> >>  * mm/sparse-vmemmap.c
> >>  */
> >> #ifdef CONFIG_SPARSEMEM_VMEMMAP
> >> -void sparse_init_subsection_map(unsigned long pfn, unsigned long nr_pages);
> >> +void sparse_init_subsection_map(void);
> >> #else
> >> -static inline void sparse_init_subsection_map(unsigned long pfn,
> >> - 	unsigned long nr_pages)
> >> +static inline void sparse_init_subsection_map(void)
> >> {
> >> }
> >> #endif /* CONFIG_SPARSEMEM_VMEMMAP */
> > 
> > I side note: we might want to split out mm/sparse.h and also move some
> > declarations from include/linux/mmzone.h there.
> 
> I think we can do that in a separate series for cleanup only.

Sure, that's what I meant too.
 
> Thanks.
> 
> 

-- 
Sincerely yours,
Mike.


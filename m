Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E2D75FF8860
	for <linux-mm@archiver.kernel.org>; Mon, 27 Apr 2026 14:50:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4E9A86B0093; Mon, 27 Apr 2026 10:50:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3FE026B0095; Mon, 27 Apr 2026 10:50:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 250486B0096; Mon, 27 Apr 2026 10:50:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 075476B0093
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 10:50:25 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id A016FC142D
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 14:43:43 +0000 (UTC)
X-FDA: 84704604726.12.1B01623
Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	by imf02.hostedemail.com (Postfix) with ESMTP id EE48F80006
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 14:43:41 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b="BLOa/aPa";
	dmarc=pass (policy=none) header.from=debian.org;
	spf=none (imf02.hostedemail.com: domain of leitao@debian.org has no SPF policy when checking 82.195.75.108) smtp.mailfrom=leitao@debian.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777301022;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=f4zHSFMRCDIOzJvASvG53//nYdaZVKmO6GM9qNfqLSI=;
	b=AfYYzVB4OZbvbaBfV0dVRMi+nWQeHIF/xIB3YogqlRuuZhDHAvDt7OTc7eTBeF9d5t//A3
	pr+b2nuhIXaJ9Qn4PuK9Dk155D9wpyUzgCs1rNN9D1tYY6I5tVUbaD8WNiGTL8IU9j+kck
	4dG/ATZRnto17e4P2/4YaysHGCMGSMQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777301022; a=rsa-sha256;
	cv=none;
	b=OKmQlNOKv+Bbqq4kdi7wY8Nw2yxnbylJqE+fqhklqU+HDKgnygIbyFM4ONOvDlf+76S1ta
	63GIL73X/m02EQ50YPUgcwMW43u4pHCAs7WxHMZMxoXxoP7RyTDrotVRDosHliAR2a0NcM
	KvXUA4/OoEu4zpSCXLIR2Fuoy72vGIo=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b="BLOa/aPa";
	dmarc=pass (policy=none) header.from=debian.org;
	spf=none (imf02.hostedemail.com: domain of leitao@debian.org has no SPF policy when checking 82.195.75.108) smtp.mailfrom=leitao@debian.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=f4zHSFMRCDIOzJvASvG53//nYdaZVKmO6GM9qNfqLSI=; b=BLOa/aPa6STWM/QAkpwF2fJs0q
	0JjOWwgFJWIw6s+11hZ1BJRkwezP6zIglOWogLDCNZz7Qj+rbjP0xEUUpOt7qKQC8nps51h+KmpKc
	aLL7UWtNr4yLW/D1e7ISuAmjj1a5leMJH9bgiDjTVNJICALMGV2OdhZDWGzSFSemoQupQzAsM/KNS
	rGtphBvHvnbEwxDLfIV1d0Tst4GZfA3ecDCE87kaQOvpC9XZoqe62DvymnlyIinez28hlwOxlk28P
	8ssdbmdpsYo9QfLgT6nqWmHpYj/+C0hZagB4IbjhKfI2A4LkXfmdz0vZBv6n+pFpeBQBp6mWDxqgO
	o2UwBOkg==;
Received: from authenticated user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.96)
	(envelope-from <leitao@debian.org>)
	id 1wHNAj-005YIa-39;
	Mon, 27 Apr 2026 14:42:54 +0000
Date: Mon, 27 Apr 2026 07:42:46 -0700
From: Breno Leitao <leitao@debian.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Yoshinori Sato <ysato@users.sourceforge.jp>, Rich Felker <dalias@libc.org>, 
	John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>, Alexei Starovoitov <ast@kernel.org>, 
	Daniel Borkmann <daniel@iogearbox.net>, Andrii Nakryiko <andrii@kernel.org>, 
	Martin KaFai Lau <martin.lau@linux.dev>, Eduard Zingerman <eddyz87@gmail.com>, 
	Kumar Kartikeya Dwivedi <memxor@gmail.com>, Song Liu <song@kernel.org>, 
	Yonghong Song <yonghong.song@linux.dev>, Jiri Olsa <jolsa@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Rik van Riel <riel@surriel.com>, 
	Harry Yoo <harry@kernel.org>, Jann Horn <jannh@google.com>, 
	Matthew Wilcox <willy@infradead.org>, "Liam R. Howlett" <liam@infradead.org>, linux-sh@vger.kernel.org, 
	linux-kernel@vger.kernel.org, bpf@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 3/3] mm: remove page_mapped()
Message-ID: <ae91ogo90bSDFNPC@gmail.com>
References: <20260427-page_mapped-v1-0-e89c3592c74c@kernel.org>
 <20260427-page_mapped-v1-3-e89c3592c74c@kernel.org>
 <20260427062137.48739e6fa6e550f1f0e8ff48@linux-foundation.org>
 <06218a87-8346-40b4-adf4-dc494b5f1293@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <06218a87-8346-40b4-adf4-dc494b5f1293@kernel.org>
X-Debian-User: leitao
X-Rspam-User: 
X-Rspamd-Queue-Id: EE48F80006
X-Rspamd-Server: rspam04
X-Stat-Signature: rsh9zx3czqwk97dwfki49gekwu8zbdb7
X-HE-Tag: 1777301021-444083
X-HE-Meta: U2FsdGVkX1/VBjHYe5b/jmqi9mrGHm95Yt/zrjcec/iRnl8Ys+BIXeGfimT6cy6SJAITa0wUnakBvs778afIsl2vaSNtZlvlvjGXkHoCXKTn6q5MYQAuE12bX783Jyv0lV9RfBeQpmOynOn8GeFBQQbpHyXNkWEeO27Cgc49kXcFFDcUSm08Tk7laMp5g6by67JB7Hg2emIFH+gXBoiFpmUlpjELa7SU2bTdEYhQI0Y7Hfl5ST8MNkPoT2miTjnkA3c81g51v81Y2MrZfHDA2w1MiHiUdZ0C/q1GS4xKzUe93De1cSV0tiuELxr3UfqkEDQAni/jVwYWO0QviNc2EgoZS4HqfUZQ/xWDPnZPBfc4fSHEatz833pp8Rax31IiLr3a7fUzEvNfbfgjWnM/OMKdsi/KN52bE2rqGaNsF99s1VY2o9EIDIWQB+Or2GhT/eJMuulhEHkQ4t8L2Lsy/J5oxoYdQJg/3VnsNsEjuE/zq+vqXMh1wqaOTBi2k37JK9s+x1QuDgWdqx49L/DRiBDNa9rJbbVFC4bBhex9ALAr9Z8hWJ5UakIBkNOcoGOt4Co7jKoFr9m63FYNEpfTXFSf/9EZZTa1AEwq3H4kw9inNYarUxeahuoW10PRDoJqduvKmF+DN9wPkN54kF4TmCMc5mkpk38oxFC/6KS/ARVDeTOrpQejRzm7v9SI+446zBlOawF9gI5i3tH7fxBEFnXVuIpXYxpFQht1iI/hWSOw7i7jFId/gciBOr9XXPUdjjrnkOzz6mSuY43xLltq9fvH6WOElLIKCupMKJI1HFc7QYm1OJi6+ohRd9/uEAsnSJimj1kpg2jUI+OZbwZM/bCb7Wqg6eVLX/Z00cZsaFtCB68nDqvNQSI8gbBgP0AOo0P+kQTIoMv6RYOOZmMhQnqQvpzWlOMEl/Gpg/d3+1bj9gs5vryhE0OxU4UuEsk3mZ7Nz9A6V28C5n2JQSS
 PWRZu5o1
 g05rN9HlQql3LCytCa4XXzvgWf1KJRId0kp9lEfIkDjja9ZFHU/CJN5GgJcbg3wR6VK+edmK6mjny94Ot3H6/b2X2agxY/SHhz3SYaRKmHF1Gu1nSeW0DC2uVqqvaV1RLuoFwPBfYu3OUCLVOySgYhIM+CEaQyoY7h0XDg/ezb24OLvvnvsv0WmkCN5KlnEem/IVOuG++h7a/V6vkCL+UlfvTR9eV7vCvRzgxvLJsPL1j1pV5pj79LUYn4VQs6Psm2snR0YVmeWQZBWqI/UQj3VK3kPu3LhGs/K4b
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello David,

On Mon, Apr 27, 2026 at 03:23:33PM +0200, David Hildenbrand (Arm) wrote:
> On 4/27/26 15:21, Andrew Morton wrote:
> > On Mon, 27 Apr 2026 13:43:16 +0200 "David Hildenbrand (Arm)" <david@kernel.org> wrote:
> > 
> >> Let's replace the last user of page_mapped() by folio_mapped() so we
> >> can get rid of page_mapped().
> >>
> >> Replace the remaining occurrences of page_mapped() in rmap documentation
> >> by folio_mapped().
> > 
> > This broke Breno's "mm/memory-failure: add panic option for
> > unrecoverable pages"
> > (https://lore.kernel.org/20260424-ecc_panic-v5-2-a35f4b50425c@debian.org),
> > which added a new page_mapped() call.  I made the below adjustment to
> > Breno's patch:
> > 
> > --- a/mm/memory-failure.c~mm-memory-failure-add-panic-option-for-unrecoverable-pages-fix
> > +++ a/mm/memory-failure.c
> > @@ -1353,7 +1353,7 @@ static bool panic_on_unrecoverable_mf(un
> >  		cpu_relax();
> >  		return page_count(p) == 0 &&
> >  		       !PageLRU(p) &&
> > -		       !page_mapped(p) &&
> > +		       !folio_mapped(page_folio(p)) &&
> >  		       !page_folio(p)->mapping &&
> 
> If we have a folio, we should really lookup the folio once. Not 4 times.

Why 4 times?

> Breno's patch likely needs some love. :)

Would something like the following give it all the love in the world?

 folio = page_folio(p);
 return page_count(p) == 0 &&
        !PageLRU(p) &&
        !folio_mapped(folio) &&
        !folio->mapping &&
        !is_free_buddy_page(p);

Thanks,
--breno


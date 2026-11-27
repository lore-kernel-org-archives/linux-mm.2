Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 66A97606A321
	for <linux-mm@archiver.kernel.org>; Fri, 27 Nov 2026 13:30:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=U4NKcntY;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=RqNzIgqE;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=BaKocssb;
	dkim=neutral header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=Xle0tI5a
Received: by kanga.kvack.org (Postfix)
	id 5C5366B05B0; Fri, 27 Nov 2026 08:30:29 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 575B96B05B1; Fri, 27 Nov 2026 08:30:29 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 43F296B05B2; Fri, 27 Nov 2026 08:30:29 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id D08FA6B05B0
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 08:30:28 -0500 (EST)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 49EB3C0385
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 13:30:28 +0000 (UTC)
X-FDA: 85480983336.11.81FC35F
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf18.hostedemail.com (Postfix) with ESMTP id 09F5C1C0011
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 13:30:25 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=U4NKcntY;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=RqNzIgqE;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=BaKocssb;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=Xle0tI5a;
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (imf18.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=pfalcato@suse.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795786226;
	b=aP98k3A497FHnaQW436ek84I/4F3746KjTM+6MjdporhrEFbk5NcjtRHEWEiwz0/E+0cGr
	VvUwYX9mzohpFfxyI1WAvBUBLHF0xL5SpTbhrzPCwhA+gPO/hzT+L5JMEUK9QQYGCAuKn8
	iw/bgb1b55Ei8excBRv1+1sIfU/dQRU=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795786226;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=H0Jql31Gwg5cy7/8LbYEz5eBl7mNTW69sIgrCB0NofA=;
	b=NnGZw6sRSyt6uU6Gkd2GNfgtIsyuQDgpHbm6WVWUS/LGk1wqbIGpbnHPdYEOlSYhi7/Uhn
	fFGZaRzKOyDI4Mu++7gLNjBEL9x2fNB8qDQTl4YUqE8nlCX8E28lPa6leDLiGtmdd+vfEG
	vw8ZzF2V9oELLcAea8i+xXwEJUpJEQw=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=U4NKcntY;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=RqNzIgqE;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=BaKocssb;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=Xle0tI5a;
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (imf18.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=pfalcato@suse.de
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 196091FF00;
	Fri, 27 Nov 2026 13:30:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1795786224; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=H0Jql31Gwg5cy7/8LbYEz5eBl7mNTW69sIgrCB0NofA=;
	b=U4NKcntY06TBTWk+IHhUJ5kuPFeYKqhQbotvPIvQDYGH9MOMGFHRDnJYoKotITYl6WNX8B
	ADY9SpBKRNCnkm3qO1VXyXeoKWuk9CpKUnFOFRfugKMdDHkLnrJyfGe0L2b+HYxAHdgWf2
	vEYSrDuzhHNz01IfDskcmsI3c1RRvtU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1795786224;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=H0Jql31Gwg5cy7/8LbYEz5eBl7mNTW69sIgrCB0NofA=;
	b=RqNzIgqEdc7lsUieUicKkHJFxdXdCOpVphPrRXi+ocnzy6PbKtg5JV7ImUXgFYHVde3mm6
	KjZO977JawC+ILAA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1795786223; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=H0Jql31Gwg5cy7/8LbYEz5eBl7mNTW69sIgrCB0NofA=;
	b=BaKocssbOonWoDcnn8ip9+Sy+3PuM4qiaBRWZl83bJBRRpPaLIpqCedCNxV4HMw6JKSuZw
	LywuQm1zwtNJGO2qPDJB1UznC0gIrvcYUdpld63uO73SRAVS4RW+BjrNC6rcvLaAAVf1I9
	TMYeJb/CFGdZIZ2yV/HWT33sMdVDw+c=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1795786223;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=H0Jql31Gwg5cy7/8LbYEz5eBl7mNTW69sIgrCB0NofA=;
	b=Xle0tI5aYu+cWxA+eRC57J7LdJQh7KEJpefFicnS5oKAlZPVJEBHmoewIapk1u1OVITcFD
	78iv9d9bvAR2mwBA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 9931F13432;
	Fri, 27 Nov 2026 13:30:20 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id nO6AGeyFCWsfFwAAD6G6ig
	(envelope-from <pfalcato@suse.de>); Fri, 27 Nov 2026 13:30:20 +0000
Date: Fri, 27 Nov 2026 13:30:18 +0000
From: Pedro Falcato <pfalcato@suse.de>
To: "David Hildenbrand (Arm)" <david@kernel.org>, 
	Tal Zussman <tz2294@columbia.edu>
Cc: Christoph Hellwig <hch@infradead.org>, 
	Miklos Szeredi <miklos@szeredi.hu>, fuse-devel@lists.linux.dev, John Hubbard <jhubbard@nvidia.com>, 
	Jan Kara <jack@suse.cz>, Andrew Morton <akpm@linux-foundation.org>, 
	Zi Yan <ziy@nvidia.com>, "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, Peter Xu <peterx@redhat.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, linux-ext4@vger.kernel.org, linux-nfs@vger.kernel.org, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
	Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, 
	Usama Arif <usama.arif@linux.dev>, Kiryl Shutsemau <kas@kernel.org>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, Kairui Song <kasong@tencent.com>, Qi Zheng <qi.zheng@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Axel Rasmussen <axelrasmussen@google.com>, 
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, Baoquan He <baoquan.he@linux.dev>, 
	Michal Hocko <mhocko@kernel.org>, linux-fsdevel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH RFC 0/5] mm: GUP dirty + ->release_folio() fixes
Message-ID: <awmE8VSlF2VTHLGu@pedro-suse.tail5790ac.ts.net>
References: <20261119-gup-dirty-what-v1-0-236d69f25c24@suse.de>
 <4f096d70-6f94-4148-8f47-242b8551e5f9@nvidia.com>
 <awWNyDZT2SVu2Zp9@pedro-suse.tail5790ac.ts.net>
 <55114986-0ba1-4a80-8498-bf674d64e01b@kernel.org>
 <away88BuU8ibcTA5@infradead.org>
 <d088452f-1118-4a06-bc16-1942e523e0fc@kernel.org>
 <20261126022418.3620783-1-tz2294@columbia.edu>
 <50045fa1-0b46-402f-baf0-a08d05282410@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50045fa1-0b46-402f-baf0-a08d05282410@kernel.org>
X-Spam-Score: -13.30
X-Spam-Level: 
X-Rspamd-Queue-Id: 09F5C1C0011
X-Stat-Signature: owy3mgear8w5kgqzipfihcd7mtsw4z8z
X-Rspam-User:
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam04
X-HE-Tag: 1795786225-13385
X-HE-Meta: U2FsdGVkX1+wjOcSX6bNRAw8M+5LB2cn2j55FOApUSN/U47TB5KSzaZ8y3teTP4+gsbeP+8C7RLOx+3QZt/0HmA2/e2kNkaC9LeO0JSXCQl/4skx9/KNlRlmU53tvtmppO9xYnLlsf2wIv4lZtQ+xhLuCCYg+Q8FwJJs7APjB51ihhRtKk2ajrx1OT4Z/C346uJTcJQhIaCTkC0/IKtKQoFDx6CyTvzkFalgk4hf2nafx6AYQH1KASe6JI+A689LaOi6W6ccIGL6oeG+LX+ScrO+AmgA6ZZ6Ht1OpA1EdLijpEH/sJYuxK17RwrbcwuMa4RINC6eFL53s/J65hDwudgAEn5UbrS7bWHx7Lgm30XKNHk33YJdC0IalT0F+4i2LU8ld1bXRGsPdJaJcjeib63ITvsVt4JrzBaKBwS0G0bk18a/KHnnc79+tceajF5LdhLJGgs29pu7/AE/7qBHEbUWcuk+As4bIlhGQLtKs4Muz4aDxRnM/tZIXmA2/EdVUho1LWsObfwGSCu1HIZ0xo2DmZFCrpFUiGj42qv59V0u+MebcNStzsZNGYlleZ2alGeey60Dvk8M4nKg64LZXSChmc0/3ylSEtWa3s5K6DYAyENH529+3Ra155STHDFf9VFP/RyG0GNvFHAirMZpH7WJquP81dno2g6GmNrP7sVx/fY6BTe+T0ZHJ3TfiQRM7m4fY8eYEvp+mQ66r6KtQd4Iu0GFXY4Cr+GOCFNRAKczaZ/Hjl19NUyivVJ9deRFWdv2JFSs/K2mq3NALwoQqn3aPNPaGVQPtf0mztySLwwyxvx7kbHbbzHjEeiyZ17Zw4t1meRLwtTFe8Z5/2xXggSgHknxLV6NDMgSYCQhHltWLmRHz+sX53s1jb5vTSaUyACJdZyomvQo265mfvYpEJnKJEizqYU3oHY2cBkB0y0U9I3g6eXOmOIIcoAtQM5bC4MvOdDuOpKQBrGUqxU
 NL+qdYdH
 tEiLDLqKe6fhi9ENW5LKBxtz1idUU1zsPWuijnmhxAdJwj5DN0VjJGDGJ54q2dXANOklbzGDoNLVmOXDtZpNuOacyyguWUJD/tumnR0PmYT2e91x+E4mwFQ1N86p9F7xXbCBzFxi0kVwgD5pxZd2uuvo5wcsXEn6OsTls9gFgGrarm2cA46Ccd7ECyaIWPUbiCoTHNsXeSxQA6SRoTpayG+SvqG+zE2wiY7M5xyW9gDPrMWt2I3UyBvZ+1UogWSKLt9mae3pS+4XrfelLAoBgJRchdi+NbBoqyUJGvAnjAoDEOC3NSqBJcTZSKGuOduOdm99ELSqg6vSppCzlNA35GeA3hyDuThlQXuG5By1muDDeWS7Rwnmt4UYr3z70kCqNGtAcp5fLLghZT+mB8uQlN1kuNXhUsYtdR92s6KBysRBWlW8osCUswX8wl2Fb/uOVGZ8q+SjprOvnjbqcUUzOfeywbGLtrWnSTvcD4ijwiG9I5g31qeO2LXzcG6vI1Y7Fn7LSmLGSMwBbJCtiAqFT+cea4naO7I5uMWUG6qcZqLOCa/3kFGA6QW2Mcw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu, Nov 26, 2026 at 07:43:37AM +0100, David Hildenbrand (Arm) wrote:
> On 11/26/26 03:24, Tal Zussman wrote:
> > +CC Miklos
> > 
> > On 11/25/26 5:19 AM, David Hildenbrand (Arm) wrote:
> >> On 11/25/26 11:05, Christoph Hellwig wrote:
> >>>
> >>> We need to, if not for this series then for all the other outstanding
> >>> issues with GUP writes.
> >>
> >> Cool, and I agree (that's why I placed it at 1).
> >>
> >> But who is "we"? Because I recall that "we" wanted to do that a while ago.
> >>
> >> (I won't be "we" ;) Pedro, can you take a look? I'm afraid the fuse thing might
> >> be the harder nut to crack)
> > 
> > Coincidentally, I sent out a patch to convert fuse_copy_fill() to use
> > iov_iter_extract_pages() a few days ago in order to remove its usage of
> > set_page_dirty_lock() and address a different race. I think it should
> > address the fuse side of this issue as well.
> > 
> > https://lore.kernel.org/all/20261120-fuse-copy-fill-pin-v1-1-72a0d888f140@columbia.edu/

Awesome!

> 
> Oh, nice! I was assuming the usual "we use put_page() on some random hidden path
> or core code" would make that harder.

Right.

> I recall that's the reason why vmsplice
> still uses FOLL_GET years after we discussed that it should be using
> FOLL_PIN|FOLL_LONGTERM.

You almost gave me a heart attack, before I remembered these vmspliced pages
aren't writable :) That's a battle for another day!

-- 
Pedro


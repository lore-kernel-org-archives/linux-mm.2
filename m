Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6E823606A31E
	for <linux-mm@archiver.kernel.org>; Fri, 23 Oct 2026 13:00:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=nbN2jT0b;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=qmfmHZTn;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=nbN2jT0b;
	dkim=neutral header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=qmfmHZTn
Received: by kanga.kvack.org (Postfix)
	id 790426B0363; Fri, 23 Oct 2026 09:00:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 741D36B0365; Fri, 23 Oct 2026 09:00:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 62F506B0367; Fri, 23 Oct 2026 09:00:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 35A3C6B0363
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 09:00:17 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id AF9FDA7F81
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 13:00:16 +0000 (UTC)
X-FDA: 85353899232.25.87E8689
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf06.hostedemail.com (Postfix) with ESMTP id 8DDE5180014
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 13:00:14 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=nbN2jT0b;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=qmfmHZTn;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=nbN2jT0b;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=qmfmHZTn;
	spf=pass (imf06.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792760414;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CGkjdIfQ2kWLFqSVO3nPKYQIl8t6u+ZHR5jt0u0MANQ=;
	b=5ECpjTTy1e1ww+dltb9SPg30bYB3F2Zj5ITyAca76HRJFhJQKhmrUkzK+YZMUD2gzrTcjc
	hdh0iV1vDpDUI7AzQeaLv282ysGY8MEzYyZnmDi0XnGiCZuSA0Pf28UfrnPtc+v842xc1K
	h1BWIBSdssvK1A+yxM74D5bLJ8k/qqQ=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=nbN2jT0b;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=qmfmHZTn;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=nbN2jT0b;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=qmfmHZTn;
	spf=pass (imf06.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792760414;
	b=8NvUzHPHpKHgACtbaIGNojCVgKxxLOlsGGZoF8C2aOoQOvbhcrKrk5ls8oVSbzPPUtMXuK
	vpoa9sjFPe0LGKhiyR/XnvtzpzkNpSessY+gRjNZT2aggfie1ffAxPzwO+5OOv0BrR+Pf/
	ZZWZmY4k75SUhrCIN6TDM7mv7XzLDg4=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 2A0361F785;
	Fri, 23 Oct 2026 13:00:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1792760413; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=CGkjdIfQ2kWLFqSVO3nPKYQIl8t6u+ZHR5jt0u0MANQ=;
	b=nbN2jT0bJ+1hEWNmQMV68E0bK59uevv3wh0s4HgOA6Z77CrVn7bBKopcNV6FBOhOjBxmAK
	LSQ6mg5Bx/3cn7tFcuwqP8sn3EesbXT/md+yTtFq8JYXM5NxG6yvZzzpy6t6nNZ6QbT9Lp
	k5Wu/hMJcRI0+VCPD3cMO2Vj0Jx0rss=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1792760413;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=CGkjdIfQ2kWLFqSVO3nPKYQIl8t6u+ZHR5jt0u0MANQ=;
	b=qmfmHZTnKLgVSgw3CxWFYZZGj6k5bDwHfjuEOGcYuLMqYbdEaU8j9h5cJCy02vJqHx0RVm
	PU1Kqb1ZznCr4kBg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1792760413; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=CGkjdIfQ2kWLFqSVO3nPKYQIl8t6u+ZHR5jt0u0MANQ=;
	b=nbN2jT0bJ+1hEWNmQMV68E0bK59uevv3wh0s4HgOA6Z77CrVn7bBKopcNV6FBOhOjBxmAK
	LSQ6mg5Bx/3cn7tFcuwqP8sn3EesbXT/md+yTtFq8JYXM5NxG6yvZzzpy6t6nNZ6QbT9Lp
	k5Wu/hMJcRI0+VCPD3cMO2Vj0Jx0rss=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1792760413;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=CGkjdIfQ2kWLFqSVO3nPKYQIl8t6u+ZHR5jt0u0MANQ=;
	b=qmfmHZTnKLgVSgw3CxWFYZZGj6k5bDwHfjuEOGcYuLMqYbdEaU8j9h5cJCy02vJqHx0RVm
	PU1Kqb1ZznCr4kBg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 5915B133F3;
	Fri, 23 Oct 2026 13:00:12 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id GRe3C1xa22oBKwAAD6G6ig
	(envelope-from <pfalcato@suse.de>); Fri, 23 Oct 2026 13:00:12 +0000
Date: Fri, 23 Oct 2026 14:00:10 +0100
From: Pedro Falcato <pfalcato@suse.de>
To: Luiz Capitulino <luizcap@redhat.com>
Cc: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, "Liam R. Howlett" <liam@infradead.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, Jann Horn <jannh@google.com>, 
	David Hildenbrand <david@kernel.org>, Jakub Matena <matenajakub@gmail.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [REGRESSION] mremap() fails VMA expansion when VM_MIXEDMAP is set
Message-ID: <attZIKD7GfoNeqbg@pedro-suse.tail5790ac.ts.net>
References: <20261023023106.515365-1-luizcap@redhat.com>
 <8c53e58c-f7d2-4e98-8d03-7ff1163c1159@kernel.org>
 <9544f4ce-f5d1-498b-91ed-906b37122e31@redhat.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9544f4ce-f5d1-498b-91ed-906b37122e31@redhat.com>
X-Spam-Score: -13.30
X-Spam-Level: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 8DDE5180014
X-Stat-Signature: 7s9ik9qk9pmcnxwjjcca7g5umnfnheyu
X-Rspam-User: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-HE-Tag: 1792760414-220511
X-HE-Meta: U2FsdGVkX1/a7Mr+CgCG728Bv80KIlDNYuB3Wn/QRBC66e1oNdWhFEynDzhfAlDFFF3ygDb5VlZ8N4CrRckl4HCLtQadMETQJh4gAUaQFFmrWwNABx7L+umfFSV4ekV4526Cl/SS+Fr+NnKNHZHrtJYJ41oxsxtUdOdc0FxmZPxD2Prh/cBNxK+fBvHf0oSEKZsVu2KUQ2+u1K/KRwIlc9/Qlfoi2GqajpUSR2bqKT/KJQ8+fGFCpfq8y+5foQHGfyXAxAZRbbfop/c4MB4yjjGs0bcKN6hNGiCujfajZM9PvNG2yFTc1tbAiM+/fbev7/KUANN69TeSY+AE+hlzPrPxpv9ns8A9pt8o6q0wugM3lrb87EiaW1J5eq32elFe3CKN7zY8zk1VAh1Mbix89/dZDm7CLumrHZU8nZ69JqVm9jW+Q5Ft2ol50WsCBtABXYtlSSYf+LRcVecPpIG6FUODaCHp0Q9/HE4cuZVZauo/JlYE4+XhT0vrwdWsXq7v6U5CBE2mkWDwxGUCNr0IohawF/U4sYTbr4mhtTr5iUPmzgBM9oLIwLT1fV+J2oO1LlkbD8dL/zCM1tXKWY/wUMRb9H1gVe8X80uPYopLrLyfToJCcG5heSeDP3lqUyzsM4iK8BfGnZylZ6Qli9gRXoUrGN9fKNacRlhmOi/lYe3uNkdhK0qq/qNComIuuSfpxzhWuC6yEeAwRDuQgL+a8KsCPT0gxVuJ/vQdu9/8EMYM2gi6pxRQ1Q5RVI33ApK11ID/J/WTikuVxi2uWKvpAvNpx1UEl0099Fcppc16ddIRN1rBJ/CSjog2RPhhADa+9UxpQCR5J3QNStJ/kzH1uwQpRpwI2eJwIE7jFFe6Aca3q/JkjxRe97ShObltcpxvej8A1PUPA7swH/lAO6E9hd51e8m5Eax1kqwiE7+cHSK758RNlnRKyISDUNk5rjYU6SoITW5PeSsyP0JITtF
 xaURE6Cm
 KbsJCCFafOqdied+vs76Q7tDK/7Qv9piaNvMeERbvjNkV3JyU/E4UsdxaQWteJCDFs0YisazkBTLifl1TznD4QrJusy4oOD+Eeh8E/BmKzch+XuxkqtBpPFDyySNrBmrpZghM+RHbPrpZPwTrfd1Ktoj72BN9fSoZGZ4y4ohGCjYDQii+1718kp5Ej/2VGIXGr67056q+p4C8L6iCgTMuR2uANUe2zHnbsgvEANFwOCycEC/qclJBrek4SOoyBUpmCd/RhIfiXsxdKNpyRroyAqcWff9wsIIjBN9oo9E6eApLIM6VyZpgpEulRw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Fri, Oct 23, 2026 at 08:13:56AM -0400, Luiz Capitulino wrote:
> 
> 
> On 10/23/26 3:16 AM, Vlastimil Babka (SUSE) wrote:
> > On 10/23/26 04:31, Luiz Capitulino wrote:
> > > Growing a VM_MIXEDMAP VMA with mremap(), with or without MREMAP_MAYMOVE, fails
> > > with -ENOMEM when the address range after the VMA is free.
> > > 
> > > This regression was introduced in v6.1 by commit ca3d76b0aa80 ("mm: add merging
> > > after mremap resize"). This commit changed mremap() to use vma_merge() instead
> > > of vma_adjust() for the expansion case. However, vma_merge() returns NULL for
> > > a VMA that has any of the VM_SPECIAL flags set.
> > 
> > Hi,
> > 
> > 6.1 was a rather long time ago. How was it discovered just now? I.e. what
> > use case broke by the change and prompted creating the reproducer?
> 
> The use-case that broke was an application running on an older kernel
> and accessing a GPFS volume/FS. I was told that GPFS sets VM_MIXEDMAP on

So the application is growing a file VMA with mremap?

> a VMA because it inserts pages in the process address space with
> vm_insert_page(). I then asked an LLM to check if there was anything in

FWIW this is really odd for a filesystem to do. I see we have two filesystems
upstream (at least in 7.3) that do this; that is, cramfs and FUSE DAX. This is
arguably weird and should be fixed. Perhaps the VM side isn't giving
filesystems the right flag here.

-- 
Pedro


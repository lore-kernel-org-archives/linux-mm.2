Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 65AD5C43458
	for <linux-mm@archiver.kernel.org>; Fri,  3 Jul 2026 09:18:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4C3D56B00B5; Fri,  3 Jul 2026 05:18:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 473EA6B00B6; Fri,  3 Jul 2026 05:18:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 362ED6B00B7; Fri,  3 Jul 2026 05:18:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 0E1606B00B5
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 05:18:05 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 7DB301C79F0
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 09:18:04 +0000 (UTC)
X-FDA: 84946913688.20.DAE919E
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf24.hostedemail.com (Postfix) with ESMTP id 6821D180010
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 09:18:02 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=J+jWUKTq;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=s2psg9T1;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=iCXK6Nm4;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b="E8/ghmHk";
	spf=pass (imf24.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783070282;
	b=NFQfGYyRyHr9Z98yXQ52cPpZaplB+B+jkgQWHG746wxIvp9aRIUCiCIIOTsQ6jojwYcWc7
	lyCUMHRU+A24hcAMnTRCAUkBo7+WPkI3sOam17kSHIjzmwwjcb+i6Q+YCj4O2DVnOfKPXS
	lsnLRZRfYuoLEdQz8CB++VggbjFceJc=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783070282;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FhN9EMr2lHkL5BMvw29TtKP0AePa2dRLHiG8ECux59Y=;
	b=oAdV4UbFEOcs56nRrQtx580u8fhLys84tmSBHhzaImCvrq/dh53/tx3PtQhlbCN1YcV0n0
	OZUkcclY7/DQNIA44kke77R+EcPC7AWOe5zc/USXH9qm9ecKpUNfRxFB3pKodi6SbEFxtQ
	h8KgqTU70x7b3DzNgdaBRTYy2CS7uS4=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=J+jWUKTq;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=s2psg9T1;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=iCXK6Nm4;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b="E8/ghmHk";
	spf=pass (imf24.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id DB13674825;
	Fri,  3 Jul 2026 09:18:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1783070281; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=FhN9EMr2lHkL5BMvw29TtKP0AePa2dRLHiG8ECux59Y=;
	b=J+jWUKTqq5o285bOJdd0jxEhqO6vpnYVpX9gnCs0/CFbx1O8UaynYTrWDaU86U6j/g00Ot
	owQzwP1x7cyHpiMhWbTVthDsRPhHM0Fs/ndzb1xZ39msuQUr4haR8ktQiLMvWjiECXXNc/
	Gj5YWtayG7VPZiHhRYbEPcnl+d6Y3mE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1783070281;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=FhN9EMr2lHkL5BMvw29TtKP0AePa2dRLHiG8ECux59Y=;
	b=s2psg9T1r/2hQkDSiO4PtzcwH/6mfj8+bjgLFZwymi5BgnG3YmnTdJsWKdt1SJjfKLwmCj
	fx63nnBGWQ+z8MAw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1783070280; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=FhN9EMr2lHkL5BMvw29TtKP0AePa2dRLHiG8ECux59Y=;
	b=iCXK6Nm4/4D5p8LPMLzFK81dWPnUO7XwzclX66EtIofxy8KzWsan8gpSDhx2tPtzwqJ7A8
	dKMVE/boPVoTFmEDslBKzgDeK9kua//Whd3YLGvoCxOfQORJHYtTcfU1u29fZmqwAOSS+J
	d7wfrMoZtbApQ9qUvH1hP0qwM+82qfU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1783070280;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=FhN9EMr2lHkL5BMvw29TtKP0AePa2dRLHiG8ECux59Y=;
	b=E8/ghmHkljwFP6n9e5ZRXEkHaLks7oMbJzsGUtma26Bg/uOEBvrhX4Stvb5MhXawttTNwc
	rtPqN6pycCRUR6CA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 7A8BD779AA;
	Fri,  3 Jul 2026 09:17:59 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id h3E+Gkd+R2p/ZgAAD6G6ig
	(envelope-from <pfalcato@suse.de>); Fri, 03 Jul 2026 09:17:59 +0000
Date: Fri, 3 Jul 2026 10:17:57 +0100
From: Pedro Falcato <pfalcato@suse.de>
To: Lance Yang <lance.yang@linux.dev>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>, 
	"Liam R. Howlett" <liam@infradead.org>, Nico Pache <npache@redhat.com>, 
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>, 
	linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>, 
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, stable@vger.kernel.org, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Lorenzo Stoakes <ljs@kernel.org>, 
	Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, Matthew Wilcox <willy@infradead.org>, 
	Song Liu <song@kernel.org>, Eric Hagberg <ehagberg@janestreet.com>, Zi Yan <ziy@nvidia.com>, 
	Gregg Leventhal <gleventhal@janestreet.com>, David Hildenbrand <david@kernel.org>
Subject: Re: [PATCH stable] mm/khugepaged: write all dirty file folios when
 collapsing
Message-ID: <akd95TCd3m8n74Xm@pedro-suse.lan>
References: <20260702165409.164568-1-pfalcato@suse.de>
 <110e92b2-f7a6-487a-94a2-25ef1242afb7@linux.alibaba.com>
 <6a547571-e60e-4b36-9968-011e3d880588@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <6a547571-e60e-4b36-9968-011e3d880588@linux.dev>
X-Rspamd-Queue-Id: 6821D180010
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Stat-Signature: td1e1pxm63pa8kc66ou53pk4xa6qhzeu
X-HE-Tag: 1783070282-996220
X-HE-Meta: U2FsdGVkX190fWMeg3GxDSb6fb7qdMp+EyzpW6rl2EaG6W718OKvwQzzCyyWMlIGJT0w1EODT55536/40OMNstmB6TnVVo1HDq21jonqQUFIG2A7nD3mqw90gAmEY7B78tguHj5yKPM7PWpS6ebkxwsofRz7VZOBlgCQ17V1EFXf2hyzOC5Nkp6h+g+pLNcljl/p75FyLmLyyd8u/cqbtbDE+aqO3iDd6OPgdiPcL1xUFI2QjTfGK5Mzodtxj40lo6yJ4VFvDuiZzxhQbIbGuhSoLpuVbaCR9mSnpR5M7p9nkMOdcatUt4LKWdJHWK4Je4CMrbfIKv/YL4E8VgB3wEunJmsjwHmyf0fE2+sS0Z03fVt/FsuFqhWhrK4BBfaJaeNPisTTi73aMzqyVFDA2mR7QYik5W1il25cEDAUNRkGB6lvQoDeHyFBCrhe7isnCHIUJ9bKPwjFpA8fEHaifZD8acJLROSydp/5bgAAM3wIcw0wUKfZpfV4WcdV80ZNwuZFbX2B6pWht9V/uaIw3osokUU8T3RaGXFOkznQwUUowJykMsmIIF+RRinrV4AXCUhulaAmqxP3Wav+zZcWroEkvJNECaRK6d1BBrWXdYWHpTdn71HYCqIUu0lNVeznzx9UzKi/TWJdNx5r9rOeiMRD2gX6SDaoH9MeYQkyfsKeV2JaMpC3XHkEfXtUT7S+DvBTT3BWQx+WpPvRQ3nX7vCIpTG7M82q5DhWdKcQt+ccpVbds6/JI0R5j3Rdv8As10armGJFxraFgpE0ao5iEXK3hXRkrYMZ9LX4Hx5VixBnf9lfMZLK971MKld27jFgeuo12bQoQ7m4A34QiLR/BdbhZgLZPc0Kogg0OE45YX0oHz3EIc9nNOFXPsLU9CF76sY6BQAiVW7gudrDGCc7G//wbtF65YOQtvjzhDTDFbKehhrve9RNJByo0bEkf+UlGVjOhrtHxvIRLpl7jQR
 gvS18ObT
 RkmnP633g2HBkaAlCixsYpS261NW9eezLE2vua8RY29pHQboKT/IDhUHMRv/ZxFfYDmmF9SU9/sdJbKxW7am2BZGdKT2UwrrB1KwB1EVUmI7udung1qUVkoscDUKr0DLeR9C/pzTSAvgvjWSXf1tTWFjaPMXK+Q5w38T6yxePzbM0eFSyWXyRgKpecRY5TKLZ80Q7gqZPag+difyOUfW5TRPAVbXIY6NlYW8+MZ4yJbfqH4Hkw9kzZgGYCo2dqqLYUwNWzo+JhqXjULE+6cW6yRgPv+pDCtyzE+J0KsA8uv+BU66OscIL57+s+o7e+PtD8YoZpFKr6uhj+wIETwdyhUh4GPA9XVyLe9qeTPMX4t0K2Qfzvvrgv0x1xgvJvsCFQN05p+IRoSkWUl+bUYnJ76oYajDTLgF/5vAXy64P1oKufgopPrAqk44VUng00d+8wqzU7JqPQRCum8Luvnx0pg/Ynw0UsmuDs99MR38YO0naVeQ9nRAa+MGxV+4xHU+kqfQ1+A37JGy9AX9Rf+8mp4mjlJhPRtn8WH+K
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jul 03, 2026 at 04:45:34PM +0800, Lance Yang wrote:
> 
> 
> On 2026/7/3 11:49, Baolin Wang wrote:
> > 
> > 
> > On 7/3/26 12:54 AM, Pedro Falcato wrote:
> > > As-is, khugepaged and writable-file opening exclude each other. A file
> > > cannot be open writeable and have THPs (because the filesystem is
> > > not aware
> > > of them). khugepaged will never collapse file pages for files that are
> > > opened writeable. On an open(O_RDWR/O_WRONLY), the page cache for that
> > > particular file is dropped. This is fine because nothing could've been
> > > dirtied.
> > > 
> > > However, there is an edge-case: collapse_file() might not be able to
> > > coexist with concurrent writers, but it can coexist with dirty folios
> > > (from previous writers). Therefore, the following can happen:
> > > 
> > > open(file, O_RDWR)
> > > write(file)
> > > close(file)
> > > madvise(file_mapping, MADV_COLLAPSE, some non-dirty range)
> > > open(file, O_RDWR)
> > >   nr_thps > 0
> > >    truncate_inode_pages()
> > >      /* THPs are cleared out, but so are the dirty folios */
> > > 
> > > When this edge-case happens, there is data loss, as the dirty folios are
> > > fully discarded.
> > > 
> > > Fix it by fully writing back the page cache (and waiting) when collapsing
> > > file THPs. Doing so provides the guarantee that no dirty folio will be
> > > observed while there are active THPs. To fully ensure this is safe, the
> > > invalidate_lock needs to be held while doing the writeout, so that
> > > do_dentry_open()'s page cache truncation excludes this write-and-wait.
> > 
> > Thanks for explaining the race, and it looks reasonable to me. One nit
> > below.
> > 
> > > Cc: stable@vger.kernel.org
> > > Cc: Alexander Viro <viro@zeniv.linux.org.uk>
> > > Cc: Christian Brauner <brauner@kernel.org>
> > > Cc: Jan Kara <jack@suse.cz>
> > > Cc: Matthew Wilcox <willy@infradead.org>
> > > Cc: Song Liu <song@kernel.org>
> > > Cc: Eric Hagberg <ehagberg@janestreet.com>
> > > Cc: Zi Yan <ziy@nvidia.com>
> > > Fixes: 99cb0dbd47a1 ("mm,thp: add read-only THP support for (non-
> > > shmem) FS")
> > > Reported-by: Gregg Leventhal <gleventhal@janestreet.com>
> > > Closes: https://lore.kernel.org/linux-mm/
> > > CAFN_u7H_0ECF3jixP=T=U7AH5=Q3wQNvJMo8an3VqUDMerQfUw@mail.gmail.com/
> > > Tested-by: Zi Yan <ziy@nvidia.com>
> > > Signed-off-by: Pedro Falcato <pfalcato@suse.de>
> > > ---
> > > This patch is written against 7.1.0 (because the code no longer
> > > exists in mainline).
> > > 
> > > Zi, I kept your Tested-by, but I had to move some things around and
> > > use the invalidate lock. Please re-test if you can.
> > > 
> > >   mm/khugepaged.c | 39 +++++++++++++++++++++++++--------------
> > >   1 file changed, 25 insertions(+), 14 deletions(-)
> > > 
> > > diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> > > index b8452dbdb043..0707d719a270 100644
> > > --- a/mm/khugepaged.c
> > > +++ b/mm/khugepaged.c
> > > @@ -2094,32 +2094,43 @@ static enum scan_result collapse_file(struct
> > > mm_struct *mm, unsigned long addr,
> > >           goto xa_unlocked;
> > >       }
> > > -    if (!is_shmem) {
> > > +xa_locked:
> > > +    xas_unlock_irq(&xas);
> > > +xa_unlocked:
> > > +
> > > +    /*
> > > +     * If collapse is successful, flush must be done now before copying.
> > > +     * If collapse is unsuccessful, does flush actually need to be done?
> > > +     * Do it anyway, to clear the state.
> > > +     */
> > > +    try_to_unmap_flush();
> > > +
> > > +    if (result == SCAN_SUCCEED && !is_shmem) {
> > 
> > Actually, the operations below only for those mappings that do not
> > support large folios. For mappings with large folio support,
> > filemap_nr_thps() always returns 0, so the race described in the commit
> > message won't happen. We can add mapping_large_folio_support() here to
> > filter them out.
> > 
> > if (result == SCAN_SUCCEED && !is_shmem && !
> > mapping_large_folio_support(mapping)) {
> > 
> 
> Right! nr_thps only gets updated when !mapping_large_folio_support(mapping).
> 
> For mappings that do support large folios, writable open won't see
> nr_thps > 0, so no truncate_inode_pages() for that case :)

Yep, thanks for the suggestions. Willy also suggested this, and I didn't get
why at the time, but looking closely at nr_thps_inc/dec, those helpers only
do something when !mapping_large_folio_support(). Fun...

I'll fix it up when sending to stable (or a possible v2).

-- 
Pedro


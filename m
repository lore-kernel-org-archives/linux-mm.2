Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F261DC79F9A
	for <linux-mm@archiver.kernel.org>; Mon,  5 Jan 2026 13:58:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 216EA6B014E; Mon,  5 Jan 2026 08:58:29 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1B43D6B014F; Mon,  5 Jan 2026 08:58:29 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0BCFA6B0150; Mon,  5 Jan 2026 08:58:29 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id EB5BF6B014E
	for <linux-mm@kvack.org>; Mon,  5 Jan 2026 08:58:28 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 8E7271A0121
	for <linux-mm@kvack.org>; Mon,  5 Jan 2026 13:58:28 +0000 (UTC)
X-FDA: 84298065096.23.E93D47B
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf10.hostedemail.com (Postfix) with ESMTP id 93F9EC000E
	for <linux-mm@kvack.org>; Mon,  5 Jan 2026 13:58:26 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=LMdQElta;
	spf=pass (imf10.hostedemail.com: domain of bfoster@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=bfoster@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767621506;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tAkRmahwDMj8glf3/6lkFxmOJSwV+a/ZJXhYLby36UQ=;
	b=ciCzsdU1v9xkM8sMCl5hjBEp0hNdiFOESRucTvByFqiAa46bodiJRNhYezTURWG6+7lnSv
	fG2WFMozzqvVrvRgBITc2Rm4+fb2A5IS3AdA27xARL62Pdl5Dk4KABeGNJCsvkLIPfB7bw
	KgzrJN98vMXvc2qRtI41e1j2Gv9Kq80=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=LMdQElta;
	spf=pass (imf10.hostedemail.com: domain of bfoster@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=bfoster@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767621506; a=rsa-sha256;
	cv=none;
	b=DRy2ZkRRuaSi5GqiQ/HSZUXU++QNWpmhwPPaw7GbWUn2kzOJVF8w2FX1sa5iYUujhZhNG3
	quvZTFnaKyYEy3EeBUTQjWeyoMxCkQ8g0Oqr5ifUBAY8YlZ2r8DIxbR0zjLAnQga34RezP
	AcYGo113+0aKM39/iFYWbdbtqpxUkJE=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1767621505;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=tAkRmahwDMj8glf3/6lkFxmOJSwV+a/ZJXhYLby36UQ=;
	b=LMdQEltaxZqvBb2G47MWUkDlOlihAHjgzZpA0UQwwisYNY5cPpTrb3egqhGcIvV39IscbX
	wQCxZV/19SDfvbrY+8nxcU12MxFQDXCxUgLy8wfqXwr6j+MI0/FOzp8Y/me74YUg9va16L
	+PeCvqlhRoojrItkuPSyZSPrTD18obs=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-152-7ozuR_E_NR2ifjhmuXX-wA-1; Mon,
 05 Jan 2026 08:58:20 -0500
X-MC-Unique: 7ozuR_E_NR2ifjhmuXX-wA-1
X-Mimecast-MFC-AGG-ID: 7ozuR_E_NR2ifjhmuXX-wA_1767621499
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 4E212195608A;
	Mon,  5 Jan 2026 13:58:18 +0000 (UTC)
Received: from bfoster (unknown [10.22.64.153])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id C24CC1956048;
	Mon,  5 Jan 2026 13:58:15 +0000 (UTC)
Date: Mon, 5 Jan 2026 08:58:08 -0500
From: Brian Foster <bfoster@redhat.com>
To: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <21cnbao@gmail.com>, Matthew Wilcox <willy@infradead.org>,
	akpm@linux-foundation.org, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, Hugh Dickins <hughd@google.com>,
	syzbot+178fff6149127421c2cc@syzkaller.appspotmail.com
Subject: Re: [PATCH] mm/shmem: fix uninitialized folio in shmem_symlink
Message-ID: <aVvDcEB583Yuolm_@bfoster>
References: <20251224094027.65842-1-21cnbao@gmail.com>
 <aUwcV2HhtdiXXxfJ@casper.infradead.org>
 <CAGsJ_4whKLWiw6LNexFPHTFWB1QbSrAwrBtspuc=c8fM2=WnvQ@mail.gmail.com>
 <bdb7f7c6-ecf5-4da1-a11a-cc19c77fe4f2@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <bdb7f7c6-ecf5-4da1-a11a-cc19c77fe4f2@linux.alibaba.com>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 93F9EC000E
X-Stat-Signature: 7dj68swqpptiegk71w147in5kso6o5hh
X-HE-Tag: 1767621506-290092
X-HE-Meta: U2FsdGVkX1/OjDzTEMiBJ7NuBHrEeXnbFe8d0nCufCJWmNTOYPRsN7QBpjtVvIjGjpGVZeFCdj23Jhv8DYSiNNmS6o3e//iOc9ra2fNy+mk44jDRT+GB+ie6Vwp3aYG1kx+WIkwL5cbkA3HA2tiyqkArmp9CHke7/LWpBZByGAZg8IM3Kfmfa2vpiLqJxwAuDACkGW1wKPXx9akLR9AtxkZwAGYk8yTlFrgHPITd5vo5SwFzWhd4eygO2bHQBce2fYTOLGFh2kNsT4w2prJULbe6fU62vgJ9HJGRMt7EPEls3Qc2YqMZjokcrOkubDtHthl9LYl9taAnpEtXtdKsEN0WWOfTx0Ago5lj05sVjafmxZHNsfsVAy3ZtoSHXY3cReY0TSWRJei0T9sIcj7thRu4PLAMalAvO78cCXgvMnpa5FhSy0rjDlQtITP2LeUJfQbh7Jr4RKGowRpm2ivvFgrj/bVCDMqDrQ9Cp12fs9eMDHkWfYd35+qHPjlteqd0hgYdn1LvVt5PscVNlbNtxhQoTu4AepvpdjnGJd0N2auw9yzw3PZdltCz9StjtkWBhih2GnyvCP3wDwHCFWqLN8wopfy0EbnzA/46CI7f32DEVmzjiK7+RGbe+4mrCDCORh3YoxEnf9iop/B5//VyID4ScUiVHivCkgQD72rpdZ2rMBwv4GilkaoF+AuSWty9OyJT92iriY6EJHy19CkqmXwoifv0hp6ZHyzhXwnowFQIQdpWIUhUMmlsY32LQwJOIsNFsjwJjbSDb7wvc/0c6cDs6sFq0m5AT+9uj37u65OnJmChDt1VD1bd3lXXEFSbwRNz2xG0lKuYkiWbpBrurL96tTROegpycmF+SKABt14GGWLvOk3Btjko08HmsuMFOflsyHT8vCaWwfQJOzIvu/vPfEcEeA2iC1lNmtieZveISgoom+LUxhly6lhTVW1DGDDDzNGBiOsyga7uAJY
 86N69Xn5
 087Xcj+/CeZUczn1jNqMwS6tCWvesdb2sETBO4u+z34Ld0Cp+9/c+o35vaGIPe/qUMrj2N0p9GQxaeL/OhotIXFpF797d1ppKjL1SkEiW31vX6+cTQHGoOPY26i8g48eaPuOlUFj67EnMtKwI+dgr6f31TS+gDhTJR7RqYBxG9vizYfzrRq/mTvPW/wkDJ2A/CPueLgqyDjEREpghmqkNUS/dUd9v+k+xcA+MZUo16YCENBO13rU7kMtek9AuxwdCaQSatEUEHtJzo2Q1RL95aJL8JXekzbzi/zz7v64hVCLP5UTtgNzYpaQDF4+uelEbUPr3OlahHSPqx+XOdaQP49s8tAVckLFs6P9X57cW7c8f6xVm50zaJBdRQg5ZVQQZMbbdSY2Lu14IBJ8c5wKmR62mDyHYCzBhGYD/Z5mhL0KkI8GMFgKYfWAbzQKJEL67W+OoJguKtwe5ebFzImUi5Z/r35o80NEJKmgU8sS3oon5gTNr2XDlpWf3l3fMnlt9VwH7bux5D1U7dg/wSjXlPJwOfNxNY4u8CR/QJ7vPlEN0gJJ+bPvyYatuLLfqX8EbsHHSAs3NfqdAAkF7v1zlbDVPkq0JB18sApb7xsTRJGD9c53LXnIr7LWfV1KCBTJjXK6v
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Dec 25, 2025 at 06:08:08PM +0800, Baolin Wang wrote:
> 
> 
> On 2025/12/25 12:04, Barry Song wrote:
> > On Thu, Dec 25, 2025 at 6:01 AM Matthew Wilcox <willy@infradead.org> wrote:
> > > 
> > > On Wed, Dec 24, 2025 at 10:40:27PM +1300, Barry Song wrote:
> > > > From: Barry Song <baohua@kernel.org>
> > > > 
> > > > Uninitialized folio allocated in shmem_symlink() may be accessed
> > > > during swap-out, causing KMSAN BUG:
> > > 
> > > This would be an unfortunate way to fix it.  The vast majority of
> > > symlinks are short, and we'll never access past the \0 in normal
> > > operation, so we'll be dirtying a lot of cachelines essentially to (1)
> > > shut up an automated tool and (2) optimise a corner case.
> > > 
> > > How about this instead which delays zeroing to swapout?
> > 
> > Matthew, thank you very much for your review, even during Christmas.
> > I would like to wish you a happy holiday!
> > 
> > I am not quite sure, as shm symlinks do not seem very common. Since
> > allocating a folio requires a symname longer than 128 bytes (where
> > 128 == SHORT_SYMLINK_LEN), such cases appear even rarer.
> > 
> > BTW, do we need to migrate the owner_2 flag in folio_migrate_flags()?
> > If so, I am not quite sure it is worth changing the hotpath to
> > accommodate this.
> 
> +1. At least for me, using the 'PG_owner_2' flag alone to mark this uncommon
> case doesn't seem quite worthwhile.
> 

Also JFYI the post-eof swapout zeroing work (still pending) looks to me
like it would cover the swapout time case [1]. That's just if you wanted
to go that route here; creation time zeroing for the large symlink case
seems reasonable enough to me as well.

Brian

[1] https://lore.kernel.org/linux-mm/20251121152246.1023918-3-bfoster@redhat.com/

> > > diff --git a/mm/shmem.c b/mm/shmem.c
> > > index ec6c01378e9d..f3b3be1b50fe 100644
> > > --- a/mm/shmem.c
> > > +++ b/mm/shmem.c
> > > @@ -1636,6 +1636,13 @@ int shmem_writeout(struct folio *folio, struct swap_iocb **plug,
> > >                  folio_mark_uptodate(folio);
> > >          }
> > > 
> > > +       /* Zero out symlink tails to help with compression */
> > > +       if (folio_test_owner_2(folio)) {
> > > +               struct inode *inode = folio->mapping->host;
> > > +               folio_zero_segment(folio, inode->i_size, folio_size(folio));
> > > +               folio_clear_owner_2(folio);
> > > +       }
> > > +
> > >          if (!folio_alloc_swap(folio)) {
> > >                  bool first_swapped = shmem_recalc_inode(inode, 0, nr_pages);
> > >                  int error;
> > > @@ -4133,6 +4140,7 @@ static int shmem_symlink(struct mnt_idmap *idmap, struct inode *dir,
> > >                  memcpy(folio_address(folio), symname, len);
> > >                  folio_mark_uptodate(folio);
> > >                  folio_mark_dirty(folio);
> > > +               folio_set_owner_2(folio);
> > >                  folio_unlock(folio);
> > >                  folio_put(folio);
> > >          }
> > 
> > Thanks
> > Barry
> 
> 



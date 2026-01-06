Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3B672CEFCE2
	for <linux-mm@archiver.kernel.org>; Tue,  6 Jan 2026 18:46:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9B4E76B008A; Tue,  6 Jan 2026 13:46:14 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 98D056B0092; Tue,  6 Jan 2026 13:46:14 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8B91D6B0093; Tue,  6 Jan 2026 13:46:14 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 7CB7C6B008A
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 13:46:14 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 303191A0873
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 18:46:14 +0000 (UTC)
X-FDA: 84302419068.18.67B5F79
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf08.hostedemail.com (Postfix) with ESMTP id 15F90160006
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 18:46:11 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=IARWE1zP;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=none (imf08.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767725172; a=rsa-sha256;
	cv=none;
	b=pLJjT1HrRSu57ax0m8NTq40bXZcIwpeVI37S9A37JE2nxdDqu9v1dhhgE1vhNT76q9vmCO
	BjraxZQ8IieMch74a92gPU2JV/8ECk3+jF+3+SZsyhJPYHXO2hfFfvxmORLitg6sNVjvXk
	GInRTKWQ7zMPvhx4UQMy7Z4bhDiTz7s=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=IARWE1zP;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=none (imf08.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767725172;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Wo2o+JALBU6VBsZm8lcVzlOAHsqn/+GMFk5NcFxlXaM=;
	b=JMa/CDePmj/fsuNYe1pmgRHxMwI7h0HnSgMnB7ju9PAzVIcEXQ7loRyKdBBTZbu0Jiqz7f
	2M3dIDcQkWRbNWPkaYxPVO3rTj9fbQk8w/8JfCDCvrWLIaS+/42eQPWbMXF5L9S/L420kD
	545fFyEWhm3c6UvS0gxfuXa0pFmMfww=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Transfer-Encoding:
	Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:
	Sender:Reply-To:Content-ID:Content-Description;
	bh=Wo2o+JALBU6VBsZm8lcVzlOAHsqn/+GMFk5NcFxlXaM=; b=IARWE1zPOdFKJHoMAVzT6KZBBy
	gA0djuK2uGibigJfm3JoBK50ngrNEDi/Rje3Fgvrib7URrln1rgFzWnIJ6dlygys0v9R+QIC3vXue
	F1slxyym3DrOXusXNKSWHSkd1zH/ZPKtydzPVNgceekGX4Xxb6j4HtMzDEObT8KXonwAk4x4F3CDO
	Q9M7RCTOqHTEd05uAL5AuTPnY6y0orxb1YMQrbVcW1HWoVWtzLQzKLHMvzjd//4V+/oxiE72VVBco
	hCq3JUZKbMsK/l46Pe3L0tPZG3uhl+Qka8cKormNffICx7hxI/bdwpUJqXQCRSXk6cmTSjlR05a6u
	vM1BIYAQ==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vdC4F-0000000CJZ3-2085;
	Tue, 06 Jan 2026 18:46:07 +0000
Date: Tue, 6 Jan 2026 18:46:07 +0000
From: Matthew Wilcox <willy@infradead.org>
To: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Brian Foster <bfoster@redhat.com>, Barry Song <21cnbao@gmail.com>,
	akpm@linux-foundation.org, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, Hugh Dickins <hughd@google.com>,
	syzbot+178fff6149127421c2cc@syzkaller.appspotmail.com
Subject: Re: [PATCH] mm/shmem: fix uninitialized folio in shmem_symlink
Message-ID: <aV1Yb4r9_ukWoc8i@casper.infradead.org>
References: <20251224094027.65842-1-21cnbao@gmail.com>
 <aUwcV2HhtdiXXxfJ@casper.infradead.org>
 <CAGsJ_4whKLWiw6LNexFPHTFWB1QbSrAwrBtspuc=c8fM2=WnvQ@mail.gmail.com>
 <bdb7f7c6-ecf5-4da1-a11a-cc19c77fe4f2@linux.alibaba.com>
 <aVvDcEB583Yuolm_@bfoster>
 <2b12f63b-ceab-4d3e-a06f-f41e6b1b2d23@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <2b12f63b-ceab-4d3e-a06f-f41e6b1b2d23@linux.alibaba.com>
X-Rspam-User: 
X-Rspamd-Queue-Id: 15F90160006
X-Rspamd-Server: rspam10
X-Stat-Signature: p4iaxher4kot6gzaqqpb8sqd1ait57xc
X-HE-Tag: 1767725171-460840
X-HE-Meta: U2FsdGVkX1/xa4CQvKQhVSfY6SGY3E9FXAZs/K1bIvwKM+Nfsf+9BolD5m92njTewIDgNGnhcv+aAJeoEDw3iJ1md9m7Oo0iDpOyWh55SY+kZruKhwm/ubMucdt9PHyAUk0eALvQG/WvgoRh0uQtbJhFmJl0UkV1oWziGqyjxFa4N06Q4aQR7rymOYI+yhlBkk/qs3N1caDxa2JoqPI2JGifcnrBffhXjwyM6O4a4KDz3y/aMD4fmmQD/YnwmPy3BONP6YS/T0Y47aieDK4X/wkipjbEVCcphAbAK1yn91bIb3kqPfQwzai3ChNAjINDASNou/kKaGwWMlhSQGIp3m5wgb4pIoU3CJD8DWZ9lbKYNMK5CcIooIEJDODIU9rIuy5XCWyRnrFklB1DpyK4FJAHQJ59z7qKGh34ta/Bo4H8d1YfM08J9yaCK7HNJZ48wCfSv4uT44VoRi2wt0iT2LzA6DVe4Hs9v/iWhV4ar/ovpg2phnvxrRTEKJkEmoGBe9v3/DthUYvUku/bHt45apRgiiBz33A8C49eZqkevPsncbRmbZ0rgyZd3DSD/rrc65k1K0IpswLsHlBKNN2EefvRlP5cNXwLp72ZQWh5g7Dpn7zDY9UowDJhEiLQ1+BlmvPeuKcCVtvrLM2e9WOlC57EqOdtlUCOKlQuLI1TgVSyHGAhz2eKANmb9fxK71OCMCdUSkuvjVBpcGULIcgFuUdiKurAD/ImI4i7Kc2Q4/eKpsPSmelm4Ufc+Syn47uwsX8X8Md/USPXH+WwbeMF2FvAmdztTxv6ce5BR6xs6RbozfX83dk17r9+8rbCzJvniGmfOa++5fZKkKhZTQuZinwOIuxdEDz3EjEP4zsXJmJCaZpg2O/qJl42Icuw+K77JEg65vX0ig//99uLbYWgR3dxqNb+craGsmsaCmDu8y2OfLPg6U6Teg9WLsnwIcoVjE0aO5srEnVX6bPH3fV
 1I5At3A/
 MZ4O842jDReJULDD0iWiS4M1+tcwXI/zuUTdaBY+VO6EiLzOnp0e46HREyEj7rWu7+wBgUMyg3sGCpuqZoNluDijiFlA286zDMw5EX7ZibrLX5N0E222v7nXegnQGdjjXld84lQLhxDYzXBCFABKk+3VZv5mlDEFdOtzlDoJAirnqFLiniMxh8eC922T2BHySxZb0zph9Ewa8YauJ5aBes3D3GIXWilLCKTKXAsvv2g6gbDHmhmH+lWdVMpm3KrXEXlKsWf2rE/3EzHQaDjvzcTUturzhK6GeK+Px8kVvjzSzsCFhTWu+mSz0n/EaYdwIXWc9uITD4Bym1mKQorOh5pdoJIH/t8ZxU4JvvVIzxrP6D0wTHGJlsSl6wglDb0/Y4+Jk/inBVVGSJlidbZjHwjgWan+x+issVNdr
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jan 06, 2026 at 11:47:44AM +0800, Baolin Wang wrote:
> Why I prefer Barry's fix: First, the symlink folio is marked Uptodate after
> copying the symlink name, but the whole folio hasn’t been initialized, which
> seems unreasonable to me. Second, as I said before, using the 'PG_owner_2'
> flag to mark this uncommon case doesn’t seem worthwhile. Currently, IIUC the
> 'PG_owner_2' is only used by btrfs; if we ever want to remove the
> 'PG_owner_2', this uncommon symlink case shouldn’t block its removal.

PG_owner_2 is aliased with PG_mappedtodisk [1], so it's used by every
filesystem which uses buffer_heads (whether mentioned in that filesystem
or not).  btrfs was switched from using private_2 to using owner_2
a little over a year ago.  PG_owner_2 is not on the list of flags to be
removed; that's PG_private, PG_private_2 and PG_reserved.

[1] include/linux/page-flags.h:     PG_mappedtodisk = PG_owner_2,


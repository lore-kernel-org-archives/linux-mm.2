Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 90E3BC88E50
	for <linux-mm@archiver.kernel.org>; Mon, 14 Sep 2026 10:22:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 64F426B0088; Mon, 14 Sep 2026 06:22:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5FF9D6B008C; Mon, 14 Sep 2026 06:22:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4EE016B0092; Mon, 14 Sep 2026 06:22:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 262336B0088
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 06:22:29 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 69D24120252
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 10:22:28 +0000 (UTC)
X-FDA: 85211978376.18.2101291
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf09.hostedemail.com (Postfix) with ESMTP id DED4A140002
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 10:22:25 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=p2wi7jCq;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=g4fW+si0;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=3YH9x2Re;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=ekt6QP9Q;
	spf=pass (imf09.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789381346;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=luzLayfa4rHXL45QFB+GJQv0hHmRfCd3gxDCrJhimew=;
	b=xx6zh3/j0gjrN4ixo3gshxK4Jid8GBo1baKFwRfReocNIPA4TNvBCfoys1N7BOY1lV+u3F
	4ojT5Eu06g8KSDJpzrqW81rymC7ShUbTr2e/s4nkSj9voyTVQ4ea19AO9LYb+ntU/Zn9dA
	mvDYPCd6gnp1kAn8lbeOBRCa4N+w5Mc=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789381346;
	b=TtJELfgKGGh+/70hTRphj3R+v0iuEppA+akqBn8gFjQhXWhKguHZSyCYR6jdlvyru1dTBB
	FFJGVtEKP9BjTIU+iTEbxB+Mm4tZrVsdvRMTm9wAXeBThhdvy6EQqDkDmNQWFZdlx8uFrD
	WOsg+holyMmDFMbvmdHeR5rT//g6CQs=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=p2wi7jCq;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=g4fW+si0;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=3YH9x2Re;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=ekt6QP9Q;
	spf=pass (imf09.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 173C521ADA;
	Mon, 14 Sep 2026 10:22:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1789381340; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=luzLayfa4rHXL45QFB+GJQv0hHmRfCd3gxDCrJhimew=;
	b=p2wi7jCqQxMtDtt0SsJX+NDu1YtSlcItEir5Cv21ks6QnEMwGVCmcDrkR5kJTSI6nYgRcV
	pGq810eVTVfxv2SY5kw3iByF5JkocvR69W3AxecpcAsdrut6/sHHYR2VvwsKWLDOB5/chg
	P6uECxmfOOYvoB/zhKWFS1s00tCq8t8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1789381340;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=luzLayfa4rHXL45QFB+GJQv0hHmRfCd3gxDCrJhimew=;
	b=g4fW+si0DbGfirJ5Db7Wx8lw1R/j3jX/4JhaoyHqCn44N2t47tkSsfgEddDjhEtFkVBFc5
	WHIYkg8AvLpEjWDw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1789381336; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=luzLayfa4rHXL45QFB+GJQv0hHmRfCd3gxDCrJhimew=;
	b=3YH9x2ReN5DpSz5W5vfPn8wUxsHwFU5gl/qOIfVTasOSV3oj5HCsgPUPOUoh24VxCykh3r
	Xh/gXjjqkGMbhisDJSHhIfeW5Nn6WVk10BMjUfYWDDW/2Q5Ak0is5ZwZr9QTjk/dPecUPM
	beaT68eD94/xZVzXU3dX19wHad9n/6A=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1789381336;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=luzLayfa4rHXL45QFB+GJQv0hHmRfCd3gxDCrJhimew=;
	b=ekt6QP9QmhOVCfSgVrF8QGUctm83k9cFrXM4te530+y1kMuSZQr1wXBMtz8zApT85TR4UB
	BkbCxFvK25UeQTDw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id DDAFE13515;
	Mon, 14 Sep 2026 10:22:15 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 2tYaNtfKp2ogFAAAD6G6ig
	(envelope-from <jack@suse.cz>); Mon, 14 Sep 2026 10:22:15 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 6A623A12E4; Mon, 14 Sep 2026 12:22:07 +0200 (CEST)
Date: Mon, 14 Sep 2026 12:22:07 +0200
From: Jan Kara <jack@suse.cz>
To: Barry Song <baohua@kernel.org>
Cc: Jan Kara <jack@suse.cz>, Tal Zussman <tz2294@columbia.edu>, 
	Wenjie Qi <qwjhust@gmail.com>, willy@infradead.org, akpm@linux-foundation.org, 
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	stable@vger.kernel.org, axboe@kernel.dk, trond.myklebust@hammerspace.com, 
	jaegeuk@kernel.org, chao@kernel.org, qiwenjie@xiaomi.com
Subject: Re: [PATCH v4] mm: filemap: retain mapped dropbehind folios
Message-ID: <3pclzpr4f5qisxwqhjguk4zz7vwdbahzbjbgqryq2f5mpklddk@f5do4mayzzot>
References: <20260829111621.41ed2bc9a0e99e3367eb96c3@linux-foundation.org>
 <ef160933595c365f2c47597b260bc7ecd98ed7ce.1788029516.git.qiwenjie@xiaomi.com>
 <076bb01b-6fcf-4691-be8c-0e8507c9fe64@columbia.edu>
 <CAGsJ_4xMK=rPXCH5OiCOYHKRQp-w+xDJQusJ_ykbuAuLZr+8bA@mail.gmail.com>
 <1e5118a5-6b61-49d0-85e1-825e22059241@columbia.edu>
 <CAGsJ_4wj6XvPB+QF+_X1BJ_8Y2sZEEFAw6RaJJz-cHaDWLkxaQ@mail.gmail.com>
 <65a2c7df-0d2e-46de-9580-01e9c35a7e32@columbia.edu>
 <CAGsJ_4zS+UehT4wuTuTVjK3s3mhzp+dku8M-Of9cF=CN82aRow@mail.gmail.com>
 <hbki3yc23dr5fkre5phwx2ev6yjfn3ooodan37uo3at53y3gs2@kjyxyb34s5bi>
 <CAGsJ_4xNLEhrCZR-7ZAxBnYV8BDzuQT29yT419mObVRGH71AVg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAGsJ_4xNLEhrCZR-7ZAxBnYV8BDzuQT29yT419mObVRGH71AVg@mail.gmail.com>
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: yebnjwijhiuuhkfuu5zasugjj4af6e68
X-Rspamd-Queue-Id: DED4A140002
X-HE-Tag: 1789381345-239155
X-HE-Meta: U2FsdGVkX1/K4IkL6Bl26jSXk9EnFFwJUxMGTnJKh3aPBsZs+5Guj0TLFbBK6QvSvwqa2GZjA/sQjUVM8xJnCDb0Gd2XDPexwlZcrFQJvzntc1Ju9WrgMBv3bOBolr2tW4Wdsp6qeTKEBoQMmiWZjj/KxNZnULK+CLx0K3dYkLeTkTkzGu/q+/FtaDValJVa+t1zp9OXW2g9WqhuoPK7OXRdPXI3BtMYpd7ODZZ8KQWZojiwpSQaeU32Qagk6U4kvs3zUCj5Dwvxok5KG1Z/PScshsCUg3Jf/8fgncQwYwbc/eEiU+cr5isb2MPNlebeFY15yqTNlxvmt79+8JMuJIm3YIm5t2P0gOwn1i/ZOkAxs8hCweuOguRPRuDyHsZpy0O5EvPItT5Kk24pGVOTphfDV30+3RcjDVXlVDzNeUDJmfirDqqE7TmrRZnHh8Wvh1q0A2zVfLjj5TAAfP3zEifEiYo8hblp2f6MXcfL+0fagNnWXWvsX3srOyB0Mw2II8gzlDe/xmgKg+Fgn5MF4/B9tFPmElbN6SyERh883vqNE3pbRzB/lOsxL1DzTH6ESLb6wfdlppUEOYK/8g37B5uckPqwHupoYELOUHT4bL0PtwNi00c6/ayOCSVzjJH8iH3OLCdEOnB3pT0w9GksAJh3fAWb3qYvtA7taiN7oMxc0wb73eHFWEHFL4BFgW49mwlsC8ond2N0UpkzdSwe+ozPGyTN9rDiXPUOdFIlbujv/Nn6tG9UDYXWspCCKuowmMWQUowAwsqUTTgQiAmgsuT1Lcp0VU1gCscDMrRpe9ZVpkWcmyLCFv8G23HO9gfrEAAl9ek+iRsD1temFe3I/PvV63quyv1uEDDpRZ65hyFC/lRmh7k2vxzG6MpveUo9nph6Rz9NCWNUjSTT7BKCrXYsH2wUYvoStSek5s3/GphOmZiNdtAtYgZxKG1uAmG39zuJ/vpu132US5o+AKp
 oXs4B5Ep
 ezWa/lPw/q4v5AMfhAGYXHrqwfr/l1eZf/BDbcs2gTcjKyz608OZuJm9XmZYmQOVd+VICHQDrRDxUP94F4ZBO8ofnpb0kO1CEqth7g9uPK79/U2xLw2mB82I5Iw4wH+t0n6nepq3pF4r0kITc/uOKH4IWzd1hawGX8nsuVwmDX17Ei+XstXxr4BlRfTYp6RBhBQQBkrTiZ5aI/FJFcRkVmKmzxb9RhVjwfzFmN2GoZ+Ljrpn0T7RAn0GSloL2swZbrANFKNrvJUJxsgLBldylfkh1A3y/2u7Tm9no58p8E+okrbz+Oki6pZfPMHEdTULsC+t33LqDbdo5/zzSFRHmCOIP2GaNCN/tt+yiAoOhixhesagL/wEH95hMGiY8WRa0G8NCL2ph7avtL1iY6dYmPOYwHBarS6olOdonQisdgSuBHB8TLiz0gOhW/rNwMQOVVgdKn12/tyqXSdVqGgo/s8QvCH1hQuvkiw/g
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon 14-09-26 17:42:59, Barry Song wrote:
> On Mon, Sep 14, 2026 at 5:33 PM Jan Kara <jack@suse.cz> wrote:
> >
> > On Mon 14-09-26 09:09:32, Barry Song wrote:
> > > On Mon, Sep 14, 2026 at 7:34 AM Tal Zussman <tz2294@columbia.edu> wrote:
> > > >
> > > > On 9/13/26 6:51 PM, Barry Song wrote:
> > > > > On Fri, Sep 4, 2026 at 6:36 AM Tal Zussman <tz2294@columbia.edu> wrote:
> > > > >>
> > > > >> On 9/4/26 12:28 AM, Barry Song wrote:
> > > > >> > On Sun, Aug 30, 2026 at 7:59 PM Tal Zussman <tz2294@columbia.edu> wrote:
> > > > >> >>
> > > > >> >> On 8/30/26 6:25 AM, Wenjie Qi wrote:
> > > > >> >> > From: Wenjie Qi <qiwenjie@xiaomi.com>
> > > > >> >> >
> > > > >> >> > Fault-around can map ready dropbehind folios without going through the
> > > > >> >> > normal page-cache lookup that clears dropbehind. A mapping represents a
> > > > >> >> > competing cached user, but writeback completion can currently unmap that
> > > > >> >> > folio. A later mmap access must then fault it back in.
> > > > >> >> >
> > > > >> >> > Retain mapped folios instead. For a mapped folio,
> > > > >> >> > folio_unmap_invalidate() can call unmap_mapping_folio(), which takes
> > > > >> >> > i_mmap_rwsem and may sleep. Retaining the folio also avoids this path when
> > > > >> >> > folio_end_dropbehind() runs in non-preemptible task context.
> > > > >> >> >
> > > > >> >> > Unmapped dropbehind folios continue through the existing invalidation path.
> > > > >> >> >
> > > > >> >> > Fixes: fb7d3bc41493 ("mm/filemap: drop streaming/uncached pages when writeback completes")
> > > > >> >> > Cc: stable@vger.kernel.org
> > > > >> >> > Signed-off-by: Wenjie Qi <qiwenjie@xiaomi.com>
> > > > >> >> > Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>
> > > > >> >> > Reviewed-by: Tal Zussman <tz2294@columbia.edu>
> > > > >> >> > ---
> > > > >> >> > The mapped-plus-dropbehind state was reproduced in QEMU. The patched
> > > > >> >> > kernel retained the mapped folio and continued to evict the unmapped
> > > > >> >> > dontcache folio. I did not reproduce the sleeping-in-atomic warning and
> > > > >> >> > am not aware of an existing report.
> > > > >> >> >
> > > > >> >>
> > > > >> >> I was able to trigger the sleeping-while-atomic BUG on current mainline with
> > > > >> >> some help from Claude. The reproducer itself is straightforward enough, but the
> > > > >> >> configuration was a little finicky. The atomic context comes from using
> > > > >> >> threadirqs so that virtblk_done() completes requests from the irq thread under
> > > > >> >> local_bh_disable() and the vq spinlock with irqs off, so in_task() is true but
> > > > >> >> the i_mmap_rwsem down_read() sleeps. It also needed 1 vCPU (so completion stays
> > > > >> >> in the irq thread rather than softirq) and ext4 -o dioread_lock (so end_io runs
> > > > >> >> inline instead of on a workqueue). With v4 applied the bug is gone, so:
> > > > >> >>
> > > > >> >
> > > > >> > Thanks, Tal. Then I'm getting quite confused. Since with Wenjie's
> > > > >> > patch, we are no longer going to sleep for dropbehind in `filemap.c`,
> > > > >> > do we still need all the complex logic in the block device and file
> > > > >> > system layers to move dropbehind to a workqueue task context?
> > > > >> >
> > > > >>
> > > > >> Hi Barry,
> > > > >>
> > > > >> Let me clarify. Wenjie's patch prevents sleeping in a very specific case.
> > > > >> The existing in_task() check covered most other cases, in that it just
> > > > >> doesn't do dropbehind invalidation if we're not executing in task context
> > > > >> (for example, block device writeback completing in interrupt context).
> > > > >>
> > > > >> However, dropping the invalidation defeats the point of dropbehind, as it
> > > > >> leaves the pages in the page cache. If we get rid of the task-context
> > > > >> deferral mechanism, we wouldn't sleep, but we also wouldn't invalidate.
> > > > >> Wenjie's change is largely unrelated to this.
> > > > >
> > > > > Hi Tal,
> > > > >
> > > > > Thanks for the clarification. However, I’m still not convinced.
> > > > >
> > > > > If `unmap_mapping_folio()` is the only place where we might
> > > > > sleep — where we might take `mapping->i_mmap_rwsem` through
> > > > > `i_mmap_lock_read()`, as Wenjian pointed out in [1] — we have now
> > > > > prevented that from happening with `if (!folio_mapped(folio))`.
> > > > >
> > > > > So no mapped folio should call `folio_unmap_invalidate()`:
> > > > >
> > > > > static void filemap_end_dropbehind(struct folio *folio)
> > > > > {
> > > > >          struct address_space *mapping = folio->mapping;
> > > > >
> > > > >          VM_BUG_ON_FOLIO(!folio_test_locked(folio), folio);
> > > > >
> > > > >          if (folio_test_writeback(folio) || folio_test_dirty(folio))
> > > > >                  return;
> > > > >          if (!folio_test_clear_dropbehind(folio))
> > > > >                  return;
> > > > >          if (mapping && !folio_mapped(folio))
> > > > >                  folio_unmap_invalidate(mapping, folio, 0);
> > > > > }
> > > > >
> > > > > Why do we still need the `in_task()` check in
> > > > > `folio_end_dropbehind()`?
> > > > >
> > > > > void folio_end_dropbehind(struct folio *folio)
> > > > > {
> > > > >          if (!folio_test_dropbehind(folio))
> > > > >                  return;
> > > > >
> > > > >          /*
> > > > >           * Hitting !in_task() should not happen off RWF_DONTCACHE writeback,
> > > > >           * but can happen if normal writeback just happens to find dirty folios
> > > > >           * that were created as part of uncached writeback, and that writeback
> > > > >           * would otherwise not need non-IRQ handling. Just skip the
> > > > >           * invalidation in that case.
> > > > >           */
> > > > >          if (in_task() && folio_trylock(folio)) {
> > > > >                  filemap_end_dropbehind(folio);
> > > > >                  folio_unlock(folio);
> > > > >          }
> > > > > }
> > > > >
> > > > > Could any other operation in `folio_unmap_invalidate()` sleep for
> > > > > unmapped folios? Otherwise, it seems we don't need `in_task()` at
> > > > > all?
> >
> > We do need it. folio_unmap_invalidate() calls filemap_release_folio() which
> > calls into ->release_folio() handler and generally filesystems are allowed
> > to sleep in this handler. Now usually they don't actually sleep there but
> > they definitely grab a lot of irq unsafe locks there as Tal writes below.
> 
> Hi Jan,
> 
> Thanks very much for your explanation. That makes a lot of
> sense to me.
> 
> Then, based on the above, I am getting into another confusion and
> have another question. If `release_folio()` is actually allowed
> to sleep, and some filesystem might sleep there in the future,
> wouldn't Wenjie's patch [1] make sense in that case, as it
> guarantees that `->release_folio()` is always called in a
> sleepable context, while `in_task()` does not provide such a
> guarantee?
> 
> https://lore.kernel.org/linux-mm/20260820142956.1414337-1-qiwenjie@xiaomi.com/

Well, adding the folio_mapped() check makes sense as well as Matthew
explained - we shouldn't be dropping mapped folios(). But yes, now that
you've made me look into this I don't think dropping the in_task() check
here is correct and we still need to make sure that *at least* we are in
non-interrupt context and preferably to keep fs maintainer's sanity in a
sleepable context. Matthew?

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR


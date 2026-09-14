Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D228DC88E64
	for <linux-mm@archiver.kernel.org>; Mon, 14 Sep 2026 09:34:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D1EE06B0095; Mon, 14 Sep 2026 05:34:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CF79E6B0096; Mon, 14 Sep 2026 05:34:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C0EF26B0098; Mon, 14 Sep 2026 05:34:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 9F6226B0095
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 05:34:12 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 0604D1C0B2C
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 09:33:05 +0000 (UTC)
X-FDA: 85211853930.28.E2F7819
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf12.hostedemail.com (Postfix) with ESMTP id AEE1C40004
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 09:33:02 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=LbIDoKjN;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=XRF123uR;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=nMwfz1Sg;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=0sRxt1xJ;
	spf=pass (imf12.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789378383;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XlsJ7pXjtqm+GzQ+2zmJwqm6kI3CiTcOpGOda6jqVgA=;
	b=FbuVjDSiAKQOV7KpJqhxsP/XcZ/3iGjj1ZrsAju3xIVxLTNZS8GLvlE7JrOx5h4ntodXtL
	SzHX/UU4sjCDRM74nPxLSzRTVB9LWRnUr+f6zpAr4S7RSD1ZAkXhxqqutNa4SFCSdmBsat
	xYHdC45jO6FLpTlAnxIsJlz/8kWU4K0=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=LbIDoKjN;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=XRF123uR;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=nMwfz1Sg;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=0sRxt1xJ;
	spf=pass (imf12.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789378383;
	b=VBuftqmjMIhIW5w4IaZ2P1bhxohexLRIC28WxUFMXwBmoS2wQulFGlPhUCC1msUPghZEaj
	CpYSqd/d1FMACzcC/s7MDG4eaHhd3e84Aw68DOpOGfoqvvKVymxUGPGP3NP62F/yKFs4vF
	EACMZj6ppk9kcTE/u6z6MpMtUQ5WYWw=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id C89EE1F45E;
	Mon, 14 Sep 2026 09:32:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1789378377; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=XlsJ7pXjtqm+GzQ+2zmJwqm6kI3CiTcOpGOda6jqVgA=;
	b=LbIDoKjNeXoce6+Au8AUEmijy9fOusYZyTZUtJIZRWjyLl6mAxI2CHfcE8lxC3LfVyTq4V
	FOi0ZyXOpbwV+ceni0eQ35T1oqrF3DBiyZhaMLkTolyxBvJ+PtSTTIK4hGhiUHfQQ16kgW
	5zui2dRs127w1G0rbHsZbVJQIsF8k7o=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1789378377;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=XlsJ7pXjtqm+GzQ+2zmJwqm6kI3CiTcOpGOda6jqVgA=;
	b=XRF123uRxImNUf9YrAcZypZwpkHHDigE22v1nuf4vasiaLeELcfsShNR6obW8JuOen/B0x
	nYkeSHJi7lPGkUBQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1789378372; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=XlsJ7pXjtqm+GzQ+2zmJwqm6kI3CiTcOpGOda6jqVgA=;
	b=nMwfz1Sgx3+zFjCPJptoAizAv9jEuAuj3+63p+1uS9zSZup/ZeZ/hQoT9DUjbphthhpMsG
	j+qzl/oag9dJnrDvMYEurA/JC1WJfOdA9N+Bi4v00ub9sQjRGyMiDYykzYHrn2q3uplxrW
	eGDw40MayqyWozqxSA3kepwx1PRV1zk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1789378372;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=XlsJ7pXjtqm+GzQ+2zmJwqm6kI3CiTcOpGOda6jqVgA=;
	b=0sRxt1xJhYVpOLEuHiB88wnuBlg5CP/Qv0UxLrrVRNYKn9JO9RbVU8ZR04NSVQq7vvOG39
	nc4d7DOAVWLfnZCA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 9D4A91368C;
	Mon, 14 Sep 2026 09:32:52 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id uTVgJkS/p2prXQAAD6G6ig
	(envelope-from <jack@suse.cz>); Mon, 14 Sep 2026 09:32:52 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 2E0A2A12E4; Mon, 14 Sep 2026 11:32:52 +0200 (CEST)
Date: Mon, 14 Sep 2026 11:32:52 +0200
From: Jan Kara <jack@suse.cz>
To: Barry Song <baohua@kernel.org>
Cc: Tal Zussman <tz2294@columbia.edu>, Wenjie Qi <qwjhust@gmail.com>, 
	willy@infradead.org, jack@suse.cz, akpm@linux-foundation.org, 
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	stable@vger.kernel.org, axboe@kernel.dk, trond.myklebust@hammerspace.com, 
	jaegeuk@kernel.org, chao@kernel.org, qiwenjie@xiaomi.com
Subject: Re: [PATCH v4] mm: filemap: retain mapped dropbehind folios
Message-ID: <hbki3yc23dr5fkre5phwx2ev6yjfn3ooodan37uo3at53y3gs2@kjyxyb34s5bi>
References: <3fa43eaca792bc0bbde4b82a6c1fcdd3f528b398.1787999152.git.qiwenjie@xiaomi.com>
 <4aba05e1a2c3b61cb337d373eb9b7a8db4ddd822.1788024049.git.qiwenjie@xiaomi.com>
 <20260829111621.41ed2bc9a0e99e3367eb96c3@linux-foundation.org>
 <ef160933595c365f2c47597b260bc7ecd98ed7ce.1788029516.git.qiwenjie@xiaomi.com>
 <076bb01b-6fcf-4691-be8c-0e8507c9fe64@columbia.edu>
 <CAGsJ_4xMK=rPXCH5OiCOYHKRQp-w+xDJQusJ_ykbuAuLZr+8bA@mail.gmail.com>
 <1e5118a5-6b61-49d0-85e1-825e22059241@columbia.edu>
 <CAGsJ_4wj6XvPB+QF+_X1BJ_8Y2sZEEFAw6RaJJz-cHaDWLkxaQ@mail.gmail.com>
 <65a2c7df-0d2e-46de-9580-01e9c35a7e32@columbia.edu>
 <CAGsJ_4zS+UehT4wuTuTVjK3s3mhzp+dku8M-Of9cF=CN82aRow@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAGsJ_4zS+UehT4wuTuTVjK3s3mhzp+dku8M-Of9cF=CN82aRow@mail.gmail.com>
X-Rspam-User: 
X-Stat-Signature: 8mhjigojcmsai7wr3546x534aa7t18xt
X-Rspamd-Queue-Id: AEE1C40004
X-Rspamd-Server: rspam07
X-HE-Tag: 1789378382-593850
X-HE-Meta: U2FsdGVkX19F1YWnKBVtYzijoz4p7TFraglziRPXij2v5TuxKylTkTiQry3M75LlRF4J51ws71RG1u2/M5Ibv0VHDHb+Wb/c2KZlCS8ejuAHSGqRqSLgmuy8DgMmVwJpgs/942CGnAfAQF0RJIfxEO0sHC+GdUSbMM3g2TZtAycZfTniZIjboktvIe0oZQDeutMo+fzjZxzjhOotC7WHYAH7UQGrhie1I0m7u76iuZIKPpE7u65I34z/wjziGl1Av8s1+T2bTF2pcgNRl1ZkCPIEt2ERp5z0ILFbi6GPSOnXqrcz0z3NFHrfwRypcbh79LVUwlob3mGy1mso5dXo1Auyn6xUHeQFV6wbI7xJETNQZiA9LksvYCyupogWbscM1cV7S0O/pX1cBULnZASPVV/IPNyh/DeigBGSRbS0CyR32k1v4eP+wV6D1s5U3g4SphMGTfzXBHIDYVRIZOn8z3bQIYX5flRTvK/ouCN7wqNj0SOPvDnqJL5Ckmf0c3pJIWAq+DMRb1R0rHb+vfBA5PJMgfcRa4c5x9ZgHpeQCEJBXpsnW1M0SN2WTPQcBIe3WpHjkCRIG3+/BLLP2LJfO6vnIrwVgswyhKzmMstkyQk5vtrIYjKVszMWE/4x0qDzVOu1QTmrFWJ/5HmHWRxN9U7fXOavppPMbip4PSjMNAzth8UQ84jB8qr8TkD7XkSXZcIByt403FH2rqr+EnprmcwmuAJPOZV/h3eVmwNdDgBO0fRz05zvcpZ2Fk27OtJXObB4Hm226gnQXV7JsAPP7ZTrT7m7eESdb34tfAj8jqu0AVAttLxwHEa9cxsz1kKU43QIh/sKox3fkKbj+pql1zCRUwE9HsM2fppa1ADn3jsD1dXSynAo+LuSwOki6KtMjgergLugl3lVio9kVf/YmHmbS0pSN/5z42sHWGZVFj54sHoUUVU7MkwRBGmc2MMfCk0TTw3E6iRO+JYyBMa
 czCaNrA2
 QNUJK+Vf11aqQ8trDoK1e/BOBhGQM4nhSeQJWEczPuG1L6jWV8bT1TH976WqwWbnvUugG+hlhHU82wvKjPIfx6cFNhnVA+bsuE/12x4D59E+2vCNBbKyNIaHYUw+dcVW1R9RLgTYlHk6Qviy7nEXcOFzwPmlnbe60Jpwf7EumD8xQjzP6PEiNMYlumIx8KhtPZygz0vXF7/BolWWcqDAjIFmtLVtLtzjwfxE9XAx/lZ4C9F9uscfx+QZwvtwz92Urp39uMuf0Cn7fwgz6YwQAShXYd7I0Ca5KBvpydDYn9qVF+pkCWSc9Pmdl/D+Gyy2+AIV8UiYbpQMW1q6uU8oudDocOSz3V65bLbelIo17Ni2IHXDWhvNBY+CT1OP0LxslGm/EJgv5AYn8A3ubIsgkPgIsRdbCHIgUZyuV5oQs4A76hoz4rQmZS+wiQ5gp5NssQsg0fP8yWwC9NdLSoAeKfm13gWOTyhsq8G3g
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon 14-09-26 09:09:32, Barry Song wrote:
> On Mon, Sep 14, 2026 at 7:34 AM Tal Zussman <tz2294@columbia.edu> wrote:
> >
> > On 9/13/26 6:51 PM, Barry Song wrote:
> > > On Fri, Sep 4, 2026 at 6:36 AM Tal Zussman <tz2294@columbia.edu> wrote:
> > >>
> > >> On 9/4/26 12:28 AM, Barry Song wrote:
> > >> > On Sun, Aug 30, 2026 at 7:59 PM Tal Zussman <tz2294@columbia.edu> wrote:
> > >> >>
> > >> >> On 8/30/26 6:25 AM, Wenjie Qi wrote:
> > >> >> > From: Wenjie Qi <qiwenjie@xiaomi.com>
> > >> >> >
> > >> >> > Fault-around can map ready dropbehind folios without going through the
> > >> >> > normal page-cache lookup that clears dropbehind. A mapping represents a
> > >> >> > competing cached user, but writeback completion can currently unmap that
> > >> >> > folio. A later mmap access must then fault it back in.
> > >> >> >
> > >> >> > Retain mapped folios instead. For a mapped folio,
> > >> >> > folio_unmap_invalidate() can call unmap_mapping_folio(), which takes
> > >> >> > i_mmap_rwsem and may sleep. Retaining the folio also avoids this path when
> > >> >> > folio_end_dropbehind() runs in non-preemptible task context.
> > >> >> >
> > >> >> > Unmapped dropbehind folios continue through the existing invalidation path.
> > >> >> >
> > >> >> > Fixes: fb7d3bc41493 ("mm/filemap: drop streaming/uncached pages when writeback completes")
> > >> >> > Cc: stable@vger.kernel.org
> > >> >> > Signed-off-by: Wenjie Qi <qiwenjie@xiaomi.com>
> > >> >> > Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>
> > >> >> > Reviewed-by: Tal Zussman <tz2294@columbia.edu>
> > >> >> > ---
> > >> >> > The mapped-plus-dropbehind state was reproduced in QEMU. The patched
> > >> >> > kernel retained the mapped folio and continued to evict the unmapped
> > >> >> > dontcache folio. I did not reproduce the sleeping-in-atomic warning and
> > >> >> > am not aware of an existing report.
> > >> >> >
> > >> >>
> > >> >> I was able to trigger the sleeping-while-atomic BUG on current mainline with
> > >> >> some help from Claude. The reproducer itself is straightforward enough, but the
> > >> >> configuration was a little finicky. The atomic context comes from using
> > >> >> threadirqs so that virtblk_done() completes requests from the irq thread under
> > >> >> local_bh_disable() and the vq spinlock with irqs off, so in_task() is true but
> > >> >> the i_mmap_rwsem down_read() sleeps. It also needed 1 vCPU (so completion stays
> > >> >> in the irq thread rather than softirq) and ext4 -o dioread_lock (so end_io runs
> > >> >> inline instead of on a workqueue). With v4 applied the bug is gone, so:
> > >> >>
> > >> >
> > >> > Thanks, Tal. Then I'm getting quite confused. Since with Wenjie's
> > >> > patch, we are no longer going to sleep for dropbehind in `filemap.c`,
> > >> > do we still need all the complex logic in the block device and file
> > >> > system layers to move dropbehind to a workqueue task context?
> > >> >
> > >>
> > >> Hi Barry,
> > >>
> > >> Let me clarify. Wenjie's patch prevents sleeping in a very specific case.
> > >> The existing in_task() check covered most other cases, in that it just
> > >> doesn't do dropbehind invalidation if we're not executing in task context
> > >> (for example, block device writeback completing in interrupt context).
> > >>
> > >> However, dropping the invalidation defeats the point of dropbehind, as it
> > >> leaves the pages in the page cache. If we get rid of the task-context
> > >> deferral mechanism, we wouldn't sleep, but we also wouldn't invalidate.
> > >> Wenjie's change is largely unrelated to this.
> > >
> > > Hi Tal,
> > >
> > > Thanks for the clarification. However, I’m still not convinced.
> > >
> > > If `unmap_mapping_folio()` is the only place where we might
> > > sleep — where we might take `mapping->i_mmap_rwsem` through
> > > `i_mmap_lock_read()`, as Wenjian pointed out in [1] — we have now
> > > prevented that from happening with `if (!folio_mapped(folio))`.
> > >
> > > So no mapped folio should call `folio_unmap_invalidate()`:
> > >
> > > static void filemap_end_dropbehind(struct folio *folio)
> > > {
> > >          struct address_space *mapping = folio->mapping;
> > >
> > >          VM_BUG_ON_FOLIO(!folio_test_locked(folio), folio);
> > >
> > >          if (folio_test_writeback(folio) || folio_test_dirty(folio))
> > >                  return;
> > >          if (!folio_test_clear_dropbehind(folio))
> > >                  return;
> > >          if (mapping && !folio_mapped(folio))
> > >                  folio_unmap_invalidate(mapping, folio, 0);
> > > }
> > >
> > > Why do we still need the `in_task()` check in
> > > `folio_end_dropbehind()`?
> > >
> > > void folio_end_dropbehind(struct folio *folio)
> > > {
> > >          if (!folio_test_dropbehind(folio))
> > >                  return;
> > >
> > >          /*
> > >           * Hitting !in_task() should not happen off RWF_DONTCACHE writeback,
> > >           * but can happen if normal writeback just happens to find dirty folios
> > >           * that were created as part of uncached writeback, and that writeback
> > >           * would otherwise not need non-IRQ handling. Just skip the
> > >           * invalidation in that case.
> > >           */
> > >          if (in_task() && folio_trylock(folio)) {
> > >                  filemap_end_dropbehind(folio);
> > >                  folio_unlock(folio);
> > >          }
> > > }
> > >
> > > Could any other operation in `folio_unmap_invalidate()` sleep for
> > > unmapped folios? Otherwise, it seems we don't need `in_task()` at
> > > all?

We do need it. folio_unmap_invalidate() calls filemap_release_folio() which
calls into ->release_folio() handler and generally filesystems are allowed
to sleep in this handler. Now usually they don't actually sleep there but
they definitely grab a lot of irq unsafe locks there as Tal writes below.

								Honza

-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR


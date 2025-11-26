Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 51AD3D11195
	for <linux-mm@archiver.kernel.org>; Wed, 26 Nov 2025 19:34:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6919F6B0031; Wed, 26 Nov 2025 14:34:37 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 61B126B00A0; Wed, 26 Nov 2025 14:34:37 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 509EF6B00B5; Wed, 26 Nov 2025 14:34:37 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3B1446B0031
	for <linux-mm@kvack.org>; Wed, 26 Nov 2025 14:34:37 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id D6FFCB9573
	for <linux-mm@kvack.org>; Wed, 26 Nov 2025 19:34:36 +0000 (UTC)
X-FDA: 84153760152.03.D906C07
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf28.hostedemail.com (Postfix) with ESMTP id A55EDC0015
	for <linux-mm@kvack.org>; Wed, 26 Nov 2025 19:34:34 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=AeDmO31G;
	spf=none (imf28.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764185675;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+4PsG4KS5viIMpUzolb18sI5e4MHIMIC9VS3ZftSk8s=;
	b=WzkItXVleCdVC7CbrgBWajCGlfBzDdPunGmxuB1TGyNh0tf7jJlnzemv5eCXpEOqwnh6qc
	evgrunPUgKIiJ6nBqNRa9Juxhdjui7gAQI23VlzkK4TU47qIj3JIcCYi2aqi92QtvP2HVV
	8UlH/sZBhOAxRFd34Cmf+zTvYoFNxZ0=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=AeDmO31G;
	spf=none (imf28.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764185675; a=rsa-sha256;
	cv=none;
	b=X0I/N/hMwqrRwYINmV53XrDbg2RE0244/oLus5tTRLAsF/gQwiiG/KqA1b2jNOA4ke41wr
	9wEL28RVSefXzVM2ywu2sF7xut0PDOjtRa2YAHZPAkUShdFmLKFd+zQ8IGrJtP2Hr7wHMD
	WhZk/SkTaDlAVUlWC/mp3lXKNTB+nD0=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Transfer-Encoding:
	Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:
	Sender:Reply-To:Content-ID:Content-Description;
	bh=+4PsG4KS5viIMpUzolb18sI5e4MHIMIC9VS3ZftSk8s=; b=AeDmO31Gq1mxzxWdjdAkVeBMSp
	i/yYNFurcre8Mv2s7eckgkk3SizvtimkRxY5b3h5gbYBQtbcZvsBCkxL0CqT4c5VvoYn1e0QuIBAe
	f2UCj1wz2tTjCDKOOTYFT/IYevcNQenfcbfM3tdzgZI8iAlUPO0bEz9kqDrj/qQ0I2YGsO3pNE8re
	yIZhpfiBmy0OQOgNky+N7mRTFcP5dtEGMhEkDkRZVxbzby3PIlcueKhGqa6cZyMDSSjEug9+3sRYT
	pL+zZuRXSNoCSheQt/yvNm4bE+h/shFOwZ8x8NrmOrWjYMkr/rrC3Rmku8/UTPC+B88FyYoiA9iT3
	2jWpy2BQ==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vOLHb-0000000Ac34-1Axl;
	Wed, 26 Nov 2025 19:34:31 +0000
Date: Wed, 26 Nov 2025 19:34:31 +0000
From: Matthew Wilcox <willy@infradead.org>
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Suren Baghdasaryan <surenb@google.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
	syzbot+5b19bad23ac7f44bf8b8@syzkaller.appspotmail.com,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>
Subject: Re: [PATCH v2] mm: fix vma_start_write_killable() signal handling
Message-ID: <aSdWR9GRe93VfrcC@casper.infradead.org>
References: <20251126174500.2498895-1-willy@infradead.org>
 <c35ab0c0-97c3-4565-ba2d-5c418ecac593@lucifer.local>
 <aSdGvY2UzrXdR2e3@casper.infradead.org>
 <CAJuCfpHheus2oiv94r14afjVV00XZnfqHY0p+H8fxjxCSYjg9g@mail.gmail.com>
 <ae18d781-86a3-4539-9441-079b7f45e726@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ae18d781-86a3-4539-9441-079b7f45e726@suse.cz>
X-Rspamd-Queue-Id: A55EDC0015
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: z3r98wgbyrx5shpwowi41wxixsgemxfd
X-HE-Tag: 1764185674-334169
X-HE-Meta: U2FsdGVkX19phdAcvN6EyIGxLCe9urOSs0AIFM7+ML17n3U0VFR3Agrsb/lc0B7WFatBehdy15EwpYCDLvnWoORlMOJ85LbE07wB2wtYx4oyF5EyLwhwhxmB6SWJ7bjl/i/YmJ+SxRT1ZzFr1g03n+LVNdRZweyypY+ioebi2Z1wB1F2MvMY6UxhWhpV8rv+WW/HrmL16ogSX8tTa1jh0OTeH5VtcgHn2+Xl9LEJi9PYo9qk/xYy+7CzFAeXc7n2jWfnFI0Zx6EnjL0ZHZi3gEfGVyuxCN4b5jdAhpeYOjB+5JGvfiQulZBkS9oIAKi0zyjS6Secup+ksyfF+qdnCYpgYwZEa10SvM03LSJo5GVfZos3svJsryBvilfJ4FubLu1MTch2DkUbLP0UcBGRLE50XxUiyfU1P2CWUzlemYQFabCqymInT9kpVtK1gybIqb2/O/IhQqunfHVRmccpcNv00WlTWcqVivjLuVH/ZgPEzpYmCPTrQqRQ0zAae+I4JJD5ljgFXU6J8lvdleoAgbzb4ZqlIUkHp8/uAicZ/33rx+LZd91ZbUKFRN6F5sg96KnksRw8Ucxp7QY0HH7qJi5TEygNkL6UE6afXnK4/RcRPYKYHAgKz9uw7D03LxXPTEYkv/uqZp8/uqqpnU0S4/AYZZQnB5jhF07Yo26NAAfoljUaEZHZQePbogqP8omcmwaCOnpvs7qyM28GLhBjQxD90SbyDja01yElC4uqwXOsix0YzLbKq+9UkBfMsYRtL6aNort6o04slGL2PGxIi89JIJG10Trn7bj8/rc1c32M6M7b/AXOwsJkx9Kk0CjHImWGA9NOzl2ieWqgo8Wn2nrVqxx35oovczwylYmHuY7Qt/4AHtPVMb79j1Y/XqEoTYTPZWJ5SXI7M//tWBE85cz9P25+24al04Gbb4u935ZBJO+sN497Hb4+bZP+qBimEm4muQkZy8xQknKf8px
 AqG3f2IX
 wtEbtuvCNkqtfFT3z8uqe+x0LOR3RgLu1H0LgERKK8PmBh9SQwtgZ7OljGjzPSp9NvRstEHkHde+caMhT+xMFsBJu6TGikxPZlsUyk7GW6AgzazKuASugmpNxjpNxy+ei4hUrhTxs1lJ3lnJy9reQ1WbCr8pKWwLsND64dhfEL7elFj8ck+e/Z4GfkyOi8mbF5qSrES8xDTe1edmyIr3lLocuED+sxzaDu5LxQQfdkZT78XKJ9IunnFJJI36TijyzzTyq9kSn49UR250aqHVRoiC1f+4UxTo/4MgwDBzL3bdz0eZDwbrAGbD4sHpRZ90+1F1BKV6ueebGE3qwGspejn0ZuqsX2xhw4MlxOH7i4C8jxLp0sOP9iVI6NkVfC9QxUr2HHsY4n/HFth3z1o8xf3tuQ3ZAr+7Z7kYmEIzSvL6Dxz1ijcnQL8D6XWU4A44HQbGHGq/TzI/nGhGO6zFAz6MM68PBSpsp4Evg+hTUa0na7672zmcdvl7LlwbWgEp2YdceMASbDJ0HUDUjQ8UZGGC/FG8MOxoUML1ZpZAfIzbSzQ/ocE/4LzbgCKlocDNq+KcrM/+W10k4S5s=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Nov 26, 2025 at 07:53:13PM +0100, Vlastimil Babka wrote:
> On 11/26/25 7:43 PM, Suren Baghdasaryan wrote:
> > On Wed, Nov 26, 2025 at 6:28 PM Matthew Wilcox <willy@infradead.org> wrote:
> >>
> >> On Wed, Nov 26, 2025 at 06:06:53PM +0000, Lorenzo Stoakes wrote:
> >>> On Wed, Nov 26, 2025 at 05:44:58PM +0000, Matthew Wilcox (Oracle) wrote:
> >>>> If we get a signal, we need to restore the vm_refcnt.  We don't think
> >>>> that the refcount can actually be decremented to zero here as it
> >>>> requires the VMA to be detached, and the vma_mark_detached() uses
> >>>> TASK_UNINTERRUPTIBLE.  However, that's a bit subtle, so handle it
> >>>> as if the refcount was zero at the start of this function.
> >>>>
> >>>> Reported-by: syzbot+5b19bad23ac7f44bf8b8@syzkaller.appspotmail.com
> 
> Closes: https://lore.kernel.org/all/69252076.a70a0220.d98e3.009b.GAE@google.com/
> 
> Unfortunately the reported-by code doesn't work as message id

Hm, that seems like a bug in syzbot.  The mail it sends doesn't use
the word "Closes:" anywhere; it just asks for Reported-by: and Fixes:
If that's not enough, then it should also ask for Closes.

> >>> Really think we should WARN_ON_ONCE() as Vlasta suggested.
> 
> Thanks Lorenzo!
> 
> Can we at least add a "WARN_ON_ONCE(!detaching);" before "err = 0;".

That makes sense; it mirrors the similar calls in the callers of
__vma_exit_locked().



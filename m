Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 51D41C5DF81
	for <linux-mm@archiver.kernel.org>; Fri, 21 Aug 2026 03:30:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 260236B0095; Thu, 20 Aug 2026 23:30:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 211C56B009B; Thu, 20 Aug 2026 23:30:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 14E4A6B009D; Thu, 20 Aug 2026 23:30:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E24EC6B0095
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 23:30:07 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 706E84036B
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 03:30:07 +0000 (UTC)
X-FDA: 85123848054.30.6DB36D2
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf17.hostedemail.com (Postfix) with ESMTP id E092740002
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 03:30:04 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=tTOV7oag;
	spf=pass (imf17.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787283005;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JyBcECjGqB6YkJ8I2MHh23SUvivGmImufXpX35W4aEk=;
	b=Itfag4Lst7bAWCnUyDwMpRdtdbyyy9u59OLvipZHfrwr93TJYfMbgIBgTf54a6Xlzk/lfI
	GJLTOVBlsqgiUorENpTu+pGLiap6h4NAiNZKSFE3itmm4pMYoIuYPBCvJndAhJO4AmCgjM
	NQY33qEKsFyxmFzJE0ivOvwWbOjCvws=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787283005;
	b=dUoXu8mawavJZj+PW8yBHL0KhoS6vSg+u3jhD2GRY0FgHgVjmsamGc41/8guVXRsZHE+Qe
	Y092VaYq6Vb11cqaNcPo2g9RsHteehEMfw8XYLlAUa/ap6aGmvOIObyz1yp73iFequfP3b
	HH3f6kWql63dwNcqLKJetOnSJLtY7nA=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=tTOV7oag;
	spf=pass (imf17.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Transfer-Encoding:
	Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:
	Sender:Reply-To:Content-ID:Content-Description;
	bh=JyBcECjGqB6YkJ8I2MHh23SUvivGmImufXpX35W4aEk=; b=tTOV7oagZmw4c61HKLFUVhiIlo
	IQ9AB3Ko1UOtHTeV/Ir4hjgTFOXlmpn/lYREXaz+4Twk7oYQqTLbWCyiKRs81m4i/jvOjivEtovVi
	92QgQDFU3fYPhdsG3XTofZ+ORQpB5dCaY5TZfQuCcLNOdfMbl3Jgs9MZitQI4jVLOGmmIn29JzPhW
	QU1zN5Oh/QiD7AiYKY2P0A1YU+OZ1cGw/T+OTmc3qoo/xvJgFNlbQUKQZUtrh7gJdR6qI59scZY6t
	EthXa4SrIF8H1ikALpaD3KPJXGOFXD71ogVqbcvZVbXPzb7fASdym4L6FZNatv92jHqjQ2NWxdl+G
	TtNoZG3Q==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wxFxB-0000000GhCP-3R9h;
	Fri, 21 Aug 2026 03:30:01 +0000
Date: Fri, 21 Aug 2026 04:30:01 +0100
From: Matthew Wilcox <willy@infradead.org>
To: Wenjie Qi <qwjhust@gmail.com>
Cc: akpm@linux-foundation.org, jack@suse.cz, linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, baohua@kernel.org,
	Wenjie Qi <qiwenjie@xiaomi.com>
Subject: Re: [PATCH] mm: filemap: tighten dropbehind completion context check
Message-ID: <aofGOQB4TViwQQQ7@casper.infradead.org>
References: <20260820142956.1414337-1-qiwenjie@xiaomi.com>
 <aocQcaMMU7-rfn3e@casper.infradead.org>
 <CAGFpFsRarmDScAQxHpCtSZxK5H4WCg4Y=y0hXQLjGT804ZoWkw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAGFpFsRarmDScAQxHpCtSZxK5H4WCg4Y=y0hXQLjGT804ZoWkw@mail.gmail.com>
X-Rspam-User: 
X-Stat-Signature: qcedz39hdb7tzkqtdnes4tfgabmb4i4w
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: E092740002
X-HE-Tag: 1787283004-101204
X-HE-Meta: U2FsdGVkX183MPILeHkuyCTDfAabGi/f6xrDLf6dBwBKMhO33nEqFHKl6Bqt4AcAkWswpSfybZoONwqDYN9f7a0qXZhsBDFOoQRU3ysQXCP89mWBUjOPToBtPFlTsgU8VyFpdQPmKDl109w4rJJ4O7epEBHcofcJv7nfjqX753wWyibWyu1jn1+7cyMioQfP5JUd2Bn1aDkc5Nhk4wx1+/ChYW/DK8AFnlviYjlIjCGHI9zEVrboDjGOhlmY3NHUvEHWbUvgommFqxl2rOkbWF90UL0VElbeYTDvemQxo3DHuboe7aJi/prYyybLKLOTXdNi+UhApcDhub/1NRwkK9cvtB6/EDljlFPGonwnQYnSr8aYowb+u67KIGna67MfEDWasj6yCx3ESzVNDoopETHmJZYI3SPAeRS7+XIIu0mLyDCAoOVJcruzHX3iZRX0OawEsGy7HUy17kxDU4j4sHcGQDRGVXlxSifnbUrU1GcsajEyYHpomfmiC8SWqMW4LpOJ3ToRfv27/u7Wp/KwklG599qwYnODhuxqoqxBjL7vWfaoSNt3m89I415+DxySvrXrh+ulyv+9WTt1szUhJw51tP+9e3XAAqCCuGB+yQAIryAiTaU/ftzOSYvedoCTnEG41alYuXjAsckCxla62JLWRBZLi5df4zgk3CzMuFNHAj9lfonQJ/v/611XlJ1nUE1wIXE/H5T03acSjoRzntvGBP4fFwbng3DOSH6TE8O04gI/wxXqPr3zXsCbVaR10pkyHKhU2NvawTAyPtPXBIlgNo7XvJie864/o02CC6zZooBEuqnPayUdi/7LFi6AT+zi52MT/1PvcKDyTHogHu5pS5uA1FcVurIXlIVlrNbtWSqK5FMO4EnMaVq6yza8GQWq+ZW/achXKQ36ACqreg5M/Igd8UyEM+e4bCJec/QKSAg4e4RONeGlZo6rz57bJujyt9zWb5DClfkYJii
 bdJAieIu
 Is13AJ4dlSXhQayanC+c2Lw0TXyXGl0KbjzWeYzcoNTejs3lV+L/6TdWH4Rro+x7j2lkHD1hZWOSzMxqr5uW8IGLwUHfAftgwjIuZryD1vK547nwwWkbL9IoQZskzj3yQn0ActRBkDRSHYyhpkAdjHCbjR3aVoGPLP9Zg9zYVnNa4OOtzHAXYY2Ui7ZBq+bQqE9eG/LLhHT4u6wfr/B4AIBPGDBGidzD3Gr9WsVluMGbI9Ohk5b6Tx9lpF7kjru31mDWxv2Z3UEUwSpw0Cdk98H5P25podqbjpVLr7+Z9Run8a2PemGCHX0Ls7FuXsBPRL2vZ1aNybeyDaqq2/2iCjGxFVc+sx9DuuV4R4WbZBMPXRscs6bl1BhQmJ1qfGRvGG85eWnASV1NIwv/q2mAq4XBICQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Aug 21, 2026 at 09:23:12AM +0800, Wenjie Qi wrote:
> This is based on code examination; I have not reproduced it in
>   folio_end_dropbehind().
>   There is an analogous EROFS report where bio completion ran under an RCU
>   read-side critical section and hit a sleeping-function warning even though
>   in_atomic() and preempt_count were both zero:
> 
>   https://lore.kernel.org/r/20230621220848.3379029-1-dhavale@google.com
> 
>   That is not a reproducer for this path, but it shows why task context alone
>   does not establish that sleeping is safe. Here, folio_unmap_invalidate() can
>   reach unmap_mapping_folio(), which takes mapping->i_mmap_rwsem through
>   i_mmap_lock_read(). I noticed the mismatch while comparing this path with
>   the stricter bio_in_atomic() check used by the block dropbehind work.

So your analysis is right as far as it goes.  But if a folio has
been marked as dropbehind, but was then mmaped, we clearly shouldn't
be discarding it!  I believe that we'll clear the dropbehind flag in
__filemap_get_folio_mpol(), called from filemap_get_folio() called from
filemap_fault().

If you can find a way to get a folio with both dropbehind & mapped set,
I'm interested in hearing how.

> On Thu, Aug 20, 2026 at 10:34 PM Matthew Wilcox <willy@infradead.org> wrote:
> >
> > On Thu, Aug 20, 2026 at 10:29:56PM +0800, Wenjie Qi wrote:
> > > folio_end_dropbehind() uses in_task() to keep folio invalidation out of
> > > interrupt context. Task context alone is not sufficient: preemption can
> > > still be disabled, or the task can be in a preemptible RCU read-side
> > > critical section, while filemap_end_dropbehind() may reach
> > > folio_unmap_invalidate() and sleep.
> > >
> > > Use the established conservative three-part atomic-context test: reject
> > > preemptible RCU read-side sections, reject configurations without
> > > PREEMPT_COUNT, and otherwise require a preemptible context. Unsafe
> > > completions retain the existing best-effort behavior and skip invalidation.
> >
> > Have you seen this happen in practice, or is this based on code
> > examination?


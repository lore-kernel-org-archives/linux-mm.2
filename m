Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 71CDBCF8861
	for <linux-mm@archiver.kernel.org>; Thu, 20 Nov 2025 14:14:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BC4666B0024; Thu, 20 Nov 2025 09:14:41 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B759A6B008A; Thu, 20 Nov 2025 09:14:41 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A8AB06B008C; Thu, 20 Nov 2025 09:14:41 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 95C6A6B0024
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 09:14:41 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id EC2BC160158
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 14:14:38 +0000 (UTC)
X-FDA: 84131181036.11.2397F2B
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf28.hostedemail.com (Postfix) with ESMTP id DBBAAC000B
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 14:14:36 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=cMI2xfPK;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf28.hostedemail.com: domain of bfoster@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=bfoster@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763648077; a=rsa-sha256;
	cv=none;
	b=UZ4inpYvES/NVRCLohvd+4aZucG/DzeCO8sDbtk9ckgmB6XM5kkGnPoQD/UKZmxzBL5LjX
	t4cwNPAKArxxcOYXHohkBfAAE3GuxgBlLfMgaE4et2tiON6T9Ck4Z1R99Izh2fdX514Qqn
	PzCL0PoPa/P65obLULRfGOTLJvpQYEY=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=cMI2xfPK;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf28.hostedemail.com: domain of bfoster@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=bfoster@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763648077;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xIt0w+yQa7jefSg/twoD9L40MOVMMfet4MY2La7u2oQ=;
	b=B1/IFa/X/jMvd1cCVVs14LTjP1XD91oTsibzBKnoQYQ6df2Z3pmifQNPESdnAnCoew0yM0
	Tj1OcJZrdWzi7qD0CWnAm3z8nwSYcQue1eG0YtoBnEqvdhvJ4OmvdN81z0cy4i5eKP94mQ
	MWNRluW9gsO8BzGOk55BnYxFv7BiGd4=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1763648076;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=xIt0w+yQa7jefSg/twoD9L40MOVMMfet4MY2La7u2oQ=;
	b=cMI2xfPKKDnLR9IJfl6Lb7KJ+lkiEth6AwBQYD7T31lpU2tgIeEaIDHiAgor/8KndjDOhX
	jDcEy3uvswjLQ0mnzOW97cSvBzmhlPttS6rmPzHnfbJ4V9tRudbR+cg6tUrKkIPQCl+Y9j
	qTS5R5YQVuKELcRiIP7Zmc0JQp8gMrY=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-310-__RytPx8OwW7smM4lIFT_A-1; Thu,
 20 Nov 2025 09:14:34 -0500
X-MC-Unique: __RytPx8OwW7smM4lIFT_A-1
X-Mimecast-MFC-AGG-ID: __RytPx8OwW7smM4lIFT_A_1763648073
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 8AACF18002CE;
	Thu, 20 Nov 2025 14:14:33 +0000 (UTC)
Received: from bfoster (unknown [10.22.64.29])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id C9BED19560A2;
	Thu, 20 Nov 2025 14:14:32 +0000 (UTC)
Date: Thu, 20 Nov 2025 09:14:30 -0500
From: Brian Foster <bfoster@redhat.com>
To: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: linux-mm@kvack.org, Hugh Dickins <hughd@google.com>
Subject: Re: [PATCH v2 2/3] tmpfs: combine !uptodate and post-eof zeroing
 logic at swapout
Message-ID: <aR8iRmtQt7C7ASb7@bfoster>
References: <20251112162522.412295-1-bfoster@redhat.com>
 <20251112162522.412295-3-bfoster@redhat.com>
 <e47c61e4-2c02-4eda-bd8f-900855b03af3@linux.alibaba.com>
MIME-Version: 1.0
In-Reply-To: <e47c61e4-2c02-4eda-bd8f-900855b03af3@linux.alibaba.com>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: zKjviUrgsuojmp4pYaIGMd6PeaSS9k0IiTydwwxpYvM_1763648073
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: DBBAAC000B
X-Stat-Signature: t3dtwnjkqttfzxq7s5nfqhcjkkoyjcru
X-HE-Tag: 1763648076-901978
X-HE-Meta: U2FsdGVkX18sBvWQfgXC/p2vTOl2Pbq3bIsyycjIfLL8p5OgvLm4fuIgpMr4NwVddv54MXwZuQazbvEhAm9cct/vdhcn/CuqF0jBzVCNenRJyvNPgOBzd/o0P6HcKN075qOJ/3RcgkUm+bNLpxvNs1erOufli6BkaJxiHcFodzvg8IsFgjj9j7aK4l/IGeUggK3lRKviNA1lNkckqJ9WfAcaKFNWjscG5j6b+RjcyafmAz7P/q4mLPSFmf9H2+ghEXjZydMFaTk5eJrlBobgf9AcAXI9MTrf1MQQJCH9qbIE0trB/BhCxPXK3X/WSEJ4lXsNPX9BEQtWZWgG/zyZ2jadMysBP9sEkM+ytLnUSCyCycM2/QJ5yDpaosBvBrEX6mFu4/UalapBMhtRNfrus3r2ZeyyCn9QkrWpghuvqs2mORhel91l+CYaFAwgUQMjt9/eqUY28tT6S4SWnWklcERUprcYOfY709QqKiTOzsrecGYM4Hb5sFkFZPow3cyY17p7OFn+CuuMG9dYgr8SRVzHG4nA1dW4XClaEthtTzoPdbIRxP7KiyDQVkRKXPeGuVuGpG8NxD3CGtWnECH+lCQSXkdgYDK/Ek1/WFCLeTO0ZWmIZA32bsTVK+ROcXbMOa0ZzRkxaZKFadiAPlRKfal9LCswDjnf9TvZp3gztMj/AccUIVl3hd6GeHfRflJxSiQOlWFiPUxZfRBwXRi75mgAJtv/YYHBaZXODGiEJu8IhRhanD9ca5R0GpIDiknn0o2l5Scc3eISW0oLZgeSZdMFJ5n9Hlqbzlz7ZNscDSRyRLKisf4ADJN8mYtLFeq6pbN6q7tCm34vc+wDCSEX4R5gzlTbJ7wlTphoRNfhiS+ezFKitEmLmkwVGOGZNLgQJQcuhdAg/NfR7LLntkT1dqVwgqT3dM4KevCdRryl3q81OsdVnXZmMi771p/9g8HIVUteE9uEc/0WNpNxZDG
 HPzIxf6b
 2uWsozgMnsGoFVztsOv5/TnYlYfzBR0IQ4flj2P9TCKw40V5d8x/su2REDVhjPNwZYGmF0rfrCaCXemGWtuesl+TEFiWqVemgyU9hiN7zBP3F3uQED+C1ATjSCupvGFJgZEpt7S3kfZtJM9M1j1muE8mtusmbCCi0KJRThwWqBm1YMFDYZ2MAUV+9eoxfbQ3+5hbxxtCE7tBIKeJGgTDf7h7E6L8GoMWouuvK0So8gB9rOtNdumkkuzotdTQBcK28ERCETrOHP9KF4z7lZtNmkMvFDyO8TIs/sr8VZGfsoIz/pymC3bw/0+tp7d//632fh7UJB4df0DSw2yMAjJgjfb6cbwX8cn6JwqL+L5pm6C2h1EUGs8m2iX3VsXe0wcb+rSVjgUNJDGfS89bKqqDPqyUBoXvB3hZ8Gvh5UzLWIUBYM+htoi7ieKBHYLMJA3Hd1VKsJqlNAq7t+A17bzkek76amfKEc15U9d93
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Nov 20, 2025 at 10:56:41AM +0800, Baolin Wang wrote:
> 
> 
> On 2025/11/13 00:25, Brian Foster wrote:
> > shmem_writeout() zeroes folios that are !uptodate (before marking
> > them uptodate) or that extend beyond EOF to preserve data integrity
> > according to POSIX. This is handled in a couple different blocks.
> > Fold the !uptodate zeroing into the post-eof block so we zero from
> > one place.
> > 
> > Signed-off-by: Brian Foster <bfoster@redhat.com>
> > ---
> >   mm/shmem.c | 40 +++++++++++++++++++---------------------
> >   1 file changed, 19 insertions(+), 21 deletions(-)
> > 
> > diff --git a/mm/shmem.c b/mm/shmem.c
> > index 5fb3c911894f..7925ced8a05d 100644
> > --- a/mm/shmem.c
> > +++ b/mm/shmem.c
> > @@ -1627,25 +1627,20 @@ int shmem_writeout(struct folio *folio, struct swap_iocb **plug,
> >   	 * good idea to continue anyway, once we're pushing into swap.  So
> >   	 * reactivate the folio, and let shmem_fallocate() quit when too many.
> >   	 */
> > -	if (!folio_test_uptodate(folio)) {
> > -		if (inode->i_private) {
> > -			struct shmem_falloc *shmem_falloc;
> > -			spin_lock(&inode->i_lock);
> > -			shmem_falloc = inode->i_private;
> > -			if (shmem_falloc &&
> > -			    !shmem_falloc->waitq &&
> > -			    index >= shmem_falloc->start &&
> > -			    index < shmem_falloc->next)
> > -				shmem_falloc->nr_unswapped += nr_pages;
> > -			else
> > -				shmem_falloc = NULL;
> > -			spin_unlock(&inode->i_lock);
> > -			if (shmem_falloc)
> > -				goto redirty;
> > -		}
> > -		folio_zero_range(folio, 0, folio_size(folio));
> > -		flush_dcache_folio(folio);
> > -		folio_mark_uptodate(folio);
> > +	if (!folio_test_uptodate(folio) && inode->i_private) {
> > +		struct shmem_falloc *shmem_falloc;
> > +		spin_lock(&inode->i_lock);
> > +		shmem_falloc = inode->i_private;
> > +		if (shmem_falloc &&
> > +		    !shmem_falloc->waitq &&
> > +		    index >= shmem_falloc->start &&
> > +		    index < shmem_falloc->next)
> > +			shmem_falloc->nr_unswapped += nr_pages;
> > +		else
> > +			shmem_falloc = NULL;
> > +		spin_unlock(&inode->i_lock);
> > +		if (shmem_falloc)
> > +			goto redirty;
> >   	}
> >   	/*
> > @@ -1653,11 +1648,14 @@ int shmem_writeout(struct folio *folio, struct swap_iocb **plug,
> >   	 * traditional writeback behavior and facilitates zeroing on file size
> >   	 * changes without having to swap back in.
> >   	 */
> > -	if (folio_next_index(folio) >= end_index) {
> > +	if (!folio_test_uptodate(folio) ||
> > +	    folio_next_index(folio) >= end_index) {
> >   		size_t from = offset_in_folio(folio, i_size);
> > -		if (index >= end_index) {
> > +		if (!folio_test_uptodate(folio) || index >= end_index) {
> >   			folio_zero_segment(folio, 0, folio_size(folio));
> > +			flush_dcache_folio(folio);
> > +			folio_mark_uptodate(folio);
> >   		} else if (from)
> >   			folio_zero_segment(folio, from, folio_size(folio));
> >   	}
> 
> Overall, this looks correct to me. However, I have some concerns about this
> cleanup, as it involves handling different logic for !uptodate folios of the
> fallocate() and EOF zeroing. I'm not sure if combining them together makes
> the code more readable, since, as discussed in patch 1, there are multiple
> scenarios to consider for EOF zeroing. Let's see how Hugh views this
> cleanup.
> 

Yeah, fair. FWIW I played around with reordering this a bit yesterday
and made another cleanup so the end result now looks like this:

	/*
	 * Ranges beyond EOF must be zeroed at writeout time. This mirrors
	 * traditional writeback behavior and facilitates zeroing on file size
	 * changes without having to swap back in.
	 */
	if (!folio_test_uptodate(folio) ||
	    folio_next_index(folio) >= end_index) {
		size_t from = offset_in_folio(folio, i_size);

		if (!folio_test_uptodate(folio) || index >= end_index)
			folio_zero_segment(folio, 0, folio_size(folio));
		else if (from)
			folio_zero_segment(folio, from, folio_size(folio));

		flush_dcache_folio(folio);
		folio_mark_uptodate(folio);
	}

I find it a little cleaner personally, but that is still clearly
condensing some of the logic between the two cases, so certainly
debatable.

I'm going to try to spin around a v3 quicker than anticipated to fix up
the wonky ordering thing, since I think the way I did it here adds
unnecessary confusion. Hopefully I can get to that before Hugh digs into
this one..

Brian



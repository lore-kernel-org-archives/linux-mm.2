Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DBE41E9D83B
	for <linux-mm@archiver.kernel.org>; Mon,  6 Apr 2026 05:49:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2F1936B0089; Mon,  6 Apr 2026 01:49:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2A26B6B008A; Mon,  6 Apr 2026 01:49:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1B86F6B008C; Mon,  6 Apr 2026 01:49:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 0983C6B0089
	for <linux-mm@kvack.org>; Mon,  6 Apr 2026 01:49:30 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 8C5121B7474
	for <linux-mm@kvack.org>; Mon,  6 Apr 2026 05:49:29 +0000 (UTC)
X-FDA: 84627053658.04.70A679E
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf17.hostedemail.com (Postfix) with ESMTP id F1F9440008
	for <linux-mm@kvack.org>; Mon,  6 Apr 2026 05:49:27 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=aMkntTdZ;
	spf=none (imf17.hostedemail.com: domain of BATV+e35ce2fa15ba15168fb2+8261+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+e35ce2fa15ba15168fb2+8261+infradead.org+hch@bombadil.srs.infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=aMkntTdZ;
	spf=none (imf17.hostedemail.com: domain of BATV+e35ce2fa15ba15168fb2+8261+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+e35ce2fa15ba15168fb2+8261+infradead.org+hch@bombadil.srs.infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775454568; a=rsa-sha256;
	cv=none;
	b=b8Ohq2UpE4b/Q7Km90CeyTKP5RJf1gf/lWeCLdQKdU0Neqo3uj7xU6l86FDgZ1mZxWlBrC
	wcaVfQuAIgL7h5LlKPspGjII2Bw4rvvVTk+nGTbripEn76X/E2GuPu/3xGsAX697y32Lwa
	Oc9T8XWPnL0J3m6sNat8ZRbISRpXxrY=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775454568;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6WWXWZMI41Am3IOMc7V4QgXpbUSV0Yys/y4z2vFj0+U=;
	b=40QDHJ6kyB+tgoBqYvEvV4kOgCYaHJNRQF4hwtzImEfAog62LhtCYkjlkfZP+C4ZxzpNiV
	Fruspy24iIX+vS36w5LoYIGMNNb25lBvBRVsbsw63SWEku5rrewLJNwpfaM2Hwl2Xkj6NN
	+BrNYc17I0wIjQ5opVUt9X2qrnwEqfQ=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=6WWXWZMI41Am3IOMc7V4QgXpbUSV0Yys/y4z2vFj0+U=; b=aMkntTdZNJnKIOOxVJAW0Dcitj
	5A3rbsHMazHEWugGsyUSoquIwVRWzA+1t4rpE1kiP7C2zi0C+12p3Mg0321M3Gspnxbie8PkrchOf
	YL5gPP30MTxuVja7u8F2A3zQNDCJDMLkZz1MqPrSy930AE6sMtFBo2oRZBRQKzBX+L9M0EpToOCa1
	ociP97dZmUvsZXgZh46Wp+XTT7xCh8Pz6PTJlnZ5owTujnFESE/ni8q27LKuU2dkmlRfwygAqwyC4
	dRFU/zZ0EZ7mtyjztdyfi3muuDiWGVwAAmr3M+AxcQ1zgRt7fIoDGatFJqeUKLRu3nuYUm3KRJKx6
	E8ikz8MA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1w9cpw-00000004p6U-2Mgw;
	Mon, 06 Apr 2026 05:49:24 +0000
Date: Sun, 5 Apr 2026 22:49:24 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Jeff Layton <jlayton@kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, Mike Snitzer <snitzer@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>, linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-nfs@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [PATCH 2/4] mm: add atomic flush guard for IOCB_DONTCACHE
 writeback
Message-ID: <adNJZBXeJomWmhdf@infradead.org>
References: <20260401-dontcache-v1-0-1f5746fab47a@kernel.org>
 <20260401-dontcache-v1-2-1f5746fab47a@kernel.org>
 <ac3-SU7BElHJVCEL@infradead.org>
 <629f21c6591903512eb2f3f3c4d6b14a9ac7b91a.camel@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <629f21c6591903512eb2f3f3c4d6b14a9ac7b91a.camel@kernel.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: F1F9440008
X-Stat-Signature: ogczxiz46isp75nmtbu3xji9drdpgcty
X-Rspam-User: 
X-HE-Tag: 1775454567-357269
X-HE-Meta: U2FsdGVkX195s9uGp+Bj12RlqrRUQKapRTGkeKUOGt+zKVbJ6G41yL1Qe8VGTUMOSAvrJWlWHA2cs2CzGOIsiAivoRs9lwtnvzuuyJGTSCxuYe8tmwKdhcCEnTImpFW9e6vfG/1CY6OCkuQrWkWptB0OqTkuSeep0/ao5s36kQ3Ss6qU2U1wgkfpjXD/WLjsbMlwt/WNBOXaF+wTqteuzyCGrkrds+nhmSeuNJo5IJrY2RoDG1MODlrvxxB+OhmZ5SZaFYZVwy/ybXQrB/AZFIjedJ1jFQr02vgRwWSASGamJtFNp6yVnNL/aWTviHl96XhGZ/RuYdwmNngm1EjGrVMWCooJ5Sd9P1zV/fSE7vyfPIOaC7O0sM6sqBuBm4JMt6yIyfpYqJJiy3z/GTdyBocfhmcnJJChh3kGDjvC+bwoefC23PYs+66KFk7loKRcYYzt/qu+8odt6Ld9IJPqk1hGffkmp+p48e6EvBOYS0OWaUcMyzj8iPUHYpKUT/bd5qLErHjp4wy7XUOodgONXyqvO+AAxw9U0H/T06tLIIem809k5qugYjqyzRfEkc9VW8nl7W2EAoV6iceBr5vDq37p/oOH7SYsFad8EIEIXtp8MtkUo7tdES1R+fxtXLCWZBtNbFyK8ecdzSxwiEcH7NhYgjT9behaFuqIdU4HO9ueZgYesbjAURtirwKqYZ15bUBHlfLPpC3mCn3VpsLnkyQBN+p1zPORjKrhg4EBE8W76T7OLS1ppB9IYJWCOUdNmek1Jn8mmQXlepvex3Y2JdwvpNdV0SRibFShZwJmknnYGOrus/La6imbRjeVRrUY4ynhXxqQUZU73Na/Xx50m88yZRm4UDKdzlnvZQprSJ/+6Vf/wwNTWN+dTVEnikRMKcW4TQEQkOCdL2wcwfQfHObgzToGaqpLfYoaBDmeHBORTd4MLxQfkzRf7AQ7J+cJRNLY9dTJld90NdXTZI9
 PV15L+QF
 ROP0Fbf1YyxUb2Uhe8bcYZelOJgMmtr0EpTaPMEIvDsI1HgsS0JSJIM/0sonIYMyQoO//QlA/ITu0Z+zDWB2ahLIZlTd5t8CbtyS1nZrXG5klcO6tymL+8Khj7fcfno5R0g6WMZErxyp9n7w4AuMG1EMQAqc88EkkiVF5L8LKmdxhfiLjAQULCeqpNliG0QZZFFHsa7CIX0m7DmrZJI964IbuLd8b87F39ccGqnZvaXDilNx+fLQaYxMdvEoukhKvkQ0kui/IaiwU3hv+o5k2h07PqZx3UW0Elk+hN0oM+WxkYdw2MqumfJhGmSgPujbVyVl5dSTbFfoswQoZ5vcYFIwWRnYMPSINDa9zVUK3ChmnYTPl7HebjwRc8x+yrPYLDIdFWKYkd6E/BqfKRYImaP/Atjpbf1f3ATGDHg3+tbXiFzp3ABk5ccC2Di+I0QEOrjwJjCuCkHk4sdmupUS3jDAvB2l1EIUKJLoRVKMUA6IBls29zHDwWMnrH7umSSwEUq7Ap7z1JMlfLAncGclEOG/m+mpAufktLGRN9NIJ6I3MKCI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Apr 02, 2026 at 08:49:45AM -0400, Jeff Layton wrote:
> > Have you considered stopping to do in-caller writeback for
> > IOCB_DONTCACHE vs just leaving it to the writeback daeon?
> > 
> > Either by totally disabling the writeback and just leaving the
> > dropbehind bit, or by queuing up wb_writeback_work instances for
> > the ranges, or by just increasing the pressure for the writeback
> > daemon.  Note that with all schemes including the one in this patch
> > we might eventually run into writeback scalability limits, which
> > will require multiple writeback workers.
> 
> I did test a "dropbehind" mode that just set the dropbehind bit without
> doing the flush at the end of the write. It was better than stock
> dontcache but the tail latencies were still pretty bad.
> 
> I think having each writer do some writeback submission work makes a
> lot of sense. It helps keep the dirty pages below the dirty thresholds
> and doesn't seem to tax each writing task _too_ much. The trick is
> avoiding lock contention while doing it.

Well, an any time you hit a shared resources from multiple threads you
create that lock contention.   Which is why in file system and writeback
land we've moved away from random user processes hitting both data and
metadata (e.g. XFS AIL) writeback as it leads to these scalability
issues.  At some point we might run out of steam in a single thread,
although so far that's mostly been because it does stupid things
(e.g. writeback on file systems doing complex allocator stuff).

> I think what would be ideal would be to have some (lockless) mechanism
> to say "there is enough data touched by the range just written to kick
> off a write that's a suitable size for the backing store". Each writer
> could check that and then kick off writeback for an approprite range.

And that is called the writeback thread.  So what we should do there
is to make sure we queue up writeback on it for each dontcache write.
Initially queuing up a wb_writeback_work for each range might be first
approximation, although we should probably find a way to just increase
a threshold if going down that road.

> I think this even could be beneficial in the normal buffered write
> codepath too.

Yes, we've had lots of observation that the current 30s timeout is
actively harmful.  Especially on SSDs, but even on HDD just keeping
the active might make sense.



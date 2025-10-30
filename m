Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7F212CCF9E3
	for <linux-mm@archiver.kernel.org>; Thu, 30 Oct 2025 21:26:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B21BE8E01E1; Thu, 30 Oct 2025 17:26:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AD2E38E009F; Thu, 30 Oct 2025 17:26:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A0FE78E01E1; Thu, 30 Oct 2025 17:26:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 8D1048E009F
	for <linux-mm@kvack.org>; Thu, 30 Oct 2025 17:26:01 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 0BDEE13A662
	for <linux-mm@kvack.org>; Thu, 30 Oct 2025 21:26:01 +0000 (UTC)
X-FDA: 84056063322.08.F9B3E3C
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf12.hostedemail.com (Postfix) with ESMTP id 45E944000F
	for <linux-mm@kvack.org>; Thu, 30 Oct 2025 21:25:58 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=gEZTFOgV;
	spf=none (imf12.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761859559;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WQjgh76ocKn6tEir5dlln+rELO/KQ8E5wii4qcczHPc=;
	b=QqMqFamxE63CVyvyPAvAfDexdJHrRV/c+elz+xbih2Rj9s+nztQ8dSVdSiFX6WKuRngHdR
	uFUaRf0L9bcsYnaLXK2HPApwfZtN7pdoUvgKbRLgTB8q430RBSif7Mk/E/PtA+yuwWUGjQ
	t9mpNu7Jn+GZQMsM27aWvk9/xJLr6uk=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=gEZTFOgV;
	spf=none (imf12.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761859559; a=rsa-sha256;
	cv=none;
	b=KdRoWOFb7jV+ldptOpVRSewBaVvn9un7kl8+VOuTrMqrfRmclAn1AqRmqi2JUQZM8xGRJl
	6sgPKWEXk1u8xZEyFApajrbwG3gaAq/NAwD/2VkoXmxgqO3Iv+lP6z6xs+7cWZSQqrudxD
	T+dcYIY5N6+BdnBKTxEU2BNPTWnGS9c=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=WQjgh76ocKn6tEir5dlln+rELO/KQ8E5wii4qcczHPc=; b=gEZTFOgVBA16zievEla5GynjUp
	PEyXMVqR2EUv2ROto/2cPQtzxjiwuSYjvtOdbriPADtwgo/DJXnzw3GqWRYCYX3+RMz5uMXbLbvRh
	9MinJUfmF9NsJsCBcRXCVwy95RGgFj9/wcDpiihdiDg50G1dkgoKMrlNMAji2QFNgffZdrBmd1RJi
	tWhDGBcPuHOJUSa28y/bIXNJvdcZ6Ol5atWR2O+pMM2XlD5Yc/vbnWqrAkLVMcYsSkQABgJl8/Uiv
	pLaf2suQ1vhKrtY3/ttlmI3WVsAOIn7iCFhO55ouG3KVBrvhXiXOM1RKpJW3lQU5jWPfLNR7iuXUy
	AY0QM0eg==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vEa9P-0000000DkEe-3SJR;
	Thu, 30 Oct 2025 21:25:43 +0000
Date: Thu, 30 Oct 2025 21:25:43 +0000
From: Matthew Wilcox <willy@infradead.org>
To: Baokun Li <libaokun@huaweicloud.com>
Cc: "Darrick J. Wong" <djwong@kernel.org>, linux-ext4@vger.kernel.org,
	tytso@mit.edu, adilger.kernel@dilger.ca, jack@suse.cz,
	linux-kernel@vger.kernel.org, kernel@pankajraghav.com,
	mcgrof@kernel.org, linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org, yi.zhang@huawei.com, yangerkun@huawei.com,
	chengzhihao1@huawei.com, libaokun1@huawei.com
Subject: Re: [PATCH 22/25] fs/buffer: prevent WARN_ON in
 __alloc_pages_slowpath() when BS > PS
Message-ID: <aQPX1-XWQjKaMTZB@casper.infradead.org>
References: <20251025032221.2905818-1-libaokun@huaweicloud.com>
 <20251025032221.2905818-23-libaokun@huaweicloud.com>
 <aPxV6QnXu-OufSDH@casper.infradead.org>
 <adccaa99-ffbc-4fbf-9210-47932724c184@huaweicloud.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <adccaa99-ffbc-4fbf-9210-47932724c184@huaweicloud.com>
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 45E944000F
X-Stat-Signature: qg9g9o5nfydq999gxmipnnxypotj18wy
X-Rspam-User: 
X-HE-Tag: 1761859558-450083
X-HE-Meta: U2FsdGVkX18ytCKvOQdSCp20ovvSS/3pAZ+WoAJaOUtxZNCDapr3KV1hF9pPMJfJhDhyOavY+fj2ocMlDldjKCVUe+RtZKNu7lZBgE2yPAMOGfINTcy/IjeKSqIfX0pQV1Afvl9Kdp5lOKPcU8eGr+sZ7IdsueINSCnKBk8Df/q05hINhHacLX934uwYUMj0LhMsHrARnZ953Fgh692Tauf9rimhK9zZBVun0EaOYX7xmAgHEaYYSlpU6D1vXvXFEHHJ6wypA7Yh815Y1KY5c4Qb0yQafroZp24o6S/uP7c8xSQe3Z4WdyjLOeGIXSQJM2+WJl/RXz68FT/QAppQpWHTegLGYd/Lh2xlX2N39RFc2EAYKR4gkwsnXPtfi5TiVdJiCX5xtBrNdG4Xe6O4qo+EICR53WA7S8ftaHFseEcLvryYIiS58VrBqigDGZuta9yDqOAvr8qKDwXQhn9am63kZ+BOozCWf9fXySgCtXtrE8qpYUIEbOmvWl6WaGj4OuPnZaTj3KN7mTr01tYr4N+aUTwt/w5L0AgKf9UV+Va+P5LVWpyngHzi5mH4cLsOwBfQqRuiMCshiX8746NjArE9jfMcwPf2opqXP1mNaUwyS/Fj1vlvSv4ju7BcfDdy+SuU+PMBQE+/I4q/HbW0BdNsRolp2dEQZ2rgd3koGAeEjagWi2Ct+HlK70CXhhlcRXUfHrOSOUr5CypZcwJovvAow4UdwLmoQBHAig8qB9XdQi+PkKWbLzc0z/a0nU+J2DJHckvwbk1ywLnlN/U/7o5+zdjvx3FSlwr3AJ0/5ezsGK6vngUq4maVvWUspPnhQlM7URMg+LScxh5cVN4TwmXfflvK7CRXEdNBxflTAjmBiZ3o8NWEl6uoxLxXBiXNDArD/xGFsxSOzMLc0MPxG4yx0gU8N+ubpdrTz58/Xx+QSyUxCovYJ0HN2EKVLXk4X4RYjVUgtUOC39GuPM0
 UjzrO/G/
 G/spf5eJrRg7l/eigx9YvQ/Prko/zdUx01QL9yO1iKn+G9ixnd8lRprzg8wIUTSrVv46qguA+9Dnd2RzDR+ze+nMViJAliN8/VDeqtXtZ2F4eSE1hsC3DSTmOeNvl/McU10Okx25V2qYxibyiFa06YpjzBD0n2gBPyN1B2Rlsy5iUD563tQN4gQNuR2d0ZL8DCMfqQs5HLQHChOgY4MoCYh4uIWK6dycPmbGD7N2Gei5pKvhMdEQU1GdjgXM+KwDYLAuubqbIAm86LqKVlbmUs3ttYviCdVp/Kb+fhXE0jOnG9Uc=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Oct 25, 2025 at 02:32:45PM +0800, Baokun Li wrote:
> On 2025-10-25 12:45, Matthew Wilcox wrote:
> > No, absolutely not.  We're not having open-coded GFP_NOFAIL semantics.
> > The right way forward is for ext4 to use iomap, not for buffer heads
> > to support large block sizes.
> 
> ext4 only calls getblk_unmovable or __getblk when reading critical
> metadata. Both of these functions set __GFP_NOFAIL to ensure that
> metadata reads do not fail due to memory pressure.
> 
> Both functions eventually call grow_dev_folio(), which is why we
> handle the __GFP_NOFAIL logic there. xfs_buf_alloc_backing_mem()
> has similar logic, but XFS manages its own metadata, allowing it
> to use vmalloc for memory allocation.

In today's ext4 call, we discussed various options:

1. Change folios to be potentially fragmented.  This change would be
ridiculously large and nobody thinks this is a good idea.  Included here
for completeness.

2. Separate the buffer cache from the page cache again.  They were
unified about 25 years ago, and this also feels like a very big job.

3. Duplicate the buffer cache into ext4/jbd2, remove the functionality
not needed and make _this_ version of the buffer cache allocate
its own memory instead of aliasing into the page cache.  More feasible
than 1 or 2; still quite a big job.

4. Pick up Catherine's work and make ext4/jbd2 use it.  Seems to be
about an equivalent amount of work to option 3.

5. Make __GFP_NOFAIL work for allocations up to 64KiB (we decided this was
probably the practical limit of sector sizes that people actually want).
In terms of programming, it's a one-line change.  But we need to sell
this change to the MM people.  I think it's doable because if we have
a filesystem with 64KiB sectors, there will be many clean folios in the
pagecache which are 64KiB or larger.

So, we liked option 5 best.


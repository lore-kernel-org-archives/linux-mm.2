Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 62FF7CCD1BE
	for <linux-mm@archiver.kernel.org>; Wed, 22 Oct 2025 06:24:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A23838E0014; Wed, 22 Oct 2025 02:24:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9D4538E0002; Wed, 22 Oct 2025 02:24:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8C3498E0014; Wed, 22 Oct 2025 02:24:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 783888E0002
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 02:24:54 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 1023B5ACE9
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 06:24:54 +0000 (UTC)
X-FDA: 84024762108.05.AA1D848
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf18.hostedemail.com (Postfix) with ESMTP id 75A821C000A
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 06:24:51 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=RX7a1AXW
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761114292;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1XhDE1BELRWX5YDOcVl25kQ97WNQSKEMx7NE0+Z0zfs=;
	b=gWaByNUywESvHc3fDwq56pP7oXGot0AmB+BwOPOGTlojJt1TJRh9QxOqdWJDZ1dNNL6Nkn
	f2m06vC4/D1hpk7uN6k1ZIrsusl+3YDt1PyFTYNJvb4HpnX+tlJDbghjUHZfzUtiasckMx
	T2RGmDhy3hcrcFWV1zjbpttz908nex4=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=RX7a1AXW;
	dmarc=none;
	spf=none (imf18.hostedemail.com: domain of BATV+21c3bf232c3b55be12f8+8095+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+21c3bf232c3b55be12f8+8095+infradead.org+hch@bombadil.srs.infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761114292; a=rsa-sha256;
	cv=none;
	b=LVESMYAbURDaEjAmyDZeOSutb69eojGKjKgxbcOTSPRG79wEPQQnxE/VTzPkall/SgXjsk
	pOcMbnKufAjoS7ELaSgDwFyycuIJkDzzCl/RqGkcIu8n9cs5KAnC5Mplq7G6HsXadrM7OX
	35j/thedAUQ9xBAGzBDVpm3tz7D2tNQ=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=1XhDE1BELRWX5YDOcVl25kQ97WNQSKEMx7NE0+Z0zfs=; b=RX7a1AXWTILfx/vttsD6ASD5QM
	nm39/Tj4XmpGD53ez9zf4QpAZwF67Zia4CQzhS9732EWS8EPh2m8ojSGgnoJs+ttrmJRmrRTMPhRi
	jt9Me0ujkGJNrMfLgoTCR5PgmzW3b8SlrnGxZ4pz/+jVDasdZsUWCAqzQ0ae3gmPoSxHkqQ/q19xI
	RYkBGdEhA6XkBkYrGAoXPT+y9kz1RXrhJ3UCNIW1WFCR3np8xaonuIeoPL7+Mp6mH+7Pnppq8Qvxt
	gfbhjptNvEJ0BDuMiJWCcyQYvs5SNAKh9t7u6juA0NeJcsmSSGnr1ZY9pemg6FZaqGbLYAb1E/y07
	Yqg5E91w==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vBSHA-00000001eTW-3aoM;
	Wed, 22 Oct 2025 06:24:48 +0000
Date: Tue, 21 Oct 2025 23:24:48 -0700
From: "hch@infradead.org" <hch@infradead.org>
To: Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc: "hch@infradead.org" <hch@infradead.org>,
	Johannes Thumshirn <Johannes.Thumshirn@wdc.com>,
	WenRuo Qu <wqu@suse.com>,
	"linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
	"djwong@kernel.org" <djwong@kernel.org>,
	"linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>,
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
	"linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
	"linux-mm@kvack.org" <linux-mm@kvack.org>,
	"martin.petersen@oracle.com" <martin.petersen@oracle.com>,
	"jack@suse.com" <jack@suse.com>
Subject: Re: O_DIRECT vs BLK_FEAT_STABLE_WRITES, was Re: [PATCH] btrfs: never
 trust the bio from direct IO
Message-ID: <aPh4sJ8eFJeMCAHx@infradead.org>
References: <aPYIS5rDfXhNNDHP@infradead.org>
 <b91eb17a-71ce-422c-99a1-c2970a015666@gmx.com>
 <aPc6uLKJkavZ_SkM@infradead.org>
 <4f4c468a-ac87-4f54-bc5a-d35058e42dd2@suse.com>
 <25742d91-f82e-482e-8978-6ab2288569da@wdc.com>
 <f13c9393-1733-4f52-a879-94cdc7a724f2@gmx.com>
 <aPhl7wvyZ8b7cnLw@infradead.org>
 <3677cfe8-00cd-466d-b9e3-680c6d6d8c73@gmx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3677cfe8-00cd-466d-b9e3-680c6d6d8c73@gmx.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Rspam-User: 
X-Rspamd-Queue-Id: 75A821C000A
X-Rspamd-Server: rspam03
X-Stat-Signature: zt9b39mdw3nkqimbejriniaz1gtympwz
X-HE-Tag: 1761114291-801512
X-HE-Meta: U2FsdGVkX189OTndlTgg4JSIDjaQ3bQmLEe30jFKaKbUK7KnaxLRsb4a9Trod3BmdUeYOy8Ftu+zzor2tpCOYGakAMgV+a+KDVtFJix1gyujVWW0xXiBWzwKZRBVJoEuG46PCq1/nEjc1qudFyYIqwWTFV/queSxKScX7lc4Latp87QqUVvnVu2ONIiN71fT8r/BzX7kcQYUABrAVkgabw9c8wtvAAPFK5QORdauMw3GQy0JdHbuYxH1sWCCYJtuE9d7PQdygnEc7rLZDVRfB91jjq2WeTKiMDjU6BOpLivxDd1dgKQAPcc4H6l2AdyO74N3bErJJmIjm+PgvBc+0NEvPldw7aVmkJuxOOAuI/biBybaVF4LaOV09gyfZNNRWJL8NeZ+cOw5nSI6Fg4Een1NRNYf946u6DSXjQwbzYvHhOM+A2ZK9PsxIbL/x6o8TpdcbO9kxhuVxJXza7osWH1qCw7uGEkjkrBDk/UKXGisazjkwFwRtpXlz8/eQ3KBagWKs2v17gME/K9boXm75DnEMnxIhV/UB/1TxJJO3/LHpFNa8SOf2CXDPafcXACebhHz/xlx8mkTobdAzIVlDuNPQwYWvyy0yOIsEJchgEuWBCENxPmk29txL6sqOpLRe6q+RNjQYDLZTUHQ5j9yeOLkJywdsTfktvuwm6GMu415ds5WocBAqf1juXUYTwkeg+Nl5fkUlzDjYOURYE6MIxkgy2BJYAtWWu3kPE61SgX6y6UKbLX9CueeUbMnDdeSkTaMfV2ijUTTwi3TUwUuabWuc7PpgxtbZUkpfrXF6V45cKN/N98HgQCXLz3X/rmTytcOkf6nWjjt20mWx0Sr/PcJ/FDi7HzCDzXkgsYYlU0nF/MycpyNaFW24Pa6yaM9JIQvWqOYNjRUnUq7vYLkOLekMz7gt5I6qC1lj/v1GXa6QFKsPKhLqZc8uQuKtnECMF3+pl0GwrCU74QarZP
 rp7PqqQF
 wkUno0Fnp+7PSorAXKZ62V5Bm20tVvNlrBXO0eHtGiG6iyErztrOkHVO1bug+ko+OC3Iec9BoGSSidaUiixIiOKnW6dcrfs8w/DrA7wjlDjqO3QaJ9362+bcwOLTTOdiKfDfJPq6+OJxJUn1Eo5YdP/trbhLXW5oF6wdutqsSHNKqeIgSYlhCg9PVaAgFeeWcIraxoJgXP8nFXV6JP5q9cSMLu0Rt8Ddi5LWEoDsbsreohvufQVWBxdYehaLSRyMIS4t4exbsQUKYB1PJ1aDOmVSK+U1cBXPEuArnBBzYZsNN3sTEAC/hS90dhkf2tukq8wWouGci8cURtWfLz1fvE7vvhj4/FJertwe6G55w1EhvqZ7K4hbvCav+Y2QtGtjUvRhV/YwLUl//5dgMSuESbn6AjM38BYXvZ/2hngLjrbG4bV6fp/l7UYAcvQ9EnmY+qt+pPT2OIljChDL8xHqveBQ58yxmuV1KbEwo875hU+APM0eDW0z0Ik0oHoobusOCeTyXsLwTE1OQIu4xHn0n8fWTZXsPbY9vlhl37oLionuRcp8=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Oct 22, 2025 at 04:47:56PM +1030, Qu Wenruo wrote:
> So far it looks like the bounce pages solution is wasting a lot of code for
> almost nothing, it's not any better than falling back.

That was my expectation, but I wasn't entirely sure from your wording
if that's what you measured.

> Since we always fallback to buffered IO for checksums, the content should
> not change and we can do the submission and checksum calculation in
> parallel.

Yes.

> Already got a prototype, results around 10% improvement inside my VM.
> Will fix the bugs related to compression and send an RFC for it.

Nice.  I've also started looking at my PI backlog for the XFS version.



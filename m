Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CC75CFA0C33
	for <linux-mm@archiver.kernel.org>; Wed, 15 Apr 2026 06:10:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 416536B0092; Wed, 15 Apr 2026 02:10:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3ED056B0093; Wed, 15 Apr 2026 02:10:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 329C56B0095; Wed, 15 Apr 2026 02:10:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 23F006B0092
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 02:10:56 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id B9B47C1A41
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 06:10:55 +0000 (UTC)
X-FDA: 84659766870.29.605F9F9
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf10.hostedemail.com (Postfix) with ESMTP id 14187C0011
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 06:10:52 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=Wwlu1nDv;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=none (imf10.hostedemail.com: domain of BATV+02be7307ed47794533ab+8270+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+02be7307ed47794533ab+8270+infradead.org+hch@bombadil.srs.infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776233454; a=rsa-sha256;
	cv=none;
	b=aT3NCchzFU86bDDU9lYf2GyMjFijmbIhiv2LZD0Sg5zVgg14m/alQtnXDE7k46MQewgijS
	NzouCIEICeJtujdifwl0st+pDw02w5gdVG9GBeB/Rt46wznjRXrIHFfav0lPpcZT3IqnTe
	LDZb4j2X7nmz2YrRxlyUZI4rzScdzuA=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=Wwlu1nDv;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=none (imf10.hostedemail.com: domain of BATV+02be7307ed47794533ab+8270+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+02be7307ed47794533ab+8270+infradead.org+hch@bombadil.srs.infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776233454;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7aKAAKsTYoxSoqNfxwE2AztxBRZIup6mF9UIRFkQkpg=;
	b=SZyykCiJi1C/vvi1/0ZcXgscPejm7z86ir/PcxLF7T68XWWj36taTxY6ITPijtb1e1occS
	5X4ge2KOXd2+1CBeKRuTphKmH+2efakXFHy4fGzKpq4PLG6KYbqIo4TeBHuvrRAUKSBTX7
	RfvsybU8JDp5KfJuxR3RfOHDcvVFEQo=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=7aKAAKsTYoxSoqNfxwE2AztxBRZIup6mF9UIRFkQkpg=; b=Wwlu1nDvkuxF0JLEyPMWI6/78x
	sRW2f/J7mqr2jRUICnnn53a00TfzBdd24MgcENfRMxEsTz33uGwP0NZ51O8rcPsNyi9b8DFyPAvhS
	KnTODEavAruBEZiUDnXXY6Eld6BkmwGcMYQCNlTds0txOh+uAFPGnOdbjn8pm7P7fSt1J7741+bAT
	BmsASonS0UFSepXlXdvmCva4GT9Rzo8Lal9lotlhWCy2F7FygwS6ejQ1GUHOryOx81M0MOBdYfMxq
	jLNTPPRwjZD2nlWaQyua3b9Fq2gNsuY2XO8htreLIGUWGKujRz6A/yWXEUjCW+TSCw78sUVaNBIlo
	9vnUJo1g==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1wCtSZ-00000000dJj-1yV5;
	Wed, 15 Apr 2026 06:10:47 +0000
Date: Tue, 14 Apr 2026 23:10:47 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Tal Zussman <tz2294@columbia.edu>
Cc: Jens Axboe <axboe@kernel.dk>, Matthew Wilcox <willy@infradead.org>,
	Christian Brauner <brauner@kernel.org>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Carlos Maiolino <cem@kernel.org>,
	Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>,
	Christoph Hellwig <hch@infradead.org>, linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH RFC v4 1/3] block: add BIO_COMPLETE_IN_TASK for
 task-context completion
Message-ID: <ad8r53AmTxjcvTLg@infradead.org>
References: <97b81868-6410-4c79-a242-679a9f04f073@columbia.edu>
 <95F28FA1-5CEF-4E80-BBB7-A429B4437D12@kernel.dk>
 <7e468bd2-e52b-4165-95c6-3f04e1dca21e@columbia.edu>
 <fb64ba71-7284-4768-979b-84919f2aa5f0@kernel.dk>
 <fd94b108-22c1-4eb6-8fb4-b009214976dc@columbia.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fd94b108-22c1-4eb6-8fb4-b009214976dc@columbia.edu>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 14187C0011
X-Stat-Signature: bobshdh9bbpsypw7bhnyka4k33d6jabr
X-HE-Tag: 1776233452-963384
X-HE-Meta: U2FsdGVkX18wirWbc/T5z5II6C9pCDsl8Ej73raWTquQTXBasjXpT2guqF/SK0hgAOACRVoThQR6NSalFVySRrjwlLL816l+STivcL6QLc1tteTdyJP0YKYUl08Te6TBoUYMi+Qpo5hDxQkvDFHGbWmYq3fIpNyV+R4jz8/6ssP4KOCac5gkOD6OLuCKWK2xDnku46QiTg80g9uqV1h+kOlje++cRpv0+ca/IemfqclxHKegZ7gZkRCKqKWX+t6YNmRhHXnW4Ni6yjkHOMSQePgCMBNkSr13PTkxYJ1/XrnTYrxfonPDaM1o9NYAwrO17a4Pu+T3aKO3Q6TXy6x9Y3hSrZv2Nic55640BTjpMl6OY4Hqd7j3syzq9VVLYIAXFSiCqMFSUfRyzV4p7VAkyqG7X6cPrGda0pXgOLzDVvEatt6znKBTqLuXngRXdog2fMx0wikxHvXbGHBUaRKDH+SHh8wC7KeKP7u4L/ZuwVPF5pKlOmMHPK++dgg0zpQPf19iwSooMUiYih7oDZfgHV17Fz0bhtb0DlSjzd4yda2zVoeN79xtbKfW2vdeb4bqQq9dJmKw9ngTnVoYUxmEoSyo6Usbx8WKkk4o1AnxfH+0AMjMHLFEx+wlri785zjki5TQvbE35Utrd0zQb+rYO0rhCJ60AjKyHS3VKu3uDOAlocSC/SR+HBmEQJQgAVTW6jjleuLMZIhZrcMG3lBQOp5bh6QZbWax4Dva7O+AYeiVlQ2b2vZu++U7qMBg108Gi54mNayH1dmCKDYDa5dByMPErKhYlDzvnDCZUWUbq1iUpnwOHnMlADDH4DqZuMwV2eBqQGkPI3TgSt8OrInVcqinqIPoyMPlUg1jmw3ySu23/HoBPSW5lOeBUEP5oGEyYmEOyPRAfq0yUCH51nOt8pT2SJ2DO9PGV1/f/ZCq25vt9kyWOr6pKppyYnrzPA41FCip0A0DKgWbL8G1RxX
 mUWp0OFw
 xXmiyqyjM6YU/rpikxPu6jN9tAR5DaL2sRkw6lkagwGYooPdalVgs9OzPeAnjqgVh/9BTn3KlXHjge+TTktWw5je0U1tPMB9xz2Y6240P/jf7UXDCRzGdxdWFx5FN/JJ4o+d7sADVZxh0Xtvg+HrSp8z9Y2HklIWIurOEujxi7tFKk2HCGbrDdgT8HvHAPkxBavN4KIVV1cVtzyt2EGeRW/waM7mRgto+JybmfraYHnKU5psnnu3rOI3HRi2HyzVQoFLy6OXE4LTOftacF3d8jx5GcOzyfp1kdqPwL5K6tZ5ZQ39P7m9EA/H0TE6VD1/Qs8hHHPfh3qpjRsKHw2kEAihwoDYObhdw8a+JQx6pdOD1LB3voYNw423e5e0M4GySdK9bOSGIUxAJv3Zt3U7s9P6JB62jo1uDnsqJ291qQRWXJ9I6ccIe6R2uxCjZiUxYJ1wKOojmzCafP5GgunkqI9lMv/PUNvkCv/wnaATh/6AZF+5M4zhAsY0J1PoE/YZN5ZfEPsuTpMP0uR2aF9U4dHwep/MTOckSB572EbJDNCfOa8A=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Apr 14, 2026 at 04:29:29PM -0400, Tal Zussman wrote:
> No problem, thanks!
> 
> >> (Although Christoph seems to have proposed moving away from llist again)
> > 
> > I think that's a good idea, not a fan of using llist for this, in case
> > that wasn't clear. These are per-cpu lists anyway, and having a constant
> > overhead is better than needing to reverse an llist. IMHO.
> 
> Will change it back for the next version.

FYI, the prime reason I switched away form the llist is to make sure
we can atomically check the list emptyness vs the wakeup decision
in the kthread version.  But if Jens prefers it for other versions as
well, that's fine.



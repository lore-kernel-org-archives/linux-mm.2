Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D9B0C1091904
	for <linux-mm@archiver.kernel.org>; Thu, 19 Mar 2026 18:00:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 025CC6B0560; Thu, 19 Mar 2026 14:00:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F18DD6B0561; Thu, 19 Mar 2026 13:59:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E07D16B0562; Thu, 19 Mar 2026 13:59:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id CEE656B0560
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 13:59:59 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 439D087788
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 17:59:59 +0000 (UTC)
X-FDA: 84563576118.19.A3E5FD7
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf05.hostedemail.com (Postfix) with ESMTP id B3141100016
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 17:59:57 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=r5qRRodo;
	spf=pass (imf05.hostedemail.com: domain of minchan@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=minchan@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773943197;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yBW47iFp6Ni1cQrpdYT4ayynV+aybSUe2zIBEB6l8Ak=;
	b=y6C5zhiSIR0E6TRjqwScqj7XUzLQ0L05fPr//9Luy8olkxaL81D9wRTCBimV1BIwFntZ3z
	82V+YI6s9ne79gvYcQpaAOvYzLNe9xO37ssWEA2VmHYlbYtQH167gxXPV58qVpc9LC3Ygl
	kqCboqZjYyLVhgM+LP9yQl5yAjpUCso=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773943197; a=rsa-sha256;
	cv=none;
	b=zUVvugPHd+y30+ZST2h4Ewos19+FSdlILpAby04NPryAspv0ShHhXR60sBtKwrMnXiE/Tn
	Gh7aJP6GNf7dB719+6C03aXAJ5Ysip3oKo276HyhggwPvVq2/eK+zmO/AvIn+Crvk1fQ23
	4OLr0hb6f11tSfsLerzpyYtbIkIMd1I=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=r5qRRodo;
	spf=pass (imf05.hostedemail.com: domain of minchan@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=minchan@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 23BA160137;
	Thu, 19 Mar 2026 17:59:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D562C19425;
	Thu, 19 Mar 2026 17:59:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773943196;
	bh=29WlG8Dkoh4OctdaHEWHsm1UTwJFX6GFSef9CMqVITA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=r5qRRodoitaTjP8Oo49cX59bM6/ww2hHBYTb3Av7xMXj+588xDmtzRecYNetDNhFv
	 ai9zk9r3Xzm18NmIbze5e3mQ2pBeKPP8CBLcEfQ/N5+/scOR45Ef7gyJWDMnT7u5Z+
	 RzEd/KqSZq1jO6EgQgwz7TBgc6fpsdBNYnR1aL2lCc/jLP8tAT8VBpMHJulGGAp5LZ
	 dQce4oSOE8yWWuFcdMJX40dA9YUhBlWywlFBBlJx31GKOj6nd834tJWVU2bvwaEvgp
	 PLopseWmR8aLG34tjuSZXAIjmkR9+ib6/8rC7VS+7wI6qRKK2Ap2SZvRO3aYaqzly/
	 a9BqyaBLojGLg==
Date: Thu, 19 Mar 2026 10:59:55 -0700
From: Minchan Kim <minchan@kernel.org>
To: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Brian Geffon <bgeffon@google.com>,
	Richard Chang <richardycc@google.com>, linux-block@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [PATCH] zram: do not slot_free() written-back slots
Message-ID: <abw5m8Q5fFXGIweh@google.com>
References: <20260319034912.1894770-1-senozhatsky@chromium.org>
 <abt1dsjsT9826Ewy@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <abt1dsjsT9826Ewy@google.com>
X-Rspam-User: 
X-Stat-Signature: cqxduxqdfn8qsk5xwdrfqnrhw4n5675m
X-Rspamd-Queue-Id: B3141100016
X-Rspamd-Server: rspam03
X-HE-Tag: 1773943197-183042
X-HE-Meta: U2FsdGVkX19ySFZTBNbDzf7J8Wv9sNAKddQgZsMwX0Fm5qy2GeMzibcISFsjNM4NxSr5+wpCDeh5LZjQ+CQ0wpoXtC/gSwJyq2epbY//jmP90EpC3Z8Lx8dc7Ixlkjw+RxBFljr0EB7bE3thu3/0rAWfpnjoRZyvOSxh0DWX5vMd8jFMA3PMv3afiZPpJ4vAiUFORZACgzhtWtmppTEoVcWUiE5yiSosNrgZXX1vVTXza+BdFbvH+3cqZuF0Xin872x1+OSu669xWdPJdoLh3f3NVeVXrNS4LZWYYrOSRqGZZc7UY7ojcScxO2tnG8vOFSbrokAUio4xuf7BGvzD9p6w6nssdyjse9mu3R8rmMVM8KOOnwizWmt46AvRAgcBX9hcOdW1+MAjasN5XvsQe2BLzWPXicCxUpDGlU8MwN8MB5jLPWT3dvTVqv6aJFPgy/bLmfx91b+Bv+ICuzKmILfL4QhDf83x05Y8HpcRWLQAZDBW3q63JI/IqGIgJ1zklYFynMm89jxgQXEA4+t0/ozyzDp3F6M845IKDvjhQd21HOIy4gmEaIhgA+/gFHGaM/mESrVe9oA/BDq3cHu+kiejijHANfSDLQ3T+vEfHGVN53LMQ+lbj+FI9wgGrn/giFPXWGgV78SnaelVGNfsglvKhKhFsCP7eLgQYtZF+EPahT4JvKMUKsWRNxitSgX8Ml7/Ey/KhBYzP0/A4x3fiosONfGfiBfd2fBkfYvHz2AdvyN56g5dil/xtGJTLj8SU9AWzLZd+jw6w7Uc61CWvJx1da7x4za9Ju1mNMmgrxYeJUWHUECd6VY31T3GPb5Mp2Dl2UXhoXu/OjonGuz6ga+yl3Yb+BhYcgxLFz1b5Iq6RsXvyKnqmZZrob737Xl95ASOgz/YHTSxhQFhR5kEVNKGrmEqF+8qhuEbvPiRftT08JPiEoZ63USLCQtp2aZ7LrkUYthJNbMz9aBECPu
 cfnfVESB
 1HL8NMaBFlwytSAfdubJ5FtAo8k6U5iNBvxtqxwnwK/s3HARaoJrCIXode7dcA65rx1mOOSrO0q5ch/JXjzjzs8o2heZhDDfZihCsg7MQK5ozya2sGUFhvt8br0rRMdobKSgnP25+ckSDGaulWLpFLL4vEiaBWQvRXbLpuQZ/Te5H/OF8QLWJ8TBfdoBkn20QSltJN+d7AhHEbyu7brIb4w4OOyxxFswD2RIvybV9k8iHVudITE9CxtcJcMGRvtyJLqWBmylNy1nqZ0eE/e/ABckYOANBuJE5G2qWIotu5mSRX2jcRbwuC17pLpI3m7/50rDpPEn/alzw+SE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Mar 19, 2026 at 01:05:55PM +0900, Sergey Senozhatsky wrote:
> As a side note:
> 
> On (26/03/19 12:44), Sergey Senozhatsky wrote:
> > -	slot_free(zram, index);
> [..]
> > -		if (huge)
> > -			set_slot_flag(zram, index, ZRAM_HUGE);
> 
> Original code had a bug.  slot_free() would decrement ->huge_pages,
> then writeback completion would restore the HUGE flag, so when slot
> would get freed for real slot_free() would decrement ->huge_pages
> again, leading to underflow.

This should also go into description of the patch.


Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3653FCAC597
	for <linux-mm@archiver.kernel.org>; Mon, 15 Sep 2025 23:05:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9046F8E000A; Mon, 15 Sep 2025 19:05:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 88E2B8E0001; Mon, 15 Sep 2025 19:05:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7A42F8E000A; Mon, 15 Sep 2025 19:05:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 5C4E18E0001
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 19:05:23 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id EDA415B37A
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 23:05:22 +0000 (UTC)
X-FDA: 83893017684.15.99325DC
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf23.hostedemail.com (Postfix) with ESMTP id 1ECF3140011
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 23:05:20 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=L2YDztaP
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757977521;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kFoXd94mYDwzR27iBBzfzAZSuVL+D/rJNjURhWoqhaM=;
	b=Vjoe78i8GCt6exYQlCGUDSmLE5ZcUoMWMxH9wnYOLlt+NO1oSAtbsmKY8Iv5VpACTavmoH
	lW876H33G3f7LK0F3AOnRxwTYVVgEgVvA6r/H7YnU9iD87IJL1JRIV6VXj5cqp34L6nAD2
	CiWPwey7lQxCAMN+0bNCssonALWvrq4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757977521; a=rsa-sha256;
	cv=none;
	b=Ah3op9osEjC9GQnXzCmOAEHI4rcn60N2X3fmvsFhAihOrz2fduDZqyooQwhQZKWNJT4Dug
	l40gSNzX4uv8NSNB2ynH5StmFXCHyOogB/eHhJbEA7vB4g7Ko7tkLze8Pn13NSWZZxSVWq
	nLbwpy8Knj7Hr4Y/H0CENwyLGMLx03Y=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=L2YDztaP;
	spf=none (imf23.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=none
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=kFoXd94mYDwzR27iBBzfzAZSuVL+D/rJNjURhWoqhaM=; b=L2YDztaPmKfoJgppdbukM6e4UQ
	PB18/TYsJEduUdrlhYyofd12tFAy4ZmCUt27CKhopQvnMwMxoHay0bqm+znfEhKJOlUWO86+D97Tu
	0oEwcwz/vURZ8eLgnK3R1XUkwh6hLhdBawHh5F8ImAodClbPYV/fQj7L5iSAgYtRJ0RrvkRLLdlgf
	yrxSK+OUjhTBrGuk7892523Yb2Ybtto0mzXRs5KthU6uQu5S+fvHnkHJE4RSmDMKB/AtvtKfekS+F
	zz4IzYfhlv/OVzEQbJ4OPsUS72HV7jrAFyaLGchRYe6+qqqNPdRBajqR9GXWHgr7aCIdv1su6W8o3
	nC34DL5g==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1uyIG4-00000008mBP-2h2g;
	Mon, 15 Sep 2025 23:05:16 +0000
Date: Tue, 16 Sep 2025 00:05:16 +0100
From: Matthew Wilcox <willy@infradead.org>
To: Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc: "Pankaj Raghav (Samsung)" <kernel@pankajraghav.com>,
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
	linux-btrfs <linux-btrfs@vger.kernel.org>, linux-mm@kvack.org,
	mcgrof@kernel.org, p.raghav@samsung.com
Subject: Re: Any way to ensure minimal folio size and alignment for iomap
 based direct IO?
Message-ID: <aMibrFB8_21GQWUD@casper.infradead.org>
References: <9598a140-aa45-4d73-9cd2-0c7ca6e4020a@gmx.com>
 <aMgOtdmxNoYB7_Ye@casper.infradead.org>
 <2h2azgruselzle2roez7umdh5lghtm7kkfxib26pxzsjhmcdja@x3wjdx2r6jeu>
 <fc7da57f-5b11-4056-857c-bb16a4a20bb5@gmx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fc7da57f-5b11-4056-857c-bb16a4a20bb5@gmx.com>
X-Rspamd-Queue-Id: 1ECF3140011
X-Stat-Signature: pd73jdoijyh1y5fxurnpsiiiz8zxhnqq
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1757977520-554361
X-HE-Meta: U2FsdGVkX1+G4k0RbcW4q1MLL5Ndkwmm8HXWbLBykMOHoBuETn+TwSy3d8SaF3DIo8ybf+vEzd1X7vo/qx5h4gBA8D9w4yDf1MVPWL0j1JUvLOgxzUVvd1fvuQHXFenxTL2MCeVO0L8HuNEVl9T5IbPpgZdtqL5uceelHr2SmoNGeqwXBAl3KJh8yZaGyes+0rc9tu9qC6nqc4yR4zbXWJfPQSnki2GpqyFj9ngk+mP5l4JGGlKRZK1T+XtdONXJ1bFrrhcLWd1WJB/VLHgItTbrLolDcNWGw0xnu1MbsKz1ULEuYvFApjbXIJnq59zW/NbK5bC/Wf8OKBjkv/zC3o+gjjhp1PmkjSvMJLBMz9NwqAoKVjt0GM9Fso8gyK4Yx+FL0Ala7THPw2X0y1WQDMWuJk+8Y3ua07YKFqGa7JjnVgBg6vKFxEjvuCaZZTh3Ffe+Am9zeTKszNbyxyNGJlZcuwUPKHobUZ9uBhSBTkmJJfow+1f4dcz2cpOjaL8LO5ovbyICAVT3vDaGbiOZOuGCzQyTEwv9nTZQpt0dbhPi7RRVW/PwwmLHS5XOT4zEy1CAbk0iq8cv3fEpJj/qSPMUcZiQRYYGJuiTV7cYsEv0rpIcLDFOaFBw78lFSZTLPrUZRVHnBucqxf8lJFNDjBBoX7V8u6B9HTeSNb4uJyldH6KWUuJP91qu1xxQu+NHMCeJITLYHAJJVxCf5xPGYRjMSuzmvSr/0nn96yEyDmRl4ZhgkuqsXVBJ1mVlwajE0PunoKDp7HI4Mxre3wK6Y+hJLwk70XF8CRzvSBr5aHZuUfd258sPyqSYxI297hIuTMnVmPbGsMrknVPerNMugagXhWW/ua2YKGMd6pmBIzTRPWkheXwTsJBD2TyC4sK+Yrx1goOvk0V+52WLg7fltkvzH1aZMEUg5zNf8PWCT6PJl1wxt2hbz7VCeeoEGMmdBD3Q3+MQCsBxiaUpHGA
 ltZy767t
 IR96b/HJg6U5H2R72y/f04O3DDD8YyNFOR7trYJ2Ng744Ar3PSjRAOZh1SKioF/kUm03t0uFq9qZtzCex7HQruVcWrq2RALsLrrDyYqX0v9EUn1VKU/F1dyqL+b2bErL1K/7Ihx92lbXPYwglOzY9oJrNyIOitdji9YrwLDSE1lkAshO7FNjkXSac/RSQukQ/I9D0Y9nyvu6/+eQrGdOnXTobynbwKotCIP3i+T9JxQJbzZOUDqJNxOtIEvwid2WOpuDGeTz/IkI3+/Em8ki8++sYacO1ujM/WKo0
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 16, 2025 at 07:16:48AM +0930, Qu Wenruo wrote:
> > Is it very difficult to add multi-shot checksum calls for a data block
> > in btrfs? Does it break certain reliability guarantees?
> 
> I'd say it's not impossible, but still not an easy thing to do.
> 
> E.g. at data read time we need to verify the checksum. Currently we're able
> to do the checksum for one block in one go, then advance the bio iter.
> 
> But with multi-shot one, we have to update the shash several times before we
> can determine if the result is correct.
> 
> There is even compression algorithm which can not support multi-shot
> interface, lzo.
> 
> Thankfully compression is only possible for buffered IO, so it's not
> involved in this case.

Would it be acceptable to vmap() the pages and do the checksum on the
virtual address?

> However then the problem is why the read iov_iter passes the alignment
> check, but we still get the bio not meeting the large folio requirement?

The virtual address _is_ aligned.  It's just not backed with large
folios, for whatever reason.



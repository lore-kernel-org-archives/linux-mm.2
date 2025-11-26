Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2F1D3D1118E
	for <linux-mm@archiver.kernel.org>; Wed, 26 Nov 2025 19:26:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 630DB6B00A2; Wed, 26 Nov 2025 14:26:49 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6082D6B00A7; Wed, 26 Nov 2025 14:26:49 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 54B2F6B00AB; Wed, 26 Nov 2025 14:26:49 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 434B06B00A2
	for <linux-mm@kvack.org>; Wed, 26 Nov 2025 14:26:49 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 058508A4C1
	for <linux-mm@kvack.org>; Wed, 26 Nov 2025 19:26:48 +0000 (UTC)
X-FDA: 84153740538.23.5688E79
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	by imf20.hostedemail.com (Postfix) with ESMTP id 3AC291C000E
	for <linux-mm@kvack.org>; Wed, 26 Nov 2025 19:26:47 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b=m5IyTggr;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk;
	spf=none (imf20.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764185207;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nU80GOb9NiCLGKUDlF0jPjWnpLtyN6G9RlF17vc6RcQ=;
	b=iXuBW5bSNMYPFnSsnUndbIxCnOZDtLWpRj22cYxPdhtVn+lIglJ5S8dYu877qOcPbKFWKz
	OxMDR5tjS3Ec3WfI8TccQrxKffzLuKG1xSoO8hy7s1sWZKHRfKkgb1XYM1Qtt5ErlJkiOt
	Sy7AUb1W0zVL9offX+cO3x3GCMiZn+o=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b=m5IyTggr;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk;
	spf=none (imf20.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764185207; a=rsa-sha256;
	cv=none;
	b=SmOd4YXRPvm5HUZKzm3cp8T/eYHmxTpAs9U+b0WPZv8DeuK5CeukJ+l4O6Hv7SJY3FKb0B
	FQOT+SATaMyoGZuQkLPKB3C2mcUB5vosr2katXWJkrfWLyks3e4CP4aQhkTxZwFDxmeqZ7
	JW1M7lc1P0lTXSrtDRd8btwpjRt4w6Y=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:In-Reply-To:Content-Type:
	MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=nU80GOb9NiCLGKUDlF0jPjWnpLtyN6G9RlF17vc6RcQ=; b=m5IyTggrRAAY5MhBN6EpasSDVL
	YnL4rtLPSW0hBjjOgYMp5fLiiyp/wwm7von1AJhAekg73plC0swbRI6WCfUWNQ+P6t7lyjB2IwWHK
	dHG3UMGxNUmXcARXsH20a+MKTVvBYdnODh/AQrhfKkPdN/yqqcu2nz9UzxOTCwSxCeDov1UGjAWpd
	LRU9WIJuinhZqwhWTWmliPFSxagjI+DUY21bqlM1h0ikrfoablwBCOy2u85OE1+TvvgXc8peS4IO3
	q6s2ELwC4XDldzOHD/QHYDaCIUs7has7C2uaIiYN19w0u1KZqxMxK8bdXYbLyPvUw9OW2F289fVxg
	elLHBApA==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.99 #2 (Red Hat Linux))
	id 1vOLA0-00000000kzD-2DFB;
	Wed, 26 Nov 2025 19:26:40 +0000
Date: Wed, 26 Nov 2025 19:26:40 +0000
From: Al Viro <viro@zeniv.linux.org.uk>
To: "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc: Xie Yuanbin <xieyuanbin1@huawei.com>, brauner@kernel.org, jack@suse.cz,
	will@kernel.org, nico@fluxnic.net, akpm@linux-foundation.org,
	hch@lst.de, jack@suse.com, wozizhi@huaweicloud.com,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, linux-mm@kvack.org,
	lilinjie8@huawei.com, liaohua4@huawei.com,
	wangkefeng.wang@huawei.com, pangliyuan1@huawei.com
Subject: Re: [RFC PATCH] vfs: Fix might sleep in load_unaligned_zeropad()
 with rcu read lock held
Message-ID: <20251126192640.GD3538@ZenIV>
References: <20251126090505.3057219-1-wozizhi@huaweicloud.com>
 <20251126101952.174467-1-xieyuanbin1@huawei.com>
 <20251126181031.GA3538@ZenIV>
 <20251126184820.GB3538@ZenIV>
 <aSdPYYqPD5V7Yeh6@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aSdPYYqPD5V7Yeh6@shell.armlinux.org.uk>
X-Rspam-User: 
X-Rspamd-Queue-Id: 3AC291C000E
X-Rspamd-Server: rspam11
X-Stat-Signature: ys8puredodbdz3u4bhpsrc5hkgw8o9fk
X-HE-Tag: 1764185207-78788
X-HE-Meta: U2FsdGVkX1+Ajeame2aue7ry9KlRgXDQGri7j7GX5wfO9C6TmWuKTfu0eqGyDnn1cbDS6+wgUhckXhMOGMW+LDhEM11RDeJP2dD5vDFg3zhvkGaCrJJGOvjxRPgBTIOY6/gDoBOK45lwmJfSz66ZBfN2mLSJa+2efq/2RKyf3Z9Ejlm22+KE3GeGQZ1FkjdHKUv+qowTzuT8h1DaJ1fsBoZiKthCdZGzrRNmblB0iDFtsTdOgZH/f6x1bldk/e+h6d6VozttC2PSPIG5tYTpMuQvQEhPsRCFyRyuIB0ET+/cASFYEI7gJWugHEr5LpS6jtg2t43bwKKPWtlkx+nqJ4wrJHEIcFpQuGBVR6tKMBq+Qm8TVpI/Z5q9Zh4ZPuYcsk5SR1BTyrpVmHtv2KwVUaemOE4UDEf/Z769XR10O/QLAlxX9wXdGN2tkcdnoc6zbn2nWo5XrBmY7E4p3UCbK1++TuL0gKmO8XVOQGdSuzUDfLTv7EuAFeDWGSE5aOpbd7KbS7fl/Um4TEWitMJ0TofBSeac8f+2TJ4yf1Kenvu6iCRiI+z55TUQk2TpflMpJcdhzVQmAPA2L9EHD2M8uaqYwv4pxZDG3sIGZfZhq8XnnPnqPVoWCzg9eI5N5ioAdhnQEJGrkjXHiLRolMyIWz49SpZkrpJTSRzm1gWD275bPIdw6eRYKbbd11+kf+QAAH8XEKvPlv8g7KJM8TueCNFL3Yb6CYsRXXsBe9ByaC2A0PuXtLQIi03v3tPtA7/+/1Ep/H0nmEdSMnjvFZXq2sEBbpN9KXZcdJKr0p+pRng3qf1BbAtkh7YihBCinRHc8V7pxduP7L0hsk/QORh8QV70P67XWpk43s1X5/KdU8ffOLu9ozQp85DmySTgw6bvCQbB/3GK3GE9HKkWnPOG+AC7nGKZrwsb4ll9qC5ZG3S4qHIAFZ80pay4SqEF61h8NagARi4Mg5I2jgt8lcd
 MjVjqoGp
 zKQ9fjwqIjTSbXWQdhjUDmh5uW+19VMJr7gC99f6mDxj50y1LwrHXHP8dkg6naPnHzHawTbRvwHt5uD6eOIJKXVIbZH0W7fSDQPIy6JrZbwuWA44OBDHISB+U2k4WscCksobMQE2cmQXGMVk3ih6YUjYkEiJPbEQvgMDvYEmPZ9qskDTnEv8rfYNnGW+S6TBL/LbApUVgs9FecpHkzgfuvXV8wkcmAD4zF1c9lytTQlmSRhEusT89lVVlKsHBIwH2VgvcTkJITTbCjNVkNgHBeLBUsTO4gQS9U2fy3V/xG/ciCJQQILQurLBr7DqKoU60yoW9Wkun22RymSsmbyWr4Du1sObuEcfeQBXqUUTBeg3UupBcVVIF6iChmnYFa/abRM5JzibTABrxRu6dUk3SrxRAspNoI3tLjAtIzBEyu1nUdUHX7p3L+qyb8k1TR1LImatW5bPZfV6hr5Debl2wNh12rLjJWN3UC/SjD8ltSqO9SPk=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Nov 26, 2025 at 07:05:05PM +0000, Russell King (Oracle) wrote:
> On Wed, Nov 26, 2025 at 06:48:20PM +0000, Al Viro wrote:
> > It's been years since I looked at 32bit arm exception handling, so I'd need
> > quite a bit of (re)RTF{S,M} before I'm comfortable with poking in
> > arch/arm/mm/fault.c; better let ARM folks deal with that.  But arch/* is
> > where it should be dealt with; as for papering over that in fs/*:
> 
> Don't expect that to happen. I've not looked at it for over a decade,
> I do very little 32-bit ARM stuff anymore. Others have modified the
> fault handling, the VM has changed, I basically no longer have the
> knowledge. Effectively, 32-bit ARM is unmaintained now, although it
> still has many users.

Joy...  For quick and dirty variant (on current tree), how about
adding
	if (unlikely(addr > TASK_SIZE) && !user_mode(regs))
		goto no_context;

right after

	if (!ttbr0_usermode_access_allowed(regs))
		goto no_context;

in do_page_fault() there?

NOTE: that might or might not break vdso; I don't think it would, but...


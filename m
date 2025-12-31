Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4099EEE644C
	for <linux-mm@archiver.kernel.org>; Wed, 31 Dec 2025 15:29:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A2F9A6B0088; Wed, 31 Dec 2025 10:29:38 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9D9A36B0089; Wed, 31 Dec 2025 10:29:38 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8C4E16B008A; Wed, 31 Dec 2025 10:29:38 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 7BBE36B0088
	for <linux-mm@kvack.org>; Wed, 31 Dec 2025 10:29:38 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 4288DCBDF8
	for <linux-mm@kvack.org>; Wed, 31 Dec 2025 15:29:38 +0000 (UTC)
X-FDA: 84280150836.18.C8AE279
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf20.hostedemail.com (Postfix) with ESMTP id A2BB71C000C
	for <linux-mm@kvack.org>; Wed, 31 Dec 2025 15:29:36 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=mQlnXOpv;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf20.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767194976; a=rsa-sha256;
	cv=none;
	b=bDIeE2/fCHcD44VhUqCWlG9V6yfy2BVgEKz18pEMARjTW1Pnp1pWiQlH5A+hOBm6/lXtl3
	Bx3OpVbvf7mlNWgojtj/6FoAZlcBVmsYqfaSk9YOkpjxL36gQyRcMxGOQsPeDay99ZungK
	5xZgjDtCLao4snwJW8kHHS1H4UZBje8=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=mQlnXOpv;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf20.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767194976;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eod36FJrXsH2inDv/ylBjqQ5zLll19BF/Q5q6a0GazQ=;
	b=QFfhNtrDIZtkfeP/Wcxp3mAT+1BVo0Mt/lruqXcyHgwaUeHt0QlNN/PAQ11P4GYyeLSIKC
	mCTcOd2s2IHwxnMLlcvi24XLBrElyMq2UVlZTDxrcYhz/bHqeGA2vto21NeKwzQZLYojX0
	PwoysJ4dnVUha0KB9JDNU32UcDX5GXo=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 0733B60017;
	Wed, 31 Dec 2025 15:29:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9921EC113D0;
	Wed, 31 Dec 2025 15:29:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1767194975;
	bh=Vkga7E40Aqb7h9QBR095J8e6qqtQ1jkzPSsHC7PjWCc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mQlnXOpvoPNTuysJKMrLTlKBeZF57Aryvin7lnD1RZXi8cB8oB+LtfO7d1Af6Gm5E
	 aEDvJXtnMtghcNmuG8sXhF1MdliVYo57ZxT5GlOFgkIqCP0POJsiiiVCcbof5BTnSC
	 RCYV/4O/SZ/ByiYJB8vuRYwcTTygsjXYGqtx8lbUcHBbfY+4GV5ngyU5DXpDyaIp7q
	 /J8Kz5Q6CLAPOSaG+9f0Mhuu5Bw4j27VKPs6z1Qt00dYtHSTIS2ZX/NwwF1VVVoeK8
	 EhQKFgACrAiY207JYL/6up2Z2w33/GezNGKljnJsaY7B9e7S8to4I/peXbX2Wu3QY+
	 SB+deAUhCcSlA==
From: SeongJae Park <sj@kernel.org>
To: JaeJoon Jung <rgbi3307@gmail.com>
Cc: SeongJae Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	rgbi3307@nate.com
Subject: Re: [PATCH] mm/damon/core: modified control->repeat loop at the kdamond_call()
Date: Wed, 31 Dec 2025 07:29:29 -0800
Message-ID: <20251231152931.82221-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <CAHOvCC6RwVzujJcuosiignDEQoe038eRJHuJVLEtJ4-qP8Ot9w@mail.gmail.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: A2BB71C000C
X-Stat-Signature: fao6tp8w6ahm7d3ejuts4zqwufaw31uu
X-Rspam-User: 
X-HE-Tag: 1767194976-997203
X-HE-Meta: U2FsdGVkX1+1PaCtwTXm8zEBZc06E4VA27DEwgT/7+b5OT/vwlzWIzhr68ZyUe4+23OSraCSmyw/Wvgr2IZNMcA0Ju4XaPSBwfr7LLvlTdL6gq086RIDuzn4K10K1NZnHPo8UeqtbeMB5eanS/5fvUT84T5ddPqxBLm7NPdBPKtzP1AJs6Fq6Bfk+rsn0uzOok7Fx4wKQ+nW3plKkpQF1Y9On8wXbBkjwbB2VBGezyXVbkPYWra6NcAViPC1JSlp+z9goqUcFDBjPJrnK/zRRPL/1n8LKtSK2VY/0k02uetbPqFmYgt084ETswAWAwzzTFIB7Unf317Fg4SuUXKmzGKeD5DE3BVVpM4rRKgrUx5BZl2rQxzlplVkIi8B77krLc/3mhjJe+bXGd4fiWsYF1/HEEt/+c6RhlliUETIwjh4lwEDaNLkp985x4GiGnCPY6G1scrHvuZUjrGzq5SfDr0NENHf6dgB1zHC34RKCRsh+U+qzJdSrbG5f1XV0l3P7gSLSuM4MOBNb+gc9KWi2+gaweSwe+fPG7IA0O18R1ZYiclER7Vl4M7rr8Vzyv3P3tBIhgFbZf5AOi3lfZlzfkxp1p9Sk6/xyy/EJMXrE7qFqdkwHtKJ6CQa8046yL3YrNlaxNhNcWT8M+Tkfa28L0YJW65D4uGZBSSZYn8/oMGojZ89J7hIMYGAC0+POK07xWxcY6tn//5BLAkXjvMz9cxf5vsC5t+BtjP5559rDAl0xtOIL6nZhi/+In+VKQJxI4XXjU3jMIL7bf4LJhUgj/UMppex3OTk+ufz577y8OZk9/PY9ghYw100dSJSvX/0fBGiJGFxjNo40VKEEgOEg8eVaLSPV6EPFgppMkpZybEMRwXre9n0gU3mvsBfJsIlgkO+YoUFNZVjm3VH4mTVaTjkxhFWVsiF/JnnoW8k4o7wMllBIA4sWw6foxCAJ+do+DAeF53/JPEsVT5H6Ve
 i+PXqg4T
 4uPLFrIMOlfymx46S2Pzf5r8+alP4/iwhteOon3nFlkcGGdVtqzUWZSjY/W9ZxPjzDwZu80HKhuoFMyuylnbWNI5ZPRovTVuwpQmmgiJnIRP+nRbjqZSmzzpUBUfjWAeIJgo6ytPAXHLcsCbBqJcIpkPDvgB1qLkHRa0FsWjERRRcktRCnKyOpBII7e14siiR/P+j+0hTHQbf8nR1NE19YXnYArOIGAhH8YraiHSz1fXSAuYCcrg0rXNitZQMkyEBaICn
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 31 Dec 2025 15:23:49 +0900 JaeJoon Jung <rgbi3307@gmail.com> wrote:

> On Wed, 31 Dec 2025 at 10:28, SeongJae Park <sj@kernel.org> wrote:
> >
> > On Mon, 29 Dec 2025 16:57:15 -0800 SeongJae Park <sj@kernel.org> wrote:
> >
> > > On Tue, 30 Dec 2025 09:14:37 +0900 JaeJoon Jung <rgbi3307@gmail.com> wrote:
> > >
> > > > I will reflect the above in patch v2.
> > > > Would you like me to resend patch v2 ?
> > >
> > > I just found my fix [1] of the bug that you reported has a race condition.  And
> > > to fix that, I think kdamond_call() will anyway need to be modified.  I will
> > > shortly send more details as a reply to the fix [1].  Can you please hold this
> > > refactoring until all discussions about the bug fix is done?  Sorry for your
> > > inconvenience.
> > >
> > > [1] https://lore.kernel.org/20251228183105.289441-1-sj@kernel.org
> >
> > I ended up sending the new version of the fix [1] without changes on
> > kdamond_call().  Unless you have concerns on the fix, please feel free to
> > proceed to v2 of this patch.  Thank you for patiently waiting.
> >
> > [1] https://lore.kernel.org/20251231012315.75835-1-sj@kernel.org
> 
> My patch for the kdamond_call() function further improves control->list
> to behave as a FIFO.  This also improves stability against the control->list
> collision issue encountered when damon_call() is called.
> If there are no further objections, I'll send you Patch v2.

If you want to say something about damon_call() uaf issue, let's make a
conclusion about it first, rather than mixing topics.


Thanks,
SJ

[...]


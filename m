Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 95B2FF8D762
	for <linux-mm@archiver.kernel.org>; Thu, 16 Apr 2026 17:58:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 933256B0096; Thu, 16 Apr 2026 13:58:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8E41E6B0098; Thu, 16 Apr 2026 13:58:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7D2F16B0099; Thu, 16 Apr 2026 13:58:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 6CCB86B0096
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 13:58:43 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 1629F160622
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 17:58:43 +0000 (UTC)
X-FDA: 84665179326.06.79DA7D1
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf12.hostedemail.com (Postfix) with ESMTP id 9B08540006
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 17:58:40 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=W7vSzFZ0;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=none (imf12.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776362321; a=rsa-sha256;
	cv=none;
	b=nEd3KkuaVUtMrkjFpZoCnuChxsTLGl2sIu3vGR6r3PrQhitHcUoM4laoaw+iprSeQ/EiCM
	b+t2P3L/6Vg28Yi3GYbPvasoHf5wv+J0Zon9q9XO36rAbMSd8hMunuuqI1PqhLMdVhnFh6
	s033DUvABPwrBhG6lJ/HVSYEzGTHkcU=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=W7vSzFZ0;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=none (imf12.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776362321;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lJRRddWkYSALa0B6GSWFZ3ZeCBLOx02UZufpyBXheIs=;
	b=7CYoUIlwEOP7c5yXmZonUY4sSav6N0hrFFIsjto94Rb88m44lnQG+jjdWoSQWCk/y3xkal
	m1fELSYj37U2EjmJtnsb/L9D4Jfikj9db5KVzbpHLskD25YZeec4p2XQWfYitBfk4/L0Qi
	Xl7ycUHyGYqNkHJiQMfV/jA+vuPGXL0=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=lJRRddWkYSALa0B6GSWFZ3ZeCBLOx02UZufpyBXheIs=; b=W7vSzFZ0BBGM7+i+x9PUT7gKhe
	jPD3siMA85ibGG/JGILBT1ddf3YoQPK7fRTVInbjKF4FQJBc11khwjd23Rp6J2iG/8qt/kh8llS1o
	ap5pbJLgDrs1IVciGeLTgxin2oNQqMTBYlgbaxrIXbvmPvNxZra5KHy4bBvM+TV8cH6GkcjK3a+4v
	ZNNM4dmKA3clrYTWt1OQ9Cnb7Z4pOyzPt+avTRg7EQyJ9hi8vLKbaoowF3ds+rKBG8PrqwwGeGYN4
	/RgycR1C+ELH5qfHtyQUWcBcp4kQnwCFWbuLEKsNdWEfDGMMUsAn2uQ3B1MbL/rp6UAzeu62JEVOL
	5ge3LqHw==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1wDQz0-00000001zKZ-2xpR;
	Thu, 16 Apr 2026 17:58:30 +0000
Date: Thu, 16 Apr 2026 18:58:30 +0100
From: Matthew Wilcox <willy@infradead.org>
To: Barry Song <baohua@kernel.org>
Cc: Anatoly Stepanov <stepanov.anatoly@huawei.com>,
	akpm@linux-foundation.org, david@kernel.org, ljs@kernel.org,
	Liam.Howlett@oracle.com, vbabka@kernel.org, rppt@kernel.org,
	surenb@google.com, mhocko@suse.com, wangkefeng.wang@huawei.com,
	yanquanmin1@huawei.com, zuoze1@huawei.com, artem.kuzin@huawei.com,
	gutierrez.asier@huawei-partners.com, linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 2/2] filemap: use high-order folios in filemap sync RA
Message-ID: <aeEjRtNbQI71I0wA@casper.infradead.org>
References: <20260415192853.3470423-1-stepanov.anatoly@huawei.com>
 <20260415192853.3470423-3-stepanov.anatoly@huawei.com>
 <CAGsJ_4yBmrFDHLg8Cf7x0dCLELBp+kY6yoMuP_sHt4Z1wuVrBg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGsJ_4yBmrFDHLg8Cf7x0dCLELBp+kY6yoMuP_sHt4Z1wuVrBg@mail.gmail.com>
X-Rspamd-Queue-Id: 9B08540006
X-Rspamd-Server: rspam12
X-Stat-Signature: q14ufetsm58gqg3m5wxgqgbimqm19d4h
X-Rspam-User: 
X-HE-Tag: 1776362320-910610
X-HE-Meta: U2FsdGVkX1+dX6xL4eeBDSboqmCXpTReupx38tWHF/gn4mHRqoawqohvzymRQHA1p1KP3sUPyROJjbGmL7/uWuoGPZmCAnAAcumknWCddQd0cLSdfBr7puFIGx16g2bdhLZYOanL+UqiukHg5Iw3KKyAftn5DNNsrI0JfDF+A/MvI27ynkg+7owVWXqXnawu08OIUj6jUFXBtfLKa52l22L4qyQlvRNadqzHSOVT/4qffFIvT6wO8GPENxylcEOx6K2CsKh6ohEJtMgloBY2qs3LVXfTEgJ6/gqnpK1qGDAHgHFzvRasT0Yq5vpzlK7nk0CdHNcIpBpaMMqa5Xrq7rlQZKBVHwiL1zwWg+8qWzMcxApUqEINTBy0YCNiyEdWZwNMPeTXTAS1rfY1uABCXRebHslqhuTGjnBy1ofuwyOitzieNKreNSgGFPRZUAWCzpL24N8KbyTOHRy+xfoik7irmoU4tStg75rJJQ/S85NuOR+wItTbFqvhwGMNVvs6rrS3MN83C+3XfPXgZz5quh94SR9PO2jEwFwWo9wTyrm1cvwCQRzDVTxZk54eB9MoNHYqd/GWYS9qULAUJXuuLgr+BjDzgDga1bztGSTM0WIikfE+AtHqosPCxr4UxhLi59bHtYlRqNcFDpdGh0HCOUxbh+cEyEh7M4HK8sPnESNBi1VAB38GScTMEd/BwRjtwapTMW4Yua0nC8dB7vysruBBWulp1+vuIvv75h008VonhOib1H9mMJ3VpqyEl8pNwDEDI5lTtxFn3OeRxy5GjZCv2/FcEbJ+4mnng3qVTLF6aYvjm+SmKBMduvcqCtFg91erVy5lKjCGeETP+YDvy66ZGr445dBMmZ7ErC6VyuUy/8OIAFzmNebtuFQPZogl+mkpFwBP1v69vB1F1b+gVtN2aC3p7EZ5O1kL17GDSCmaGc9ukFeHjcFujOjge1ABys9+WApLh5BUMZ9nIS2
 NiKsyHyC
 zFAB0u2BBbTrHiPZ3v7HoQo/s+hmkf83P4sAcbvqrObnU2jvtrqZTlr/hcg723O4WqxsOx66g7lcdZpWr1fuIDFlk/enLAu+qfIYGWcl9819+O8U1MJh9VMfvebjaQsmYvzPjbhQ8rNSzBAOM7VGgtC6+/iv6m2TBWT/uaS2mmMNeetMeLy0ciHBlAoaXLGRk0Od1dz5Jb/iEYHepBpW3PKBo0IXlWLe7YrfXXCTtpjnqDS8t3J0ZaNHx1rf0AFiuxBqJ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Apr 16, 2026 at 01:30:32PM +0800, Barry Song wrote:
> > Or introduce some dedicated tunable like "sync_mmap_order".
> 
> I guess we could benefit from a small order, such as 1 or 2.
> Order 4 is really too large for many systems, such as Android.
> 
> But it seems Matthew never likes new control knobs?

Correct.  It moves the burden to the sysadmin.  And either there isn't
one (eg Android), or the sysadmin does not have enough information to
set it correctly, and doesn't have the time to know that it even exists.

We need to be self-tuning.  There's no other way.

Now, that control loop could run in user-space.  And if it does, then
we'd need the kernel to expose a control knob for the daemon to tweak.
But then the daemon has to come first, not the control knob with a vague
promise of a daemon to appear in future.  Preferably it's part of some
userspace collection of utilities that already exists like util-linux
or systemd, so we're not relying on people finding & installing some
new thing (that again they won't know they need).

THPs in particular have accumulated way too much cruft over the years,
and there's a huge amount of misinformation floating around on random
webpages about how to configure them.  I think we'd be much better off
just ignoring all of the knobs that we've put in.


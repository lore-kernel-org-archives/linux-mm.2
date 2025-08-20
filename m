Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EE267CA0EEB
	for <linux-mm@archiver.kernel.org>; Wed, 20 Aug 2025 01:25:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8AE8D8E0014; Tue, 19 Aug 2025 21:25:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 85E918E0011; Tue, 19 Aug 2025 21:25:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 775038E0014; Tue, 19 Aug 2025 21:25:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 6427F8E0011
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 21:25:46 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 1B2561602DD
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 01:25:46 +0000 (UTC)
X-FDA: 83795393892.26.4AE09A9
Received: from out-186.mta0.migadu.com (out-186.mta0.migadu.com [91.218.175.186])
	by imf08.hostedemail.com (Postfix) with ESMTP id 2CCA716000D
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 01:25:43 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Gg9GIEH9;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf08.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.186 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755653144; a=rsa-sha256;
	cv=none;
	b=FJq3WxcNhStE8O8flVlPI/VsqLVjDPcVvMQnVEEh0BwEEo/BKcu5XgAP/UmxDFeccrHlmN
	i24T8BUPRf7gSyp1gnGKT4GlZRyPtnbP6mI1Mnkz/BaPDvjxyRlczZSufI0MpTtxsx7hQg
	zxWxwcArHUU4Jehh8VDaS/bxrnC2e2c=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Gg9GIEH9;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf08.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.186 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755653144;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DkCULZqBLybzeAKmdXAlETYe7ipFpeIMTG5c5FRzUbI=;
	b=49tUg6A/eAjTUQpnRWS3P7tB3QkDj789wbleqZqWD1MEVFLoKZiPXq2SYye6tKzTakVi5h
	5EUHlXDYUtyqA3GVJXa0T2wWdcxd+JXj0hRaLPia/dP9bDPTOkxXylIwM0rt98MRaO8nEL
	H3bRal27ioeo1/bU5JNVn32EdV4z7Fw=
Date: Tue, 19 Aug 2025 18:25:36 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1755653141;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=DkCULZqBLybzeAKmdXAlETYe7ipFpeIMTG5c5FRzUbI=;
	b=Gg9GIEH9q0a7IsSCOvI6pgjSSlTFw/gjrCNDmj7tWlpKN4PIdTswdIvd+cUZlvJuG7GQr9
	OFSMilzzKNRMpGI63hXW+N3n18A1v+sA6c7rXhdjxwYhObCMeWB6fhbvXzCX007PY8FYOq
	ULwmU12vfOoJej8VZFbJtEil+/3KH4s=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Matthew Wilcox <willy@infradead.org>
Cc: Boris Burkov <boris@bur.io>, akpm@linux-foundation.org, 
	linux-btrfs@vger.kernel.org, linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, 
	kernel-team@fb.com, wqu@suse.com, mhocko@kernel.org, muchun.song@linux.dev, 
	roman.gushchin@linux.dev, hannes@cmpxchg.org
Subject: Re: [PATCH v3 2/4] mm: add vmstat for cgroup uncharged pages
Message-ID: <i4hg4g75ywbera643uhtshkj6xrriqi4mi5dg3oga5os3tp6m5@u2dcv2snbiqs>
References: <cover.1755562487.git.boris@bur.io>
 <04b3a5c9944d79072d752c85dac1294ca9bee183.1755562487.git.boris@bur.io>
 <aKPmiWAwDPNdNBUA@casper.infradead.org>
 <tw5qydmgv35v63lhqgl7zbjmgwxm2cujqdjq3deicdz2k26ymh@mnxhz43e6jwl>
 <aKUM49I-4D24MmwZ@casper.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aKUM49I-4D24MmwZ@casper.infradead.org>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-Rspamd-Queue-Id: 2CCA716000D
X-Stat-Signature: 86wxkge543tmsk8qmoi8tihzr5hiixqb
X-HE-Tag: 1755653143-589607
X-HE-Meta: U2FsdGVkX1/4mPP5Kh5iUaN6n6qfra0F8g1BGOdOdBGbTNc+PAnnFE+Zg8hYfv50azGcyqCazyDbu8bxa8dAN3wzLqmgjpgp10qUmyL5qqC4v3q1KqQG3xHejPsEJm4A/zqHzKufgT7c4SbbUwI12LABEwR3BMrYtl1PcKVUiLBPylkqOKTxp+J8WWxTn4jYu7/QMTowQfJ+aW+lK6lOiAxLmhHT+1gDnQ0Y/3zc0ksaevz5apJtOraH33jBUrcPb9N2yq+dYxgzQkvxBz+WaPetiO/iKICGQRA1L2taxVrp65adoEaqAXlrQ0o6/c6EwtlywGRPgdTkx7TSD18EOfoaQgL/lE+998Hm91K/DXoKcRUh+d0I2dPpI2Hwo65I1aleoQ904bSft5pDLeDN3w9YpUIhYc3Ssry6xPv8VvFL2HW3TlQbgIupPOl7JjeprSDlQMMwI1K+as9x/nvmBC/evUErCi3Cpf/IhVSs1/E15rbEzszZFjBOzinFjsVWYcnr44zKXjqw/ZleD/X4VUqqRQzT7qoAQVGhRVWoxh+gdpKMIlIb6bz8357sRT0fcAWKCzKtEO/U7AlaQol5fbQDI0onNLGejNJpjE4SwPrI3y7uVVh+yj5BOrtwCzvlKI5nFTYF2ngk9j8M3Ul/29SDUTcp986KLtf05GjcPW3q0hGNYG2C8Qe1QXdHSKjYO2x52FGAWTHhMYXWydcvuHThjmcxxnv8suCCFCOoKOfVZwhrYWGXoSBiFt8AqoVbMkc/kH4Iy+aeLuMfwhHVVdfP8Kc00FbIBIgriUtZmpWueySNQRFJCp2G25bRue+SvadB4MDERpnJkTsKMDE372gTvJS68GyDWWXyqip2ac2J/KDi88UgJmPjnuaQMdM9HPatIVjxLwHx2sl044BnG9rWu2VwnPRYWzGPWUoQvJekyqsDx9XJD0oDxOw7OPL1dmP0u2xjUGw/w2Z0t52
 uev8au4V
 I8OedfiKnFjfrOBri9Elb0SGGMLZycdeVWIQldw+Ei+wiTTR7tg4IvnXcpMuEKjuGs0yBxn6ZfJM/kyEFtINUh+0x5V/rYVwXAyzOaTaHl63JNZ6VHM8eP39elCE3xh0vAjM2pzfVEMludDKM4+ZzSSgJl6Cu/Qw59KewTGMG/7G+fL1RgeO0u9Tz+jxr1Zr7vd/QVJUZ199OfTN+08cxzCWgSw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Aug 20, 2025 at 12:46:43AM +0100, Matthew Wilcox wrote:
> On Tue, Aug 19, 2025 at 08:53:59AM -0700, Shakeel Butt wrote:
> > My initial thinking was based on Qu's original proposal which was using
> > root memcg where there will not be any difference between accounted
> > file pages and system wide file pages. However with Boris's change, we
> > can actually get the estimate, as you pointed out, by subtracting the
> > number of accounted file pages from system wide number of file pages.
> > 
> > However I still think we should keep this new metric because of
> > performance reason. To get accounted file pages, we need to read
> > memory.stat of the root memcg which can be very expensive. Basically it
> > may have to flush the rstat update trees on all the CPUs on the system.
> > Since this new metric will be used to calculate system overhead, the
> > high cost will limit how frequently a user can query the latest stat.
> 
> OK, but couldn't we make that argument for anything else?  Like slab,
> say.  Why's "file" memory different?

Good point and I think it does apply to other memory types too. I would
call "file" memory to be more important as it is one of the largest
consumer of DRAM on, at least, Meta infra. Slab needs a bit more thought.
At the system level (i.e. /proc/meminfo), we account at the page (or
slab) level while for memcg, we account per-object (plus obj_cgroup
pointer).


Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 113CDC88E75
	for <linux-mm@archiver.kernel.org>; Tue, 15 Sep 2026 06:50:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F310A6B0095; Tue, 15 Sep 2026 02:50:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EE0BE6B0096; Tue, 15 Sep 2026 02:50:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DD8A56B0098; Tue, 15 Sep 2026 02:50:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B10DF6B0095
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 02:50:51 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 3F93EA43C4
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 06:50:51 +0000 (UTC)
X-FDA: 85215073902.19.174B47B
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	by imf02.hostedemail.com (Postfix) with ESMTP id 5916580002
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 06:50:49 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=none;
	spf=pass (imf02.hostedemail.com: domain of hch@lst.de designates 213.95.11.211 as permitted sender) smtp.mailfrom=hch@lst.de;
	dmarc=pass (policy=none) header.from=lst.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789455049;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Fl3XDxOLKwkQaq7Gn83f938ZZZZx5MsQR5gd2rSVjIs=;
	b=LegYpZ8j35Vydza9JzNu7OLqZy7qmmpj1PhW+o6NQzU6YirSy0KnXOzsq/hfZQJ6hIIiGA
	aGOaHFttg4gLid3nCuW1kHuLPvkWFwFZ+nf1FaKWD2XyHxpOuiZ+NQmO7gO899GgAMx76n
	VQb+8ssEWERXwQ0lvsPGUxEg92MOvCA=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=none;
	spf=pass (imf02.hostedemail.com: domain of hch@lst.de designates 213.95.11.211 as permitted sender) smtp.mailfrom=hch@lst.de;
	dmarc=pass (policy=none) header.from=lst.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789455049;
	b=glVb8H3GSZHRK5U53FaUNbIUQ2BvwWAjInx7lC37LMn6GlFcNPoUXwNBfVq08HpAoM74tl
	uOPa6dx5blzns2wpTC+ABd6jctAni6pAgYsuxszBs4IWLxBffGjsHEOlqF84Hco0+QnFP1
	K4tRJATzoxlCM87/TbxeajXdD0gouHQ=
Received: by verein.lst.de (Postfix, from userid 2407)
	id BA6DC68C4E; Tue, 15 Sep 2026 08:50:44 +0200 (CEST)
Date: Tue, 15 Sep 2026 08:50:44 +0200
From: Christoph Hellwig <hch@lst.de>
To: Nilay Shroff <nilay@linux.ibm.com>
Cc: Yu Kuai <yukuai@kernel.org>, Jens Axboe <axboe@kernel.dk>,
	Josef Bacik <josef@toxicpanda.com>, Tejun Heo <tj@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Randy Dunlap <rdunlap@infradead.org>, Coly Li <colyli@fygo.io>,
	Kent Overstreet <kent.overstreet@linux.dev>,
	Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Benjamin Marzinski <bmarzins@redhat.com>,
	Song Liu <song@kernel.org>, Li Nan <magiclinan@didiglobal.com>,
	Xiao Ni <xiao@kernel.org>,
	Andreas Gruenbacher <agruenba@redhat.com>,
	Matthew Wilcox <willy@infradead.org>, Jan Kara <jack@suse.cz>,
	Andrew Morton <akpm@linux-foundation.org>,
	Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Nhat Pham <nphamcs@gmail.com>, Baoquan He <baoquan.he@linux.dev>,
	Barry Song <baohua@kernel.org>,
	Youngjun Park <youngjun.park@lge.com>,
	Nathan Chancellor <nathan@kernel.org>,
	Nick Desaulniers <ndesaulniers@google.com>,
	Bill Wendling <morbo@google.com>,
	Justin Stitt <justinstitt@google.com>, Yu Kuai <yukuai@fygo.io>,
	Christoph Hellwig <hch@lst.de>, Tao Cui <cuitao@kylinos.cn>,
	linux-block@vger.kernel.org, cgroups@vger.kernel.org,
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-bcache@vger.kernel.org, dm-devel@lists.linux.dev,
	linux-raid@vger.kernel.org, gfs2@lists.linux.dev,
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
	llvm@lists.linux.dev
Subject: Re: [PATCH v2 3/3] blk-cgroup: move async bio punt state to blkcg
Message-ID: <20260915065044.GB13417@lst.de>
References: <cover.1789237876.git.yukuai@fygo.io> <326e4904402440323532168095f2eb0c6f697836.1789237877.git.yukuai@fygo.io> <f27ee89f-5a52-4cfc-a14a-e5019ae61d89@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f27ee89f-5a52-4cfc-a14a-e5019ae61d89@linux.ibm.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Rspam-User: 
X-Stat-Signature: h5gydnkt8g8gkzwzej1xdtedmye3dwuc
X-Rspamd-Queue-Id: 5916580002
X-Rspamd-Server: rspam07
X-HE-Tag: 1789455049-43867
X-HE-Meta: U2FsdGVkX18Xtx0NMRb/y1bZiSjzAwpxrlD3KWsNmOHomd6i74i3ZspEBqxJYf92rqKWe+36/XPUlkBoepdid2YLDS3IlEd5XHgFWDMRsudAxWEweoJ+J7ih4zyRTt8lOleJuX8BwCZXUiRFWfNrUchsceQ37VBiC6TZ4Xo9v63nRoDrayoU9C9k2JScOYEk7NvV6Alvbz5GA+W+vKWUdEgVMLJ+QzeAvR25bXZcsUHstsLK9ml92HufR3KGxE+8GAg9AcuuDclqFtK6IVbxeJh4Emqpta2BIH2QO2sceS25Cm2aApTspJ37v6IsU8zXV/0UcyCDde6yYdIDb0xanH3cJPJuGvRRBhvpcZOtnvojdN81BaEZhU3GnH+ZJAOvMyePpJe4Ojf4zRDLToDgkZP/7kGhJfsMSg9F3DRgkES18xn+A4P5U18dBaUV1n2iUUi2oxkwfdDP39S2/NS27LNZ4/aCpGtiVdQoa4DREmhAq3+AFmuNRdGLJqtswfgBaK45IvtKt02h4fXIqTI6WYD1ddmfDSGaHqbMlbRRj+VTG9bfMwS3PSaeNfve/VK2HLunrhKtZSotLgvZ5i7afYPMCndIFYfKjvkaLPS4ydqmHrq4ACKon92hTFneGMmWVB9IE03/B27iaKYelbCOT0VTZmmwudJRHO2aVaBE9RQpuAD3FEnw5mOF5aztDkTXhrqhnj1/aIOJCg+MM5gJ7jmL4cr64gwacI3mjo2mjHTTQvxRvkFbPV/aTSt3VeM/cDDGllLKqJA+uuO0qBwbhf8t1+KTMFrqMhrRb9yeEW/AQGlUfP/knXy8fmWf0i1eQ0mtzpnWf9OLoQySa18BRTfkkdU4iV2RWFqHHA2x2MfNdYStsbxdlzPjFYFa9LN7X6/hZUxfMTkoYZCQtqjViaBEOtZHqjdKSI9wZ/fBbu2e2QuSuOzRPBfKGzhc1He4fnXeTuzpXIVQMnmwOUa
 hXgmGIJM
 H0nIUzURwyvSStZ1aB6bUGWAgIBWkVoNM7Sn4U1OXgtzfdRKmjZRLfNX+ow+1wAVmZCcdK/KeVEIjlX2BAGAsNj4Tpv4glljIfL/T
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Sep 13, 2026 at 06:59:25PM +0530, Nilay Shroff wrote:
>> +	/* as long as there are pending bios, @blkcg can't go away */
>> +	{
>> +		guard(spinlock)(&blkcg->async_bio_lock);
>> +		bio_list_merge_init(&bios, &blkcg->async_bios);
>> +	}
>>
> Instead of using guard(spinlock)(...) here, I think we could use the
> simpler spin_lock()/spin_unlock() helpers. IMO, they are easier
> to read and reason about for these short critical sections.

Yes, guard() is a complete mess that makes code unreadable, please
don't use it.  scope_guard is a bit better, but given that it doesn't
mix with goto based unwdinding it still is too dangerous to actually
use.



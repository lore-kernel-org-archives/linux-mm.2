Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3C707C982D7
	for <linux-mm@archiver.kernel.org>; Fri, 18 Sep 2026 09:31:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 31B386B0095; Fri, 18 Sep 2026 05:31:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2F2686B0096; Fri, 18 Sep 2026 05:31:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 22F1C6B009B; Fri, 18 Sep 2026 05:31:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 04AB06B0095
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 05:31:33 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 95150A0610
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 09:31:33 +0000 (UTC)
X-FDA: 85226365266.11.497D2B8
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	by imf26.hostedemail.com (Postfix) with ESMTP id DA85514000C
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 09:31:31 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=none;
	spf=pass (imf26.hostedemail.com: domain of hch@lst.de designates 213.95.11.211 as permitted sender) smtp.mailfrom=hch@lst.de;
	dmarc=pass (policy=none) header.from=lst.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789723892;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=L7xWQ/Xh7OdKlEqXJRfBV/i+Oxkq0zbHq44/RJY53Ao=;
	b=xgiAofUjfSXqCcqpUJ7+rXs7zs7Dd0z36aM/d0hEtxz03oVlef31TzIBJeNUVPI0xAUHhR
	6zgHqjK3VJuvRnbh4E45k9nvQSN2hCdWmAAtV1TWdhrf4sYWGSQJdDPf7Rhw36hRHEEh3n
	MahdMnVK0JbK9f/YkQ6RdHahKWIYciE=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789723892;
	b=YqMIhur2uZ5d95jKvO4P4ie5sbQ99n26B/h4UGLzFj9YvRW48Bb3DTZh78g/aYqcDfiywY
	JH9ve3E4F2Ytv3ulMTs5KyEM1eO+dORmYKe7VUtgL3nR8csLdd8M17+t1ottUgPWgVD6nS
	hu8UhmTFxI+HIrwrO6qUYSMFuXBIEE4=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=none;
	spf=pass (imf26.hostedemail.com: domain of hch@lst.de designates 213.95.11.211 as permitted sender) smtp.mailfrom=hch@lst.de;
	dmarc=pass (policy=none) header.from=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 6547168C4E; Fri, 18 Sep 2026 11:31:24 +0200 (CEST)
Date: Fri, 18 Sep 2026 11:31:23 +0200
From: Christoph Hellwig <hch@lst.de>
To: yu kuai <yukuai@fygo.io>
Cc: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
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
	Justin Stitt <justinstitt@google.com>,
	Nilay Shroff <nilay@linux.ibm.com>, Tao Cui <cuitao@kylinos.cn>,
	linux-block@vger.kernel.org, cgroups@vger.kernel.org,
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-bcache@vger.kernel.org, dm-devel@lists.linux.dev,
	linux-raid@vger.kernel.org, gfs2@lists.linux.dev,
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
	llvm@lists.linux.dev
Subject: Re: dm review needed, was: Re: [PATCH v3 2/3] blk-cgroup: store
 blkcg in bio instead of blkg
Message-ID: <20260918093123.GA13158@lst.de>
References: <20260918041744.1526924-1-yukuai@kernel.org> <20260918041744.1526924-3-yukuai@kernel.org> <20260918071634.GA10884@lst.de> <daf4ba77-4c25-4993-900d-ee1fe713d9b6@fygo.io>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <daf4ba77-4c25-4993-900d-ee1fe713d9b6@fygo.io>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: omx44tb58ppizdnqu3zfdyfjtotz6eq8
X-Rspamd-Queue-Id: DA85514000C
X-HE-Tag: 1789723891-869327
X-HE-Meta: U2FsdGVkX18gWXJwb0uuYocMyGYD4atQD7VF2srY7N8rYaU1tKRExs4uDAOPLd70qza56rsOZPiBGoGYFU2fXHxB25mJAxSt4EFUPxBAWBqxqpDLPsFATL4ObWQcFsD+379C8bmIdAKh+Ci8eslNWnWid/nuZG7idMFZvmEQ1xtn+rO9WEQhpBTJLQfy71wLpRmJtCqtc6RGpqTayqZzltHmiq1VMRPwTB9KBya5y2y6+RL1brqnIpPDX7SVG953NjaSKHzmdaD2bOTppytBrY1sdp06SZprDuAtU2QZcz03/zhMGCWzcxJYUtthb138o3Eo4dD2GEbW42r7EYoNkalmRMpF6smcNcHftU80pWWQ3ZjvQjZgIJXxmHfEC9pbGb5e8GdXmt0Y9eORlyQH0bSRVASsPUxMvklY+/wvrDFwrAnNAnNn0Tu/OOvw1j2XTL6ucCaP8M7M0jWsr4RAssj2H3wutvusz5g3gzifSTwAblXxrEodaW1pc7dtGBOkOQVvm/bFsCP8Bx10WoKvMoxbWV4lDFDNw7U4LPfwFu0LElNbOC+2YMJMDyyzUP1GUGXJBRhC6hMixH8vJglCxN1nfl7TqQcrcnOmnuJpviLrxI03NJj9JoSiB44lR03xe6Xz6EGw1PC+Y7yNyMf5KgH0zCvCmkmXWdKnlTmmnOztjV0OjRJsHhxYQhg+FMzSSEk/3ljRhYQYsw7OZo6kFPtLup7lFgopAqEoJ1e27eGMfbIHRjPa8gSrgD32CZbhUIBoN7J1NxA6t1Jd53a/3E21t5vjXZTaJgtyKD6guiFU8InPEutjERsmLRPzupoZm+BdX3qpyTTtKGZXU4BZSEgtWjvkhgYF7FlbTqyrdliJsoBBwzVwujZVzjTfHMommXmLCOil/Hnu5P9Owa2XX9ubA0oYGsNmMylUP6CJUUb+o1QZ0ABOxonvVbitaCbRrujuEuTiACakpHZD6Vf
 ncJlgCCp
 CfC7Cuylhh+4dwkYVBl4iDZpxVRKcqVRWQjA7gmxXJQqBdTrDR+/3QYvqHxh4WHd2gM0iiqZiTF9gK0yhjdlqhWyCn8qekGvtMtrq5G7s7SCGoWLtDFFG84yzrQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Sep 18, 2026 at 05:19:53PM +0800, yu kuai wrote:
> So I think we don't need to restore the reference, BTW, there is another approach to
> avoid such problem in blk-throttle I don't take for now:
> 
> For bio entering blk-throttle, we can clear the new flag and blkg reference directly
> after the bio is throttled and before this bio is issuing to disk, because bio will
> not enter blk-throttle in the completion path. And since blk-throttle is the only rq_qos
> policy that can be enabled for bio-based disk, then dm_bio_record() will never see a
> bio with the new flag set.

That sounds much better, thanks!



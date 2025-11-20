Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5ACF5CF58D1
	for <linux-mm@archiver.kernel.org>; Thu, 20 Nov 2025 02:09:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B7EC66B0095; Wed, 19 Nov 2025 21:09:21 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B2F086B0096; Wed, 19 Nov 2025 21:09:21 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9F7756B0098; Wed, 19 Nov 2025 21:09:21 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 898616B0095
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 21:09:21 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 2CF1289BAA
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 02:09:21 +0000 (UTC)
X-FDA: 84129353322.21.6F5E2E1
Received: from invmail4.hynix.com (exvmail4.hynix.com [166.125.252.92])
	by imf04.hostedemail.com (Postfix) with ESMTP id A3B6240011
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 02:09:17 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	spf=pass (imf04.hostedemail.com: domain of byungchul@sk.com designates 166.125.252.92 as permitted sender) smtp.mailfrom=byungchul@sk.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763604559;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=jGkdsWOcNziDL2MuumUKrfR2cNJoEjx96GjqBIGEXgI=;
	b=PiZgqoI6s8UjAHTkG3uUiIs7dgcs45RQNzIrNHxttuzE1XWr9seeLWlV5BMkXprNVtHsdC
	MfeU7vPFsfBgCoN/pN82vkC7wR6ENcJK8hXTdoPHE5CkmqNH3fAo6RO0g6+JXF7xYsF8rW
	DJkhIVX+m55Py+35UzS8hO8dMpvEaXs=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf04.hostedemail.com: domain of byungchul@sk.com designates 166.125.252.92 as permitted sender) smtp.mailfrom=byungchul@sk.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763604559; a=rsa-sha256;
	cv=none;
	b=R30nUXkMcq4vTw5HVpiUvDgQuV9OAfpCADnRjULEKgrOv9R2FtEA8ony3JJv9lr7k6A1nh
	4DkuZWF8WwTYzqFRTl6chqydPqqzzRzJj550uAbS/8WG1ptm6BcH6Rdk8oMBuw+8lgFzVR
	+Azm4ZLGnWc1xD0yM7ROBvF3+6HSWFw=
X-AuditID: a67dfc5b-c45ff70000001609-d8-691e784bd858
Date: Thu, 20 Nov 2025 11:09:09 +0900
From: Byungchul Park <byungchul@sk.com>
To: Matthew Wilcox <willy@infradead.org>
Cc: linux-kernel@vger.kernel.org, kernel_team@skhynix.com,
	torvalds@linux-foundation.org, damien.lemoal@opensource.wdc.com,
	linux-ide@vger.kernel.org, adilger.kernel@dilger.ca,
	linux-ext4@vger.kernel.org, mingo@redhat.com, peterz@infradead.org,
	will@kernel.org, tglx@linutronix.de, rostedt@goodmis.org,
	joel@joelfernandes.org, sashal@kernel.org, daniel.vetter@ffwll.ch,
	duyuyang@gmail.com, johannes.berg@intel.com, tj@kernel.org,
	tytso@mit.edu, david@fromorbit.com, amir73il@gmail.com,
	gregkh@linuxfoundation.org, kernel-team@lge.com, linux-mm@kvack.org,
	akpm@linux-foundation.org, mhocko@kernel.org, minchan@kernel.org,
	hannes@cmpxchg.org, vdavydov.dev@gmail.com, sj@kernel.org,
	jglisse@redhat.com, dennis@kernel.org, cl@linux.com,
	penberg@kernel.org, rientjes@google.com, vbabka@suse.cz,
	ngupta@vflare.org, linux-block@vger.kernel.org,
	josef@toxicpanda.com, linux-fsdevel@vger.kernel.org, jack@suse.cz,
	jlayton@kernel.org, dan.j.williams@intel.com, hch@infradead.org,
	djwong@kernel.org, dri-devel@lists.freedesktop.org,
	rodrigosiqueiramelo@gmail.com, melissa.srw@gmail.com,
	hamohammed.sa@gmail.com, harry.yoo@oracle.com,
	chris.p.wilson@intel.com, gwan-gyeong.mun@intel.com,
	max.byungchul.park@gmail.com, boqun.feng@gmail.com,
	longman@redhat.com, yunseong.kim@ericsson.com, ysk@kzalloc.com,
	yeoreum.yun@arm.com, netdev@vger.kernel.org,
	matthew.brost@intel.com, her0gyugyu@gmail.com, corbet@lwn.net,
	catalin.marinas@arm.com, bp@alien8.de, dave.hansen@linux.intel.com,
	x86@kernel.org, hpa@zytor.com, luto@kernel.org,
	sumit.semwal@linaro.org, gustavo@padovan.org,
	christian.koenig@amd.com, andi.shyti@kernel.org, arnd@arndb.de,
	lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com,
	rppt@kernel.org, surenb@google.com, mcgrof@kernel.org,
	petr.pavlu@suse.com, da.gomez@kernel.org, samitolvanen@google.com,
	paulmck@kernel.org, frederic@kernel.org, neeraj.upadhyay@kernel.org,
	joelagnelf@nvidia.com, josh@joshtriplett.org, urezki@gmail.com,
	mathieu.desnoyers@efficios.com, jiangshanlai@gmail.com,
	qiang.zhang@linux.dev, juri.lelli@redhat.com,
	vincent.guittot@linaro.org, dietmar.eggemann@arm.com,
	bsegall@google.com, mgorman@suse.de, vschneid@redhat.com,
	chuck.lever@oracle.com, neil@brown.name, okorniev@redhat.com,
	Dai.Ngo@oracle.com, tom@talpey.com, trondmy@kernel.org,
	anna@kernel.org, kees@kernel.org, bigeasy@linutronix.de,
	clrkwllms@kernel.org, mark.rutland@arm.com, ada.coupriediaz@arm.com,
	kristina.martsenko@arm.com, wangkefeng.wang@huawei.com,
	broonie@kernel.org, kevin.brodsky@arm.com, dwmw@amazon.co.uk,
	shakeel.butt@linux.dev, ast@kernel.org, ziy@nvidia.com,
	yuzhao@google.com, baolin.wang@linux.alibaba.com,
	usamaarif642@gmail.com, joel.granados@kernel.org,
	richard.weiyang@gmail.com, geert+renesas@glider.be,
	tim.c.chen@linux.intel.com, linux@treblig.org,
	alexander.shishkin@linux.intel.com, lillian@star-ark.net,
	chenhuacai@kernel.org, francesco@valla.it,
	guoweikang.kernel@gmail.com, link@vivo.com, jpoimboe@kernel.org,
	masahiroy@kernel.org, brauner@kernel.org,
	thomas.weissschuh@linutronix.de, oleg@redhat.com, mjguzik@gmail.com,
	andrii@kernel.org, wangfushuai@baidu.com, linux-doc@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org,
	linaro-mm-sig@lists.linaro.org, linux-i2c@vger.kernel.org,
	linux-arch@vger.kernel.org, linux-modules@vger.kernel.org,
	rcu@vger.kernel.org, linux-nfs@vger.kernel.org,
	linux-rt-devel@lists.linux.dev
Subject: Re: [PATCH v17 44/47] dept: introduce APIs to set page usage and use
 subclasses_evt for the usage
Message-ID: <20251120020909.GA78650@system.software.com>
References: <20251002081247.51255-1-byungchul@sk.com>
 <20251002081247.51255-45-byungchul@sk.com>
 <20251119105312.GA11582@system.software.com>
 <aR3WHf9QZ_dizNun@casper.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aR3WHf9QZ_dizNun@casper.infradead.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Brightmail-Tracker: H4sIAAAAAAAAA02SbUxTZxTH89znvtHY5VodPlr0Qw3OsMgc0eQ4nXG+5SaGZGbEKH7AZlzl
	zvKyoghLyHDyJjLEbs5YkJXiFGhVqGjQlQywVKGCkBGs8qJWdDKYCgM2KVR7NUa//c45//zO
	+XB4rOliFvBy0j7JmKQ36FgVrfpnlnXZlvRF8vKcpsXQc7CRhnsT+QhmTG4OXja4EfzSZcJg
	rztIwZnBAAWDjXkI/O23MJw43ongSU2wrHMPIOieeMaC5YcGBg5VXGCha3iaApsjGjzFVgpO
	DLHgqzQHlZZkcNv+4qD/6HEa7IWPMZTnnqbhz6ulLBTWXGJgwP6SgayS/xjwuG/Q8OC+l4HO
	Yz8y4C1+hMBtCYWx05M05P4bYOC38acY2ks6GOgr+puGaxMjFEz11zPQY/qVhZzCFxzkuyYx
	ZPetBP//wQ3jtmoWSloGuHXLRXuZHYn+KRMSr408w2KblYhXzP2ceLEyQqxwDlHi3eHPRUf1
	YVZ0jJk4sdz/BIt9PU5WfNrRwYlXHqwSy1q3in+csnNfzo9VrYmXDHKaZPxk7S5VwvSUhU5x
	hKVX3DZTWSg7tACF8ERYQYbzc3AB4l/zzexMpU0L4cRTcJVVmBU+Il7vi9eRucJSMlIXVYBU
	PBasWnKurYlRMnMEA5l0necUVgtAAlWVSAlphN8R6c6tZd4MZpPWk4O0wliIIN7AEKVIsaAl
	ZwO80g4JnnDHmocV/lBYTBovX6cUDxF8IcSWX4Xf3DyfNFV66WIkmN/Tmt/Tmt9pLQhXI42c
	lJaolw0rIhMykuT0yK+TEx0o+GhnMqd31qOxzq+akcAj3Sz1dvdCWcPo01IzEpsR4bFurjr8
	izBZo47XZ3wnGZPjjPsNUmoz0vK0bp46avJAvEbYo98n7ZWkFMn4dkrxIQuyUFlk9M9FTqdP
	U1oek9Kb+Xx0z8PajxP8sRfvdfpu7NUOy492f190eEtey5HN3VMnTZtuJtpdCz2rDgzmtIbH
	xjlHtfPa1jRs9NhGo6P6zrLrj9Z/UPst+qZ+w/MY90+qbb0PQ9t3tBhcYZ5t4zMzGfzqXqev
	dPO6blfVkoFa/BldGqOjUxP0n0ZgY6r+FZMm1P9kAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA02Sb0xbZRTGfe/73j80llwrsuvYNOmCkiVDIS4eJzH6aTdLtqgxcUGJa8aN
	3LQU1jIEsyVlpUJQJ5QUspbNWlxFYIy1SGSk2LFRMxjbKtOhDgFTYQQYyaRs0NLaG2Pcl5Pf
	Oc/znJwPh8OaOL2Vk40VksmoM2gZFVEdeNW6a1/VM/KLQ50F8EtNkEB0tZ5A2/luBup9p2i4
	2dOFYDpaj+BBzIXBNpAksGkPsbC6/jsLyUAIQUvYjqG7r4aCv3sTDCxevo/AMRthoHWhhsCK
	9zMEzjkXCwsje2F5epCG5NQ8BbfXlhB4IwkKIsE6BJstevjS42cgNn4DQ6vjJoKvZqcw3O1N
	iX2hPxAEOk4w8FfjdxgmIulwK7rCwFXHpwwsh9souNfLgPtEgIbTLjsCa/t5BlpO+wgMzFxk
	IbwYp+BOi52CLt9+mPbOERhr9FCp+1KuC1vA1WqlUuUuBY5zgxSseztZuNZ+h4DXkg2u8Qka
	/uxwshCfzYOkuwxCXfMsTH3hINCzfIN+3YHEB7aTROz091Oi7adNRuw+043E2IYdiatnrVi0
	Nabay0srWKz1fySeHVtixI3oz4wYWHMTcdQjiE3ju8QB5xQr1g79xr65p1BVUCwZ5ErJ9MJr
	h1Ql8Q03Kfdtq2q/7aQsqDazAXGcwL8kXKs93oDSOMJnC2MNFxmFGf55YXJyHSuWDD5HWOrL
	b0AqDvOeLOHc6CVa8TzJG4S1Kz2swmoehMS3HUgxafhBJNz65AL9r/CEcPVUhCiM+Z3CZGKB
	UpZiPkv4JsEp47TUCb966rDCT/E7hGD/j1QjUjsfSTsfSTv/T7sR7kQZsrGyVCcbduea9SXV
	Rrkq93BZqQ+lftJ7PN70PVqd2DuMeA5pH1cfDG2XNbSu0lxdOowEDmsz1NlvbJM16mJd9ceS
	qewD01GDZB5GWRzRblHve1c6pOE/1FVIekkql0z/qRSXttWCrhx772hBRWHmyz35+R7LTPMr
	6Q99b0dzFv30wPD8Y+k1Ujhel/t+buERlz6WbWwK0qEiOJPjj+lHdrxT2mxJPHvP5ZH3+0bn
	8GDeTODwyeofirZfPxI8WJ9sO0bfL+6zft1sGhop6Ch/eo9Fbb1kux7+fPfD/oTkKyKxt57L
	PKAl5hJd3k5sMuv+AScIleSPAwAA
X-CFilter-Loop: Reflected
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: A3B6240011
X-Stat-Signature: x6513d5jo6i15ue5mt88mz4i1k7ctfqq
X-Rspam-User: 
X-HE-Tag: 1763604557-389574
X-HE-Meta: U2FsdGVkX1+n1wz38YrmIT3TFKEb/XzBk9v4jGOd240GGDGQYuIe4l/L9AkGFK+byIjtJd881V5u2E8DWVxcTzPRZ6u6xUBzwRb31NPSj9ay0W+HhyvkY8lYFIM+9vUkSF5TYkdDwAmnDS+65xLU4f65ApezuN5MLmehigOz6eeL2J+9QBDXg8dhy8VjWe1yNYZdR++IZpGajKUeAXJf3tY398toLBc9rQST3B6gjlW26926yUdkSDsrRmmmLNELksFuWhPP3mhzM1tNH1C2qT4XndD1HAW2XlqPRQnqE/7r431N0H5hKpo5F0y3C6R39cDzbJdPztUXtK3jmllBTK0hGFm1zc8R6e1928qIxDnUYmgukCRrgrpXuKGVeQb4i3QmCHA6g3v3isnt6+eohFW6T+ncVy0gT9IeY1NCWQBo2B1zR5eMb/iLQGLNCGhi7VXrw4VvipxIZ+EQsN3W+AEEXNBfGT4mVqO0IZaWMbVa0XDdIJ3w7zTdubFTSozRx9uoMo5GMEZssttz/ChF5zLH+Kf+p2mTlQEl3wsPPTD9FOuNeVgyOTON5MG5viFHGqH5AzorSXm1p41unBmRPz5u3B1NE2q24kla0mVFezaZMlZ7rmnw+O3KAil10mIMHCK4BR56c8J9M+lGMQgWzI2zdmxOFEn+YBJ1xCuI5u8HgjRETFP48KzrUHujNpmageTUg0hmFAKwt5zrJYHDnKY6UGN5/vMnB5XZ0Anol0U3OSc8LUiIg0ncgY1bCKFjFlRKqNJATXz9Akt5eZprRrt8pUBeYpDZv9GDHyokl9JKoKHNrydD3zn/rc25K90+yxlPz0hym7VM8X2Mm7+HZzDPIrF6D+erdj1Xu+hRbYSrJ2zYGc5V3KQ4AM1pQ2VyPbB3UOEc4OU4kJC5Z8clRoP7UZ9OUer4X7vg3fV6mved4L2boCpLaaNIbBEmGZhG6NjA4fqK8XftW7kYBJs
 mD+JB3Z4
 LMkd3xgmsiBcpuslDvCELj4huFL7tOisx17KmH1XAnhgNswHqYeIYR1koKFPPCuXJWgdSKXU0N1LPHCw=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Nov 19, 2025 at 02:37:17PM +0000, Matthew Wilcox wrote:
> On Wed, Nov 19, 2025 at 07:53:12PM +0900, Byungchul Park wrote:
> > On Thu, Oct 02, 2025 at 05:12:44PM +0900, Byungchul Park wrote:
> > > False positive reports have been observed since dept works with the
> > > assumption that all the pages have the same dept class, but the class
> > > should be split since the problematic call paths are different depending
> > > on what the page is used for.
> > >
> > > At least, ones in block device's address_space and ones in regular
> > > file's address_space have exclusively different usages.
> > >
> > > Thus, define usage candidates like:
> > >
> > >    DEPT_PAGE_REGFILE_CACHE /* page in regular file's address_space */
> > >    DEPT_PAGE_BDEV_CACHE    /* page in block device's address_space */
> > >    DEPT_PAGE_DEFAULT       /* the others */
> >
> > 1. I'd like to annotate a page to DEPT_PAGE_REGFILE_CACHE when the page
> >    starts to be associated with a page cache for fs data.
> >
> > 2. And I'd like to annotate a page to DEPT_PAGE_BDEV_CACHE when the page
> >    starts to be associated with meta data of fs e.g. super block.
> >
> > 3. Lastly, I'd like to reset the annotated value if any, that has been
> >    set in the page, when the page ends the assoication with either page
> >    cache or meta block of fs e.g. freeing the page.
> >
> > Can anyone suggest good places in code for the annotation 1, 2, 3?  It'd
> > be totally appreciated. :-)
> 
> I don't think it makes sense to track lock state in the page (nor
> folio).  Partly bcause there's just so many of them, but also because
> the locking rules don't really apply to individual folios so much as
> they do to the mappings (or anon_vmas) that contain folios.

Thank you for the suggestion!

Since two folios associated to different mappings might appear in the
same callpath that usually be classified to a single class, I need to
think how to reflect the suggestion.

I guess you wanted to tell me a folio can only be associated to a single
mapping at once.  Right?  If so, sure, I should reflect it.

> If you're looking to find deadlock scenarios, I think it makes more
> sense to track all folio locks in a given mapping as the same lock
> type rather than track each folio's lock status.
> 
> For example, let's suppose we did something like this in the
> page fault path:
> 
> Look up and lock a folio (we need folios locked to insert them into
> the page tables to avoid a race with truncate)
> Try to allocate a page table
> Go into reclaim, attempt to reclaim a folio from this mapping
> 
> We ought to detect that as a potential deadlock, regardless of which
> folio in the mapping we attempt to reclaim.  So can we track folio

Did you mean 'regardless' for 'potential' detection, right?

> locking at the mapping/anon_vma level instead?

Piece of cake.  Even though it may increase the number of DEPT classes,
I hope it will be okay.  I just need to know the points in code where
folios start/end being associated to their specific mappings.

	Byungchul

> ---
> 
> My current understanding of folio locking rules:
> 
> If you hold a lock on folio A, you can take a lock on folio B if:
> 
> 1. A->mapping == B->mapping and A->index < B->index
>    (for example writeback; we take locks on all folios to be written
>     back in order)
> 2. !S_ISBLK(A->mapping->host) and S_ISBLK(B->mapping->host)
> 3. S_ISREG(A->mapping->host) and S_ISREG(B->mapping->host) with
>    inode_lock() held on both and A->index < B->index
>    (the remap_range code)


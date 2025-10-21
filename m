Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 556F6CCD184
	for <linux-mm@archiver.kernel.org>; Tue, 21 Oct 2025 12:12:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A71618E0021; Tue, 21 Oct 2025 08:12:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A21E08E0002; Tue, 21 Oct 2025 08:12:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8E9EA8E0021; Tue, 21 Oct 2025 08:12:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 7C9718E0002
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 08:12:04 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 143D158FD9
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 12:12:04 +0000 (UTC)
X-FDA: 84022008168.07.C4A3FBE
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf27.hostedemail.com (Postfix) with ESMTP id 9CE0B4000D
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 12:12:01 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=1At4+x7R;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=5zWlszzI;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=BxLuJ7ps;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=sLWuz3DI;
	dmarc=none;
	spf=pass (imf27.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761048722;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RwFREZndxsLQgEOojxw0ePiYGHl5h5o9l6t4QJAq490=;
	b=Udj+nGkFSa0B0kKRxaZVBnsUR2s+Jxjnjq4cx1/lqHRGKxdQKQ3EsKwlQwDYPTkWrCKooC
	2w7oC4dgSc4xfI2nYjtc2CLkmk+pinWJL5pcsA5KzSSIkPtPwDwe6evn/gPNbDQm0ssWRm
	bA7KRj/5HAcwBTQU3Wyw5LV7wUH68XM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761048722; a=rsa-sha256;
	cv=none;
	b=vrXzI1GylgErHEi+rfiBDyTaavkuKNPXq+Ce/486PDfnVphubRAtR1/tKw4aMDZU1K4+sx
	JntbOmlhbgQrjZ0S1pHwVZ9WRZMvUUeNj1cgDlQcPMVqy4ko4Sy53NWYtCcZ/cNaTbKdef
	2B7lwK87GogJCjSRdoLHbRv1g6VdWNs=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=1At4+x7R;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=5zWlszzI;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=BxLuJ7ps;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=sLWuz3DI;
	dmarc=none;
	spf=pass (imf27.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id DFCB61F449;
	Tue, 21 Oct 2025 12:11:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1761048716; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=RwFREZndxsLQgEOojxw0ePiYGHl5h5o9l6t4QJAq490=;
	b=1At4+x7RUQX3DhyB+qyxSOIRvgZOdQDNb7FGLNTIAPVEHvE16pzIodPz9SZb5n++keS4hC
	ETbw7DLdFE9/ZWUCZufVR68+CMYqESgc7VnA+PfTni1W6+P+y2MFUOR8eGpWy8XmXKbRRg
	sGgLNDoe+JWyCItjD1f5DC9ldUdkq0c=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1761048716;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=RwFREZndxsLQgEOojxw0ePiYGHl5h5o9l6t4QJAq490=;
	b=5zWlszzICLEmgZyDBbbLJfNDAG3GGDOTSvp3RGR9rZ3qNfZ+iwMKswINJWZ73qbk6aamz+
	kG5TvvaQGZGJBVDA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1761048711; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=RwFREZndxsLQgEOojxw0ePiYGHl5h5o9l6t4QJAq490=;
	b=BxLuJ7psEhbrdLUyRYzObCBehqf5I73VS69CwdWanYIV+F4T1CcQv2fTKB+m/0ryGctw8/
	G7rAwn50A+PF6Ci56o+PmZEWVDwANKAU2dJ/XnnmPQb91tQjKvUaLlcReW+dJY/st4uHY4
	QVWgtOqzbwkq0rqZRUwFpFIF2MChLXM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1761048711;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=RwFREZndxsLQgEOojxw0ePiYGHl5h5o9l6t4QJAq490=;
	b=sLWuz3DITIDFEo2otIwSc54F2tb8TtJXbMNwWElucdMWEjlkuTF9VhSRmGK3Wr7g/OaS2J
	bJx2o3ShC4GOYPDA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id D1658139D8;
	Tue, 21 Oct 2025 12:11:51 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id ccUdM4d492iSaAAAD6G6ig
	(envelope-from <jack@suse.cz>); Tue, 21 Oct 2025 12:11:51 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 6211BA0990; Tue, 21 Oct 2025 14:11:47 +0200 (CEST)
Date: Tue, 21 Oct 2025 14:11:47 +0200
From: Jan Kara <jack@suse.cz>
To: Kundan Kumar <kundan.kumar@samsung.com>
Cc: Dave Chinner <david@fromorbit.com>, jaegeuk@kernel.org, 
	chao@kernel.org, viro@zeniv.linux.org.uk, brauner@kernel.org, jack@suse.cz, 
	miklos@szeredi.hu, agruenba@redhat.com, trondmy@kernel.org, anna@kernel.org, 
	akpm@linux-foundation.org, willy@infradead.org, mcgrof@kernel.org, clm@meta.com, 
	amir73il@gmail.com, axboe@kernel.dk, hch@lst.de, ritesh.list@gmail.com, 
	djwong@kernel.org, dave@stgolabs.net, wangyufei@vivo.com, 
	linux-f2fs-devel@lists.sourceforge.net, linux-fsdevel@vger.kernel.org, gfs2@lists.linux.dev, 
	linux-nfs@vger.kernel.org, linux-mm@kvack.org, gost.dev@samsung.com, anuj20.g@samsung.com, 
	vishak.g@samsung.com, joshi.k@samsung.com
Subject: Re: [PATCH v2 00/16] Parallelizing filesystem writeback
Message-ID: <bfpv6jrjo4avzk76ex77dwpzaejglu5gsf2pqpmmgwrmqdkkk3@imsbtnrcelee>
References: <CGME20251014120958epcas5p267c3c9f9dbe6ffc53c25755327de89f9@epcas5p2.samsung.com>
 <20251014120845.2361-1-kundan.kumar@samsung.com>
 <aPa7xozr7YbZX0W4@dread.disaster.area>
 <6fe26b74-beb9-4a6a-93af-86edcbde7b68@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6fe26b74-beb9-4a6a-93af-86edcbde7b68@samsung.com>
X-Rspamd-Server: rspam01
X-Stat-Signature: 4xyne3bpa9td9twizod5igucyw7mbuz7
X-Rspam-User: 
X-Rspamd-Queue-Id: 9CE0B4000D
X-HE-Tag: 1761048721-872615
X-HE-Meta: U2FsdGVkX18nAjjgKWH5UZrGc7IE5U5xwWIJLTwdRqaKKriesd85mApaHT0D7oon4sDIONzUHD5wNTCRS72U5nLy2d+YD/Q6+zV9HozUjSnXb5BCqiXjCx0V+vR50JHHyUx6D2m8ea9303YhdIk2tyXK3MXpG+PneUHqyvuoZg99jzPsuoRjZrq4z1kBn0PBQ48tCG9RtEove70/99XXNgtzgi2U+LRo43HzIIK0iNMYClku0FZRVMTzZ6UKRv1iXulOXU3JfeFe412yE/tyMkwuMuAXg/GlhjoH60l2cthDQkazvsGVzFlLYxIWnrXDJJADd/kUVQuo4WLTxr4SE7jwOBsadgsmZASFZwD0oFWXErY7Ex5b4SxaK/ZZXG/s6xN94OQt8gIuCAMAMIcOWg0HtMtxaXOXpohdg7Wk8An5CicF07ZAXs7B/chUhnRFCK3Uv3glyCBMBgvC6t75ncr11ytq9cvGyFUU6LTMq6OVvP9FOFso5iK7Hw/UbYhtG6oLnEDpI1xIBu62QzXGCrN9GczpXebwVtTI9B5yqTGsDv1Adztg8giYjY8xD/0OB9cegq1L+BAEQq5yEhfIjO/ETz+mY5RV+N4GBxBD5bmQz8Pjzx5aS6rfkcpf3AxMA7czTaYNBzY4H/J26IQepf8saglG4Z7IPBMwJahO5Od3XBgxBCe60+pioGwRgDr3eyiEPFkVioyjTIgnr7if9ds0cRJbD8z+6ls1l8wnOuolahA4pYFSXZigthglnqs26pTi6hmRaTkGUE+gTqI6bjnG1c8Hh9iH6/6gvleq9hkZtmDrnBFGkgdhphHH/t26Zq06AD+rU3spC3bK3l3NaTggHHFoBDWwTNco8ZzEFusmiIDGMW0zOAJ4OhtOMd6gaF4IYa1l2YHqLjT5vHbjkw/OfKrsSVrhEM6ism0wP1p7dX9BteQuQAtfv2upem9ldJ4dGEhwf0ElDklaKjl
 rvhD80zV
 D3XefrY/P/XdWmR+oTPhKDyR2egzT82VMyldSFcuZ0n9FPJPnPYnQXPJUvLJShXjj9s2VW0Bq2+tzdT65Xd1R5RhRz77YVi5QTaVNjAZ3mB9JrJ9SSCqVxSX+z5F04Wd3eEIFlJ5hOry6l/wwylurnDFOFGRQwYBr3d276Hc5dQNbOWQ5egtgYMnPnR3/ijmbi+fmIJ7jRb8mUMFd1werzKMzMyqLf49W3es1wHeEynovt7sAQ/3YEO4tYMy7d+CHyarFhesezzcJBw0PdRi1AoMWynqST1jBOzoyYKASyrIOKWP6mZjKqYIGLj2AzOfMrCeQ4bRY08jbBTy5BzUVsHNG9nVylenNiTjds33DHcdDd9Kgiw2ShSm2l4isSH9IK1sFlq5Mx5GdndBm6mVhfGxJgDvw9Neoq/Pd
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue 21-10-25 16:06:22, Kundan Kumar wrote:
> Previous results of fragmentation were taken with randwrite. I took
> fresh data for sequential IO and here are the results.
> number of extents reduces a lot for seq IO:
>    A) Workload 6 files each 1G in single directory(AG)   - numjobs = 1
>          Base XFS                : 1
>          Parallel Writeback XFS  : 1
> 
>    B) Workload 12 files each of 1G to 12 directories(AGs)- numjobs = 12
>          Base XFS                : 4
>          Parallel Writeback XFS  : 3
> 
>    C) Workload 6 files each of 20G to 6 directories(AGs) - numjobs = 6
>          Base XFS                : 4
>          Parallel Writeback XFS  : 4

Thanks for sharing details! I'm curious: how big differences in throughput
did you see between normal and parallel writeback with sequential writes?

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR


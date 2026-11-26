Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5F22D606A321
	for <linux-mm@archiver.kernel.org>; Thu, 26 Nov 2026 15:22:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=Ks17Enb5
Received: by kanga.kvack.org (Postfix)
	id 1EBC16B05B0; Thu, 26 Nov 2026 10:22:39 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 19BE76B05B1; Thu, 26 Nov 2026 10:22:39 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0B16C6B05B2; Thu, 26 Nov 2026 10:22:39 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id DE9FB6B05B0
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 10:22:38 -0500 (EST)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 7DA1112048A
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 15:22:38 +0000 (UTC)
X-FDA: 85477637196.29.CE9672B
Received: from mta0.migadu.com (out-189.mta0.migadu.com [91.218.175.189])
	by imf21.hostedemail.com (Postfix) with ESMTP id 5E37C1C0006
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 15:22:36 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Ks17Enb5;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf21.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.189 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795706556;
	b=D5i9dN/lqFmJgZoK8FhhdpqHv6PE1FaxEoRM6kicsPODO4vBfGrxAE2ibrtKMqwb+Mh64J
	bA6WYRntZ9p8xJGeEFz0d+EEIdD/XvQZ8jauLu9xGJrXYmmfyTEIhZmlTszMPCJkRAqJeQ
	/xsV0ikM5IALxaGHH0xOJgQAZOELLxs=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795706556;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZvT7tk3P1HeqkH7Q6Z2/RmsaVAZjfaSe3LTozOquko0=;
	b=tvS0IIUlE6ktKV0M4MsTA86mOXHRVWKxUlwLQSUWrCGL8BLqtcKWolG8P0r2KGk+rERDz9
	W9Dhp8LFAxBkYGKc2J5OOijYXM4vhpSLt+xdfX4w9wKYDY0YgnvAPxa0fAuQMigrCRdpJJ
	X/Nq2xYbLzSZQ63tyVRQMHpf8vG/Fsw=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Ks17Enb5;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf21.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.189 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=XxWyPvAJ0IroYsLOy5V5ybJak6wZ0/ht/VqjPuOuhjc=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1795706554; v=1; x=1796311354;
 b=Ks17Enb5Bv5JBp2cuKuvKzhoShVMZG4mRbSJwl7OZUw3wz/j843U/gHujp3PmAtYu5LSdZi0
 s0bhcvYbkh0XYprknwYneLk9cjUKIWo2y2SAW3gL9AnfJe10PfxWWYIdfm9z+nUut/o1Amh33/a
 sqlnI4/DUwy6GFey0+Qrx30M=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id c2ce6ddd70b19568;
	Thu, 26 Nov 2026 15:22:34 +0000
X-Mizu-Trace-ID: c2ce6ddd70b19568
X-Migadu-Flow: FLOW_OUT
Date: Thu, 26 Nov 2026 07:22:26 -0800
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Tejun Heo <tj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Muchun Song <muchun.song@linux.dev>, 
	David Hildenbrand <david@kernel.org>, Qi Zheng <qi.zheng@linux.dev>, Lorenzo Stoakes <ljs@kernel.org>, 
	"Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, 
	Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>, Greg Thelen <gthelen@google.com>, 
	Greg KH <greg@kroah.com>, Ming Lei <tom.leiming@gmail.com>, linux-mm@kvack.org, 
	cgroups@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH RESEND] mm/vmscan: Fix legacy memcg reclaim deadlock
 against filesystem freeze
Message-ID: <20261126152137.GA738059@shakeel.butt@linux.dev>
References: <17d0d1395c0237d201a1abb2473d51f5@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <17d0d1395c0237d201a1abb2473d51f5@kernel.org>
X-Stat-Signature: cz8uakc4jjwhegfoega9k8rn5m8op7ht
X-Rspamd-Queue-Id: 5E37C1C0006
X-Rspam-User:
X-Rspamd-Server: rspam03
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,MSGID_MULTIPLE_AT,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1795706556-943200
X-HE-Meta: U2FsdGVkX19mfUh6VsMvDz8nN7kS/HEJ5pGGiqcgAEomHc/hAZ5wF9C2TbNtw2r82fkdmM/XcZnBswEEfWORjCOj1Gg32YPgOiz8kWzgLIvA1W/uCmzI+HJAfnHmriomWT+RusJtL+GrvLsHYnDXTcdQ1k7CxKFjEXUj7k4czJgHVOlvvpwmOWoWEJJXDKjpXMB5t3SoeAy6S9yeaEnBA+JhZ9VxvW7AsWa6K3euT6Xvw5oZGgFNivxZXMgjt2SsIMINHgzgasAt2w7sqxTQy6OtSCJEUSM8tIzdhKxfBKG+gI8Y5uIT48EQsi0wgxfMfoVR4Nio+2b62Nsv/n4WIxBjjmOUU3OCLS1kdo8ZDCMbJWK3RpJPTmSGOVazHd0bY7xffVFwsKhlXukStsw0GqV5nU8N4PZTJFo2eyC/UVwhmq5/DCkrpv2Pp68mS55IGGH5X+1x3UJ5arrorYLLpeWvPk7uo6GtG1ZB2So17EBcGDRb3fcev/RkaCRQ1yBGi8Ktk5LoAnOhDchHKv8itfS++GctQt5EfulxlOfAuJCA1AaNCOgtBThGHMMH+k1GMDYjPTgDom2c99EgpTPmO2KwGj5U1e70kjYYn2Cl+z6vW18pIxoibRkdYZN7lKpXoBiCvLPY1WcwdrTUurUCRdrm+degPNEkDZ5zfB5nC0ZQBwFnJlQ4nW/QscAYK631SP9i3w+Qd3ad+b+633w0jKdm8TNdqXgTQB1rmlA4xSrgr5wAPyy45uIqHXwBbK21Y0GHc4Shqo52KIgFPvJAuXUfND8EPxd3gWMpE0dcy2Q8vnvZiA8uWRU/IC6zarlKFCkSomD958ZcDXLPpAO26D6lyYc7U5223PPg8npyHUOvkKCCBHhCm7be6Q8ALO8uCprSskYGxdm0mlXmmuL/gS135wZxk0V23A6ihXQlHgmKY1GHmG7oVc2nsuOAFnP1GeOf453ln73q6vXkRAQ
 HyD6sUT+
 72jQn/e/FT6aXwwDtmmZLMKNhNaokvJczV/gtSE1XMwlvwD50xkTwkqMxFhCocet0Y0DccESwB3JDEQzOS9nErZcHz6iaJ6Rtwq7mdTMVHh1B8x2nHDlOjtBMkDScX908yn4AJV/c1WDt4MQ05dmRZ3ZuK7Q8M7U7jrx8ZNRIB5T0Q3RHXxp1HumZqwzhBdfgpleTb4PLFXNCS1l79TCLr2awHMGecatMxNFJfgIxpSGjqbWpelRmEXUdDBPCSVhK3EBeBDOZAMuO0McqC63F76jjqb++GrZgpYGqEDd/WI5LafSRUlZFuRDFsn/vJURHFh+oCN77cVhjsnO+PDPhOBWH4cAc0DwYjNyXWBrQwU/HaemQ3YXoNUObdshIhA92QuhKIFIFdlnjLyrb37Tz2bHHzi7nhnn3edP0TDjsu/HhavIKjyRgl4nP4J2qUOCRvIljhrAhVpATpl/AeaLj2PpeN2Nz4JXeZujRzv5PsZKizgEe06geEya5iFHvESUosZUZR60AkB7DN2lyR3j+WYPktJIo/5B1XZEi/akkaxinCspfPZKyK1PaPEGCJdr7EHiAloekt3kGK1FjxKPJBHM41+QLOODYPIbRXc6dWSHhPKayAPTMOQJJ/4a0C3Rw8unXSQfek1kzE0A=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu, Nov 26, 2026 at 02:08:56AM -1000, Tejun Heo wrote:
> Legacy memcg reclaim has no dirty throttling, and shrink_folio_list() waits
> for a folio that is under writeback and already marked for reclaim (case 3
> in its comment). That wait can deadlock against a filesystem freeze:
> 
> 1. A task in write() to filesystem B holds freeze protection on B, enters
>    memcg reclaim and waits for writeback of a folio of a filesystem on a
>    loop device backed by a file on B.
> 
> 2. A freeze of B waits for the task to drop its freeze protection.
> 
> 3. The loop worker has to take freeze protection on B to write the folio out
>    and blocks behind the freeze.
> 
> The same applies to any driver that writes to a file on a local filesystem
> to serve block I/O and takes freeze protection for it.
> 
> Reclaim can't tell which filesystem a writeback depends on. Count the
> superblocks that are being frozen and make the wait time out after 15
> seconds. If one is being frozen at that point, warn and give up. Until none
> is, treat such folios like case 2 and skip the legacy writeback throttle, so
> that the task a freeze may be waiting for isn't held up.
> 
> This trades the deadlock for premature memcg OOM kills during such a freeze.
> The wait also no longer hits the folio_wait_writeback tracepoint, and the
> hung task detector no longer reports a task stuck in it for another reason
> as the task wakes up every 15 seconds.
> 
> Fixes: e62e384e9da8 ("memcg: prevent OOM with too many dirty pages")
> Reported-by: Christian Brauner <brauner@kernel.org>
> Signed-off-by: Tejun Heo <tj@kernel.org>
> Reviewed-by: Johannes Weiner <hannes@cmpxchg.org>
> Reviewed-by: Christian Brauner (Amutable) <brauner@kernel.org>

Acked-by: Shakeel Butt <shakeel.butt@linux.dev>


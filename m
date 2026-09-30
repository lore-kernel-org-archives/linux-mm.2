Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0765ACA5FC7
	for <linux-mm@archiver.kernel.org>; Wed, 30 Sep 2026 14:25:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F0FFA6B008C; Wed, 30 Sep 2026 10:25:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EC1356B0092; Wed, 30 Sep 2026 10:25:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DD6BB6B0093; Wed, 30 Sep 2026 10:25:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C0D056B008C
	for <linux-mm@kvack.org>; Wed, 30 Sep 2026 10:25:01 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 52381407FB
	for <linux-mm@kvack.org>; Wed, 30 Sep 2026 14:25:01 +0000 (UTC)
X-FDA: 85270650402.30.C5CCFD1
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf07.hostedemail.com (Postfix) with ESMTP id A3D324000A
	for <linux-mm@kvack.org>; Wed, 30 Sep 2026 14:24:59 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=nBCS4+LQ;
	spf=pass (imf07.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790778299;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xdqn8jaes/7yzZn0Sv5IMKv/fi+R1x53WIn7OlrVd5U=;
	b=yD1toGDphOlRec771Oo0UB/QwhtVONkXrQ23jR41ohev9rMLZLeRXwuqIcwZ/lYBfueCo5
	V8xJjswnt6Z/z1nANeWesJV03Fgj0z11hgz4G/GQJ5Tc2Jtnx4Pd+AKPs3ejgiVKUYjry8
	WKpwoMhq8bd+204MyCAa708k0m0xUuw=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790778299;
	b=sBSZCJVCvcbj1mD8idKeQSNpleuCy4qWZ2Kb4twx9oInzrBITrOXi5N/qquOq+lyxhhdBj
	iyxnidmMDuR+sUXIoZwU0iAzHpViUDXvLbgBingNB5QqbaV+CbY01DG0uruOGQ6HpkAtQW
	4tfAWc60HCRQw8giXLQvtxDHYAa/KFI=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=nBCS4+LQ;
	spf=pass (imf07.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id C2FB5601DE;
	Wed, 30 Sep 2026 14:24:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33B161F000FF;
	Wed, 30 Sep 2026 14:24:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790778298;
	bh=xdqn8jaes/7yzZn0Sv5IMKv/fi+R1x53WIn7OlrVd5U=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=nBCS4+LQ5lJx4AWazCSD2t+T9rlszILCCjyntcRhEcJjqRBLH2ZoUGtzzmNc4q8Sn
	 fvJfEwyNbzeJ3IPuupSijSjdZy49eftWRpOMcv9B18omttt9wYhUS17rL8KjzoFAnm
	 HV6F+SOQvzkMplkZ2aDSoK2N14usWBKDNFa1IBIHcD6NESQUYTRvWxN5iLpysEMjaj
	 qOJ8UMUky12YARAEJJiuXon0C6RnVGQ2y+f3DV8gIroBBVy1zci+gtcHCAnDdbgFSF
	 inRfWfO2sfQMhnABHW9esX0JqAMVYCCcUXx1dzJB5agt6cMrKClif8KMVCoq40W3MI
	 qy95INF9BhOSQ==
Date: Wed, 30 Sep 2026 15:24:53 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: =?utf-8?B?5aSp54u8?= <rockeet@gmail.com>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>, linux-mm@kvack.org, 
	linux-fsdevel@vger.kernel.org, "Liam R. Howlett" <liam@infradead.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Jann Horn <jannh@google.com>, 
	Matthew Wilcox <willy@infradead.org>, Jan Kara <jack@suse.cz>
Subject: Re: [RFC] madvise: best-effort deferred writeback for shared file
 mappings
Message-ID: <ar0a9y2E0nDTIC8V@gremlin>
References: <7ebe4591-2306-4b5c-b83e-6a2e34b52bd8@kernel.org>
 <CAAE3jtfeKJLSypScqRAEEgvO8En5kJfpbcFn5X+LQ2YL+xz_vA@mail.gmail.com>
 <85aff663-2131-47da-ac04-8f0799a49b91@kernel.org>
 <CAAE3jtcRQ407P9LTbg=JOwhABQRViSaq2XBefnDdNWiD7PxvUg@mail.gmail.com>
 <1ce9cf3a-15dc-4815-ba29-2e22b05206fb@kernel.org>
 <art8EKRKMdwSDCkr@gremlin>
 <CAAE3jtftxMkCfWJ77W-xvV2x7jdAN8C8kyofYC3fEivM-Cq6UQ@mail.gmail.com>
 <arz0auULA33fqoWu@gremlin>
 <arz8Plu6J4YOTi0a@gremlin>
 <CAAE3jtcanTUrV3xfofwrvYGCFe5o=Vn7gS66bDzuxzeGg6c5=Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAAE3jtcanTUrV3xfofwrvYGCFe5o=Vn7gS66bDzuxzeGg6c5=Q@mail.gmail.com>
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: A3D324000A
X-Stat-Signature: uoseaou34d1wythjc558nebofcfrsk16
X-HE-Tag: 1790778299-933695
X-HE-Meta: U2FsdGVkX1/qbefPHj7aAvdQZna55mt214SD+ckGiIYKIsCOrPQ7vnBqKsj+Gi8RBQq4IjTV2CZCdM7x12hrHSVi2+0nWq/eVT4+hwRgoxx0Q6U9spseHwPOdfh5+hoB0AntgJ+2x/FgWz12xIO13UUJh0Uk/qL9YpiK6zESCoMkRWWGoOJijfEGlUFzIK4StEm5ZZR0lUX9cyQHfKMU9jl6P6hI1uVaHLwVSnFZfQ/98D9WvFYN2sLkZujJ8OzVr2Ft9S2s+VrfHrChtYSMc/e/PeZHs01UfjCueBB2iYxO8Nn/bj2FDwLkUYJ5UO+OTMuR1WZhe50oRid9F9YCILLnIiF/NhipmelzLQM1HDxbuvw43sEoQEgdwMcJmJV2GJRnQuKOHPJr78haM5LtXUf9u1/RucNuuDqdhb/0rlFahln6YzxPUFB61DB7JQYo/6tKLTOUl2fONX+x9tUooSqXpqT586FBRMfKqMQj8vxEihZRNUni9IiSQl3VjyqlkbqQ/4kdShmmjqPjfFLfOqLjk6nhr7tBS19MWFhex8D+YS2rtmwMMhNZVOJ/3q9tHa0i0tLfT+/yx7Aq5gjn7jO0X0Uqo5gjeqJhxuzY1oTg9V2ufwAUZvtowmb3rI9+3wx2jdVEFVccThVuN9kemQCKQTIzEQ4+9N9kcWP6G1hwiZ0IqBYSZxuQxgiSO+3AHjr0DuJ7/VzuY5pz6UYYYpxTCoNRq1QgZSdrsSAdmOZ5F0Vs+I0TCOhgWmy0k5ERzeg0j63icvV5ga/G8GC6AGBaJSQGlYPnXP9WQXWd6knsrVd4Y1xUk4LPX/FTUve3WSb6i0LoPcAZAl4S56yP4SGbJE/C7RVOxdSkcxXi9KlmSOdZH3KFSe60yzTLY9zyCiuQULQIUQ6ih9FqtxQcjAJyy3jmZ3IKIg3DkgAxjaTCrqaJ/cVHmIyFj7os2tcgeeVAnG3H08AlxaDuoXG
 eLoVQs7y
 aX53co7zr8MhUxYhVYV6pC5FD+dxFDIEjzDLyxc6Ms/qwZd6Ti8cnsNH+AVnc3VXI3DYGS9GhCCGsDZyTtcMYM6GrFA1iXEaEPtdlsnYR50CtvLVKsh/OqbbqtVbyuZfqls2CC0RL8yK3Jtui9nNpCZDC/s9h/oBur5Jq/fLuGbueS8AuFg9iRZWiHBKt/kUK/++bNeOaZg5fgvzaZapiFzoiBuq11bu4n58o2R0qs048QRrOJ+cCand0MlIZimPQ8GKzSM2UhJFbnAshcyeP1gxN9Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 30, 2026 at 10:14:27PM +0800, 天狼 wrote:
> Hi David, Lorenzo,
>
> We currently work around this issue by setting the global
> vm.dirty_expire_centisecs to 60000.
>
> We have also developed a kernel module as another option. It exposes an
> ioctl that takes a file descriptor. For an already-dirty inode, it updates
> dirtied_when to the current jiffies and moves the inode to the newest end
> of the writeback dirty list, postponing its selection by periodic
> writeback. It leaves the dirty state intact and does not remove an inode
> from an already-queued flush.
>
> To keep postponing periodic writeback, the application must call this
> ioctl continuously at intervals shorter than vm.dirty_expire_centisecs,
> expressed in centiseconds. Once the calls stop, the normal expiration
> interval applies from the last call.
>
> The key code, with checks and locking omitted, is:
>
>     inode->dirtied_when = jiffies;
>     if (!(inode->i_state & I_SYNC_QUEUED))
>         list_move(&inode->i_io_list, &wb->b_dirty);
>

Yeah that's absolutely violating how writeback is supposed to work.

> However, neither changing a global setting nor maintaining a separate
> kernel module is as elegant as having this supported directly in the
> kernel.

You're neglecting the question David and I have both raised with you here, which
is why you can't simply use shmem (e.g. a memfd) to achieve what you want to do
here?

Writing to a MAP_SHARED mapping is not recommended for a number of reasons, and
most software that does something like what you're doing uses shmem to achieve
it.

Overall I don't think there's a sensible kernel solution to your problem.

I strongly recommend you look at a shmem solution.

--
Cheers, Lorenzo


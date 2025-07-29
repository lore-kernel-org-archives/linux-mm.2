Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4BF1DC87FC9
	for <linux-mm@archiver.kernel.org>; Tue, 29 Jul 2025 20:38:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DE0A46B007B; Tue, 29 Jul 2025 16:38:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D91A56B0089; Tue, 29 Jul 2025 16:38:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CCDDF6B008A; Tue, 29 Jul 2025 16:38:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id BDDA96B007B
	for <linux-mm@kvack.org>; Tue, 29 Jul 2025 16:38:10 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 4D9F0140226
	for <linux-mm@kvack.org>; Tue, 29 Jul 2025 20:38:10 +0000 (UTC)
X-FDA: 83718464340.07.4A90ADA
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
	by imf21.hostedemail.com (Postfix) with ESMTP id 8F6CD1C0007
	for <linux-mm@kvack.org>; Tue, 29 Jul 2025 20:38:08 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=ORSMNwLk;
	dmarc=none;
	spf=pass (imf21.hostedemail.com: domain of akpm@linux-foundation.org designates 139.178.84.217 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753821488;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tjpheeLLhJZM53CkyfOH29N35fGBhCpBnztJaC21VT0=;
	b=jvLros/lE7AnTjDT/IyzLgqjcXbSfpjSlYvzuUf6rgN8BvP7x6tNXdTwwD0r25Ysbc4IR8
	7Z0TEkiR1v7Sk2JztlNsB/Wr1fZqaNYlEHfyPQ82RyekJtz5fqdnjHyXDX2O7ua4HH3QSw
	s+9kCJn8GlWqlDa5i1ToUpLvVVkr1WE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753821488; a=rsa-sha256;
	cv=none;
	b=kkrAvLwTvZMOwJCspAt9TM5SO3AVY8ZO+u6X5WjKGuPC9qMUvB8ijyguid+8QkHRAbYcd6
	+CDYy2B5LWBZWmwgpNxJSxHyC3XkVz6q96wPvr0Z5qy6PClqPVzZS3aerUXX3iFeaq5bYb
	4AWARS4qKRLjYVCY+fFGER0Ld4z0DMA=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=ORSMNwLk;
	dmarc=none;
	spf=pass (imf21.hostedemail.com: domain of akpm@linux-foundation.org designates 139.178.84.217 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by dfw.source.kernel.org (Postfix) with ESMTP id A2AB85C01A6;
	Tue, 29 Jul 2025 20:38:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31A8BC4CEEF;
	Tue, 29 Jul 2025 20:38:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1753821487;
	bh=O3eoxl0WirooKr9OXIBGk7/4wcVz2/rwVAeXhtcOi6A=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=ORSMNwLkK6ZsdPpu/7UKVgVZXzs2lkeQzVpfBbuFsGew3tAd7C0+lgEw48rf5AfmM
	 BPYc4rRCCsF37qhoGq1oacNo1fEI1gbIaVoUmDuzOQaJyi5KMGWJMZs+OCNL6SVwk4
	 Nzp/RpWJoU+grp0NNsRZh7lmj/iZYzohEAwkC7Pc=
Date: Tue, 29 Jul 2025 13:38:06 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Hannes Reinecke <hare@kernel.org>
Cc: David Hildenbrand <david@redhat.com>, Oscar Salvador
 <osalvador@suse.de>, linux-mm@kvack.org
Subject: Re: [PATCHv4 0/3] mm/memory_hotplug: fixup crash during uevent
 handling
Message-Id: <20250729133806.979475704b1162d7aea99b2b@linux-foundation.org>
In-Reply-To: <20250729064637.51662-1-hare@kernel.org>
References: <20250729064637.51662-1-hare@kernel.org>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: spmfj85f3pncy74o8exhqqug5rkjajsm
X-Rspamd-Queue-Id: 8F6CD1C0007
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-HE-Tag: 1753821488-369831
X-HE-Meta: U2FsdGVkX1/Ex+1MTWmNppVqUOdlwXILAVtZg38US3u/kVvryo33+FZbGJBWQgVBDvN6t7TIR0v4Qaw+1TbostBJGaV+7tn+3MoUa080yIlwVYVb4d54C23fjOucrUBl+8vsZSQa9XQ7oA6vBcIVMWkkZG6NLWj5ugocLllBlTOCgFGw1oZsuqRKwgS0BVaUFauwO/5W26Qi6pW/WweXLG6bIqQEZEbUjQrQykNnqT7JH7UfaWnMado1SifLUPYVdA2vgEycN9p92Bxdd3SsMjc2NzGYtXDb9COgaBWi9bsf3K1j4S51kqI6TwqYS+JiV9Jpft2b5EvWv4TqlcFDQM25BfEXrxr1dklBYbSJ8vjTCpC//JWdb9/QCKjGPpI3ES0YGqOywpCJEV0RDCpD/85ZTVByRg+ETrof9q2L62/unykDG5XyBNtLykvGihqv/ZpPHVF1EpvJU25vX6QfkYEbj7x7Lg9gxlFHagoHGKcjFTAKwZrtXkAT+88o8sTR3hWMe8/EkcUw88DmGTX3Pt0ln04sVdtSJjvjlaW7qqSrgRngxi3oZpa38cyn2frCIdusp0zLftmO9wIZslw0T9KFVgcJfKHBFDtWsMOmDO/g9AqjjAbC1/VAe2AwoXLyuIun0y9pmbtbcbu4CX2SfqJxsGzg0t26m5e+9T+Dg5h1uvFnF+cjFiEHty7zmXPTs8ZVt4k3U75d79VNmjo2BYuF6J7jPGPZqRzuWLlGj775Obhg7r38fimbCtt4fRRbFITLjTjrp6cKjdqVy7FVkk9IY560kZCwSFiZmZKkD+1bYE85y5kxPwcDT8o70ue3P7d22G5TROUpozLXidGif5TpQgxPvAmEbD0zaNJ3Vav4MVUvKPZKOS+0HDkE6q4wOQC4gyYovkP3aSTVsvxp1woh6FCCVHIjzhQa75PJI/cEqz9ZQAHLbMXU//tgsM/HvEVXvb1u3O6ZN18CQDb
 JA83D2g5
 XWbCBdZeYOqu9Hi1CoeBRVZ8QkcS4kSGwi4odgfmlQAwGCLuDQnJCI1OmbEOK+wNLWzQhm5MLzPnh9QKp6MKQIUgDrwxTr9ssfXnsykMuNdhWICT08ja0CkGZDjL4VXINqavyVJjQKmHmc/IMfP5EL2EJO0GPnZjLpyYjQinb+FEGmSm3g0k/E8W7xh5ret6HysG3lBcmIE5ZK5YICLvHIz0ycEWQjLg+ruTFDhawH+JzXV+ZKjuj/mpJXqEv8x7nBTWRXutUkRaayYZmPv4xyS7WcQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 29 Jul 2025 08:46:33 +0200 Hannes Reinecke <hare@kernel.org> wrote:

> we have some udev rules trying to read the sysfs attribute 'valid_zones' during
> an memory 'add' event, causing a crash in zone_for_pfn_range(). Debugging found
> that mem->nid was set to NUMA_NO_NODE, which crashed in NODE_DATA(nid).
> Further analysis revealed that we're running into a race with udev event
> processing: add_memory_resource() has this function calls:
> 
> 1) __try_online_node()
> 2) arch_add_memory()
> 3) create_memory_block_devices()
>   -> calls device_register() -> memory 'add' event
> 4) node_set_online()/__register_one_node()
>   -> calls device_register() -> node 'add' event
> 5) register_memory_blocks_under_node()
>   -> sets mem->nid
> 
> Which, to the uninitated, is ... weird ...
> 
> Why do we try to online the node in 1), but only register
> the node in 4) _after_ we have created the memory blocks in 3) ?
> And why do we set the 'nid' value in 5), when the uevent
> (which might need to see the correct 'nid' value) is sent out
> in 3) ?
> There must be a reason, I'm sure ...
> 
> So here's a small patchset to fixup uevent ordering.

You know what I'm going to say :)

Should we backport this into earlier kernels?  Seeing "crash" make me
think yes.

But only one patch has a Fixes: target, and it's with the Fixes: tag
that we tell -stable maintainers which kernel version(s) we want
patched.

So, still assuming "yes": is it possible to redo all this as a simple
minimal patch which is suitable for backporting?  And then a separate
cleanup/refactoring series for future kernels?  [3/3] doesn't seem to
be needed in earlier kernels?

IOW, if we wish to fix this crash in earlier kernels, I really cant use
this series as presented.  For now I'll add it to mm-new to get it a bit
of exposure while we decide what to do.




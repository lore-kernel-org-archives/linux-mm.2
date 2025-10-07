Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 183BDCAC5B8
	for <linux-mm@archiver.kernel.org>; Tue,  7 Oct 2025 02:25:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 413788E0003; Mon,  6 Oct 2025 22:25:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3C2DF8E0002; Mon,  6 Oct 2025 22:25:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2FFE68E0003; Mon,  6 Oct 2025 22:25:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 1EAAD8E0002
	for <linux-mm@kvack.org>; Mon,  6 Oct 2025 22:25:51 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id B631211AA5D
	for <linux-mm@kvack.org>; Tue,  7 Oct 2025 02:25:50 +0000 (UTC)
X-FDA: 83969727660.12.16ED77E
Received: from out-183.mta1.migadu.com (out-183.mta1.migadu.com [95.215.58.183])
	by imf14.hostedemail.com (Postfix) with ESMTP id C97C1100004
	for <linux-mm@kvack.org>; Tue,  7 Oct 2025 02:25:48 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=jwnVEiY+;
	spf=pass (imf14.hostedemail.com: domain of martin.lau@linux.dev designates 95.215.58.183 as permitted sender) smtp.mailfrom=martin.lau@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759803949;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/MKPrETeCuyyOYuVdodsDdiZ6BmGFxYMMYFjYABmB/E=;
	b=qz4yg1AqyxH+OZR7XRnJI2Js05qaT7XP02Q2SZRYlisGK6L56TukwJwfnE9EM9CYzR9gaL
	zWK18XjYaXMJ4tUU4pX5TjYQ6kQqP5ihM4QIXNn9M7HHCBciUacd/hzd7Zy+4O87dtc6cT
	G1MRvqTqCbPcCfT1cP4TgU0Hydudyus=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=jwnVEiY+;
	spf=pass (imf14.hostedemail.com: domain of martin.lau@linux.dev designates 95.215.58.183 as permitted sender) smtp.mailfrom=martin.lau@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759803949; a=rsa-sha256;
	cv=none;
	b=0QpChO+QpjeZTEMkjAL4Ze8t8VKnDsvzZKBjAmadHiLfAcM9vVji6MYmhAe7hu4m2+02A0
	Ne8Bw0Pfw5jK6aDMACbWbu1IArCMEe9hlXgRnXFnzw0rAj+xUillofVKH2wwiGZ21JLSae
	JH+d0cQQGVhP7Na/vXKiTyD9xkZEJ04=
Message-ID: <8726ab79-73f5-46c9-839a-d3abf6f301f4@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1759803946;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=/MKPrETeCuyyOYuVdodsDdiZ6BmGFxYMMYFjYABmB/E=;
	b=jwnVEiY+lQvyrdA2Bf1cDFGtM/Wg/zb3zEORYQVzkoph90jCCxJpGDM7JAltMeK9M7gaXK
	S1C5GtB42Tynfz8K3GBngRpbfbnfBY3IkgfeiXf3hAwnbyxcW2AfoNQqPkmHB14NiVxnbs
	dMex8vxR6PyXIZmZuIr7y5KxzCVBtEU=
Date: Mon, 6 Oct 2025 19:25:40 -0700
MIME-Version: 1.0
Subject: Re: [PATCH v1 01/14] mm: introduce bpf struct ops for OOM handling
To: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Alexei Starovoitov <alexei.starovoitov@gmail.com>,
 Kumar Kartikeya Dwivedi <memxor@gmail.com>, linux-mm <linux-mm@kvack.org>,
 bpf <bpf@vger.kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@suse.com>,
 David Rientjes <rientjes@google.com>,
 Matt Bobrowski <mattbobrowski@google.com>, Song Liu <song@kernel.org>,
 Alexei Starovoitov <ast@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 LKML <linux-kernel@vger.kernel.org>
References: <20250818170136.209169-1-roman.gushchin@linux.dev>
 <20250818170136.209169-2-roman.gushchin@linux.dev>
 <CAP01T76AUkN_v425s5DjCyOg_xxFGQ=P1jGBDv6XkbL5wwetHA@mail.gmail.com>
 <87ms7tldwo.fsf@linux.dev> <1f2711b1-d809-4063-804b-7b2a3c8d933e@linux.dev>
 <87wm6rwd4d.fsf@linux.dev> <ef890e96-5c2a-4023-bcb2-7ffd799155be@linux.dev>
 <CAADnVQ+LGbXXHHTbBB9b-RjAXO4B6=3Z=G0=7ToZVuH61OONWA@mail.gmail.com>
 <87iki0n4lm.fsf@linux.dev> <a76ad1e9-07d5-4ba1-83e4-22fe36a32df0@linux.dev>
 <877bxb77eh.fsf@linux.dev>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Martin KaFai Lau <martin.lau@linux.dev>
Content-Language: en-US
In-Reply-To: <877bxb77eh.fsf@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: swcqdmwqen35w39enzkhunu4kf67chey
X-Rspamd-Queue-Id: C97C1100004
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1759803948-66470
X-HE-Meta: U2FsdGVkX1+Ip4Y0sL999iiD1G7OxSPfq5VYTzd6GhftL5zXtCVngVVK4LoSkKOLGu2w7PJ5hWhzZhJOsXI813FAMIuMkrfz1g0r5iFBoAcrosAq4lffimBPMc4zrWx1WA5W73QT5T6uDcARl1ifxHhJ0ntVZt7GiMUASPMrm6hGsnezg+FAEm49FCTYHq9X0dwAIQn0KWB8vZU5VGWcTl+v3gBteI09ItrsmTaW34583gkTeO3FouIz+X4xkHvHCzXNgwDybARc/cF/TtgAVw/q28OvbppaXF7kr8V2UU52esvY264pnOTWznwMqxsLJePXVyIGeF6N/RcJrzOUb6NKb39OmLnUdivpWZiTutH5cHar6g8HjSCKX9YkC7mf8BA7ZwFkTSkLl9iS4a8F05R1drU3yMw3jrATMFfRGk0pix7dZjr2trhFH+871BLXGDM7ycZ8pHz+y03DMWNzW9Hr62FrnotaLBiFvHc8nwULz9q96edeL1Txn/kutidx79vCsTvaC7i3U3QR9bNqXjTm56yznxzYmD3b6npieSfDVfIAlz9Maz8Aou/YamazETXcr7uQc56pB+YZ4iaRngteejt5zZm1V2HyrNxLDwxdrP53sYUylLaOuQsBq1oRTon0vzH0RjbrFeA26pY3tAY/FTa9A2FX4/CCI3tn7r+Hs6m7bcluuIanabRI9kbIKvfeitVUhHjCtPJR4cYUvfh3SHrIRkJ4hDbW90AvaBEeagGlQpVFw57saE6KAsLF/w64vgPY5p6WPBDdZ9qqqNNqYFtuJ+xsHx5nZ2GyGA9A1WvqM5YJfFbwmB6R6iHdCh8OzUHZ4Et6uMl4h+Juk86uhadoKQN4g6XIv4kXGwKesydNBZFgvJDz3/sM7WhgvqD5HUrX0qDBO3OnB6mgFdsXdhLwhvqZmxiD5Wgmf3hXWeaN5V/TKmNNgtVdc/da9ZGGuF5qMPL2hdj3Wy3
 cQp/WyN3
 Z+TwiTjcJepH+SVf05Z4B6M5MgGCcGwks/sl8LZGTNRcG8lBQTakBtQN2DRNaU3Bmidj6pyac1PXZpBuaPKDqIhvZVoMtA4HYGLkPD6IQvBmJ1a2byCx2jNoaiQO5ByIKFZdyotlzu2peKYKZQQF1bgj2AcEUZNXsHB/5F5NPjw2IYxPfKXWO05XNJWvc/ni43J3/ejGdv9TjTNqccByo1Fc2RqMyJd3nothRDD+Spucbigw5Y+OTRbuWba8qWqNmZq24tFhLbL6i7LpeuWBj0S2MpQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 10/3/25 7:00 PM, Roman Gushchin wrote:
> Martin KaFai Lau <martin.lau@linux.dev> writes:
> 
>> On 9/2/25 10:31 AM, Roman Gushchin wrote:
>>> Btw, what's the right way to attach struct ops to a cgroup, if there is
>>> one? Add a cgroup_id field to the struct and use it in the .reg()
>>
>> Adding a cgroup id/fd field to the struct bpf_oom_ops will be hard to
>> attach the same bpf_oom_ops to multiple cgroups.
>>
>>> callback? Or there is something better?
>>
>> There is a link_create.target_fd in the "union bpf_attr". The
>> cgroup_bpf_link_attach() is using it as cgroup fd. May be it can be
>> used here also. This will limit it to link attach only. Meaning the
>> SEC(".struct_ops.link") is supported but not the older
>> SEC(".struct_ops"). I think this should be fine.
> 
> I thought a bit more about it (sorry for the delay):
> if we want to be able to attach a single struct ops to multiple cgroups
> (and potentially other objects, e.g. sockets), we can't really
> use the existing struct ops's bpf_link.

The existing 'struct bpf_struct_ops_link'? yeah, I think it needs to be extended.

> 
> So I guess we need to add a new .attach() function beside .reg()
> which will take the existing link and struct bpf_attr as arguments and
> return a new bpf_link. And in libbpf we need a corresponding new
> bpf_link__attach_cgroup().

The target_fd (or cgroup_fd) is in attr. I think it is why the bpf_attr is 
needed during link_create (which calls .reg).

Other than link_create, the link_detach and link_update also need to know the 
cgroup but the cgroup_fd will not be in the attr. Only link_fd is available.

The cgroup probably needs to be stored in the link. The struct_ops has its 
'struct bpf_struct_ops_link'. Potentially a future struct_ops can be attached to 
non-cgroup also (e.g. attach to a netns), so maybe adding a 'void *target;' to 
the 'struct bpf_struct_ops_link' and pass the attr to .reg(). Note that the link 
pointer has already passed to .reg(). Then the subsystem (oom handling here) can 
initialize the 'void *target;'.



Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E5130CA0EDC
	for <linux-mm@archiver.kernel.org>; Wed, 20 Aug 2025 22:32:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6FC288E0032; Wed, 20 Aug 2025 18:32:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6D1D48E0031; Wed, 20 Aug 2025 18:32:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 60EC78E0032; Wed, 20 Aug 2025 18:32:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 4F2CE8E0031
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 18:32:24 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 95B801373A9
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 22:32:23 +0000 (UTC)
X-FDA: 83798585766.04.7552211
Received: from out-174.mta0.migadu.com (out-174.mta0.migadu.com [91.218.175.174])
	by imf06.hostedemail.com (Postfix) with ESMTP id D62CE180010
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 22:32:21 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=nhOltoJ4;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf06.hostedemail.com: domain of roman.gushchin@linux.dev designates 91.218.175.174 as permitted sender) smtp.mailfrom=roman.gushchin@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755729142;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=N0IRlJS68kXvQ/sl+UPNiKXqYY0HXBsBdYbmkimwi+8=;
	b=x9jJJncALerF2bfNhXVDhriJjYxjzpmYSEsRlYKZgx3QvDObFNB30Q7Hmo4phkIO40FGJp
	gZC6smL3HB0xwf6bqcvXJs/aVGb1D8mecpuLtP39+yJ54ZiL00txhgfBHWvv0MYjMqSKBe
	vbuZWzqJCIowREbcc9n/D4yUbWmnlj8=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=nhOltoJ4;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf06.hostedemail.com: domain of roman.gushchin@linux.dev designates 91.218.175.174 as permitted sender) smtp.mailfrom=roman.gushchin@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755729142; a=rsa-sha256;
	cv=none;
	b=Dv1snS/MXrHFl6dfWRl/HUaNJOYVD33kIl7YO99r5K+vOA+jmuUyr/bDuVzaw8XYuaEaAi
	adzbFV0Mog4bsastmzXId09/G/woPFR19qdgsr3XrlllSDJxcTcton8R/zBXqGsVF3WKKx
	yMQa2hPVLo8uCGqTy9sxCp3NlYhJdB4=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1755729138;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=N0IRlJS68kXvQ/sl+UPNiKXqYY0HXBsBdYbmkimwi+8=;
	b=nhOltoJ4OlfQcMaKWmmRjWVkN1LWfrmBEr3jVnKVeFjEL0v3Nf6H2CEUH8t+zgW9CNNX8c
	Gfkq2j6teAdetfJOQQDNE+3LTxJW+W/kyQkUzm6W4VEeS2knQRIkriUxcMmwkGYIEG14wO
	UUM2k+bTZdvN4tGUhY5/NeR/tQ4nAG4=
From: Roman Gushchin <roman.gushchin@linux.dev>
To: Kumar Kartikeya Dwivedi <memxor@gmail.com>
Cc: linux-mm@kvack.org,  bpf@vger.kernel.org,  Suren Baghdasaryan
 <surenb@google.com>,  Johannes Weiner <hannes@cmpxchg.org>,  Michal Hocko
 <mhocko@suse.com>,  David Rientjes <rientjes@google.com>,  Matt Bobrowski
 <mattbobrowski@google.com>,  Song Liu <song@kernel.org>,  Alexei
 Starovoitov <ast@kernel.org>,  Andrew Morton <akpm@linux-foundation.org>,
  linux-kernel@vger.kernel.org
Subject: Re: [PATCH v1 02/14] bpf: mark struct oom_control's memcg field as
 TRUSTED_OR_NULL
In-Reply-To: <CAP01T767o1-KyhRLGcm8gXU5GiY8_OtifT6bNVfMuf+MT+3ZBw@mail.gmail.com>
	(Kumar Kartikeya Dwivedi's message of "Wed, 20 Aug 2025 11:17:38
	+0200")
References: <20250818170136.209169-1-roman.gushchin@linux.dev>
	<20250818170136.209169-3-roman.gushchin@linux.dev>
	<CAP01T767o1-KyhRLGcm8gXU5GiY8_OtifT6bNVfMuf+MT+3ZBw@mail.gmail.com>
Date: Wed, 20 Aug 2025 15:32:11 -0700
Message-ID: <87cy8ppqtw.fsf@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: D62CE180010
X-Stat-Signature: rausyyowwqumjwrjhi4qknt1q9gim87s
X-Rspam-User: 
X-HE-Tag: 1755729141-530176
X-HE-Meta: U2FsdGVkX1+dPDkjeHXIPS4tKBZfGmZAVJ1l7VpLn7fvYYBbfh6CPdZFAL0uJhk89zJnIIQwV969RyaC315ONj/6dH7aDn1MTvZbOQd8RqdVRNqNY4S5eM2+qbiYbCh3Z0vNGsXeuuI9tYPGeEqeWqujtUo02cjVm+28o85kaoRG5QrvUgwJ8DlkjkmQeW5E9kHHIcNtaWUhfEOC5pWgmrW4WpkS3/Gy3GGm+dHsXLwE8BEzN9gQMLmAqQ5qPL7KF6//NkXyVExwGbQang5TD5L00rNES9OiyxNh1HXS1xKj0hx1VYJowgdPmoRHTxreY5TOfnGufBwYeBlPRE+I3UR8WVWikToI+WBqZR8XNF8GU8aS50blZ3gTL/AbvwQ2QS8supITyYZCTc0optFkorn9NbYI7d8sP5wnRjYARmUIjFKwSGaDhtDbdLU2WIBJgDo2nd6h4N8Ep6dz/2cjsmxcdw1ujalFTByM/wwCEmxWfgV0yZ7nuwyZhW1ztDsBjcVq7P9FLg6QhFqM9S6uEE4rmW4Vj7k7I/GynIk8HnPFmf34zdvLvYyHJMbGZNnHWPR89XPZwwoi8Zrbea4uuWJxxkMzNFjGUUTIwhD/EoqE5m7RoIwhOXiX5J6zWy/12hoX8efoZnZFa0Gp+GYQxOWp1GiWxGpEh/DnYpvpsWFr1bjal1UxsUAW6obbBOnSRC+mV6H5f0Y2yhGw9lFvHDNMKVI8ZcnRkUwr/Ek2REIPTC7FuuCVRB/lSGnVCOp3OtAMK8KFZxYg3NW3GGrv7STxvMOsANVAM9B0y6dd7V+a0iT/9RM4ihWZXYq5niHtCPg294dq9YFy6AtRA1Gg0wB1O/kEcIkZC+0N8+hHdvPStKqcNRLv4cryTl4xjtVI4qq/yeYvF8Su/8ecYWp8nHxjN1hd23Nstg+O72YHNq+gvS87LzKZ4UQUfsXDTzHAYDh31ulDkXBNEH/G3oL
 2wCvau6Q
 5Y7bZy7vpPi9R1jY1QP8aD/uEJDHo/LSaWIAkGwmFvyTRxG2Dk3xccM0NEbowvg2MYTI8+e1gczyeMrUOfSlynj3vK8rn4WLBTYAJWmcreS2eoFMI1CbLc2eGFp3Q6QgeQsmFDokskq0qzkJsfnc+xMbwWS3viVgdu4IbwWDvqlJWpGYAn7MavZJTA+Wv5bwAcy+rq80O5fu1j/S1YZwZOFDSQ4rH2/WsntBzCjDcsnHXIi2OvehneZyA6W8zLeL9ICUlecZB60JSeeE=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Kumar Kartikeya Dwivedi <memxor@gmail.com> writes:

> On Mon, 18 Aug 2025 at 19:01, Roman Gushchin <roman.gushchin@linux.dev> wrote:
>>
>> Struct oom_control is used to describe the OOM context.
>> It's memcg field defines the scope of OOM: it's NULL for global
>> OOMs and a valid memcg pointer for memcg-scoped OOMs.
>> Teach bpf verifier to recognize it as trusted or NULL pointer.
>> It will provide the bpf OOM handler a trusted memcg pointer,
>> which for example is required for iterating the memcg's subtree.
>>
>> Signed-off-by: Roman Gushchin <roman.gushchin@linux.dev>
>> ---
>
> Acked-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>

Thanks!


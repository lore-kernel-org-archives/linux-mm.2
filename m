Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0A093CCF9EE
	for <linux-mm@archiver.kernel.org>; Wed, 29 Oct 2025 20:27:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B17898E00F5; Wed, 29 Oct 2025 16:26:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AEEE38E00B2; Wed, 29 Oct 2025 16:26:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A2CCC8E00F5; Wed, 29 Oct 2025 16:26:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 94CC98E00B2
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 16:26:08 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 4CED7BC21B
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 20:26:08 +0000 (UTC)
X-FDA: 84052283616.27.3B47FB7
Received: from out-185.mta0.migadu.com (out-185.mta0.migadu.com [91.218.175.185])
	by imf15.hostedemail.com (Postfix) with ESMTP id B8F00A0007
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 20:26:04 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=gbNivlUO;
	spf=pass (imf15.hostedemail.com: domain of roman.gushchin@linux.dev designates 91.218.175.185 as permitted sender) smtp.mailfrom=roman.gushchin@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761769566;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8LQMYVbeSSNK8HEpygcBXhLqfLwBAFQnmbjr1eMUwF0=;
	b=f46AzMfhyuVjNBv2y3vizDVz7xR3fx2/VtIMnIceiAbHzX7RAciXOy92oQLSEQ7N0WmiFZ
	LW6Dq9HwysSK45YWd7BSwh7muEAFDFawb9KoOYSnmlSrWH3SQ8qlg6tl1mNbeNikzqZeaD
	O38yZFtHZlgk8ncA/z2TlGw/yOmqUf0=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=gbNivlUO;
	spf=pass (imf15.hostedemail.com: domain of roman.gushchin@linux.dev designates 91.218.175.185 as permitted sender) smtp.mailfrom=roman.gushchin@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761769566; a=rsa-sha256;
	cv=none;
	b=l6fYjr60BdJb3RgVqyGKa5oRNPCd9374fGN7hO0CtQCVFMPwQQTgil1fXmiAq7m0AW1h7z
	wSmzc2L7S+cpQjImtTpJUS/1/5s2b+CzVzc47UXiMNg8w1oTus85f/AulZNR+Ymh/yvGsx
	YOfr15OUPHhjE9r5Ktta4ocyiHQOdug=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1761769562;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=8LQMYVbeSSNK8HEpygcBXhLqfLwBAFQnmbjr1eMUwF0=;
	b=gbNivlUO+akpnki/DzJK4tKIph6Rnah2FtAYOZAFV/5Wv7eVnDwIZPm8p3A2ydfKREWBhG
	3FthTNlzbIfe+q5R50wA4HQ5Vk39t3AnmZyZ82mAHwVMj6FtGgEUrXCsjHi9Le98UFePqh
	M5/4hadwC/JHzm9H8+Xd3qivsGT3owI=
From: Roman Gushchin <roman.gushchin@linux.dev>
To: Tejun Heo <tj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
  linux-kernel@vger.kernel.org,  Alexei Starovoitov <ast@kernel.org>,
  Suren Baghdasaryan <surenb@google.com>,  Michal Hocko
 <mhocko@kernel.org>,  Shakeel Butt <shakeel.butt@linux.dev>,  Johannes
 Weiner <hannes@cmpxchg.org>,  Andrii Nakryiko <andrii@kernel.org>,  JP
 Kobryn <inwardvessel@gmail.com>,  linux-mm@kvack.org,
  cgroups@vger.kernel.org,  bpf@vger.kernel.org,  Martin KaFai Lau
 <martin.lau@kernel.org>,  Song Liu <song@kernel.org>,  Kumar Kartikeya
 Dwivedi <memxor@gmail.com>
Subject: Re: [PATCH v2 02/23] bpf: initial support for attaching struct ops
 to cgroups
In-Reply-To: <aQJZgd8-xXpK-Af8@slm.duckdns.org> (Tejun Heo's message of "Wed,
	29 Oct 2025 08:14:25 -1000")
References: <20251027231727.472628-1-roman.gushchin@linux.dev>
	<20251027231727.472628-3-roman.gushchin@linux.dev>
	<aQJZgd8-xXpK-Af8@slm.duckdns.org>
Date: Wed, 29 Oct 2025 13:25:52 -0700
Message-ID: <87ldkte9pr.fsf@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: B8F00A0007
X-Stat-Signature: i7opd9adxtebrk8jcpqkhkah5wgqssub
X-Rspam-User: 
X-HE-Tag: 1761769564-770518
X-HE-Meta: U2FsdGVkX1+x4SGumu9/HM1AGx9b/Ey2IhUZXQxx3Lsz6QYZvXZXMuU82FtQnkUCLx6xCepjFurNS0xkG4VFkjbcMSL1dfXcPYWf7nr73tzNHuM1GQT8NPrZZTFWXdlvQbboEaKuRebbZGe7g5EeeHqIQJ8C9LdxsZqy7Vv623KAIl9KNxhwAhKlET3DuJJdRYMEFpbUpljM9XV7mCi0pXWDBTbcKYlQL3gF95GzED6Qlwwm+G7CoNzZSEM629+72Qtt8GAtpiGZ2e6VBcpM192TX8aRbwKBtIrE/ONJCpWBiIJnPydMbasoHeOt6qGM5nWBiR8Dm2+KoHwca0Jz8fGwHK2eVkkYpcvfzk4TIc2iH8axEJsbyxCwcoGE69xALoisapABVe6wf0Ioq8dICokTYAxnvmbch/fQ0n1DAw9xyoF7kM0I5P6sLc+QhrLK5JgC01qzNB4UeZ1S9JkIIscI69fTwTU6pwbfKxGz89gvoaVSi5miMo98PVojd1zdVpmdmaZCzlYeW/J3WUnKPEeLQT+6ePSv4vD75tuk1sW9w79WHBe3fvXQ2CFaQGHCbVjWJHW8KrwlbZPA5xml4lJULsjXMf2aIIF89ud3sHhAzSPOUnRoayQCpBvu61Y2Yx4FliTxz7Kxvs9FxwToHdDq0tsnLz2MuoSCaKGSAEMvBjTzZfRSIpjcLsIWhB8c2nq8yBHwDXjzKSjdPcJaZY4NcHf8blhr/RNa5ySFsoDskZgTyk7abtV3N0eXJ3x+Qg7zMpszE1mpNMtfbMf5WUr3AAt4MiP98sJIu0jGu/0YOTBxU8Si3JVpDJsoas4TsKn8TC/+MPzjfL2Z0wQSsubZDVGyDh8JTe87/L7nJIwdS8P8whO7dg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Tejun Heo <tj@kernel.org> writes:

> Hello,
>
> On Mon, Oct 27, 2025 at 04:17:05PM -0700, Roman Gushchin wrote:
>> @@ -1849,6 +1849,7 @@ struct bpf_struct_ops_link {
>>  	struct bpf_link link;
>>  	struct bpf_map __rcu *map;
>>  	wait_queue_head_t wait_hup;
>> +	u64 cgroup_id;
>>  };
>
> BTW, for sched_ext sub-sched support, I'm just adding cgroup_id to
> struct_ops, which seems to work fine. It'd be nice to align on the same
> approach. What are the benefits of doing this through fd?

Then you can attach a single struct ops to multiple cgroups (or Idk
sockets or processes or some other objects in the future).
And IMO it's just a more generic solution.

Thanks!


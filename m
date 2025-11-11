Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 16992CCFA1A
	for <linux-mm@archiver.kernel.org>; Tue, 11 Nov 2025 19:13:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 71F398E0008; Tue, 11 Nov 2025 14:13:19 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6F6568E001A; Tue, 11 Nov 2025 14:13:19 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 636628E0008; Tue, 11 Nov 2025 14:13:19 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 4F0348E0008
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 14:13:19 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id B38611601B1
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 19:13:18 +0000 (UTC)
X-FDA: 84099274476.03.9A93924
Received: from out-181.mta0.migadu.com (out-181.mta0.migadu.com [91.218.175.181])
	by imf13.hostedemail.com (Postfix) with ESMTP id E889920005
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 19:13:16 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="BK+z0/Gw";
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf13.hostedemail.com: domain of roman.gushchin@linux.dev designates 91.218.175.181 as permitted sender) smtp.mailfrom=roman.gushchin@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762888397;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WAMF5Kieve7eLi0CA1Q7SiwB8XtOEdddDh5a5e2G5pM=;
	b=I8fHLRxekiZPvEVCAazLlohq2inLRLzhZGGxPUAaYuvX73+8yAEv+AwKq6v+GLUwREYpX3
	8gCd0g/zfJbuF5Kq8cyoNm0cAoowfwSAhuQ/76ADh4TJaQia1gU0Fgfuf01WIe6IXQviz9
	xKwZhdQi/Tq9POQBsxdh/w0/bsSdlrk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762888397; a=rsa-sha256;
	cv=none;
	b=0n7Ybrw+Ca9lAgTAKbtWkOtWap3HByoOtye4mCQSL4Agj4zEeQQuHS57eb++4ESLPoUnhW
	1YvN32wXnjKl2PLLXjaBDfmloQYgWJcD3ihXNUYEjHEbA5oDQ8HNAtoWEKhDe6Neo2D+vI
	zF/yZL4BZ+fIPmaK3RPQj56usuWqAqw=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="BK+z0/Gw";
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf13.hostedemail.com: domain of roman.gushchin@linux.dev designates 91.218.175.181 as permitted sender) smtp.mailfrom=roman.gushchin@linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1762888391;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=WAMF5Kieve7eLi0CA1Q7SiwB8XtOEdddDh5a5e2G5pM=;
	b=BK+z0/GwfZFWc92LGrJKHMQiWjt8FetZh6gz9F7Q3nigg37iUGQkMuedZ0rPT2Gs1ppbzb
	W95ukc8Q++q9Y/TmKv2Gbi490gsoalmrdY0sSLJhEoUJRa777q+YEA8iwwAVuqcwuBu3b/
	81SxkJdLw2+ynMuB7sJquE7X9LFbQzs=
From: Roman Gushchin <roman.gushchin@linux.dev>
To: Michal Hocko <mhocko@suse.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
  linux-kernel@vger.kernel.org,  Alexei Starovoitov <ast@kernel.org>,
  Suren Baghdasaryan <surenb@google.com>,  Shakeel Butt
 <shakeel.butt@linux.dev>,  Johannes Weiner <hannes@cmpxchg.org>,  Andrii
 Nakryiko <andrii@kernel.org>,  JP Kobryn <inwardvessel@gmail.com>,
  linux-mm@kvack.org,  cgroups@vger.kernel.org,  bpf@vger.kernel.org,
  Martin KaFai Lau <martin.lau@kernel.org>,  Song Liu <song@kernel.org>,
  Kumar Kartikeya Dwivedi <memxor@gmail.com>,  Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH v2 13/23] mm: introduce bpf_out_of_memory() BPF kfunc
In-Reply-To: <aRG0ZyL93jWm4TAa@tiehlicka> (Michal Hocko's message of "Mon, 10
	Nov 2025 10:46:15 +0100")
References: <20251027232206.473085-1-roman.gushchin@linux.dev>
	<20251027232206.473085-3-roman.gushchin@linux.dev>
	<aRG0ZyL93jWm4TAa@tiehlicka>
Date: Tue, 11 Nov 2025 11:13:04 -0800
Message-ID: <87qzu4pem7.fsf@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: nxdwh663hzfhgs3sypfj4jhabxt4q8th
X-Rspam-User: 
X-Rspamd-Queue-Id: E889920005
X-Rspamd-Server: rspam10
X-HE-Tag: 1762888396-680805
X-HE-Meta: U2FsdGVkX18QDCv5Ka+2mpguFyQ2LOOnT5+X3LsC6VMznciPeZSEh90V5ALbreR2D5lvuMv0Kn/Ws39tQ1Wprp69yYk2lpUw+WEfvtTyMBGVU4lQeiZ2He1F47U7/BKcDx2DPV4rmqvXMlgBGu0aJ5pjM3e8eR06wUhUgrkINVgK80sxnjJVvYU+yn1meQgIrDaNPlyyH7yX4TrqLH62eKQeufpfUUbrZIkjWxcKjnsS28zD6D426OiHq3zNSeGYdSjmhS4GYNrifFvqqSQZqjmt3i1JmkSnZGldelNs7n7XoxC0EneD6tukmIDIrvyT7Cjyw4ux8DJWEllScWy1wd9Jyhc/MIh32SMbiV++8xX/1JOAOcnIh3+Wc9hF08K1cE1mnMuV5OVv6EJZ8Z/7WaWjZsQpRshfJZLZGypPW3ZrU8qfVlQZHF7PYNFYFgI7XdwC6BApLEPVK5m2GYHR/LR+0vOYK0xCRjMpV3OqCsTJJi36F0TnGLH7uJoGH2lD1oAesgBX1Nxz8jk9f+mcW1d6Xeq0gOtRIY5lJtcb0iGz5pqAKgA/5l4CAJQfq7G7r1zy23LNir+89k3i8q31AxBu6Utilb50Sj7McPkT1YP4spbFq6PzkGD6BQ6zxZQWYD88wpNoYnboCHaOKdcxc2XDxQ3/DVaUM9aQ/wU2f5eKHGa5gujCk9Cqzfo9kmSwvDLmGlLmPpnzkkf6viqdooWZBMES/Mk71p3yJXAzoHZs3VYJLgr2LJJ+NOOTKEvOGJvlo6vUqzi+0x+nin2w67+k1dUMcYqnAYq1I9ryZFCJp8URBAz65+goNI9GZFZNZAkcJYlFnXETOg8L9e6q1Y/c6hcD/5x/QisDIgR3ypXIv08I+4HAxjEC4Y/3PPrXAHrYg5KD14n5cgLVnc7EqxfVsImerJNzrYzJAMLt3/pU2ZVwJQo5qC+XT/FvrMsj7jC73J19YO2Jh0ii+Jf
 gNoJQ00Q
 UfBY4IUmTwPZRk2Q8eyVc6ffvGtT2Qxb4fJ90iDdCxFBiRf3jYGTUaFu2zAU8uj2+qKTD1iMGuZZESyPB8w7OcfY4Z0krOAp+09yIJHqdF5iBpvOuhdve9s1m219ml/PIhFtunDXH9wH9y3rJqyL+tqIKzAjfU2ttpev7TlMZwFfAIjaW7d7l88iZAIBc54NI8gwexMIJOUW09sNlY0UyHxqGpHrpHHYVKZukRa2FLJKHfyF7Hw2kJpep5wKlHmqU0HlC2KDMBqbdQpc=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Michal Hocko <mhocko@suse.com> writes:

> On Mon 27-10-25 16:21:56, Roman Gushchin wrote:
>> Introduce bpf_out_of_memory() bpf kfunc, which allows to declare
>> an out of memory events and trigger the corresponding kernel OOM
>> handling mechanism.
>> 
>> It takes a trusted memcg pointer (or NULL for system-wide OOMs)
>> as an argument, as well as the page order.
>> 
>> If the BPF_OOM_FLAGS_WAIT_ON_OOM_LOCK flag is not set, only one OOM
>> can be declared and handled in the system at once, so if the function
>> is called in parallel to another OOM handling, it bails out with -EBUSY.
>> This mode is suited for global OOM's: any concurrent OOMs will likely
>> do the job and release some memory. In a blocking mode (which is
>> suited for memcg OOMs) the execution will wait on the oom_lock mutex.
>
> Rather than relying on BPF_OOM_FLAGS_WAIT_ON_OOM_LOCK would it make
> sense to take the oom_lock based on the oc->memcg so that this is
> completely transparent to specific oom bpf handlers?

Idk, I don't have a super-strong opinion here, but giving the user the
flexibility seems to be more future-proof. E.g. if we split oom lock
so that we can have competing OOMs in different parts of the memcg tree,
will we change the behavior?


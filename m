Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CE6CDFEA801
	for <linux-mm@archiver.kernel.org>; Wed, 25 Mar 2026 03:48:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 04BB56B0005; Tue, 24 Mar 2026 23:48:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F3F176B0089; Tue, 24 Mar 2026 23:48:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E54B56B008A; Tue, 24 Mar 2026 23:48:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id D467C6B0005
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 23:48:01 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 7B22559CC4
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 03:48:01 +0000 (UTC)
X-FDA: 84583201962.14.E9A9D87
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf28.hostedemail.com (Postfix) with ESMTP id 4E02FC0008
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 03:47:59 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=AZuZz6C1;
	spf=pass (imf28.hostedemail.com: domain of longman@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=longman@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774410479;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fTWuW19SzsgMBofMGpQhLndrrAHyvaqK2jt4CAJhThs=;
	b=qLyi+2k1m8ziLoeZQ3R4erPa5m0SeZ/pzPBaq9zt+XTOVCTFq7e/gcLVubGx5CnTdUiSH2
	zYqPZs45VNDxcvkz8S23y9jrD7MPP1l/h7oR/Gb+gJMQD47ZO5GfGtEB6SeWv1JyyUosDH
	An/TaRBOzTOcQqe+52IVoBD/+eDRE0U=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774410479; a=rsa-sha256;
	cv=none;
	b=rLfBRj2nQibak4krvBJb3KEONVqgkmiQK5x93pL7fzuUpCMi7jaMXlTflJD6gerb80emYY
	HcPX9sllCbx/JMJvVjtZSI5SYL0ccqCZ1IyvGI98ciNhrR6d9B714kT3SK2VElxCc0KW81
	lwwLGsCt08R5YNpIlFvosSB4bNvdvZk=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=AZuZz6C1;
	spf=pass (imf28.hostedemail.com: domain of longman@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=longman@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1774410478;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=fTWuW19SzsgMBofMGpQhLndrrAHyvaqK2jt4CAJhThs=;
	b=AZuZz6C1Rv1YwxyIqhimjzOBXqk4kFuCk638KQM+yUJJvbLICiexsnWclPzFd/256VMnrF
	w5bJHIq2CmtutDQxT0G1u8DbW4M+xp8tErr/cO4rdbi4k3kKdMt8DZpiG/fB2Shr4JeiSh
	AcWWkdI2/oqRrKftiHocPOgvOjwQP8o=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-194-9zpRRRgTOyyAahvbGz0crA-1; Tue,
 24 Mar 2026 23:47:56 -0400
X-MC-Unique: 9zpRRRgTOyyAahvbGz0crA-1
X-Mimecast-MFC-AGG-ID: 9zpRRRgTOyyAahvbGz0crA_1774410474
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 328D0195609E;
	Wed, 25 Mar 2026 03:47:53 +0000 (UTC)
Received: from [10.22.65.192] (unknown [10.22.65.192])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id E51103000223;
	Wed, 25 Mar 2026 03:47:48 +0000 (UTC)
Message-ID: <ac21dea1-4fbd-4003-9723-1c02fdb5d03a@redhat.com>
Date: Tue, 24 Mar 2026 23:47:47 -0400
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 5/7] selftests: memcg: Reduce the expected swap.peak
 with larger page size
To: Li Wang <liwang@redhat.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>, Muchun Song <muchun.song@linux.dev>,
 Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>,
 =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>,
 Shuah Khan <shuah@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, linux-mm@kvack.org,
 linux-kselftest@vger.kernel.org, Sean Christopherson <seanjc@google.com>,
 James Houghton <jthoughton@google.com>,
 Sebastian Chlad <sebastianchlad@gmail.com>,
 Guopeng Zhang <zhangguopeng@kylinos.cn>, Li Wang <liwan@redhat.com>
References: <20260320204241.1613861-1-longman@redhat.com>
 <20260320204241.1613861-6-longman@redhat.com> <acD4vGZKveXJ4GuW@redhat.com>
From: Waiman Long <longman@redhat.com>
In-Reply-To: <acD4vGZKveXJ4GuW@redhat.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4
X-Mimecast-MFC-PROC-ID: ihwpxp5kIEu30l-eVcJTV-WBJhT5nY8GMggCI0O6D-4_1774410474
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 4E02FC0008
X-Stat-Signature: cozp6xc5sz94ugte4iccf3boo4s67z3d
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1774410479-952375
X-HE-Meta: U2FsdGVkX1/l5ZEJ/QxeEvMOIhmAMXsAKlo9Hghy9rSy5VP0QrM1Lj8Rjjn+nuY7spo9f/1kZ9rVFhQWdlgALIcLOhFukqklhy8s7tyv3MF8+4yHk3eWVax0PipxwyZXaA+TEtCwPD8Urf6O74zpHzMGtVHzyFSNZMCp3Dl7LD11zvpKyTE2fEUoPtiYzX1xcpT+SEft8Cej/7Dk+ArBb8WAJix1mLbbnBMAxR+9VwgpT40n31/oRXZAirzOxzgQDd7Z+ww759kkjSTYOoiroDxv49+nL+CW5QR7xo4rOcYipqPsS03PH+Mqzv82dEq0FVV4whM60kAje9qZTYvNxjjAm1arJQPT3T9YKFj6gX/Y14yHZS4Zyksp/Ptez68ooDaeMw9O9fS+mkoqUlULy9u6gq7OfUwQtMiUtaVqw9wtMbtlwlnwZ/2A/YMMRTrhHQnaaajCP8HFViAWpkAHQ82y021pNCvaHfBP95Kq2yPIeEsMbH6eRe7C0oeYQPURP/5f4APRy/WMym3ieCD2pZybPMvwNtC9MkalOh2vM9hBNJDXaCn0BkOHBBtGe8tZsNFg/wxc8noghpxa7y74obBIVZyEVn0rfVm/Sim2i5DUen+OieZYWijtOFK9C3C/G392GKAXYaSvDORPvcwzN4K1nx61JVvMwJncRpbkysnkIPZXScxvp+2CHODv2TvpH4scMjcuhCiWGqBtZhtUot3UbYLSmKyaEKg1SwdO9Y+BJMiYi84DPF5jZOssvzfloQchMoiiZBjVWCb4SZatttk/1S83AIcI3L66XY4miLcZVAG99vXX0okqYsVNGq7JpiRkKUrwaBLvXhBWi6D58B247AGxvcRROyXYL1+niO6lTmW9ctqmBIo/kSjMDaTCzHOhJDseWeRS61IiYB+VIMtRMHKpIg/hZoXKOBTM5SZ+D0uYVuK38Iy+JZbJLTGwgSdn3PlVUIDQpPozc8V
 mg/ZD1/M
 CvfEcY3D/0uiXGAeluzVNDVdWUi4/1YC+0/myVzFOJ52Lp67U3F0+7t9WG5yIFCW8FV23ByjY75PouQqAs60FQXtt8RuXl8/c/Ljwzslyi2RLn6cO6gWwfTibCtO0Vu4g4ud/+AWfUjaJa17Qe3zY7v+XdON/umpipBGA+vD6lJia54ojfqIsRtvHIP3EEM1ONa+q61Ay8vmiOSPCQ+o313y/eeF+/0c6rQ7Vy9k2aoPEyaNTQybWQYOwZz7fFg+dUmxLfK9Okcnq+ehcwprS25raWztZ3UqmUGEUN09gaGxlxe3UxcgWDdU116t6bcQAWu6kWZUqTSV0uqkJPouaMPf7rejs1oTNz2m1
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 3/23/26 4:24 AM, Li Wang wrote:
> On Fri, Mar 20, 2026 at 04:42:39PM -0400, Waiman Long wrote:
>> When running the test_memcg_swap_max_peak test which sets swap.max
>> to 30M on an arm64 system with 64k page size, the test failed as the
>> swap.peak could only reach up only to 27,328,512 bytes (about 25.45
>> MB which is lower than the expected 29M) before the allocating task
>> got oom-killed.
>>
>> It is likely due to the fact that it takes longer to write out a larger
>> page to swap and hence a lower swap.peak is being reached. Setting
>> memory.high to 29M to throttle memory allocation when nearing memory.max
>> helps, but it still could only reach up to 29,032,448 bytes (about
>> 27.04M). As a result, we have to reduce the expected swap.peak with
>> larger page size. Now swap.peak is expected to reach only 27M with 64k
>> page, 29M with 4k page and 28M with 16k page.
>>
>> Signed-off-by: Waiman Long <longman@redhat.com>
>> ---
>>   .../selftests/cgroup/test_memcontrol.c        | 26 ++++++++++++++++---
>>   1 file changed, 22 insertions(+), 4 deletions(-)
>>
>> diff --git a/tools/testing/selftests/cgroup/test_memcontrol.c b/tools/testing/selftests/cgroup/test_memcontrol.c
>> index c078fc458def..3832ded1e47b 100644
>> --- a/tools/testing/selftests/cgroup/test_memcontrol.c
>> +++ b/tools/testing/selftests/cgroup/test_memcontrol.c
>> @@ -1032,6 +1032,7 @@ static int test_memcg_swap_max_peak(const char *root)
>>   	char *memcg;
>>   	long max, peak;
>>   	struct stat ss;
>> +	long swap_peak;
>>   	int swap_peak_fd = -1, mem_peak_fd = -1;
>>   
>>   	/* any non-empty string resets */
>> @@ -1119,6 +1120,23 @@ static int test_memcg_swap_max_peak(const char *root)
>>   	if (cg_write(memcg, "memory.max", "30M"))
>>   		goto cleanup;
>>   
>> +	/*
>> +	 * The swap.peak that can be reached will depend on the system page
>> +	 * size. With larger page size (e.g. 64k), it takes more time to write
>> +	 * the anonymous memory page to swap and so the peak reached will be
>> +	 * lower before the memory allocation process get oom-killed. One way
>> +	 * to allow the swap.peak to go higher is to throttle memory allocation
>> +	 * by setting memory.high to, say, 29M to give more time to swap out the
>> +	 * memory before oom-kill. This is still not enough for it to reach
>> +	 * 29M reachable with 4k page. So we still need to reduce the expected
>> +	 * swap.peak accordingly.
>> +	 */
>> +	swap_peak = (page_size == KB(4)) ? MB(29) :
>> +		   ((page_size <= KB(16)) ? MB(28) : MB(27));
> Or, go with a dynamic adjustment based on page size?
>
>      swap_peak = MB(29) - ilog2(page_size / KB(4)) * MB(1);
>
It is a good suggestion. I will adopt a dynamic base adjustment as 
suggested.

Cheers,
Longman



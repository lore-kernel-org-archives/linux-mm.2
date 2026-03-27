Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 49B8210ED64F
	for <linux-mm@archiver.kernel.org>; Fri, 27 Mar 2026 10:04:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9061E6B0096; Fri, 27 Mar 2026 06:04:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8DDD06B0098; Fri, 27 Mar 2026 06:04:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 81A806B0099; Fri, 27 Mar 2026 06:04:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 6FF2E6B0096
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 06:04:54 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 1288214107E
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 10:04:54 +0000 (UTC)
X-FDA: 84591409308.13.245B893
Received: from out30-98.freemail.mail.aliyun.com (out30-98.freemail.mail.aliyun.com [115.124.30.98])
	by imf07.hostedemail.com (Postfix) with ESMTP id 46D8940009
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 10:04:49 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=N2myqbd3;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf07.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.98 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774605891;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3pcclGAw2n0ERSdgcxRd/f1n8hL4Vj2lV1ZnDYVVzEg=;
	b=ZYJ+HqsyUVnsVSVZsnytvTuUR2axefBY+HfZrgTMtu3Klq+ZP1F9bI5chn9TOqErLjs0qw
	GzXfASUPInw4h6ciGJZhRPutmThHvEfZcp6PBgnm8ZwedmtRiroeawPLwB9bgiGrncrvLY
	jJiclW/uaXlkTnQGQkfrswQXis8ob2M=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774605891; a=rsa-sha256;
	cv=none;
	b=8QqSJyNEFaxi47gLESggUWVb8jvxf075JuEZF8xCctbVu9v9/VcwNUzN9lOnpIfNgi1LRY
	Co6I9s5rz9VfUCv0WM1GkTc1mn+R17C5h738ivizvi6zI2+RNEG1h8P7FOjjaC1HaxHrAR
	mlNARAOo7+C0Hn11o7g2N/PP0jlG4ac=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=N2myqbd3;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf07.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.98 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1774605887; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=3pcclGAw2n0ERSdgcxRd/f1n8hL4Vj2lV1ZnDYVVzEg=;
	b=N2myqbd3ZbGn93c4GULI/7XKZuo6BZoiyoyTH65mLlz//yXFNcYbMFXX8j7fds/DR0+/xsfSJlVF1lSUoNqj72r2ov3RrVPF3HFc4wwtS7G2Xw3lFLz83AV51pjSf8+jmVnambmVHWr0RckgVI8OkATCy0NORpTqD4QlnM9nQAo=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R131e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037033178;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=13;SR=0;TI=SMTPD_---0X.nyg9A_1774605885;
Received: from 30.74.146.57(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0X.nyg9A_1774605885 cluster:ay36)
          by smtp.aliyun-inc.com;
          Fri, 27 Mar 2026 18:04:46 +0800
Message-ID: <1ff07ca1-8a64-43dd-85e3-9aa963c24b55@linux.alibaba.com>
Date: Fri, 27 Mar 2026 18:04:45 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH] mm: vmscan: fix dirty folios throttling on cgroup v1
 for MGLRU
To: Kairui Song <ryncsn@gmail.com>
Cc: akpm@linux-foundation.org, hannes@cmpxchg.org, david@kernel.org,
 mhocko@kernel.org, zhengqi.arch@bytedance.com, shakeel.butt@linux.dev,
 axelrasmussen@google.com, yuanchu@google.com, weixugc@google.com,
 baohua@kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <bf40a20cd93b6c21f10db95657928fdae185e843.1774438978.git.baolin.wang@linux.alibaba.com>
 <CAMgjq7BmZYEp_3bHVCWD696Tx3qAoN8mafKE6M2Z-fTf1hTWAg@mail.gmail.com>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <CAMgjq7BmZYEp_3bHVCWD696Tx3qAoN8mafKE6M2Z-fTf1hTWAg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 46D8940009
X-Stat-Signature: eprjjodud4cytax6azbxpaadwmqgoy4q
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1774605889-321277
X-HE-Meta: U2FsdGVkX18pk+leARzA20qyFQii5L1qofMYPdMRTpDEH8N4//2uuyuHkT0tkb6T2HzSKl/oIPBf8EG5iZVNUZnVLbPetPKROp0UD13FOA0I2TtBtKk7Z+4HilhKyXuIEGb6fjvuxDZHbrwhWW0v0hczXbjXWTCPGooqCAHqkzaWH6Ji23ZyoCHG6nbBPX7p9Wi+TWAeVWVuqlSITJy1kgrzKqG7LOIP0uXrho1JSg2elZeDNAQJcoSLXs0B8nuEjLIAYJ3cr1XwI0ApU4nCE9SLeEhpTWWh1ppVv+2CsptG8+z1UacyoXuzUR2yMS3eKd0CUte/1SjdvT9s5DfMF3I9OmDvPeO1cL21T1KktapE/lFsnbx9YO4JOPYOJgoqlPOiOrjrccswf0E1QpGM2gGFWbw8i5MKRYpeDV14nSik1/5K1yOeffS6TGKm/D8oq3+wXWbFgs05XDaniO2A95ftbNY3QFfiizxCi+9Xmu2E+OnJx1Xootqd6kzXkgTMvZCppJNjr9rRbrZCOKNK0vQTIGvx/7Ot2sGuHXh04cE78fnytLMGTECdPUMj8YiU0EV0O5B4TP/ki7ayXaLxQDBGHcF1WDD1gY0zn4E6OM/swTedREuMEL18RGwIn1lAIaeqlR93DG8YpjP5nwi4wioyMiCyiDeqixzMjlyeo/zICaH3d/Cb0ktQucbgdyZi1kpxYJeoWunFGx7xUgHlufPzLQLO0eqU29AL2wq4UL8fY8qX5AjfvInMTkdYyt04ICQyyjOaqesZk0Po/26aAr3bOBllgQgXaWoQ10durloc654Et1gYq1n0+72e9An1nqsLkzsI3qApPU+lwCpJjGQ446uRmsApUz3Fn6C4m/O8uB4Y/XmetJhINrJXj60vINtaLJMoMrDyiQ3/D9COcksF3oBA66Kf
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 3/27/26 5:45 PM, Kairui Song wrote:
> On Wed, Mar 25, 2026 at 8:06 PM Baolin Wang
> <baolin.wang@linux.alibaba.com> wrote:
>>
>> The balance_dirty_pages() won't do the dirty folios throttling on cgroupv1.
>> See commit 9badce000e2c ("cgroup, writeback: don't enable cgroup writeback
>> on traditional hierarchies").
>>
>> Moreover, after commit 6b0dfabb3555 ("fs: Remove aops->writepage"), we no
>> longer attempt to write back filesystem folios through reclaim.
>>
>> On large memory systems, the flusher may not be able to write back quickly
>> enough. Consequently, MGLRU will encounter many folios that are already
>> under writeback. Since we cannot reclaim these dirty folios, the system
>> may run out of memory and trigger the OOM killer.
>>
>> Hence, for cgroup v1, let's throttle reclaim after waking up the flusher,
>> which is similar to commit 81a70c21d917 ("mm/cgroup/reclaim: fix dirty
>> pages throttling on cgroup v1"), to avoid unnecessary OOM.
>>
>> The following test program can easily reproduce the OOM issue. With this patch
>> applied, the test passes successfully.
>>
>> $mkdir /sys/fs/cgroup/memory/test
>> $echo 256M > /sys/fs/cgroup/memory/test/memory.limit_in_bytes
>> $echo $$ > /sys/fs/cgroup/memory/test/cgroup.procs
>> $dd if=/dev/zero of=/mnt/data.bin bs=1M count=800
>>
>> Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
> 
> I've been testing and based a few patches based on this and it looks
> good enough as a bug fix:
> 
> Reviewed-by: Kairui Song <kasong@tencent.com>

Thanks.



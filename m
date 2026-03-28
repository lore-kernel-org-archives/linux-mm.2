Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9E4E610F3DC8
	for <linux-mm@archiver.kernel.org>; Sat, 28 Mar 2026 02:38:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DEFBB6B008C; Fri, 27 Mar 2026 22:38:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D9FC26B0095; Fri, 27 Mar 2026 22:38:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CB5C66B0096; Fri, 27 Mar 2026 22:38:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id B569C6B008C
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 22:38:44 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 54BC38EC3F
	for <linux-mm@kvack.org>; Sat, 28 Mar 2026 02:38:44 +0000 (UTC)
X-FDA: 84593913768.07.5420E92
Received: from out30-110.freemail.mail.aliyun.com (out30-110.freemail.mail.aliyun.com [115.124.30.110])
	by imf21.hostedemail.com (Postfix) with ESMTP id E57A51C0007
	for <linux-mm@kvack.org>; Sat, 28 Mar 2026 02:38:41 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=atP+Kgc5;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf21.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.110 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774665522;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8DOt/S8u7uVbI1sNGa1m5LuFvnKwYtZQpZgs6y83o4A=;
	b=uM5TY/iQ2f+rdLu0rta4uASOEXKcNaJBJxhTshwN8quoAZVwFmcWLTjuh/5E3DdbYjC13Y
	Oi0fVa69Homu9WlVtfqCRuifvw3Gtf6qRAQZ7MI/k9gNi0HlVoMdDEbC2hY79orya2caFp
	S1EOZedSWC7hpCVTd1iSjziYwdkvZfQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774665522; a=rsa-sha256;
	cv=none;
	b=2qK+u+aPVVfOTITPF9BYfCxPRGh0PbwFXTpiUojSoHs7Y/MbjoYkWvq9SX+FFX4ANdf9TS
	/kYNBZesBsa616KqeUT4QglQCZhWBlHF/g3bOz4NIgxZHShqNhePfNDjiGwNMULxsFKBZI
	K1JE8QtvCXgJHc9+C78LTI/0LwgBBq4=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=atP+Kgc5;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf21.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.110 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1774665519; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=8DOt/S8u7uVbI1sNGa1m5LuFvnKwYtZQpZgs6y83o4A=;
	b=atP+Kgc5bV+C/GyIKTm8eaFWAqbOHhVx3wCJNqI9/WIb2rbFWJsLnYrZ9v8YoDoqokAB6l4jlV28n723ePr6oCFDsnMP7w1+V9ep3PqEneQGTu/iJ9NE93C19vf2ZnEufLSmnBtLfG6SiAw+MwSAVsX3UPmn03OMh77A9AlWCHo=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R861e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033032089153;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=14;SR=0;TI=SMTPD_---0X.pba0A_1774665517;
Received: from 30.42.98.36(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0X.pba0A_1774665517 cluster:ay36)
          by smtp.aliyun-inc.com;
          Sat, 28 Mar 2026 10:38:38 +0800
Message-ID: <b1935ff9-6949-4d4f-af51-1c2738c032c0@linux.alibaba.com>
Date: Sat, 28 Mar 2026 10:38:34 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm: vmscan: fix dirty folios throttling on cgroup v1 for
 MGLRU
To: Andrew Morton <akpm@linux-foundation.org>
Cc: hannes@cmpxchg.org, david@kernel.org, mhocko@kernel.org,
 zhengqi.arch@bytedance.com, shakeel.butt@linux.dev,
 axelrasmussen@google.com, yuanchu@google.com, weixugc@google.com,
 ljs@kernel.org, baohua@kernel.org, kasong@tencent.com, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
References: <3445af0f09e8ca945492e052e82594f8c4f2e2f6.1774606060.git.baolin.wang@linux.alibaba.com>
 <20260327083042.da4fd1586ab8aa2f639393b0@linux-foundation.org>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <20260327083042.da4fd1586ab8aa2f639393b0@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: E57A51C0007
X-Stat-Signature: 5ioy9rp54k1ut7ty6ygx34ijnbr4b1or
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1774665521-50732
X-HE-Meta: U2FsdGVkX1/RZpZEoF9JNozmC5nTutRRO0Qd9pEr4xZ4DlBZkotEW6fGCjyCxm1fODDN3vZI1wDx0mkWflYhgUmxkM0gz+lj7epsUJrpeN3yNhW3N1mM9F9qkJdIfYP0Nh4JsaxtjOO7+sUVmAjhZM3olUeTVczXMQgO3XQCs/kVT8U6hxcFnpJlMn+PVREyXEyaTcMZTz+bgLghf9/v9jJjCM9WOQY9Hf17aVcn0g4AH9g+YMFFnLedSJSh0PBzcWzOhnw72fwQ6nMILDTQSobRBEGQzSvyYqkO4idaCpwttg4jLVK9AzZkB9NZ1kwvj/RM493V+A4MSfHNZazV1eVQ27bS0KGS4G7QjTc0jvjCRgXoOom258ePF070lu3mysRrVJ0TGPUxlW53efVNpa0oZtlznTMgbiNL0zF3BMAT+3dk0SqPSd0XsfX5SQ+6tMlKwuQEBSLp24BsZHZCRv10aK1+C4yvr7uiFUTr+iSvcEubsxq5EeqCokaveJcmNoa8OK1Hq1GF4al0LKnQ4K6IP2T4VJSoO/DPqhD+zjr39QGru0MJhy5ZYyYOy5Su4QDBpPTiFjIWUVYA+xmU2PGvg9iVzktOzn/esTaDKiBKD1Es7O63zBEZ7muHTcugVwKQx5dIdTsiD6+4J/GPa/lNNyoB9AXGCuJ7EauXsXghVEw1l8yqbMeq+idg5j/H+91aveq6V+F/6VUMreqMg3XhkKfP4WQUGxt+MYMvS6TaxY6SX+19NdHbdLO5OqoQK6W5QUR5cIwpcI3b2awPYPuabxHVtFNhebv1ozPecUIaufQb2OucQpNP0E439C3B+75+UfhayMQy09oipMvehlDZ4gYBumbkmkVvcOG8JRezxMB8zC4OPxYiC6hidW8NRRsRF4tPoJRNLs7UCRHr7yKBA/FdVtq98cWSJ0NS0NE2JEUwsEYwETKVELPQpo8yniPdNmmRBEdYHyFaOwC
 UngXi4Za
 D8hwTLBHDOxdmme+d9r9wk2IFhciFauRD/XBotujwio0Jw85xEu/6BWmUFQSVtJWbZIxC9yuiuHEog5FViURkspirSwPNa9myt6LaHK/UEmhuTi/yAYjVEIiz+4cIGIBnVldjhgow1apuBnXF3W6NYTTLEnJ8RuJl/FfI6rsK4UX8w5GsuMc1Ibg0DsiTHwqE3bA5gQljf2gaL0Qyz3PjV5bL6DmLDNICHixAOnB9VSz1M3r4u0su6vdjkoYgqlCKA+quNxsrm5u5aMH8uYE8HtXoKQcpm9G8WLJbLJlsGbG/hlg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 3/27/26 11:30 PM, Andrew Morton wrote:
> On Fri, 27 Mar 2026 18:21:08 +0800 Baolin Wang <baolin.wang@linux.alibaba.com> wrote:
> 
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
>> Fixes: ac35a4902374 ("mm: multi-gen LRU: minimal implementation")
> 
> 3+ years ago, I don't see a need to rush this into 7.0.

Agree.

> But should we cc:stable?

I don't think it's necessary. The issue isn't that serious:)


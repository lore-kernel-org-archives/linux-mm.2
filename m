Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5A80AF506C3
	for <linux-mm@archiver.kernel.org>; Mon, 16 Mar 2026 12:44:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2B9D06B00C6; Mon, 16 Mar 2026 08:44:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 271FA6B0255; Mon, 16 Mar 2026 08:44:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6D7B76B00CA; Mon, 16 Mar 2026 08:44:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 5AC136B00C6
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 08:44:45 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id E10791C16D
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 12:44:44 +0000 (UTC)
X-FDA: 84551895288.08.3230AB2
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf18.hostedemail.com (Postfix) with ESMTP id 0929C1C000B
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 12:44:42 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=WMjVI9iW;
	spf=pass (imf18.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773665083;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GvQvuimntf0WkeYLwmFbZgNZkHNW+yJn8+eNNrtfOg4=;
	b=cKVNKNEPcq6/UP3EV+Smy7DU5jMnxLNyISLyj3b8fMdFGuSXARAHipv4O+bwp6otPoIfB8
	JgfZ8p8vzw9kFvhLd/K0vBvLgaUacQwyiiuZbmr0J8vHRnj3a82ADv+4TFPUlT4wGnlHg1
	eYQ1Sj8W0brw6EK5nIolj21mQPQ+pCY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773665083; a=rsa-sha256;
	cv=none;
	b=H9Dv/WbckT8dFoubOtEhkWK2ES+bT9BpfnBVpOYUMA7IWfryNwfafyYNyH2ZUVzjyEb5JB
	8bTGA+n+Lsc6wcVsl+Sjkx+9C4+dWcPZmPGt8ZGVPQobaclU9QHFikGz4APk6Frc4MRQWY
	x3oaYX+jlKtdaVHo/amyNX6y+bqNkig=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=WMjVI9iW;
	spf=pass (imf18.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 090CB43DE9;
	Mon, 16 Mar 2026 12:44:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CBCD6C19421;
	Mon, 16 Mar 2026 12:44:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773665081;
	bh=B6eErf0Rv8/pOP4wFmEW6JF0kE6gyF/QIuBdqW8vGtQ=;
	h=Date:From:Subject:To:Cc:References:In-Reply-To:From;
	b=WMjVI9iWkodLGabPriQPIp3DlznF5/DEc9dSKbJM6eEPare7zajZflkO1uG2lePs0
	 aflrxJllg4kPZ5nNqLlkqP8hWO4W5ThAinZAww478FjUTEIpBi1Ib+eMZFEPV1p9Bq
	 63p+2qrAZien6ta+ylnKSPyRklWsFXJUDifDcV3eT1OFfG9G1/DN97+6bwUCZTGOKd
	 +14s/5fh/jo8qh/yHPZXsp5RJgNia7Ku9Kkrf87d7rw5cFJDsiIV4nyTJLMSCEsfYd
	 yYyZ4fB1ojIfWyTkIeeAIiLj9fWOd2G0ELy4Ucd3MnS3UsDjE+SMPDNoot2+UAX7iG
	 bwwId3d/VUuTQ==
Message-ID: <12d8c91d-d839-4f3d-aca8-0c63e66354d7@kernel.org>
Date: Mon, 16 Mar 2026 13:44:36 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: vbabka@kernel.org
Subject: Re: [syzbot] [mm?] KMSAN: uninit-value in copy_from_kernel_nofault
Content-Language: en-US
To: Christian Brauner <brauner@kernel.org>,
 syzbot <syzbot+c18de0ad13d62f18469d@syzkaller.appspotmail.com>,
 Alexander Potapenko <glider@google.com>, Marco Elver <elver@google.com>,
 Dmitry Vyukov <dvyukov@google.com>
Cc: Liam.Howlett@oracle.com, akpm@linux-foundation.org, david@kernel.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, ljs@kernel.org,
 mhocko@suse.com, rppt@kernel.org, surenb@google.com,
 syzkaller-bugs@googlegroups.com, kasan-dev <kasan-dev@googlegroups.com>
References: <69b7d9f6.050a0220.248e02.0112.GAE@google.com>
 <20260316-fachtagung-gelitten-17389c00b6c2@brauner>
In-Reply-To: <20260316-fachtagung-gelitten-17389c00b6c2@brauner>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Stat-Signature: 745qti83mq3quzd61fkw641h4atqqsy6
X-Rspamd-Queue-Id: 0929C1C000B
X-Rspamd-Server: rspam03
X-HE-Tag: 1773665082-681247
X-HE-Meta: U2FsdGVkX1928p7EsLevgNNNu/32aNTwpZvGo2r947A41GzUd9ni04ebOJJag8ai+hfYXTZR8f47QpuH1G38XIsfcrspF2upzksYb57ah0JemepE9jXMXXer6lICNXpB5HzPMDOV/5khI1RH1T7e/pY1l21+3u0h6YYwzH7EC6IzoAvKTBJ6HYPp/0PB872w1cEJTO+Ye1cz+j9T/BjkzCkCQEMHqdBV1Tt/HhrLScW2nEHGR56/IHIOmkra6CsrO0b7rHDQsFfrIus0NALI+vSq9zMEwMfikmBfX6tKkYAS+Lk7VQA/QqJ0GGpeiqTS92NkdF8UAEN+YoEeCjmolwEqC9+w5qDapGuxpv+z13fd5n/f2A6fkzaYl3csWoqeXrkx027rCOHzWorsrKaH6gNoQLRj+QgG1/JV7cC77VJzDYHUFQ+owKs84syGgz6YVy/HQnBZrgCOEhvm5rvVZq7k02KWcq1PJQYMmb3PeOq26S42ipFQ34UMkCMoyUzcmyI1kXkCwO87GpQaKp4ZIrWNwgBEcqFUjfeWHJnnXEYlDYsJgP+khDehP/0A6xUIQfCyZh5NwBX6nWcbVa8pf7KFrsAelRhmx70vysZ853OFx7pSQOhULFUEpvwMu4efuLSYe6MwfLAHKZGDROFU4KTjBqtwQ7uaHZ/xrVxTdJvS7GPEK0akWE2AzkHzXYBATnF6KcF/7Z/ITp7n1rArHgQQaGUl+m/mUygMay2y97/W8gd2BgPTXsZD7Pq1DdMY22Dqfv69WNFLW9DV+DRvmIvzrS1FCRAk2bnrHeM+iLY3fN0IpPeiV6oI+3sdbvGrGKHOE1+4IeB5BxrZR8964gzyWA7Gv6lmYhW3FOcIwKnsJ+h01jfFoa05BiJiSs6hdgWFElfGWALVcFu7SuKRiXINGvWSPOMuDlKCUGddKSNkthvZUd9ah1AXgD9Lms1yYkaDj5yeCEo/87IRir5
 5/F/EXYx
 gtWlzAsK/oFK54ua0v+hITIyfehWjPE0KuXZz8r7jppLdt3BQuFdk53xxkTwT0j8x6GUv3luJSJGiGQe9qveS8068+PjInzCMy8tNdmUGmXIzMghN+imiXW2y5xBjzmLMRYX1fuLuu3cVpHC4VHyoExfF26WelltODX8bN1IsP6cqzUwSM7oSX8/3EIAjgyb0CEkFjTPkdCcQ8CSYMAv/Pgv7Y4pdPzgapkV2Nh5kZw/J/tEaC93WF6dOyRPPcQV3x9qXnVyaWk1nScHU5fVdQYjm/sGPUpxUE3J08bmHk7xGJ558FTng+uHHkQOdx7f85pDfHlVbqeWRUPTaN/OFXzUXoq4+rG5nAqHGNbFjBFwlNqdvirNFfHyWTquXFbedQbhUAL4z5/A07BI/aXR8IRzeyj0dvR9D+NXfvo4Q7C4yvoQJH8Ziv4oY9UaFX3IzUOZ3gMCUGRmLvc2/pNF0evEK4QpzxwOPhong5gHrWkH+mxpRtTmSWTuD5gVIKab1KVi9Vs7mlOgKR+ZuOWlwb1SM3MhLntNEYOTQZT05cC/TE7WlBvpDyjYPrm+29CVmXHryZt01mC2QAzs+7ESdg998Qs+tF7cj9dnoNpr+9aZY6w7kplWFgVkoL6XHJBxycHPVMY1UnmzeytzPaKk1TOJ3f38FQdfIFkHZVu08aNOjxFLqlb4fYXLr1SC51elOd02Fwskbc0x6rCGntlbxS/Jzq9bNTM9gBZ1o2avw8+yRya+Tyi0i8OyFJML7duzOgY9WEldB7MTNMJOITgwMX69ZxyyMTHOaHCB2Dsc/ZhmeH6nNkcdcAMlSThquW6SQfXud0pbrx3XZRi0HS+j7FkjCB4B0+yKpONiaFvq3tLyUTACQ7fhXdzM6i6fyqJW02SVDS2qS8wo2Rf12PnjyUEJsO+M44ZpgLPS+UqaO07xB+LlfiahPgeFe3nyVhRFEMA88
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 3/16/26 12:58, Christian Brauner wrote:
> On Mon, Mar 16, 2026 at 03:22:46AM -0700, syzbot wrote:
>> Hello,
>> 
>> syzbot found the following issue on:
>> 
>> HEAD commit:    80234b5ab240 Merge tag 'rproc-v7.0-fixes' of git://git.ker..
>> git tree:       upstream
>> console output: https://syzkaller.appspot.com/x/log.txt?x=1474cd52580000
>> kernel config:  https://syzkaller.appspot.com/x/.config?x=242f02fcd3fbc8f3
>> dashboard link: https://syzkaller.appspot.com/bug?extid=c18de0ad13d62f18469d
>> compiler:       Debian clang version 21.1.8 (++20251221033036+2078da43e25a-1~exp1~20251221153213.50), Debian LLD 21.1.8
>> userspace arch: i386
>> 
>> Unfortunately, I don't have any reproducer for this issue yet.
>> 
>> Downloadable assets:
>> disk image: https://storage.googleapis.com/syzbot-assets/a0d037332dff/disk-80234b5a.raw.xz
>> vmlinux: https://storage.googleapis.com/syzbot-assets/0a1f7f8b54f8/vmlinux-80234b5a.xz
>> kernel image: https://storage.googleapis.com/syzbot-assets/83eb68ee6421/bzImage-80234b5a.xz
>> 
>> IMPORTANT: if you fix the issue, please add the following tag to the commit:
>> Reported-by: syzbot+c18de0ad13d62f18469d@syzkaller.appspotmail.com
>> 
>> =====================================================
>> BUG: KMSAN: uninit-value in copy_from_kernel_nofault+0x15f/0x570 mm/maccess.c:41
>>  copy_from_kernel_nofault+0x15f/0x570 mm/maccess.c:41
>>  prepend_copy fs/d_path.c:50 [inline]
>>  prepend fs/d_path.c:76 [inline]
>>  prepend_name fs/d_path.c:101 [inline]
>>  __prepend_path fs/d_path.c:133 [inline]
>>  prepend_path+0x64e/0x1090 fs/d_path.c:172
> 
> I think this might just be KMSAN not being able to deal with seqlocks
> appropriately? 

Let's cc KMSAN folks then. Maybe there's a way to teach it that/add
exceptions/ignores.

> dentry->d_shortname.string[DNAME_INLINE_LEN-1] = 0;
> 
> is initialized with a zero byte at the end instead of:
> 
> memset(&dentry->d_shortname, 0, sizeof(dentry->d_shortname));
> 
> which would prevent that warning. But that's zeroing 40 bytes vs one and
> the dache is fast-fast-fast.
> 
> prepend_path() detects the initialization race via rename_lock seqlock
> and retries d_absolute_path(). So this is entirely harmless and works
> correct.



Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 73387C61DE4
	for <linux-mm@archiver.kernel.org>; Tue,  1 Sep 2026 06:34:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5CA976B00B1; Tue,  1 Sep 2026 02:34:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5A2366B00B2; Tue,  1 Sep 2026 02:34:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4DED26B00B3; Tue,  1 Sep 2026 02:34:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 2EA786B00B1
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 02:34:46 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id AB3471C1DB9
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 06:34:45 +0000 (UTC)
X-FDA: 85164230130.20.46E5ECB
Received: from mail-m2488.xmail.ntesmail.com (mail-m2488.xmail.ntesmail.com [45.195.24.88])
	by imf14.hostedemail.com (Postfix) with ESMTP id 21C18100004
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 06:34:41 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=easystack.cn;
	spf=pass (imf14.hostedemail.com: domain of zhen.ni@easystack.cn designates 45.195.24.88 as permitted sender) smtp.mailfrom=zhen.ni@easystack.cn
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788244484;
	b=w4cAxq5jtMiv0YmLpBkZ5gS6n1noBi5AQbmEe/CS0WvAR3lu/G9uV28G568rjLFQq9R/NR
	PivETuJ2BNPq0+JOTKAfloP+HuvehQ6ZLXqlzKFwVQ9LCUJ4xUaibeFs02br1JSbSq4FNg
	cD6HtbXZR3VBpcY0RMUkTC7TWrC9GWM=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788244484;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=PJCfy+N44QeGKCwM7n6h2jL3FwgJyHq9SdsScC9ngt4=;
	b=GzF2eqAcW8d4XeQpVlSe6/5kNm/Z8W51ssl2UGh6ueH6Mu1WAKOUxe2A4NQJ4Mxf7ofYX7
	9ALwyK7AaaDMa7Vi1Cd05eAYeguJZ1DMvmbVLEvdPuIxZR5y+wZN1naL8tq3OPv0lN8FD5
	NuIiKAEsp33ynmwDOudpNQH69K/KqbY=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=easystack.cn;
	spf=pass (imf14.hostedemail.com: domain of zhen.ni@easystack.cn designates 45.195.24.88 as permitted sender) smtp.mailfrom=zhen.ni@easystack.cn
Received: from [192.168.0.59] (unknown [218.94.118.90])
	by smtp.qiye.163.com (Hmail) with ESMTP id 1e8c82612;
	Tue, 1 Sep 2026 14:34:34 +0800 (GMT+08:00)
Message-ID: <9fce3210-3548-4df3-ae00-730b666f5d57@easystack.cn>
Date: Tue, 1 Sep 2026 14:34:34 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/8] mm/page_owner: Add PID/TGID/COMM and cgroup filtering
To: Andrew Morton <akpm@linux-foundation.org>,
 "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: David Hildenbrand <david@kernel.org>,
 "Liam R . Howlett" <liam@infradead.org>, Vlastimil Babka
 <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>,
 Randy Dunlap <rdunlap@infradead.org>,
 Brendan Jackman <brendan.jackman@linux.dev>,
 Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
 linux-mm@kvack.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20260828031339.1270699-1-zhen.ni@easystack.cn>
 <apEx0wT_hWs1Q5Wp@gremlin>
 <20260828113654.d01abd8baed3f73e87506eb3@linux-foundation.org>
From: "zhen.ni" <zhen.ni@easystack.cn>
In-Reply-To: <20260828113654.d01abd8baed3f73e87506eb3@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-HM-Tid: 0aa05bad3a510229kunm61780f1f274d70
X-HM-MType: 1
X-HM-Spam-Status: e1kfGhgUHx5ZQUpXWQgPGg8OCBgUHx5ZQUlOS1dZFg8aDwILHllBWSg2Ly
	tZV1koWUFJQjdXWRgWCB1ZQUpXWS1ZQUlXWQ8JGhUIEh9ZQVlDQhpMVkhLTEIYGkNKGE1OSlYVFA
	kWGhdVGRETFhoSFyQUDg9ZV1kYEgtZQVlJSkNVQk9VSkpDVUJLWVdZFhoPEhUdFFlBWU9LSFVKS0
	hKSkJMVUpLS1VKQktLWQY+
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 21C18100004
X-Stat-Signature: f8pngw8147nm3xncjdt47hwiybkchyba
X-HE-Tag: 1788244481-808761
X-HE-Meta: U2FsdGVkX18UUF6DRDR8SK3cMAEXMLiqbwaspn7itmnPQF7qfvBvmaOAINYwG/XStAs0/cpBaexA67ipw1Hp3d1LfNUOZ4A2leSJX+uY67fgN2dxZzba8+c18U5NQNfzsXW31BC2QKCD3ToT4WuliWgc41Ky5FxziclN9ushq84BBxRR3Ewr/cNqPcATHrSXNaCYsekVqU02aX6+4mzPUIPJRk/Jinb9ZuIFSi8f1Yy/4eTF0XS6sHqvJr78EP1winDXLRu6sCng+WpIBtd9QZDP8l0+UsjmfPvuPdDpPHs1wCpigegrelQ+mzF9S8bHtVyGcHHW4CKqRtPn3KCMVTtINEYc3feN8gc0/3uECIGQlfo6F1JdepfKJtsDLflM/mx9FRJxY7mmKAKdIs9+gyHk/Cc/ciLYjwrbqk0NqDN80clgBWcieq12ynCHveae+wp1Dpw700mXCCUq6v3y+dcjphA81LdE5DG+SkXa2Q/bXDTCX7CIzhcXRinK76mLBLb4rsr5SbOLuH5zqJsrGv7I43/eKjzY/GQiVHqzJ5dgEynW9TfficZmdPxYoZBRPQPj/aLJ5JyWYs+R+N4bKrblL2rvAH4CrG2m3VOupKXvjvXNJ37E7jBRZ7tnuBMDQP9656f8UgW/DwLRMDUlCB0JeGS40BfkfBTHmp602Zh79WeAl7bLPiLDXvrxY2ZlFPuVGcjVad+RZQs6AMZcB7xoz1xHGcbJCmBTh5FlSewya00aGhbOGOyVEtFaYMdnVMDZpe1eO2jZnzVjs6Fne6SeikjBtLggMv+1zStk916CwyniCcJ0SQMjJw+aiiNIzE3SpZaSW/BUpNRb3e8/e2G+z4AgHibXOaSTfKB1HGI+Lfu+w8s4lYXuoMgFLygPLI4pyKX+VzyUwnnw/58Ej7/5zPjteK5ZpI9Eq/PICS3gZdY4qTLMX3R4cwWz1T2Ss9lNJuJ703rF2kZGnJw
 6cjtWLVY
 K0XyUQBf2E/38U+dfKsPOkr3K5wNkskUjP3XE2vUedQ/Ag+cplbH1U8nhaPG5Skgp4Q+eYrmxQcQM7LQ4aKYKpPQZIJxsrahUoH5syjbKws6y5ErA9zILW2jsO4Ksi273L4wFDUmhjEn9re1tjgDL5SL3s7HfcjSUhJQqoLMzcXGmCjB8EgWv7zriCfQ8l1PB4TsICQyPSHeL7VGhu4WVUMwCEWpMihjoPG/pHMALO8s3ftRefly8vdmqtZwzhMZmOOob/sDYtsGicc0s+lVdZstbXSY51GX0qHpFRm4YT8Md095Y9JhunFZ3mQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



在 2026/8/29 02:36, Andrew Morton 写道:
> On Fri, 28 Aug 2026 08:03:38 +0100 "Lorenzo Stoakes (ARM)" <ljs@kernel.org> wrote:
> 
>> On Fri, Aug 28, 2026 at 11:13:31AM +0800, Zhen Ni wrote:
>>> This patch series adds process and memory cgroup filtering support to
>>> page_owner. Following the previous series that introduced print_mode and
>>> NUMA node filters:
>>>    https://lore.kernel.org/linux-mm/20260707115411.1714314-1-zhen.ni@easystack.cn/
>>>
>>> This series adds filtering capabilities to page_owner, allowing users to
>>> filter output by specific processes and memory cgroups. Users can now
>>> filter page_owner output by PID, TGID, COMM (with wildcard support), and
>>> memory cgroup path. This makes page_owner debugging more focused and
>>> efficient for tracking memory allocations in specific contexts.
>>
>> The majority of this cover letter feels like it should have been
>> documentation put somewhere :)
> 
> yes please.
> 
> The only thing longer than the cover letter is the Sashiko report ;)
> 
> 	https://sashiko.dev/#/patchset/20260828031339.1270699-1-zhen.ni@easystack.cn
> 
> 

Hi Andrew, Lorenzo,

Thanks for the review.

I have analyzed all the Sashiko report findings. Some will be fixed in
the next version, and for the rest I propose not to fix them, with
reasons below. If there are no objections I will send v2 accordingly.

Will be fixed in the next version:

- mm/page_owner.c: drop the kstrdup() copy in parse_pid_t_list(); the
   token will be parsed in place. This also fixes a leak on the success
   path and a kfree() of an advanced (interior) pointer on the error
   path. cmp_int() will replace plain subtraction in cmp_pid_t(), and
   pid values exceeding PID_MAX_LIMIT will be rejected.
- mm/page_owner.c: PAGE_OWNER will select GLOB so glob_match() is
   always linked in; parse_comm_list() will drop its kstrdup() copy the
   same way.
- mm/page_owner.c: the cgroup path buffer will be allocated once per
   read() outside the page_ext RCU read-side critical section instead of
   per page inside get_page_memcg_info() (GFP_KERNEL allocations must
   not sleep there). The memcg= parsing branch will be guarded by
   CONFIG_MEMCG so kernels built without memcg reject the command
   instead of silently enabling a filter that never matches.
- tools/mm/page_owner_filter.c: user-visible input errors (empty
   -p/-t/-c/-g arguments) will print error messages instead of exiting
   silently.
- Documentation: the wildcard pattern in the -c example will be quoted
   to prevent shell glob expansion.

Proposed not to fix, by design:

1. Shared-fd concurrent read/write races (READ_ONCE around the pid
    passed to bsearch, torn reads of pid/tgid lists, glob_match() racing
    comm rewrites, concurrent write() leading to state->memcg_path
    double-allocation): multi-threaded sharing of one page_owner fd is
    not a designed use of this interface. The filters are per-fd state
    meant to be configured once and then read, which is what the
    page_owner_filter tool does. Adding locking to the read path would
    put overhead into the per-page scan loop for no designed benefit.
    This matches the semantics of the original filter introduction.

2. No "clear filter" support (empty pid=/tgid= lists partially clearing
    proc filters, empty memcg=/nid= being rejected): write commands are
    incremental -- "keep the unmentioned filters" -- and there is no
    clear operation by design. To start over, close the fd and open a
    fresh one; the page_owner_filter tool already works this way. This
    also matches the semantics of the original filter introduction.

3. kcalloc() vs kmalloc_array() for new_comm_list: no consumer of the
    list reads past strscpy()'s NUL terminator, so uninitialized bytes
    are unreachable.

4. char cgroup_path[512] in validate_cgroup_path(): acknowledged that
    the kernel side accepts paths up to PATH_MAX (4096). The userspace
    check truncates an over-long path with snprintf() and then fails
    access(), so it is rejected, never silently accepted. Bumping the
    buffer to PATH_MAX would only serve pathological paths; realistic
    cgroup paths are well under 100 bytes, so 512 wastes nothing in
    practice.

If this plan looks reasonable I will send v2.

Thanks,
Zhen Ni


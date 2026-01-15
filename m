Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 39DA9D46600
	for <linux-mm@archiver.kernel.org>; Thu, 15 Jan 2026 17:21:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 777A86B0088; Thu, 15 Jan 2026 12:21:34 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 725E46B0089; Thu, 15 Jan 2026 12:21:34 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5DCEF6B008A; Thu, 15 Jan 2026 12:21:34 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 4B33A6B0088
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 12:21:34 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id D1EB21403FB
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 17:21:33 +0000 (UTC)
X-FDA: 84334864866.19.3B0BCBD
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf03.hostedemail.com (Postfix) with ESMTP id 66A0020013
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 17:21:31 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=ar9Eb2Ks;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="DUV/+18b";
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=ar9Eb2Ks;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="DUV/+18b";
	spf=pass (imf03.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768497691;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=H7nbsdJegADMvNMzeEWBItdwlctZ/7S4Mk0Bv+Ze694=;
	b=vU3ZyNeQbADcLoyxwLEql05wUgImEjXg8jLjIPl9bnvdv3jzZIEQUVRQxkKhzKAvw7J6JK
	2arJw35db4Ai2T+vxYUw37Yltc9y0MeEnkiTcm2/MFkjno8w3RP7Xc6ujbIRRBSISnwxuJ
	EwFINTg1oCB75T+C5Q/MVD6lqWBc2xk=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=ar9Eb2Ks;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="DUV/+18b";
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=ar9Eb2Ks;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="DUV/+18b";
	spf=pass (imf03.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768497691; a=rsa-sha256;
	cv=none;
	b=tF3J8JCehsco/oz3TogvQl8px8sTt1ERSQKi+tcBnGzfQ3UPT8TxJE6D27GK0ClTSRIm9c
	uV4gfS/L9N3E4nDk4UdnjPTSF7zrglQD0I2A88+GahxyA9Rkh/rggiR8/O7vNYSCM1cHuj
	WsSN9dm8bb0zuVEadbdfSaCCy7QYRFY=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id A90C35BD01;
	Thu, 15 Jan 2026 17:21:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1768497689; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=H7nbsdJegADMvNMzeEWBItdwlctZ/7S4Mk0Bv+Ze694=;
	b=ar9Eb2KsNGFgc9+YKY3N0CvPegHkrWBEqD6Ba3Ygu+8/Yk9WYN96m+kK7OSCyaqF8nJT+6
	Sp0iexD0M4TznIXzoK1KLeiDjyG/EB6lcdJUgI2xW2sIEGZUvRTQnMVCE3IQNFmhrO6lDT
	3R3U39Ta+J0XHBPbhIcCYAQ3WeKV2ek=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1768497689;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=H7nbsdJegADMvNMzeEWBItdwlctZ/7S4Mk0Bv+Ze694=;
	b=DUV/+18brg0WwFScx8DChNDAeL7QZIcyVp9gDJkebxtK3EGye1CNC896wU78jsO9pJFJM6
	vrikNBiXnCgV6fBw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1768497689; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=H7nbsdJegADMvNMzeEWBItdwlctZ/7S4Mk0Bv+Ze694=;
	b=ar9Eb2KsNGFgc9+YKY3N0CvPegHkrWBEqD6Ba3Ygu+8/Yk9WYN96m+kK7OSCyaqF8nJT+6
	Sp0iexD0M4TznIXzoK1KLeiDjyG/EB6lcdJUgI2xW2sIEGZUvRTQnMVCE3IQNFmhrO6lDT
	3R3U39Ta+J0XHBPbhIcCYAQ3WeKV2ek=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1768497689;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=H7nbsdJegADMvNMzeEWBItdwlctZ/7S4Mk0Bv+Ze694=;
	b=DUV/+18brg0WwFScx8DChNDAeL7QZIcyVp9gDJkebxtK3EGye1CNC896wU78jsO9pJFJM6
	vrikNBiXnCgV6fBw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id F16833EA63;
	Thu, 15 Jan 2026 17:21:28 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id /EqUOhgiaWlcDAAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Thu, 15 Jan 2026 17:21:28 +0000
Message-ID: <c1b309a0-7f2e-473d-940e-af05bc907b96@suse.cz>
Date: Thu, 15 Jan 2026 18:21:28 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/1] mm: Fix OOM killer inaccuracy on large many-core
 systems
Content-Language: en-US
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Michal Hocko <mhocko@suse.com>,
 "Paul E. McKenney" <paulmck@kernel.org>, Steven Rostedt
 <rostedt@goodmis.org>, Masami Hiramatsu <mhiramat@kernel.org>,
 Dennis Zhou <dennis@kernel.org>, Tejun Heo <tj@kernel.org>,
 Christoph Lameter <cl@linux.com>, Martin Liu <liumartin@google.com>,
 David Rientjes <rientjes@google.com>, christian.koenig@amd.com,
 Shakeel Butt <shakeel.butt@linux.dev>, SeongJae Park <sj@kernel.org>,
 Johannes Weiner <hannes@cmpxchg.org>,
 Sweet Tea Dorminy <sweettea-kernel@dorminy.me>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 "Liam R . Howlett" <liam.howlett@oracle.com>, Mike Rapoport
 <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Christian Brauner <brauner@kernel.org>, Wei Yang
 <richard.weiyang@gmail.com>, David Hildenbrand <david@redhat.com>,
 Miaohe Lin <linmiaohe@huawei.com>, Al Viro <viro@zeniv.linux.org.uk>,
 linux-mm@kvack.org, stable@vger.kernel.org,
 linux-trace-kernel@vger.kernel.org, Yu Zhao <yuzhao@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>, Mateusz Guzik
 <mjguzik@gmail.com>, Matthew Wilcox <willy@infradead.org>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 Aboorva Devarajan <aboorvad@linux.ibm.com>
References: <20260114143642.47333-1-mathieu.desnoyers@efficios.com>
From: Vlastimil Babka <vbabka@suse.cz>
Autocrypt: addr=vbabka@suse.cz; keydata=
 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
 m6M14QORSWTLRg==
In-Reply-To: <20260114143642.47333-1-mathieu.desnoyers@efficios.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 66A0020013
X-Stat-Signature: ec59dbp79ggmbqtmnxy6889srmofh8pi
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1768497691-546239
X-HE-Meta: U2FsdGVkX1/ayAEo55/DOc+P4HOP0IU7R6qiOu1G9xDHAzvxj9ACJ3rgCPCkcXir+kVoRbpjZ93WpJT5zgdiHZgGhFlMdgIogQV7SqtzUJcYuxuRnn6YBBCodK4wpXULMXJfObPVXpZv4a1frD54lhgMxBXsOj2gpEAB9CceJd0nagZ67O7p7ghd0SoaxkTWiy7huiwKY32UJFGc/txNnHu/A6904aBq5FRZHVObiw4WSFwY9Xbb40CZTh6MVJoUuTR8I/9Ctdn6zS5R/ORulCoPepLUwZ9OZy3omzvLZNkwFO5ka0RHLufPnFEnUX4IiuTaw1IJS3laVgO/LTkmpp2roeMdJNsuC9Qn8gtlb1mkfzn8HUHS+r5xtCFuUuhvNGRpKd/Bg9yoolov1oYj2zdKx+4aIXgSvtGlIqHvdRa/UNR4Cim+NwZeVpa3w09Bn1DgpRFXVJdUBS73tTZ24qmR7D9ZCl44ELqbwq9LbcYXoZwkZJwoEA/ViK/3tNkFA8jJs4Z822/rJk5klyfMT+LnpzZxEfrcQ/iDmR1gYmn7iFUeg01rHtp+H/FKeGOLCWk627lW7WAYmj1e7Zq6tVE5LCDp6QTTiCc50D7hX0DWy3IHk/Y5Nq4zwVPXg78NVXcBuLtCTX5dosFKNci6IPo5mklsUr0rhwec0yNkHMKyvg3m1orJra0DIwWhC3d4z5Q7ps55Fp2P+0H6/UxrWFjkFvgJTTS4TGphtuGjnXo7j2wqYJSi994DdodiV+Gg++i91QoUCcLCge8MXgJbpRpxCxqvqP31bNpaDJ0LcMfsqusDg43snIYD6/9f9VIUwautG1Cw4GVR4XMsHL79ol8pqsbHNGuZqWiyBTcgxDmlJKaCKCyZS0kxY0VJ2ta5bt2HvyGSm2yFrQmdaISScFVUv1viI9lmlENeXvFKXsLMTYvGCkEY2WXMeqPZdQqHZqsUyHcSH9fXdlLwVtn
 imgYtTeK
 VRstwt7LGYCEjndg1ajKvyOE9BsOsRg1UvJSaGY3pVWos78AK/A2TOEa3HFI6dm0/rYgA2bNnKYzMr0qKhzu0k2Q/dLiyCVdaurnokAyLJFbsfs/wqP9X45cyZDF5h5ZevOLTjgHOBqk7Ah7lO+XX1X41dcCFYE60a/tEgWjJxKgqeatp9qY+euyxhk06qRnAmTzIroJTyDQSzfVALIiogqC8Yrx7L9fDBhZy86moKGwTucA0qUAUMu3BW0ETFVZ3d4ZjPl8kYqjbmnF6TO7TKi8N1tGwE77ne7coFZyhyBCVL7iQ5ztst16ELS20Lse2Mr5MiwXsYHVUbMEkmfw2b74Jk+E1IOZA6ffybi7iFLKQG4vJorluTCXu2KEaE+fpuNa5dXJImLr+I2Ap1IRjskZMpMIKJarHP7PCo+CPacmc/qN4lxuudn9hCtBRXb3RsZUBzm/wofnigcOU11ikVuhlPEuKp2pd7QMXTIttCDnbGG4EZAz5l+2h2SzADAWbikIyNXnEQsPnT4Bdku8erS65o/GT7tc26vFGPvtyscd9WnK8E5/9UDAR5p+Wy/+IsKCPEJ92sp4v2TGPnctg9+971tCkAp28kMvICwr2JRrvrkb3tavEEaG/AHINWPVOxNWJU0iqA5m17W8DpGrt5GQcouDaeHvB64Q4o+6Wxm+NbDdX6+ePeSqskjcMalDWrEiu/F5Y70d+eAApatLXJ9YqoORDjJzfYv+Ud1UIaowREa0TlMQXtmD3nhxOhwRvZ5J0TbyHimDRQLxZ6pXpa94fFzcnb+/akHE63HxXLX9j07Aje0UDQlkHNgT8t7jszXzIwY00cWIYe+tKsXMQ1lnOR8moUUMp420CVPo2mupVndJMBGjEtvDslpfnPmTN1WXkGkpP3VyVzM41JX+5CF8Y8AO28eJRqFUAGD8umuHtorprqjyoMuqHXho8u6Xx9xgMXVhucNRrCrddgmoFGOKTlZJW
 yq5oGeV1
 GdAchPDcChRUWwbaDUu5vbeJaxxYcJqnT2VpIHNk4nqJYSvH+86zDZmzew/AUo77Qrl0myHS+gPjHES1TDgPWEbWz9c6kwl3tssejdefWXmF/wzhWBP1Fo/tyWcAqIQS
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 1/14/26 15:36, Mathieu Desnoyers wrote:
> Use the precise, albeit slower, precise RSS counter sums for the OOM
> killer task selection and console dumps. The approximated value is
> too imprecise on large many-core systems.
> 
> The following rss tracking issues were noted by Sweet Tea Dorminy [1],
> which lead to picking wrong tasks as OOM kill target:
> 
>   Recently, several internal services had an RSS usage regression as part of a
>   kernel upgrade. Previously, they were on a pre-6.2 kernel and were able to
>   read RSS statistics in a backup watchdog process to monitor and decide if
>   they'd overrun their memory budget. Now, however, a representative service
>   with five threads, expected to use about a hundred MB of memory, on a 250-cpu
>   machine had memory usage tens of megabytes different from the expected amount
>   -- this constituted a significant percentage of inaccuracy, causing the
>   watchdog to act.
> 
>   This was a result of commit f1a7941243c1 ("mm: convert mm's rss stats
>   into percpu_counter") [1].  Previously, the memory error was bounded by
>   64*nr_threads pages, a very livable megabyte. Now, however, as a result of
>   scheduler decisions moving the threads around the CPUs, the memory error could
>   be as large as a gigabyte.
> 
>   This is a really tremendous inaccuracy for any few-threaded program on a
>   large machine and impedes monitoring significantly. These stat counters are
>   also used to make OOM killing decisions, so this additional inaccuracy could
>   make a big difference in OOM situations -- either resulting in the wrong
>   process being killed, or in less memory being returned from an OOM-kill than
>   expected.
> 
> Here is a (possibly incomplete) list of the prior approaches that were
> used or proposed, along with their downside:
> 
> 1) Per-thread rss tracking: large error on many-thread processes.
> 
> 2) Per-CPU counters: up to 12% slower for short-lived processes and 9%
>    increased system time in make test workloads [1]. Moreover, the
>    inaccuracy increases with O(n^2) with the number of CPUs.
> 
> 3) Per-NUMA-node counters: requires atomics on fast-path (overhead),
>    error is high with systems that have lots of NUMA nodes (32 times
>    the number of NUMA nodes).
> 
> commit 82241a83cd15 ("mm: fix the inaccurate memory statistics issue for
> users") introduced get_mm_counter_sum() for precise proc memory status
> queries for some proc files.
> 
> The simple fix proposed here is to do the precise per-cpu counters sum
> every time a counter value needs to be read. This applies to the OOM
> killer task selection, oom task console dumps (printk).
> 
> This change increases the latency introduced when the OOM killer
> executes in favor of doing a more precise OOM target task selection.
> Effectively, the OOM killer iterates on all tasks, for all relevant page
> types, for which the precise sum iterates on all possible CPUs.
> 
> As a reference, here is the execution time of the OOM killer
> before/after the change:
> 
> AMD EPYC 9654 96-Core (2 sockets)
> Within a KVM, configured with 256 logical cpus.
> 
>                                   |  before  |  after   |
> ----------------------------------|----------|----------|
> nr_processes=40                   |  0.3 ms  |   0.5 ms |
> nr_processes=10000                |  3.0 ms  |  80.0 ms |
> 
> Suggested-by: Michal Hocko <mhocko@suse.com>
> Fixes: f1a7941243c1 ("mm: convert mm's rss stats into percpu_counter")
> Link: https://lore.kernel.org/lkml/20250331223516.7810-2-sweettea-kernel@dorminy.me/ # [1]
> Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>

Acked-by: Vlastimil Babka <vbabka@suse.cz>

> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: "Paul E. McKenney" <paulmck@kernel.org>
> Cc: Steven Rostedt <rostedt@goodmis.org>
> Cc: Masami Hiramatsu <mhiramat@kernel.org>
> Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
> Cc: Dennis Zhou <dennis@kernel.org>
> Cc: Tejun Heo <tj@kernel.org>
> Cc: Christoph Lameter <cl@linux.com>
> Cc: Martin Liu <liumartin@google.com>
> Cc: David Rientjes <rientjes@google.com>
> Cc: christian.koenig@amd.com
> Cc: Shakeel Butt <shakeel.butt@linux.dev>
> Cc: SeongJae Park <sj@kernel.org>
> Cc: Michal Hocko <mhocko@suse.com>
> Cc: Johannes Weiner <hannes@cmpxchg.org>
> Cc: Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
> Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> Cc: "Liam R . Howlett" <liam.howlett@oracle.com>
> Cc: Mike Rapoport <rppt@kernel.org>
> Cc: Suren Baghdasaryan <surenb@google.com>
> Cc: Vlastimil Babka <vbabka@suse.cz>
> Cc: Christian Brauner <brauner@kernel.org>
> Cc: Wei Yang <richard.weiyang@gmail.com>
> Cc: David Hildenbrand <david@redhat.com>
> Cc: Miaohe Lin <linmiaohe@huawei.com>
> Cc: Al Viro <viro@zeniv.linux.org.uk>
> Cc: linux-mm@kvack.org
> Cc: stable@vger.kernel.org
> Cc: linux-trace-kernel@vger.kernel.org
> Cc: Yu Zhao <yuzhao@google.com>
> Cc: Roman Gushchin <roman.gushchin@linux.dev>
> Cc: Mateusz Guzik <mjguzik@gmail.com>
> Cc: Matthew Wilcox <willy@infradead.org>
> Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
> Cc: Aboorva Devarajan <aboorvad@linux.ibm.com>
> ---
> This patch replaces v1. It's aimed at mm-new.
> 
> Changes since v1:
> - Only change the oom killer RSS values from approximated to precise
>   sums. Do not change other RSS values users.
> ---
>  include/linux/mm.h |  7 +++++++
>  mm/oom_kill.c      | 22 +++++++++++-----------
>  2 files changed, 18 insertions(+), 11 deletions(-)
> 
> diff --git a/include/linux/mm.h b/include/linux/mm.h
> index 6f959d8ca4b4..bfa1307264df 100644
> --- a/include/linux/mm.h
> +++ b/include/linux/mm.h
> @@ -2901,6 +2901,13 @@ static inline unsigned long get_mm_rss(struct mm_struct *mm)
>  		get_mm_counter(mm, MM_SHMEMPAGES);
>  }
>  
> +static inline unsigned long get_mm_rss_sum(struct mm_struct *mm)
> +{
> +	return get_mm_counter_sum(mm, MM_FILEPAGES) +
> +		get_mm_counter_sum(mm, MM_ANONPAGES) +
> +		get_mm_counter_sum(mm, MM_SHMEMPAGES);
> +}
> +
>  static inline unsigned long get_mm_hiwater_rss(struct mm_struct *mm)
>  {
>  	return max(mm->hiwater_rss, get_mm_rss(mm));
> diff --git a/mm/oom_kill.c b/mm/oom_kill.c
> index 5eb11fbba704..214cb8cb939b 100644
> --- a/mm/oom_kill.c
> +++ b/mm/oom_kill.c
> @@ -228,7 +228,7 @@ long oom_badness(struct task_struct *p, unsigned long totalpages)
>  	 * The baseline for the badness score is the proportion of RAM that each
>  	 * task's rss, pagetable and swap space use.
>  	 */
> -	points = get_mm_rss(p->mm) + get_mm_counter(p->mm, MM_SWAPENTS) +
> +	points = get_mm_rss_sum(p->mm) + get_mm_counter_sum(p->mm, MM_SWAPENTS) +
>  		mm_pgtables_bytes(p->mm) / PAGE_SIZE;
>  	task_unlock(p);
>  
> @@ -402,10 +402,10 @@ static int dump_task(struct task_struct *p, void *arg)
>  
>  	pr_info("[%7d] %5d %5d %8lu %8lu %8lu %8lu %9lu %8ld %8lu         %5hd %s\n",
>  		task->pid, from_kuid(&init_user_ns, task_uid(task)),
> -		task->tgid, task->mm->total_vm, get_mm_rss(task->mm),
> -		get_mm_counter(task->mm, MM_ANONPAGES), get_mm_counter(task->mm, MM_FILEPAGES),
> -		get_mm_counter(task->mm, MM_SHMEMPAGES), mm_pgtables_bytes(task->mm),
> -		get_mm_counter(task->mm, MM_SWAPENTS),
> +		task->tgid, task->mm->total_vm, get_mm_rss_sum(task->mm),
> +		get_mm_counter_sum(task->mm, MM_ANONPAGES), get_mm_counter_sum(task->mm, MM_FILEPAGES),
> +		get_mm_counter_sum(task->mm, MM_SHMEMPAGES), mm_pgtables_bytes(task->mm),
> +		get_mm_counter_sum(task->mm, MM_SWAPENTS),
>  		task->signal->oom_score_adj, task->comm);
>  	task_unlock(task);
>  
> @@ -604,9 +604,9 @@ static bool oom_reap_task_mm(struct task_struct *tsk, struct mm_struct *mm)
>  
>  	pr_info("oom_reaper: reaped process %d (%s), now anon-rss:%lukB, file-rss:%lukB, shmem-rss:%lukB\n",
>  			task_pid_nr(tsk), tsk->comm,
> -			K(get_mm_counter(mm, MM_ANONPAGES)),
> -			K(get_mm_counter(mm, MM_FILEPAGES)),
> -			K(get_mm_counter(mm, MM_SHMEMPAGES)));
> +			K(get_mm_counter_sum(mm, MM_ANONPAGES)),
> +			K(get_mm_counter_sum(mm, MM_FILEPAGES)),
> +			K(get_mm_counter_sum(mm, MM_SHMEMPAGES)));
>  out_finish:
>  	trace_finish_task_reaping(tsk->pid);
>  out_unlock:
> @@ -960,9 +960,9 @@ static void __oom_kill_process(struct task_struct *victim, const char *message)
>  	mark_oom_victim(victim);
>  	pr_err("%s: Killed process %d (%s) total-vm:%lukB, anon-rss:%lukB, file-rss:%lukB, shmem-rss:%lukB, UID:%u pgtables:%lukB oom_score_adj:%hd\n",
>  		message, task_pid_nr(victim), victim->comm, K(mm->total_vm),
> -		K(get_mm_counter(mm, MM_ANONPAGES)),
> -		K(get_mm_counter(mm, MM_FILEPAGES)),
> -		K(get_mm_counter(mm, MM_SHMEMPAGES)),
> +		K(get_mm_counter_sum(mm, MM_ANONPAGES)),
> +		K(get_mm_counter_sum(mm, MM_FILEPAGES)),
> +		K(get_mm_counter_sum(mm, MM_SHMEMPAGES)),
>  		from_kuid(&init_user_ns, task_uid(victim)),
>  		mm_pgtables_bytes(mm) >> 10, victim->signal->oom_score_adj);
>  	task_unlock(victim);



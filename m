Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B586CCAC5B8
	for <linux-mm@archiver.kernel.org>; Tue, 30 Sep 2025 07:43:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0CBE88E0027; Tue, 30 Sep 2025 03:43:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0A44E8E0002; Tue, 30 Sep 2025 03:43:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EFB848E0027; Tue, 30 Sep 2025 03:43:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id DF6758E0002
	for <linux-mm@kvack.org>; Tue, 30 Sep 2025 03:43:35 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 8AEF9BA743
	for <linux-mm@kvack.org>; Tue, 30 Sep 2025 07:43:35 +0000 (UTC)
X-FDA: 83945126790.30.362CE65
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf30.hostedemail.com (Postfix) with ESMTP id 61EA38000C
	for <linux-mm@kvack.org>; Tue, 30 Sep 2025 07:43:32 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="t0N6w/AM";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=xva+Ts5n;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="t0N6w/AM";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=xva+Ts5n;
	spf=pass (imf30.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759218212;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tWv6kYc8Znq14mP8rEXIkgR9K/OwdQEybl1xuZYh90M=;
	b=c/v3kLPgaO+PJGYWRml3jaS0qdUm9qETnVtJxjUe7GycvUobkw/9U6Fk3Ee7Q3bnuCFqZZ
	7ZaGc1J2aVHFqCzFEhuXJzN2ZuzjGTjezxfh+nGgYFy+jB7PwbFuw6Yl43JsD9qZjdedmd
	Cn1HbAADOYygsGw7wkmegI+ttC2eCJc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759218212; a=rsa-sha256;
	cv=none;
	b=Fxxdx8n/M49mU15ZaUyxxJYj1pGX5ePfDM5U9T1wVAEBxKq75kfEjQ611uF+PArQ1Yn+95
	CtSuoL0SLO8mC74505Nw0Hv4wdHpnanhQ/hrOOGBETTWDHomJ2dQogHi/a7reDJvxsfg8L
	2pNfFiebLPrW8umx3t/ASAO5S6CKK1Q=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="t0N6w/AM";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=xva+Ts5n;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="t0N6w/AM";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=xva+Ts5n;
	spf=pass (imf30.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 219151F747;
	Tue, 30 Sep 2025 07:43:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1759218209; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=tWv6kYc8Znq14mP8rEXIkgR9K/OwdQEybl1xuZYh90M=;
	b=t0N6w/AMC1Ug+t5cTpJuKpTY5ednFfBC5C55OYerHg5YnNRXM6TMtm2c+ezbaHYKLpXs13
	spLsU7rUzegLNgonoavueMlEmpBLtNTLh0WxEiKdd7VCsGVTC6a4GtGKU5oIBvgwhqLgaQ
	5uLew1nvUcZczbTdgkv33TAhUiU0WAk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1759218209;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=tWv6kYc8Znq14mP8rEXIkgR9K/OwdQEybl1xuZYh90M=;
	b=xva+Ts5niEu0NviFgcyz371DOYJa8E3ubxUNoLRcLwGp79abZuDicyYrCXTOoOBdKOs96A
	ryTFt44lpHf+j2Ag==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1759218209; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=tWv6kYc8Znq14mP8rEXIkgR9K/OwdQEybl1xuZYh90M=;
	b=t0N6w/AMC1Ug+t5cTpJuKpTY5ednFfBC5C55OYerHg5YnNRXM6TMtm2c+ezbaHYKLpXs13
	spLsU7rUzegLNgonoavueMlEmpBLtNTLh0WxEiKdd7VCsGVTC6a4GtGKU5oIBvgwhqLgaQ
	5uLew1nvUcZczbTdgkv33TAhUiU0WAk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1759218209;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=tWv6kYc8Znq14mP8rEXIkgR9K/OwdQEybl1xuZYh90M=;
	b=xva+Ts5niEu0NviFgcyz371DOYJa8E3ubxUNoLRcLwGp79abZuDicyYrCXTOoOBdKOs96A
	ryTFt44lpHf+j2Ag==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id F39581342D;
	Tue, 30 Sep 2025 07:43:28 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id wCUgOyCK22gKVAAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Tue, 30 Sep 2025 07:43:28 +0000
Message-ID: <877fa6d5-e2c7-41d8-88f7-6ee6ac395fc2@suse.cz>
Date: Tue, 30 Sep 2025 09:43:28 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm: re-enable kswapd when memory pressure subsides or
 demotion is toggled
Content-Language: en-US
To: Chanwon Park <flyinrm@gmail.com>, akpm@linux-foundation.org,
 surenb@google.com, mhocko@suse.com, jackmanb@google.com, hannes@cmpxchg.org,
 ziy@nvidia.com, david@redhat.com, zhengqi.arch@bytedance.com,
 shakeel.butt@linux.dev, lorenzo.stoakes@oracle.com
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <aL6qGi69jWXfPc4D@pcw-MS-7D22>
From: Vlastimil Babka <vbabka@suse.cz>
Autocrypt: addr=vbabka@suse.cz; keydata=
 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
 m6M14QORSWTLRg==
In-Reply-To: <aL6qGi69jWXfPc4D@pcw-MS-7D22>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 61EA38000C
X-Stat-Signature: 6q8b9eon1nq78ahq6eywqxm9rnrzw7pg
X-Rspam-User: 
X-HE-Tag: 1759218212-859166
X-HE-Meta: U2FsdGVkX18C0QNSPDiFwT7r+XbpKx8E/yE6QlJuiMIKJxeMvT3IhHpmC5gMFE0qRdzGvjxgeSfQPDeJPMn6iQVi2G9sQ+z0o7NmIRti9DVqmYomzWgwoLIvy3ligRnb6b59cwCSo5MZO7fWTD0tyY6wzZnQVvzatNGoaXNiG141pUyTzxq1LMqiYxDq2VIivhOrFoe6HJRRNsWfeKZtkmTrEmKSldRU3tRbjhd770aVw8eqYIhX7PsanxtEUbI0qEFH4qx2K0b7R6VPgxD/Ryf6ZzNHPW6QkqhlpWN05tbeJryfv1OjlFvcsjeWQGBkZgVNuT9BZT6kY1Y3gEcIFmBeFSQ8nPRkZNSXSp9Gss/VnVhHQWX39S7bKmqGmWR0Zu4fx1+djVk6UiRGPDG904k6+wxaLEAL9FNVWPXht4/wIcSbVbfqHPSgS3MqQHy1D4LqVGclg2bg7Hu/DrpEBXYAkc/pFGxBCm1X58U7QFzuV7VAMm/tPy0l+ASZlUI/3CK5IiNPDdxNHWJQjtmzf6g6CGYK5wB0q3wMTB4C5vMLHodqBrIS702MpQtrzLSUyR4mUjV+Si7bUopc9vzdP5hcAy1MitTYBGOhe71+ZtsdiO6/u/ZEu0PhzpDoVx/sLngXv56o24OJ+rOzYI24aoxtEuq+gWNC+Nd3QX0tF1eRN2NMi6TzsWJfG7Gfn8tUuKK9S6bs0mgKtHbrNlqyytScsMk10lJqQyUyP06vUN2KOwSmvaMmM4gqSoy8BJpdzI033LM3nn3ngayMpLnyYoz4NCEXOsmDbvwdJMR+V/SojCNKEjOP6akLZWJ/7VqaALj8rJdDON+BOee08ymIEvvpGH5Z8ZgLAkoQIuwH7tmmp+W3/6FcaIriBXw3eljXafD2rMCIbuxGAsQpWjuhybTxPOZWLMobzQUwhoJyB31543lf9IsE44HuwkWa15OdQGvUZRRvmYADP6tQcUa
 RPI1wQB1
 WMh5dYoutYUxt98VEn2uVFFAh1g/NoQ2dK74JLSiEQeXFXLscRYow40A8adQrzl2Ylca0fNVj9WIi7eU9X1ErQjrJ0ssp6xHMwzTo7Zn/HIthB3BrwJrheb2XQblKvQeNDTD1/XA8QUzRn+3VNXth5ugFglhgWKWx2+lnydDFcMUEHxDZXaJzxW13dZ4nPORwr51XM2axMYrFhSWBFSGG0aTk9XY434xVddWj+LAbYTkrw6fNf0ETjH2ZyKcxddtAHDYEMgTLy5Jral8OK4mJu3ze/ULWTgO+jyYcUkiG6OhHeqZUh8SJxWDxbQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/8/25 12:04, Chanwon Park wrote:
> If kswapd fails to reclaim pages from a node MAX_RECLAIM_RETRIES in a
> row, kswapd on that node gets disabled. That is, the system won't wakeup
> kswapd for that node until page reclamation is observed at least once.
> That reclamation is mostly done by direct reclaim, which in turn enables
> kswapd back.
> 
> However, on systems with CXL memory nodes, workloads with high anon page
> usage can disable kswapd indefinitely, without triggering direct
> reclaim. This can be reproduced with following steps:
> 
>    numa node 0   (32GB memory, 48 CPUs)
>    numa node 2~5 (512GB CXL memory, 128GB each)
>    (numa node 1 is disabled)
>    swap space 8GB
> 
>    1) Set /sys/kernel/mm/demotion_enabled to 0.
>    2) Set /proc/sys/kernel/numa_balancing to 0.
>    3) Run a process that allocates and random accesses 500GB of anon
>       pages.
>    4) Let the process exit normally.
> 
> During 3), free memory on node 0 gets lower than low watermark, and
> kswapd runs and depletes swap space. Then, kswapd fails consecutively
> and gets disabled. Allocation afterwards happens on CXL memory, so node
> 0 never gains more memory pressure to trigger direct reclaim.
> 
> After 4), kswapd on node 0 remains disabled, and tasks running on that
> node are unable to swap. If you turn on NUMA_BALANCING_MEMORY_TIERING
> and demotion now, it won't work properly since kswapd is disabled.
> 
> To mitigate this problem, reset kswapd_failures to 0 on following
> conditions:
> 
>    a) ZONE_BELOW_HIGH bit of a zone in hopeless node with a fallback
>       memory node gets cleared.
>    b) demotion_enabled is changed from false to true.
> 
> Rationale for a):
>    ZONE_BELOW_HIGH bit being cleared might be a sign that the node may
>    be reclaimable afterwards. This won't help much if the memory-hungry
>    process keeps running without freeing anything, but at least the node
>    will go back to reclaimable state when the process exits.
> 
> Rationale for b):
>    When demotion_enabled is false, kswapd can only reclaim anon pages by
>    swapping them out to swap space. If demotion_enabled is turned on,
>    kswapd can demote anon pages to another node for reclaiming. So, the
>    original failure count for determining reclaimability is no longer
>    valid.
> 
> Since kswapd_failures resets may be missed by ++ operation, it is
> changed from int to atomic_t.
> 
> Signed-off-by: Chanwon Park <flyinrm@gmail.com>

Acked-by: Vlastimil Babka <vbabka@suse.cz>



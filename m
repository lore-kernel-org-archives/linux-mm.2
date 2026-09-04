Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6D86BC79F80
	for <linux-mm@archiver.kernel.org>; Fri,  4 Sep 2026 04:34:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 084FF6B0088; Fri,  4 Sep 2026 00:34:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 035BF6B008A; Fri,  4 Sep 2026 00:34:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E8F286B0096; Fri,  4 Sep 2026 00:34:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B9AAB6B0088
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 00:34:36 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 439ED1A0724
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 04:34:36 +0000 (UTC)
X-FDA: 85174813752.25.3B4AF12
Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	by imf28.hostedemail.com (Postfix) with ESMTP id A1A61C0007
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 04:34:33 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=Ma9JpS8w;
	spf=pass (imf28.hostedemail.com: domain of sunjunchao@bytedance.com designates 209.85.214.179 as permitted sender) smtp.mailfrom=sunjunchao@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788496474;
	b=RcBM4XXsrr6eEJ+Bl/sRy8Gh6T5EDPIG7E5a4bh5ZSjqpkdB2XchUZqVf5OsTbMRoY7kmY
	njnw7P7LKMEYA3okkCF0LLz2jrGDwXBKv72OGpS8wOoZmB0HuzBA2AflKB8GUHopSV3ukY
	fnTr53/azwqWqYHyV/M8uWKUbGISjhI=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=Ma9JpS8w;
	spf=pass (imf28.hostedemail.com: domain of sunjunchao@bytedance.com designates 209.85.214.179 as permitted sender) smtp.mailfrom=sunjunchao@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788496474;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eSlhukOAEBzhTTxKjuHTEkWF5Nd7WBqUfZbcICKKwNo=;
	b=a6jKxpbjRlCjbSDJnVw8YERmpOQ2r9OGtMMAZqxDCNHc31vps5iqA1Pn8xdzM3sHwS2n1j
	ESfNds0hrrg2h1rRUEPDKWZ4VYHYUT9WPpdp2vLVQ6sIS3UE2LY6T9s8x2UZY5SJLP3m8I
	B5ikiYh+ACs+HQV2LEYSv1FdoLwRwAo=
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-2caced6038eso6202945ad.0
        for <linux-mm@kvack.org>; Thu, 03 Sep 2026 21:34:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1788496472; x=1789101272; darn=kvack.org;
        h=content-transfer-encoding:content-type:in-reply-to:from:references
         :cc:to:subject:user-agent:mime-version:date:message-id:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=eSlhukOAEBzhTTxKjuHTEkWF5Nd7WBqUfZbcICKKwNo=;
        b=Ma9JpS8wBHqilhVzRKZGwbRMY7DdHr/I1vNXxgUgn7IicjEFZj96SocmIf03qvwHKW
         dDHjwU+Zg+9B6GrgzEnokMIPqVsRH5utee+bzbeX4wjRBy4l+zWa4lnpggiKXq45iuSW
         ymf9vctR61bBlDxAJkeCn38OC6NupKQrWVy1EqXev1ef2oi2k4PDON0wpAFqJpXVUZD0
         hz9QuNKPvmQacaUq5zWv7nVhqGl/qrAcb3uQwrzoeBY54HW+rremhaUqKPL05TSHgS7N
         Ce3LJ7WTkW+KDVGqjQ/7rY+FWv31KChhIdEGPRDxuUgJG/0+nlG4AVAEb4NwX42u0qzw
         zj+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788496472; x=1789101272;
        h=content-transfer-encoding:content-type:in-reply-to:from:references
         :cc:to:subject:user-agent:mime-version:date:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=eSlhukOAEBzhTTxKjuHTEkWF5Nd7WBqUfZbcICKKwNo=;
        b=Di8LbTt5JX7Rej8ahuyuijIrqK/5Sc2RFrwku1fl22NrFPZ0yg8AgB/YpOtMUk05zm
         MihFsvglNh8wl61fss+J4y3UIeVOoYJehijgpB0qpdjTRK+fONm8fevCLHhH5BpJ1ap2
         SpOohuVIp/6gVWn4sXvV+3fgUVgOoMsmXlH9Afo89QfNGCaMlwoPX9q9P16qtRdsZMOC
         0ePaelVxZxi7ZzOPEHVQ1VfofyVhsZqBzjHCiejECZqNlL4nkeYITcPwuEs3Y3WtWk8O
         2sQTI9yLXxgHviGNz5IvT9GnnJsn+WP4Uh1/zsdoMjssdF82xP3jYyf/K8onR4//Lot0
         c3dw==
X-Gm-Message-State: AFuF++nX7fHNAVHEqKqKz2SmFWkZyxYc7X8CIvCStl9kP0e50LZhdqug
	2gResk0V+AgrKHKXXjaE2w6B5Kb/nxX9mjZXcRaRQ9m5Va29toGv42bcl1LrfxlS96Q=
X-Gm-Gg: AYBFou3bGwTW+6B/0eFjzykFAPbWgT7kA52fmP3b71qjArZYQJnIzZRN3ykquiB3v47
	8E0LfKCQD/mGA5zsPYo6ixAw5036vJwTO08V4GbL43g9fPlAbn5KU/NKIzDYZkzO/qkxo/kQblN
	meRkKrogNO9UqNP0VwCRGr/k08D7qFeUDpesBj96Li3aNEVLivwJ/kxD9EyofgmfnbStTo/CbL5
	CiRLVNw+VBulwygHZCNrGmVCfKRfjxIb/iC5RbmH+V4bfx0rA9vaKo8l0leITJbrs6LG4GIcu9O
	RXl1REU2bmCAkNfyhkmhX427M6y/aVKao9sFIOTo7ZZxoM/SKBLNQxtdWb++UX1f5Gq75XEv42G
	ppUfJqTD9pj7H2V3ZmZfks/nWchqGCfITnL8zZT6KGd2Ig7GjxPl5zJf5dSFMPR/1bsSe8N/QIU
	zrOsy3xp9BA3VlfBXYgbSJho/5dRFScZm+bl3BO+eVD6lPag3+HYsTw9HTOLKdNRCys50TrKfdf
	ZX+g4qZtH6WszWQA2J6u3RBWR8aR3HS
X-Received: by 2002:a17:903:32d1:b0:2db:18e7:e5db with SMTP id d9443c01a7336-2db18e7fa12mr13335245ad.12.1788496472116;
        Thu, 03 Sep 2026 21:34:32 -0700 (PDT)
Received: from [100.81.12.150] ([61.213.176.56])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2db1497d455sm4363415ad.30.2026.09.03.21.34.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 03 Sep 2026 21:34:31 -0700 (PDT)
Message-ID: <3a7ca3ba-d2e6-40a1-95b2-4d0ee93d4242@bytedance.com>
Date: Fri, 4 Sep 2026 12:34:27 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [External] Re: [PATCH v2] writeback, memcg: skip foreign dirty
 tracking for bdev inodes
To: Tejun Heo <tj@kernel.org>
Cc: linux-mm@kvack.org, cgroups@vger.kernel.org, hannes@cmpxchg.org,
 mhocko@kernel.org, roman.gushchin@linux.dev, shakeel.butt@linux.dev,
 muchun.song@linux.dev, akpm@linux-foundation.org, axboe@kernel.dk,
 jack@suse.cz
References: <20260903083303.2769873-1-sunjunchao@bytedance.com>
 <apnYouiUINQR-98e@slm.duckdns.org>
From: Julian Sun <sunjunchao@bytedance.com>
In-Reply-To: <apnYouiUINQR-98e@slm.duckdns.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: A1A61C0007
X-Stat-Signature: 8spq395jazuf1pogjpxmf7qpshn3bshc
X-Rspam-User: 
X-HE-Tag: 1788496473-733336
X-HE-Meta: U2FsdGVkX1/zl1Dim8MTRQWbe9WW/0KxoToUYG8Ze8AKUkvlM4YtI85zCV8B+oxC+NtiPCF62zVR61gGg7e+D8pFkSV5o7rWgAZuf9V95l9cXKWSLUnieIir81vOB0Cfz3KPSdMG+0DU1r+hvWmSD4qLPcWL6O9bg/MJpOXmsETZZCSDtYY5eyB0xOYEL8X4fekI/kVMb9DDzEc+hGFA8vvkhyyX2Twj0MbyX6okTRf1gWplCE29YHoxxE5KfNSpgK0llm+RHn00Q3RUf93maCsEBKz+17MiI3e5IXHcrQrcof+OW7BUX/XYxgW7Mxgw60QilGjYlcFw45yndh98BuLNdF7xhsqwbMkuM9h/X18KTWwLqf70z6gl8dMk35Mk0Jz3z0OD4iV3vFYM7Mu25oRtC+OSJ5gWAqUaGtoY468SEiSOeFe0STYHjUNgSOGVLcUaN/qo8Quwur1l6ekAjqIabGhCE+8WZXLQfofdKfZoEX5Bz+DV5HXU7lytQj0KVAL8rQHXKum1DLoXQdYzKRSYPq7xvN6GVafAdbK8Q0g0eckM+RzqtKfNtDSfBjqTTZL6KNrVz8h4e/j9X3R0t16xY4Q/S+j6P+JByLedlQbdRaB52TQfpRt/hVdfJ8mjrOiXWmHdnUvNSNJ6E4p5OracRRBxDpnehxTE/6HvBEHkRFyxQdWi5TaipwqwKCSIXa6ZCvjc4qpsXumSC5bPllAOFEqC65cEVR1eZueGewK2jynw7/ax349s03U9D4yBiU+5jH5XBG+NZ9TpnuTVxfale71PmauWLlGz5gZo3MGCr5gYZQvL4n6qa1MEMrQeXZl1VUt8BoXgQFBLq8fe/nsb6e+rL183eMjVkt8BxRt2PjIqqOCwACXELvKHeq5L5+T0KxGez6AQu1gnYOxQdGMruNQMz+mskDs638mopqoGrLYB2kO0i3AbWZoDLdH61FAjJzTqJGeatkLZJgu
 22Qy31WU
 PlUYMNRF/IKsVz8ZupEay6p3T20Ept9E4IfuWzy9fpxHbTr/3msF+Efkg+kmmHKgGVIbGr4+dkWaYHa1prsMxcGCLlxm8ySrsGybNm/GPn1aLymHIGFY0CK/b8Usyk0VTLEqgCn8o2+w+bIJVzaIpPqsIS8wNw6FkFAcwr0AV8oBJte3Pag1aKfyES2y1zDtVK38G4CBhA3QpIaoev5pPkmg5bu+f7/2ylp9uY7qjy8GZSXe3r/zlIO/aQyfVk8jmyvsfs8jzHB3lG2NmciSvihRlBpQuD+ybiquAWgsbGmbmYX7SfIcVcCs2VV609VdtOZCvfUoXqXy7BWSSAiizAIV102nlOFLTuxZEQF4FwGb1074=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/4/26 4:29 AM, Tejun Heo wrote:
> Hello,
> 
> On Thu, Sep 03, 2026 at 04:33:03PM +0800, Julian Sun wrote:
>> Foreign dirty flushing handles cases where a dirtied folio's memcg and
>> the memcg owning its inode wb differ.
>>
>> wbc_detach_inode() notes that "concurrent write sharing of an inode is
>> expected to be very rare". This expectation does not hold for bdev inodes.
>> A bdev inode and mapping are shared by buffered users of the block device,
>> while the inode has a single wb owner. On ext4, buffer-cache folios used
>> by metadata and journal I/O can therefore be charged to different memcgs
>> while sharing the same mapping. Normal bdev activity can thus produce
>> frequent folio/wb ownership mismatches.
>>
>> This was reproduced on cgroup v2 with the memory and I/O controllers
>> enabled, using ext4 on a loop device. jbd2 repeatedly generated
>> track_foreign_dirty events for bdev folios charged to unrelated memcgs.
>> When one of those memcgs entered dirty throttling, the resulting record led
>> to a flush_foreign event and queued writeback with reason=foreign_flush for
>> the bdev inode's root wb.
> 
> Was this reproduced from an actual workload with adverse effects? If so, can
> you please explain the workload and effects with concrete details?

Yes, this can be reproduced on many production machines. On one 
production machine, we observed 102 wb works with 
WB_REASON_FOREIGN_FLUSH as their reason, 101 of which belonged to the 
same wb. This wb was the owner of the bdev inode, and dirty pages were 
continuously being generated for it.

The logic here is that, Once a memcg has recorded the owner wb of a bdev 
inode as foreign, any task in that memcg that reaches the throttling 
path in balance_dirty_pages() may queue one WB_REASON_FOREIGN_FLUSH work 
item for each recently recorded foreign wb, up to four in total, without 
checking whether those target wbs caused the current dirty throttling.

On this machine, the total nr_pages of the foreign-flush works was 
630,681,285, or about 2.4 TiB, while the machine had only 400 GiB of 
memory. Although nr_pages does not represent the number of dirty pages 
that will ultimately be written back, the actual number of pages written 
back may still be very large because the corresponding wb was 
continuously accumulating dirty pages.

> 
>> Skip foreign dirty tracking when the folio mapping's host inode is on the
>> blockdev pseudo superblock. This prevents bdev-originated records from
>> triggering later foreign flushes.
> 
> If you do this, tho, that means now cgroups that accumulated a lot of
> metadata writes on ext4 and crunched for memory don't have a way to relieve
> the pressure outside of periodic or other lucky flushes. ie. I have a hard
> time judging whether this is net plus or not without learning more about how
> this patch came to be.

How about this approach? Before queuing a WB_REASON_FOREIGN_FLUSH work 
item, check the target wb and avoid queuing another one if it already 
has an unfinished WB_REASON_FOREIGN_FLUSH work item.

This approach can eliminate a large number of duplicate foreign flushes, 
but one issue remains: a memcg may dirty only a small number of pages in 
a bdev inode, and when that memcg enters dirty throttling, the 
throttling may be completely unrelated to the wb that owns the bdev 
inode, yet a foreign flush is still queued to that wb. This problem 
becomes more pronounced when the wb has a large number of dirty pages. 
Perhaps we should track the number of foreign pages in the memcg and 
avoid issuing a foreign flush when the number is below a certain 
percentage?

> 
> Thanks.
> 

Thanks,
-- 
Julian Sun <sunjunchao@bytedance.com>


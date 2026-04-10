Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0B690E99059
	for <linux-mm@archiver.kernel.org>; Fri, 10 Apr 2026 09:05:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5F2BF6B0005; Fri, 10 Apr 2026 05:05:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5A36E6B0089; Fri, 10 Apr 2026 05:05:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 492766B008A; Fri, 10 Apr 2026 05:05:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 387CB6B0005
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 05:05:24 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id CD45A58EFB
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 09:05:23 +0000 (UTC)
X-FDA: 84642062526.24.C5653C9
Received: from mail-wr1-f45.google.com (mail-wr1-f45.google.com [209.85.221.45])
	by imf06.hostedemail.com (Postfix) with ESMTP id 9ABED180003
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 09:05:21 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=YH9B8pi2;
	spf=pass (imf06.hostedemail.com: domain of mhocko@suse.com designates 209.85.221.45 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=YH9B8pi2;
	spf=pass (imf06.hostedemail.com: domain of mhocko@suse.com designates 209.85.221.45 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775811921; a=rsa-sha256;
	cv=none;
	b=QUpCBLAHE/X9XIQpy0AesaAOanVD9AsgZjzpEI+p7P3LEADn/VkIRy855TIiB3OXqkYzIg
	m+AV/8yyp9dhjFhG5e/egUnOOUkr+j9LD7uDKq7nmK/O03SGfI2RQ/YW7ggiWnHjBZWjRV
	c9zZTtS/ETHZiDeabXLhtihN4sCu4sU=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775811921;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8XEvKQiPqvwQxNRmtSVZKQ+GJktAIkI23sY2qooZ+Ow=;
	b=dcV7VuGYlMEOS2SiHRHnwicd9bVXZ8BWijSld09dwd7bLWnxc5RVHXItKSXaAwXjMvEAKc
	Q6cr+sIaJbr/4m0GVMpnwO2LAX/EFL1Ec4FCDe7cu6ijLeELPqj0mWsrAixvYbCmMWIqFy
	ur2ucp5f2Fa7Zi6GokwXwdu7UrT9EXU=
Received: by mail-wr1-f45.google.com with SMTP id ffacd0b85a97d-43cff5dafc3so1321027f8f.1
        for <linux-mm@kvack.org>; Fri, 10 Apr 2026 02:05:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1775811920; x=1776416720; darn=kvack.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=8XEvKQiPqvwQxNRmtSVZKQ+GJktAIkI23sY2qooZ+Ow=;
        b=YH9B8pi2oDtVT/K9WJPGXNdMsymD9SAuLtnjDPCt3VHOgA81L6vWWAqCA5xp6D3JI8
         vKeyWIa6SlrC0x34D3ifIvvg+VZspWUTiTT05xLMzi4ENBTnS95RH4HLhtjnhxfJxzTx
         jpdHOMxx2/nj21YHD5mdIMfym9d0/LoElkHrziwPLiaW793K9HM0pTRS2eUn1go0vBUg
         f5ovfqPfngQy0sTCVKi7PuDWC6dlt1ZZiibOibcAyJiS6Fq7ugVWYAVjQxojg2r7dWM2
         7xEmzJSywQXibjb0aIdQPKBf522OvaBnJ94uawL5vrMiD3MBdSW6/REvje+QNNYn97ID
         wPKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775811920; x=1776416720;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=8XEvKQiPqvwQxNRmtSVZKQ+GJktAIkI23sY2qooZ+Ow=;
        b=bJfNbHBFvTpYJUFBHVmJDbI2xeOYVaZHCMsnO1CK+vFgauyu/E24rEDvLEEj8y6bkC
         LZ+1FE9KERsjM7UaGmEhU5LIth6BUmX2YXiSCSWql/ZlOcv7bC1INXhBXJOBwvPNn+5V
         9XM4qvOEXL21EB6BrtWs2haegtPExdW+vZPLwgSQfz0Fej6nq2MVdlFVeL2qw9NyJRAY
         s+vE1MZCT9vtss3n40hAowl1z20u/l0dPrlBqEzqjrWB6mqptV/Pi18cbqmJx6RDu3MY
         jFA9RaUaB2kBS4Jke/9XWqiKszXITdOminqo9s3v+sxWYHFyRxQBGhwwsnUiTDLDVpwY
         dhBA==
X-Forwarded-Encrypted: i=1; AJvYcCXrxubT4xZYpVy30zn9ZciZ1ZkMxet9MgfQGwb8BVjnPJOUJ9kJeQjBaM5GCQu2L8upqwPt7Ab5wg==@kvack.org
X-Gm-Message-State: AOJu0Yw+JR8SqzqRPBUlu0AzpouGUHG19CHVtcPDuOwdgm9sQppsJUuX
	vyT5vXdfPBF+KgclBEsu/u0Ia9i4net/HU+D6RmX1swVM6KoTBEiMkNonbWQ3XIS/bE=
X-Gm-Gg: AeBDietLI2sSyWp57YbGFUBpgTtsKFYr5xWm+oZ2I8Y5zOBNRUo3428jsLEuNUCgy+b
	ygTJ0r6ZAUQcOg/dkhkhjTS7frRyNvTyT/HN02/Hb5NbkvBTwHUclgthJwUiJuR0kWWm53rV0DT
	6sSlNz4z71qEWcySN4oKJLnHGvL8Bqb0lYB9GW17andqzXrVTWk51nNXkWeuc65+1uwaCHHdwOR
	XZlROuKCN7vyYKZIxuf462iK2RhE1Fx5F7Bf9PAJONh2TR/I+xwqmYIKvNdJfQkjmhK9oxw0HXx
	iBHy/IdGybhtcwBFylXn7l2lz1LhPcnHRV/DWpYgD1/xAEIajGT3shXI0sxezNDsUprZraOwVL3
	iT32zi16v9S6JNmCTS+qeoXI1BvbL+7G1xlQJlMlAmDnmSSxf7Jn/PVr7c7gV/8rRjkKR+xAAc3
	7bnwAWuGarx7aa6LN4czC9MdtrqkuiiGseVg==
X-Received: by 2002:a05:6000:268a:b0:43d:4daa:7a89 with SMTP id ffacd0b85a97d-43d642a50a2mr3222376f8f.19.1775811919772;
        Fri, 10 Apr 2026 02:05:19 -0700 (PDT)
Received: from localhost (109-81-92-28.rct.o2.cz. [109.81.92.28])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-43d63de2a53sm6028261f8f.5.2026.04.10.02.05.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Apr 2026 02:05:19 -0700 (PDT)
Date: Fri, 10 Apr 2026 11:05:18 +0200
From: Michal Hocko <mhocko@suse.com>
To: Breno Leitao <leitao@debian.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Christoph Lameter <cl@linux.com>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, kas@kernel.org,
	shakeel.butt@linux.dev, usama.arif@linux.dev, kernel-team@meta.com
Subject: Re: [PATCH v2] mm/vmstat: fix vmstat_shepherd double-scheduling
 vmstat_update
Message-ID: <adi9TtIbWOoQPpBp@tiehlicka>
References: <20260409-vmstat-v2-1-e9d9a6db08ad@debian.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260409-vmstat-v2-1-e9d9a6db08ad@debian.org>
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 9ABED180003
X-Stat-Signature: qdqjnobnxuwrshei5dm7srwykehqe1np
X-Rspam-User: 
X-HE-Tag: 1775811921-810152
X-HE-Meta: U2FsdGVkX19MnVlvpucPxMktxcL5tNkhBd+m6CjNrGjccaY+xA74ytfDZpT2PVk3MiRXn8MN99ePjEgpZe9ouv+VPsnkxn3GB6VajPjmtHQtYfIj6Sdd22pvsoLyl0/M8gEMFSMR6ZTpUUd3wJBDCkNMZzpMRF08PcM7uXO8kqna5LUR79B24As+cAAum7mD24Gns1L/JW4e1gBgXwG4X1JlviAdIj3AS0VHsFTXsSmadSlHMMws3dxEH5v/weeEmaSRGjYlCY+mYLgYs73GH3jqXX14nogmjtkyDhlLR2/qmqh4GIv99Kq9XksSUaR9Dk3sKaKYzbMyF1oeq0AbS8WG5z9KzlFWww04r0YabpVSF3UMij2fh7INEn+ec25gJ1xNnDWJb4MmrM6no57+89AQkD0X4vOasL1JqslbePYYvSRz3KILTmEMAZ6akBtHNg56gzkuZw6E4jTXRUzRT8A4mRKq/eLAY0A6WLep0a+W7MVewImdB6oWGkCjdLYebQmP1VP/5bKDt10DXC05TtWS7hCcbUXQioiugT4no+qOY6EJQGAr4bbGSOlDboYkGeelhocnXfzFWMK7RJfNw6hICO4YF9LCCSYbZVPe5gveq7+DpkZcOeI50QyM8TBRecIg6Bp7o/njtGGpZk9GzIt3/enHGDLfoXoS0PcSR1LIRFEk5b0hm1qaq7Yv0MdY3im1HWmJRxus1W3Nq8nbYMGYp/pazzT/TAFAIImMj/XzCG5F/cnveUua5V+p37rjTC1iMDQqiY3wxEmeA/BvUA6H6YkEHBgeFdyqeIo1puuvqYh/j+uD3w5n3L/n466YS2GdNwL6jT6y3ZQCTyUWN/FJCncv+klHJqOx/0ZnzGgdEL1gh29c+6yY3crP0o465WJr+X09wdD8Jv6gCgJkReb2lTcXl/25DjVPB8OpOV648usLw5NyXIvw64fBQZyMTw0gQ213dowIRW4VCNG
 Tt7gRty6
 J+FSy9bXneTVr8w23L2leNxVRVTrlyz/Q+DTKthyYDZb5o1JFDAb/ucjrwxWygbvekHffAwITleDCE5jBN3Si5fxMqbzrA+xgFCsipIfWXVWtykU1+giznntmkKo5DUA0bO9VA8muPwgPkx/R8zsraMd1Xd4Hka/luVeOahal3qrXXhqNBe30kbEx/lHa595xo0WkLEXyxueZQXmvhSmEUJzFJMw7Zrsfw+H9eYCCsul8/hHiI4rvao2mKRm/v0fL1L9/DiCdqGQD9Km1VjMmvs8VGj2stpKHYEsdJnSgtzrYMhu60C4m8kMOf8VOrMOqI+MM4WuEautwtT2Lvkldlzl1q/X2oVG3YCh9WwnX1mYegETAglnrKW/ae5oSlYO0cQZmojCPAPYmSTV6buhgYmQ0iOzfCOuCOZi6MOnAw3jGbP4//dGXi2E28cOv4a/rDA5gCLKV7Hny857V38zn0/rUCb8YqAD5TzqZMqAbqrmzdTJjXlIEgALbPNHEON6NXjKVMvarR3IzDZXSMzJ3IfR8CD8xr9mLxAHFoQUDaVOGfMTHoQaPJpbQo/4jZt8Vp/ThBN09NEQD1xSZZLdGIq3BW2MdUgTRZGLumrRCiSVg3eA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu 09-04-26 05:26:36, Breno Leitao wrote:
> vmstat_shepherd uses delayed_work_pending() to check whether
> vmstat_update is already scheduled for a given CPU before queuing it.
> However, delayed_work_pending() only tests WORK_STRUCT_PENDING_BIT,
> which is cleared the moment a worker thread picks up the work to
> execute it.
> 
> This means that while vmstat_update is actively running on a CPU,
> delayed_work_pending() returns false. If need_update() also returns
> true at that point (per-cpu counters not yet zeroed mid-flush), the
> shepherd queues a second invocation with delay=0, causing vmstat_update
> to run again immediately after finishing.
> 
> On a 72-CPU system this race is readily observable: before the fix,
> many CPUs show invocation gaps well below 500 jiffies (the minimum
> round_jiffies_relative() can produce), with the most extreme cases
> reaching 0 jiffies—vmstat_update called twice within the same jiffy.
> 
> Fix this by replacing delayed_work_pending() with work_busy(), which
> returns non-zero for both WORK_BUSY_PENDING (timer armed or work
> queued) and WORK_BUSY_RUNNING (work currently executing). The shepherd
> now correctly skips a CPU in all busy states.
> 
> After the fix, all sub-jiffy and most sub-100-jiffie gaps disappear.
> The remaining early invocations have gaps in the 700–999 jiffie range,
> attributable to round_jiffies_relative() aligning to a nearer
> jiffie-second boundary rather than to this race.
> 
> Each spurious vmstat_update invocation has a measurable side effect:
> refresh_cpu_vm_stats() calls decay_pcp_high() for every zone, which
> drains idle per-CPU pages back to the buddy allocator via
> free_pcppages_bulk(), taking the zone spinlock each time. Eliminating
> the double-scheduling therefore reduces zone lock contention directly.
> On a 72-CPU stress-ng workload measured with perf lock contention:
> 
>   free_pcppages_bulk contention count:  ~55% reduction
>   free_pcppages_bulk total wait time:   ~57% reduction
>   free_pcppages_bulk max wait time:     ~47% reduction
> 
> Note: work_busy() is inherently racy—between the check and the
> subsequent queue_delayed_work_on() call, vmstat_update can finish
> execution, leaving the work neither pending nor running. In that
> narrow window the shepherd can still queue a second invocation.
> After the fix, this residual race is rare and produces only occasional
> small gaps, a significant improvement over the systematic
> double-scheduling seen with delayed_work_pending().
> 
> Fixes: 7b8da4c7f07774 ("vmstat: get rid of the ugly cpu_stat_off variable")
> Signed-off-by: Breno Leitao <leitao@debian.org>
> Reviewed-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>

I like this much better. Thanks for digging deeper into this.

Acked-by: Michal Hocko <mhocko@suse.com>

> ---
> Changes in v2:
> - Instead of changing the timings, do not double-schedule.
> - Link to v1: https://patch.msgid.link/20260401-vmstat-v1-1-b68ce4a35055@debian.org
> ---
>  mm/vmstat.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/mm/vmstat.c b/mm/vmstat.c
> index 2370c6fb1fcd6..cc5fdc0d0f298 100644
> --- a/mm/vmstat.c
> +++ b/mm/vmstat.c
> @@ -2139,7 +2139,7 @@ static void vmstat_shepherd(struct work_struct *w)
>  			if (cpu_is_isolated(cpu))
>  				continue;
>  
> -			if (!delayed_work_pending(dw) && need_update(cpu))
> +			if (!work_busy(&dw->work) && need_update(cpu))
>  				queue_delayed_work_on(cpu, mm_percpu_wq, dw, 0);
>  		}
>  
> 
> ---
> base-commit: cf7c3c02fdd0dfccf4d6611714273dcb538af2cb
> change-id: 20260401-vmstat-048e0feaf344
> 
> Best regards,
> --  
> Breno Leitao <leitao@debian.org>
> 

-- 
Michal Hocko
SUSE Labs


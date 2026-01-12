Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2CFB4CF45CD
	for <linux-mm@archiver.kernel.org>; Mon, 12 Jan 2026 21:29:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 505F06B0098; Mon, 12 Jan 2026 16:29:19 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4B2F96B0099; Mon, 12 Jan 2026 16:29:19 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 394C06B009B; Mon, 12 Jan 2026 16:29:19 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 258F66B0098
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 16:29:19 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id C5C75C46D5
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 21:29:18 +0000 (UTC)
X-FDA: 84324602796.19.453CC15
Received: from out-183.mta0.migadu.com (out-183.mta0.migadu.com [91.218.175.183])
	by imf12.hostedemail.com (Postfix) with ESMTP id 4C7434000C
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 21:29:15 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=X+ggap4u;
	spf=pass (imf12.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.183 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768253357;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6jQat8IkmsEcR4ZTpT5To4a7MP9MPiNeCEisUVNEbnA=;
	b=j9CKYPvVve91WlzfEBfmDsNT9tJKuKW2+2WJZT761OMGysR03qFNyJibuXNJxgx93GlyDv
	533VETRY5RGynFwdiWnVvpjnQ+C4IFZG0Ui+urzLRn+TIUwlG2eTJ7HTeOsISRSILjUnnb
	EbVyLw7G17zjRH2HUQwmY4ZY4O08ItE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768253357; a=rsa-sha256;
	cv=none;
	b=eO9uTbQVNchEpfnGIRC7RFyvFVCqqgs9ourrzykb6a01gmOSc3NzOENLFmyjlFKbu6YDPG
	JGFlfTI0lphTGoVAfipxNUgKQZvbpngyTWRIFS1LgttaNd1qbelV2JxXg2phEef/sqEP0l
	278UScNo+f7OiJTkRnv1POuOE6NO5Tg=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=X+ggap4u;
	spf=pass (imf12.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.183 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Date: Mon, 12 Jan 2026 13:29:06 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1768253352;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=6jQat8IkmsEcR4ZTpT5To4a7MP9MPiNeCEisUVNEbnA=;
	b=X+ggap4uhp3b11bHNhPS5cl/8HT9sq9NFlDASsco3Ep03ZXtRHZjlNcZ1GnQbe5gkEwV08
	mR9O05Z2ZLNs3sgmoerDB650MM0E5JE4MJvczhYREMqoMXd5N9XSrTMJMjc7pcOgt8vv+6
	X4eTaYig+mYi/xIQ690QCUvicFnUzKM=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Jiayuan Chen <jiayuan.chen@linux.dev>
Cc: Michal Hocko <mhocko@suse.com>, linux-mm@kvack.org, 
	Jiayuan Chen <jiayuan.chen@shopee.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, David Hildenbrand <david@kernel.org>, 
	Qi Zheng <zhengqi.arch@bytedance.com>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] mm/vmscan: mitigate spurious kswapd_failures reset
 from direct reclaim
Message-ID: <langyedbbu7b4zkz5o7yy7m7bdlusoa3zwsjbgrqt2p7ou37qm@fi7rovfl5gfz>
References: <20251226080042.291657-1-jiayuan.chen@linux.dev>
 <gxrh27cynibsmexsb6gahs2gd2wkicoiumzfyljbxt5mdleium@5rmx6bljxj3c>
 <61b4f3ba49016e68e8d6bfe6543150a7de0bac79@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <61b4f3ba49016e68e8d6bfe6543150a7de0bac79@linux.dev>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 4C7434000C
X-Rspam-User: 
X-Stat-Signature: ekea7jmagc8ktryth6enowxw77yzc4rd
X-HE-Tag: 1768253355-473048
X-HE-Meta: U2FsdGVkX19Orii1fh3Jeu6KwMvJLkfSqJwI82HQtTlnlyQAJCBIr9peMNcFfGBebiQX7K4tKOAyD8oRU8ddfhilFxL0IqOdzmLlCObit+W7X1Xla2WlbvLGIYkipJh/ZREGSfvbFgxEYXHrfr9UdTFXpyPPrF6lRTCw7mPyDVNRyydA0ehMWF0ji83H4SaZt28M14Pesc3Tg0HxkdWY3aebZ10QcZ6l8n88Y5fDXFFLCx+istj43gegLcOzpR6zN3unSXdXRn/cRAsMIferZgIyl7Dttq23dfRV9CubS8ERvPb5bZUxUtWVvSvGRp0NlL5aOjRTRoOm02jVLtPoF+FnqJcbnrrDIfdCNMeITGhYg1NaQod1evBkLogv7pNi4cI894fzpvirj71P0A3bmDqVnKQdntkYPKceG7XzR116WNH7HVMepdp/DQ9vw0g0f74LAj3QQjnS/Jci8FyfLA9A9SCB4XtSegjuOuhVnU2XgTCvLCaoN65clEERGPFSpGz/JAIuKfhOeOa8Tycr9glQmZAfv+ECjPonj+Xofr8BO+/tQDmBT/GnjrWyzZK8ewPzlzrhmySDzXmSYkPtVYcA8yStRCeZ7hoGkuuzXELdi7zkciLcghik/46AaZxr+TAsWGQ5KNv+53OUD9XoqffXFY5uJvNr1VIAM+SSlrn6eGpJW3G+w6jAqiFm7bd40CbGkqBcbctTT9iMHk9F0RdcRpSvWLaNLBe/GGFT3paiEmx7oHVMtAbvyY/xqWG3PU0HpXqDSA6sBJOS5tV2AgtiuyLtIK4sbSshqUJLzgyuhc6EbfpkS7vfgV+YHukInwHxBO0rNe158kiFXVVQrdWfhVrnSD/ObppuwJE6YTRU/djOUoM+fLzhNk/Tdn4juSpyUqTQoCFKd4JH7pGD05QuQVZlV2aJTSgX8gM91E7r/I0MxC53ajaxsB9Wgvh0ciO7r2umy9k4tElJssr
 NyEgVMr/
 3HhhowibkauFio1HbZoErE2NlLilvHnQXeMUgr9+/yAl4PxRWk923ZdXS4ZQ4FthdACJPfhouQUFfHAYKMl+Qfl9tLYLj4spW/crAxHtvFOaJag3TEVqYA/tqZg7eZY2YgMdgufCJbq3AezJP4cl83RsMTtxD5Rl2JhFwqCMnHbKPoJ1bPG1ghzsCCleiO+el+rxeHfIXCx0TlhEx2TYIgCsA8q5u0WyoFEWgwpUfiDS/6lB0mIxk5xvrl41lrUPzsAw/
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Jiayuan,

Sorry for late reply. Let me respond in-place below.

On Wed, Jan 07, 2026 at 11:39:36AM +0000, Jiayuan Chen wrote:
[...]
> 
> Hi Shakeel,
> 
> Thanks for the feedback.
> 
> To be honest, the issue is difficult to reproduce because the boundary conditions are quite complex.
> We also haven't deployed this patch in production yet. I discovered the relationship between
> kswapd_failures and direct reclaim through the following bpftrace script:
> 
> '''bash
> 
> bpftrace -e '
> #include <linux/mmzone.h>
> #include <linux/shrinker.h>
> kprobe:balance_pgdat {
> 	$pgdat = (struct pglist_data *)arg0;
> 	if ($pgdat->kswapd_failures > 0) {
> 		printf("[node %d] [%lu] kswapd end, kswapd_failures %d\n", $pgdat->node_id, jiffies, $pgdat->kswapd_failures);
> 	}
> }
> tracepoint:vmscan:mm_vmscan_direct_reclaim_end {
> 	printf("[cpu %d] [%ul] reset kswapd_failures %d \n", cpu, jiffies, args.nr_reclaimed)
> }
> '
> 
> '''
> 
> The trace results showed that when kswapd_failures reaches 15, continuous direct reclaim keeps
> resetting it to 0. This was accompanied by a flood of kswapd_failures log entries, and shortly
> after, we observed massive refaults occurring.
> (Note that I can only observe up to 15 in the trace due to a kprobe limitation:
> the kprobe on balance_pgdat fires at function entry, but kswapd_failures is incremented to 16 only
> when balance_pgdat fails to reclaim any pages - at which point kswapd goes to sleep and there's no
> suitable hook point to capture it.)
> 
> 
> Before I send v3, I'd like to continue the discussion to make sure we're aligned on the approach:
> 
>     Do you think the bpftrace evidence above is sufficient?

Mainly I want to see if the patch is contributing positively or
negatively in the situation you are seeing in your production. Overall I
think Michal and I are on the same page that the patch is net positive
but the testing in production would eliminate the concerns completely.
Anyways we can proceed with the patch and we can always change in future
if this does not work. Please go ahead with v3 with additional
explanation.

> 
> 
> If you and Michal are okay with the current approach, I'll prepare v3 with mote detailed comments addressed.
> 
> By the way, this tracing limitation makes me wonder: would it be appropriate to add two tracepoints for
> kswapd_failures? One for when kswapd_failures reaches MAX_RECLAIM_RETRIES (16), and another for when it
> gets reset to 0. Currently, the only way to detect this is by polling node_unreclaimable from /proc/zoneinfo,
> but the sampling interval is usually too coarse to catch these events.

tracepoints are cheap and I am all for more observability. Go ahead and
propose the tracepoints which you see fit.


Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B4BEECCFA13
	for <linux-mm@archiver.kernel.org>; Tue, 11 Nov 2025 02:23:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 043A68E0003; Mon, 10 Nov 2025 21:23:34 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 01DFB8E0002; Mon, 10 Nov 2025 21:23:33 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E9C098E0003; Mon, 10 Nov 2025 21:23:33 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id D91D38E0002
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 21:23:33 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 7FFC7588C3
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 02:23:33 +0000 (UTC)
X-FDA: 84096729906.16.A41F593
Received: from out-181.mta1.migadu.com (out-181.mta1.migadu.com [95.215.58.181])
	by imf05.hostedemail.com (Postfix) with ESMTP id 81CF2100010
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 02:23:31 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=KUnq6Eks;
	spf=pass (imf05.hostedemail.com: domain of qi.zheng@linux.dev designates 95.215.58.181 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762827812;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=q2QEY03Zb79SqJtXbf2zF+i57eoPzcpd2R1ZoSjupFo=;
	b=BW+N4fsdujpQ/XNzIB+iM52D//y8xrg+HVz4+2GKeVGO1oSOBSvtfI0nG+HfzlJsOQ8v8O
	jHfa5xbYXygHtSjEM6dtsvDcLUyI+o4B9fSFY8Wbx+W5eYmeo/kFKdm+eEGWSQSLrsCr14
	jHpNGid9Li1q9RoPQYHlarsLulPAds8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762827812; a=rsa-sha256;
	cv=none;
	b=fZxw07OxJhkSHJR18OGfWwSTKF1a7wXRc7ZxHgNTwldthTEEXLoxNCHzAZGgC/P6j++er3
	A+v67MzFrYxyiKUxWVOa3afxuQpwV/k8S/YXM62+y3kYslQaQ/jRoHeQyKX9ufcfgNM5vA
	StxMK9i+ZbOQwxd3jmRK73EtukqiRUY=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=KUnq6Eks;
	spf=pass (imf05.hostedemail.com: domain of qi.zheng@linux.dev designates 95.215.58.181 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Message-ID: <24969292-7543-456f-8b80-09c4521507e2@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1762827809;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=q2QEY03Zb79SqJtXbf2zF+i57eoPzcpd2R1ZoSjupFo=;
	b=KUnq6Eks5+xX4BoI5CcsTd5M8ayBvzEvJtBfpTPkht0rd2IUTHnBDtE0SJbtanxFBSLrwJ
	1kF+HodCXj9w701YF+pz1FWfIW9/YROvpD63GjFT3E+sw/148pxBfealvVfcozJ0SmQHjT
	svDRow3q91F7HoMTCc7SItb+Aeybl6c=
Date: Tue, 11 Nov 2025 10:23:15 +0800
MIME-Version: 1.0
Subject: Re: [PATCH 0/4] memcg: cleanup the memcg stats interfaces
To: Harry Yoo <harry.yoo@oracle.com>, Shakeel Butt <shakeel.butt@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Muchun Song <muchun.song@linux.dev>, Vlastimil Babka <vbabka@suse.cz>,
 linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org,
 Meta kernel team <kernel-team@meta.com>
References: <20251110232008.1352063-1-shakeel.butt@linux.dev>
 <aRKKfdN3B68wxFvN@hyeyoo>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Qi Zheng <qi.zheng@linux.dev>
In-Reply-To: <aRKKfdN3B68wxFvN@hyeyoo>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 81CF2100010
X-Stat-Signature: t74mwtbq6c95cs3iyyuuyerfwwxf8was
X-Rspam-User: 
X-HE-Tag: 1762827811-127347
X-HE-Meta: U2FsdGVkX19YCw/MBsjuxS7usCUBdE8dO6IWArsG2v40zXIWlOgWIqz0GpStAlmj4psFZTwkA6pi4ytSMo9eMeCinSuNvQxandcxxyWRhBlqgeexL43ojkWXyn82Zo1QEuv+UirOq2qUUokB2G5YZmvvmLfoDuswsUIAqNBnMtvvjJdfYxRzy1QfYw+NbG2DoWGjF6w8RFgS3aC/YFBdNbleVfxX9LQIksRKM7lJ9ZdOUfX5YuGJmE/iinhXPIw3aEHLK8d/Ahpz1UNtgulSQJ51eDAZwRETXxY+C4FTXc9H7po9kLMXOkkFaIjSCXDJddi1JRljL8b323IXPQJhZcGyol4kn3lUh8ARH7Ki8+aqGz8fXwFg7WtKL7xbj9LSN3VE1LTAMvR2n55KQG+9scdVWGqqyxxlwxac+EMWqOYgqxWbppbl/lyPuiYW/U/yVIaOCeVFk89MA52KjiGeve6dyQX7xKEP6KaRnhBBut49hAnRghex7ULitl9Uj58p8Mpd1H49xg3+54zstheIA5L3/1O6Oas+Qxh2sdIIgjY5QfmF2nl8S/F9rsvObddGqODZcCGG2NjGCwS0lAlKbtJFMs2/CaVuNvVYo1Yui7mkpymSZILTTBaUC2UeVz1MB/eY9iQLSjWjhrf51qRX0MTKaZJ4HjThRbYoAIH6pGHetvs79yhyu6lq5cvNv0yG2QW8fRWgvOj68ATnkjiOnb0Pv9Sw2wGe2xvUQnzBQtQESfE/s4Xw/J0xD47GncvhvqQs826j69+Vhu754e/KRscoVE0rQWaRGsMM9bBfvPuLs7t8GkClxu4NhC0OCwpARkgbJSqV08fW3MESfcirRngTuqd5wcHUk56cfhrOpOc5RNAEdnQxokERzLJVYfHLOoCqWPfz0q6Kz6zjGkqpVCO69NTjKO8JSb43qzxKGa9i1tq/BuLBVBUmgYh444RWKyDoQ93IsfKClXga/9L
 Tq1ZzWP5
 zpZZlAj4/2MvhQhvrxdCRVa8puVt+U3nw80LIvlGwEiG/iuAC5041R+JrvJaGdTvhQJ8PTFtcWsW0FwCrfn05QKUpME880l8VfpluhaZ2Hg1nhUW+zgASYdrlOkh1XmXzC/S2KVSluD1Q++VCvxeYU/50rA4Egk+H/4M6hLamfCY60lK72EvWKXNi9hhvsutHkO+Y5Sq+u5yD6bAu4Qk9pdeaopRVPcWn0YpK0drA0Upvawo=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi,

On 11/11/25 8:59 AM, Harry Yoo wrote:
> On Mon, Nov 10, 2025 at 03:20:04PM -0800, Shakeel Butt wrote:
>> The memcg stats are safe against irq (and nmi) context and thus does not
>> require disabling irqs. However for some stats which are also maintained
>> at node level, it is using irq unsafe interface and thus requiring the
>> users to still disables irqs or use interfaces which explicitly disables
>> irqs. Let's move memcg code to use irq safe node level stats function
>> which is already optimized for architectures with HAVE_CMPXCHG_LOCAL
>> (all major ones), so there will not be any performance penalty for its
>> usage.

Good job. Thanks!

> 
> Are you or Qi planning a follow-up that converts spin_lock_irq() to
> spin_lock() in places where they disabled IRQs was just to update vmstat?

Perhaps this change could be implemented together in [PATCH 1/4]?

Of course, it's also reasonable to make it a separate patch. If we
choose this method, I’m fine with either me or Shakeel doing it.

> 
> Qi's zombie memcg series will depends on that work I guess..

Yes, and there are other places that also need to be converted, such as
__folio_migrate_mapping().

Thanks,
Qi

> 



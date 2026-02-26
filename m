Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 502BEEA4E22
	for <linux-mm@archiver.kernel.org>; Mon,  2 Mar 2026 15:53:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DB0D86B0096; Mon,  2 Mar 2026 10:53:34 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D3B8D6B0099; Mon,  2 Mar 2026 10:53:34 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B94D06B009B; Mon,  2 Mar 2026 10:53:34 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 999CC6B0096
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 10:53:34 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 5F9691401BD
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 15:53:34 +0000 (UTC)
X-FDA: 84501567948.12.675ACE1
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf07.hostedemail.com (Postfix) with ESMTP id 6A0624000A
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 15:53:32 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=XZeLSDdS;
	spf=pass (imf07.hostedemail.com: domain of mtosatti@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mtosatti@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772466812;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dLbuFPWOWGHaHFWL2ILwbNpXfhNKBfkyvba0iiQAlY0=;
	b=scoHIUYKhtKu41Hw9pTXfQ/1Y9hF7UaoFE0Wl8QxntTG2DqrUBYZ9m2a4USkqmeNqh59UF
	nL8a8w3TzvUtLrLlF4HnyXDgyZdAAEv5jg0pUlMlH1caoTkvodfdIpQvdH+LpA9Uk3qT13
	l64LsSQO4oSGUjL24/zWrv2AttlAj80=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=XZeLSDdS;
	spf=pass (imf07.hostedemail.com: domain of mtosatti@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mtosatti@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772466812; a=rsa-sha256;
	cv=none;
	b=aegvG27bPzBMe3HeDAK2bV6HyPsd9oYI4hnNfOdejvbPGQsxkr4s4nZQmZuLOBqLhHPuKu
	NHxXtodpllZbhsqm2H2sznbAkTUw3x5SnzqWrgC7DyxgZbP8vrMXft0iosTIy+S2SL0PaU
	INgIs/KKU5TBR+hYRjpL/jHxWFJYono=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1772466811;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=dLbuFPWOWGHaHFWL2ILwbNpXfhNKBfkyvba0iiQAlY0=;
	b=XZeLSDdSWtRQSpIuotJ/0D9qV4f1mY6f2QdXqDbns0rZj/rg8VVOBWGCMsHHjvieowNgm9
	t6TmCf7CeYo6+Y4LQM/W16lSzxR3jPlLRgwWQokMHaYRCtzioj5+uhGJZauqG5dvtWoIPQ
	L32pYMSvmA2+4j5uaOayfHNnGc9gz34=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-650-h8wrkvvyNiGreQWPAh48UQ-1; Mon,
 02 Mar 2026 10:53:25 -0500
X-MC-Unique: h8wrkvvyNiGreQWPAh48UQ-1
X-Mimecast-MFC-AGG-ID: h8wrkvvyNiGreQWPAh48UQ_1772466802
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 7682819560A2;
	Mon,  2 Mar 2026 15:53:22 +0000 (UTC)
Received: from tpad.localdomain (unknown [10.96.133.6])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id F3D2A1800592;
	Mon,  2 Mar 2026 15:53:20 +0000 (UTC)
Received: by tpad.localdomain (Postfix, from userid 1000)
	id C42E64014FBC7; Thu, 26 Feb 2026 12:49:18 -0300 (-03)
Date: Thu, 26 Feb 2026 12:49:18 -0300
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Leonardo Bras <leobras.c@gmail.com>
Cc: linux-kernel@vger.kernel.org, cgroups@vger.kernel.org,
	linux-mm@kvack.org, Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	Christoph Lameter <cl@linux.com>, Pekka Enberg <penberg@kernel.org>,
	David Rientjes <rientjes@google.com>,
	Joonsoo Kim <iamjoonsoo.kim@lge.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Hyeonggon Yoo <42.hyeyoo@gmail.com>,
	Leonardo Bras <leobras@redhat.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Waiman Long <longman@redhat.com>, Boqun Feng <boqun.feng@gmail.com>
Subject: Re: [PATCH 3/4] swap: apply new queue_percpu_work_on() interface
Message-ID: <aaBrfg0ozWK4moxC@tpad>
References: <20260206143430.021026873@redhat.com>
 <20260206143741.589656953@redhat.com>
 <aYaQFM9sBbauUn5c@WindFlash>
MIME-Version: 1.0
In-Reply-To: <aYaQFM9sBbauUn5c@WindFlash>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111
X-Mimecast-MFC-PROC-ID: jirs7lx3bPc33FAxAAQElJfX07Ac1IZUttRfaL0sBSA_1772466802
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspam-User: 
X-Rspamd-Queue-Id: 6A0624000A
X-Rspamd-Server: rspam08
X-Stat-Signature: wucpaibgoue4fqgnsjn1cobb4gj7oy4c
X-HE-Tag: 1772466812-470908
X-HE-Meta: U2FsdGVkX1/HmLxoKgdCN2KoHZIS3Sl6Dnq+yIZPDAr6sRAykBhGRDdX3w19AUL8J9H9EUO3ZVZ0S6Vzb7e6f5Dg4ZQKOweP3OzxsVHy5A15TwQYQEqAA+6Vfr+iNmSh3wgy5I2Qzlek2YZyot+3x/sMpvDcg8jhpMxXer+OBcJ88HfdZvmzC5s16PLSz8jDv8YEclvrUab1V12dfdxg1ZBha9hNi8yrGbq2PD3BjKrninhLT+pEo52VjOkTpyAKBQEyXaF/nVVMwwanTwtIeKjxRBFWr9cJwLimmMbq98dxSU4Ox2MLF1tbX2dN/hqVLRKdfbqK2F7FXAqa6KsQh8ryde0lsvYrBpxFAjritb9HcsE2WU8ZEySbLrUx3JPqXfauwuqMbpZ7r9B9vrUG/uOmGNaYPnC35Tiv8/U2dV+IcTObTG4Ri1k3ecZZBI7bHSSfulHLRaqAKHAb0wPBer6o7gxa3HA9pt1cKwWuU91ksQjVBzClFcSjhgSOrZCvDqNtBr2OKa1Z6gq3sYTovth63WLZoBeYoYKqa5Eq37oKcD78/b/g7k4sM9awSmkh/71IvIDbycbt9y8cEwD0gkfaAV6q/KTKJK5IMHxM5lLpz66hFY+fRRtDRDESwyTYdNJy/VqMDpCI1pPMc0dXLnmDlb2AUpLxWoE9MGJ23jeU1qFFEhijLlUZayyPnrlaJpWVwNbhypY05maZ95DK2IyeOpv1Pe09rr8wsXx1pOBFnGmgCYjfIa2rfJXK+4ik4L0wRhVYLCd1jw3yVn5GKcowhgK8ziwlytne33BVbhoGQr+WlOAO52qkJm4By7q09Y6TW38wT6D8zGALLxWbxN5TymqAxbSMVdU8HhpNQBIkkXr9P9/msG0FKvu+UvFebDibBvrBuZQCRqb8tZDSKbksceOLQVWkehXHH0QYN1NjUJbC8EnW+Rw+eyv74hEytPJSuPK45ZaIN4svIBz
 dWtFJmWY
 mT1QrPU5rsBZIw92LkGNOvBWbW1aD+Hrk2Ut2iEkEJ9l1g4+OYAO6FeMHp+DdPCR6qNDoXxCp4XOL3NuWWI1/nu/lD8LS+rrAaBs7eCIiMPmaKjvo3tHCjcrU0OJs/TfMCY0SfTjnW4N6nHiElO+15QxkHjkz3lzrKzRmbcQDLAP85BvR3Cz6djmu35S/ts0FRW5oWBs7PK0I4NHnUu5AbAWkBKgfVF9L9/7rTr07h0C/yM9d1yZp5TkWu8aAn/qiWQW6qdYVWc0bOlUJBqbzGm5XyaN1O+avgOLblQe0FbqOka93qrj6y1VAptnEV16DI2b4ns7nKYbnFsSPCmiAqst1eIlOLV47AnEoYclgF+LnjGXQM6jghMUUq7Gl7ngQwM080OaKCanH2J5JK/qAycHhePcHBshFge4mtgZTPQqF02v7+BgwHNHfAfNB77m44wVdL0MDha3g15VkWjyj7etD+Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Feb 06, 2026 at 10:06:28PM -0300, Leonardo Bras wrote:
> > +	cpu = smp_processor_id();
> 
> Wondering if for these cases it would make sense to have something like:
> 
> qpw_get_local_cpu() and 
> qpw_put_local_cpu() 
> 
> so we could encapsulate these migrate_{en,dis}able()
> and the smp_processor_id().
> 
> Or even,
> 
> int qpw_local_lock() {
> 	migrate_disable();
> 	cpu = smp_processor_id();
> 	qpw_lock(..., cpu);
> 
> 	return cpu;
> }
> 
> and
> 
> qpw_local_unlock(cpu){
> 	qpw_unlock(...,cpu);
> 	migrate_enable();
> } 
> 
> so it's more direct to convert the local-only cases.
> 
> What do you think?

Switched to local_qpw_lock variants.

> >  {
> > -	local_lock(&cpu_fbatches.lock);
> > -	lru_add_drain_cpu(smp_processor_id());
> 
> and here ?

Fixed lack of migrate_disable/migrate_enable, thanks!

> > @@ -950,7 +954,7 @@ void lru_cache_disable(void)
> >  #ifdef CONFIG_SMP
> >  	__lru_add_drain_all(true);
> >  #else
> > -	lru_add_mm_drain();
> 
> and here, I wonder

This is !CONFIG_SMP, so smp_processor_id is always 0.

> >  	drain_pages(cpu);
> >  
> >  	/*
> > 
> > 
> 
> TBH, I am still trying to understand if we need the migrate_{en,dis}able():
> - There is a data dependency beween cpu being filled and being used.
> - If we get the cpu, and then migrate to a different cpu, the operation 
>   will still be executed with the data from that starting cpu 

Yes, but on a remote CPU. What prevents the original CPU from accessing 
its per-CPU local data, therefore racing with the code executing on the
remote CPU.

> - But maybe the compiler tries to optize this because the processor number 
>   can be on a register and of easy access, which would break this.
> 
> Maybe a READ_ONCE() on smp_processor_id() should suffice?
> 
> Other than that, all the conversions done look correct.
> 
> That being said, I understand very little about mm code, so let's hope we 
> get proper feedback from those who do :) 
> 
> Thanks!
> Leo
> 
> 



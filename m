Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E7977C44508
	for <linux-mm@archiver.kernel.org>; Wed, 21 Jan 2026 20:07:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0A58E6B0098; Wed, 21 Jan 2026 15:07:55 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0538F6B0099; Wed, 21 Jan 2026 15:07:55 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E94116B009B; Wed, 21 Jan 2026 15:07:54 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D65B96B0098
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 15:07:54 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 30ADF8D220
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 20:07:54 +0000 (UTC)
X-FDA: 84357056868.14.2912991
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf09.hostedemail.com (Postfix) with ESMTP id CE0D1140004
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 20:07:51 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=TO5cjHU1;
	spf=pass (imf09.hostedemail.com: domain of llong@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=llong@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769026072;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bbBobMrMFMnxXuOT9SRofzQuxPsjw2p9SW8z4MTGrgE=;
	b=RpMl9iNhnjAoxUA1OIqnTG+BFBxgydtEWqYaM8n5p05yAqo9ARM0VgNElCOLhjBcAHa6Av
	iJ6PzEEbb3upEukbHboezgNQ/zxY9+njAAPJdLvXZeKGtp4Mr3TqijOvOvFffzAMTwhQ7/
	wxqySH0fYOE8qwfX77m6V4vV0NZsKag=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=TO5cjHU1;
	spf=pass (imf09.hostedemail.com: domain of llong@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=llong@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769026072; a=rsa-sha256;
	cv=none;
	b=TNGMQj2aeTX3RsVyfBpYXMRfwcPajQ3u1PQRuPNlJQqWVgI1U8GSIceI/Nv/iEhfwpiqYA
	deVOrM8CBHqLkuTO8AsXXwaTRE8uJy6VkB4DybN8wjmJ24/4zXRm2A0NXDzzEFQ0lxr5//
	x4B8j4fc2MauIwlSa/C+L0rjYODm4AM=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1769026071;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=bbBobMrMFMnxXuOT9SRofzQuxPsjw2p9SW8z4MTGrgE=;
	b=TO5cjHU1+0Mpg/SLzNYxkc0mM2YHBkQM9NAskh9e6NsIeo5wuL6/bmLdRlYn5B//i++cIt
	CQ3d6sDiHLAibNgcJMrQIccNSRvLF+TcnzqwSXXTpGmHe+SDrZ8I/2wl+/X/DEeXrmkpdD
	le2A9Rs5CWKXT53oMevHnCQZGq+AepE=
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com
 [209.85.222.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-456-2mYCpj9SPruWULHt-SsK2Q-1; Wed, 21 Jan 2026 15:07:49 -0500
X-MC-Unique: 2mYCpj9SPruWULHt-SsK2Q-1
X-Mimecast-MFC-AGG-ID: 2mYCpj9SPruWULHt-SsK2Q_1769026069
Received: by mail-qk1-f197.google.com with SMTP id af79cd13be357-8c6a241b5cdso38780585a.1
        for <linux-mm@kvack.org>; Wed, 21 Jan 2026 12:07:49 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769026069; x=1769630869;
        h=in-reply-to:content-language:references:cc:to:subject:user-agent
         :mime-version:date:message-id:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=bbBobMrMFMnxXuOT9SRofzQuxPsjw2p9SW8z4MTGrgE=;
        b=Rg5y3XC0PvZQ0CLxZSCBsXr7Pm2C9eSxp9coXkyhLBoYC/U0XODKU1pJY0CXFon2ni
         kCYJTtWqw5UhBzbF70f1r0wPVBxzykIWYE4OkuXpL4Kvt5hmSZGXuSzJoxyYhIZLx2ap
         5jVu0bed5GR1gMcwfhRXhKQk5qyQXk1Wn9/tnqRyoIz1wpVCYA49lIeTipRX0f2P9SuH
         ESRzTzsvHIU6LEP0x6G+ROW1T9ibqZTOE2sPfA3/n/duDFQukQAxxlq9aV9H2vunHinK
         O6Cj9WKy2iOs2RVTcUJIoIUdgQd3z0tshi/stXjIrzLaNIm4ym/AD+YE0lrwLStNc+xC
         gIsw==
X-Forwarded-Encrypted: i=1; AJvYcCUzv4aJK2TmJrnkn00Z4Pvi6tJJ6zg6PxlQkZIdPtLkg29UEjBO8VBRIHW9QtXDh4PYM/pEvLP84A==@kvack.org
X-Gm-Message-State: AOJu0YyuDmDDQBPmTeb5nV3fZmswtfQ1SWwfAKLdXOlpb25VyxXRbj8R
	JmycKEU34aGkNoXyyARTDfuz7s67LrvDdDnuwX+3gzFAEbdpi9TmsouBJqtbM/8nWWs5Yz24OEw
	Tis2KCN9XSXRWpdI5Kv8A5Ppk2zvUgmJV8U/0Y4d8dVr3+F8bQAT5
X-Gm-Gg: AZuq6aKXZpthO3TlbzSSlRFPhDy7DgR8NCCHBA5W/rh+bCg9Uo5GYnLqDHv/Tp5yCbI
	kva3absN1KOFjZtqAUpCujB7cRHNx+4hN6JuXwI3zIL9jbFtYvCF8Qr11KogK1v/4zewczq8Njf
	5V/LYpcUStou+g6KnBG65VIwJ1SOrvVRXDXSU7NC22Gnvi+wjVjuzMSf/ZgR1sOLSlNacI0BX8o
	Ciq7iH1n4/jp2Zwg9u2o42KGG6VV4mv7ixw+4rhTcCsZAL50yKFus5KF3ILnLkomuqrPUBI+t0q
	ObTnULUVJnrAZfOTItZdmtU4f8CdthDYD8+d1lSzKhHQHzijq0M1YOw0XjgIfrqhUmcwkK8xTUi
	kur6010lsL3L3P/H9eVp6YDjumnck+VL6rhwpjCZsuM2qT/7INPHpHZv+
X-Received: by 2002:a05:620a:7014:b0:8b2:a049:4ac0 with SMTP id af79cd13be357-8c6a66e4bc2mr2474030685a.30.1769026069126;
        Wed, 21 Jan 2026 12:07:49 -0800 (PST)
X-Received: by 2002:a05:620a:7014:b0:8b2:a049:4ac0 with SMTP id af79cd13be357-8c6a66e4bc2mr2474026285a.30.1769026068697;
        Wed, 21 Jan 2026 12:07:48 -0800 (PST)
Received: from ?IPV6:2601:188:c102:b180:1f8b:71d0:77b1:1f6e? ([2601:188:c102:b180:1f8b:71d0:77b1:1f6e])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8c6a71c083esm1287460985a.17.2026.01.21.12.07.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 21 Jan 2026 12:07:47 -0800 (PST)
From: Waiman Long <llong@redhat.com>
X-Google-Original-From: Waiman Long <longman@redhat.com>
Message-ID: <0e385146-67a3-4fdd-b119-059caba8c5f0@redhat.com>
Date: Wed, 21 Jan 2026 15:07:46 -0500
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/mm_init: Don't call cond_resched() in
 deferred_init_memmap_chunk() if rcu_preempt_depth() set
To: Andrew Morton <akpm@linux-foundation.org>,
 Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Mike Rapoport <rppt@kernel.org>, Clark Williams <clrkwllms@kernel.org>,
 Steven Rostedt <rostedt@goodmis.org>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, linux-rt-devel@lists.linux.dev,
 Wei Yang <richard.weiyang@gmail.com>, David Hildenbrand <david@kernel.org>,
 "Paul E. McKenney" <paulmck@kernel.org>
References: <20260121191036.461389-1-longman@redhat.com>
 <20260121114330.6cd34b4732c7803f1720f0ba@linux-foundation.org>
In-Reply-To: <20260121114330.6cd34b4732c7803f1720f0ba@linux-foundation.org>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 870cWezHx6V9ID_kS62XdUJUODXNLP_VwUAcSDMT1vM_1769026069
X-Mimecast-Originator: redhat.com
Content-Type: multipart/alternative;
 boundary="------------3YoXDFipTAldiOlsPPeC8MuF"
Content-Language: en-US
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: CE0D1140004
X-Stat-Signature: x9zdnqfgz5u5i6aqf7pmzgc3hkg9ammp
X-Rspam-User: 
X-HE-Tag: 1769026071-794270
X-HE-Meta: U2FsdGVkX1+aO2pxi/5p/pXOOAQ8p5QymJXU3yJCygnFElW4P6mSEAHozQtmjpcmDq69pb5vV6AFuRRffYGqrWUmGCTZWF/5H70D63qOBusa3518VzYPm31D07QBqkkL/VXCCdgcoJSOJsK17lL9LmwgDNqR7aKMnL1b4VrzY29YILZn4jv28vvISmXKIUKoxrRPEWkH5e+MODZm/kVeAXYz39A09tgEiTo6j4wSsr+cw81R+g0uSts8d5fRnhFKuMSc5/0LPBL4OOFn9R+tsYbyir5G+WGqXeH5KTV3gFetV+58iGOMzMEJRFtR/inM4Co4wZP0PYFGo5nsfgTPD9pcQExAloT9/kaJAdprkg5hxXa9/xPGMsEwAECdxZLKwYJibNSBpk8vVUyM5AJhnoxomWT0bRC3H/eHZ+jdZkEzJnCTC98HfhI6BBIDV0G/eo0dsGf7oHvCbMkhN4NDNOFSyV3mlzo92wO1Ii1MnXe7cfYdYvyQOKOq74ENGEafFIijBcVbVHu3LRJyve4ppS/goHXyZNrzPyg/JGfwnO/6n4gAz+hA5dIDOKPCK1Rb2CG31kKLa0UW+DS+xo800Kv14eVrL4KvlHZcBDi/SVS6a6dfVp1jHCfINncfYFaWnjgwK+tpJwWkZ9ASQr1VYYUgwRTbPZs9blB+Kg/PR7Ds424m2VkPssPTWEg9QZopSdI/1qMC9n70Buh0OlBK3bIoWl/XZFWqGq6Yg+/CVApntEOq0nOGTnUf/SLQH+LDP/foN18f0X7mm+iJgQPH0msUTMNUBSRE13ZpMNAvu7o5xRps0wRU+JBBP3DqiBwiNsYJtfnZHdA1AljOTJ0C5/csUIrRJvqAKA+iNy1oVl6/iHn+yOK2VQnp+OHSZ+XQRlncdJH+O09gzCRb6nCz7hy/XNbo/wzVkru2/nO9eVOSGwFxnapiGfDT5vYp9y4eWDGmePhdRaRIvnfDlKx
 6qv/u0FP
 HZr2dhb54GaPhsYODoRoWv4m/Iz04mkps/W78YRLwyOctCGsf/682BakzLW9Qphn6YQpMfAYgZd93LwWdVn2LAwox0d7mHkg0ST9UJvwlbhxWo8MXrczjLNzlB9ZwYsaufmwzK96qpyPule9qRQgRxf3xkr9Q5o3FlsmevotXHSnhg0qqdroMD8M+pvtMK7uSwKSU3yBcd6pF97gb6fDd/dtnN12+NQMzCkK0RuoU6Y+S+QPfECsdaqqxhayOhWEQxR7qgQ3e/cfein2bjSi45qgorIsGgCvLjU1q
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This is a multi-part message in MIME format.
--------------3YoXDFipTAldiOlsPPeC8MuF
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 1/21/26 2:43 PM, Andrew Morton wrote:
> On Wed, 21 Jan 2026 14:10:36 -0500 Waiman Long<longman@redhat.com> wrote:
>
>> Commit 3acb913c9d5b ("mm/mm_init: use deferred_init_memmap_chunk()
>> in deferred_grow_zone()") made deferred_grow_zone() call
>> deferred_init_memmap_chunk() within a pgdat_resize_lock() critical
>> section with irqs disabled. It did check for irqs_disabled() in
>> deferred_init_memmap_chunk() to avoid calling cond_resched(). For a
>> PREEMPT_RT kernel build, however, spin_lock_irqsave() does not disable
>> interrupt but rcu_read_lock() is called. This leads to the following
>> bug report.
>>
>>    BUG: sleeping function called from invalid context at mm/mm_init.c:2091
>>    in_atomic(): 0, irqs_disabled(): 0, non_block: 0, pid: 1, name: swapper/0
>>    preempt_count: 0, expected: 0
>>    RCU nest depth: 1, expected: 0
>>    3 locks held by swapper/0/1:
>>     #0: ffff80008471b7a0 (sched_domains_mutex){+.+.}-{4:4}, at: sched_domains_mutex_lock+0x28/0x40
>>     #1: ffff003bdfffef48 (&pgdat->node_size_lock){+.+.}-{3:3}, at: deferred_grow_zone+0x140/0x278
>>     #2: ffff800084acf600 (rcu_read_lock){....}-{1:3}, at: rt_spin_lock+0x1b4/0x408
>>    CPU: 0 UID: 0 PID: 1 Comm: swapper/0 Tainted: G        W           6.19.0-rc6-test #1 PREEMPT_{RT,(full)
>> }
>>    Tainted: [W]=WARN
>>    Call trace:
>>     show_stack+0x20/0x38 (C)
>>     dump_stack_lvl+0xdc/0xf8
>>     dump_stack+0x1c/0x28
>>     __might_resched+0x384/0x530
>>     deferred_init_memmap_chunk+0x560/0x688
>>     deferred_grow_zone+0x190/0x278
>>     _deferred_grow_zone+0x18/0x30
>>     get_page_from_freelist+0x780/0xf78
>>     __alloc_frozen_pages_noprof+0x1dc/0x348
>>     alloc_slab_page+0x30/0x110
>>     allocate_slab+0x98/0x2a0
>>     new_slab+0x4c/0x80
>>     ___slab_alloc+0x5a4/0x770
>>     __slab_alloc.constprop.0+0x88/0x1e0
>>     __kmalloc_node_noprof+0x2c0/0x598
>>     __sdt_alloc+0x3b8/0x728
>>     build_sched_domains+0xe0/0x1260
>>     sched_init_domains+0x14c/0x1c8
>>     sched_init_smp+0x9c/0x1d0
>>     kernel_init_freeable+0x218/0x358
>>     kernel_init+0x28/0x208
>>     ret_from_fork+0x10/0x20
>>
>> Fix it by checking rcu_preempt_depth() as well to prevent calling
>> cond_resched(). Note that CONFIG_PREEMPT_RCU should always be enabled
>> in a PREEMPT_RT kernel.
>>
>> ...
>>
>> --- a/mm/mm_init.c
>> +++ b/mm/mm_init.c
>> @@ -2085,7 +2085,12 @@ deferred_init_memmap_chunk(unsigned long start_pfn, unsigned long end_pfn,
>>   
>>   			spfn = chunk_end;
>>   
>> -			if (irqs_disabled())
>> +			/*
>> +			 * pgdat_resize_lock() only disables irqs in non-RT
>> +			 * kernels but calls rcu_read_lock() in a PREEMPT_RT
>> +			 * kernel.
>> +			 */
>> +			if (irqs_disabled() || rcu_preempt_depth())
>>   				touch_nmi_watchdog();
> rcu_preempt_depth() seems a fairly internal low-level thing - it's
> rarely used.
That is true. Beside the scheduler, workqueue also use 
rcu_preempt_depth(). This API is included in "include/linux/rcupdate.h" 
which is included directly or indirectly by many kernel files. So even 
though it is rarely used, but it is still a public API.

>
> Is there a more official way of detecting this condition?  Maybe even
> #ifdef CONFIG_PREEMPT_RCU?
>
I am not aware of a more official way of detecting this. Maybe Sebastian 
has some ideas. rcu_preempt_count() is defined 
whether CONFIG_PREEMPT_RCU is defined or not. So we don't need a "#ifdef 
CONFIG_PREEMPT_RCU". Maybe I should explicitly include 
"include/linux/rcupdate.h" in mm/mm_init.c just to be sure.

CONFIG_PREEMPT_RCU defaults to on if PREMPT_RT is set. With 
!CONFIG_PREEMPT_RCU, rcu_preempt_depth() is hard-coded to 0 and will be 
optimized out.

Cheers,
Longman
--------------3YoXDFipTAldiOlsPPeC8MuF
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: 8bit

<!DOCTYPE html>
<html>
  <head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
  </head>
  <body>
    <div class="moz-cite-prefix">On 1/21/26 2:43 PM, Andrew Morton
      wrote:<br>
    </div>
    <blockquote type="cite"
cite="mid:20260121114330.6cd34b4732c7803f1720f0ba@linux-foundation.org">
      <pre wrap="" class="moz-quote-pre">On Wed, 21 Jan 2026 14:10:36 -0500 Waiman Long <a class="moz-txt-link-rfc2396E" href="mailto:longman@redhat.com">&lt;longman@redhat.com&gt;</a> wrote:

</pre>
      <blockquote type="cite">
        <pre wrap="" class="moz-quote-pre">Commit 3acb913c9d5b ("mm/mm_init: use deferred_init_memmap_chunk()
in deferred_grow_zone()") made deferred_grow_zone() call
deferred_init_memmap_chunk() within a pgdat_resize_lock() critical
section with irqs disabled. It did check for irqs_disabled() in
deferred_init_memmap_chunk() to avoid calling cond_resched(). For a
PREEMPT_RT kernel build, however, spin_lock_irqsave() does not disable
interrupt but rcu_read_lock() is called. This leads to the following
bug report.

  BUG: sleeping function called from invalid context at mm/mm_init.c:2091
  in_atomic(): 0, irqs_disabled(): 0, non_block: 0, pid: 1, name: swapper/0
  preempt_count: 0, expected: 0
  RCU nest depth: 1, expected: 0
  3 locks held by swapper/0/1:
   #0: ffff80008471b7a0 (sched_domains_mutex){+.+.}-{4:4}, at: sched_domains_mutex_lock+0x28/0x40
   #1: ffff003bdfffef48 (&amp;pgdat-&gt;node_size_lock){+.+.}-{3:3}, at: deferred_grow_zone+0x140/0x278
   #2: ffff800084acf600 (rcu_read_lock){....}-{1:3}, at: rt_spin_lock+0x1b4/0x408
  CPU: 0 UID: 0 PID: 1 Comm: swapper/0 Tainted: G        W           6.19.0-rc6-test #1 PREEMPT_{RT,(full)
}
  Tainted: [W]=WARN
  Call trace:
   show_stack+0x20/0x38 (C)
   dump_stack_lvl+0xdc/0xf8
   dump_stack+0x1c/0x28
   __might_resched+0x384/0x530
   deferred_init_memmap_chunk+0x560/0x688
   deferred_grow_zone+0x190/0x278
   _deferred_grow_zone+0x18/0x30
   get_page_from_freelist+0x780/0xf78
   __alloc_frozen_pages_noprof+0x1dc/0x348
   alloc_slab_page+0x30/0x110
   allocate_slab+0x98/0x2a0
   new_slab+0x4c/0x80
   ___slab_alloc+0x5a4/0x770
   __slab_alloc.constprop.0+0x88/0x1e0
   __kmalloc_node_noprof+0x2c0/0x598
   __sdt_alloc+0x3b8/0x728
   build_sched_domains+0xe0/0x1260
   sched_init_domains+0x14c/0x1c8
   sched_init_smp+0x9c/0x1d0
   kernel_init_freeable+0x218/0x358
   kernel_init+0x28/0x208
   ret_from_fork+0x10/0x20

Fix it by checking rcu_preempt_depth() as well to prevent calling
cond_resched(). Note that CONFIG_PREEMPT_RCU should always be enabled
in a PREEMPT_RT kernel.

...

--- a/mm/mm_init.c
+++ b/mm/mm_init.c
@@ -2085,7 +2085,12 @@ deferred_init_memmap_chunk(unsigned long start_pfn, unsigned long end_pfn,
 
 			spfn = chunk_end;
 
-			if (irqs_disabled())
+			/*
+			 * pgdat_resize_lock() only disables irqs in non-RT
+			 * kernels but calls rcu_read_lock() in a PREEMPT_RT
+			 * kernel.
+			 */
+			if (irqs_disabled() || rcu_preempt_depth())
 				touch_nmi_watchdog();
</pre>
      </blockquote>
      <pre wrap="" class="moz-quote-pre">
rcu_preempt_depth() seems a fairly internal low-level thing - it's
rarely used.</pre>
    </blockquote>
    That is true. Beside the scheduler, workqueue also use
    rcu_preempt_depth(). This API is included in
    "include/linux/rcupdate.h" which is included directly or indirectly
    by many kernel files. So even though it is rarely used, but it is
    still a public API.  <br>
    <br>
    <blockquote type="cite"
cite="mid:20260121114330.6cd34b4732c7803f1720f0ba@linux-foundation.org">
      <pre wrap="" class="moz-quote-pre">

Is there a more official way of detecting this condition?  Maybe even
#ifdef CONFIG_PREEMPT_RCU?

</pre>
    </blockquote>
    <p>I am not aware of a more official way of detecting this. Maybe
      Sebastian has some ideas. rcu_preempt_count() is defined whether CONFIG_PREEMPT_RCU
      is defined or not. So we don't need a "<span
      style="white-space: pre-wrap">#ifdef CONFIG_PREEMPT_RCU". Maybe I should explicitly include "</span>include/linux/rcupdate.h"
      in mm/mm_init.c just to be sure.</p>
    <p>CONFIG_PREEMPT_RCU defaults to on if PREMPT_RT is set. With
      !CONFIG_PREEMPT_RCU, rcu_preempt_depth() is hard-coded to 0 and
      will be optimized out.</p>
    Cheers,<br>
    Longman
  </body>
</html>

--------------3YoXDFipTAldiOlsPPeC8MuF--



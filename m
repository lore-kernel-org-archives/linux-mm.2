Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E5064CCFA13
	for <linux-mm@archiver.kernel.org>; Thu, 30 Apr 2026 12:11:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4BC616B008C; Thu, 30 Apr 2026 08:11:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 493036B0092; Thu, 30 Apr 2026 08:11:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3A9796B0093; Thu, 30 Apr 2026 08:11:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 268626B008C
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 08:11:06 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id BE7A2C0666
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 12:11:05 +0000 (UTC)
X-FDA: 84715106490.02.61E4548
Received: from mail-lf1-f45.google.com (mail-lf1-f45.google.com [209.85.167.45])
	by imf30.hostedemail.com (Postfix) with ESMTP id C5C2380012
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 12:11:03 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=DH104wOY;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf30.hostedemail.com: domain of urezki@gmail.com designates 209.85.167.45 as permitted sender) smtp.mailfrom=urezki@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777551063; a=rsa-sha256;
	cv=none;
	b=ztDhYGhqdJ9w4McDJWAoc2ejAMCPwZTiEwdNAV0CH85COZyMGPcxm4wOmEublY+9ij1zOl
	nkBY//7JZ33NFtinYX3p4qXcJyUayIOyKfw0xh06aJHlVu+cqEPLatIRug45KKnPin/TJv
	AIGwiOV0MuUhKnyornf9WrDJ01/utKU=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=DH104wOY;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf30.hostedemail.com: domain of urezki@gmail.com designates 209.85.167.45 as permitted sender) smtp.mailfrom=urezki@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777551063;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=t1qpxAkuAsOwU5i725XJCGiCdOGB9mh34dV03O6Zark=;
	b=ym7bSDvPjnKhugsDZTUcyWdtiba0sUf9yGY4jSGPSMsDXeSjHs6LIbA0dzZyYOwKbqZvI4
	e9AmSaSn/F08s15YBL7XNukisytSbeiVrg/50nEteNswDlDavHuB7X7s9OpbpZeaEBxgrz
	+NwKWdmdtMOkQ4MYQVhgoOXPTqoqz3E=
Received: by mail-lf1-f45.google.com with SMTP id 2adb3069b0e04-5a40b2bc96dso846356e87.3
        for <linux-mm@kvack.org>; Thu, 30 Apr 2026 05:11:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1777551062; x=1778155862; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=t1qpxAkuAsOwU5i725XJCGiCdOGB9mh34dV03O6Zark=;
        b=DH104wOYAimHiVX+dUUXnew2p5J51gBxyuvQJJmFUBc/k6YvFA4N2N70KGXU/2O9wH
         FSAuLb1VqwAJ0cab2RF+dWmAH5hhvwGORN0ZS2zZmSxPFFmCzzno2ygeJmOPaoizW60K
         jkd3QqRDk4O1tdrO90G+4YTogk73VayUFkJ+bpHB1YIy+JZZGE44zzBYf4moqpnJ+9wr
         UZ01VZO2Jkd7+XpxjuObF2SiPQpZ05h88sAX5HRdh3LMduPuPZWZr8kYlGnEkQTLmAX1
         i0zASs7GZ1mpNuHQpkYTTIiHwWyPudn1c7t3HpKKgKYsfTMbIjblZvFKF33m36JeRMgZ
         yhBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777551062; x=1778155862;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=t1qpxAkuAsOwU5i725XJCGiCdOGB9mh34dV03O6Zark=;
        b=CGugZkRIh5oxCC+y7fSC7u+jPgjuX99g1wJuK5CweTlIWvNaY42mkDURAMGmVqzI9Z
         pVQQ3pdOrkQMqlLqnk91ifmrLQRwU0hAuqAwabPhG7FbaBsXwTVZinj7P06m/700dYv1
         bF8vSbo2IPXq8wZh6ELVgrkufJSogLNX2rBRWPUAxD6Z3+sWDX/p5q2YNoXUUhs4yDlX
         scvo4ROqHyIOn1eR8/JXs/u44LP2ca741ewduU6owdEWFurV/GCpuP0lF1bc+w0XXNiy
         lOClJdFt05uQ5bkWfVklmFhbCcKvAW4xq7nhdsT1CVvqw2WEwGdrJXIg1WP7Nk+6AkF7
         vw/g==
X-Forwarded-Encrypted: i=1; AFNElJ/ND9/ktZ8nEeFRle1tWTvS5pyHQbN6kFfaXWzzhzuouszYrzxkXLZmp2KlSpyjSXkscEVlUOsDtw==@kvack.org
X-Gm-Message-State: AOJu0YzPbOJpB0KAU7Xf96aTPoTZR2xEzafDYaqgdpKSdcOIzTPjZYA2
	IgX1ge5dIOXuzQamL0OaoFV0lUDpkd/EeUe7u7AG0B3xQQslz9wE7uN4
X-Gm-Gg: AeBDieu0tho56RAqZgq16ydIIP47CMCp9ZSblNfrtlW4/5hFBs20i8c6Y7jMlJEkxfR
	8/Dc0zD6FTs6yDdeQvNZ7X2jWDkO6x8XMISSUZn6FcfPX3A8Rlb6R79QbMRMnYtNwoGkHUD5EIY
	bd8avtieE1fP1SO49wcci6fBxTQ/5XZOMVqn3vYCH6561DnEZgpvkx7FvX4tRQpv/22vmS3TtNI
	Uo07GD5AQPUXzsu7tEi+EMfQ3RZ43Lk6kFAQva7xJUplKiBDFfiFiQDESfVaMq4LFzJVb2nLiJ9
	a4duUFlL+PmWqn6hMff3WXA0F+ccZ0p7Es4AKPJKgx2Z0tf/d8/YM4IKo95YRBujv/YAAvN3zms
	HlyaZfU7lNQuHz5/gv9ihAVVNp9JzWnuYtMKeM0ungkDXsb33JyQAWu8La5YGQZfgWMeRMzXPRa
	1/OdUYVNuF2LOE4IZSzxnEXCROgS4Kfvoyu46FpY0J919piSBX+JRZbkXq
X-Received: by 2002:a05:6512:1092:b0:5a4:1add:c574 with SMTP id 2adb3069b0e04-5a8522b1d5emr849686e87.5.1777551061318;
        Thu, 30 Apr 2026 05:11:01 -0700 (PDT)
Received: from pc636 (host-95-203-5-23.mobileonline.telia.com. [95.203.5.23])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-5a74a769570sm1386080e87.66.2026.04.30.05.10.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Apr 2026 05:11:00 -0700 (PDT)
From: Uladzislau Rezki <urezki@gmail.com>
X-Google-Original-From: Uladzislau Rezki <urezki@pc636>
Date: Thu, 30 Apr 2026 14:10:58 +0200
To: "Harry Yoo (Oracle)" <harry@kernel.org>
Cc: Uladzislau Rezki <urezki@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Hao Li <hao.li@linux.dev>, Alexei Starovoitov <ast@kernel.org>,
	"Paul E . McKenney" <paulmck@kernel.org>,
	Frederic Weisbecker <frederic@kernel.org>,
	Neeraj Upadhyay <neeraj.upadhyay@kernel.org>,
	Joel Fernandes <joelagnelf@nvidia.com>,
	Josh Triplett <josh@joshtriplett.org>,
	Boqun Feng <boqun@kernel.org>, Zqiang <qiang.zhang@linux.dev>,
	Steven Rostedt <rostedt@goodmis.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Lai Jiangshan <jiangshanlai@gmail.com>, rcu@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [PATCH 4/8] mm/slab: introduce kfree_rcu_nolock()
Message-ID: <afNG0jNQNYeZ940g@pc636>
References: <20260416091022.36823-1-harry@kernel.org>
 <20260416091022.36823-5-harry@kernel.org>
 <aejeVK0J_jHSfVhD@milan>
 <aemevSofweaUSx0n@hyeyoo>
 <aeoD_Ts6hLsgNc9-@pc636>
 <3s4jafam3la72a6y3dkfvhtzxk3fsngb2cka3bpfqrirl5m633@pz3vzizefoxb>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3s4jafam3la72a6y3dkfvhtzxk3fsngb2cka3bpfqrirl5m633@pz3vzizefoxb>
X-Stat-Signature: zqdnodw734mwios45p7gufn3f33er7jz
X-Rspam-User: 
X-Rspamd-Queue-Id: C5C2380012
X-Rspamd-Server: rspam07
X-HE-Tag: 1777551063-390462
X-HE-Meta: U2FsdGVkX1/Ld5tNLAKuBpcp+FlmxQdCzypcEbLgcUWOcdKpjscxTtSQoYMmjtSd6wrDc0s6ndTDcm31+xDSXHFjSrV3nJKICyIRq0C041BDh2knnmPEJ2/ZW2SApA6LwcaS6JEeDj8+ppVxPqP5Snolivw61u6iojriM/RP5SbPtNeESBREDxyt8/Hvx7m4wmNWBACLh1LjW6GlnjL2eUm4OBKtltZWJcxdhKLdCcoE5Gp654DyFRnxD6sdLaMu5gk7F9lDmPgBEuFNzhY0G70ypVVORH2SDXyxes8dJmALpZdfim6zfIACkimNnFhJ24kC7aXqMvialLSH61HG2JnnBg49KE3XO/N5d/05eq5yr4+qygKGZXud8QjfocZ15Ej5oeraVDrPVjG57cf4I0/LAIJM7DzQVp/rHxzej2F20cBz4wWxFGIQ1RzsEznSPlTP5BIxt53fjgWcbAx9ZCJ9OrXkcn8STD5eioUKNrGtjGnfyMPiCDBsrSoTjGw4fnAsSAbi+YfHUS4UI1NNFWOYhI/KoeZsR+qzr4nXAHiak/MDRirxqrw74drgG9zIi4YFgnR5HFpZgIsA4EY1OE7h+vrk/ZIXD5NJpy0Ay+gwiiyT/EnkP2fWBlo0859FVrG/SHKMTABPlBGb9a6jDMkNGEm6RmJtN38YbUGeCAR+Nd6aXdC0qkikO1HtPSc5daUPPnRSGiIWbHgyCwkCv/yHuXtfvK7rgDs9z7u1SRUgI7x0LXE/6jRMOwhniXVOlOzNtaIMsQFr1l4hYpsZsUhoXMZESCBOpSX3iAT0ykpNShUOJO+MCYxUR/Ke4R7eycJXtYAvQm5JQXkVbyJnhWea4dJfc3iYdIB1u6KIA7RHHOtvQZDEvP3J2evN9fZ2qBE0ybAiIfeMWH94t8f2MvTt3gB/2aHybXcjaYub3v21clMaVivPpuvvVE9a9GVBxEJrxgrr4PoGNB0Rolp
 ESUxmXVw
 LJdTcNqdcRV5q2Ts7fUJ0Lmzi9tN9H/Rs+IZ3wjvInU4c9LWm1tr7hL/j/10UINsLhOju0PJLV+dDn/bpjoPDCRRqQ+++HQsVcXk3qo788r+zxFd7zxy/0jJYe8pjnsdBG62mJh8uMAU7s+ZkXeTcU/dWu9yRphbXpptdh5fbhVlTBmdWolxjGbOmLAFBVF9BlUKFoRorg4qHyLhJEq6d0apvlSaZ1XZfMnRrAeZcp041T1gKH5IfFgm/gH0Dtkvydxm6d1ayHZqdtVahcnyxbYf2ZVkbP/Q5DBCt9Q3upXW46HBchwnjbfV4XduEh93TXvufN39Ifk2WBE6Am+tqoNB2ZNtU85CYLyWb87Vp98MYq/7OSN/OEOWDFnYbI0Tmr9eA1qbiPljmtHhKycpXOTdJSqZpP9Gqmx0IbYwiGfyolwcc333GI/YxtnwzCRD4GTZj6mLH1lRdAM7BDGsaLZlmvx40c8Fe9BLt
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello, Harry!

>
> Hi Ulad. Apologies for the delayed response.
> I meant to reply sooner but sidetracked by other issues.
> 
No problem, sometimes i also can lag because of other tasks :)

> Your questions are fair, but let me try to clarify
> the current situation.
> 
> And before diving into details, I would like to reiterate that
> there are potentially two points to discuss here:
> 
> Point 1. Can we justify complicating subsystems by passing
> 	 `allow_spin` parameter all over the place?
> 
Yes, we can. But as i noted i see some drawbacks :)

- all new incoming patches have to respect that new third argument;
- the fallback mechanism which uses irq-work is not optimal in my
  opinion:
    a) We introduce an extra window between queuing a pointer, mark
       irq-work to be executed and then reenter the kfree_rcu() with
       no-sync flag and now we need to wait a GP for them. But the GP
       might be already passed for such pointers. So we potentially
       need more time to offload. This is rather minus.

    b) Since it is for BPF, allow_spin is always false, thus only
       fallback path is used. Decoupling comes to mind.

    c) 

Why should we mix those? What it is worth to do, is to prevent mixing
"unknown path which is for BPF/others" with generic kfree_rcu().

It is easier to go that way and more cleaner, IMO. We need less code
and we fix a specific requirements.

>
> Point 2. Can we avoid adding this complexity to kvfree_rcu() and
> 	 let slab handle it instead? (as mentioned in [4])
> 
it depends if BPF people want to free a pointer using RCU machinery?
Do you know if that an intention?

> On Point 1: IMHO it could be justified, but at the same time I hope we
> end up avoiding more complexity in the long term by working on Point 2.
> 
> This reply focuses only on Point 1 and explains why it could be
> justified.
> 
> On Thu, Apr 23, 2026 at 01:35:25PM +0200, Uladzislau Rezki wrote:
> > On Thu, Apr 23, 2026 at 01:23:25PM +0900, Harry Yoo (Oracle) wrote:
> > > On Wed, Apr 22, 2026 at 04:42:28PM +0200, Uladzislau Rezki wrote:
> > > How much performance do we sacrifice compared to
> > > letting them go through the kvfree_rcu() fastpath?
> >
> > Freeing an object over RCU from
> > NMI context is a corner case. It is __not_ generic.
> 
> First, I want to clarify that kfree_rcu_nolock() is not just for NMI
> context. It is intended to be used when the context is unknown (because
> it can be called in an arbitrary code locations).
> 
When we say "unknown" to me it sounds like a worst case, which is NMI :)

> There are two kinds of problematic situations where BPF programs
> are attached to:
> 
>   - 1) a tracepoint or a function that can be invoked in a critical
>        section (w/ a lock held), or
> 
>   - 2) a function that can be called in an NMI context, which might
>        preempt an arbitrary context holding a lock.
> 
> While 1) and 2) are not (I think) dominant use cases, and although
> most of users can legally call kvfree_rcu(), BPF can't use kvfree_rcu()
> and must consider the most restrictive contexts.
> 
> > We even do not have(now
> > in mainline) users because we never support it from NMI,
> > just like call_rcu().
> 
> Unfortunately, we've had this use case (of allocating memory for BPF
> programs) for a long time in the mainline. There are two current
> approaches to mitigate the limitation:
> 
>   - 1) Pre-allocate all memory. e.g.) allocate all hash table elements
>        when creating a BPF map, rather than allocating them on demand.
>        This ensures correctness but sacrifices memory.
> 
>   - 2) Use the BPF-specific memory allocator [1] [2] to allocate memory
>        on demand and avoid preallocation. While this wastes less memory
>        than 1) and also maintains performance, it is re-inventing yet
>        another memory allocator.
> 
>        Also, the allocator reinvented kfree_rcu batching as well.
> 
> Now, we're trying to avoid 1) and 2) as much as possible and use
> kmalloc_nolock() instead [3].
> 
> > If BPF needs
> > it, then the first question which comes to mind is not about performance.
> > It is how to support this case in kfree_rcu() without adding noticeable
> > complexity or overhead or hacks to the generic path without making it harder
> > to maintain.
> 
> Since there will be only few subsystems that needs it, and because
> they already use it on production systems, I don't see much value in
> maintaining a simple implementation if that compromises performance
> (and thus make the transition harder).
> 
> > Performance wise you noted, you mean:
> > 
> > a) call latency(this is probably the most important for NMI)?
> > b) memory footprint?
> > c) pointer-chasing overhead?
> 
> I think it's either
> 
> - The performance of kfree_rcu_nolock() itself (a), or
> - Not distrubing workloads running on the machine (b and c)
> 
> depending on what people use BPF for.
> 
Are you aware of any specific workloads which we can run? To test
and see what we have when it comes to performance metrics? I mean
exact uses cases with exact steps who to trigger them?

That would be useful to see on behaviour.

Thank you!

--
Uladzislau Rezki


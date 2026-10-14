Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0284BCC6B1A
	for <linux-mm@archiver.kernel.org>; Wed, 14 Oct 2026 13:31:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0E7A96B0088; Wed, 14 Oct 2026 09:31:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0988E6B008A; Wed, 14 Oct 2026 09:31:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EC9E86B008C; Wed, 14 Oct 2026 09:31:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C81186B0088
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 09:31:02 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 6B9C71A0569
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 13:31:02 +0000 (UTC)
X-FDA: 85321317564.27.D836CA3
Received: from mail-qt1-f180.google.com (mail-qt1-f180.google.com [209.85.160.180])
	by imf20.hostedemail.com (Postfix) with ESMTP id 9F3971C0004
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 13:31:00 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=rbEB0Ha2;
	dmarc=none;
	spf=pass (imf20.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.180 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791984660;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Yl3/HcMxKzbLRx25aj5CEBdDsA+AcBSsOvkZ317Rc8o=;
	b=WlRSdSDiBXwdP0f4PhzQ1eHjllQ4n8K7nP6hWD2aQafwGc0lXMw79g+UvtDKodVLjaf0nY
	U0QnDfaAmIteMLe1AwCulOvimkJFwmMthrUCMTK4aYorgcdZzLRtkQj4Z2NZuFarAUBN9M
	IxSl1aGJvZORuQVs9ZPPqw1f73w19XI=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=rbEB0Ha2;
	dmarc=none;
	spf=pass (imf20.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.180 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791984660;
	b=QREksyaXpX/n6o9oJ5ZO7OCp7Rli8/cbnx9F//rw4OoralzOwGsziWOqs9vG9gILQFpAvI
	qUzWXWXZ1ex3wkqPBIVklly0Ynxv0izBtdak10QF/2PRhyN5c+j0BxD0WY3vT/QEoJjLSW
	i+be/ezJ6O9pON9/1vRZB0U2WhIF9xA=
Received: by mail-qt1-f180.google.com with SMTP id d75a77b69052e-53505bc6524so11156751cf.0
        for <linux-mm@kvack.org>; Wed, 14 Oct 2026 06:31:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1791984660; x=1792589460; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=Yl3/HcMxKzbLRx25aj5CEBdDsA+AcBSsOvkZ317Rc8o=;
        b=rbEB0Ha2st0ppMEPp2bmZBpA2tauSe6E5UfCh67sYT19dGwblR6TqHf6pQ60LOBssO
         YPUPDi6Gm9OA4Lz3vhImqSboHyO7gIRTFXVB0a0TGPgIL51G+taZD3a2yW/yaBPmtpVQ
         dDBemUdsTZQARhey2pLh04p6eWH/DtZroiRw+bsY0AUqGBCy9ub1Sea5q6pfXWQJkadf
         sf8qnEnhIW2F1YGQc51nsc+x9wII9+CMQPylpuIh4ZZMiH8vwtP8cFBi8COzVsBlcqO4
         F68yEY763vjIXTaesZvku67123Q8QmKX8gJHyTFechmKAqWOclnMclLmvHmkQB/8X/k0
         rM9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791984660; x=1792589460;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Yl3/HcMxKzbLRx25aj5CEBdDsA+AcBSsOvkZ317Rc8o=;
        b=ofuXX+LG+8pCnJ/fa294dckI5h3cjODtfENUez67+1FCwCA9WgjxppcZGF8QHrPrMq
         IArpNcbHcRwKIjss8Q9BtYL2rl+kmyspgH1lV+8cxoIor8iMQjJxrXYyGcha0+Odp/K8
         UhYIvOrqbLikJ51k441KzPKcIbOWlFQosbE+XATPW/llmDWcjq6F2A+SjP/JVSGPAKjL
         RNBJ2X1S575cM3C8Vfdp0N6NIpq056N4sZXUy43vO/QcWnXctPbKhbhSah2fcu/UdwJm
         gCse+L8s5Ba4esu+xPQRFLbh6WX90LH2jl/PYIHxYCijIMMfPRP7DTSVu3+JnnFucmg0
         Yvlw==
X-Forwarded-Encrypted: i=1; AKwUvByFD2N6H2wDMJ6pGdAdLGxeQmJWwy7geq7zvWnw8N+Ty7nUUNsF0C09JMsZQBdpDBCFH4JIeCY2cQ==@kvack.org
X-Gm-Message-State: AFq9FYI6QI0rnhAnPMQ/KlkDzaFcN6cuJpi2WIDTSYHPzULUdhGS2oSo
	RkOcn+21P34ffDPorK/2GYdhxlC+3Tm5q5PaGdiTj+vc+vn0Ij0V7FUbnxgE14VuDQU=
X-Gm-Gg: AYBFou1xomtIP6/KzoDjXyYwIlx17JNwpNPi1YQeBFprVtFtyIutwQGsvQ10/I1O3o+
	uTdplSCNFmxF/H1EKfm6s71/5VHyasiAZoO/ca7p9sepiNWWbNKKCgFVB5aJMfzddM78t/19rvf
	W9/WbYBQlzWbQOQoPPnT6eS92dwFSdsdc7wXb0z+4TWaLvXMoj98gJAhl8KNNj4NMmvlhueVpGo
	OnAAsdsLrIhlfGw5z1imXgABJq4q/mFau03yXiWuqSnKXbG6ulKfGfXCqOUdZ1/YyG+vOyUxg2i
	tKs/ELPLo0UZsVNlIwmdKy7tRnxi9pren1o1mbVz1Gsai8r1M4/FcA1ONas2hGZO1W9ifST+xjC
	u0DwpSXCt1VrjQWiUNHHxpr9BaUbQrV8gn/yf4V73RZXPr37KE3ZnPlADUuVGcx2pHpEuTbKUZt
	rxQbnukhpwyKOrF4ipVa2pxm8Ftk3vwCSkCiA/e2oX3ZELO8CWshntpFWyp7bUR+DkGrbOV3oWZ
	OCbfhPu2giaay4J5wCbymU5T//tmOwVO32ZylLZRnOiXkgMlljMEwA=
X-Received: by 2002:ac8:570b:0:b0:535:70b3:fa0a with SMTP id d75a77b69052e-535a6294b31mr232930981cf.38.1791984659743;
        Wed, 14 Oct 2026 06:30:59 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-53607e1b801sm9569991cf.21.2026.10.14.06.30.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Oct 2026 06:30:59 -0700 (PDT)
Date: Wed, 14 Oct 2026 09:30:57 -0400
From: Gregory Price <gourry@gourry.net>
To: Li Zhe <lizhe.67@bytedance.com>
Cc: akpm@linux-foundation.org, david@kernel.org, ljs@kernel.org, 
	joshua.hahnjy@gmail.com, ziy@nvidia.com, mingo@redhat.com, peterz@infradead.org, 
	mgorman@suse.de, riel@redhat.com, juri.lelli@redhat.com, 
	vincent.guittot@linaro.org, dietmar.eggemann@arm.com, rostedt@goodmis.org, 
	bsegall@google.com, vschneid@redhat.com, kprateek.nayak@amd.com, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 6/6] sched/numa: ignore preferred nodes without normal
 balancing
Message-ID: <as-D8ff7oXKX_CwF@gourry-fedora-PF4VCD3F>
References: <20261014094347.99157-1-lizhe.67@bytedance.com>
 <20261014094347.99157-7-lizhe.67@bytedance.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261014094347.99157-7-lizhe.67@bytedance.com>
X-Stat-Signature: fh5oayo7qaiimsd1tq1njakdegd6qa9s
X-Rspam-User: 
X-Rspamd-Queue-Id: 9F3971C0004
X-Rspamd-Server: rspam08
X-HE-Tag: 1791984660-955700
X-HE-Meta: U2FsdGVkX196FIpOGv3b6w4zolsRu0zPkIylhWoNymy2BlFLbreUyQ+vXzsO41ixn831xg7Z2khJHKxwiKk4ApDrpr8KCuHSTql3yNaat781ZScH5BUtdia/Zx7LMSe8TYyeUQA6ahr2eHywRpmpDH7CSM3dUImXvrvSeY+aKT6B6/0TBONoQd46/9HfmIp8rF11sGHmNue8us1ww88IduvSXPHZog1XRMQq4qwemkhkGAJ1Vyj2mRO129y4qy3oe293mbnTFc/RcsWIVbRmloquzj1GbV/l3tVFoEenX85jxYZt/CCfREQBP2dImGCgEaP7mDjE0EG9dXqcIjaujiuWyBH/+xPW+UfauYVGIyZY+ik2REiwk8QqpZiuP9McrFNWl8VQdZ09Uxz2r/vWd9tUzxt7UHUoxW6bcnNAI5l9C4luFhnXJt0zTBua88Acb01y75o5tNDONfkq09sDSOORKurpxpqdBHRxHK7VUdqiheSdFmLsCjD+ZBbVayz2CHCWiXozTATjbWLoCrpBoxAMVY0pAVrcdYzm9AMskMQW3Yl8GGmtZy2JmjOV9vJGgsuIRLPL5cILsrzsJ9wsUmL9EiXvADDB07/Pyb94iu38XQyO7q8Onq0FXr3BOc/HZgxgMbGBNFj0DvwvLlMyqDwiGjP/1MFCZJtaY9iyF5VZbZEu56tC8RP5WzgYcTgTwF0JEO0ig38KAE7p3VFtgTBuYyaw6EIUBbw/iWtT+OH94PLBEkjpkxkjYWvXfMhiXn2gHrAcAokS9VtM0HCBKa251VXhduEaPAeIaL7TmupOb1TZ0e25ceOm903qXywvvkEuWm1yfmxYZ6afv74/xCwkX7JPcnMUoKRTJAcSdnBYOJMFg+Q4KxtswHqkctq2ZUKnobBjlGDrKDqLFtkpgYItOzsk1krRRDCtyfCe75na20HC9HfP3F3A9qIrwOu5f7qmmdcTpBw/cmeotwe
 c1ITXa5G
 sck05bPlO4fnX292fdPU22soPfATjGo7mM6c709yRdrta0RZiyH99pzSnaCuaGQw+yXMsjSnLj2n9TRnl6W6PwR400BOzW2XkEH1vnOpPHFELaJhn7OFAfkP0Ashb1xzFpSDbCrpycIgA15U6WvQSX8c8+omAtjW3iIQqWZMgF77mGEWepf8eHYdil1D9dMbfbA8JB2TBUe+r1CTcl3heqY3TfO0URfP8Yv3CLfwD6F091GQBDv0pcn3jDYUzX8tw9Xf431/qh/I2yANKTO5f0npmQ2u5Dbm7szslhXnfY96DHqzt/832ekFUZ0sN5RzsE8mZsw6+S5Yl1R4F8vOWg3AOl/txD4/t5HH74ulObuXlO17h1YIe7AOVorodzeqDfpNbkEauBpDVJ6mninQEw1eVZQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Oct 14, 2026 at 05:43:47PM +0800, Li Zhe wrote:
> numa_preferred_nid is normal AutoNUMA task-placement state.
> Memory-tiering-only mode uses NUMA hint faults to drive page promotion,
> not CPU placement.
> 
> Even after tiering-only faults stop updating normal placement statistics,
> a task can still have a preferred NUMA node from earlier normal balancing
> or from previously polluted state. Several scheduler paths consume that
> stale state when the NUMA balancing static key is enabled, including
> explicit NUMA task migration, sched-cache preferred LLC and scan CPU mask
> selection, load-balance locality checks, fbq classification, and wakeup
> group selection.
> 
> Add a small helper for normal NUMA placement being enabled and use it to
> ignore numa_preferred_nid when NUMA_BALANCING_NORMAL is disabled. Keep
> the preferred-node migration retry timestamp update before the normal-mode
> check so accepted non-normal sysctl states do not leave stale retry state
> behind.
> 
> Keep the rq nr_numa_running and nr_preferred_running accounting unchanged
> so runtime mode changes do not make enqueue/dequeue accounting asymmetric;
> the load balancer simply stops consuming those counters while normal
> balancing is off.
> 
> This does not clear numa_preferred_nid and does not change memory-tiering
> promotion decisions.
> 

Same feedback - need to present user-facing performance changes to show
the impact of this change.

Sashiko also has some correctness feedback.

~Gregory


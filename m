Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6DA46C88E53
	for <linux-mm@archiver.kernel.org>; Tue, 15 Sep 2026 09:24:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5040C6B0099; Tue, 15 Sep 2026 05:24:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4B5686B009B; Tue, 15 Sep 2026 05:24:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 37D5D6B009D; Tue, 15 Sep 2026 05:24:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 0B5356B0099
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 05:24:08 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 93BECA43C2
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 09:24:07 +0000 (UTC)
X-FDA: 85215460134.06.575410A
Received: from mail-wm2-f12.google.com (mail-wm2-f12.google.com [74.125.225.140])
	by imf01.hostedemail.com (Postfix) with ESMTP id AECBC4000B
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 09:24:05 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=HiRFRV7g;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf01.hostedemail.com: domain of david.laight.linux@gmail.com designates 74.125.225.140 as permitted sender) smtp.mailfrom=david.laight.linux@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789464245;
	b=JnzgrGn/qqVcOiy0fD/cQG7ypg3JViW2B6FOo7IaV6BKRd0DqjxOJU31Zd6Jx2tUiA9/iA
	6pUECeGhq9jbG1f5ZONoNSlQTlCqShi8wrLTLPK9k+7kiTOjzZoIqSyq/lyvCxGsM9hHLu
	r/llb3USuyoUjDxsQ4o39ZMPCVWVddc=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=HiRFRV7g;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf01.hostedemail.com: domain of david.laight.linux@gmail.com designates 74.125.225.140 as permitted sender) smtp.mailfrom=david.laight.linux@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789464245;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aLdhT2Q1x0+krLh05Drnda1oX9PUv34jY/LmETe5rwQ=;
	b=v4Ff6d+47lzG2EGq9duYc09IsqG70frntjfY1v/vWDGrxmTfJcTilkdsjh++tOTtzs1yvE
	drg3iKwm6w5J4iPeb3U6tH8rnZm9//eS052Iby5QtBj41Dr3FRMXRK/XbUFI0Qhh/sXWOU
	u2iJhpD8ygxBwh/VqE3hIHjOqekX4cI=
Received: by mail-wm2-f12.google.com with SMTP id 5b1f17b1804b1-49b912e2406so12226815e9.1
        for <linux-mm@kvack.org>; Tue, 15 Sep 2026 02:24:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789464244; x=1790069044; darn=kvack.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=aLdhT2Q1x0+krLh05Drnda1oX9PUv34jY/LmETe5rwQ=;
        b=HiRFRV7gjrz2429NxDANTTeNdz28+n1e9tBArQkRToucEhescfT8yoCnOeDh0avKl7
         XmzVQIvTF3VcB9Qwoh5v8kZzqIMqF8Ky10TlDIXL07DYbphP4bIndBu20hq6TsnMXDxn
         XseLSNwkiox85qW2EhEIWxJQJ18LwUKlv9EayW7sdkgBJ0dNBnXn/9jfCLkECU1OrBi2
         KY7iXmWlgVqP9zyR8Q+u+/GytmCpMVBFCcFOQ7ZV/Zhrpxp7hmM+G1wTS5YSRAYQjSnK
         p/AvznQ+23W4F9VT6BgpxcP5Y7+W/dMuYv1mMlIsPq92DYVQ1H1aDwUNdD/jI8rEKfbK
         XPVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789464244; x=1790069044;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=aLdhT2Q1x0+krLh05Drnda1oX9PUv34jY/LmETe5rwQ=;
        b=PWlJD/qs2IdlDtSoBVujPjGBsbYT38CRzCv1G69bLtrmcTrvknI/8WSiBZfIET5TXS
         c+GDBPeCP5rXQ5kVUBcE8GdEXRRMyIiKOyHY9CsnGISib4hpfk696AJhCVgt5iwaf0Fg
         6dI62yVeWfRcqUfNhGdxzD51DqVv534Gveq39PhMv4jtIAzFqct2FouIE3x2YzIdcZxO
         ILIZAeP+cEaJZBVNycavfyD7Tym2utqGXfmPL8lJ/z58tRJDUQaIVI/3xSjl6ZyftbLa
         rFrpS0ZlKRwUN0PUsFuvChPIJUHJwlfUqH5obNEVa4Sl7rhx4V0yoEQjW+CgbkVqXKSp
         e3ug==
X-Forwarded-Encrypted: i=1; AKwUvBxdSb6jEKv2sz2fiTsjHBz4q93kk6ZPcJUfhFjaQKIKIB/p/2FAahp8VWHtJRh3kEfrF4qjubFgJg==@kvack.org
X-Gm-Message-State: AFuF++kyWVqMXL3+ia94tRBkf92GNdZWq2MgjXZGwcDXVdXvHVAygPwa
	hv0Wv1a9clh/3nArP86cjbILF++/PPxTDq/6lz6Xoeq3AA5WafdrZHEl
X-Gm-Gg: AYBFou0H1SdyvGCZwIfL9zxyQHsaX5/PQ1kGeV2TpiKW98vGHUYXGMblWY1MS4PYBDn
	LiQct3EpqiASfxoYHDGKk2NxUlH8J3sBM+GJSnbnxcsQXQDz6cDkNmsPTKAnCDAAY90kTlzM+VY
	dFBtlbNvpNCWJnpidOpRP7OCcZ/mtJTfwyQ9pVsSFvuS2VO5rNmgjR1S9VkfJdU+4Z+heQr/Lfa
	PT4guBdEvcagM/0QR1ldq3lMGuu5oFwaezP8r3gj487sRVy6b2kF5lB4NIAOFx6hBYk5quIaYm0
	MvLWcnPET8/VQ7skyeBLSR+JFBQbL6X8IUiI/cEtPk4Fj1ixeWAYT09hSWy8P2tW+fYsd08tMMK
	1WV6eZ96vVghfOAw6tWJ5fc7A9qoma1Tldg2HCsSk3gbeGZN3l+TbyEoDdS+y2RL+LGwxyZkiTa
	gfLUX/aTVhsIXgZ7wuH52ioh6HHfd2ki9ci266fJAjrkIae/HdySBbBuVnY559/qLW3bvpnr6H5
	Kv9fvAKV9KORuj49GP7ES2TrkJah1IHLB0C
X-Received: by 2002:a05:600c:c162:b0:49e:65f2:db64 with SMTP id 5b1f17b1804b1-49e7d72b000mr36925425e9.5.1789464243970;
        Tue, 15 Sep 2026 02:24:03 -0700 (PDT)
Received: from pumpkin (82-69-66-36.dsl.in-addr.zen.co.uk. [82.69.66.36])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49e7ef9228fsm49333445e9.15.2026.09.15.02.24.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Sep 2026 02:24:03 -0700 (PDT)
Date: Tue, 15 Sep 2026 10:24:01 +0100
From: David Laight <david.laight.linux@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Yury Norov <ynorov@nvidia.com>, "Jason A. Donenfeld" <Jason@zx2c4.com>,
 Andrew Lunn <andrew+netdev@lunn.ch>, "David S. Miller"
 <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, Jakub Kicinski
 <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, Matthew Wilcox
 <willy@infradead.org>, Peter Zijlstra <peterz@infradead.org>, Ingo Molnar
 <mingo@redhat.com>, Will Deacon <will@kernel.org>, Boqun Feng
 <boqun@kernel.org>, Waiman Long <longman@redhat.com>, Dennis Zhou
 <dennis@kernel.org>, Tejun Heo <tj@kernel.org>, Christoph Lameter
 <cl@gentwo.org>, "Paul E. McKenney" <paulmck@kernel.org>, Frederic
 Weisbecker <frederic@kernel.org>, Neeraj Upadhyay
 <neeraj.upadhyay@kernel.org>, Joel Fernandes <joelagnelf@nvidia.com>, Josh
 Triplett <josh@joshtriplett.org>, Uladzislau Rezki <urezki@gmail.com>,
 Steven Rostedt <rostedt@goodmis.org>, Mathieu Desnoyers
 <mathieu.desnoyers@efficios.com>, Lai Jiangshan <jiangshanlai@gmail.com>,
 Zqiang <qiang.zhang@linux.dev>, Onur =?UTF-8?B?w5Z6a2Fu?=
 <work@onurozkan.dev>, Kees Cook <kees@kernel.org>, Joel Granados
 <joel.granados@kernel.org>, Anna-Maria Behnsen <anna-maria@linutronix.de>,
 Thomas Gleixner <tglx@kernel.org>, Juri Lelli <juri.lelli@redhat.com>,
 Vincent Guittot <vincent.guittot@linaro.org>, Dietmar Eggemann
 <dietmar.eggemann@arm.com>, Ben Segall <bsegall@google.com>, Mel Gorman
 <mgorman@suse.de>, Valentin Schneider <vschneid@redhat.com>, K Prateek
 Nayak <kprateek.nayak@amd.com>, Mike Rapoport <rppt@kernel.org>, "Liam R.
 Howlett" <liam@infradead.org>, Lorenzo Stoakes <ljs@kernel.org>, Vlastimil
 Babka <vbabka@kernel.org>, Jann Horn <jannh@google.com>, Pedro Falcato
 <pfalcato@suse.de>, "Michael S. Tsirkin" <mst@redhat.com>, Jason Wang
 <jasowangio@gmail.com>, Xuan Zhuo <xuanzhuo@linux.alibaba.com>, Eugenio
 =?UTF-8?B?UMOpcmV6?= <eperezma@redhat.com>, Sebastian Andrzej Siewior
 <bigeasy@linutronix.de>, Clark Williams <clrkwllms@kernel.org>, Nathan
 Chancellor <nathan@kernel.org>, Nick Desaulniers <ndesaulniers@google.com>,
 Bill Wendling <morbo@google.com>, Justin Stitt <justinstitt@google.com>,
 linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
 wireguard@lists.zx2c4.com, netdev@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, rcu@vger.kernel.org,
 virtualization@lists.linux.dev, linux-rt-devel@lists.linux.dev,
 llvm@lists.linux.dev, Yury Norov <yury.norov@gmail.com>
Subject: Re: [PATCH 00/17] Treewide: enforce static storage for object
 initializers
Message-ID: <20260915102401.3c56aa95@pumpkin>
In-Reply-To: <20260914231418.b15ec01f7225cf460f6e515a@linux-foundation.org>
References: <20260915030336.1192299-1-ynorov@nvidia.com>
	<20260914231418.b15ec01f7225cf460f6e515a@linux-foundation.org>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.38; arm-unknown-linux-gnueabihf)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: AECBC4000B
X-Stat-Signature: b8wfpsd9ge7d3myqks9sc19nmckgp4nk
X-HE-Tag: 1789464245-211293
X-HE-Meta: U2FsdGVkX18ibjE0CqpmmHbwQLX9J4SUd6PfSO2gvp66b1AbVJbJxlLY0MmMxmbNMP8a1tzClcSxvRtLYoEu/QZf/CAWf+/R1thqOm7S6W8ClG8Pf3mcrGHk4JxmTe02HkDOaKkBykVw6MCirzmjDxCl+yEipoLJDa5LLgY/wG51HO39l4PFZDyZ3VhTSut7nTaMtgOrpYMfMXPSOjpo2uiZ+OR35otzBQZDGRXRQzB0jSiy47zIjJq7hnWkG6ZOTP2eZze8MMmXQUWfetPwrLTQCb0m9FWIBDfH/wPARDBdMhL4jUehgglvLGIriEEGD2Ikz80poSh8yDe7GvP5QBwdbjmkBf629mqJTuqBzDrnNsmPH8cZeGY/05fjCN1tXdzzkbPfY9k6F4d3TYjAdqUE+Os34mJDt7AglMbrULPPj+kXgA9jIbdLBLJeIOUDtl+BENjaqyzR1P0+T+hkb3DWLdMYfd4g9VdiGGbe9KJgZ+5G9scwBN1MAkNNljxoHGJBeS63jIz0tLQRd0kcpiYjgBW3wUEoOhLmGFD6q/LnHqJ0G/exMKQCQMD1gJiejt3qrOz8KIEtZSVpTyPoH0BVBHyYGHgMV0iCFPYpBgj/e6NTvSAuc0jzuBxNifd4EwXib4+1B3gN7SfTPwv8iGZLMXt5SJG870VArmQ7CyoB1ZZVyQy1EehvECUQ8GRc+glARYZr/nRjhBUBscBQi8G9odwvoIV1+1P068XaQhuJequXEXKw7xu1kcnoPcgI5wV1BDyP4hXfbKQw0h3Z2qPadV4sOZC4pryx+iRpbYQ08/91LdL4F4TzNgBo0AgW9DqmR2SxzWrKBj3z17uOhXTdD4x+3iNKuhFXlgJ5g7C4lnOVrBy87OaXS4s3sai+ZpOSRoTYdfjuDQh+4FnOXfsb5e5JxAGJ+6ErJ0qvjUvpTxoSR0CmI0FTyTJ+4cIL6jXPgL6FcI9kviDBDbH
 UXw2gY9T
 HEKxpz3t1xOK/QLoKoWBBMS5T43QfB/LC3C8QGx7Akh+aag7pZN6CZFbjGkIUn/gaJKoAivwAof7o/A2b4MJoSjLpUftK16DXCTh1mwFzYVvXebKM3PZM3U7tbkIyaEjM5UOKq1ZbJ/NRy1mUXBytKuRODnrZuBc4ePTIh9hIDUahby+m8lVkbuODaxMO/L6QXY3ASABWx3CdsW2NlH3JBaA/PH+Fq+clMQpgyUPpjQMvzTgH4kf8DOq3gcb/Or4pQ937Leg1l1Ur7o0M7nSVmSiUm+LQxRcKJuunASGAsB7ybW3Vkd3uyFdfb9wb6ViHc19nEBPR4uthvFwPnoCDK49xLU5PlaK0ev4ZtjImIbNSoCR7jPKLBconLOEpOO0xj+Hl7V1t+HFS8ws35AF4uLqcVgJrp4/xKS0lTSElzSdoWq++z70/UqKcZdwUX66I5R4wrUGrkzQTO1Cjz3Jx/FH5bwFfhJRs0YuY0rQZa5IAM1Dhvw59PCkHim9PN5oRNnztpyDFtugWaHnNneciXCjc7NR0ivOu/shmrEBP+CY0M6OFJ3s8naI+Hf/ILil2yYDZL2KG4zsK9yrJWwZbfWPHMA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 14 Sep 2026 23:14:18 -0700
Andrew Morton <akpm@linux-foundation.org> wrote:

> On Mon, 14 Sep 2026 23:03:18 -0400 Yury Norov <ynorov@nvidia.com> wrote:
> 
> > Declaration macros that statically initialize embedded locks require static
> > storage when lockdep is enabled. Automatic objects must use runtime
> > initialization so lockdep receives a persistent class key.
> > 
> > For automatic local objects, lockdep cannot use the lock address as a persistent
> > class key and reports "INFO: trying to register non-static key" before disabling
> > itself.  
> 
> So why haven't we been buried in reports about this warning coming out?
> 

Are there any code changes outside of testing?

David


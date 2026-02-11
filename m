Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B784AE9E302
	for <linux-mm@archiver.kernel.org>; Wed, 11 Feb 2026 13:02:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E8E0A6B008C; Wed, 11 Feb 2026 08:02:32 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E3C326B0092; Wed, 11 Feb 2026 08:02:32 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D13E06B0093; Wed, 11 Feb 2026 08:02:32 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id C00F66B008C
	for <linux-mm@kvack.org>; Wed, 11 Feb 2026 08:02:32 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 50B6A140357
	for <linux-mm@kvack.org>; Wed, 11 Feb 2026 13:02:32 +0000 (UTC)
X-FDA: 84432189744.09.AF008DA
Received: from mail-lf1-f52.google.com (mail-lf1-f52.google.com [209.85.167.52])
	by imf03.hostedemail.com (Postfix) with ESMTP id 1E9912001A
	for <linux-mm@kvack.org>; Wed, 11 Feb 2026 13:02:29 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=NBuXSgFt;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf03.hostedemail.com: domain of urezki@gmail.com designates 209.85.167.52 as permitted sender) smtp.mailfrom=urezki@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770814950; a=rsa-sha256;
	cv=none;
	b=jSX/acI/wKTXIHlqPtjhZ/68s1ftoj1oIOFTgPia/uD+vZrQ+En6wcNX309TdrEuDw0h2/
	Vn9Wc2Fvog+hG2LVL3QcDOYR8Ajht5PmHgBv0Kk6tEYFvZiW41brBl0bMcH7biactt/7wA
	9MNTvntmMLdoLqWYkD/vdATTuj9hhVc=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=NBuXSgFt;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf03.hostedemail.com: domain of urezki@gmail.com designates 209.85.167.52 as permitted sender) smtp.mailfrom=urezki@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770814950;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=deALlWWmUYhI7Qq/UdLZZQ3FMP5Fpo1V2LM+cbD7E+4=;
	b=bB2mh9NkC4Y33rNXN9Ym3R5R6ZUwG9Tp4RLbNMw+GUY3EI+G4t/GLNGpV/+cQbD2aaCjU6
	wF4Ja6tyKLD8f17aQCNuAYz5+jX5AVvTMcrMthNegxEluTu/R0imNsXOsKE3x+1cLKbkL7
	gA4/unVwYsPIf82RjrtPDmo0LZwIFzE=
Received: by mail-lf1-f52.google.com with SMTP id 2adb3069b0e04-59dcdf60427so1975513e87.3
        for <linux-mm@kvack.org>; Wed, 11 Feb 2026 05:02:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1770814948; x=1771419748; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=deALlWWmUYhI7Qq/UdLZZQ3FMP5Fpo1V2LM+cbD7E+4=;
        b=NBuXSgFt5+XPEzZujYZawSVTgURu3lZSTBIuqexc+49jZZgmUghpN7yBtdrjfolQM+
         pkc3qQQ2/G470S4JcZ1ONFxapRMgE/2NGr1a0PGHFnaxQ+MN7c8tgVUDLeYXGWwxjkcw
         kPR02GNwWCobA4kfYSMPznCJhooSeQ6Cu6P9z0JarVn6cbzoBYSdKXBABJuhC3+DpL28
         I42IiHz9ave6QTKHE5jz387PnJ5RegnBxqR/vWnbXtSA25OMJu1Di4N4iq1itOjK9Rs5
         k8iOMNeiSgyEbUCBo5kcc2VB90vDI3CLtbnU0KYw1SEe89qWIX54pj2RMA7AtUO2Vbdc
         NnGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770814948; x=1771419748;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=deALlWWmUYhI7Qq/UdLZZQ3FMP5Fpo1V2LM+cbD7E+4=;
        b=DcngOhkcDu2bUZ+/J7FkNkRZpwE1dK3htNJghTvkssfQzPS38TjXxF6yZK/NL+0eyI
         6nkpr/SUAaqEQwaueBSXV9kfQAYcp677HvCitnqHAYvs3QnAH5OAzW19au5qhfmkKtc9
         iLUPYOKDJcX2mf14Y8v0bPiMADz2TX3MI74DoFnO8YZioil2pKTge3nOy9rjxBGnaK1P
         Nc9dvba9+RdSiBzycSwa33YPdwoEx+Gtv4XjMZHsfbLfMODOGhN9syZjyPx8WGfA3Pl2
         lHO7jj+J2CkpVd526TVWC4S8yaBWx4wIQO1utTn6ywmNryDFADIt5lhag+cllLfVoOTQ
         4l1w==
X-Forwarded-Encrypted: i=1; AJvYcCVzZs9+g+qbq/f/06J6O6mUHLviAWzbJcyy3ECwWsKKLabDWuAlYOMzi2f7j2zlJGgfLCP9kiJnVQ==@kvack.org
X-Gm-Message-State: AOJu0YwqS/p/pwhI+9rLTVjRywP8kzQTRoAz1NeWD5IfHvamCMtAGC+9
	aBQ+lBeWdhFbIKBKwBa49ysCl7lQhh72qIpXF4wc9ZkWyViqou+s0hug
X-Gm-Gg: AZuq6aJgIMp6Bp4J/qSilUhMqc8X6PiNqgZZpMtt9qaGrzmhg+NyTk4VbJMY+bnxRAB
	Q1rNuq/2t6hwGSDqUKAjDdrP+IdkyYGbh6UvlUHLamxRnRiCSulLWl6WofzmB+a7I9DnK6cSxe5
	NCdrElGPGfRMo5orT8cPb2w32C7447tBcgWbjADkph9XKqtTzUEonX8iMzvEqydfT9YpQPRnuOU
	z74Y3rz/kskoUtQoXMNEtA1AxAq27FQxJ1w5oF8zeEGmAk7kD/0DlmGDUhxVAz2Zu9iqqxlVj+R
	20x6DnfcZvyNCVfQD2HRFoVTIVw4ndNfToXD5rP9kY7yyRAsIE/yIbrmmZvkjjycc4ORMZjmCzR
	KfgXIWkVaDg2+pWfKHfGL1FfFu5fjrdrfv2U7/O2wZ4hwpSs/x4Qoy12u3avSVSDm
X-Received: by 2002:a05:6512:8014:20b0:59e:45ae:7035 with SMTP id 2adb3069b0e04-59e45ae70c4mr4201894e87.3.1770814947718;
        Wed, 11 Feb 2026 05:02:27 -0800 (PST)
Received: from milan ([2001:9b1:d5a0:a500::24b])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-59e5f89a356sm313641e87.92.2026.02.11.05.02.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Feb 2026 05:02:27 -0800 (PST)
From: Uladzislau Rezki <urezki@gmail.com>
X-Google-Original-From: Uladzislau Rezki <urezki@milan>
Date: Wed, 11 Feb 2026 14:02:24 +0100
To: Harry Yoo <harry.yoo@oracle.com>
Cc: Uladzislau Rezki <urezki@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Vlastimil Babka <vbabka@suse.cz>, Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Michal Hocko <mhocko@kernel.org>, Hao Li <hao.li@linux.dev>,
	Alexei Starovoitov <ast@kernel.org>,
	Puranjay Mohan <puranjay@kernel.org>,
	Andrii Nakryiko <andrii@kernel.org>,
	Amery Hung <ameryhung@gmail.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	"Paul E . McKenney" <paulmck@kernel.org>,
	Frederic Weisbecker <frederic@kernel.org>,
	Neeraj Upadhyay <neeraj.upadhyay@kernel.org>,
	Joel Fernandes <joelagnelf@nvidia.com>,
	Josh Triplett <josh@joshtriplett.org>,
	Boqun Feng <boqun.feng@gmail.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Lai Jiangshan <jiangshanlai@gmail.com>,
	Zqiang <qiang.zhang@linux.dev>, Dave Chinner <david@fromorbit.com>,
	Qi Zheng <zhengqi.arch@bytedance.com>,
	Muchun Song <muchun.song@linux.dev>, rcu@vger.kernel.org,
	linux-mm@kvack.org, bpf@vger.kernel.org
Subject: Re: [RFC PATCH 1/7] mm/slab: introduce k[v]free_rcu() with struct
 rcu_ptr
Message-ID: <aYx94NTsLfQyvflY@milan>
References: <20260206093410.160622-1-harry.yoo@oracle.com>
 <20260206093410.160622-2-harry.yoo@oracle.com>
 <aYxXE6CC0XQr1KNK@milan>
 <aYxdleYc7_TWj9To@hyeyoo>
 <aYxfumz5IlwBDS4n@milan>
 <aYxnfk6kCZ66CaOJ@hyeyoo>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aYxnfk6kCZ66CaOJ@hyeyoo>
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 1E9912001A
X-Stat-Signature: ksehrb3h1pdpizhqmb14rme7k9edyoes
X-HE-Tag: 1770814949-540351
X-HE-Meta: U2FsdGVkX19Dsidn9V2EihBRpL6+jZbk5xKZKwVfecZUV7YdrXzmIPMWi3QlB54DE7vWZXeXvK8EerlwdZSGI+vWnyrByNDHdyFJsxtjfU3NPIgZHNBG7h8YunUpA9ranQ2dWnkrmizbH8wmn3KGJs1A3XnBIa+qm57vEqC6TTR0egL/mROgOLnv8ok3dMH3R1pAcQdgHi2E9GvKyXJoYqzhLSuFmO2jRQ5uzO2QD34r2SOVQ5yj7V8lkoAGaMa7YjCMnKyXuDTDMsbzAASfx0GO/MGAkaDckSGRDy/EUkaTjZ3SIz4gCqEP5bBbiveshgPYAOMpPPJ8VoQsYeuhmXUlVBfYFP1LByZiqTmxPfn6ISyWN5EbxC9qUd4a1C+OhAtIIkwThy4yQmLgqETRZtnHDnBhRu2w8XcJr/5IWxuNCLGNa8OvL3XaxUl4Xc7qhb57VrQTNI/i3aLF0fRyBIC+NClEx+h/yBZomJKqyQGcvrBIR+jus+DvAWqFcDgoDBqBBhN8zzDAFHwwxCl6tqZnc0uxt9HGoV3MKa3+B7MT8iY3VCSSYodV3BXNicwvXlV0YebjonUz6wfFRTmSOpfvBaSsUgWe30jNC4RejcfHUm7sYrTe0mxXr/6XQheIf6MWOvhDSd8CJ/JFi6eoVXvGzMQQVRRQOhs2DoDhiGVinlhxqtACs37DHHAKEeinalRJm2SOByefd/q+357ZAuZxLwBsPHg6kvZpoEkTdSCJ+yCFP/AXi2MJrutWcz4fjJlesuaEidd9CwOhOdkva7u5Ea7XeIZE5QmuY6TJz5qf7Cka2A7ogmUIBYlKLaoMfJ5j5ts4a3uS/gHyiQ+lthSywc35bd7GqE0HHj+1eTp57v47Zk2tGkdk9pYn3UQamEgERM/vFyudYwMJsFuxhgJNdZmzUEbZMfQ/XxTwgqUhvFduv7LAPOpvPWlTl5JeBYvg5+IEhbG0DdpoXU9
 SxrooxOA
 9iu7kocD7Rk+uWpMOP9vPDcjKcgDXaic7vjXBB81RxB9tpIdERTelUiV3HdJrMUXKYf3sYolIe+6RKTDXlbVwElF+8cYO2HGu7vgYsVj7pqZurGxEB0uqA+sf6FCz+0iN7dUg/5HrsaURaNeJiS/DQTn5S2G1cy93z7ZNEbYHHeKa7UDUEmXGzhAw5Co+NQNfw1ancMwL80NvgVJAruHc7qkDSeciT6tjfkcTo5xxf6vnNlM/oSc3ZHSgeAjZp4Jj4E6+RSLhANX2gdFhX1haN8NzYWxrbqEaM39h6LY8ELk1yUEkfrRLhSfqeaRn3+MyoUI4E3UTaNrl15iwHu8ny510qbIz1WjRkeVrxhXdloinnk3s68hwI7VhG6bzzVxZTfJnwzQuLQFkRO3UPrknfDd5IzkWhsDqcjecNulWjUdwPf3Ws6/DCWpm/L4OxPVZhKAnjLDQsIPFJk2hTVolAJYBQECK62QEjmR9nmXy8gmC2UMfUy1TYq4Kg1cKJGG/5cFLLt4siyoK9CnHJEKLQ6q27daDnETzp3fDrAvLrMLR1D3MdZHYySCtyizCT1OJtAI9I2TiSCDPWhWPNO9ZQdiR8Q==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Feb 11, 2026 at 08:26:54PM +0900, Harry Yoo wrote:
> On Wed, Feb 11, 2026 at 11:53:46AM +0100, Uladzislau Rezki wrote:
> > On Wed, Feb 11, 2026 at 07:44:37PM +0900, Harry Yoo wrote:
> > > On Wed, Feb 11, 2026 at 11:16:51AM +0100, Uladzislau Rezki wrote:
> > > > If this is supposed to be invoked from NMI, should we better just detect
> > > > such context in the kvfree_call_rcu()? There are lot of "allow_spin" checks
> > > > which make it easy to get lost.
> > > 
> > > Detecting if it's NMI might be okay, but IIUC re-entrancy requirement
> > > not only comes from NMI but also from attaching bpf programs to
> > > kernel functions, something like:
> > > 
> > > "Run a BPF program whenever queue_delayed_work() is called,
> > >  ... and the BPF program somehow frees memory via kfree_rcu_nolock()".
> > > 
> > > Then, by the time the kernel calls queue_delayed_work() while holding
> > > krcp->lock, it run the BPF program and calls kfree_rcu_nolock(),
> > > it is not allowed to spin on krcp->lock.
> > > 
> > > 
> > > > As i see you maintain llist and the idea is simply to re-enter to the
> > > > kvfree_rcu() again with allow-spin=true, since then it will be "normal"
> > > > context.
> > > 
> > > It tries to acquire the lock and add it to krcp->head, but if somebody
> > > is already holding the lock, it re-runs kvfree_rcu() with irq work.
> > > 
> >
> > Check no_spin on entry, if true, llist_add, queue-irq-work. Re-enter.
> 
> That is much simpler! Actually, I tried this way during the initial
> implementation. I like its simplicity.
> 
> But I wasn't sure about performance implications of the approach
> and switched to current implementation.
> 
> It'd be nice to hear Alexei's thoughts on this; I think he'd have some
> insights on performance aspect of this, as we have something similar
> in slab (defer_free).
> 
> > You might need to set-up interval to prevent frequent bouncing.
> 
> You mean an interval to wait after queueing the work, before it gets
> processed, right?
> 
Something like that. Not ping a scheduler as soon as we added an object
to be freed after GP.

--
Uladzislau Rezki


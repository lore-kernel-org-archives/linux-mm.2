Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DC4EDC5B56A
	for <linux-mm@archiver.kernel.org>; Tue, 11 Aug 2026 18:19:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 86B426B0096; Tue, 11 Aug 2026 14:19:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 81C556B009E; Tue, 11 Aug 2026 14:19:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 70A726B009F; Tue, 11 Aug 2026 14:19:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 30A906B0096
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 14:19:20 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 9E80CC01B1
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 18:19:19 +0000 (UTC)
X-FDA: 85089800838.18.71F7040
Received: from mail-qv1-f53.google.com (mail-qv1-f53.google.com [209.85.219.53])
	by imf05.hostedemail.com (Postfix) with ESMTP id A9F6F100016
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 18:19:17 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=ziepe.ca header.s=google header.b=CaT7o8PD;
	spf=pass (imf05.hostedemail.com: domain of jgg@ziepe.ca designates 209.85.219.53 as permitted sender) smtp.mailfrom=jgg@ziepe.ca;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786472357;
	b=4fpl6EPOwoYIWjlacMTM3N0Uyg/Ixw/+U/fMG7v5+VoKxWQJj36xoeU7xtX9mQRLF/Qcft
	AHiHTGBOyKFKmuObqLcEW+pWTlyxLcUBt4V8HY2UbR0AbXvHfyvvPQi/icThLZ0hRndLWL
	9uHWxoip867JIB8DqvPIM0/xPx+znXg=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=ziepe.ca header.s=google header.b=CaT7o8PD;
	spf=pass (imf05.hostedemail.com: domain of jgg@ziepe.ca designates 209.85.219.53 as permitted sender) smtp.mailfrom=jgg@ziepe.ca;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786472357;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7Juoz6itPiwLzS63SjvZr3Uz5ivFoN4JzwWEODeoXz4=;
	b=VOUc5L9B53b1NK5vj3i+lbQnnDeh3ZiSdDC6k9WQ5cfL99T12ZDdF0t7LLPO/IjnT56s9E
	qkrK98r6nJKFppkv7WxbB/TaA3zLeix6slY3FJApOUXMzdz4LTobfaSQEjSNQNshAey72k
	xYzT7Iv2cZkCtPjdljwCLp4vDEmAozI=
Received: by mail-qv1-f53.google.com with SMTP id 6a1803df08f44-90898faf46dso931906d6.1
        for <linux-mm@kvack.org>; Tue, 11 Aug 2026 11:19:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1786472357; x=1787077157; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=7Juoz6itPiwLzS63SjvZr3Uz5ivFoN4JzwWEODeoXz4=;
        b=CaT7o8PDQYgXBb+e/dWvfoksovtaj57bLqQkOkELNEj+Q3942m3zp6BJ6Jr8RWnEzf
         E2CI6uJEEEcLQoHAsBhuOReQfAO818CoWAg0KbwM2dPib36YdetnoiTrQrwI1OunBSYA
         +ahkrMvMJQutdqgtpmkVTEEaYFQgZdqR5yLRD4TodTf5yvqJ4FEFMwW4JPtZew6/TMsE
         g4xM2k2wdtirObNLqcudbfQ2mkbG8OvWbwsqsd14qbJ5zYgUfkV5K3NoqktbccRIPeZS
         0rGvnNYQQKujLBEdFRoo8nSJ8grA/2O5NXhomQdeTNgVIES7Hg+LIN/LS6Ywq4oXxZiZ
         EYxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786472357; x=1787077157;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=7Juoz6itPiwLzS63SjvZr3Uz5ivFoN4JzwWEODeoXz4=;
        b=Iy1oU3G/awPUIiflCoaPfhM92j8ulYdk2edEj0tcyX4ZFNOA3gHZjRho1GmHFdhXX2
         9FGksM19hEpW/95lft2fWmIjeYPYa/7BeWeV7JF56IqFzX1PM8WSvOPGdpWRhQbqhXJl
         12bmXMFu4PZNTaTo7ObSLx805KNEvB7vOGrkvA1RPOP73DtSFQCubiCN0JhQum4Wc82Q
         hTxvju5eBxCgJRXM2IaafAUIjv5CZguanx2BrkZnsZhgZiXJhjVRmfnJDWF+Iiu9uG4s
         Ef1DBX/9iPJ2xjswYg8njb7cCobe24Qvw3Y8J8GlM/171iBylK8uOBPbAE+Yyc922mk9
         VDAg==
X-Forwarded-Encrypted: i=1; AHgh+RrvAjpMul9+932IMZFb2uBf9mnVjhqDNG1SjRvTBrdVg+ezWEo058+8iBjxTAuvzEml2SD02MY46g==@kvack.org
X-Gm-Message-State: AOJu0YyFGFzblmFldl+U0aCjiZiwLNGZTua/96hi9d9lLEtLkL6eS3kp
	3X3XYXK9j7OJD9TcUJhb3fv3C6FJAdKihYlEbsFQ/TYsa299FnzXk70/a1O6pMbH3ls=
X-Gm-Gg: AR+sD11RVYUeEwSN5x48iD5E9VAkWZtRezYlENs7pNkJOK5om63L4trnOwJS7tybYuu
	9UH0w4CpCkVBkxOFPDTjpjwToMSUxA/AxYrAhympzeuHVtWfVzXrYY7cZ3YVerE4nhKL/i9o3nF
	YkfOpkZh9VVz8wuwGyE7M0jJMSRLB+Z8VlTazWI8REjb8n0dt9jxoOgYrUnDSmvQDKjmkD6c9RX
	ed10Q+cKNOn2tvTox+RpySgULD1SQpMSdGUDZN7Suh7XLicur6R0Qtk72lokCXODxet5dPE2nV0
	X5PwFU1ml3uvHtY093kPrYEG+1CfSWUB++MG3j6sLhMn/sXdD8OeqnJieTRe+sV4Add6TBwUEW2
	ktLsKmpsZUFw81ivbx3MUCNtQhws9cPaSs1RDE4FGsn9EqBLJJ65NrCrmQ56nM+rhIpXyEaiuBR
	H9YxQcd/xO2GgisNUhq/KXM6Qkr0GCMfk3gZ7r2ZgNxCBUEGu3
X-Received: by 2002:a05:6214:e4a:b0:908:958f:4db with SMTP id 6a1803df08f44-90a66922571mr43184126d6.3.1786472356695;
        Tue, 11 Aug 2026 11:19:16 -0700 (PDT)
Received: from ziepe.ca ([142.166.156.215])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-90a6c395bc2sm4671866d6.30.2026.08.11.11.19.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Aug 2026 11:19:16 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1wtr4F-00000002kR7-20cJ;
	Tue, 11 Aug 2026 15:19:15 -0300
Date: Tue, 11 Aug 2026 15:19:15 -0300
From: Jason Gunthorpe <jgg@ziepe.ca>
To: David Woodhouse <dwmw2@infradead.org>
Cc: akpm@linux-foundation.org, david@kernel.org, mhocko@suse.com,
	rostedt@goodmis.org, bigeasy@linutronix.de, simona.vetter@ffwll.ch,
	jglisse@redhat.com, christian.koenig@amd.com, paulmck@kernel.org,
	seanjc@google.com, pbonzini@redhat.com, linux-mm@kvack.org,
	kvm@vger.kernel.org, linux-rt-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/mmu_notifier: Remove non_block_start/end() from
 notifier invocation
Message-ID: <20260811181915.GO544626@ziepe.ca>
References: <20260811162423.GL544626@ziepe.ca>
 <f33571137d2e3973e440d09c7602edaebe08b714.camel@infradead.org>
 <20260811172627.GN544626@ziepe.ca>
 <B25708F5-8425-4075-8D95-5E2A00C933DF@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <B25708F5-8425-4075-8D95-5E2A00C933DF@infradead.org>
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: A9F6F100016
X-Stat-Signature: n9k6mk1x87drummca5xfni8we4xdw46f
X-HE-Tag: 1786472357-606819
X-HE-Meta: U2FsdGVkX18oC3Hhb4I2bDWCxtzzP1GkBN+hVlW1wDaQuR2tNj3F7rePUQIPqZ6XzUkg0inCHRh2nxBxm6No6HgBz9rNzYp7/feM7s49B87mlMylHKZ8Htr+mgssWMpkDl1OT2yYcRK77m2CUGecJ82UDvybO6wBui51UdroIv+bQz3Z0VGk6VFcbVy/dpF+C+6fcY8wYFPe00ITzn9stt8PiknjOESoVFnFjjsfhvZITj0MSeasHRk5aiU1+2FQWcu5YJi2Ldt3KAHDVdNG2TVVHWO5kA7eNszkom1zllIrPzB3B2WCHpf3oi2rfK91W3tot+1GzMgdFJ71FJ8EhI0bOHvOa5m3bHvALu8XBEIm37rRuIyN/D1cuHW3WwlscGNJcK8qBdE1/WVBhrZf0dC8wQ97/uY/xQ2mK2+IOTdZQGXwFk64d+2TyfOOimSb/tYydJhiDghpQ7snyliNVPiA5iTjQAy+6zwltIVYlVRPdl1lgbqA7WD0DMKByQ6cnZxKqxQAAieZwbiueMAL54acmKdrylZ/xzbqv7LKi3GG7NtdCocg6TwRBpcI6xMW8GJZOETAIiD22rEIiWVSNX2EugTjvHixJyy8aljFSrKB7gNm5pux02Sha8paWnU0Pzp3oSqJgwfm0CTbnu0iDcXAsCQ/PM82u9BtG6tANpnoE5aQtoR5V3jTNpaWBUQFVnEWPFH899scdEhgVo2ZpgacoMxIaeZ9dlm4Q7yP5ShSH3xvsvbJiWZYxGL5N6yXhzmFuBXiNp+m3qBFKQ5FJ+W6F9TnyHK6NX8Wt6yPeHSIV2Anwk8PvtuoEksw21HNyTPEZMTACbUu9DAGdde6OZD0L0G098W/oyUWb13t9DmVObiEA87I7hB76DvA3GdHZNh+cUBJigeUE51R8I0iWyQI5YFhBZNsVehzpYrGl4r6GVuSmBsWg3YBtrFdcoXyFOjrSyGkaTqWSgIOV1I
 0iffr1vu
 yEPrjVrs7JAZ/cC9fJGtjjWr7ZcjTsKIyRQzepjpHZ7t0Q0wwuJqkDMjr5Jk31uPWOY+Q4oZ2OHJsRyG2sCRwqj2IZVl6cMiT7oMweYILgggYN9kwgr9do68caaMjzXR8PGJThEfRkAN/XQeW+nkV6UTEFfnXz3ZeUKT+wVjXnmcldEY7e2vilve/eUw7HNggLyKXyuMfnRRYkWgNZRsrIPC4LzODv1TUqwSPQ1HgIPPkEr08Jm5FVUDrkZR/XvQBU7CIkzn5QVvWLABX5y8vOFpyVkfrbxnqsD4ZU0ou1e76qeGCToQaVAswc/aIHSASgcaAOc0AnRMxYLQrlOzBOTVotEDKa00DNCKpVNaCS73xzoAIGm82+oHthpGMBGZ3RoiHEclzfax70Ww=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Aug 11, 2026 at 06:59:24PM +0100, David Woodhouse wrote:
> On 11 August 2026 18:26:27 BST, Jason Gunthorpe <jgg@ziepe.ca> wrote:
> >On Tue, Aug 11, 2026 at 06:22:12PM +0100, David Woodhouse wrote:
> >> On Tue, 2026-08-11 at 13:24 -0300, Jason Gunthorpe wrote:
> >> > To be clear you should not be using any synchronize_[s]rcu() primitive
> >> > inside the invalidation callbacks. These are well known to have
> >> > multi-second delays on loaded systems which are a completely
> >> > inappropriate performance characteristic for these mm callbacks.
> >> > 
> >> > This statement has nothing to do with deadlock.
> >> > 
> >> > RCU is always a trade off, you can make the read side run really fast
> >> > and the write side is ghastly slow. If you can't handle the slow write
> >> > you shouldn't use RCU techniques.
> >> 
> >> The multi-second horror stories are about the *global* RCU/SRCU
> >> domains, where the grace period has to wait out arbitrary readers all
> >> over the kernel.
> >> 
> >> This is not that. It is a dedicated srcu_struct, private to one VM,
> >> and its entire reader population is a handful of KVM fast paths that
> >> until now were under irqsave rwlocks.
> >
> >Are you sure? I've never heard that srcu has those kinds of properties.
> >
> >If its so fast you should just propose a non-sleeping version and
> >leave the notifiers out of it
>
> I've got torture tests running for correctness on the GPC RCU
> conversion. I'll throw in some metrics on how often even in that
> pathological case we hit the wait case, and how long it actually
> takes.

Well, to hit the bad RCU cases you need to usually do some other
workload too..

I guess srcu does have some meaningful functional differences, but it
is hardly guaranteed to be fast or non-sleeping out of the box.

I guess you are making an arugment that if SRCU critical sections are
atomic themselves then the synchronize could also reasonably be
atomic. That seems plausible, and may be worth some additional API
surface on the SRCU side to expose this use model and drop the might
sleep that is causing the trouble.

Some sort of "atomic RCU" that has a slower reader but a faster atomic
writer.

I'm much happier to see a formal API under the notifiers that has
strong properties of being reasonable than KVM using SRCU in a way
that just happens to do that by accident, under the current
implementation..

Jason


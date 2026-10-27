Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 44CCE606A322
	for <linux-mm@archiver.kernel.org>; Tue, 27 Oct 2026 11:32:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gourry.net header.i=@gourry.net header.a=rsa-sha256 header.s=google header.b=Jh2pV0sw
Received: by kanga.kvack.org (Postfix)
	id 36D1A6B06BB; Tue, 27 Oct 2026 07:32:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2F6FC6B06BD; Tue, 27 Oct 2026 07:32:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1BF6D6B06BE; Tue, 27 Oct 2026 07:32:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id E86F46B06BB
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 07:32:03 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 53531120A13
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 11:32:03 +0000 (UTC)
X-FDA: 85368192126.06.DA5E78B
Received: from mail-qk1-f178.google.com (mail-qk1-f178.google.com [209.85.222.178])
	by imf28.hostedemail.com (Postfix) with ESMTP id 74414C000C
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 11:32:01 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=Jh2pV0sw;
	dmarc=none;
	spf=pass (imf28.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.178 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793100721;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RdtQZXTbTiwwiCOERJQ/97tzbS8/zwPttXhgydj9WAE=;
	b=K8QyuQIHxL4AjRk85QxIQOOpFHtqSjyB6+t2oExS5pMmqZmrAo37VYkn6a4JFInOGu0AXJ
	7Li7fXaFfKumdRyPKhQX7/LFi05JD1pFnRqbbnra+VBpXcZ6u+kwkA4UDC0iV4KDie1Jtp
	zHrneIJFGysf0MWE/R2G5ML/o8tIqh8=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=Jh2pV0sw;
	dmarc=none;
	spf=pass (imf28.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.178 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793100721;
	b=iuQPOCZPBqhGJDHXquMkgWLoA/YaqP6w/Pzgzvz9Yy4n57Mzdg1RMjMqzhiVKBXEaQBdZ2
	s3sMK1sQ1rooUZUF0qln09wxAXbVIygfhzOnaj0V46RhHXdz4Q7NTHE0JVEZ0AVnzkOIHO
	HTSrioFCCG8sGJbM/3eztCKr0/yGSfg=
Received: by mail-qk1-f178.google.com with SMTP id af79cd13be357-93f269e335eso417863885a.3
        for <linux-mm@kvack.org>; Tue, 27 Oct 2026 04:32:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1793100720; x=1793705520; darn=kvack.org;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:content-type:mime-version:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=RdtQZXTbTiwwiCOERJQ/97tzbS8/zwPttXhgydj9WAE=;
        b=Jh2pV0swdfLsv52E0zyc1iOAOeWZ5HE3F84YOgg+/NUQguN5D1gGEh/SBrvxT6Orwy
         myv4cv2Bs5bU2ZVv3J9yLfZ25hQiAsyJUEIHm+eCF5BccUZ8tMpJYqFdnWacj6xxbH3J
         vg0rDx3zb8HwJEeQZ+YXaucIDjg2BLVQ2CXBY+WKigr8n/xDembHyq65DxrFIZgDuzay
         eYqOClpzkAEmndWdxNoSEL8FLRbzpQGl34//IgtQCiRukGpQ75EipqXaFp1ox36gSWbD
         CRQiFNLn/LBMJB/4JSWM7fL7sbHyipCCmGIRhf9vbCXqUnPVEHB+11YnKyhsoH2woOnj
         xjqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793100720; x=1793705520;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:content-type:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=RdtQZXTbTiwwiCOERJQ/97tzbS8/zwPttXhgydj9WAE=;
        b=GdELpjRaPBvJCAJ0fEessQv8rzPUJlsehT4YLbmUTibZFJSi7Urzk0njfhaVIw1a2V
         9kj3rnDrc7Pe5VXt2Ggydrj6yyaZbiFF2YwH9pITG1r8rSGMEPOp4O8bO3D8Q+ubERf4
         07pfHrqSCDgk+86/6haWjpzdUER4DA9DDyyfcyljyGJiqL6xjW5MJrwNc7iGZEYYHxXi
         kxFjw627vYdfruKGmihTA/ymD8V/uIRrU5VherDFy2JiS4sbzgbi0ih09kgrM39vYC+B
         rqkCNZO7G4QaP5MhxgUASH4Tg15G3MHsyt+jiSuHURTFppTCXxob7IiZhHOKyOkBqdrK
         gGqQ==
X-Forwarded-Encrypted: i=1; AKwUvBwKtMrP8mYbilPD2psIPxn1OpVeeIuK2Kfmb90hoxmyd90RXvIrLW/82BRbT78T2Wrx2rqZsbTljg==@kvack.org
X-Gm-Message-State: AFq9FYIGgAblJ6SsVTXdsyrDsP1mERNtvXiXMQYWhJcs6MjE9s95RbfD
	f9Y5qcfGSCw4UNHgD0Y7TxJOi0Lq7k9hUqmYLuf4LvDLx5kxC5EEgt2B6Qn8eDXtV93KhDJFX/5
	Bb0HQ9bE=
X-Gm-Gg: AYBFou2jy/l6uHMrOvrBn4XsqHxkpi6thkY92/z7ZrrVZ5W1W+g3JbXZS02Q4+AVjJq
	YWb4UGemV6K9elGVJYsi67LLfKxeV5z1ZmcqXlLdQgv4d9iHD/xWTNdDllqQyFap+1ECfOUQgVF
	T308bIHnMnym6ArQ4OmZDPouttHH7Gqof5/3h8q4neCd/2E0gAEso6ZMcyOjC5FGH/33CUhzWFl
	Fjv14x6WuCkCzwBJWG6TkbFgC+hKpDo8FYwRyvfKY1TwKofnxHljxZVjgbUy2islggak6Elv7Mb
	s7jMk5PhA4dB9nA6mlixoCHWmk3HKino29Ypq1pSUpCv8oRq2bypx/D1WWE6f5Bj4Wu3CAqwBJ6
	/z9v9wEJuOypHZD9KZ8A5gbMsZE00y7BGIVTp16NXUdQaOweFu6Az2zAWjRynR6N4AS0yuZViCh
	sIRVnr6ofEg9bZubbQV5U5t9JzrwQZwVYfKQLlFje+h79gnmw3/EvXqqDT5I4Nh9czvDADXuFa7
	/80AnB2RcMcVDTDJD8Cw5cFQY55MR4llBsGysjqU40ZDz5GnBtELMJTnaXuyvA4oTp6ZYy1tATr
	3IXQ4vQTp7/PSFAh7NaVO+1QJ5y7ShLcRPGRtlW/JmJUl0vt
X-Received: by 2002:a05:620a:4556:b0:93e:5cf8:e5aa with SMTP id af79cd13be357-940ef9380d4mr1524401485a.61.1793100720515;
        Tue, 27 Oct 2026 04:32:00 -0700 (PDT)
Received: from [192.168.86.58] (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-91c47a6d598sm99588996d6.3.2026.10.27.04.31.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Oct 2026 04:32:00 -0700 (PDT)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH 0/6] mm: fix pfn walker races with memory offline
From: "Gregory Price (Meta)" <gourry@gourry.net>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: "Gregory Price (Meta)" <gourry@gourry.net>, linux-mm@kvack.org, 
 linux-kernel@vger.kernel.org, linux-cxl@vger.kernel.org, 
 kernel-team@meta.com, akpm@linux-foundation.org, vbabka@kernel.org, 
 surenb@google.com, mhocko@suse.com, brendan.jackman@linux.dev, 
 hannes@cmpxchg.org, ziy@nvidia.com, linmiaohe@huawei.com, 
 nao.horiguchi@gmail.com, ljs@kernel.org, liam@infradead.org, 
 rppt@kernel.org, osalvador@suse.de, muchun.song@linux.dev, 
 iamjoonsoo.kim@lge.com, anshuman.khandual@arm.com
In-Reply-To: <01d7d54d-0047-4eb6-a1d2-5b3f113f26cf@kernel.org>
References: <20261027042204.3741307-1-gourry@gourry.net>
 <01d7d54d-0047-4eb6-a1d2-5b3f113f26cf@kernel.org>
Date: Tue, 27 Oct 2026 07:31:59 -0400
Message-Id: <179310071902.664110.12994053710961856591.b4-reply@b4>
X-Mailer: b4 0.17-dev
X-Rspamd-Queue-Id: 74414C000C
X-Stat-Signature: 8dkq47oeq31357eahndqbjjexpzdkjjk
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1793100721-646592
X-HE-Meta: U2FsdGVkX18JlEAZ8msJxRVDR6F2lImp72mZbKYJVYdGOGcN0kWUa1K5ojfR3f8tac12QEuMDir00bUP1Rhv6qspu4HoTl0Sdi02C0eXpSRXHuehJe5e5JkatcYP0Je1YdQu3pMokf/U+0HdEucbawjeN4XX5kBEbBFO5Nh0r+1bB9jEQuDlxlF2C6Vvd88jD6540d5VOYjfdq3FIHb/Rj/1fymD3sjFvwvDNVwi8YJo8prxDSMVAnaZRGYtBBlEob+G1b1UQ8TEPtbF5u8Sa7g3aHH3LuYOWe4qQAkUMmkXAaGcpCi74L7//UnRaQGhxVTIBZSPzRPziFIKJMjFm3JoqlIq+MHl/R16xHFOM890a9nmyS+DsqPa8GL3iA4DyqrpngEMMhN5qf8dbmwoFDdZw90IiWWBsKxpLW+TPTihgtBQTApNNU+vQwbRMNeeEy4V13/EKZmBoSCO8jvbIjMkGhJ6iosgzsRZ4rsD/KLMKyrwZ5LF8M1QA0o1F+wIebrKfFvMzsDdTw6GQTweqOuQZc9WEkNgLTAovoQyLrqKrys3y1EFkxGdvejJ1Vp9UcMkh0mIPootv6Fwn9ZOwQSzimBl8SiyAUFbUesqtvFNgzUtyyk3jfmFXuZ4x/nfq6fsdI1REUdKc/FBH37eqi3ogBTQL9lyQXk1HmZKFvGw1d6P8jHNFDKp/hzf4WyRv9ZpPtLPKrhDriD3wuia3E9Trvc0p1hEJyxaK+50j5bl/QNlpX2WrwxMq+qbI5v4KWqilTfbia2O2bfpWtXYWMkjoVMOVEhd5hIgekowCLo6N8vaXoUPmJU2fHBydoYC60MyES9dqzDDVw/W6wGaWJ7Jcm8dSWiGqMuY41kHzqh3Uee4CwXea92NW+axqrMRKlQFBYscZoKGXTkfRJWG8X7v7FOHyIcxv0QV8r0yvlHLnvKz5+RbTUHPerCf2GLV/qECtj4H3meXlgIMwFk
 eew65soV
 CYbjLtTRZakXJ4rD7W9SARukodcIGRfJzwjeeAkEfZJf3fhUwq+PVs3Dx2jOMtkQEIyEpxXQR+klxBgcNLxUtm9nLPJIOVzdCYMVwu4KkizeBYl2xeCcqaHszq8CKnmVM4bWXguYVROHKgYbRuMjkFezny1NhjfLe0ODmPYuT0Y7V/qzuHtaFps0aWm2rNhc5qdB3wWObIQjnY1eUfzBWHuCLt9s8a6BzvPClELC3pjOsu1RWr5bTnSlRKhIg7yj2twAvsde3NYgnY4uQaV8Y+eUkckID+jkiNgiPwWtMuK8DLEqntlmqOOv8TthRtNXvBqDab/XGXybc/bs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 2026-10-27 09:57 +0100, David Hildenbrand (Arm) wrote:
> On 10/27/26 05:21, Gregory Price (Meta) wrote:
> > Several pfn walkers check that a struct page is online, then use it
> > after memory offline has poisoned it (CONFIG_DEBUG_VM) or removal has
> > freed the vmemmap.  Five of the races crash the kernel; the sixth leaves
> > an offline spinning with the device hotplug lock held.
> 
> I have roughly the exact same list of AI garbage fixes here from a certain company.
> 
> And I consider this all extremely low priority.
> 
> So this is something to discuss throughout the next months and do it properly.
> 

I actually have a reason for these fixes other than "bot said bad".

We leverage ballooning and hotplugging as VM memory overcommit tools
and are finding that some of these race conditions crash them with
large MTBF.

While most of these are insanely narrow, they are not as unlikely to
happen as you think. A vCPU can take a vmexit in these windows much
more easily than a host can take an NMI or other interrupt.

Thankfully none of these (or the other series) appear to be obvious
security issues, but they are stability issues.

I have a reproducer for every single one of these (and the other
series) - but a handful are unreachable due to a 2-statement read
being emitted as a single read by the compiler (which can be undone
by a targeted compiler flag). Those were included for completeness.

--

On properly - I have a follow up series that fixes the zonelist walks
structurally, but it uses SRCU-fast on the fast path. The catch is that
PowerPC (and i think others?) don't SRCU-fast without atomics, so they
take a performance hit.  (It also doesn't help us for backports)

I've been weighing that solution over never freeing and/or prepopulating
zones - but this also results in performance impacts (leaving dead zones
in the list forces the allocator to walk them for no value).

-- 
~Gregory



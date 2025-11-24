Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9B1EFCFD313
	for <linux-mm@archiver.kernel.org>; Mon, 24 Nov 2025 03:04:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C8D896B000D; Sun, 23 Nov 2025 22:04:52 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C44046B000E; Sun, 23 Nov 2025 22:04:52 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B541D6B0012; Sun, 23 Nov 2025 22:04:52 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id A247D6B000D
	for <linux-mm@kvack.org>; Sun, 23 Nov 2025 22:04:52 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 32F2387249
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 03:04:52 +0000 (UTC)
X-FDA: 84144008424.11.34B8349
Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	by imf27.hostedemail.com (Postfix) with ESMTP id 7C96740010
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 03:04:50 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=VracKje+;
	spf=pass (imf27.hostedemail.com: domain of rientjes@google.com designates 209.85.214.175 as permitted sender) smtp.mailfrom=rientjes@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763953490;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=Tx6vA+CxqxOX7GajzPYCWsYXtugWt0/CKtc430xokd4=;
	b=wGeRGw796CZTU1Do1bhwZnitJ+I5x5jZkXXfnqF/+B6ZFLXBEH6+XwKrjuorAY/okef4jv
	4f2PlMSE5H8u1PUYpOxR3BddNwrSkiNEE8oVCFCojS9HXwBrVEhpB56VFNaWKQveUOYFJb
	/ZLAWM3sdqKpm/48eGJgorRbWz4Yqi4=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=VracKje+;
	spf=pass (imf27.hostedemail.com: domain of rientjes@google.com designates 209.85.214.175 as permitted sender) smtp.mailfrom=rientjes@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763953490; a=rsa-sha256;
	cv=none;
	b=0Q+G/4cCSyXtenMV1NMhb+ZvEkxWdQ1ZH7evgpFeVL3tfK8/9QOvNoG7ilQp/V7ikdqQAp
	LXVnCWmzHI+D+kXjN7tCPiTgcWH7yu9duFtvMknaZJ7JfW0E2Ih5/RllSI2sojI8QsliDc
	Lt6IHgSg0nwrQu6Mp6edZNyoAfn4XD8=
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-295c64cb951so268975ad.0
        for <linux-mm@kvack.org>; Sun, 23 Nov 2025 19:04:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1763953489; x=1764558289; darn=kvack.org;
        h=mime-version:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=Tx6vA+CxqxOX7GajzPYCWsYXtugWt0/CKtc430xokd4=;
        b=VracKje+fuOP5/RXWkxlLV8wehwr4m2BMQN7rOR43sA2pD3IEGT6z6Q45Y1W17GPu2
         ZDvYmjLZDVxET48JTyOAtTzkjAng1ptYhUtqVkLOQPUhcnu7W3I7W1QN7V4P2cByxgJZ
         Axlu//V7WGfOV2alFswktyXYVKRmxrZygQYZ1WaWNIKTaSUkAmrkWvGmOCkPefI/iI6K
         zdDh7LxA3YVeqD+8mN+g4o5EZbsM9MioVsbcn0Vln+vFL/ubLIWRa5goQdZVa9RazmTt
         1srcT1+NmIgPQjEv7bymtFZTiMJ/z4bPgVgLoMVxv3FnLUdihzmy1RpF2gcXs6F6d9m/
         DolQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763953489; x=1764558289;
        h=mime-version:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Tx6vA+CxqxOX7GajzPYCWsYXtugWt0/CKtc430xokd4=;
        b=kx+OEp9Lyx+z1XhG9nvXRNerd9KvzJhaTWKabtC7YWw9m2TvlD4izHGASPXqIexQXU
         C5uQkTf4gFMcB8odpBn9gbii1/0EspvQDLjiyMpsfLjggg5r5+vaG8rcXI0Uvu1xa0yR
         0+fYz9upmnVIdiH1XKwr6mIWMNfTxhc7lY9oBKdWM0+7vhcf0JEhznLVptbfEQuWekYj
         1NkSH2GwEE0Z+XZv+k3R+V1Mkp0FRzdEdjTdBXy9Yyq/8mduk+TIUGEvfoJHf+i8XZEO
         UdzSknSXZFsLvzhS6xSAG2wt9sl9SSCbC3sytcQGk8QLiCrdshrGysLpJ5hg+jQa37gY
         RxFQ==
X-Gm-Message-State: AOJu0Yx9QEUjj0rgD9eJskjnZyaVRQf0uA36ePxOZdgPlkj4v7HXWKRr
	EZyo8wT/Z0ZvPj9ykFHP3PC1qpnQIG0s1lToqQIPz7mCsZY5rpzOclQk/TD69z4Fpw==
X-Gm-Gg: ASbGnctW2Yad2JUGGhkcCMltK9Kh1DgtdASK54sh5xfd+xp7v5xR3wQtdTM4KAvdqwb
	3uPMEwOIlzsm8u94dPP0Jw7FGrPhmkC/JO53uGGrstNdaMb2XwNmo3/qNfqdkkkr9XTKFbml57c
	9FWcPoOkJ26x4xnzM7CbJVTKDVQPLZj6bwCpdbMUl0mHmzp3Qy45dv20y7fi4DnJJWZkMcPwOQi
	M5HedR7y93cKVwshApkHMRdSv+P9YxWwAPXC8ErKSs6jhxBDrXAQF48MNa9gEwFvFoAEl1HU/9J
	8iaziaAHdqhqLuqNN//dKl8hFuGuZbJBORpe6Vo0J4eE8lwE4rV3T/NpE/bTQOf27VwE1/+0aQl
	bLoD96aYFeLfPsnocJRlZyH7zuPOhCH2iXlPBTKtF0Zdpyr3RegUasnxBc/7oHbneIVuhhrajmd
	diu4qm65i12ZooV1gdebce1E3PRqBvb8wDVPyUZ49bqAHp2k53xo3Uj/IlnaV4Vck0yj/ryzTUv
	7gYFILgnCQuBbxH96+xEZ8/3roNxTry6eoiNt6tng==
X-Google-Smtp-Source: AGHT+IH9XBqwk4wJv8CSX+PLeLD3bG8PCvotbTjnUOQ8lZOwvqgKa33mbVqNr/HU/wVdej/qZCRyuA==
X-Received: by 2002:a17:903:1ca:b0:291:6858:ee60 with SMTP id d9443c01a7336-29b7b0e619emr3779525ad.4.1763953488905;
        Sun, 23 Nov 2025 19:04:48 -0800 (PST)
Received: from [2a00:79e0:2eb0:8:1390:945c:e006:77b2] ([2a00:79e0:2eb0:8:1390:945c:e006:77b2])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7c3f024ace6sm12886381b3a.34.2025.11.23.19.04.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 23 Nov 2025 19:04:48 -0800 (PST)
Date: Sun, 23 Nov 2025 19:04:47 -0800 (PST)
From: David Rientjes <rientjes@google.com>
To: Davidlohr Bueso <dave@stgolabs.net>, Fan Ni <nifan.cxl@gmail.com>, 
    Gregory Price <gourry@gourry.net>, 
    Jonathan Cameron <Jonathan.Cameron@huawei.com>, 
    Joshua Hahn <joshua.hahnjy@gmail.com>, Raghavendra K T <rkodsara@amd.com>, 
    "Rao, Bharata Bhasker" <bharata@amd.com>, SeongJae Park <sj@kernel.org>, 
    Wei Xu <weixugc@google.com>, Xuezheng Chu <xuezhengchu@huawei.com>, 
    Yiannis Nikolakopoulos <yiannis@zptcorp.com>, Zi Yan <ziy@nvidia.com>
cc: linux-mm@kvack.org
Subject: [Linux Memory Hotness and Promotion] Notes from November 20, 2025
Message-ID: <58dcd4db-a923-0d5d-37eb-1a539f1f275d@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 7C96740010
X-Stat-Signature: u9bpbnp63xhcsuaofb6kn8bh698aw4u4
X-Rspam-User: 
X-HE-Tag: 1763953490-944147
X-HE-Meta: U2FsdGVkX19RwgnP2Pr6Od/OS2XLr2OfSdvjJ+gPztn8sVuJUaqnDFBAKjNGBphtsIvD4fl7kuqjVB7mHrEV3Fsau7SBEuqhYRL89LDC7gQRblxDqjxpvgj5eeqBa0sHRsKQivIvSBJNJtpqlb0mLw83Lx1r3O0oDSR4EkrsUGkyrEstaBGA8t4ZVwsdJPiWMxZohV8gMZnaV7QRo7Xvx4WkQT+lNYc0a59IlPYwrM8xFCFQ8mKsJTrT/Yk90TcsvSPAvipyhlJSH4v8/wLu50ZTUd8JZjVWNwbBPLRXNrvhmPRFZWWz8X4bjyJUKBNabEv2/1ZepVLKHzMfC6x82YrGgBQ2AofXEwlzErHeRULRTSTbnZYEAbyRRHYTI2fXiwGELOfmpT+8ZErxVaaCnbHe2Ze6eXP1Hyp22ZeaNGSlwXeWDnuMJFHQY4bT8TlGIIHaLQQmiWfzhcTUPTa4Ila4Ou4YSjb3iLaXozOy/NXEHrtnuQksIbaFFEdeVawdyqUW+Wr+a6YTKMLKMArye7JDkwPeM9oRg1jVG6/T1Nvwpmye8aC/nHh2Ju4MYqnwVoKQiWJ3YZKEUmUeCEGpjpD8/2UAyDjPwYFSdBdYv14t0soOpaustSuVAUH7zPRJZ6ers9sXoam8NjB+r0GBsxt8OL9EuhWvqmXPKkWrWj0S9To/eKvUS/lrP5MIsmYRj+ZT+WrSmoJEHP4lX5/gYKs2E3l2kF0FziETuwO23a835iQdvtSojJc6T9z1QRzdO0NhR1EAGKIh1NrCCb4PZWSC8Mm1CH5TMxFtN0mcPCgQx2h9anCu2HEukaQaj8sGXnl5svuCvhsl3vPwuLj6llHzgflhX3Vt7hQ4w4RPo4QykKMMqcjgJYLmkFw8IOipoBR8Tme3Yl27n16W4uiA9zS3Jrr8bHM30d8HaSkJpizE+Bwbgp3Zeh92OymDZ+aXJHtRi3ZYSjj9DXJ82sv
 MZ1vaxyl
 XoXxOHiIZric/bZn3xZ01P4nYindC0nVMK5b4yhQOdT+RQHuWhDuiI26VwqDj7YkSDQNF/qYCXnokVXPwSbiQ5wsTA5bnTbPXptEWVfIsaxc/5sFpLzmTwnzZWEX0DWZ4CyJOQlOwV1Q+HdSiT73gwE5PgEkXD1qJLsMa+m6Jn/qYzqxYEcC1MSSnR7xD0oqwW2p+/HqY389pr53Z7pr4x08WGTXcojrU8tsSgOxRVq0v0uRnLxplzyD7IC/UUjI2VETwPYso/5WuENNOAklXNpGEJkyRWbPVUS7InznPiiMOoByEArtVyYbjOZT91+l9UIy7uNRBzJHaiWTojMipm13H1/t5R7DSd1piTBALIUxN77s08zyqtc5i708/WgCRbGyjt03dRBZpVNuHPkud4B3+Q9SWXJG5OUotXuJbLqfguNg=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi everybody,

Here are the notes from the last Linux Memory Hotness and Promotion call
that happened on Thursday, November 20.  Thanks to everybody who was 
involved!

These notes are intended to bring people up to speed who could not attend 
the call as well as keep the conversation going in between meetings.

----->o-----
Bharata updated that he had a set of results for the scenario that 
involves promotion upstream, he posted this as a reply to his RFC v3.  Any 
feedback on that series or proposed benchmarks to run would be very 
useful.  He was also thinking about consolidating all the tunables in 
sysfs into a sub directory rather than have them in the parent directory 
for MM.  I suggested this may also start out in debugfs until the APIs 
become more stable.

Bharata was also planning on redoing the NUMAB2 support so that its 
cleaner and the page movement ratelimiting and associated logic is 
separated, which enables using faults as a source.  He's also planning on 
using folio_mark_accessed() as a source of hotness to cover promotion of 
unmapped file folios.  He'll be writing a dedicated microbenchmark for 
testing of this.  He'll also be investing additional benchmarks for the 
overall series as a whole.

----->o-----
Jonathan Cameron asked what the general feel was about the memory 
overhead: currently this tracking requires ~2GB per 1TB.  Wei Xu noted 
that Google is taking a similar approach but with one byte per page in 
page flags.  If just for promotion purposes, we likely don't need eight 
bytes per page.  Even NUMA Balancing does not use eight bytes per page.  
Jonathan said it currently uses 33 bits per page so some shrinkage might 
be possible.  Wei said promotion still requires the per-pfn scan which can 
be expensive.

Wei said there would be one data structure with the information so we can 
do atomic updates on the hot metadata and then there is a much smaller 
data structure that tracks which pages to promote. 

Raghu noted that in discussion with Bharata that it was pointed out that 
the tracking of memory here is only necessary for the low tier since that 
memory is the only viable set of pages to promote.  Jonathan noted that 
may be the majority of system memory.  The metadata itself is only stored 
in top tier memory, which is expensive.

----->o-----
We discussed the benchmarks that we should use for evaluation of all of 
these approaches.  SeongJae noted that he had no specific benchmark in 
mind but we should discuss the access pattern the benchmark should have.  
This should have some temporal access patterns but also have different 
hotness in different locations of memory; secondly, the pattern should 
change during runtime.

Jonathan said there's been a heavy reliance on memcached but that's not 
ideal because it's too predictable; we actually need the opposite of this.  
I noted that I've had some success running specjbb and redis workloads.  
Redis is interesting because it does not always observe spatial locality.

Yiannis noted one of the challenges with specint is that the duration of 
the benchmark itself is not long enough to assess optimal placement logic.  
Wei agreed with this, the benchmark would need to run for a long time.  
Yiannis further mentioned that these can be used to over-subscribe cores, 
however, the induce pressure (and consume bandwidth).

----->o-----
Raghu updated on his patch series to use the LRU gen scan API which 
iterates through a single mm, this provides more control over the memory 
that is being iterated.  He was working through some issues in the patch 
series and may need to reach out to Kinsey for discussion on klruscand.  
Jonathan also provided some feedback on the mailing list.

Raghu asked Kinsey if it would be possible to have an API that scanned a 
single mm; Kinsey said yes, this was similar to what was being thought 
about internally.  Raghu said this would be useful for integration.

Wei asked Raghu if his series will integrate the scanning and promotion 
together so that when a page is identified we can promote right away.  
Raghu said this was implemented like NUMAB but does not happen after a 
single access.  There is a separate migration thread.

Jonathan asked if we necessarily care if we lose some information; if 
there is a ton of memory to promote, we can't migrate everything, so do we 
care if some hotness information is actually lost?  Wei suggested that we 
must have a mechanism for promoting the hottest pages, not just hot pages, 
so some amount of history is required.  Jonathan said that if everything 
was insanely hot and we lose some information it would readily reappear 
again.  Raghu's patch series only uses a single bit from page flags, Wei 
suggested extending this.

----->o-----
Next meeting will be on Thursday, December 4 at 8:30am PST (UTC-8),
everybody is welcome: https://meet.google.com/jak-ytdx-hnm

Topics for the next meeting:

 - updates on Bharata's RFC v3 with new benchmarks and consolidation of
   tunables
 - continued discussion on memory overheads used to save the memory
   hotness state and the list of promotion targets
 - benchmarks to use as the industry standard beyond just memcache, such
   as redis
 - discuss generalized subsystem for providing bandwidth information
   independent of the underlying platform, ideally through resctrl,
   otherwise utilizing bandwidth information will be challenging
   + preferably this bandwidth monitoring is not per NUMA node but rather
     slow and fast
 - similarly, discuss generalized subsystem for providing memory hotness
   information
 - determine minimal viable upstream opportunity to optimize for tiering
   that is extensible for future use cases and optimizations
 - update on non-temporal stores enlightenment for memory tiering
 - enlightening migrate_pages() for hardware assists and how this work
   will be charged to userspace, including for memory compaction

Please let me know if you'd like to propose additional topics for
discussion, thank you!


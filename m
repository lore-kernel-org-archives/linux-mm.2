Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B77B3CCFA18
	for <linux-mm@archiver.kernel.org>; Sun,  9 Nov 2025 02:51:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 009808E0010; Sat,  8 Nov 2025 21:51:13 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EFCE18E0003; Sat,  8 Nov 2025 21:51:12 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E12A18E0010; Sat,  8 Nov 2025 21:51:12 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id CE1758E0003
	for <linux-mm@kvack.org>; Sat,  8 Nov 2025 21:51:12 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 653F75B8BE
	for <linux-mm@kvack.org>; Sun,  9 Nov 2025 02:51:12 +0000 (UTC)
X-FDA: 84089541984.05.9FC3363
Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	by imf23.hostedemail.com (Postfix) with ESMTP id A9910140005
	for <linux-mm@kvack.org>; Sun,  9 Nov 2025 02:51:10 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=vSoO2vvB;
	spf=pass (imf23.hostedemail.com: domain of rientjes@google.com designates 209.85.214.173 as permitted sender) smtp.mailfrom=rientjes@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762656670;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=rH/cjvJUOWnP5hvJ4MNMjClZa3FAqzia1bjsOfdPp/A=;
	b=e21F4vqMJpIDh2Ev9wUij6clrb3Ynk4ka3L9sq0Ke2ANsZR7cPXez9ohyO0BvRsKLojyXg
	w3iGxzV8t8V9DdBCrb0YgwZQnGCSmIJWsEToVyDY+3/SXlPYO9BAMx6YyBV2ciV1HuuSrP
	cOEfcZpujjdkR2VkX0axrSTV9t0/BiA=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=vSoO2vvB;
	spf=pass (imf23.hostedemail.com: domain of rientjes@google.com designates 209.85.214.173 as permitted sender) smtp.mailfrom=rientjes@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762656670; a=rsa-sha256;
	cv=none;
	b=yaVa242encQ14nKmHRUStqHWhyPvyS60Sb8VMhXssGRcM+oL5TDaOUczZUAoPP+Jmf6Y8n
	tV66Zl0jy5Wj37VEgJmsRuX1lLXo0aNmibjJQXY3FnzS72g8E8Xk6smXCOlr4Ur9yrYQGd
	Mk5oVQoX6trb9A0sl9HwbKkgQEUXWzA=
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-2959197b68eso147285ad.1
        for <linux-mm@kvack.org>; Sat, 08 Nov 2025 18:51:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1762656669; x=1763261469; darn=kvack.org;
        h=mime-version:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=rH/cjvJUOWnP5hvJ4MNMjClZa3FAqzia1bjsOfdPp/A=;
        b=vSoO2vvB0ZntxOllp5gNAYe7aSLjF2QEt+0oqgkwKXMiDa4wN4lnXGqgsD9PtYPWL8
         qej3JTdnzBlcZaV2meIlg500ABMFDSgVgViANlWNT1VqyqvrK0yLOHM7MZb4k8F7aLlp
         syX+XlRK0yReCMHheDIqmYZH3VkvGiQV7NDzCHw6N8wZa7TLBgtiSOnLiwpfV5qLJWk/
         Xkj+i2R79Vw6wh464cb5GnmF85XBk27jeZOh78SWsjnonOx0ZJZVu7EV9mNGSndsv05e
         njP+c98qiohfHOq1tx/dhBZz26khProJn7Eea6JM61SRW9xFSJzibHgXWU+RbJXJ27Au
         5doA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762656669; x=1763261469;
        h=mime-version:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=rH/cjvJUOWnP5hvJ4MNMjClZa3FAqzia1bjsOfdPp/A=;
        b=XPHCzoS44VZuFbaKvF6J0FUJWP1h/Rzdj/FVoYeuHdnFHPIL7bsCOm2tacZaiOjgyX
         D01J9YjruPebJrQKnCcfoH1m2x+ZObyD0ySZAimBBw00QXJJ0uqsxjLnXjnpuey0mr7E
         C2yfSM9DIu7oWZXKW7XDYLDnucJHEU8f/+AGoxCysd9xNBLKkMqIXLUqbmOvjKlyiexG
         QcQRIyyTmO0eTMEGKPXz/ZX6TvIwUwYVrDi10qIxvGLnf2R5gVBLUvGTUORq56sBiNyl
         D7Wii8E2z4JldjGcm7duiwvlkh527FsZfK8hsBFB1M3JTj8m67clBwtobaKhvgTJ9MB2
         PkyA==
X-Gm-Message-State: AOJu0YxXxtsZzh9TXppixYR5yVgsMVL3Qhj1fwL1vNFNulmZabUrJKlX
	BDEXZVmSWI0+WWJkdCCeeDNqqJEGz8Ti3Sb10FMPTT7pFDLfnwKrsnMUHNJ+LYUGJQ==
X-Gm-Gg: ASbGncvVVxsUejWsUl1qK5NP5iQu+4fvtS+lavxN20V9jSTQSLhEIJ7NQ1DfvBOWHe6
	9sgwUroQd2uiIpWI6WH7su9h19ie2nH0HDBELH1QR4isq7QtyBPpha1rMqE05HKr+WBg8lVsw/X
	Q0kX53KOD5wpb6VEL/5ajFPrl4EVdo2gPQtzX3EK66zCThK9cqoLMCAMZJE5rBheVudrVIkhie9
	YaSIr2rRElx7ZRa9pgZooFaWanERCg985KApjerGfzemPzE9tPxtHZxYcFkKUhq6gk2j98xMFW2
	6dSXaVB52VUy1eYSiJ2ik/w33GSyjRM0DSklFeNUVckSED/175qW8yS3sem7/J/x+JuBuPztxw0
	vbJ5hlS7TBQS4La1oKImczQWbB3Vga0MldizpEUU5z++pLuZKpvxtrh65Zj7CgPjfZ+0Fblm/Nm
	PjjHUeRrUODKO+giDxSjvtaeQKu5nc//oh7p+wqZpGypZPqfTE8q9Sc/scfIuewXLd1c1Kd9qV/
	YKA/MmqA2PhO5ab4VZpxXBdQz4nLjU=
X-Google-Smtp-Source: AGHT+IGjyZDo1w7W8dZnNlylzYmxKkzD7FuEhfJv9ofgZMnOkj2R8OxsP35EkFCvmWueWKg/epDd9A==
X-Received: by 2002:a17:902:c410:b0:290:8ecf:e9f9 with SMTP id d9443c01a7336-297e7bd0859mr2940385ad.7.1762656668975;
        Sat, 08 Nov 2025 18:51:08 -0800 (PST)
Received: from [2a00:79e0:2eb0:8:5a08:8aca:3cfb:79ca] ([2a00:79e0:2eb0:8:5a08:8aca:3cfb:79ca])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2965096b889sm101465825ad.14.2025.11.08.18.51.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 08 Nov 2025 18:51:08 -0800 (PST)
Date: Sat, 8 Nov 2025 18:51:07 -0800 (PST)
From: David Rientjes <rientjes@google.com>
To: Davidlohr Bueso <dave@stgolabs.net>, Fan Ni <nifan.cxl@gmail.com>, 
    Gregory Price <gourry@gourry.net>, 
    Jonathan Cameron <Jonathan.Cameron@huawei.com>, 
    Joshua Hahn <joshua.hahnjy@gmail.com>, Raghavendra K T <rkodsara@amd.com>, 
    "Rao, Bharata Bhasker" <bharata@amd.com>, SeongJae Park <sj@kernel.org>, 
    Wei Xu <weixugc@google.com>, Xuezheng Chu <xuezhengchu@huawei.com>, 
    Yiannis Nikolakopoulos <yiannis@zptcorp.com>, Zi Yan <ziy@nvidia.com>
cc: linux-mm@kvack.org
Subject: [Linux Memory Hotness and Promotion] Notes from November 6, 2025
Message-ID: <8ff2fd10-c9ac-4912-cf56-7ecd4afd2770@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Rspamd-Queue-Id: A9910140005
X-Stat-Signature: f36roxxys5fiyyf5965n8qi957qjocsb
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1762656670-667503
X-HE-Meta: U2FsdGVkX1++oa3j6/QvHLwf85xVhY0vRIk8tIZK8HntHK6lM9bbNmc/H2s9R6XUEVZEVAavlnEKrN3TIiPN1Y4eJBiblHWMVznMqRxbSmG2975sTLZKVOzjGjmsFWfYdnWTHuOIApImV1y8ESUANc9pZE6kwbECvAzS/kd8AJoTuKN0ahLA1fkmewYF73AwJYcYeWfsHmk1tbZH+SYlCZtokh7TlBRa3TATLyjyC+nwHyOl5Ge0n41z7V8skzU5uLzaIPcw1es8WDoQHc0x2rdoIIEgGSuUS17L4zTuQbDhav4jlw2bE7TgoF4oc0a960lkpbdpvam9b/GH0REwAXrPpQYMZekNB7hmfkWu+JdUIPdicZjDgGlIfVA7ffwiD9wi8gYg02g4/d9oiFXBiO3udjFvyYnyNexQ9wp93YEVdVcpz3nBUERcLqwxGAHt6cMGvo5qfSHyIuPQO9TXsw41K7ijskSPKTcOiKlm/e5MjGdMbwWjOdpEreLUbevOreugDi3FlUO1Ov28Dlnj8C/LcdJBj46Rd9CuMNOpduKswm+B+vXEiHd17k/QTLtnp1LeA7qs4cmC1jPmobN8IXI4ZS6EV2B04NhRQjaLC3fMtk+MkYhlziZO31XTploFFCjBH1yitKoFY72F7nmztodBwt3u+ZsKe0of7z6M3Y4r6CKIJaydk9lKBTSjblCxBCotxyB+vBPzd5Y+tCoTem16m1UTnEXm+2L2qaZ7sWHWrrQIoK3jCJtTFPf6wIrVQVGSWIZVMrwPxRv8aDU6ypK12mIBs5n0tAcb460K3YFUWe0q00DAqcb8N/786fdI5q2VESsgKXVQ/3LSr7lh8QO99rO1wSFeciqcdhoZnwuuvZV/zJQUU5c4qUuJ6BtZ6b+n7GI++QzngGXQrNdwDCXzjJOWyaeXhrwfr8em7uIzu9B0sNsiUJDPClPiWKerR4XfR/ipGPbwaQzv2IK
 xa4iEkD/
 Q60oZ/hPtn6LpGWLd8SBkmZkaAlrgGVs6PLvtPkVPBlPJV8pVZ4ATwzphsVBL8HdpKoL/ojVyqD+tpmuQVk3uB64viLEyPA0vght3Iv4FWzbC7Hurn/fPtWlY7cR6UVgBFQHcGD7j1Z4P8+rjLPkfU+kSMH3czeTGhHMoKfQqP9Q/kixaoQB15aWYAJmGGdkztsKBqOgiU9aRzZlSXOLkEkzwamMvmuWwDuE0+Oq3fMnEyvqSFSAML5ZaJiyIz/6r1okpK4YT1k32FPTB3kVYvi1JvHcuNqhxfmil79OS6Ui4+tbHv2aAQ6/LUQGmrM6SSJhPQF1XgZnuVWCizLZXungrK9q4nfQ8fxUjQMiaXHYzzixYry+bKPWO9zb8k7mvWAWI8g8dFLaiysuyyqLeC0Bh6bgt9lVg7VKfmvgG2YN8yjQ=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi everybody,

Here are the notes from the last Linux Memory Hotness and Promotion call
that happened on Thursday, November 6.  Thanks to everybody who was 
involved!

These notes are intended to bring people up to speed who could not attend 
the call as well as keep the conversation going in between meetings.

----->o-----
I read off updates from both Bharata and Raghu on the latest series of 
their work.

Bharata is in the progress of getting ready to send the next revision of 
his series and he's collecting microbenchmarks to share.  The next series 
is intended to go out over the weekend or Monday at the latest.

Raghu updated that he could root cause a performance issue for kscand 
based on feedback received from Jonathan.  He has not yet pushed that 
series upstream yet.  He's also made some early progress on LRU based 
scanning and will have some updates for the next meeting.

----->o-----
Shivank presented slides that were added to the shared drive.

He walked through his methodology for microbenchmark testing: the kernel 
promotes hot pages to the local NUMA node and the benchmark completes 
faster when more hot pages are migrated early.  He intended to answer the 
question of whether kpromoted with DMA offload will shorten the benchmark 
completion time.

To emulate this environment, he created a memoryless NUMA node to act as 
slow-tier memory and then tested kpromoted from Node 2 -> 1 (remote vs 
local NUMA latency).  This environment was close to real-world CXL systems 
in terms of memory access latency.

Gregory noted that with this set up using the cross socket link that we 
need to account for whatever the bandwidth limitations are; the latency 
graph as it goes up as bandwidth is pressured will not look the same.

Results for microbenchmark completion time with and without DMA offload, 
in microseconds:

	Mean (in us)	Offload		Offload		Improvement (%)
	abench Access	Disabled	Enabled (DMA
	Pattern				8 channel)
	random		39114520.00	35313111.00	(9.72)
	random repeat	11089918.20	9045263.60	(18.44)
	Sequential	27677787.00	24576768.40	(11.20)

Overall conclusion was that DMA offloading reduces abench completion time 
by 9-18% (lower is better).

Gregory asked how there could be any improvement here if there will be 
promotions from Node 2 -> 1, but also demotions from Node 1 -> 2.  Shivank 
noted there was no memory pressure on Node 1, which may not be realistic 
(there will always be demotions).

Yiannis noted it would be better to include numbers on promotions and 
demotions.  Gregory asked for memory usage before and after on each node.

Wei Xu noted that you may not want to saturate the bandwidth with 
promotions but rather leave the majority of bandwidth for organic memory 
accesses.  He also noted that since we are uisng thps here, on an access 
we may need to migrate all 512 4KB memory that may not be ideal.  Shivank 
noted that this doesn't necessarily require thp, there were observed 
improvement even by batch migration of 100 or 200 4KB pages.

----->o-----
For DMA offloading for migrate_pages(), Shivank opined that SDXI may be 
better but he lacked the hardware needed for the evaluation.  He also 
noted an upstream series that provided a multi-threaded offload using idle 
cpu cores being worked on by Nvidia.

Using the new batched design for migrate_folios_batch_move(), the batch 
copy of folio data includes a migrator that is configurable at runtime via 
sysfs.  For example, static_call(_folios_copy) allows for pluggable 
migrators (Default, MT CPU copy, DMA Offload, etc).

I suggested that this would be useful even beyond CXL use cases, for 
example, if you can offload most of your memory compaction then this would 
be generally useful.  Shivank said the patch series is currently in v3 and 
is receiving feedback from Jonathan.  There is discussion on the right 
interface for configuring the migrator and its parameters.

Shivank is currently using move_pages(2) for benchmarking directly which 
will use all of this under the hood.  He is getting the most benefit out 
of batched migration.  Gregory noted that reclaim will do batched 
migration and it is generally useful.

----->o-----
Next meeting will be on Thursday, November 20 at 8:30am PST (UTC-8),
everybody is welcome: https://meet.google.com/jak-ytdx-hnm

Topics for the next meeting:

 - updates on Bharata's series sent out between meetings with
   microbenchmarks
 - updates on Raghu's series for kscand and integration of LRU based
   scanning
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
 - discuss overall testing and benchmarking methodology for various
   approaches as we go along

Please let me know if you'd like to propose additional topics for
discussion, thank you!


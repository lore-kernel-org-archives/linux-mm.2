Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7DA53CAC587
	for <linux-mm@archiver.kernel.org>; Mon, 15 Sep 2025 01:37:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C388B8E0006; Sun, 14 Sep 2025 21:37:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C105B8E0001; Sun, 14 Sep 2025 21:37:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AFF038E0006; Sun, 14 Sep 2025 21:37:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 9305E8E0001
	for <linux-mm@kvack.org>; Sun, 14 Sep 2025 21:37:26 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 33EB413AC35
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 01:37:26 +0000 (UTC)
X-FDA: 83889772092.06.94CA174
Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	by imf07.hostedemail.com (Postfix) with ESMTP id 7833E40002
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 01:37:24 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=EhtcbuvT;
	spf=pass (imf07.hostedemail.com: domain of rientjes@google.com designates 209.85.214.182 as permitted sender) smtp.mailfrom=rientjes@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757900244;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=PQlbgZv/FKfBIuoMCrHumpGqtyuSirfU2Ze29pDTJgo=;
	b=cO8gAsZKmp8vB8GvnvD0W5smIFLJmb4DI3f5i41Gc1tSbRIXlUv3Y5VhmrKV2HvpZvRIEs
	nviPnTNROWNjZLQGI6q09hrJAKQ8Wt4nztog4i84h1KvGg+FoLe9CeSIJBwCdCtcWz+l7x
	ClE9HQpPZUBRz4dYwzOXqL9z+eVAB3k=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=EhtcbuvT;
	spf=pass (imf07.hostedemail.com: domain of rientjes@google.com designates 209.85.214.182 as permitted sender) smtp.mailfrom=rientjes@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757900244; a=rsa-sha256;
	cv=none;
	b=My/h3XSTi4BuINAnW/O44UMvFfJOQ25tPiTCDf8aNZuynHcRqADW5VLjF2XpglVJ9DFeLr
	ZqYpsiVDygO8C6MrQby5NDd+5SrSdlQoHmXGQG87q9Bxmnhv9ipPi2cQVZ4D7eZYULAicb
	R595az1KOYU++O3+b5E2OQP6Z29/p+4=
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-2637b6e9149so184975ad.1
        for <linux-mm@kvack.org>; Sun, 14 Sep 2025 18:37:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1757900243; x=1758505043; darn=kvack.org;
        h=mime-version:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=PQlbgZv/FKfBIuoMCrHumpGqtyuSirfU2Ze29pDTJgo=;
        b=EhtcbuvTVBR1GXwwsT/uLpUQsUamFwQc/skYkxdAZl5ImsxQeEpajSwunVgqDEktgq
         wYT3IQQBaMHb7R/2zhZvLJ9O6QU0G77XhEX7mkps9qtGnqXYDSefrvn2sK3ElKPkYeuS
         zBNz43AErq5225DHZ2oSRE+kvP5zvLWybeSUrR6GUM5mFcll7XnJIG3hmsgo8NOz9B/3
         xYXdxnTJZMGXaZxAHxQu23BNJxbzJTdl1UJ71tqaoeqsBoJWHMidNrU+f/i1Xqrt4ZOP
         4At5T/8xpCiIoOLFx1iyTiTG2uXwV74VciB9P8QO7/Eg7lkOTRBIbLFBxW/NbXa0wzRl
         mE7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757900243; x=1758505043;
        h=mime-version:message-id:subject:cc:to:from:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=PQlbgZv/FKfBIuoMCrHumpGqtyuSirfU2Ze29pDTJgo=;
        b=SKYRO6exPqb4Iun2cqqocMOXvLcOHDiP9izlHWMOuX+n2SKopN+LJWkViO678t6Nw1
         cQdxB/Ki/VgHyksGRim8nVilHnZG+WC7pSLVAoFClYvcsX+qyCkxnZ7WJYSnXwCaaJ0c
         vYSEi8Y+olgZqDaWw8clZA2U6zpvzZFruTbYgUEWcSBkg4RykrU8b7lk5iBmLQu8rsyh
         kuvUJBQtX4ghz2Q1qQ1o2rWLiFlEKXvEeDTw4Yxenicy2sUnUB244UywdEbK08EQUHJu
         EUmNKVfSXDoZNtE3TbFHLOHU7urE6HNCkOiWx0A51IfOCtoR90lHars1oVzvwBxbFIBJ
         zPIw==
X-Gm-Message-State: AOJu0YxtXUi+17QDJg9QDPL0owy7s6XiH1oboGo5SAE34XlQTPhk0iiO
	KC9TmJ0lUXrGSj1CcHF9chCK+hQ0cwNZvxjI1w6x7VFFKh2faULbp04GjGd1/qufLA==
X-Gm-Gg: ASbGncvGG2uAcYl1hmvtMU4MVToNdyh1CtP1FlM8YEVYHk2ojFaYGj1iE7GwHEV5v7Y
	j6N6u0nCcN7MW8QhZEmJoj585ulMqpz/RwqqaPXYxe3Yb29jNSZMwlUI7DxwMVlyMaoCA3uRgAB
	HYKPKwI8GSX04rXnUbbXLt1uUr8OjPkpONa77R2oD5QuSebvYMIoosCuDUo00PH9CEglHQsc/nW
	DlZW4JsiZDt3LleuJ/JJT9O5L35B3lipXPhMfBxUrF1gpQSE9MGXYbYgdTAIuTwYucDRrlOTLSs
	skobcaxxng8igMdE42dpwJry8AuyS729pZ/ROXZEs5TUmp6v0eNitk1WzB1XAyZrPwAxicwpdhs
	KK4epSeqldiRry156Va6Kzxkl+HdnTPPGUOuc7TmzAAULmUWoqRhqBSuagmSrWYpd/r/+XKES93
	F45zLbUvN/K2WYXKDoBsXMbAke8NNAGCZTUUm9nXQFFs2OcbmmNEIPlzE=
X-Google-Smtp-Source: AGHT+IFUFDD33CLYpD4m6mnb5edjKAqv1xInQXGnVMof+T+O+DNknxhsPTTOPHEFQkzY0nSFKOHQ9g==
X-Received: by 2002:a17:902:f688:b0:231:d0ef:e8ff with SMTP id d9443c01a7336-260e759b104mr4329515ad.8.1757900241849;
        Sun, 14 Sep 2025 18:37:21 -0700 (PDT)
Received: from [2a00:79e0:2eb0:8:2665:4fe2:6854:b9e1] ([2a00:79e0:2eb0:8:2665:4fe2:6854:b9e1])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-b54a39926c9sm10263467a12.42.2025.09.14.18.37.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 14 Sep 2025 18:37:21 -0700 (PDT)
Date: Sun, 14 Sep 2025 18:37:20 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
To: Davidlohr Bueso <dave@stgolabs.net>, Fan Ni <nifan.cxl@gmail.com>, 
    Gregory Price <gourry@gourry.net>, 
    Jonathan Cameron <Jonathan.Cameron@huawei.com>, 
    Joshua Hahn <joshua.hahnjy@gmail.com>, Raghavendra K T <rkodsara@amd.com>, 
    "Rao, Bharata Bhasker" <bharata@amd.com>, SeongJae Park <sj@kernel.org>, 
    Wei Xu <weixugc@google.com>, Xuezheng Chu <xuezhengchu@huawei.com>, 
    Yiannis Nikolakopoulos <yiannis@zptcorp.com>, Zi Yan <ziy@nvidia.com>
cc: linux-mm@kvack.org
Subject: [Linux Memory Hotness and Promotion] Notes from September 11, 2025
Message-ID: <d18661f5-ba27-35fb-f2ee-a4cbe865b6c7@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Stat-Signature: iscpmx5a978gjndueycyx9ucpsofboyf
X-Rspam-User: 
X-Rspamd-Queue-Id: 7833E40002
X-Rspamd-Server: rspam04
X-HE-Tag: 1757900244-60880
X-HE-Meta: U2FsdGVkX1/djP62ND4o2GuO/5rCumOS6VKIC3mR0Eg2drbVFw6P92erYwY97D+zsE3t8lhZ9bca4nl7GtlWVxTloZDIDHP08CpB9bAKazUt8YK2/FzSO7255m5q5MgSGBx2g7S46hUeO0OJzKLAKt1gExapnnjfu74vimv3KXKO3hAjSDE4y0P2gKajNFkVWVFjCfbR1a51KFBL9GYaFF54qry08NgXwFozndO0YRa1gL+HEtmOm0XNR7W7wtjCvp/U3q0ILPJEx2MSEdDS1AI8IuFAwL6GJMO3uEiiHWwS2GJFMPnrPgvtOc8YSLz9VprVjh/AnEfXMPOX/S0oYcuv6Ku3BNhMvta21wA2/uxq8AWwReG7ZiEFLCpMEjDZmBsw83K4v/o2vPrWynQvAhMxYbwQCQ79i5UPQ6OU96cyAUwxW7MYIbQx7gw26F5UWLkMqrRHD3n5PuLOUngUkqIucELts4NGwvd4wSWX3+umXo/nZL0GcKwSB8+Y0wYn+gL4ek0A+SIJ3l+wgCkuU+ufPcIjGzxY3Banzdne7T45F+6n3tERIl2+pBZd/hD9+jWnosmHXNEk/q/HGuY9yPQq9meOjcvjt7mPC7lIcsCHkKlGsFEzZuqbrLvbQHe+8II2Sb8mSkCEgDJsBf6S8YanG7nZuKES1mCFjqhJyHW6c9c9D7eYKHkw26EUycReAulR/ywnSKUO7TAsO4P5Hv8T7nYgYe5RlVl/f8NhMRovjZ1xvdBwjesTne7TWtAnZynb91jpuPSltagvWNd9xq5xd4+Ll3oBpUavALdoFJwYvzSTf0E+y2ySjtleXcWKyLwzOOtFE5lh1j2HVKjG/dlY3eNrkNTJ1vx8il3i9rIKaQfOq2y1pOroay37kWq5BkmVNcL5eURjmU7A8+Xno1xzUCbbT94A+w2D49q4KwdbDZnY4bgkVtDSrZ4uD7znvAxNcFOysB65jcNxTSr
 hCZo5pwg
 X9eNeLnQL6livKTw+AbsBzNO02aZlBEZ/TO94n8TWrGhhef/cbB57MoPJUaPY3h9sPqyE0dwC9n9Yhbe61GS6gL/ehUPCaZMVe0sjZrTwuAt5BFCFUWpwX8WvcHiUev6YZiADvARbc93B/LGXmpT2Id/VFeWgmezs0UrIFhRer3TzjTX9e/+amx6DyOZYkgHYc+YBk4Xmat8OjAVoxM8mMEcMIuZZvTHEw1Oc+2oOO/RsZ1Z0uw9Q4VMFIN8ZZEL6tq/HEFTy7btILEoyvdS/DDRimcT8XtvYO/+DNwMa0wcvrh4P2GF/JIMR5D3QVDEizEmWnVeY9I7cW7bzx03q4Z8xhEhjEKdPdTg603yOFv7ZiikFRvig+1h1UdlvpdX2g6fXVSEQCwxYqjQIRXpI6c22+hLryT+s29uLFHs9nEVVolI=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi everybody,

Here are the notes from the last Linux Memory Hotness and Promotion call
that happened on Thursday, September 11.  Thanks to everybody who was 
involved!

These notes are intended to bring people up to speed who could not attend 
the call as well as keep the conversation going in between meetings.

----->o-----
Bharata provided an update on the status of his patch series including 
NUMAB=2 and ratelimiting and dynamic thresholding.  The latest patch 
series was posted with three sources of hotness information, all 
experimental in nature.  It also includes basic testing.

Bharata noted that he had been doing testing on Zen4 based systems where 
access latency between remote node and a CXL node is high, from 60-90%.  
So if there are two top tier nodes, nodes 0 and 1, and a CXL node 2, the 
access latency from 0->2 regresses by ~90% compared to 0->1 (access 
latency from 1->2 regresses by ~60% because it is closer to the CXL card).  
Compare that to a Zen5 based system where latencies have improved a lot, 
the latency from 0->2 is ~7% regression compared to 0->1 (access latency 
from 1->2 regresses by ~40%).

He asked two questions:

 - do we still need to provision CXL memory as a separate NUMA node or is
   traditional NUMA Balancing sufficient for this?

 - question to Jonathan: is this considered a step forward based on
   previous discussions at LSF/MM/BPF?  And where are we with CHMU?

----->o-----
Wei Xu noted there are additional use cases: memory expansion, bandwidth 
expansion, and memory tiering itself.  This all depends on the CXL 
hardware itself.  There will be use cases where we want to put cheaper 
memory behind CXL to improve overall TCO.  Additionally, there may be 
additional features behind the CXL controller such as inline memory 
compression.  Memory tiering itself is likely not the only case for CXL 
memory.  Yiannis agreed with the point about handling inline memory 
compression since that's his focus as well. 

Wei suggested that the data structure is key to these discussions to 
minimize complexity.  LRU is likely a sufficient signal for demotion but 
not promotion.  A separate data structure for promotion is needed, but the 
complexity should be minimized.

----->o-----
Jonathan Cameron suggested some folks may not yet have the shiny inline 
memory compression devices yet but also brought up much larger topologies 
if the latencies are this good.  People may start doing switch fabric to 
get wider fan-out and plug even more RAM into the system.  He strongly 
agreed there was a case for all of this.

He also noted there was infrastructure that can gather data on application 
behavior to optimize for memory placement.  This was the focus of the CHMU 
for right now until we have actual hardware.  It was also noted that 
there's a lot of flexibility allowed in the CHMU specification that allows 
for building very bad hotness monitors if we choose.  It's very early 
days.

----->o-----
Raghu gave an update on his PTE Accessed bit scanning series.  Instead of 
idle page tracking APIs, he preferred to rely on PTE scanning and MGLRU.  
He discussed an integration mechanism for the two approaches.  He wanted 
to integrate his series with MGLRU.  Bharata noted that kscand is based on 
PTE Accessed bit scanning information and klruscand is also based on the 
same approach; there should be commonality between the two that can 
leverage the heuristics from kscand.  The goal was to get the best of both 
worlds between the two approaches.  Wei strongly agreed and suggested 
klruscand was a proof of concept.

The division of work was suggested as Kinsey Ho providing an API for MGLRU 
that provides scanning for these use cases (access and flush) while Raghu 
focused on the kernel daemon for this including heuristics.

----->o-----
Next meeting will be on Thursday, September 25 at 8:30am PDT (UTC-7),
everybody is welcome: https://meet.google.com/jak-ytdx-hnm

Topics for the next meeting:

 - updates on latest patch series from Bharata and consolidating memory
   hotness information, including ratelimiting and dynamic thresholds
 - update on Raghu's patch series for PTE Accessed bit scanning and its
   integration into the above, as well as with klruscand
 - how to provide data to the community both on access latency for type 3
   memory expansion devices as well as hotness information
 - update on non-temporal stores enlightenment for memory tiering
 - enlightening migrate_pages() for hardware assists and how this work
   will be charged to userspace
 - discuss proactive demotion interface as an extension to memory.reclaim
 - discuss overall testing and benchmarking methodology for various
   approaches as we go along

Please let me know if you'd like to propose additional topics for
discussion, thank you!


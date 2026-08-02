Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 17C22C55162
	for <linux-mm@archiver.kernel.org>; Sun,  2 Aug 2026 03:40:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8BDFD6B007B; Sat,  1 Aug 2026 23:40:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 86EAB6B0088; Sat,  1 Aug 2026 23:40:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 75DE46B008A; Sat,  1 Aug 2026 23:40:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 499136B007B
	for <linux-mm@kvack.org>; Sat,  1 Aug 2026 23:40:41 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id AF63DA18ED
	for <linux-mm@kvack.org>; Sun,  2 Aug 2026 03:40:40 +0000 (UTC)
X-FDA: 85054927440.06.CD69CF9
Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	by imf09.hostedemail.com (Postfix) with ESMTP id 186F0140007
	for <linux-mm@kvack.org>; Sun,  2 Aug 2026 03:40:38 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=oJ+Wpmc1;
	spf=pass (imf09.hostedemail.com: domain of rientjes@google.com designates 209.85.214.169 as permitted sender) smtp.mailfrom=rientjes@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785642039;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=gXzPGpDH1PjGhAKiF8JCEfjG4iMCfQeA0PRC2XBQVaQ=;
	b=mkq3yMeIWgmBldbEHjPmwdNYEwyzFV96j2Icm2eQSv2q0D2jPtIkOLq6DA4O0FwFk7rAX9
	37AJRgAaYK8hmib6o2JX6SzAfLPLgCQBbUeYqEpTNAKoTGnAxQ1eUUUE9K3s5otUaeJA+j
	2KLqGcJKwJgGM8BeFnmEvFrK0C2bUj0=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785642039;
	b=q8lkLI2qfDbXzWly1V2KBthi8RKE9B6sX8ovYlqeU2XZPiFJw8vogy/+UbYhXvADL+GZcV
	SOibVJd3thJ00IBFFXMwvkYZ2+gujwXELkm418Vru8pyOYcyt0RDqk5mUBkFGGczljC19q
	m/kv9Tq0A+rmXOHA16eigsEBU9LptNM=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=oJ+Wpmc1;
	spf=pass (imf09.hostedemail.com: domain of rientjes@google.com designates 209.85.214.169 as permitted sender) smtp.mailfrom=rientjes@google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-2cacef7d299so48195ad.1
        for <linux-mm@kvack.org>; Sat, 01 Aug 2026 20:40:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1785642038; x=1786246838; darn=kvack.org;
        h=content-type:mime-version:message-id:subject:cc:to:from:date:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=gXzPGpDH1PjGhAKiF8JCEfjG4iMCfQeA0PRC2XBQVaQ=;
        b=oJ+Wpmc1TlAMbq/fn8pMb0W3pt8FpuzGTV3IrDHbxKPK3fNZNPvox5pyiwTkQw5Dsv
         pxnjgNnaOIrJK6CN5H+LaOK0fi0JJcwBts96wZZP/nGODVOAwhmBqLWRAPM1sCOyL7KH
         W8yBpcsboK7sXUyRHaRGJqKrUXNkdnAIwEVO9ZtK7s7R7X3ynHBpW/JL/qjjgOuK3lJF
         Wqbd1wBXQdZ2EI9vpBbjw30EVMI/ASsnvLtEOF3TAW7sKvKfe01U55yFfq8nvwPdoMok
         NRF7vdvKZrVH2ldbJkRLppBbnBMASansvsd3mW6JRfn5NqLVYd+JVM7NmgDytnZbQbyh
         jEVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785642038; x=1786246838;
        h=content-type:mime-version:message-id:subject:cc:to:from:date
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=gXzPGpDH1PjGhAKiF8JCEfjG4iMCfQeA0PRC2XBQVaQ=;
        b=lrUAKVNv0DBx9TYgMQIDHO/xA+PciuyouIlq3hRuz8oyLTPJZtjvUVz+9/tFyHZWhw
         8TiTkMpod7DLMGwuwA3Tq+KYPkJM22dJRf4a7lLkWdk0Fp4KDSZoPa765k+0lrMFR7Fh
         SCSzO1iajjpYG3zhmos+tTEBYkf7SRbLy5QbFtffLncR0jg7RiAHYQCnnhvlX/ON6ORp
         jyIqE7QW535GE8fbwsovpxoQZ8yWSkM/MxUFPDE+hLgwxi+xwISz5RAP9rp3UziJoOnc
         k5Q3T4FBD6CHtQrG0uk0p6wS8USjJ1UGncxJjpkqEYF+5l/8YSeBRpfzfqONJkrS5rCa
         4h3A==
X-Gm-Message-State: AOJu0Yxra/pChx6YiogXFM89qIPplW5RQDvhPmnGMz9BhwN1Bn4gD3tg
	Qspnd8QFOQzZX9iFrI8vxyUzY7ERjGKyRCuM0SNFeWoLExDhHZtvB7QDsGKPjgJQCw==
X-Gm-Gg: AR+sD1028f5oLa8oQ3e4KzSgAZDR6SM/VpI0K8cE47nkYB4v2f9lMTjtqEv51Jwpk1z
	aGMgCgTgBIVOJy5jI6IbJKvSqtB6bgy45tTdSfPMKSUOk90xEdo/wsq9oTnN3rXC1qIneuh9opd
	Q5OgEqDwT6naVD/UNX2LKyodlN/HCyR6QkYhPUgnIvvj2AoVHzISJHspfXyl8wkO77xoVTBNHWA
	ynEZ/Rfra5RxZTj9xxVbsWx7wjQ1Be94lZBFwHCIPqYIAV7Xj7OgkeBUVbspuSw6Q8iqHMaVdk5
	J8BjC2w2tGBkcDTCsbcrCF6qkG6Vq5VG0GHHBXMC/srMGwRWPoNkH0YSNtOvIF6YMCKiHuKztrF
	38XJovkKtwlhABy2yVYNQnRPLWLHa+HjdgieFmsCtAID4eLDOBUtm5L/RpNyvjoKr4TFSc4IU4H
	PR9RAoE1RG3DpKxAAQD9Xn5Mke4YLcJtdkTkQbtyu0lzvN+nLqKtuC94hsvi7xMUsC1xdOBDuon
	bdq15sTj2cCboTG73q8b8rkG3Yg9mgODdfI2F+Q3qWvVYGwI/9xt0xtESQ34Ga8K2N8nBd091Be
	olsE2x4cAsU/SYw=
X-Received: by 2002:a17:903:1746:b0:2bf:3579:cdaa with SMTP id d9443c01a7336-2d0547c39f3mr7176595ad.10.1785642037054;
        Sat, 01 Aug 2026 20:40:37 -0700 (PDT)
Received: from [2a00:79e0:2eb4:9:4825:2ef8:8f3d:1924] ([2a00:79e0:2eb4:9:4825:2ef8:8f3d:1924])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-84edc51cac8sm2169122b3a.56.2026.08.01.20.40.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 01 Aug 2026 20:40:36 -0700 (PDT)
Date: Sat, 1 Aug 2026 20:40:35 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
To: Davidlohr Bueso <dave@stgolabs.net>, Fan Ni <nifan.cxl@gmail.com>, 
    Frank van der Linden <fvdl@google.com>, Gregory Price <gourry@gourry.net>, 
    Jonathan Cameron <jic23@kernel.org>, Joshua Hahn <joshua.hahnjy@gmail.com>, 
    Raghavendra K T <rkodsara@amd.com>, 
    "Rao, Bharata Bhasker" <bharata@amd.com>, SeongJae Park <sj@kernel.org>, 
    Wei Xu <weixugc@google.com>, Xuezheng Chu <xuezhengchu@huawei.com>, 
    Yiannis Nikolakopoulos <yiannis@zptcorp.com>, Zi Yan <ziy@nvidia.com>
cc: linux-mm@kvack.org
Subject: [Linux Memory Hotness and Promotion] Notes from July 30, 2026
Message-ID: <fe8acbf6-a631-c280-55a3-3a6fbf248ed9@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 186F0140007
X-Stat-Signature: jmruxwjxyjcqs9aesm5eresd348a8x1p
X-HE-Tag: 1785642038-802501
X-HE-Meta: U2FsdGVkX18vxWhLnK7wFco48hwQdcAR5YJlGeuNNE8cxVwnfeuoXj46ApPZ6CY9nwQ9tnQ8WUVc3ISj+Z9724sn+0GuqhzLQTIMDVQXHI+7QaFzFCJexW17Tb8R7pCAKJq7netF5kkji4rHgT3rfQN2xR1KcRTVIwJM9zvaTyEV5oWqhbcmzRpj0AQ7/+X1SaWIODgIJ3ntNJWpqU1BQ23oeUPRJz//9ejPvkjJI+D0hle9dROqFVN0HgtpSIljj9ArGJttB83WzGmcoj53N/ZSbfB5o7YqiKA7RsNQoR6a6ffwtVpqggfMofZNbUaykNyHoYVXm+cKP9PmyQCySnUzjwBwlsXzoPphztS3AB1xyhSBOVtaIFj0baev9/fLaAb04J8RLP6Gghqs8PkojY+HtjRo6qzMt4ywlC4TernkEbcrQOlFVlWW1Vl/NvGOHmSvND+pRK6CbD8yVqxl7gmbcpgNTChT8VGWxLnq3MZYMsZcJ8WN/LmivhNLiyNDzjT7jRej9QaI10BoO08Fs0MN5IclEOlPZ74E/fAq4iP8mPqpAI2s+iw9qdXQ/M2kByVdd8jj07KejllLcb+Lf1QrhJRb32yCxdAQ9fLMlcVNdCR/yBgBI/Wj+adcq1OjpCATGmGzFdThNtBLo3f48qQNl4/wM8/p0Otj5TT+8OwrX/cmfySRBdIGyiQa5vvcu+7/CZIsosW5pBj1Nhu0wR8kVbT6FslxuTWIq6o9bs3IS3S+g1m54UHEIepVO7D8qPzjwszQKgUd2tjumKOqLUQvv9boYzrkpr9ertf4x5o13mr4FoxlnSR8aWSTMQFOszdwzDN5Mt2CMQebsokc1SNSH8RVI+jznQGy2o1uoyA7EvQTb2+K4rOyFkZuvEW1G9bJguoshCkiMg/rUutEaVcuMP4LXeLhqiXwa56Vx+9xXvVecAi/jFN5pbPx1ERfxdZNlktTj/Aw+W6rwel
 L1NsqJy0
 fVeXp2FAdNI7ocW7VdHHEAlyip1iZj/l1mQnSZfHwuNXopUhHy+qMqtIxekBNWm+u0E5mXxX0Y9W3tex73PCySl5DFOu5zlEoLzTHc2XXOLafTegLvNO/rUsjId8cP+7PyfOMVGQtEvNeu0GBGacYfXjhKJRzxgeGC+8/Fo0TWFklMPne5eXFkbPiG37xem4S6SoSZsyrVDxXaK37GfYPcpcSRytuhk7pIVclwXe3h0KNpW48Dz/SrHOaPG/jQXcwoCuTs/buLHnhQZna5d1vUmcg62Uhy5X1lSJTn9lC+3DzMYS9OTDs+2Ypdnf8PUVkscQMc0KYf5Nn1igzWIbPbgqJ8UjY4edlfoH3lq4t4GFvBDiCixbe5vyWkEylsC/QJntKI33sjkrDeyxt2WQn6np8a3ATWj/mcN1PocTK+EcBuQjFjvfIpIH+M1iNthQwJ5MOwHaiMt1J2hyAKRaNvcpPz04QHMFbNJKbgUWnoZpSUOQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi everybody,

Here are the notes from the last Linux Memory Hotness and Promotion call
that happened on Thursday, July 30.  Thanks to everybody who was involved!

These notes are intended to bring people up to speed who could not attend 
the call as well as keep the conversation going in between meetings.

----->o-----
Yiannis updated on the status of non-temporal stores and working with 
Huan's patches to handle memory errors.  Yiannis preferred Huan's 
implementation and would like to fold that into the patch series.  He also 
added the Kconfig that we had discussed in the last meeting.

Huan asked if we also need to support ARM; Wei noted that in the latest 
upstream kernel that there was a switch in instructions so non-temporal 
stores is actually the default now for ARM.  Wei suggested applying Huan's 
series on top of Yiannis's patch series and Yiannis agreed.

We agreed that the patch series should be combined into a single series.  
Yiannis will do this over the next few days and then will be going on 
leave (congratulations!).

----->o-----
Bharata updated on the status of his v8 patch series.  He has posted it 
with some numbers and did not observe any regressions when comparing NUMAB 
with pghot.  The initial goal is to upstream the support for the tiering 
subsystem regardless of the number of page hotness sources.  Thus, the 
upstreaming story will be about clean up and refactoring to support 
tiering; David Hildenbrand had suggested that the current approach was too 
extensive.

Bharata was also looking into performance numbers asynchronously.  Gregory 
had been vocal on why this patch series is needed upstream, but any 
additional use cases and support for the upstream series would be 
beneficial.

----->o-----
There was discussion about what overlap this work had with DAMON.  DAMON 
was noted as being highly complex and we reflected on previous examples 
where this was a similar story upstream.  Wei suggested that memory 
tiering should be supported in the core MM and not something external.  He 
also suggested that we wanted to support hotness signals from hardware 
(like CHMU) and fix the promotion side but that does not require extending 
DAMON specifically.  Nobody in the call suggested that they were working 
on productionizing DAMON at this time.

Gregory suggested that our focus should be on generic support in the 
kernel that ensures that we can handle these memory topologies correctly 
and without extensive configurations, including from userspace.  Wei 
strongly agreed with this.  Bharata had replied to Andrew along the same 
lines as this and he suggested that we should provide this feedback 
directly on the mailing list.

Yiannis said what is missing from the discussion is that this support will 
be a major use case for the kernel and that feedback needs to come from 
the hyperscalers.

----->o-----
Shivank updated on v6 of his work.  He had received some feedback upstream 
but there is nothing blocking.  He also updated the SDXI support on his 
upstream repository.  He will also post the rmap batch support upstream 
which will help with mTHPs[1].

Teja asked if there were any hardware issues that were encountered in the 
testing of this series like he had seen.  He saw vendor specific errors 
that were logged.  Shivank suggested that Teja can send him the hardware 
errors to look deeper.

----->o-----
Joshua quickly updated on the status of tier-aware memcg limits.  Based on 
feedback, he is pivoting to supporting N-tiers from the very beginning 
instead of only two.  Additionaly, in the first iteration nothing will be 
exposed to userspace, all of it will happen transparently.  The goal is to 
upstream the mechanism first as discussion continued.

----->o-----
Next meeting will be on Thursday, August 13 at 8:30am PDT (UTC-7),
everybody is welcome: https://meet.google.com/jak-ytdx-hnm

Topics for the next meeting:

 - update on combined patch series for supporting non-temporal stores in
   migrate_pages() with memory error handling (series from Yiannis +
   Huan)
 - v8 of Bharata's patch series and next steps for clean up and
   refactoring to support the initial landing
 - v6 of Shivank's series for enlightening migrate_pages() for hardware
   assists and his rmap batch series
 - v2 of tier-aware memcg limits, including ABI changes to support more
   than two tiers
 - Gregory's investigation into demotions for multi-tiered systems and
   LRU inversions
 - first class support for virtualization based memory tier support, how
   to leverge memory tiers in the guest
 - discuss generalized subsystem for providing bandwidth information
   independent of the underlying platform, ideally through resctrl,
   otherwise utilizing bandwidth information will be challenging
   + preferably this bandwidth monitoring is not per NUMA node but rather
     slow and fast

Please let me know if you'd like to propose additional topics for
discussion, thank you!

[1]
https://lore.kernel.org/linux-mm/20260712-migrate-rmap-batch-v1-0-872a734431d1@amd.com/#t 


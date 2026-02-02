Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0B26BD172B8
	for <linux-mm@archiver.kernel.org>; Mon,  2 Feb 2026 02:51:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1392F6B0089; Sun,  1 Feb 2026 21:51:45 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0E74E6B008A; Sun,  1 Feb 2026 21:51:45 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F0B496B008C; Sun,  1 Feb 2026 21:51:44 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id DFD396B0089
	for <linux-mm@kvack.org>; Sun,  1 Feb 2026 21:51:44 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 78BC0140A55
	for <linux-mm@kvack.org>; Mon,  2 Feb 2026 02:51:44 +0000 (UTC)
X-FDA: 84397991328.04.2FE690E
Received: from mail-pl1-f196.google.com (mail-pl1-f196.google.com [209.85.214.196])
	by imf19.hostedemail.com (Postfix) with ESMTP id CCAAD1A000C
	for <linux-mm@kvack.org>; Mon,  2 Feb 2026 02:51:42 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=3VEg2laC;
	spf=pass (imf19.hostedemail.com: domain of rientjes@google.com designates 209.85.214.196 as permitted sender) smtp.mailfrom=rientjes@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770000702;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=a92yQmGz/4ixc+EeXoSnW9f2TatNud5iwb98QgmKlNc=;
	b=HZLtnA0MHFLgaHGW6VGbG8efUKcY2lJlMtOu34e336f12v37AyUh/WWBRaq4NjQhrNu49k
	MbhW+jFAEhJTHv/xwKt3HW0WFQlyuTUuAkGc+zicLP89zXLJhG4MDKVxXao7Hy4ejLz1BL
	ODLEMaJqDLtrcIGYTgJ/+wOO0jePMhM=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=3VEg2laC;
	spf=pass (imf19.hostedemail.com: domain of rientjes@google.com designates 209.85.214.196 as permitted sender) smtp.mailfrom=rientjes@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770000702; a=rsa-sha256;
	cv=none;
	b=7RbKnidNrkMW5M900BRpWCIFhl0VZnkwkfksaEsbOzoQS38YZMCDSGpB2MZy7dB7nloU/f
	DzoKAfq2Mbc7sReYc0MjsHSgba/uPPw4u2Far26sYFDVNwh8wk5XnBfp1ADU6csHYNHq5L
	juBsceigU8L7NvaU6HnUn7CxsiERqs0=
Received: by mail-pl1-f196.google.com with SMTP id d9443c01a7336-2a885af8ee7so100285ad.1
        for <linux-mm@kvack.org>; Sun, 01 Feb 2026 18:51:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1770000702; x=1770605502; darn=kvack.org;
        h=mime-version:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=a92yQmGz/4ixc+EeXoSnW9f2TatNud5iwb98QgmKlNc=;
        b=3VEg2laCcphUkGIXN2hbPYOIDv2Dss8O5o/NgriZSkcwPD3hzOcKU2z8xhnfKnc2UD
         S6ffI3+FRmf/Z17y4HNZm9hTZ5LmwE8S9pEXcMPZDlflObBjMiCS4KmMAREVZosmAUVz
         yoOdHPIDb6FCIDryNvorr6ctSNCVT3ehNlG13ngTap2Mcv5SLNp7Qhja8mChvMuPieE0
         +Af85ctiuRJ5VpdeMV/jZMc2mzirubn/VXLF97f1a9RN81VaoGMdtR0vnyOhZmpJgbsM
         FXbMhbMd9ynYoCkd5PF0Yln8pBOIOXfJDINGk3AK7iBqa8kL/eMtjpEbt20j32zvaOW7
         0bNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770000702; x=1770605502;
        h=mime-version:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=a92yQmGz/4ixc+EeXoSnW9f2TatNud5iwb98QgmKlNc=;
        b=EGFMhVaGgKw74S4oXmF29sL+53E8qBnb2+NKWlTL+HmikyX/Gjq88WNf3S4rCF6vJD
         KNAJlgEGivZhU7t6WNXxv90s2Q/k3SK/3FvmK4vpdsl8FfbtLo2T92lo6+dB8RPPn5U0
         3cx2TLKcpwq5QWiDJsQZ5A0INbNpGMhoHvlyuL7C4fqzPJvDX8zBOklWKUDNjZq0baLJ
         t981MSjll+AcHf8Nkwkm2VhhH5YnW8GaIhEaI+xTsALH0Q2I8nL34ifsNUpC3+0a06DL
         yWKgsosm03Yak/cgPQwaw6/TRbp5bMrDPoCL7P9C6vqSbxmaxzQIn+M01775jB8ZzaNb
         cI+Q==
X-Gm-Message-State: AOJu0Ywjw4NkjsCW+zATpoTwOK8h0+qHFTJHKMQ3+8fhDcSayUx9qT8v
	Jpk4v+xwalVT5ygW/eBA5D8mDxD2Mn12GxWZXExz/NlyivIxunpRWlECeT+v/2xDVg==
X-Gm-Gg: AZuq6aJWOMxBuauu1AGwVUGU7MCgvUse6PtIIVT488a/lX1CqWVs5N3HjBiVs22o58c
	H1DuT+8CVMFfR8tU2OQEWNjBSlwULrn0SrOBURqP+0/uXb0NnQ8xEClzrxswqHgcLuoeHK/IgEx
	tGmjUr94fQTrTDR/ggyKaY9UZwuVnmlfXogGVGkt+tmmGHPo/HKcqgVQ/MUS6NCnawInZqNBJPQ
	EL+gM5b6KxAJp3VvT+Wf6RI4zCr9hiXi9aPPvoPvx3t1EW6YkpuCPGzgdbQi/ykZImCJeggT/gz
	cJC+Mqi7DAKtsMFetY3Sj+NGE6K/Y/ONM9Bn4SbpCDLd6C3GZTO/tJCoU/4q7Fgwa0joQv5AIIb
	q7uyqiMgIBskhztXi0kWKwPxkUUuMZaiXq/f+1ukZ5tdvUQL38b44Bc27EyrwnhWclnHpo0eq50
	tikwHT66X+qhYsvnYHgAO20MnwEre6MbPVoMLt2rjZ6SWEcFQ+u6YedaZ0t/uwXwgVnooQjMEa2
	eEx93F7PlbhwojxAjfoavZxyxw8Zm4yA0ZUBOMWRQ==
X-Received: by 2002:a17:903:2a8d:b0:2a7:d266:d84a with SMTP id d9443c01a7336-2a8f50d1221mr2596545ad.17.1770000701010;
        Sun, 01 Feb 2026 18:51:41 -0800 (PST)
Received: from [2a00:79e0:2eb0:8:7f92:4ba7:443c:9ee4] ([2a00:79e0:2eb0:8:7f92:4ba7:443c:9ee4])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2a88b5d9a70sm134225535ad.77.2026.02.01.18.51.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 01 Feb 2026 18:51:40 -0800 (PST)
Date: Sun, 1 Feb 2026 18:51:39 -0800 (PST)
From: David Rientjes <rientjes@google.com>
To: Davidlohr Bueso <dave@stgolabs.net>, Fan Ni <nifan.cxl@gmail.com>, 
    Gregory Price <gourry@gourry.net>, 
    Jonathan Cameron <Jonathan.Cameron@huawei.com>, 
    Joshua Hahn <joshua.hahnjy@gmail.com>, Raghavendra K T <rkodsara@amd.com>, 
    "Rao, Bharata Bhasker" <bharata@amd.com>, SeongJae Park <sj@kernel.org>, 
    Wei Xu <weixugc@google.com>, Xuezheng Chu <xuezhengchu@huawei.com>, 
    Yiannis Nikolakopoulos <yiannis@zptcorp.com>, Zi Yan <ziy@nvidia.com>
cc: linux-mm@kvack.org
Subject: [Linux Memory Hotness and Promotion] Notes from January 29, 2026
Message-ID: <c8bc2dce-d4ec-c16e-8df4-2624c48cfc06@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: CCAAD1A000C
X-Stat-Signature: nooun84sar4iewhuj1oqbf6u36jyuqwm
X-Rspam-User: 
X-HE-Tag: 1770000702-143918
X-HE-Meta: U2FsdGVkX1+SrGBUGPUmurNeOs8+eui3TJsVuPGEYQJE9Yy0u3O85J/6LLbnGNBJ9f03RHNGh6RfpjVUW7tB5QGISbvmeDYzHBH2HJaOTzbOgNFBu2OJYdJDO7IVQTT4RTo+dvRf6fZNSYJTufOL0KzC/mmdnN3QQrafeuhXujNTCKOSAFK0kOxMWFhNBVYke0pm2nvY6voAYodgyCQMVhv29nux4ESMgzelqE2BOCD6SZlD1IwaH0Mdw1ORCEwPLQNzCQT9Ed+EpVabvrUkncfNOnOqYuT1NN3EtEsn1xZ5l4kSFwdRrvFQdW7KFLmMiXBX4VEJl+UV3fN5h92YmkAzy6/DVm5bZKO12Fm7Z61P44ffutxeQkTRWjizjOuYGjFg/r583z2hF6k3PAKTV2fQcNA/mwC3ME/NMJxfagt6EA0RXMaX/PEs3maXWFiIGuXkdOaJqBqH4nUleyncwtzLmlIVGS0KLrPm4XBdUO03PGlHMJIam9voBY3TFiRIbppsnQz2ztVMTen0jQF6jsafFTOn56PtLZTVw4gSEojzamvrQTxqe0olrzs9Fk2TKBOrRGn9Vv3lKkowgvJ4OGw0/iUcc7FYWir9wrpAeplDr9Pk3+GjIYwa47zgkkzvisBlTmshl+XC8WC/iVoEMqE0oI7GV53Hj1YJjpgvx07sxiPpfYLVNXn3phRcVqL8EPlkuhRaCKR7Q2bRP/6gx++FuKazyEbFTvgL/JC1gJGCsMS+aZqMNELr7nsohK4s7T0PpAkqUmEdPE+sdHq++hnWan0WxqoirS2pC6kD38kgmAhhaSWMowE8Ep1yDZdWXLP9EK/Qjodk2nv1xZ2Bif6MQ2SxCZGJzQTMjzXAvgfjQwGbwz/cQZwb78cMtqkVMQuiqxnqk5IMWyzoB+bdWIw8j+BHC73Yi9gCJMS1qtpDaWlHbYP9R/Gl9waD8XqXQtwpsTJ0VC1jOn6rZn8
 QnHgT7SQ
 s868tsWgog5/7xZxcaJzb3nAnxaFIzw1BHJ0U3z5qABOjzmwkaH4p+rpOj7UxRa1XAl5gO9Gd4MkxBUkOdIUN5dWmqYT+As2YOphrmFgRX9F2rpbHLC40HZnHxnthH8Swri4qbGrZlehZ63LPfDUzlJCqlBeeskCP2gl1ZFA3ic+eDHsTdDx2QRnUcXZRgpm+fhTPsCY2QN5lT9ZdSo/OfEuW8yb/zY0Lhp/wB9X+w/XCTGVGWNLR+iOgrMp7v2jQPYpKq8R52LJ9UJyER2kVzLEJPVMBmKXYioMLOK+S6AS5hAwAkWbSnb0tLVO12iG9m3SaMZOK/DFbATUAK0jPN2qcMtrmupC2F3jAxk9+i6rZN7HN6CIgPFl3woFSIlTxYtp6cDcuPciUy+0rbpZQdrRmBl7Z2I9HzPnR/PjEBoZtzbsrmXn9u/GBqE4ja2UQZTLo3MeR/Y7GXKayfLXaDlCsLxVZOHz5GsV0q0A3MLcwd5AaCVatOcuc4wG/2e+c5fkY4zmuWC8w+KFOdZYRB1hOz4xQPqiEYfX/gkJ3r/SpVhqYMtodIiJS7w==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi everybody,

Here are the notes from the last Linux Memory Hotness and Promotion call
that happened on Thursday, January 29.  Thanks to everybody who was 
involved!

These notes are intended to bring people up to speed who could not attend 
the call as well as keep the conversation going in between meetings.

----->o-----
Bharata had updated on the status of his series, he just recently posted 
RFC v5[1] that included new pghot support with two modes of operation:

 - the default one uses one byte for hotness record and tracks frequency
   and time (bucketed time) of access.  Default target_nid (=0) and which
   can also be changed via debugfs tunable will be used for promotion.
 - there is a compile-time configurable precision mode
   (CONFIG_PGHOT_PRECISE) that tracks frequency, time (in more fine
   granularity) and NID as well.  It uses 4 bytes for hotness record.
   This will be suitable for systems having multiple nodes in the top
   tier.
 
There are also lots of code cleanups, fixes, and reorganization.  His next 
step is to do some extensive performance benchmarking with additional 
industry standard benchmarks.  This should be in a good place for others 
to test out.

Both Gregory and Wei did not surface any strong objections to this 
direction.

----->o-----
Gregory has testing going on with reclaim fairness.  There was discussion 
that referred back to the previous instance of the meeting about avoiding 
opportunistic promotion.  He had a similar use case so they have been 
testing opportunistic and "fixed share" approaches.  His thought was to 
test with both reclaim fairness and Bharata's series.  I emphasized the 
customer observable experience that would have different requirements for 
different use cases.

Joshua Hahn went over the current thinking for reclaim fairness as three 
components: set effective memory.low and memory.high based on system-wide 
capacity (in addition to existing memcg tunables); the goal was to ensure 
that some amount of proportional top tier memory was always resident.  
This avoids interfering with other memcgs on the system unnecessarily.  
Additionally, the goal was to make sure that kswapd and reclaim are aware 
of this and can be more proactive.

I asked about the effective memory.high and memory.low as being hidden 
from the user; Gregory said there is a single toggle that has a tristate: 
none (default reclaim), fixed share, and opportunistic.  Fixed share is a 
self policing option; for example, if 3:1 ratio for top tier to CXL memory 
capacity, that is calculated and the effective share of top tier is 75%.  
Another goal was to ensure that this would be extensible in the future.

Jonathan asked how this would work for the overall system; Gregory noted 
that either everybody participates or nobody participates.  If you cannot 
use fairness, then the scheduler needs to be more effective.  If a single 
user excludes themselves, then you need to reduce the effective capacity 
for everybody else on the system: does this scale when containers are 
coming and going?  Likely not for the first iteration.

Gregory also suggested one possible mechanism could be to add a tunable to 
a reclaim fairness sysctl that allows userspace to reduce the effective 
capacity of a single tier on its own.  Reclaim would read that value 
directly instead of adding up all the values itself.  I asked if there are 
any per-memcg toggles for this an Gregory said that only the existing 
memory.max and memory.high play a role in this approach.

There are some interesting caveats with memory hotplug but they think they 
have that resolved.

It appears as though reclaim fairness doesn't have any strict dependency 
on Bharata's series; Gregory noted that we want to ensure that no 
mechanism can over promote, hence the goal is to test these two appoaches 
together.

Joshua was working on allocation throttling mechanisms and would hope to 
post the patch series over the next 2-4 weeks.

----->o-----
Next meeting will be on Thursday, February 12 at 8:30am PST (UTC-8),
everybody is welcome: https://meet.google.com/jak-ytdx-hnm

Topics for the next meeting:

 - RFC v5 of Bharata's patch series for pghot with two modes of operation
 - Gregory's testing of reclaim fairness with Bharata's changes
 - discuss generalized subsystem for providing bandwidth information
   independent of the underlying platform, ideally through resctrl,
   otherwise utilizing bandwidth information will be challenging
   + preferably this bandwidth monitoring is not per NUMA node but rather
     slow and fast
 - determine minimal viable upstream opportunity to optimize for tiering
   that is extensible for future use cases and optimizations
   + extensible for multiple tiers
   + must be possible to disable with no memory or performance overhead
 - update on non-temporal stores enlightenment for memory tiering
 - enlightening migrate_pages() for hardware assists and how this work
   will be charged to userspace, including for memory compaction

Please let me know if you'd like to propose additional topics for
discussion, thank you!

[1] 
https://lore.kernel.org/linux-mm/20260129144043.231636-1-bharata@amd.com/


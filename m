Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 21A4CD68BD5
	for <linux-mm@archiver.kernel.org>; Sun, 21 Dec 2025 04:10:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 844426B0005; Sat, 20 Dec 2025 23:10:39 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7CC4F6B0089; Sat, 20 Dec 2025 23:10:39 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6A9256B008A; Sat, 20 Dec 2025 23:10:39 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 56A4E6B0005
	for <linux-mm@kvack.org>; Sat, 20 Dec 2025 23:10:39 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 0CB1E13BAE9
	for <linux-mm@kvack.org>; Sun, 21 Dec 2025 04:10:39 +0000 (UTC)
X-FDA: 84242151798.15.D1B5493
Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	by imf06.hostedemail.com (Postfix) with ESMTP id 451CB18000C
	for <linux-mm@kvack.org>; Sun, 21 Dec 2025 04:10:37 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=2yaHw7UW;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf06.hostedemail.com: domain of rientjes@google.com designates 209.85.214.171 as permitted sender) smtp.mailfrom=rientjes@google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766290237; a=rsa-sha256;
	cv=none;
	b=zkoFT7FIuNXyHzKVgCE9mqx9ysPQiCSZ27tGLSemekcRNeiGw/9qNQl7pnMlT3f2mGNyOw
	5bJ4koMDu1pnFBTm3SLzqIO42/YE8Q3O/J4b9NxKW+M5VqAUtWu6zg/b6K/HFs8Bg+oB3t
	orRQ1PBWTgZDo0EG5UIjd70+SY0kCSI=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=2yaHw7UW;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf06.hostedemail.com: domain of rientjes@google.com designates 209.85.214.171 as permitted sender) smtp.mailfrom=rientjes@google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766290237;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=z3ezoi6UytYVc/ToXoXHwmGm9U9iJQTZduvZu+Lux2E=;
	b=Hcd5e4EAQP0RK5J8at70bTdEUs5STZQ10rKf5XmdaFag69/y/rTA3f1zmq237YGqGf7p48
	Aqyapxp5t8qnstyJzt0rwz+m/t7RsTzrWhlyIawH8KeAJccTnyDRbcSyLLw7u5DJcfrkeA
	0Sj80t55E08fo0KQFnVBsh1lY1B2zt0=
Received: by mail-pl1-f171.google.com with SMTP id d9443c01a7336-29e0753e5d8so341125ad.1
        for <linux-mm@kvack.org>; Sat, 20 Dec 2025 20:10:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1766290236; x=1766895036; darn=kvack.org;
        h=mime-version:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=z3ezoi6UytYVc/ToXoXHwmGm9U9iJQTZduvZu+Lux2E=;
        b=2yaHw7UWDcdEE8xjUGTFsBGOb3pD6WK9n6nFRrVlgLIvIvmAf3hV8MyxQWfs5X4itU
         tuXCLbrJuAWVdwpOY8aet4TSQBA1TyIAjSsPZncwz9tw4rj/ca7DfhpadX9qb1tIi3wO
         kjHPW3HansjpWu4Jfh3D6jK6uKMUzopBg23/1DRBoNs84jdzPATsREePMOLtO6YF7pb9
         PnUPXeahjrNoh3ShmoIvCHjCa2SRaMmusgUySiL25Q4iQR2uEChOodUP+8sHEyGiLdBW
         gCKSSbn0DaBeNF3UXkYAEXc5LZ8UC4HZtjI3v03Vpzo14IoURNCxqCq6OAEUN5K/BRmf
         HlrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766290236; x=1766895036;
        h=mime-version:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=z3ezoi6UytYVc/ToXoXHwmGm9U9iJQTZduvZu+Lux2E=;
        b=C2Xdm4DZcUzzMX6jqBv/Dy3NFgkftYDF4XTf7TJG+R+lmxsBUvRAcH27G1VkNdhzRZ
         eEAqGCr2NttXiCoFiv9UlZUPVGNCn5AsAcv8iltP48jpPmpLbdSPtmWhjLyIQL2BCqUv
         J7XAuCTZd+6+sGAbakxYL28GFyYRgxJMikOMMOVhwC4cweZTgs2MCGH6DMCoA5xFxsmU
         OQ8pVe423g/pENX9kPiHUZTx3O7n9L56UaMV9dyPTJjvtkd6whhTWY9EpZzrH/chifI9
         dsMj9HkcxPEPchYYHdFH/A8S5n9G8A5w1rtRFzGDuDP7cqNuW52/RVZ4IvD8EhW37yb3
         K6mQ==
X-Gm-Message-State: AOJu0Yz94EAzfJlVKXjWoK64sTTr3g/POClJkBuBxSC10vOeT2EdzuB1
	Z+3z71dY7hK6AVt1GO+1gM0E3TBnTyXXnFt/TDmlcxNP689se16fS6+J8CsnJpE/Mw==
X-Gm-Gg: AY/fxX5cHjTKWdgt9wocidpP+NlCnDG2DKikzDAEloLGhiWLp5lmZmzWKxX130+pJGn
	dqLusKiAoLNTSrnIMDeBABAGaaJZftgy87+jxFZ39BDabVcMC5uL9ZLRycGSGXAq5drr7rmFQPo
	mMjYnz1fXbgOptBWJ1et/XI+dofBYRZ1tLM202gq3F5lZBSeUVyR47TWUZfDT38Iiz7TwT0MrIe
	yGm1DOpIQ/HAqB81Yden9gZRV4dZzka+YlG53tLmx3jYD8/ztrJJN7wLRcru5xtLGn0DmYITzOZ
	Rp9X4WVAA3235LyXrkL9hEdve8OXfqQDfGJs07rwrW/FeJcf3enU1uZRmZ790k0Q6y0l137O/M7
	sk/nIEiBGbJS3gbvrH0M4t4KSkl0nmHCrUEXNtuRsHGTpXJZaEuCXau49n2k/tofTVY+nVY5XUj
	NLdMHvwpyH8rh5Kx7c1O8bvxddaJR4Vu9ElwUkUK9PMv6NHmpYmJIGzqLHdhQiMKcL6h44Cc/3T
	DKWwji/zvRWKG2h9mQasYgLqOkOwOIujixc1qRZnzn+liDBRkX5
X-Google-Smtp-Source: AGHT+IF30j1q5u/8alX1lylsrMuSzoz6jPQiKQsJsgcbgDtuzM+Z5T1crehftgIrcE0aG7A5qlRqRg==
X-Received: by 2002:a17:903:2b10:b0:29e:27f4:bac0 with SMTP id d9443c01a7336-2a311807b73mr1873595ad.16.1766290235492;
        Sat, 20 Dec 2025 20:10:35 -0800 (PST)
Received: from [2a00:79e0:2eb0:8:97c6:17d9:e34d:346f] ([2a00:79e0:2eb0:8:97c6:17d9:e34d:346f])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-34e76f03baesm4770882a91.2.2025.12.20.20.10.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 20 Dec 2025 20:10:34 -0800 (PST)
Date: Sat, 20 Dec 2025 20:10:32 -0800 (PST)
From: David Rientjes <rientjes@google.com>
To: Davidlohr Bueso <dave@stgolabs.net>, Fan Ni <nifan.cxl@gmail.com>, 
    Gregory Price <gourry@gourry.net>, 
    Jonathan Cameron <Jonathan.Cameron@huawei.com>, 
    Joshua Hahn <joshua.hahnjy@gmail.com>, Raghavendra K T <rkodsara@amd.com>, 
    "Rao, Bharata Bhasker" <bharata@amd.com>, SeongJae Park <sj@kernel.org>, 
    Wei Xu <weixugc@google.com>, Xuezheng Chu <xuezhengchu@huawei.com>, 
    Yiannis Nikolakopoulos <yiannis@zptcorp.com>, Zi Yan <ziy@nvidia.com>
cc: linux-mm@kvack.org
Subject: [Linux Memory Hotness and Promotion] Notes from December 18, 2025
Message-ID: <c74ce9f2-5538-9851-65ac-832b3cd50487@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 451CB18000C
X-Stat-Signature: xpp68kh8e87wc1ht5agtqpefz1x5iju5
X-HE-Tag: 1766290237-588619
X-HE-Meta: U2FsdGVkX1/Fh0ejwG34YxcEig/Is5AxFvTr1tsnDX6DcqL3mSDWBObbDO0qJ1pG7KOeDKF3zhLYz8nv9ywYTlY5ttNsQQO3Mm/JnVf4Sp25vP4hCLefVaq1B9ZoXHR89IEgJElddxlzI8T58D+FbL+lm7DVrT/ASr5a55GbA/Vr1LW6HKWjk1F3Kx20NE0wbqzA5iK7nJAb/YR+P//7Yovo2u/IcBIV7AHGQisFunXhvmW9iJW6PUGVO0H2O3Lx9+YpJzbmvACPpXMW+ZYryEZHAXYcaK/6+6j4b7m8/0Qtmup6dvdXIO++VCsf8lDkK8AwBWgP+ncmB8bXaFDsIZipzyiM8lhFyEoB7D4OHckFYXbHB0JQWXUidAsl/vAYlXumfzsWkUCjkkWQ+aUbcNnf05akynX/TToNXasdp1/W8JLV5DPYlmxOewt+/S28r0V1bq4vOiDkpTNtVHd7ntLnTvDfNKh+duKyrRKU1Ijsukq7eYq7vvjPxs1J3MJNW92eO6q/TpWKoVKDiulFYt91qaJSAVD1tf/Ca9HPhRvUdaznWq78f1XGuRHRuc0IF4o06ThcV7Yvqa/XoCeJDssmLAgOYQ9gRKVT1VU/p/nrxm/XEb4DBpvBWFbP4ioEANvrBw73iSRnKAiU2R/a9z1hddY0JlKPxLmPwFjyVTim5uaep60oaMJBsQ+rHMdS7kQDBl2jCf1lvA4NBFKbZJIdoCDOI9btK2ngFqK9GpI52lReLC6bEnIb7yJtUeaWJB/2uC1tfqSn0ZqA9ba7sFZXuv3ILWR8mtbYAw7QdPdWAh4dTzrEctoEvlg+vn6MmQi2Ntq13ZSLqpNFp8oFpkEfeDuWJacfozmjITD7j0FSv+PJIsFf8yvFFMSS1eTOGuvcpHcNuDLti3TnPWFKiN0J1Ngg51SjP7u2AbfMBB+2nZA34/hGL4O2Yja9pY/n11+YuSVrVhV6TTybd9q
 yQj19m8/
 myrChVJoqnGhDlrSDFIUpUsPAtvC4lY8P5fEURRJ9LgdhhQpNYgptw80Gesoai52we8GskCgFryT5qEPMa+SvWSPFfE0nFBqKrlztOj0vScbcvwFcRsyHt+O0W8yz/lIe407p4CfiNE1NTENdY82DLHwMFtZKpBfnvtXg0vycVW0bP1IYQ8q5vbNJFvsWsXs8rgSg6xEwx9vI6qcaRTFpQj71fESxF1lF5pAsBm8oXsySV4pc5L6CH3CEwSM+Q4amlaUbVHfLSagxTnZLdQGgyZkc/NWJg/5bhCzGCwHAwa32jXw9Io0uML4H6m+O5vrMCu4QEwFLoIsi7Td1llyUQ8cvkMMYigkQlCAakKn+Ds+ErdWtGmQ0FANhGmoMb2bQWgFSl36n4rHsEAI9jaSquJ9vi7/iy1eNcETIt2381BdBM/w=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi everybody,

Here are the notes from the last Linux Memory Hotness and Promotion call
that happened on Thursday, December 18.  Thanks to everybody who was 
involved!

These notes are intended to bring people up to speed who could not attend 
the call as well as keep the conversation going in between meetings.

----->o-----
Raghu provided an update on his progress; he was trying to fit klruscand 
into his current approach but some redesign would be necessary; since 
there is already one approach working, klruscand + pghot, he will be going 
slow on this.  He was planning on posting the latest set of patches for 
the record so that it would be possible to revisit later, mainly focused 
on Jonathan's feedback and new optimizations.  This was likely to be 
posted by the end of the year.  Mainline would continue with klruscand 
with pghot.

Raghu had a question for klruscand, however: for the latest cleanup and 
MGLRU LRU changes proposed on the mailing list, will this affect anything?  
Wei said this would not affect klruscand since the core of MGLRU is the 
LRU of the page which is unaffected by those proposed changes.

----->o-----
We moved into discussing memory overheads for storing page hotness 
especially since this would be coming from super expensive top tier 
memory; we felt this was likely best to align so that we could determine 
the minimal viable upstream opportunity for a landing.  Gregory has a 
short discussion about this at LPC and the current proposal was around 64 
bits per tracked page and this would be limited to the CXL memory tier so 
the shorthand would be 2GB of overhead per 1TB of memory tracked.  He was 
interested in seeing how this would generalize to supporting N tiers which 
would be a minimal viable upstream requirement (HBM, DRAM, CXL tier).  
Jonathan suggested that HBM had nothing to do with hotness but was rather 
focused only on bandwidth.  The consensus of the group was that we still 
need to be able to support N tiers.

I asked about how this overlaps with NUMAB, there as been a lot of 
discussion about NUMAB=2 in this series of meetings but it's likely 
worthwile also to consider NUMAB=1.  Raghu suggested we could update the 
VMAs for DRAM tier in that case and only track the hotness of memory for 
that VMA.  I said that would still be operating on the sliding window.

We aligned that any upstream landed support must be extensible for 
additional memory tiers in the future.  Jonathan generalized this by 
saying that we need to be able to turn the support off with no overhead.  
I said this would be required for virtualizing the lower memory tiers into 
the guest where you may not care to track the hotness for optimal page 
placement.

I suggested that 2GB per 1TB of tracked memory sounded fine but it likely 
also the ceiling.  Gregory said that colleagues were surprised by the 
amount of overhead and so we should discuss this on the mailing list.  
Yiannis understood the pushback and said that we should show what this 
additional overhead is getting us: we need to demonstrate the value in the 
hotness tracking to justify the cost.

Wei said that internally he is using one byte per page for hotness 
tracking and this is a simple solution.  Jonathan said we could allow a 
precision vs cost trade-off, some mechanisms use even less than one byte 
per page; they work, but sometimes they promote the wrong thing.  We 
agreed this could be configurable.  Gregory made a good point that for 
single socket systems, for example, we don't need to capture source or 
access information.  It does drive configuration complexity, however.

Gregory suggested we may want to avoid the accessor information on some 
systems and, when we get it wrong, require double migration to get it 
right.  He was on board to limit to eight bits to start and then add a 
precision mode later.

----->o-----
The next meeting will be canceled for New Years Day.  We'll come back two
weeks after that.  Happy New Year!

Next meeting will be on Thursday, January 15 at 8:30am PST (UTC-8),
everybody is welcome: https://meet.google.com/jak-ytdx-hnm

Topics for the next meeting:
 - updates on Bharata's patch series with new benchmarks and consolidation
   of tunables
 - workloads to use as the industry standard beyond just memcached, such
   as redis-memtier
 - later: Gregory's analysis of more production-like workloads
 - discuss generalized subsystem for providing bandwidth information
   independent of the underlying platform, ideally through resctrl,
   otherwise utilizing bandwidth information will be challenging
   + preferably this bandwidth monitoring is not per NUMA node but rather
     slow and fast
 - similarly, discuss generalized subsystem for providing memory hotness
   information
 - determine minimal viable upstream opportunity to optimize for tiering
   that is extensible for future use cases and optimizations
   + extensible for multiple tiers
   + suggestion: limited to 8 bits per page to start, add a precision mode
     later
   + limited to 64 bits per page as a ceiling, may be less
   + must be possible to disable with no memory or performance overhead
 - update on non-temporal stores enlightenment for memory tiering
 - enlightening migrate_pages() for hardware assists and how this work
   will be charged to userspace, including for memory compaction

Please let me know if you'd like to propose additional topics for
discussion, thank you!


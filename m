Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 176D6EF5868
	for <linux-mm@archiver.kernel.org>; Sun, 15 Feb 2026 04:05:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 43DA06B0005; Sat, 14 Feb 2026 23:05:01 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3EB846B0088; Sat, 14 Feb 2026 23:05:01 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2EA5E6B008A; Sat, 14 Feb 2026 23:05:01 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 17CBE6B0005
	for <linux-mm@kvack.org>; Sat, 14 Feb 2026 23:05:01 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 7E6221409D9
	for <linux-mm@kvack.org>; Sun, 15 Feb 2026 04:05:00 +0000 (UTC)
X-FDA: 84445350360.05.55FA1F4
Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	by imf30.hostedemail.com (Postfix) with ESMTP id D0A048000D
	for <linux-mm@kvack.org>; Sun, 15 Feb 2026 04:04:58 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=RCRusBvB;
	spf=pass (imf30.hostedemail.com: domain of rientjes@google.com designates 209.85.214.178 as permitted sender) smtp.mailfrom=rientjes@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771128298;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=I/RhIvpEFLtPpCN6HI6eqnNvFV6app2Dc3NXesx03zw=;
	b=vN2xF5jDOI+EhV+RNvje2hdPXgjIu+oJ7lqbc+v0omNGyh6G715uHbCJ4PtTtkYr+Rm3GC
	/b2mN0R7BGwCi/LLNFPVA0w5v89+gU6/Yf/BNHdrHgFFkpJTqpnX7gcTVvDDAL99Ffvdz0
	5W9jAX3KFHhAH4Fy/a87dsjG9XNowvA=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=RCRusBvB;
	spf=pass (imf30.hostedemail.com: domain of rientjes@google.com designates 209.85.214.178 as permitted sender) smtp.mailfrom=rientjes@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771128298; a=rsa-sha256;
	cv=none;
	b=hHIY8aklRJ7SYsTSmEt69NXwvnMi1Tb91Nujof4goWItuOXKPrjKy+PrxK2NGl87FESjBF
	6MvT4hXooS/vwAhDFNs2Jkpj+xnLMnmG4aYm+lWhJGiQhrSnjQayNvWKJe7vAxb9mNvmrb
	pYfl0va7IkC6pFOavJYmQ63lI3Cd9j8=
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-2aad8123335so60995ad.1
        for <linux-mm@kvack.org>; Sat, 14 Feb 2026 20:04:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1771128298; x=1771733098; darn=kvack.org;
        h=mime-version:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=I/RhIvpEFLtPpCN6HI6eqnNvFV6app2Dc3NXesx03zw=;
        b=RCRusBvBrNuSt/16qK8ZkEdmR/FTg9L1sTIHggMh2iw95vS3W2Mq++lsFf3ZbPerti
         upDIJiAweiok260tC3p+BMdmiv4/dHntTRCXTZ97XkQHiebYkPzriRskBjsHVXMF2UOU
         dAZqGYnl601o98ZQlUr2rSyRTrT5mnisBPItEDJxKh5u1Cgr1VTENLduTBWLUddy3MUD
         ZRDN4lq+U62vMmv5pyJyq3YahHDc6bzjwBYAJaVXptaI0aInjX9AvKngEhZESFxu/UIi
         BHAT8Nt1b4IZTF4P1+mA1ldAMSh8g8uTaiEVmu5Nc5LuBMJzcX6GbI5OrD0ONtoq1FGy
         Bx5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771128298; x=1771733098;
        h=mime-version:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=I/RhIvpEFLtPpCN6HI6eqnNvFV6app2Dc3NXesx03zw=;
        b=sCaf3z7DEaSor+8G2ZbbtUr/6S0OPCBj3qW8uEKk880Wm0P9SxB0VChwUktjNy+Vvj
         9UDw2aIsKsOUx5jU3BNi45SBNew7t5MJ1/GPndGqqf1Ma3lZgteQyT5Y28rQFkFGf7Ta
         OwFMoaXm2olDRwTY+cxPGMFF9wJ2PpThh1Wo3TgSosRkFJH9xB1g9qa5kJC80WeFSurv
         SbAc4MA02flfBCyTBOs/s3o7yfNdQSaevGNjeCSFh4+NoksFtPoeAP+830BUX56An1iK
         rhBRdhpMth0d451ykMB+0OuDJE56pUXHTx4foTXSYNAJ+8ossBwC6wmuAPLkea5vfSIq
         Cwow==
X-Gm-Message-State: AOJu0YywYHeemCMmqipxcfNDIzUuxvKYUuOJqgB9ye/kPc+fpDuZgnks
	0KKSUojkOM6j0nYokBdtEPfvIWUvJz2E+tvLMq/eHQnvoeod/rZ6QNmwgbBKfsg8Cg==
X-Gm-Gg: AZuq6aIgj/xU2LTuZ5q3pKbWnkHQMM45M2j13C29D7F6TAt4cPHgLocV0tAb/XP3+2R
	2N0ZsF9usPGu6TrEMHbeYA7XHwVAHg4eSX38GiTR3iUmWqHQF9esuteflUDmEIEKNn6OnGob2QY
	jg6dUqdkzXzRBt7kmKRq48eBsgi8lLe8cmE6buVqy+QzqYHx7mstV5Qg6IOXIqpVkAt96eSB+SQ
	CChVb2LbYWDWz9NYywH9R84JiCuFlZmnB9cTFrdY8p1Q9dUp+vYTRTyRx9EZBjbDwKJThTZE+D7
	iBVkGVbVs411jN+CXWnHYRV8nue/7SshkDsiejwP9NApo4qElSDpvbRLyhXocA1FZnlnO8bc7CR
	h+2U/thmGDanVtF6HtVLuN8b1gsUaUNpmByydT1sOBF2C3lESGB21XgJfDPLHzwr+7i2jnDj58U
	aGf9s2WaNDNUIPPj0P8dSVMTT7cfFQhyJpGuAGXgpHpqowJ/Gq0uWPIi8JxuZuvuAd9leeRJMWu
	WwvKQtKlsi52NEYfVR/3JtuYg9jce2Q12FhtNWUiqQOXIDQIFa7wg==
X-Received: by 2002:a17:903:38c3:b0:2a0:89b0:71d6 with SMTP id d9443c01a7336-2ad1f0ca506mr943545ad.17.1771128296953;
        Sat, 14 Feb 2026 20:04:56 -0800 (PST)
Received: from [2a00:79e0:2eb0:8:97ad:c968:9be7:91a9] ([2a00:79e0:2eb0:8:97ad:c968:9be7:91a9])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-c6e531e6c44sm3653865a12.17.2026.02.14.20.04.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 14 Feb 2026 20:04:56 -0800 (PST)
Date: Sat, 14 Feb 2026 20:04:55 -0800 (PST)
From: David Rientjes <rientjes@google.com>
To: Davidlohr Bueso <dave@stgolabs.net>, Fan Ni <nifan.cxl@gmail.com>, 
    Gregory Price <gourry@gourry.net>, 
    Jonathan Cameron <Jonathan.Cameron@huawei.com>, 
    Joshua Hahn <joshua.hahnjy@gmail.com>, Raghavendra K T <rkodsara@amd.com>, 
    "Rao, Bharata Bhasker" <bharata@amd.com>, SeongJae Park <sj@kernel.org>, 
    Wei Xu <weixugc@google.com>, Xuezheng Chu <xuezhengchu@huawei.com>, 
    Yiannis Nikolakopoulos <yiannis@zptcorp.com>, Zi Yan <ziy@nvidia.com>
cc: linux-mm@kvack.org
Subject: [Linux Memory Hotness and Promotion] Notes from February 12, 2026
Message-ID: <5146e3b4-751f-ca6a-0bdd-7b1f4d425ff0@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Rspam-User: 
X-Rspamd-Queue-Id: D0A048000D
X-Rspamd-Server: rspam07
X-Stat-Signature: ntepfnsipjdd3tchzz9empozpju79eng
X-HE-Tag: 1771128298-498787
X-HE-Meta: U2FsdGVkX18PvJXJRYNYCwbPMXZVHnJVqXN3Zz+094KbMgQveTWfpd2eTx6B+FotvBO4DLUDSSF901wjTy+54W0KfveduaMlNT9slRSklNYypChRj4fBG27SQ0cR7y/IZIguUAtqzdDMS3x55of9DCcCjhkP+jSavmJzPw5ZK1RQGlLfkpKkdoJjlDN5sXMp+qeUl/VXfG2xtbA8zD2XcuNiten3nZ6o3HF2DnImPkHeu4h0/+OFaIODkDYo3yg4LPKndF2lQtCYeKk3/4XKFPU2FFtHqDAPK/Mou9rHtDT/aXXwnxVABn++Y/ef7V4wrO07jjoas0MtIPfm/b217/BjEUtH9XZjqfQmjXVRzkD8jStP8V45U8xZXa728Qlkgy4Ga3MTp4/buqJhspp119cb9qTMOyxeHfPu9g9GWICs1kiieJrjwfh5PSGhzPqqq7zFPTXTI6LB5N4J3PT/JEmtM39uw7Kd0B344tWgWPg3FZa51whI1kbPYJSw+ngcdSmhoix+02UlvLOKGbfORu3SFJba6XrfuNLEPKMH3AlTuG0YFgwDGu+eto26Mf+Q5QqFnMQ0j57NtaB2Re9Cjeew5QeG8DERAwwgHVdxbJqQvyCTpN6UfwILJn3uUsSZn03oZQuHIPDZn+oj+eXQZ8YLN+jz90tWYb4a0w3RIfJu8UmSgmLyd2MWku5f3l3HFNnC4cddkz7iRBAl2IXHIbnEdsAOzk/Fto+fnNI68iG1HS+UWcbTy/cKXMnbBhQPe/mChBnPPQGtpU3WpkcCwj0wtAVKkPzcCg/dDj9eqDqGyfBVeBUgH/rv85nYkEjIBUyIIbI8u3Nbk1cxFSdlDFBz0BiiRdsjcmbzP5PzK1UaysE7EAoRujiU8V0HvzFppUFWgkt9rEqvZU+G+aIM1EzIYGjn8Y9rJEXRI8KdmuhkTIZ+0ZTB93JmZFDS84uzWhzzP2l0RaS4Vq3jK6z
 uAK9LAY1
 ItyMjQbtTZOVuVQeGRiiyAHrX9aAa4pyV/3omPusxQPO5Jde6lCFb71Lmq1V44UbyjFSxQ2l3Iqpk3xxTsaJXP6b44+IvaX41/7iYR/Ip/VNaSp1twIzqwJBXfK9B+kSBymjHwzVSWuu9RTRcxMLbkZoTPwyue2FEVrgNTvmgZj24POcKGC3DMdd+S7HaCfPg4vb+9L/jD++Y4MEhYVlEy/ASuNDXDfZ3ksI1bshJQq2hiCLUFTLdFlMQekbuydJw9v2Dz/dXTLjtTAPOkyVXjGdVwJ192FCADwyCmOSDm0wDqhiH5362afa6PWJgrLROsZe+44i4QE3TruTSP3DLhNqps6LAO+9gjDFl3cv8ErWI9Tw9SVGdFuFt7iWEmaon91zT+dOjMjdfFOiyEKIa42LFO9/hJ289TP4Q7gNRhjqiMzs=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi everybody,

Here are the notes from the last Linux Memory Hotness and Promotion call
that happened on Thursday, February 12.  Thanks to everybody who was 
involved!

These notes are intended to bring people up to speed who could not attend 
the call as well as keep the conversation going in between meetings.

----->o-----
Bharata updated on the status of v5 of his patch series from a couple 
weeks ago with two modes of operation.  Based on discussion with people 
are LPC, he proposed two mechanisms to track hotness that would have 
vastly different memory footprint requirements, one as little as one byte 
per page.  He posted benchmark numbers over a series of updates upstream.  
He found a clear advantage of hot page promotion when top tier memory was 
not saturated for both of these modes of operation.

However, when there is top-tier memory pressure (when the benchmark 
working set spills over into CXL memory), then we tend to demote and 
promote simultaneously as expected.  Interestingly, he has not observed 
promotion in these cases actually being helpful; in fact, in some cases it 
actually turns out to hurt.  He asked for feedback on tunings for when the 
demotion case can actually help this scenario.  Note in one of these 
benchmarking scenarios, however, that the benchmark would perform random 
access.

Gregory suggested that we may want to track the number of demotions and 
promotions; when the rate of demotions equals the rate of promotions then 
we should reduce the number of promotions.  Bharata noted that there was 
ratelimiting on promotions but not considering the current rate of 
demotions.  In this case, Gregory said, we are seeing promotions drive 
demotions and there will be an endless loop with these workload 
characteristics that will impact performance.

Gregory's idea was that if we promote 1,000 pages and then a few seconds 
later we demote 1,000 pages, then this is an indication of churn.  If this 
is consistent, we should back off.  In an ideal scenario, we would be 
doing some proactive demotion from top tier so there is room to promote.  
He wanted to see data on the rate of promotions and rate of demotions over 
time for these bnechmarks.  This may reveal an indicator that we can use 
as a heuristic for a back off mechanism.

I asked if we need a back off mechanism or we actually need a fairness 
mechanism, the worry was that we would find churn in promotion and 
demotion, then back off, then start promoting and demoting again at the 
same rate only to rinse and repeat.  Gregory noted that this will continue 
to consume precious bandwidth on the device so any churn will naturally 
impact the rest of the system.

Wei Xu thought that this was more about the sorting of the cold memory: we 
need to rank the page coldness across tiers because what we promoted may 
not necessarily be hotter than what we promoted.  One possible approach is 
to use a time dimension where we refuse to demote any memory that is not 
cold enough (like MGLRU's min_ttl).  Gregory noted this is a function of 
the call that we use to promote the memory which, today, is just a call to 
migrate_pages(); we could pass gfp flags to specify what to do if the 
promotion node is out of memory.  If we are calling direct reclaim, that's 
probably an indication that we are not aging off inactive pages and we may 
be forcing demotion of active pages.

Bharata's current approach uses migrate_misplaced_folio() which 
unfortuantely does not give a migration context but does wake up kswapd if 
the top tier is near an oom condition.  There is no gfp flags being 
passed, however.  We may want to extend the batch function to allow 
passing its own allocation function; the current benchmarks would not be 
calling into direct reclaim today.

Wei noted that we do not have a mechanism today to be able to compare 
relative coldness of memory to make promotion and demotion decisions.  He 
suggested using a time dimension such that the page being demoted is 
guaranteed to not have been accessed in the last interval whereas the page 
being promoted *is* guaranteed to have been accessed in that interval.

----->o-----
Next meeting will be on Thursday, February 26 at 8:30am PST (UTC-8),
everybody is welcome: https://meet.google.com/jak-ytdx-hnm

Topics for the next meeting:

 - any on-going work for CHMU and a generic hotness interface to leverage
   it
 - RFC v5 of Bharata's patch series for pghot with two modes of operation
 - promotion and demotion thrashing detection and back-off mechanisms
 - LSF/MM/BPF 2026 topics to propose for discussion on hotness, promotion,
   and memory tiering overall
 - Gregory's testing of reclaim fairness with Bharata's changes and first
   posting for an RFC
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


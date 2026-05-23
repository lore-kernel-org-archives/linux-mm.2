Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F2ABECD5BB1
	for <linux-mm@archiver.kernel.org>; Sat, 23 May 2026 05:21:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7C6FD6B0092; Sat, 23 May 2026 01:21:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 777DE6B0095; Sat, 23 May 2026 01:21:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6B5556B0096; Sat, 23 May 2026 01:21:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 53EDA6B0092
	for <linux-mm@kvack.org>; Sat, 23 May 2026 01:21:24 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 94E47C29EE
	for <linux-mm@kvack.org>; Sat, 23 May 2026 05:21:23 +0000 (UTC)
X-FDA: 84797536446.27.D32602A
Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	by imf09.hostedemail.com (Postfix) with ESMTP id D786914000F
	for <linux-mm@kvack.org>; Sat, 23 May 2026 05:21:21 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=AOIFuFu3;
	spf=pass (imf09.hostedemail.com: domain of rientjes@google.com designates 209.85.214.169 as permitted sender) smtp.mailfrom=rientjes@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779513681;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=iBznbaNytKaeuxLQ07f1x42nohkV0AU9qEgrbnMsn3Y=;
	b=hCZpeLA1IwrwxJp4zOnEdKFf+ER3pIG+QVwnwlxDS+wfLjnjt19k7fMQ5wuI6PcI+Kr72t
	rov83/lhGhYne/SeFf5WgHiTgehvW4lzTsF93KNIVTOR6F84IiaPVuNSeEbwKqf5qr4uX1
	pvrPODm9aRoFyb0PDI8OHSavGracELA=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=AOIFuFu3;
	spf=pass (imf09.hostedemail.com: domain of rientjes@google.com designates 209.85.214.169 as permitted sender) smtp.mailfrom=rientjes@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779513681; a=rsa-sha256;
	cv=none;
	b=PHo5s/n8WXhsJMb77FSH+bLhj/s1z55Vyn8I8EM/r2iNrHHEWYGEjgMwbqKhx39ECUPIkt
	jYxWNcVf1HDYZ2Q6k7FjriXPzltkBQYjzvinSP36QlavUG9dLrUyda2yPZxkQyUySgcPd2
	zIYxw3jwugrtDcEGgoKQ2GxEqezVZxM=
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-2b2e8b95bdbso85ad.0
        for <linux-mm@kvack.org>; Fri, 22 May 2026 22:21:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1779513680; x=1780118480; darn=kvack.org;
        h=mime-version:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=iBznbaNytKaeuxLQ07f1x42nohkV0AU9qEgrbnMsn3Y=;
        b=AOIFuFu3xCKBk6He5uBbnOXzDRm7NGD5uR5Hkzxp3hAyurvyje/PkXi/5BwE2qpaRt
         2tubw+s6+CS4mrjOx+8BXGC35Br8aO+ZnbVblh8g0gJkcIr1ckLojb43b7UD0kefFGL6
         xuEhN//Haw0J9aoayuM1iX52Q6q4sD4kLANcGc5r4qexfO5nPxWaYMDFxw+6aU54WDg+
         kmbnzS3NBlPAoqRTASWCkRPNda4OSwDasVRBOlDv7k8ulqlsYHmgnWi3cKBnG1yD8Jpy
         cWRSqGsjUdCHjxt8e2Fhwjd2sJVp9eJ6W3shKttiB2j8IyHm16OJ+d9kzgepdJS4sg78
         84xQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779513680; x=1780118480;
        h=mime-version:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=iBznbaNytKaeuxLQ07f1x42nohkV0AU9qEgrbnMsn3Y=;
        b=UQNATY8vhaRZqSdx0bbMwj7OUeYSO3TRAcR8T1o+BJEJgRh6XSAX+kKB4pNtXKGuLX
         7YOhHdcYpcm/vAp1C/9JleSstEebB2C5QedVmwwl+DlBNiB4zIfF/xOQEBiyPCanHM9l
         ejv/TRTl2KDcSSQWNZ96zpmJHiY30mZvaOcc7uj5YtVWpk9g+8DATyDwZLFJOw2HQMV9
         l118U9r+RmhnQ6WkqyZkznQMn5wArrKi8gRemcThIU9VAmyCcyXmudwtLRYMerZCpYZi
         InBthRIARVBB1qAS2UpwCIOwzG2IigviblY2DkDdXLrbrj0+qmyJyuVipUjZtWvBP4e1
         KtGg==
X-Gm-Message-State: AOJu0YxsbuB/ay39tNKReTiDaq76DynsxaW6nPUs7m6n39phzWGIuTl/
	Jc4YvE76ui3MCJdueqWe9aSS4q1q0oztHUEB1jp3ajDLL076RnFg7/m04Z0E1bgSvg==
X-Gm-Gg: Acq92OFYxLXpumVpYBeCFnvirF8m3ZwtWt+7FxiUMnbGi5cyenA3U31QmH9M1QdEiF0
	b1/pvYXDSWlweruateLxRTN/U0DpEOV5N8NSrVd3OAfEvgOS5V2ALAvUkbuupW5qcySl5Ff7Ua/
	S0W2E3yQXGAWRa+hiiyh2PCzZ/tfrsYBSP/baPwL987A9UGBZjkSyRQwX/+SBoLwyfWlcBFQKP8
	Cm2F9y11o6tQY6++DMXvpv6CpQXPisXEOIv/xqAYcDgruCVgljs75Q6lJG5uy3WDT/WxHpIV8L8
	FO6I9bCdQSqmhJh3VzovfaM2/YdusgxM4HgbHS0Jxcd8+W0WZOtSiszxbbl90KfDoi5TWwmhQ0V
	aqWZqgEnEhhC06PKlITLjD9YYDSqq96andCg3sV7l7LUCfm6rXIXQHbPDkDycgIx7fX7Jp51XHI
	v/QaOPPo0FV15/0R0KRe4Xsw8Q9+xr0vIqalWRqpKVds1cdMLb2D715RWA96npkvvGquw50WpQ9
	iciZMQfGdCbF1Aly8rYp781JsnYrn0SvTWHNQiyntg8E942kV9/Jxpv2xD9I1xH
X-Received: by 2002:a17:903:17c4:b0:2a8:ffed:4663 with SMTP id d9443c01a7336-2bebe9eff1amr1343175ad.12.1779513679728;
        Fri, 22 May 2026 22:21:19 -0700 (PDT)
Received: from [2a00:79e0:2eb0:8:88c6:26b0:28de:ab63] ([2a00:79e0:2eb0:8:88c6:26b0:28de:ab63])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-36a72c4ce6bsm3466133a91.11.2026.05.22.22.21.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 22 May 2026 22:21:18 -0700 (PDT)
Date: Fri, 22 May 2026 22:21:17 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
To: Davidlohr Bueso <dave@stgolabs.net>, Fan Ni <nifan.cxl@gmail.com>, 
    Frank van der Linden <fvdl@google.com>, Gregory Price <gourry@gourry.net>, 
    Jonathan Cameron <jic23@kernel.org>, Joshua Hahn <joshua.hahnjy@gmail.com>, 
    Raghavendra K T <rkodsara@amd.com>, 
    "Rao, Bharata Bhasker" <bharata@amd.com>, SeongJae Park <sj@kernel.org>, 
    Wei Xu <weixugc@google.com>, Xuezheng Chu <xuezhengchu@huawei.com>, 
    Yiannis Nikolakopoulos <yiannis@zptcorp.com>, Zi Yan <ziy@nvidia.com>
cc: linux-mm@kvack.org
Subject: [Linux Memory Hotness and Promotion] Notes from May 21, 2026
Message-ID: <ee9615c0-41ea-a980-e58b-302e0e64dacc@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Stat-Signature: j3mfdn9q1sdorsnkokprdiwtmnwt31h6
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: D786914000F
X-HE-Tag: 1779513681-714110
X-HE-Meta: U2FsdGVkX18sD1r2mVfLBgqkO5aySBWMK3ISRCShvGDoTeHIw3kXbCclIDoJw/Ff4bgwPBMqt5aSRxT/WH6Cuoqfln3DLwgswdzdKBxVytYXE3QogS4Z+EGENT3DXkmKyiXpSCtD5cuzqiyTx1QJ5eIiMYhRJvBRIZIE4eJiWvtJzrs180Njmfs4dHOmbTTZbLPRGe3RYLA80eQY1Gt6uVAX9cG5yMB8l7YBherG0bqoJYG6P0tYyHxdEWtcZD2KWgp/8WRHpGKNDJ4sVhHt0xov1iOEng1vn7X39e55a/2fzDR1UTkL237GZIjpuhk6XgVv3/3zuTKb1OKZC1TOj+amz0xJIudFJ7ORUOHtQamobgTIFA/u1+O198Du6CFv4elJ6Yie1xwrpfL82jB7Cw3x3ABFfkDAUKoq+ulCrFtrO6sm+zjZafsVlH++/So8JeQXIjsc3vnD2eL8fHZ7kFplIcTiYTcdccY3UNDvj7+Va17pVKJr42Z9amZyVZv0nFTzAhAfH+58m1aZaM3dM4mC6639p0Ae8am9PC7iHnZR7wagNQF+9RQ7pLwCiHDUhRZaXXsmyFhtrnNI7LI3+npysaJqUgr2ERzy+a2nWKFqTj2mGLUG1KcBUPWwghaPFEZoMy73bmxdVX7TKjCtvCf9bDoM4Lwif/K1f7N5OqAT/rEJ8wL/N609T4OcbienuQr3g1NyXmW11j3o1rZ4QPMP0a7+Y0H19qhiF2e4rSyc+C7IseXWGRo+Z0mBWIq7VxdOFmXamtHPo73J5J76SVZdRSA5rgquUNg0gDYHA3SU8DoWrHkXVorgu+05wBm/ucpbRd4J99q2hXIMylswJ3Cqj6/yPRuqy6TEh5yuwcN9aOtzpXDKEuG08h+zoOGtGpSlUmqSaVIPqlxhKtbuLIosdDeo7wOfMzxwTddH1P/GOoanXlEOEc6IKp0xly7OA8FpI6CSKqFaOIH/b8t
 do7Rd0do
 6DX1vj2ERdDvEeBKVB6jIZ/bSLTi3Wz7GIzHoBctXEKsh6POfDal5Xn8rWz1RWXZGdH51Mzbs3QvQJng1RxKX8VAV91MhraUviIEO5ho62kZB+cbdEQ2Ke7c+S452mHYQAz3uoy2TqDhnyGEqbD/zVw7ZLaeDCWQRkB6sSqcpXd0/P4aM93mFJZiEaayAWhAX7Tzj0DkQT07BjUE6LAFM5OBoIolwOPyVLN/cA489XO0Dz3h5tPZiuT1IotuSWXnE6JjIl0z1qik4/Nz0eJ97j7fNzVHylRmyLEbnM6RgYgEvC5TDjhdAjG/qbkWlmQYCRVpwWhf/6vTDKOPqzOEQfC+H5RX+z5GOQ6WISBaH5FtECSO8O9P5356W+W4MjlGxXyioCzFsvMRndayFzN0Z2b+kXzTBQ8sVIyiaIodHv44Xl9NBy1n87oYTc9cT0msUMybkMdLoZaVj/6PpQQ/8ilwHdTyBpwLxm8sbPn4KLiE1mwR26hJMzB6u2w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi everybody,

Here are the notes from the last Linux Memory Hotness and Promotion call
that happened on Thursday, May 21.  Thanks to everybody who was involved!

These notes are intended to bring people up to speed who could not attend 
the call as well as keep the conversation going in between meetings.

----->o-----
Yiannis updated offline that he is planning on sending the RFC for 
non-temporal stores in migrate_pages() by tomorrow.  Upstream feedback is 
very appreciated.

We introduced a new addition to the group, Frank van der Linden from 
Google.  He's focused on memory tiering and will be participating in the 
upstream calls related to it.  I gave a brief overview of the topics 
covered by the meeting and the usual participants.

----->o-----
Joshua updated on his experience at LSF/MM/BPF.  The direction for his 
patch series looks good but will require some ABI changes; some feedback 
at the conference discussed the eventual need to support 3+ tiers, so 
extensibility of the interfaces is important.

There was some feedback offered at the conference from Google that memory 
tiering may not be here for another decade or so.  There was a hypothesis 
that this was related to the DRAM shortage in the industry and there was 
an idea about managing the tiers separately because there were dollar 
amount differences in cost.

Myself and Wei corrected this stance from Google: memory tiering is 
deployed in production and is here to stay.  We are strategically very 
invested in this going forward, so it was unclear where the feedback was 
being offered from.  Wei also noted that we are actively expanding into 
three tier configurations and working on how to integrate swap into this 
topology.

Joshua discussed swap as a memory tier.  He mentioned how cgroup v1 has a 
concept of memsw and how it treats swap as part of the memory footprint.  
Wei said one challenge is how we move memory between these tiers: there 
are similarities in the demotion path in using the LRU to find cold pages.  
The different tiers have different performance characteristics, however.  
In addition, CXL memory tiers can do direct access.  The mechanisms and 
policies will be very important.

Wei suggested that we prioritize discussions on how memory tiers can be 
used for virtualization purposes and what role the guest plays.  We'll add 
this to the agenda for future discussion.  Joshua noted that Gregory has 
been looking into how the guest can become aware of tiers on the host or 
whether it's abstracted away, so a very interesting discussion could be 
had about this area.

----->o-----
Shivank updated on the status of his patch series.  He will be breaking 
out the first few patches from his series and sending them upstream as 
non-RFC changes.  Offloading and DMA will follow.  I reiterated that 
Google will be happy to test and eventually benchmark these patches to 
support their upstream inclusion.

We discussed leveraging the migration reason within the migrate_pages() 
call to determine when offloading should be used.  I preferred to ensure 
that we have the flexibility to offload certain types of migration, such 
as only promotions and demotions, rather than all migrations to make more 
efficient use of the hardware assist.  I thought that heuristics based on 
either page size or batch size wouldn't allow for this flexibility and 
hard code behavior that may not be desired.

Shivank also pointed to patch series that are current work in progress in 
this area (thank you!)[1][2][3][4].

----->o-----
Next meeting will be on Thursday, June 4 at 8:30am PDT (UTC-7), everybody
is welcome: https://meet.google.com/jak-ytdx-hnm

Topics for the next meeting:

 - v7 of Bharata's patch series, including new IBS hotness information
   and NUMBA2 hint faults
 - v5 of Shivank's series for enlightening migrate_pages() for hardware
   assists and how this work will be charged to userspace, including for
   memory compaction, and separating the first patches out into a non-RFC
   series
 - v2 of tier-aware memcg limits, including ABI changes to support more
   than two tiers
 - update on Yiannis's RFC for non-temporal stores enlightenment in
   migrate_pages()
 - first class support for virtualization based memory tier support, how
   to leverge memory tiers in the guest
 - discuss generalized subsystem for providing bandwidth information
   independent of the underlying platform, ideally through resctrl,
   otherwise utilizing bandwidth information will be challenging
   + preferably this bandwidth monitoring is not per NUMA node but rather
     slow and fast
 - later: testing of tier aware memcg limits with Bharata's changes once
   tier aware memcg limits is stable and further along

Please let me know if you'd like to propose additional topics for
discussion, thank you!

[1]
https://lore.kernel.org/all/20260511-sdxi-base-v2-0-889cfed17e3f@amd.com
[2]
https://github.com/shivankgarg98/linux/tree/shivank/V5_migrate_pages_optimization
[3]
https://lore.kernel.org/linux-mm/20260428155043.39251-2-shivankg@amd.com/
[4]
https://lore.kernel.org/all/20260428155043.39251-14-shivankg@amd.com


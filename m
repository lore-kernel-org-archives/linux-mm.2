Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 483EEC4450A
	for <linux-mm@archiver.kernel.org>; Sat, 18 Jul 2026 22:20:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D98C16B007B; Sat, 18 Jul 2026 18:20:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D49E66B0088; Sat, 18 Jul 2026 18:20:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C5F936B008A; Sat, 18 Jul 2026 18:20:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 8BFD76B007B
	for <linux-mm@kvack.org>; Sat, 18 Jul 2026 18:20:04 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 044B61C06E5
	for <linux-mm@kvack.org>; Sat, 18 Jul 2026 22:20:03 +0000 (UTC)
X-FDA: 85003316328.20.070D494
Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	by imf17.hostedemail.com (Postfix) with ESMTP id AE0F840005
	for <linux-mm@kvack.org>; Sat, 18 Jul 2026 22:20:01 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=GqQjifQB;
	spf=pass (imf17.hostedemail.com: domain of rientjes@google.com designates 209.85.214.180 as permitted sender) smtp.mailfrom=rientjes@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784413201;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=r4fN35Xy0B8zaFzFTIutBvNuqSKDwsTPJ8Iqe7ZWG9g=;
	b=lQpm0np4WvukUeV33NYeuKCMDjN0IcctnRiq2LFBNtQjX40jCw+i0433UI/NUl7o/y5oda
	Tx7Gbb8tksaP6Xxqr3jFGfIwRxH/KCg6tuYlBZMKKuARXAR/lB3ff0h+WNkSzM184tt8Jb
	4pohCezxs5aejntNDbQQbKW1sWNlemc=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=GqQjifQB;
	spf=pass (imf17.hostedemail.com: domain of rientjes@google.com designates 209.85.214.180 as permitted sender) smtp.mailfrom=rientjes@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784413201;
	b=OLh6oe61tnHKKOKpmp+elUR2CK0CQVjfENg6dOmlvU2bj91CKpvomrKjsxVn5LkL8ADAz8
	4vz1I9B7tscTbEoTXi4YOLTgTqsztlM0y3xGYEBFJAJX0ohz6VUWVR7VMGayc+MyaKYJVX
	53sFX0zCbpflcukt662tCankMwWI7Ds=
Received: by mail-pl1-f180.google.com with SMTP id d9443c01a7336-2cede6375caso231825ad.0
        for <linux-mm@kvack.org>; Sat, 18 Jul 2026 15:20:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1784413200; x=1785018000; darn=kvack.org;
        h=content-type:mime-version:message-id:subject:cc:to:from:date:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=r4fN35Xy0B8zaFzFTIutBvNuqSKDwsTPJ8Iqe7ZWG9g=;
        b=GqQjifQBDWazuGmys/cHTIPCh9KVwhEn14feUDgWzgo9sAyAl9Crnau/EDpPSwFeSy
         diN9Iax58FtaCPHT1Nq9peI6lBOFdPXihmip/VwLCsCxBqdg7g57u+GPrJXDYSK6Ieaa
         HYmM+R/GfyacWeWE8a/nEkRNE5hvikwgJwDbAgcpMuROo84BA9PWaVshxArTv7ypLp4a
         hOotBN6yXsyUm0D5CRn5AqNUo2cZb1nnjm857RgPcJ0l5oa2E7LEg4oQVM2YAT4U9Nsw
         QhQtclbHLoxxGJ2DtQjX9qfg7F8nJg4Q3PL6U7wod8vquy+zACobdFI0N61vdF7lqwy6
         xTlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784413200; x=1785018000;
        h=content-type:mime-version:message-id:subject:cc:to:from:date
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=r4fN35Xy0B8zaFzFTIutBvNuqSKDwsTPJ8Iqe7ZWG9g=;
        b=ga4GNOhwhia6a4XS4cvSdOPi06LLDylqFNfLIRqkSygkebEEPRYIUa0DlgLuPDDEAL
         gEoyTrymj+dmKa/fnl9UmXrtotnUfnWDTwDNujbwyPmGnmelVAJ+cTfujt+E/4v3bhgs
         PyUNSPMjyfUM3t1ClwCpoOtamupTbXlAUIG2G2j02ngQPojm86Q+v65wp+HjPG94xJwP
         oFjC7FfEkf4XPpx6ef1SN66QBq6F0m8+xf1fXM5U1aW9dvpKNbAI1mGSfk4HZnBKRYKH
         LdkKPDlJlOSqpNlN5LHpENMOEwDtqKGYFtuZCvWz9fjjwTY6ijFCsU/YCcGRtl3pUELw
         rCvg==
X-Gm-Message-State: AOJu0YyMBkUu+MgPPlzmPmKd+uiN5sor4t5B6E7KM5cPIA4bP7zXTFzt
	2reZlHOeAsB+CorDawAb3qU73IgCIeYoXDnYTD7uGyHCPJFXjKeexaAyYRWlFOGQoQ==
X-Gm-Gg: AfdE7cld2f51s+pnbbWbmFqCnY7uI2N5B/CbKqxsMVKHPOppMul842dxdzJCawi+NQ+
	L7H2fX0b1GDN4K2llzcd8l2jPRJWkjAZMDqTsSXftiXD9emWAQ433J0UNrTU/VLOhy7EpSYZZag
	4y/mxNH8un3Q3IZTSHHihbYxDKVOazE7LB/zMdmGH2va7XfD4myBxDcZ7uk0RzqJJMXa7Tdg+87
	ylWrcLUXAyoRFZrQLCcfVN2XurVx1njmTve3PFvBCbr5FC8r1/fTJSA400ldiUb0w6ckeJVKAfU
	B9I4uzIEWfiLwHfn50rtz5+ottYJsIRL7lpK5ws65qnibMhLSufqBxzienrNwTCgWRYD0uTy3A1
	jfkuRKLoH+hi/iFSBgAWOdcS5XaGmRvie9DlpR2YdlyC1pPHk30u3VXwqve5EQ07Q5KQoTRzIbv
	UaHwz+GClATn3qjXHq+lfrT1fB5wF2vAewtKZFX8J/HAQR5Y+HzO8sIvqsXN8VWLImMbjsQyST6
	vC7Y6l+rAqoI1QrWwViT8Z00xIlLy+L
X-Received: by 2002:a17:903:1b24:b0:2cc:a859:d404 with SMTP id d9443c01a7336-2cf4a4d5af2mr2606395ad.23.1784413199893;
        Sat, 18 Jul 2026 15:19:59 -0700 (PDT)
Received: from [2a00:79e0:2eb4:9:5365:2f3e:9da8:d323] ([2a00:79e0:2eb4:9:5365:2f3e:9da8:d323])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2cf346da07csm32012185ad.52.2026.07.18.15.19.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 18 Jul 2026 15:19:59 -0700 (PDT)
Date: Sat, 18 Jul 2026 15:19:58 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
To: Davidlohr Bueso <dave@stgolabs.net>, Fan Ni <nifan.cxl@gmail.com>, 
    Frank van der Linden <fvdl@google.com>, Gregory Price <gourry@gourry.net>, 
    Jonathan Cameron <jic23@kernel.org>, Joshua Hahn <joshua.hahnjy@gmail.com>, 
    Raghavendra K T <rkodsara@amd.com>, 
    "Rao, Bharata Bhasker" <bharata@amd.com>, SeongJae Park <sj@kernel.org>, 
    Wei Xu <weixugc@google.com>, Xuezheng Chu <xuezhengchu@huawei.com>, 
    Yiannis Nikolakopoulos <yiannis@zptcorp.com>, Zi Yan <ziy@nvidia.com>
cc: linux-mm@kvack.org
Subject: [Linux Memory Hotness and Promotion] Notes from July 16, 2026
Message-ID: <6e07d152-d746-ad9d-9426-bf51647338d0@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: AE0F840005
X-Stat-Signature: hypid4ixjbwocp87qr78aaw81fgw8ooa
X-HE-Tag: 1784413201-54482
X-HE-Meta: U2FsdGVkX19WG2mHwyfj3qKzFwN73dBxItCQHTV3B7LMX0f6l6GDVv2IIqLAFjvezFZCpFifuxepIErOUlErp/Oue7T0ESy+J2JUEJsVY8h33ZfMDpUtKDHGk4pd2fL1JIPgTflbS2/IQXI9qGoHqry0CqUUAF6D1SngR+iZ0MDNWskA/GZJCsoo8/uJ3yiK7cDl3i6bWUpQ3w0/PYmJ0zgmNjGwDC/gjRjL/ZWVMNam9Y2waYEP9euuG5+6G2t5LH/IemcMC2W3ee1S7Q/6pEXdaY3bb/yRWUyYd3TCCA/GTCa1TVjB1reGDtuAKqVUS8Orus71GnMvk6lOk4rF2zE5lqUGySQeIBII1T2rmqdISl5I40D/JWQfCDex/x3LAI430Jli/r5en9AVPHRTpl5ZR+JJgGaO6XaZEF+otBJS2Pxameyer6BMFIQP4cMyg8AHi86Pe7Pzd+PZwuSBZpv8qm+wnhdWMljNQsNkc2htTMlcr34j1BMA6NwyS6k1KX7vjo/YUw+QidQd8jDxaeCqTw/+tzMiWCrSa8dSAu+UyhKSJwbC5Ua65YDtZDwGiUhZyp3NLnKIAJczdKsFYPHgJt/SKIfQJHPGKqH8Juxkl4wGiwTKhA5aaLQGDITQW3cIe8A9+ts8srieBeIHSjrpjw1oLpYQ2eXOPcfL3IJj4gJNixRc1JzwHBNNrQMOoFnotuOdGF4ZqTmoGWvw7WUnO2HU9QVbGV7eSDwNLpjAQ+eNLklpNc3mZx2E/M+2991ZMOM5HCo1dKjaTYeTJN7euein1ubpfna9K7WciUOxlDVNxrfrMdhdJ9H/F8gJxOEKNhAHthpc5JUhf6oJlorEovu8msJ9+i62O2Yb6U577dKyzutGgmjLdSQulNAPSpTzqZaOBO1C8yQw8dH8m0/EwUJeafRbjIgx1C6zmdKjn/uRO3oE/iemMFRYFGB1hEsafhjZKj0t7JwgBON
 E1BhXYnN
 askjpMc5QYkYMz/Ho9Mx5flgy82kQo4vUo7+b4q/ztZkh6mSMHlDqcvlgol/ypP+R15r99J70U5kxmsPJ31s4MAaBmBh6iEC00VknzoU4ruh3ELn4mnZcAN1jXEMZ2jQ09KtORAFLEoIrEdebujiGx5VMVp/5HaP3C46mTlsQzlpuapdE8gusksPLDctTIHkbWzCizKeCCh6U47hQRfbhBkN16QAkOVSv6XRR6mMXL9UQXkvb1L3BbjCCr+EgnoKGfbV+Ld700vnA5HS1phhQgS96lzXLzNCgjmADI3yxbaE5GEo0a1Xz7ODHZyJ0b5BL9MbFZju3Ebq30hjL5jVOeZ7NiOWgpG6Z6pakVREhqfIqUNcsTMle/ETWzwEkAtNRYtooFu0HJGaoZSy2d7isaMtZFqN2k3FFrmEzzsfWwQug5EqpRosrdcIqnEOUvKRkzu++UW5dWGVLyFC03CPgS0FfPuvY7XttSsPYY8wbniFCo5pSe+8N/olHHZ03Ydmi+p7rP3QUy+kAukMr01yREZD50j1Bre5toCModS+SfgFWdgOOLDSh9OM44eEQXF8NOPHfehKw+A+Y9Xo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi everybody,

Here are the notes from the last Linux Memory Hotness and Promotion call
that happened on Thursday, July 16.  Thanks to everybody who was involved!

These notes are intended to bring people up to speed who could not attend 
the call as well as keep the conversation going in between meetings.

----->o-----
Yiannis updated offline that he'll work on getting his non-temporal stores 
patch series on the upstream mailing list in the next couple of weeks.  
Huan also noted that would attend the next meeting to discuss the progress 
on memory error handling for NT stores.  Wei noted that ARM memcpy should 
not need this support, but Jonathan suggested that there actually were 
specific instructions for this on ARM although all implementations may not 
actually use it[1].

----->o-----
We discussed LPC in Prague for October 5-7.  The list of microconferences 
was available on the website[2], there are both "device memory" 
conferences as well as general MM.  Shivank noted that he and Zi were 
collaborating on page migration offloads as well as rmap walk batching.  
He is also proposing simplification of migrate_pages() and the ABIs around 
that, including context information.  I was concerned that we'd be delayed 
until LPC to make forward progress on this, Shivank was actively working 
on this.

Joshua noted that he had discussed tier-aware memcg limits at LSF/MM/BPF 
so probably won't have a ton of new content for LPC.  Jonathan suggested 
we may want to have a BOF simply for memory hotness and promotion work, 
similar to what we talk about in this call.

----->o-----
Bharata updated on the status of his patch series.  He now is working on 
finalizing v8 of the series that includes bug fixes.  There are some 
behavioral changes that support NUMAB better and more closely support that 
implementation.  He is collecting numbers on the patch series and, if 
there are no issues, then he will send the series upstream next week.  He 
is also working on supporting for the second instance of IBS that is 
specific to memory access information.  This will also be included in the 
v8 series to be sent upstream.

----->o-----
Shviank updated on his series of changes for migrate_pages(), now at v6 
upstream.  He is continuing to post as an RFC for now and has addressed 
Sashiko review and feedback from David Hildenbrand.

Teja Vojjala had been testing on Zen3 hardware for PTDMA and has been able 
to reproduce Shivank's numbers.  He had observed many context switches, 
however, and suggested we should be able to optimize this.  He asked 
Shivank if there has been testing done on SDXI.  Shivank confirmed this 
and said that he can provide a patch to Teja for testing.  I asked how the 
feedback should be provided, Shivank suggested feedback on the upstream 
mailing list would show more interest in it and we should likely pivot 
toward the SDXI use case.

I suggested to Teja that we should be able to product a list of blockers 
that are preventing us from productizing this support so we can iterate 
through them and get on a path to using these in production.  Teja asked 
if PTDMA is a legitimate use case and it is, but Shivank suggested 
focusing on future platforms with SDXI.

----->o-----
Joshua sent out his latest series of tier-aware memcg limits to me and he 
wanted to do more testing before sending it out to the upstream list 
again.  I noted that we will try to find two engineers to look over the 
patch series and provide feedback on the API and overall support, as well 
as any potential gaps that we see based on prodution use cases.  I'm 
especially interested in any blockers that would prevent us from 
productionizing this.
 
----->o-----
Gregory noted he was investing time in looking at how to optimize 
demotions and possible LRU inversions.  Once a lower tier becomes full and 
there's memory pressure on the system, we start demoting to an even lower 
tier directly.  He's been looking into better LRU ordering.  He is 
continuing to work on this and will send it out to this group when ready.

----->o-----
Next meeting will be on Thursday, July 30 at 8:30am PDT (UTC-7),
everybody is welcome: https://meet.google.com/jak-ytdx-hnm

Topics for the next meeting:

 - update on Yiannis's RFC for non-temporal stores enlightenment in
   migrate_pages()
   + update on Huan's support for memory error handling for NT stores
 - v8 of Bharata's patch series, including new IBS memory profiler
   support and benchmark numbers that were collected
 - v6 of Shivank's series for enlightening migrate_pages() for hardware
   assists and how this work will be charged to userspace, including for
   memory compaction, and separating the first patches out into a non-RFC
   series
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
https://developer.arm.com/documentation/ddi0602/2021-09/Base-Instructions/CPYPWN--CPYMWN--CPYEWN--Memory-Copy--writes-non-temporal- 
[2] 
https://lpc.events/event/20/contributions/?config=c513701b-9743-4b41-914c-c1f29ee2307f 


Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1924B606A31A
	for <linux-mm@archiver.kernel.org>; Sat, 24 Oct 2026 03:15:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20251104 header.b=fZQdoOPR
Received: by kanga.kvack.org (Postfix)
	id 22A5E6B00A2; Fri, 23 Oct 2026 23:15:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1DD0E6B057F; Fri, 23 Oct 2026 23:15:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0F1306B0B7E; Fri, 23 Oct 2026 23:15:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id DA1BF6B00A2
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 23:14:59 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 63256A7A1E
	for <linux-mm@kvack.org>; Sat, 24 Oct 2026 03:14:59 +0000 (UTC)
X-FDA: 85356053118.01.E77ABB5
Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	by imf09.hostedemail.com (Postfix) with ESMTP id B27CD140006
	for <linux-mm@kvack.org>; Sat, 24 Oct 2026 03:14:57 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=fZQdoOPR;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf09.hostedemail.com: domain of rientjes@google.com designates 209.85.214.174 as permitted sender) smtp.mailfrom=rientjes@google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792811697;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=6mjfshxghHB8LxqbbfE6EzJoUjcj/T8J8H8JO6YcZUA=;
	b=dKXo2ChJaKE69C249egQm4IG835Rbqh6OHKpKfVrmbQAiJj9VtTm5TWGuqUYxoFOhUYkie
	RRENXY/LPer4bTc2s+biIqhcsPik+12bvDSoFOLqC1dx9gct1ybX9tjmwIdzjqHlZ0AMAC
	UNUXUwoHsx0VpsEy4JTsa/7IhEkmAb0=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=fZQdoOPR;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf09.hostedemail.com: domain of rientjes@google.com designates 209.85.214.174 as permitted sender) smtp.mailfrom=rientjes@google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792811697;
	b=bxiWcaqiAf0/NCJ4heO7eUoPYHNvYgN4YwqX3Y9djpo50lKOMTD5r5iVuUKRUKy0lV7nQP
	Jr4jOMa6VOjdMdbh6sW/Z/SpSQJQRlmeOYs21ztiwX7V6OHkOkllzBzpKu3u1EYhsOgxle
	nH8T4I8p7HqPdUjjyr3oOrVKbpxzIW4=
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-2e8d6fcbba0so12955ad.1
        for <linux-mm@kvack.org>; Fri, 23 Oct 2026 20:14:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1792811696; x=1793416496; darn=kvack.org;
        h=content-type:mime-version:message-id:subject:cc:to:from:date:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=6mjfshxghHB8LxqbbfE6EzJoUjcj/T8J8H8JO6YcZUA=;
        b=fZQdoOPRyPg5/XS94UmzDMvJAzDe4PjHCGOaY0uRiQTp/IM0MPGNkSR8eVzc5oSJh5
         KI+cxC2KzkgNDTCdz1pb3v6xkT5qEv0U3XaYTOvLgnAhGpRxZIABNOEfxcOXkaXPMQR+
         WyjBlEceTr1TMOYwHoo5tQdYWiVtrulc98pRP3YTXMuTuRetV03AATEs1wMhfKelMhml
         ZSKh2bdc+msc3PXtFLuPP+H6n+cHOOdPfOsAPTLtxSP/EFCM8T1vAAdoW4mdIQhioGsm
         vcpDPWbAYsxyaTicqpJFwg6+zfGT9AxcmO/D4emWB+/aVNMeC+GVWgYLiwAxvachf5rJ
         k3bQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792811696; x=1793416496;
        h=content-type:mime-version:message-id:subject:cc:to:from:date
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=6mjfshxghHB8LxqbbfE6EzJoUjcj/T8J8H8JO6YcZUA=;
        b=hxsOWrFGSmS79QPMOWru1TI1Cd4rvMkD/XCNBRghh/9m+fI89Xy4QN4StDEG0EQsRv
         ZmQYS7/+DLMoUxOOnHuYauLsN89Sj+u+rmgaVKU9983EGlfmDuDj1L6O7aUHf4K5AjQC
         wd7mUPqe3bAItvDZFnoZy1yZNZaiG7DO4mwIag+DuKHLunuCIclL4y8xQ4E7VfBEM5bx
         WBXwP2fDg2wKXXIobomECsGUPFFvJDR3p7TgiYuMMXxhP2UYYopWWdzyue4s5JgWv+0v
         RP7Df+8Q2gTittKzcHnmyPCIApZFWR21Jy92zNEF6apjeZj/GwnyL6GLHKuOZSMM7iKb
         xTtw==
X-Gm-Message-State: AFq9FYLbj/4bZno0BG4OLDr1QMKKzNIR7sg7u4iS/msQnDOn3wwHoYzV
	7flajFDlesPv/ZoFczmqHBNdU8VFpoGshdInmMpNUcK8zvA93i99DhvbFxmjo3cYrYfgJf27dsW
	aZ1WPYmMI
X-Gm-Gg: AYBFou26DHYBhbEyCOUCqs/6cmzZbs/50yCjmIhzsY9DprR00ZYNTRm5GmgOFhuJiZA
	OpCKgavl3J7CKeUHNSmO8nc5EDNL4sZPJn8usTBEXx+VOKfJYOtYo6p6CwBaQWxdLtascumJ6ie
	jz0e4UALw9o8RvOUuAEYKI1guaCclKSEAipTwEIbMZptAAFoU1cNZL5PG5TnezlZhnKGTRO49xr
	5yKlA88z1+BVudC5GRSQZWx6u5w4vmRj3q/4o6rQZ+Dm0YIGCAey9X+KLDptQKTwuzooSBMG7gr
	uDxNtzC6ZRG44iRdO8l88QNN3kVvASNNAyYq31yCKICaRej/T28qyEX36vsct339YijKlyHVbxt
	F7w5EO9uvCKWpy7WuD1wZBRfrN47u6fEcqQ9Fj65/nNBIpzelCm+t4YGShvS2xb1f1a4FSAqPj8
	Gd8lIVW/odagwH8F2Mx5mfNizBBKx/r8rWTv28qljNKTFAp1+tfXpaY/Cj/OnpCcI5Uk6anZyS+
	C1/o20D0B3dIWwSGpLze6mHTDCG8JNz+MOOdrhyi+OTUSkmUOrTY0aKg5clj4EQ6hn+hjDyVC7e
	jZmThKIJIrK30raV3e2cn3Q4bfLywRdy6SwL5UthzO78pVabVwgar2nl/REmyZJPqRQtrizfx64
	OjKCnK5wm3bF1KI1CXUe4MMczDkpOHWQzwnyP4Ipb4x6SG3qVHTbmUYxWtPAlzf0UAw==
X-Received: by 2002:a17:903:2b0b:b0:2e9:73e0:2a6e with SMTP id d9443c01a7336-2ea9d17e185mr1487035ad.17.1792811695673;
        Fri, 23 Oct 2026 20:14:55 -0700 (PDT)
Received: from [2a00:79e0:2eb4:9:aa88:ce75:c103:41a4] ([2a00:79e0:2eb4:9:aa88:ce75:c103:41a4])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-cd8cccce585sm155624a12.26.2026.10.23.20.14.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 23 Oct 2026 20:14:54 -0700 (PDT)
Date: Fri, 23 Oct 2026 20:14:53 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
To: Davidlohr Bueso <dave@stgolabs.net>, Fan Ni <nifan.cxl@gmail.com>, 
    Frank van der Linden <fvdl@google.com>, Gregory Price <gourry@gourry.net>, 
    Jonathan Cameron <jic23@kernel.org>, Joshua Hahn <joshua.hahnjy@gmail.com>, 
    Raghavendra K T <rkodsara@amd.com>, 
    "Rao, Bharata Bhasker" <bharata@amd.com>, SeongJae Park <sj@kernel.org>, 
    Wei Xu <weixugc@google.com>, Xuezheng Chu <xuezhengchu@huawei.com>, 
    Yiannis Nikolakopoulos <yiannis@zptcorp.com>, Zi Yan <ziy@nvidia.com>
cc: linux-mm@kvack.org
Subject: [Linux Memory Hotness and Promotion] Notes from October 22, 2026
Message-ID: <a4676b13-ffca-636f-4590-640a1adbe422@google.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Rspamd-Queue-Id: B27CD140006
X-Stat-Signature: 5pt6i6pxdtxuyw1ckrs5fpi43nzpfpwo
X-Rspamd-Server: rspam04
X-Spam-Status: No, score=-13.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_IN_DEF_DKIM_WL
	autolearn=no autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1792811697-328791
X-HE-Meta: U2FsdGVkX1+P5D27J7AcyMHNJHFV6275h14FY1UIOYQTWVrxJpA+6BgWbDbwxrNL78JoTsu0CUgopQFYre4Qqx9CVbYmXXk6wrtZEF6+30Gv7cC38FsJ0ie5BCfi3pi1Dnnou7HtcXBcPvXzhDzPHFxjyil6HTfLi0W6vccfFtRdU4yS6IMRNNpnbBFBGO3XlBTaTzWrWed35S8oPESATbwx0y3rTNZDY+cLO7+0/SB9ZZsCM7XDUv5hygWuOuSUuWm1HeTM9s/ym11U1W7pI7L3QobdCEMOjLypvqPdR2OpI5ljG+W7vpoGaYtkpmHelmHeaL1HngiWGgEovGOyRFtx86XHNfVjL1xv6UsFdQxlfwfabuIuQQ6uQgnphhUo6MZ5jd3s0auT7sQ1yfCsI/gZQUzjvJivYmgOi6/68Ug1juhR9jawBQdZ7bN/8EGihEFgkQBsAWFfpY4+NinX/iKq8QkDU2Ht7ujvHd03uoAM3SuxVsoJnv9aBTMSh7LqCoDQN3hf9KujwXa8HXS6hTlv++WvQkViJz/RhpcB8xPOzwHO0fwoHV3z+LDloGnlJDsx3JAguVD1PaciWA+RzuO++wxk2UTXlJn3IBkiUKa2ScH62onBQA6gsjecxJ5Q5K6e3yDrmq0JaMHKZQr1UyNASxHvsyHHTEwr4PB22iQA0Fhv5w4jye7lvD/gL5VVAPHpHoCsJdJ2fpkR5gMdAQzpggJv/4/7X3GXNTaPXlzFqYX7NWM8ZWTj2aDXa6lTmAY48tQMstEJvaYolWBedXF3PUi9ZyB5ZEoIVhKrV0xYg0uajS5XAf0I1nBmsx2/tIT6125eMN2+Md1xw2aKC+l1U2R+HaNU5FQq1ixH8eZRiMW3YWqZIJUUNznZwjRVTUtV0Mkl3/KRusRD9zqNbx57aoASniAqo1/w2FxFlBiU5klVWJLHjhUBu0VbhD+wp6mmeBsNCpPqkmSrV/3
 005/ln9Z
 A/E13ltR8HOPOele9pTa8ptamUOzsgnAPEnM+3zmTnPnwq+23Fzt2pdFZ9rGAuGD3cSnHVXRMM2UYaHNDp9anmXjOrCQomcsM8jYkP+7pmHJESlhTtm9ORrR1lZRGgr8WbS1/Kufm85BQ2c7GtT4bJ4jG9K+JVuxYSF9WHb4mzonDoH9d09sKfBSy7h68I2WPN7F/9HkAqqvTgZ2gYjtOzJKgBlKR5u6trRX8hWy/awMq0UoSx79C2Xd8qmqFkimAYPPRIavj00ICeAzgVeb5xlQbUd+9ZQ2f4B3UGh8r9Q/sVnU8DD8EvgKWdiOUPKqAIzvGXEG2hWmxg0vez06pOMOroU2Wn47IesJqUZgBBAczvpmsmelwq0/6NK1PYBS5E63Vr79m8i0mZqWT+xH35OcNcOUwnujQIiVJcYCsXl8KKTYNmTTpjYkyIQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi everybody,

Here are the notes from the last Linux Memory Hotness and Promotion call
that happened on Thursday, October 22.  Thanks to everybody who was 
involved!

These notes are intended to bring people up to speed who could not attend 
the call as well as keep the conversation going in between meetings.

----->o-----
We debriefed the relevant discussions at LPC to bring everybody up to 
speed.  Bharata said the clearest outcome for him was to separate out the 
asynchronous promotion mechanism and establish its independent value.  
After that, sources of page hotness and hardware specific mechanisms could 
be integrated into the kernel.  Wei suggested getting the asynchronous 
promotion mechanism merged soon so that other things can build off of it.  
Bharata said he will try to post the next revision before the next 
meeting.  Gregory noted that there may be some pushback on asynchronous 
promotion with regards to cgroup charging of the cycles.

Davidlohr noted that this matched his expectation and that he is working 
on upstreaming the CHMU support as a CXL driver, currently using DAMON as 
its backend.  He'll then wait to see the outcome of the other patch series 
in parallel.  Jonathan questioned how integration with DAMON would be done 
to eventually support the asynchronous promotion stuff.  Davidlohr said 
this would be done in the most generic way as possible.  CHMU has a 
natural interface with ranges and large continguous chunks of memory that 
can be passed to any interface.  If pghot is confined to the NUMA 
Balancing aspects, then CHMU wouldn't be integrated with it.  Jonathan 
asked if we're really getting large contiguous chunks of memory from the 
CHMU and Davidlohr said this is what he is seeing in his evaluation.

Bharata suggested it may be difficult to get the configuration of DAMON 
correct, this is a complex undertaking.  If the only way to use CHMU is 
through DAMON, this may be challenging.  Davidlohr agreed the 
configuration was more complex but if you're going to go out and buy a 
CHMU supported device then you can likely configure this correctly.  Wei 
asked if the CHMU is implemented as a driver and Davidlohr confirmed that 
it was; in this case, any backend could likely use it.  Davidlohr said he 
would send out the CHMU series and then extend it through sysfs before 
adding the missing pieces in DAMON.

Gregory made an interface that took a list of physical addresses or 
folios, the idea being that a driver or external service would send CRAM 
information on the memory to promote.  There didn't end up being an 
important reason to only be in CRAM, we could implement support for 
private nodes.  For normal memory tiers that happen to be on private 
nodes, the hotness becomes important and can require additional plumbing 
that will evolve over time.  This will become more obvious as private 
nodes moves out of RFC and into a formal proposal.

Gregory updated on the CRAM discussions as LPC.  He had a lot of 
discussions and there was general openness to the first user being HBM as 
the minimal upstreamable place.  There isn't a big leap between this and 
CRAM.  Jonathan asked how hotness tracking is being done for CRAM today, 
and Gregory said it can technically support NUMA Balancing and another 
approach is pushed off to the driver by telling it what to promote.  He'll 
post the next revision of private nodes after the merge window followed by 
CRAM.

----->o-----
Huan updated that he had sent patches to Yiannis for supporting 
non-temporal stores and memory error handling.  He will post these to the 
upstream mailing list soon.  It supports folios, not just 4KB sizes.  
There are some changes to the interfaces that are in flight that may 
result in some changes.

----->o-----
Shivank discussed two concerns for page migration hardware offload: (1) 
there's an assumption that SDXI would be idle so there's a concern about 
other processes using it -- there may be competition between kernel and 
user, (2) if batching folios for migration, there may be latency before 
the first folio is available.  For this, we could use a migration mode 
that is not sensitive to latency.  He is planning on getting the easier 
bits merged first.

----->o-----
Joshua noted that he was going to follow up on his tier aware patches 
after the merge window and requested that anybody with use cases for it 
would express that on the upstream mailing list.

----->o-----
NOTE!!!  The next meeting will be after Daylight Savings Time ends, so
the meeting will be one hour later if your time zone does not make the
switch.

Next meeting will be on Thursday, November 5 at 8:30am PST (UTC-8),
everybody is welcome: https://meet.google.com/jak-ytdx-hnm

Topics for the next meeting:

 - update on Bharata's asynchronous promotion mechanism separated out
   from the rest of pghot, targeting posting the revision before the next
   meeting
 - discuss current status of CHMU driver and its integration with DAMON
   or any other generic backend as needed
 - update on private node support as well as CRAM to be posted after the
   merge window closes
 - update on combined patch series for supporting non-temporal stores in
   migrate_pages() with memory error handling (series from Yiannis +
   Huan)
 - discuss Shivank's series for enlightening migrate_pages() for hardware
   assists and competition between the kernel and user use cases
 - update on Bharata's support for sources of page hotness and hardware
   support
 - Teja's update on SDXI page migration based on AMD patches and hardware
   issues being encountered that do not result in page migration
 - update on tier-aware memcg limits status and production testing based
   on the latest major overhaul
 - first class support for virtualization based memory tier support, how
   to leverge memory tiers in the guest

Please let me know if you'd like to propose additional topics for
discussion, thank you!


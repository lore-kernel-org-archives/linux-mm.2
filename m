Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BAFE8C9832F
	for <linux-mm@archiver.kernel.org>; Sat, 26 Sep 2026 21:43:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 84CA56B0088; Sat, 26 Sep 2026 17:43:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7FCFB6B008A; Sat, 26 Sep 2026 17:43:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6EC096B008C; Sat, 26 Sep 2026 17:43:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 39B1F6B0088
	for <linux-mm@kvack.org>; Sat, 26 Sep 2026 17:43:31 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id AB2DE1204FE
	for <linux-mm@kvack.org>; Sat, 26 Sep 2026 21:43:30 +0000 (UTC)
X-FDA: 85257240180.01.DFC8087
Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	by imf17.hostedemail.com (Postfix) with ESMTP id 0E08540007
	for <linux-mm@kvack.org>; Sat, 26 Sep 2026 21:43:28 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=OY4ESFrU;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf17.hostedemail.com: domain of rientjes@google.com designates 209.85.214.169 as permitted sender) smtp.mailfrom=rientjes@google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790459009;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=NOH44JwH5Kn0cST/pI6Ly2X+L/2neQN1cWQMIsqwXb4=;
	b=TvruvI1zCZssiqm4hX1Enqg7OUwq9Zl6iauUU7llvF1AabzAzPNu6mrcRoGlWgKz9LdiQN
	6C3p/hK073eYLaqf4OriR5wwS8cEjjRucRpWDIufLduqPUvsohQ8BXNqCjhyWQ0t6UouQ8
	0lX9Be6IoQB/G9ow3Dc7RgSUoSvZ0AI=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=OY4ESFrU;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf17.hostedemail.com: domain of rientjes@google.com designates 209.85.214.169 as permitted sender) smtp.mailfrom=rientjes@google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790459009;
	b=5ynZ9pKvYw82XKUpV+0uLaVajwRJNupQHmpbvnqCMDUjpwLvNc4/vgZgfMEFl42iL95bXv
	kevW/0Bd00PRpFWYFsKY+0cUsnm5XfALq23Z4Yoge3Hknd4KEmJ/HLF7Oow16uKAivA+t8
	kuyIvLrLJ6V8+dP2ND6AcuQAarTcCqo=
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-2d8fd7a3f38so31965ad.1
        for <linux-mm@kvack.org>; Sat, 26 Sep 2026 14:43:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1790459008; x=1791063808; darn=kvack.org;
        h=content-type:mime-version:message-id:subject:cc:to:from:date:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=NOH44JwH5Kn0cST/pI6Ly2X+L/2neQN1cWQMIsqwXb4=;
        b=OY4ESFrUXCnRr0cDuaXU+NPkQZyqY0ljbUY0Qlb+ehdYGSeKUDdT2Lesc1fyIdLtjU
         lPI+JVTuW85OjRWWIG5B0ypTQHIzChcXwXaqQQkPsIJEyu6cD6Giva+OGEr6+WhjJaOg
         sKss7vSN5LxJ6Bv3bL+RomrB/zDA5MFl3yDclAnqeT21rrfTRiDvu6l9zvXqlmUBHf5h
         Gr60mQ5IWvX8M9MmNoUEiefAi9Y4j78O1ZpLCDD+nCLZ/U0L5FPwsJxidmjbD0lMQTwm
         9qdJomQkGIWHzAb9Ixl68Yfv0ddNiwVFqXWZ6lL5TrLckS5To9qRLSDspIMraq8EZ1vG
         6gUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790459008; x=1791063808;
        h=content-type:mime-version:message-id:subject:cc:to:from:date
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=NOH44JwH5Kn0cST/pI6Ly2X+L/2neQN1cWQMIsqwXb4=;
        b=n4PA5auJhPlLDq+e0DlKV9pywpTJMm56lFnKte9IN7rgnXuFHt8Ifj4IP5f5JPv/ZC
         GNYR+XrQp2hIFcwZBPi70uar/an2PbbWF3efyafcv893TjmV/ciSRmDNSIgoiN4LlUko
         tep1X0m84d0NPuUOuMt4omcfgWmnQ+bCm6eFy4zv464FZHUjzjz4o2H3hyahDL/IjV6i
         3Cf9dYUrM5VjuuorX46W8rdvvGw99q4i1/MnXM4E4Ts/W7G5k0sFO/TGwKDRTqp7QR9g
         cWVJsiep/8Toxoa42y4vQHQuS5ICpoM6c5r9v7rhvrNQVqwgun5Ylb9rdLt4FQtOTdHc
         hiXQ==
X-Gm-Message-State: AFq9FYKNCz/FTa8B18jD2wyluQqbCKLWpgezaaE0VZvZcfN7NLuppnx1
	If60hj5ZV7sumwNdEmOoiULxsqrAI8R8xiD4Md76mHca+AMseQdVDwkh8FmutDvo8g==
X-Gm-Gg: AYBFou1R2FhTuSI4dTngFTiISnxUhE2aqhTaBHvQ/xPxzTmp0rU7N44FlreF5Pv2/IY
	PrfFAruaZf2OlAAOVF+MMYcHqTmbNwIRIMr5UYLtxKE9INhNyhmvKEG2LhTd0/HFWfHelV7J0iB
	1XGQmGAqJBxsU4iKBzPS26Hf4vy0CJz+PJO3+nT4Z19ZNJEx3MmhS04jLw8+lk02fNfUymsaKEK
	aUIjfexLQoG0rxmBj/EV/0qCsxrKnDAHfCRSOVt7AXZQ29BvE6X+7XwirEDhrOwJrBeflit+eZY
	J6XMZRsA+xJ88mtljDCqtJGrksiuoL3PsLrrRjdAEVHdlHlqlH56kai14mZzlPL97I/rT0o1y1e
	0YWZzvoVPArySb4PiiUaeNwVFjZdHy2sNyWIWL+uHDM+6qLV6ENBITlZ06IDE+FiRRMkrQcWzfp
	8rxQuESWNLSHwE1Mp0WeE+Vi06UfTzuOe5JTkfb0ZH+4w53kSSOnZhDSOmRiAbAE8tcTe56VCaX
	r5CCIssatrK6Yza8n0ASx9DScNhaPJ5VRql0HQAJpPIilS8SU5yAbTwmMPdVFA9Q8yQsmZHMMMG
	ZGuesvEce083UIYY0R7x5LxxJfOocHWQQBtB7pJbFmS4eQ+ntMLTvd5bQHtmJN+OHGNnenHFI77
	jpN5ktTE=
X-Received: by 2002:a17:902:f601:b0:2d5:db38:8013 with SMTP id d9443c01a7336-2dfa62423aamr3923435ad.18.1790459005911;
        Sat, 26 Sep 2026 14:43:25 -0700 (PDT)
Received: from [2a00:79e0:2eb4:9:125b:13f7:c69d:3887] ([2a00:79e0:2eb4:9:125b:13f7:c69d:3887])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3a0b898cabesm11736892a91.0.2026.09.26.14.43.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 26 Sep 2026 14:43:24 -0700 (PDT)
Date: Sat, 26 Sep 2026 14:43:23 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
To: Davidlohr Bueso <dave@stgolabs.net>, Fan Ni <nifan.cxl@gmail.com>, 
    Frank van der Linden <fvdl@google.com>, Gregory Price <gourry@gourry.net>, 
    Jonathan Cameron <jic23@kernel.org>, Joshua Hahn <joshua.hahnjy@gmail.com>, 
    Raghavendra K T <rkodsara@amd.com>, 
    "Rao, Bharata Bhasker" <bharata@amd.com>, SeongJae Park <sj@kernel.org>, 
    Wei Xu <weixugc@google.com>, Xuezheng Chu <xuezhengchu@huawei.com>, 
    Yiannis Nikolakopoulos <yiannis@zptcorp.com>, Zi Yan <ziy@nvidia.com>
cc: linux-mm@kvack.org
Subject: [Linux Memory Hotness and Promotion] Notes from September 24, 2026
Message-ID: <0c8a7227-c7eb-bef1-7326-c7b04cde78a8@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Stat-Signature: tyb3zwcjow6ukzg761sf4ux3gt39cowb
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 0E08540007
X-HE-Tag: 1790459008-604615
X-HE-Meta: U2FsdGVkX1/Mxen8VNNpx8qmUOJiQE1MRtNppW+DEMP7Qo6PK7oyL9gINXTQh4nigd3l5zH8gZsvJOq8Lktyc1W5UQ3q6VvJW0e4zmLc2t3w2H99d248ceIVPtZyjFonzjAwXFXe6xv8QK4qtdkDIrl0g2qRa8RlWNw2epkXVuiWgaqdyVDG9q5u061K1/0Adq/UYAVCTqGm9Av7nAM3OOrWE/KhM5CDWoeV75Ks1suYZNsePZdZxQAezjbj5lnhas9wGQkyiIMKUK51qznxVKfNADWvFgvi+DNhLvHRfat5wTAa+pxZ3KKv8uvkg9C97LeWdMgSi3KGGlK0SwNR9v2gMir/EvhSDyYaL9PXo5rqC0vjA5Vshfwi65vgBNpBCd8Uq+zPMZ7NOwkR3aEhDtunmC495xrP1ZQLzPg09k23wIpBDHDevEEI4R37WLMysEncnWAJA/hKApY1kHgBZqcUKPFf7TeyL40PB87+ukDhupsyyRdJwxwKcOZCYyhREsYy43c54jpW+ODl+vYJgOITUISbP/KX8YRwrRuoZfHZBXC4aQ22LqbtLaiZjvfdVY+Bg5Aq/PQMsjGnqEnEwrd9LlNQgYYBzkPQrtScakV7BxGIZIzsmrcqdhXmHoEbTnZ3fDoRY+djXxYjvsJ55/z7Fu0KGgUp9yzjNiLTM9v2JdhxdEmsOj0thSCwbg8tdv/HwaWuT7jBKhZvAN6mbm8fLfAvrk8B5hZQdkwrTI8QWE7ZnikYQTOlWTigyV0sO4UI+q+AcM853wVXl6AMqJPo5UDMU0EIyJqtlGyrZLjtIVVudYCrJ1gu16ChE6Uuax2TcXoDyR7LK7Xc0LAF/JewuwsiKlxcTkojiO9Shb+4IYTjcDc5n9uJR7WyVf0vj3ExIReBUOcO5VRwbi2n9J/eYaKUg/cPCLg6QU7EtTFLdq30f3t1f1nAPDsNm8ThmyxH2ixXw2p4r0Myfh0
 +0c85Zzy
 5gg8BWBHeL3AISPNa5YcFVkhWDXbykYx+vT2hM4Wqyfuks+mbl+l+yK3ye6JgdcJR+TWU5UNgf4STjE55RBmBbezFeQpLVwd1sJOmc9eAVUkjiIeLmpJJV2iMw1UFqkyzIZZ0zuQ3BjTSJ5ledc0Exd2lZMBWqLJf/fj1uxSgD2vjUp857lyyfP8tTJ6UijKZ4U1ziPAdbsuE8njB5+7iPLtT73LnoyLeZGyYa5zgqVpQX4fkrn8DoHJ9UQdxwedF85HWKxdU3OkWcvCxN7tJsaRQval5IHkd80K2vZ+jEV6vKt+llT0L9GAJKb3KC21UWAOWnrTInes3PTFMwhOq0oMc9/GHrTZEfDZNlnjWQHfpoMJqSwdAumDQhxmKYXaTVPTaE9NNkfkxYyQmWwaJl97ff5Rq8UHj6JDWB8UvENzQTjO9iOTgkkZpI320FytmBqscKjGqfXaymPhkQNvbpXT86f41/G4fscSJvxhzvViROcg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi everybody,

Here are the notes from the last Linux Memory Hotness and Promotion call
that happened on Thursday, September 24.  Thanks to everybody who was 
involved!

These notes are intended to bring people up to speed who could not attend 
the call as well as keep the conversation going in between meetings.

----->o-----
Bharata updated on the status of his work.  He posted pghot-hwhints for 
the IBS Memory Profiler as a separate but dependent patch series as it is 
x86 specific and the pghot patch series is becoming too big with multiple 
sources of hotness information posted together.

Bharata noted that the benchmark numbers for pghot-hwhints so far looks 
promising and that he is looking forward to discussing this topic at LPC 
coming up.

----->o-----
Huan updated on the status of his work with Yiannis for non-temporal 
stores in migrate_pages(), he prepared a patch series to send for feedback 
to the group.  He looked into Shivank's feedback and work being done for 
batching with 2MB pages.  Today, we need to do a loop for each 4KB page, 
Shivank's work speeds this up but Huan has not yet integrated this since 
Shivank's work is not yet upstream.  There are also mixed results posted 
upstream.  Thus, for now this is being considered orthogonally until 
Shivank's changes land upstream.

I asked if Meta was also going to be looking into these optimizations; 
Gregory noted that they'll be waiting for it to land upstream.  They've 
been looking at basic correctness of NUMA Balancing rather than 
optimizations for now.  Per his discussion upstream, it turns out that 
NUMA Balancing, at least for tiering, has been broken for the last four 
years.

Shivank updated on his patches[1] for non-temporal stores without 
overloading migrate_mode.  Feedback on this would be useful.  He will also 
be presenting at LPC including additional experiments that have been run.

----->o-----
Davidlohr expressed concern about the direction of pghot overall.  He 
noted the upstream discussion has focused on not having any regressions, 
but there isn't an obvious gain either.  It looks like Joshua had the same 
conclusion although PSI may have improved.  Davidlohr has been working on 
integrating CHMU into pghot and found the experience to be complicated so 
he ended up bypassing most of it.  Whenever he got an interrupt from the 
device, he would try to create as many contiguous HPA ranges as he could 
to feed to pghot; once he got that, he decided to promote instead of doing 
decay and got a 3x improvement over NUMA Balancing that he was expecting.  
He suggested we may want to go back to the drawing board with regard to 
the complexity and interfaces of pghot.

Davidlohr suggested we may want to rely more on user-driven proactive 
reclaim and can then tune CHMU as desired so there is some control over 
freeing and promotion.  Another option would be to integrate this into 
DAMON as well.  One concern is that if this is integrated into pghot then 
we lose locality information.

Gregory said that pghot provides value in doing this asynchronously, which 
NUMA Balancing does not do, and that avoids lengthy stalled faults.  In 
this case, Davidlohr suggested we may just punt it to a kthread that would 
recheck if it's hot and promote.  Gregory thinks we're proposing 
significant complexity in pghot that doesn't yet carry all its weight but 
if we were to focus on the async part then this could be a start and we 
could build incrementally on top.  Davidlohr said we're still losing 
locality information; Gregory suggested this is a general limitation of 
tiering in general.  Davidlohr said we could feed the locality information 
to the kthread although this would include overhead for tracking.

Davidlohr agreed with the value of the asynchronous promotion handling, 
including for NUMA Balancing, but not with catering to IBS necessarily.  
Gregory is a proponent of splitting out kpromoted from the rest of the 
system.

Wei agreed with Gregory's assessment although the data structures are up 
for debate.  We could iterate on the data structures for this.  DAMON has 
a ton of additional support and we need to discuss what all comes along 
with it if this is a general tiering solution.  Gregory suggested the 
asynchronous promotion work could also be used by DAMON.

Joshua broke down the components of pghot: device drivers, kscand, 
kmigrated, and pghot interface.  If they get separated, it would also be 
useful for code reviews.  He was concerned that pghot may be heading in 
the same direction as DAMON.  Davidlohr agreed with this.

Bharata, have you thought about the possibility of only introducing the 
asynchronous promotion support first, getting alignment from stakeholders 
on that, and then extending pghot with additional enhancements later?

----->o-----
NOTE!!!  The next meeting will be canceled due to LPC 2026.

Next meeting will be on Thursday, October 22 at 8:30am PDT (UTC-7),
everybody is welcome: https://meet.google.com/jak-ytdx-hnm

Topics for the next meeting:

 - debrief discussions at LPC
 - directional discussion for pghot and how to build it incrementally:
   focus on async promotion mechanisms first and then add enhancements on
   top of this separately
 - update on combined patch series for supporting non-temporal stores in
   migrate_pages() with memory error handling (series from Yiannis +
   Huan) for 4KB, extensions for 2MB later from Shivank
 - v6 of Shivank's series for enlightening migrate_pages() for hardware
   assists and his rmap batch series as well as non-temporal stores 
   without overloading migrate_mode
 - Teja's update on SDXI page migration based on AMD patches and hardware
   issues being encountered that do not result in page migration
 - update on tier-aware memcg limits status and production testing based
   on the latest major overhaul
 - first class support for virtualization based memory tier support, how
   to leverge memory tiers in the guest
 - discuss generalized subsystem for providing bandwidth information
   independent of the underlying platform, ideally through resctrl
   + preferably this bandwidth monitoring is not per NUMA node but rather
     slow and fast

Please let me know if you'd like to propose additional topics for
discussion, thank you!

[1]
https://lore.kernel.org/linux-mm/20260902-migrate-refactor-shivank-v1-9-9dcca87669c4@amd.com/ 


Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AD738606A326
	for <linux-mm@archiver.kernel.org>; Fri,  6 Nov 2026 23:32:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=jBfsFrI8
Received: by kanga.kvack.org (Postfix)
	id 9EEB46B05B0; Fri,  6 Nov 2026 18:32:12 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9C66D6B05B1; Fri,  6 Nov 2026 18:32:12 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8DCAB6B05B6; Fri,  6 Nov 2026 18:32:12 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 6139F6B05B0
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 18:32:12 -0500 (EST)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id DE67C12024E
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 23:32:11 +0000 (UTC)
X-FDA: 85406294862.13.9281D72
Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	by imf21.hostedemail.com (Postfix) with ESMTP id 367871C000F
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 23:32:10 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=jBfsFrI8;
	spf=pass (imf21.hostedemail.com: domain of rientjes@google.com designates 209.85.214.178 as permitted sender) smtp.mailfrom=rientjes@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794007930;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=wM60XYkzpSdeB/DJsbUxU2OvbUHo0twWWEWRlCj41e8=;
	b=cYIQxbzi6FdUGrV/Xex1+OzISzFPAnfBRGzHEP5IxizF9WcCFrExC/uBwPNXg8xP7yzYnn
	KP8QPXBqjctLPKBOGzs40CaKkLgtZ0uEEYXhZkYuh/YvU4KA0w8REozj63ft2V4Pdrf6Hl
	wtg/6FxzZlt2wheO64prCDTlFIaU7DI=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794007930;
	b=uUh4RMMEk7vZ8lhgkUT+xWui0H60BCT5vJA9disOcqWf/a0yuje6Ke2SUv2Yqt9fJRFpid
	4c4ZaZLHH7L7mvlU65UY86yjaIwYw+1KtQuyR1g+/PWi2i9j6KjT6OwzM+EEvNfJyifnlD
	JneVQz5SJ/P8fwa45FFeNFQL+V0k2HM=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=jBfsFrI8;
	spf=pass (imf21.hostedemail.com: domain of rientjes@google.com designates 209.85.214.178 as permitted sender) smtp.mailfrom=rientjes@google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-2ed3f563739so14235ad.0
        for <linux-mm@kvack.org>; Fri, 06 Nov 2026 15:32:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1794007929; x=1794612729; darn=kvack.org;
        h=content-type:mime-version:message-id:subject:cc:to:from:date:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=wM60XYkzpSdeB/DJsbUxU2OvbUHo0twWWEWRlCj41e8=;
        b=jBfsFrI8JOWJ2ccsnphv0BBtBaiGjyJti+JAE9k4cMu/aCNYJN5Ip3rcWj3tujW9h6
         1pWLh4exDG6JocALRRppjPHXsgo6S90zOAMDrpauTEts8tnk4F2pklbmtX2kXeORv4F4
         IfVgOuLcUN54fuJ2/3QBGQBnR2zzv031ljS1XetfZebktxAHTAL9pqCd11Ev+sI2g6xK
         J1CfHJ94F4imlFJyNl1x5tsVyGxZGWFcfbAksjwV3HDirS0Q6GOCKFMHzk+K0CblF+FR
         Y2yPCNFhTL0QObwTRnYjWE9a0fzHJnNroUORoasjs4nr7bP6pvnDXb8a9DdPOOSi2cBg
         dQ2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794007929; x=1794612729;
        h=content-type:mime-version:message-id:subject:cc:to:from:date
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=wM60XYkzpSdeB/DJsbUxU2OvbUHo0twWWEWRlCj41e8=;
        b=ZI7o6w7EooN+i7/FJxZoGLz3zcs4yWFs63F7ikbN7yl8MdJOg2Rfc1kaVA2hkpm2Xm
         NfbVX3ibmroDoEjI4OLU4/6YqiQYyXjeyozRsm2vlG+M4IAXoYDpDhMroVybA4E0vlNi
         C6tyXYWXv8h9egJ9fOpP2k506J9xOYDYjzEqD8RDGcIHGwkeH+B2cMIn+HZNZPcPD33u
         VB3a7+sGYo+XVksJQS1avkLbjcDr8wtVr0P7h8qskyD/yotl8EovtTzvcjx5YwtX3sjP
         /FXnaR4zH4dSZbo3jM7IyMavh+BhKuCXuwEadYWQY8fAopl8bTfeFerChjgRHdVoF1D+
         DGAQ==
X-Gm-Message-State: APuU4Z/2LbDsEhBX5qbZoL+POgXnWfdr2HA6SL+bzV5A9Zr9SDAgLPLc
	SRm4aeGYlEyQyTxcO9i/11JwiSITEIxIC/tFRjvM59e0Okk5ASu7GNnNOp11UFYAcw==
X-Gm-Gg: AYBFou2+xj5DMVCM13hNIrhgOxyVivBkdxQPV32Vcuo7PT2rzSgfctlCi27uB0dEvx9
	3HT5WwUBHC7P82LouZmWk3T4jHGX657dMGOhZlnqpvnrzIDg7WODW4WyGhaHkCu/h2yT5X0GLdo
	5SXY/oGP4yPjauSiM7TGltmwUF6tqHTuvIUJKlDGD+ZO1KlDwUmfcKWWH9AbxW8Aw+9UIBXteRJ
	bTLXfonoH7yySAbYVBAPTvEkBB/LP9xqc7UPAnPsAxNISyMo+xLOTPeIUubUIA2aK/4ZQs9Zx9i
	vMQCjr/QpODSQ4/oXnYJGzGtA/zAivXTSJ/hqTspk427qGtgvEkhY/bG19rzQkBiTy/0S02kjsK
	p1B2J/dihBKxGhO0CDj67bAfd092fgLmjE+jgQPhE3c7aVV4PBM5evfN6vb7VGKjKmz315nWytn
	5iNYZPmfm1dsUrfXUgM+MMf49MsIeBlXoWkBYyNeVlEj2PXozzJaumlSPKWHMJ6+bGf2SuWRVyx
	YGjLOZFhk+MjnMaVkZ/r0QUcOporfCPNt9fQEAIbpH+qZRGrA0mAZV5clwsztWvwdh7z3r5uHQQ
	FdkHhsvaZd6dAV0JJ9AmF9LieoDDPv6RtEk9el/hYdIbVZ/87AgzCYluowBiaClmk2cTvhj8Hfa
	ecvKI79IxJEMmYLGKnQ4zcdhUnEvXp88UZW9dFiz+rzDvLZ4Wi8xi8UAcEONbdr12dEP7Gg8JoU
	WqrnA4yO85RZfpYrJl2eU/nXqsMInvvbuHZ9GD3twyXrxhJ5qkNFigxyBpxse2rTwAgg==
X-Received: by 2002:a17:902:fc8e:b0:2e5:9bdf:6b65 with SMTP id d9443c01a7336-2ed66aa3bcdmr1314825ad.0.1794007928437;
        Fri, 06 Nov 2026 15:32:08 -0800 (PST)
Received: from [2a00:79e0:2eb4:9:3ac1:1213:5fc2:edb2] ([2a00:79e0:2eb4:9:3ac1:1213:5fc2:edb2])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b10580ca47sm694276a91.8.2026.11.06.15.32.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Nov 2026 15:32:07 -0800 (PST)
Date: Fri, 6 Nov 2026 15:32:06 -0800 (PST)
From: David Rientjes <rientjes@google.com>
To: Davidlohr Bueso <dave@stgolabs.net>, Fan Ni <nifan.cxl@gmail.com>, 
    Frank van der Linden <fvdl@google.com>, Gregory Price <gourry@gourry.net>, 
    Jonathan Cameron <jic23@kernel.org>, Joshua Hahn <joshua.hahnjy@gmail.com>, 
    Raghavendra K T <rkodsara@amd.com>, 
    "Rao, Bharata Bhasker" <bharata@amd.com>, SeongJae Park <sj@kernel.org>, 
    Wei Xu <weixugc@google.com>, Xuezheng Chu <xuezhengchu@huawei.com>, 
    Yiannis Nikolakopoulos <yiannis@zptcorp.com>, Zi Yan <ziy@nvidia.com>
cc: linux-mm@kvack.org
Subject: [Linux Memory Hotness and Promotion] Notes from November 5, 2026
Message-ID: <fe33f3be-5de8-9283-3b35-14bb9bded4ac@google.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Stat-Signature: xcr7f6jmrpoz9866kqtjcnzcci1zecms
X-Rspamd-Queue-Id: 367871C000F
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-13.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_IN_DEF_DKIM_WL
	autolearn=no autolearn_force=no version=4.0.1
X-HE-Tag: 1794007930-215786
X-HE-Meta: U2FsdGVkX1+w5FX+W8jHklKLENvMZRoNkSaM3yx+neJ4G5sLOQwKt/ZGaYOIqmc8VlgwN/ATirkhbKyKs0KyCQIFjLG1RkB4FjBG6IerO9ui/qK/bhfDyfUII3C3LAp+aSeOH1FxXQNHu/4326fSy5mNHBYoEesleESVgtRpx32qMIJKW2lJSXcGeq5PWu6vv1oNe8msdYrK20LkuppRifjrCS5RVMW99bibidAEsLYlSqYwz8ISvQCmVaS8qM3RyfTfkGAJUNLxJ4fz0nQb7JmVQa9K6R8ZKUOo5zXikNQlC5jSGCsYCYHHLX29X7ZrBZmm6nDaYAkNhSdzKG3PIblq4P46lUAm2HZteqpbDLRULM9g1y/k1HtTV87qS/KIbfwGv4gwjFldx5SsI8CAvFt7MhVckJjT+L6/Clp09qIPrxQnsCXU8zJG39mTLHmRetb7KIo4MT+q7Z3kbHSURq0x6aib9RdTbg3msaaOKQ9ABzYf2JkWiBDmVJsxUC3gyOgpAyBKOf2rY28JGSQVr/phIvAHbulbIYM/bblXzgDYJTM7cC9p4DO1Tx7oJNT+7krrOdP5fXFxvP9qafKZNvLA1sbm+iYPai2yIWESZh6rgrinEoleWSVjOPnDXYlEu1XwhqXK1x99QOYEtc/HBJVFd13cuCopU5x2vjjCVYbXlUFSR85Paca5EQVsMacmyJWMf6nPro4hkHF7T99edtoyGELS0KBtxWZ2IZ5nVlHPpth4PMA8BBa/J7hHtKomnseVbiNw6zUg4uBOxDbEsHh1KnG/9gZ6dtEgtFKcbTVSzcVXJUcNDxbB9jHCVo2Wl9fWcyckMlmoMJqPlIduCKj9zyQZMA3gyTCxOGx9X3iW5OL1AsJgXNEPOPU50y0hvn9YZUO7HLN9U5sCw2dHJaOYqK7uFc2cb5gTk/Nlig7xLi4MWiVtrZ/vXcfl/uzb25NgDrZWxl9e3/25O5D
 +F/Dfxr1
 ucwG0jzR51K97r/6NPzsl60rtHfqTet15fEXqOPhXtiu7RPdeS0adUenai8lfKR6C7XYPzJJzaGJ2baRJv5tqyIisR3r/1J4PQNp2LAvTPyU6aqMOJeAl4JWF3R3n3GqIXBVH0QsJv8EUIWk5H8IB4QNxlNNmd/FnTevCpVoe1mt/pLpJqsBgmWnAmKIqQp9EehUznPm3qU49h572758N1YuYNGzVZ8XErs1RBkRRMJWK/4day7aNYBYunB3ifqMV0NA23d0WZ8qotLPLxcFm8UNvmbG8CeLOd9L7jVuNNhyoqvWhWP+fC8hLClN/C9Myc2EERvURezDoPaK8E5wSWLLwq99uufWolccTFs8ROWPhqdDEhAY41EYPcmFUHDSIK9TSSUUfdARV9EeTghq6V7UbgvdKdCFoSzAukIPxyxhReToGUNK/1pZHPA+yUYxrjt8FTZL9ttVASJUFpwoiWmcbTep2OPklKTnn048KoPriZ8FgjQJBImssxv4tJVd+/uwMrLUP5OU+CHRRLTYmvpB5vrREK0uvIM5s
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi everybody,

Here are the notes from the last Linux Memory Hotness and Promotion call
that happened on Thursday, November 5.  Thanks to everybody who was 
involved!

These notes are intended to bring people up to speed who could not attend 
the call as well as keep the conversation going in between meetings.

----->o-----
Bharata updated offline that there had been no progress made recently on 
the async promotion work after the discussion at LPC.  He will follow-up 
in the next meeting to discuss progress and the next upstream patch 
series.

----->o-----
Davidlohr Bueso provided an update on integrating the CHMU driver, 
expressing that the generic layer might be overengineered to satisfy all 
users.  He reported that a working prototype is functioning with testing 
numbers similar to pghot, and code is expected to be released by the end 
of the month.  The driver translates DPA to HPA, providing contiguous 
ranges as large as possible using 4KB granularity for testing.

Jonathan and Yiannis discussed interleave details.  We also briefly 
chatted about the ability to derive sub-4KB hotness information for 
offline analysis.

Jonathan shared the original CHMU driver[1] with perf aux buffers which 
more closely resembled a tracing driver.

Davidlohr will continue working toward releasing the code.

----->o-----
I noted that an upcoming Linux MM Alignment Session would focus on private 
nodes and CRAM, led by Gregory Price.  The announcement will go out to the 
linux-mm@kvack.org mailing list on Monday.

----->o-----
Huan Nguyen provided an update on the non-temporal store motion posted two 
days prior, noting open discussions around integrating changes.  Huan 
noted that a patch for reducing overhead within single folios has not yet 
landed upstream, which will require updates to their assembly code.  Zi 
from Nvidia provided minor refactoring feedback, and Yiannis offered 
assistance to resolve posting and tagging confusion offline.  Huan and 
Yiannis will coordinate offline to fix tagging issues.

----->o-----
Teja evaluated SDXI for page migration in internal Google use cases, 
observing significant benefits that met internal requirements.  Teja noted 
a performance regression bug where an interrupt is generated for every 
single copy, but confirmed that the driver authors (Shivank and Nathan) 
are aware and plan to fix this in the next patch.  Once the small driver 
fix is released, Teja indicated the series should be ready for production 
use and supported upstream.

----->o-----
Joshua discussed challenges with upstreaming the tier-aware memcg limits 
due to complex edge cases, such as handling memcg charges and reclaim 
during batch migrations.  Reviewers identified dangerous edge cases 
involving tier changes within a memory control group where folio locks and 
reclaim clash.  Joshua debated whether to post a buggy series to maintain 
momentum or wait until all details are resolved.  I advised posting the 
series with a clear "do not merge" warning and a detailed cover letter to 
gather early feedback from the mailing list and Google engineers.

Joshua agreed to proceed with this approach for their shared heterogeneous 
workload use case.  He will prepare and post the patch series with known 
deficiencies explicitly noted, and I will coordinate internal Google 
review and testing.

----->o-----
Next meeting will be on Thursday, November 19 at 8:30am PST (UTC-8),
everybody is welcome: https://meet.google.com/jak-ytdx-hnm

Topics for the next meeting:

 - update on Bharata's asynchronous promotion mechanism separated out
   from the rest of pghot, targeting posting the revision before the next
   meeting
 - discuss current status of CHMU driver and its integration with DAMON
   or any other generic backend as needed
 - update on private node support as well as CRAM to be posted now that
   the 7.4 merge windows closed
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

Please let me know if you'd like to propose additional topics for
discussion, thank you!

[1]
https://lore.kernel.org/all/20241121101845.1815660-1-Jonathan.Cameron@huawei.com/


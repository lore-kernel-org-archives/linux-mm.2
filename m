Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 784BEF30283
	for <linux-mm@archiver.kernel.org>; Sun, 15 Mar 2026 20:54:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B4BE16B00C8; Sun, 15 Mar 2026 16:54:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AF9C16B00C9; Sun, 15 Mar 2026 16:54:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A06146B00CA; Sun, 15 Mar 2026 16:54:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 8BBFB6B00C8
	for <linux-mm@kvack.org>; Sun, 15 Mar 2026 16:54:47 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 175401407A7
	for <linux-mm@kvack.org>; Sun, 15 Mar 2026 20:54:47 +0000 (UTC)
X-FDA: 84549501414.01.1D3BC26
Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	by imf25.hostedemail.com (Postfix) with ESMTP id 6384EA000A
	for <linux-mm@kvack.org>; Sun, 15 Mar 2026 20:54:45 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=vvTn7cUo;
	spf=pass (imf25.hostedemail.com: domain of rientjes@google.com designates 209.85.214.175 as permitted sender) smtp.mailfrom=rientjes@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773608085;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=FcBMnjCfDjB6dMDoVyopzydyhSDBV/gPRQ0icRCnbPQ=;
	b=yf+lGyi02fqaixDmNqrdbpMlNAK8seBkbrAd5aOcBb1WlONMbtLksHKIYjANU2OjYkQe7a
	bj1gYzoTwVmU1Qi0CoOPDZcX6F4wgkM4qJfNavqoCCC3iP8tbWkGAH03Pho0xdkMWN7BV+
	k8+UYkz4gmbve8Gb4/N7JMCjVBZbqxQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773608085; a=rsa-sha256;
	cv=none;
	b=0VlL5ZVkvCrhkIixZl3vTTvE8l5DX1vQRYlgaiOmO3xLlz7xnZ2RK4DFDFNZTwaSqc4UHo
	w6+zaUZBmKVAfCUzBYAB6mYs+bOZ5IlKSMpyeKR0oTKKcuh5GEuGlQ1Ad2EopUg26QeqfK
	0amAXqt+D4LSsU3dYFofArtOJ63aIEE=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=vvTn7cUo;
	spf=pass (imf25.hostedemail.com: domain of rientjes@google.com designates 209.85.214.175 as permitted sender) smtp.mailfrom=rientjes@google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-2aeab6ff148so85525ad.1
        for <linux-mm@kvack.org>; Sun, 15 Mar 2026 13:54:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1773608084; x=1774212884; darn=kvack.org;
        h=mime-version:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=FcBMnjCfDjB6dMDoVyopzydyhSDBV/gPRQ0icRCnbPQ=;
        b=vvTn7cUol3teIpP9HvxugQX6mmtf8x44R22Krf+6+FFAjDjTKW11SVJfT0zIQT5Hx/
         +o4iM+IuXvbwId77tpMeYzP9TdmZYBvsW5M3d7LT0g2nDaoDuc7CiVaDNM22incouBzG
         SSCDxYJccRz0RLs7D8NhYML9QdjB9+ZoHXrbpBqIq5cr/lhEgqvBvVr6yFsXPTjqcXSg
         NIctWM+5C0oMPlOG128waBVfD2gDBgHOqL5A7ZB0Fg1d+5EfAiTlqR905gT/XK1+6Kql
         5B5k04dRV8NKEXutvnimgVpZnQnx2kLRW3UsaiZU5yVDQimDtI1CfLPhPTDwkdXfql66
         IMsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773608084; x=1774212884;
        h=mime-version:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=FcBMnjCfDjB6dMDoVyopzydyhSDBV/gPRQ0icRCnbPQ=;
        b=MXV86uRKCgWsvnfFsrkJYq70ettAZ5/LU/E4yGiu+tFxJTENYGjOM4CMpNG/qKre5X
         PaxbG8taYkCA3+1RYG15+kNdqRip/vtilJ4ZpChAM0jBohO3f6D2WW7DIdh6krvSlCzv
         HQNlTOBqJCaV/pAQQqXu2fcFNlEYWRlypM7QtCQxCGl/Bonc5sCuh0MK9PbiT4cWVOmJ
         cCktnngEQBuKIavLWzalawRhSWiZ4ZHovbkxloPIpRXTVAVsA6e8y5vcml/fD/EmU0J2
         VjRCHjM/tUXOrizVKQ32cL5QlNmWEJGm3J7J9i4/CJVBZrlLwIiqMxruk2VXZbM+eJ++
         J/Jw==
X-Gm-Message-State: AOJu0YzMsu1iTnJ8LID+Q75SjkhxWQIVAvyOtuctDw+R1OTgGni4X+QG
	oVsLTEsJwe8DhzifNDYr7AZq0qQ8U3hBDM3t21bBrrl2EVRCIB36woySl+gifKGslg==
X-Gm-Gg: ATEYQzwiGNbAGIzRQ+A7rc1aPK4F2WBhklQo7EtWWUF/P/BOZU2/9rWE7CJTqB7i11e
	oGr4GpenvtuKqmyC0nvegEX2CaJ7fSx/RSjWoK19DGZn+r3yrm9Z8wxK6eaF1YprceXa03ihjJ5
	f7L9xJibhFYuHVD/+qfYRqnmT+U1/wo+dY8mjCMezn7rc20lQhlmxFSu+6DpSEgU8Qx4gymnQPR
	YcMTRMtVs8HnN+r8BWZl2R5AbsFhHb1KIJfu1DuCMnsII7/rSuwkLjw+sVIdVbo/zjIfWEUGm0y
	gMdLrCRuHNG9LGFL2KqC0ImjHb2A9D1OHj5Z5erHFeHjFsAd4ZbE1mrxadEqMTU3JxkOBASG7Hw
	2SvPh+C80ey4a0RrOl16o2HizfbTahCIEFX8EyUTKuwcPmltiQFKKtLsGtKZEg2og7dTAOnxp8a
	DQTspbytp+4rJ4BDcVKIq73PE+aAwCTzUK5hmKjsh7FTAQmjBFOWkvRhqwpknCdlKQ0NPdvp737
	3Udxko5GZQtbehzPBhb3gB13SmDXpKEherYWAv8Ewugs/qpjjM=
X-Received: by 2002:a17:903:3887:b0:2ae:4453:3674 with SMTP id d9443c01a7336-2b04208842cmr3648345ad.4.1773608083507;
        Sun, 15 Mar 2026 13:54:43 -0700 (PDT)
Received: from [2a00:79e0:2eb0:8:3db4:c014:312:f50c] ([2a00:79e0:2eb0:8:3db4:c014:312:f50c])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-35b93912448sm1136833a91.12.2026.03.15.13.54.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 15 Mar 2026 13:54:42 -0700 (PDT)
Date: Sun, 15 Mar 2026 13:54:41 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
To: Davidlohr Bueso <dave@stgolabs.net>, Fan Ni <nifan.cxl@gmail.com>, 
    Gregory Price <gourry@gourry.net>, 
    Jonathan Cameron <Jonathan.Cameron@huawei.com>, 
    Joshua Hahn <joshua.hahnjy@gmail.com>, Raghavendra K T <rkodsara@amd.com>, 
    "Rao, Bharata Bhasker" <bharata@amd.com>, SeongJae Park <sj@kernel.org>, 
    Wei Xu <weixugc@google.com>, Xuezheng Chu <xuezhengchu@huawei.com>, 
    Yiannis Nikolakopoulos <yiannis@zptcorp.com>, Zi Yan <ziy@nvidia.com>
cc: linux-mm@kvack.org
Subject: [Linux Memory Hotness and Promotion] Notes from March 12, 2026
Message-ID: <5c757116-3e41-be19-8ae4-28f4398490db@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Stat-Signature: 98gbmjkw6q3xd7ogrwq5yeje68mghe3y
X-Rspam-User: 
X-Rspamd-Queue-Id: 6384EA000A
X-Rspamd-Server: rspam12
X-HE-Tag: 1773608085-869323
X-HE-Meta: U2FsdGVkX18+XQwIUUIei3mKMJERSFgND0xdPHePMor7H7HzIDfPRiLBsaiYljHJoLi3UifwD6SOX6/WI/3hVOTq7kcvPYuxZgtH2HTRWUB4YAYquyZ+9VU2N7MeTmv0uDWiKs3cB3TQnlcHBRNu7anj+11UzKH8gDgHC62kZjGcnjRXE3uysFTl9cjE/8waotkq+wE67s/ekfzvJTVT8KyB4HiRFqka1gvDsRKdSgmGCYaYJWQgQz553U5bZwJti1Ue2OcE6B4RZcA4t4Hf/xwRzZOo6SHf1nUTObkdQ5Ha+OOi4dgRoM0Ros1UlYZVrrfDWswK9aw9jDIMV1/OxY4PFdh26wMiLwLh0NkzW4x8O5rDvtFB+O0w7yPmVIIqcE2wAKkZvyVuz65g9n7pk/SCG8Y2LG/v3quYsldD5nteEExv4ALOp5FyPAijT/CR+USLznLvmZfv92qVCut3LcPexQrjvuFSKqfL4+hVu89tKpI20tE/1nOdtTZlFibRl7k6XQo7sHPaByR0y86qR8h4MvJ4avRZKRC7rwh3VD33puPfht1Vzj63fq7v/AkkAvt0M64BFPXGx2NqgRHlGmEe6qESj0CkoOOpsefT+3Cu6788k14K2oHjot53BJAivbLdfjvg5C8wJsxPxBOPbrjAacvALChEpw20DLJeDf3uWtabMi8TlcEBhuTM7tZykDQ4nNI0tQAPSye2nnsv/efmV/nk32OwvYFeoNVapaIGknT40XEnklcWL96ffQrrs1BsXKp/tcfhacYjQpeRDf5imd4ilmRHVd8Ar7Qhge5POZr7fbaO15A1KZfOyGtYF2frZvKC2u0Bkoj9fY4glGN7RyksRurIIz+S36trE78IBz3DO5QZNHs6VMe+9y0Fb4MxORwGVe8JIJAytwXTMKKKAvaXfytCe1AoCVrygQqvFLNWrLKznlz5Tj2IsdNIY3O8ly07J9nQgnZvuWS
 bp99YdGE
 /UviVnA3+lAq4eS9WuL4MQc+aFRv9vEv4u8oDiN6wuvN5qq8TfmF8Ldo+arsEVrfoicDKKUm5gq0GRSqJghQY5QrknqWZdCOvVqwHcFlazUotfdmrx3Izi2zKiqR0ERMLiLzXKS4XnK62Qs1XqqdZJdExszf/bHHReUKVjyofaE3k+GlqDRymFbOUa52U/1xIplm8w062zbqTiPUiNbojx0PBCD7bk9WLI3SUjCjZiralZAInKkvjT4xN+C55/KVExv7cUnrid8sjv1nOEPTbhmGJjBK0l/eiLT5vlsOTG3OvtM3MgXIpmqQOIUsnmNCLX0Uz8oAea7exH1vyggCmRxBgaMcm4wWEFp9qg74vavn4cybtPBU8K/ijz0sblsS9uPvzuNl8wYKMlSaUErac/bgruxI5Pia+tIRUK1eB3vGEuCg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi everybody,

Here are the notes from the last Linux Memory Hotness and Promotion call
that happened on Thursday, March 12.  Thanks to everybody who was 
involved!

These notes are intended to bring people up to speed who could not attend 
the call as well as keep the conversation going in between meetings.

----->o-----
Bharata updated that he is working on v6 of his patch series.  He noted 
significant work being done on NUMAB since in the initial work he had 
bypassed the regular balancing mode; he made the NUMA hint faults work 
only with hot page promotion.  In his next series of changes, he added 
back proper NUMAB=1 support.

This turned out to require that NUMA Balancing would start to depend on 
pghot.  All of the functions are required by pghot and this will make it 
easier when future sources of page hotness come later.

A concern was earlier raised about memcg stats reporting which should now 
be fixed.  There were other small fixes merged as well.  It will take a 
week or so before patches will be ready to post.  v6 should be posted by 
the next meeting.  Nobody expressed direct concerns about this approach.

----->o-----
We chatted about the upcoming LSF/MM/BPF conference.  Bharata's suggestion 
for his series was to continue the discussion on the mailing list since it 
was covered in last LSF/MM/BPF and then more recently at LPC.

----->o-----
Joshua had been doing some testing with tier-aware memcg limits.  He found 
in the general case when everything is behaving as appropriate that there 
weren't major benefits.  When there is a memcg performing poorly, however, 
this can punish those workloads as needed.  He showed a graph that showed 
a very wide range of performance with NUMAB=2 and then a much smaller 
variance with tier-aware memcg limits.  The important part is that since 
the variance is low that you then have direct control over where the 
average throughput could be.  He is going to be including this data in the 
v2 posting of his patch series.

He wanted to get feedback from memcg stakeholders upstream and discussed 
providing some guidance to end users on how to put these pieces of the 
puzzle together.  This includes translating tier-unaware memcg limits into 
tier-aware memcg limits.

Gregory noted that one of the next steps will be to test both tier-aware 
memcg limits with Bharata's series.  Bharata would also take a look at 
Joshua's series.

Joshua sought feedback on the best way to compare with and without 
tier-aware memcg limits.  Gregory said that we'll eventually move to 
workload testing but in the meantime it would be useful to understand if 
the floor of the throughput raises when you start to use pghot -- this 
would be an outright win.  Joshua was planning on having pghot + 
tier-aware memcg limits data to share for LSF/MM/BPF.

----->o-----
Shivank updated on the progress for hardware assists for migrate_pages().  
He said that he posted a v4 of the patch series a couple days ago that 
includes several changes.  He pivoted to doing pre-copy of data from the 
source to the destination and, if successful, then the metadata is 
updated.

There were no major blockers for this work.  David Hildenbrand suggested a 
few minor changes.

We also touched on non-temporal stores and enlightenment for 
migrate_pages().  Yiannis started work on this, there was some feedback 
upstream for a new migrate mode to be supported.  Yiannis has been 
discussing this with his colleagues and will be able to update; he is 
targeting having patches on the list in the next two weeks.

Wei Xu had a similar approach to the new migrate mode and ended up 
splitting out a helper function that would check for both MIGRATE_ASYNC as 
well as the new mode.

----->o-----
Next meeting will be on Thursday, March 26 at 8:30am PDT (UTC-7),
everybody is welcome: https://meet.google.com/jak-ytdx-hnm

Topics for the next meeting:

 - v6 of Bharata's patch series, including NUMA Balancing dependency on
   pghot
 - v2 of tier-aware memcg limits (reclaim fairness)
 - v4 of enlightening migrate_pages() for hardware assists and how this
   work will be charged to userspace, including for memory compaction
 - non-temporal stores enlightenment for memory tiering
 - Gregory's testing of tier aware memcg limits with Bharata's changes
 - discuss generalized subsystem for providing bandwidth information
   independent of the underlying platform, ideally through resctrl,
   otherwise utilizing bandwidth information will be challenging
   + preferably this bandwidth monitoring is not per NUMA node but rather
     slow and fast

Please let me know if you'd like to propose additional topics for
discussion, thank you!


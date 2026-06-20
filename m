Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 82493CD98F6
	for <linux-mm@archiver.kernel.org>; Sat, 20 Jun 2026 02:54:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6A0166B0088; Fri, 19 Jun 2026 22:54:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 677CB6B008A; Fri, 19 Jun 2026 22:54:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5B4E76B008C; Fri, 19 Jun 2026 22:54:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 1EAD46B0088
	for <linux-mm@kvack.org>; Fri, 19 Jun 2026 22:54:57 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 57EA2C2C32
	for <linux-mm@kvack.org>; Sat, 20 Jun 2026 02:54:56 +0000 (UTC)
X-FDA: 84898773792.27.2710B3E
Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	by imf23.hostedemail.com (Postfix) with ESMTP id 9589A140008
	for <linux-mm@kvack.org>; Sat, 20 Jun 2026 02:54:54 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=eo0ymUDr;
	spf=pass (imf23.hostedemail.com: domain of rientjes@google.com designates 209.85.214.180 as permitted sender) smtp.mailfrom=rientjes@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781924094;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=j0vlDoCbw77gfg1P+5UXxDNO1W2TOIpEV0Usb0adE/s=;
	b=iEon4tmajMvJXrca2iKmwDIIarfDX5W9D0j/jA0jfSkMyi4IwcFq4ZopFYjc8xLs7xy6aC
	g2MDSpRL0nKCtnm36qlQKiry10EyuwD8NBmZcfumD5r/halcNAsm8t7fF7jEK7wOPKd1pK
	gwZhEYclrL1dAqIaiIPF8lwhNbtvvws=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781924094;
	b=yErGqWYtQa6hRzD1NxeOiofsCp8OMYr3PGSrzAqOg7iThXVQ8X76STz44y/8kBsYAJOUZW
	9AVSY66LzA9i1Jr8pVmR9cqbHsLb4GYq17wUu90yAdcFKZrEzb6bqEHJobwMuJ+K/TG4ow
	bYxVP8UJC+YIj5QblaHycFPLzUXeY2g=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=eo0ymUDr;
	spf=pass (imf23.hostedemail.com: domain of rientjes@google.com designates 209.85.214.180 as permitted sender) smtp.mailfrom=rientjes@google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-pl1-f180.google.com with SMTP id d9443c01a7336-2c69fa0b1f8so79555ad.0
        for <linux-mm@kvack.org>; Fri, 19 Jun 2026 19:54:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1781924093; x=1782528893; darn=kvack.org;
        h=content-type:mime-version:message-id:subject:cc:to:from:date:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=j0vlDoCbw77gfg1P+5UXxDNO1W2TOIpEV0Usb0adE/s=;
        b=eo0ymUDrxEqC2IGF0JwAqyVCbnCH37PS53Zrn8OY7mNMRQuFjKWT4sSR9dQ4ZmhgzY
         LdAMAY69HRr22BaM12GBEJH2kBjLKJkZaNckwx9tvwUOkaBQUS8YfFB7pd0YdhIlMmQW
         TNIxsGHuJ+Z+hqMxkiT5jGbHjpZiLI/IoSw41RlUOoFQ+TETvGVYUi5Eu/it4DbLwlhr
         Y89AcR063b01z/salz8rFyhwTnL3ZKsmnF7sluJ2/wOoaQQC8ANgLRyeJUnr0+tUuWeh
         CY3VZL1cqcJBr3Bop057zMg4mLqASFn0VCu/j+L23WAePz+f/W13ZOWwCHfN6qUFtqWc
         0NHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781924093; x=1782528893;
        h=content-type:mime-version:message-id:subject:cc:to:from:date
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=j0vlDoCbw77gfg1P+5UXxDNO1W2TOIpEV0Usb0adE/s=;
        b=andExfPPpn1+CqNxTi3P17ElMcy9YELYVzF38bLb9U1bTDqsnULwAmt2sBlCH5nNfS
         HQY60qDJMOz51lXLrZPlmEv3aD+o4SKPGbnLFZOsdVz6tjLYjxB1rf0KbUxaLiMyv8QZ
         3BcvESIKa9VVrwgSzX8HnT1f6c2o/v1kTixnvHUDifNHwKu5PyH/x+ZB5m5SmTiI/vn/
         2yyURRn/8t/uD8pE6wCp99Ns7vVzcJC81O5bKCgqsE+TLY5vFDsppoT4DonMOF8UjOrm
         8rv/nJbNyVfLn40pACYngOwSUoUtr8eO2zmb83m5h7GvX/C99PV9vU0YZqEqjIJQkw3L
         lX4A==
X-Gm-Message-State: AOJu0Yw3PMwg/+fQx+RyZl/0LCOdjgLLRI6FZtfDU5b6NrxkTiq1bVwl
	fAu5BjI2YDERc+MrK3cD/V0WrqgKesjJ6TBsQDUWjq1C+NebBW9IpKv/SWxCfVd7UA==
X-Gm-Gg: AfdE7cn/J42H0xPFezKYs979EKPaDeBAnDx0pRBeMOiYi6c3x3qcpCBCKjhlT9bzn87
	fNuQNvh3xjJRR1KQjeCvVIIYapAJ5k3+M/5VB5j4zOHASrgwMqQr+dPlIRMi5Om1PTUKX8VhoLf
	FTzsQH9SkHuEsM8LVU1UqFW+Iu/25rRRgclHT7ffRgHimnW9tTbebiy1ckS0a22xxx5dCCFQwD5
	2dJzY4xLl04FQxNkiqxRkfQskLsZj00EZ3Wa4OHSE91EPZxApqf4/aFR6duWPXP3yjbNazx/TPC
	QaLS7z0DlqVK25TBsfPMMjx/XafmOqldvUfgzjbGQe2EGmhyyQT8nmJbtGyRIRvFUNMLwdqq+8P
	7gYZU1LViHjKdsSbU992LWy6eeuLUe4UrhDEauwqSi2OPniorCUivsfu5msmEmzm/6scTh39T+9
	4eUY+p+XOH4+IVm4jNcP5/VBKyrQSKsuynYjLfperzoQXXELs5sDoKzPFEYj2LMEGJLgr99vooy
	MV5+rhS9TCeHveqmPn2xi3RHxQ1vygU1Fc87vSCPrU=
X-Received: by 2002:a17:902:ec8b:b0:2bd:3c1b:3073 with SMTP id d9443c01a7336-2c718fa99bamr2394035ad.16.1781924092875;
        Fri, 19 Jun 2026 19:54:52 -0700 (PDT)
Received: from [2a00:79e0:2eb0:8:f548:65dc:ec64:cc16] ([2a00:79e0:2eb0:8:f548:65dc:ec64:cc16])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-c8bc563c406sm954121a12.19.2026.06.19.19.54.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 Jun 2026 19:54:52 -0700 (PDT)
Date: Fri, 19 Jun 2026 19:54:51 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
To: Davidlohr Bueso <dave@stgolabs.net>, Fan Ni <nifan.cxl@gmail.com>, 
    Frank van der Linden <fvdl@google.com>, Gregory Price <gourry@gourry.net>, 
    Jonathan Cameron <jic23@kernel.org>, Joshua Hahn <joshua.hahnjy@gmail.com>, 
    Raghavendra K T <rkodsara@amd.com>, 
    "Rao, Bharata Bhasker" <bharata@amd.com>, SeongJae Park <sj@kernel.org>, 
    Wei Xu <weixugc@google.com>, Xuezheng Chu <xuezhengchu@huawei.com>, 
    Yiannis Nikolakopoulos <yiannis@zptcorp.com>, Zi Yan <ziy@nvidia.com>
cc: linux-mm@kvack.org
Subject: [Linux Memory Hotness and Promotion] Notes from June 18, 2026
Message-ID: <cae6ab98-3441-38bd-1e07-4586a85cdc74@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 9589A140008
X-Rspam-User: 
X-Stat-Signature: eczukwjor7mtzgh1osy7msp1cy99rgkb
X-HE-Tag: 1781924094-465727
X-HE-Meta: U2FsdGVkX1+nJAhcRn/jl1ScU3CPf6qS4BBhNbTM0+iPzjwdOSzdIFlAu2O7NfrTYK86VpxLsFX0rt199MBOl0HozoslcA3CyZhZ5Plixy14jcM55t6/1stPZ67ZV/MY6IO5id8JUxAEtYpzykWnkwguQ3HjFgMajqd95nJ9XOyb7qoXkgplVdILbdJqaeYoN+kIc4deFctDwr3aRuRe8x78FNrzw+M3NNqtcJw466Ahxq9q4bTpcZ5spRdnTlL9h5OFBtq7nYhWJho7kxdn2YfEwkz7af8Eeyd2RxPyvMPRuYFzLDdzm65AIdoKzIhJEriD5+wYFkcgFhWFCgs4XhgUCXPZKQsx6Y0A6ZjNEii+c+eRhr3tWGQYnhHaQEqmxvUmwe7FcZtVZj52/EKNCDZPp55XgxgUULkZY/C7VHxzfpxBUM9bhZyQRImr6TbacZJp/DKydm25HnNTltwrg7/atK8NNBQyiaj+7JO9ayB0pYGAzpSZfwfezou1AyI/d42F3Cd0y3wKFYwpf7Ge6kRRSnwn3hnlIxrMbmFvajTafFUVOxhMsexX6kbvIx4XY3GamfgYlhHc7wnnfOkufe4m0G/AuGW35GtuNawgJl2V+doi7upilxhpvDmMhY87+MAKq5j/y7Bb12b7BZT1pQQ6SSaRze39dwVy/8Bm1qrWR/2+Bfo1fvpbpiqO8rMYFkEe9M0v17ZxM/SQUoh56NxFTZ55p+4VnSU6TO89Lnjkkf7P8Rzhau5mEQ/gCa6iI/FYmUx0hbHPA1Kn/kqvs5/RmpqJrFUd8mIHMH8D/vBoYJeUYkV6EJ9blnzpGGRGIX7hcGkhfSY5p2Xhg103MBgam++X6KFV+a2j4wJp+gLCb09eQVDEAiqxpURPUfYoOZjcH0ynJpl1GYPB9i5Ca+8GAddToQTEPlQOkyOllD4MgPEoTzo3KCLawSQDXhb8iCEjuFkUUJxk165CoYD
 7Ahd3Te6
 Aaf0AeS4YgEsRDTyoPYdiGppphMdkd06irX+ICFRwzQ5307DXToonmXNl0YUjqEmp+Tjyy5zsM9xbdzUA3sQmneU3Y167UfigPjcvuhJqaTmZ53QiRTNE2ZHR5m6DGWpoOUKQGA+HC+tuLUXWvoMdVLa/s8LDdGzBIbxL+0KGRkKGBWPp82uy9rfH+qJB4cztzDt+t6Sn5LfCl8hCdBUf+zzcTRvYHSwUcLjxnnI/6T/MIPxkrCwiUflKZQZkGFx2TgkQhqIA5UF8M8uJDRBYEXfRRcE3gZ9mzTnBhyr1fEMKsVDSdmrxTSR/FBJXqIoCN6Y6Xm2vqtANkckIBkG0uMRX9CYHuMKGHLk4xS4EtpTpE15hv8+/pUw8QNdRjpI5e/c0VWNv0w/Zt90tEDVdM7ZJD8bU9SpydQuh9Yf4f4rWeshiwzbiumL+GA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi everybody,

Here are the notes from the last Linux Memory Hotness and Promotion call
that happened on Thursday, June 18.  Thanks to everybody who was involved!

These notes are intended to bring people up to speed who could not attend 
the call as well as keep the conversation going in between meetings.

----->o-----
Bharata updated that he is getting more benchmark numbers for IBS Memory 
Profiler source with pghot and he submitted an abstract to LPC for a talk 
on IBS Memory Profiler.  The next version of the pghot patch series should 
be posted in a couple weeks with new benchmark numbers.

----->o-----
Teja Vojjala updated that he will start working with Shivank's patch 
series for migrate_pages() and collecting some benchmark numbers.  He 
noted improvement on Zen5 especially for benchmarks that are flushing the 
cache.  He was not so sure about the instruction that the patch is using, 
whether or not this will pollute the cache when doing demotion from top 
tier memory to lower tier memory.

We're working on non-temporal writes to avoid unintentionally promoting 
cold pages that appear as hot otherwise.  He also noted that comparison 
with other approaches showing a degradation when using AMD's patch series.  
I asked him to follow up on Shivank's patch series upstream to have the 
discussion.

----->o-----
We skipped ahead to discussing non-temporal stores given its overlap with 
work being done in migrate_pages().  Yiannis had posted his patch series 
as follow-up to the previous call in the series.  He noted that he took 
one of the existing functions for the pmem era and that it may be possible 
to do something better in terms of implementation.  We see reduced cache 
pollution with these patches measured by the CXL device.  We see a 
complete elimination of read traffic on the device itself as a result.

Gregory Price provided feedback upstream about the use of the Kconfig in 
the patch series.  That was his only question for the series itself, he 
thought we should be able to identify if we can do this offload through 
cpuid; if so, then we could always just use it.  Yiannis noted that with 
this implementation you could see a much higher number of instructions 
retired which may or may not matter.  The bigger benefit here was that it 
reduces bandwidth.  Gregory didn't think of a scenario where we would ever 
want to turn this off.  Jonathan Cameron suggested removing the Kconfig 
option.

I pressed on the new migrate_mode addition given the long-term precedent 
of the existing migrate modes.  Why do we need a new migrate_mode that 
specifies whether we want NT stores or not?  Wei noted that Google does 
the same thing because there are otherwise ABI issues which is a bigger 
problem because the migration callback does not include the reason passed 
to migrate_pages().  I was surprised that the only way to change migration 
behavior today was to introduce a new migrate_mode that would be passed 
into migrate_pages() and that this didn't seem very extensible.

Yiannis will refresh the patch series to not include the Kconfig and sent 
out an RFC v2.

Wei noted that some Google work was supporting memory errors while using 
NT stores and that we could discuss that in a future call.  This would be 
a natural extnesion to what Yiannis is working on.

----->o-----
Joshua updated on local testing for tier-aware memcg limits.  He ran some 
benchmarks where DRAM performance was the exact same as CXL performance to 
identify the impact of the overall approach itself.  The overhead was 
minimized so far to 1-2%.  He also did testing on real hardware and got 
similar results.  He will be going through this testing before posting the 
next update.

----->o-----
The next meeting will be CANCELED due to the Independence Day Holiday in
the United States.

Next meeting will be on Thursday, July 16 at 8:30am PDT (UTC-7),
everybody is welcome: https://meet.google.com/jak-ytdx-hnm

Topics for the next meeting:

 - LPC planning for October 5-7 in Prague
 - update on Yiannis's RFC for non-temporal stores enlightenment in
   migrate_pages()
 - extensions to ensure that non-temporal stores can properly handle
   memory errors
 - v7 of Bharata's patch series, including new IBS hotness information
   and NUMBA2 hint faults
 - v5 of Shivank's series for enlightening migrate_pages() for hardware
   assists and how this work will be charged to userspace, including for
   memory compaction, and separating the first patches out into a non-RFC
   series
 - v2 of tier-aware memcg limits, including ABI changes to support more
   than two tiers
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


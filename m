Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CB7A5606B379
	for <linux-mm@archiver.kernel.org>; Fri, 13 Nov 2026 08:51:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chrisdown.name header.i=@chrisdown.name header.a=rsa-sha256 header.s=google header.b=EIkpVXQA
Received: by kanga.kvack.org (Postfix)
	id F1DA56B061E; Fri, 13 Nov 2026 03:51:29 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EF4C76B061F; Fri, 13 Nov 2026 03:51:29 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E31076B0620; Fri, 13 Nov 2026 03:51:29 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id AF2D06B061E
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 03:51:29 -0500 (EST)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 40516120295
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 08:51:29 +0000 (UTC)
X-FDA: 85429477098.19.4B3DAC1
Received: from mail-pj2-f1.google.com (mail-pj2-f1.google.com [74.125.227.129])
	by imf30.hostedemail.com (Postfix) with ESMTP id 5DD9580002
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 08:51:27 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=chrisdown.name header.s=google header.b=EIkpVXQA;
	spf=pass (imf30.hostedemail.com: domain of chris@chrisdown.name designates 74.125.227.129 as permitted sender) smtp.mailfrom=chris@chrisdown.name;
	dmarc=pass (policy=quarantine) header.from=chrisdown.name
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794559887;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=77Y95W/UaJg257+QBwzQ+4jh+bph1WESxo/Gei8xe2A=;
	b=rmgXJEx/8Od+CuHzCsS0VfBPZ6AdM2bE5DjfoBrYcpek52HZv7/52FtZCOAvL93gpKfqnm
	8q6pXIHK8ylUfmDr7ucf4MQGYi5Pz1Jo7t6lVGFOpdZjWdWDNATjqz5qaAx8Dt/dcuOgi1
	IsjdzySFriWmAZ3St/2icljOJBbvXDE=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794559887;
	b=6twcZMdTJK0Z5D3Fo4E/EmI6ZrnxWSqs+u/Q8xdVGRACHr1LMVgP80angdvyaxf6P4Z1Jv
	S/BTlxtDpdbKI4CI1hn7/K0rx5mxrZtrTam4t1L9T/CzdKsFEC421njyFyxwRI7lfBdOEA
	Icgrxct81NExwtaei3DhBMBbedElJuA=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=chrisdown.name header.s=google header.b=EIkpVXQA;
	spf=pass (imf30.hostedemail.com: domain of chris@chrisdown.name designates 74.125.227.129 as permitted sender) smtp.mailfrom=chris@chrisdown.name;
	dmarc=pass (policy=quarantine) header.from=chrisdown.name
Received: by mail-pj2-f1.google.com with SMTP id 98e67ed59e1d1-3b10718b387so479702a91.1
        for <linux-mm@kvack.org>; Fri, 13 Nov 2026 00:51:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chrisdown.name; s=google; t=1794559886; x=1795164686; darn=kvack.org;
        h=user-agent:content-disposition:content-type:mime-version:cc:to
         :subject:from:message-id:date:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=77Y95W/UaJg257+QBwzQ+4jh+bph1WESxo/Gei8xe2A=;
        b=EIkpVXQAOdhYPAXSf5UPmsmcP9eyQLw5zF6kuxVx1hf6xYLK5E22MK4TSJY/MHJnIz
         ljYMnphBXEydyJKc7HwZxArhWK0IwN5Luww2ZG8QAD1ns09kic/Abm8ZnmrcpHBF5vSg
         aUBlSlVpD+BES8ITbDJYZ5upI8LEFe0lUWbeM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794559886; x=1795164686;
        h=user-agent:content-disposition:content-type:mime-version:cc:to
         :subject:from:message-id:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=77Y95W/UaJg257+QBwzQ+4jh+bph1WESxo/Gei8xe2A=;
        b=Jbz64dT557ATYO+4nWpYxSKI1WBwHYqGcUxruT2xHyIIbFr0ECNBQMpArMIO25SRK/
         N98XG5SI1SJViyGYcBybXKGi96H+Wj9xfCys3m/NIosQqEldYTpBy7OpJbzlk+t3m1OG
         2gf3kpQCoK6bwclhz3tLmWmxw575HaOV14VYfpJ7kvtfisSsUtLpEkgNvfvvulL7hEVy
         7VpEP2JxvKKgimTJ2Oq4K04urpIEukFvS0ZKw8k0s8H10UnxVs3hhC/26R4Uc4mx28p6
         +xgqs7sgAE7PakXawsUemgraPYFOE8vXAleMfQUFj9rwKG7/AecMD49s7xCCKDBzY/dQ
         0NpA==
X-Forwarded-Encrypted: i=1; AL+hErFOacRp+V7efsFDWB8HvBpaVAFNYAiwvp39XdTdriT/t8WKrg1tjd9yyy/HVzZgQREhdHNl+zyBSg==@kvack.org
X-Gm-Message-State: APuU4Z/lSZakgMDDGg0JxsREkP7W4qi7JZtyFDwwiy80zBuXQ4GmIFUS
	b/S2+4KrLLmmZlibQh2dMaLOsYohavbFnQZsbUMqN+k43j+UgHVD1rnAkvvU+7L83pM=
X-Gm-Gg: AYBFou1RsCii2xAfwJbM6lqS42uHD2jznTZ8g0l3tb01JgFMSFobfgmxdbEntQ8NM9L
	Y0QoLAvHIPTm2KsVBPULIG0x21+PFj5F2o+8H4SCB8Ygelwomdf6FJLeVpgj38VEUGthUvFPZE9
	d9pV5k9XKOEO/qQs/W0cIWKnyy5x4pE4g9fZUAX0qB7yiJ76n57QFYxkQd6bI9rCBclpdTogf8k
	26bABk+epsWlF+1pMDK4A0dyUWlEV0Itf+hyJ1w4eIXfV0taPX5S8BTx5K7XIpeqMUZJlSYGL3i
	ZYb5kJym56Zcy36MCmIraMnPBFwrs0H0WKScFzjiYqDC24AZs2ubPuGTrAk47PcYYI9NvD4IXg6
	WYKCcfzQdKYGAWiZOSqfoaXazNAd+/tDjtyJ0AgNTD+2TAxmJDPtoiJKDUgr7QOKfX9isZCiwga
	n8Cdw/CEwZJg/D+9jjOGZWNptZlEymUYLRwPCrgVC6D20oBl5L6rQuFC2k/efM8pGKwagj5OBqm
	9CI2AU03HxoBbsJjWyUtvlMgv/+SW6t4EeiI11ZCFXpekNI8SaH7CIkjxK0ByCWFNDUuLSURQfb
	FkMwfl7thN8ctVqhcetyktyKB2rYrVi1OfzaZlqYKwJHqkCLemOCZ5h1jFBS6ajyVDOb+yJ0gTD
	e/5jolYEOnoVdjaJiZ1aZo/Prlq0H3+fTrw7HucYB50dc2pgtzpyo4RMS1AZ+xzbUrMz0U/bwHT
	m/wuMsmqa+h6IDdhi6wlrf3E3ZhsIpEsUYcHOFD6YI0bclC+Fk+yOlSh1q1ZQ=
X-Received: by 2002:a17:90b:53d0:b0:3ac:b2e6:317d with SMTP id 98e67ed59e1d1-3b1b0a10840mr1664527a91.35.1794559886175;
        Fri, 13 Nov 2026 00:51:26 -0800 (PST)
Received: from [172.22.0.2] ([50.175.87.158])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b1aec63b9bsm3619209a91.12.2026.11.13.00.51.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Nov 2026 00:51:24 -0800 (PST)
Date: Fri, 13 Nov 2026 00:51:22 -0800
Message-ID: <cover.1794506262.git.chris@chrisdown.name>
From: Chris Down <chris@chrisdown.name>
Subject: [PATCH v3 0/6] mm/slab: Support selecting slab hardening features at boot
To: Vlastimil Babka <vbabka@kernel.org>,
    Harry Yoo <harry@kernel.org>,
    Andrew Morton <akpm@linux-foundation.org>
Cc: Hao Li <hao.li@linux.dev>,
    Christoph Lameter <cl@gentwo.org>,
    David Rientjes <rientjes@google.com>,
    Roman Gushchin <roman.gushchin@linux.dev>,
    Kees Cook <kees@kernel.org>,
    Marco Elver <elver@google.com>,
    GONG Ruiqi <gongruiqi@huaweicloud.com>,
    Jonathan Corbet <corbet@lwn.net>,
    linux-mm@kvack.org,
    linux-hardening@vger.kernel.org,
    linux-doc@vger.kernel.org,
    linux-kernel@vger.kernel.org,
    kernel-team@meta.com
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/2.4.3 (cc9e3943) (2026-10-09)
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 5DD9580002
X-Spam-Status: No, score=-12.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: 3eaydjqjku89mx87iezgr9d5ap7ujwoo
X-Rspam-User: 
X-HE-Tag: 1794559887-277206
X-HE-Meta: U2FsdGVkX1/Ik1+gGKCEL+R/YyNAT8RmJKhVPfh5d7Qb+AckstIFmCOEGS0LAArWHWODsPxeUKJVpDOzOk2z8isd8rJaNHcKgWbZZhVY9V58oxrVah6IMO6sZMNREwUtM4Z+VGvTfUPrd3NH5oz1TDdcnwfASKXDNwHdPpoS6q7e89hEAQO8rW5oXa1ng3MPuWaANOMad6L93bT6mRqYhTrBfohLwL+ARPHVyWQhPPZwEQV3mWRSIWQJ3RALGpZsRZQHjQ/Ga1mK/1v8pkz6PrL+Twmu+Mo4koMCF35ghBltDsCXbyV1LoMe8KpKxtdveCt0r2F4B97wDJwFCVYQ3y4Zs0n8Bo7i65H4g69YuZ5haTls8ZYYrPBocR+FydzzuRBiY/34E3p+T5lHL71PAoSFnjc7FfcJoYeOfeqMl/sXMmXDknsOPrUNs2KgiLAFOFI51XAzO1COK7rBv/+YVV0tS5eJIOy3cs20A/28eAn36v9n/+v4iK/wZC9PwSHi/CvAwJl0Uh6UMBBMK60YOXzMVw8pnPs3BQIK05NsHPPJY9HVf5Q9PYxk245d69H5TrY/Z7gkM76QJR97On40JPIPf3Cp1sor0OQosweANJvl5UNDXW7hj2yOnw2Ku6rpMY/eKZbGh6zmHGiken6veqyQ21h8dpKo872VOGCEFfqNFFOGzp9Igy8Xlo8VKua4JZHVyYwc4+QqVkbbnWOvTWYgYHhK9dv7+PUPEpNQk0hpU4zpUmSFDPU762GYqFX16eQF2/BxSUPLhTmy19Jyb7cofluCvrFK1CSY3jYu4NKsNBQuWx0DXWbXwNbu17FLcN272KTbZMgd+qyr+F0pHZEtVlfOXKXh2g31yT26SR7V14ivN2wRsYMkpNsdOJyGwfNogotRodJ1kGJCWS104BhEbSPI9+AIxmILDDlMFMcYOOWw8ocVORsubzhVsLtLEABwmLpq3imGk6vBX3k
 ID+qfmSG
 2tPzxnhQyxF2iDpdZ466/16lTDQOANM2518H600m9BWXM94KTfhgChuz/iMnYHKm5r7s2kVjWWsJVjMEcnmxz2UEzoUw3qhr1td7HJNnSEKS2B3iPC/oRvZz6rp9/4bkDMYtPodlfGD/jGVbDOCMPkFdgukEHOXAG6UzrwpHR2OR183VaSlTOb6vJqJsQQ5U4Y18+BiyKYT99HfbwbVoJvcJjf12XI7Lk2t9IV2Qse24X3fd+ZeEW2f0N2Sbjw/S2HW03+8rzBsv62L+hNe/SOSLPu+i2RnRtEVIH+t3R9QQARi+EwZymDWvCAxgojffsnZ5K9p6d5hR77VKQwqFc4Fg/xCTJjDQ12qTFcqAUrbyX07vzBkX8hLqrlB5rHLsthEKYGYYsjGsy2EsrnIfMLwN466gAnV+ZtMcD0Juk1xPnfbOqG/rbAMrmK/yfa0emTDPC
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Slab hardening settings are currently all build time choices. This means
that, unfortunately, hosts with different requirements end up needing
separate kernel images. At Meta, for example, some hosts are built with
these options and the rest of the fleet isn't, and that's one of the
things that keeps those kernels apart.

This series does two things:

- SLAB_FREELIST_HARDENED and SLAB_FREELIST_RANDOM are cheap enough with
  sheaves that it makes more sense to just enable them by default than
  to make them switchable. With both on, system level benchmarks didn't
  change measurably, only slowpath heavy microbenchmarks did [1].

- SLAB_BUCKETS and KMALLOC_PARTITION_CACHES cost memory (Harry measured
  about 1 MiB and 18 MiB respectively after boot on a 64 CPU VM [2]), so
  they get slab_buckets= and kmalloc_partition= boot parameters, which
  default to on when the option is built in.

Whether those two should be folded into a single slab_hardening= is
still open [3].

v3:

- Rebase onto slab/for-next.
- Always build the slab_buckets and kmalloc_partition tests and skip them
  at runtime when the option isn't built in, instead of leaving them out
  with #ifdef (Kees).
- Declare slab_buckets_enabled and kmalloc_partition_enabled in
  mm/slab.h without any #if (Kees).
- Drop the remaining #ifdefs around slab_buckets= and
  kmalloc_partition=. Both are now always registered and ignored when
  the option isn't built in (Kees).
- Keep both flags as plain __ro_after_init bools rather than static
  keys, since they're only read when caches are created and not on the
  allocation path.

v2:

- Make SLAB_FREELIST_HARDENED and SLAB_FREELIST_RANDOM default y instead
  of adding boot parameters for them (Vlastimil).
- Skip the memdup_user() part of the slab_buckets test on !MMU
  (Sashiko).
- Keep slab_buckets= and kmalloc_partition= separate for now. We can
  discuss whether to merge them into slab_hardening= or similar, as
  Harry suggested.

v2: https://lore.kernel.org/r/cover.1793253633.git.chris@chrisdown.name
v1: https://lore.kernel.org/r/cover.1793086056.git.chris@chrisdown.name

[1] https://lore.kernel.org/r/auITixAJMfLtfa7i@chrisdown.name
[2] https://lore.kernel.org/r/179312451613.474906.1475329637924619088@kernel.org
[3] https://lore.kernel.org/r/aud4gPOUzvHtLYnJ@thinkstation

Chris Down (6):
  mm/slab: Enable SLAB_FREELIST_HARDENED by default
  mm/slab: Enable SLAB_FREELIST_RANDOM by default
  mm/slab: Support disabling SLAB_BUCKETS at boot
  slub_kunit: Add a test for the slab_buckets boot parameter
  mm/slab: Support disabling KMALLOC_PARTITION_CACHES at boot
  slub_kunit: Add a test for the kmalloc_partition boot parameter

 .../admin-guide/kernel-parameters.txt         | 15 ++++
 lib/tests/slub_kunit.c                        | 85 +++++++++++++++++++
 mm/Kconfig                                    | 11 +++
 mm/slab.h                                     |  3 +
 mm/slab_common.c                              | 52 ++++++++++--
 5 files changed, 157 insertions(+), 9 deletions(-)


base-commit: ce6518e61e3b4bf4f97f7ac6204049b9eba7eb75
-- 
2.56.1



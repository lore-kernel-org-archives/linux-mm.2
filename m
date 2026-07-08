Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 04E74C43458
	for <linux-mm@archiver.kernel.org>; Wed,  8 Jul 2026 22:22:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BA5ED6B008A; Wed,  8 Jul 2026 18:22:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B56C66B008C; Wed,  8 Jul 2026 18:22:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A46D46B0092; Wed,  8 Jul 2026 18:22:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 7BD546B008A
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 18:22:22 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id C8F5F120308
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 22:22:21 +0000 (UTC)
X-FDA: 84967034082.21.316358E
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	by imf19.hostedemail.com (Postfix) with ESMTP id 1C2EA1A0003
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 22:22:19 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=Mjexf6T9;
	spf=pass (imf19.hostedemail.com: domain of 3ms1OagsKCMkprzt60tD82vv33v0t.r310x29C-11zAprz.36v@flex--ackerleytng.bounces.google.com designates 209.85.214.201 as permitted sender) smtp.mailfrom=3ms1OagsKCMkprzt60tD82vv33v0t.r310x29C-11zAprz.36v@flex--ackerleytng.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783549340;
	b=uO3jSCk2wJCtzmL+kus5IlEQ7plU8xU+xANFocsDDkleCSLA2bF4vWZI9ngGtzY+NeLzF7
	rQACaAVitKX/bDY6TkzhVteI94E5s/Y93zejiTQ7D63FRf3LG/CQ9qQFCZjFcEGbKEsX2A
	/dkToyXQuh9WcaVcAKO8QWfbrZygr04=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=Mjexf6T9;
	spf=pass (imf19.hostedemail.com: domain of 3ms1OagsKCMkprzt60tD82vv33v0t.r310x29C-11zAprz.36v@flex--ackerleytng.bounces.google.com designates 209.85.214.201 as permitted sender) smtp.mailfrom=3ms1OagsKCMkprzt60tD82vv33v0t.r310x29C-11zAprz.36v@flex--ackerleytng.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783549340;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YfstwW5fdgPHEqzlTVyIef12ZG3uZSmm4XPE4cEuyck=;
	b=IcE7KrDsyNdzr7opAF427GYcYrSja0NwZMU1j83s4PrK4ztTJilR+QolHn9zB5ELDg5/MC
	EhiTMSJfw2svsSh8/6xwCKlWpCNMowfgKCWUn4Iluft+CGpX+KsHl8da32RBhKPooNfKxI
	kBF3gje6QGbcHAkYJg/SAe1A2mxVQZM=
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-2ca5d2474c7so34053915ad.2
        for <linux-mm@kvack.org>; Wed, 08 Jul 2026 15:22:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1783549339; x=1784154139; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=YfstwW5fdgPHEqzlTVyIef12ZG3uZSmm4XPE4cEuyck=;
        b=Mjexf6T9tOuVv4OTjKNQbTCHdSpVjjvzq4+pr/mD1n0Jj8lw4kjRw/jZm4UCZk8QIf
         TFwwZamLY91BfWzaZ1M63qsFGwSaMdnY0Xtgy/ftj1q+zhS5+kFy88ms/yL4sxJAJKii
         HQLouweGeltZe7LpU9uh8LtrzhSQt4bGEk7/bWoR5rovJ/1F6M9RvDZ1WUaCAbE9bAE6
         NDyvlQlN40xbNvhMS8gZDLeajkYZjDJ9XcaqEK5xCyURs9dpmyAoLTKmTH30YqEXO/dz
         PPfOiYzBzFyGLDvDQOERsy7kRIq8jzkI/QrTT6pPS1h+dKub6bJlcxIt4pk4QNXtzlBp
         xtaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783549339; x=1784154139;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=YfstwW5fdgPHEqzlTVyIef12ZG3uZSmm4XPE4cEuyck=;
        b=jWw/CjJvv0UBY8eHMLkKx32y6+ykK62BSxXeiBw5lTgBxK+7nc/CBiOzYRwDZ290O2
         7abhN1Kkvh04IPN7GZPv3yqmXvNoZSLkpyaf9quUyCcZv/dFSPXHEECY9R1oATQRwFEp
         FerrN+2AmnI8f6V8arJFCM4klq7LOrOEJZlnGLzFghUci17eRI1yOyC9/PXFkeIVsN7h
         4uQRAi3mr/bs2lA+c7iM3CEqr0bFXjwkEOi7RVr6JnuUeOHF9p7hSSMeFwpElQNItm+U
         L/9stEaLYJzpk70IWfQbvT7PB2C/fxS0EPa3f8T1zzbjhl5cYW6yic0mtMcRmNGRQxBK
         +0YA==
X-Forwarded-Encrypted: i=1; AHgh+Rp7CsmV99sYOQ+y2KJryJVpe7mBxbyESKylgZy/iQKhvNXfqepRDp9IkOp+2Mqd1aOIc1FS9MKWjA==@kvack.org
X-Gm-Message-State: AOJu0YwQX13O9uJWeRssMEEDfbDc4mQova47s8Jr/7W1JpGbrdBJ3a5T
	nLC2MDGIsQTyznHfEUc7e5nS6Ef1gEF4LNw67ja/1+PefN/eyNSVvrGHOcXzwYDGfPqfODFm6GI
	cJrmbWSf11I1+TrtqJBNTwLTp8A==
X-Received: from plbkm4.prod.google.com ([2002:a17:903:27c4:b0:2cc:e88e:4245])
 (user=ackerleytng job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:903:2306:b0:2ca:ca48:c380 with SMTP id d9443c01a7336-2ccea3a7a6cmr42757595ad.47.1783549338708;
 Wed, 08 Jul 2026 15:22:18 -0700 (PDT)
Date: Wed,  8 Jul 2026 15:22:10 -0700
In-Reply-To: <20260708-hugetlb-alloc-failure-fixes-v2-0-c7f27cbb462b@google.com>
Mime-Version: 1.0
References: <20260708-hugetlb-alloc-failure-fixes-v2-0-c7f27cbb462b@google.com>
X-Mailer: git-send-email 2.55.0.795.g602f6c329a-goog
Message-ID: <cover.1783549129.git.ackerleytng@google.com>
Subject: [POC PATCH 0/3] Reproducers for hugetlb allocation failure issues
From: Ackerley Tng <ackerleytng@google.com>
To: devnull+ackerleytng.google.com@kernel.org
Cc: ackerleytng@google.com, akpm@linux-foundation.org, david@kernel.org, 
	erdemaktas@google.com, fvdl@google.com, joshua.hahnjy@gmail.com, 
	jthoughton@google.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	mawupeng1@huawei.com, muchun.song@linux.dev, nphamcs@gmail.com, 
	osalvador@suse.de, peterx@redhat.com, rientjes@google.com, 
	shakeel.butt@linux.dev, stable@vger.kernel.org, vannapurve@google.com
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 1C2EA1A0003
X-Stat-Signature: m7h5zhqbehyz5ysk7954ejpfoka4ihor
X-HE-Tag: 1783549339-845588
X-HE-Meta: U2FsdGVkX19xQJljs1Oe3VozrpS35StKWPF51syTCfkCMpAB7hFWvAaEsM3Njgprj4rkkHVZSa474/u2JqZQXFcmfZn7N58oP9swyYMHaT8Ofh8prhMuLhJT1A4iwEKrPBZnaKanC9MRb3QDua9z2EPLUzen5WDPTJS3TmYpMJe+ataT4v+zs/aZcza7jN6BqVHmLwHzbXuYpQnOLrv1oVpb5XqneLjRGvziE4JH1kP2nBsO7EPHkHyhq6dDL6gMZ8jBYOlkZqMGI4wORn6LiQEWcYSVZFlwKI+ezUGhuBqOVRPnV32tuyVm1bOYvZMtWHxgAcKDEq1wXNPkn8f8TtGxmW05eNZPHpDA3EZQ7r9ND7nPl4zAfBjxjeQSCM7xV2hGg/lgK80EuTyginYCgM87efDgaeB+noJk3UrfRQM+dr/jR/3RKXoua8Ym09fVbYNukbLQemyxLQ5347qFqzLKBxqo2MBmLZ45nh65K4/CtW+KDDFg5HzOzWGoSEVxteIEdKt5Ibg8kOf06MaECqOVhoVAgR9LHAKxessZGIMidCYt8jyMsZJaZyDToTykHWrYpu/NTA8owMO6O8DXCP8HJ3AA1tIf9VEqOgg8gAYyxJAuAh+NReUfCD2vGAqkFDBPIyDMvK+ux86VzNneGi5EKste92bzKJV16A9IOsh7p2TuIY4PYRBSoh6Qm60eVp5biARelmPfXISE6SlX8aUb3u1PLRGc8QEejD/mSUcJiP9SVpyeuFd1mAsymf7+5AfUAsGPxiwvjcHlXLblfzasdYusqt6+Sj6TJKO0YDUCZZci1l66i/BJEpPEBD4IkDQoDsti3Trc0hqb3O/sNpbMFmZC4aiUh2+jKCBVhUM0tZocPVEuc7EAhjTLjlS+EPFZae5vzCieALGT9zOL2n9JM3vrtKANPsgpwmQrrOjRqhc4oISctLjO5PEJeSQUjlv282LcOPxg8fapV5M
 y+olJAUh
 xe4mJIu5bolSmPHUGMvxcyWWD3xKMApWyaQAyPWChD4LkgfKbaAgFuMsVM0+7wpYiVHTF3EomOsGvY5O2XOJ7OnrzoQ09Owz3skhs+0GQZ176kTExednkyM3vv1Nd7uJit715yT4maDlgB2od0T42bjDcic55/ftbDvg/NPEK3uOLT5wiSfH84hxtK+5PcKNCObJvux+Um0ZDzXc4DEd4ss0LWhFVJgnR8+CmTAEZasm1cFXKGZphMgzH65CFLQYydETt91O30Re0VwU1UThcUILyPmkAZYGBubO/OjChaKTX+r0mlcesd4f/gojBhj0BmPIU9lHuQoBS32LYvRnFdmNOWGuuXlxiTLVYPdUrEeOxomqJc7t2h9qukJRQvMtCMPDDA/HAYXiCkWDWa2aZgnvqWZYZeMNaTNLQ6uIwjzsOZnUZw1CMBQEm76OMRz6mgTtx6/KBDGtv+Bn2pdqi3PeF+4Yw7bbuJzOhUkBpXeDSZbMTmdtjGn7Lm2EhfkrBVUc4mJRj+x+PHV1+Hx6y/MqUl2p8adnPPNeIhDVBjZkbfpVLQXDBlLfbHs1Rx5peYlNvix2/iJdONQ3Yn1yYPipgy211i8Zav9EO1INxCLq4G4CyhDTdpZ+taj6iAwLPv3IPr+OVwFo6THzacQDxGtUUS84WD9sRZVqrEZRNZoDqezMJTjn7948waiFvE9VlY7CEYDguvggab8ariYrs5cpLOqynOqz6fC95
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Please see separate patches for details!

Ackerley Tng (3):
  Reproducer for false restoration on shared HugeTLB mappings
  Reproducer for subpool usage leak
  Reproducer for allocation failure due to cgroup v2 memory limits

 cgroup_v2_allocation_failure.c | 160 +++++++++++++++++++++++++++++++++
 subpool_leak_max_size.sh       |  71 +++++++++++++++
 subpool_shared_leak.c          |  29 ++++++
 subpool_shared_leak.sh         |  86 ++++++++++++++++++
 4 files changed, 346 insertions(+)
 create mode 100644 cgroup_v2_allocation_failure.c
 create mode 100755 subpool_leak_max_size.sh
 create mode 100644 subpool_shared_leak.c
 create mode 100755 subpool_shared_leak.sh

--
2.55.0.795.g602f6c329a-goog


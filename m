Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8D478CAC5AA
	for <linux-mm@archiver.kernel.org>; Thu, 25 Sep 2025 08:20:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1020D8E000E; Thu, 25 Sep 2025 04:20:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F31998E0001; Thu, 25 Sep 2025 04:20:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E47B08E000E; Thu, 25 Sep 2025 04:20:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id D1A9A8E0001
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 04:20:06 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 951221403BF
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 08:20:06 +0000 (UTC)
X-FDA: 83927074812.16.6DDC6B1
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf10.hostedemail.com (Postfix) with ESMTP id 669D7C000E
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 08:20:04 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Abrd6Ses;
	spf=pass (imf10.hostedemail.com: domain of dhildenb@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=dhildenb@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758788404;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uQyATlrnC+wowTPbvk0SB6NXeUbtxy3oLcwFt8kaAo8=;
	b=GKFsyHjVpAvXdM3G1Db+cw4dY9FTMkEw1doA/cL79CXtGL0JTMQ8/1EtUO7I3j34+d38Vx
	pFpBAVL/sLXzreMdhkh3fMP9hQaKOTEd4i52zj6Gu03gHdLKu8raXChHsEHLeYAKEJPdP8
	1KCtAwXEujzO2glqgDBsOe2eapcgBu4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758788404; a=rsa-sha256;
	cv=none;
	b=KjQe1/siPyPnufI6VrkQQRUuCeGLPzCkObYfMMgk0nSfVNGkbVI0elb5OfKLkbPkbUZl4D
	M38Kw3jXSN4vmQ+VcsZSU1m3hYAKj79a+HJjgQbOoULJfTNYU9dslnvHUR3VqPgpfO03qu
	qhwUYQ2GGPQrd5uIWiwZkPK70TvyyME=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Abrd6Ses;
	spf=pass (imf10.hostedemail.com: domain of dhildenb@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=dhildenb@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1758788403;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=uQyATlrnC+wowTPbvk0SB6NXeUbtxy3oLcwFt8kaAo8=;
	b=Abrd6SesqHQmE/QjJSPEz418POuh2YxoqOJL0d/vUL6yOlBix1fw4wju2cI1P8hvwixTLp
	+b4hU7T82xvwYDhWo2fjuI3Jxtkns1rq7UGlbQ+7OL+0r6r+NbqUo5uQczEQBCz3Zd1aay
	QelxQVbaFNjgBpYR5cS5n7FFxx+j6QM=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-183-j-dPxmm-OMWYa_OwYYI7Cw-1; Thu, 25 Sep 2025 04:20:02 -0400
X-MC-Unique: j-dPxmm-OMWYa_OwYYI7Cw-1
X-Mimecast-MFC-AGG-ID: j-dPxmm-OMWYa_OwYYI7Cw_1758788401
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-45f2a1660fcso5747235e9.1
        for <linux-mm@kvack.org>; Thu, 25 Sep 2025 01:20:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758788401; x=1759393201;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=uQyATlrnC+wowTPbvk0SB6NXeUbtxy3oLcwFt8kaAo8=;
        b=pZLrbNgOGFxc/STbAQkT91NVqD36o7YsUJLixFjS32w+Q3ZYmiLC7JVlN3/Y31dhw1
         pkWq83Fm8ikd81FS5+Y76zsWq6OWQTHG+kvNm/+CEmGCyLXcJ5L7ssfLsG7btE73+hnA
         ODWYJEqLcqY9/r4peYeE347vZ5M77XCJm1GG6i0nPaQofuiYUEcjcrJRZ19kEm5ec5Z0
         8ACIwTSduj4iBsmLB3ZnBC8fOsA9frw3UK1SqoXqITpbyfzdFiMrlWcPvmXGemDhkvfc
         v8zxA1XhRD6fE2LiPcCqT1GmTxexy8XXkzbMOz1E3Cd0Qey7dTCQq94k6z2y6l87dCdW
         fW3w==
X-Gm-Message-State: AOJu0YyHeZS9l4DxdbtVBIxvwF3wq42C8fn6buG0IPYQq/QP3OLYf+Na
	KsKylMcdkBfEmflat4IGLthXS02XFfRTeZfAG6ddj+qyRo3eyszGiMDrSxt6o4CW0OjYEeMwwlG
	CPnccVfLS+RvN6gP1qwz5j3xTS9yKXl+0FgD63G4tZ3TojM7oALiH
X-Gm-Gg: ASbGnctoDdzSIrroKLtojev7WLUwAzXgNCe0tBcHCAZwIQgHhvj6iKe4z4jsrGKxSB5
	DH3g0SLlHqBuNleJsbVk0dV+r+pY+027QiLOXH6DrW0daTwuQ6myQMZI9duoTn6s/HpBj3VKR9x
	q4hCcI9gEfyyfn/lYu0mL/vkc4euIpwG1dmdIcnh3QjIzRh4dm+jMHvoAysNKcirnIXuJJDMAFa
	WioLnirzZYExH1eX3GrDMR4rq5PVPH0ukJi5D1sRjaet/u9fNpNJsk0EY0icxfUMw2UVFFdXx2a
	p6dRenciKaMOCL9TdK5WY16a4+N5elgYFfSwgX52yZIfCCxua/Vq9HS/w5FNX8xwP/OTdWylIGO
	eGmDV0aowrFC8Bf9Fy+qPseP0jQ==
X-Received: by 2002:a05:600c:1986:b0:45d:d8d6:7fcc with SMTP id 5b1f17b1804b1-46e32a057c2mr22542455e9.27.1758788401176;
        Thu, 25 Sep 2025 01:20:01 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFbC+TtRneWX13e58C5C/EoikI53nXNNt4+T6sl+welA2z2gykiSxedmAf1xpwS0M/6obS7Zw==
X-Received: by 2002:a05:600c:1986:b0:45d:d8d6:7fcc with SMTP id 5b1f17b1804b1-46e32a057c2mr22542205e9.27.1758788400656;
        Thu, 25 Sep 2025 01:20:00 -0700 (PDT)
Received: from localhost (p200300d82f3ff800c1015c9f3bc93d08.dip0.t-ipconnect.de. [2003:d8:2f3f:f800:c101:5c9f:3bc9:3d08])
        by smtp.gmail.com with UTF8SMTPSA id ffacd0b85a97d-40fb72fb71esm1915655f8f.1.2025.09.25.01.19.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 25 Sep 2025 01:20:00 -0700 (PDT)
From: David Hildenbrand <david@redhat.com>
To: stable@vger.kernel.org
Cc: linux-mm@kvack.org,
	David Hildenbrand <david@redhat.com>,
	Alistair Popple <apopple@nvidia.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	=?UTF-8?q?J=C3=A9r=C3=B4me=20Glisse?= <jglisse@redhat.com>,
	John Hubbard <jhubbard@nvidia.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Kefeng Wang <wangkefeng.wang@huawei.com>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	"Vishal Moola (Oracle)" <vishal.moola@gmail.com>,
	Zi Yan <ziy@nvidia.com>
Subject: [PATCH 6.6.y 2/2] mm/migrate_device: don't add folio to be freed to LRU in migrate_device_finalize()
Date: Thu, 25 Sep 2025 10:19:53 +0200
Message-ID: <20250925081953.3752830-3-david@redhat.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250925081953.3752830-1-david@redhat.com>
References: <2025022401-batting-december-cf51@gregkh>
 <20250925081953.3752830-1-david@redhat.com>
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: GGPHkzZjGkMmUbBkLDJ1kgyn3NoaIOaiJRZBiRf6jjE_1758788401
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: mwc4fjjrhwy4sx5ndphbfb7x4ia981aq
X-Rspamd-Queue-Id: 669D7C000E
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1758788404-979383
X-HE-Meta: U2FsdGVkX1+LB6Y9PjBqqdeaGTX+SlB5+Fsxyr6dp1rCILD7sathYG5iRrLLSFujwjIqB0iqjz9HELh/IjzJyemMyIjcfQFHm+StaVop8aqa1ExMufFJOyzhdy/uBYlW3sxDbrYGjWY4v1xbxDYXZv8tGkLslt9IUleh4Y+STk/iK2+b4REivOaZx5b88DQEpa4JcgtEZpKnaMrGsY4dEOgO+anwV6hvYG2zbh/+Q+d3Ut+PaSYq33Py/GCIWqqSQ7AGTWpG4SEjaB3mNitsBetB+8lNio0XPVkkorxjtpRv0u6McwZ7aTN0chRXFYthi8T2tBTszWIdzzzQkN+wYDpleZOXpakZIiugMbZtHiV6y8qTyZyEyH0JwLfFeUqexSGZXNRpJnBXIdJHfUASP4/NVxnsD6M4+v5uEDzbp7BATEcKnHjcgr6l+19vyzTxRlfiFJemAKn2q8BJpTJcYssqIQvDH7YmBLqMLMLpcnmpvubhBo6gxPj+0sPo/aRsE5e9OmdOMn+25GpaZXiFPkDAxZys3Dy9zVDekGUgMgE+nD6gu9anYMGINxlgR3zTkzsDE9gp0fToh6oV5k4B9D6f7doRzymggf8LzC00UDVNun8eP+7ceNfNwhRnCywta/E9yiB0VODa56SUh2FI4+6OnvOfcF/MFCgCN1LFAos0Vlj52NfcQRZVwHUFT+m11tddtzKjy4bv5rOdhoFBXqMxAEHnJ0eRpsx31bc33oh2WpG/Slp+JA9nTyJ1DHTIDi9raLCB1j16P1G7DNAjGgOstPAafSzD7IMNAvE7B70Oa80DhRjRikgZBWck3VTOt1kHTRjOr/Qkvk/tXGBbM1RtoBBlWc+/agWl9LuMnk4NBm4njvdgvaz2ucsDjDKplbqy2tiBynCTBtzdzQyMQEJMG6thpfMQV47OGGWE8waBg/UNVM+abdryextyjWrMIQRX2zCiH6LBAPTywEi
 9W3GeDgk
 flq2+LX4JtApZt1SRU4qDWdplH8kdMInRezmDFbqem/5zRvICpuJ7RExPlvQzuwkvQ40OCfgdZaMf6tUukFX2OwpMHyYIIuT1fvy6t1usOmXMBGOMcx+ajTl2Ga1KgB4edTyePc+3+ckvjGyY9EsjEm3lYELLR5JgOzckkvcywpaf+MU6jZywEa8u/eBSlnm4TpJhB2qsGX6ToGEiw5fSLW66pcrlKr9P8MrHmuQfi3NN/M8vhvXOplvVRMs0V8ZdwNHcmgxngieuutFpWZi6cokNoVtqEuEmlgLx0+sYlTR3CU/xjXtX9KQ5ohfHZ2W4qRwG7LF022OXe/sVVYtaSmCD8OER31NBpMVL8eRQGChicmWbh/gchd0knF7FUvYl+Hzu/3kkFJXOY+lv2QrSLpsBNGv/rf7gnLwQOshKvVJ7pAUZjCgc4dlAF4/AwkDZmn80bqc5SIRzBi9uLA85KuAZ5I81m9bzF6hkSvoKOzFerhr66VqpzfN+MxIJntKzAO1n3y3ns7Z6E8c39pyDyn6ABxzry5B9aoQQXkhVC5RcjRv6NFd/xMm569mYM5vDro9P7NGVwAgyBf12wZB8LDcsa9ldWeYhrL+/gz6bL1wJsXa7fxiv0V9twXnZfw84PqsO92C/UecPYIagNlBzz8DMpE77yUyLOmBxIT/aTh+XsqldXts3NSGJWiYDiuToFscNY3p2xKnU9MXA4U9k+z2Vs3uhsca4V/xbxGBy2INk4YD0eGcxuQwL3KdzjTe0fhFc
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

If migration succeeded, we called
folio_migrate_flags()->mem_cgroup_migrate() to migrate the memcg from the
old to the new folio.  This will set memcg_data of the old folio to 0.

Similarly, if migration failed, memcg_data of the dst folio is left unset.

If we call folio_putback_lru() on such folios (memcg_data == 0), we will
add the folio to be freed to the LRU, making memcg code unhappy.  Running
the hmm selftests:

  # ./hmm-tests
  ...
  #  RUN           hmm.hmm_device_private.migrate ...
  [  102.078007][T14893] page: refcount:1 mapcount:0 mapping:0000000000000000 index:0x7ff27d200 pfn:0x13cc00
  [  102.079974][T14893] anon flags: 0x17ff00000020018(uptodate|dirty|swapbacked|node=0|zone=2|lastcpupid=0x7ff)
  [  102.082037][T14893] raw: 017ff00000020018 dead000000000100 dead000000000122 ffff8881353896c9
  [  102.083687][T14893] raw: 00000007ff27d200 0000000000000000 00000001ffffffff 0000000000000000
  [  102.085331][T14893] page dumped because: VM_WARN_ON_ONCE_FOLIO(!memcg && !mem_cgroup_disabled())
  [  102.087230][T14893] ------------[ cut here ]------------
  [  102.088279][T14893] WARNING: CPU: 0 PID: 14893 at ./include/linux/memcontrol.h:726 folio_lruvec_lock_irqsave+0x10e/0x170
  [  102.090478][T14893] Modules linked in:
  [  102.091244][T14893] CPU: 0 UID: 0 PID: 14893 Comm: hmm-tests Not tainted 6.13.0-09623-g6c216bc522fd #151
  [  102.093089][T14893] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-2.fc40 04/01/2014
  [  102.094848][T14893] RIP: 0010:folio_lruvec_lock_irqsave+0x10e/0x170
  [  102.096104][T14893] Code: ...
  [  102.099908][T14893] RSP: 0018:ffffc900236c37b0 EFLAGS: 00010293
  [  102.101152][T14893] RAX: 0000000000000000 RBX: ffffea0004f30000 RCX: ffffffff8183f426
  [  102.102684][T14893] RDX: ffff8881063cb880 RSI: ffffffff81b8117f RDI: ffff8881063cb880
  [  102.104227][T14893] RBP: 0000000000000000 R08: 0000000000000005 R09: 0000000000000000
  [  102.105757][T14893] R10: 0000000000000001 R11: 0000000000000002 R12: ffffc900236c37d8
  [  102.107296][T14893] R13: ffff888277a2bcb0 R14: 000000000000001f R15: 0000000000000000
  [  102.108830][T14893] FS:  00007ff27dbdd740(0000) GS:ffff888277a00000(0000) knlGS:0000000000000000
  [  102.110643][T14893] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
  [  102.111924][T14893] CR2: 00007ff27d400000 CR3: 000000010866e000 CR4: 0000000000750ef0
  [  102.113478][T14893] PKRU: 55555554
  [  102.114172][T14893] Call Trace:
  [  102.114805][T14893]  <TASK>
  [  102.115397][T14893]  ? folio_lruvec_lock_irqsave+0x10e/0x170
  [  102.116547][T14893]  ? __warn.cold+0x110/0x210
  [  102.117461][T14893]  ? folio_lruvec_lock_irqsave+0x10e/0x170
  [  102.118667][T14893]  ? report_bug+0x1b9/0x320
  [  102.119571][T14893]  ? handle_bug+0x54/0x90
  [  102.120494][T14893]  ? exc_invalid_op+0x17/0x50
  [  102.121433][T14893]  ? asm_exc_invalid_op+0x1a/0x20
  [  102.122435][T14893]  ? __wake_up_klogd.part.0+0x76/0xd0
  [  102.123506][T14893]  ? dump_page+0x4f/0x60
  [  102.124352][T14893]  ? folio_lruvec_lock_irqsave+0x10e/0x170
  [  102.125500][T14893]  folio_batch_move_lru+0xd4/0x200
  [  102.126577][T14893]  ? __pfx_lru_add+0x10/0x10
  [  102.127505][T14893]  __folio_batch_add_and_move+0x391/0x720
  [  102.128633][T14893]  ? __pfx_lru_add+0x10/0x10
  [  102.129550][T14893]  folio_putback_lru+0x16/0x80
  [  102.130564][T14893]  migrate_device_finalize+0x9b/0x530
  [  102.131640][T14893]  dmirror_migrate_to_device.constprop.0+0x7c5/0xad0
  [  102.133047][T14893]  dmirror_fops_unlocked_ioctl+0x89b/0xc80

Likely, nothing else goes wrong: putting the last folio reference will
remove the folio from the LRU again.  So besides memcg complaining, adding
the folio to be freed to the LRU is just an unnecessary step.

The new flow resembles what we have in migrate_folio_move(): add the dst
to the lru, remove migration ptes, unlock and unref dst.

Link: https://lkml.kernel.org/r/20250210161317.717936-1-david@redhat.com
Fixes: 8763cb45ab96 ("mm/migrate: new memory migration helper for use with device memory")
Signed-off-by: David Hildenbrand <david@redhat.com>
Cc: Jérôme Glisse <jglisse@redhat.com>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
(cherry picked from commit 41cddf83d8b00f29fd105e7a0777366edc69a5cf)
Signed-off-by: David Hildenbrand <david@redhat.com>
---
 mm/migrate_device.c | 13 ++++---------
 1 file changed, 4 insertions(+), 9 deletions(-)

diff --git a/mm/migrate_device.c b/mm/migrate_device.c
index 06a52612b2c45..f209dc512d821 100644
--- a/mm/migrate_device.c
+++ b/mm/migrate_device.c
@@ -839,20 +839,15 @@ void migrate_device_finalize(unsigned long *src_pfns,
 			dst = src;
 		}
 
+		if (!folio_is_zone_device(dst))
+			folio_add_lru(dst);
 		remove_migration_ptes(src, dst, false);
 		folio_unlock(src);
-
-		if (folio_is_zone_device(src))
-			folio_put(src);
-		else
-			folio_putback_lru(src);
+		folio_put(src);
 
 		if (dst != src) {
 			folio_unlock(dst);
-			if (folio_is_zone_device(dst))
-				folio_put(dst);
-			else
-				folio_putback_lru(dst);
+			folio_put(dst);
 		}
 	}
 }
-- 
2.51.0



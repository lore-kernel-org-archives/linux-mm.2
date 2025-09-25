Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CBE30CAC5A5
	for <linux-mm@archiver.kernel.org>; Thu, 25 Sep 2025 08:47:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 275F88E0019; Thu, 25 Sep 2025 04:47:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2265C8E0001; Thu, 25 Sep 2025 04:47:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1169C8E0019; Thu, 25 Sep 2025 04:47:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id F0BD68E0001
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 04:47:28 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 84F4E13AC56
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 08:47:28 +0000 (UTC)
X-FDA: 83927143776.06.32271E3
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf16.hostedemail.com (Postfix) with ESMTP id 50E6A180007
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 08:47:26 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=ZI3y6IoC;
	spf=pass (imf16.hostedemail.com: domain of dhildenb@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=dhildenb@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758790046;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ytvh9Mi9NZnOjZ13mHmZtjEG3efGey6pvhUPQwUWTZg=;
	b=jYH/MwsrHpC/IMMq6TWIhVkPF8V/X5vCTy+yjK2A6bQmozeQzJNexPteaMZSz9QDwNBwbW
	Gm6pgQwjUPyY6a1p98z99y3Cv5zOZZAxY/mCQbdkcWW/JWQbYEDxPjV1Xbl5HFs2yp5wsr
	x5IgkC13yQNrHGzHmuJFzQ/qWZh7d/Q=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=ZI3y6IoC;
	spf=pass (imf16.hostedemail.com: domain of dhildenb@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=dhildenb@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758790046; a=rsa-sha256;
	cv=none;
	b=D3qSxQ4R1yygydf3kVKT+UhgudO0Jfj6LFc5Wnpw2KBk5xINSuA/s3wq8lhoRyvBPGii2I
	DzCfbn5oherTesFpiV+sH/nPmrIkPsW79CJYlM5yDALV5Oe8yX1XzdnGSZIWizEYXi/4Ey
	7lhWOUpeK0kvIFlLr9OXZnnnwQuOWFw=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1758790045;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ytvh9Mi9NZnOjZ13mHmZtjEG3efGey6pvhUPQwUWTZg=;
	b=ZI3y6IoCcviIgvr66MUAJ075jqsxgRFU6icbommX+MDgMeDtbR/Kda6wzPi/RNm28IKjIW
	d9k98jgD42gCGp2oS3EFCxpXSK+/z/Ngg8K+DyuCwreH9/x1e3pc0oIFgSkYpB8wamuwcl
	qw2kcuCOVfAqVIPs4GBoHPR4rX5YvoM=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-657-kJHwzkBeMeOX_1-xgJnU1g-1; Thu, 25 Sep 2025 04:47:24 -0400
X-MC-Unique: kJHwzkBeMeOX_1-xgJnU1g-1
X-Mimecast-MFC-AGG-ID: kJHwzkBeMeOX_1-xgJnU1g_1758790043
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-46e35baddc1so3126775e9.2
        for <linux-mm@kvack.org>; Thu, 25 Sep 2025 01:47:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758790043; x=1759394843;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ytvh9Mi9NZnOjZ13mHmZtjEG3efGey6pvhUPQwUWTZg=;
        b=HZ1a4E+A7PEZojH6xpwPvYuSUg5/8cTyPQnyHyhr9X3MqFKuzZ27DuA7H/DejK/I45
         WGJhcCSz+CDkiFoHchpj641NwHbEY5nOIw7speXOfyUpbRSSaN+LqcDw3IvmfioAJ+Vo
         HL6s+IT72bXTvF9A4OuwX+KZNroDDK64ndAlebcUxwck58RhvgiDVA2HJgTVcJY9gLd4
         +yJHINTmM1xeh58f0bmIE+iC318yj89O3gDKb3TMAcecu+G12Ls+g2gKiBJ4BQFtZCw1
         VMe4TwD7KavW8z8PElT4h/PaCO1Ns2XWRArOPHtttGQ81zDsgcBJse4WiR8UbisvfEnZ
         FYjQ==
X-Gm-Message-State: AOJu0Yww30dNDag797CMG4L8/OkYHMq7K6dwO2FXwyu44O9QsAQHi6mD
	U+TgMcAq/xh6Za7DWgpfJlgH/+GOME4afO89s5rp/8V6Jct7LMZiYBYJQ1xnUHQjubKJ5lCvLEs
	rvc4cQxkjE3cSihH88fKnesx93PhY8GtIco+ZgTMUpJut8ZsJ31ii
X-Gm-Gg: ASbGncuMZvqM3qha1ElXscpm3oSYLVzn4c05XvWuBCJ24uxcdpyAh+bXa0pX6gfRiyP
	04FUezGYRe0Zhw8tyDQxk64J2uJ9RSQFT+bBFiPBcb9uyXo/o8/6hVlGDnsXaHN8w405HiWqhtD
	u/GWDnqTBG+M748ZVEAQmtQzVqijo6V2nGTrrLbwoOesaCpEXM3ji1axR/NkkoDEOi4AwqPx/QA
	KtaPQSf+0MYb2XZBfiZKIva7N/w1H7+JJ62VC3njQzNMEQTeKwWCFLivp38zMoBgb7sOkuKSsFI
	302eVhD3n3VCG5D6ZnhqlU2YXzpKY3uDZIHn6QoR/rH0wLfUcXzRzylSap21YWiKo4F+WrRUbd/
	GJY0QUBAKVlZp4ciKDJAjE3jqIQ==
X-Received: by 2002:a7b:c8c8:0:b0:46e:1c97:e214 with SMTP id 5b1f17b1804b1-46e329eb0c2mr16790045e9.19.1758790042994;
        Thu, 25 Sep 2025 01:47:22 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGX0jfIZio1fHF95MfkT0t5zEbNwO85FYXIBLSG1GXZo4PT5vwAlnnGWbTCna5dU4DPME14aA==
X-Received: by 2002:a7b:c8c8:0:b0:46e:1c97:e214 with SMTP id 5b1f17b1804b1-46e329eb0c2mr16789835e9.19.1758790042478;
        Thu, 25 Sep 2025 01:47:22 -0700 (PDT)
Received: from localhost (p200300d82f3ff800c1015c9f3bc93d08.dip0.t-ipconnect.de. [2003:d8:2f3f:f800:c101:5c9f:3bc9:3d08])
        by smtp.gmail.com with UTF8SMTPSA id 5b1f17b1804b1-46e2ab6a514sm66598965e9.22.2025.09.25.01.47.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 25 Sep 2025 01:47:21 -0700 (PDT)
From: David Hildenbrand <david@redhat.com>
To: stable@vger.kernel.org
Cc: linux-mm@kvack.org,
	David Hildenbrand <david@redhat.com>,
	=?UTF-8?q?J=C3=A9r=C3=B4me=20Glisse?= <jglisse@redhat.com>,
	John Hubbard <jhubbard@nvidia.com>,
	Alistair Popple <apopple@nvidia.com>
Subject: [PATCH 5.10.y] mm/migrate_device: don't add folio to be freed to LRU in migrate_device_finalize()
Date: Thu, 25 Sep 2025 10:47:21 +0200
Message-ID: <20250925084721.3856196-1-david@redhat.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <2025022405-surpass-stipend-ca02@gregkh>
References: <2025022405-surpass-stipend-ca02@gregkh>
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: TeAzlXXzXsP9cLr10SKTciJ_jWHNK5oockDxI4j_kJ8_1758790043
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: jpcnf6t5w6i3akmz9n3zncuyofmjebrg
X-Rspam-User: 
X-Rspamd-Queue-Id: 50E6A180007
X-Rspamd-Server: rspam04
X-HE-Tag: 1758790046-283097
X-HE-Meta: U2FsdGVkX1+sK2kz0sob7flm50brCgVEMGlmIJsBzETvBK34GdheJVUjyd0cQYyz7NFSJLQ5id+6lbr11gNh1K52cKxKDRoipzW5nLTUQKDrk0rg+Aa25g10h2MNNnAuoJ5i4PQWaHzt7BA0CYH4ZMhwqUdzKjpxkNKkkQHkas7njE2L1bf1usUUK0zAEpuhlEoxAco38LaCOjHNqj2VeeKsXJ9Y9nrEFMXpcNSXHSlozLzFdpFI3Nek45PNdeM90ppx9HascrnKUcVPrpTMFoBbvcGxQp6p5iNwBVf30O4ovgZB2zNuHhasGEWIJiOSul7lGvDw1H1X1RXqWMfMtuzAk+pOQXSaml/X/2BQzn0qZLAz8P7fvfgMKC+HOo5KRDp70Te+zJMqI7fGbUc4aplc1FelN5aPeIgQx/7iF6wSrsuVtRTESxPA4zSSfHwrKwk9AqWxFqYGwoQcfXAcGDkYVhqnHgwFZAgldGSk5NhCbkWkntAfXvpM+jgcNXmfF6KfDq4hwT8vWmrqzzZa91bdDSxWBFmuR00XVOMAWQor18PwgbRjBvewra1HUpp3Ss18cARSsy29yxZ3rMMKJITDOnlU+3aNEywI+ycmqQqljd6k8ih41FW00gkFDvD8Ffo87q2ppalUViE4PTsG6sVRd8pzhqTNHbICNSdIWNXtLGfMUY2l5i5lbh0f4hRblre+7ftlv7A7oSepZZD2HyXv2eCxoNOEqz5zHVO4IS/s/IbjJ9sebvJGlC/vdY1CFphNWmKc7I8Y7EDdDzTzpwTYaTEL5MK7zx+Rz9BjpWq4lZp776t+l931EqoeSQ/O/sBRbnbnKB9NQv1pU3vueom7rHHZwrlGv3hFsQvLSY5DIXAHsRectA3fTADkAmetiRS46gZCOuKEgdtyoUadxSZEbgvzxRRcQKigjp8SJYxpdd5QkBFR3+6eLe16pcAddUJKF7gZjIqj4lzgif3
 UHqEMu8I
 PA6xvtAx/a4o9UiJoZ2NQLhnFte6MPWkiaMhxFZD14Q5gjl50C6bFLZZzoeB3TKsymRovbp9EHgKqr5ZSqO448zYzqxVa24pGg5NzHDqit/ClZ6DT93TLRO9vVSTjsQMtfYOCa+3HZFhZiLTyZMBlFbuhkVeks28tbTBMUEDjKZA8QuEpPfU2i+96mjl1hkWHE+onKnTM24vWwv93S5hj3D3pRMv1ueu54hHVAkz13lG2KBgc79Nv14PYkbHQPC9RparcpEyYVBPsj0sbalLiDBsEvFXd/GfFzlJNG/46hVF39AX85HA3fAaw+3qisOscACRbX6Wu9fCF/OSh1N2biaD1x3syEgRh2VnbI1/3b1yXB9mPsQWZbyu9cq5EWCY2722lqyFdDjD1RZSmDa6SdlrjbTtpx+x38I6ahI5SYbnW2gEecLD2hffc9uehiPfZWK75x6eVGVY2f/9pSN9Qe6BpWc1KmBTkkWfpSgXpXMsAvb7/uk8RqMAJ4fpmIguRXWGDhGiAUntDeXqg6s/MRUQUpNeuOW/sNJ2MXP2vnFGiIiKDaVv54D4L7s01a4kR0bBFPrPtGn7RNsWa5Gr8DDNQwb29P0cyFazf3tzdqvL6KspRraDFVCrCBxwmIRnXlNjxJ8eFteegbRwVt5GHUlpEByOXR14OgfKm6UF+CCcFwKIWF4wCyAwK63B+2cRTbMGfKW59BjO4oYjbZvoqB4txK0mY4KJkVPUsIsVCqbRGIIdHOISjJplPk7pr8tfk3ZnL9g//LyWyhU1IjO8t5X3wz0e9o0zMQFWUOtWp3PRHtft+uyjpXU6P2w==
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
--

Code was moved in the meantime and converted to folios. But the code
flow is essentially unchanged.

Signed-off-by: David Hildenbrand <david@redhat.com>
---
 mm/migrate.c | 12 ++++--------
 1 file changed, 4 insertions(+), 8 deletions(-)

diff --git a/mm/migrate.c b/mm/migrate.c
index c0a8f3c9e256c..aafad2112ec82 100644
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -3105,20 +3105,16 @@ void migrate_vma_finalize(struct migrate_vma *migrate)
 			newpage = page;
 		}
 
+		if (!is_zone_device_page(newpage))
+			lru_cache_add(newpage);
 		remove_migration_ptes(page, newpage, false);
 		unlock_page(page);
 
-		if (is_zone_device_page(page))
-			put_page(page);
-		else
-			putback_lru_page(page);
+		put_page(page);
 
 		if (newpage != page) {
 			unlock_page(newpage);
-			if (is_zone_device_page(newpage))
-				put_page(newpage);
-			else
-				putback_lru_page(newpage);
+			put_page(newpage);
 		}
 	}
 }
-- 
2.51.0



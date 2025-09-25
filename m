Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6DF0CCAC5AA
	for <linux-mm@archiver.kernel.org>; Thu, 25 Sep 2025 08:49:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CB31D8E0014; Thu, 25 Sep 2025 04:49:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C63C28E0001; Thu, 25 Sep 2025 04:49:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BA05D8E0014; Thu, 25 Sep 2025 04:49:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A95478E0001
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 04:49:29 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 609FD1DF6A2
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 08:49:29 +0000 (UTC)
X-FDA: 83927148858.07.ACDBDEF
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf06.hostedemail.com (Postfix) with ESMTP id 45B5E180008
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 08:49:27 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=bp+no4+X;
	spf=pass (imf06.hostedemail.com: domain of dhildenb@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=dhildenb@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758790167;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=96Myumouvefz+w6/wGcSm/myLCLF8eCGCwHV82PZpT0=;
	b=PloU2ZKc8gkfdV60VXud8q23P/XezbBZSQMN1NeUldfP9fo21omq5I3IvupUya8y7je5tt
	nTuKEuUcWoVtwxKWBvyPOGV9ONkPGlZKIv6R/7GK6isyB84ypc40bwTSNuezNj9/M7cclG
	H6skmNrJTL29PhKgA/bYuu1zv6mL6Do=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=bp+no4+X;
	spf=pass (imf06.hostedemail.com: domain of dhildenb@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=dhildenb@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758790167; a=rsa-sha256;
	cv=none;
	b=o4YMgVcS+PdxguAyDFZ2/9zExr0NFpoHwr5nqfVAbNSzUGrGYFhjPrBaDarubMVNxh9LsV
	W6jUWzvekc+l60rpf94wav+M3ZIT+lXIjkJRg6gRGNKbfhDz48C5wdp/0+WgaTopnZYVH0
	XdeMJIGZIYT1/hncGHt6LtIeMTL4x8A=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1758790166;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=96Myumouvefz+w6/wGcSm/myLCLF8eCGCwHV82PZpT0=;
	b=bp+no4+Xp0oQsVD5wq3re0fOWRmK8zWrBywmMLVAG7VA0Z6eUBLVFG8W+w6c3BA3M7dlDc
	OxUEDpn2qzk9oQwoWXft25AQmWz60uaD9Gl7ZIAnsUQL3VY6GY8tI26TEDemDfH3udwxbl
	EAPS/bJrt/Ld7MfPWup+F6jcH6cGwFk=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-33-0VBJl3fJOkOCOZBKzaSA6Q-1; Thu, 25 Sep 2025 04:49:24 -0400
X-MC-Unique: 0VBJl3fJOkOCOZBKzaSA6Q-1
X-Mimecast-MFC-AGG-ID: 0VBJl3fJOkOCOZBKzaSA6Q_1758790163
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-3ee1365964cso651852f8f.2
        for <linux-mm@kvack.org>; Thu, 25 Sep 2025 01:49:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758790163; x=1759394963;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=96Myumouvefz+w6/wGcSm/myLCLF8eCGCwHV82PZpT0=;
        b=IOjCmDOKgdHHzzmzh+Wk14rtWyNUQ/d9UVCeoCTENf090QzkbItmQ81mKyM5mgVcq9
         3Hs5eJ6LO9edo4YFhjr/ChT/pu7A4COeHLOymXyluq+OLm0OEooSWeqqqw9I6Dcl+OWn
         AW8GpJaGBIqYp9P5eFjHhKvL41InZEKEQrMhHwiSecQ+6TyZ3X77IB+D2MeDX8tzvPpq
         ltdqTcAMEuBqWA4k5dH3LwDCFrPE7f+2DvZDdR9gfwdytvk+4W+wCTy65xs8hh5Ux/27
         Aut5uKKw34/ce27QPtR+LX/7XlesakcbQv8VOVZIq4MbkHjyt7HbW7xIUtdwXx5gO66s
         hmRw==
X-Gm-Message-State: AOJu0YzpWX2KYAWWBxKFuOhkNQRR7mgmkd8tHmMEiscMZCiESYbVJn0/
	fo/Oq45AOQxWaZaFurwcmwZyrsbssvsGqJhNdNPrssiyYJk0OYi/ihAgeykY0AiFqsVQnc5QEsg
	n718b0NYTSeM8BJOzFWwFP/0XIKhj1z0muauba6MA4uPSD9F4SieR
X-Gm-Gg: ASbGncvVNYIqSsd2aXXKE72O5LexlNjtC00fReFJUGdGfMpzPyowqiig/IN6ucPIDcP
	LNaROGR5ACmH3fGhhOs4BFDimCbTgrryVkx+AFUSsudv/rpiipB/hI2uoJhF9VRh95kSSqsSUgH
	G1iKdPjU77YEfVGpqQL9/iGXNgZhDCxScCmnQdMBNUwYmhw92r2C02Kjw4UEVGa1xsluV3jZnMS
	mPYUpiwHr/SAE4SrxrP13ldxKvfBA375GRvQXRbgVczS5ONiyawz0TwaRmDhWt0EYj5c1l/XNz1
	wPgmgip/VXqIxpvxAWTy54NeZMjp0TsyyH+3dH8sG36r//Z69/Gcwg5qj/tf9VzKCBXOsY1azHO
	1OQvPCXTzE/Uix3X/0qpKjWdTmw==
X-Received: by 2002:a05:6000:2089:b0:3eb:5245:7c1f with SMTP id ffacd0b85a97d-40e429c9c58mr2551050f8f.2.1758790163228;
        Thu, 25 Sep 2025 01:49:23 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFJXawuNWztXmHYJ9iUK4IjlVZc14jQcaTzlL8IJ56OZf0xhqA/uTbjXN2rk1CkLSG9voVrYQ==
X-Received: by 2002:a05:6000:2089:b0:3eb:5245:7c1f with SMTP id ffacd0b85a97d-40e429c9c58mr2551020f8f.2.1758790162754;
        Thu, 25 Sep 2025 01:49:22 -0700 (PDT)
Received: from localhost (p200300d82f3ff800c1015c9f3bc93d08.dip0.t-ipconnect.de. [2003:d8:2f3f:f800:c101:5c9f:3bc9:3d08])
        by smtp.gmail.com with UTF8SMTPSA id ffacd0b85a97d-410f2007372sm1181613f8f.16.2025.09.25.01.49.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 25 Sep 2025 01:49:22 -0700 (PDT)
From: David Hildenbrand <david@redhat.com>
To: stable@vger.kernel.org
Cc: linux-mm@kvack.org,
	David Hildenbrand <david@redhat.com>,
	=?UTF-8?q?J=C3=A9r=C3=B4me=20Glisse?= <jglisse@redhat.com>,
	John Hubbard <jhubbard@nvidia.com>,
	Alistair Popple <apopple@nvidia.com>
Subject: [PATCH 5.4.y] mm/migrate_device: don't add folio to be freed to LRU in migrate_device_finalize()
Date: Thu, 25 Sep 2025 10:49:21 +0200
Message-ID: <20250925084921.3874940-1-david@redhat.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <2025022407-amplifier-catnip-6e14@gregkh>
References: <2025022407-amplifier-catnip-6e14@gregkh>
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: Ay5IfzzVxWt8JFGGZsv0MgFQn2IgaWMeqLlPhS8uJec_1758790163
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 45B5E180008
X-Stat-Signature: 7xk4w8rroro5agxwt5jddf8xnqt6k3f8
X-HE-Tag: 1758790167-595152
X-HE-Meta: U2FsdGVkX19fgA6s6AzfvnBamImnC45N074t7hNHteeEHB0WZUFd7I4t/oO7OwvKM1e00g4Gn/j77CeKx6PZqIOznFxqrlU6vXexfUOAQ7ocuIrJdK5BPxflYJXY5qsfNX/xzpPNhWbUs1mCl8l9prch1GlEmUn2undXpFgsanKfw7Xy/vPLeBmi+6l7xBZQB2y4LjbY3JjyUYaFS9ZXy8Zrmb8OMsJKIqpFpXlbtKLCGLJXz8CqhQwpPDcOEhyJtTDlEsqLRUcZXNgvAn2UXdguWjz/8FjPJ9JqRHOpuohQmBdgfioSl0u+tvknm8aIrMGHojTEXMCfhO9bqOpybzZoLqaOwqlvn5Go4zQMGK5ZpTmtgrfWJAUETRWLtG1gi3VXBrZyDcLDb3wl/z8hdU79haev5ZJz1QnhwvtHZ6CSUO1vtavSuQkbK26AGRPnwrNkcQ1phtzD1OHjlLWaf8iXPqjHKneF2jmYn/Mg54vG82TCz5Y5Athxd0m7oram6/G6kqbGNPiFAPW/HCt3Mvb0RCUcgYJ3yXlra2PD/295UnVaJFohrLSlTvz9eXSCj3VwjMq2ZLokB06FHkbGQ6vTb0vEgeKmpnyvUBPUXYs30PDTqFDHzRtO6LRsQkTVA/Igy8d8Mib4SMr06Wv3ni88tR+Sz9V2LqYpYvaZ9VIdQIg8idftnyz2ux5SJNVQDNREGcrQA7Y1LF20IB43jqdCFOB8KHkl2wA6LOSgXMoCsA/0rfMeZjNrdczWLJSGbeyLbve5VZoq8Kwht2OmMiciFB57MLXDKcg2knx5urKHhMIRVnFHL6ih1WLB0tR5M2h/bOzu8c8nPH7N50C1tMQIK3//Iun1aJAcITR9FuvCsjy3gQGh0LRoVr5Fwk/hcZDOEqYLVAxjpfZV1lFXxLv/qjntkW1O/rjqBug9M3fjtsLvRW90882mumSK8slKei3VDZEM6AiFVwp3qx+
 abqI1OBl
 WUa6y3stM2u5DIh05TRL+SanCvakWGEW/KeK4IZ/FgeNJ3+a7Kp6EHdVImmF4eSOvaxCXB0jfl3byCZy8gA6cc5D4gPfwG+syVEvMIdSFwfnZ3vmGqLsGdCJqmB5c8jQKXoUCa4PcErf1qJ4AbZPqd+AzZ3GUQIH/ejAUIbghtw3+rcV54hpivcdHdg==
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
index 9cfd53eaeb4e9..aef7978cc56b2 100644
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -2967,21 +2967,17 @@ void migrate_vma_finalize(struct migrate_vma *migrate)
 			newpage = page;
 		}
 
+		if (!is_zone_device_page(newpage))
+			lru_cache_add(newpage);
 		remove_migration_ptes(page, newpage, false);
 		unlock_page(page);
 		migrate->cpages--;
 
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



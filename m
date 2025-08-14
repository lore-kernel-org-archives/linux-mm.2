Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 62F64CA0EE3
	for <linux-mm@archiver.kernel.org>; Thu, 14 Aug 2025 07:22:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 04BA19000FE; Thu, 14 Aug 2025 03:22:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 021B5900088; Thu, 14 Aug 2025 03:22:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E79D19000FE; Thu, 14 Aug 2025 03:22:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D6460900088
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 03:22:12 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 867B31DD981
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 07:22:12 +0000 (UTC)
X-FDA: 83774519304.29.5894148
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf02.hostedemail.com (Postfix) with ESMTP id 6B74C80008
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 07:22:10 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=CF6xMi0d;
	spf=pass (imf02.hostedemail.com: domain of mpenttil@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mpenttil@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755156130;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=HO8ahXGAV9+oYKhXXFg6Hd9BCMtW4wga0zmW/d806gI=;
	b=ed2H0yUi2f8S02pBwfANbVG0zJZD2BFJJEJr24HCMDq0eRAmUjVw9FA787WgqJyQEElxnK
	ZdErGp2QCD+McfQodwdMJS/O8bmpap7ucqEfmG3l0yzvuXlhrSB58uqDbMhMggc+7payXi
	E2vVlAtwRqS+9r9tMMPzvISit0NG3Pg=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=CF6xMi0d;
	spf=pass (imf02.hostedemail.com: domain of mpenttil@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mpenttil@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755156130; a=rsa-sha256;
	cv=none;
	b=NgTO0RIe2vt1eWRyIX2aRGflyMNWCqTtdfgZhayO1Hhyxep9SjzgpWKss58hFFyXCx3KA5
	ppYZ0RZ2MQdPkKwRsMMILS8RLsB/IM2tHxhOgXm9KKmtggkNOlBlmLP44jgtTJNtJUOnTe
	ZcQhaewCfPQJTQ71NhsjhgnT3Fm8CWM=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1755156129;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=HO8ahXGAV9+oYKhXXFg6Hd9BCMtW4wga0zmW/d806gI=;
	b=CF6xMi0dq4A3ekvhe0r4hZqta3gatxhbuWi91BDWUzp8M4viRAB7aQ/QioTGHyPrg/NrgK
	Kn+alV8CWGr9/KrHgVpRik6pI3Bnt1K+YBYxqoA6+66MM41h6o0fzlFJ7e4EmbAYlF9o7u
	jhE/lWQo2B+zbvMpn4ZZxtdN2FcvtX4=
Received: from mail-lf1-f69.google.com (mail-lf1-f69.google.com
 [209.85.167.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-670-Om9D5fIqMpmBchxZp12G2A-1; Thu, 14 Aug 2025 03:22:08 -0400
X-MC-Unique: Om9D5fIqMpmBchxZp12G2A-1
X-Mimecast-MFC-AGG-ID: Om9D5fIqMpmBchxZp12G2A_1755156127
Received: by mail-lf1-f69.google.com with SMTP id 2adb3069b0e04-55ce52539daso299587e87.2
        for <linux-mm@kvack.org>; Thu, 14 Aug 2025 00:22:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755156126; x=1755760926;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=HO8ahXGAV9+oYKhXXFg6Hd9BCMtW4wga0zmW/d806gI=;
        b=XKnLeLLH8uEXWsxqOQwCPpncazNObeIzZZOdPaFvNVWzmN+LwvYI8LJy05mkpIsHYK
         2MSRdArlpZK+EyKLjji5wdUAwkijEyNfwtKNUKhQDt4Ogc3jAjBJRULzplQOFTws8ClP
         48Zf9a3PeEZt2QtAcO5T2g4qKxoKvHXE9Y2qNtuAD/RuhlA0ZLKTGSNG9Lp8RXF3G2re
         xtcGEv8xQlCUy+3oxEj0wHqtfdZ15AQpzptIrZgYaVWyBroNI0iTOClpDEd5sehJQiV6
         EN28dKL9NSaMsEvSvcZbwoIcWuUqC5imd+TddVJIwDG36b40wFMG/bvpoUG92XH6qegv
         geCQ==
X-Gm-Message-State: AOJu0YwH5FnAn10IEw3MqeV1pQCpV7+RMOHARN9UbpOnQwJ5km4Voncp
	z0lrOhfLmXsLfn0vAi0/4jny6oeN4Q7YrLUjdYi7DkYbDijHgzYDHEbgjYk/7wrb99Q282kTt97
	/jIk92j9H9EcplceBXfRHcN05yB7Lv9txWo3CWa1mIHKlSnq9Liv9a5goG0OxoisG4LcxmKeJys
	pzlf7pglbblHzcSSprSWBOqtuv/l9/ARSXGU4=
X-Gm-Gg: ASbGncvWgnd9zPafkgN39my0qQOniAZ2kih5s6F6J6ZKQugOJ4xs2kHTJXh9hrzv4jc
	vYCmSM7CXkLDc82NG3A5C7dz4l3jx+YHS6KeiZswY5TmNRgmOqQOdwuhFMA4otafSjO5WPIJ4JP
	qU4JYwYLP7DVHWqny3jf11ZWctafI8BzM4MiElOZmKmolV9qFmJRxDkAtviJNhhO+ZcjiqX7LYS
	M1QB4dhRDDRpQ9ugLBv89Au63fzembUJUsPUOVA7vijBL6STmHRXMLh3rITuICMDJ0J0XStT/85
	Ww+j/CKXKijNK3INKUURT2r6WNaKYI0Hop1XxEV/tIhy8v0jf6wF9Lg=
X-Received: by 2002:a19:6b19:0:b0:55b:57e8:16ae with SMTP id 2adb3069b0e04-55ce5042db1mr525786e87.42.1755156126002;
        Thu, 14 Aug 2025 00:22:06 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IG5vppBBhHVr3bNEhRLcbKtwJBmqRqouOozh53CEMqraYorHauklrnN+jqy6RCGgiQqQIBMFQ==
X-Received: by 2002:a19:6b19:0:b0:55b:57e8:16ae with SMTP id 2adb3069b0e04-55ce5042db1mr525768e87.42.1755156125414;
        Thu, 14 Aug 2025 00:22:05 -0700 (PDT)
Received: from fedora (85-23-48-6.bb.dnainternet.fi. [85.23.48.6])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-55b887f72f4sm5620240e87.0.2025.08.14.00.22.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Aug 2025 00:22:04 -0700 (PDT)
From: =?UTF-8?q?Mika=20Penttil=C3=A4?= <mpenttil@redhat.com>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org,
	=?UTF-8?q?Mika=20Penttil=C3=A4?= <mpenttil@redhat.com>,
	David Hildenbrand <david@redhat.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Leon Romanovsky <leonro@nvidia.com>,
	Alistair Popple <apopple@nvidia.com>,
	Balbir Singh <balbirs@nvidia.com>
Subject: [RFC PATCH 0/4] Migrate on fault for device pages
Date: Thu, 14 Aug 2025 10:19:24 +0300
Message-ID: <20250814072045.3637192-1-mpenttil@redhat.com>
X-Mailer: git-send-email 2.50.0
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: BT9m2rHc5mcOd0mJLAtceywZDEqrvzyGwos-2KHOLKs_1755156127
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 6B74C80008
X-Rspam-User: 
X-Stat-Signature: mb67okrk6koaqdhn6p3qpyabsb4oswdx
X-Rspamd-Server: rspam09
X-HE-Tag: 1755156130-291836
X-HE-Meta: U2FsdGVkX19ZLoBl0bZBNo5ao2cBtCQ0J/o8h8hNHuPMRuUE9LeVbgm2ftkKNRNP70Zok6yKG0BgvPWRSjhsQgQCEBEZzCi1J3KBPMCja6umSFEZKVDiL5SXMCsYAQjiagwYmDlKfDTjHSOSM6kuQ7D4tPnUVnSLy93Gpoaz36dy53P1pFZYP6NlgA6GakGJy4uFBc5F1lS1CkSIcebbYRMKm4QQ/ok8Un19qv9X/ieSkWHaoETOTui3SB9oA+60+IiTi2V8Zy/O5v38iLMr7f4z9qvE5z/9dQI8211gPkmSzTF0+c9mhOXwyEhO/eOAyJJQPoQXAvQbFxwKf+V0vK3Ua/QyV3k/F8lfF0fM0VTS1eJjJv8dtTe+IE8W4EALXHVHXF4Qk5cK+tZ9qeXmu6AGkEr/cYyPU06Gks+Qf91KUzLNAsHl56K35iejIp9t6Sa0YwRC69ctH5NVGRbNcuCiGDgraaTdLDwSD6EkSNZTWDygS5aCO9VXG+DYQR0b8yTov6FREjhuXkwHXR1USQDeQ9ox/ds4AoDsNeo4YpOWhU1yanlCU/W1GY8e2g4wP40faZLFPuZSWvWncklK82gvREHqkan16LsXx0O+6vsPXjgC1Fyk2yziZB444yWUsZRu8rRMuJ71WF0ddI1n1pKVhWjhwg1tT+K14wMK2lvERBCYBIBcgUxvxzRWcVBySXL9sFtvscUB/zr/Jg2XQkWSIwDV7h8CsUfnFbd8uhFrGLsNAbaSelJoC9kF5Oiv2yOF3RSN5EZoyMISLH/PGxHYjMmXolnKGqOQk0gm6MukoD6Q7J20EGVrhOFFd9lDNS0v4AFsiOGRxUICXrH7NoWRY5kkb1IIJiq8PUQkNlU0ptltsU8aniY0hMPjNHTuMt8tIu+VtDHWv+UBmiohxmLG6VHDnCAK9p8MMC/GalXePEMYOs19qU4WtA2hCWuVP9EB2bhxS7DXGIr8vNQ
 D/DTc9xY
 hiCDKMPVcDOd6z6y+5MuULMGfQgjrscXSL6pwVQ66XsjMCwrc5SFLvDh3hAI49XpQmZqNUtIzkbphcozX8Z95s3GNK0fjyP9bX71og/2IWWhRdqI1BEdPTuapT2Pn/6om432PIbO04mpFKqP9HRwELYXC8whhdDu0MBCzrfy5ebhVBFkqLQifA3TVCDbltwIY30/WOpO0Wz5lQGYSS0oqJIiAzyPLNeQK/Q+13GzT7WDQl1+HSdjquBWqx8ovNwVNQjf93GFgYQzexn6+VAC34+FUkS1JI5XbkTYiTQefsIw1NkMumnue3ukKAeqhxSzoTillWUu2yT/l8ctqk/DHnBP5cPEXycc24pDyfikdTCjeQkSf/tMvf8bFsdgvQdi1IwKMTZ6x5HuT2O2W0st7rZxNTGW1JgBChm8Yex6aARf9rP/lEVGb6Ccl0xUPV0ZGoFE8NRGV3Pg9Dl33BU9QBe0GajbVnMxlP1uyWz98oy8jfZ/eKpy6fYg0sqmggElEQ7CCc7RRWZ+EWCVfPMfI2HwbmQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

As of this writing, the way device page faulting and migration
works is not optimal, if you want to do both fault handling
and migration at once.

Being able to migrate not present pages (or pages mapped with incorrect
permissions, eg. COW) to the GPU requires doing either of the following
sequences:

1. hmm_range_fault() - fault in non-present pages with correct
   permissions,etc.
2. migrate_vma_*() - migrate the pages

Or:

1. migrate_vma_*() - migrate present pages
2. If non-present pages detected by migrate_vma_*():
   a) call hmm_range_fault() to fault pages in
   b) call migrate_vma_*() again to migrate now present pages

The problem with the first sequence is that you always have to do two
page walks even when most of the time the pages are present or zero page
mappings so the common case takes a performance hit.

The second sequence is better for the common case, but far worse if
pages aren't present because now you have to walk the page tables three
times (once to find the page is not present, once so hmm_range_fault()
can find a non-present page to fault in and once again to setup the
migration). It also tricky to code correctly.

We should be able to walk the page table once, faulting
pages in as required and replacing them with migration entries if
requested.

These patches add a new flag to HMM APIs, HMM_PFN_REQ_MIGRATE,
which tells to prepare for migration also during fault handling.
Also, for the migrate_vma_setup() call paths, a flag,
MIGRATE_VMA_FAULT, is added to tell to add fault handling to migrate.
The original idea came from Alistair.

These patches are based on 6.16 mainline, and they pass the HMM
selftests. The support for THP pages from Balbir should
not be to hard to integrate into this, and that
is something I am looking at.

Cc: David Hildenbrand <david@redhat.com>
Cc: Jason Gunthorpe <jgg@nvidia.com>
Cc: Leon Romanovsky <leonro@nvidia.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Balbir Singh <balbirs@nvidia.com>

Mika Penttilä (4):
  mm: use current as mmu notifier's owner
  mm: unified fault and migrate device page paths
  mm:/migrate_device.c: remove migrate_vma_collect_*() functions
  mm: add new testcase for the migrate on fault case

 include/linux/hmm.h                    |  10 +-
 include/linux/migrate.h                |   6 +-
 lib/test_hmm.c                         | 105 ++++++-
 lib/test_hmm_uapi.h                    |  17 +-
 mm/hmm.c                               | 351 +++++++++++++++++++++-
 mm/huge_memory.c                       |   6 +-
 mm/migrate_device.c                    | 384 +++++--------------------
 mm/rmap.c                              |   4 +-
 tools/testing/selftests/mm/hmm-tests.c |  53 ++++
 9 files changed, 592 insertions(+), 344 deletions(-)

-- 
2.50.0



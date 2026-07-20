Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 01CC7C44515
	for <linux-mm@archiver.kernel.org>; Mon, 20 Jul 2026 09:32:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 08D316B0096; Mon, 20 Jul 2026 05:32:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 065626B009E; Mon, 20 Jul 2026 05:32:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E6F9D6B009F; Mon, 20 Jul 2026 05:32:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C7DE16B0096
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 05:32:10 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 33DCB140738
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 09:32:10 +0000 (UTC)
X-FDA: 85008638820.01.6C0243D
Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	by imf17.hostedemail.com (Postfix) with ESMTP id 718D44000A
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 09:32:08 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=N3suUqkB;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf17.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.214.169 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784539928;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bOzdkIPPNoupexe8+AVOrQT3DBRmXPJ6Kybkle+RLi4=;
	b=uQ2QAZxWyf1VVmgsz8hlOX2xmWm7dcfFa+GPfzeIAqcQ9QdqqUjRAlxLrA27EEnuj2Au+H
	WmqyIrEtXtrRqGyBy/2lkOylBddwbHsUlBO/RJ6FMz6frA3HQpLyAHZTcKiIVDNZQTOTkG
	1TDndKhUy7KfjcKoULE6QiWGymDK3HQ=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=N3suUqkB;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf17.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.214.169 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784539928;
	b=rlbaCi6M5KERPY098L7YT1Y93da4EtcEuBh4Eqxo4/ZJ0k7Z/FLEQkFuiMbvTf3GqHKPBO
	ZTu2TTrIKarc/rHbtMjH0ti9kM0K/mBebjz4KGYa9rZc+dzMq3pjku40OXyQF3MdoMLZbj
	MaqZ0pLmWPHWIocghe447drQrqfdrNw=
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-2ccf2360620so57773215ad.3
        for <linux-mm@kvack.org>; Mon, 20 Jul 2026 02:32:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1784539927; x=1785144727; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=bOzdkIPPNoupexe8+AVOrQT3DBRmXPJ6Kybkle+RLi4=;
        b=N3suUqkBywl6eVVOR4YsbxVBYlj9BSjSNZnr6g5QfBUYoruP9PcVfMDu6vjhGCokMX
         CEvpE9rS6OnmVsPubFWn3+TJcGy3mQ5Dtq97wUwURozejoEwFFD5mAgYkzW3Z8fONX6a
         t5s83VgTpcExSUU0g+EE9C2KXc/ozYf9KO5CgVrzIAcrQp1ikwQn0FFmAB+A5p9PwBky
         7xhuttNjZrtIjdDEfmOBkaxf0gY5YCGCBFJH/1RJWnVE8Gl+wL0ITVmrJ4PFzGYUsUn2
         1X6fYEMZozEfAYUH5AYRogPGCinH17Ys0yRgNiB8lbW/b+8INOb2E0TkqRPP07IUXS8Q
         KGvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784539927; x=1785144727;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=bOzdkIPPNoupexe8+AVOrQT3DBRmXPJ6Kybkle+RLi4=;
        b=SZgQ2KtpZ45kypmRew429i3U+SawFvkuJ0bfqpSDRjOAF3WAHDrbGL0XitiqmElZo4
         YyB17tFk/uNsAC2kkAol15WBMoYub8ezcCbtSfPL57f5tF7AjWFwzrLk4l/6i6KeUxkP
         trzt9QmHRvStKBsMBlGQY1+s9W/9GVXxgoAsz9oMxv5l6Gd4jIgWdBrgQGTnTcV24rif
         ZF6UVHaP2h2HisaKsk1vWEBeZDdOx38eEJ3c5u7yRB+KgYaHL+0+xDLr9bNjxQXjjJZq
         jrcUDWWUsgdqM35+lCwbRToNtR9MOJ2PwBQeIJ06fEseG9P7ulzOUs/2rAWW+qYAow1p
         BwvA==
X-Forwarded-Encrypted: i=1; AHgh+Ro0xfweHfPOL5l74wyy3l55OQ157BnffTb4jMdqA2Ij53y9QamLfkG7PsfHzm9HOh26zEcPgaItCw==@kvack.org
X-Gm-Message-State: AOJu0Yx+svgKGqD0IoT5/rNwtQ0/fZiiQATvmAaUsMZLioxrDrqVw/Vy
	o+4P/DrGEjqb1P/SmeTOqY0IyIGbS9e20lvv5gDo/aE7/ET1D+ZyPr2fx2ysbgq0Wzc=
X-Gm-Gg: AfdE7clhnRGMa7X2hGo9KhY/DkrzES1SJ+jrKdIVWez0eRCRT5yDgULTe6ua+83eH32
	B9JlNoYelvZoWF8atnLjuR0KShkmR2DfJ8EnGA2A8wThr/XVuEYIqOhwDPZC4EzcWjKeX3dhOVo
	6h7s3q3BMzlCkRoWh0S8IX310cx9XMnlmGnNgOCoINYsxYrKbrgyBMhhaDXuxKkIft35+k/T2Km
	82RKD3ZP+4+rdt4nGmhIhutPoDiOol6eE6VrHXXw5xMtmP2itgJ+v7jVXKK3NUbDAUoJOY10/bq
	Iw3Vpn5gWci/EJhV9N1bGnDMs9YW/WxP/NA/iVkBat6O8M1Wq6nVBJPRZQYM+JbEOgVB3wlBNQY
	I/LGZdORIb7NfpvYAzky/aBepz1X7JUVpT6kje1kO3R69pRGGUPGwPDNbs/+HbFXpwSHkQ5YFpr
	RkYHh27080wBoQNU3pXRK02to=
X-Received: by 2002:a17:903:2a8b:b0:2ca:ddbd:a19b with SMTP id d9443c01a7336-2cf34997827mr147416145ad.28.1784539927267;
        Mon, 20 Jul 2026 02:32:07 -0700 (PDT)
Received: from n232-176-004.byted.org ([36.110.163.101])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2cf347a7c9fsm53136455ad.84.2026.07.20.02.32.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Jul 2026 02:32:06 -0700 (PDT)
From: Muchun Song <songmuchun@bytedance.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	Oscar Salvador <osalvador@suse.de>,
	David Hildenbrand <david@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Michal Hocko <mhocko@suse.com>,
	David Laight <david.laight.linux@gmail.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Muchun Song <songmuchun@bytedance.com>,
	Muchun Song <muchun.song@linux.dev>
Subject: [PATCH v2 04/17] mm/sparse-vmemmap: initialize shared tail vmemmap pages on allocation
Date: Mon, 20 Jul 2026 17:31:14 +0800
Message-ID: <20260720093127.540540-5-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260720093127.540540-1-songmuchun@bytedance.com>
References: <20260720093127.540540-1-songmuchun@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: py8uha4sq6xwqcz1phu8rs1hzoa4rzue
X-Rspamd-Queue-Id: 718D44000A
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-HE-Tag: 1784539928-582430
X-HE-Meta: U2FsdGVkX197qsNIkSYIJaBHvEE3owmP04QxFeujSeCE7MeLWoxVvqdVGrhm+8JRb/se8yY3p8dCHP721JJYwPoXKmYOvDkQfq1OybmDl29VPIFlf7Gf+2qm3Vn0dftD+AEcsff544Cjilw6i61mdbAqB486yg20QSIqssb4bsvDFb6YXf03x+WsddPr49tQaiG286Y67agiM4s6Xu+0rD89FSVVY/DOWcli5ECTLMfwNTXRlsk1wrHRv9yBCFrmD6qvHuzXD9kBUEyGsNEUe7ymlQdmPALus7fbaHMOeSv8dixtbXVI814Et6WnopIpjzsl2SmnCVVKJrmLU0nECzhahOcJlXwhC1JOLklavoC8qDUcFGJH188MxA5Dt0LjXXgUqGvY/R6+AuQ7VqmGxSjq0ekw16w1B1QvqM2bUYKBVTSTtdzr8u6rTo0c74ch1jWOVGaP0dhjsGgXn/j4686up/RKTK1X2M9SBBZ4kXTFRNalTp15NGFAgJqiZvsiL3AcMVVP5L2sPlw4a2fOJvs3YX9gfxL7hpXnM/Saq50C3AIrAAUZcK5huNRfuCOZi2cz1POBip3zYZQ32O4p6+lNX/7GnWgQsIbcU4BQgPQ0l059w7vj3DoXmmPNxek8m5A21o/GGx74/FOywuUiKexTo0XQ7zjjXNSccHqkO//UiIrkys/6XAt4CKVKY39yurKL1TpUjiolXbGM7SAjQAIv2af2+x1z6gNqvJRTYPz3McP7bej+GTRauL5KU7zYGeMm3sjAMwz66boBKUNq+GEqA/G4gBKlK4KwF9ultjP0/3Sn4mTDkwxkW0YQGo8/iYeefF+7t6RWEUlFskprrWHKIr9CdDm8DIiOhHvka8iLp+FExL/XvO2uEzR+97pvPafMAm9Ir+Bna9Tuc7/4OTKI+juG1lULww0qdiBsKaB5Y220zproKLY8c6tiQGufBERUDftDs+dDdkwgKH0
 Cy11q7MK
 ol+f92ElIjXO2HPsMgqNQzTV7XadUg2hpck4MFscu67dyFqsvHa5tYF3KAPYsWnVoBpWph212o+2vVI2YzKeuzU6gT0DUYseddUrzJeUKIf+v12efzySkdEhDAzdR+EqWajXfiY3Xt/C37iXcH1xlsG27GMlvLgZjPvpZ0IT8J+m98LU48/1DVRdUYhb9CmSTK52w7STx+wwTeG4xWEm8S86TgljcaPV9AwM0ZPucQxlMOgGHeEYc7fo0YKr+FKGAlKIaTOOxQ+CsVv0KZdPuxtUnfEYeXVqtfYPBhyQBo7Z2uewtLQACFseIS8vO1C+v8p1FHci4h41TXMMzGjuRbOqiGEaf/C89uzfvkk+RZqLbrVY+ThunL0t1kK53ellQB8ifK2xwjyE9bTwJiroZj/BqItbflGQjPE/Uq5SuYxnvNxE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The shared tail vmemmap page allocated in vmemmap_get_tail() used to be
left uninitialized, because memmap_init_range() would later overwrite
it.  That forced users such as HugeTLB to defer the initialization to
their own setup paths.

Now that memmap_init_range() skips shared tail vmemmap pages, initialize
them immediately in vmemmap_get_tail() with init_compound_tail()
instead.

This moves the initialization to the point where the shared tail page is
allocated and avoids relying on deferred handling in individual users.
The remaining deferred initialization in HugeTLB will be removed once it
switches to the section-based vmemmap optimization mechanism.

Signed-off-by: Muchun Song <songmuchun@bytedance.com>
---
 mm/sparse-vmemmap.c | 12 ++----------
 1 file changed, 2 insertions(+), 10 deletions(-)

diff --git a/mm/sparse-vmemmap.c b/mm/sparse-vmemmap.c
index aa6a4a2fae98..107215cf8488 100644
--- a/mm/sparse-vmemmap.c
+++ b/mm/sparse-vmemmap.c
@@ -338,19 +338,11 @@ static __meminit struct page *vmemmap_get_tail(unsigned int order, struct zone *
 	tail = zone->vmemmap_tails[idx];
 	if (tail)
 		return tail;
-
-	/*
-	 * Only allocate the page, but do not initialize it.
-	 *
-	 * Any initialization done here will be overwritten by memmap_init().
-	 *
-	 * hugetlb_bootmem_struct_page_init() will take care of initialization
-	 * after memmap_init().
-	 */
-
 	p = vmemmap_alloc_block_zero(PAGE_SIZE, node);
 	if (!p)
 		return NULL;
+	for (int i = 0; i < PAGE_SIZE / sizeof(struct page); i++)
+		init_compound_tail(p + i, NULL, order, zone);
 
 	tail = virt_to_page(p);
 	zone->vmemmap_tails[idx] = tail;
-- 
2.54.0



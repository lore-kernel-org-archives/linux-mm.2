Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6ECF6C55164
	for <linux-mm@archiver.kernel.org>; Thu, 30 Jul 2026 15:03:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 36D9E6B00A3; Thu, 30 Jul 2026 11:03:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 31ED36B00A5; Thu, 30 Jul 2026 11:03:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1983F6B00A7; Thu, 30 Jul 2026 11:03:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D289F6B00A3
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 11:03:31 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 3E37A801A6
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 15:03:31 +0000 (UTC)
X-FDA: 85045761822.10.F63D124
Received: from mail-ed1-f45.google.com (mail-ed1-f45.google.com [209.85.208.45])
	by imf22.hostedemail.com (Postfix) with ESMTP id 517EEC0014
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 15:03:29 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=bXdjOgjw;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf22.hostedemail.com: domain of yiannis.nikolakop@gmail.com designates 209.85.208.45 as permitted sender) smtp.mailfrom=yiannis.nikolakop@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785423809;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jbxhIHpP+P+duAb0b+RpjF7CmIf+HVEI8a2PNCDtUeY=;
	b=VcQLmDS5m3r6w+UjE0UopM5pOodVWV0DYQXTtHcSUXLMbOeiTuMTPSQJu8gU4o+7KUV8aB
	0aaFp2pqZMfsL7lYypLYtoCbQGxhhyuvtMdK34Mxhdtj6LDWGkxB0xcvfV0HcDQYVtBgBp
	A1IGAUtdEODau04Ew7QG/IZ3OuSNm5Y=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=bXdjOgjw;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf22.hostedemail.com: domain of yiannis.nikolakop@gmail.com designates 209.85.208.45 as permitted sender) smtp.mailfrom=yiannis.nikolakop@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785423809;
	b=HL7wygoQccr0/JuoeuPOlP/IcaanZdiU+XWvBA+2nOKa0ocmXigzgkb/wILY7oXXYRqM9i
	OJuxk8n1lWtuR3zLgx6Pvgda7G+L5mFlotYlavYUWbZlCdQF4vXUQHt4Xx+fJ8Ohvx2XTL
	l2Nt3c+Xx6h5H4tirY5OnZGSDX4gNNU=
Received: by mail-ed1-f45.google.com with SMTP id 4fb4d7f45d1cf-69fc9f25118so2337109a12.2
        for <linux-mm@kvack.org>; Thu, 30 Jul 2026 08:03:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785423808; x=1786028608; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=jbxhIHpP+P+duAb0b+RpjF7CmIf+HVEI8a2PNCDtUeY=;
        b=bXdjOgjwI3rstyGLo4G+FA7nGGtr7sXGgozRPcxLUZ4pqtxNlryAi2Hpy2LCHwzARx
         oCA/9MYTfRNtWJ7OW8ndAHIneOTvouMPW40uM+YuenajjSF4ubtY3UctnYLaEGkHaIun
         C7w+buYIllOVpBJA8rgn0Eo8o+/uP/36DPLB/Yvyj9hOKVtdyV0t4KGK2HvzDxhiZuUA
         WKze9btfGmJQII1nxereOT4Cm4Z2TQgwT4aRmzXf7WxD5887IqGIc4Y2u7S3Syh1740X
         tSefBbOO+3k+r236wSp2ZEqvuvy28Ejzklp/j1B9aCOhIdtU4CXFEAWfOXcMaj8YKMCj
         zHXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785423808; x=1786028608;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=jbxhIHpP+P+duAb0b+RpjF7CmIf+HVEI8a2PNCDtUeY=;
        b=LDNVzbu4wXI+g4FnXIWsmFJ/Es1Hsk78v22/9C5OcA+W2KAW5GwkbDfbGn/X5mOzTo
         RYUrl/z3eXxNKgTQkLa4OQl7b2wjk1xxY2fi1+wUvmHInhw9pkq+srDfp/DsezqjBZhq
         2fI71iGxu+9wbKScBZ8gLkODAdC0ZLuStT1lQnPfwK+lr4jaJ3FYYko7G8xJbEkgsspT
         ytkQ5YcriXsTAIqD9dmBUTJlQnS8Qmwwf/CAfFia53gwc7umSbjytis1H7QczI+8XhSM
         2hKDxhmli/KtY8VHKbsieSyTuTWZfRt2/sv6r81wYjec1UjZMumHEI4oIeINK8bXfhIP
         PQRw==
X-Forwarded-Encrypted: i=1; AHgh+RqZ5TEDTYV1WzVcDDyoTpKc5UfeWA6noxIwIQVNWCImUG66bnfiqn7z3UszfGN3YS6grIIDNlAH2A==@kvack.org
X-Gm-Message-State: AOJu0YzGaVGUBqbiqndoQGkpqi+gVicNt6jS98bNMl8TjoTnLDVXQ8cJ
	/vub9ZuLe9JTRIkCt9s2gQtuK4kyG4YZ7rn8CqcomOPQqu9agKEPeiX3
X-Gm-Gg: AR+sD13MqdF+L7QMeK0jXz+kc4y0c2YsT50eMGzTHQCIArYNZZ6h/nqFZKcpd03l5ik
	Yqf7VsFq6WLp8vO9fcH4ZE7cGo8laHt8cznVyCVxPMeeDaA4pd0ZhzRSuEzuYAQDK8TgU+Gg+8H
	yjyvYat1b48uS41SXnCwAJTpjYg4m7MLBXZu7ViZm2zVx+ZK0LhcUMlLYnW0M/r3hOOpfdol5Wr
	Fxn5fvdOHPJxhYkpmj6mzldq9P0/dmd5KrWB28nhii6MihgTDuvk4/XsUzgfLnD4EMJQOsNgPi5
	+8BzQqhsHyYCx3ohnKRT8K3mtVj+qsTDNDBajY+Wy9sxGj1eVLSWyF6L3wbL4I8468XKP7nimfG
	OOxaL4hjWNB/PpQkO1DVZvcqDu2HTePzWR4bvVIbI+ZVLJUscAovQWynIzVvkxhL3zKz5QmmIF3
	s7g9ibQ2wpXk9oFfe5fjNHvkyBQyAHXk4w0FRxWD9Q6ieO0SqbzgrhlROt0vW0Qwph4vJV1qR/3
	jenyaJ0qE3cBB9XdoUEE5zbWv3OTN3pTw==
X-Received: by 2002:a05:6402:5418:b0:697:e953:d14d with SMTP id 4fb4d7f45d1cf-6a07b8148acmr1397265a12.17.1785423807694;
        Thu, 30 Jul 2026 08:03:27 -0700 (PDT)
Received: from [127.0.1.1] (h-62-63-197-109.NA.cust.bahnhof.se. [62.63.197.109])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-6a07bf18ff8sm729116a12.0.2026.07.30.08.03.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Jul 2026 08:03:27 -0700 (PDT)
From: Yiannis Nikolakopoulos <yiannis.nikolakop@gmail.com>
Date: Thu, 30 Jul 2026 17:02:59 +0200
Subject: [PATCH RFC v2 3/3] mm: use non-temporal stores for demotion
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260730-rfc-nt-demote-v2-3-452dbe3b5073@zptcorp.com>
References: <20260730-rfc-nt-demote-v2-0-452dbe3b5073@zptcorp.com>
In-Reply-To: <20260730-rfc-nt-demote-v2-0-452dbe3b5073@zptcorp.com>
To: Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, 
 Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, 
 x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, 
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
 Trond Myklebust <trondmy@kernel.org>, Anna Schumaker <anna@kernel.org>, 
 Zi Yan <ziy@nvidia.com>, Matthew Brost <matthew.brost@intel.com>, 
 Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>, 
 Byungchul Park <byungchul@sk.com>, Gregory Price <gourry@gourry.net>, 
 Ying Huang <ying.huang@linux.alibaba.com>, 
 Alistair Popple <apopple@nvidia.com>, Steven Rostedt <rostedt@goodmis.org>, 
 Masami Hiramatsu <mhiramat@kernel.org>, 
 Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, 
 Brendan Jackman <jackmanb@google.com>, Johannes Weiner <hannes@cmpxchg.org>
Cc: David Rientjes <rientjes@google.com>, 
 Davidlohr Bueso <dave@stgolabs.net>, Fan Ni <nifan.cxl@gmail.com>, 
 Frank van der Linden <fvdl@google.com>, Jonathan Cameron <jic23@kernel.org>, 
 Raghavendra K T <rkodsara@amd.com>, 
 "Rao, Bharata Bhasker" <bharata@amd.com>, SeongJae Park <sj@kernel.org>, 
 Wei Xu <weixugc@google.com>, Xuezheng Chu <xuezhengchu@huawei.com>, 
 Yiannis Nikolakopoulos <yiannis@zptcorp.com>, dimitrios@palyvos.net, 
 Ryan Roberts <ryan.roberts@arm.com>, Huan Nguyen <nhuhuan@google.com>, 
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, linux-nfs@vger.kernel.org, 
 linux-trace-kernel@vger.kernel.org, 
 Yiannis Nikolakopoulos <yiannis.nikolakop@gmail.com>, 
 Alirad Malek <alirad.malek@zptcorp.com>
X-Mailer: b4 0.15.2
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 517EEC0014
X-Rspam-User: 
X-Stat-Signature: 7fakedcmryo5b1zqm86ijwjeoqr7c45j
X-HE-Tag: 1785423809-591066
X-HE-Meta: U2FsdGVkX1+lqLq46yr0RDpW9cMq+iZxrrwBtNYYk5psliZEpQcEm/AX77lhzg/af7w6YBcCITmYdws9BQXweIJiSlQVZWeTqwXAHYxj5bbfO9AySKA1NMfG4bS2pcYOVzGSn3gSatGdwpRYwunsnt2zx/QVh6Ex3LvFPrRdkTV2uNuA9HvojhoyLlBOp59yxxGcZ28cjDkZvPeB4V/xbWEFwEhjeJGtn4ZG4B1LAE8naechoLpNBuilsOyPUiCfGosKadZDpomglFwvn+qwbALjGOutB2K5KVSmBU7m04bjRj2yYQIZFkzZZnakztCOWqGlCoyuS7Pjp7TazEC77eoi2B9El9HBENWRfiyN0A+WATtM3SiU8uiONhuYbUTTCBQEhDsnSliVtGV4cQp/1yow+LD7iounfggybtYGqXTKgBkjQew3hibR7DiPMuvB8uyR2ULhXUeJtmIT5aSWhLiWHkwEPnQa6yz+EbgUctLhjVd7bfPFxp2v9KxWxBwUz4w/zATyHX9CMa9EA4FebdkLZsY685O3M0i0W9HbMBKdK+hqEIEUuHji7qJ6pigXHi/hVCKCWyu0FdMbrOHY3RvD41R4vk4B+jQ16wbujQ+TKnG2iP9KQI1yP6f1mZQWexopZ4N8oh0h/1LYDnYhSux26Lo89EuMZn1RiN7+eLssBZFFeiQGMc+jG8wGSKTCorRr/YJOjS8Unt9BgCYT1+Rhj0ceDd4iV1EY7XRSSSkON00zvKmmGWLLwnVMFmjWAgmo/ilb3F0b+oZZJluUAreqsw1xqiPLXOPAbLMNZlh2OFbQD4sMShLmUSdC6gVu3A+DDrBroTrIg0Igqj0a4wkvL70+PtxvJl9PJGlmnUyoFfXaUY0NpVayl6oc8ueeP23E//S/4KT/5vdy5J1tsLfr116yTbJYLtriv/lzgukAcAP3/lH+NsY9q1SA5EnZVEfipCjQ4soY1/bFYX1
 rnuVWHu9
 y0GLEfc2gREhfrKcSixe3y1jNTdrZIPlUmYqt89SpvztoGwimvwMOBNIdRxLpL33Si76DNQonFWoliDsMtKIM7T+L3V916kWktdeafXXm/0rQJZEEZk3EhZgoerirvvusjtS6g7VZ2WVw8AeNpxKEw8OtaUANWG6mcbSh2slH+D3KlF5yzg1uMJ4zz3lirmRaPqspiCU04HBDP6JCg8azoF19j1W30u27TnAu3HBR9AmV3WzFXFPjrrzqumvpVRKQGPUYfJrAQRUab/rYfbct4iMNSrU5+kfJw+wgFyqE/twgmQUvgA9V39BqM4LIwClkhKAbIrBl7NROMeh5DzTC+RkQH96roUGst2gbHAQxA/H2pBjbbTHaOuIOQXDeY9vcIHTnnqC4RU175WVsu5uA4FWxGXMVjRAeKSq6edERwlFqwBbgAqsy0cmqeSgOzzrC8WuFX/uH6Fp5qhjvprX1UGF77SfTiYOGpFWTvE33FlNseJCWAFJGz8oPNFINw53UH7QK8UPW6rx1QdU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Alirad Malek <alirad.malek@zptcorp.com>

Memory demoted to a lower tier is assumed to be cold and most likely out of
the CPU's last level cache. Additionally, in certain demotion targets (e.g.
CXL devices with compressed memory) the bandwidth can be negatively
impacted by the eviction patterns of the last level cache when standard
memcpy is used. In supported architectures (currently X86_64), use the
MIGRATE_ASYNC_NON_TEMPORAL_STORES flag in demotions to trigger the folio
copy path using non-temporal stores.

Signed-off-by: Alirad Malek <alirad.malek@zptcorp.com>
Co-developed-by: Yiannis Nikolakopoulos <yiannis.nikolakop@gmail.com>
Signed-off-by: Yiannis Nikolakopoulos <yiannis.nikolakop@gmail.com>
---
 mm/migrate.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/mm/migrate.c b/mm/migrate.c
index ff6cf50e7b0b..c7c62700d541 100644
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -862,7 +862,10 @@ static int __migrate_folio(struct address_space *mapping, struct folio *dst,
 	if (folio_ref_count(src) != expected_count)
 		return -EAGAIN;
 
-	rc = folio_mc_copy(dst, src);
+	if (mode == MIGRATE_ASYNC_NON_TEMPORAL_STORES)
+		rc = folio_mc_copy_nt(dst, src);
+	else
+		rc = folio_mc_copy(dst, src);
 	if (unlikely(rc))
 		return rc;
 
@@ -2081,6 +2084,11 @@ int migrate_pages(struct list_head *from, new_folio_t get_new_folio,
 	LIST_HEAD(split_folios);
 	struct migrate_pages_stats stats;
 
+	if (IS_ENABLED(CONFIG_X86_64) &&
+		IS_ENABLED(CONFIG_ARCH_HAS_UACCESS_FLUSHCACHE) &&
+		reason == MR_DEMOTION && mode == MIGRATE_ASYNC)
+		mode = MIGRATE_ASYNC_NON_TEMPORAL_STORES;
+
 	trace_mm_migrate_pages_start(mode, reason);
 
 	memset(&stats, 0, sizeof(stats));

-- 
2.43.0



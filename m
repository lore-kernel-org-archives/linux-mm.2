Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2B4E9C79F82
	for <linux-mm@archiver.kernel.org>; Tue,  8 Sep 2026 13:14:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A0FB16B0096; Tue,  8 Sep 2026 09:13:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9E6EC6B0095; Tue,  8 Sep 2026 09:13:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 861CC6B009B; Tue,  8 Sep 2026 09:13:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 563DA6B0096
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 09:13:58 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id E6E58A5049
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 13:13:57 +0000 (UTC)
X-FDA: 85190637714.21.4CDD127
Received: from mail-ej1-f49.google.com (mail-ej1-f49.google.com [209.85.218.49])
	by imf22.hostedemail.com (Postfix) with ESMTP id 1FF09C0010
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 13:13:56 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=rvKKafPM;
	spf=pass (imf22.hostedemail.com: domain of calebkan1106@gmail.com designates 209.85.218.49 as permitted sender) smtp.mailfrom=calebkan1106@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788873236;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mbEf3V3BeedaNXPvyc7QWrrndht5k6QHT5mMZYzozBE=;
	b=1Yq/5CbEToVnpAs+CEahjbZuclUyO2iJOLOZXjI/o7qAgFRht3AKFq5nvHAhLOh7R6qJo9
	eEmmNW2xfMPqGiQn7OBIthjR86pvPZLTrejHa9MIshCf6SXvR6Duo5k21Mn4YLW1R4zIaJ
	tgZDjMFa0M1qXetyodXxPaTjed/d1vQ=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=rvKKafPM;
	spf=pass (imf22.hostedemail.com: domain of calebkan1106@gmail.com designates 209.85.218.49 as permitted sender) smtp.mailfrom=calebkan1106@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788873236;
	b=tjEuFebAgI30XryqpFBvwxFJ92xij6IuSharLQ6gRdcKQ3rG57Nqin5KzsU2YoyF/UoRpC
	4tQegSwsBUna1O1jQSZNgks+vf2nt0EVyK6fkJgkRVwweJ7zsGH2H+7xD56JL1rF67k/eZ
	aKTL8EO6p3jCIMfwD2PKhDey+eYJaFA=
Received: by mail-ej1-f49.google.com with SMTP id a640c23a62f3a-c197e7e4e94so746309166b.2
        for <linux-mm@kvack.org>; Tue, 08 Sep 2026 06:13:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788873235; x=1789478035; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=mbEf3V3BeedaNXPvyc7QWrrndht5k6QHT5mMZYzozBE=;
        b=rvKKafPMt/PjBOjOZu5/h8nt1NDKUj8rm07RWkBC9+x+zIW5heHGcn55Q1G/j/eCWt
         I+IQ3igWPPn775zilZVEWA+ap4Xp+ys9tTt1NueTBk0UCCWqd3BiGjLN/46KGRyhlyZT
         a5htAjWJ689ORXMUyVjYn6L85XZCLz8zmWrtDqLypxCQSqbi5Pl9Pav88XnYAJPxxLiQ
         t34NXss/6JqI/9yjafIl+Yg7KoyaK3TftpAvu2OUQuzE26LK6PUH173Y4P3UwZcAS49S
         FUYqm6P0+VnfT2Ip52Zm7uCuU2GtfWqBU8D1q4lVr399M/AlcbV0E4Wh8jAAXLnKHy/W
         Yp8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788873235; x=1789478035;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=mbEf3V3BeedaNXPvyc7QWrrndht5k6QHT5mMZYzozBE=;
        b=XvW1ftTUxzNzPrdrgQzNMpq8qn40sIpEqPSQWHmAiHxFhpXP/eLh5QDt5a4rymjRMM
         JHQSLnwVFFsN+Lkv1dyhFYpCujlA/aZHHMwo24OdPXgyw+yhPv7mNdb4x+MPN/nfUjSQ
         yhIQVI8TxXypBH/TeHV6PQ9Az+s3KcYoTWJkiohyMB0NFi+OgwZN62dwSrFhmLkV4y94
         t12hVeTJBWM1GuUty5S8bS8G2AKkt4ou/xeeQxTpzMFtjSC0OOTuf5c7mCQr4L6WXhXu
         XyR8T5hTRsVTkisvvv3guqV52oS5Uu82i6F4UQbI7SFMkfX8T4wtuFb2ynx+SPZOwIaI
         dg+w==
X-Gm-Message-State: AFuF++mD5k1fpb+5ujgtDrZNbCMgLK4sjVdQ7ncH4fzUmHFG2pxCypm5
	1OqNFRR7qIb8WerJ+CasBUpQE1j5mXEMpHzsoMpQ0KCCGQ1zuk+LGpwx
X-Gm-Gg: AYBFou1SL7aLa1TyaJbCwpgeqotJjkA3pbJ1DdA8oTy4BfcH2VdsswL6ephN8MJ+QIy
	AjV2rOkKloORiDVMkmnObn4jMdXuwTLtjAr4UatP8SWs1TpzWOpm9kQZmdnm2OBBLiuCb1+Pmk5
	LA+TDBsAXouZOItjn7g/dPBEXCBT19Pw+PrBtPOFiDvh6OzwB5d8prn00Norh0zjAtmVqjvORZ+
	en3AsELl2o7BUrYogJLsIexwkeHqhQaGiVuopHriCS5/MGOCyH4sGQSTjdb4sMvcVOvWtGn5/pH
	0sE6WHEYbKpb+KOZcZSm1byndGY+OCuEgFpypRyCR+79k7howfD6GjSx8DQtA0VE9XRAj6n0qbh
	DrqKumdk6eOnvOx6VY6BlF7kQPUN0oQ3Kd3ywO6rr2BAwOL/XoIdZw1zRavsFKQuoPmKI5qEUrH
	dcvSxsvjSg2rkymcwLMffP1FjvkyEzfnNguv21XwKxJ2dVkJdf+Q==
X-Received: by 2002:a17:906:1004:20b0:c26:2205:e8b9 with SMTP id a640c23a62f3a-c262205ea13mr572772266b.25.1788873234617;
        Tue, 08 Sep 2026 06:13:54 -0700 (PDT)
Received: from [127.0.0.1] ([2a09:bac6:37a9:1e5a::306:1])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c260d6e1c93sm625170866b.63.2026.09.08.06.13.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Sep 2026 06:13:54 -0700 (PDT)
From: Caleb Kan <calebkan1106@gmail.com>
Date: Tue, 08 Sep 2026 14:13:37 +0100
Subject: [PATCH RFC v2 04/11] mm/kmemleak: print trie-backed stack depot
 traces
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260908-stackdepot-trie-v2-4-1996d5cef732@cloudflare.com>
References: <20260908-stackdepot-trie-v2-0-1996d5cef732@cloudflare.com>
In-Reply-To: <20260908-stackdepot-trie-v2-0-1996d5cef732@cloudflare.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 kasan-dev@googlegroups.com, Vlastimil Babka <vbabka@kernel.org>, 
 Alexander Potapenko <glider@google.com>, Marco Elver <elver@google.com>, 
 Dmitry Vyukov <dvyukov@google.com>, Andrey Konovalov <andreyknvl@gmail.com>, 
 Oscar Salvador <osalvador@suse.de>, Caleb Kan <ckan@cloudflare.com>, 
 kernel-team@cloudflare.com
X-Mailer: b4 0.16.0
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 1FF09C0010
X-Stat-Signature: fw3396885dy5gfugj3muhr41o9xet3ny
X-Rspam-User: 
X-HE-Tag: 1788873236-283420
X-HE-Meta: U2FsdGVkX19tHp4EGsFpjwV+FSjw5hGIadhny6B5sUZxVvZhpP1N9gg7LmJeM3pq3A0yiLFjj65Ci47G1eEG/qPrxbR4F3/qwASz25JgcLI7rzqCYqKDexGp1ZDWOY3MS0+3LI8/8+iaD8hv/JPZ1KGVNMRobGvt0Qe5074yRNJ931vGYktprqEVbFR1JWqD/4mE1V5lXMFopPg+GGlVGE6VhTFuIXBX8PmL6eDPK58KC56TnrOfBjbBJlTKbsJlVG6uUN/Za2ZO2p+NLJgo7iPz4zKD2kHzP7O3IbEUXv/F7v7ezQW9R85dnKgse/zuh/Lkc1KSSEWC91Y8wLnD7hpZX6u6RGqdECATukGmdjJpJi61w85RCaQMQn4XRI6pWNx6Jwi7/Z409Rc8Q4XCJnKc9EVYEgTIB0pARSo9g2GcfIJYUr8vJUSGVynd1kky2A9X800ttBqFVGBLH3FKG0JRxrG0AAg/kuPzwp8LAy8HxNy0MR79RviTr5wZinbfH45eodkO7RRjH+oSSErQ0uoNXlVPbwh4eSjH8rLyO678hfkXS8CpYTEbTXinBRj2LbkpeZ3VJm3N8hf2OLsuOLTpAQHihrI0zZrgFVLfrl0FVZvjomSQ6xv7PXcqYKo6UwcESoz/RxU8qfNvwisGzTTQT07lSCsro8jjauuslHLvnErYrpon3sgt92xT9K3hhMyHTy1/h4vTZqWuMdb3mN7xxuq/Bga2oYnWj4g3ZQcnjeQgEqqiRSjexXZI+MXa6xF/bm56Bcb+EmGaNb0mwRTXM5CCCz50fOlromLu5seV/YfoW/9XbFVGpqF72cN/V5Yci4nsd+78v5ZoTS7YR1usFOVLaXiSZGY1UQpqllVZQRV3NFd4b7be201cfdPAB0W6YzLcdpZT/HD/PbPB/keXnUuCvl89iuz1S1fx3WeobEMIjf0/HuW06dOE7fCy3cRKFE7m3b2Wt9JfmWq
 ktC7Apa3
 KI08cw4mvG1n8mNXFwZJcCBon2C0220q4toEskZX91MNJc7HA85ectYm39X7OGs7PQ3qNkmYhwCI8QvF+3JBrOwIjH07OM9vPfDK9oC/wDrq8/qzxcHGh+ynullSURYS2Ww/f/CAHIGnUDMbLK339XGBHjlk9dHUJFDAE+6YroO+zP0Ck3cN4hQUtVAW7PaCYLbKajh3cVZVENx9yIQBAf4zwr8qgTN7qVg+A1LEwlWsR8k19eFnzTj6kSQRMKTawAQayq5yS0Ncqs5ZjnPBNRwPyMVJ/k+Mxeb1OYb8idVLZSl+fmuA3oYfCS9goP5nug4pzJzmHrCPr07qAYd+yH5VXDBpzfx88fi8ZSkEqQl0iIxKMbo3atmKs1LBXQmmsV7BNRyUX8jVn5foIqe822x9M/e8d3idMb4QtLZCLE3QSvY2Az7HnZN+bUZzhcUcmoT1zHUROjSToqBrf2uj5JVQtI9HHp8RbpIq6
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Caleb Kan <ckan@cloudflare.com>

kmemleak stores allocation backtraces as persistent stack depot handles.
When trie storage is enabled, stack_depot_fetch() cannot return a pointer
to contiguous stack-record entries, so leak reports would omit the saved
backtrace.

Use stack_depot_fetch_into() with a MAX_TRACE-sized local array before
formatting the report. MAX_TRACE matches the save-side limit, so every
valid kmemleak trace fits without truncation. Preserve frame order and the
existing report format for hash-backed handles.

Signed-off-by: Caleb Kan <ckan@cloudflare.com>
---
 mm/kmemleak.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/mm/kmemleak.c b/mm/kmemleak.c
index 8fa409a4f9fb..c42741a88bd4 100644
--- a/mm/kmemleak.c
+++ b/mm/kmemleak.c
@@ -378,10 +378,10 @@ static void __print_unreferenced(struct seq_file *seq,
 				 bool hex_dump)
 {
 	int i;
-	unsigned long *entries;
+	unsigned long entries[MAX_TRACE];
 	unsigned int nr_entries;
 
-	nr_entries = stack_depot_fetch(object->trace_handle, &entries);
+	nr_entries = stack_depot_fetch_into(object->trace_handle, entries, ARRAY_SIZE(entries));
 	warn_or_seq_printf(seq, "unreferenced object%s 0x%08lx (size %zu):\n",
 			   __object_type_str(object),
 			   object->pointer, object->size);

-- 
Git-155)



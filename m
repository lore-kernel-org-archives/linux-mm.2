Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AFF97C5B572
	for <linux-mm@archiver.kernel.org>; Mon, 17 Aug 2026 12:43:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CF4F56B00C2; Mon, 17 Aug 2026 08:43:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CA7016B00C3; Mon, 17 Aug 2026 08:43:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BBC466B00C4; Mon, 17 Aug 2026 08:43:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7A0416B00C2
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 08:43:07 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 048A3A3276
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 12:43:06 +0000 (UTC)
X-FDA: 85110726414.03.B353B9C
Received: from mail-ej1-f50.google.com (mail-ej1-f50.google.com [209.85.218.50])
	by imf27.hostedemail.com (Postfix) with ESMTP id 31C1F40005
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 12:43:05 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=LBH75tsr;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf27.hostedemail.com: domain of calebkan1106@gmail.com designates 209.85.218.50 as permitted sender) smtp.mailfrom=calebkan1106@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786970585;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mbEf3V3BeedaNXPvyc7QWrrndht5k6QHT5mMZYzozBE=;
	b=iYIgbanqfqVpHU18gUh/bns1ukuhMgGPa+f2J2BEOhmgDKobc1LyELc+9EbtXyXrRBdECd
	A+jeG2yhIowTBc3xbjzM5s0AS9DsObLhXwJ1U8jYPI0B4SZvNt5h8T43Vj2BDc6uQEz4WO
	wCY3YbbopauXhqIx2Z9uvo/8GwQtxq4=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=LBH75tsr;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf27.hostedemail.com: domain of calebkan1106@gmail.com designates 209.85.218.50 as permitted sender) smtp.mailfrom=calebkan1106@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786970585;
	b=ueKW8bSeRd+7OauW/aweFc1ezJr8zABBIwI/uahjI49NuaX1opF7e3rrGVHTLV2ugxpajv
	PHheX19Ihk0x7Wo77QHF7C1F1keUIG53BPv6+iK9Sbs1P02Fl3suox36OE4LLQXM6xM3ff
	8xxJVcVEVZLkA3TQ9MtwCldwcaHRjbc=
Received: by mail-ej1-f50.google.com with SMTP id a640c23a62f3a-c15ca7a7ca9so333601066b.0
        for <linux-mm@kvack.org>; Mon, 17 Aug 2026 05:43:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786970584; x=1787575384; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=mbEf3V3BeedaNXPvyc7QWrrndht5k6QHT5mMZYzozBE=;
        b=LBH75tsrb02MZwk8taJnpfe/h1jXK3ZJxZBuLlquJbQ6+c3i/KQRaE5EY4JlOIUtj4
         v2mkEoZiCVvtmNVA9dwMi6UFA89jAocyBKbuGLYaYyUkAIDpxJBWqhMUpeon2fYSkChA
         1AYuk/q9uR5sSxrLTP/8v8boc1hQZVjzRE2qRmz7Wvy8Rhif+nMM/TiCXQ5DMv0fFLV7
         2UCsrdZAnhYhmasN5Xv/0cpXMdv2y5crJ9NaNojF7u4WlhCtX1FurzuAuK38jC5lhTav
         Dl/pyMcqhuz/7r6blPTQ0xLVzvCAkABPiq+TF2+Oj9JN/9hiQb9ti00yosW+2WXfTEt8
         sNFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786970584; x=1787575384;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=mbEf3V3BeedaNXPvyc7QWrrndht5k6QHT5mMZYzozBE=;
        b=iUX5IfpD8bvMxKUGIlyquS9cj4WRo6WvsDaXD++mnsJVL03Hnn7BhOq8YaSs4gyh4j
         AK5ZOMAirTzHe5OkJ6U+3ItyGqEV4OTb74TvdMWyA6jeXhJ8smS8xZoyDPcogNzIfPNq
         RRnrh2/BjfoPrGacaDVHSz4CN4koZrDvYa1Is48n/U9NZRvZHJqAYwMDWr2i6PWbv9ju
         NBXBwcmacFOBplsvD5dlqBa0f8+PRiKWkdhbbcctWsd2KzL3ZDQq+qF+hopLOpVbtBb6
         0mTOGHDYzxYFphLJQbTWASC6QGumpbNKaod4LBksfPxkGDvD/+gaiF9szkFozpT1Cc4D
         MRdg==
X-Gm-Message-State: AOJu0YwwoiChfFVS+nhZkJJ2tNBz7Q1n7txPFLehQ0xnbpcWd4ue8/49
	0kzG/l+z7sML2bItVW1I/pmgOJF/hk2KhMbdk1UsSeHMD0ZwxNbTAXrq
X-Gm-Gg: AR+sD13RY36wTADXFfxWgEJaGOZVoDh/Am1xqBxdMcubCZz3l86Gh1KK6IS1oY4fHNJ
	yE9kqCuEDuQXIvI4oM2zB5Iu6DxEgAh85Ht3RHCNNCUkPpe8W7NYrOc6zAQPu3Ul05359ZECnv/
	sistC7RJU0khJRs/swnqzJF3dgYmb9wCTMSUw869b8O2tnDYy4/0cxZausewJ4jTJn0XE4JeZzc
	Xo+iWI1SRrWsC4UGxvBccbe4F8VmdaYQPFM5ctF4msI1ZYTba6OLO/iQTehBFjy3btd0MXO+REw
	+zpcdKWvIM7q+Ldd0mwjawWIEPlrIyulmrEn2P7UEClCXXh/1bJPj0QABrwQosxZRbLrHuQekCJ
	nwPqdl0zIEWXeUjhXomtiWy1wrHeMA0VYpw1dMYNefw83LUTqnEDB6hSpUbRkNitKpXKvMkebYL
	UUXQSE98bvhf+3+AyhJLRTkJKFxPwpxElVP+kpYwzEn3brLvHq6w==
X-Received: by 2002:a17:906:f183:b0:c21:82bb:1105 with SMTP id a640c23a62f3a-c2182bb1689mr70810566b.22.1786970583773;
        Mon, 17 Aug 2026 05:43:03 -0700 (PDT)
Received: from [127.0.0.1] ([2a09:bac6:3861:1e5a::306:a])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c217feb99d4sm52626266b.22.2026.08.17.05.43.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Aug 2026 05:43:03 -0700 (PDT)
From: Caleb Kan <calebkan1106@gmail.com>
Date: Mon, 17 Aug 2026 13:42:44 +0100
Subject: [PATCH RFC 4/9] mm/kmemleak: print trie-backed stack depot traces
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260817-stackdepot-trie-v1-4-53870ca1651b@cloudflare.com>
References: <20260817-stackdepot-trie-v1-0-53870ca1651b@cloudflare.com>
In-Reply-To: <20260817-stackdepot-trie-v1-0-53870ca1651b@cloudflare.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 kasan-dev@googlegroups.com, Vlastimil Babka <vbabka@kernel.org>, 
 Alexander Potapenko <glider@google.com>, Marco Elver <elver@google.com>, 
 Dmitry Vyukov <dvyukov@google.com>, Andrey Konovalov <andreyknvl@gmail.com>, 
 Oscar Salvador <osalvador@suse.de>, Caleb Kan <ckan@cloudflare.com>, 
 kernel-team@cloudflare.com
X-Mailer: b4 0.16.0
X-Stat-Signature: 9tr9rcyf8c796t6e1x37jio4icmpb747
X-Rspamd-Queue-Id: 31C1F40005
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-HE-Tag: 1786970585-729652
X-HE-Meta: U2FsdGVkX1/gmFmxvljy+tfiu1oZCkHcM+naX9Rs8r5R+rS3f5zMzGNphDPf3nrVNgtn3Cta2uHV5wIM3o0+KP0cWoBe7Tvh6i96snmmOhWgWWH9MClACWueVQ7K3CHzrod9T38RraekOa8U3XHdY7PPw/BPNfBXAHaHssN/SvzfVInBolvAATnVporYUlPfyFbbtNQuQ4RPayAMFPeUPK7UefPzmSQgqQ3biEADTsOZnuQbqAi/sRAjSG6Ylyo5p9qTQgs3wv0z6zIS7J8o80BdObnyfvmwBYPoUE7Kw+QNK8oaQIlqs9/2uNY0i+RObE2eCfi6Yt+RBSwt+kFwlH+LTpKwZYS4QDmn4PhKrE3Ak9R1MQJ3oWJCp2FHkt5kIMc028zkKOEmdkePTHptKF0FA53EIm3P9y9sJQLnfw5EsymUPrkGEHMGhQCn45S80qWw7ailUmmo91LNaywDDwqrBRMltk/UqURL5Yzq1aiEeRtQvzCRrbdS4N2v9zUFQw+1W01i/PHxOQMLCpJ45VFg5NOcnRUyecjFsqZYthHK3VAEHZX5UN3cNDJMkt/5PkaB46YAEuoll3PoYGhNmWvj2t+cHuL4yIR2taXOVwWt1DzUPyJR795AGxaJMFvwFRYU09L2PqkteaXWol0Vfpnk+0lKoiZY3+bklOL9eYNQLgKlJXIzd8CqFo8Xuu5rYAF2zxPf/wJtgBffCX2Ol2dfDRV/WKIfrwaB+6QNkHOTc0Md5z+y8mG1vASr5qULfCRdsLbLONtrG1nVCLJUyspUC9kUHsf0m/cdL6LJorffaemM/vDOF99zTOJv4dHTuquZA2hBc8yUmXVx1KmKMyl/VR7XT90mdkO3qK0cG5iAXioxwdofpIlRsk44dMqUl1H10YfEKJ2Qq6+L1MscLfur3XeolM0faNbDzrcCkI4qCdNBeGzUi6IkqN/JMhoo49fRClgjfkDmox2xZ69
 W++fQPq5
 5OX3xbyY4gqLH10NGoZalZN41wPM0pNexMLmVSjARMTqmUjaF2FFBhfbI0dsoESJav1HWcIU40qwv1ZFfh6WlMt741jD3lo+rCF03kKm9dgfTW/DkmfkaPOtIXfZ/WrA06XzQDojkN0rWFImyKWAXQZDeHAX5F77HrPBYp6lHa7mQtuaRL+VdcJe907V/M4v9bSgZkOpIc55x5rwlkKoFpX0b2jmuaT2Lzk9z2VqOhg2wMb1uotlQ6iAuo5NVtQvVhEUYZFZzk8ngjF+XffbIIdtfjeMt5EK71XIdY/DUV/qz7oIXNj1leE9msSKjdqz6MrKPNFa0druD524y22epc9lciQJzngV+uLUybDUxP+n5dU72TUI3QJg95RS/J10Y7mTpcKCk82kVCh3Ji7TbUhvYcKVg8b2pNQHvYNvVpVUEjXFI9t3QxWz0rFxG67OARrcXaQ729fPA1G5Jq7cmTDXMyjgwkpC0Mz90
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



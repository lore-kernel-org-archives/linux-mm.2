Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2E015CD37AC
	for <linux-mm@archiver.kernel.org>; Mon, 11 May 2026 09:04:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9521B6B0100; Mon, 11 May 2026 05:04:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 92A316B0102; Mon, 11 May 2026 05:04:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 83F0E6B0103; Mon, 11 May 2026 05:04:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 71F9C6B0100
	for <linux-mm@kvack.org>; Mon, 11 May 2026 05:04:09 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 33341A064E
	for <linux-mm@kvack.org>; Mon, 11 May 2026 09:04:09 +0000 (UTC)
X-FDA: 84754552218.13.C06BCE3
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf20.hostedemail.com (Postfix) with ESMTP id 018001C0018
	for <linux-mm@kvack.org>; Mon, 11 May 2026 09:04:06 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=G82cq8U8;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf20.hostedemail.com: domain of mst@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mst@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778490247;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=91FyDo4lvxPgkiSt2vN5y4yAYQZnqJbtxElmqdOrkw4=;
	b=ACCpMwvZCCwGC34dHUWolS+hWq+H0Ld4TYRNxyKEj2yj9hlD6uNhPY5E05YP8mKtICQ2V1
	S9MN4JGxafQmFngbAV/clNtA6jg/fWcw+HpvEZSE4pxQJo5EOVGLSEYZaqk8Wa80n561j3
	oh96BjrJpL0CPuFPJ2jn+dTZ8OGdUL0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778490247; a=rsa-sha256;
	cv=none;
	b=x4rk5B0YR373lCHRZgBGMv1hcpkV4fHrKwY9up4LLN8b/E6OhYgHj+1tqObK0GlABYivo5
	Q1Z/KFD8qaux8OBSVVD+etPxTDTcEu6K8C2RQO3Xy5OhyeVDPgFk+YFPMOaWbygI8eKvLV
	yZI13hYApQ7CSoC8P/xgy3lWfyEdyO4=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=G82cq8U8;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf20.hostedemail.com: domain of mst@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mst@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1778490246;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=91FyDo4lvxPgkiSt2vN5y4yAYQZnqJbtxElmqdOrkw4=;
	b=G82cq8U8itgozYGxboQFtoycyu2vBOs5j3ri9cnUQkhaKYNvizpMoOgNWySnvJVh0PD+nq
	ivtAkWUrofmSfnqdFNiaHeypsjkXrkT0X1E+Q9v1aIUBi8x3dfPUKV3shrYc7rZXQ0hmvJ
	q+aLUUmtxc9Dicl35t0EYKeOGc8tt28=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-99-KYpZRy98NSG4xLTLQxgwVQ-1; Mon, 11 May 2026 05:04:05 -0400
X-MC-Unique: KYpZRy98NSG4xLTLQxgwVQ-1
X-Mimecast-MFC-AGG-ID: KYpZRy98NSG4xLTLQxgwVQ_1778490244
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-48e6af7a9cdso16476475e9.3
        for <linux-mm@kvack.org>; Mon, 11 May 2026 02:04:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778490244; x=1779095044;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=91FyDo4lvxPgkiSt2vN5y4yAYQZnqJbtxElmqdOrkw4=;
        b=jPAumMTXWjY4LF/5mPaW4PYB0FBfd+T9hhj6hDWa2PWCuWblpi4U0OXoKTgPckDZst
         mUdAaxZEXOmkXxjHAese2xrBcVG28nrjomPl4DjUxJnCAtfpqBm4SEu3mRu+4lDSs8Rs
         zGZLlw5bOjJQdscPfWDWLQDXlpTNmzvHW+DbvYYuN5Av2qvzpONO/f0oZIoIbC+HToh2
         kBxAcTjp/8xhcbnMD3HVI6hw3i24tKNjX+9FGW33zdxdZ9nbS8ld52tJyKnTkSwjeMf2
         kqCeVys3vWT4Z+LWR+FzrAhxCD6iPIvK/yXIjwT4YAb2wCMWl2MBLceTBhOxMvcRPKKQ
         WQQw==
X-Forwarded-Encrypted: i=1; AFNElJ/oIdby72EpYz9jHu1JQLNhp0lx5f+NJDbTiF2CuSE/OLuHn6f1MUErGl7A+m2iT4Ife8YFrGdqUw==@kvack.org
X-Gm-Message-State: AOJu0Yzc49aK5DVRIrPFMzh6UEm2qEBltMj/9TwOSMckBQIPOVypAMJH
	+Gnut3WOjoRwa1D6i3+GmOBTd0AJgOgap0uQrF8kR9wqcnqWlOrvgvLP6gT0iSjKiqKciqmoCf4
	9wkGd16vCpgb2TcMVUS0I0FMPsuXj7dg3EoX48NYCiMFvihygaiZP
X-Gm-Gg: Acq92OE/RoppqIi9LxgacTTmP7E9MbxH45HfRuvIyndFkl9y1Frq5zqTKM9eWdbKIIS
	ZOTFY2XK49vKOIO+muPIYombsL3ZfA50O93Ej/p9za7nSXU4RON2N4cML2k0XGdN/T5wSyT/HLv
	rvSI+CJfUgtXGj1fuchxI9gsD4L04Ot4+4UcElu6Gt9LAz8RiwgeDLBwCUnz3jELgt/W0DuaQEz
	0l3bPgpgoJBzAsqBeQOuniiJDABSiAN2rdQKcAW6od7i47CWql2T/cY0wz5d170frq8un2R4m5R
	ex9gFoBBgg7m58Yud9dbm1odWPvOI+Jh6gFDF9BMVuOnFPzOscYdfhejaVXcC1Wp+NFrH32v5+b
	TrFhEDYd9g1CaFmO2VPiuA1mmD60VGkZa7DbqEXyA
X-Received: by 2002:a05:600c:4e87:b0:48e:706b:53e8 with SMTP id 5b1f17b1804b1-48e706b54famr152706885e9.11.1778490243701;
        Mon, 11 May 2026 02:04:03 -0700 (PDT)
X-Received: by 2002:a05:600c:4e87:b0:48e:706b:53e8 with SMTP id 5b1f17b1804b1-48e706b54famr152705715e9.11.1778490242995;
        Mon, 11 May 2026 02:04:02 -0700 (PDT)
Received: from redhat.com (IGLD-80-230-48-7.inter.net.il. [80.230.48.7])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-48e702f4042sm180354375e9.14.2026.05.11.02.03.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 May 2026 02:04:02 -0700 (PDT)
Date: Mon, 11 May 2026 05:03:57 -0400
From: "Michael S. Tsirkin" <mst@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: "David Hildenbrand (Arm)" <david@kernel.org>,
	Jason Wang <jasowang@redhat.com>,
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
	Eugenio =?utf-8?B?UMOpcmV6?= <eperezma@redhat.com>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	Andrew Morton <akpm@linux-foundation.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Brendan Jackman <jackmanb@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>, Hugh Dickins <hughd@google.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>,
	Byungchul Park <byungchul@sk.com>,
	Gregory Price <gourry@gourry.net>,
	Ying Huang <ying.huang@linux.alibaba.com>,
	Alistair Popple <apopple@nvidia.com>,
	Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Harry Yoo <harry.yoo@oracle.com>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
	Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>,
	virtualization@lists.linux.dev, linux-mm@kvack.org,
	Andrea Arcangeli <aarcange@redhat.com>
Subject: [PATCH resend v6 24/30] mm: page_alloc: propagate PG_zeroed in
 split_large_buddy
Message-ID: <53c45baf0b66b9ddb042377a2e060f7f88b9ad64.1778489843.git.mst@redhat.com>
References: <cover.1778489843.git.mst@redhat.com>
MIME-Version: 1.0
In-Reply-To: <cover.1778489843.git.mst@redhat.com>
X-Mailer: git-send-email 2.27.0.106.g8ac3dc51b1
X-Mutt-Fcc: =sent
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 64yNIMnetXWWTkStWW6RXdgMOnyDL7cCmHhoWP-APJE_1778490244
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 018001C0018
X-Stat-Signature: em1wu7ojm8dhhqokscfr16ay7m3sn65z
X-Rspam-User: 
X-HE-Tag: 1778490246-72813
X-HE-Meta: U2FsdGVkX18lcsI9TWlJlrUowF8HTSlLF9cCRG4IJ6dQE+mnI+fxCEACzsu9NC++5ZO6DkQIDAjL+G0MBXaJWA5w8QCztlUvL+GmEjXYcguj9wUQtLu5lZENFsZINQo8hawZkDjsJQMwyAiwKLl03piafy7jhkbfUCp0i05RjlCgM+Qyd+ZVN0mnC4v5K1fUtD6JzI8TVCwNRMVFy0R7bWhqKFe4iTysgfFpvIYR6qvs/LNSwHpQJAkX4ZeKMmFsQzXobXqOEX5pCKG58dwXggu7T4SD9gS9IYM8Y+WMbMyWyMcvmcGlwmBzT+PECGZqXazwWzoPbyQF7a6q+bM6cKNp1B83nwdmhsKZBHvREakGlW11YIldgnUwVH2p+U2N2GO7Vo0aM94PmSG/mZvLsV2MoxoiBfTKGqbpH8tl19m4HH4lbHtSr9aFywcGbhPJH0v9VX48sn5mnUb816nR4wWbYU2QouM2tmp77XrE94DblhLlYJfjaEch9Srlgpg0FqN7AjTrhhczMbs/Qw7T++/kNdbLCRWW6WMYJl55+tGy6WKtvJzpThOJM9w7cjtfzVB+XmmTL2QnFCrUkxeE+kZ/KBuOuyyF4c5gXpDwqtdqszsWZTuFkgFmvzDhv8UvIRL5Uw0xg8+tkt+t/FZNnjONfBkPy1m0pQgMV0yz4ko6ahprsApsZS1QE9ZWdx/OaOnzRjdk043vutp0CTn9yPH//aulxsnuH/WUq9kE3RanI/jkmkH0wKBD+lrEsLBKkHpRgfUY66cYXLPoMPqbp4RiSNHsIqhJq78DtixprZYmWBLrxbhB8yWC4elXCQPQvIG1gx+Rla8vkHBcIb2skBimbV9AN3jdSBED/5sAo1eP3BvoU2TihCtkeEwsn7noEjnCaF0LOaCq5pdKbWp/+yc3R6cFiDESY6JUE5PNhHbDJQG5B2skrUkohAsPf9R8JNqb0m/Q0y2sLLN2Vt4
 ugAxXoE7
 dvouszKZIUbdKY/ArZ4DOmBqi4elEJEsDqgdL/7w1WiokdFEk0FRr8gKNoFpDWtiZyDiaC176I9TZ9UXlWgMeW6hJma46gQ+yI5QFp2OxwDaGY4L99xjHLNfZnMrfmym5qZHXC7TkYLrZ96xOaqh2D/za6dl0Cw3ACIYJuCzzZ7P0voOv4lNPx7spDH3uIm1KWHrUY8tUgxcvaAXgTXufvF35E8YPE4HNmXbuba0slHcnT78CDJp7QVWhy4NwuhHZBW1qA0lZMGvITUCaCGxM6iE4+SLUfv7y3kFEBKhX9Sxxz62H88LOrTUV+7F9FK/lxHYftCLOhT0GiV+AMTLnElt4Vq6wpxzRuTvk0mH8lswV3JLclDwm25pZnlrbYzlVnwSMaEZ2MVYgr3Gl5MWnPcgvCvVwuPWvw6DPAokDQI57wa0NnYEs+U2nNTpkzl3LM1c1
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When splitting a large buddy page, propagate the PG_zeroed flag
to each sub-page before freeing it.  __free_pages_prepare clears
all flags (including PG_zeroed), so the flag must be re-set on
each fragment after the split.  This ensures that the buddy merge
logic can see PG_zeroed on pages that were part of a larger
zeroed block.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Assisted-by: Claude:claude-opus-4-6
Assisted-by: cursor-agent:GPT-5.4-xhigh
---
 mm/page_alloc.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 468e8bde7d34..ce43f5a3dbaa 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -1523,6 +1523,7 @@ static void split_large_buddy(struct zone *zone, struct page *page,
 			      unsigned long pfn, int order, fpi_t fpi)
 {
 	unsigned long end = pfn + (1 << order);
+	bool zeroed = PageZeroed(page);
 
 	VM_WARN_ON_ONCE(!IS_ALIGNED(pfn, 1 << order));
 	/* Caller removed page from freelist, buddy info cleared! */
@@ -1534,6 +1535,8 @@ static void split_large_buddy(struct zone *zone, struct page *page,
 	do {
 		int mt = get_pfnblock_migratetype(page, pfn);
 
+		if (zeroed)
+			__SetPageZeroed(page);
 		__free_one_page(page, pfn, zone, order, mt, fpi);
 		pfn += 1 << order;
 		if (pfn == end)
-- 
MST



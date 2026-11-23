Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 01D3D60A262E
	for <linux-mm@archiver.kernel.org>; Mon, 23 Nov 2026 18:18:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=tFPTQymb
Received: by kanga.kvack.org (Postfix)
	id F150E6B05B3; Mon, 23 Nov 2026 13:18:34 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E9EF16B05B4; Mon, 23 Nov 2026 13:18:34 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D3F386B05B5; Mon, 23 Nov 2026 13:18:34 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9FAE36B05B3
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 13:18:34 -0500 (EST)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 08365140992
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 18:18:34 +0000 (UTC)
X-FDA: 85467194148.09.68EB261
Received: from mail-ot1-f53.google.com (mail-ot1-f53.google.com [209.85.210.53])
	by imf05.hostedemail.com (Postfix) with ESMTP id 48EA3100003
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 18:18:32 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=tFPTQymb;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf05.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.210.53 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795457912;
	b=gxhji7vSuJVecrbCyTMFKzCZYDoFqfwGkoXUEWxpGJYnBLemtmak3bj9UKycplw0bu5zjQ
	/yxrqT+xhuPVr3awKm+4Bw0sxNZ8FWCWGeqq5WCBOKfxYQok0urKTsvbk5wqOdJBSauDCh
	dYCULfpqQG8gU3xKQgMayPerpS8Rp7g=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795457912;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=StHkoBAdAlawOIXQLWKads0UJny1AZdhexBmHXAPI9Y=;
	b=IgfN2Ead3dNAL5ZPsOAKEA58LJTslTaR4K1odfxZLCjmJ8MXlzl+aBsub1Poe7mN+GpXgl
	GUAFGHcx07kE6deT9N/uqR7z6GF7OM/jm/H5n8pNKajvNH0PqMJsXnVVucX4gloEKVGsbk
	2k2WXEgi6q5EaeVAR80EfAQvz5pYf0A=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=tFPTQymb;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf05.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.210.53 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com
Received: by mail-ot1-f53.google.com with SMTP id 46e09a7af769-847ac7ccd85so2110830a34.3
        for <linux-mm@kvack.org>; Mon, 23 Nov 2026 10:18:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795457911; x=1796062711; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=StHkoBAdAlawOIXQLWKads0UJny1AZdhexBmHXAPI9Y=;
        b=tFPTQymb0CYPLQA8WCacRpMoTSD65gF71HjUr1mC5r4mwiCz1KGV6ND9nzOHRuWoFm
         k6J8DPZLmZgyL+VNxhmCdfXIr4IpWcw1EMblAVgVVptedvH5tMZfMMC7hS2vVoWvsPfl
         q+Kf7rdJ7gi12LDL6sIu3gSaJ8kjpwi4b0lgqm+7BRkAIbZ3XvDgmtucneevtz9DpFO9
         gqKROW51Yu8fp855xRtBUKeh2Y555HH6ZHJcKaeo18mcOsx24tnbnHUiFzW/rr7k7wy7
         16lwsQSW1uIqHg8jfhX5eTpmzWwbSE1dtZqvG/960x8HCzuph7iDp7uqNLXuu1UGudyZ
         lNdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795457911; x=1796062711;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=StHkoBAdAlawOIXQLWKads0UJny1AZdhexBmHXAPI9Y=;
        b=pTbVqokRcXIXQKam7huLiJ/zl4nyY0XhR3NQrRQqVtFuOm4cMgMccgGS3c+XyL8V/o
         f/o7K5RfWlqU6Dj/pfS+Ca6Vt0wS7GLhDGrAGjp4iv2S1ankc1SomgqIznrFt8Musr4g
         AkldGNsXq5RbtnykGy4bkgD59pWm/Xk0uw5OOJDKAEuxG/HsegKm+BYfK4uQLd+8dN+F
         DFI9NYtUKvrJS0PfvRB40asLCFHa1Vye/oxLXwoilQ7bnk52u/6TZ3An0XUqNZCtFM4q
         kYTTy0MHgVq6x84oLPM1Rr2iubWDfueZB6uQtNys0J6kR3iOFPXfyVMYl6pkPmXsADqt
         eDrQ==
X-Forwarded-Encrypted: i=1; AL+hErGH1WadqlPPs+Zgl/4o3UK5J42aoz/2ogYAEsnbNmrTOfK5F2Cc6V7vd5KvGin8Rt6zsM5eezGa4g==@kvack.org
X-Gm-Message-State: APuU4Z/8KBb/PM8m03b0qU4L0SmdGwuLbn8JCgFiyZs9CSH74ZmxEb1g
	vLWl5fHzqV+q8kRQrdjlA0L8DuApEKtCb4t3Jn7YM2Be2bC3CCIi9Qfi
X-Gm-Gg: AZFdTZdN+cZyHNBBiEIeUWFjr2nzJ1puZ9lwKpvu4AXyCvD8TSx6Ac4s4HAMBzQ6C1O
	NM6uBJ14mcRoNRFplM0GLI83Zi76O+OdfBjSKlBvWi7g3UMspcmDuIO5tUO1qMU+vH674mOlxUN
	ghspejuw+S1BiT77Dm8W3qIGqordxCrr4JAt0ij9R/5DKeVE6spfuED4dTYD+EdLktVBl4f1vrv
	I9dh0nb+zMTvPcuy65HO0JK4lA2wNTQzepky1pXi8t4GbEQtfDNRjdyaF1EnbLWAwN/MRYz7DBk
	crnUYxIAXyhEpEFuWh8liU0I3ra2OOgk18vF5Ke2sjodby3ZIhZ1wA4Ei6kvKg6YrkfbrYetv7f
	4HcWTxkxl020xgEqqUGQgdtk85+l1mhzlOtiztper0SQwzt+71RiM41cFjHspwAtXXx9hplAMbS
	6xOuwcbPw3ie8gU3D7iL3+ZzAK1F8/7YqkNF310TvIDeldK2BJ9WgHWdc5KgAZnX+PVRsxAFeok
	Jb1vYY5u+6STD3kVk8ARYVdgc+tKGsf3eV589CO9SaIYwuIZwh/GVyujYMbGJCujz5EGajsAAdm
	H3SgxWjg+Wa2zVvtavxLu8hIqq4oOqU2UhQyWC9MOpGjilqHOCqAUuf8iFwe
X-Received: by 2002:a05:6808:660e:b0:573:1dfa:f0c2 with SMTP id 5614622812f47-57a0ae27327mr12433757b6e.29.1795457911381;
        Mon, 23 Nov 2026 10:18:31 -0800 (PST)
Received: from localhost ([2a03:2880:10ff:5a::])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-57a34250ef2sm10116253b6e.3.2026.11.23.10.18.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Nov 2026 10:18:30 -0800 (PST)
From: Joshua Hahn <joshua.hahnjy@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	David Hildenbrand <david@kernel.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Brendan Jackman <brendan.jackman@linux.dev>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Zi Yan <ziy@nvidia.com>,
	Qi Zheng <qi.zheng@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Dev Jain <dev.jain@arm.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	kernel-team@meta.com
Subject: [PATCH v4 0/2] mm/page_alloc: get_page_from_freelist cleanups
Date: Mon, 23 Nov 2026 10:18:26 -0800
Message-ID: <20261123181829.4065581-1-joshua.hahnjy@gmail.com>
X-Mailer: git-send-email 2.53.1
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: pdqpkieppfa3zt1fdw3p74cprsnuom8o
X-Rspam-User:
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=4.0.1
X-Rspamd-Queue-Id: 48EA3100003
X-Rspamd-Server: rspam03
X-HE-Tag: 1795457912-820229
X-HE-Meta: U2FsdGVkX19t6TelDIhjk1Gd7QkhPpk9yPCrpvu68VXY5vEpUJmlfoBlNMJ+Sw+jJhmZ/tmhD/Gh4lKPT49ULR1GpqitpMph1WGXvQ9EBwxtHWVtuo7VolZnB0RVwhtrHksVYSNKXGfIt6TkkT20eyT5EUtn5Z9xxDp78VIzcezHsKpP29WrLmq4h0k1mb+CwjP6z8Fu+ZVly5PiaDbGgnDzr9qJFtBPfsmP62iT7ZYX1cd51nDAASf7ebRSMPJaRA+2NIO6IxlrveqyrBboab4gnG9uh7L38VT4ovlsDBhrXLAABPV7cBqNT8Wqf5vTWiLoYBC939nNcxdh86avXudKjVJFp93W+3TV797Lwe9JXKr5jEZC0rrX1i+gJWEvpZ2tqiDoBr9kqy4dh6pEvS7u2Ty69xdmNNTTzjbDQEGob03zMIn9gWdnZfGjia/rr8sE8qgMT3vBlLpZjBu+16q7xmeN5fNN0AjRDlaFQaxo8bGHpbc0pNyncgduXCDrh5JbXf1rm32U735TbU3SX0j9ec5LvPnLCJQMC5rw0YsBYNVdZEbsMR9a9LGOa0zwE09oKTymrLOO5EycF/hsxwIPk8w5+zi0Nj4ayRlKqwRJxHOh6gHebzB/LLmvVwC2UnGzgIYbkIQAN3Llpd3jkWKO8c8oIzeempTcEA3eZvLIdrxT2uE1O2a/CC7rkF7F2+mHZyavHyktnT9X62Bw7JicS2L+Z0KyS0P7nm1zWHaBFEO+LvLKpE8cVHnLVO2PmmfpasRTQman2GG8O1hrm/7RW9gObi1w7XvSb9/wsPRL+H4daOaVM29Frhnln5fvBeMjuM6S/ZrYCnD379duSQr+xYAegi/eW+IM8vBE7ij5LCCsTcrpDgT5CqgySAmxVhYgl5umuzOmWYxzY9GdNzEGDQj7J1FAv76d50A9GhSeOCCNp007YW+O5F2cWsmSVJpgr1qIoGbqYr6Uxah
 uYstvOOE
 47A/gFJEA091eJ7+8mrm30O8BwzNn1WmsEEcU6hdl7gUcWsBxLcfI8w3xKiFdnbrE+1SxA6tngoKSonh3T91uaSIGdnCNb5esOOerGbj0+VNRRviCs6RjLfftyWwRXKW4nmD6hpr2Hwm5MyjnJvuL1PVoqKfNNWpQKg5lyG8VEwGToZDSlWDTHYLWBsmOUuwnxvB4ZewuOkZzkJKiLyzsD5uml9tpefXB8Pb/QY15eYRjgdFVKJyjpagYKFWhSZ+ZHow+vIq+4MVazpYOTY2qWYmsnu7Sl5bDFJ8CEEjnOlX9TXj3n2WKH5kmzFrdbLMhFBz1sYYy6HlfkgRbJhsnLgUHvsOIuufStdZ8HfJToKeF8Phn3062m2FJ9SQy7iDoy0jFbINxgvdzF8HPcyuwf/pubuJyojg1WM6SDEwQB+Zm/wGlLHXI/MIprHiMHRhtBhL128GHmxlCUGT0CZbIt8UonsPYVhfXf3MroDl9CDcoW/a5waulp2c/2uMGVNQkD+VGJCaY+ewGy18uMpMmH7u7TkQLr84ViGtHEnhP6TxafVpI8dazojdrN6Yp0xDX+BzW/GmrCylcb6+yEaqF3oUKn+vKLfoXiTlYDJZO/5BSq28oA9GISS01rlu3GsELr0VXEQyYWqqRSCodQLK8booCCrDeTIVGc5fJAQQISIuZP74ZcjrqLLF39b3nj8LyPP61rgc+or+rJscJKsrfb7g2nJ4gOby8yR7BeQOJPs3xASljteYvKNJbWAKRtRCvb9JZdpoVOIXAImj2oV7Sa51aK9vHWqNq598wodNs+iKQ0Bc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

v3 --> v4:
==========
- Make kswapd_wmark_pages() static inline, as suggested by Vlastimil.

2 cleanups for vmscan and page_alloc code. The primary goal is to make
get_page_from_freelist a bit easier to read, especially after the new
kswapd zone skip conditions [1].

Based on the latest page_alloc/for-next branch as of 11/18/2026.
Notably, there is a dependency on the aforementioned kswapd zone skip,
677dfdfad244a "mm/page_alloc: only skip kswapd nodes below their kswapd
watermark".

No functional changes intended.

[1] https://lore.kernel.org/all/CAN+CAwNsqWpPoag_XE6bxbrfi6m71xw1NS_wc3h_ShZjNspSjg@mail.gmail.com/

Joshua Hahn (2):
  mm/page_alloc: move the kswapd node skip check into a helper
  mm/vmscan: consolidate promo vs. high watermark checks

 mm/page_alloc.c | 47 ++++++++++++++++++++++++++++-------------------
 mm/page_alloc.h | 12 ++++++++++++
 mm/vmscan.c     | 11 ++---------
 3 files changed, 42 insertions(+), 28 deletions(-)


base-commit: 3a99594e62fce8c646e8aac01d38af16d6833a40
-- 
2.53.1-Meta



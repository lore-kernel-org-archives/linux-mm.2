Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D0161CD6E56
	for <linux-mm@archiver.kernel.org>; Mon,  1 Jun 2026 11:40:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 253B66B00AA; Mon,  1 Jun 2026 07:40:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 203E96B0183; Mon,  1 Jun 2026 07:40:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0F2F16B0180; Mon,  1 Jun 2026 07:40:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id F1DD66B0343
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 07:40:14 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id C285B1C0B12
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 11:40:14 +0000 (UTC)
X-FDA: 84831150348.15.816212E
Received: from mail-ej1-f73.google.com (mail-ej1-f73.google.com [209.85.218.73])
	by imf27.hostedemail.com (Postfix) with ESMTP id 0A3F840004
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 11:40:12 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=Dggjuo4Z;
	spf=pass (imf27.hostedemail.com: domain of 3m28daggKCEgtkmuwkxlqyyqvo.mywvsx47-wwu5kmu.y1q@flex--jackmanb.bounces.google.com designates 209.85.218.73 as permitted sender) smtp.mailfrom=3m28daggKCEgtkmuwkxlqyyqvo.mywvsx47-wwu5kmu.y1q@flex--jackmanb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780314013;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=6Wl48l2DfPZ0MppiMhPgvatUF8ANRh8YkT+xizR8GSs=;
	b=PwN/uPdV3LuezA6MR4qDeoZzWVMZS3XmLbr8XN0skUr8wfyhG0x1yojw3QyXC4tHuNysIA
	7EIjuedYQe+/9LBt2guBgZkc7gOgRn+mzblCFPgTzfLpeuC9y+PcWSHNguZziI7LJbsdZ+
	smK1h49CSgGzi3iNoGZGXDSAfEmd6nU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780314013; a=rsa-sha256;
	cv=none;
	b=4jrRQzLjIqePOtfLb9CFuCkrPY/SKfloPQlYyyXff8PdC6Ch2CKtPhvwyCnFqf0A48Wv7U
	mCtrnO2AiqGdB7FeF1KPoGEJGoPGpRXVSFxdEipqQrPSk6kT0stlgB+CaYhFt6RFK4VqeW
	SpAz4mzrMDdwwwhh66Glt6owFxhDw78=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=Dggjuo4Z;
	spf=pass (imf27.hostedemail.com: domain of 3m28daggKCEgtkmuwkxlqyyqvo.mywvsx47-wwu5kmu.y1q@flex--jackmanb.bounces.google.com designates 209.85.218.73 as permitted sender) smtp.mailfrom=3m28daggKCEgtkmuwkxlqyyqvo.mywvsx47-wwu5kmu.y1q@flex--jackmanb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-ej1-f73.google.com with SMTP id a640c23a62f3a-beeb1713d20so3251566b.1
        for <linux-mm@kvack.org>; Mon, 01 Jun 2026 04:40:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1780314011; x=1780918811; darn=kvack.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=6Wl48l2DfPZ0MppiMhPgvatUF8ANRh8YkT+xizR8GSs=;
        b=Dggjuo4Zmx6nFtD5uuh0NQiv0Wlg0Wp/1SqxoteR2cX6pomhCpyNXD9rZeM9uhk2ra
         nrzXPlzFLWUKLxwrViC+/4ZYoUdtlMNwUraiOAiYxxD87pGggydoOzAi++IHeRGRVC4Q
         Wag+fLYRm1jtpH/TEpDv7mIBXU/BLL+GhSJ2G52DTzCu/uhWJzeIAd8XK3DDqKd4RuJn
         dXxVrlGj6GnqVrm7I6u9zFmndqiykavPX0hTr5WIhT7Rjmn39EwF23W085PPbeIRwuFM
         QxohszLAXxpvTDv9SF1t5nhvv7tnRFpDJ4LbsrgbcX5oV6/nrrxInQFBawVqgT+jhNQr
         dx/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780314011; x=1780918811;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=6Wl48l2DfPZ0MppiMhPgvatUF8ANRh8YkT+xizR8GSs=;
        b=K0DivaNsWUcMtmK91PUyfp0LYpmLOr5VxkcB2h+V/wmNzHuJP9h1IoV7B4/rW0XRjD
         pkzdTKVa0qL8QNHrReqL1FkCFJFZ/0JR0Yh6eaBwVqc9+dYVSG0RVJDpsOq/H2+3evH/
         7c+FwrEjvRk7UtHMRyn1RExmqZcuFYg//UJ2Z/mi8hmL39cO+LtI4BCR0d5b70g/GL1E
         gCfl8mkYjTl5HwCfHQGUvHfIjWZ1YI9TF1CAtJaNnK1q65pxp2E2gJGSrTbRu8T+iMxT
         C9Oot5Qo11VYYqcUyhEFy5ZRybg4Eec22qldmAeUuBvUlhFZYYwLXiz/ZUkpMmNyaDxl
         tBjw==
X-Gm-Message-State: AOJu0YwFPlMR9oq5jGd06hjd/+6B2ZdNcHE6/KAMUE1JjI+JychiR64j
	D1X8w1Pu1VDGKnyR8FE/J81B0M9AxH2/vIyR6sYRBNg/OpMFpvfFBacK6FVV3rzdXsDs+MW/0yC
	zAYDGa9wu85pmVQ==
X-Received: from ejbrh6.prod.google.com ([2002:a17:907:20e6:b0:bec:2b20:60cf])
 (user=jackmanb job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:906:8a6e:b0:bec:c237:4ec1 with SMTP id a640c23a62f3a-becc237541dmr245766966b.13.1780314011057;
 Mon, 01 Jun 2026 04:40:11 -0700 (PDT)
Date: Mon, 01 Jun 2026 11:40:09 +0000
Mime-Version: 1.0
X-B4-Tracking: v=1; b=H4sIAJhvHWoC/x3MQQqAIBBA0avIrBMmKamuEiFhU81CDZWIorsnL
 d/i/wcSRaYEg3gg0smJgy+oKwF2n/1GkpdiUKg0aqzlHTyZlOdsOJOTNjhHPsumXbTGrleNQij xEWnl6x+P0/t+pFQ+8GgAAAA=
X-Change-Id: 20260601-zone_stat_item-comment-45d660892420
X-Mailer: b4 0.14.3
Message-ID: <20260601-zone_stat_item-comment-v1-1-f452dd91d5eb@google.com>
Subject: [PATCH] mm: delete stale comment about cachelines
From: Brendan Jackman <jackmanb@google.com>
To: Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Kairui Song <kasong@tencent.com>, Qi Zheng <qi.zheng@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Barry Song <baohua@kernel.org>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
	Wei Xu <weixugc@google.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	Christoph Lameter <cl@gentwo.org>, Johannes Weiner <hannes@cmpxchg.org>, 
	Brendan Jackman <jackmanb@google.com>
Content-Type: text/plain; charset="utf-8"
X-Rspam-User: 
X-Rspamd-Queue-Id: 0A3F840004
X-Stat-Signature: ai7crm4a7deh5otot8twjthuutx5dxaw
X-Rspamd-Server: rspam06
X-HE-Tag: 1780314012-75883
X-HE-Meta: U2FsdGVkX1/HXRcrv6fUPyWRg9xwRUQ6WPhZdnXyGPKynDQBPYc7JLRAJEHFze4ckeAXlWG6em4MdbQwnQbJDNeRlk2VUSQ4cscUe7Xof0iESDQ0Bd7ZtRfhloglXGGvzluVS+OcKWO8vJpJIWHLyyy3Ofu3Zj8UGjbFN25Z7zey9cag0HgBk+FJqwcyAuisDObfZOks3frIzPynNR1GbhyDtuMT9IlJ3lGYVN7YMiastjDV7kJpAqWmnu0qzPMRjZI8+Sdtu6fp3tOs7gsIGO9O7gtkEGPrALxa0sH+MCWrGAXKvkxdEqKE9Pfbz8or1tT1zXcpgNDtUxp5wYVq7OSfHFAQ42rNZCX4uvP3m2sV5VpTMKrfSE27u24OUAaLt7z4aNK++FGFM0kOLD81UJuAsi2juFAURMn27zaVcuJWCo/W7bU0JOpGUnN4Vwkg+Ek721Ut+lje+xWvMklez2oaO+p3CA0eP/6fgXWaVmAVo6IUxPVVeRUn4/zfCur2upbDY++yPyLceEThZgzo9ZKXON/Hi675aMOVfVyCWFmQNdFdJzYt28tOUdi6EIp1F9VeVTTMDMZeBODcSx/EccbdY9uLZchurJszObz6u3TVOI9ANB5bbsoSTX+dhn8gBoNk++AT3B+w4b3f4g0k3VLzeQsWGly1bnwYCmPH9VlFHFFsRuuxGJXMyfVkhUyYNrS/nZEv4JVVv1weHhxBDSzjv2Q60yQkX+zWzHiRUEAM27wUa8Aa09SwR+7nkewcvSWjZbq+xXrorvLJiUy9ygexESoFbw9XrvkMoHIPDM44/UBKAFELWFjz3z0jM3CINvKN48TrPtzUJhj4JsCU4BTxDN+3yWRYfbznYAt6kGgC+Gebzqcs9Xo7ZNVVCG6vJ8axXGSUXurIjytQ6b6AEzYOxfBbYIwpgVcDBtXPoLe/RoeK5Ci0uxpjw9zVNXOxfXKld5muM2mhvZ/fmf+
 FBk4Unpd
 3BeCDseXh5esyRxrB0169Plg5U89H498N5Kj9geA4OmRFi/3G2Z6Tl/wlCN6S/H6rf2P7ZNRBBVCx53dYSGN8hoRhPP6YZhjnykU4Iwr3N7N26/wtElkGH6KhOPGbl3DrXQpUlSQnBVjvF31Oh01dx5/Bz/ACSzfohLskxX67W39hPE5Jzu+sOP6UC0f8T1KOyo4Ew26WAVDzCwc5HqbIZmlqeTzdRKZ32vg8BpjrUeNYasoqVVFSvQoxFzFoP1qas9WGQBq43R61tkpWk3tBeihZQO3YB5HOlRRbmZURiZ+yE+2JGXmcetb79RN1aAElygMz5jeyZao2nR69eSUkLZl7fybqDYBORxBa9SNOJg1+gMuXzyQ96VgUm35SUBQJ1XuPpV4EvvoSit8GNYLipyE4g8VzQFQT1/RhUxW6gmZAWUwYpgKxPNofl3IpA4wrBkkxC/LH+vWOh//uBg+3Hs/epsZw1YOH9rfMFO5Fv3tX7blBT7oM3j06omKDyl/bF6LVFlLKvah9Dg543AOp7yWdXBcg5tpXy6DQKGymOvrC3U+mqp9T9VQJDtY544Z8CJx/PpkbL9gn6ThMWA+OYB8XFoq8uNrL7vQHtmiLmxqlAqHevdupdLhKI+oX95ajvM0+aJTZpcSht9E=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

These comments have been wrong since commit a211c6550efc ("mm:
page_alloc: defrag_mode kswapd/kcompactd watermarks") added
NR_FREE_PAGES_BLOCKS. Since nobody has complained about it in the last
year, it seems unlikely these comments were particularly useful anyway,
so delete them.

Signed-off-by: Brendan Jackman <jackmanb@google.com>
---
 include/linux/mmzone.h | 2 --
 1 file changed, 2 deletions(-)

diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
index 1331a7b93f33c..e308f5ac7950a 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -214,7 +214,6 @@ enum numa_stat_item {
 #endif
 
 enum zone_stat_item {
-	/* First 128 byte cacheline (assuming 64 bit words) */
 	NR_FREE_PAGES,
 	NR_FREE_PAGES_BLOCKS,
 	NR_ZONE_LRU_BASE, /* Used only for compaction and reclaim retry */
@@ -225,7 +224,6 @@ enum zone_stat_item {
 	NR_ZONE_UNEVICTABLE,
 	NR_ZONE_WRITE_PENDING,	/* Count of dirty, writeback and unstable pages */
 	NR_MLOCK,		/* mlock()ed pages found and moved off LRU */
-	/* Second 128 byte cacheline */
 #if IS_ENABLED(CONFIG_ZSMALLOC)
 	NR_ZSPAGES,		/* allocated in zsmalloc */
 #endif

---
base-commit: 4aedd91eef75addec6eb2702aa0d94625d01458d
change-id: 20260601-zone_stat_item-comment-45d660892420

Best regards,
-- 
Brendan Jackman <jackmanb@google.com>



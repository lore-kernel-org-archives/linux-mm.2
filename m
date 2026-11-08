Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3F4C2606A31A
	for <linux-mm@archiver.kernel.org>; Sun,  8 Nov 2026 03:40:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chrisdown.name header.i=@chrisdown.name header.a=rsa-sha256 header.s=google header.b=MD4IFTgU
Received: by kanga.kvack.org (Postfix)
	id 363D26B05B0; Sat,  7 Nov 2026 22:40:58 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 314BF6B05B1; Sat,  7 Nov 2026 22:40:58 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 203A76B05B2; Sat,  7 Nov 2026 22:40:58 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id F0DC46B05B0
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 22:40:57 -0500 (EST)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 60328160119
	for <linux-mm@kvack.org>; Sun,  8 Nov 2026 03:40:57 +0000 (UTC)
X-FDA: 85410550554.04.DD3FFFB
Received: from mail-pj1-f48.google.com (mail-pj1-f48.google.com [209.85.216.48])
	by imf17.hostedemail.com (Postfix) with ESMTP id 8B92440002
	for <linux-mm@kvack.org>; Sun,  8 Nov 2026 03:40:55 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=chrisdown.name header.s=google header.b=MD4IFTgU;
	dmarc=pass (policy=quarantine) header.from=chrisdown.name;
	spf=pass (imf17.hostedemail.com: domain of chris@chrisdown.name designates 209.85.216.48 as permitted sender) smtp.mailfrom=chris@chrisdown.name
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794109255;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=ZXPOl0YSd6S/HY373Pp8Ndi01/j4+eSRlC/6LdJKdNo=;
	b=W07RCAo1Ii1aGaNMFwnEl25PDb7GaJEMaMpX3xmP6RTYVS+u80YKTx+wqjxAjoTlTsAapa
	zKCNgJ1Y5K4xlTVb//0srPXwHuVG3/SEBz0GL0/JfIiYP+SAGZN0Wnl+lQaFBFTd5WT6X/
	CL0UMdS0Gdv3Abxs50cZUAnqdha7RSc=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794109255;
	b=Iu93Jy0i8pUg/sgrpbiapRT38IITadJYfYXxglzwPAXM4X4i3kgEMSao0XGOJJzmBJBX9a
	nLES2ikXyhOUvn8luEJBWywTRJrpI9gDlnas6j5+xA98LeUxmbiC99ACz8dw0MbokqL04i
	ArKwuMkCElqe5r8wnIwIUEEwHydrZ18=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=chrisdown.name header.s=google header.b=MD4IFTgU;
	dmarc=pass (policy=quarantine) header.from=chrisdown.name;
	spf=pass (imf17.hostedemail.com: domain of chris@chrisdown.name designates 209.85.216.48 as permitted sender) smtp.mailfrom=chris@chrisdown.name
Received: by mail-pj1-f48.google.com with SMTP id 98e67ed59e1d1-3ad2b3b1c02so73453a91.1
        for <linux-mm@kvack.org>; Sat, 07 Nov 2026 19:40:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chrisdown.name; s=google; t=1794109254; x=1794714054; darn=kvack.org;
        h=user-agent:content-disposition:content-type:mime-version:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ZXPOl0YSd6S/HY373Pp8Ndi01/j4+eSRlC/6LdJKdNo=;
        b=MD4IFTgUwIcvC3i9h9K2vxzgvxCe4x0k6wHNpQgMy6c/n4EgrHY0bm479bzEq3xiOW
         KoucfwM25er/SnqN8c/xs+qLSzAo9D4VhokEXQ6S4D5p78sQd0UVkzqzLeoJl+EMVveF
         OOgqp6C9jrR8GkR2aHabpzlv5wxs949cZb+vM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794109254; x=1794714054;
        h=user-agent:content-disposition:content-type:mime-version:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=ZXPOl0YSd6S/HY373Pp8Ndi01/j4+eSRlC/6LdJKdNo=;
        b=pctNI7CJWqKGO3U+26UtD+Nu8iyZEuvUReAUoT+LbgXpkDClXdvR16HPVnfU0O5jYA
         N8aSyLklMNkybPjT/VhWcy8wsesxLrWMl+Yidpf2KKx3zgJlcSjGauyOt31VBqM9o4li
         pRH0aSZyPZkBqAvKl24/mCiCe2Z1QwPXuuSx2sKAhm+YzUEZeTqhotFdAavIlys5G4JY
         3gTWHiZguX2uBacJa0aHAduY2yR0YgKf5iUKCoc5GO5ArhgO0KnaEaTapORnmmo3FIoA
         CvVgLRXGKTbeludANEYWiFat7DQhXBWRTP4li7U5LEN21UDqOxEuhQ0jX4YQhn+tm2bN
         nRbw==
X-Forwarded-Encrypted: i=1; AL+hErHVDpsfPU2bDsp/s+QJfZSkPBR1bFfejiUKVaJjhFIOOUM5jYrcgXQthUILYsrOt266EBDETpWRYw==@kvack.org
X-Gm-Message-State: APuU4Z+4QW15NxQ+A3iiEft1kRl24hElrzLNuqgx/RpCTOTdazyz6DTo
	/aGfdhTmX5gBRFMMrjpe8xd+fRVkHwuraRkPz7r2ZZwh+FZZCk0ZhW1r/h1TKqkrsYE=
X-Gm-Gg: AYBFou2I9KfHbrtGmT5yuwtcPpbdHUuASama46o5e62xpokiXg9nMcU2i8xSYV6mSAa
	5ClEu7kV/HUjyF6PNWkK5qh10eix0+vpKQ43ab9F+tTFwIatMOD0OGMpUv5fELpxCr+aqRDEWWK
	25XYxsa8HVAR+q2+eXMR0jjgRfME0BGwAp3sRe3Twis7it02Wvm9tvrNpp10hIo1Rn22oXRcOw4
	nIAKoMmBg+cnhzyv4KXoATVob4wKrsgrKNdj07eIonYjXxZTXk2EAnNRwkUiOV8evuQA7YFXJMp
	/qtnO77Srt6kbyKrZnVwmR3Mrc3G1KcRGWVT2jIGiYHhz1o9+9GaXlYiqRPvBzayFaAIL4uY1iy
	EkSj8x1kLlRRxAFQ23/doyYXx5eQ/D8w4wB2wYsTA/VTDaJfU24dzZ+L9OIywdlYgHiwGJVQd8q
	ODe4b+0GloX9MrLH/wx7F2OTT1xSO6qO/2Nj6BdsnkkBZtcUx/hoTRODHkwE/G1ocqrnZE4euK9
	tfbS5tbA+4oMtvlEJx2Q9HZsklpqAPNRrz1y6PoeMHx1a/h8MVHsXgF7xf6iBy4WyMPJkMrapKw
	wO2gpufykOG81DfbsHNtrkL24MEypt6VasVUbuqoUWtV6Xsb0ql2DOxzs6x9sNoWs+QMLwTBIpH
	MQQuAXW6e7x7M+BQ4SLWxILncVbVXIuBvfadjRtT9wcoMwWa+rLtwjdnx5ARhetafqOoRw3NJCp
	VYEWK//e4hA0SUi1MRhj2nd2jT/Y4+q6mWPrvALu2/boOTh86pt30S
X-Received: by 2002:a17:90b:1e48:b0:3ac:9c37:942e with SMTP id 98e67ed59e1d1-3b12d5933a0mr344498a91.49.1794109254287;
        Sat, 07 Nov 2026 19:40:54 -0800 (PST)
Received: from localhost ([50.175.87.158])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b1058d3310sm5374560a91.15.2026.11.07.19.40.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 07 Nov 2026 19:40:52 -0800 (PST)
Date: Sat, 7 Nov 2026 19:40:50 -0800
From: Chris Down <chris@chrisdown.name>
To: rppt@kernel.org, pasha.tatashin@soleen.com, pratyush@kernel.org
Cc: graf@amazon.com, kexec@lists.infradead.org, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, kernel-team@meta.com
Subject: [PATCH] kho: Don't release incoming bootmem areas when kho_init()
 fails
Message-ID: <au_vQhHAcJbkryXN@chrisdown.name>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/2.3.3 (9073d26d) (2026-06-12)
X-Stat-Signature: f17boroq6i4qg76tquhew9h3wdxgc3w8
X-Rspam-User: 
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 8B92440002
X-HE-Tag: 1794109255-851454
X-HE-Meta: U2FsdGVkX1+VQmGzuUqzUbwLhbICNXj4V5mZ7sFqaJLhwc0YHfig89tf5ab+4KKH5Q8OcGEkg7aWIyO9MtsmLBKzQKx+VCptuNSEO+6LAWlNV4MO/7UXvw+vXWa1yuiPV24y5DjuzAW479Su7HjtxqX7RX6pgS6SdrOTi9WIZFPK16WGc1x66cgdCD1HGCfPaBlxpyzAfFAFeUctvLME8dED1gfx719/DioXQ7Euom6gNtLPlbSAhgF6XVEMsZghQvOPOaxiq/1yhhzhs+w7W/vrEevk6n+wYhLPnMb5KMYjksitLHvT6DAtBRIkV2e3h4tNtK5HQLjiKg11uV7XZs5MBHFmxo0V+bnODv/LxbxBaVn+ZzbBBx69KIPteFdMKjC5/YuHkGRuUyPBhbhkd02L5c66tEnvT4oeAwU2/Hz7GCA/JgAIoi3+xWABeL0GHdjPVVPg8AeiPiZHJVueive+m6Jvm8r7Hc5cAkkRoqt0RaSGoRYE2O95PdtjzN5SR3xUc4FsFuz0YVj7GQf9lkgH3vxXEs/1xvcqioPZU3PMizj4NcA6Ntedig3NxaiUIMZlXY8JB3Nv0aiXktcBACddaklDYPfO4Pe7Bgqlt9M7Q087wUtDReCoNfDf/Ew7HblFty0sL09sf7j+taOVHnGaQd3UcTCo63BCKEp2gy8WgsE9M1vPDePHR+ly128Va6id7slKoG3L08ct8R07vpbOnlRAI3dWhpSzvstUSG6gF8O/e1TEez0qL5LVmFWgvOVchgeHOJVpe1MnoFzv62l43DciqlbMezFN9gBQ6qE+4gX10dU9mHDApoT9S+IFq1C1Vq7Kyb0e3gz5XYOLefzarnfRh7yxhnnLTbfGEQFGOavro75GT7OXTSuf+YLbRXx/uBwPIVNpmDVfUkSvp08vf2wN9ERXcFjHZOHgPTR5+cai32A68SfAxJPxlgMNWBO8H8OXx8D59Ezmeah
 uOTE1gto
 YrXg7UUToWOAKmdSqsw5S8nsbt/otTO0tReEo/kWX4q39h+moSEWfGKg61WuFK4pVRtQcRSKlYIAUXF1zQtymjXqZJOl6g7CFkxI1q2tmNNxMiZv9g1J8B1ujyFzhNYt6baIjZ44UqqiiuiKCIa6OUteHgdaE7dayhff4AJJJZ99W6Lr5LWZPflo94aA6mYSwzJWeNJ+MiTrlPzb6SWCKp3w4BvzZRs99F2Uc2ALIqblsp6TNlsPIhc/ljQhV8iVrXh5YbQaZnGVQErcD6RacKsAPtp/2mceFeu7JVlM/06UlXjpAeC8iFETEGJWSgBHFAwms2qYcIFhbdarkvqCHhJi0UhjCbeAuPRiivIIWLhzCCclnCouTvvA20wDtMSzBE1yh29TRkIycSfWmbWodMCSEbfaJOEyTGeZDf5Zw9jUO5cd7KLFSVBl40LBDHc6r/bKHg36BiLCtyJzWic1yo9XrOD/J+bDjOjjBmF6WsVD/VnaeDzSfrhbOyb9ejPOFpegQJGfM1eF9BsF+EHVvQ3LuFXpFymKdVCke
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

kho_populate() adds the incoming bootmem areas without reserving
them. memblock_free_all() then hands the remainder to the buddy
allocator.

Unfortunately however, if kho_init() fails, err_free_bootmem
currently frees every area with free_reserved_area(). This can free
pages still backing early allocations or free buddy pages a second
time.

To fix this, let's only free the areas on a cold boot when
kho_reserve_bootmem() reserved them.

Fixes: c609c144b0e8 ("kexec: add KHO parsing support")
Cc: <stable@vger.kernel.org>
Signed-off-by: Chris Down <chris@chrisdown.name>
---
 kernel/liveupdate/kexec_handover.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/kernel/liveupdate/kexec_handover.c b/kernel/liveupdate/kexec_handover.c
index 6f1f55fe3181..a566ad6634d8 100644
--- a/kernel/liveupdate/kexec_handover.c
+++ b/kernel/liveupdate/kexec_handover.c
@@ -1899,11 +1899,13 @@ static __init int kho_init(void)
 	kho_radix_destroy_tree(tree);
 err_free_bootmem:
 	kho_out.fdt = NULL;
-	for (int i = 0; i < kho_bootmem_cnt; i++) {
-		void *start = __va(kho_bootmem[i].addr);
-		void *end = start + kho_bootmem[i].size;
+	if (!fdt) {
+		for (int i = 0; i < kho_bootmem_cnt; i++) {
+			void *start = __va(kho_bootmem[i].addr);
+			void *end = start + kho_bootmem[i].size;
 
-		free_reserved_area(start, end, -1, "");
+			free_reserved_area(start, end, -1, "");
+		}
 	}
 	kho_enable = false;
 	return err;

base-commit: fa4ad798f6f681031775266044ba1b0cf3c670bd
-- 
2.54.0



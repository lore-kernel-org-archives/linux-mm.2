Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B625FC982E6
	for <linux-mm@archiver.kernel.org>; Mon, 21 Sep 2026 14:39:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 899BE6B009B; Mon, 21 Sep 2026 10:39:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 84A746B00CC; Mon, 21 Sep 2026 10:39:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 73B1E6B00D1; Mon, 21 Sep 2026 10:39:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 47B4B6B009B
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 10:39:49 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id C423F1C1B3D
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 14:39:48 +0000 (UTC)
X-FDA: 85238028456.10.425C613
Received: from mail-qk2-f12.google.com (mail-qk2-f12.google.com [74.125.230.204])
	by imf23.hostedemail.com (Postfix) with ESMTP id D35FB140012
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 14:39:46 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=FimO1JCs;
	spf=pass (imf23.hostedemail.com: domain of hannes@cmpxchg.org designates 74.125.230.204 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790001587;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6JeVamdoCa9AA0LbUgrFt2azIreJSKrfNCLuX4lcnQY=;
	b=opnNKL5FSK4DL8mkbE1TA4TJ7pqrcfyXz+hWykYrndhzjLtQWv+RE/YUwa8OjOLgy67BFz
	+eWZs5eG0EF8NqOeGmJZ2khgisTJOXpEQ2pnamr2Zc7iOEQqDnpXWa3QMOp3IrLZNavBB6
	K8DrJRxlrNhd1iTYSQ7pn7akt/sEJiU=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790001587;
	b=gzyOH1KncmVDOpDqIw15G9cHEk23bSg/572W84ZIJ41AseOkf3/H5q7YsHkqhHzA2aznvn
	rgWsIpDoALxHuilAwGJEGJOisfdFOwXRrZP5Yvf3qpUqer8sXoiIwzXffS/7DEMNMUEnvn
	ICfGM/G1FeCmUThGK16Q7719fqhyhVY=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=FimO1JCs;
	spf=pass (imf23.hostedemail.com: domain of hannes@cmpxchg.org designates 74.125.230.204 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
Received: by mail-qk2-f12.google.com with SMTP id d75a77b69052e-52fb7692a57so38425121cf.1
        for <linux-mm@kvack.org>; Mon, 21 Sep 2026 07:39:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg.org; s=google; t=1790001586; x=1790606386; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=6JeVamdoCa9AA0LbUgrFt2azIreJSKrfNCLuX4lcnQY=;
        b=FimO1JCskwJXmChT3cfspHWJUZKhUe9LD++/LjGfdLIQHKmbS381XZqIQlQ3+JaN7Z
         SUzwanrJWq0Yax4mc6W63W30bjwVkXVZkiJIGLdNrC3jly+LrA0G5U2YSgGa8Z6ULzsZ
         ekIe4XzfLlL3uCWT6Jbr8tTqc/armnLMHRoR4CDb/jbusH0vuN4DS0IAKVmO6kjF0Wvr
         fz/RZUaFfU5sb+os5PfgZH493bXqCruqJF50vOi+WZVTm5PLPhfYo/z1nFnbg+TIDnSA
         +odP998eYCqbYXQuhHII7HRaWvARHKTGs9pXnjzg4pR5d7Ww062pKrWxr3jiyAp5ao0E
         0iJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790001586; x=1790606386;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=6JeVamdoCa9AA0LbUgrFt2azIreJSKrfNCLuX4lcnQY=;
        b=s0WIJ2sSLX3vGGmXHaIMV3vdhh41MClr8lswZDCzPIeJwMdU+hpxS1ntekLpaIR3Aj
         E7yxCxMvReuaUnCNPUAa7Z5eUXf2lryGUtUPpxHWc49k7CJGueSVMkG19ytU6diH6Wxw
         E54Jue0ZgvyCEJa8JJDXUq0K4SQX5B9c/r2dwwtYV6FVV90foYhOHdEMuGJKZysjMHy8
         yKj+7X00aS0AYPZ5ob+5uBdUYV4wv9kZnRo6z4JGAwqmTKX6Y1sRTG68saOrWMJyQJU/
         Kdfq4CysPozMv16FzAv3pUox7dq6WrRsxvCEqPCzcKkqy5qhwQMYrEy/Ow+gAI0f4hjM
         AQ1w==
X-Forwarded-Encrypted: i=1; AKwUvBzevJqGdU2ytEvFwoFq1jVBSC3W+pul7htZxtBFpRfbeAObU4+Lv991dFqQC+zy/wyYYjXwTpl87Q==@kvack.org
X-Gm-Message-State: AFuF++km9Q7uM77SdpNyPOivXLUjeb6jVXnC4t0XS2K8mMz688q8YbDk
	8QZDynvQHdJHudwhx6BC3cnHhPu4DDfgfB25Ux5QcUTL4JPScXeClpheTlC2qQUSb1g=
X-Gm-Gg: AYBFou10JH8B1+ikSVh0mzuIJ5KWxCZNi6WAXzfFzKnPTYrOfo0Ds+r2Vc2Apryp6IA
	qODVrakgaMBx1ccu5/ORfDgL6qZdfAFuE+V4AeSyxWKzP7RHe+9TuLbQAuwOWpsYNVWDl8OY0lx
	h1hOMMEsZ7tBgji1UFbGNd+ZBGM3DSWBXNKjyTb3wJKeK3jL2K5MZ0ldOOuXYvRzIwrC4DQvLeC
	UxwRJfWqo/anoCR0CqECOtXp4ygeCSD0w4kcL1RIbnwLhhElolun/0utfJuVTzJYxwsPJf3FVAF
	+SBcOZKj6nNhxlYaherUf8kb5W5AxSqlp4QototW951Oqj64jhaRUz38oHlyjNmJ1/y+O0rC357
	W+IHCU9AQ4F5aKr/1hKYbeJzUTAaednnMKFXkFFjiSTn1deYvCuTyZuenvzRkdCKG+AMaOb83QW
	V8pLGvZT83U2g/Q/I8pPJiEFk/PUUfLYq57etMPqPQPJZHoPiwH3aZZ7QkSnXlvRSGu0mi
X-Received: by 2002:a05:6214:2422:b0:90e:8cae:7fe9 with SMTP id 6a1803df08f44-913fc94a61emr8317866d6.24.1790001585748;
        Mon, 21 Sep 2026 07:39:45 -0700 (PDT)
Received: from localhost ([2603:7001:f100:500:365a:60ff:fe62:ff29])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-91260aa2065sm69381076d6.42.2026.09.21.07.39.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Sep 2026 07:39:45 -0700 (PDT)
Date: Mon, 21 Sep 2026 10:39:43 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Cc: Matt Fleming <matt@readmodwrite.com>,
	Salvatore Dipietro <dipiets@amazon.it>, akpm@linux-foundation.org,
	abuehaze@amazon.com, alisaidi@amazon.com, blakgeof@amazon.com,
	brauner@kernel.org, brendan.jackman@linux.dev, david@redhat.com,
	dgc@kernel.org, dipietro.salvatore@gmail.com, djwong@kernel.org,
	hch@infradead.org, hch@lst.de, linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	linux-xfs@vger.kernel.org, mhocko@suse.com, ritesh.list@gmail.com,
	rvvandan@amazon.com, stable@vger.kernel.org, surenb@google.com,
	willy@infradead.org, ziy@nvidia.com
Subject: [PATCH 2/2] mm: page_alloc: remove ALLOC_NON_BLOCK from
 ALLOC_RESERVES
Message-ID: <arFBr22V60BMmVpl@cmpxchg.org>
References: <20260905174239.99e31515fabe220aa7d8e6fa@linux-foundation.org>
 <20260910114602.926944-1-dipiets@amazon.it>
 <aqQlUr-1h07G8JWM@cmpxchg.org>
 <8d6a8a63-4adc-458a-b548-a47bf5ff8eb7@kernel.org>
 <aqq8pWI0u1IZNWHT@cmpxchg.org>
 <9f415dc7-adad-4161-b20d-7c3173f50ff3@kernel.org>
 <arFBJdYaRx_iJNDA@cmpxchg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <arFBJdYaRx_iJNDA@cmpxchg.org>
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: 6pebgo3hg6ju4geturyfe73exd8eqy55
X-Rspamd-Queue-Id: D35FB140012
X-HE-Tag: 1790001586-308829
X-HE-Meta: U2FsdGVkX1+ThydM9aWAfDwAwuG78wih0gC3AQBt849qZGL8z97UzBLI03BpJsiTc8ADE5cLXSPdIEJN878RA8oarhUiDfOyb5X+hwd9Esrj1ADOBJYzdtvmnEXTBaIaebSYHOomR8gSESBZ4YMFiN37hBRbsxhJR7qhRlnc7+cmHdC69cAFr721coiB3q4vQ/vCHN2wZ+fig2qeatA1K4leGwszdtErNt1IP6dw9cB3GApMH10r9tGYXVOQTNsxf6YVma5jXak2Ey9R1Jd757THyZ/YMH8IjJVxSfUi57d1xD7ZtqfSQ33T0+tBsS1IBaI1exY63gkWE2sgBP40yxZlWcNY0VuApn3kL715tqpgXpPEbDibcnMnB1J1w4K24Trk1t9eojiK/5TBviQ5qEKj8WSzrhnb1DEsGn0eAllbpuqD2fC1KVX9Njx20YtGlLjiotXduhlZk8jz9RxipfmovHjar43n0/SceKjO57u2b2XGr0sKWxQ70X/V7gqTk96sNfGKSrQwamUoSPF+FBBwvCavjAi5xJAV0UY5LECHFwqRxuug3P1uOXlhG0uAWfSbDJgF37ECqRlara9+Umtgb6EmdUdJIxTjmkX+KaqbmnvjEiuBwZi/1cQUhPyTAA6XzpxpEmJgiU4+Cpb9bA3NZeh6Ui3LwxW4vMJagaeSnnQMwvXwoKA15+ZV4uP+dUUylHmJqENCCCZIsUTSkxebcM22bkObv6JAXwgdrPE4W4Bn/HaWwVXilQfZ0MRMVqoAfbTi61/U1nOspAIeF/QPAR3HPhiZuUmmQUFAhor5P6FoOgx38LTWkfdmRjAgqKXPC4sLFAAxNuE8EMllv2vGXV/enyedi0U06ViiEBysS5N+1gvfOoT2YhcASZTyYYEEwYkyDOMqV7wGuDgdsZuz3sR0drk9m6uDWNbBvwV2s4FmzVSbvSipe64ZOoOpvmEiI/7IfkXHekSykZr
 aw8gpZtD
 eNNQAKPCPEkMguBwj7UI/J5lXHpJ/egECQoWDJkyxvbyY3LrkHcgf5E9X2Oh73tAtiukbLs+hFbfM5qGesQe6L8OYe8kwsrtDs18E7tv0lCCUeiOcpSYpjJFO4dLz6Lk/+kPogtNAlz+rT5OnkYSBJUTw6CanG6vP3uZcTRxi11FUrbQopvlRhfI9HJy32ru6YyJbwphyBv5/w3JCHmB1cChgKUPez5xBBF2VfJYw/llKp021yG0eiqyVehIrsAbAFAdsRGhxrlIly1c+A/G4Nm+aQ7YG1YavnGlQCS1gHijbJkDyvyHnTqSFQY0A8IQrEQRCjry6FehDKnaRF6f5YUrwrOB0mZUoA4BUY+MHlrsluTrIDnbZ97jpb6ckY8jcjckRl0dzxz6kP+zRjM0ODb8ASxFxCEw1Yp8TpXYVdPz80gRmWR9uMwyWSTxkKRxElkYocJm1ElbOwVUBawvZg8VGrEQsP6eiiVKtgOMyRG4UqC4bwXBDcn6itRhVyVXuXauj8DB2rcSqBDujEWA6JH9Jt38BIFM6ZCLOj6+0fAJX2nTGpnytQ50oSDOidjcFu7Bg
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

1ebbb21811b7 ("mm/page_alloc: explicitly define how __GFP_HIGH
non-blocking allocations accesses reserves") stopped handing out
reserve access for ALLOC_NON_BLOCK on its own: the extra 25% below the
min watermark is now only granted on top of ALLOC_MIN_RESERVE. But the
flag was left in ALLOC_RESERVES, which produces something odd:

With the ALLOC_RESERVES match, __zone_watermark_unusable_free() doesn't
subtract the free highatomic pages for them. So in the slowpath, they
get to consume regular blocks below the min watermark by the number of
free highatomic pages. The highatomic reserve is capped at 1% of the
zone, which on any decently sized machine is a multiple of the min
watermark: GFP_NOWAIT can drain regular memory to zero.

The user-visible result is brutal hiccups during bursts of GFP_NOWAIT
allocations under memory pressure. On a 32G box with an anonymous
working set, swap, and a filled 290M highatomic reserve, a GFP_NOWAIT
burst drove regular free memory in the 28G Normal zone (min=60M) to
28M, 0.8M and 0.6M in three runs. Swapout failed to allocate its swap
table, reclaim scanned 13M pages to reclaim 200k, page faults stalled
for tens to hundreds of milliseconds. The machine survives it, but not
by design: direct reclaimers eventually fail and start unreserving
highatomic blocks, until the allocation succeeds or the reserve is
gone and the OOM killer runs. That reserve exists for high-order
atomic allocations; here it is destroyed to bail out a GFP_NOWAIT
consumer that was never entitled to the memory.

Remove ALLOC_NON_BLOCK from ALLOC_RESERVES. With that, the GFP_NOWAIT
burst is stopped short at the min watermark. No direct reclaim, no
stalls, no failed allocations, and the highatomic reserve stays intact
for the requests it exists for.

__zone_watermark_ok() is unaffected, since everything it keys on
ALLOC_NON_BLOCK is already nested under ALLOC_MIN_RESERVE. Update the
flag comments accordingly: ALLOC_NON_BLOCK just means the caller can't
block; the reserve math belongs with ALLOC_MIN_RESERVE.

Fixes: 1ebbb21811b7 ("mm/page_alloc: explicitly define how __GFP_HIGH non-blocking allocations accesses reserves")
Cc: stable@vger.kernel.org
Assisted-by: LLM
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
---
 mm/page_alloc.h | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/mm/page_alloc.h b/mm/page_alloc.h
index ad89f83d1dab..c8af79decbd0 100644
--- a/mm/page_alloc.h
+++ b/mm/page_alloc.h
@@ -32,12 +32,11 @@
 #define ALLOC_OOM		ALLOC_NO_WATERMARKS
 #endif
 
-#define ALLOC_NON_BLOCK		 0x10 /* Caller cannot block. Allow access
-				       * to 25% of the min watermark or
-				       * 62.5% if __GFP_HIGH is set.
-				       */
+#define ALLOC_NON_BLOCK		 0x10 /* Caller cannot block. */
 #define ALLOC_MIN_RESERVE	 0x20 /* __GFP_HIGH set. Allow access to 50%
-				       * of the min watermark.
+				       * of the min watermark, or 62.5% if
+				       * the caller cannot block either
+				       * (ALLOC_NON_BLOCK).
 				       */
 #define ALLOC_CPUSET		 0x40 /* check for correct cpuset */
 #define ALLOC_CMA		 0x80 /* allow allocations from CMA areas */
@@ -58,7 +57,7 @@
 #define ALLOC_NO_CODETAG       0x1000
 
 /* Flags that allow allocations below the min watermark. */
-#define ALLOC_RESERVES (ALLOC_NON_BLOCK|ALLOC_MIN_RESERVE|ALLOC_HIGHATOMIC|ALLOC_OOM)
+#define ALLOC_RESERVES (ALLOC_MIN_RESERVE|ALLOC_HIGHATOMIC|ALLOC_OOM)
 
 /* Flags that mean GFP_ATOMIC */
 #define ALLOC_MASK_ATOMIC (ALLOC_NON_BLOCK|ALLOC_MIN_RESERVE)
-- 
2.55.0



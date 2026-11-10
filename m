Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C575D60A3807
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 15:14:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=AO3iXKYB
Received: by kanga.kvack.org (Postfix)
	id D49C56B05B1; Tue, 10 Nov 2026 10:14:16 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CCC9E6B05B2; Tue, 10 Nov 2026 10:14:16 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B94066B05B4; Tue, 10 Nov 2026 10:14:16 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 807806B05B1
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 10:14:16 -0500 (EST)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 7B9F440760
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 15:14:14 +0000 (UTC)
X-FDA: 85419555228.05.0133EAA
Received: from mail-yw1-f174.google.com (mail-yw1-f174.google.com [209.85.128.174])
	by imf09.hostedemail.com (Postfix) with ESMTP id B162014000C
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 15:14:12 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=AO3iXKYB;
	spf=pass (imf09.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.128.174 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794323652;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bcKBtRZaFb+mZfYAGiwpdRY8hHzgqYhO1XHVeJRGJgE=;
	b=vdJFxjUDcopEp920ekAE3sYJl6fah4UBAVJPH39kSp2TeMk19cqPRfkP1qfRUANgBSf9GZ
	QkyLOVFuktOPeSEg1jFe2/WrGIdAt+orbBC1ylikQsDtbBGiIvL9+ZOFhnGvKZZm3Lq2LF
	qoPqpyWmSuaAlr7eyCENJ+7995akQcQ=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794323652;
	b=hMwxfB2N4O/YAmD/YMe2an6ly/HMGBWv5ToYN5XE1GjZeVR9xjfXFIMoFVvc4EJd9MDq0E
	caZvgv8lh1UqdPkrBV9isd4QaeKqcHDRqFZFsABIRSdxZoQwGuwYRKxC6qs6+ppl8lvEwf
	1Rfg4o9l1Zt/7/DnpB7rFQijd09eFvg=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=AO3iXKYB;
	spf=pass (imf09.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.128.174 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-yw1-f174.google.com with SMTP id 00721157ae682-8b309147589so22989697b3.1
        for <linux-mm@kvack.org>; Tue, 10 Nov 2026 07:14:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794323652; x=1794928452; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=bcKBtRZaFb+mZfYAGiwpdRY8hHzgqYhO1XHVeJRGJgE=;
        b=AO3iXKYBotHFerHCklwn8eUZWBvif3ejd1SdGdxt++6UF4izFYAYWq60updqom1jP8
         FecrMf/wceUIGCav9REwJ8+QHj33W4Yx19WXy7jEExrmXNdK3klt/T9awVRgXtv6sOWs
         sdYE0kNq8uloba0aRFZmD6vxlFavTMY3S9aKinS/gbie9ujRVliyhU/16kn2UQeV66Hz
         DejwQDAfaK2wsrlI2V1sx5ZpOVc7YW7mRyc6Xd5VIq9fcLzhoHJn/x2rum33bUXVxoT4
         xuNK49aafBhLZsu773ICvrd5Ff5EGbi/4hbyRbPTuv4fMwJ2mSpzA8N2nXfnfcCxLeew
         cllA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794323652; x=1794928452;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=bcKBtRZaFb+mZfYAGiwpdRY8hHzgqYhO1XHVeJRGJgE=;
        b=iq/rDfnmWmUH6IhKTYWnCH194Wi2McqSCxR1OUI/16/LtJ0iwm+mDRL3mvFp2jbv9J
         YzZNQ0sGFtECpC0O+mgEemAynBRORvr9ZU4seFec5msk8X/hnyks3BhqBONcfLKTg2Dx
         3AUi/v+IwbpOIY2OE0AxCusm71GPJRhGNn1vPxM8WkNERXWPdw0Fcz/i1HV5V03ppCZU
         ufGVTopXfWzjh3FGrCu6AbQ6hrgEmoX0vG2Gq5HFs+At0CtMpaLSZP2sZBR1GpDZOgLz
         pDHFGH/cScS+/6ieCgx6MpTLlPf4LSpI7hENVHpM1Vf9JZZqoPRF5I2BvMvimErI/7K+
         /iIA==
X-Gm-Message-State: APuU4Z89UQ7lj8vv/QLJYjS0Suwja9vzEw80UVPGt5+xFuPrOdrvlcdt
	FdcYC2+iNqmU06QNPpNwRVAUhXGYARpwvAmpnmrtSm+xl/9hGEl3agIfAotLs3zw
X-Gm-Gg: AYBFou3aCapni3Z4PQn8/1gzbpPJtnNPWbA3p9c8Jo+NtBH3TJ5C16zyZTPQ10fhbjL
	E6mk9SzlkdlTI+yORVkVXihaVbOjssK/or0+3enekZkmAMfJaEhwDw1zjrXN2HwPYOed23YrZs4
	Qv5ohP87ldUw8y4behKFsNoZGUbKU9F+ZblLhBFpDZVU0aoOc16oPFYK82LArYXY/M0jNQq/n/v
	YsaZQWqvUtB28AJ3j7xqH4Bf7BpAR5lekuemrng7oUDuaCz7VsFglG4WhRSITfC+LqI6qmKBcYe
	uyw1Ick64rG2vW36OgvFI3qU+K2KUYdlaikbd9nnWcPkwLWm/jrmbiep7B1ucr851WLk7dzuV1Z
	X9fQKcrZGDy/kiKHnXFnN9SSEqk7q4QPq7qVzcumYITUSYaxsrcVDGhbNA7Lu/WUOM3M5Y4XrDu
	/spQ9phXbcKvJZQYpBBfHtlSkevOjvGW2M1Ygn+iCAX+te+uh+Ii9UAZsYQZgGsiDoEEY87nAIJ
	vaxT0FdS4R88gnkWCQ8wiXp6w76Pl4A6P8+AcXDBRnxPWErEwQgIbi/a7gqUvcD/Yaq7OF+hg8Q
	d41a6ntPx/Ljx5o+q9C/zjI0ccNZ9l7eeZL9IVPXXu7d5lpRX627aay+NM2VZkANBfFFJRQBRNj
	3lRC8GPjDIcKsARuPSTxGA6TVyhB5kOiTnRwCZQ==
X-Received: by 2002:a05:690c:660a:b0:8b0:e7a0:ac5b with SMTP id 00721157ae682-8b39288d821mr18964047b3.1.1794323651688;
        Tue, 10 Nov 2026 07:14:11 -0800 (PST)
Received: from localhost ([2a03:2880:10ff:45::])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-8b39343d4a6sm21481757b3.37.2026.11.10.07.14.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Nov 2026 07:14:10 -0800 (PST)
From: Nhat Pham <nphamcs@gmail.com>
To: linux-mm@kvack.org
Cc: akpm@linux-foundation.org,
	hannes@cmpxchg.org,
	david@kernel.org,
	mhocko@kernel.org,
	qi.zheng@linux.dev,
	shakeel.butt@linux.dev,
	ljs@kernel.org,
	kasong@tencent.com,
	baohua@kernel.org,
	axelrasmussen@google.com,
	yuanchu@google.com,
	weixugc@google.com,
	baoquan.he@linux.dev,
	baolin.wang@linux.alibaba.com,
	willy@infradead.org,
	brauner@kernel.org,
	linux-kernel@vger.kernel.org,
	chrisl@kernel.org,
	shikemeng@huaweicloud.com,
	nphamcs@gmail.com,
	youngjun.park@lge.com,
	ryncsn@gmail.com,
	sashiko-bot@kernel.org,
	stable@vger.kernel.org
Subject: [PATCH v2 1/3] mm: vmscan: allow writeout of swapcache folios without anon mappings
Date: Tue, 10 Nov 2026 07:14:05 -0800
Message-ID: <20261110151407.789960-2-nphamcs@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261110151407.789960-1-nphamcs@gmail.com>
References: <20261110151407.789960-1-nphamcs@gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 5m4tqxpk17wuobrcxw33q1s4qpycqxxz
X-Rspamd-Queue-Id: B162014000C
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1794323652-652940
X-HE-Meta: U2FsdGVkX1/st5wXI6BGfpzI3RFzGIJE2gfk/2WCFnulVwiN4C7TqZPiplYtSEC3+lAcyvAOaba9DRWKG0UC8yPwgS2S1OWy74iaJIl7PKT+a3+R8GHCIr4HgKp44n4fRcXjXYrXzCa/1l8MjK1lFDgZmHVZ1GAmJ3PbwvPV7e9m0hAo/UR5P2hFj7VGboaV7USFdmD/XIwOq0qS0I79/R6noKraDDE4GFfCj8nwgUNNDGXs4ncFsy+ApbOgc8yb8MLyu1KzeQGQdFto8YAQiMwH0y9oaT27DtuQ14RfZmvbc5EL2J6FzVBZ8PI/n3WN9JTurAv7YU6OQiO9zZsNcHXeYi21BJFIFcOcH9QYFKL1CHDKylPHzS6M37z9yJ1mZdDH8v/1UViufBxo4UPjDobN5jQ3PspjCTCZ/NidJbFS9AIvumVGJrfI87bb686En2AE43wkaJUuH9olrP8wa2vm3F+4+vDE7iqsCNm0WGY8756QarYLLDOhqJzw2FE1SKbdb8GdtFlJa2m8SD7fjyXpC7VDrBKadcY6WvdWoGCmERcY7W5WaUINoFQ16DzhUHNmV/LIPUEs8+vrOEc77vB4PX/t6ChfpHkW4YnmtixCA9xJNpzTsM/rXpNaJX8xdi2CsWM0alFo4FLpEJ4f6VPGI7aACUgE0d1y//MUoYWLZeztDgT0utFSC2F2DxuL/x0K4xB8wqwmNmgudmD3YgE5ZqqSchME5JiRWOI27McrQyrahfNLAaISpaT4iUgtL/btZ6fwCtLkXdMM+XcTRLCz4w5fsrhJrzowPBZhLAYzD8NxP5DlmWzGu8jPJKXD4s+SkeGqWnnpS+S1qWpaCLYrYV8WzGC5oW02bpTneQ+mpSus5cRZ1CJDfnpnr0E4gHWiY8pWlk24kOJQU4uuhH72QZehyIAM9x8ZrnJIaEMwhtY9hoNWBWl6Ajfd7+oSix/mGvXrjX4fjpO/jI2
 IMlH+gLC
 jIYlVHK12w5L6iuj1wJ03T6tLeOXXwbQUmPWOZv6UcC5ot7AerdXxJjPCG76FQ1KlBx/Ua3XAYAgMTvVTHtTksuCHs1Ywrn9OzxRV6WvNgWRUQqMsOTb8X6IOIYYPd+0fs2I8s7YRgl00GOKCxjMwdt7pUmlM7CLnW0try/D5gZGp0qAQe5deaAu7DQQZqmBl77o79nnaSoIupb45OmhRgFtK9TSt5/9TtHNLoJnheAuErBsfIk4IRy7/x30JJxSVSiP+udPbFUG5xLu6V9IUQcEmhmDIItHJeUXiA1QILe3i0mWL2RVxTbwBYKPgBZQ1r8ZMMFzTLVqF6jWqw2ZxFmxVjj07nEqDRbuSulySAtIJ89Svt3ZMwurDRDzHOJ6ZL8FCCK9B6Sin52gQnxPj4QZwstD006ACeJfF1Qbq58Iz7D0LT039uTJWF5cX3tGjtbSg6J4vwguOfBY0fcrCuITsMpDeBE9b+Kac1Gg6MtHZCkJdGMktJ+jLdyYa6tuSOdmX5sE9sbDVH2I=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Unfaulted zswap readahead folios can be dirty and in swapcache without
an anonymous mapping. pageout() rejects them before swap_writeout(),
so reclaim cannot write them out while their swap entries remain
referenced.

Allow swapcache folios through the filesystem folio check. They already
have swap entries and can use the existing swap writeout path. Anonymous
folios outside swapcache have no mapping and already return PAGE_KEEP.

Reported-by: Sashiko <sashiko-bot@kernel.org>
Link: https://lore.kernel.org/all/sashiko-outbox-181078@kernel.org/
Fixes: 84798514db50 ("mm: Remove swap_writepage() and shmem_writepage()")
Cc: stable@vger.kernel.org
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Signed-off-by: Nhat Pham <nphamcs@gmail.com>
---
 mm/vmscan.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 061fbd168d98..96201eae0ceb 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -607,7 +607,8 @@ static pageout_t pageout(struct swap_io_ctx *ctx, struct address_space *mapping,
 	 */
 	if (folio_ref_count(folio) != 1 + folio_nr_pages(folio) || !mapping)
 		return PAGE_KEEP;
-	if (!shmem_mapping(mapping) && !folio_test_anon(folio))
+	/* Anonymous folios outside swapcache returned PAGE_KEEP above. */
+	if (!shmem_mapping(mapping) && !folio_test_swapcache(folio))
 		return PAGE_ACTIVATE;
 	if (!folio_clear_dirty_for_io(folio))
 		return PAGE_CLEAN;
-- 
2.53.0-Meta



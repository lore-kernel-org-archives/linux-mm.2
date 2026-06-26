Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AA1E8C43211
	for <linux-mm@archiver.kernel.org>; Fri, 26 Jun 2026 18:22:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 962216B0120; Fri, 26 Jun 2026 14:22:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 911D56B0121; Fri, 26 Jun 2026 14:22:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 801146B0122; Fri, 26 Jun 2026 14:22:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 3F2596B0120
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 14:22:36 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id ABD3A1C33C8
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 18:22:35 +0000 (UTC)
X-FDA: 84922884270.25.066500B
Received: from mail-qv1-f44.google.com (mail-qv1-f44.google.com [209.85.219.44])
	by imf25.hostedemail.com (Postfix) with ESMTP id CF061A0004
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 18:22:33 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=Ymd84ctr;
	dmarc=pass (policy=none) header.from=cmpxchg.org;
	spf=pass (imf25.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.219.44 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782498153;
	b=BOJtDVvoJhI/evogjMtoRPskAxc72FC06GnlbdReWN4jnktOgeIVVHt2KAK9oF/QnQMF/6
	l4G6bVoK/4QmiAELrt0XHnoMYolafqfxAEg9mW1bhEXiFFwaBrZyGg/BOFWKoFjx1I0zdW
	yv3/dhENxOhb4njIi5c1TUJDA5QQfRQ=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782498153;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xNnQvDlpVbdSBzQMZkREgFp+pXIUFVREki7kHSxzZi4=;
	b=rHxNsQPEovnzExjwTSDdrBOB4wUsL+E7mMJ89mOmdNrIV3y7a3XW0o6F5ttROxPbUrOqWT
	ICOJcc6fRi9w56EYzjMWORup7ft5c6sFzyygat/WSx+1RrR+9ViYlrtAMR/1C9dZlsSN0F
	IjXStKFjPCBXcABjI7vAi249qu0XU84=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=Ymd84ctr;
	dmarc=pass (policy=none) header.from=cmpxchg.org;
	spf=pass (imf25.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.219.44 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org
Received: by mail-qv1-f44.google.com with SMTP id 6a1803df08f44-8e608e02bf0so11452266d6.1
        for <linux-mm@kvack.org>; Fri, 26 Jun 2026 11:22:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg.org; s=google; t=1782498153; x=1783102953; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xNnQvDlpVbdSBzQMZkREgFp+pXIUFVREki7kHSxzZi4=;
        b=Ymd84ctr3wv6PT1MSxMm0Z1jHZ8R9sJKORJ3h8fbnn255g943gxt+X6wIG0W+NK323
         dX1jowa0BjJOy61H/OipofCQCcs8GdSHi/CArsUfPOUSfq5N0TDx3lExkqsvmIjFjBEb
         kJ5Y2jUSpr2EtJTmTNlZnTXMps30I+7L/GAnJiEHfFU5SxUUsAilF0N0IClTyNGCyvxB
         eOLW5N9Z7nr+1WRZZASAxxzGFFfq40lbsN4YXSz4vies2TARoc1DH0dZjxEzN8bMQ0S6
         suZYzjVSgHHl8UBT+TbfhDHKaLho3cOK/142GeyQtfYa5jxM5f8KFUGpV/A+sIX9esqE
         OGZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782498153; x=1783102953;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=xNnQvDlpVbdSBzQMZkREgFp+pXIUFVREki7kHSxzZi4=;
        b=LlCOLabob5qucwasDoOI/MzwGzrU3evl28oLa++0RcIlFlGEsVeYEaLD2Hm7zWiyeE
         U+e/12a1/CyQq7VwjxikAFUx4VRViv0GAtYLKTMHuRlwAZVLl/eEdKaIOPjm7TyPMSTB
         1NDlwnXUuT/e93A3+T8uf4eKyvKkbwfqwY14cA/tjRDleDSJitP2bjf7UUS5gy8z0wZi
         kbo7aKp78U0sFkEXMXJiopwriewwW6PyMLQ7IimCP/COSmzBoZw+NFQRRQYtM3hGcwrZ
         g1sbirA4aEZ1MM2QSQsBlwYiAv/KVA488q5Jf11wV5t3aFIcx1fTFQfE3Rh90Ape9x/m
         RzIg==
X-Forwarded-Encrypted: i=1; AHgh+Rr8CBGlANNgZBnDaw4eTXhDLLubjAOLZfOoqvaLa5iGHqbNoTtjDDQv1eSyRJDEZHBRLk0pvD97Bg==@kvack.org
X-Gm-Message-State: AOJu0YxmU+/GsMagADHBnjhibICZvchQkAonrTADF7h3eU5E0czG6Uve
	H+C5AMJU1ekhvmIEGe0ux8G7kSF2W72LSyqZ0EeOm0smyUs18/iF/QQUlEPUINCfHaI=
X-Gm-Gg: AfdE7cnUXQvTpH5SZu9DAqlHY2bhYSamgBUo/SmjT+HWk3du3uUgEUWkjkn0QH2jtK/
	MwJkxGclZkhjHD1jDtTy83zTt09ZG1Wz9X7DB/HEFCe3ipwK9dCqM/BZhHeAsyDPpmZ/gSn0eeo
	rNzSaS7jYfUzqrTAPLJivxaWeRgcM9YdEYd8Iyk40psGg7Q20dnCMtx0opxy3Y4JC3wuBNyb9wB
	pbhK00C4wuEI7XFzkwdaC2SPw9bqva+q1ukp5npB1nEN8KtdDuiLzpLr5gT7wyTPXtRdtbBiPvh
	nKT6QrlNfCNuGMK7aY+RSqOr/VoFhc3qkyW5wdNGzqqkOgerAFb0EiB7/o2sNWkUuDJXgzaZHF8
	75Ux3eM1Zpou90rBTISGLUCgqiwhdF1GQ8Y96UIHWMuvvdSj5agXD5NxBuwkUjmEt/sRqZJQsd8
	hKP2U6OK4ynp4=
X-Received: by 2002:a05:6214:40a:b0:8ca:2559:8886 with SMTP id 6a1803df08f44-8e6d88d9babmr138437776d6.13.1782498152835;
        Fri, 26 Jun 2026 11:22:32 -0700 (PDT)
Received: from localhost ([2603:7001:f100:500:365a:60ff:fe62:ff29])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-8df81fcb55csm217910836d6.34.2026.06.26.11.22.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 Jun 2026 11:22:32 -0700 (PDT)
From: Johannes Weiner <hannes@cmpxchg.org>
To: Andrew Morton <akpm@linux-foundation.org>,
	Vlastimil Babka <vbabka@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Brendan Jackman <jackmanb@google.com>,
	Zi Yan <ziy@nvidia.com>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Mike Rapoport <rppt@kernel.org>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 1/4] mm: page_alloc: __GFP_FS lockdep annotation for direct compaction
Date: Fri, 26 Jun 2026 14:21:17 -0400
Message-ID: <20260626182215.1107966-2-hannes@cmpxchg.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260626182215.1107966-1-hannes@cmpxchg.org>
References: <20260626182215.1107966-1-hannes@cmpxchg.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: CF061A0004
X-Rspam-User: 
X-Stat-Signature: onc86xs199qwod3irytii96aygyqc6ox
X-HE-Tag: 1782498153-139719
X-HE-Meta: U2FsdGVkX1+Hooekg3OdsfMJiDt4fcYE1NBizSAt/jZ/ntc06KPoL1uxUdoNidaoFVIjig1rrT10S1WvTXnxqGlvY38+R03HCQTUdESlfr54V46rW2f3ivJUs6bsk7eU7iX9+97eDtCSplGg4WKM14/zXIpkHNKV0SOwtZUYAjVEfAt6znfILtzOlFbPSZPyYMOpVmlCITs6SPjlSZu12hyKQUCZb7vQGLBH/fUzZ3aF9Ig+FWw3KoBJ+3AXhKtrmyDz3m1+5Py/6+Co930oYx+h81K/IgG9yYkK66KgNkXlX35yowpcnjHvOtZ2KUozRM5O9MBHoxTP/6uy/r0asI00664pWNgtzpJtr+RrbH9aPtXMv2dm6S+vETI1F7DdLXezc6pbGM3vL9bOAXxBm7WURP6AHMo4nTgDDeNDgbcRyw4av9ZW5x8feLPgKxczIZestTG6r9REWTdOlzazzTysgygJq/j7eBuq5hiWcslKaxH/MZ5sCWsTwQvwdV+Y3JpKYUFMrGnW91zK2DIZf04mCbuOFDQM+jMF0+CzraZfSbrynWmPgXJQ1srDzvdRtDa2kAQOQ93YjzFL8RgSiBnwtGO0iFw+nF/lK46WrkVUvdSUDhJdId56zldETmvhT3gSlww7PBK8za+SMAzk4j9cA8riN/z/hE8CiGHn05zjm72asfVhbXvaewSbGcOiwtZ1bYkkUkmoqHXMvL0zhSarKLC1G4gHhInezgQJ7N5AcvCtwXRULlgIRLbHGPTJxyy7R484DcT1kLvlGU074keQxLvdchdgHzPnr9iUTogvrhoJgukugvnXdmA0tDLS4zGB2aChgMd+viL6vUOWwLD/0U3MxpvPAfecR2otreXWstbzTJVR7zhzqQz9anJVTZdy5Qf08eEvbQ/gz21x0dY2ys0Kk6L+rCLLyssq7UEvLz+SjxWMkiQtV31R2EGvjAXkwhWlih7mf2xijO9
 r7tyzFI8
 M8hhaYOyknr0LdQrIrNP5VVjc5lwBJ83y4aRAC7dF1fQjFy23l6DBpfR2XRgq9+Z+AtCZMbIUpPPgaeqBOxxNd88R6du/toyzGka/SpjiScNl5pUioBJFtYsCOJIFiDN6TyDLM/yE+M1CabrkzsL/p3ycOs6fVuNI41aVryCEI7xezxuIQ5AcbDe1dmmgWvGVkK9B8nyccj3bap7alKKebGATpwqE4lW1KFMVf+AMF3EsHuPqgUit+msd1EKnDZIuYqTilZbL8CUDsGOWeXvsDUlpu31v3AyXqWesP2ftCgHFOwgLjzEtB6a6pR8h2bSZEKadFiFUfT1Q+xGNQcgx1e0rhsjFqflg9b8ZL6FjwYYMrWTodnHmTapu7onoDATRKaCF6jFcMdGb63KYSiYRihNjFJpKa7+SNIaz4kmuvfTxPVidm9/i88SHpQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

A subsequent patch will have some order-0 allocations participate in
compaction under defrag_mode, to stave off extfrag events.

Since this is a sprawling expansion of entry points, and compaction
can enter filesystem paths, add lockdep annotations that catches
__GFP_FS passing errors.

Direct reclaim has had this annotation for a while, and since reclaim
and compaction are usually used in conjunction, this is unlikely to
unearth old bugs. It's more about future proofing and peace of mind.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
---
 mm/page_alloc.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index ee902a468c2f..cb422505c6ef 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -4152,12 +4152,14 @@ __alloc_pages_direct_compact(gfp_t gfp_mask, unsigned int order,
 
 	psi_memstall_enter(&pflags);
 	delayacct_compact_start();
+	fs_reclaim_acquire(gfp_mask);
 	noreclaim_flag = memalloc_noreclaim_save();
 
 	*compact_result = try_to_compact_pages(gfp_mask, order, alloc_flags, ac,
 								prio, &page);
 
 	memalloc_noreclaim_restore(noreclaim_flag);
+	fs_reclaim_release(gfp_mask);
 	psi_memstall_leave(&pflags);
 	delayacct_compact_end();
 
-- 
2.54.0



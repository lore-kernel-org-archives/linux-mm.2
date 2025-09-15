Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B1341CAC59A
	for <linux-mm@archiver.kernel.org>; Mon, 15 Sep 2025 13:41:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4FDB28E0015; Mon, 15 Sep 2025 09:40:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4AB9F8E0001; Mon, 15 Sep 2025 09:40:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 300988E0015; Mon, 15 Sep 2025 09:40:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 1FFB08E0001
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 09:40:53 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id E044AC062A
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 13:40:52 +0000 (UTC)
X-FDA: 83891595144.23.BFA8656
Received: from mail-lf1-f43.google.com (mail-lf1-f43.google.com [209.85.167.43])
	by imf02.hostedemail.com (Postfix) with ESMTP id E29A28000F
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 13:40:50 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=EVo0N3pv;
	spf=pass (imf02.hostedemail.com: domain of urezki@gmail.com designates 209.85.167.43 as permitted sender) smtp.mailfrom=urezki@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757943651;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7tWr/JqVgOvXu/F9fhJXup17MiB9k9fkyyqujUfoMQs=;
	b=GswBeAxeb3pZUN6nLgXP1Hu7g5yLX7y7iV2csuWfnif0AHkzQ87LqnVE+TJhBI4ztlWxLG
	NBp0LmJ6n0Br3b3EZ3tF7auVjOm2bgM7nC/95axsZbqaXnEkb7qNqZikD5h0HXC7Xxlx1M
	R0Cv0PTZsiUO8fe2mAn9yEMv2p9th1A=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=EVo0N3pv;
	spf=pass (imf02.hostedemail.com: domain of urezki@gmail.com designates 209.85.167.43 as permitted sender) smtp.mailfrom=urezki@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757943651; a=rsa-sha256;
	cv=none;
	b=tDQlNlEaEvnndadSkGRzCER1ttpv7WGP2rot0m59K583zCX0Q1dVc+hAYkhF47NIOMvauM
	QM10FDyuiy98swplnJ5eE/qYZOUVJg4Yg33a/h9QWvfMlL3nxK3Kw+8HfeEamfAzDmxec0
	es5tHqkAQbhFHpdYBZQHRzaV/v8onQk=
Received: by mail-lf1-f43.google.com with SMTP id 2adb3069b0e04-55f720ffe34so4781344e87.1
        for <linux-mm@kvack.org>; Mon, 15 Sep 2025 06:40:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757943649; x=1758548449; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7tWr/JqVgOvXu/F9fhJXup17MiB9k9fkyyqujUfoMQs=;
        b=EVo0N3pvRo4JxL1Z+uxmlq+sEWPV9cKuwnufl9tUKrfpjgnoIUZmzF0fcn12OCkvZE
         CCtGmPcz+ZaNWvnwbNty+uL9I8oeY6+/Pzckg9fdn4X/JzA4FwdBbEBnRXht2eEvA3K5
         as4lE9gphuJP91KIXdxwid87forR6ErylaCHQmptc9LoqDIofXa5fU1d1KBqRubMlNwH
         Dntg14Lk8mR+uOOJIyJ9ofA+WciuIykyrTyDJ449AUWdwaVd7/9blKQ12fatdVyeXMZv
         HzQRpvFzFXqOmkhBc2jBGghJb1IPW6zAODEheUZPYoTqxxM3LwwgZNtGjbrgoKRH7qWd
         AghQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757943649; x=1758548449;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=7tWr/JqVgOvXu/F9fhJXup17MiB9k9fkyyqujUfoMQs=;
        b=Vk1JOq8hD17K4EBeVdOgIJVkIMtZzVCEEqVz8b3tTCQo4aVjIJ5WsUdmFkG2/b6B4X
         Uf6fTMhG39XCUzdDfW1+QecGPerINPM7mdbqRSIbott3X54h9A35sKasGndNhQc+UnW8
         gOGyz5/NgeYiAtQ/YubMFzG01hnO0WiRpEjMbBVripGjAQg1Nm5lFG95+CriMZu/wzLa
         UuhCRdEtD3AQs/w4P7yeHrVX7UHsujCrN/zEHqe8jy67j0x9cTGY/CB0gOsM6EIcAtM8
         FsrJ6BiFUkSWZ4RvkXJvQI/qz0y6DCsXVb8nnAXLyEBbxeTJY89XLN+mscsnQ5Lrvc03
         YklQ==
X-Gm-Message-State: AOJu0YyhOQFg+hwPmqyJC/Q3Qklxm2Yj3+rv1KkA5R3V54ie/nsEu87U
	QdvCrlCMx1ozNeZhzACUiubrh+41gVa7wR2T48dsWMnX3wHbg6dUyUsaeVIJaQ==
X-Gm-Gg: ASbGncsKCEa6wbcH0qfm5SmHuygngKHlFM5mWz79/+kUH6f18bqoOi2T+pcJmF7pcdO
	fa7UT5+i8YEHYinHkDQNTzfQmHqeymuYAWFsVOpdJQ6xv8V0EVBXkn8yr/kHn8//kI/skp+17bT
	VyV5pqE8qumkwgbH7Hn7YD4ovNKdNp9TnKN2MkHtWHppBOOzojsCQ7AeEGVkEqkGWVbj1hdrT4/
	JjfY8iY4/EHdqSFIYNy2+CTIfXFwSUbQm0pDQ00oISVKAqCZZpqaVVkhHi2G3exKZyov/FY8CRJ
	phK62li3ZPo+R4m2HjpuPVx8iC4p8oF5HbRXGm1AQdiPu90tvoZbXJ0tqod4lbZIHk67Q4PPcUX
	e2g1UGGk8DkhNPgEH+gAi8BE6ELw=
X-Google-Smtp-Source: AGHT+IGZUiqgRibPAiA5DgB0BOAerZLdpk29rMvBlfQxC3FGQGHcSpvUlZ5Nw+aF8RQ+y3vCwdokTw==
X-Received: by 2002:a05:6512:31d6:b0:566:41cb:671d with SMTP id 2adb3069b0e04-57061436fa8mr3784043e87.23.1757943649092;
        Mon, 15 Sep 2025 06:40:49 -0700 (PDT)
Received: from localhost.localdomain ([2001:9b1:d5a0:a500::24b])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-573c8330e54sm1150719e87.63.2025.09.15.06.40.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Sep 2025 06:40:48 -0700 (PDT)
From: "Uladzislau Rezki (Sony)" <urezki@gmail.com>
To: linux-mm@kvack.org,
	Andrew Morton <akpm@linux-foundation.org>
Cc: Michal Hocko <mhocko@kernel.org>,
	Baoquan He <bhe@redhat.com>,
	LKML <linux-kernel@vger.kernel.org>,
	Uladzislau Rezki <urezki@gmail.com>,
	Andrey Ryabinin <ryabinin.a.a@gmail.com>,
	Alexander Potapenko <glider@google.com>
Subject: [PATCH v2 07/10] mm/kasan: Support non-blocking GFP in kasan_populate_vmalloc()
Date: Mon, 15 Sep 2025 15:40:37 +0200
Message-ID: <20250915134041.151462-8-urezki@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20250915134041.151462-1-urezki@gmail.com>
References: <20250915134041.151462-1-urezki@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: iz8ojug6g8ooqwopiick7xokh5s9y1qy
X-Rspam-User: 
X-Rspamd-Queue-Id: E29A28000F
X-Rspamd-Server: rspam04
X-HE-Tag: 1757943650-788982
X-HE-Meta: U2FsdGVkX1/2Hit/8XWnJzMZB5UGiArUL27Gruc6khrwF6taOEWSQFHMdiox+gQB7umlU6oci5T5hnW1luMmIATG4jhxo9p1WBZK7frcxJPrtPTG9w1C6JSByIiDxOejwkdfptEtSA3isP9RgO4r1r/AFs+zsg5QhzUuCdvjcY6AsCmmMct62VrYCw2Cv0o6YbbNfibUKRIhKGxtsF33wn3W6TLIlgpoiXsanPJy/jEz4DcHTPqmSZyIZqqt1L9Q2mfugRvN7YdBGiUfhfGBj9kyt7FJdVRs8Plpdu/jwe1O3RdZrf5xSPzmwBbagMrhcFsTABnarpiJdP89cwplBIHB5VVOWDdw8ElyKKTbQo+YQeKLNv4pjboLOrfk/bn3qFbp08mP7orsAk4+U7PqJQXYWKGKMv/rjUFUnfTSjsmdwLyM5QV5acf897a3AakEKpApu+oU4ba+TYNjn+4FqjfqvskGaAO/YZquwZkwFBpEZWDaFeEG2mxPexu9sjNCZQtj1TZjzFVrwrdRiDxFY+6ZD8LswCdPltsqHWBRhfWZMP06Ii1khqQzzDfN3Q1RTsTXoiViWl4srCuXgvP7TiEn8nN4FPFdn9EajRj2Yyw6hTLNDyE0seE+3Vl7breQEROM0MHT62XW8MlIRQv4/IBYhKXTUoAY7AzWuyKSSykV8fNkRMtJC2wD1tPY8kwgAfMuq3QpBlRYhim5lnAaEFsxcWvb6ag0m5pbwnTU2BCRO6QVPiiV4jkifekq5lpd+aFMCqjXvmL/K0DlpADgTts2w2NhpRXQ7fFRwqfApdnHHOmoSJqm2jQfO7N97ov/Zcwsle0T1CusFWRna/4EaIbZXmDvB98+TweNwPvNYaCD4Qdy/tYOQZbjfXwbePO9ef30rJn0/HbV7fYuK17SO+6iJHYPrYaaVR5dRtOtnROdfdvhETs9iWOTk7vxGyJfmLLV+opWOoSlV80UUgj
 3v+qKQUZ
 5uBT41o8m67hBjfae1mJuDvBbRsZnErPgGe69wTuYPg9kTCfmzuY1ViVrpLngeEsq4GEJ+BMd19ui/Hg99zAA+Nipbsjp5oXzR5ac1aBUrjhnAL/t/oPoBJuap19oaEuBLbcQep7y9e1l8StOwNsalTl8LdyK7HDH5ifMv1ICqIRJMq38UqGPzCowoB1LQVx2cvpXt36MidhQPRlxpl4n+CLd+x9BvlxRYa8E7ZnsbpInrkp57KJSpBWZR9ejyzDhULE9UOZHeB70hIJbnBRGH7FbkrpLFzkWwXsCX/ujqrcpT9Bw5wNClrINbX18fSVNzD8VTlpyIf0LXBm8CF4Zs7dZQpDqv+EmVvJxEVnJpKlauq/1wRT/7dMqDjU15kaSa9PjCDG1K+pusZAnqcTUpWmcJtMJXSEC+d6VhErA96HDY6Ykqoy+afzYWSE4UrqPsl592RQtC3orbdVydvRbCfOVsFTViUQ2y2a1VF8vR1CW9b/fyqwcNEfVEtg4ICPTVOfQESEd311CXw2qqs4cHmYN0a+uegI4F7Sqtq3Wdi5Hp5X+3VD3SlXj2g==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

A "gfp_mask" is already passed to kasan_populate_vmalloc() as
an argument to respect GFPs from callers and KASAN uses it for
its internal allocations.

But apply_to_page_range() function ignores GFP flags due to a
hard-coded mask.

Wrap the call with memalloc_apply_gfp_scope()/memalloc_restore_scope()
so that non-blocking GFP flags(GFP_ATOMIC, GFP_NOWAIT) are respected.

Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Alexander Potapenko <glider@google.com>
Signed-off-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
---
 mm/kasan/shadow.c | 12 ++----------
 1 file changed, 2 insertions(+), 10 deletions(-)

diff --git a/mm/kasan/shadow.c b/mm/kasan/shadow.c
index 11d472a5c4e8..c6643a72d9f6 100644
--- a/mm/kasan/shadow.c
+++ b/mm/kasan/shadow.c
@@ -377,18 +377,10 @@ static int __kasan_populate_vmalloc(unsigned long start, unsigned long end, gfp_
 		 * page tables allocations ignore external gfp mask, enforce it
 		 * by the scope API
 		 */
-		if ((gfp_mask & (__GFP_FS | __GFP_IO)) == __GFP_IO)
-			flags = memalloc_nofs_save();
-		else if ((gfp_mask & (__GFP_FS | __GFP_IO)) == 0)
-			flags = memalloc_noio_save();
-
+		flags = memalloc_apply_gfp_scope(gfp_mask);
 		ret = apply_to_page_range(&init_mm, start, nr_pages * PAGE_SIZE,
 					  kasan_populate_vmalloc_pte, &data);
-
-		if ((gfp_mask & (__GFP_FS | __GFP_IO)) == __GFP_IO)
-			memalloc_nofs_restore(flags);
-		else if ((gfp_mask & (__GFP_FS | __GFP_IO)) == 0)
-			memalloc_noio_restore(flags);
+		memalloc_restore_scope(flags);
 
 		___free_pages_bulk(data.pages, nr_pages);
 		if (ret)
-- 
2.47.3



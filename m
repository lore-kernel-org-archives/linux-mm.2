Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C7668FC72AA
	for <linux-mm@archiver.kernel.org>; Sun, 22 Mar 2026 07:08:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AC7406B009D; Sun, 22 Mar 2026 03:08:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A78A96B00A6; Sun, 22 Mar 2026 03:08:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 98EE56B00AF; Sun, 22 Mar 2026 03:08:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 899BC6B009D
	for <linux-mm@kvack.org>; Sun, 22 Mar 2026 03:08:50 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 06A4F1A07E9
	for <linux-mm@kvack.org>; Sun, 22 Mar 2026 07:08:50 +0000 (UTC)
X-FDA: 84572821620.11.CF11CB8
Received: from mail-dy1-f202.google.com (mail-dy1-f202.google.com [74.125.82.202])
	by imf07.hostedemail.com (Postfix) with ESMTP id 536E540009
	for <linux-mm@kvack.org>; Sun, 22 Mar 2026 07:08:48 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=YnUZhPM5;
	spf=pass (imf07.hostedemail.com: domain of 3fpW_aQYKCPsvxuhqejrrjoh.frpolqx0-ppnydfn.ruj@flex--surenb.bounces.google.com designates 74.125.82.202 as permitted sender) smtp.mailfrom=3fpW_aQYKCPsvxuhqejrrjoh.frpolqx0-ppnydfn.ruj@flex--surenb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774163328;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=bUUcI+G547AnXOqEoU0HumPgtMUcHYFJWOSvPIWQmuo=;
	b=6ZwHRHpaPisewC9aY8wRtHLG73he2bFXD7FwRZJsbvn6W9X1jw3YqUKynttXSVnd43ArE3
	X/BqkKPEEswvRoE2FKvQ2wkBtzmW39BrU13cPwjT+cwL30Dh9tJ8wRoheaxiDiFBp31Ebz
	FCMuJd1Ct7/6tdBCskkOmq0/6+pIvTw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774163328; a=rsa-sha256;
	cv=none;
	b=06aw/FA1E0W1aZi2lMslMMLFzODFenIeufkfXbi1jOaj+Gv20UbkXsRkiE9QMHJNWpzziT
	XCfjsHSRixlkA5n/bVsEf4jCMFodltv9lr5WQyKB4i4MluxOPRMQSKYxXJT5urWnCkrv2a
	KYrO7iFHqVJNQdxulNSzVqMGBKRi/Ds=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=YnUZhPM5;
	spf=pass (imf07.hostedemail.com: domain of 3fpW_aQYKCPsvxuhqejrrjoh.frpolqx0-ppnydfn.ruj@flex--surenb.bounces.google.com designates 74.125.82.202 as permitted sender) smtp.mailfrom=3fpW_aQYKCPsvxuhqejrrjoh.frpolqx0-ppnydfn.ruj@flex--surenb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-dy1-f202.google.com with SMTP id 5a478bee46e88-2ba8013a9e3so2566097eec.0
        for <linux-mm@kvack.org>; Sun, 22 Mar 2026 00:08:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1774163327; x=1774768127; darn=kvack.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=bUUcI+G547AnXOqEoU0HumPgtMUcHYFJWOSvPIWQmuo=;
        b=YnUZhPM5B4TLK+dElM2gNTNGQ3FQ5vsDC8a4VTiI+d6RMxoxhHEa35eb2V3t0o8z0l
         JquGv9149D0D67SuCU3/JqJeoSrl2RMtN8rzd3Bnk2ae31jeb2tcdVCMSix6TEsHnp42
         gsSM0zOwcbmd7K9WT0EURL4CxOuFZpKBbmWATCO84K5Qk4f4HBaaLFltziIOaynSHAy+
         Ik/YK4lRvimJtbLCZvORze3QpIsL+F9CZmXDxRYqhRPM1d6kZGPw9YNXLzfe3I9IZb8r
         zid8N0HBuaJ8oaMmPMmiyXNHWFMiyD//mddF2s187A4c2zRaM3ei8PzABJwRybxiodWr
         kCwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774163327; x=1774768127;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=bUUcI+G547AnXOqEoU0HumPgtMUcHYFJWOSvPIWQmuo=;
        b=YGydKT0NwzkVLXH+RLx0BhseuvcLpnCHGMuz5OEnXMugKAsVYF1qiMQWjXnX+Bnb/B
         nSnzBOgDujvBc5oKnReRhHyBUMk76BR9JWoQT5jONQY8xeO8dV/81o/TEXQVctNJvy4X
         YfwXUyFcG8CCC2PdhN1zgshtPrKmsAXPJ+Osjhx1Eb6LWm4NTMDa8Gv8UMu8w8mroMpM
         4S2w2hKA0Utk9FsR/GXlrcAdF6i2hG7/g2N8Y56QYFJ0HerzJ+PX4WVWupXMzbBHIjUv
         anoQe+I0qpHSno8gbIIOV9tu7bo18ehYG7WICeyvzJhysk3OD+Vjx8gY3pKzR7sgJuh8
         gdNw==
X-Forwarded-Encrypted: i=1; AJvYcCVhaMgtsj6u27NPE+dmQjb0HnaZ9vvvlo+c0JgrGfF/WR0mlYC2s6wPeS+4noYuuFM+ba++VP1ThQ==@kvack.org
X-Gm-Message-State: AOJu0YzBlwMMD1PlT6/YUhyqteeFKt6T/mC42VY5hEe5cao/uFUyLHpB
	GtYd3b+MH7YiYwlys69jxR7brJxhQQP0YRegoK3U4EhAcTiH6KI+k8jSRguAbQgDUro+wiGDocM
	1BfdrGw==
X-Received: from dybme4.prod.google.com ([2002:a05:7301:1884:b0:2c1:264d:62f])
 (user=surenb job=prod-delivery.src-stubby-dispatcher) by 2002:a05:7300:6dac:b0:2ba:6854:8d4d
 with SMTP id 5a478bee46e88-2c109752e05mr4064629eec.20.1774163326701; Sun, 22
 Mar 2026 00:08:46 -0700 (PDT)
Date: Sun, 22 Mar 2026 00:08:43 -0700
Mime-Version: 1.0
X-Mailer: git-send-email 2.53.0.1018.g2bb0e51243-goog
Message-ID: <20260322070843.941997-1-surenb@google.com>
Subject: [PATCH 1/1] mm/vmscan: prevent MGLRU reclaim from pinning address space
From: Suren Baghdasaryan <surenb@google.com>
To: akpm@linux-foundation.org
Cc: hannes@cmpxchg.org, david@kernel.org, mhocko@kernel.org, 
	zhengqi.arch@bytedance.com, yuzhao@google.com, shakeel.butt@linux.dev, 
	willy@infradead.org, Liam.Howlett@oracle.com, ljs@kernel.org, 
	axelrasmussen@google.com, yuanchu@google.com, weixugc@google.com, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	Suren Baghdasaryan <surenb@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: pc3dyqaeggoj5etqo3w5d5b6ke8ds77o
X-Rspam-User: 
X-Rspamd-Queue-Id: 536E540009
X-Rspamd-Server: rspam12
X-HE-Tag: 1774163328-381803
X-HE-Meta: U2FsdGVkX1/4ExUgz0QoHZPUlhqFRD28f4l+Q00nNVTqM9vy6dPfi+4Usxjvh0UO2DVpYknWMKMjTRJYgbkYRLU1xh8SDlJX+wAPg11lhnCun6Ahj0ctihfcG5d5WWnAQnoV3CFdQ+tw9+Tzubo4DOc7arqeRfkklqvnGBLU/JYIVc5PNVeiQnI3DjT1E5148nl2U0Tv1rCYR8yfwb4JSzqx3JOpRGI3OtjUTa7vq3PH30QZYfQ2XXnN3CMPDYu+Dysc71q6dn6KRcIMcmZblBK4DLSH1nBKHCcyoe4VI4iX9zxaCIcoI/QGtlC0E5vTiMoZgQkEOecB9uuYNTmfRuKWHlabqSAoRyV2JDMYqmF42hPF9MioOTpNmpilOM0HKuW+p+2Zfhwei5aHRSHJpcJnResAUu/6SoS2JZMnfC4Lgz+lOzI9g4kh3nm+6FzMd0FFPlyuDG1Ve1HqXiGFCigtPHoG6i5MktMiFWSPDIYyIJaG/ec+fvjQ0GrmF7WRw1RtyOBIOctm76Xj1bbodyW5luApayM75AsbKT9BtRTbdIhewnNaylr8OlcFA7Xyfkqh0+KZR16+vOjmnpdoCRh2d/xVE8CwHUQfLrhOm/WUb0fDNp3MUST41dQAXNPmw+kfNeBMymYUgd+DlSTda88oYOOPhEis+k9NDZ+uJFTNzFiUDlFBa43b72ntqhEigDTYq9BaefcLy5gbmZHy+XWsNm/h2l37Nn6Xsd0dWliWnHPL1tWRd1fETtUyywactLerFrxpezWr9yGjT/1FOdfSTFkXjg3EMNFThMiOPbqYSS8GOVVb680hcv6mcuKZqVyUyYZ03y10ceEmBQ9sA7dqG/xHEU+lJVNiY1JnzDg1VIhEMF7sSU1HtT4S5ydq5E68qTX8Nwhn9Cp4UgT0Gsk05TjRAg+MUKHMSSc2TGKtquDSHvGpy3Yl8sPbqAAAVT0Ie3xHIYbSNAKFHEv
 ylE+Tqvv
 5gPNT/mBMB2ASRVwPlqpYAJEQpIM3cwwrvw5jI72z00vzT9qOCFsMTZZPYnIlmC8iJKzSNIvOeV3RowhaTnfaU26XlLzga5J1qRLBwzCEuDcxukVIII7Wvtv1cslBSVLF2AO3v7yRKjrK5KHFR1RzTYUfzGgx2dUnKeNXwZl7FjNLN978zzLq2S/jrrh3NGqpqoLeLowmzSJN+rvFCxwyHi3G+GVqbc9vxaG7H4A8AuBEFRlEodgFTun/2P3jrlgsWwN54h1CFO7UNt5Ekuskn0hTy5k2GKUx9bXwZL2LAtTXaBjiwlI7vnRqVeoBRJYdq9g9a8zvV3GVEt3Vd7ZdE0Wr1nQLijEZxUKMcyBkhSMqCjZxivHMyMj3adbq7vTZjUKJhdX5/+D61t42MIQ9f+/x0JYNLBrAk2Qs2FR81MAg1QDuUMhm+VgzVh466gTerJJKSVX2faobRSe4OIvIi4lA0lRXjdxLTgOc7hl4PAUsxwlT6Jh4BwOxVeaXerjl8uQawEybPUujBFM9qrAA1GKQWSf0e7aoVQYAYwjDaYHfXj/ET57Wn3zRTDs3oYmlj1GHPuV9hD0T2+KXZZN5Gfs7hoMlUVJPonMF0V99E/AbNOTnFNezlJScaw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When shrinking lruvec, MGLRU pins address space before walking it.
This is excessive since all it needs for walking the page range is
a stable mm_struct to be able to take and release mmap_read_lock and
a stable mm->mm_mt tree to walk. This address space pinning results
in delays when releasing the memory of a dying process. This also
prevents mm reapers (both in-kernel oom-reaper and userspace
process_mrelease()) from doing their job during MGLRU scan because
they check task_will_free_mem() which will yield negative result due
to the elevated mm->mm_users.

Replace unnecessary address space pinning with mm_struct pinning by
replacing mmget/mmput with mmgrab/mmdrop calls. mm_mt is contained
within mm_struct itself, therefore it won't be freed as long as
mm_struct is stable and it won't change during the walk because
mmap_read_lock is being held.

Fixes: bd74fdaea146 ("mm: multi-gen LRU: support page table walks")
Signed-off-by: Suren Baghdasaryan <surenb@google.com>
---
 mm/vmscan.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 33287ba4a500..68e8e90e38f5 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -2863,8 +2863,9 @@ static struct mm_struct *get_next_mm(struct lru_gen_mm_walk *walk)
 		return NULL;
 
 	clear_bit(key, &mm->lru_gen.bitmap);
+	mmgrab(mm);
 
-	return mmget_not_zero(mm) ? mm : NULL;
+	return mm;
 }
 
 void lru_gen_add_mm(struct mm_struct *mm)
@@ -3064,7 +3065,7 @@ static bool iterate_mm_list(struct lru_gen_mm_walk *walk, struct mm_struct **ite
 		reset_bloom_filter(mm_state, walk->seq + 1);
 
 	if (*iter)
-		mmput_async(*iter);
+		mmdrop(*iter);
 
 	*iter = mm;
 

base-commit: 8c65073d94c8b7cc3170de31af38edc9f5d96f0e
-- 
2.53.0.1018.g2bb0e51243-goog



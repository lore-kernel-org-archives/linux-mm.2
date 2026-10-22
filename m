Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1895E606A319
	for <linux-mm@archiver.kernel.org>; Thu, 22 Oct 2026 20:04:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=kOy+P066
Received: by kanga.kvack.org (Postfix)
	id DFE8E6B09BF; Thu, 22 Oct 2026 16:04:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D88036B09C0; Thu, 22 Oct 2026 16:04:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C295F6B09C1; Thu, 22 Oct 2026 16:04:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 8FC126B09BF
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 16:04:11 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 04B86A0298
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 20:04:10 +0000 (UTC)
X-FDA: 85351338702.13.CD74F15
Received: from relay.hostedemail.com (unirelay05 [10.200.18.68])
	by imf22.hostedemail.com (Postfix) with ESMTP id E288AC000F
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 20:04:08 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	arc=pass ("hostedemail.com:s=arc-20220608:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792699448;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=YRntzMBmnfmIB4INuU9xu5/Fgelt39Yq9cPrtthNfGc=;
	b=TqFFT8ttO/Lw9juQImGBWRMrb+NTZPUbxxUZ1EBiLSWK4j9jr3FjRb3ReoA3DjFDkvyUW8
	aGA/cPLD2SKe56GJNx3uPExbQ4w7zcyVXBr9raAodQaA6y9RWnRo4O4qySHtk8NaR+KKAn
	WRJd/BtiIc2VJTnTgAgfMpb+j1phvb4=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1792699448;
	b=ADSWShVG6VKgFeA+eKAtGWYdO+MEesQKCKNgCY9UG5O4xaW9bFMi1VZV/7I3BLgU6agdmW
	39UzXRP/8CvEHR+BkYhIGc0sX4n75y6YvbT+ZNOj5u4pzyos75SDBcFym0AybQK7ZD7ANo
	ntWD9BhjqBQqfyoXUrXqB+QBFpgJ8Qg=
ARC-Authentication-Results: i=2;
	imf22.hostedemail.com;
	arc=pass ("hostedemail.com:s=arc-20220608:i=1")
Received: from relay.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 6EA774025C
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 20:04:08 +0000 (UTC)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 369CD4029B
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 20:04:08 +0000 (UTC)
X-FDA: 85351338576.22.053BCAF
Received: from mail-yw1-f182.google.com (mail-yw1-f182.google.com [209.85.128.182])
	by imf23.hostedemail.com (Postfix) with ESMTP id 757CD140006
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 20:04:06 +0000 (UTC)
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792699446;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=YRntzMBmnfmIB4INuU9xu5/Fgelt39Yq9cPrtthNfGc=;
	b=gD8yUAP8Ih2Qf96hIpe39eyZi5xOTAFPOc8jrsPd4r2r5z7bz6je6dNWgGg1nopcPuEWHb
	JlQJIO895F84pUuIh+dy9V/0r97iD9Ybm9HkQI6/1cLF5ZwxUWxT0FUw8Rpcnu092hjIOz
	+xHkOrRpHm+JnA00KkosLTjfiInV48A=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792699446;
	b=Q2WX6X1t1TLQpog6oP8nd9UkW2IxWHsvoKUPLeqHH+lVnZhKRfGYIkM+6uk1XYcWiqHBHc
	7iXgoKNq4wu7LBEJkecEMW7CNEtcWADlxnMku085kIripjuq2l3DwdkoeI/aE/iMk1VcEE
	kSroIInhdkOhWdbrq5sKhGY0ffEqDfs=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=kOy+P066;
	spf=pass (imf23.hostedemail.com: domain of joannelkoong@gmail.com designates 209.85.128.182 as permitted sender) smtp.mailfrom=joannelkoong@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-yw1-f182.google.com with SMTP id 00721157ae682-8565d77c277so2618117b3.0
        for <linux-mm@kvack.org>; Thu, 22 Oct 2026 13:04:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792699445; x=1793304245; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=YRntzMBmnfmIB4INuU9xu5/Fgelt39Yq9cPrtthNfGc=;
        b=kOy+P066GLZzQzSUEsbWjmYuYPJPqOfO5ssd5VJlIINFwcOBe2oV3My8D1nhxmHJvW
         30X5iwhZKodVhYSRLx+NP9rwstP+JiIM0NshcRadkTKYSYvlLoCgrBg7C6XioqLL6UH6
         hyg4mpCQ8gRlF1DkayelY0TNq/6IDCddudNuqGMaWdgCeothuOBlKFuOTWbtOSQfskY5
         sHTh7sgd08L0O194H3KeQQs6JTsVCsnemmiErqeymC4yZDK4w0+EFoM2zhKeIwxSEA6e
         QymWMv5ZDNdMbgxxnL2cfsTaHf2Sc818oQGfcdoUNiei2VrAsvL5LszxeMVgwrqBpLLy
         cdzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792699445; x=1793304245;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=YRntzMBmnfmIB4INuU9xu5/Fgelt39Yq9cPrtthNfGc=;
        b=z1MkzOI8/i41S/mn5/CoT+9XrpF+/4p5OPIqDiFn7MVLj/8HM5D71QQ+7kQ/3bcIQg
         mfO3o+fHXVnIvrlCjEd0Wb0g+24je7y+34FtgnOwQQBnmvo3PuSeE/YezJTkXoAxRN3T
         o+5XwTC4+TTgf21HaB/39VE/CUxe8+J+0PT+2+tl6ESEaqu95WdJ//tF8xmrIqLI86pG
         KPWkqqSTFSjUNPwumISlqclhKNL46aPoeN+axATaS7yye9/v4tUTj65N76q8zeJxMpUy
         pmZwQH6wbuWh2Qkpdum5Pa75gWb+VDGMvqudLzzV2O/pyZFqS0nhtKU6G//iDB4OT2ie
         2tFw==
X-Forwarded-Encrypted: i=1; AKwUvBxfQJLcu8cgNSZvrEv3Tt0gS16h3kopwpGPScsZG6RidnPfeU/rsLk/hGVrCJ/fbNExVh/21gntFQ==@kvack.org
X-Gm-Message-State: AFq9FYLwtQW/i3TMQ1SFfc/r/tXjBICCr4U6/TsHy0k3vixuHu93lLPG
	7kHOtdAUcjjKDsLlBtFkeV3ECOUJXLyssHi9FoCMwcqlsf4jdr1vnXFz
X-Gm-Gg: AYBFou0A07YzzcuEZidKyZrm0+6uw9WQmksovdy7kOHahe5Umko4IXWZr2uBIwk6iFw
	JQGjnNhVSDCDhi4D1LKy/oEFABrfSundMN4B04aAPdl8aigZfmmvoq9DorP4GQ7aBadcka8IdrC
	Z69yFGrzIngTuF67pwkWUibTgbORWRoChONnSDChLeQoRP7KGKuJ8Rir0T0QQiasyrny2V3ZAaz
	pGWDt/ytwBx2sctZHHFx480reOgsMonxr0vdnmtXU+oM8qKLNsSKUr41l6f4OvezwQL8TAElpbH
	blF4jHwpWrOdKkeLB2lEL0uPW5NkECRKDx4l5hVgak5pLLvFGznxeGkbNd39CEG9K5erpX3NY5a
	prNuAq31SCGDTO/N5esESCiggyy8sfb9/QxEzaJfooHzs11JuRo9K74hpJ5yXxWTCfO/RgQAsVQ
	PLR1K8EJzUoghFJlRRO/p05gTRtfwbRJc55BSVZFWP5rUHGTGIjnBBsv40j6fOywR7cVNM8/YfR
	VfDmbc7D7EfSoctL11000sy6va/WpBqXJDYuQ2AVcC9yPBkKdhMrMrTmWDHhcHKM4q6CHz7Y0Bm
	PhwLflfAXHTsbTgMlOyLF93fP7FSweQ=
X-Received: by 2002:a05:690e:128e:b0:679:9c43:8599 with SMTP id 956f58d0204a3-67a359e6abemr53680d50.8.1792699445215;
        Thu, 22 Oct 2026 13:04:05 -0700 (PDT)
Received: from localhost ([2a03:2880:ff:6::])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-8b1560cc857sm3450147b3.9.2026.10.22.13.04.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Oct 2026 13:04:04 -0700 (PDT)
From: Joanne Koong <joannelkoong@gmail.com>
To: akpm@linux-foundation.org
Cc: yosry@kernel.org,
	hannes@cmpxchg.org,
	mhocko@kernel.org,
	roman.gushchin@linux.dev,
	shakeel.butt@linux.dev,
	muchun.song@linux.dev,
	david@kernel.org,
	ljs@kernel.org,
	liam@infradead.org,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	kasong@tencent.com,
	qi.zheng@linux.dev,
	baohua@kernel.org,
	baolin.wang@linux.alibaba.com,
	axelrasmussen@google.com,
	yuanchu@google.com,
	weixugc@google.com,
	baoquan.he@linux.dev,
	cgroups@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH v1] mm: move LRU size stat updates out of lru_lock in folio batches
Date: Thu, 22 Oct 2026 13:03:13 -0700
Message-ID: <20261022200313.2354350-1-joannelkoong@gmail.com>
X-Mailer: git-send-email 2.52.0
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-HE-Meta: U2FsdGVkX1+OKSf6Gl6SS8D7eSXJ+TvP2sFicRHymJu/0LxmEMaJHjW1BsUaeIcSRdyaYLJWQrmMCJVJrQdHlq0WIMPNQH1U/8mb3u+avgkA0eaSQXSBJFzncnl43I9PDn7KlK4CrT03rL8QZCDsc7beirF2z4Nau3KP0UxPY+/IcKsopBGpLCiGkDk3L1WkFwlOv/ZAkpcxL45PAHkpGC3u9FFnkDWgs4LQ7BAWCLWdCtvZ1dF9YNtHjnsaQHGT6C2Pd0WuTkllfDo61CVWR+Fc71Zl7nqTQRbRYYDVAHW0fRSgCfIiF9AVoJfJmrSm4xS2C3Cj3AgXi96JDDZiye7gQucj9PfIdrN+58Nrf2UEwHr9r544rkgdN5biTHorXUYdvJcB4qZcikVzAhAcsv4Yy9ZNTmf+mu3XWTDMUwM2mWudcNDjaCyoh5JjQ2Za0aT4uL3WjF6WX4t3AyIkbtGlmSR5Coe+33qfQtwSsI34/vHb/YPo4xERU3XA+10/FljUIvx7Hq+wiNCXG97qegB399mrreGcne8mWlmrkRWVQ5pTTvmnlBqcUloC/t5oEY9pGrr34wGpwF+cn78FsEY+buoqeJVX3DiY8uFCF6/nj/t1Wd0Bj0kXpvLr9kHs2MOt5QzktOeR9mLxEK4gYC0SjS6XD7A7gbF5/9HmqjW+9s8FIHXMuXMeNsBerIeJ8Imv7rNDgODoGzRtz/NrQNUQ5VsbV363tQc3DFOckJb0AAecLpM2oNwlD5/9S4Mu6OSqZfpxnkn4LAONDrYspY6bL19+WAQQ0JBonXXkAIgGGMt/jxdN76JExwaJh+9x4dqMvq7Alk8DRm2n63S4szPKSWr/0DGK1xcljohhQsMEz4S7b8z9Jv7YM7mHsEKceQgjLB8K0O8noE/H9Lq/E59z/qLmA1YqOOPyusmzmyzzb9aKxXOurUBTHzhaQyAQq0yu5tE//RNRe6ui+a1
 GABZx+Wt
 zLDPyVjXanjJqTlwdI+KT6TQCyy6tB3CFPlCI/J2JtN5XT0Tm4r/XeseBFTI3TlXc9sHm7JxuOPbiAAZZe1hsKhcSXRFHNLwmlzxUa5c4vksdlebk2diQdlSRDFTnMxF70t0lzY8sqYUaQyZhaPKeR84oGPZXnkezxIr9WrspqB3w0HGdhGmkIbaW7010g+LIfyIKBC4y4ZmNzlJGzg3XRsbT9nXrwEGJ2HeKOrUwLvBTKed0ZIoM5cxVHbtfUcqTRUCCpbfcBeVJ0xkQ+RCBr0oGIoXoGgLNOw02BamFEHMXhDYT3w7H/XRr3oxCfbEYALDog+4oo8qQoB4fq8Idhp5g9qVGspqKyI97WHbJDQDAk5GbhgDbWx/4D9eHA1yDVxF9btZrpxGrLT/3c4LuInW8zGjyhV1v5kgdSnCo21r0gNbuAbXVNxtkeq0Wl3mKxLGESF295bq40yj2PrGQ4zPkqOchgxJGKiGEoT8OHP5mjndvtBlzkzDe6APi/ac0NroI/NQP/YlMijwbL8i0HOfZYw==
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: E288AC000F
X-HE-Tag-Orig: 1792699446-60571
X-Stat-Signature: y5okhatqy3bna6myt8dhpdpwnfsyjk6b
X-Rspam-User: 
X-Spam-Status: No, score=-20.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1792699448-530931
X-HE-Meta: U2FsdGVkX18xCGffBJ2OfX0CfvXqVWJDO9sSfJITMBaT0TIj4zkUz1N+pQe4Rcv4ZPxnmlXn5q1UquZPsj6rLeDrkdW/cwAhL9q1XkfmSAzNPvK/pbfYNVgOarq54p69bo6Fai6BwP0M/hcK8/wj26OvNigYDi/MFJwmmzh1Fxv0kH89vnLgH1DpIqdzCc4s08WNHq2OzR/kOZNjZRGS2DXpJvl/H62A8Sum7n1yTtT5JFD2Qv8daZ8yAuuwTB8/Dz9TE8iYybBZ9KzgNpUJwYphJfJEPDU2op7dpAhvgkK/f4EldkiV4XIKsg4pweXZmBho9lIw0EUPPKpGqBE88hIwdcZfSdrSir0dpB9Nbx11aZhECu0KyGfxxwB9D6y01xPNgdfMKMdrP8xx/P9pRviEHtnIDxhs574cgoY+tEDZHdCy/yK3+WieICBsCS4t1Y04p0EqGFpQUx+34sY53Scs7miK56NCLz58DaTMW7FvUcmOXQeiLlFRo8fK/qQUFoiCY30pFBwrkZYdFVMbIGugoW1uO3FVO6ep1uFAaPJm3Tg3pvCbcI/jwvlWgYQKGzkvNqrh/eJoWeDIT4jX310cmOpd42lsJAVaSmNNCKEvsuQUNvNXAqi1NyJX9jETtQOdpnvJ3nrDytGK3B33gglAr9/wCTODMrVWVs1X5uFAdE/Ss8gLA1W2vT42xG1thsseFK0dLesNIFBHUVpyu3Lqpt7zCAGcjGcD3gNTAH2wGQB5YW1xFISWK73CEvULdeN1ahgmUTyeahnLF7UuQudSG3Qn+N5FzNE1ouFqsKwEO4467gUC3j/AoOshwGGfdFQS2J8GwjMiC1plgm5UxHxDBmLPpDeyHpH/xhlKSR9EzmUyi7Bj6WLmXAm7mt++qWtBrnTvm+e0IkG0+DdvTJV5lw3hiU4KY2q3ZNUTIgK7rlh+KpfssTbKRT5l3MuzKIDJLgREgwyPXmnymZw
 kwzMHpz1
 FJaZiylENd5SZDCjnFHgqW37BR4rrKnFSznEd02Z2j5jplc2AxKzKwKG33qjlKFqWOxcqi7cSrNkYMgI3zcq0f+WAjUQ45ygXW21GoFHmgLMpaOY/73j3XVP2bAxiK0su8jwuf8+K1O7/6GliluJkygbMhLh/83y7538HDDQ07Ovv68qrD7L9wZ5R2R6I60OA8YuxbuHKPoSbXyKAAlAE0hKHUbFTa/JWjLr0o7ck5PgizRoa8qD4D/5WefuCyj5a+w98lxF28fdm+93b1IbNGTOQslHVmGsZ6htBgIOJMZD6EHXGC6JRSdRYBAKzGzkShx+9zd3/Ka/rxbyZiLb4duuiCoi0KwzOMiyg6fEjPHY1i3+2uTsdPYKqrKUD0PdI6T8WortNkhDR7dCpo9KUkqO7J+f5fJQ4DT4CHChf0/tGcTTrpw2Nw9daObgJeR6/WG3T2Bx+6bEes/5j1uuLTFNsHX+Fnw2gBrt69JTiHM7/0NIr5K/s81pkGg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

folio_batch_move_lru() and folios_put_refs() take the lruvec's lru_lock
once per batch, but they update the node and memcg lruvec stats for
every folio in the batch while holding the lock. Only the LRU lists and
the memcg lru_zone_size need lru_lock. Updating the stats while holding
the lru_lock is unnecessary, and they make up a large part of the
critical section, as seen in [1]. With many threads faulting and freeing
memory in a single memcg, about half of all cycles are spent waiting for
lru_lock, and the hold time of the lru_lock directly limits throughput.

Accumulate the stat changes per LRU list while holding the lock instead,
and only apply them after dropping the lock (while still inside
the RCU read section that keeps the lruvec's memcg alive). This moves
the stat updates out of the lru_lock critical section and turns the
per-folio updates into at most one update per LRU list per batch.

The batch is attached to the lruvec while lru_lock is held so that the
LRU add/del helpers don't need to pass it down. To keep struct lruvec
from growing, cost_lock is moved into the hole after lru_lock, which
leaves room for the batch pointer in the same cacheline as lru_lock.

The stats can now lag behind the LRU lists by one batch, which is well
within the per-cpu batching they already have.

On a 2-socket Skylake (80 CPUs, 2 NUMA nodes), with threads pinned to
CPUs repeatedly faulting in and freeing memory in a single memcg,
average pages per second over 7 freshly created memcgs per run, 2 boots
each:

                     before    after
  shmem, 20 threads  4.74M     5.47M   (+15%)
  shmem, 80 threads  7.94M    10.33M   (+30%)
  anon,  20 threads  3.04M     3.35M   (+10%)
  anon,  80 threads  3.23M     3.41M   (+5%)

Link: https://lore.kernel.org/linux-fsdevel/CAJnrk1ZezmmzrYdf8KP6re_a76izMS=qGPeC8ZZXiteHyZZC-Q@mail.gmail.com/ [1]
Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
---
An alternative that avoids adding the lru_size_batch pointer to the lruvec
struct is to pass the batch down explicitly, but the plumbing for this is a
bit ugly (and doesn't cover mglru paths). The code looks like [2]. Happy to go
with this if that is preferred.

[2] https://github.com/joannekoong/linux/commit/2f20765b01f98113e3c83ea0d0f98580502bfb96

 include/linux/mm_inline.h | 12 ++++++-
 include/linux/mmzone.h    | 11 +++++--
 mm/folio.c                | 67 +++++++++++++++++++++++++++++++++------
 3 files changed, 77 insertions(+), 13 deletions(-)

diff --git a/include/linux/mm_inline.h b/include/linux/mm_inline.h
index ab69b9930893..b3d85fe91385 100644
--- a/include/linux/mm_inline.h
+++ b/include/linux/mm_inline.h
@@ -50,7 +50,17 @@ static __always_inline void __update_lru_size(struct lruvec *lruvec,
 	lockdep_assert_held(&lruvec->lru_lock);
 	WARN_ON_ONCE(nr_pages != (int)nr_pages);
 
-	mod_lruvec_state(lruvec, NR_LRU_BASE + lru, nr_pages);
+	/*
+	 * Batches in mm/folio.c attach an lru_size_batch while holding
+	 * lru_lock, to apply the node and memcg lruvec stats only after the
+	 * lock is dropped. The stats don't need lru_lock and updating them is
+	 * a large part of the critical section when batching. The zone stats
+	 * are still updated right away.
+	 */
+	if (lruvec->lru_size_batch)
+		lruvec->lru_size_batch->nr_pages[lru] += nr_pages;
+	else
+		mod_lruvec_state(lruvec, NR_LRU_BASE + lru, nr_pages);
 	__mod_zone_page_state(&pgdat->node_zones[zid],
 				NR_ZONE_LRU_BASE + lru, nr_pages);
 }
diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
index 3b96d6c7123b..ac14f7118562 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -739,10 +739,19 @@ struct lru_cost {
 	unsigned long		last_io;
 };
 
+/* LRU size changes made under lru_lock, applied after the lock is dropped */
+struct lru_size_batch {
+	long nr_pages[NR_LRU_LISTS];
+};
+
 struct lruvec {
 	struct list_head		lists[NR_LRU_LISTS];
 	/* per lruvec lru_lock for memcg */
 	spinlock_t			lru_lock;
+	/* Protects cost[]. */
+	spinlock_t			cost_lock;
+	/* If set, defers lruvec stat updates until lru_lock is dropped */
+	struct lru_size_batch		*lru_size_batch;
 	/*
 	 * These track the cost of reclaiming one LRU - file or anon -
 	 * over the other. As the observed cost of reclaiming one LRU
@@ -751,8 +760,6 @@ struct lruvec {
 	 * serialises that update.
 	 */
 	struct lru_cost			cost[ANON_AND_FILE];
-	/* Protects cost[]. */
-	spinlock_t			cost_lock;
 	/* Non-resident age, driven by LRU movement */
 	atomic_long_t			nonresident_age;
 	/* Refaults at the time of last reclaim cycle */
diff --git a/mm/folio.c b/mm/folio.c
index 45c814f3857b..dc2c796a4ea7 100644
--- a/mm/folio.c
+++ b/mm/folio.c
@@ -64,11 +64,54 @@ static DEFINE_PER_CPU(struct cpu_fbatches, cpu_fbatches) = {
 	.lock_irq = INIT_LOCAL_LOCK(lock_irq),
 };
 
+/*
+ * lru_lock helpers for batches that defer LRU size stat updates until the
+ * lock is dropped, see __update_lru_size(). The deferred stats are applied
+ * while still in the RCU read section entered by locking, which keeps the
+ * lruvec's memcg alive.
+ */
+static void lruvec_unlock_irqrestore_batched(struct lruvec *lruvec,
+		unsigned long flags)
+{
+	struct lru_size_batch *batch = lruvec->lru_size_batch;
+	enum lru_list lru;
+
+	lruvec->lru_size_batch = NULL;
+	spin_unlock_irqrestore(&lruvec->lru_lock, flags);
+
+	for_each_lru(lru) {
+		long nr_pages = batch->nr_pages[lru];
+
+		if (nr_pages) {
+			mod_lruvec_state(lruvec, NR_LRU_BASE + lru, nr_pages);
+			batch->nr_pages[lru] = 0;
+		}
+	}
+	rcu_read_unlock();
+}
+
+static void folio_lruvec_relock_irqsave_batched(struct folio *folio,
+		struct lruvec **lruvecp, unsigned long *flagsp,
+		struct lru_size_batch *batch)
+{
+	if (*lruvecp) {
+		if (folio_matches_lruvec(folio, *lruvecp))
+			return;
+
+		lruvec_unlock_irqrestore_batched(*lruvecp, *flagsp);
+	}
+
+	*lruvecp = folio_lruvec_lock_irqsave(folio, flagsp);
+	VM_WARN_ON_ONCE((*lruvecp)->lru_size_batch);
+	(*lruvecp)->lru_size_batch = batch;
+}
+
 static void __page_cache_release(struct folio *folio, struct lruvec **lruvecp,
-		unsigned long *flagsp)
+		unsigned long *flagsp, struct lru_size_batch *batch)
 {
 	if (folio_test_lru(folio)) {
-		folio_lruvec_relock_irqsave(folio, lruvecp, flagsp);
+		folio_lruvec_relock_irqsave_batched(folio, lruvecp, flagsp,
+						    batch);
 		lruvec_del_folio(*lruvecp, folio);
 		__folio_clear_lru_flags(folio);
 	}
@@ -80,12 +123,13 @@ static void __page_cache_release(struct folio *folio, struct lruvec **lruvecp,
  */
 static void page_cache_release(struct folio *folio)
 {
+	struct lru_size_batch batch = {};
 	struct lruvec *lruvec = NULL;
 	unsigned long flags;
 
-	__page_cache_release(folio, &lruvec, &flags);
+	__page_cache_release(folio, &lruvec, &flags, &batch);
 	if (lruvec)
-		lruvec_unlock_irqrestore(lruvec, flags);
+		lruvec_unlock_irqrestore_batched(lruvec, flags);
 }
 
 void __folio_put(struct folio *folio)
@@ -165,6 +209,7 @@ static void lru_add(struct lruvec *lruvec, struct folio *folio)
 static void folio_batch_move_lru(struct folio_batch *fbatch, move_fn_t move_fn)
 {
 	int i;
+	struct lru_size_batch batch = {};
 	struct lruvec *lruvec = NULL;
 	unsigned long flags = 0;
 	struct folio_batch free_fbatch;
@@ -199,14 +244,15 @@ static void folio_batch_move_lru(struct folio_batch *fbatch, move_fn_t move_fn)
 			continue;
 		}
 
-		folio_lruvec_relock_irqsave(folio, &lruvec, &flags);
+		folio_lruvec_relock_irqsave_batched(folio, &lruvec, &flags,
+						    &batch);
 		move_fn(lruvec, folio);
 
 		folio_set_lru(folio);
 	}
 
 	if (lruvec)
-		lruvec_unlock_irqrestore(lruvec, flags);
+		lruvec_unlock_irqrestore_batched(lruvec, flags);
 
 	/* Cleanup filtered dead folios. */
 	if (is_lru_add) {
@@ -998,6 +1044,7 @@ void lru_cache_disable(void)
 void folios_put_refs(struct folio_batch *folios, unsigned int *refs)
 {
 	int i, j;
+	struct lru_size_batch batch = {};
 	struct lruvec *lruvec = NULL;
 	unsigned long flags = 0;
 
@@ -1014,7 +1061,7 @@ void folios_put_refs(struct folio_batch *folios, unsigned int *refs)
 
 		if (folio_is_zone_device(folio)) {
 			if (lruvec) {
-				lruvec_unlock_irqrestore(lruvec, flags);
+				lruvec_unlock_irqrestore_batched(lruvec, flags);
 				lruvec = NULL;
 			}
 			if (folio_ref_sub_and_test(folio, nr_refs))
@@ -1028,20 +1075,20 @@ void folios_put_refs(struct folio_batch *folios, unsigned int *refs)
 		/* hugetlb has its own memcg */
 		if (folio_test_hugetlb(folio)) {
 			if (lruvec) {
-				lruvec_unlock_irqrestore(lruvec, flags);
+				lruvec_unlock_irqrestore_batched(lruvec, flags);
 				lruvec = NULL;
 			}
 			free_huge_folio(folio);
 			continue;
 		}
-		__page_cache_release(folio, &lruvec, &flags);
+		__page_cache_release(folio, &lruvec, &flags, &batch);
 
 		if (j != i)
 			folios->folios[j] = folio;
 		j++;
 	}
 	if (lruvec)
-		lruvec_unlock_irqrestore(lruvec, flags);
+		lruvec_unlock_irqrestore_batched(lruvec, flags);
 	if (!j) {
 		folio_batch_reinit(folios);
 		return;
-- 
2.52.0




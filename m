Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 86E3DCA0EEB
	for <linux-mm@archiver.kernel.org>; Thu, 21 Aug 2025 16:35:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C63C98E000D; Thu, 21 Aug 2025 12:35:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C3A1F8E0001; Thu, 21 Aug 2025 12:35:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B4FE98E000D; Thu, 21 Aug 2025 12:35:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A05538E0001
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 12:35:08 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 4C26DB9311
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 16:35:08 +0000 (UTC)
X-FDA: 83801314296.05.C19BE81
Received: from mail-pf1-f173.google.com (mail-pf1-f173.google.com [209.85.210.173])
	by imf27.hostedemail.com (Postfix) with ESMTP id 7F40340011
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 16:35:06 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=JK8lzQsL;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf27.hostedemail.com: domain of ekffu200098@gmail.com designates 209.85.210.173 as permitted sender) smtp.mailfrom=ekffu200098@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755794106; a=rsa-sha256;
	cv=none;
	b=Yv/DQfFQAyNAh3uy3Ab3VfXlZwMW2AZZVirVcsnmrUmFkEcDw5RbktboKd7/kCoIzXISdM
	WxG7jGCVHZQ5kjyiabb82Q3QB9Omz+lbC7Ni6Rptzy3UY1lSkScazUT1yX88yeFKnvDHzZ
	RDL6lk0YE6v94iVtILJV0F6eTGopNQ4=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=JK8lzQsL;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf27.hostedemail.com: domain of ekffu200098@gmail.com designates 209.85.210.173 as permitted sender) smtp.mailfrom=ekffu200098@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755794106;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=flb2E4kjGcDlTRu530Vt8i5Q+Cs64zRzjln/3+D2F4k=;
	b=g9NuRU1wp3EBdSPVvYBjgkR3m9OsKNBvJqDrdfjt5WhueAI7GlG7v0oQE7ffgm4JEmwSyK
	E3/js7KLeuPIPhTkpg2rtxZ0QuKjgKfWhqguNuJluwV0oLz/3wkAguKDl6j3BBv61tb7jL
	7hmpJ35prhd0riVqmBkJTYAoKyvlPZQ=
Received: by mail-pf1-f173.google.com with SMTP id d2e1a72fcca58-76e2eb3726cso945338b3a.3
        for <linux-mm@kvack.org>; Thu, 21 Aug 2025 09:35:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1755794105; x=1756398905; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=flb2E4kjGcDlTRu530Vt8i5Q+Cs64zRzjln/3+D2F4k=;
        b=JK8lzQsLpTexVdF29d/aMoco8BmJmu3ooyKCCpshEty/xBiFelyP9bHB4EWIH7F+u4
         bnIrE9fj44pKgsRsW1ytgfGUUJj08f1eYDc6gr0Aio1PHFFnNoxOOauDJ8Mu4LpH+JZQ
         CG5QE1TEnlAGRugPeVWTVRqeWLgq41A0h2WqvY0WqUsnMOYtExaj+SSN/SJR+jSDpfkE
         HIP+Vn+DRHqHHlLz9ZjJN4UEmblyiD1THjBXNMhgrn+zZrtZfRIeM9JdewoccQAmoVxI
         Bl3amKPXbcnCi/JOC3Jx9rqbzHpmYgNJ6hNe6GiDE67j6QNSt0hfV8nLtcxC7K3j26rS
         qiyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755794105; x=1756398905;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=flb2E4kjGcDlTRu530Vt8i5Q+Cs64zRzjln/3+D2F4k=;
        b=MWQqiklGVxgMaXNra56vRZzQioGFwzJbnUX0izlNQ/8moqGXMpKX14epkejkCRbZuQ
         TRkEYj8Bh1iMrZNYC27mAYxNn7/avPQ5te0tTQlExWzQWrF+xZw/sq4N7I6wZ0CHLyqf
         JwhcNqvwW0fQOP4XRsOCO1saRby19CBC6JnqUnY+Q3QsdYwlzjKmvr+LniIhrLSwxjfY
         dF5OCI3WcfhPuniAgBaYM5iv8ncqAeVCmI+OAkXXEyz4l5xJIPrxFys1GNU6N4arnvmm
         XFf68AZje3vugqiigXD/7VTQINMEGsewk9Rg6+aHatWwKmVP8F5W0CyUgqYkVugT/L11
         /mnw==
X-Forwarded-Encrypted: i=1; AJvYcCXqvAUflc1bFS6x5vCC87n4j0HLfEBTA6oq8YN+5KPpUGKI8xmy+i/uO5JR+qtiC0te4hmKrDkMmg==@kvack.org
X-Gm-Message-State: AOJu0YxYRxQNE+oCahXJZrHkW7EWBciGC+9fW43grsZmWrswsCGQY/bx
	+qpZ9Nw5z5GM/1XDg1Ler6TUOdJ5cOVZmuRUxBQOL731uGPbZJU84QSq
X-Gm-Gg: ASbGncswUAfE4SwejffTbYUWyRTnZlBfgDaq5CUd1Lj7tAOWGi2lyDPEWphTZ9sA7qt
	VLm/YQHqn1fNtibFvx36jLHxffNcMADW4j3mtcQrBKurAGIhdKUEMKGJL8gODLeLiqXhxv8lJuK
	AAtECHX6XycJwOev3tmhbXYJDOOu5zRM4Q0CkJGK4y1jw6CIQvUcqhyOfrIy8EXmej473/nymUM
	/vyPIkK0LavOVerOmNe5zKqT20RyrKiRCwFgh5WSiOMqIuW8T7m6MYkPTqt8GjA+ttdzmXiZXsw
	8g9OpK1FvhDTlZlPMqMuLODkay3lN8HBTZFhXXIzfy4TV5DcQ2eYGauB+/Uy1VLEnw/br3p0hME
	m6Qatdg1/TwUWS+r0
X-Google-Smtp-Source: AGHT+IEoK20LGwps1UI3qxtBzFuC2UZywh32woD/WzTb07rAX67EwMDZ7TmGCqkdLFk9tfZL3IepkA==
X-Received: by 2002:a17:903:120e:b0:246:1c6a:7026 with SMTP id d9443c01a7336-2461c6a7131mr22258645ad.40.1755794104962;
        Thu, 21 Aug 2025 09:35:04 -0700 (PDT)
Received: from ubuntu.. ([110.9.142.4])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-76e7d5242dasm8704422b3a.77.2025.08.21.09.35.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Aug 2025 09:35:04 -0700 (PDT)
From: Sang-Heon Jeon <ekffu200098@gmail.com>
To: sj@kernel.org,
	honggyu.kim@sk.com
Cc: damon@lists.linux.dev,
	linux-mm@kvack.org,
	akpm@linux-foundation.org,
	Sang-Heon Jeon <ekffu200098@gmail.com>,
	stable@vger.kernel.org
Subject: [PATCH v3] mm/damon/core: set quota->charged_from to jiffies at first charge window
Date: Fri, 22 Aug 2025 01:33:46 +0900
Message-ID: <20250821163346.1690784-1-ekffu200098@gmail.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-Rspamd-Queue-Id: 7F40340011
X-Stat-Signature: jx8quzymn1gk1m19cuet5w9tuuupq4jq
X-HE-Tag: 1755794106-654749
X-HE-Meta: U2FsdGVkX18XgSFQMKBMHtx4ZJ7t5mtFFEZT5pGYRKy4aX5be3LUAli+eZyWyi/XeHhjib+Jbtnvs0+zNPTVjB8wNdLpT/4f365m0C3E76Qx2JJKpDJmNa24Dl5MycfKjVAGHIe00gmjrla93Uq+7cZiJ6KPXfUryhb0FtO5Yqj7M1wcV63SiWWgZF0Lfy66A0ChafC84n/TY9Q1tmy7eaYVPZ76tuiCI1Wga9MNz9VLIwWlzIPRTirByBOSrFOUUp5D6LflyWEU8+n3x4E7w/q03NzxD7z+4RhyWX1jyeGT4qDxYZpBEgPGYts8MeLm0R8pcFn39pn5eQnVHTLHUExNj8309H2wTNkz3x30Ey/0parpAawYhSi647z7EkYUyWtOD4rmJYjdfTsnL0joPbBmYx+MnfqCbRQJSNelbyJEDgVQWdB1d1BKiNu/d3S7QHX1wmENC6MHvaOqbTJy3TRDucUe+GUenVJgjGNTwGK8STwuU1RvZlhmou4Y+KhTC07jxxLPlXc8wqtnuV5jVesWKO6+VoDS3uRorFE0+CaYPs5CosBfl4XvO1oROctIi9SJihyofJAJBRmPzXI76fk0iD8TFaxCRzimM2YGxBqf/AApa0mk2bB9hjkh8z4J6V55oQVzIGShNqW6zUEbnJb6vOfN+/CeqGuTVsd/LlErLRshh5WeTWiFXDsFmwm3djGJulpNUow+3J8MNWY2yP6wvLah/6qQpNne5455vqeCNTLb2StLv0MTWBpZiPWP8CoqWwnJMZQdg/zfju0rtyGaCXuXrACsMoIt0+iicCPy1b9l8/tekmxL57CKgwdHQVXgKkaVR5YjKB/6PsePqYxT4NVr1Z5GAy4nW4KcGCxKdgoUxSjWJ3b36oyL7f1kvyYSHVvVc1R/QbClZV/IJ7mXmeUpyY0YRlwCandd8I+qb1FKwNbRGvtvgIa3G01csOIaOALv543mjM1Brgk
 qkOovQOX
 HyB6T6Z5nB3RsWYcDO2Dre2UY9m6TD6UfJaRScEYaM3fKI5BsJZempvGbahPiCXR7FMnjE7ljA4QdSf2sAc90aZqMCVX5N3ZliNn6yFrNkpa+VfILlbcksrn3c4sbH9m5DHBmTvnOnuwobmPUcxcAL4qPXDxu84SbRkbmh01SO5t6LyUSRecbVOuDqYQ973PbkwKBJH197+dH9TZqGukBc/7W5Pm90T4pDj2Cx1UGVtD23pU5mZOi9j3hgGG+tZ+KZBVGObjNVY+BxW20UPJkz0ASPo7mYdB+hj8k32NvBfTC+2MNRtAhQ/+ufvLXUt624566L+xJo3WUDbX/FY2FEllIh+w/mHlyPXg6mk4ASGsFCO6wsrkgwtQpJtQjZDNLZqzpIEfbyK/C6Oh/aBF7yAZcLKl2fsdP0QwEKMkWN1kEJc0YeeRNTN/8dBTMhg3be0dZS9g0nrZCL/haHoxmA1tJDVd7Nfsa57t4tyenCNB4Pwk=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Kernel initialize "jiffies" timer as 5 minutes below zero, as shown in
include/linux/jiffies.h

/*
* Have the 32 bit jiffies value wrap 5 minutes after boot
* so jiffies wrap bugs show up earlier.
*/
#define INITIAL_JIFFIES ((unsigned long)(unsigned int) (-300*HZ))

And jiffies comparison help functions cast unsigned value to signed to
cover wraparound

#define time_after_eq(a,b) \
 (typecheck(unsigned long, a) && \
 typecheck(unsigned long, b) && \
 ((long)((a) - (b)) >= 0))

When quota->charged_from is initialized to 0, time_after_eq() can incorrectly
return FALSE even after reset_interval has elapsed. This occurs when 
(jiffies - reset_interval) produces a value with MSB=1, which is interpreted
as negative in signed arithmetic.

This issue primarily affects 32-bit systems because:
On 64-bit systems: MSB=1 values occur after ~292 million years from boot
(assuming HZ=1000), almost impossible.

On 32-bit systems: MSB=1 values occur during the first 5 minutes after boot,
and the second half of every jiffies wraparound cycle, starting from day 25
(assuming HZ=1000)

When above unexpected FALSE return from time_after_eq() occurs, the
charging window will not reset. The user impact depends on esz value
at that time.

If esz is 0, scheme ignores configured quotas and runs without any
limits.

If esz is not 0, scheme stops working once the quota is exhausted. It
remains until the charging window finally resets.

So, change quota->charged_from to jiffies at damos_adjust_quota() when
it is considered as the first charge window. By this change, we can avoid
unexpected FALSE return from time_after_eq()

Fixes: 2b8a248d5873 ("mm/damon/schemes: implement size quota for schemes application speed control") # 5.16
Cc: stable@vger.kernel.org
Signed-off-by: Sang-Heon Jeon <ekffu200098@gmail.com>
---
Changes from v2 [2]
- remove unnecessary example about time_after_eq()
- remove description of unexpected reset of quota->charged_from
- clarify user impacts and when bug happens

Changes from v1 [1]
- not change current default value of quota->charged_from
- set quota->charged_from when it is consider first charge below
- add more description of jiffies and wraparound example to commit
  messages

[1] https://lore.kernel.org/damon/20250818183803.1450539-1-ekffu200098@gmail.com/
[2] https://lore.kernel.org/damon/20250819150123.1532458-1-ekffu200098@gmail.com/
---
 mm/damon/core.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/mm/damon/core.c b/mm/damon/core.c
index cb41fddca78c..93bad6d0da5b 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -2130,6 +2130,10 @@ static void damos_adjust_quota(struct damon_ctx *c, struct damos *s)
 	if (!quota->ms && !quota->sz && list_empty(&quota->goals))
 		return;
 
+	/* First charge window */
+	if (!quota->total_charged_sz && !quota->charged_from)
+		quota->charged_from = jiffies;
+
 	/* New charge window starts */
 	if (time_after_eq(jiffies, quota->charged_from +
 				msecs_to_jiffies(quota->reset_interval))) {
-- 
2.43.0



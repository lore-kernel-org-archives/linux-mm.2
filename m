Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 58586FD377E
	for <linux-mm@archiver.kernel.org>; Wed, 25 Feb 2026 18:39:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B8AFA6B0089; Wed, 25 Feb 2026 13:39:12 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B41AB6B008A; Wed, 25 Feb 2026 13:39:12 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A5B366B008C; Wed, 25 Feb 2026 13:39:12 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 93E496B0089
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 13:39:12 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 30E7313B864
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 18:39:12 +0000 (UTC)
X-FDA: 84483841344.07.FFF5FDB
Received: from mail-wr1-f51.google.com (mail-wr1-f51.google.com [209.85.221.51])
	by imf03.hostedemail.com (Postfix) with ESMTP id E119B20013
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 18:39:09 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=MxgxDh9j;
	spf=pass (imf03.hostedemail.com: domain of mkoutny@suse.com designates 209.85.221.51 as permitted sender) smtp.mailfrom=mkoutny@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772044750;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=XOpGuwqZTKF6bz60SpxWW0lS1c9nYBDcqJqzi/pIY4Q=;
	b=Z3rfmMln2vVoqhU5a1mug742LI7Eya9P3+sqPRcPEuyUDY3VwPXnFrL6tJlvomczeW7hCC
	kM0d7/6+Gmx2ERFVhjjXHrWr+Sci+WtxHMWX1JQqvMY761Qd1ely19Vb2uGQTeIgx12u6A
	D1DA/ydDmKU67E9HCPAlg1IdV3SutSg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772044750; a=rsa-sha256;
	cv=none;
	b=N71/IZLNKky9iqZ3hyvBOUwCDiqC+WmyrNRdCCwKx6CcGEd+NKlkUYNM+g5W1V54ETzPGf
	38+aUnNnlo6ma0IqIquSDPxp3npJbpYScVJLJ8hsL3jvKBOnMcxCTDFL3a21VQ4XAFEPA7
	boy4CdaaLxRAI50uKrnWUSOes0R9lr0=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=MxgxDh9j;
	spf=pass (imf03.hostedemail.com: domain of mkoutny@suse.com designates 209.85.221.51 as permitted sender) smtp.mailfrom=mkoutny@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
Received: by mail-wr1-f51.google.com with SMTP id ffacd0b85a97d-4398f8403edso20730f8f.1
        for <linux-mm@kvack.org>; Wed, 25 Feb 2026 10:39:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1772044748; x=1772649548; darn=kvack.org;
        h=cc:to:message-id:content-transfer-encoding:mime-version:subject
         :date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=XOpGuwqZTKF6bz60SpxWW0lS1c9nYBDcqJqzi/pIY4Q=;
        b=MxgxDh9jlKrd5OEDQFf7u5CkXqTD6O/nz1+Vd8JmvGruue0NB2g0LHOR/8hVJtoKsh
         gtaFJ25NoXom27M7yVCs1nb3ZwwaF7Lr0Di4RNOGY9XXeuke65zvbJ5Ts5EGO2vOiLdU
         VTH09NbyC3RS1tON/pUTkpiTp18ToPbjgRIDUtkgzMrJOiUhdCrJkZn01gzBoJdbkFlu
         P0m36XTI061Rh83xvmc7qdkhZDmF5Z4HhU0H2yyWVdyj5vvIhEWx0IT5QoAt4j9QM42C
         blV0CS+xaIwI0p20NmGS82y3EDkP0x1Yy4MgnAOAWrN5MA2Axu5v8Foq2tTwfejQ7YFR
         BdDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772044748; x=1772649548;
        h=cc:to:message-id:content-transfer-encoding:mime-version:subject
         :date:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XOpGuwqZTKF6bz60SpxWW0lS1c9nYBDcqJqzi/pIY4Q=;
        b=OhU2BEB1TEIjiLyn7PpHV9WKaDNnGC+hD191uTK979u2Fy8tmsX/TXpMEtqsSnJM7i
         L+EKppVowYl2AeKJbN1mGuFMUEIWpbezyVICurMI6ggPuEMEtvmBjHRO7Hc5cEwDOKgR
         ZsA0KLNImoLfb96lkcA7A+e4ToCW0XBPdszNDJtIaG2OlwIQcBWdop/JdOy42Ax3Psh0
         fs3siS19h7NA8zq3lzvubQagEtRalTNFQzrJBj1UCZ1zycF1A7UzaYIFUs6ajCVHSRWX
         9c5FRkE9Ju17Mg9d1nueYIHQdW1NvoMIpZaromK+Br5z9E1b4nvwEtTTGYeIa2hZAEh4
         RCmQ==
X-Forwarded-Encrypted: i=1; AJvYcCW3bSy/OdNxwNzvBMRNDAgwjnhEwGLZk8rvoPkfvgjU5YyFXUuQmkLBSppfirUNDHkT+Lo/l/PZFA==@kvack.org
X-Gm-Message-State: AOJu0Yyhd4rLJARFR2BMpKJmS57L608ivEa4gWDkoXHG73GyzB+Dc3E6
	94TAHp8UYoparH4nSLAmBL7tXtj5+KnEc3AZzqBbr2Kqssr5OK2Vh5KLF6XCQatKUgU=
X-Gm-Gg: ATEYQzw5VxuABgIBbO2hHxWwnh3jsMxRM/ORXh21dFQAR3Vfz76xuzaXiGj7w6eozxG
	JcGwjGnPDuA5NAjqXWqDZ/b3ZoSWmipcWsZngSzY4PJbnM7Kglka43QadnNQ7dUIJI6s8xDwsGc
	10fEQhQ8QLADjWTM5Cw0cIdOVEWLde30fUa6dNujBBYOr+8OO0i8bCnztQJ+7jsIVeF0gaN3m1D
	cA/u7cCOCVXAqCB53k+MGTUqvzFKlinyX7zP2xt2nznMgO0Ug/5YfDu5oeWe8irtnNGPMm0xdKg
	4jThz56yNACfmvWMyVb3CwpfzoGlY/wNoPJXIId1cuwdxgYfW/OLgJI32pQ9gdHTzRlM5ps8bjE
	nAD5uPBUHlxnjMA0FcUvxNK/txbhLdCUNDWYiwMoTy5DeK/J+lSToJPfXcfxzkpjQELUZtqhXcG
	/iJ0e+D8AmzVJWzStZiWBgPLNX1m2VQz4KkmZYcPWbGZU=
X-Received: by 2002:a05:600c:524b:b0:477:7ae0:cd6e with SMTP id 5b1f17b1804b1-483c2168d6dmr27534795e9.5.1772044748156;
        Wed, 25 Feb 2026 10:39:08 -0800 (PST)
Received: from blackdock.suse.cz (nat2.prg.suse.com. [195.250.132.146])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-483bfb29715sm44245515e9.0.2026.02.25.10.39.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Feb 2026 10:39:07 -0800 (PST)
From: =?utf-8?q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>
Date: Wed, 25 Feb 2026 19:38:44 +0100
Subject: [PATCH] mm: Do not allocate shrinker info with
 cgroup.memory=nokmem
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <20260225-cgroup-ml-nokmem-shrinker-v1-1-d703899bdda4@suse.com>
X-B4-Tracking: v=1; b=H4sIALNBn2kC/x3MTQqEMAxA4atI1hNwgn94lWEWtaYatK2kKIJ4d
 4vLb/HeBYlVOEFfXKB8SJIYMr6fAuxswsQoYzZQSU1JVKOdNO4b+hVDXDx7TLNKWFixHU1FbrC
 ucwS535SdnO/797/vBzJkrwFrAAAA
X-Change-ID: 20260225-cgroup-ml-nokmem-shrinker-7da42fbcf8f2
To: Andrew Morton <akpm@linux-foundation.org>, 
 Dave Chinner <david@fromorbit.com>, Qi Zheng <zhengqi.arch@bytedance.com>, 
 Roman Gushchin <roman.gushchin@linux.dev>, 
 Muchun Song <muchun.song@linux.dev>
Cc: Jan Kara <jack@suse.cz>, linux-mm@kvack.org, 
 linux-kernel@vger.kernel.org, 
 =?utf-8?q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=openpgp-sha256; l=1767; i=mkoutny@suse.com;
 h=from:subject:message-id; bh=vCSUMFDcCR7TTirWzMfGTpmIOE4hV1UFUHSUFG9Fiow=;
 b=owGbwMvMwCVWZ8v0fMrtHxyMp9WSGDLnOx47cJpF7FzoCh7ZH/MTFX49nTiD4+ACtpjANM83o
 c+qNM3NOyayMIhxMViKKbI4Ceexzv8g42Z5uusLzBxWJpAh0iINDEDAwsCXm5hXaqRjpGeqbahn
 aKgDZDJwcQrAVP/5xfBX8KBMyIaes4ce8EefZ7QMiq/1dDNOqkzT2npLLarsUNBVRoZHXGqLOY0
 qGa3zGt5qXZD1NUq55Tn/m495SPwJvZnKq5kB
X-Developer-Key: i=mkoutny@suse.com; a=openpgp;
 fpr=9F2AB6F1F2BBEE7621C1B620CFDED9A2FD1314F0
X-Rspam-User: 
X-Stat-Signature: ua7ewtzetat5zxbg8j8y96mjwtt3ms1h
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: E119B20013
X-HE-Tag: 1772044749-784274
X-HE-Meta: U2FsdGVkX193Twpr8lRyprlWW3zPfMXXQsMRba6s/nw8+XrFcekIbUS8HszQfaBGr6cmREcdIpnVbfj5eGYkMROiJkV6KRtv7JLycdrx0HBAVhdjCf5d9zFMpy6ZBPy6PIGURamPTWSgLFFKidaO1nlWpLgSaPP1bdKWLcoO4ucC2qGJ1kaciss+THDDLhgSqeS49PeJswiczUKg8NguppxRl2jkEsUn+HmWZrGw7GI8/Pl1MwLteAVhB0tWIXjPISc4fPh8K/5TyaBmkq812hHJcLr/8MlC6X83yq8UFa9p55QE/YrBZVNoEmuYglSK/dPZIJYMtkZHIvx/j2N73+0hbO8UwRiWMpNnHKlU+h+MJeRNi9wOsTlSjxo4X+4IPa7s/3f6+odia0/lJbx9Z3W0INGREQ96BMqgg+c/FPwD7hiDNMhPxDy9ffsPb/c7hFEySd5Rs199aZoAWGt50LJRYmnbh78q8PXWmvoiGoaTTIMo5lydO774leofNkxCSeb5ISL9Z2dEV5hse5yHF85XjFABEQ2Z1BEr0gmMPxq0cyN7eBCC7QVXUqK6pXVrNmWSU2MFzuRXbIKaVePEcvO0oDJ40EZw4z8+Fjia0TivVBYeD2t4OPtOswmM8A3SaIBVpGhHuHzI4Ncyi0L/xG6P+EjUWDQDNyqwcpKcf+qSkkzdsHVOhFoPXADh1DZDx9B1cQOJksTL44Zg0X/6z4KyMOphU3ZCvKwL+8y51QuCtCJb1uGUD540RUGBUvo7qdMiP0fgHzUExKj4kGT44o+YILOA0hu9jI/f3njizyboa9FWAw2OQGGX7C7mNEj5WfTLUmRIBvLUIt1o5PcHjVAyQb7wog8LNG/FyVWw6PGSy4aJf8aDH6cVRzw6R5TCaW7D1dU2g7yh/9K6wAfL8sCPagjZoOrT+nkJ/EB/uSpwoLUgPYzgy19DI4TIlPssB/CquChZv6XLAmrY1jX
 /uIYi56d
 mS2oFOQPn4lyI5KL+whfms4jac7ySzcH1CoDbcP28DwwFqa88/yqJjQgMa42JV3fPbpU28wD7gR/pNdIrI2kWZ8oW7/iHhvQvc34Vk22FANIDaz3snCWY/w3ThVXrmvMo6Sxim/qpLPL3xwgEiq8CnHueabLwzcr7RSunyU4vwWNUVEVzhFt5WkKwf4eWiqT50kvc2jM6g1EWTVTrAi8lMpCT6iutzGAAE4HRusWefT2CjLj90t1brmQNiU6lRdsKdLetWSGi70x5BgTSpes/NXKo7T8r3qPc5eajJTtaFgvY1vnJifXArxiggGdtBsPYgBPSOSpSyoF0g4FqbZ1W+zW7q2E/6nsR+lhJ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

There'd be no work for memcg-aware shrinkers when kernel memory is not
accounted per cgroup, so we can skip allocating per memcg shrinker data.
This saves some memory, avoids holding shrinker_mutex with O(nr_memcgs)
and saves work in shrink_slab_memcg().

Then there are SHRINKER_NONSLAB shrinkers which handle non-kernel memory
so nokmem should not disable their per-memcg behavior. Such shrinkers
(e.g.  deferred_split_shrinker) still need access to per-memcg data (see
also commit 0a432dcbeb32e ("mm: shrinker: make shrinker not depend on
memcg kmem")).

The savings with this patch come on container hosts that create many
superblocks (each with own shrinker) but tracking and processing
per-memcg data is pointless with nokmem (shrink_slab_memcg() is
partially guarded with !memcg_kmem_online already).

The patch uses "boottime" predicate mem_cgroup_kmem_disabled() (not
memcg_kmem_online()) to avoid mistakenly un-MEMCG_AWARE-ing shrinkers
registered before first non-root memcg is mkdir'd.

Signed-off-by: Michal Koutný <mkoutny@suse.com>
---
 mm/shrinker.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/mm/shrinker.c b/mm/shrinker.c
index 4a93fd433689a..7d7302619b7f7 100644
--- a/mm/shrinker.c
+++ b/mm/shrinker.c
@@ -219,6 +219,8 @@ static int shrinker_memcg_alloc(struct shrinker *shrinker)
 
 	if (mem_cgroup_disabled())
 		return -ENOSYS;
+	if (mem_cgroup_kmem_disabled() && !(shrinker->flags & SHRINKER_NONSLAB))
+		return -ENOSYS;
 
 	mutex_lock(&shrinker_mutex);
 	id = idr_alloc(&shrinker_idr, shrinker, 0, 0, GFP_KERNEL);

---
base-commit: cd2e103d57e5615f9bb027d772f93b9efd567224
change-id: 20260225-cgroup-ml-nokmem-shrinker-7da42fbcf8f2

Best regards,
-- 
Michal Koutný <mkoutny@suse.com>



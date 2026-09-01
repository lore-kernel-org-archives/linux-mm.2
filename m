Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9A9C6C624D3
	for <linux-mm@archiver.kernel.org>; Tue,  1 Sep 2026 16:53:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AE00F6B00A4; Tue,  1 Sep 2026 12:53:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A69246B00A3; Tue,  1 Sep 2026 12:53:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 86DA96B00A4; Tue,  1 Sep 2026 12:53:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 589546B00A1
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 12:53:32 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id D34581404A9
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 16:53:31 +0000 (UTC)
X-FDA: 85165789422.27.2ADAB1B
Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	by imf31.hostedemail.com (Postfix) with ESMTP id 1946B20004
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 16:53:29 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=fp75MEXO;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf31.hostedemail.com: domain of ekffu200098@gmail.com designates 209.85.214.182 as permitted sender) smtp.mailfrom=ekffu200098@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788281610;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zLxdIeL3CrxbJdHdwQq7AqwqMv3skQXpBgUpwkYf6+A=;
	b=qM9P7JgIhjuiU4DiqDCokFUknsjOsx288zHasVqiBXCPaLNnVoIhNwUHhHwlb+awi5j0ib
	cGMFzg0l3+TclRGGQbbAsetAW9oRXZKPd69iQuus07f41434rPUBI1RKhBszTM+gX8KHyn
	Fst4VGwwAtFsUZ90yUvEuqkUZstk3b4=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=fp75MEXO;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf31.hostedemail.com: domain of ekffu200098@gmail.com designates 209.85.214.182 as permitted sender) smtp.mailfrom=ekffu200098@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788281610;
	b=ox5Fx5oq7l+7r6b2SS8hv9a4lR4oEDeDFjMdVFbIkPNX6hmH2mTOSyeyrn2zBLIutcmp3L
	xGiXsnl/AXC+jjpn3cbj5AICUQ2gp5/dUP2uEz4b73qu4wiy6Jg8e00p/cKiUhw/UtQTqF
	8KFssjaaGRrX1/4wv4sr+pQnu859a0s=
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-2d7200b2e15so53581625ad.3
        for <linux-mm@kvack.org>; Tue, 01 Sep 2026 09:53:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788281609; x=1788886409; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=zLxdIeL3CrxbJdHdwQq7AqwqMv3skQXpBgUpwkYf6+A=;
        b=fp75MEXOnfjXIwo6lHyoImKv+VkUw84l+8OUf6O+6NqhJDM1UGKqxgfeGGihKIg0Dn
         neAMmxZRGR58LjXazZbb/Apf2oHBeKyspGaw+ziIBTsgyN96WZZSGdff0HDMkb3uFBo5
         7lBrSgtcY9DUnnpcsCwMobaoKbW70sB+nl1BMQvMzpjl/kL+J75q9tkHOLBbdIszjkOQ
         jSEjnPOXNFEhEZ3yXJCQh+3VVOJmlUfZI0uahVw3gk65WtchjFwLaTohRUuW5HVQln4F
         hLqa9L+ganc9VXPQnXxv7DegCNusjSp/N1a0fNGd8Rteal5FcAfipofYAkGJ+hfQxzq7
         IQQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788281609; x=1788886409;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=zLxdIeL3CrxbJdHdwQq7AqwqMv3skQXpBgUpwkYf6+A=;
        b=NsKJSHe0lZKQYeHOmaCTcUVsZPIJkoF309x+erJa0fIorMFVWbIDSDGPdfoxwHhrmM
         g920rTGJ5KLGqS/mU5ePAyZH3FEaDYnCV7y1hssjuGd5pwWMOdlQ+ld5dpjL5cmMkqnC
         f7duVdrZe44KrnVc9s8lUmf6J6c+hpRpnmigSTW9vJUzMlRnoYZ7xUFnmkB7yh9tfnFb
         CNj9I0iq/Mew32x5FELFlzDJZqu9Vk18LhmfeuVgUnz/gXDzE7H4F8xpJQtatu63d/zC
         2CUCtHnbeZ0mjsqLTIMQyBNTeKXH/TvvsvaXGkPGLT/obw3SvHBgg6alauuad5Em0WzL
         ruJQ==
X-Forwarded-Encrypted: i=1; AKwUvBz7MRNN+FTbnAII2QRZyrSseLcotoQ9+uwaV1nTidDhjNW410i7OjQ49RZgFJT/Zj6mT5AjS3o3wA==@kvack.org
X-Gm-Message-State: AFuF++npJSBqjMxYKgt7JKu9g69y1WuojEtIxl1mPQIjOx79EQk8PUkq
	1a7D9zcdd+uUj+0Kv3JGCIZ1bkSFNDT1YRGx++qlsd0lcZEfvtIA/4MiOD/WOKBu
X-Gm-Gg: AYBFou3tm16qxFGZ2dj2wfvbJy5GkiSddxEzAOU3Vgp3GK+LdjBaMbhKqLpr69S7ill
	r0Yk0J1eql6AEZdfV3ndPZgw9+9NFm99MNvsaCzpPv8VstipjXPsL+t6b7DXWpnQjrJPy/VV7bn
	siadtJC0KGuKQ3MgTRTL7ggoRu3Na86/+q1bKUwtZfCfpEK5jqq4fiZplFf1392msfECzubvtth
	0lanro8Ptm3yE3GOvn/zSaelEYDo0+r2OkZzKhbs5hbclPA5RkZy5qwJdu12tknNlXdrhzuaUu/
	yvXf5aRt/EZnXxsRpp2tbXQwLwjXx/gvTeOJz/Hq9EJ5hp17P1NsXFv64sJL595LMRW8LQ0AHg9
	W58JLGePQYEpVUYvXi8KMJgjWvAKSCvnY2YeM2kePDx7vMwKZsDwoNMJCHZU1cCWu994TkjwQbJ
	LFW/d2uO4t3P7MFL8OHrquMDCIxocjnZpIexSSh3TfrXevfXzhNRmHyg0=
X-Received: by 2002:a17:902:cf0f:b0:2d0:cc92:f7a3 with SMTP id d9443c01a7336-2d94a703f61mr138707735ad.2.1788281608492;
        Tue, 01 Sep 2026 09:53:28 -0700 (PDT)
Received: from ubuntu.. ([110.9.142.4])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2dadd357efbsm1762325ad.4.2026.09.01.09.53.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Sep 2026 09:53:26 -0700 (PDT)
From: Sang-Heon Jeon <ekffu200098@gmail.com>
To: Dennis Zhou <dennis@kernel.org>,
	Tejun Heo <tj@kernel.org>,
	Christoph Lameter <cl@gentwo.org>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 3/4] percpu: remove unnecessary cpumask_clear() in pcpu_build_alloc_info()
Date: Wed,  2 Sep 2026 01:53:03 +0900
Message-ID: <20260901165307.1026248-4-ekffu200098@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260901165307.1026248-1-ekffu200098@gmail.com>
References: <20260901165307.1026248-1-ekffu200098@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: bhnsjbwdo3rqxbugi454953fmdn3ad8g
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 1946B20004
X-Rspam-User: 
X-HE-Tag: 1788281609-45711
X-HE-Meta: U2FsdGVkX18uchhVlDZF0DCgo21dmLDcbbhYrBsvHQRlb1bRoEu9KsMTnxdBY1Ikw/xYGX47i5KAGzUpmA76yjGj+wkScXc9LiPyQeJ9SAOtaJs8Vi6q4wnBb5Sug1T0LAnZx986HFFVn6w70W92UYhqVdJ+c1498oj0W6fVN6WcgNkFn0cWRyonHwZT8S59xel+iBqi3dw1Fxe9tPQDmxdXBH5KTRH4L7OcgxfB9RvBE9VgacLoa4OUpmQ6esUfTL61NJgQIjxcVa2Go17aMBdPC+7m44Q4rtUY/vna1IaUL+oycNrT7tAR2vdkX2rrCC0m3SgAcRzHBqTxrAt0WRuFX/WnKuNC94gagSbS+ZWgMEjhiEHJWpJRKpe1MOHfbm2dkCl5+npMnJZWcn0HKd9HIFflTcF5oWxDSdIsecMghDLQfiOP/EPX3ZsZd6mIvoANQb+z/0JpEK5515eYnSWzjzLURpPkU8oY6cu5sZw21KQiAMCZNEeEeoS+E7zlhVdvZsmryjPcJ5daOo/rKCBBWE3EsLWEMgMCLCRFJ8o9CQIMKpNmuvy63WQJEEB08lY1UAd5BFnkJ1f6i0EPEeudE7P6ELoccOt3jce4bCn/riyV7V2ow79EUXSxM2+0Z5GZw7sqVaTw2v2EM4LLsKiLW9XilNhniC0XP2qbH5WQW+NIapS3I4ZaT4T3pFGQuf4AKmZ6FxzQPOmc3tZVpJgEaznfLU3AOaRdgUuCLFL5Kzhcqip6PB+P2uO0ivlVjz6mF9Ol0j/ZhugkZobi8BNY5IlRjmjf3Xy1f1md4fJAwqogDX8KxxwS/IS3a42eDYXyyMgaCd9YvAo+CPuy8efXNwd53oG4CVkrW9fN499QepBPbBEN4VcPCBpfzwd56KsDjzEFeO7yMqKfI/GjbcyBQVl3pWCVoCZBfCiBbeQNDmL8wWTJ+fnHXEMRO5Hw2n3MQyue36ky5sjL88o
 anNlZAfR
 ohn87S3XCs9sjTR2kByFod2xL0Y84c3wueYKj+cXf/Stnz/YzcMvuo8vYVgLRooHjnDEnsm/XehWQrUa+zkMl7XxCbctFYpVt7WFnWSbAoJnuVMpyRuKZzESJDgrY9mRUyylJWoPFtKVPmR05KLal98UrKNz9DkOOA4rSu3X6Bim2h8kEqfNRnuuM8SJeetOJJbnzOnOaPfQFg16g2RTszXZ2uqhIPgbdTApc257f21lF2fULqmNZuFOGFRDMtzVYBy8/W2zKAiJgl9V1UGViapzcI/uvrpv1gURiBt5nwkM+g5MnS/WvTBXXnH45yNrjdA5xAAeH3qLUG+pv8joiOpPDSjNOKAHjS/O4zPbUiV8VzdxtZvJTit2KliIy1CvWnK/vovoTHd9n3GAU2duXlX2CETmIjgE0o2PijUm31C2i2XTghfa16yyPX+9E5EXwfF9oQcG6taDMEsg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

pcpu_build_alloc_info() clears mask and unconditionally sets it to
cpu_possible_mask. Nothing uses it in between, so cpumask_clear() has
no effect.

Remove unnecessary cpumask_clear().

No functional change.

Signed-off-by: Sang-Heon Jeon <ekffu200098@gmail.com>
---
 mm/percpu.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/mm/percpu.c b/mm/percpu.c
index f222b43cc90a..45f3e3fda2f9 100644
--- a/mm/percpu.c
+++ b/mm/percpu.c
@@ -2828,7 +2828,6 @@ static struct pcpu_alloc_info * __init __flatten pcpu_build_alloc_info(
 	/* this function may be called multiple times */
 	memset(group_map, 0, sizeof(group_map));
 	memset(group_cnt, 0, sizeof(group_cnt));
-	cpumask_clear(&mask);
 
 	/* calculate size_sum and ensure dyn_size is enough for early alloc */
 	size_sum = PFN_ALIGN(static_size + reserved_size +
-- 
2.43.0



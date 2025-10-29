Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 24FD2CCD1BF
	for <linux-mm@archiver.kernel.org>; Wed, 29 Oct 2025 01:44:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 535BA8E0024; Tue, 28 Oct 2025 21:44:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4E68A8E0015; Tue, 28 Oct 2025 21:44:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 423F18E0024; Tue, 28 Oct 2025 21:44:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 30BA58E0015
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 21:44:25 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id D0C13BA869
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 01:44:24 +0000 (UTC)
X-FDA: 84049456848.18.07AB5D7
Received: from out-182.mta0.migadu.com (out-182.mta0.migadu.com [91.218.175.182])
	by imf30.hostedemail.com (Postfix) with ESMTP id 15F5280009
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 01:44:22 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="YNccw/Br";
	spf=pass (imf30.hostedemail.com: domain of hao.ge@linux.dev designates 91.218.175.182 as permitted sender) smtp.mailfrom=hao.ge@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761702263; a=rsa-sha256;
	cv=none;
	b=eHKgvEnSZ6+5Q69Pml3kID8oXfObLd03J7LXO50XAC1AHhhk3BZ+sS0dOzSn6ewxMmSWCW
	Fz8el/ObKFqaLgusv9r47FGyGmgbDtD9FeUQLurvOcRBweC3F54cAY7Irk7UgnAxmR0t/5
	/ZDn35mt8kjVDP0REix2HwF5xjYFjv8=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="YNccw/Br";
	spf=pass (imf30.hostedemail.com: domain of hao.ge@linux.dev designates 91.218.175.182 as permitted sender) smtp.mailfrom=hao.ge@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761702263;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=aM/F09QVx4GPfPIsMF79qJ9NKFno9SfH3yZf/+Wb3Q4=;
	b=8SDOIRzwnTqnQFpSmK3QBmuADcD8C9guH0DjXrlh0PK4zzIf6qgpEpskH1Cc1gr3R5NAlc
	5yXpBLj+6KkArp70ufktXUOwsimlaUHffCqJxegi+idHCEFX1vCuTGNl3aVMEKK/d3HlnP
	IQeE3h0nirGndMolExCr6JohxQTKtOE=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1761702260;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=aM/F09QVx4GPfPIsMF79qJ9NKFno9SfH3yZf/+Wb3Q4=;
	b=YNccw/Brrj60Ymznhn+quzxsoksok+V00LoQGOyoH4Q+qtEC4B97JrnW1LVOha4EqiDScG
	1MVaXdaSs4/R7NQO5tEvxYNdP9zpKJ/mPP1+IU0mbH6fnOHXni5Db0Gb4Lc4vWLTiopCiX
	JZzA/4kwYSLhZy5w8E9niBLNXtimJMg=
From: Hao Ge <hao.ge@linux.dev>
To: Vlastimil Babka <vbabka@suse.cz>,
	Andrew Morton <akpm@linux-foundation.org>,
	Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Harry Yoo <harry.yoo@oracle.com>,
	Suren Baghdasaryan <surenb@google.com>
Cc: Shakeel Butt <shakeel.butt@linux.dev>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Hao Ge <gehao@kylinos.cn>,
	stable@vger.kernel.org
Subject: [PATCH v2] codetag: debug: handle existing CODETAG_EMPTY in mark_objexts_empty for slabobj_ext
Date: Wed, 29 Oct 2025 09:43:17 +0800
Message-Id: <20251029014317.1533488-1-hao.ge@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Stat-Signature: 8zq9idna1tb4y7nwr7mrs9c4asrs1s35
X-Rspamd-Queue-Id: 15F5280009
X-Rspamd-Server: rspam09
X-HE-Tag: 1761702262-26538
X-HE-Meta: U2FsdGVkX18r3J9PIBurXweY54XVkXEer1yrTIMdbqb3DPsmThkbpBdm+UUOe7xvPMgahkRD0OM4KRbAiQCzNKaBx6Ga+41BxhbFtZPvO6ndv+sLuValEuBDoN9ltrMXsr+lNXnz6ubJfN6NAoCt8zuvOu9ho/J3S9bMVeB81/rU/ugqM350jNh2WmRDSAA6k48Xct1W/Xxx5hDa0l/87GEmIDcdZao/GOPhwoe5A9oclWiZm7V6VfSM5h2UvK6YFfoUJK7nGlrfA8QE8mfgO3sLww14bjIREZ3x0dsS1Gyy8r7CshSiKdkUKykYUF5wv+bHd5QzmHIbBt6NMX+GCBsEvQXck/7rE8sESznfJZgqztOwkt5hpR4wHAcihV7FqMXapwm71HpQxt8BknXxvQopvChyCU/e4sHSERKFJXXAgRwK/H5/QMuReweLj7A6h4c8C9ahtEPOCKbGruHoFMBvZWJDDvi2dIvZxP2jAotiWWzLnTFBh/MRJQWq48JCSqLx9HntoesjZqC/7RxHMveynB8NvJV81fZbSl6e0n+gB2tFiOuh390mCq7XZqRV6isoXDQYnc3HAaG1Or2wIvtei3z4tK9duNiPlxZCI4wE9WMgNMJOIuF7OmpgJfU18lioGxJAXrmNFI440PTx+JlVCXkc+6mi274NwpucgruDrykJml2P7LptucRJwUDeHiaRHnKskjlicO0PYZkqMBnR2jx3k5s1djWH3o7/mJvOj5GOlE8nGeFcOZbc3mVwQTZ3YLCJVmIfNg3IozAZpojQPhSWJbtlbaGx0Q88nXarlTpi+KiaXrTIimBzzTOhDFJju9x4YVPMFBnyCfPl1Ws3B0IoiZ7fiY6bvjNxMWiJapv9Iv8loDtpBPt6fWnjhh1anfZPl6yfeVj2jLT1r4idY8XR1Vj4RP/74zFEiRM1o5z+BQ/gTikgHRMueVZZrdpDU3SJUmHNQcPyKMm
 q8lX2eJK
 2X4uCvlpogTMMLm7naLmj7qctYliEh8dAZbG3e9Bm+Al8V4F/RlgbUfw8cb4gFVsdmBMmvSRCt5OdqoAwwSNM7rLjwbqog3HyvgJAa4/aaidyvaC82cmr7Jvjet44kYyhUfJTwQvSL483L9nALhpv9vHWVVD0I64Ms1vRJUCC/TcW6MAsqoRFQSJp96nNyDVilva0HyrkmHg39isWbVrJu4t02PV6IdJPPYyud3pmMXZmDRASSXikyUViMF0F7b3EhMBblAxasX7NSWI=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Hao Ge <gehao@kylinos.cn>

When alloc_slab_obj_exts() fails and then later succeeds in allocating
a slab extension vector, it calls handle_failed_objexts_alloc() to
mark all objects in the vector as empty. As a result all objects in
this slab (slabA) will have their extensions set to CODETAG_EMPTY.
Later on if this slabA is used to allocate a slabobj_ext vector for
another slab (slabB), we end up with the slabB->obj_exts pointing to a
slabobj_ext vector that itself has a non-NULL slabobj_ext equal to
CODETAG_EMPTY. When slabB gets freed, free_slab_obj_exts() is called
to free slabB->obj_exts vector. free_slab_obj_exts() calls
mark_objexts_empty(slabB->obj_exts) which will generate a warning
because it expects slabobj_ext vectors to have a NULL obj_ext, not
CODETAG_EMPTY.

Modify mark_objexts_empty() to skip the warning and setting the
obj_ext value if it's already set to CODETAG_EMPTY.

Fixes: 09c46563ff6d ("codetag: debug: introduce OBJEXTS_ALLOC_FAIL to mark failed slab_ext allocations")
Cc: <stable@vger.kernel.org>
Signed-off-by: Hao Ge <gehao@kylinos.cn>
---
v2: Update the commit message and code comments for greater accuracy,
    incorporating Suren's suggestions.
    Thanks for Suren's help.
---
 mm/slub.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/mm/slub.c b/mm/slub.c
index d4367f25b20d..589c596163c4 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -2046,7 +2046,11 @@ static inline void mark_objexts_empty(struct slabobj_ext *obj_exts)
 	if (slab_exts) {
 		unsigned int offs = obj_to_index(obj_exts_slab->slab_cache,
 						 obj_exts_slab, obj_exts);
-		/* codetag should be NULL */
+
+		if (unlikely(is_codetag_empty(&slab_exts[offs].ref)))
+			return;
+
+		/* codetag should be NULL here */
 		WARN_ON(slab_exts[offs].ref.ct);
 		set_codetag_empty(&slab_exts[offs].ref);
 	}
-- 
2.25.1



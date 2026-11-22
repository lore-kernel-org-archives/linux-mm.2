Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5451C606A335
	for <linux-mm@archiver.kernel.org>; Sun, 22 Nov 2026 00:29:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=T+Y1sOPK
Received: by kanga.kvack.org (Postfix)
	id 77C1A6B00EF; Sat, 21 Nov 2026 19:29:39 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 753F16B05B0; Sat, 21 Nov 2026 19:29:39 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 66B0B6B05B1; Sat, 21 Nov 2026 19:29:39 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 424AA6B05B0
	for <linux-mm@kvack.org>; Sat, 21 Nov 2026 19:29:39 -0500 (EST)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id D0D1312062A
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 00:29:38 +0000 (UTC)
X-FDA: 85460871636.13.062A018
Received: from mail-qv1-f41.google.com (mail-qv1-f41.google.com [209.85.219.41])
	by imf19.hostedemail.com (Postfix) with ESMTP id 228491A0004
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 00:29:37 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=T+Y1sOPK;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf19.hostedemail.com: domain of evanfengff@gmail.com designates 209.85.219.41 as permitted sender) smtp.mailfrom=evanfengff@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795307377;
	b=YTdXOFZfnkBAke2rSR2W9jRhMOo8+8NI9IX1yUe3hDt+O1vIDn0rvFfOGumqOyD4ORYRfC
	QU84jZHwVeXIs+a45KGDC7eQoyM0EmiGGQFw1wMvCIfOUJbk460ykqNF0baGJGPR9gkgnT
	/ml45mzP1EqOXyzJtkbwTq6NM8/Ivz4=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795307377;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=/d2B1uiOt5351Wc+V4rdkTylekRqoHBMFthy3xK3VRY=;
	b=bHnqrT6Wq5oDDDDagtFnDqpVJbmRUFGFV/k8TYUTmu5dM5+f+cFx6uM5S2RTRu/NSOVQ/p
	3AknFm9ht94HuY+R79VI1vEKDAseMvZJ/Pf/k9j/OCMN32Vy+sNAjlAK0JHZPja33nRhXG
	7NdMzDeaM+Jj4JVH+vaNeo0N5vUAOso=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=T+Y1sOPK;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf19.hostedemail.com: domain of evanfengff@gmail.com designates 209.85.219.41 as permitted sender) smtp.mailfrom=evanfengff@gmail.com
Received: by mail-qv1-f41.google.com with SMTP id 6a1803df08f44-921318b2eb8so29208396d6.1
        for <linux-mm@kvack.org>; Sat, 21 Nov 2026 16:29:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795307376; x=1795912176; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=/d2B1uiOt5351Wc+V4rdkTylekRqoHBMFthy3xK3VRY=;
        b=T+Y1sOPKtmrGhrf0fwCIzmOMZBzfNOfp04WCf1K3sR6QWk8HHSrK7a1qW9gyvGXnLA
         6PamIkd50wvo8+QQq4XBhL3sVqjRd4Bxh4sgcIPuHWNFm+qQXWXplCLbMp3GTLOcbItS
         +gLhiipjDxVSkyujyMEMbwIRW7FetMhHqED3+H2R5ifldV/tmAecjUrG/jxN9hUF6LCW
         RxJsvkOuoBe1zv+ayMFmu7PCY0uyxW/PlJ+ueTNte8Db2D3iHHoRxEFCJEOpFJkMqZqp
         2tyi4kLCYejkcTR60FFan1HSigR4Dn9FnMq6zCWO/BG9enaDd9EhyNb1cUjO0DC5OcqX
         mqZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795307376; x=1795912176;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=/d2B1uiOt5351Wc+V4rdkTylekRqoHBMFthy3xK3VRY=;
        b=ucNKkBCG4Hid7F2S1OtoALhUKkaFOnscENLoVf8wWTrR1xqocXPKRZjnxg4T6FzseV
         qpWI59+05NPp9CGW4aS5Uab0vh7GxbuCtc8+VUUVFSd11L6B9HEjc3AbbJ0cVgVV4Gci
         +egITzSCfKouf2psnavndrM/alZnpqjlxzbWgHXqV3SsCDFwHhA6p1ywFhm5Xmk211pe
         Lm50JXf5IOGImX58NfNqYvaG44iTCxBFN5NAnnB2CbVfoUK3Wl9/D0C5nYIiyeeVNLOT
         PsDt8S87hEmSRiPGMjf6JGg95ng8SOZYI4C2zknTjyXf4HGJ7hU3e8kWKJjbVhurIfU/
         +Bnw==
X-Forwarded-Encrypted: i=1; AL+hErFPj1KMJqMAL5gTgRrV+Rl45PscM5lpM55wE+Vhybx5HQ33H6K/1HIFbr6P75iJKHC34mFcopF8fQ==@kvack.org
X-Gm-Message-State: APuU4Z+EMRKkVBWOQrP7Iko2iBGciQvsdtbRPcnT1w3taayWt4sZR+mj
	dSJBvNVQx+cO6NepIKuVciCh1w4qisPOJd3n5igVaQZY0nrxfQ0gsl3QfVMZe98gzO0=
X-Gm-Gg: AZFdTZfQQFZ3vxVDNhktaTU5BHeBkFqO65MAWjY+VZtRQ8I4O8p5GGmkbDenfGaX+7E
	YH2mmMyKCqKjikz9kxCM6U24YoIMrPezRYblWXgp3mtLkWiiR305L6dmg+J8loBFDclBrBqEPIJ
	LfLq16opehy5Uxzwz0kaxcbg8Slr+3zt/csDhgUkq7oINnzKHRZzEF0q+iAiprT9riKGzgaSyJi
	+OPS3qAjKyHvvehhNJWnRDd7ZMTTsNfAI1s4CLStvXnTYdwl7czNehICzgCUHUsXaE1jHM8AUHO
	TxYtiFNN252I+5b2ETTYJWve/jviyR3ukLu0o9BzrfK/WRiNWAKYnc7gjvHN+NPo1/Imjs2k0hs
	D8hkrMOr3VtmHK8yneHyjexWY8+5490h45+NbuHLXMLNxEV8ydogfQXKKLG5IKUvnm8gs6aJlT/
	hGhIgVo1ZAkIVMD78D938fC+sGMafGQO9QalFMuMmUWToNpU/oEDVhfh2WeZkKgFWEbYH64VX6T
	m+wHDr8EL/opqBGaun38fhB18x5Gk4cG/lV37D8/9xhk1MwHf1I0smJPMkAtkl2gOlF9q4ZEeQj
	XnUQUAecp0Twu9w047s1n2iBKjUBsSWSiGsYDc3x210bcZq4TyqUHp8Sl+yGnTSlOE2FtGiboP2
	K4Z2LKkpaVzYXWDO6m2DvLweHpI4V
X-Received: by 2002:a05:6214:411c:b0:91e:97a9:cf02 with SMTP id 6a1803df08f44-92134a38ed6mr129326736d6.11.1795307375814;
        Sat, 21 Nov 2026 16:29:35 -0800 (PST)
Received: from localhost.localdomain ([71.18.96.10])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-92134a0a454sm64752766d6.35.2026.11.21.16.29.34
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Sat, 21 Nov 2026 16:29:35 -0800 (PST)
From: Yifan Feng <evanfengff@gmail.com>
To: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Yifan Feng <evanfengff@gmail.com>,
	stable@vger.kernel.org
Subject: [PATCH] mm/damon/core: do not overwrite wmarks.activated in damos_commit()
Date: Sat, 21 Nov 2026 16:29:30 -0800
Message-Id: <20261122002930.98401-1-evanfengff@gmail.com>
X-Mailer: git-send-email 2.39.3 (Apple Git-146)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 228491A0004
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspam-User:
X-Stat-Signature: stum58nsejsn71bwhy3dwgtswqhhqgt5
X-HE-Tag: 1795307377-77074
X-HE-Meta: U2FsdGVkX19u3ipdk9GT+dnO3AVuaOBpmeDi/v1ddbS1KbmW17kuuKgBT5THY2qw9loqSdgGomr1AmOn01QrNV/Da15c6Y3wRO5SG9vHNSHLOq09l5SP3gBd8SD91FOEUClOW6yyGNju7Uuiaw+VD/WBlsNLwAMGN/wJXQIBwFo5/Oqm5vSW7aI3K9OVYB3LRaT3VrkH0aN22K2SQyLK+BRtQUykbl1zP4Fu7JBszpRF7j0k+0yXzba+iz13PJrRwJltzpRPid9w9z3EhYU2APf+rX4dnrYBrTlb8e4Jw5piFwnU+18n7SzVHym7Qa/iyMtmlIqC6fNpoIMDOgmpacW320pzD7Mqey9s10g0qlVTuCRhdHmHMnK3KgM6rHx15h3RhkwbFnhEmGb+fdREJnMxuGz0PBRfVGSHMmBV0F3qox+C4/0OSscOJNRQepv/Wc1FzjeViGwwTK+0zp2v0j/O88vf/fdtndNFdyyqMA+H9VNkg5JKSpN8QfMJBtjPr7LmojQu7IYGWWyeM5PdiqX4scCplwcBSsXl5xCq19pVEcb2kFHvD6/i6z89V0+3i12fVJYue9fOHJFBwuJoA+xXio1PSqrOsC6sY2J1M129Pv/IRdbPKsaiig0srt0L/mU9xSsbvV56VRQv9tM4kIirlJokGKqUjs8b9A3i7qwK1IzAyEBPX408sf3e1Y+P03p0BKrnc2ne7WHuGXZoT+j+7qnWrWkbOiZNjGKSn4Zaa9cXWtTfyDZ77ozTtxLanXO2kZ0N+zg2VvBFw82LGfZ0bvuBGCZNEaD8/4eoQf3qEpDLnCWWg1LZiklZFojbMmPxD86Px+uuYJ/sUyRmF4p583+vfDjXZJ7/jTtxR+YX8qfuIc4XnA0icXEuAVEU7pfVkYOX45iqhIh7zxVIvI9yzobwok4/GA8f96sVXCUCsEe3yJYN/jBFp0KiBZ7lpa/cabgW7kZMXcDKwIi
 HBvtjgJe
 pPteNNb5ZtejTc5yUz+uhriqkEwj+0cN/VHtRJOXUXdZQitDPA9A3A4LT/eqYUN2EQwgWX2QqA+mfkPQgfdOTSB5kD7hO5nnj4gSSmlJl/eY2FF1gaE/YoLIVCB04a667ymi3GCW/7ZdRRHyYzj/8X+s3raxn+isV440/lX1Aj/LbbZwB8GbZhQU8w+6p76x7KGvBVgy08w+t49r59K7TVI3OHrLRzY1hXB41gL0JPJNoLAZ89xVIWLNeMD+kmRfKnPxoL4QKXujx1sixUWOdq0Lha05/zRcnK13nGWDkMXxs3bAeBwqj25Yq98AaFC19tOBfdN42FoW5LmX6coQgZUpr+zuG2mMNfnSESaMI30N3U7MyMqCPeCh4mAKOBYmX1sFUsknFUtnTrEtccfSq8v96fZXJwbp9CP4BdpfFYErjqgxz8w+VMqQneT0Fbh4NF1i/u/L/MWrnmOUD4xuClJV61ZjkXP5tAtNIStszo+w8tiB2E1g/7wuzScbw7L+4kl90fWANI/ddEibynCbU9iJWNEWvcs/Zyia2xt4GVyRJX6i4/sFv0+/0HcGbIG0jsUTDobzFG1xRKo77a4ATu3K3Tmoxo6FWPRdsnkl+CPIfYH8sKmy9crO4MaKMYDTVKELUIQ22aezSnDvy0bVrI4tLLNndZzUtJAttv+NhKmAM38B0m5qhvoTmjbbza5+5BAt53YUlPMtaIUY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

damos_commit() copies the whole wmarks struct from the source scheme,
including the private 'activated' field.  The source scheme is a new
one, so the field is always true there.

As a result, a commit turns on a scheme that the watermarks turned off.
If the metric is between mid and high at that time, the scheme keeps
running, though it should stay off until the metric goes below mid.
DAMON_RECLAIM and DAMON_LRU_SORT use the same path for commit_inputs.

Save 'activated' before the copy and restore it after.  Do not restore
it for DAMOS_WMARK_NONE, because nothing sets it again in that case and
the scheme would stay off.

Fixes: 9cb3d0b9dfce ("mm/damon/core: implement DAMON context commit function")
Cc: <stable@vger.kernel.org> # 6.11.x
Signed-off-by: Yifan Feng <evanfengff@gmail.com>
---
Tested in QEMU: without the fix a commit turns the scheme on, with the fix it stays off. kunit and selftests results do not change (13 pass, 2 need drgn).
Found and written with the help of an AI coding assistant.

 mm/damon/core.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/mm/damon/core.c b/mm/damon/core.c
index b8678a53b0a9..9ae77e4d6e57 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -1567,6 +1567,7 @@ static struct damos *damon_nth_scheme(int n, struct damon_ctx *ctx)
 
 static int damos_commit(struct damos *dst, struct damos *src)
 {
+	bool activated = dst->wmarks.activated;
 	int err;
 
 	dst->pattern = src->pattern;
@@ -1578,6 +1579,8 @@ static int damos_commit(struct damos *dst, struct damos *src)
 		return err;
 
 	dst->wmarks = src->wmarks;
+	if (dst->wmarks.metric != DAMOS_WMARK_NONE)
+		dst->wmarks.activated = activated;
 	dst->target_nid = src->target_nid;
 
 	err = damos_commit_dests(&dst->migrate_dests, &src->migrate_dests);

base-commit: 4405c18c95d2d0f99f6c581ef0ee8591a1aa6ccd
-- 
2.39.3 (Apple Git-146)



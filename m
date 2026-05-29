Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F1CEFCD4F54
	for <linux-mm@archiver.kernel.org>; Fri, 29 May 2026 20:28:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6344B6B00A9; Fri, 29 May 2026 16:28:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5ED076B00AA; Fri, 29 May 2026 16:28:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4FB1B6B00AB; Fri, 29 May 2026 16:28:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 3EBAF6B00A9
	for <linux-mm@kvack.org>; Fri, 29 May 2026 16:28:00 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id DD996401A4
	for <linux-mm@kvack.org>; Fri, 29 May 2026 20:27:59 +0000 (UTC)
X-FDA: 84821593878.24.EC94E0E
Received: from mail-oi1-f181.google.com (mail-oi1-f181.google.com [209.85.167.181])
	by imf30.hostedemail.com (Postfix) with ESMTP id 2900280004
	for <linux-mm@kvack.org>; Fri, 29 May 2026 20:27:57 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Nfd8vYJx;
	spf=pass (imf30.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.167.181 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780086478;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=9RzBPZkcHoJztcOY8Ay43RDpkIbpehVBuhl8amny//Y=;
	b=6DhXbgJZQDFEkM/Vj67Q/LWThYR+k/pFFRSRuwqpSeo7GDEa7gUA9jjTCei2Ukk10R9J1B
	5pRjnOQTfIBgZpo1LOEmq+ppCgQTKlNWS/m1U7HyUhSfnBGLTbEszRw9JHBIKMqGSedOXo
	Qu5qWDVXc+2GWIH/L5KYsog1PiXMflg=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Nfd8vYJx;
	spf=pass (imf30.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.167.181 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780086478; a=rsa-sha256;
	cv=none;
	b=e4L241HQMv6IK5rYlqCUf9r3iS4UqtEPwiML9veeTgtzAZ6Nbhcl7SZH2iBFxsWgH6VqXK
	efvv/y7IzUfiHR4NqgQ7B8s3RMfFHuau1vDOUEoyf3OEhzyzxluVYUuvtky+hEgFeIqirj
	2Eht20q/vj6B/5HIslDG2fhYvnJ+g2s=
Received: by mail-oi1-f181.google.com with SMTP id 5614622812f47-484cf882ce5so10601425b6e.1
        for <linux-mm@kvack.org>; Fri, 29 May 2026 13:27:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1780086477; x=1780691277; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=9RzBPZkcHoJztcOY8Ay43RDpkIbpehVBuhl8amny//Y=;
        b=Nfd8vYJxPqVta7Dxt63Mu+8LCWXsR+jKIez+TXb6lKcqcakti8UYqIs0C4kHF1AkIo
         aKguiwrdVSDPb4Qc5MuE6R6qJ16kZvCcTf/2pfyuKtcHowA03L2NLskVUJJAYOZI6Fho
         vuD4SR/d3lRhUBOrgitR1pNbAtB+D3OH8rISe8jY5JligXW11hLnKm9/GVChkSCsjIBS
         yUsQ9/KP7mc0Oc11Ds/Xr9OM3Lz/F04JlpJId0XybyS9SQT1yv4W4zpAHjtOgzoIcZrr
         PFHCHA0GTsdBbFgiNMkWJmXGvghsUN6SwhXaxQnd4zjJE/50RcaX/meZvz5iLuaXPpgu
         Aa0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780086477; x=1780691277;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9RzBPZkcHoJztcOY8Ay43RDpkIbpehVBuhl8amny//Y=;
        b=V/d1efQd9TkL+dQqqIwqT33glftXNtnhu6BY4mhk+/luQg4VBv0340Yiqd8xy7t75f
         d4EowU9FCHDqYlMaSoLmnGnFzNoFUyG0c2dj4drWqhUTEsi3ie7EvCqBqEq1SvYfRjhA
         veeu0pinNGQI/LbqmQfELFEc5mdPKQdOe63egu4ATMvNNRgvhX1HBZnXCMKUA/PiXyII
         YTQotv99hoW40DewCWr70CajIszXRw7GPb90WvFFwM9jpIo02T0FeGuvAJJ5tJjelI3a
         vPGscncyTmfJ2DAoNPINoxsqkUyB8WjHFEz3yMRZJawCjfASgoOfPz+pDOF/tqP5L4px
         NB3g==
X-Forwarded-Encrypted: i=1; AFNElJ+msk8OMNppHMQSlgKPptwFRf/aUB1Bn+wb2dMJybatbfiLV6tQTKBinxFubqAXUBvUkn5muPnD5A==@kvack.org
X-Gm-Message-State: AOJu0YzMt25wMaB8HKI8dLi9phrmxpYs5188E5pFpgLr8Pe8T0Q8rBTs
	VwEGtSlUcuOnr/SPs22YzJjElLDVds0FAs2PaQD9VQh3FzhkGrAw5Jfk
X-Gm-Gg: Acq92OEyXcvM2GGseO47oTDpxU6pnX7/Kh4/fnJBJ29RGz4uYQYoHmy7VxTLzCD8Oyz
	/zO4gPJyDQxPBDC/xM3Zh3ARBAJmco/oKV617F5KPnBLj19bADqe7QzO8qR9VHYdpEO6B8NRv1l
	/DiPTbi2MFO7NieBBaA7Xzn44nrDFpcXe3xHvBc6ZWf8+FtMBQBzrYJdMNBCdPkw5K2Gnh1BoXA
	KwvEqWr8ucc2QEBvyoLVi/X1gkZ4HlTAwLluZTm6+52ypHFNvxtrwMDDfV5ssycjQ4gVwb7I4FL
	lcPy8XMf7+gfPSWxJS9AXpXpQ8SWCNNAHHYPoH0SbKBUQBqqmRADDP7m1l/I2Gn6iBJJxuhSlzY
	t0Ia0A9PJ2dMxaMTHkslZtZk0NgX11y2/FiHm5SGn22/l5d+HdW+Dtt3a2ytKViUJlfhT2uLLrA
	h49G/eFiFcJ4Q6zNALZbxMU3wiVJ59mlG9FoiIO9AKV+x0sj5X0tHtb+KqzqL+fKhP
X-Received: by 2002:a05:6808:3092:b0:485:d6e7:9dcb with SMTP id 5614622812f47-485faf4d41cmr620581b6e.0.1780086477061;
        Fri, 29 May 2026 13:27:57 -0700 (PDT)
Received: from localhost ([2a03:2880:10ff:58::])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-43c93ae5342sm1729030fac.7.2026.05.29.13.27.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 May 2026 13:27:56 -0700 (PDT)
From: Joshua Hahn <joshua.hahnjy@gmail.com>
To: Yury Norov <yury.norov@gmail.com>
Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	kernel-team@meta.com
Subject: [PATCH] mm/nodemask: Correctly describe nodemask operation return types
Date: Fri, 29 May 2026 13:27:54 -0700
Message-ID: <20260529202755.1846800-1-joshua.hahnjy@gmail.com>
X-Mailer: git-send-email 2.52.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: a4acmpxowx49ruq34qzksnep5b8uz3po
X-Rspamd-Queue-Id: 2900280004
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1780086477-759475
X-HE-Meta: U2FsdGVkX1+dVBi+jDy9oZgUcX9lCUtk9iH92XpJ91qtdVsjvSMOXCmFsIdJnR4IOJj9OISRgqUuENKsUYcgl5elwCsKM91WDdgxnmnXgZMf08uSG5c+0pFG8uxAzZlSusztxbxauApi38abHybqLoU/Yzr8YOP4/OqOtyYvCrnTimPAu/5aTQIiPs+0uSC07PQahZUDnvciAPAGaPdMx/WdJdePhVcJvoLAdZWP8QX4dGYd2cYaQBMDNt/0UTLUkkYO1tYE3mRd0I+Oc9GvTmsmRcF/Qr0r4qcbsHsM1Jpv1GNrSbY0PoCgmxMFcwaicqWrGXA/IUOf9zT+kOtxitIZjWpJkdqqr2oTD44y0yR7s7cHkyCq8J5APrWJ/3U2rTQ42F3BRjE55d3dH/K4HNmlX9rHRuZ0ZsnYYdLZ0sNkQ+KNqElgbi6OAwNrPcLmJG3GkpsoTFZz10t8TdGFDrLEuDC0kGtMUBuYIYsBj7ruPaJPgdYDpBlCwHr+Mc0mbXZ1Zxx6xAoD5VtVtn6iQ14BdA2P5bKKFVKnfV+KCdpmG/TzNQQ3/oz5nC9cok+mlrXt6YMqZBpMw9jNoIheVkSKUWeqlL0BLC2Xh1b/lDsDnhigewKBU5RQarynDFLosdECfAOx9dXxj2ppgAUJ4Ta42e6ct7UFoJff0thNft8gDR8hccgSzB4o/OxW48G8JmRv2oyvLCmpUYKgZG2Cgc8GAGKNT8YQ+0iz0fsmi3UiouC2BVHdiDdHIxUqP90NF+Bu3tD8kjXiUygZ8q7i015bhK7Z9mHlnaKjkL53J3tHVdYJgLu6WRaXrW/E6AmxXonkMHP4zIsylxvR6cxDtgYyBYYH3n38QfebIOYSGkmV6TrriWYONiEfjP6Bw8niXUtse9EzqWD6xozsEi37knNDAr2F+Dsp3aQsseVcCYLWKnhdPwGvTyzTqzA/6X1+2qywI/sCPYCF8AgUKv+
 yLpQ3xaL
 sLqZ3kY59JuNXTPz35tJZAjBWlC0R0THGFTeueZiHnbj4nILLB/LtDpqESaLXHLoQC5IjOojLo53CkiDsxoj6B9cZL4t7eeXjYzAIdF1TsUA3pJRHWfStz91N9/1pXtv3qB0416m1j8effqzr0fYKPwjCfT6ufs5pPF01z+D2zqHeapDWsfldewMR0uTwsWvpzS5GqxuY/gch7bR9dt6tquRbMuMntpg+IhimFVzT+xPNEV8geiSE+8ICmFIpcJWzUTw42mbTV5rcnSmPL+lo4gLnnrRQgTKfAq3CmfY75v/Eps1uUonxOor8pfWWVVj9lLPWBrRUSmaAZP3QlT3ok0Zf64/W7cIRDEgEQxZZDoPuxt2Oag9wx6qQgA81CSnHYPkiKlHbqhgZaUO7qLrxdurAala/1HipWSwalxqQTa7oCua5Xnr+UaIkDKmhvOLNontqSKWlAdJuQFI8KNdAq67qldKkSpFWgnZvEBRxb5Vq2Aj+/gI+MJJfvw8qqMA9TCk3n3HkNhRHa26HjnFKdXwt1w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Commit 0dfe54071d7c8 ("nodemask: Fix return values to be unsigned")
changed a number of nodemask operations that used to return int
to returning a bool instead. However, it did not update the comment
block that described these functions, leaving the documentation
incorrect.

Fix the comment block to accurately describe the functions.
Also fix a typo (unsigend --> unsigned), and fix a callsite in
mempolicy.c that did not get updated during the conversion.

No functional changes intended; changes are purely cosmetic.

Signed-off-by: Joshua Hahn <joshua.hahnjy@gmail.com>
---
 include/linux/nodemask.h | 18 +++++++++---------
 mm/mempolicy.c           |  2 +-
 2 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/include/linux/nodemask.h b/include/linux/nodemask.h
index 204c92462f3c0..b842aa5255464 100644
--- a/include/linux/nodemask.h
+++ b/include/linux/nodemask.h
@@ -24,23 +24,23 @@
  * void nodes_setall(mask)		set all bits
  * void nodes_clear(mask)		clear all bits
  * int node_isset(node, mask)		true iff bit 'node' set in mask
- * int node_test_and_set(node, mask)	test and set bit 'node' in mask
+ * bool node_test_and_set(node, mask)	test and set bit 'node' in mask
  *
- * void nodes_and(dst, src1, src2)	dst = src1 & src2  [intersection]
+ * bool nodes_and(dst, src1, src2)	dst = src1 & src2  [intersection]
  * void nodes_or(dst, src1, src2)	dst = src1 | src2  [union]
  * void nodes_xor(dst, src1, src2)	dst = src1 ^ src2
- * void nodes_andnot(dst, src1, src2)	dst = src1 & ~src2
+ * bool nodes_andnot(dst, src1, src2)	dst = src1 & ~src2
  * void nodes_complement(dst, src)	dst = ~src
  *
- * int nodes_equal(mask1, mask2)	Does mask1 == mask2?
- * int nodes_intersects(mask1, mask2)	Do mask1 and mask2 intersect?
- * int nodes_subset(mask1, mask2)	Is mask1 a subset of mask2?
- * int nodes_empty(mask)		Is mask empty (no bits sets)?
- * int nodes_full(mask)			Is mask full (all bits sets)?
+ * bool nodes_equal(mask1, mask2)	Does mask1 == mask2?
+ * bool nodes_intersects(mask1, mask2)	Do mask1 and mask2 intersect?
+ * bool nodes_subset(mask1, mask2)	Is mask1 a subset of mask2?
+ * bool nodes_empty(mask)		Is mask empty (no bits sets)?
+ * bool nodes_full(mask)		Is mask full (all bits sets)?
  * int nodes_weight(mask)		Hamming weight - number of set bits
  *
  * unsigned int first_node(mask)	Number lowest set bit, or MAX_NUMNODES
- * unsigend int next_node(node, mask)	Next node past 'node', or MAX_NUMNODES
+ * unsigned int next_node(node, mask)	Next node past 'node', or MAX_NUMNODES
  * unsigned int next_node_in(node, mask) Next node past 'node', or wrap to first,
  *					or MAX_NUMNODES
  * unsigned int first_unset_node(mask)	First node not set in mask, or
diff --git a/mm/mempolicy.c b/mm/mempolicy.c
index 4e4421b22b59f..36699fabd3c22 100644
--- a/mm/mempolicy.c
+++ b/mm/mempolicy.c
@@ -2865,7 +2865,7 @@ bool __mpol_equal(struct mempolicy *a, struct mempolicy *b)
 	case MPOL_PREFERRED:
 	case MPOL_PREFERRED_MANY:
 	case MPOL_WEIGHTED_INTERLEAVE:
-		return !!nodes_equal(a->nodes, b->nodes);
+		return nodes_equal(a->nodes, b->nodes);
 	case MPOL_LOCAL:
 		return true;
 	default:
-- 
2.53.0-Meta



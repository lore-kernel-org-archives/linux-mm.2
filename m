Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2BF44C624DD
	for <linux-mm@archiver.kernel.org>; Wed,  2 Sep 2026 08:18:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 359EA6B00B2; Wed,  2 Sep 2026 04:18:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 331396B00B3; Wed,  2 Sep 2026 04:18:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 247346B00B4; Wed,  2 Sep 2026 04:18:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 093196B00B2
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 04:18:03 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 8E4A81C0054
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 08:18:02 +0000 (UTC)
X-FDA: 85168119204.01.7379190
Received: from mta0.migadu.com (out-221.mta0.migadu.com [91.218.175.221])
	by imf16.hostedemail.com (Postfix) with ESMTP id A22F5180002
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 08:18:00 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=or4Fd+fj;
	spf=pass (imf16.hostedemail.com: domain of hao.ge@linux.dev designates 91.218.175.221 as permitted sender) smtp.mailfrom=hao.ge@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788337080;
	b=z9M+myAtFl8Rl50MyvjBkRyaH8vtG9owecPdEUY9Uy10/B+RcnwvnQIjHpZNSAw0aUkr9L
	YdNmK9aWG30Idr1p3688WC1669mFtwhLYz2Fc9wEI+XC/oLRAH2pkP3X7SyDw1SHoF3KUv
	UVLuuqPQPon2ydaWP5ZKgDkKRVlnPDo=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=or4Fd+fj;
	spf=pass (imf16.hostedemail.com: domain of hao.ge@linux.dev designates 91.218.175.221 as permitted sender) smtp.mailfrom=hao.ge@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788337080;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=M1UZWCItS8vywVIXvWtrvTvxyn9vkE4tQyoI5BiDSxI=;
	b=O0FCfDYrXjCeHpd4PrmXemhM8oMr/I6EOBLJR4+LpTIAtf7IeCksP1P9ql2f7L3us3PiVG
	whU3PG0BXAwHl6YGzFC7aCax/ZMb6MT0lrtxDg5M54Oy6AYxi+htDnnLapKPPPzoklu+WV
	zMU0ygHXnhwp08WOamPCgSOBrP2rJEA=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=dWk9y7b0drDaUlfFd/9bCLMEQv7pdwsvhjNQU3mPn70=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788337079; v=1; x=1788941879;
 b=or4Fd+fjoDT55iqG+B+WGSLMTkSlmM2k8Qs99PoVYTcNgrL8/zCL/7azvjiPygrMyNP+v1eN
 tjsUmoY+rFpBv0IjhNbAKdX2oLGpT8SU8WZ9/nEl/T38ACMIGrdGTfEog5CkVYMXkx1yoI0TRHo
 be6yuvAXOPdMXJti7fV2Ly4o=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id eca1d97746dd0c27;
	Wed, 02 Sep 2026 08:17:59 +0000
X-Mizu-Trace-ID: eca1d97746dd0c27
X-Migadu-Flow: FLOW_OUT
From: Hao Ge <hao.ge@linux.dev>
To: Luis Chamberlain <mcgrof@kernel.org>,
	Petr Pavlu <petr.pavlu@suse.com>,
	Daniel Gomez <da.gomez@kernel.org>,
	Sami Tolvanen <samitolvanen@google.com>,
	Aaron Tomlin <atomlin@atomlin.com>,
	Suren Baghdasaryan <surenb@google.com>,
	Hao Ge <hao.ge@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: linux-modules@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	Sashiko <sashiko-bot@kernel.org>,
	stable@vger.kernel.org
Subject: [PATCH v7 4/4] alloc_tag: release the reservation when populate fails
Date: Wed,  2 Sep 2026 16:18:02 +0800
Message-Id: <20260902081802.146145-5-hao.ge@linux.dev>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260902081802.146145-1-hao.ge@linux.dev>
References: <20260902081802.146145-1-hao.ge@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: A22F5180002
X-Stat-Signature: 3c6zozi5yajqrw7is5ozkwfj8uogiwzi
X-HE-Tag: 1788337080-404876
X-HE-Meta: U2FsdGVkX19wijtsCF7x0cNDPIm39eb3xXHhwSJlkrdozf88q0Nzcoeghm5941p0z+AATxwEeT/2cJf/5gzTHRyTd8KuPKQtGqx418shFSC3awGX61DlDZifRc0kqdfkuPzz2NT5NlMDAR7ZrBeFqc7uQfX2ks8+/rM4WqtNvJPZSpMycXzVEXbx/Ce83F2RK+a2ATtfL181ZtTqkdHpQ/s1Jf+kv8WiywwwXre1gEZysSMjC8HXF7vDxy6mwTKfswC++gURbr1wY5xZptsHgvcyBrd8ZSBBNFORJhnW/pkiJRHfwLHuLwiM3jw9mTY6vZKnk5OVFd2H4g03GLU1/LtNPjaCKnvNUWd5Jy0qdLYkwXi+iTFVIIB0km0w30glRaLQmIQtNpxBkCmL0cYBGav8SpBkdiGnz3qCsGLuocdc6TUaURsN9WO3Y0GuNo/rUltpcBfr0U8LkpNSIAW7k8E6qudetQRG339SxIHjxfxkgzk6sPAVyjNbEkFhemfZ/cuybTytNFw2tCDa4JhH1CPjxNm2ayelVIZ4lJk7ZiMsPZiOv+kxt0POnHqnjmuyanrEpfqj8opXJfB4LWatsMpsHcXSlE/97pD1kT20XBGKIjpm5sCsIubIlY8rr+prIyyHmwkfmFWcHhSysg0/uIbo+AMRtD30gFxpsnDN0EBHM5aqLYROfkKCT7aqjK5xs3WWTcCeDpA6S3AS3e8P3EWWkCyi/EkdFokaBY5trzL3BLbP+1MWXDFExW7OAx4jwA0mAFFY0Cl2/3Tc+8qEHk6yBfphxmoiq+PhdhVYLWahe3TbTHl+hOSLp+2n5l83xpqrRYlMLprk3okfIfSf5O4F2Enx1/9OGvZCF57D1YHFh8+BigooQoW95AqSdr8njSk2ToNaVdXdAm6HVLmuMukZXi3Vgy/A0efA0Q4Bau2YyEjgD728PaSECcQZwBpan606bslfuUrIS1d69vE
 qmGDrJmf
 bxZsg6r7RH+LHgiv6ajjQNx6+At2CAgmtGxStAPq5prXMvYqfvVJCpQ9AfZWunLzoqWk6SkT53Tr62JY7hCLkbWvh1yl6V61rk0XaqcE5OZYxeHkf38L3HZTcAyaspM3nD7Jc1jNHKzFRSG+g84Iyc5p9REdaDmFenGAEndy9GeisYLbEj9to5SwoPdYkdVSsDL78tZdZXUbvhPnKJa4bdyWYEc6WUxUKeX7YKkR/5dtSSy/DtAzKaeFwUo701tifI6vULkHRCuTuV+/QKGGFMWZSbUg6+c8Ns6lk7i1n/rS9jTk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

vm_module_tags_populate() can fail after the reservation was stored
in the maple tree, and the error return leaks the entry, since a
failed load never unloads the module. Release it.

Fixes: 0f9b685626da ("alloc_tag: populate memory for module tags as needed")
Reported-by: Sashiko <sashiko-bot@kernel.org>
Cc: stable@vger.kernel.org
Signed-off-by: Hao Ge <hao.ge@linux.dev>
---
 mm/alloc_tag.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/mm/alloc_tag.c b/mm/alloc_tag.c
index 248496470904..3c25475becbc 100644
--- a/mm/alloc_tag.c
+++ b/mm/alloc_tag.c
@@ -971,6 +971,7 @@ static void *reserve_module_tags(struct module *mod, unsigned long size,
 			shutdown_mem_profiling(true);
 			pr_err("Failed to allocate memory for allocation tags in the module %s. Memory allocation profiling is disabled!\n",
 			       mod->name);
+			release_module_tags(mod, false);
 			return ERR_PTR(grow_res);
 		}
 	}
-- 
2.25.1



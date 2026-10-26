Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9D7C0606A320
	for <linux-mm@archiver.kernel.org>; Mon, 26 Oct 2026 11:21:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=Uw2IaIaz
Received: by kanga.kvack.org (Postfix)
	id AD5046B05B1; Mon, 26 Oct 2026 07:21:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A5EA26B05BB; Mon, 26 Oct 2026 07:21:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9749B6B05BC; Mon, 26 Oct 2026 07:21:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6A6496B05B1
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 07:21:26 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 009221406D1
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 11:21:25 +0000 (UTC)
X-FDA: 85364536572.06.5DE397C
Received: from mail-pj2-f1.google.com (mail-pj2-f1.google.com [74.125.227.129])
	by imf01.hostedemail.com (Postfix) with ESMTP id 2FCBF4000D
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 11:21:24 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Uw2IaIaz;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf01.hostedemail.com: domain of jm5905938@gmail.com designates 74.125.227.129 as permitted sender) smtp.mailfrom=jm5905938@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793013684;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YaPrNf7Cus6idRIRbovGwqOwkJFSxRQnPSz6SCMl2RU=;
	b=F+doyTCYDCtNkY7ecTPfgVdvnLxBFXoOIC2ZMhzp3XfaRCmGasjtwR+U7D3R0YW60LXZ+p
	UsI6GvYDn0RVybPp4FIZkbACyfwRhTPfQtHpCS9hSbiGC4ru4LERL5tR2sbgLrjhpkh5ku
	udWVzxxbFjYwZPykZfEkon0m9qvtzhY=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Uw2IaIaz;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf01.hostedemail.com: domain of jm5905938@gmail.com designates 74.125.227.129 as permitted sender) smtp.mailfrom=jm5905938@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793013684;
	b=ODWd4ztu/slKkf1lX/9+8VvHAzjPHw9PGWwamv/tgqvvr5SR2H0iZtmjlQLwoddR1x7lqW
	T6h/Cb41Nf3tEyKg4OQqj3cCxDjs0hLQIiCiqFacfxORMLdLqCPRdNItddaaZPh4Da5Wh0
	ryIWrUkmZGFm7EolgbK4CHfJ68QFN0c=
Received: by mail-pj2-f1.google.com with SMTP id 98e67ed59e1d1-3ab37ea4798so632000a91.0
        for <linux-mm@kvack.org>; Mon, 26 Oct 2026 04:21:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1793013683; x=1793618483; darn=kvack.org;
        h=references:in-reply-to:message-id:date:content-transfer-encoding
         :content-type:mime-version:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=YaPrNf7Cus6idRIRbovGwqOwkJFSxRQnPSz6SCMl2RU=;
        b=Uw2IaIaz0fFdBA6LBmNZvYTSGcnXx0w/mRj+A4v/2NLS6OlbZINMpgSdWq0RPorY2B
         7dJPLXo+YdKkhP7mwNFGGy/Io9IygF9mtofPOFBpTyjrrN0C8Xyxx4yc8NOV2Aiu7OfY
         y0yYmgVxUSelkYAZSDrsx7HL+o13hCjzUyfwGbwLQvM2ZDPCel/I8M2f+h4zov6qqsDQ
         n7byjEoqYjT2OC9JPn1VaqBSX7fNSYPPSQoVEmQ23ml27us7im78JZ4UUPsuV8ergG/o
         COCPNqj/yATTxr6s7Gq62hNpGEEz8mvoOvhzvMTbaaZARyc3aZR/2ZMMjKn6miBhIlRN
         PPhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793013683; x=1793618483;
        h=references:in-reply-to:message-id:date:content-transfer-encoding
         :content-type:mime-version:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=YaPrNf7Cus6idRIRbovGwqOwkJFSxRQnPSz6SCMl2RU=;
        b=QUmDEYA6E51hNvqkvXkZW9b6zr+2u3eY0DLy9IlTayThpEfpyWiYUbdOlZM+WC+hWL
         IktogVYKLGXC1AbKbBDon9UbGjaHozXZyymt1tkk5x89BosgwWuYLsvH20UrugeUk8C2
         gWxlWDvTil+BDfcQxvcmnLMxnW7iHkFoHkjtZcP50MG511x5rhBBSzld2SaMaXMiL77d
         FX76dgrH5NF37tr39Hp8ZBPtbHYdYIUqVkgNFdgFd+CxSBxK9PjxsNMMOToa5oV1yLbJ
         vLdFzlzGFk+sNaP+VV6sta6nqsWGGD8RTF8EPGoPl1gnTbuvNLYT9QdXtBavjTDfHc6C
         INAg==
X-Forwarded-Encrypted: i=1; AKwUvBxxMJgLbyh54CdBR8VvHYH6qGgQ0D781hOy4g2idCMyOGiopOaNSvzpTuLQ8oy58oKaZt53d2pGyA==@kvack.org
X-Gm-Message-State: AFq9FYJ+WEutapBcV3cn3rgB//t1Nf7iP59WMn8oOqaJEn/7RgkKPAS7
	O4tikywUEfK/biPMFC9L8qhE4mpe56PPwnVH6KfUDPx+KWVkFCn1p3ZL
X-Gm-Gg: AYBFou16Ay7wgHrOdAz/lk1VQMa910DzjeCtwVtE4P+GrQhAiCjQR0Xx5IqrylOhkcg
	Sj4XQm7Ztv8dLI/zma4CFQPGZEsdBXNEB1i+2WcIJmr4I4dViLP03GJmQaoPcT/Qlpx3JI8fN/8
	o+sfXyaZsnmQgNJ05/cFzLPzQtA4pd2bXTbwrpEViqR5jaWNWjmxuJVHgx85r0HE89kwRWVAzQg
	G4kGfJOWQOysvbHdZ4mAL5bLZy78CU7KOzU4eo72yZSNRh5MUO4tdKeoWU9CTS3n8oTlab97Khs
	c6ttVarT/2GOv+2YQYkRjuAJo35niEAAbWZPNJEBByibkxiFHNDl6Lu/6ZeoT+GO4sfxzhtCaFN
	xCk0v+kuN5CKk6taBpaN7E6Sm9AvFtRo8UwmTp04o/FDaLOBzsRNL02Ay+9NKJjiAMjcj4JkgP4
	1W9FU0ZTKCKcHJLo2WXMhpQdS7+tduFkTOc/Mk9W72Jf3Nv4ZfRsvGMjYY0UXX4ikC6Z9bi7Rm4
	3xvmjMKkiJEuawZC//g5HWkv3jWh9utjrJqHfRerCZ1vTzLNnGP0jTZ3Te0mFJxzLgQQBjje60f
	MY40L4YOmE0KxXMAbH4ir3Za0eJDSOHQz3aVonJgyd6pJRgzQqUQRg==
X-Received: by 2002:a17:90b:564d:b0:3ac:7f4c:a690 with SMTP id 98e67ed59e1d1-3adeafb0449mr4836978a91.35.1793013682850;
        Mon, 26 Oct 2026 04:21:22 -0700 (PDT)
Received: from localhost (n106-71-19-159.sun21.vic.optusnet.com.au. [106.71.19.159])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3adebe6af24sm7907912a91.6.2026.10.26.04.21.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Oct 2026 04:21:22 -0700 (PDT)
From: Aveline Noir <jm5905938@gmail.com>
To: SJ Park <sj@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>,
 Shuah Khan <skhan@linuxfoundation.org>,
 Randy Dunlap <rdunlap@infradead.org>,
 Manuel Ebner <manuelebnerli@mailbox.org>,
 damon@lists.linux.dev,
 linux-mm@kvack.org,
 linux-doc@vger.kernel.org,
 linux-kernel@vger.kernel.org
Subject: [PATCH 4/8] Docs/admin-guide/mm/damon/lru_sort: fix remaining grammar
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Date: Mon, 26 Oct 2026 22:14:36 +1100
Message-ID: <179301327249.2.16817896016779044743.damon-docs-grammar-4@gmail.com>
In-Reply-To: <179301327249.2.4690198998605536207.damon-docs-grammar-0@gmail.com>
References: <179301327249.2.4690198998605536207.damon-docs-grammar-0@gmail.com>
X-Rspamd-Queue-Id: 2FCBF4000D
X-Stat-Signature: 3m1ioja3w5hipnarwi359wuuwngf6tcf
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1793013684-711454
X-HE-Meta: U2FsdGVkX18YUPWqwG8tFfux9xsDHfaGnfasrVKenpHW3QOUGrt7HEqnAf+RcRnf6+fD6dmKOTi4TdePUDhjCcrtpmLPlcyYTY92RPCWvHnjtB5EoeQrHXQ0q5Z1O0mRGj54AqOcvihtva+ZAU/CNLbEe1AnUHCorghzikMdhLlZQcG/LM+031AQrdnkd8EnVlZLQGfOgQKHf8LVXgZLpOLpBxZAyL98Ni3G6T58Kcys7Uu/ZShtGsPH4R1195PJGFTvx3f0Zct0SmPXOjiXtHPBINaX+nboD+rAFoe6rMu8/+gmTysPymlTxB5M7EgMGYmFDeC8Hnl2Rc09wHW6zyBbZTbKVDreCAz5vzW1IEliMwtn4UhdUTkYdLZaTa2K6f8KCJk862kcCBze2NTVl2NhuxXNRjFmH7UPatrxxegqRqw2fcBHFoJ36RHOvIQpp5h8OqVc8qS9Mf/R/bTAXuMpLlXI849Dlrn7zZSTDm5OVmdosXqE2ryzEeWp0y5CY/ipg+WISCrr+fckFkIXLW0xqjy12kqYXLZoefnW+X+T5iExC/wQX6TWji7tqVUsOhfvYL/eyOcR8stWkXVL62+Id4a0wujIvwbj1aQSQ4m+nFT/HI/CnFv2hX7gfftOHfI+Qheq0JCX+jhIkr2cWxIglSqufu2BxOLy9btjL/QIxhSJ0gIiCt5wooj4NK9rXdfq8kRkh9lZJIN6u4cISegOwuXRQgpHWMUEp7xztrd5fI6D+5Ol4gOz7235R6VAtWxYFu4zqMlp1K2v4rjY8VswCm0XZdbG03bfaOt2HkDiJPYlLNYh5vKYBuEGUrmR5+UHm3IAPagjGsEdDSAlz1Zx4tZfrZxjkS3P9fwfLi9XQm0DcG4xUoRA/7AIDrds1JRfgNKQVP+urfIz/sk6HvyXg36DL3xP6MdDpndByohTQ2llAJC+sRMvP5xa9tfl7IkdAAFXQKMue4Tr6xL
 o8wcVxrK
 xEqqXkJiGzhvUQvMT10dwQY8Vr7lVpHZxbEN4PT0CG0uVk34mx5yelpzUejyNxjvQG8l4onHwKqtlu2g6TeYpK9+eTpXnnIIyrcIfIKgew3A98L1vvy2ibBAuBe0IKXQpTN+6MHpxfN2YUtxfWvVbHif+5AlrEmvIk2ZWgD0EWI95XBX89boqISmI4ViPQibKQn+uPFJ+NwNFJ2hvFLEyZNEpK6ipABQb/TCSZI0ahiAn1sOlLO7rFTmLrmRXMFlGvhxPT1PvyAHXscqrR3WULCOjgBasnlZDAnTVpZWGe9sd5sHS9oa8rnq3T/1cGFE/S6kX7DxsNT7zTy10gBDCxSJS7fIX9A8rR+6n085Xmjabows45CMtoca61hCv2cPELkw1nSSDhrAa0UZ/2VR7AG27lsF4EMFd05n5fHF4faDyo2L5SKc5jeAvOyjgyQpJz6pLyWBNr6g1v6EvqepJGnTj0NpppZj8BYisCkxQ5W7d4Usn2rkMb9SZWtOKtxWZuPP3Qo0CllCYYnp8QwDKuD0Nv91iOl870pdFWY7tMiHDlwA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Manuel's recent grammar fix for this file, now in damon/next, covered a
good part of it.  This should take care of the few mistakes that are
left, like "should automatically activated" and "Make DAMON_LRU_SORT
reads".  Rewrap where the lines got too long.

Signed-off-by: Aveline Noir <jm5905938@gmail.com>
---
 .../admin-guide/mm/damon/lru_sort.rst         | 45 ++++++++++---------
 1 file changed, 23 insertions(+), 22 deletions(-)

diff --git a/Documentation/admin-guide/mm/damon/lru_sort.rst b/Documentation/admin-guide/mm/damon/lru_sort.rst
index aa4cc90ca57c..c628e3f6e587 100644
--- a/Documentation/admin-guide/mm/damon/lru_sort.rst
+++ b/Documentation/admin-guide/mm/damon/lru_sort.rst
@@ -35,7 +35,7 @@ deprioritizing cold pages on their LRU-lists.  To avoid it consuming too much
 CPU for the prioritizations, a CPU time usage limit can be configured.  Under
 the limit, it prioritizes and deprioritizes more hot and cold pages first,
 respectively.  System administrators can also configure under what situation
-this scheme should automatically activated and deactivated with three memory
+this scheme should be automatically activated and deactivated with three memory
 pressure watermarks.
 
 Its default parameters for hotness/coldness thresholds and CPU quota limit are
@@ -55,7 +55,7 @@ DAMON_LRU_SORT utilizes module parameters.  That is, you can put
 ``damon_lru_sort.<parameter>=<value>`` on the kernel boot command line or write
 proper values to ``/sys/module/damon_lru_sort/parameters/<parameter>`` files.
 
-Below are the description of each parameter.
+Below is the description of each parameter.
 
 enabled
 -------
@@ -70,12 +70,12 @@ condition.  Refer to below descriptions of the watermarks parameter for this.
 commit_inputs
 -------------
 
-Make DAMON_LRU_SORT reads the input parameters again, except ``enabled``.
+Make DAMON_LRU_SORT read the input parameters again, except ``enabled``.
 
-Input parameters that updated while DAMON_LRU_SORT is running are not applied
-by default.  Once this parameter is set to ``Y``, DAMON_LRU_SORT reads values
-of parameters except ``enabled`` again.  Once the re-reading is done, this
-parameter is set to ``N``.  If invalid parameters are found while the
+Input parameters that are updated while DAMON_LRU_SORT is running are not
+applied by default.  Once this parameter is set to ``Y``, DAMON_LRU_SORT reads
+values of parameters except ``enabled`` again.  Once the re-reading is done,
+this parameter is set to ``N``.  If invalid parameters are found while the
 re-reading, DAMON_LRU_SORT will be disabled.
 
 Once ``Y`` is written to this parameter, the user must not write to any
@@ -87,10 +87,11 @@ active_mem_bp
 
 Desired active to (in)active memory ratio in bp (1/10,000).
 
-While keeping the caps that set by other quotas, DAMON_LRU_SORT automatically
-increases and decreases the effective level of the quota aiming the LRU
-(de)prioritizations of the hot and cold memory resulting in this active to
-(in)active memory ratio.  Value zero means disabling this auto-tuning feature.
+While keeping the caps that are set by other quotas, DAMON_LRU_SORT
+automatically increases and decreases the effective level of the quota aiming
+the LRU (de)prioritizations of the hot and cold memory resulting in this active
+to (in)active memory ratio.  Value zero means disabling this auto-tuning
+feature.
 
 Disabled by default.
 
@@ -112,8 +113,8 @@ Filter (non-)young pages accordingly for LRU (de)prioritizations.
 
 If this is set, check page level access (youngness) once again before each
 LRU (de)prioritization operation.  LRU prioritization operation is skipped
-if the page has not accessed since the last check (not young).  LRU
-deprioritization operation is skipped if the page has accessed since the
+if the page has not been accessed since the last check (not young).  LRU
+deprioritization operation is skipped if the page has been accessed since the
 last check (young).  The feature is enabled or disabled if this parameter is
 set to ``Y`` or ``N``, respectively.
 
@@ -125,7 +126,7 @@ hot_thres_access_freq
 Access frequency threshold for hot memory regions identification in permil.
 
 If a memory region is accessed in frequency of this or higher, DAMON_LRU_SORT
-identifies the region as hot, and mark it as accessed on the LRU list, so that
+identifies the region as hot, and marks it as accessed on the LRU list, so that
 it could not be reclaimed under memory pressure.  50% by default.
 
 cold_min_age
@@ -134,7 +135,7 @@ cold_min_age
 Time threshold for cold memory regions identification in microseconds.
 
 If a memory region is not accessed for this or longer time, DAMON_LRU_SORT
-identifies the region as cold, and mark it as unaccessed on the LRU list, so
+identifies the region as cold, and marks it as unaccessed on the LRU list, so
 that it could be reclaimed first under memory pressure.  120 seconds by
 default.
 
@@ -237,7 +238,7 @@ The maximum number of monitoring regions of DAMON for the cold memory
 monitoring.  This can be used to set the upper-bound of the monitoring overhead.
 However, setting this too low could result in bad monitoring quality.  Please
 refer to the DAMON documentation (:doc:`usage`) for more detail.  1000 by
-defaults.
+default.
 
 monitor_region_start
 --------------------
@@ -310,7 +311,7 @@ Total bytes of hot memory regions that were successfully LRU-sorted.
 nr_hot_quota_exceeds
 --------------------
 
-Number of times that the time quota limit for hot regions have exceeded.
+Number of times that the time quota limit for hot regions has been exceeded.
 
 nr_lru_sort_tried_cold_regions
 ------------------------------
@@ -325,24 +326,24 @@ Total bytes of cold memory regions that tried to be LRU-sorted.
 nr_lru_sorted_cold_regions
 --------------------------
 
-Number of cold memory regions that successfully be LRU-sorted.
+Number of cold memory regions that were successfully LRU-sorted.
 
 bytes_lru_sorted_cold_regions
 -----------------------------
 
-Total bytes of cold memory regions that successfully be LRU-sorted.
+Total bytes of cold memory regions that were successfully LRU-sorted.
 
 nr_cold_quota_exceeds
 ---------------------
 
-Number of times that the time quota limit for cold regions have exceeded.
+Number of times that the time quota limit for cold regions has been exceeded.
 
 Example
 =======
 
-Below runtime example commands make DAMON_LRU_SORT to find memory regions
+Below runtime example commands make DAMON_LRU_SORT find memory regions
 having >=50% access frequency and LRU-prioritize while LRU-deprioritizing
-memory regions that not accessed for 120 seconds.  The prioritization and
+memory regions that are not accessed for 120 seconds.  The prioritization and
 deprioritization is limited to be done using only up to 1% CPU time to avoid
 DAMON_LRU_SORT consuming too much CPU time for the (de)prioritization.  It also
 asks DAMON_LRU_SORT to do nothing if the system's free memory rate is more than


Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AC6D9EA3C59
	for <linux-mm@archiver.kernel.org>; Thu,  9 Apr 2026 12:07:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0B4D86B008A; Thu,  9 Apr 2026 08:07:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 067366B008C; Thu,  9 Apr 2026 08:07:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EBDF16B0092; Thu,  9 Apr 2026 08:07:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id DC8966B008A
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 08:07:00 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 902AABAD60
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 12:07:00 +0000 (UTC)
X-FDA: 84638891400.16.57149DC
Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	by imf10.hostedemail.com (Postfix) with ESMTP id A8FE5C0003
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 12:06:58 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=rnDFhBVc;
	spf=pass (imf10.hostedemail.com: domain of devnexen@gmail.com designates 209.85.128.51 as permitted sender) smtp.mailfrom=devnexen@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775736418;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=sXdgIpG5FRTBrRjbb+SQdYnUqpZ5GkM25dk30cTxjFI=;
	b=5EGxnzVHkBj7iY5Ws2P89WQYzVAqL5BV2fVO6MrwAFyu1ejKahs4MkccqRJgTk4yheGsYP
	xvj4SBR+qS3KPkCZwOM1HmOvnaPeVvwrim/ffipLFKTd7KRaMUWQdktE52WaBuY5HlSJ2G
	x0pwMRBjgkZg/hq+z0fDmbdCyIM61Sc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775736418; a=rsa-sha256;
	cv=none;
	b=N41Z4Aq0RJ36dRR2TxLp9zV0AgMoI7LPUVZvBHjaQPqSnPe27pfc+Wbh3IPersQbfkkDOG
	+hd7IQgbzB2hqw4sLJjeldhaCiUdz7iBFdj2ULXnW1rSvbjN05VcWQ/28VfEMBQ+Bh4yrp
	j51sQmH1ovI5Q/jGSagz/NPSqLSrYH8=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=rnDFhBVc;
	spf=pass (imf10.hostedemail.com: domain of devnexen@gmail.com designates 209.85.128.51 as permitted sender) smtp.mailfrom=devnexen@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-488afb0427eso11006605e9.1
        for <linux-mm@kvack.org>; Thu, 09 Apr 2026 05:06:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1775736417; x=1776341217; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=sXdgIpG5FRTBrRjbb+SQdYnUqpZ5GkM25dk30cTxjFI=;
        b=rnDFhBVcjDRZJeF2bBADUjwLQp9klTCKIvVxyPGQd8erAsCGEAg2Ok98Pmvz/KrmsY
         4/93Z1ZRUrwYuM1JEWVtR4hbPHSL1dQUS3pk+v2xURpYE43lq6sKvFA3S7hrVe4GvxvC
         kUvK46mAuts2CyiW4DgTW79xcK3SZRvovkaeLMDCjA73ak+a5vB/3Zay12IpSYhYsP2i
         HvCaXedIcbPuMiwvnjmxilyz0uW8YOnqe0v2H5F60zyUHMYAMke91I2eMNd21k1YTf7q
         bMPOjoGunJlcO1NtZ51xJCNDJJItenurysdgUaDYygZI8DDL2QRUs17X6+WaY1ar0GJT
         N6hQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775736417; x=1776341217;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=sXdgIpG5FRTBrRjbb+SQdYnUqpZ5GkM25dk30cTxjFI=;
        b=KaQmWlO1nE386hGoKsGtzVPNb2NsthDzHceHGePYUWgqOYbPOYNF/AESYV8wKKzOui
         s0QnbpeJ3AxNTw/I7p11KisIxhOdugd/FgVloZILCS6OZdteV03/FzeUGTKyYLNHdi71
         jXO7N8TNLbGY21XElDMSYowQsLnhNR1PDA2levTO17AgbLNXqggMp0tZToFrygokOrDO
         fxokluEOkOL9iTb4FUA6Rcrl+BD8Jdd8AcO50KOo7oRxwX1zysQQ37wQZPeovYm6hIyw
         EqLkm81PH+QZSoMCGXeHx4CLAHYcsJpjyHmautHtmZjm8ixBq8Go/PROxQW8CWQNr+XC
         xbEg==
X-Forwarded-Encrypted: i=1; AJvYcCXcKt4H6eocOqCMFuN2GdhxmbvIom8JxIdAu+y56+BE2MNCEO5T+j16AWJGoR3vS1M/HI7uJd2Gww==@kvack.org
X-Gm-Message-State: AOJu0YxSkU6dqHaMMiB9gt9J7dL3ZM/50W/yJrW3AfOH20ZH35uAcOXk
	miFqPKJMlRz6tbW6l/JPCvKnVTNVAH2uSzg0H7ATFd/EIxPqQ/2c1tDf
X-Gm-Gg: AeBDietjpXjOk/N3JYTpaitpaHWg+uL7ks1rBEOrhnNlENvO6zchU9RzUkTAbbzkcaG
	cRaTbXFuWfEs9woPKAHrJwkVlgU+cBQSSrdQS7HJejYCWo81gV8GL3mZsGV5Y0Ku8YSDSrfMswn
	w8PushhhUJrX7rUtjzG9PO+o/R6uFMjIIrS9kE6tYK3ymgK8sXjtVBN3LJNs2eiNmt3YCxnDp/X
	LGDIVtnVwSJJ6UR9tDhsAyS4+kXwdSc+TtpWq3WTrS9gH4Ffu3It6CONNaJrdBDUk9E6LQEt+IL
	EGpeqtxwq4+niiAiidaV2V8xqbYSj93KVxCnt0lY7gb+92M7QdOgXl3bY/F8qec1jmYHidOx6JG
	f6Qba3xaqsN6W1LOW5XDIqmhGKhB/0hoo1g4fqbViDQzthyGckM1inBwZ9k47ErbN3aSiI3dDfu
	jUAGz+IdxQz8W6LVHgrhHldeD1++i+T0cG7+YUiCK1aXIUo+m7Lxx61lyDkGG3K5VMJl0DYRBGu
	CXuXjqbldoicHpwem1O5BE=
X-Received: by 2002:a05:600c:628e:b0:480:20f1:7aa6 with SMTP id 5b1f17b1804b1-488997dd822mr321214615e9.21.1775736416672;
        Thu, 09 Apr 2026 05:06:56 -0700 (PDT)
Received: from dohko.chello.ie (188-141-5-72.dynamic.upc.ie. [188.141.5.72])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-488cf9e8808sm51409725e9.5.2026.04.09.05.06.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Apr 2026 05:06:56 -0700 (PDT)
From: David Carlier <devnexen@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	Mike Rapoport <rppt@kernel.org>,
	Peter Xu <peterx@redhat.com>
Cc: "Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Jann Horn <jannh@google.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	David Carlier <devnexen@gmail.com>
Subject: [PATCH v5] mm/userfaultfd: detect VMA type change after copy retry in mfill_copy_folio_retry()
Date: Thu,  9 Apr 2026 13:06:53 +0100
Message-ID: <20260409120653.290386-1-devnexen@gmail.com>
X-Mailer: git-send-email 2.53.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Stat-Signature: aqfhmgc3ii5ntht4xttochms6uy6zifp
X-Rspamd-Queue-Id: A8FE5C0003
X-Rspam-User: 
X-HE-Tag: 1775736418-839219
X-HE-Meta: U2FsdGVkX1+GyGsh677KITWiqYNl8B2sYmmr4FT6+Y8tAwhWKagpmzEzdhaUS99V78t6vEDUt93cUrgqUETl4AL+pnofAB/X3q1zqG51MnWDdjYT8L932S8TBKZQeZP7d64A2ebH8DxdoYVnT3Gh+CdS7EMVoaODh5iP7E2ZRJ9XQ7ypS/8pz/fNj2FNl9hZW+m3eOW8NDdVN9bSKjT3dlVjJv0okSgEUvrvw2DGJiRbl8Iyfv5O3AGrnlLeyWMkVyfYiPPY6lh6n/IzLlyoVwdUI1Qq/hsEZd9HsCVqqsH60pA8LAg4bsplughiJ1AL/WAobAlX9OiFNuKkK0KdDK8olI/eF5toI+frGWTnKBKekNfXA5dJUJ5/kybcQ8OCqMIOg0qV1YBgfJyd5pa+Y2CCpbT10QTBOtseNhysoilx7pWgd3d0r2IvF1zI8js7vNWkujYsynP5VIB+dIfkS/QLhAqMUPcvdDHaeJHvi7Qk1bfIaD33njqeVUK9ucmVjfe317XKrmnT03K+gOo5XtlDPmdEi+CKzJnY1jEL+V1GWBTQ8zVpCOMfBNjX37q2j2Q7DDtDM6vROBHOZB5aeZJqpoQVj+BNM6cwYcg0GOZ2nMM2WN12U0bLQnMbv8D5y0QNstivY4d4h4sPev1Qrjd+eYDYGFCiyAkgnJ9/1TsWGvJhVbrxQ/9RccwaCbv/0LJXEOtJnyg1KUnb03oiN3RQP/qray+J9NhEXgixvaosr5MsvZ1cidAKs12gPFUnq1ly2n38OEpvRVnAzKbHYO1hAqDQnTZikGgUOi9C9WmUUtqV7hobLNxgb6f1/kF02AtTXXZBXvN4ZRgM3g/dfEsfxRYJ3jWrNq8t518ahVqm46azTqK7zEjW3cQ1zhwV3ssMNcF2BO/D6BDeBy5Sg//xXQzGKh8Md7CFuJ8wpQZL4RJI3Cc70DtcgqnzItDhkTgM2AEPSl7MUhk7ojM
 pV2r/qAH
 YTd8cp9LVbII4vVg026JC6l95pN2vS5A3mvr5mfIREu8yc5T7LpifZGjwPH0zXWgbXK5K3MlsYF/1c5X40RdECKzy2V4zzCQE/5KkGMielGbSSqFH+weNL8YxvqxlT5VnZhP1uL1pRO6pn0Fm9wjYPyo7k4gDkQJs5r6zdwWRbTcfOH+IJ5FZ+voHcE+pcMclGuywnkksbOqUFaVXWiIDsHV8WtrxdBDx/1AqNv+Ce8YQCZuKr+1QPnNxrLfB9EcZaTTu3GmyTmryu6ih0mttUdEsX9ZPZvboFtsgwO/+oOjXbNsPZ8GX2DfuWyeVFoTN2wLSyo6AveKeomnMpLkKj5KviewF4/t/lkuqpYANUI2q5ekVVW9BjpebhDqOneocCKI7jmOYumBgK8Fayz6/0JyvE1nqE/GxfJqHxhgs/FfsnpQ418kOC3/vfO0WdwvV3e7ttzs/kLmLG9M=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

mfill_copy_folio_retry() drops mmap_lock for the copy_from_user() call.
During this window, the VMA can be replaced with a different type (e.g.
hugetlb), making the caller's ops pointer stale. Subsequent use of the
stale ops can lead to incorrect folio handling or a kernel crash.

Pass the caller's ops into mfill_copy_folio_retry() and compare against
the current vma_uffd_ops() after re-acquiring the lock. Return -EAGAIN
if they differ so the operation can be retried.

Fixes: 59da5c32ffa3 ("userfaultfd: mfill_atomic(): remove retry logic")
Signed-off-by: David Carlier <devnexen@gmail.com>
---
 mm/userfaultfd.c | 14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/mm/userfaultfd.c b/mm/userfaultfd.c
index 481ec7eb4442..214923a411c1 100644
--- a/mm/userfaultfd.c
+++ b/mm/userfaultfd.c
@@ -443,7 +443,9 @@ static int mfill_copy_folio_locked(struct folio *folio, unsigned long src_addr)
 	return ret;
 }
 
-static int mfill_copy_folio_retry(struct mfill_state *state, struct folio *folio)
+static int mfill_copy_folio_retry(struct mfill_state *state,
+				  const struct vm_uffd_ops *ops,
+				  struct folio *folio)
 {
 	unsigned long src_addr = state->src_addr;
 	void *kaddr;
@@ -465,6 +467,14 @@ static int mfill_copy_folio_retry(struct mfill_state *state, struct folio *folio
 	if (err)
 		return err;
 
+	/*
+	 * The VMA type may have changed while the lock was dropped
+	 * (e.g. replaced with a hugetlb mapping), making the caller's
+	 * ops pointer stale.
+	 */
+	if (vma_uffd_ops(state->vma) != ops)
+		return -EAGAIN;
+
 	err = mfill_establish_pmd(state);
 	if (err)
 		return err;
@@ -495,7 +505,7 @@ static int __mfill_atomic_pte(struct mfill_state *state,
 		 * will take care of unlocking if needed.
 		 */
 		if (unlikely(ret)) {
-			ret = mfill_copy_folio_retry(state, folio);
+			ret = mfill_copy_folio_retry(state, ops, folio);
 			if (ret)
 				goto err_folio_put;
 		}
-- 
2.53.0



Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 94FE5CA5FFF
	for <linux-mm@archiver.kernel.org>; Wed,  7 Oct 2026 04:10:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BC7626B0088; Wed,  7 Oct 2026 00:10:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B50D66B008C; Wed,  7 Oct 2026 00:10:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A18B96B0092; Wed,  7 Oct 2026 00:10:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7A43A6B0088
	for <linux-mm@kvack.org>; Wed,  7 Oct 2026 00:10:40 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 3FE1C80408
	for <linux-mm@kvack.org>; Wed,  7 Oct 2026 04:10:39 +0000 (UTC)
X-FDA: 85294503798.18.49B6302
Received: from mail-ot1-f42.google.com (mail-ot1-f42.google.com [209.85.210.42])
	by imf29.hostedemail.com (Postfix) with ESMTP id 90CEF120005
	for <linux-mm@kvack.org>; Wed,  7 Oct 2026 04:10:37 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=openai.com header.s=google header.b=S3CFPpXf;
	spf=pass (imf29.hostedemail.com: domain of kylebot@openai.com designates 209.85.210.42 as permitted sender) smtp.mailfrom=kylebot@openai.com;
	dmarc=pass (policy=reject) header.from=openai.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791346237;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=MBRXZKUt5w8de+h8RL2geRZW1pbP7GywRMbabudOQ+U=;
	b=SHOXDvmLxBCbVEssQf5mbRVsA/2A9XKw54Xlonz92oumPxzPHoTEgzuTWe1c1Jbej110l0
	+CAyT+hYeLGcGzym0u/+aCXDSEYUzQ85GnboXTdSMnd/nH4fq6dfIrtW5JziW8fWv3Rpis
	BkfGKHB8FAJJgKIQupbtw1bOKVI7qHw=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=openai.com header.s=google header.b=S3CFPpXf;
	spf=pass (imf29.hostedemail.com: domain of kylebot@openai.com designates 209.85.210.42 as permitted sender) smtp.mailfrom=kylebot@openai.com;
	dmarc=pass (policy=reject) header.from=openai.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791346237;
	b=ZOQcL5tRhwlxqDXe5XsgBVB8Gz6cX/zzFqjuBifSsYkwth3uUmuDYlJjPhKX4fT+nYCQhO
	4+mVunFgz0a5oz5UCTiuC5ghVTEHg5FkH7hGtKx9BlPVhrT25CEZAHl/Tha2ss/FsAecl1
	pzlo8Iag/JWWMfuFVw/4n3PxAy56lzA=
Received: by mail-ot1-f42.google.com with SMTP id 46e09a7af769-82503732024so584307a34.3
        for <linux-mm@kvack.org>; Tue, 06 Oct 2026 21:10:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=openai.com; s=google; t=1791346236; x=1791951036; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=MBRXZKUt5w8de+h8RL2geRZW1pbP7GywRMbabudOQ+U=;
        b=S3CFPpXf4qlWBJD6O6lhUDVdRXNr4BXEbw5OL2vnO+nziX5Y0+6edeDBXmMPPQIK0w
         RI8kjxODReiestNuhZNd6NqzATdiOny2ABNnoyke6/fFVUYCtEYn+Js10VGecEy1Kw4n
         d9/3u0V5kxZw44J8BIYE5nc3rVvesGE6FJF7g=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791346236; x=1791951036;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=MBRXZKUt5w8de+h8RL2geRZW1pbP7GywRMbabudOQ+U=;
        b=OECaofcAMkaJQxltB3WE/SoDRwdDfx9icCAQck9vgdhP+4z+4mrl6gzemiFpZZJYuB
         YYC/qXO+rlgYXEJwegpRddob7pYrS80n1u7qMBWek9EHGu7ibYMQCASf79suHyrVDTnO
         /XHd/EB9yJB12+9+i+EcKBWW//S+VoRkguc2TiMGDHg48cran9RJM4YCVW/6SdViALN5
         Rww2lLOiZHjMd78lehoKMIjoe58t2JR/Pu+uZR3kCtpghFSeUKaUUrZMf76jjJQj/8ZY
         x85o3dfCYvr/1KlYhC7lkXQw9Clbm0SjobUH2c75pVcr63Y9qPoTxKPljKpP6Ab90ntG
         +MaA==
X-Gm-Message-State: AFuF++kq0+n1GXhYvXWFxRyN6hgY2uAVLaJzTsDH34Aj2a7gFaGC58xk
	j6GvbkaOK4vdiXgQfXq84RZa7020n6jr8NIhDWvvv/xR2JpIIKr3H3/TJk9RHnBh7rAC4ndsCXe
	0tJQeEgHO7w==
X-Gm-Gg: AYBFou3MfQhBw1hVwq6ZsYR/xXwIQdHJodNzBJDUESDwqZCGntfcW3howh74zoGdzzJ
	ZpeQYiJP12FF9Ljvmz1p8EDadw57v5e9GKiOgeflAk8DJNGM/shWwoTvx1CDsAtPiInYuFrmKX9
	Rd+KslFMMbSIY14WLMNMIQIR2wgwrJfTyafgizO/gBBcG3KkS3S7PrQdbE5+BWg+ZSuCHmrIvNh
	xwb8MX+mp6PhBSOGS7p7dEA5f+wT5Y7h39EiymT07rENb9zX9ouXo4TRWdcvgwQiM4wYkAuU8NO
	xYuuVx2W6wk0NLRoBH4yOrtonpFPZ3vgB8Iz6Ww8uI3Iyn/nDg3hbc8+XLkRwLxNg/9SDjQTXN4
	4fOiqgLm0XSfQv8IWhya+GlLTDGvw1HQ7glIaMRjWEgN05xJ0j9+ZZbMzIkF+Vkrjd8/yx/7TXn
	zv5y302d1MfnRJ7845mamQoJGXFgrLvCo/K6HP6JZ54XFAkDE/wEsnMymqYpf5G4ZG73bk0mbBk
	ICfeRyeq7lubDg5bdX6Dt17VTucFh8zTOX+SV5EcA0ogbpwTyEnww6wQuxmPkpUCtvy0+OAf9g=
X-Received: by 2002:a05:6830:6485:b0:81c:e3de:d194 with SMTP id 46e09a7af769-82acefa6e00mr2083117a34.10.1791346236482;
        Tue, 06 Oct 2026 21:10:36 -0700 (PDT)
Received: from com-75606.corp.openai.org ([199.47.143.7])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-82adcb187c8sm1864670a34.22.2026.10.06.21.10.35
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Tue, 06 Oct 2026 21:10:36 -0700 (PDT)
From: Kyle Zeng <kylebot@openai.com>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	outbounddisclosures@openai.com,
	Kyle Zeng <kylebot@openai.com>,
	stable@vger.kernel.org
Subject: [PATCH v2] mm/khugepaged: flush deferred unmaps before dropping a failed folio
Date: Tue,  6 Oct 2026 21:10:01 -0700
Message-ID: <20261007041001.43181-1-kylebot@openai.com>
X-Mailer: git-send-email 2.55.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 90CEF120005
X-Stat-Signature: bom6x14td5pq65eytbx3c31gra6bc1wk
X-HE-Tag: 1791346237-728092
X-HE-Meta: U2FsdGVkX1+jkVDcunVhtDl8tV/NtsRAxL495AIFtjjZl6ZILbMvkKa0mt+ziiznRdp5doT/XLVBfOrwdZs21iqK8AJY1hNlNuTYaWHBPZN154lYW5ZMmxpK23rbjra7jixsa43Td4ycHybAMKMsnLKlH5tKLKHwpy7oC3Fjn/zg97VD8/i1iw2g+HOhcG8UjchexHsCQazJK877xExhLCkaDXvD7kda+TQ9ydQuPwbD7mlD5emm8x9VH9tDTt5YlTCv6e05pjllqvL+EqNmUk4BuKTU/k9BkIEi0/kvvNIy77KopFpeWIJu1zIlYWhle1kIgO3hShp3CAGV1I+fIEqnOVKZOwttbbhkuyo3yEo1sMToXI6LHt3Jsps6q5O8maN9423ruh6ZKtU3CiAl0KHBSsQAGQ0/E4z9om6u+SMdZmeguA/wxoQjihraX71tCQ6gwJYAsIGDIqrOarCRh/EdhNAi+KOHuMeNlUG9nn0SqtUyFsrPwh3VSh18LG4tTMuvwzmAx20A8tV96KMn+11qUmK7YoLyGZEXAwLsc+SSpFytaBqj65TooptQ8FaDOSqTP41EwObqg+I7MWiXl2ldbnKBw3cuD7iRmqQktI7rJ//qzuCl/8UX4kApFZdtsvI2F3DEditkLGJYNQM5dfkaomLZ/DOQbK61BC6q0A7pc3e5KzPc/SUdIXiB+SqvzKS/SE1TLPV6QgIHugxQ1c7rODkhrSGjo/SfqbtFTVELM+10Bclx+d1ZeeQYbT9vSoHlngsemXS7l0gA/E1rJdEAdjhRBmS0S9ORs/pEmM2S/LrPq8PkOdM/Mi3YqXOQ8fPJwvuzq/GO9yPcJ6NsuS8maFxFZN5PkSDQsjGlAXSPT9zB9X0vBo6Chgtrj9y5kWMraVdaN+QTVEvZwjJNEcxMuY+dD8LubIAXqCmlAC/SqsL0gvzkrHMRaFWN6Xf7i4a4Sp80KDWEJHkkf6B
 SUYLjPnc
 PkzHPp2sQ8ByJgHBue/3my0WxW4moKqb7U43Kg+NTjBFNX4VqX6ndqvf+AbltjYuDTHE5A+imMaVOxWax144NsaB4qU9q30EEOYDHD7UfCEcCDDgdLXX3yOqzdFaKpQVlPgenEhBS7vIY71+8Gefs9oltJU5RbIbp4W01p27ft1BSYpzYJ5/ROAv3K5TFtQ6CgH95nOzQdslwEAFu+mWjk8X3a29KCbrfXASnio6XKw2VZrIy9ZEuDlV2qyeBZhinYVEQFknTkxipG7y04+cYMNuj38shhWsQUyHYpVGykUhfu4x6zL5MQ9nvfVXHdASoVOMS
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

collapse_file() can fail its reference-count or dirty-folio check after
unmapping with TTU_BATCH_FLUSH.  Both paths put back the isolated folio,
then unlock it and drop the lookup reference before reaching the common
try_to_unmap_flush().

The page-cache reference does not keep the folio stable once the lock is
released.  Another collapse can replace and free it.  With its PTEs
already gone, that collapse cannot flush the first task's per-task TLB
batch, and retract_page_tables() skips short or unaligned VMAs.  A CPU
can therefore retain a user translation to the freed folio.  This has
been reproduced with unprivileged MADV_COLLAPSE on a memfd.

Flush at out_unlock while the lookup reference and folio lock are still
held.  The common flush continues to cover the accumulated pagelist on
both success and rollback, preserving batching on successful collapses.

Fixes: 6d9df8a5889c ("mm/thp: collapse_file() do try_to_unmap(TTU_BATCH_FLUSH)")
Cc: stable@vger.kernel.org
Assisted-by: LLM
Signed-off-by: Kyle Zeng <kylebot@openai.com>
---
Changes in v2:
- Use Assisted-by: LLM.
- Explain that the common flush is a no-op after out_unlock flushes.

 mm/khugepaged.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index 75639298efc2..e1a5890818ad 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -2478,6 +2478,11 @@ static enum scan_result collapse_file(struct mm_struct *mm, unsigned long addr,
 		index += folio_nr_pages(folio);
 		continue;
 out_unlock:
+		/*
+		 * The folio may have been unmapped with TTU_BATCH_FLUSH.
+		 * Flush before releasing the lock and our last reference.
+		 */
+		try_to_unmap_flush();
 		folio_unlock(folio);
 		folio_put(folio);
 		goto xa_unlocked;
@@ -2488,9 +2493,8 @@ static enum scan_result collapse_file(struct mm_struct *mm, unsigned long addr,
 xa_unlocked:
 
 	/*
-	 * If collapse is successful, flush must be done now before copying.
-	 * If collapse is unsuccessful, does flush actually need to be done?
-	 * Do it anyway, to clear the state.
+	 * Flush before copying the folios, or releasing them in rollback.
+	 * This is a no-op if out_unlock already flushed the batch.
 	 */
 	try_to_unmap_flush();
 


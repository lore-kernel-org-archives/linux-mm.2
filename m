Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 47CE5C5AC82
	for <linux-mm@archiver.kernel.org>; Mon, 10 Aug 2026 09:32:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 34BFB6B007B; Mon, 10 Aug 2026 05:32:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2FD4D6B008A; Mon, 10 Aug 2026 05:32:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 213846B0096; Mon, 10 Aug 2026 05:32:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id F06476B007B
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 05:32:57 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 825F4806DE
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 09:32:57 +0000 (UTC)
X-FDA: 85084845594.26.47BB611
Received: from out-189.mta0.migadu.com (out-189.mta0.migadu.com [91.218.175.189])
	by imf04.hostedemail.com (Postfix) with ESMTP id F013040009
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 09:32:53 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=YQ4BDv4R;
	spf=pass (imf04.hostedemail.com: domain of hongfu.li@linux.dev designates 91.218.175.189 as permitted sender) smtp.mailfrom=hongfu.li@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786354376;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=1XFvf8w7v4DlH4awXePCLi5hpsAxTi4mLDtG0/Z7htc=;
	b=MVMotB/TF6DZ5p+hHDml8/uDcHD1/iMg/ses8DgAiIznst9H3vtzvq4w0BooYEF8W8qBc/
	/JCG6RX443zPTHrXZ9ThP8KmjjNhBOO+EC1yCyffLSoFOawQ4BfZ4/HxQvqtHnas8Ca4WO
	ViDsazAHjj+ciJTqJRZm3lsKf77aSaA=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786354376;
	b=zjGEuEFWkyuDKKs35oPLJ9D/2vd4Dkc15sfvFUS5hkzFVtUxF3x0b669/rNp0VF2z26CJv
	vrcXW0DBYqeow1viJ7lWe5D9aFKH9X470vWQTTI3o74H5KTArxOEVex+7cTNUroy7mLbbN
	Jz6XBCNHxIT5hbhKY8VTuPD/ZkC2gks=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=YQ4BDv4R;
	spf=pass (imf04.hostedemail.com: domain of hongfu.li@linux.dev designates 91.218.175.189 as permitted sender) smtp.mailfrom=hongfu.li@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1786354370;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=1XFvf8w7v4DlH4awXePCLi5hpsAxTi4mLDtG0/Z7htc=;
	b=YQ4BDv4RX2WwPEQQ8BDcG8Gcq6JLVa1hpEWCKM99bA9S3peEMMpAk8oBV8UdN9q8UQGp/+
	DK8Md6OeiEHLJNqs2JPPgdIZ36XJxVHDmBhIBL0fMO0+ZFEUrvt89NA2E16Q3nWPTag45Z
	Mo1CpT9o3bEsknJcgTNtKV4iWQKZWI8=
From: Hongfu Li <hongfu.li@linux.dev>
To: akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org,
	liam@infradead.org,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	hongfu.li@linux.dev,
	Hongfu Li <lihongfu@kylinos.cn>
Subject: [PATCH] mm/cma: remove stray newline from auto-generated CMA area name
Date: Mon, 10 Aug 2026 17:32:15 +0800
Message-ID: <20260810093215.91419-1-hongfu.li@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-Stat-Signature: ikwnbydb98ddasf47nc3b6doozxbxs5d
X-Rspamd-Queue-Id: F013040009
X-HE-Tag: 1786354373-908197
X-HE-Meta: U2FsdGVkX19l1cpGkhYOb/2+rlPCg2XzC7f+bHGzaTAle1Hz2iljs/6Up6Lx9kDFiXQ7Kv/2yOWyvPVBmOt++Izj/DmLBxNfyU4yt0WSIrfiAxPBRFeTrLifK8UnVDx5alvKiySZtpj6m75EDw7cUobE2m9AQeRaWXQcpvsgZKZW2nWVkZS2mJc5j/yatty19kQvR23un8Js+R2KfLk0oxi6iS8bdcxphdMZqUAu7cZrelZnN1mIr+PpnF9RwKIXlvyNP9SEKHftvpb8pBh1JTZENyPiW78wRY0r0if0ZdVg+3lf5QHGDcVPOt2Ubmw2ZW2U/pPQSzZ7vKxxkVUk78zSJkHN2HLl1CK0JPGo7htBytL6JY6zQMmbhPd5H5g6q7Qvyt3otRjIJ/hmKKHITlrC8Dmzd6eyAc0RC/ikkvzcYel98lC1+xzBq+NfMYU4R8vMOl3URz8GBFMEoPETamBWolO4XqVzB2QqeHxmJ5ct96ul97MKTbooj0pHgIJy8tDfzstj+r13jasISq1ugnWtTtlIp9iUa1kdbpA5bbU8baXwVt22VCVZUFm9bgu+iNJ1H1vojVG9x2U2tRylw7tIbZuyH3VBn+WkWmf//vHsONLzQIS+e0YKfD7gMHNj04VqKLCinK/qEpJal0P5t+2NyTXxPORTY7tPgkEM1ygaG9+xsVlAm9a0PMJKxUuiynChPIPpkqml5+Dgm6dP6J9RaVvKE/vOET/nl6O4UI0B9Jv/b86P50TPlPTfqQG3tLzNm2yFRF7bsm0T/gWnslMb1M0xWr1vKs4Wyv9YvfU8RIVynXN1RYdyFOSbhWi2jNbn3ijrnZqvyBnl+q/fofWlobby59xRBqMkhY6hcGgJFJUbgjtr7k/2AI/zN/srASrD+pmCm+HCHAaeGGAAmuwIDpoLOi7uade03yOZdwm932InIZejaiLQTSwcZ0+5b36tqSTsuCB11fw9N6h
 T5m8FOlL
 tmylVJcVxAJ5oWzph+aNXgmLQGOK3u+UAOknm1na9DPf/A9I+/0019I6vo/Yc/bmytc39CLopuiBhWWz6M0l9PBcV0fzepml99A5JidZVSJzXC5eoCpj4SV4KLnF35aN9V8nW8pDVNeIdxRazDVOLtcL9J6ZNAyzpKGm+JDsEsvQ4vcoQRNy1ZvRdWmVlxPNXceGwN+BoXaytZ3Y=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Hongfu Li <lihongfu@kylinos.cn>

When no name is supplied, cma_new_area() generates names with format
"cma%d\n", introducing an unintended newline character ('\n') in the
CMA name.

Most CMA regions are created with explicit names, so this path is
seldom hit. The newline only creates cosmetic noise in debug logs,
traces and debugfs with no functional impact.

Signed-off-by: Hongfu Li <lihongfu@kylinos.cn>
---
 mm/cma.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/cma.c b/mm/cma.c
index a7929c758df1..a10ea37a261d 100644
--- a/mm/cma.c
+++ b/mm/cma.c
@@ -242,7 +242,7 @@ static int __init cma_new_area(const char *name, phys_addr_t size,
 	if (name)
 		strscpy(cma->name, name);
 	else
-		snprintf(cma->name, CMA_MAX_NAME,  "cma%d\n", cma_area_count);
+		snprintf(cma->name, CMA_MAX_NAME, "cma%d", cma_area_count);
 
 	cma->available_count = cma->count = size >> PAGE_SHIFT;
 	cma->order_per_bit = order_per_bit;
-- 
2.54.0



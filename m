Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7FB01C88E5C
	for <linux-mm@archiver.kernel.org>; Wed, 16 Sep 2026 08:25:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 65EBD6B0093; Wed, 16 Sep 2026 04:25:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 638116B0095; Wed, 16 Sep 2026 04:25:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 574AE6B0096; Wed, 16 Sep 2026 04:25:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 2DC756B0093
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 04:25:47 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id DC2B64064F
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 08:25:44 +0000 (UTC)
X-FDA: 85218941808.26.33CC4CD
Received: from mta0.migadu.com (out-155.mta0.migadu.com [91.218.175.155])
	by imf25.hostedemail.com (Postfix) with ESMTP id DFBF7A0004
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 08:25:42 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=mxWZ3a5S;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf25.hostedemail.com: domain of ye.liu@linux.dev designates 91.218.175.155 as permitted sender) smtp.mailfrom=ye.liu@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789547143;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=e7J3QTjTF70u7VTLKk+bXscovi5fNJVgb7m1iXC/1ac=;
	b=eA8dIa+cKOZInlRsSq636b5nrhWlFoWoMRHs5vT/594PJ8T27uPTwXsKLDDRvL8BhtG1Kq
	wF4ju8J7MTIMWj5sh66QN0Zj4tDneoUIoHxTAOWeHJ+3V1dwBivmtKCg+TIus7kGF8sMAn
	/dwIf3ufpTzrynTC/ItMdjF9ZkKhx7Y=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789547143;
	b=s8ZMWQtcTG8/SdHb+4iwsuz1KKpqSgr73QcgR2aG7KnjQS8Qpb7hRefMJwNqBFqpTI46vY
	ezqi7HW1r/InEP7P+/wwT5d+WNmD8o3W8qrJDQLhPLnx3TL5reZ3SfeOegqD7IJX6wOxbn
	k0Pdd/WVLUktcdj0a0XYW7kk04M9IqM=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=mxWZ3a5S;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf25.hostedemail.com: domain of ye.liu@linux.dev designates 91.218.175.155 as permitted sender) smtp.mailfrom=ye.liu@linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=TgBqgmk/OGkiRG4oFsrkPk1fFb54WBL3zueWiSKqe7I=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789547141; v=1; x=1790151941;
 b=mxWZ3a5S60Wa5HGuVt5Xpgegd0w934B026RhIHea/bfbbzJ5TR8xkFXpoch98392Bhy/qz2e
 TNAsCgDySYfWU7PdPwsVIo5bVmZMuD/DEBE1jPe6Ok+Y0i5YC7Ji0WL0jrcSapwE1Mh4FV/nLUt
 5uzORfZMaQHJsXWk1VK9ZUhg=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 440f386aa9fdf0d8;
	Wed, 16 Sep 2026 08:25:41 +0000
X-Mizu-Trace-ID: 440f386aa9fdf0d8
X-Migadu-Flow: FLOW_OUT
From: Ye Liu <ye.liu@linux.dev>
Date: Wed, 16 Sep 2026 16:25:28 +0800
Subject: [PATCH 1/3] mm/vmalloc: fix vmalloc_dump_obj address alignment for
 last-page lookups
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260916-vmalloc_dump_obj-v1-1-7aa402d224df@linux.dev>
References: <20260916-vmalloc_dump_obj-v1-0-7aa402d224df@linux.dev>
In-Reply-To: <20260916-vmalloc_dump_obj-v1-0-7aa402d224df@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>, 
 Uladzislau Rezki <urezki@gmail.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 Ye Liu <liuye@kylinos.cn>
X-Mailer: b4 0.14.3
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: DFBF7A0004
X-Stat-Signature: iz1nxor1zy61r9jkq374ndzpch5aqick
X-HE-Tag: 1789547142-431078
X-HE-Meta: U2FsdGVkX1838MI9UdTnnrT0x5f+JadvCAlzysUp7gjkBmYqHYKqcahQwC1lxImTuBOHVLw7hBJyYflJe5TefG7sbgPLyq0Tn6oWZi7k7NJv2ky3G9S2MkfbjO2XuHEoR4WxOmjx2PRUYBnSnlahz57GzPxbcVXX/WVKhR4EcHVtmWv+H/lchWYDCilKJ/+W8v05JMOkP9bCsXq0copXGzI/6PYIqKUqTBVtM8LR0PhH3e/HRpC+1D7jTASRvwHB4tT8P/zCTQlaNeG6yr8pAGkXeAHM7H3P3xZGNdkT8kc7Qz0StxfcM8QwEnS+ySltzNNCgkQVF36RKLBDsSoRaveS84iYVo2ZShGG3ZnsXsKNGVkqZvMqJFidZ7rp0eisIdbp/l3kGfEfMjhxZF5KTcBYV7fLPlGFcz0j1ouleoW+paPduBOL1JE2aWTrgeQ1JB0N0YZtaak+PmYYXJHN68S6CwFnkstW2ai+mMKcUBBMqTtb03RHbnbYGEeTPv9BAm4uXNxSC6k/Zev6jUsG1iZrb/r4m7K7Q3SRtG95u0FKk90QYD1xAXgYRJN9S8AI7zR9G9OES2WW97hmw49sE+LI/mRKqA6ID6nVe423p5T5dTRYsdIjAavQwF89TTCHyTHMJWNnu5TbSrEW8Fxl4Uch7O86Cd4YStTPLZIbWCkSqOwE+3fQZVOlQCzA7rVibKEGqgP86aca//ytfmkDhTVZ2EKkyiNqwcjqueS09rXu8CT9Jb/S19Ll/bRWoc6E31h1Pq6AO/1dS9hRG+4jVOQo3Pki3uvO2Yigdia1KkTJEzFnPnliQD5ZkoxyRP72oDtNmNhpDy63vjzopdx8POisZbCUi60HrdgBLLdyRC1mW2JfGcsXDSB1fbkKKCJAzeJGAsCM0XRgOj6o3eml25bz+tyYFtU8Zs8JiNS0Ys/cpQarOSs6A4+lOyadh2HP35vn+uCaNuKij3h8l9p
 LOaek/xM
 lU6bDtWXN1hFiZZq3jESE2f2a7FnEwkexBNtYJmakdnP6ke8uNawBmyQE/OuDa23BN3dGOhnTp5gIeAw01/HOVikMs7UJnYxe6mFoulod+L+iOZIsvxj7/v3H/4aIcdXzO1BpYBGL9B9ogDsfnKeeWSsi4PX2dqy40FaxNkeL9+iZDzQCA4rTjyHDx7NdSEgwkDgl/w01p9aCkBefbXJ1bZCCG+fQ/RPJsdEB67dXL0mEXPUGCyn6u4ZLPXLb6Yc/llBkw1oGT5ydlRBzUnIbV75ESg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Ye Liu <liuye@kylinos.cn>

vmalloc_dump_obj() uses PAGE_ALIGN() to normalize the input address
before looking it up in the per-node busy tree.  PAGE_ALIGN() rounds
up, which can push an address in the last page of a vmalloc allocation
to va_end -- outside the [va_start, va_end) range that
__find_vmap_area() searches.  This causes the lookup to miss the VA
and return false, degrading diagnostic output in OOM dumps and KASAN
reports to the less informative "vmalloc memory" fallback.

The upward alignment can also change the addr_to_node() mapping when
the page boundary crosses a vmap zone boundary, causing the search to
hit the wrong node entirely.

Use PAGE_ALIGN_DOWN() instead, which rounds down to the page
containing the address.  This keeps the address within the VA range
and preserves the correct node mapping.

Signed-off-by: Ye Liu <liuye@kylinos.cn>
---
 mm/vmalloc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index 859e6d2d57a3..df42d8a6f058 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -5277,7 +5277,7 @@ bool vmalloc_dump_obj(void *object)
 	unsigned long addr;
 	unsigned long nr_pages;
 
-	addr = PAGE_ALIGN((unsigned long) object);
+	addr = PAGE_ALIGN_DOWN((unsigned long) object);
 	vn = addr_to_node(addr);
 
 	if (!spin_trylock(&vn->busy.lock))

-- 
2.25.1



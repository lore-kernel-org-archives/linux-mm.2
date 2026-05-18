Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BA1C3CD4F50
	for <linux-mm@archiver.kernel.org>; Mon, 18 May 2026 18:27:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BB7D96B008C; Mon, 18 May 2026 14:27:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B42206B0093; Mon, 18 May 2026 14:27:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A0A606B0095; Mon, 18 May 2026 14:27:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 893E96B008C
	for <linux-mm@kvack.org>; Mon, 18 May 2026 14:27:12 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 377AE40A77
	for <linux-mm@kvack.org>; Mon, 18 May 2026 18:27:12 +0000 (UTC)
X-FDA: 84781372704.20.9E7DD75
Received: from relay.yourmailgateway.de (relay.yourmailgateway.de [188.68.63.162])
	by imf14.hostedemail.com (Postfix) with ESMTP id 813B210000B
	for <linux-mm@kvack.org>; Mon, 18 May 2026 18:27:09 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=phwe.de header.s=key2 header.b="f/y2DjST";
	spf=pass (imf14.hostedemail.com: domain of kernel@phwe.de designates 188.68.63.162 as permitted sender) smtp.mailfrom=kernel@phwe.de;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779128830;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=lI8P44C5ab3VkmVwJK8kA3X7b5dIv78WZ8xizbOii0Q=;
	b=XCGRHT6rL4zHUiU7T7DOhyRo57iWEtf92aV/jm1y7gBjmZcqv2zq7ej8LYAEloZM8fVgIF
	VLG6Fftz8Og33e5FB/mI6kOwr6pMgzkbkEifmKsEHsLbUnEyitG0/demB+7DhDltniDwst
	+GNwXOam7FJUScb5zf9gPKhPyUTz43A=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=phwe.de header.s=key2 header.b="f/y2DjST";
	spf=pass (imf14.hostedemail.com: domain of kernel@phwe.de designates 188.68.63.162 as permitted sender) smtp.mailfrom=kernel@phwe.de;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779128830; a=rsa-sha256;
	cv=none;
	b=nfsD8yswXMP3aueYBJWr2ZcO1Bppi0n0HbYgQK1v/dodPrRpKYD4772jmE4FMyeI2AQz7N
	Hwfslq3mXzSp9cjOQsDEDfRdtap0DaW5slT+4NA9Kz5uXp/5nVl+FkC/JezLBh9uWVbbDq
	wRBM6pctjq1gclqq5glvFiSIwx6N67s=
Received: from mors-relay-8201.netcup.net (localhost [127.0.0.1])
	by mors-relay-8201.netcup.net (Postfix) with ESMTPS id 4gK5qv5s7sz44h2;
	Mon, 18 May 2026 20:27:07 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=phwe.de; s=key2;
	t=1779128827; bh=Lf7UAWV/kjUUhHpP0mRUhuZ1JIY/eond5cWSDt9e0qo=;
	h=From:To:Cc:Subject:Date:From;
	b=f/y2DjSTtevyYLpzRWSovDDwBzRRiNnP/03nu7Lt6SI2wYkst+Hw0fSd2/oc5xNTC
	 2L01yeVncrsO8h0P3E5utM7dpab9LIRpLwI0YE6ggKKTRrtUmL4bM9AikIa9mBQqFt
	 TcXs6xTwwVzvw+gAD9BqXd65H/0eHZSZeLkTtzud01lqH4LXzGikk2bzT+jnFemQac
	 66m5gUmcqebHjfZxU/86bVlxs+MzbWSXA+TnVBqfQEmQcxcDmhOeNiWwC8PCGW+Lew
	 oUMy8O6ePhtZh5kBI3gyqoOaEbgeV9wsdmWNgfeZHp17gyp82XbnN+gO0n2/cUizX9
	 jk0tvS50ifrqA==
Received: from policy02-mors.netcup.net (unknown [46.38.225.35])
	by mors-relay-8201.netcup.net (Postfix) with ESMTPS id 4gK5qv56nlz44gx;
	Mon, 18 May 2026 20:27:07 +0200 (CEST)
Received: from mxe95c.netcup.net (unknown [10.243.12.53])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by policy02-mors.netcup.net (Postfix) with ESMTPS id 4gK5qv0HbJz8sZP;
	Mon, 18 May 2026 20:27:06 +0200 (CEST)
Received: from mandalore.fritz.box (p5dd24ed4.dip0.t-ipconnect.de [93.210.78.212])
	by mxe95c.netcup.net (Postfix) with ESMTPSA id D1CC68019F;
	Mon, 18 May 2026 20:27:05 +0200 (CEST)
Received-SPF: pass (mxe95c: connection is authenticated)
From: Philipp Weber <kernel@phwe.de>
To: akpm@linux-foundation.org
Cc: kees@kernel.org,
	brauner@kernel.org,
	jack@suse.cz,
	vbabka@kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [RFC PATCH] ipc/msg: Use dedicated slab buckets for msg_msgseg
Date: Mon, 18 May 2026 20:26:31 +0200
Message-ID: <20260518182636.58134-1-kernel@phwe.de>
X-Mailer: git-send-email 2.53.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-PPP-Message-ID: <177912882656.211742.12285739949726872344@mxe95c.netcup.net>
X-NC-CID: MAsjFXrDzJtuEJ4q9m8J8draoP01HUam7Q4eFRsrvg==
X-Stat-Signature: kbujfek5ajbhb7giftontsss4xw5xnyc
X-Rspamd-Queue-Id: 813B210000B
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1779128829-243805
X-HE-Meta: U2FsdGVkX1+lc1OD5TP8xJlfjN5NjFd4qfWNuprxEiwmekybjQPZJliBIC7nyMRD+fkVpMyon42JoWB+vffBDlWZzH0e/D9L2x+9DnDTPyyiv5sfxKgPC4Q087R85+oTvxR38Vzt6t+1fDKNV2stb6VBOCkUe8ruokRngyTdCyvsE87Em3jhNU32dE7o2xZBkoxDD5MJ9TT2wqWDz3QTwoBZ8aOzN22woRlyHJUluW1Iq5aBpx6Hb65hpF2EkxGu/0d/dc71Bhia+JoccDbOLg4pgEwc3XlAeoR+YoVh3+BvwtYJ46bDHfLupLPxBNyaLIOjZlcvFbDIMzVwIaJvPfIienR8V9U3zzv6StlKJcPJSjlfNdJNEgOjCVG2OPucx8b3QzuGQNuXJYcjGCoZ4kz4C5/Y9UtoG0Jub937autRI0K3dnq1x84bY0RnRgxovNl02fx+xujjSSekFJ4Adar3qImrp1u0HxRarmv8QUIP5OPckcYqZF/YsWN78N1f8VCC9sp7w7OHbP9dTjdwhOec0MEvYHI+RNsx1Bjiynmpw4EBe6Nnff1aiRsWr0YI2+dPCtAnhZYeZg3U8j0wMXw+iJuqHALVAnj8RNO1gKArW+LTDP4l5cT+oHfb+zKQy80/mB8PpaWQnc6bqRqsWyqkmpdzCcXHjLddQJXNoaR/G/fjYvqWrFtnj5/sP6JmdfyOW9fQGCYjsGF8/ElCZpCvKDLfWu2R4OIFdeuX7bTZGHRS7lhOClc9C7PO8W3Dpq606TF2Csdo4lBwKnLd5Q+XkICm18Y+3Dst9XyEToIYgBflIj8+maKIu8SQ6sw6qYgsuN7yVUqlN7jh5t6maF536s0gLCbIzBlMWKbXWkbsk5hZifeDVToxaYvt1rRHHt3UEhXk5fYhCzP6TsgSiisD3KdztQZY4vmL11LaR0uU9T66lSETPhvnnCUcy9rbU+gVjEI25z/ptUPhwNX
 489IlMwH
 GiNecGDeoUfbgcqddQMDKV/znwTjIABzgBuVoJUyGFpSVIXLMAyNukQN7zgWRic7AzQoJj0l1YzYPLBFQicDSh0/yJs6CR/NwcCOcD/rIFQykihmJQ0zEmQfRqjyCSApeacukjsg1YtYeGk01h1T4yeUT9OcZMLrMnTelPV/sIwIiDmqO/McjDZZjGLJwtDn/sjrGfFCdBMxuWAy0wsk0/QqFDg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

System V message queues already allocate struct msg_msg from dedicated
kmem buckets, so user-controlled variable-sized message allocations do
not share generic kmalloc buckets.

Large messages allocate additional struct msg_msgseg objects for the
remaining payload. These allocations are also user-controlled in size
and contents, but still come from generic kmalloc-cg buckets.

Allocate msg_msgseg objects from a dedicated bucket set as well, so the
segmented payload path follows the same heap-isolation model as the
main msg_msg allocation.

The free path remains unchanged because these allocations are freed
with kfree(), matching the existing msg_msg bucket allocation.

Signed-off-by: Philipp Weber <kernel@phwe.de>
---
 ipc/msgutil.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/ipc/msgutil.c b/ipc/msgutil.c
index e28f0cecb2ec..8aa8ac180317 100644
--- a/ipc/msgutil.c
+++ b/ipc/msgutil.c
@@ -40,6 +40,7 @@ struct msg_msgseg {
 #define DATALEN_SEG	((size_t)PAGE_SIZE-sizeof(struct msg_msgseg))
 
 static kmem_buckets *msg_buckets __ro_after_init;
+static kmem_buckets *msgseg_buckets __ro_after_init;
 
 static int __init init_msg_buckets(void)
 {
@@ -47,6 +48,10 @@ static int __init init_msg_buckets(void)
 					  sizeof(struct msg_msg),
 					  DATALEN_MSG, NULL);
 
+	msgseg_buckets = kmem_buckets_create("msg_msgseg", SLAB_ACCOUNT,
+					     sizeof(struct msg_msgseg),
+					     DATALEN_SEG, NULL);
+
 	return 0;
 }
 subsys_initcall(init_msg_buckets);
@@ -73,7 +78,8 @@ static struct msg_msg *alloc_msg(size_t len)
 		cond_resched();
 
 		alen = min(len, DATALEN_SEG);
-		seg = kmalloc(sizeof(*seg) + alen, GFP_KERNEL_ACCOUNT);
+		seg = kmem_buckets_alloc(msgseg_buckets,
+					 sizeof(*seg) + alen, GFP_KERNEL);
 		if (seg == NULL)
 			goto out_err;
 		*pseg = seg;

base-commit: 5200f5f493f79f14bbdc349e402a40dfb32f23c8
-- 
2.53.0



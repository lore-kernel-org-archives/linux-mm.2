Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 244D4CD3423
	for <linux-mm@archiver.kernel.org>; Fri,  1 May 2026 17:31:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 78F3E6B0096; Fri,  1 May 2026 13:31:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7666F6B0098; Fri,  1 May 2026 13:31:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6A3ED6B0099; Fri,  1 May 2026 13:31:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 5B14B6B0096
	for <linux-mm@kvack.org>; Fri,  1 May 2026 13:31:47 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 22179401E9
	for <linux-mm@kvack.org>; Fri,  1 May 2026 17:31:47 +0000 (UTC)
X-FDA: 84719543454.05.DC2AD50
Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	by imf04.hostedemail.com (Postfix) with ESMTP id 2B02140013
	for <linux-mm@kvack.org>; Fri,  1 May 2026 17:31:44 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=IrgAn4FP;
	spf=pass (imf04.hostedemail.com: domain of crisjacobmaamor@gmail.com designates 209.85.214.171 as permitted sender) smtp.mailfrom=crisjacobmaamor@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777656705;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kl2Z21aRDWvEO9ZM3F5D114Gv3b0H+mzb5aSolSK6U0=;
	b=vtFKeM2zMBrBoCSQ0BTVgD0nefdjfzWCP3+YPOhef/pkXjFaeGBI6JbrK+D5QGoAGKTkOO
	Yk7DFMO7Gd+vGmdsnw5OebtsHcGgKri74d5O1PXQBSpT0zo+EPGnl2DjBl7zhymZ4E/oTQ
	Iulh8n7Iv0Ho+2ScGfAqJT+GHVfP9OU=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=IrgAn4FP;
	spf=pass (imf04.hostedemail.com: domain of crisjacobmaamor@gmail.com designates 209.85.214.171 as permitted sender) smtp.mailfrom=crisjacobmaamor@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777656705; a=rsa-sha256;
	cv=none;
	b=yN5rViI1SEpsN25XoE+4cUtsRaqlO5kfQ9A+3dHwM4m84wV1EqfDayQNHV0BLx+0uiwldM
	3oYxaceqULhAq+f/RIhMdYZ+HFvDZVpcgNObF1Ofkl0nxyDJKD2gCnHqiCIwPE8G/KOK6v
	0iCI8iNC0vRJQLxhEL/Vpk+yTf1LOx0=
Received: by mail-pl1-f171.google.com with SMTP id d9443c01a7336-2b9ea536877so2040185ad.1
        for <linux-mm@kvack.org>; Fri, 01 May 2026 10:31:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1777656704; x=1778261504; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=kl2Z21aRDWvEO9ZM3F5D114Gv3b0H+mzb5aSolSK6U0=;
        b=IrgAn4FP+0paTRcyhdesrPAcweYQoPwhX/rLhrEqiOU5v8pg0vyzYs1AY9ysRTgFah
         /7ZDyvcPZa3/6ZEh737007lMucISggoGu2IKDG+th1Cn8spocFQ8O7Cszq8SXKNfDyDI
         QDmeN8uiswc8e18dlPz0mXXxVd7QOU9dLgsEpde4ObeNcfzGvfaZGUuEcxD2IZfrcrj5
         tpyUp/yWZ/6Jt1NP9juHXFGZbUgzGAYGC6DlX1wc1J8rapkQgBPeqHDpyNuwM8Iy80Jx
         9z+52MTeOLy4RMiyuqUuTXMikFTn55b0Ug7Ojwxjv3X7m1nzTPqwy7YdtotwNtqGKPmo
         KKjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777656704; x=1778261504;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=kl2Z21aRDWvEO9ZM3F5D114Gv3b0H+mzb5aSolSK6U0=;
        b=Pg3W0VvlZlcHijbhY2YByhDXuOoovnesLTaPlzDcC3WFpyt7k3TBqQSDNYk3vId8PM
         Oj/XVCTn3px2gMml1daeVfOPSVwVMdbGIzKUGu5yVj/0yJpxSqE6XRlxy6qjhQchAO3k
         jKbW8a/UO5tHSDLVngh6rGGQI5FC7Gl0BHerGfPjLBR6ho6Fm4loQ/FITXIXATPEqK0h
         CKq1/TBlkdK5dNDQdi7Wln/Auc5j2J+GhDVj1d/KuIQ3TSAdFZpnC1f9ydmSCJzc1JC4
         5Xp4yA5JcvE/HLTP3IVF742LLPpY5+pqQEnI234FJNWbthd9jUGZH1cHYeAceNxu3sN8
         JX8Q==
X-Forwarded-Encrypted: i=1; AFNElJ8D9ZR/ZXJsquLoM4JnZR0DGmtI6ZcJ6Y30Z34FvgQ6Tz6nK8lwuz9I9EvyrIxRAj9wKZPDUmw1zg==@kvack.org
X-Gm-Message-State: AOJu0YyWi+8Z0kthla5RmRKrRWc3yrjcN0Wzuo1/PF/CCJlZ0r8W6bBh
	1semvWldnMzvUgZ0SxXHH/p31GzZ2s2CJjKBuNn1BP3ygwOIr8tJGktV
X-Gm-Gg: AeBDiesw3dMCnmy17SPgtDTXXmbn1YIsa4qTFYqxT3Iqf0gMBJQwNFUXD7PTdtQhy8o
	SoY9P/escxHZug65R/JRBMUb7YVXcg2hEtbtoyNp7JEB9PZIoiMvi4Ik6TW+lfWKZTuxd970Isw
	xMDFkU0meScF10axpW8woYGqMTQOde3bLEKHxo26roAxz6LqdL++10Diy7miqKlveiFV1hyhGJe
	qMb6BeVytemxRj24n65GhizQXd5u3Qnc8MB/NZFDKZ2IPLJ18nrlGrFb1Q3XfQYkCSj6X9gZkzB
	6/iHfwGcHgSE4v9iMqtg1pveWPY1yGnK8lqIS2OIS76DWhcmYoShB/S5RFNhslOHyfd7dB+/d35
	S2PEPL2oYijNymlSQg0Q6FNG1Sygj9SC4ospAUM02zou7/bYEGGhosjjYZPH6ipgdabiG8MAK61
	G9PisLmR/htDxzyLqMbpxmZ8dXetMeLBCDtZTvJdJ3Yot5Hvbt
X-Received: by 2002:a17:902:868d:b0:2b0:6068:4c5f with SMTP id d9443c01a7336-2b9a42fd480mr45822995ad.8.1777656703888;
        Fri, 01 May 2026 10:31:43 -0700 (PDT)
Received: from laptop ([2001:4455:8025:be00:15cc:43cd:8af9:5a8e])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2b9caad2459sm27094895ad.33.2026.05.01.10.31.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 01 May 2026 10:31:42 -0700 (PDT)
From: Cris Jacob Maamor <crisjacobmaamor@gmail.com>
To: Mike Rapoport <rppt@kernel.org>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Pratyush Yadav <pratyush@kernel.org>
Cc: Alexander Graf <graf@amazon.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	kexec@lists.infradead.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2 5/5] liveupdate: validate restored LUO FLB metadata
Date: Sat,  2 May 2026 01:30:53 +0800
Message-ID: <20260501173053.73116-6-crisjacobmaamor@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260501173053.73116-1-crisjacobmaamor@gmail.com>
References: <20260501094637.38650-1-crisjacobmaamor@gmail.com>
 <20260501173053.73116-1-crisjacobmaamor@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 2B02140013
X-Stat-Signature: 8735cse4595esdhu75yqzbkiz3ockb7g
X-HE-Tag: 1777656704-264929
X-HE-Meta: U2FsdGVkX1+s6N1kCB65ENKaTqXhjqa8oJYnnPSuFnRdo8c7IrR6uGk47bWKHYnVHti0qtRtIhvYmPJE4m+fCOAtaSQTHqUgp9+DGDGlq/4px304FVrLUd6TM99ETlwtGJvYnrwBXfIJmF9Iqvm657jGViWbIBvIZ0PlwqXjZv9j4AJOsmrvP9F/NSc4wHlm4qMsvBptb0XY+PVoR/p0eaFlpsFlOudXpVn8ZraglMoNu6QhHXjaaNzB0ffmY2BS8HsmbYyibfbUBrt2Wd951VRc0IrUNuQJuM5W2JYuWbi8c7xvfZoynkEL2rJ53Gz82Vv7GQ3lg/wV/9v/6WIzGo2rO1i3dJMDDBGPgrdi5KvAD3G6IJ2Ns9trf71dX5XOItly9JJelOFxCq2hLyp5R7LnMBAJgb0vxGwMaLdXnYG95YaDMQqjfy4VM0KtYam/G0vmXzdI1c/bkTRXZaPREzqVkBw99q9xPRPp91WRQeQ0cOQpArtGpkpOWFXCOErD6Es5nt+l/ZvaZkRwvGNwjijDnLlCiC506LKasgKdjNHHABk+bXEyBydyfKlP04yXidbWcbMHbrrKRnOxaOtrKXo8hBM6ma2PqP9RQyHaFPdic8yB5a9svWcGnoaoyPiHg6vJ+dCqgXEWF59wripsadnri1Eo3ZKTFGol3I49LJTrU2ljkHCCrf3+nnO9icGNeNijNHaesU+UHOgsknp4gwU3IDEnjkMheURIJXQKoXp94Y/4FTirr+9yYKG9Wh/6Q+JN91APISPgAAPCCM8iQ9xFQG01Kw9kBGkSpLLASUyCXPFmDGoWDZfI2mXRAHmpH4PE4saJZj30pv8l7ZXT4vHO0RU8ocmI4hXRxdGUdyrtkcpV2rqZf8Us2KOaX5RjgCDRROmJ+b8BThBuTwQbNycuxVwuyg+hV89M0J7Ok7UMKMhIJNY00p4WPW38gwlWDEk7oXkM0cG2GCU6uk6
 lpC26wl9
 pRJRpQZGDVi8lurLV8biKFo107Q+iyHdxeTp1Pg2JL030U5J9//npAXyKtsJIu3+rSr4BnSYsVzVJz+AcURr1lDP1V8gd58dVXiytNAMx3KHyfdBkRcLZnrIn4wCsovfhGCumD2ClYmCHqbW61fFO/Lng4PoXxIaU/2mc51zS43S6/2QiP4I+p8gYHaPTcWRQRiEz1IFeY8bPRIYlXhmA+ubbZIn/a3MhOrdiDfS3vweibFiLlvua+ptpyC1WHX908V4qYOJsUIZVdnALHUa4q9PM5Jx8qxYwmIfAPLWxecVCxMkAoKPYyLdkVgfcYWF7CZgzMAHEEaEDFZop/vfdc0YAfzPls3fn4k2OnObHiS69Eu4D03qaxQuYbKsGNH0T6NoLzCirva4N0Qh/NfosvfNj4ExPhRr5Nrj5
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The restored FDT contains the physical address of the LUO FLB header, which
LUO maps before using the restored FLB metadata.

Check that the FLB header range is KHO-preserved before calling
phys_to_virt(). Reject invalid page counts and counts above LUO_FLB_MAX
before walking the restored FLB array.

Signed-off-by: Cris Jacob Maamor <crisjacobmaamor@gmail.com>
---
 kernel/liveupdate/luo_flb.c | 23 ++++++++++++++++++++++-
 1 file changed, 22 insertions(+), 1 deletion(-)

diff --git a/kernel/liveupdate/luo_flb.c b/kernel/liveupdate/luo_flb.c
index 00f5494812c4..e80032669cea 100644
--- a/kernel/liveupdate/luo_flb.c
+++ b/kernel/liveupdate/luo_flb.c
@@ -162,6 +162,7 @@ static int luo_flb_retrieve_one(struct liveupdate_flb *flb)
 	struct luo_flb_header *fh = &luo_flb_global.incoming;
 	struct liveupdate_flb_op_args args = {0};
 	bool found = false;
+	u64 count;
 	int err;
 
 	guard(mutex)(&private->incoming.lock);
@@ -175,7 +176,14 @@ static int luo_flb_retrieve_one(struct liveupdate_flb *flb)
 	if (!fh->active)
 		return -ENODATA;
 
-	for (int i = 0; i < fh->header_ser->count; i++) {
+	count = fh->header_ser->count;
+	if (count > LUO_FLB_MAX) {
+		pr_err("Invalid FLB count: %llu\n",
+		       (unsigned long long)count);
+		return -EINVAL;
+	}
+
+	for (u64 i = 0; i < count; i++) {
 		if (!strcmp(fh->ser[i].name, flb->compatible)) {
 			private->incoming.data = fh->ser[i].data;
 			private->incoming.count = fh->ser[i].count;
@@ -620,7 +628,20 @@ int __init luo_flb_setup_incoming(void *fdt_in)
 	}
 
 	header_ser_pa = get_unaligned((u64 *)ptr);
+	if (!kho_is_preserved(header_ser_pa, LUO_FLB_PGCNT)) {
+		pr_err("FLB header is not KHO preserved: %#llx\n",
+		       (unsigned long long)header_ser_pa);
+		return -EINVAL;
+	}
+
 	header_ser = phys_to_virt(header_ser_pa);
+	if (header_ser->pgcnt != LUO_FLB_PGCNT ||
+	    header_ser->count > LUO_FLB_MAX) {
+		pr_err("Invalid FLB header: pgcnt %llu count %llu\n",
+		       (unsigned long long)header_ser->pgcnt,
+		       (unsigned long long)header_ser->count);
+		return -EINVAL;
+	}
 
 	luo_flb_global.incoming.header_ser = header_ser;
 	luo_flb_global.incoming.ser = (void *)(header_ser + 1);
-- 
2.53.0



Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1B015606A32A
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 08:52:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=q02sPx7B
Received: by kanga.kvack.org (Postfix)
	id 17E3E6B05B2; Tue, 10 Nov 2026 03:52:32 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 108266B05B3; Tue, 10 Nov 2026 03:52:32 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F11A06B05B4; Tue, 10 Nov 2026 03:52:31 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id CB5C66B05B2
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 03:52:31 -0500 (EST)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 5C6DF1608AE
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 08:52:31 +0000 (UTC)
X-FDA: 85418593302.14.D1ACE12
Received: from mail-dy1-f170.google.com (mail-dy1-f170.google.com [74.125.82.170])
	by imf19.hostedemail.com (Postfix) with ESMTP id AD2581A0005
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 08:52:29 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=q02sPx7B;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf19.hostedemail.com: domain of adrianhuang0701@gmail.com designates 74.125.82.170 as permitted sender) smtp.mailfrom=adrianhuang0701@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794300749;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=xfIJPZ8iDuwMd4fEVUhcFpuLjx5VOiQMHuJ+5IFm8uE=;
	b=vE+wB9V7jznYViH8lVsueN1jvUTDsF9qz9JFNvYjKiGhjktSCb21U/cS3I1WMomQEDTLhM
	BM7puwLPgzYuYPlQcNJlzuFfNyP2ohIhYMfbmgh1vPLDI6TE0RaVQ/8P3DGRt2WAEKW+vs
	hoxkyWYpJZQeKsuFmrQ/ueocTDKcGdY=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=q02sPx7B;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf19.hostedemail.com: domain of adrianhuang0701@gmail.com designates 74.125.82.170 as permitted sender) smtp.mailfrom=adrianhuang0701@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794300749;
	b=1vM3ZPFcPPnod5o0zVq5AxGP3iCeGHLCKb11lXo/jtJEY5pqfcq3LIalX7kn5ujAZAgwmo
	olPq/3OsoQktqz8NYLBu8oY354mSjVDGiOJE0WAd+/3ml2AQb1mgMdLuPaRLjjSdRo27E0
	sQcz7hRImb/SrQQXKLb4Vg6s3p78uK8=
Received: by mail-dy1-f170.google.com with SMTP id 5a478bee46e88-3700ed8dbe3so2577789eec.0
        for <linux-mm@kvack.org>; Tue, 10 Nov 2026 00:52:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794300748; x=1794905548; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=xfIJPZ8iDuwMd4fEVUhcFpuLjx5VOiQMHuJ+5IFm8uE=;
        b=q02sPx7BtyWatpW/96aHwhzhcjh6ZGl91x1zQOOz0AoSerVCKhj6otE7h0iZyZw1c7
         nVesdynOMhZDOujQVH3F/IaKwT7IpVpcbXW6AkPkK9AARF+nb+vs4WMPGWMmO8uTHF04
         TJS6Ny/vcMdZ+k6quE/+YfBZy9GJPbEqFsMokTmgCsc3N087BFpycVxOh1DAwg3F3InD
         eWYk2j1MnTBQBWHhQvM2edhUd4Q+d4dHkuEZs/idCfwM1+fQWHY1nMeDGwyKEVXLGBd1
         Shfo8d3C90FO7iKKFhgu1ge735uBQr6RFDDPOyOWaZKqfXan5qdY+OY8r+caUaVQy0lv
         lYig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794300748; x=1794905548;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=xfIJPZ8iDuwMd4fEVUhcFpuLjx5VOiQMHuJ+5IFm8uE=;
        b=y6A7liRsN54uoQKbnTPlQ2iZQvZITvJi1GAJ9Fq/i1QsXEL6ny1puIim1nrD/5IuZh
         49vQrOtT0sB5PoG+B6vMaAmNWDnWon4ZWuirde8WviEIZCG3UA277vUfQOhwXrKMuif2
         i7uBv3qq0kfS2GE5QfrhP5ZlaiQxyg36YUnrnmjpriJKqImyCBZhHz9PQFMkWXRoufop
         yzKsw4B+WmstL8UsxkhDwGyTwsN+HWZGHtk8MPWmSQL//3crRXK26eXOiNE8vp2CIssI
         K8i5FewJYxFoe3rMVXc2SQ2k2aGnKI19mef70v+wtkpL+jxGDnDhZLbupK76zijdIZY+
         3Skw==
X-Forwarded-Encrypted: i=1; AL+hErFic4VPb8EXbgHIkZyyK1/ndWSTsT4Bz58QC5qMPeGgaYbyHcaDnpGj5CvSzFI6/IeHnQ/uUZddYw==@kvack.org
X-Gm-Message-State: APuU4Z/ow7jxTt650XITvWD4ILLzKG/dC5sFAKBKbZEdw/Mz/WBRjR02
	EB08yIScBNyexwmmNmp+myI8P5YMBLEz0BvMZq/41ogBnTnyOgdxCq+M
X-Gm-Gg: AYBFou3gNNkKv+gDea4wWjMZDvZqXwcdxQ5McKmuJtEMSjLAW94hpH06rI+qVBI2k+v
	Myq9W3JzLBNZfsiqY7neMwmzNQOnsrFSSeH/MvzTrelpui3jck8mEWgBoLrJ3IicKtXHkNdQWBT
	Zv/u4MI1JJaVMfWOSO6b6koLPVV9XG/McFm78ZubDfRk/wbfENNwzn2OaK4S/nT4P8WKm2MGp9g
	Q3qaqJkrdXig3uyrUew6fRYyYSG7X5iymczYpqgwfPhaxV2YhKH0lKgLMxb92rONdya25eF2BRg
	/cy/X1hwB40MHr2cv2rpeZ+4IzGOodGywSnzGLKK/geSudGDB6fAR+Ah3v5L5vz6N41iDS6FA+e
	87cuL2z5LDMAmdny4DRQw+omuBEzCk38dmjRw6VShcpWEiUsHQWfuov/x2TqDBeh5FwENpevRo1
	/vdZXIIWAEgJKT9t7Gcd/YMP+reRVTA0FO7zsck+nO5YLXHcc21RuVP+NEcVAO/M/He1/UEtbgS
	rnbauH4SMzeauJnsqZ70YBUxs7svAicIviF112bokrR40Bf4P6INSxk+Qejwy0HaJ2UWbirl5fr
	9+NlqYzIdfCuz4QJ8SQ/BtU3kqrkwwcWKrHRJahXp2bGaG7SKNPIkWfOhuuItUviPf8d4nCyWQf
	w1CDw/LiZ47AtMmzsECbgBbeRHjpkjOgSc0Ems5G6Ksu1Iag=
X-Received: by 2002:a05:7300:f48f:b0:351:2958:1740 with SMTP id 5a478bee46e88-3751fc35f80mr2396611eec.37.1794300747995;
        Tue, 10 Nov 2026 00:52:27 -0800 (PST)
Received: from AHUANG12-3ZHH9X.lenovo.com (static-ip-10-78-56-61.rev.dyxnet.com. [61.56.78.10])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-375215d8889sm5590830eec.27.2026.11.10.00.52.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Nov 2026 00:52:27 -0800 (PST)
From: "Adrian Huang (Lenovo)" <adrianhuang0701@gmail.com>
To: SJ Park <sj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	ahuang12@lenovo.com,
	"Adrian Huang (Lenovo)" <adrianhuang0701@gmail.com>
Subject: [PATCH 1/1] mm/damon/core: simplify minimum watermark wait time calculation
Date: Tue, 10 Nov 2026 16:51:32 +0800
Message-Id: <20261110085132.1023-1-adrianhuang0701@gmail.com>
X-Mailer: git-send-email 2.25.1
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: AD2581A0005
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Stat-Signature: ktnm8uwt4uadf53aew7ptx4xodxjdyc1
X-HE-Tag: 1794300749-733294
X-HE-Meta: U2FsdGVkX184f5h37p61tuG/8KM9SgggP+u7CS8NNoaCApqVfsWoZNKHAfyoAPI7KBgs17fIDyO6SBIvl+jS8/H0lSdl9nbtNcA7r1ykrCca4OZ5KHy2zF/l5xoaBBSibmJSyC9RZGufEdG5hE5CQRhVBosIhhebx6q+DDbPy8kSCDbEU/GYKotF/gCr6f8+u2xrCBO+RR3Yew8ERNv+u7RrSf0Xl3PfvpUd3XhlgflbHQ5XBkX/KhY0iIdxollJiidQAlHd0YK46IXv0Bb+fAgjwiQRow/3bAdQyXfKwyRljNWuA0yNY3Vckqv/XPVatvZM7ruyWZ2X1TWeVZtpgFmfs9ZjjMzgfRZ+P9lJjyzMvbsoJFit2XTYrk8FqE2XmaVRkWJQyDr+QW6LBpgrZ6EcwlW6xMKdgkx4tT8hmIVAZA+gTuMBU+X3feCBY0AcgH5Wx+8/c9nt0InlO7q/j7eDRqmyis1sIasQ7KyfCAgsj/Dvsf356FOFmE8tAO5VsRqVjxMPnNjFkxGIVzKt4wV84UKo3IB06PdItME1UITeHqzzzRGoqodaFXe4vMHNFN9vlRzxQUpZNJSxooETzhSjtDrZy5EyUc4lL6zXfouGxMdjs6skYlM4uglda4qIx3C9Nh5XWR5VVWby9AFTs0z8zkDGGsT5Z/nV5bW6UPaSc5yDWF0Jrp9uqy4WT2pjIGVSz9mTuLTWpib3uSvXJp94foF5GK8wkVvu/f5VFfx7oHB4vtLeQeDtI5p00EGgO6NTdyrmYbNEWtN2kl9VV41RwsLEaS55RjVImUbF0jO73gvyK5qWZlbDbRoroU3j9jD7nzBENg5mxHTrT/81rPcgUBmv0Hfol8OLTCyqlBBjE69qB4CfXVWWH6DQ2MtiGjgGlhR52onTaTpWvHPZ3QqL+RjJg4tEg1ZKHosdyPwfGNCSJpNrNBU5SseCPP3jOY6YDtRo76W/HOa2u/f
 0nxB41e9
 4IdB2HjyAUk0Ouj8Do5SxKBGvHX9AM8Prt0vtEmrIXa2i+T/SzzEffYJXWfF5rYroUMPh5liJMqj+oqif9epZZiUp/5RciRoilSybb1NUk0eDBDsH8k60njwg10HXbXLfdI+rDCLRTFBVMmke4lCzHK7pHGXR0f9ZKkt8qkZxGKhhW6H9CLlqSILutVrlluwdJ1O6ecgALYiTqw8GUQ26Tr2ez8mz/DEHS/sMS8rFJdHoY6hjRtEr++cVpeyWgjmmd2yxiuilOFndlo8ZOt3BgTSHaIdS2XFYOJ5huREacIphBKIWk/9bfsltWaSYonDGX/lIPvElycPHR6+I8yWNFvaX9WLcIMTs5yK6CgxxNC2BMfH+21LENfetJOBXadfWzCK1VdBv9A/IzYq8Q5vbcF/UXQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

The minimum watermark wait time calculation uses an additional boolean
variable, init_wait_time, to determine whether min_wait_time has been
initialized.

Simplify the logic by using list_is_first() to identify the first
scheme and initialize min_wait_time accordingly. Subsequent schemes
update min_wait_time only when their waiting intervals are shorter.

This removes the unnecessary boolean variable while preserving the
existing behavior, including the case where no schemes are configured.

Signed-off-by: Adrian Huang (Lenovo) <adrianhuang0701@gmail.com>
---
 mm/damon/core.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/mm/damon/core.c b/mm/damon/core.c
index d36823f4d092..93ec684a113c 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -3985,14 +3985,12 @@ static int kdamond_wait_activation(struct damon_ctx *ctx)
 
 	while (!kdamond_need_stop(ctx)) {
 		unsigned long min_wait_time = 0;
-		bool init_wait_time = false;
 
 		damon_for_each_scheme(s, ctx) {
 			wait_time = damos_wmark_wait_us(s);
-			if (!init_wait_time || wait_time < min_wait_time) {
-				init_wait_time = true;
+			if (list_is_first(&s->list, &ctx->schemes) ||
+			    wait_time < min_wait_time)
 				min_wait_time = wait_time;
-			}
 		}
 		if (!min_wait_time)
 			return 0;
-- 
2.43.0



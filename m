Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2D6B8ED7B96
	for <linux-mm@archiver.kernel.org>; Tue, 14 Apr 2026 09:44:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7962C6B0092; Tue, 14 Apr 2026 05:44:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 76C9A6B0093; Tue, 14 Apr 2026 05:44:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6A9BD6B0095; Tue, 14 Apr 2026 05:44:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 5B1E76B0092
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 05:44:48 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 2B270C1D55
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 09:44:48 +0000 (UTC)
X-FDA: 84656677056.06.D96C4F8
Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	by imf12.hostedemail.com (Postfix) with ESMTP id 5F6B94000B
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 09:44:46 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=himwPyTw;
	spf=pass (imf12.hostedemail.com: domain of charsyam@gmail.com designates 209.85.214.182 as permitted sender) smtp.mailfrom=charsyam@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776159886;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=T7NVfQUbfE67jeOzUT2RzULiiF7E2EzeQAkQdo+bKL4=;
	b=3rDgbxT/9Jk6aSKACjNdAilvEHCTaUsDPK0KLcLRDqoE+Dbhn29u2uCuANFGCD583AyMmx
	G33sw2LS1EeehpL1kZi5eHLWexlN/nRD2sIBZQlhbLpHlam4oA7N4YhG2UK5WqSt1U3sOU
	FsGrXMHn616tGBbDhSb4G1wj5Aql29s=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=himwPyTw;
	spf=pass (imf12.hostedemail.com: domain of charsyam@gmail.com designates 209.85.214.182 as permitted sender) smtp.mailfrom=charsyam@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776159886; a=rsa-sha256;
	cv=none;
	b=xF4X7jf8oUaD72eTG0ncbB5apHLW9oDoLjrjHfFin9UEQvb73G2zuKjr6r+ri9UAqtq1t6
	zIkNXj9nMc04Lmfz0JhFYFzCsGYLps47Oonb7rpzAUCz9vNvZTzN/xsbnPje+i20wk+Xyr
	6zUaq/Yc/ucGKzTSMfQhse+KhK4+ILA=
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-2b249d6ba0bso3475245ad.2
        for <linux-mm@kvack.org>; Tue, 14 Apr 2026 02:44:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776159885; x=1776764685; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=T7NVfQUbfE67jeOzUT2RzULiiF7E2EzeQAkQdo+bKL4=;
        b=himwPyTweWXjvSPEw4i6KbGOPwUcvdeltiNhF/gS3cmMZY4D1uo9Ci3omxHVKesKuA
         pq7g8417ZF8EqinrKvA8Nl+d6/qcdjGSFFu8TwAFhUq3zdE3FrSM8KEHLp33vJXHzyOi
         t1HGGopL1E7tESRw4t3NbDVC+rIWqo1b6VA2ZS5su7L4awstszgaSTk7d8mukMfarEss
         fBS3d33tFkLJOq8HRBDNIl3/eEg9SuP0EKIKQQnK8gwH/OwdAvY08UqRPkjDAeKXGfuR
         eYysZhaS/s+qC8AJjKYu3PA4eyY8FnwZWrd2bgxySmREN26JS3F+H4UaY9YywnyMaJQc
         BowA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776159885; x=1776764685;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=T7NVfQUbfE67jeOzUT2RzULiiF7E2EzeQAkQdo+bKL4=;
        b=JAtBmsFgyGRcY8aM1qQOZOQLcNGuFme1Tktm488sHJsXL4dMYVvYtzwbHQpCmonPFv
         CZeXvq82UgxTySrM6vdbMuUA2ELjrM9x3dm9zrAX/w9YT92U1snNRZTEBiA8na1WLo9B
         S8Exii8qQ6Y6YelvzbLDH17SrZIePn7oPHBM2G6wa8T+Irq6effGDQPCSuiudIl091gM
         bDgNRcLzzkZ3nNF2sbu2I9mxr6BqE1oK9ZnDwEYcnV6qZlTVsejZOlu+ha2SgZ1LnT+K
         RvZlH7UXXpNRODi3lgsUsoS+CCfOZNjPMKR+5ibb/Ax/uj5Phxo8ui/6qW6/xuRFUhel
         qsBQ==
X-Forwarded-Encrypted: i=1; AFNElJ9hLxDNX+vGY/cXY9AvwWOxe3cIx+4o/q7X35q2SxsRFstvZ37hvxBqFbZqoUoU0BjK2xjM2sJZ2Q==@kvack.org
X-Gm-Message-State: AOJu0Ywh4UDzrFEBTJ3dMYMcMkVrIwjfuuN0lk6AEkOjQz7i+zQpwlne
	Zes+xRYBrWAD+FNutyLA3ZHKskvf8A4IJn6vReoszttSZqRsVJKs4tgG
X-Gm-Gg: AeBDievtwrmhROPGQWggTk2GU3EqXxTHZn43ptjS2n8wnCe/narzuaNonHuL3qAUVYW
	rRzgpOOaOpAzEvHO7nlVquR0t/T3jUJyzcE0x41wj+REKL85+vZs1Hzlur/pAVDpRFFU/t7zfL+
	OVOYkr56k1Bc+/0Jh/HEfhkDWQxO+3MRCmHBJhLTXVfW17BIUSfS4mSriihMJDTvKt5TYfouVLF
	LGzQgnhbOBu9B3q84/DuaGHsYFUOjCprsv3rsCz7gEDEC7Auzd8vcoMVhN0MlFgW4ZS4p+/LUAa
	mteQbe3qGPHnh4NJVprYAs6JjodzPqY9sMNJs5VPvV5uyO0Y+A3MWlongZMbvreiN6A6fGbaFsA
	AOuxxuzVqtOR2TCkPxj+qwfvxYnLipw2xmGF6C/b7Gujnms1F4enEFwFP59Sbz/RuwpH0tUkYdu
	vyB26rExZiWt1bt3iH
X-Received: by 2002:a05:6a21:9204:b0:39f:2a10:e4ff with SMTP id adf61e73a8af0-39fe400f906mr9985807637.6.1776159885070;
        Tue, 14 Apr 2026 02:44:45 -0700 (PDT)
Received: from ser8.. ([221.156.231.192])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-82f0c50cd34sm14456375b3a.54.2026.04.14.02.44.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Apr 2026 02:44:44 -0700 (PDT)
From: DaeMyung Kang <charsyam@gmail.com>
To: Mike Rapoport <rppt@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: Steven Rostedt <rostedt@goodmis.org>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	DaeMyung Kang <charsyam@gmail.com>
Subject: [PATCH] mm/memblock: fix off-by-one page leak in reserve_mem_release_by_name()
Date: Tue, 14 Apr 2026 18:44:39 +0900
Message-ID: <20260414094439.982853-1-charsyam@gmail.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 5F6B94000B
X-Stat-Signature: e65jhrmfiuruyy55a3bm5r48wdeusgfx
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1776159886-924251
X-HE-Meta: U2FsdGVkX18BQQ8eGni50l2xUhBLQHeWZ2PrS+2VFQSlTqP2xGGraIXwBbZSQujraUvNSHbOlncjcNkk14gI9Y1l9ewrx8CA/+mlapRpmif6f5Gx2eblXEGi+k8l3lBiKZQ1ZWS2nliNVAYo2LDpb/NwOllQwtzdQ+F+ELWk2XIIdq1XpqBArmcTcRNVcaa2pv1xn+4DBt7foSjg6+Hz2jp4VJqXfAZ1+kYev9LB/dZ8yL/PQ4I0qimbVq4dn+k9rivjhERkWPQUOzJRTStiDGwNZ9g1FIgxYhQ/cI+uqBITC6kQh/lr9EC/Xeui9ihF8sulk3JBmFA4yYeFjFOT1cKDOCLqGdWKT8EXthIhl7H2ZuElTevbKecdq7G5ATTGilTZR5m+k90Po7uoPivfHMWEg38jlEGEuc92X/VLgzaWSPje1oCSsDRrB5uUAK6F8CYV5YpFLz/Dl7YnXjeGxVwbj7/306j1vtdc3rRdVrBcgfpYv2Mk2ZRCYHSMWFXEoofBjtAooIJ7noQwxjE3eucHyGQI52alVM8uHDXb7HlPTlrCTIJ4uWrEzAsxjrlKHBQ+LmvvgWD/TfARnAT00Neg+vVaYsQ33xiZfQ29ohvEYIV2RpxFDpy7oJNK037cMZb+FfOEcO+kTcoFzmquZ5c+SY8SgKbMYXds7X/uwGy60rx02Mvz7RkfxINmuoEWgyhnk/caiZc60pezs9YX2GWkBhZJlF7w3yPH+8QarmVhFXEH7ZlXgPWjbgP8nX8UhQ/JWnhQtwwUvgCjsLiuadGBI1FRqFYeU3ioQRPZE7ytq3diqGjha//ag0kp7SidUwgUAC8Ezr7QblVH7wSYcqVfoDtECreI6deRpyelr2hONs4tJaZ3A8qYTxk4tIOtFoo+HS19GHZzXEIOas1GkEtHaOtuOZerB5Gbi2B6ADOUmOJJAGcdLeniaiJUHR1jTdx59ND5HHf+NpTnyyr
 bxdt/vMF
 D33j8KTlRZ+9Yjo2PIox+tDnhmmcvZRRMawNCcNNk3R/HHtQwVGeWzyBcIlTO519FLSSUfuoRIA95tTL9zzH/le7/3CGmUbVyY8WLq4qFFk5P5+LwNOcH/rNEMHihw2Nmp3GBXM5DjCobuoU/nL/5FKr1E78xAnf4hU9ansj4jKSOJEue9FfYY/iWsBfBBOQoZqZriQCrOlFxfb7/Cs1a7auvQi4Ko0NKpee4UzcDzFDx28ufpWattC3JgBt/tvhqSwkE9Dk64rmmTiyMuHd0DC0d/zKqzL7pyJJe+dCtuVYiG6LmVyBsTVK6UeCuWPnou2nDhMVBnBBW9dSherxxUFbH7xI21PaAoSZpW5802c0KLiNj1DHi+ecxPkn5LSdcKD9I7LU04tjEgCkuQtx3DjTVJcEA7afPWIKCbrkmUPun97D2njmHouvkRKtHaxoP69ZsjEvm84XCvZci3JhZP1tF9XFbLh+lIhuugjMqjULHK3ZWTqMqStj80w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

free_reserved_area() treats its 'end' argument as exclusive: it aligns
end down via 'end & PAGE_MASK' and iterates with 'pos < end'.

reserve_mem_release_by_name() instead passes 'start + map->size - 1',
which causes the last page of a page-aligned reservation to never be
freed. For a reservation spanning N pages, only N - 1 pages are
released back to the allocator.

Fix it by passing the exclusive end address, 'start + map->size'.

Signed-off-by: DaeMyung Kang <charsyam@gmail.com>
---
 mm/memblock.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/memblock.c b/mm/memblock.c
index b3ddfdec7a80..d4a02f1750e9 100644
--- a/mm/memblock.c
+++ b/mm/memblock.c
@@ -2434,7 +2434,7 @@ int reserve_mem_release_by_name(const char *name)
 		return 0;
 
 	start = phys_to_virt(map->start);
-	end = start + map->size - 1;
+	end = start + map->size;
 	snprintf(buf, sizeof(buf), "reserve_mem:%s", name);
 	free_reserved_area(start, end, 0, buf);
 	map->size = 0;
-- 
2.43.0



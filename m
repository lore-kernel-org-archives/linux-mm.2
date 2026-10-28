Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 61DCB60A2606
	for <linux-mm@archiver.kernel.org>; Wed, 28 Oct 2026 21:19:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gourry.net header.i=@gourry.net header.a=rsa-sha256 header.s=google header.b=Sl8pm2YJ
Received: by kanga.kvack.org (Postfix)
	id AD9616B05B8; Wed, 28 Oct 2026 17:19:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A632C6B05B9; Wed, 28 Oct 2026 17:19:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 978C96B05BA; Wed, 28 Oct 2026 17:19:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D769B6B05B8
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 17:19:41 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 5A1FD1401FE
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 21:19:41 +0000 (UTC)
X-FDA: 85373301762.25.7058F5C
Received: from mail-qv1-f41.google.com (mail-qv1-f41.google.com [209.85.219.41])
	by imf29.hostedemail.com (Postfix) with ESMTP id A558012000A
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 21:19:39 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=Sl8pm2YJ;
	spf=pass (imf29.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.41 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793222379;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=woeAztA9ioPxkj5kTODOYAAuCzoQVvGCjxTGUXdVMNE=;
	b=eEfHo719XO36VSHuTEg0LElLsUAhGAl7Y9NAmye11POH1r47aICXwFc0heXgj8IjFKaIHD
	4DucpeBBIa7dmEZJKEaLc6ZpO1XHCasWXc44RubU2s8wne+sMx0czrvYrYLPVuJgkCa+ak
	Mjcwg6cqfUNYyLIAHQWRBOARKTs0Hlc=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793222379;
	b=JNsvvImkxgsNblDYw82aNdNACOnc5lFl1Gh1E+QHLlmD5tNVC8HuOS1Te8FT9QEa/vaOY0
	WwB42c44M7Gtgk5xmaaAQgRmGRcuWGpuoW8xFf49jkFzK4qPOs3ypw/AbJ73T5ahsCZYvg
	W02eqCAfxG/o6Ok8J+WesZQT9IuO2xg=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=Sl8pm2YJ;
	spf=pass (imf29.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.41 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
Received: by mail-qv1-f41.google.com with SMTP id 6a1803df08f44-917a707f37eso14931446d6.0
        for <linux-mm@kvack.org>; Wed, 28 Oct 2026 14:19:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1793222379; x=1793827179; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=woeAztA9ioPxkj5kTODOYAAuCzoQVvGCjxTGUXdVMNE=;
        b=Sl8pm2YJVHP/M67Hk7hNSHMZqeRIpdoOJySkvVbn3x5IA3yBNsUziMGn8jH3l7zS6k
         bxgC5rbnnkViIrocVKx1GyU+dIFzRsnO6s8FGSreN2FPVcwQxfuragpF61zgukwbfimv
         FIo8amGIoTojngfgfP0vTZ9yClQ1JdW5Wg6zUq3cxPKkCcO9oiPGLTezkGf1lv1VxZM5
         f8kBpLr2XTjlqt/BDa0vHOGhpP9L40KvUDMsMyK32Nc33A+SLE2MBlT/DWhuAo84KyUc
         FkX5zle9LcjkBchCyyZC+7p7QcrzRmJX8OeOWVZ/P4a7hFQf+zlqvAkc81o8BgEwg06T
         BLdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793222379; x=1793827179;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=woeAztA9ioPxkj5kTODOYAAuCzoQVvGCjxTGUXdVMNE=;
        b=rB3k7f1u4HwMlhmG8PAaPHCvKoNfnQaDWfyPt2nz8AEJQ4degoJtxnkx8ixBTtevUc
         3+0JyNvRNw6EqFMzveeBUD+ra/EkMWfwurUUU8uhbFu95J4MqB3cW4hfF6nBu1wO8oeN
         vXlHkyXUNVqXpJTN03yaDx6/qUECRetBQ5/GqPF0T9rpyneSA/XGUQe4DG9ZU82RZm7A
         ipaZjzgE93ioYkwBTNSHiEgZg4Yd4zgBQBhbokEtotfxjAs9oP9boE86viTe1hdmwqyy
         CEWuhAMd79vwRRLAYJl937MI0RZv4SKEqIj6UHGoWoeXKUl+VrFedPsGOSM3+NfyuDxa
         V+EQ==
X-Gm-Message-State: AFq9FYLuqKrxIgINNip26XGN9D1Uv8qx31ohphxKfY5vuqQnctYI125E
	AJWcQkg+FVPgdttkVsMpKJxvBIzI+5hdCz1GPo5KZRpkzXRD+o+XuIFNZ197wzVIjP4m3GmVHdY
	BS30mUxk=
X-Gm-Gg: AYBFou16pYTbFMRGqPG4AWLX2mKvl1fMvsW0lQ35BiT64z9O4hoDDeN2Ozc0ZZ2tDE2
	sT3CHJfqlWHpNNmzYOPmc1mckf4axFaeE7EQ4n8BbfMjzJunr0boTd8DEUcYEVbf40ohie3H/Mh
	/uhyyZvU1yg7GosXmKaSmtGBZIhqv8hTM8YUSv8nW5/IeuDuQ/LAGRgQys/mDWhq0QPJC4n5Kwt
	UyYOXwWClWPGFOzUmeDJjQkGuYhDgNgG/F+LW4Hc5daPdS/TgNhjOVAjko1oORLUSr6uMi7Jub1
	/tn7oHeli0SCXeAQlleQ5Vql3/+x+Vz5QlONJPNhpa+fqP3RNUw2IklLqYsyz/ycVZu0igawuTJ
	4oMDkzj7Iki+lWqtFLeGia5TiXzurCgVyhXeCxINGlVTScfdTkQC1GSwwmz3IenneSj3v6yo8po
	+sMxH8eDGrd0Ixszzh+6yEubO2wmqtYbOCh4T+5YeJUb1PDRK/sTZ20wGu+r35b1f7t0ZqXnqqB
	8+sPz7xzz6PrV2qJtJRVbR6/PSqhAu+CWpV11iBzG6KS/rGgwwDzluD6QYs1SoobhrsKjtbwvsZ
	lM+ZRWVPiLZBbtKt99iMokFqB8M/am5QoJTbXtJM34ePWkOWA7jKiPYxver7/adSLRet25cohq1
	IEK9FMOPRvBkIOxs=
X-Received: by 2002:a05:6214:501e:b0:919:5a24:d77c with SMTP id 6a1803df08f44-91c7cf99ea6mr58383016d6.31.1793222378818;
        Wed, 28 Oct 2026 14:19:38 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F.lan (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-91c47a6d598sm139778966d6.3.2026.10.28.14.19.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Oct 2026 14:19:38 -0700 (PDT)
From: "Gregory Price (Meta)" <gourry@gourry.net>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org,
	kernel-team@meta.com,
	muchun.song@linux.dev,
	osalvador@suse.de,
	david@kernel.org,
	akpm@linux-foundation.org,
	gourry@gourry.net,
	ziy@nvidia.com,
	joshua.hahnjy@gmail.com,
	rakie.kim@sk.com,
	ying.huang@linux.alibaba.com,
	ljs@kernel.org,
	liam@infradead.org,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	brendan.jackman@linux.dev,
	hannes@cmpxchg.org,
	mgorman@techsingularity.net,
	anshuman.khandual@arm.com,
	stable@vger.kernel.org
Subject: [PATCH v4 4/8] mm/mmzone: read each zoneref slot once when filtering by nodemask
Date: Wed, 28 Oct 2026 17:19:26 -0400
Message-ID: <20261028211930.3504634-5-gourry@gourry.net>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028211930.3504634-1-gourry@gourry.net>
References: <20261028211930.3504634-1-gourry@gourry.net>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: A558012000A
X-Stat-Signature: pr7e8rppd1wcj9p9aji31hbix41r7a8w
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793222379-789946
X-HE-Meta: U2FsdGVkX1+rDCuuZ64K5NF3cTjUllujl7Anb4PI6P0IvYIDkYWrOkNxaUWCqye/azOooEVYelRZuipCM1Sc4siQ+zOF7I1vJdhVf75AcInpQW3iDGDDf4N5zesSsEKp1Xox1mwZhaXzlRR1rhD1HMVy0CEOlfjuzf2ww+ceGs13/1chhj8VdAjxKzHJ12sJAbVCIAXtwPxJV0bphn3yWkXNeFeCaIofIRKx+qGh6q3hiWG5x3ef6q9xm7OG5eKG4H1XIafT5e4nePOBbWvdKlHj/mTjE5wU9rgYknL3/fCaYLCUn0XpPC1HdQ9mJHVSVMQUk1Qc6eXUynbKK7xipXXO95hLy01TlPQSjHGwSKWN+mTNhHoJdN3+go5XUhOm33eu1PGWpPMU9ywoZC6EeDqBICwLuENeMoIjeKe9p4zY8B2yUMgXowJP04FTICjPOoL7TkPtz2ak41Cnf8a2NfruLT+spMHBUQkygrXi+TQgLu9erXAlOcG5mIEikDzdiKcxa1xT87r0wOlEerCUiDFz6eA2fV8d+IPLpk81RhPBero0xvTgAtyXgIknHzjyP7jI6udPzWszxTJYdXyS4h4TCxgNuS746pHHoXgdC0Ogr+Xbg48fCi0cPHxCmKRSoj1fKbdmuogRXJ0AyWbGUcHQcrDRLOlIDu2zB3+qH9II4t3TxqQTHg6HoukB1ejiDlSGHq5lnPMUysPTX755xFIAuREle+JZmZeOPMz11QGp3McFKmNKCGQz+8ClrMWb+HH5yOMS3h42w/VR3vlESBJOAbylwZpiXHuznldYqGXZwMq8XSNmT3I1hlyuQmklJGOjUjm2itmiW+Mn4E9CrDeJ80SHsZx509GYkxZLY0AWdUR/fLdC/0p0uRijW3ayCo4FDA16m5tE7tLN96QFpaq2cXMvFFEQUjQGzPB6+Y+T9725eSmtN77IbDWNPWpCI5WszuYEYTUgtPaKc0M
 jMsl77hN
 0BUZsKlj0li3qzzH2LIYQvMgneefhi2EANtmsUfugXYAW3JM1fgIDGfTGlTsq/Rz1oSZNjpXMd/sRJ6IBGTTKKw70lYDUib4DNseFveC3o0FY26VbSY137aOM3v1WnQTq1nHnouZ3mnGjtFfZa1DvLOViL/acQCgL1Qnk1ooJOafbdm/XFsQ+v/h8vy2DilGdD9gdZDQky8IFSSnyExkMfqOuDmnf8ldPRZk4/kG2f0G5i/ht2nu+wKl3JX18RGa50I7auiWlS+x5ZgGMep6QiMA/lj155242tj2yWUAm8xOby/fd4UlUn55YvXw+YOAI91De1U09kPphgIymF0LJ3LEc9v5G1/7ZU8roHBVmIWh3JAOe53ejCbxxo2FGfTxYx0SGPeG0rsfXliZnAR7tadf0uQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

__next_zones_zonelist() tests a slot's zone for NULL, then reads the
slot again to look up the zone's node. Offlining a zone's last block
rebuilds the zonelists in place, so the second read can return the
terminator:

  CPU 0                             CPU 1
  __next_zones_zonelist(nodemask)
    zonelist_zone(slot 1) = NORMAL
                                    offline_pages()
                                      build_all_zonelists()
                                        [MOVABLE, NORMAL, NULL]
                                        -> [NORMAL, NULL]
    zref_in_nodemask(slot 1)
      zone_to_nid(NULL)

Current GCC and clang merge the two reads, but nothing requires it.
With mm/mmzone.o built with -fno-inline -fno-ipa-sra, holding a
nodemask allocation between the reads while the node's last movable
block goes offline oopses every time:

  BUG: kernel NULL pointer dereference, address: 0000000000000060
  RIP: 0010:zone_to_nid+0x0/0x10
  Call Trace:
   zref_in_nodemask+0x9/0x20
   __next_zones_zonelist+0x23/0x70
   prepare_alloc_pages.constprop.0+0x16c/0x190
   __alloc_frozen_pages_noprof+0xaf/0x330

Read the slot once and test that zone. A NULL zone still ends the walk.

Fixes: 11cd8638c37f ("mm, page_alloc: remove stop_machine from build_all_zonelists")
Cc: stable@vger.kernel.org
Signed-off-by: Gregory Price (Meta) <gourry@gourry.net>
---
 mm/mmzone.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/mm/mmzone.c b/mm/mmzone.c
index 9cc9ef588580..009f1dd75dde 100644
--- a/mm/mmzone.c
+++ b/mm/mmzone.c
@@ -43,13 +43,14 @@ struct zone *next_zone(struct zone *zone)
 	return zone;
 }
 
-static inline int zref_in_nodemask(struct zoneref *zref,
-				   const nodemask_t *nodes)
+/* A NULL zone terminates the zonelist, so it ends the search. */
+static inline bool zone_in_nodemask(const struct zone *zone,
+				    const nodemask_t *nodes)
 {
 #ifdef CONFIG_NUMA
-	return node_isset(zonelist_node_idx(zref), *nodes);
+	return !zone || node_isset(zone_to_nid(zone), *nodes);
 #else
-	return 1;
+	return true;
 #endif /* CONFIG_NUMA */
 }
 
@@ -67,7 +68,7 @@ struct zoneref *__next_zones_zonelist(struct zoneref *z,
 			z++;
 	else
 		while (zonelist_zone_idx(z) > highest_zoneidx ||
-				(zonelist_zone(z) && !zref_in_nodemask(z, nodes)))
+		       !zone_in_nodemask(READ_ONCE(z->zone), nodes))
 			z++;
 
 	return z;
-- 
2.56.0



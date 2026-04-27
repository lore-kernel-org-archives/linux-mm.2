Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B1C8AFF8868
	for <linux-mm@archiver.kernel.org>; Mon, 27 Apr 2026 14:56:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 210686B008C; Mon, 27 Apr 2026 10:56:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1E7E86B0092; Mon, 27 Apr 2026 10:56:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0FE586B009D; Mon, 27 Apr 2026 10:56:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id F2D7E6B008C
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 10:56:33 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id D28D31C04F3
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 14:52:59 +0000 (UTC)
X-FDA: 84704628078.28.5CDF536
Received: from mail-pf1-f176.google.com (mail-pf1-f176.google.com [209.85.210.176])
	by imf30.hostedemail.com (Postfix) with ESMTP id EB40D80003
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 14:52:57 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=K746OGgP;
	spf=pass (imf30.hostedemail.com: domain of enderaoelyther@gmail.com designates 209.85.210.176 as permitted sender) smtp.mailfrom=enderaoelyther@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777301578;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=jC1NRZz+kwp3j5wZmm2yj+4VVo1PzPLnch+E5Q6Y4MM=;
	b=CgAsPNjURtRcwgNWI5PqHcwZJI5gfJXBV2PTjaadBYJmqFL788o1KVNePMzJkc6joO48nG
	zYOglnPlQjG6Jf9g6W3z2oy1/wM9pLf8DVaaROM2rfSoUeKO9jXa6HHW0bB5N79Ro216oR
	POCa22a4JC3ssYOkB9dIhW77kvmJL/I=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=K746OGgP;
	spf=pass (imf30.hostedemail.com: domain of enderaoelyther@gmail.com designates 209.85.210.176 as permitted sender) smtp.mailfrom=enderaoelyther@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777301578; a=rsa-sha256;
	cv=none;
	b=N7l0ENawrppneNXxBABkqlWa5LSBi8QhKL7AfOIkENx3dFGpNtHApzwZFexuQKOh5ki/6l
	Uxgq/fGu/zaNi2oLDO+v+dYuM7BWvr5/CIDg7n36p5A4RN8czJy3bJWwXOhtk6i5Cexi6D
	9hnBcOn6V8J454W1d5NGphgocwBXarU=
Received: by mail-pf1-f176.google.com with SMTP id d2e1a72fcca58-82f8892d4d6so4464214b3a.0
        for <linux-mm@kvack.org>; Mon, 27 Apr 2026 07:52:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1777301576; x=1777906376; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=jC1NRZz+kwp3j5wZmm2yj+4VVo1PzPLnch+E5Q6Y4MM=;
        b=K746OGgPcmTEFwA8sB8CMKwdp7t9gGjb7K0mjNHUxro9EY7MmmQ5HNB+hrJGjTvkPu
         ABLQ4qQVzuJSQuGsijth2uZBD/MWUC9IvHGwjET5WmSe9+50xnnnAtcuKEzd7DM5GvnX
         W/lyq7qIV84/NZw9B3aDsTvt2cTq5YOuw6IV12mpIhFUO/4U10lvgYg9bBtiNS0J+uI0
         2lxXhJ/0PB9SSMPt40ro8gOxDWD6wDMjICgYg5y+7O27tlqwiLV87CpoShl0ntXrXVHc
         UY+6lnk4Fbp6bLMOdzZyajAvVz2alSYta5+0aZhSdzGa/S2uExPqbdK7W2BP61nAIzGB
         MzSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777301576; x=1777906376;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jC1NRZz+kwp3j5wZmm2yj+4VVo1PzPLnch+E5Q6Y4MM=;
        b=UuK3vbN9Su7MylsU1xA5GKBXsjuz87KfCO9/5wdByhIhYOLwc54eFk8kwl5Vi4ERZ6
         4mBWkO2w4FAhoJzTBXJ20NfWM69P2t9tWuqRao4TPZBoFdSeiS44x/0P+b+RhCO92hLn
         6+grATfGG0P2tueG1g9olmOeVTNRqrutlTRhx/ApT6mKGJdnqQJLCa1Ec4WajcvrBeoQ
         R2HS/sFeX6Ph/yiw4zzg8TwKIF538nJgHuvWN9LeiygOUqrcUDwjuGTgVhROPHVsBw3d
         rWZXmYBBhlwIkNH5dAXEWuRdGpNgL7UfFpiugjbcRAl0l4vzW5tzuj7FOQGQLtVkNhQe
         +pMQ==
X-Forwarded-Encrypted: i=1; AFNElJ8ZMDIjAjM53b+06sLJLiWcocKv/OHn1ug8MiDXGzhCfo3b23QtUzzf27g8HGBVEAnNoEIUTt5PWQ==@kvack.org
X-Gm-Message-State: AOJu0Yz08wTCCXN09haTPo7oOMx4GL+QhV9mTcxhFYkqlOvrKqKGm25e
	SeMyhr3wsksiyAsUTXd6jNMn0R9ZVnSV9ES5cwtfU0NifI7xO0gerCTp
X-Gm-Gg: AeBDiesyx2JrNSnrySr59MFd/nghqo3wdCcj5t4jsrMuoWgUWqby7LF2woeU1Czhnuj
	MQkxUMbz0iGmZYm7uf9zYv7q+7OxEaXSZv6P2DXsMPadbFOzTEGIddf3Emlcu7WGnpGnQdg5VhX
	xSW1sMaNxlhYowEg8NqXdvs/eUFxrI6H53PlGLSqyG2ZrNsTZuohQLigi5CG1XkfkggFrkMA7Pb
	rxHWTQgw3biltUH9Y2LKhmIkFZAk7km10aThQd5zNbqR6FszxyJ+ojXeftoD5ukx4+gofbefORx
	+Aq+44tVPlE+I01nXFZnWGo+VHI0ZIbITZSkzUVsRvf1PdIYaBTjoiic9gEKC1geeGwl4ajEjnp
	lNSOddFquYp3PP3zrkseHQyFw2ySPK7ARc85uavJFVTTqu4V6DZ8b90kDtWGSygg6XbokFDDADo
	eNyg6I0AJhIhNd1IT2GMxe9vrq3utCgCfW4uGieRZo9TJEpJjvD13O48qCSZtBwrg3rybXQJp19
	A==
X-Received: by 2002:a05:6a00:a241:b0:822:6830:5900 with SMTP id d2e1a72fcca58-82f8c7eee25mr42954392b3a.6.1777301576381;
        Mon, 27 Apr 2026 07:52:56 -0700 (PDT)
Received: from KRHW1CJW23.bytedance.net ([139.177.225.226])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-82f8ebbf0e5sm33009112b3a.28.2026.04.27.07.52.52
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 27 Apr 2026 07:52:56 -0700 (PDT)
From: Catherine <enderaoelyther@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	David Hildenbrand <david@kernel.org>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Catherine <enderaoelyther@gmail.com>
Subject: [PATCH] mm/hugetlb: fix subpool accounting after cgroup charge failure
Date: Mon, 27 Apr 2026 22:52:48 +0800
Message-ID: <20260427145247.84157-2-enderaoelyther@gmail.com>
X-Mailer: git-send-email 2.50.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: EB40D80003
X-Stat-Signature: 4n7umzrmzofuh88npbaafxuzhbabob18
X-HE-Tag: 1777301577-521662
X-HE-Meta: U2FsdGVkX19gAW1ZjZt4XlwFJVPLjXtxLD2GBl6H96hLnqsJ8N6RNjNfFm/vO1W5NBqzNGPjuche+oeePh1d08a6lF7zD8QNFJbBCcwT7fLsGGA9M2dg6vuoripNG7fWvGZ0rUg90Ycb9sW8iwMF/R3Xzpect8kygZTclz7SrY3QYTR8UT8sO3RhjSH1/trjP+gMR5EJtiOcWmsoZOwxFe/IbjShk2yvIZhs7OOl+IuKCU1AuNP6mXzFVZN7iGERFzv28E5kzW8Z6F+mPNVgj+iThSRkqqKoWm4C94xibxWR5Z9CjdmVN6oBu2K7DYSgJXGBV2PTa5K79Viq7x3BOEFEChwJbyxaQGDFgUUcqOe7cI2nhKVHE7Asi69hKl3BK9tIGgTzGxFCU9T8OqhPdy1zqDiRYFeBilhOcTlGePbol6T06jnx0ccmzrXaN4nA7WzXG4SIw36euL9qL4r06OXwmCnpKvJ5UgdSTk4qGVkO5lOW3wwy1KKfsKlVbPbDtiuRxsKpZH+ZVHf2+QF1tlCQwN+XVRafDXBokOsl40sV2t0F5xBWRiBAhUpYRMkUvyHf5JeYPsqwq3HoO0kQoIum2MogMmJagSjB82n1aLZCySnSfa4rjpeKIucxIBd30En9S57vbo2aH20Rnj1kS415B5uNXne8oz/aD3I6zvzyskzE/JOGXsbBnCa6LDxGlCArwVPEfYGioNnGYKrsoL3ySzRy7+AWKrK6rUiDN//4XHL+rNAhilqUueGkkIbzExFZP+gJTAZH46/ML/dLSYxgTN2DcGgoR7C8/qHO5QOeajU0vMvSJx57UWzDzo6jWtw7OLpgaTA/A9O4ozDsX+3c/Hj43thH9BDmbtjcsSEue8xTHNy7Qti3EMSn2AkXuW06OY0eGGCxOY2cJ6ptVUQ2Kelq4LIbTXC8GexC2zmrXpLOC05UMqxIZAe34KbrYhWItFePvzrPsTsZRWZ
 hs1GEsT0
 KcjDx/DuOUjPXxIJly82j2RbDbThJ/W+Zp28fplzIURu5KUbuDPSY7dupqtYzl4/zCI9fXO8GEcw1hT7YYP4orFHNHh7jLWHj8hij0l8FTkVdlvidsykLPJz9jUZClWk9c3bpQxaYyFapT/GLVwM1xr1dImOr60TV/aBqG/ViZt7fC7KAm1I+hgVtLplhgRgSpmWwp/1cH7201XIzSOrK/EI+U7GMKd7olUg5ymPPIhPpp149DBg9w+fSy6VnyEoYBoH9rnohIH4dPLYXHhk9Up48yWWEsct9L14TbZfzonkhc33A2pPaA1MWZGrUevgTJ4h/uqw4eee7HEt5NT0jGhSL6bIx6VOj/MFBoKX5blB8o2BhmZkfNUOIAQQ3F0MEMITRJ1hA6/Rrdbh04YBXduBfzRX7vT8Xv6MZJ24Ae/2Mr8djMeL7pm/2tksRxXkBlC1VpT8RY9B9jSJsTVWHIGqHmqSMky5WfB7I/HIOGFQFrqtiG3qWZBi0lg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

alloc_hugetlb_folio() calls hugepage_subpool_get_pages() when map_chg
is set.  For subpools with max_hpages, that increments used_hpages even
when the returned gbl_chg is positive.

If a later hugetlb cgroup charge fails, the cleanup currently calls
hugepage_subpool_put_pages() only for !gbl_chg.  The gbl_chg > 0 path
therefore leaks one used_hpages charge per failure.

Always undo the subpool charge after a successful subpool get.  Keep the
global reservation accounting under !gbl_chg, because only that path
consumed a reservation from the subpool.

Signed-off-by: Catherine <enderaoelyther@gmail.com>
---
 mm/hugetlb.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index f24bf49be..b3ad024a0 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -3026,12 +3026,14 @@ struct folio *alloc_hugetlb_folio(struct vm_area_struct *vma,
 						    h_cg);
 out_subpool_put:
 	/*
-	 * put page to subpool iff the quota of subpool's rsv_hpages is used
-	 * during hugepage_subpool_get_pages.
+	 * map_chg means hugepage_subpool_get_pages() succeeded above.
+	 * Always undo the subpool quota charge; only drop global reservation
+	 * accounting if the subpool consumed a reservation.
 	 */
-	if (map_chg && !gbl_chg) {
+	if (map_chg) {
 		gbl_reserve = hugepage_subpool_put_pages(spool, 1);
-		hugetlb_acct_memory(h, -gbl_reserve);
+		if (!gbl_chg)
+			hugetlb_acct_memory(h, -gbl_reserve);
 	}
 
 
-- 
2.50.1 (Apple Git-155)



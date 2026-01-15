Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 61E2CD4660A
	for <linux-mm@archiver.kernel.org>; Thu, 15 Jan 2026 18:14:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 562796B00B9; Thu, 15 Jan 2026 13:14:46 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 46E2D6B00BF; Thu, 15 Jan 2026 13:14:46 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 287176B00B9; Thu, 15 Jan 2026 13:14:46 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 0C6AE6B00B9
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 13:14:46 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id CC83CB97CA
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 18:14:45 +0000 (UTC)
X-FDA: 84334998930.19.4F7EC07
Received: from mail-yw1-f180.google.com (mail-yw1-f180.google.com [209.85.128.180])
	by imf19.hostedemail.com (Postfix) with ESMTP id 3CFBE1A0011
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 18:14:44 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=PJVoXDcg;
	spf=pass (imf19.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.128.180 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768500884; a=rsa-sha256;
	cv=none;
	b=Pj3e89b1KP4mVPTGgymRPnft4J3fc10J/fTyivRYk+IgNF+v4N2ndWmBnaPubo/m33KoNn
	IK/aKDOYeIrh/To0u0vaYQ26Dj/WJMhAMjkN0PG8h7vn6wIx1ynf3ZxBENlcJIwBtnQzCh
	Oh8wJxQ38HEQfuia2PyeWO7jY1x8Fks=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=PJVoXDcg;
	spf=pass (imf19.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.128.180 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768500884;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Fl1lTXpbNrtiLn0Tp+FPt+QeDg7+SN/+cxlb4rbkB8w=;
	b=rs8FNA5hGJOEMzzYljBT0+0C1IxELYs4uXLDrWgPPC3WDASehmVRvdakQoUw7bHplgsUTf
	VEKFqHOPcGH8WADCNKfce307+fKpj3oLSmV7nXFUgELUe89MUm3RPRsGJ067RtecAzxAUl
	8XOE0twPDEa0w0r7u5RwF6alutOIbII=
Received: by mail-yw1-f180.google.com with SMTP id 00721157ae682-78fb6c7874cso13242237b3.0
        for <linux-mm@kvack.org>; Thu, 15 Jan 2026 10:14:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1768500883; x=1769105683; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Fl1lTXpbNrtiLn0Tp+FPt+QeDg7+SN/+cxlb4rbkB8w=;
        b=PJVoXDcgI8rHYOWsmBdwKpiHmizGBSKSZqxu3Dttihv5h616PAxsjM/sCRYCSqOm1G
         FomQJlM2Vu5OT8pdVeRLvAntqJ986qg3d/kIRR7UyblMOKLEdG/2OUWki28WbXHuhrWz
         Na/qyxwOeagxzkWMqlgQEmrvzWSWLPOqt0NIqHKBM3zGICgmqQ9V4Dcc2Sr0Vllnreeh
         vspOOJbrdxbIFZcbtsqBikLduJgVMaGN/lrc+DdVOdttOTH28+mH70rW/uG3KJOllQwi
         Wp2hb3vk/rp4VredJmzJo6Hfdyo+8JLXaKri+lJm2+mgSbTnoW0yv2CC9LgrP0J5qJPt
         IN0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768500883; x=1769105683;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Fl1lTXpbNrtiLn0Tp+FPt+QeDg7+SN/+cxlb4rbkB8w=;
        b=OgoUxMV4HT3ojN5Gu7EKdlVaMC21Qkv+kMhoTS7kF+Cn8sEqmY+fUHXA2WYUg0ltBv
         zdJn8+GP24HYjLVxXf4sjOkAVBYS7p/+WxmAW/kci1Y+VYTbjZ7f7etiLJ3ZchFXxJsM
         Y3gkGj3PGHTiJEyR5vJumdJXEwp7LBTrzEtwL/nyVTutT1Q9C7GUzyc2Zawi6+XO5d8U
         GgngN6Ru+3VyifUbzsPUfWRxNibAlBuqgOJIhBgAyau4bR2Xo4Plr1F0iiXhYa4AJj5X
         rOdrHsHk/sGK2BpXtYisWOT0HNt8pyck2X2eQq42Ib1Kfoe7TZkvx7R8XNMB/7z9pUcq
         z29A==
X-Forwarded-Encrypted: i=1; AJvYcCXV4akgNgMDjcveWBuASX0hiP2ZxtimHK/me9/kelC3IMqFuqUTEcQoWj0OiJ52EqeWQo/VngrPPQ==@kvack.org
X-Gm-Message-State: AOJu0YzIrzKP7JD0sT6zG9/0BgmUHhOf69oExUt78AgV1BofT0BetI+m
	cEz5QZ503czhhtVm0E2rPGRc/uLEOnqp8jjYxbCF58D46enWsaTkcdQ0
X-Gm-Gg: AY/fxX5SswN8DSHBSsIrOi0n5Sy4wInPzGjvNACjYKEdrCDnoiTLEvhz81Up7un1UGS
	PwnQBpQ1GaFPVXWz5xHUwe2HNAp5HiQ6xCDCShWwHgZZvm6fBbpwtfHBM+X2i5NH6oEt+VZH4yD
	QeTkN+54L7QcOq2QqKX+fe9coqbsoxrGtbTzZLDjuvqjL5fO7UAzHuRdHlk8+mBjJSqVOpjpv/2
	xDFKgvvYOegbMwBkYgKNgYJrpAW28CxQX35AUOFB02c/BFzeYy/k+eVb9zbO70eZAeySTsJBXkQ
	L564lhRLHcAuTVvahCckjdJQuT9POtj18eeAN1FhTBTVPU+FBZLgDh80++5KbiK5nBcN8mHqPu5
	EYVroHJgF+PgFrIncyj2DUfe+C/bIevcd2xuJLLtY9Eqz47+YengfWPpXPWhcXC53Kkq50HJgCA
	aQm1j6U6ayxg==
X-Received: by 2002:a05:690c:39d:b0:78c:fd6:6c11 with SMTP id 00721157ae682-793c6701158mr564687b3.23.1768500883222;
        Thu, 15 Jan 2026 10:14:43 -0800 (PST)
Received: from localhost ([2a03:2880:25ff:57::])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-793c66c726dsm206407b3.8.2026.01.15.10.14.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Jan 2026 10:14:42 -0800 (PST)
From: Joshua Hahn <joshua.hahnjy@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@kernel.org>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 2/3] mm/hugetlb: Remove unnecessary if condition
Date: Thu, 15 Jan 2026 13:14:36 -0500
Message-ID: <20260115181438.223620-3-joshua.hahnjy@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260115181438.223620-1-joshua.hahnjy@gmail.com>
References: <20260115181438.223620-1-joshua.hahnjy@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 3CFBE1A0011
X-Stat-Signature: 7o5afuakq15cmxdb1wr5b9z9sjuxsznu
X-Rspam-User: 
X-HE-Tag: 1768500884-428802
X-HE-Meta: U2FsdGVkX19wI5+h352GdxrlcjOR1xTQjnv3go6s11t4+NW/qleyp25Ubwd/0tEoNT4vLxIHPMpO6jl/jagqz6Q10GCeLGHGNVQAhNJbrtwqD/0nbH/Z5OGsEwAL19YO7y9w52usQiv7jYjHrJ0cQNuHcbYzUzdK/nTAVgUulxlYGbEZStuY6bOullshn5XDHSy0NXKn8v41Pb7Gc5vo+AihVdAp0FGHC8NttWEEZGhK8hWzbzGjOtKnAq3wGdYcEBPaBI9k7YA6x/mcMaEL380XHCwyYrA+LGDBSU7W8aib0eYdviAzDVvE1zK48BGz6+4nik8O9BzqVA/CsrHs038HE5iUaL4e0Wdo/S7nvCONt/X8nUsEEQmR+sp0fjeKyYjOiphhXCeXG5FlCTTot0J+wyLxxOYeBewccKGjtA9O1ytQSpvX9Fc8pCH8qSX2Jis8Vtx1zROio+IdzoeGwXIYdYSP9IoonESSB54Ic1xLZjbxPwkmmxsUEDxV8iIlFdloSQ9W9eDsgF64WrBgCmOweW6u1YlQJW94U/G5otOPANQpbXCKKQKJMym5vUPsImlQ4vXpebfpkJIf5bCXfs9c1vqCAnFsSO1FYVTQODcg1Uu7uWWRtkABb4favf/Tvm8ogcIDCX4ULdIIp9X4NusYqEVgYDAD6fQ66fo1shUizyOyTtryXMHmocYS/eYOfOnJLpUHAvASDhSAoeywjyL1WKMRixQUwdpM94dfK5znjIxDFh7Hl4PWIdmztqt+wX6OiXc9Rnju6ca/kO52M/IPU5uXEDtpD19bsF+KjlkQUoptva5CVUoGku6lujq1HLbpYLbdyJOFbt+SEyh+h6r0oFTA3RhFcpoyv0LZEyOkH3XQ32JE6+AE4xtWiOBXOqRy67i/tmMiux+wsm6PzYX9CvSrgUWXidhW62NxGMgEPur6mKH9ydbLXpRgZU+MyN9Oi1dAgUzpAJS88lk
 P9YMTxor
 yKThsWRq3WOnj8XaVVBPG9oxCdFBC7ZJ/xj7W9pRUsxterG+4EY+YL9Iyhu32tCY2Pu82VeVOA1Jx5FrmB2VMv0kwGOEU+TMXFwlU9OEiqKdPUPSnlsrEQFxv1f8DBID7wWQ0
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

if (map_chg) is always true, since it is nested in another if statement
which checks for it already. Remove the check and un-indent for readability.

if (unlikely(map_chg == MAP_CHG_NEEDED && retval == 0)) {
	...

	if (map_chg) {
		...
	}
}

No functional change intended.

Signed-off-by: Joshua Hahn <joshua.hahnjy@gmail.com>
---
 mm/hugetlb.c | 12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 88b9e997c9da..432a5054ca1d 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -3019,13 +3019,11 @@ struct folio *alloc_hugetlb_folio(struct vm_area_struct *vma,
 
 			rsv_adjust = hugepage_subpool_put_pages(spool, 1);
 			hugetlb_acct_memory(h, -rsv_adjust);
-			if (map_chg) {
-				spin_lock_irq(&hugetlb_lock);
-				hugetlb_cgroup_uncharge_folio_rsvd(
-				    hstate_index(h), pages_per_huge_page(h),
-				    folio);
-				spin_unlock_irq(&hugetlb_lock);
-			}
+			spin_lock_irq(&hugetlb_lock);
+			hugetlb_cgroup_uncharge_folio_rsvd(
+			    hstate_index(h), pages_per_huge_page(h),
+			    folio);
+			spin_unlock_irq(&hugetlb_lock);
 		}
 	}
 
-- 
2.47.3


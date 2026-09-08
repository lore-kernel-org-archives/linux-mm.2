Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0F4D7C79F99
	for <linux-mm@archiver.kernel.org>; Tue,  8 Sep 2026 15:58:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 798DB6B00A2; Tue,  8 Sep 2026 11:57:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 724396B00A3; Tue,  8 Sep 2026 11:57:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5C36E6B00A4; Tue,  8 Sep 2026 11:57:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 2EC776B00A2
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 11:57:56 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id EA8641C28D0
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 15:57:54 +0000 (UTC)
X-FDA: 85191050868.14.EAE8A0B
Received: from mx0a-00364e01.pphosted.com (mx0a-00364e01.pphosted.com [148.163.135.74])
	by imf21.hostedemail.com (Postfix) with ESMTP id 67BF81C0003
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 15:57:52 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=X6wJmGAB;
	dkim=pass header.d=columbia.edu header.s=lionmail header.b=p2ggz2sb;
	spf=pass (imf21.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.135.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu;
	dmarc=pass (policy=none) header.from=columbia.edu
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788883072;
	b=Edd80ZdTJngrtIgifO7qXBCcofVQzvdl+58pbCcF4V80+bVbdZlM7Gzgt9hJyC5T8rF7pQ
	m+3FBSOyBVCiSFqtGxtYQs4EuXIZCeuphNau9D+WWA3QvMzEKWk5+oWnEmt7cYKfBg7gUB
	NAiToihUSQbWs0zgl/zAUrH0fkJ+PEQ=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=X6wJmGAB;
	dkim=pass header.d=columbia.edu header.s=lionmail header.b=p2ggz2sb;
	spf=pass (imf21.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.135.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu;
	dmarc=pass (policy=none) header.from=columbia.edu
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788883072;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=W+SYTc9YgTwbyvQtPG0l4mF2QbsfRfThQCH4AEEmni8=;
	b=SsAJQXcPwelb/e6rPK+qCFp3MmT5sr27NcaY79Ft6kehiszGxpi/fOyh6/YlhHY9tkmbmI
	1Pw6RUIWGEhnbKss+BHkarOeFYrjBE4NH2l9gkUPWgAkw7tGuhdiN+rh2m5SYsW71dcudZ
	f7upvKBkb1SA3+IRjFNfCSgeS2LbSbw=
Received: from pps.filterd (m0167072.ppops.net [127.0.0.1])
	by mx0a-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 688Fbdfm1154500
	for <linux-mm@kvack.org>; Tue, 8 Sep 2026 11:57:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pps01; bh=W+SY
	Tc9YgTwbyvQtPG0l4mF2QbsfRfThQCH4AEEmni8=; b=X6wJmGABACvVcn/8A580
	VUgc4bV7zmwzLAWYWl7bPh0WrxFjtYEvbCCmiqoIBKQSAJqduelA4iHiY1zEnHo1
	QenyZxHNHaouUWRkC5nG5Ffsgq29G+oQiO/hcD1QsI7lTkEFGAv8foaMB2LGtlIf
	oQivZkspUeNV+lgfyiXLzmqwqvTpLMIJMTQHPuo6mJg3NJ0N1Z4T5I1LCNZfVGS4
	4xK9m0dQiLswilzwD3wzVhh/phO6hpwfJxgH9wwV6NNVsx92v3xhhzDshASIksDG
	/Na67ZvNnhcTdoHutnkY1J6/BQPjqLYLJ1u3LuL9VL7zm8DZh3pLenrQJlafdrwx
	lA==
Received: from mail-qt1-f197.google.com (mail-qt1-f197.google.com [209.85.160.197])
	by mx0a-00364e01.pphosted.com (PPS) with ESMTPS id 4gj50j5h29-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Tue, 08 Sep 2026 11:57:51 -0400 (EDT)
Received: by mail-qt1-f197.google.com with SMTP id d75a77b69052e-53094ff7090so22865681cf.1
        for <linux-mm@kvack.org>; Tue, 08 Sep 2026 08:57:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=columbia.edu; s=lionmail; t=1788883070; x=1789487870; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=W+SYTc9YgTwbyvQtPG0l4mF2QbsfRfThQCH4AEEmni8=;
        b=p2ggz2sbvgGGgAxywFMMv15LhWbuX05WVtNiGNWLO6OpjXP9ZpNXcsaGeLOmoucUaa
         66//1jv19RRWJCkhumvROwV2xxkoFucM7Wk6k42/jByoMqId/BjegrZzyKwpRnSsIy1W
         WHcwD8QiOQQQBtLeGXXQwsXh0bwFQQI9vqcG9OETiGtdzxLua3VMAgWc/uttBOt/xRgG
         OqUuewBdc0OWgjrrmzrhVDf+qN3KwIWLXfojSzTEs/pPFPILuNbskaTeUGE020z/BYdL
         eeEJHMqEGf4bmRaLm+3WoIewc3gBwJ0GHyfbJHnSzu4s/eSKFPK/mkHyw6UrhbnsVSwR
         6W9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788883070; x=1789487870;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=W+SYTc9YgTwbyvQtPG0l4mF2QbsfRfThQCH4AEEmni8=;
        b=dfFrwsYK8uCVKarJOkbx1UuAo6cTRTGOr5q25gLvzKl9ZZZ63yWkWvOvtJj5WIyHnx
         U2BHtqBWXLXRHyP+EypASSx0vQ9ciTW7L4j9GdbH3f2cAns8FvzRqCkR7e31IO/TviWg
         1GCg4kFRq3NcWDrrj8xbf3cyOkuSUXnjzmRmx91hQnjMk6E/9CGJZBu/2F0DIWRmM8W9
         4MhxS2QgG7EDIGClkKlfSchY2SKDFOwr8DAoDRRI1nCnBBqG0G0pkcAH89fZZl246Eo6
         mMhn4CxnQpvV2DzGv7BwXENOQW5hOQzeOAywvUj9UYawaDalpzLg8NnK5osNLvC/2aIW
         1wEw==
X-Forwarded-Encrypted: i=1; AKwUvBxJZy47GccCtXZXspib66shMD+B5ez9yx4WE+PyTEvE2b9cb9pKoihm9kWD9sCbh6fk2Tm04e0anw==@kvack.org
X-Gm-Message-State: AFuF++lTXLuk4SMjTxnPl9aNmCEutxBBzY1iIJUnDY+xAmf4gEZnqQtx
	pSDsBdA7z8FXFxmxqpEqkjz0hFimhFyEr22DDC+IyS3ApqWC9z1QFBHTVpi/Eirv/a5d+DdLddr
	FGFagrN5+GcNPrXBuSr60YniT8n8Rn+ivYlUfjj8dVb3uVRUm
X-Gm-Gg: AYBFou1XwIfnGq4Qapc5y05cfX5F22MPt4a8CiEW8+z2zmqIrePAWNar9U3LUC6YvE7
	1likJlH1FTGp77ukdxZf4UWGx7KqucE3Qv18sU3jQkoizv39ahGWpyMOTlB8VdTYITIpu5aUYb5
	m9l1s137qwLxaPEAW1dYP0EU06kTFMeUwYVmTIdOVVYInJFCp23lw6GjDfnXlWTo8zK5IQTwOY4
	VG/BAho2fw0apm/TbZurzLf6SoFX9r+1zD/PMErhvlys4OgfpXau28rfqCLGD0uXGWWhdv/K8B6
	PsHPbSM49h/AtqnVy4nBp+CmwqEpFpyywDmJGSBcZEHzA5iSCdj3iYFPVkhkrbF31DJVj2Q89pG
	74GlL+MViAi1lDCogOpz0z9J5RBGKD+zvGek9j42MBvL5tDhy
X-Received: by 2002:a05:622a:c7:b0:530:4327:6c8c with SMTP id d75a77b69052e-53054a35c32mr336955201cf.49.1788883069984;
        Tue, 08 Sep 2026 08:57:49 -0700 (PDT)
X-Received: by 2002:a05:622a:c7:b0:530:4327:6c8c with SMTP id d75a77b69052e-53054a35c32mr336954491cf.49.1788883069421;
        Tue, 08 Sep 2026 08:57:49 -0700 (PDT)
Received: from [127.0.1.1] (nat-128-59-177-174.net.columbia.edu. [128.59.177.174])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-53093295584sm27830461cf.13.2026.09.08.08.57.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Sep 2026 08:57:48 -0700 (PDT)
From: Tal Zussman <tz2294@columbia.edu>
Date: Tue, 08 Sep 2026 11:57:40 -0400
Subject: [PATCH v2 04/11] mm/page_io: take a const folio in
 bio_associate_blkg_from_folio()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260908-folio_memcg-const-v2-4-811e9f443409@columbia.edu>
References: <20260908-folio_memcg-const-v2-0-811e9f443409@columbia.edu>
In-Reply-To: <20260908-folio_memcg-const-v2-0-811e9f443409@columbia.edu>
To: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>,
        Roman Gushchin <roman.gushchin@linux.dev>,
        Shakeel Butt <shakeel.butt@linux.dev>,
        Muchun Song <muchun.song@linux.dev>,
        Andrew Morton <akpm@linux-foundation.org>,
        Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>,
        Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>,
        Baoquan He <baoquan.he@linux.dev>, Barry Song <baohua@kernel.org>,
        Youngjun Park <youngjun.park@lge.com>,
        David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
        "Liam R. Howlett" <liam@infradead.org>,
        Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
        Suren Baghdasaryan <surenb@google.com>, Qi Zheng <qi.zheng@linux.dev>,
        Axel Rasmussen <axelrasmussen@google.com>,
        Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
        "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc: cgroups@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Tal Zussman <tz2294@columbia.edu>
X-Mailer: b4 0.17-dev-db0b7
X-Developer-Signature: v=1; a=ed25519-sha256; t=1788883062; l=1933;
 i=tz2294@columbia.edu; s=20250528; h=from:subject:message-id;
 bh=puRmIXD1Ve7ElQt9KP4DSIyIaDfy+iHVy11lX8uUHlg=;
 b=8/SxO4FLsM5OCzLi0nlD3CTL6XF04Y6/eTXATxHGLojvR37DUuTf/wd83bHyMJ3AJGQZnLJV/
 uEAVipH37guCcOZoITV71ESfMo/6Y7Sc8NLmzp0LsxSiktRTH57GuJ4
X-Developer-Key: i=tz2294@columbia.edu; a=ed25519;
 pk=BIj5KdACscEOyAC0oIkeZqLB3L94fzBnDccEooxeM5Y=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTA4MDE3MiBTYWx0ZWRfX8yvcB3VV25KB
 xW2WR0KkGbwbwV1lGJC8kCeGUEoWWdvCmAofmoLDXymD1EdTLvPCLwrCEQqrp9dsvEuBgN5/Is8
 vnWqIDVA2yHsERiYw8viiV0lVQO4GkHLcXfqVX2ltoiRfB/kPTZI2TuYck5x1tgXoozeyIh9og1
 bdVJ08hrqt+/xJa6xRvN0JinGm9sOaerzGGAvu3xUWqtDThndxjA24AsoxQv+BQbfF5Gzr3htQ7
 zRLDFElVIsLFZgn/fa+WZ0wg+GkuzViBiZ0LVVP4FHmNvJSwrg4S+Q5X/7bcnnHbDb8Un/eNsSy
 weBR/UzO1Mlk8iag0o+dP+zezrtNlVZw+rrpFBhTZHN80SeXegxusf5BMN5rTcXYVQCIWVcvvh4
 5+RCuLeZYHg/GC9IRMpwoV/EUoHO+30tg7ZETZz2h8kN4umkiCBDfCPTGxyt5qh0pU1tyoeKpqg
 Z5WEWzJNSCmG4qVxhsA==
X-Proofpoint-ORIG-GUID: BmmrjMpP-3mazg2-djglMLifwO9ylpO7
X-Proofpoint-GUID: BmmrjMpP-3mazg2-djglMLifwO9ylpO7
X-Authority-Analysis: v=2.4 cv=O7gJeh9W c=1 sm=1 tr=0 ts=6aa0307f cx=c_pps
 a=EVbN6Ke/fEF3bsl7X48z0g==:117 a=HBUb3goEnnz3w2smY6d+Hw==:17
 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10 a=x7bEGLp0ZPQA:10 a=A0y_DWxS2BwA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Da8U98TiO7q1upZEImrf:22 a=SsB-OO3BMngHh3ZO9fOt:22
 a=4JVmFDg4bpWGYAirTr4A:9 a=QEXdDO2ut3YA:10 a=a_PwQJl-kcHnX1M80qC6:22
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTA4MDE3MiBTYWx0ZWRfX3RKFJvbs3nJL
 Edh6qCh2BsD0RTvG51R/MKJKirAleidyl3wPjXcZttT6E5F6phRvLA/qUBLkVIHt+LZKi7jd2Pj
 PAEQl9BeJwm0yKyyGibd9IH/Xwg5URNGpWzmfZtu1ykgbZTRbL/+
X-Proofpoint-Virus-Version: vendor=nai engine=6900 definitions=11900
 signatures=596817
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 suspectscore=0 clxscore=1015 malwarescore=0 bulkscore=10
 adultscore=0 priorityscore=1501 spamscore=0 impostorscore=10
 lowpriorityscore=10 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2606150000
 definitions=main-2609080172
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 67BF81C0003
X-Stat-Signature: 3n39ixxjug7fom87ffrpsgfing54k66f
X-HE-Tag: 1788883072-682068
X-HE-Meta: U2FsdGVkX19TpSSzF31cvknSiPn7333wBH02CrwVY4k2193a+mqh1lYG9CAGczycMBLgjIEAnKjk5KfpMkUvux5gQsJcJRSAdj3d6lpP1Asgq7pKd0m/+5nRfjeF3lzJmeFqk8/qutwNzm85r9BcV8erZbrUBtK1aAhuMpHpkR5oYyrruwWDzXYkfVrFOzpHo3DDzCcSosfGGrgAcjpbR11IMKeZwu6kK7ziZaxQUc+W9gIBu/ya/luqIWNJ1ZeIw9AJZ1dYQXnapNkrRZ35ArFpnQxWBxsWxi1POCRopappwQGMzY/XWropwaJevSUmkdLb2X33pc8KOzDKCA5wvgIYBykC8vXnBdLhytJ9iuww4Nx2D2idnuZ+Kw6k0zQjOuCYJJxxTd5dIOviQvsj6JRnN9YbZ9o+8U18MEz0HcSLCx86kanpDAPzZxx3dcI6HgBJCLuR+BTuIUEXos1s+Tjag+28Mu1yXMwJ+RkFtr3N7MEB4o7Ft9W/Xy0yjbPFPBmnMePnC7MrdJQPNELcc14XwmR6mtFyF0KsALNDSqbayn8aa1e7bL1LFLTLZG8PqyGbIKKEEDqMsKlbJ6R/Pbs20u1PGh7uWuvEaTSVPRnPybqMLW+TANmWoYTXvGmMHPULK3+KRmR8fXmEiz1rfrnNcEEdXOOPiJ5jpS/WOs2GTZFwI0fJC8g6EPrBTuAZ2td08o1KZJSstTizBI/WNLS3qbxPgxTcrjiHg8RRZl9Ux34vtMbunhPMMysb546KZa3Gm7UYXpTDKQq8mbIPds/z7SruQnKHVKdJceO+3+HyuDyT/0SC8aeO23OTfFWLgT6dDP2zKSaZ0+IzffvHO6Yi/vn48V+5wc8Ekw9bsfIiJ+nLSkmHaX53oflfzqxuwvLuebPnRXK5hfEuJx9L9IPX3r5MZh6OUw0VX+PJb4A6orsYsOeOquUCyLlPU4QDWPQR6SWVFWI11Z4GC0Q
 75rUVgQo
 JQj9QiLHpL/JoZgCJDVTj0Dxya8OsXszPESLUAN9AQwdcBlnp0Kfvxz6bq4QfLaN7sxwYefDqcPOVjpVfW1DJzpZt9uomA3M+8jYMneV7E8F4dN9Xkz1fmkjvGuJXJzTTrCZkSsG0PCLMt265z3KJYjNecAawuJaGGikGlSLxwpcn08Egk9AyOf1grLB1VX9o27NT+52rCWXQd7luRZYu6cIA8YaBQqtZjtwsOeUzSPEzpFWGGAOJAxPYwHDjdkYDP9lyi9QL8sFvPpNTf7T3V4J9Ikckr3DDfurpxaPHuJwpXvwOaJQv85ejDfPk7v/IGyd5caEOthpfoBPYua1VG+ZE6eXgjq5eV/F7s/xHXL8dkH1LDnCL03SjFA6wSzZkA73WzU0aI/k35WlDgW83M+lBJOUIdohe5HgEUp55NMeY0SI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

bio_associate_blkg_from_folio() and its helpers only read from the
folio. Constify their folio arguments.

Signed-off-by: Tal Zussman <tz2294@columbia.edu>
---
 mm/page_io.c | 14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

diff --git a/mm/page_io.c b/mm/page_io.c
index 1da4ff484f09..5f7756e370f7 100644
--- a/mm/page_io.c
+++ b/mm/page_io.c
@@ -256,12 +256,13 @@ int swap_writeout(struct swap_io_ctx *ctx, struct folio *folio)
 }
 
 #if defined(CONFIG_MEMCG) && defined(CONFIG_BLK_CGROUP)
-static struct cgroup_subsys_state *folio_memcg_blkg_css(struct folio *folio)
+static struct cgroup_subsys_state *folio_memcg_blkg_css(const struct folio *folio)
 {
 	return cgroup_e_css(folio_memcg(folio)->css.cgroup, &io_cgrp_subsys);
 }
 
-static bool folio_blkg_can_merge(struct folio *folio, struct folio *prev_folio)
+static bool folio_blkg_can_merge(const struct folio *folio,
+				 const struct folio *prev_folio)
 {
 	bool can_merge = true;
 
@@ -277,7 +278,8 @@ static bool folio_blkg_can_merge(struct folio *folio, struct folio *prev_folio)
 	return can_merge;
 }
 
-static void bio_associate_blkg_from_folio(struct bio *bio, struct folio *folio)
+static void bio_associate_blkg_from_folio(struct bio *bio,
+					  const struct folio *folio)
 {
 	struct cgroup_subsys_state *css;
 
@@ -294,11 +296,13 @@ static void bio_associate_blkg_from_folio(struct bio *bio, struct folio *folio)
 		css_put(css);
 }
 #else
-static bool folio_blkg_can_merge(struct folio *folio, struct folio *prev_folio)
+static bool folio_blkg_can_merge(const struct folio *folio,
+				 const struct folio *prev_folio)
 {
 	return true;
 }
-static void bio_associate_blkg_from_folio(struct bio *bio, struct folio *folio)
+static void bio_associate_blkg_from_folio(struct bio *bio,
+					  const struct folio *folio)
 {
 }
 #endif /* CONFIG_MEMCG && CONFIG_BLK_CGROUP */

-- 
2.39.5



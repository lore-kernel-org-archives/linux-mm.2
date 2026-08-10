Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0B9CAC5AE49
	for <linux-mm@archiver.kernel.org>; Mon, 10 Aug 2026 14:21:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 13FA16B009D; Mon, 10 Aug 2026 10:21:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0F1046B009E; Mon, 10 Aug 2026 10:21:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EFA996B009F; Mon, 10 Aug 2026 10:21:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B76726B009D
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 10:21:20 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 41A01A14E7
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 14:21:20 +0000 (UTC)
X-FDA: 85085572320.30.2404128
Received: from mx0b-00364e01.pphosted.com (mx0b-00364e01.pphosted.com [148.163.139.74])
	by imf31.hostedemail.com (Postfix) with ESMTP id C86DC20002
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 14:21:17 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=a4TWNTA0;
	spf=pass (imf31.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.139.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu;
	dmarc=pass (policy=none) header.from=columbia.edu
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786371677;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0np+Mh4g6FbtGTotF1tdHYY92zqeAhsY3aQwW/2FAQ4=;
	b=KAxr3Z0j65HD+KeaVUz2tBd+H51YGKKNC3Msj2gB8UIaZOo0mTzYa0WZexOuXh3TsFPsZu
	LLbLDUuXneIsTRvCFAm4ev4FZ8x04KUvmCQPw67RiIKjwiwdP2iDCFA1fxT6Eu9ctt+U4v
	NK3eQgG164pcaXdfjrI6GWFZW0TECFM=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786371677;
	b=lbTVpUGe562nC7o8pbzZ+3sFa+bT0vjOnR6obXOI5bz3IFDavoK+YkQMQg6LNWBC5ovctq
	t5O7BmsP4h7VCfdqeg2zPGj4IT+fVSMvOZiQlR6o2eaTaN6/fyPsd6Bwb86Qp7JfZ1X5J0
	rI71a3HD/WHxAckudQW1tn8I+HD9aQ8=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=a4TWNTA0;
	spf=pass (imf31.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.139.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu;
	dmarc=pass (policy=none) header.from=columbia.edu
Received: from pps.filterd (m0167074.ppops.net [127.0.0.1])
	by mx0b-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 67ACaDqv2990400
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 10:21:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pps01; bh=0np+
	Mh4g6FbtGTotF1tdHYY92zqeAhsY3aQwW/2FAQ4=; b=a4TWNTA0jldsAoQxZpdx
	gKVTI89o/WtLiku4lqWkbaqHIimCfvpBOsgmQ3NajBr6av3Jpzs89t9CNmBh7f2o
	pzbEZyuRQSQbgKiVFtnMjWs+j5H3OnPItob8B9Dd1sZxJxtbG+RFPFg7vhx7GrgW
	ImrBI4iVxj2sJDW/QYuOBwgzVJyurI/l5jpngzk/or2XmHNedXJ906ILCXFqu0+T
	uNXrQpW6xeFnMltsG4qhCFkSiXXTntJoht255EHo1peTIMWpX7fTQJFYpl8LPYgk
	h5uu9ArmsWvSbwlSIS4z4J0dnYIpex7PF+bzADVBDv2Pb2rhVsBL38kgUv1Dz+zD
	+A==
Received: from mail-qt1-f198.google.com (mail-qt1-f198.google.com [209.85.160.198])
	by mx0b-00364e01.pphosted.com (PPS) with ESMTPS id 4fxykwujf0-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 10:21:16 -0400 (EDT)
Received: by mail-qt1-f198.google.com with SMTP id d75a77b69052e-51c1d7886cdso38007621cf.1
        for <linux-mm@kvack.org>; Mon, 10 Aug 2026 07:21:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786371676; x=1786976476;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=0np+Mh4g6FbtGTotF1tdHYY92zqeAhsY3aQwW/2FAQ4=;
        b=Agx2/X63TJF3GMhszWL98TnJGz7z+gC1BIJwgwf+/uucUmTnOUmdI5NO1Un04CtXQ8
         89OmkSVoD29dHLlLLuAHkrS0LULT7TzGAZ6ufxiAYHr2NVIq8S0y1Ma5Xm1UvUEiTNMP
         ZLIgMMm7U+CuJMuFDOvh8b9l2jJ7ajie+XQkE/yxF6P/4G40C16+Ap/237jwnnOZnXmW
         bVun+4dNNIWpM0w10HkDrb/ZTm8Tmo2GiagzHMBsR+GWiJN5fgmri6hG5RKge7nx1NV/
         am/g0vJabU0re/WJp4DotRjClTrTWDgawWwDR2t7WtZdAyRHF66RRoJcJREUyxeaxWhL
         5Q+Q==
X-Forwarded-Encrypted: i=1; AHgh+Ro0zBolM98kfkOyO1PKIXUW1JzMjsJUbpZcVqK8XqdLDfUxcfrBsI3Eu+fLsQ+tTDKRCvEdvv1IbA==@kvack.org
X-Gm-Message-State: AOJu0YzK0VvKLeHRUinTYPujVXygzFYgohWk1l1kdOxONX/y0jYu2Xka
	Vp5ac8Asa/hhyxc1szwUn9yeei7C3BPTbJzaK7H+VP08LnWzap7+yeBPhxnkm1yUN8d935cwcQr
	Q6syzyFQOxzKQATLk1hMRoK3btnRyktjXOspKccaeDzq+lKEa
X-Gm-Gg: AR+sD10E47aJJX7ZGa/rW6bHGNeoGw28Q44iPbq5W0K7m/Rn3zuJy8Ml09mSTa/a5ZR
	J5RWYodxe0n01qObfYycmB7FYdqATFIy+BAKMuoo02YKpnEL+cORNH0K46vSia7J1D8iCxXZEYa
	+F8v1IDRAsA58L9P3ZSoiPq7UEV5e6I0udIDF82+zwC8Okx3YRi1WaUg10y6TJHcpbXhOPjp2/A
	a33Dxw+pFUYm68hM+TTE3d65Jf2DQG3dkiLKcJ9ngyfBRdH9Zjs2DhNNsauelCx1vnvcfZRx/Fk
	1+MzJpY/s+48pGloe54bM64hbLVtihRLNZp0AV2qvYy2CSZh1Yc/yqZzwDhW51+Q84ra7xZ9eWa
	/Z3tKYjS1
X-Received: by 2002:ac8:6f08:0:b0:52b:4f1a:5fde with SMTP id d75a77b69052e-52d4bbae79bmr27114151cf.19.1786371675726;
        Mon, 10 Aug 2026 07:21:15 -0700 (PDT)
X-Received: by 2002:ac8:6f08:0:b0:52b:4f1a:5fde with SMTP id d75a77b69052e-52d4bbae79bmr27113101cf.19.1786371675218;
        Mon, 10 Aug 2026 07:21:15 -0700 (PDT)
Received: from [127.0.1.1] ([77.137.77.155])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48002145589sm37383983f8f.1.2026.08.10.07.21.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 Aug 2026 07:21:14 -0700 (PDT)
From: Tal Zussman <tz2294@columbia.edu>
Date: Mon, 10 Aug 2026 10:20:16 -0400
Subject: [PATCH v3 05/12] mm: remove wait_on_page_writeback()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260810-remove-wait-on-page-writeback-v3-5-dd7531704f26@columbia.edu>
References: <20260810-remove-wait-on-page-writeback-v3-0-dd7531704f26@columbia.edu>
In-Reply-To: <20260810-remove-wait-on-page-writeback-v3-0-dd7531704f26@columbia.edu>
To: Ilya Dryomov <idryomov@gmail.com>, Alex Markuze <amarkuze@redhat.com>,
        Viacheslav Dubeyko <slava@dubeyko.com>,
        "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        Jan Kara <jack@suse.cz>, Andrew Morton <akpm@linux-foundation.org>,
        David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
        "Liam R. Howlett" <liam@infradead.org>,
        Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
        Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
        Zi Yan <ziy@nvidia.com>, Christian Brauner <brauner@kernel.org>,
        David Howells <dhowells@redhat.com>, Jeff Layton <jlayton@kernel.org>
Cc: ceph-devel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
        Tal Zussman <tz2294@columbia.edu>
X-Mailer: b4 0.14.3-dev-d7477
X-Developer-Signature: v=1; a=ed25519-sha256; t=1786371655; l=1451;
 i=tz2294@columbia.edu; s=20250528; h=from:subject:message-id;
 bh=6dxbAtDCmrnDYkfOuWrS6UKuWVd+lmgUjReNrbBmSH4=;
 b=61yGVyVUUcoA+BeFj6z7ZvMKTrknl5Vy07EqPr8fQbcEitcS02/CCYCNWVboS8DvW4Ni4Bvq1
 Ka4sfab8C3RD10XylVk59bT0fPLpe6Z6WhfUVMqvXYkJBpnLyaK94HK
X-Developer-Key: i=tz2294@columbia.edu; a=ed25519;
 pk=BIj5KdACscEOyAC0oIkeZqLB3L94fzBnDccEooxeM5Y=
X-Proofpoint-ORIG-GUID: LoYskUKF0kSuDfUfxUIpKlKNuRuxr1Bg
X-Authority-Analysis: v=2.4 cv=S43pBosP c=1 sm=1 tr=0 ts=6a79de5c cx=c_pps
 a=mPf7EqFMSY9/WdsSgAYMbA==:117 a=zHmcO6jMd5r4EZ4U0P0LQg==:17
 a=IkcTkHD0fZMA:10 a=Sv0fKeRqtYgA:10 a=x7bEGLp0ZPQA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Da8U98TiO7q1upZEImrf:22 a=azVShVRs0zEubeQ0wG0L:22
 a=JfrnYn6hAAAA:8 a=VwQbUJbxAAAA:8 a=qBqFc3eaEPVjc8k8qNUA:9 a=QEXdDO2ut3YA:10
 a=dawVfQjAaf238kedN5IG:22 a=1CNFftbPRP8L7MoqJWF3:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODEwMDEyMyBTYWx0ZWRfX9Xh8NgKRhNcB
 XZoqHduMHaH5rzv2LGs8ZRw9vlbOPIAGGhTBJMCjwgZgt1ffJOfFc4GR7sEzxArbC6N6o85w8Pq
 4zXfR3DRWsGE3KKOdts10V4smThDeCiiXKCvg0BrshXA5ZLO/FSMZBxI79WVsKb56Y/nnQvwKQR
 gzFgB6xN/H84e/Ccq3GYfE3iN9RsLbxoLCyhVqLI3OFg6HgS7A7Uw/i9jsGFpgcCqEvXcAZo2ps
 ffLqDp5pTdUj8ptUhzdYXssaw79zc60H+aP0TEMiZNF4+3LVxXQZj04Zbg4p+DLkmQvtbYWZ0Qu
 cilxzNFTtBLhmhsBFeU/FNzgMLjMJSc7xi/xyTrBAWTLrOENSl5lbAc+Zs6kpu9uNxHpDTAjYlv
 GpbpvxtnNruiFhljWjXa9Uqkyl10Bd42yB7AcU5bDwUW9ZH8vrIA2oUt0jWCHitnloXteBUMFVY
 rMEt4onH+K5mliIKpdQ==
X-Proofpoint-GUID: LoYskUKF0kSuDfUfxUIpKlKNuRuxr1Bg
X-Proofpoint-Spam-Info: AW1haW4tMjYwODEwMDEyMyBTYWx0ZWRfX8qXVMEy0kYrY
 SnVC3UwB+GkN4xqJhYU0k4GzVQ1TOIZz77zo0A13sjkjXaRJ20FTdxeLZCAMSMru3+8/U5tuXeB
 QIaiKX6GeYU9MHQK5/hHcnmWc8iCXo3Hs7+qcWuoH7FfE+9C/qYM
X-Proofpoint-Virus-Version: vendor=nai engine=6900 definitions=11870
 signatures=596817
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 clxscore=1015 adultscore=0 bulkscore=10 spamscore=0
 malwarescore=0 suspectscore=0 phishscore=0 lowpriorityscore=10
 impostorscore=10 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2606150000
 definitions=main-2608100123
X-Rspamd-Queue-Id: C86DC20002
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: jeyu4fjxwk8fqcm73r4i7eu4fdcp7aen
X-HE-Tag: 1786371677-143454
X-HE-Meta: U2FsdGVkX1++nkdRS7Q5vLn90iP6ZHnLLOUZ38r1/2hEGvvLveCIXSTYbhUowrXbVC9wgm/x63uz524zfDLFa7QUadA8nAbQXm2WKu3UdJgvQsDamGY/q145xiIuuTmbetSDSUhyp8FXpvK1j0wsjhJFUXS6z6SteKPvP1PLeqaHnp/v2z2fm+SPxGv1h8wpyEjeT5pk9VvI9IJ27RrqErrpmRSimB7pN7e4CTRHIhJQYfQ/5U1l2hNsj+S+iSBMi5kKkk7IffT4cHFO3RbeMFpKtEBxytdR1zOtZvkTfxJW/AKu9lFNDOslJG2jNMvsT+BrvwcrFOmQNI/fZ/wFni4zwq0wWOHPuZVqSBe/NXvSXY8+F7jt86grgUxlC6j0Jodw5+gEo6VUDJuVqz5Wghj6ZAlYbwD8xxmIaFF1P2k4/Q1CTnxFLtZ4C6sjeuXGuWldFdMLQEkMZi25jOHtU9Dw9mAzpju/Iq1HKpiQrtH8Bmr1Odldb2RCrsaTVn0VLypBeE6r0F/mvsG9vjV2PlEJrQ3hdyoPwyLJI3RPeLI2othXVWY8Gm7POk5fZZ0h530kXDQik6nvR7QFjX5fPLYamQFrOISxuK6IJNdy5NEtuSmSzFf2XRtzds1oZcjCBrHZsGDobXMJ6bZrmb/lxVohhb0P7Yq7Xv15KeYTOs8du9QbcT+/Ps3pQrzosFTqylPFYGMRsMz/Ga68CryUiUW9M8cRS0bNzNuxxAmLNFRXiWo3H1BnzoJZIeoZfJhpUTZiAt67hyPlviI+w7AtmnyhDnmyCsRZkudr/lmfOzBFx79tOIMnSWdBkXFaUSYTADZTcH0pXUVJ7o+vgEm4YpWVlbR/8pW7NU4wjQTu5eApFoCAEL664re0Axb2Guhcck5RBl/a4KPo2/3fL2r364mGK5eM0bKKewGwAWsHFMx4MFkwzAB4RuhtjvxkROOyf9TYl1Mqj8aYM7aA8s9
 GdWuJUWZ
 n1bHcK9tYFrvt0YS+OG5Ko5nr2MHo4ULa3t2qoAwLBlDODw2BYqk02t36qklGGl0KcQPfgpg8nqW0BzjLkdc4u4SJ0SqfDM5mJVcq7gX4GgCs6aLG09wEfufuG+srqvHFd1us55ezlHFqcy98gfs/BupSifcJLYzGtDrlSunspmSX2fEhOH/KUZD+euB5Z2Qh1+kyP5LA92ttqCHAzzvdRZIO7Rl1E5g1I2PO9whrHdg+q+Er861upUtG1T4mbA8Eg6KZ/nupH1eicsrL0BjFLvNmiV6qvo6QZKSf62d5EnXxI2E/APQXjHrLHGhUdUHyEjz8/FtyJKapy2BEVjyyqvBN9pTwfNZiiX1popIjbhL8iZkpTTocyNzXdckXdo5r3djwXlqVUIbPoHNKT5XAG2ud/dvQJOV6jIi0Q+smCGmmFqn+Bzkn9G9Xn1ZFUmoFGPzSp7ew66pRqqlw1Kj1apB0Z4KWSBsgXWX1eNxaNZPDgwvP2y5YEYcqWTlaRFxW4WQO5TN8ujZ31PlhZ4zYFdA7zpoIXNeC9IE/xosTYkjkZSHseVkWfDClFXImT8phEaDhbL4vhfgwdnBhgxmoz/5L8w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The last caller was converted to folio_wait_writeback(), so drop the
wait_on_page_writeback() compatibility wrapper and its declaration.

Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Signed-off-by: Tal Zussman <tz2294@columbia.edu>
---
 include/linux/pagemap.h | 1 -
 mm/folio-compat.c       | 6 ------
 2 files changed, 7 deletions(-)

diff --git a/include/linux/pagemap.h b/include/linux/pagemap.h
index 2c3718d592d6..3748dde2b97e 100644
--- a/include/linux/pagemap.h
+++ b/include/linux/pagemap.h
@@ -1240,7 +1240,6 @@ static inline int folio_wait_locked_killable(struct folio *folio)
 }
 
 void folio_end_read(struct folio *folio, bool success);
-void wait_on_page_writeback(struct page *page);
 void folio_wait_writeback(struct folio *folio);
 int folio_wait_writeback_killable(struct folio *folio);
 void end_page_writeback(struct page *page);
diff --git a/mm/folio-compat.c b/mm/folio-compat.c
index a02179a0bded..ae0271591d37 100644
--- a/mm/folio-compat.c
+++ b/mm/folio-compat.c
@@ -23,12 +23,6 @@ void end_page_writeback(struct page *page)
 }
 EXPORT_SYMBOL(end_page_writeback);
 
-void wait_on_page_writeback(struct page *page)
-{
-	return folio_wait_writeback(page_folio(page));
-}
-EXPORT_SYMBOL_GPL(wait_on_page_writeback);
-
 void mark_page_accessed(struct page *page)
 {
 	folio_mark_accessed(page_folio(page));

-- 
2.39.5



Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E23BEC55184
	for <linux-mm@archiver.kernel.org>; Tue,  4 Aug 2026 18:53:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 29A096B00E8; Tue,  4 Aug 2026 14:52:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 24AF36B00E9; Tue,  4 Aug 2026 14:52:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0EC296B00EB; Tue,  4 Aug 2026 14:52:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id E12A86B00E8
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 14:52:55 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 81BC3C014E
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 18:52:55 +0000 (UTC)
X-FDA: 85064483910.12.281B8B9
Received: from mx0a-00364e01.pphosted.com (mx0a-00364e01.pphosted.com [148.163.135.74])
	by imf21.hostedemail.com (Postfix) with ESMTP id CA3DF1C0003
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 18:52:52 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=FZQOfS2m;
	spf=pass (imf21.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.135.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu;
	dmarc=pass (policy=none) header.from=columbia.edu
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785869573;
	b=MG+B97xCY2BOYclfAaiZsZ+A6ajuxoXmiRx0Hz41rpSuuCJhlH6PPFUop/BcwRjHwncQar
	m1iVq14A8m8OZrNcQP9knjTad4DMAbFwF82AJKjzH8XV+JleeaLXfnRmZ2uK9j/uMbK7kD
	423UkBUuxiUApy5VPLnQdwgTyuaAIWY=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=FZQOfS2m;
	spf=pass (imf21.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.135.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu;
	dmarc=pass (policy=none) header.from=columbia.edu
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785869573;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aLyblFTyCRkRNvHlbjBlieXQYnfG93Mvps8LThXIpPg=;
	b=AwcygYsXJ+QUZfq+xCw2oE4pPNZ5nY96GJQ4G0L3GobN2iGuiRYDypHZYyfv60sg7d/vfD
	7jcue9EMqoJ7xvaOIJ4VmePFDzScUijMj3HfRCkbVlXtwLWTtrybkFz2Rj6SW9V/+UeSJE
	pxUJhLzfq+JZ35emOjE9IIH0chg6X2Y=
Received: from pps.filterd (m0167071.ppops.net [127.0.0.1])
	by mx0a-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 674IY8QE1999413
	for <linux-mm@kvack.org>; Tue, 4 Aug 2026 14:52:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pps01; bh=aLyb
	lFTyCRkRNvHlbjBlieXQYnfG93Mvps8LThXIpPg=; b=FZQOfS2mrfDQVv1eTgY+
	KoHIWPv7re0oYNY5Ak+9Hk5q72AtkKqpgtlokthMwfu7jmQ+xhBqpqTKIepB9xhZ
	yneWNpbAd3zsItw3SHaMvretXA8+qaOYKNdIy2mbHY6etbfVU/MT7PT4rI2duJf2
	SObadpunqBBBfBBH0bcskN2hDOlTjn+dmhWIx0Z9FnqRYEARekOL413g9Prd2gAf
	kws3L6gGJE9ofKW/2qGu3L8D/L9n+jOo/8oGUM1LSbYoUhcQxOEfeMqBDH300VMU
	kNoC4WkxuLNNlJj5+5KRd8r6O+yNS22qEK9drDas3n7Wtji4lmrhWGPQq3CnQ6rS
	wA==
Received: from mail-qt1-f200.google.com (mail-qt1-f200.google.com [209.85.160.200])
	by mx0a-00364e01.pphosted.com (PPS) with ESMTPS id 4fujcfhv5s-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Tue, 04 Aug 2026 14:52:51 -0400 (EDT)
Received: by mail-qt1-f200.google.com with SMTP id d75a77b69052e-51c0199faafso1070821cf.3
        for <linux-mm@kvack.org>; Tue, 04 Aug 2026 11:52:51 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785869570; x=1786474370;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=aLyblFTyCRkRNvHlbjBlieXQYnfG93Mvps8LThXIpPg=;
        b=lXskC9/zsOxObwISurg/5GPXT9Ay9XQS5hQXIvD1nY68FkUqKmpo/Ww77rYp+iB9gy
         3sH0uvb1TJcVSjQz4W6QpLu4DzO1lSeNvE9Y1wQkT156eNq4/LyxbB8URjUEQD3KVmWT
         GrE5Qd22ykhFZS2kvh4ZwTMIZ6iT2fn24HnX66er4ST7lH7cQ/u/r5u3LK2eJl6b6Xu4
         Uj6KMF8vHoeX7vBe+2a6l2XUbdFDdDjAsD4zXRE5I5afrr7lPp9bEL547r8Bn7vIoSSb
         TwzsPvqV4Y6KwUPDmCW+yo3gEhrWFYxO2XtwTd97jsppaA1gG23wHz5nJklB90dAW9F2
         ZsrQ==
X-Forwarded-Encrypted: i=1; AHgh+Rqg8dOA5HklXQueyqyNprieKJtk5YBJIDJpk7Poqs+dJcozobamshJMM+Dl/J+MwWHWH66v7V6FnQ==@kvack.org
X-Gm-Message-State: AOJu0Yy1HJbUmMjoYaDPY8M0Fj9P6Wur5kDLkbU8OOC0oJm1ekydrsCk
	U6NtX6IaY/uu1Rn26me2yKESVdpdpbijp86667O7kljEpfyBYnJV7/b93YTbx9wxfl3JHXpfQe9
	2KVpNAdyer91Rt3HTt0cotPWlVyi/b+k4bkP3/XCYwyT5Gb+Ufmjuwg1A
X-Gm-Gg: AR+sD13HlvaGK4vkoPgtY6/KDxz5kboBpNGA3htWyJOXG1f+7lC6jgeMdjA7+j6i7Ee
	1dx76owxXsao8CXrTv4Zif6CFkPyKIFmm/G2MYk9q6G8NLyfSA8CbQoc+wpaWq4eipFdOReqqf3
	SSH3cyfDuQWja4bDAQ6WDs9NhaNPhH6CxtACF4dHqUh0B++YApPNLDoCXKAJq5AYRY57SqkN0gp
	GZBSRtIn6tN+mdT9tZRgYkU7uWzMSA+EK1P32gESBQDrmiBPsBGbaC6aSiuqFafEc1x/wrROm9R
	M9OeuVlJZw06x8JlcHgs7qN1H3eCvN7FVSfbyO82jTI+PDmpXakWEgPNkzjrY0u1PadJCh9jiIt
	enIuoMdzy
X-Received: by 2002:a05:622a:345:b0:527:6dc7:5c5b with SMTP id d75a77b69052e-52ce61009cfmr11185321cf.21.1785869570479;
        Tue, 04 Aug 2026 11:52:50 -0700 (PDT)
X-Received: by 2002:a05:622a:345:b0:527:6dc7:5c5b with SMTP id d75a77b69052e-52ce61009cfmr11184811cf.21.1785869570010;
        Tue, 04 Aug 2026 11:52:50 -0700 (PDT)
Received: from [127.0.1.1] ([77.137.77.124])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-47fec232d7fsm2313275f8f.20.2026.08.04.11.52.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Aug 2026 11:52:49 -0700 (PDT)
From: Tal Zussman <tz2294@columbia.edu>
Date: Tue, 04 Aug 2026 14:52:17 -0400
Subject: [PATCH v2 09/10] ceph: remove ceph_fscrypt_pagecache_page() and
 ceph_fscrypt_page_offset()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260804-remove-wait-on-page-writeback-v2-9-81f0ab065284@columbia.edu>
References: <20260804-remove-wait-on-page-writeback-v2-0-81f0ab065284@columbia.edu>
In-Reply-To: <20260804-remove-wait-on-page-writeback-v2-0-81f0ab065284@columbia.edu>
To: Ilya Dryomov <idryomov@gmail.com>, Alex Markuze <amarkuze@redhat.com>,
        Viacheslav Dubeyko <slava@dubeyko.com>,
        "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        Jan Kara <jack@suse.cz>, Andrew Morton <akpm@linux-foundation.org>,
        David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
        "Liam R. Howlett" <liam@infradead.org>,
        Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
        Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
        Zi Yan <ziy@nvidia.com>
Cc: ceph-devel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
        Tal Zussman <tz2294@columbia.edu>
X-Mailer: b4 0.14.3-dev-d7477
X-Developer-Signature: v=1; a=ed25519-sha256; t=1785869541; l=1581;
 i=tz2294@columbia.edu; s=20250528; h=from:subject:message-id;
 bh=eEBEQRS44uRWq+68HnHuSJkJWcepL1mJ0SSpfrhNU80=;
 b=ymFYHbrvN5rEjeaHcX4tJ/TZFBIdDlWxKA60/JN0KDJrq2/K4VZWWR2AOJJsHb/WIAfLsRBdE
 dVh0f4m20VEA7/0gLk/zQLeySGdoHYncfupyZbHlWLadTzarlMg/B7k
X-Developer-Key: i=tz2294@columbia.edu; a=ed25519;
 pk=BIj5KdACscEOyAC0oIkeZqLB3L94fzBnDccEooxeM5Y=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODA0MDE1MiBTYWx0ZWRfXwDHYQof4+Ck8
 k2niXNtEDzpwHa7BhHatu0y/CYrzCV/fJo3H+SFC+bQgjIL9mzasU5LLkeyO9o7NEx4OwxZKz4a
 8kGXKF4tbLjV1oxKrI5JSHE/4ghpSoVt2fu0pv+YsZsUMJrN0brX3SKQOaAcSiqtdsictZ4vCMp
 Kh2FPq/BzC1eIn0dvUb8rYH6DuHTC2Uz06hGi3miYyQM7opQsDQ44U0sMsyo/AdGwlnt13miqqI
 dDhBJShXnx4DsGiPqjRSpSJxvNuRDuwYP30UlvKanJ9VXEYvnHeZJuHBjYjOsUeiVOVV84m/K4h
 U1hft58IERPtHaH8Re9MecOsYDzXWvSAHXBSfWADHz1m4C+/WNP4owdXxy+fJghSjZTt/yOaCD9
 YA7N+xTXWC8ZZ4+mEMXFOWJfoD90IOLjLn9cYy3o/cGkj2OT4d5Vd1sZqzfL79Syz8HkfEQa2mI
 kUYJSQm2PDmNlk7mdhg==
X-Proofpoint-Spam-Info: AW1haW4tMjYwODA0MDE1MiBTYWx0ZWRfX50sAMelcP8aA
 bh9OoP7+xgyHP77gEWDGUpCae5+/9HHATLReaRwCeahwJhvfMp7k+5uJObJ54BJq3JbHrLjhzHc
 JdWEo5FjmV3qpx28VbEMQEfeECo9wiBplZjVuC+LJvmza15NiJMc
X-Authority-Analysis: v=2.4 cv=efcNubEH c=1 sm=1 tr=0 ts=6a723503 cx=c_pps
 a=JbAStetqSzwMeJznSMzCyw==:117 a=j1J1DEHOHTVaJYOjuVnKiw==:17
 a=IkcTkHD0fZMA:10 a=Sv0fKeRqtYgA:10 a=x7bEGLp0ZPQA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Da8U98TiO7q1upZEImrf:22 a=79PYxaXUQd1wl-QFWJnA:22
 a=jfg2DRd2ap2c96lsYj8A:9 a=QEXdDO2ut3YA:10 a=uxP6HrT_eTzRwkO_Te1X:22
X-Proofpoint-GUID: p-5ACVRO0alEbGF3YTH6raQ1ofiVF7RB
X-Proofpoint-ORIG-GUID: p-5ACVRO0alEbGF3YTH6raQ1ofiVF7RB
X-Proofpoint-Virus-Version: vendor=nai engine=6900 definitions=11865
 signatures=596817
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 phishscore=0 suspectscore=0 lowpriorityscore=10 malwarescore=0
 adultscore=0 impostorscore=10 clxscore=1015 bulkscore=10 priorityscore=1501
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2608040152
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: CA3DF1C0003
X-Stat-Signature: eqrqnujkq14jbgan3yzqj58g8nksjzu9
X-Rspam-User: 
X-HE-Tag: 1785869572-397299
X-HE-Meta: U2FsdGVkX1/69bEgjRy1IiZxzmJGlu3l2xj5gPzf8+Imcqic+kWHYkRDQw/aPtAxqR/LX0Omn1WMiJr2uUkIXbim4ptjSiJCi9RiCsWr1IeccbR+9xxBuR0C2QOC8X1Bv9JGaeJZ0SozWwAdb5JCwljePlLnxORya+rYwa9pPkot4OIUDXoa+RcpnMfHkiPT7PnY2LtB8JWCcF0neGVWjRVZFTETO5ppzgE8JxlDCB6OfhidJvlK7Fq2aXKIHKro6M32Fik/NdNXGgJVkUNzJibHYcridfbFwuDptSA6EZCh1dNOSZTpZ+wNY8lWAHRXO/ZD3CCj6Pr8+dm36h7/TeM+Vsb9JzEOhC7YOegwG/Po4brA/rfpPegMujHZYlegZqbMtHt3UzOKTQKERpL1z/PlIsbSfz9TuQ6z4SoSJ62jRHM7Yvukb6knqYC6MbfFjem1FgdUXPDawKS30Vfmcg127rH9Dk6MUxfX1eb6G60fD1n0o5OpFi1KF9YkB4SRVfdc4M7nc1Vp2lxJuy8YFTiCN2h01B4kLWPaGB8AR9491HrwQeATTx/rUmvqTGHkuN/3yP/RlHRh6XU4y2f0L6s1CSAu4Sy8aZFIqMg08QpydFBvCRvmONn2tAdoPUdRULDiYC2ivAcdLWWTkI7a+XTmVz40h1uXnjCSpH9ut9R68zz1+1AMLV6ZH3OU83VR3VZpfXiQW5CIC0oN+aiA56/gSjMQByzWLBQrA0P26Nbvcmul4utuMbIrtISq0NafvoLcQO/ZFu42URXAkhosBWlL2XO013n9FgekzwyLVKa3wJsOv3fa0K64oE8LVevas2nZ91pZgQEQX6uuqjiEuA5PDbZMFfpilmgB9heHE7euQ+vSJcIGKagIub9Yb2ywHbfxCCHMlJ4a/sHHZIknz67fFMuz8zZGSgs+1yV1D7wgXpevUzBFExo030c+2eafRPB7JzzwjuXDTlSIfP0
 EIR9l2Fg
 xX5dax0Mx5zkvj7rc7+yr2GNHYg7iAUBjhp6Ol5O5DeQ7SzboGnI57rQhyAKHLPSrCgwhJkLvj5GB79l8MCL7EXy1TEjow6hknc4tfcIixrKWeBU51cRI2Fg7p5FK7wnOSu1h32r77A2TIq1NjVoxsO5Tyx7GAR15K+4EUG3C0hI/GkKqPZgDw6psfz6/fVQ7ydbIuqUmW0Ij6FKDLF/+qDskwxC/bjmxyPU1gp4N8pJhFow39N2r+dmL4AL328INwvtpR70jDDoZttHVViOyOjTt2VMn040i1/cGMMH6h3MWERPUQ9lf6Ib8tp3ea/fL+9lsV54i3Dzs0AXwnshqgdZdEAi+z5d3RwmJRgpzgHcEsP8N30RAI7u6hG6jq5L2QV9tIRtGoNtx+1E=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

All callers have been converted to the folio equivalents, so remove
these unused helpers. This also removes a use of page_offset().

Signed-off-by: Tal Zussman <tz2294@columbia.edu>
---
 fs/ceph/crypto.h | 15 ---------------
 1 file changed, 15 deletions(-)

diff --git a/fs/ceph/crypto.h b/fs/ceph/crypto.h
index 948c8b5dca06..d199dc8410fe 100644
--- a/fs/ceph/crypto.h
+++ b/fs/ceph/crypto.h
@@ -157,11 +157,6 @@ int ceph_fscrypt_decrypt_extents(struct inode *inode, struct page **page,
 int ceph_fscrypt_encrypt_pages(struct inode *inode, struct page **page, u64 off,
 			       int len);
 
-static inline struct page *ceph_fscrypt_pagecache_page(struct page *page)
-{
-	return fscrypt_is_bounce_page(page) ? fscrypt_pagecache_page(page) : page;
-}
-
 static inline struct folio *ceph_fscrypt_pagecache_folio(struct folio *folio)
 {
 	return fscrypt_is_bounce_folio(folio) ? fscrypt_pagecache_folio(folio) : folio;
@@ -263,22 +258,12 @@ static inline int ceph_fscrypt_encrypt_pages(struct inode *inode,
 	return 0;
 }
 
-static inline struct page *ceph_fscrypt_pagecache_page(struct page *page)
-{
-	return page;
-}
-
 static inline struct folio *ceph_fscrypt_pagecache_folio(struct folio *folio)
 {
 	return folio;
 }
 #endif /* CONFIG_FS_ENCRYPTION */
 
-static inline loff_t ceph_fscrypt_page_offset(struct page *page)
-{
-	return page_offset(ceph_fscrypt_pagecache_page(page));
-}
-
 static inline loff_t ceph_fscrypt_folio_offset(struct folio *folio)
 {
 	return folio_pos(ceph_fscrypt_pagecache_folio(folio));

-- 
2.39.5



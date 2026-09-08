Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5D792C79F99
	for <linux-mm@archiver.kernel.org>; Tue,  8 Sep 2026 15:57:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0BAB36B009F; Tue,  8 Sep 2026 11:57:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 06C0D6B00A1; Tue,  8 Sep 2026 11:57:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E9BB66B00A2; Tue,  8 Sep 2026 11:57:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id BC6806B009F
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 11:57:52 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id C01DDC061C
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 15:57:50 +0000 (UTC)
X-FDA: 85191050700.15.D70657D
Received: from mx0a-00364e01.pphosted.com (mx0a-00364e01.pphosted.com [148.163.135.74])
	by imf03.hostedemail.com (Postfix) with ESMTP id 2D0752000B
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 15:57:47 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=nbNFtHL9;
	dkim=pass header.d=columbia.edu header.s=lionmail header.b=M8QNyo2t;
	dmarc=pass (policy=none) header.from=columbia.edu;
	spf=pass (imf03.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.135.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788883068;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=NifX4Rb1WDw0wxtWlVThAQsW+jygu9Vf8Cny+Iwc1Mw=;
	b=kRUVM9kb6ZkPkuzYk7mMVWaaZhv1WEePBW0YsYRqul48GIfL8VbHD8Vf/OhK5KSQC8QZG4
	Mfe04djZsJgGNZ/lmd2eJbre2Z6lgMZe0L6FhbWv5GmW6swzsbhPGg4fD0vdxoN8RUTT7c
	6axMULyrpwHBUtzDROxdOOOW9IBZWNc=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788883068;
	b=uSlgTXs7qlhzgWleWnGVKJrwSbBPCbY7Y73Az5e9N4UdM5eyGdlEZ8fIOIIgUmAPAbYPUc
	9ukCeU5fht0yxCNasVA1AvTq78u/Mfes5dqFBcHXbDkqr+SQEt6e9a60TE5ie2U1IF1lLC
	r6KyfcVR62H9NYr6fGLBEG6QzZ2g4SE=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=nbNFtHL9;
	dkim=pass header.d=columbia.edu header.s=lionmail header.b=M8QNyo2t;
	dmarc=pass (policy=none) header.from=columbia.edu;
	spf=pass (imf03.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.135.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu
Received: from pps.filterd (m0167070.ppops.net [127.0.0.1])
	by mx0a-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 688FbEGJ1064829
	for <linux-mm@kvack.org>; Tue, 8 Sep 2026 11:57:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=pps01; bh=NifX4Rb1WDw0wxtWlVThAQsW+j
	ygu9Vf8Cny+Iwc1Mw=; b=nbNFtHL9MXnWtK26BxA1gyl68MUKnXXXxoueCQqUDN
	PlAAxqnECyGfrI5luVVHgkn5aO+soguWzHRqqKc5XoFDmbdhwuvLilMM99IFcYTj
	+JMRcn73qCpmaZ/fWTKKkSatKo8L/US1KBq7wxr/gMhukyyBM3tqhRZRDJqV+PTz
	BNPwJMOiHkFnv0ilHeV2vGi+c+rMDYMQ+GRq2EIfM5V8QkTFK6agkdniSQrtaMGv
	5nwebsxdCctFhRbY1bic7XQ+mrRjg0RVx1tPhg9fdt7WBnf0r7ukd4MtVXQdEI89
	jlgmXgdAt1/o0W4fgk24CIkvLrkWTwRHE5bwZ+V0zgYw==
Received: from mail-qt1-f200.google.com (mail-qt1-f200.google.com [209.85.160.200])
	by mx0a-00364e01.pphosted.com (PPS) with ESMTPS id 4gjmwm8bp0-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Tue, 08 Sep 2026 11:57:46 -0400 (EDT)
Received: by mail-qt1-f200.google.com with SMTP id d75a77b69052e-53062ec5b9bso65526071cf.2
        for <linux-mm@kvack.org>; Tue, 08 Sep 2026 08:57:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=columbia.edu; s=lionmail; t=1788883065; x=1789487865; darn=kvack.org;
        h=cc:to:content-transfer-encoding:content-type:mime-version
         :message-id:date:subject:from:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=NifX4Rb1WDw0wxtWlVThAQsW+jygu9Vf8Cny+Iwc1Mw=;
        b=M8QNyo2ttghyvzIGmObSTO3Cuxbz8WnUsYGRIUgr48b9ppDz/GFPHLWQRSZtcseb3U
         wgTBQ1jK0DjiuIbhC2gVuZtNpR7rwbNToBTvGECeHQAFAJT63G6dXM6cct4j1BX4Vx8+
         s1YM3QshY0JcXt7lzyE4UkVInGNvZdB+EStx8Ul5x/mTp6RuLLdY3Rp8ScjY32iESwLu
         m2fIiiRLNW7jusV0wyzmzHudR1SjdxTj2+wE/AH1aq4dr/gaJAQDuh4eS93r+ch/9bCJ
         aJORvC8rkKZK30trEvi1FQ/WD4OPsRpMDi0FiAO9+BYoALRrayoZxP1GwKlwKRsawind
         00Kw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788883065; x=1789487865;
        h=cc:to:content-transfer-encoding:content-type:mime-version
         :message-id:date:subject:from:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=NifX4Rb1WDw0wxtWlVThAQsW+jygu9Vf8Cny+Iwc1Mw=;
        b=GvV3j6hk8dfXC9P/2NycB291oymirRV4os8zJH+9oS9+QIY5PfcrndorflAx8mHKA2
         LMjjMdPly76Uz554DXg4x/gxvZalBTUon8cgWMZGN+f/mvNU4c/j4dwzC1XWsjk7Sq1V
         dZbMBhbbjkrtU30o3UqWPmqLYN5PztHnc82IN0Gpv2++o564Piijpy81N9VuikB/Dcs3
         gEmjw9K8fg8ubsRoN48DHpJcUb2XNGWoSiWkVyvfGHxbHpuPZqmKM90hMkJXa7kC8r7u
         RBOIx4nxuAzfgeFXfaAagagnsh6LgoguTZyEPfSx7WN1tp4lvM8lIW38t52KqMdOZprm
         jwrA==
X-Forwarded-Encrypted: i=1; AKwUvBwjPC5LGqZ2E0ftTyuxL+b/TfzyhcCF7ZfVWoCtSXQOIfngnUo1gWQgJKAHDeEZee/rGPjVsADOqA==@kvack.org
X-Gm-Message-State: AFuF++kK3u6IP9j2w0KXdyxdjn25wfFKrvo6yuHGP7luz20D22VYN8r3
	nwPZbj6zGRNPgDduukoiDTLXig/wcUvi8cT5DDU9Fha76NVx5Jz76QBlLtyRhkssTuvI+hyHs4Z
	rNNJZzru047OijmZqUs3lU8clfPi+SEiJZk7BF27opyCCabyC
X-Gm-Gg: AYBFou2UTlcv1hADboIpOIsP4ZDKPAqCodwogNo0bOATV6kAWVz6pIliY9v1pKWnRxZ
	u8tpq4lLbXKe3jdSMvEd46jXdgOWr/x2ysJdRjGc/byZtfI05XIQhvSOsHPQdANp2Jttt589Sob
	D2CewPsWPg7kosprcm82kSz0dmQJKiH1CizK1jVn2NtLzKOos9Tu0Ar6plR09TCmIOqk/SxPVXh
	Sy+dR5FIcQOwiNlRhks5L5l1N/2zsMNJTxOyLLt4++ka3Xe8RgKpGgQVuIAeVE7SgXnxBWpcq3M
	jUNEUy8SPMDfvsB1JuoMscJh3opADGTPOwUNqdTWuwFjKrXezCJiFdDYZGhIh7jnNVs96FB0bWO
	YMk9m9d+pEieUYUbJv0pQu14NldtadUb1sXCcj8rW9wnmx+bQ
X-Received: by 2002:a05:622a:134d:b0:52f:f072:a1d1 with SMTP id d75a77b69052e-53054819272mr349899241cf.11.1788883065106;
        Tue, 08 Sep 2026 08:57:45 -0700 (PDT)
X-Received: by 2002:a05:622a:134d:b0:52f:f072:a1d1 with SMTP id d75a77b69052e-53054819272mr349898481cf.11.1788883064429;
        Tue, 08 Sep 2026 08:57:44 -0700 (PDT)
Received: from [127.0.1.1] (nat-128-59-177-174.net.columbia.edu. [128.59.177.174])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-53093295584sm27830461cf.13.2026.09.08.08.57.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Sep 2026 08:57:43 -0700 (PDT)
From: Tal Zussman <tz2294@columbia.edu>
Subject: [PATCH v2 00/11] mm: memcontrol: constify the read side of the
 memcg API
Date: Tue, 08 Sep 2026 11:57:36 -0400
Message-Id: <20260908-folio_memcg-const-v2-0-811e9f443409@columbia.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAHAwoGoC/22Nyw6CMBBFf4XM2poyqYCu/A9DTGkHGAOtaYFoC
 P8uj63Lk5x77gyRAlOEWzJDoIkje7cCnhIwrXYNCbYrA0rMZCFzUfuO/bOn3jTCeBcHoXSWk5J
 WFZcK1t07UM2fvfkoD45j9SIzbKHNaDkOPnz30yndvKN/lfinP6VCCkKTWo2IKrN347uxr1ify
 Y5QLsvyAyiWWWDHAAAA
X-Change-ID: 20260807-folio_memcg-const-4a67e40d485b
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1788883062; l=2237;
 i=tz2294@columbia.edu; s=20250528; h=from:subject:message-id;
 bh=hj+Nv0WF1d95Gjv7TrdlCtnL4rlx46A03j7UOfRM5nU=;
 b=Eq+dpJKvk9whXLlAXSzv+mq7m+3iea9TQG0LeUDcbezPns09wXcAvBEa2NVPavbZ7BAUmO63Z
 PSK81m8Ob4hBtmnLts5McXIWX4J153hefwW3tg14Hbs4ZiWO0dXw4fN
X-Developer-Key: i=tz2294@columbia.edu; a=ed25519;
 pk=BIj5KdACscEOyAC0oIkeZqLB3L94fzBnDccEooxeM5Y=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTA4MDE3MiBTYWx0ZWRfX/1vkufQLkNPn
 3Iw2o2PooRxPRpEDxpB9YowTp88Q63B+oUbbQDrH67c62lZ5vtHF5x7ZZMZDnbQ6a7QDukxuyEC
 J9bpC2GpmB7oHcoMd1EUwE1Jso8jYtojenNtH46fMck9lmRRiBl5L63J/d08vcrvMqpw29FVKP6
 YD88MDtmworeWGUpuwR6wzzSAD1ydF8GFhFp/uytpVHIgA1jpbYJXxmZe1pp9cjA3IDnoBI062q
 ku9dEO5rSJfQ8eetzUI9ILtt2glW/oCwLNY4fjcNaoW6xsDXsUdK1SAL5fralxPdJVeNLSSuC/z
 eRUvxG7nD2NmqzN8rHJYxQd+hblwcYItqtVuteBMHKk7j9hngDm8/0VjIMlVwDnVtMjFmUABrtx
 VPZTpiNNG9kJzNlGDLCxPf6TNQx5AllMUHkKSlExuBnpRl2jgD2JSlt/c8pjSraHQ1NIQg6+jLd
 dGOuPAjgUBjHtZlh18Q==
X-Proofpoint-ORIG-GUID: I3g0r0IcZ272iQxhXP6GdubX7vxogW78
X-Proofpoint-GUID: I3g0r0IcZ272iQxhXP6GdubX7vxogW78
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTA4MDE3MiBTYWx0ZWRfX7Ra+n3ulXoGe
 xl95zbTLFnWOEDOuC11Bi6GCD0KiRVQF0U4SfWalNlmu01CAu09vttmL19Vi1MW/kLK0nidxdZW
 SON0NanBQQ6VvwcOeYeNy+qRrKXEQtmDexG7S7GzGmxB3IbI0I0R
X-Authority-Analysis: v=2.4 cv=JPELdcKb c=1 sm=1 tr=0 ts=6aa0307a cx=c_pps
 a=JbAStetqSzwMeJznSMzCyw==:117 a=HBUb3goEnnz3w2smY6d+Hw==:17
 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10 a=x7bEGLp0ZPQA:10 a=A0y_DWxS2BwA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Da8U98TiO7q1upZEImrf:22 a=svvvyxlR1OQQkelhaPoB:22
 a=VwQbUJbxAAAA:8 a=JfrnYn6hAAAA:8 a=bC-a23v3AAAA:8 a=b6ln72opZJ-VCPk_GP8A:9
 a=QEXdDO2ut3YA:10 a=uxP6HrT_eTzRwkO_Te1X:22 a=1CNFftbPRP8L7MoqJWF3:22
 a=FO4_E8m0qiDe52t0p3_H:22
X-Proofpoint-Virus-Version: vendor=nai engine=6900 definitions=11900
 signatures=596817
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 phishscore=0 adultscore=0 lowpriorityscore=10 spamscore=0
 priorityscore=1501 bulkscore=10 impostorscore=10 malwarescore=0
 suspectscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2606150000
 definitions=main-2609080172
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 2D0752000B
X-Stat-Signature: kquab1bqu6igroix7q67nsac1t94gucd
X-HE-Tag: 1788883067-237744
X-HE-Meta: U2FsdGVkX19k/RHMg+G8Cd0WFr1Jmbjx7k396+he1KSP+3ljjAh2JWJqMbYxz0xWobYOBsEpdHrsK0HsNtO3DlGBY8cvGWazE/xAR9ucZKkSsTfnsJ7la286VQa4TLpPsz5y/KoEqOAtTr/nhhstaFcd9BmylvDozLKUl/5qqhinKZSdiufcLB2FHAxA6bqaiOOACN+YQilQbLxe56aYbYFlqJRYz896cZwZJE4JB9UZoNvs6lFH0/+DIN6WQhMoYTd+uZAeGFYmCRozN3uRwL9r27g7PtPkhYJYdKeSGnBhMoEc42ujZd6f0CH08CJH2ksNibfUXCMeWvi/bZCsKbZg/OqnoGxbpVt9VvSrYyXGPn3CjHyNmGsWSEdrd7dn80SAjv/wQAW4OU2c4NLrRVcZdYrnfkIdpuU9Rxls2iWBkMA9H01RGlqS6e83Xur6+bZZoAK7aKAxKxkHyeT/verap6vAzufD4Fa2NNfZ/Mg6wF26sPH/23oUNx6M1wADhqwHzBuhmWdj6rpT1hE+P9wvuo+8kmasyTYGDDMe3zLAozNlZAToV4eQUyzE7So0DDY+4QwKQzXM6+LTxJ7Ju5fFf5lx2re8x63Tn9ScQ9YazKeWJa8zYo5fjVW9FB9NNteE4daT9KK0gTUN9ffUS6mbd1CIgdBhyYnRaj5ryP4Wrk9ny/VOEz95uYmTwIB7Cjb332o9tDPTlBhL0ynlGJPBNcUiw/SoHnwBvKiGXyT2fFvaN1E2/kdaJbBMy7V5JsV4yBzT8YCVN2o9b+r3OohKZQyOPr1fGD9mk/UBsptLEQ60RzBQRJSNeAVSegmIFkUoV6L5XtBNDAGjOtBIVE04OEBzp0hv/yskT/TiqZOhNOJm76qdk3TLqfKAZitTNlrfJu1Gq+glKWPp4jjQo7SSy6d2MYw+W1RZFruM8LFe4gla34Odush5JLhFGAOi8Vsy+iIlsrdCNJXG/Ao
 dhHKx0ob
 F5IjCGn41mUelOQA/lD1zYPeC9x0V0wPniSpdc2g1Q4x9npVBwKH9uv40bHnLeL1q78hSqFgP37LEPbSuxndFH3cFY5hfwnrtGF19541eHUm0a6y5rI0zdS1cRXNPtzCvZgkvYEkfBCb/uMbnuYSZvFuklz8E7I9ymBjwrVlLhon81wVggkn97rLjkGeJ3m5tHTGxxcxSO99klHotAbTPKY+usfdX59TuPS0AGKwgUhCaj8iTfI2V0CepPCJIdBGbnvk65rrc16gbh/VGnbokwxGBiI1lfAfPnipTzOSKA+EQ2kwc7omdoYVQcT6n58GrPwOqNtJ9yF+aP520boPinKCjl3s6PSKyiGxvkMSASDCJNR4SHRMjMWt7y0AXRyj5MDVFDoHYZh2HDQoH1TSwyqZTbZQpf0d1NjF794+Dc/w32JUBer8oo21G5+7iKupTl6rSfhcXXrVEVb76vUXCduhyxYaBgveRWY7s37iFPTWIn+wgOXl0VGuDgCcsZWyNaWIl02AO9NkY4Hgn1tZUqYXHuxmPJ06U5RJL
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The memcg accessors, lruvec helpers, and stat readers only read from
the memcg, folio, or lruvec they are given, but take non-const
pointers. Constify them, along with a couple other helper functions in
mm/page_counter.c along the way.

This started as a follow-up to [1] that quickly grew in proportions :)

[1]: https://lore.kernel.org/linux-mm/anYqSDnC2BbJXv1h@casper.infradead.org/

---
Changes in v2:
- Patch 3: Constify the folio argument of folio_lruvec_relock_irq() and
  folio_lruvec_relock_irqsave() as well, per Sashiko
- Patch 3: Note that mem_cgroup_lruvec() updates lruvec->pgdat in the
  per-node structure, not the memcg, per Sashiko
- Patches 3 and 8: Use container_of_const() in lruvec_memcg() and the
  lruvec_page_state() family, per Sashiko
- Link to v1: https://patch.msgid.link/20260902-folio_memcg-const-v1-0-e2c1da22246d@columbia.edu

---
Tal Zussman (11):
      mm: memcontrol: take a const folio in folio_memcg() and friends
      mm: memcontrol: constify obj_cgroup_memcg() and friends
      mm: memcontrol: constify the lruvec helpers
      mm/page_io: take a const folio in bio_associate_blkg_from_folio()
      mm: memcontrol: constify the mem_cgroup accessors
      mm: page_counter: constify page_counter_read() and page_counter_margin()
      mm: memcontrol: constify the reclaim protection helpers
      mm: memcontrol: constify the memcg and lruvec stat readers
      mm: memcontrol: constify the swap accounting helpers
      mm: memcontrol: constify mem_cgroup_swappiness() and mem_cgroup_get_max()
      mm: memcontrol: constify the zswap and socket pressure helpers

 include/linux/memcontrol.h   | 204 ++++++++++++++++++++++---------------------
 include/linux/mmzone.h       |   2 +-
 include/linux/page_counter.h |   4 +-
 include/linux/swap.h         |  12 +--
 mm/memcontrol.c              |  49 ++++++-----
 mm/page_counter.c            |   2 +-
 mm/page_io.c                 |  14 +--
 mm/swap.h                    |   2 +-
 8 files changed, 148 insertions(+), 141 deletions(-)
---
base-commit: 9d3243fc689fef444f87e0a703b4c99653137e1b
change-id: 20260807-folio_memcg-const-4a67e40d485b

Best regards,
--  
Tal Zussman <tz2294@columbia.edu>



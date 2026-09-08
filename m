Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 534C3C79F99
	for <linux-mm@archiver.kernel.org>; Tue,  8 Sep 2026 15:58:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 242436B00A1; Tue,  8 Sep 2026 11:57:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1F3196B00A2; Tue,  8 Sep 2026 11:57:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 01F086B00A3; Tue,  8 Sep 2026 11:57:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id B395D6B00A1
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 11:57:54 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id C1DC2A079F
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 15:57:52 +0000 (UTC)
X-FDA: 85191050784.09.6F2F4F7
Received: from mx0a-00364e01.pphosted.com (mx0a-00364e01.pphosted.com [148.163.135.74])
	by imf19.hostedemail.com (Postfix) with ESMTP id 1F4421A0003
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 15:57:49 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=j5I3RNnU;
	dkim=pass header.d=columbia.edu header.s=lionmail header.b=Ujij0ukl;
	dmarc=pass (policy=none) header.from=columbia.edu;
	spf=pass (imf19.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.135.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788883070;
	b=NI0OcdbPTXW9KHQypQvz6XcFRq7XhEqmXvYyXBrFaxWccn1qate9FcuJF6NWaTlQrPJm0i
	heOyWPdCpW0CFAox+KEvf3QsRRkMovFA94O0sPwbXJuxQQdKBxdNIES8KTfeKHy7FUpBZ5
	WyNOBILilU/PJRBC3PZeaUGu02SNcbg=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=j5I3RNnU;
	dkim=pass header.d=columbia.edu header.s=lionmail header.b=Ujij0ukl;
	dmarc=pass (policy=none) header.from=columbia.edu;
	spf=pass (imf19.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.135.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788883070;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Sj1N7uQmnGuNNgPkBsDb4ODo0/fNYM3Wqy1K3HrTKe0=;
	b=ZHmaXgZjpU5ilTlodworZ007CqmCp3gGegyqrY48xZKIe35ZX7RMVtNNYYY3tTxerISWWl
	eBz0cOiaq6+nGKRj4p5ZWuhhEU6vIVlOi+AxpZWVagrk+Rs6+78ottl/C4k9dYzQr0eYgW
	vpRnWJvvrQbqyHkwcmIyID1GAhKJDuA=
Received: from pps.filterd (m0167070.ppops.net [127.0.0.1])
	by mx0a-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 688FbE3A1064819
	for <linux-mm@kvack.org>; Tue, 8 Sep 2026 11:57:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pps01; bh=Sj1N
	7uQmnGuNNgPkBsDb4ODo0/fNYM3Wqy1K3HrTKe0=; b=j5I3RNnUd0MS/NrBD70/
	7/0lxzZFw4VWhZUt5gKhJhTsXfcBODPPBpAPpLwSDYoMJ3FtHN8uv4vm8U/ysa4e
	BsrtRO5j6SnD6XyQ+SGNHtJVIio3TRJrr1P4tEwsiZz0CxLKFQ5stdm5FHyMnMKM
	DVovccz0GsgurCVgVaU4J8Ra+Lk/BeiFTqCHBYrtRuczzJF7MYRk3sVtq8+Bjd1I
	LRTDKqbsck5PGKZ9pxJcB4OEEEwc7ajMyOF4DyE4oXu9Z1lbcrz3Yi5GYQx85wQr
	m9iDedE80zhRJqA7Ow8137cQTfR+u+dnICd7WduO4Qk7G2Z34E2zvM01wBFSJOE+
	Ew==
Received: from mail-qt1-f199.google.com (mail-qt1-f199.google.com [209.85.160.199])
	by mx0a-00364e01.pphosted.com (PPS) with ESMTPS id 4gjmwm8bpj-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Tue, 08 Sep 2026 11:57:48 -0400 (EDT)
Received: by mail-qt1-f199.google.com with SMTP id d75a77b69052e-53062ec5b9bso65527001cf.2
        for <linux-mm@kvack.org>; Tue, 08 Sep 2026 08:57:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=columbia.edu; s=lionmail; t=1788883068; x=1789487868; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Sj1N7uQmnGuNNgPkBsDb4ODo0/fNYM3Wqy1K3HrTKe0=;
        b=Ujij0uklf5M9Pj45dw1Jpgp/rX7Vqby9LFrRUbt1TL9yo9pvITCcqmb74iH60ajLCr
         MUnelJ3r8it8Orppt5MK6SIWrzcWtuzaDSQQc0nUPjnA8fX5JESEWWphNB45n2+/Klkv
         HCA4fZcOupZQdSUqsTXD51mEyW/noaif1MgOruONTFK6N4G+s7QMmhY8UGkMofGazKsc
         AJKOtRWSEg+fZCWSBGtRbGuxUeTVOzFk2gh1QzljC7mAkgxEl0PVwEb46K2rCOnINeZ3
         rOdEBVNUvdEP7atNWTz/V5Kepifl8uqxiZvA1ahLrgfN8iZJgfe2NIbXA3PNK0p/dYij
         pE1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788883068; x=1789487868;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Sj1N7uQmnGuNNgPkBsDb4ODo0/fNYM3Wqy1K3HrTKe0=;
        b=dyq5RhnofTgFwLRhKDx3ifcCPAJ5CRZo8Ykz/PVFYjOxqajPC8DzHCSkeEW+JQuXvM
         O5K0AzTLAruVb03upw8PatgdxeYvZX1IgUgB7eqNrmOpaGxOSXLXk3jl3dQp8sPQmuu2
         0eUxF6I6rFkjhXEHzZIEAvGv2mcmEnpz0qYfg0oaYVvrAYb5jIPFifzslgoYEQgjQ2Vw
         a+nBWUMeM8LikIRwClkmECpKjZ31tVp1VN48FPlD3r7sRGcpu2CA817q21p9nRG0srOV
         6t0tvwdzfvHKdvJq4h5KkT4iyMxLYALqNnTyIkVvvljrwhtzkwJ/dlhdqmFxfqXd1Pc3
         CquA==
X-Forwarded-Encrypted: i=1; AKwUvBz+TZDYQkL0V/pQNFk1NNZ13is1A/pXuHYMFMvcVhddNgma4SLwClafLfPK5xLSFakCIkvEykdPnA==@kvack.org
X-Gm-Message-State: AFuF++nL8HEke/1gcwdPiG2SatTJPV70j6qXaxgZS+w1WhZVyoPwug/k
	20JjS3tliSZn+1bpe1AuUy+0i7IRQf24ap2g5egKtNiPRwmyDopcdgZmb9VSSst+uouFEW1geDq
	m2lsaRhM7PlrGBPB/AuKcmKosfuzsYP04ql3WDDQHHfT1UPou
X-Gm-Gg: AYBFou1zF1lwANpYf/uaSQk69BifEFwQClH9yTwoA0zx7GT0dhFU/httBXd6YwkrM8O
	j6MIEGG/Qo9p8zWO4lf0H22Fjy+w8L96OFKyorhqaXVfT3COilWmgkwZSAnUciHmdT8fO+O01Yv
	hs8DXr9+TCVElqGVoENgm3FY6Gc1WJdCg2qaSXbf3Jg1g05A2w5nys5koFi/J6kfPm6Rj1p7W4E
	iiFIF3jJSDkOc/E97/jeyBOLx6trRD7XG4ftK0xsQ8brLsKer9Yltx6tSCAUbDMsqTPQVKPulc/
	kxV1d/DLmQAa3Zg9AAL9PskXYdJtdYSk3NmsX9VsY1th9TbPyU/5MdL6N8j+tLquODuHrWULZ9H
	K0tFcuJs+bY7hCqjTRFaxgGAOzh85UyXr8sMmPPp4BH8TYgpV
X-Received: by 2002:a05:622a:261a:b0:530:7bd0:72a7 with SMTP id d75a77b69052e-5307bd074e3mr207354411cf.14.1788883067573;
        Tue, 08 Sep 2026 08:57:47 -0700 (PDT)
X-Received: by 2002:a05:622a:261a:b0:530:7bd0:72a7 with SMTP id d75a77b69052e-5307bd074e3mr207353371cf.14.1788883066890;
        Tue, 08 Sep 2026 08:57:46 -0700 (PDT)
Received: from [127.0.1.1] (nat-128-59-177-174.net.columbia.edu. [128.59.177.174])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-53093295584sm27830461cf.13.2026.09.08.08.57.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Sep 2026 08:57:46 -0700 (PDT)
From: Tal Zussman <tz2294@columbia.edu>
Date: Tue, 08 Sep 2026 11:57:38 -0400
Subject: [PATCH v2 02/11] mm: memcontrol: constify obj_cgroup_memcg() and
 friends
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260908-folio_memcg-const-v2-2-811e9f443409@columbia.edu>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1788883062; l=1873;
 i=tz2294@columbia.edu; s=20250528; h=from:subject:message-id;
 bh=UinAA03uCLSDnqTeuLsKq7N1uV7CWB3kv6f1gByAtp4=;
 b=CDRAqj/1wb/3WnGAi9BY4rxHz8UgL120vcouDu/S7bC4uAUypmncBBwZxrKy82c8EXPYIfw5t
 qSiBFt4YV82DeeoHQG/qc3T/+N2P7kl5zdw9sNHqwNj+PrDkLIAp7LE
X-Developer-Key: i=tz2294@columbia.edu; a=ed25519;
 pk=BIj5KdACscEOyAC0oIkeZqLB3L94fzBnDccEooxeM5Y=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTA4MDE3MiBTYWx0ZWRfX0CiBEhUHQeCg
 6DfHbRZyHQXIFWZHIxhWRALIMd27sSbCcM8k+zQpTwm+EgP8v6cb0AUzef1Vf/Bn3sRPTXr2QcV
 uEPVrnTwI/QqxyAEHqHNl85jQ9OvNEaQijYfn+fQJBGdwcps1HymWzIKFWpHAS7LgJ5oQr+vYKX
 8MQ8KYK0fq9XbIqy/y6Tf0wa8tHwIyayuxFSWL8qMs4dYBMVcxx2AidValEtjUxVRcZQeR1AloF
 J8mr5veSQzwOwrbmdr21/zJ2jaxBvmpxGb9jv87qPnV7SZ4QocCI9Sah4NOD3Toau2pK0mm610x
 ufU77McIm6/MZARJEAmwqvEmYvTk73MTvRx4VDNgrtvGvas/p6fY6AKRNwZoEg2YYeBNRVqSMwt
 YyLgDB6/JbYUdop57TE3B6fWQS1S2Ugs+Up/7S2KiN2ACcXBYkyaTElC65UreAiRYqu2YSiMlU/
 vJR1AlCQlhD7a9uqdYQ==
X-Proofpoint-ORIG-GUID: 6p6sjIASqva7jKcMKN2fn9_8yOyrm6jD
X-Proofpoint-GUID: 6p6sjIASqva7jKcMKN2fn9_8yOyrm6jD
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTA4MDE3MiBTYWx0ZWRfX1iUvR34KKhIG
 fDnMrh68I69p6ypIBL4xx4DRSSVAccRRPBj0xY+sFdhWVX1mAcEckKiZqZi4NvkZG99ueI39W7s
 +egAUW1S9CSa0FrY8hrx/U+J10wmOUH1lfaDzRlzl7gr+PQTsOgo
X-Authority-Analysis: v=2.4 cv=JPELdcKb c=1 sm=1 tr=0 ts=6aa0307c cx=c_pps
 a=WeENfcodrlLV9YRTxbY/uA==:117 a=HBUb3goEnnz3w2smY6d+Hw==:17
 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10 a=x7bEGLp0ZPQA:10 a=A0y_DWxS2BwA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Da8U98TiO7q1upZEImrf:22 a=svvvyxlR1OQQkelhaPoB:22
 a=HbpFEVrQSsppjrtFf58A:9 a=QEXdDO2ut3YA:10 a=kacYvNCVWA4VmyqE58fU:22
X-Proofpoint-Virus-Version: vendor=nai engine=6900 definitions=11900
 signatures=596817
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 phishscore=0 adultscore=0 lowpriorityscore=10 spamscore=0
 priorityscore=1501 bulkscore=10 impostorscore=10 malwarescore=0
 suspectscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2606150000
 definitions=main-2609080172
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 1F4421A0003
X-Stat-Signature: egdnr48jrh6jn3rm1rrerr5atx91tniz
X-HE-Tag: 1788883069-37275
X-HE-Meta: U2FsdGVkX184qzJnZ1/kZr0YiSWsYhTG5rHQgO7GjGlH2k7oKrcTix5UZIov0CGuL++UJH758FrJ9z6pbrePHNyknXQV7sjfMSEqvTHp3Auz7wMriKuuHWypheywberwHyt231Ec/WlyG6JrLeyvJHeLAQd/nl/Wb2vGijNe5Kb+QuAjPD1IZZz9S0pbzVnJV/qpzsy8kP7a/Rm7qfWJ61oFf+ilVHJsUzN9MEUp2B76ckG4e6joHUHecTKIS7LpzTPEsIAZvs91lzoK90zb0SqEybsaqlAW09sMqHFbZyI7868FLWMUSibb9OVp/4M919iy+LkOS/x1YdB/0DfkK/l94y1oDjwJ36NLEPheS+hWmOR/cciK7MIV8r50xfpZr1xIZv8eAQx9HAJW1h1dFnIgjAkhSFcrP7oLI8VVktCc8dw7c5GHPRbFWVLDW+wwRiHiBCnWKbQuHbDakrlc+kr5rG5G28gjnGZIvzZDWhqGUS07bWfOiMbuD0eB5EytJ3iXYANv/q2kLfWcEV0QOEL3w0WAK8UmWZXqa0AAxu4nqfw1bfQ0l/GpniHJFqGfC9kgUtS+BTfGDzslBpZ/N4dflu/bNzqtWx/Bfj08QxkJUJqY5MX9H3Tyg+K41iB6GNKRmseZi7ZKwV/jAkJDjBjhYEmU/kBTzAswz4mHpvFHYXB0FAKaJ5CH+XpsbXQ7cdWH2qpWGd9cIco8bMkv0p/xfL31iMSZxpyqqclQnZWEPIrHkYwEMuKgUJ/PfISguZY+rSAnMLQ+eixfxNcp4ag8877myaE0aKothu6ehPH1J0khZEmIJSuTpbZwY17ZgIixsMB8e7VPxr6uqfkLuQegh2T+/CmsCMhvgyw8LvwCobYjguM+YGsxCBeKCW8ZpK+m0PTwIQ0nZa4nmFxOupZk3KQfZFpOU+58QYFRWkIuRVQmYIrXq6Vm3OmBnZq1EAvvSL0Z0zwl/Vvh4jl
 79/Ig67P
 7fjLBtQ+p8sqMw4tFipMxvKkd+Wtx9coyqiXwtAfV9Mx7ivvInYDLZqmUbZRmrmNtHVpurfTfJv594OpBZxUUILtYdva+3STxBwwNnBuxvs9lxUQdr6n4s5EzqRXfgAfzvxTbosi/MiN48LvbnoTGVerbBJalSEzm8esv78CX9bKJz4o83hm3it8Mm42T3/mec9uUYj0ovAy5imeKB1DjSxFAd11xzVuHSDqyWA7vOE/MBTb1dmg7o+qGbLHzcjAtCmy31yydmzv+msIyP5W2y5scWCEenj9xzhtBWhu2+wMkb+LCHww1ZlcJ5ROmj8wZdbsaUkXEPILPOn3tf0o6VTSkE+zSZFIS1FJJhjEuUE8T5xL4ptxgUJr2jKjyWxNm6pf95Z03//FkeJhkytfz9FqXEtURt3c6wnVi2g0+aujZuPw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

obj_cgroup_memcg() and get_mem_cgroup_from_objcg() only read from the
objcg. Constify them.

Signed-off-by: Tal Zussman <tz2294@columbia.edu>
---
 include/linux/memcontrol.h | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index 8a614a36c05d..d2577a064894 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -396,7 +396,7 @@ enum objext_flags {
  *
  * The caller must ensure that the returned memcg won't be released.
  */
-static inline struct mem_cgroup *obj_cgroup_memcg(struct obj_cgroup *objcg)
+static inline struct mem_cgroup *obj_cgroup_memcg(const struct obj_cgroup *objcg)
 {
 	lockdep_assert_once(rcu_read_lock_held() || lockdep_is_held(&cgroup_mutex));
 	return objcg ? READ_ONCE(objcg->memcg) : NULL;
@@ -505,7 +505,7 @@ static inline struct mem_cgroup *page_memcg_check(const struct page *page)
 	return folio_memcg_check((const struct folio *)page);
 }
 
-static inline struct mem_cgroup *get_mem_cgroup_from_objcg(struct obj_cgroup *objcg)
+static inline struct mem_cgroup *get_mem_cgroup_from_objcg(const struct obj_cgroup *objcg)
 {
 	struct mem_cgroup *memcg;
 
@@ -1075,7 +1075,7 @@ void mem_cgroup_flush_workqueue(void);
 extern int mem_cgroup_init(void);
 #else /* CONFIG_MEMCG */
 
-static inline struct mem_cgroup *obj_cgroup_memcg(struct obj_cgroup *objcg)
+static inline struct mem_cgroup *obj_cgroup_memcg(const struct obj_cgroup *objcg)
 {
 	return NULL;
 }
@@ -1104,7 +1104,7 @@ static inline struct mem_cgroup *page_memcg_check(const struct page *page)
 	return NULL;
 }
 
-static inline struct mem_cgroup *get_mem_cgroup_from_objcg(struct obj_cgroup *objcg)
+static inline struct mem_cgroup *get_mem_cgroup_from_objcg(const struct obj_cgroup *objcg)
 {
 	return NULL;
 }

-- 
2.39.5



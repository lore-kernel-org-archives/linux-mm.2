Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 59069C88E77
	for <linux-mm@archiver.kernel.org>; Tue, 15 Sep 2026 23:21:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4350D6B009F; Tue, 15 Sep 2026 19:20:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3E4A36B00A0; Tue, 15 Sep 2026 19:20:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 286D86B00A1; Tue, 15 Sep 2026 19:20:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id EB3CF6B009F
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 19:20:43 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 539401405B4
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 23:20:43 +0000 (UTC)
X-FDA: 85217568366.10.33B7CEF
Received: from mx0a-00364e01.pphosted.com (mx0a-00364e01.pphosted.com [148.163.135.74])
	by imf13.hostedemail.com (Postfix) with ESMTP id B06EF20004
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 23:20:40 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=BrVYs1NM;
	dkim=pass header.d=columbia.edu header.s=lionmail header.b=MWguK7nh;
	spf=pass (imf13.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.135.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu;
	dmarc=pass (policy=none) header.from=columbia.edu
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789514440;
	b=JsXiW3Uuki0d2opT3yV4kVNfqKB6lBSG/xkYhFHmtcVzch5dS84Es5HWASWhPVpqDmNkwd
	5iY41Ttv9PlYnzdbAlWbYuGAFdomsrbMv5nY5vtrYyWVEAk53HN5J/Br8Gqeu6BmunlQEl
	3Dn3JpgBCng0SB9NsVe9Kxclp/j57Bw=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=BrVYs1NM;
	dkim=pass header.d=columbia.edu header.s=lionmail header.b=MWguK7nh;
	spf=pass (imf13.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.135.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu;
	dmarc=pass (policy=none) header.from=columbia.edu
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789514440;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0v7j5xbCjC/R2t86sIxx8y87XGVXaehizjaj2Q5S50U=;
	b=KY0fDOF65KDz+JTK+X6OZZqwBxYj9Zd9IHryW0/bFGX/2QhGboL5ijf+RMNy/IDjmB5+hb
	FWxrpNgG/sIufyrIEIXFJ3696jBj6Z4tSlYN1GLtuaeG/L8rd6mtfLNWbV59ZgGNJL80Jv
	RQAIqQq1FmfOXr5zfxdzslX9xxUGmEQ=
Received: from pps.filterd (m0499199.ppops.net [127.0.0.1])
	by mx0a-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68FMbOvB2692876
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 19:20:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pps01; bh=0v7j
	5xbCjC/R2t86sIxx8y87XGVXaehizjaj2Q5S50U=; b=BrVYs1NMaZZGfupVL8/o
	I2XXxeOWRwH1ui7kzucUwQsOgPtFfFOvMu4CsxpUvCkarLs8g0wRAcKdeugGJyAx
	KGFk6THEL4SVIQZaQouxivpAYeuwAgB1PMAsEvWqQpAiSOQdjkybjvzFc5ObFZzU
	ERnOWeH7Ke6o7KbQ+12CqNSgNrlBho5/Y5ptjJ81fY1atYIy9JTGdTflgIPFTGi2
	ht4dIC5+V23Jc49dyMCMarl3pH+7L0lDqP0mEpagqAeAPJZCIUlAgwFOHuo88OO6
	9piJF76yQP+tYZtI/9X11QktRCPElr7cGkwdx9Q/BKeSMI800mi8Z18wLUm4y+cx
	gA==
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com [209.85.222.197])
	by mx0a-00364e01.pphosted.com (PPS) with ESMTPS id 4gq9n5uj5m-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 19:20:39 -0400 (EDT)
Received: by mail-qk1-f197.google.com with SMTP id af79cd13be357-93a0c7126e7so585588385a.2
        for <linux-mm@kvack.org>; Tue, 15 Sep 2026 16:20:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=columbia.edu; s=lionmail; t=1789514438; x=1790119238; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=0v7j5xbCjC/R2t86sIxx8y87XGVXaehizjaj2Q5S50U=;
        b=MWguK7nhFLZFRwySMucN7/ytQyFThLGcYk9Kq7PC+Gote2JDW1gBjbDBnc2xrdkIMA
         BhXrQRN50vy5y8Ts2Gn+CBCfmZvy8nW4CGkE2PyYX48aw9HywKFodvfZgqH3AXxwtrwC
         NAEdZzck2qgTGyzM6EohkKQ3wYouQ54/x/PsLhPNf6ZwC5dpLRPbcX3OWJIh9gdAlMzI
         HjW7rmPJr5gOFbr0TJVqU+XHwBYZaOaxKOKMlNRUmfJJrL1SITcoiHhIiv+nb+mysabm
         BZdtkx5INEw+J/g+AuOQmXFCG9lcsKTvrFX0ux9bfjlHX+26Yv/P4L4tRbEXaXnzuZ/S
         Okog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789514438; x=1790119238;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=0v7j5xbCjC/R2t86sIxx8y87XGVXaehizjaj2Q5S50U=;
        b=fXNPucy6CzCDfhqE7AgxjEd9der/LN2x55QtQ/yie0pmXundFHNDo589LuwsgjDiNq
         MOayBiqdBUYlW7QS0uOfUjFBu8Hn3lbtEUR4NUeFmLdz+xFIYl+RoENVKUiQvG+laBzr
         BL82WaZ0bJPrRMBaoX4kgkwKRCWoqTmMy7IsY8VT0rZgKohgzhEPQUBl5+pFxAJ4SuZs
         UgVDRK+tT55mMcqoldK1I+Uxu0/Usvb8lxCrPOTieFoOO0M629PiUTqzZCpoCbr+BZwp
         +IQ9EG7+9nxrxtML14+mxfaZ+/oMD3M3p85SF90g+CLx3eBCx/NyheBuC59/z3S0x+VX
         u6zA==
X-Forwarded-Encrypted: i=1; AKwUvBxH96DMexanLZ7aoMwiy3BLUb5pbQjbEZZgnC0Vg+73q8TXNuDTa7riq+xUwaRrsXmMQy9H9eRLrQ==@kvack.org
X-Gm-Message-State: AFuF++n/fMh8og3uwgXbkSn2HlZgH5etJxlrgdBBuu5Pa2Q34yWwE3Iz
	bGx94QeUcrQAIf+tBpl5vWPFkZRsGTQpdvdM1QQ6MmvN1rBEgv6YkUpVVaqKtciN69SQAlfrvgL
	CILlOhTWV56bxg+DSvTInoU+Ja8BAVoKnhZ9PzLjK+rYQKYCd
X-Gm-Gg: AYBFou05G6ycr+ux1NeDlsyLokB8h0IVBrE65v6TpkyHeUqTPwM9WkW7K2VeXIAyqMx
	H/uOBAAtG0F9qbzJPXyPlQiWN8z4ogx6ZsF9ySgI+LGpumfYWSS2g2/9DXyOa3pncVqC4YmJmZR
	G1fZOpStF2UP8gnNw9UoMlusu1bso+SSBLeOVCei3uZX2YkHH0OULzl0fPu764D1s2dqL5qqkQi
	xNMgZCjpJm1gXFhcsZ8hOvXFHm2D1PJu6IQxOFHXYxp7nApmKpgZhmmke2tQu+X4V4qBnd4wcjV
	wSRA5sCAKE6H7B0S2r5mruM+LN1Ab6akeuceg7cG44HL4dq7mMLR5YEOpYp4Sa81KNPtBZXSd4o
	rS3CBIUmfu0frFE9EPW4xoDX6DKSoyNoGUR33QqF6/z8vddne
X-Received: by 2002:a05:620a:28cc:b0:939:6dea:4f1b with SMTP id af79cd13be357-93bb7947dd8mr52930385a.49.1789514438267;
        Tue, 15 Sep 2026 16:20:38 -0700 (PDT)
X-Received: by 2002:a05:620a:28cc:b0:939:6dea:4f1b with SMTP id af79cd13be357-93bb7947dd8mr52925285a.49.1789514437828;
        Tue, 15 Sep 2026 16:20:37 -0700 (PDT)
Received: from [127.0.1.1] (nat-128-59-179-204.net.columbia.edu. [128.59.179.204])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-93b781dfde3sm77151085a.12.2026.09.15.16.20.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Sep 2026 16:20:35 -0700 (PDT)
From: Tal Zussman <tz2294@columbia.edu>
Date: Tue, 15 Sep 2026 19:20:12 -0400
Subject: [PATCH v3 08/11] mm: memcontrol: constify the memcg and lruvec
 stat readers
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260915-folio_memcg-const-v3-8-c239a6010b58@columbia.edu>
References: <20260915-folio_memcg-const-v3-0-c239a6010b58@columbia.edu>
In-Reply-To: <20260915-folio_memcg-const-v3-0-c239a6010b58@columbia.edu>
To: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>,
        Roman Gushchin <roman.gushchin@linux.dev>,
        Shakeel Butt <shakeel.butt@linux.dev>,
        Muchun Song <muchun.song@linux.dev>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
        "Liam R. Howlett" <liam@infradead.org>,
        Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
        Suren Baghdasaryan <surenb@google.com>,
        Kairui Song <kasong@tencent.com>, Qi Zheng <qi.zheng@linux.dev>,
        Barry Song <baohua@kernel.org>,
        Axel Rasmussen <axelrasmussen@google.com>,
        Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
        Baoquan He <baoquan.he@linux.dev>,
        Baolin Wang <baolin.wang@linux.alibaba.com>,
        Chris Li <chrisl@kernel.org>, Kemeng Shi <shikemeng@huaweicloud.com>,
        Nhat Pham <nphamcs@gmail.com>, Youngjun Park <youngjun.park@lge.com>,
        "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc: cgroups@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Tal Zussman <tz2294@columbia.edu>
X-Mailer: b4 0.17-dev-db0b7
X-Developer-Signature: v=1; a=ed25519-sha256; t=1789514423; l=8657;
 i=tz2294@columbia.edu; s=20250528; h=from:subject:message-id;
 bh=YHxHgN6UU3N+CRyqP6YR9gtUjtCBlfYvowwLJv20ycc=;
 b=uuSz1AN4zqrv+kKMUPwsyJcOR55Y3QGLadluQjZAAt4wjOFnOj6fBym05KwGEc1H5APSHo1Tn
 W6EXE/EhSJwCoQNu2oL3eojcGhds040wUiGowbePkxegFF+7xegz+S3
X-Developer-Key: i=tz2294@columbia.edu; a=ed25519;
 pk=BIj5KdACscEOyAC0oIkeZqLB3L94fzBnDccEooxeM5Y=
X-Proofpoint-GUID: QFYoPCmCScr2uHNQvDncLfmpkYCfPMUv
X-Proofpoint-ORIG-GUID: QFYoPCmCScr2uHNQvDncLfmpkYCfPMUv
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTE1MDM0MSBTYWx0ZWRfX7jAgrOq7bAlQ
 7+gG8sFmWFH3N7M6iPO+yEgeQ/I0nFlxfubYP6xPEMSpczZ4dHMo4V776SUrt8MAn8TrUpqNTk2
 snug1fmKFxSwmzLuZb7KgjCl4m3jirQX+NgXtDkJaV6pWoKb+XxojwbMhr74iar48Wl0qB+YoS+
 i1Qgm0/TrKXy3V8Be1Eaf3ObuVP2v+TV7HaqiWGn9oXt/R/vlh0wPklOLG4X8Z6YzTstZB+2lQJ
 dRrVzC22/EeLjS+uDciWFQHm4TqcHaqSlMvIV0PVErzR/+U/p/ttuL1MhiBjjvkdirSOjomXB6/
 ioJgRBtFNCnRbG5RxmwuW/SQjbC0jR8NwnbNIsPjcFnLO8UEWvZLHojqnChSAGPZHx7jDtrbwkG
 LtE12GuDYn4JCt1OXARNeAAPOKIkweDQpcOLMMpR9f8moM58Kf6tFQLhFAkRUsaqtSHYYqYPQgu
 SpZdam5bbZ0/Jt9M77w==
X-Authority-Analysis: v=2.4 cv=KZVHIgYD c=1 sm=1 tr=0 ts=6aa9d2c7 cx=c_pps
 a=50t2pK5VMbmlHzFWWp8p/g==:117 a=hXAsoc/zAxyCEdIRhrpmVw==:17
 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10 a=x7bEGLp0ZPQA:10 a=A0y_DWxS2BwA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Da8U98TiO7q1upZEImrf:22 a=G--0XuH5328wxK7v7Suf:22
 a=cGOFIiuQh4YOckM99toA:9 a=QEXdDO2ut3YA:10 a=IoWCM6iH3mJn3m4BftBB:22
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTE1MDM0MSBTYWx0ZWRfX5rJNauQhBEYh
 t/Bpy2oPez3mfW6WX/YZzv33vFbqeUa1iXbVH3qK8fiW9IKgrnQ5vSqA07TiMdUljrEEU+hPhKf
 xmWtDbeSp0x/REsCogf4affxHYY6+iEpRGaFb1t9+onKKNFKoUk8
X-Proofpoint-Virus-Version: vendor=nai engine=6900 definitions=11906
 signatures=596817
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 priorityscore=1501 impostorscore=10 bulkscore=10 clxscore=1015
 phishscore=0 lowpriorityscore=10 adultscore=0 spamscore=0 malwarescore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2609040000 definitions=main-2609150341
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: B06EF20004
X-Rspam-User: 
X-Stat-Signature: n5m7jbg74kecau9gymwhmph6yagjfh9q
X-HE-Tag: 1789514440-765300
X-HE-Meta: U2FsdGVkX1/50aSrN1LsX/2KJKqyL9XjMheEjdSqgXY5FiOyPABaO3YdGNMm0Okyxzcp1e25dxlIGN5Uf4HlWi1hqzIOW1g4FWmpKbsrAU8Lr0YbHe1tDUpJ9dir6qJ0UztSrgdrvOU0DSr/9pxtt9tLuRyQJnRBZBhcEGqG876iwZnhwTm4kt2q/h9S3nk2jfcRi0vke6uCsFJBY654f/vLqgo/aNkfLmV3YIKXp/wIhqtGk/4fHbZciMrqfzCEgN8qxjXCs4Zj8Gs3aZff4EYiUkc3tgRq0zu51yh4tXlSikiXszn3BMqxCaC9QJnEz8j1BeRyYUZHgTPBgSv1bemAnlHpFIjYDHb4aX8FqU6vrk6A7XxMTkeN8uKxL3rxcP1BmK80My4A25bye9MbwOgAMaCFVkPSvuEpfkp4UIL0eyZXot8KbMMg/72NNkAHlf3JDxbqgMAqyN8lRwP7QpNRk/wlx3CP622YFSM044GzEspB72nm0ssN7XrsTzDpm431f9BjAikFbZlcOxA4v+1YUZLsCq0eCJGyROmZopYJ++x66nOgQTJ9D8hFa4S+n2Wgq6UrYtZnidkM1CFwlpNkmB2MKJYsMVTKzNAfrSH3PRBMEtGJrs+EAc8BjcbVMG6amcPELMUZDRy/2JNrK1gEFE5sSZ1876G83vHIaN3I1QjyTWHU2enbOFz/QDr2j7aTI67J/QYfEOxKE8Q/NpHI/NIqO10IffRNCDKABG3KHmu5PvGzpbMdxdzNubKiRawRmaO5TQBlVXVA2qEmKhoJdoS4Z9WBCCKEAWkF9Cwi6QLgQSYqGxDAWlGOKBhrJ131qkIV9FeibOJ8W2S+FknVU+EFKSs01NdVMXgqTg5ySqStQtfnwzSTA5VWQ2Wamo2pAqURuerwwKF1NhtttUivmGzI7Sx/Q1Xu7yer+CLf5Lu+t/w4KoH071vUVIwyqyj7k1XNxbJ0JtKEtD6
 lZWUjeg9
 vDzqISyc5ZQX5VKXlS9irKHijqRk2ivvqIPMnwzTVG8MovpUHgz0DyBWzik75Au3nRHygaSuPDW9nB6iWRsLvaGI/oAcvq+VRk4rFYUsQnh2QCA5oCu3R/DYHK0Nq7YGzj5KxfuaX4cLrQjhB+oWs8mTqoc1NkA32VePb9n6ndHhM2AKNQY39RWpH2CmqGDhQU7LDBqUXjHTSX5DZExd33i4P55g92rA+XQaG19OT76HqWJSKl5d5yWRgR8ZH0gM6vu0NRsgLIIdPyMHZ7j6DIsKCNVEiUXfd1t15CMcAQ4xKgAmXdIS9PB9Y490cxqb3pQn+wbzYteLo4fQ2kBiU35RduxoI8edY0mMs5SA/HyL1uhxeS511cEVvNF6HcTnT63BK
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The memcg_page_state(), memcg_events(), and lruvec_page_state()
families only read counters. Constify them.

Use container_of_const() in the lruvec_page_state() family while at it,
so the const isn't silently cast away.

Signed-off-by: Tal Zussman <tz2294@columbia.edu>
---
 include/linux/memcontrol.h | 23 ++++++++++++-----------
 mm/memcontrol-v1.h         |  6 +++---
 mm/memcontrol.c            | 30 +++++++++++++++---------------
 3 files changed, 30 insertions(+), 29 deletions(-)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index 22067899eb6c..9beb065c0879 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -971,15 +971,16 @@ static inline void mod_memcg_page_state(const struct page *page,
 	rcu_read_unlock();
 }
 
-unsigned long memcg_events(struct mem_cgroup *memcg, int event);
-unsigned long memcg_page_state(struct mem_cgroup *memcg, int idx);
-unsigned long memcg_page_state_output(struct mem_cgroup *memcg, int item);
+unsigned long memcg_events(const struct mem_cgroup *memcg, int event);
+unsigned long memcg_page_state(const struct mem_cgroup *memcg, int idx);
+unsigned long memcg_page_state_output(const struct mem_cgroup *memcg, int item);
 bool memcg_stat_item_valid(int idx);
 bool memcg_vm_event_item_valid(enum vm_event_item idx);
-unsigned long lruvec_page_state(struct lruvec *lruvec, enum node_stat_item idx);
-unsigned long lruvec_page_state_monotonic(struct lruvec *lruvec,
+unsigned long lruvec_page_state(const struct lruvec *lruvec,
+				enum node_stat_item idx);
+unsigned long lruvec_page_state_monotonic(const struct lruvec *lruvec,
 					  enum node_stat_item idx);
-unsigned long lruvec_page_state_local(struct lruvec *lruvec,
+unsigned long lruvec_page_state_local(const struct lruvec *lruvec,
 				      enum node_stat_item idx);
 
 void mem_cgroup_flush_stats(struct mem_cgroup *memcg);
@@ -1412,12 +1413,12 @@ static inline void mod_memcg_page_state(const struct page *page,
 {
 }
 
-static inline unsigned long memcg_page_state(struct mem_cgroup *memcg, int idx)
+static inline unsigned long memcg_page_state(const struct mem_cgroup *memcg, int idx)
 {
 	return 0;
 }
 
-static inline unsigned long memcg_page_state_output(struct mem_cgroup *memcg, int item)
+static inline unsigned long memcg_page_state_output(const struct mem_cgroup *memcg, int item)
 {
 	return 0;
 }
@@ -1432,19 +1433,19 @@ static inline bool memcg_vm_event_item_valid(enum vm_event_item idx)
 	return false;
 }
 
-static inline unsigned long lruvec_page_state(struct lruvec *lruvec,
+static inline unsigned long lruvec_page_state(const struct lruvec *lruvec,
 					      enum node_stat_item idx)
 {
 	return node_page_state(lruvec_pgdat(lruvec), idx);
 }
 
-static inline unsigned long lruvec_page_state_monotonic(struct lruvec *lruvec,
+static inline unsigned long lruvec_page_state_monotonic(const struct lruvec *lruvec,
 							enum node_stat_item idx)
 {
 	return node_page_state_monotonic(lruvec_pgdat(lruvec), idx);
 }
 
-static inline unsigned long lruvec_page_state_local(struct lruvec *lruvec,
+static inline unsigned long lruvec_page_state_local(const struct lruvec *lruvec,
 						    enum node_stat_item idx)
 {
 	return node_page_state(lruvec_pgdat(lruvec), idx);
diff --git a/mm/memcontrol-v1.h b/mm/memcontrol-v1.h
index b9a21f0fd2c3..f6d128da443e 100644
--- a/mm/memcontrol-v1.h
+++ b/mm/memcontrol-v1.h
@@ -34,9 +34,9 @@ static inline bool do_memsw_account(void)
 	return !cgroup_subsys_on_dfl(memory_cgrp_subsys);
 }
 
-unsigned long memcg_events_local(struct mem_cgroup *memcg, int event);
-unsigned long memcg_page_state_local(struct mem_cgroup *memcg, int idx);
-unsigned long memcg_page_state_local_output(struct mem_cgroup *memcg, int item);
+unsigned long memcg_events_local(const struct mem_cgroup *memcg, int event);
+unsigned long memcg_page_state_local(const struct mem_cgroup *memcg, int idx);
+unsigned long memcg_page_state_local_output(const struct mem_cgroup *memcg, int item);
 bool memcg1_alloc_events(struct mem_cgroup *memcg);
 void memcg1_free_events(struct mem_cgroup *memcg);
 
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 4b7c01daebce..b13f5ed74a5a 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -490,9 +490,9 @@ struct lruvec_stats {
 	long state_pending[NR_MEMCG_NODE_STAT_ITEMS];
 };
 
-unsigned long lruvec_page_state(struct lruvec *lruvec, enum node_stat_item idx)
+unsigned long lruvec_page_state(const struct lruvec *lruvec, enum node_stat_item idx)
 {
-	struct mem_cgroup_per_node *pn;
+	const struct mem_cgroup_per_node *pn;
 	long x;
 	int i;
 
@@ -503,7 +503,7 @@ unsigned long lruvec_page_state(struct lruvec *lruvec, enum node_stat_item idx)
 	if (WARN_ONCE(BAD_STAT_IDX(i), "%s: missing stat item %d\n", __func__, idx))
 		return 0;
 
-	pn = container_of(lruvec, struct mem_cgroup_per_node, lruvec);
+	pn = container_of_const(lruvec, struct mem_cgroup_per_node, lruvec);
 	x = READ_ONCE(pn->lruvec_stats->state[i]);
 #ifdef CONFIG_SMP
 	if (x < 0)
@@ -531,10 +531,10 @@ unsigned long lruvec_page_state(struct lruvec *lruvec, enum node_stat_item idx)
  * monotonically-incremented event counters are stored in
  * enum node_stat_item.
  */
-unsigned long lruvec_page_state_monotonic(struct lruvec *lruvec,
+unsigned long lruvec_page_state_monotonic(const struct lruvec *lruvec,
 					  enum node_stat_item idx)
 {
-	struct mem_cgroup_per_node *pn;
+	const struct mem_cgroup_per_node *pn;
 	int i;
 
 	if (mem_cgroup_disabled())
@@ -544,14 +544,14 @@ unsigned long lruvec_page_state_monotonic(struct lruvec *lruvec,
 	if (WARN_ONCE(BAD_STAT_IDX(i), "%s: missing stat item %d\n", __func__, idx))
 		return 0;
 
-	pn = container_of(lruvec, struct mem_cgroup_per_node, lruvec);
+	pn = container_of_const(lruvec, struct mem_cgroup_per_node, lruvec);
 	return (unsigned long)READ_ONCE(pn->lruvec_stats->state[i]);
 }
 
-unsigned long lruvec_page_state_local(struct lruvec *lruvec,
+unsigned long lruvec_page_state_local(const struct lruvec *lruvec,
 				      enum node_stat_item idx)
 {
-	struct mem_cgroup_per_node *pn;
+	const struct mem_cgroup_per_node *pn;
 	long x;
 	int i;
 
@@ -562,7 +562,7 @@ unsigned long lruvec_page_state_local(struct lruvec *lruvec,
 	if (WARN_ONCE(BAD_STAT_IDX(i), "%s: missing stat item %d\n", __func__, idx))
 		return 0;
 
-	pn = container_of(lruvec, struct mem_cgroup_per_node, lruvec);
+	pn = container_of_const(lruvec, struct mem_cgroup_per_node, lruvec);
 	x = READ_ONCE(pn->lruvec_stats->state_local[i]);
 #ifdef CONFIG_SMP
 	if (x < 0)
@@ -827,7 +827,7 @@ static void flush_memcg_stats_dwork(struct work_struct *w)
 	queue_delayed_work(system_dfl_wq, &stats_flush_dwork, FLUSH_TIME);
 }
 
-unsigned long memcg_page_state(struct mem_cgroup *memcg, int idx)
+unsigned long memcg_page_state(const struct mem_cgroup *memcg, int idx)
 {
 	long x;
 	int i = memcg_stats_index(idx);
@@ -950,7 +950,7 @@ void mod_memcg_state(struct mem_cgroup *memcg, enum memcg_stat_item idx,
 
 #ifdef CONFIG_MEMCG_V1
 /* idx can be of type enum memcg_stat_item or node_stat_item. */
-unsigned long memcg_page_state_local(struct mem_cgroup *memcg, int idx)
+unsigned long memcg_page_state_local(const struct mem_cgroup *memcg, int idx)
 {
 	long x;
 	int i = memcg_stats_index(idx);
@@ -1113,7 +1113,7 @@ void count_memcg_events(struct mem_cgroup *memcg, enum vm_event_item idx,
 	put_cpu();
 }
 
-unsigned long memcg_events(struct mem_cgroup *memcg, int event)
+unsigned long memcg_events(const struct mem_cgroup *memcg, int event)
 {
 	int i = memcg_events_index(event);
 
@@ -1132,7 +1132,7 @@ bool memcg_vm_event_item_valid(enum vm_event_item idx)
 }
 
 #ifdef CONFIG_MEMCG_V1
-unsigned long memcg_events_local(struct mem_cgroup *memcg, int event)
+unsigned long memcg_events_local(const struct mem_cgroup *memcg, int event)
 {
 	int i = memcg_events_index(event);
 
@@ -1715,14 +1715,14 @@ static int memcg_page_state_output_unit(int item)
 	}
 }
 
-unsigned long memcg_page_state_output(struct mem_cgroup *memcg, int item)
+unsigned long memcg_page_state_output(const struct mem_cgroup *memcg, int item)
 {
 	return memcg_page_state(memcg, item) *
 		memcg_page_state_output_unit(item);
 }
 
 #ifdef CONFIG_MEMCG_V1
-unsigned long memcg_page_state_local_output(struct mem_cgroup *memcg, int item)
+unsigned long memcg_page_state_local_output(const struct mem_cgroup *memcg, int item)
 {
 	return memcg_page_state_local(memcg, item) *
 		memcg_page_state_output_unit(item);

-- 
2.39.5



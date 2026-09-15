Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BAA77C88E7F
	for <linux-mm@archiver.kernel.org>; Tue, 15 Sep 2026 23:20:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4A98E6B0099; Tue, 15 Sep 2026 19:20:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 433D36B009D; Tue, 15 Sep 2026 19:20:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 25F6E6B009B; Tue, 15 Sep 2026 19:20:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 049456B0098
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 19:20:37 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 507C61604FD
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 23:20:37 +0000 (UTC)
X-FDA: 85217568114.21.7E8C874
Received: from mx0a-00364e01.pphosted.com (mx0a-00364e01.pphosted.com [148.163.135.74])
	by imf14.hostedemail.com (Postfix) with ESMTP id AFD59100003
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 23:20:34 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=JI1AfrpG;
	dkim=pass header.d=columbia.edu header.s=lionmail header.b=fWJibpde;
	spf=pass (imf14.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.135.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu;
	dmarc=pass (policy=none) header.from=columbia.edu
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789514434;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3A0c795kjeVp04m0X3RgV/nXXLo89+Yqy/uh4bIfeQg=;
	b=7sNjG93qA1OO/sJPNyOSndTAdGjGt2xlkblw4z6hI2O3+VmsyxEfYMn3AxMjShqvzJRNMx
	nKO+DvuDYkgobSjFsWuklQE6J0aUOW0jNEF7BPMPyfVfwZM8TNDHYX0f2E6ISdgWdbkRl6
	RT6hCHAxo+vGBz+KTAqzS4qAPsEDFFo=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=JI1AfrpG;
	dkim=pass header.d=columbia.edu header.s=lionmail header.b=fWJibpde;
	spf=pass (imf14.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.135.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu;
	dmarc=pass (policy=none) header.from=columbia.edu
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789514434;
	b=KMwRkbhACNafNwqcRl4hxncA9IzpQaz+5S74kme5l+3gI5KcuQSzj0EFLVlmR5tR0PEiwE
	ymw+y63OV5+WJgG4iviiFGIu+Q17Rrz9LatqE0qjJV+KTdNNH29S9hK1NBVsiFoCcVjC3P
	8YCODAUqgzhEXK9En+CN0pe+4DYla9o=
Received: from pps.filterd (m0167068.ppops.net [127.0.0.1])
	by mx0a-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68FMbOZL3384082
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 19:20:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pps01; bh=3A0c
	795kjeVp04m0X3RgV/nXXLo89+Yqy/uh4bIfeQg=; b=JI1AfrpG+w8AnKn7QscG
	cHXWdBdfUOmF4ZEwHbvxEFaOKJ7qvLzmh51lvDMEkWjQ/pOLNeKd20N/CFpzyXvM
	Q0/GqpmVNIE+Mh3sisXovCHiRlz/fSIXZtof9/OZcv0oWqtAJlZCG9e/8Z8qu4p1
	/YX4W1g6Ua/LoY8E8lNySyifthRdhHu3W4hHz/RFatvx0CZOiK695OqAuoYMlNVU
	IMZ1Gb9BZ739TgZukub6+Gweh/6c/u16x6Fhm6fnbT/G2+bmcXzVLjv1XuiJYzxP
	aPC5lPwQ8+Tib4bOg5pSZjQ56H8wQnp81BG5Ahs2TCM/5mr66w79KdHUrJz/hIsh
	IQ==
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com [209.85.222.200])
	by mx0a-00364e01.pphosted.com (PPS) with ESMTPS id 4gqbjfad7s-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 19:20:33 -0400 (EDT)
Received: by mail-qk1-f200.google.com with SMTP id af79cd13be357-93a082c014aso368919685a.0
        for <linux-mm@kvack.org>; Tue, 15 Sep 2026 16:20:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=columbia.edu; s=lionmail; t=1789514432; x=1790119232; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=3A0c795kjeVp04m0X3RgV/nXXLo89+Yqy/uh4bIfeQg=;
        b=fWJibpde8ZDG56IKMnlQyo0LJnFSqRSkpTcjbXAZLyn8lWPos4QPth+J+ig9BR8he9
         xACWvaoZWGciWnTuL21+psX5YQmeRhd+ajlwCMv1CuX9DDufZFT7addN0KgNIwX0y5GN
         hOM+BePzcatcNmQHr+NZyO8EMueeIUv5T5Bo1Zpo9s/l2KD4tO4qVFf4hqjd1E8uHKxR
         wkp8AP8a8+pI6Z4pI8OwyXFKDTWQmRE1ayQKhGCQYGk5MxrMoM7TPd3O2agP5YmyGwgt
         77XEdb8f+thYpd71xwXnhbLH3OZWK5Pt75eXAwho5Gtfh5POMr+CYRGvTmZj1KqHTwes
         7uSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789514432; x=1790119232;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=3A0c795kjeVp04m0X3RgV/nXXLo89+Yqy/uh4bIfeQg=;
        b=BNEDuLb+ioATh0yWzFbDLrwegtj2tCZ4wOqzbGJ03b9tRkm+32BJX/q9+zRgJFMsP6
         eNIRZDIojlGk5blW/Ksi+iDN74bniTsn/tgf2Ymc+Je2zM9KmrlYnhArWm3I7iXrQpGH
         ZYCUPxtmY19LH/A+aFUdcZT2ko35uEDdSdeERv7WtLJoHXj4+z3nVeXRoo4NEJRz9cvY
         POF/MiphyJPQjOUsVVP4VSU/xwDGU4q04Zwk7FO5fBB/0ASVH/utvgHdxVXNnkynvNO2
         rRAjgNqMkfZuXWTV3hDX584I5EJpO4Hnu+TPbXWUAAs9a2Hx43qDST7sClLAgXn5oG+d
         5/CQ==
X-Forwarded-Encrypted: i=1; AKwUvBxNVNbx9IQjMmGd+DBV7hqiTMysQpyrP9USZ3gtD/zbgxcKYu2Tb3NTl+IESwIbjXAzpRo727OlWw==@kvack.org
X-Gm-Message-State: AFuF++lhUNbwl+ILaU2/t6UKkuQpMvcHe7MfpRQAUiwNi6XvClq3dzrA
	ce8zBQGaMBbw+M1UmgBhgOmjFz5iWyZKs6JNS8emBZDHIp4/hD+DSxTpuSkTn8ou1fECqbV+ymo
	apf35mhhGj+aAeIRbKVf0JrFqzXMrbmfcIljGsmCJeSiCA7Gz
X-Gm-Gg: AYBFou1T673KAnBaznmriDczwm/Yv+La8izMVWAm3Y/JEbn+uUx/VvEzlDBGQ7OjuXj
	mDjbLiynXpyW8V/iMRtsAT3Cj1aWFCfjH6HcGuXe4dUy1K4Tf3L4MgOmAZCYxqNoa1RoSEsqybm
	Umx6RMK3hfOdj4JZykWLoOycPp4cZRfpWmrPNtVaDarQZyvIrQJ7fOxYaGUX6qlxk9n9s828NW2
	WD3OMaY42MZxfr7wT2KPasPGiAq6KBrYwDt+LSunDiIQ65+OToLLeouALB/8hT3vHtMvcahUGR6
	q77uZrnqY8ZGDXL1hyuSw4BTAc1PxhhDBNgXMeMFo8glLBhzCrllGT/UD54cLbKgI26tVrRd5J7
	A8/qIGPMh4H+xr+46DrqyP7mmOxGM/+snD/+sIuW9g//jUKwt
X-Received: by 2002:a05:620a:438c:b0:939:8e06:45d7 with SMTP id af79cd13be357-93bb6f34ab6mr61122385a.0.1789514432450;
        Tue, 15 Sep 2026 16:20:32 -0700 (PDT)
X-Received: by 2002:a05:620a:438c:b0:939:8e06:45d7 with SMTP id af79cd13be357-93bb6f34ab6mr61119885a.0.1789514432031;
        Tue, 15 Sep 2026 16:20:32 -0700 (PDT)
Received: from [127.0.1.1] (nat-128-59-179-204.net.columbia.edu. [128.59.179.204])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-93b781dfde3sm77151085a.12.2026.09.15.16.20.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Sep 2026 16:20:31 -0700 (PDT)
From: Tal Zussman <tz2294@columbia.edu>
Date: Tue, 15 Sep 2026 19:20:09 -0400
Subject: [PATCH v3 05/11] mm: memcontrol: constify the mem_cgroup accessors
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260915-folio_memcg-const-v3-5-c239a6010b58@columbia.edu>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1789514423; l=7131;
 i=tz2294@columbia.edu; s=20250528; h=from:subject:message-id;
 bh=bDvtL2wz+QRX9/VNyJZjloak2gmuOXGwsId1RmEh0qM=;
 b=dExCOGR95BwlR2j0umAJm8kuB7Y5PPVWGGNWYfcQOUtxfTCnvXIMgrU1BeG4198ozJ4GUes5c
 sXUNARWn5VJCOkluJKmxZxDJHzCsGgLGw4nZuktlF1BJVk9u87aww/f
X-Developer-Key: i=tz2294@columbia.edu; a=ed25519;
 pk=BIj5KdACscEOyAC0oIkeZqLB3L94fzBnDccEooxeM5Y=
X-Authority-Analysis: v=2.4 cv=fNCsTpae c=1 sm=1 tr=0 ts=6aa9d2c1 cx=c_pps
 a=hnmNkyzTK/kJ09Xio7VxxA==:117 a=hXAsoc/zAxyCEdIRhrpmVw==:17
 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10 a=x7bEGLp0ZPQA:10 a=A0y_DWxS2BwA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Da8U98TiO7q1upZEImrf:22 a=usPcmh10W0ubT8QP8_c3:22
 a=J-BU3SA5NDMaAVagD6IA:9 a=QEXdDO2ut3YA:10 a=PEH46H7Ffwr30OY-TuGO:22
X-Proofpoint-GUID: rSbS0owvDjJpUHG8Y1je_ih0MIqJLXeO
X-Proofpoint-ORIG-GUID: rSbS0owvDjJpUHG8Y1je_ih0MIqJLXeO
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTE1MDM0MSBTYWx0ZWRfX7Bvf/Ra8TP/P
 kNHh+ky3L1cXtMKwQDwOhytIuQ/dXyGMvhyhnKVNNLmuZzIUloeOaO7oEOxqHz+IaKH3QODojti
 IvQOYJ5F4aGO+qwUTPmBGsKK4VWjJacOWBJcVSUq74fWiYPxoN7e
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTE1MDM0MSBTYWx0ZWRfX0BQFiVSq/Wz4
 1OIM5IoBLdjFNKAOwqujNH9b1KZuJyIvLUwRx71XhW90Ishl1Yq7gGGu5wyzeWij8nAJP+p7dWR
 QSY0asifXHpEcCfcw3DGY0LROCWix2GacTp+OoiZ4XmT/qTfmYfrj5BgUt2srSFKJ1cVMclvxNX
 8Crcsi2qvCA4bmRYayCtECtREUMMMTaBIivhSF16gP+QOIx7FcY2CQeDg4uLv5DTUKYkTjoBRu9
 oSvY1JmGb0aILVFrgLD/jEwSCjNkiiQPRYlbcCIXeOB17W6itaiT+pyQIbmm7FPeRTPl2EPkAMx
 iJNO5LYBWsLXtarbg20eXu2plfMVKVGMpGfRpwLDZGqjnF864FxqNylSa7IHdihgIL5MzjCVL9r
 DSIUgxacjAjfovzfIEn/kPjt4XhX5fIQLt+rjn3ZxY9HIT7Ykyv59bxt9U9tkFpi9ijXpigDzKh
 FKcr+tGVCqnADMOvdLw==
X-Proofpoint-Virus-Version: vendor=nai engine=6900 definitions=11906
 signatures=596817
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 priorityscore=1501 impostorscore=10 adultscore=0 spamscore=0
 clxscore=1015 phishscore=0 malwarescore=0 bulkscore=10 lowpriorityscore=10
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2609040000 definitions=main-2609150341
X-Rspam-User: 
X-Stat-Signature: h4j739gq1sbyn7wy8r46myfekriruzo3
X-Rspamd-Queue-Id: AFD59100003
X-Rspamd-Server: rspam07
X-HE-Tag: 1789514434-91732
X-HE-Meta: U2FsdGVkX187mNFRhbxrFX3ok6ydSak2fYyHMDMSgP+UR/HCaXinR3enXqkqdoQAHMqbyZxnwGIewJBjFDTpICVf0n67abQ0SyQXsxiX3Rfsyn36P2UQL1koS6I5SZ4HqKnlA7jHBOychKa51NL6Wxoenl+gDU5sykoQOeFgh7HKF/yC7pjyTqvv4frxqsvy7LOsVNXPwpG9JNIuHhI4Wi75jqjy286gabD1fZdODpdkrKl+Wy4fN1m34N36aN8Z+i3+sjc0d8QrpduoU86hlXWDJC1VDriNPdowLMIAKas2IBAZlzdphBQaX+oVXGGWEYQmyUldJkXdJJaIaX7yoEqXK81l6GIhwSkjj4w+nbsK3ZhLlLA1HsjM247yIrwWHYnv0JkPD6IfTH5leUVq4TD5P8+v1FomJrhXGlLwF4R/meW3QPyHnGvCJjy7XnpFRqZAtsRBGHtGxGSipKmIngJ/4+5JnNMNQ3evK3TUJuynpra9S1RxOh41s0p3Ja0Aa0ak3parFQmbnGfAP6AZfSkqpV/duV42+b6GE+uV2ULlNsaVZ++O1OmsENxtzStA/1S9DC9mQibFKQOQ9d6DuErEsywlhIVO0nvKWpM094OB/fB8cnbsFXjA5/vO9EwXHHZieAgxNLYLQdclR1WUeCWZ/Wx/IoK9qBMK0AXzevQB5YY74SxZnL/7dZZNe2s/Kj7ipltjWy3Xp/HthAOUW4+dF/8fCDM060RQc+Usbi4OZYKMeHmlIiofqMcodg39+MZ74gS0gollSC9mA9OkZsVnb1valPbW3aTUVk2R1JC34UQPF/RdnCNEzNECuEVMAJlpV/DdTtHdcdIB/OJoBbIA6VYvwVLSRVFM/GBCaUjgYedzGWcLr7IVyUgPMyCEh7snalHC5GVK/pdvWQEOTNBwd0d6pXc3+g8ZC6KgvIV0idm3wD0tndisrJzOs1Yjw37fE4PTrtlwlI4Rl0z
 M4bfiOeI
 +Z/VaqJn6uAVeiFgkTKAsShZzqiGzRphJ/VUPM5ESTNcgfV7QttXtZ7mi+5f5+f/NjNJ31jvNsBFBk0Aymc9aIRlNmoCkBeTIRtKewDTgWHQuF2n6Ts3FX3pQzyeKO7LwXsl/TwkW2UcX3u7ZUif3JBHX8lDsu/zclFOV8nzi3f6CmPG9A0IO96MkErwZseO6rHd9WZlCqymaIo+BBpZS0IVZQsJz8qKvuotmQx9NpFr8zZOHa5NbNB+L6VxjJua9x8dCvUpOuZRzY2zzY45OiuGKGmMY4ZvvPR+DBpiL07T9i7Zty431KQLgn+Ehmun8v3hEDO78JjWhOVByXhoN6JlbwWotsrtIk0sEbtk3aYRwJDVSFgomcxawTGB9fpLSCAu3KIMSSckREexF4yzeltYzjOAowrq64woa6RKCUA2a1Bw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

mem_cgroup_id(), parent_mem_cgroup(), mem_cgroup_is_root(),
mem_cgroup_is_descendant(), memcg_kmem_id(), and the other memcg
accessors only read from the memcg. Constify them, along with
mem_cgroup_shrink_is_root()'s shrink_control.

mem_cgroup_print_oom_context()'s task stays non-const, as
task_cgroup() takes a non-const task.

Signed-off-by: Tal Zussman <tz2294@columbia.edu>
---
 include/linux/memcontrol.h | 41 +++++++++++++++++++++--------------------
 mm/memcontrol.c            |  3 ++-
 2 files changed, 23 insertions(+), 21 deletions(-)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index 436934030d79..01f74413fc79 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -539,7 +539,7 @@ static inline bool PageMemcgKmem(const struct page *page)
 	return folio_memcg_kmem(page_folio(page));
 }
 
-static inline bool mem_cgroup_is_root(struct mem_cgroup *memcg)
+static inline bool mem_cgroup_is_root(const struct mem_cgroup *memcg)
 {
 	return (memcg == root_mem_cgroup);
 }
@@ -555,7 +555,7 @@ static inline bool mem_cgroup_is_root(struct mem_cgroup *memcg)
  * and do not honour sc->memcg can use this to early-return 0 in per-memcg
  * contexts.
  */
-static inline bool mem_cgroup_shrink_is_root(struct shrink_control *sc)
+static inline bool mem_cgroup_shrink_is_root(const struct shrink_control *sc)
 {
 	return !sc->memcg || mem_cgroup_is_root(sc->memcg);
 }
@@ -840,7 +840,7 @@ void mem_cgroup_iter_break(struct mem_cgroup *, struct mem_cgroup *);
 void mem_cgroup_scan_tasks(struct mem_cgroup *memcg,
 			   int (*)(struct task_struct *, void *), void *arg);
 
-static inline unsigned short mem_cgroup_private_id(struct mem_cgroup *memcg)
+static inline unsigned short mem_cgroup_private_id(const struct mem_cgroup *memcg)
 {
 	if (mem_cgroup_disabled())
 		return 0;
@@ -849,7 +849,7 @@ static inline unsigned short mem_cgroup_private_id(struct mem_cgroup *memcg)
 }
 struct mem_cgroup *mem_cgroup_from_private_id(unsigned short id);
 
-static inline u64 mem_cgroup_id(struct mem_cgroup *memcg)
+static inline u64 mem_cgroup_id(const struct mem_cgroup *memcg)
 {
 	return memcg ? cgroup_id(memcg->css.cgroup) : 0;
 }
@@ -878,13 +878,13 @@ static inline struct mem_cgroup *lruvec_memcg(const struct lruvec *lruvec)
  *
  * Returns the parent memcg, or NULL if this is the root.
  */
-static inline struct mem_cgroup *parent_mem_cgroup(struct mem_cgroup *memcg)
+static inline struct mem_cgroup *parent_mem_cgroup(const struct mem_cgroup *memcg)
 {
 	return mem_cgroup_from_css(memcg->css.parent);
 }
 
-static inline bool mem_cgroup_is_descendant(struct mem_cgroup *memcg,
-			      struct mem_cgroup *root)
+static inline bool mem_cgroup_is_descendant(const struct mem_cgroup *memcg,
+			      const struct mem_cgroup *root)
 {
 	if (root == memcg)
 		return true;
@@ -892,7 +892,7 @@ static inline bool mem_cgroup_is_descendant(struct mem_cgroup *memcg,
 }
 
 static inline bool mm_match_cgroup(struct mm_struct *mm,
-				   struct mem_cgroup *memcg)
+				   const struct mem_cgroup *memcg)
 {
 	struct mem_cgroup *task_memcg;
 	bool match = false;
@@ -943,7 +943,7 @@ static inline void mem_cgroup_handle_over_high(gfp_t gfp_mask)
 
 unsigned long mem_cgroup_get_max(struct mem_cgroup *memcg);
 
-void mem_cgroup_print_oom_context(struct mem_cgroup *memcg,
+void mem_cgroup_print_oom_context(const struct mem_cgroup *memcg,
 				struct task_struct *p);
 
 void mem_cgroup_print_oom_meminfo(struct mem_cgroup *memcg);
@@ -1119,12 +1119,12 @@ static inline bool PageMemcgKmem(const struct page *page)
 	return false;
 }
 
-static inline bool mem_cgroup_is_root(struct mem_cgroup *memcg)
+static inline bool mem_cgroup_is_root(const struct mem_cgroup *memcg)
 {
 	return true;
 }
 
-static inline bool mem_cgroup_shrink_is_root(struct shrink_control *sc)
+static inline bool mem_cgroup_shrink_is_root(const struct shrink_control *sc)
 {
 	return true;
 }
@@ -1227,13 +1227,13 @@ static inline struct lruvec *folio_lruvec(const struct folio *folio)
 	return &pgdat->__lruvec;
 }
 
-static inline struct mem_cgroup *parent_mem_cgroup(struct mem_cgroup *memcg)
+static inline struct mem_cgroup *parent_mem_cgroup(const struct mem_cgroup *memcg)
 {
 	return NULL;
 }
 
 static inline bool mm_match_cgroup(struct mm_struct *mm,
-		struct mem_cgroup *memcg)
+		const struct mem_cgroup *memcg)
 {
 	return true;
 }
@@ -1327,7 +1327,7 @@ static inline void mem_cgroup_scan_tasks(struct mem_cgroup *memcg,
 {
 }
 
-static inline unsigned short mem_cgroup_private_id(struct mem_cgroup *memcg)
+static inline unsigned short mem_cgroup_private_id(const struct mem_cgroup *memcg)
 {
 	return 0;
 }
@@ -1339,7 +1339,7 @@ static inline struct mem_cgroup *mem_cgroup_from_private_id(unsigned short id)
 	return NULL;
 }
 
-static inline u64 mem_cgroup_id(struct mem_cgroup *memcg)
+static inline u64 mem_cgroup_id(const struct mem_cgroup *memcg)
 {
 	return 0;
 }
@@ -1377,7 +1377,8 @@ static inline unsigned long mem_cgroup_get_max(struct mem_cgroup *memcg)
 }
 
 static inline void
-mem_cgroup_print_oom_context(struct mem_cgroup *memcg, struct task_struct *p)
+mem_cgroup_print_oom_context(const struct mem_cgroup *memcg,
+			     struct task_struct *p)
 {
 }
 
@@ -1813,7 +1814,7 @@ static inline void memcg_kmem_uncharge_page(struct page *page, int order)
  * A helper for accessing memcg's kmem_id, used for getting
  * corresponding LRU lists.
  */
-static inline int memcg_kmem_id(struct mem_cgroup *memcg)
+static inline int memcg_kmem_id(const struct mem_cgroup *memcg)
 {
 	return memcg ? memcg->kmemcg_id : -1;
 }
@@ -1885,7 +1886,7 @@ static inline bool memcg_kmem_online(void)
 	return false;
 }
 
-static inline int memcg_kmem_id(struct mem_cgroup *memcg)
+static inline int memcg_kmem_id(const struct mem_cgroup *memcg)
 {
 	return -1;
 }
@@ -1962,7 +1963,7 @@ static inline bool mem_cgroup_zswap_writeback_enabled(struct mem_cgroup *memcg)
 #ifdef CONFIG_MEMCG_V1
 bool mem_cgroup_oom_synchronize(bool wait);
 
-static inline bool task_in_memcg_oom(struct task_struct *p)
+static inline bool task_in_memcg_oom(const struct task_struct *p)
 {
 	return p->memcg_in_oom;
 }
@@ -1980,7 +1981,7 @@ static inline void mem_cgroup_exit_user_fault(void)
 }
 
 #else /* CONFIG_MEMCG_V1 */
-static inline bool task_in_memcg_oom(struct task_struct *p)
+static inline bool task_in_memcg_oom(const struct task_struct *p)
 {
 	return false;
 }
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 1f660af3bc3a..4b7c01daebce 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -1818,7 +1818,8 @@ static void memory_stat_format(struct mem_cgroup *memcg, struct seq_buf *s)
  * NOTE: @memcg and @p's mem_cgroup can be different when hierarchy is
  * enabled
  */
-void mem_cgroup_print_oom_context(struct mem_cgroup *memcg, struct task_struct *p)
+void mem_cgroup_print_oom_context(const struct mem_cgroup *memcg,
+				  struct task_struct *p)
 {
 	rcu_read_lock();
 

-- 
2.39.5



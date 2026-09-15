Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1E0EFC88E77
	for <linux-mm@archiver.kernel.org>; Tue, 15 Sep 2026 23:21:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B882F6B00A2; Tue, 15 Sep 2026 19:20:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B60AC6B00A3; Tue, 15 Sep 2026 19:20:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A501E6B00A4; Tue, 15 Sep 2026 19:20:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 7A0FD6B00A2
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 19:20:49 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 051261A0573
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 23:20:48 +0000 (UTC)
X-FDA: 85217568618.26.294012E
Received: from mx0a-00364e01.pphosted.com (mx0a-00364e01.pphosted.com [148.163.135.74])
	by imf12.hostedemail.com (Postfix) with ESMTP id 668EE40002
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 23:20:46 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=G3xvhvKA;
	dkim=pass header.d=columbia.edu header.s=lionmail header.b=wMAiTR3I;
	spf=pass (imf12.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.135.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu;
	dmarc=pass (policy=none) header.from=columbia.edu
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789514446;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iohstel+U4w+qu+f/b24Nbqr30/JwqG/BmuqFbjm+rg=;
	b=NckTVHkuWcNFxJCylaylwkPU9ihTy4/8rxYInVTFOTODunjaeYl7UDVxWZkEbQGWt5yT+r
	Pe7KRdTokJ9Yvk/3eDgWY3QH4Yf9laEh3DEMpUPp6wGDwHVfF/qeKSRsGMm7utL8I4pKll
	GWUcZ9Y7JG3tpWrg2BmpEhgE7Y1tt9w=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=G3xvhvKA;
	dkim=pass header.d=columbia.edu header.s=lionmail header.b=wMAiTR3I;
	spf=pass (imf12.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.135.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu;
	dmarc=pass (policy=none) header.from=columbia.edu
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789514446;
	b=OG0pVtJk82FKu1RDmru1TmJXjwJBx95yPwne3OoBnUoiRHwm6q7P7+nZFerkMvlwTyayuk
	Owi+bfjNJvZ80VVsdQrYXEtdTLHcPgv1+QVXsLPsUgM/kk9LnzWcGLMl3fUa/uynLa14kA
	3x1RbxJa40zrs8oKQrpN+Nbd7U/sV/4=
Received: from pps.filterd (m0167070.ppops.net [127.0.0.1])
	by mx0a-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68FMbt3o2571971
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 19:20:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pps01; bh=iohs
	tel+U4w+qu+f/b24Nbqr30/JwqG/BmuqFbjm+rg=; b=G3xvhvKAasRnOUA3QkA7
	O2B5Z0uiInOE5axuO7zjxdNfV1nMjxqGzRKfdHZwtNs2v9I2fhaAU7pVLB8HUXuf
	cKtVAxN2asgbRT4r6Wpi2IBwWrRh9eFjrQ5WOWL2kb1U+4zKRW9Y/+7o7PfyFM4/
	DVaAmcDH0BxcI11Au0LNcgLdDlOs7Keee1puvS7aMma0BOSR+srHsynPKksRBr+o
	3PZhy3uWAN4MzQkWSq7F468MzGFeVeFJ2ylwfqNEnOXVv5+/ERAZbGzEQsZ8ZjoL
	rLTMjcFh7/EcT1HlVmFRhF7QZk8BlETzaj46KlNU/L5UhjBxVbIQ97Y5ALCt37OL
	3g==
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com [209.85.222.199])
	by mx0a-00364e01.pphosted.com (PPS) with ESMTPS id 4gqbwd9t21-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 19:20:45 -0400 (EDT)
Received: by mail-qk1-f199.google.com with SMTP id af79cd13be357-93a1e564fd5so446038185a.1
        for <linux-mm@kvack.org>; Tue, 15 Sep 2026 16:20:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=columbia.edu; s=lionmail; t=1789514444; x=1790119244; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=iohstel+U4w+qu+f/b24Nbqr30/JwqG/BmuqFbjm+rg=;
        b=wMAiTR3I59XajMlGEwAFV3ruKJ0H1slbugU0xZjUPghS57gYaLp/hPYvFcYaelXExL
         5YUwSD4+eB0xlmQUOYNcaNmTjb1OdNwiKdR/rVFeZYaB8vdSZv6dERBFmMvOkoK5RgfA
         v1/eNDCkY/JXXJeZ6dwSRq4cZ+PPfW9CONtlL/s596+xGAjcVCTk29P58dAU9v2F7syw
         hSgmDAoU6Q4S2an6F583GUuFSM2otDjpJvhtii1Z6Zgwb5E7p9jDcjUwL8R1exgFuZME
         BFrhdm55SSxYozYy9vEpYwHoQZxGZJ4gwQsdyqPhDWAruzzvF/qk7i8vSzdLxsk0BwgG
         0waw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789514444; x=1790119244;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=iohstel+U4w+qu+f/b24Nbqr30/JwqG/BmuqFbjm+rg=;
        b=ODFcEF1eHQ/Svubf1SR9OIPy4ia9gH+Wsp8jtWTci7p+ya+mrXF5IPySkRb0Db/8FY
         m+/mhiT/zOri6kLbpQmwxJZ1RIWZLo7v3piCJHFtcyUa4VKhCDQpXJq9/lExFsLh9bKx
         CVF5Chv8nTVLyLBmIN67SvZ/x127xL4rSkhokqfiKUGY4kPs90MrKPkCjD89Vyjd1hQQ
         ykTirtC+oC33yIkzZLjZ69lJWf93IlZTOJT+gLuK+TbmNIMj9K5tIYRICaGH9bTD/sAl
         7/C7irY5kOxYusY62zYJ8krCNn+wDrGP/yDrUZMx+kppoJuWhAyiZjjkvTgIeK2++dZM
         d63Q==
X-Forwarded-Encrypted: i=1; AKwUvBxOXsxBYufwtGPABp2Mobge2IUJDi1Z99xX88JK1oGxGXjgbLc11XsFBOEucguqEf3INrVzj+iOow==@kvack.org
X-Gm-Message-State: AFuF++mK/JcG84zYonnsqgf3rskMuxdPXQR9VgkBuoImTpwGUY4t0Vsj
	kpBmrmm3+zl9jX5tngxNcFTLzUld/GDQ+pJKlRGppFjtDKBrE2je1yiqEVOsVIGOjNHsPgUAQZx
	gtqe3sMJSxfWt2vH+pge2s2g2G86HOQ4bnbIl4JTzGnIqi30J
X-Gm-Gg: AYBFou3kIJWDdMfk2cR2iTjoredc6Ue7cZdKdWJB8Yq2Rx/3Tt3h9dTLJYSnG5lAip1
	fgymDibO1NlXQRxzULx8OH10ITeL68AQkfz8gh4Udl0Ig8zxvNJSjj37urTMbTnlEyow9J52nHa
	EwrsAmqd921ROlNKAGUpXpqKShqDsoWIL1hVuYMJpa/pp5brQtstTM1sI1h0/G4yVgz6nm99lcF
	n0l3EsYnPJwPMNX/Anx/o9Za38kqHEAJ4+TBZf7GNT047sZmXMIHYBNWYFab+BPnvg5FUwIeriX
	jHqdtuF9Xa4SQgU8y0qSNxbjAjOQo++CAjMjvGENXv0ikyHoMsTJx3tM+9Reuqd494AkF5RnOxB
	ID7dPc54ACL2CXKcIw1SorEkd1bq//nrZQZcODFgxoJNy3+h/
X-Received: by 2002:a05:620a:25c7:b0:93a:2e8:5afa with SMTP id af79cd13be357-93bb78f8162mr56618685a.30.1789514444142;
        Tue, 15 Sep 2026 16:20:44 -0700 (PDT)
X-Received: by 2002:a05:620a:25c7:b0:93a:2e8:5afa with SMTP id af79cd13be357-93bb78f8162mr56608185a.30.1789514443031;
        Tue, 15 Sep 2026 16:20:43 -0700 (PDT)
Received: from [127.0.1.1] (nat-128-59-179-204.net.columbia.edu. [128.59.179.204])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-93b781dfde3sm77151085a.12.2026.09.15.16.20.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Sep 2026 16:20:41 -0700 (PDT)
From: Tal Zussman <tz2294@columbia.edu>
Date: Tue, 15 Sep 2026 19:20:15 -0400
Subject: [PATCH v3 11/11] mm: memcontrol: constify the zswap and socket
 pressure helpers
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260915-folio_memcg-const-v3-11-c239a6010b58@columbia.edu>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1789514423; l=2733;
 i=tz2294@columbia.edu; s=20250528; h=from:subject:message-id;
 bh=gfXjN3rS0S5wCNAreZHf2pNt2WW5g1ntWcz0DrURYW0=;
 b=emYpUpxeMYySXBIAaFOu0+xjuyPwfYFvwTaSgzFVe1rapWKm637OoQF7dwjdaMdFk0pkiDQN0
 2iGK6p4657BAVZ8kUeMyipu+wfuTYfdoQtzBPFfXoE1Jh+I6JIxr+tP
X-Developer-Key: i=tz2294@columbia.edu; a=ed25519;
 pk=BIj5KdACscEOyAC0oIkeZqLB3L94fzBnDccEooxeM5Y=
X-Authority-Analysis: v=2.4 cv=JeEpPkKV c=1 sm=1 tr=0 ts=6aa9d2cd cx=c_pps
 a=HLyN3IcIa5EE8TELMZ618Q==:117 a=hXAsoc/zAxyCEdIRhrpmVw==:17
 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10 a=x7bEGLp0ZPQA:10 a=A0y_DWxS2BwA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Da8U98TiO7q1upZEImrf:22 a=svvvyxlR1OQQkelhaPoB:22
 a=JrvLMZgmaQ4VKr8cMrEA:9 a=QEXdDO2ut3YA:10 a=bTQJ7kPSJx9SKPbeHEYW:22
X-Proofpoint-ORIG-GUID: -0YZndqtI95hwkpm_3DxpfvgsTFO_EtK
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTE1MDM0MSBTYWx0ZWRfX3aOtZfMnkaZX
 e2GsKd64KbLtmjrKaaw50tXJ9SNmoGhHvMnXB4t4lB25Ig3cqp6o5+VnqXTtvyiMuUVFh4otiUy
 lDi0+uc37fD7P/7J/wb7/+p9UaMohrl39Jff6WMv9M+wGlHyS6rimziVO7yl9jmoXaVH9I9PqK1
 QrCY3leCB+wqT1tJN5cxb1WjlVe/ZiedcnRcKqHI7rCovB/rWlYT3GgBRT13bip1rjXg4FBm5kH
 vkO1pNeF8ayA7U9ZgUhAEp1/HWXBC5ZYE8TdAwHB8j4zhRh1XP1vGH5mRzK6v2fAg0co5gwMHe7
 vur6D9A7xDSRJ40zHy+uwdZvT0/0Ut9M7lhyQm1nf7gGc/zS1PHQ5L8dj9vuLjXy+of6NBOuE7t
 RTEXHzerms6jyxL+KfEPl0ZxsHqRTo7+4BU75s0BnasVEIT7qKEAshPboL4lLFflYquMVCgBg3p
 yBOpnA4Dvnd6pxboIbg==
X-Proofpoint-GUID: -0YZndqtI95hwkpm_3DxpfvgsTFO_EtK
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTE1MDM0MSBTYWx0ZWRfX97x2Xx0N5aS3
 hfDo8DmDDqg4jG6KFN1uzVfrsZhOI/DHr+lPy9944LFD0+YXiZFz8lN75uAUcDTVl+d+h3we+ae
 jODuC2rRIuPLjXvuMXuUX0FGa2iOVLm4DxSiRwtynjQme7Kxqfv7
X-Proofpoint-Virus-Version: vendor=nai engine=6900 definitions=11906
 signatures=596817
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 spamscore=0 lowpriorityscore=10 adultscore=0
 impostorscore=10 malwarescore=0 bulkscore=10 suspectscore=0 clxscore=1015
 phishscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2609040000
 definitions=main-2609150341
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 668EE40002
X-Stat-Signature: h7qfmx6xid6r7kectngmcifgup9p6ojh
X-Rspam-User: 
X-HE-Tag: 1789514446-517244
X-HE-Meta: U2FsdGVkX1/NpaCYu36A4q7eX1T+v6QCZd2x0AlCKrxp13F7rJX80fNiZzgtDWEvY3IFEjO9qdUOwGRpjhpkdG/xaQ8j5n6Kd4xp/kWImfkxxCqA1AtvTzLXk+j8W4bX++aFDIrv5qJugtWX5YlQROFzyvTCNh3Ydizh8aZCG0CGvZdj0N4OmRr+OX3LXlIJEjTjtES5s2oPZtb2xv7qR13lFvgy8xnyRtr2TVtZ+1fWNkQISRK5iGV4RsK9TbJ2feTP86coxpS0ENEOaih0kAtbQ8W3X/cNUocdzhIFI7IGgE0nABcobkzigmmGIm+TvRVW6+FNW8LbXHMNR8p6HYJdSmwSQ7PfIEBpkqRVbnieZf7fCYCv4emyrfQtt3H6Y7kkw2bw6/ucUlGHs6pn9W//ZF81o3blBMjaLSIAiHHW3Bao9wtKfbjiNNUxX5wWAMSaaoo5ISpEt/K+mAIiS6tfqHVTQdDuZggUQJiTHcCBSCYUgZESHtoQqfCfsjP6HIq33V970/CGXD7CXTeSU9Li04ysNfHQcDUQBVPcg7HAPqnPE/+zACUc6D7O0uYACoFe7gPZmjVhamB3UVd9kj7LVqI4eKjONJwh8tqfGNLj4zhoQZPTJxXdJJS8kjWq2uZExQdLapbBjqyQNLq7Wplu43AojBSl5mMc3Sgs6iQQ8IdGgzVafXkGtwGTC3dsC6KcfApnUT0PHAB9O/FxwsKWGmEpTHfeDxKvKkg5tCeyRF1qD5fhusaTgoRTZbak0UUCiN4IYPhzIHqZUOKYaEGULQuAfPWCeK7vvUSiXChvxeCoGl46ddrRyGTI42i938GFPixRuGYPOUKwXv4hSQ71LaNISUzqTrNOdk0WARc7yl+uptohpdMtYSFEJwpPw7ukK609U8tItHgA0e6emBOFlHit0DNZv4obhIeRwmNMHBWwp5kdZjF9cb32zs3TPB4RM4HrWfyJC+quNbZ
 H3bOZ3Iz
 YDV6oWD1Xj/G4SRy89a1/b1DlqgNMYNOcWtaEAc16apxM8z+9N2+YKVlE9Z8dmOak94dW0xyBb57xDUAIB24zFsJqcPk9nxNaoCZNiq3FGvh/c55za6HOCKdy7Yu7X4/Mlp5M1TKspj/JfUkUwLK50PYG9E2yROaDaJCjuxDDSA0gJsBdnsa0B3hp3qSVtl+t9i5HFxSONCpaibChYeRzNYyAbAbQ6QzUbZmkNJdGRTQZi8VPE+qjGDpEXMI7O1kLOnX8kpFtbt3nzUaXOTmLNBKUC0BYTQFWKQs7YpAQFEBsVJheYXLZjQ03Jd1y8jhi16JHU2kPqB9bwTXYtwDOJTddYde9N8jhwHTdqup7PoTS1lYLB78n17Hpbg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

mem_cgroup_zswap_writeback_enabled() only reads the zswap_writeback
flags, and mem_cgroup_get_socket_pressure() only reads the socket
pressure timestamp. Constify them.

Signed-off-by: Tal Zussman <tz2294@columbia.edu>
---
 include/linux/memcontrol.h | 8 ++++----
 mm/memcontrol.c            | 2 +-
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index f11899085473..64c183be8cbf 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -1684,7 +1684,7 @@ static inline void mem_cgroup_set_socket_pressure(struct mem_cgroup *memcg)
 	write_sequnlock_irqrestore(&memcg->socket_pressure_seqlock, flags);
 }
 
-static inline u64 mem_cgroup_get_socket_pressure(struct mem_cgroup *memcg)
+static inline u64 mem_cgroup_get_socket_pressure(const struct mem_cgroup *memcg)
 {
 	unsigned int seq;
 	u64 val;
@@ -1702,7 +1702,7 @@ static inline void mem_cgroup_set_socket_pressure(struct mem_cgroup *memcg)
 	WRITE_ONCE(memcg->socket_pressure, jiffies + HZ);
 }
 
-static inline u64 mem_cgroup_get_socket_pressure(struct mem_cgroup *memcg)
+static inline u64 mem_cgroup_get_socket_pressure(const struct mem_cgroup *memcg)
 {
 	return READ_ONCE(memcg->socket_pressure);
 }
@@ -1937,7 +1937,7 @@ static inline void mem_cgroup_calculate_protection_path(struct mem_cgroup *root,
 bool obj_cgroup_may_zswap(struct obj_cgroup *objcg);
 void obj_cgroup_charge_zswap(struct obj_cgroup *objcg, size_t size);
 void obj_cgroup_uncharge_zswap(struct obj_cgroup *objcg, size_t size);
-bool mem_cgroup_zswap_writeback_enabled(struct mem_cgroup *memcg);
+bool mem_cgroup_zswap_writeback_enabled(const struct mem_cgroup *memcg);
 #else
 static inline bool obj_cgroup_may_zswap(struct obj_cgroup *objcg)
 {
@@ -1951,7 +1951,7 @@ static inline void obj_cgroup_uncharge_zswap(struct obj_cgroup *objcg,
 					     size_t size)
 {
 }
-static inline bool mem_cgroup_zswap_writeback_enabled(struct mem_cgroup *memcg)
+static inline bool mem_cgroup_zswap_writeback_enabled(const struct mem_cgroup *memcg)
 {
 	/* if zswap is disabled, do not block pages going to the swapping device */
 	return true;
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 6e3731b97690..d0f1b8782009 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -6304,7 +6304,7 @@ void obj_cgroup_uncharge_zswap(struct obj_cgroup *objcg, size_t size)
 	rcu_read_unlock();
 }
 
-bool mem_cgroup_zswap_writeback_enabled(struct mem_cgroup *memcg)
+bool mem_cgroup_zswap_writeback_enabled(const struct mem_cgroup *memcg)
 {
 	/* if zswap is disabled, do not block pages going to the swapping device */
 	if (!zswap_is_enabled())

-- 
2.39.5



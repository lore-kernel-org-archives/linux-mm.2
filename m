Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 80DC3C88E77
	for <linux-mm@archiver.kernel.org>; Tue, 15 Sep 2026 23:20:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9F0B86B0096; Tue, 15 Sep 2026 19:20:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9B2256B0098; Tue, 15 Sep 2026 19:20:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 852A36B0099; Tue, 15 Sep 2026 19:20:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 682F26B0098
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 19:20:36 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id D98D81604FD
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 23:20:35 +0000 (UTC)
X-FDA: 85217568030.26.DCAF795
Received: from mx0a-00364e01.pphosted.com (mx0a-00364e01.pphosted.com [148.163.135.74])
	by imf15.hostedemail.com (Postfix) with ESMTP id 54D2FA0005
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 23:20:33 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=WbCDuyao;
	dkim=pass header.d=columbia.edu header.s=lionmail header.b=BvwaLmUw;
	spf=pass (imf15.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.135.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu;
	dmarc=pass (policy=none) header.from=columbia.edu
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789514433;
	b=l3Mbc3Dmgh91CLIB2qUIiPnB3o9ppA2RTxUAyoV3T+tSxe109MIqiGQXnxKHz/x2Z1r370
	JMspU+dS/GV19aFC7bY943W7RiScVvmMnwfvlkG1iA4Eoq/ijDw/2Z7ssjca9934Ql8rNA
	Y7AWVxJJrttfJdFjJQHOSuZi5iI+7O0=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=WbCDuyao;
	dkim=pass header.d=columbia.edu header.s=lionmail header.b=BvwaLmUw;
	spf=pass (imf15.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.135.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu;
	dmarc=pass (policy=none) header.from=columbia.edu
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789514433;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=W+SYTc9YgTwbyvQtPG0l4mF2QbsfRfThQCH4AEEmni8=;
	b=ID/MJbrxlnWztrqnYiPH6uyFpO1REcVO5+X3aAFQ19KNa+n0FwFfvO8kYTM1KjCoo/GvWf
	MrZ4Ttgvhw82rRQZg1wqx24TXCWngHQMmw1ikTUdD8Js+K0wS2T7DcDTC6iJal+jpKw13g
	npjnappT4wPG+iiSr8QMu7734FinjgI=
Received: from pps.filterd (m0167071.ppops.net [127.0.0.1])
	by mx0a-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68FMbng74082512
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 19:20:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pps01; bh=W+SY
	Tc9YgTwbyvQtPG0l4mF2QbsfRfThQCH4AEEmni8=; b=WbCDuyaob2YbGQCiOozV
	yIe9RC4/zmMA0eLFXwM7A73YQNwsOwZmCv8DBOlacrAHw2eYuzW+Ia8uFSxjLlpx
	iXtbUFdPD03BZEqAJh2oES9GzKodFOni9hMXu+dhWUkpEahBYODAw8XpEL8hil6w
	JMErRevg7CLUpghoITPIUnJN2Fb8toEGDGAOzchUxuY73PxZK0hf24WEE+Ne991c
	cPmiQdPC40zNLagsBqSmndt7DVO6fl0oOUMqhN16VdF0E0taTzXeUc7+mBizPKY5
	WKumJ8gBkpFfNZIRzIz+cEP9mLpYCpHfbKctlMN4YSF7hUJ9rAIbpV8Vkr76HIrK
	ew==
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com [209.85.222.200])
	by mx0a-00364e01.pphosted.com (PPS) with ESMTPS id 4gqbwaj2fp-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 19:20:32 -0400 (EDT)
Received: by mail-qk1-f200.google.com with SMTP id af79cd13be357-93ae8e7e546so116367585a.1
        for <linux-mm@kvack.org>; Tue, 15 Sep 2026 16:20:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=columbia.edu; s=lionmail; t=1789514431; x=1790119231; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=W+SYTc9YgTwbyvQtPG0l4mF2QbsfRfThQCH4AEEmni8=;
        b=BvwaLmUw5QWFoo+QvECPCQczNnkCq9paOUPq7EVSNcnvGJj/t2bHwA9kr8mcjvsTGp
         SWN+PisC+lM0xqYWE/D6FXkLO7kMr09axp8+A5jvx6rsX4PsSammCbcD9BekeB9I8DyT
         rjz2iSSPx0UErENaEsM7VeigO9K5yU2bWVybbb6NgCr4mV9lDLilvGwJ/zxuA2x42rDK
         F40EWBxciry7yCCVfc0A0dXn0FhIdliLJek/EzdS4jLENynYQY0l+BD6HOZiOdmCOP2Q
         IjRjQDg02huYwLTRDbRQ2xdAcWZ4vhCLl/WWdR/wz7KFiV/1iePUBqYt0tmq8Y2/FQe+
         hvXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789514431; x=1790119231;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=W+SYTc9YgTwbyvQtPG0l4mF2QbsfRfThQCH4AEEmni8=;
        b=HN/TQ7foeDr64lOG0ArUI5Q0zIZ5RdsKEyxpU879j0kR+AYUVUXFDxbJuxkSvNi/A6
         /BB7/q5At+qkH/54PTHMGj2ZmqliF84xnyL10fgff7+M61Eduyp6V11XB1an3uC2raQh
         TW8Zi/t/8EPSGi8BASv/5kj/L4J0lPR6EIdfHIfEbkF9YjgY+i8nz9BsWtyDAxQLNyuk
         3zhoXHyhUgCv9HAZixbN8KvDp5LIvUkWQnnOVJr6m93ZW4Y0XxEnEl9JubEOMnMxrddd
         q2MKFcxpHu90NAJ+SaQq4mYDVpfj9iDuxGbqtgjDzvUABiVSkvqANchv91MTyXDCcfPI
         r2jg==
X-Forwarded-Encrypted: i=1; AKwUvBzjj2HgF2XwCvcX2fjmxSaBiMyNBjS6d1bmF7TWVfBg6ob9wOoMKQ3P4UpMTELS2ClozePVFFnIXA==@kvack.org
X-Gm-Message-State: AFuF++mzlSC3wyoerQZlCVDFvJmLGEyN4hBc7WkoT3Bw/jSfrN8W3iw1
	uXsI1xfWP43wXUVP87LztawCtTDa7SG2FhSzIG5ckUvPZ4SLYU3uM2qerAhol3TwwIZJLwqazsR
	WIH0zFtzCcylG+pRTLPeXRv4NTOAcWvZaMpXZGzNwGbiC5QZZ
X-Gm-Gg: AYBFou0MLjcuKXF854TWF4YPBIE0hrXprbkDGUxnS8ytEqlQ24S5/KERrp7hnyOAdCO
	MOcF1xv8UvGzrPS//l1ATtXrO6Mwg/NJG6UYSZRaCYuAK1sXVYOr9MAwcbYRAZ/BtdfqHDy3i7o
	XXFJRkWBLMaD9Sp57vTlkjciEO0+ZuFfK1NPCMOR3HgYumBw+ezM17AQQu6GQ/71XXT0vTAniSU
	MX+0P5HTrhAwgfx+rkEFqwjx2Bg3xR/etbdvqFc2kHA6Qa2ZWcpJvMWvxzEtQ1WNK/cwpuRmH+g
	fxIw/jV9ly5+eKvmT7SpbAS20U3UY9KhQa6s5IwvFmcbZPfHtNMZWVIVvYT+Ewh1Zn3ISwSiLfa
	kkCdJx/uOjEe+l8Ta4Ete/oYQbNUWgzm4AeojLmhR6biQ0PuW
X-Received: by 2002:a05:620a:390b:b0:939:9eb4:888a with SMTP id af79cd13be357-93bb76a62dbmr56955485a.1.1789514431093;
        Tue, 15 Sep 2026 16:20:31 -0700 (PDT)
X-Received: by 2002:a05:620a:390b:b0:939:9eb4:888a with SMTP id af79cd13be357-93bb76a62dbmr56951585a.1.1789514430668;
        Tue, 15 Sep 2026 16:20:30 -0700 (PDT)
Received: from [127.0.1.1] (nat-128-59-179-204.net.columbia.edu. [128.59.179.204])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-93b781dfde3sm77151085a.12.2026.09.15.16.20.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Sep 2026 16:20:30 -0700 (PDT)
From: Tal Zussman <tz2294@columbia.edu>
Date: Tue, 15 Sep 2026 19:20:08 -0400
Subject: [PATCH v3 04/11] mm/page_io: take a const folio in
 bio_associate_blkg_from_folio()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260915-folio_memcg-const-v3-4-c239a6010b58@columbia.edu>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1789514423; l=1933;
 i=tz2294@columbia.edu; s=20250528; h=from:subject:message-id;
 bh=puRmIXD1Ve7ElQt9KP4DSIyIaDfy+iHVy11lX8uUHlg=;
 b=ErI8Po+B2rZxjluBv2tCvc/GAMAH6HlqV7iBCu1F52BrrDIeskYGbPgmeP+1GO+PyjKeg9FBh
 iNkFxzPrOAJCLaYd58UfeF2w1r5vQcFDYNXXhpcTcYTxktylhrjEiR8
X-Developer-Key: i=tz2294@columbia.edu; a=ed25519;
 pk=BIj5KdACscEOyAC0oIkeZqLB3L94fzBnDccEooxeM5Y=
X-Proofpoint-GUID: JEMnXdIirG88qEqNwRhJLUP_-TxVNddZ
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTE1MDM0MSBTYWx0ZWRfX3UZsqDsaE/Wf
 NWs1H1PJoOba0/X487915y8jv6PicHGfaTUrmpbIvAal8Oxzw0N0EPRJztarCIYn1VDhgDNdcCw
 eq0HdhgrRvSOcoCPbo+BWegxOgyFO+jEz1cful2Ihz7QeN5atRBPXc/U07mY7hYbT9OuTdVnLvy
 jb3Tmn/W29f9uDGx69VOB5Os7NTw3gQYa1rGHdJhmDGpio/xc1lR4WGdCSoZwWU3mDseECNC/IE
 zjIYspb63qInzfI0D15i7wFw5Er7gh4HOQ/fTFq48zNTP0nUJ3ND1824EgG1ZRsBws3nuglFORH
 EwSouGFClco44GsuMil/EjBEvuUZID9xe9jOee7EIMz/XDobM5ymai98vcLru9lW+nCH7cXaLdZ
 a5hfvq2LBWUiYaVAPOstfCMF1LppvY0WIHXBnJxAAgfXDFo8IFTRaCsuvEOvqreqRaMcRfTtjki
 gIuvP7joLSQKXW4xE2Q==
X-Proofpoint-ORIG-GUID: JEMnXdIirG88qEqNwRhJLUP_-TxVNddZ
X-Authority-Analysis: v=2.4 cv=JP2uIMKb c=1 sm=1 tr=0 ts=6aa9d2c0 cx=c_pps
 a=hnmNkyzTK/kJ09Xio7VxxA==:117 a=hXAsoc/zAxyCEdIRhrpmVw==:17
 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10 a=x7bEGLp0ZPQA:10 a=A0y_DWxS2BwA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Da8U98TiO7q1upZEImrf:22 a=79PYxaXUQd1wl-QFWJnA:22
 a=4JVmFDg4bpWGYAirTr4A:9 a=QEXdDO2ut3YA:10 a=PEH46H7Ffwr30OY-TuGO:22
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTE1MDM0MSBTYWx0ZWRfX8ydfrYSLB5qG
 P7+T8X0YoSLKFomlNjYK+m1rB7/uvvWCgLS8mDq8FumtqUgHuRhwH4bdEUo9OcJ+MwLlpl+q7YQ
 Da4jmdkwZCcdtyO1CQDjqa/B/qXajZu0XoptBvVCpBfK9p7fUAbC
X-Proofpoint-Virus-Version: vendor=nai engine=6900 definitions=11906
 signatures=596817
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 lowpriorityscore=10 priorityscore=1501 adultscore=0
 clxscore=1015 suspectscore=0 spamscore=0 phishscore=0 bulkscore=10
 impostorscore=10 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2609040000
 definitions=main-2609150341
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 54D2FA0005
X-Stat-Signature: 4tfzty3fyg1amos7ezrizd8n9rpuk8hz
X-HE-Tag: 1789514433-489908
X-HE-Meta: U2FsdGVkX19F6gXxo5F+UVjwvp5ESYiMmYwblV6HEUFL3ANzJ3M/Hsdw4xuo7jbBsu8JLsh0LovB2K3kRqSFQ31ZlQ8kg4+i+bjTjONti1Qzp4+Qm+Wm4tvxKJfa88cibwtB5hweceufak9LPQOtp3mj7oln/l/bqHOxLlTgdT3rHA9dJpv5LsWqydVuL6+jl7nEXvUO2dClmR26dt+YfI8wkFxdh6ZOdQSybttYLjy2kZNuWL62s7xnnoVN94tIL4XpwKTEaKW7BxS+AD+OliVyWJOqbDfbPvKKzolMeXw+tZ+CdBHqKsdhPYfxZipLsd02jk8djBHcjOBz9RSSRfhVUkEsyllVU/yoFs4DBei6sV5B1JqjXf+ybqeyGbXCMtKZL3+Q6r7fKa6QKMRdnmQmOZeDCDZJFh7WGjCrXjaZuf2x0HZaehLD9hlRqXVZSpwC9xYLOGPmYUHFW7wLkXUrORUpWjwaUw6JQJH/bHCG3Isx1pK2jAimzLmezn7SwzV2ZJwtoh4CGOSnvzw6aIUeLqdumrOqjd4/4Yock1DPwAqAIjRLKNTkFThPCohh7+z52zVtUarFYHZ26eD/7vf34JbCQcWvXLJGVjOcDLOa6pQT4MxuuXlfWHyu3QI5tH1Zw8qvyyUz79hhmJFwy2M/KWp8voDRBvNBJo/fE2HYPOlXkl7I8N5yaZv9BGtS19Zif+Ds9M5wZ578eMuBU7ZXskP3DK1K+ulA/DTGTLZwcodFCakHJTdpqnBtlm011lc9Yj6gNf+DIfuncSK6Mjr/OLju5snkiqI1pa22EWJq1ewjQRGJ9sjP57Yzs8SAgip2nV4MRfP3psdz0o50EdcVgNxFyIeCDQBsqLTUNJDW4+RroYfrFjUfmK/sfsH10E1IJSivIz9VvCrcuGHsJfwWPa1MhZVnRY4P+uN29DotciIbWoK8i1dmrtAkwJ+4JLWP8l2t0yq3Fy+wbgC
 dBm24p5m
 fG3CcrhTGuf9m52ULuW4PlauI/p4ptHa1c8OWITzKOzpOUba+xgYsp0xuIxd18+ybKuwlfdB6QhjIlzj2rPvWvoGyeT8o9CaNt7QTxuBpSYhaBiHZlJn9IIY5PizV05OZ/0Lm3KUN2x7tcIVKOgx1/GPOXMj3pVntudvsFRVhFiENs1JeGEBzBYKn4gNX02TsQ6n7KPhLlhDyFC/UsnBIdhQAUDQNA5C5JXctszaBizyTJUKd3MrPsdHCcuu/7Gr3xf37PHIupjqC4NlrcYRMGXNHqYf1PhuKUqa6dHfkNROPS9/0O/LpZW/McQcjts587CW9h6wNW76uGpseeO8fXtdNeTMVZ0raGHLSZRHrc39ncUPB/FTOHrhb0jFV70bfB6gtmxb/BG6j4brDc8z2RteuVpW5DdZND/OsOqEwfgUemQU=
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



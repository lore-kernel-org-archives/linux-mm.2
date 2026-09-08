Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 202E4C79F99
	for <linux-mm@archiver.kernel.org>; Tue,  8 Sep 2026 15:58:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9BCB16B00AA; Tue,  8 Sep 2026 11:58:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 96CA66B00AB; Tue,  8 Sep 2026 11:58:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 80F366B00AC; Tue,  8 Sep 2026 11:58:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 417436B00AA
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 11:58:03 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id C36631A04E6
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 15:58:02 +0000 (UTC)
X-FDA: 85191051204.11.05A3BFD
Received: from mx0a-00364e01.pphosted.com (mx0a-00364e01.pphosted.com [148.163.135.74])
	by imf24.hostedemail.com (Postfix) with ESMTP id 2B8FA180005
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 15:57:59 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=UgbEefNP;
	dkim=pass header.d=columbia.edu header.s=lionmail header.b=TTKMFvrc;
	dmarc=pass (policy=none) header.from=columbia.edu;
	spf=pass (imf24.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.135.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=UgbEefNP;
	dkim=pass header.d=columbia.edu header.s=lionmail header.b=TTKMFvrc;
	dmarc=pass (policy=none) header.from=columbia.edu;
	spf=pass (imf24.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.135.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788883080;
	b=XSEu072ag+Vxq8wFU1qlhbt1Xukct7t4yc1KSB464oj8tFsyq8r4g6yPusYLjZiU6qmhma
	B+YoytzQl+LrSorTfaHGiprxNQFrR3dh2EMQkfb3kBFT9c1/1eXm6UdaxtFkGi9imTcZj2
	pGXCOUrEk2ss6WMj8D2LVsvfTjRRWxM=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788883080;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TeVVsQIvBZbi+49h4ozI7i7qVRiYtuqemdFb9KMPB8M=;
	b=XjJyIklBnXtnUeeiuf4yKgbN0md7xD9aDowMGm0aUPMe0X+ONw3jccB6kUcF83yn1Bq4Dq
	DLEr7x9FQDk5upNXgfgVp0dBaccPUqmtiDvcnO4tKCiCCnDt1DOGvJNSyfABLOXzpSBq+E
	k4qxG+I/aIK/akIXAzHi7RU3YJdBCoM=
Received: from pps.filterd (m0167071.ppops.net [127.0.0.1])
	by mx0a-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 688Fbi2G2588915
	for <linux-mm@kvack.org>; Tue, 8 Sep 2026 11:57:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pps01; bh=TeVV
	sQIvBZbi+49h4ozI7i7qVRiYtuqemdFb9KMPB8M=; b=UgbEefNPOgcTF4tomGEG
	Q5ckKSUVWPesGosjIwCjoZW/c93h2cEjk4vj+EOjeFstLD2SKjXZuHIXDmPZT3Dy
	3Eb/xPtzA1TLX+Rlak+xLw0bV3udWMJJgUxhYS4eyUTbGqrwIDDi8uNPfgF+w3Kw
	zpaI4o3DlnqODxzJgxaoi458HauGdx/l9LA0HQ1Po4YuE7qk3HyEpcnXRt5AbkZI
	a3MKNpdXaAfSbmNwIpAj6H62OMgwjK4f+cdOJzPGoRsYJfSsdb3AO4b08QEW+1zC
	F3VCp/Vbkbkbjsuxkl3EnPdl2J7lK8pJNyL1hOVVHY5HqpWyj5Y78QGC20D8Fxof
	IQ==
Received: from mail-qt1-f200.google.com (mail-qt1-f200.google.com [209.85.160.200])
	by mx0a-00364e01.pphosted.com (PPS) with ESMTPS id 4gj4d5dma7-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Tue, 08 Sep 2026 11:57:58 -0400 (EDT)
Received: by mail-qt1-f200.google.com with SMTP id d75a77b69052e-5308af39ab3so25816111cf.2
        for <linux-mm@kvack.org>; Tue, 08 Sep 2026 08:57:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=columbia.edu; s=lionmail; t=1788883078; x=1789487878; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=TeVVsQIvBZbi+49h4ozI7i7qVRiYtuqemdFb9KMPB8M=;
        b=TTKMFvrcLZnoRZN1vmz51BOkIuNRN1U1o63VUIwfy3RMUrLCFX4AmsCeYmX10Wc+BT
         6haL40QV60D5gCV8F5eEelA9U7WTZ4QS/jHxDfOHOAhepnCKlW/vB6sINMpPN9dySOc2
         peu9/ZJQmYuNJJF11BhDZwtTVpt7YV1+mQ70h3HH08P6IvlF+BxvjRIK3M1GyuMd+w+t
         +B38D5/k4iN4Z0P0OE9cbWLe2rrFm2VJYkJArbzBcf/od2C/0xDrxco9UlHn9a7AtUM4
         i3wdnMes8P3akgWcyYdPjSdOZs3cGD1VTNDsaM4B9Jo1DdlO031Lq8J0fTmbtyHESaJ1
         ovpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788883078; x=1789487878;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=TeVVsQIvBZbi+49h4ozI7i7qVRiYtuqemdFb9KMPB8M=;
        b=CgphBfg8L0RV2hdiQH0fLrjLxCDUejkCbcy71poprNjJg/0r3qZp1h7+M90LrElti3
         9hkmk0DxsHsLobb0nFZNIE/bkGnIp2EXeqKzaUl3QdpICppCJHlEkHiw7fsln1uuR3rf
         F3ZKGxC/rOuqv8GsCKcHrsYWGPV7ihHb9/oKl+ryb6HtdGjPZTdHlpQSlNtwN/zvbAH7
         tVArtKZjxrZ3YHyd66NYiQ061u7/qwgT5nQagsaBstoOHpuyY+KTZ+xS3ryGJQUg3HaP
         Ws7IIA9qBRxwjW07Sh+YOXFpamn/6BtiWWSSGD2bS8BtvVSqDtHx0SPvDjcRGdMnoW+a
         sULg==
X-Forwarded-Encrypted: i=1; AKwUvBxBzcVsDJm183Tp/oXsILuqAJgI/EY5UbmCAf4S0fO5kJJaqhUazpdzD5hBbadtOCmtuGdvuAA7zw==@kvack.org
X-Gm-Message-State: AFuF++lBqAZpPr1s2bCJAWx8qVOqCMgmEjgiEe71YUQcjsbiEQiqQ7Iq
	E1rOAd24H80o1crA+fFZzxIoSS92LLokJg2gXaBxK1X8cIX5NPlPXdC7zW+K3e/uX52b+NYJCnt
	Qwh60ovsgJKMkjnNYIVTudXKEtyKIiGwtzOvFIUKVnw3/FTdd
X-Gm-Gg: AYBFou09v44adn4XQgGmREuH4iuPiTjaUoxo3qqsQzxm88GwyGfwtfXXf99b0Qmww12
	TjK3ERb0CGqgmCDOeGFa7c+2UNfHCZEuEAfaWH6W9ETs3pGYMK5myAK/RgcP+l2HzlY0Tr/b2cV
	UUQNelHxqDI37ROe+AByxmxh7p6TOiXwfnbopTTVuluh7XhB8jZ+qXA2yZJB3KVQK7m6KjO2vgJ
	EIRZoN4D+0VHfMIYRufeK0upsEj7s+T+KYoSdjVeRVQMgir8UP5IRrbXKXH5VatW/XL1NPPR9bh
	Zd/Zt6CzQ3t9NaORzTbQMEeN9f1z9q+XE2YVAtPxY4PrqQ1/3n1aCq+4snvZcp99Wgw9zFkwvQl
	zKfhKq1tGro6QhZzYZh3zJZ8oP/q1EJgLsYEkhAk1vQyhE617
X-Received: by 2002:a05:622a:5a10:b0:516:d699:a99b with SMTP id d75a77b69052e-530549ef2b5mr388066861cf.40.1788883077596;
        Tue, 08 Sep 2026 08:57:57 -0700 (PDT)
X-Received: by 2002:a05:622a:5a10:b0:516:d699:a99b with SMTP id d75a77b69052e-530549ef2b5mr388065961cf.40.1788883076997;
        Tue, 08 Sep 2026 08:57:56 -0700 (PDT)
Received: from [127.0.1.1] (nat-128-59-177-174.net.columbia.edu. [128.59.177.174])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-53093295584sm27830461cf.13.2026.09.08.08.57.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Sep 2026 08:57:56 -0700 (PDT)
From: Tal Zussman <tz2294@columbia.edu>
Date: Tue, 08 Sep 2026 11:57:46 -0400
Subject: [PATCH v2 10/11] mm: memcontrol: constify mem_cgroup_swappiness()
 and mem_cgroup_get_max()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260908-folio_memcg-const-v2-10-811e9f443409@columbia.edu>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1788883062; l=2036;
 i=tz2294@columbia.edu; s=20250528; h=from:subject:message-id;
 bh=7T7rpGdGl80eIczyk2CHyU6fksQb5qaA/aOGDxxYlJY=;
 b=dvicXk+cWpKuYHJz87hjtQBtNMgPgIsy8I6NedGtASQpZSrvjzaXdf1eVZoDbdE5vuWL5jJic
 VYpcQmfMVY/A2GP80eVvqyCVEeLqg9nsU1PjNsZLY5vt+AATTdIhosb
X-Developer-Key: i=tz2294@columbia.edu; a=ed25519;
 pk=BIj5KdACscEOyAC0oIkeZqLB3L94fzBnDccEooxeM5Y=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTA4MDE3MiBTYWx0ZWRfX0jKvEHUR0H3P
 knyRmKV3bQ6Ctm7GjjpxRgQgXwcjj8lHd5Al7TcY4s9kZ/OF25AEPnHTFUwHTFG5KQWrl+LUqDT
 UTujZ3jQiZxtIfA87qDJuUiPX39vmyeRzuMxuPvmjM7j4ykWlXF5ivI1RDEx1XrvwiRaeSXn1cH
 oW8dmSF4HgTsXWsi/K7+vdeKMqhhcyMzvkI+xJlZeJ4cJb7k+L2WAvBn4QCgeIeKt+BgGaC2lBO
 m7yQJcKIOoKyEyYv9bMFnPfkXb9JjhDEEGoecCX34m6CnQ+PO1Zgq17v8/03k6HaTnlhdnHWcZA
 2xchG2ocAQNCnabqw7HNV+CFhkHE3iI3X3FeF+y9YtaQQnIuI1/qBZ3512SbjSDX0vm+/bnE5KW
 Yr5dzzESUmVdjauF8jaTHA4vqzsNPq11tKGW0HsAQ2t0e8+z4ZsM2iw9gdxE+B4toCuNnFY2vmA
 IHcqSTsKlpTpE+QlwsQ==
X-Proofpoint-ORIG-GUID: N90sEDVlhCUwyw7SzuAJu02L20B8Tfn9
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTA4MDE3MiBTYWx0ZWRfX2iw3s5jh9i1v
 AInB1kI5AN+oNdsw73HJ4qw/3SAbEMsSQ6TFLKtGwB2eI34jbyOaAB2tOkWAENfa9vOePSpzTAv
 jCwb6w/mG97Iaeb6XjzdUgU0/FU/N8rzX1rMZz+a4+Ek/pnJofnV
X-Proofpoint-GUID: N90sEDVlhCUwyw7SzuAJu02L20B8Tfn9
X-Authority-Analysis: v=2.4 cv=BqCtB4X5 c=1 sm=1 tr=0 ts=6aa03086 cx=c_pps
 a=JbAStetqSzwMeJznSMzCyw==:117 a=HBUb3goEnnz3w2smY6d+Hw==:17
 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10 a=x7bEGLp0ZPQA:10 a=A0y_DWxS2BwA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Da8U98TiO7q1upZEImrf:22 a=79PYxaXUQd1wl-QFWJnA:22
 a=LvCEVWXYBYKFGHUOtEoA:9 a=QEXdDO2ut3YA:10 a=uxP6HrT_eTzRwkO_Te1X:22
X-Proofpoint-Virus-Version: vendor=nai engine=6900 definitions=11900
 signatures=596817
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 suspectscore=0 adultscore=0 spamscore=0 impostorscore=10
 lowpriorityscore=10 priorityscore=1501 clxscore=1015 bulkscore=10
 phishscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2606150000
 definitions=main-2609080172
X-Rspam-User: 
X-Rspamd-Queue-Id: 2B8FA180005
X-Stat-Signature: 3ucosdeggmbyjkfj68tyfopkcc7w38eg
X-Rspamd-Server: rspam01
X-HE-Tag: 1788883079-501377
X-HE-Meta: U2FsdGVkX1+zBTB4uloV+g5ptJfNWWzUyTiq7AYuyLK4btEoV9FKRyR+zRCys74UZQdhd6vn7alIFVs20UzUD0OiiwSwio5xB0LV04RBmLMW97jzEMQJ72loru5b4Uptfw1AP8D7Dc4jS/8zMPrzuMpx6ijlEgKg4B2IhvNe7gIri3KTVWVwZXPRiUOkB3s/tq7ivc7NB4M8mF/iBIX179FHNGx2eoI5iD9gMHpmZb9SEFsIf2Q3WRNbQmgrRlu+ITXbVMeow2JJy3Mgtg8zW75ktIH3tvtmSUXmC/pha7aJWytvtf4OICT3uZ9oiMnoSHL76l2XjGTdmiX9fezqtBQ8YXHXXUN1pGjN7kZNTKRmI0z7AQPySGRho3jLXuot96yO6uhyEPMlynxwSTb6k33u7zfwLHdnI/2bycyWXBi0bMMZAncPSn1d7oT+zrd1Kb8a9HyuishvVd2B3MY+zfUPo39j9vmnFRjnye8uzXM5Px2FT9BNON4l4dMM73dwRH7oag43CHUNMrx5LwuWA5fNJRCZgK354G8GRjpGeWoYGdzJCF4SGiNmZObwa3MYGhvPVDYKNcGqdgCcmn6ezDgfDiaAhicJ8oSBX46ySSo3zplS4L8jX19Y3WGXxmzSShGxnQ5IywgUohz866Va0tuUDenvRYf8vxTqAD+2FU5ZrQnKaG3/Bzh2t2gZxCX6Brx+aivbOklgblpPBznN0ExXwInmoBgefvQCC/adPA7pWABTc9ahvuphsGHht6BZIBnkFLc4CC6rz5k/Nvkk8K31IMZ5ubwYmobzp52J0IRUs+g408Kjmmf2QFM//y/nRclRUvFv1ylKcTRY+IgAjk80mEcdkqL+BABWiCeVlt4ISxSa+8cGj1ZPVOR7sDzvipctuoR2QWMBdzs6SeqM5KWVIcJcXlUmQcnw2xbPfYJF+skXpGaw+pfgamEp89iRp2XHCnqjYPVO2idklgu
 CknzLfj1
 1ZxO4MDV+WD7zJEz2YfDUkPKSekdxp9x+NWZeDBHtx98hiHKRz4/JNQCojaXShy+6rQ2mNoFPlXic0C9twjpSYHbP889xOkhHkUdS+EUgbMB6ri8PKHccablHKLh8ZiSDerH1EoKFo1zApL3InKXcz+D3650E1Ai3OjllH20lgOZUQyW2W/n/0WkjIC8BPxvECXbkoxMvyMO6+KTG8cTPv/E/Scc98C7jwY4phdsUySRVH74dOgyxCCJp7Ka4RH9v6fH1frSTP+1KjP1tgdwiIaKdhX9AeOKn3LMxDdS6/nX/Qqw1Vz9A0eRL/fCJ5EbUajBNFToiFFADO8L0y1Q8kw05LNoYp5FHPaFxtOncnzFpsVcoR3MruNtOcob6ljG7iIKGbNPLuK+RfBqzEKdjirQMu+coxc3Z7DW14jEoGOsXsG4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Both only read swappiness and the memory limits. Constify them.

Signed-off-by: Tal Zussman <tz2294@columbia.edu>
---
 include/linux/memcontrol.h | 4 ++--
 mm/memcontrol.c            | 2 +-
 mm/swap.h                  | 2 +-
 3 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index d8600f1444df..9fade4667d9b 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -941,7 +941,7 @@ static inline void mem_cgroup_handle_over_high(gfp_t gfp_mask)
 		__mem_cgroup_handle_over_high(gfp_mask);
 }
 
-unsigned long mem_cgroup_get_max(struct mem_cgroup *memcg);
+unsigned long mem_cgroup_get_max(const struct mem_cgroup *memcg);
 
 void mem_cgroup_print_oom_context(const struct mem_cgroup *memcg,
 				struct task_struct *p);
@@ -1372,7 +1372,7 @@ unsigned long mem_cgroup_get_zone_lru_size(const struct lruvec *lruvec,
 	return 0;
 }
 
-static inline unsigned long mem_cgroup_get_max(struct mem_cgroup *memcg)
+static inline unsigned long mem_cgroup_get_max(const struct mem_cgroup *memcg)
 {
 	return 0;
 }
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 0fcc0ff587fc..4de2aee45ac8 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -1884,7 +1884,7 @@ void mem_cgroup_print_oom_meminfo(struct mem_cgroup *memcg)
 /*
  * Return the memory (and swap, if configured) limit for a memcg.
  */
-unsigned long mem_cgroup_get_max(struct mem_cgroup *memcg)
+unsigned long mem_cgroup_get_max(const struct mem_cgroup *memcg)
 {
 	unsigned long max = READ_ONCE(memcg->memory.max);
 
diff --git a/mm/swap.h b/mm/swap.h
index 0b5d507739bc..94714d9dd003 100644
--- a/mm/swap.h
+++ b/mm/swap.h
@@ -82,7 +82,7 @@ enum swap_cluster_flags {
 
 extern int vm_swappiness;
 
-static inline int mem_cgroup_swappiness(struct mem_cgroup *memcg)
+static inline int mem_cgroup_swappiness(const struct mem_cgroup *memcg)
 {
 #ifdef CONFIG_MEMCG_V1
 	if (!cgroup_subsys_on_dfl(memory_cgrp_subsys) &&

-- 
2.39.5



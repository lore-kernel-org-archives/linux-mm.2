Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ED506C61DB9
	for <linux-mm@archiver.kernel.org>; Sun, 30 Aug 2026 10:33:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B0CB66B0088; Sun, 30 Aug 2026 06:33:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ABDE06B008A; Sun, 30 Aug 2026 06:33:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 986166B008C; Sun, 30 Aug 2026 06:33:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 681B46B0088
	for <linux-mm@kvack.org>; Sun, 30 Aug 2026 06:33:30 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id DB96B802BC
	for <linux-mm@kvack.org>; Sun, 30 Aug 2026 10:33:29 +0000 (UTC)
X-FDA: 85157574138.11.3811276
Received: from mx0b-00364e01.pphosted.com (mx0b-00364e01.pphosted.com [148.163.139.74])
	by imf28.hostedemail.com (Postfix) with ESMTP id EB509C0006
	for <linux-mm@kvack.org>; Sun, 30 Aug 2026 10:33:26 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=UrN5Y7Al;
	dkim=pass header.d=columbia.edu header.s=lionmail header.b=yBmqukGl;
	spf=pass (imf28.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.139.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu;
	dmarc=pass (policy=none) header.from=columbia.edu
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788086007;
	b=wyznqgSbB66ZlYwhQQ5CiTSlRs2u6o58UuEimfimyQLOAnT4YErjArnq/5UcOqVmI4pHza
	Qo+ENXjy3WtgInPG2deSAuk+OE/dNK4oHPe3BtvQdqVkGzSd+tzJRWdwrRLK99bl+wrqGN
	ItPj36E7LOZ8hr+Hbp5NqUY9V6dq1fg=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788086007;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=Dmcr4tzCXL4F7wgRjqJeFcGn1Q75Cerw60dFrdsb/pM=;
	b=Z4EcWZwbDZAfrLfpf6o0rPS43AOqyuw7LFhW62vv+kFGOCc28D77KiHum7wU2st0M05XU6
	aKscOjjmnqG30G8rAfqdfRN+XNQ4MzzsnnryVGJZHTxekbH+k+YFwWe9I1lZIWKAwtJq+S
	D4giZO5WzTPCLqVKtaeeZd+C2drwDow=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=UrN5Y7Al;
	dkim=pass header.d=columbia.edu header.s=lionmail header.b=yBmqukGl;
	spf=pass (imf28.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.139.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu;
	dmarc=pass (policy=none) header.from=columbia.edu
Received: from pps.filterd (m0167077.ppops.net [127.0.0.1])
	by mx0b-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 67U9mmqd3220594
	for <linux-mm@kvack.org>; Sun, 30 Aug 2026 06:33:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=pps01; bh=Dmcr4tzCXL4F7wgRjqJeFcGn1Q
	75Cerw60dFrdsb/pM=; b=UrN5Y7AlAfBbY4Fy/u2SJtnyl48+/thxogZMawq5vx
	GWDobDYzCPueT5SwmQqcFvh62bwzdLbPA0voxbttGPICDfjCp64zUixpqjHKv5M1
	60fDqXYLjHpqE4RUq/8b4UwHFwB8u+06Nm46g/H4mqnh8+duSlzN4blTnsZG1puW
	1cS5jLJWugFVEOIgAC/bcsaqQw5tqU373L1NN2rn4hsTy5BoFe0bQgt20RPpSYtn
	x/qBuhiaxKDwIdoDnZp+iwOV7pWzdAEXUfgXn5q7wxef/9rpinE0x+SOAwds3jM+
	gbL/t3e0nkJZwlwf2aJsn3xRZfPIV/wgtzdPB9V6UkzQ==
Received: from mail-qt1-f200.google.com (mail-qt1-f200.google.com [209.85.160.200])
	by mx0b-00364e01.pphosted.com (PPS) with ESMTPS id 4gbs0pvvq5-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Sun, 30 Aug 2026 06:33:25 -0400 (EDT)
Received: by mail-qt1-f200.google.com with SMTP id d75a77b69052e-52f52ccd459so37867951cf.1
        for <linux-mm@kvack.org>; Sun, 30 Aug 2026 03:33:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=columbia.edu; s=lionmail; t=1788086005; x=1788690805; darn=kvack.org;
        h=cc:to:content-transfer-encoding:content-type:mime-version
         :message-id:date:subject:from:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=Dmcr4tzCXL4F7wgRjqJeFcGn1Q75Cerw60dFrdsb/pM=;
        b=yBmqukGliyAO3xIpOjZIcLLlBFA7M4lLVuB/l5Zet4ZxfUaKhMH5iOvuXW+9OEpncH
         I5oI3GX1r7wcleSLLk+8m67xgyl9v0XhTT8wIPPFeI8n1yyGn/ePOaWiiHP3Q7SnxR+N
         sXawfdlSCSoHD49jb/Fc/WuIx05huogS6A24SHKc/B0fLW4iXf6sGumzBUWvgpAXMj8P
         V87vubP+6K2wDtkk3pkdmEucFFw8SdumsOD+G9jmggsGJCQQwDV+gCNhGaMtzvkDbgzG
         JMbKnHjeEtfSFxjYaBL6ZO+ZuExbS8tC9Nwol8Cnx2iztwAJgW2pKVE9TRQuhXJmwOPf
         pjtQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788086005; x=1788690805;
        h=cc:to:content-transfer-encoding:content-type:mime-version
         :message-id:date:subject:from:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=Dmcr4tzCXL4F7wgRjqJeFcGn1Q75Cerw60dFrdsb/pM=;
        b=E3fjhnZdhMOUb3IypjnD5D9LETqGvbQk40NbPyDy2S4B0ib6s3PpD+aEzje+XAntjy
         gwcD2Vgb0JqsuVGNumYJdwoaWdnwnn0RwUINX32DMVb7gOlvkZVCJoeylpINWFXLTsZ/
         n3qtwYSwx0I4/5fJ9p3n7a1k7/CTvYjb6qLpHeWYVUBQnqTz8jkj2/AjVg1xu9UQ4T5j
         8515eGmQM12ODzb+UeEebnVym+Qn2/DRGiRIoapUU63gXxdENRZytkbZddWsRMvPACOK
         v3pZfsuKkNM54V5qDu/J2/OKrSajobGvxFWRchWU8WuLfubTVqN2LhDiCt9CiyYE0pWm
         8c4g==
X-Gm-Message-State: AFuF++kBx3ubxsM/y6W+BmR7u9U+NGk3oYN++jomuNnB/FfcPIQb8NTR
	o8Y0sLVUxrfhs/Wv6/b77xz4Mes44+iJfm0Bp/nKOV6JK66LmBW+Q78wb4bUjGKOiHeV17TqM5j
	S0x1DQhI8vDUwFBwaSGr2pnKfmR1/zu4ipMjUjAOazxEqjxDb
X-Gm-Gg: AR+sD11GDZmb/8l1+oUUpKhpXhESAkVAVBV0ImNc75YtxLHRP8GD5vPiI4WUJNYTr08
	jKQJamfj2tLjkDAsD+Jp/d0HdxJCBbcsu5vgMicNc7ur+IIca+RNI4W9UehccbiD05ba48CVZI7
	Hq/UDibtPMGXxblF3UacZ2EcLw/oDoF14bpF09lRXghOScNLXF9Ftz+b/IhTIDVE1vPPoVDu0Iz
	6qinxTEVp4/o9bjvU06Sv/agul7zlHr9IwR5LuG9xujqDrkdFyt8mVaTvWAVLAa7rXgPitpcqro
	Ha23PCDgZnhxDCbwRP60ZDXOCHWfWr8jD1Y3UuSGBKwt7nFETvZLndyNiSNSZSWPXDJGvWLPv2d
	q6S9IMCETp6/9uc24cIC2HeSVAmYRDLrSZjPNdMERag==
X-Received: by 2002:a05:622a:4d44:b0:52d:7b6e:4986 with SMTP id d75a77b69052e-52fb94aca06mr249247231cf.23.1788086004553;
        Sun, 30 Aug 2026 03:33:24 -0700 (PDT)
X-Received: by 2002:a05:622a:4d44:b0:52d:7b6e:4986 with SMTP id d75a77b69052e-52fb94aca06mr249246751cf.23.1788086004114;
        Sun, 30 Aug 2026 03:33:24 -0700 (PDT)
Received: from [127.0.1.1] (bzq-79-179-7-133.red.bezeqint.net. [79.179.7.133])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49ccf5a580esm69304005e9.3.2026.08.30.03.33.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 30 Aug 2026 03:33:23 -0700 (PDT)
From: Tal Zussman <tz2294@columbia.edu>
Subject: [PATCH 0/8] mm: remove page_swap_entry()
Date: Sun, 30 Aug 2026 06:32:22 -0400
Message-Id: <20260830-folio_swap_entry-v1-0-7786b52acbc8@columbia.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIALcGlGoC/6tWKk4tykwtVrJSqFYqSi3LLM7MzwNyDHUUlJIzE
 vPSU3UzU4B8JSMDIzMDCwNz3bT8nMz8+OLyxIL41LySokrdVFPjFDMLM0ODlFQDJaC2gqLUtMw
 KsJHRsRB+cWlSVmpyCcgcpdpaAN3xYOJ0AAAA
X-Change-ID: 20260807-folio_swap_entry-e53d68610de0
To: Andrew Morton <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>,
        Kairui Song <kasong@tencent.com>,
        Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>,
        Baoquan He <baoquan.he@linux.dev>, Barry Song <baohua@kernel.org>,
        Youngjun Park <youngjun.park@lge.com>,
        David Hildenbrand <david@kernel.org>, Zi Yan <ziy@nvidia.com>,
        Baolin Wang <baolin.wang@linux.alibaba.com>,
        "Liam R. Howlett" <liam@infradead.org>,
        Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>,
        Dev Jain <dev.jain@arm.com>, Lance Yang <lance.yang@linux.dev>,
        Usama Arif <usama.arif@linux.dev>, Kiryl Shutsemau <kas@kernel.org>,
        Lorenzo Stoakes <ljs@kernel.org>, Rik van Riel <riel@surriel.com>,
        Vlastimil Babka <vbabka@kernel.org>, Harry Yoo <harry@kernel.org>,
        Jann Horn <jannh@google.com>, Johannes Weiner <hannes@cmpxchg.org>,
        Yosry Ahmed <yosry@kernel.org>,
        Chengming Zhou <chengming.zhou@linux.dev>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>, Mark Rutland <mark.rutland@arm.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Tal Zussman <tz2294@columbia.edu>
X-Mailer: b4 0.17-dev-db0b7
X-Developer-Signature: v=1; a=ed25519-sha256; t=1788085997; l=1676;
 i=tz2294@columbia.edu; s=20250528; h=from:subject:message-id;
 bh=URqsD108Ktb7Q1ul6tJPwzbY4nIKxLZRUx0agGsKnfc=;
 b=Vbu1vdG/yynRHwQQgggtra/gysbc3tRr4M+3u9Jf693fE4TvPp8VylrcVsbN5b3J6pcxUbsgp
 qB3DhfuPzdhCqmnLZqz/XufM/PRKZAua1WrSRVFIPkcEVAXKk9HZwVG
X-Developer-Key: i=tz2294@columbia.edu; a=ed25519;
 pk=BIj5KdACscEOyAC0oIkeZqLB3L94fzBnDccEooxeM5Y=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODMwMDA4OCBTYWx0ZWRfX3dgnszbJZ7PG
 IOstNCzk7KjLql9uNIi+LxFDJcjLOtxjk9xju7rSMZ3Y8u8a1AQoKAWgR2KhAtQzufNwJbh7PVZ
 +5kPlAqDbEoE+Wg8Uj3dpT0+vTKwNlpxWT4WI5YCbMw8dMrh4XkktGtwutPfmTV4L4B0KBeXku7
 vC5KoRDgdY6wafTM26RvWKOkbN3EvgNpM4echhuLJtPlZfj2vm25EAuWJZQ5qKecDRYEflnCPW1
 j6wLlhMfeN+8nK0zLkimWZAeejBYY3q7LdFfHp3kkNExSvfSBFQ8xuqMiS8xMsPucD3J4PzG7hZ
 Y0ZgNjj798YVc7sB4OYQKFQRnEeZkmDmRvNQNOqKw4e8BLkn7g0iDaUV1jFMMsz5enRs8kuDX7J
 Qc6YUiia7gf5Q/5VNYiKhEf139PSzKnWKHSe7gPDW6HCT4xFGmwaH1c+c/NL6fmabMKE/GAocfW
 i9Y2E/tPj2/lJWnHVMw==
X-Authority-Analysis: v=2.4 cv=EtbiaycA c=1 sm=1 tr=0 ts=6a9406f5 cx=c_pps
 a=JbAStetqSzwMeJznSMzCyw==:117 a=LRATYcvZeiQrLRB5MfbBvg==:17
 a=IkcTkHD0fZMA:10 a=Sv0fKeRqtYgA:10 a=x7bEGLp0ZPQA:10 a=A0y_DWxS2BwA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Da8U98TiO7q1upZEImrf:22 a=QOCMdifcju39GKoXhKua:22
 a=FVoBsLlWJ5wMsLtFyMMA:9 a=QEXdDO2ut3YA:10 a=uxP6HrT_eTzRwkO_Te1X:22
X-Proofpoint-Spam-Info: AW1haW4tMjYwODMwMDA4OCBTYWx0ZWRfX63IgR2IuNS8d
 FQI2R1Sj9tvNXkdpisv+A8tvvFNAEKNvPUgKNF47+MuqmldC47T5VeuvKKKmkXbMTJ8mQEibLga
 eAIsi++xeKUuQdpQRSUYGJESib2upCNzU5gdVdHjXhEYBc54KySU
X-Proofpoint-ORIG-GUID: s1b8QCjaIfURPk57oWEHVsEjxDpUpJQd
X-Proofpoint-GUID: s1b8QCjaIfURPk57oWEHVsEjxDpUpJQd
X-Proofpoint-Virus-Version: vendor=nai engine=6900 definitions=11890
 signatures=596817
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 malwarescore=0 adultscore=0 lowpriorityscore=10
 spamscore=0 clxscore=1015 impostorscore=10 phishscore=0 bulkscore=10
 suspectscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2606150000
 definitions=main-2608300088
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: EB509C0006
X-Stat-Signature: bmdpcdj7w697fqum9r9stexej5rhenqe
X-HE-Tag: 1788086006-597849
X-HE-Meta: U2FsdGVkX1/tSZPkxID4m3qK1L8fFBAfBDoDbYlMBmqZcBvt3RT6ftnYtV22ao0iv5Jbmipp0WniWEl4Kf1VAkV2jEvyMVL0mkyxNPt4WOaYQpl8UVAyas1+DYMEHhmMMW4GPJwV4uAg3N+HL+vikLATn109C701NuNiR3GHAyiKwzKgDjATYmLiv1ikkcLVfC+COse7lbspGWHeY+lWNxSdRP+nxqVDd5yV5Z454HKgPKfNFZXvH86Tn6VWL2Co4IYsSAtctpW/SNH+7FnQgUswMwhUTrFn93DBb0yqS25+CadZ/IyDeWdKht2TvzEHe7rnA7gUodFsrJj4av4mzrWKaj3r+cP52Ffo4xkwrlmGVZ+w7zdPhCJVxM9qLZdWZjOouyE4Qi9ZHvnXfM2LtcBJ9+LXt0X5Yo2S0Q7RLursG/DYOoAuJtXeastGL9VBYK+dfTWVJHdzJjOcIbMJmBy0S+n++rUMKn6GhymMIs3pXMvfSGB5iwqiFyiVQXCqkBi0mq4TGHDuw08GOOUFFOQSLGyy1BrFiAXVXdbkCOFZeo2s4RzGMzpeMh6BcMEiv02bCFi8nWrPwvLwx9DHlZ26uBpfghlqw/qfnWZWr/Jz7k8CC1T0FTI7vlcYSeQYJXfXS9FMJeZmuMwL5EF1iCTDI0TSjN1T0Yl2jxeLLmvi1o2gM0Bim/Yp4hXk75wWnxMBlOaZp58+so7g9Kc0rz3bH2SIfsg94f4jA+DI8UU/qUJ8JKrYS5C/a36YQXu3UDrzWSbA1RyXorgVMMwIp2kIvMIX4Vwr12BMbWb6Yvs+WRVJDwI8tlsfl2ZgeArvI8iPEIlX8lzOHDK/KgJqy0eMLV7Vl2aiUpYyL21UkIC8jo9sS2e6h/Ncz/Fx6yk06BUJmcpxdqmB5S53DUA9zfj/C7Fb2vMbJx0cJ2hTekvid2n3QIWMzJFlBUASsDFdZT4Xw8NX0ooE3rnBhup
 U+U2+dby
 USJnZHZURRapyg2WNJchtcQwgxtveXKSsppRss4kVKqJSXIYcsYCcCCl46Mo5KZ0VdOglVktKMcPyozMI6UFHyEsiIH664jmxYOGEUUrU4rFnmx+V90RyNpQ7beHZjZgCNLyCtMrrsPd99Aovqw5yVmbxPMJYPdkh75V6dAjoDaW0KOL2ucDohvi35XKDkT/bzlYSWVCgN+QefIRKF6P3ufV1dgt6NVKgmwR8Ofg/H8YTJu/YGkZC6d43yW1idXZVshh6YqKcXwso0Npq3FDHt3o1DOx8AXvhRX1Bdcjqc7p3CNT82VbJ9jcoX6kF98snsvGSfRLrHq2ZOnoogXW14LkvFmnCXsc/GO/ZYPRjP4dLKXJELfP8CabDpXnXnCSB8sxhAqGdkVCdM6gRaAr0i4xEnAkTlnflCFTToU0vAxC4bDw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

A folio in the swap cache occupies folio_nr_pages() contiguous swap
entries starting at folio->swap, so a page's swap entry is just
folio->swap plus the page's index in the folio. The swap entry is
folio state, but the only helper for it is page-based:
page_swap_entry() takes a page and recomputes the folio its callers
already hold. Several callers avoid it by open-coding the arithmetic
on folio->swap instead.

Add folio_swap_entry() and folio_page_swap_entry(), convert all users,
and remove page_swap_entry(), with a few other cleanups along the way.

---
Tal Zussman (8):
      mm/swap: add folio_swap_entry() and folio_page_swap_entry()
      mm/huge_memory: use folio_swap_entry() when splitting a swapcache folio
      mm/rmap: use folio_page_swap_entry() in ttu_anon_swapbacked_folio()
      mm/zswap: convert the store path to take a folio and index
      mm/swapfile: use folio_page_swap_entry()
      arm64: mte: make mte_save_tags() and mte_restore_tags() static
      arm64: mte: pass the swap entry to mte_save_tags()
      mm/swap: remove page_swap_entry()

 arch/arm64/include/asm/mte.h |  2 --
 arch/arm64/mm/mteswap.c      | 32 ++++++++++++++------------------
 include/linux/swap.h         | 30 +++++++++++++++++++++++++++---
 mm/huge_memory.c             |  2 +-
 mm/rmap.c                    |  2 +-
 mm/swapfile.c                |  4 ++--
 mm/zswap.c                   | 25 +++++++++++--------------
 7 files changed, 56 insertions(+), 41 deletions(-)
---
base-commit: da6c37ed8beb273e3308e42d4bca3ce11b4432fa
change-id: 20260807-folio_swap_entry-e53d68610de0

Best regards,
--  
Tal Zussman <tz2294@columbia.edu>



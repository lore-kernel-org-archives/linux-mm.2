Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6EE99C79F82
	for <linux-mm@archiver.kernel.org>; Tue,  8 Sep 2026 15:16:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 774206B009B; Tue,  8 Sep 2026 11:16:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7240E6B009E; Tue,  8 Sep 2026 11:16:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5F2696B009B; Tue,  8 Sep 2026 11:16:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 3CE7F6B009B
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 11:16:48 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id CD215A077B
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 15:16:47 +0000 (UTC)
X-FDA: 85190947254.05.F71AC0E
Received: from mx0a-00364e01.pphosted.com (mx0a-00364e01.pphosted.com [148.163.135.74])
	by imf16.hostedemail.com (Postfix) with ESMTP id 36C57180011
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 15:16:44 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b="in/n1AU8";
	dkim=pass header.d=columbia.edu header.s=lionmail header.b=hXpV3yhE;
	spf=pass (imf16.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.135.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu;
	dmarc=pass (policy=none) header.from=columbia.edu
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788880605;
	b=zkDBSTEuD2UDxveVaVgOOjL3iSwoFCYm1hI4Hg+oraZwvigMblk25x5QNzQDgY30FCBKvj
	vwzkxn/Kv7aifGOFdDW4+UjAC38mK9FWC42F0lbINqeOI01AQEwLGTL0VMiKPtO/Po3ZCF
	eMPR1ihAdx6Tz40eQUwom0sLHAQbv8o=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b="in/n1AU8";
	dkim=pass header.d=columbia.edu header.s=lionmail header.b=hXpV3yhE;
	spf=pass (imf16.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.135.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu;
	dmarc=pass (policy=none) header.from=columbia.edu
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788880605;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=7KTq1kvrsMit8SFzKcwQG7/KUyhDzvAvzAS7QNGVsPA=;
	b=szkGINLC5vqEoQPZnA10YHFZBEOXbuqmUmyWbGtT3bMRzKlPdfa17muFc4abl7BoowokpZ
	GjvriazThiGOgjpS7gzBxvJawadVghY1FVro/V0dTGDPTvOoEN3GT3QPyNwbjiQBjKjHO7
	9+RORdOuScxnqMAEaYeVuhs84AwTBMw=
Received: from pps.filterd (m0499199.ppops.net [127.0.0.1])
	by mx0a-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 688EYlqf1082084
	for <linux-mm@kvack.org>; Tue, 8 Sep 2026 11:16:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=pps01; bh=7KTq1kvrsMit8SFzKcwQG7/KUy
	hDzvAvzAS7QNGVsPA=; b=in/n1AU8hwERwEDKE3bsHQzCHdN8PKao27b5V92xL5
	ZaiUEQGmekNAL3glvpAW1aqYF/G3hgj+A0bjx+L6cO5knmTAly//PFEF8phzWE8D
	DTpWJAVpetifMXlEZHakVuAL04Bk8G289rEVn/t9lyiABm4y2yS+DP0EPoenATiq
	xgcU5rh68dZtp+ZnZD/of3fd75s8DPIFsin/c3c8e+gGkZPLahmGKnWFbW77SADj
	K3r1NZUZr9QfDXtVQoIOfEvIaTzvJtT3GyZr+tqQgJ2q9He+LE7FAKGufgiuG1w+
	Eu4cUuJ0k/i7SuFaWcLvJxYWIsyc4fvfRkkQ0L+b9Ktg==
Received: from mail-qv1-f72.google.com (mail-qv1-f72.google.com [209.85.219.72])
	by mx0a-00364e01.pphosted.com (PPS) with ESMTPS id 4gjhqktavy-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Tue, 08 Sep 2026 11:16:43 -0400 (EDT)
Received: by mail-qv1-f72.google.com with SMTP id 6a1803df08f44-90ceabcd64aso99296346d6.3
        for <linux-mm@kvack.org>; Tue, 08 Sep 2026 08:16:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=columbia.edu; s=lionmail; t=1788880603; x=1789485403; darn=kvack.org;
        h=cc:to:content-transfer-encoding:content-type:mime-version
         :message-id:date:subject:from:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=7KTq1kvrsMit8SFzKcwQG7/KUyhDzvAvzAS7QNGVsPA=;
        b=hXpV3yhEPVpABg1rav47VFvFDYDPoT/BMCPzH//InR4TTaJBzQo4+iMF8RkAWQpIhP
         H3PIBSHKmduq50fyF+tghGP1NByXgSi2/faowImlJaiGCf7sBpWZjZzG+Edo/NTXIy/Y
         QEAtl1YxGDVTpvVSsloYBmgQs0aFosCzpO9pvuXoyr4kHqAdS0K8yp1CoTkFQ8h4z3WZ
         MOr4gXrB5LRhEbuq73dA1sqpyjLtXbtpWno3TCGfCwGHnCIdUiJfcZn9XOmu/FkRXpb+
         0qixYYbDfcZpOuc68ecZbs2uWEi4ntyja4XgP0NDz2AvJ63Jlp+L19AEFr4gEB0tbkco
         ovRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788880603; x=1789485403;
        h=cc:to:content-transfer-encoding:content-type:mime-version
         :message-id:date:subject:from:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=7KTq1kvrsMit8SFzKcwQG7/KUyhDzvAvzAS7QNGVsPA=;
        b=nlVt0bRo4twk4UMvRluWG7kYSpgRqnHLolUUhiC4KqUVf6/GGMj9NCtQMwFO7yWrmg
         ycp9PbS81KxRN9T9A3I5NamrsJxGI8Ev29LxWe71nqaWp1a/xrOlCU5Y4YThBjgMb6/B
         B1bPNHBOlKluMJZJ5pWwmwjLvbXG7T7EE7YVmErkdF3IrRxM6iNkOx2JUsvth47/emUo
         7bhmo52P74U6uCSDbmTdi+MP2ofSPT81SR005sqiNYPczB/aeOJs5W1gyRwjJzbPGczj
         iaJtHbqTPFgKSMampUELEdFutnuPJWydXgmyhDK5nCgDYnlLkEQ4GraaWgGWLERbMtG9
         iSNA==
X-Gm-Message-State: AFuF++k+PaJHrknv0BGuVpbA/Is3DP2AY4u+BH4CtXCdF+RNUO3nzgzP
	kAyQB8Gx8H3n1RtpQ8+8M9vGJyWy6FZUJZoQH+LNv82wMt3jgGIF8CpR91V+22XkeRZ2wh8eXa5
	xxn9+hyiS9L6VJXkc66I5fa9U6chCIUK96ejFr7hfwjhXyvpV
X-Gm-Gg: AYBFou04wGM6TXDvwO3eaCT1CIxdJoeg7nXeSS6kNmFO2ZB0RlpGH6h9i5M30NwIV2e
	5f/LWR/JF8xK3uWp//gLOvFH3ahstYAk91UTnhIwGcpRRld98OYupWjFjI6QaUODC09W+wVpyvz
	bzZ2xoPpxyJ+wAdyvvhpTnvd1olNSH8/TT9WKd5WNGSOdWijPPOmL8wwo9nn1E1tjTGuX7BO2PA
	gNvz8M1QaWmCo1H/4DqxE9DBMf7sh1S/RyWoax+yrxT6YUqShx/EuBOv1flirimUOTAkHExRQ8m
	2Qx/2i/XWfGZm6CfWaM3ngQVf28R6LfvevG6nIRtAdpy9CpDTwm+ZhtGC1o4XxLTqrpXg1ne6SB
	JMfi8H/Rz9vvGlzUL0g6CsirSYSSGV06U5CgcHd3bvJShS0JfykPj8g==
X-Received: by 2002:a05:6214:3386:b0:910:3453:505f with SMTP id 6a1803df08f44-9103f06f122mr371615996d6.33.1788880602537;
        Tue, 08 Sep 2026 08:16:42 -0700 (PDT)
X-Received: by 2002:a05:6214:3386:b0:910:3453:505f with SMTP id 6a1803df08f44-9103f06f122mr371615166d6.33.1788880601876;
        Tue, 08 Sep 2026 08:16:41 -0700 (PDT)
Received: from [127.0.1.1] (nat-128-59-177-174.net.columbia.edu. [128.59.177.174])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-91040673ce0sm122105496d6.25.2026.09.08.08.16.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Sep 2026 08:16:41 -0700 (PDT)
From: Tal Zussman <tz2294@columbia.edu>
Subject: [PATCH v2 0/8] mm: remove page_swap_entry()
Date: Tue, 08 Sep 2026 11:16:30 -0400
Message-Id: <20260908-folio_swap_entry-v2-0-ee6d01dfa5e1@columbia.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAM4moGoC/2WNyw6CMBBFf4V0bc1QQmlc+R+GkD4GGYOUtIASw
 r8L6M7lSc49d2ERA2Fkl2RhASeK5LsNxClhttHdHTm5jZkAIUFBwWvfkq/iS/cVdkOYOeaZk0q
 m4BDYNusD1vQ+krfyy3E0D7TD3tmNhuLgw3x8Tunu/fIZ/OenlAMvCiVNLrQ1Vl2tb8enIX1GN
 7JyXdcPRyQkHsUAAAA=
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1788880600; l=1968;
 i=tz2294@columbia.edu; s=20250528; h=from:subject:message-id;
 bh=BW1jUF2S5ycmeA+jFwvHzlz0Ys2b5JeYJvusxui8Gw0=;
 b=pW4BwiQnZqvQ8s20P0IiCWnMFrvc6b6RE03aLWSNO+VqtkHPIJ6wzKMNqS6Ttm+TPdFUYKmf0
 zH+0YdBwZwODqfWWolQOWLlGw8f47azHMpmTmAO8ApancQrfdo8RefZ
X-Developer-Key: i=tz2294@columbia.edu; a=ed25519;
 pk=BIj5KdACscEOyAC0oIkeZqLB3L94fzBnDccEooxeM5Y=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTA4MDE2NSBTYWx0ZWRfXyV3ChABzaDt6
 SOGS7M0XuMN6wl8AHnw3d+yeYXSVBwFZcz2NurSZK7TdnXLjuaRJExqJU9dymzFe9C61+0zx0Gy
 auVd8wJ1C1Q8Fczy0vm7+pWQGB/d57GN//QZZWodzucWpjhFe6XrBBBxnSqkIKmHaoPdraKDrO+
 i0EIQwlZtwqWdKFdt9U9PmfzQQfMer5UG1HDS+p08K/sAUudTbNQBUeYfHEAqUoe1Bb6b85asZs
 wQqk1WB6N1zGMD+Z3RhpcNGiEm2QtkVUueGWYqt+96fqZjqo8MXPcqeLAvfIYvct+7tPkukysFa
 14WqsfCLRMzzmaxMUGuKB7O0UO9y0mDiTcyUXR8kG1ouHc8mc6CmY9xe11SVWvinnIrj7wRCm5y
 g34asmlJmN33Y8jj0YpCthsLG38fUTqr7fo8OTAfO7HSYqNTIAVQkJtqYOjM4uPAhlogGQwnRHG
 ACwgmwhouKYQBNA0mww==
X-Proofpoint-ORIG-GUID: VRiqP37_Wq2evFBRfRAT_u5Sn3CDfmoh
X-Authority-Analysis: v=2.4 cv=CuOPtH4D c=1 sm=1 tr=0 ts=6aa026db cx=c_pps
 a=7E5Bxpl4vBhpaufnMqZlrw==:117 a=HBUb3goEnnz3w2smY6d+Hw==:17
 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10 a=x7bEGLp0ZPQA:10 a=A0y_DWxS2BwA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Da8U98TiO7q1upZEImrf:22 a=G--0XuH5328wxK7v7Suf:22
 a=bC-a23v3AAAA:8 a=YU6N8qweUkUyprsO3vAA:9 a=QEXdDO2ut3YA:10
 a=pJ04lnu7RYOZP9TFuWaZ:22 a=FO4_E8m0qiDe52t0p3_H:22
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTA4MDE2NSBTYWx0ZWRfX7cJHQDe/pgT2
 adSvkKYKahnCIuz9j2YnfJx6mLR9wAInZger/HfzrzM47byjOdeAWBrSdyRGheV7+ftVsLIp12m
 UfmnG097bydJD0eYEOXvV3b7uzV8NimxDT1wINYSPCGvUvV99QEQ
X-Proofpoint-GUID: VRiqP37_Wq2evFBRfRAT_u5Sn3CDfmoh
X-Proofpoint-Virus-Version: vendor=nai engine=6900 definitions=11899
 signatures=596817
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 phishscore=0 lowpriorityscore=10 spamscore=0 bulkscore=10
 clxscore=1015 impostorscore=10 adultscore=0 malwarescore=0 priorityscore=1501
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2609080165
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 36C57180011
X-Rspam-User: 
X-Stat-Signature: ws1bizeia8337b1bdf1mqkst3otn7mq5
X-HE-Tag: 1788880604-435688
X-HE-Meta: U2FsdGVkX18CJne4L9VYRuwJZsbpKWj59lBQQg89f1ih+fthZAACjHXkyFh/USwCMn6e+A7rzxMdCSSNxeaBXzELpISWL19LIeUVOqW3lM26TJ4c2l4ol/1jZtOjjwemUzYqINRopTpP5zB9KFteZaEbg6jzKbSDtDFQcefYXSnRW2i/tfcwwohtns1xULG5wNkvuRit5gZpwhD++jIchyGDk7QezNcD2ncG6tvRRtORe0TM10G9Jy+tWIDmpkDJw+cJCqSp+0uA/umE0JigXNGBDw33Aas1y6rcyvOdZHGAes/JvfVmZDlIArIeFmEoJBgHtAMx/KMdTxLn6sbOLiBDur0x0ZUu9NtlSNmwkdb8sjg5JAbirnaWiQ+wOt0LlssLynaGdBzGxrv0/dEflEdoPq3hHTk3+U6wRQBMJco0xIaJjzZzmKjbMyL7kj8sZQYL4+g42Tv+YwpYAjlIdEiRkogV84qQVpZk/oPYPV4DjUpAaDO2BaMnAp6pLXaUug3Y+LuoPrQceqR6SA5bfhP6OnZAF6/uNQ1gTsWXo6Mts/SiGQhUrJttGFJXSd1eHrcTXj09cIrKo4orgPYmAvqHnOIrppwLClF67pSgiW6BFD0bKBtyUFBIrLfJTYBDqee3PURF9jn5Ar4WNDSUz25O5NnZpa+9TfcWPEGA/tBZUU6EqDKbY79EZZJfI51Qj9p2tqCeqqEkX1uEX6zE7ytSmy4VOVmnBG7FTZsJSEZZRorkWuo9o36604TYaOVzArIbj9E6PH4tDnmzADtiawJ9KKYJkHBgU9Ubb5EkNnd+zjFfzePpkXhqpwGUKT42oga9ATSnGF/b46bESvmNEv0+fNubekQYmCrZ+nOKyTCUm1sNIUkYki/nY8mOs73dZR61RFZEd5YXS5HDD4513Xr6scmHWD7ZDQnVGv2xHCQKmZtsfLPsJMnOobGiW83K3ck53dvx2EzOPMRTuZX
 1ajkRy29
 SwOFpWYxZ+6eNl9wUI7att1X3Le5z27hNIGZzLm4sKoQkVVXT3etuEIkaY/UA+1LB4YfW399QC0oRndIfEU7rdsl7sFEy8+2ScrSzUiy0bF0vQijytt+yXh+1nf7W44FG5KZCjycyUlkwazKH6ZPhrR1fXnoFWpo0Qteqf2YoVNeqGIy4ceXzSlfdzwhfgSA2KIff5gAkqjw+JVNQQjqNzjZYtI9i4IuMYtkBsN5JZ8XeRqvXfZSLIUrUX5KBW5NF7vWpS3C4Ua42owB7VSw5AiFtw/TnY1gs1anrztkAA2yjpjOnerV2adPXl+rMZH3rGZmIAadH4zdNZaUy4FK9VPAgL2ehPNU8PBQL6BT/1xgrNaX52oFa7YNxHHgeNrFEU4cpyQQ6d6E5z4eNKNvqfrGoAv4d6A9a03BBNgq72Roth8vMQ4EyAEBJHR8hPqCWl++36La81m/LDiN8jW9UERiqduqj0jovIUcB6BUd6Q5xRw6hf2fj991T5yqDmcFPGxgd
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
Changes in v2:
- Keep the swap entry computation in __split_folio_to_order() open-coded
  and add a comment, per Zi Yan.
- Reduce the zswap patch to using folio_swap_entry(), as the folio
  conversion landed separately.
- Link to v1: https://patch.msgid.link/20260830-folio_swap_entry-v1-0-7786b52acbc8@columbia.edu

---
Tal Zussman (8):
      mm/swap: add folio_swap_entry() and folio_page_swap_entry()
      mm/huge_memory: add a comment to the open-coded swap entry
      mm/rmap: use folio_page_swap_entry() in ttu_anon_swapbacked_folio()
      mm/zswap: use folio_swap_entry() in zswap_store_page()
      mm/swapfile: use folio_page_swap_entry()
      arm64: mte: make mte_save_tags() and mte_restore_tags() static
      arm64: mte: pass the swap entry to mte_save_tags()
      mm/swap: remove page_swap_entry()

 arch/arm64/include/asm/mte.h |  2 --
 arch/arm64/mm/mteswap.c      | 32 ++++++++++++++------------------
 include/linux/swap.h         | 30 +++++++++++++++++++++++++++---
 mm/huge_memory.c             |  4 ++++
 mm/rmap.c                    |  2 +-
 mm/swapfile.c                |  4 ++--
 mm/zswap.c                   |  3 +--
 7 files changed, 49 insertions(+), 28 deletions(-)
---
base-commit: 9d3243fc689fef444f87e0a703b4c99653137e1b
change-id: 20260807-folio_swap_entry-e53d68610de0

Best regards,
--  
Tal Zussman <tz2294@columbia.edu>



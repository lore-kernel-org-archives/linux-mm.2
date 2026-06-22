Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1CD9ECDB46F
	for <linux-mm@archiver.kernel.org>; Mon, 22 Jun 2026 21:19:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 04F4F6B0088; Mon, 22 Jun 2026 17:19:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 000B86B008A; Mon, 22 Jun 2026 17:19:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E0AEF6B008C; Mon, 22 Jun 2026 17:19:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 669A86B0088
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 17:19:12 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id A80068CFE1
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 21:19:11 +0000 (UTC)
X-FDA: 84908814102.15.E83A3FA
Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	by imf02.hostedemail.com (Postfix) with ESMTP id 092528000F
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 21:19:08 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=qualcomm.com header.s=qcppdkim1 header.b=oVXhTpzP;
	dkim=pass header.d=oss.qualcomm.com header.s=google header.b=DpEVW2DB;
	dmarc=pass (policy=reject) header.from=qualcomm.com;
	spf=pass (imf02.hostedemail.com: domain of ketan.kishore@oss.qualcomm.com designates 205.220.168.131 as permitted sender) smtp.mailfrom=ketan.kishore@oss.qualcomm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782163149;
	b=5mcn53e9e8GixM9jKfElczfTEzQqpg1i0Q6MZYUMOnd9OSXXm5MTbkz0HDTedLseSW4XiM
	ch/5awb7kaFFDJ5t3rPqF4EKOAa0tIWMEdZqgHBoBcDqvaL8J8NOL43aoML888PiwuIOdq
	6ITprDwXTsHXW3xadt8KxlOR8HhPRf4=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782163149;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=jbWnur0UQozabsJp1eS7FjjSZ9kDV6hLBfR8H71dKkY=;
	b=jawTO4QSEfe9Fy7Vs9ym1IcGDEkefIh7l6Jd46maT5jNoE3PPEKwZwGL+oft5yut0hh48h
	xNIHzLDXKbrCvpuWVoa+bmFQ1ep2ys6aeZHQAw75GfaSBi8F0HBXpjnczWJSOyLK5/AF2d
	i+d9CgYtm/4Zdu5Pul07ZIZr1Nfjh2U=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=qualcomm.com header.s=qcppdkim1 header.b=oVXhTpzP;
	dkim=pass header.d=oss.qualcomm.com header.s=google header.b=DpEVW2DB;
	dmarc=pass (policy=reject) header.from=qualcomm.com;
	spf=pass (imf02.hostedemail.com: domain of ketan.kishore@oss.qualcomm.com designates 205.220.168.131 as permitted sender) smtp.mailfrom=ketan.kishore@oss.qualcomm.com
Received: from pps.filterd (m0279867.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 65MJZiNH1629262
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 21:19:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=qcppdkim1; bh=jbWnur0UQozabsJp1eS7Fj
	jSZ9kDV6hLBfR8H71dKkY=; b=oVXhTpzPWyS8DnIR0ZSDgMtKe3m68zHO0HdM2C
	GJUVZEjE5oOO1sx1yqfha+MMRk7uepuKSwiX7lfx4ezWmioZO17+zLyjNrU2vZdg
	jps+mjEH83oxu+Y006A1Tq4Fbitg6AX7d9wHdCg3TmaRr6o22I5ZYLODxKMCD82D
	sTsIRYNnXEy+m7gOTDnxXrWMaFRnmf9/wR4Xef4W9eEXulEJL0Uv2zedaXQNWzRP
	de3trtraKFECIirHsSSKIeePQw6tAAykA+6qUIOtuSEPmxbwnJqARg0bmZZo4UIN
	BhJv5WNBLGkK3+9aQ7jxlj/ASfiKv2smfQy+GWPS4XE9NNjQ==
Received: from mail-pl1-f198.google.com (mail-pl1-f198.google.com [209.85.214.198])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4ey3cq28q9-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 21:19:07 +0000 (GMT)
Received: by mail-pl1-f198.google.com with SMTP id d9443c01a7336-2c6a48fb4d5so43001545ad.0
        for <linux-mm@kvack.org>; Mon, 22 Jun 2026 14:19:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1782163147; x=1782767947; darn=kvack.org;
        h=cc:to:message-id:content-transfer-encoding:mime-version:subject
         :date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=jbWnur0UQozabsJp1eS7FjjSZ9kDV6hLBfR8H71dKkY=;
        b=DpEVW2DBa0jMGc7pvFR2bSMb5Hii3vSkyg1c7zFcvejYSqINyxVdQq13DiMu/ed6TC
         +eTxUAx/U1hhjRa9pXY859hDCjofTM6ENf4feUnop7l8u5ezWtK5N4LASiqqY1Y99EhC
         +IUe6sw63ObSC8yY8XCEhIoRqB5W7e9Tg/EexwigI1SUyfJN34jLHB+9UagGIR1uewUA
         B5CCFyVzxwQ2TtC9dZbR7b/lYl9YTgC6uqpfh/NsmT2hYb+qmwhNJ2wtZKMk31Cmpm/U
         vj+hjpAGPA3x1hftvbY4U/nm+au3O4PnHOtjoPGhiNmclmke/KdeJVYDprP97iibAIxR
         rpSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782163147; x=1782767947;
        h=cc:to:message-id:content-transfer-encoding:mime-version:subject
         :date:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jbWnur0UQozabsJp1eS7FjjSZ9kDV6hLBfR8H71dKkY=;
        b=TWC8Xl9jxoBWohRqPxvPpSx3/vfbmJQa+x776Jbw0bgGc7tis/t4WECFEVOBvcoHGz
         b4c5yAeL/e8NpUPQhzgLIHdsqrxGZgGQ8qV1p+s+R/nCoskPuZUMyGcQSTloONQhb3aj
         bZ9K0w2N0XH1LTbPth407ETFTa6gKaDmWlgRdCA8wsq+QzyDKqT3sJLO+9tLEzDH1g3h
         uWJHXTDRXWhSOgt5mY13G8wOfiY1h+dIPHmem6VQq45fWe11IbZRrWsPJku3saow5hNW
         v9kOj2Kxw/UHeR2FcGb+AfgJ2vKfBG8gYj0vY6x9siLoKsJO4Y9WlU3NbYUGEp9aNJbl
         n7hQ==
X-Forwarded-Encrypted: i=1; AFNElJ8ZhZb4XUfmdTi0DSb+A5e0OxmB67JZT6rF79LZbUsVLP8KdyZq9U/a5uyw805c/VdSy9GlomCGkA==@kvack.org
X-Gm-Message-State: AOJu0Yw8IVNof404xE0HqxRxaZPt9ZB8IHeNYOJNvYA/5NNJSErUU1oe
	mn52yi5fKNOT0HejBXCx1oRjt2OCM5bhJJhZUt4JqzJr2u3lxHambNKVpKh0+zQ7TVcPa4vP7l8
	zbHsNYzSqIGy/3/CgujkjWSU8C6EtRGEtPteTPS8ghLCGoB1vxCYWQw==
X-Gm-Gg: AfdE7clcGkQmoKXAPA4VEvzsemawcM5Pg1/6V1HeFncjxd0+ceU4JlQkYwaq2Uq0d7s
	TT8Lo7IkI2hK0QYesEclIMntxW9yD5J0v+sRLYcYajzmGm7KOPFQGCFtSZW4TT3PJ1oiAdTxsML
	iB3L2//KnCVv8AYJcDPy7ndsMrYqSqyuyWnxNKjbmB2ryK+ZU+lgHLbHGeoZK1fDIYoTp7OqNLY
	F6lwyGNpDz68J/vozxMfJ9sBtTZ0ENmnrh9uLdJyEinHaQy7Rl6Wz6QB7cWbNz8tddChr7ugpDc
	x4Mt75j9Ii18u3gCOFQlhSFKaefv9/CfGz93AyfxnojJuVh0w5JrGloY+xrybazZ2JaQe/rS7A7
	QgrxQDKYUjl94H+XzEijTYIU6keMdEK35niJX7tUVGGfz
X-Received: by 2002:a05:6a21:3299:b0:3b4:7236:1b5 with SMTP id adf61e73a8af0-3bd15169c58mr183609637.26.1782163146802;
        Mon, 22 Jun 2026 14:19:06 -0700 (PDT)
X-Received: by 2002:a05:6a21:3299:b0:3b4:7236:1b5 with SMTP id adf61e73a8af0-3bd15169c58mr183567637.26.1782163146079;
        Mon, 22 Jun 2026 14:19:06 -0700 (PDT)
Received: from hu-ketakish-hyd.qualcomm.com ([202.46.22.19])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-c8bc374375csm8380733a12.13.2026.06.22.14.19.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Jun 2026 14:19:05 -0700 (PDT)
From: Ketan <ketan.kishore@oss.qualcomm.com>
Date: Tue, 23 Jun 2026 02:48:04 +0530
Subject: [PATCH v3] mm: page_ext: add count limit to page_ext_iter_next to
 prevent invalid PFN access
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260623-page_ext-v3-1-a89799a5367c@oss.qualcomm.com>
X-B4-Tracking: v=1; b=H4sIAIumOWoC/22NUQ+CIBRG/0rjOZyAqOup/9FaQ7woLcVAmc353
 wNby4de7na275y7IAdWg0Onw4IseO206QOw4wHJVvQNYF0HRjSleZqTHA+igRvMI2YEFOc847m
 SKMwHC0rPW+py/bCbqjvIMfpx0Wo3GvvafnkSd99s8ct6gglmhajLlFZEsPJsnEuek3hI03VJO
 CjWPd35lO58GnzCeJ1JVcmMqj/+uq5v+tUKU/kAAAA=
X-Change-ID: 20260616-page_ext-31ef555456fc
To: Andrew Morton <akpm@linux-foundation.org>,
        Vlastimil Babka <vbabka@kernel.org>,
        Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
        Brendan Jackman <jackmanb@google.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
        Luiz Capitulino <luizcap@redhat.com>,
        David Hildenbrand <david@kernel.org>
Cc: kernel@oss.qualcomm.com, stable@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Matthew Wilcox <willy@infradead.org>,
        Ketan Kishore <ketan.kishore@oss.qualcomm.com>,
        syzbot@syzkaller.appspotmail.com, Lorenzo Stoakes <ljs@kernel.org>,
        "Liam R. Howlett" <liam@infradead.org>,
        Mike Rapoport <rppt@kernel.org>, David Hildenbrand <david@kernel.org>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1782163140; l=5625;
 i=ketan.kishore@oss.qualcomm.com; s=20260617; h=from:subject:message-id;
 bh=ATrTdqo1jlcfQ3mHuUEXHK9/hrNkCyYMvwXtawjP/oA=;
 b=cZEBwPoANnoLKkmm74TLao3n44k2IM+wtVqqAQ1nadYNuwacQdKggZ9yR3CDkZq3KnSRPMqn8
 vm58lo3BWYlBJB38MA+2Qcc+WDVUV4LZvVcFHgl+dImn9QBMDGfK7Z3
X-Developer-Key: i=ketan.kishore@oss.qualcomm.com; a=ed25519;
 pk=4sb5Ima5x03wc0KSnl57v8kR/7FxMt01+xlZJ53rSJU=
X-Proofpoint-GUID: mI6oastcpzqhNoAmVEtmFA616rTzFcih
X-Authority-Analysis: v=2.4 cv=VKXtWdPX c=1 sm=1 tr=0 ts=6a39a6cb cx=c_pps
 a=MTSHoo12Qbhz2p7MsH1ifg==:117 a=fChuTYTh2wq5r3m49p7fHw==:17
 a=IkcTkHD0fZMA:10 a=FelO9ux0wxsA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=eoimf2acIAo5FJnRuUoq:22
 a=bC-a23v3AAAA:8 a=EUspDBNiAAAA:8 a=VwQbUJbxAAAA:8 a=20KFwNOVAAAA:8
 a=JfrnYn6hAAAA:8 a=hSkVLCK3AAAA:8 a=Z4Rwk6OoAAAA:8 a=1XWaLZrsAAAA:8
 a=iox4zFpeAAAA:8 a=37rDS-QxAAAA:8 a=v2oVMEoAPVEBj90iUNMA:9 a=QEXdDO2ut3YA:10
 a=GvdueXVYPmCkWapjIL-Q:22 a=FO4_E8m0qiDe52t0p3_H:22 a=1CNFftbPRP8L7MoqJWF3:22
 a=cQPPKAXgyycSBL8etih5:22 a=HkZW87K1Qel5hWWM3VKY:22 a=WzC6qhA0u3u7Ye7llzcV:22
 a=k1Nq6YrhK2t884LQW06G:22
X-Proofpoint-ORIG-GUID: mI6oastcpzqhNoAmVEtmFA616rTzFcih
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjIyMDIwNiBTYWx0ZWRfX/cRUAoygwCl4
 759zivsUvt+RSaTjFFvb3dVLVLtntPlyL+OHwvH2ooFGGA/pNfDvktJ+Wrs2lAn8P/Po3VnMOVw
 ct49ikplBwzpwLEokXm1hzYBOYWBr86JZRFce5eNy34hEke50Hbf3RnA+6E0N/qbHQzn6ir7vbb
 9Dt7dfvqXht+xeLZWVds7VFKsHXNEMIjxxoCq2XFAh3osJYo34PHJ+IBp8EWNZVrcCJdrcieODS
 l0Vkmc8KUgBtRWTVBlUe1QqziYeicHUSp0tWSWvjFlqjQTT+ycHLna1E8Cjb5fUFjKX0dDjsc+m
 L7qAQo3vcTyvxNcC3KONmVEwfkNss9moibAZlYto0ek9VIHSXVmP9GQ3PEKL5u/6PCsJ9ZKhsrn
 aSM8tH6W+7UZOqh1kP/vRT8NYGMPggM1Dq00HTuEUp+Ug/MU1OpsTnuF2CI4Ea8cG1gkPvZEZc7
 hgLrgCDZkri8lsj2YuQ==
X-Proofpoint-Spam-Info: AW1haW4tMjYwNjIyMDIwNiBTYWx0ZWRfX/fP3VT/xuxGf
 RZPK0oqNOlkdfjTEWMEaZIFLMonlR8u+vAT2Yb9+IZrvCY+zrAMzERPFVvM8b/DwBLtl0a+0i/U
 VG566yZ3bu31EMmvG+FjJlYTYcfP8to=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-06-22_04,2026-06-22_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 spamscore=0 phishscore=0 priorityscore=1501 adultscore=0
 suspectscore=0 clxscore=1015 lowpriorityscore=0 malwarescore=0 bulkscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2606220206
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 092528000F
X-Rspam-User: 
X-Stat-Signature: o59pc57kbpcffdtk46s4duxbcjo5ye4e
X-HE-Tag: 1782163148-118665
X-HE-Meta: U2FsdGVkX1/6AHLgpX4LgeuVLisSmhMqschBNcq4onAl5ccoxeiHufyuB4iuqVoy8lSJXlRcgUmTodgx6LUmVfSvU8XkzALDZPCZaOkdegt+HpZwbUg5aiJuv9iSFz4wLLNzv6Yim/QiUreCzkBFdjnaxHL+2wBojsK9TktXDwoFpjnTNl2/gJQpcGbmv5QyO6iqVqKYJ63YF5GEFX0ufXLsmsOIMEL/d+21RBPgeaYUYre9Yu9Ee/bsZU90vt7im+kZDydalN7NxTIsKM8ydJ6lbjTglZJoV/sRQD/8Rn64JqCxUBtT9saz8FzCaQnstR8oZgDm0taBL3Yim2qmMJkAzmf2xnfJZ03n8z3ZJEfCphuzXqSKIlnPxWn8Os8uP9xNANad0WiwEsc/DiRmlcb4vFNNawsZp/4LemI4Gwo0eRwonFI0d9/nRsRGpEnTRIV4RVlX45NiPsAWfx76HPJ82gHOjHwQ31eHdTFpQBMWMbL+2xl4AYSSGbKz9LoypLIH4dkNU65ddWtFwmz4qOUDMHVn0Gh+a823b0NfddMUFExUH9Laudou1/QF8Im1EZF+ePIf22t6Ncvwsg9sbfYZ7Wpde+IBhOI7YbcZf6ttSSygMj9s0rRIazsTDzbM3LIXf3cCeN0JoQA79fXh8qXnQZJRsjzg2ilidSPEvyTXYMS0Wxun1MT9CJ9Lgxipv/rouvbXwv7lLeymluVeuHMvB5CXg3QL61Qw8TVle1xi3WdDoeyyLHpT00p2fSOFuQhEjQlGDnAsga4h3Wv8BNs2pBswzEAEOALKAg7LtaSVNqMlLHdnuEKstB7y7n10Gqwd2pPw4A600UsvY9tTD3NXvK130C18mF13+enO8+7ZiUXfDQZEr50zo5b50IXPaonuS6XJBq19TTFR6rcOeLKO+4GdOFRCjoXi1FL7R1KVSuU+60FxlG51yJ7dFlBNyEe6jSc+cLjBE5HjApy
 nEfjJoCu
 +7ab6I+A1olculFRq3sFiG8IMH9C92l2NO8FwWa9ZQ7OZQ0+SHUsWUbXxVFp+hHNqqoLDgz6WwKlbuh59dSF4RGQHuIvauTOBWD8rG78l8yBn8AD0qeFfCMKUQEb2s8yzzceioYjwa5iV1doidGR3afzRQ29ZFyhpVBMd1TiPKT1IHhtNlSVEe68JupDpa9MF9nVg1O3HotJjhuhX92yu4z1OY6TUQR7Hs/tU8ZqlEfpUHwhUEYvbOlRjeq+l0WU3cgQ+pTFuCNFw84xZazeCDHje4wfFmk6u7URQkkZQw7zXeMnfdgFXI978ux6yLrdhJsRVhBUNiJkBHhEsu9B3oL3kpSZMym8faPdGhH5LxuvrEhA+SPBxu+F76nIIJuE9DbFczHkYvgRDz/OoSgJ+V8SNuhlbC9fPulyniQjaJ5mzXgdqW3yf+kWTWoLpwsikR8wbyjAVuZJ52y3TTiRZ28a7/SGKge9nfGtUybfDMsW2Fb80n9L2SC0xNji2uqsB2WvU+WBoAna42oowvIwsu4csVmpqMx3uU80LFshUgaP7Ldkd00uoWjiFVOGy0zKnyEV2PSC50b5xRHBsSzIGZpNdIJgFu1Nvs7LGlTYHm61do4j41wAY8a92usIgRbsWqw+oK1Ex1anzSQKjSXudBlNuxyyH7hLFSOsSH5b7OGvQQ0JrngsxCGNohoQsP56ISkp3O1IQp/uaR9eze0kXLezS1WIYMdEEh4BsMXM60qFjdec1zwBtAMaQaEGEG7q/9awonVz1nAval/zfCl+2WFQYMOOzdmyDYlGQZobQ0C8/o3fAa7IRGLFEgSdwWiqXLtqZQbAqz5XQW2j3owaEHoE2Kp70JCks5TT+8KzOS+CEP53xtmn56Ry71kHPH2eOMXCGbgonwPJc1XCn3ZIqMSuPs+lXfCFGtOddsqeutY39/znzVia+x5XVpA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The page_ext iteration API does not validate if the PFN still
belongs to a valid section while advancing the iterator. When
dynamically adding memory in the hotplug path, it can lead to a
NULL pointer dereference during page_ext_lookup at the boundary
of the last valid section when iterator count equals __pgcount.

The for_each_page_ext() macro calls page_ext_iter_next() as its
loop increment. for_each_page_ext() does a
"__page_ext = page_ext_iter_next(&__iter)" at the end. This
causes page_ext_iter_next() to increment iter->index past
__pgcount and call page_ext_lookup(start_pfn + __pgcount).
During memory hotplug (online), the PFN at start_pfn + __pgcount
may belong to a section that has not yet been initialized,
causing page_ext_lookup() to trigger a NULL pointer dereference.

[   14.555124][  T846] Call trace:
[   14.555125][  T846]  lookup_page_ext+0x6c/0x108 (P)
[   14.555127][  T846]  page_ext_lookup+0x30/0x3c
[   14.555129][  T846]  __reset_page_owner+0x11c/0x260
[   14.571201][  T846]  __free_pages_ok+0x5e8/0x8e0
[   14.571204][  T846]  __free_pages_core+0x78/0xf0
[   14.571206][  T846]  generic_online_page+0x14/0x24
[   14.597782][  T846]  online_pages+0x178/0x30c
[   14.597784][  T846]  memory_block_change_state+0x284/0x32c
[   14.597787][  T846]  memory_subsys_online+0x4c/0x64
[   14.597789][  T846]  device_online+0x88/0xb0
[   14.597791][  T846]  online_memory_block+0x30/0x40
[   14.597793][  T846]  walk_memory_blocks+0xac/0xe8
[   14.597794][  T846]  add_memory_resource+0x280/0x298
[   14.656161][  T846]  add_memory+0x60/0x98

Move the iteration boundary enforcement inside the iterator
functions, so callers cannot inadvertently access beyond the
requested range.

Fixes: 9039b9096ea2 ("mm: page_owner: use new iteration API")
Cc: stable@vger.kernel.org
Suggested-by: David Hildenbrand <david@redhat.com>
Suggested-by: Matthew Wilcox <willy@infradead.org>
Signed-off-by: Ketan Kishore <ketan.kishore@oss.qualcomm.com>
Tested-by: syzbot@syzkaller.appspotmail.com
---
Changes in v3:
- Fix the iter->index++ increment to pre increment(++iter->index)
- modify the (count == 0) check to (!count)
- Link to v2: https://patch.msgid.link/20260622-page_ext-v2-1-135d4cfbc42f@oss.qualcomm.com

Changes in v2:
- Incorporated comments from David and Matthew to check for invalid PFN
  in page_ext iterator rather than checking for NULL section in
  page_ext_lookup.
- Minor improvement in commit description to include the issue with
  page_ext_iter_next
- Link to v1: https://patch.msgid.link/20260617-page_ext-v1-1-37ad802b1a38@oss.qualcomm.com

To: Andrew Morton <akpm@linux-foundation.org>
To: David Hildenbrand <david@kernel.org>
To: Lorenzo Stoakes <ljs@kernel.org>
To: "Liam R. Howlett" <liam@infradead.org>
To: Vlastimil Babka <vbabka@kernel.org>
To: Mike Rapoport <rppt@kernel.org>
To: Suren Baghdasaryan <surenb@google.com>
To: Michal Hocko <mhocko@suse.com>
To: Luiz Capitulino <luizcap@redhat.com>
Cc: kernel@oss.qualcomm.com
Cc: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org
---
 include/linux/page_ext.h | 19 +++++++++++++------
 1 file changed, 13 insertions(+), 6 deletions(-)

diff --git a/include/linux/page_ext.h b/include/linux/page_ext.h
index 61e876e255e8..f23d4b218da0 100644
--- a/include/linux/page_ext.h
+++ b/include/linux/page_ext.h
@@ -120,14 +120,18 @@ struct page_ext_iter {
  * page_ext_iter_begin() - Prepare for iterating through page extensions.
  * @iter: page extension iterator.
  * @pfn: PFN of the page we're interested in.
+ * @count: maximum number of page extensions to return.
  *
  * Must be called with RCU read lock taken.
  *
  * Return: NULL if no page_ext exists for this page.
  */
 static inline struct page_ext *page_ext_iter_begin(struct page_ext_iter *iter,
-						unsigned long pfn)
+		unsigned long pfn, unsigned long count)
 {
+	if (!count)
+		return NULL;
+
 	iter->index = 0;
 	iter->start_pfn = pfn;
 	iter->page_ext = page_ext_lookup(pfn);
@@ -138,19 +142,22 @@ static inline struct page_ext *page_ext_iter_begin(struct page_ext_iter *iter,
 /**
  * page_ext_iter_next() - Get next page extension
  * @iter: page extension iterator.
+ * @count: maximum number of page extensions to return.
  *
  * Must be called with RCU read lock taken.
  *
  * Return: NULL if no next page_ext exists.
  */
-static inline struct page_ext *page_ext_iter_next(struct page_ext_iter *iter)
+static inline struct page_ext *page_ext_iter_next(struct page_ext_iter *iter,
+		unsigned long count)
 {
 	unsigned long pfn;
 
 	if (WARN_ON_ONCE(!iter->page_ext))
 		return NULL;
 
-	iter->index++;
+	if (++iter->index >= count)
+		return NULL;
 	pfn = iter->start_pfn + iter->index;
 
 	if (page_ext_iter_next_fast_possible(pfn))
@@ -183,9 +190,9 @@ static inline struct page_ext *page_ext_iter_get(const struct page_ext_iter *ite
  * IMPORTANT: must be called with RCU read lock taken.
  */
 #define for_each_page_ext(__page, __pgcount, __page_ext, __iter) \
-	for (__page_ext = page_ext_iter_begin(&__iter, page_to_pfn(__page));\
-		__page_ext && __iter.index < __pgcount;          \
-		__page_ext = page_ext_iter_next(&__iter))
+	for (__page_ext = page_ext_iter_begin(&__iter, page_to_pfn(__page), __pgcount); \
+		__page_ext; \
+		__page_ext = page_ext_iter_next(&__iter, __pgcount))
 
 #else /* !CONFIG_PAGE_EXTENSION */
 struct page_ext;

---
base-commit: c425609d6ac4012c8bbf01ec2e10e801b1923a7b
change-id: 20260616-page_ext-31ef555456fc

Best regards,
--  
Ketan Kishore <ketan.kishore@oss.qualcomm.com>



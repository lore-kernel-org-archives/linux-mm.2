Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9487BC61DE2
	for <linux-mm@archiver.kernel.org>; Sun, 30 Aug 2026 10:33:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B5B9F6B0096; Sun, 30 Aug 2026 06:33:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B32E76B0098; Sun, 30 Aug 2026 06:33:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9D4276B0099; Sun, 30 Aug 2026 06:33:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 711E86B0096
	for <linux-mm@kvack.org>; Sun, 30 Aug 2026 06:33:50 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 06EE81A021C
	for <linux-mm@kvack.org>; Sun, 30 Aug 2026 10:33:50 +0000 (UTC)
X-FDA: 85157575020.25.46E125C
Received: from mx0b-00364e01.pphosted.com (mx0b-00364e01.pphosted.com [148.163.139.74])
	by imf19.hostedemail.com (Postfix) with ESMTP id 785F31A0005
	for <linux-mm@kvack.org>; Sun, 30 Aug 2026 10:33:47 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=WEtkyWrQ;
	dkim=pass header.d=columbia.edu header.s=lionmail header.b=gjRpabqt;
	dmarc=pass (policy=none) header.from=columbia.edu;
	spf=pass (imf19.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.139.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788086027;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JCz6TGTeY9Fm3CRXI9ycezdJoLH0CKAS6XvyEH2jrh4=;
	b=HcjWEO3msKSB5pusGEBsO9sVkrMk6PvwxenmGRw9V62oR2gkKdDTtb0awHCiRerL+Ex8w6
	WF4Ai3Nsg9hZOL5eMmt8wgWUAYpcewYjEjP6/Qh+Arfy0/sKjlbbAsmqmGxyQTLY8QtjGy
	2n17dO8U+Z+8cP9m/nSQrVp5Rrpf2z8=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=WEtkyWrQ;
	dkim=pass header.d=columbia.edu header.s=lionmail header.b=gjRpabqt;
	dmarc=pass (policy=none) header.from=columbia.edu;
	spf=pass (imf19.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.139.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788086027;
	b=eihgRwCc1781Cxyw/BQT5zLjVni8NiUlD3cBgQi7LcW1qvRU02NN0nJOaL0YUav+x7qMkB
	xbNLVAiIiLDh0CdDne+BA7/iqdir0kOPY5e/OttehpB1jmsieoKAA7BPb7r27o5a36+Ml1
	n81JO+cEvPhqNs8A5wz0IgCoHHja7Js=
Received: from pps.filterd (m0167074.ppops.net [127.0.0.1])
	by mx0b-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 67U9f0tl3255280
	for <linux-mm@kvack.org>; Sun, 30 Aug 2026 06:33:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pps01; bh=JCz6
	TGTeY9Fm3CRXI9ycezdJoLH0CKAS6XvyEH2jrh4=; b=WEtkyWrQuMLAyQJfquvx
	k7UMw94sA32wFOf9YloYUNSyS4hQzHHb0ELsJQ5GIvapw8mZKuXQbGZz9Kx8q2Ia
	65hqikIprptymJ5GEDlBevRjNslGhFLtjnKmDlcEhSRwHx05Huct96UUzYanxApR
	+dMeH/qpAF8Z0bZc3t9xpB0jn7eeXT1P60fiFRnluk2e3IEq+N0Qp2LtgtSyJxd8
	TGWhy64E9dXzIudpWbcPrtssFIaxH5Abcxpis+8U3KcEe7V+rA7nVNboa70yUW0I
	dGNfLwGfbkzbsN2Z6ZjrbD+BJ5poFIcCbk/Hz2tDROeIfsNwpFM0giMzlDO6rXYR
	dw==
Received: from mail-qt1-f200.google.com (mail-qt1-f200.google.com [209.85.160.200])
	by mx0b-00364e01.pphosted.com (PPS) with ESMTPS id 4gbrfbvyq9-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Sun, 30 Aug 2026 06:33:46 -0400 (EDT)
Received: by mail-qt1-f200.google.com with SMTP id d75a77b69052e-52fb6c7b680so32032131cf.1
        for <linux-mm@kvack.org>; Sun, 30 Aug 2026 03:33:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=columbia.edu; s=lionmail; t=1788086026; x=1788690826; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=JCz6TGTeY9Fm3CRXI9ycezdJoLH0CKAS6XvyEH2jrh4=;
        b=gjRpabqtgQ+cYVcPl2NEeNDHp/Aqv0LgynxoQFqe7vH2rTtf2aMbvgwq+3jplnMeNG
         gxRmhSpzYv+qOzTBbkO0r1CkNtD0utYlaY11gi0X5HNKqnXW57by9TtfzmllZlnmAeQq
         KoRR88LEUX4ppCoDipZYwZxMob/gIOrIUG5jACbJ2cs5V2d6o/57S0T90/+drYyXgKxY
         mmSi3KchJd8bCFU7zsFqIJutuHwQw/UYQoYFbthX9gvIK3HDeEvvYWA0vyVR66uhhPZX
         IZUL8yF8pdLi7QCwLVtv4JFl+knXIJ3yFNrYSecSMJSPws5lVBxyPa73HGeB8GXJZ1pR
         FB9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788086026; x=1788690826;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=JCz6TGTeY9Fm3CRXI9ycezdJoLH0CKAS6XvyEH2jrh4=;
        b=GmKOyiuNLv+bOAn4glJmcDlBeP0D39lKdOSq+MnMUfEFku72QeOQ8sRxTH0dy+gz7j
         DOYaq9RIOEZc8eoGKSrOVAVwGh1clj2AF/r96TVEEabQYwhw5wQCwoIIJrKUQ3ek618N
         81z3zakSMrZWdyrOJ+GYkfnSXI+aTPOfcKNxRi7HbUInKxCO7k6kRHgB/me7ESbw4hBp
         0Ff0lqm8KhPxKqzXZiXBEZ9GZMqdwmJ8uhbsKsLQFBrxyM+kffMRgF3CxKCQjQ8evDPF
         FqYDdUxBCHi6BM/TGPt8Vpw1lck776Nnqb3hitLJIFXPIXJ1XDKgJf2mAt6Pdb+f2iqb
         E2lA==
X-Gm-Message-State: AFuF++n1rmppTzD48uyH6uWWQbgPci1i9lZMxTVJMTwNADPCVjvPt8Dm
	auvnke5Ct7rMERRQYc2VQq5eN1kqgmklWH81YHSYot0bBQ9OYIp5P0URPxPChhYTi/cEotQJEBf
	gUxwZ4fnOKc/MnwbT/7cgSxYgEyBS65s3zuIk9szwpehSqOmk
X-Gm-Gg: AR+sD114aA8oH366UKoMU/ylsW0rfVKklDkRqSdsJCcQsWB+ktzMNbrmjEGUea+ofwi
	5YVIhK4RXkOGaP+ddJE6S3Qq+li+nZduBVUPHJNNki6nICNuuAwTOpfqdttXXDQCG/6lZwm/TFc
	OizQ2Ui1RtN9e/Kihx31mHOGPCleRI1MWxaQ9YEggdj2YJCCs0MlOJ9xtjVyXNdOrPyLEJQyhjl
	1NGkcp/EHZZt++qqXjP6NJjnWc2QV3yoCTTz/XaI+sRV1CsAaa11AiqYY21kD+6NO0pH2T46Rug
	Zo3jCUm6jAi3jaEQzNogRBSCOhFVPbEVyg6YDcRMYNIVTKcXnQ5NB0JlifHBN6zKFV6mqak+uye
	0OqX0OKFu6lnKxTDkPK87ZxBreI1pMUljuJKDkNzd+g==
X-Received: by 2002:a05:622a:5592:b0:52e:12e8:54f3 with SMTP id d75a77b69052e-52fb93b34a9mr275721481cf.8.1788086025949;
        Sun, 30 Aug 2026 03:33:45 -0700 (PDT)
X-Received: by 2002:a05:622a:5592:b0:52e:12e8:54f3 with SMTP id d75a77b69052e-52fb93b34a9mr275721061cf.8.1788086025492;
        Sun, 30 Aug 2026 03:33:45 -0700 (PDT)
Received: from [127.0.1.1] (bzq-79-179-7-133.red.bezeqint.net. [79.179.7.133])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49ccf5a580esm69304005e9.3.2026.08.30.03.33.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 30 Aug 2026 03:33:44 -0700 (PDT)
From: Tal Zussman <tz2294@columbia.edu>
Date: Sun, 30 Aug 2026 06:32:27 -0400
Subject: [PATCH 5/8] mm/swapfile: use folio_page_swap_entry()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260830-folio_swap_entry-v1-5-7786b52acbc8@columbia.edu>
References: <20260830-folio_swap_entry-v1-0-7786b52acbc8@columbia.edu>
In-Reply-To: <20260830-folio_swap_entry-v1-0-7786b52acbc8@columbia.edu>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1788085997; l=1012;
 i=tz2294@columbia.edu; s=20250528; h=from:subject:message-id;
 bh=QUnk24a5m8yz5ZbJrqhe5QuRGQ1y8Pb73+CWqNpDSpw=;
 b=rD3bjW5VlbToPZmsPYLIPdScpwZ9iyNjv5RFx5o7TeUw25j31bQHhyFDgRRA45Wy3q+XZswAN
 z+0pSelEWUqAt2c+uOLcWNt4kpdF525CGBahVVb1EDd4i59VGMgTxN/
X-Developer-Key: i=tz2294@columbia.edu; a=ed25519;
 pk=BIj5KdACscEOyAC0oIkeZqLB3L94fzBnDccEooxeM5Y=
X-Proofpoint-Spam-Info: AW1haW4tMjYwODMwMDA4OCBTYWx0ZWRfXzXqsn3UJbV2W
 mELC7UIb+MAcQIcO1wbMIzQjmEg0pzGutb7eRCP/Qjj6K+Ky9NmI7qrKan6vS1+cYXbUtF1QHbj
 VHUJJQdrYfXNJSBwZeGKtNS9PtFSuHK+NHyiPYoRULXsiwqVyS1u
X-Proofpoint-ORIG-GUID: tzNx2M0vWdlonf1ar-TFMdV_705d7NAd
X-Proofpoint-GUID: tzNx2M0vWdlonf1ar-TFMdV_705d7NAd
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODMwMDA4OCBTYWx0ZWRfXwU/qQp6OKI/b
 G47d5izdoBi0qWEmTcsV9UOOC0dzCMWRgiuz6DCjRbo8vX082HnDEky6fZqwYW3hONzGqypKTpj
 FfJ3SSAKf4sw3u93FOzpg0Gz+qAGJOD/fn4g3140FAWed9Da1Ym4FKKvvJ/eiIvtlQyym2E7XPH
 lbBbbKUDbEbAkFe28FB1BwpAW3EprBp1544nMiMMhqFLR9dhw3DIbshiLjLx8RUMNGNpRnafiji
 fO4EXE/qeLgTqYP5et+0OH0eqRULauo1x8C8x/Ve7C2lO4viMHGFlYdaG+NlH+uxzYDNWlTV0oj
 Yq5f8SKbj4mVPGSma9wGnK3gIfEqEimt3H0PwJunZAIkvqGXF+Ew60o2b4gkuvlM60M7N6Y4RIf
 h5a8OHE0qfL3neWGkQIa8OgxTfhOVRBZt/gaqJZafnjHwBG3hzc7h43s4xHSJ+MmBM2Zcq1p/nP
 +vn4eavG1JYC7hRyJEQ==
X-Authority-Analysis: v=2.4 cv=beNbluPB c=1 sm=1 tr=0 ts=6a94070a cx=c_pps
 a=JbAStetqSzwMeJznSMzCyw==:117 a=LRATYcvZeiQrLRB5MfbBvg==:17
 a=IkcTkHD0fZMA:10 a=Sv0fKeRqtYgA:10 a=x7bEGLp0ZPQA:10 a=A0y_DWxS2BwA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Da8U98TiO7q1upZEImrf:22 a=azVShVRs0zEubeQ0wG0L:22
 a=xqDBoplpeononJk8d44A:9 a=QEXdDO2ut3YA:10 a=uxP6HrT_eTzRwkO_Te1X:22
X-Proofpoint-Virus-Version: vendor=nai engine=6900 definitions=11890
 signatures=596817
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=10 bulkscore=10 spamscore=0 lowpriorityscore=10 adultscore=0
 priorityscore=1501 phishscore=0 clxscore=1015 suspectscore=0 malwarescore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2608300088
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: tx5dzazp7s8dmnmuzo7fah4fj61pfebj
X-Rspamd-Queue-Id: 785F31A0005
X-HE-Tag: 1788086027-572171
X-HE-Meta: U2FsdGVkX197csQ9MjdIREaXBbupuCMeMBfXYNQEPWA7cBcV+Js/qd3lB+8EUUp8DidzIRkgc6GSFu9BjlbVvufVNcls50tjWezDg/afMhqKDobxiJF7mHQ4y2IZOe7RfUtjEg/40N4a0aZiaAqn+18pSPoqWhwbGRAO4FXV3Jp2DxnaKGdpUqXAkpzHi2GkwAetsGN3FyxCZM1cpcrqooZWvmmJBeoH7i1B3V7HSKwL9nHhd0tP2P8Tls8hIbhka0ZQbXGgoKQNoUWv9Y00sn9IE0Mq1SxyFhvGu0VXnNQmu0GPBn6hWz/+NKEn+BFOTMYrWXOrOrmSilt1VKH4PH4azp3Kb3A8DhfYR7+v8/BKGOYWsgP4gCJ5pPAVC/TLcX5MD7yrQgxnBhRVp1N2d4UKsc+JBP/2sAJ3lS+BKXaFXg95nSm98R6UNN9mVvkmItVt2Uqe4toMH976/n8CB05agDBmSV8Lu7aVHD+ZfcRG0NvRbgzbU4fpGN61qhyMxPhve2xZb5AwPfqPhVhgZYZi8uBQJuOCrWDOfG8rKNigY4VBgq8VzZpMDKM/ocU5h2SJSOTaKs9qa3EmgpsiN03ShksThCO92RPTyTOKMI9Xr/blBtCxSG0fVeRlnJMtTTzdWAr3r2GBksDxwg1aMRf47Ez5jRsnxHH2HfA/8NK1FjCehR0BDC3hcS3H6NvlcJJw0Kbmw0AjpeSvXudznbjE0d1o5N5Zz7c1hCP9StbeqIX804XhiC5GPzj9s70zsJzDbTNUwI0j6LHW+yPjHk2f6RIAFXFVqbz23GI+Bx0qStjzYx9SNFjqtGZW9JPneYFZ2e4gIagw4uWeEK93Y1EShKw6b+jH4Cup1+42/OcK0YxSag11B2DpCjhx5XzXjOHenBrqlR2yHpSutzfgne8+ngokt1MdEKqPADfKeY/nfI0U1Mq29oW81cbtLjpASSW6Ko3YahN71+8S4Ly
 dPua4DKk
 QHnPh9kAdmjk2hK6wWgw5L+3XBPo21SzhT5myM2K/p0h8Q8EJHdGcNyWohJQzCSwoLpcjwRgKpt64JzbWowwgIxr/8nuTlvfWtZ+AUdY6XAs7ar0TvX3KgSZE8ullSipfuC5JTD2EwIJrduwNg9KDAu3C9T5pzJ1977rO97gb8gLptdj3w9TQ/jh2GSG3mpYzOiBTXWVv15hEjAnTeKxAqjqI5Ho1UjEfC3Rv+NrzNGEWj9f4W9YfgUkw+Pq7y1NYJMAx5Dac9kEjNifBrenGJuFPe8DdnoBy6FjRGCI5RgHCqwXHyp44A7Sx5AtKZUQn6l0tc+oCWE6v74NMRR1p64bnU1GRxCl2I5tLwG89GNKlYeSUZqpyYHNFjoZtP7PjXzvUJjJM5hgidxolKdsZN3fSU4baBP+JZt/u5EzMMqWUP+g=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

folio_dup_swap() and folio_put_swap() open-code the swap entry
computation from folio->swap and folio_page_idx(). Use
folio_page_swap_entry() instead.

No functional change.

Signed-off-by: Tal Zussman <tz2294@columbia.edu>
---
 mm/swapfile.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/mm/swapfile.c b/mm/swapfile.c
index 58db70424253..c7b8e69a1227 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -1810,7 +1810,7 @@ int folio_dup_swap(struct folio *folio, struct page *page)
 	VM_WARN_ON_FOLIO(!folio_test_swapcache(folio), folio);
 
 	if (page) {
-		entry.val += folio_page_idx(folio, page);
+		entry = folio_page_swap_entry(folio, page);
 		nr_pages = 1;
 	}
 
@@ -1837,7 +1837,7 @@ void folio_put_swap(struct folio *folio, struct page *page)
 	VM_WARN_ON_FOLIO(!folio_test_swapcache(folio), folio);
 
 	if (page) {
-		entry.val += folio_page_idx(folio, page);
+		entry = folio_page_swap_entry(folio, page);
 		nr_pages = 1;
 	}
 

-- 
2.39.5



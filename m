Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 37407C79F82
	for <linux-mm@archiver.kernel.org>; Tue,  8 Sep 2026 15:17:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 836EA6B00A7; Tue,  8 Sep 2026 11:16:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 80EDE6B00A9; Tue,  8 Sep 2026 11:16:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6D6326B00AA; Tue,  8 Sep 2026 11:16:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 3DF206B00A7
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 11:16:58 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id ABC101606BA
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 15:16:57 +0000 (UTC)
X-FDA: 85190947674.13.B8D0BB1
Received: from mx0a-00364e01.pphosted.com (mx0a-00364e01.pphosted.com [148.163.135.74])
	by imf07.hostedemail.com (Postfix) with ESMTP id 381F64000F
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 15:16:55 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=URL8qlju;
	dkim=pass header.d=columbia.edu header.s=lionmail header.b=z7pMJbdN;
	spf=pass (imf07.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.135.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu;
	dmarc=pass (policy=none) header.from=columbia.edu
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788880615;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fX9NElGdJ1vvg7lNn1ooXtrYJaw0f4RzbfQAdaHbR/Q=;
	b=LPtwE2mZdvfc7JN8qOYCjxSMAKr9vDLfVhQFu5mEtCjj5d0d4j8MqRLpUL/AIebNrjwyYX
	8GituFaO8Zyv0L4ib5EhFFAf2Ggt0mt2CfT8ksMBtwnoyV7ybi3Pi+3uuHzalV+UYuv9HF
	RRx1dryHzWqSWRBYYPxlNwkBVM0i5Bo=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788880615;
	b=Z99jwiVR087nvYRdXCKmgXG2uDs9Tlup1kaoyKPm+CG+0tqHXqhppiZX9pLUEwE0ywgP/G
	6cQnqN0tzyw8EYChEh5Ys0erwt/1QwMl/D+8U1G6AUTJRFs2zrJB9SSlYQ13O18Kj0Zmmp
	3OtmGOYmGxa78C/hUWK8GkxAqSoWMHg=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=URL8qlju;
	dkim=pass header.d=columbia.edu header.s=lionmail header.b=z7pMJbdN;
	spf=pass (imf07.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.135.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu;
	dmarc=pass (policy=none) header.from=columbia.edu
Received: from pps.filterd (m0167070.ppops.net [127.0.0.1])
	by mx0a-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 688EYod0900164
	for <linux-mm@kvack.org>; Tue, 8 Sep 2026 11:16:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pps01; bh=fX9N
	ElGdJ1vvg7lNn1ooXtrYJaw0f4RzbfQAdaHbR/Q=; b=URL8qljur+o26RNDCwhc
	3otxNMr2qFFL7YmqHUgEk4Ox/BW7+OhP1HTONIGtt/wEcTTAEhw4CQav4KHY3grd
	ycpKIXbs9EvBw3TELRqqCd4D19Yv1uRnkoe94QRpy4O+KSa0cTHtWocpZTOzfMUh
	ByysD6ZPx4pnuvP/y+Z5zt1XCO0iHb2IJuuCTtN5L3vkKydqmhlPUGYpu3CPkd8m
	d8QgsZS7oDb2/z0OieyYkUORtzY2eCGqAUfpDe1GSNgcd0EGpcmInARCvRzL2H4f
	2cFO7Jv7ZAVanKzGoy7vuxFsw+KqKY0Cx7Y20Yh2Y7rm+yM5ukMDuOmSAkJ/Z4z4
	AQ==
Received: from mail-qv1-f69.google.com (mail-qv1-f69.google.com [209.85.219.69])
	by mx0a-00364e01.pphosted.com (PPS) with ESMTPS id 4gj4ykw1kp-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Tue, 08 Sep 2026 11:16:53 -0400 (EDT)
Received: by mail-qv1-f69.google.com with SMTP id 6a1803df08f44-9103f4ddce5so51724386d6.3
        for <linux-mm@kvack.org>; Tue, 08 Sep 2026 08:16:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=columbia.edu; s=lionmail; t=1788880613; x=1789485413; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=fX9NElGdJ1vvg7lNn1ooXtrYJaw0f4RzbfQAdaHbR/Q=;
        b=z7pMJbdNEs9q3sdP0k+eFJ8wYkmarAQvKfIkWqCBF0AJfOQRgTWAj6Gc+N3Dl0kOfr
         NOdPBlHmiqYY0pVj7Dmlh02K51/i2Q/pwhOYuaNf13YiSwnI9K3awWUNhnXxX+uytSZO
         8hxDnTwOWH1Utu4hmEG4f3UgpvKnEZxoperF4ZbDYqJOjVEWtjDmEcSxNL26Pg6uuKbk
         fapkxBjxhjgC6vZfCAP/igKv2QDUEEn9Y1H629I8L2tZRRCTd3QnnyAx1AuhnnJcNU7z
         ilfwci13bMGHRJ0sfFBaEQivZvQTMh5vh2PbB4lY8DR8pW4S5IW+jFW28/zXFZV23g0v
         3kRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788880613; x=1789485413;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=fX9NElGdJ1vvg7lNn1ooXtrYJaw0f4RzbfQAdaHbR/Q=;
        b=nhz3FCQ/7zYIjxpA6GKSr7+L0RyTNnaytoE2QNYFy3JDZ/+GPPif4nkTycH1lc6WQu
         2+ZizXHwtPfb4EvBkGK73MXy4M8n9ZEyWjL0DDT0ieYSPHX4iAnmVN8i80rpHdbINbdV
         8HckJs46n8Z2mDMc0vD84YLZjMAoqSZ7LRX/N+Wr9b5nmphCO6fAQwvhsGLi/p6XjZK5
         lVvTqvQhntMhJOKziJi1et0yekebuSJw6572nYS3pz2NI8nwpbwDVbfZdcwC3CKWTtTr
         VL/Qt9FkXLPqI7WXXCuDcykxMOaeIC+Fntm0RMgW6XPyfRMdx+c5U8uQyBL0JCJKOsfg
         FiSA==
X-Gm-Message-State: AFuF++nsRBRYSFxRA/fPV8HdzHnuVDfXz1iggvn8/d5M2Z0RW/H14bTk
	jLI1I0MEc+XuOeod38QYL7vp2SP+YVy4Ut3VW65PwHW6huQJ6J1DZ2cqwB2bwMEmVrsaKfYF3Vl
	JsaWTMDASwm0QsbcuSU5m9vRtQIjzk+Wad58+wbvMIz6V6se8
X-Gm-Gg: AYBFou2qI7m9mey32IqlfiTgU2Cmy+dePzsm0WFsjzwd7g9A1RwIKyP9aclZxnl7mDU
	9g7w/De0/uAoYiEXGRjwPMn91bMrOwDjj4Cbk5j+J26Xqv6bu+iGV2YW8fHIewINcBLiI9BDm+k
	iaQjRRdgkk8GK2Joe7vqilx2fV6JceXwdUprIQ5AJ09KuSERd7m9Rn86HzlFLWr+qhOjiJWH5Iq
	qtJYNa+rtw1Tjn2irJ4cohuuEC8ZgcX2YOTUQw54VsOJEc8i0Szj/bCrdkST7TJzgJdx2b8eG7W
	8y6bLcTiJADJDOtt4oI/tTrWfXiduazb1cjwhmMDZl/7IwyUJz9rnUOrhbVViciP+7tTsjjoX+b
	GwlzDpilRiYEsKhlk+jflKlHvZK+sv21/g2PB9mVvYWWTkmS0h7UxAw==
X-Received: by 2002:ad4:5aa5:0:b0:90e:838f:d282 with SMTP id 6a1803df08f44-9103ef96606mr374577566d6.18.1788880612860;
        Tue, 08 Sep 2026 08:16:52 -0700 (PDT)
X-Received: by 2002:ad4:5aa5:0:b0:90e:838f:d282 with SMTP id 6a1803df08f44-9103ef96606mr374577136d6.18.1788880612245;
        Tue, 08 Sep 2026 08:16:52 -0700 (PDT)
Received: from [127.0.1.1] (nat-128-59-177-174.net.columbia.edu. [128.59.177.174])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-91040673ce0sm122105496d6.25.2026.09.08.08.16.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Sep 2026 08:16:51 -0700 (PDT)
From: Tal Zussman <tz2294@columbia.edu>
Date: Tue, 08 Sep 2026 11:16:38 -0400
Subject: [PATCH v2 8/8] mm/swap: remove page_swap_entry()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260908-folio_swap_entry-v2-8-ee6d01dfa5e1@columbia.edu>
References: <20260908-folio_swap_entry-v2-0-ee6d01dfa5e1@columbia.edu>
In-Reply-To: <20260908-folio_swap_entry-v2-0-ee6d01dfa5e1@columbia.edu>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1788880600; l=860;
 i=tz2294@columbia.edu; s=20250528; h=from:subject:message-id;
 bh=CwVUhQtJV5BBiMFIF7YsJllNsqsS2ZgEmWIprGlfLYs=;
 b=tyPDhjc61YJsztH5Euj8TQKxOFLCx/bN5LNbg4nPR3nHokHNyj+eIbeFvKstLN2ZgLUq75Jp1
 TIiTx3V2yBJDm7QS92klbDglsyL+bdllOp4LdCCYZmItGrGmI/LXvyx
X-Developer-Key: i=tz2294@columbia.edu; a=ed25519;
 pk=BIj5KdACscEOyAC0oIkeZqLB3L94fzBnDccEooxeM5Y=
X-Authority-Analysis: v=2.4 cv=bJQm5v+Z c=1 sm=1 tr=0 ts=6aa026e6 cx=c_pps
 a=wEM5vcRIz55oU/E2lInRtA==:117 a=HBUb3goEnnz3w2smY6d+Hw==:17
 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10 a=x7bEGLp0ZPQA:10 a=A0y_DWxS2BwA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Da8U98TiO7q1upZEImrf:22 a=svvvyxlR1OQQkelhaPoB:22
 a=t2YXVXqu3yB8mPBWm3YA:9 a=QEXdDO2ut3YA:10 a=OIgjcC2v60KrkQgK7BGD:22
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTA4MDE2NSBTYWx0ZWRfXy54uViqYGMFN
 BXN1Hvm+GojEOQVPLXC6hz5B/bAtx2STEH8nYpP0BM6BPU0t3A3FmoRk0Xyucmf7yKhJzN9tT2H
 CkHa7/BaHxPmAJk5987o+U6aEFt7TGJSK+Op1Ke3TKvh3Pso9Ul4
X-Proofpoint-ORIG-GUID: p9j9IMYh_tExfeXgbAGiPv8nmR_pKr9h
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTA4MDE2NSBTYWx0ZWRfX0fzaBgHCQEgZ
 ikEwfhH8NqbmpPYI+C0T3GHThsiYKHintea2wAWwvDxy7PHJ7YGp7vnNh7NYMvi7uhcP4VmVL5A
 f31PWEnsxJrJg+lap8xFNs7m9PMTYntlXNEafrpsLcHupbU548uAhVuL3NW438TWHbGC+BBdZCQ
 GHyVBTZYG6StBJm5Aq4DRNKWruQa6v1pyCv2LerhOUroLzaJWD1O8s04kwE04d4oFdQEy+wMwZz
 fXzE2jnKHw2Pf93gxXZRo4vISvA6h87uzvGTTk0V7zFqSpLuHxJnQinuz0oI1nr/4wEwEpNW5RF
 +SK0gu9yAQiaT2b8XnKitLN1fi2kBOBIxlUoJl15/PwZNqtiB+6JaXOrGnJgB/BFCQzc4M/+cO7
 Flsa/Bvwu7M8nGzaGZAnQpaAMCgpanjHZZxaVY5jo2D1zahG0GFupPW7uzCXan9mFO0QQ0Vp7hC
 ykv+apZb5ckeZ+kb6xA==
X-Proofpoint-GUID: p9j9IMYh_tExfeXgbAGiPv8nmR_pKr9h
X-Proofpoint-Virus-Version: vendor=nai engine=6900 definitions=11899
 signatures=596817
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 lowpriorityscore=10 impostorscore=10 bulkscore=10 priorityscore=1501
 spamscore=0 adultscore=0 suspectscore=0 clxscore=1015 malwarescore=0
 phishscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2606150000
 definitions=main-2609080165
X-Stat-Signature: rj4hcukxjdjaxz5ifh6qmkd1uikwn83u
X-Rspam-User: 
X-Rspamd-Queue-Id: 381F64000F
X-Rspamd-Server: rspam03
X-HE-Tag: 1788880615-169719
X-HE-Meta: U2FsdGVkX19d1PHAGVGNfkXzPYnItAKfl8sLkjWiADh+PAL6Q5TIEqzAA+1PNdmJyz9fMN6sE1JdMJPGDwwHhTNtfBzENJIU88dFjAHkT37NmWEScGRvG0o0V5COz5l4wZ7G4+j5JPDgBAPCy1AT1Da+vDiKSXgvGn4ThiALFuySG3l+HHN7wq//eSl8m4cMAMyTo8WKVl1u/udLQMX9jba2fhCXj10dS45Zb6UZrNiPewqgxD4GiSZIZVR3bBNxoPo5PnlDWRLOFoQ627tcTct6Bwo4Qj8cvQrgp+gxSoJyu6MjcWKT0vFBbXeckl2PtgUy8EyMGRT20NYZc3zMo1efNF8X47o8+fFDoByHQYveQe+hHNhft4Ab31NzxYqn1OnYQ9FlVzgNHIlsfXZExXpBPU2PtsjH0LiivkKZjl+KrZKmIkcyNybiYU+lkIHepM0em9yf0S04zhVMj0Do9A3GhxDHx4bAIzwTQM8MyTHT0dPy5sk3oZuCIjeAcwedyNYYYmWP4BSUm18NBq6q3ITeuDx5zHw8gnPT60ambfQN+wMK3L5qdwstTwTX+HRPiNC7G9dVpi+xzwkd9TONEfbEWBSblBBUv1EOj8Rm0a2scfbsYYSuwbhOAyIcUIrROAvm/YNwzfGAirI5ZZ+1r9QIFdpVnv6Uurq/4cq3OJjJi/3tqLvfUCbmJ3e54/XbBP6g/cDmpFga/i/VIlrV9Xz/KESxjSp1IsRsav5iO0zYaj8j1Ed0k3m3b+kOHPxeTryHrc2pgYWZUcMZg1MUhhXckztZZm48OgHGR7I2D25YgAAjVzeTSBm/odbPT89fqV/Fouzu95ndsDfnDxKZNifdUdA7Y1xYTKP49P2khNBLmo+CHFE5mD8y3BN502Ysg17kwXScwnC6uoB8eaQDwNZ/dJG4LxrecB/IndONXEUFaxyTe060SD5Q2GEaPJaJ5Kk/SvtX+LXLTyGAGth
 wWW7i8df
 tpd4yXn0ZGPMvPafgJVFVyuqpv2GjQVVuZXcSG5pGRbF66201kdJmOEQlYG+ImkFaOmmmFBm2YRsZp3k6MUX0LV6pohGqH0sf/uI3wkHh1/5PpotAVBUYaGBcU+4FMlnj1PrviFbx5r97uRLroyFmKkgkQSE9kukZEQL/FwgBGVl8nUJXlhJ+lJrbBm7YxwAN226E8jBNg8DfQADnopunvQk5e8ozpKcRRIjfX79182kp40YmEuY7Mz6ubrarJCJms9zaBNBYnBIuIsnJi2LIXqHebPn7uTAkoCT+PsT3gdntah/u8/xvP1f+4jdHcS3cnavC+ZaYXzYkmBVq3LLpxsJwGuT/7u+5JkIeXoKBdxcgQWguW5p2NYg25WqDmrAnnugs2crx4mlQl7cDe9JXRszNS365vH3TWRDRjdkrfLNjwzU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

All callers have been converted to folio_swap_entry() and
folio_page_swap_entry(), so remove it.

Signed-off-by: Tal Zussman <tz2294@columbia.edu>
---
 include/linux/swap.h | 9 ---------
 1 file changed, 9 deletions(-)

diff --git a/include/linux/swap.h b/include/linux/swap.h
index 1d979e76e78a..8032a0f3c319 100644
--- a/include/linux/swap.h
+++ b/include/linux/swap.h
@@ -305,15 +305,6 @@ static inline swp_entry_t folio_page_swap_entry(const struct folio *folio,
 	return folio_swap_entry(folio, folio_page_idx(folio, page));
 }
 
-static inline swp_entry_t page_swap_entry(struct page *page)
-{
-	struct folio *folio = page_folio(page);
-	swp_entry_t entry = folio->swap;
-
-	entry.val += folio_page_idx(folio, page);
-	return entry;
-}
-
 /* linux/mm/page_alloc.c */
 extern unsigned long totalreserve_pages;
 

-- 
2.39.5



Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 907ADC79F82
	for <linux-mm@archiver.kernel.org>; Tue,  8 Sep 2026 15:17:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6B0696B00A5; Tue,  8 Sep 2026 11:16:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 689E26B00A7; Tue,  8 Sep 2026 11:16:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5509F6B00A9; Tue,  8 Sep 2026 11:16:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2B4EF6B00A5
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 11:16:57 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 89F5E140728
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 15:16:56 +0000 (UTC)
X-FDA: 85190947632.16.55742D2
Received: from mx0a-00364e01.pphosted.com (mx0a-00364e01.pphosted.com [148.163.135.74])
	by imf27.hostedemail.com (Postfix) with ESMTP id F3FD54000A
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 15:16:53 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=VPfBwFhT;
	dkim=pass header.d=columbia.edu header.s=lionmail header.b="aJC9/W6O";
	spf=pass (imf27.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.135.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu;
	dmarc=pass (policy=none) header.from=columbia.edu
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788880614;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TUGgy+CgNjku4PJ/FQqlsQRbEqOOlPzZGqKdff23MIY=;
	b=WQSdIiELiokIYcij2wDgtAecjM93pOdXeEvZrnRz2v24F+hULZpiSeYZd4q3V41zsoU3gX
	DFqA4a0nBnQLQ6p54In5WYWuJzcKoK6opORut3I3kXjaKM2mabUU9g5NAB3MdnI7AKBGAZ
	MOsVVESD2BdQktdg5Q6VOeiutoNuQsk=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788880614;
	b=iuEaJgOsH6ZWzA3aA3egrbNjfSQfq5io3056AZxG8jr2NsABr33qOrfX8/7AFgq4HWeNUq
	7CvJR53Jo68jafZdw1D/PVDTVXZYeYe9rdi4goU49ZJoEPc7bukYOt/G7s9qoJzr+mGisu
	rXGjQWlNrXsvd57OwhzzOKocFRb7Dsk=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=VPfBwFhT;
	dkim=pass header.d=columbia.edu header.s=lionmail header.b="aJC9/W6O";
	spf=pass (imf27.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.135.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu;
	dmarc=pass (policy=none) header.from=columbia.edu
Received: from pps.filterd (m0167071.ppops.net [127.0.0.1])
	by mx0a-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 688EYpun2420867
	for <linux-mm@kvack.org>; Tue, 8 Sep 2026 11:16:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pps01; bh=TUGg
	y+CgNjku4PJ/FQqlsQRbEqOOlPzZGqKdff23MIY=; b=VPfBwFhTXlKFwWloCWqY
	doiDToCv+ItHMrqPO8i1W6Tgwgz/M5rRQJYpKEfNUMWz5BJ2yLG+uh5r0CX3wyyq
	TKmf1kQmAGXXF3BJiEXFXxeso1ZOcG2jGlJZLCjrKINYDYBLatBvLKfKfPfcWcvO
	m0ayVUqVqT1dVAi7f6Qsa0hLZhPTzL1rNniu2/8pm2cMKQP+Sgeb0CvIqJl2TFbA
	vSLEIvvAgpI3kJk5ot7pZHladU6eFzG7h4Ajx6Xp1X0gl390LLJ48qW4au+CZrVI
	h4yF2ZuGZGkAOgNtYYq65A/PBG/UWV0El1iRS9lZegUCHrlUD+ytH0gxUUSpGfRw
	mw==
Received: from mail-qv1-f71.google.com (mail-qv1-f71.google.com [209.85.219.71])
	by mx0a-00364e01.pphosted.com (PPS) with ESMTPS id 4gj4d5d7te-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Tue, 08 Sep 2026 11:16:52 -0400 (EDT)
Received: by mail-qv1-f71.google.com with SMTP id 6a1803df08f44-9105be46009so28387036d6.1
        for <linux-mm@kvack.org>; Tue, 08 Sep 2026 08:16:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=columbia.edu; s=lionmail; t=1788880611; x=1789485411; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=TUGgy+CgNjku4PJ/FQqlsQRbEqOOlPzZGqKdff23MIY=;
        b=aJC9/W6Or5rQ8Ok6fzE4OXWzXlDYG7Tg0QKQDvYc2TIgrkq+WiV6I6mzIxKOarjvNE
         OD+OChIwdFch+8fSAMgp4i3TShonbMS7p4N3B1I4Zikj/QEIzfdShEtqUM6j06rm5rYO
         NbRJBFTkHWdV4wFdHdVVA5/X+r7TOqlQqMIsGRRhN8/yj8LQKFbrmmDMPhGUcnpinKeL
         82+lNWMkgIZN9uX684/y5CojM0IPM02kipOLxz5Huj9y/3v/hAoUUyN8KLO9RhVjKWG6
         pNolJ5h2QNl1LIf/lewGgl3L6I+nDAWVtw69N/4OZu/IvdyEqW59/kka05vgZMyQaGin
         Rkmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788880611; x=1789485411;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=TUGgy+CgNjku4PJ/FQqlsQRbEqOOlPzZGqKdff23MIY=;
        b=UpAKbDavXeLl+I85xxK2jYoiOp5MC7hJCZR+RaWBmKI/+a81yMDbtOf7xzJxt619I9
         OjXupBsu4p4AKa0mo2NpZAEEZ4xSpcBM+wrSJqQ23iWoimQXnAsF8TW/6DJpdSjbKUo8
         svntK6A2bn/PdpIOA9qBVfsCv6B54ZnPK1mhgq5sQrkGwP6THxyJPhZF6/dr2+2wFtIO
         FCSYPe4odsAO3DfLXmKF5Bx57SZCaxDgGbR45Lvf56bc9gesH31xc8soq77rwjPdCq39
         I/+MFMHfGglApvxMM/5+Go6fdOwJ6UF9n72GLY2gFbalENd4TZ4yAS7L5DjVx4FI5WFS
         gSsA==
X-Gm-Message-State: AFuF++k0uHDlG3iiKkmcAxiyBv79OeVAqftO6HXraSLEoAn7HyvwiRqC
	pXwRGJ0aYoaGqFqvEiMU2pXvhxyvXBc9Dbi0LGf+xqEYKnDKzaq4Rd2FYz2KecnBmAIxGvg6u/G
	oW95iTsDkIVbxfJ/l7XQ0s7GCB/JY6xYaZ65z4uP2rwP+iCly
X-Gm-Gg: AYBFou1Cx3IXZ6jGk32r863OTDHg1fIozuepe6jyAfFSA6TymLlrOo5l+zrdDtF2M70
	v6VeUYurPIJ9K747YmeRJL53WMpG/iP6fLpzviCh0QMSbUUrXSt/BL31ojxIdg3t1n40oPU6ZvK
	Q9su9oEFqhugiz0bikPaD8kjj4WKuzFaFNqIQIxO/FsFfIvMQ/mMpHq+vCmN0q6MMRDxGgKhrVF
	1g8vmXfjdzjKsnr7W1HVqrAzP3tao0PvWPYFrPOaV+P+RO1nUqhIGs1/3oW5PA8EQ1sKFN5mf3T
	SXh88vla9hyxKqNnj0VQw2hwrlrYqhABmjs7+4WysXzx0vM41aph1qTRfgNs1hslx9+GcOk3pta
	J2xM7+Aqb6HhOxo+ZUWpIZiohi+MXLFJM8XCkU3v5b3cQ+eQII1F/Hg==
X-Received: by 2002:a05:6214:29e7:b0:910:3b67:b793 with SMTP id 6a1803df08f44-9103b67b7f9mr305200516d6.24.1788880611509;
        Tue, 08 Sep 2026 08:16:51 -0700 (PDT)
X-Received: by 2002:a05:6214:29e7:b0:910:3b67:b793 with SMTP id 6a1803df08f44-9103b67b7f9mr305199926d6.24.1788880610996;
        Tue, 08 Sep 2026 08:16:50 -0700 (PDT)
Received: from [127.0.1.1] (nat-128-59-177-174.net.columbia.edu. [128.59.177.174])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-91040673ce0sm122105496d6.25.2026.09.08.08.16.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Sep 2026 08:16:50 -0700 (PDT)
From: Tal Zussman <tz2294@columbia.edu>
Date: Tue, 08 Sep 2026 11:16:37 -0400
Subject: [PATCH v2 7/8] arm64: mte: pass the swap entry to mte_save_tags()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260908-folio_swap_entry-v2-7-ee6d01dfa5e1@columbia.edu>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1788880600; l=2617;
 i=tz2294@columbia.edu; s=20250528; h=from:subject:message-id;
 bh=8STOz0RYKi+7v+knfY76tg8bbf4f7uqOVYm5Jf2KOls=;
 b=3yiqYYUgynKMq+RRIEdaUti5K7MwMUXqY3WMxl1fsFaH046VsOb7qrugj7sTwz0D6k7kygoPl
 s02ruplAlBsCYZx/5WBodJl3UJIHGU4Yv+lkcZNrMnk7xeKVJglYrmg
X-Developer-Key: i=tz2294@columbia.edu; a=ed25519;
 pk=BIj5KdACscEOyAC0oIkeZqLB3L94fzBnDccEooxeM5Y=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTA4MDE2NSBTYWx0ZWRfX/UaPcVb5Bo5A
 gSmLED6/B+5U9+xrVpYn1vadeCbWAakA7zt6RHBHhSRC5hElNDwPUFOkN4SfG6KhpzwPfOQA/KC
 zfh7GcelCSaed61kb0vYieCxU+B/d7r8rzU4uibDPF/yEJ4+Px6ZKC+8jktL9bOca4vM75yXNY5
 acR163Z0hFJe2u2kBs8HDtyu9p0x7Hb/RLvIjKgNS8ZfBKi7OpwjkwpYnA3kIpESga2TTwkBBBG
 oNe4yFhoYHTGI1XoI+NLAMmtu/hzG2ovQafF3KVTU/7oVAdonpAi1ib4OCAIQV1Xfboidi5NlIs
 qLJv7L3m6e91/HCBWp6GlPNCrtbmhUBysjZ2ePryGLkUnpTErKKxAuKmTHH2QyTx7Aj+nF7ThJH
 pcnLiLPN4aBOw02s0WsiFTVDss7M/uboUeBbRw6AoGNlt/9Ir4kumm30MwSml2xEvWGnsCqM1ax
 JdsJw642k6/7tJ10gsA==
X-Proofpoint-ORIG-GUID: nKQGG_8hmUHLo18kP4AvQwS419FUcuvm
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTA4MDE2NSBTYWx0ZWRfX9+/lP2sCFHLZ
 idA7eX+Dw8sIAznTL75fK1RkmWh+wSBu8RgFwC3/gnrEb9JoO+H/9lE0dt+k5tmm89sajM8iBBa
 B44KjYZfxvRw704E0UKYSBJKNZD/o+UkFoJpeGhN4Y2+OgcsUtzr
X-Proofpoint-GUID: nKQGG_8hmUHLo18kP4AvQwS419FUcuvm
X-Authority-Analysis: v=2.4 cv=BqCtB4X5 c=1 sm=1 tr=0 ts=6aa026e4 cx=c_pps
 a=UgVkIMxJMSkC9lv97toC5g==:117 a=HBUb3goEnnz3w2smY6d+Hw==:17
 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10 a=x7bEGLp0ZPQA:10 a=A0y_DWxS2BwA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Da8U98TiO7q1upZEImrf:22 a=79PYxaXUQd1wl-QFWJnA:22
 a=p1CcqGZxNqfKctaSDs4A:9 a=QEXdDO2ut3YA:10 a=1HOtulTD9v-eNWfpl4qZ:22
X-Proofpoint-Virus-Version: vendor=nai engine=6900 definitions=11899
 signatures=596817
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 suspectscore=0 adultscore=0 spamscore=0 impostorscore=10
 lowpriorityscore=10 priorityscore=1501 clxscore=1015 bulkscore=10
 phishscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2606150000
 definitions=main-2609080165
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: F3FD54000A
X-Stat-Signature: 9zq46hkqo5cp3iw5imkr5tnwojztgfqn
X-Rspam-User: 
X-HE-Tag: 1788880613-738629
X-HE-Meta: U2FsdGVkX1+YddFGlzN8sYJ9TIj5crCDAweEgK58bpGRGnGHJuEqNRW54xMuYc62HGDOLqeY7mmDDolSK2lPA1W9oaCCNGEOw1q6pVed1jH+xdCfga1/Ad+ZYRdyjuWkV55oprAIlIVS9947CJUsVNPCaED0yWsUlZj9T1lGyKh/tAgJB0+4r1XuQg/8R1TwnJcxo90iG2hq1+GxxK6KSN6Oc5FZNu4OYJpgL9isL5+7gUwURCcfA3eWzT+Gg+DfQSpBdSGkY+mJrsNTHuVhvH7WecRt80VYao1gj0vpZuVeYKuHMQRC/+rUdFvgT2FrVtazAkCt2hKSXCGJek8FWqucCTn1zz1Scc226xMsjDIpqVANfo6IHDD02uDBzAPj36i4MfFcdHsdVZKjXy9nL+WXLu247LkA8XPyhpqDQfitzAKbGY6ivhgiwDJXdB9xQAbP39QRDBZT35sh9aAdQxCNCJ9MFmo3FlnAuLaSzr7QdeYKfdoeWLRVCTcYzLXen7ueZQc1xqOL0w9sFcjdPQZptzZbnykJ8rswqjCHC2lL83UyqlIfvgrOKgs7ugpfOd9zVFLKVE+W80yST/vqTkPKYNjQn7EWK8bUaFxog57hdxZvpTJQ7sy6mPUfJvEFpd3dLjtyrO07PSujGxkItOQvD5jx/iKlpFIUfKLhgQLOz4M5JK6G9oSjNE08/9O3+Qqt6oOIk3DPVJOYjQy76Mr99EBxdFTsb3KqqZFMEmYJmNAu3wfsemcjHVeYkzK5l7vLPZCQfd42lJbfmx37Txa8StFp6OxvLXqDmOLZEHawor/KigSqYY4FCcgESQtKV4AUjG9rts5xe0LJBL9ACFzWYcT/1Wba0kfuSSLB54o2ZWJHSsKVy8uNNDbVjxAl12l8meUw/M5hSGOoEXaDFf0BFZ4ygF90iqwLoTZkmsRtsZAVr2HRw9jdCkI8Vhce+ZlIukGdM6755VpiCFq
 +3LrCpKt
 q8i7VbUEQw0lFE85c4ydosXXxSFOest+zjqqPGHqG7XOWw/X4rgETW5I5en9DkKmnq1TiN1zpqVDyzuw/87A16KEjeqQfhUuZXUduxXEfk5SUORmJi+w8UXbv0kDT40aQzogdkWGH9xq8RELbjWhQdrb8M2MkKoDYgsxk3ncXLYHgYExHprrSnYl6xhF6UoORnNt0Sq0KMOpU7k53+0zbKf+vw4mxOkFmv/lsWaHH9SbGpSOmW2XbFD7WyNr0TitbIRvdr7M9MAquvn8RuGHoqa9lMkD3JbsPKR/bRKgPO+JJFGzHJnorvPXOKlwDtcVLyita41PNhNIotXsKG6AzVG5jYy+k8Phx3ItkxwJOETUFZglXkFnolX1zCmMZ6VsFpysWUjg9TrGzOPbS5A6zGOVb1KRxtIcvtQfgzzrXSARajXE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

arch_prepare_to_swap() derives a page from the folio only for
mte_save_tags() to recompute the folio's swap entry from that page.
Pass the entry in directly with folio_swap_entry(), matching
mte_restore_tags(), and move the page_mte_tagged() check into the
caller so we only compute the entry for tagged pages.

__mte_invalidate_tags() loses its only user, so remove it and call
mte_invalidate_tags() directly in the error path. This removes two
calls to compound_head().

No functional change.

Signed-off-by: Tal Zussman <tz2294@columbia.edu>
---
 arch/arm64/mm/mteswap.c | 30 +++++++++++++-----------------
 1 file changed, 13 insertions(+), 17 deletions(-)

diff --git a/arch/arm64/mm/mteswap.c b/arch/arm64/mm/mteswap.c
index 3c54afc8b758..f64202b69309 100644
--- a/arch/arm64/mm/mteswap.c
+++ b/arch/arm64/mm/mteswap.c
@@ -20,22 +20,17 @@ void mte_free_tag_storage(char *storage)
 	kfree(storage);
 }
 
-static int mte_save_tags(struct page *page)
+static int mte_save_tags(swp_entry_t entry, struct page *page)
 {
 	void *tag_storage, *ret;
 
-	if (!page_mte_tagged(page))
-		return 0;
-
 	tag_storage = mte_allocate_tag_storage();
 	if (!tag_storage)
 		return -ENOMEM;
 
 	mte_save_page_tags(page_address(page), tag_storage);
 
-	/* lookup the swap entry.val from the page */
-	ret = xa_store(&mte_pages, page_swap_entry(page).val, tag_storage,
-		       GFP_KERNEL);
+	ret = xa_store(&mte_pages, entry.val, tag_storage, GFP_KERNEL);
 	if (WARN(xa_is_err(ret), "Failed to store MTE tags")) {
 		mte_free_tag_storage(tag_storage);
 		return xa_err(ret);
@@ -68,13 +63,6 @@ void mte_invalidate_tags(int type, pgoff_t offset)
 	mte_free_tag_storage(tags);
 }
 
-static inline void __mte_invalidate_tags(struct page *page)
-{
-	swp_entry_t entry = page_swap_entry(page);
-
-	mte_invalidate_tags(swp_type(entry), swp_offset(entry));
-}
-
 void mte_invalidate_tags_area(int type)
 {
 	swp_entry_t entry = swp_entry(type, 0);
@@ -102,15 +90,23 @@ int arch_prepare_to_swap(struct folio *folio)
 	nr = folio_nr_pages(folio);
 
 	for (i = 0; i < nr; i++) {
-		err = mte_save_tags(folio_page(folio, i));
+		struct page *page = folio_page(folio, i);
+
+		if (!page_mte_tagged(page))
+			continue;
+
+		err = mte_save_tags(folio_swap_entry(folio, i), page);
 		if (err)
 			goto out;
 	}
 	return 0;
 
 out:
-	while (i--)
-		__mte_invalidate_tags(folio_page(folio, i));
+	while (i--) {
+		swp_entry_t swap = folio_swap_entry(folio, i);
+
+		mte_invalidate_tags(swp_type(swap), swp_offset(swap));
+	}
 	return err;
 }
 

-- 
2.39.5



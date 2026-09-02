Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D5312C624D4
	for <linux-mm@archiver.kernel.org>; Wed,  2 Sep 2026 19:28:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 63FE46B00A4; Wed,  2 Sep 2026 15:28:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5A2476B00A6; Wed,  2 Sep 2026 15:28:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 469C76B00A9; Wed,  2 Sep 2026 15:28:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 1860E6B00A4
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 15:28:31 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id ABA821C1DB1
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 19:28:30 +0000 (UTC)
X-FDA: 85169808780.17.2C18A6A
Received: from mx0b-00364e01.pphosted.com (mx0b-00364e01.pphosted.com [148.163.139.74])
	by imf05.hostedemail.com (Postfix) with ESMTP id 29BF7100003
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 19:28:27 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=hVsrrlYc;
	dkim=pass header.d=columbia.edu header.s=lionmail header.b=B5TUGhJT;
	spf=pass (imf05.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.139.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu;
	dmarc=pass (policy=none) header.from=columbia.edu
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788377308;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Q9N4IW0Q0HkN9KT6h8CVRGegPfku8TwgZZjZ8yH7Mw8=;
	b=b1mZpLBbkjRYwMIGvVfpYuZuV+SdzKfrWQDWK3Uf6KqBWTZiNYI9pg9MaT5kAksZzg8qhl
	El2XzKMufc5KzYqYz8jj1hKKGz6BL+ypdioUVqg+UA4nB4f2trtSewac7dX3jWNohJT5eL
	3qCV8ShqWMk7YPbMBGgy+Eddu6BtSlE=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788377308;
	b=2blPupwPgMdTRO/mZ51d8HVOT1SxKPh4keh+NdxF/pYih3CIgdDfXMVVJO/YyGU21fAHmP
	hTh9/OfV/FrtC4PJwZ5RcXQn2KwQ/+rwXsnbFdRXcWp7zRvK9DxzEsD2AxR2F3AATa2IlI
	WYEZdeG/qD0PoEuQ8qunFg7Igns0wCA=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=hVsrrlYc;
	dkim=pass header.d=columbia.edu header.s=lionmail header.b=B5TUGhJT;
	spf=pass (imf05.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.139.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu;
	dmarc=pass (policy=none) header.from=columbia.edu
Received: from pps.filterd (m0167075.ppops.net [127.0.0.1])
	by mx0b-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 682J6jCc805167
	for <linux-mm@kvack.org>; Wed, 2 Sep 2026 15:28:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pps01; bh=Q9N4
	IW0Q0HkN9KT6h8CVRGegPfku8TwgZZjZ8yH7Mw8=; b=hVsrrlYc59XuGvwMLBIB
	79hF1PI9iXwfcm63Ba1eZwxd/Fbs7FreqXrwsb8TTjULXlpYWKxGzaKJ3pyGpVKg
	VsHUeNz9wzapy2ZAdNCzluWCQjTVjcSwQ3jImhqREivNoqu6zhk+dS+ytImdiu3D
	k/YR02g0i06qnTSTHiEpEH5oKyA9ZOLmvDefOspbZBDH7EV9dYl63cNpXi4YcXky
	GRwLFl0+VjkxNCuFaRcseKqydKfQpXoZJR4lkO18uo9aHWWpBxiMPIv9RdMUrUDQ
	uiYn0VlKBw2/8SpolixLs/UstwsHtSREwFrz/7As9/3QeUQBuRikiu7RKfL1Cfwu
	AA==
Received: from mail-qv1-f72.google.com (mail-qv1-f72.google.com [209.85.219.72])
	by mx0b-00364e01.pphosted.com (PPS) with ESMTPS id 4gesp0g54s-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Wed, 02 Sep 2026 15:28:27 -0400 (EDT)
Received: by mail-qv1-f72.google.com with SMTP id 6a1803df08f44-90ceabcd64aso30765556d6.3
        for <linux-mm@kvack.org>; Wed, 02 Sep 2026 12:28:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=columbia.edu; s=lionmail; t=1788377306; x=1788982106; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Q9N4IW0Q0HkN9KT6h8CVRGegPfku8TwgZZjZ8yH7Mw8=;
        b=B5TUGhJTrVW8zeRvIBybJY7iTCBum7kK3AzDYDzCEYNjL8D8xG2IYq6iwbwd7OU4mN
         TIiNc+8ncYKcC0/M3LC4YlaoHBKj/MM4KQBcjIQo8kP4tmPUVhbpSX7o5td05gMIgVE+
         FYgC8JIQ/VB9LnXlepuIyT2hQTSBWRyrNV0CHuwp0l5RBsJBcb2LIQCgzcDNKhStpAXU
         ZMu0B4PczUDbkcLWUy+7PxArD+3vDm7iCJxz94J86FYyE8npWffqX5XjR/3jQZAmohEk
         pu+IXDSAS1BLrxd+Q583WrsvSx5MJEVY7GJjTVrc6vk4hNG8lY41gBvCrTHowH3vud7J
         r1Nw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788377306; x=1788982106;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Q9N4IW0Q0HkN9KT6h8CVRGegPfku8TwgZZjZ8yH7Mw8=;
        b=WbY/jbIJ6yYPvANFXbrKSBXuXbgYTj0bEieebrXVcHtYhZNVxWd9M6RHIkb+iXMYE8
         6wtD19ZAPIsBO4ybwmPrJyxWRHfPidCqQ66AhShTVsJj5ht4Jo3aLOwLnlolRwB3ZUam
         mYIx+F9Ho5SVQHRrodEdn3PVxvHjFtQjcMzwZsr16I7BAoz4GHHyArVk+2+ExcMUkTiu
         JWWhCBdJhYFYka47ziY+yeg6j+9DAXdaVFSnFZonFPGT6FZxsVHbTBKltdWvnB6JtMQD
         Oge58baqPOBdiY6ho3j8gp788Vxbif4NdPE1EMxe0ZS1YcH4OfkfEvuMGBdFbH06Sfzr
         EXfQ==
X-Forwarded-Encrypted: i=1; AKwUvBw3KcsfPreJTERLfom0Bi4ekvDGpQQ1lb6lOsmwllOiYv33/CJrQ6HaE0HLQzRLbGtZOTot5yFAzQ==@kvack.org
X-Gm-Message-State: AFuF++nGtQ+HR/lKY7uctdZAolbaci4daiKwIIMWxuclkFm06CLTYT/1
	2JsNi/XCwj40UOZmZQjnbl0zhuWpdFKQr84HQzblzH/JuHrXoTrR9kjrhZ9cR9rcorBRyAOvj4H
	DZu1fSjaIoX/i+ibgvWHAwYloPmbwDOY2nUJnzE9gu+92df0G
X-Gm-Gg: AYBFou3ZqIpVleAd32cF2b5aQGIQo8wKKKVYBVjOAIuS3iDHW3PeASNttbC8RtZnmnq
	gvkfBnW06SDJrDHOlQrP17DPU7rsCENnOTH1cQwGtXowjS7xqHJipglTvIMBKoOiCMK6t+j+W37
	xNBM4h84xEeKuz/toqwauZPcfUZy/vPqGmNlLxHWL/BlvfTuTlcpV60/pLK6o9qDqsXR36keD9T
	vz/d9heRFq0Ea8Kt4nFkwrf37SAEEUa9+EXU9UghRMWXLiCJ+JEDfXg61S3vNtaeumrpw/d654z
	NT/d+ZqchuIBHIF9asGu8cXCpUFnRbVxfniTR8njTp3nEX8ycmJbTx1qbvDlPVgy18ULt90QCvz
	lHpnQMQfMbyylrVL44OQkGUiYBu8fmz6eMuV9duwGGIK3mYPaDmOv3Q==
X-Received: by 2002:ad4:5d6f:0:b0:90e:95ad:ba56 with SMTP id 6a1803df08f44-90ebaff078fmr101878166d6.9.1788377306338;
        Wed, 02 Sep 2026 12:28:26 -0700 (PDT)
X-Received: by 2002:ad4:5d6f:0:b0:90e:95ad:ba56 with SMTP id 6a1803df08f44-90ebaff078fmr101877186d6.9.1788377305632;
        Wed, 02 Sep 2026 12:28:25 -0700 (PDT)
Received: from [127.0.1.1] (nat-128-59-178-193.net.columbia.edu. [128.59.178.193])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-90e9eec85a0sm25420936d6.29.2026.09.02.12.28.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Sep 2026 12:28:25 -0700 (PDT)
From: Tal Zussman <tz2294@columbia.edu>
Date: Wed, 02 Sep 2026 15:27:52 -0400
Subject: [PATCH 06/11] mm: page_counter: constify page_counter_read() and
 page_counter_margin()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260902-folio_memcg-const-v1-6-e2c1da22246d@columbia.edu>
References: <20260902-folio_memcg-const-v1-0-e2c1da22246d@columbia.edu>
In-Reply-To: <20260902-folio_memcg-const-v1-0-e2c1da22246d@columbia.edu>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1788377294; l=1723;
 i=tz2294@columbia.edu; s=20250528; h=from:subject:message-id;
 bh=ilFeF7WzmkT3DE3smE1F3wtCBJfDaUSUcaDgXIyabqI=;
 b=7SvjOSnQHJqga+RWSYxTfjhpAi2s6De4EDJuTDdt12VyGEw9fCStCgXHcbh3kEzsD2y3neQth
 Ez75ezd5GfbCGX281htE3Y9/bLU4GHSZi9xp5qDT8cGrFVNQSwXUwV0
X-Developer-Key: i=tz2294@columbia.edu; a=ed25519;
 pk=BIj5KdACscEOyAC0oIkeZqLB3L94fzBnDccEooxeM5Y=
X-Proofpoint-GUID: QP83LUbaL9gZwHYpzPVm8rOvCOQJjOfg
X-Authority-Analysis: v=2.4 cv=PqejqQM3 c=1 sm=1 tr=0 ts=6a9878db cx=c_pps
 a=7E5Bxpl4vBhpaufnMqZlrw==:117 a=XwBYxoxBwSosfWEfMcqm5A==:17
 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10 a=x7bEGLp0ZPQA:10 a=A0y_DWxS2BwA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Da8U98TiO7q1upZEImrf:22 a=HpS3TJQ9O3Ob1ozEcmik:22
 a=qClW_BUTj_2nsftnHKoA:9 a=QEXdDO2ut3YA:10 a=pJ04lnu7RYOZP9TFuWaZ:22
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTAyMDE3MiBTYWx0ZWRfX9/rOop3fhVaZ
 LZs7zDLlu1Xt0XpqIOsA0Mj433P6b3IBiv3QfS3XvD6WRncHNfQxU9Gl+Pyr828zHQm4IFsOaFR
 vc598IGMoiknWGS5QfOBcWQj9oeu6UKPR/5FRXmwl8vmjeIZBapK
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTAyMDE3MiBTYWx0ZWRfXw1smSa3oFj+Y
 Afz7NDWmMQpsdcGRToJidh0TAyA2Ck+noWtYwp3JiOPCFZ9VhUl9NgfAMLR0gCfgFzU26CrYvAZ
 gcz2r7+vbuOD9d7RkZgFL0WZtznl7Qxw8UTCazvpe3Ec8v72KEQq3wXu79YsJ5va6ykygBaHeP+
 mfdDFdQNDYi+59pCVI9Xk3nV9p+11pOL/SyG9H42f1++ZczvmFSI5IxltPfhsRom0mW8pi4NWxk
 iRGk2gr7sA792ARqzuDpydZe/al7sdTUN0c/M+8CWGKxCgIVJUVUbeekBqXJFq3MzkrHigDs9Ig
 R89Xm4A96WmwT5c48EaDFQF8zR3eeZwZDW/vCPxhYPkyY/7JUa96+5709JGB0BQjPV/N3Zp09CI
 FYqCfPA6qwkCfe7HKjNSK8uPyvF03nAAm9LbhpPvvssY9GZTILhdMKeYwx4V3I7X/tIUxEgyPP5
 Fsfg0RKChXcNveKpwQg==
X-Proofpoint-ORIG-GUID: QP83LUbaL9gZwHYpzPVm8rOvCOQJjOfg
X-Proofpoint-Virus-Version: vendor=nai engine=6900 definitions=11894
 signatures=596817
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 adultscore=0 impostorscore=10 priorityscore=1501 malwarescore=0
 lowpriorityscore=10 bulkscore=10 suspectscore=0 spamscore=0 clxscore=1015
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2609020172
X-Stat-Signature: c8kth4th5kgfqr9btozmsbnqcmdjm7xf
X-Rspamd-Queue-Id: 29BF7100003
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1788377307-95910
X-HE-Meta: U2FsdGVkX1+ijc1SAeBESTE1LvZUplTK2UJ6fCbOHMFp2fyXpPWYg6gz3pTPGzOpcnF34fQLJ12AfTCWp9e9fHvm4CJjmErzoAFNDmtUaLhfqklopPoeVbevSlunS5qBWUZOk9hDJ7NnyuM1vC9WDxFlx9/ZtA7UcGYxZPeP5LENQPzPAy7nLQTZfvIItNiCNMseaBf/r88gARrM/le822D8hPNitsgU3f9+BcInvfXWsQ54IJvjQDDILstVauVMdFB2dptWJzD0EW9H5+ZoeecUDNePpNQiLLtYC5HAsLD7eCn9w0glnZBcxUMvxnfnO7nNzGZOz2bSLGjz9K00FN9ullPdgOHM8KYaDazrZdiHmRQ7/Np/r5LJbNRGbQfzTt2ojlrOUsuAjYYs8Lt6Ga6qWEztiHQQoAcdiSyM7qsHGHJkG3SNoRyBxfyEzlQjN6J9xBcYr+EttSU43VxS4gFzQgxjWE/1eXBAnC+FfHKoBJTyYLxKQKhdDLufW25n3OpAnZdUYW9+RvZj9neDCIQONfMr8hqQmFMuzo4NIE81H3q2CtZ34GOa5EbhE9KrmbyElFHpTy/OMu8mJTsVUTudMx/dJWPINvuDMqUpAQvxINB9Bu2HuhrXFnuSQ32iA302fGyB5N2YVPml8YC9EC3j0ez4CShuvj3FThOEwgNFiXU0+/7w0OXPHnUufUIXDhZNLhUG5q3a8E/M7HANKe77kIfFsn7ms/meRfa0JKGFPOZFMFDc6Cf4Fhnfb8VFoviWdtjdKt+tAA62e4CEowsoJysx5ms7of9yVo6kl9NImaM3OKSiOxVGxE3gLFNoF3Z48zyi0b3+YMGPCgSHcVwiIWtQZLbjt1Xjap1kg4GbOdwm1iCEBDk77yoMklFymyE0hXAGpk9qjFgKKfU3P24SsC7tDGFbXtAF36pUCCNKHUVCQf3ncl1oNVdvRRA38IIKQdjQuMZmrDufLO2
 LBZypvAc
 /U0C3OURmYJvi5TWL4jk5g4Gm9Xcl0FYgS7qp/+eqZR7V2TBJpAInz6nDfSj/lBgB7K6yANTpq3P8IwJFdzxEzhTi9MmKfn0pM/uqClkUPqKfm3oX6+lQxdszdUpKG/lr+4197LmORKOyafF/bEjtcD+6aymo/dkuvyLh8+25iCsVioFlaKMbBhBMSQwNuS/Y9/LgBFEVJ6qIW09x2PksGUzowqMob1CB8ZeUMiwTxG5zbsuUCHJ3zrbMn1Nc3r4BP+YnMqvxCGzEpKmTDK0POzvJwsfQm8/L6sCJkjnZcwDasv0P7pLT5h+CRb2O/51iDl6IL7RZgGLa/HYtPLomSJoPMWFCfmSPN7CMEKxLGo6Y3fCmJQaF31iPpKYJNXrqzKxlKoumjZfhde2JJxm5lSNzjSRuqELWtCvUwCN1uTJF6Jk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Both only read the counter. Constify them so that users can read
counters from const memcgs.

Signed-off-by: Tal Zussman <tz2294@columbia.edu>
---
 include/linux/page_counter.h | 4 ++--
 mm/page_counter.c            | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/include/linux/page_counter.h b/include/linux/page_counter.h
index 07b7cb12249c..2baf7a2b29b2 100644
--- a/include/linux/page_counter.h
+++ b/include/linux/page_counter.h
@@ -63,12 +63,12 @@ static inline void page_counter_init(struct page_counter *counter,
 	counter->track_failcnt = false;
 }
 
-static inline unsigned long page_counter_read(struct page_counter *counter)
+static inline unsigned long page_counter_read(const struct page_counter *counter)
 {
 	return atomic_long_read(&counter->usage);
 }
 
-long page_counter_margin(struct page_counter *counter);
+long page_counter_margin(const struct page_counter *counter);
 void page_counter_cancel(struct page_counter *counter, unsigned long nr_pages);
 void page_counter_charge(struct page_counter *counter, unsigned long nr_pages);
 bool page_counter_try_charge(struct page_counter *counter,
diff --git a/mm/page_counter.c b/mm/page_counter.c
index 450543f4b318..8c6f3b45136b 100644
--- a/mm/page_counter.c
+++ b/mm/page_counter.c
@@ -53,7 +53,7 @@ static void propagate_protected_usage(struct page_counter *c,
  * Return: The minimum value of max minus usage across @counter and all of
  * its ancestors. The value may be negative during a concurrent charge.
  */
-long page_counter_margin(struct page_counter *counter)
+long page_counter_margin(const struct page_counter *counter)
 {
 	long margin = PAGE_COUNTER_MAX;
 

-- 
2.39.5



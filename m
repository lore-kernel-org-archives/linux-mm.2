Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5A186C61DD6
	for <linux-mm@archiver.kernel.org>; Wed,  2 Sep 2026 19:28:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F19006B009E; Wed,  2 Sep 2026 15:28:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EC97B6B00A2; Wed,  2 Sep 2026 15:28:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D6C796B00A3; Wed,  2 Sep 2026 15:28:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A0E846B009E
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 15:28:28 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 3802D140366
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 19:28:28 +0000 (UTC)
X-FDA: 85169808696.24.32B707A
Received: from mx0a-00364e01.pphosted.com (mx0a-00364e01.pphosted.com [148.163.135.74])
	by imf27.hostedemail.com (Postfix) with ESMTP id 9D1914000C
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 19:28:25 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=c95Mf6l6;
	dkim=pass header.d=columbia.edu header.s=lionmail header.b=020dcT7Y;
	spf=pass (imf27.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.135.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu;
	dmarc=pass (policy=none) header.from=columbia.edu
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788377305;
	b=yjz/Uzfk4CH3rP3vXEKYgq8sPcW7qsKQr7qwFTKFGjvr+fMZv8HobYIs+/S9LKt08DdWss
	HeeWd4udFMYR2zsu0sM6ljYj8gJWrQgvy9H5Qx9bpwFGSnUiPtdMn9U0hZrh93RWrV1PqP
	5dFJ50WoQDqUtBajYZBNdEWH/RjyS+k=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=c95Mf6l6;
	dkim=pass header.d=columbia.edu header.s=lionmail header.b=020dcT7Y;
	spf=pass (imf27.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.135.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu;
	dmarc=pass (policy=none) header.from=columbia.edu
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788377305;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0z2sUYS3bRxKw8oYeBvz7KheVev/gzBZgUkJzUWo5SA=;
	b=bm62jDBcIDUvOBFny2wlMENN8/OYn7nUUPcIcJfYVqqXld8Qs3z0OHCLZhs1cXY0JL7OSR
	+KEetO+aZbMjhsC7s6Hd8U9L3r+XUpbwia8Zz+bxlEx5uUaREu5PcFU7igQBrWbnr+NMzV
	hqw2n1PsuBsxDTCIlLkBRWPkabiEa9g=
Received: from pps.filterd (m0167070.ppops.net [127.0.0.1])
	by mx0a-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 682Ikpbc519587
	for <linux-mm@kvack.org>; Wed, 2 Sep 2026 15:28:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pps01; bh=0z2s
	UYS3bRxKw8oYeBvz7KheVev/gzBZgUkJzUWo5SA=; b=c95Mf6l6qAjpqtYgVvw0
	gB0qdUg83m/qkdW61GmXQEKNeQpPr5tfuu7G25qCm8oAGIqpxcFBFovovJhNIt+Q
	sm4UKt7Ey+OMpB8APfxXC5fCSq4aOLKOl4Tm4r6JKh7TRr2xinhsv0aok5KGWE2W
	H911hIv2F5wUhSL1jLZfOF2A7Vz0oq6rcTB3xHGoWinYr8UpiAZfEn3vckcwASe6
	u6Z4ViX5FrPkMp026WKzY5kjeSSObrb8mjr2rd2UiJVe097k7wL4l32DePxZdJlv
	bYfd9AHezGTPLcZvvkY4PHZesmDxaMQkB2H8AA1X5DUtWVpBHZNJODUq1UQt6Ifz
	3g==
Received: from mail-qv1-f72.google.com (mail-qv1-f72.google.com [209.85.219.72])
	by mx0a-00364e01.pphosted.com (PPS) with ESMTPS id 4gescggbgc-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Wed, 02 Sep 2026 15:28:24 -0400 (EDT)
Received: by mail-qv1-f72.google.com with SMTP id 6a1803df08f44-90e80ce3597so28706536d6.1
        for <linux-mm@kvack.org>; Wed, 02 Sep 2026 12:28:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=columbia.edu; s=lionmail; t=1788377302; x=1788982102; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=0z2sUYS3bRxKw8oYeBvz7KheVev/gzBZgUkJzUWo5SA=;
        b=020dcT7YNklspqci/EmhQ47KNsUnw2lvc4p4AACgJzpVkVnjP3lJoBoWCjqiK9Hlr8
         lTO2HX2C3Um4uI/OYWWEieM+YiX+DyOjmogS4+t4fzoEOAxCy8Lzx+CQ+/4lWrSgvh/s
         wv/OBKS/9zTEQFiH5OEVg13MdkiUxBr1L/p33uvMiGpwqj4/9F0hSJd9heP7HpfRCrbt
         RbyJbG+KkGv+uU+Yx4F9+zodEwzYTe6WgdiSuuL+l4quEAs3tnWiSJ5bUP9IhLiZ+Cfu
         NRdQmBVVq66AfWC8dLPrErJN8n3sgfomB/D2nVxwTC23wuV3chQgI+TuIlIqC7Bgmvpy
         sWYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788377302; x=1788982102;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=0z2sUYS3bRxKw8oYeBvz7KheVev/gzBZgUkJzUWo5SA=;
        b=nDyASqOk2XogmAUdC520DUv6M6ISq9Ch6QqjYk+KpB1etDazlznBurxL5xVOk96/v0
         XRwEeod0a9FGkk9yJ/LDbl9x+cOv6PX53EWbbbI6XoHavc5I9SzeeJqJqwulltFuNRc5
         i9Li4240sUzH+vLYzX/wsBm6JPm0AbdM2FrPZtQYKsP5vtJqmo1ifq0LyCAr8Pv0hfp9
         Ieltmv1oUcRsPskZ9figsdbut0Lg2zo+GT7qFfVqP4b4sXE/ozLhpXKxB/XBblXFvfEr
         IuHsPqKQTcY0Kkxpj77nmWcxtQ8Cebebe+70Nk2Tu2xx4CjUXCQxG2f6wTK5qV+7v7Yu
         0R4Q==
X-Forwarded-Encrypted: i=1; AKwUvBw2ZsJvZsB8fcE7eNOmtMCj9wDFXOJ/g0ByADyeiRce9JWR6cpa3XcUHqJPoEIzy052pxi/utKdig==@kvack.org
X-Gm-Message-State: AFuF++kF37iYYBZzNIZIS/4GpeDDWRU8u7IQN8OucoekKzWfkeYA9Uea
	Hv5F/VBwMgqBLFcJUfSacGx2dvgOCS8o6x1cbAamV+PEPBXL47kgjQory6elg7D6oQH4ZQ2107H
	cgyeSeWhj3QY/QHLxhQ/9DRFh2XG+2mhvBpcxpASJ6Lk0tFTC
X-Gm-Gg: AYBFou2A66d4SJNzqNRNWbrisYNmcSa8HJ+rP/bO+fgFKEyR7q2E00cumx0pQdM8H2X
	3dgDpCkT7e8IqYzCL0f29LymOCuaLj/CxrUaIHgIyQ/JtfPqBDIOGRVgFVjq+CgVceRL11Dv3PI
	PFKUYvENvMJRpHquZ0mqvHQts/GVzrl0wFNr+gct8KQf+Mwc61Cy2tjSm120rSqZzyGXdlWrHed
	XLYnkencQlT+EzH33yTHZIq7ymela3T2AqZBzc0kZ+zap+twh5+peNq61ItF5iyA8YL8/AVN0N9
	SEkargx/RBI/6k759GZhSGD8B5Qstq1oH8IZFW2VEUPm7dZ3wUTVpMfIhm3oGKpYz3ZNaMTKMTW
	v2K+RNFPRXnMbOcpQf4tnxYM2YU951SByyDv6KfFUWMgA2RpE+v5mHw==
X-Received: by 2002:a05:6214:459a:b0:90e:8495:b33c with SMTP id 6a1803df08f44-90e9f20406amr120753106d6.2.1788377302311;
        Wed, 02 Sep 2026 12:28:22 -0700 (PDT)
X-Received: by 2002:a05:6214:459a:b0:90e:8495:b33c with SMTP id 6a1803df08f44-90e9f20406amr120752136d6.2.1788377301664;
        Wed, 02 Sep 2026 12:28:21 -0700 (PDT)
Received: from [127.0.1.1] (nat-128-59-178-193.net.columbia.edu. [128.59.178.193])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-90e9eec85a0sm25420936d6.29.2026.09.02.12.28.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Sep 2026 12:28:21 -0700 (PDT)
From: Tal Zussman <tz2294@columbia.edu>
Date: Wed, 02 Sep 2026 15:27:49 -0400
Subject: [PATCH 03/11] mm: memcontrol: constify the lruvec helpers
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260902-folio_memcg-const-v1-3-e2c1da22246d@columbia.edu>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1788377294; l=7434;
 i=tz2294@columbia.edu; s=20250528; h=from:subject:message-id;
 bh=MqTE7K5pNhCo4/31s6/6kWidCPt4QuecBwAxB925n3w=;
 b=c9uAhsFeBBBtvIgXq+FIchS+b/wpJeP+BhGmEX5xOHyy+GDucmCaa6L3hZ4mszhUX1bhfyZIq
 dWF1STmz8XwBV6qBCZ9FPOwCSAY/jrUYsVZvW+W3lykd5JWWXmv2oje
X-Developer-Key: i=tz2294@columbia.edu; a=ed25519;
 pk=BIj5KdACscEOyAC0oIkeZqLB3L94fzBnDccEooxeM5Y=
X-Proofpoint-GUID: WtHxX-QTBE620qja3ijyio4gGiLpctUm
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTAyMDE3MiBTYWx0ZWRfX2ieZwig90+5e
 Iz7vktsCTIKMNN/jOzQ0qeOUwCyjZLjvE5OJdyr7ZmT/6WBHyUC9pSVVhrA0Arem9qe2PbcFGJ/
 SYudEyP2at1mj+9WIelAQTk6mI74PHm/yi1Mu4fQb7mRPVUrzR9vP23ql+LnQ306sZYZD3zsvUl
 xJD2iQKcJ7Hm0GBzycOfARLMCQjuOW42T3ue0hZZrrEvrfZaIywVkM0YWlGkYEu6K2L94/8fqfP
 9BBx+4HxuzgTsA0aTmq+b06YsHOm+jsadr6FTLUYG+SuYQ+tGNt6o8O+s8n232S7xzqKOV0odXe
 yqpFsgxNz4nPnp9mKDeUtD3PfkReouh/J2cesBjgRd+TDYuGMyAWbS9oNBIP4rvXY1jQrgdUBfI
 YhnW1pQTgPLK5Hq/vChrHUgCCq3gHSd2BiW9zUPJeLWDEEZTsmkk3OJBSIkAwwx9UHLPLaMdRab
 77JLSmIqX9OWO9Nw3/g==
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTAyMDE3MiBTYWx0ZWRfXyJBAQY+Q6nSC
 8g1PfQLbko49NHuOJ4ZUfflXGaKPvtEcnINMvMaw71OzJtYpjr/x6vI87AXgzkvNONQMU99esls
 8PZ8fx+FDCfoBfp0Xw4xx2TE5yAxWDKOyuecbnVbebIsdOXjVj8w
X-Proofpoint-ORIG-GUID: WtHxX-QTBE620qja3ijyio4gGiLpctUm
X-Authority-Analysis: v=2.4 cv=VbnH+lp9 c=1 sm=1 tr=0 ts=6a9878d8 cx=c_pps
 a=7E5Bxpl4vBhpaufnMqZlrw==:117 a=XwBYxoxBwSosfWEfMcqm5A==:17
 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10 a=x7bEGLp0ZPQA:10 a=A0y_DWxS2BwA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Da8U98TiO7q1upZEImrf:22 a=svvvyxlR1OQQkelhaPoB:22
 a=OahJJIsL82qy_ALkPHgA:9 a=QEXdDO2ut3YA:10 a=pJ04lnu7RYOZP9TFuWaZ:22
X-Proofpoint-Virus-Version: vendor=nai engine=6900 definitions=11894
 signatures=596817
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 adultscore=0 impostorscore=10 bulkscore=10 suspectscore=0 lowpriorityscore=10
 spamscore=0 malwarescore=0 phishscore=0 clxscore=1015 priorityscore=1501
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2609020172
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 9D1914000C
X-Stat-Signature: 6jmduiewkfhttujxqmocq5j1gby9ndbs
X-Rspam-User: 
X-HE-Tag: 1788377305-360363
X-HE-Meta: U2FsdGVkX1+Y++LTY5B2BcfQhP5FXNVNaD9KlRw2YsWNqEPA+Q0czDuiMNF5kCFu1LHmsOay4+YF+csZ87qIDf+OKRc2TJQksvCuMEj1FToTVqqNaaapbZGOY0xSZQcbgIdxc9s2f31mKYSkpJkDwrrpS4iolFVv2aBblb3I6IIEIHqeTNtX+tAqRGi5sqPl/aXkbTMVZAfN6GSH5+2hG31AsvrT8E3ygIpDVxj97i2NHQhc5jXfQeMPedrzqOkBBLDuUAQu8+rBC/8+8ve5EZkd0w0CFecItvszDIJHf8zMTXvO/clCwTQnGU2JfAfWIIh4Ubqu/Z0YPlxOSwxRsv56nzFHcWQlBbwoypV/zANOvt/AdtGIozJ/oGg59360c0gWl+Ray+l6gNsBjmE4HjkzlMTCUKj/PFDiYble2YvAxzybN8hrq+Mx3bzsKuzco/3FXlbU+/4CdgzCE2ouvo8X2UWgf8Na1ORb06SA6Zk0xef0gEZBS7yF3tB1RuJ+jGK3VGR2+jBX1u6QttxWzTjaoxhmlYW9VMPEWfRyOY6GoTT/QlTsPARF95BlsvsAwRwjEoThMuRXZRjPAPaTy4QKbu9lrN+nGO1L+PkHtI+kCCSvFJt4uR2KXfmOEcWk2HJ6SAW3IT+IJV2CxlWBAsW4WTJQhyGHs27pOmOc1tc2ASnSdJLiN1affI8OeEAy17yTK7DUO4Rj5eHmEL40ET3At1P+MCEJhTl3PZ/krrJ0bGQTG0/IvOR9lZbMw59ITuw5VMq62sTAWkOwYnqH0CqvCuWGvWNQw5JDh4UIbgB3naAjBD3DubghSn0KyiTxin9slXo/8irllS1uqJsmlUU5saR0VxgSeqjSp1hRCBQXt4RGBEUA2zqObcJCMbUGhko8eWNt8pT4yLDA5ar+uuleSOXVkQpptdP11CDZjgD4bD4mQLPJUwbld7FMZdrB2wlXayaekSrF7zp8r62
 F1kc6df6
 g1qz7ZS/ezy76stcWhoy3J7gwfpo3aNhwVgsL5YsAnpLfjt32IiQY3qSciv0w5r9Ztpm7KeIe+xe1Z2hoX3JNyc/7Q5WQdUJXg5l4fZpyv44NkxZOT8cIMpIeCcwOkyDR2Xs5CP7L6XkEUKoZTjoa63VzAf2NwTXt6yso/LKgio+HOq7BoqIpamN0Lc1e+nF4bv0qr12pDajHuqrlEgGDYnTjqBUL3hTHWIMw63GAzO47C//x6xGZnocrCqexWmIbHaCqqiICZWsLLw18SqIJ5zNMYBDdXIsGiygwwbPN32o3y4DJKosR5t/fwgn/Sbp1WsNceqTiWIu/UmKFlxjuJ3ljVvkhZk5Sv4EgsJsOkLwvEwWVGNdQv3mvYJWLYiJQeysp
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The lruvec lookup helpers only read from the memcg, folio, or lruvec
they are given. Constify them, along with lruvec_pgdat().

Signed-off-by: Tal Zussman <tz2294@columbia.edu>
---
 include/linux/memcontrol.h | 34 +++++++++++++++++-----------------
 include/linux/mmzone.h     |  2 +-
 mm/memcontrol.c            |  6 +++---
 3 files changed, 21 insertions(+), 21 deletions(-)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index 2b3b62e84ab2..4b7cc97e45b2 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -688,7 +688,7 @@ void mem_cgroup_migrate(struct folio *old, struct folio *new);
  * @pgdat combination. This can be the node lruvec, if the memory
  * controller is disabled.
  */
-static inline struct lruvec *mem_cgroup_lruvec(struct mem_cgroup *memcg,
+static inline struct lruvec *mem_cgroup_lruvec(const struct mem_cgroup *memcg,
 					       struct pglist_data *pgdat)
 {
 	struct mem_cgroup_per_node *mz;
@@ -729,7 +729,7 @@ static inline struct lruvec *mem_cgroup_lruvec(struct mem_cgroup *memcg,
  * their binding is stable if the returned lruvec matches the one the caller has
  * locked. Useful for lock batching.
  */
-static inline struct lruvec *folio_lruvec(struct folio *folio)
+static inline struct lruvec *folio_lruvec(const struct folio *folio)
 {
 	struct mem_cgroup *memcg = folio_memcg(folio);
 
@@ -745,9 +745,9 @@ struct mem_cgroup *get_mem_cgroup_from_current(void);
 
 struct mem_cgroup *get_mem_cgroup_from_folio(const struct folio *folio);
 
-struct lruvec *folio_lruvec_lock(struct folio *folio);
-struct lruvec *folio_lruvec_lock_irq(struct folio *folio);
-struct lruvec *folio_lruvec_lock_irqsave(struct folio *folio,
+struct lruvec *folio_lruvec_lock(const struct folio *folio);
+struct lruvec *folio_lruvec_lock_irq(const struct folio *folio);
+struct lruvec *folio_lruvec_lock_irqsave(const struct folio *folio,
 						unsigned long *flags);
 
 static inline
@@ -827,7 +827,7 @@ static inline struct mem_cgroup *mem_cgroup_from_seq(struct seq_file *m)
 	return mem_cgroup_from_css(seq_css(m));
 }
 
-static inline struct mem_cgroup *lruvec_memcg(struct lruvec *lruvec)
+static inline struct mem_cgroup *lruvec_memcg(const struct lruvec *lruvec)
 {
 	struct mem_cgroup_per_node *mz;
 
@@ -885,7 +885,7 @@ void mem_cgroup_update_lru_size(struct lruvec *lruvec, enum lru_list lru,
 		int zid, long nr_pages);
 
 static inline
-unsigned long mem_cgroup_get_zone_lru_size(struct lruvec *lruvec,
+unsigned long mem_cgroup_get_zone_lru_size(const struct lruvec *lruvec,
 		enum lru_list lru, int zone_idx)
 {
 	struct mem_cgroup_per_node *mz;
@@ -1175,13 +1175,13 @@ static inline void mem_cgroup_migrate(struct folio *old, struct folio *new)
 {
 }
 
-static inline struct lruvec *mem_cgroup_lruvec(struct mem_cgroup *memcg,
+static inline struct lruvec *mem_cgroup_lruvec(const struct mem_cgroup *memcg,
 					       struct pglist_data *pgdat)
 {
 	return &pgdat->__lruvec;
 }
 
-static inline struct lruvec *folio_lruvec(struct folio *folio)
+static inline struct lruvec *folio_lruvec(const struct folio *folio)
 {
 	struct pglist_data *pgdat = folio_pgdat(folio);
 	return &pgdat->__lruvec;
@@ -1241,7 +1241,7 @@ static inline void mem_cgroup_put(struct mem_cgroup *memcg)
 {
 }
 
-static inline struct lruvec *folio_lruvec_lock(struct folio *folio)
+static inline struct lruvec *folio_lruvec_lock(const struct folio *folio)
 {
 	struct pglist_data *pgdat = folio_pgdat(folio);
 
@@ -1250,7 +1250,7 @@ static inline struct lruvec *folio_lruvec_lock(struct folio *folio)
 	return &pgdat->__lruvec;
 }
 
-static inline struct lruvec *folio_lruvec_lock_irq(struct folio *folio)
+static inline struct lruvec *folio_lruvec_lock_irq(const struct folio *folio)
 {
 	struct pglist_data *pgdat = folio_pgdat(folio);
 
@@ -1259,7 +1259,7 @@ static inline struct lruvec *folio_lruvec_lock_irq(struct folio *folio)
 	return &pgdat->__lruvec;
 }
 
-static inline struct lruvec *folio_lruvec_lock_irqsave(struct folio *folio,
+static inline struct lruvec *folio_lruvec_lock_irqsave(const struct folio *folio,
 		unsigned long *flagsp)
 {
 	struct pglist_data *pgdat = folio_pgdat(folio);
@@ -1314,7 +1314,7 @@ static inline struct mem_cgroup *mem_cgroup_from_seq(struct seq_file *m)
 	return NULL;
 }
 
-static inline struct mem_cgroup *lruvec_memcg(struct lruvec *lruvec)
+static inline struct mem_cgroup *lruvec_memcg(const struct lruvec *lruvec)
 {
 	return NULL;
 }
@@ -1325,7 +1325,7 @@ static inline bool mem_cgroup_online(struct mem_cgroup *memcg)
 }
 
 static inline
-unsigned long mem_cgroup_get_zone_lru_size(struct lruvec *lruvec,
+unsigned long mem_cgroup_get_zone_lru_size(const struct lruvec *lruvec,
 		enum lru_list lru, int zone_idx)
 {
 	return 0;
@@ -1465,7 +1465,7 @@ static inline void mem_cgroup_flush_workqueue(void) { }
 static inline int mem_cgroup_init(void) { return 0; }
 #endif /* CONFIG_MEMCG */
 
-static inline struct lruvec *parent_lruvec(struct lruvec *lruvec)
+static inline struct lruvec *parent_lruvec(const struct lruvec *lruvec)
 {
 	struct mem_cgroup *memcg;
 
@@ -1528,8 +1528,8 @@ static inline void lruvec_unlock_irqrestore(struct lruvec *lruvec, unsigned long
 }
 
 /* Test requires a stable folio->memcg binding, see folio_memcg() */
-static inline bool folio_matches_lruvec(struct folio *folio,
-		struct lruvec *lruvec)
+static inline bool folio_matches_lruvec(const struct folio *folio,
+		const struct lruvec *lruvec)
 {
 	return lruvec_pgdat(lruvec) == folio_pgdat(folio) &&
 	       lruvec_memcg(lruvec) == folio_memcg(folio);
diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
index 84e237f2c17d..8e1e3a50757a 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -1657,7 +1657,7 @@ extern void init_currently_empty_zone(struct zone *zone, unsigned long start_pfn
 
 extern void lruvec_init(struct lruvec *lruvec);
 
-static inline struct pglist_data *lruvec_pgdat(struct lruvec *lruvec)
+static inline struct pglist_data *lruvec_pgdat(const struct lruvec *lruvec)
 {
 #ifdef CONFIG_MEMCG
 	return lruvec->pgdat;
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index b9bf655cdd2d..e2845f761e37 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -1441,7 +1441,7 @@ void mem_cgroup_scan_tasks(struct mem_cgroup *memcg,
  *
  * Return: The lruvec this folio is on with its lock held and rcu read lock held.
  */
-struct lruvec *folio_lruvec_lock(struct folio *folio)
+struct lruvec *folio_lruvec_lock(const struct folio *folio)
 {
 	struct lruvec *lruvec;
 
@@ -1469,7 +1469,7 @@ struct lruvec *folio_lruvec_lock(struct folio *folio)
  * Return: The lruvec this folio is on with its lock held and interrupts
  * disabled and rcu read lock held.
  */
-struct lruvec *folio_lruvec_lock_irq(struct folio *folio)
+struct lruvec *folio_lruvec_lock_irq(const struct folio *folio)
 {
 	struct lruvec *lruvec;
 
@@ -1498,7 +1498,7 @@ struct lruvec *folio_lruvec_lock_irq(struct folio *folio)
  * Return: The lruvec this folio is on with its lock held and interrupts
  * disabled and rcu read lock held.
  */
-struct lruvec *folio_lruvec_lock_irqsave(struct folio *folio,
+struct lruvec *folio_lruvec_lock_irqsave(const struct folio *folio,
 		unsigned long *flags)
 {
 	struct lruvec *lruvec;

-- 
2.39.5



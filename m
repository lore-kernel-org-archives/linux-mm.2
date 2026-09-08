Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 87EF8C79F99
	for <linux-mm@archiver.kernel.org>; Tue,  8 Sep 2026 15:58:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 43E9E6B00A4; Tue,  8 Sep 2026 11:57:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3ED9F6B00A5; Tue,  8 Sep 2026 11:57:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1A5046B00A6; Tue,  8 Sep 2026 11:57:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id CCB976B00A4
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 11:57:57 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 558771405A8
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 15:57:57 +0000 (UTC)
X-FDA: 85191050994.14.F447EC1
Received: from mx0a-00364e01.pphosted.com (mx0a-00364e01.pphosted.com [148.163.135.74])
	by imf02.hostedemail.com (Postfix) with ESMTP id C427280006
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 15:57:54 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=HWoN4fX9;
	dkim=pass header.d=columbia.edu header.s=lionmail header.b=zr7bdTgn;
	spf=pass (imf02.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.135.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu;
	dmarc=pass (policy=none) header.from=columbia.edu
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788883074;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Q9N4IW0Q0HkN9KT6h8CVRGegPfku8TwgZZjZ8yH7Mw8=;
	b=4GzkZyXCqlC8Zjm/O4eWA8SSuNlK95AR/WVHvAHe+2okl+kIhkK33iY8AbhBFIJU7f4EXR
	sbbtL529ZMLZ3pgq2QwZq4/z7o8jHIQZCd+d9+ZI2urCOoFPmPQvAjTuNRc9pD6JgCHu/n
	2BEdWX2bsQ4cnQweVXaD9gPul85khpk=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788883074;
	b=Lv567sYOFcRbS/4H8UpKtt+ghrsFmQk694/c/IXA/C0rFzjVRp/W47X5Ii/OV0uUCw0+jv
	GbMZKenKgoVnG5xAbfLwTMzvh1gvhGS+n/nhA3m0eK21km+iZOBm1Wps/OHoS31TBrkL+9
	TbYUhK4GT2sqx6EveqP2mxslGEBcdos=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=HWoN4fX9;
	dkim=pass header.d=columbia.edu header.s=lionmail header.b=zr7bdTgn;
	spf=pass (imf02.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.135.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu;
	dmarc=pass (policy=none) header.from=columbia.edu
Received: from pps.filterd (m0167069.ppops.net [127.0.0.1])
	by mx0a-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 688FbjgX426578
	for <linux-mm@kvack.org>; Tue, 8 Sep 2026 11:57:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pps01; bh=Q9N4
	IW0Q0HkN9KT6h8CVRGegPfku8TwgZZjZ8yH7Mw8=; b=HWoN4fX9O6PM4r7xxWZK
	B1LWKD4v1Hu5nou4SvaRMrpd6IZO7jqvWe2U+PVvmOrjbwS8ABb7hSkfsI7BhS0Y
	TuDA8AuxsSOfwWwQnYZCfipiIlEWKUEgpdMZzlWt+afPmD1nrMhVXJeqLiLrnNvL
	AbjOkKB9GLdmzqkpDBdNxUStkiMDje8SrS2i+2tLY9hnBi+7/qoAZIXUrHZMm1dV
	QUg3dxoRkTDKlgR1CHPtvh6jmHrZpXiQwXQzyvsnFi287sQAxd07X+9JSMSidai4
	8EcJTN56/hm9KzhA2xpbr/Aq7l5qlYd/Lre+ncP9+Gof0Ky0r2792JnjgxsBG37K
	TA==
Received: from mail-qt1-f200.google.com (mail-qt1-f200.google.com [209.85.160.200])
	by mx0a-00364e01.pphosted.com (PPS) with ESMTPS id 4gjmv7gf0r-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Tue, 08 Sep 2026 11:57:53 -0400 (EDT)
Received: by mail-qt1-f200.google.com with SMTP id d75a77b69052e-52dcf1bb6e9so91193871cf.1
        for <linux-mm@kvack.org>; Tue, 08 Sep 2026 08:57:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=columbia.edu; s=lionmail; t=1788883072; x=1789487872; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Q9N4IW0Q0HkN9KT6h8CVRGegPfku8TwgZZjZ8yH7Mw8=;
        b=zr7bdTgngDYVTKBHEchuCju/52WyxLBUUCLs5nVeUa7XFzEZF4Ga/MMcJBylmZzhPJ
         IGLXNAR+/TwX2cI6DVNpNtQtnI3WfC7FMeIfVBJJOdwSnJDPIQKfC8FeE0niLv6kRQMm
         XpBiV4DxTlW8CNT3PeRWbdNybmXu5PYxTU2KkYC2M3KauEwKlRh7eb6HD+1jvQE8WC57
         bHWJSaqIkFM0aZkv8PDu/+gG5gghPY4idWDO6NWLJPHK+uVU1FIjeqac72+irk4H0g1x
         0EOcUT5ANMWNCNAtwmXqDGgUtvrXsAzTtR32+PpcVE1XwuQTTySLi+3Lex9NJSDSQSot
         VGug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788883072; x=1789487872;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Q9N4IW0Q0HkN9KT6h8CVRGegPfku8TwgZZjZ8yH7Mw8=;
        b=qe/djpbrESigKA1chAZLHVm/AKMvkRnnEf8SXFkixF5dwJYpJlpVZ/DLdPDoK2YMgu
         iM/uUlG1+Sn5SljDjd6GSe37gIq0Gaia/JtEDR/QgzIoOkKOGXf2FP5CWSlsdkm9U1en
         lrvvR2XOzPj0of1+VwOMmexVi4j45V1KebwSEXdwA8s83atMVqd62Fx9r4+angePHTOj
         enzLQP3xV4yLS+ZbwKMk6lUZXCmhHZJImNb9HVXLPTBCaK0cAWJQnhOqZPiqRjQlBGyA
         Oau681SkCArqpGw8NYntX9EmLvYi8jZb8tgQyjofC0OSWUUIetRmNptZp+yas2mrLlIi
         QVtg==
X-Forwarded-Encrypted: i=1; AKwUvBxrwDpWYXVZOEUKMwRJ3r8bZGBGiIYeh6l0OB/DjxPJx7nYkdrRhXVI/5sbY9j4cVVoa2RKI18CJA==@kvack.org
X-Gm-Message-State: AFuF++n3awyxp4ha8coHa6iVXK/1nluwNRrzjELgOM/CKy6XLRe8zgmf
	jq4juw+uXdLV7u05m1Kp+0s8477UWrRoZpkh9MtLH+cEbee9IHRVAZ7uBG9wG+geN9WJJdCvnTQ
	O8S1A9mAv5Rfin3s8aL449q5v277Btpr6Pf6ftoC/vbw/Cjty
X-Gm-Gg: AYBFou14z0fHJUvKlk7UvWnvQ9zYXSozHEMUoSO0JRfq8kAl3Xvm2HT9A4EMlL6Uz9N
	MkaRIBYhDIMxwwm4SXpjLdOl2KssxEoOiRWUBDJ6tmICJlkRY3dP48bbbIuWom4Zix8tH2Olt6+
	T6EQxb7nMZOn/Wg29iXPo9h8BRo+2BfsNf1bb1J+dLR/frudjnCqk2PJV+VzNu3TzJB9+5BJXW7
	rZM3E/QwE5Yy3fWSEEyN1VC7rdWE3ip/OO4pMuj40shbNBrj5Xg20knm+M3mzLVL0itsTgyCXNt
	0buiNOjItoJXtcTnUwTRnookF9jpW0et8rorqfYCnTMnb/cv1YbP7s0++u5Vix1UbWHuVei54JC
	ycOzCbXdWutVa1WWS14a85EwgdJXRk9u4IdIQtFyC0av9COB+
X-Received: by 2002:a05:622a:1aa9:b0:52f:b372:2ef9 with SMTP id d75a77b69052e-530913411b4mr76747651cf.20.1788883072406;
        Tue, 08 Sep 2026 08:57:52 -0700 (PDT)
X-Received: by 2002:a05:622a:1aa9:b0:52f:b372:2ef9 with SMTP id d75a77b69052e-530913411b4mr76747031cf.20.1788883071826;
        Tue, 08 Sep 2026 08:57:51 -0700 (PDT)
Received: from [127.0.1.1] (nat-128-59-177-174.net.columbia.edu. [128.59.177.174])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-53093295584sm27830461cf.13.2026.09.08.08.57.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Sep 2026 08:57:51 -0700 (PDT)
From: Tal Zussman <tz2294@columbia.edu>
Date: Tue, 08 Sep 2026 11:57:42 -0400
Subject: [PATCH v2 06/11] mm: page_counter: constify page_counter_read()
 and page_counter_margin()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260908-folio_memcg-const-v2-6-811e9f443409@columbia.edu>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1788883062; l=1723;
 i=tz2294@columbia.edu; s=20250528; h=from:subject:message-id;
 bh=ilFeF7WzmkT3DE3smE1F3wtCBJfDaUSUcaDgXIyabqI=;
 b=qs/aOiqsuEwnuRCgRoj5FQu98XRLg2KKKEUPKSnBKV8A8y1YbwgcE1thOj8GxB+WCzIUk6eKx
 rHBTQ7yU7hMAMKRu4yHXq5htNrT3t0tXfWjfpvFQvUXQOrRY8cOdrEt
X-Developer-Key: i=tz2294@columbia.edu; a=ed25519;
 pk=BIj5KdACscEOyAC0oIkeZqLB3L94fzBnDccEooxeM5Y=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTA4MDE3MiBTYWx0ZWRfX/OOy59aaI5z0
 d0Qs1SecXMnp4tXwKigxdY+bR/wNW01ZVicbGErxsiROq663wZssahyTZ5+jbWxOfIjffRya2Gf
 WW0N87tMhje1Upj+y72QC3z56aC6OtN/hBqa2JgBtIbMcQZQBRHox+lq8XEA9oPDPuYlN7ZBDYE
 TokQqQAnBKZ7XnwFSJ3sK8he6UDkvBOCpSPgic0uKYKkFwunwdUhxByxELLhJfGDuslYCPvywnz
 lVt65ZYjRQiWGVzBYI9KC1qVORGwVIg+xz+uzhRxD9DBxXrbhYQjUCpOlXkJr13HUeuhGyO36KT
 zC59C9XyvMysDO9U+JoufWTDtncQO/VnEKlscXx8vh4Kzy100FPX+tDtIllkJXokUs4GEkoPU0+
 01Y1fbyB489bKSbC9GHZRk+5YRhL+dJislbIf2zvJOlgOOr5hHegfNeaeQrWljQlkp/ij1HtFO5
 nV4+tbITKsk21f0LavQ==
X-Proofpoint-ORIG-GUID: kM4pe--NmTZCNld1XlNjtDrrQdJm_hgF
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTA4MDE3MiBTYWx0ZWRfX1yFehFmqeWIh
 5V+y9VLO6pvTmhMp97+3yj0WkSkONy4cRHLVkpUUIyV1qxWzXi5cdbutYJTpPHBf5PYhXJeEbEv
 3oi0IYMd9AkV0d41LDdX/ikj7U2UngzwrS739+GZpO6kU+OPTWQP
X-Authority-Analysis: v=2.4 cv=fpnsol4f c=1 sm=1 tr=0 ts=6aa03081 cx=c_pps
 a=JbAStetqSzwMeJznSMzCyw==:117 a=HBUb3goEnnz3w2smY6d+Hw==:17
 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10 a=x7bEGLp0ZPQA:10 a=A0y_DWxS2BwA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Da8U98TiO7q1upZEImrf:22 a=JR4YdQiviy7OQf72WyZ1:22
 a=qClW_BUTj_2nsftnHKoA:9 a=QEXdDO2ut3YA:10 a=uxP6HrT_eTzRwkO_Te1X:22
X-Proofpoint-GUID: kM4pe--NmTZCNld1XlNjtDrrQdJm_hgF
X-Proofpoint-Virus-Version: vendor=nai engine=6900 definitions=11900
 signatures=596817
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 priorityscore=1501 phishscore=0 suspectscore=0
 lowpriorityscore=10 impostorscore=10 malwarescore=0 spamscore=0 adultscore=0
 bulkscore=10 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2606150000
 definitions=main-2609080172
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: C427280006
X-Stat-Signature: j18ixnrsfw3kecyzwtx5tg4mzn7ukeou
X-Rspam-User: 
X-HE-Tag: 1788883074-93586
X-HE-Meta: U2FsdGVkX19TI81XwyGnA0o+lB8Xj9mOfN6yBGt6dRRpozYesk7M7AgL2zT15B7Xef5NPCHjekEP4MCFqWEbLet6oN5DZS1gekGjwf05FknjwaXYrW00DnSOKRP7h9q5dRKsdqSk6GT+QT28J9WFQLpgrJg7+Tv5uox4kye7+LD8UHZBtWw/raqLuTYT68PwBtjwDTXSkD0kJExw2whJNrkx/mB9FHZtarNiYrR1IcecIqPixnX8FYRqD0dHczsa+oUbexWpgI14qig29xOmX+aWuj7rQOqz4yraQzCaqh/n21Ux6Pyn/t3BlU98SvQ7gniWeUfP9XS9yVLeolVTPfV7o7c6k5ndmGdlRJ5NVppdgAjuhfKnbegkds997Z1O5Gr1f2KBZa+UokLyWWdu1H44/oZTbqWLnReu6ReDBpCWfBgt+LyA6LUFstuKY1A5SjEkADrBU04jKPtWwDKqWDHROeZ8rTQM1JVw4VHrIwP1G2m2Wy3r9Lem/im9+aw+Ymqve5w4xE/SxT2n8gdA2WZoFY9XJ3w5CHax9CWtdQ7pOWsRbSB5jJO/EJVlAp8l+1iIQE/kOvBvvhJU2cdY+Z18e9BoWlTxK9yVcFNaVLhLfygKtw79apntsuZ6WVhSWverBaKcOkIBnsOayMVmR6mLm62ZoxSmQH0AGjFowd5PYjqipvSPs3VFxsF5wYqDoD4lzQPYuq4fyIgbn1K2AtRTljhhLbfNahQ/oegS8upzRLDmopiqWC5A2npuALP1HwnOmaF3wK0efwxsbpFe5jfGJWfFtZJiMlj26tPyvZhVtRMQeOwaD4+iLPq7ClqQ6u+Yd/py2XsxfRvgQvEN1PAQfsY87PwhjPhnCydBkACw0wt2QuiYpSro21ciIO9bpqZlpj9IRTI5rFI+H1y4OrHuhubcmIO6oOc3VlTuQ0RcPjiOhNPRI+anPwpxJ0w3yYSFlc75RcHI7XV4oEc
 XNjiZ/s7
 5B+NHSMo5Ma0VHWqzUnOHcwTAQetA3EmHLE9t3nQeaIoh5lls90eUbTwZ+Bo/Q7C9Ik/URGHLz/1t4IyrKiB2YPUQZAsqJrfe7Am49jFwDH0Og9y4rzSeldfvDGegC5iymgVuCAYgXtYjHfeN02ncmiIc95b/r+HyLnurQGJWeRwkmQBcYpDxayIuG+BRyZxQ1U3vbir0FzjECgul3l2rPNnHYMaOgclPsn+/r76+kBcu6Dvrx0r9GM5DSpJdD+NBCywvpdgLJbtOHyyi1ms+WvoaUupgMYqghvjpf9D9RfqCgyg3i1U+FXq54dHa5UpyvLjYONYBV+NIVgMWK4qC37Oec3+gasnLUJ4wZYEJjFwqHoZZkanBmekLLatdl5xn9D9k4LLPY5riz2l6wuRT4Osw+DVMs2/X/xZEkJDWq01J3CM=
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



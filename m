Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D75F6C61DD6
	for <linux-mm@archiver.kernel.org>; Wed,  2 Sep 2026 19:29:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E564C6B00B3; Wed,  2 Sep 2026 15:28:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DB9AF6B00B6; Wed,  2 Sep 2026 15:28:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C5A206B00B7; Wed,  2 Sep 2026 15:28:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 8DC746B00B3
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 15:28:42 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id F41D4120375
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 19:28:41 +0000 (UTC)
X-FDA: 85169809242.14.9124625
Received: from mx0b-00364e01.pphosted.com (mx0b-00364e01.pphosted.com [148.163.139.74])
	by imf06.hostedemail.com (Postfix) with ESMTP id 7644618000C
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 19:28:39 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=VcbRIp4J;
	dkim=pass header.d=columbia.edu header.s=lionmail header.b=B1TVExjh;
	spf=pass (imf06.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.139.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu;
	dmarc=pass (policy=none) header.from=columbia.edu
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788377319;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zKnVzljslWEn654S8LhmKqCkQWwfR1ZqpbkHiEttZS4=;
	b=8XDZKsLY/R7LfSy9TWdE4gl52zwPWfSZPPDzHvhM2UposKg7KnuRlLh1hfS2T5krxSeUtP
	CdZn/xMH18deP/UmDEGBuACp8VTwv5E5TVpADm8QEwrhqksAeu+yDlbwRKXHMdfrnEClYx
	gJ/2Ftmi93CvHPArXKjPRwUr3hfaGwc=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788377319;
	b=xOuolhLAey48Jja5v5sMyvIs786TkjWeeM5rxssXtpvCJ1kEXN3wxJQvIU8wO6dkFAXhTo
	tnwj9cu+lxBd+6//ILbA2NMkwPeyQ+msoh4tpIaNanavsE5XxDxLt7qV5U+KROCJegzAO5
	LmBkqDYoCK44DXK70adIfgyr5EA6KjQ=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=VcbRIp4J;
	dkim=pass header.d=columbia.edu header.s=lionmail header.b=B1TVExjh;
	spf=pass (imf06.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.139.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu;
	dmarc=pass (policy=none) header.from=columbia.edu
Received: from pps.filterd (m0167076.ppops.net [127.0.0.1])
	by mx0b-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 682J5XHw1027110
	for <linux-mm@kvack.org>; Wed, 2 Sep 2026 15:28:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pps01; bh=zKnV
	zljslWEn654S8LhmKqCkQWwfR1ZqpbkHiEttZS4=; b=VcbRIp4JVvQ/3ejpIWPP
	caZTh/F5tjCRdvFZ/W4BJovJXlZKNdSkFZS17kv8udRIKw5cuUQxZvRHb38IW5OD
	LQ/GwWFWKi14Q98Qqt8pl4Zi9ZCNICDsIn/zbyYdpBtISVYL0Kby7OOydvSI8Pjq
	GO3ILRPBcard5zQIfPI+Q3RZTHtYbgkFru8pWAOQ2/f00YWwHgWwXMiHVG6WqiF1
	vGSEFzCpH0/td4+0cbc7Ng5fnIRrgQ2h2PEalAq4fw+Evle7D/vWnFNjVTZDpYqL
	96MXSyd8+P0h/PSauYCwlgtRfq/U5iCS3XyTMdzODvpYYJft8/oEVhN+Yx+GC131
	4Q==
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com [209.85.222.200])
	by mx0b-00364e01.pphosted.com (PPS) with ESMTPS id 4gesner54t-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Wed, 02 Sep 2026 15:28:38 -0400 (EDT)
Received: by mail-qk1-f200.google.com with SMTP id af79cd13be357-92e52306621so219895785a.1
        for <linux-mm@kvack.org>; Wed, 02 Sep 2026 12:28:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=columbia.edu; s=lionmail; t=1788377318; x=1788982118; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=zKnVzljslWEn654S8LhmKqCkQWwfR1ZqpbkHiEttZS4=;
        b=B1TVExjhlIHdxg8Gc4iegTBubqyZFWihkG3XxGWg31cLtDBUoTQpivuWeu0cXonuvA
         uaoOT9yjEWqXyEB2R5W2m3oF7LumWcttFPVC1eEt/4vGCwDKD8ZvideSiRrVrVk3G6cJ
         rUej4+aI/I8AFPXC36qCjuGxMbItHsXaHGWbMRicXsTOvpRYEOjgWONL/Hb0/T2F8+3Y
         c104GoKG1HYSTNNR53LeJTWTed+1dlijn63U3yJFydzaL7iQkqIBOxalTVzqG9xP7rYs
         slu52sAYQw5FPIUP2kSlAFAPvyTQirL38axDbgxL9VUpelPnVF8HvYrBHF5S9U7tArLK
         MSdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788377318; x=1788982118;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=zKnVzljslWEn654S8LhmKqCkQWwfR1ZqpbkHiEttZS4=;
        b=TJNhS7chCQGfUGhSzp0qw4iipx9n3JhrAtVPECsj/7PsM/h4gHzEO2mUdkI2kr6USS
         w2tUeyWcnGbYDqp/N00av+u+vNPwLUFzAW93PeqUPPVxHyBbhc9PSIAZcjHENEaEN5R9
         807inmbGKYbc3x4t8o6+fpZ5x9frR2S5VM16DnxMmQu2FQgkfAbQnJGll+Q/L9sOffjZ
         CyK+ZPVODAPBrrLu2ot+LGG9hZjZ6ColKpvdd4rQ3FWb7KLtlY2vjJyzFGsIFGfQqwQu
         sXCokbWk2wt+ZN2fBI9G73pERbDBDnmoqNeuPIG9FnSOV5oNH/rBACe23S/nF8RjSSDj
         e3zQ==
X-Forwarded-Encrypted: i=1; AKwUvBzyT/XXO2wz1vIGyz5c81EiB1I7iPuUmr9OhfY/GIkQ+y/XpnFsU25mlOuLJvt9p0+qsO4HW4v6WQ==@kvack.org
X-Gm-Message-State: AFuF++nLuO8RlCp8qRI9w0ZmGWEg1bkh97cqZFX0nC0DIVP5OGXn0hMd
	7DUL+07+lMwPLBUXGhoVFaePfi+396mrAUeACM7DjILlfMLVKRzrvqX7GQJCp0ku0hK3WrjkCK9
	6iWQOPCofo9NutKSWtGXF8yjZM/eN6DjnVhjwrAuXbSU8EOcH
X-Gm-Gg: AYBFou289XAu9EGrXq+oIVKp6UXhgXxuqAK54/sED9MbxKy/Hooe7h373hrgdZGh82X
	xOV2TLvAJco7O8aace276ytE7BcggDUmCnP0VbJGQPcKAwWpkQ4TnZjOP1DA+0HAo2VCgMtTVc0
	Y04ziZp9tU120Elr/+A6qonbx966w8r2aHDpWC1wGLinWTVnG6WrGBTX82YHwZ116iGWkuX9NrD
	UUUoz6DdY/97MRBetnPXej2f7dviig7j5IJ2RU7gbw5oWYR0F7Htayk/oV9HJK4NRm2Z6Lk8L01
	UhdztFQDRo8B76M+M8itCb15TfC8NTUV3TWnZsyWNz7I2jE7vfTvXZ2LHMfpC7BXf0N1XnjHElN
	N5JWj3+PIL5pHO6X1GGsYX7FHU/JRuibLYEBMC3fS0UITtJpUr6HDQw==
X-Received: by 2002:a05:620a:4448:b0:936:a407:98bb with SMTP id af79cd13be357-9396f65f15cmr67781185a.9.1788377314133;
        Wed, 02 Sep 2026 12:28:34 -0700 (PDT)
X-Received: by 2002:a05:620a:4448:b0:936:a407:98bb with SMTP id af79cd13be357-9396f65f15cmr67750685a.9.1788377310673;
        Wed, 02 Sep 2026 12:28:30 -0700 (PDT)
Received: from [127.0.1.1] (nat-128-59-178-193.net.columbia.edu. [128.59.178.193])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-90e9eec85a0sm25420936d6.29.2026.09.02.12.28.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Sep 2026 12:28:30 -0700 (PDT)
From: Tal Zussman <tz2294@columbia.edu>
Date: Wed, 02 Sep 2026 15:27:56 -0400
Subject: [PATCH 10/11] mm: memcontrol: constify mem_cgroup_swappiness() and
 mem_cgroup_get_max()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260902-folio_memcg-const-v1-10-e2c1da22246d@columbia.edu>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1788377294; l=2036;
 i=tz2294@columbia.edu; s=20250528; h=from:subject:message-id;
 bh=qY55MTnqibpTPmaITCcOknY/TskrjruIzBjhjSvoJq8=;
 b=XBJ1VxJgkZ7z5/jJpbpfdgQJ9HTXTIu58edJVRrSCFJGK7C1hYYjRFweIITZPR6353Ht7J0S6
 Agk9F/63QbZCBLqPgyFB2x5VwRDyz/DAkCE+H1xfhE5G+ha32Pkhl9f
X-Developer-Key: i=tz2294@columbia.edu; a=ed25519;
 pk=BIj5KdACscEOyAC0oIkeZqLB3L94fzBnDccEooxeM5Y=
X-Proofpoint-GUID: lqb_9YjfctmaMEyON1UxUMIQvv8BpOZ9
X-Proofpoint-ORIG-GUID: lqb_9YjfctmaMEyON1UxUMIQvv8BpOZ9
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTAyMDE3MiBTYWx0ZWRfX/uIac4Yq+rXd
 3YakBofECSFGKyMn7bJwtRQkwja2KD3YjvHmv838tWXx2egcJ/nXR4IYtiS6dTxfzVobEGCobur
 SzgQrXewqeEpdfVsqPZXyv0l31Ob7bR+byyw9Yx3BZJJuFKc6kDf
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTAyMDE3MiBTYWx0ZWRfX8tz8op51xDwU
 OQL6XspHxDiw+SFjlL4hli8KkxnJyWbhlNzJ4KQGAaxwjXdpumnZaWeuH1+S7ddzCknuobPXCDl
 QEPMJR80QTnOY8TuS71BSkxxn6gM+3YNKSuVwGbRE7SKP0unCYKvm7tkrdB/Pf8JxBPv/DzfY8r
 a3sXQMTImJMcYuPgHqITRBrVckkHBYXqtrjuVV9OFU0UepN8HQxgB9pdIvwlrMqqxJzP5OaPoZW
 6CUOcFcWlOdUM7TfJBI3TU9D+IZmSSzomn4uMK2Q7Errm08FCu02iYbpYnCS7jxwmigdYJPp11h
 F3szjFQSzBBL+x26mp0xNyF3ansJ96T8AiidTL77VNaG+jDXmwcuXE8BHyekUev+cKaeiciYFY/
 1b/YJk3xwo9VEjvAIdj/N1khTOmmYGLk8Knm2RYZeMNHBK6pb7tdrT4Ax2tJZG1BepKab+FbkpF
 FDLXvfxEFEyvIAi5PUg==
X-Authority-Analysis: v=2.4 cv=LsSiDHdc c=1 sm=1 tr=0 ts=6a9878e6 cx=c_pps
 a=hnmNkyzTK/kJ09Xio7VxxA==:117 a=XwBYxoxBwSosfWEfMcqm5A==:17
 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10 a=x7bEGLp0ZPQA:10 a=A0y_DWxS2BwA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Da8U98TiO7q1upZEImrf:22 a=Qm0qsxP7aFY2tkT6R2MF:22
 a=LvCEVWXYBYKFGHUOtEoA:9 a=QEXdDO2ut3YA:10 a=PEH46H7Ffwr30OY-TuGO:22
X-Proofpoint-Virus-Version: vendor=nai engine=6900 definitions=11894
 signatures=596817
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 malwarescore=0 bulkscore=10 lowpriorityscore=10 impostorscore=10
 phishscore=0 clxscore=1015 adultscore=0 priorityscore=1501 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2609020172
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 7644618000C
X-Stat-Signature: aeyzc716nbx3sf7srjdfh73i8zrmqtm5
X-HE-Tag: 1788377319-164217
X-HE-Meta: U2FsdGVkX1+i325wkxW+Fs2jIjre3h56kjcAUVW+zuwYe0VLiaYStvPwUfdAaOCmccZG/UDFtWmiDL1HyOq2tNVO3zXUMuj9GaB2VqbVohttTpt43VVxuzIfhmOAlI2tsfrjwfEXcx1tBfW0STtD8EVltdlQmBHvLt6iBc8e31TtVsbAoYt906MxzKOf2ycarlYGAvB6rW16q4hRdWBoI7G+xSErlXFIqFUo4+zVoiKxo6NRaIEFXBr8RAAFEh5MkPZVuL3IP/y6V7M5HDCCeE1pAuiKxOF02OrgsIC45xS6enZXmKqtHh9BOYmc7BMfgA9VumVnassdaBg7wAqSlhj+kzK26wvRPXEBta0qLp+Q2jIErCGxEC6YR5/vaVTsCpLFqkXEojM1FjycDP5VFoXARqN7Ffmmf23KmN4nbxc3Yl8LE4FnJlbLL3W7z9ZuHtZRsqlUbnmNV/907+pdzHPTjROuOTKpuuy/UTsPbHMGPdE605OcM5eVt2Ua5bgFAylBhO9nAYqI4K9mOuj84wBy9d4Hy5PWqUb5s8jBvyZixj4CuGncOC1rxdalVF8X6iFRBsOynvCo03tX5lTBcgUje1tvnXw8Y06OFj3t5+l7d0/BWKLoZVmnMUyuNE4lvwhz9vEJsVk4GgeJIkvI5fyaKGnslldSHYDH050jkZRarlYAgsmUWmlwT2SoT1tmdkXqkmUHt+LDlBiLVKGbf3Hx3tyz8j9nkRjCMAIbGgiWkBZMn17dC9mO6E62Wcwoq0nm1aRIDzCiDBIlId3sfb0NOsvQt5B93Wx0nc40yem4f3Sbij37at7PFcXiqup6h2DUM+iWtdJ52sq+IJXuwwfs1uprwPKpo9jHh3vn5++wlY0T4Jty7WlxMIQbDaUvfW0lTpm0rL+Q1kFwdn1uJAnfDsVBX7H22gS1vvGA16VQUss3R6ARe6u+byCB3q5zL0io0AOTJr2y6nXYLKc
 E/NqK8iC
 qVzFckmBW2b741WUVK1NEoijihqjqNHAew3zbXmJdp0CbAYrq/PMGveDF5rvlZZ+JUvGuiNZQnw+1AEFhOipx9PE38Txm0DZKI4I+eHxCNXizbA/U3xC2CB4ozu90dY+0K1LW5KrL9iBj4jP8Eyv6ng69LM7d9Wx4/kwGaaD/K/Gn66yGrKw6XIK9wOBVC9rSPVNf4Oageba5WRzLV14tQhGPOINO0eQCxQ6ODCK6nGWipWRThh4fyP/dRPA6NjssX+U1E495YxE9Xfhp3olYHbAdMqtFlLAXQwqoY5GZpCQhESecHPCmGdxvxVhqG5VEv4Lt3uuxqPtOF/N/ihPvxA1j+oA17fBAJNgMZLU0/ijZZflLh/+t17SX5TE1UZg63LeRo3vviyyoyTkK2jMbsh/AM2YECjnb8Nrn+E86nbGK38Y=
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
index 10a197886f31..2d5e43dbec4d 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -902,7 +902,7 @@ static inline void mem_cgroup_handle_over_high(gfp_t gfp_mask)
 		__mem_cgroup_handle_over_high(gfp_mask);
 }
 
-unsigned long mem_cgroup_get_max(struct mem_cgroup *memcg);
+unsigned long mem_cgroup_get_max(const struct mem_cgroup *memcg);
 
 void mem_cgroup_print_oom_context(const struct mem_cgroup *memcg,
 				struct task_struct *p);
@@ -1332,7 +1332,7 @@ unsigned long mem_cgroup_get_zone_lru_size(const struct lruvec *lruvec,
 	return 0;
 }
 
-static inline unsigned long mem_cgroup_get_max(struct mem_cgroup *memcg)
+static inline unsigned long mem_cgroup_get_max(const struct mem_cgroup *memcg)
 {
 	return 0;
 }
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 2b8705a88f6a..e28b2a4f278d 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -1878,7 +1878,7 @@ void mem_cgroup_print_oom_meminfo(struct mem_cgroup *memcg)
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



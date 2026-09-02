Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 32F08C61DD6
	for <linux-mm@archiver.kernel.org>; Wed,  2 Sep 2026 19:29:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3CF226B00B0; Wed,  2 Sep 2026 15:28:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3A6B66B00B3; Wed,  2 Sep 2026 15:28:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 220B56B00B5; Wed,  2 Sep 2026 15:28:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id DDADD6B00B0
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 15:28:36 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 75DCE80330
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 19:28:36 +0000 (UTC)
X-FDA: 85169809032.01.B10A21D
Received: from mx0b-00364e01.pphosted.com (mx0b-00364e01.pphosted.com [148.163.139.74])
	by imf05.hostedemail.com (Postfix) with ESMTP id EF388100003
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 19:28:33 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=CshMvBTt;
	dkim=pass header.d=columbia.edu header.s=lionmail header.b=o54p4L4W;
	spf=pass (imf05.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.139.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu;
	dmarc=pass (policy=none) header.from=columbia.edu
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788377314;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=etsoZ1nYpLyjnqIEyDkj4czRZjNiE+7y+Zy3Gx/jez4=;
	b=fZd8WFyxPPji4HWE07bx6xllP43e/yRTEL3+pFpCM+0qYfiKwYbVFK7VOHnbM0MWgOFndy
	NhzIJmNVnBBs5GlumzH9IVMyTii0/41FiZwQxn63k00FKyuYQEN58xif6UfwGtP+y9W7dV
	ImKkirk6kCo85HuF4bD7J1OpV89q8z0=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788377314;
	b=QAFRkn9nKfMchWX5FM5gf7KQOBbj57AmVVKiaEGQbF0uVU01rQcvLUz2FLEMEaTC29VKOt
	EIsymndxHR2lUwtf6JaDdAJML5yDQa3s0sntQ32Jf7me2yMYOQBJsdR3J1ThgKzcy7a7XB
	37/tYdMmMQsa5Hz69VX/prdjJ+Z0Zow=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=CshMvBTt;
	dkim=pass header.d=columbia.edu header.s=lionmail header.b=o54p4L4W;
	spf=pass (imf05.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.139.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu;
	dmarc=pass (policy=none) header.from=columbia.edu
Received: from pps.filterd (m0167073.ppops.net [127.0.0.1])
	by mx0b-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 682JCw9u1005216
	for <linux-mm@kvack.org>; Wed, 2 Sep 2026 15:28:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pps01; bh=etso
	Z1nYpLyjnqIEyDkj4czRZjNiE+7y+Zy3Gx/jez4=; b=CshMvBTt0wF7fZJmdvPC
	razO8mf0NSOk+9J4nMbIzL8vlPorpEzQUgjjHaq8H25LbGzVeeNS8lNLDdVam0pR
	CQsbsnA04zZ9ZozyejAJej6oYlEMJn/ryuBggtxO9yqSF9j0c9yfQcY71E9YT8tM
	jY0aBy6TKDqUAoODeqdvUdUlzZeXp6rJTrAq9kn8ciAKtFn5A13pjrLUupg4OL3m
	fZw26m8eIndVQyPuR8SujTSzqSPzleNiGmM3aTB7KcBNCJrDPCOi8Q1q4+WSStWG
	yTIscEgrjSJpDD5njOHSe3hwlKZ8DbmWFGc6p2IbD/kNBH4+XIDxyccZgZcW8Kxh
	Ng==
Received: from mail-qv1-f72.google.com (mail-qv1-f72.google.com [209.85.219.72])
	by mx0b-00364e01.pphosted.com (PPS) with ESMTPS id 4gesrr03vn-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Wed, 02 Sep 2026 15:28:33 -0400 (EDT)
Received: by mail-qv1-f72.google.com with SMTP id 6a1803df08f44-90cd16a0bc1so39821516d6.0
        for <linux-mm@kvack.org>; Wed, 02 Sep 2026 12:28:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=columbia.edu; s=lionmail; t=1788377312; x=1788982112; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=etsoZ1nYpLyjnqIEyDkj4czRZjNiE+7y+Zy3Gx/jez4=;
        b=o54p4L4WGHDvVqxnGiFBg14nfJKZnQNIztszRS87IpGt6s3SDUs47eCWLtUHRDCCD6
         4JTw5wma7WyWli1Cw9FEBv11duacMUzVAMXVfxRSv7owz5AIdLHsAoFRgGxJwaPXrGmX
         U6IjbKJnAg3yyUkzENlgJxB45a5UxvSAd6GsoG/cPVg/wUsRqm5QFTW2YVyHIfMkK9a3
         NwFHGJ3XB/KP3ZYMZKh60gMsXq19FStuwAluhlhoSTMU4lS4KnCBuqGgsj0p3HEltzRW
         6Uyr8B761V2hHmTrvK5MqBp3bT6p8iGojp5d1y4et4MHCwxYR9Wgxuky9uR6bbp+14c/
         mgoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788377312; x=1788982112;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=etsoZ1nYpLyjnqIEyDkj4czRZjNiE+7y+Zy3Gx/jez4=;
        b=JNfsKt6Fhdx2loj4aP1zngh6AnXcrBOWoUstyQ0Fj+jTPJTAa2gbiczcI2MeX1cRXZ
         hme6ky8UzfAw+M763DX6A/wwF3zOsrFtrFSRr1nhEpK8uv54Lb2hU7tLGcCBLB03GY8C
         Of5agocFgQoqdq92RWeITTLYr+GEd5/s8zkDeYFdN393/nwrZ5Ex9y6IF154cYxIf4jS
         bLXw4pnGHMzL4uONM2BValZIPjzNmqlk6qc+7X46W8xRJsMzwr9lakFqbZEG/BjARV58
         v7NGeaxBFOQCpQex0BmkxvcJRRNVFsGI5S1WCfJxybSVe/NJP+cJR3gJInpZvxv0YqzB
         B2wQ==
X-Forwarded-Encrypted: i=1; AKwUvBxgZKF1BDZZ3aDy0GHQZ7tHk8BAUYHuBFBmfPz1uW/Kex8KZGab5SpSrWftK7/jT9Hky6x1R6jkdw==@kvack.org
X-Gm-Message-State: AFuF++nOZk8jxyPu6gn5i5vu0C46FPbjrTDv+NOIwTRhhUi8nHArlSSJ
	tNmJK3RPuIziZ4ezYCp0kvPeO6GBS3dqzly0HO3rMIRuf3/AXg0sxzm5/4A6JQM1tD9A9BE4y6v
	bnE0LqE1FEGulemxtQuhCaq0RVMbvmpXuTxVkH1Zps1SOquR/
X-Gm-Gg: AYBFou05/E/IKUMIQRFggrmlBeEp7EGGst20d5ZzqhNLFpHYz7DGb2EM+dUDd7BjTN8
	cckbbWtmLoFiEB8P3EIW60VzHswtC6IwpL+3N7AeZ/Q15eQWsDcT8qEMyR60Rxr4wjcAVZMdx97
	vtyYg//72/2ZZt+qPnr3N2ifFOU8np3bVs67jV1mqAVnQy70uLGtTBMtNiOULyb3I7GhnWSFJry
	c8+eCNu4U/YjHvGqb89Zq6FAybp3q25dYlF3TDl94JSRTgFfCrw/Oir7NCR+1vFMN3bnp/61zGJ
	Jn6TZxEWhvU0kHE9FKv27QV11JAgene4VOhdrxLpLbjxlR9f0ASDPGvwAMyC2CHTnaL/P0aSfRN
	rBbsTRb08VstarJYn2FGoxEn8LvEAE6NesQY0umwJgPoj3YlAo6mA1w==
X-Received: by 2002:a05:6214:dc5:b0:90e:8a6e:1c98 with SMTP id 6a1803df08f44-90eca3a4b8bmr84521586d6.25.1788377312462;
        Wed, 02 Sep 2026 12:28:32 -0700 (PDT)
X-Received: by 2002:a05:6214:dc5:b0:90e:8a6e:1c98 with SMTP id 6a1803df08f44-90eca3a4b8bmr84520976d6.25.1788377312017;
        Wed, 02 Sep 2026 12:28:32 -0700 (PDT)
Received: from [127.0.1.1] (nat-128-59-178-193.net.columbia.edu. [128.59.178.193])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-90e9eec85a0sm25420936d6.29.2026.09.02.12.28.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Sep 2026 12:28:31 -0700 (PDT)
From: Tal Zussman <tz2294@columbia.edu>
Date: Wed, 02 Sep 2026 15:27:57 -0400
Subject: [PATCH 11/11] mm: memcontrol: constify the zswap and socket
 pressure helpers
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260902-folio_memcg-const-v1-11-e2c1da22246d@columbia.edu>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1788377294; l=2712;
 i=tz2294@columbia.edu; s=20250528; h=from:subject:message-id;
 bh=HtQiag/hQA4cS07wJ3eYyM1OfLA6EMF125WNv+tbpXU=;
 b=6a2WpH9oLcDssQ0P8DLsdO7NmO3ejtxK7/mvXW3DHkwMVn/VmhoY1ToJ0PnMjGbOpdLk/bDF9
 gjA2Kj0xjyGB1U/eaKDMcjnt6vS+w+mfAFv+gB10zbtyMPoRQCs9x2l
X-Developer-Key: i=tz2294@columbia.edu; a=ed25519;
 pk=BIj5KdACscEOyAC0oIkeZqLB3L94fzBnDccEooxeM5Y=
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTAyMDE3MiBTYWx0ZWRfX4DgCCp+eN5QI
 JNIQJvScPCIHWsMO2bU6JIBMYCJ1q2+QKwzpkBQfRP6n7KCwLKQsPUv7NCfxqb7sHIf6VvFXFPs
 SWbIS/e140tgcTsZM+Kk3sk3bVg9tTits8MZHWZce625DIyTXaPC
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTAyMDE3MiBTYWx0ZWRfX/N4pMnYDRqDq
 nHEPFMeHANj9QS43H63qfnp/pzXVNBcMVJKxUQGBr6/GacWUf2f2VXj8EWROfvxwWI9bCQWHmrj
 hQhl2v+c0/GxIA5PnS94lLdO0owfhLQ3nve6sw2ZjJ5jx2/6jNor0xvIFAywGNH83u2zuqtiKng
 r9uVaT0aTy6QAuKm+WIJ9Eb9itoEjin2QDVdO5nbs0t8o7BFmUU3dGDH4OL2foDKvgN5Br18m6R
 c6bjkoe9Ge6KmA3HHhu+FUd1R5iE4qHSAqUetWCbPTZn8KPa0jC8487tibo2MPdsJY/85YYjKZS
 9xDctL2TAlvTKzmoqJ6wIcH0oU6Kq8QEDBl3fyMnNKNFeSlsAdizYgSFX5Z1GOsV9ZoLeOnocr7
 PtP5+THObbGpzVnqzTZZFGBEDs/vzmg9IZAI+82IqXP6XX4PgrKCl0sgMkLBPyuApih5hpX5fva
 +g/mi/DgnvUdvw+yf/Q==
X-Proofpoint-GUID: mNGZ7RsXRcuVX9CRo_2kcOKir6Ege5zu
X-Proofpoint-ORIG-GUID: mNGZ7RsXRcuVX9CRo_2kcOKir6Ege5zu
X-Authority-Analysis: v=2.4 cv=cPnQdFeN c=1 sm=1 tr=0 ts=6a9878e1 cx=c_pps
 a=7E5Bxpl4vBhpaufnMqZlrw==:117 a=XwBYxoxBwSosfWEfMcqm5A==:17
 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10 a=x7bEGLp0ZPQA:10 a=A0y_DWxS2BwA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Da8U98TiO7q1upZEImrf:22 a=jHxIr1HyPKZ_Q5_91PL3:22
 a=JD7xpo4jQ08vE0tIMKUA:9 a=QEXdDO2ut3YA:10 a=pJ04lnu7RYOZP9TFuWaZ:22
X-Proofpoint-Virus-Version: vendor=nai engine=6900 definitions=11894
 signatures=596817
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 clxscore=1015 impostorscore=10 priorityscore=1501 suspectscore=0
 spamscore=0 bulkscore=10 malwarescore=0 adultscore=0 lowpriorityscore=10
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2609020172
X-Stat-Signature: sg6ctueg5fuwjc8pm55pzpqo1rpdmyzf
X-Rspamd-Queue-Id: EF388100003
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1788377313-149141
X-HE-Meta: U2FsdGVkX1/+4uv6I+T2DZA4jUETuUyfyvXVWtypQBlR4J7DmQhcFlIb5j+g83sa/zOa7ryqRsT2KEtMvAmIYPuRvJYW/ue0LllR4tVv2j05BsanK81x+6BcGbOlXe4imiUKaTbAbhQtFOQCL/eh7B/Iv4Z8xi3TfW5eB4onRrQ0nu+hjSvCpJw4tka941bjWnKBvm94dhuaBssAPs6/lLqUaP/Df5CAEe2f/+0auWUT7Wi/o3h/orFrMmWTeVfE9I+VR8RR+OgTiLbPcVNIAN8inahk4seHjd+rhLZklnl0e59upiZwPfk4HLgIyEnUQKpuuceTbKWnsxqP2cCsVB+45jXJiKqFq7EuRbr/YAexP1ae2yqjsjDAk2TBz5rNxRDHDMPVnoKJgszuRlj1yqL/F32lRg3DzW7XFZe+Gr9OQBf8Pvmjxs5DZn7whiCQ0mxpIu17PyFBtdiSl6mp1RLW+zpVKtsG1qUXwpIslAhgTEqvJ892SCXdrvOP05X8PoyWJ5wyMxRe+QeQYGeWIcSo9wZa9VYCi0BDgJ8zrK1VJPhunNA1J451VHhWmBhp/KuKVtpuNEbNg7Lyz/sOWkmICqdeEzaPbYhDcA6V4vepT/wct6WxeXCoqtJrJh+Xam68tB1B+fDQ7I5IBD1ifnN41NisH8cLcT8Dc3r5eTP5wQt+DQHgbizE4Bnl1M6cTzzmKoehpPhNhQL7arf3sF+wcuf9e3Oa3poTD8rlwSdjAA91xnGarMuWJGQHqCqgIigMYzGqW7WqvC+EBZ66SgGOpNAkkAaMj3VCYGMhOkta4BZahmoVlZBqo45CbMWvnlKicwV2VwN0ZpzdheMj+G4owbpcW9AnL+eFLlwlFJscPf22yi24oGEibZ2r+Y28Ii0IH9jy5jMklO1jnUJutD+Lc7dkMMIR3JmIBLcVE3HYbvpY9xNbhC40MsNdPokIbDrI8LS7ahyDdyvPK8Z
 opYgTWch
 e2JpDR1siPLx0wFkdrcp39jjqFgf916cXli0rHiGw1C1mYxlGeVdHG/audQoMrcHu8af12TYfO4DrMM3gA0i/uUV2o8IwyvCPXCL9oT8RCAMFBJZXiC06/inPTHS4Q23fM9ECESBe+TCsMAkIQDTZLRAD/y5Lnf0z+OpnWaisLTHywaNRFIjWxhd6Iqspk7Vyf8KLfow4HG7Cg4E9TKyVddTumjLHzCegh2JUcrk5/1Fcqy34VLwvcDFL0RhXCC14YABzbS9q65Wf1wq1cEbWXBE2ZOMqC/ZbHCXenZc1FZT8U720Y+jzJtSXRTOkmv7k9SplGzIh7jMvefOx+8TYrJxqEN6O+fMHT8njqfDjeR5xFjasOVAKpe1ob+LXkZg5BjNP
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

mem_cgroup_zswap_writeback_enabled() only reads the zswap_writeback
flags, and mem_cgroup_get_socket_pressure() only reads the socket
pressure timestamp. Constify them.

Signed-off-by: Tal Zussman <tz2294@columbia.edu>
---
 include/linux/memcontrol.h | 8 ++++----
 mm/memcontrol.c            | 2 +-
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index 2d5e43dbec4d..e18b44965d05 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -1644,7 +1644,7 @@ static inline void mem_cgroup_set_socket_pressure(struct mem_cgroup *memcg)
 	write_sequnlock_irqrestore(&memcg->socket_pressure_seqlock, flags);
 }
 
-static inline u64 mem_cgroup_get_socket_pressure(struct mem_cgroup *memcg)
+static inline u64 mem_cgroup_get_socket_pressure(const struct mem_cgroup *memcg)
 {
 	unsigned int seq;
 	u64 val;
@@ -1662,7 +1662,7 @@ static inline void mem_cgroup_set_socket_pressure(struct mem_cgroup *memcg)
 	WRITE_ONCE(memcg->socket_pressure, jiffies + HZ);
 }
 
-static inline u64 mem_cgroup_get_socket_pressure(struct mem_cgroup *memcg)
+static inline u64 mem_cgroup_get_socket_pressure(const struct mem_cgroup *memcg)
 {
 	return READ_ONCE(memcg->socket_pressure);
 }
@@ -1887,7 +1887,7 @@ static inline bool memcg_is_dying(struct mem_cgroup *memcg)
 bool obj_cgroup_may_zswap(struct obj_cgroup *objcg);
 void obj_cgroup_charge_zswap(struct obj_cgroup *objcg, size_t size);
 void obj_cgroup_uncharge_zswap(struct obj_cgroup *objcg, size_t size);
-bool mem_cgroup_zswap_writeback_enabled(struct mem_cgroup *memcg);
+bool mem_cgroup_zswap_writeback_enabled(const struct mem_cgroup *memcg);
 #else
 static inline bool obj_cgroup_may_zswap(struct obj_cgroup *objcg)
 {
@@ -1901,7 +1901,7 @@ static inline void obj_cgroup_uncharge_zswap(struct obj_cgroup *objcg,
 					     size_t size)
 {
 }
-static inline bool mem_cgroup_zswap_writeback_enabled(struct mem_cgroup *memcg)
+static inline bool mem_cgroup_zswap_writeback_enabled(const struct mem_cgroup *memcg)
 {
 	/* if zswap is disabled, do not block pages going to the swapping device */
 	return true;
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index e28b2a4f278d..f56e958948ac 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -6140,7 +6140,7 @@ void obj_cgroup_uncharge_zswap(struct obj_cgroup *objcg, size_t size)
 	rcu_read_unlock();
 }
 
-bool mem_cgroup_zswap_writeback_enabled(struct mem_cgroup *memcg)
+bool mem_cgroup_zswap_writeback_enabled(const struct mem_cgroup *memcg)
 {
 	/* if zswap is disabled, do not block pages going to the swapping device */
 	if (!zswap_is_enabled())

-- 
2.39.5



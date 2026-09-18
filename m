Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 56AD7C982D8
	for <linux-mm@archiver.kernel.org>; Fri, 18 Sep 2026 18:16:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 29A196B0099; Fri, 18 Sep 2026 14:16:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 259CF6B009D; Fri, 18 Sep 2026 14:16:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 16F536B009E; Fri, 18 Sep 2026 14:16:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id EAA8A6B0099
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 14:16:40 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 7E299A06E1
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 18:16:40 +0000 (UTC)
X-FDA: 85227688560.21.2B750F4
Received: from mail-oi2-f13.google.com (mail-oi2-f13.google.com [74.125.231.205])
	by imf25.hostedemail.com (Postfix) with ESMTP id A511AA0010
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 18:16:38 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=qepbQGdc;
	spf=pass (imf25.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 74.125.231.205 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789755398;
	b=WodSvHTd+Y718WfV7YLQuNPaJHccXZFtXIgPxMPdV8KJJMjIh7PQIIk9jyYRpK+jIkcRTY
	bAW6PChGMUShTycMmQiXqYi0eNoPEQvMHn/y2Tsdc4hwiJDqk/u+QJFqr+PwoD8DNZ6WKc
	mV+L5MMBEpsDy2QVsIzx2bV/VIDjrb4=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=qepbQGdc;
	spf=pass (imf25.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 74.125.231.205 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789755398;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1CoHLip16Ywr/lC9AnwYxCTtODZgmreI05p0Tb8d9mg=;
	b=VlAYc61OGxq0eJtoiZdNtTYOQxYZeyRUofxAEqYMXnNPPQRAhesw/PNX7ruJgQCQYNl4Ze
	qBjJJnoqSvvnVpFD1fMz4GIyaLpVM29On2bsQ0ogjfg4siUoIkhPwGTohJvMixvOAXRKZE
	XHaO92kEu2Uz40BgN7T6a0s8cvVS0pQ=
Received: by mail-oi2-f13.google.com with SMTP id 5614622812f47-4c4bf3defecso753521b6e.3
        for <linux-mm@kvack.org>; Fri, 18 Sep 2026 11:16:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789755397; x=1790360197; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=1CoHLip16Ywr/lC9AnwYxCTtODZgmreI05p0Tb8d9mg=;
        b=qepbQGdcU6qyn7z7ycnRrVfyedxS6FlR60QXVTsQ88JAw2u9ZwNjFkQL6a1NqV2l19
         9OJJNuSTt0iNwYNx91krZlm5uP5XYjgt8UlBcu7s/TbvQJSCGHjvQYKBQyWOMJXDeCYa
         Gf4g9b9ffZ3QbpbhQhkymSRIY3ytmG0f6kvoNGZOVCq6t48VkCYRQg4tBST5tYxcoX0Z
         XM3CGI75SfSAE8g+uc/RydrHfH0rm/d5t8gvuQ7akY7pCwCRDcVC0sWd+sWJGDs13Gjc
         ABAO+cJDdBg0lHSN2hj4VcZLDloTp5ulOssUXAkf10sKOukaBVIZquqn8TanZeQTD2EQ
         AeSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789755397; x=1790360197;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=1CoHLip16Ywr/lC9AnwYxCTtODZgmreI05p0Tb8d9mg=;
        b=wDPRXvStT6VOaezZdZ1GqkfxT1cBEbcptCqH0+6CZhztz97nv5Ltox12RTJpL+eM/k
         Lcvx33CJRIOoux1B7Dt1GZBk9PBS3hDI5KMiaQeZM0/hqcJqD5cGLqcdDrzWM3FYcaaO
         eqtGYoG0sc8le4P5XHjGpfbqn3aG6KNT2/egmACb33Qj5UAojzp0FDk1RSflUL7twKGC
         a77TIZFmDt2xLVjbE6FZgEozCaVdeLGFgNTEQ+OVj8YL+yCr3BWMVzudY+azEeT9gNzU
         PX5Ftau2V0XOs3Mx6LI8jYpszdju4VlZYURy+JThKufT4vn7lNGRYOeP+Bd9CntbMK9a
         8hLw==
X-Forwarded-Encrypted: i=1; AKwUvBxtxRtvjINIfcR3eNKo+hYN44/7TQLpTVrQbNWlDgCZpfFc7O4kV2FPUXEW4sgRUlWWFRSJ+fUgRg==@kvack.org
X-Gm-Message-State: AFuF++kd7GPUreukzKYJvprJvz37ShNZQ5RvwM6loiA2A0mZPI+kswYy
	zn/SgEDhf8nYB+oh9moFa0uHdVoAiW2e7Scetheu78kUkNtXrHghU+FWVueHTg==
X-Gm-Gg: AYBFou2ktC9sfWTUIkMpqPTW3lVyLZ9QCUSGpJ+MPxWmQLkai+n+54J324v28LqnmcJ
	cMnecfaAv1OQmZDpW5FbQRMb25IF0rhJO7h9IY+dHC1XcIDSzbE3cgN48aH+6JTVmcZhzDi65bj
	FjUYeSP9APgqJ0kGTojg/v8N1RBs6uIUoi4hYI2Mzt/n6+gXzN4P/WFIEjVYoAPvbnqD30TcbxL
	O7fdCJJeVJpxLxniaoAtFFhVTfDVhHA/p+R5MWmqZ5dX4kHfozJmZXXakkkg0K6aUOLytjoKij5
	Vvp8FqDp4heaAAU7a1ZxrrK1VSxhgJV0Oi9AaEC5xadO65DrVdVGbedyylea6EK9o162Mqh+WRq
	H3f4VlInucizSa6nLJnoUQ4W9gk5HYQoGecQhm8YmMCpYpCm+aeEXmubmg5AEjK0jOmC/ckldTU
	f48EwQu5goi3sKmbQDx0CYhmF5scCgq5OdKdarwR0NQaRQg+TYVanMuQ856e5ugpROes+MnsKjf
	6UqjKpAxxspSqp+R6yWpzQEXVYt4w==
X-Received: by 2002:a05:6808:1a1a:b0:4b9:e65b:8c2f with SMTP id 5614622812f47-4ccf7efa991mr4138923b6e.29.1789755397623;
        Fri, 18 Sep 2026 11:16:37 -0700 (PDT)
Received: from localhost ([2a03:2880:10ff:b::])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-4cf3f77781csm47b6e.18.2026.09.18.11.16.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Sep 2026 11:16:37 -0700 (PDT)
From: Joshua Hahn <joshua.hahnjy@gmail.com>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Zi Yan <ziy@nvidia.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Byungchul Park <byungchul@sk.com>,
	Gregory Price <gourry@gourry.net>,
	Ying Huang <ying.huang@linux.alibaba.com>,
	Alistair Popple <apopple@nvidia.com>,
	Rakie Kim <rakie.kim@sk.com>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>
Subject: Re: [PATCH 0/3] MAINTAINERS: rework MEMORY MANAGEMENT - MEMORY POLICY AND MIGRATION
Date: Fri, 18 Sep 2026 11:16:34 -0700
Message-ID: <20260918181635.3251639-1-joshua.hahnjy@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260918-maintainers-mempolicy-v1-0-9a94cac6d135@kernel.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: A511AA0010
X-Stat-Signature: f4qf41bsimwnkyuqrcfssusjwen8fz8y
X-Rspam-User: 
X-HE-Tag: 1789755398-346914
X-HE-Meta: U2FsdGVkX1+4SXphyHeMPyfk6pe2c/6f1nCirWzRsny+0wG0keX0iq5+EGzsUuAot00VxuMeZhvNkXFAtUtjk7CpStzjQop7TaGagcMzMWASrUvHlvFqELUFPiMLQn7MskGxnVj1hXNMEFrudnbwf8ne6cLz2w+kfVddO3z+NWtLCtOwcudj75AVCPrPdqYLXTVoU+09PXVtkO17cqDKMWkknJjcjQm4Yn8Wz+eE5aomwRrGwaNs1Az4ZmSIkKIQ/C42bh5W3C/zrHBpTYhRDTJ7g+OmrqXnkAWyAit64NcwJIf7JsvMdfXdrkXhhCwIMXZKUWlGfMhHQPdTtB7Dgp8LbTKOxtOfIvfUYbvGUc0XrTxVLCBi/EUHwBLHr2Sn/VQ6OHzQyXGl/n5qAlTuH8vp89AQfq7nPn5AW+ZKPUG4JBfq6kaIlgyrA/gOicesJ7DuEBeazopkR9WYHuKkzB0PiMLOd1TxjPZ/yJUOwRHCtZsCZD+XjxkBjdTZd5K8ZbZPDFhl7yIOcD3AoDdx/oiKGS+O0KZMMi/heRxDLgIslbBa9850Hjc05Ivo1ti6dKvxdCLuXoz5q/pICd6DFNAaPGdvbD53pFqH9zE9fksOAQ8EkOyMWUgmPjzL4C33dKY1J2fkgDFpV+AQwTDPE5QqiV6BLD2l6T0OJCXM5X09gIjfJmcIq8oDrZKnaDxWGE19zZpdcUEU3bEgbzRT19GXEmKutJ3gqPYX7mhRFUVreB9o+GCA4h8wSgbotIXF7bvbBQGrr88PbeG3A8PKZlzKBb1xga7afqWhlkLLA1o4QCaobampoR3R7dnVduqo+AuJqyyOiF1xP1d8NMd+m64H2g5gWVHZFpSM6cwU0MJwouDVhJYjm+YhxO6xE1jMd3g1Ds6eyMpvEja1Ug21mktBqpO1CLIOdAJRWK6ek6o6gpj1DnhpOudrjhhLfXP1l3o0y2MCTrOctBpiKKi
 W3ErWT9Y
 lFkHpM9pXQ8BGK1pvJe9OG8oBtfxUQ335BM6R+u7a+AXXB03xkS7XA2zqE9RcJY4m663+kodnFlhgpHxr92KJTMFTdCWUC8i9GSDn1V4s+j+yQHMEhRlhfUTQvmrxMDS5FjdFZALd7FevzEB4PdALrhmU+WKeNtjB1bJrLDRLYG0xfn2Bbr7ksNQpabWCPkhD6k9iwJsSaFojQCVbTbmak42w+H0d+k0L14wI259s7LgwmQa3r3l3fL2CvFTUgM27HU/m8oPs/iwlxJ/PYjoi3dRQRZjZ0DmBuGKagnRDPj/PVUyVuogq+VsjKI+Sf+TfvwHGH9wGrkeJCx37Rc0Rdy7uWUmw+J6uyjbOx4xJ42sFIDg0ykiyHtdDHz4AT5npjlZ4B1bA63ZWt02zv8hV3WtFZltq1ozSCZoKhuPskr4TezGsy6wc29p8aA8X6mnb0gxjmBIGj/z8OnwfW0J6dW22UztR/ydmIvILM0q5AFsPGuPNU24IYNnHDuL1hiqKGyZarhs9NLAOAoP7O49M1nlR5A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 18 Sep 2026 18:34:23 +0200 "David Hildenbrand (Arm)" <david@kernel.org> wrote:

> Let's rework MEMORY MANAGEMENT - MEMORY POLICY AND MIGRATION.
> 
> As I can use some maintenance help in that area, add Gregory as
> a new co-maintainer for the split out MEMORY MANAGEMENT - NUMA PLACEMENT
> section.

All of this looks good and makes sense to me. Thank you David,
and congrats Gregory! : -D

Reviewed-by: Joshua Hahn <joshua.hahnjy@gmail.com>

> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>


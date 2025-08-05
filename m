Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7AF11C87FCB
	for <linux-mm@archiver.kernel.org>; Tue,  5 Aug 2025 20:50:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CA1576B00AF; Tue,  5 Aug 2025 16:50:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C79448E0001; Tue,  5 Aug 2025 16:50:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B8F546B00B1; Tue,  5 Aug 2025 16:50:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id A8F526B00AF
	for <linux-mm@kvack.org>; Tue,  5 Aug 2025 16:50:52 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 5E969B6FE2
	for <linux-mm@kvack.org>; Tue,  5 Aug 2025 20:50:52 +0000 (UTC)
X-FDA: 83743897944.14.C71DC14
Received: from mail-yb1-f173.google.com (mail-yb1-f173.google.com [209.85.219.173])
	by imf11.hostedemail.com (Postfix) with ESMTP id A405B40006
	for <linux-mm@kvack.org>; Tue,  5 Aug 2025 20:50:50 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="hU/wa9gG";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf11.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.219.173 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754427050; a=rsa-sha256;
	cv=none;
	b=iwPxLNEaHitXl0fKIS8EWWeR8DpL3YYzWFoUZrQ1xzgnPwbauOW9CtH06T/f9dPAcO1EE8
	W0fRs4V500iIjg2TDLRzU6ugeRz72NHEdaZGhXPL9xYl8CThRG+iU0ldgwT4ViwtElwrTT
	jAlpNjgJ906x2z/h9RqcmPd9Tl/k3/A=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="hU/wa9gG";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf11.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.219.173 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754427050;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=ZkJR3JDYsaMg5EgtLQqsM1EFIKcngzfD0e3IWoupzBg=;
	b=Ww7Jpa251vn/XHw5Wro7kY+U2YkbXE08E3Lk6dK34RFc/Kda6pbjTIM4i49YwlD5iG5vvj
	7wtlj414grLzRaN1VhLvLFKivXo3cn/rm6SA0XG/x6wjgSki0V/zuqMUbuoqtmN3+lyomt
	ePPE69d8ntLclEsMkqc7rMIjcK7QjsY=
Received: by mail-yb1-f173.google.com with SMTP id 3f1490d57ef6-e8fe929b147so3924068276.2
        for <linux-mm@kvack.org>; Tue, 05 Aug 2025 13:50:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1754427050; x=1755031850; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=ZkJR3JDYsaMg5EgtLQqsM1EFIKcngzfD0e3IWoupzBg=;
        b=hU/wa9gGd8dy47K4eK8iD/PX8QWIeYnSaq3nSiiwMGRHipxLYt7loQKiT0EAt1GAAQ
         Oa8Gqrh9tbQeTpWDl0AihECFOjlzb4idiE+Yu5TRrbkPuGRwgPPAvUBwS30xOtBRm5f+
         crcLEpCRlFFF6T2ZofJZWvOYM8Kr+3eyqgsoD+6MopzHQDVtr2hXIKZondMuax0rgcnm
         1Q4mY+j5SNUPM+9fqWrHTTNjrCY/3pOr8R2cR7KPjArg9NIJ7ZvECvAZPTRqdAaK1S/K
         AfTdgbgxk3En/WABeBpff4V7awqbilUOr9FSUvbN0+K9TfAyou59ywxrB6yFPouFv2Z+
         Nh8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754427050; x=1755031850;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ZkJR3JDYsaMg5EgtLQqsM1EFIKcngzfD0e3IWoupzBg=;
        b=HJ3IV9oPUfiPHQQJQZ7j6RcmrtdzuUiQX/9o9rN0aXdzbGeCpoIO8aBIWnG1EFPcGI
         UIWkRq+cVvDtfoKP25978S7vUYAa/0zP0XF+/ejhoosHsF53O+8JuCDEuTRNjoWLRnuq
         /kkMHhvxiTxZ6U11LJ3RrEzmv8ccMjdQpKng1IgGHY5jRHNh+FAchN3CkZ5XisX3t7h3
         1kQiA1wCtLoC/TeEte8VJiZRk16RsJfzT4yYeKM3VcuadVqpgn3skW1/31PfVYnnOQNX
         OLqjzTRZ9eB0G3LW2zp+WmTsgxKwofXgBHTiZd/BPTY5+Iz/XH0URvFYw4c+5f4LgCeu
         OXeQ==
X-Forwarded-Encrypted: i=1; AJvYcCXJ2brujk4jCFCUljGPYHVY4dkPe9mIokWALCJQqzpjpw49wvB06aIXPFtzrWTThqKzdsRWGwmL8A==@kvack.org
X-Gm-Message-State: AOJu0YzPHJGxOfYmgszhmXNatO1cTwaWH6CLZG4sQnwDTJaFcyYF/WQn
	+aBsrIpQ9akCEto4OQSyWbBjXwMx2F7ESxCNlCwthkz2Q9kT6WyYT5RQ
X-Gm-Gg: ASbGncuvWW5SUGY80yvI+XtjocD1TlDZ0/07mQt/gU6uBGh37h9BaeVQckY+mdssDmZ
	9LVKGSXcp+ndu+CZeGZmVH7SnlQF94JBm9NwLDQGs835isRPIHV5fr3IyvTc6n5xi9IWC+cDBYr
	Gn56FYwCKwXaj4jhh/SVFUn4oo3aF8FQ3dXZp3Do+2rfVTd+eHortHUauDlhGwAiNv+iKSiUboX
	Qoejk9zv8uwn9qfTnE0PNeHo9rzPq2Qk+D1wqhetgI8I5Oi63/vkGrPSYF2cl7K1YjAMjws+lc2
	IYD23wO01YPWXJ7BkdToSS+QBmEfnQK9hcmYNXB99tIJUDdvujAeTFU+n6bLzlnI+hCc2ga7Kxj
	CETToIcn7/vyJe6N1f16s/A==
X-Google-Smtp-Source: AGHT+IH4CQSD7STnqr5i8+APTIpIexp6StX2qIcGqhM3cINeLyQLcygJ0t2OakkLViUtS25xwvzYeQ==
X-Received: by 2002:a05:690c:3588:b0:71b:9213:a75d with SMTP id 00721157ae682-71bc973e912mr9178537b3.18.1754427049647;
        Tue, 05 Aug 2025 13:50:49 -0700 (PDT)
Received: from localhost ([2a03:2880:25ff:4f::])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-71b5a5cec4dsm34333237b3.75.2025.08.05.13.50.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Aug 2025 13:50:49 -0700 (PDT)
From: Joshua Hahn <joshua.hahnjy@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@redhat.com>,
	SeongJae Park <sj@kernel.org>,
	Ying Huang <ying.huang@linux.alibaba.com>
Cc: Alistair Popple <apopple@nvidia.com>,
	Byungchul Park <byungchul@sk.com>,
	Gregory Price <gourry@gourry.net>,
	Matthew Brost <matthew.brost@intel.com>,
	Rakie Kim <rakie.kim@sk.com>,
	Zi Yan <ziy@nvidia.com>,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	kernel-team@meta.com
Subject: [PATCH v3] mempolicy: Clarify what zone reclaim means
Date: Tue,  5 Aug 2025 13:50:47 -0700
Message-ID: <20250805205048.1518453-1-joshua.hahnjy@gmail.com>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: A405B40006
X-Stat-Signature: 9x9htktoejxwaaiiygwm3w5txasdw8ad
X-Rspam-User: 
X-HE-Tag: 1754427050-920959
X-HE-Meta: U2FsdGVkX19h88WTKgje9hznKMGMxLdWcNF/8a3UP5iEAv30/Zequnt2jH9L6NrSgUTvUV9fM4FqIJmMHFnF4jJjiLx6Rxg8VBbGH9Mq5wViWGbHH8VvL+8U3uRC5qWjrukjzdK19ND6YUMIFKP8Vi/NpuwvGnvO6AAIsmO841tJytR9v63toWPR8cl8KiO/vyxa+ILyExr9SQp1NVS9NMU5s2GzE35jcFLLjK+oWuSOsa75bL0gCemtrv/xPKDxtoa7pLFFRLi7X+0rJYoySE8tZ73soK2s4RLRA8du+JqVGm6QZJcV3h/JAV07ERm1Lv+4X5ENmTBU32CMtd9F0OJxbE6Y/p72W+nBXJneXLoFDG1A0IJKl96Kw07fJoshjDnhdVXNKDr9BIF+iJNlFOOCeEuu0qxR3aVgwHLeHuaad2Wc1e6PjDN1IyVZBmkteooDaarD8wLT5n4kvnnPUdWHD9oVme8oKiz4I6zgBGY+WaYMngaHMIvgsFNbnYXgJG+WSMgX/GysCVBWUcLtnAKdIwhfmKEU6Dt3ieopQVovul0qkIMyYZisHa98kQ3nNLz5N6ZL/5RHxpYXn+Y+XMOi6KN4lku6+n0/JlYWwLBWfYfYj5RAnNTGji+5ZXN15rSZnb5hzAJN3b/43WFlrdN6ryRhNYDobZqMZZRyVuQc76D/qXrUTXiIApm/yeA2KX20Ojm3YwBdL8So3uAvfvIW/gY/CT4NZyL1VMAZAw+gKnw1QAQ9GvC7b1Gkrgt9G7xT9NCAqWXBOqbD+aZpduuWwOPL+G7DUxFLHOoITI6ed+aJ07p1rzeUrHNvta2Bmwx8oFlXPLbNI3DDqoVRT9dklW9tvuKJJyrXRoQYI24OdBKh5MiT8Au+DMqal3NtxwV+WI6y8AuFOnZzaN2iDQxaOCSWt9yTlmX9q3MLO2xcT3vmbNpJv7kkwIQPFeX+xFp4n7UXgc8gY1Xa66P
 lK2LDgVo
 DFTpu59yVytRmkLRDYcUbzBpxGv1bKAV8A/v0I6DnmT85nLbo8UNHcT3W0Lmo6DkfW3COBli9lZgrt8arwucIgn0pZhYxs7jm6UqDGk3sQqR59WQ8hIzyQk07wai/d8Jk8vYVUipuN3l432l/FX6ZZEDXQtxQpETJHEWz4byp5YCH5/sAjMbZm/6CKZsDsHydXMCkUKx2hlFkWrp1DVIaIN7+fyERNCoyY5k5fuJtu8UfmfJiJjldD/IOm0CTpm5b8HQnpJkoPGLXeinQULoMzlLOoHsyEtNkZNelTDeuIdiAaEEwPE0Q3t0H0OsNgl1GXEuGEA8Z7HlHEleQ6Mf9ODHG1su1HncNzIZPeBDBXPevI/3jBb0tDSYIPMRQdPGUmx/7h6ETTNnM3qdqlwx1aLtrj79hqDUKxr8vHNBuFPf3Q40PN0PjgANSJKXKlf9w+gxrxyOdMVnFE2hZFPfLp5ICcaCvvod+Mg/qXbSNBEPgLPIEXcJajcARQO9zvoXydZ5SJYu5o/IZRK0+vFkCSNs6kzdPb65j1s3w+IVA1CuNic/Att+4i4fQoA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The zone_reclaim_mode API controls the reclaim behavior when a node runs out of
memory. Contrary to its user-facing name, it is internally referred to as
"node_reclaim_mode".

This can be confusing. But because we cannot change the name of the API since
it has been in place since at least 2.6, let's try to be more explicit about
what the behavior of this API is. 

Change the description to clarify what zone reclaim entails, and be explicit
about the RECLAIM_ZONE bit, whose purpose has led to some confusion in the
past already [1] [2].

While at it, also soften the warning about changing these bits.

[1] https://lore.kernel.org/linux-mm/1579005573-58923-1-git-send-email-alex.shi@linux.alibaba.com/
[2] https://lore.kernel.org/linux-mm/20200626003459.D8E015CA@viggo.jf.intel.com/

Acked-by: SeongJae Park <sj@kernel.org>
Acked-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Huang Ying <ying.huang@linux.alibaba.com>
Signed-off-by: Joshua Hahn <joshua.hahnjy@gmail.com>
---
v2 --> v3:
- Fixed typos
- Softend wording from "never" --> "should not"

 include/uapi/linux/mempolicy.h | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/include/uapi/linux/mempolicy.h b/include/uapi/linux/mempolicy.h
index 1f9bb10d1a47..683c130782f0 100644
--- a/include/uapi/linux/mempolicy.h
+++ b/include/uapi/linux/mempolicy.h
@@ -66,10 +66,16 @@ enum {
 #define MPOL_F_MORON	(1 << 4) /* Migrate On protnone Reference On Node */
 
 /*
+ * Enabling zone reclaim means the page allocator will attempt to fulfill
+ * the allocation request on the current node by triggering reclaim and
+ * trying to shrink the current node.
+ * Fallback allocations on the next candidates in the zonelist are considered
+ * when reclaim fails to free up enough memory in the current node/zone.
+ *
  * These bit locations are exposed in the vm.zone_reclaim_mode sysctl
- * ABI.  New bits are OK, but existing bits can never change.
+ * ABI.  New bits are OK, but existing bits should not be changed.
  */
-#define RECLAIM_ZONE	(1<<0)	/* Run shrink_inactive_list on the zone */
+#define RECLAIM_ZONE	(1<<0)	/* Enable zone reclaim */
 #define RECLAIM_WRITE	(1<<1)	/* Writeout pages during reclaim */
 #define RECLAIM_UNMAP	(1<<2)	/* Unmap pages during reclaim */
 

base-commit: 6bcdbd62bd56e6d7383f9e06d9d148935b3c9b73
-- 
2.47.3


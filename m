Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8D8F2EF99C4
	for <linux-mm@archiver.kernel.org>; Fri, 13 Feb 2026 18:15:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AAFC86B0088; Fri, 13 Feb 2026 13:15:54 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A32C76B008C; Fri, 13 Feb 2026 13:15:54 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8DC746B008A; Fri, 13 Feb 2026 13:15:54 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 771026B0005
	for <linux-mm@kvack.org>; Fri, 13 Feb 2026 13:15:54 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 4877C1C5C7
	for <linux-mm@kvack.org>; Fri, 13 Feb 2026 18:15:54 +0000 (UTC)
X-FDA: 84440237028.25.17937A7
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by imf16.hostedemail.com (Postfix) with ESMTP id 6C047180010
	for <linux-mm@kvack.org>; Fri, 13 Feb 2026 18:15:52 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=linux.microsoft.com header.s=default header.b=eujRomCG;
	spf=pass (imf16.hostedemail.com: domain of tballasi@linux.microsoft.com designates 13.77.154.182 as permitted sender) smtp.mailfrom=tballasi@linux.microsoft.com;
	dmarc=pass (policy=none) header.from=linux.microsoft.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771006552;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eIWSUeA5jrXy2GEYqMyI4qiE4CqcAnCn+rGFRu1MjD8=;
	b=7sl/ocy57GB4zyLZ8mVhr1OYp4HKY8OTXwq6UM9T5Q59g+9ACcjp4M4QRicVBJ+1mfImgu
	HQ/XvjdQDVUPAajDAOn2a/TmDRRRmNbKDN9Ltqqu0VhggM0X8WA8RJeey970wsXi9yVIzB
	TV+G2MjuQg2e6Yiqx2n5AsxfhLZ0xaA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771006552; a=rsa-sha256;
	cv=none;
	b=D+2ltcgOuCaCwdUgDhAnQ3T2tjjFvsF6+uEEzqtl//lGSnwdLYQFoCarI5npnCny+02CJH
	8efUY6isu5+XtAa6UyF6RZquV5QNlV83X+bKOi8UH+E21gduk4Id6HlDskPpakZhpHCge0
	Fk7V6B28ZJa9V9UleH8EcBJTfshl5zE=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=linux.microsoft.com header.s=default header.b=eujRomCG;
	spf=pass (imf16.hostedemail.com: domain of tballasi@linux.microsoft.com designates 13.77.154.182 as permitted sender) smtp.mailfrom=tballasi@linux.microsoft.com;
	dmarc=pass (policy=none) header.from=linux.microsoft.com
Received: from LAPTOP-U3CCR7C6.lan (unknown [40.65.108.177])
	by linux.microsoft.com (Postfix) with ESMTPSA id A2BDD20B7165;
	Fri, 13 Feb 2026 10:15:48 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com A2BDD20B7165
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1771006548;
	bh=eIWSUeA5jrXy2GEYqMyI4qiE4CqcAnCn+rGFRu1MjD8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eujRomCGGvJ10SwXSjJwRAaEgWNw39PibhIQW9VyxbG7nZJCXPZ3+JdL1cNSj+3My
	 N7ZVwTIZ0XVs4s6ce+TRgjwEvlNXchGJWpsoj+ct5eOUNj1O8NQayLbxHTUo7MWLhw
	 JM+aZKZp0Q7+ofMKoNIEdhAYNG3tOIbxMOV/yXtM=
From: Thomas Ballasi <tballasi@linux.microsoft.com>
To: tballasi@linux.microsoft.com
Cc: akpm@linux-foundation.org,
	axelrasmussen@google.com,
	david@kernel.org,
	hannes@cmpxchg.org,
	linux-mm@kvack.org,
	linux-trace-kernel@vger.kernel.org,
	lorenzo.stoakes@oracle.com,
	mhiramat@kernel.org,
	mhocko@kernel.org,
	rostedt@goodmis.org,
	shakeel.butt@linux.dev,
	weixugc@google.com,
	yuanchu@google.com,
	zhengqi.arch@bytedance.com
Subject: [PATCH v6 0/3] mm: vmscan: add PID and cgroup ID to vmscan tracepoints
Date: Fri, 13 Feb 2026 10:15:34 -0800
Message-Id: <20260213181537.54350-1-tballasi@linux.microsoft.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260122182510.2126-1-tballasi@linux.microsoft.com>
References: <20260122182510.2126-1-tballasi@linux.microsoft.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 6C047180010
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: 8dtbwjjmma38m3io6q94kh4z56njoz3k
X-HE-Tag: 1771006552-519795
X-HE-Meta: U2FsdGVkX1/RwCT9S+S4nDIGZc9lfVXXM8ZTWDfl4HRUp6y6a4VEcFWnD/CZeRUes7t+a0MaF00OzVRL3zS0G2E9vgZ9MC/xdw2oGtTrIvHh2nqyBoyJnNBbSRN4bE/L4m6D9l+xeng3Xm6RceG1HtgXzc5NoEaSEpEs1jAub+tZzcy6jWD+dfV95vxZPE1XKv0/lw2QoDAtTNNvgzRySC/tzm7ZqadzQHSKz2Ss8yIfUAPaBsYfe5PfRxLCxpRX10dhUGQz1NUTFhAmYfJ/+P0SYf4epMjBfkTIShM5pMKfbOp7pTJf2XFUXsUug7vnDTE4eF7dERFOSavrua2GYaG7pcjONkFw3spcaCk3mRWZeDI+xJWlT3ye3Cc+vfjHvteBWNmAXBpxgxuxstqc742rrV7o3C9gZGCLZybOaQnkKU8w78b0G/kWZlQ9j1SReQnE+itNqhv9MeInV/CP7Yxpd0Z6fl7ppbbMnDWBQRKoDj+oQBeTiK2Vz3AHpIfHLauixHrM+hEsuyuKQN/8RSZtvvlWmo5sYQTh/v8IoE2abDelFAVhXj6db9ciQpNdYYw+ZsYU6M6s3ObOftb0XUIJjdwu52EsyaroXHfUTtLtPjPehLP1zaC7KSilvIYuqGWjI/wWoIc7P01dTJPkrkFBCxm0NbdvwKABr67o4zXeazAun0N6aKkrdfTotVhIofVdtPP/ySQKqrQCFaPc3lF/YMl4vKhaWFZuOEhebRdmPzJAPkriMwLHDF2IbcDWQF3VigzVDQQlk5wPtjmX1yFhRcudinwB5sDebdJllQRsXcjLPqouw1mNJZw+QS3N5jcfM2cQFKNJv8JwdmBW+qy2fvOpiTqRnNdKUNeeaVGXt9yy1GuxyMOPAh9+OMDxlHdoIpHArLtHA7g8nsXVe4R9NSvYLWSqYIOJ8Qbp7pIqLTS3ZgUJrNRDs9UMZASaxr8r7nvfv8xIPRN/EHx
 5SYACwa3
 27MmgErqFsIsazps+ZyORDrXef/Zk4ThbbCzeekY+LMG5HgK9gY3dEq3/wgE02kkrb2nqdvq+UPOW8rvQ5X4lv/Ia6I2ad1Q5+hQjmpRqwFYOwtcZLm4zZImJdLjdQ2nMIrzsISmJb61Jxmjh1BxBJpTNf7DllcGhxJYSLHQAWS1H8sIW8tBbnvqaE/Ab23LwJElm2SQ+fdU3jWyn7oTn1p9F/Xr5ON+RuizV1VM3czbu1wUV1kDZ+FBeIrc3VPUUaABeKnn7sNeBS41sz23dEfHVC7JRw2Ehn8k1AyFfc3M4Qpy64zyPNnowPQGDXpM8dk6F
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Changes in v6:
- Updated Steven's patch with sign-off
- Passed memcg pointers as arguments in tracepoints instead of memcg_id

Link to v5:
https://lore.kernel.org/linux-trace-kernel/20260122182510.2126-1-tballasi@linux.microsoft.com/

Signed-off-by: Thomas Ballasi <tballasi@linux.microsoft.com>

Steven Rostedt (1):
  tracing: Add __event_in_*irq() helpers

Thomas Ballasi (2):
  mm: vmscan: add cgroup IDs to vmscan tracepoints
  mm: vmscan: add PIDs to vmscan tracepoints

 include/trace/events/vmscan.h              | 104 +++++++++++++--------
 include/trace/stages/stage3_trace_output.h |   8 ++
 include/trace/stages/stage7_class_define.h |  19 ++++
 mm/shrinker.c                              |   6 +-
 mm/vmscan.c                                |  17 ++--
 5 files changed, 106 insertions(+), 48 deletions(-)

-- 
2.33.8



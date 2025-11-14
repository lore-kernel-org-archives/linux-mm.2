Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CAE1CCDB47B
	for <linux-mm@archiver.kernel.org>; Fri, 14 Nov 2025 03:00:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 95DCC8E0008; Thu, 13 Nov 2025 22:00:36 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 935608E0002; Thu, 13 Nov 2025 22:00:36 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 824C18E0008; Thu, 13 Nov 2025 22:00:36 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 738A28E0002
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 22:00:36 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 2E5B357998
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 03:00:36 +0000 (UTC)
X-FDA: 84107709672.08.7148A90
Received: from mail-ed1-f46.google.com (mail-ed1-f46.google.com [209.85.208.46])
	by imf14.hostedemail.com (Postfix) with ESMTP id 618FF100018
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 03:00:34 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=KCz+QlGk;
	spf=pass (imf14.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.208.46 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763089234;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:in-reply-to:
	 references:references:dkim-signature;
	bh=nxmCp+1tFj2nPrc7V0yyf0VDnt4ATzf2Xf+BbEjL6dc=;
	b=tCyFQS8kliYEBfdNhi6lrRV8C4LpC334FxxX0cG7I+8gY7RmfOYBw26YGt2YILZG6WdGW3
	msvbVEOLfhVdOUlhrFX0u6kibvrKsc/8zli9X9MJPBjrzJlcKlMrV99H3nttzG22fA6YZL
	04BAXit8gZAu1obDgxq3crpHCvn4DVc=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=KCz+QlGk;
	spf=pass (imf14.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.208.46 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763089234; a=rsa-sha256;
	cv=none;
	b=5egBNjTkphXTNB8n60H0KrHmtQtJc83LxFj9VmW0Rx9mgINk/cFuP1rGvMI7OymXoGoW0N
	KxNHLERnvtBXkEdMKTnBO1KuyOB+ydWumD9bPQzHH0rZsaqFxYB6ukgyB4zbj9q9LOh+gb
	cTdgO+GGnD/Omy9/hKvLODTZ8hczipM=
Received: by mail-ed1-f46.google.com with SMTP id 4fb4d7f45d1cf-64175dfc338so2744924a12.0
        for <linux-mm@kvack.org>; Thu, 13 Nov 2025 19:00:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1763089233; x=1763694033; darn=kvack.org;
        h=references:in-reply-to:message-id:date:subject:cc:to:from:from:to
         :cc:subject:date:message-id:reply-to;
        bh=nxmCp+1tFj2nPrc7V0yyf0VDnt4ATzf2Xf+BbEjL6dc=;
        b=KCz+QlGkI1acX5p8QkagKzP+/XsxcJzqoQjM5CoChyqywkEINCRzf0oe0AZzSeXA+7
         jL6hkEoHCOEi+gl8kIWVABdzC1iy0SBzxykfWucFLP+hM4i9gtTzE72eEosyWsJoT3po
         4wHSGuIYP6fak4UgOzb3DpHXhOKJxNzON8U4FWJpnL/qhPzlzrLKk+qSN9wnsA/FNme8
         6BxCc18DNfFXOvsl0yDA3RuDDFRNLL0mTCvmgv5kfW6Q9x6QbchG+J2xOHfpNyjByTb6
         m+TzQtqUfq4OwqHEKyTxV3JKUfJZ/1r2o3GQLGVjOcUaPOir4UHZGiW2xQ1A3HXKXCp+
         F2ew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763089233; x=1763694033;
        h=references:in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=nxmCp+1tFj2nPrc7V0yyf0VDnt4ATzf2Xf+BbEjL6dc=;
        b=InfTUXBLSTvQG1Fj9+FqLBHo/eNo8WZdX28rub3pWH/dHEUFpsVbTOzsErSUShSQij
         TbOXbKIeRETAOa2RlRVn5aQzJr5QZBUCPKXvTL4QVbCdqr17RW60vZwoLeAQBm8b1+zn
         AdXxj5wkzbIDSUwqZ5x97dUQeF38sIv/ZrKSVHj7KQQ9iW8Y9hV7aLY1vsPw+ggEGaSS
         sl2zytAvox1wnw1S+PiFg3CMnVNH0NngGwtdiXBSYE3+OX6vqyI8jILN3QKE7QSpxOVa
         DaIOm08T71FTqZo72aPtBC+aruCPQEeEyjouFFZtpbytzx747GNUHHNyfqQxh3QyOc8R
         cjzw==
X-Gm-Message-State: AOJu0Yyjihn20BhrPq+tmYyN5FTOjl11SRbaHu2TBv390VVhM8CyIN6p
	STbMT+GdQFqJ/t5DKKyNsMVtV3SzxANapTfoNmHoMuv+pKcBENtCJxlW
X-Gm-Gg: ASbGncvHIqV23gZCLASqv0y/PRkFJ4B2AKKE2LW73A8yRUv4GkqvBHfb6CP/MsXijTQ
	RbZMmuTSe+cAkTM+ushPwduUIbtJvuun3tSkrj5rGaNmFhgeMcIdQBRFKUEGre7VUxf/aW7ibQu
	/N+O+SXuvvlEM7Ru5Pyh8DniRNaTAhn+0pU9vZNDqr71vtN1dY5Wn/n8Bt/5DQfAMp9idtf5b/h
	Vy1Z/EY9+grGFFQZ1xM9g2sdHJdBhQV1l5mPiUEaocRPpU/MktjXLl09TTtm0kqRl0/nD6Lhx0i
	4g6eT0lo9IRZVd7D6c4jRG3P+awsC9NkhdA0d1okfMPpdBmbpdZXZzlsY4zazXXYRhQo1/1+jBD
	uNKrRsCWaK/CJ8sekAegZJncOPbs77WxMe2zaFNAsNf1aOYU+gX4Vi/npoK2UND95chWxMdHLDU
	ArRnsNwywJQ1EV91JSH4djAruP
X-Google-Smtp-Source: AGHT+IGr2FHI4mQDeFoS9RvkdlYcHCBMADaQXXsC2YpJWm24c0a6YxFb9EqHzkttxnjGp67upgAg8Q==
X-Received: by 2002:a17:906:99c2:b0:b73:419d:322a with SMTP id a640c23a62f3a-b7367bae0f9mr134086566b.34.1763089232918;
        Thu, 13 Nov 2025 19:00:32 -0800 (PST)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b734fa80afbsm287765666b.11.2025.11.13.19.00.31
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 13 Nov 2025 19:00:32 -0800 (PST)
From: Wei Yang <richard.weiyang@gmail.com>
To: akpm@linux-foundation.org,
	david@kernel.org,
	lorenzo.stoakes@oracle.com,
	ziy@nvidia.com,
	baolin.wang@linux.alibaba.com,
	Liam.Howlett@oracle.com,
	npache@redhat.com,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	baohua@kernel.org,
	lance.yang@linux.dev,
	rostedt@goodmis.org,
	mhiramat@kernel.org,
	mathieu.desnoyers@efficios.com
Cc: linux-mm@kvack.org,
	Wei Yang <richard.weiyang@gmail.com>
Subject: [Patch v2 1/3] mm/khugepaged: remove redundant clearing of struct collapse_control
Date: Fri, 14 Nov 2025 03:00:26 +0000
Message-Id: <20251114030028.7035-2-richard.weiyang@gmail.com>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20251114030028.7035-1-richard.weiyang@gmail.com>
References: <20251114030028.7035-1-richard.weiyang@gmail.com>
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 618FF100018
X-Stat-Signature: xop3y3iy7tdcr5pxat3rudsmzq3a5r68
X-Rspam-User: 
X-HE-Tag: 1763089234-211601
X-HE-Meta: U2FsdGVkX192aD95osRS1kxF9ouM/GoNnQCPBlxoMhjgkfbVfqTZApXdVQpQAd1YFrSqKY8Artl2QKp2zM4kmXa/qcUJVxlLjStxH5QWLYV1eWEYITbvAbAIXDs32hn+jwktrAVyUA/AxBUE+UKPtFcdF2GIhd/Z04WjBdIHg0UBeYJgg33NdmGHhAsl4pXY5ThG/bQfYqBS9e8AXCZzEU6Dr31+UaFMR8SRogu6VdLtUx6izk/Uov76xDc4WcE6vHSFJJAoRHXY+MCv3WDnM86q0htWwRux33bP0PS90tsOuDDMWAk3F8S5wgZqgFOseOMeUeWO3w9xr7f3Pr7iVIkpUs0vtFmCCJfqYUaZvTrUPNh5cfDZcqDQY0IXIYBE+uIq9+kNE3dBRmiRXnMH17EN5l1pWGjJF+ybETENzIp66xIqEOoQ5l/hGl34P4cex6c156gFJoWVmpWdjLhc/pgQXJUG6Op+Z95b8ZZQC/3vyPz2IEBrYNnHFtwQzPAdatxIRIS5xGCUkHrIkgFwWO6OEmFndLAREVBRgEgquCxlSXjSIli5QLgNi0rXF5X+XCAv/4FiRkA6dL/jegqZmkkwq88iSbg6Hmtb5Rn21W+I/9CIosy4owEe8hHwCecUTUZb8+znbOZ9YwUD56NIoR1vsfZBaGd4EC7XEaBtmoplNSGJfOihV6I3v8+Qr7WBdhg3J18D8tansJalGxRz36ovyG8VSvCuEUeZvWFO0dn0ZMBbgN5yZEjcqdwcz1nJtlrP3an8LzeXO2xTahqODGJOxjaotBWRim8zcH7Y5Mw2D1CpKDZcSIh9npox0z9TcmxmccdY5v+fE05fLhELiJPQV9InAqXqvBfh42Er6Hs+n4mxZZMq/V2hQhaDIJAq0NzmsWsbBkFfr8yzJ9Unc+LeOEW88f2ExNpZXsEVmwY4PqU2f94Gs0osKhZ5d9XAoSDoefv+qf0S4v15Ogk
 cJpnlMvC
 pomI7hCmtlBSFTrSTusLx9Js3dDc+hX8nQizXPZL7m52RT/8OuknV2wyPeY+vtXltMt8kZcxpSjqYPyE2+Rr3vQkiB5+fUPZt0ZPyll6yDjkjqfsYZF9oOYmduvaxFzjj0U1NRlNRFY7Xnmtlti8whpbfVmGp7OHqJ63zaLjrd1P9wS8sQoJioiLjZnR2jUCXEEYAolqaOf4OIXEqFTYMf7saFS+wLfVw41sEC3T8QaANjjWSaV2/RdtQuRO2n1hE5tds8tsrsNsaV7alPgXW+rV+Xt0arduRQkFDVtOnLJUkHdYEDebDPfR3MoFhHMfM5pPcmN6mg+Iyx/XcX0ppUNZkA3HiRXzUw6vFdlhgrdJwZEDuJs5QdVO2wZH0f3CJNGeIdyqFskYYdviaXq2WRNJ6dVTbSj1CH21DCKFWrORcJXeg7wcLiW0kus3kPsehqzsgaGWpr4Uj9E1fHCLueTqbokutDzDZ/MmJD4fCqS+She6+F9Nr8ac39SwZjedpUpD6uCSMLmkJ0cX2jwzT+ETLn14Xz1FbgdPnGCN6Frzp/lJFe6+0SOoPZWW7zF0s5u7u
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The structure struct collapse_control is being unnecessarily cleared
twice during the huge page collapse process.

Both hpage_collapse_scan_file() and hpage_collapse_scan_pmd() currently
perform a clear operation on this structure.

Remove the redundant clear operation.

Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
---
 mm/khugepaged.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index 7e8cb181d5bd..1fc8986a28b3 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -2803,8 +2803,6 @@ int madvise_collapse(struct vm_area_struct *vma, unsigned long start,
 			hend = min(hend, vma->vm_end & HPAGE_PMD_MASK);
 		}
 		mmap_assert_locked(mm);
-		memset(cc->node_load, 0, sizeof(cc->node_load));
-		nodes_clear(cc->alloc_nmask);
 		if (!vma_is_anonymous(vma)) {
 			struct file *file = get_file(vma->vm_file);
 			pgoff_t pgoff = linear_page_index(vma, addr);
-- 
2.34.1



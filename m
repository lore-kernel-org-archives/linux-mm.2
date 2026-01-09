Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 97734D232E3
	for <linux-mm@archiver.kernel.org>; Fri,  9 Jan 2026 06:06:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0CA1C6B0088; Fri,  9 Jan 2026 01:06:27 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 049E86B0089; Fri,  9 Jan 2026 01:06:26 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E86C26B008A; Fri,  9 Jan 2026 01:06:26 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id DB3796B0088
	for <linux-mm@kvack.org>; Fri,  9 Jan 2026 01:06:26 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 767BE13AB0A
	for <linux-mm@kvack.org>; Fri,  9 Jan 2026 06:06:26 +0000 (UTC)
X-FDA: 84311390772.09.8B5B36C
Received: from mail-dl1-f74.google.com (mail-dl1-f74.google.com [74.125.82.74])
	by imf30.hostedemail.com (Postfix) with ESMTP id B3C3E80009
	for <linux-mm@kvack.org>; Fri,  9 Jan 2026 06:06:24 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=b8kmYxM7;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf30.hostedemail.com: domain of 335pgaQgKCOgLSXQTSKYQYYQVO.MYWVSXeh-WWUfKMU.YbQ@flex--bingjiao.bounces.google.com designates 74.125.82.74 as permitted sender) smtp.mailfrom=335pgaQgKCOgLSXQTSKYQYYQVO.MYWVSXeh-WWUfKMU.YbQ@flex--bingjiao.bounces.google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767938784; a=rsa-sha256;
	cv=none;
	b=75j1idgB93l6VobZHeERgCLhZqfbLwmwDLH3g+8+R0pCB+J+4NnhlE+8gVNmPNWYrh/nLT
	46r5i8SmYCFRdRfSas/6mSBgaFEFSdT+mWpFNPudn9f6GDoUb029bUS82nfqTYF+LsE51G
	MYE95PpM41Y0OE06oYzExvsMvlDP13M=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=b8kmYxM7;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf30.hostedemail.com: domain of 335pgaQgKCOgLSXQTSKYQYYQVO.MYWVSXeh-WWUfKMU.YbQ@flex--bingjiao.bounces.google.com designates 74.125.82.74 as permitted sender) smtp.mailfrom=335pgaQgKCOgLSXQTSKYQYYQVO.MYWVSXeh-WWUfKMU.YbQ@flex--bingjiao.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767938784;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VJ52X8DJw4332ZGcvwO1T13NvF/pxnQEOtkap7ms7B8=;
	b=kl2iscWRFsTDXGR2eRI2xfgDP/adhxIMz0G5V9SBB8q0QLskorzTgEcUOZDeMjX03l2vGG
	CdOsLatil5Nj7AcXNDYKSJQJ+KVBuVRW7u8x92HuHx1Hx9pwyVOf/JeUAOeeb0DsKUzC6u
	Q9qCFQgK/jR9wNj8RdQn2o30bsWj6Qo=
Received: by mail-dl1-f74.google.com with SMTP id a92af1059eb24-11b9786fb51so19711077c88.1
        for <linux-mm@kvack.org>; Thu, 08 Jan 2026 22:06:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1767938783; x=1768543583; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=VJ52X8DJw4332ZGcvwO1T13NvF/pxnQEOtkap7ms7B8=;
        b=b8kmYxM7pxEhqX3jnMwdvvtOMV1Ed4TepZVrexIWdOouD5QSgWEs0EW3T5IzMWzpeh
         +O8K/ifqMxbg8D0ZEvbFj7DGRy+ncSBmFpkGOWx7GG41Xpn/I7vVcSJin8ZTg8KkC3+C
         3bL4/YQsVm72HN/7JuTCuUws05ZHCo7wSdaFpi1UkFUWrVrFFx55zPy3eJRuR6PnEfGr
         t58P284O25xz16rAzycPZeIusCB95Xya7OSrwcTe3u3ttfluBdBTx0SNxkSXFQbD+LnD
         8Dz/7fFtr9RdustMtrAOnbL/Q5C/weZccQkBsSzZBrZNzF1nXi4qBsp3Uv0zRurJvLka
         9Ehg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767938783; x=1768543583;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=VJ52X8DJw4332ZGcvwO1T13NvF/pxnQEOtkap7ms7B8=;
        b=QEl+5K/gjeWMJaIhJOoYDqZtc3GRj9LTCUgMvFR+5HAwYaTWQ8ovmEGgjZt00/1IuP
         vKg5yEIpgVTLYZzPJGj6DLFtaTlB8G036qyjhBNAycjqArn/fhtnGm4chxtyYa9MjSZn
         FiztvcDTawS4+/kxYNhPYV59C0tfVg4ramexGSYDdm/2i00KEcYyF+PPvOqt/cDYRWRE
         +I/ZRh2qVSaReFjbdPJgekwuI9mDVRQBaVrRQBKQGOwBxID69bxhzKDNZjDm6btEniER
         MSie5p/MTPOhwNDT5DDVVq+UJj7yoMXLcjQUV+4Ji5rwEar3v+rSPWp0Xn1u0QaXOvlF
         Re8A==
X-Gm-Message-State: AOJu0YzXC4J2UmSzM0yzdELie0Mc07kiIEWJEsuTgpwInY0n6Cs9LH0y
	1kGAvPxmVZbCPifU+tYGPtwyhb99eaPsKUDUudBYXLfKnxJrvT34FejT1nuUD4eMYrlRhdd6mKy
	61dGS+1h95sihauZdhAypewONyTLCtZXJAM9V79lbxZjMCSyivROePpVrJkE1Qm/r3B2KE4sd+H
	9GhTeKbnFf3DuSJ6oiVhg4bMSc6Jbcq0Qca8FZoDCpsg==
X-Google-Smtp-Source: AGHT+IEycexvcYOpULS4uIaacG6moaZkSgb3dQTA8rE3yW1sudxFNh0OQhIfvC5qfjuWshh86gDgGyyMyAafWA==
X-Received: from dlbdd42.prod.google.com ([2002:a05:7022:aaa:b0:11f:3e3f:a2f])
 (user=bingjiao job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:7022:384a:b0:121:a01a:8e2f with SMTP id a92af1059eb24-121f8b69552mr8048147c88.42.1767938783235;
 Thu, 08 Jan 2026 22:06:23 -0800 (PST)
Date: Fri,  9 Jan 2026 06:06:21 +0000
In-Reply-To: <20260109055937.3739860-1-bingjiao@google.com>
Mime-Version: 1.0
References: <20260109055937.3739860-1-bingjiao@google.com>
X-Mailer: git-send-email 2.52.0.457.g6b5491de43-goog
Message-ID: <20260109060622.3742262-1-bingjiao@google.com>
Subject: [PATCH v1] mm/vmscan: fix uninitialized variable in demote_folio_list()
From: Bing Jiao <bingjiao@google.com>
To: linux-mm@kvack.org
Cc: Bing Jiao <bingjiao@google.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
	Wei Xu <weixugc@google.com>, Johannes Weiner <hannes@cmpxchg.org>, 
	David Hildenbrand <david@kernel.org>, Michal Hocko <mhocko@kernel.org>, 
	Qi Zheng <zhengqi.arch@bytedance.com>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: B3C3E80009
X-Rspamd-Server: rspam06
X-Stat-Signature: sgpseu5ocebcynbp1w4etn8s48chzioa
X-Rspam-User: 
X-HE-Tag: 1767938784-916612
X-HE-Meta: U2FsdGVkX1/eRbZcDsMXupvI/69HaPLN4leLhsi2nU/Cx2MDaV/mslqe99j9VRZ56HdOft4eVBz0xhmEPv66mUZKJUdwBCcSjhApc6FL62vJkM/VcHyfq5F2Bd1q5fR9kuARiMBY7W4/BQedythsmPYocpYHeuKL2JsCf7dfTnXH62Q90mTj2BkrNLiC4MBTfC75281ruAny2BFWbFuMitOWy2uq4werZEtpjiRFczauhtEkPUHy4tSrqZ1z6Du2NNn934GwrrhIy6PPRXtvBPFURlW8x9xIbX8kr2WvHvJVCiQRcs9KFQ3nrpWtWrZbiPKIK6IkTx+d59NrlpGSxmWKVg+Upqj14XJD2O3FzS3nN60qn1CeqB7Dg3gAEz40tHfhd/+3xsWvRzddD+7Jx6lZS8ln9VCPU9m4om7SqhKuL/JYQlWZBDhzDslQxutDi5NmX/kMoShoc+dMWNPRT5CAhtUOo0r9nmBUunJyn/bJIvSx8ljmqo7LRxfIgI5aDqwvfPGqCY9EVTKzsUlZOiMlPktPzUWzLgBNCcJ4aZ7ASAlEgZQyadOstJVGdnZJujsGJmsig3JKCH9qJmvD7NSKFw4YGZQ+0ptKaNkU2XC4H+hxTlto7AMbhi0nGv0NwGvGnKsUtetl4A+vDyc5f8JR77Pm6wevbesEDnzceZP3X9p693QAHrcHerUZwitiMP1vP0hQn5SkoaJdQ9nbTaYjAnYVdWWqEmGcExrbLfQ7ry0OmHEF3zbWjvjbQjJqMnSe4L/HmzZjRNy9HY+wfFYwutvnEQh6zDETkLXTGarVMYa6ZO/yjfvUjaNBsugFfR5z4QpTEVz8LA0pTfwAnjPP0ONvW0XUeIGlZkkI8CuU9m6vf0BwyXsKPjcuvtkoyd9+KraZ6rVE0mrcCzWmeZYUHKDX4GoYZt2MG0baiFxHTSRfJqVADVl3gyUt39YEA7hoA/iUztOutcCZGMQ
 5QpMEOCG
 kWvD7n2mMIovYdKr0ZfgqYoFfrYYT4pw1jCQhsrPtbpMNOPZvNwkzFDbXyJJcF2bJsRX4RjxklTOIr5JKtn/j7Z6xIpiuTiQNhFo/Az5fT9KQba5HDhvNtS3bidZNr7lbsxyMaTAZHh3EQB5qN0qxtc/q1Xg7AlMNlprmMx4YgOt6Lm4w37DjiBKGL0RxBlAM99/Am9gS7pSwTj5XnKQiu3sjhbynUgBn05KCaNeqlhHNNZs4g//WPlzz0hIrh1PgJT5ZLEMIew32Hi8Auo3Er1qtk6N96FeINxTij343dpgeXPukrfC6SI3sabwhOYOKLblgmY8fxBmQ/CQhpinGRzqWZci6Xlya+gypfbxsgsGyrzwxrEhz1dALSGBicCiZOnU+yEeA2Pjo+hp3DrdDpAHpQYdqtIzf0f22wjM2JZJOLUfOjUCfS29qviDzf959aYRvMZp8vQG+1h9+5ibxxCb3vGDDj8PUQ5tY8Hprhr/3FkHZ1SbG9ZZwMFCzDqB8pAXovamNIyOMuTKDndGEJbp1AtGo8pUccoCLiuCuA3cEkWCu4luyZnvLRPLUJdiIypSK9jz1fefvo4PxOd5ef4LiA0hwY44DCP2zQnVsJeHECcuhz017yhTlzU8shHWL4KiP0A2HraWHdzcqWvZ4ztsijhvSLTLUgDwAZX1mgKUkvk5voZm5QuTqPQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Commit d92027a5f30a6c ("mm/vmscan: select the closest preferred node in
demote_folio_list()") refactored the selection logic for demotion target
nodes. However, it removed the initial assignment of 'target_nid' while
leaving a premature check for 'NUMA_NO_NODE' in place.

Since 'target_nid' is now assigned further down in the function based on
preferred and allowed node masks, the initial check at line 1046 is
redundant.

Remove the redundant check to resolve the compiler warning.

Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202601091037.vUSHeJCH-lkp@intel.com/
Fixes: d92027a5f30a6c ("mm/vmscan: select the closest preferred node in demote_folio_list()")
Signed-off-by: Bing Jiao <bingjiao@google.com>
---
 mm/vmscan.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 213ee75b3306..590ab3ec1998 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -1044,10 +1044,6 @@ static unsigned int demote_folio_list(struct list_head *demote_folios,
 	if (list_empty(demote_folios))
 		return 0;

-	if (target_nid == NUMA_NO_NODE)
-		/* No lower-tier nodes or nodes were hot-unplugged. */
-		return 0;
-
 	node_get_allowed_targets(pgdat, &allowed_mask);
 	mem_cgroup_node_filter_allowed(memcg, &allowed_mask);
 	if (nodes_empty(allowed_mask))
--
2.52.0.457.g6b5491de43-goog



Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 934EAC61DB9
	for <linux-mm@archiver.kernel.org>; Fri, 28 Aug 2026 05:30:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9F6416B009E; Fri, 28 Aug 2026 01:30:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9CD2E6B009F; Fri, 28 Aug 2026 01:30:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8E3EE6B00A0; Fri, 28 Aug 2026 01:30:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 6302F6B009E
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 01:30:19 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id EE8C91A038F
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 05:30:18 +0000 (UTC)
X-FDA: 85149552516.06.D73C9C3
Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	by imf19.hostedemail.com (Postfix) with ESMTP id 3879F1A0007
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 05:30:17 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=eCYaCU60;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf19.hostedemail.com: domain of lianux.mm@gmail.com designates 209.85.214.182 as permitted sender) smtp.mailfrom=lianux.mm@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787895017;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zjyf211XtRs0nkL10Qp9VSObiEIsDLFDi9ZSA9jafOA=;
	b=aCfARW+/QcHk9myxju3QMNLHSgb9/jph6GJ0V+SXMDbplWOYhuMKSBk65ZajBrVQOMgeVp
	eu+sCCemn7m8khjhFzbMb4NLlnE90FpNyStx1snNZdDBO5QGcXJb0PasPedSZtxFMRBil+
	xFS5091gU2b1CX8KFxPf23Z9YMOnzc8=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787895017;
	b=FzvNKoPARD3fgZ0c1ekCbJ6G0jDBg9dNHJA+TRBS+0wrC1OCbzuLNgVKE8psj7kAGElsHg
	cP5nz0UW7900z3vz28xhrwUi/LekRV8kkecLk+Rbq1/5MlhEStTlqbjzRjY0N320olaP1Y
	X5ik8rioNggVXFUmWLLLy7yYcYw2kl4=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=eCYaCU60;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf19.hostedemail.com: domain of lianux.mm@gmail.com designates 209.85.214.182 as permitted sender) smtp.mailfrom=lianux.mm@gmail.com
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-2d5335cf904so5930655ad.2
        for <linux-mm@kvack.org>; Thu, 27 Aug 2026 22:30:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787895016; x=1788499816; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=zjyf211XtRs0nkL10Qp9VSObiEIsDLFDi9ZSA9jafOA=;
        b=eCYaCU608Ip3/t47zucmKF6JB8LMq/gz23FnUet03tN6sWUMUrCdXg7ozgOpa0JIVD
         7m1rUI0pKBZjB5CDL6bw3zA+gP6xVlKHPhV2Lr2epBEQPlc6CDSc27WT3IfKAJGxzS9Y
         /QutJ8EPFxC9s0Cb08HSPeuBrJeBVRIsu8vehRTa4vN0OIe2YqdIcLIMyL2xBixjuyW/
         Ls9fiVM/Rro6cNDFd/FYsRd5ePUK8tDYfJtRntvektXEocGguICpeC1/qMesXFvLjI2G
         mEHSW8qOfkjMiP12UIeIoIm8hKxqbZqAeXk1LjIRDRPqynM6B8Rk4DxZMbPwkM2oIgaM
         O5Ug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787895016; x=1788499816;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=zjyf211XtRs0nkL10Qp9VSObiEIsDLFDi9ZSA9jafOA=;
        b=bH1YMcF0u/5ORz4CPxBeHTaTHfYnwQ77BKGTIHvZoE7qAr0MBKPUP8b82s7rI1Lc7U
         jIeEBDSwEaGUGuqW37gLMqd+/uEmaIObQvDp3DD2M002awiVJJCJ98f/POnTWe+qes79
         ngCRLYwr/81aiVGegR16CDy+7gFNz4M2oCQWJXGU7WtuqIDuoZLm2CuR+xMvQ8GxVE50
         yApKN7r4Icr9qB7wgOYfI+HjnoeHkcIh7/bdiDQQOcxC2+i19t3ycFkBwe0AHfjh675L
         vhhaK42AsK4Dfccd7SqyaRwLvVIF5lZYEOzrJT21IeLCRUMFGZh6OWg4mjxW7T8fI9qU
         cKFg==
X-Gm-Message-State: AFuF++ms+ijmRzIXLyC+uVehr9RExVI34h58/xK78/r/TmG3XodH4SJ3
	mQ3ZrkUCvPjy5cL2Y9IvJ11Rdvrt5aZjYINPYLnoid9pgFky+WCNQze/
X-Gm-Gg: AR+sD12mdn4tDCWQ8AfJaZO9ok/c6GlZBQgn2qm9jbyZmtEV5CesFVcwsjO9nsyuvra
	In5DwXX+ZC1aO5X+44Gvtu1TXt3VJIjfklC+DNBw+REd/TymX//bcfV2bBeBZcHzWt/Mfxdx38a
	GP/c21/xUbHXiX7Br+iA5hYSeHhU4fx6mfWYVS/PQujxF00dLeDkF1PrHfyg/9FE8eWPUvSHqEc
	tFKCZjYVZnlBZo9mY4gtyqxlapNbZMB8qvrNixdeu+BCneqr5BcFv9gJMtRu/9zfTPt65f8N8oY
	RmJMdc5S9bJPjXn48w9S/FEHdPCzdyn/1vaDppVcMjugYcQsv+dZVptmstZq6lmkq6WZ4tydAol
	u1n9j+eQM78Zr6Fye2lDvRD2/sh22Mtxw558Y2rH7dmhkm3+B3lTy4uMlM6v6OKzHGs5fW5GSjT
	9597qvf4R396iiMcmi+vXAPlG0VAo11DYvJwMSPR/AmsfgKtHy+FX2ma0FV5PnodwKWgownj/lk
	fnizMD/DdINy8A6LbdPCb7V3Og8
X-Received: by 2002:a17:902:d591:b0:2c9:deec:f564 with SMTP id d9443c01a7336-2d74df52c1cmr1686825ad.13.1787895015897;
        Thu, 27 Aug 2026 22:30:15 -0700 (PDT)
Received: from localhost.localdomain (vmi2317720.contaboserver.net. [84.247.152.65])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2d75988cb5dsm2170415ad.64.2026.08.27.22.30.05
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 27 Aug 2026 22:30:15 -0700 (PDT)
From: Lian Wang <lianux.mm@gmail.com>
To: Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org>
Cc: linux-mm@kvack.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Barry Song <baohua@kernel.org>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>,
	Wei Xu <weixugc@google.com>,
	Baoquan He <baoquan.he@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Chris Li <chrisl@kernel.org>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Ridong Chen <ridong.chen@linux.dev>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Yu Zhao <yuzhao@google.com>,
	Zi Yan <ziy@nvidia.com>,
	Qi Zheng <qi.zheng@linux.dev>,
	cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Kairui Song <ryncsn@gmail.com>,
	Kairui Song <kasong@tencent.com>
Subject: Re: [PATCH v3 5/6] mm/mglru: use explicit tier range in read_ctrl_pos()
Date: Fri, 28 Aug 2026 13:29:28 +0800
Message-ID: <20260828052949.52874-1-lianux.mm@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260826-mglru-flags-cleanup-v3-5-d9f1c75549c8@tencent.com>
References: <20260826-mglru-flags-cleanup-v3-0-d9f1c75549c8@tencent.com> <20260826-mglru-flags-cleanup-v3-5-d9f1c75549c8@tencent.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 3879F1A0007
X-Stat-Signature: 1ceri4m9utd47gqqesg6ghkmhziyokxx
X-Rspam-User: 
X-HE-Tag: 1787895017-319804
X-HE-Meta: U2FsdGVkX1+uf6PMKlNZr1CytwnuiB3cKrgEDrWTZLihgyUkWxKIA6LZyH4woQ9KYsxpAe0si8lcv3rT35vw9OP3aB/Hg2n0iPBJtzPuNHSbtHiNs13n5S3XOxQKylXGez0skkXFueuf1AV8PcIPz+g5WewcgOpyH0eTI15HtjGQus1sMn5sejFwjDmu+6YySNSDAxHVdvSfbGoT/Qt7x3NvQtojSsiqmBrNxnulC7J+slL/zYfpyNkhWXn/SkgwdzPx84EPTihf1lhahAH3x/vInWX62R7VAjWPbrQ0mxb9radU2pBZ1sKVJTEMV7rsySClzSTWyisNgMg9PisFJLbFU1PyEAcexLj0cPI+W+lt4dwb4VrjzwEwwbkXpVs5+b3OijUO5DBJgVYefBcm6Rx3R1KM2jha4kNG5H1B6lCpJOnRi5DsmNFfWQqifYhogonxS6m2dTv8xPUtFBFa3nPBnqRS9gmGRsyCPre+QFyrRaQkbYzxLgbL4K6+DykdDborTvd9pL0eQDAQRtI8WWCB7HVlC+LJ/nJm8Z4QKuvEmTDAI9IKShAcp3a9dmngua3VR6TkcjbE5neKjmRO5yQIYjSBnYowXxlZw1PnajFmJkdh8CzhOoccJ1PwsSfQ5826egkZ2ZGPX1gwasHM6bisxNF5hc5v649rheHkdZSAm43zqlLUKgpkdL2c/IpOQx2yL6OagvlTraTI29Mi7em8ki4YLj4w7lFU8/un9vPBVu5MZ2HbWveE8pD7VSmUblr+gpeJCJELGUnCMy9DnrUwD7Mm92KGtWPf+DuiQKSWVP3XAqgmgd6STPzuK0fot9Aw9Bu4u+q2ZrH3i+LQsMG4STJCUQJV4NEzYGb2TtFl1dLBkDB7RxjRZC6WTb8no7GHNdrPPQIWpa+zM2iWdtoZy0EqEt3graffYuvVLLUD/8yP/r0tYWWnuZVDjixpnTeYP+WQjP5gWPjBfj7
 FE1GJC5G
 e1JqiNTp9GRZ67tY1DdJizzitmIfDFOimEySaRSTuPhBbPQX/4VZ0PRz4cTPv6/m2AamXms7OzVQszhL82u/g3tNxOdPpgf+k+2nsYH+BuPwAB6pNLUk7ZYwESEmAW44LZzOeQw6glv0BBJMYUYaoD3nSuVpENajUprdep8uGFDLKQByRmXjrlHuHeIcsF9I62WbgXBqIsNDaCrqON/KMCOuODhjvNfIYUCN0lgWD8DUc+jfuVeGXhVIjgF1zV8/PyISJywqLKCdrX+eBImvdjIIb2E/hLm5Pgnh9rX+EilYdIztaLXRe0j4USch3/fHuwj5HqeqXc+ra8WkCkJmSP5AnFk3Arv0Eq+yTxUeddyN3jVAmqm0ClhX8tDTbBPkhbjVAfoNx51GvBOzC/4eQhzqiQugRB2uQ53oGHDDkgBYgQ+/DaSd8vDMRBWnCnScqWAggHMGaqyyWyr4MpAgb+YobARwv6dzBXFBB2MeP4bsHlpjixMwXt06k03yFb2MzSq33QKRb7zGny/JkqUPzqj8xLVr8e01RHOPCDKZAeH5K0814RN77Ni4UyRGy3o7ES9YM
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Kairui,

> Replace it with explicit (tier_min, tier_max) parameters using a
> closed [tier_min, tier_max] interval

While touching read_ctrl_pos(), would it make sense to add:

	lockdep_assert_held(&lruvec->lru_lock);

All current callers run under the lruvec lock. read_ctrl_pos() derives the
history slot from min_seq and combines avg_refaulted/avg_total and protected
with the atomic counters, while reset_ctrl_pos() rotates and clears that
state under the same lock and already has this assertion.

Adding the assertion here would document the snapshot contract and catch a
future lockless caller before it can observe fields from different history
epochs.

If I missed an existing lockless caller, or if this is intentionally a
best-effort snapshot, please ignore this suggestion.

Thanks,
Lian


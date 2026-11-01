Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 24AD9606A329
	for <linux-mm@archiver.kernel.org>; Sun,  1 Nov 2026 20:23:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=iQ09DlIh
Received: by kanga.kvack.org (Postfix)
	id 382016B05B3; Sun,  1 Nov 2026 15:23:01 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 359436B05B5; Sun,  1 Nov 2026 15:23:01 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 248406B05B6; Sun,  1 Nov 2026 15:23:01 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id F23976B05B3
	for <linux-mm@kvack.org>; Sun,  1 Nov 2026 15:23:00 -0500 (EST)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 9596F40B27
	for <linux-mm@kvack.org>; Sun,  1 Nov 2026 20:23:00 +0000 (UTC)
X-FDA: 85387674120.10.9485DFD
Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	by imf17.hostedemail.com (Postfix) with ESMTP id D098F40005
	for <linux-mm@kvack.org>; Sun,  1 Nov 2026 20:22:58 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=iQ09DlIh;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf17.hostedemail.com: domain of rientjes@google.com designates 209.85.214.178 as permitted sender) smtp.mailfrom=rientjes@google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793564578;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9AqbH8327lnwvg1LioWgbD9Tcq5AbImAQbsNTXyY7Tg=;
	b=uNwtJOILW6UozvXO6mw7ESaTvTZywzAuqbyVViota8/b2cJElGEfna6umAe0Ovwi5VUAVM
	icmMGZgcy30tuLOIJf0YPdUxbLWppr1dZ62WdMbQG48b4m8NUlc9Vc2R/CCDq/PyCw+k/M
	YQVGEHvpcIFG8UyG1zv+sOwu5RZ92yc=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=iQ09DlIh;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf17.hostedemail.com: domain of rientjes@google.com designates 209.85.214.178 as permitted sender) smtp.mailfrom=rientjes@google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793564578;
	b=5wgVEL3i+7PWRyOlig02cuNymmaUvonuyvybrpoE3xkVEkTlWV6i2A3gAMhF7hJxUGlWLM
	XyqO4hIzFsP0OGjgmaHqnYhhwo829Vmf3CRGK8j7+j468OXZAhBY97oLaIpv9dIONM2CXD
	ApCrznuJTVBbtNW9VNKBYdj3Sf4N3Ao=
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-2e8d6fcbba0so41825ad.1
        for <linux-mm@kvack.org>; Sun, 01 Nov 2026 12:22:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1793564577; x=1794169377; darn=kvack.org;
        h=content-type:mime-version:references:message-id:in-reply-to:subject
         :cc:to:from:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=9AqbH8327lnwvg1LioWgbD9Tcq5AbImAQbsNTXyY7Tg=;
        b=iQ09DlIhQ9PtlVQpaCligizJbUd9FvNq50u5YgzB+W/2+14Rg97BJ33eb9Zp0oc897
         oYgki+qLPKULsKLC5thj/gu1JhZ7RUOiLcOdSYvizQMlShTxPcgMCY+GcIS/SBCsFLnk
         a2xyFQcYSUxx836q2FxWgB5pR9KW+N6VDAuPZvSQxPX8F2dcwkZ8ogx4+TDboYzJtqiZ
         OqAHQp2kHpkbmWqZ4PiIe8FOx7K6M4qTpjiO5+RIueJRuTIaJ+y3lo0ZImvfre8cHuoo
         357UuKvWScPGOf/22F1zz0n13m2xTVX33WiyM9KkZEuKFNay9+6vlZZFYBAgqwO3HYkE
         YndA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793564577; x=1794169377;
        h=content-type:mime-version:references:message-id:in-reply-to:subject
         :cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=9AqbH8327lnwvg1LioWgbD9Tcq5AbImAQbsNTXyY7Tg=;
        b=QYMWhe/c7YVEQ2g/ax8PFvR6DCa/NkaU8Mw6Fls0fmSfkcceWRtrBX5IL74meDxyhA
         Kwa09gx9rDCdMq4Gr8cCttT8ICy1J61+grdgTOxlXpL2Hcb+rqrTkqKSzfeOn+NS8NX5
         DODHsXnuuvO3uiPEP9e1nOZGmA7INjX88KE5dyyjGZhoMyNhmiVGDfK7bIq9QECdI+KV
         5cn/58BtDaqhf1dM3BK+0Qz3UgbAXehuDYm3MZqIeQNlgY/lY4iKdlN4FgAVlPO6LuSL
         STDg1NK7tCpVdHheU4bjI9bU2HikGaX2My5iVV4/hlc77hlVjwNzMshrgD1A98jKadgt
         EgPw==
X-Forwarded-Encrypted: i=1; AKwUvBzt+F48yRJ//OuD8mBgceERAlvtl69d7PA7+W9SVduk/IFf8oowinXXbaMdBvHAH1E9aonuXay4Iw==@kvack.org
X-Gm-Message-State: APuU4Z/6Otb4G1bn9gbzpPj8etYgT3NNWOHeuaCtno1B5++abRlfMf5h
	uGJmFoAht1nRsd3Sdr9MTaDwBf4gLO7wrAXHANdQHXlOwKTU23FxEGHv835JAZ1UEw==
X-Gm-Gg: AYBFou3hbkPXa/PdJOAqyua8fQxmOFGt4FS9Bhvok3Wx1MCTFDkltg+GAayt/fQz36a
	ua8itEuUvbYFYp9XV+orMu0EQ5NmVD0wdGyLiJK9FRDDiTDbGKMFVDTbFdSVKb8KT13C4CRcLx2
	Goe4ET/jk5jWkOgayg7v6rAs+XC3Fkx3xJ6zjLRzVaN4EHtzhnhrz72pHkOr3jvL6EThs9kKJ7l
	muQpbmSU4KRQizEgfJzjIVqz+gBZou30SLpb+HVAt65Tfw9bkqSAL+mJ/0mbxFUJBSe8+k4ng2q
	RjSqDSy4yE7Nstivftr546E9wXc7uBQEaQG3iVovFegtooulU+4LRKty5GvCGZzX2QqwXmC9FZ3
	2ZUgOqBLpcYa0gfndoSfE8wH/JCLHewaNjfOcSNwdHsCescKqq/eUkVF2p0SuRCN5k+tq2+rzo3
	0zDrqzl9tf4Mi6qrQbd/VdFrEm/NfKuFqvcfaORityiYbssThCy5ybfa81LFaYODu7C10abZtwW
	WRbBrIfjJnPj6vas8Z3zAjKz8cnQ5DINci1TVFQ8S7ycxxuwAiVh9J4227grDrJ4GD4i8+m2gCb
	QpmY9gmBSXUQLsU4/euosdFLwyhhwss1NRPqySGAo9/A/JBv926dETng1auOP1+BTpdUV6ytNSR
	J0MMxQkaYu29sSX2W615yihaY53KcdeI7JtgIh7S0xU2mv8QuUzSZ6CkypjhBjtwz2JiJz58f26
	WRGnmSGNms1ck7fuomxiEpTSwAYokTH1k3TN8/Yhw5ntI3
X-Received: by 2002:a17:903:2acc:b0:2e9:73e0:2a6e with SMTP id d9443c01a7336-2eb019ace41mr24556695ad.17.1793564576851;
        Sun, 01 Nov 2026 12:22:56 -0800 (PST)
Received: from [2a00:79e0:2eb4:9:6dde:d2a6:8d93:5cfa] ([2a00:79e0:2eb4:9:6dde:d2a6:8d93:5cfa])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3ae8441a5ecsm11128450a91.2.2026.11.01.12.22.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 01 Nov 2026 12:22:55 -0800 (PST)
Date: Sun, 1 Nov 2026 12:22:54 -0800 (PST)
From: David Rientjes <rientjes@google.com>
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
cc: Andrew Morton <akpm@linux-foundation.org>, Harry Yoo <harry@kernel.org>, 
    Hao Li <hao.li@linux.dev>, Christoph Lameter <cl@gentwo.org>, 
    Roman Gushchin <roman.gushchin@linux.dev>, 
    Johannes Weiner <hannes@cmpxchg.org>, 
    Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
    Brendan Jackman <brendan.jackman@linux.dev>, Zi Yan <ziy@nvidia.com>, 
    "Liam R. Howlett" <liam@infradead.org>, Lorenzo Stoakes <ljs@kernel.org>, 
    Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>, 
    Mike Rapoport <rppt@kernel.org>, David Hildenbrand <david@kernel.org>, 
    Gregory Price <gourry@gourry.net>, linux-mm@kvack.org, 
    linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 2/2] MAINTAINERS: move SLAB ALLOCATOR under MEMORY
 MANAGEMENT
In-Reply-To: <20261101-maint-page_alloc-update-v1-2-27e8c246b13d@kernel.org>
Message-ID: <2d819627-1f3e-140f-81ba-626d58ff917e@google.com>
References: <20261101-maint-page_alloc-update-v1-0-27e8c246b13d@kernel.org> <20261101-maint-page_alloc-update-v1-2-27e8c246b13d@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Rspamd-Queue-Id: D098F40005
X-Stat-Signature: b7s37akthatfwnrddkt4mcrbsk9ybyjf
X-Rspamd-Server: rspam06
X-Spam-Status: No, score=-18.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_IN_DEF_DKIM_WL autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793564578-925076
X-HE-Meta: U2FsdGVkX1/B6YbUHYzARPhb1xDwh40Sbd3fhgxLtoyyf+QRHBQehOSloExNaJCXV9t7DCEKMUKHf7QVtedYd5QNjmAlYhVKfJfZxZiol+7BPPJTZM9lHQQKqZNy7ZJGuCxANmphYHWHticX6ATR8Dd+z4IgwXmcNVHcXbwqs6Witg2y8/9Wp3HUY2a2A5+acyPDQKOEbNSzAZSgrYl05IqaqF5J9sF4HpvmLFqjQobndQnoiTESFm1thWHioHeSwsR/htmTa3sLmd49yvNUHQtH5nbphBiYYg21oMksiWqP0l66JIFU9DtAw47FkqG4tnvKgogaGwCLHi7ttHNZkPefcvIeoz11tRzN2+88AAY1fsFsYUZ4Sf4Rc063Mmo4r9CwGGP34ZipiNJvTIq2ebmI5txkViOP2RwDuFLbWVzMICvVRyDUqQN+1/I3hhrbyB1t0oGD6TXRwwIgSOomNvh80phS+JW+UeFRzQOMjCgLlY/1BeWLqf3esy4dT1WCXhMntqpNxObC4kO5AqkCbqOxoL5g6l2wW2YGnzScD7xG2JSsCWtxRAIo0l6c8TwpkkMyGnw5OLPOI5jPhbRdHfAhQoBV6f1fMrrrX5ed8ZFo1WfvsLUII1jvTXc7dTOq/fGjkGBofqe23Tb5dabq6Y3jHZG8ZkBeOWuJDGAb1+3bZZzjf2FUZiQmt+mo56k9K5+osYQ66YkkYqDhyX4BnkIfCL/MRJVdpk5Mg3/4WI08N6J09Td1a1d/Kv7MBD8LpZI3PLleVl8ReOLrX7cK8KKhL7+t245FnXX9D8hmg4ziaogBF/CkSVn6bygtv1T/zBD5WKap2MN5Ots3yUBKEQ8xq159r/gYFU06xBe87zqF6Xlqrd2gRoTtYsbhB5vyEO08/2YEWZ0KnI1xijcfDxFXiIQFNi4kGcO4IYfui5FUMcc1JYIVT3AyiXudS+TXxysbkgmkJ8Z6t+QoctC
 5JhUMyGG
 ERtS6swalCIYP06sl6taq8hiXWpx+zvcHrRYZuz+VxzazCMA5a6v2JChvhOocC1rK9gr4OSU1atPA26m0x6FKcB/4stl6GLbT6uL3T4xGufPUbpj5nPp6aJ9rYhNitMw41C22KF3nFoQFsUWiDcTOH7alw0jP31BU6Dpnh/7YEg2kAj1k7PYzZvdoaQh5n3dZ4sjOrAjA2bLK4Je1IZ0MQsajrXElKRnc4RjvREew3XbDYDFypnuA7c6Rm49dIzjkeJYYaRp70pANUBQUCB+sU97iz6+J+e3Bh3+ZvE3rik0u+Dl+vxxJ199MpWZxthCU2hTFJZwDP+ex9uRzc182fV235PcLvaaYWHtoV0P2reHPuhWoXNfBw7cfW471pgx1cw1m
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Sun, 1 Nov 2026, Vlastimil Babka (SUSE) wrote:

> Following David's consolidation of several other MM subcomponents, do
> the same for the slab allocator.
> 
> Rename the section to MEMORY MANAGEMENT - SLAB ALLOCATOR and move it to
> remain in alphabetical order.
> 
> Remove Andrew as M: to signify he's not the primary person for picking
> patches in this subcomponent. get_maintainers will continue CCing him on
> most patches via the catch-all MM entry. David prefers not being added
> for mail volume reasons.
> 
> Indicate the primary integration branch (slab/for-next) in the T: entry.
> It will now be integrrated via the mm/linux integration tree.
> 
> Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>

Acked-by: David Rientjes <rientjes@google.com>


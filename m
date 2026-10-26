Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5A379606A31F
	for <linux-mm@archiver.kernel.org>; Mon, 26 Oct 2026 20:23:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=ctFl4FCF
Received: by kanga.kvack.org (Postfix)
	id 794FD6B05B0; Mon, 26 Oct 2026 16:23:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 71E446B05B1; Mon, 26 Oct 2026 16:23:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5E5956B05B2; Mon, 26 Oct 2026 16:23:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 38C7E6B05B0
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 16:23:42 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id ADE8240870
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 20:23:41 +0000 (UTC)
X-FDA: 85365903042.21.45299B2
Received: from mail-pf1-f173.google.com (mail-pf1-f173.google.com [209.85.210.173])
	by imf27.hostedemail.com (Postfix) with ESMTP id 037E040005
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 20:23:39 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=ctFl4FCF;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf27.hostedemail.com: domain of sidchintamaneni@gmail.com designates 209.85.210.173 as permitted sender) smtp.mailfrom=sidchintamaneni@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793046220;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=bKvNc5FHva93Nru6Wk+U/7p4AvuTN2mzzP8feyVue2g=;
	b=2jjvZHZm/n0u47TyQRNHs4q2dE0/+Vsib5P/18Ih3XVcdo/u8XifT5Zejfssm0FdwqO6Ap
	Gox8TZZzg5hnj4hvKev4NR9GQFziEoH4GydqNVNcWWR9/V+B4m88JPJiLH8NLLV3CJt1GX
	YPmQbhJWdh8dLgdO68u/CT2mBUCvwUg=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=ctFl4FCF;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf27.hostedemail.com: domain of sidchintamaneni@gmail.com designates 209.85.210.173 as permitted sender) smtp.mailfrom=sidchintamaneni@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793046220;
	b=1cYkyGmQmkr1lenElPEhsqCAcaUhXroXdvImjZUUZUcSyghAbbhGEP7mVY57w7nVLY0Nw9
	SFJ23xjCVXWhFCUgqgyR+SJu3+OwfsGWQw69SXBjCLDU2/uTudV0RCl8ITnAFFvv9X/juQ
	7v+WVVDXW0eQ3Yyy7ecJhtSLKzEzgvA=
Received: by mail-pf1-f173.google.com with SMTP id d2e1a72fcca58-8a0880a46e7so153433b3a.1
        for <linux-mm@kvack.org>; Mon, 26 Oct 2026 13:23:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1793046219; x=1793651019; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=bKvNc5FHva93Nru6Wk+U/7p4AvuTN2mzzP8feyVue2g=;
        b=ctFl4FCFw0R7Jp9MYQqyWNS2jL6w3aY2HYloaItgRq3U8fNVUwvhB8XfF+QCeQOTL8
         ehl//8CicxQF8L9xHjNusXtdd+D6FTP3i8Ncye8L0v1tZoW2Kt5Cwje5phvtnIt8ccPl
         576vkDmnIdb0R+1574pGfusf+o7SoifJXWUTU8SnmORs7NeETzrwKuiaefZKXIDSRj3N
         fusw7n9m5vwYnAuKMzkhWXu3pQ4QRw/FCPHCv0yhfLWPbhecvTl+9c6Uj1Rm3HxavYl3
         F/rpHKhBjKClfcDZ217pGjjojjVF/bQRuKfvqhb3VARUhUC9eHvj94noFblue1kMxO8L
         HU5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793046219; x=1793651019;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=bKvNc5FHva93Nru6Wk+U/7p4AvuTN2mzzP8feyVue2g=;
        b=NDjAJ78RmCTg+JvoLLivAEbZEhGsztwl+3frKRO5xHxG7KffTkzMk6AUuGr6h5BKGh
         sSOza5x8c0AKRDlJ5mbe58PEwT1KXUfxeb0idSUK9GRcs4ptA32TO+hHRSONfRQnn7YV
         1HbOwOr78mop2zLT7upSLACYQ1H2ZM1KhFUuxpSlQJDe3KMgucSd1sILV2OoMYeWQTKV
         B/9lJnw/q5DlyBAwlV6w3Kav3G/PS27lOAoXIUuDc81RXYsWXC/ZOQ9pS8lXSUMmSWrJ
         dy92yOTSKwwkaPtvMszs7etguMQ9qetsW3eZq5X8ZP3V8SGQuXbRRUHQVra1KEueYcNj
         q6vg==
X-Forwarded-Encrypted: i=1; AKwUvBzIL87cAlrpI/QZKG6lNfLAyJTapvuoUnwnfLXEtM8akKKi7rGS+a+wTuZmvHpcC7fZJW0aEzz3FA==@kvack.org
X-Gm-Message-State: AFq9FYLu7Rfe9SN+SXsWwCJXrwynxhEZ6bUivANGrmi61Mu3k3drsfAt
	AR07YYxctBxhqwxyC7LccrW+zjOgtgdcSQLKGaOU1u6ipXLvKR2igR7l
X-Gm-Gg: AYBFou3uFgq2PguLnMoXRerdp/3fJBlpnSJk2GLNDlHItUXIe8PwYN1Gi7EDUZSfHdK
	ype9nNcm62i56koLptpHiNK80/toy8uNaj7xaTDYdJEhs8tylFh7MX0Q0mOVPGhAvzfqF+5S1aM
	x3yOJvZPGWK1nNEpZTqfsuXwyyLaYk1gTIXk0fmeyzwfoioMtYfWrdmoG6f0D5MWm247SjoqrXG
	1fqd6KGO9HeLScQMuRI2adzLve79u3z67iff4xjZVbsduPQ+YnsBHGApps2NI66zuwIhtk13aXi
	AHVSQvtqeqEvMHlvzl9ecv8XpCayDAn42WBnZRypt1Wt7r1N3kD3L6osG2zjPmtT6oY1AAPBPmy
	yhQz8FUG5MYPnk05IxNAhVUluug7/C5Gb2Dl5aT4LIXuiTEj/Kt9JdTns5/4nAPrUJo0lrgnEaj
	zNKoaNAp1NlFNKx+Owf32IYPJzENT7A+201CCGJReDNX5/qUdrYay4bN//MrzY4Siju2vUAqxCH
	pjaIZnSkfyc/oNe6bCB8zPJn5fveC+RdII3vkEGsSGZvDf8WjMnsyng/p1ZPw/zGCPKOwpPrpaI
	GVoQtCBJ4ZgffZfQ09BfVgwXSF+87SrKgfY4RoCCZFmte4orSbDkEbrrkcgrfBS+Jz890SVGB5B
	FoW3GLWPNA0aVG4Mn8G4LU/+pzmnpeqYgSb6+dn0BEPo9TI0lKMTluhlp+R3byjSZDnQ=
X-Received: by 2002:a05:6a00:b46:b0:884:831e:d0e3 with SMTP id d2e1a72fcca58-8a5a601c56dmr360543b3a.17.1793046217922;
        Mon, 26 Oct 2026 13:23:37 -0700 (PDT)
Received: from sid-dev-env.cgrhrlrrq2nuffriizdlnb1x4b.xx.internal.cloudapp.net ([4.155.54.158])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8a36bb29546sm1627846b3a.33.2026.10.26.13.23.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Oct 2026 13:23:36 -0700 (PDT)
From: Siddharth Chintamaneni <sidchintamaneni@gmail.com>
To: akpm@linux-foundation.org,
	hannes@cmpxchg.org
Cc: david@kernel.org,
	mhocko@kernel.org,
	qi.zheng@linux.dev,
	shakeel.butt@linux.dev,
	ljs@kernel.org,
	kasong@tencent.com,
	baohua@kernel.org,
	axelrasmussen@google.com,
	yuanchu@google.com,
	weixugc@google.com,
	baoquan.he@linux.dev,
	baolin.wang@linux.alibaba.com,
	yuzhao@google.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	apais@microsoft.com,
	rlmenge@gmail.com,
	Siddharth Chintamaneni <sidchintamaneni@gmail.com>
Subject: [PATCH v2 0/2] mm: multi-gen LRU: replace get_lruvec() with mem_cgroup_lruvec()
Date: Mon, 26 Oct 2026 20:23:11 +0000
Message-ID: <20261026202313.63122-1-sidchintamaneni@gmail.com>
X-Mailer: git-send-email 2.43.0
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 037E040005
X-Stat-Signature: ae351ejdpaeutouq3zzc8sojktqxbj5k
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793046219-923579
X-HE-Meta: U2FsdGVkX1/r8cKH8NLVK8IQsiwLNs0r2HYtAbd0I0qcmrNWV3uCqbq+CKFnPDdS8F5WUl7r+gKB1pRtzcLS3V8phxDh02vHgj9wAyBWAHYWQP5kM3pLWmu59sdWNoxi8LfR7CT6d3LV9s4+a9SjV0sZxFIzpLjBrgmq+IPcB0cgRXhlL0BMsXFhgI8yOyMBtLfsWb9MiizOG6hWjam/lueyYwU7h4OHkWkyT7ZXa0mA7xX622dROjd5NMvRP8JJYcWekEn386JRg0V9wxb4+gbec2nROSYaRVt2Tw/P6cFXicTQ7iFKwvNVU3DfCL3Ghr8/6AOqdnBTcdHhKZ650n4EybOpx/8yhPPSxmRg6rPWMUZYKSlKcFWactRGT1Z/hEIvc2eMGAsBj1aezpnC+YN133MhkMvWNdImsOwyogjrfJpNTBl2xZ6BO9MBkE1Q0cf6fksW9ukqi241MpyU1uhA2u7DBs6ZmyXwYbB+cl/UiCXVP1z/ftiZAIlHbr4XfeolaWJo6iNSfcdmZyWutGb/AzO4kbmnxgEvBQMjs7rZLYbtriBCqtUfQM0xti9ysKmUfp7qjfXQrHZxhj8/RpfHVd8qVxzrydYbUtYPzAOauE6I9OvDn2EQu+v4x11zz4PpHy92gz3ayiBER8uH44aEtOTMfry5SrI86wpfk68g/+MP1OBEgXWtnD7b59f/k5ZrrWg0A+jlmV/NPW+ON8HKZvDxLV+Z5038194n/GpYnAzvUBrHgDe3jhQj50+RaeRO6/pjWQur0ATjJBNT0LVBXauTSasN/O/X58f8XPlvcWJaZ/ccUvs6zGaPK6xSiPOIObwn6EeYLshztOicJkdE6I34QRvIFABPCQ8zC5jgx1aPV9YSXaWDh5KQMekW+vPC5jyS63fMFjrPfAU2jReXpIARK6/fNJ8SIvbi+TrqceXDgGlBj4HZW5NZSFs5LvC0WCw5vvTjjqh4QNv
 zPQQG+dJ
 5cMDP1ScUtx11hV/aHlXeWkw0PQXlv2OPpTi5ulivG8G3DqIYUqPyCklLcWW1VGcf3463acUsy3+iZyvZrSGmk5oRNr2y8yKL7JPbc8Q6wuX/pHiX+WrmW1O3TiIwrQHSqbuOYG/d5XCCuZh76H2YPN1sNflv/ARYgjqXjKYFmGyZ8ugsG1msQGmDszU3Qs6fLXnOzI+ZcYko31ReTI5XPpXf6jhGZiB9P3Iy5aWg0Mhk/bbL+085MR8KT7CXejwvp9A6w4Ydv2fYjQQ6J8rDUNkKBlTISfyjn2qL/EGmk/PGuI+AmRxaw4dL040O0zDo0MBUqaOc9aqNSEReYeT4TJNYHvcF75LKwWT8vlu0jlaL45pLAXWfZc6S40KLWMk9WKI0XUJUS+/Y0GW2wFzmY8wrKasqLLlIS+s4L46XHKUYLyrwapDLvCZ0rQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

This series cleans up MGLRU's get_lruvec() helper in mm/vmscan.c.

Patch 1 updates get_lruvec() to delegate to mem_cgroup_lruvec() rather
than returning &pgdat->__lruvec directly when memcg is disabled on the
kernel command line.

Patch 2 removes get_lruvec() completely and replaces all 15 call sites
with mem_cgroup_lruvec().

Siddharth Chintamaneni (2):
  mm: multi-gen LRU: use mem_cgroup_lruvec() in get_lruvec()
  mm: multi-gen LRU: remove get_lruvec()

 mm/vmscan.c | 50 +++++++++++++++-----------------------------------
 1 file changed, 15 insertions(+), 35 deletions(-)

-- 
2.45.4



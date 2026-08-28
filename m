Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B5A71C61DBD
	for <linux-mm@archiver.kernel.org>; Fri, 28 Aug 2026 05:27:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AD9DF6B008C; Fri, 28 Aug 2026 01:27:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A8BCA6B0092; Fri, 28 Aug 2026 01:27:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 97CF16B0095; Fri, 28 Aug 2026 01:27:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7119A6B008C
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 01:27:29 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id CFF7E140369
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 05:27:28 +0000 (UTC)
X-FDA: 85149545376.17.682E431
Received: from mail-pj1-f54.google.com (mail-pj1-f54.google.com [209.85.216.54])
	by imf14.hostedemail.com (Postfix) with ESMTP id 10225100005
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 05:27:26 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=ECRmPZCj;
	spf=pass (imf14.hostedemail.com: domain of lianux.mm@gmail.com designates 209.85.216.54 as permitted sender) smtp.mailfrom=lianux.mm@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787894847;
	b=DyCiC17GyIGUDekqCz8zwHxpiZWTQi6SAGCRiXoBK4EScX1PHqtBqTJoTWm4vKL5kQRDTe
	sDtFUMO/zrVljyIho+mbkKqAeXb2hgapiZCAEra76SBjJ1RDMezfl7uxQzkldrDfbA+zwn
	sVnoDVP1aQ7gtH/gj4elcdoqztFhDmM=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787894847;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GkKJcJJo80VBzccp6OY4nXGqipd1Y9XAJQzIr04BHjs=;
	b=UgmD/Rx6HFsGMqYu0Fys+Fl+UDmhZFIuBaZYLk1TcvWoNfPjB9v6XyMe3norr3jOL3SCpN
	vCghKugilj593yrAkSWHjC/ysDsx02E8UmcBw6+XOEeJy8YFEWcUdZt+jiaTSgjJ/ysRl3
	afiN7ucDM8wMWBNCAka7ltJlTMqNm7U=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=ECRmPZCj;
	spf=pass (imf14.hostedemail.com: domain of lianux.mm@gmail.com designates 209.85.216.54 as permitted sender) smtp.mailfrom=lianux.mm@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pj1-f54.google.com with SMTP id 98e67ed59e1d1-38e7109321dso562202a91.3
        for <linux-mm@kvack.org>; Thu, 27 Aug 2026 22:27:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787894846; x=1788499646; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=GkKJcJJo80VBzccp6OY4nXGqipd1Y9XAJQzIr04BHjs=;
        b=ECRmPZCjhF0xJHYgIH4mXR11DgcYCrCiCEw4abJAgJ1LyWTlT7ftfbeYfF/LWRCk+R
         rPRY7VE2xsHKRzKOo9fWm9p2xP2isxlFx6dL/72+xV67TtvJ7FW28PC0lbulPTiX7fh0
         GCxMlQqyE3SfcBGKcyrYWsnwN2WJt5JDoNF+xF/9BDdcyhCTfE0bWVf/FUISWktt6Kqc
         4/fQo1dyvARwVlV2fFI90AgFP+UXPtd68mzWHkGrdt9eCxY+7wasX6Fn8fyhdpx9cwa8
         aqTH0TQ2UmWZAzNGRDxxXzN9d4i5bfRBkFTW8m+QthmHQw4NSB92xPjASq8itp0dCGWv
         eQdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787894846; x=1788499646;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=GkKJcJJo80VBzccp6OY4nXGqipd1Y9XAJQzIr04BHjs=;
        b=G81a7andaRXIMEXcPbnji1rfeLdQqtURe+zQNo8dZQQk+xAtFybCgv6TuQIY/HUQyk
         WiFb0ilvm8m8kCVM1hhOJ68ppXRDHMCPbjXNzXKllMks0ebd0RHZMMgYIHH/4w44lPBA
         zIaG5yVCZwzsxJMVUCJEkG8PU6j9mfx7Fxf2RqfciSOmMoIx4SFT6amp/mlaOY3jzIDX
         PJnPqIya8+qpZLiMaAJz/CO3acQ6CsXXLt+vSod+gs3PmgJ1O+XFBFPZGQUflNLxDc6+
         +enbOtXKcfVqAt+p+tHSq8rjSMQEdt35oTwBCLyhWbcoOaOOh0z1rYWP8W/VrrCl0D93
         B39w==
X-Gm-Message-State: AFuF++mDacTgwKrRXYgoDOw9994fRJrquqR2JI+qxqT8pvuOqjt0Fx4v
	lgphLU0x1DX+TaVTrRRKw1X3r3GYE/f8De612k8O9Z6p1I9ek4FtozqV
X-Gm-Gg: AR+sD10a2uhFcPBgQj+RFXtKHAfNL1wtxA3m102jm2NuQLAbmb2NY8Ki8xFgJ+rqQFZ
	z555I00lze97r/Nei9n+n6sSpq+xExN6jiOVAZ1I1/Gq6xoqM6P5TMZSuPfWd3SzTpBcNBTTb1C
	RbdiNH+PWZW6YemHyuUvX8F6sUc3UoYaVezWC+6lCW6khYV7IvfyDxA4qNgV51+gJ2lLjCwRUCw
	8oBPgMvH2T6Fv1WvfATwytcy5eJCk+DLL7BzaPye8uIOrCpLosmwqvy4p+PUTBjtgYIz0E/LoaH
	wQg3tGqbK1hPRiXZ5LrNf/8KuiIjnL8iWC8yZ7VLZxFZ+7a7J4T0qy9Ur+zvBhZWDB9s4jcNvDT
	MUsYJmomvldgwSct9HD9dmhztF/LiYqzFQAbSaCFeITCUzpyKFafMQ8zsAUj46LVjQDPuN/7Wg6
	cirgXP5STfyeESISTKzIROU166RfUIheEs0AmMy/KK9ZFbrpBwlqz0TtlldhZXqp2TeFuyCFu29
	VDTXJBXHHnbGXdjFbysFZcoaM4yfBQNYvSi9uM=
X-Received: by 2002:a17:90b:3ec1:b0:38e:7168:281 with SMTP id 98e67ed59e1d1-396d0f2dcd8mr6758572a91.10.1787894845803;
        Thu, 27 Aug 2026 22:27:25 -0700 (PDT)
Received: from localhost.localdomain (vmi2317720.contaboserver.net. [84.247.152.65])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-396ddc555b0sm977985a91.13.2026.08.27.22.27.14
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 27 Aug 2026 22:27:25 -0700 (PDT)
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
Subject: Re: [PATCH v3 3/6] mm/migrate: copy all referenced state via folio_migrate_lru_refs
Date: Fri, 28 Aug 2026 13:26:32 +0800
Message-ID: <20260828052702.52673-1-lianux.mm@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260826-mglru-flags-cleanup-v3-3-d9f1c75549c8@tencent.com>
References: <20260826-mglru-flags-cleanup-v3-0-d9f1c75549c8@tencent.com> <20260826-mglru-flags-cleanup-v3-3-d9f1c75549c8@tencent.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 10225100005
X-Stat-Signature: cw51gtqtrcpmbs1c4f3rjykwiyx9fgiq
X-HE-Tag: 1787894846-269539
X-HE-Meta: U2FsdGVkX1+hkusd5WeyepKDeywRZRbzh6z9zOEwu1DKpCwH0D3KaXvapOumLyDSMvxrN99H5cBYfJqEYb9ArMZiJUanu5ds/YnDMWg4dYIk95TDOgKxuEvqdvZPqhWDAjTNTuMYObZ+284v9p+VqRAPcjD8wmaXxDI4frpQ8cKd74s2B+RjycWxx42Vbx0wajrBFTFffMGlzFoCfK1zJ6DJvMbAXqu/qc+79As69z7w2BTayB/JJs3ovhgapI9UzqypJnghq6tsGMCwXrv/K+AKnKul9GU+WJjRTBoI2EroFjOOwhR00/AZ7F2R/M4d/3GyvOWzMZ62yxO5V0xBhHgJ0R+3bQnWwM9ZGjnvMUrcvehh5M20z+texFllAgaDAz9FYsOsg4XBL/XaxihIxF/bB3EV76aVXvORHCeAmdlSLnlLezEeTt4YH28vjnQwFwy1C/7cVdDjf6O0avA0vgnswTovhL5f0TS5KupWuXWKF6MjsCKzXFUb+4OfRP7F85bh0CgiE+PUvUS+25ACk6ZnlOMUDHbMO9LNW3joH+E6Y7+JHmGUdqYpUp4RVTkRkuhdaiLYq/htolutQOni5egFX6DEDuaxqHoq5dRs8Bwv9IOUEv0/Ihi4frHPvrsVIg3WF9sZIlWRcTa4iSx9iw9EucpCa1OnbKPqyje6djMmuE9n6s7UvOs4FlQ82n/vydukFTDtnhVnjjRimqcpI0Fsuhfb5OcE37NIlig7YG2aAUOu5ZJltCcH8sV5Y0svh4OK+u6S+iaj3+5b0VDcqiq4RG0c+Pkj/QKfF5G5+8Oz+mVaEQ0KzbGp9RRwZqFfog1HMd8YsC5EIW3SF/Ze9/N9bhTb7M4mgpcrM87ORn/W46Oj6SsIkwyCQD+pfESaVQwVOxjZq3G78DX8xrZW6bn6Ye3znc4+P9n0fyeR2Vz3M+jAwCDMl4PD4AUasXP90skOcanlZumMSN/ZotH
 N3No/x/U
 oHaOzBCoKpmGuM+UbxpFmRSOmMmxPfqHwHzPfxtjtIgz9q9HRS8lndG/lq/OXTEKSS22c76NeGNnreeZC9Y7oN6ARX+mvJJ6kgtADXEOzIgDx2tXQeNgfZovUM8XOffsl2OiF7lc6F1WXONJzFXYWu6WQqNBefrUOuATkJ6+c3lUbiCbhSvlWHV3O5uoNIDo9p0TRMJRSmjO4DwK7eoXZDLsT/XXrWt5/vwJHEd4lrGnWZvDAjLYgwaV7AR9SXFzI9g79ULJq/QGY0Lk12pfMV6nCxOBfDYvq/1e0Nf/NFiTJGF+wQedP444BO2MGbipoXyXSU1LbGT7HJrO+s5i92RsCS4tpxljuG3+oaw4avts7TEZk/iBvSupOLA2EigKyFSR0/RryCnmGgdOKG+O3E/CrssvJvYuW8Ko/fzLqN67AstdOmNhtdHeaYsPPT2CM/EZR4LTICJpnfwrSAHb3FwxKEfBVDG+RJWKHRwGLhj/pfCuhHAjoagQ6Fa3tccRuJHz4x2pMRj2P11eHFj8KgqftrBAe0FiXRTOlmChP31lyYfOFrYxl1EdiiRJoz3280b/n9iTIGf5lV4BbceQd31h7rcT9tqYcfwv67t0CY9HMVODKjUDxwl0sA8g6mZH71ow93LlKDnZ8oXca4U58yEB0lAVJTx9P5wEjJgIpaP5Q/ew=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> Transfer the reference state first, before the destination folio is
> marked uptodate, so a concurrent lockless reader cannot have its
> reference update overwritten by the copy.

Reviewed-by: Lian Wang <lianux.mm@gmail.com>


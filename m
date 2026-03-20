Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E71B31099B37
	for <linux-mm@archiver.kernel.org>; Fri, 20 Mar 2026 19:28:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E46FF6B0166; Fri, 20 Mar 2026 15:28:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DA8E86B0167; Fri, 20 Mar 2026 15:28:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C4B116B0169; Fri, 20 Mar 2026 15:28:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 9E4ED6B0167
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 15:28:02 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 602AF13A451
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 19:28:02 +0000 (UTC)
X-FDA: 84567426804.20.745D7E0
Received: from mail-ot1-f53.google.com (mail-ot1-f53.google.com [209.85.210.53])
	by imf02.hostedemail.com (Postfix) with ESMTP id C291F80011
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 19:28:00 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=RRHlVxIy;
	spf=pass (imf02.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.210.53 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774034880;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XNNnmWHnRUZm7wwtDTGZLy0ujBXuugSXcNtRiTK4tAk=;
	b=6rH1dI34JdQCBl+A42gUnVdMNtJwOBTZm15ag2//tWO76mBozVlUiXV45m1x7eUVapnO1r
	1Y5McVr0Srl4fqKS3+FTUJ64t7DkP09WE1HzC5+oIAZpP1krXPRrJC89jEC6nDJMdcJ7fD
	kNbWCvlbafhZYT5o4VOZKM6AVpel3S8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774034880; a=rsa-sha256;
	cv=none;
	b=tqwt5Q+iPE7HCzxkAC5TUQS9/Rv/UtJejK2YenfhmqGBD2BF0+wl4avXLND+0pl5jyDMcC
	qYNVUlkN6aOI6GH0SGo6SB0vi156qUnbf8giwv70y8nPSAd0nO9M+y1kbpxYZuEk3Jq6y7
	PTCBOAU2krHARuyR/G6vjJ2EK5rgvfc=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=RRHlVxIy;
	spf=pass (imf02.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.210.53 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-ot1-f53.google.com with SMTP id 46e09a7af769-7d7f035bc39so705664a34.1
        for <linux-mm@kvack.org>; Fri, 20 Mar 2026 12:28:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1774034880; x=1774639680; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XNNnmWHnRUZm7wwtDTGZLy0ujBXuugSXcNtRiTK4tAk=;
        b=RRHlVxIyfT02aQC51bdJTchrL6FY+DzuXxNXNug8GhtUFFp2PAns82gDMPHhC+dbdL
         xVSOHz670yIKqFVC2buv4kisH/vOzGK7abRHn7ObheNx148aNOt2V2rFAyy3DI45ynbv
         mYM52RDufCttd0qlcempVCWU354FkoxclSGgrW5wCQFiH0IUq+w3USC5CBnr+eQopeOd
         XNINCrRVt2Lo92eoy1bqtLS965DZ/cFxT6aNrq3AZ7x5cGxINZjtHj5eEqlYx3ng+f30
         NNnt0mq0VdLfxdPTG+IayrAacRdOy00AMiHWXnqx57uchnQJEYh7lAW4vkBFhaYTeyoj
         gMZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774034880; x=1774639680;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=XNNnmWHnRUZm7wwtDTGZLy0ujBXuugSXcNtRiTK4tAk=;
        b=YsFMABbVbnJ/rDyvtSkoC68Db+YYs5XQzA0gDtB2geE0xYWaDLvu7MesikncKrOw8h
         17vLYNk+IfKJS4NXkKSWlIVXs/7PH/V5kTdToGZp+muWKA0i+7XPkew2ufsDoMwa7MIg
         yT7NA7TDa/WfcvDFrlKge8iszhcPiWs6jWcU48YS12CmSMi/q8vdMIEOxJ3+eBD+TdWw
         mD9G9sYXQzBWNRIbke9iw26xqqYfsfko8JTBlhDNkEF/2199hSLqsc1lT9iJihW4P6OZ
         Tcjnxv7MYQkUD3erGWJTrR4TmiLKRZtmG/WrVy9hohUJYUO+aWkiYUCRPsbXlChb70u5
         D1pQ==
X-Forwarded-Encrypted: i=1; AJvYcCWmkPIhtC/eiwGQCGjMKFOmj9JZJ3YHs4/S2skd0EQb5RK6saOCaOfZZaNhwxaxVsiHX1GjLL9wxQ==@kvack.org
X-Gm-Message-State: AOJu0YxWASYIA5g30gJMrSMWXhIEGF8LtVD6Jz2o8cXMY8p7wAtOaBob
	LLLLSrW997DH6gnGpJx/pClASUvhcS4n3sXY/4zVpQNQQrXyKeLNRDwO
X-Gm-Gg: ATEYQzxRvYd1ex9bZWuIDNOeH2b5JEYuKW/5CTkawjFliGM8iSe8ktXQT1Xiccgs2lQ
	SHuodh5SrR5lXMuVZX5PcLZzl7GqM9HzH8AI3vt2TL66Oc9S/4yvEGVgqdmFlY+hHV8ayzjk1dE
	xqw6yN84eCQJ8toO79v8Jda6CAaNto+ftJVfFlj9cv4TJqAkLTrMLvEDhx3mh7Vjw5dnYA40a+N
	F6AawmxlXls36sYtijlwce8UrqCQbUcawQR+lLzT7MhOmXAk1NfNCnaI7fwGB6gLRdEdvbCYiOn
	GK1jYziZ6PlWrmGiTkLmpBqjaDyZ584eSe0Bls/alYKxj8NlHZ/jOkUTqXnawRnQn07+99SZ8OU
	zEzusKxOmzj8aL9nex6/f4vmUJhA+zmebxQnvYmm/N2ixq0SAYMjK26/JWVPUbZCbFa9tDmIfIZ
	xvOZ5CtoUtT2OU4BxqKEfmK5tZYgzyIfo5srl4ZTEAyg==
X-Received: by 2002:a05:6830:2c08:b0:7d7:4eaa:8b82 with SMTP id 46e09a7af769-7d7da7d0888mr4861812a34.17.1774034879806;
        Fri, 20 Mar 2026 12:27:59 -0700 (PDT)
Received: from localhost ([2a03:2880:10ff::])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7d7eae27691sm2931366a34.24.2026.03.20.12.27.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Mar 2026 12:27:59 -0700 (PDT)
From: Nhat Pham <nphamcs@gmail.com>
To: kasong@tencent.com
Cc: Liam.Howlett@oracle.com,
	akpm@linux-foundation.org,
	apopple@nvidia.com,
	axelrasmussen@google.com,
	baohua@kernel.org,
	baolin.wang@linux.alibaba.com,
	bhe@redhat.com,
	byungchul@sk.com,
	cgroups@vger.kernel.org,
	chengming.zhou@linux.dev,
	chrisl@kernel.org,
	corbet@lwn.net,
	david@kernel.org,
	dev.jain@arm.com,
	gourry@gourry.net,
	hannes@cmpxchg.org,
	hughd@google.com,
	jannh@google.com,
	joshua.hahnjy@gmail.com,
	lance.yang@linux.dev,
	lenb@kernel.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-pm@vger.kernel.org,
	lorenzo.stoakes@oracle.com,
	matthew.brost@intel.com,
	mhocko@suse.com,
	muchun.song@linux.dev,
	npache@redhat.com,
	nphamcs@gmail.com,
	pavel@kernel.org,
	peterx@redhat.com,
	peterz@infradead.org,
	pfalcato@suse.de,
	rafael@kernel.org,
	rakie.kim@sk.com,
	roman.gushchin@linux.dev,
	rppt@kernel.org,
	ryan.roberts@arm.com,
	shakeel.butt@linux.dev,
	shikemeng@huaweicloud.com,
	surenb@google.com,
	tglx@kernel.org,
	vbabka@suse.cz,
	weixugc@google.com,
	ying.huang@linux.alibaba.com,
	yosry.ahmed@linux.dev,
	yuanchu@google.com,
	zhengqi.arch@bytedance.com,
	ziy@nvidia.com,
	kernel-team@meta.com,
	riel@surriel.com
Subject: [PATCH v5 15/21] zswap: do not start zswap shrinker if there is no physical swap slots
Date: Fri, 20 Mar 2026 12:27:29 -0700
Message-ID: <20260320192735.748051-16-nphamcs@gmail.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260320192735.748051-1-nphamcs@gmail.com>
References: <20260320192735.748051-1-nphamcs@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 7erqju4stdrhurar57mx4764iftw888i
X-Rspam-User: 
X-Rspamd-Queue-Id: C291F80011
X-Rspamd-Server: rspam12
X-HE-Tag: 1774034880-879717
X-HE-Meta: U2FsdGVkX1+10tXnuMMghPAkOH6L0E2y8msJhWOvytj3CGShkNV14OAad7Fh1KwN8j4k1SuTAQccLlDrEa24G5fzZ9BPvpPJN5fNHNkgvZWYIAhsfwXnnxUHnsYCC96TDDW12Pe/aWdz/P6Q6mN2BN5nZxXuJ05V1GGuro/8Ob0UNbudBkghKBXgg7uh/bbOFjThKFfX/9yL8CMVZbH93XIeXBP6s5AyJl/bk0kqexdDM/KQzMFFzWEmEy10ph5ULaDLt9CskkLaQr3xcteoJKm6E4WXw03GzAoSaPToEpkZ2+7Esn9jJ0vnvOS64z5Df1EcOYqDrMRiYIDCQ6tQ0gbEiWnPFaq6bnqxGOJWZRshyN5uCa7SLFcP7xo5WzXchq+WLpYwG0sdHiMLZJq8B92g8JiDoKf+MHNftAjPztYV4/KsszXC9V8NSfTAl7Y789eDEH/eSKAvqHidCJf/2LdN0oBxA972LzUoXMqqSJqvzhq5Z9ugrhty6WqQ5KhN5yz0SkVKncOmnt4vhzn+rBu1eF5QuwSoI3kSfGMD8DohGpzGG0siiUz7tXTV58h7qLdzetmKd62Lgb5RZ5pIWmWV6KjRDIBeQq6Zp3vEqFlglZCTUNQTBHfKM8i/yBowVkh1SqjH3ayGjGT3LsHrv/OY8d18bRsWoy5SPkZlDcnAlPmQxGkPage4IyTZa3X2rJmi/IQOn8vFwNL2d0SrjHWA7sZPPErLs3noudCV1Nb8D591O8pVgWr6hR9fae2EuKYI2YTdQHhKSoWkpGc+M5MVQyUiizwsPbSQqMM1jN932XN3Yw3rqaU4kPlPlCECZge0/hUnl3SmiQQce3egCOOPA/pLtEVtg64DYn/KVIbpqksdL3CkzPsvfGUPbJPp3r4WEPjS6iT3dDmGykUT4z1veGOZ19fKejOnhV93n9mo/eHB5lTk1LXIuMZrGcqpQRMOeFJv01Beaca1/DD
 3pVJHNeb
 3rTM2HCB5Tn6eJ9PcdJeqnvdlAFWnwMxIuxkp7SNCfvrxcCRsaNytXb8WQJEEJjyY6qg5DyUEQL/w2OI5c2np/C3g5S8tvcANd2rkzijpiqUCq2nPHI9Fn13d9TjXqgCeipj3jzH3XJbFdrsVcV8zyKokowUL8VHIPz2TNt8D6zrNmZU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When swap is virtualized, we no longer pre-allocate a slot on swapfile
for each zswap entry. Do not start the zswap shrinker if there is no
physical swap slots available.

Signed-off-by: Nhat Pham <nphamcs@gmail.com>
---
 mm/zswap.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/mm/zswap.c b/mm/zswap.c
index c5e1d252cb463..9d1822753d321 100644
--- a/mm/zswap.c
+++ b/mm/zswap.c
@@ -1211,6 +1211,14 @@ static unsigned long zswap_shrinker_count(struct shrinker *shrinker,
 	if (!zswap_shrinker_enabled || !mem_cgroup_zswap_writeback_enabled(memcg))
 		return 0;
 
+	/*
+	 * When swap is virtualized, we do not have any swap slots on swapfile
+	 * preallocated for zswap objects. If there is no slot available, we
+	 * cannot writeback and should just bail out here.
+	 */
+	if (!get_nr_swap_pages())
+		return 0;
+
 	/*
 	 * The shrinker resumes swap writeback, which will enter block
 	 * and may enter fs. XXX: Harmonize with vmscan.c __GFP_FS
-- 
2.52.0



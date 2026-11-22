Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C1FF6606A32A
	for <linux-mm@archiver.kernel.org>; Sun, 22 Nov 2026 11:39:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=Z/m9kr0N
Received: by kanga.kvack.org (Postfix)
	id AAFED6B00EF; Sun, 22 Nov 2026 06:39:03 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A39BB6B05B0; Sun, 22 Nov 2026 06:39:03 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8DAA56B05B1; Sun, 22 Nov 2026 06:39:03 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 66C6E6B00EF
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 06:39:03 -0500 (EST)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id E20F6A82F0
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 11:39:02 +0000 (UTC)
X-FDA: 85462558524.29.52AF298
Received: from mail-dl1-f47.google.com (mail-dl1-f47.google.com [74.125.82.47])
	by imf23.hostedemail.com (Postfix) with ESMTP id 16A1B140007
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 11:39:00 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b="Z/m9kr0N";
	spf=pass (imf23.hostedemail.com: domain of lianux.mm@gmail.com designates 74.125.82.47 as permitted sender) smtp.mailfrom=lianux.mm@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795347541;
	b=tEd8Td72udvecv1OEw872USI1L6UmBg8GNGVDsgerfI+mXUAuPwYn8mqnr1rWkC1Fe3+uD
	CwomKFUixCzNcVEorQryYiGuFkjSmtw1blRGVD/rzum7F2287xpWKRIY5dHf1lZriiaf7k
	Ynaz0AKU5/C+EidRSH5iMcaB1AfxbG0=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795347541;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9SL2nw3BljIJfL2BNxy4TtTwunpxe4OhPHoB+8Eji+8=;
	b=NnsiCuIZ7w9GCARFRy2G3NNUaGQL6JXIvWf4F2mB25XIVQaZzeke+Wxkrz1DUkThMVNOM5
	gMJNDPx6DEUhRDK4ygucHzD+0vGU58LW1O0tStSfe19ooJpzrxV8xNOjozH2IZ8ieG6oaI
	UDObo5RJZ4kFQw9KhpefPkMabckJswk=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b="Z/m9kr0N";
	spf=pass (imf23.hostedemail.com: domain of lianux.mm@gmail.com designates 74.125.82.47 as permitted sender) smtp.mailfrom=lianux.mm@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-dl1-f47.google.com with SMTP id a92af1059eb24-1b50a4bd2f3so3681709c88.1
        for <linux-mm@kvack.org>; Sun, 22 Nov 2026 03:39:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795347540; x=1795952340; darn=kvack.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=9SL2nw3BljIJfL2BNxy4TtTwunpxe4OhPHoB+8Eji+8=;
        b=Z/m9kr0NzQT3f3RhDSqdyI/LGvc7Bdhb4732IdgpBePVlBruPZNQA6AsJY+ZowHO9o
         afwMazmg1BrLYQtJ+tbNuQMTQLs4akTTEtb0HxJP2mDvaL2XKWfmXYOr5TVmsfIT7vPQ
         2hhKbeAsRXdh+1bKGhmALWZFmOiziW1+yZQ12AuhBwMGClN/EGzfDOZwD0+kJbWe2uN2
         McagloiT9H4STZlFNRS2s9B/g/Bq/ovWk1MYtDiqJIL4Xn552qJCPu8zk4ArFSpUwbyi
         iYtZBPqSIcph5DQiDG96JnuwTMd8oCNJM0KIC8ZVPwxEX8oRQyEIWc4Smcn40bUYZIPN
         ebbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795347540; x=1795952340;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=9SL2nw3BljIJfL2BNxy4TtTwunpxe4OhPHoB+8Eji+8=;
        b=h8ExMbMZCDcHodK682SqbLkMCyyZoWOr3myzH77N9o3J8gE2Xku34WRPAEf9UQ/7iW
         5SJ0CFE7B8W23rAaRCPMA+kBJvn+uQka4epGq6fpWX9vWUw+my5UyPirDzmBOKe429SC
         JKVsDCmtIBzJaajmWRf0HvrHEKaqW3zwNteIfJYCp3h7E3FTEE/jTh8Vot7OdJ4dIsle
         yJWFjp7lEkf5xrUA6iLYtwONZNrDwkWCJTtJ+IMGIwI9MdIzvZYAw08EhnKlN5arrLjv
         sABiibAfGanPbeVEw5liUiWBQn3njhE9wVhzmksf+VNzJTmup7Nr/APeizxiC6ayHX85
         43/A==
X-Forwarded-Encrypted: i=1; AL+hErGV8Em1DnsGmudb+k6ABcfUcw5oTTkhjsmN99IC9ErYExz0cWv4G11TBmvuDVjLApne5Fq8HSSYJA==@kvack.org
X-Gm-Message-State: APuU4Z/iLSemK4aD0ysTjMGhAv+9aSV7cfRPcoWyM9HDzprDdrLIcDbN
	UTWPj2Rv3IDtIMY2jVuYxbK+A24c4MKtE3VymVVvyn+wgTlhd+yAnhtA
X-Gm-Gg: AZFdTZcMm4lDzwTJJz8uemn0ROhVT/82YyCtx7fJcyXugQRYZcFis0Qk36CuKFRnztr
	OF7DQRixjV/cOq2oHmHcs+w4jNM55kXeJf6NWgF0g66B5xxCBTAJIKumHiQHtuegJG37g3KZQVO
	K7i1iz/44jMxcuwHHeBFhazvWGMdR5uCRomp4GsZmEA+3TbeBfpZFsaLTjBSPrV35bi8prztdlU
	uYaV8xt9hzVMO/0PyJQEMKLx5CBZ45pF/uTvQst1INs6+Lt/rTyoQOT19nHZf4JaaWFx1e4j/29
	e28Soua9gCxC2Y6931wTSUb6WGqTNiBWTJ3epc4NOpltcRSa+4PIs36IUoNrY1sLVAKHJ7/HFhb
	W90q+ahxruOVINKsHTd/Zyvz1MdXZ7pPOBUTqDyqjeeq4PZ+W4IMmewLEijQHGvNkF5+gj/9DBo
	JcqbQI+RTyx4SqGwK4qvh34TOsqHIMvnE90Illu0BNjaoaJRnlw/JswrmJ4115aB7/uBZsi01IF
	Qawk8hivucBFOezxXUgvfo2ZeqfCfr1RTLx9kSVEtSMJxEzP/ZDJIbr2YmCBGDK1bEAWVEI+F20
	cTdlpNmtxipB6Zf4f0t+EwqD6EwQiNkIYZayHMgNTWIeD7TgdkXmjlOczNAiEMgfjeE3
X-Received: by 2002:a05:7022:f509:b0:1b3:ad88:b9c5 with SMTP id a92af1059eb24-1b5568b7e07mr8368775c88.24.1795347539687;
        Sun, 22 Nov 2026 03:38:59 -0800 (PST)
Received: from localhost.localdomain (vmi2317719.contaboserver.net. [84.247.152.64])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-386aaae4960sm3717851eec.18.2026.11.22.03.38.45
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Sun, 22 Nov 2026 03:38:59 -0800 (PST)
From: Lian Wang <lianux.mm@gmail.com>
To: Kairui Song <kasong@tencent.com>
Cc: wang =?utf-8?q?lian=EF=BC=88ByteDance=EF=BC=89?= <lianux.mm@gmail.com>,
	linux-mm@kvack.org,
	Johannes Weiner <hannes@cmpxchg.org>,
	Muchun Song <muchun.song@linux.dev>,
	Qi Zheng <qi.zheng@linux.dev>,
	Ying Huang <ying.huang@linux.alibaba.com>,
	Chris Li <chrisl@kernel.org>,
	Baoquan He <baoquan.he@linux.dev>,
	Nico Pache <nico.pache@linux.dev>,
	Usama Arif <usama.arif@linux.dev>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Barry Song <baohua@kernel.org>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>,
	Wei Xu <weixugc@google.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Nhat Pham <nphamcs@gmail.com>,
	Youngjun Park <youngjun.park@lge.com>,
	Zi Yan <ziy@nvidia.com>,
	Gregory Price <gourry@gourry.net>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>,
	Lance Yang <lance.yang@linux.dev>,
	Hugh Dickins <hughd@google.com>,
	SJ Park <sj@kernel.org>,
	David Rientjes <rientjes@google.com>,
	Yu Zhao <yuzhao@google.com>,
	Vernon Yang <vernon2gm@gmail.com>,
	Zicheng Wang <wangzicheng@honor.com>,
	Chen Ridong <chenridong@xiaomi.com>,
	Tal Zussman <tz2294@columbia.edu>,
	Kairui Song <ryncsn@gmail.com>,
	Xiang Liu <liuxiang.277@bytedance.com>,
	Ehab Ababneh <ehab.ababneh@intel.com>,
	Zhao Zhenzhuo <zhaozhengzhuo@uniontech.com>,
	Joanne Koong <joannelkoong@gmail.com>,
	Kunwu Chan <kunwu.chan@gmail.com>,
	Hui Zhu <hui.zhu@linux.dev>,
	linux-kernel@vger.kernel.org,
	cgroups@vger.kernel.org,
	damon@lists.linux.dev,
	linux-doc@vger.kernel.org
Subject: Re: [PATCH v5 00/17] mm/mglru: frequency guided promotion (MGLRU-FG) and flag cleanup
Date: Sun, 22 Nov 2026 19:38:17 +0800
Message-ID: <20261122113833.62817-1-lianux.mm@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20261119-mglru-fg-v5-0-9eee2fe97a2d@tencent.com>
References: <20261119-mglru-fg-v5-0-9eee2fe97a2d@tencent.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam06
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=4.0.1
X-Rspamd-Queue-Id: 16A1B140007
X-Stat-Signature: ig95wsxh3qouhhk4xmbyr4t1bybiiha9
X-Rspam-User:
X-HE-Tag: 1795347540-745105
X-HE-Meta: U2FsdGVkX19oJ5tMAA6qKCA5Dinag2OayFXsw9EMFtpg0GdIyUrEGcCKNEd6o7WTvNWqYD1lAAnznO8+1z+gw6PnRl3idCPUQdOkp+0CgRLcLY3L/rFAX4Hq5oW+3EX5mHlad0uTnhh0PV+CYb3EhZ16IZ+aRIac5orLwiqowqB/PY6Uu+M3KQXIWsyZxSrlzpaKKEAQX45FlbvfxH12PrAt8sl2V4P4GA5F/ljuJrPLHvPLThAHl+G5kgtZrSPQioff7TSAn8SWolsSvX5REZYGo/LzZM3drEs2a7Y1+ajxdtviCRPVJlAwQQ1TCLm8e3NE7LZzI6aGNDwBj2ea6bfXcZJ4K3Y1saVi8MDVpF1+DDwm2j0zn1q6ElUkt55sUWyX9pXRFNMS97CYPuHyjt+sRG1HjCLv0wqu2HdLAXYHMgp9ZArFdr6Xp3E6ZHuJmCq0z76jB0web0MKvTN9wUa4UXmNk6niprVlBpjmuVQsnqXxDCLhwnsBWSFQG4vHL78NAouRGtj8fTdBvVJ9V5D4PXnzdyt+q/ZAgJnUAX657Lzt8IhV/6meCKRsw67aDV6XHC6Wb0M7N4Qo60Cy20O6HZR8DyAxPKl8Tl7vrFoW2dtzUbk2frEad4FRrb9O/FbYnaaCkuCk+rwD2k3u7DZSxtNjufqnq3n0/XSRYFlRUKkSceO5AQQmUG3r/kZb+7FgevRDcYH+lD/MIPIDAlnG2IplqjIRb/ApE70HQ5viTdKmMf4/MsgqBq9knP+lz7ziryxaHzkgNcrpObf+/Cz3dU5MLwiu9OWhaqJdyr2C1EhVFmxrEw2+ei/sPyu1JLd2DrnBXRKsYxbCxcjc0Mnd+vxmYQCX3v4quMlzWsSqxX9gmRNAxu+I9LYOeYK+jhO9OdaR1JCBHN8R74U90/GfXh/uvJnnedDYK48EIiakC9I/UysM/y5eYulY44z9Vr6iVfJFM7BpBekCaNt
 717YBzyo
 frQjrcd6kQCM9k9Qtbb8yplkrmTE/5ysjZZkM/fWBdFp+x+sVSS7iybl7Mswjo9c1lJzkV69t5kso3lyU25QeYF+AkjF/dYwUa0kbLorbtnnnvIDu2rSlCcf6Vs+ptKOfYCGwo1WhgSE6+qM4SGShl24DpRc1PXbuRMJzOvt70UDJcvckzmyJMzM5Pjiwp9a6ViJWtyp63lpDwqR64bdYrvxgl/onqZCiEvg9NLLtCkBG0dKv/NHjEdaPTeco0/002CjK+iOxoML02+5+s/dsG+JvKWXPlpJkZ/YDZnn3Gui/2c6OOITy0hIrfqoA5t5SucTi3o0Zcbc3MTrRmKVj90A1km8bbfBk385L7bkFitDkKEf+JDjBKsPHuyOiCMF3vdp2w261QvLvWbf4imdwE1oCASpOSMLl0DdxfUI9TASmxbsYTb2moTOnGydbTbO3vRZHg5LYwMYWyCnqBRedkq/jxrIqwhjz89kGA+BRU256k901hG6RWkEfJ9GXS5D039lbUhkT6d+54FGa2byBRoscw3fd2TO0y2+PxFmRof1kELeYooVh6QId6ojpvI5KkJnltb6naV835jmwEn1lVwFCrsnnH0fBXh8GP+PEyYH3bYSbS02p+5lUr5+cdbIR+dn0kSpX+KZOjr3NoAjC2w4+jRnCfd3DN9jFlWfS/0IfhEoG+HRAUMYW608RqKy6GkaTPBROkee0Lw/dBQinG81fU8UFFMpjpp9FbKOIp0TCFFxsh+nmAZkhZj3IDCuMF3Oo
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: wang lian（ByteDance） <lianux.mm@gmail.com>

Hi Kairui,

On Thu, 19 Nov 2026 05:03:32 +0800 Kairui Song <kasong@tencent.com> wrote:
> - Rebased onto current mm-new.

The v5 build checks on x86_64 passed without issues.
I'll continue to report results from additional tests and workloads.

So feel free to add:

Tested-by: wang lian（ByteDance） <lianux.mm@gmail.com>

Thanks,
Lian


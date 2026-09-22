Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7666AC98302
	for <linux-mm@archiver.kernel.org>; Tue, 22 Sep 2026 04:16:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5E4606B00AF; Tue, 22 Sep 2026 00:16:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5BB506B00B0; Tue, 22 Sep 2026 00:16:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4AAD86B00B1; Tue, 22 Sep 2026 00:16:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id D0C476B00AF
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 00:16:26 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 5D796120357
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 04:16:26 +0000 (UTC)
X-FDA: 85240086372.07.CF02EE5
Received: from mail-pj2-f1.google.com (mail-pj2-f1.google.com [74.125.227.129])
	by imf01.hostedemail.com (Postfix) with ESMTP id 7FB7540006
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 04:16:24 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="FULsV/AA";
	spf=pass (imf01.hostedemail.com: domain of nzzhao.sigma@gmail.com designates 74.125.227.129 as permitted sender) smtp.mailfrom=nzzhao.sigma@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790050584;
	b=lD0KcKO9S7X3dE2sr2oYwOoTwO/tZAZ4+Ohl7ZtuuHkSrSJeEafLycBmzhMTpQC/SUgcxw
	1nfSti8648viIdETMgN7f4JGTxvcMCUwyvR/RJ/EQfB8xhp/34zRZ5HqVyKO4KuwPvLNBg
	/Oc7+GsqZSIplAucrxslFHFxu3kjgaY=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="FULsV/AA";
	spf=pass (imf01.hostedemail.com: domain of nzzhao.sigma@gmail.com designates 74.125.227.129 as permitted sender) smtp.mailfrom=nzzhao.sigma@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790050584;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JDLbvCKUB+a+IDR0laoJE09QGbcCCmet6VJT4AONztI=;
	b=DFp+zuVtVnXa5e8tCUMzza+NuNEvOoRrx9QWE3FSbULwKvGAUdYJBVrsymoEqBIYbrPvTr
	ZzDNIgtP/6G0snB2vDNpEhTGkVdchg8ck9JoEXxUPFsHStJY9WIBIe9dsSADUcysorr+4r
	JG9kOmvhDZjNWvkM5MgDsWAdS4WJc2U=
Received: by mail-pj2-f1.google.com with SMTP id 98e67ed59e1d1-39e59dca659so2252826a91.1
        for <linux-mm@kvack.org>; Mon, 21 Sep 2026 21:16:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790050583; x=1790655383; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=JDLbvCKUB+a+IDR0laoJE09QGbcCCmet6VJT4AONztI=;
        b=FULsV/AAMQ4+CpgYjaku7AE5k1FkBPZRhjycVA4mM4zLrxtS2p6iLIwG0z2DzYfZCu
         tzEfJYn8uXN865np6piQUSslQZU17RDkY63WIhrR7H+egG3G5RDNqBn0cmxGCybhFx5+
         9bWOxEM4ZaRKsOgT/DR4HQgu1kAL8TSgxY9zLqM0m0NP5oyk1SyZ0RyAe1yL/tqYe71G
         5EBILjLXhU2QjFsodGGFcwTbW1NFpKCnqEMKbuNgbWudkGtkO8KBi/Kyy0w3NbKBxzT0
         Tnk+JM6ttPW/GOK7hLGtTjlhyqTqLHWsMhxqiDBCuLe/vyyxlwNlqb74S99TZ1QrJQZo
         FfIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790050583; x=1790655383;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=JDLbvCKUB+a+IDR0laoJE09QGbcCCmet6VJT4AONztI=;
        b=pQYPBR/dC7JWFkgAWvonM0dBXvH9KNlRYTR21v2E/hYlAQWuWWSf+Uo4F0v27BbBmL
         GxH8qYIGHtn6NFbAazVhReOxqrgTcezFmvx7nPig7faJPpH2ORwmRe9p5EbakNAe1MWD
         db+8Pl7rWUy9VwOCPOjjskEaU29AKFt6AQ/UhtLfDmF5bXaBnLe28w0BoPHP59tqDQpv
         So1qMeLGSXPFXGpKJ8X/o0xpn4ul3/zw5xCEFDQJ/EqLhvk97bxX3cSKRI0xBNuTjawm
         R4nhIc+uL6KciJkv2qaQpgprnyfisBb78D5fKZffNqwruKtHqyOI8/s7xbxmcV+VVHWs
         A6eg==
X-Forwarded-Encrypted: i=1; AKwUvBx4kr626i84ynU8p+Lx8lkN1jbBcAYv2kP4JyHo9yCwaYfIkUZtdGYgQXC8aoUvxjM9jnQQRJcQzQ==@kvack.org
X-Gm-Message-State: AFuF++lWq5dQuzOYdx4EjweewPUYcye0qK/SWqCfGD0WPxgU1bCg9gOp
	e9jwSXA71E1xWjxlVhFBQF16RBEASydNzlXjeJOgCbuytnRYvcN+6U99
X-Gm-Gg: AYBFou3ahQsrS1ckILe0197R1Jw47pbR/7zJScxFRQagqEfkcKaPsi7zcwXseAQW5/I
	OxR7i/AlYQkjrHQx912KZy9Dw+OQ53cSWMxqMoPZr3iBzvEQehfJ6egI+5GIDUaHygaA0oqu+iq
	X8bYGe/i48OTKpqXsUK8vvHk64SsQOzdDmtdDamdVVSGDPAcIkm4Iv73tiHUhhTspCVGAlqHATb
	omy5W6seP3p/4cx8XXt4Fyr3cLz3ShOvjyZ30zLKpGZQKiMBfhOxs3l1zkf++RVyZIiyEHIge3X
	9HkPlT2q9RqZXX/3UnILKz53DZfU+Zd4LMVIL5HU6Tu6McV0Q4MY2YMDfkAI/DSLEEU80u07ZUK
	Hfy6hymCPbUL2OBs+cy1+Tzu7+GypmBsQtdyBx5BHoc9dBmUtsLNKOdZJ60z6e4GYIU/8N5IU4/
	w+wLaf3iLyTvcZEtLymRw0XX1i5Lp4A+bMIxlJhRf+c3gWnlObhYVSx/tFPZezrF4MyYmTdMsm0
	zYeVs0sggO3mcaWtcUpAzAFzG2Bxp2qgvAV
X-Received: by 2002:a17:90b:56c5:b0:39d:f95d:bd08 with SMTP id 98e67ed59e1d1-39e55008a3amr25857593a91.14.1790050583196;
        Mon, 21 Sep 2026 21:16:23 -0700 (PDT)
Received: from nzzhao-ThinkCentre-M760t.mioffice.cn ([43.224.245.179])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3a0674d65d4sm2204031a91.15.2026.09.21.21.16.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Sep 2026 21:16:22 -0700 (PDT)
From: Nanzhe Zhao <nzzhao.sigma@gmail.com>
X-Google-Original-From: Nanzhe Zhao <zhaonanzhe@xiaomi.com>
To: Zi Yan <ziy@nvidia.com>
Cc: David Hildenbrand <david@kernel.org>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Muchun Song <muchun.song@linux.dev>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Nico Pache <nico.pache@linux.dev>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>,
	Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>,
	Usama Arif <usama.arif@linux.dev>,
	Gregory Price <gourry@gourry.net>,
	Ying Huang <ying.huang@linux.alibaba.com>,
	Alistair Popple <apopple@nvidia.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Qi Zheng <qi.zheng@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Kairui Song <kasong@tencent.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Ian Rogers <irogers@google.com>,
	Jan Kara <jack@suse.cz>,
	linux-doc@vger.kernel.org,
	Alex Markuze <amarkuze@redhat.com>,
	Peter Zijlstra <peterz@infradead.org>,
	kexec@lists.infradead.org,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Dave Young <ruirui.yang@linux.dev>,
	Adrian Hunter <adrian.hunter@intel.com>,
	linux-mm@kvack.org,
	Hongbo Li <hongbohbli@tencent.com>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Chunhai Guo <guochunhai@vivo.com>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Tal Zussman <tz2294@columbia.edu>,
	Baoquan He <baoquan.he@linux.dev>,
	Matthew Brost <matthew.brost@intel.com>,
	Anna Schumaker <anna@kernel.org>,
	Stefano Stabellini <sstabellini@kernel.org>,
	Yue Hu <zbestahu@gmail.com>,
	Rakie Kim <rakie.kim@sk.com>,
	Minchan Kim <minchan@kernel.org>,
	Richard Weinberger <richard@nod.at>,
	x86@kernel.org,
	ceph-devel@vger.kernel.org,
	Eric Biggers <ebiggers@kernel.org>,
	Alexander Shishkin <alexander.shishkin@linux.intel.com>,
	Ingo Molnar <mingo@redhat.com>,
	Viacheslav Dubeyko <slava@dubeyko.com>,
	Wei Xu <weixugc@google.com>,
	xen-devel@lists.xenproject.org,
	Gao Xiang <xiang@kernel.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Joshua Hahn <joshua.hahnjy@gmail.com>,
	Byungchul Park <byungchul@sk.com>,
	James Clark <james.clark@linaro.org>,
	Arnaldo Carvalho de Melo <acme@kernel.org>,
	linux-fscrypt@vger.kernel.org,
	Borislav Petkov <bp@alien8.de>,
	Steven Rostedt <rostedt@goodmis.org>,
	linux-mtd@lists.infradead.org,
	Axel Rasmussen <axelrasmussen@google.com>,
	Jeffle Xu <jefflexu@linux.alibaba.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Yuanchu Xie <yuanchu@google.com>,
	Ilya Dryomov <idryomov@gmail.com>,
	Oscar Salvador <osalvador@suse.de>,
	Juergen Gross <jgross@suse.com>,
	Pratyush Yadav <pratyush@kernel.org>,
	linux-nfs@vger.kernel.org,
	"Theodore Y. Ts'o" <tytso@mit.edu>,
	Oleksandr Tyshchenko <oleksandr_tyshchenko@epam.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	linux-kernel@vger.kernel.org,
	linux-f2fs-devel@lists.sourceforge.net,
	linux-perf-users@vger.kernel.org,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	Thomas Gleixner <tglx@kernel.org>,
	Jiri Olsa <jolsa@kernel.org>,
	linux-fsdevel@vger.kernel.org,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	linux-trace-kernel@vger.kernel.org,
	linux-erofs@lists.ozlabs.org,
	Trond Myklebust <trondmy@kernel.org>,
	Chao Yu <chao@kernel.org>,
	Daeho Jeong <daeho43@gmail.com>
Subject: Re: [PATCH v5 00/17] Remove PG_private by using page/folio->private checks instead
Date: Tue, 22 Sep 2026 12:16:00 +0800
Message-ID: <20260922041600.1240429-1-zhaonanzhe@xiaomi.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260920-remove-pg_private-v5-0-bb68b6a21869@nvidia.com>
References: <20260920-remove-pg_private-v5-0-bb68b6a21869@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 7FB7540006
X-Rspam-User: 
X-Stat-Signature: rsco36x46hyrct4krnzm9agzqwfhox49
X-HE-Tag: 1790050584-716488
X-HE-Meta: U2FsdGVkX1/ef0+DhO+SADTLnCYJbYjN+KH7AeuzbQUWWCBTeCbIMHM2FfK2yHD0P00d/n3Ub7ihGykElYS+383wt20PxF9Nc1hCmWASiHNkQpw4IlukwdMGG1EUn78CLYEG2GtSLNK0fT4BotGfMHmrAZ2PZH6OSuOLralA1P2AGJFABVUTkmWzDE9W177y7dDEV+rEOVRFYaS6e8oHzj3h+DGbYWfJm2I/JSRAA5aBGjYIuCl5Ez5zYMWh6M0ebtTT7bILgyUazovX345KIeNmOX8FvENLlR4MnC/hlUtC0EMVs+GXIe4xsiwbnTa2ZZ7A3BJZ6rg855cuO6Cr2DvkPEs8EQrKCgsDkV833xDzG+suKGQkv29nEs7ymfdxjEv3pzI6iobjEgUOxCLRSxgGo4E6wwuYTFDXpJIffgZPkPr5Tw0k18YLwzYtuyoieeWgRkMZq9jASJstxL60qNICB5p0W5pXPUYSpQFmyZLb2oy0xnag9OuFEYrs1jS4KeAJfFpYrZU6lKqinPE14kV/1wLEL2zQiXSfTR//4gZ3+TIqLiqBbPNEdNS6jdNxtpv5fFzqTE6GDGUoBATmg00wBTm3SZiELGw9f8j6wuZRLwenTJL0BfUx4BGiMx3De129mmO1dl0TEA6dXLBm1iZSOX4GFqLe1eDJA444Yl8DC/AtzgxiO/EWh8COcx1k0aLSvJFvAFwYTH1Ozt/zcR7pVQUZz3Od71Oh8z0/DHpKzIGKJmXe0oQu31C7mowLzPZHYyIsc529LoOdqF/xAs+NbtfftE5G3WK6KtmJdh3NK0YUg3u381OZyoTL56NyzCk/r8wBk86+jIS8ZHs+Fv5yw9Q33UushLlU4libCOzOwohW8SSv1KD20iUj4dB2NXVj+FSaGN/G+6zPqJOJaee6o5AFzXZWhM00K+BM+3UYDl5C1mKwAg131ZTuQDjw/lRi73ONvpNsJA+gISn
 WI1j+xok
 GzRVqcw+djTTQyJqw1JMkbDuyrG+BlqfdBqkva8IIdJSclAUi5GGSPBJoEaOmE7lBctsqZ6BcsWROfOqr59tRQqihmJ/JbGLhHYLpMzS5vAQjkW2vXXzWymxFNXQTsJHYbTx1fhqvPicqHYkqDOnvxPtcyJ5KNAW4XlDV2LjjdA/xY3layUJHY0qWhQITem9A4UctHWsSigtGE8Ilt4/BIq11zH24Ql7Yn0Y5AhESYcxRN/g8mFJEMUB4Cgs4NaM4uAXtuhnBEFTUI+F6aRU6lgs/F3npoVwTjih91wmOzmkY1MCuzI73Rbh9pf9dKHC4W6IX0FuNoEuGATGmonecnqoHUWlKUQtYQ/Q5U/xHjtpwtIIYoLDK2m7zEVPjQ5BIKaMlENGaUSi0VXdMHF/W/+84xNSSZtRM8BbFExtGLVj91nOuqUd/8ClQ4RykkI1eVh7/PJUsIIsi/W2ecTs24VK0YzQib8DGTI8gkZ0Hvv/ex7NxBQxCzhu/n+wwx8PTyHC3T7fgq99Y/f8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Zi Yan,

Thanks for the series. The cleanup is a nice help for the f2fs
large-folio work -- it removes the page-based private-flag plumbing that
my series would otherwise have to carry itself.

My large-folio series v2 [1] can be rebased on top of this series. The
only overlap is the PAGE_PRIVATE_* flag helpers, which I can re-express
on top of the F2FS_FOLIO_PRIVATE_* names while keeping the
f2fs_folio_state indirection.

Jaegeuk, do you have a preference on the ordering here? My personal
suggestion would be to review and merge this series first, and I'll
rebase on top of it.

[1] https://lore.kernel.org/linux-f2fs-devel/20260915041909.2903887-1-zhaonanzhe@xiaomi.com/

Thanks,
Nanzhe


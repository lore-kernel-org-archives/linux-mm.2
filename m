Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C060FCA1005
	for <linux-mm@archiver.kernel.org>; Tue,  2 Sep 2025 16:05:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 249608E0033; Tue,  2 Sep 2025 12:05:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1FA308E0002; Tue,  2 Sep 2025 12:05:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0E9358E0033; Tue,  2 Sep 2025 12:05:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id F18E38E0002
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 12:05:50 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 8AF5B16029D
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 16:05:50 +0000 (UTC)
X-FDA: 83844786060.23.6910A40
Received: from mail-ed1-f46.google.com (mail-ed1-f46.google.com [209.85.208.46])
	by imf09.hostedemail.com (Postfix) with ESMTP id B7D17140004
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 16:05:48 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=XaMD0boP;
	spf=pass (imf09.hostedemail.com: domain of pyyjason@gmail.com designates 209.85.208.46 as permitted sender) smtp.mailfrom=pyyjason@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756829148;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Y6y56X8OUTmSoo3VKz8VzAATzZ9BTMxyuZT6xksXOKo=;
	b=AM1fiQxWCCdXLnvwXqRY7EbzOcbxYP1RCTpJjbmkYbFyOxMu4JZiFagFANcq+P3HWWBtFd
	bTobAhrqrfYqL0nZPAOJH1jgUSKqu0wQzse1mCAf+cMC6o2X2NQIBcs1yO6rN2PuvDVxXR
	rJGGMd/5OkIAQu7a+/wtc8L2K4Nzboc=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=XaMD0boP;
	spf=pass (imf09.hostedemail.com: domain of pyyjason@gmail.com designates 209.85.208.46 as permitted sender) smtp.mailfrom=pyyjason@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756829148; a=rsa-sha256;
	cv=none;
	b=QMLxYhrvubB/jifv5ZajBQh58AlqKth2CxHGSSfF6oqNzFWrZXyuPCxJ4Y2i3dQR+tAaLo
	EQeot6C02NALrbxo2Cojp1E5f1dUylcZwhtR9iA8eTwPBbgMMm7ANlsTnox1RvdEpMggaM
	NI88Vb5a7kBhx1pJTNc+yc1qsxqNCNw=
Received: by mail-ed1-f46.google.com with SMTP id 4fb4d7f45d1cf-6188b7550c0so6756042a12.2
        for <linux-mm@kvack.org>; Tue, 02 Sep 2025 09:05:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1756829147; x=1757433947; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Y6y56X8OUTmSoo3VKz8VzAATzZ9BTMxyuZT6xksXOKo=;
        b=XaMD0boPPwckq67Zd+vyCINLr0OiVyI4fXA6dFSWwIpySM0yPTx5GKoU8SFEcYZHq5
         2zLIoclip+ZofMYIZifuDPjqrFIDdhb0S8V3UTpnjUjZBJnaKhs/+l4HS1CESRdcgpG8
         i0N0Lfv2yu6eMsxD9NAp7ID8S7nuAOYPlkICLJlYtlOhDYMUlecfYapQUWOJKxcK2dFq
         tiV/Z92uwkJX30zRSYT1tQQbymCzJsLKNmAzTx8e39VA+KThWK0rMlU7MWTuJiqmeD/n
         w2ecdU7tChSn/j9PkYQ3EhANfi0t3eOUe6SydyzU5YFTgqQdei59pvFhP42TY0XGjeci
         4AxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756829147; x=1757433947;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Y6y56X8OUTmSoo3VKz8VzAATzZ9BTMxyuZT6xksXOKo=;
        b=YNn6DKajj/A8bOYBhslV8sQO2SlQIqoHqU3+YVo7n2p2+AkywQBR3jqGPmEdkZMZI7
         gPMvqetwx+/n38jvQyyB0gG1tsLaYDK4V5k16Cy2Qq82T6hl4lmHas0Yn0Em2tVaG/nE
         hdpBSeMgR2NIYqUEx5NNrfuA9iqzHUxWSi6vmgqo+hmAfig8TQCSfLxM+UFVSfz5de1F
         uYdsedTGNGIvIB/YKBYX7mE1ofTznuMMQ8w4rtAmXlEqmI3Sv9INhtVJuczk5kSNlt71
         uuxmG/8ns21706zfmvN0/TB3jdZT9iU6ONdAtqxsjC/QEGZgq3ogPMlqH+VPmtogq28X
         /kEw==
X-Gm-Message-State: AOJu0Ywi4/b36eAfzgEkhP7DvIVouWIPbn0pzoPgdfgUy135TTRHW9wG
	QiljpZSrySqo1nR/HyX+Na5TEvDedVzaLGGSkimndIhYf3nJo3L46jrhwu9mtQPaej8=
X-Gm-Gg: ASbGnctQofjQSDBPz2qJMh7RFjEmhYswJOCu71ia0fQUkyOA0T0n1eFbIZzKgrklTRq
	78VLOYUuaJ148aS1V4UGHRLhPAZyIHh6MovY8UM1APlPtiQsWdgvamvZBrB0YUawsNMUIQai35j
	xvUalxYynufYPa+gIeEmzwkSLevxa/0raXF1RrZiZSGNQtyklEPawC37Y/OcgNQMXtvYm0fL14T
	Fa17UspBH4wiMwFJ2gzpQ5N1GjEl5lJs4YQbZPvQoH3gC5zuFuIm07OTuduB7QWafnRKif8Z8F9
	JYUq/mMuandZxsAp/tjqDsOopfWedeHNmqffF6YTb7HwSPWJdb6DhnLaIY+fPYT97KQfYzGmbdG
	gNYvk4+cosk9gGAM=
X-Google-Smtp-Source: AGHT+IHdPfNYaH9+9Q+ni6q5vuGRLRXreFcdRGX5aH2suTfhR9z0SYDmT0xWmddLPp0M60fE9SBktA==
X-Received: by 2002:a05:6000:2283:b0:3c8:e9d3:c392 with SMTP id ffacd0b85a97d-3d1de3bc74dmr8652135f8f.19.1756828675091;
        Tue, 02 Sep 2025 08:57:55 -0700 (PDT)
Received: from localhost ([2a03:2880:31ff:71::])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3cf34491a7fsm19642743f8f.57.2025.09.02.08.57.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Sep 2025 08:57:54 -0700 (PDT)
From: Yueyang Pan <pyyjason@gmail.com>
To: Suren Baghdasaryan <surenb@google.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Vlastimil Babka <vbabka@suse.cz>,
	Michal Hocko <mhocko@suse.com>,
	Brendan Jackman <jackmanb@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Zi Yan <ziy@nvidia.com>,
	Vishal Moola <vishal.moola@gmail.com>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Usama Arif <usamaarif642@gmail.com>
Cc: linux-mm@kvack.org,
	kernel-team@meta.com,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2 2/2] mm/show_mem: Add trylock while printing alloc info
Date: Tue,  2 Sep 2025 08:57:51 -0700
Message-ID: <1491df0ac12a7626b7c9b00e26a6e10adb8c9045.1756827906.git.pyyjason@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <cover.1756827906.git.pyyjason@gmail.com>
References: <cover.1756827906.git.pyyjason@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: B7D17140004
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: sh6gckw3g6jrruu9pqdw1nuw1iuz95gy
X-HE-Tag: 1756829148-156456
X-HE-Meta: U2FsdGVkX18DMeZjrx2AgDCX0YzycTCDSLMYC48czfc/KGEdPjAZCZXhK44AacXSNkQQuPFCCLaSOj14ZWFBYCIcIj4ahcLTOla+noRTPOzXfaVFAXLNBjn5D/eurG8MAoQWqTs+/YUrHCkQX/xTBC8YvlbmqO9cJXJZyTW6ISCwg65nnltuHWwFaEBNa3o5RgFfiaYwDv0Y8HtgLhFOY4v6t6Y3sgPgznC9oMwTwzAW0opL/kKtubMXWVyuqelVscLN7LoeDcY+DZD6kU3i8+aza4yVsQJ/SPfYxsNvRMAsXQkZMzDXKgZaNqPRnsJflOHNWmgNHgr6JtLw9twBXMn+pEdXBaHEAArJgRhMG5ZSRhaa2Fy+CCMqfYcsK8WuaWJWmSSXIFMzrkb0jxmk6PdIw8VzCGgUINByo4U+y4YELTuyhJhv/OsTZykD1hDWfcH+yFahRJUgIug+DlgLWW7JMrdh2AM5J/P5d5K/b8Oz+/4HqozLOSojHWusFHe4I/0fhrKH+ZRUOBltw/rKaqIwPiPirtY1bC3fIdy86qkRpKBMqaKBGLeNn29FVeZuhLv2a8C5VpOOHGrDqlvYNpSezJjEdyuydD5kpi2hYMBI4eFI7kIazKuF4Dpj923iFR5QvB1v4AJyYSJCbN3ZxvjhnsiSByuEas5VeIIjKB/+cIoQ2mLn/TJgX9nY4x0RVDmiMORulWV1sH2B3deKXbfWgaOX55sBWD/XlSqqvErHe6pmrLenIRp9vfQW9MIl0DnvX+sbJaK89ZVry6+q3yncYizcpTjF29Tq8wQ1hVPtdG/80znh7TlOxqMR2hBWnIfIw69iaJrQlraJRkM99vW7hLO7PTZfe2utbpGEjpJXtNrgMNlhNK15+t89++IhPrDNVyKHOahVCjFqxfh/GQURsIKGTRkSL/1jQAebgxJrwDIf7htdb3A/pUZKmxlbvOGidgQiCxDMYEsEb4X
 4xR8m+PT
 VXldajXgrM3GR3/LgmXhDsUS6Aj0X838lSufmsNgILrxZFVxivz7UsgUtCHDJnT17JsyNwd6DORsqAFhs8f9cJ/zBz/+b+Ea9vLV/4FdJpgViu8GYTizKhW9aemv+0FxFlBdfVODaWgVisbnOLvk5A8kKyhHmIfCuY4XIf2pQSTk3CZzLqmRa/qlDsCAM9eIGXekc4BootmiDRSEe4BxwcnkIZsiOd74Svc+f
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

In production, show_mem() can be called concurrently from two
different entities, for example one from oom_kill_process()
another from __alloc_pages_slowpath from another kthread. This
patch adds a spinlock and invokes trylock before printing out the
kernel alloc info in show_mem(). This way two alloc info won't
interleave with each other, which then makes parsing easier.

Signed-off-by: Yueyang Pan <pyyjason@gmail.com>
---
 mm/show_mem.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/mm/show_mem.c b/mm/show_mem.c
index 51892ce2efc4..4c876ea2b66f 100644
--- a/mm/show_mem.c
+++ b/mm/show_mem.c
@@ -396,6 +396,7 @@ static void show_free_areas(unsigned int filter, nodemask_t *nodemask, int max_z
 
 void __show_mem(unsigned int filter, nodemask_t *nodemask, int max_zone_idx)
 {
+	static DEFINE_SPINLOCK(mem_alloc_profiling_spinlock);
 	unsigned long total = 0, reserved = 0, highmem = 0;
 	struct zone *zone;
 
@@ -421,7 +422,7 @@ void __show_mem(unsigned int filter, nodemask_t *nodemask, int max_zone_idx)
 	printk("%lu pages hwpoisoned\n", atomic_long_read(&num_poisoned_pages));
 #endif
 #ifdef CONFIG_MEM_ALLOC_PROFILING
-	{
+	if (spin_trylock(&mem_alloc_profiling_spinlock)) {
 		struct codetag_bytes tags[10];
 		size_t i, nr;
 
@@ -449,6 +450,7 @@ void __show_mem(unsigned int filter, nodemask_t *nodemask, int max_zone_idx)
 						  ct->lineno, ct->function);
 			}
 		}
+		spin_unlock(&mem_alloc_profiling_spinlock);
 	}
 #endif
 }
-- 
2.47.3



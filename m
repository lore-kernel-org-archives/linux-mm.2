Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5606EF589AD
	for <linux-mm@archiver.kernel.org>; Thu, 23 Apr 2026 12:25:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C1F096B0098; Thu, 23 Apr 2026 08:25:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BF6956B0099; Thu, 23 Apr 2026 08:25:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B331B6B009B; Thu, 23 Apr 2026 08:25:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 9E81B6B0098
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 08:25:46 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 691A21C001F
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 12:25:46 +0000 (UTC)
X-FDA: 84689741892.17.725C29A
Received: from mail-ed1-f74.google.com (mail-ed1-f74.google.com [209.85.208.74])
	by imf26.hostedemail.com (Postfix) with ESMTP id A0A6A140004
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 12:25:44 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=p7zcsnsn;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf26.hostedemail.com: domain of 3xg_qaQoKCOMRHQFUNSXPNLTTLQJ.HTRQNSZc-RRPaFHP.TWL@flex--mclapinski.bounces.google.com designates 209.85.208.74 as permitted sender) smtp.mailfrom=3xg_qaQoKCOMRHQFUNSXPNLTTLQJ.HTRQNSZc-RRPaFHP.TWL@flex--mclapinski.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776947144;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=Fi9xSgYpoZ/qpCfid0/vii4Xij6h2WhXpELMzsBfSVU=;
	b=hdsK2b7pQkLYCloKRMauKDEGGvaj68i6MNacgEwBGEpVwTk2jUjpJ8684RfUlSTtnoXfiU
	sTrBavIBNxzwT1g/Wr7yOreQ/c2ANIyMAhkve6aeT3z2UdsFd7qZ/Ij66mGC8vsrn1oM+3
	Fte5Wi1Ef5Xcinrp9QvWd3P0PU72puE=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=p7zcsnsn;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf26.hostedemail.com: domain of 3xg_qaQoKCOMRHQFUNSXPNLTTLQJ.HTRQNSZc-RRPaFHP.TWL@flex--mclapinski.bounces.google.com designates 209.85.208.74 as permitted sender) smtp.mailfrom=3xg_qaQoKCOMRHQFUNSXPNLTTLQJ.HTRQNSZc-RRPaFHP.TWL@flex--mclapinski.bounces.google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776947144; a=rsa-sha256;
	cv=none;
	b=MYxje4qWTX7AuTUEg5WlK32umMKESuo1b7k9zaV5+92wwxYu7WMBs/GNPagNPzvVYvPUMd
	2/vKho24m+KiM9JcC4yh32sBjMrcaatqrrseQnY5EQS9qwlAH1T6l5C12HCdtXIR8HppgW
	pkUldUHGLR5VaSbWxsIIVeJuvSdpxCQ=
Received: by mail-ed1-f74.google.com with SMTP id 4fb4d7f45d1cf-6771df2b5easo1036149a12.0
        for <linux-mm@kvack.org>; Thu, 23 Apr 2026 05:25:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1776947143; x=1777551943; darn=kvack.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=Fi9xSgYpoZ/qpCfid0/vii4Xij6h2WhXpELMzsBfSVU=;
        b=p7zcsnsnGo7f18PN73x1bNv726Rnz8+QZjy2r21lhG7cL9JTKmQE+uLdTfYIQNGRqi
         D0zSFSZOGMZTpzdzdrtn9k1qgouHzBl31zXYSiIOpmnhC80TW7BB8KPDUwAg6XbSiM/g
         zzMwzcs7EC0nEzORrwBxmlIyfw/+FsK/6mzqS+qwf/CDHU9v9yga9lXxXKuDZcyjF7fr
         Flf0iRk0qVO1VKVEptNVsmLkHTDfhRz0zcErBNPjvlHqAIAbJk6UeeIvMUtPT//aZ86Z
         SKQreAi36o095Cfc4wXlf/x/Z2Jg2DkOeM4i/lQurGUIp/ZbxzeEEyIQze/ki7Hc3/dd
         9TpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776947143; x=1777551943;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Fi9xSgYpoZ/qpCfid0/vii4Xij6h2WhXpELMzsBfSVU=;
        b=bprdMrKX89NbSBsUgD5xsLntz6Q+D2d4K7uMCVHPJXqzDyvtAlq5k5mUSoLQaaSsf/
         f3ktfyGdUa5F25EPI4omIkz7CGK8duP7F6PX3npxzLVsry+MtgvPQkNzv0fjA6Tnz0pm
         iA/Sb2A8s65xR56IWyxNj+c1jLkqEQ7/mSBr7IsdSJ2ApNLLPE92zc3Ai/PZd/I8AKV0
         gR8I/BVrU/C45nQRSKphQs1NI0DIFRCPQVeOJ9lLcAZHGEbmyNuw8CzR9nudSLSKAZpZ
         TZh9QHG4GWhOg6KfiHWwEZbGecg3WDh8LNU1mbGeeLeNGSHfYrnI6h3JdlFHYTiIB1Sk
         IYQg==
X-Forwarded-Encrypted: i=1; AFNElJ/CifBY01FlGBLeUtxY+fy7Vpwrd5XGLpTRWghm1geXYPX2Y8js/7AkYtkZqxg+fMTqYxIs2CJAvw==@kvack.org
X-Gm-Message-State: AOJu0YzUAjrIZ0lNxV8SYXLCua+1gxZWVLEjRReeRhKAJZSnv+zq1Z/p
	kvDSOmFCj8lEuFODyTV5zIeRfa+rrMi6Tzu0Dd0oYnfMcpzorEmYhOoSWpneMFgP/VTHBVEGM/O
	WPHrO1oJ+lM/e7Cus0TbS0Q==
X-Received: from edev7-n1.prod.google.com ([2002:a05:6402:a2c7:10b0:676:9c94:9878])
 (user=mclapinski job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6402:1f01:b0:674:37b7:227c with SMTP id 4fb4d7f45d1cf-67437b722e4mr9379117a12.2.1776947142685;
 Thu, 23 Apr 2026 05:25:42 -0700 (PDT)
Date: Thu, 23 Apr 2026 14:25:35 +0200
Mime-Version: 1.0
X-Mailer: git-send-email 2.54.0.rc2.533.g4f5dca5207-goog
Message-ID: <20260423122538.140993-1-mclapinski@google.com>
Subject: [PATCH v9 0/3] kho: add support for deferred struct page init
From: Michal Clapinski <mclapinski@google.com>
To: Evangelos Petrongonas <epetron@amazon.de>, Pasha Tatashin <pasha.tatashin@soleen.com>, 
	Mike Rapoport <rppt@kernel.org>, Pratyush Yadav <pratyush@kernel.org>, Alexander Graf <graf@amazon.com>, 
	Samiullah Khawaja <skhawaja@google.com>, kexec@lists.infradead.org, linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Brendan Jackman <jackmanb@google.com>, Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, 
	Michal Clapinski <mclapinski@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: A0A6A140004
X-Stat-Signature: z9p5e43ant4zoerzwx45c63r145bznja
X-Rspam-User: 
X-HE-Tag: 1776947144-44139
X-HE-Meta: U2FsdGVkX19UZOabXTQgiz1ITKY/UCtv3OoR3BkaLHy3pnd2jZB13KxB8ztsix5RmbCh87WaPq/0TgNn3iVqF/fVOJwC4DCTATHZ1ppPtziiqqNbmqx/Mcq2or1g1bLesScAoGp0Hr+00j4NqwH2d3iBMchSzu15Hi3TzCaQKBUSi6X/iJcHQw8hIJ/xryEe1XdumpeMuIQHl8ff34RynD6WS8QrJGMveqOmYgmJeMd4mBPPl8ApdA/7ud7eu2R65AVAg98O83WneKWFru16A4N1bYdT2XM2bmAwYDnO438OLLaXN2CFpyIYTCI/fe8vhPlYZc6s7Bv9KeuDji5kKzOLhwFCLZMlGpB7cBuVMt4oJG7gL9Im6Z/3GmZjiu6WopcM9g/Xrdoe6wjvPw2WAztvlnYj7+RV8OkMjWYOAXQBRlxqTZcldzsqWQyCYZ52Y+WE1M5GdDvsgG2LjEqZsMCD/mnXYcqEhQerDSHRDyMd9jQjqBS8gRWzn2oMTuYVaNQ6uvuyWTEudIGALBmmsqCRpuPqJRufdA9ZkEyXsQ9IsjCFjRjglC+Glk2WBrMaL7WI8buy44Y4NUvifHSo6gldZVa2uLEK5PtM4zeqz9mfeFj/nO5Awzprlzj0EIK3231WRyV3kKFjBZbpRmUAudCLpj77oz2Rjzh0+I/TW+geklgE1hJMKEFPoDnnkN/ZCnCJmWyeSfL2aI3oVr7Gw3C9K4Mw990dwSI5PU+elGCLmK9mqqMNVn69dqhtkRcm1gNSGVDItHuSSrF+YvutgnNOR6l9cOgKUtF/mQz/Hos/URTGiaDHJFkgnQuHgGZi/XrP94ebsYbkjyqgZOMSknCF80EqaxyfYJhQ6o7ItSv/oFVSKsId60YKeVgUm5CQaxLW2hi4VkNSUCkmfywf4RxrRK/CiEsVmuBCgSJLOVfDt0W/+h1Su3bp/b+NK4uoZeZfOM5d05bjv3+s/ol
 xqIUo3sV
 qtME2o9d8qPZORuSoRGoSOqqiwn0VGIz6iFLGBMRVdJeN0rdDcqZMLr2xYooiXlsPa79TMWdBhGrfQYei7gKUrDwmzjvOXYonQf+KyG9dL8VvNztNZ5VNzN3W+lbUGlW4uwqBDq7/aTN8YFKjNdf7ABuKx+Js9atSplk6fsBe5t0Bv44sRKijC+YfQn4tm3v7VZutjw4nd2x0hkjnQoLBz9M1aD0y9U7p2phmmoQyEb6LQKEJPXRxQBKh+W+dYTN7pLrBSedlHt2cFwfpXIO1XpaDblcWnte1E55+kB03BQrEw4RSdgRA3QYguHJW0MfPzT46NAxykjfQz7uKXMaZBWM2IV6hIpMpXqiFp5MT5oXDKN2iaeUHBVg98nrQj2aJ7LRXSapv9TYIu+IJ7IBjz+zWdLQEvDyNOxKcrzygicCydo8ctNvy9GNBP3f45nosoH0jarrvL1UBqGbzrn+6ZfOC4FJ8X9p1FCxH5/i8WrgZ8x4Daw//vMAIlY3qEBx5F+qHzwFvFcGwyCHmhFv3gXcROEtzvr+jHOAUDdxZ5/FcXldIW4tGQcwiZDHeinr7AU3ON725M12BHOkxwNeJm39Sl1BfR0Iv6o9Z2mE/ViHZiUHg/Enf9VHEEUrz6Bg9Aoo7s9E9CuAiAWHWGl3pVD/wZov7UXSI/5w9mqQWkIYa73LnYsc7Tx0CgwapVCcCd5H5LFFF0kWRFOSjbPhKZ7wvD2vouldi3llKdcbRJ0Z0if2pVC6qqU2wTu8rjHgxklC5
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When CONFIG_DEFERRED_STRUCT_PAGE_INIT is enabled, struct page
initialization is deferred to parallel kthreads that run later in
the boot process.

Currently, KHO is incompatible with DEFERRED.
This series fixes that incompatibility.
---
v9:
- moved init_pageblock_migratetype from memmap_init_reserved_range
  to __init_page_from_nid
- reduced number of ifdefs
- new commit to test this feature
v8:
- moved overriding the migratetype from init_pageblock_migratetype
  to callsites
v7:
- reimplemented the initialization of kho scratch again
v6:
- reimplemented the initialization of kho scratch
v5:
- rebased
v4:
- added a new commit to fix deferred init of kho scratch
- switched to ulong when refering to pfn
v3:
- changed commit msg
- don't invoke early_pfn_to_nid if CONFIG_DEFERRED_STRUCT_PAGE_INIT=n
v2:
- updated a comment

I took Evangelos's test code:
https://git.infradead.org/?p=users/vpetrog/linux.git;a=shortlog;h=refs/heads/kho-deferred-struct-page-init
and then modified it to this monster test that does 2 allocations:
at core_initcall (early) and at module_init (late). Then kexec, then
2 more allocations at these points, then restore the original 2, then
kexec, then restore the other 2. Basically I test preservation of early
and late allocation both on cold and on warm boot.
Tested it both with and without DEFERRED.
https://github.com/mclapinski/linux/commits/deferred_test/

This patch probably doesn't apply onto anything currently.
It's based on mm-new with
"memblock: move reserve_bootmem_range() to memblock.c and make it static"
cherrypicked from rppt/memblock.

Evangelos Petrongonas (1):
  kho: make preserved pages compatible with deferred struct page init

Michal Clapinski (2):
  kho: fix deferred initialization of scratch areas
  selftests: kho: test with deferred struct page init

 include/linux/memblock.h              | 21 +++++++++-
 kernel/liveupdate/Kconfig             |  2 -
 kernel/liveupdate/kexec_handover.c    | 52 ++++++++++++-------------
 mm/memblock.c                         | 56 +++++++++++----------------
 mm/mm_init.c                          | 30 +++++++-------
 tools/testing/selftests/kho/vmtest.sh |  4 ++
 6 files changed, 88 insertions(+), 77 deletions(-)

-- 
2.54.0.rc2.533.g4f5dca5207-goog



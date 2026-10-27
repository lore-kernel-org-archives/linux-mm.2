Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3CF21606A31A
	for <linux-mm@archiver.kernel.org>; Tue, 27 Oct 2026 13:59:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=hNHkCPcj
Received: by kanga.kvack.org (Postfix)
	id 43A5B6B06E3; Tue, 27 Oct 2026 09:59:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3C41C6B071E; Tue, 27 Oct 2026 09:59:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 28C716B071C; Tue, 27 Oct 2026 09:59:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id F3E646B075F
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 09:59:39 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 9BEA01A09BB
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 13:59:39 +0000 (UTC)
X-FDA: 85368564078.02.BCD2D0A
Received: from mail-pj1-f50.google.com (mail-pj1-f50.google.com [209.85.216.50])
	by imf21.hostedemail.com (Postfix) with ESMTP id EBE581C000D
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 13:59:37 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=hNHkCPcj;
	spf=pass (imf21.hostedemail.com: domain of charsyam@gmail.com designates 209.85.216.50 as permitted sender) smtp.mailfrom=charsyam@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793109577;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=Ze3hDNgAVXxR03vgb3ebN8Im6n2FcLAKEpCxr8ESZ/g=;
	b=0UHHtn0DRtJDFOqUNf9KMeXMXo9a46FX/zRjAfjteUzLkfAiI7f+GVte+ehnn6gifv/lKg
	r8yGrrHSHWHLztZrZQPu1j3yfHL6LNbsFY+ardtVNSquVChNh5tin/gZOwZ5f0HAo/tC8M
	rn7hMMZprkJ2usMf7HdG1aApfzJLzcg=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=hNHkCPcj;
	spf=pass (imf21.hostedemail.com: domain of charsyam@gmail.com designates 209.85.216.50 as permitted sender) smtp.mailfrom=charsyam@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793109577;
	b=hv36samVZY9ISEjvFMcyPalNBgqg8z600nQuRxeYEd+OJGrTa9lIDR8sZalDlSaIavUViF
	HjhZ7R1TPaZ4I9eBajzBPJsNOX2AqyDOvO9O6djJmSrNn/afu7TA4VdVQ6G1VnJgPGZBwm
	h3KYeZNCtJm2r8fEcauxtSyUfrZ1q9Q=
Received: by mail-pj1-f50.google.com with SMTP id 98e67ed59e1d1-3ad9c5b4dfbso500029a91.2
        for <linux-mm@kvack.org>; Tue, 27 Oct 2026 06:59:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1793109577; x=1793714377; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=Ze3hDNgAVXxR03vgb3ebN8Im6n2FcLAKEpCxr8ESZ/g=;
        b=hNHkCPcjnibY97lFG4CX6FIVrWnxzPGIMCG9CBoBWiEHk/wAtL1ZTGYYP527duPSDd
         XzDEl8Anc59x2wASyEmtp6nVe/fYN6OPD3VwQGqerW6kBxnpQh/sBm18Pkwo0CIG81FN
         D+yEVOXaN/+ZYzR+wjPe1lHch2x3ATlGOsA0HzkSdNvs/Ops/yh/BthKKtedgg7IMzUG
         MdTHytSf2o1EIKzGtWTxWESz+clHBtObOsxn/KWOBLzfFhLS6yXd/+qiZg5xYFGmQrzP
         aqH2cl8fZ2wbSk4Zu3sixFbmjeBxTuq1urmG0/c0EjF7fa92ciV+NX4ErxExwq9GPO2d
         aIaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793109577; x=1793714377;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Ze3hDNgAVXxR03vgb3ebN8Im6n2FcLAKEpCxr8ESZ/g=;
        b=x2qVpLToz14dbEhRfH3NHQYVcfW1pyY/6m8IuSDT8jtYvgL7JpY4RYZDPYzmePFRy3
         /WM3qI2w5ZNSYSkpMV/UsJym+q793lYGT2Zs2pVGb42DZcsw2qquqhBL2dBfwTyZoBrh
         NctKyEUh1QjzT+Pg3xQq/PC9ptReFmNQ2SU/uumLZ02h20bzHaucPzploXFBy8qW7fsa
         GuIEFsUfTeDDpuKmr1QEm2dQ4qClew7p+I2jfRLvx8xzIoZNDhxogZb1xCeiueSWKv2v
         pA1t9UsSn8l5Qz5pU/G66KvLibcpmXb9zRXSKn8iY1AMukcsojEm6Fa+HxguUE8p6iaP
         b8GQ==
X-Forwarded-Encrypted: i=1; AKwUvBz42VxmOmmm4T+Kae7ZsmAmSj1L/5SoD2Nk6iexjWSXdvRESwDE+hOGlychBtg/N4tJahd/A6BRGA==@kvack.org
X-Gm-Message-State: AFq9FYJ3BEi5sm2ISSKmOFdeeHEIwb9RMCVrURcmqgvaxAamdzOcSDh/
	BNhodxhNf2TRK0PptQ3BQzs059q4ANooCOoxaC08o2Q32PRIZlhnMjr4VvUQ7z9D
X-Gm-Gg: AYBFou30WJNbtVuHS88UxKSVm5Uf62D8uGJ+qAQ0xn/7DJhoriiFtPt2gP5eLvwwNUf
	ADcbcTgvWK2TWlMLIME1f2edZvPTKCzR3nuqyPmB5BQ7/8jBDmHNXWAKA9ZIKvVFEfxh1xjHsJk
	rsjQdHVgK0zyGzsGYDUojXH+N9f6AuQlfVRY/rAkgSgL9m5sqzBNr+4zR7owrMqcSdw6MKVihBU
	AfjUmPYLMMbQB4gCoHjrA6LUQlOlUbafumGHoH9sbsmcEziqjTO4A9BgU6fy1bk1D18mZbZXTwe
	XCS0RF+k2D3JZLXfbtf1SBEhx0uR68lVt8ImnFUOPQMY2ZS7ONuqPXcq+GUeO3BJTej66DjfvdF
	NPFUfm/CwKka4LRbsrZ/H/qmP6Vx7fZF0tYKXFdD/PpwCF8dChh3oihJOZ8noxQF9r9jpWWP3Gd
	QfPc3s4An2WwmqUugU4BYEn4+pyKqUXUrEiHpt7dJJ3pA3GK6uEklBu3dFlDyRWgKjhzCd88IMG
	IADeHhzVmF8AT7UxjC/Z3A6b09u8bgnUkiRWVv8khTH8Q0W
X-Received: by 2002:a17:90b:28c4:b0:3a6:f1d2:57fa with SMTP id 98e67ed59e1d1-3adeae5dd2emr12875632a91.4.1793109576511;
        Tue, 27 Oct 2026 06:59:36 -0700 (PDT)
Received: from ser8.. ([221.156.231.192])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3ae404432a5sm4243466a91.9.2026.10.27.06.59.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Oct 2026 06:59:36 -0700 (PDT)
From: DaeMyung Kang <charsyam@gmail.com>
To: SJ Park <sj@kernel.org>
Cc: damon@lists.linux.dev,
	linux-mm@kvack.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Asier Gutierrez <gutierrez.asier@huawei-partners.com>,
	DaeMyung Kang <charsyam@gmail.com>
Subject: [RFC PATCH 0/3] mm/damon: fix overflows in score and ratio calculations
Date: Tue, 27 Oct 2026 22:59:29 +0900
Message-ID: <20261027135932.2301646-1-charsyam@gmail.com>
X-Mailer: git-send-email 2.43.0
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: EBE581C000D
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=4.0.1
X-Stat-Signature: jgefidzuh6tmp5xkj6ceasn59irsgwbm
X-HE-Tag: 1793109577-861532
X-HE-Meta: U2FsdGVkX180fbrzTbO0Hi9LEdg74exj4fQPKW+P4Xgb+XHv+ursnlEoIQaaxwFljXk/XRggQK2hxcBnmEhzitx8XYzz6YhMgOARcLbTOD2q2h3jbAa5ypqHkOC49PnFrv9nu6pF/RGaBMSyRsK9Z7+85FNSTvHv/0ZpwM8PLQjm3xGDd30dmr056j4loRZyFtVq5gmoRbHxoZ+lPSA7Fp/qq8Vn+Ryf0eb+RnmYhhNHnSnJ3IhlQ9iR0nHqH5HQ9dC/mfioqBML5YL7wg/w5pshGPUNQuWOyrMthaKuuxzo+tNlVfNCfPGirsWCp2GuXvKUUkTnc6RHuk+H8t07XyMQkn2/qzcZs5FLWm063az2naw+40Mk56NqZgGy5sjfID+yU2gInnZQoWWVqXBAW64UuzJ2rDmZPKuLZSZhY35oJpy1kkTgLrnifTsOtZnNzTnl/4ENFYZnTFNgflb149dW+c5n/Y9j4f53Natz64yKGLe5L2KopdODcac7bTtjK7b/OBXo5Q360iaZyCfE+c5e4IDt2r2rSdXBXrCozM8A6VcMuc4iB8obSxLQgsvA632VgfnjfU5Ot0DMJy+KCStLupUQ0wYhO+padw+j8fuVqlU+nRRXuvRDDDIHsT3bTHpt9O0Sn9OIkMXoxHXLnEntWDCxL4lapI8euXPdaIU361JueOoGXzLW08CfFQQj8GCARKi83gyCtSEgGNoBOhgsFZwWnZEZWvqi4Vs6CMK0ISDEEE7kbkvoJsHhpUDLfHXcn9srzlKrTFpX5pA9dFOA5awRfAx6VKrdGybv2vxyZTbb79Zixfh4cVnbttrgp6UwT19dZjIKvu8UbpaJFciiOegjXIjmzNNqOSXmxBlhg9QdI3MdxRNaC94hDeXsBEHFKhQ3em//sbL+BmtnrXxrmst3007zrLSBzL/7HN/6IQqv29uAk/IOHbeed3yQKkKmfUAeE7/2kMbbsHp
 z9IsaTS7
 Ymq2Zm6GxjvU1wuvfYTOHqMRsJArKPaw5/jDA9uS2OMqJLt7CJFm0JJE5c0Wnr7bbdAAnkTCTU8zgurJnfDW965j9TL5bFoD9YIglFM2F/oFL/gzYe52RVdIBcO6SWhSK+ggH5I+NLLrZ2Pl8yIaGZO9laXbOcCTf/5Gw1/sBVt4SFrTFYeGcKnhCQ7/PokuTuM8xuukoa4Jk29yqwZNfLoc7LXnGIgUanIfUxqZFa2qlBEhHKgHiLyDj3369szwrymOiMOlsKOuShVsA/WlDx5ou7KVb4zrZAkNaf3rC0T1RCLn0sa4EtkW7HainlvndHn88/myguZxWRZegWlSdRDTEwPV70ZWpsvIyzKh62Ia1fuXDuHO5JhhCflQbJqEcxr9V76Bt1p7JAHadIKBX9x3Beg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Sashiko reported several pre-existing overflows in DAMON score and
ratio calculations [1-5].  This series fixes them with wide
intermediates and an overflow-safe mult_frac() variant.

Patch 1 fixes the weighted hotness score, which overflows with large
user supplied quota weights on any architecture.  It accumulates the
weighted sum in u64, preserving scores for non-overflowing inputs.

Patch 2 adds damon_mult_frac().  It returns the same result as
mult_frac() when that does not overflow, computes the remainder product
in full width when needed, and saturates results that do not fit in
unsigned long.  It fixes the region age and sample ratio conversions
for new monitoring intervals, and the moving sums of access counts and
probe hits.  The helper is introduced with its first users so that each
commit builds without an unused function warning.

Patch 3 uses the helper for the page based memory ratio quota goal
metrics, including the hugepage metric, and for the quota goal score.
The node eligible memory metric counts bytes in phys_addr_t and uses
mul_u64_u64_div_u64() directly to avoid truncation on 32-bit PAE.

The remaining mult_frac() users, including the intervals auto-tuning
score that has an ongoing discussion, are not changed.

I am sending this as RFC to ask whether this approach is preferred for
these overflow issues.

The DAMON KUnit suites pass on UML, i386 QEMU, and x86_64 QEMU with
NUMA enabled (54 tests each).  The new regression cases fail on i386
without the fixes.

[1] https://lore.kernel.org/20260623141527.044D11F000E9@smtp.kernel.org
[2] https://lore.kernel.org/20260708140944.F26821F000E9@smtp.kernel.org
[3] https://lore.kernel.org/20260901133650.EF4F71F000E9@smtp.kernel.org
[4] https://lore.kernel.org/20260626002448.975E21F000E9@smtp.kernel.org
[5] https://lore.kernel.org/20260831184956.1DA321F000E9@smtp.kernel.org

DaeMyung Kang (3):
  mm/damon/ops-common: avoid overflow in weighted hotness score
  mm/damon/core: avoid overflows in monitoring results calculations
  mm/damon/core: avoid overflows in quota goal metrics and scores

 mm/damon/core.c                   |  59 ++++++++++++-----
 mm/damon/ops-common.c             |  10 ++-
 mm/damon/tests/core-kunit.h       | 105 ++++++++++++++++++++++++++++++
 mm/damon/tests/ops-common-kunit.h |  47 +++++++++++++
 4 files changed, 203 insertions(+), 18 deletions(-)
 create mode 100644 mm/damon/tests/ops-common-kunit.h


base-commit: bae9a042b03b27924c6fd5bdc00a20d6a44d6041
-- 
2.43.0



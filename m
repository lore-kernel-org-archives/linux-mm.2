Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 716EFCAC592
	for <linux-mm@archiver.kernel.org>; Fri, 19 Sep 2025 13:06:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D04348E0003; Fri, 19 Sep 2025 09:06:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CB50F8E0001; Fri, 19 Sep 2025 09:06:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BA48A8E0003; Fri, 19 Sep 2025 09:06:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id A6C408E0001
	for <linux-mm@kvack.org>; Fri, 19 Sep 2025 09:06:33 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 556CF160693
	for <linux-mm@kvack.org>; Fri, 19 Sep 2025 13:06:33 +0000 (UTC)
X-FDA: 83906023866.11.61B7A02
Received: from mail-pg1-f177.google.com (mail-pg1-f177.google.com [209.85.215.177])
	by imf19.hostedemail.com (Postfix) with ESMTP id 84E2A1A000E
	for <linux-mm@kvack.org>; Fri, 19 Sep 2025 13:06:30 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=bsXi8SPc;
	spf=pass (imf19.hostedemail.com: domain of linyongting@bytedance.com designates 209.85.215.177 as permitted sender) smtp.mailfrom=linyongting@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758287191;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=5Y44nOyA0y8OwFwmSdVnNikf+85sx5V+uPvR9b6gSko=;
	b=as46hHrYwFhR8w0myRRlmovhbSXIxoC2t4Is6nBURZDA4io5JRZCJQ0Ty6PqpQkl0s0ukD
	MtkgJIned408MwouycRTk9t6oZQXmfuBvHGhoRJ/fJ6666PBT+GSngT4E1cMqyU8KorbUQ
	5guc3FlvsqQi9D744RyVxgCuBtnbAd4=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=bsXi8SPc;
	spf=pass (imf19.hostedemail.com: domain of linyongting@bytedance.com designates 209.85.215.177 as permitted sender) smtp.mailfrom=linyongting@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758287191; a=rsa-sha256;
	cv=none;
	b=HZGPHI3prZ4JGECqAM6PeEXEHxwXyhsSMtOebaHYaOqxuT2kBTJgKDxmHX4rXkF5Cvr6d6
	Ggvflh1QMmXoCY8+UikMQNo7tpjPFTWTD9zaGdljYTmaTCl4H9RSPVxKReaYlGftDbeK6N
	+G+nymQQmxIN4Tr9hv3aCJZl1cK6HWE=
Received: by mail-pg1-f177.google.com with SMTP id 41be03b00d2f7-b552590d8cdso348689a12.0
        for <linux-mm@kvack.org>; Fri, 19 Sep 2025 06:06:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1758287189; x=1758891989; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=5Y44nOyA0y8OwFwmSdVnNikf+85sx5V+uPvR9b6gSko=;
        b=bsXi8SPcWuDznQayNbr2cDCh7AOlrHMtabCKM2bv10xrwb1MzeIGI/W7VzF07/qEDm
         DPLvoNtsbOql7JgKfpzkjrTm/IQK7xu1T9bIGDbbqLMuA2Z//XkOG44ppCF4QZa/usYm
         hll4PqZe1lSqJhVhmdg2RlK9ikrHpcutEJrPlDjJqk/WY+dVcUXknnNwebfdZmYhY8VJ
         QwL4xIwIaWwYVns2IkdidKhq431j4Iu+1EBeWbzlUw+8+ajtTAAGw6sJIK/yhFDMRLLF
         p9067nfGS3sG4CfmmsX5X6E6XGsd1+jos0TkpNpG8Lv9pF4yqYZ6bt28UH3pRQ4bXchG
         rACg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758287189; x=1758891989;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=5Y44nOyA0y8OwFwmSdVnNikf+85sx5V+uPvR9b6gSko=;
        b=H+K443SmhYgaPKxd99lAH93/CEK9dCmCsn0Fd/QWWGp5GnV+DPiT09LxhF37fMSoX0
         n7ZokP+7N6okGaxpyaxGQfYTboJkGvz21NcLWBsaTuaZaBfYZlLNhGzHUqAeaZ5RsGtf
         p+GVblCEEmwCzXPpk9k5ipgnV8klCO7I0ouqIQZxDomjA2hET/441vb5PytwjGjabZfm
         m1noCcY7IAhRFX/0LzaQx5MQnoLni6q0mIVvZ3RQjJM8SBA5s1+Z1agS5LUblCehP+I1
         8yQOusAzk+ja/Y3RwgDlYoiKMSdYJQ70dO+upMUPIMnL/LNrpH2BzG4GXLcnxMmnOHba
         GlYQ==
X-Forwarded-Encrypted: i=1; AJvYcCVz8zCM/2G5pc9nVnutfKweBrP/e4WP/GLtkkRiaMJiAnPQKXQz3LN4Ci1iiK0WCM5A7saYvv1x2g==@kvack.org
X-Gm-Message-State: AOJu0YwBUP7IM4DNMQiMG8Btpbgbh3zFlVXL5y8zFGvUHUUNHyUskl6C
	wicfvaSjRDqdDgJD4T/CVKtDPBlpuRjZgqG9qvfhlOIzh4+hPghrsNl7m3wS5qAjU8I=
X-Gm-Gg: ASbGncv2cJLxvrUnGbq9ykufQU7WBF38Jbg4bo+56VCA8aZ5rVg3lHeZW/r0G+4S/GK
	7sueI5K7Zec2I82lAKpeQoqETcijTNCuyCPTSBZXaXE567D6cFiDUMpAgq0UJOqm3KmnW9dzSJ0
	gqphEKo0U3Q2sjrGdIHXhLSVh2ULJe1RZqeucbdhAfNip54spLtpU4IzOLY2+cUvmPD8tfm2V+2
	DHDWnXVCza1W9y22CCrRbFL3EubABeoMik3mIvhdnwcB98iWzlBdwEaDiKJfHwMpAXolBFuIg7G
	P3VOGCHEBQO1Lb5hPB/D2EMONV4jcNac2YPWxz8myHHNB8H+w9QBGn2gzTe/+Pw/OuITaVPQWHP
	zvYlyxqR6qd1Bb1vNulWbYmM1GOsiufaSGAe/7faVBV+rj+8=
X-Google-Smtp-Source: AGHT+IHbCYvgUOcFkkck27B0rfSlhrmfVapbla8Z6az+fBKLroeJB8snmFXCKURB5BgfWYqSEvjPWA==
X-Received: by 2002:a17:902:e946:b0:24b:4a9a:703a with SMTP id d9443c01a7336-269ba42b2a8mr46541595ad.17.1758287188922;
        Fri, 19 Sep 2025 06:06:28 -0700 (PDT)
Received: from H3DJ4YJ04F.bytedance.net ([2001:c10:ff04:0:1000::d])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-269802e00b3sm54732065ad.90.2025.09.19.06.06.25
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Fri, 19 Sep 2025 06:06:28 -0700 (PDT)
From: Yongting Lin <linyongting@bytedance.com>
To: anthony.yznaga@oracle.com,
	khalid@kernel.org,
	shuah@kernel.org
Cc: linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	akpm@linux-foundation.org,
	linux-mm@kvack.org,
	libo.gcs85@bytedance.com,
	Yongting Lin <linyongting@bytedance.com>
Subject: [PATCH V2 0/8] Add selftests for mshare
Date: Fri, 19 Sep 2025 21:06:13 +0800
Message-Id: <20250919130620.56518-1-linyongting@bytedance.com>
X-Mailer: git-send-email 2.39.5 (Apple Git-154)
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: nt7n7nqh9baidyswwqs188gnie78o78b
X-Rspam-User: 
X-Rspamd-Queue-Id: 84E2A1A000E
X-Rspamd-Server: rspam04
X-HE-Tag: 1758287190-221294
X-HE-Meta: U2FsdGVkX1/S+pAkn6bbrqViLE60rrUOmJbICRTncEXd9VIEBQhTYLOLznOVxXE4lRlDALWgk6oMhQhddAt21POaC2shngSQ0NJHymvV11CxN9siKiMFnER4bpey9bPEGxu0QSrMJcp2U7xEh+/jpsBA87B8nw9gfUC5PNDQ7qiYM+DRXnfluMeEO+eXJaPmhGBPFEX489bWWNyTo196ooufRM0Vt1iyrv33n0Ag/LHL1ke5UzJO36u4X8OTyL2EScOc3RpvOEeHZHZbsEjOwGPr3GvDmwvLFeG7pJFHLurwcH2DnRHkGO68mg8YM3m0YwMwHsWecU6youTpTTXrze7KQ+C+oaZ4LKP+jXGv6Nb7fG9rGb5GUgnLmDsRrdBtd2WyFHl2ZPJKTT/7Mx+hHbR0/BkqKgA8pS3PmKzyTGjIqaQmisPj3YrzswbbAaMDTiyEcD5YMYy94Sf+ChPg+Prj+c+f3l3v6X3lBqF0Dv+uypWzF3PdsP+C+0h0oURyf0UJ7Tfs1hmsNq6MvTOjDGnsXU4Svi56kY1eYA4STeCnKGM4TRMPrELzikHNGK/qr/xM3DAdEOIgs6wPtpVncXevoisVVL9RMziYha6jPL4p5TxREj7OTUzoG6ti/wm99enWttgMqgUKAB2Rlrt0DjVJ4S/e6dVeEbDJnp5c/DcymR4w4W0Q4fPN02NOMZoh8LxwYj0+yT7tY9WUZh8lpVVH21lYM8aFwOZJY/Xv53Jj39hfbO3h65z7NqCA7m8cFpkD8EH4BJmuieLXxesV3goRj0Wq8UN5M0roizNoH5+5rI6tk2sa0ty/VFN6xTiMWp/z2tokxeun0nrV+GTcuIrZ2TkGkoQSMpmmTks8LsxkLDNoXH0ZkE9IsF3pTb6soyQdj26lOqa2AyE1TuphhTzznNZD2NzsIn244x2PDmZ+FlUbL+zQh7WPnH9x6lGwYLeNLJ0MakXghTQxprw
 IUn6Kltr
 FlQuqEq9/sCn1f2AEgWRsaOhTNOMb6+CioASxfC+QL1TThYuKEXCqnV5w5GEIjJZI5tIvi+/BMZM2HdSEc54jyeBjJFxStF9/3Mkzm/oZn0j74FrdWVy7TKEM/t74m8LeXzXNFCrnz/KhuwaL2b7rYJBJ8Yhh1BourTa9aUlvL8u/q7C77c6Tex8deKy/V0ZaJYw1qgywTZwDB37sM2z5xHexjC8gkGy6m/JbKrWwVe0+A3dzFbK+z75KR4FrYgj6CPOgOzyCoIWuo5XRZVAqtwCyBe6tLgfTe0jDF1N4NoDDYC3vSVYSuV/UXO4rZrts+vYYdqAaMrS4VZC2kliyVov9lRhRd3zjSwV89reUQqarqTA=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Mshare is a developing feature proposed by Anthony Yznaga and Khalid Aziz
that enables sharing of PTEs across processes. The V3 patch set has been
posted for review:

https://lore.kernel.org/linux-mm/20250820010415.699353-1-anthony.yznaga@oracle.com/

This patch set adds selftests to exercise and demonstrate basic
functionality of mshare.

The initial tests use open, ioctl, and mmap syscalls to establish a shared
memory mapping between two processes and verify the expected behavior.

Additional tests are included to check interoperability with swap and
Transparent Huge Pages.

Future work will extend coverage to other use cases such as integration
with KVM and more advanced scenarios.

This series is intended to be applied on top of mshare V3, which is
based on mm-new (2025-08-15).

-----------------

V1->V2:
  - Based on mshare V3, which based on mm-new as of 2025-08-15
  - (Fix) For test cases in basic.c, Change to use a small chunk of
    memory(4k/8K for normal pages, 2M/4M for hugetlb pages), as to
    ensure these tests can run on any server or device.
  - (Fix) For test cases of hugetlb, swap and THP, add a tips to
    configure corresponding settings.
  - (Fix) Add memory to .gitignore file once it exists
  - (fix) Correct the Changelog of THP test case that mshare support
    THP only when user configure shmem_enabled as always

V1:
https://lore.kernel.org/all/20250825145719.29455-1-linyongting@bytedance.com/

Yongting Lin (8):
  mshare: Add selftests
  mshare: selftests: Adding config fragments
  mshare: selftests: Add some helper functions for mshare filesystem
  mshare: selftests: Add test case shared memory
  mshare: selftests: Add test case ioctl unmap
  mshare: selftests: Add some helper functions for configuring and
    retrieving cgroup
  mshare: selftests: Add test case to demostrate the swapping of mshare
    memory
  mshare: selftests: Add test case to demostrate that mshare partly
    supports THP

 tools/testing/selftests/mshare/.gitignore |   4 +
 tools/testing/selftests/mshare/Makefile   |   7 +
 tools/testing/selftests/mshare/basic.c    | 109 ++++++++++
 tools/testing/selftests/mshare/config     |   1 +
 tools/testing/selftests/mshare/memory.c   |  89 ++++++++
 tools/testing/selftests/mshare/util.c     | 254 ++++++++++++++++++++++
 6 files changed, 464 insertions(+)
 create mode 100644 tools/testing/selftests/mshare/.gitignore
 create mode 100644 tools/testing/selftests/mshare/Makefile
 create mode 100644 tools/testing/selftests/mshare/basic.c
 create mode 100644 tools/testing/selftests/mshare/config
 create mode 100644 tools/testing/selftests/mshare/memory.c
 create mode 100644 tools/testing/selftests/mshare/util.c

-- 
2.20.1



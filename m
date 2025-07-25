Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 44471C87FCA
	for <linux-mm@archiver.kernel.org>; Fri, 25 Jul 2025 16:23:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C8CA66B009A; Fri, 25 Jul 2025 12:23:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C640A6B009B; Fri, 25 Jul 2025 12:23:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B53546B009C; Fri, 25 Jul 2025 12:23:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id A2B5E6B009A
	for <linux-mm@kvack.org>; Fri, 25 Jul 2025 12:23:03 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 555FF140874
	for <linux-mm@kvack.org>; Fri, 25 Jul 2025 16:23:03 +0000 (UTC)
X-FDA: 83703306246.29.FA681DF
Received: from mail-qk1-f177.google.com (mail-qk1-f177.google.com [209.85.222.177])
	by imf22.hostedemail.com (Postfix) with ESMTP id 84BFEC0005
	for <linux-mm@kvack.org>; Fri, 25 Jul 2025 16:23:01 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=I3NvyDFz;
	spf=pass (imf22.hostedemail.com: domain of usamaarif642@gmail.com designates 209.85.222.177 as permitted sender) smtp.mailfrom=usamaarif642@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753460581;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=tsRvKxISNRBPG2Kb51ym8LU6IwShBIRfDNgq3e6HRCc=;
	b=hxts5sB0CyfuMb7vXLlJyn00tRYBIQZhyLV/NIIjPt3ETYOyN9fM92yc5pkZ3HojsbKj3E
	LTWwzU2A4QCbalvueVzCQKQNhVHGS/cYE0n9ebb47W5e08VK2WL7uYLzOZB9X+d6DKa9KL
	LddlU4pVZQ6bbwP2tJQC2ziRSWLC+XA=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=I3NvyDFz;
	spf=pass (imf22.hostedemail.com: domain of usamaarif642@gmail.com designates 209.85.222.177 as permitted sender) smtp.mailfrom=usamaarif642@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753460581; a=rsa-sha256;
	cv=none;
	b=uy0cfjvpkkLSj/J9bFFh0eXL2npwPkzCMABwmm2YiYyD3nWCJil53V8NQJlgv8lVZcl1Zx
	OewMwNjVKA2v5Rw5cTTxjq4HhZl2kGZRIOylRSwEM8gxTg6DkvQHCKfr9H2bH7cvp9Eo81
	1MMU1AJ/T1mtAUsVvz2LwibPuqSwY8Q=
Received: by mail-qk1-f177.google.com with SMTP id af79cd13be357-7de159778d4so221274685a.1
        for <linux-mm@kvack.org>; Fri, 25 Jul 2025 09:23:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1753460580; x=1754065380; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=tsRvKxISNRBPG2Kb51ym8LU6IwShBIRfDNgq3e6HRCc=;
        b=I3NvyDFzaRBiGoCqbimkLEUwlZ67vDlFjEyCn0XJ6SXOvyWnJoCa3ixjEeupF0+dCO
         xiRuzedeVO/UYZ0XQzz0Jpf1JSrZGk52Q8SuUjOPn3weTjqlbo/uB0+oO3uSmcbEUA6D
         uHt+VV3T8zqyRBx7mXL6RsUdl8KfEhIczWr0jdkqzke1io1NEJDquTNVfl4kHLoL2AED
         AffOdOruELpZxfTMPhz+BAFxzGU1tpkoXiXkyhr0h7g9MbpmO3Gk9+pHqBtntzuBk3Yt
         iwEQ4NJdTFW7zItXe5OHbLnDmlBl7QB9jeD7fjgMLnFEdHeoHKV9QGKuhyK3wQ8D7R4p
         skpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753460580; x=1754065380;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=tsRvKxISNRBPG2Kb51ym8LU6IwShBIRfDNgq3e6HRCc=;
        b=toaP9+NiLl5GJXSdrOQ/m2tWcrVXYf+/MvCKaRK+mMfem6a3B1ARvKSdfiYvLPQDI/
         XvxP2a5LV7pkp47tGDnvP6b+HU3BTTD4WfyodWV9g2ngaTD0+0M6d/2X+Ubn0wTqJI2u
         9wOmWmJc+DGuO3iObGhFdm9aZnP6GHCRNv6p9doQ1Pii0h1rwJR3vLi2bcWuYkdJFf8F
         tY4OIBA0pk1TZdyGgeclubzrER8o2FQ1I4kU2sQICag/6B5mkogaRo0Cdn2P9QrcixdH
         4Ff9i5kbXjgbK2+mLTV889C+DJ3vHs/ztei08B9t1pweDGEGcALypzv/ddQ19blVLdzF
         h+PQ==
X-Forwarded-Encrypted: i=1; AJvYcCUuUOI3xDpQIw/V4S0cTSUnuvN0V/nONruKU4qV4GX74cFNj1dSIKnM/hSOSs6iq1NJHaQLY3mCgw==@kvack.org
X-Gm-Message-State: AOJu0Ywhy/VsB6aocm/S4wS9kDNFdhjH1mk/nZLWWsDLrolTGrmCcjl0
	wnu2p3CLv3HCxurqLo84wSgd/hq8oHKgUn+476SKkhrTGKq9VhA4/Y5F
X-Gm-Gg: ASbGncvWN1o6n5VLXyEk797lAaanKlb/QpMYrLDq8AtTtF/2iTAGkO584jYP554EVat
	+wbBgk9cvVItQbnc80OFGbXHS9gckiOU+Jwl1wmFiXh9lh37n8/nSIPRIH479obkNJPboNCwsgl
	Iin+Hv40nAuA6A8jWnMc5tmjgQo6TxuOgq9m84xrKntC0ViqRPwtGHj4lc3cvG6UWX0Th5dkwL9
	PKbeK06TpogtqCeiO1yQLA5zfhy9JLH3WsQBpOQuRWpqmtUc1tFlImSNjrDkEuUqDigk3+zH/b0
	7jk4MhI401C6BP6jYaFaIzns02htjlBurfkQJ+6p1N72BsH/qpCRcxJ6e9fwcupISTsdFrx+K+y
	3cetsIoJB1NG2LnhNem9mJSCFiC+PY1E=
X-Google-Smtp-Source: AGHT+IFUPOXO+Rx3b3L9FWMojxy4UgYsuqor8FhdRVAZKo4WeQbM3LrIA/dgX9xaRGdAcSqcaoHl+g==
X-Received: by 2002:a05:620a:2892:b0:7e6:21cb:c331 with SMTP id af79cd13be357-7e63be53012mr329207485a.5.1753460580101;
        Fri, 25 Jul 2025 09:23:00 -0700 (PDT)
Received: from localhost ([2a03:2880:20ff:74::])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-7e643878eb7sm13556985a.46.2025.07.25.09.22.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Jul 2025 09:22:59 -0700 (PDT)
From: Usama Arif <usamaarif642@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	david@redhat.com,
	linux-mm@kvack.org
Cc: linux-fsdevel@vger.kernel.org,
	corbet@lwn.net,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	hannes@cmpxchg.org,
	baohua@kernel.org,
	shakeel.butt@linux.dev,
	riel@surriel.com,
	ziy@nvidia.com,
	laoar.shao@gmail.com,
	dev.jain@arm.com,
	baolin.wang@linux.alibaba.com,
	npache@redhat.com,
	lorenzo.stoakes@oracle.com,
	Liam.Howlett@oracle.com,
	ryan.roberts@arm.com,
	vbabka@suse.cz,
	jannh@google.com,
	Arnd Bergmann <arnd@arndb.de>,
	sj@kernel.org,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	kernel-team@meta.com,
	Usama Arif <usamaarif642@gmail.com>
Subject: [PATCH 0/5] prctl: extend PR_SET_THP_DISABLE to only provide THPs when advised
Date: Fri, 25 Jul 2025 17:22:39 +0100
Message-ID: <20250725162258.1043176-1-usamaarif642@gmail.com>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 84BFEC0005
X-Rspamd-Server: rspam06
X-Stat-Signature: rtarenon9t61akq1gy4igrzurtn1s7mh
X-HE-Tag: 1753460581-586341
X-HE-Meta: U2FsdGVkX1+Ia3mLExJs+KjanYESPq/o7yDCybvALQmwWpFAuO+dDhFmUgbyUnz4YNK7YRK2GvIpbjp9VrkDEHCOKZSXnGK1bUfVmUjdzXQdf4+SgA7L+dbINBh8m3CNgjiF3ECDliN6EgFIsXQsteRR7YMmFZO78VAxhTy4zUvqZ894G5YkfTYr0/YbCZxvHrqySGYnHtFV1dBQ1NZb028WPHW1H274vrvOtA14i6A5/YVDsylFxpCQuG7VXfePamx27DaTlaWfXGBIHkI3SQljnoEaKVY81wiM3Z9xRw0MQYAlbD/F1acd5b9WdbvUScGvtzaKZ+tGIxWdYMjJdOuOO2lry38ATG4UbkrbqXi9rwk51ulXeG3Lvz8WujTLXlQNyU6MiK0Ld4yIulk7wm6p1UOBLWl/XoHE7xtxc2wRfcDTmFyeHK/FARM+VvQr71Lx8aaRCSCkl7xSXJJEOdIuEg6VSh95EQ297LQE59Ict6pKWvQTcdxb+KZ3YKu53hxh5iUtI759Bl4lLLO9hDNkDP319/d5vUKdiPb6VtbD182Y7jfLE4knUgiosh0vMqHz6wvRulveoBWiRVOFjbHPPg62JQn8XdiX102SmC5URJbvUWLJJJhLR2Hqqy5OZ9A+KBn8l4QtEFhwwAe1MObQYJ/rGeHGOg0G0MlCSquZ0Vd/px6cuhhriYq2PAFr84+Ot46azbj67hS9N7/SdhBRD3xCFvsXT7Bd5TMO9FN04ptAKyoSdBIS7dHZ5BU/FTqTtyKgP81q9EmfSIKRGqQDnsz9EoJ9crLTuppXuyD/XgO9H5u6vj4sk572MN5+F0svXMg/dmd40UoCr4g1LQh0JHjw/utbb4eSqsQDWZNDdvXokJwlfwzqR4rA4SbYTjkpQw1NSCm52QAcLAzLEkAGuKD9XmkVDdhGraXxQJrQsRgh/hr3htuihXcYDJjoFcHnQdgfp9FSev/uDsA
 +rV6MlO0
 PbNq/2hgASnw39KCgHM3NDpGrzS2P6fA0BDfzd8e23mKgdkx/2lbo7YkYekSfMZwbjcsGV3cZ3ersU33vXQ8NFUXNj6ksqhbjIWsgNFO1OssYM7Ml0zEnsFQhxE87FgkmDi4UnQ9P0PI2swSIiGol8a78J1/i/4imwJ8g+MlG32FIzAm84nszJzruAFkWbk0X0FBKnV6+JSTkLqIlrF7lp++3R7OsGBKZ3WhX9yoFTKCUSJXh9aFJj8Yalyg5IymaEYbcQQHjnQuE0PlpKt9VNqNlB2gPtWC0E29XQ2AUoKAKVSJRpV+tLW5WmODUGmqzC3af2xeK1FSlQzH3PZZgj8ivi9KNfTjwoldE+yEdsXArvTua0ycr0nrKxkWpVpGk+oA2RAJYwXP8SohY63QnLHOvheWk5Xm+XvMjtA+K/tthcehsMvU47Rs+koIM1CFhsRPdLydkgVcBDT7SHVZDGC2barYXXeXH6cSpfx2vyTMG+nsduXwqvfJIlWi5WWEpKXUaJ7X0I2Y1vpq8oxtP7H+r/Q/WKt6k5oeoiaX8qocW5sqmvX63WmvjH77aBYE1dPAgCbMPTDm/gxrUfdpgkPcGs6haXJUYk0NksunPCAVE7FXxeDzKD3IjYw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This will allow individual processes to opt-out of THP = "always"
into THP = "madvise", without affecting other workloads on the system.
This has been extensively discussed on the mailing list and has been
summarized very well by David in the first patch which also includes
the links to alternatives, please refer to the first patch commit message
for the motivation for this series.

Patch 1 adds the PR_THP_DISABLE_EXCEPT_ADVISED flag to implement this, along
with the MMF changes.
Patch 2 is a cleanup patch for tva_flags that will allow the forced collapse
case to be transmitted to vma_thp_disabled (which is done in patch 3).
Patches 4-5 implement the selftests for PR_SET_THP_DISABLE for completely
disabling THPs (old behaviour) and only enabling it at advise
(PR_THP_DISABLE_EXCEPT_ADVISED).

The patches are tested on top of 4ad831303eca6ae518c3b3d86838a2a04b90ec41
from mm-new.
 
David Hildenbrand (3):
  prctl: extend PR_SET_THP_DISABLE to optionally exclude VM_HUGEPAGE
  mm/huge_memory: convert "tva_flags" to "enum tva_type" for
    thp_vma_allowable_order*()
  mm/huge_memory: treat MADV_COLLAPSE as an advise with
    PR_THP_DISABLE_EXCEPT_ADVISED

Usama Arif (2):
  selftests: prctl: introduce tests for disabling THPs completely
  selftests: prctl: introduce tests for disabling THPs except for
    madvise

 Documentation/filesystems/proc.rst            |   5 +-
 fs/proc/array.c                               |   2 +-
 fs/proc/task_mmu.c                            |   4 +-
 include/linux/huge_mm.h                       |  60 ++--
 include/linux/mm_types.h                      |  13 +-
 include/uapi/linux/prctl.h                    |  10 +
 kernel/sys.c                                  |  58 +++-
 mm/huge_memory.c                              |  11 +-
 mm/khugepaged.c                               |  20 +-
 mm/memory.c                                   |  20 +-
 mm/shmem.c                                    |   2 +-
 tools/testing/selftests/mm/.gitignore         |   1 +
 tools/testing/selftests/mm/Makefile           |   1 +
 .../testing/selftests/mm/prctl_thp_disable.c  | 257 ++++++++++++++++++
 14 files changed, 394 insertions(+), 70 deletions(-)
 create mode 100644 tools/testing/selftests/mm/prctl_thp_disable.c

-- 
2.47.3



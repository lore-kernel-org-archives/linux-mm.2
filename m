Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 23311C87FCC
	for <linux-mm@archiver.kernel.org>; Thu, 31 Jul 2025 12:28:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A7A438E0002; Thu, 31 Jul 2025 08:28:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A2B388E0001; Thu, 31 Jul 2025 08:28:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8F2B78E0002; Thu, 31 Jul 2025 08:28:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 790D88E0001
	for <linux-mm@kvack.org>; Thu, 31 Jul 2025 08:28:33 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 1FA6BBB3E2
	for <linux-mm@kvack.org>; Thu, 31 Jul 2025 12:28:33 +0000 (UTC)
X-FDA: 83724488106.06.2F1CC37
Received: from mail-qk1-f172.google.com (mail-qk1-f172.google.com [209.85.222.172])
	by imf30.hostedemail.com (Postfix) with ESMTP id 4A61480009
	for <linux-mm@kvack.org>; Thu, 31 Jul 2025 12:28:31 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=BY+YGH81;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf30.hostedemail.com: domain of usamaarif642@gmail.com designates 209.85.222.172 as permitted sender) smtp.mailfrom=usamaarif642@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753964911; a=rsa-sha256;
	cv=none;
	b=lWKqADNgM7KEhjQz/cFZ7OwR3h/FBlXpvynPbHpOjyCmQTxiWmEceO42S1COi1TM+5r0pb
	OjP0hXOlGbdZlqH0/5jWrGgijXZCo+NFOopb25u4Tuj98WnMTBnKCrLzDIs4f2Xe167uh0
	QzcWuLQK4nztClX0ABCnAC8opY4eekc=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=BY+YGH81;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf30.hostedemail.com: domain of usamaarif642@gmail.com designates 209.85.222.172 as permitted sender) smtp.mailfrom=usamaarif642@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753964911;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=RS4JTAP3a6V5rVYkQiGLkIDwjMzYKjOUoW6XDyAbEAY=;
	b=w0W4h1vjQEAf8cFrnU4548MdUUGmp8oQcU0bUIgKPqhgNUXAdxdZKOTZwoDrPv1tmtyu6o
	SI9VcR95qJ+frDyF3ymUDhpIe+3pW0qX9xqTDOWUjdhiAHWwn3VJFu0EmHDw291PTm3Ppy
	pxfHeyxoA5bmUX1t7E9YGtdcWr5Dqjc=
Received: by mail-qk1-f172.google.com with SMTP id af79cd13be357-7e34399cdb2so96541985a.3
        for <linux-mm@kvack.org>; Thu, 31 Jul 2025 05:28:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1753964910; x=1754569710; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=RS4JTAP3a6V5rVYkQiGLkIDwjMzYKjOUoW6XDyAbEAY=;
        b=BY+YGH81j4UfYnOHbZOt36OXFnxYqXMXbSbonu61HL/KHhcfUCJ/PRZ4XyQNxrZFRo
         nlEOTXU7XEf0BnX48L08TJorzd/Pv55iOaH/bdlLV2SxeCMMWZW1tl7ZdZSwV97l4+bu
         WVxs2q2HuEOZdJO3PlUwRYfRzDgw19v71ajSI+Qwyz+JSix0ZKM51s4rEE8IGgsnh6lf
         pOYCg9FcXlOnko1pF7Ww/Zok+sO/ka2Nb5ZCHwL5hdJ2HEGWO9b6T2+AjuBbSHqO0ebP
         esQGof+1RnBal9zeC17vMeruMp2aAF3wDuuxJc/TYFmunS5tX2Q3yUCTqfrbtJeYTsKc
         xArg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753964910; x=1754569710;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=RS4JTAP3a6V5rVYkQiGLkIDwjMzYKjOUoW6XDyAbEAY=;
        b=DwKry+LO7KdDzea+AMOqX7aG3n1BdkxZhB2z9BbLphNdUoj7GGYtmxLEhNHXUj9oAI
         o7NtiCsnLpxGuq6MJv0Pc93hRp/ql8BZtHt8NckYPyS+NkKsEn0zXBJTnYX+ChE/L2UB
         DpcZ6lxOrxcmgu3V9aaygbTDqnqGyVZWedzmqaCvyho6vvldCwckU+mMI76rOsTTW5B0
         p/Ab2IDQzQW2UYhPEGqYt5cTXd3mUTGbCUjSnK9+wFRJwHczdvaqfHwTYDbIb4BpZuya
         QHa3iFzbkUNsQZZZXU1CEt70YNPgaEZb40keCo7piPI4bNUIeKcGoQzWYb8jD73w4qIC
         KoLg==
X-Forwarded-Encrypted: i=1; AJvYcCVqWBl7omzT6qkXdahtxYUjH0x7fuI+PL/sovkIsYRKwijh+CCjlFZ8PMbEB5PnEDokn1SOsLALHw==@kvack.org
X-Gm-Message-State: AOJu0YxYDbSWnjTxS5c0sRd64si3LHtR7NydYAAab5tCdQ8K3ayKi9JY
	vF+ZCavUZMV0Ha/aniwACmcjLnK+ibQElBQESzE1VlyrQjhNZymBso3f
X-Gm-Gg: ASbGncsqCL675XnQ2h56gw26xSE3Yn0al2ISMph7gZywQEgBVk8t2XJFd+d0gfrO0n2
	zccq/pfrDZjvhld5tMOb5Ging+YmO/CAqnWV9gK7MoZozE6GTULqToO5ZPsrQuy0vLTa/EUClEx
	r89t/E1ZoSCIR23KIARdtYjVgyyMhzbqFLJRI9AM5X148AwZLdNo66SfygdaA2mQlNnDYzTXku/
	ba0EkJLgS2el34gdp6F2EB3xOMZF83kC1JPbYyaLKJS6l6EKTEv95HUT/ruak+wT9DYVB9lN4pK
	8jY1dYnCpAzo7HClfKKLwMFjyiu21NiCORfZMC8sejf5g9Z5IH+IQ73zWz3qqD59xU78FSQT3I0
	EVyfxfwLYY8JZ2xucxvI=
X-Google-Smtp-Source: AGHT+IFaYqTU2XCFiHMz7+aNk0BrqZ5MYEroyP1jSw962PvqV1nx/jTcnm4C844IagSTx/ZUMJgXJQ==
X-Received: by 2002:a05:620a:118a:b0:7e6:2738:c2c2 with SMTP id af79cd13be357-7e66efe88b4mr951829985a.16.1753964910188;
        Thu, 31 Jul 2025 05:28:30 -0700 (PDT)
Received: from localhost ([2a03:2880:20ff:8::])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-7e67f5bb503sm78456385a.27.2025.07.31.05.28.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 31 Jul 2025 05:28:29 -0700 (PDT)
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
Subject: [PATCH v2 0/5] prctl: extend PR_SET_THP_DISABLE to only provide THPs when advised
Date: Thu, 31 Jul 2025 13:27:17 +0100
Message-ID: <20250731122825.2102184-1-usamaarif642@gmail.com>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: f3yxs7rurrk8936nsmqro43cbk1ddbh4
X-Rspam-User: 
X-Rspamd-Queue-Id: 4A61480009
X-Rspamd-Server: rspam02
X-HE-Tag: 1753964911-31393
X-HE-Meta: U2FsdGVkX1+opdz4OLo85VY3OgRB9kGWAgcesreGc6jQCkl414X4cvlHRL28DtoXU54Wf7pt6v05ioGmFl3fT+U6FZi77PUzuDfHkZoQNXpmKfkYJ/tb6v/GD+5UCIEAEDnQZ8HDBccX8PBckTmfCJxxFRtNqlhn/dK5ShgJWNY1k8SDtBCCH44rY2gY2glt7kmvy/WN0fJMkQRM/nokUFyL55anAOc128d76IKDxxCwoqT52HvVHcFijYw2DrQd0hbiE67zkfGeNR18BKCJP3bk1xL3CoEbL7jKpSlCmg7mHW0/PGfUGnvNfFNds+MyZyHLEM6d+lAe6xy7khqEK5MAVCZKIG5ivgUTKvRzEeBVY3WWj1i19x7zRCdpNY4FoubE5km8Ki6hUpygCS6fMm1HpfM1UVUH8XK2CV+BWYOHLLoadhAUnhNVLeVqnpasZZCQRzrJ2PBiu2imXNx3xU7s1wJ5TDLTcDYjr+5UnDd60LsDl28gixOwGkfk6imkyfLGArUgTHVDSdbJw53hFUixETqLCqa9ZUgYYN1To0dm1gXuL11HV3Im4I/ll0ScqqmFLx6gkLyrk9OnXTbxR1+Pfi9heAz41dmSeggQ3KjNqUNaYgPhlifF9f+SKDqriKuJYH+Gt+9TbGq711D7o4jx7tTchXIh9PHZqz367ahVURa6/vhLEcHXe77LOMsilASbhy5Yy6N60CORwi0ZNiDN8nMclySAIoJEsW67CxFAHEljFBvEwOkJ7sgJhrnsFBNBXczkXNyZRRaskBSBV8N30WV9thVS3CHpE3n9AUWtRVDkLIziCOh6ktHRs3dJTF0V8fuOd8dltH0XPX/YUx+TXYaK1X+HzDwCBtIy1bY/lfQQCGZvS/Reab3Ac9IpINDAA9fchCaB2TCRCkZjqq4nfb5VYUzQbP2rWNnOkn3y+bpkHwRZoKhKdzDz+ef+bokFjQsSGnq5EM0NPBU
 tZ1qWBq+
 /aOkBVqAtv8GzMRD6YYtjR/QZxZuSRFFLDAyEAwDA6LPlsxN7e4gQaRC+BO+TRckZvXhtUtc4OIa6Y/SzB1Yw5EN5PjBycVEimkyGajwKiJ28iRHyNm6g7VcsqCyMt/JbsR3odvcAj0UMcqS1w9yPEzu9HS7IRH4AQmdBfSTdkfYCoAE+Uq1S5o07NDoFfzSxO+PGpSobc0wvSyk0qWoK3Iwnj7O3fI5pLPzw6CQ1sNZ+99/89uSmRneBP2VfEia5Zcfle6Ns5XIy7c1XwZm+gYmd+9GHQFdXi5BCJ2+JLK038dnT+ucsGIrPSQ1bJ6MJIpOw0MUG4SIWOU1x4XEF3EzUQH+zUZHSk23yHgcBp5qnNsKfs8jK/sdKdf3EqWPOnh5G0X+08cgj3W1cNz72DdFwCOabMAEGYNjrpgdaoyefPyScuwz5AGyqrSZyAQlBJwG4g0k7Cq6e0+nMvpG6F7JJbjeJzOfcUX3kd0cv6JybMyY2rSgrvL6KvpxbAoDU2Vy/8h8aFv6XaD3LqlAPmfbANRL44lVdMbvCrW3C2AkWw6deAOmIJfaeOmQ2MMYFfHPLOwV1hFR5jABykTKj5ogDErz3C7GZaYpN
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

(Resending this as forgot to include PATCH v2 in subject prefix in
https://lore.kernel.org/all/20250731122150.2039342-1-usamaarif642@gmail.com/)

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

v1 -> v2: https://lore.kernel.org/all/20250725162258.1043176-1-usamaarif642@gmail.com/
- Change thp_push_settings to thp_write_settings (David)
- Add tests for all the system policies for the prctl call (David)
- Small fixes and cleanups
 
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
 include/linux/huge_mm.h                       |  60 ++-
 include/linux/mm_types.h                      |  13 +-
 include/uapi/linux/prctl.h                    |  10 +
 kernel/sys.c                                  |  59 ++-
 mm/huge_memory.c                              |  11 +-
 mm/khugepaged.c                               |  20 +-
 mm/memory.c                                   |  20 +-
 mm/shmem.c                                    |   2 +-
 tools/testing/selftests/mm/.gitignore         |   1 +
 tools/testing/selftests/mm/Makefile           |   1 +
 .../testing/selftests/mm/prctl_thp_disable.c  | 358 ++++++++++++++++++
 tools/testing/selftests/mm/thp_settings.c     |   9 +-
 tools/testing/selftests/mm/thp_settings.h     |   1 +
 16 files changed, 505 insertions(+), 71 deletions(-)
 create mode 100644 tools/testing/selftests/mm/prctl_thp_disable.c

-- 
2.47.3



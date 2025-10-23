Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4045DCCD1BC
	for <linux-mm@archiver.kernel.org>; Thu, 23 Oct 2025 18:01:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 809858E000D; Thu, 23 Oct 2025 14:01:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7B9578E0007; Thu, 23 Oct 2025 14:01:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6A9098E000D; Thu, 23 Oct 2025 14:01:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 54CDC8E0007
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 14:01:43 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 13131129DB1
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 18:01:43 +0000 (UTC)
X-FDA: 84030146886.28.B394F43
Received: from mail-pf1-f175.google.com (mail-pf1-f175.google.com [209.85.210.175])
	by imf21.hostedemail.com (Postfix) with ESMTP id 165971C0019
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 18:01:40 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=nXXrw51Y;
	spf=pass (imf21.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.210.175 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761242501;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=hOfpW2F0dLhMpb8zi4+tT7+zxDG4noiF/FBCYOCAu60=;
	b=zVuCgsgvFM9fJlLA1pBNt94tFuf/qASr9Z0vooH39X/Llq4VLHWbG8pbclWHbaR+ehYbKH
	/81xCuXRmSXG/iqQB7U3+5olrD//3UOb7dRjhLijjyJhakY4VZtlKOXPQSVoKb9xP9bj8H
	7Osd0XBSflanQZoD5aDmv8ATp07U7Ck=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761242501; a=rsa-sha256;
	cv=none;
	b=vsGa8ucs2lUuIXhKFEF2AB9JCBUpjD1HlSAxsOaApS3JqsvySirnzQ+p1iHI/tzhKHzhHT
	fuPyLnM0/TzuhrwtGu1fs9Y0avvCtG3g0RORZ8htkba5y57BoKtBi5qLNRFQmmOl3ABd9j
	xQ4zX7mnhjdBnl5kcYkvxgTHXAtsRyQ=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=nXXrw51Y;
	spf=pass (imf21.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.210.175 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pf1-f175.google.com with SMTP id d2e1a72fcca58-7a213c3c3f5so1511146b3a.3
        for <linux-mm@kvack.org>; Thu, 23 Oct 2025 11:01:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1761242500; x=1761847300; darn=kvack.org;
        h=cc:to:content-transfer-encoding:mime-version:message-id:date
         :subject:from:from:to:cc:subject:date:message-id:reply-to;
        bh=hOfpW2F0dLhMpb8zi4+tT7+zxDG4noiF/FBCYOCAu60=;
        b=nXXrw51YXdscm/x3s/z95oPI8UGxKaiSAxFpzLcR7pVsNdkQqqU4CgKVLzYObDTx2I
         V3w7kRpCiWHy/eboke9WUUY8UT80guatVTx6AivMenCZKFvgLLpCGsgU301BJJJ1p+u8
         cYh17CuYy9ymlUlHWCovbJmUsyOTKCEqMhlSGiMmZ9zOrH7fjai3r4G+6FzSy1AAnuFt
         qCWX9TI5thNm9yQU6QBVOnkC7Zy/+MVv+lhlzOdU5fEBJV48stZQ2/w3Ocur795uSF8p
         pKb0gZ6BFhGJZiFFE4vuIRxei+l9QrmSqQF+vmTwam8ZLH/DSnSFyN4rwgl8TcQRrwx5
         9YwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761242500; x=1761847300;
        h=cc:to:content-transfer-encoding:mime-version:message-id:date
         :subject:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=hOfpW2F0dLhMpb8zi4+tT7+zxDG4noiF/FBCYOCAu60=;
        b=sSO95I0FcA5Yu6y1G98JhTcQx0shnFmn/4QQNpaW36k+jR6Tn2MgVadr4hSTrjLbw2
         Qf5KN+ziNkZy3IyGAZCQOZOp5PakYw6GkxJlYICrQqCAxt6fv6LMNEu0TdYJhYZsevRN
         oh4WKbXlrbHqV6PBVPWWkFvZpJPSiOt2B/En1eK3T5pEjjywP8txg9JsoNJijtZ3s7N/
         AdBt79X5y+iKjIN4vvipmn2/YknIhtI3TjEloL1GNQ4LXVREjS/PctN6IFZQ/eAesnR4
         TD25lnwWejo2MaAR10ujVvH2n75mhBzYMlZcEtNYR9Bx00B0XjCfMzcNfDPnV8lPcI5V
         vxmw==
X-Gm-Message-State: AOJu0YwJFIOYueD4GJV/mbPNvs5n0E5tOX0wLpVIvpgT0BWBjSxqfT4a
	6UuRPHzHYXhb8M+9wkexj9oFNU8DS9DxGgPgsLjRaHJuTbEWZBQmE+Qn
X-Gm-Gg: ASbGnctSJ4Seu6uG8ZuBuWe9KLotUrXcU/rD2FR6BXQW2kBvNg4j3Naz4EsUPvjlY3R
	KSmzvbE/Z32RuOS5pR5CVQwmYV3GRU2qYejyLZGhA11xL4e5WgRmaAtF7Vq+ON/bMYaLvikUaHw
	9FQfFNa5JolzAVPP065XOQzYdPG5UmxJHQF3EIEnc44njnA7S2/ryFr0fYK+hRGof9vJYzi64iZ
	oN1oPZrKLLHy5hQsWLy7WnF0AIf5HRMjz8EYyo4HwHQ8uMZZEVKRs2bcfm+n/MFbe+jkhxUCBqW
	lBuG0x4W/QPLqvDUMk5mIVjShkzZCnepsECLbPtzBGBxJ4yd4O6/td/NGD0qILe2R5W1SQZ0V0z
	81y7XFActEdLTCZXWiQHcjKH4ofXXTaQbKTvNa8w062MNdbo+X+XhXm/+RPEZOWnX2rT8wW1Fhg
	riTrN06KGTYlHzxciO
X-Google-Smtp-Source: AGHT+IHIZOFsj/SegFVrNbdOjeH3WRgln2EKfh0ASZUCKq0ad8fJDrSau2Rt6XTQaNzq2A7iutDbkA==
X-Received: by 2002:a05:6a20:1611:b0:334:7e45:e69b with SMTP id adf61e73a8af0-334a85a552bmr30672459637.29.1761242499397;
        Thu, 23 Oct 2025 11:01:39 -0700 (PDT)
Received: from [127.0.0.1] ([101.32.222.185])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-b6cf4c4d83dsm2734532a12.18.2025.10.23.11.01.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Oct 2025 11:01:38 -0700 (PDT)
From: Kairui Song <ryncsn@gmail.com>
Subject: [PATCH v2 0/5] mm, swap: misc cleanup and bugfix
Date: Fri, 24 Oct 2025 02:00:38 +0800
Message-Id: <20251024-swap-clean-after-swap-table-p1-v2-0-a709469052e7@tencent.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAEZt+mgC/42NSw7CIBQAr9K8tc9Af1RX3sN08YoPS1JpA6RqG
 u4u1gu4nFnMbBDYWw5wLjbwvNpgZ5ehPBSgR3J3RnvLDKUoGymEwvCkBfXE5JBMZP8TkYaJcZE
 4nEi1VcNcGYIcWTwb+9oH1z7zaEOc/Xv/rfJr/06vEgWqumsFm24gVV8iO80uHvX8gD6l9AGaQ
 0SPzgAAAA==
X-Change-ID: 20251007-swap-clean-after-swap-table-p1-b9a7635ee3fa
To: linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>, 
 Kemeng Shi <shikemeng@huaweicloud.com>, Kairui Song <kasong@tencent.com>, 
 Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>, 
 Barry Song <baohua@kernel.org>, Chris Li <chrisl@kernel.org>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 David Hildenbrand <david@redhat.com>, 
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
 Ying Huang <ying.huang@linux.alibaba.com>, 
 YoungJun Park <youngjun.park@lge.com>, Kairui Song <ryncsn@gmail.com>, 
 linux-kernel@vger.kernel.org, stable@vger.kernel.org
X-Mailer: b4 0.14.3
X-Rspamd-Server: rspam05
X-Stat-Signature: fnh5xpqmfnoxk1txix5jb6sxjqo4m7gm
X-Rspam-User: 
X-Rspamd-Queue-Id: 165971C0019
X-HE-Tag: 1761242500-360723
X-HE-Meta: U2FsdGVkX1+DamK0FABGLtwy40f/MuioxmHhvWlsrXb8XPIXv8F0Z/Gc5vOJhBo9phKlWOzcqG2Q6E4/C2vabfW0D1ZuQ77b0FuC8hyz6At0tcJPN1XYXTmLcUSnQKvlWg7NpN0ZDqAOXrvJMNAWllDw9TlcA0rd7Gczsv6VsmO190JEZUjOpd85u+ceJeKWMUjG0bpCVRPyFG/P20tX1+kOCiOen9+RvdXlTxhWeZnHuVVN30Wa25oV7K0M0JGpLoKEXM1j3eSXQR5w1g70qSMOLxLtVJXWbdU49u0D/BRFNwAKsrylGMzm9IWKL28P9w/RpOpYf4lOeD5YBtZl69bge4ufExBBjSSx8xGrrDJiM7ANv2PA0n9EknwqHR6fEiDgd1OGlr9sbaBquVocGAGwiZTShPmQyhKCwZ3vLmHqi8o4HgJGNUmq5BX3z9zzKCuRhe6x4ULiBAnGU9A6Od8zk1yEEjoYWTSvyuvdJHGIwumi/ldJUcuCrhEJayLFmjgrePMaLxR5BBTvuNHg1AOezJApy0o5q9Gx64XYTaf0pHCJIZWoOnT88IcUu7rIB/Vbs9qJ+KelrJvZAyBzU53lUBRInl4ffLfkF3/v+3nY5jGnAlb3k8Nf/6T+EfuvHhFjGygpSACm+V9SabLTgUU27Nq+ZrWILNxUuVy0sEF+8/VZEBq2CXv+IxcllWA5WOnm0xXKHCwvmoxbcOyfqx2yGc1X6SJt3WRY7GLTIkALJNOo4gUWDiJIKhCi4+o4JPaShEVsidrCHs6HQgpR/FMxWhjieveFDINzriiyigVyG9npe0RhdEsIsBxgb0MHR5RtM+S4dKab/vw4DQzrNE1I6KB/wg/2WNiuRng1IHJaK0MN/qI+DOr1q9is6fhFKEwsOAkElupX8AtsY6ci2OrmOTLSCIZFIL1dsu5dWcB1PvTAorzRFIP1GgG46jW5z1zib1mA8nDSvDZkYjF
 gEPriRm+
 m5sEtDNrzyX7+81nShil2FdXDsjvrGO29XS63Vgnp572HKoW1hJrNcZXm2thhWYgIO1v+AhqCAF7dmcg6VVeOuPC052oz145Rbt1g5ThupAwvDnjagJ+tKDfHnVYHzTGQheGb0TPxyZvj9MpXgiBfrYpkhRTWeIe22YiSHPeNrq96dv6ZFD+Ii1KwXP6JVsmsKtZrdZxrpnEfN4BWVgGWAsL2NeFfEvzokCeAoIA6/Rrw3rclGu1gX/fajVaYpOLb1HsmWnSEUqHO88scOu01L0CrVpw829n8wx5gVlVzFpNe5gjOqbuO2ESGh80cUlEcRFIKXlEdRHQjCwj6290Cl25tgm3AWxh1eb5+7EhcwuvnoK9HUa0dyU4ok5KlZ9+7tM/LEzM+wewqxwbNQjFSl8WbVZuWm0lZ8Ct44WYyeySFfl/LE6esoFtmIszrTWd+xIRy4o2mKUBvJi8=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

A few cleanups and a bugfix that are either suitable after the swap
table phase I or found during code review.

Patch 1 is a bugfix and needs to be included in the stable branch,
the rest have no behavior change.

---
Changes in v2:
- Update commit message for patch 1, it's a sub-optimal fix and a better
  fix can be done later. [ Chris Li ]
- Fix a lock balance issue in patch 1. [ YoungJun Park ]
- Add a trivial cleanup patch to remove an unused argument,
  no behavior change.
- Update kernel doc.
- Fix minor issue with commit message [ Nhat Pham ]
- Link to v1: https://lore.kernel.org/r/20251007-swap-clean-after-swap-table-p1-v1-0-74860ef8ba74@tencent.com

---
Kairui Song (5):
      mm, swap: do not perform synchronous discard during allocation
      mm, swap: rename helper for setup bad slots
      mm, swap: cleanup swap entry allocation parameter
      mm/migrate, swap: drop usage of folio_index
      mm, swap: remove redundant argument for isolating a cluster

 include/linux/swap.h |  4 +--
 mm/migrate.c         |  4 +--
 mm/shmem.c           |  2 +-
 mm/swap.h            | 21 ----------------
 mm/swapfile.c        | 71 +++++++++++++++++++++++++++++++++++-----------------
 mm/vmscan.c          |  4 +--
 6 files changed, 55 insertions(+), 51 deletions(-)
---
base-commit: 5b5c3e53c939318f6a0698c895c7ec40758bff6a
change-id: 20251007-swap-clean-after-swap-table-p1-b9a7635ee3fa

Best regards,
-- 
Kairui Song <kasong@tencent.com>



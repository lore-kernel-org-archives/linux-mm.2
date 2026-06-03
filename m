Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7E9DDCD6E4A
	for <linux-mm@archiver.kernel.org>; Wed,  3 Jun 2026 13:05:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E38066B008C; Wed,  3 Jun 2026 09:05:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DE8EA6B0092; Wed,  3 Jun 2026 09:05:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CB01C6B0095; Wed,  3 Jun 2026 09:05:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id B78526B008C
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 09:05:47 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 85290A038F
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 13:05:47 +0000 (UTC)
X-FDA: 84838623534.24.8437E96
Received: from mail-pf1-f171.google.com (mail-pf1-f171.google.com [209.85.210.171])
	by imf15.hostedemail.com (Postfix) with ESMTP id 8CE40A001F
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 13:05:45 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=fX3stnyS;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf15.hostedemail.com: domain of wujianyue000@gmail.com designates 209.85.210.171 as permitted sender) smtp.mailfrom=wujianyue000@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780491945;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=KUNz2ByJ1uR0lUfiaY2wF4eyBaRncro6lIUctBUODUo=;
	b=YLdFBOzWEU/G5y0I60cvQ74UmClkK5ubpGq6qyS0oom7wcKXCQoeJcHG4yAvQ1rr5lH/b8
	XI/RUFgpVe1O/VY94Bii7Y9YAMZ4vnOeFyv3YIwjK/ZRJvFjziVcPgNboC8N6fcPc5jZ5p
	j6X7tfAR93DGnNQefSXW8FH9kprwDu8=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=fX3stnyS;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf15.hostedemail.com: domain of wujianyue000@gmail.com designates 209.85.210.171 as permitted sender) smtp.mailfrom=wujianyue000@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780491945;
	b=jngoTyklbciANfxJ7nmDVLv8UIl7uZpV78ExqgS5fwRqIVAd/pNSE/kye3rmhQnr0yBPyB
	YJlxZEmRtAHdEctPh0TOrB5ZOFlBW478G0Y5QOH8XF/pQPotbBv2v13VxG0t5ibXrdgBic
	ucalAUYBIWAmvWKR5fclV6fGTmuvhOs=
Received: by mail-pf1-f171.google.com with SMTP id d2e1a72fcca58-842273a2c4dso3041732b3a.3
        for <linux-mm@kvack.org>; Wed, 03 Jun 2026 06:05:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1780491944; x=1781096744; darn=kvack.org;
        h=cc:to:content-transfer-encoding:mime-version:message-id:date
         :subject:from:from:to:cc:subject:date:message-id:reply-to;
        bh=KUNz2ByJ1uR0lUfiaY2wF4eyBaRncro6lIUctBUODUo=;
        b=fX3stnySxMAFOeev+OsybQlGpraEFmKplIbQzc/R2DpbBP14LsFqt2MRwc3LwHubCy
         um2cPjxm+qHPxh2GkYdBEqRr9KI/xojgxUdwajL2AOdattHD3Qj7VO2OW38vBEXQqieo
         BFnDCBPuMAAQs70a924G02FkdvLuUMy6pl9AJPkirRrxiaC6SLqApNdZRQGKSpMDAZ/w
         LhIDaYAw+ODJQpdt7Dc+Z0RypIBd8BdRR6jiO5AU0K64wvJVF/mP12fAoa++Brs1g23z
         KKRVuVo/BeQuybDhkmPZNUz3xCb/wn4lM0WwX6cRkZAfEsVr9mTnWdpK2SjTehNAPhVZ
         u+Cw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780491944; x=1781096744;
        h=cc:to:content-transfer-encoding:mime-version:message-id:date
         :subject:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KUNz2ByJ1uR0lUfiaY2wF4eyBaRncro6lIUctBUODUo=;
        b=o4/zQd+6tfsqGRLLbYEg+e8b46rqNQ3wHKYY34I/h/d5nE7QLWwj3F0Rgx0qITPBly
         thK4yu46Y/3+r25jlNKOS9//ksNlwPozu5S5Jq7UvRAMcLttwSbzljKbdoDSSoi/phg9
         7j323yBNlYRxKkIfXy2RGkNXtn+9CH+T1Hzx/EaTVnJh0Y7bqiFQN9UkgOyLauJTuKu/
         u8Ls7WWFtKgW9guPBKCVInydcwFV2H1F6NPt2zZXyrgfgsOSY253vj2hvdrWqkniHe3t
         ACcXlw4usMUBUJ5iwNqFEIhJAtNj9deXB/qJnz3ySA9BYEUPZsVlnyZtuLEoKAxz866q
         DtMQ==
X-Gm-Message-State: AOJu0YyI/1bGev6yJGJg+hlabVwGg34Q4s3JTtB0FA/qpx4rVvh1v+Iq
	r4nc5vvtIWF7mt5w0MhepfqUNm+gabJ6JHAGBuhPdwL0LSXscV6NVtBW
X-Gm-Gg: Acq92OEvkqsAXdTl3Sd/q5CSh7c+IfsNzGQje3hWsiX70t+Hc2sZQvQNP6N5bi36ySg
	hremBmsMZrQmEJ5Si4brbjrXfjmWSTVdJvpZtRK6rePuxuyRgPlrKtzod4BNIjBvl6ZtWfmCrL6
	7GTX33HaL+MitDS5ioHmFTnHjlQcEWxWHZYo+xDO5KlWJxzmWdiRRFN28wafwtFJP+XttWBBomp
	/42kCWyWmM5tp3dm22QjuZWuA8Gd3vEoMAXbco5ZdMzTpeqIqA6e0zWC1mkT6DrOWy6lx8U5M6W
	8AXLfjGxDJ4hllMT/9t+NDD7Y6H+L2Jg1ip45RRRQWOz5OMMxc3ggDSQKQNXa53Z/aD5KXLymSm
	i9BzxGhT7yD3UEvTIJPHJpggCvoVrU8/YNmiYIHVXJ4YPZzlM8C45FqJfDFXdRdag5Urp54f8qK
	7t8kRD02mknIGr6s2gvQZdkUeRgssywoXbB4MzAPjMgrI4iBPaVhWUmidyq9dTVANRD67mdqYV1
	9WjLgU7fKA=
X-Received: by 2002:a05:6a00:1d9e:b0:838:a46:ce99 with SMTP id d2e1a72fcca58-84284fada0emr3028039b3a.48.1780491944310;
        Wed, 03 Jun 2026 06:05:44 -0700 (PDT)
Received: from NV-J4GCB44.localdomain ([103.74.125.162])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-842828821d0sm3018661b3a.28.2026.06.03.06.05.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Jun 2026 06:05:43 -0700 (PDT)
From: Jianyue Wu <wujianyue000@gmail.com>
Subject: [PATCH v4 0/3] mm: clean up folio LRU and swap declarations
Date: Wed, 03 Jun 2026 21:05:31 +0800
Message-Id: <20260603-ch-swap-series-plus-folio-lru-cleanup-v4-0-ce0219e100d9@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAJsmIGoC/5WNTQ7CIBgFr9Kw9jMUSn9ceQ/jAihtSWghYFHT9
 O7SutClLuclb2ZBQXmtAjplC/Iq6qDtlKA4ZEgOfOoV6DYxIpiUmNEc5ADhzh28f+DMHKCzRls
 wfgZpFJ9mB21T1bmsKSWtRMnlvOr0Y+9crokHHW7WP/dsJNv6byESwJCLhhdcEsZEce5Hrs1R2
 hFthUg/1hKTX600WZkQgpVVV8um+bau6/oC09MN+TABAAA=
To: Andrew Morton <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>, 
 Kairui Song <kasong@tencent.com>, Kemeng Shi <shikemeng@huaweicloud.com>, 
 Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>, 
 Barry Song <baohua@kernel.org>, Youngjun Park <youngjun.park@lge.com>, 
 Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
 Wei Xu <weixugc@google.com>, Johannes Weiner <hannes@cmpxchg.org>, 
 David Hildenbrand <david@kernel.org>, Michal Hocko <mhocko@kernel.org>, 
 Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
 Hugh Dickins <hughd@google.com>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 linux-doc@vger.kernel.org, Jianyue Wu <wujianyue000@gmail.com>
X-Mailer: b4 0.13.0
X-Developer-Signature: v=1; a=openssh-sha256; t=1780491936; l=3985;
 i=wujianyue000@gmail.com; s=id_ed25519; h=from:subject:message-id;
 bh=5VLnZhSIf0jXUgELog3B8KWjOVsjpryu1D4jbtsrY2U=;
 b=U1NIU0lHAAAAAQAAADMAAAALc3NoLWVkMjU1MTkAAAAgW51Zh3v9nG0Wlld2Ti8ylp1TnO7yB
 H+z9CbXty/WEAQAAAAGcGF0YXR0AAAAAAAAAAZzaGE1MTIAAABTAAAAC3NzaC1lZDI1NTE5AAAA
 QCSpdIDNmbNJM5EUpVtFVV9jlxnqM6P2hi0lMTlOMnz2cxEysphPYLNuuvG+Dt4a5TzXOxCrD0x
 xN4GjzBx2FAw=
X-Developer-Key: i=wujianyue000@gmail.com; a=openssh;
 fpr=SHA256:gVWBPJbHGWlCIw+V8F63Ff0k21S7AB5+rZt8+huemvg
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-Stat-Signature: wchqtyham81nztbxa8xryk1p4mfha6ub
X-Rspamd-Queue-Id: 8CE40A001F
X-HE-Tag: 1780491945-592689
X-HE-Meta: U2FsdGVkX1/kGNXEEIMM5NoxY6qwOPG5mK4xvapWkqPNaHSzDcBnx/RF2vvFePBEBHzuJMkv+CR8oAyYk/qRpeZ4CDk8X354O/SJZyZRFKKzDWKiNl4lsb18vZHF7nWGRSvc0hDlZEYowp0osN3AB3rcJcAbcUhUZcKrRDz9u+7vaTPmp1Ux5q5QbHZoBgyxeuZ8MouGo7miNqZ3Hw4DUBIRz4QMAgBCzOLXPLDEuEnQrBAlhbW9vK9GYgbD7XO0Yci/uUFt5Sqq76JPMcZtg3GiEJO3R6f19iG06Zz5ri4O7djPRX5H+JuY6IhxlXywvjH13fmFuW3nYFVi9K8WVcQl2bxpxX3bN1sWo8aZV768OJgQMyd3HiXp23GuWTMDZo+FHp3jvdcRy5+n9p8rTa2ZOZP+TKZef5+wRnIzsovU8jhrFOIZMbKFPxneh1MXEj52jMqHf1n7VcjLM978swYKRo9GPmGJQvXzGXYbVeg/0juO0p5IAfN/r/qgFoovefTxUHo+7SS+t61liIPPIjhXuQ0veS/2w/L2Kq9gAMPKNoaJmYBpvkpDc8KlEtz3FQGJiKFw7FGTDevV9S027+e04EjkkB5G4kYpJlbNlmUY4Bc29zsJOSUmt+l5xCO21yS0xasjJOKCYEKnYP8kLHHXdTDugpML8F/ihdLzlL8LrBlUaFyxsrFNl9eQeXdo3ZkGbj0bQHHAO5XB/15Q3l4RB1m0nZDCLxmTf490epvCNRyrPEu8vEBSyWAA7DWgXZCVU57WZQYEWfc7Kx4z8Aj0z3d/h3SZKsbv5pbSryHM0uaOO4DIfD4Qis5VugX5m/AshXG0Y8Svh5vJ8QkXyPU8EzS+IcQXSiFr4g8a9Lnh8E60/VbcMb+60FDKoeXNlQak0l08/MOXBGASXiQRXsrKOBXaAG/JBqXDTE81vDmH5hcz+ORfS4LlSuprIfT5ShTSr50hVuZWvHOulXW
 inyTUisK
 9c/QhMRjOriLGhSCroSUkJMQxGI1hwpIr4h3vE9/Uf57IICpNKCqdqQaUEw8UrM2txqfsWZv4KQwswCmVw2ksfHXiXTrtA2q9SvY7oGdlrJOwG1Dw3JKNwx1s5csSlV+sxrFqVudi+bkz1/m0YYb3FUx92SISvk58ufvn9CmtpoWQ+b9CVsWz1VqrW0WAc0Y53h18hAWwl3t5BkJ2FfEYtEhFMwUEMV+74tUhMP/fze7FF7FxbaeEGlJulISMg64tJ1/Cyu/IUT6jQYgArCPwKpDFNxWv53pi2mrwZtKFN5iNCDctSTaLF48zEmJXrKm4AyqeIc/SCFnlmOYKy5C7DmdpMBAT6/7a+mloxQfOWmBhqUEGdAxYN9uomB2AheUfCfxMidZsMUN9u4BCOR7TBmRw41wFd+1oCkPzrAuWt46tQ5wUqCqpBTR/mR/TWSJNZkM2rxRpAFihcqUk7GRRy3xRSpEFq0cRbcmHaC9VO34cgNAKGrsoVxh2REIinKkF7pTKEXQM0EZeX6n4CGkv7ThTLUGG7WbzQ6T3HvdtbfS/Lh3iFPRnJ8JikBkIQ2VKu4k3Xs7uFj0K0A+qd0nCNYWwTTxC6Soem0xqjnZ8Non19mOdavOR9wL4VZR5X0zfT6PgZML/9yZVqIntl1vXmicRghORozoh2qGObjprJsXWDm5LGOj75zZI8LoRL+0JA7GJIPr0A62YQQlmQ98h4bm04UgkvaiKUVAc6xjnqK/E13P0keJWs/B8KKgfu7NJkbTG3dQGQUXajOVe37r2LdVv/ewxI6rDlHGeGhlsZB90A9dsFj2ND8ShyD2mHAUTK1GATzKQXtdwHKsHyi/I5aKtkCwKUnAb5Dcq/fQ5/DyIe445gsf1MCBxUSCb2iaf/WQ2xAgwBlGuE+E2Walwcnd+CEcmOhZJURi16bhr6wQJ9GYN4H4AlZmE0b8nDTSDbgyqyJ8AOgLejvStqC09/vSj9qe1
 VtleCOHl
 ybdx8YQmyMy6I3hN1IxCcrNZONhWWmrooiyBkcAmYe0p6KTRrPNahQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The previous version moved the folio LRU helpers out of mm/swap.c in
one step. Based on review feedback from Johannes, Baoquan and Barry,
split the cleanup into smaller steps:

  - move the page-cluster sysctl next to swap readahead in mm/swap_state.c
  - rename mm/swap.c to mm/folio_lru.c after the swap-specific bits move out
  - move MM-internal reclaim declarations out of include/linux/swap.h

After this series, swap cache and swap-in readahead stay in mm/swap_state.c,
folio LRU helpers live in mm/folio_lru.c, and MM-internal reclaim/workingset
declarations move from include/linux/swap.h to mm/internal.h (public LRU
helpers used outside mm/ remain in swap.h).

The first patch handles the swap-specific page-cluster state before the
file rename, so the rename commit only carries folio LRU code. The last
patch keeps the LRU helpers used outside mm/ in include/linux/swap.h and
moves the internal reclaim/workingset declarations to mm/internal.h.

This series is based on Christoph Hellwig's swap_ops series, which
moves swap I/O dispatch behind swap_ops and leaves mm/swap.c with less
swap-specific state. That makes the folio LRU cleanup more natural to
split out on top.

  https://lore.kernel.org/r/20260528124559.2566481-1-hch@lst.de

To: Andrew Morton <akpm@linux-foundation.org>
To: Chris Li <chrisl@kernel.org>
To: Kairui Song <kasong@tencent.com>
To: Kemeng Shi <shikemeng@huaweicloud.com>
To: Nhat Pham <nphamcs@gmail.com>
To: Baoquan He <bhe@redhat.com>
To: Barry Song <baohua@kernel.org>
To: Youngjun Park <youngjun.park@lge.com>
To: Qi Zheng <qi.zheng@linux.dev>
To: Shakeel Butt <shakeel.butt@linux.dev>
To: Axel Rasmussen <axelrasmussen@google.com>
To: Yuanchu Xie <yuanchu@google.com>
To: Wei Xu <weixugc@google.com>
To: Johannes Weiner <hannes@cmpxchg.org>
To: David Hildenbrand <david@kernel.org>
To: Michal Hocko <mhocko@kernel.org>
To: Lorenzo Stoakes <ljs@kernel.org>
To: Liam R. Howlett <liam@infradead.org>
To: Vlastimil Babka <vbabka@kernel.org>
To: Mike Rapoport <rppt@kernel.org>
To: Suren Baghdasaryan <surenb@google.com>
To: Michal Hocko <mhocko@suse.com>
To: Hugh Dickins <hughd@google.com>
To: Baolin Wang <baolin.wang@linux.alibaba.com>
To: Jonathan Corbet <corbet@lwn.net>
To: Shuah Khan <skhan@linuxfoundation.org>
Cc: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org
Cc: linux-doc@vger.kernel.org
Signed-off-by: Jianyue Wu <wujianyue000@gmail.com>

Changes in v4:
- Address Baoquan He's review on v3: align patch 2 subject with
  rename-only scope; fix vm.rst sysctl documentation; refresh file
  header comments in mm/folio_lru.c and swap.h declaration comments.
- Expand patch 1 commit message on CONFIG_SWAP=n vm.page-cluster
  registration (also on CONFIG_SWAP=n kernels).
- Link to v3: https://lore.kernel.org/all/20260602-ch-swap-series-plus-folio-lru-cleanup-v3-0-5bbb567f8c99@gmail.com

---
Jianyue Wu (3):
      mm/swap: colocate page-cluster sysctl with swap readahead
      mm: rename swap.c to folio_lru.c
      mm: move reclaim-internal declarations out of swap.h

 Documentation/admin-guide/sysctl/vm.rst |  3 --
 Documentation/core-api/mm-api.rst       |  2 +-
 MAINTAINERS                             |  3 +-
 include/linux/swap.h                    | 75 +++------------------------------
 mm/Makefile                             |  2 +-
 mm/{swap.c => folio_lru.c}              | 46 ++------------------
 mm/internal.h                           | 68 ++++++++++++++++++++++++++++++
 mm/memfd.c                              |  1 +
 mm/swap.h                               |  8 +++-
 mm/swap_state.c                         | 37 ++++++++++++++++
 mm/vmscan.c                             |  2 +-
 11 files changed, 126 insertions(+), 121 deletions(-)
---
base-commit: d7be408821acadd7d713d1da16a6742886799114
change-id: 20260531-ch-swap-series-plus-folio-lru-cleanup-d9781c8332dc

Best regards,
-- 
Jianyue Wu <wujianyue000@gmail.com>



Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7C0D4CA5FD4
	for <linux-mm@archiver.kernel.org>; Fri,  2 Oct 2026 01:25:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 693AE6B0088; Thu,  1 Oct 2026 21:25:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 644836B008A; Thu,  1 Oct 2026 21:25:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 533FA6B008C; Thu,  1 Oct 2026 21:25:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 206AC6B0088
	for <linux-mm@kvack.org>; Thu,  1 Oct 2026 21:25:34 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 6B2B6405D4
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 01:25:33 +0000 (UTC)
X-FDA: 85275943746.01.1D0B29F
Received: from mail-dy2-f42.google.com (mail-dy2-f42.google.com [74.125.229.42])
	by imf12.hostedemail.com (Postfix) with ESMTP id 9D64940004
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 01:25:31 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=KJ5dJFIN;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf12.hostedemail.com: domain of odys.yuan@gmail.com designates 74.125.229.42 as permitted sender) smtp.mailfrom=odys.yuan@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790904331;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=G6UX0d8wcE3FCfnSy6NmrZ53ZLwwwBzpYO6pRbLaARg=;
	b=TUFA+8fm/A0ieiDe6Owx2ppRukbb9GhxgN+00McQgufamI7cUtIB2SszhROBhGufsWM1IJ
	OHIyW1LDMQUVKm+vhJSgQmVC0WO4IQS3GC0qaty8qTqE6jy8OVhuEIbNMlNeGJkVQ8D1MX
	K/Fr3RAcEFeROVgoEYsGDSkTnZzVLPI=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=KJ5dJFIN;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf12.hostedemail.com: domain of odys.yuan@gmail.com designates 74.125.229.42 as permitted sender) smtp.mailfrom=odys.yuan@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790904331;
	b=fnQJm9qJyEzxwSJJR5Tf9qvI5v5oP+U5kd6FwD8ZN/6t40lbZr7FtXobh3e+G7Y+m2BCg8
	TxjsdU3DLTxqOJbgHe3iXICTmpioL01fD5E67bemF1NAATJa+KDgi7KclG3eeTqitLHGWg
	gsLFAUz+DI4YP81AHW3sVZv+t7hOxIQ=
Received: by mail-dy2-f42.google.com with SMTP id 5a478bee46e88-341d0522b4dso11265562eec.1
        for <linux-mm@kvack.org>; Thu, 01 Oct 2026 18:25:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790904330; x=1791509130; darn=kvack.org;
        h=cc:to:content-transfer-encoding:content-type:mime-version
         :message-id:date:subject:from:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=G6UX0d8wcE3FCfnSy6NmrZ53ZLwwwBzpYO6pRbLaARg=;
        b=KJ5dJFINetejIWL42tcmD4u8oX45YvvzE1iFJ3yOANGKSYWEPCJjKO80CigU1EBKY1
         inYhimGbi+26FKsTCxqa8FcJS8geZmhNCAf8YAfiX4jOZzlJ5t1A9P1fm1WfRszS1XC1
         CcK505Eww2H6m5PJmPFcnVTZuytzYDUI1jvxs1eIPzD9IbtHs/8hc3Ak1p95U/y4sZL+
         DtLtDqmLQzUeMMFTNIpggQUwZbXGiQ7ihCo0Ysqq9HhgoBJ4DscIMQDzTIuY3ipW9hdf
         PiEGFjMltw42POfvpl975ATEi+4TzvlFnPUQm0AbieHFwuoqhO6wcobyWOHgqbVzev9j
         FzGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790904330; x=1791509130;
        h=cc:to:content-transfer-encoding:content-type:mime-version
         :message-id:date:subject:from:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=G6UX0d8wcE3FCfnSy6NmrZ53ZLwwwBzpYO6pRbLaARg=;
        b=l9Mw5Hz1J7HNcu6/CCJfkt9P7ZVik4t0aYWRduFDnkJCUF9pOwOjcRvHzuZyQbqiJX
         TFK9G3wGmdiVucMLKYLiohL1FzOmIYrisTcpBO/DwwN+u1qgfCgGY93GAcj8a68mzP9S
         zqtyhsDYjfqFDOa13n3oTXaobGOVjfYA/T8iBMlpY+B8pdD7BnpBSPsOut9uJygKpNKJ
         dI8jaBGsiR54bBgFTciolEaq32NNXQUHUIFdDbvROl9kKSgIN4O/ZDn/tbcEeMOXfeVy
         wJAITnufGI6tUOV5PcRQigzJwmNWPWzJ6gt9v4OMKeh5cMMTL41/aO5fgvXxVGRLiMTN
         MWow==
X-Gm-Message-State: AFq9FYJR7Ixdqyu/1Gtd1+vmwDgbuEeJV0S1qgPwabTiG0lNNlwPwn4G
	B1jfzhu4zeRbhhQNYJ6yEDO8YxGS7pjMAkdZw/zORknGxO2oVW3jPOaZIHNnJ6My
X-Gm-Gg: AYBFou2qeFuOs9HXtBIBOrZ1ppbS20ia3r+3ZbqkXw7HOhh237tPBKdCNiBe3z1o2Ns
	pieV/FHgzDiMA1e15QX3m97JLXnMZJlfLP/6A1zAeGmPz/gTop8TxMricE7ak05u1UIOv1k/4VW
	NKUmr464pIO6wtvVLCF35j+dlEIQFdoO4VJZJ81WPzmJk0+hps3wCSkToykclCmSkCcGDIuuXvt
	0tbQ7jrfa3KPQwnBZZ9OicSgMsnGL5yV4/k5Awyl2u3t/pv2+FMwCaX4WC2ur67jW3A0wuvgXgG
	SqDEvE4jCa5FN8NZFSo5ysEpvKNaY6hlHD4EEiV1pEa6a+mq8s2YC/PW0cpX8eYuRUu+yRhzrIC
	npG2SwSkiQdgyU4WhqYK2assTOWIs0q3aR1TO1Oid/QfEcAkEEWn7c4MwjLKyxeLEfucXd679ky
	9sW2ESWFfOIE0F4zPmhkbnGa/ALZJcEkBSsXOZGYN37ummaOLnSWSfDCpay+bmZFvMRA==
X-Received: by 2002:a05:693c:6385:10b0:34c:94a7:b783 with SMTP id 5a478bee46e88-34f15085393mr1226098eec.12.1790904330115;
        Thu, 01 Oct 2026 18:25:30 -0700 (PDT)
Received: from [127.0.1.1] ([23.254.208.9])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-34f14f984e4sm1837223eec.17.2026.10.01.18.25.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Oct 2026 18:25:29 -0700 (PDT)
From: Qiliang Yuan <odys.yuan@gmail.com>
Subject: [PATCH v2 0/2] mm/migrate: speed up move_pages() node queries
Date: Fri, 02 Oct 2026 09:25:25 +0800
Message-Id: <20261002-bug-mm-move-pages-stat-batch-v2-0-f73b5d20519f@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAAUIv2oC/43NQQ6CMBCF4auQrh1DGwriynsYFgMOZRJLSVsbD
 endrZzA5fcW/9tFIM8UxLXahafEgd1aoE6VmBZcDQE/ioWqVSvrWsL4MmAtWJcINjQUIESMMGK
 cFphbhaon1Je2EyWxeZr5feTvQ/HCITr/Od6S/K1/hpMECUrrsaNe6q5pbsYiP8+Ts2LIOX8BM
 hftjMgAAAA=
To: Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, Zi Yan <ziy@nvidia.com>, 
 Matthew Brost <matthew.brost@intel.com>, 
 Joshua Hahn <joshua.hahnjy@gmail.com>, Byungchul Park <byungchul@sk.com>, 
 Gregory Price <gourry@gourry.net>, 
 Ying Huang <ying.huang@linux.alibaba.com>, 
 Alistair Popple <apopple@nvidia.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 Qiliang Yuan <odys.yuan@gmail.com>
X-Mailer: b4 0.13.0
X-Stat-Signature: me3pa58rrf53ftpnq5e65s3h6etu8bix
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 9D64940004
X-HE-Tag: 1790904331-923247
X-HE-Meta: U2FsdGVkX19uh/gs/oPmHMaVZAhK7YwTzLAhp89JElYgsbYV+xy9HFnCVYC56/vcB8YuW7y833Bf0aaSylC9fc6idkeMoIBd17MdBOb9UCUmanQGKAm7CfDIaPnnm6iJ/WGi+50k7mOERkt8On4GQ+L6rmeNBXrHnpKcj8PA8OqP0Ow4c9D5QUsPpL7yzTROV8/jyMMmNc9lc3IXkAcvn2qo36vGr5/f0DTctgACcyPDGx5yowq0rQYwtTP9tNJ7QKa7J4KXV2IdnGE3vhbHOsOeKugvFg+I5mjfopzF6aajftsC8s9w9quXp7ezUaoEm0XulzzrjABLxP6pjYcMHYYIg7ueJ+y1efQamHbfncyrw4DblkaLHl5aVr4i+lUCafOwYJLlrSR34KhkTkTPii7d7oH/DgszROcJy3Yd1UKpTmTrRHnfiPKnLK7vGeFozjxFIGoS+XdcOhD7URM9U90SHq0zZl8WvwcaEuHBfheKXm5EvMxeOb2YfBME6Oym+96xQWFCttscK+2YcnY6k9gQg3emlJTC944tKLmW+yT+0FhReCpKA6/VRf7kQs+TuM+SDbhuZTHtxoWD+mprpW7+JxFRYkwgPty/5ZmCuVeU4+nkVGlCAyrEyCF1494gRDsNfC41PilXhSZ9VHgQPEpDmp8NSDo04G6u86J4nc3Xjirfy3sbWKhIGqQM/TOZntv2qEVyMTKUdD1+FbGsddOmUMiSQizskxWMEg7rIAO+sZ5sOsqgJvXcj3JRs9qfrjqZHVpc/AfAEQwaGYRtlYiKvpBtGfeLCGCkiRrKOdYoqRFLHZLHUwvG0Ni/WniTmA5LUIBHZ7XDb4tMl96QBiRfi26B6XoccB7NCkUVYH1tjdKml1DA0NQRbtDQBCs/ZQpG67mhx7VgPkGA+leGB1gSAT3d0mR+Ru6QQ6OI9Fk3K2XBCz3x11jEEieS9ulCliAo14xXPpQBNnMECQA
 UFSFZxdr
 YmPxIe1hKv11QQ9kyu8jsXNlcTpDV0RbtYTywSRx2Rs+NcRqWpFHQkC1uHVt6y1NYr65QmHNKSpW87soOkRdOMTzzfF85TD4SJhMVNahuHaVYr3wc3/WQSgeTTgw4mlGWLHNzn8LM8mdhlL/765tXBbaAlR5Pm1F2kk9uUcl4X6mnRWlGF7jorI1Aq2ShqXbSH1BOnmxOLRF9QpmNo6ny4VWfqsKss6zcScC2EKQ03p2eRzUYHqGYV+Jsfe6C/KvAYlEF+XXot1WIcQU25UyOpx106XsF1MgmMOkcgwqjxTXZE5p/dc8tKeBzgMxjcQfQbLk+8j0P58xOvPQsu0DR9fT/syjqjBOE3RmMvJvKwNU93j2MPm4lARNVw9OZC3lOpUdY7P3FVnA9g1bUnwIRcyg3BmpgrcUJZFgtx3nzKtY3uLmu4tFRqTDcOkz6XgHtTvQ0JKTQ9fo+db1++h0jet8ow93OEOCIaGWFv94zYIL9CTzPlsH5kl1/OquTPQACiLlOJccq0bUeSFMShgGd87zqotydpd9dv57YO4nlpun0KD8AyMto1Sjj/a3sijv97Rk4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

move_pages() with a NULL node list reports the node of each page, and
RDMA and KV-cache engines call it on every page of buffers spanning
hundreds of gigabytes. do_pages_stat_array() walks the page tables from
the top for every address, at about 105 ns per page.

Patch 1 walks runs of consecutive pages with walk_page_range(). Patch 2
raises the do_pages_stat() chunk from 16 to 512 pages so that a run can
cover a whole PTE table. Together they bring the per-page cost from
104 ns to 12.3 ns with 4K pages and from 90.6 ns to 2.0 ns with THP,
and a 16 GiB buffer of 4K pages from 486 ms to 52 ms.

Signed-off-by: Qiliang Yuan <odys.yuan@gmail.com>
---
V1 -> V2:
- Walk the runs with walk_page_range() and a pmd_entry callback instead
  of extending folio_walk_start() by hand (Zi Yan)
- Raise DO_PAGES_STAT_CHUNK_NR from 16 to 512 in a separate patch, with
  numbers for each chunk size (Zi Yan)
- Re-measure everything in one run on a VM that now has two NUMA nodes,
  with the test bound to CPU 0, so the baselines differ from v1 (16 GiB
  of 4K pages: 486 ms instead of 440 ms)

v1: https://lore.kernel.org/r/20261001-bug-mm-move-pages-stat-batch-v1-1-255b7e915744@gmail.com

---
Qiliang Yuan (2):
      mm/migrate: walk runs of consecutive pages in do_pages_stat_array()
      mm/migrate: raise the do_pages_stat() chunk to 512 pages

 mm/migrate.c | 206 ++++++++++++++++++++++++++++++++++++++++++++++++++---------
 1 file changed, 177 insertions(+), 29 deletions(-)
---
base-commit: 551c722f40809618230001baccf219193e22fc5a
change-id: 20261001-bug-mm-move-pages-stat-batch-f62a29ea5867

Best regards,
-- 
Qiliang Yuan <odys.yuan@gmail.com>



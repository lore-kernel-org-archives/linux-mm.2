Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3436FCAC5B8
	for <linux-mm@archiver.kernel.org>; Mon,  6 Oct 2025 20:03:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 67C168E0020; Mon,  6 Oct 2025 16:03:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 62C998E0002; Mon,  6 Oct 2025 16:03:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 51BAF8E0020; Mon,  6 Oct 2025 16:03:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 3FE808E0002
	for <linux-mm@kvack.org>; Mon,  6 Oct 2025 16:03:08 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id E7AD65A7FA
	for <linux-mm@kvack.org>; Mon,  6 Oct 2025 20:03:07 +0000 (UTC)
X-FDA: 83968763214.01.13D3D80
Received: from mail-pg1-f174.google.com (mail-pg1-f174.google.com [209.85.215.174])
	by imf23.hostedemail.com (Postfix) with ESMTP id 04F7E140005
	for <linux-mm@kvack.org>; Mon,  6 Oct 2025 20:03:05 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=TC26FN6N;
	spf=pass (imf23.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.215.174 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759780986; a=rsa-sha256;
	cv=none;
	b=tIZ+nBEBAFvjh35mkYqcPhjF49nd8vvLG905W61FDEUloC3YmVN7FZUZ1D7SRvySmJ/BOD
	CparK9+PAVgxGp0h40bwqXDh+xS95LzdYADIO0mx9UXwz1vBpYBPTGXTNlul2gZVLB0sCw
	yddF2hqsirkB8NND4h2fN7WmvrXMJE4=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=TC26FN6N;
	spf=pass (imf23.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.215.174 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759780986;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=OPonIAH1BxQsQtr1Fp2wusarT5XUOhEuCk2sJi7fQwA=;
	b=oSIkbdkTC2MIY8PstK4S+Fk7rDnJf9JdfeHllh5nwsyLUbCilLvIr+NqgwJHFMOT4dDa0j
	4oqpCinadUBdYp2WS6158mdcHKKcY0RyA/aqTtW1qtlqm9wEAsMdS/xBLciOZp2dks5ytG
	BgDEnlXiVX+rATElDqA809zn89i9+Q4=
Received: by mail-pg1-f174.google.com with SMTP id 41be03b00d2f7-b57d93ae3b0so3664549a12.1
        for <linux-mm@kvack.org>; Mon, 06 Oct 2025 13:03:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1759780984; x=1760385784; darn=kvack.org;
        h=cc:to:content-transfer-encoding:mime-version:message-id:date
         :subject:from:from:to:cc:subject:date:message-id:reply-to;
        bh=OPonIAH1BxQsQtr1Fp2wusarT5XUOhEuCk2sJi7fQwA=;
        b=TC26FN6NG5Nn6xyCJ6vCn43ymGep2QBJW4UzKYTBc5Kk7Le+uVRwngOZrflqs1k11h
         KBLGHeHAe8YKZHisvusVHUtYcBUO9eTdiXBo++sAiNy2+RJysM7eiWunWqrZ4HPp8/08
         hWPDuCFJyErsT/U6Q/wjPzsNqaiy8l3fdVYWsqwKNg6jZgGfWXhO0L5zt2mzJfwzuiWy
         5dSNmVUjF/B24NxUGPhqauiZPnr2sPzIz5iw4JuO5QDWWeniJq0E7OR81COIzCbruoNi
         6cogD9Q6TdEUgoNAIVXS8b1h1qXZaER/zDTOsMP7ynp5KkpI9AOKqkARHjKIbCaT0m+F
         7vtQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759780984; x=1760385784;
        h=cc:to:content-transfer-encoding:mime-version:message-id:date
         :subject:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=OPonIAH1BxQsQtr1Fp2wusarT5XUOhEuCk2sJi7fQwA=;
        b=RmjQoPgDZFzSnNq5WjYmqf4VWYkQZ4KW08hYIZXlMJrm3wSH4hL4n45QTglEx1YnFR
         F03OJJD1yRGwywARtWHCtHcN4Gh4N/eoQegSM0bvN4aBww0NJ8XRK2ixo8+80gP6855h
         PLkxL1KZtcXqJuxDbwluomljy9LDHXkZX7pBd4561y7Z+j3kzXbeyRqIXcobaHmU+I5A
         /xV9/cJIX5JjYwmY2oXEAvu8q0liOVXc8jylSoKTkzmRRT7Y8SwLpWDz8puowl3yLPHk
         M3VNPy7n48QX9GxDOtU3XvL+DJkdVnfRub9F3Rn3trGruOrjaL1EKpMNtkaDRP9I1Asp
         Wehg==
X-Gm-Message-State: AOJu0YydWqRuyG/tBzZdvc67fCMj89IgbTVWpDJMq9B+Yo7yVb/1+FDF
	9Qd/HZD8xtHiYA+CQMuhsUIsoQJKrdY78bBbAIdV9Ksa8mO5OZJoFK0fWt0Tr25B
X-Gm-Gg: ASbGnctVKqWHzenr0FaL7tAQf/swL98Xq2dqj5p9gXdigpl89Dk9IXCatKXQkOw231p
	K++fJ4XRFs2ESTslX8N9RzQUI+0XLgu+pzPD+TV2FIoD2ChqpGRfWzWA041Gxg7ZSnY98Sb1rrk
	zIjbhMLTrKg1weSzQUzUH5rSvzOsUB85PEDpHDzsgSKviXDaftXlidK/FX9ePIbYvO4+KOLoGO9
	BBZSrWmDh+mIP3nY7x5fRBTJovdwVyefvF8oe+OoIGhWWjoaLOZRmuyIX7VzGzuBL/aQhEHWrpS
	ymUD24Zn/1LhjkCjkDewJDv7riiKpm8r472CX3vQTMs0bz/dNgTDq/gPxAqc5XttvpqkO2g7tug
	XNeS6c39/qZnRYXBm484oyFGee6UlOR2gpA/GiI3+GgXvXv37GspWBi52YaBz+PM=
X-Google-Smtp-Source: AGHT+IG+0oUQlrSsGCn6Vgw1ZjZpeukVO6DKfpXCGE9O6Ywd1toItQoNbpHsbdY1nkL3pyjQL+eGNw==
X-Received: by 2002:a17:902:f691:b0:27e:f018:d2f9 with SMTP id d9443c01a7336-28e9a61a6d6mr182472965ad.34.1759780984255;
        Mon, 06 Oct 2025 13:03:04 -0700 (PDT)
Received: from [127.0.0.1] ([101.32.222.185])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-339ee0ba20asm163148a91.4.2025.10.06.13.03.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Oct 2025 13:03:03 -0700 (PDT)
From: Kairui Song <ryncsn@gmail.com>
Subject: [PATCH 0/4] mm, swap: misc cleanup and bugfix
Date: Tue, 07 Oct 2025 04:02:32 +0800
Message-Id: <20251007-swap-clean-after-swap-table-p1-v1-0-74860ef8ba74@tencent.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAFgg5GgC/yWNwQqDMBAFf0X27EKiWGl/pXhY9aVdkDQkokLw3
 w32OHOYyZQQFYleVaaITZP+fAFbVzR9xX/AOhemxjSdNabntEvgaYF4Frci/sUq4wIOlsen9I+
 2A1onVCIhwulxD97DeV7BTplFcAAAAA==
X-Change-ID: 20251007-swap-clean-after-swap-table-p1-b9a7635ee3fa
To: linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>, 
 Kemeng Shi <shikemeng@huaweicloud.com>, Kairui Song <kasong@tencent.com>, 
 Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>, 
 Barry Song <baohua@kernel.org>, Chris Li <chrisl@kernel.org>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 David Hildenbrand <david@redhat.com>, 
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
 Ying Huang <ying.huang@linux.alibaba.com>, Kairui Song <ryncsn@gmail.com>, 
 linux-kernel@vger.kernel.org, stable@vger.kernel.org
X-Mailer: b4 0.14.3
X-Rspam-User: 
X-Stat-Signature: 4p6ced4whzo4c4bwb1fumbjah1izeea1
X-Rspamd-Queue-Id: 04F7E140005
X-Rspamd-Server: rspam09
X-HE-Tag: 1759780985-189281
X-HE-Meta: U2FsdGVkX1/lh8rcfapXr6xNhF1DEXtTvrSBYy/xNYfVIxpjaGOlLVYb3FWC3+WNR7CZua7PZmpkorxaCilgVjzIF/kWlp2EwLqUCWDrBxn8BOZVoN/V6891oC2SBRIAUD2oN8bKteP7jdPlkXlEWjHp4kfXzDR7mqO7krmD2iv95IF66sPa+TQRyYl2y7XwugUmhS9h6ouUqzAPcTMfPXQ4k1kwvTA1TigKn6qoPCViOPDBhQQjoWWD437TdQu0uVk/jD9qmiHUhQAqFp6usER/jYs8ztUsUZ3IvApW2DguoZqPrh8cH9JQbzGONrdP3T9NpeV+J6WtJ0YmGMMc06jwrw9FQ9OMpbIn7aygryjv2p+Dgu0D+mttSiKKlXg1T5lL73DvZ0c1ewgyx/uN84+UXhYoCi5F2YYGgIsJa3ayu9UB8ugE2luA79L86ZJuoXSAWKiFTlmzgBx6YD2/5BY3CPDddo1HlJp21HksBhZ9RHk3tXqlpo5iut9F+Bpuk2d3GQWPGt4Q3YSzra+tWDbK2fnB6bbEwMwEtwNJfTTTdOITHOvKVQOXLBfaTN8zoS9uQxD1UqOM3Bl+Qr/9TneAZhnLTEPDAjj9Vnwi7oxuQm31ShOCF+C5K9fhobToMyD2dYNOt00uAcA2gg6VA2ttIUfaY8El+irofi2TUa7u/Kz/ZUJ7cXJ2kvn88qVLyRvYznBfN4+m7UhrRQBa81BV3dCN80oznvBWvz4amcecVAgEuwD/q6X/9tDqwo61oRlF0kLx9e6OAqSB4L57SBNEYV6fRNlUBgWFrJOyNZuduIeoeadFO0v0I3g3gy+t1v4MU+Uz2W2bl95OQSRnH1r9968p+e5IkFYB/5x1vrHwXX0KGnM9C1F3QHvxkyK6SKfCAYnJp+PeOssiFVaUtcvIqZBOs9nTqQW/7j3ZuDOTeKFltZtibTSa0iZnEnL+MkWBwRz26jGCxGVidIh
 MuM6uOSR
 K5bf6gx4MclRDXFItPM6eoYgL0l8OGvASXMgzDU7aTA4chZc+QebcggG7y4RZ4bP3XKErgVVKUTvqrJMdgXgGaTnEEeeZnpHHz46rrA7/3zYK/WQYIKU0brDoOHhimlHKwX+NAf7zd7jeZmga+KaFCGiyTn91vAJoOQNWs/mByHz7+WoNPR97w/uqg2q/67scyOZakV/Yow7oKwq9XXptv6RU+qqpbK5WaSsk68+GawHAynxNkRXtbaMnaV3RbDGrzMYCawoDnsQLHxkQEaaxEgPbMk7Rzxr3pI5Q4Tsmw8RQAUpFSNcOfaxcjypihG8eSsa0IxCtJguBbQ9bIARzmBqO1b7GzxGZ+V+TAU7DSLUKbNoHXsySNyFNR+VjuP4B7MH6s9CpZhh3KU5Y4eqan0rU9Rql6JNc0vjo4Ko45CeoWqTnNGL7UZpNlBu3yEMPNpF0Pziflm6NJZZ8agD0R3cN3g==
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
Kairui Song (4):
      mm, swap: do not perform synchronous discard during allocation
      mm, swap: rename helper for setup bad slots
      mm, swap: cleanup swap entry allocation parameter
      mm/migrate, swap: drop usage of folio_index

 include/linux/swap.h |  4 ++--
 mm/migrate.c         |  4 ++--
 mm/shmem.c           |  2 +-
 mm/swap.h            | 21 -----------------
 mm/swapfile.c        | 64 ++++++++++++++++++++++++++++++++++++----------------
 mm/vmscan.c          |  4 ++--
 6 files changed, 52 insertions(+), 47 deletions(-)
---
base-commit: 53e573001f2b5168f9b65d2b79e9563a3b479c17
change-id: 20251007-swap-clean-after-swap-table-p1-b9a7635ee3fa

Best regards,
-- 
Kairui Song <kasong@tencent.com>



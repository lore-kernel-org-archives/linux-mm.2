Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9F453C87FD2
	for <linux-mm@archiver.kernel.org>; Thu, 31 Jul 2025 22:00:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 13D286B0088; Thu, 31 Jul 2025 18:00:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0F0966B0089; Thu, 31 Jul 2025 18:00:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 006136B008A; Thu, 31 Jul 2025 18:00:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id DDBCD6B0088
	for <linux-mm@kvack.org>; Thu, 31 Jul 2025 18:00:30 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 575A4160C3E
	for <linux-mm@kvack.org>; Thu, 31 Jul 2025 22:00:30 +0000 (UTC)
X-FDA: 83725929420.10.5195A19
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	by imf23.hostedemail.com (Postfix) with ESMTP id A232814000F
	for <linux-mm@kvack.org>; Thu, 31 Jul 2025 22:00:28 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=DZFfyWio;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf23.hostedemail.com: domain of 3e-eLaAYKCMQ241oxlqyyqvo.mywvsx47-wwu5kmu.y1q@flex--surenb.bounces.google.com designates 209.85.214.201 as permitted sender) smtp.mailfrom=3e-eLaAYKCMQ241oxlqyyqvo.mywvsx47-wwu5kmu.y1q@flex--surenb.bounces.google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753999228; a=rsa-sha256;
	cv=none;
	b=lhVbKkwE9zNsxAVXA7i/ZZf3W+YQ/8GtpnT+tUOWRX9mALa/YwTAQ+UPsgMJlnMnS5xfB4
	zg/oDt2Kx31ym/mLNvQdsUZLojO/NGbTVIG1aK2t+5n9TeDM5Q0TJQlcgZf1hMGU4HmFaq
	B0o9NaLQG6efXIf3Ojvg9JjpGVFXYeU=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=DZFfyWio;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf23.hostedemail.com: domain of 3e-eLaAYKCMQ241oxlqyyqvo.mywvsx47-wwu5kmu.y1q@flex--surenb.bounces.google.com designates 209.85.214.201 as permitted sender) smtp.mailfrom=3e-eLaAYKCMQ241oxlqyyqvo.mywvsx47-wwu5kmu.y1q@flex--surenb.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753999228;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=cCSvQKtWkk35NnkkH+OyPH5z8EOYlo24FiwE70HiXFE=;
	b=1sTNAy5z3pC0AL5g53vBg9E4XHGUxEsrvpz5XA9tGQiA+ge2tuX7UIevuoQq7zgx5h+YIX
	fl25TL6UGRPtNupETeR4YibCgJIdzp5utt/fMvv6ckyTfVMZJWB+/gwEteyixt0xdQ27yt
	vNHsmu8LUqj+7DZDypj2+khEgXRZcHU=
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-240012b74dfso1684995ad.2
        for <linux-mm@kvack.org>; Thu, 31 Jul 2025 15:00:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1753999227; x=1754604027; darn=kvack.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=cCSvQKtWkk35NnkkH+OyPH5z8EOYlo24FiwE70HiXFE=;
        b=DZFfyWioGu0XU+cMpa6nQbqEJfyu/rmF1H4mb++oNkpbqXACoEnzaQd89PrhYRG0Yz
         bnFi6nee/QJcWih+wR472d0sEmw4gg64xSdbm/xFDQu4MQr6eCg+5jsAUoKOw2Rpjbqf
         Y8QPY5Pg1qUijP0BZMWMX1waIK7edeV3kpwmVBIUrTxcWBG5RSQNhnfpbzngMuKrEOuK
         pkGaUefXlHg5QC97V5RN9EZBtiKEkw+iH4+WTjL026GnaVUuQ8xgkn9GX30ItN2oaodo
         IDfrwqdlP4+YxkUf05YbOeToZu83SBOzA3cn8h9KmQduTeN1r4G8Ww8fIM8OluHbzXFc
         rZug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753999227; x=1754604027;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=cCSvQKtWkk35NnkkH+OyPH5z8EOYlo24FiwE70HiXFE=;
        b=pPV+kUy0T0sr8J5hCOcPyfb+SmMAnpteK33Ad4J75w8PclSxQx4ZQh57Xqe6cWZYuv
         PhuRgq8h/Ya9JhXK/SxhuRKEIPqRE2Ps+fb4+Q8qHajFaeT6Dgls5mfpi5Dn6P+Fze0G
         zyP7KjFjZxTDSGS19INgrFY9VQFiPxL6kUYyFcxf9cQ0OSXfvCIMioJ8yrEwEStLPhfs
         Qlothyhy8RBm1JTLV6Mf3ianM6xCcXNus7ZZKhPvRBgLUEetAL985TNtZLzEARIfTPIq
         3qkOIqcPuBfLyjU4vs/jY9Rp5WrYpqKRkBvw3NMjNGGBCV/3+N7DLDdia1fchk7I/ibQ
         IpSg==
X-Forwarded-Encrypted: i=1; AJvYcCUcVYW0MCOQNN2SO2Khn6Nlp4qPNj58APHrV7Q1X94w0x04uB4zWzYeK+2JjD+iEDkL6zEcXbFAoQ==@kvack.org
X-Gm-Message-State: AOJu0YxB58OUZ5wteE5LtjKMx6FeAVE6xMS7ZXcPpHOjnRfvSYmMBU9E
	fwmVZGggHZ8+KYj2C3xwj238+Gd8RZ/pbW1Rvyi4KscREO7PqNq3e9sq8FK7AQEvk9UuQ8+l7Xi
	q9KC3Hg==
X-Google-Smtp-Source: AGHT+IGtegZ8YgQm2ROATdnX6in35bV2Ie8nf5pnKlyAF9NAZgIOc92HgxdoMwUjsjKWnQz4jS6av6uz+y0=
X-Received: from plkl11.prod.google.com ([2002:a17:902:d34b:b0:240:11bf:3c68])
 (user=surenb job=prod-delivery.src-stubby-dispatcher) by 2002:a17:903:acc:b0:240:3e40:43b0
 with SMTP id d9443c01a7336-24096be1970mr126184995ad.43.1753999227429; Thu, 31
 Jul 2025 15:00:27 -0700 (PDT)
Date: Thu, 31 Jul 2025 15:00:21 -0700
Mime-Version: 1.0
X-Mailer: git-send-email 2.50.1.565.gc32cd1483b-goog
Message-ID: <20250731220024.702621-1-surenb@google.com>
Subject: [PATCH 0/3] execute PROCMAP_QUERY ioctl under per-vma lock
From: Suren Baghdasaryan <surenb@google.com>
To: akpm@linux-foundation.org
Cc: Liam.Howlett@oracle.com, lorenzo.stoakes@oracle.com, david@redhat.com, 
	vbabka@suse.cz, peterx@redhat.com, jannh@google.com, hannes@cmpxchg.org, 
	mhocko@kernel.org, paulmck@kernel.org, shuah@kernel.org, adobriyan@gmail.com, 
	brauner@kernel.org, josef@toxicpanda.com, yebin10@huawei.com, 
	linux@weissschuh.net, willy@infradead.org, osalvador@suse.de, 
	andrii@kernel.org, ryan.roberts@arm.com, christophe.leroy@csgroup.eu, 
	tjmercier@google.com, kaleshsingh@google.com, aha310510@gmail.com, 
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-mm@kvack.org, linux-kselftest@vger.kernel.org, surenb@google.com
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: A232814000F
X-Stat-Signature: 6at6bum78rzib45rode37moozbzx9z8i
X-HE-Tag: 1753999228-395891
X-HE-Meta: U2FsdGVkX1+Jb/S8OnSWj2AGiZ7q9sF+CGZ6WGZfV+5ze6I47hqaLIE0XiGBeVo9O8f5kRUYaHuqBb5s2ZGPhpgW6gFE30to9fFVu0bOFWUlleLEn88rWuKVZythrKTAC2TVWvZOHK+WM8odxYqEBT9DAzzvLrOpVBUYk35jDBSKNK5q/onJxWTzFc7XwQ161p+nlyC1VY7+1DPBdxGk3AKKn1ALN/6X21dT+zkBt0ZvD/pKg9tM7bliXng9jnE+TTrpgRoX33qc+iKtVWyBJ/1kz0jcLd72cJfEjm571mozJKq/melDNyTJDLm+n69Hzh08djWwtTE2/Sl1YiAy/CDW6P2lZZfpra3DMxVBxo1LPGwyAfFYYON0SH4nJAsGD2CyQDC0HL7DkhnCS0P+ipz7Syo7dgcBvq1JFtv6DghNXPjc7McjpZDsN5i4do8HTvwtmQAzNLc/ocS8luyWUtN2PER4qzHem+f9c924hpjkLIdnIO+95+EFdq5TBg9+izu1HixrEu2MtMbf6lgFf/vGltAZtUbJ1GF2GoII8ursqk6OZagjFejTwiHZLuYT5nI4O9EMp8T6R7o4UL0hL0079zoOGjzeCPWdzGtmmhxzYx9V/hgNcR/T+8eVWhw5qeGRrAuuAp66YljKf1W5d7JU0V51jeVdfbrr4OfvbhiQkDLb0ZBS9iVP5nAoJef6ul8FYH/YjNQYH4hoIE6rB3vrOa/1IPaSfmzfGZxVYi38fadyXlpeJvRZCr3+V3JaH62jb4liwDDULjreJBt1/mG6rqQhqtpZ/FD6EUJSNtH5FiTThS6/yCt10CpNobXp2APgGng6kfWmbq00VbsJRGDFv11Lu7eScWrZ3n0xeX4yMl6TUQza9bX83EUXdOmK6pVp12rqr+9fRrFjkqTOrJ294wdTMjQer6DAcTD6PR16kPkH+lLcsSodGResRIfpCzzbo5HZl+UFzDptKxw
 YxJKDVyg
 fmINTZ0zTpLU87ANq1gObYl1GCWLvG9ScPtYRwABsgNkSc7MOvrYBRO8QFfLhUoXVZjCoX5o1bR6liRDQAruH9GrsxFERnpp9Q1JymLcRy76x6WyCyWEr5rNEII7J9rPx1V9F9Lrh2OVkvhcHaIj7D5TCoDQ8iyAzg/eqTGl/wDPKwbdpnyTbUSgjRwDKlcVk2C4SypTyWKLAxgNmROGHcMS8hqFme2azAjrVqkGjPgRVXbeYnoCEyqlFVTvUuUQYk6O5OFFvg1QGFqjIR/HVy6oKzRdhHjZTZ9d3c5ZaCbIeMp/CnxtW4e3AGQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

With /proc/pid/maps now being read under per-vma lock protection we can
reuse parts of that code to execute PROCMAP_QUERY ioctl also without
taking mmap_lock. The change is designed to reduce mmap_lock contention
and prevent PROCMAP_QUERY ioctl calls from blocking address space updates.

This patchset was split out of the original patchset [1] that introduced
per-vma lock usage for /proc/pid/maps reading. It contains PROCMAP_QUERY
tests, code refactoring patch to simplify the main change and the actual
transition to per-vma lock.

[1] https://lore.kernel.org/all/20250704060727.724817-1-surenb@google.com/

Suren Baghdasaryan (3):
  selftests/proc: test PROCMAP_QUERY ioctl while vma is concurrently
    modified
  fs/proc/task_mmu: factor out proc_maps_private fields used by
    PROCMAP_QUERY
  fs/proc/task_mmu: execute PROCMAP_QUERY ioctl under per-vma locks

 fs/proc/internal.h                            |  15 +-
 fs/proc/task_mmu.c                            | 149 ++++++++++++------
 tools/testing/selftests/proc/proc-maps-race.c |  65 ++++++++
 3 files changed, 174 insertions(+), 55 deletions(-)


base-commit: 01da54f10fddf3b01c5a3b80f6b16bbad390c302
-- 
2.50.1.565.gc32cd1483b-goog



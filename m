Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 57BC0CAC5A5
	for <linux-mm@archiver.kernel.org>; Wed, 24 Sep 2025 20:44:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B07CF8E001C; Wed, 24 Sep 2025 16:44:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AB9A18E0001; Wed, 24 Sep 2025 16:44:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9A7F88E001C; Wed, 24 Sep 2025 16:44:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 861BE8E0001
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 16:44:13 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 34A59117A80
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 20:44:13 +0000 (UTC)
X-FDA: 83925321186.28.4F207E9
Received: from mail-yb1-f175.google.com (mail-yb1-f175.google.com [209.85.219.175])
	by imf30.hostedemail.com (Postfix) with ESMTP id 7143580013
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 20:44:11 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=izrTFCSX;
	spf=pass (imf30.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.219.175 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758746651;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=nfUQ5D8UXsQpdFNJBj9JNJ56MdGhDsygR0SMM5MuzEA=;
	b=V3FsHBZM5/XMp7XHR5/yTLt7upc40Rfv70sNeNsUMUrIE51tP7TjFEa+AGqFySgkJJYDlM
	kURfaUifGhNfRw8TaS0UtN4atawVhORDy7fpUqXH+vGNIgosq6rIjUqrt18xacLOeSkhiK
	0rzYC9L23jZEwZ1DUqg+kwmN1Ol7NXM=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=izrTFCSX;
	spf=pass (imf30.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.219.175 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758746651; a=rsa-sha256;
	cv=none;
	b=YlfxKPHVpLw5ajP5YpIetYTgRWAfP+z6Ucudyf11QyNaNXik6qrLXWyr7yCavwnVXLFJsl
	OvEFj78EZRbm3XQy/6wSxZzdFyFaHZ0YgOmAq4MhRXcXMsh1XZwg+/tkaRLS615Pe8rKHi
	RjDfrYJqur9D63xrEJBYHqcj8EFl570=
Received: by mail-yb1-f175.google.com with SMTP id 3f1490d57ef6-e931c858dbbso231539276.0
        for <linux-mm@kvack.org>; Wed, 24 Sep 2025 13:44:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1758746650; x=1759351450; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=nfUQ5D8UXsQpdFNJBj9JNJ56MdGhDsygR0SMM5MuzEA=;
        b=izrTFCSXiJyNoTBI3xq1ZTh8MED2DhnJsmqOP7qx7BExkzOOt/SxrjiDvCwMBeqpZ3
         1oubg8Kzjvo3rGr95njdRyS0jobe0g0hgRxT0kwu87rf5dHSnKcq6tuZXnvChvHiwAHS
         EN1uDWREMaCYW5SMauyYGe687smAz+pdGn+pORZ7ygE/PR21toTaz2jyDlm/PIINqXyg
         Kvm42h8MPTwx3KgY/Wa1iAzDrg6mH7csHjFT0pCOYzdnuNM8Qc9squxoiKlvi59c0DeS
         SYrf16N8B7S0De7egtWytCJQ1oXt3MoC07pnz16CDn8ug2/kaKyNLhHW+ibi+Zg2UyRm
         SfCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758746650; x=1759351450;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=nfUQ5D8UXsQpdFNJBj9JNJ56MdGhDsygR0SMM5MuzEA=;
        b=Z/nkiokKXwvXA+XR4aPFEPdHio6QxDTVtWGFTih6tmXtT8pAU3hMnSgTmyMQgJVEVp
         d2pgVn2Hgqt4mpNT/MxQsfq0+vrxMDZN2eNAgnHfzBpPzl7pj2rjbfUoMsS3oWl3Zkf+
         AvNSf0UEcLUg7Ef/tjuuJ9ZTeXj/G9DNSGKAPArY18Kfz8duYrZapEf3whZH2KQHgvwi
         Op73e2cSlczCHjD0LbfG+44/Oyx13Gkem8PxfPR1xTtP9dr8my+vqQpadLAbs90m+b4q
         YvYR71+PrY+SAbWAqYDc3KOwSCnUJtKdE5yDSJYvP6sYyaZ9BpYol4xFw+Sg4kY5VI60
         KefQ==
X-Forwarded-Encrypted: i=1; AJvYcCXHBwKVLEA+E6X5APemH4fWuMB4BclgoopkACkkhwwvgnVV2Rri7eUiyPS2uMaMym9/CqdekpjAIQ==@kvack.org
X-Gm-Message-State: AOJu0Yx9Qwpk1MZeM2kvhSWLyF4u2bjshujhYbbgcLJd22KzG/a8ybII
	mD9ki5kBD6NeWODO1ZiBw77Zozb/X2h8T0nmEq8V22+BbXwNyHYjb3dg
X-Gm-Gg: ASbGncuSTlWQbvXkA2HRffu/cqF+DuBwnZtSlO1DUTkkhTorsccsc/wvoj4OzjK6rgG
	BKOv9wFshuFmQwZHB8qWuD0+SoIa3yFFvyfGjEapCIjZhdB/XWKNzHvZ/Y8DkZmsWIjOOy9cGgn
	yDbjxXq7lH5WrOslMibaqdEeE3yyyfuKSfSjclRDhRcW6TX7DpH7ARYL9c7Cgb0knx0Ny2lpXkR
	H2fLTyYKIKkrVmbIcaftfAGGZc/3PMVSgLbvCd4MBZHluELqjGOzjVEuHbh2Uv5sWyYoDpL1B6L
	jc7n1H9TyocyK2tIN/KDjX47dtAVpd9SP3/kX1A/zyrzvRjm4j6cE3NbsYT2l8BIYiaiJ60EoDl
	q1wPX/H3oKTsz0RxYr/7ktrAyBxcjE858o8okfGxh2UCNfl9I6oUoLg==
X-Google-Smtp-Source: AGHT+IFBq8AJRMzTJK0klOcnC1vLPRjpjHZy9TRw7dLM8P5C4iSy9O6k75u6x794jG7F5vuo14q5NA==
X-Received: by 2002:a05:6902:300f:b0:eae:d640:42d6 with SMTP id 3f1490d57ef6-eb37fbe9b1dmr1046467276.5.1758746650314;
        Wed, 24 Sep 2025 13:44:10 -0700 (PDT)
Received: from localhost ([2a03:2880:25ff:51::])
        by smtp.gmail.com with ESMTPSA id 3f1490d57ef6-eb383929b93sm9854276.21.2025.09.24.13.44.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Sep 2025 13:44:09 -0700 (PDT)
From: Joshua Hahn <joshua.hahnjy@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	Johannes Weiner <hannes@cmpxchg.org>
Cc: Chris Mason <clm@fb.com>,
	Kiryl Shutsemau <kirill@shutemov.name>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Brendan Jackman <jackmanb@google.com>,
	David Hildenbrand <david@redhat.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Zi Yan <ziy@nvidia.com>,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH v2 0/4] mm/page_alloc: Batch callers of free_pcppages_bulk
Date: Wed, 24 Sep 2025 13:44:04 -0700
Message-ID: <20250924204409.1706524-1-joshua.hahnjy@gmail.com>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: zkdtdg7gfnepum7hibndoabstpqyn6c8
X-Rspam-User: 
X-Rspamd-Queue-Id: 7143580013
X-Rspamd-Server: rspam04
X-HE-Tag: 1758746651-573913
X-HE-Meta: U2FsdGVkX1/kqgiTIrjuoBkj/VDvOhZ9oO9K8iEoX/R2wcL7GGEuiKUab7/QGsCBfnLxKSrC9LqcK6Cw9KowGAaBIiD4xx7DpMG4+x7Ts9ZL8oJLwgI+bTfNWlRuLCc2MOpIVx6NnzEblh6W/wl+JVIhw60CYV+kCjt2NPLz51rssJvWdN8FX3Gaa5VTnJ0Ad5+0tPcFtyXQ35lX7fg7zJkwXT2aGzczo0VnasRH2H1MTE1XS3Q80RgkT/rdBzlRPBjPC/P1N4RoXvpaqWsJBR/AbqzNCN3sA1rc70c9k4UPeBT+L/jbp+q933a1srsaUI9GxARcMhSrei5UR+Omxeabna/fRdGVR9bn5YHYH8vw1l3anL+ibw2SosRh3P+oAXwzY7YQJ5QJRor97suUwIAkzLIH8h5AQzWWI/8oMnLZRcEKQrP/lZ7u2ktTU7rGuFw0/LDJAOpbkAXWN5i7akUZ0/dkKP/eK1t5Xzwz9FxyPIxZtqR+cUCFaPwJLpTnqkcWpiBv9ihK5ysbzQp3xS/34jTprpixuuSCnDgzTde/ZoAs5shyR670tZnQMbysVnwAivjl5Woqp4nNpP5ADER1j64QSiRkTNLuGQGFv1fjlFKq+jWT98xPfiI0tQC99yVtAvkcUHBihjL3KTG8SsEJEA7474CXtb70vUwSd4cZmcRPGHgO8xeMsOGKMQv4xwDmQEvMkY9Tzv97wZHku//AHhDC0hKvSIQqgMzwKxKJg4qPB+t1T7mFZNo2MfcS/Rc1n789DyxFOoyTjg6bnoKgz//XF9vv1aGBVgPm9LDS91jPAIUOVed1mv1u6w4jpT8L+DgbVaAmh6yVWNvHcQNTmQGccEvhHJGRbVS3Y+g124X4oQGDMO5vyvLSB/z7cUpn7DyyW0xS2ZZIS/SLi/KidIfT3bMooGh6FayEjlaw3TBKsy+KAzWJCWAkCzHPXX45qxTotpxq+qFEy5V
 DcSoZAPN
 YxE5u8509zyaB1/rJkzLKmn8KszKKp27//hEEYoC8Ad6e+f/ol9+AAdtO9iMpOCSnC1ZeQ/rr3YIA/mlGwd83kEyXzyJ4GC9ueqOY2sWKJM3t7XhpmA6rdDwMeGjq1pReRE+jpzGDby4TUVoheTwNQOHt2nHSrlOR+x83ZXyQ++Y01hJR3nQcPDvWyNQJyXC5WVQ5Qknrq9xI19MeAEauQVC4lwmQuYeKPwhKl2w7K4OW9WVA63NBfcZMLOG8BdXz2tMaA3i9jdUL0+mBLeqyqcf9Rc3UdR//abA4Vqivl+4X7R34AFbfvtYwq3mKmNh8/s8j6WRVyxtwaZYBS2um0CCGRpl62QbkOTUqq+XXHJx6rSZmH1NPfpZdeLg/JQuCGgzPNpqrmZ4BYN+hYBMsY8IjhHgoJO84LEXeVexpSuIdokmjHDjAsCw5r/jl1FzKfDe6G+Fo7MH18Rvbxlbkh2MvfRIiylYNIX6kBi05ZwcXmErapdpQmfIvNOvx+4DuddyG8Faw9SoLePBETMZtZog77F0KCMF9DYr6HDhELr4XO1VQPXGrjTpJFQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Motivation & Approach
=====================

While testing workloads with high sustained memory pressure on large machines
in the Meta fleet (1Tb memory, 316 CPUs), we saw an unexpectedly high number
of softlockups. Further investigation showed that the lock in
free_pcppages_bulk was being held for a long time, and was called to free
2k+ pages over 100 times just during boot.

This causes starvation in other processes for both the pcp and zone locks,
which can lead to the system stalling as multiple threads cannot make progress
without the locks. We can see these issues manifesting as warnings:

[ 4512.591979] rcu: INFO: rcu_sched self-detected stall on CPU
[ 4512.604370] rcu: 	20-....: (9312 ticks this GP) idle=a654/1/0x4000000000000000 softirq=309340/309344 fqs=5426
[ 4512.626401] rcu: 	         hardirqs   softirqs   csw/system
[ 4512.638793] rcu: 	 number:        0        145            0
[ 4512.651177] rcu: 	cputime:       30      10410          174   ==> 10558(ms)
[ 4512.666657] rcu: 	(t=21077 jiffies g=783665 q=1242213 ncpus=316)

While these warnings are benign, they do point to the underlying issue of
lock contention. To prevent starvation in both locks, batch the freeing of
pages using pcp->batch.

Because free_pcppages_bulk is called with both the pcp and zone lock,
relinquishing and reacquiring the locks are only effective when both of them
are broken together (unless the system was built with queued spinlocks).
Thus, instead of modifying free_pcppages_bulk to break both locks, batch the
freeing from its callers instead.

A similar fix has been implemented in the Meta fleet, and we have seen
significantly less softlockups.

Testing
=======
The following are a few synthetic benchmarks, made on a machine with
250G RAM, 179G swap, and 176 CPUs.

stress-ng --vm 50 --vm-bytes 5G -M -t 100
+----------------------+---------------+----------+
|        Metric        | Variation (%) | Delta(%) |
+----------------------+---------------+----------+
| bogo ops             |        0.0216 |  -0.0172 |
| bogo ops/s (real)    |        0.0223 |  -0.0163 |
| bogo ops/s (usr+sys) |        1.3433 |  +1.0769 |
+----------------------+---------------+----------+

stress-ng --vm 10 --vm-bytes 30G -M -t 100
+----------------------+---------------+----------+
|        Metric        | Variation (%) | Delta(%) |
+----------------------+---------------+----------+
| bogo ops             |        2.1736 |  +4.8535 |
| bogo ops/s (real)    |        2.2689 |  +5.1719 |
| bogo ops/s (usr+sys) |        2.1283 |  +0.6587 |
+----------------------+---------------+----------+

It seems like depending on the workload, this patch may lead to an increase
in performance, or stay neutral. I believe this has to do with how much lock
contention there is, and how many free_pcppages_bulk calls were being made
previously with high counts.

The difference between bogo ops/s (real) and (usr+sys) seems to indicate that
there is meaningful difference in the amount of time threads spend blocked
on getting either the pcp or zone lock.

Changelog
=========
v1 --> v2:
- Reworded cover letter to be more explicit about what kinds of issues
  running processes might face as a result of the existing lock starvation
- Reworded cover letter to be in sections to make it easier to read
- Fixed patch 4/4 to properly store & restore UP flags.
- Re-ran tests, updated the testing results and interpretation

Joshua Hahn (4):
  mm/page_alloc/vmstat: Simplify refresh_cpu_vm_stats change detection
  mm/page_alloc: Perform appropriate batching in drain_pages_zone
  mm/page_alloc: Batch page freeing in decay_pcp_high
  mm/page_alloc: Batch page freeing in free_frozen_page_commit

 include/linux/gfp.h |  2 +-
 mm/page_alloc.c     | 67 ++++++++++++++++++++++++++++++++-------------
 mm/vmstat.c         | 26 +++++++++---------
 3 files changed, 62 insertions(+), 33 deletions(-)


base-commit: 097a6c336d0080725c626fda118ecfec448acd0f
-- 
2.47.3


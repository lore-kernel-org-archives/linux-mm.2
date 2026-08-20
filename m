Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 84F19C5DF81
	for <linux-mm@archiver.kernel.org>; Thu, 20 Aug 2026 03:47:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 40D646B0092; Wed, 19 Aug 2026 23:47:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3E4D66B0095; Wed, 19 Aug 2026 23:47:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 321F26B0098; Wed, 19 Aug 2026 23:47:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 12F206B0092
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 23:47:22 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 7A6EB405C7
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 03:47:21 +0000 (UTC)
X-FDA: 85120262682.15.7EFA6ED
Received: from out30-118.freemail.mail.aliyun.com (out30-118.freemail.mail.aliyun.com [115.124.30.118])
	by imf30.hostedemail.com (Postfix) with ESMTP id 46B5C80004
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 03:47:17 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=mPYs5PT1;
	spf=pass (imf30.hostedemail.com: domain of xueshuai@linux.alibaba.com designates 115.124.30.118 as permitted sender) smtp.mailfrom=xueshuai@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787197639;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ak29XqEPumPmnZIsWkH5gs3FZoGglGtpR98b8ROA4Gc=;
	b=0a/fFtxTmUwgnRt8OEoajyaRsxw+4/mk8g14XwHpwfueiTwU0IMiZo7Ou5F1aMPQDFh+cl
	w4Dbfv+zQjEmJoWBZFehcEGy+dFIllVUAg0kW/gfXudLgbX6/VLugdMmvcJ2ltpf3xV8/R
	4dLXxc2Hu0L5vMyz3aSsWw90Y0hI9lQ=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=mPYs5PT1;
	spf=pass (imf30.hostedemail.com: domain of xueshuai@linux.alibaba.com designates 115.124.30.118 as permitted sender) smtp.mailfrom=xueshuai@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787197639;
	b=qKw2+CRYwNKjSO9lWKx10BSO8ECUfWDU3FAEYM3GvCyh7NGjmlOjQdhyCM7D86mtnjpclU
	z0l26sjs6rn1f4Q3cYl8Z+dZXn8QF5x5f0+Y23RCbLJ58XVwAVqIQs4af/XNx2c4QYKz7f
	TZvNd0R9TDswy+Gyv+gD7zAKbotJYB8=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1787197635; h=Message-ID:Date:MIME-Version:To:Subject:From:Content-Type;
	bh=ak29XqEPumPmnZIsWkH5gs3FZoGglGtpR98b8ROA4Gc=;
	b=mPYs5PT1l0zeHzsIvcwo0U6ABQKR/F2PcOSv0Cb9HTFNEQ0otUIZ1qFBiM08jEOTDn+zLQIkFXHxQBO9zaZHmUpfvrEbXL1ItUR/W/xz5TF1hbrTSRnj7yKXr2gK9pOmV/P1WftP9azTrbXwidZnyzlawHTzngE7bqQafWw64UU=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R731e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam011083073210;MF=xueshuai@linux.alibaba.com;NM=1;PH=DS;RN=31;SR=0;TI=SMTPD_---0X9IIIZZ_1787197632;
Received: from 30.246.161.92(mailfrom:xueshuai@linux.alibaba.com fp:SMTPD_---0X9IIIZZ_1787197632 cluster:ay36)
          by smtp.aliyun-inc.com;
          Thu, 20 Aug 2026 11:47:13 +0800
Message-ID: <0d2fc2ab-333e-42a1-88a1-6bb85538cbb0@linux.alibaba.com>
Date: Thu, 20 Aug 2026 11:47:11 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
To: kyle.meyer@hpe.com
Cc: Liam.Howlett@oracle.com, akpm@linux-foundation.org, bp@alien8.de,
 corbet@lwn.net, david@redhat.com, hannes@cmpxchg.org, jack@suse.cz,
 jane.chu@oracle.com, jiaqiyan@google.com, joel.granados@kernel.org,
 laoar.shao@gmail.com, linmiaohe@huawei.com, linux-acpi@vger.kernel.org,
 linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-kselftest@vger.kernel.org, linux-mm@kvack.org,
 lorenzo.stoakes@oracle.com, mclapinski@google.com, mhocko@suse.com,
 nao.horiguchi@gmail.com, osalvador@suse.de, rafael.j.wysocki@intel.com,
 rppt@kernel.org, russ.anderson@hpe.com, shawn.fan@intel.com,
 shuah@kernel.org, surenb@google.com, tony.luck@intel.com, vbabka@suse.cz
References: <aMiu_Uku6Y5ZbuhM@hpe.com>
Subject: Re: [PATCH v2] mm/memory-failure: Support disabling soft offline for
 HugeTLB pages
From: Shuai Xue <xueshuai@linux.alibaba.com>
In-Reply-To: <aMiu_Uku6Y5ZbuhM@hpe.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: fzahg5dgj811csh86fbp745q4rgzpmy9
X-Rspamd-Queue-Id: 46B5C80004
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1787197637-876072
X-HE-Meta: U2FsdGVkX195q4ZvRjQGFKft4UIkpVxi1hBN/0P3jdgPM1l0aeSYAhwPHN3Rsq7H+ROHZouY33rxWYPJ94vGYVQlAOSIFvWF66N0bkis3lj5eGnP5X5IMPzhBxnd5K1fmt9iBTql2tGFFJdrgXWG29dlDt4JNsELSJNv+L4+aVqms0ccQWGsnsGVX6T+FyBa+tHX3RNuT3/6ff6Yn0qMMXsDtMfEYV4rDgnw8DKuMABosVXz9gC9ioemSZbiX/0HKa9TbXAhWxgmJlfXHhgtbH9Cs14GbxKmO06R6ZfQvxZIAY2W5by2+4ZUVzjx7oNC4i8KnU7jMcXY3S3ZoJTelkZNZs0kAxzdIRrZQfpaIDY1huzUjml6NdSw6T3nXh3Qi7vlSpHMQrwyRbtaJZJ0tbf2dOUKg+rxqAF8qTNdxrpC/nEMGESiG/2XP3cQV5sdCu3RhmylNF//00TDbAruJP17NTrNqOZ5zdzqsPg0Gelb+jHLkRfXyIqlNA145fS8wYLJ7Wn6/FEIdKu+TrsxDkXdeewTb2fPh+lsEOGWApYl8m5n8Sj/WrMtYdN+e+xDZiMFcAm2N2co33yPjbLtA5nN60f0y+B2U66FoO8Yk40l1TiPivsSnRq2bE/6rjZyOhhn7qA1CLHzEO+5/778JgTW94NJqqD+6RDxxMOQfryY0FNkP2Qtjy1QNA3hrO91SiOTTZ67FIKM19eyU/vyG9sqzR+fYZCg3xsIh3Lf67SJHDMQ6lsz2E5/tea7XfibGuJuiVGbyK34pave1gSvNiTr0CbvR0Wod9r4z6ZCMx3kfW7qV0h/2xxtkstvJ5mSRPxCYtT1Rb1laPY4U3v+4WGyvK/vvtccFWb0DtJOzoGndKUccBWqEBu2D2ZbRVFHnQ7I0M73DgjBDcPZtI6iKoVuctu/cDWQK4j6aHodkyqppZNVqpzL56UpvNlZUTGzU8H36blkVVRQlbKo7Ko
 Fzu2O95w
 uvHPTdKCVWA5/+qzdb/31LkxX3GqJAyIgxEiLkDkoz1qx5dYKDoK87PMqp592sST1O46AgnifS97q+jF0/cZZq2rEic069tJ5C7DyYx6TWkX0n+OqWmjxeCaZSx54BmNVrHpzL4Wh3nX0RfdfXwHS6jwgsZwZqx7fs++SEMZgIkhrefVLKKgpSkTy8MdYb8hukfS6iGhFhYzlS9u1XH/IayJG9D3muOXX737EhqMw0rXL78Pvqre2LxfjG9/ktEwv9HWttZDunY0Ebj7bbLrgurPYyiEZqwfoi9BT8W1hCy9XAKXoOA12KAaqbjdJrcGgoPxmp8jEqBKnb99YWBJ6HTFmn8rk93Clwg/T2IRYJnkD6FW7ebi1ijtReBsNqda8IJNjFlfJGxGCBtM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Kyle,

Following up on this thread. The v2 patch once landed in akpm's mm
tree (9ae6eefa4b6b "mm/memory-failure: support disabling soft
offline for HugeTLB pages"), but that commit is now not reachable
from any branch, and mainline as of v7.3-rc1 still only has the 0/1
switch in /proc/sys/vm/enable_soft_offline.

The underlying issue discussed here is still unresolved for us:
firmware reporting per-rank corrected error thresholds via GHES
triggers soft offline of huge pages, which neither addresses the
failing rank nor is acceptable for workloads that rely on stable
hugetlb physical layouts.

Do you still plan to send a v3, e.g. with the disable-bitmask
layout Anshuman suggested upthread?

Thanks.
Shuai


Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 59E9EC43458
	for <linux-mm@archiver.kernel.org>; Sun,  5 Jul 2026 00:50:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5D9666B00A2; Sat,  4 Jul 2026 20:49:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 58B1B6B00A4; Sat,  4 Jul 2026 20:49:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 479DD6B00A5; Sat,  4 Jul 2026 20:49:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 0EE416B00A2
	for <linux-mm@kvack.org>; Sat,  4 Jul 2026 20:49:59 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 68E5940618
	for <linux-mm@kvack.org>; Sun,  5 Jul 2026 00:49:58 +0000 (UTC)
X-FDA: 84952890876.02.8A3689E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf18.hostedemail.com (Postfix) with ESMTP id 184911C0007
	for <linux-mm@kvack.org>; Sun,  5 Jul 2026 00:49:55 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=TM9584Co;
	dmarc=none;
	spf=pass (imf18.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783212596;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZjSm4Fd+lNDKkVoVoHGYedDWV9KOmG3MTrqi+j5epJw=;
	b=ynxqM1L2lFGRkfsmDLbbsRNQ3AMj+KPN+0j2NfwH/oG0SVFnTiDk4XzmPN1s9cWD4v+vMD
	9RSd4PUru98RZKlYz/HJdspiQxITEErlr5zg200kO4472Zk0pIG+4g9vpIgvSwQ2FYia5S
	zrfVcnokaKqLlvfc6t8X/pfQoOoAu54=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=TM9584Co;
	dmarc=none;
	spf=pass (imf18.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783212596;
	b=hiV2tkap7mJ44KZ0ibPAsXq6eUJakivIaV6gM5npcsxYwmwVHhQFIagLbMWHPPfMPkZDUe
	r59NO58P6gFhTywiHVoG+q5R3wyAwE1m7JLxkf1FT36236q91Caku5VOYHxE+o73tUoguu
	kYbb+AiShubmbiJe6TsAhuOwI04vO6g=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id CE7B840E47;
	Sun,  5 Jul 2026 00:49:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 682DF1F000E9;
	Sun,  5 Jul 2026 00:49:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1783212594;
	bh=ZjSm4Fd+lNDKkVoVoHGYedDWV9KOmG3MTrqi+j5epJw=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=TM9584CoCVWiMFvcZyNQtjeivX2GDfDb6VcM7ie7sC1bRM16H4Aw3UyuMWq/Mi5aZ
	 TvQIv1DaQXfV2Rzjrp6lHg5XVhv0UZf0WPxCpCvlwgxc53NBkeTeYUkWacRCo6tOtz
	 iLz5AHcrgPwfhiKGztT9+tOBaD04R/bmyM5g7nRA=
Date: Sat, 4 Jul 2026 17:49:53 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Sourav Panda <souravpanda@google.com>
Cc: muchun.song@linux.dev, osalvador@suse.de, david@kernel.org,
 surenb@google.com, fvdl@google.com, gthelen@google.com, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] mm/hugetlb: Fix null nodemask in
 alloc_fresh_hugetlb_folio
Message-Id: <20260704174953.002ee4990c62cec6bbfe4391@linux-foundation.org>
In-Reply-To: <20260704174930.2885785-1-souravpanda@google.com>
References: <20260704174930.2885785-1-souravpanda@google.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 4ctt6ncei69h4ajquqsbp3rxk5drhp9a
X-Rspamd-Queue-Id: 184911C0007
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-HE-Tag: 1783212595-14400
X-HE-Meta: U2FsdGVkX19ESl+keJ70EHNUZViQxnJXzDP6VL+Zoltc7eoUNW8csbtgiA2cAqgUw+s7WPj/AlL66U7cJHIYoJ+aobrY7zip+t1Npr4j4Z3VcNEiThY0mLwUnp7OLmRxlTHZBcgjEwN7LgV5U2jLlpt6zacFvl5/xuQIyyWhP2xHGu0tgzqivB29XuRqXCCh3ELf4EgXwuNDxZ5P/tijw3g3t5J3OOX387oTF28gs9q3Nf7AD96ASylrfTgIk9ey08FxxiV9wjaxRfcQdkSnIKl1G/q03IOS3A8fFbK2mWvk0vPa7LFoXY37oun4pPyoB6ccEx3FGA86ftBWq0UhLJUWp8i/HeEA6j8up+QwCAEt1V/dnp9lBjVgaXKW2olXTnbjnNzPTkUg3LXd3BHcpBeX7JFnuuHytX+librglxN3TrXCVWXaYgYoexAZ8XeqjA1LyCyFT39vs0svJizJAXXGNbonlFqBA0TBXdz4bNuosqyJmvPuzoSfftJfcgiEcVxQdSZ5CbGgxAVft4e6fWFNGQXUSmsmKBbfHkxxiyuQFxC2g3k6sj7eaK5HRyxZIR7jTXpCYm/BAwuFmq6XuD96xWc8YuZCPyYZDtC00/qbwvZ0XNn6GyQLh1GcnWQtRq4XP9vUZgqLUxnE2OHwOPNsH38TpsfR/sTng/QpHt6aUdYG/h/+8ItVWyUQZ35alOQF+NYpNyWLzR7KpsngA3zc9gq8NSdVGXHQog4gVVaNy8oufL0AvuzCmOu4BINMWognLU0zREMHVZ2cSiJpDtFeHrpYr4vS7qNEZzUT8IKhnpzC/oCSul1Mi1qgzlPhtGuQX27fLBgqh4No6cDQTLRQ5WcAnx4uE3rqVdBJ97m87axO+JwSblSCTXJNX6X8Mv/1/znxfYqAF2Zo1ea7FGRsIo9S7L+TJpV4voxHyVpAeyRKUnlFJAxZVwQ/w7I8MhP9Z/KJh6FlXZ+Ord8
 bH95mkKh
 S19c80ZIKDvjUH+BXFnZjvNqcxUf9QkwVeKFyjKOldnEXKaj75RXob2elATHiOmbQz/yfrt9/H86e2OByBbcta7FWk4FWuV7FvAsgNSkpg6ewmHfB4MUlzY/zxdSKBhilTbu45DUIR0fvpf9zDBpn6uFiAguLY8dAvA8IMUxHBJ4jaZOq6V3upDF7+Mqh45DHHjJ/XoKL4O2vb+nbslPEumawN40fLwNYxa27chQXmpJZqPza5TpYB1cibhOuGpMU5ol5i0wynecDsvaxz/czv+xkjIE5GIm3KttwU2SFgYGAMRN//sjiEIbH0toVHk4G7Up3jfUUAiTDHyFTNI4NyMRnLdrDBGeSrMX7zGVhkF4NMegy+28XmjrOqlPYtzvhWQKR
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat,  4 Jul 2026 17:49:30 +0000 Sourav Panda <souravpanda@google.com> wrote:

> alloc_buddy_hugetlb_folio_with_mpol() can pass a NULL nodemask to
> alloc_fresh_hugetlb_folio() as a fallback to allocate from all
> nodes. If order is gigantic, alloc_fresh_hugetlb_folio() propagates
> the NULL nodemask down to hugetlb_cma_alloc_frozen_folio() which blindly
> dereferences it in for_each_node_mask(), leading to a null pointer
> dereference.
> 
> Similarly, if the CMA allocation fails, the fallback
> alloc_contig_frozen_pages() is also called with a NULL nodemask,
> which may cause issues.
> 
> Fix this by explicitly checking if nodemask is NULL in
> alloc_fresh_hugetlb_folio() and defaulting to
> cpuset_current_mems_allowed. This ensures that both the CMA and
> contiguous allocators receive a valid nodemask.
> 
> Additionally, this patch adds a missing node_isset(nid, *nodemask) check
> in hugetlb_cma_alloc_frozen_folio() to ensure the initial node allocation
> attempt respects the memory policy.

Thanks, bu the changelog still doesn't explain the userspace visible
effects of the bug :(  Important when proposing a cc:stable bugfix.

So can you please condense and include the info you sent in reply to
my v1 question?


Also, Sashiko is saying stuff, as usual:
	https://sashiko.dev/#/patchset/20260704174930.2885785-1-souravpanda@google.com


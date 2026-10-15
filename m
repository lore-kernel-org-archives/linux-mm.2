Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7CFE4CC6B2D
	for <linux-mm@archiver.kernel.org>; Thu, 15 Oct 2026 00:13:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 82A156B0088; Wed, 14 Oct 2026 20:13:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7DB466B008A; Wed, 14 Oct 2026 20:13:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6F0FE6B008C; Wed, 14 Oct 2026 20:13:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 54DB06B0088
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 20:13:39 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id B35DD14080B
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 00:13:38 +0000 (UTC)
X-FDA: 85322936916.02.7BA8EB5
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf23.hostedemail.com (Postfix) with ESMTP id 03132140009
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 00:13:36 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=fQM8FvOL;
	spf=pass (imf23.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792023217;
	b=WchlYzJYmACl5rEgXrUR3dlEo78Y4CNLzsOEPfYZNEAM41ov6Oj8YQzIUuK5xuzOy5E6+d
	42st4xfgE3l2bUUUhxGE48CgA73nlTxk8VdXrPzlZhBS4X9/yLgi/GWL5y1LC6UP6NGcb9
	sZE1MrIkf04dnfZ8riF+7/rt0CSenqo=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=fQM8FvOL;
	spf=pass (imf23.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792023217;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wloXvAw4VLAs7Q2MzPshv8uNxbkgW8DhbrN4DcpdVGg=;
	b=8ZdbLmmqNqz/qc/IyYxl7BmDV/cuE5WuGd9ssGU2yWoSyEfB2frv+1GgYQv/jxn2AgNRYF
	/Kztdravy658lhb0NA/zllJR876xjEkRyypntrrcAFAEHIWx2Ej774KIFUUet4l2WQ5Tnn
	KrtQPHdmGOO/h91MIJhp76Ws/QM4hUo=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 72BFA43686;
	Thu, 15 Oct 2026 00:13:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5B971F000C4;
	Thu, 15 Oct 2026 00:13:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792023215;
	bh=wloXvAw4VLAs7Q2MzPshv8uNxbkgW8DhbrN4DcpdVGg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fQM8FvOLFG1dIYNAsW0fEjziwwvtHWa2uipltWDUoCBm4L9GKBpsYHP3ML1ucEzhp
	 zlls+B6KLSbHrhdACFczFew6ior6vJLcsombpG6p6MYKCXhdHQhhYnbvI/WS2glGGf
	 S8hir23xG470a2b6oq5w1YjePnu93o6t/Ty8lIPI5MksEJb0cE92vSa+sh04+dUMsJ
	 KWbIWfyFS3tpcIF8VkE5GAaHrE/krzJ7A4gi6PmTHgojuM8g8W8L1jyixTh2pKUMQr
	 gz1In7naCXHfATkXzgcFIOqSbulX0XqrGFRRKwGrd5zzTz9i3fLE3QbT9f61E7dwkg
	 qYf+SYo3ESrGg==
From: SJ Park <sj@kernel.org>
To: Pedro Falcato <pfalcato@suse.de>
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	David Hildenbrand <david@kernel.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Jann Horn <jannh@google.com>,
	Minchan Kim <minchan@kernel.org>,
	Michal Hocko <mhocko@suse.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	linux-mm@kvack.org,
	stable@vger.kernel.org,
	Samarth Narang <samarth.colleges@gmail.com>
Subject: Re: [PATCH] mm/madvise: atomically clear the young bit on THP MADV_COLD
Date: Wed, 14 Oct 2026 17:13:27 -0700
Message-ID: <20261015001327.4037-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261013191719.95502-1-pfalcato@suse.de>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: huikmwzqb88xgyj4gie4dp14mmgon1rz
X-Rspamd-Queue-Id: 03132140009
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1792023216-67570
X-HE-Meta: U2FsdGVkX19v5eK0XXfHeGwhxkUWvcP5AYIX06dFbkDIfV/yyfrw5xQF8OnWRBVmr12Mdr3Ie/dn8KvoXVPzn3uhi/xl1mqm2Sb5lj1Mnq1R82jXWFtvBy4NRBmoF5OcEoBSocDqS0wJ1hkc1M3i8OQT5CvYBRmdux6D5nhsT8Ij5dOLvDZTx/BwbxrelkjfrlYJLvJeGcvy9gp8XaIXMfEEzDHTFHhqv/neYJcXeEIJY5COqrwAaSehDoC27YMmxVll30ubHQlcuGZ8L2CONxHiAWNEVDiGXDJUtTFIlhaz90tUWRs6KXixmGxyQA3pcIsH5Yc3ixHuf8aawKcUPN02OIijOG+JsKzM2ZE5J5YiT3Bvg+vqB2wSDyommuhYmq51Jmp1VaK6tLJys11wbxu2GYJGURTg9bmWtZHsjZNpu2U5U5eYTLccxor2TI4JeSOMMhDs09T8xM+Bj5hj56HINwqRk3fhFgF0d1ZchmP74PvbBhITTAfeE+kx7V1WUqJfaHHpZ/tegjo6HG822yQvZCXjLDL0RI2MyWDlW+BYda95BVQ6d5xklrGjmlpL5vc4ArEftJIgtc97B3jUIcTCr+wrp6IIBm9GSpT0YQOxBwcQJdRhIUCUn9q33RvtHFojBS0bfWIWgfGXc+kk5KE3suB/6LkUSXcnAmKBozM68RvPZpBoarjrK1K09PUKJLJiMXdUQgl44TtsyIGzcuGHQLBbXliN9XSo6TllurXhRoKX7X6yOUMGOY6ZuaUFXYGLpZzC+R4/F7UO5lCSSK0HtxBhYeTe7T0EpRTrN4Lwc06l4ZrdzA9muld1ZXcFQkdI025EVmR92fAnPTmWauFkJ0YFe2+IPDxeSsf5jwel05FdNpLddCF8adVzOB6H27fYd7/QCx5DRBteEIJfHyV8V0VcJfXvI9Qr2fTqdTuSE/cjXRejMU7kIl5C/4o138wuxS5JRVmac8fMd6H
 C1ZThv8f
 nODc7HU3r8yIm4t/TZI9GYJhnxvZ3cEMo4wzofdShsGkjKhfNUWv/e/1Em8lKjYxw3sZlnaHwAD47DUtMxon+eNI8gSjg0D/Gp3JoM5NfqlgCTO48HOGIyB2FvMItperEEZ1L/5xo1CWLN8w/YvbqZFsFJPVmvqQjZvET8OHvO3uRJoYM+oQxgCnm0lOyG6n2Iy3KS74btnGi8Iz47x//JI7PZLRCdIKZWhpp5BWB5ispqZT7FnsaJ2nkm/lZJdOTJjun4e2sDMAmcazb/5sGziUsYMLbyjnyxHYxHwU1pM7YtEo220aLkoUXzfaOheAtdaz+ynVgGPEXVkCXNOZ8l7mU7W0AJDx0Ri3HgWQUDlbzo2gmh7heKgGmzc4kBZkajz29
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 13 Oct 2026 20:17:19 +0100 Pedro Falcato <pfalcato@suse.de> wrote:

> As-is, madvise_cold_or_pageout_pte_range() discards the hardware young
> bit by invalidating the PMD, doing pmd_mkold() and subsequently writing
> to the pmd again. However, it does so in a racy manner, looking at a
> possibly-stale snapshot. It's entirely possible that a write elsewhere
> set the hardware D bit, which this logic now loses.
> 
> Fix it by using pmdp_test_and_clear_young(). This is an atomic
> modification of the PMD entry, and thus safe against any possible racing
> writes. As a (nice) side-effect, this elides one non-required TLB flush
> in pmdp_invalidate().
> 
> This bug can interact with the swapping system in complicated ways, leading
> to data loss. For instance, if a folio is marked lazyfree, but was later
> read from, and then MADV_COLD'd while racing a write to that same THP,
> dropping the dirty bit may lead to data loss as reclaim/MADV_PAGEOUT drops
> the "clean" anon folio:

Thank you for nice description.  Makes sense to me.

[...]
> 
> Fixes: 9c276cc65a58 ("mm: introduce MADV_COLD")
> Cc: stable@vger.kernel.org
> Reported-by: Samarth Narang <samarth.colleges@gmail.com>
> Closes: https://lore.kernel.org/linux-mm/20261011132227.413217-1-samarth.colleges@gmail.com/
> Signed-off-by: Pedro Falcato <pfalcato@suse.de>

Reviewed-by: SJ Park <sj@kernel.org>


Thanks,
SJ

[...]


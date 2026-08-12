Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D20FDC5B56A
	for <linux-mm@archiver.kernel.org>; Wed, 12 Aug 2026 09:36:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C89276B00BF; Wed, 12 Aug 2026 05:36:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C604D6B00C4; Wed, 12 Aug 2026 05:36:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B76E76B00C5; Wed, 12 Aug 2026 05:36:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 953326B00BF
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 05:36:28 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 258B4C017A
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 09:36:28 +0000 (UTC)
X-FDA: 85092112056.04.EA5A8FD
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf24.hostedemail.com (Postfix) with ESMTP id DC4F1180008
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 09:36:25 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=m8GGtF6X;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=utSR7Dso;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=jUmOWDIi;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b="/3PMGy8Y";
	spf=pass (imf24.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786527386;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5m2rqBH/Ah6lf7nFwFeHrsDpb9GfTC3w+B+47Xs24Nw=;
	b=auVqVYQ00EAKJn0crAllHZLmsIN6gg9C0EitVFv4o5wHHIyVmGp5xBlMH8gw148BcGG61P
	Hfni1PaxL4QQKv8PS7eWkCK6jjY4oijdkAwdueaBpYObMsQ+80Qig5kg+AF4OzoKuPL6X6
	N7OKl4A3Qv/EewFW4MT3lnubFDmaI7U=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786527386;
	b=PdJ9mF89WAgOE5kliEwtqYv9neM8quSC0TS2VmBDykKUAqXCLSm7ulQKd9uP6XQjsvIis5
	reH83SsK0TdiK1sPZUMWM1I9I7+bKmClnQWqEDvLS9yr3Af+FMlXlj66nPUOgWBDjrXxOF
	U3Eoeim4g7VifO9OaueaJnZAnP0gj9A=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=m8GGtF6X;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=utSR7Dso;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=jUmOWDIi;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b="/3PMGy8Y";
	spf=pass (imf24.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 42BB23E50;
	Wed, 12 Aug 2026 09:36:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1786527380; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=5m2rqBH/Ah6lf7nFwFeHrsDpb9GfTC3w+B+47Xs24Nw=;
	b=m8GGtF6XklCvzBprTznmHbacWiZP2M8520eAyRLAra+O6UpOb/hGvTLAo8D4PzNMzuHeZM
	ZupAC899WLlpXMBC7oCzTloC9YfQHzsvG0CFIqjCYaQRrG5ymqiu/uIj0gE6kWEa/hvkVP
	jaGASGxGVxtppPFIbWZVEPRNfhbLVyY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1786527380;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=5m2rqBH/Ah6lf7nFwFeHrsDpb9GfTC3w+B+47Xs24Nw=;
	b=utSR7Dso4bX2slVZ6GLc3cHrjeStHUNJhvAzhQm9kzFxDsluOSqmkqfqDhNwg74BNxy0XX
	wFLUEY/FhncMV3BA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1786527376; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=5m2rqBH/Ah6lf7nFwFeHrsDpb9GfTC3w+B+47Xs24Nw=;
	b=jUmOWDIiuVoLHMp2/59xweK6NIjfOdOE5CkF8lle+dvBw1DC5tVPYxMM+7aU4IbPHYnu68
	oOExW2xww4/VFGVfLFXgIWjF9zvZHyAkeUPI9wJGijZ3KaO3M3bg8kXndCAFNQNg1/EUeX
	ReywErtAit4icugdSkdCEIYWWXo4AFE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1786527376;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=5m2rqBH/Ah6lf7nFwFeHrsDpb9GfTC3w+B+47Xs24Nw=;
	b=/3PMGy8YSbdr0qkHdLxH/WULoIYRpGa8WE3E0ykdHEwtbfxTWfCLiQ1oCGCNVuLg6pvONg
	AB8QnkOt61BUKaCA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id E3E74779B1;
	Wed, 12 Aug 2026 09:36:14 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id WWtUNI4+fGoKAwAAD6G6ig
	(envelope-from <pfalcato@suse.de>); Wed, 12 Aug 2026 09:36:14 +0000
Date: Wed, 12 Aug 2026 10:36:13 +0100
From: Pedro Falcato <pfalcato@suse.de>
To: "Nico Pache (Red Hat)" <nico.pache@linux.dev>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-doc@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, Zi Yan <ziy@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, "Liam R. Howlett" <liam@infradead.org>, 
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>, 
	Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Jonathan Corbet <corbet@lwn.net>, 
	Shuah Khan <skhan@linuxfoundation.org>
Subject: Re: [PATCH v4 3/7] mm/khugepaged: introduce a count_collapse_event()
 helper
Message-ID: <anw80fOYcFcLsGV_@pedro-suse>
References: <20260811-khugepaged_pte_refactor-v4-0-ddac39d61c4a@linux.dev>
 <20260811-khugepaged_pte_refactor-v4-3-ddac39d61c4a@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260811-khugepaged_pte_refactor-v4-3-ddac39d61c4a@linux.dev>
X-Rspamd-Action: no action
X-Rspam-User: 
X-Stat-Signature: fhaaoymbmkac75s5xy711he9em4fj8uu
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: DC4F1180008
X-HE-Tag: 1786527385-653794
X-HE-Meta: U2FsdGVkX1/XoQMBhEnpZ+vtYIbkIvA5yzVcOvjseM2d7E082ldWdz5/H/M99xsx7ZAlzg3vQV0pw5VHyuiLZoeiRtFb6WWMSfuIH3DGvY+MIRfL59wRO64VSawh18xcltOHo+mMYMA7KXGzP3As5Ew9/XTWElXRoxe/LXVOoPSiL/zW+zC1SraI33kmI6dfl0GykX2mUzUCPxeBTNcmWU7+SSJoUgxz37WiKJf4kL1jEWPXzJVx0/UhQdwd+GHg/OIOF3U6o9Qmz/j84MiVGb4O/iBYS0qkaYteBLZ+X1CZxQt8/wqJKbAgEWlmfoiqcP+G0A1hyRpsy9U+pNihcP7mJY8qwEN8Tt9mtZRpZjOYVvkqD+t2VD6Z9JB3yk7pSApUJ+irUGvN4v0itosK1jnoe0tRnk1231OyFayANC7oR8WR7m6VtMm8FgOPT0gp4J6hjdaZUdTzcsyuYR16qCrVt79QifIp4IxRcSYYDDQYvgRbTLs6RV2L1xHQnAhjteIYM05Wg2iKCdbkvYa4xyT2RkojvygIVCAmsYy6yLLmH9DM2WtuSOMaUZGRn7d4KIk6KZMPkLPVVEM6Xvv8pViushSqoQpkS7sObWdtXOCWqlfh65fkg+JLvYpsZvEA17G8ZdjwB4s/xAaIQD5yg90TE5CtSkjo+BjnaMvl/AVId+JgiA9SSMQhLhOuJufOlFYn1G5phEoiQxP0FiCYiHIHNBn/QiGpIWhTe4sXbQaQQVf+KxTy5Cb7aKO60jmRspZ/ArzjzpFmaEf/Ui1/y1UrLdyn01SbXYzc40gbvLvhpMwqh+oUlCms6CkeD3lq/nogwgDjfm6YPTgmSXs7chOiatzNfPl1Rr0Lu4VL2OtY6jo+0WlsK50akrvn2fW9bN9ry3UrCu3nDFQOFGvOCWeT5TF7+6Kqj46XXvULehah9AAxU1zb+TBpvs+2INpEMNnKjpliIgNluOkoMvK
 kv+iEp8t
 T2HEQ7Km5/GRbt4MFZP8GP18V08FEwV3zxK7Z7SjiogsetpDP2F6t9RNnTW1Nr+ShrAqA6qv9GgqOSMzinsQprEUgk4+GuuNflLrq9bkBiLiyqNtWrn6U+ntdlS5JJpiOTjTTU8OKhwo264ba6eeHViQlqgMRc0kY4DcXv5kXCOXoZd7kHE4ddWISKMzl5Trkr2HzldYJbAltzufbI8GH+lub4kyrz3/oRfdeAW2HfLt5F+wTM5MhRoh/1onwY1zP/ZFnV1s1nd2FhuajW/uJVT6C3CPV5ynRwjmd5zUuEIrP5B1+Qtz0wDhLAPvdLl12h6CyT/KICtaN7AXifN9WcUJO8WHzF/Q3eqsxs0HTrQSR7QNjeRpC8gYKDdUWHFk+2aHZJ51RO58OoREK1kY4YTEcDw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Aug 11, 2026 at 06:48:35AM -0600, Nico Pache (Red Hat) wrote:
> Provide a simple helper function to help reduce a often used, and
> duplicate pattern across the khugepaged code.
> 
> When collapsing to a PMD we need to record a vm_event and the mTHP_stat
> event. When doing mTHP collapse we only update the mTHP stat.
> 
> Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
> Acked-by: David Hildenbrand (Arm) <david@kernel.org>
> Acked-by: Usama Arif <usama.arif@linux.dev>
> Signed-off-by: Nico Pache (Red Hat) <nico.pache@linux.dev>
> ---
>  mm/khugepaged.c | 42 +++++++++++++++++++++---------------------
>  1 file changed, 21 insertions(+), 21 deletions(-)
> 
> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> index 8babd4c97db6..cae510aa2914 100644
> --- a/mm/khugepaged.c
> +++ b/mm/khugepaged.c
> @@ -688,6 +688,14 @@ static inline bool folio_pte_referenced(struct folio *folio,
>  	return pte_young(pteval) || mmu_notifier_test_young(vma->vm_mm, addr);
>  }
>  
> +static void count_collapse_event(unsigned int order, enum vm_event_item vm_event,
> +		enum mthp_stat_item mthp_event)
> +{
> +	if (is_pmd_order(order))
> +		count_vm_event(vm_event);
> +	count_mthp_stat(order, mthp_event);

Maintaining two counters for the same thing is Peak Tech Debt. Would it be
somehow possible to redirect /proc/vmstat to PMD_ORDER mTHP stats?

> +}
> +
>  static enum scan_result __collapse_huge_page_isolate(struct vm_area_struct *vma,
>  		unsigned long start_addr, pte_t *pte, struct collapse_control *cc,
>  		unsigned int order, struct list_head *compound_pagelist)
> @@ -708,9 +716,8 @@ static enum scan_result __collapse_huge_page_isolate(struct vm_area_struct *vma,
>  		if (pte_none_or_zero(pteval)) {
>  			if (++none_or_zero > max_ptes_none) {
>  				result = SCAN_EXCEED_NONE_PTE;
> -				if (is_pmd_order(order))
> -					count_vm_event(THP_SCAN_EXCEED_NONE_PTE);
> -				count_mthp_stat(order, MTHP_STAT_COLLAPSE_EXCEED_NONE);
> +				count_collapse_event(order, THP_SCAN_EXCEED_NONE_PTE,
> +						     MTHP_STAT_COLLAPSE_EXCEED_NONE);

This is nicer than open coding the add, though. One step at a time :)

Reviewed-by: Pedro Falcato <pfalcato@suse.de>

-- 
Pedro


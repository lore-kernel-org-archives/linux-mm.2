Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 48E52CD8CB2
	for <linux-mm@archiver.kernel.org>; Thu, 11 Jun 2026 06:06:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 604F26B008C; Thu, 11 Jun 2026 02:06:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5DBD26B0092; Thu, 11 Jun 2026 02:06:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5190C6B0093; Thu, 11 Jun 2026 02:06:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 414646B008C
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 02:06:52 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id BC732C1D5C
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 06:06:51 +0000 (UTC)
X-FDA: 84866598222.25.06148F0
Received: from out-173.mta1.migadu.com (out-173.mta1.migadu.com [95.215.58.173])
	by imf30.hostedemail.com (Postfix) with ESMTP id 9403580003
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 06:06:49 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ftEQ4RdY;
	spf=pass (imf30.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.173 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781158010;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VY6cPLdBFMgAfHoRWeR+QE2M/b9diN2t5Veaeaq+jOM=;
	b=PN4JkLeP39OJCn4KFFWNBaYeOl6plevZAgZgYbTZ6MaljDR9s3es0DWi/gMFRGTxGRFNpK
	kFIjwNrfDzMF2TM2GsviViWBASjSdG9UnIoT8JRy6pO06COOaVv681J5AiZAps/cbaPlJG
	nQCJhKfJCa+89/GC5kJ92Rt/7EoG6HE=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ftEQ4RdY;
	spf=pass (imf30.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.173 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781158010;
	b=FpDCS5llHgvX3lyQxdj2Qw7Yw//CNUo/2zZWWnvtliXZrRsQkknVcQexZfv/W8WEtZvM7V
	CHaIrGULKVLLMkm2Z9GIrKNmZmW/BGvstBf+V3CQDj9dmLMlNXSkEnXzCdmbt4yarrJkNU
	SbR2aBxkFUKhyf+3s1RMwuOSZthxz9o=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1781158007;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=VY6cPLdBFMgAfHoRWeR+QE2M/b9diN2t5Veaeaq+jOM=;
	b=ftEQ4RdY3JzZb61UAxo9N15nCfYeH1ESPtYqnyAjeynqSBo43LkPMTTqO9JcKjiEFqHWVF
	S69PLmCZYqmxG/x0wEF7QkOO2QdjEdRsGD0fs8us2gXWZ7jVGOYvplIaqm9zA46Hyvejsb
	buz1f6cyS40AP9fHbkhYLyXLvaPrPKA=
From: Lance Yang <lance.yang@linux.dev>
To: baolin.wang@linux.alibaba.com
Cc: akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org,
	hughd@google.com,
	willy@infradead.org,
	ziy@nvidia.com,
	liam@infradead.org,
	npache@redhat.com,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	baohua@kernel.org,
	lance.yang@linux.dev,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH v2 04/11] mm: khugepaged: add shmem mTHP collapse support
Date: Thu, 11 Jun 2026 14:06:19 +0800
Message-Id: <20260611060619.94738-1-lance.yang@linux.dev>
In-Reply-To: <3895c09794739bbfae99d9e021ffacf8a51fb8e2.1781083630.git.baolin.wang@linux.alibaba.com>
References: <3895c09794739bbfae99d9e021ffacf8a51fb8e2.1781083630.git.baolin.wang@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 9403580003
X-Stat-Signature: r1ttnm9w157q5mm77s7em3amq56tcqtd
X-Rspam-User: 
X-HE-Tag: 1781158009-778028
X-HE-Meta: U2FsdGVkX1/0xWaXvDmKQmUZU5WH30xQo9pK8SC942p39CZsaL5JbcwKxEnJ/TQ2Alz12oXT4A3unN9XVlvn00J7tcnEwor0QQpq5CL7UgZW/fXFSu+gaVFhE/mzI13kc9iugZAWPBrwwac3bBgVlt17NZeZAsJysrlfIeb3hKiFI6ICiqaIaWltoh2GhKrX5IMik9peeIi/y2da3MwjkZ7LdTQxMl/ya2ro9SzYw4DK0sybbmC4N490C2M7drL3o4Unmh+cA0GDjYaI2E7hVGKiJuE7aSro3ng+iy/fxfl2sT6Bc5XpEYXCuILkzIKeICI2Uex3SN15FSJc+MUOawtcDx+oZP8kRROuRXCdP7QEeXVEHDODbJq10KfoPoZQlPcd91QKNRxb/+6kpwQaVgxkYYfghTFXzlgidootwkO3fuOYhZb/AJIW1Nn7yCnl/9Y3RcvMdDTbB1zY64loL9GXRK7/SaCcuI4p7CWpBEZ/+6R9F1tWDNbKUZaaU+3PTim8rtBruGyPbkaZORdplv0FX/1Byj3vjWz/2I/aLUrI0q2Tl7kTbHaF9I89/ekwvQ948EaXjAoEdDzbXvSNhGZb8ucOZh5NBhr5sBDsDaSrmyNQZJXeyxFrztTpM6xUeCVbKneT5s7I+66ju0bffSLPJWfaOiiP+ALYX4BOH5eYYRA81cPY6aZEALU8tajNjGVYWFEKNagwwEKOGadCt2aRdn+xM5JvbAWeyAi9qmoZAYDOzmHSZphvutBSByY0e01MOFkN9uIIoSDj0ZsBQPjNEAaLhj7gSSfA5BCZu/+JdvoWGU5JTVKZ8jnBnNgcZsvkvYp7Mg0YDY/fes7kmrQAZOxwGQX6tIuPOk4xatyWinSPGTRkkZC+RN+3FLQnG3c26fz90/b1uSUp6X2I+Wd9u9YL5PE45NW99cQB2vXf6jLoSN5mk43yk6Fxc+4QCteobQpP08B4ND5N/H/
 99yP87gx
 WgSK5FWgeHqLp2oW43Qf9qnsr7xRgjLRV+BPDr02oVFFqe0cGkAybYpXKJiJQ2QIGloS3lOZCEimR101ea2dHlkihm74vfgBi16jZi2oRQDESAPJ9mT/m0rTvrRv18aQY9gqHHA8KsV3aTpU7TiDsUma5DEnTiXWDCKQQqfjJeUf7k8NS3datSgEDZbqlKq6bs6E8HSVd7x9eQYbj8PFfzP/uRA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On Wed, Jun 10, 2026 at 06:29:12PM +0800, Baolin Wang wrote:
[...]
>@@ -2768,15 +2827,23 @@ static enum scan_result collapse_scan_file(struct mm_struct *mm,
> 	else
> 		cc->progress += HPAGE_PMD_NR;
> 
>-	if (result == SCAN_SUCCEED) {
>-		if (present < HPAGE_PMD_NR - max_ptes_none) {
>-			result = SCAN_EXCEED_NONE_PTE;
>-			count_vm_event(THP_SCAN_EXCEED_NONE_PTE);
>-		} else {
>-			result = collapse_file(mm, addr, file, start, cc, HPAGE_PMD_ORDER);
>-		}
>+	if (result != SCAN_SUCCEED)
>+		goto out;
>+
>+	if (present < HPAGE_PMD_NR - max_ptes_none) {
>+		result = SCAN_EXCEED_NONE_PTE;
>+		count_vm_event(THP_SCAN_EXCEED_NONE_PTE);
>+		count_mthp_stat(HPAGE_PMD_ORDER,
>+				MTHP_STAT_COLLAPSE_EXCEED_NONE);
>+		goto out;
> 	}
> 
>+	result = mthp_collapse(mm, file, start, addr, 0, 0, cc, enabled_orders);

Feels like the second 0 wants to be "swap", no?

>+	if (result == SCAN_SUCCEED && !cc->is_khugepaged) {
>+		/* If MADV_COLLAPSE, adjust result to call collapse_pte_mapped_thp(). */
>+		result = SCAN_PTE_MAPPED_HUGEPAGE;
>+	}
>+out:
> 	trace_mm_khugepaged_scan_file(mm, folio, file, present, swap, result);
> 	return result;
> }
>@@ -2808,7 +2875,7 @@ static enum scan_result collapse_single_pmd(unsigned long addr,
> 	mmap_read_unlock(mm);
> 	*lock_dropped = true;
> retry:
>-	result = collapse_scan_file(mm, addr, file, pgoff, cc);
>+	result = collapse_scan_file(mm, vma, addr, file, pgoff, cc);
> 
> 	/*
> 	 * For MADV_COLLAPSE, when encountering dirty pages, try to writeback,
>-- 
>2.47.3
>
>


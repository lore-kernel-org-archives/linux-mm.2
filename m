Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DB427FF8850
	for <linux-mm@archiver.kernel.org>; Mon, 27 Apr 2026 01:43:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B4A9D6B0005; Sun, 26 Apr 2026 21:43:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AFB116B0088; Sun, 26 Apr 2026 21:43:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A11636B008A; Sun, 26 Apr 2026 21:43:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 90A3A6B0005
	for <linux-mm@kvack.org>; Sun, 26 Apr 2026 21:43:05 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 2FDCC1C09D7
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 01:43:05 +0000 (UTC)
X-FDA: 84702637530.28.2CE1757
Received: from out30-97.freemail.mail.aliyun.com (out30-97.freemail.mail.aliyun.com [115.124.30.97])
	by imf15.hostedemail.com (Postfix) with ESMTP id E0D1DA0002
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 01:43:01 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=bf4Nngqs;
	spf=pass (imf15.hostedemail.com: domain of ying.huang@linux.alibaba.com designates 115.124.30.97 as permitted sender) smtp.mailfrom=ying.huang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777254183;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ePqS8q5Is8xzOptDw0ODHvqxS5RXYp2DBozEtMHv32c=;
	b=CWqBGgFZ2c2piM7lKaWyy2SnwBli2BrZOV5ybrdOQ3IMKUUIXLTHhdmBAuZzPKiRouNoF0
	ORWVKcTAusMsOG64ASDTQ+nkgQ8F8GaUlwdoJX7PbALSs5CUrBu8bxCcE7bg59xxUSRBiz
	a1YVPbMnG0bT8hGFLIMSzqKv8bavnig=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=bf4Nngqs;
	spf=pass (imf15.hostedemail.com: domain of ying.huang@linux.alibaba.com designates 115.124.30.97 as permitted sender) smtp.mailfrom=ying.huang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777254183; a=rsa-sha256;
	cv=none;
	b=rM4gx5W68Lcd189Pkep4IqMOquLAgonbnPpbKkph3As6gbIKVEUXAWkig5CwZC1UWO/0mD
	3X3toeSkQGUnQpKep+v2XWVR/OMjZ4QxaIczq/9hP5Gvd1xO+vjwOPQlffp5QoNdSMaTp1
	lxRLv6j/pdwhYyb5y5Er0mH90q1TUo8=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1777254178; h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type;
	bh=ePqS8q5Is8xzOptDw0ODHvqxS5RXYp2DBozEtMHv32c=;
	b=bf4NngqspTK1IXcL9RwPFMF8W1VAZdl1CEL1PaIN19r9bAOt+If23X5gFoZe0+x4MQWo3NCbph0sIVyQBq4h+jl8lueokv/jUlCowAwm0s/emsSXZrugW6rWCIUpRlq/2Cj8Vc++CCYM/hcSWRRJLRw7Vp9AkbcOjO1YigZxEd4=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R151e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037026112;MF=ying.huang@linux.alibaba.com;NM=1;PH=DS;RN=12;SR=0;TI=SMTPD_---0X1i.oX8_1777254163;
Received: from DESKTOP-5N7EMDA(mailfrom:ying.huang@linux.alibaba.com fp:SMTPD_---0X1i.oX8_1777254163 cluster:ay36)
          by smtp.aliyun-inc.com;
          Mon, 27 Apr 2026 09:42:57 +0800
From: "Huang, Ying" <ying.huang@linux.alibaba.com>
To: Sunny Patel <nueralspacetech@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,  David Hildenbrand
 <david@kernel.org>,  Zi Yan <ziy@nvidia.com>,  Matthew Brost
 <matthew.brost@intel.com>,  Joshua Hahn <joshua.hahnjy@gmail.com>,  Rakie
 Kim <rakie.kim@sk.com>,  Byungchul Park <byungchul@sk.com>,  Gregory Price
 <gourry@gourry.net>,  Alistair Popple <apopple@nvidia.com>,
  linux-mm@kvack.org,  linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/migrate_device: fix pgtable leak in
 migrate_vma_insert_huge_pmd_page
In-Reply-To: <20260425134453.23769-1-nueralspacetech@gmail.com> (Sunny Patel's
	message of "Sat, 25 Apr 2026 19:14:48 +0530")
References: <20260425134453.23769-1-nueralspacetech@gmail.com>
Date: Mon, 27 Apr 2026 09:42:42 +0800
Message-ID: <87fr4hw54d.fsf@DESKTOP-5N7EMDA>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain; charset=ascii
X-Rspam-User: 
X-Rspamd-Queue-Id: E0D1DA0002
X-Rspamd-Server: rspam06
X-Stat-Signature: tjx1iyqgg1rytyo3wqncjz8anynoq7bc
X-HE-Tag: 1777254181-964806
X-HE-Meta: U2FsdGVkX1+qbmHtqsycV5/GmBVuv9TqFk7LMtJobcVFK2op5QaoPGDQOeYuFyPs03O3IRPViH0rElwjEMu+Iq97Lvs9e/MRlOTbW5+f9ajJgDttPuV5Oi9dZ28cGIB9kw3/CMCyxKLa2QbixDaJDfD59tifN/8BdEtkFX8IDjvx32hEMExXpuz78p8fxNssI/K+nVVTTzb8LJ2WwUupnAuWW++6XBGZNdC6Jn5gqrNzJBYhBTqEzDXN3J2bBAmnsinlEeT9k3heNoTYRKe5Dxb3kcpkUn+sLUXuHgJMaMCOyPu9eOvlxs0kvJ/j++mgX6GkCl+EhlyLRw22bDUQsk4c/tqazX2ImAr8/H4x5brsy5WA4fONKGHlNyDXkXrw6r+MBg2G2erTfmJb8OAa11Y6sGEaDZwTh5043SpKR1hSJWs+7YTSrcfxZOSlWJ3ZL1/L/5Vrq0r+oRfaqrh96hSvWS3k8SCu3L7q3nyKOtVGfCLnge7dBQyjIdx22C3F/8kS/vNtL7dbVw6zjke2ge8IzP1REgHza5uuFBJ/xRW5Jfy5kNq7Vy4Kprdh3SFqs8gUrZyiVnoGEatMFdSst7auzzCohqMnoQJ2ZvyYFr3/thqFGWdrhcvu8cdQAaYFtSOIWHEXIEGB06uZPBCXfDckC8UP+I2ApHu1YjLtp8JuW3pZZoIsixmQOyp7AXORX1mi/tpXvQRXY/kglNOSTNSRCrVDk7CC0a3EnFqupWo6an91xTKBdF9Nl1lFS8b0vkBj1CfjVY15IODhGQFOcrCRadH1JRgq+2okdEsryRuWuIkXEMzdWGx/hSPl/ReejIMREO2U7jBuUkMHNztOWUo/pdd+y+K8VwqJV2AzP2qYtwZ9F0Hb/kbKC8scsQDRtyP0bjHkXVqRq9JLhV0FP4eOJxkVAWSppSoEUnjGMJDJRWF50MCnBdAw/Eb2jgTGjufofbX+fdINGOecfKW
 G0W9aXuV
 slur55vjfrbs0+tUen9sMaP1brSu3B6VmPAQYz2qW4pqlAIac42cJ4Pf9ys52WPWWJId4LvdVT0tWamxHTiHDznKU7og8O8DRfA+WOnbj6DDXFBqCAIgHRcuP6T+X/2XX0rsyoiCJf+npqIOv3xoH/kskCK+FYS5pLwyw2mIIxtlfdDlogbiLJNUc+mHh5QQrzrHgnMR4TvJJHTGrHIKOwD7n8RwD1e5qub8ZIY7uaoXa/vyIy1DHodxQg5Z39YXDLB+E8sbSoJIINZSD1j+BnMTmxJJHrooWYF5qzucKzMUjl/b6fOiNxJB69kxe3pmp1ASWNhWAeLiOius3A4IWCcooXrb4RfKRSnP4nzNWv9Y0dnrhjPq9dBwD847IZ0yKQFQ/nqHa6xKwoJI9d5gTHWnIev1f1mq+BDFF
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi, Sunny,

Thanks for working on this!

Sunny Patel <nueralspacetech@gmail.com> writes:

> When migrate_vma_insert_huge_pmd_page() jumps to unlock_abort due
> to a PMD check failure, the pgtable allocated earlier via
> pte_alloc_one() is never freed, causing a memory leak.
>
> Add a pte_free() call in the unlock_abort error path to release
> the pgtable before returning.
>
> Signed-off-by: Sunny Patel <nueralspacetech@gmail.com>
> ---
>  mm/migrate_device.c | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/mm/migrate_device.c b/mm/migrate_device.c
> index fbfe5715f635..457bab5c7c31 100644
> --- a/mm/migrate_device.c
> +++ b/mm/migrate_device.c
> @@ -893,6 +893,7 @@ static int migrate_vma_insert_huge_pmd_page(struct migrate_vma *migrate,
>  
>  unlock_abort:
>  	spin_unlock(ptl);
> +	pte_free(vma->vm_mm, pgtable);
>  abort:
>  	for (i = 0; i < HPAGE_PMD_NR; i++)
>  		src[i] &= ~MIGRATE_PFN_MIGRATE;

Is it better to use guard based automatic memory freeing?

And check whether guard can help unlock case too?

---
Best Regards,
Huang, Ying


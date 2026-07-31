Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 23229C55173
	for <linux-mm@archiver.kernel.org>; Fri, 31 Jul 2026 20:00:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CFC206B0088; Fri, 31 Jul 2026 16:00:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CAD7F6B008A; Fri, 31 Jul 2026 16:00:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BC2E86B008C; Fri, 31 Jul 2026 16:00:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 966216B0088
	for <linux-mm@kvack.org>; Fri, 31 Jul 2026 16:00:25 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 233CC120134
	for <linux-mm@kvack.org>; Fri, 31 Jul 2026 20:00:25 +0000 (UTC)
X-FDA: 85050138810.20.DD23087
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf21.hostedemail.com (Postfix) with ESMTP id D47ED1C000B
	for <linux-mm@kvack.org>; Fri, 31 Jul 2026 20:00:22 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=iHmHFJD0;
	spf=pass (imf21.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785528023;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dZT9+CTn+bjLGUN5P6jZtXT3Oe8XoKKTzXRedmYLMew=;
	b=yDOdOO05MUVYjcJYsXB2oqHaqxqpo3mFsVynmi5sE7urzJuXUbnITG2QRgl9A+cgckoLcS
	y2VXN6pH29BaVMnNFx7jbuF3ztcKDVAXtLNPZZQj88hR559/mQrr4idDRlqPcunanGbvva
	LN0SddShJTIKZA4tgxGhZejlTcHlXJI=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785528023;
	b=ocFzoKCOFMGXomAaPPxDC7SjZE7F/LeDbx3qpkqzhrNx34Ws/RjKbo8Mj3y5erPyt1jViW
	qKDQYCzaAk5S9u+fi/dK1Hkog4hp1uPg6bQjgXd9Lve65LtmpAnWPqxmm886Lah4MOJvBY
	Zzdz1+rF8dJhluQmL2qMUv+0XH7DkEA=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=iHmHFJD0;
	spf=pass (imf21.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=dZT9+CTn+bjLGUN5P6jZtXT3Oe8XoKKTzXRedmYLMew=; b=iHmHFJD0hadfYVHZHTaZiKqCrV
	G3474FAUSeNF1IIpVToLdSl+pNNnmvlHWG1a6cBEHDqR2MHr5LkIFWUDZpQI3XK0LoQoQbTghA1A/
	Cfysl4y8kc2FaP1Sie1oTSxOmDwc3B9YlTz/MkgLFULhoG28144rFwtgOd3ACZ5N5KOjxdV4MEeSM
	lSu8suzl60A+yZhtJAayk5EFwU0VVYjazK4NoCoyHEL/f6lLfYAmFnGmYErJwI2UuX6to0xAvF6GP
	KzH/+y+lkfZrD2wgtmKiprd12uZWafAwCRR89azmGYC4USF892UCsNHPZfA+nGEl3vhgcPwjc5nbX
	jmOtx0IQ==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wptOv-00000001zPM-4Awv;
	Fri, 31 Jul 2026 20:00:14 +0000
Date: Fri, 31 Jul 2026 21:00:13 +0100
From: Matthew Wilcox <willy@infradead.org>
To: Miaohe Lin <linmiaohe@huawei.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Jane Chu <jane.chu@oracle.com>, linux-mm@kvack.org,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	David Hildenbrand <david@kernel.org>,
	Naoya Horiguchi <nao.horiguchi@gmail.com>, Jan Kara <jack@suse.cz>,
	linux-fsdevel@vger.kernel.org,
	Christian Brauner <christian@brauner.io>,
	Jiaqi Yan <jiaqiyan@google.com>, stable@vger.kernel.org,
	Gregory Price <gourry@gourry.net>
Subject: Re: [PATCH v7 01/13] memory-failure: Fix hardware poison check in
 unpoison_memory() again
Message-ID: <amz-zad7HM-PEkjb@casper.infradead.org>
References: <20260728204409.3396238-1-willy@infradead.org>
 <20260728204409.3396238-2-willy@infradead.org>
 <amlKHkemYQBxFESG@gourry-fedora-PF4VCD3F>
 <amlav1zfVy-9fLw5@casper.infradead.org>
 <ccce5d73-b5d8-3e23-8e49-bb154af023d4@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ccce5d73-b5d8-3e23-8e49-bb154af023d4@huawei.com>
X-Rspamd-Queue-Id: D47ED1C000B
X-Stat-Signature: qkwho6qtdxhzps71p6su6wc7kkk1kzox
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1785528022-554142
X-HE-Meta: U2FsdGVkX1/1z+htLa2JqY6kVnpKNoJdDjcWMB4HPurFTYEiVa5SQ3v48voZibcCOO9ox3VgkR3COlKYhGE5jusK6xw1SXgpQrqvvVo/HNNqlGdjTz+o1fgLdBqw94uOOtLLKn3nO3z7f69cgdqw0l2FSGPMS5NWgF6DESPronxJFg9T6bbo9nbW5Mvp2R19JeSx3QLq539ZZa/dcS4wHIf/cgR/ntkUZ/3USdZb/FHPWZv0bdDDK65E0vtqp1XA83SqOV1fpV68OLVW2SX3bYguustDDIUyH/C7MnufYSZ4C4aJDytz4J44XImLwZRPOZUDWn+xUfmT/0DFpXn3dkujNJrc1GQOEIwKhx+SvNaZfQH7wfOV8n1OOrCyAGMpVbwCINZNPOjURVi390Y4xZR9wL3VGVB9p7Y3CJg0jdKCCvxhWT8urql8w5/+hHCuYcgxKh9KoQ08LdS+cA6yI+bBTY31T+PBTxwI7Eac/ldgfvhnVHpuD2UA9pUC6SJIlVAMvyFo8UdGPeReYt3TYXkWtXvOGKhr9WI1BZTTTR3MVgD/iQP88Wxkv9q7HS3kpRpVoheta+wsk93xEeU/adnNUgmFhG+KdELTDFY4MT1dIGnF5dxvN+YXkLNHhl6in2CpjMjmnC7aCBqitQX4Xs/CPgOAhV68Q1oPeyN5JohlEd/akAzFsz07HEjva6ixoZFOArtN6omwLqT1uW2MDkWkiBo86Q87rTcrQl3ILPOZTQC/H8HK/mAK2xKJujBc9iqVvcynD4dvukG8fpr+oKW38I+5mCp35BljLGlAOwXv2Eb6/gXj/Vo1gG0tJqI05o1aMCAT/CAoxzBeDjMMUTNt3KafttX49P1T8tDGzRmspBQEyN7jNukXp9m3oH4gxClW9sqxhCNaiEyoK8CXr+sN+TgHgw5DkLxlcg/FiyDnoZtfBmTjG9BaGklOzb+3/2HRk9n9DJUL8jxvfjw
 9K3Q2ETe
 vDKNAqeMPLRE6VkVgmOGgbTUcQ607fZ26s4CA+hnjQQd607Q3W5ILE/4SLcRERjUFknRxAsIAlHl8kxm+nX1KHflPfklBl5ClrNntfSMqprQJ2pfwMCEzBcjLuGZGi452YcCe60rYZsgNP2LUe1CpgIYySFU4YwUkpQpJxJB7huhNj9HxTvwAXEP6BP7xMbka00snre99FtCSleHuzyFs95hebtJm+hd18F4rVc55WVLEUvEV3Ylc0WS9wisCFGFpGE+XA0wLh1oap4mmKYSnG/V+STNwt2MdUnPMwQ9a/OeryM0ymMLB4D4KpoCrT3oz5b/rLEeSwVJMRT9I2rnGKadjfoSHLKozWzYrg5nbN26mT8YfawhJlLiG6G9uMK4N8c+ZFDzuCaOmioo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jul 30, 2026 at 04:45:19PM +0800, Miaohe Lin wrote:
> On 2026/7/29 9:43, Matthew Wilcox wrote:
> > The careful reader will observe that injecting two memory failures
> > into the same hugetlb causes ... problems.  That's true before and after
> 
> Could you elaborate on what problems this might cause? IIUC, second memory
> failure on the same hugetlb folio will make try_memory_failure_hugetlb() return
> -EHWPOISON without holding another refcnt. Raw error pages will be added to
> raw_hwp_page list. Then in unpoison_memory(), raw_hwp_page list will be cleaned
> and extra refcnt held by memory_failure will be released and PageHWPoison will be
> cleared. So it looks work to me. Or am I miss something?

Thanks for the explanation of what happens.  What's confusing to me is
that we can poison pfn A and pfn A xor 1, then unpoison pfn A and that
causes pfn A^1 to be unpoisoned too (if they're in a hugetlb folio).
That's an unexpected difference to me; I'd expect to be able to set/clear
their poison individually.

But it has been this way for many years, so I presume people are either
used to it, or don't notice.

> Reviewed-by: Miaohe Lin <linmiaohe@huawei.com>

Thanks, added.


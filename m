Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 46550CD98ED
	for <linux-mm@archiver.kernel.org>; Wed, 17 Jun 2026 22:28:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 259966B0088; Wed, 17 Jun 2026 18:28:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 20AA66B008A; Wed, 17 Jun 2026 18:28:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 122A66B008C; Wed, 17 Jun 2026 18:28:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D477B6B0088
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 18:28:21 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 45B7D1C48DC
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 22:28:21 +0000 (UTC)
X-FDA: 84890844402.21.9775B4E
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf09.hostedemail.com (Postfix) with ESMTP id E2BD7140004
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 22:28:18 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=hcURVoml;
	spf=pass (imf09.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781735299;
	b=snPS9rFokve/MAAB7ajKyN7ytRnUqmzH0LOaadXD8OFfg+QOExIQ5cKctHtZM6cO1rXsPQ
	/T7E7My+zt/7TZUFkIeCkrIRfRxGbZchs1B1eWeghylBEHy9AnY8xsr6melDfcHLguspqh
	zGs26cTSXA2DEwqRZ2CdQuPVq0NyUsM=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=hcURVoml;
	spf=pass (imf09.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781735299;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KNYyO6SgPKl4C9MF3+RAjBkHpwVrxYNEfsKvOvBWLNg=;
	b=b7FwTzMTHIEMvEUFQETGyaf0tg8HNw3ytyHu39G429ixxZPU3AfFFtO7YxnUo5kscwogMJ
	xhMOffOWqi9Xo8PmJlaTUwnTHFvkx3DrrIW+g+h5zZIqf8dFjDEmBMbhdHFVQK3Fbj0Oyk
	upTQIoRd2BtsOLlcgELvY58e8IW6rp0=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=KNYyO6SgPKl4C9MF3+RAjBkHpwVrxYNEfsKvOvBWLNg=; b=hcURVomlWT5nqRNu4mssXwPiRF
	7ktKlqqLah/ESrsnAO6TOGb+NLOJLeg9107bAxjEw9M9V3sAlzaUcCiLUt9apxycXIeiKiPih4gqR
	E2mufM5NaHDNLe8jEaU6Ts7ttO3cLylYfAZPi7Varz/WNutEv8s+8yBmeP0cPk0Kw4eYYvik0rd6Y
	RN9uSE61LUWHgRolMlUq/PO7+H4PurkY+ph7z/Xx842H8s48zJPs3mjU79lXW20E7Prs+cNTufO/w
	M4iDrprAndP9FvtTAFa9WZH9hBCX5oFdkS4wI1BDKX/NkpulEn0vhuVKEmqsmg7ftB/h8n3Cbc8Pl
	RmuqUqmA==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wZyju-0000000DNrv-0BST;
	Wed, 17 Jun 2026 22:28:06 +0000
Date: Wed, 17 Jun 2026 23:28:05 +0100
From: Matthew Wilcox <willy@infradead.org>
To: Jane Chu <jane.chu@oracle.com>
Cc: akpm@linux-foundation.org, jack@suse.cz, viro@zeniv.linux.org.uk,
	brauner@kernel.org, muchun.song@linux.dev, osalvador@suse.de,
	david@kernel.org, hughd@google.com, baolin.wang@linux.alibaba.com,
	linmiaohe@huawei.com, nao.horiguchi@gmail.com, lorenzo@kernel.org,
	rppt@kernel.org, peterx@redhat.com, corbet@lwn.net,
	linux-doc@vger.kernel.org, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH v2 05/11] hugetlb: Convert the vmf->pgoff to PAGE_SIZE
 granularity
Message-ID: <ajMfdQf-Fspwmstr@casper.infradead.org>
References: <20260617172534.1740152-1-jane.chu@oracle.com>
 <20260617172534.1740152-6-jane.chu@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260617172534.1740152-6-jane.chu@oracle.com>
X-Rspamd-Queue-Id: E2BD7140004
X-Stat-Signature: tgh5ypq49otqgyr7r4miuac6p81p6png
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-HE-Tag: 1781735298-557345
X-HE-Meta: U2FsdGVkX18gHZiNE97lVULFDPrpTZCWcgVgZd8d/JLWCBIp489o5eCrENXszF3jIjDWDGWfOIoXkqNSxYngU1g6k9A5c/8/0Kgh0aHF9cjIP0r8op26ycaKU9gsXU0HY4yF5evqcZ44sGwXk7ENdAOcKrKTGIswkPaszmhU1TXmwixvwgG/SQ8RdkjqbL1szhXoBIvgF9yY0T6fk/PNtos2B2W+5T8P28ACAcutcj28tioANvZK/bYxqupjde75AQsZ8Njk9oLJ+dSg7WTLTQpYxyICY+gJ9ktKw/5j0z6GnOsuq4hie7oYI91Ad651xCmJgl0M1OewlUl06IDhi6Q0Psab6esCZqPjoLpd0lKGK/lE7Mjrpz2cvhlDXFjGpTiO2KQIMatBwBwD/gC2byyKlIjU3JAHQmr4cLocwtHf7Ln/a9sM7+FPSGqGSDrg1r8f4Vtbg/zhzNXLlvxRdy4YuP3rGPeFx3+ol+j+pii/kBV1IxcYfwT9WRoriWiXzZTN/3MyHsJu7vAdt/NwDpt6REgi7sq8k7qxGjYgZfbxetrRSH2os0bGhKIFRhNgkc012IYBe6p+LrYXpFof2Nccub3nlcZ9NjI/QHD4LTt5QoUZmA4b3amjPCEu2flokgztIZSU5F/8rslFvMjOo0G/Bf/r0Rltx8DUtpfAgKbSiUjK+2UfOdu9h54aTKeV+9u4/sox+WHMr8gLCLk2PLfLVV58L8UUbZqmMKkq2twDGoQVuqURX9S1YxqoeCqGOiTegNujTEKHs+Q//a4W5LNMiWxerx/uXkflCyQrMKxQeNKOLQlVcocGbJUUtCMToZR/7FcnalCj4r0y9arnCca2wPh4WlM1747HG9t2yA1btu2xNeZSwGN4R5bRHq8c9TdpGTYwaGCHSvaorgCrlUJK6/BHw23l+921EFA9RJcSnz9N1+iCQ23Olx/aUWLHHAn7ljsUtEqQmqWo5j0
 vk+AzsH6
 muQUgv0k5eRsHSIa4RXqmVxmfAFD5UwgdTAr883Jb313++p0vpzFE1fmGrXfUxJFy3P70muUGyUwNTTOiX+ABqFSd3P85YYKYixH93sdW/JcQ9ZMcKLZMEvC4hNx2SdaOev4YeoLs4Yh6RyCEbhe57orIIYzyjkkJ8Y9IDdxDOcat60s2f/TOTSp3zDLXDAnDcD869LsbTxJO1/cr5/SV0ickfZK49iJvqRIcXLNI+9oHCY+hgHCWanX6zpjkRAYbB1a03CtjUACIdIRipT4nubJ8eavXqFbRLRuvAw/DyktMfdfSiE1/Q0IQMLblhiASH9me4wqVL8Dcaer9Y9NFtXVX4++1S+wVDtwEgtJEdNmCn6gsptlGqAJp5RlUsDM5tpEwtJMvuWRby8I=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jun 17, 2026 at 11:25:26AM -0600, Jane Chu wrote:
> +++ b/mm/hugetlb.c
> @@ -5654,6 +5654,8 @@ static inline vm_fault_t hugetlb_handle_userfault(struct vm_fault *vmf,
>  						  unsigned long reason)
>  {
>  	u32 hash;
> +	struct hstate *h = hstate_vma(vmf->vma);
> +	pgoff_t idx = vmf->pgoff >> huge_page_order(h);

If we do manage to make mapping_min_folio_nrpages() return the right
answer for hugetlbfs (see earlier comment), then we can avoid this by doing:

+++ b/mm/hugetlb.c
@@ -5936,7 +5936,7 @@ u32 hugetlb_fault_mutex_hash(struct address_space *mapping, pgoff_t idx)
        u32 hash;

        key[0] = (unsigned long) mapping;
-       key[1] = idx;
+       key[1] = idx >> mapping_min_folio_order(mapping);

        hash = jhash2((u32 *)&key, sizeof(key)/(sizeof(u32)), 0);

although I wonder if we still need the fault mutex array, given that we
now have mapping->invalidate_lock?



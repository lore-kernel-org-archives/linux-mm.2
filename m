Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2F183CD98F0
	for <linux-mm@archiver.kernel.org>; Thu, 18 Jun 2026 08:17:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B72186B0095; Thu, 18 Jun 2026 04:17:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B49F66B0096; Thu, 18 Jun 2026 04:17:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A3A826B0098; Thu, 18 Jun 2026 04:17:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3FBDF6B0095
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 04:17:19 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id C14C01406AA
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 08:17:18 +0000 (UTC)
X-FDA: 84892328556.16.F5C0C8B
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf03.hostedemail.com (Postfix) with ESMTP id 11E8420002
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 08:17:16 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="D9We/85S";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf03.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781770637;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3FpCfwSGbFj1ORl9+5SUvGkHql53Bq03HU6wagOjIx4=;
	b=doe/iaSSHEENugho/L3UEd5tslgB603u8NSE+TvbyO3wPAd8BbPQSNpcIctjv6P23Y9mrV
	8uFCiNQ6lclmwxAf/7NUixQSu3Quh+xj2uQ20dJhDboPhJePfLkpozL4TB/E6Yxs5FPez8
	8+zaMmFPevah+s2ZsHAVGssP/8HhkJE=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="D9We/85S";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf03.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781770637;
	b=xPSJavQIviN98i3FCMw6dUKG+5Z/p5F0BXknxGdpEWbPssAvX6r2HCSZisKXmWhrm+OYVj
	f/vh00yJ63LW5W4itF6QqUUqc9oxjaBzit3r+nLXrIwOdtbzTPSxzNqMtEocT3u1MFH3e+
	11AjxNRtXm/tuIvTUhoc9q3/KT4ATwk=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 8ADB66012A;
	Thu, 18 Jun 2026 08:17:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E6051F000E9;
	Thu, 18 Jun 2026 08:17:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781770636;
	bh=3FpCfwSGbFj1ORl9+5SUvGkHql53Bq03HU6wagOjIx4=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=D9We/85StERcFnJLm+5aRYUmACRykavBGx1pKs5I/eNVSr6casbiGlTJs8XvQlWb4
	 xtDu0sfAf8KHpOcRNdg5ERkwiWvc8rb2NneHWJBOx0hCv+/gcNR65ECPhaRsnKT4dp
	 QCHmKdaKba227L5X7yKdOMyQ5pjxFgiTAQff31vesj26AicykmMJnN55fugxFa2MkB
	 f4SED0jT5uOY3lRr7VEPFsBxkloODAaNu67Hd6MFRkwvv7ePrWikhvJf0WsQjRfukW
	 6R01fesVcjRNGgpC2O5ExtcUqF48lUpPwXT6K04aKrdQUHqxmi/XZTCcRkitpyQX+r
	 4FaKycVFRxNKA==
Message-ID: <73acffd5-deda-4270-bc1f-6b056c8cdaeb@kernel.org>
Date: Thu, 18 Jun 2026 10:17:13 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/4] mm: mprotect: use walk_page_range_vma() in
 mprotect_fixup()
To: Kefeng Wang <wangkefeng.wang@huawei.com>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: Zi Yan <ziy@nvidia.com>, "Liam R. Howlett" <liam@infradead.org>,
 Lorenzo Stoakes <ljs@kernel.org>, Vlastimil Babka <vbabka@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, linux-mm@kvack.org
References: <20260617082622.3397584-1-wangkefeng.wang@huawei.com>
 <20260617082622.3397584-3-wangkefeng.wang@huawei.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260617082622.3397584-3-wangkefeng.wang@huawei.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-Stat-Signature: ugtq3gq4hsfd3811b7u9cp94p5e43zgc
X-Rspamd-Queue-Id: 11E8420002
X-HE-Tag: 1781770636-609859
X-HE-Meta: U2FsdGVkX19I1kfjacGzzxEg+bJLkQckK3/WF0JedAx9d3OY4i8vF/jt1V6xE5M/5827aLd9HPt2q3JdE/CZe9f1rdrhjbyBPZLwn7sb/zfVoip4py1rlZ9Zy4hMz8+qWJ9xbN0hJ7s6bi++MHVCKnlbzsxKuPw9oypCvb9qNnOeAGJX/2K2StYGSbaZD1b/j8f1lM5NYQWtuIO57onkAUxSh9Xy94HcyI67nzT7vzsplc10owgACdWdEqlzx7MWCHv+mR3j9ZJ98cVvgtfK4TpqcG6nq7aMfqaHxjYWsIWqkzvCcBh8q+0w+IYe/APq9bq6M20XWa7jkPOX8vClX8xUMSagVnFhigKPUBLclN0YqCejVDANcs3C7V0fC3SlUJwRs68Rc9sSAgydmPy4Zr03CKUHpW6UJLPTqLIw1AIHOnGTMUPOL9Ls/QWnI2RcvGLpX+Ky0/Box9eGvg/lFElcHu9DhK0DE2KJruXDltjs/6RhpwAWZabAnoar6X0lmzLG0Zwt+mzPq20vjFr+1EjO7kNYvs1Kx0X/fPpGX6/gnSrgEte2etMADLS9ivJS2nhKufOwIG04SZQcUJ4qarL6RdK4IPzmn7gdpRDinDdvl+UHSJgzMquCBgUCTkh0m4hUpBMYj3t527qn3rveEvq1Gn9aklAPEU17flikyXJ65YFmf6FTFzArsz+uWhzKpBSOhOwulV3Hkek5nBxzQ/WZSyCuEHIPZFqk2W7lXwpKMNSoDVGCQbgWdn3iPR++Jyd3ICzSVq9GT/teoZgXPv8lp5Ud8yySjP7K2fffX8iIhTq0FvWDie71fGpJGvG/iNaP7DApVzhV6bXu6aAMhco933oSCJTROss24HlknnvfPED77pn3nt45ovSaIccNWXtrRTdb6r1cJrkb1fae9Nj295QKr76KGpi5JMe3B9bedEX1SUKpUxBfhzvISixNUPeUb9dFBbGBUFqxgpS
 ZJeGvMEM
 aVlQjYdfLVUuoxva3YEx68CKAYhdGEMs7U3GkE5nYheInUUc13NN29wVEsueF2LT+f4Sohy49AoU4ddKDQHewY4ax/yeMEQhhM3o999iEPJWWRzUvuF5rtq+1D/qE9FcysG4tZ9ui+grrGBu/0lRLU+ODEIvMUEWdf2Vcn+6u9iHV7V7FLO0hZKEnSOgTrG6uGKcb02GPq57EfgGudz7pWeSZCY8BKTlgYs3QrPVn+OMsQgAT9AFPsk357IRR8ZO6HVXRtDmBhDNMr/J2cwki3Fd+aaFvf8mwPNAaxrfURkrTrhSftKkfmS0sJA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 6/17/26 10:26, Kefeng Wang wrote:
> In mprotect_fixup(), the PROT_NONE PFN permission check uses
> walk_page_range() to walk the page table. Fortunately, the caller
> always passes start/end that falls within a single VMA, the
> do_mprotect_pkey() iterates per-VMA via for_each_vma_range(),
> and setup_arg_pages() passes the whole VMA.
> 
> Note, walk_page_test() isn't called in walk_page_range_vma(),
> however, prot_none_test() in prot_none_walk_ops always return 0,
> so it's safely replace walk_page_range() with walk_page_range_vma()
> to eliminates an unnecessary find_vma() lookup.

Heh, same comments as for #3 :)

-- 
Cheers,

David


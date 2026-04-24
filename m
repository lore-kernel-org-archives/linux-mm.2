Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2634AFED3C9
	for <linux-mm@archiver.kernel.org>; Fri, 24 Apr 2026 14:25:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 823A26B0098; Fri, 24 Apr 2026 10:25:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7FBA36B009D; Fri, 24 Apr 2026 10:25:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 711CA6B009E; Fri, 24 Apr 2026 10:25:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 5F70A6B0098
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 10:25:52 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 27C851C00FC
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 14:25:52 +0000 (UTC)
X-FDA: 84693673344.28.9E3BED7
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf04.hostedemail.com (Postfix) with ESMTP id 3B3B84000B
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 14:25:50 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=DofXVLTZ;
	spf=pass (imf04.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777040750;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=23Hcsbr1tt2s2RWLFPn6vr3+cwXf/+OvNj3iHoClopU=;
	b=VvSVptn+0iZP+P1ltoOZdLO5rVkUPPUTpW80gYUzM0hlL6S3NwGG1/IUgz1hZ7KncEGJuX
	X9zCXDZRLDPtzQdEDg0bL1Se1LuTajhXUqm2Ns5PgrTegOHnbdGxP9IolQZbmkjvkEhafY
	1QQPLhD8iA4v6dOxTDUOwdVP8MQsf3Y=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=DofXVLTZ;
	spf=pass (imf04.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777040750; a=rsa-sha256;
	cv=none;
	b=8f5zIPuOkDKhXdHYP4+V6/1r6xNeJE45dm94UCQlQCku5XsuXXES5ndWORnFhvPADHHPQh
	SGusokQzmCR/lC3J3yRH1ujYxH218NLO8PTg4WdEWOglgaBOuOZZ+FJnd/neIgjNKw8HI3
	R9dojgF81nXS03cmL6cF7PXMzmerZ+Y=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 3C54943CE1;
	Fri, 24 Apr 2026 14:25:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB604C19425;
	Fri, 24 Apr 2026 14:25:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777040749;
	bh=WgkfmGhCzLmCGzkxUzpe7r47QqHHRuaSNRO9yoR56BQ=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=DofXVLTZOLJBasreFFoD4GB529ZJhR9p9hi9FJzzR7k3ya8vwqlS/HZoCOka8sOVP
	 /PiRxL7CrMv6+PHpWjGyPK3rhjRX+R/DAzhh1hBu5Vdlds7d1DNtIsUZ3gaaNJjQzI
	 U3lruPBer07yxkOFicQRfyTZG40sAEGmjBnES58hOCWky276BbHNkvuPG0B/cApuSC
	 sDPcYDMn++TNz+JgIG17HhBOwZlJgpsznHNWxyYqgYE9FYEIOUaOOBwJkYSTeMG6gs
	 ZFkTDa1Ex62JyGwnBDRJ87XhmiVu/CvXRhiS6wA40BHd3G+sBRYaor0qiQFSpGlJxF
	 qnggDM0+yg0NQ==
Message-ID: <4b961a07-b72d-4c8a-ab49-23f61ed12b53@kernel.org>
Date: Fri, 24 Apr 2026 16:25:41 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC 4/7] mm: add page consistency checker implementation
To: Sasha Levin <sashal@kernel.org>, akpm@linux-foundation.org, corbet@lwn.net
Cc: ljs@kernel.org, Liam.Howlett@oracle.com, vbabka@kernel.org,
 rppt@kernel.org, surenb@google.com, mhocko@suse.com,
 skhan@linuxfoundation.org, jackmanb@google.com, hannes@cmpxchg.org,
 ziy@nvidia.com, linux-mm@kvack.org, linux-doc@vger.kernel.org,
 linux-kernel@vger.kernel.org, Sasha Levin <sashal@nvidia.com>,
 Sanif Veeras <sveeras@nvidia.com>,
 "Claude:claude-opus-4-7" <noreply@anthropic.com>
References: <20260424140056.2094777-1-sashal@kernel.org>
 <20260424140056.2094777-5-sashal@kernel.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260424140056.2094777-5-sashal@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: zf44xcucodnezt5pp8gx1sjuqgff9jbf
X-Rspamd-Queue-Id: 3B3B84000B
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1777040750-872518
X-HE-Meta: U2FsdGVkX1/vxHY0d6qjR2MljBqWedMSSDLTlLoyMxgPFIF5oZbNzlg+oVoSoQTR2tQdUKrHqIb9OXPW7k+fEoeoQgcUemx2kUjEb2gjg+NXTuA7gaLi1CeDXSwjUUxg+nARS21hbFyhwoAGLK+NJq8WZm8JpZmjZ+omQKSOrRy3kbPUaDHco5mWsj8INnZdYlci3p9FHTrN6KbVTD5ivfcRrUrTDwZVMeQY0pLWBt4Voi2gRFLCHRHLll6Vu0yUlPL59HUjSPqpCY/cSRWAGeWTHH+/ojmio1J8VB+mAT/nooZ3YMatRxC73utwqlzKvf3j3nh0xmDdWB07rIOJX62nZUuRN1qn5FP1zc2I1iV1DCI5zCO95hR59gj/A9vy3g7fStNbHPg9KltuR6ugiKqvLDB0RKxhyGLCRz35PC713WtvyjK8fDMC0pKeXb4Sc/gtOrCQ66av1f3YEo8lhpIvvKXpEVfOs0hg9lw28uCxJ5a/GYdAgr4RHRpieuWi37ReLZcJs+VHXJvgukQdi2LYFfGJbmIdSX1ipaLToUmy/gwZtRjMfjs/ENnuJI9tn1PRUn0qj8vfmpN1NduV9uM8rryAltWjGH7BGWTILq3+A6xEY4JTUFVZsT/CvZGACEv53EG4yD6XKHj2Nsp7GqoBgdjbM4sOvCFVsDAsNDu0nepEV2j+5r/5ZhIsW048w471uwTYCmJfuaJaLATw/jTGJF/iZC0H/rqV2jQzBvVWPoC4if/LD4rWJkuHQw4mUrpf9YbnSHb2KZunJ/hyGIfRIqxO+bGHTzd1xV44MyxDIQJp7GxGxYaRXEFB/8ngWYcIX/eC4I6VTYqyHC9uPfsqUydxdHww/kZBd20tIgLXpffl6I7ipPmSgDOo2lLaZ3EyFBu/8gQmRhzyUKD3tPR1rv0OQQi31bDchEz0z2+lLRzeUr7lCy2cJ46fJz6L3UmB4MT8DbAGU9g6JoX
 edGQJttS
 nvRVLDLr4NyNqhYLdi+qGqUYgX1dIy5WWu3rLWvCmKldFprBiMJAbWPbhbEDjMzuhJQwnK7TpkGRFP93aLaO9xQ3cBhfFjN73ShjXqXghtGQRB20NiFuq/IjvDpN9YZWc9x2MAnMOUzsyWLUTnYIFfFQHm5aZloRoIoS7b06aaRF0Tw55IUzpzGaau20vTj+mSykr9rdIk5AAMEhfm66t1/Hcud9xadfymZAQHuiCOn5vXikrAc5lGd27k/rNMvAqJz5w
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> +	/*
> +	 * Size bitmaps to cover the full PFN range including any holes.
> +	 * Holes waste a few bits but a flat bitmap keeps the indexing
> +	 * trivial (pfn - min_pfn) and avoids additional data structures
> +	 * that would themselves be subject to corruption.  This matches
> +	 * the approach used by pageblock_flags.
> +	 */
> +	pc_state.min_pfn = PHYS_PFN(memblock_start_of_DRAM());
> +	pc_state.max_pfn = PHYS_PFN(memblock_end_of_DRAM());
> +	spanned_pfns = pc_state.max_pfn - pc_state.min_pfn;
> +	if (!spanned_pfns || spanned_pfns > UINT_MAX) {
> +		pr_err("PFN span %lu cannot be represented by bitmap APIs, feature disabled\n",
> +		       spanned_pfns);
> +		return;
> +	}
> +
> +	pc_state.db.nbits = spanned_pfns;
> +
> +	bitmap_bytes = BITS_TO_LONGS(pc_state.db.nbits) * sizeof(unsigned long);
> +
> +	pr_info("Initializing: PFN range [%lu-%lu), %u bits (%zu KB per bitmap)\n",
> +		pc_state.min_pfn, pc_state.max_pfn, pc_state.db.nbits,
> +		bitmap_bytes / 1024);
> +
> +	/* Allocate primary bitmap (zeroed by memblock_alloc) */
> +	pc_state.db.bitmap[DUAL_BITMAP_PRIMARY] =
> +		memblock_alloc(bitmap_bytes, SMP_CACHE_BYTES);
> +	if (!pc_state.db.bitmap[DUAL_BITMAP_PRIMARY]) {
> +		pr_err("Failed to allocate primary bitmap, feature disabled\n");
> +		return;
> +	}
> 

One bitmap that covers all sparse memory available at boot.

Conclusion: Just horrible.

-- 
Cheers,

David


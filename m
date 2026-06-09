Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BDC8DCD8CA4
	for <linux-mm@archiver.kernel.org>; Tue,  9 Jun 2026 13:56:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3AC176B0005; Tue,  9 Jun 2026 09:56:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 35CDF6B008A; Tue,  9 Jun 2026 09:56:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 29A0E6B0092; Tue,  9 Jun 2026 09:56:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1B9276B0005
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 09:56:37 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id A3E631C2CE0
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 13:56:36 +0000 (UTC)
X-FDA: 84860524392.22.25B80F1
Received: from out-179.mta1.migadu.com (out-179.mta1.migadu.com [95.215.58.179])
	by imf24.hostedemail.com (Postfix) with ESMTP id 5F3C2180004
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 13:56:34 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=nMaYrvGu;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf24.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.179 as permitted sender) smtp.mailfrom=lance.yang@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781013395;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1v2Zddelxf5PmwGEW+ZgV6CJT0DFyt74H17htCtqM/Q=;
	b=dCTQsxPXHD5O1dSZc+EQ1mryFqOxnsWDEm+my3kKKag/gupsTi/CTe79YXavSw0p0qlfwt
	4pRhZPQJlEYvRiDQAl2bLMFq8REcsevupRzg1wenjtFheBsTTtyn0eXSHWEw388vp44p+d
	voyS5wT667CDuUeb1QSDMiUAWvOProA=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=nMaYrvGu;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf24.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.179 as permitted sender) smtp.mailfrom=lance.yang@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781013395;
	b=jeS+GAfSWtOoy0qRlS3GMp65q27vljOZF03I/PKpXc08Vqr0MxHQQytkXbWvjrDds3k/k+
	RT1x2JvXLurDdib6YpHU7SEdx5rS7P5d1j5+zO+wUwjJnIdEH9exmIyyYknzW5Uf85gPBS
	S4IoGMj1KuHyJJg5VE+3pEbRZrh8Ayc=
Message-ID: <71507be5-8430-4a3d-af80-6777a421565e@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1781013392;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=1v2Zddelxf5PmwGEW+ZgV6CJT0DFyt74H17htCtqM/Q=;
	b=nMaYrvGuCeqWHmltN1ytkMCfwNtkbJpJ4jzqKPOiAiwD1CT3Ikqp1qtu38bNoRi8P55fhM
	3j4PIc6f8XGb1i/FAhZJLCaUWxMJJjXUG7kCJEWvfRhklPvXr8PvzgQof8/3XFkygYlqxB
	69BSvaQiOridjvKTAIVdsOEpU9Rkj84=
Date: Tue, 9 Jun 2026 21:56:13 +0800
MIME-Version: 1.0
Subject: Re: [PATCH mm-unstable 1/1] mm/khugepaged: fix PMD collapse swap PTE
 accounting
To: "David Hildenbrand (Arm)" <david@kernel.org>, akpm@linux-foundation.org
Cc: ljs@kernel.org, ziy@nvidia.com, baolin.wang@linux.alibaba.com,
 liam@infradead.org, npache@redhat.com, ryan.roberts@arm.com,
 dev.jain@arm.com, baohua@kernel.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
References: <20260609120443.71864-1-lance.yang@linux.dev>
 <b2d0cb7a-15fb-4b29-b86b-795d5b904a9d@kernel.org>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Lance Yang <lance.yang@linux.dev>
In-Reply-To: <b2d0cb7a-15fb-4b29-b86b-795d5b904a9d@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: 5F3C2180004
X-Rspam-User: 
X-Stat-Signature: 47x397k8ytr7odhybme8afant8hn71yf
X-Rspamd-Server: rspam09
X-HE-Tag: 1781013394-664875
X-HE-Meta: U2FsdGVkX18gd++2+bxe6XB3Bzf/1/i+Frb9EEIitqIiyG1Kmlcyv5B4lG1WtGAlM7uYhxlZV1noOTtNYLbRNSjaGVM7nGE9vjWzBOPgHF3xbPbehWt6ZPUWiRV/AKtD6k/cvGT7nAWthFFwge5Yp8TDv5GWyfWAe7r+rtzaa9oEy1boqHKTdrm27L54AHmh6BU6ek762gG6BxAK7Er/cp44g8kFnlgrWZUPnbCUhFtimxY9aORu/L9b8QMrpzdTOqqUfBgGBFGfXbvcOrrJry4VZ3FubEAxQY48Omg3rloWS+z9NNXndJAjA3lvOhvKz6l8CYZn3p1sTOxUY/t6VSo/p0tTHRMaHVc/295MH+WFAu4IP+h0q9pmOv5rQBni5oO6g2dU4eoaNYdY2lwL14Zl1/jPZ8daOj/ySZISwElXhBlO9EFXztMlaApNJhpWAS7aadk5Jm/4qlXr8KZXh/UVKbS4LJwLqcKcbiCPAZd53uBOAj18FyZWL2my5eVHGzshvakhe8FZnKVpOIYku8Q+7SJLrrWMARNq32KUa1ZAXV+nER4uLpvtQ1UvNX4GPiEFdT18aNyrJDpScaxle7612EUAb7BuGp6w9JtKuCZ9/nprS+HUr6wEkBuSrJoLWS0FPAn914bGO/wJyLV8nNOOZX/xzGTZSa4XODCrxpgcbXMY0O9Trl5CWG6fR2TYxQ2evZjWyVLOnpzAA3UShYacdTlmWZMIoQmuAc+MMUUp2vrkNZN4J7v2+udgQs06+p6KDAqUOjmT43Tx8PdXfVAtt+VP8u6ZfhpaDksUA30AVkwoBnrqahwf0Ju2+yosr3fA/s4slvp65oF2qpmCQWtPPxPremMdaKMh5UFXnqEdMw1wZEj5gA1bJly9+oSilf1aB5Q30LUXU0uMxxC79nqhSPDeyVtnoxGm8e8Cv4pfPHX0RvgpiK+2V6N9Q2lZuiOw3vyUD8NbiWA3sfa
 NG9iql+D
 5dzCAWNrcoSyh25o4sI7UzWbEvHvnwW9naWbTb1QfynLzkZlRuiCLVurIT1YQo2SCojgv+e34llDgdnGj827ndDmBK2As46i9CmsVSdbCH45ZO1oNgXwxrJdN7hEb+KJXljFfRLrWw65vkhs0arJfIKrHjZ0EE6W3nZPydzMZ+aenTSnvRr13RSc/u/eTYZBJcwEXkS+RsESet+FByN5r+reV2A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2026/6/9 21:20, David Hildenbrand (Arm) wrote:
> On 6/9/26 14:04, Lance Yang wrote:
>> From: Lance Yang <lance.yang@linux.dev>
>>
>> mthp_collapse() uses mthp_present_ptes to decide whether a range has
>> enough occupied PTEs to try collapse. Swap PTEs accepted by
>> collapse_scan_pmd() are counted in unmapped, but are not represented in
>> mthp_present_ptes.
>>
>> When lower orders are enabled, collapse_scan_pmd() relaxes max_ptes_none
>> so the scan can cover the whole PMD and build the bitmap. mthp_collapse()
>> then checks the PMD-order candidate using the bitmap.
>>
>> With max_ptes_none set to 0, a range with 511 present PTEs and one swap
>> PTE no longer reaches collapse_huge_page(), even though PMD collapse can
>> handle swap PTEs up to max_ptes_swap.
>>
>> Account unmapped PTEs only for PMD order. PMD collapse supports swap PTEs
>> through max_ptes_swap, while lower-order mTHP collapse does not currently
>> support non-present PTEs. Keep non-present PTEs out of the lower-order
>> eligibility check.
>>
>> Signed-off-by: Lance Yang <lance.yang@linux.dev>
>> ---
>> Sent separately, as discussed in [1], to spell out the PMD-order swap PTE
>> case. Patch [2] is still only in mm-unstable, so no Fixes: tag.
> 
> Right, probably we just want to add the Fixes: tag once Andrew moves the series
> to mm-stable?

Yep, hopefully Andrew can add the Fixes: tag when applying this, once
the series lands in mm-stable. Should be soon, I guess :P


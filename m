Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DE61CCD8CBF
	for <linux-mm@archiver.kernel.org>; Tue,  9 Jun 2026 13:20:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5E58F6B009B; Tue,  9 Jun 2026 09:20:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5BD606B009D; Tue,  9 Jun 2026 09:20:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 45DCC6B009E; Tue,  9 Jun 2026 09:20:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 36E116B009B
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 09:20:16 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 03CFD1C12BB
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 13:20:15 +0000 (UTC)
X-FDA: 84860432832.15.ACB33C1
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf27.hostedemail.com (Postfix) with ESMTP id 4AD8F4001B
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 13:20:14 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="Qn/TwL6p";
	spf=pass (imf27.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781011214;
	b=QG9mT1F041naF9sppQF9gWVpd1I/+7F8FiwGZY46vod7tblpokb1682ZrIvBsfpu8MBC/1
	xF9MAnIUaeX9/nYcpYzzk2tbEBQOk/5i53w4fSwuIZ9JI4379FG5i7WTLLK6ll1NukrQRy
	87+PN0b3gWcrHrtIORZpDcUFrNueha0=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="Qn/TwL6p";
	spf=pass (imf27.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781011214;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hVaej1augRXIFWuAG42FMnav00Af7NNV6S/ONanWmPo=;
	b=txXj4Au7cTDB7mUXh2q/ViwgLZqmwbJCXSc9FSqLSma3BXknFoBvQVQ5X5FhNVWKl48h3T
	+oaHQeJJl68pIBLde3jUD8rvdGCFY/bbDyz7dUOjF/kj+0J6Wq5mY8ZF1j4z48agdv30FO
	el8hl3tJxLN62ZduaLMgaWuC/K34pRc=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 9B9486020F;
	Tue,  9 Jun 2026 13:20:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98B3D1F00899;
	Tue,  9 Jun 2026 13:20:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781011213;
	bh=hVaej1augRXIFWuAG42FMnav00Af7NNV6S/ONanWmPo=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=Qn/TwL6pgtT8QYIE9U2tP7uwoTgnLZz5sBSxMK2focx9/jk2s/mZGV6jNIp6+u3yq
	 8wZgDhqklVGdn2RBWWSd4Kyr07glvsviq1pvtYGuGqkUUo4Iv2IXUHGiCXvXjNaGWk
	 HJHR8oUDepujeZnV1PtcHCahmpScFH24ynMezpMPC702Q+vHoXKRwDi6W5MJkEoVbx
	 c3FYIdYM1rMWUD4LkBqXFhBz8pLo+zvc89WIAk18ilxCNBTv0ywoHSoEqqsN/Or0sC
	 EQ92l4d61A//VQFI9bTm+k5Yf12jzwdQbVXmZWlVYAoRNayPsgNkhQdIR3ur/C2Zvo
	 SbrMwa6K0XmBg==
Message-ID: <b2d0cb7a-15fb-4b29-b86b-795d5b904a9d@kernel.org>
Date: Tue, 9 Jun 2026 15:20:07 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH mm-unstable 1/1] mm/khugepaged: fix PMD collapse swap PTE
 accounting
To: Lance Yang <lance.yang@linux.dev>, akpm@linux-foundation.org
Cc: ljs@kernel.org, ziy@nvidia.com, baolin.wang@linux.alibaba.com,
 liam@infradead.org, npache@redhat.com, ryan.roberts@arm.com,
 dev.jain@arm.com, baohua@kernel.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
References: <20260609120443.71864-1-lance.yang@linux.dev>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260609120443.71864-1-lance.yang@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 4AD8F4001B
X-Stat-Signature: ky1i63h8dnbw6ud5qzrk8stpe38b8h4y
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-HE-Tag: 1781011214-545878
X-HE-Meta: U2FsdGVkX186Trf4gW7JIOYIUz63CsR9bxwQlZ941curbU551iiZNVF/3gBy1R/a0Yi9DngSnapMTz1WlEvaIZBQMgjFx592g2NB6xE8MGBW+8gqzsyQPSj/fnF7E/EmbysCIDAyGtx0BX6Y9zm2XqVmeQ6ry/SrHMPHg62QiX2L1uWlSb9e6OnqQdgtxy/fdly+DZol7Ke38G2Vu1YOAR6uLsuop+wDiEQsArFv7pklev42FP8/Sc9fB8LNx4/X+5XD/uV7clUvvv84niNyJUjQ4aQMTNd1UdlqoVSczUw9Nnyw5jT4mUlVmunApOxG9Q/pg2O8MWJXRhj9Z81PcANL7hpFl2IsE1+iDaBsaeLLMhTEOovtthP5KiHhIup38VaC7iXFr/iMi5dvx9TtE1PJ2x3rl0k/A+U6Uwr7t5W2/PjXXYBsOLEJ4viSgzMfD1HHJ50tExz15D5h4lONiwHdfgZlv8mr9uqg7AORmofEjfLaLM+pSXdFhQ8w8vSoc0uQuLHxoe3JmzX33vF8LOr2lMevkXrTF8vdRR2TWGH1hiiNOJwgPL1R75EUFelQwtOpVIG62g0OZx8mOj0++ArUd0HMGeqRcceRk6Z+a9oWkAr5ox06Q8SwkqEBmcMswHCwYmBrbSEO6oCyjajxPGOzVmxVzHdAiHvBzpeQIGA6HYXJ2vnXwxfto1BwcZKV2g8JIl6PQKeVVqRX+hcqDt/DvqlpeVa6FwaU5p7WciE5F5k07f5nW5Hmoob+3uNxXQOI1t/SDPb7mHA3Q4YE2kzRTEa42Bd6fkViR7dnoRsCC8qFdsSBlVShEyFQhpb2NyNySni8wKS8Mbh0C6eFJB6+Z9vz3exQus/ey6VxBWX7hl9aAQvDzPge+naKIXVeRboGZCncrZjOP3YH/hN1uyS+J6tf0vqAkchlcW2LVNx3XtwnK+CBQbCPK7PKt3DVnm3ayjCUCebRfgs3lRm
 dL9hzTXg
 B5ij5CWUJcmkAHyS/UOO7LWjzlWjaOxcJ0nCr+S7Wx4PI1geFHrAVuDUrk8KtPpu7vbEwsL1YycUypZTubAIeGUm1+xqi76FzySYJnln3H3t8NsFKwKa2lqxlXUIrF+5be2MPpcgANZWzH0lBqhH7JtkAcBAkePRpDBfOE00/owE6R7JedyXHw8nfPGjMdgTsy1OtNIXRS0p+4ZtXodJ4xCWMF7qx+kPqAPDvyXzKY6NPHcNdFJxas+djKXn2nBo9jWcJ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 6/9/26 14:04, Lance Yang wrote:
> From: Lance Yang <lance.yang@linux.dev>
> 
> mthp_collapse() uses mthp_present_ptes to decide whether a range has
> enough occupied PTEs to try collapse. Swap PTEs accepted by
> collapse_scan_pmd() are counted in unmapped, but are not represented in
> mthp_present_ptes.
> 
> When lower orders are enabled, collapse_scan_pmd() relaxes max_ptes_none
> so the scan can cover the whole PMD and build the bitmap. mthp_collapse()
> then checks the PMD-order candidate using the bitmap.
> 
> With max_ptes_none set to 0, a range with 511 present PTEs and one swap
> PTE no longer reaches collapse_huge_page(), even though PMD collapse can
> handle swap PTEs up to max_ptes_swap.
> 
> Account unmapped PTEs only for PMD order. PMD collapse supports swap PTEs
> through max_ptes_swap, while lower-order mTHP collapse does not currently
> support non-present PTEs. Keep non-present PTEs out of the lower-order
> eligibility check.
> 
> Signed-off-by: Lance Yang <lance.yang@linux.dev>
> ---
> Sent separately, as discussed in [1], to spell out the PMD-order swap PTE
> case. Patch [2] is still only in mm-unstable, so no Fixes: tag.

Right, probably we just want to add the Fixes: tag once Andrew moves the series
to mm-stable?

-- 
Cheers,

David


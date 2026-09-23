Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E7356C982FA
	for <linux-mm@archiver.kernel.org>; Wed, 23 Sep 2026 13:09:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 059CA6B0088; Wed, 23 Sep 2026 09:09:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F25E36B008A; Wed, 23 Sep 2026 09:09:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DF0BE6B0092; Wed, 23 Sep 2026 09:09:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B775A6B0088
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 09:09:06 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 48031407C3
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 13:09:06 +0000 (UTC)
X-FDA: 85245057492.05.849110E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf23.hostedemail.com (Postfix) with ESMTP id 677BC140008
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 13:09:04 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="hqT0qz/7";
	spf=pass (imf23.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790168944;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XQwnEEJJ9KivuXOXOPcFUQjvPID+bTdoFJ1xTtN2RfY=;
	b=DhX8eYm6CSNuLuUnx0dm5DCdJlLZctPsvG3eKqq/tz8ji0dIu7vbqfX/vcQxnZYI0UyqRS
	jeaX85PfXpksrUFOkPSfvAhAbpnMH6Jno6cBS5Nf5kAV2ouCxDQlDlXUnTOmJPR/s83fms
	d+j3/E3aX1+E6lej+W/XJtxXEqZSwNw=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790168944;
	b=pyIJPTPpn3k61bnQ+bSPglr25T0zcSRpYi5tyD1Lvq04u8si0CR+nv69oiuebytjBNplFK
	ObO54jVtTRonTAiTzt6BtOuOLMvLZKrbcQCES+EIs43pQ5PD4EfnxJvB53DKQImehWdIw+
	QOn4cUEIgHygmh036dzk2eedvmBSvTM=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="hqT0qz/7";
	spf=pass (imf23.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 8D844433C1;
	Wed, 23 Sep 2026 13:09:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DBDCA1F000FF;
	Wed, 23 Sep 2026 13:08:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790168943;
	bh=XQwnEEJJ9KivuXOXOPcFUQjvPID+bTdoFJ1xTtN2RfY=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=hqT0qz/7RjZjaIE3DfxuDW+Q0hgAZC0uyOdtIEc6zILRmwB9MY9YYa2aFmOCIfG4b
	 kT97EwsI1B5oXFDCzJlORDRDio7YYz3qspDWM3GJTTrn9C7u9CbovVvYGGwxjY4yff
	 zzQcDTAl7dC54ZrW8ujG9GdWflmw8hWqYNa2N0IREMio8fn1UjoaKnt98KOTNI2J9P
	 1TJk8Qm4dWMOXJRwA1qqkVOSEHYGVh/yX7tXUPq/KKnXIIha1McfY0eK131/Krh/bA
	 auOhovusMqeyXk3+/2abXa/bXkldqcpMferAGEl9zZc87BE0gWFkW48vt7uoqsDEoG
	 GX1tCKkP8bdTQ==
Message-ID: <0b421935-d83f-473b-a21a-e7f29f8585e3@kernel.org>
Date: Wed, 23 Sep 2026 15:08:55 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 09/12] mm/collapse: open-code collapse_single_pmd() in
 its two callers
To: Kiryl Shutsemau <kirill@shutemov.name>,
 Andrew Morton <akpm@linux-foundation.org>, Lorenzo Stoakes <ljs@kernel.org>,
 Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: "Kiryl Shutsemau (Meta)" <kas@kernel.org>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, kernel-team@meta.com,
 "Liam R. Howlett" <liam@infradead.org>, Nico Pache <nico.pache@linux.dev>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Usama Arif <usama.arif@linux.dev>, Vlastimil Babka <vbabka@kernel.org>,
 Jann Horn <jannh@google.com>
References: <20260916093145.4022188-1-kirill@shutemov.name>
 <20260916093145.4022188-10-kirill@shutemov.name>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260916093145.4022188-10-kirill@shutemov.name>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Stat-Signature: ni1xd68eywzb4k4ctzwwyq8uykf37o76
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 677BC140008
X-HE-Tag: 1790168944-289710
X-HE-Meta: U2FsdGVkX1/jlTAsK/45IkQH9cSHGh+0YWQ3CW+wXtTRF6MI/yw5lWh9To7GY2ByEyiiyD+FR/jwMTuKJ9woXa2ReY0CtxRoi8eKcmcFYYCucyIsqJ/5+Ox95HNA/bcMvxgE2mxQlI0Zw9yxZA+Y2HEFr+ocoYbyRBFQ6RVhFEJ0Fpnh40F114O/ePWtM08Cu5DWG4rkmJJ9TP5UVOGKulzWxfSSNiVu1ZQaGAQ1EhigfiKQd/8a4mEEfqZW01TXvOrec/CK3SSBk2lzSvg0ZLGElNsiFLnz5KhG2UV9FzMkXfyS8G/gAUnl4ad8D/SEq7CC1ASlGkkrta/9xfg4oXEgvkABhRTIO5bJjwbEhKqbo9CAibcHZOlfAi/C4VmEqPQCJT2zdWk3CEpigXwypckv0YaabGAQo5E2HQeM0AGPgwkY40clNYXMYKfoll52p3LpeC99cPDhKbaGN2O+57gk8+fUIq2QFWhHGiwLD5On6aZjERleDHUzWqIB+IcbD4kwxakGGZ2ulpqAWsR/8Vt7E9UFquCkpbB9islxqzFhcIW5DfOCd7rrlhqMkZT6G5IBqNaYQVBiuLwli7NEC1Ur0gFcLLQtUNDMeid/+SOOpxemlcSm/4svuwatJxs9dvkHAGPwOFkToxFi0VsEsAtAetXii9ugpLc724pXulxQL8Fmy5sLsNggfRvnkvFgaB7Op0FqK9hc+FbUbAsbZ+KnOLH49GU9AnIrxM9bE8wQuYAxJPvjv9ejSYxIC0TEOLadWj7pndfPDyDL4DPoPb/BCcfrgWsvSaIsOn1D5zoRXA1+N29/CByb02w4jETaSlLJPAB32Yds3ONmZ72FMma7W/wqjJOJsmXIq+EO6ouvCETkirUnzNYrqUNNFfhlXeoVtTsYWzoCsM3E/f7CkPaubk3gWB1rseGyIFNloQ4sj0+7Qv7ntyCE7NsWyY6z2PFT+wy7oXS16bNyyMs
 SFc0xW86
 gl4YMnrd2fMVeZXgKa1BF+237GLpTBpDYeg07jbYdwj6yGKiCRJqWHTD6geERzA1iqWxHgRVtxpIWYK+/2uA6XihyzGvX/078gIpqx3SOv+xACCABDts6geLbZZfAFxZ3o4GtmRaJIubwFDSpcGlXc9Cyygu5uol8L1nMD6m5GT4Hq8SdDKqxeqlWzyVuAWE8QhiMBNCPJ0X6wWHeZDeluXhIprLEbMP9Fue862H8BqMAI72iCt3E9xQJjDf7PRqHFK+NQEWDTL5xG4uu51+88FB2dVEE14NGwvshO3brGJY7e+sOAfkfJAYh7UvsedjnCEHYyZKd0Fm5ojI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/16/26 11:31, Kiryl Shutsemau wrote:
> From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>
> 
> collapse_scan_pmd() and collapse_run_pmd() each have a clear locking
> contract.  The scan is called with mmap_lock held for reading and returns
> with it still held.  The collapse is called without it.
> 
> collapse_single_pmd() kept that boundary inside itself.  It dropped the
> lock on some paths and not others, and reported which by way of a bool its
> callers had to carry along and then act on.
> 
> Open-code it in the two callers.  Each scans under the lock it already
> holds and, when the scan found work, gives the lock up before running the
> collapse.
> khugepaged's lock_dropped and madvise_collapse()'s mmap_unlocked both go:
> the code dropping the lock is now the code that wanted to know.
> 
> khugepaged's walk carries on to the next table while the scan keeps
> refusing, and ends once a collapse has taken the lock from under it.
> madvise_collapse() re-finds its VMA after a collapse, which it did before,
> and now uses a NULL vma to say that it has to.  It still reports the drop
> to its own caller, from the line that does it.
> 
> The lock is given up and taken again at the same points as before.  No
> functional change.
> 

I'm not sure I see the benefit. The code in the previous collapse_single_pmd()
callers certainly gets more messy?

Is there some other patches in this series that depend on it or what's the
motivation?

-- 
Cheers,

David


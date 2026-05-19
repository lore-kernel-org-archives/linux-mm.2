Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 81181CD4F5B
	for <linux-mm@archiver.kernel.org>; Tue, 19 May 2026 18:44:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CEC416B008A; Tue, 19 May 2026 14:44:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C9DF56B008C; Tue, 19 May 2026 14:44:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BB2C96B0092; Tue, 19 May 2026 14:44:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A73596B008A
	for <linux-mm@kvack.org>; Tue, 19 May 2026 14:44:27 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 42C7E1615F4
	for <linux-mm@kvack.org>; Tue, 19 May 2026 18:44:27 +0000 (UTC)
X-FDA: 84785044974.28.8BEA88B
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf12.hostedemail.com (Postfix) with ESMTP id 7E6EF4000B
	for <linux-mm@kvack.org>; Tue, 19 May 2026 18:44:25 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=w18nVIDV;
	dmarc=none;
	spf=pass (imf12.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779216265; a=rsa-sha256;
	cv=none;
	b=zpemmpyniEOU1pgIXPVvGEHden1dcQxsCpwx5cUVn2/Y8DieodjCOpuYLMU7URoseZ5/5O
	uOw3MMP4pFbCLLgj5MENGIb88mmJmqYbb41fC1aHU6+5d0HIDvvd0QX0AGI1ev/7Pqd6vB
	A1d8VNr377AwX6jXTuF/FqGWO7cdfp0=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=w18nVIDV;
	dmarc=none;
	spf=pass (imf12.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779216265;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YsF6o4/V9UzeLHz1aYY21U6JpWyGRbWECBzQRYf3Vi4=;
	b=4KWs+zgRMfA6NLBv+mNBqDlwEkoWT24U6qA3593v6nkI2GkmNrUrCCAbgD04BiW4ISp2BC
	eRV0mhI48pyVywZiOkLOr7fIWyJvMMH5iQJMkV00sE7cRfJnLAlyDlSD4fZpcV7tEPIdfp
	TqwNm7Xh42AVTeiiZHRRbs5RdsaA9YE=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id DDE1360221;
	Tue, 19 May 2026 18:44:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65779C2BCB3;
	Tue, 19 May 2026 18:44:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1779216264;
	bh=HK7OYVU9TauJhgu8vXQYjgfa7h9xtWGXH0z3It907G0=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=w18nVIDVydNXS/nY2UaxqYRxpkxdmjQOisHNaec+lmQKf+SjhTHSvI+DR7UTC0fBB
	 eZ0p6//YRQnhl9r4FvIvpP+lBAtNP3DHocQyfJph8UR/zmtLTvgeRuQLeL2x94Lk8Y
	 iczE/DV3BmQ80aFZjLSUCjHYaOt/+/Rxa5fQI+us=
Date: Tue, 19 May 2026 11:44:23 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Aboorva Devarajan <aboorvad@linux.ibm.com>
Cc: Shuah Khan <shuah@kernel.org>, linux-mm@kvack.org,
 linux-kselftest@vger.kernel.org, Sayali Patil <sayalip@linux.ibm.com>,
 linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 0/3] selftests/mm: assorted fixes for hmm-tests
Message-Id: <20260519114423.cf0ff77b970b92e8377cf5cc@linux-foundation.org>
In-Reply-To: <cover.1779090293.git.aboorvad@linux.ibm.com>
References: <cover.1779090293.git.aboorvad@linux.ibm.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: wnr5eqm5y1p91xfjdymdhb9xcdyw16hp
X-Rspam-User: 
X-Rspamd-Queue-Id: 7E6EF4000B
X-Rspamd-Server: rspam07
X-HE-Tag: 1779216265-654504
X-HE-Meta: U2FsdGVkX1/JS4j/29XOb8oY0nQgel/UZjewaFOCQOYENm9vVsNWYKPSb8L8hHFx3ZquzbqY0mDICUsfe0TF1zdiXhL1FzWZ2FJMHvLlxVZKE5aQJ0PMx5hiepslmOBsvym7pSHepVoHm5fmDq/h22AooenkYdnBi0l/EzC9obfKX41zpx8E4P8SfTjWzSvZdRvYOF8hNXziy4ccAlUGWtODLtzZhT9juQ4gi3IxW/3fE7Vg+MlKWXCe/mfgjunOBM01sLAtN7aQyC+wTcALc+fKInlP8U2LBnBJOPkHUQOGehQFbp68OP2ClNWF2ic5iCdG1hrX2EE/IJRcYHJgOr++4P+o4pdXbD33CEhechFH2/gXF2wOFMZ9cjG4Nr7MVKaK2nuz5N3b6jTRjLc3x+K5zgueKoC82X7jKBK3yi0sz6BXJMTm6BexPlo3ct0rAlUNuZt63Y+5N4ytwCyXU/QYUjSm2szdqQBvz7YlgBeN/qTlSILpYQ4dVdRcTCmy2aSMqZT8kFE9uU9TqxRUH6J33JkBQGgcvQWDFGToA6yEI4djAwaFtTUje6C8BfB8Z+gPrHaD2xDz+3su9pCpDgqNMoWjmHZOIPnekMWq4GBPdh47KGgZax+mFRRFwVr9UmxS/woqFYwQJACuqzyMVdiU6ZXOgdtQEJIDwjrhZfslC3CmYm4QB1RqqQnHFZSZOusDDUlMylGUwWGw2QAhaUPun7b6cIGW+MwNg23R7G5c7e7iTWhEnSwAOuupUzrMILOVGvrp1FWDz3SY8OQV41OfZVaFFUPgva2xEkiSFgFRbtbRdfvSL3J06V5ZmmONHNBFEP9k07MYlWnEmcSf8fRVZob7UbAGwFMESjNCLuTEUZEk/qh9V9hq7kSf5TJ0X1nRDru6OPsLXp6S/j+jIQy5T/2+UMbz58C1gY8BvVYf8kHzdkdFfjrsQ5VGLN8jLIQs+wvzCS6zgqSDKmW
 i2nAiNT5
 j0ThtHFNfRU4iL06Zz+Drt/xJ6eNkkfOTXyoBFK+vm0b7vaefTDF1xJR3R+tVyRdrk4z23rzOCr2Jm2WmCsK5eKl0xiDEaR+VxFCQS6T5I4SIcB9UrGRLofSKJl0jeugfgVop7nesoPDTTrLFw1GRiVbWMn2eFlki0ZK1rphk0UesYtE/A69ueq7Trs5OICHewQzSdifG05Rafw3VGZ6+6KaeElV1pAqZYrzAlnNINNo+5+v2aK3xrAdKkCBJWQjr4mup8BfaFcok1cpVYMCuCH13e1j6zyGjWNeq6FI8IrS+K/7y4hJ31I9xHZWa8qmASMSQ7kDdSfQIY1aUjwcl1IlwpF1SYsMoZhm4D68ergPrdktTqhiuht9P74Ud/kX8Ma1KE2PhjP8VeictFcZ3R/a7JQz18yuLlKmEUIn1Ir+J1tWkDOpZ6dNwvlBepzjAfpE+k/fOvl4ehk45pbv/dw0Zy8uFc6g9S/+CIQS2gz0fu0mQa9CUWsXhjpwNN8P6QLf1snDPatPz/efOB9MpbUTzoSULlNlOaN64tCITPiKcDm+c/bUU9gGg+Gb2zOxGYj2aKLhvnSOhViVXjiSniTC4kxzjotD1VckE0mcPuIJmYM0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 19 May 2026 09:36:21 +0530 Aboorva Devarajan <aboorvad@linux.ibm.com> wrote:

> This series fixes a few issues in hmm-tests that show up when
> page-size and huge-page configuration differ from the hardcoded
> assumptions the tests were written for (PMD/THP sizing, default
> hugepage size, and related cases).
> 
> It also includes a fix to exclusive_cow: the test ignored the return
> value of fork(), so both parent and child ran the same teardown path.

Thanks.

A lot of people weren't cc'ed.  get_maintainer tells me

Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Leon Romanovsky <leon@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: "Liam R. Howlett" <liam@infradead.org>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Shuah Khan <shuah@kernel.org>

Jason and Leon, particularly.

Also, get_maintainer isn't super precise.  A scan of the `git blame'
output indicates that Ralph, Balbir, Alex, Matthew and Alistair might
appreciate a cc.

AI review asked one question:
	https://sashiko.dev/#/patchset/cover.1779090293.git.aboorvad@linux.ibm.com




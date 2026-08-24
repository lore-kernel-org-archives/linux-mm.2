Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C65EBC5DF94
	for <linux-mm@archiver.kernel.org>; Mon, 24 Aug 2026 12:33:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E2EB96B00A5; Mon, 24 Aug 2026 08:33:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E02B36B00A6; Mon, 24 Aug 2026 08:33:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D18966B00A7; Mon, 24 Aug 2026 08:33:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B1DBE6B00A5
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 08:33:43 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 4C16216012A
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 12:33:43 +0000 (UTC)
X-FDA: 85136104326.09.702DF5B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf29.hostedemail.com (Postfix) with ESMTP id 8869A12000C
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 12:33:41 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=F+tF29nw;
	spf=pass (imf29.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787574821;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8vpukjlWR+PMzdNZ1W3YPHPHq8x2wf/T1Pima1mpBR0=;
	b=UC6oByuPVcpdya0YaDmlGxul4MZKDWLkAxL/M5COfR2zju1ZxFd9/Ufx0PI59kGuRQoavM
	UlmL05c3/asJ+OCSWUx8BQe0WTjRiXyMUG2N3j1QEO+1VikZ+6LCNT9OzEwOa4Buaur07g
	q3bR5WO87ik8XSY35M+cZcLs2pShiwY=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787574821;
	b=D/e+Dg1PtsusI2HpjD5OElXydHMeMB6ft/9IuOsLJqWzKGQP4zWPx6OA+vpwTTkxrOS+32
	AgG1XebYt9Djm9UonAkfLWHt7bA3SPfOnYBR435P4RGFcmeb65ATjgVO2TcHbyIDta6d+r
	jVw9Dy7EXFZMXMbLD4CoN77zFt/Zef0=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=F+tF29nw;
	spf=pass (imf29.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id DF9AE43945;
	Mon, 24 Aug 2026 12:33:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AEB5F1F000E9;
	Mon, 24 Aug 2026 12:33:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787574820;
	bh=8vpukjlWR+PMzdNZ1W3YPHPHq8x2wf/T1Pima1mpBR0=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=F+tF29nwIuQv1aVvflAgq+bILiTSbnwQ8lYomNjhMzXw3jXHvugTukYJsgcrOFJCx
	 2AQJYKCtezFme7T7wlnjVvZag3Xw1L9zQRdJ3fFmZgsrsi7YKnOrPxgVgU/BGK9QvW
	 +seVY2QXqG0dr2y8oxlc+RcWo6i43OhGsD+SKPdQXzUebhZObFdDPJhawq5Ybyryrz
	 w6ajQkl0YTSQCrHupD2b67JYx3Ogm5bgi+9Zp0NC8Le1g7AWyqeMzI5XeXz6gL/VjH
	 0SHWAVYOt4iHvta6SQgBjLWxjQ0MEaHqB6y6H04BaNryNHj7VPUMaWYE/Lg/J835Vm
	 uQsWWEgDlz6QA==
Message-ID: <8aa0e0c6-bc6d-478d-981f-3e0d5907eb11@kernel.org>
Date: Mon, 24 Aug 2026 14:33:30 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 4/6] tools/mm: move gup_test from selftests/mm to
 tools/mm
To: Sarthak Sharma <sarthak.sharma@arm.com>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>, "Liam R . Howlett"
 <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Shuah Khan <shuah@kernel.org>,
 Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>,
 Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
 Lance Yang <lance.yang@linux.dev>, Jason Gunthorpe <jgg@ziepe.ca>,
 John Hubbard <jhubbard@nvidia.com>, Peter Xu <peterx@redhat.com>,
 Leon Romanovsky <leon@kernel.org>, Jonathan Corbet <corbet@lwn.net>,
 Shuah Khan <skhan@linuxfoundation.org>, Mark Brown <broonie@kernel.org>,
 Anshuman Khandual <anshuman.khandual@arm.com>, linux-mm@kvack.org,
 linux-kselftest@vger.kernel.org, linux-doc@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20260813181230.483746-1-sarthak.sharma@arm.com>
 <20260813181230.483746-5-sarthak.sharma@arm.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260813181230.483746-5-sarthak.sharma@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Stat-Signature: 1eptdmcyax1ru4q9ufwnn7hhiqw3j4e4
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 8869A12000C
X-HE-Tag: 1787574821-439996
X-HE-Meta: U2FsdGVkX1+VCExtyEHm+3w2/Mvh6mxnpoUIwS2mWjZrldP9rPQjFbhwbETUsYUSNFfRXPDOa7mGnWUymeSiTHu1BaUqH5HluiUIeDueg0Ifi6+kvbD2h1aE1dn/KAIoJR67qRHFB8+DlSTrdrXR7MR79mDbl8aTuivzdzCTk13BRz9XQG2sTXG60rIxE5KYZtO4Nf64KRUi5kpGeaQ6hqEgJrX9ppOCM+H4uozGQNjk0ye9MjN1xVWHp1iWyJVtSm7nptXAQNu/apF8U8EW2/D0ikUgZe4sf7pj46zx129WqtU91+241tb2q8irwdxWr9l4uTtTepskJUktY88aKJp4zitLNitVTR1wYNdh4WLeSLyHG49FHZuDc/o7+yRGQIsH/ZT/CjLH1Rqg7S8c/1wQtimM28fVCT47jppbXdNEXO/QmIScJgimbd2OyH45p/P2x5WdB3N/tEeu96tAGsJD2+9UcPEp9dCyrqiZASr/43Io48HE45CHD0EWcjuhiI1zxnQPlVDC2Qw84KwAWWYpZot7YfhQSL4lGPz5f2D8b/FoJfCswyupCsO8oPf+7pQRPxir3Zxp2jZDvxp8csC9VsXujw1ksmb7NH0AzxSTQ0sih7SbAL2eaTGT/jWB/ZR1lCdm6LQMm8La/FTRb30Hrn3jWUmLwuwWGa2NQy0iQ4D2fRJue0nKjf0efV9Ba7gdjnYhYQdOuLHqlx/qedTT16gv1GJT7PNyw3Qo8cALnSQZReZvZIl4IlGVsCZ26/VUBLn1SrCmY1wQb+F+Jw3aoN+OMk/c749vSPNgk44ChJqiRISMo5aKwplhp+xbCfrtceIhIPu65gBT91AYJCU90DiiNAGwnuWfAxBnAvT51tVjI6c3J1kwNsAGJoFuHFr/E3Zcfv05ar9G8HPwtN1yOYuDhEXdyf1roEFXWe1B2cJcqXMmdk8tmCNADDsSqVzBfCLk1XSy/H4gd2q
 4bju1Xxp
 SllUurqq0JN38KAPMrT9KbQrYnjv45/C4cS3Jea/xx825h0LWKvfcWwa+pmCAsq5/CLdKnTdk5ossFet8rCwyu7RaWfIW2GGOjVw4gOl7pVfNBVPb/DHzshduLSR6ntB52oHVw5lJxpKZqZjqgxxyB+sMFoAJ9wYr3phcFt0McJr+kViQGc4tXq7iDeFkqd1lxsRSNKH14sQ4BZrFOnbHtN3yZ5q/lo5PYX8lMOKtfQtA4oFZr6GG8jMKbGJY7cgWp+AcZYHYdyMvcVL88JJsUGgPR7XCIVwv3l2dCjUGbigoCbqrA3HWjzeUkKVx33XKq/yHfB32m+PuPtThD2Qz0VPsXPeH9hzYwuUD9Y28WSvkHAN6U7eaFLEMNPqwKMlXNMkKCMGgr1oEJt0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/13/26 20:12, Sarthak Sharma wrote:
> Move tools/testing/selftests/mm/gup_test.c to tools/mm/gup_bench.c.
> This is the first step in separating its benchmarking and
> functional testing components. Later patches will make this a
> purely benchmarking tool and introduce a new functional selftest
> under selftests/mm.
> 
> Include hugepage_settings.h directly instead of vm_util.h and
> use getpagesize() instead of psize().
> 
> Adjust the Makefiles in both locations and add gup_bench to
> tools/mm/.gitignore. Remove the gup_test invocations from
> run_vmtests.sh and update MAINTAINERS.
> 
> Suggested-by: David Hildenbrand (Arm) <david@kernel.org>
> Signed-off-by: Sarthak Sharma <sarthak.sharma@arm.com>
> ---

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David


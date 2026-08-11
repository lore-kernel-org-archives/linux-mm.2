Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3E0C0C5B572
	for <linux-mm@archiver.kernel.org>; Tue, 11 Aug 2026 15:43:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1D0586B00A6; Tue, 11 Aug 2026 11:43:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1A8436B00AC; Tue, 11 Aug 2026 11:43:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0BFCB6B00AE; Tue, 11 Aug 2026 11:43:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D853F6B00A6
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 11:43:40 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 713991C0C02
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 15:43:40 +0000 (UTC)
X-FDA: 85089408600.16.86E9F5A
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf09.hostedemail.com (Postfix) with ESMTP id AC544140004
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 15:43:38 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=e1FIi7jq;
	spf=pass (imf09.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786463018;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DKom/OlPyx8ZT7/3gM8kilSNbFvpI+ZzFp07AvtIwJc=;
	b=6Knfa1FYmtIwXDCSUcPzpLDAn4BN3rXjDBtX0VFsIKtFDUoPPnveODzaYvRXDrPsN6FvM1
	9B1CXge616ecdVNE4pwKrfT+FYdIq7gUJ6PYFsHZicoQExgxUjAJx995pQGzK2w2suLY6R
	iUhuBEN3o2ETX0fN0dM1AhX/QbejZ6Y=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786463018;
	b=EXKZEYKXnjG/C4AkbqvwTzy5DeozA2EFzaSIeO9sxc41cNcoHxgWTNH55VGaU+yXA+7dXH
	fW8rji4rbYgV2eNsu3kI7S1acovaPiYXlGRJxRh2w+rXORWw2pFCWs2U1veXBl2o4hLL94
	2W27GA0W39LpaiVZx+9tbx2UzuaKKf8=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=e1FIi7jq;
	spf=pass (imf09.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 3FD3B600AD;
	Tue, 11 Aug 2026 15:43:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C31F1F000E9;
	Tue, 11 Aug 2026 15:43:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786463018;
	bh=DKom/OlPyx8ZT7/3gM8kilSNbFvpI+ZzFp07AvtIwJc=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=e1FIi7jqG6CQzdgGuv5mCpItbPaSeX4LbBTzWN6ECSYTtRVp8ED2a5nuOZYGrv+Gr
	 DN1ojBQPWKqCQCOuIdPwnQDxrYV8MIj0qvMnccMbo+sdrBfw7XCw+QG99JNRO+x6Sr
	 Q+HroFpYkTEwJTQOcgAlNUcUsLeSz9XEhbTxfc8NJAOg/YkjdW5+PHPVXdsWwAstA+
	 OvTjzTRKHICFwuHO/WNdmVrMlHqfB+vvX8OcfmJy7OM4Fc/rYAiNczLCDizE/kvWsT
	 q0GH+XYonuEbulNmK10tbTIYtIdsXAQeSm6XF7ATZKmAFUb0g1dHixKwne6rYDxeHe
	 ExvtrXoKryj7g==
Message-ID: <cb189211-d139-4eac-b4f9-ceceaff52704@kernel.org>
Date: Tue, 11 Aug 2026 17:43:33 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] selftests/mm: thuge-gen: fix test_shmget() for PAGE_SIZE
 check
To: "Mike Rapoport (Microsoft)" <rppt@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: "Liam R. Howlett" <liam@infradead.org>, Lorenzo Stoakes <ljs@kernel.org>,
 Michal Hocko <mhocko@suse.com>, Shuah Khan <shuah@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Vlastimil Babka <vbabka@kernel.org>,
 linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
 linux-mm@kvack.org
References: <20260809-selftests-thuge-gen-fix-v1-1-1919f4b3d12f@kernel.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260809-selftests-thuge-gen-fix-v1-1-1919f4b3d12f@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Stat-Signature: hhoj18yqjq9idtbyh77djqamgb3dxpc8
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: AC544140004
X-HE-Tag: 1786463018-380825
X-HE-Meta: U2FsdGVkX1+NV7HtL2uwKUF7J+tj9VmWh5F9VzqJo/3DihnjyFQvHiucZc998Cu9yk/fRED7su0dJdDncn/U+dj8cRGh45qFrUzyI9ygcqnf9oX6Q0h0Q23/oqJG19T5xwG/EkQXLGNrP+fBIrS/QLzVt2cSYBqvhI7xXT5eD6boaBKpRAhuBD5FhIXYdeVwbBHreIZDtujOOX1EWP+xNHUYtXUVyb7PVRt2nbLgBOYmS4V5EIaT0hgOVRK5jwYMWcbJNThn3MxrIPYy0SIq6ga0+KNCRvyNMbASoxMRU62EnPgrxTpelGgDYDajK8lwxdU/fn6GA07DO0pfktUCOVg/Dzhd3nguXx8pxFZHR0xU2quZB8vmhs6gHy4fj2NJIx4e9bFpg9gvLC4How4Q0SXds31jMVu8mjTZTdgaFv1+6DDp82WLn1zr8uJfXzSwyfnLBwzMTj8DRYukBBRuZlVm1ZSN2WKeWtWSCwuA8q0yzjt95ygS0jcxFm7NFienhmxIdwN6Lules/l7HcDdCj80tiVD/1+Uou6y0kMf4hxTr3YTiWXYdhNgrVRPS9I96fJys95bHCHfy4mN0eMyRIK4cKsh6gK4VYrC6jieu2zD8fs+pcIjVVFldjOQG/adgMcG2uBoS2eMbCtXCzmrdunyq+Ts1z0Qj8IjN/GFRdWp9Ouhf3wfxLhzPNRK9avbeKvX9FCNYAzGym9OlfIyb8qsXPfZbvYLHzveVKXSHtefh6p5ZI3x3IXIrvSOdMrV+2TA7dPFBaK7weia9lPsJN5bcNmOGlkWbR5gW2gRAjqH5F/H/RBXG6ZMo8XIk82W8xEQoU1DCWIhFIefukbNPApsflWfXOWeh3Ombmo/y12n3OJGiEqzh5l/ydZhMQLsvz5vxdVkfJCxu3UWIgmvQ/z27H+8BtQTMPyew1ZgkMb8OVc6buAeK+EvMMmnh25nZQMs4tL044L0vVaN4BP
 iz0xjqhG
 GyoSznQzToNuGq8Zl8MIk+NodxzSxPkdrFiadb/10jSuTF12358DkuWG1c8h42kVOU/WToaxF17AyWVtkIs52HR4GgX8FHdOMSjIv5nIHV91L79Wmyz23unZDXSM34mw51UDbJai9CDW8768yAyN5KDdeFXFzZzEAweHSXNwYrlL+Q2dt4kDLeQKeYlQ7pNcjQN8KLq2YOjeQnjeoLlcGaXiwam6YIPqrRWDjbWDmg7T6fFf0LY1subjuqAP9GJuSt/PBmifbGd71hEjAfZocBeuakbXPgrecyAKv+RW7blHEzG1cgsDGwr3nC1ocbL25atmcg937WjhQBCU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/9/26 10:03, Mike Rapoport (Microsoft) wrote:
> Commit 49a4e7186b08 ("selftests/mm: thuge-gen: add setup of HugeTLB pages")
> changed thuge-gen test to use common functions for reading hugetlb
> attributes from sysfs, but it missed that the original read_free() function
> special cased PAGE_SIZE tests.
> 
> For PAGE_SIZE tests, failure to read sysfs was ignored and read_free()
> returned 0.
> 
> This allowed test_shmget() to essentially skip the check of how many huge
> pages was consumed when it ran with PAGE_SIZE.
> 
> Commit 3199b0c09efa ("selftests/mm: fix read_file() return value check")
> fixed the common read_file() to actually return error on failure and this
> exposed the issue in test_shmget() that checks the number of free hugetlb
> pages even for PAGE_SIZE test, tries to access
> 
> /sys/kernel/mm/hugepages/hugepages-<PAGE_SIZE>/free_hugepages
> 
> and obviously fails there.
> 
> Gate the checks for free huge pages on size != getpagesize() and initialize
> before and after variables to values matching PAGE_SIZE test.
> 
> Fixes: 49a4e7186b08 ("selftests/mm: thuge-gen: add setup of HugeTLB pages")
> Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> ---

Heh :)

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David


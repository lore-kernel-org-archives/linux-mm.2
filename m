Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F1271CF256B
	for <linux-mm@archiver.kernel.org>; Wed, 19 Nov 2025 09:17:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 57DE56B008C; Wed, 19 Nov 2025 04:17:28 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 52CD86B00A2; Wed, 19 Nov 2025 04:17:28 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 41C0A6B00A3; Wed, 19 Nov 2025 04:17:28 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 2DF806B008C
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 04:17:28 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id CBFE758B58
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 09:17:27 +0000 (UTC)
X-FDA: 84126803334.26.329007F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf26.hostedemail.com (Postfix) with ESMTP id 03531140015
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 09:17:25 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=r1eviRHi;
	spf=pass (imf26.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763543846;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6Y5kJQVbOla5fH5duGClMNZK8b9PMSU4r9dncswVtoc=;
	b=qjyO75qasjlztEvjptZhDBhXZrXQvbp3tGSklqT1K0vTspOAP0oFEPi24d2wQZ3xoU42s0
	TZErjG0eKe34IeHZL/4e+JQORSRmUxlzXkE0MqNeCJFGQx9kpVYbGSVpVnO2HRTQmuYHW1
	RPJGZSB7GlDzwJZXlIiNf9OIT0wEV7Y=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=r1eviRHi;
	spf=pass (imf26.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763543846; a=rsa-sha256;
	cv=none;
	b=E8WlwmNo7Cyp8HYPQ0Wb1y3UaY5PDLr3AnFgUTbAJ7z9kgegiQODtxeOuKIMy9bSwIqSrg
	9KppN17/hd/durHZzJwdmHFfc8mMS8EtQNzEoqgHDRtZgcxi7q+v2bQ4VLnW2h3xyWQZmk
	CkUo3eVMpitMck5biyf1sWqSOX3CG9I=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id CF46443B21;
	Wed, 19 Nov 2025 09:17:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72CC8C113D0;
	Wed, 19 Nov 2025 09:17:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763543844;
	bh=+ffPga0iEGIkgs/2Wyne8l2+b7HCliT4lHlAANtUKP0=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=r1eviRHifDhzFR62Rl4Hl0Fldbxi2i1iUnRJ7++2aGuq32uA+sAcMmBxT7j5wcxja
	 Dr3ZCuEdjdi8uHutObrIAwF0D3hmur8+G1xnxQFbAKkLNL4iYe27x5IIXBJBjwF3Xn
	 rMjfwIIGVLgiU6ulekobGpCWlb6zkHltfsa8SzERy2qg6tWRTjshCJLTGPZ6wuTwwQ
	 OCQ9I8WFX1h1b3KktdQHU34zpodV9N9zEu3H1biShZL/3tZAdlnkgltMswqALaTjxE
	 eX9ysZSrrbzj1mt2R0c9c7jXa5m9WR8iNE2m/RO3JX7xMzNFbmQ7RIqHovhYcsURJu
	 lOX2pHSd5VFlQ==
Message-ID: <dfba107a-21fd-4439-ad6f-bd8a976fb232@kernel.org>
Date: Wed, 19 Nov 2025 10:17:13 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 5/9] mm: introduce copy-on-fork VMAs and make
 VM_MAYBE_GUARD one
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: Jonathan Corbet <corbet@lwn.net>,
 "Liam R . Howlett" <Liam.Howlett@oracle.com>,
 Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Steven Rostedt <rostedt@goodmis.org>, Masami Hiramatsu
 <mhiramat@kernel.org>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
 Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>,
 Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>,
 Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
 Lance Yang <lance.yang@linux.dev>, linux-kernel@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, linux-doc@vger.kernel.org,
 linux-mm@kvack.org, linux-trace-kernel@vger.kernel.org,
 linux-kselftest@vger.kernel.org, Andrei Vagin <avagin@gmail.com>
References: <cover.1763460113.git.lorenzo.stoakes@oracle.com>
 <5d41b24e7bc622cda0af92b6d558d7f4c0d1bc8c.1763460113.git.lorenzo.stoakes@oracle.com>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
In-Reply-To: <5d41b24e7bc622cda0af92b6d558d7f4c0d1bc8c.1763460113.git.lorenzo.stoakes@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 03531140015
X-Stat-Signature: 7opkq6ms9esi7mxpyeggcsrdazjte9uu
X-Rspam-User: 
X-HE-Tag: 1763543845-860622
X-HE-Meta: U2FsdGVkX18aRjoTeR+b5FoVeMWv2YB/UGDgYlsluci4UxkH/3K21BcBwfGTQ2aDU/UTQ+OYD0I7KZ6dFST0UR7MEpWCCoF+x34IasLfoNqDXL7PU2MO/TrcrX+9oQwdtvYPLrRBqYzpfc054oOWPH36wZsl+hnuJXFVOxLWYnSle3kqIim+l0lPaRKNzwlkyhevT+mpDJbIHwFq+VxJz8a6aI3UwRkYIC2/AuShca/vdYU9ofikMxY98R1R2BM88KsRwTp1QaP05rSkc3BIAdNxxS9CpmgKopB0XUAZg+HRqAD6tL0vEEJIkkAmlxl2nS3Guo/ccybb9mI/bpmnz8fA14kNhLfm/JuQQ7XJEpy3z2eatnxhNXw1NGFIf2J5+aN980Tbq01EZRx5ws8Gxk3m57KcC9sc/ru94LTuM7HPuParcTWkcIfz5m7fGBzP3MRb5R2fs4xsaCK+k74gS5PpnPscvZjMF+Zjzr41sFCA0WuPVPmN5z8BOaclRG7PJkb0ZbyAbFUJobXd+4wBpOOSQL1gavr5J5cidv3kI//9pQwc5Mhy9m8QZ5QZC8jMmXnWSQYDTcivuqDKipAkwxzs/BTvvBkg42K4ese0503n9Rn6P2nfcVoRMv89Q2eFVDqPRRpIeW77wtKu59wvUtfLxVPKfKb77XnrpbOMsK788MAyXL8m6KOgNsSsDf+uzYSSY7MBpzZAs5CTGMbBdqQHHpa0zMgdaHLEhOA8P/VBzvNrAKVWzr9XaCgaK7z5lo/8nnspdBXl16bPSsA8GecI2tUODd57UZCg4ALbmDRY2O0MLsfLTT5pVyw77F2M2y7IL4l4LgstB+XnvH2tWuXH+Y0FFVG0oDClGnTIpMsHCgRExqPlEN6LyQFiPvVmbVacDS34tMtz2E8dXPdsEzpRmLA05J3PezelfMP8A53gU3YSecWbluxwbmbRs/Yi2pADyg59q8l8YqRdC3x
 n6BPZeDd
 WD5vnBG+TGpE/gxfnG2DfPfXL2SrKjDA3xUG7XSFpP3onmd4R7LAZyHjz8fV4OvYD7Fyg926bp443BwfSSvqXAsbAYYP1brKOh+fyREeeRmzvaRgts+bj+jYNRq6BOZNjs/cJZDfp6rKaI/ook89hQx07HStunNcjl/01pXWdqUUiYl/v8XElNUkagI+tpo1ZxvajCCPdI+pHDbm6CrAeEXcTHAihhWfN++TDemHcQLBBMXmA4XtxlxqZRLtYHTBtX4yt5vUWz1wbQZyCbowRm7kL0N2Pg41EsOQhfXrYFYteJYnNtSZcsaQ+ldMhAzTnJtraV7bvl0aQw/3h+mO74nzXAEtaE8AbdvN9
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 18.11.25 11:17, Lorenzo Stoakes wrote:
> Gather all the VMA flags whose presence implies that page tables must be
> copied on fork into a single bitmap - VM_COPY_ON_FORK - and use this
> rather than specifying individual flags in vma_needs_copy().
> 
> We also add VM_MAYBE_GUARD to this list, as it being set on a VMA implies
> that there may be metadata contained in the page tables (that is - guard
> markers) which would will not and cannot be propagated upon fork.
> 
> This was already being done manually previously in vma_needs_copy(), but
> this makes it very explicit, alongside VM_PFNMAP, VM_MIXEDMAP and
> VM_UFFD_WP all of which imply the same.
> 
> Note that VM_STICKY flags ought generally to be marked VM_COPY_ON_FORK too
> - because equally a flag being VM_STICKY indicates that the VMA contains
> metadat that is not propagated by being faulted in - i.e.  that the VMA
> metadata does not fully describe the VMA alone, and thus we must propagate
> whatever metadata there is on a fork.
> 
> However, for maximum flexibility, we do not make this necessarily the case
> here.
> 
> Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> Reviewed-by: Pedro Falcato <pfalcato@suse.de>
> Reviewed-by: Vlastimil Babka <vbabka@suse.cz>
> ---

Acked-by: David Hildenbrand (Red Hat) <david@kernel.org>

-- 
Cheers

David


Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DD895CD8C8E
	for <linux-mm@archiver.kernel.org>; Mon,  8 Jun 2026 07:14:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1D6BE6B0088; Mon,  8 Jun 2026 03:14:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1AE0F6B008A; Mon,  8 Jun 2026 03:14:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0C3DE6B008C; Mon,  8 Jun 2026 03:14:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id F1C1D6B0088
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 03:14:11 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 6848D1A0995
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 07:14:11 +0000 (UTC)
X-FDA: 84855881502.05.1A93165
Received: from out-172.mta0.migadu.com (out-172.mta0.migadu.com [91.218.175.172])
	by imf22.hostedemail.com (Postfix) with ESMTP id A27EAC0008
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 07:14:09 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=rHBdi2+z;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf22.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.172 as permitted sender) smtp.mailfrom=lance.yang@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780902849;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=t3DfQ5vwWCckZGkA87/DSfdL+GVPQKWQGnRbRGwtS94=;
	b=6CD4Ou4IeGFRdkndylXet95K2J4kG10NpPejkDDid5poyxoQNzlLjdAu1emU7UWYK1WFL5
	/OUv8dnMr3KzYhBWLkSdATTDCf0Otq9g7L7QdVNwgDkOoM9e6BD+09sc5tpcL88mPx/13T
	OPjX9JgeYOiYtrHUudnSRO7DUlCPUo4=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=rHBdi2+z;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf22.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.172 as permitted sender) smtp.mailfrom=lance.yang@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780902849;
	b=j3tcqpwbfK7jguoVcXS/pjLP1O5YpyKZxUlygJjHXEb7QLdh2/doXZy1X3p9vaY7zxRCKe
	vO/SRZ4p1ncBTrSDdbRK3wPcG4QDUrGzJ+6i6r9Eq1pKw5PFwt+o2d0Gqot+xM85QrrCYz
	adFD1EXpjtIPjbiCZoxN1dBhNs07cN4=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1780902846;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=t3DfQ5vwWCckZGkA87/DSfdL+GVPQKWQGnRbRGwtS94=;
	b=rHBdi2+zew9CwX9JzM5CIi0bAAjqQd2xi3+2yfyULKQaqBBpfay7Z6/nK5Y6px4dq86NAt
	H3KNQz9QRnC3ymTmBRIrbdi3ShIKJibCXsKvCwwJdBfGnNZG9jvrXc3IQb6RkxXPpB7Xlm
	pdcWF/RCLj52b0xE2Pdn+dpnpyCMK8w=
From: Lance Yang <lance.yang@linux.dev>
To: npache@redhat.com
Cc: linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-trace-kernel@vger.kernel.org,
	aarcange@redhat.com,
	akpm@linux-foundation.org,
	anshuman.khandual@arm.com,
	apopple@nvidia.com,
	baohua@kernel.org,
	baolin.wang@linux.alibaba.com,
	byungchul@sk.com,
	catalin.marinas@arm.com,
	cl@gentwo.org,
	corbet@lwn.net,
	dave.hansen@linux.intel.com,
	david@kernel.org,
	dev.jain@arm.com,
	gourry@gourry.net,
	hannes@cmpxchg.org,
	hughd@google.com,
	jack@suse.cz,
	jackmanb@google.com,
	jannh@google.com,
	jglisse@google.com,
	joshua.hahnjy@gmail.com,
	kas@kernel.org,
	lance.yang@linux.dev,
	liam@infradead.org,
	ljs@kernel.org,
	mathieu.desnoyers@efficios.com,
	matthew.brost@intel.com,
	mhiramat@kernel.org,
	mhocko@suse.com,
	peterx@redhat.com,
	pfalcato@suse.de,
	rakie.kim@sk.com,
	raquini@redhat.com,
	rdunlap@infradead.org,
	richard.weiyang@gmail.com,
	rientjes@google.com,
	rostedt@goodmis.org,
	rppt@kernel.org,
	ryan.roberts@arm.com,
	shivankg@amd.com,
	sunnanyong@huawei.com,
	surenb@google.com,
	thomas.hellstrom@linux.intel.com,
	tiwai@suse.de,
	usamaarif642@gmail.com,
	vbabka@suse.cz,
	vishal.moola@gmail.com,
	wangkefeng.wang@huawei.com,
	will@kernel.org,
	willy@infradead.org,
	yang@os.amperecomputing.com,
	ying.huang@linux.alibaba.com,
	ziy@nvidia.com,
	zokeefe@google.com
Subject: Re: [PATCH mm-unstable v19 08/14] mm/khugepaged: add per-order mTHP collapse failure statistics
Date: Mon,  8 Jun 2026 15:13:52 +0800
Message-Id: <20260608071352.77428-1-lance.yang@linux.dev>
In-Reply-To: <20260605161422.213817-9-npache@redhat.com>
References: <20260605161422.213817-9-npache@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-Stat-Signature: 8gaktrdp9aniqksh6i7mp9mhzk5haq3y
X-Rspamd-Queue-Id: A27EAC0008
X-HE-Tag: 1780902849-657853
X-HE-Meta: U2FsdGVkX1/JSGKTZFV0Tn1U1rFfcneGX4B8nSebpKC8tRpuGpb7OR/b1qQiW/jXodAecF9JgOX5KJRAZoor1BVYHPrVnLa+4r1QMgwehiuk4/iAsN+TR6BiMIxJIoxEf82TOwjaJaPAzMTAJ+hxSN59XtKXo5MKxRbtJNgom0n8BrIrrzLy0yc/yTt5WvoG5BB9jGgYreSrfDUxS3W34QTIm6CMAsy8Ux7ZWkUuwUzFbEvJZt9hAxUqkiLxG8INpyKauaOOIZOov30YkU2OaFXLNIT+Y0uocVi6j1eM3KiH8BPfl1XFJ/h3OUGeiuXXcWed2SSXFNFyhd6S7OnOiMeZQEv0dMlkvk/RyYg+cOVOnCs1pQsARg0Y36G1OWQzJPnSiu6Wcwkb2ibmJjnNsRvfP2VivrwfdEyG7UdvPTw/moCAhS1ndGozECCFmzxqhhsOIBrcs1AlxDHv8HG0Wi/lu18MWqxULfPADp7cNXzdHp6m3lxnOPtREOdY+RK0weIVVwUn/6VCXzHeZyCUcLqZFnUodB8YBjR4sCxnP2/SHO+3mN/za6jWRWnNFbJ+VRkYlcaHnvBTqgsRsSmLF/reMUZ7dJeQMVc3UVHRXkM4ow5QWl5GBZxD9lMbbUXYb6nC04VzujOhj60d9T8EXgqj2ICzK5EjuKXTHkxma9GpyNN9ybr/KUCFFXZ+HOMQVmlhkcoaSU4KEA9GnqT4xopkFpEwoBKk3BnHbH16yx8YbupuErCPnLvC8sI3r5SULwe9C44b9GM32NctTSTWVypOaNUDX6WMLxkIhQoAFoofH6vwe9yQR4POVAG7WebsETYgjPHTD/4aJFcrxEmG1yx6UgPv52HEfwfWRxP6z3Pzid9O3N22N6LXtoRKSYYXKwCg0lEWHWpiurJRJ8CcAkFtGuAUOyG+U8Nwl87UXpK5V18qEi3l4rCJUMURK1KruxFy6fnVshYPCt2gAKD
 SSYVAzhV
 VGm083Ax5O/bi2riM2KD7X4BikvYJKQVyXo+uYkvQ3PDe573lEMRbUi67SMPEPTlbBLksoL5Ed2TAnAhpeBWuOSRL1MXHn5+utRese06uxjo3+TSkrGXx3NOiRG6kPgyX8Fqb98yqPsKGNdEor3pCyj6upM3f3iuHNA7YbTbHJmOIWEv/iXz9RL/F46iYpJv6d+ZriIlkt0HWDsGxaI/Htn1TCKCKee5Qb4Mf2yfLA7acL2X3AbwMZDrHiPR2jDqeHRJrjdhdxZCRqUvNCXPD3m6JEZmU9rvlMmTr+eI012I6NMAPdCdjwE5Gu9oVS9SbIxRWuRbjXbrFTng=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On Fri, Jun 05, 2026 at 10:14:15AM -0600, Nico Pache wrote:
>Add three new mTHP statistics to track collapse failures for different
>orders when encountering swap PTEs, excessive none PTEs, and shared PTEs:
>
>- collapse_exceed_swap_pte: Increment when mTHP collapse fails due to
>	encountering a swap PTE.
>
>- collapse_exceed_none_pte: Counts when mTHP collapse fails due to
>  	exceeding the none PTE threshold for the given order
>
>- collapse_exceed_shared_pte: Counts when mTHP collapse fails due to
>	encountering a shared PTE.
>
>These statistics complement the existing THP_SCAN_EXCEED_* events by
>providing per-order granularity for mTHP collapse attempts. The stats are
>exposed via sysfs under
>`/sys/kernel/mm/transparent_hugepage/hugepages-*/stats/` for each
>supported hugepage size.
>
>As we currently do not support collapsing mTHPs that contain a swap or
>shared entry, those statistics keep track of how often we are
>encountering failed mTHP collapses due to these restrictions.
>
>We will add support for mTHP collapse for anonymous pages next; lets also
>track when this happens at the PMD level within the per-mTHP stats.
>
>Reviewed-by: Lorenzo Stoakes <ljs@kernel.org>
>Acked-by: David Hildenbrand (Arm) <david@kernel.org>
>Signed-off-by: Nico Pache <npache@redhat.com>
>---

Reviewed-by: Lance Yang <lance.yang@linux.dev>


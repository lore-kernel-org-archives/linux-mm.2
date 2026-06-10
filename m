Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A0AD2CD8CB2
	for <linux-mm@archiver.kernel.org>; Wed, 10 Jun 2026 12:44:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 95F5C6B0005; Wed, 10 Jun 2026 08:44:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 936BC6B0088; Wed, 10 Jun 2026 08:44:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 873CF6B008A; Wed, 10 Jun 2026 08:44:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 76A436B0005
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 08:44:38 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id C4B941209CB
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 12:44:37 +0000 (UTC)
X-FDA: 84863971794.12.7907C8D
Received: from out-171.mta1.migadu.com (out-171.mta1.migadu.com [95.215.58.171])
	by imf17.hostedemail.com (Postfix) with ESMTP id 8292A40002
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 12:44:35 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=gGAqpLHi;
	spf=pass (imf17.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.171 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781095476;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Hoo+J3C19/L3qqtvBUInYcwgth59RiEZ8NTdgfJnZfg=;
	b=0GFsv+Wuc48CNmE1fcqZlAnMt+GRq15BlF6rbUDZej6mKrqodBuEzk6y/zwKgohSrdHyg6
	qx3NeNJ1oLqC0YNMcG4kDgGr/Hyi/iL3JXPu8h3wCmoV7Jl9Sq6ttZ7fzFxbPBuo+vGmLb
	VGzuaIbpDxVsgQG89qanKzpuyut4uGo=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=gGAqpLHi;
	spf=pass (imf17.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.171 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781095476;
	b=2xtBRjJlGpZbZ+dUekXsvaiQYWpUZOR9JfGg3LdmLeZLcu8/iCDpgpgF5fAtDSuCzY4WWE
	4DZai9nI7XrHnicczd9ARqddaxz8TPzbV2ra4VwaiqiXVBbHqiRRgFRWKnQzUtJL6fmUWn
	tWyagQOMkGE5/C78hYvhsoWlwS+l9ok=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1781095473;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Hoo+J3C19/L3qqtvBUInYcwgth59RiEZ8NTdgfJnZfg=;
	b=gGAqpLHinpWJJIMY9244f7levClY2JlKxqRaam3js8ZUqYdvVO4BzvoMjdo4PEpMe8f/ik
	LTRhPWwq8lfm05w/iNz+U1AZIruvpGtRJqHjB01hEPWOt3adL6p4OCEYTREl2g/rO0Co2M
	kBSmP/e/a6a0S3mU0msPiGnFlH+lcgU=
From: Lance Yang <lance.yang@linux.dev>
To: baolin.wang@linux.alibaba.com
Cc: akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org,
	hughd@google.com,
	willy@infradead.org,
	ziy@nvidia.com,
	liam@infradead.org,
	npache@redhat.com,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	baohua@kernel.org,
	lance.yang@linux.dev,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH v2 04/11] mm: khugepaged: add shmem mTHP collapse support
Date: Wed, 10 Jun 2026 20:44:16 +0800
Message-Id: <20260610124416.46522-1-lance.yang@linux.dev>
In-Reply-To: <3895c09794739bbfae99d9e021ffacf8a51fb8e2.1781083630.git.baolin.wang@linux.alibaba.com>
References: <3895c09794739bbfae99d9e021ffacf8a51fb8e2.1781083630.git.baolin.wang@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 8292A40002
X-Stat-Signature: x4pjruinfnsz8r41tisom46c6pxx3m3o
X-Rspam-User: 
X-HE-Tag: 1781095475-241105
X-HE-Meta: U2FsdGVkX1/9oxlDbxXyOHem6kFInJWlLaUsJWCc3lRizLMypy/Llpflaa+iaREV1GO+/7X49vjc+H/NOSxQiEVnrhnQTSTcDYfO1D1iV0uSzEBCrpnUNOdwl4O23stOPwdKjZjTmX6F3g6S533AYRJi0fPrvfhrRPCLoV/xQvlkZSdPxe3d0XVGezoLIpBQGNUz0CXTspwmhQBwQd02t9rlkQsaEgI8YCVnKvlNuwJBtzArMWzRgo50eAokvhwJpMGpgv2EPh3g3oTyrDCVJfxNmgnz8F3anIXV6nloqo4Je1vlaWOUD+nhkmUV3Sj7gu8a2vXNkMj3IZdg3NF48sv0x49wCmMww5T4wWDsU8FOf0dakU/087H/D7Z48NvN0W6pcFBb9VNoaJFNGRjbgae5Lmx+h/cbufEsnzh+F5CcQ3RDwysH8dh7rPnZEqNNlxad88JjaBEE/RKsOCamKxuLfIEZuyujBEOhamGZWqR8jmzN8mOBCV04e2PutUA+2MJPxxBVFtf1MrRvMtaVgoAi/HOhgo7pzl/K6QwYWk3dpu+7T15O2mmP39pIbl6WfuC2x4hw+z6xuO211Gjd9YjITGzADLlSZ4uVaIbg7EK7K/5HHxFs4uMt0Ia3hw60pRyKe3NQV0NPG4Ov7Jzr8Jq2TlzFmQkvYS+/rQI4jChj1+xiW199YoeSPH/g9Tj09X3vcuXdXEl6t02+Hn/PDOJysjkYMSlBaQVxvWFkC2JkISPZBx+TJ1zEDuLLwMgJqfOk434AUwp60wEBxVEwJXQ805535B3VwAJ9TdfwnEMuJLpcY+aM1UR/bpEZZnK8yPqXduCtLhn1Cq5YLvSjuyRTa+7V6f0fKw6AxKgYubJ9WO75vDO72eDs4g7mfYO3a8z06XQsqeOrRt+mkx5QvPxu/n/jiXh3rXeLeSWtefNNKqkaZXgvDvv6X3B3+Hq20EDZRHOiNg3g6MPe89p
 GQ8Dr+W2
 7UGptz1tfNOG79yYTnIs6vkWrhMXfuNwnQrw2EcuunNZpp1UDk2TUfxaCHnaWycTFV9LxNFuTLPWZfVVxkKfxT88WwYflI04l6vDw9pG5DZU8L9RNSXb09KZkVCLyUgZ5hsPmSsBz0Jbx4aPEOZH5soGAceGLuzSKMWSAX0+RijVdwdI8wze6GLmlLR55XEpBvyGl3rCt7sI2bk4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On Wed, Jun 10, 2026 at 06:29:12PM +0800, Baolin Wang wrote:
[...]
>@@ -1512,8 +1517,12 @@ static enum scan_result mthp_collapse(struct mm_struct *mm,
> 			enum scan_result ret;
> 
> 			collapse_address = address + offset * PAGE_SIZE;
>-			ret = collapse_huge_page(mm, collapse_address, referenced,
>-						 unmapped, cc, order);
>+			if (file)
>+				ret = collapse_file(mm, collapse_address, file,
>+						start + offset, cc, order);
>+			else
>+				ret = collapse_huge_page(mm, collapse_address,
>+						referenced, unmapped, cc, order);
> 
> 			switch (ret) {
> 			/* Cases where we continue to next collapse candidate */
>@@ -1521,6 +1530,7 @@ static enum scan_result mthp_collapse(struct mm_struct *mm,
> 				collapsed += nr_ptes;
> 				fallthrough;
> 			case SCAN_PTE_MAPPED_HUGEPAGE:

Looks like SCAN_PTE_MAPPED_HUGEPAGE from collapse_file() get lost for
the PMD-order case.

Previously, collapse_file() returned it straight back to
collapse_single_pmd(), so we would run try_collapse_pte_mapped_thp().

Now it hits mthp_collapse() fitst, and that case just goes to
next_offset ...

>+			case SCAN_PAGE_COMPOUND:
> 				goto next_offset;
> 			/* Cases where lower orders might still succeed */
> 			case SCAN_ALLOC_HUGE_PAGE_FAIL:
[...]

Cheers, Lance


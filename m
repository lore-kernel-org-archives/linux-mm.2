Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 88883CA5FCB
	for <linux-mm@archiver.kernel.org>; Thu,  1 Oct 2026 10:46:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A6D0A6B0093; Thu,  1 Oct 2026 06:46:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A1D876B0095; Thu,  1 Oct 2026 06:46:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8E60D6B0096; Thu,  1 Oct 2026 06:46:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 640F86B0093
	for <linux-mm@kvack.org>; Thu,  1 Oct 2026 06:46:12 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 4B4D3140370
	for <linux-mm@kvack.org>; Thu,  1 Oct 2026 10:46:09 +0000 (UTC)
X-FDA: 85273727658.23.FF6FAA1
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf28.hostedemail.com (Postfix) with ESMTP id 96F12C0002
	for <linux-mm@kvack.org>; Thu,  1 Oct 2026 10:46:07 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=VqH35c14;
	spf=pass (imf28.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790851567;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2BR3qjzOL/B8brr80lOm9esyzvVoYxCmAhj9OkzWhEQ=;
	b=Z4kzCNHqf8JQWlkOc5qmMD1vmNW4nOI/1a67vuRdnhQNPHBL3LZGUU6i/0Sp0UbnnG6wgX
	24fGqGIIJ+B8cW923iYz9dnRjGegLQntNkjjXcPLG+Bvc32rI0qTQNbiqler3chN5Pifkm
	SwgPPIrkuZbd0Lk6QXoPblJgydXAlJU=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790851567;
	b=l9DrDuHM6EFBvdvQ9MsjAoPPCWH0xuhJFYhi2sXhnhIsZsU+OCl0FtlieX14RisOI4cvW7
	ld1wdF6y3gJcQMV4R6XCb4WKPLdLu7uJW8AIW3byhKWG2yCdoomCOmfe/FVZetRqm0g+wu
	f8RCnXe4R/MjIT62d7KANakHEwYtHSk=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=VqH35c14;
	spf=pass (imf28.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 1DD6960A58;
	Thu,  1 Oct 2026 10:46:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A85B41F000FF;
	Thu,  1 Oct 2026 10:45:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790851566;
	bh=2BR3qjzOL/B8brr80lOm9esyzvVoYxCmAhj9OkzWhEQ=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=VqH35c14ovL8IJGd5/WwWVjA7l4NKoUsItEhIHqB0YXU4ep8K/XOKm5wXVO8NM2fs
	 +4WHMc5yy3+3/4o/Yz98MDbud32Pq1hEBkpUQEu7NXzGQjTHUkgbYd58hWSEpxGt8E
	 QawgvkJ1doULaIOGg5hq45wwWHsR+9HsY5yQJb9da93xEuRsmMbWp4BNa3XBP9W5t3
	 RdwZipRLsHWAi2OC+KDUTefq/gN9SpCvKYD48eWL+fnLQfjj19VlFn42FAk6GMqNLr
	 aICqGdrbGi69k1GKcZgr/npbR07PgnxsvKhief4wBPFqYN0N/ErKNJdpVZk65A+MnB
	 icTal2n9XS47Q==
Message-ID: <2d57ce00-1791-45f2-86f5-dff29bac3d03@kernel.org>
Date: Thu, 1 Oct 2026 12:45:54 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 7/7] mm: use VMA flag helpers in NUMA balancing
To: Gregory Price <gourry@gourry.net>, linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, kernel-team@meta.com,
 akpm@linux-foundation.org, ljs@kernel.org, liam@infradead.org,
 vbabka@kernel.org, rppt@kernel.org, surenb@google.com, mhocko@suse.com,
 mingo@redhat.com, peterz@infradead.org, juri.lelli@redhat.com,
 vincent.guittot@linaro.org, dietmar.eggemann@arm.com, rostedt@goodmis.org,
 bsegall@google.com, mgorman@suse.de, vschneid@redhat.com,
 kprateek.nayak@amd.com, ziy@nvidia.com, baolin.wang@linux.alibaba.com,
 nico.pache@linux.dev, ryan.roberts@arm.com, dev.jain@arm.com,
 baohua@kernel.org, lance.yang@linux.dev, usama.arif@linux.dev,
 kas@kernel.org, joshua.hahnjy@gmail.com, rakie.kim@sk.com,
 ying.huang@linux.alibaba.com, matthew.brost@intel.com, byungchul@sk.com,
 apopple@nvidia.com, jannh@google.com, pfalcato@suse.de, hannes@cmpxchg.org,
 shy828301@gmail.com, osalvador@suse.de, raghavendra.kt@amd.com
References: <20260930112206.205083-1-gourry@gourry.net>
 <20260930112206.205083-8-gourry@gourry.net>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260930112206.205083-8-gourry@gourry.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 96F12C0002
X-Stat-Signature: d8adb33qp3rphjnh99kcegzeqyrw51zk
X-HE-Tag: 1790851567-781929
X-HE-Meta: U2FsdGVkX1/FbwFeAaLRqIE4C1dn/7E2DIYrwqEPeJwxICvjOh/U0W78gZ3b4L78J3aLqevY31CrSA2qcre/xVP4Z0d0+N9x9twrKDP4rEK8yZQuFUMBItTDOlBkslH1z+GK5bUvgHgZSbsWsBamAuur/lwC/cATcLFxw4i8UPxIzSK/h6hdr1LWE2mzSofuE7wZHCwptzv6Y0SPxgFd7fY8Ym8E7SXpf3sJkI9uJHqcLAKn2NVSo33Wn6RrTL4Vx9+IJSUiFpnq2u976CaHB8y0kDVtjEW4yNjls+QyZIZiW3zMi5BfUMWdwzm0xhCr1mQDBnIQevlqzbnudmNtRn8wPLUzF52NtxAI1jc1TIXWQZf0ZJrxv6QwFu8rq/5RSEOKH1sOF/mA346IjABe/YzSCzUsoKpAHKvxQuGUsPl/fwyQOkzv0hmv5VBLNU3RMn6bRzxP6f3e6TlMu25qSQcNQWUQqpjTcvFrqSSc3owOxJiRg/L3+WlW/8WfMpJdUMfQ32f/PCbhbc1FOTchhlO4XPft407hYmZVjBDSbINAeVF2e7kn1K8lXOaqyzl+XQyKIEldrybtb/YBcFHMnyTG8La/hHAQhRKTyKK8JF5x5rgMQ1BIjoMbQ7AvY7AF/Zcm9YTbJtzGEXrEPDL6/fNzC+15Zfswpum78Zk8e4hKBOJrnzICTOfX3IWcGQ6HvPLDvisodmdNFBH+cvoq7amudHsAbD9NIZvX5ZmClIpFwIUEFEZmfwEfwif9cCPZFsjx4HGgQSzWaxzp38mlQP97lqT4c/SqnRoVPYcNbaa6RFvWdhwNab66D0Sn1VS0pCl9GrWlozSy2jibESzynMfAmRgc+ir9ZNRu0y26aWfQIcNorSEjEHN/889CHXd8mkQDFJKjp8J6K5uw6ZaCKwH3LC4OYFcBuEgLcVmOvukq84sqvIADN0R/Ika7dBq+DOJt+EiuVW1HGUlptyT
 3b3xFogm
 Cpi8CwvR7J/0MeWOdhsCokQqxaxTAXfS+aUwd3JeFY5fMWqXIsw0k22BEi8u7ohExwqMJP7p5pZNEg+oDW2+JGExQrbtMKdWUTUrMSogEoY7PI7QucZDONWm/M7bt67zBacYkHpNLO7fStYfBUy8GhtaHUVd9VO0ux8P0fiKwPLaWpQ5NRJ1K2X84OLzLaPALlbYHS25DW4XQYFENQ8YLLL7GxCVge+FdWeKIUsQCsnI+AFvvuuOGLrJ4bRdPVJGqAK1hBhfvLyoznrSIIHQ8sZkMvRCfXbPb8C0M5CDi1ckcWebtrEwtctdiXYR8AJdzH1096ba17kktkHrWQ2xpO3yiESBvGOKG95If/MVBcIl39lTxbR6/vf9j/aK1LBuhG2eyicjbyeMbWQfQmGwftEck+vpmdL9yc6WZ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/30/26 13:22, Gregory Price wrote:
> From: "Gregory Price (Meta)" <gourry@gourry.net>
> 
> Use vma_test() instead of accessing vm_flags directly in the NUMA
> balancing code touched by the preceding fixes. Keep the existing flag
> predicates unchanged.
> 
> No functional change intended.
> 
> Suggested-by: Lorenzo Stoakes <ljs@kernel.org>
> Link: https://lore.kernel.org/r/aq1FDhy00epXXtgd@gremlin
> Assisted-by: LLM
> Signed-off-by: Gregory Price (Meta) <gourry@gourry.net>
> ---

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David


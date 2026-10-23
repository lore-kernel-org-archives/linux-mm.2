Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 28E21606A31E
	for <linux-mm@archiver.kernel.org>; Fri, 23 Oct 2026 03:39:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=c1xS0Vgw
Received: by kanga.kvack.org (Postfix)
	id 395896B0AD4; Thu, 22 Oct 2026 23:39:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 36CED6B0AD9; Thu, 22 Oct 2026 23:39:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 283166B0ADA; Thu, 22 Oct 2026 23:39:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 04C096B0AD4
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 23:39:38 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 8E143C0130
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 03:39:38 +0000 (UTC)
X-FDA: 85352486436.07.76858CA
Received: from mta0.migadu.com (out-177.mta0.migadu.com [91.218.175.177])
	by imf27.hostedemail.com (Postfix) with ESMTP id 73E5740004
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 03:39:36 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=c1xS0Vgw;
	spf=pass (imf27.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.177 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792726776;
	b=59AeEW7ry7B+LkGWy0+KaYu9yBXPxfHktsSXq9zPTJ5yhOxDVEnoPrxZUp+m7cihWsKUPA
	TrIYi/24UEggZ7KKS7MuAZGFgU5DLdBSUsKzMSrcCDDNJxe8nrQcFQKQ+ICcig1hseoEfz
	KIX1PddBDIfqSk7Sh7lbWssrc6oAkgA=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=c1xS0Vgw;
	spf=pass (imf27.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.177 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792726776;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=h/PHKf5VXGtBGoIbL1o/q0Pk83/Oxg+wK+aNGJFCCa8=;
	b=zsfUsyPz3B4C/r8DWg0kri3xMvZL0n+g4MbofIfe1lTo4AlIH0j/69eXCM7aUnv5l1pFZM
	6rAkTGHuRJC+6GyNJFzWhwtzfBLvs8VccRouwxSc6cJHtXZTQM7y9R7/UBIyR+JNIhnnmK
	9I2Ciamhacqj8pQbLU8rQ06dh/jVnzc=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=nyUYoSOqOuJuKO479lHIb4LIHOAdbHMHCwHUsDvcPhs=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1792726774; v=1; x=1793331574;
 b=c1xS0VgwSmIWJCeXR1Taxdhv1AQZQAN/vHNT33C7Hb1gPxcM7mlXtCRT5/+fwadj0MRzcwh0
 jG8WnZse0/fu9e5AgyUckxXFoE9aCPHwvyir+c16a6qpqSCQoVlJvw7UaKI+aQddTUUjB0INtrM
 Y3PS8yWDwld7/sVWFLzkc1Ss=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id b7fc172a1acb4739;
	Fri, 23 Oct 2026 03:39:34 +0000
X-Mizu-Trace-ID: b7fc172a1acb4739
X-Migadu-Flow: FLOW_OUT
From: Lance Yang <lance.yang@linux.dev>
To: songmuchun@bytedance.com
Cc: osalvador@suse.de,
	akpm@linux-foundation.org,
	rppt@kernel.org,
	qi.zheng@linux.dev,
	lance.yang@linux.dev,
	jthoughton@google.com,
	david@kernel.org,
	muchun.song@linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 09/12] mm: hugetlb_vmemmap: make vmemmap optimization folio-oriented
Date: Fri, 23 Oct 2026 11:39:27 +0800
Message-ID: <20261023033927.35704-1-lance.yang@linux.dev>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20261020115824.823278-8-songmuchun@bytedance.com>
References: <20261020115824.823278-8-songmuchun@bytedance.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 73E5740004
X-Stat-Signature: sddhrxn5o3i1c67uez4i5949n9wcwukt
X-Rspamd-Server: rspam01
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1792726776-439847
X-HE-Meta: U2FsdGVkX18SVQZ0CoL6EhuCZBzhaEjheqqafrGqnKsxcuOJzMJN0xjIjxkQfvHHncsvPq8eD69MC6/8+ZIaZ1pa8z349c3UaaoVf3xp5cUrlBQCR70LMBz0B0jKbAyAH/wRsz9DGJJiae3Wefs+ds8wxYKEs5qdQX/slWFQZ8msoaWceuF5fxL9ORbPuQrDGVPQ9se2WWsZEGPfJL9VgPuHcwgbiy9yOvcl+yDvcvYfmtKlGCMPCPaUBv+S4/iWeJOYPfee/OozcXnTgfllsF0RmYn786LcUN45zefquLpnN+6xwIwwniWUbIzOfKGQzJBfHg4f5ulUhv2AvNHKqE7fX5qnVBHZDYGPT2hRquY6h3mVT5oYpKV5MmG9IP7O0Q3nHzz94fUYgC9mQk8G5ROwg+RXE5eEIMng8g10NPo2CYxl7ZhKwfblIsiYHn1sGzPRy7Q368zwdvifs5/GrW5u+Zb39RRcQ6oWyVDAPwbmc4oMvGkutSvwhrWYffZpkVFIj9/Q5TcHgQgmTEXzICyypu6GE6KYTIx6JZBKfTFK+IF5KrqsKSMYN+JI9ANON3IGaJzasR+XIoRNA7HcaDwNGABK9pGlEtrecJ5YSBlsxUov9tVMjUja1zEhvGg/pTUW/i8wmOxrsjYQtFrRXKUXNj6VPxWgS338hi6uV+SbzQwSVrE6AhpEIR77BUL/eBC0Zk6t/Lh9Vhr1na4BgE37hNs6Q0g5LRUR5+7ZxL+T8APf958ic6NkjIGElyx3WwdxQMcwWMns5aWcCh2BNowEKFnQ+xXv26dq4DTrcon6RYNtx8OFI8wHjd7oKWxTPVDUpEVI28TITNynnTzfpxm5SPYfM/M6hPW9aJdrz/BL5fGuwtW61agNAPkjUPIoQlMKH//yCF2fsiyUIZioD5fpxnJr7dbyKqsBpCB6dZ/NqxIEEPsEWB3cEL5J1KuhsO9dZuSbGsAKepzduyI
 wJPO/Dzi
 vKY9GCefYSMn9Eu2FCpA26bU0XHcCtHyEnoHZsaaKbX/2aiNfqou6xLzWSqmSr0qy9HXHutT8aC1+1pJQ0rX2voF7HV+Y7wxMcKFRHtlvdTlu+soKgzLTEDup5lYJwCal6I/xCT48Fah7S16OzvcYUEeKmUa3IfMIOFMyhhI7gp61GPTFRc7lxmzPnz/aJxdZP/LbGQscEu5+fb+tiEtOxwccIndjyxj/3j1Z730fkweNnjnVOEqpTM3viuQe1oS3vC4vEh2ZpSvlzjjFfGqOWOALOrkYnipoFowg5/R5XRrO3M2516T1WcoZwg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1


On Tue, Oct 20, 2026 at 07:58:21PM +0800, Muchun Song wrote:
>Vmemmap optimization operates on one folio at a time, but the current
>interface exposes a raw address range and requires the HugeTLB caller to
>prepare part of the operation.  This splits the common mechanism across
>layers and obscures its natural unit of work.
>
>Make the folio the unit of vmemmap optimization and move the common
>mechanics behind a folio-oriented interface.  This keeps HugeTLB-specific
>eligibility and state in the caller while making the remapping code
>applicable to any eligible folio.
>
>No functional change intended.
>
>Signed-off-by: Muchun Song <songmuchun@bytedance.com>
>---

Cool, I like having the helper work out the range itself. One less thing
for callers to get wrong :)

Nothing jumped out at me, so:

Reviewed-by: Lance Yang <lance.yang@linux.dev>


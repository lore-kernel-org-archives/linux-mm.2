Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9DF47C5DF85
	for <linux-mm@archiver.kernel.org>; Thu, 20 Aug 2026 14:34:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B84676B00A0; Thu, 20 Aug 2026 10:34:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B35106B00A4; Thu, 20 Aug 2026 10:34:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A4B2F6B00A5; Thu, 20 Aug 2026 10:34:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 86A416B00A0
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 10:34:32 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 25550C01AA
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 14:34:32 +0000 (UTC)
X-FDA: 85121893584.28.1A56483
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf07.hostedemail.com (Postfix) with ESMTP id 958F440004
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 14:34:29 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=OGAzrRdC;
	spf=pass (imf07.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787236470;
	b=pgyW1CrgC2bu18SnQBF5CX7NFNt+3ppGWuDQcWPwZ60paSnFIfqEmpqcYiLsF8ApK87JNw
	On2apCJWmTCEukKumUPc98FMRuPgyr1KkIT5cIhHF4G/5nGrNw8w2Cje3iHHuM/BzeuVK8
	qjhu4/urrcSZw5PeXXpOlBdlwoa1tRc=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=OGAzrRdC;
	spf=pass (imf07.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787236470;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nCGTkrhWrZIb3xeP7v7Rxd5y0edHxQjkXYTyHj37cHM=;
	b=yK0DEb06QdRVhQIDoxXNRZwJU0pam9wP/YV/EHablPd7/k/mv4i8dER13tYs8DN97nlR+j
	Fxtjx7RUAKPybO0w0YDmNOcLVjoFkIi+1ZNzVOQGYVUxTD5cj6JVJ96yDsMf/klpsXzEOX
	NyFMlz+sx3aIa/79lsRjFqE9LBTH82Q=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=nCGTkrhWrZIb3xeP7v7Rxd5y0edHxQjkXYTyHj37cHM=; b=OGAzrRdCCfChHnOWwapbj8AxD9
	CFPWYhncrfUEBMlQp6wUJ+ivIuTG1uNPGw06HgclZIORGuI19uaZtxwjELcOviTT7UQ7aHDJIegWb
	Fh794Y0OvPeZJElYsUXNYLpMMPRSPKAg7oHLxl4CpalsYTqf149MTv28vGTtZrOfi9Wul3XsLIA31
	RxY2q5ajyE9nGGTzYdcQ6HOD30Pub4B84QV36+zeApWGkUGAeUPCPW+ro+tpngeKzN9wGHA7Jr4Kn
	nTCtGxlNek0010kZLJ+BaE4sH2ku8BvWMONqVQpGDYLUIElnFY4PCP49pG5egWizhqQsOgMJbgCnQ
	LmXcCHjg==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wx3qc-0000000FoVj-07RA;
	Thu, 20 Aug 2026 14:34:26 +0000
Date: Thu, 20 Aug 2026 15:34:25 +0100
From: Matthew Wilcox <willy@infradead.org>
To: Wenjie Qi <qwjhust@gmail.com>
Cc: akpm@linux-foundation.org, jack@suse.cz, linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, baohua@kernel.org,
	Wenjie Qi <qiwenjie@xiaomi.com>
Subject: Re: [PATCH] mm: filemap: tighten dropbehind completion context check
Message-ID: <aocQcaMMU7-rfn3e@casper.infradead.org>
References: <20260820142956.1414337-1-qiwenjie@xiaomi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260820142956.1414337-1-qiwenjie@xiaomi.com>
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 958F440004
X-Stat-Signature: 9mgxesd4f7ojy3b8u6khuqrnr9557bit
X-HE-Tag: 1787236469-785071
X-HE-Meta: U2FsdGVkX1/kB3zQMeEiv4qO1jp6B7pBLv2O+Iq6Bk2hTr6vOnbxFz4cZ1EbYlvMYYz1eu+LBOkOq4quCNGH6ayNtIv6+fQMeKvj0CrYBjz3ORF873AQ8obD7c/XhrwSYsmffgl71p5x5BIz6Is8Yas5SF8U/YfqCdMwJkZvch5pqCEHCwTXMfL3AkdK3ldl/fZikRTUyMZCXnFJ3VXSg7NzMvyYjYgUb47S90pfpwqKGhXmXGjF27xtDPtX8KhtTu1ld5/SoncnNzxyp0e/b7cqpp01AS+rEWP1djHAm4c2nsmbWgqW0LRtVSI2IIZeupHCHZUXFDb5wWKorxoeQsSLg0QHnlqTIQlxLHKhUIgmFiGShT0rmY8nv+2+eLNAL59o83w9UlDsrmf7ubRpl5zYPc8AfO1qrgP4duufYWbrAbLvVst+ccAZC265W/NsdhvkTQCnnr3fdFxQah1v+lY24BUVOL1ziCfnWnaLEgkxftAQRDEe3kXDuZTRXoQWab+kirRLOkI+y8vwA5In7lyTDdZ9O1nGicOQRC6H8NKGVQgethARXv7e7vmE0pD40lMvCIhBT13zyVJr4heyTCWPjX90F55RHRom9gC2F+m5AJH1v7mjlWx1qBe7YrmHouGrVr+kBGMXHp7MEtU+Zzn1ZFsv2qaS1NedVadygwL/UoU5NkWcEsuJZDh2yS35JRy4YBc1qeOKO4MplJozklCJ0s0MGIIM9aLdNZo6pfb1LBizczzh7e/AB9rJaGt6z901lL14Y6oy77+kmreQuOiW8QelhghFpfCECpisvYr+Nm9//EhL86BKhJzbzNrGA954OazhMjSWVcALkfRjV/FBPXmAgN9VXS8zkpV//MELZbl3WuWIlkkMxtUbK60Kvag60yA40pGjxeYMsgcdDAekuF+wMpRQzrGzcZXZPAgb0o1iz7zbz4gKXanv3fnmiKDdHJmK7+zMklzLscw
 DbRq1bMq
 tbtzVxENRB1J14QDy4Sl9ISk85Eshe2a/7kK0YrJ3lA4nid1uJHLEPeQazWoDudUdoITn+dXZFLG4KsNjN31OUhWx2LwfWw8MiuINtzEKzQXQSMXu8aqL6R0CvI5klPqJyGB1RO6NXhGDIwL8x5x5SYL4VuCZzfKPgkppUxJwwSoqomhmkzAGrMWU1jFayWbFuZELs2SnWRnf22RgdRuLF25h/5mzJq3bvnnH0xfaQtbqx3EOMcMn/dxoPxYRB2lUKvP2+UPSRIQR2Zk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 20, 2026 at 10:29:56PM +0800, Wenjie Qi wrote:
> folio_end_dropbehind() uses in_task() to keep folio invalidation out of
> interrupt context. Task context alone is not sufficient: preemption can
> still be disabled, or the task can be in a preemptible RCU read-side
> critical section, while filemap_end_dropbehind() may reach
> folio_unmap_invalidate() and sleep.
> 
> Use the established conservative three-part atomic-context test: reject
> preemptible RCU read-side sections, reject configurations without
> PREEMPT_COUNT, and otherwise require a preemptible context. Unsafe
> completions retain the existing best-effort behavior and skip invalidation.

Have you seen this happen in practice, or is this based on code
examination?


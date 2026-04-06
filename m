Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 47341F46C62
	for <linux-mm@archiver.kernel.org>; Mon,  6 Apr 2026 17:54:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 24C266B0124; Mon,  6 Apr 2026 13:54:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1FD066B0125; Mon,  6 Apr 2026 13:54:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 112C96B0126; Mon,  6 Apr 2026 13:54:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 038006B0124
	for <linux-mm@kvack.org>; Mon,  6 Apr 2026 13:54:22 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id A1AEDC1989
	for <linux-mm@kvack.org>; Mon,  6 Apr 2026 17:54:21 +0000 (UTC)
X-FDA: 84628880322.28.944B74C
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf15.hostedemail.com (Postfix) with ESMTP id E8FD7A0008
	for <linux-mm@kvack.org>; Mon,  6 Apr 2026 17:54:19 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=K61I7HDy;
	dmarc=none;
	spf=pass (imf15.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775498060; a=rsa-sha256;
	cv=none;
	b=mfLrTxo63cOjqFK94GURayjqYa8oL+KBnmxqMtVyyEZnVCPguRvS//xIlIsyigYCeu5PIM
	MbS35K+fx2/hao26oCIBsm+dKVi4iQKvYtsrzPzhPzmQ3KwyXKsIFfvxIv0kDk80UzRVTS
	af6VIvjR3yYoPthNHZVfuCjQMsmcQ7k=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=K61I7HDy;
	dmarc=none;
	spf=pass (imf15.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775498060;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sZWs/4XaveoPpQeX5L4+wkfkaU/E7x08yQDSu/f90S4=;
	b=XBcdFMysCVBn7r0c7w/vxNPMqW7sHbS7BEBs+o2oPDWgFOZuBnBjw5dmCxwgOjJgh+AkTj
	dQ8hXZx3wvQuttI0BlwpM582xNUA7AMKURycVOAxiY9NOw56Bfd/5YCewCUM7gdzgotiQa
	hzMfVNHcf6y+pZRb5kde6rLm1YyUoqs=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 017A760103;
	Mon,  6 Apr 2026 17:54:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EBBD5C4CEF7;
	Mon,  6 Apr 2026 17:54:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1775498058;
	bh=bJaqfa/gqe5hwOumVtDeoBhAL1x7A6nlQ0A9z2WKb6U=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=K61I7HDy5O7GcGISve4miyGDAiyRNr8PSrYE1uJUq3cKg+RzdTcLuQ4n2sXaWeSK/
	 l9q5xzvMPUduw5G32AGCokoXyk3bIGihJtBI0dQE4wU9xq0C9I6ENYIdgz8fwXMZ8u
	 MlxXw8nUNNAWHKWp0u/3U0pEcm//25OMWBNdTEeY=
Date: Mon, 6 Apr 2026 10:54:17 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "JP Kobryn (Meta)" <jp.kobryn@linux.dev>
Cc: linux-mm@kvack.org, willy@infradead.org, hannes@cmpxchg.org,
 david@kernel.org, ljs@kernel.org, Liam.Howlett@oracle.com,
 vbabka@kernel.org, rppt@kernel.org, surenb@google.com, mhocko@suse.com,
 kasong@tencent.com, qi.zheng@linux.dev, shakeel.butt@linux.dev,
 baohua@kernel.org, axelrasmussen@google.com, yuanchu@google.com,
 weixugc@google.com, riel@surriel.com, kuba@kernel.org, edumazet@google.com,
 netdev@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@meta.com
Subject: Re: [PATCH v3] mm/vmpressure: skip socket pressure for costly order
 reclaim
Message-Id: <20260406105417.28fda9587146a011af2fb876@linux-foundation.org>
In-Reply-To: <20260406174425.61692-1-jp.kobryn@linux.dev>
References: <20260406174425.61692-1-jp.kobryn@linux.dev>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 6frfbzq8xa1j6w9hki19an95f33sttdq
X-Rspamd-Queue-Id: E8FD7A0008
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1775498059-819167
X-HE-Meta: U2FsdGVkX1/qhORn6CL5KjIlLOmXpdtQ5jzwM276OFIvrdKRrU57He7lOC3PXsxjcTWCRRtm8FVmwyg7Oa2GdAQ0kC8cyZRUWlXshypKb2saGGdM/K7TlhNnm+Hw14LNxVPiiFs7/A+tL1FFzWexOwdoqANo2KxVB7S51I9EUq/eKLoa0S5dw8Fwj+EycYuU+XAVzQ3+s5Vz9Ft37qPIM+FxcHZ+7/lUMWVNv9L/Y9V068rZ9Lvl5Hk5vdafqH7+KK9gggP4lRmWXoLX1q19XSfcyvYTpBwE8JTtKHldxANJYS/iKl/cYFXJxKKZFr66BsHu5Hn1a9eq1UWVaWibUxGO2m3t3s8MSeJYOeCnniZVdtRJcmi895e8u4xbULezjOTKmetjPK5KIyIKOOduGTz2LEl7DSdqs0Sn3AJeUiOWv9F7SEfd/N95oPiupcEelF9a6Nq52gZrM4KwivjmuUFnEJTUvST5kou9em4DjdEc0X2Q46cxE/EMW+TgOKMt4RuZ2E5NYDGuypm11+e7YODmPn0tpI/Wwt/g7BjbQslNlHoAjpzuBJ8FC4aeKFp1tEVG9L2j+50T4XlE83XwhZ5ROd0Mb3t4ptNtCrGVuajSoD2SXECYU78pg/yiYcYrfaI6hbSO1VqfQQKEfGzroiOlDXaxOixA58KoOjfLWOQj/PvntPLOlYdp0NEjDCBlH3regPpBmPN3u4KCmhyMLWxkMWuL+mKvHYB0wB5QVQfW8sWfGi9G0rgrnglEMBiphuE0xyH2g6NRKveEGoeIO02SAWlCyaCvQtlwWIbzK57mk/s592yjso19j3KsKeALAAf9LtkIsIl8DSFqb64b9NSCZ1hj7Rr91VNKfC+5ZZ49G9ke5BDzAWH1S50KSfu4ZEwBnLHACJ1XxLF0ot2Ygv7X/NCy5qRHQAzShL3waCBkON7ODg4DDzag5MrXpxzbv+8IMT0VKLOmJSwd/r+
 f9zsIjFl
 xoxj8iwJ3N+Uv7kGf/p1b4cuBgPMjcBwJv6VXlJNG8ugQPteJv6mKw8L8kC3YWXc4kyZwKmVEllE/uaankvfL/ZchTNDauvreKvncaZp/0Tp3PB29CghOYOX5p3zwwC9CDQlnFRU3D3zDVpwd34ofxm7A2KOQPDA0W5CiOVvze8OuwyvkZ9DQDghcOCl/eEwWYf6iHER9nImXkTUTnhv5aecXyPv6kKFvprUE5Fy5v+2FJbMoh1xUXnMt0StLNL9/WBjM
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon,  6 Apr 2026 10:44:25 -0700 "JP Kobryn (Meta)" <jp.kobryn@linux.dev> wrote:

> When reclaim is triggered by high order allocations on a fragmented system,
> vmpressure() can report poor reclaim efficiency even though the system has
> plenty of free memory. This is because many pages are scanned, but few are
> found to actually reclaim - the pages are actively in use and don't need to
> be freed. The resulting scan:reclaim ratio causes vmpressure() to assert
> socket pressure, throttling TCP throughput unnecessarily.
> 
> Costly order allocations (above PAGE_ALLOC_COSTLY_ORDER) rely heavily on
> compaction to succeed, so poor reclaim efficiency at these orders does not
> necessarily indicate memory pressure. The kernel already treats this order
> as the boundary where reclaim is no longer expected to succeed and
> compaction may take over.
> 
> Make vmpressure() order-aware through an additional parameter sourced from
> scan_control at existing call sites. Socket pressure is now only asserted
> when order <= PAGE_ALLOC_COSTLY_ORDER.
> 
> Memcg reclaim is unaffected since try_to_free_mem_cgroup_pages() always
> uses order 0, which passes the filter unconditionally. Similarly,
> vmpressure_prio() now passes order 0 internally when calling vmpressure(),
> ensuring critical pressure from low reclaim priority is not suppressed by
> the order filter.

Thanks.  I'd prefer to park this until after next -rc1.  I could be
argued with, but....

What I'm not understanding from the above is how beneficial this patch
is.  Some description of observed before-and-after behavior, preferably
with impressive measurements?




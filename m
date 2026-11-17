Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 81095606A323
	for <linux-mm@archiver.kernel.org>; Tue, 17 Nov 2026 04:27:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=tiGY/6R8
Received: by kanga.kvack.org (Postfix)
	id 9DC226B00EF; Mon, 16 Nov 2026 23:27:31 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 98C9A6B05B0; Mon, 16 Nov 2026 23:27:31 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8A2256B05B1; Mon, 16 Nov 2026 23:27:31 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 6622F6B00EF
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 23:27:31 -0500 (EST)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id CC50B402F2
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 04:27:30 +0000 (UTC)
X-FDA: 85443327060.26.82C481A
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf07.hostedemail.com (Postfix) with ESMTP id ECB9340009
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 04:27:28 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b="tiGY/6R8";
	dmarc=none;
	spf=pass (imf07.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794889649;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2zmCg2Oecp7ztUG+EKti0RUYQInlo6S9bwE8WEcIlQU=;
	b=WpgoZGm21AgHqtYPkQbMAJPjYTuJoDJyQhK13XhGmQGkxqAL3fp1T4oD/udpwmfP7jRX/N
	qxU4do6Lj20xtL19xkImE8miv7IEdTnVvSXambZQv9ghUcqz8xP8XSEDbF53wmGR2Z302s
	/V5CxOywPoRYkYuaSbk+tve/+SbBT54=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b="tiGY/6R8";
	dmarc=none;
	spf=pass (imf07.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794889649;
	b=444x4n6UAiEZ+gXmW74njPEmdp9gj/cj9mm53l+i2vSXPWc3lDS7zei1dOyz+k0nvVWEOx
	a19wLaNey7N2zVxWJHuWt41pohQQ1eHT9pAds5Smx9k2ggEp/VzCdYFsWtkNuVEOLLIr/G
	TvagPD+g+M5yARX+ZOd3D/6yS+4eGAg=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 0F0CA60D60;
	Tue, 17 Nov 2026 04:27:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 571C81F000C4;
	Tue, 17 Nov 2026 04:27:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1794889647;
	bh=2zmCg2Oecp7ztUG+EKti0RUYQInlo6S9bwE8WEcIlQU=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=tiGY/6R88Xv6tkOElYGGFwbeGFw56Z2EvbMoJl+3gqynhYYcvmMNvHPjyJIeLDlPg
	 lccFyWVb8L0IspShQx9GxDurBHXRIvCa77GqslLcfx5ngrAnEWJhgKDgnnvdbVigFs
	 b1VD33rJvReWLpzMlxkCQMWbpYzdOngY/5Klb2iY=
Date: Mon, 16 Nov 2026 20:27:26 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: david@kernel.org, ljs@kernel.org, riel@surriel.com, liam@infradead.org,
 vbabka@kernel.org, harry@kernel.org, jannh@google.com,
 lance.yang@linux.dev, qi.zheng@linux.dev, baohua@kernel.org,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] mm: synchronize with PTE table reclaim for all folio
 sizes
Message-Id: <20261116202726.b6690f9038557df945f8b007@linux-foundation.org>
In-Reply-To: <71980310d9bf1bf9733ea0e4b772635e1b2bc5c5.1794886401.git.baolin.wang@linux.alibaba.com>
References: <71980310d9bf1bf9733ea0e4b772635e1b2bc5c5.1794886401.git.baolin.wang@linux.alibaba.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: q3jjhjsrh6nog3nrjwr4s4quktyz7wda
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: ECB9340009
X-Spam-Status: No, score=-7.5 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-HE-Tag: 1794889648-739192
X-HE-Meta: U2FsdGVkX1/xR3qxAjC9GKA3uwjQ5vJRdpDe/+SydoPOkW1KfTXkTUN/4XcHRblciDfmZ9Vl6o/zUp0PhMACt8ky1sI0gIv9A9IOyk/l6M+CF32XBNfc6DUY8Q6v4C3gwMdpMdHhnaNpV8h6mXi+WwOiG5pRak7PCyo724JMx41E9wG3p91OQAj9AN8xFYfUJAjwZsG59w+aQWhQyO/CxWS+r1bpweBKTJre3Q8yWB1EkbnzIxVM0YhUoH6CxaFn0859LWjzlg7Mb+p45AxvG5jQT/JWirLO9KkNDIpgabYfmHT3XnEyZ5eeBesohwT9cxYkiDckpAZdU8BD1u+uP0P4O5aDl8X9xirswyZiJQUezZifYLnJy2wT6NXRZinNxmKNcKVioHxWYXHAsb/SEwZtIqpEy+ZgHpP/SncvuZ4rtUN2eroWqoH8LqCQO4PfbTYwOclv9s5PjYBPsmyfxNSG8osQ72uK7kxCD/4aBJn94gdef/3Zg5p39qTYGiXNf0hJxDg0oaP9mdgit+fxYoKyTr+8CXJXHzSLWNCClkC1xTDsnd+1CSxIj1WAiW6t9BdzfYGBC/EXS9e8LZXu90MIV1F2sBMm/rwO38lxr79d40EBeAk+Z+WIp9scqMYelvhGh9k0GuImvuPieot+00QQxpSh8HzVXz8Sv+zJnGMXkCN4aB+MoRsnqLp8DFsNToslBVAS49i8cr8CU3FJ6vWaViW/xtjDV8wFMK8VDmenpJX5WIKDxJ89vRumdl8k1jF3r0T6yUCXlwruF4wbf+eSwrW6Ut2rPBMlm7tFYrkfUZbuwj9NRed7gqJT4/81fq1WfJ7epPYLBpmvgYQgCohW0bBL2fp96GvBXoZpZg/KdraAMU4eHD01c2S375/8GkHeEXy3BVNducKPDMS9NaMY0xwA+TRtzww1bx3y8JEFQbFy6mKBp9Vy6yMolLh4Bh7CqgBYOqODy32dEZH
 ZvYAe3Ei
 GDaQhMg/rNoYlWX/O0qbDFmoBIqPb4CUDB0lgN+lJooroyQMj4+YcyrcLL5Cb033h2V4SUFzXpFKTq5RKwg6R1LLo45HSZ4PZ9+Unx6tozxFcZux6ZVGtmB1j4LfmivgrNuUH8sVvt03iAAyeyhlZ+C9ai4txd2jH9W/DOF7SStg2wTD+67wA1Sllyb/VEz02JEzspEPqD5rJsXW2F4c8QfFmTLcnDOYVwN4WXYNa85MwFcCB4OE6EMU47ZPXRhyIjzaGRRjE5A0AOmgFV8yz5L4zbA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, 17 Nov 2026 11:40:22 +0800 Baolin Wang <baolin.wang@linux.alibaba.com> wrote:

> Similar to commit 243cf1f67b36 ("mm: memory: fix truncation removing mapped
> folios"), the '!pmd_present()' check in page_vma_mapped_walk() can also race
> with concurrent page table reclamation via zap_empty_pte_table().
> 
> page_vma_mapped_walk() is used by many functions including try_to_unmap(),
> try_to_migrate(), folio_mkclean(), pfn_mkclean_range(), remove_migration_ptes(),
> page_mapped_in_vma(), and mapping_wrprotect_range(). Except for try_to_unmap()
> and try_to_migrate(), the other callers do not perform post-walk accounting
> checks, so the race has no observable impact on them.
> 
> For migration, the race can cause unnecessary retries. For reclaim via
> try_to_unmap(), the race can cause failure to reclaim a folio that is in
> fact already unmapped (as shown below), which may cause cold/hot inversion
> (e.g., in MGLRU) and increase refaults. In extreme cases, failing to
> reclaim unmapped large folios could even cause OOM in theory.

Thanks, I've updated mm-hotfixes-unstable to this version.

> Changes from v1:
>  - Update commit message per David.
>  - Add reviewed tags from Qi and Lance. Thanks.

Confirmed - no code changes here,


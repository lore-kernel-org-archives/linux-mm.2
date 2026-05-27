Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8802BCD4F54
	for <linux-mm@archiver.kernel.org>; Wed, 27 May 2026 19:39:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 758DC6B0005; Wed, 27 May 2026 15:39:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 709966B0088; Wed, 27 May 2026 15:39:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 61FA26B008A; Wed, 27 May 2026 15:39:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5532B6B0005
	for <linux-mm@kvack.org>; Wed, 27 May 2026 15:39:39 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id EEF6F90138
	for <linux-mm@kvack.org>; Wed, 27 May 2026 19:39:38 +0000 (UTC)
X-FDA: 84814214436.24.C55F327
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf22.hostedemail.com (Postfix) with ESMTP id 356FDC0006
	for <linux-mm@kvack.org>; Wed, 27 May 2026 19:39:37 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=k0WaPiIE;
	spf=pass (imf22.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779910777; a=rsa-sha256;
	cv=none;
	b=i58skzbVRFDV9RGSqsHB/c0PSkkDBhcGbOb7aCY0/ABP7a2eOC4Mk8eu89dBjCMkOu+dc6
	athKda1LWVw/Jm2IlG5uJ2GbO7Z3MaICvAxZxdwN29AG0O6/8TUEcx5kAwnlYh7ulndISJ
	0ZVtL4ddo6ba4oWGuB1KDKvoWOQcz70=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=k0WaPiIE;
	spf=pass (imf22.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779910777;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Qje0s9+5g7mwBQLx6gyz3RzpOX1+aY/PlmzgLifJRzw=;
	b=TIOMXXkn1IyTt2F8deYaVNSSixPfYmnvIyW/Bu9XFuvoVaa6q21QLJl5yWdpYaGsTO1rwl
	GGJwt704PDVU6cFW1I1vrtjHVinza3+L8yJIoGMlaHto92EXRA7RyJCR23bZr075S/2dxS
	4KrNzU+3oXLXUIOmra/2FRn/94qjxvE=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id EF3B0440E7;
	Wed, 27 May 2026 19:39:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24A7D1F000E9;
	Wed, 27 May 2026 19:39:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1779910775;
	bh=Qje0s9+5g7mwBQLx6gyz3RzpOX1+aY/PlmzgLifJRzw=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=k0WaPiIEBwU1aZfVY3U7+RBAE7VXMsxFrl481Ofs/0gzrkClEzhhWW/Af7E23YCli
	 0ipemC3dY0d2opQX7XXgRRYAotjFovhhh4r5uKR3k5z7L+JCzDDk0TT0+UfU079iBy
	 oTL2Y855DeQzOc+E+D7mBaQJDL3axvoPT9QZ0l5w=
Date: Wed, 27 May 2026 12:39:34 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Breno Leitao <leitao@debian.org>
Cc: Miaohe Lin <linmiaohe@huawei.com>, David Hildenbrand <david@kernel.org>,
 Lorenzo Stoakes <ljs@kernel.org>, Vlastimil Babka <vbabka@kernel.org>, Mike
 Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Michal
 Hocko <mhocko@suse.com>, Shuah Khan <shuah@kernel.org>, Naoya Horiguchi
 <nao.horiguchi@gmail.com>, Steven Rostedt <rostedt@goodmis.org>, Masami
 Hiramatsu <mhiramat@kernel.org>, Mathieu Desnoyers
 <mathieu.desnoyers@efficios.com>, Jonathan Corbet <corbet@lwn.net>, Shuah
 Khan <skhan@linuxfoundation.org>, "Liam R. Howlett" <liam@infradead.org>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org,
 linux-trace-kernel@vger.kernel.org, kernel-team@meta.com, Lance Yang
 <lance.yang@linux.dev>
Subject: Re: [PATCH v8 0/6] mm/memory-failure: add panic option for
 unrecoverable pages
Message-Id: <20260527123934.77f789b4ecaf403f0ec6cd31@linux-foundation.org>
In-Reply-To: <20260527-ecc_panic-v8-0-9ea0cfa16bb0@debian.org>
References: <20260527-ecc_panic-v8-0-9ea0cfa16bb0@debian.org>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 356FDC0006
X-Rspamd-Server: rspam03
X-Stat-Signature: xfy83gcpggr8eeguwfgw135pxazbhtmz
X-HE-Tag: 1779910777-248501
X-HE-Meta: U2FsdGVkX1+EXlfojbvI9beeKrw9r97N/dEDnPEbeqlasf0p21gnCYgTWw1C5vGeMJYherFR89wwUdwWBpQS22NZRZQlAhxeb7kzjRFc93Qnyhhguns4NoF/POzt/PDCT/MCQIj3gmSiybgE4t0uK5Iv8DxCyww5ZuLiZS37slCBQjdG8oYcJh+bWwqUZyvH937uoMEO4ANXdqO+DEBTMdtav0ZtcDk4ri+FgvjXc7kzw9Outn/6NR5+Ab7Jk7sGhxaUCe7gqpQ6HTgEG8xS1aZRtMAIYB/VG5McqgC6lYuIw2rLVYRYOhFurto9s6UEpeym4RxYAGzIOdxHnyG7lyAWuxR7FvVtPRLvXjMMYN6jS+fQcUv6bOjO5UOW7XLia8HSTZvhia+0ojamfBrH/Qdj+PWMiZ9e23wTCfu18YSpVOA2W/6+OVmmnJWgQHT3/tdVY1eet0nSFMGiI9q9BURJBdujCbQKj3sTpat4flWzQZfy8SUcIOrqMFwu7rbfXgStDX9YrYZULvMQ6BnzYKcm7ce/fYGppy7rCCL2LO66zbMOaBkpxFhXPWuRTpU061cQ5LmdqD2K/hlG2OwRTEVaavNS3qdfDks9oAvkPMAfygnvb/RMAkTZ9RkfGZdXHC7mbP0pHTlofMnCvu8YHIMOy1M0yMiI7ReAjAiQHmquy5FCFgnoTV/4F2OjRwmIfO0rnCRgQXvTwvtp+YWRUEKU1e0Vi5TRMmaPHKfgG3/f3oHS/RNor5Wf7e2dKw0BWVpD5mldH8TFlf5Z6GlWfWzB9/cK62YRpP26zdT8oxGxLPV7G/vAPVIfDe/tcnQ2NIgQy8R0rHuSio6m0DUwb+KURfGOiuCXsd6SkaPQNusl9Vx6V1ZdlYbrp01dkmrFaoqNqF3RhD08wfGu+H4Mo+XgSsMpKMyQWdgJnsVfRsRsGT84T2n+lIdJhH5NFuH6EKt+JZV0/q5v/QZfYus
 go0pubcD
 ++G6g91ttL8uMU4+MWjhSZkRKCmBxmjxGde4wtB88sjbBrOI0019WidFACragMURhbE16RgJDGAePF51mKh+fE812bKS0q6b/0YtqntUhl/bhFwqc4KKm24YaFKBY1zBUx+uxRUkWKEzvuoIY1yclrRGbKN33RPWxPR9GMqWNvMI4lzT4xyT+bWI+jZBkgO8cIcYvEtE98b4W0EmkJveDI9w8tWCiz0F0W0+FTCkTnpSNrYvDJyGbcoPEUF3QhOF2SnsjnGc8AGpTNHmwQokIrObvT8rSvHeV721XlgOiCV/o12l90OOSjuLYn3HQ+GcA5HL0IAbrqlNni37khNJQplZAOJMktqS8R2ayp/El4LdF4EvUfRmHfy0sGGlDMyaIQip4upLAs2inglcmuCIZvzWF6A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 27 May 2026 07:06:13 -0700 Breno Leitao <leitao@debian.org> wrote:

> A multi-bit ECC error on a kernel-owned page that the memory failure
> handler cannot recover is currently swallowed: PG_hwpoison is set, the
> event is logged, and the kernel keeps running.  The corrupted memory
> remains accessible to the kernel and either drives silent data
> corruption or surfaces seconds-to-minutes later as an apparently
> unrelated crash.  In a large fleet that delayed, unattributable crash
> turns into significant engineering effort to root-cause; in a kdump
> configuration, by the time the crash happens the original error
> context (faulting PFN, MCE/GHES record, page state) is long gone.
> 
> This series adds an opt-in sysctl,
> vm.panic_on_unrecoverable_memory_failure, that converts an
> unrecoverable kernel-page hwpoison event into an immediate panic with
> a clean dmesg/vmcore that still contains the original failure
> context.  The default is disabled so existing workloads see no
> change.

Thanks.  That does seem useful.

I'll pass at this time, due to -rc5 and not-very-reviewed.

AI review said a few things.  It claims to have found one pre-existing
issue.

	https://sashiko.dev/#/patchset/20260527-ecc_panic-v8-0-9ea0cfa16bb0@debian.org


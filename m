Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 06234C83F26
	for <linux-mm@archiver.kernel.org>; Thu, 24 Jul 2025 21:52:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 96ED78E00BD; Thu, 24 Jul 2025 17:52:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 91FED8E007C; Thu, 24 Jul 2025 17:52:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 835BB8E00BD; Thu, 24 Jul 2025 17:52:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 715CF8E007C
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 17:52:06 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id D0293B619B
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 21:52:05 +0000 (UTC)
X-FDA: 83700506610.04.0615378
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf26.hostedemail.com (Postfix) with ESMTP id 42B3214000C
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 21:52:04 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=wOBTkMrE;
	dmarc=none;
	spf=pass (imf26.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753393924; a=rsa-sha256;
	cv=none;
	b=41SEnSLcpmV2pY2K+fQjJiu+vEmvMORWV5eSt4AY3LiKIxDwVxazngzztuXQK9RcwpRkoZ
	FxAaLnHIyoBRowXNlj1uOuvywr+aSuTF5cQv0utUrMMNBlF4WVOZsxZIn8WaKNndyl1r0P
	+3REcxuNLKD9PBGE1PuOMBDiZmyAqRg=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=wOBTkMrE;
	dmarc=none;
	spf=pass (imf26.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753393924;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=o7peTatFtt1CFKjIAMTdNUr9nu8oiwm/yjnFvfva8mE=;
	b=J2+zd91eLjUpBmrsy6UIN7Vuu61FsXp7H7r2bggMSpHK66drDCcV//9d5gv2Ew/qJ2O6Mu
	3ekCtI7/2FuuphSPrzhmryMe4LMiikPDMRxAz3Y0JMTA5VvqXq0vhHAj+6CX/p/4sv/UT1
	rBgo2F+urb98OtaOwj3469He7Y9kQtc=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id A2331600AD;
	Thu, 24 Jul 2025 21:52:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0BA02C4CEED;
	Thu, 24 Jul 2025 21:52:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1753393923;
	bh=5OoEe7SZSPXZs8wT2btyJqWHG+JKmXeljHTTSsOV8iU=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=wOBTkMrEHUl82WmHclcL0OScUCkn29r07y/G/QTwxdXEwaWVPFCPdpJTBULmwO3Ue
	 TwICs8wRfXFYuLOu2HC6Izk8GmBDdLZ2xldi/NmvtRNvUeqf8dQ457NJmmZqAQOanS
	 8/MjVB2Y49HPyHZDBZ8savtZ0rPFPiX+Ap28U/6E=
Date: Thu, 24 Jul 2025 14:52:02 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Jann Horn <jannh@google.com>
Cc: David Hildenbrand <david@redhat.com>, Lorenzo Stoakes
 <lorenzo.stoakes@oracle.com>, Rik van Riel <riel@surriel.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka
 <vbabka@suse.cz>, Harry Yoo <harry.yoo@oracle.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/rmap: Add anon_vma lifetime debug check
Message-Id: <20250724145202.7f48386e9bd6fc8e114c3436@linux-foundation.org>
In-Reply-To: <20250724-anonvma-uaf-debug-v1-1-29989ddc4e2a@google.com>
References: <20250724-anonvma-uaf-debug-v1-1-29989ddc4e2a@google.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 42B3214000C
X-Stat-Signature: inydp44rfcbhwfr9xfce8aztdped5efn
X-HE-Tag: 1753393924-364616
X-HE-Meta: U2FsdGVkX1+ECPdHF20mI14Up4995rM3OJQ3Wfrp4iAG/hVDxuGSt7t55tuXKRM8EvTlJ5XLrWsnsTMI2jEZMuyVfxqg84pjmZZpYHNFP5lowJLlWuu31Q7wTHAzcjcwx1nlUXNeph8cnhykEHXgoEKHeyoQoW0IGP4Wc/KgntYiak4ZK36Fb0B0DFz1N/ZCOxymwQxsCIp/XDkDl0KGjiMgH3AGwUzxE9gOvGiMMb+4uLg9GyTfTUt7GhYpNLtZdhE7QMXQ2sz/28nqswfuA0LQWpRjMMAi9lDv6AR65fQGC2Dv11kU49E1kKCqgwhnsXyAuCWp8S4ZkGTHbOHGa0r4MI/GlC4LWKn3rTZiCB+V3p7EqscOb9s6//2yDnV6odD2ZakJr/61bIp7fKo9oAIci/Hqqfs3If9aYFREVAdwEqUVYj6TU+xDzV+RbA3VT/MWc25yl8t/DYs/KzKc123+aSQ33xvSsSCAUmyXWXAUSejQc+1P+pwaBbGRgQX4s1cSaARWJkdLz2nDTD+gf5LhN4fCA1DcDtvrNfMg4+FyF98fZfRv2/5mW7XZAVWFFJFiTv7lM6sDrSq18gzEwi3pRi79/4NE/q4r2mP0v+AemfoEgpf7eYQ+o0ZX5yZACJUvIE21saeLPM962oW+8xLijN4bpPyHWQtmOEs8KDLlL5Vsm12nGVxSYKJWtmnRQ0zeq8xorkLSp7MdtMBDuZUSq78Mg8596CxUyEXzEEt5cawZOX3jgEfeMIhesJTuh86IkXunu53AGNpOwKa4dXeZY2+9ttSqbGeCemA3rW3JaLmxrDcaEeQXOvviK6jrhaKHt0tq71xJxTlB/JoBkisJ1bCwtvXJc5PpnzCiYkJ3w8vjcmmKEbfIMP2V8WDsucTyLDhaalq8aUJrcZxbl46kkoMldcQmlLZkMwcFPPZ46dheN/a5ojcBLx6b70MHyrq6NEqm66y2Enmk6xE
 +A8uFfdU
 6Z1TU2NCYPO7dWsoZGoEK53jD7hU58Ao8ZbwpbvWty311s4XMg5ze18iQGSWdZgN4vH/hyQ0Jr7G3h4skT4HsE8ynk3kvR1/GN35Vl6S9xg+VL9QJX33jyU8IaUQuWwUTLtZ5YDppttu7RxcWMFwdJtELQizZF+sjwlfLRnZszFaJWTkUDTnromYhilLFDYSnbpS3lliwQyi/GTIpIPeBi15M5HqVLXlY0/HAMhLCj1ZEG8Y4seNLGiJDpXum8UufDBfVnBgHWW+nLHUHThN5R1NQeYCzMBWsj/X3E0D56+rLcHCsS9wWLgOVpEBX/SrQNboa+jjw1KCPWvoJMSbxu8M/5BlFBdgajAba
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 24 Jul 2025 21:13:50 +0200 Jann Horn <jannh@google.com> wrote:

> If an anon page is mapped into userspace, its anon_vma must be alive,
> otherwise rmap walks can hit UAF.
> 
> There have been syzkaller reports a few months ago[1][2] of UAF in rmap
> walks that seems to indicate that there can be pages with elevated mapcount
> whose anon_vma has already been freed, but I think we never figured out
> what the cause is; and syzkaller only hit these UAFs when memory pressure
> randomly caused reclaim to rmap-walk the affected pages, so it of course
> didn't manage to create a reproducer.
> 
> Add a VM_WARN_ON_FOLIO() when we add/remove mappings of anonymous pages to
> hopefully catch such issues more reliably.
> 
> Implementation note: I'm checking IS_ENABLED(CONFIG_DEBUG_VM) because,
> unlike the checks above, this one would otherwise be hard to write such
> that it completely compiles away in non-debug builds by itself, without
> looking extremely ugly.
> 
> --- a/include/linux/rmap.h
> +++ b/include/linux/rmap.h
> @@ -449,6 +449,19 @@ static inline void __folio_rmap_sanity_checks(const struct folio *folio,
>  	default:
>  		VM_WARN_ON_ONCE(true);
>  	}
> +
> +	/*
> +	 * Anon folios must have an associated live anon_vma as long as they're
> +	 * mapped into userspace.
> +	 * Part of the purpose of the atomic_read() is to make KASAN check that
> +	 * the anon_vma is still alive.
> +	 */
> +	if (IS_ENABLED(CONFIG_DEBUG_VM) && PageAnonNotKsm(page)) {
> +		unsigned long mapping = (unsigned long)folio->mapping;
> +		struct anon_vma *anon_vma = (void *)(mapping - PAGE_MAPPING_ANON);
> +
> +		VM_WARN_ON_FOLIO(atomic_read(&anon_vma->refcount) == 0, folio);
> +	}
>  }

PAGE_MAPPING_ANON is now FOLIO_MAPPING_ANON.

The subtraction to clear a bitflag works, but my brain would prefer &=
FOLIO_MAPPING_ANON.  Oh well.

Plus gratuitous 80-col fix:

--- a/include/linux/rmap.h~mm-rmap-add-anon_vma-lifetime-debug-check-fix
+++ a/include/linux/rmap.h
@@ -458,8 +458,9 @@ static inline void __folio_rmap_sanity_c
 	 */
 	if (IS_ENABLED(CONFIG_DEBUG_VM) && PageAnonNotKsm(page)) {
 		unsigned long mapping = (unsigned long)folio->mapping;
-		struct anon_vma *anon_vma = (void *)(mapping - PAGE_MAPPING_ANON);
+		struct anon_vma *anon_vma;
 
+		anon_vma = (void *)(mapping - FOLIO_MAPPING_ANON);
 		VM_WARN_ON_FOLIO(atomic_read(&anon_vma->refcount) == 0, folio);
 	}
 }
_



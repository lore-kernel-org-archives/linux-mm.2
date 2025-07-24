Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E18AFC83F1A
	for <linux-mm@archiver.kernel.org>; Thu, 24 Jul 2025 13:28:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 465CD6B02BC; Thu, 24 Jul 2025 09:28:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 43BF96B02BD; Thu, 24 Jul 2025 09:28:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 379036B02BE; Thu, 24 Jul 2025 09:28:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 22E786B02BC
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 09:28:52 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id CAD031A0384
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 13:28:51 +0000 (UTC)
X-FDA: 83699238462.26.9BDE684
Received: from relay.hostedemail.com (unirelay01 [10.200.18.64])
	by imf13.hostedemail.com (Postfix) with ESMTP id 0DFDB20009
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 13:28:49 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753363730; a=rsa-sha256;
	cv=none;
	b=qY1SIhyUXFkX7pUuLZcp6G+9+L652gDjbSxjSY4rQ9wXnnWPc216xPqzHjqD1f0MLPbwSR
	YXcWa3L7FHkEM93ICIKF98URak3LQctcS/nfk5rLtgtrD4jV0dT5USn8szZuWt3IKOr+VS
	kt5gr7euSPn8hvdi2GFC/z4+JsKOQfQ=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753363730;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=SXfYGfYLh218hJHjTQdgGwoQkXS5ZopwfEndSfHKB60=;
	b=CPDx0J+PdOsmv4HfEdAZWUFwrOKmjqeRc9y5irHDIqaufit4SMcChM8MGYODHK8RrRoAPv
	VmhlyfpvcQHm8vA3g6+9Sme/olW3KMzxwtsjqHYYm9m+4uN/taX8KK/ImpXJC/+C5bBh9V
	wvEv7ewssadhF6pOmHQFojRGdzMOp1c=
Received: from omf09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id DDE751DA81B;
	Thu, 24 Jul 2025 13:28:48 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: rostedt@goodmis.org) by omf09.hostedemail.com (Postfix) with ESMTPA id C889820025;
	Thu, 24 Jul 2025 13:28:46 +0000 (UTC)
Date: Thu, 24 Jul 2025 09:28:47 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: LKML <linux-kernel@vger.kernel.org>, Linux trace kernel
 <linux-trace-kernel@vger.kernel.org>, linux-mm@kvack.org
Cc: Masami Hiramatsu <mhiramat@kernel.org>, Mathieu Desnoyers
 <mathieu.desnoyers@efficios.com>, Andrew Morton
 <akpm@linux-foundation.org>, David Hildenbrand <david@redhat.com>, Madhavan
 Srinivasan <maddy@linux.ibm.com>, Michael Ellerman <mpe@ellerman.id.au>
Subject: Re: [PATCH] powerpc/thp: tracing: Hide hugepage events under
 CONFIG_PPC_BOOK3S_64
Message-ID: <20250724092847.1aa83756@batman.local.home>
In-Reply-To: <20250612101259.0ad43e48@batman.local.home>
References: <20250612101259.0ad43e48@batman.local.home>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Session-Marker: 726F737465647440676F6F646D69732E6F7267
X-Session-ID: U2FsdGVkX1+rR41YkZ4vfPDuaVGPm5LjEQ+o87duC2E=
X-HE-Meta: U2FsdGVkX19TwKwFZE33d1YoVfppyNpdv/tncGvkHsZwMXaWnKE14AaArR6yFSehWaptxorH5BRbkpqvjBpmgqIAkUbK4csDkVsaN/jxHJXJ24Uoln1FdOMJaLuV2+u+trOzamfPkgOJv6Fg6/08hRiLVz4wABcvUtwkD9Hki9pHTrrBht/0CUs8D96Do1EtswbMe+r093l7NiwM9NKNTeUdKUn2kVYjcFgtRgfFyk2W3RNViePsGFdTzB8iGRYr+RgIELl2fhr2Jv6JvcDoUxlpuf/xhrurqovaYpdqHxpbdbfRIk9Xi8QmqXkOK6EsFengFjcaV3RveOifvzgL9a0HEnOL6JIDZQucAmMhUwXijoyEF3xPUnyjG854LrQ/Sl+ORHuGs/CDnzUlprRh2JC38MpQXAZC
X-Stat-Signature: wwqsp3ycupd37f9jfqojdzid69kub8ro
X-Rspamd-Queue-Id: 0DFDB20009
X-Rspam-User: 
X-HE-Tag-Orig: 1753363726-693272
X-Rspamd-Server: rspam02
X-HE-Tag: 1753363729-928497
X-HE-Meta: U2FsdGVkX1/7DRf2131ta06y4dt5n3ezN6F0XZVmX1dNF6IYeXzkw7R/EkT+0mS1QHKQAu7FvfRiJKtvwT/xLJD1QG6fcACKBFyHYTNf4mrbF3t7LaLMg04vxlLXPgAXLmctbMNi9ckI9QXQV4U4fARnxYkYjVoNgCVDY3//SZKttJ+8FunO/P/w91mtAtnbQ1dApVL1DUTr1rz7gRIjcAoVVsaET3SVg1J/PG2uXU0i3LQjAULuKa2Z3hiB4So/6X/M8rccidlT4/qQOCVkx241PsCfim6BxZBzldTSo2ojDf3JUNcQlb7kIvSFNVYSIhhA2ZAJFD/rKcplsqzuiCHzIJ0pvhREesAXjZXmEdnSSawnplOObwOLJlMJUXpTBF5iWPm0h817p9NGuO/kTwl3IxBZQZ+YHrme41Q2K17pqF8fFveFfbIgmCNkuWHxBMQwHqEhK42z7AexoDS9mrUPAIIRF/RE5y0/LbkgYJuCFeuC3pnvpPfOn3T3JfTghAgY2p8Ndvy9yWtwfl5HH5vviF/vLpTA9PBaTbT+uR7iqMhrA3QH33SJqoDQLRBSVrqm8BU6EpmfXtKSAbzpJfU8qjNmZFw7JT/NWXHIXJKSb3RyiFtDyjXLP3jMqZPUyv0hfiKEHBHpsqg73iUglr0dsBAOlqjD917paXw5qAKY+qtjdNy36tw99KTAZaGFDxxu/AlXEG5Lb759VtY0BxGlLgBeHOxJbCYE5sQLRQOXpfMP8tE30L5l20RG0HFLwUaolaT1+ZkbCt0++/jS8Ad97aLdo+I9lTEv8eRlBqJbRhyIZw4bkvTwhgNY4ZoPzqRFh/D5WfENXNh+mPKZn7SlzgmtY6Vb5VsAy1/OpMDIcF/fG9E9xneTp0ZQh3LLlalmExQ7VLbakXphFwg5dg0vbRIH4hxvXLXfU3p6mv9mIV4NYZ5lCx1xgo1iCSYpI72s+NnJM7YtIvb7qub
 j1JG/HDO
 8Gj+J8BSs1CVho9189+tYm/wPTCE3w+eKtcjHj0luXlvvWADDdvul62spAEzaXQCA4ocbU9OCqqGoZJU=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


Anyone have any issues with this patch? Should I take it in my tree?

-- Steve


On Thu, 12 Jun 2025 10:12:59 -0400
Steven Rostedt <rostedt@goodmis.org> wrote:

> From: Steven Rostedt <rostedt@goodmis.org>
> 
> The events hugepage_set_pmd, hugepage_set_pud, hugepage_update_pmd and
> hugepage_update_pud are only called when CONFIG_PPC_BOOK3S_64 is defined.
> As each event can take up to 5K regardless if they are used or not, it's
> best not to define them when they are not used. Add #ifdef around these
> events when they are not used.
> 
> Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
> ---
> Note, I will be adding code soon that will make unused events cause a warning.
> 
>  include/trace/events/thp.h | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/include/trace/events/thp.h b/include/trace/events/thp.h
> index f50048af5fcc..c8fe879d5828 100644
> --- a/include/trace/events/thp.h
> +++ b/include/trace/events/thp.h
> @@ -8,6 +8,7 @@
>  #include <linux/types.h>
>  #include <linux/tracepoint.h>
>  
> +#ifdef CONFIG_PPC_BOOK3S_64
>  DECLARE_EVENT_CLASS(hugepage_set,
>  
>  	    TP_PROTO(unsigned long addr, unsigned long pte),
> @@ -66,6 +67,7 @@ DEFINE_EVENT(hugepage_update, hugepage_update_pud,
>  	    TP_PROTO(unsigned long addr, unsigned long pud, unsigned long clr, unsigned long set),
>  	    TP_ARGS(addr, pud, clr, set)

>  );
> +#endif /* CONFIG_PPC_BOOK3S_64 */
>  
>  DECLARE_EVENT_CLASS(migration_pmd,
>  



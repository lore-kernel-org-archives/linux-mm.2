Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7A9BDC5AC67
	for <linux-mm@archiver.kernel.org>; Tue, 11 Aug 2026 05:54:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8D0176B008C; Tue, 11 Aug 2026 01:54:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 880FA6B0092; Tue, 11 Aug 2026 01:54:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7C0946B0093; Tue, 11 Aug 2026 01:54:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5CF176B008C
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 01:54:57 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id D6735140283
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 05:54:56 +0000 (UTC)
X-FDA: 85087924992.07.6EBE274
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf07.hostedemail.com (Postfix) with ESMTP id 0CB9D40003
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 05:54:54 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=GQyOt0N5;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf07.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786427695;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5vs0lacMJLmSK4+++PcZ15Wjz6RJL9ozhfGMOsETHNI=;
	b=W0jYEznuiimP/e0GElyjqiYxVDwdZdVzS/27V89PrOG8If8jQitmifdsmO3/yKRl5Wg3YZ
	+N4EuJCY67BgR72kskeeNB8UmZZj5FSNN0qHL7cQAQ8+D15WGgsZ+/jehL6pnKYa2vllfQ
	b+ffM8wYTWZ0knkjl7lR+evR78jDZHg=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=GQyOt0N5;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf07.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786427695;
	b=mjO2b5YO0eJoCTLXuwqJVqfw4wHFZWOIJp3zLiUjjst4CzRQPyauECtlfM24XpL7yU9MPM
	vE6nprG3CVw2lwnp2l8+jB5r8U8QZxPLBOE1bjSSH3pEOrAZxTPe/59UHx1voltfo5XkQI
	dyNfBrR4eaIfDqvHeiwoQleuAzC3d6k=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 18BEF1516;
	Mon, 10 Aug 2026 22:54:50 -0700 (PDT)
Received: from localhost (a085714.arm.com [10.164.19.28])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 4E02F3F632;
	Mon, 10 Aug 2026 22:54:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1786427694; bh=OhF0UPRews73LbNvIT7NctAIRe4VOf0G6Dt+2Zp6UHg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=GQyOt0N5BlWcAwRxIRFhCNoL0pOdFHl8tfHBTEmsNLlDF2/RouXP6Gv5s+388k1WC
	 UJE0HtEntoCEejEpSi5RI2vRksilfcjP5xyVx3iuO8tjPSiYnaTqL+IWdWWPqLO0GX
	 SR23o9lNKQ3ST03QUcnk9m0XsQA4CyRF4xgNRce8=
Date: Tue, 11 Aug 2026 11:24:50 +0530
From: Anshuman Khandual <anshuman.khandual@arm.com>
To: Bart Van Assche <bvanassche@acm.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, 
	"Lorenzo Stoakes (Oracle)" <ljs@kernel.org>, David Hildenbrand <david@kernel.org>
Subject: Re: [PATCH] mm: Make VM_FAULT_RESULT_TRACE compatible with sparse
Message-ID: <wgpmajmsa76zdgrfxt2ayvqvr62es4gxkxslmx6smbnmhlijao@g4xsu3nmcom5>
References: <e56c9e2aead04f79192c3110de80d846e41e3791.1786122711.git.bvanassche@acm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e56c9e2aead04f79192c3110de80d846e41e3791.1786122711.git.bvanassche@acm.org>
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 0CB9D40003
X-Stat-Signature: sky54x7ribgcyrn7cw93ckj63h9kxgsr
X-Rspam-User: 
X-HE-Tag: 1786427694-331151
X-HE-Meta: U2FsdGVkX19y9YwosE3qb1rhD6jW1qRGbObnJJaSvbLhXxOZCTxGKCmQ+xa6gCfg3qoyZ31mNOcYFmneGTfyMZzSjmJewydapImysXYYrQDLJLdcXULMH+lVWJC4DCebNClOp5h/M6sTSs+gHthR513ZxFSaiN6QZhdZv4f03uYMhlRoZmy5H7jF7rHDTDqlVQ2QQTqyxZ2InxZJUOz8/vFd30DuJTeeyp0dQUdNIQgkpce/SW1P3g5CLuq+XheafsQolYp6UtT7ITqc8eU3+Ohxn3EhJAVJDRdfwXQU+wmXoIYIZ4L4GtY4Eo5Ij78dogTwu3jgQ2HhfQw62oLNJKtwflKGqmtFaZwzm80lZZVVgs+4byA0KnbwqPvSjX8RqMhvgzARp67EY1f12VsaSPEj+njZuNdrth5Ywv5DAOCGKYccHKQmjkwLdhf662OPkGmgqdbmNu3TmVoR9oFSItmFehxZTrtVRZxW1dxGlr2diSterC8iQK2uCFp1tH5LNXilzAWVSjQADsGyGDQ61MJab8STSrAto8BYwT1OSH1G14iX/GNTx07h2RNp72KqM6DH58ysgnE25EVNbulzEIGPpOyPyhkI25DiEd+GLkw9xjk1/7/NEosctfHp+hJzlZRNRSK7w8uHWkcmJRcR4k3B6gjsXdHEAHQy+gzz4JT/TZS73qlKcMvIPRGCON85fFJQ8Ivs8XFiclCX6tVrczRcBODR3dA3boqMgPAIvseeFMHLxT1FF1QWk6i6UCb4Uc0ZOZ66OljGzzIPiJd/jQ8PZINQnk4G1od85Tv4mjRcnWv8A778o//LU0ZvhzSJ1sUDJzlPs6ylwqNCXI3JvPD+21BLMFY+qQrFauZ2d3qv0jqrEUgmhxgyZBfxe8fo62akjIlOcONZRLZwDaK6L3SUD0yIS0FcL3pCdJtXPUcd1slff9BGGoper2E83QqiVZrwY1gzwH6nVec9wHq
 5FfPjYXa
 jNrDdX8x+IBMEvpCg45W4hrOHmY4kOKCiRa6fYIPMCcfNy6roOThQK0AGpM2A1SekgTXnxk4vOCyT+gkgA9uHBVAuAZZHr7rXrEE8ykcNkPNy5IhvK3NmzcxytXNwKHYqYMQ11jhkzZ0Kz4JpnQul3eAPNim6CQUmf20z3MoxncEbGTmZxQ+yMR1fUHrOfe93V9liORNbmbWkaujvd8bvp6xwAHGbX4RmsM3PB5r1fexktYT1ltZBItb+BQJ++b+x/C2/6J7MKW8LjgHzyy3ku8j8DwWaDxzXatRYLL4LLrCnWy9NKmRJW3X1C5lnu3MuWxAqv2xpwEOrR0TaJitlKUhvvwpOUHiK50vj0Z5R99btH7nRs71mU1x0rN1S+bENPThEHtp1ep31VzSPUMfpLz7CHOguKml3exjyjDRMinGrAhdgZv9peFaUBPhAuNbC5rmKLkVQMJ+i9AzN3GS6SJOXdtM74CwWmCli
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Aug 07, 2026 at 10:13:10AM -0700, Bart Van Assche wrote:
> Fix the following sparse warnings that appear while building f2fs:
> 
> ./include/trace/events/f2fs.h:1469:1: warning: incorrect type in initializer (different base types)
> ./include/trace/events/f2fs.h:1469:1:    expected unsigned long mask
> ./include/trace/events/f2fs.h:1469:1:    got restricted vm_fault_t
> 
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>

Reviewed-by: Anshuman Khandual <anshuman.kahndual@arm.com>

> ---
>  include/linux/mm_types.h | 28 ++++++++++++++--------------
>  1 file changed, 14 insertions(+), 14 deletions(-)
> 
> diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
> index b18c2b2e7d2c..fcd7d6cfce0f 100644
> --- a/include/linux/mm_types.h
> +++ b/include/linux/mm_types.h
> @@ -1703,20 +1703,20 @@ enum vm_fault_reason {
>  			VM_FAULT_SIGSEGV | VM_FAULT_HWPOISON |	\
>  			VM_FAULT_HWPOISON_LARGE | VM_FAULT_FALLBACK)
>  
> -#define VM_FAULT_RESULT_TRACE \
> -	{ VM_FAULT_OOM,                 "OOM" },	\
> -	{ VM_FAULT_SIGBUS,              "SIGBUS" },	\
> -	{ VM_FAULT_MAJOR,               "MAJOR" },	\
> -	{ VM_FAULT_HWPOISON,            "HWPOISON" },	\
> -	{ VM_FAULT_HWPOISON_LARGE,      "HWPOISON_LARGE" },	\
> -	{ VM_FAULT_SIGSEGV,             "SIGSEGV" },	\
> -	{ VM_FAULT_NOPAGE,              "NOPAGE" },	\
> -	{ VM_FAULT_LOCKED,              "LOCKED" },	\
> -	{ VM_FAULT_RETRY,               "RETRY" },	\
> -	{ VM_FAULT_FALLBACK,            "FALLBACK" },	\
> -	{ VM_FAULT_DONE_COW,            "DONE_COW" },	\
> -	{ VM_FAULT_NEEDDSYNC,           "NEEDDSYNC" },	\
> -	{ VM_FAULT_COMPLETED,           "COMPLETED" }
> +#define VM_FAULT_RESULT_TRACE						\
> +	{ (__force u32)VM_FAULT_OOM,                 "OOM" },		\
> +	{ (__force u32)VM_FAULT_SIGBUS,              "SIGBUS" },	\
> +	{ (__force u32)VM_FAULT_MAJOR,               "MAJOR" },		\
> +	{ (__force u32)VM_FAULT_HWPOISON,            "HWPOISON" },	\
> +	{ (__force u32)VM_FAULT_HWPOISON_LARGE,      "HWPOISON_LARGE" }, \
> +	{ (__force u32)VM_FAULT_SIGSEGV,             "SIGSEGV" },	\
> +	{ (__force u32)VM_FAULT_NOPAGE,              "NOPAGE" },	\
> +	{ (__force u32)VM_FAULT_LOCKED,              "LOCKED" },	\
> +	{ (__force u32)VM_FAULT_RETRY,               "RETRY" },		\
> +	{ (__force u32)VM_FAULT_FALLBACK,            "FALLBACK" },	\
> +	{ (__force u32)VM_FAULT_DONE_COW,            "DONE_COW" },	\
> +	{ (__force u32)VM_FAULT_NEEDDSYNC,           "NEEDDSYNC" },	\
> +	{ (__force u32)VM_FAULT_COMPLETED,           "COMPLETED" }
>  
>  struct vm_special_mapping {
>  	const char *name;	/* The name, e.g. "[vdso]". */
> 


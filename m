Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D1667C55174
	for <linux-mm@archiver.kernel.org>; Wed,  5 Aug 2026 16:55:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E84C36B0099; Wed,  5 Aug 2026 12:55:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E5C926B009B; Wed,  5 Aug 2026 12:55:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D99EB6B009D; Wed,  5 Aug 2026 12:55:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id BE7946B0099
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 12:55:09 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 4413A1604D7
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 16:55:09 +0000 (UTC)
X-FDA: 85067815938.30.F5E0E28
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf22.hostedemail.com (Postfix) with ESMTP id 5B727C0012
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 16:55:07 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=v2E4D0zr;
	spf=pass (imf22.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785948907;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=y/Xo6oFfSvfj1zh+rhXXcNboxnlTqNc3vaBkdgumDs8=;
	b=q73fBh4jq/AyFqPsq3DZWt9px9wcpsLw/XQAtkjKFil4KPdOLMxIgTKweGauLzMTWA+s0o
	TQOgi08Uy+RZqmq9u4/6yybLnRxCImBnKyHJtP2dLXDD/jB6A8x8i1L8tOmVrrIQI3P6/N
	FJiyvdeieG+1CMlV22C9xYOqNtUsb3k=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785948907;
	b=lSVgNIaZJhx9+13h/sYl2jHCQxypuo7IfqPhZ19I4Ra45S6jrO9itWWYTiZs2VvEpfwqIT
	Q/HbF1/FyWQgWH7B6D+d4qS/hREBqGHvEe0F0jAHKsc8ULqPlq/R2l1lXUDG2meqNfoOgC
	xgqIAJkssYIgLl2TR7JmOMwvggxHJVo=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=v2E4D0zr;
	spf=pass (imf22.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 7D83A43C5F;
	Wed,  5 Aug 2026 16:55:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35AF31F00A3A;
	Wed,  5 Aug 2026 16:55:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785948906;
	bh=y/Xo6oFfSvfj1zh+rhXXcNboxnlTqNc3vaBkdgumDs8=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=v2E4D0zrSHz84NoMOT/N5xD2ffO+tWDFQxb+rv7JssylOXqG/9CNmDq6w5SBv6Le6
	 cKl++OCnqbi+g96XX2whiBiZhAsEU430M8CwOeqTC7VjbdMRG+xZP7Qg6pAvqE9qqV
	 WvIervouVCFUIY3n97UiCgoh6bbQZwf6w0pxmnu4=
Date: Wed, 5 Aug 2026 09:55:05 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Hao Ge <hao.ge@linux.dev>
Cc: Suren Baghdasaryan <surenb@google.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Abhishek Bapat <abhishekbapat@google.com>,
 stable@vger.kernel.org
Subject: Re: [PATCH v3] alloc_tag: fix undetected compressed tag overflow
 when profiling is disabled
Message-Id: <20260805095505.1c2cbc150441cb20a74ba9bb@linux-foundation.org>
In-Reply-To: <20260805090633.141001-1-hao.ge@linux.dev>
References: <20260805090633.141001-1-hao.ge@linux.dev>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 5B727C0012
X-Stat-Signature: thka4fpepmaeojc13ix757ap3jke59bw
X-Rspam-User: 
X-HE-Tag: 1785948907-162872
X-HE-Meta: U2FsdGVkX18UCc/yBfiPGIkNQiT+EVdaojhVHF3M0Aj2ZEVCBJ5V01iMs+R2EIoa8X8hdg73mcSU8od/pMOA7/JJSxa69NColxItZhdfuwKKKLvsxq2THjfIO2be4KGLwSx6oanV475aEDbNs9SmmDBRbJpcqApus5qyNnx+SdVY5+s2GV+9q6xqOfZZKeSvHFiYB6/K+th1H/ct6UtJ8Frw3oUJyCJBYaHSfJmXGb8c4GAg+sEH/CRAlWFC3E49UlmsXAi8nxoI/4Dc9KIEpGnBkC4cj/5LqNkF7uIAmlL24wDxSsHSxBAcoKBeAUeoPe7p1xVoKZ5+Wzg07toGyzTZlG3L8j4rrELWCRj7bFhO5nFf766equIPcbKWAMjubbs+CW41WqWcnx/UwQczTCZj5DZOyVlqsgHDDtkNVsbgwGbMZ9saHiPW/fpWOKR3kjnfdkLss0JCv77GsTErsvyaTg2ug0I/t0YhvNB5YPLpt4DEdlTFecavDtV7ECL7e26tVPWqA2KgNs5C+pt1d34PswpKkP2N9ro51a2Yrb05FSqzYlWD4wr7ixj8ZTtuYEPjAWN+O2ZVpR7+OJeTmyQRJSo8CT2KxQXaMaCKIQEeFRGWiNdBbQbnJ30XyzHJf4UUjgHuc3SbUeG4/GrnbFtbsO2wWqekMOzcQs41dCtPxn20uezlF3A+Oc0Sw+hEl67P3Qou/V2egdgnAG84u6eHGWsZuhMX7kXy0lcbt0/JpSSEwzZU//gP2aE/6cLz7uF4WRwcJL+qF/EVVKrevL/3+aJRHOc7BJoLNWTunk1r7Z+f9F9wWyt4wWT92FEmVoCYK4uSzGFAbCau9KZfatkDgtd5NUdtwxkYjtVr3DopV9XinVWqc2SkUWwtMWH05U8Rdi8+hDP8sYcNNSQ5IquIFfMcUbMmH/gvgyLM6hKaeIRKP3+RsQFDOKOrwjmN9nk3yQQOh/F6hqn89cG
 BzagkMLU
 XZVo8gZC/BODVwLVGtseaK3xLQr0lCVkshFVuGLwJ+1E2BTgoA+mIIaulKLwNUM/iHCFPxHCB+3ol2Ab2BjdZjhN4W+G2jjmUoU71FS7FZnpDe/mjPRyW1EX/5GvrNVpTh2OVBjndqNBhsluWwXBFZCNZ27PUPmVb4mLYH0nXNIgHrXb3TonlzppBqgLmim2UGza3rOiewFPzsbdzd8BQ0E0n0cZubYyfbXu3eLyyZSxpqRi62XMyUR/WeFcpRqiOkZWiwOCxkfv2UjK/dmA9PmiRDMW6OxiM+7CKChnJdq6F2rG2tINAMFV6XWa8RxDzoKOYGLP48fGu9lv+9M3H3s7QSaNwa0uuiJB9
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed,  5 Aug 2026 17:06:33 +0800 Hao Ge <hao.ge@linux.dev> wrote:

> In reserve_module_tags(), the tag overflow check is gated on
> mem_alloc_profiling_enabled():
> 
>     if (mem_alloc_profiling_enabled() && !tags_addressable())
> 
> If profiling is toggled off at runtime and a module is loaded whose
> tags exceed the compressed-mode limit, shutdown_mem_profiling() is
> skipped. vm_module_tags_populate() still maps memory for the tags and
> the module loads successfully, but the total tag count now exceeds what
> NR_UNUSED_PAGEFLAG_BITS can address.
> 
> Once profiling is re-enabled, ref_to_idx() computes each tag's index
> as its position in the alloc_tag array. update_page_tag_ref() masks
> it to alloc_tag_ref_mask before storing in page->flags. Indices
> beyond the mask are truncated and idx_to_ref() resolves them to wrong
> tags.
> 
> This silently corrupts /proc/allocinfo: allocated pages get attributed
> to the wrong call sites, so the statistics it reports are wrong.
> 
> mem_alloc_profiling_enabled() and mem_profiling_compressed are
> independent. Once compressed mode is established at boot, it stays
> active regardless of runtime toggles of mem_profiling.
> 
> Remove the mem_alloc_profiling_enabled() guard. Also return an error
> after shutdown_mem_profiling() to skip vm_module_tags_populate(), as
> the mapped pages would never be reused - shutdown_mem_profiling() sets
> mem_profiling_support to false, so no future module load enters the
> codetag path.

Thanks.

AI review points at a cpuple of possible things, one pre-existing:
	https://sashiko.dev/#/patchset/20260805090633.141001-1-hao.ge@linux.dev

"Does this unintentionally result in a denial of service for module
loading, preventing critical drivers from loading when they otherwise
could have just disabled profiling and gracefully continued?" sounds
pretty obscure and I doubt if we care?


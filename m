Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D7A94C4451C
	for <linux-mm@archiver.kernel.org>; Tue, 21 Jul 2026 11:59:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D627C6B007B; Tue, 21 Jul 2026 07:59:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CEBAF6B0092; Tue, 21 Jul 2026 07:59:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BB66B6B0093; Tue, 21 Jul 2026 07:59:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 7DBAB6B007B
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 07:59:28 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id F341412010B
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 11:59:27 +0000 (UTC)
X-FDA: 85012638774.23.E8ACD1F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf01.hostedemail.com (Postfix) with ESMTP id 25E884000D
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 11:59:25 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=aYkQRZtK;
	spf=pass (imf01.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784635166;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BkBqQeZsu4p5xalY28N6H1RbwRy6i2XBb+MX5uI0fsg=;
	b=LQyI/hrvRP9ZH/nxRCcTy9ev9D2O9SXCIZ+XZ0UTYVKfiQ1SC3+ssGuZvEjE12fS9YM0sM
	D8aqvUyqRBvOLBpxIbijdOia5ctypMqUyffjSLUJ8FO0smA+7+0CxjPdiHhIPPPJ9bYz3E
	zp6PSHHXojYGlReYxHwALZ+o0FwUEcg=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=aYkQRZtK;
	spf=pass (imf01.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784635166;
	b=LbKkZjKZWP3Hbqfq//yjnCDBiOzLa58yQRToZ5XX7FAarXk0GvszAypl0MEl5+olg5D1fV
	3QCNJyVZsBxOAmIYOVjY+T+0LTmR2CADpIKsfV2aJpttuBH8wgphSGtcU92O/a4M3ZEbxN
	lxtWmoliFwHA8iguWW83oIXjMSUmJ9U=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 025724182C;
	Tue, 21 Jul 2026 11:59:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46E511F000E9;
	Tue, 21 Jul 2026 11:59:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784635164;
	bh=BkBqQeZsu4p5xalY28N6H1RbwRy6i2XBb+MX5uI0fsg=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=aYkQRZtKJpV/raQruiEsjYECc85zx4lZfk6s9SiRSLQLW24Qvl/8WmIeOT9p5qnep
	 cDDAHEX4Nldfmq8M6KC4zYg7AvuVHhYKvgtm27+A2fureIEUb8dNttjqIbeOizdWuY
	 3TWkFSYlcmQavdGRC23mOPucFs9+4UEKQzhG2GN4ApfnHiiQNRVHkMpcREzIP2UC7r
	 WKSXP95OQZLAVwV7Mqv5BLSLstqitEwSD6k9ATyvnn1BUTzhntmQsli1yWWarI/KS6
	 PUkFYZ10/vNDaWgkN36CDsx8q8ccFa3kCB0QU+JtMPjFEho01+/8/8YHkO7RqXCFJl
	 ZSYIJ+QZ909EQ==
Message-ID: <5bc46ddf-f4b6-4f96-b97a-25339a5c7fef@kernel.org>
Date: Tue, 21 Jul 2026 13:59:21 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] exec: fix unsigned loop counter wrap in
 transfer_args_to_stack()
To: Christian Brauner <brauner@kernel.org>, linux-fsdevel@vger.kernel.org
Cc: Kees Cook <kees@kernel.org>, Alexander Viro <viro@zeniv.linux.org.uk>,
 Jan Kara <jack@suse.cz>, linux-mm@kvack.org, stable@vger.kernel.org
References: <20260721-hochachtung-staumauer-pigmente-15d71f7d7d04@brauner>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260721-hochachtung-staumauer-pigmente-15d71f7d7d04@brauner>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 25E884000D
X-Stat-Signature: y1cuywqww74q57qk75rzw8ccehgfkuku
X-HE-Tag: 1784635165-253470
X-HE-Meta: U2FsdGVkX19Btm6QZMQKO/dKihJd4Eb3cL206XsmwlCqDH2CwUY2yGYXCuV9Zu6Quz142+c2kNLUHqY1hBJL61zYLFLgir8HOJOtdg5s3z9CKKVGe9+G9gXpub5dKCclD4uxX4a1sBc5SNj+79gMcOkd91tLOUaXRpdiH7L6yetWBpsO2x3b/x/z0xgHz7sjFMSGg4uXjWWlTyZD2qRHNsvrExvLONhmWbAphHzF4+q130upFpRVoz3dOzrh0vPspERu5LOgJsrm108KCloHblzt1HLI/9phPFlyVrEGGI077wK5TlnNuGaEdgq33VxRfa0lGMhO8HCyE4p2ha22MqHr/EPRCns2sC/9yaMpHKZK2ldoPPlbwt6kSjgXWb9YMxTi2YrpalG5mLZPDKM9iVgRe8DFnS5dYGqEKHCLe3mDQptdy8TInYwwuPUss92EbgwC+u2Ps8vrYBmEedpX9RMsheubOdIskU+sB3PZCNpD2HfMaeKvLZJC8pIzp4i1oCLpA7rGY9Sk+527gbOfkcQ4me04LtEGy0wxNIofXmJr+6m/n5cvH52lms3le8thnyBer1BSUYt5RYabNvuOpXAiB9SKrecXkEqJSEiqGfpBnkVONDIhvcgMaQJXIiRnUBZ2palzNhhGo2zc98xLmM7OWvcVMIBQqz8reLcPaZ42hJ1xnVkHM4vKLjNfih/Mi5p6/ppZUcCsb16xoJ6N45fQxWa+fecG6cxYInlDFLnBgbb0DceFwlqaFn5s8ZR8yufuxsnM6KFwg0EuIRm0tm2gbO0V4aVlqh8+xTHM8YEe6MqgkuV4NHts/TqEjfpk817/k8/l0GBuZtfSCgQMnpgI2cRrnkDnTm5/zc8iGmAP8hofS7NLVky9Qqf+4cA37MAzobjtyLTjGXJBjQk4uEQ2n12NZasLeSxNTDBIv23SeDluyMLeXk8BmpuKEBlvz/3JQmUZJ3YtgLICKio
 p0B3/Bdm
 H+PNRZwgeGi1+ZP6d40U3Q5PPBfUEEJUedswf5J4d5DfAALg7bHVxs0ZLP4nND75yFtK2XjjbPJTnh+oAh4q3sXdqqFLx8DxQc2NuKyBvPIsCMWYjuuhm4citaZsvvBxDlYdtNJf/i/FtoIF5xrciqL6+AWCqxOeqchzVsBgVlIzQCjYMtY2FIqAHMLJwUoTgXyd/v/EA6pc9/3sY7LIvN0PWZVeRLlbSpmdkALy7Mh5fVYr0UqK0uxzruYA/iKjEnGMWHhIpKsiAW5vUsUbxyoqGX8aEit6Kv8AchWcxhbnIYyOevNV6UtHcYyiP3pNp/y4BNq3+TLN0nX16RkPMAnKGjYan0WxmaxpossVw/DMijFE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/21/26 12:08, Christian Brauner wrote:
> The stop value is derived from bprm->p >> PAGE_SHIFT. The index variable
> is an unsigned long. If bprm->p drops below PAGE_SIZE and stop becomes
> zero the loop condition index >= stop is always true.
> 
> After the index == 0 iteration the decrement wraps to ULONG_MAX and
> bprm->page[ULONG_MAX] reads sizeof(void *) bytes in front of the array.
> The pointer has wrapped to -1. That garbage pointer is then passed to
> kmap_local_page() and PAGE_SIZE bytes are copied from wherever that
> lands into the stack of the process being created. And the loop doesn't
> terminate either...
> 
> Getting there only requires bprm->p < PAGE_SIZE. On !MMU
> bprm_set_stack_limit() and bprm_hit_stack_limit() are empty. So the only
> constraint on how far bprm->p is pushed down is valid_arg_len(), i.e.
> that each individual string still fits in what is left.
> 
> bprm->p starts at PAGE_SIZE * MAX_ARG_PAGES - sizeof(void *) so a
> single argument or environment string of a little over 31 pages leaves
> it in the first page:
> 
>   Oops - load access fault [#1]
>   CPU: 0 UID: 0 PID: 1 Comm: victim Not tainted 7.2.0-rc4 #1
>   epc : __memcpy+0xd4/0xf8
>    ra : transfer_args_to_stack+0xaa/0xae
>    s4 : ffffffffffffffff   s2 : 0000000000000000
>    a1 : ffffffdc98000000   a2 : 0000000000001000
>   status: 0000000a00001880 badaddr: ffffffdc98000000 cause: 0000000000000005
>   [<801a5324>] __memcpy+0xd4/0xf8
>   [<800d5f6a>] load_flat_binary+0x43a/0x65e
>   [<800a2de4>] bprm_execve+0x1d4/0x316
>   [<800a351a>] do_execveat_common+0x12e/0x138
>   [<800a3d44>] __riscv_sys_execve+0x38/0x4e
>   Kernel panic - not syncing: Fatal exception in interrupt
> 
> This is an arcane bug but we should still fix it.
> 
> Count down from MAX_ARG_PAGES so the loop ends when index reaches stop,
> stop == 0 included. The iterations performed are unchanged for every
> other value of stop.
> 
> Only CONFIG_MMU=n builds are affected, transfer_args_to_stack() is used
> by binfmt_flat and binfmt_elf_fdpic on nommu only.
> 
> The loop predates git history. commit 7e7ec6a93434
> ("elf_fdpic_transfer_args_to_stack(): make it generic") only moved it
> from binfmt_elf_fdpic.c into fs/exec.c and narrowed the copy to the used
> part of the first page. The condition and the decrement are unchanged
> from 2.6.12-rc2.
> 
> Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
> ---
>  fs/exec.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/exec.c b/fs/exec.c
> index d5993cedc829..c7b8f2d6366c 100644
> --- a/fs/exec.c
> +++ b/fs/exec.c
> @@ -740,7 +740,7 @@ int transfer_args_to_stack(struct linux_binprm *bprm,
>  	stop = bprm->p >> PAGE_SHIFT;
>  	sp = *sp_location;
>  
> -	for (index = MAX_ARG_PAGES - 1; index >= stop; index--) {
> +	for (index = MAX_ARG_PAGES; index-- > stop; ) {
>  		unsigned int offset = index == stop ? bprm->p & ~PAGE_MASK : 0;
>  		char *src = kmap_local_page(bprm->page[index]) + offset;
>  		sp -= PAGE_SIZE - offset;

LGTM, however, using signed variable would make that easier to understand.

Reviewed-by: David Hildenbrand (Arm) <david@kernel.org>


-- 
Cheers,

David


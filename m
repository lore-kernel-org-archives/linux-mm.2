Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C08CDC5B572
	for <linux-mm@archiver.kernel.org>; Sat, 22 Aug 2026 08:50:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 47E926B0095; Sat, 22 Aug 2026 04:50:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 42F7C6B009B; Sat, 22 Aug 2026 04:50:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 31F206B009D; Sat, 22 Aug 2026 04:50:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 095156B0095
	for <linux-mm@kvack.org>; Sat, 22 Aug 2026 04:50:43 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 9C1DB1A018C
	for <linux-mm@kvack.org>; Sat, 22 Aug 2026 08:50:42 +0000 (UTC)
X-FDA: 85128284724.26.C37F14A
Received: from oss.cyber.gouv.fr (oss.cyber.gouv.fr [51.159.188.251])
	by imf26.hostedemail.com (Postfix) with ESMTP id 4A240140003
	for <linux-mm@kvack.org>; Sat, 22 Aug 2026 08:50:40 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=oss.cyber.gouv.fr header.s=default header.b=X1EZAnKo;
	dmarc=pass (policy=none) header.from=oss.cyber.gouv.fr;
	spf=pass (imf26.hostedemail.com: domain of jeremy.jean@oss.cyber.gouv.fr designates 51.159.188.251 as permitted sender) smtp.mailfrom=jeremy.jean@oss.cyber.gouv.fr
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787388640;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jA7ZZ+PPBmaHIUeoNEMhyCIkVm7La/GskdTAq5H+eKo=;
	b=0FYFhaniAqzS5EGlPJ1xYT/rZj2Ef9Yk0Q004k4Mi4+7E66114Zt1yLG/f+jP3DWxm+OXL
	lFB7K9ZtKXlVjklVxSwCf3ZdX26bQ33rLUTgh4Ej12GpniVG5ps0hOkU4RIR7uqK5fFn9/
	J8pY1cnQH5MBlDn6UbbJXccJGp0QIiM=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=oss.cyber.gouv.fr header.s=default header.b=X1EZAnKo;
	dmarc=pass (policy=none) header.from=oss.cyber.gouv.fr;
	spf=pass (imf26.hostedemail.com: domain of jeremy.jean@oss.cyber.gouv.fr designates 51.159.188.251 as permitted sender) smtp.mailfrom=jeremy.jean@oss.cyber.gouv.fr
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787388640;
	b=VtnYG0VVo0nN4JgyGZNICIGXQhfrHxrvz6Pqc++j6sc2GhVVuq95Zb44pPMHF61KtrkKz/
	zysGfkm+24BcBO+6Q3FA8VgQvzb7K07x/ePuVqT3wqZDw08fWPSypsGvaMvhbQPWGUKmsK
	OmKPoo4n9ajGpn0k0OqLF3gylxNttfk=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=oss.cyber.gouv.fr; s=default; h=Content-Transfer-Encoding:Content-Type:
	Message-ID:References:In-Reply-To:Subject:Cc:To:From:Date:MIME-Version:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
	Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
	List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=jA7ZZ+PPBmaHIUeoNEMhyCIkVm7La/GskdTAq5H+eKo=; b=X1EZAnKoPUSWGz5kjixqIMzm9o
	CabyqZVNATHb1zUrWsrRICCm0Y8c1jOXeoUhSEw/fh4rvgDnB8PoE8iDflV4/J5kra39hGGixh9dM
	5ioBhEey24Adct8FB76oxnAAA01LtVIeyVMIxvzuLiuEn5oAblkrep2SQ0M6VyDl1esJ/gw+zACY7
	8WUPFjXRaTZVpg10RW0DgpTUYz5mIhJJ32enZelH51BYAeZLtq69H1ha8Oj10ILxr9OnrOD5ZSaoi
	ld0OBAa4BxHgLnUicd+jUfKeLHX4ZhNMLVoWaeT0XSbV8HPVgpgVqjTD4pfpD++lLznjm727fDQfD
	DahGPMIA==;
Received: from [::1] (port=33978 helo=pf-012.whm.fr-par.scw.cloud)
	by pf-012.whm.fr-par.scw.cloud with esmtpa (Exim 4.99.5)
	(envelope-from <jeremy.jean@oss.cyber.gouv.fr>)
	id 1wxhR2-00000008nAh-0geM;
	Sat, 22 Aug 2026 10:50:38 +0200
MIME-Version: 1.0
Date: Sat, 22 Aug 2026 10:50:36 +0200
From: =?UTF-8?Q?J=C3=A9r=C3=A9my_Jean?= <jeremy.jean@oss.cyber.gouv.fr>
To: Bradley Morgan <include@grrlz.net>
Cc: bsegall@google.com, dietmar.eggemann@arm.com, juri.lelli@redhat.com,
 kees@kernel.org, kprateek.nayak@amd.com, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, mgorman@suse.de, mingo@redhat.com, peterz@infradead.org,
 rostedt@goodmis.org, vincent.guittot@linaro.org, vschneid@redhat.com
Subject: Re: [PATCH] fork: initialize function graph state before
 copy_exec_state()
In-Reply-To: <115F081D-7469-474E-BDDD-39FCB6FCFD7E@grrlz.net>
References: <115F081D-7469-474E-BDDD-39FCB6FCFD7E@grrlz.net>
User-Agent: Roundcube Webmail/1.6.18
Message-ID: <18e7f6a43796eacfe08742d00ae655ad@oss.cyber.gouv.fr>
X-Sender: jeremy.jean@oss.cyber.gouv.fr
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 8bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - pf-012.whm.fr-par.scw.cloud
X-AntiAbuse: Original Domain - kvack.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - oss.cyber.gouv.fr
X-Get-Message-Sender-Via: pf-012.whm.fr-par.scw.cloud: authenticated_id: jeremy.jean@oss.cyber.gouv.fr
X-Authenticated-Sender: pf-012.whm.fr-par.scw.cloud: jeremy.jean@oss.cyber.gouv.fr
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Rspam-User: 
X-Rspamd-Queue-Id: 4A240140003
X-Rspamd-Server: rspam07
X-Stat-Signature: jatx91er6kanym1gajm44aut8u84ot79
X-HE-Tag: 1787388640-975280
X-HE-Meta: U2FsdGVkX18bfA1U4ecUPgOsxpfAhlVQIc30FFHurrxaj6NI/ZEcl/FZDqTxmg782mW68FIBJGe0IOOQ6xSIIKYOgiDb1H00yOhS6yKBJDAzXcj2fADFpDohAq4I48Av5V6Z1EokbP4bgE8cZfXTrSljsf6592xhpvFS41PobOFtVI2dDf0Kl4gMD7Ku7SpzHXJrRRd0gEEdH+cVCw0LYy1M5hKpM7tzsRo+h3ik1VfiSbErlmgeVvv/H980dyn3sc1AmOKym6yTxDL0kJRCB2aySH8ZlUYpE2stwIVLLCzVO0NeH7rqlIYKGnOXSRbQMnrK7sgR6UcIIASfiLQIhgYZtbCba+jONHLBph7enueOq4ElHfE+OVL91KF5kkP6uen4PIGlA5uCJ6ovuJPd5g2HsNW+X6qgsyV08DJFtCKHjFCbzkr9zZ/aphF8jjwH0RHX5RGFl1HROjq9yTRpE4z1IqI3I/7YVNhqTpScJS0W6QBKnNnXSiwwEWiyTlEsDXtmN0YgydeHDkURxGLeZTZelSYKbCBB7wy/BgJCQOcWl67Fg/VvTvMB5B/thyvAovBEkyDCbLExzG9BpRLfyfRBsB/raxEyAVjoulmf1O3IYvH7lA8x4xHBPeLNZVfbIGTj/5tGWWxpusXN8jkIdVua2nOgqDbFrxD/KGHrXFKL2vHsvnFXXeyP448VPXfF4tScH3xUJp7o+2cGmeEGvoFpkovQzoRMth+iM7d+YBrMXs4FCZzovldd9DDtOB+Hkt28bgBOhhQG/1gs9xxXoI6WYGLlmwEJBtS/+juauqjYC6M39QFyhalWYZo2uN5b3p1A6TMECkmQlqgErgTjOSOU1GmMBT2fSXsyHbna85h+GYxHXdhpKbpUzfYOZIPlEy/n0d3z11TVYw2AqRFDAEyOhQMN2LNaMysCyy9+IuU8VTRU0ibvsiVJTxdzNjiwk5J9sQxt8aIfS5M0kr6
 owti4VHC
 b5rr5EAmjOFN7ncGg6wHG52NZQY35zql7n72HxbSqYdzk/F1DDYIPt13JNxN8AfLj2U/XLuEI9xC/BU5zPWCuqptyKRWgg7yIl+8/GWGHRGbgdLXCcavta3Oi/iVw3puJm7k0N405XGBKjXqgEz98jqgKUghhsbkqmWcQuxXKnYWDVY9bjk9X5TTUndmbrZWKgv9fACiu6CtPq2+FU8rP+hhfXbK4zTCL3hC84YT6X0Q/O27bU2MUlcY/HYSjrNxL6oGKTFFS/L4DxaP9Rf7/FooNEmD0s92u1g8NqZcChGVMCtn7AX91svdufzknuMblu4fKNcm02ZNlAZC55DnP35VJ7y5o1vkX43869HhD0QJnqYAPM8SZzWx+jlD5p0HTiwLfGkEfdmuREtZhfZz5kW27N8JnViPN37w4XPkI7aqjaBEVKQDD7vXf/sLOV86TL1rTu6fGilezDmLIc1SU0VQJpx5rHXHuoQY1WwF1rV6d0rQ8cL10mVzFjiQsBXKqGqxvHN9QytqAQGWGLVxk2mdt4iM7lJNLWrGOBNeRScHkgie5JRbGfbx5JCxmZeml3G+KlmWAPRZzCMgD5zuOW2q8V8J0C1UP29SHPqPNL/ueqDMo7dbejKLG8Z5nwhJs8y68caVyCjxCzUBKoQvEJR/NrDFPxTDJx95mAjOK0W+rXxAN28rtfzW9ZvKfCMJrxoxGcx+MO+IBG9E1hQqvgDUFsQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2026-08-21 23:58, Bradley Morgan wrote:
> On 21 August 2026 10:22:08 BST, Jérémy Jean
> <Jeremy.Jean@oss.cyber.gouv.fr> wrote:
>> From: Jérémy Jean <Jeremy.Jean@oss.cyber.gouv.fr>
>> 
>> dup_task_struct() copies the parent's task_struct, including 
>> ret_stack.
>> ftrace_graph_init_task() clears the copied function graph state, but 
>> it
>> currently runs after copy_exec_state().
>> 
>> For non-CLONE_VM forks, copy_exec_state() allocates a new 
>> task_exec_state.
>> If that allocation fails, copy_process() reaches bad_fork_free and
>> free_task() calls ftrace_graph_exit_task(). Since the child still 
>> carries
>> the parent's ret_stack pointer, the unwind frees the parent's active
>> function graph return stack. The parent subsequently accesses freed 
>> memory
>> from function_graph_enter_regs(). KASAN reports a UAF.
> 
> 
> Ugh, real one.
> dup_task_struct() does
> *tsk = *orig so the child inherits the parent's ret_stack,
> task_exec_state_copy() can return -ENOMEM, and free_task() calls
> ftrace_graph_exit_task() unconditionally, so the child happily frees
> the parent's return stack. Exactly as described.
> 
>> Initialize the child function graph state immediately after
>> dup_task_struct(), before the first fallible operation.
> 
> Good! The alloc inside ftrace_graph_init_task() swallows its own
> failure, so moving it earlier adds no new error path.
> 
>> Fixes: 6b1c66c9cca9 ("exec_state: relocate dumpable information")
> 
> Tag is right, before that commit nothing between dup_task_struct() and
> the init call could fail.
> 
>> Assisted-by: Codex:gpt-5
> 
> Love you declared AI
> 
> If you still have the KASAN report, pasting it in would help the folks
> applying this see it is real and not theoretical.
> 
>> diff --git a/kernel/fork.c b/kernel/fork.c
>> --- a/kernel/fork.c
>> +++ b/kernel/fork.c
>> @@ -2139,6 +2139,7 @@ __latent_entropy struct task_struct 
>> *copy_process(
>>  p = dup_task_struct(current, node);
>>  if (!p)
>>   goto fork_out;
>> + ftrace_graph_init_task(p);
> 
> One small ask, feel free to bikeshed: nobody is going to remember why
> this call has to sit before copy_exec_state(), and the next reorder
> breaks it again. Something like:
> 
>  /*
>   * Must run before the first fallible op, so error paths never
>   * free the parent's ret_stack.
>   */
>  ftrace_graph_init_task(p);
> 
> With or without that, idc ..
> 
> Reviewed-by: Bradley Morgan <include@grrlz.net>
> 
> Thanks!

Hello Bradley,

Many thanks for your feedback and advices.
I will send a v2 shortly.

Regards,
Jérémy


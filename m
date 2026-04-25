Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 037BAFF885C
	for <linux-mm@archiver.kernel.org>; Sat, 25 Apr 2026 14:51:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B64196B0088; Sat, 25 Apr 2026 10:51:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AEC8C6B008A; Sat, 25 Apr 2026 10:51:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9DDF26B008C; Sat, 25 Apr 2026 10:51:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 8BA836B0088
	for <linux-mm@kvack.org>; Sat, 25 Apr 2026 10:51:42 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id E2FD640361
	for <linux-mm@kvack.org>; Sat, 25 Apr 2026 14:51:41 +0000 (UTC)
X-FDA: 84697367202.09.2816E95
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf14.hostedemail.com (Postfix) with ESMTP id 20A6B100002
	for <linux-mm@kvack.org>; Sat, 25 Apr 2026 14:51:40 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=GQo7VRwW;
	spf=pass (imf14.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777128700;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=L2HCP5k1Kp8V9+1zY4aQLj2CYq5NCIFiCI2Z3ujZYF8=;
	b=H53mjRXAVtv4HwZJPDyOIcnd53XntVqmBkwigQxr+qyeneykxfEdklXkhIbSEmM6A90fza
	0xpgzTASd8pdmkrC8NQs2PxRuzdho+vpFoy4FjjGTdTyfxvTQRWY6SxaSh5PwBgGszDb+R
	iXnK9NwhyFrCY/b8jmD4Chb+N0E4sME=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=GQo7VRwW;
	spf=pass (imf14.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777128700; a=rsa-sha256;
	cv=none;
	b=V82LBiTS16Ymg3ysiEhof5t/TaCwxgxk2BdLZrhzZKytfTNgRDzcft9F2VQbDzcTVRnShf
	gvsimdmsaLJu/5h/mPAy3/7JNfXCiFhMYGHL7I+U2/AnnjR5BXswOd//dmIi6ytV6iemY6
	LR4XXml7AGBbQP2Hm3OBGf1BG/ma/Zc=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 679C560055;
	Sat, 25 Apr 2026 14:51:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B32DC2BCB0;
	Sat, 25 Apr 2026 14:51:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1777128699;
	bh=+6WrDJNhpjLA9Cjrh0c4iMzpktx8eQkS6lHL+YB99R8=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=GQo7VRwW//RaAfn1ZjdoQDPRYt9XRE9UAmNmowegV8cLgNaCe4UiiQfS1yZKlpFco
	 byEO+XEqNn+tqFt91qVuZ76kQa8M9w2YpxPgZ//q6XfaO9xe0qvwFw79KXrkxV0vxK
	 IBoS947Nmv+zbCE/cunoDkY2fNWteqiYesh6T1t4=
Date: Sat, 25 Apr 2026 07:51:38 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Jiayuan Liang <ljykernel@163.com>
Cc: linux-mm@kvack.org
Subject: Re: [PATCH v2] mm/page_owner: warn when stack trace depth hits
 PAGE_OWNER_STACK_DEPTH limit
Message-Id: <20260425075138.7944ef19986414cc01991f79@linux-foundation.org>
In-Reply-To: <20260328214408.2990597-1-ljykernel@163.com>
References: <20260328214408.2990597-1-ljykernel@163.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 20A6B100002
X-Rspam-User: 
X-Stat-Signature: mdgs598bjkap5mwdudbpp193b7p5zxqs
X-HE-Tag: 1777128699-701844
X-HE-Meta: U2FsdGVkX1+aBpj8VLSj1gnGlgNW6q82ykl33I6KUbu4a1qQQ7jICNi2pMqxk2tUK5UzNam5FH7Op1yuV77VDvV96FtzWIQFrNmZs6dLQRmUg4zxqXugouvE2Le0Klypfz21f1l7vJ3mnGg68+IfLaLs3/4d7+rKIKQfl4pPyqLveDJe3L6kM5qgy1tMJd9X60ANd8Y2n5OQAl5G8TtXo204S5uFzXOaeXNaIUTu9eTon8G0Cy3X80opRpY6rl/iF7smGaHUqsbZd4Wg+FX4a8m0+ZQgW11ONXYj+8mZAO3O+FZpUu9g9+XiqKr9wx6DZ9cmiL1W9pVlwkloG4qGhEV3NeCbhIKZLKwTCisMcRCoRE9auqavw8pw7UpyhpQZeWBKVkzvExdZyd/M/X7sfXpByZTNueyd89HHUGpsyeI94qDXlkyZDabNtewPLWxTBVp6MMvzKW191IXj31aUpxNvHbCrwxmECkY8Y/r3tDR5RVSpN0NOOulEkY2EPBsZwHGWjGT2qN/HD3vQBFN/KmXEIZVaNoqEXcKc9A8kteEjKTi4fX7imwQO/aYf+f1SivbaikUIhHB8Ip6u8vAcsF023YH5w/L4pum/VW+DJB4hCYLz/7qqNmFgYndLchjdV8W1Hltm1TkFpCIduFddeKKims5iID7eH8L53Qwcf5mlgroyWz3tN9IiZLN9kxUS2XZwbVwZaWxz8fPXZkCbBOToe5nJDcuHB4+HvZFGYPwFMdDB6+h8dOHsBt4FcLt7zmVo9XwZCLh4W+ak5fO4xfXNAOOgejOs9EIda0FcBecGi/yzigm/XrOMPZNYjTBeM11Lu6zuKbqh5qVHlWx50NYsUC0KRq8b/I3Ei6fDAiO1zHTm/DM9rwD07JWP8h8kJcqqkEKMwwh5JHhHsrH2+cTM2Cx9eqJBDgvbKO64ZdsMaDaP998EQwVDGASw7uGXZms5RBeGjMBpycUDCmn
 RlOF3mhM
 biztJwoFf/ER9SSYKGKo6RpgE+/YYwSTuHjiH+7W9tpO6Tsdsls70OaeLqQYV30P58vKR5zwXV/Jlk8zwokdSNTePIc2E3FSfDlkRvXEaXHfyqd6D3BxEEH72M9oPhSGFemXUUweSbl1CiwjK5N3OPtOnoj7eGHwCM6RTEzi5qt9rhiVatMsf5OzsGvukc2qvUPyNqw8l/uKqoqSpotogH3FUlsTprf6RXTlzBsIOL8RSfDRDhEC7k1FgYF3uODZozNEekT+WhpYgCI6PtA4fw2Cd5UjAydNTpeJ6Zz3tmE66cabGp5GRIgspRwPvBm+QJ/aP
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, 29 Mar 2026 05:44:08 +0800 Jiayuan Liang <ljykernel@163.com> wrote:

> page_owner silently truncates stack traces deeper than
> PAGE_OWNER_STACK_DEPTH (16), which hides root caller information during
> memory debugging.
> 
> Add a ratelimited warning to notify developers when this truncation occurs.
> 
> ...
>
> --- a/mm/page_owner.c
> +++ b/mm/page_owner.c
> @@ -163,6 +163,9 @@ static noinline depot_stack_handle_t save_stack(gfp_t flags)
>  
>  	set_current_in_page_owner();
>  	nr_entries = stack_trace_save(entries, ARRAY_SIZE(entries), 2);
> +	if (nr_entries >= PAGE_OWNER_STACK_DEPTH)
> +		pr_warn_ratelimited("page_owner: stack depth %u exceeds limit %u\n",
> +			nr_entries, PAGE_OWNER_STACK_DEPTH);
>  	handle = stack_depot_save(entries, nr_entries, flags);
>  	if (!handle)
>  		handle = failure_handle;

Does this actually work?  stack_trace_save() kerneldoc says

 * Return: Number of trace entries stored.

so

- if there were exactly PAGE_OWNER_STACK_DEPTH entries available,
  stack_trace_save() will return PAGE_OWNER_STACK_DEPTH and the
  proposed code will incorrectly warn.

- if there were more than PAGE_OWNER_STACK_DEPTH entries available,
  stack_trace_save() will again return PAGE_OWNER_STACK_DEPTH and the
  warning is appropriate.

IOW, the stack_trace_save() API doesn't actually permit the caller to
determine whether the result was truncated?

A good fix would be to change the stack_trace_save() API so that it
returns the number of entries which it *wanted* to save.  Then the
caller can see that this is larger than the passed-in size and then
warn.

A lame "fix" would be

	if (nr_entries == PAGE_OWNER_STACK_DEPTH)
		pr_warn_ratelimited("page_owner: stack might be truncated");




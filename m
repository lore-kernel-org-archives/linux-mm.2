Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C3210CA0EFC
	for <linux-mm@archiver.kernel.org>; Thu, 21 Aug 2025 16:43:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1C6FC8E000F; Thu, 21 Aug 2025 12:43:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 19E8A8E0001; Thu, 21 Aug 2025 12:43:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0DBFA8E000F; Thu, 21 Aug 2025 12:43:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id F03DA8E0001
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 12:43:27 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 7137058C81
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 16:43:27 +0000 (UTC)
X-FDA: 83801335254.24.6414802
Received: from relay.hostedemail.com (unirelay10 [10.200.18.73])
	by imf24.hostedemail.com (Postfix) with ESMTP id A4FA6180003
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 16:43:25 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755794605;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=aV5BsEEmAuXCwu5BF2OY3/+wGTOE95OUYQVd4MZ8B28=;
	b=OMlFlmibHX5Vj4CdoyFawvGLrh0rcONB8G7oEeB2Xgxn4Y4/f6PGTI6fpFSx1ofvTSQwjc
	ZZmJfLh4zMkdKkP4/KlerUD0y8hGFIkiKhwIAAfpcEQqj/wIrLs69IlPfnNLk1TvUOgN4z
	5/YJB3/pgUStxPX892uvlo/PxGsUxkk=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755794605; a=rsa-sha256;
	cv=none;
	b=Oy/y9GRktBcDryrrxjyqodwSHRViah87e1P5/3qO5YCbTfnxmQ+5vvJhRQd/NiiCWQqqCh
	IPv9wXF8FDJBE847c5FSlPkgO69w8d4lrRGSx41dvPleOwZDZjkUK9QVU09VYtwy5SRkSu
	krWMuo0HHEia3VfdFNl5h9uAroacg6Y=
Received: from omf10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id BCE8BC04A4;
	Thu, 21 Aug 2025 16:43:21 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: rostedt@goodmis.org) by omf10.hostedemail.com (Postfix) with ESMTPA id AAB9B41;
	Thu, 21 Aug 2025 16:43:14 +0000 (UTC)
Date: Thu, 21 Aug 2025 12:43:19 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Bhupesh <bhupesh@igalia.com>
Cc: akpm@linux-foundation.org, kernel-dev@igalia.com,
 linux-kernel@vger.kernel.org, bpf@vger.kernel.org,
 linux-perf-users@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 linux-mm@kvack.org, oliver.sang@intel.com, lkp@intel.com,
 laoar.shao@gmail.com, pmladek@suse.com, mathieu.desnoyers@efficios.com,
 arnaldo.melo@gmail.com, alexei.starovoitov@gmail.com,
 andrii.nakryiko@gmail.com, mirq-linux@rere.qmqm.pl, peterz@infradead.org,
 willy@infradead.org, david@redhat.com, viro@zeniv.linux.org.uk,
 keescook@chromium.org, ebiederm@xmission.com, brauner@kernel.org,
 jack@suse.cz, mingo@redhat.com, juri.lelli@redhat.com, bsegall@google.com,
 mgorman@suse.de, vschneid@redhat.com, linux-trace-kernel@vger.kernel.org,
 kees@kernel.org, torvalds@linux-foundation.org
Subject: Re: [PATCH v8 4/5] treewide: Switch memcpy() users of 'task->comm'
 to a more safer implementation
Message-ID: <20250821124319.07843e17@gandalf.local.home>
In-Reply-To: <20250821102152.323367-5-bhupesh@igalia.com>
References: <20250821102152.323367-1-bhupesh@igalia.com>
	<20250821102152.323367-5-bhupesh@igalia.com>
X-Mailer: Claws Mail 3.20.0git84 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Session-Marker: 726F737465647440676F6F646D69732E6F7267
X-Session-ID: U2FsdGVkX1+mRtTllI9WHAwDf6lxFlPKg37+M3gy9xo=
X-HE-Meta: U2FsdGVkX18d4x1NK/MTRDnXGK4K44au4CLBgnuOsLPMQS97oEClGF08S1UQPBqAXUhOYT2+eq5/sAi1mgXdeKmHe3pcFulqgI53Ec4Rb67snLuAtLtfVEavfPmRoD5y7JYHmGcn4Hro2p6dSjq/gIi4DyWBoVzCq3mxjRVILe6FugSo/lVjVT/il2NZmD1RMZHIRrrhVfKMIF217v1uQBErnO0+KI+hW1t4ZB4lPrmLe/Kkw2XO1RYIw7qhRDsjjiko4PcHZx8Idw7WLpJYEFX460Pa2NxLzazRNb+PG3fgUrLoiUP922YDshk8ps52PLY+fC+cpSKl/2qsrZy3Iu9bWaI9/zhmCvlMP6SAHTFm1f+GPmbrHkxx6vkxlhCB
X-Stat-Signature: 1oa1t5qqbkks8kqanx8ka8mut54jjjfi
X-Rspam-User: 
X-Rspamd-Queue-Id: A4FA6180003
X-HE-Tag-Orig: 1755794594-825770
X-Rspamd-Server: rspam01
X-HE-Tag: 1755794605-287881
X-HE-Meta: U2FsdGVkX18ILj5yfit9mK3QjIWiKzAVb1dlcnXf3V4LrGClQCj3L/OWo76TaPeRULu6KLjROcT+FmooD5iJDdZTJcLcsw2FJTOlpR0Ae1Eq2VtK1IM52SmivHfcJnrcoHWJQKdXJMcOFVfeI5mJVRRr5DsILB8fEj9JPmOC9MvW6HJEy/Fz0Yx189yjJDkg3H8e1IMIFgkriSzdGk7wxwRSx49rPlgnciZMJ4ddChKLv1PZZdNW01xwubqNNgNzVjJuIEoKm2+w+TK6BGbgCFCdabPCgwE84hfaY23asWAEONfl6PZIQ9Kikd7ZQ/4/SehpEGuk5ZCJ7xtnq3siR5iNFceY1FieuE46fD5L2XHkVHwY/hq9yo7KegDvD/iLiub5uEmUfRNOS/X4L0aHdHY/wVKt6XZwUaKZB7WpABd2B9jZQyzsL+smtmHR1CAHP5OMfTDnd4Hyt/rcE5W9ySEZnGLBwIGaPJfCvyIOFHCxjOE08vkVGpt5nSd74hDcDqnY74aoMWjTMh26p25p6Ugl9vWxvwxMCWdpZzdTFYsB+5jzUUvV5/OLLXnEHp8Az7x5KfEwwhlLCT9W2VuUYy4SNJZtBznZz4la591GhWiBNI52qVC/DWWUxDD06pfeKUuirfeR5bfGnLuv89WhR8RNHB3sw9wJjj1YpyI/GjaiiT8EH0ijQvcJkoYMNq89omuQldZhfyylNb6KASIf3wSLkjFhuOhYwwYC6L3SSeiwsc6OYxMlUx6a6ucFbUdMeymfqlCNzOD7QFsUe55K96MepYfOab3HgUwzsAGH5wDPwyddnXgtEYEJkA3MLtaMNjc88SU6DiRNZN3zJeJCYYSNG7l8wDXNBAR54qGq0OzgYZeq42sb4TENs0GFoy+xLerL1hiXHwITdxxHrem/FGGCSdtHv8/SjTkcS75BaKfoxMlRG2xmF5n1bWSJ29uZKNWtetBnxVC3c8Gj4v1
 0mGzUIpd
 UvQSPgJH9Wa/23dyfbA4jB/LQtvjTVEKuBzLcIl8ijSS0A1Zy/oGy3BXsmLhYZdi8UkD4
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 21 Aug 2025 15:51:51 +0530
Bhupesh <bhupesh@igalia.com> wrote:

> +static __always_inline void
> +	__cstr_array_copy(char *dst, const char *src,
> +			  __kernel_size_t size)
> +{
> +	memcpy(dst, src, size);
> +	dst[size] = 0;

Shouldn't this be: dst[size - 1] = 0;

?

Perhaps also add:

	BUILD_BUG_ON(size == 0);

-- Steve

> +}
> +


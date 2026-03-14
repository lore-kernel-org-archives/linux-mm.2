Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 83ABE107BCD1
	for <linux-mm@archiver.kernel.org>; Sat, 14 Mar 2026 00:42:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AE8506B0088; Fri, 13 Mar 2026 20:42:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A96006B0089; Fri, 13 Mar 2026 20:42:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 98E956B008A; Fri, 13 Mar 2026 20:42:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 88AE96B0088
	for <linux-mm@kvack.org>; Fri, 13 Mar 2026 20:42:30 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 4D45EB914A
	for <linux-mm@kvack.org>; Sat, 14 Mar 2026 00:42:30 +0000 (UTC)
X-FDA: 84542817660.02.47D2F98
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf20.hostedemail.com (Postfix) with ESMTP id 98EDA1C0002
	for <linux-mm@kvack.org>; Sat, 14 Mar 2026 00:42:28 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Z6poEW9+;
	spf=pass (imf20.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773448948;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=q94vVA9e/sHdbL9rGqCKHBVU7E3vQZVo62Mmi93h5P8=;
	b=I94s4Xs6YRcWAJ8nKBUwHnjuVA8XOwJ07WM6fxo5E5B/jqnE5d3yt85zFtGHFRkYVioqlT
	iH/oxENWTiVAEGpA5aB//14cZ+dk43tFCvGHt5oumaAE+fDfwazq8qk5fDF1H/bCg8tXtI
	sKlUA59xItH0EonDTqZMuZ38msQNIg4=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Z6poEW9+;
	spf=pass (imf20.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773448948; a=rsa-sha256;
	cv=none;
	b=2APWZCZsJfrbOIP9QNAz9Gfz51rTvtj8lZurlsScP6Ya2K354vFW7a/aKZ9ryIioMRIVIU
	FpScpSB4JYvwb/bC2r3F+E+TeUqEXgZo03AHiIYDjTSgUtpdtiNQ+eB5hRZGyrg5Cn1vac
	x87b72tnLoWefwxoqbC51Uc1g8WiLwY=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 82DBD43E3C;
	Sat, 14 Mar 2026 00:42:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31BE8C19421;
	Sat, 14 Mar 2026 00:42:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773448947;
	bh=ePAgfPiEp28gS3ZigJ1iIT61qD0VqK2kCenISk7TpYI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Z6poEW9+snTWcDGfIaO7P/4K9QmzGjMan/mIuzIEISA3IAYJz6TPrG5hKt79TjLao
	 abzFi5WH6g3H9w94w7nsp3QhOCRu+0/lc/DAGZ45b09V4R6QCcKIL99pmG58eR1xeV
	 OGCEAbTU9GNvxb8EsBWUval1ct568Xy7ojYmI8YlvDk3yUDju/EPicjtgwj/Uyl3R0
	 a299qWcagFUENjKBrzoE4AwqKIIsy982BxJb7ZCdwOaPoWLiqgufl9TJ48lqiTklWW
	 iiVfTsCUhX6hZGZzalkWhGiw8sbDRjH3s2BuL4yNUEouDH8Eb1keQ0fcNWp/EiCusk
	 Qg14FRjvght/Q==
From: SeongJae Park <sj@kernel.org>
To: "Guilherme G. Piccoli" <gpiccoli@igalia.com>
Cc: SeongJae Park <sj@kernel.org>,
	rppt@kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	kernel-dev@igalia.com,
	kernel@gpiccoli.net,
	Andrew Morton <akpm@linux-foundation.org>,
	Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH V2 2/2] mm/memblock: Add reserve_mem debugfs info
Date: Fri, 13 Mar 2026 17:42:23 -0700
Message-ID: <20260314004224.80693-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <62b3bcca-7e4b-09ce-4996-5b67f066e123@igalia.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 98EDA1C0002
X-Stat-Signature: wqztzb59tzkd5hz45wwo8y76guy6td63
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1773448948-880689
X-HE-Meta: U2FsdGVkX188Y/TQaT0TkI3h27BqN4/mWMPvJT2CHChr5FgHPUBS805VI3Z+j6oUlF28Tf1xt/wFaqe6j2zbG+EcsMpT8yuGHhw9LWMkqEY/pfnjsdEp1qfklYAo8celzc/txgfToJ+K04wTCpNJpYJ8cBK8dRIn5L5NHcCLkBkoVG/FRqD/335Hf6ZEqMsvTb/hRewf+LZbNGjqcd0+5ya9H/ABrvahqF76y5m4XUQiAFFeaJFRon0Q4KEGzt4ep0ucLvtkYZjfgEdaMqQxW+AxsUoRgy2k+SiyL6t4n53xRwx8mmN45lhMJffQeVpvJQnEqGYEe04lrAjy2jAj9RPKL7Z+B79ZHKZ/E2p25qhpuFR4WMHnR5eEFShHrQEH64gQATMHZl/4SFt2Wz/vvTGm3by9BWrovCqfYBPeTYacfWr4kcIgA4zyqQha8+0UG006WB/npXAMmbm5O4/cDdSUaiuU/IAXnsOaa97N2UTCZvxTZ01ZkML9E133nqa/W0WrhGInTf3quHBqLvBV5eO559MzSc+YU+SF0gRTsqWMyQZs84X6US2MRKxZrOg8bfPEK6AxXmRDvU4uGOWlkaysuH8ZeqCxbJFpIJqyylomrXB/j6LgPxkf5SFz1Y9gLYYw/G+VeytKwo0WE6kkeoSbMLNhbIjfkxzdB6pY20AHg07RD3Im63eTIx5o1lCEeXPUerPMntgPtahzMFINXE182KEBoE1ZcvytDSLkhilb5o7c5tdzczRFI4bUW3ba+XCqEHC4nfoPdzTLoimDXYz9AZl7q6K5X+2kucMQ6spQWGhY92QZeEQJ6GHgzO/IspGdkB0wmcXNY9Uc6Q/kbmQ4pGSPwAKY5dW2/PHIra7H28KS6uV9mLkvQ6tkgPDJpPnB+h21dRzIbs0zo/+vprmLqKDuWplZfyD7LY6diospIE0MLW+Qdz27/zs3A6Qsv/VnWVeTjMD8yW7q7h2
 Y7ccTLD+
 5wwtYUPchjzDZxqgVOQRtMmqSGnRO+JPBzt83e47t8K5qlnKsQnUt+V2uGgQjZgdwc0bnRV/goJUFEN68Hcno+9ntq48W0spOj1CBSNWW/Th3JgGuS/dC3+rxl+Zul8k9hPrDZ1QQUI+jAp4LSIoSo5dJSg/a58gXWo8H9xzN6x/ZBJAkXsF7wrbg4SXtF9dWpgecJZwYJP8yH+Vfo913M1+H57S7IvkJNh7tXfkDDtURg5Ju6gd4JeTeRGT1YB1snAXlwQ81M9SgJVlyWq2JSdU6mFkHZums0n22lHlnaSjXIuZ1X6TC1ZMdVg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 13 Mar 2026 18:09:10 -0300 "Guilherme G. Piccoli" <gpiccoli@igalia.com> wrote:

> Hi SJ and Mike, thanks for both your review! I'll respond the 2 messages
> here.
> 
> First regarding Mike's concern from the other email:
> 
> >> +#include <linux/string_helpers.h>
> >This will break tests in tools/testing/memblock, please add a stub there.
> 
> Sure, will do it!
> 
> On 04/03/2026 22:44, SeongJae Park wrote:
> >[...]
> >> There is no easy way to determine if this kernel parameter is properly
> >> set though; the kernel doesn't show information about this memory in
> >> memblock debugfs, neither in /proc/iomem nor dmesg. This is a relevant
> >> information for tools like kdumpst[0], to determine if it's reliable
> >> to use the reserved area as ramoops persistent storage; checking only
> >> /proc/cmdline is not sufficient as it doesn't tell if the reservation
> >> effectively succeeded or not.
> > 
> > Asking out of curiosity.  The previous patch has added the error log for
> > failure cases.  Could checking the kernel log to see if it was failed be an
> > option?
> > 
> > I think this debugfs approach is easier to check for the user space, though.
> > If that is the reason of this patch, adding the clarity would be nice for a
> > theoretical case that debugfs cannot be mounted.
> >
> 
> Exactly that! Not only debugfs way is more convenient for checking that,
> but it feels a bit weird for me to assume the reservation worked by
> checking for errors and if none, all fine. It's valid, but as a matter
> of taste, I prefer checking the file. And not only that: imagine we have
> more than one setting in the cmdline, for other usages like ftrace.
> Easier to have the debugfs showing the succeeding ones, by name and
> size, ready to be used heheh

Makes sense to me, thank you for kindly clarifying this! :)

> 
> Do you have a suggestion on how should I mention this in the commit
> message? Is that discussion enough maybe, for future reference? I feel
> mentioning that userspace will use the information from the file seems
> enough for a commit message; but I'm totally open for your suggestions
> on how to improve the wording here

The above clarification on this thread is good enough for me.

> 
> 
> >> +	if (!(IS_ENABLED(CONFIG_ARCH_KEEP_MEMBLOCK) || reserved_mem_count))
> >> +		return 0;
> > 
> > One trivial comment.  I'd slightly prefer having one less parentheses level as
> > a tradeoff of having one more exclamation mark, e.g.,
> > 
> >     if (!IS_ENABLED(CONFIG_ARCH_KEEP_MEMBLOCK) && !reserved_mem_count)
> > 
> 
> Good! Unless Mike is against that, I can easily change it.
> 
> 
> > 
> > So, we get two level of nested ifdef...  I'm wondering if returning earlier
> > when CONFIG_ARCH_KEEP_MEMBLOCK is undefined is easier to read.  E.g.,
> > 
> > 	#ifndef CONFIG_ARCH_KEEP_MEMBLOCK
> > 		return 0;
> > 	#endif
> > 
> > 		debugfs_create_file("memory", 0444, root,
> > 	[...]
> > 
> >>  	return 0;
> > 
> > Very trivial comment.  Why don't you keep the original blank line above the
> > return statemtnt?
> > 
> 
> About the ifdefs, as per Mike's comment, I'll rework it in a helper. And
> the blank like, I have no answer heh
> Likely a braino? I can certainly keep it.

Sounds good!

> 
> Thanks again you two for the suggestions,

:)


Thanks,
SJ

[...]


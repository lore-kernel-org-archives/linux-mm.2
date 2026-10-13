Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 44188CC6B0F
	for <linux-mm@archiver.kernel.org>; Tue, 13 Oct 2026 14:09:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 897DD6B0088; Tue, 13 Oct 2026 10:09:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 848D86B008A; Tue, 13 Oct 2026 10:09:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 75E476B008C; Tue, 13 Oct 2026 10:09:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 431776B0088
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 10:09:14 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 2E40D80BF2
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 14:09:13 +0000 (UTC)
X-FDA: 85317784986.18.01CF584
Received: from mail.hallyn.com (mail.hallyn.com [178.63.66.53])
	by imf31.hostedemail.com (Postfix) with ESMTP id 13E1D20009
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 14:09:10 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=hallyn.com header.s=mail header.b=kL9ibrJg;
	dmarc=pass (policy=reject) header.from=hallyn.com;
	spf=pass (imf31.hostedemail.com: domain of serge@hallyn.com designates 178.63.66.53 as permitted sender) smtp.mailfrom=serge@hallyn.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791900551;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=w6ZuGJpO3JerCueQneSa/3vKnDAJukJFeI8mWhm4kYU=;
	b=RsC2QtfpzKHnMlo0fYLGYwT/QAkHHQlvF51fAj5OzSdGBLX8lYXAUEnJpF+eqPkb6yC2wh
	X7neK1j0oVhnZBQ6WuJd7hG3VEb66bHNbaS2EqDZeGETJfHhn/ZpaVqQg3gQiP8tnisSD4
	dNfFi5ch22WccgqLwYWNAkKumvQhM4A=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=hallyn.com header.s=mail header.b=kL9ibrJg;
	dmarc=pass (policy=reject) header.from=hallyn.com;
	spf=pass (imf31.hostedemail.com: domain of serge@hallyn.com designates 178.63.66.53 as permitted sender) smtp.mailfrom=serge@hallyn.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791900551;
	b=DnfsIn5bJ7a5vzNPTJX/bDS1/oQKRHhUH9HFuu3g2fiwliuNaFIAnvVs3J/0Iu+OaI0hZ6
	wJ648p45TN24F7ABAQR5qlJhK7b1C+HVGzWkw2JGr0j4ghpSFlly8Ulmn+MBwWs/SoIYxy
	ejN2dGA1GAnBg+wKt5Bgl7mSXDK+5xk=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=hallyn.com; s=mail;
	t=1791900547; bh=Suo0YfCYPtCoLBJ8iZXRfc+dw40jvIHLkG13JRnjZUY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=kL9ibrJga4YY3RAquWvtOegRsAK6JNwI4zXpQH4mv6j2Vsk9CY8qfIhLg/GbWf10M
	 DeXquRyTooElnL5wcZ6eBAgd3kldWf1/1DVrk/QnE7SSW6X/eN/0nBES3D+BgjTlUU
	 C/Rx2MZe3C0Slal4i45wXX+ZGEjf9NEkolx65kLPAJurAwcIqT7Fgf9sZxk/YpgtAy
	 XDKHXmjY/8nxliaKEOZl8gn/L8ISgxycaCqcVMdYGSSfKRj3VaBKUpf5cLXmVPw2xG
	 o/e7XKeKzb8AwNvzLFiFE90IPPcFzQuMfwogAUoL6N27g/9+hdqYmLbjfnu+6mI3om
	 KyZ826JuJNe2w==
Received: by mail.hallyn.com (Postfix, from userid 1001)
	id 2638A6FA; Tue, 13 Oct 2026 09:09:07 -0500 (CDT)
Date: Tue, 13 Oct 2026 09:09:07 -0500
From: "Serge E. Hallyn" <serge@hallyn.com>
To: Jinjie Ruan <ruanjinjie@huawei.com>
Cc: kees@kernel.org, akpm@linux-foundation.org, david@kernel.org,
	ljs@kernel.org, liam@infradead.org, vbabka@kernel.org,
	rppt@kernel.org, surenb@google.com, mhocko@suse.com,
	mingo@redhat.com, peterz@infradead.org, juri.lelli@redhat.com,
	vincent.guittot@linaro.org, dietmar.eggemann@arm.com,
	rostedt@goodmis.org, bsegall@google.com, mgorman@suse.de,
	vschneid@redhat.com, kprateek.nayak@amd.com, paul@paul-moore.com,
	jmorris@namei.org, shuah@kernel.org, oleg@redhat.com,
	brauner@kernel.org, alexjlzheng@tencent.com, jannh@google.com,
	jaime.saguillo@gmail.com, elver@google.com, blbllhy@gmail.com,
	bvanassche@acm.org, pjw@kernel.org, broonie@kernel.org,
	debug@rivosinc.com, tglx@kernel.org, aleksey.oladko@virtuozzo.com,
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-security-module@vger.kernel.org, linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org, morgan@kernel.org
Subject: Re: [RFC PATCH v2 0/3] security: Add PR_CAPBSET_DROP_MASK
Message-ID: <as47g9Ofa7hgDDLp@hallyn.com>
References: <20260929130200.1638343-1-ruanjinjie@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260929130200.1638343-1-ruanjinjie@huawei.com>
X-Rspamd-Queue-Id: 13E1D20009
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-Stat-Signature: s643hkxq7s4e1fpthco5nb9jw68ydewg
X-HE-Tag: 1791900550-43831
X-HE-Meta: U2FsdGVkX1/0IjOC93bYyjgsZgAWKHTliwp0tTSFF+V4RpaOkDS0qEplVOCmZLKHRBnKcB2bjIovikfiOkBhDMxHuPwi3CM9A/LS4GC/0gPmwE3EKAqqnAI55nYUt3MDXNqDRqhcCM3unyQPeBVSBnyTb/g0xYBmdUUKF3ZIDBuC15Bj/5iwOjVWxAJDc8tCYknDutE6laGUfaeO0hfA4V2k/QYHjc4Qkeuh9R9PpgxdyR/FbPGP/ZOAGJejogfXf+93UsJZgbyJaf3BwbBikIajtA88ent1HN7X4DSJ/QA/08ZdN+DadH5T4FQHJo+Uv4iIbi9zH/eHOPfDPA3E1z6hYe6gL8DHB/pVGcBDYQswpI9ESwxnCLaFf910aGosTTqEMO1noFi5K0/f23K+vHmSBz5K3dKHftuUW7TaiALtfCHYKN8in5AZ1wD+vjnvUibnAddZ9e40lsEWWhCbZ7lKOmvJMDUTu6hD5HznCnZ6MGM6tFbOjl7b9MwQww44qiukKzh9PXIvZceuQIeHEq019yvYmTVVxTIdQSki6XMexsEvKRdpi/F6Ys1ddVNMRX/6AkPK6Vk2URo4I2hlt8Zn0U8Ffxa74mtp4ftRVe4Tr/ddr4+3J8tAeTcj8JGjdQ6Hp2xhJ5CgaaOluJ5lbZI6XkuzY1WjV9DtSJJqFTXQtDNwLT5kmGCSlcB4HOo1JQgU2awyz8N80CFag78Rfeo/m1tHN3x84x+3Pe8WbLNmPd8P0nOMkPrpRa3PlZR/qvS/re0Pw139nV1S3TXqZ34nwRBKknflyhpx7nqz8CW8rZL3Uqu3WpwdgADtEBvZxAqsnLy8EhLnUNcCDhvGcxKuiVfiSGohT0S2wKlqUnWHh6B5BjngtityAnKr7M3q8LojejOnHShjpHs+AT7Bs4D5R4s6AjbiGTBrayn8Cpknykl9OIIaa2HpGVR+W+48xI+fVDTGnHuMvVd11/p
 p8o/5f+/
 YG/8QmMrTYO8p/JXUW/sC1elUq3z6UpOhf8K9Wqk7+TUJjKusm3J43YY1onI/nSwV83tIlWrOEuMJRjDRhGHf0INk0ezDZ//chTy45PH/Ke1DXk9CDhzqLeuQXvSKPjO0RPzvzlcxxMvwIeg+ymNUKU3sd4Z8MeB203dokf+ZRdm/wcAkpr+FCUvNLTKCo1hla7CP99m7mUn7oO5S11KShA12siMlQcdFcjhRVKDdg0tXsuiLRCNLfYKiWolCKk3x+u/O+GQ2yogGsKNQXBZ0fIW8cZ+qlERpWrjjDguFDqbwYWy8paSc+0HW3fcYvfhfZ3RbP6YsnfJJDh9WZVs5gJT9zxrIf6upwSntk4hFytTd7iCr0zEXJwhwKwc3LuypiZJEVmhZvJ9+p6DC3DiuTbwc8FNfdqfevp+Q678IzgKv0YmyLq0n4YX73w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 29, 2026 at 09:01:57PM +0800, Jinjie Ruan wrote:
> PR_CAPBSET_DROP only affects the calling thread, so dropping capabilities
> for a whole process means one call per capability per thread.  For a
> long-lived, multi-threaded process such as gVisor's sentry this is
> stop-the-world signal delivery and costs milliseconds per sandbox on a
> many-core host.
> 
> This series adds PR_CAPBSET_DROP_MASK, which removes a 64-bit mask of
> capabilities from the whole thread group in a single call.  The drop is
> recorded per thread group and folded into the bounding set wherever it
> gates gaining a capability, so already-running, concurrently-created and
> later-created threads -- as well as children forked by a sibling -- all
> observe it.
> 
> Trimming 41 capabilities in an arm64 KVM guest goes from ~8.5-23.6ms with
> the per-thread loop to ~11-14us, independent of the thread count.
> 
> Changes in RFC v2:
> - Solve concurrently clone and concurrently drop mask problem.
> - Solove sashiko problems in [1].
> - Link to RFC v1: https://lore.kernel.org/all/20260922095816.1191799-1-ruanjinjie@huawei.com/
> [1] https://sashiko.dev/#/patchset/20260922095816.1191799-1-ruanjinjie%40huawei.com

Sorry, somehow I didn't notice this version until today.  I will take
a close look later this week.  Thanks.

> Jinjie Ruan (3):
>   capability: Move mk_kernel_cap() to header
>   security: Add PR_CAPBSET_DROP_MASK for process-wide bounding-set drops
>   selftests: prctl: add process-wide bounding-set drop tests
> 
>  fs/proc/array.c                               |   3 +-
>  include/linux/capability.h                    |  10 +
>  include/linux/sched/signal.h                  |   8 +
>  include/uapi/linux/prctl.h                    |   1 +
>  kernel/capability.c                           |   5 -
>  kernel/fork.c                                 |   1 +
>  security/commoncap.c                          |  91 ++-
>  tools/testing/selftests/prctl/Makefile        |  12 +-
>  .../selftests/prctl/cap-bset-drop-test.c      | 641 ++++++++++++++++++
>  9 files changed, 759 insertions(+), 13 deletions(-)
>  create mode 100644 tools/testing/selftests/prctl/cap-bset-drop-test.c
> 
> -- 
> 2.34.1


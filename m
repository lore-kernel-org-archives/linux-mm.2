Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EB416C87FCB
	for <linux-mm@archiver.kernel.org>; Fri,  1 Aug 2025 21:11:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7CD906B007B; Fri,  1 Aug 2025 17:11:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 77EA86B0089; Fri,  1 Aug 2025 17:11:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 694906B008A; Fri,  1 Aug 2025 17:11:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 58F216B007B
	for <linux-mm@kvack.org>; Fri,  1 Aug 2025 17:11:06 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id E15651A01EF
	for <linux-mm@kvack.org>; Fri,  1 Aug 2025 21:11:05 +0000 (UTC)
X-FDA: 83729433690.01.1F10129
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
	by imf10.hostedemail.com (Postfix) with ESMTP id 3279DC000B
	for <linux-mm@kvack.org>; Fri,  1 Aug 2025 21:11:04 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=f9X+OE6T;
	spf=pass (imf10.hostedemail.com: domain of akpm@linux-foundation.org designates 139.178.84.217 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754082664;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dMJ7k8h29jIKsM889GWGLoUPmzzUzdKWH9QApyFj4LQ=;
	b=smqOM5MnPYWTAFkx7+2YlaO9tIqEsr5PyFa+7V6bnQuM77Dd8gX2AMHehpg6o8YWmX75Y6
	P2hzRhaayCmnjiRq2H/ulDBW0ivrqKdolXD93Kx0ZBkkvyTMgRLdPa3U9PRPMY1kIKx9CJ
	XAXjeYCGYdEdHAXxjTnNcjiuuT+7sew=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754082664; a=rsa-sha256;
	cv=none;
	b=OKXqoHxJ8DtiJmcZL+tKDm/mVYeuXexEI4Ewa4NDuoJ575MxyYWZDZ7JRaf5jkgACIhrtP
	/8eI7Gwkwepg8evDaafWsuWF4+KajLgs6xWjFvivsDIhKDWfqQbqDDZdfutnJR/rneBSnf
	Ygg5YZcW9uT32rxd9P4/UyayxGtS3Nc=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=f9X+OE6T;
	spf=pass (imf10.hostedemail.com: domain of akpm@linux-foundation.org designates 139.178.84.217 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by dfw.source.kernel.org (Postfix) with ESMTP id DFE775C699A;
	Fri,  1 Aug 2025 21:11:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55AEEC4CEE7;
	Fri,  1 Aug 2025 21:11:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1754082662;
	bh=ww7t1UI4eak/tTR1kr/oRbXmt8cJpLrpmmFrejZkmk8=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=f9X+OE6T2ufAtHATllC8W5aKWaZ12A5bdEZvrMetKyo7MIpzCOJKgiBQi1bvRSZvJ
	 ZRy/aKgf6gcmVyJDMpIgJ5zgTtgQ7Vo4mk3M9ynRhfptQvDRrDWCQPMSrakeUQ6azD
	 jU/4m1DF7WMHLXmSWPs4vrDjdq1j6PitZ1vd3uBQ=
Date: Fri, 1 Aug 2025 14:11:01 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Sasha Levin <sashal@kernel.org>
Cc: david@redhat.com, surenb@google.com, aarcange@redhat.com,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/userfaultfd: fix kmap_local LIFO ordering for
 CONFIG_HIGHPTE
Message-Id: <20250801141101.9f3555a172609cb64fde7f71@linux-foundation.org>
In-Reply-To: <20250731144431.773923-1-sashal@kernel.org>
References: <20250731144431.773923-1-sashal@kernel.org>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 3279DC000B
X-Stat-Signature: exd7peh75wnoungg4b59d5zgkjk8rm96
X-Rspam-User: 
X-HE-Tag: 1754082664-158915
X-HE-Meta: U2FsdGVkX199H1cXQPVb717kaOg/WJoUzY5kU6YTNiNfvKHfLxXxZkZzsxOzFC5lPFKN1GVhpobK6Relf7j5SzZ6gIu+HAnFB/qYn/HhlS8AEUHZ+VukH2PwUYjuiYMPqMxD0GYrU4L7/jEFaGwuZn5HZgaENsXJAQdoJckLdLWm7hymeBPzSl+fd80H8J9R+f6NQf0Ran+U1xclet0FOAo26nbPTCr+rRUJBYvtKN647E4AY7b+Odrid8adka1Wdd+ZBMdsYWgBb6siQ+Kbwevs9G7DVRfIul9Fmps0EnJH7eur3CW0YGjUibq2O7mZrEHpm5DsHH9zWCetyHSwu2XzJ3OZYfyeLwqPfyJbmGf0IABqLGIEjOjqXf/yVDp7G4YBPguCSGoNYRxEffTvgH3eQTY1kRHQ4GaEbo+/MhYjedfv9KF8QUntUAhQ6pukn0H4FV0ZKu5D1Wavr4UKfpGzCXoornx3yxFWsjncViI3D8bG5S8RajmS5RHHUwY34vdwvx7MYphMwhOCrM5AGl/59oMi0QfBDStUmdm4QT/HBMec2uNdWc4G9Ir6sOgaByNUFwhi5PLTf7g+xRK5WCjZpS8Vfrd8LFNO8ubb+RPVIMtsDy31Av+EOf0jd2jUHJVbU1Tt4tCqQEDlVd2BAUyFAWEZKHOtXzEHH6sBeimSSIcAXQgE4vrpEXEmh6jmiR39+Y/uOEQlDX532vfOkFK+K5rGnNjpGdRUFGY5CvRfee+XLZq/E9UTRburCLvMrbrF7HGgy9Y+OsgZ+YzxwlNsDPmGY09uD0JpqKPKdSRHRuViS1blR1sVMgLxRk/N/86LbfUwSice0bBZZNM1abvNos3aO6UrpSMfLdUIWG3frO5xcnWoA0LWCpvQI0lB+0v7jyVyKLxp534GeD5FFh+bghwLUSwBuDTUkdf5fPy6D57Cfu+MiH1CSxdMLu8gEmlBXr7nAZyauOVw/En
 BMFmiL6d
 GOd4KMzLnCwLMTGONI5EY+P021dTLf6Y+bT5uZ+ntZREqtmZZexZUUyeZ7b2uoc+F42GQEGHn5y/ChKBWsEAVRb+Fv9dEQPyfYqPh4/FKoVYtG2WFeqKFf/HKMSYA7OvIifdloSuKdslARv8CjaFAVEvc1iGK3wC6oxMqj7w1BzFpc0iT2an4T5dPa7K8OkMgr4Fa8LBMwLwZbNPUrXKrjeUOGzsNNgajsxWstj/IBq899M0vc4wsBQjmXkR74rM9dPaWuNnyzPn7Qzjjc4Ftf6RhWfWFz8yNZYe0rjWuSeW2GToWtKe7ymrbqTh9rmwq739X
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 31 Jul 2025 10:44:31 -0400 Sasha Levin <sashal@kernel.org> wrote:

> With CONFIG_HIGHPTE on 32-bit ARM, move_pages_pte() maps PTE pages using
> kmap_local_page(), which requires unmapping in Last-In-First-Out order.
> 
> The current code maps dst_pte first, then src_pte, but unmaps them in
> the same order (dst_pte, src_pte), violating the LIFO requirement.
> This causes the warning in kunmap_local_indexed():
> 
>   WARNING: CPU: 0 PID: 604 at mm/highmem.c:622 kunmap_local_indexed+0x178/0x17c
>   addr \!= __fix_to_virt(FIX_KMAP_BEGIN + idx)
> 
> Fix this by reversing the unmap order to respect LIFO ordering.
> 
> This issue follows the same pattern as similar fixes:
> - commit eca6828403b8 ("crypto: skcipher - fix mismatch between mapping and unmapping order")
> - commit 8cf57c6df818 ("nilfs2: eliminate staggered calls to kunmap in nilfs_rename")
> 
> Both of which addressed the same fundamental requirement that kmap_local
> operations must follow LIFO ordering.
> 
> Fixes: adef440691ba ("userfaultfd: UFFDIO_MOVE uABI")
> Co-developed-by: Claude claude-opus-4-20250514

Well this is innovative.  I doubt if Co-developed-by: is appropriate
for this (where's Claude's Signed-off-by:?)

I'd support creating a new changelog tag for this case.

And really, if AI was recruited in developing a kernel patch, it would
be helpful if the changelog were to have a paragraph describing just
how the AI assist was used.  At least, until everyone knows all about
this?  You probably already have a presentation or a web page, so
adding a link to that would suffice, thanks.



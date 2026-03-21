Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BAD5E1094497
	for <linux-mm@archiver.kernel.org>; Sat, 21 Mar 2026 20:13:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2FD246B0130; Sat, 21 Mar 2026 16:13:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2AD2A6B0131; Sat, 21 Mar 2026 16:13:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1EB176B0132; Sat, 21 Mar 2026 16:13:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 0F2906B0130
	for <linux-mm@kvack.org>; Sat, 21 Mar 2026 16:13:00 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 9CC071DEF5
	for <linux-mm@kvack.org>; Sat, 21 Mar 2026 20:12:59 +0000 (UTC)
X-FDA: 84571168878.09.EC9C289
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf06.hostedemail.com (Postfix) with ESMTP id 04F1218000D
	for <linux-mm@kvack.org>; Sat, 21 Mar 2026 20:12:57 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=knZjaQ3z;
	spf=pass (imf06.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774123978;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2DEOO+RaL97frzuFdW5SeURXmSnZ6aYvVQg4g0VzQ0A=;
	b=a3U4+GDCC5wD0EFXxeUFAcokH5ZcXkSipzfmr7j6bUncxmeMhKcbaykG1484kDdOaSZ0fB
	Hht5zEV5eJDgHHO6oZGgOsj4K57Zbad85BoJDH2vhkiN4Zpj0SbIsPgryXI6602qoA77Fm
	ap/IHnFUWhb5lSkKkJXKtWBEddo2f+w=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774123978; a=rsa-sha256;
	cv=none;
	b=a3eN6oRMQ7z0KYCcBivuwQOAZXvU/aALI2eixD7lFxVhxtsudkv1tWidEnnjnD7GdBOsUL
	Db+Sl8bKftxPh3vA+2MwZstNHYMu6f2bUCsqBlKj0ffX2rDHlAUpuJvkxT/N4aE+2o90Rs
	nh57Yh4DSKrzHdNddVdrgL8bvAZT7FQ=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=knZjaQ3z;
	spf=pass (imf06.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 6854360097;
	Sat, 21 Mar 2026 20:12:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EEBEDC2BC87;
	Sat, 21 Mar 2026 20:12:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774123977;
	bh=NVQdlnexlbZWj9Y/C0skFJH7Ccw+Ra+VVoACTnCMddQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=knZjaQ3zOODa5K1OITF/rxTrNYzbiCsy8bdjTRLa6mdR/l6IFvAVqmFEmMAWq0vGL
	 bHhambtDAnhviLc69ZuvBvfkN2uAVxG1r1q+4/lo0u1TfVXdfGdoYOIK/eDrnVmbnD
	 ig8jZe/mc9MU7fBthDQcvS+Ap1sl55IMADcONTLs81T9dKO1pR+/xB+Gvqt5++woYx
	 lYOxhdEwGVkClJBUdMB9OQuBwMMoN9BMq+ANv5rBVZ3+KtyFAqYZNivPi8lWkq84oB
	 U2TtpE4rNyMZp4h0lCZBG78chgevEuy7m4Q8QhTI8zQAaq/Ct5SBWWOJNIQmWvTSKr
	 RAD3uQ09EIMmw==
From: SeongJae Park <sj@kernel.org>
To: SeongJae Park <sj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Shuah Khan <shuah@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: (sashiko) [PATCH 10/10] selftets/damon/sysfs.py: pause DAMON before dumping status
Date: Sat, 21 Mar 2026 13:12:49 -0700
Message-ID: <20260321201250.95873-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260321181343.93971-11-sj@kernel.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 04F1218000D
X-Stat-Signature: ssxqdb6so4f5yjck316tpa5rbgc8x413
X-HE-Tag: 1774123977-967241
X-HE-Meta: U2FsdGVkX192x2yBwwGm/2SMQ7PTog5oVQIp7k9wuHida/1p0/Obe696ECWb68mL0SPO17BvvXaZkdBu7Qm1X3Bu+F8EDeYiATQzSqk6K83zYk0go0cJd6LTR3RhmNp8+8HlTGJbTKtOiAo2/Tr7ZqkQX3CTq3mRYCYk0EsijABM/chd6QLvHi3GpbsvSb4Zj1G22ECAZ7VgaEdgLe2JQ0p3eTN9TCX0xGGNrZd4gWPpHq++w2fzxul2idCN9inffsdWVlfhI+83imgSkfBIALlOU7eXCmbBN1Iha3DPZqXHXv7onaTaj2NkSsE95xaJB6wZ2g2KI67KBLCjjAejHTekiqFJilLrzx0IfB39dKq2a+oyTk2wi35fchgWuGkC4SfaNvCv348MI2exyBdwhFm3sa/JHPdl7OYkuHQ74INq3t9w6wHwoQZqDooya485wS8OeDd+Cg4KijL85KTz+SyEMSJJTflccA7Lwgcwsf7uQFWWhIpUilf/5vQVA94f7Cfn47hJEVMrOsglM1bJtr43yME453F+MbNEXosArj3FWQcQyM12l8LyDPUgfdXd8qeghYfCrvaCpy0ShLY90WEGUEaHe4moDoUb3pkhdAwxPVSeLrUyMDBzZK7YgW694ybhGqEgS5uIfuq+E08+gJ9q8gC+Zn/u4Mjjfd7eDS80DqNpMX97Y0cQrNSljQjr+kYSPqtF2JQTI9xbIqukzV9hoYYJO3mMQQpiH3CFSz2mQiRDZAjdfObZNnPvdqY5ZZ/s7JRwKq5fLB45D0CHE/QwoN387MZKkZpMburf8wBan5x868UU/JsH8Ina49uPWmhKaCyIWp5V0bUU3YJov0t7EG1cwXB58PNY+t6ApZ64FSBgtJdO500xRGqOTIxbCZQcNREgoLNEbr9pF7omb871nrbFp6IBD3dsyGt5Drd63bHjCOKU20z2a3u+IFPytIwkaUWCQb+uePqmuq6
 NDhuWeV3
 m9dOoYjZfc0dRkOc2rLxHR++u7WZfDJ1QW+1oUtg/QzpCmkr5VDVR5eqQU5yp0t90pKWATBnrv3Ja4CQDqvbXP1VataBOQuUG8AZsau45xjpyc/6Ak5xDifhpZ6GXwVwaT5xn95EUAEIE9qYRt7TvNNDaAjkzNQPobE+5NXwNYLcpKwW6G9kpBhLF9FcTB4s7Hk/uBd9eUTD3tcVOcIseatvqY/764gFg2vPLUEt/XatjxqMIQFk6ojAdtgEq+RUq2atqC9AG0/yXOqAZBKJjv/JKrgU8gXAuH2woh88qTMFTK+IQfJnu7dfXyw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Forwarding Sashiko review for doing discussions via mails.

# review url: https://sashiko.dev/#/patchset/20260321181343.93971-11-sj@kernel.org
# start of sashiko.dev inline review
commit 019bf04e4448bbce4f6d092792a1b959f718f39a
Author: SeongJae Park <sj@kernel.org>

selftets/damon/sysfs.py: pause DAMON before dumping status

This isn't a bug, but there is a typo (selftets) in the subject line.

This commit updates the DAMON sysfs selftest to pause DAMON execution
during state dumping. This prevents potential races caused by internal
DAMON changes, such as the addition or removal of regions, while the
dump is ongoing.

> diff --git a/tools/testing/selftests/damon/sysfs.py b/tools/testing/selftests/damon/sysfs.py
> --- a/tools/testing/selftests/damon/sysfs.py
> +++ b/tools/testing/selftests/damon/sysfs.py
> @@ -193,18 +193,53 @@ def assert_ctx_committed(ctx, dump):
>      assert_true(dump['pause'] == ctx.pause, 'pause', dump)
>  
>  def assert_ctxs_committed(kdamonds):
> +    ctxs_paused_for_dump = []
> +    # pause for safe state dumping
> +    for kd in kdamonds.kdamonds:
> +        for ctx in kd.contexts:
> +            if ctx.pause is False:
> +                ctx.pause = True
> +                ctxs_paused_for_dump.append(ctx)
> +        if len(ctxs_paused_for_dump) > 0:
> +            err = kd.commit()

Since ctxs_paused_for_dump is initialized outside the outer loop, if the
first kdamond appends a context to this list, won't len(ctxs_paused_for_dump)
> 0 evaluate to true for all subsequent kdamonds?

This seems like it would trigger kd.commit() on every subsequent kdamond
even if none of its contexts were actually modified.

[ ... ]

> +    # resume contexts paused for safe state dumping
> +    for kd in kdamonds.kdamonds:
> +        for ctx in ctxs_paused_for_dump:
> +            ctx.pause = False
> +        if len(ctxs_paused_for_dump) > 0:
> +            err = kd.commit()

Does this inner loop repeatedly modify contexts across all kdamonds on
every outer iteration?

Because ctxs_paused_for_dump is shared across all kdamonds, this appears
to redundantly modify and commit contexts for every kdamond instance.
Could ctxs_paused_for_dump be scoped per-kdamond instead to avoid this?

[ ... ]

> +    # restore for comparison
> +    for ctx in ctxs_paused_for_dump:
> +        ctx.pause = True

Since the context was forced to pause before the status dump, and the
python object is forced to pause right here before the comparison,
doesn't this mean the test only ever asserts that True == True?

It appears this entirely skips verifying whether the originally requested
unpaused state was successfully committed to the kernel before the dump
procedure began. Any kernel bug where the pause parameter is stuck as
True might silently pass this test now.

Should the original state be verified by reading the specific sysfs file
before overriding it?

[ ... ]


# end of sashiko.dev inline review
# review url: https://sashiko.dev/#/patchset/20260321181343.93971-11-sj@kernel.org
#
# hkml [1] generated a draft of this mail.  It can be regenerated
# using below command:
#
#     hkml patch sashiko_dev --for_forwarding \
#             20260321181343.93971-11-sj@kernel.org
#
# [1] https://github.com/sjp38/hackermail


Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3544E1094495
	for <linux-mm@archiver.kernel.org>; Sat, 21 Mar 2026 20:05:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 69B336B0127; Sat, 21 Mar 2026 16:05:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 64BE36B0128; Sat, 21 Mar 2026 16:05:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 561F86B0129; Sat, 21 Mar 2026 16:05:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 4090A6B0127
	for <linux-mm@kvack.org>; Sat, 21 Mar 2026 16:05:32 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id C8BB3160640
	for <linux-mm@kvack.org>; Sat, 21 Mar 2026 20:05:31 +0000 (UTC)
X-FDA: 84571150062.15.3CEECD5
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf20.hostedemail.com (Postfix) with ESMTP id 3A5E71C0007
	for <linux-mm@kvack.org>; Sat, 21 Mar 2026 20:05:30 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=b5KdK59k;
	spf=pass (imf20.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774123530;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2/ZHSu7avb8m7e0K4N0ewzwRWE9YM+on6t5lZLewIZs=;
	b=Ar8BWbH9GeTfSUg+MbiYxRWgUPWbRbZFQ4eLXKwkeCcG4cgiro7QARgVYL9pV7gCoIeCQ1
	WCPpNYKI7gZdI9WDFCY+4QoKapRvO/6AQYCnIsESmNPKoEgb14A7emJtbV7thDgPfS64e+
	VI+7e4B7MxZAiXYfz5TQibLe8oqkdNU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774123530; a=rsa-sha256;
	cv=none;
	b=wt8KoLGXeMZCkPJINkkH9bFtbJ0SkMSrLLT3P8ZVqPQsSEgmOQ6ak/k7Vmc91or7UOAzXk
	prlS2oEFNlzeXlYBppFwda+nwGtyUBYS4b42X+w3dxigwxwExblWyuts3wchMu2VRGH6oq
	TEWCppwjBjVDH6YlKQX5DQGzocSMQyw=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=b5KdK59k;
	spf=pass (imf20.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 8250D60097;
	Sat, 21 Mar 2026 20:05:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1578AC19421;
	Sat, 21 Mar 2026 20:05:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774123529;
	bh=hF4d6w+NsvBedZ8VviZitL2wMhJxn8T70hjJF0LSTPM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=b5KdK59kRoJk2bLlJIvbkyHmo2s9RtlJrI+F2Bwy5TeZvWKRKLaCNn5RUGElTWDgV
	 uOOVT2eO0gM/fh5l+GsVFDevH0ufjabK464Tcu/pjFOP+mXfoI87j15jrbzLZd2Vtl
	 We4sbzCW95CXUV9MpIfmGqstGJIEEMBzHy+Cj1pQfhtKxLyXPcAUYF5vaGKY01KFVH
	 KYXGw/AYdrzL4R1F+u0/dmtNRO+PNc/TQAVKMSgw3UwPGU6h2H5oA+LpRXW9u8zz5w
	 Z1+hnWqQF1GzVjOUzHG8/kbgsrcHrTfyLOjvReAeCR4d0N4V9oKzMeVUeCsnrl6nI3
	 ADyY6xpEtadVw==
From: SeongJae Park <sj@kernel.org>
To: SeongJae Park <sj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Josh Law <objecting@objecting.org>,
	"# 6 . 17 . x" <stable@vger.kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [PATCH v3 3/3] mm/damon/sysfs: check contexts->nr in repeat_call_fn
Date: Sat, 21 Mar 2026 13:05:22 -0700
Message-ID: <20260321200522.95395-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260321175427.86000-4-sj@kernel.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: y68idamn8twe8xbmy7busmht8dyfuf1t
X-Rspam-User: 
X-Rspamd-Queue-Id: 3A5E71C0007
X-Rspamd-Server: rspam12
X-HE-Tag: 1774123530-856761
X-HE-Meta: U2FsdGVkX18S/z7UVGslaiGJLN2MRn6SFzsfGPP8i5Bwe//VhuKyzm6E/BNKz6ZPZN+I2zfnGf835px+dQsYfRtlv+MFAH8D5PTYDvM7WA5bE2L2Ql8j74DfWGUKdJupvDM11n0Vmx3IR/FZzcX1+/HoZOYJI1CanAULLc/LqRtPug3R1gsEIOIYY7pjcQsZNU6ZqDQ8I0f21wnbwCFq+grmKRRwiGieiGa5kBIMqq7XbtiJe4rTFmcZHzldxFcrWhy1/WRomwbYOTA83rv/b/fQFdmGMnceVwsFOCu2fs3LbN7AlFZN0BIM8wvo6zaTpKgDzQYdp548/16X01xl0MIUW4DF+f+fK0nVc+QGg0PyskB6fP4VZDeAy92uqqP+Ocjw3A63oWVLFYf8Pk/ys3W8zt4p+U7UZI9qhJvjVrB7casoDx1y5cSoSHtlma0rmQX1f/S080G45tb2tBWN51E0nqbClNuzJwYMyfXdLmJGe1lL/GRIAvT0QsapzKkwDyfQzlI+tBQbh9/bFA6w6qzn01byZlFM5SMlRxXElORIXKGxKwps+WfcEl0Mu/QnqjxoSsT72pV/xYcbKZNy3s05eAZfZM2zec9Nx0bVjDfZk4inVCoa+lzJOj7xakEUx0UoYXvrR0/2xLwRRDnnYhrNenqQIoe5Gb3xf+E5iuYRRVbgznd2u7su2/c829eAclSqdKj+c42nOH3p8XuaYaGIVlxyaGgmh+j7cDHwBFWqAKEbL4uJ7jdHUKf1gMrno8bvYzCVgENU62s4D8f7YjW1xaJ16J2HF4llFir3uhp+urWhGnzsMSE6Nrdb5AJu1rEBLvvYC2eaOlqPqPgCh6iHmx2xbCSIlh5BjXjgsqUM67Dlpu+YtyOZO/PFBzouH0BNDyl/iK29pp2eS2CPkrv9oQgDKifEammw/LD2uh5u1HtZvzO9KWtiJ0jYhwau9WCNQnDIGhIx0UosVPc
 GMLCS5uY
 Ya2JaKrfSd7ldgp6jIwywlxUrzOav9YvByIwnz4TKXB302XbFtq6P8KoDg2XqxGjmcjxAoc2PeoTCp5l0G8yFKD2QQhZo/gRStSrVnVrgxd4mdc2dfTjj7ajdGnOE21EeYv/PZyOWlJTrorUumk8fWojjDuvJBgWBn3gw+gviVueL/4RjpFMqxyKqpHQPW52LLxMk+82OxizEhU+FjHnEjQ6UvabJKwSpCVGIaeL5wLUTk5J7J5RrbC3hXgyRtXYoiKOf49xJXPINU7oHXp+mTFNZmUEtuDhCwAJmqyqHk6P7sx3EyBcX0K/gMBQsg8JtbA5/DjGfTz5m/EOoSqALHE6uA3TOdWhwFvT2RU1Osbsx8aHZmbp5yww4o0uwpNiRQy9LF1nikx453Uz1ohGb/kpQv5G1K66/N3JJShzV1tVJDW3QyDoxOK2CKjZDf3BKgj7yoeIiQgaKyHSrPPWcrZRstM6UH2Dv5wPw6WCiUVJXe/ogviDhgkaosw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Subject: (Sashiko) Re: [PATCH v3 3/3] mm/damon/sysfs: check contexts->nr in repeat_call_fn

Forwarding Sashiko review for doing discussions via mails.

# review url: https://sashiko.dev/#/patchset/20260321175427.86000-4-sj@kernel.org
# start of sashiko.dev inline review
commit 349107c02ee8a122119ac77a51451bb3d9311a34
Author: Josh Law <objecting@objecting.org>

mm/damon/sysfs: check contexts->nr in repeat_call_fn

damon_sysfs_repeat_call_fn() calls damon_sysfs_upd_tuned_intervals(),
damon_sysfs_upd_schemes_stats(), and
damon_sysfs_upd_schemes_effective_quotas() without checking
contexts->nr.  If nr_contexts is set to 0 via sysfs while DAMON is
running, these functions dereference contexts_arr[0] and cause a NULL
pointer dereference.  Add the missing check.

Link: https://patch.msgid.link/20260320163559.178101-3-objecting@objecting.org

> diff --git a/mm/damon/sysfs.c b/mm/damon/sysfs.c
> index ddc30586c0e6..6a44a2f3d8fc 100644
> --- a/mm/damon/sysfs.c
> +++ b/mm/damon/sysfs.c
> @@ -1620,9 +1620,12 @@ static int damon_sysfs_repeat_call_fn(void *data)
>  
>  	if (!mutex_trylock(&damon_sysfs_lock))
>  		return 0;
> +	if (sysfs_kdamond->contexts->nr != 1)
> +		goto out;
>  	damon_sysfs_upd_tuned_intervals(sysfs_kdamond);

Does this code cause starvation or incorrect statistics when multiple
kdamonds are active?

It appears that damon_sysfs_next_update_jiffies is declared as a static
global variable and used by this function to throttle updates:

static unsigned long damon_sysfs_next_update_jiffies;

static int damon_sysfs_repeat_call_fn(void *data)
{
    ...
    if (time_before(jiffies, damon_sysfs_next_update_jiffies))
        return 0;
    damon_sysfs_next_update_jiffies = jiffies +
        msecs_to_jiffies(sysfs_kdamond->refresh_ms);
    ...
}

If multiple kdamonds run concurrently, wouldn't they all share and
overwrite this single global timestamp?

If one kdamond sets the timestamp to a future value, another kdamond's
thread might incorrectly evaluate time_before() to true and skip its
update, potentially leading to starvation and incorrect sysfs
statistics for all but the winning kdamond.

>  	damon_sysfs_upd_schemes_stats(sysfs_kdamond);
>  	damon_sysfs_upd_schemes_effective_quotas(sysfs_kdamond);
> +out:
>  	mutex_unlock(&damon_sysfs_lock);
>  	return 0;
>  }

Could there also be a memory leak of repeat_call_control in
damon_sysfs_turn_damon_on() if the target kdamond exits early?

In damon_sysfs_turn_damon_on(), repeat_call_control is allocated:

    repeat_call_control = kmalloc_obj(*repeat_call_control);

If the kdamond thread encounters an error or has no work, it can exit
and set ctx->kdamond = NULL before damon_call() is fully executed.

In this race window, if damon_call() detects that the context is
inactive it calls damon_call_handle_inactive_ctx(). This removes the
control from the list and returns -EINVAL, but it does not free the
memory.

Because damon_sysfs_turn_damon_on() ignores the return value of
damon_call(), does this result in a permanent leak of the memory
allocated for repeat_call_control?


# end of sashiko.dev inline review
# review url: https://sashiko.dev/#/patchset/20260321175427.86000-4-sj@kernel.org
#
# hkml [1] generated a draft of this mail.  It can be regenerated
# using below command:
#
#     hkml patch sashiko_dev --for_forwarding \
#             20260321175427.86000-4-sj@kernel.org
#
# [1] https://github.com/sjp38/hackermail

Sent using hkml (https://github.com/sjp38/hackermail)


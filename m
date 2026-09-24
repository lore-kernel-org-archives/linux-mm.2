Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 69F25C98315
	for <linux-mm@archiver.kernel.org>; Thu, 24 Sep 2026 14:19:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 74D176B008A; Thu, 24 Sep 2026 10:19:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 723D26B008C; Thu, 24 Sep 2026 10:19:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 63A436B0092; Thu, 24 Sep 2026 10:19:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 3C0AB6B008A
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 10:19:29 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id C277140357
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 14:19:28 +0000 (UTC)
X-FDA: 85248863616.05.D61842D
Received: from mail-dy2-f12.google.com (mail-dy2-f12.google.com [74.125.229.12])
	by imf12.hostedemail.com (Postfix) with ESMTP id 7D95C40004
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 14:19:26 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel-dk.20251104.gappssmtp.com header.s=20251104 header.b=FiIULCH0;
	spf=pass (imf12.hostedemail.com: domain of axboe@kernel.dk designates 74.125.229.12 as permitted sender) smtp.mailfrom=axboe@kernel.dk;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790259566;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=l5t+RkrxBW/tPG0f8s8vACvjj/UzJW53i35clI9VtqY=;
	b=iZgwo39Ya/o6BC3b6MeZIEOh2jWb+fSA+76p/yhCsXsppLFc2YdYi5BL5zFyBinZ5Df6sP
	7lldetSKPrDbBk2Jy55jvwuS5yvB6CMXLHxvAuelIpxV+7li3YFLiB3hWKePdJ+A7jCyN8
	el8tdjR9ZsTzlwTjsqU/TQ035w+Jo7s=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790259566;
	b=LQbqjf5dT4cNpPSBSwrfG/f6dPM7XZmJtZh6Ww41x36Cz8Mnb4Mzwa7lWpMqudvJOIDibt
	2++0irmS06Jc89iUBC0zQd/Jrxo9qbONtsqVF9llCYvdkt0zOmisOhKhJLkGAQJ5iqyH5Y
	Ok438IUO83Kvg6XIWxdmei0Jb9IwaI0=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel-dk.20251104.gappssmtp.com header.s=20251104 header.b=FiIULCH0;
	spf=pass (imf12.hostedemail.com: domain of axboe@kernel.dk designates 74.125.229.12 as permitted sender) smtp.mailfrom=axboe@kernel.dk;
	dmarc=none
Received: by mail-dy2-f12.google.com with SMTP id 5a478bee46e88-328664e061cso2305428eec.2
        for <linux-mm@kvack.org>; Thu, 24 Sep 2026 07:19:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20251104.gappssmtp.com; s=20251104; t=1790259565; x=1790864365; darn=kvack.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=l5t+RkrxBW/tPG0f8s8vACvjj/UzJW53i35clI9VtqY=;
        b=FiIULCH0tlCKbbeH/rsKhRfquheVjUkufu5Rl+UiHQUhYljUixGy0KHHc106f/LFqA
         ebE99TK92mMtvHANjV2OnJ3d99RDKLz8Y4VblvlsqgKy69K4BjFNQ+gADbbIH2i5TQDx
         EGuHCjdgaMSLiL7PFE0ytlbd1mAPtXG3m5l72lnLJ3KWsAqj7eimcPmyuN+z+KdLP8DR
         FlqktwV4nDGRBgfXgZP3G1l2uiUoXbdXDqpGZ5w5ToGMqwxx1BDcbjbPnHhE8EWhuIhj
         fz5DcRMDewQ7OHKtpO71D75s71MYt0OOAQ1OkejBjZQThmedmmOOAzGMj9r0yaHhmGQz
         xrHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790259565; x=1790864365;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=l5t+RkrxBW/tPG0f8s8vACvjj/UzJW53i35clI9VtqY=;
        b=aRhpvgVCRsZKX/5eFmBTMb3d48dq86kUfHkONGBWnwfIvZfHcxV/7Of8JOkcBgHJVy
         yjbmBZtr8zRSz3VykLVqoSzFxXcYRdQDqT+nXe6bCBoLWgVwj4iIp96wdBg4u1lGgPHm
         7S+GlJCtpwWQd6rzCUD2Zw6R2NsO0jHbfXiMB+rb8DlDtqwHnE5xS13X0ybomUcK32tT
         pHqAOLX5xlA7gxXbjTtIjZdSxEyONQaXl6FQoKG/pWDsEIU2jI/IJmwjqh9fEMdp8NNv
         izmBl5sTcPNB6e7Z4IL9dbaNmXtIbc2BHxeraJCMVovMB8RKoDAw3oU2yg65TlU19iuV
         n8Gg==
X-Forwarded-Encrypted: i=1; AKwUvBwMX7c//j2QSF0A3FtcjGZIHyBURm8NJd1rKoIIpnD7/trXGGM85kG2MMr90NntFdZjRz7itia1Bw==@kvack.org
X-Gm-Message-State: AFuF++ngeoR/D47Z1X1QXlZalxgvJRhYzuCSLQQWMz8AYKre6nZznwaY
	1I0Bw/9UaKmI75HhdX4cFi/8vBGn1YHqaLuKwkdo1c+zK18Dpyn6EM1QJC78u2pGtk4=
X-Gm-Gg: AYBFou1/FnofEwJGU95yNrhHrLG88ydiznivzLed9/h/a9Hx5IsDvg57owzbsuvn3Br
	waktQOLP9ZZvBdfc6vwCc0r2Oo2WKkCNBusB+MOAX0rcHFxoXeqS5XrXY+/pwpA6m6gZeOL0dfm
	5Z3Vc40Kc+fUJb1Qy+vsY8C7gZwUg9ZE7bX7SjE+msNUzHdQwVeoyAAmcS/LU0CN6X8DrLB/j/b
	kHszc4duhZ4+zQlF0y58xchjg7pOYMxj/6FhnipjQrvPcThiFtgpJNX8D6BB/X0Dju5pU8evTXi
	HKBhOk6eEyn1N2jm4p26RuttkIxVi1tWchXMraWaM41jVedrCXikY3Dk/LqfueIH5hNRPPk3yeU
	Ben9IX+O0DR32tGgv/oIosfweWtgdfKRYmP8x25qIdPe+mB0fhzNxdgabhp4Wg5ZIZbJZSUcLlG
	8UxCKqODpP6yKwE2Lnp49CsOLlpO1uA83YEgVIkpfLiJosuLWh4/g2oBP3z0iWWvJKdUP3EVBsA
	awq7aO3hFWvTLNDZJD9r+POdyVPHPcBjuz93AXPfTMPGKNIXekAFwhcJQ==
X-Received: by 2002:a05:693c:87c7:20b0:33b:f566:eca9 with SMTP id 5a478bee46e88-34001c1401fmr2175061eec.11.1790259563746;
        Thu, 24 Sep 2026 07:19:23 -0700 (PDT)
Received: from [192.168.1.125] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-33e9684ed70sm12529265eec.19.2026.09.24.07.19.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 24 Sep 2026 07:19:23 -0700 (PDT)
Message-ID: <e1fb70aa-cc4c-4ed5-809a-e8babd52dacf@kernel.dk>
Date: Thu, 24 Sep 2026 08:19:22 -0600
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 12/17] exec: cancel io_uring requests before
 de_thread()
To: Christian Brauner <brauner@kernel.org>, Oleg Nesterov <oleg@redhat.com>,
 Chris Mason <mason@kernel.org>, linux-fsdevel@vger.kernel.org
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>,
 NeilBrown <neil@brown.name>, Ingo Molnar <mingo@redhat.com>,
 Peter Zijlstra <peterz@infradead.org>, linux-mm@kvack.org,
 io-uring@vger.kernel.org, stable@vger.kernel.org
References: <20260921-work-coredump-fixes-v3-0-8e4adb1619e6@kernel.org>
 <20260921-work-coredump-fixes-v3-12-8e4adb1619e6@kernel.org>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20260921-work-coredump-fixes-v3-12-8e4adb1619e6@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 7D95C40004
X-Stat-Signature: 4sc9nj7373cyunmnk8yxiwj4qshxfnse
X-HE-Tag: 1790259566-134717
X-HE-Meta: U2FsdGVkX19ao6XmPoDaLs6dhsSxYKc+3s8VVYWYuYcZRxWI8LxxiC/pmUEBk10gQTolxpyyuDJbZKC/f7xsM5gYr647j+3vDs7t8TRwpkFXaTGjys+6nAZO90EKDMrfswxXj+BPq74+xQy1Qa+TYVwTeFlMXAKJoiWCE2310wL5CoYNcdfcf45RTlhSBEIcsRo7bojE/6sD6ksN9NP/DGtBYRF9Tz+Zb+o+dfpIMbsf37V36abO5p8Ei0b27nG2aE2/0tmfmiAbjBFqNmZ9qzNG8piV/slXbCrUjgHAnu66XHl3YIpOQFLshNE3UZKfScsNYLHhhdL/BTWgqSToG4VaJ0EKb6MNPQdtSSGV9ccoGnfjnGtWu2ZQRVvR+oBFzmtlbcIkHaA2r7SzwtrlRyitJs7NfnatzaHwhyhr13z6qon5UxTUpK6SXqh1JIEaeF/JEMzZPv2jlxHzqk1Qe5Ii8IvuUo+5YuATn+Ceb3tQ0sgvUJbLt8ZO8Hx/rmdyyJyPbqOzIN4eKXpA9aA7KUv+LCkWCPACAZyRtNY2SUU4QbcNEZXI5DTB303nKevOL0lI2jhjjrWarE6E8mqCoxAht08cnBf6WOdhaxhmrkyluCiPyP29CoqgYVXeOlZHpFbpvFVyY2TTKI0Rt16GzLouIeehEami9oHAZN2/3OCTOLQg5/45uaO7CDfpfqGWeuKHcOu5dme5N0SLq4GAL629n6jt+TnT8CZgHGe8sMIWz7zfJhpdWDd2zK+8NUNz0EuWhmRfwSRnLEpT/Wl6u69DDZwg+j2he3gT+Jl6jdist2RzPkJdhZB4mL38uPx5cK55cc3QWUxIZK/aThn0lEsdx47cNitTumYy00XKWzUWektbFmeyt6R/SEREqsZ3I1wPy+FXM7KWumzFHMpWOdEp7qmoYbbtOAsRLG2FHIG5+7aWZE/sKOqQ8t0tTaZ2sJyxfhIxxcSw24UdT3a
 xw4CP6jn
 Z7Env4InxeBTgKqupjEOGOaH+iBZuN371KEbe+ij6BZVAI+Yk98135qddrndlVm2Hx9UXMZuBhskD7Kc56Msqw38ohR+rsrvzCRrITmgKyxqz607XBznCPJlm2OpPjArjFMJxLHsm4aMUIEDjmwnAvUHsb6XOvGCyz7575L6gZmSX1zFCGdIamx2r3WyllN6LjJru8rGeStiNyE0o988XceOZhaQ6MMeFl37ya0fCRiY7GZwhi4HmQuU8x/tuZqiUz6+kSqHXtqk6rXjorKirtaTLQ8rDNwQhp17WBTgVQq4I226rZGS/X97l/HpB43igUT+LzaQk8/eTUsF+VR9Frkxc2drT4cyxMv5gEhpqUpzHpoD8QGI8Sx+Rrpm+jyTU+LduURVMS0UPXSF/eLTdnUi2Sz4zkTmDPaac5PdVIe+c1FhnQWdTtPkEgKGTgnVrfmXK1dqSJHe68jZ7t8UNmSE4WQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/21/26 7:45 AM, Christian Brauner wrote:
> begin_new_exec() cancels the exec'ing thread's io_uring requests after
> de_thread() made it the only thread in the thread-group. Now
> io_uring_task_cancel() runs task work after. If it runs a
> create_worker_cb() item then a io-wq queued on the thread before the
> exec creates a new io-wq worker thread.
> 
> Said thread joins the thread-group which de_thread() just took down. The
> io-iwq sticks around until it notices that its workqueue is dying. But
> code after de_thread() relies on being single-threaded.
> 
> Move io_uring_task_cancel() before de_thread() but behind the point of
> no return. Any worker created during task work run from
> io_uring_task_cancel() is just a sibling thread that de_thread() will
> take down and reap.
> 
> Once io_uring_task_cancel() returned the thread has neither a task
> context nor a workqueue left so nothing can add a thread behind
> de_thread()'s back anymore.

Reviewed-by: Jens Axboe <axboe@kernel.dk>

-- 
Jens Axboe



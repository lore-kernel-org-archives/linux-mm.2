Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D4F0BCD5BC8
	for <linux-mm@archiver.kernel.org>; Tue, 26 May 2026 13:33:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E2D726B00D3; Tue, 26 May 2026 09:33:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DB7A16B00D4; Tue, 26 May 2026 09:33:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CCD0D6B00D5; Tue, 26 May 2026 09:33:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id BC4CF6B00D3
	for <linux-mm@kvack.org>; Tue, 26 May 2026 09:33:33 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 833301C02E9
	for <linux-mm@kvack.org>; Tue, 26 May 2026 13:33:33 +0000 (UTC)
X-FDA: 84809663106.25.35BF443
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf12.hostedemail.com (Postfix) with ESMTP id D26554000B
	for <linux-mm@kvack.org>; Tue, 26 May 2026 13:33:31 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="IJdXqJ/O";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779802411;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6jAOS0/EwvvAsAZOUxgHfwKPnBOOkFHmitJou6/DGm0=;
	b=1DNUS+kXT+NP1tLTYt3jh3RkCnUmAXCikQKOv32ZXGMzOf+p5EjifOiAFUchEz9pL2Spp9
	+v0kqlHoalDR/fi6jxuniMiSplp1BXaqESsha7ZE/LZ8VRyEqBC39REAHBp4jQNS/5g3CB
	wYUMmCd/jeApcIPiFZCwK0kVMNLxscM=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="IJdXqJ/O";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779802411; a=rsa-sha256;
	cv=none;
	b=xiC6AJCJ63Uz4VIgj3J+hUQF40XCZqCPOEJxtbHjlEn5rPpad/9kavktoPCfx83rFKCG9Y
	7kf0k1s6YKBqzAMxbzg0qrA2f19BJ3QRk/sZzfwyQYafjREFAPpYkuOzm5lXH1N9OV8G35
	F5HBSD0oTMoYLxSPn8as175l26V8txw=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id DB8A6429D5;
	Tue, 26 May 2026 13:33:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C33F21F000E9;
	Tue, 26 May 2026 13:33:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779802410;
	bh=6jAOS0/EwvvAsAZOUxgHfwKPnBOOkFHmitJou6/DGm0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=IJdXqJ/OztdUKhdnt0gLGbIvLEpUPwej3tFhKIDpQw61hr3H1/peeCesxk8MmYrsp
	 KqLVT/2wVO8En0vC5kHzx0QCBOXGNWInvzaxUyZwbHe8tkcM4oYB0MD45GTch5R+FE
	 KUdNx2Gl9BQJE53dgCh9tNwv7kx6ABm8CNO8BcxX7dIViod50yPBIkMeZ9V4EOtoCV
	 qoLPNPeK//aKaCNBCZo6zYeR/gTZILe07Ld0kSekYXnbhtto5tS8Y4S89gwd/W7ZSh
	 qn5JBBj9WIrbT0Ut11YBtYuGisVtvBBRnHchDLrIF00eFQ4Ky3EPny0cj9f+kB4qSH
	 bgnZLkwoHpAug==
Date: Tue, 26 May 2026 14:33:24 +0100
From: Lorenzo Stoakes <ljs@kernel.org>
To: Chris Gellermann <christian.gellermann@codasip.com>
Cc: brauner@kernel.org, shuah@kernel.org, akpm@linux-foundation.org, 
	david@kernel.org, liam@infradead.org, vbabka@kernel.org, rppt@kernel.org, 
	surenb@google.com, mhocko@suse.com, linux-kernel@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH] selftest: Fix UB of getline due to missing var init
Message-ID: <ahWNRKCzGykpYE0h@lucifer>
References: <20260526113848.530105-1-christian.gellermann@codasip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260526113848.530105-1-christian.gellermann@codasip.com>
X-Stat-Signature: rw8z5ayurkdekm7jy3dj3btfqwbwnihj
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: D26554000B
X-Rspam-User: 
X-HE-Tag: 1779802411-806599
X-HE-Meta: U2FsdGVkX193ewf56kkiuMNacHA7JzZbVxgJyT5ZP8++tAG/IyNLudXvMI707PO2AaDzs7JhhJlcVO/LCU6Iys8cRBCkBJJoG1ucge2De7EeHPEwZWTTeJXbGI7LSRQn/gCls00kmPy0CfDK7BhvzAuMR7JzCe2EbGJ0VdjN8zqdxUqamEgebhkDXQ7sVbU3PfDbCh31TqUXlxutMSQSqFwakGmJS4VxqVjqd8aKd1DCweOaGRb0nfuhBk7mr1ItzjtQKI1eGeVwaWGZ6dvkd5ypbcLDBQU0ffyu49gehtJtvQDj5Ish5kaV4RkW9hCBcnj3CTBJpron8muxObs5A56x3AFLeMO+HsqkeiLTxRSLQZvImD2qk+WrKDgHdyMmw38WWIHouGGOskqCCyhN5vbl09+JRry5cqdmAUJpEo0Ry5SSegPNfIT1JSScmk0VBK5E4nPLCjov/8EFTV/rVAmeWiNzj4OiaOPCJ0iuJp0Cz41AIdGWLHzeCmqndDKs7RdT7rMTOfgBq7oRXWBcYXaH4m4GJGUtGnHJTESfMmThQpRjV41Ukf1uOnSVNdak45z8LZidF5VUOPKa/qP4OoJgKt30i7CcqcszayOt+RFX/bZmtLSEmmNVbuuC8/BNw3dvndspe8VwD6fCOnsgb4hHBfMz9dC2LUUhFfmkQUVYLeA1BYyFOT8gKYaQy/qxcsTIJQuMFH7CQgD/sMcNNU6H5V4XVZew71PhdBK6BevHmyAnGmoQuz9Hb3hMkzH8qACx31CNK6SOhZU1mrN8kQNvmhO449C7PsbCoM3HVWNlwIIzv5o4nVJYYZuLI/mOypgQAh0XcoM4B/DWtqnLeFr75M30H+y3mGi/7iNZR0saEXvStlhZDthOwcMJaqemqw+HD3dYndiNrdZLfpjaDYs/Xye7xmRI2zbDEuVyEiTQHVExM3mz6HXGoNW6/IrwGrRKqBZRnW+q9ute7tH
 aDBJGotf
 UnRDwUn4kGgb7dqaHbqAEzg6LawayZRTZAkHL/c08IHjv925FA+Y5EOqudZfT3ltH0zd6ZEWXlG4/Ji+6J5Yh/Vn438gZ/Ivk5WRoChuHV4Aiv0I7hoQG7JIJ2jKroGRE3lIWvY7V65a0Fk+64PKq6KJdu/7uJqDBAE5PiE95KuVC7RVMVWRjddnem/5tlbUSV8lYj6uaRUl5/bQ4rcb/lyuhjkTPVlEc6wt93/yLSV/eFu8McQ6870b34eY4zWE+c6r2zc5o+ny1C94wV7XGkD2uOsTSR7GNuLf5jgyNunfIfWrwKVmekJJqE2uvJxfd+Bk8Ad1x8TEDbWDKxwPbOWQPEQhl7FEosmpMVXb+6pBZ4GeKv42h6ZCs5wiF6z5rg5orBoKMWqUyG4o=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, May 26, 2026 at 01:38:48PM +0200, Chris Gellermann wrote:
> Clone3_set_tid uses getline(&line, &len, f) in a loop to read the
> child's process status. The code expects that getline allocates the
> buffer for the line on the first loop iteration. For this, glibc[1]
> requires char *line to be set to NULL:
>
> > ssize_t getline(char **restrict lineptr, ...)
> > If *lineptr is set to NULL before the call, then getline() will
> > allocate a buffer for storing the line.
>
> However, char *line is only declared, leading to an undefined
> initialization value. Fix this by properly initializing it to NULL.
>
> Same issue fixed in mlock-random-test.
>
> [1] https://man7.org/linux/man-pages/man3/getline.3.html
>
> Fixes: 41585bbeeef9 ("selftests: add tests for clone3() with *set_tid")
> Fixes: 26b4224d9961 ("selftests: expanding more mlock selftest")

You'll need separate commits for each I think? That'd at least make life
easier. You can send them as a series.

> Signed-off-by: Chris Gellermann <christian.gellermann@codasip.com>

> ---
>  tools/testing/selftests/clone3/clone3_set_tid.c | 2 +-
>  tools/testing/selftests/mm/mlock-random-test.c  | 2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/tools/testing/selftests/clone3/clone3_set_tid.c b/tools/testing/selftests/clone3/clone3_set_tid.c
> index 5c944aee6b41..485efa7c9eed 100644
> --- a/tools/testing/selftests/clone3/clone3_set_tid.c
> +++ b/tools/testing/selftests/clone3/clone3_set_tid.c
> @@ -141,7 +141,7 @@ int main(int argc, char *argv[])
>  {
>  	FILE *f;
>  	char buf;
> -	char *line;
> +	char *line = NULL;

>  	int status;
>  	int ret = -1;
>  	size_t len = 0;
> diff --git a/tools/testing/selftests/mm/mlock-random-test.c b/tools/testing/selftests/mm/mlock-random-test.c
> index 9d349c151360..16294bc7dae6 100644
> --- a/tools/testing/selftests/mm/mlock-random-test.c
> +++ b/tools/testing/selftests/mm/mlock-random-test.c
> @@ -84,7 +84,7 @@ int get_proc_locked_vm_size(void)
>  int get_proc_page_size(unsigned long addr)
>  {
>  	FILE *smaps;
> -	char *line;
> +	char *line = NULL;

Strange this didn't result in noticeable bugs but maybe perceived as flakes
or such?

>  	unsigned long mmupage_size = 0;
>  	size_t size;
>
> --
> 2.47.3
>

Cheers, Lorenzo


Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D01E4C4452B
	for <linux-mm@archiver.kernel.org>; Wed, 22 Jul 2026 00:18:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C664C6B008C; Tue, 21 Jul 2026 20:18:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C172C6B00A3; Tue, 21 Jul 2026 20:18:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B09AF6B00A4; Tue, 21 Jul 2026 20:18:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 83AAB6B008C
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 20:18:13 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id E3DA7C02DA
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 00:18:12 +0000 (UTC)
X-FDA: 85014500424.20.F121C46
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf18.hostedemail.com (Postfix) with ESMTP id 586771C000C
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 00:18:11 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=HQklOV3t;
	spf=pass (imf18.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784679491;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NZE8OVcCqPgnZz+/5Kme28lwwlaGh+3LsOtdYSryteU=;
	b=NVfNpL3ULwjpMd4VSzE9ahWq49nXrBmP7jbe58I7Az0ei+z+3bU6gkezdSyxQie7hjDgec
	2Q2nQolnNyx4+3WgWsT+Ug0ObaxKdTyiWBF4W3rPzsN0oPLH1YNBDz3fCPVn0sa+YlKGZH
	Ni0XL9OarM+1nzp+jb+Rkoo9a7VmIvY=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=HQklOV3t;
	spf=pass (imf18.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784679491;
	b=P7PoqgVc/REIcatPSOig1UWFjd3Bif+XBwGVoj0Qa3w+xwvl21OTBT96JQI/JUZgupjTm0
	Yf+s1LehjisYIRWWOfABn98pwOUTBqc3fyY3tsXvNnlQX1j9XXH/JEUfA/NfYRvm9rGG/t
	rSDzwrHaMkjmwxgA0W9q8wotdf3Y+ms=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id D46BB600FC;
	Wed, 22 Jul 2026 00:18:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4CA041F000E9;
	Wed, 22 Jul 2026 00:18:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784679490;
	bh=NZE8OVcCqPgnZz+/5Kme28lwwlaGh+3LsOtdYSryteU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HQklOV3tmYgsc8UrejYclNrWh/eCAMQrh79IZrgN0+gHQk4JssCNNslTRNhnYyWkX
	 FyKeg3rWX8mUJnpmSgf+lsRZV5A99IIVJ68sU4maNDFnhBE8vha3SnLsjClH/fl0G3
	 Anxbm4RcITokwXA85WLGQqRyUh3ahEIoN97Tfa0CB+ZDz75rOG7cBhXZYXc7aFPZCA
	 xBhlZxxthyvWaJ3wGH2xRHqcWXT1KM2anIcUXTY2aG6QUVHm5f9io8QARfC4i/JiIg
	 ziVrar6D8Pk1jj+IDiMyd2mh1f+nd66nN2S2aeQ3h/d3I2oeS07tQjN0VhcSsHnCNl
	 ogBmadR06ltiA==
From: SJ Park <sj@kernel.org>
To: longlong yan <yanlonglong@kylinos.cn>
Cc: SJ Park <sj@kernel.org>,
	akpm@linux-foundation.org,
	david@kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	shuah@kernel.org
Subject: Re: [PATCH] selftests/mm/pagemap_ioctl: Fix missing NULL checks after calloc()
Date: Tue, 21 Jul 2026 17:18:00 -0700
Message-ID: <20260722001801.150265-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260721063611.342-1-yanlonglong@kylinos.cn>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 586771C000C
X-Stat-Signature: 1mnsz5m3zarm8xctyhgozjup5krhifgp
X-HE-Tag: 1784679491-390586
X-HE-Meta: U2FsdGVkX189TUiQ7J+f6vV7hhAiRqtAIj/UxgCYsZeq0Q0S5UQGveGaTFanNN/Lrwc+JQakuZrWGZ8NH1O1nruCgsPdDkg2GGiBYaM3V3D3+UHFdIrFvV1so3FGllw6SoArCTz+1XyZsNvad3DhZmE3bJ+cFYzN+jcw8X4p0ZQepVJVP4f/1HmUvOeFoOaAFF0rTDmGIrkBONCbqjUPaMKu7qR8cBIn09zDB9ITAR8daH5P3B3R95TFmW/FbHXxLJs7+SzCZYJ+DyYpvHq/u5bEr6RHJKx31FaMkn8GN8M48PaZDsEDQqIpEqciO3PpcZnbnF3amZKUG4CKIjQQ2O8nXqSUwR+pFEcjoPImbC2C46Zt2pf/ZP63dJY14PrIiszITzo343jHgNTkcojcKV87N16AXgSuJB7kKJamxtnNWTfobOooJr7GkyN29wd98xuzqTYVd0jf2GnP1f2iCnh1cY3Z7Klpc5ivsiwgxi4ZRYWG97m6uWy6s9YW+PGOVi/3LuaMQ/CSSwvkHz6VsqhUoPud+jP/DychT3GNfoK0SxjJ0sA330GPCVm01lB+MbGS9/VOvu4kCsa30GDFur7EG94w4x+PMnTfq0GLWFHE44bYHEgcdJvAyNg/fR+9WIRNfwPZCnVvuCS8BCSdWJfadcErlmrZVcQ5DlghZBgvSwdbjHAbcrMFxYe2knLT1Ug5H7ZOzI9mdOfyVU8/lMEhmFKPLwIodRPNHU8+YIO78J8c6cf0HDb9Fk7nlfhm+d6p9XXFdo1/9kzvyrVlFfK1XM62G5iA9yTrwL6/4C4ZesQwnbsfMo8KUh6OtR6PtZJhNiHr9C6nOC3lFXavURWxaNMe7do2xJDkdpl0Qd1wQxtdWdGw5+T7nZx2KoyevLTsJcnZ+ILHpCeM7a6r1Y1oaYSfcvMdFCLv+JCIj9eABL8Vf6sHflx3f29qKZe6pdkkGND+owFgte/FQsX
 JANjUnUr
 T2BYd9eKtQ3X1B3H4dqnS6/w1hVNqd42V3r1NtGJiaOMbR8cywdzer2QUL2qbDPln3vgwyefpkQ5w7eMNJzC1dbTEVagWWUYRCzHIAV4KZ/pCQz5u9eC66fMhmISI21eI/bLyaR9VT2kaYvYHqfM+jq8Z854tQzVEt1Tw07YOgftbQX7c0Xvumb5JjfBwi8bOOffxXkGzCzBbx9N+DzcNY1IlCLfmdMZVkHukqzmKihYKNyQ9J7/imuPrH8XIdqzphbrYQ56x5nYlRrKu6QwP9NHmsIViTZYOPvpTYQYVAxKp65WjhWVz61evRnphRiM3uw1jHgQKybpAGVw9pAj3zvDFm2El1DMOYO2/PnMyyjAeDgVlNcDKfAeo/465cAo9m9mon5b7tJSBYhOOKJloqENdoxjHdzyWie1e
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello longlong,


I found get_maitnainer.pl is suggesting to Cc below recipients.

- Lorenzo Stoakes <ljs@kernel.org>
- "Liam R. Howlett" <liam@infradead.org>
- Vlastimil Babka <vbabka@kernel.org>
- Mike Rapoport <rppt@kernel.org>
- Suren Baghdasaryan <surenb@google.com>
- Michal Hocko <mhocko@suse.com>

On Tue, 21 Jul 2026 14:36:11 +0800 longlong yan <yanlonglong@kylinos.cn> wrote:

> The pagemap_ioctl selftest allocates memory via calloc() in several
> places but does not check the return values. If calloc() fails, the
> subsequent code will dereference a NULL pointer and crash.
> 
> Additionally, in sanity_tests(), the calloc() failure check incorrectly
> uses MAP_FAILED (the mmap() error constant) instead of NULL. Since
> calloc() returns NULL on failure, the check never triggers and a
> failed allocation goes undetected.
> 
> Add NULL checks after each calloc() call, and fix the wrong error
> constant in sanity_tests(). Use ksft_exit_fail_msg() consistent with
> the existing error handling pattern in the file.

Makes sense to me.

> 
> Signed-off-by: longlong yan <yanlonglong@kylinos.cn>

I have a trivial comment below.  Regardless of that,

Reviewed-by: SJ Park <sj@kernel.org>

> ---
>  tools/testing/selftests/mm/pagemap_ioctl.c | 8 +++++++-
>  1 file changed, 7 insertions(+), 1 deletion(-)
[...]
> @@ -1000,6 +1004,8 @@ int unmapped_region_tests(void)
>  	int written, len = 0x00040000;
>  	long vec_size = len / page_size;
>  	struct page_region *vec = calloc(vec_size, sizeof(struct page_region));
> +	if (!vec)
> +		ksft_exit_fail_msg("error nomem\n");

I'd suggest to separate the definitions and statements by putting an empty line
in the middle.


Thanks,
SJ

[...]


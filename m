Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C3D4D109C04A
	for <linux-mm@archiver.kernel.org>; Wed, 25 Mar 2026 17:24:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 27E6B6B0089; Wed, 25 Mar 2026 13:24:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 256196B008A; Wed, 25 Mar 2026 13:24:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 193586B008C; Wed, 25 Mar 2026 13:24:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 04E2E6B0089
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 13:24:20 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 9BFA51B8EE8
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 17:24:19 +0000 (UTC)
X-FDA: 84585259038.22.F851586
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf24.hostedemail.com (Postfix) with ESMTP id 99B6918000D
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 17:24:17 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=niHokkjg;
	spf=pass (imf24.hostedemail.com: domain of catalin.marinas@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=catalin.marinas@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774459458; a=rsa-sha256;
	cv=none;
	b=IpJuSU1uBOMAzwMbko/eB1blzakfohKhEA7Mha62PQrADx8yd2K5a/bcP57eJ+aOVNf5F4
	557Xu+lfXyFZBirjrdXlVyDQfs8dFIsYydT76PtfKCiKgGaZRyuvhe7KKyfP/72s17if+s
	uH7YLWXV1Ntu3jT59A3MmC8QvJOevTs=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774459458;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dkr/gj2JfwsSBNER/L6mBhUor2WDdG2iMt77dCfW8iM=;
	b=lCN0IlG/QG0lER9LX7CeMoc9Q/9CteNXRN58U5upuKRzbO4I9PAAjZOdJEmWlwLwEomL+H
	5Q80eDurz/WfinSl9mDlriM/fFuE5pVfNGWqRmAVm19H5qT6ohEJmerobFaCRXx5gVZng/
	SZLyhvr7zRoAUGFUmwNh3Ycm1SZmNko=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=niHokkjg;
	spf=pass (imf24.hostedemail.com: domain of catalin.marinas@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=catalin.marinas@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 9645D2444;
	Wed, 25 Mar 2026 10:24:10 -0700 (PDT)
Received: from arm.com (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 0D5EF3F836;
	Wed, 25 Mar 2026 10:24:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1774459456; bh=TiuXT9NXs8/Mo9xPQcHRFeA3hC481saXm8LjpAnoYZE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=niHokkjgNoo8Snrt0nc60qG9+ESssyWERXlIiBvh/Gk985Yc8tLc8PYqUdsmOG2ak
	 5WICkB4GH9xceepX+nqSM3xLE0sW1fxX6xE+ctN1GEdHnn37tDwSaAhA6ZzMU8YHav
	 cY36nmtwfb+WZWtcyxOrXvgX7JR/K9ivlJlA4OHo=
Date: Wed, 25 Mar 2026 17:24:12 +0000
From: Catalin Marinas <catalin.marinas@arm.com>
To: Breno Leitao <leitao@debian.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, kernel-team@meta.com
Subject: Re: [PATCH] mm: kmemleak: add CONFIG_DEBUG_KMEMLEAK_VERBOSE build
 option
Message-ID: <acQaPLFaqcwW1Rvg@arm.com>
References: <20260323-kmemleak_report-v1-1-ba2cdd9c11b9@debian.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260323-kmemleak_report-v1-1-ba2cdd9c11b9@debian.org>
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 99B6918000D
X-Stat-Signature: qcfbtxkdog1pkosh6ysr4s3xtxghq84o
X-HE-Tag: 1774459457-880234
X-HE-Meta: U2FsdGVkX1+vxvcCVshKvVgbssespekjzsdue4uh3uTUijjY2E82D2I9V96zsPJvmMk5POSYqEI0IaUDzspCrkb8vhaI4hIXRjk5rYHE0pjFbcj3XdRX3oH22X1FR5D/+MrdpC3HrEPLUsCzuIL+tAZ3G821X7eBY77WNo3fm3dqyHpQ8EVjTxLTADeVAGXWeKo5r2T/wO3YYEPY8iWWD41SWaoV8GLJRn6C3LQpfCBACmEwg4Ti+X1usv7OFlCaLKFzEfdBhEszdXncNJwdLq3Ri3Tl2wP0qEHc4qulIGGex6PhXL5pEc4yGt4uJYyBzcGmd0x+qM/TwM53jUxX6caGITNhRg73IEOLJY0H5/30rrHMYsvLfmv0TJIGRN1tQHQwCM6ozIcOeN7tcMfiRIgDYLPN159bIqNh3s+S92phFh97wW0auZ/p6RvxKMM5pzBXJCAP5Jf3rTHkWcwokr7hxfzaqzT0pvf5zjQcZyEULhHX1FSYxTnZosj9VtSjUSzDqQ8SZIoyOOeWYMSdTdSsup45rEHp4Y5ffFzw29LVEW7Juv0LNCSr29IrH20NNwQcmIbGbU4uRObWt4gXLdXH+CueAvIxRu6E2puRpPin1enNr3li8jCHjt8iKjHqh2sM/DDFJ6P+Bm0uM6Elh3yQZsCmds5+saq/1/7vghcZGTHMXhCFr0cHuHIdb7Yhj8QGK16aHblCnhQDbPrSrTS2mJbx8yHsRhvRc4j8Q5WXoIMKyW24rub7AYMVTrsvG1xdHJCvlhxjYyIKUvQAD/Sm6naObpntc/+iiCi3vyr3kNvz/O9CuDYwSxbghgZfWBW53PEVIknJDeWV2WicQMx5ADGmi+ivEjtpTKTKdb5/OAacsr6FerI0yusxnMoqgtjq/4OB63D6S+lfE2p3CU0jzO7nkzxbOq1+8CmIE9e7gx0FwjcSwN9eUYsL33Z60nl/pU0QljLjO512UTO
 n75iuYfb
 R5y2InipFDau7NCmK3wSU2l1RW53l+r68N9h+WDbjQ8JsgdWXgMDUc814hOtPgBgwNhO497bZvtHe+aV3Re/2H6RBxhzITrKvJYSrpNic3NJsF+BKcfugmQvPueUjtj3m3gD0HeIt89hq2UBJQjCuoZhlLiNIjYCNqYj/klhhXtJjfNIVn1Cy74i2o7bQ7lgC3F/MpR6X520ing5spNs74u/uYuYb5S5UrsapyST8opgBnPf9VQ7fEpuyE+QlSQkISbI6X0TcXDIqMAW2lHTjbt6H1s7+8RifM86l5Rl+AcvOsrN364He1sM+GgyLGVvGMpAhkpQQ+s682FlJxpD1WS6iYK3K8jpBGMM3UHPMjpIubX0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Mar 23, 2026 at 04:12:13AM -0700, Breno Leitao wrote:
> Add a Kconfig option to default kmemleak verbose mode on at build time.
> This option depends on DEBUG_KMEMLEAK_AUTO_SCAN since verbose reporting
> is only meaningful when the automatic scanning thread is running.
> 
> When enabled, kmemleak prints full details (backtrace, hex dump, address)
> of unreferenced objects to dmesg as they are detected during scanning,
> removing the need to manually read /sys/kernel/debug/kmemleak.
> 
> Making this a compile-time option rather than a boot parameter allows
> debug kernel flavors to enable verbose kmemleak reporting by default
> without requiring changes to boot arguments. A machine can simply swap
> to a debug kernel and benefit from kmemleak reporting automatically.
> 
> By surfacing leak reports directly in dmesg, they are automatically
> forwarded through any kernel logging infrastructure and can be easily
> captured by log aggregation tooling, making it practical to monitor
> memory leaks across large fleets.
> 
> The verbose setting can still be toggled at runtime via
> /sys/module/kmemleak/parameters/verbose.
> 
> Signed-off-by: Breno Leitao <leitao@debian.org>

Acked-by: Catalin Marinas <catalin.marinas@arm.com>


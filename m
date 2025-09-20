Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 51D74CAC5A5
	for <linux-mm@archiver.kernel.org>; Sat, 20 Sep 2025 13:41:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4EE3C8E0005; Sat, 20 Sep 2025 09:41:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 49ED98E0001; Sat, 20 Sep 2025 09:41:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3B45B8E0005; Sat, 20 Sep 2025 09:41:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 2A7AB8E0001
	for <linux-mm@kvack.org>; Sat, 20 Sep 2025 09:41:35 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id B5DCE55B1C
	for <linux-mm@kvack.org>; Sat, 20 Sep 2025 13:41:34 +0000 (UTC)
X-FDA: 83909740908.30.64D61A1
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf23.hostedemail.com (Postfix) with ESMTP id 29C83140012
	for <linux-mm@kvack.org>; Sat, 20 Sep 2025 13:41:33 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="qwL/7fDQ";
	spf=pass (imf23.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758375693;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iyyGW7jA8BZTpeffO3akr8JtG9wvwEYdRYV0WoOwfZ4=;
	b=gACgQvuCDKCahjIbdmW+cd8xRsnrXHIopV+yqygGtDDsTcYtf/CbT+WlZJowcvdxuCuLy1
	sa1PIHSMMcuQlmp5E1R7RwL+Y4jG/GsXtKdbY3wOR/eGXrYj+d+tFILkAnYkUfivvaEIP9
	3kzOBDRTgVcwJ0fTMDf+RkBtfgB5yLg=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="qwL/7fDQ";
	spf=pass (imf23.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758375693; a=rsa-sha256;
	cv=none;
	b=Hzn4Iva5+7FIAbZuvFTWh3cKGcRViXUumoHJs97xjO11vPLBZ/jSCFfTH7cM5zxj5lNpYv
	8aI7CoU5yaVZLhti/NEpbJzWjIimy9OGY5lvG4xYDJqvjamWqw36jcYhBnnhu8t+UIM5D4
	6D4M4UEHsrehUrzI01jw0Mu/9pFkuus=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 3662A60195;
	Sat, 20 Sep 2025 13:41:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B807DC4CEEB;
	Sat, 20 Sep 2025 13:41:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1758375691;
	bh=RDJAEtZ/32oyV42TKebCielH8wuyWaMhvvfTGQP3mK0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qwL/7fDQeWrz5y/TUE+9vIi+MFL1G7OIkBoGGnwd6AWApsB/FNthMANluTL/vvBnB
	 dVXL8dw04UmHs0P0xWW6zF1ViM7clnQI3WW8GBzhhRse7VsESi3YhOxq3U+eqvTIKf
	 mZzF1OayOxRwORTdoUOACpn7keuKBrnXn0ERvzfhyuzZLh0KIP/CNas72X4+13k6jp
	 J0ZU/Srs86bnHMIkGz7yNWAm0MLsbjtkstUSKmrvWu/J2iLAic1w2aBeG00Xcq+Pg4
	 DSR78rQ0wdMyWHx1Wc01TfTgijxFV7vxVB4oR8bs6PTi18zG5gfQmxoStaWVgAXzE3
	 3wvFipC+0194w==
From: SeongJae Park <sj@kernel.org>
To: Wei Yang <richard.weiyang@gmail.com>
Cc: SeongJae Park <sj@kernel.org>,
	akpm@linux-foundation.org,
	david@redhat.com,
	lorenzo.stoakes@oracle.com,
	ziy@nvidia.com,
	baolin.wang@linux.alibaba.com,
	Liam.Howlett@oracle.com,
	npache@redhat.com,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	baohua@kernel.org,
	lance.yang@linux.dev,
	xu.xin16@zte.com.cn,
	linux-mm@kvack.org,
	Kiryl Shutsemau <kirill@shutemov.name>
Subject: Re: [Patch v2 2/2] mm/khugepaged: remove definition of struct khugepaged_mm_slot
Date: Sat, 20 Sep 2025 06:41:30 -0700
Message-Id: <20250920134130.84541-1-sj@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250920122958.nf6vcm6iyl2wz3bj@master>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 29C83140012
X-Rspamd-Server: rspam05
X-Stat-Signature: bw7e1up6ikyamjrfnb8pzhax31e3yrsn
X-Rspam-User: 
X-HE-Tag: 1758375693-485623
X-HE-Meta: U2FsdGVkX1/tq+so2ncfZt1ijEsyZntVZ17cdmJwEoxI7t13N1X1r9DIwBgW1l0FTgWNxhDjte+6wMokrFcX5qqGQ4lG+4rJsJQNZ8qw6YzjQ6dJB8L52fi2zZSqrqLM69nhNxcKXGTTrwtPf5zD35oXUj0bMwXJMv9ElisIRuId7HtyO9K8nBie/4YiGNaZNZUefyBGc2rUR2KTKB4NObScqCrDF9BWyjBfm/fdKgXjDmNZHdpG4H453eCnkaNbYua6p3t64dMzOp8hR45Tdsi2+B5AlwKu5NPaa/pU/c75RSCpcuxebuEK5YoNyBd5bIurqFtSQB4TBBdlaUmL/wi9aFLZzNadu3i05svXztTI2P8ydpw0jkBhaNp4Fiv8dBW+GL5WxuJz2HpshOkvaw8ocIku2+wW+9rky8KCC6xcyP6FOR/1HBbrmDrxCewlQ+Qe1TdtBbVK1sPLCMa2rJ1W5BGr5mKAyM70tKOVwCRC1y3bZ/+qdzjRHmLCPf1Q19weClF2qBUuTqK+V3AfSsOS4Ukd2Ibc29wKuBgThikDFH8YWPJF7ziXNcgNtpitZe95++13rvtgBjVCK271VYNrYQ/FwV+O6j8l5nU25oDUmJe1ZB6Xa5Ps/FS3py9xm5mlfN6/wxoB80LRaHfQWT5FVg5Wlp7qXZHEkdNcoUtNWaHj4srHsill08r0K0HJby2IBsA+LRlAIHLER+YyuJJWzs4bnW4H196mJTS2vgXu9/9vUlXxiFMBgsZ8DqCQvRSygbqzdbp0RuhYpSCAmDgVKx/syy1y/RNGZzsWi+Gscuzo9sBxY7BIUI4o8l608xgu3CbS5ooA80WYnJ4o/klhHPe8fKYO9YAlFzC4N99uYmLfNp3FB8i67FHtUc/ZhNsNlNdfqaCY/yTKJCVSeYgRmYb7n10rFIEBv5HAVENDeRWJNabSMrpGKMk5++AKDxkhJK0GGvCtuj+9/9l
 FF1+G5g8
 Ov8G0Adwzlei9KjeZelHw0jkEsQHms1hmJfSUdr9Krp7CBVqdt7ThyeuiK4yoo/ctcfCGtxD3waDVtDGYUahA18LxytNZJYFkJShkYgkoMXN74Di3ZOYR9FHWJsgdfbFN7MRqoVjR+hAeFdz9pe0yw19dXGOcox9XU+fjEEGsuI1Dck/4QW63AJjAvMN8Qn0Y5yZ8UPOrMLx9Hf8ZH+A6aD9Mr9is/6UmdxuclMjiy3Ac/kFe1GSN4qCB2l/2JmvAGjFBSsv7zPMmTBYifH3c6+IsIa1L5boVMhb6XCT9AziZTKl68Ux60z0EvLchSSNAaG5VGzzsQDrYTkl2MdHnD/qJF1FUw3rJxl4X
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, 20 Sep 2025 12:29:58 +0000 Wei Yang <richard.weiyang@gmail.com> wrote:

> On Sat, Sep 20, 2025 at 04:52:33AM -0700, SeongJae Park wrote:
> [...]
> >
> >On latest mm-new tree, I am getting below error while building UML mode kernel
> >for kunit.  And 'git bisect' points me this patch.  I'm not familiar with this
> >code and have no time to dive deep for now, so reporting first.
> 
> Thanks for reporting.

Thank you for fast reply!

> 
> >
> >Oops: general protection fault, probably for non-canonical adI
> >[  356.456907] CPU: 34 UID: 0 PID: 309 Comm: khugepaged Not tainted 6.17.0-rc4+ #370 PREEMPT(voluntary)
> >[  356.457702] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.16.3-4.el9 04/01/2014
> >[  356.458484] RIP: 0010:collect_mm_slot (mm/khugepaged.c:1427)
> 
> If my understanding is correct, the error happens in following code flow:
> 
>   khugepaged_scan_mm_slot()
>     mm = slot->mm;                (1)
>     collect_mm_slot()
>       mm = slot->mm;              (2)
> 
> Looks the reason is slot is NULL at (2), but we have already accessed it at (1).
> 
> Not find the cause yet.
> 
> Would you mind sharing your UML config and test step? So that I can reproduce
> it.

To reproduce the issue, I do below:

    $ ./tools/testing/kunit/kunit.py run --kunitconfig mm/damon/tests

Then the OOPs happens a few seconds aftr the kunit run, or during the
kunit-purpose UML build.  The issue sometimes doesn't happen or take time more
than seconds.  Since the code is related with khugepaged, apparently there are
some timing factors.  But I was able to reproduce about 3/4 times.

It was also reproducible when I build and install kernel on my QEMU machine
using 'make install'.


Thanks,
SJ

[...]


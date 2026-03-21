Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 721EB109446F
	for <linux-mm@archiver.kernel.org>; Sat, 21 Mar 2026 17:59:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D0ACA6B00FC; Sat, 21 Mar 2026 13:59:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CE26E6B00FD; Sat, 21 Mar 2026 13:59:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C1FC26B00FE; Sat, 21 Mar 2026 13:59:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id B415A6B00FC
	for <linux-mm@kvack.org>; Sat, 21 Mar 2026 13:59:25 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 7C7AC16060A
	for <linux-mm@kvack.org>; Sat, 21 Mar 2026 17:59:25 +0000 (UTC)
X-FDA: 84570832290.23.C2F4CE8
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf16.hostedemail.com (Postfix) with ESMTP id AC0E2180002
	for <linux-mm@kvack.org>; Sat, 21 Mar 2026 17:59:23 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=chMULYR9;
	spf=pass (imf16.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774115963;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jRxodJt1kTeaEKxopmskxZeBVq+n1PY3TQFnl62VdOI=;
	b=eSHf/h2luFBvxsKsDHpV5w+XAKKWH1JT7kvSp1INLtcg3MuMrQIMW8KmM05H2HlGH9dcCA
	k3r9D1nYEeAno0OuV4QhF8Xp9XJu1mdDJeCjlyEi5leEeV3uMJhL8XygBF99um0Kh0Z7WV
	TPmzZn+/mqxMtdaYyWvxNk/pqm0g7Xw=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=chMULYR9;
	spf=pass (imf16.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774115963; a=rsa-sha256;
	cv=none;
	b=rMbALzgo+yrhqYY69MdR2SnXhF9NC7ZbiOCjq8bM8Qu99I6AdiH/GTVzopE1edCAbiJykh
	jqYKP4Jea1ovOLxPdm1eoP2J0gUVyzd4GqtfhxwRmQBQ7hlhrXstKOE7lZPobplWn0PgLl
	sRjIm30WvZe2VH52MDcCRtn9u7laJaI=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id A0F4943910;
	Sat, 21 Mar 2026 17:59:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A1DBC19421;
	Sat, 21 Mar 2026 17:59:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774115962;
	bh=84p3Slq6ofODyReBGmrKpMl97d43ab6ti5Ey5r2+UOk=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=chMULYR9rnO2u2qWOsi9FI3oVkk7OZ/5ggenjdK2tuT712lAwlWmJgnG3Fp9csfkT
	 NEGx9xzqA1r8Ja5rZ7n6+IzyEbRz9+s1K71t+rJEgezfWRmGbrc10MNuGREnDC087Q
	 nSL/fbNWNn/OFm77WuB9cVNGDeHVDJZkLqbkqJn4=
Date: Sat, 21 Mar 2026 10:59:21 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Youngjun Park <youngjun.park@lge.com>
Cc: rafael@kernel.org, chrisl@kernel.org, kasong@tencent.com,
 pavel@kernel.org, shikemeng@huaweicloud.com, nphamcs@gmail.com,
 bhe@redhat.com, baohua@kernel.org, usama.arif@linux.dev,
 linux-pm@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH v7 0/2] mm/swap, PM: hibernate: fix swapoff race and
 optimize swap
Message-Id: <20260321105921.19388b7acbc0f8d6036e29a7@linux-foundation.org>
In-Reply-To: <20260321103309.439265-1-youngjun.park@lge.com>
References: <20260321103309.439265-1-youngjun.park@lge.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: AC0E2180002
X-Stat-Signature: h1w9ia4fumbe1yn456zkpkyc3pz5yibq
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1774115963-74339
X-HE-Meta: U2FsdGVkX18zfI8yt8uohT8HfUtSIp7qQyWgUwYJKYVkesCKRv1HmKlyEr4skxWdQBWyJOeIoSG5pgpoc5ExetaEUGS2fm4gi4uhNc9XMpwMjckdWwq4A7SI6SesxS9FAXMBhuV35hHAJEpSmn12fQ91IbRQoo+urK4wnows5iy4g6T/RzDu7TwmS3uhg4FkB6CiL13NWEgtMcqKmEKqc+//8qVaf5v01Cgi9YUlOwCiNKOFEZ3GrMWZC1iLTDajzurw2YSR6kAibp4VkxZ8l3lHw19iTFVfYOFJI6dPMD4/kwOQt7jrjmpq08QIXT0Fk66+O3mI4PSnx6TqzhtFcZJSrgMCcItNE64+OYOUdKZG6+UQAC3Lgy2Mr9eenf5cLEBbx1LSjLwjn+w2jKV0EJ+eKiWXoxZE9fc0M2LdSxncqb4k1chRvXY+iqnqfUigbidXa7LdCgTgGPj1h1T+BRg7VWFTVniXYAA56dEhwunVxIqZq1VZ2S+NJQT7S2d5PBbSvzQim0KoqG57iBUENmVisfqhWGKgq0zwDbbzdblM2fCYic7htLJZr6AfvdQEgLhsibHF8mZCGXpUzqVx0hBxPev7MxLkwaCNXr6sW8ZD5x6YnTXATr2CU4Fb0qOlzRwSEkvNgmfW1/x40kSjr/pcmR4ja2XhjR6ey+K67PEWIJ/cc8INv067Vkth5QnZYYcBPlvbgZVfaDeKGZl7xUuwPzF7meDlfr6IK3wo+EbA3TuLgIz4ylzdbKYLF7Y8hZQxRsA2B0cQLXNAkMw5nr8J1IA8SW1CXfMJzZs6LebZpGOOZZL7QJpPkTIXbe3JmZAirupmVaqyQvbjyXtOR16cI7WnKi4M3DWxPzwJC7OVNlCM4cM8dfaArHvr+aexm0HcH4bjSuMwAT84OcQgO+ksLUmOxguowmxbkLe1MQIVWQx2lN4iRw2ePD++qaVvaPrAxuGpmJ+sMp0IMsF
 t77oADXy
 ZUkAzsdgV8/n0ZDiI+vqL+pMTYi9BfRKfB0ztcafQV83NZgOjpPLQDz86Rk4OaycFTMEO7bnXWECS9IL+jew017r4hY/h5MGS7bdtyUtLAo/Rtoz8QGLHe34S9QLs4GgX/tqbnnsf8R2Ei3mOnGJaU8chELzVS6IQyt7j0OY+lKsHRAMahBsQoy0G7b/Xh74/3ePO9dTcosmOOEYhU5ZLjMe+qVeFK5Lw9KoI0WMSKukpIE2HlrrcOJe/JxsjFr/Fap+1Wu6IiB8mftaKvJTTKubCmKWmN/+Npus1T/uiIs3m3V6xgVh6js5C5eDcYSE+o6amT6WfYtNJemoA9rgMMlv8nA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, 21 Mar 2026 19:33:07 +0900 Youngjun Park <youngjun.park@lge.com> wrote:

> Apologies for the frequent revisions. Hopefully this version is close to final.
> 
> Currently, in the uswsusp path, only the swap type value is retrieved at
> lookup time without holding a reference. If swapoff races after the type
> is acquired, subsequent slot allocations operate on a stale swap device.
> 
> Additionally, grabbing and releasing the swap device reference on every
> slot allocation is inefficient across the entire hibernation swap path.
> 
> This patch series addresses these issues:
> - Patch 1: Fixes the swapoff race in uswsusp by pinning the swap device
>   from the point it is looked up until the session completes.
> - Patch 2: Removes the overhead of per-slot reference counting in alloc/free
>   paths and cleans up the redundant SWP_WRITEOK check.
> 
> ...
>
> v6 -> v7:
>  - Dropped Patch 3 (pm_restore_gfp_mask fix) from series as it has
>    no dependency on Patches 1-2. Will be sent separately.
>    (Rafael J. Wysocki feedback)
>  - Andrew Morton's AI review 

Well.  Roman, Chris, Google and others.  I'm just a messenger ;)

> findings applied only to Patch 3;
>    Patches 1-2 are unchanged. (no problem on AI's review)

Seems that it changed its mind!

	https://sashiko.dev/#/patchset/20260321103309.439265-1-youngjun.park@lge.com


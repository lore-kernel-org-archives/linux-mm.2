Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 99B77CCF9F8
	for <linux-mm@archiver.kernel.org>; Mon, 10 Nov 2025 01:56:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 640708E0005; Sun,  9 Nov 2025 20:56:27 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6180D8E0002; Sun,  9 Nov 2025 20:56:27 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 52E9B8E0005; Sun,  9 Nov 2025 20:56:27 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 3D0008E0002
	for <linux-mm@kvack.org>; Sun,  9 Nov 2025 20:56:27 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id C08DD12D8A3
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 01:56:26 +0000 (UTC)
X-FDA: 84093032772.08.E78CD3A
Received: from out30-99.freemail.mail.aliyun.com (out30-99.freemail.mail.aliyun.com [115.124.30.99])
	by imf16.hostedemail.com (Postfix) with ESMTP id F3457180009
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 01:56:23 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=UnlODuQP;
	spf=pass (imf16.hostedemail.com: domain of ying.huang@linux.alibaba.com designates 115.124.30.99 as permitted sender) smtp.mailfrom=ying.huang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762739785;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=h2Vc1MCnbF/ttJ2+MkLrZKM08vvpbJ9pspqnCXu4l4I=;
	b=HVcHYPu03Jlj7vsXGUsN2hoev05j2yi0XHsTk7CLbeh5uRxfGd9mw0RQzHDgyt7TVyAv56
	SKsFNwBXUdBtKO2b11K8xkAZKIB0dDzbS2Y31y5E9PFYeaoVY401A93pifo5tUrt0Fg/Be
	LeMWKDkM2rqIYMX2Z5lmkiVGxKgiy04=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=UnlODuQP;
	spf=pass (imf16.hostedemail.com: domain of ying.huang@linux.alibaba.com designates 115.124.30.99 as permitted sender) smtp.mailfrom=ying.huang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762739785; a=rsa-sha256;
	cv=none;
	b=NtbliW1tRKRX2xUnUjb2wOqG9GW4tOssEjFkpkODBzORjDRgIsCzuayqAaRmroq0AZ86+L
	+pg7S7j1fPKHU0a7q55i2bPraGx9BharWQoLUAUU2bjHpGXa8PiHQILzq7/EZqj/Z49hRg
	/MdkEiw+v83+OOukrGgxbQjuw7+dQwE=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1762739781; h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type;
	bh=h2Vc1MCnbF/ttJ2+MkLrZKM08vvpbJ9pspqnCXu4l4I=;
	b=UnlODuQP6YYsiAhKNCwEOSsZRkKn+jmtMK0i3uPvdjNt31onkTFLlMJWWGiY0HUNBS7StTv3bCz4LGHBvhWW39oZFLPv4VYNBlwXSnzrIBVlvxi0vC9qohB6aA3FQ8CwgmowV+1k+BjDe9clZGS87QQHRwPint/VRGIAaPMjEfY=
Received: from DESKTOP-5N7EMDA(mailfrom:ying.huang@linux.alibaba.com fp:SMTPD_---0Wrz7d2o_1762739770 cluster:ay36)
          by smtp.aliyun-inc.com;
          Mon, 10 Nov 2025 09:56:19 +0800
From: "Huang, Ying" <ying.huang@linux.alibaba.com>
To: Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org>
Cc: linux-mm@kvack.org,  kasong@tencent.com,  Andrew Morton
 <akpm@linux-foundation.org>,  Kemeng Shi <shikemeng@huaweicloud.com>,
  Nhat Pham <nphamcs@gmail.com>,  Baoquan He <bhe@redhat.com>,  Barry Song
 <baohua@kernel.org>,  Chris Li <chrisl@kernel.org>,  Johannes Weiner
 <hannes@cmpxchg.org>,  Yosry Ahmed <yosry.ahmed@linux.dev>,  Chengming
 Zhou <chengming.zhou@linux.dev>,  Youngjun Park <youngjun.park@lge.com>,
  Kairui Song <ryncsn@gmail.com>,  linux-kernel@vger.kernel.org,
  stable@vger.kernel.org, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Subject: Re: [PATCH] Revert "mm, swap: avoid redundant swap device pinning"
In-Reply-To: <20251110-revert-78524b05f1a3-v1-1-88313f2b9b20@tencent.com>
	(Kairui Song via's message of "Mon, 10 Nov 2025 02:06:03 +0800")
References: <20251110-revert-78524b05f1a3-v1-1-88313f2b9b20@tencent.com>
Date: Mon, 10 Nov 2025 09:56:09 +0800
Message-ID: <875xbiodl2.fsf@DESKTOP-5N7EMDA>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain; charset=ascii
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: F3457180009
X-Stat-Signature: eex1xrday9w9xhkcngztoziymtygnepp
X-Rspam-User: 
X-HE-Tag: 1762739783-346472
X-HE-Meta: U2FsdGVkX1+dDqTA9+c5rIgnshMEkRwHPFTsjHmMFiFJfrHwpRQh34q7OUVkiYElsOhvnVbpbT7olPdopIFPh/TXNc+kyEnB3zlPRmrZkg+EgEv1VgM2bbgt0Cat3+l7rnYBRIK0B2IydevIi+10ePIh5+KhqFtLWNF0ghUTflq5BK/OLurQrP/4qpZoM3Xj7L7cSw3a01YC3P+nuHyKHM8eauHZTjMUC8p486q6QN/lGlucdbfJnv/Exxnq76cQFGEFvqtWUd2CwyqYQrBJc46elqOIi8CYWGMp5HVMxwj+QFJBEMY5gKdd2+eydqhZHhzE5agICB+bSagTGZaZRoI0z618Tz5Btl1jnA4wsC+/ZDTWJdH2FbtOQIyXKn8QY31vlmUiPdsrWFNeLJTen3djH9rApKVJIPzDrdErTHCeuYIiw20xkNnParuQTavoSlnsbFx+UOYveouvli6KZY4u9eCUX7fbXTYHF0jDfWrrIiE4XkgBkiD4nDEYx/IttClWKwxkVSPHBfkw9PIutbLneWfRzlycQSLWWcYXd1/VYHgnkSBQgSln0fsUruR02/lMug5Yv865GdQmqrJNl5WASJrdjWRrVXqGyyUw4XLibv4sgG08o6PGt9kLtgzprxFJqEzqoorE7ggbDkb6bO4ZA9SxIz5DJ2kels2jAxJdpyEmn2nsSiwfTCYCRqcAsJv/m2D7ddKif3OmNyxrj9pNqpjp3XWmKjW95qhkjM7qHm1L++ERXiY+f9nzQMHeB6qqSSWcYitU40DgZVUfzZQSyAdvENK46o8y77vSfCeDpQzkMzq8OirFJoa8Me88Q7OtfY/En6LMojlnQYzjeo1/jYREc6SGy9UeVl2eEz32qe7D1jcUoOk8x1oOYUSq/PhS6neG/yGRyoTufnJb3y+0tv8NemUeRfdUUmCG0jndUmzM2F3BOIaFIzjmQr7BRBqDSAN4Bypuu+vjySr
 6kbelJVT
 GCgsXEaibo+4gRW2ppZrNh1gk3FU4DrdhalejDFOFFQnZ5JCZwZQSIMS5OTWBOWjWxqfldS8WcafWsx6sFiN+2ZnTQrHdQDQtfNosrnYoM7oJVC741lprTRDoYKAU9ss2ZzFWXIGklsJvTKfs2y12soTKqM8Ej/+zJTWpLi+Qd7Zvq//FfmJ3QUHR6hTPGxqUsGkOYE3bd3pb+gVCYp/V8JoBIrzv3ljnUAqf4quOM1KPgFF92hMM53rP9mfqntghQt3zBWl6ASTFpX7olMvmnf9WxQVp5rRrVp6NX9CNz15qWXNS78Q21NPAGtv7JluXTHwEbXkN073ewK6oPsqS+jW+/0tkGDjccZ6v6CD96rJ1JKLAvrWrbAS9KaaL1i17pj9l1J1h2oy0v9EKnAKi17cESDu6JaJVqr3b
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi, Kairui,

Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org> writes:

> From: Kairui Song <kasong@tencent.com>
>
> This reverts commit 78524b05f1a3e16a5d00cc9c6259c41a9d6003ce.
>
> While reviewing recent leaf entry changes, I noticed that commit
> 78524b05f1a3 ("mm, swap: avoid redundant swap device pinning") isn't
> correct. It's true that most all callers of __read_swap_cache_async are
> already holding a swap entry reference, so the repeated swap device
> pinning isn't needed on the same swap device, but it is possible that
> VMA readahead (swap_vma_readahead()) may encounter swap entries from a
> different swap device when there are multiple swap devices, and call
> __read_swap_cache_async without holding a reference to that swap device.
>
> So it is possible to cause a UAF if swapoff of device A raced with
> swapin on device B, and VMA readahead tries to read swap entries from
> device A. It's not easy to trigger but in theory possible to cause real
> issues. And besides, that commit made swap more vulnerable to issues
> like corrupted page tables.
>
> Just revert it. __read_swap_cache_async isn't that sensitive to
> performance after all, as it's mostly used for SSD/HDD swap devices with
> readahead. SYNCHRONOUS_IO devices may fallback onto it for swap count >
> 1 entries, but very soon we will have a new helper and routine for
> such devices, so they will never touch this helper or have redundant
> swap device reference overhead.

Is it better to add get_swap_device() in swap_vma_readahead()?  Whenever
we get a swap entry, the first thing we need to do is call
get_swap_device() to check the validity of the swap entry and prevent
the backing swap device from going under us.  This helps us to avoid
checking the validity of the swap entry in every swap function.  Does
this sound reasonable?

> Fixes: 78524b05f1a3 ("mm, swap: avoid redundant swap device pinning")
> Signed-off-by: Kairui Song <kasong@tencent.com>

[snip]

---
Best Regards,
Huang, Ying


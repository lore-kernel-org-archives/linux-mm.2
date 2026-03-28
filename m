Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0F3E010F3DED
	for <linux-mm@archiver.kernel.org>; Sat, 28 Mar 2026 17:40:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 09A6B6B008C; Sat, 28 Mar 2026 13:40:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 04BA36B0096; Sat, 28 Mar 2026 13:40:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EA39D6B0095; Sat, 28 Mar 2026 13:40:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id D980A6B0088
	for <linux-mm@kvack.org>; Sat, 28 Mar 2026 13:40:02 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 896A21B6F02
	for <linux-mm@kvack.org>; Sat, 28 Mar 2026 17:40:02 +0000 (UTC)
X-FDA: 84596185044.04.232A407
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf23.hostedemail.com (Postfix) with ESMTP id D8648140009
	for <linux-mm@kvack.org>; Sat, 28 Mar 2026 17:40:00 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=aBEk0qOU;
	spf=pass (imf23.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774719600;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MLSCl35bqtz4h7EqhNPdlTxnR7jxUbQI+9QVTH+dae8=;
	b=mJkizEATdBOxyKV88Ch8pIP+0XaPaxIJgSSFytag94kmE9s0g+jDYKexorqwfOQTghNBQ0
	9FMdpl8UfcGa16y1gFPf/YwFJY+2M2U680pMDFAQhVQvnqaP60LlG6m8zV0MtKlgNWb6tk
	f2FFX4fjD+X3nobwC7N++RNVCQCsSHs=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774719600; a=rsa-sha256;
	cv=none;
	b=CWsp8kS2zU9fwBbuFnDknVQvv/wK3DZeLRUonjt3xgp/Jsl9HghLww2ceN2kgsbEUQ7YWm
	a8dl/pbe4/KmAC84+5oQtOL//kGf5JH31gf314/Wd+X0vILjeh/DegFD+MN5OBAzyFqBo+
	xmRJMdx5b/WHofJ2SEdiLu6hbFPkYrk=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=aBEk0qOU;
	spf=pass (imf23.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 3D84960018;
	Sat, 28 Mar 2026 17:40:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF5FCC4CEF7;
	Sat, 28 Mar 2026 17:39:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774719599;
	bh=CvGqcc593VzG23ikPjsoJXo4HOiKi2mitRDUYqcfKF0=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=aBEk0qOUrYIHyyQ7WnA9ixpbUNxja1hUtWp0/OwMhuR25aZbJbVQtLto1DwKSbFZN
	 ABRbuAG809O600Mom8UZ/FdHxBg8pIH6fe0826r2Rhsl+KQRrXGNJo2aR1Mf33c8ic
	 XhLNVmP5GEiJ0nV/w++qVcYYQkpLxXTAO8fDVJZ8=
Date: Sat, 28 Mar 2026 10:39:59 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: syzbot ci <syzbot+ci9dceb132e443f5a7@syzkaller.appspotmail.com>
Cc: linux-mm@kvack.org, ljykernel@163.com, syzbot@lists.linux.dev,
 syzkaller-bugs@googlegroups.com
Subject: Re: [syzbot ci] Re: mm/page_owner: warn when stack trace depth hits
 PAGE_OWNER_STACK_DEPTH limit
Message-Id: <20260328103959.a4739ffff3c8d7a6f4d60732@linux-foundation.org>
In-Reply-To: <69c80fa8.a70a0220.97f31.0002.GAE@google.com>
References: <20260328214408.2990597-1-ljykernel@163.com>
	<69c80fa8.a70a0220.97f31.0002.GAE@google.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: D8648140009
X-Stat-Signature: pkz76khcwygfz1oawkzoz45cs1pttuhy
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1774719600-65495
X-HE-Meta: U2FsdGVkX1+vUarGNi49AL+Kcfc2THunHB1I84VHdG5dZn1EaYhelhxd4YDVB+ANmSa2zLbTGurInha8O1H0xSW0+L+yXS5r87ZYMTFRygtOywvgTqbpc2wChKCOMvHlTSYGnflP7WB1xyt7wlOO4s3PLQC/V+kwm/C/ey7TVkVr/gj3HHBdI6J8vJezS/+EmG+HsZf4mDE/y+2J5nL6EKGngqF89cFG8xpZ7Kup5SYztcZV0ApqhL6OEc/gdbu1ENNHZFJZPYVYsP3Ey+6JGVn4g/pwhwrEAxvXstoU/GTkJNaFfADVA/tqdiAJ4keWnrw+kcFr7uyFh0iI165pgtOIVls/WjrZY1Mnt+c1qXxOcmPqrmjKEIeEgVQHaGsSaS9jQojDCQjEJ9m9hY0dSiBJ2NyPzmLtyIza7XEIT51NrX3UCbOXbYwtxtxwU3SZt79DTfm5cr52pH62qSybrSrrb02NvtT7jhu29wk92cYdZHWOMQGzMkw+cOpkT4cgCV6CB9b2fI6sdckxe7cUagEN7sqbo4GdGwAFX9cnfvVti8jyvWpqLuTUlSDWJyvWz9D7gLtYAsY11BHcfAmiIIZiCw5OZqYhrCBYaPaXNoBunHXUV/5GIqiJil2bsuX8vQdICXOCwjccBDF3DjiC7dI5mVj0yKbJuueA+UiWD7MzOv8fzqBiaEeSbpbZJo8aNkndgYy5mCVPj4OOd6UhOC/iGd+PpdkL/Cuo2QM5zAewY48Twv8fkJC1BWCaXRT6TVq9KylUaoVqVhf5bD5VtWYpcALHut2nia/4TFsMbEpgfRAjiYW8INQJCHra8EEKceMfI+7afTGnNtjlZa5QVCgH6ky0Tu+rnLDapB0psf/hiWfObhszbmiZR6siPOUys9qTvsficxt28nOJXEcFQh4bsY+IVQ+XaQeyvQUMbhQcJeEFADVBu/q5SnsXbZdjdDZuM9xcF6yLotvvc5f
 QH+pep9S
 iQqMB7AnxEPb/wXeKaNAUvkK8kfGX0JmBVC+6Z+G7cLQyYXryWwMru+IOznnXjEV0cwotwgDuelHBviLboLwSioJ5fMrEjVKnj8AfgRepeOri9++gAG/hxnXttBzddH7SQqeepafB+9y1HrDghckIHwrquZtueChv8YLyIrOvAAvBP0L/MLcMW0DblWJVOEap2eWE6pNiwSZ6v6IvF594stsvgyvG8yE2xAve3bxrunZHu6Nvtl4I/HgvyzyFlkcu1ElzVeFi9s/IUG3754bC9JtBzWIjEjNhHMYwyHkngzMGCwMACcO2BFytrQ4bqrMg/yP6vwmi0MS/kGBcJj/kcvESTt2FB3U8RXgz6WdJIzZjyO0gafQ/LbyciLZPdRP1Ukff3l2U6bILeB9hYtukbtXH9WjWvHljg7rVIPmv9X1w5WTur+mEK5dKHUr+zLPpOG7g+m0PrA5d+K/QYT+jati4ibgZNZEMmh+CZIaMsHUZ6uhRJUpOH+ZcM5OjGX2vG/qOBu4jB/2D7RrZYPla/gs8YkVGppxuFia+uHPuX9Ug1GK0jIag9EMpN+kAvDgYvg056Gcqlxe4w0dws+U13BebZaPsShcHI7tRt2lJPhieX6RLdT5lk4prou/oOMu0qmtdboS+Posi9nk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, 28 Mar 2026 10:28:08 -0700 syzbot ci <syzbot+ci9dceb132e443f5a7@syzkaller.appspotmail.com> wrote:

> syzbot ci has tested the following series
> 
> [v2] mm/page_owner: warn when stack trace depth hits PAGE_OWNER_STACK_DEPTH limit
> https://lore.kernel.org/all/20260328214408.2990597-1-ljykernel@163.com
> * [PATCH v2] mm/page_owner: warn when stack trace depth hits PAGE_OWNER_STACK_DEPTH limit
> 
> and found the following issue:
> possible deadlock in hrtimer_start_range_ns
> 
> Full report is available here:
> https://ci.syzbot.org/series/aa38ba8f-44db-4d01-8965-ed5a27174f71
> 
> ***
> 
> possible deadlock in hrtimer_start_range_ns

Thanks.  Sashiko reported a couple of things, one of which is a deadlock,
probably the same one:

	https://sashiko.dev/#/patchset/20260328214408.2990597-1-ljykernel@163.com




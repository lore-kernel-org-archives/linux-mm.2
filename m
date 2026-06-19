Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4CFD6CD98FA
	for <linux-mm@archiver.kernel.org>; Fri, 19 Jun 2026 00:55:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1331A6B008C; Thu, 18 Jun 2026 20:55:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0E4596B00B7; Thu, 18 Jun 2026 20:55:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 022776B00B9; Thu, 18 Jun 2026 20:55:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id BCC3D6B008C
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 20:55:13 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 1DF0A1C1AAE
	for <linux-mm@kvack.org>; Fri, 19 Jun 2026 00:55:13 +0000 (UTC)
X-FDA: 84894843306.01.314BC06
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf24.hostedemail.com (Postfix) with ESMTP id 8AD8D180004
	for <linux-mm@kvack.org>; Fri, 19 Jun 2026 00:55:11 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=nQslR0Ay;
	spf=pass (imf24.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781830511;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=X+9uTAgjbY6OtzEwlDtJNEKcSt+eoz2L0sjllhTO1o4=;
	b=wTb6VwJwa3USTAve24gt1zwe2YxEz5ZKNUt0Jths473qeSwpcVhcTHtb1VzZAdjSvxdyUg
	EEwPLOtZAGi+9CSYE8sS4eHu4CXj6fXe1NDou77wuiwx5yIJBVAyjb2n87V29ET2vJ4rNn
	TGe0W7pjMl08ncyvWMhNA3P9EPD2Ll4=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=nQslR0Ay;
	spf=pass (imf24.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781830511;
	b=n+wlTcdPrJJHpyD/BoBs1WWbCCBScJGgRhA6kWtXQjSLtRfHWXbFlFgGXy9MY/M11CcOPx
	jGnpC2+CEZQgMV/PAYpv5ZH0UFn8rT4yUgiGLjo1FE0wWFhDjQ7A87v2kwyT87YXztquVH
	vLERNoesLEN/ge4Bn8BqAoUmyUwMPHk=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 79D8B400F1;
	Fri, 19 Jun 2026 00:55:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 609BE1F000E9;
	Fri, 19 Jun 2026 00:55:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781830510;
	bh=X+9uTAgjbY6OtzEwlDtJNEKcSt+eoz2L0sjllhTO1o4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nQslR0AysYs9Cqc/sOPoW4i2CcA6GSOSkQv/X44IuPYtq6GxgiR9Ahu7AKMTTB2em
	 rvBeYKa66Z9ra72s6tWp2PxiRuhRV5aDnlLIjVVreaOKj/ZhArZtdVGSTnytmt9TPp
	 6jU9gkNtTsSghIk6fCWMfeAkC7ahcWZbpB7AplegIfVxP6EgrbUESzs0hdNp3D5815
	 WLtmkR8f3GHfTa6SSy59ON0IX2BC75BVx0iwhDk/iICeOCkkiDyUOyIhXuHta7pmsU
	 Xq78Gsk1GuklxU1ynJ3iRLaJG8mWoQi/4K37XRA/PdGy1lgx3nBw5P/a+BsJFmwvdk
	 yQlX8kU1MtHVw==
From: SeongJae Park <sj@kernel.org>
To: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-mm@kvack.org,
	David Hildenbrand <david@kernel.org>,
	Xu Xin <xu.xin16@zte.com.cn>,
	Chengming Zhou <chengming.zhou@linux.dev>
Subject: Re: [PATCH v2] mm: remove PageTransCompound()
Date: Thu, 18 Jun 2026 17:55:05 -0700
Message-ID: <20260619005505.9038-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260618113523.3913307-1-wangkefeng.wang@huawei.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 8AD8D180004
X-Rspam-User: 
X-Stat-Signature: ydrrfdk6e67b7k737bot1bqrn8znuspe
X-HE-Tag: 1781830511-864420
X-HE-Meta: U2FsdGVkX19zzzXLuNxmbYk5J3JE6wYBSCtcYBdJqLz20NY90WXegpwXyNG8xy53heegrl0tLYZr3mqQZWFQTQe6uANpQwlfdWqW4ZgwgYwEAiwkKKPxeh85wQzLkdlziSGeYheMhq9rReiBUbasgQ4TsqLDW1XZo6FfhawQxS1MLZZtVqKs3+Z3I0fFq1kwighSY/QsyDLFLNCmMcoXjeJ6PMjWzwY0FoulC7Jfob94Fvf1NYekm8G9zhLxKaJcR5pS4FPWE9bYeOqOt+F8arJ0ZEK24Igx+AXEmkuMjmhi+L19XpW94Eo1GWuZy/nsahkFgN7HcmKkdRrjiCi+AfDIEKCR3WJ1x0spkBewHwNXqLL+5VWenf2nB8F0WYyt1qF8UleXjM6dbjbw67eCfsvwaRN1HlQSQD33iyeOKzcK02Td48k/xQ6f8FzZ00jdI+MxAXt6CGo/OC5m93FdrTQSJTCnWkeNR1Z03IbF17gttHUb5LKqicEXYVnmh8H7iuwRjtXUildr3CR2TdeRgurg2YD2ptYCHFzwuFuzplcdIrVVhEACW3eqbiWCGYUHX74ToaqyIZ7G34BUfY1eb0ntTiffz7BftZ/vncDNBGDyrFL1nH9FP6bKWmHXfdaStBtC9ROSVz6wjwTjYJASuSLUwR9H+vEsUm3uVzbzfhYogtBC5fEHWG3x0N0lE0wv9n0SuB/yOdPhzanop87hc46WlvmLW2NYomfhmq8H8cxYZz8XBdBfxbfpudx3Ij7j/k354RoT8Cgowlr3E5teKVyp9lkeyvX7GViF6aCc0x/t5i59vT9cwnaP7cz9UH5q6Vgd5A2yNX54C6VNQMBfV+uZk9X/YYT9sVOvBwtOF3W6D8oOz/BMy4s8lApQx6TpOukgrZHOP7aQvwA2gFU/eq9p9kKs4MzDMWRhTfdDk+t1OSHrJUY8xTjDuuOp5audm+6thVbRoIcPozULK90
 jcMtzB7p
 WcTWyrXoO6nD5go07TMmxPy17o37vy+2bR6gnH++ysVWNjJU43Fl2V/iN4mJ0d+7t4DA9X9nGHN8egpC7Ya+S2h9f7QY14Z+zpBQHNOsRKURLCTlOv6GSZ1nS1WqOZ1FKSfbw+OGt71F05q8B2RHwMK1S8hG2TZ7R76J1PY1MfMcb17NARcsYe8Kz6REA84269mBBHtZ95M3ZZ6Y3anGH6+rlEruzBbmZppl3wD83hxPAGGGpuNOKTFm4yHgF0Fcz5kEjc+lC9K8NxoNGAWU28Hy/x+Et1Cc1j6w5
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 18 Jun 2026 19:35:23 +0800 Kefeng Wang <wangkefeng.wang@huawei.com> wrote:

> Remove the last user of PageTransCompound() in ksm and
> get rid of PageTransCompound().

Nice!  And all changes look good to me.

> 
> Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>

Reviewed-by: SeongJae Park <sj@kernel.org>


Thanks,
SJ

[...]


Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 08F23C43458
	for <linux-mm@archiver.kernel.org>; Tue, 30 Jun 2026 20:45:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9D8626B00A6; Tue, 30 Jun 2026 16:45:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 98A2B6B00A8; Tue, 30 Jun 2026 16:45:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8A1816B00A9; Tue, 30 Jun 2026 16:45:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 60FF36B00A6
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 16:45:44 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id CBE2E120117
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 20:45:43 +0000 (UTC)
X-FDA: 84937760166.16.B5FA49A
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf17.hostedemail.com (Postfix) with ESMTP id 209FB40007
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 20:45:41 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=EMEdtcEN;
	spf=pass (imf17.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782852342;
	b=lPWDJec2OYLxEBseqOwjCL6oq0re2GPsNg4Kqs/6sDDE5ylrBUNr7Ri7jPDvm/Av1aYgzi
	wAcsEZobVrwCLn82dIoakDBdbWjxWFlrgmNv3ZoNcd1QzQbdaMMhvFnrerU2dcq2EEacKW
	X4CHfXkt3pvSfsCtU3ez3k06fnJgTC0=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782852342;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UjRiWzaf+3IXUGXwj4iWCLtx4c/HoCgAd+zOl3G+fYY=;
	b=ZQsYa7tZ8QUIS/36eDthJdfpCQkH36rP9Is4gMGK7lWTztlZwSFPpv+4gUaMmTku4PXviO
	AGSH8pewORf0G4VaIUq6E+t7TOTXcEZh7qj3Vz0a6am88pMIEOPh+Ztrym7YT3QmUpEz8Z
	gTkzY/ggr1sZSpXbowDT2HpGTvZKmV0=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=EMEdtcEN;
	spf=pass (imf17.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 740E3600FF;
	Tue, 30 Jun 2026 20:45:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB0971F000E9;
	Tue, 30 Jun 2026 20:45:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1782852341;
	bh=UjRiWzaf+3IXUGXwj4iWCLtx4c/HoCgAd+zOl3G+fYY=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=EMEdtcEN80YUQ8EI2alDygIXdqQUbtvrCZEAfj9XCv0A0Y+RaQoEOVlTpRMRTq482
	 n3KjmDtTHqfmgrRLGDajhAwYs8VP0dOgxDOVRoPIanXzMEArowCb1Cewhc1uNQiAUw
	 DiHmL+aeJEFcMQ93LV3umNIP9yHtO430GFiMo6iI=
Date: Tue, 30 Jun 2026 13:45:40 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Arnd Bergmann" <arnd@arndb.de>
Cc: "SeongJae Park" <sj@kernel.org>, "Arnd Bergmann" <arnd@kernel.org>,
 "Nathan Chancellor" <nathan@kernel.org>, "Nick Desaulniers"
 <nick.desaulniers+lkml@gmail.com>, "Bill Wendling" <morbo@google.com>,
 "Justin Stitt" <justinstitt@google.com>, "Ravi Jonnalagadda"
 <ravis.opensrc@gmail.com>, "Quanmin Yan" <yanquanmin1@huawei.com>,
 damon@lists.linux.dev, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 llvm@lists.linux.dev
Subject: Re: [PATCH] mm/damon/core: reduce kernel stack usage
Message-Id: <20260630134540.550e55ba610ea956111d1e6f@linux-foundation.org>
In-Reply-To: <0c57d639-259c-4498-9b7f-3ac46d669935@app.fastmail.com>
References: <20260611125704.3386176-1-arnd@kernel.org>
	<20260611135608.66888-1-sj@kernel.org>
	<20260627223405.3533412b4010b6ce658da01f@linux-foundation.org>
	<0c57d639-259c-4498-9b7f-3ac46d669935@app.fastmail.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: w6bi93u5ibpejbcg3g64yexkriid8h6w
X-Rspamd-Queue-Id: 209FB40007
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1782852341-883248
X-HE-Meta: U2FsdGVkX18wKC/YoVpamp/kXQAoSoJf0PTzUGqOVXM5JivD9us8dpwvqh2oEKgYiEgh4zZQZbJusRypYSJIoOkJr/u1h1I1JV+ykVkmhGgekZtLsNQ03WkIJjpsQFkc5iihuxs+zJiwRiUHtEgdKdwgwj3s72ky3uUkMndi3cQA63LlZoDsgAbzEnq8q8N9tnoxF6RkoprQjgZSj6MNsDYGl4soRqXAsI/wUzrRM9SQzVI5RXbRw3UJAMyfiHY3EIhsfIXkHf+cGGXggv6apOhkl36K21ROEQT7skqBcdtf4rzxbAo4SqRvq0+UMBi0CTIm3IB6WDd+Wl6agUDqo6mcTbKl4woey8ADhBDpoe3WIJX46lUwSMu8sv3xDVCnH3t7BWFGxpOYrvXB9FEB6i2hs1RzUIQnynrU40f30iQMz9E06wU4mTX/cyFPdoi/rUN9X9CXJTVc/kMtlOcRAMhL4Sij65QKahWcA5fBOaUeUjFTfejR4kUO6ZLiToJTIWO44+8NCekZs53xcUN/qjw2yPwZoDYkIRGjpJIMvnIIpX8SzzXikAt4X3ekg/Izm9FtpjssPq9Wfu/4wTVMkxXQdsUoPf4H0oyyk1oiofq3gjmAnAbzbrgXLbRgGS7OkHJPn9w+22MeDO/XO0Kp5Xr61SPor07t7abjaz+gYxjjC+ARNlMIMrZM9DS7RDSAF98vGZL4UzgBX8BRX6Habz93bHPZAC7qCD/toRFEJpwX4zbrTh/W4C8+b/OVVnxk2/YD0WTqad5HshIYSYRaySKFOEnLXeMAlymjXNtNT9n/KS30+FSkbk07yTyuVYjBgRknS+mBnSwof9zMxNJA4/BxDEvoVKHH43mvzt2QFHRMOXbyROlhN33jq7LhVAVKoWqPb6l8rm5NS+NgeisPrNp+hEG0+T6vGWXTpk82l30943MlyUWjzBzcR25cFf8AqjFZ22kD0cup7ZIxJiM
 bGGyYfXE
 ivkQ2R0VquHwfL11zbzBChiOGy0gXbW5iIV30ngxmUHs5bEiIvxgvNspsAAaAb3LW1MtIY4JpP2JRMysjdRGF3ENrBaUi8fAJ3SeNyywFCwoV1joeW56NcYsbZSL1jtmerenhe2lQtOSp0Ba/KZUtfUMLhb6NxtbJFHAQdl6W8HOI3HD58JvHfcuXkhcFVqs8anJpsMrblVAq79qWyW5KSgFwO0b2Z0Th74lQmByfndTr47E0Vo5Ufb2CN1avRle3lBC3vrPPXClXxow/tSptAA0RT22gtVmyCe4CNC3r4LLXl90ymYc/HnpbtbeThLH5J4uUh5d7KdA6NRWYczN1HoLdzvOt8CpWcoc0hjEes+XxJpY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 30 Jun 2026 15:29:03 +0200 "Arnd Bergmann" <arnd@arndb.de> wrote:

> This is clearly an
> uphill battle, but kernel stack overflows are a real and build testing
> with a reasonably small limit is only one line of defense against these.

It's a worthy battle.

Reducing the default CONFIG_FRAME_WARN on various architectures will
help.  It's kinda trollish, but we should clamp down on this stuff and
having Arnd plugging away on his own isn't a good way!


Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 89639C2A06C
	for <linux-mm@archiver.kernel.org>; Sun,  4 Jan 2026 18:02:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 67E7D6B0095; Sun,  4 Jan 2026 13:02:35 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 62B3B6B0096; Sun,  4 Jan 2026 13:02:35 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 52DE16B0098; Sun,  4 Jan 2026 13:02:35 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 46D7C6B0095
	for <linux-mm@kvack.org>; Sun,  4 Jan 2026 13:02:35 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id AB5AA8E138
	for <linux-mm@kvack.org>; Sun,  4 Jan 2026 18:02:34 +0000 (UTC)
X-FDA: 84295051428.14.A638C42
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf03.hostedemail.com (Postfix) with ESMTP id F003320011
	for <linux-mm@kvack.org>; Sun,  4 Jan 2026 18:02:32 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=LpJQM6ho;
	spf=pass (imf03.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767549753;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sukNPMtSOV0nXMIev4sNjkhuhRsCMj+n/zxVIAKDb54=;
	b=NK9Y/ezwMF7/T6xBVMdMV0NWNhbdJ/V3vVYvtQtCIqXr7l+Y91N2jQKUhpzvZUIVmXWEN3
	vaCCN2Z2YmFzgW6sPCG79ccJHE/UyOPa4NGFFzliBlW9714/EZkNx6/MX9OXObT+5zsGY4
	uXovMrIJZBL+P0wJ5KGwHbOUxj4syAk=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=LpJQM6ho;
	spf=pass (imf03.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767549753; a=rsa-sha256;
	cv=none;
	b=s7CJXCnwtvNcv78S9ElOWITsA484cXg3+swNqfMKYqxCM8VA8A52WlguBCal1Dw3azk05k
	+fJXCy7fBJhStGpH3sdSdb+IThM95M1BdxDxy1349BBbrqeeQQS4XUUUnTawDvMyHR+PK5
	ambLDXrTdb4H3c9keYNZzNDwrf9a5KY=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 2E3A460010;
	Sun,  4 Jan 2026 18:02:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95EADC19423;
	Sun,  4 Jan 2026 18:02:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1767549751;
	bh=CTZbCp3RpyYugdgjDwKUDAhn3JkVf+OgS6iO/KiU6cs=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=LpJQM6hoUi+Q1YVYh08n8HeejbFS9R3NXWrFc0lipnhub04SnG50puKjpQV51KYiR
	 HAI2oInhTrkk62gEqsOEchHIehRWy+QiJ8nwL11yPm4BIU1RJf6Ypr/XNICDJsI5E2
	 +IuuUVccAB3441KNKabMLqFiklxzjd7b/v8xlCHk=
Date: Sun, 4 Jan 2026 10:02:30 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Ryan Roberts <ryan.roberts@arm.com>
Cc: Alexander Potapenko <glider@google.com>, Marco Elver <elver@google.com>,
 Dmitry Vyukov <dvyukov@google.com>, kasan-dev@googlegroups.com,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH v1] mm: kmsan: Fix poisoning of high-order non-compound
 pages
Message-Id: <20260104100230.09abd1beaca2123d174022b2@linux-foundation.org>
In-Reply-To: <20260104134348.3544298-1-ryan.roberts@arm.com>
References: <20260104134348.3544298-1-ryan.roberts@arm.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: F003320011
X-Stat-Signature: wkxtnmogta1e96tppbi5q53juxaquai7
X-Rspam-User: 
X-HE-Tag: 1767549752-104843
X-HE-Meta: U2FsdGVkX1+EVGl0VJGVeOOdZq9l96yV+9cQ/ag8SJWj2cYRRo5OfBFjjIAOFVRSJkAMcPaQ09W2sJyvcvD7twzMZfcRNZ7y3DFW1GmrmjKPju7V6WYCAmmIA4R3cjBz8XNnwvZkabmDdgDFQasgQ/QE8GLBbwZaMepweAfJfCfoq2WiKR2MR+qNN2obYLox/CH5b+S/rt7v953QGibHvHbH26Ec0rhnW/Ci41tKuzHZQXPwuoUXvQ443DipluOlmzyvHjHpiPABt8f8fIUXQVP4PySTNMOem6hOlHuhrUTviCbMSYpEpchulLPdWo6cz9NgDttIkFUwpuWAdGp6S3lEqqE0t98lmCu9AI71jg81+csXBdZ3gmKPAOAfwC8lK+aLvqU3zi9ov4SvhDUwnTCkJ3t8y8LhFZbttDys3TtAQ7TaCjvgkmBPipKnW0Vkp0LvehoslBXhoVBnpycd0qu4l7NyUQRlViqMxZniJlmAuYmjwhA1uVTKr+QtPmmlwaRPCx7g7xkVYkIptW7zeXqlzo7ZnrvokoutAj/7fLhxwIzzQEnhrpkFjXV3zWFpU0cu8aobzy1xqeOsVbFpsXT53UaHhbuGZPnHYN79cnBxjeXsaQfEkTzaFGwMMz4xq0AdV1VBrjA2vogWqdo7LV5BEpJMQ8Knv4y5p9any0laX/oEXsmcJ5w0mrs5VaEZ2dIj0ah9p735PQ+U9J223h5mGgON1uoILtHJaicojJLB9D2F6i5OSXO60YO5O9vY021X9HqY2vK1gJtbbbSS57rgOOepyuHEheGlSVk4pBGUVfaWddJWOq92MhgI3zOYcnKYYR+jPluhbVNDfBcSlXmGd+eVThgDw6JoLmmjzJzp/K3B61QXZ6+fbqT5265gMHjXHmPa5fD8bmkz7BxjZhofpx/Rd3l9fzUZNwcqh39+RR8OV9lICKd6zyKjxqT59uE4m1ey6Un/6KP+Xlv
 Zw3feKzP
 X+yiRfU9PkvxaDtNE3RvedBJ1NJyR8Kajiaf/ombbfjRfQ4ydeUgqt3iCLm3isD/8gYAS1arOYZCnBe47L14s59xA1XWm+LHqITuYlVZ2Er6nUI/hiyMpLWxH9xZRonJhQtjPpgWEWggEYXvky1B6YuHjvf1C3sbUUXJ9SwA5Ka6Urgo3tLH8IENqIhbTNS8etLRsLDXr1mwoN8gX6ymH+GQJkx29TbeqhCCx2RmYozC4UqkSz0XStb0mESVK52FrxX2vmJwKluFNVi/Vk8kRDZD1umnLsiU94A2QtmgkDIsomG55iVbSkB0fCiAwBjB+0laMgYs6hBqPc/g=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun,  4 Jan 2026 13:43:47 +0000 Ryan Roberts <ryan.roberts@arm.com> wrote:

> kmsan_free_page() is called by the page allocator's free_pages_prepare()
> during page freeing. It's job is to poison all the memory covered by the
> page. It can be called with an order-0 page, a compound high-order page
> or a non-compound high-order page. But page_size() only works for
> order-0 and compound pages. For a non-compound high-order page it will
> incorrectly return PAGE_SIZE.
> 
> The implication is that the tail pages of a high-order non-compound page
> do not get poisoned at free, so any invalid access while they are free
> could go unnoticed. It looks like the pages will be poisoned again at
> allocaiton time, so that would bookend the window.
> 
> Fix this by using the order parameter to calculate the size.
> 
> Fixes: b073d7f8aee4 ("mm: kmsan: maintain KMSAN metadata for page operations")
> Cc: stable@vger.kernel.org
> Signed-off-by: Ryan Roberts <ryan.roberts@arm.com>
> ---
> 
> Hi,
> 
> I noticed this during code review, so perhaps I've just misunderstood the intent
> of the code.
>
> I don't have the means to compile and run on x86 with KMSAN enabled though, so
> punting this out hoping someone might be able to validate/test. I guess there is
> a small chance this could lead to KMSAN finding some new issues?

We'll see, I'll park this in mm-new to get it a little testing, see if
anything is shaken out.  If all looks good and if the KMSAN maintainers
are OK with it I'll later move the patch into mm-hotfixes for more
expedited upstreaming.



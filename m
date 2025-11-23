Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 46735CFA46B
	for <linux-mm@archiver.kernel.org>; Sun, 23 Nov 2025 15:00:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 82AF16B00A5; Sun, 23 Nov 2025 10:00:40 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7DB736B00A6; Sun, 23 Nov 2025 10:00:40 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6F0E76B00A7; Sun, 23 Nov 2025 10:00:40 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 5BC2D6B00A5
	for <linux-mm@kvack.org>; Sun, 23 Nov 2025 10:00:40 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 020221409E8
	for <linux-mm@kvack.org>; Sun, 23 Nov 2025 15:00:39 +0000 (UTC)
X-FDA: 84142183440.09.B8ACA4E
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf13.hostedemail.com (Postfix) with ESMTP id E1B9220023
	for <linux-mm@kvack.org>; Sun, 23 Nov 2025 15:00:35 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=nXR2QW3s;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=none (imf13.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763910038; a=rsa-sha256;
	cv=none;
	b=sP42akTPPZEt+RWA+nUOWga7td0Yr0I5e4NFpOPMiKyfY8H2IFj4O5qr7SA2QPOHmI7sCn
	WOzF1SlxP5nvHQrk7n8gWnQvKrwrFlmzwoCGpd5DFwPS3ETxR/fXcE2oPLoBjs14Pyanvk
	Njg1OaEpEaZUKEVQ8Ka+ia66uiWFM5k=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=nXR2QW3s;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=none (imf13.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763910038;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vPzOgo4wSLye7hvf6YZUBRjo/5vEsuGzogDqs/fKbqI=;
	b=Nks6Jzqp6yXdRv90SNFTu4hI/NtrKXIRjtz2DwMnaeTrDK4ltw1FEpgpiONeH4POckzytX
	lGILcmwCtc09H/ErBXDe+vadvBhPtZwMv/uhtla027KC/s+gGNLx4nTaweuyvOL/9aQ3I2
	HK/YXVsZQIqWy5BRPpGL5KWVwEvNO00=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=vPzOgo4wSLye7hvf6YZUBRjo/5vEsuGzogDqs/fKbqI=; b=nXR2QW3sDHw+B2LZ8F8viG138u
	0L8ihS3bQBKbQOxJ3ryPGk7sKYNEQNvWa+F9g44RaQa1OnPPQM2ahtmAfnjF/sGxZu6l9eYU5OVou
	k9bfETdHu0fmudYKb0DwT8sfK51WqjoQoE5tfDgDRjat/uDdIKyefd4mhrDw/aKUWn8Kp9ei0g+zQ
	Jkr+whQxrInGOUbzXn2tjr64rdbCnUNwI73IgA25z2Z1MY1rHDW5+o1NBMEFJ3tXQlQbdRvBuylsq
	tsfH0BRzvt/fKxN7cXR7TOV6MdveU9lFiMI52Ti4YcV6QPNBas6/ZajbC3jq9R7zCE8UJKZhEX/LV
	tv6fUWTQ==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vNBZn-00000005hD1-2tpo;
	Sun, 23 Nov 2025 15:00:31 +0000
Date: Sun, 23 Nov 2025 15:00:31 +0000
From: Matthew Wilcox <willy@infradead.org>
To: Mateusz Guzik <mjguzik@gmail.com>
Cc: oleg@redhat.com, brauner@kernel.org, linux-kernel@vger.kernel.org,
	akpm@linux-foundation.org, linux-mm@kvack.org
Subject: Re: [PATCH 0/3] further damage-control lack of clone scalability
Message-ID: <aSMhj2Q6BTMNSsA4@casper.infradead.org>
References: <20251123063054.3502938-1-mjguzik@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251123063054.3502938-1-mjguzik@gmail.com>
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: E1B9220023
X-Stat-Signature: iw76onnh7bfwwnys8dq7qxz5usyx9r5f
X-HE-Tag: 1763910035-829264
X-HE-Meta: U2FsdGVkX18xqKE+/3h8cZmKcjsMIVBmpAZdCRrUIZaN98aIdvr8EPLy5m0OOWovoZBpZe6E1wkTr4/KH0GC95YKIPY0++8hTym41vX5EYQYGOACprsB9AYXSqf7R1DFnqnBG+D4XkTJDMywG1ij1ocfWe3IFwKLop5jK40UyMzxUleFjCjXavd4lfp65+1Smza1uUTd3XvRaRsks8cxD68t06YezDjDiWiv281xI9mc1sGuOw6zL02NPEosmFlBt4/wFib9LCxmaVxvOJAKyeIzB1PRewTD60UFRspOXSmO7fm2OXi2SYpJb9OYbAwo/e5C5LVlz87JyOUV6QasqlKGRmmEw/rhfxPD7M5E3pS2nvI+Ehqeg2MkdF7P+ev3se5OUYGEUT7LzKuQFNIgL0Rs3XDc5GI29nBhfzA2ErjNSyVWZQ0nDcaWEnHnAhQzmYyhIAZ9uhdU525Vc+hbZevSigvnZH4iD6H2zIeSDNxlK+uDeSNhgqaup4Okv/qGdbpLTe0MAmPhUhPWABQH7NqtwqpukS9GLnkIwY7IWqhIA+ikMw+LraVXVkdvz51n/Cv05nEblzf1yrdZV2xCUnHO4SlBt2O5Q77+DNgtLLNJF6Jth2+4GDg5Fjf28sOH842aX+kW6yPmLtGQoPQEWKtY+9kng1AdpVEPUK0pc4yvZcDDqzbkKimx5pklsrFTHX2tAARdDh75zqKZTgvfum7YE99y9y9nhGKPl6A++Iq9BtzbRa7YAksjN756kyjRdZELJwbOVWvUVJWbivWNWC+z8gMefF0PjvgfW+ZENfj6XRaxEoQrPk61oXQhGElLU3206p6sJ9LqiZQ9cTgc/6j2EH8FWvuQpKNZXEzV6CtOKIHIAfPG/aHJKfqO8cRmxBbcYim0rUdOrkQs1PFnF3Ud1RVK9N6015nmeMTBKetSWvRj4oQZH1qZ8udKSdGjfgrVy8EpqEWGkrF3dJq
 4gKjE909
 P5vR7roLmvC937CDPefym5pNLoA43xUmW6RJekdCQwYHKIAy9K6lT93GeQaiWo8TsACcoB0RctM3Br6b+uKkH0GqtQPdu7ZJDFnx7VVHN9AIynD3BmMph7FH3B8S6EHcx/F3Vke46aiRMeXNhm0a6X11CFBGocxxYS2kaYH1hf7z/ChlJD6sVFQjayLuO2UbH/jOeJM1r2MFx2dbzycIY+zST1qQ0UAZJmvR0wpTpAnG6YP2w/yh1HPQhkg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Nov 23, 2025 at 07:30:51AM +0100, Mateusz Guzik wrote:
> When spawning and killing threads in separate processes in parallel the
> primary bottleneck on the stock kernel is pidmap_lock, largely because
> of a back-to-back acquire in the common case.
> 
> Benchmark code at the end.
> 
> With this patchset alloc_pid() only takes the lock once and consequently
> alleviates the problem. While scalability improves, the lock remains the
> primary bottleneck by a large margin.
> 
> I believe idr is a poor choice for the task at hand to begin with, but
> sorting out that out beyond the scope of this patchset. At the same time
> any replacement would be best evaluated against a state where the
> above relock problem is fixed.

Good news!  The IDR is deprecated.  Bad news!  I'm not 100% sure that
the XArray is quite appropriate for this usecase.  I am opposed to
introducing more IDR APIs.  Have you looked at converting to the XArray?
Or do you have a better data structure in mind than the XArray?



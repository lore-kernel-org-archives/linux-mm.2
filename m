Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 364DDCA0EE6
	for <linux-mm@archiver.kernel.org>; Tue, 19 Aug 2025 22:49:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C81CC6B0098; Tue, 19 Aug 2025 18:49:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C320E6B0099; Tue, 19 Aug 2025 18:49:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B479C6B009A; Tue, 19 Aug 2025 18:49:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id A06436B0098
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 18:49:17 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 25350B70ED
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 22:49:17 +0000 (UTC)
X-FDA: 83794999554.16.0ADFE4A
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf21.hostedemail.com (Postfix) with ESMTP id 8091D1C0004
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 22:49:15 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=fX0VJvHp;
	dmarc=none;
	spf=pass (imf21.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755643755; a=rsa-sha256;
	cv=none;
	b=G1BtJT/aFRK3kLF1Br202SHdExNH5qVtoUetHJThuo2oML2U5NTH15GJQlo75wNPHPjQ7O
	wGoNokoLALcJGN4xTRkT8BL430J8LieowxMgQtSH0v8ixfJkri0KhLPwePLdpxt1V9yCfq
	aMBZLml+UdKJm3PfILLcbu0fyvFDhFU=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=fX0VJvHp;
	dmarc=none;
	spf=pass (imf21.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755643755;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TawZes0ZleCKFMu5qumdIUeVbC/7GSzCYgIOYITpUns=;
	b=V3pti8c/jTQLeJ8mE5KjrS7a95acbTv6DY1o16sFb7PEsRi85kzw0tA/Sob7ydYP1abFOh
	48iMIfIu+ERdZIfglFsjNEo/y/5aSysI46KobYuEjtUetdYUibGozFPrEhm8gJRMkW6SBC
	slwjdReie240UM35UwqclRRuZ2Czt3Y=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id B7984613EF;
	Tue, 19 Aug 2025 22:49:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E865C4CEF1;
	Tue, 19 Aug 2025 22:49:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1755643753;
	bh=xoFiK4rxFUIRRw1ywG9Sjg1y2W8RvmUgV7KXFN1o+3s=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=fX0VJvHpX3zu2ROg1lqiKzEizuel6NvNX6/Wtmm0ZKaCqMVDJp1D7BCvZAQTN+rn7
	 aXayhYqu8BNYqwF+FQePFye/I3lOe5f1HVyTbqWPGRozBFYJ/oZ1Z5dsX9wyyEcmCp
	 yd9JcwJu0EHuwRMDyLMGsWvp3HNsAmNAMVDdiZCU=
Date: Tue, 19 Aug 2025 15:49:12 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: Gu Bowen <gubowen5@huawei.com>, Greg Kroah-Hartman
 <gregkh@linuxfoundation.org>, stable@vger.kernel.org, linux-mm@kvack.org,
 Waiman Long <llong@redhat.com>, Breno Leitao <leitao@debian.org>, John
 Ogness <john.ogness@linutronix.de>, Lu Jialin <lujialin4@huawei.com>
Subject: Re: [PATCH v4] mm: Fix possible deadlock in kmemleak
Message-Id: <20250819154912.f6599afb4d7f1c2d5a39890e@linux-foundation.org>
In-Reply-To: <aKSYq17EUrXRGFPO@arm.com>
References: <20250818090945.1003644-1-gubowen5@huawei.com>
	<aKSYq17EUrXRGFPO@arm.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-Rspamd-Queue-Id: 8091D1C0004
X-Stat-Signature: t8r96hrbc6m9yk86ggdryqbbgzo6qjej
X-HE-Tag: 1755643755-980744
X-HE-Meta: U2FsdGVkX18tJfI2dZxlW2Zsjp8hgjr1aERDG5b+lUAF6nvHoVnlJixWIDEuu+RfpZDC2w7XFq1eMDsd3LPb/la04gpBESU4ihLp4BVyq23+SLicVc0ugSln4fXvVD7w1yecOy27ZNZI/hrFmpWppYqQ6GEy1x6qQL+LFFpx9VKj/C4PRICnJX6OjK/vR6obTVcDxXu+o4h8a/fc3HxBum6GEAafCI2wnXkpqr9HL8gRKlcUviCOYZ+YEZ+vE91xZSA5jI10AwskiDrAoMtcPXYdedyOq0Fw3MAqYJbM1xJDifQH2ih+KGgyuHTiDqwKY3Q95qw5CShbldrbwAKKH8+2xT7lRRuSm+fimN6GKp/YMCeBPibAfkx1F4/Cn+f95VhcYxU4Ez8Xey1GHfrbNU9fGFFGQbBaCbikDi+TwBtufWo6wA2vksBR1G6ExWLfQK6745OmMwzagDVmhuxrsbTF2XDBGV4GhnmSoN0isYVLy9woYD/za2xTyWefkkrje2o9ZXGXTk5b0kiWBBjcL+VJ8bdvjBah3JZKZafhAJPNIr9XacTsWabfwre/bZf3Uni2dSQm1w1SBRVFKW+vTJKd4X7NXspC7Y+0akjBb2FNhkdmGZg0RcIGsnrlzDEaepWYArNE+b9vvxyXNMUvglyXsq/OAYu474s69KsqJLMrnRXEOGPyTgB/agVZWwdnXljNA2JAo9OoIV8iTZk7luNd4QdenSZHCllhZ0XyAeql2ZvdUNVS8200XTueFLZivDe2Yrv/jrCKets4qNhF9Z2BJUHsygzMN/+UkxUaCWSAc+houhdw7j3zSj8WF7glXr+a9pHI6DjXXuYHPwaGriz+QRCKP70HcFb/GApSJWIUEENfGiCUbDFfHOKUQuTEerNMz4eh1J/3qTA/u/SasKAqOWZk+gPUYOcsSabwWywVErBNj1/ftMXA7maWygioacRw9QmJh/cUMjCBBJQ
 PW7m03Xs
 BRIqBAvfOeP6r/Xnq+QuByF8C9GNgLVqdG9qNk0zcv3cIfpTIVZt+cnPQloRVt9E4KJ35RZvfhEuma9NQkRJRSTbeV6jvZaGCJqggo1MrhOi/e2YX8nDPBUZhz/jKKl4Aapm05XrdIu8Lvz9sza2qQ1AprvHtPcmKo1GnPg4whOWf1/tG5p+t2AiBhZhmC5WjwyZwkvU89ozaRCwOg21vgurgcdCYebypWXxMR+8zellxrlcCz3zp6g1xUu3xFgVwXluxTo+egN9WXVZAtRmK0d5BusO/168HvtJT4orxD9KsP93ANt3NClmU/mlUBc06yHrjp704yVPXEOQ=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 19 Aug 2025 16:30:51 +0100 Catalin Marinas <catalin.marinas@arm.com> wrote:

> > 
> > Signed-off-by: Gu Bowen <gubowen5@huawei.com>
> > ---
> 
> I suggest you add the 5.10 mention here if you want, text after "---" is
> normally stripped (well, not sure with Andrew's scripts).

Yes, I strip it.  Although there's often useful stuff down there so
I'll paste that into the changelog.

> Otherwise the patch looks fine.
> 
> Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>

Thanks, I'll queue it for testing and add a note that a v5 is expected.


Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 95C5BD4662F
	for <linux-mm@archiver.kernel.org>; Thu, 15 Jan 2026 22:12:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D700D6B00C0; Thu, 15 Jan 2026 17:12:26 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D1D0E6B00C2; Thu, 15 Jan 2026 17:12:26 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C53886B00CA; Thu, 15 Jan 2026 17:12:26 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B118D6B00C0
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 17:12:26 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 5ADFB13B0E0
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 22:12:26 +0000 (UTC)
X-FDA: 84335597892.22.191F7E7
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf02.hostedemail.com (Postfix) with ESMTP id A881E8000D
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 22:12:24 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=tM8jRUvM;
	spf=pass (imf02.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768515144;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PrqHyq6/wAz4pUXOmH0fKmUNwb91b+ZgE9cJJH2FG4w=;
	b=Z+UJvsy6U9QisRD4HXTkUFXl222YKSf/7ZLGG+4YtSFhPmgu0fjM2BLESD08hCT1zd81dA
	8rr/liayXJ42Qe3csDzbvOZT+eqGlWGho3Xmhu6QcYhbVsQ/ylR96yYt6jN5izbFfO5xbl
	DKmFwolBhPefPodXgWDbPV51kQBzu0Y=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=tM8jRUvM;
	spf=pass (imf02.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768515144; a=rsa-sha256;
	cv=none;
	b=hgERPcEebFX9BC/SwjmN1HpzshmrwzxpJarxERrCJzufu19fIxROLWwl0gBP5JT7kc2JBo
	lc7Meuu5Abrn3y6lAalituOpf7IGZIlCz94Q3aYsE1u7JBnRNIlFJnWptL4zdphlyIRrh5
	kQFH9Tl7tLyaSzrsS9mxEgT4Vyze3YM=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 111B660130;
	Thu, 15 Jan 2026 22:12:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 743FCC116D0;
	Thu, 15 Jan 2026 22:12:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1768515143;
	bh=J0t6D4B/Y+jbdnXbnnu2rhN2MrsP0r0M3IJQfqxlIPc=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=tM8jRUvMT0fDMN7a95Ev1UXEVETEdSUtgwoRST4l1NJT++jWy2baAKLd1Nwl1H/s8
	 qQ48p1Ppduszbf1GM1YXxQI63Yq0EK0WezWpEhWTrxbOtbyY9G2CxkQPkIb/T8s1d/
	 /TvvgsBbD6/ZL86gtfhOY+2fRuNHRZaTjtrWNNdM=
Date: Thu, 15 Jan 2026 14:12:22 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Suren Baghdasaryan <surenb@google.com>
Cc: ranxiaokai627@163.com, kent.overstreet@linux.dev, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, ran.xiaokai@zte.com.cn
Subject: Re: [PATCH v2] alloc_tag: fix rw permission issue when handling
 boot parameter
Message-Id: <20260115141222.2fd0f636c1f480a664d583a4@linux-foundation.org>
In-Reply-To: <CAJuCfpEFZNwmpwfUqM45StJKPZG3s+qZpv8Vy2ohF6StsL4LGg@mail.gmail.com>
References: <20260115031536.164254-1-ranxiaokai627@163.com>
	<20260114192336.9d98f0330bfd6c8638762dd0@linux-foundation.org>
	<CAJuCfpEFZNwmpwfUqM45StJKPZG3s+qZpv8Vy2ohF6StsL4LGg@mail.gmail.com>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Stat-Signature: 1zoahqonsadrxmg86yh9mo366mcu3fwj
X-Rspamd-Queue-Id: A881E8000D
X-Rspamd-Server: rspam04
X-HE-Tag: 1768515144-27559
X-HE-Meta: U2FsdGVkX1848v3K3O78NFC6RNKx+qg7vEtCLSYK8en73J3wsTq+FMQVkX5WG1Ede70qtqEhuzmfpvpWG6ZTwq/nkIL1m3xpF51Wy1EyB5Hj7k7G8stwuc0ZoKtRZvoAwb4ct9yweu3gKrPWnr/JkcOMmeACqabrbC/rTlNbkNiLfoUJDlIfRkvwRZqXc5Fca9yiKsYEQAx5DuGeL1ECd5a8DVghAhLYYGHc6lCrKja3LLPAG8vTPEsWGVVKjgb7dNfr4n34fzMyV/Zj5gQZBX3M4waAE2PotDRPs8YQFCoOZv9D7E+qKrvXnp6sfCr4xJAqkAtzVDHY/hLwnsxA7D1BekGrfJg3Q3TPPYWytC8wsTYiaANDEKe3vbzKH0m0Dr7HZgT3nrikUF9+iQ1iCpmI6Y9/yT+M7OZ/l5SCd3fYm0xMom9zZMpmJJUwHlbhiyoPmaEz8HHchvcjnkaU9YQVujD/FMyfi6jkRUVr/sqgK7wggOr0r1b+oJUeFtgYt+cScejWaXg3aIErdkfXAqqZKBokgypFtI7SI+b11jQAYhuapZBvUTbiulHBpPDQKcGpKRGPZAhfu63UmS0zHoJSaGkAbzUcfVea72VYrYgVVI/a9rVVChxQs3Q9famgIjS6LnqWKi/1fzQNVXOWRKuABPLbsJX/iasdHpPhESsptMUd64dY/8dAGfr81wTUTG+zVamZkN3JFwJN6naChfRipDiJd3IFL+2My5uqkoTGaorYR1Fu/FqSIYmjSCVT2w9Av6/QsS+Or0EG3PNPm8X9mPxKe/RshVfMzOi506bXrPaYRSFvB9lLWeKHXPca4yLdgGngBPEynxSbWsngc9wRLX+9faLmuhu+AaIi8zmJlomSMczCP4IIehlsnLyx8q2kk6Ta08vZMYuYaxXMch3A9xsbOedr7WcTUqu7DAga6ZWrTT6nXPLiwB1YCUc3R0JXpQBYsbtUmgeT/06
 TQgFsa5+
 JJob/bxEpkwoCPPHKLiKiKBqfEt+UfPWZ+tKP9Isawi4kaDHYtzDbJkXVhVoRpKGfx8uh9uFrDzXBzzrEowMeJaIQwxiCJhSoTdyz+Og2lrYGf/EXFz2H5SIgHCg+BlaP0NzJCTgMUhwFNKDzTA11a2Tvs73Lx2WhLq6f0aXAmJwVZyUAwbqv2OCly8NrJG+IOvm7rIkn34myRUHfHZysR86XXSUbSk2KV9hQohpp09zuu+KPtQaaeYguMxevN5ji1WEC2zzVztmuuarT48dahU4Rdq15IgB0V4DKM3ElaeuSxVX/B60ZWi/Llg3KsuMpL49OrslkAMqxHqHNTQg1mto1tzPfhbq+qUxMSgXgnXF5UAl9aKpu7UcaRxxW4yhEiSHbsrQ87/qcrYRYlyZe8YuyGg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 14 Jan 2026 20:58:52 -0800 Suren Baghdasaryan <surenb@google.com> wrote:

> > > Suggested-by: Suren Baghdasaryan <surenb@google.com>
> > > Acked-by: Suren Baghdasaryan <surenb@google.com>
> > > Signed-off-by: Ran Xiaokai <ran.xiaokai@zte.com.cn>
> >
> > Should we backport it?
> 
> I'm not sure a single boot time warning produced only in debug mode
> warrants backporting. Do you think we should do it anyway?

Not if you don't ;)  Just checking...


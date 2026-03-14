Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 950D110706F2
	for <linux-mm@archiver.kernel.org>; Sat, 14 Mar 2026 18:18:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 769636B0088; Sat, 14 Mar 2026 14:18:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7173C6B0089; Sat, 14 Mar 2026 14:18:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 623056B008A; Sat, 14 Mar 2026 14:18:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 4E64D6B0088
	for <linux-mm@kvack.org>; Sat, 14 Mar 2026 14:18:02 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id D805413B6AE
	for <linux-mm@kvack.org>; Sat, 14 Mar 2026 18:18:01 +0000 (UTC)
X-FDA: 84545477562.25.BF19BED
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf14.hostedemail.com (Postfix) with ESMTP id 3640B10000D
	for <linux-mm@kvack.org>; Sat, 14 Mar 2026 18:18:00 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=REWDu3KA;
	dmarc=none;
	spf=pass (imf14.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773512280;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rVbsVmCNr0B9U26xEORyGZv4Jm65bacKIV24KYqb1Zc=;
	b=s2iiwz1Eg8tG3OIVrxhFeSVGxWDygPBPjovI/I+Walvoj/LAlGcI3S6kjlNiRcj6BGHscE
	8gIyl192NL0RSrHNL89Cr/iyHw8GXK4yXoUlOzu+HofAti2itvGZa63BpXcDDiRIbJgFUj
	0+3N+AJprwQOni9gCJimAVGGLEJSZyg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773512280; a=rsa-sha256;
	cv=none;
	b=HXDKROIE1FtdjBljwA6pAdYaKOc5V6nhX14a9dZiriKC+xxX1BpVruRDVFm4+KO1J0FaRA
	nO6FLcLPsF9w/rYaNTOW+1ph074oKDB8rvCmpOd7URq3kUklkhgYBYPkueP0oYwsmEp4d1
	jUvI4aqXwOW19+bnwT9g8pbpwc4fW/E=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=REWDu3KA;
	dmarc=none;
	spf=pass (imf14.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 4EEC260008;
	Sat, 14 Mar 2026 18:17:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A263BC116C6;
	Sat, 14 Mar 2026 18:17:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1773512278;
	bh=5lyc4nYBYKJUb0KYCmeiT0EMMXqOAiiUHayvp7zQMJ4=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=REWDu3KAP6d0lLPALgItFItoZzlGs4vQ3BHFEgSJ8jdkBe704scT4OcGb3Q/A/mOM
	 vD8uJha6tAaW6bdGd3XDR2mDp8WY1NCrgtgSgcFliDiIZ5nx9MNNVeL2X6T3tR7F5t
	 WkCSOi0RIxuYUxUJvGfeQ2KjrOXFpbdPUwsHLR/o=
Date: Sat, 14 Mar 2026 11:17:57 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Kit Dallege <xaum.io@gmail.com>
Cc: Jonathan Corbet <corbet@lwn.net>, david@kernel.org, linux-mm@kvack.org,
 linux-doc@vger.kernel.org, Mel Gorman <mgorman@techsingularity.net>
Subject: Re: [PATCH] Docs/mm: document Shared Memory Filesystem
Message-Id: <20260314111757.2a17c3acce8c3a1eb68ed209@linux-foundation.org>
In-Reply-To: <CAAZVx98Sz1MknCcMpQXxeGpUjXBDyz+0KyRuUiCXsM+3qzqpeA@mail.gmail.com>
References: <20260314152538.100593-1-xaum.io@gmail.com>
	<87ms0ajtvy.fsf@trenco.lwn.net>
	<CAAZVx98Sz1MknCcMpQXxeGpUjXBDyz+0KyRuUiCXsM+3qzqpeA@mail.gmail.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 3640B10000D
X-Stat-Signature: a7ns7gpbcsam8gk68hebb4hwyj1pmuxw
X-Rspam-User: 
X-HE-Tag: 1773512280-739362
X-HE-Meta: U2FsdGVkX18mmIb/IjOSaCq0NNX0VMQAALgHcWW1+TX7xjSwSJa3Os4dUCW6eH713iDOMWbxFJx1uJHuYWHmUrCYNv11Dwp0TAQbLBSzy/+lAI1UlFpIkLRnQWVm6+G1gJPM4LTheY0STPNfhcYv8K+MD2j6UjxO75n6xh0afQF8B8IUzbVAbw824UUxuLwvNxanjpP1zpaV5wRHJseEeWcJbABeF6JwE0afba84Exxjj4nE4SyywakOcpam8ippOWK5rwxEzEWGTG2AQktahq4QBjyo+VZ5OLdiDaGJeG3Am1tWvqunwvg8GrRxiU/t7PpaNntkovdzJofeim59UtLA+9GiLeNfwjkaD3hbeXIU0fLNnGWe9aiXui5BYJFuTgo60FshKuCT6gqzIfoA7Nu5YJJoeq+qLUZPw6otnTsCYMI4K7WZG7fpMvNkzY+x/tx0DHF5RBijlJ6DJBEiKebdlh6wfnptMkHyR7oJ41y2H1ZYAsLroDqwIclYjrTxDNuLNqtfyvYaZWq7we0CLwlgpnYSLQHaH5MpuO8HDao7H81J/LPt6U+Bxne8njMO4SVQMxj6kZt5HCv5HRQrlFLxslonROxLtEQqt24OhgI25TmO1z2CzqqGPOE26Mlq3iTrRny9gy645MRlfDSDHltUMu1wVG6m3RbY7Rg5rQe9e8zFlwwCuWWqTUjdMgD1NWPR0b6xqInQ5971d6Jpqd2jwUj6mgBa5DqXm814N/QQ9M5Vwhu/M2QlqY+7Qb+gK+IWyVAJg5gHNAdl9cEZsoWEfGaA0ymR3z3H+Q03CQEwzNzmqyHGwAovN8OZoWECmSKw7zT6hbFU12ffLhRM2Yg5Wz3dbP7deFUHJQjGAye+WQnA6TYetD8axYj0RKgTSIE70k6l5Wu7UALIAF3VXRsAf5BFkwIiEU6i8YymdpCSAlZakzfuUxSJPENwE3xgoMuwZUaA5o2xMOFxtj+
 +0TfAPw+
 WxsM7g2oOLi+s57AR13d/4lhMt2qPpxtAGXmL2wUyVDUBGbc76eZuHFXVo/x1e05nddHX+Pzitnz78ewxGgYooU5rfeCk2I69XdABX7HqQRDSwLYiYlcDF+HgAt/pfbGOD22d0TGlX1Wh2my42xVNq0tatfoHTIQvGkah9zG4zaXBMgbYguj/apEwzuoGBEdqstX5O/FNvm0WLTJOy3RvdGvoG2rG8td33aoEcQDOiuv9+37NBoFLDRGzf6tJs48oPFxTfrvEsNq2MMRldp8NQ7gxuwInjqbv8W1aT2qbEpVlu68djS6xpmAVfr/6mJRFLJRXco/vdRy4idW1E5ve/XI7pg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, 14 Mar 2026 17:02:47 +0100 Kit Dallege <xaum.io@gmail.com> wrote:

> Hi Jon,
> 
> The material was written with AI assistance (Claude) and then verified
> against the source code in mm/shmem.c. I read through the implementation,
> the existing comments, and Mel Gorman's book outline to identify what
> should be covered, then used AI to help draft the prose, which I reviewed
> and edited.

OK, so you're saying that you created the content and used an LLM to
assist in finishing it off?

> I'm happy to rework anything that's inaccurate or doesn't meet the bar.
> Should I add an Assisted-by tag to the commit?

Yes, Assisted-by: is appropriate and useful here.

From a quick scan, this material appears to be helpful and I think it
would be good for us to get this into the tree in some fashion.  Which
will involve asking the relevant MM developers to review each change.

> Mel Gorman's book outline

Well, Mel may have an opinion on this - hopefully you discussed this
with him beforehand.



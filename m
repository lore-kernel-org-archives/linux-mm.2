Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EBD10CD8C8C
	for <linux-mm@archiver.kernel.org>; Sun,  7 Jun 2026 11:58:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 416356B008A; Sun,  7 Jun 2026 07:58:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 39F6E6B008C; Sun,  7 Jun 2026 07:58:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 28E296B0092; Sun,  7 Jun 2026 07:58:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 194696B008A
	for <linux-mm@kvack.org>; Sun,  7 Jun 2026 07:58:23 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id A9669C268A
	for <linux-mm@kvack.org>; Sun,  7 Jun 2026 11:58:22 +0000 (UTC)
X-FDA: 84852968844.24.1CA2A12
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf12.hostedemail.com (Postfix) with ESMTP id 0D58B4000A
	for <linux-mm@kvack.org>; Sun,  7 Jun 2026 11:58:20 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ItsDMWph;
	spf=pass (imf12.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780833501;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=H2pnv615PWqSZrpd2NRH79qwtsELWXhl5rrCYlTNZXo=;
	b=O2G1JhmXrL1+ye1lsAXHTYgEe3HUe8LgltDlzYwKRSio6JCbRqT+jItrW7j8f+X3t3zc/4
	pj9ym+qY1lTDKa/skwblnUvKfU0534HtJdMI+2/koWFNk9jvaivxTG5M6TihZdBR5GQHx/
	xc+ZY0nYQ7lgwhcu6NNtRpaqv0m38t0=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780833501;
	b=ojE/65juLjmTcCwati6cRQHE5cmLo7yNddAQUl04yzE/C6no8TZL3Hz2S30wiX+zje+Jg7
	5q/saF8IfSCKUDd50vHxB9YJA7tQlanjIkFRyeIMR4xP02N7LGFFwp3otVmVIB+Qh1oGJS
	3v9UOOqUYz2C8MdupR8L+/AKtpYXev0=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ItsDMWph;
	spf=pass (imf12.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 98183601E0;
	Sun,  7 Jun 2026 11:58:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0487A1F00898;
	Sun,  7 Jun 2026 11:58:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780833500;
	bh=H2pnv615PWqSZrpd2NRH79qwtsELWXhl5rrCYlTNZXo=;
	h=Subject:From:To:Cc:In-Reply-To:References:Date;
	b=ItsDMWphVvFP4D8ih+9sFpqdbEllQp8JuNzqgQys3nbl3JRqSpd7m82izly/lFRXA
	 23SWdwR6HYtp7hRPXyHAUcOCpSsHOvTegPo0+c0Zoc/8HpZOVaNaXYTu391jg8RAcT
	 lNuiTww4Je5vPyjUu6tupBsWXuI6+1WkwqXMcZ1uZzFer2zFa65oT4pvSbc/lPzohm
	 FThaHBR5t10QV7mIFRzbIdC1X3dBWriV7aLfUCAclVbONkt1fiCgXNJgD7wc7Oz4wc
	 9U8zF9tNMbgUZWnuUB23hxabixRlJ3jbIren5pQKdSCeKQcujQXRc3S61MiWKHXSmM
	 xJSxwo9xyAzYw==
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [RFC v1 1/9] kho: split out radix tree tracker into
 kho_radix.c
From: Mike Rapoport <rppt@kernel.org>
To: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: linux-kselftest@vger.kernel.org, rppt@kernel.org, shuah@kernel.org, 
 akpm@linux-foundation.org, linux-mm@kvack.org, skhan@linuxfoundation.org, 
 linux-doc@vger.kernel.org, jasonmiu@google.com, 
 linux-kernel@vger.kernel.org, corbet@lwn.net, ran.xiaokai@zte.com.cn, 
 kexec@lists.infradead.org, pratyush@kernel.org, graf@amazon.com
In-Reply-To: <20260605033235.717351-2-pasha.tatashin@soleen.com>
References: <20260605033235.717351-1-pasha.tatashin@soleen.com>
 <20260605033235.717351-2-pasha.tatashin@soleen.com>
Date: Sun, 07 Jun 2026 14:58:08 +0300
Message-Id: <178083348873.1648214.11020626647820932506.b4-review@b4>
X-Mailer: b4 0.15.2
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 0D58B4000A
X-Stat-Signature: ujuuzhqsb4gjjigd17zsw8tyxfz4sjzx
X-HE-Tag: 1780833500-589809
X-HE-Meta: U2FsdGVkX1/32FitIo/232KAp84sqLqmeQO5O+KarcG0eW8gVI5H+17uMZoAf2wn/oO4siafYnKRnVcrd3Sk+oOsca/4zhYFrnUlMg00I6/rWLU40ikCtz2LpTAy+K5jkAd9R2KeYiXm2efJHBuBmPEkbk4C2UD8WdSBY0/z4RhAI8/+AUbkEYhNz+0cNcKSrNq7vsqBhLgid8pzIIoPiDPhMqEmlDlzV6sZf+/2wsK8snB7R/R4OipKxhsG8fPzK+aUMKThAP9bD4T5ZG87YL9wXcq6Wqj2CxvbkoLhlSHw3VsjataqhJK+4GdMBQneazRM7LdjnHMH6ZyKPPaj4Wm9VTfRidYgtCzRYLxD30i8h2ldVbAFzaktFhRasCi5Pz0R7IEdXui1D+cAJatuZZD9u5XgfTZGWRbXgWsfzQfr8TNtTmJKM+K0TaTbaZnPJVKaTQ90jFImPCb2LQ9dMObs1/pfCXACq6kLGwYivtLhMUdX/9aDVkrtAxE1txsFWiQ99EiAZkY3DuuEgxrSo7pFtrfZzCLXwtV135OE+MHfSoao/dwZ2BvcdjiDmAsSOdL/CRcA7jzvCAb1sx471MnMOMSefpbu5Of903P8zK502QuNPa5fJL5+ZvYglMklWcZ6jlfoyXejZfA2/4mhFjEsHhEvM0xCnHmY0XXqCN2/Rl5/aDXUvmnsH5P1uPZYlnSLU3hfm/2o/51smhDbtCnJ9lpeNSCIv9pVxxH/xt/aPZPBhFJeK06533qb/IEpGTG/qYibsuiyRBT8YXGWcnrx21Gc6QNz9zit2owce1Nqhr/wchaoCpWOiJ4fN2S/7BcYqy2Es8iMEj8ndJyy/3doeceDij9Z/9iXgj1pY03TqoQiu3NAhMJh/cWS9Q5jiV91VO6IHyF08UhKzqBr2ld24q9yekmxs4y8MuzvIGoYNSmUN672gZaCJaS1a7CtJHU7MmQ1Oc2DaZi+cgq
 iXRbklj/
 EXdRctiq2YOwM1Xf372RuSToRyTgRFyC10cf6pn7K+yb4TbDd0ZjDdFhX19Vtge+g+FtqnL9woy+9aU/R32Z9TBxEr2aK45cV+E3ieQKjGXzHMNtEqTJZud26VR4xcqAFb3YNOE1MahBA67d2KIf7LxGOxbnuS77pReaY/WmB3HRh7hCCqXPMQKiJgD03Cd69xkjqSQtMYz8ygGaxruxqsRfBJt9sgEHn03Vfa8tHXyXuzAmQ2vnme1Z2v7mNEzgImULbXbGP7F+Sqf+AfxwjWcrZlTNNTyUjQ/6A0PPCGjGsE/odvaRcQ7WjGW3ZHUNIQbO0
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 05 Jun 2026 03:32:27 +0000, Pasha Tatashin <pasha.tatashin@soleen.com> wrote:
> Move the radix tree tracker implementation from the core KHO code

It's radix tree data structure implementation, kho memory tracker is it's
user. Please rephrase to keep the semantics clear.

>
>
> diff --git a/kernel/liveupdate/Makefile b/kernel/liveupdate/Makefile
> index eec9d3ae07eb..a3ee8a5c27a2 100644
> --- a/kernel/liveupdate/Makefile
> +++ b/kernel/liveupdate/Makefile
> @@ -7,7 +7,11 @@ luo-y :=								\
>  		luo_flb.o						\
>  		luo_session.o
>  
> -obj-$(CONFIG_KEXEC_HANDOVER)		+= kexec_handover.o
> +kho-y :=								\
> +		kexec_handover.o					\

I don't see much value in moving kexec_handover.o to a separate line,
btw, the same is true for luo_core.o, but it's not important enough to
change.

-- 
Sincerely yours,
Mike.



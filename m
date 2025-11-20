Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 98B79CFA441
	for <linux-mm@archiver.kernel.org>; Thu, 20 Nov 2025 21:16:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D03B76B0029; Thu, 20 Nov 2025 16:16:25 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CDB4C6B002A; Thu, 20 Nov 2025 16:16:25 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C184D6B002B; Thu, 20 Nov 2025 16:16:25 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id AEAEA6B0029
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 16:16:25 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 11A2758876
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 21:16:25 +0000 (UTC)
X-FDA: 84132243930.20.145FFB1
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf02.hostedemail.com (Postfix) with ESMTP id 387898000B
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 21:16:23 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=EmIiJtRE;
	spf=pass (imf02.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763673383;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ICS/x9VGE0DFmPQtmpd1JFc714yQO38J1m3bxRMq4XU=;
	b=nZZPnT7zik+4G0gYMe5RS8Rsjn3ig/sIUcYiugLVvekA5FoK6P6++X04J5cER1d4YK00YO
	yRDoh47x3q3x5q+XW//ywyBzXGtw2abSVgtdX4D9PV66mkIUXU8L3hvzGPSes0YVekkUrI
	zC4GXnnljlmuKkLg3yKeCYq+dRmkI1Q=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763673383; a=rsa-sha256;
	cv=none;
	b=KuGbnVdQW3UlTHf3NG3o1YGVqKpIXkAdxPmtFWcFqWK2N6yKdouEQIySe1sTrOJlJAQVUI
	Pz4SUecsZEphTLU7KsOquKDGQ4V2XNgScR6uYyATj0tPU6+O7sVypOCBM3jMmp06PXyf1S
	siECg/cLpHlLEzIzZdCyjTcvTMKtBIo=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=EmIiJtRE;
	spf=pass (imf02.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id E161F43C87;
	Thu, 20 Nov 2025 21:16:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58C74C4CEF1;
	Thu, 20 Nov 2025 21:16:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1763673381;
	bh=piAWPbO17CVRXy+xVHrHY8gG5b4yazR0bLuALBdvoYE=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=EmIiJtREsL5zxTFbP/TUH1T0IPy8AJCiVtfSr23iUrbvVzdh3xSgKr4vZPc4PgZjM
	 o+5eXKA4+hifuAWOdKNclI1jp3h7l1vbM9fGYF77i7mMkt9QaLcPrHIOLWXLagLSi/
	 2ybZIAlvYV1l6nv8sVGX+XdaPVKaGYIHY5ad+Ll0=
Date: Thu, 20 Nov 2025 13:16:21 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Wei Yang <richard.weiyang@gmail.com>
Cc: Zi Yan <ziy@nvidia.com>, david@kernel.org, lorenzo.stoakes@oracle.com,
 baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com, npache@redhat.com,
 ryan.roberts@arm.com, dev.jain@arm.com, baohua@kernel.org,
 lance.yang@linux.dev, linux-mm@kvack.org
Subject: Re: [Patch v3 2/2] mm/huge_memory: merge uniform_split_supported()
 and non_uniform_split_supported()
Message-Id: <20251120131621.486cbccc8a713ddbd30dcfe6@linux-foundation.org>
In-Reply-To: <20251119005248.ddlbhokgjdmlkhkr@master>
References: <20251106034155.21398-1-richard.weiyang@gmail.com>
	<20251106034155.21398-3-richard.weiyang@gmail.com>
	<20251117012239.lqm33uu4vl4y5zqc@master>
	<337CD281-F5B3-47FE-82C3-ECB236450F60@nvidia.com>
	<20251118033339.7rukw7vvjvlbj5jb@master>
	<51358ABE-B0BE-48E1-95E3-C778D1F44622@nvidia.com>
	<20251118103220.bd90932096d4e36f754de21b@linux-foundation.org>
	<2AD36673-231C-41B9-905D-35BAB4CF63D2@nvidia.com>
	<20251118140658.9078de6aab719b2308996387@linux-foundation.org>
	<20251119005248.ddlbhokgjdmlkhkr@master>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Rspam-User: 
X-Rspamd-Queue-Id: 387898000B
X-Stat-Signature: thhujzoynnwcx3n4xx97seaty8cn4pjg
X-HE-Tag: 1763673383-739766
X-HE-Meta: U2FsdGVkX18IW4wV4OUwuJnDwyzZb1h5dKwRr4xzMCbUHRrj9ZwItcqV8waNLvLBeOKQ7v7HCe1EcrXq42+BPXdnv17ZVZcFiPAHIPZE8CBC9i6z1tl5gQYDZH1op/0cK9H0PDeg8PLxCmcGNJhEtFcWRB6I7evjX2ygfzpqPHLmgSY7BqpHMEWgOMCnkers1lbMey9t6t8wImoh1o7wT43XEYFw9SZArgMgoXeDM96T2+BLgHUDZose5S+P0kXtJyKOWcP6CdI8weEQxsKH+2LMC605wQ+GsAzxklOM3Kht3IQPEvSqt8+RsAaH3NNqHNEWHI2pLKjuGX8DqqZVTLN3gtsbXAAEkdanpF5PGXAwWPViVvifIFgmpSyFYfNfX9VKTP/oWYfyrOY0lfBec1fcSadd8a9m+b5U9lj2QkY+h91qa6jNLunb4hAJCnFqxgX0A/p5OtzIQnGDiinaUjh3lBiqQSIqysQZPBuMn+5A0FYz9EgV9zGBvuyeFGttluUvxMEc8KmusBSP8BCpxMQgxCVttpjk6F/WSe7hoOnVFOkYqlTi31/jeKmYWD7gLiMuGHg2a3umomlK5QIGOtBNv8YtO92j1uYhT5ATtICMbDWQbvY3Lxe9mr6+l5WnrDl+g0VzLWlINc/gUAPrPPA7kO8mJN07ve6x/Gs9Yhld2fGifZNhBfvRoYdzeLGvdJs32cGjTXTUmK8jTaS4rVhCcrox1Aef+Et8mtH6GzJzv4lheHv6d314w3Ynz18BBo5+M7a4P72iC2oW5MB32R695JiM2ZoGgtbBUd3fQoQpruvWa7LwS9BakY9jpfFidPRWV0dflXGe8uv7RYT65Qn880GGbZGGKGnvz3QUWY+INoEXj9LFyO34ZPhb8mjP+65NBj0V423F0w+UXyEr5dWUha6pawK6T93CclIS6ALcfJFnB8nmq69xdzxguXnNo8CXZ+S4ZIS3wIC4Xgc
 qQX2hdMR
 P+ZQ54OAIZAI8idiImmc+tTZb15q3ojVfcY1JQqyuXUqLf+eIawvdVqp/p7Jz/1snNB/bYpiBBLENK3m/2D6XM+Z7JP3riaCeYoGGFgS0Q9gu/gkD4RDBBBREtfrmy/+EB+/yoZmUbePka/F+2MWkQNvNqhUIIX+1Bs0zwUk3Y/ZZuRv6cF4P3bccSmq9VsQnb0eZVg938WeoVKrbnoeKyOeIerh+oGXKjrjPvm3F1+QOdQvEwVFH8gi0mR3JCFGCckbqD4TSXqiw4b4MpITF5NJhNTHHdujTUCUOAFVZKSd7bLIPD8VqFD5lLJtWtgIxgeVswALtJFBjqA8kuXV9rGjOAo2k6ZojBMushApXNbZ+6QnS4piWe27NSI1Xejb+DDAfKp+QtkJkQp/xMF9Z0Uq/KwO9nJ14/EjiSMFQRtjvgy9HkYP9glJAxcC5UBm/+4gK
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 19 Nov 2025 00:52:48 +0000 Wei Yang <richard.weiyang@gmail.com> wrote:

> >> Hi Andrew,
> >> 
> >> This patch does not fix the NULL dereferencing issue yet. Wei is going to
> >> 1. send a patch to fix the bug on top of mm-stable,
> >> 2. resend this patchset on top of the fix in 1.
> >> 
> >> This might be easier for back porting the fix. Maybe you can drop this series
> >> for now.
> >> 
> >> Wei, do you agree?
> >
> >Dropping this series messes up later patches.  I could of course redo
> >things but would prefer a fixed up version of this patchset asap, please.
> 
> Ok, i will prepare a fixed on top of this.

Did this happen?

I remain unclear on the status of this small series.  Issues which I
have flagged are:

https://lkml.kernel.org/r/20251118021047.uyldr7aay6fb5evt@master
https://lkml.kernel.org/r/136E8B1C-3352-412C-8038-627F5CC8A112@nvidia.com
https://lkml.kernel.org/r/20251117012239.lqm33uu4vl4y5zqc@master
https://lkml.kernel.org/r/337CD281-F5B3-47FE-82C3-ECB236450F60@nvidia.com

and a couple of comments from yourself indicating that updates are
required.

Have all these things now been addressed?


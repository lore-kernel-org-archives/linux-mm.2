Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0A446EF99DC
	for <linux-mm@archiver.kernel.org>; Fri, 13 Feb 2026 20:09:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1F9E56B0005; Fri, 13 Feb 2026 15:09:10 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 17D986B0088; Fri, 13 Feb 2026 15:09:10 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0AF796B008A; Fri, 13 Feb 2026 15:09:10 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id EF7DE6B0005
	for <linux-mm@kvack.org>; Fri, 13 Feb 2026 15:09:09 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 7C3C61A0630
	for <linux-mm@kvack.org>; Fri, 13 Feb 2026 20:09:09 +0000 (UTC)
X-FDA: 84440522418.07.CDBFB54
Received: from mail-qk1-f177.google.com (mail-qk1-f177.google.com [209.85.222.177])
	by imf21.hostedemail.com (Postfix) with ESMTP id 563091C0013
	for <linux-mm@kvack.org>; Fri, 13 Feb 2026 20:09:07 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=cmU+b4bS;
	spf=pass (imf21.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.222.177 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771013347;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7qPVnjkUUN7g5ZDl/2W4jZj/HTnTNtx2ZZEtCyQsavo=;
	b=smpf5Ig64+FRvJgeGN1f/3AJmoWjUAdpvqt2qAH//b3vSux7BJy4a8aN8/DLDANh3ipWUZ
	NOiJqDzItvVbqyKRf4tT2YJ3UKZTWF9xG09QNPZ1zXJh0beNZchZaEBXsmwtXk2Tbp02xi
	1Ngmbijcj45Up+esGFlJETlRIYejPI4=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=cmU+b4bS;
	spf=pass (imf21.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.222.177 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771013347; a=rsa-sha256;
	cv=none;
	b=Wag/F4tkGJ+eD+XaKsDPRJ5u57BUqjq+iPP8zjTDgK103sRBYFrk73BrKd4ntZrugB54oP
	AF0Z75YfJv7KkdrRb45hUxdolDsI/JXoSu7LguWvi+TkpW4z5Pe1nCqopxFpyQSkGUCRLN
	OMDvd3cYTu3m9tV8Vb1NxZgtN7lm9DA=
Received: by mail-qk1-f177.google.com with SMTP id af79cd13be357-8cb40149037so128554485a.2
        for <linux-mm@kvack.org>; Fri, 13 Feb 2026 12:09:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg.org; s=google; t=1771013346; x=1771618146; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=7qPVnjkUUN7g5ZDl/2W4jZj/HTnTNtx2ZZEtCyQsavo=;
        b=cmU+b4bSlweBWzOefF58LIgmMFgQv53ArWeXUDZslNFahoUPCS0KWM9mKZqm9HvdQ1
         gUesFZ6/nBq1kr7MSWcftAjs0cPFW9WT9qqNIRVhv9lMDNj1Lu29GIbYEhe4XTN+hsdc
         J8RDNmQrpVAXH8LzqwhRTR5wmH4yi4zaPq794vkCypfGG21Zlc9mkWnuacAzOp3Q96Ae
         fmYyOuJPPLyA+n8rqCtTSApB2bqvpBZjARWWjBCn+iaMS+hkspjoaVh7LuNminQW3meh
         Tt6fzaGwjucOVc4BcNKLLMJqeggCaYrUL8OK5EpMNSaHxdLoRMdtwFkAa/+jRzAy5lfS
         4dfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771013346; x=1771618146;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=7qPVnjkUUN7g5ZDl/2W4jZj/HTnTNtx2ZZEtCyQsavo=;
        b=LbOjNCriuWOazT4GrCFRFQXJs1UTmW4eJ2ADhV5F1g4ZtfToJnGpGhdRHttuuaqjYD
         dZnHVQYi5RbJgWr19onTGT7oCL3SN92BkM9iG1mritMiwAWnu5tofTmh6sFVqqOGz8Ho
         1pGUl7rpKL9QPV0lswTyr0tIzr4EWJQNuz/W+i6GhVSRdr7K0YOPe66zKnJ78AYGrUWc
         x6J6kRc4NQvnM1ZkAtwDGmGHnRTw/0TXTHhhfMgkZslAXwRAtQhrqYEfQnll23JILfwL
         DsCaDBY/UDImI+Egd0XBLJaJO6Z64ktQrde2Bgx/6W0tLQg4KlYonmL96dUN4Gdm5RvJ
         PwGg==
X-Forwarded-Encrypted: i=1; AJvYcCVi4BTum90u+9RIcx/5xXKoAT2rnyFnCBXPx/SpXvSmiRR0Spo8Ryi3kIOPMpt4NCUqxaM1FP5lLA==@kvack.org
X-Gm-Message-State: AOJu0Yzxh1wem5bU5MIo+ynlZT95P9A3ON9hte+jiEIKXgl41G+6sZiY
	Gzd/2oU5IfOzjXCS/74oYPPaRG9f6jr694c2cHw2MKF5kQrueoMD/IAezte25X0fJsg=
X-Gm-Gg: AZuq6aJzHjlHh72u02YfCKfl6uUD4M/yq2c1vJA3QGuFHuj9RnbweVPgVu3b0DaLIcC
	41oRfvsJDYFvcMdTG7jp7ks5IRKwCTEdtQ9jJQArEZusmuvzx4TEOG9dlGX0+ywKIdv3M3UpxuT
	e4jEJQS8umZTgCmRLXljAwHCmHo+miLzjwa/qeVUpoOs72J76G5qITC+ySIibUaWk+Chx4/SW8h
	VRFI3Xpl8H5CTV8e7dm8R0iBoKRHiB12XJbA8KxrzNtV6LrsDFKncozcRgbh8Bb8b/CX9czmyyY
	AU90wLMQAsxUeMaof/vLouahCxm2sJX0O8IiSkSBtitVN2+3hEcF6lAxLPhXxZJlUJrSMcCkFgy
	cvDkw8Ca2Sj6w21iyjkKDvWSCLufKbRd1xrBOx1xwCm/eTx+SXd/PDglu992+zoySuIvB17MYGG
	WIXqoVjPfhw4pIjw4BqJCkqw==
X-Received: by 2002:a05:620a:1a13:b0:8cb:3bca:bb3a with SMTP id af79cd13be357-8cb4249f104mr378592785a.67.1771013346200;
        Fri, 13 Feb 2026 12:09:06 -0800 (PST)
Received: from localhost ([2603:7000:c00:3a00:365a:60ff:fe62:ff29])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8cb2b1c7ef7sm723625085a.28.2026.02.13.12.09.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Feb 2026 12:09:05 -0800 (PST)
Date: Fri, 13 Feb 2026 15:08:57 -0500
From: Johannes Weiner <hannes@cmpxchg.org>
To: Kairui Song <ryncsn@gmail.com>
Cc: cgroups@vger.kernel.org, linux-mm@kvack.org,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org, Kairui Song <kasong@tencent.com>
Subject: Re: [PATCH] memcg: consolidate private id refcount get/put helpers
Message-ID: <aY-E2Rj2gBrBHJsT@cmpxchg.org>
References: <20260213-memcg-privid-v1-1-d8cb7afcf831@tencent.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260213-memcg-privid-v1-1-d8cb7afcf831@tencent.com>
X-Stat-Signature: dddnru9jmxabpdzj5uffx13g53zrac9u
X-Rspamd-Queue-Id: 563091C0013
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1771013347-123674
X-HE-Meta: U2FsdGVkX19gs0zxrlH+CpVqwc+VfY9sJeSwvfc/OQS0H+5rI8xV952yUUahLBTi9MwDaCb1JjQ987md2y/yeSWDUmz+Thp9xYBEtkUb9oZ1D8BgbqIdjohdtiEb8GyXhBStO92Rlwqd9Yrc5CZGIjwYGaoF9ooymtRMMUYZDSAV6KCCw5ac7V+scbEnj3cNWVv2p3B5KB/jstksWYFppdFlrH7nJAyHwfaS540PgUjNBcBNxYZuD+r86gaBUCVrGoMtMRl0uzLyUbh75SRbEfuMWd/z/hX8F7Ki4oB8zuAaJ46NCIDPA1mn7en5BE3FSBIq/Nyjt1SOaaxOBZw7794y1EqAUcZ8/BYWc0HcZsHfQUSouNqF0AlPQvHf4VuvosjNJ9arEcaUSrNvb+5OZ5MPC06U0nv0StYGegxc+3Ojllc5HqlcBdOwq0aiHPVs8YmcTgILZWtguv5oIeibCFkgsxSvpGrl7/XK7AsqyNo2v8sENocblrOLAz9nAihQ1Um/DYN1k4fglp5TkHiNgrQz9iDW041W7geWStRD8hxsQBhyzANeuO0WUW/eMK4BiJnw/zs8avhBNnXPQbjr58bjHjYZV2jzJUkviW+Jd3I4+04OmdWQmqWn3e1UenKU0uLmGzYgYEMMYy3vZrMRuik3cKJftTYTW4nWvsQx1op3UjKRCOx+BIh7/RkuvL9QicubBkz/17l6QhEU6VYrWX37dYJzP4Md+vkSc3XwnJ/ledv/DrgXLIvH1NIPhsHCIgBMIDG9gLqUXnqKviP1YDmuEHqu9pPHamDT8x6tifbtCTgb5rzMlDagMrCEaYXwpL2u1hg3Eyfrk7GWTyCS8PPb3VYAG7PchSTy0jLSMy73GRsm8zIZOdYNQqI2eUNRVCdoJgSy8lwxoZanaAkY7Hol2mEDeRdzSxCwok/z8pA5taYn83s5esH/B9NHWPV9KveZt0ZJSXcGZqAxXYy
 XyZmY5yt
 T24YisS1iElrQFcyDpnxGJeu3VWa6O189dQqU2zLJOHGTR6QDhWeAVXLi3qJbVHUZfQe9qJu9s+KC8A2lJS8pH7lD93jnAn6RG+HcfXiLGsy+/0rJfrXqq4iKZYOpHMcIpkISc+RdllLAYN29ij/YV6SE6cY6fzfoiIo2RVXNo/Z9R0v32F6rc0tINcKBTY9wkAjpljZbE3lCE7WQX97VyUPhYw6KNi82KsarnaArFNrPq8roiWQFreSRtpk3frySGq7euyhm2ZcukRpXRhrVfTaqtnHwk9yGoDonZ5lz1oDpNci2CrE3Pyi6MYo4E7DEiWa2ak5QzkiuJtcZeS/o3s5xgBhk7pLPeLFz+Cw+J+R7RivxP0qCDVsDJqVo8KaGxyvGgP8m6Qs79K0/WTIAuQO+xm9Rv3LG/hlAsN542X7nwcNmyakOPpex8lo7td2ixbZb84vUHitcyn0=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Feb 13, 2026 at 06:03:32PM +0800, Kairui Song wrote:
> From: Kairui Song <kasong@tencent.com>
> 
> We currently have two different sets of helpers for getting or putting
> the private IDs' refcount for order 0 and large folios. This is
> redundant. Just use one and always acquire the refcount of the swapout
> folio size unless it's zero, and put the refcount using the folio size
> if the charge failed, since the folio size can't change. Then there is
> no need to update the refcount for tail pages.
> 
> Same for freeing, then only one pair of get/put helper is needed now.
> 
> The performance might be slightly better, too: both "inc unless zero"
> and "add unless zero" use the same cmpxchg implementation. For large
> folios, we saved an atomic operation. And for both order 0 and large
> folios, we saved a branch.
> 
> Signed-off-by: Kairui Song <kasong@tencent.com>

Nice improvement!

Acked-by: Johannes Weiner <hannes@cmpxchg.org>


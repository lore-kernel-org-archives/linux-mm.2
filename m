Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 57D57E63F3F
	for <linux-mm@archiver.kernel.org>; Mon, 16 Feb 2026 09:50:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6CB8F6B0005; Mon, 16 Feb 2026 04:50:32 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6796B6B0088; Mon, 16 Feb 2026 04:50:32 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 55B266B0089; Mon, 16 Feb 2026 04:50:32 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 414E56B0005
	for <linux-mm@kvack.org>; Mon, 16 Feb 2026 04:50:32 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 4B6025CBEF
	for <linux-mm@kvack.org>; Mon, 16 Feb 2026 09:50:31 +0000 (UTC)
X-FDA: 84449849862.06.2A24E56
Received: from mail-pj1-f47.google.com (mail-pj1-f47.google.com [209.85.216.47])
	by imf09.hostedemail.com (Postfix) with ESMTP id 50DFF140008
	for <linux-mm@kvack.org>; Mon, 16 Feb 2026 09:50:29 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=ilW72n94;
	spf=pass (imf09.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.216.47 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771235429;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7gnmOo3Cj78yHvfE5N1nX8eAvU7JXJVsvwozPhpqUe8=;
	b=a1mi0BDd8GajgIH0TI4Kl9/9R1uaPGMvgK7tMEGEh0rLkQdlxmoMTRX/2GyGxXDnXPxOVD
	4CFhb+rNvKgjXV4pOjav1lqNu7wpGm+bnH5mg+j7tCNpNFr9zoi/4sJXgHpc5wWOaeGY+M
	h5+1e8uPPtOC4Y7IvRYdtmymtuQ/cXs=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=ilW72n94;
	spf=pass (imf09.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.216.47 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771235429; a=rsa-sha256;
	cv=none;
	b=k5PDAasC8tcyKRh2ndAPIjqvqT2zew/kScfcSZUm8MF95oKFYjgYoTCGQqUqDbCH+Kucyc
	QSEOjRJ54iQrPm8LKTIuKE5yxlheXv3twkMyByoqp8LxgJ0+d1+xtNx0JqlbgB7ENmzpnZ
	Lhne7Fnrx0TQE3s/OGi0uPVknv1oB9k=
Received: by mail-pj1-f47.google.com with SMTP id 98e67ed59e1d1-354c16d83b2so1395197a91.3
        for <linux-mm@kvack.org>; Mon, 16 Feb 2026 01:50:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1771235428; x=1771840228; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=7gnmOo3Cj78yHvfE5N1nX8eAvU7JXJVsvwozPhpqUe8=;
        b=ilW72n946dpjUjt2pOOeXVFHXY7OwELWHsMxE6bqj4XeuNH5k3TN+BhxWMoYXsOxsa
         agnMTIc5ca8eC+uYOXFkRmjmWChugtnpEeWfFFK0Y79kHfCr2tVOgzpK6qwku9HToWTi
         lKIWcBOE1gjyQgwe+8HThUtdrR3HTKfGWguJ8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771235428; x=1771840228;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=7gnmOo3Cj78yHvfE5N1nX8eAvU7JXJVsvwozPhpqUe8=;
        b=AoXXJJrK4gy/PwlYvzdCY2/We5YqHjEEDTlulSzgsZffTtcqk1lakfr0qsoJ8bgQO4
         PvqnCqgU7oklHBbEdnxOozwXC7c4B6RbuokqWtosNrtxFRZ/MNcWu2/8x4AuZIxfMKPu
         bVGGDrMm050kl5NhBBzczgRFwjuN5nCgtEACcPd/Y5EzoAgIYvwdsamJPBRrxDjn9w7I
         6yeQ/4t8vF+Z+0QKDaZcSCKAwFKooXnkSvCAS2sX/dMpVEzBXVEsZDGmjKF7m/+Wcu+u
         bf+8KMVeMvHQ4IGmu6K5CN/2nJsj1xWCvFaRk+6CgbpCgJSCZPnqDwumqVHJg5txJNr/
         ErAg==
X-Forwarded-Encrypted: i=1; AJvYcCVLTkPMk2Nncy4ykc/mqahHWXIZ53jMTO6EPzCRlEbdo9Uwgxxuc74/CautSXuI0Rr0E8oea/Ko2g==@kvack.org
X-Gm-Message-State: AOJu0YzTpbZyHEuzkLkxNcTDYMMWGgb4jNN54+nkLR0FUI3rPoXHJUx/
	M3NuJxONDIFCdoNGGtNbaymO3hjnDFd9DFg3R1OQzghI82jKLbYc07aYTvtOq6YpYYtAt0w4FDo
	VhOo=
X-Gm-Gg: AZuq6aJWOUwja0Yb0VuVMgpOnI5B81X5CG7HcrqgFioCryEKkOTs+GFKJuGNSPpE+Mf
	6KHdh7TIuLW9/eZlUJ/5RugGG3s6fUrLN/+gZ1uc3+pX8dajApZI0VbMveAt4qoXLAiZ4PecnUA
	bksIrSgWyXGCa9pQ9q7u5SDGYokyQrRM6BwSXacw0FfB07rjs3b61RU90rMfe+Ngtz/VOp7zu0G
	xhRH8RzkJmX0hzhAuuIjcugVdtgeNdHc0S2VNWy12Ikb/LVcR3UmpZoTe5/7HkHLJj25JCyO54x
	tAo2nNJy+SGzMbIXfi2O/HU5lZnkNSNX+IxEl/yWyk2QQ60aXaTyBaRbf7silWpYIvoYQS7iuJ9
	pj+ezvuyZnRVQ+OShNQo7zN+/uO83V8oOJN0Xnw9Yti5nnIFs2a7bTAhlpzic+v/tkIA4CcZJaE
	S0IUX21JSmLZypJ+59xIX21tteW41imGjrXiLAsovfjIlaNB/im7ZVTo6s54f+wSA=
X-Received: by 2002:a17:90b:2e49:b0:352:b674:2592 with SMTP id 98e67ed59e1d1-356aaa761b9mr8883704a91.7.1771235428014;
        Mon, 16 Feb 2026 01:50:28 -0800 (PST)
Received: from google.com ([2a00:79e0:2031:6:16a9:1c52:52a1:18af])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3567eba9451sm14824310a91.10.2026.02.16.01.50.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Feb 2026 01:50:27 -0800 (PST)
Date: Mon, 16 Feb 2026 18:50:18 +0900
From: Sergey Senozhatsky <senozhatsky@chromium.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Lance Yang <lance.yang@linux.dev>, 
	Sergey Senozhatsky <senozhatsky@chromium.org>, Andrew Morton <akpm@linux-foundation.org>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Zi Yan <ziy@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
	Barry Song <baohua@kernel.org>, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCHv2] mm: khugepaged: make scan loops suspend aware
Message-ID: <jfj7y2xpqqnpzvttyd7uotavxk2geabdqbwwsdr3akmcz2cioh@5h7nelhexzyf>
References: <20260211031512.261127-1-senozhatsky@chromium.org>
 <104bc764-5a20-4ac2-95a8-b31f41255766@kernel.org>
 <jftqdosilzfkd4ku6pjuevkvuwmhlqtua62jwsmmgdfcseitb4@gopt2xzqhyrk>
 <3571cf8b-9fb3-41b2-a402-a8537ee2c399@kernel.org>
 <r6m6vdhbqada6i3gugtnj3lytjrkyiretihwebwci423vwslcr@ysrgdqvvno6b>
 <16ce9ce2-8081-482c-a6ea-0932ebd081f1@kernel.org>
 <56345542-544a-48e4-b127-49a850deee9b@linux.dev>
 <5dc7d3a2-a358-481d-9352-d8356d3343c2@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5dc7d3a2-a358-481d-9352-d8356d3343c2@kernel.org>
X-Stat-Signature: 9wnyy9w8jufwq89p76jy643m756fbnnd
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 50DFF140008
X-HE-Tag: 1771235429-29779
X-HE-Meta: U2FsdGVkX1967GYlzUlNF3X/uWzyWgPfFdPxaxjK0aK989JYid4sKeYwK5RDVS0STjnQhBgYoHfkpba7/uRhGyzAO1da2cHAWacVmv6N3Sa3kj+96VOEt88PavPP9IG2QL++sUAx4HHRTQZhGy3lsgWcu2MZfBw+VPJIFItAvwLflWguSLrf/qvv/nFPCs/uGPSrIFQuk0/kwrsaNFxLNl1qwzE0038jbPWQpJ6R9cRYKJnS9CSN/hXUx51gG0SLr/xBXoundFCQrr7HfkKVSVc/+vPetrMJLte9byOyGx0+rf3KFkleJGzNLhaPXKSzQ1tDKe/eFszyIIQ9y/3ra5jh1+ej4cE2VjnQCoiWCEE355jdnbZAv7xqs/gw8mWZa4rINACMew9e/uTpXkRNG8p+Utq4GsQIn1RQDipHAwEuhHzJ+2FoQKSYFIuKbQeDbk+RaJXU4rZ4kjMlk1Mgl1NMapggYpMkBRbSJcV8iiPUFfbcMVtnocXHGoyc9FqYnpgRfPas/qu8+4sCB5yd6R9YEhk7GBD0isuln/ku7bfh0vX6lA90aanJa5hAcZ/ZjvTWLjNF4ROm1oaXv8eEUvG+gvGb1bTfYGK+RxyN50LD9z+EBhPzuuBtJftzpuN0rW7buks7ZyIigX98Hk3atbOTvJgKGUcbAuTKQl++OPT+PzMScy+znzideIHDsYW9z/f8/c7j3elbYOKCbXb3zB4lBSK70NgnUI6WPHu6aTCwBKj00kc9DTxUpSv/D8d3XGeK4xHMxF3e+g24PEnZ+JVpVjkjQMixsb5wGIjKNaoWceCVZIUY4yns3Jf7f8ZlPr1JTegUTqLHQjRARg4ULl6u6eSFADR4FXT2o+offfN+vE7lEsfDKy+1FiavmvNyafw73y/z9rZl2X1A0n+m6Hs1fPHdIkIFIhYa4JBVxbaBVZK44RGkS0W7lNC/x9LuoHkPU0Z2Bo8Nh7nug8b
 N5BQ1ota
 Odcmj1ap3ursrLKjhNas73O/yhzJThyKTP0uqv7QhH/R0h3XIL2kBnbjptW73lrW3nxymA8GpLcX04XQqJG/QFHLqsBi+kvm6VCwYBqhagMoqUrZS+dxLL3o0KCL6IFkY/QU6OsHBwt6S8PiGh4RqDrdKCar5Ef51e5GAJjT7NR8Ik/zo/U6+BW5IpT1Lzboc2VvAgkjWu5pSX2I0oK7cnoPGE1XQ0fz0zfMi+1KlgBRt4WIopowXDfMmWMBlUE/tQoWO11GPc55Vxqu7JzlN+WfqBXxTzzXtbq4cnb2bgDY/hgZky/oJp91kDN3+OfuI2MH1cypxntN4kes4ffkwUYw4dembNK8m3VgYVK80HGCplu0=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On (26/02/16 10:24), David Hildenbrand (Arm) wrote:
> > Maybe we also need check points inside these loops to bail out early?
> 
> I'd only do that if we have evidence that it's actually helpful.
> 
> @Sergey, with which base page size are you running (4k vs. 16k vs 64k)? I
> assume your report is on aarch64, correct?

I had reports from a 2 CPU Intel n50 device, with 4096 PAGE_SIZE.
I'm trying to repro on that device now (by running suspend/resume
in a loop), but not much luck so far.


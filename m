Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AAFD9CCD184
	for <linux-mm@archiver.kernel.org>; Tue, 21 Oct 2025 17:44:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 154288E0013; Tue, 21 Oct 2025 13:44:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 105A18E0002; Tue, 21 Oct 2025 13:44:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 042508E0013; Tue, 21 Oct 2025 13:44:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E64BE8E0002
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 13:44:15 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 8E8618830D
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 17:44:15 +0000 (UTC)
X-FDA: 84022845270.16.F84EBDA
Received: from gentwo.org (gentwo.org [62.72.0.81])
	by imf24.hostedemail.com (Postfix) with ESMTP id E8F3F18000A
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 17:44:13 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=gentwo.org header.s=default header.b=OsAVFdj1;
	dmarc=pass (policy=reject) header.from=gentwo.org;
	spf=pass (imf24.hostedemail.com: domain of cl@gentwo.org designates 62.72.0.81 as permitted sender) smtp.mailfrom=cl@gentwo.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761068654;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=K7a4l8JVBnnCMLYmHwA7OCtZe1J5ujlEJyq1JqWJvBo=;
	b=ZVqfQ+VotoNMPFGbHk8Hjb66YWKl3ZYZ4likuNhDXh+5lzh/PdQD0m8f+ALTi6jm79TbPm
	UiJ9neHm9OSKZTpdXdahyVTbIhnVrhyy7iz/Yr0C0zHmj6e0ZH1hPQRfp252g/tMDpTWhr
	iUI3YrpNsNjdPn0YnOFiOdGHCQM9BTs=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761068654; a=rsa-sha256;
	cv=none;
	b=kf5zjuRlTc4uWBTPKqt9IE54FCJfozOgOYXSGvdfQZKoHSKJrspIg1bT17atcPMyo+Ws/Q
	wsioUv5gkiKQBYksP/pg/btvJ/au2Dl7GfDC5GlhzQJdrTxzgZM7vWlgOqXtgfObRUo6Ll
	rGsvNfbNMTTomEABp5wbNgLCDLa2ftE=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=gentwo.org header.s=default header.b=OsAVFdj1;
	dmarc=pass (policy=reject) header.from=gentwo.org;
	spf=pass (imf24.hostedemail.com: domain of cl@gentwo.org designates 62.72.0.81 as permitted sender) smtp.mailfrom=cl@gentwo.org
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gentwo.org;
	s=default; t=1761068652;
	bh=K7a4l8JVBnnCMLYmHwA7OCtZe1J5ujlEJyq1JqWJvBo=;
	h=Date:From:To:cc:Subject:In-Reply-To:References:From;
	b=OsAVFdj1XnkmCtKV21bPHIYYTMEENYG738Q2lQCRjFy7xneyA030IigcR1yeNsUF5
	 ircnfogyilwyd4P8Jxvwzk+cH+2M19cJlo+om3JiOblX5uV51rum2FYbQzUmJg1k7m
	 PMC3DgUhg6yD9dvyeaOMTaOeNgnxXlyvnh7x8r0U=
Received: by gentwo.org (Postfix, from userid 1003)
	id A7F854028E; Tue, 21 Oct 2025 10:44:12 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
	by gentwo.org (Postfix) with ESMTP id A71804015D;
	Tue, 21 Oct 2025 10:44:12 -0700 (PDT)
Date: Tue, 21 Oct 2025 10:44:12 -0700 (PDT)
From: "Christoph Lameter (Ampere)" <cl@gentwo.org>
To: William Kucharski <william.kucharski@oracle.com>
cc: Vlastimil Babka <vbabka@suse.cz>, 
    Andrew Morton <akpm@linux-foundation.org>, 
    David Rientjes <rientjes@google.com>, 
    Roman Gushchin <roman.gushchin@linux.dev>, 
    Harry Yoo <harry.yoo@oracle.com>, Paul Mundt <lethal@linux-sh.org>, 
    linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm: Remove reference to destructor in comment in
 calculate_sizes()
In-Reply-To: <20251021110004.2209008-1-william.kucharski@oracle.com>
Message-ID: <679a717d-b434-9a2f-1d59-fb17b343bc30@gentwo.org>
References: <20251021110004.2209008-1-william.kucharski@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Rspamd-Server: rspam01
X-Stat-Signature: ix7yh1xn81f816dhg6999n6xbopzbeyy
X-Rspam-User: 
X-Rspamd-Queue-Id: E8F3F18000A
X-HE-Tag: 1761068653-189412
X-HE-Meta: U2FsdGVkX18cwZvhooXTBJ5iuVaPCgibWQD5lWVHkdp9jSsl4aOADe4qlYx6O/AnoeX5uK96TzWYnAGcDwH3JopOl2vTm/kegevmy8JYiM7rxbSCqMrnT6yC6I2vpMnRod+elyzyfwgfI6gH1gMqq1a/zNxz0dko0/5aBPKojmQmPocRhsh1jzX1Ja5Zl7NwT4uatKRgz6RvJK23tKdrC0X3Xu+Thv40A5EMp3H2RwL9uLYD9lcD1Jhc2/W2d6vaeIC0vG82+NuP3OLWd2rv8wDg0RI9a54kefMLasvgXE0xk/L+RDoEWcwfWdpheCCZFKevoMc9cHKt//pJOFN+ZRvdb756XzUPeYRwZDzy33z2fzRO0zHTFVO6kwK9DclMJGhop9md4+qAzaZXheNwEYey+udX/ZiRk3CyAeCzMeK+DdMGLZIqYIcsoyYJ1KXpgjbmzPUGdcA3/gX7rtNF72aRpG4w88pHxRZSlZKiPnMr55hP9EY74wpysJ0hDUIUSTWdRjLruF68YXbcQGZDE+WwJSdQ4yH80Lkw1B00th6fO3sLwF39tA5DZoJ3FK66kRBeZYFkx3y9nJ73CWET2oBHMmnzvgXwBAcVRDpd4QtpWXa3KVVQK/Lnerq//ssV7gOx0Eu5W1g/m1iThBd3+z4KTh5/NdCVnsOrqWv+P+UX0+YxNGXxsagA1T4JoGUGmYf6tGd6+bxpjAHbEaI3eFH6C+oFUzlVfzCIKdfM4UEF8CqWqyKBXyh+iHU/41Sgjpx8fj52/DSEuIUmootXZglJBhwgSqDj7p4Hn+427h7b0RTHxiCveGSAKuQKKFUMjRayodqVuccPGcxIyq4lQgm/MSJnAG1aiQZWljfgPHoGKE+7Kirxac8WqHgga0IU6wE0eB1xgkeWlg1cD+5rmxPoYTs3D0Fr6k+nL4HBr0xFCanFbkvzc6KB1HqhdopGHDtl2ZMRwXYmArFvDif
 6DFdM63K
 NKWvvhI5LZWqyPj5cCLx6scVIzgB9X9fLTOhfFTLgjsdpbIJ+eqxeKCam4snuMLJSzllBZ/4uknDP+gnavEufOnyp/XgSsAiObekRa1GwKZiHAz18NBof1wxSMfP8objkYGs/GNFCP514bDNNAcg1fXsdrMsUDsGYoNVQIAMnZt5zGJY4bnKjwtF4sAPlvZHT5IH7VTPr1ipnmw03vLIK4XB6KNJV5XtMwp4kLO8vP1xgMCLJ3Y6F1k8S8MAmBcg+1NRYCVxvvuJNeDO7GEhvuYXnT78zG5WD3LifmBrReX8LoW96WhhjasC7SYWZUK05JuJQixd1hnSlIZuwHunOjQSVzS48ADWlH0nd
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On Tue, 21 Oct 2025, William Kucharski wrote:

> The commit that removed support for destructors from kmem_cache_alloc()
> never removed the comment regarding destructors in the explanation
> of the possible relocation of the free pointer in calculate_sizes().

Must have missed it about 2 decades ago.

Reviewed-by: Christoph Lameter (Ampere) <cl@gentwo.org>


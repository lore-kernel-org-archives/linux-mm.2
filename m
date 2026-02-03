Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AA1F3E8784C
	for <linux-mm@archiver.kernel.org>; Tue,  3 Feb 2026 17:55:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F09656B00BA; Tue,  3 Feb 2026 12:55:21 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EB72A6B00BB; Tue,  3 Feb 2026 12:55:21 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DE0956B00BC; Tue,  3 Feb 2026 12:55:21 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id C98156B00BA
	for <linux-mm@kvack.org>; Tue,  3 Feb 2026 12:55:21 -0500 (EST)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 7E113140573
	for <linux-mm@kvack.org>; Tue,  3 Feb 2026 17:55:21 +0000 (UTC)
X-FDA: 84403897242.13.5204E1E
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf02.hostedemail.com (Postfix) with ESMTP id 6FBD280006
	for <linux-mm@kvack.org>; Tue,  3 Feb 2026 17:55:19 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf02.hostedemail.com: domain of catalin.marinas@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=catalin.marinas@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770141319;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=j9zHuRPtzPE0oVVKPkbmyD60n9k6NBfdJa/hwaKcDq4=;
	b=iHU05S9XSwZZ5PcsCSqDaW9gVm+dQhTaBlOBTuWXkGFoTCX5pqfPjIRWNjWPUSTClaJuWp
	+sicVlFOc3FjmcsK+RqAXJDZxg9EMQkOIvAp7o/3FIwAPWOeEx/EeA5WEbffZeGKOGJDWy
	/ihQtuH2BO9GCWFg+6+zfURrzOMeuOo=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf02.hostedemail.com: domain of catalin.marinas@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=catalin.marinas@arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770141319; a=rsa-sha256;
	cv=none;
	b=CC4/8bPrDFeGvMHJq2NwNiBkdyxF2uek0pmN4zoZMXxwofYBIpwaEUstBky8OCrwqf5k3e
	psEJN21FPq3gx17JI2qbE4b2JtkPV1clDX9BgOO8O3FhH9DhUgZFPfOjzVvTaTajn8DGNq
	XWlf2b74qkkybxMYLELOZKjJLN8ATP4=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id DB356339;
	Tue,  3 Feb 2026 09:55:11 -0800 (PST)
Received: from arm.com (arrakis.cambridge.arm.com [10.1.197.46])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 5F1BE3F740;
	Tue,  3 Feb 2026 09:55:17 -0800 (PST)
Date: Tue, 3 Feb 2026 17:55:14 +0000
From: Catalin Marinas <catalin.marinas@arm.com>
To: Zhongqiu Han <zhongqiu.han@oss.qualcomm.com>
Cc: akpm@linux-foundation.org, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] mm/kmemleak: Remove unreachable return statement in
 scan_should_stop()
Message-ID: <aYI2grbaboVrhXoj@arm.com>
References: <20260130093729.2045858-1-zhongqiu.han@oss.qualcomm.com>
 <20260130093729.2045858-2-zhongqiu.han@oss.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260130093729.2045858-2-zhongqiu.han@oss.qualcomm.com>
X-Rspamd-Server: rspam11
X-Stat-Signature: 1y4bxkyrfe5ra6kfyt86qjds11agkw1p
X-Rspam-User: 
X-Rspamd-Queue-Id: 6FBD280006
X-HE-Tag: 1770141319-915678
X-HE-Meta: U2FsdGVkX18D8KfzlrSPYYeD3ndVPatQXcV7b/igH9g3wQG42BK3rOLgQpdxgiBRJ+JVpYQzTz4mt3hNG9gaYa79P/MHrcc4szF02FpXo/8gsYqpBY4PAfUqtF1e+RW6b2DH/yqZR6TqNCjIo7bTI42zRrrrn67DslaFX/bFwDXNevH9IW8LRsTUC5fpq9wPKFivTP94dtQMXWdvUF2pWSL75Hv4gPqE5b8Orb+40MkIncYjqy6JISc9S1MdekcpUZciiTkXbzE8hDTLX9ds9jP1cfUSw7HDax9qdJoWX6NiCK9MeqkE9JSuvDPgidse+Xc5u/H4SnPTCK/6VuV9ZQmIwildcrOvkGMfQB4VQL87EG6s6g+lEoDap6+W02WN1HZ12qQo961/xQCT30P9DJd6kff7RWtLBWZrPf/KCWB982lvPRqgf4WX+3WuCpEnKLvrSLcqdVqYuTm5m7zjuYB9Kzjap9dBb8t5L+Wp2LH3IreUk8IKs8QArGyfBwbxNBoHAv8sIGNNF552eOzwWRn/YciplGacnM+5/2US87aLDE4E0MsGJq6hNv/Dpqt3A/tHjMBo6OE/k0E71YbkPcKqQ7Hdv1GAYaZa76rQvAu0wJ2zFcd8g6t8OOkmniV+hUltqsbw4uadLOf2Gi5SwY5mG8TtVaZKC/HCeCcAWs5ACLQDpYcamw/02rkqGJ+bb5Z63X1B+Q+HNiwaR5IU/iilUFCBoTNsw/OPsRGNUjd2emp6OIEGgVM7dHHA/Vz5F/czeqIK3emRqKafXXhS34knADvrgHYSRMz+e4OjlWmqkWv3UgSEJ1Iy3Fo6iLZVD5/Ws/7hmzIrv6lh9r4bkHsLoJr5ysKwfewMevnoXksg+yD7Q7NqYpfgIQkklDIe+dCghscjdcU7tYVEakbQx+ANFSlIvhwkkt7ix6JyQaX8jS3WJ6oYW6hn4BiWk6jHA2JaxG5kjeu8DWCC+bg
 rx/qqYUj
 Howoymige8k2w7fWRslktmskRBaGb6ASbiMF2nIuBDw1dlw8hQXSD9WnYclZ0nByMS364dWAPxIokvreOpavFiORNX45ohA5jYA1E7FmpwR6g4ic5QOAGg61DiKwLoAPX27g+/HJMuBiN0vMqkFlj/7Q1L+YSj9Yq1RsptdN5KUFSR78ITp5sJurFeOgLEiWCCfIhzFGkIvIICzTFNzT7Uf7jCm08WaHX1usOtw0Y8Vwap854NIQYd+xONdt2Gv+JPkxqFQm+oH0LaXA=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jan 30, 2026 at 05:37:28PM +0800, Zhongqiu Han wrote:
> Remove unreachable "return 0;" statement as all execution paths return
> before reaching it.
> 
> No functional change.
> 
> Signed-off-by: Zhongqiu Han <zhongqiu.han@oss.qualcomm.com>
> ---
>  mm/kmemleak.c | 4 +---
>  1 file changed, 1 insertion(+), 3 deletions(-)
> 
> diff --git a/mm/kmemleak.c b/mm/kmemleak.c
> index fe33f2edfe07..fb0022f34393 100644
> --- a/mm/kmemleak.c
> +++ b/mm/kmemleak.c
> @@ -1509,10 +1509,8 @@ static int scan_should_stop(void)
>  	 */
>  	if (current->mm)
>  		return signal_pending(current);
> -	else
> -		return kthread_should_stop();
>  
> -	return 0;
> +	return kthread_should_stop();
>  }

Yeah, not sure how I ended up with this.

Acked-by: Catalin Marinas <catalin.marinas@arm.com>


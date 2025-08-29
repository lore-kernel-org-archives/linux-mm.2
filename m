Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DC580CA0FF9
	for <linux-mm@archiver.kernel.org>; Fri, 29 Aug 2025 23:21:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2C5F36B000D; Fri, 29 Aug 2025 19:21:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 29D9A6B000E; Fri, 29 Aug 2025 19:21:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1DB056B0011; Fri, 29 Aug 2025 19:21:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 0CE5F6B000D
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 19:21:50 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id AF6B81A09B1
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 23:21:49 +0000 (UTC)
X-FDA: 83831369538.30.959FBD7
Received: from out-172.mta1.migadu.com (out-172.mta1.migadu.com [95.215.58.172])
	by imf19.hostedemail.com (Postfix) with ESMTP id ECB921A0008
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 23:21:47 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="O/HeWPoS";
	spf=pass (imf19.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.172 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756509708;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IoK4zllEW6Xms2ZZwinNd7Tz2T0VM/zmYZ08GOudL3Y=;
	b=A5tA4JnAD50N4jrZ6z4gd4bQNYVxY9BJamcxxY/iEDB08A90pkRuEikLPNivbMc/GsxLBA
	zV36TZJetNtm/2CoL8GFQcfUs2zqFGsCZ9a53E10ynByEZfMJGpjtvEwA8P57h02LB0TVw
	aVmGkOy68dr08ZOvw+D7gaaoPpALVGk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756509708; a=rsa-sha256;
	cv=none;
	b=XhLtKAw6r8AsqCDVdQYxTqRb4OFYZ7yxKojzJaA9dyCRTGIBZsNxcaO19cOKMYkz0v4vju
	QdEKqJX1RbakbYr/aAHDVxSMYi5pL64IJcVNTQAWtudV2IyLlw65wEfZEwIAoEpDYdYv5Z
	qi+HWJ1zlavaJR6IZiqef1xXPzTDxTg=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="O/HeWPoS";
	spf=pass (imf19.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.172 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Date: Fri, 29 Aug 2025 16:21:36 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1756509705;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=IoK4zllEW6Xms2ZZwinNd7Tz2T0VM/zmYZ08GOudL3Y=;
	b=O/HeWPoSrX6AKwpdvqdj3JLFnuBqfjf/xGW64fGgD/Z47FkMT2nA/th4VCcqmPeKOIHOIZ
	BOF3jOXr5/ACj3Zol3/kVvoQwcmSU9MPztrrKPwSBhM726pGzXZs/HZ9Fkj99v8f8LIPtF
	6GO4LLXoFIHLeEvaSUR8utcJwPR+d78=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: zhongjinji <zhongjinji@honor.com>
Cc: mhocko@suse.com, rientjes@google.com, akpm@linux-foundation.org, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, tglx@linutronix.de, 
	liam.howlett@oracle.com, lorenzo.stoakes@oracle.com, surenb@google.com, 
	liulu.liu@honor.com, feng.han@honor.com, tianxiaobin@honor.com, fengbaopeng@honor.com
Subject: Re: [PATCH v6 2/2] mm/oom_kill: The OOM reaper traverses the VMA
 maple tree in reverse order
Message-ID: <xhletvae36fzuh6aobsxfk5qr2vyqcixhnto7faqd3fnqubnl5@q5uqhfgiebc3>
References: <20250829065550.29571-1-zhongjinji@honor.com>
 <20250829065550.29571-3-zhongjinji@honor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250829065550.29571-3-zhongjinji@honor.com>
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: ECB921A0008
X-Stat-Signature: jqig6k1h7fgqh8j5xgfqa89zwywfotpj
X-HE-Tag: 1756509707-720312
X-HE-Meta: U2FsdGVkX19wNZPJWtgitnKb1HIxac2nTyPoujVjUBQ5mN0Qy8OCV2rvHLTJrcUSMl392GyqXm2C8Elfo6Qk25SGbm51QI4i2nsL/QkQSrUTwPQAYPrnmoMDbWahWtV5imATa8DY1m0zXOyjC+y2nTwY2FAw8HdU9pLIjobnHd4bi+7j9xuYFCh5u14FURSTTs/rsAB2CxF11Nysc8dHE1HSK1GZwTJjtxIDN4ieVw/3wYEEUgjUpkPXKje2NT+gPfzaM7/keyH4DYzBZibpRegFlMR0HsIUe9qUEhxicV0LGFspbjLw7EHs9A/NE7nSMdA+svCQ8mJQUP9b05nunwEVvNG1VyHOZWXsatnQVerviOoOyHuwCBWEt8ikZT+FavDhMKLC/KAGczZUFsOACrpoUXxs8guZRwmrholv9g9hTrQuXz7mgJ9KdA7X2yTxJfiX6N/4cptYPdHlIU1mxrZJUFmBGnCPWJ8zh41jNI/zlIrvw2EJXlInz1HTe7I1O8cz+A5mz24TZJ+pOuGExlxDqc3gA0hkxMSozoWSzTLNoQoV34ry+BuNAOGzhP84wyMXzCXaKUnHHWNw9iDm6uzrIJkrFzx5MN7kYyimlQhKYl4hKIXBLO2dn6aqdwXa/7q1Wfa7R1TAU2BqGKLJjjFHFF1Mh/ivR4cjOt7oNdsthp8RzCCG1S6XcQY5t/mXL+eNv0oQLCqNN01hjTWdfF4UHjrx444KSL6NFxL8K6uUjS6yC/123MFzZ+CfPJqQZwOsTJgqFVvVamkkp61nmcW0RUy56Mok/st9jGcIXNv7GJObNab3g0XwHEdC6/K5qSRQ8siK7eQJ7OJ/GM2YUniSJYg6PYWM9s4Tbop3dcY6LtxseymmWb5ubLQhr+7zoaCX6030I0O489QbPI2z5KX8FT5A7sA/akjIhSfPm9O1C9dmEINnkf6l3U2QLFD8bdnLbBn4/RtfWXOCiG4
 TkY4kx8H
 0TwVJXLXOHO/mXStgFrA1JqJ3B/B8UjUxPWW6HTn0sPT7SG8gjFtyWyuk+DaaHQ28nVE+yj81/am0W7HslQntb5X4MkbSUtZv44DLTNCZCrPsYqQg+A0OLWi1UUEK6p5Ygd7hJtR/afht5HNzA7YfTcZb+PQA1xYfJY2mn0G2Ijx1GzOzul+3WMnHM8FfqvIa3VD7pLMMI7sajT/vSHW/doqbYOKpovmB55PCKO85ovyrKBAlqm8uxhVnmctEnr8f6qJHtg1H5ytet2wfuQJnT9IELZTz5GS2745YvvegfYSifjAkFwbG46ZVBbTVg0wr954V2S+iavI9NCFSJLPC+Ec+S5m4LdEK5/nJ
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Aug 29, 2025 at 02:55:50PM +0800, zhongjinji wrote:
> When a process is OOM killed without reaper delay, the oom reaper and the
> exit_mmap() thread likely run simultaneously. They traverse the vma's maple
> tree along the same path and may easily unmap the same vma, causing them to
> compete for the pte spinlock.
> 
> When a process exits, exit_mmap() traverses the vma's maple tree from low
> to high addresses. To reduce the chance of unmapping the same vma
> simultaneously, the OOM reaper should traverse the vma's tree from high to
> low address.
> 
> Reported-by: tianxiaobin <tianxiaobin@honor.com>
> Reported-by: fengbaopeng <fengbaopeng@honor.com>
> 
> Signed-off-by: zhongjinji <zhongjinji@honor.com>

Acked-by: Shakeel Butt <shakeel.butt@linux.dev>


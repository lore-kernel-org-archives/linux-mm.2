Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A2301EA4E08
	for <linux-mm@archiver.kernel.org>; Mon,  2 Mar 2026 14:10:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F1E306B0089; Mon,  2 Mar 2026 09:10:13 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EF65B6B008A; Mon,  2 Mar 2026 09:10:13 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E0C0E6B008C; Mon,  2 Mar 2026 09:10:13 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id C8CE86B0089
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 09:10:13 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 9A672B65B4
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 14:10:13 +0000 (UTC)
X-FDA: 84501307506.16.D279AD0
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf15.hostedemail.com (Postfix) with ESMTP id D7D73A001C
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 14:10:11 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=XC26fhYW;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772460612;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jAjD2mFruhLA6S5Uyea3rqvdarrNjuiCTh+l7kuBuUw=;
	b=ZKGSd4NVMNdKvsR0G42APqf4YjQSH39vvqI8kFxPuVqPjh/lqagD9w2azFw2t4mKu381M+
	PbFcXp/ooZw5gLBpMWmRqIruderj9qzcTrf7n/lrhdrVyQhFeQfqAJvgpgZGWofI2TpCnb
	ZCslGi27o8jGiMHdOTsr7gAPL4Z5vBU=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=XC26fhYW;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772460612; a=rsa-sha256;
	cv=none;
	b=31MCIQe1SfF2AftUmbqhq0gC7niJKod5fc7i1bciUQtuSusOEwHODT+ymyNehgjN9mR1Qm
	55a9p+HRZgCUiLgQO7YjtKu98cMtlo45Caz9zX/iIqD41f/KMgrNLasTH5MlaofiFypH4P
	ekdPDCJujBvONvIcn1b8L4DXqXa/bHg=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id DC71F40A17;
	Mon,  2 Mar 2026 14:10:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2039AC2BC87;
	Mon,  2 Mar 2026 14:10:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772460610;
	bh=Iw7aUP2S7mWahuhzCJO/BUcWFftOh4Nm7vHQ0zIqiJY=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=XC26fhYWvpCZWb4IyVpvt4Oen+imcRPCYbXTeuSc1MLlCUVRgZc5v3AQ4m82UcGUX
	 /J8tyC2i62wPJE9f2KQeG9fs5nPTejtD+H/hMq3v7rst6nBeN1ODJCRZRR51tNy7Et
	 JA4yuGwd/7yzIxU3CFW5yUHMty4FxLR94ARGLlXdTSPM/bQlHoL5ZEPokxwStEWYFW
	 V7ebXMDn9zkqFfMb0FW2qZOtiDsDH+uin4ubx7X8NfFN4Y4Gh5IQEQFSpsZ1R6ACE2
	 N/xRfzgEZMD3s/djPCWs+RIbSAfQhxV/2Y4iOcJ+Zk9ZPFy7TgynrP/LmhqHoW7jqO
	 OnzfcZeYpd+3g==
Message-ID: <0f340324-502b-4719-b3e7-c7ccd4378385@kernel.org>
Date: Mon, 2 Mar 2026 15:10:03 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 4/5] mm: rename zone->lock to zone->_lock
Content-Language: en-US
To: Dmitry Ilvokhin <d@ilvokhin.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka
 <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>,
 Wei Xu <weixugc@google.com>, Steven Rostedt <rostedt@goodmis.org>,
 Masami Hiramatsu <mhiramat@kernel.org>,
 Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
 "Rafael J. Wysocki" <rafael@kernel.org>, Pavel Machek <pavel@kernel.org>,
 Len Brown <lenb@kernel.org>, Brendan Jackman <jackmanb@google.com>,
 Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
 Oscar Salvador <osalvador@suse.de>, Qi Zheng <zhengqi.arch@bytedance.com>,
 Shakeel Butt <shakeel.butt@linux.dev>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 linux-trace-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
 "linux-cxl@vger.kernel.orgkernel-team"@meta.com,
 SeongJae Park <sj@kernel.org>
References: <cover.1772206930.git.d@ilvokhin.com>
 <d61500c5784c64e971f4d328c57639303c475f81.1772206930.git.d@ilvokhin.com>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
In-Reply-To: <d61500c5784c64e971f4d328c57639303c475f81.1772206930.git.d@ilvokhin.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: D7D73A001C
X-Stat-Signature: 7yon77m9epoz8hue1xeoif9ak8gc44ez
X-Rspam-User: 
X-HE-Tag: 1772460611-560637
X-HE-Meta: U2FsdGVkX1/yZ0wxT+sa5rwf7fg/9i4Vk20GF0FpSePV8v9oUBYdtmKyXJXF+S8g4eoie0AK925lMzO5cFcvMO/r0KatF5aNm0luk9+uIota/1fL8SUGGeMiBuDwI+lSh+2yYK07opkUKjENfeHLkIAFlg62EM4/T1r10TgXSES8e0A4Vs0SL5qSujIACRHfc4QyjoYAxDMkoEWORjxEjsOQjEYQfllQzU1D5i0mpIObYZeKbOL2zNReiL+H9mGt6k35ket/JYlpZnRiW93NJ6bSJ/DozeHEzS3Zp28/6oddF26y56ejSePAJcptCWg2LF9ur9OqyzLzmNKc00yQNFUAEsxmCnY3bPI2SFBIPNlGHI1ygl6wB893lRQvPv7DyXdvxIgS4VyWOXrS/R11EgZMNC6KdpYdXaupmmn6hcVRl1HlFw9ykQxBXurgP5jU3YS/UqdHwxN5mEB6Q8bL7QQzW9IKLRcaRLWIsL9pd7PgwP3ZTvHVM5aujRmNQUARoJaOJ5WjZ4s8sz6/Dg0BRDDsf5/IAcDvvH4NKJNQqs8Ii3SQuy3nbazwL4t0Vtp5EMk4EXvIYXMXtr1sk54148B+R5p6y1PCtGcCiGLB5vJuTR6wG9CAL2vzGnGDL4sP9cqWjsbnq9qB0y19FSJ1CbBSSwywdo5xYvvEX9K4V2ybnkv2uTW6HDvLhuBEz83XRDLIpmWiKzCM6EKjTYIuIWbnlk1lZMUzyiA3nqZ/cEMz8zNgNH02EIj24dqmB/gxmTvXP66cnehbvjstsWTe1gLHEOxVzHHpWPJPf112gHwCfUo6EOBkRSw6NbPWlITnfIpLyCSXw+HiKjQSJD0NnZn8X8qKOWkJZd74JksACkRiOybnLh9YVrzWgTDntM+Z3cexlph1dMrv9ONnxK7tJKWDq6OwY26X0VL9ys30mooAh/y9qgboKUyqGw5GzdK8x74+hQdvFjSMZEEvnjS
 2QTZXEs/
 oT9UZg2eWOyg6bAmYbKnrq8TQg5eVJJ0rBR43kwRuAX6/ldAUnvmdLuTDoF2KWRTXgS7e2NzBb9zkGe+coFMOBfDUuW+RrQfkzZPPOlnfqOEDY6pNzYXKsQymHwJZWNxM9W/EWYgi+TnuY+bz01skPfGCGKI2mbFjTwFzcaVbgcF9SUaM+bmTsOk6doX+hvOS5lA97Dv+MJne59nKasH71ik5vaf4b7qmeKE7s25rtconn+Bfg1WspqQ3Nno74VaNydIHxO+hTCYUVfnmYLYTTnQT+45kFDb/+zwB6Xdk9lEic4n1zzDOp8qR3sEw6LV3g5vl2+8OBzL5DlBanTsa4Fo8pU0giIeEC2LyWsOPjVBkxmWGK0KzF2TgxUtFb8pwrS69hjsMqjyOTPGsY5WXuuWMOYSuFI6wSUgMFzVADxVYXyOIoMbyiVABuvDNqoqCFjcn
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2/27/26 17:00, Dmitry Ilvokhin wrote:
> This intentionally breaks direct users of zone->lock at compile time so
> all call sites are converted to the zone lock wrappers. Without the
> rename, present and future out-of-tree code could continue using
> spin_lock(&zone->lock) and bypass the wrappers and tracing
> infrastructure.
> 
> No functional change intended.
> 
> Suggested-by: Andrew Morton <akpm@linux-foundation.org>
> Signed-off-by: Dmitry Ilvokhin <d@ilvokhin.com>
> Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
> Acked-by: SeongJae Park <sj@kernel.org>

I see some more instances of 'zone->lock' in comments in
include/linux/mmzone.h and under Documentation/ but otherwise LGTM.

Reviewed-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>



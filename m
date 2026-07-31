Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8E8A0C54F54
	for <linux-mm@archiver.kernel.org>; Fri, 31 Jul 2026 07:27:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A36246B00B3; Fri, 31 Jul 2026 03:27:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9E6806B00B5; Fri, 31 Jul 2026 03:27:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 924786B00B6; Fri, 31 Jul 2026 03:27:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 710EF6B00B3
	for <linux-mm@kvack.org>; Fri, 31 Jul 2026 03:27:02 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 0A104A1564
	for <linux-mm@kvack.org>; Fri, 31 Jul 2026 07:27:02 +0000 (UTC)
X-FDA: 85048240284.29.C430E9C
Received: from out30-101.freemail.mail.aliyun.com (out30-101.freemail.mail.aliyun.com [115.124.30.101])
	by imf14.hostedemail.com (Postfix) with ESMTP id 937D910000B
	for <linux-mm@kvack.org>; Fri, 31 Jul 2026 07:26:57 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=RAxHtStO;
	spf=pass (imf14.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.101 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785482820;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eLNMJHOFfOlCx+slGzSsXWk0YgYOSUN0fbbglHvBxqc=;
	b=G2kGSySIbAf7QEbumFRkOtesXsFd5d+Yykg8XLlcK/Eh9u1oFmK0xxV3oBbcPLmfRsn9pc
	rxAZZri21oNVkEtFLlQIv12Kl7Rb9d/xVOzyn5UTAiFAtG7wp2zhBJthhRGgDh8C3ich5K
	Jp7yhBAFNbvKLAgLA76JKYDMrAf0Y7c=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785482820;
	b=PaMICo+9DThCeQjH4F81EqLNf/nwYcRCyqVd9II6p9Q/jcSFOFBHwPKkGoIaLQGFP3NfFc
	bPeq3zE656u+1xT/+wYcRgt9nYaYLs/VN7MMcEWhwvgKMygVnEHreuD1XLMpPnZnr4Tpc4
	k7g6cPZbPJNCf7yexe/Gcmt528XAJJE=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=RAxHtStO;
	spf=pass (imf14.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.101 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1785482814; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=eLNMJHOFfOlCx+slGzSsXWk0YgYOSUN0fbbglHvBxqc=;
	b=RAxHtStO/uKGZp10TAXSSbuW5vDfRpr0Rl2zdUkTAiwzdpdsiPWXAaT2U60S/QbqqQdi6fQHmvAV0xkAUldvxaQuqIqaALzUBAQGzxp/TaYbqK87dIIVXrpmooqGCLf+R52Syv8yPwAipgsr8MZIriTk1tfDQ6RwztxK1lp4rkk=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R191e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033045098064;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=16;SR=0;TI=SMTPD_---0X87FsqD_1785482810;
Received: from 30.221.147.207(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0X87FsqD_1785482810 cluster:ay36)
          by smtp.aliyun-inc.com;
          Fri, 31 Jul 2026 15:26:51 +0800
Message-ID: <3869ea1a-23e4-4b82-bebc-8cf1ae282fc5@linux.alibaba.com>
Date: Fri, 31 Jul 2026 15:26:50 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v2 5/5] mm: mglru: run aging if the preferred type has
 no folios in reclaimable gens
To: "Barry Song (Xiaomi)" <baohua@kernel.org>, akpm@linux-foundation.org,
 linux-mm@kvack.org
Cc: hannes@cmpxchg.org, david@kernel.org, mhocko@kernel.org,
 qi.zheng@linux.dev, shakeel.butt@linux.dev, ljs@kernel.org,
 kasong@tencent.com, axelrasmussen@google.com, yuanchu@google.com,
 weixugc@google.com, linux-kernel@vger.kernel.org, lyugaofei@xiaomi.com,
 stevensd@chromium.org
References: <20260726122123.7614-1-baohua@kernel.org>
 <20260726122123.7614-6-baohua@kernel.org>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <20260726122123.7614-6-baohua@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 937D910000B
X-Stat-Signature: izabpbnz5hhyzi4dxf4yfy6yx7147mx1
X-HE-Tag: 1785482817-306707
X-HE-Meta: U2FsdGVkX18ZOfB9pXRFiqMpOllG1oM0vj9Aw8J37ayjl1PDph3ARhg5w2Jvlqnr9XO9VO2lsCF6+Lq+0WXZ8D1LRgmqwou1ehG5IsDVxTCwkxsr0mQ53UGe5JcmYaL3if0GwXdVT/+IIY9LhP+q5FMgW1itfMWgaMEtW+/49LaTL9WZKQTIYQeawJT2BH18cT+YJmXqAVxzEgGQnRGgvnUwXcdscJJRRCSoZwCzhWerY7u1Jyhx3Yp6qz8oxyEtWr8kQY6V8dTtYqSPXd3pA9qrlZIT9jasTO3psHD9J5SXPbb52rzPMYSY7dVHPRqvh9EcpGEy/GjQ7VHpMFEGQrdEMmDZ4o7o4hntKisQnGCy/Z6roBJuCp05mhYHKtMDvRKo+InMbgnQfYqkRmKNaqTaXRyjNLwyGU4DyB1KAzEa9jPF5FC5NjNPl6sduDzoOXsLOZ6XTC6baczZlB6Eu6bIjYgWFzDLJpoah8uQhH2n5KyV4fBPbIM94Ok2aqzcGNJDezVVXqg5ueEoWknKs+K9SXQKdRyawtUD1R/rN4/5ESPM2wULrd7HDcLCdNoXfSdEk3nGPX+Fi9ST4fqNU+mCHWU8iVKLLkKiGZjCTD0RFT1x3Zi8LHiUxafsBErdBjpsyr070WO9HPnXD+F3oV8NzA9v8hwaLnIuo88Ho3NNsRRXsTLcbjQuTsFM7NLUdOVNfeQSzZdNjKTdPoQcKuBlWTbpiHA7lvsimnkKts8bPEIjHwd0C10sljqazp7UScQswkMjaUV3zgTETHWWxlkR3i00Ar/fIVqMrw6vDyZKPACP0+8vQ5HSP1M6xNYSLZ7WnJReFS7KRzPwSxA+EmDpmfDMRHk25cSstDlCGcwMpfAPzrei3bYty06dpnWna91VAzyweCKV0kFfBTcy/hs8X2vWDJfVLkN2VlUetVopeYtO/eXr5eYwU1OIja+qFQAxwVKz27Jxwm3VOLf
 KJe9qXrW
 G4zNzNrF5hQ8RHMmzjiAMshWpiz88VPQSlvksMPbdCHMj+zYUFME1s/BscBhVUIortZIX9AyyIG0KgLOQrHdOdHctaw9goF4JLo/RSMcxc59ZcKwa4McJBckMZ55jRfCQWLrQ764GJhSjzsxg0OQnojQ4iuX8p+ZaBr2IRANJOC2dEO4XQ1xLySEmMUmT83D5xgaZMLL/ApTySrcGdzwrKEk7bwVVbA40PV0B6BqwuUfdfMnfIxcDTnBOMNRHkxNOi0KagNOujNqQ4pwvWi3xI6BVJBBN0SFg9nAL4jic+DRkFs8RSYb02lAORavVyhGPsuVCRfgjsRSCdeG+b4uHF3Vx6Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 7/26/26 8:21 PM, Barry Song (Xiaomi) wrote:
> Respect the type selected by positive_ctrl_err(). If there are no
> reclaimable gens left for that type, run aging.
> 
> Signed-off-by: Barry Song (Xiaomi) <baohua@kernel.org>
> ---
>   mm/vmscan.c | 4 ++++
>   1 file changed, 4 insertions(+)
> 
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index 7c13dedb0b1f..d63322cdb1bc 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -4996,6 +4996,10 @@ static bool should_run_aging(struct lruvec *lruvec, unsigned long max_seq,
>   	if (evictable_min_seq(min_seq, swappiness) + MIN_NR_GENS > max_seq)
>   		return true;
>   
> +	/* run aging if the preferred type is exhausted */
> +	if (min_seq[type] + MIN_NR_GENS > max_seq)
> +		return true;
> +
>   	/* try to avoid aging, do gentle reclaim at the default priority */
>   	if (sc->priority == DEF_PRIORITY)
>   		return false;

Looks reasonable to me.

Additionally, for sc->priority > DEF_PRIORITY, is there the same check 
logic for the scan type?

if (min_seq[type] + MIN_NR_GENS == max_seq)
	return true;


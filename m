Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9DBE6CDB466
	for <linux-mm@archiver.kernel.org>; Tue, 23 Jun 2026 01:55:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C869C6B0088; Mon, 22 Jun 2026 21:54:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C36E86B008A; Mon, 22 Jun 2026 21:54:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AD9476B008C; Mon, 22 Jun 2026 21:54:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 74C766B0088
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 21:54:59 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id E5D9F140324
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 01:54:53 +0000 (UTC)
X-FDA: 84909508866.05.A95C18A
Received: from out30-131.freemail.mail.aliyun.com (out30-131.freemail.mail.aliyun.com [115.124.30.131])
	by imf06.hostedemail.com (Postfix) with ESMTP id 4B569180008
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 01:54:49 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=VonwGSWV;
	spf=pass (imf06.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.131 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782179691;
	b=AEFYFBugdGFbobjFjuAmKcQ/AP3x7Y0SNFNcU6lsEOfsgeO1H/w+HhsCUIDUsV6Ve2FN7N
	kufYpJyTluVz95RYd45CJeDs+IEOuUJKR1kMd80gUa/Pj8SdtuGm0RYO/ESWQ+5yqVy5F/
	JIJxz0qcg/rgmbp7+URDE+vMi1M/62Q=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782179691;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zMSrrHEC6r/uacCJ2Y96I9hM+DH0T+xP4vq/+KGOBGM=;
	b=3BUhDLGTFf8QpQJ+vpf+khP9fsPRZNCpfTS/hWg9FsPcRG3uPTIw2rsvkglNdaS1M54EZn
	0w2pD/JGHeaYD1CKshcQ0S96VP/TvJZ3Of6TFfXCkldUjVnBq6QYWkahwyMkbNaFk6iNkq
	O+++mlq/wn0z9xWUUGuLU7QkGhroxfA=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=VonwGSWV;
	spf=pass (imf06.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.131 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1782179687; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=zMSrrHEC6r/uacCJ2Y96I9hM+DH0T+xP4vq/+KGOBGM=;
	b=VonwGSWV/6MbrlN7uVkp1IYSAlyKiBxEwG19bhCikPxXAMZqWLyjMjbjR/e+AOOt0F/zl+ES6emlKF3iZwu0+/240jSMTOK/nCJqjsi9TMTVh2WbTmfmyw6beO16ZXciD7541+yohQOEhVZ+55s7zE048zW07W2NyYiF0llRCjA=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R491e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033045133197;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=11;SR=0;TI=SMTPD_---0X5SEl-R_1782179684;
Received: from 30.74.144.118(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0X5SEl-R_1782179684 cluster:ay36)
          by smtp.aliyun-inc.com;
          Tue, 23 Jun 2026 09:54:45 +0800
Message-ID: <84e0ac89-1f08-4f12-8d67-207e37bd8804@linux.alibaba.com>
Date: Tue, 23 Jun 2026 09:54:44 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH hotfix] mm/compaction: handle free_pages_prepare()
 properly in compaction_free()
To: Zi Yan <ziy@nvidia.com>, Andrew Morton <akpm@linux-foundation.org>,
 Vlastimil Babka <vbabka@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Brendan Jackman <jackmanb@google.com>,
 Johannes Weiner <hannes@cmpxchg.org>
Cc: Jiaqi Yan <jiaqiyan@google.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, stable@vger.kernel.org
References: <20260622-handle_free_pages_prepare_in_compaction_free-v1-1-fcf3b14abcf7@nvidia.com>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <20260622-handle_free_pages_prepare_in_compaction_free-v1-1-fcf3b14abcf7@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Stat-Signature: q45pcdnpq9363bfione1rqdeee4kqrbk
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 4B569180008
X-HE-Tag: 1782179689-676600
X-HE-Meta: U2FsdGVkX18QTTO0kLubBfJYSjI0Q7YFINw0spGvqP2O237k1MWucyD2yFc9gwuGaThjRaFTV6ef2Yd0JNlUBdJZ+IDF5SoTHOHgsl9zWhA/WaNWjbakaH3/MDVXjiYKKPlI11Whtnrdl66ZVMm4E/Pu/+uPdin8n6BiTOVJjed2X7cCu0hsm+MJk1JuCtALXUZUQTl4XgD7kzyWsznJ9k0/t1y+tD6O9x7OgWAf8y+2nsd7vCkXIpbqEKqFErSi1RhznGVsDRPgq3FrDGm6GOSqJLNgQn00fmjF73Xw90PXIU3aPLAmDaIAzw3izcc51PFdZklJdWCWvS2EnxU2T/I2trWp0Yfkvo5SiYt8FpLbngaISzBkpZZ6+96dsrCiJFwwLZ62eroNbFXt4k41WVu+rfxOI900vrRAnMuT0ENOW1JZ19j5V+youf1kwaiMWx0g6SvVNcEN1jE9OJiIaooAddTd5WL19pbxk7g6voS87A+gDavTTI2DALw8DCF9V/lvqUW10zSl90m1sJbIrXaVvtJLn+ddQ9VQQ4VORmvZdFusU85XJFJI04HaA0ROoUsa96ZmEeKUPAgNBh/L7JmEJ2eLKtFPcdInXuvAaH0ziGWqsXMavdsulzHYOHbsov5q0hMU7s7cJrWm6tbLGO/AR0Uc4I5KH6Rz0yIpuxpvim+6aGsmDxNo4S914jdnXT4CJeo06KqB5K38g0Vx80/c5tu6mt/SgLlHv+ar0AS6uyvvQzBg0xOS+yXJaU2YJdfWMLRqrunrCUqvkPviB2823Z9v1xDkv/rT8hf1k5IvbRoTvMMx+fz220YrilWu3+3NF0NzxzlUgXj7RsyH9L+6+5+2VCO/MuCkx2bs6/o31aRpV+U2bZUy/9y12cTBqzPV/yL/2T0UgEaZEEfNf3R85WyfM/Go9L1eKzpfIsXDDMvDoDlwXXnRAP//vrjWVRsyjrDViQVhQnK2h70
 bVOvykpp
 9ntOmpqjoyD7RGVnQQHE0ew9vLnFMqg/bm8p5n5wBtJLs93BjC7crjhNQffcjlM7j9y4xJ0w5N4CkD5byc1gXMwMIdOjsuwYsdYIdPY0ZP7jTXUTt4m/OIVZH3E+oHoeZVsqUqrW1NwKA2mBImKd/az0ggfEzqCp0dxd5NQrSC636LX5Vg2XaJXDZr+X2xcM9Mgy4YPPEmtI3FPRKLGgTSz/n/0KLSvLnALm2SOjKhUkM48BgjXy425RGNGf/uczYg6pXIEbUbGfwVWKgc6sBfjBX0+xXF8Kl+fqId00zO8Pu2ChTHeFN13dlWtrkBxC7bqlM0xyR5HTDQjzhpDh2Y8I7Fma9r50yoDoJlABIY9ItT7418snAd5qIfzLPTbLMZZurniVmONfaMmc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 6/22/26 11:30 PM, Zi Yan wrote:
> free_pages_prepare() can fail but compaction_free() does not handle the
> failure case. Failed pages should not be added back to cc->freepages for
> future use, since they can be either PageHWPoison or free_page_is_bad()
> and might cause data corruption.
> 
> Fixes: 733aea0b3a7bb ("mm/compaction: add support for >0 order folio memory compaction.")
> Signed-off-by: Zi Yan <ziy@nvidia.com>
> Cc: stable@vger.kernel.org
> ---
> free_pages_prepare() can fail if a page is PageHWPoison or
> free_page_is_bad(). compaction_free() needs to handle these cases to
> prevent failed pages being reused in cc->freepages.
> ---

LGTM. Thanks.
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>


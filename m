Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 859ABCA101F
	for <linux-mm@archiver.kernel.org>; Sat, 13 Sep 2025 03:04:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 66D918E0002; Fri, 12 Sep 2025 23:04:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 61E578E0001; Fri, 12 Sep 2025 23:04:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 533E98E0002; Fri, 12 Sep 2025 23:04:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 45B518E0001
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 23:04:58 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id CDF291409F2
	for <linux-mm@kvack.org>; Sat, 13 Sep 2025 03:04:57 +0000 (UTC)
X-FDA: 83882735034.24.A7BEED0
Received: from out30-119.freemail.mail.aliyun.com (out30-119.freemail.mail.aliyun.com [115.124.30.119])
	by imf19.hostedemail.com (Postfix) with ESMTP id 4361C1A0005
	for <linux-mm@kvack.org>; Sat, 13 Sep 2025 03:04:53 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b="FP/D4P48";
	spf=pass (imf19.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.119 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757732696;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6oiFjqJ2Qm+dtXW2VEyHJx3EfGVEzVOxZqD8aCepxi8=;
	b=a/Twt4E1SfG8UxZjSXdZHiayA4RfV0W7eHfYIPskkFR1mOgke0joSchZkpP8XKgDkmOR1r
	itrB+H6Bn++UiorY04/Ztc31A158HJgQXETAZuszSOrsVmn0FsaglUuUvfOvVMBMev3IeK
	PIohorwFfj3Ck1JaV+XufmAiUY/2+2c=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757732696; a=rsa-sha256;
	cv=none;
	b=sHirbh/rHlVXJv504l4lij8T3na/cnbRywB0b/yOGDB1fM3Tt86L3RE9EPGHL62yqLnzEU
	4J2Tn9CAbMP3Mzwp4gMCBIfMpXoUa2SUaXAc7dq9fxLY5sx/XQGEvJ0rdcdqB12tXo/Rz7
	/s7vQqfsieyW6g9h9phgJnN+r6tCSmI=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b="FP/D4P48";
	spf=pass (imf19.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.119 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1757732691; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=6oiFjqJ2Qm+dtXW2VEyHJx3EfGVEzVOxZqD8aCepxi8=;
	b=FP/D4P48WXsidbDWSIUnfJdAwix+aYSESt+Lbau08KYFHLjNlEZslSFYNHiuCqm+EFGAtwQZD+vDSm0ybsdmJGU1Aq65Qq52vZ77KhDXO9dUZfSQUz07U0lNb5p70UNyUW7/aee2q4INaJsahJ5fYdTaMjQ4/xIr3zr+9qe8bPc=
Received: from 30.134.50.220(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0WnsSUij_1757732688 cluster:ay36)
          by smtp.aliyun-inc.com;
          Sat, 13 Sep 2025 11:04:49 +0800
Message-ID: <11629632-c652-460e-b617-3ec0c27969f5@linux.alibaba.com>
Date: Sat, 13 Sep 2025 11:04:48 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] mm: vmscan: remove folio_test_private() check in
 pageout()
To: Matthew Wilcox <willy@infradead.org>
Cc: akpm@linux-foundation.org, hannes@cmpxchg.org, david@redhat.com,
 mhocko@kernel.org, zhengqi.arch@bytedance.com, shakeel.butt@linux.dev,
 lorenzo.stoakes@oracle.com, hughd@google.com, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
References: <cover.1757648598.git.baolin.wang@linux.alibaba.com>
 <b8c0fe71982aa1cafafd59d8e71064efaac16007.1757648598.git.baolin.wang@linux.alibaba.com>
 <aMQ6bW-OoMWMVEFF@casper.infradead.org>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <aMQ6bW-OoMWMVEFF@casper.infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 4361C1A0005
X-Stat-Signature: f55it5eqp5bnbi6ju5srop3x6mytq1gc
X-Rspam-User: 
X-HE-Tag: 1757732693-696142
X-HE-Meta: U2FsdGVkX18m8Q+p/RURmBrkbGLLuEjJnfVkNm+dig57GjSOdPPZEkwj0r2oMkLVoftQ9DKRqKKgjyrcx9zi9gXKuSraiY3+pY4Z9r1znfaLcVm+TNPCm0iSEoO9I/53HWmiTdmymh3FCthMqtGJNBBoxyTp0Qo8Epmu5dSPNV7rnkozxGGqlvLgrqlbhJG2I3xgQg1dVh169g659S2DMSBQYUHNTgDzlq3K8BHJIT3B79JCPrCIKggSZhu4P4Nju6xLOz1BcpLXbMuczcipXpHH6+lmgq4x2MVR6gDlv6KT38dKfBprXLSuynn0xNt3drjlzRb8FZCrsE538pctSrbqPSiGB14rNDKJggx0L2/dRF8AHGOWeCCrxVMm82+TH0UF7Tfh9+uqrNrvW22RumV38CNQp1JlSl4xu8GlRBlrz1VKyia1xYPCsIdVGX40Fny3unikYq/XmSyE230wUF6P6lLV0k0o15TzF+Al+mixJmrMZEhd3F+5NTgYdbsOKvHV6yqDD20zve9JT2oBpuWs2wA7A3kDDas1s5sNbpYFc25BGDcImrCbBdwFtWXe6sgZlq/pt5Yo9ZEcJIGR4t84ecJr8oj4Jsfy46Gx72J+IukUeyZ3LvjD9NlVLtSwGoJAIVISkLVRwi4ruo0RzMyZ8wZy27nEPfTQu7ZZWvYPfXyJa29g5uFWVonSrxM7EkKVhQ071kz9CiZJxWRXjHno++dhEbXO7cvR2vdf7NPHQEi13Xbf+vElrNgirjKvQcHX8lAgGxjMccdGxUH//7enTW8UZnn/zGTGZb47nGPddVy+sfrRUPbQzPWeGWO+e+TffCft81v0YOqLNoF0hghqFUxJ3F0dGCKDvJIOl0gn+7a0nWCLfa8bLwS0w7kVsicvaBRfDi26QEIB+ch/9ZR9PSu9BW8qldQCFzyGiQht148G21J4FKjaOloKUpT8VHMknUmVJj7k4fV1MrX
 CeMRlCDQ
 1BDdz5PhisaT4eo6AXLetChTX6ttqbQnaxl+bZmZXETt7N8Bjqjr5xg0xtC8s5a76N48Ah0vIyqFqqjkyQRTim9QJagx4mWYxKMGkrM/DIqt6PW6ZC5fvUW5JSY3v4A3c5GoVJpQ13AvDkDglW+OsDVU23mY53UyeY+tu/GuwGi8k7Nf6arHWnkIVMdaKStQ5DCmcAv9sSGvcAv27qPYCxAZxKzFNVKOcvxyK6He0ezcaQCF+Wgr/aZbXT9dKsBKJfCFTix9bieVuEGKNQ4NeIBbQgIaI+oq+kuDUReyMlmVCMBf10mT3Kdg/KY26uYn3NsTBFHz+zWGbnhh5BrWDl0xBr2+jnkvGMwHo8r5gBeabwvU=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2025/9/12 23:21, Matthew Wilcox wrote:
> On Fri, Sep 12, 2025 at 11:45:07AM +0800, Baolin Wang wrote:
>> @@ -697,22 +697,8 @@ static pageout_t pageout(struct folio *folio, struct address_space *mapping,
>>   	 * swap_backing_dev_info is bust: it doesn't reflect the
>>   	 * congestion state of the swapdevs.  Easy to fix, if needed.
>>   	 */
>> -	if (!is_page_cache_freeable(folio))
>> +	if (!is_page_cache_freeable(folio) || !mapping)
>>   		return PAGE_KEEP;
> 
> I feel like we need to keep the comment (assuming it's still true ...
> which it probably is, although there's nobody who would think to update
> this comment if it became no longer true).  I would certainly wonder why
> we can have this !mapping test.

I think the !mapping check is still needed here because the tmpfs/shmem 
folios truncation might race with folio reclamation, see shmem_undo_range().

Additionally, the comments here are no longer related to tmpfs/shmem and 
swapcache folios, so I still prefer to remove them.

>> -		/*
>> -		 * Some data journaling orphaned folios can have
>> -		 * folio->mapping == NULL while being dirty with clean buffers.
>> -		 */
> 
> I approve of this simplification, and I think there's more work to be
> done in this area.  Thanks for doing it.

Thanks for taking a look. Yes, I will continue to take a closer look at 
the further work here.


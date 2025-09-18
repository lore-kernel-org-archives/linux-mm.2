Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2086CCAC59F
	for <linux-mm@archiver.kernel.org>; Thu, 18 Sep 2025 02:45:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 799B78E009D; Wed, 17 Sep 2025 22:45:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 771DE8E006B; Wed, 17 Sep 2025 22:45:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6AE478E009D; Wed, 17 Sep 2025 22:45:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 54F028E006B
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 22:45:46 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id AE51516077A
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 02:45:45 +0000 (UTC)
X-FDA: 83900830650.16.B9C6EAE
Received: from out30-131.freemail.mail.aliyun.com (out30-131.freemail.mail.aliyun.com [115.124.30.131])
	by imf09.hostedemail.com (Postfix) with ESMTP id 8B7E2140007
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 02:45:42 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=cReQRru3;
	spf=pass (imf09.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.131 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758163544;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=edngCZIauCo4tQxaAcmWsONusTDWKBny329eUJIO/dc=;
	b=Pq3eSgXaAesLiLdVXSE3+nw9jZgCaYmL8+B+HD7GlyclHalIFn5m10lcIbJeTW3//BNBW1
	QuNmJfLmv6N/SvLqYvXejx+gBwvYI8LKmzkgoxwyleFQqKs+FhQZefnRAjyyt6CEcqcvoo
	JjxlUDM/6aLTRT9JE+Nw+GYNXIHIyUE=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=cReQRru3;
	spf=pass (imf09.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.131 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758163544; a=rsa-sha256;
	cv=none;
	b=xpuJK71jbHA8606ELgWaSKf/eo69KzLCK5WG3WCFQZhBB3tBN0yLc0AchC8PY7FSCzfFQz
	pXoA/tC27dSJyjkreXousPK6OdzjypjPzhq8OnERrOwJvLaRyPfhIe6XXAnHvGIGMAZ+L3
	wg49HJ5ITLcB5+7bdLbt4spkjb2XIwo=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1758163539; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=edngCZIauCo4tQxaAcmWsONusTDWKBny329eUJIO/dc=;
	b=cReQRru3JTV5jfiZETOjJcHf343qYMoK9vdrlKtins8s61TzFxdRHAT6VS+fVqTzILh/Dtk1n2RnaU/RMd2h80Vc+K7i04vIvJel5hA5oBtqCfnvTPj9AbXE3OaV4AxBA7Rs8yviVVPY+SuHBm+Ajzqb3pDtdWX9ay4mTgttntI=
Received: from 30.74.144.125(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0WoEIDoH_1758163537 cluster:ay36)
          by smtp.aliyun-inc.com;
          Thu, 18 Sep 2025 10:45:37 +0800
Message-ID: <41c98144-de4c-4b46-b842-dfc03e3b0cca@linux.alibaba.com>
Date: Thu, 18 Sep 2025 10:45:37 +0800
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
 <11629632-c652-460e-b617-3ec0c27969f5@linux.alibaba.com>
 <aMh7SAlitp5FqR-M@casper.infradead.org>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <aMh7SAlitp5FqR-M@casper.infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 8B7E2140007
X-Rspamd-Server: rspam05
X-Stat-Signature: kp8tcdox1tysmzonzrnxi961tgmpunuw
X-Rspam-User: 
X-HE-Tag: 1758163542-441368
X-HE-Meta: U2FsdGVkX182NjxvaIJDgK6ywc10jJKQlfJ+bUFB/GJnJk4vlRzGJqkvypymfYZLTY8nhUq7IF8+OJyHG7bED2tgcIp8umzjcso++ru8kGQ3mPu12w71tQJtlvYHJc334nrLrRKhq8547NnWAJOWSZVJRFgapSSCjUO4a89ecnrX2vpfJEAvrxbN4xyztmH0X22ld1AOBe06oLerdqm7q9KgHudAqvNrs06oG1eDc5/FZ+GgJLuzFZf7T1BbaGmDR2FxgcAFaozLyF0WGhpnm3ghkfNAXRSO9bwrDIyWmtzdNRV09utJcFZPyRzFNonSfPIRN4VrRBJSn9oPrVfiZNpFspHFc6xfoAag9F+vDOh+x07jAJ0A4eKMxtZaUJ58+HwfTaVa34/6w9hzr8fMtHELZ5cf+z9hbXFwNOTVDh5jwnrcWjiK+OTdLr90IPaplA8qjvtcozVN5+mTBq4za7zCn+SOtQ1MIjE9X7AUIbfsvxjTl8DHLVbr+GXlK1Z2MgjCSefFApCWMK6j87KB6nFdo6i3bGVmXLejlyMLNs+d9ckzbGuuSVgDQqtWOn61ASL00MfbqmNhP/+Sns0oooehT7mWUy+51O0IEKMXuSxEAGR3fQJLiThoTG8l/JqaBv1kS9yLY4rfPcWN5k4eXGitsG3TsMpuIGcgZaRdG1GXuXU4x/gAYsanYd4Pa6AfaV/OQdejs1/PQ9VSQFX4eQ2NZethmDguuTpmUJzu9YdpsSuu784C3G0Z4ArC/Mzvrz2+VoQxeZB5MRu2xPy+c3BNNCfryJT4isGH65oQM2Ji1bMafl7acamVdtymRBQ0HVv7H+FBgdMXR6lB50/elp11fKGm0PRJHVARSWYdDoW7FRVdqSz5akgi10jZdk+LuCWtmWyLpxgmymoOz6qiQCaCc88uantXi3Wzr/N/ftU60wURuRMuPuBsu3GpuH00NBat9h3OgaoCxOgDOFU
 iQS/ewzU
 nyuIG3qujf/gy29jTWSEP2B3HVlbfwzZpO6fdoXqKcJoqjUbYbSkflisnJsgoowYrf03y8U6ai1K9vzayn/Rp1f5mIWxndPPI2HrQkhilbMRli4/s3qBiseMldHhawFaQJjgSN+gi9ryVdqIJU+EmlP9BcmkftCBuIHHrkg9Epw+XkNNa+1ari7Eq92uPd07zw6YLO96otGjMBMcY05eycpLdB8DNRysKeJ+N95bfXtGhQuKivofujlh7ZmRQ58S8ni1LmNuMpotGJSirukcV98/y0QcB7339RjwD6sUoyMJ7MWYZQkKl4YkAQlU0oyqnsM9grPRC9VHndeL2WNUoNbWu/MLsU3aFsXH0fkXTdfn30M/MlqEw1hjrLMntXF6uM2FSjkPoxkGKWpHzikgoLx+FfA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2025/9/16 04:47, Matthew Wilcox wrote:
> On Sat, Sep 13, 2025 at 11:04:48AM +0800, Baolin Wang wrote:
>> On 2025/9/12 23:21, Matthew Wilcox wrote:
>>> On Fri, Sep 12, 2025 at 11:45:07AM +0800, Baolin Wang wrote:
>>>> @@ -697,22 +697,8 @@ static pageout_t pageout(struct folio *folio, struct address_space *mapping,
>>>>    	 * swap_backing_dev_info is bust: it doesn't reflect the
>>>>    	 * congestion state of the swapdevs.  Easy to fix, if needed.
>>>>    	 */
>>>> -	if (!is_page_cache_freeable(folio))
>>>> +	if (!is_page_cache_freeable(folio) || !mapping)
>>>>    		return PAGE_KEEP;
>>>
>>> I feel like we need to keep the comment (assuming it's still true ...
>>> which it probably is, although there's nobody who would think to update
>>> this comment if it became no longer true).  I would certainly wonder why
>>> we can have this !mapping test.
>>
>> I think the !mapping check is still needed here because the tmpfs/shmem
>> folios truncation might race with folio reclamation, see shmem_undo_range().

Sorry for noise. tmpfs/shmem folios will be clean after calling 
truncate_inode_folio().

> I agree that we still need the !mapping check.  But it needs this comment
> that you're deleting, because it's not obvious why we'd have a dirty
> folio with a NULL mapping on the LRU list.

As I discussed with Hugh in another thread[1], the issue of a folio 
being dirty but having a NULL mapping was fixed by commit a2b345642f530 
("Fix dirty page accounting leak with ext3 data=journal"). I can hardly 
believe this kind of situation can still occur nowadays. Anyway, let me 
leave a warning comment here.

[1] 
https://lore.kernel.org/all/1111883c-974f-e4da-a38f-bb3d337185ad@google.com/

>>>> -		/*
>>>> -		 * Some data journaling orphaned folios can have
>>>> -		 * folio->mapping == NULL while being dirty with clean buffers.
>>>> -		 */



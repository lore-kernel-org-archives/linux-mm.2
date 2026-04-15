Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8ADD4F9D0FE
	for <linux-mm@archiver.kernel.org>; Wed, 15 Apr 2026 02:27:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A8E7C6B0092; Tue, 14 Apr 2026 22:27:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A66186B0093; Tue, 14 Apr 2026 22:27:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9A3066B0095; Tue, 14 Apr 2026 22:27:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8BC5F6B0092
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 22:27:55 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 21DE713A1E0
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 02:27:55 +0000 (UTC)
X-FDA: 84659204910.25.A94A21E
Received: from out30-113.freemail.mail.aliyun.com (out30-113.freemail.mail.aliyun.com [115.124.30.113])
	by imf04.hostedemail.com (Postfix) with ESMTP id E76B54000A
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 02:27:51 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b="WB/8Vhxd";
	spf=pass (imf04.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.113 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776220073;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UGv9x1boX8h/Deb8a8+F3ObyeaQMEQe0PQ12CK07I5Q=;
	b=xm8s9hR71ePJG1wuxTXPhlK533Mw3u6vuExE/tZ7/7NwCH62Y76cb4fRitp/P/S5EjLjA2
	2BcS2WRw/tPP4468SmpfNA+kkC9rklwagUy1obja5M0F5oheDwZp7iDpOA91po3+r2t+Qf
	jowVLDonHVkYpiCndjUDu7LlYkmpYbc=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b="WB/8Vhxd";
	spf=pass (imf04.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.113 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776220073; a=rsa-sha256;
	cv=none;
	b=vWXYov78iOli9pmSktRO3rU2WysyCA0qjvuoHLQqL+oG/b3UY0LDloK+ffYRna+AZxe9WF
	C4UeLJtP5ZrTM/uB+XWUvC3+fQOg7nZOYMk4mHHMa0kzK/J1n+8rVHazxVjIRacR/eWf0P
	zYFcdkgn2jcLwUFPNnKFQXiQrz7+nq4=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1776220067; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=UGv9x1boX8h/Deb8a8+F3ObyeaQMEQe0PQ12CK07I5Q=;
	b=WB/8VhxdRz0CoWK0Rl2C/CMFrU3rpY5l+wyYucwIia92gA+3bT3lnnNL/NsVJA6ymRO1XVIlk5vfdtmHGGmcY2ORSh7wsH1s09AvEFfYCjrNK0nliJn1Q84j98dyufyeL94sabHVDiMrrGOyGMQUQTgXUOOpMxZ4hHkjgF3xFa8=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R491e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037033178;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=19;SR=0;TI=SMTPD_---0X12xEIY_1776220065;
Received: from 30.74.144.121(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0X12xEIY_1776220065 cluster:ay36)
          by smtp.aliyun-inc.com;
          Wed, 15 Apr 2026 10:27:46 +0800
Message-ID: <7d5bc512-f3ed-40dc-991d-70cfed32b6f7@linux.alibaba.com>
Date: Wed, 15 Apr 2026 10:27:45 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] [v2] mm/vmscan: avoid false-positive -Wuninitialized
 warning
To: Arnd Bergmann <arnd@kernel.org>, Andrew Morton
 <akpm@linux-foundation.org>, Johannes Weiner <hannes@cmpxchg.org>
Cc: Arnd Bergmann <arnd@arndb.de>, Kairui Song <kasong@tencent.com>,
 Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>,
 Barry Song <baohua@kernel.org>, Axel Rasmussen <axelrasmussen@google.com>,
 Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
 David Hildenbrand <david@kernel.org>, Michal Hocko <mhocko@kernel.org>,
 Lorenzo Stoakes <ljs@kernel.org>, Muchun Song <muchun.song@linux.dev>,
 Davidlohr Bueso <dave@stgolabs.net>,
 Koichiro Den <koichiro.den@canonical.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
References: <20260414065206.3236176-1-arnd@kernel.org>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <20260414065206.3236176-1-arnd@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: E76B54000A
X-Stat-Signature: x1uwr73oa9o4bb9tfyaxibogso18rxbb
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1776220071-781604
X-HE-Meta: U2FsdGVkX198ecJ4r+XlOJtPxdVR5WDKbZ4rNhvE3jsoxbB1rLqITn99BKO6vGDMWyNQ/V9OFfe2ejJX3v+L38d4anIeREs44oN+peYNetcgkB+h11o/Lc9t54IhauSamfa4DCjEoSvSQJ8PcOPQG/VDe4dbbsOLeFuDwVfLWan714n9TkXwitcH7QfL6Sb+y68dpUajOv2KosXn4TGxErDEHpHriGUgwn7U01gnqf9R1q9f6N6yqxAmBjjsoaYnOjMwpjylrEPGXcD9ZI7JcMNHU19L35CcVB15m9oCZzHR6682krukIE3FJi03iv+awthTo8WT4b7IafoMib8Ulqqxp2S4KDbkvoZzLJpFzwXl6c7K2HGF2CBKwt2mvRMdyDMfZRLqyOfo3WPAqgekQmKJv8Bw4k3YtKj76eSYUYnb0faabfehwq/Mau+RIUyg8NWXVHt/8ePmN3NtCJtBz2iLBDQKAQ0Ki+EnFbWPMyGI/uZzAjQfRMkUJRXJ9gOTEE8KVr7HKMPN19kzeW7dZED3mCoeFKf057Sdt06lh80lEEdRaKjmOLX+n7BbWgaTUUUqNCPuXWpGMBzqfCsy+FChGsH6nYn6orxzVXAL9mS+JwuG1QSzlIwcDXoPrSgPElhF/tnUkthJjeDSgnC7HGaaR1BHJdbBaW9ql7P+OND0CqZmpi/ItwR3C4IYULo2IXz3gCDdD4F3fk8dbmGs6kip5BRGrSIcVfH9wJDzbVLEifqs4/tx6H/7RtcwEdagoey8apdUTcIOvageOQNtsuNOeV7tCimXkUTyJpATNCrtoJ8dVzI8q1io4SJn8Dd0zAi3o0m0Dw9mbF70Q1/1wqOl/oTenCpp8cxKAwneJcKuyIybNVFchlGgZ60d52pdpecLzOx8kzL/kaqOpNBrakb0LQitkmXC9epWmTXnKJDzz1wKxJrV07blElpMFjoXrCS68b1uH1blDnzEz2Z
 0NG/Uyja
 FQTErw/cOiELSWtkDYGtO39Nw3Avku+t+QGyRGDjLfuUc+MhAqXb4qNHyODrIo5BaFQ+PPpZ1Wp+SaOBudEsYpegGjkSx1/tpqyFxmL6tYmv/NMr1iTn8XTiPIeg3CBqGH2wU1RyqtneeoFADzrMtbdF7BfAlrOu4sASI0Hrh6rwAwHeFReeyqAmjqAksnS2BWmEFFkTAZZvcxlmcYcR9tHsJho26M+Hhm4hdAzxio4inKKck4eMHyiabWzdxLKImd5wJWCg4AwnngryCrXY16W4jtr1zoHa5KgZyYmrUeA359hrLuT8eVZIjXZfmISGrul8eOdKdjAtC6z1OdOendCtgfSsZpwIYp+eC
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 4/14/26 2:51 PM, Arnd Bergmann wrote:
> From: Arnd Bergmann <arnd@arndb.de>
> 
> When the -fsanitize=bounds sanitizer is enabled, gcc-16 sometimes runs
> into a corner case in the read_ctrl_pos() pos function, where it sees
> possible undefined behavior from the 'tier' index overflowing, presumably
> in the case that this was called with a negative tier:
> 
> In function 'get_tier_idx',
>      inlined from 'isolate_folios' at mm/vmscan.c:4671:14:
> mm/vmscan.c: In function 'isolate_folios':
> mm/vmscan.c:4645:29: error: 'pv.refaulted' is used uninitialized [-Werror=uninitialized]
> 
> Part of the problem seems to be that read_ctrl_pos() has unusual calling
> conventions since commit 37a260870f2c ("mm/mglru: rework type selection")
> where passing MAX_NR_TIERS makes it accumulate all tiers but passing a
> smaller positive number makes it read a single tier instead.
> 
> Shut up the warning by adding a fake initialization to the two instances
> of this variable that can run into that corner case.
> 
> Link: https://lore.kernel.org/all/CAJHvVcjtFW86o5FoQC8MMEXCHAC0FviggaQsd5EmiCHP+1fBpg@mail.gmail.com/
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> ---
> v2: replace the earlier more invasive cleanup with a trivial
>      workaround
> ---

LGTM.
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>


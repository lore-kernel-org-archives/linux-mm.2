Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3FCC5C5DF81
	for <linux-mm@archiver.kernel.org>; Fri, 21 Aug 2026 00:24:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D17C36B0095; Thu, 20 Aug 2026 20:24:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CEF506B009B; Thu, 20 Aug 2026 20:24:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C2C2F6B009D; Thu, 20 Aug 2026 20:24:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 92E7D6B0095
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 20:24:17 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 0C2C5A2C6C
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 00:24:17 +0000 (UTC)
X-FDA: 85123379754.10.7A53A6E
Received: from forwardcorp1d.mail.yandex.net (forwardcorp1d.mail.yandex.net [178.154.239.200])
	by imf15.hostedemail.com (Postfix) with ESMTP id A4F2FA0003
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 00:24:14 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=yandex-team.ru header.s=default header.b=zrmsxZNa;
	dmarc=pass (policy=none) header.from=yandex-team.ru;
	spf=pass (imf15.hostedemail.com: domain of d-tatianin@yandex-team.ru designates 178.154.239.200 as permitted sender) smtp.mailfrom=d-tatianin@yandex-team.ru
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787271855;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PisyH1HuiBHr709YrZqJgs8jcmnNqZIHg4qjGq0xcMY=;
	b=F/GICmho2PVsvTKeu/ERW8venqSwnxAcNxJaKayoaBoNUXF7N2EHLANEcKXoNCFU07oN0B
	vaKKwSB1iXVjIOcy6GMAjqW+EuB9teBnGXTyzQ1Dk6C6FT99IHTEtZGngaWTQncUodpe8k
	eDVieDiYPnyrQbWm68c3ylzduTgmXJ8=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=yandex-team.ru header.s=default header.b=zrmsxZNa;
	dmarc=pass (policy=none) header.from=yandex-team.ru;
	spf=pass (imf15.hostedemail.com: domain of d-tatianin@yandex-team.ru designates 178.154.239.200 as permitted sender) smtp.mailfrom=d-tatianin@yandex-team.ru
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787271855;
	b=UV1D3dSjyM8CsCOAKzf8uREctQj4/UVPElI7lIxhlxMmlzbLwHaF4A0tLIJe7Amgea/UeE
	tU45mT82OqFOyxe+jpPZGBVmgFk2CKm9nM5Rikhlomj/KpC1ObZqsZGlRIQKcdekWw9nnA
	lK5om1eER3a4Br4flDsqZ+2AWJBbKDY=
Received: from mail-nwsmtp-smtp-corp-main-68.klg.yp-c.yandex.net (mail-nwsmtp-smtp-corp-main-68.klg.yp-c.yandex.net [IPv6:2a02:6b8:c42:86a0:0:640:75de:0])
	by forwardcorp1d.mail.yandex.net (postfix) with ESMTPS id 0513480EE9;
	Fri, 21 Aug 2026 03:24:12 +0300 (MSK)
Received: from [IPV6:2a02:6bf:8080:a74::1:2e] (unknown [2a02:6bf:8080:a74::1:2e])
	by mail-nwsmtp-smtp-corp-main-68.klg.yp-c.yandex.net (smtpcorp) with ESMTPSA id 9OLK3n1WPKo0-KxUMjvRq;
	Fri, 21 Aug 2026 03:24:11 +0300
X-Yandex-Fwd: 1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex-team.ru;
	s=default; t=1787271851;
	bh=PisyH1HuiBHr709YrZqJgs8jcmnNqZIHg4qjGq0xcMY=;
	h=From:In-Reply-To:Cc:Date:References:To:Subject:Message-ID;
	b=zrmsxZNaqv7j4hhgQDAaHui5rz9F8+lbtfAN2aMMsqQBT2HZxbj4SrYv+feULDUDO
	 IsheZmFUrJi/JnQJsQL2XPHRcTZtrIawP3yLfiRXyQA0Cg3v7NpawOJIT+HXgJF0Fu
	 J93X6G+1yqDc02vps03V8WtZjDd9jAlluPuglBF4=
Message-ID: <d1d6c16c-a43d-452e-a6fa-67db561d1eea@yandex-team.ru>
Date: Fri, 21 Aug 2026 03:24:09 +0300
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/vmstat: add per-order allocation slow path statistics
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, Vlastimil Babka <vbabka@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Brendan Jackman <brendan.jackman@linux.dev>,
 Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>, Mike Rapoport <rppt@kernel.org>,
 linux-kernel@vger.kernel.org
References: <20260820133659.712111-1-d-tatianin@yandex-team.ru>
 <20260820154913.3d6a821f6ba5c1f81d134a0a@linux-foundation.org>
Content-Language: en-US
From: Daniil Tatianin <d-tatianin@yandex-team.ru>
In-Reply-To: <20260820154913.3d6a821f6ba5c1f81d134a0a@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: A4F2FA0003
X-Stat-Signature: qcy1c4ie7gmtkjuryk4rjnh35c88nfzg
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-HE-Tag: 1787271854-768907
X-HE-Meta: U2FsdGVkX18tMW9E5fcRfNockglgW7c+Z9hyhfcPnng5qp9oeTpuGtS7inM1fb9hEzD7yVgq7vT8dT/1Oi3JKf/4ji8QT0KoU6D2yxUZ0lYz4w7tTXwttROeJ+M10XiG3u4psKVzcBnHgEd3BP81mk9eD+vDb9MaFgzwlsD+KWqQVwOPqozzhj+5p2RX4TA9djWq+i0S25fkaCEaFFMmQ4dAdqrFLjI/UEWUSbh4P9Z0O03khKk4QF5menCjpNrqxWu3huzb+bl9tNZCXDB2WnaGbTgv3PJ7Pq55Y/tNZTmbpzU43EnJCqVV2nIAPFgRevzUaZfVfXOHV4+6ci3gyZutCDQyJ3rUqdJJwMOT4QoG8oUrocfyLQuUM+B73u36mfl0dThfFHzlfcQGqeBu2LFxRFoTdKVAS3XIL7wEKCXCTalPiF4YmeaxPp4p/QA5TmPxxi5m+FaFLlCMB7Taw8ODsypd+0kS4L+Zkyt8zT0G3mx5j29mMkjb2EaiO3J8u9iO5IMW2JE9eqmsg9IEZ+4zUyp6ySQIMQwqI9HE77JBPFwg0F+juxuiSlxWPA/39Sx+OkCKPW1/HkK3zHY2o/GVVC9lnT8ypftYI+4moi3Iull770gNgjEG6nnASZ/LclMPzaioJoEixG6hddTLDyCPc8p+wUUyett+5nT5p6o5Ay6Odc8Z6ufx4ZYK7yjQfi0pgzOZfxLunXGX7CuVfig4DTIsfVqLQ+2AVb6tH8iy+5nhYXJXH95KUhyhDmbcRhVzIAtzFpNQCvuscV/frI0nKxxXHoJSHPNJtIFwKDDOooSTYSg5R0b2LTuyVFlGlHPTiYuoyJas9Zoba2MQBjcySnLiz2y59tHTG7kGOpE9F+9iQhY2hYX5ead45tjIlFDPfzmQzH+9ocmwKrzXF7NjIMuU1iS5JD/xugGlFZEfQUjKjoAoqRe6qz8UEz+EEVbdTrRAtndVmnclgEP
 2Cc+DVwP
 M7WIZaxaM3yuE9L//gazcXtJfrR9pJHtECElKpAGUclLjcx1BLIRPt5BXWgvfJES4oCDG4wPPthKAOEf5IWY/7leOns2SkNrYYUsCLI37sXD+rxBx+V5s34UW6kKbredywAHt84S7i1OnS3go1wfBykz7VkOHJJLJFxk8CBGQjtP+LXJqPZ7b3WkeHfnKTgU95XWJpTCazcvhzCwdSdwKnE3ueiDKeJqpb+XBY6E15CupUEYDRe4GGLRSW0qvLT2yCa3yK0qLUKnHMDRfsQvKy8aWwRTCJ1RqSfvxZa/83m3VBFAaedQ9gk61nRrdtxlPqxaf249KBM+1l1PSEW+41M8aFvJiKFCc1BQkYOj9m6Jsp5tNx4HPk1c9e02UdAy2nxNYyZDzx7YCwwHCUPXziG6IgMg617Bu5yzre6tplXVEpsR2uY8hsMXdrWhNy4McTmvspIS49fT+rig=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Thanks for the quick review!

On 8/21/26 1:49 AM, Andrew Morton wrote:
> On Thu, 20 Aug 2026 16:36:58 +0300 Daniil Tatianin <d-tatianin@yandex-team.ru> wrote:
>
>> Production incidents caused by bursts of high-order allocations all
>> entering direct compaction are currently hard to attribute from
>> /proc/vmstat: pgalloc_* has no order breakdown, and compact_stall does
>> not say which order stalled. Tracepoints can recover this on a single
>> machine, but they are impractical as an always-on fleet-wide monitoring
>> source, which is what is needed to correlate latency regressions with
>> allocation behavior after the fact.
>>
>> Add per-order event counters to /proc/vmstat, covering only the
>> allocation slow path, so the page allocator fast path is not touched
>> at all:
>>
>>   - pgalloc_slowpath_orderN: entries into __alloc_pages_slowpath(),
>>     counted once per allocation, before the restart loop
>>   - pgalloc_fail_orderN: allocations that returned NULL to the caller
>>     (including a successful allocation freed by memcg charge failure)
>>   - compact_stall_orderN / compact_success_orderN: per-order split of
>>     the existing direct compaction counters, order 0 is omitted since
>>     direct compaction is never entered for it
>>
>> All new counters are purely additive: the existing keys are untouched
>> and compact_stall == sum of compact_stall_orderN.
>>
>> alloc_pages_nolock() is deliberately not counted: it is opportunistic,
>> never enters the slow path, and its NULL returns are expected rather
>> than failures.
>>
>> Counter names are generated for any MAX_PAGE_ORDER the arch Kconfig
>> ranges allow (10..13), a static_assert catches larger values.
> AI review got upset about this:
> 	https://sashiko.dev/#/patchset/20260820133659.712111-1-d-tatianin@yandex-team.ru

Indeed, it appears PowerPC even does 7 in some cases.
Will fix in v2 in a second.

>
>> A per-order split of PGALLOC itself was proposed in 2017 but stalled
>> over fast path overhead concerns, restricting the counters to the slow
>> path avoids that overhead entirely while still capturing the
>> allocations that cause latency.
> Seems useful, thanks.
>
> It would be easier for others to understand the proposal if the
> changelog were to quote some sample /proc/vmstat output.

Agreed, will attach in v2.

>
>> Signed-off-by: Daniil Tatianin <d-tatianin@yandex-team.ru>
> Merging patches from Russian-affiliated individuals is problematic.  As
> I understand it (not well) it's OK if the contributor's organization
> isn't on the US's OFAC list, and it appears that Yandex is not on that
> list.

Can't comment because I don't know either



Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CE45E1093168
	for <linux-mm@archiver.kernel.org>; Fri, 20 Mar 2026 03:07:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3F4FD6B0421; Thu, 19 Mar 2026 23:07:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 37EDB6B042E; Thu, 19 Mar 2026 23:07:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 26D5C6B042F; Thu, 19 Mar 2026 23:07:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 11E336B0421
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 23:07:40 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 9C0301B8A5D
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 03:07:39 +0000 (UTC)
X-FDA: 84564956238.02.E25DD87
Received: from out30-97.freemail.mail.aliyun.com (out30-97.freemail.mail.aliyun.com [115.124.30.97])
	by imf13.hostedemail.com (Postfix) with ESMTP id 6B1B820003
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 03:07:37 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=dYdHcERt;
	spf=pass (imf13.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.97 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773976057;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+pDqs44dkcjEkb8OYJpU6L+/Zb+sncdVx4zheks3ZXc=;
	b=Wk9sAkCKsjgksXAa/yLtvE63skkudfI/bjf2xCXQFUDjNEw/4G65TKxMHOrr1EVD7YaokG
	NSNWcMcFW0SEB8XsyDJzzR8z8rIJdz0/CVvRn/GwrYkRcZTEeJar3iva8tl3pYkAeKKu83
	qKPwE9Gg3qc55kRcgJmsxtK/a5ELYxs=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=dYdHcERt;
	spf=pass (imf13.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.97 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773976057; a=rsa-sha256;
	cv=none;
	b=YFaMOPTwOwGBpeKMJP5OE0IluaKhAMk7Aqyr7yj5y0sxNjzijsSLk8XwCVGVH6RjnHxHHi
	C2wreN4Wu2upWX5Sh11GY6n0czH7RbxXaXBgmwUdXiB61P3dcIYe6RZtkyXzrwMc6BMPbx
	WN+N/YeTc8hmdtOz/X7j2Dri3kFUXbU=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1773976054; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=+pDqs44dkcjEkb8OYJpU6L+/Zb+sncdVx4zheks3ZXc=;
	b=dYdHcERtYFyNDTA3+ZaSb0zhkINX++RF9JvBq39XHaTNKskbmntrB+vn38Plh0CJQ8M4rRNKMZ8wdWyajdB5G+jU77GwrnxHIAMTd7kNfr8ufDsZvm+VguuMIqoNLfEFry+kJX3yvWIW2gm66Tb8R7NKdA0PXdrRnjwoEZqzxl0=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R101e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033045098064;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=17;SR=0;TI=SMTPD_---0X.K9XTI_1773976052;
Received: from 30.74.144.136(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0X.K9XTI_1773976052 cluster:ay36)
          by smtp.aliyun-inc.com;
          Fri, 20 Mar 2026 11:07:33 +0800
Message-ID: <2ff1b860-ff76-48e6-98c5-28e517afd3f8@linux.alibaba.com>
Date: Fri, 20 Mar 2026 11:07:32 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 3/6] mm: change to return bool for
 pmdp_test_and_clear_young()
To: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
Cc: akpm@linux-foundation.org, david@kernel.org, Liam.Howlett@oracle.com,
 vbabka@kernel.org, rppt@kernel.org, surenb@google.com, mhocko@suse.com,
 linux-arm-kernel@lists.infradead.org, x86@kernel.org,
 linux-parisc@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
 linux-riscv@lists.infradead.org, linux-s390@vger.kernel.org,
 kvm@vger.kernel.org, open <linux-mm@kvack.org>, linux-kernel@vger.kernel.org
References: <cover.1773890510.git.baolin.wang@linux.alibaba.com>
 <8025b898d0841a4bcbd766998959b4e2ae4d4abc.1773890510.git.baolin.wang@linux.alibaba.com>
 <4cf8eac4-f601-4f39-8094-d904edbf454d@lucifer.local>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <4cf8eac4-f601-4f39-8094-d904edbf454d@lucifer.local>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 6B1B820003
X-Rspamd-Server: rspam08
X-Stat-Signature: ihjsrq58a3yyafqnasoajhxdejidbfw7
X-HE-Tag: 1773976057-168600
X-HE-Meta: U2FsdGVkX18wZNIeZd0lx7x7ISynpciFSOOdO5sn49DwqgdwJzVsdcAm6vsrYhdokrMm7I7ugK8JlUQy4n2vXA9xBETcHH+Q6d9pjmoIxdWqiWbOJ+JtMKz9GDbfxZFhnWbpqLG7pSFeQcTJzHYXTwDC+Mp/zcVBtpk93Tmi2bbycdTRGR6Lq0UQkmcndH6BrbZ0s6dt5RmDr/vqCnd32mm/TvsXPvieSh00absWYqhxHccCThzhKD2etTFujMT8Mf+nwbPTUI+IZs3huP5hHojyYlxwQ04RGZO6Yc/XWKd2tNZSg2beVtEs98HI2TAf/lXaT8xCIlX4POtjTX8LEPsQkXD18Ae0xYNUC+Mr/ctQKCefQqrgDsz14yC67XRwZKStjYnNJ5CGysrAq1EIXYXGDajU+fsAIaTzUF2aeUSYSfeMXxzJz3bIQlMkq0Ic7rIaDzy3NBKx52G/TytTshb8mqStFwrdj0CysrljOEWdFAE7W6f+XieuCHlxjtn5pm3D02sCTQETlWVkxJ1FlreEXzlqsnfkqvZoFkwFtl4sam//pcE4RcLqhJLv9+xIPs8ZJkWBUoGrWJXWZ/xp7rzwoWJC5WcrXxs48asZzOgH/pZlw0nay6JhwL7OlkFhUR2dhaI3Q72SEjHpbXzNoZQBKHNE0qWQaamlop75IjMk7pmY2aR0oNB6lUvJaAf/Ui7hfhEZCc9hhiNTSWaGaE877/U6Dwc3+rnKSvsj/CLBtlxUQ+nbYmKpl8GrXiGkNfBAGA1H1GEK/NRxLf7yqywaJBpxg25b27dHIUy07bm4bTEVzIUlLWYIDXf4iDrlwNXta9Qfspeufv2jFUoXjOErXmodEbe1PIJZ98XIm42iug8gSQ1mncTpIEHn528+8MyesCEmT5bYNmsjVSPZps38Q5lrCAh0dO0e+1taX/Cb40QqNJk6JP8xQkKh24sCTuLJrkFM4ZP4WJ+f+4L
 O2XOIn6h
 pxApVxQ8mzkN3a5kT0ts3L2BM+dIEPTy6OI5SnX7mLpeRzFdk6jbg9XSo0/ykl2Vm2XDpQrVpPIx0OuvG9IdodYGzKOFGjQqz8TbaKTjnneBxieSr0z9kCQ3+JqyqYMPUTiFDVGERzlwv19fpBFuOC7x0E7tvwM5rNgK5APn2XgGEtttx3nJkSFmhEpsmH2+EMu+A23TqBjob8GmTOg+Pqfpb+Z3jgLJ/WmiTJl696vUmI2uZ7TarURv8EI02FFeyc0jIbUkvOXxSNyGN2l7yadcmyPB4OGImmpNhC5DWATSFg/9bs9QKukpmo/2GVDYQfyXHmV2wSPGVjqh9FjZnrYw9SElYxo5hV1vaGvbu9q++y7v9cAsR9aNCkxpZzfst2gJiuXNX8IvLe34GEP0arykIxg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 3/19/26 7:31 PM, Lorenzo Stoakes (Oracle) wrote:
> On Thu, Mar 19, 2026 at 11:24:02AM +0800, Baolin Wang wrote:
>> Callers use pmdp_test_and_clear_young() to clear the young flag and check
>> whether it was set for this PMD entry. Change the return type to bool to
>> make the intention clearer.
>>
>> Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
> 
> Some nits similar to before, otherwise LGTM so:
> 
> Reviewed-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>

Thanks. And all comments acked.


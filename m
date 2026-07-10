Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C4C08C43458
	for <linux-mm@archiver.kernel.org>; Fri, 10 Jul 2026 07:29:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A57106B0088; Fri, 10 Jul 2026 03:29:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9E0826B008A; Fri, 10 Jul 2026 03:29:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8AB206B008C; Fri, 10 Jul 2026 03:29:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 5CA6A6B0088
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 03:29:15 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id C9EB2A0352
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 07:29:14 +0000 (UTC)
X-FDA: 84972041028.11.7868FA6
Received: from out30-97.freemail.mail.aliyun.com (out30-97.freemail.mail.aliyun.com [115.124.30.97])
	by imf22.hostedemail.com (Postfix) with ESMTP id E4942C0004
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 07:29:10 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=HXUM95L2;
	spf=pass (imf22.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.97 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783668553;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6R0ZXUQFUwfZgH3nG+djP9eJT2Fdh4nBXbLmCtqMTsk=;
	b=Lt9cBNt+CGPHqkJ0Sw8+o4XR9jznbpl+z/Derlx0lBuXDqRUmkFNKM7npg0t6Bl42oA1mX
	E7bAX3teXtyFWYSrGoP7uHyGniSUmeVbTauCAQj8dVBuuNjSwS/DgfFPdc5zhmE94h/l9P
	bhb61GFuIv/cNro97UCtqtX9jewjQoY=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=HXUM95L2;
	spf=pass (imf22.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.97 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783668553;
	b=HPIsG+LdOOAjj0tXC9wc/jIHSNoc7glKqb0QEolxg8SYq01A7b9JYF5jtOQbCcIeyC0wJU
	eRQqvuq1aFjkf1xydGUcNRt/P3Urtn9GR4ZoS3KG7JvOGqi++Y79KDhJGYuPenqfcBtjHE
	R4RTg76E8Ox4Yx3/jYdQmQDutTQ83lg=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1783668548; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=6R0ZXUQFUwfZgH3nG+djP9eJT2Fdh4nBXbLmCtqMTsk=;
	b=HXUM95L22Fy8Jdp1/Aq3u8RHZB1TcbUJZ6vM/XEd8hLRIU70FmkAKbUnm3TgW3t0KWYCy8Z7jhV3NNgljiwdD4BKVz+jhmFpa0g1lyuAua7i+uL0E3N5BJWNi3FdLYGLH7fHBsTXy3yRlHa7qiZ7sIi7WkiFOYtgSmqxpAynuIE=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R881e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037009110;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=20;SR=0;TI=SMTPD_---0X6mtZXo_1783668542;
Received: from 30.74.144.121(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0X6mtZXo_1783668542 cluster:ay36)
          by smtp.aliyun-inc.com;
          Fri, 10 Jul 2026 15:29:03 +0800
Message-ID: <037ba54e-d947-4b61-9fa4-961d14f87a43@linux.alibaba.com>
Date: Fri, 10 Jul 2026 15:29:01 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/8] mm/khugepaged: refactor per-scan state clearing into
 collapse_control_init_scan()
To: Usama Arif <usama.arif@linux.dev>, Nico Pache <npache@redhat.com>
Cc: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 Zi Yan <ziy@nvidia.com>, "Liam R. Howlett" <liam@infradead.org>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>
References: <20260706170755.3387204-1-usama.arif@linux.dev>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <20260706170755.3387204-1-usama.arif@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: xg4tbqxpg5mrie8k6abs1js8ac5a1toc
X-Rspamd-Queue-Id: E4942C0004
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1783668550-587694
X-HE-Meta: U2FsdGVkX1/xDHR7FQ52RMsQvkewJhnKSIGxPZMyq7uZqyF7ScJMx5hQLnNzoRZfVTQY5IozbYrRW3hdNHpA9xKjJaKFQk8jOt/szazq6tXP0wMYWdj1VEUUsMdMJ5lFziaqsolOQaFAbUFcV+oDWXULkW7XY1/taYW7O1QUKfbup674EQp9VZtZvbjA3ZjS0CCLcqoQ08b89f6FQ5p6IpKTOb3jwx6/25Oh+eP2lhexvp7rg1w/4ITxGOd9PI/3UnQZ3txGw25GuktKeEjDQHY3/Uti9ArvWEtlKz7nsLECN3z0awURIhqm3VnX/+Tje4a34V0ZANBNRBRgTpLkpReSUnbUHV3QMkdOV5ILwYE9v4BALKj68ydYhiwIOQ+EM65oKgYSP2T0+PM7SbqEbDQZh3CLawsfTh8nh8ZBPy6llsFkkpJCwM7RTrMd3AzzfoHYqHqWDpz9R+h0W24lf3hkkq2v3XGHwffEBUY4JuWak3RvWi90Nk+Cg14UtUSJHVmGWPDkePnOCOsSgwENgGtIILhu3yfr/s/Y2E03LvGCiANiP2GDvOifcszJzoJhpvGMHOrZ4Z9e8Ask4QLi4Ig6nKF1dU0kvL1qAqTMgZjvLCD7qjgJK9FVMTceTLKB3SjWjYKGocT4wnVfJMEJxN+EA+qziO1hp4QTIhQ4x0boiHXWYjQjzhwlfyISu1HMdDBC8AQ7sK5APRFuYe6zVxpTKtV93JpIlA8svAQHzft28853pVOZ2e8HvHsYR8kErz60CncXkOahb1r1HUf7dnkjp+ILqtL37CmRFDWha2aFSIousju9eL9Fne7KHkiVgRjvXjFFmDJBq1AbhL4rKpPv3p4R+gDWqEDx5G/arRaF0VvlY9mo/ea1366XexLTdhhiKuoMHuE3w01z2qt8m4q/nJdRxuYcIB+tbewZfSWMP/BsTkpZYhWhK8l5gdeauABWejl1wA7Kf3KN+Wv
 Ei8/fnqh
 Zi8wAPPaMGaWqKbayZIlKhsJxRoasqTqavo+fY0otda9XK7AEjoP1Hw+SmkrC8O7UPdAxkFn71sX6tPvQzdRZ1oPkRFr55qTlPuZQQaBMic1W3j7AS8exP1o52uefF2otWpCwAJSFzXCSPWDa5J8Om+TtfEzD+SANq514lLFt8rxDu7eM+6w/ImRYG9Oo5qIqZ9K4ULQAg5TmSrZ47eiRLIHH//r0jaY8YC2LO2sWpa6ue77HKitwLPlI344PNOBz7gVHaUQfPIq/lD1/5lop8HU7XGkAO2uXDGdRW5lB6DM4rehnZZzrykFSkQfoHpnKoVZQi4KP27WoHmySF+4XcKgUSvqMYCy/ZtB5Q9E+9iLPrgDJi7Aty5FoOQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 7/7/26 1:07 AM, Usama Arif wrote:
> On Mon,  6 Jul 2026 09:44:48 -0600 Nico Pache <npache@redhat.com> wrote:
> 
>> Extract the repeated clearing of node_load, alloc_nmask, and
>> mthp_present_ptes into a helper to reduce duplication in
>> collapse_scan_pmd() and collapse_scan_file(). Althought file scans do not
>> current use the bitmap, they will in the future, and clearing it now is
>> harmless.
>>
>> Signed-off-by: Nico Pache <npache@redhat.com>
>> ---
>>   mm/khugepaged.c | 18 +++++++++++++-----
>>   1 file changed, 13 insertions(+), 5 deletions(-)
>>
>> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
>> index 617bca76db49..b3985b854e77 100644
>> --- a/mm/khugepaged.c
>> +++ b/mm/khugepaged.c
>> @@ -628,6 +628,17 @@ void __khugepaged_exit(struct mm_struct *mm)
>>   	}
>>   }
>>   
>> +/*
>> + * collapse_control_init_scan() - initialize/reset collapse_control variables
>> + * that require being cleared once per-scan.
>> + */
> 
> Probably don't need the above comment, but apart from that

Agree. The code is self-explanatory.

Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>


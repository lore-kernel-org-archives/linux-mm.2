Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C24E6CD98CC
	for <linux-mm@archiver.kernel.org>; Thu, 11 Jun 2026 12:11:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 25B396B0005; Thu, 11 Jun 2026 08:11:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 232C26B0088; Thu, 11 Jun 2026 08:11:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1703F6B0092; Thu, 11 Jun 2026 08:11:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 085BD6B0005
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 08:11:20 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id AECEE8F825
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 12:11:19 +0000 (UTC)
X-FDA: 84867516678.23.0901918
Received: from out30-133.freemail.mail.aliyun.com (out30-133.freemail.mail.aliyun.com [115.124.30.133])
	by imf29.hostedemail.com (Postfix) with ESMTP id 1629012000E
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 12:11:15 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=kXDbOG7k;
	spf=pass (imf29.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.133 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781179878;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+gAUjXbMGZfUSgaQOzcFV/0TYnRK9QhUgm1Vyadp9F0=;
	b=DNBquQE5GAvKpCyuZApqd9I4IHVAgdoU5sknIPl708P6U7LiRePc0e/c0+2QYEXIkw2iH5
	bzaAd8Yz2RpybCk1APCyyzYz9QlauHyUcOB6xW+aoc2EBN5s19+cdNOXpbeH4Tp2ADL5Q6
	wk/Kgt0oR4oRkKKainorC3wpxE2auOE=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=kXDbOG7k;
	spf=pass (imf29.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.133 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781179878;
	b=KNNxDRfT0M2yPj7akzJUJm7VjmZJL5PB25rB9L6ygp9d+BFET88Fe/3JMY8qaSqHRGpCUp
	Bd22vHp9phJo+BXf1OLjqM2FER9HOiPHBXA+jN+tnacfme/YFcHc5YtPDBeazz1XUp5O7U
	dG+ok8p6DWs14OFSWzu/YxBPlnsNQno=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1781179871; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=+gAUjXbMGZfUSgaQOzcFV/0TYnRK9QhUgm1Vyadp9F0=;
	b=kXDbOG7kfp1OHS5IEnU9JGyRWxO0Vtrd8QsQVnEdPDr2MU/IQT4ng+q5DX+ycnAHZy5CAXZDHyLhTFNdKuJUhkOZZ5wppdD0tkUnEzbkqzMWhF6J2llbSzpvWJMZdlm0W3HpJ3pFRk/uHqx0Hu7IsIy2nIIArK1aNfeOTd/lbVE=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R121e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037033178;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=15;SR=0;TI=SMTPD_---0X4dcBhE_1781179868;
Received: from 30.120.38.205(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0X4dcBhE_1781179868 cluster:ay36)
          by smtp.aliyun-inc.com;
          Thu, 11 Jun 2026 20:11:09 +0800
Message-ID: <b8536502-b227-4f7a-b82e-82204f2c0e4c@linux.alibaba.com>
Date: Thu, 11 Jun 2026 20:11:08 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v2 04/11] mm: khugepaged: add shmem mTHP collapse
 support
To: Lance Yang <lance.yang@linux.dev>
Cc: akpm@linux-foundation.org, david@kernel.org, ljs@kernel.org,
 hughd@google.com, willy@infradead.org, ziy@nvidia.com, liam@infradead.org,
 npache@redhat.com, ryan.roberts@arm.com, dev.jain@arm.com,
 baohua@kernel.org, linux-mm@kvack.org, linux-kselftest@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <3895c09794739bbfae99d9e021ffacf8a51fb8e2.1781083630.git.baolin.wang@linux.alibaba.com>
 <20260611060619.94738-1-lance.yang@linux.dev>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <20260611060619.94738-1-lance.yang@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 1629012000E
X-Stat-Signature: fsqwd5af5cekz66aei5yssmq7nzw1p45
X-Rspam-User: 
X-HE-Tag: 1781179875-750017
X-HE-Meta: U2FsdGVkX1/0OHoTiYxkvfcIJxH+DMzH7wtlpHv5QeFGMzGaQ9GUXNM1kcFZJEOVu2gS5i1ue2+YZGMtWKJKATJbGsylrCJB2XqV17aalzrbpe2bKhU9wsFJhJdi2HTvQpKLfLYOsOEtqwalXH2ZLkvtIZH1Apr+w+sEgg7z6eHBTuco447ETMER9WTKZh6NjAwEMZp+58CvR+QtTMxszSARR4I1V810eVLuVIbcp04TLWk3RoGsbRsIfWzsqZTONf3DYcT/4uLDSjqKunUxj9uZ5ciJHBfzJey4tP9g/sDTWsINta59gf+DkvSZAEvhOnLTxJmBmzj/VA6D89FZuUqK6ZFHQvWfqM/wIk969GkJlHz9CNy42/RdWnCL0U4KSGylXF4rUlgReU3/BhwKS++hlI78zhsk9pHJMdHxaq0TMgF2X2nkce2DkI256ZI2GnqKH3MRQDk3wZwKhuZuySmMByjqvcT6u2Y+nBaAguPYnOJKGMfWfk3tqMypxBFcyF8p0FP21G3ZwCfywLipc2hIUc/BDgygtqdnwd6+S1UDpaXXFPmGU0ZZhEw7e/E0Fln/ICVGlN+oKCTQIF59DATRTMegePJgqOmV+XqBztX5JqkHxzXQyrEEbd092FkW/D8RP6GHy+IW6YBbIIHkkA+Wfp3m5J205/4BjE2IjIAZ3sCB/BIZNCpPhy8jBk40ENX51rZxr7iUzxt7PDLQoXMCYGid65TWg6Q4Eob6uy0BWQkB7CpUwkTdmK+/I6cfuX+zKfNr/UWg0uCGhAUoSrf0oW65JWMwyhSi2F5ZzuoAijiilCjW8NW466fRyX7Z4O194fTMn9LnfeZ7ewLS0DX7gOTZ+eLwFTsiglubXiLbdi3QDhs6ezA5fVwWifCHdrOycsKTbn19mr/+YAKbxUE+aMVBkOj8g0kALqwyPaFlcYh/6H/xQiXgCqvVXklF5dA/qBeQypsHOfsFVgO
 l/XahN4Z
 HR/hldhqqR6lEFJS9v32aP6pZDODCfWkSdYRBzbYtU1D1iqmXtz7/Pdz0kZg7T2DL2VvBNkx2zEi/JzDbgJ95TiZmejT7s2MkATYeQJk8/cYOMX07EmvSzGq70zqxPkWsXBhPnqLa5TMDoL5fn/hbRzdb+nxPoJ/SxYZ11Rx+9jBOPE1Tkkqj4MXDxURk8eewLfGYleU9c+CqakM6qgnjbRWjsiKp68givyYoIbVOZr4pdPUktJ1ymvBePb83K7gtVirKgDh8gVidNtZ/2zGTcq9lD0sBstVz50UxRQVVvu24rn5ZHN4c4lB8aS95NmM2lF3mFrt3hrpJLZEvAVtdwmS9dH9QYLjHGSZUfdXBEp3Pi5Y=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 6/11/26 2:06 PM, Lance Yang wrote:
> 
> On Wed, Jun 10, 2026 at 06:29:12PM +0800, Baolin Wang wrote:
> [...]
>> @@ -2768,15 +2827,23 @@ static enum scan_result collapse_scan_file(struct mm_struct *mm,
>> 	else
>> 		cc->progress += HPAGE_PMD_NR;
>>
>> -	if (result == SCAN_SUCCEED) {
>> -		if (present < HPAGE_PMD_NR - max_ptes_none) {
>> -			result = SCAN_EXCEED_NONE_PTE;
>> -			count_vm_event(THP_SCAN_EXCEED_NONE_PTE);
>> -		} else {
>> -			result = collapse_file(mm, addr, file, start, cc, HPAGE_PMD_ORDER);
>> -		}
>> +	if (result != SCAN_SUCCEED)
>> +		goto out;
>> +
>> +	if (present < HPAGE_PMD_NR - max_ptes_none) {
>> +		result = SCAN_EXCEED_NONE_PTE;
>> +		count_vm_event(THP_SCAN_EXCEED_NONE_PTE);
>> +		count_mthp_stat(HPAGE_PMD_ORDER,
>> +				MTHP_STAT_COLLAPSE_EXCEED_NONE);
>> +		goto out;
>> 	}
>>
>> +	result = mthp_collapse(mm, file, start, addr, 0, 0, cc, enabled_orders);
> 
> Feels like the second 0 wants to be "swap", no?

It seems so. This reminds me of the issue you’re trying to fix in [1].

[1] https://lore.kernel.org/all/20260609120443.71864-1-lance.yang@linux.dev/


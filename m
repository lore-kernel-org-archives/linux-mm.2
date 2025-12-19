Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4FD84D711CC
	for <linux-mm@archiver.kernel.org>; Fri, 19 Dec 2025 01:42:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B55E96B0088; Thu, 18 Dec 2025 20:42:29 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AD9A06B0099; Thu, 18 Dec 2025 20:42:29 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9E5286B009B; Thu, 18 Dec 2025 20:42:29 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 8D5E66B0088
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 20:42:29 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 3F4AEB8A15
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 01:42:29 +0000 (UTC)
X-FDA: 84234520818.22.6484857
Received: from out30-111.freemail.mail.aliyun.com (out30-111.freemail.mail.aliyun.com [115.124.30.111])
	by imf09.hostedemail.com (Postfix) with ESMTP id A303D140005
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 01:42:25 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=TVwXy+6C;
	spf=pass (imf09.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.111 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766108547;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ErxvyipvL98VqcIt+BEu7/k5SVUdoeQoBQCwgW4JgEA=;
	b=HDebDNxRnFaAar/XgiYGAdhYa3kW9TWHlKm2e+xBGSg7L3nXBNzpOhcFyKEopL806uvyNr
	ApLJsLItO88b+mAAef2H81PCMgzwh2t1JSr9w0lHNN9MvQgHWrcbxiqRsJ2fSs6Ku9E3OT
	XaDWPjv0q36QpsOREwFTKuXMmb31/w8=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=TVwXy+6C;
	spf=pass (imf09.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.111 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766108547; a=rsa-sha256;
	cv=none;
	b=5IzOcPRPZdxdBrqC+t5MzP+rcHlZAXghz2z+MZ4/2Pau0pw+BhUYsT+7sNoELzMbI5/GjP
	zqaJa2430mycQLhG0JawSJoEfoZjY54nHDDR3GpjI5UpCC5/UZTOPHIiaqrhUWJNLS+Jhe
	z8xZTnLMC20lWpLostyeaRZY7lBowtY=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1766108542; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=ErxvyipvL98VqcIt+BEu7/k5SVUdoeQoBQCwgW4JgEA=;
	b=TVwXy+6C92zjCK1DHhzXNOgPRW/PWgjPnMEBgzCPqjbLql1mocfHozzfWiiR+IqCkwQfGDtrLs0qj3NY4fFdhNaMMnC4Aq6eHzsVstZ/agG6zQz0DysmjA9dF8FxpvtnPj8k2wywDTG0xtnRN+AuyxyoH5DNxI36vSHLo1aQZGU=
Received: from 30.74.144.116(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0WvAfIbP_1766108540 cluster:ay36)
          by smtp.aliyun-inc.com;
          Fri, 19 Dec 2025 09:42:21 +0800
Message-ID: <f0c962cf-20db-4ca8-897c-b64a5976bb89@linux.alibaba.com>
Date: Fri, 19 Dec 2025 09:42:20 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm: Consider non-anon swap cache folios in
 folio_expected_ref_count()
To: Wei Yang <richard.weiyang@gmail.com>,
 "David Hildenbrand (Red Hat)" <david@kernel.org>
Cc: Zi Yan <ziy@nvidia.com>, Bijan Tabatabai <bijan311@gmail.com>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
 lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, vbabka@suse.cz,
 rppt@kernel.org, surenb@google.com, mhocko@suse.com, shivankg@amd.com,
 Hugh Dickins <hughd@google.com>, Chris Li <chrisl@kernel.org>,
 Kairui Song <kasong@tencent.com>
References: <20251216200727.2360228-1-bijan311@gmail.com>
 <6b4cadb2-6246-48cc-9c76-64ba0a23198b@kernel.org>
 <0C218C18-916B-4BB0-8B37-AC82503E4AD9@nvidia.com>
 <a47adffe-b2c6-4d86-a970-b31c2e620146@kernel.org>
 <20251219002134.uqgtnr43zz7vvvtd@master>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <20251219002134.uqgtnr43zz7vvvtd@master>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam02
X-Stat-Signature: zpkdjwjn5f8acxtbp1y9dfrazoxe75ww
X-Rspam-User: 
X-Rspamd-Queue-Id: A303D140005
X-HE-Tag: 1766108545-303593
X-HE-Meta: U2FsdGVkX1+qtmJWnxGHhF304oSuDKaIGsQdJSTNwG29A8jqBN7knvfi7JnYF1b0ctJy9k3XZ9s3E/Wu7rdr65oE5QBNt86lgRiqlfD+fZI0bTmKAER3eSzf8mivQ5VX78ZTVtPUbqqsyHjFSEVrEGBIU8Cnc89FCD8lUx+vEJypRNtmg1lw3s3H7c4f45nLzLakgv5b3LGVgxsb9QiEH4o+gcPPtk6bVNoFGNujzoEcg3UkdMXm2W6FRYeTANh+JqZw0bqBmYYV0Fc45Kffnqhg3qQ32SsCvezF0B46G35U2OPGwjI5iBX83ePgeGFksvAmPfwtsXQ6fxYVR2LIXWM6tkehsRSIM6ZduRre5vZVVfaH1pDT3SsspJaT1elC2HeD8YFhlni0Mc0Gnq95nVRiH0XbCfxSD5+UoysBKkx4fyCb+yvvVFotfAVnDvzVEyKOjJd/afvYWrKr4IYULES8KtOlgSTTbeDZjs2p/7eMWJBw/3ZQXh8np4iXkc3n+GFV3JAoQalPCQypprcwjOZdFzBAPAQMaCuH5KkoEs3iOKbpAbGK2EbmPavqVhxR6g+uZJ0U8toZrQ6oSaNlZ8I6elGsXcHXKtLtYiUmtzTgRTnSoi7RLgvdCzIyHYlmIsX5+2S60EUJXCEFLAGMxx2d3ztfNCpf1amxzCGkV6cHbf+Tc4ptwyQbwHeCcQDS3kxpaKUiH2u7fGcgAz+UL18vYud7hvgAcVUOboNk04dT6v+ok7mc0II4dZsktqAEulH2dWYe3XZuW0oLiYXkGpHZOLDANnkYw6j4C5xUAikk6XeLin3DCiQXxa4ybfukszNODhTsKjWlpmt0unGQVKohbrNMAszKe4xsnP5cAbjoQOtYCyNcWayxJ2wC5dRKHmFO5+/jGWWcmPQ4JH+lxg+UtN2OxV8vIwpWQwVcADGt9ksIcy1RWrW2LGuWbr8BQ8cu2EqyzIU8KXdFcgz
 bGwG4+Se
 tj3pmQXI5Eb1pMUBh9kMHLBxuI6IqfGVUO9/xZG5A688hBJ48Ux5wKWnla2GQbQc7BVInU4j1dkOIxLllbXbtDjFiFhm7qSjuubN05aqOUkNKIgsn+zMiiPnZXxggIdQKM39JgrDEOexZ1jbEWYUvjVE/obsbbQPCIt0edFLZj54cpyJ24ZBJmGMftVHEfzvMckuqDCHdv3Mt+lC7G6WyMSdyqVgtHWAlQqxn9eZpT4cQfdPK5dNuUoiMBPiDuiGL0WtRgT6FCbcPLvyzyWfvzJbfHcZlTuyc2/wuPk5Bo7dYSpf1wwBO9hl9oP+zB5Xw3ceFR3KJqAFS5WfBOWUdZKRAVBzeiqgHC99HgZC8PdwS/928CbE4YK2FI+bBoU1WoY+r+tyZuhwpQlapVN/DOUeLK70pR6j6To6udzBEQMs5rmzbm6G8RkthqQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2025/12/19 08:21, Wei Yang wrote:
> On Wed, Dec 17, 2025 at 02:04:16AM +0100, David Hildenbrand (Red Hat) wrote:
>>>>>
>>>>> I am not very familiar with the memory hot-(un)plug or swapping code, so
>>>>> I am not 100% certain if this patch actually solves the root of the
>>>>> problem. I believe the issue is from shmem folios, in which case I believe
>>>>> this patch is correct. However, I couldn't think of an easy way to confirm
>>>>> that the affected folios were from shmem. I guess it could be possible that
>>>>> the root cause could be from some bug where some anonymous pages do not
>>>>> return true to folio_test_anon(). I don't think that's the case, but
>>>>> figured the MM maintainers would have a better idea of what's going on.
>>>
>>> I am not sure about if shmem in swapcache causes the issue, since
>>> the above setup does not involve shmem. +Baolin and Hugh for some insight.
>>
>> We might just push out another unrelated shmem page to swap as we create
>> memory pressure in the system I think.
>>
> 
> One trivial question: currently we only put anon/shmem folio in swapcache,
> right?

AFAICT, Yes (note a special case for anonymous folios: lazyfree 
anonymous folios will be directly freed instead of being swapped out).


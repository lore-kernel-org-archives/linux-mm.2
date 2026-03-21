Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 23AB5108B8FF
	for <linux-mm@archiver.kernel.org>; Sat, 21 Mar 2026 05:40:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 644306B0005; Sat, 21 Mar 2026 01:40:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5F51A6B008C; Sat, 21 Mar 2026 01:40:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 50ABB6B0092; Sat, 21 Mar 2026 01:40:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 403146B0005
	for <linux-mm@kvack.org>; Sat, 21 Mar 2026 01:40:09 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id CE7CF58AAF
	for <linux-mm@kvack.org>; Sat, 21 Mar 2026 05:40:08 +0000 (UTC)
X-FDA: 84568969296.08.4E02F83
Received: from out30-98.freemail.mail.aliyun.com (out30-98.freemail.mail.aliyun.com [115.124.30.98])
	by imf09.hostedemail.com (Postfix) with ESMTP id 8CC4A140002
	for <linux-mm@kvack.org>; Sat, 21 Mar 2026 05:40:06 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=Ds33Nbg7;
	spf=pass (imf09.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.98 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774071607;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nAl2y/5MAUG2YMDa8VDO7zg9tHL26pM8p/zvJD5tRkY=;
	b=pdjlfxLxCEPJOTGL+N2ajBQV0Gv56ppE1GmlWi6LiwL4V5FsEI5YxRZy5zeEYOKHYWfKNf
	3qq+e1ZHIns5cF9fj09s62j4ygAB1oexHmFDA9kIhV15ShMqZuM1Mo/z9yNPmfcPl7UlHV
	czKGXcYIcQPz+agnn7RuS8GJbRFgPYs=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774071607; a=rsa-sha256;
	cv=none;
	b=g3OULOEw5o/QDzq8nou9UyFWs2YZYQa78XSAVR0UzRs7BzmR0YssJ8B4Qbm9jqZZTP7BOd
	HYppieHOmak9YzlFIIRP/0a347ab17+kRkeOshGWmWMT3L7JRJ6J6FiceB7JUM9Ivq0OWq
	dNFaXRv9fx+Vh0DsT/1WzWTcibpu7vQ=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=Ds33Nbg7;
	spf=pass (imf09.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.98 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1774071601; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=nAl2y/5MAUG2YMDa8VDO7zg9tHL26pM8p/zvJD5tRkY=;
	b=Ds33Nbg7Lmu5tZVg//jLuXwVzy185iuQ+lzzhsBQHv1tBe2De7IdrYkDTCO+8jshqTu4CrSZ9e5uW9WvMeRsRvwLxSm7D6e8gmWvG/MHtUikINm/1u7yR8Pa9E7ksxnyRnQlggHuR4nMY68q/YrUfuUkeF56vL7M+6RoOzqjORU=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R101e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033045133197;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=17;SR=0;TI=SMTPD_---0X.O0qYc_1774071599;
Received: from 30.42.98.36(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0X.O0qYc_1774071599 cluster:ay36)
          by smtp.aliyun-inc.com;
          Sat, 21 Mar 2026 13:40:00 +0800
Message-ID: <55ce039b-ea89-4677-9b07-d556145cc512@linux.alibaba.com>
Date: Sat, 21 Mar 2026 13:39:58 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 07/13] mm/huge_memory: deduplicate zap deposited table
 call
To: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@kernel.org>, Zi Yan <ziy@nvidia.com>,
 "Liam R . Howlett" <Liam.Howlett@oracle.com>, Nico Pache
 <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
 Lance Yang <lance.yang@linux.dev>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Kiryl Shutsemau <kas@kernel.org>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <cover.1774029655.git.ljs@kernel.org>
 <71f576a1fbcd27a86322d12caa937bcdacf75407.1774029655.git.ljs@kernel.org>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <71f576a1fbcd27a86322d12caa937bcdacf75407.1774029655.git.ljs@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 8CC4A140002
X-Stat-Signature: hs7qjemqxyo43naoaq1d4y8ttzcmwxkh
X-HE-Tag: 1774071606-150626
X-HE-Meta: U2FsdGVkX18qtZDu3v9eOSjEpn5SDhpuM0Gt9JJPs5mKYc7xuKDDVshcNRenH33a2N94LCc5oKC0ePgA8TOGIUXw+YTLhGNfxIPNlLYBpuy8xwwJUBgxZ+/ax/3bqTpHOy3G0qi+PDk3MYvg1rjNvgjQEFitvlTw4ST6nbE44GxZlLNi/FeG+kQcMTGrSrYNbVpyLXR4jKYV5gw56kY0NvDMlGmGhJS5KaiM7CP41qTuXBqwBGZknq06XfEfM/MQcbQWLLjd9qzfq0NvUbr6qZLWw4aPm0/kJi345Z+dIcMgD2LPJZHk0I5gtIIb45LOekmAAivg7JU60dp3DTyfd+MQ5vbx7GJz9yuK3+r+Amjoxw1E0hPBKgD4kdRK5kztwB8rTZmttLMhIOCQku4PEZldP8V1y3LrcPruI4gzWWRApUBoL8M3SUlUrDoVXEjgIQQNq3hyvd9MU/QFCCUSoMfaOdC+wVnr8I6dvR9MYB6305Tjt1Rloa8DfeEgwVyqXy2TQk6yONBPdSQIMtzX4mbgDeHJiygUO7ffeqgvAconSeh1/H9DefNywLpL4jWq30gkNTenGNBc7JHrnhs9xE7yloqMCBG1MsE6N1nKQFvQqLnxZm8kvDZrb6YPqs4KwHGOq1iyJMTBveg5tb4QgVYv8/zsVV6P5/jXrmcbsfGROkJYeyVpHmFy5vUG1L4LCQ9M73pSd6Ji58iz7j3Dl2w/dsoPoAf1qCkE9cilymhyZ7SleJJMTgtas+gJ8hDbmh29n9+uvE99kt3mKkpAC3f1RwgV4WwD4rL5xDnoYIquzr48DHIzpu+chlBE1tu/VWPol+tMADIWRaoZtiJ2Scg/C8LJyrWtVhTNTYTlhnhY8E/RlSvmcb/AXvyIpUCRDA3fB5hu8FXQ2i7CB+oAB5plWQ3j7wXngb2N8hLS7YITsC7WDF5eOInWQhjhSJCN5FiaJUjr6KKexPEIWuq
 wk9soBpO
 qMG+14ip7Tvmoyq+DQNhocl4yFDEltoaPfmpPWyFNvUXoWI05AyXhB3sEB4xssejSA3IN8Nta9YwDo9aRkZGeXBlH9weQe13RFA3Vit90lHkMegId1EL/F8505RXIHNsteSEU4+DhLoz2DK4D6vIuFd99SU8r8B4OYROo0iR9Zc+SRmzw4cNhVZVTBJEMchiAd5kKShpMEr9zNhxQgIoJIlgWl9uXRGBTqJJ/d/wcpNT0S1N8hBa4JppPwQ5W4sksT5mob2/SzYFyyEup2NIoknrTg44F/F1aAf+V3ELHBR6HJiVn0NPL3GzaAgJ3gXIkY7Nqsf81hiT19BA8561Hlac63LeCFM7MUNzIfIUS2895Y3HseoJ19Nbeaw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 3/21/26 2:07 AM, Lorenzo Stoakes (Oracle) wrote:
> Rather than having separate logic for each case determining whether to zap
> the deposited table, simply track this via a boolean.
> 
> We default this to whether the architecture requires it, and update it as
> required elsewhere.
> 
> Signed-off-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
> ---

Thanks. The logic is much clearer now.
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>


Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F33F5CD5BBF
	for <linux-mm@archiver.kernel.org>; Mon, 25 May 2026 08:44:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 58D166B008C; Mon, 25 May 2026 04:44:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 564876B0093; Mon, 25 May 2026 04:44:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4A26C6B0095; Mon, 25 May 2026 04:44:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 396F96B008C
	for <linux-mm@kvack.org>; Mon, 25 May 2026 04:44:42 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id F35368A2CB
	for <linux-mm@kvack.org>; Mon, 25 May 2026 08:44:41 +0000 (UTC)
X-FDA: 84805306404.06.0027F75
Received: from out30-101.freemail.mail.aliyun.com (out30-101.freemail.mail.aliyun.com [115.124.30.101])
	by imf08.hostedemail.com (Postfix) with ESMTP id 8EA4716000C
	for <linux-mm@kvack.org>; Mon, 25 May 2026 08:44:39 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=blMSx19k;
	spf=pass (imf08.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.101 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779698680;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8PU4DCnB+MwemnNbQ7J/hgQBpqjXOqzi0eDu1txdPKk=;
	b=0x6xSqtmMvNyEID+mGjSwG7FaKIydfgh/csWA8RAnWHHnkhljuxKTOpnxaAyazrIr4guDn
	2gLrAfvCoAPNcwMVhi1sf4knDiAMNODbsV56ckAJ7DbxAMLRPfxNbld/IqVcdK8zf17Jbo
	GwoYspb02LotdgefH3Be80NT+YXispk=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=blMSx19k;
	spf=pass (imf08.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.101 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779698680; a=rsa-sha256;
	cv=none;
	b=fPYRnheZ1szDlTGuPEKkYv8PAWiIHa8aNaHMFMX1nimA/PcEVexO2CnGiMY2rWM4CpCaaT
	33GX7W8yQaoY9QVCDo0qemetG7CPLC/J1t8C7bd783/sR5DVk9bIQPfyCB8dvsIf24zNG0
	92wm43ldh7imGT3yQVM/A5Ki3Ce2PVw=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1779698675; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=8PU4DCnB+MwemnNbQ7J/hgQBpqjXOqzi0eDu1txdPKk=;
	b=blMSx19k6erh91bt/vjUU4gCbtELoRaVXUe2hjvw/9WDxuaqX/+LH71+/Y+pfr2dK/aGPyz3vpCjcNFkidImt45ZTcJc5oXymsM+LJEJxSO50xAMjqt5bLO8vPUvBE2WoK6B4beBmZNWXkdQX8GoVT6mto0A6jSqFjIwd3b6g88=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R201e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033045098064;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=18;SR=0;TI=SMTPD_---0X3WrO7q_1779698672;
Received: from 30.74.144.135(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0X3WrO7q_1779698672 cluster:ay36)
          by smtp.aliyun-inc.com;
          Mon, 25 May 2026 16:44:33 +0800
Message-ID: <32556db2-c4b3-4e58-88cf-ec0d03ab8791@linux.alibaba.com>
Date: Mon, 25 May 2026 16:44:32 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1 3/5] mm/shmem: make SGP_NOALLOC succeed on hole like
 SGP_READ
To: Chi Zhiling <chizhiling@163.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Cc: Hugh Dickins <hughd@google.com>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 Zi Yan <ziy@nvidia.com>, "Liam R. Howlett" <liam@infradead.org>,
 Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
 Lance Yang <lance.yang@linux.dev>, Chi Zhiling <chizhiling@kylinos.cn>
References: <20260520101538.58745-1-chizhiling@163.com>
 <20260520101538.58745-4-chizhiling@163.com>
 <772f7bcb-eb78-4439-b94b-1a096a01dc51@linux.alibaba.com>
 <87efc5ef-9fef-4cfb-a129-bf8ca373683d@163.com>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <87efc5ef-9fef-4cfb-a129-bf8ca373683d@163.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 8EA4716000C
X-Rspam-User: 
X-Stat-Signature: 7hofm9xa1n84gzppqdtcg74zzgee5wrg
X-HE-Tag: 1779698679-764836
X-HE-Meta: U2FsdGVkX1+MzUCh6b8ZXnbCTAI3jCTlFXOEfoU37NRWlapgAbEnsmPYVaKg7zMAY8F4Z/jF4H3taLKRtqzGcyRhQPTuDRL5tl1b8GtL1+uMnzuqOzMmdCYFP+1+LPoZylWRt6K3bTiEldfcJitUkn3Lj+qn9e49YbPEN6m9ieUF0j1VO/UMty5Qb8fg7tygh4U3LfnZHtkWc0A9jLJhs2ED0BR0rU10bzAoNMvDjsrt6EO+vD17h5G3O9OuPjug0qWJuYx86kgyGjzntBvnxD4+8zsADIqTOGAkjbmMP2raf3Jr993erQHkmG6tahAGBwom0paadA+CQIREhip13RRVsFSJNGCRvaZjxY5qDcHaFdCyjQ/SCmTcECnGf5D5aEFXAPVsfPi1cI3dBJ1o3cJEcFagVVFGHydWpeQZRMkhyg5dIwPiCQ6sUUBUL8Xlk3FYgrhPAK5WuaKGeTTH+uRC3U0xwvWs7annOMxYZijwHVT7WmuEim+Xlyp7eMpDFP4hBTxuv65MpJ6VnPqPmRydQJVWBgozh0Ux+RB8hk+IZDx6xOtyvxQtqdZnNn9Dpnr2BxknWz/gO9aeEVtkztxtZ5elPeDf98jpVteO+gwevLcd92jFBR4Biayw2Lc24dLHBKxPgQ4Q7peFRTkfKUnZxIKIWr7zxTAs2k/+CUiQNjQFd1MHWoHZTCZ0u/hhOdQmvgmu9ZB1975Jsx5SPNqE0U0Mv4rWWrOUIBT2i0OZbyx6JbWdrBYHOqIOEhr4BwnOU11CfNEpghIpPJVYWUv2BomEHHygoQkgy4JgmWje4bfW/FQcp/uLQLQ1wvl3zRXOBpSKRhIt8lHLTE3Il69jbJ5eQQQUE/QbjBRnpjK5VVIx6LWc+ltal+7Ne2The3HyQH0MGdJq+ADOY1Fg8tLNibKbq2KqVIPn6RArbIMZECqLaFMv7VikgtC7MndqfQfoWyxayu8obBknIw6
 0fCw3thA
 4uuKL1wRRXj9l15xCuroq4NMYKv/jO4zvfWDRdvGaFbnAfdomBNupv75j15KmJET6kbedPwAQNlTK0YTzJ0/RljW85+gGTM7Da2JrSjhQpG9NwRxzlSCPDmwGJlEfbZPD3Ltd0Gx8b3sO1R5/J6PH7fJUc0nqxrqrFdpk+Bb/ccdv+snX9tL1QgMT6b3kZ2959+pgLcmwNMI7JeciKmY/TM/FE6E+vnOtH30QjvNOE/0MnB8A9inwVPjCgBJrQ7rJEplUZ508/+Wp8PsD3UmL2DikcJ76MBnvsbyOijVZ4FmsDZDAizDKKyQsNbrLGugth0YiG3qjXh5ALTSZfy4Ta3wyE/ZekWQMhRY9I4Ne3EIpnqgIalFDRo7wjo7m+4YQUF6t
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 5/25/26 4:14 PM, Chi Zhiling wrote:
> On 5/25/26 3:10 PM, Baolin Wang wrote:
>> On 5/20/26 6:15 PM, Chi Zhiling wrote:
>>> From: Chi Zhiling <chizhiling@kylinos.cn>
>>>
>>> Change SGP_NOALLOC to return 0 with NULL folio on hole, matching
>>> SGP_READ behavior. This simplifies the sgp_type handling by unifying
>>> hole semantics across these types.
>>>
>>> Previously, SGP_NOALLOC returned -ENOENT on hole, while SGP_READ
>>> returned 0. This inconsistency required special handling in callers
>>> like khugepaged and userfaultfd.
>>
>> This patch doesn't seem to be a performance optimization, and I'm not 
>> convinced.
> 
> Hi, baolin
> 
> This is not an optimization patch, and it is not related to this patch 
> series either.
> 
>>
>>> After this change:
>>> - khugepaged: behavior unchanged (checks both error and NULL folio)
>>
>> But this adds an extra check to khugepaged, and I'm not sure it's 
>> worth it.
> 
> You are right, I will drop this patch in v2.
> 
>>
>>> - userfaultfd: behavior unchanged (both -ENOENT and NULL are converted
>>>    to -EFAULT before returning to userspace)
>>
>> No, this will break userfaultfd, cause userfaultfd currently returns 
>> an error code directly in this case (please update to the latest 
>> codebase.). See:
>>
>> static struct folio *shmem_get_folio_noalloc(struct inode *inode, 
>> pgoff_t pgoff)
>> {
>>      struct folio *folio;
>>      int err;
>>
>>      err = shmem_get_folio(inode, pgoff, 0, &folio, SGP_NOALLOC);
>>      if (err)
>>          return ERR_PTR(err);
>>
>>      return folio;
>> }
> 
> The return value of shmem_get_folio_noalloc() will change, but it seems 
> this does not affect the logic in mfill_atomic_pte_continue().
> 
> ```
>      folio = ops->get_folio_noalloc(inode, pgoff);
>      /* Our caller expects us to return -EFAULT if we failed to find 
> folio */
>      if (IS_ERR_OR_NULL(folio))
>          return -EFAULT;
> ```
> 
> No matter whether get_folio_noalloc() returns an error or NULL, the 
> error code is converted to -EFAULT here, and mfill_atomic_pte_continue() 
> is currently the only caller of get_folio_noalloc().
> 
> Did I miss something?

OK.

But I still wonder if it's worth changing the definition of a flag, 
especially when there's no obvious bug here and this is merely a 
cleanup. Yet this cleanup requires adding an extra check for khugepaged, 
which makes me feel it is not worth it. Unless Hugh prefers to change 
the meaning of this flag:).


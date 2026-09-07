Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 48E7DC79F9E
	for <linux-mm@archiver.kernel.org>; Mon,  7 Sep 2026 07:40:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E2C966B009D; Mon,  7 Sep 2026 03:40:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E03846B009E; Mon,  7 Sep 2026 03:40:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D19D56B009F; Mon,  7 Sep 2026 03:40:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id AB7D16B009D
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 03:40:13 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 1F2AD14066B
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 07:40:13 +0000 (UTC)
X-FDA: 85186167906.14.611DCA5
Received: from out30-110.freemail.mail.aliyun.com (out30-110.freemail.mail.aliyun.com [115.124.30.110])
	by imf11.hostedemail.com (Postfix) with ESMTP id 3872840002
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 07:40:09 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b="JG6lG39/";
	spf=pass (imf11.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.110 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788766811;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=82c/cEDSh9maujXIA79HAPy5EQu+cpWevwisjM76zYI=;
	b=DOm+SlDT9tjZIOyaTUqYDrNliiprk5k7dVpA2B6yLym3vyx/2RA4pJPk3+ktC9u94L754d
	Vk+VSQs1nmk7nPOCrumBTJ7X+9MjpOaCs1CBKJksVVm/ti3FcSU8qHGGCvypq8CZ5kPBDg
	oaLTysa2th5Oxa8Q0nqv39ZMGSF9ihQ=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788766811;
	b=SiCZAZfLEi17DckUlUETmmo/phYsWRgJH0xv8N8PnwyqKSx3tpglQdMLgfSVXe4BnxveQr
	L8B7Tyqx691gxR9bTBCiVYn31CVg5xb4i7sop19HDmKUMBjVXb3ef8MAMNYVIVU4OrrAKl
	L27/9K0oavVFdeKT9C2eBgqa5NsNQao=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b="JG6lG39/";
	spf=pass (imf11.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.110 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1788766806; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=82c/cEDSh9maujXIA79HAPy5EQu+cpWevwisjM76zYI=;
	b=JG6lG39/3BFYMwM5GIX+bnyDC+nJnjngZeQZ+oDWfHnXFbQr2Rc21bk/7LWX2KfORsJO7LY0471HTJTjoLLkrcQH7K2BMfluRNtsfdjdlSEzs0x/ddjXeBlG0EWb6tLBAp5ekUa8WoRk8CNG2kTbkxU2WjzynS7IhHkApyXI1Ik=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R111e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037009110;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=18;SR=0;TI=SMTPD_---0XAQpdfr_1788766804;
Received: from 30.74.144.134(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0XAQpdfr_1788766804 cluster:ay36)
          by smtp.aliyun-inc.com;
          Mon, 07 Sep 2026 15:40:05 +0800
Message-ID: <814025eb-87cf-49d6-90df-ad1783fb220c@linux.alibaba.com>
Date: Mon, 7 Sep 2026 15:40:03 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 02/12] mm/khugepaged: count collapses where khugepaged
 makes them
To: Kiryl Shutsemau <kirill@shutemov.name>,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, kernel-team@meta.com,
 Zi Yan <ziy@nvidia.com>, "Liam R . Howlett" <liam@infradead.org>,
 Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>,
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
 Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>,
 Vlastimil Babka <vbabka@kernel.org>, Jann Horn <jannh@google.com>,
 "Kiryl Shutsemau (Meta)" <kas@kernel.org>
References: <cover.1788533997.git.kas@kernel.org>
 <ef229484e454d804ffbdbf8ae87798919594fd1b.1788533997.git.kas@kernel.org>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <ef229484e454d804ffbdbf8ae87798919594fd1b.1788533997.git.kas@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 56osknuy8fdwzrxagga8yn9kkwweoj16
X-Rspamd-Queue-Id: 3872840002
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1788766809-306273
X-HE-Meta: U2FsdGVkX1/fHRLBnUKgwllOCeHBNlWzfgqJpqlmIYC0ixyZiEu5BJGiwNmzSggUikp54m/RA8+2IqlYSa0W/WXco+CFdCpkQBs+EDc5fjzDKmmGchTLQdhB5m0wC4bVKwT7iSgQVjKnvANxizSBekrfW9LltTPvo8S9diPLzc3om81kLlKVG80mDotgX0+Os/PPJgBDpzUSHsgrXBfJQ37L9fiNJwrVKAq1Po0rDe+JhMKhMOZL8haXPsz9fshwFhjT1b3SeZ6HgaWDQK/kzG/SWa6bo1pKdHadWKnI0KgcP/XWmEh3q/HQBZH5WD/JMc0dQpL6Cbb1YDF5blm6JxrelUUBGwE0WX3jLKzl7V+4lH45IpetcWf+6xBkJiVxb5OVFcn7mIdC6xECoPYvorxU5ip7GI8+9b2Mca7CZf5c5oMc3qxL12bVtKrFH7487hEWMVBqMqxN2fCJOhyy5/dK8dO017Ya1kCBBLFUn6nHa25MUjaDYVs9y5TtVJ7FDPNIswxojBRT3UkHTwEeIFf2Ap3gWsSLkwpYUiPuHM338caolfZl+po8diVnmzm1Pg4xW6Y86n8xhyWYMyLCS2XovBGX/yI06DXIY4VhCTmIU+/rN66WkEDDPBgbOtscRCzOYHBMb1PpvXJsZF02iLLU/O45cI9difRqtFWzEFRL2sfRp7ZX9nA2Hd/brbxREpHiPPoskA/8NToXs33j8ZokQPrjrjTM/bIGu1pLdAwAI5PgdTDa4IbGOirLRYbUz11tq5ZwjAJp1O8pz07/AzY+OkH3wOHqfQSaaRWgNm3dPRbpfLoPf0wPfpvtn4nfHzQDRYmRuh+fVOfZy+g31fmz1ySuQCp4keQ9VOcnDGmkb2enfn2aCtvYoCyvtWBXUFV3AzI0DzRbXcc0RPnpsIZT7msQauTR7mIgW6n9tGkC3DzTb+yIL7uOHxhvjTLqnx9li08p6V6xpgJajju
 1SwIniKA
 NSZJISjqHImsuzcQt+w8oNrDRhI+JFrnHu+NI/SRXix7vamvezTwiiWGilnm6WPlUNKX1Wqdh26KzAiovxZa1kWJYInj67ajBjr5m9l+M9Z1wUDflq+zoHlWzNx8leyu4q+h+pJ4x0nSgz2BrIz2+/Q6tedniRgQs7Og22Jns1fg3PrGIL3Q5/mh3EaZXWM7qHvbNOnQeXebSAgeeiZ/5JhKg3hWOr87lV0rK2pN8ilNyU8CSU5WjEHKbByyFb6anKv83C8j0MR0hy8lW3MUZguzExh9VIbvyPxKMVBpiWLbXuYtEmQCQaFwqh4eWPO3MHPEsNfA2lAi9yuw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 9/4/26 11:10 PM, Kiryl Shutsemau wrote:
> From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>
> 
> collapse_single_pmd() bumps khugepaged_pages_collapsed for its caller, and
> tests cc->is_khugepaged to know whether it should: the counter belongs to
> the daemon, and MADV_COLLAPSE must not touch it.
> 
> The daemon sees every result of every collapse it asks for, so it can keep
> its own counter without the shared path testing who called.
> 
> Assisted-by: Claude-Code:claude-opus-5
> Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
> ---

LGTM.
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>


Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B4317C87FCC
	for <linux-mm@archiver.kernel.org>; Thu, 31 Jul 2025 18:41:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2D7206B007B; Thu, 31 Jul 2025 14:41:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 288826B0089; Thu, 31 Jul 2025 14:41:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 176906B008A; Thu, 31 Jul 2025 14:41:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 0B9586B007B
	for <linux-mm@kvack.org>; Thu, 31 Jul 2025 14:41:20 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 989B780EB5
	for <linux-mm@kvack.org>; Thu, 31 Jul 2025 18:41:19 +0000 (UTC)
X-FDA: 83725427478.22.662399D
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf10.hostedemail.com (Postfix) with ESMTP id 34955C000D
	for <linux-mm@kvack.org>; Thu, 31 Jul 2025 18:41:16 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="G/BMtChq";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="uMx7D/3Y";
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="G/BMtChq";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="uMx7D/3Y";
	spf=pass (imf10.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753987277;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0Sv51VnK012QgJpcYgAuO+r+JO45rwAswNl1O+Kew8U=;
	b=efbPdheUM49tvCLzGVDvS/vQ4Vn7nk+zNEgKgtPLilspZsyLvOs6npCRXz28go7DODScOG
	xEATlUdod8TW2VNlZsgcOeqyldAzc/0VNV+ozw8yo3CkFY933buWeHzDzHwS8NmdA/10F+
	FQA0QYrRRjJrXmUTkSuBxowCAPKCJEI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753987277; a=rsa-sha256;
	cv=none;
	b=ha3Oj3zkkEzwvn4TCtLmy6czNn9Dkc+1xDhAL5v2cvu/Yh2q92HNGcZLlaNCQmJYckG9ub
	25wJPIoQIlHjoT/k5R668PXIiR6PX4z5rN+DdF/ceYt0RbVTcfb3a4cZe+A37L3q8hxv6J
	U+XMkKkPS0udu3KpwKA2Z/pSiP6aZ2s=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="G/BMtChq";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="uMx7D/3Y";
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="G/BMtChq";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="uMx7D/3Y";
	spf=pass (imf10.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 7EC4D1F7ED;
	Thu, 31 Jul 2025 18:41:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1753987275; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=0Sv51VnK012QgJpcYgAuO+r+JO45rwAswNl1O+Kew8U=;
	b=G/BMtChqtjctsqeFygmz5MpWxt/LqFK3+/OIS6kjHOnm9kAmfDCIRgFTY0ou9M4+DOTu+4
	J1bM003cmyc8eUCxZpRL72kh0N2RYK6LFe7qj/Jwaj7SJMIZMBwvZOqQK+hnx5IeNSQW8N
	GM9Hp+rI0MU0WkEsfxtaxI6hiNIaWrY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1753987275;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=0Sv51VnK012QgJpcYgAuO+r+JO45rwAswNl1O+Kew8U=;
	b=uMx7D/3YcsGLDucgsGEp/O9KYA4vqUIqnLESFo/2mLj9z+iPLu9N95/Jm1sLOC57+E18NW
	eut8/SEFtVsC13Cw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1753987275; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=0Sv51VnK012QgJpcYgAuO+r+JO45rwAswNl1O+Kew8U=;
	b=G/BMtChqtjctsqeFygmz5MpWxt/LqFK3+/OIS6kjHOnm9kAmfDCIRgFTY0ou9M4+DOTu+4
	J1bM003cmyc8eUCxZpRL72kh0N2RYK6LFe7qj/Jwaj7SJMIZMBwvZOqQK+hnx5IeNSQW8N
	GM9Hp+rI0MU0WkEsfxtaxI6hiNIaWrY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1753987275;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=0Sv51VnK012QgJpcYgAuO+r+JO45rwAswNl1O+Kew8U=;
	b=uMx7D/3YcsGLDucgsGEp/O9KYA4vqUIqnLESFo/2mLj9z+iPLu9N95/Jm1sLOC57+E18NW
	eut8/SEFtVsC13Cw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 6C20A13876;
	Thu, 31 Jul 2025 18:41:15 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id RvK0Gcu4i2hhSgAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Thu, 31 Jul 2025 18:41:15 +0000
Message-ID: <71df781c-3ef3-4b26-9ba8-93fc7d4f9eec@suse.cz>
Date: Thu, 31 Jul 2025 20:41:14 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: Realtime threads delayed due to kcompactd0
Content-Language: en-US
To: Frank van der Linden <fvdl@google.com>,
 Alexander Krabler <Alexander.Krabler@kuka.com>
Cc: "linux-rt-users@vger.kernel.org" <linux-rt-users@vger.kernel.org>,
 "linux-mm@kvack.org" <linux-mm@kvack.org>,
 Dennis Schimmel <Dennis.Schimmel@kuka.com>,
 Daniel Braunwarth <Daniel.Braunwarth@kuka.com>
References: <DU0PR01MB10385345F7153F334100981888259A@DU0PR01MB10385.eurprd01.prod.exchangelabs.com>
 <CAPTztWYf82p6hq=Q2mVq6_9WTjRaQiH81z4idZL6MZ1PXufPwQ@mail.gmail.com>
From: Vlastimil Babka <vbabka@suse.cz>
Autocrypt: addr=vbabka@suse.cz; keydata=
 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
 m6M14QORSWTLRg==
In-Reply-To: <CAPTztWYf82p6hq=Q2mVq6_9WTjRaQiH81z4idZL6MZ1PXufPwQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 34955C000D
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Stat-Signature: imsspg9j9ndxh6tdwyr4s9cf6tbmndyc
X-HE-Tag: 1753987276-994871
X-HE-Meta: U2FsdGVkX1959Y4Dtz9d+/eGlIkjnvaodSaOq5uLBERjUs6jKL625AAp82dlGY+N1pwxPUdGe2/fxY6Z6ujboWd2umNmorBGv8AkQ0ODTvyLbCM9tX74sXkTrqxL1D3SwM6jdQnxP3UzwEHtEeCXrO5XaIqZoB6xapO1oH6lvuCEcFDqXDTMvDjF7x2IwT9h+cOhwyfQexx2Zx90LiFdyQ+H8nai5mBnCYkDUiVRYIq3hzlr00I476sQhcfXYj4r+caUj+KcOoUyYICD5+MdMeRDqyOjR4XjcpSEecAC21wn56AOMr0jgdlkOEXE2/eARPUEW/I8jlpvCGEWtg6cA8RD2HsGxFE2eHPXWZSj5jy0yHhQ9LNWBIDuP8ThwOAYy3Eazjebo1hr4ns9NvqApz+w5xM0w6sqFft5oBtanxil9JmhcqDf9vvr8ljVI+wyT1HWQT9FvrwJB8AFf6e0I/eHiXseCQfzuJ00FjPmP/Jy+GvlA4dVTxUg5llNcbGNbZF+OeECWS5UXKoMRbX7kSucAAthFU7bMEXCiPkMUbuxF4g3nrbwbgYhpaqqKTM+nOacz5hS7kmEaTDIraXW/8xJMZFqJ2lJhaQXtDbG+PtnQCsZ+oidBr+O2+CnmdNz07YyQNzY7hiyIiWZ99pPOWEkTA4wfwOEMQa52xqphhPm6+NTFR5NVDQatLDjlF9TyMDONJyK6DOR6sLGjFAEHTUS2yisJeeg+yxIHqmdsq5cs7h0P5cd6TbYZkRqZSn95stH0cp0HNmR46ZbXfnbS01k3wdJFlIOyKiA6Joh4znSDpixKlTBhd1sUcnipS1QuMvy8opukNXzkjJi7LuoGip8+RWYBUFJuZzyLy/WEtYSSjCZ7GkacLV6eI+PWW8dVJ9YsQ9hMrN21CESqmNTFJ9uPueH9JA6kNXBzVyj0bEtLJ5QjsnDsDoQB4rK1OwuiUmnz53PeTFiR9HAijv
 xfnBDQNa
 ES+OS1uwQN1MhceLDE48A317glIYQjAlIYsAtXb2jc/2X1iRfRgDseY7yRrHPiAUJGbgu3G3AxKxmaKX9jDtv70VRWe2zR2rzv0KIz8EOX/pKbvFsycHjWziTa7A8BlVptfhqWivr0Tat8yFe698RAy0nCaaVIzXtmpYNSKhMABYHUVVvT+0EtXXCTAcIABI69CiF2OXNAVkCdbOffWLAeQWDGomi4626Vr7EOswRdWE1wl6FXNWAPv3gZpMgO2OYpEtpp0AAG18+i7cqTLz6Lp6pJr+11jfj0TGUeDdKcnxM2noD68qJH5L6Ml4ZOeAIEVA/
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/31/25 20:34, Frank van der Linden wrote:
> Not sure what the right thing to do would be. Either explicitly boost
> the priority of a thread temporarily during migrate_pages_batch, or
> mitigate the issue by dealing with 'busy' pages more quickly in
> migrate_pages_batch.

There's a workaround for realtime tasks. If you mlock[all]() their memory,
setting sysctl vm.compact_unevictable_allowed to 0 should exclude these
pages from migration by compaction.

Vlastimil
> - Frank
> 



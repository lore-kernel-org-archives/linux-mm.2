Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2C324CA0EC0
	for <linux-mm@archiver.kernel.org>; Mon, 18 Aug 2025 12:06:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C29AC6B00B9; Mon, 18 Aug 2025 08:05:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BDA946B00BA; Mon, 18 Aug 2025 08:05:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AA2718E0003; Mon, 18 Aug 2025 08:05:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 93AA96B00B9
	for <linux-mm@kvack.org>; Mon, 18 Aug 2025 08:05:59 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 5FD72BBE8E
	for <linux-mm@kvack.org>; Mon, 18 Aug 2025 12:05:59 +0000 (UTC)
X-FDA: 83789749638.13.9F60686
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf01.hostedemail.com (Postfix) with ESMTP id 0E6C440008
	for <linux-mm@kvack.org>; Mon, 18 Aug 2025 12:05:56 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=MdHLM0qg;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=IpR3VIGE;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=MdHLM0qg;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=IpR3VIGE;
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (imf01.hostedemail.com: domain of hare@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=hare@suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755518757;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qu9v+fr2mK8VQbSW13ClOvrZt5hxDSdnoK2mLEHPovM=;
	b=keo1gN8IxK0Gu2sOxGZCmBHcE8+aR3nRB+66g0mHXaLh7otFRrfo12wNzS2GyWfYqO57IP
	Y6MB+Nqwc0RUqZFd2KM4DSaqYU4jio9zP5eSi3t8D9xnKBiyuBafWyxE0z8BDWWRoHSGjQ
	06BnWnLZFxPlzFlNPAZWegsltE1QFzQ=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=MdHLM0qg;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=IpR3VIGE;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=MdHLM0qg;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=IpR3VIGE;
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (imf01.hostedemail.com: domain of hare@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=hare@suse.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755518757; a=rsa-sha256;
	cv=none;
	b=LPBAPw9T5iwinqKaJPZlET5p+7eqPZaBSNTuGYEWUSCdgtJQRNeqyRiVu5xgGuUzp/j/Sb
	LJf/X15flRI+LvATfpJxxS6URFSy2vipDjUrOPpK8rI23qywITXE2YuO8Y4qOBmp0IORUl
	JIV9EtFnlRSChElXq3N7SmGZcULOsII=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 902D81F387;
	Mon, 18 Aug 2025 12:05:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1755518755; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=qu9v+fr2mK8VQbSW13ClOvrZt5hxDSdnoK2mLEHPovM=;
	b=MdHLM0qgaeR4B3I0+GdsZeZl+SGwY9C79O4Y7QTjaxvkXfLsN6stdQyNVySwjDUOhfPNYK
	B7V4HyC4ovjVZgs1xBau58s7tIAwZCwpvtF+jNhdmyIaOochhH4IKj38rOuVzGYDzVn39t
	QRu2NZCktn76xjw49q3NRlHI1kzKtko=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1755518755;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=qu9v+fr2mK8VQbSW13ClOvrZt5hxDSdnoK2mLEHPovM=;
	b=IpR3VIGEpVAirqsgobjv2gkTstXg3/hm2n1koZnwMhtR0of+PtO7xb0I+WwMRoBoAgyaKW
	Q7I+4KL4sFBiGFCg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1755518755; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=qu9v+fr2mK8VQbSW13ClOvrZt5hxDSdnoK2mLEHPovM=;
	b=MdHLM0qgaeR4B3I0+GdsZeZl+SGwY9C79O4Y7QTjaxvkXfLsN6stdQyNVySwjDUOhfPNYK
	B7V4HyC4ovjVZgs1xBau58s7tIAwZCwpvtF+jNhdmyIaOochhH4IKj38rOuVzGYDzVn39t
	QRu2NZCktn76xjw49q3NRlHI1kzKtko=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1755518755;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=qu9v+fr2mK8VQbSW13ClOvrZt5hxDSdnoK2mLEHPovM=;
	b=IpR3VIGEpVAirqsgobjv2gkTstXg3/hm2n1koZnwMhtR0of+PtO7xb0I+WwMRoBoAgyaKW
	Q7I+4KL4sFBiGFCg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 2D34113A55;
	Mon, 18 Aug 2025 12:05:52 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id dQPbNiAXo2gnbQAAD6G6ig
	(envelope-from <hare@suse.de>); Mon, 18 Aug 2025 12:05:52 +0000
Message-ID: <fde3cd06-d660-4b38-940b-4d089ee2c4c4@suse.de>
Date: Mon, 18 Aug 2025 14:05:49 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 5/5] block: use largest_zero_folio in
 __blkdev_issue_zero_pages()
To: "Pankaj Raghav (Samsung)" <kernel@pankajraghav.com>,
 Suren Baghdasaryan <surenb@google.com>, Ryan Roberts <ryan.roberts@arm.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>, Vlastimil Babka
 <vbabka@suse.cz>, Zi Yan <ziy@nvidia.com>, Mike Rapoport <rppt@kernel.org>,
 Dave Hansen <dave.hansen@linux.intel.com>, Michal Hocko <mhocko@suse.com>,
 David Hildenbrand <david@redhat.com>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Thomas Gleixner <tglx@linutronix.de>, Nico Pache <npache@redhat.com>,
 Dev Jain <dev.jain@arm.com>, "Liam R . Howlett" <Liam.Howlett@oracle.com>,
 Jens Axboe <axboe@kernel.dk>
Cc: linux-kernel@vger.kernel.org, willy@infradead.org, linux-mm@kvack.org,
 Ritesh Harjani <ritesh.list@gmail.com>, linux-block@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, "Darrick J . Wong" <djwong@kernel.org>,
 mcgrof@kernel.org, gost.dev@samsung.com, hch@lst.de,
 Pankaj Raghav <p.raghav@samsung.com>
References: <20250808121141.624469-1-kernel@pankajraghav.com>
 <20250808121141.624469-6-kernel@pankajraghav.com>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <20250808121141.624469-6-kernel@pankajraghav.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 0E6C440008
X-Stat-Signature: 8dzawi31wd5w7cziapx51wj9dqbaiutd
X-Rspam-User: 
X-HE-Tag: 1755518756-644303
X-HE-Meta: U2FsdGVkX1/XICdQeZjpLemx+ZXuRrDCEQQsKELOfN/FCdYlc6p7ZnjliKc+7Thq36rA6XSuyDRjfpvud2nLJSXoofpL5dsFtn+IizTOHyWouiR3dIMAxfyiYDx88L1wtZ2OsWlfxk5pfhxlZdDEN9nhbSsTpq327SovxEwwPyr7EA2/dGzewvJeq0M2uLZWgrbtUWLIKdvsvs58m3vdp6ynkhkefdakTmFb86q8s73SlLvR0dEEQjoWDSnJFZIRKkWOSQCwv/FjY3gIAXJP40QRnB0XFHnAv/OBjiw8hzyuyYpcm6fKhXblR+zx/1lHrIyfb6AHPzyptdDSFEptCIGeAx4ZAn34yTJ0uf0Ysoh9jK8U4H+l6cMFh0ZvlXEeLkCzCgPh0jLj22cwqc8ejqBg+LRNAj/KL3aeAjH9TJedFXklBjuDhqLBg8TNAUNvZKc6hhF7c/+8zSy539Zyg59vr/JqXHv9mjMbJylR0MLNp3o3zge38UPQL2ivl0cJEIkbrI2Rh69PUqljJe33iWd7bTKq0QKI4Tym4GvRsrz+NqhN4bmgsw6516kFG3q97NXJ42baYXxVe/2J3++iWcRCFYNOQUAnaM6BGBLj6ueSL4nkpWVH5UcO19S+Pf3SczR9iSGJ+UQ7Flef3Vbcn6Mgk/ee5IqgXdDosm+/25wTPaKxJlCOyQhSDLzAWR0I67XQ5cfezDifRZYl6sY8FbD+aL3V8BxdEuqgoJJdYjggt8KzKiqg+3QgzFhNvgDIpRiEqts0BhfFTAgvi8VanzeJkw+KpWF2BpF1HjKDZDJNNRy5Y7ypYMK1MmSob31BmEiNPxOMkjNul+EdtMUbT47Rk/ulFkDWDy7mogkh1SVkxqr9W68PHqXt6jDUClEJs8GubY7vTGTC2foiPEDatp4DodAF/8aP5zUka1s+feQhhwwotQjr3uvfVimQvZ1GAafqHmjR+LFLa20hxVT
 YlXByH8N
 8MFuNKAu1PySLYA/spqcO4UhSKy2Fb7pY3t75q+6zquctcWp6Gf5APrMXCC6jfzXIKiJh16C+8fgX1jbfwkT7Hleo5VKjk0N58zp8ij97H9stPxjLMHeay3lW8Eek3TCcnbwPfzJaYKZTyYirsNjnaNBCj85voSNwmRfdKcZDfWoGWgJdfJPQ2AjRNhtIqzlEwCV7Crra8bFzEqap9GXHUEZHuAZMi4jokAch2MQuK+rpfEud1MWVjKKwiTSLqB7crkK3FnWom4PrWNFicvEhpuT8fPDvBUIMZ8YrE4PmqHlvLoRoITQYiE8P+pYbLSgBw+2ZS3MksFq1KCgws28VwQhdbXPrjvTu51pHmx7tR92VkBEtSuZf4laN06ohYeBQwAOYzUQzBDEsINJBBonbmroBQjfUmnp3o6zd2HBAxWYdjejEVZf5aFX1E8HcibZHSiJkRvdPGAHtHDTlDuATA2Ub43PCvnmza3O17PydGlSYEiOz0Cc/YTqEHg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/8/25 14:11, Pankaj Raghav (Samsung) wrote:
> From: Pankaj Raghav <p.raghav@samsung.com>
> 
> Use largest_zero_folio() in __blkdev_issue_zero_pages().
> On systems with CONFIG_PERSISTENT_HUGE_ZERO_FOLIO enabled, we will end up
> sending larger bvecs instead of multiple small ones.
> 
> Noticed a 4% increase in performance on a commercial NVMe SSD which does
> not support OP_WRITE_ZEROES. The device's MDTS was 128K. The performance
> gains might be bigger if the device supports bigger MDTS.
> 
> Acked-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> Signed-off-by: Pankaj Raghav <p.raghav@samsung.com>
> ---
>   block/blk-lib.c | 15 ++++++++-------
>   1 file changed, 8 insertions(+), 7 deletions(-)
> 
Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich


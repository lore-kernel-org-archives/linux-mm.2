Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 08C2FC87FCB
	for <linux-mm@archiver.kernel.org>; Fri,  8 Aug 2025 17:46:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 57B986B0099; Fri,  8 Aug 2025 13:46:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 52C846B009A; Fri,  8 Aug 2025 13:46:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3F48F6B009B; Fri,  8 Aug 2025 13:46:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2FC0A6B0099
	for <linux-mm@kvack.org>; Fri,  8 Aug 2025 13:46:08 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id B58EB115D4D
	for <linux-mm@kvack.org>; Fri,  8 Aug 2025 17:46:07 +0000 (UTC)
X-FDA: 83754318774.22.583ACC9
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf07.hostedemail.com (Postfix) with ESMTP id 4D23940002
	for <linux-mm@kvack.org>; Fri,  8 Aug 2025 17:46:05 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=hnTsNRSV;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=QisqGGgW;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=hnTsNRSV;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=QisqGGgW;
	spf=pass (imf07.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754675165;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OgUmwY6RCC9p9/dfYsN5D7uMh1db1LsUhnXQ6lTp2CU=;
	b=gZYjdAcf7zJ5PfjdrWRBAo5743kRErJo/TYAkH5GobSc/L6VB+d0LuplNU7Jhr9yHUf6eE
	ob/pUbh9uYvZxEKTvaGVSNFht0XKFWYtdy1alRsSKCslqZ7RgbuTeSwXl/myQr2Q16MGJd
	0fdanaBtNCss5je3iDSNbq6lKNHsqI8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754675165; a=rsa-sha256;
	cv=none;
	b=63S3R/uQkLKYMpj3ADVW98oXMj+arV7TFuRK/cfHXfoiN/yCgjmhNRKC1Cc+nFOuY0K4iA
	rzLv/Izczdx64EKQGKCnqgQjvFNbsUW2ppIgZTt44I/NsxgDEZCF2lDwSFo8G33iCWW/Aq
	ola6G99VZZy+GdX7bz8H4ikGOp0cujc=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=hnTsNRSV;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=QisqGGgW;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=hnTsNRSV;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=QisqGGgW;
	spf=pass (imf07.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 3427433E3F;
	Fri,  8 Aug 2025 17:46:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1754675163; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=OgUmwY6RCC9p9/dfYsN5D7uMh1db1LsUhnXQ6lTp2CU=;
	b=hnTsNRSVcXZvncuMw3nnw3vQDVI1iiWEAHLrfxWgbwFzht9b+UyUTUYYy/aNFqBcXY4CUT
	nbIZqT+2hRwWPzxv67SfrKgnuvM6erLL7LbqDtgg4hXLicK3kl/GuKMW6FZaqCmX6an7mc
	UsSjNdn48T5GOfWzuuoH75CNj62gJHU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1754675163;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=OgUmwY6RCC9p9/dfYsN5D7uMh1db1LsUhnXQ6lTp2CU=;
	b=QisqGGgWGb0XheLsmWyq31VQkNt7/VLiJP9Kc/6q7GiK1lg5QFvTGDBPmuzglkgYPiHmnV
	n37q4/fG28qVkmBg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1754675163; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=OgUmwY6RCC9p9/dfYsN5D7uMh1db1LsUhnXQ6lTp2CU=;
	b=hnTsNRSVcXZvncuMw3nnw3vQDVI1iiWEAHLrfxWgbwFzht9b+UyUTUYYy/aNFqBcXY4CUT
	nbIZqT+2hRwWPzxv67SfrKgnuvM6erLL7LbqDtgg4hXLicK3kl/GuKMW6FZaqCmX6an7mc
	UsSjNdn48T5GOfWzuuoH75CNj62gJHU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1754675163;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=OgUmwY6RCC9p9/dfYsN5D7uMh1db1LsUhnXQ6lTp2CU=;
	b=QisqGGgWGb0XheLsmWyq31VQkNt7/VLiJP9Kc/6q7GiK1lg5QFvTGDBPmuzglkgYPiHmnV
	n37q4/fG28qVkmBg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id EF51F1392A;
	Fri,  8 Aug 2025 17:46:02 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 6GkKOto3lmjUaAAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Fri, 08 Aug 2025 17:46:02 +0000
Message-ID: <2a53f01c-db74-4298-bb9e-36b770e4fcd0@suse.cz>
Date: Fri, 8 Aug 2025 19:46:02 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 3/3] fs/proc/task_mmu: execute PROCMAP_QUERY ioctl
 under per-vma locks
Content-Language: en-US
To: Suren Baghdasaryan <surenb@google.com>, akpm@linux-foundation.org
Cc: Liam.Howlett@oracle.com, lorenzo.stoakes@oracle.com, david@redhat.com,
 peterx@redhat.com, jannh@google.com, hannes@cmpxchg.org, mhocko@kernel.org,
 paulmck@kernel.org, shuah@kernel.org, adobriyan@gmail.com,
 brauner@kernel.org, josef@toxicpanda.com, yebin10@huawei.com,
 linux@weissschuh.net, willy@infradead.org, osalvador@suse.de,
 andrii@kernel.org, ryan.roberts@arm.com, christophe.leroy@csgroup.eu,
 tjmercier@google.com, kaleshsingh@google.com, aha310510@gmail.com,
 linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 linux-mm@kvack.org, linux-kselftest@vger.kernel.org,
 SeongJae Park <sj@kernel.org>
References: <20250808152850.2580887-1-surenb@google.com>
 <20250808152850.2580887-4-surenb@google.com>
From: Vlastimil Babka <vbabka@suse.cz>
Autocrypt: addr=vbabka@suse.cz; keydata=
 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
 m6M14QORSWTLRg==
In-Reply-To: <20250808152850.2580887-4-surenb@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 4D23940002
X-Stat-Signature: ha659ecyicqqq1dd3o63mpzpoirj7xwb
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1754675165-158558
X-HE-Meta: U2FsdGVkX18KGVWGVxBcwDjw55E5u/pye+JyIfX+hkrgFM6t3/54vWRQrKh0zNW1gMzjUGBrcgX96O0lfhJGRVtyFObg/eyfCZgsucjrBmoGW404MbQ/7DR+P0e4H7xpHu3Xmbz+kW1kyxavcx8Yravgt7p0R1CiBWuGMjri6RpHuro70UB5jPIFknyTvGGTeXzQGzvni8ZChkTrH57lNAvcvChsAT7oTimrEG3rJ5M6anHbpbitlaR7PwuZ0lKqh7dEnzQi030e6j3c5TbmaOp2pp89SxTOWeAdmj1GsUWr6hq74QcGgDYXEAI9B+mvggHEm7Kih/te/VasefQMUwHNyse+AV2VPZ23Udj0Wy7ODdKxoI/o4FUEJ0kLVo/G3P8CVrW06kl967oP8xOLu9LmtcDsoDW1LIq4EsoKY/KsVvRYWaezBn8ACyCt1U/bA9LLSkSbz0Xj2/MO1cVqiEkHB69ZO8OXN+RyGX4eM9VpkT8BFF7NkgO5U7TGYLS1ykzpggFMGzkuGdpP+V1pPug3Q6luG96Wc3/Cp3ziidVASRUTs733mOGtoWmJ5jeSi7Fs3IY1MPnJzNvPb0iY9er0cgIRAQbaiTMz/7ERxjr5Tb4DyYaomCRmsnX88w/gVr9L66Q4MpuSGULnRxkSkiHwNOoPMSN355XT0hJNbllOqUDvGwC2rpGv88gHANaonOmWmW6dx5iVdhYeYpa3apdnO3cdy/4cZft7Iax0f5lvXWtylzWTJlMcEnoJ9A4B9ss2YQF9Z+51qy4WXNgWqA8aYf8SboFr6/KgGMu2WvzAqchwoJ97wflsSnCde8YPIhv2rJ2eP7e4/tb1ZDDkBsqtbZNCcn/yAD+0JmWeYt6PkTdetQGrVQr7PbLrIXwgak5qca+QraDRiLzqkQi76xleIrbOxonKxyB6g9/BirPnYeAxVgrXZQbcpUAaBxt81CK3AHBn9JaOeeuBolZ
 OsBew96a
 x+YCQtLBnHvB6f+T4cuknGKYvg1WqDpMaWlcW3EC54FK9q7fUH0GaHrb21wSv1oC9OevyfAfQ3IXNI/frZ0s+C4ufgXpL4Z1BQyRDcgjCHG+CN9Cnm28aL1EglD7mqdbtTZ4d0Xn5A/QaTFOY4vIEmtaRjk/z65iYCe9yINcGxw96yfkTTSiwdrWy8YWkaL4OUeeMCc74SmSOtHZizMQcRDhDRGroyZSOY0/jF0TO72ST1waISvItLrGj0GGbqPx+ymSuVerd8MVwSL1aCZHBxDZbnkq2wEh2jH5mxayfzZYV7WXJ3Scig2GvXTn3xW8HWH7DN7k6hBKByJZVlA0M83qAjnMQSKvro+c59/izoD1ph7LEXOu3hkzWkTuqK1oIbDrL
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/8/25 17:28, Suren Baghdasaryan wrote:
> Utilize per-vma locks to stabilize vma after lookup without taking
> mmap_lock during PROCMAP_QUERY ioctl execution. If vma lock is
> contended, we fall back to mmap_lock but take it only momentarily
> to lock the vma and release the mmap_lock. In a very unlikely case
> of vm_refcnt overflow, this fall back path will fail and ioctl is
> done under mmap_lock protection.
> 
> This change is designed to reduce mmap_lock contention and prevent
> PROCMAP_QUERY ioctl calls from blocking address space updates.
> 
> Signed-off-by: Suren Baghdasaryan <surenb@google.com>
> Acked-by: SeongJae Park <sj@kernel.org>

Reviewed-by: Vlastimil Babka <vbabka@suse.cz>



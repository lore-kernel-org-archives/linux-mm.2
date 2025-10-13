Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A3EE9CCD183
	for <linux-mm@archiver.kernel.org>; Mon, 13 Oct 2025 12:59:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0B6268E0044; Mon, 13 Oct 2025 08:59:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 08E238E000F; Mon, 13 Oct 2025 08:59:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EBF198E0044; Mon, 13 Oct 2025 08:58:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id D81B88E000F
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 08:58:59 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 8C2AB119B89
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 12:58:59 +0000 (UTC)
X-FDA: 83993095998.07.BB3A4E2
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf19.hostedemail.com (Postfix) with ESMTP id 333DE1A0014
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 12:58:56 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=ZIhtcp7D;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=+g+6vyDw;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=w3wJ6bOR;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=oFRwmpdD;
	dmarc=none;
	spf=pass (imf19.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760360337;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GUvXlGSR5dfv4DsHE/Q9B87BUvBYICqk18OVwp4dZpo=;
	b=kCxliiijbXsv34Urc1t9iRtHZQQ5AVQc/zD/B7507OYYCfbilV/1RQi3God92BrrSGJ/52
	06vw+idlBGSkoQ+fvdSBvigoGOH0Qk2Ons+NpjLEIuGOdZn3AQpnAew401GHnSfCutFhBc
	stZ8v2L0dyFm9Aco7BivCTFq7HJFCQs=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=ZIhtcp7D;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=+g+6vyDw;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=w3wJ6bOR;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=oFRwmpdD;
	dmarc=none;
	spf=pass (imf19.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760360337; a=rsa-sha256;
	cv=none;
	b=Ouyj1zl74HPBseZ1eKH3izjcQDaQ4UxBBgUd050IY+/XDESzt1hz25VgugFUQcdrmKOgFo
	cJFoz+5gc1KX8vJLn+3lv2gP878zJv5vP1rLg+bqLlmv296XulH0q88uomFuCzLih7sjZf
	lnIVCvGgsrq9TZH29SLjIEzRsCdysXY=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id A355D21A0C;
	Mon, 13 Oct 2025 12:58:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1760360335; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=GUvXlGSR5dfv4DsHE/Q9B87BUvBYICqk18OVwp4dZpo=;
	b=ZIhtcp7Dx8VfBtEa4XN0pmjakW/kevK9QuHN8xeQDoiyzQpQ/3Zt5yvQRtite5ibV5V8Uf
	csFFxwQlD2r9TyeIlxcyBOqsOew7DCLfVd+/LVEZccl0Gysl4dp89PhwwwXhmETdd72PdZ
	+jEdHtnCjAEhK7p8admwmYvm2IaZ2pk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1760360335;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=GUvXlGSR5dfv4DsHE/Q9B87BUvBYICqk18OVwp4dZpo=;
	b=+g+6vyDwhWbIatNNLDLKSHUiullj0+zaljcntAFFnPG4Y8ImZGpnR6IXm5TlHggKZBIX88
	Z5kONg5YCHF01LAQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1760360334; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=GUvXlGSR5dfv4DsHE/Q9B87BUvBYICqk18OVwp4dZpo=;
	b=w3wJ6bORfEFflCSEDWXZ0SHmbA+9pWST+N/BMt1tti/E5n17216TAFRDo7KODNENZIts7F
	sVc9qopl0n6RGRoOZ4JO0ZdVx2weGhDnZkmeBPi59nfgk0q92g7T7/9Ud747PkoUK02x6X
	c6hkDVHmW3iQmCgn4msDESN4vPD3lyY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1760360334;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=GUvXlGSR5dfv4DsHE/Q9B87BUvBYICqk18OVwp4dZpo=;
	b=oFRwmpdDQn5NL2xshmLSPbX2C962zstdmxgel3QZFZ5YhJLiZ3HFcE1fxDHI7+KICYT2TN
	+AYEWJOLvuS7y1Dw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 8BAC11374A;
	Mon, 13 Oct 2025 12:58:54 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id DuqtIY737GgQPwAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Mon, 13 Oct 2025 12:58:54 +0000
Message-ID: <eed70cd0-7850-4f06-ac64-3059c20e78e0@suse.cz>
Date: Mon, 13 Oct 2025 14:58:54 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/2] mm/page_alloc: Prevent reporting pcp->batch = 0
Content-Language: en-US
To: Joshua Hahn <joshua.hahnjy@gmail.com>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: Dave Hansen <dave.hansen@intel.com>, Brendan Jackman
 <jackmanb@google.com>, Johannes Weiner <hannes@cmpxchg.org>,
 Michal Hocko <mhocko@suse.com>, Suren Baghdasaryan <surenb@google.com>,
 Zi Yan <ziy@nvidia.com>, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 kernel-team@meta.com
References: <20251009192933.3756712-1-joshua.hahnjy@gmail.com>
 <20251009192933.3756712-3-joshua.hahnjy@gmail.com>
From: Vlastimil Babka <vbabka@suse.cz>
Autocrypt: addr=vbabka@suse.cz; keydata=
 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
 m6M14QORSWTLRg==
In-Reply-To: <20251009192933.3756712-3-joshua.hahnjy@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Action: no action
X-Rspam-User: 
X-Rspamd-Queue-Id: 333DE1A0014
X-Rspamd-Server: rspam03
X-Stat-Signature: g7jtw3z49kuf8n49oe9i65w9izxihojw
X-HE-Tag: 1760360336-996619
X-HE-Meta: U2FsdGVkX19PquZjapy/NSUm2Wav0hX6/zmwzv3GeXl56wEDDNCsr3AFmhhSYauOwngPdiJfHV+1vO3pVBE12WgLsP85iz4DrahDJWGFEbAA4gnZyHObvY3mNc5FkHGMaboZktVXNxxqV2CfWKRXn1JpJL9Q2r3osv+xOonPOd9KbpX2mexpKvUmROEpiAiosGGbyrRe07wR3IWkngV0VlQkuJoE3AQ6Gv+w0zfaA7F/CE1M2CyMgP6d60Wxm0kc0hxBLeBgqgEt0InTjH6bzVN+01zdYcnHGuFofAjByc9LerZBMynnDwZQuv3ARbx4eaI/XwIHFAq55JlbAl2BPRzj0Vt2i4FuybaX0t8nBRbZv5ojtW8eef8IaihZPh13IFgXLVBscRS377qUeeCiH6k0VCvQUW7Pa31w6LPoIO06lZvucXpiDJ6kv4mG6otGcrVxMECRSMjQvwh2t71WFOcQ+aUmGcILgXf7cQ2H7R7J+bPpA6tvzH+PgmMiojk4Uu9VhhDg2pTGznSWjXEDohBE8obmaR5vUmelfUKWPRcbvBHNtLK4OLHQ4WtePnik2o5GXe6XaYFHlqfPPN6vrYHlmFgNpuYa2udOjZnguMVyoRZRU8XFBfyE+nMlJZiBnZE1z7ve7rDHenR44gpS9Jd9k9K/yWj61O78runHaPq2TMc3xIip3+6OVpA0YWN+zx3FXMIqPJH05FPLFL3GCo5tfA7pwfTPK2l5oGlPqBKzT+QHdfTmuKcGobvUhNCUlfpyaQzYSA4SQ08Q33sZHqylNXUxrRBnQOYjqA/QMcyG4VEN/dxyO0RubgiDWH5X+gOeKr3IIBmxJEQ5Xo8/1GIpeiLB9/GO71GPsJP0b9hBj4yZSA/e3trhAu042xsdZgc0MBwRLmEET03UZoG5Um8uZ2q9e/iL2ZnmUAxgzrzJT2RuHUyd5+eAwmMXfhFwzhQ3rcpztSuRQvWNB/b
 1dx0hOC9
 c+FwnejYHpzFB2s5IzxSoyjDSorSuTJlwRIhEJ8CaUAGDAhv6AKivjiXjsjtoRxDEXLGmCwkfu8e1WoYzMYSv6bjxbB+YjmULHEELIdM0iT6UGm2jMd9gVgIAlQfLf5/gWF5QENoo6fAZsjsoPoLJQyqzZ4MCDFKCIScbvpe5u2Z1EgEHnxw7jyg2cpp3zVlY4cu/Juqap0HWzMMWyEXAvwJCixPCs7zVW3Ztt0PixMD9Z00lZmGgZX9Xx/S7a2IEoyXSOvR1HwLBUiF91SqoO27/3dYlg0Lv2BeXRlbiBm34AT4ZZoDBM36cxYtPLRqiWtOkN7jRbahn/tt1WfcwIOw9KTvlA47RQ7xdIwCW72c6CWKDlq9GS3eItv9MI0Bsc7AfT4ld5sbX80ZM5ymeF+jzyEG3yepyQl96eBDcBHX8rCY=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 10/9/25 21:29, Joshua Hahn wrote:
> zone_batchsize returns the appropriate value that should be used for
> pcp->batch. If it finds a zone with less than 4096 pages or PAGE_SIZE >
> 1M, however, it leads to some incorrect math.
> 
> In the above case, we will get an intermediary value of 1, which is then
> rounded down to the nearest power of two, and 1 is subtracted from it.
> Since 1 is already a power of two, we will get batch = 1-1 = 0:
> 
> 	batch = rounddown_pow_of_two(batch + batch/2) - 1;
> 
> A pcp->batch value of 0 is nonsensical. If this were actually set, then
> functions like drain_zone_pages would become no-ops, since they could
> only free 0 pages at a time.
> 
> Of the two callers of zone_batchsize, the one that is actually used to
> set pcp->batch works around this by setting pcp->batch to the maximum
> of 1 and zone_batchsize. However, the other caller, zone_pcp_init,
> incorrectly prints out the batch size of the zone to be 0.
> 
> This is probably rare in a typical zone, but the DMA zone can often have
> less than 4096 pages, which means it will print out "LIFO batch:0".
> 
> Before: [    0.001216]   DMA zone: 3998 pages, LIFO batch:0
> After:  [    0.001210]   DMA zone: 3998 pages, LIFO batch:1
> 
> Instead of dealing with the error handling and the mismatch between the
> reported and actual zone batchsize, just return 1 if the zone_batchsize
> is 1 page or less before the rounding.
> 
> Signed-off-by: Joshua Hahn <joshua.hahnjy@gmail.com>

Acked-by: Vlastimil Babka <vbabka@suse.cz>



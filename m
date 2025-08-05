Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F2C75C87FCB
	for <linux-mm@archiver.kernel.org>; Tue,  5 Aug 2025 13:13:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6828A6B00A2; Tue,  5 Aug 2025 09:13:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 65A796B00A5; Tue,  5 Aug 2025 09:13:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5702F6B00A6; Tue,  5 Aug 2025 09:13:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 3C61D6B00A2
	for <linux-mm@kvack.org>; Tue,  5 Aug 2025 09:13:34 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id DB6A9135A84
	for <linux-mm@kvack.org>; Tue,  5 Aug 2025 13:13:33 +0000 (UTC)
X-FDA: 83742745506.22.75BDCDA
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf19.hostedemail.com (Postfix) with ESMTP id 43B981A000F
	for <linux-mm@kvack.org>; Tue,  5 Aug 2025 13:13:30 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=a0fspBgD;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=cgtIllom;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=a0fspBgD;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=cgtIllom;
	spf=pass (imf19.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754399611; a=rsa-sha256;
	cv=none;
	b=Wog1ke5Ha4mi0XCUK74zXOxx7khNZjyRjE+6eh8b8zP8YePQw7d+Ay503e2wTa8ADV1X2S
	FNu1L9XCx6NV9AU3lcRdumI1v9SBVjsGRMTdGcUEAaYuKR7GUf6OeKOxVvZmcFnkACkZdY
	CO9qlZydIFEwOp8GqMNL5ShwQ/Ve7dQ=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=a0fspBgD;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=cgtIllom;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=a0fspBgD;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=cgtIllom;
	spf=pass (imf19.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754399611;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Xi0O+0PdcmQy2RsQ+A/bu5pdhayeg1okjbaLCenz2T0=;
	b=Uho1txJB/4eJdlu3lquwdoVbUipq2sLrJCELtyLWXil3OQEx3xg9PO6A9ZttrqRk49P2f/
	WBOZlwM6lH4lv654YAUg5ddKXKMtIjSoBBSKG1aDSA5Jnywo27F8i5jis/GuQdyv7uY7PG
	1CXGGQNs/3TObsjv4+oEedrZdqZk6Vk=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 5CC911F74C;
	Tue,  5 Aug 2025 13:13:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1754399609; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Xi0O+0PdcmQy2RsQ+A/bu5pdhayeg1okjbaLCenz2T0=;
	b=a0fspBgDv7mHr0gCzRNAy6nYETWL0rIDRUlvXtJP1ZYmOnTK6jsGYCQTi82lAPng7mzru6
	DBdAaMbvCYEUXRJkVxvXDQDWM4uEIHj37QXTgmEPfxSat8O6rMeVwKnklGIS5OOXIyqORq
	A3BgHJtRpxmEIWwbj/yyynNc2YgGVGk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1754399609;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Xi0O+0PdcmQy2RsQ+A/bu5pdhayeg1okjbaLCenz2T0=;
	b=cgtIllomiETqtcvWGC8w/VKHvxEPfDzsj2/m9sWR5FJXfYzexlDfCESBMazpRTqR/apz3g
	vEa/pPrVhcAMZDBA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1754399609; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Xi0O+0PdcmQy2RsQ+A/bu5pdhayeg1okjbaLCenz2T0=;
	b=a0fspBgDv7mHr0gCzRNAy6nYETWL0rIDRUlvXtJP1ZYmOnTK6jsGYCQTi82lAPng7mzru6
	DBdAaMbvCYEUXRJkVxvXDQDWM4uEIHj37QXTgmEPfxSat8O6rMeVwKnklGIS5OOXIyqORq
	A3BgHJtRpxmEIWwbj/yyynNc2YgGVGk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1754399609;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Xi0O+0PdcmQy2RsQ+A/bu5pdhayeg1okjbaLCenz2T0=;
	b=cgtIllomiETqtcvWGC8w/VKHvxEPfDzsj2/m9sWR5FJXfYzexlDfCESBMazpRTqR/apz3g
	vEa/pPrVhcAMZDBA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 0167013A50;
	Tue,  5 Aug 2025 13:13:28 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id ApkCOngDkmi2FwAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Tue, 05 Aug 2025 13:13:28 +0000
Message-ID: <a4491b54-4e08-4bcc-bcd3-3bae20a490b2@suse.cz>
Date: Tue, 5 Aug 2025 15:15:26 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm: memory: Force-inline PTE/PMD zapping functions for
 performance
To: Li Qiang <liqiang01@kylinos.cn>, akpm@linux-foundation.org,
 david@redhat.com
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, rppt@kernel.org,
 surenb@google.com, mhocko@suse.com
References: <74580442-2a9a-4055-b92d-23f5e5664878@redhat.com>
 <20250805120435.1142283-1-liqiang01@kylinos.cn>
From: Vlastimil Babka <vbabka@suse.cz>
Content-Language: en-US
In-Reply-To: <20250805120435.1142283-1-liqiang01@kylinos.cn>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Action: no action
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 43B981A000F
X-Stat-Signature: a1pbz8i3xa8j1neuo5rtkogostdw1i5q
X-HE-Tag: 1754399610-888625
X-HE-Meta: U2FsdGVkX1/qgowLnTJEdVbWXfRDX69qLAukTOzoGpxfdd8yb04AStrsX/dQQ+ZbWn0PB8VXHYHdVxJG1ZIu2CmvFvEjo4pQBsdXOiYRKpT5Xk2OMkTgDhUDfbtGFnehlcaidK08VQpzDXPGciRVu0CuTZAGAmW9pTC46v4eJ6qHJCTUuj5Q8IBoaRTGV8/m/H9fgqpt+ckb2ZuG4r+EUJurnFyTR78F4CY+K8Gwy7p4XhGQKeDsEWenqtD6fQ6faME1GQVG3UTPvMYE6PPFSv1y4sBuY3JADED5lp9NjaNuLF4xC8YJr/jShFrm9We9aslRJ03yvT6TqtCFZn+pFXzlhLFv5QHrod7Wgv0rwPEQPGYzg4ZJ17xsWEfm0zpIvqC4wQtn8EW/XBJTFLpJV/MV7Z0iTdrYXVwbDUEW56C4Zpr8x7MbNOu3S10GA4kkKJneB6uwIW2PxzLKmHdvO2uMTUcC85v45YkSqPQWySa05utGfoUAoPP+lsn7mDRRQhrHtFfNfnC15r+TTN5K+JlWestN3Xi6my/kzTu30HRg3oQ1LThAzbdFDJKQwvDNHmd5xb2e8D2rge24GJCH6CzrHbtx27R/HSWDA3BmdWnFa96uZLCN695JZrC0PBjJ7cfF21s7aR9FONDKUgyQZ3yBfbJfNhdH8FUzqXE+IGPG4vRRBcdJgK0U8IOAVhTFsCmTu0CoPIq6VYGx3mwOhDvhWkOioS9Z4g1zMEafYl4k/g/h5leqmwgPHfFK+3JydwMzaO0SNBRRTSAlUjTKWwZkEgtNs9Cw6CNKemGpU5PBYJE94qqHdAK4Qi+NWoHXWHk93S83YCbqb4RY8Fx9zfcRtZ9dbG9ZYpIsoVcV0LymUNnDqVNRcd7Zr5z9TF1Q/hMhIGKgIdxCL7qlskNGFV9dXV1S7q659JM0+IdvPr1H9owYa1fDxTiRaENAFLixZCCtvmkjC95MQfgHW3N
 3ZOGyLfu
 aoKc3xLqEPQ9ZOOXj04y3sNMeg/33bMpPNwhjOvTmztauLIDvR+aI1VQ+skpbgOXdRme7N/5mwsY8SEpUuxV7CY5hZlpNStwt2kjcbjjilRZZ2lKfWdri0U72iC+Sr6e1er+20aLDRyGxirbF1Qs54lWrqdpyd4ME9Z5RU/g+NNL6uNAcZfRaPovgAAQNCVwWDut1RexgLnfucCEsMczpHDqKxCoHCT+aG4v1KPnGApf2T4FFBya8IE6bDuTwLPcfs9KG79GI0YaXcMRICTZzUHlzWvYSRRXIqZrv
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/5/25 2:04 PM, Li Qiang wrote:
> Ah, missed it after the performance numbers. As Vlastimil mentioned, I 
> would have expected a bloat-o-meter output.
> 
>>
>> My 2 cents is that usually it may be better to understand why it is
>> not inlined and address that (e.g., likely() hints or something else)
>> instead of blindly putting __always_inline. The __always_inline might
>> stay there for no reason after some code changes and therefore become
>> a maintenance burden. Concretely, in this case, where there is a single
>> caller, one can expect the compiler to really prefer to inline the
>> callees.
> 
>>
>> Agreed, although the compiler is sometimes hard to convince to do the 
>> right thing when dealing with rather large+complicated code in my 
>> experience.
> 
> Question 1: Will this patch increase the vmlinux size?
> Reply:
> 	Actually, the overall vmlinux size becomes smaller on x86_64:
> 	[root@localhost linux_old1]# ./scripts/bloat-o-meter before.vmlinux after.vmlinux  
> 	add/remove: 6/0 grow/shrink: 0/1 up/down: 4569/-4747 (-178)  
> 	Function                                     old     new   delta  
> 	zap_present_ptes.constprop                     -    2696   +2696  
> 	zap_pte_range                                  -    1236   +1236  
> 	zap_pmd_range.isra                             -     589    +589  
> 	__pfx_zap_pte_range                            -      16     +16  
> 	__pfx_zap_present_ptes.constprop               -      16     +16  
> 	__pfx_zap_pmd_range.isra                       -      16     +16  
> 	unmap_page_range                            5765    1018   -4747  
> 	Total: Before=35379786, After=35379608, chg -0.00%  

Is the before/after swapped here? This output suggests some functions
became NOT inlined.

If I'm right the output binary becomes slightly larger. But it doesn't
matter.


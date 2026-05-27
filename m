Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9A1ADCD5BD5
	for <linux-mm@archiver.kernel.org>; Wed, 27 May 2026 13:16:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EE3336B00B7; Wed, 27 May 2026 09:16:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E94776B00B8; Wed, 27 May 2026 09:16:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D5BAE6B00B9; Wed, 27 May 2026 09:16:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C61D76B00B7
	for <linux-mm@kvack.org>; Wed, 27 May 2026 09:16:22 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 8FAD214020F
	for <linux-mm@kvack.org>; Wed, 27 May 2026 13:16:22 +0000 (UTC)
X-FDA: 84813248604.07.59129E7
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf22.hostedemail.com (Postfix) with ESMTP id 7EC8BC0009
	for <linux-mm@kvack.org>; Wed, 27 May 2026 13:16:20 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=lzGuTPB9;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=v2twKcmK;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=lzGuTPB9;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=v2twKcmK;
	spf=pass (imf22.hostedemail.com: domain of hare@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=hare@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779887780;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OlZN4MZBMRk7/mYsuEmdScE+habUyE7Kd5wM6ZSmZgo=;
	b=BJrscqaxQHGLP7/ffstsKJo+ehvrRQ7GC2kR3zv13Mzq4vjXoDMHIYWPjuwWVWRISpJoZ5
	Zh/KCcpp1Qg589FfMrBVQVCEYxuxSX66ctZd1DvRXkD4AN/r10eGVgElbyqsEaBXnj98XC
	YY9OgIQQrFVV0SUUCjm8VpdmXeBwmt4=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=lzGuTPB9;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=v2twKcmK;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=lzGuTPB9;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=v2twKcmK;
	spf=pass (imf22.hostedemail.com: domain of hare@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=hare@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779887780; a=rsa-sha256;
	cv=none;
	b=sTIDvtsTcMeLbHPfy4m0OWo0UvJtRcf7TEx09tBeZclf2wetVKlKTpCf2mOfkMX/N9KgfE
	Hg3lSk/DRpCQsO362jAJgmpcIUCYHdGeOBPHRtBcbFT++SRmDlPInz/aS/xTS0FXdUy50Y
	RBRWybAY1azy2762eYo5xFG6xTOvOBA=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 20A57676A6;
	Wed, 27 May 2026 13:16:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1779887779; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=OlZN4MZBMRk7/mYsuEmdScE+habUyE7Kd5wM6ZSmZgo=;
	b=lzGuTPB9TxksItwNNrc4fVrQaUQB12CntSIS3UxwCx9fARLVE2nnW2n8of+sODqGKXmLXO
	nOSUl7rwGEX0Zd4AJ/peUQaUKyIvWF/j84REVLYx9Etg21Oy0JCkPOkLGOkui4McBgAc64
	v6p9l8QG6SIwDI7PgqZSwUOINHfTJJo=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1779887779;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=OlZN4MZBMRk7/mYsuEmdScE+habUyE7Kd5wM6ZSmZgo=;
	b=v2twKcmKpiySDGB6ar/59B5yPxRSfjBa/a7BG9Ubym94q6NC6NvrFj8nz8Pkyb3lKK+0dZ
	+uIydVF3HQvabxBA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1779887779; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=OlZN4MZBMRk7/mYsuEmdScE+habUyE7Kd5wM6ZSmZgo=;
	b=lzGuTPB9TxksItwNNrc4fVrQaUQB12CntSIS3UxwCx9fARLVE2nnW2n8of+sODqGKXmLXO
	nOSUl7rwGEX0Zd4AJ/peUQaUKyIvWF/j84REVLYx9Etg21Oy0JCkPOkLGOkui4McBgAc64
	v6p9l8QG6SIwDI7PgqZSwUOINHfTJJo=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1779887779;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=OlZN4MZBMRk7/mYsuEmdScE+habUyE7Kd5wM6ZSmZgo=;
	b=v2twKcmKpiySDGB6ar/59B5yPxRSfjBa/a7BG9Ubym94q6NC6NvrFj8nz8Pkyb3lKK+0dZ
	+uIydVF3HQvabxBA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 093ED5A849;
	Wed, 27 May 2026 13:16:19 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id SJC9AaPuFmoFGwAAD6G6ig
	(envelope-from <hare@suse.de>); Wed, 27 May 2026 13:16:19 +0000
Message-ID: <26361fb4-54bb-4db6-9394-640ab7115b4f@suse.de>
Date: Wed, 27 May 2026 15:16:18 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] block: partitions: replace __get_free_page() with
 kmalloc()
To: Christoph Hellwig <hch@infradead.org>
Cc: Vlastimil Babka <vbabka@suse.com>, Matthew Wilcox <willy@infradead.org>,
 Mike Rapoport <rppt@kernel.org>, Jens Axboe <axboe@kernel.dk>,
 linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org
References: <20260520-block-v1-1-6463dc2cf042@kernel.org>
 <ahPnX-CwVgK-9chp@infradead.org> <ahPxmSqT4Y4jcAbQ@kernel.org>
 <ahP3R2nH8-bHMVf0@infradead.org> <ahQX_JCgS9JWIhY-@kernel.org>
 <1dea9df9-18c2-46f5-bf47-abb3f088574b@suse.com>
 <ahWwD0eqj3cUgaKn@casper.infradead.org>
 <8b780901-8184-4908-8bda-56fac42fe6b3@suse.com>
 <17258981-d5b3-4ed1-9b3d-56a0b6ecb3f9@suse.de>
 <ahbti6M8zRWR1oGa@infradead.org>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <ahbti6M8zRWR1oGa@infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 7EC8BC0009
X-Stat-Signature: gjz556xhjfmhi8i1466wtxeh3j9n3gq9
X-HE-Tag: 1779887780-113817
X-HE-Meta: U2FsdGVkX1/fWIUCfDMgLWBCgNF3bRxw2Sf9l5d33eBGGr/vGb1+rd76ETVTe2NQKzdnxyIP6BD8y3Pq31t57FESsQ+vZRq5GhMQPsWiEx524TsUdRhbnECB+LTYgEuDMPbKIeyVbe18QBnp/v5x+WVmn1SqEaXSuV9en27F1w7W3E8hqptFa84hYu5mGuoTe23Yor0s9dQA23cIuhkXx7n8qHn/6BKfgD3U+hsQq1obBKnesH5SAHGlwwPt1uoxUHYfPMzB5ce+PnrnNGMOZvMF9qGsV9Mar8zLwlzW7sULkMkJvKxbGL3dJqZcoTJ9NKMHFXsjbkHF60qJTOx6gFI6PmAEVBmzdQdHTaxIC+/Ihw48sSPmKDVzRk02zJ6+ckdISt0DYbHpJ2t4LlSwA6KKDe16twd86walyjs7RhqcmxsXvye1q8r8At/QpvBYLyCoB39wfnSCF3sHqOTLAtSzTBNIsHg9TOLzaUK450ZnLehriItGNFAcXd4Rp7zi2J1iTU6noG8GCCgMXLn+uI72PgCX12Ep1qUmlnNnXPlzN3Q8UW+lBEJ02FCZCBsRdjsSpMdkqzbdFxvzp1IFlXK2UJ1JHiEOmwB8hLSu7G8daz46WM00M4+gIQK2rzFz7FyLm4gP/DDjcTH681HL4Lbo/8ox6eRdSLF5MLxhbZarqI4COgQP8FHFJEpbhPCbTE4x3R/ZuiHx4MFGuVlQ7Bl5vjMZODe4vsN0jtBBCefGTHvfm39qd8IL1TOXXAWDscmkwGmJ6IRL14CeP93fA3JcZxAqtyYFSg9ucsIpicUj7WQaqfwZEeG9ks5FRsyoZ+KivXy6Ik6Zs7ie0RATYU6zl4h153WpOapUww3L3r+cjBcKKoklQGtCBqNXQUKO344I4O5jNrbQpPxKxS3xz80ldcQdxZpYWLF3DFzSDUhYvm3bDXNgGsnIuQV3zjcQNZLxiuGxHF/EdQAoU0Y
 Pkmk8PtS
 zx4KOpvRWOgzUtYAFNddn+AseAFMrEug5DMZ0JfYtFJuJCPuer0Z0Is/Q/JD/cwi0dvlNB3S1fCihMvRcfGFw0K9lsY847mDOkEv6sxd6+9ddjGOyKUtSbWmljgUHj9Q74s04EU26PzPTtdMbd5Lf3XwSl6yCeXQYZOlsBCBmlvDjP3nDjrpMy4pqdkWo2Uvv3wTriMpwF0nnkIUTjeuTkK1B7AMYwp6xYqkyUc8RNrRq0Wcn8p3bqeOQsrnpBIrv7Lrjh8h6VqJA8evlKbzXmEcE1qEFwCK6fHyDWNZvbbFHBUcb62qEgHN+kS8h+xEgcJ1BcMUvif2G9+gaDivMyDaShr443PO/FKUyhEkR78u8we6JnpjkduC/8xmeY46cAhrj
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 5/27/26 15:11, Christoph Hellwig wrote:
> On Wed, May 27, 2026 at 12:04:29PM +0200, Hannes Reinecke wrote:
>> Precisely my reasoning. In most cases, __get_free_page() is just a
>> lazy way of saying "I need some memory and the allocation should not fail".
> 
> Huh?  __get_free_page and kmalloc can and should fail.
> 
Even better, one argument less why it should not be converted :-)

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich


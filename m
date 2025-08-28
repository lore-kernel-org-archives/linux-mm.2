Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 30598CA0EED
	for <linux-mm@archiver.kernel.org>; Thu, 28 Aug 2025 14:21:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6BABE6B007B; Thu, 28 Aug 2025 10:21:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 66B596B0088; Thu, 28 Aug 2025 10:21:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 55A5D6B0092; Thu, 28 Aug 2025 10:21:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 43F3F6B007B
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 10:21:10 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id C4810AC875
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 14:21:09 +0000 (UTC)
X-FDA: 83826378258.01.C68D0B6
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf14.hostedemail.com (Postfix) with ESMTP id 6D79E100009
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 14:21:07 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=aXsIsQPV;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=y6TneMYX;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=aXsIsQPV;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=y6TneMYX;
	spf=pass (imf14.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756390867;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aqiaQFlBOYKAI7njJj/u551vt3ouY0wM55M0oWkLZlg=;
	b=RzUFphewoKm2IjQdiANyktYHaAW8X8hvTWb1YiRvy3d/HLd7W47GfwejyFptOCTsvDUBJ6
	X38rWhIYzQWXij+Pv48/E3foPZFa3rl5njtOZcYUCj9+HQTB9SNlIUEp1Hng0YRyi9KAze
	7qCqw/qvinDX0b5hGRWW3Bg1RuBNYIg=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=aXsIsQPV;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=y6TneMYX;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=aXsIsQPV;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=y6TneMYX;
	spf=pass (imf14.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756390867; a=rsa-sha256;
	cv=none;
	b=qqmKINjFXWVNsJ/gvZXpQ224lgHvjA2GwQHv81ab9jOrT5FACzZYGLTOJVRyifJ7MM5T3K
	Rvt/uunMdCr9jDh7/Efz1QZyra4REurBac6+TMTcVapLyaSIQk3fF5yDd29xtWWwfRYSAs
	XOBOeDZEcWy46gwoV38psXhlekgAZA8=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id CC71722098;
	Thu, 28 Aug 2025 14:21:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1756390865; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=aqiaQFlBOYKAI7njJj/u551vt3ouY0wM55M0oWkLZlg=;
	b=aXsIsQPVgjmop6DjBihTXEZ4p1fpk76LMh7F5PUW7eYc4PO4LbTo5LJfztirEgF5OsYmj2
	tRb5IHJvl+vBxgbquo9SwMQB2NrhlG6ZoDe/kaME5MeYIhh1QojsP9HgEFQxOETZRRuDQs
	OWV9OjMO8CAvpwPKgHUl6dI56AFjCPs=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1756390865;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=aqiaQFlBOYKAI7njJj/u551vt3ouY0wM55M0oWkLZlg=;
	b=y6TneMYXXAJgtJpWUMmQFRbMBouLr02ttAEdHnwYHD857AZQ5UahabYKeW4SKZromtv9IO
	dtcnFj18MqOVjZBw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1756390865; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=aqiaQFlBOYKAI7njJj/u551vt3ouY0wM55M0oWkLZlg=;
	b=aXsIsQPVgjmop6DjBihTXEZ4p1fpk76LMh7F5PUW7eYc4PO4LbTo5LJfztirEgF5OsYmj2
	tRb5IHJvl+vBxgbquo9SwMQB2NrhlG6ZoDe/kaME5MeYIhh1QojsP9HgEFQxOETZRRuDQs
	OWV9OjMO8CAvpwPKgHUl6dI56AFjCPs=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1756390865;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=aqiaQFlBOYKAI7njJj/u551vt3ouY0wM55M0oWkLZlg=;
	b=y6TneMYXXAJgtJpWUMmQFRbMBouLr02ttAEdHnwYHD857AZQ5UahabYKeW4SKZromtv9IO
	dtcnFj18MqOVjZBw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id B36191368B;
	Thu, 28 Aug 2025 14:21:05 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id rjZcKtFlsGgyHwAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Thu, 28 Aug 2025 14:21:05 +0000
Message-ID: <53b938ed-dd78-42fa-8cde-f3a938b6f39f@suse.cz>
Date: Thu, 28 Aug 2025 16:21:05 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/mremap: fix regression in vrm->new_addr check
Content-Language: en-US
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Carlos Llamas <cmllamas@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Jann Horn <jannh@google.com>,
 Pedro Falcato <pfalcato@suse.de>, kernel-team@android.com,
 linux-kernel@vger.kernel.org, "open list:MEMORY MAPPING" <linux-mm@kvack.org>
References: <20250828032653.521314-1-cmllamas@google.com>
 <8a4dc910-5237-48aa-8abb-a6d5044bc290@lucifer.local>
From: Vlastimil Babka <vbabka@suse.cz>
Autocrypt: addr=vbabka@suse.cz; keydata=
 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
 m6M14QORSWTLRg==
In-Reply-To: <8a4dc910-5237-48aa-8abb-a6d5044bc290@lucifer.local>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 6D79E100009
X-Stat-Signature: x86sbct5sb1d4arbydz4ui5twdabdrkp
X-Rspam-User: 
X-HE-Tag: 1756390867-627496
X-HE-Meta: U2FsdGVkX1/qnSvf5cJnm1znzL2Nk3VmljUkFWlE9JdWd0YDP35upr0TxhHLGy9I/ZZjq0hfZbawat5UL1/nycgNSBydBJ9KkBGgLIFu4m6f1NjCp0Vkdrq9p1sCSuzjtrpcnsdYapWYRxVDkOpZznUy7grXhqaqSTjTab5nX3tkrMm4EB9sKrzNJdzm7woWsg16rYJKU6b6S2m/PM8IyTLyANIbB1ymDjOg9sF9KffETlgB4v2hMS9YvlpkwmSWH0zj4brxAlp8/RPNgZBJwCmEf+Y5pwEXeA44ME3QmeS5DXFAruZ36uKuRoEiYsbt9YOWhPlDeIsaBC0A+RqJOkaEdWPLyruvUd+hAF4epNhZaQ9y2xlMniC0HnzziZV3z6oUE6nl3r4G9UAsEbaORihrI0apTnMfVAmoSg7rFP1ykqEXsbK1ZVxza+2xZxGAno1EvqY6myQVIpglRIfRN7d88cITi3vvadVvUyNDPwb97iBe3XyUAmzOLXiTp5cIbkowqyKfe7N/32XTReBMiGl+i6FW826MRxmaRhCYNx3bXTttM037IAwhmqXMLlR3I77nWG0a8+tJj3cJB6y/Kg6JRYnWqNXqtZCJCOXSuxHgIS/4axD+eQIPhzojRTIDBxQDKyVHBCMzrChlRmZEZmy1iYOzL4vUdHwxiaMF6jpgdK65U5UNI/eErLhWgijhN0IzEr2WA1Cj113G5JCS19Hu1TIr/i5ou+n12G1TNFyu1Yg6/S2m51UBfOG1r2fPR+1sFimJ4f8398clYIRebMPSqumucWC6+vyJiLB+/4NvfR4QphLrk/QwpTWF1O5N6jRjOlViHSIp34ooudOjPHKPBQyVopK9PesPRulwkDGtwZcmAeLMCK6oxLBmey9dJNU0EOyRo2GA4yF6mIjgiiuJbUUpRzi0aJ/qgDobTWms9togmazBApGZYpRjfqcmYxJL0lV+YWU8iWOBmEC
 TeIJO67q
 dqZSNa23CHlX7EJJIBPLym0GLGFAy/8ZYgbA6k5yXY4k5ziZTD54d8hcXkOifQqPrDXk3kxNxpHtDSGvo9akacVtFwgmJAoTfs+kdfeZZm5urdMAcItQy9QA/JGYTzxHWCZwjGaaml34A4muvQVEsvYCLPw2owCn3GPdG3fhUh+dAehcMAjin+QyQfWNp9WjWzeCcJN2bruqLZShqktst9g7pAJDeQwbvcO5WwiiXWM3zsgIXK9JLcvxiO4cKgy8e/oOWBEQMVUXVU2jiK1QtzjehmWmFoquMJWO8puWreCjl8cS2DkLUdemiaYVaAI4D9PK9pYQw0uTjMHj00L/7dYYsx8ZHxfFtXTz7
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/28/25 07:38, Lorenzo Stoakes wrote:
> On Thu, Aug 28, 2025 at 03:26:52AM +0000, Carlos Llamas wrote:
>> Commit 3215eaceca87 ("mm/mremap: refactor initial parameter sanity
>> checks") moved the sanity check for vrm->new_addr from mremap_to() to
>> check_mremap_params().
>>
>> However, this caused a regression as vrm->new_addr is now checked even
>> when MREMAP_FIXED and MREMAP_DONTUNMAP flags are not specified. In this
>> case, vrm->new_addr can be garbage and create unexpected failures.
> 
> Yikes, sorry my mistake.
> 
>>
>> Fix this by moving the new_addr check after the vrm_implies_new_addr()
>> guard. This ensures that the new_addr is only checked when the user has
>> specified one explicitly.
>>
>> Fixes: 3215eaceca87 ("mm/mremap: refactor initial parameter sanity checks")
>> Signed-off-by: Carlos Llamas <cmllamas@google.com>
> 
> You need a Cc: Stable.

No need as the commit being fixed is from 6.17-rc1?
But it's better to use "[PATCH mm-hotfixes]" to make sure it goes to 6.17
and not the next merge window.



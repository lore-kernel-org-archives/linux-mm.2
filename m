Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2F31ECCF9E9
	for <linux-mm@archiver.kernel.org>; Wed, 29 Oct 2025 08:02:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7432C8E003B; Wed, 29 Oct 2025 04:02:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6F3C08E0002; Wed, 29 Oct 2025 04:02:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 609F18E003B; Wed, 29 Oct 2025 04:02:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 50E438E0002
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 04:02:05 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 20E0088EB1
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 08:02:05 +0000 (UTC)
X-FDA: 84050408610.13.606A700
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf22.hostedemail.com (Postfix) with ESMTP id 9BA9EC000B
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 08:02:02 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=AiNRgFvV;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=YZj3+LbC;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=HmkWTwFo;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=ZyQEV5XA;
	spf=pass (imf22.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761724923;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=i4SJ1u6YlZpvdBvtqPWVePYQY0BKt3uBwq0MkSLjAGg=;
	b=F5rSpLtjNxfi019/EbdzzJ1oj58bfZGB2lOA8gKam2LhGKRmmyyDnI/CEnqc+b1DC6qdep
	eMFmzjNKuHFFG6EuVfaAujAko/NysjlHZ89JMqPljloQqqNUBoymalaosii9t65Tjc4U6S
	9+7FaB/KdlneGVn+28zjkvsYlS7NeUQ=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=AiNRgFvV;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=YZj3+LbC;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=HmkWTwFo;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=ZyQEV5XA;
	spf=pass (imf22.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761724923; a=rsa-sha256;
	cv=none;
	b=z0YkZJbMElyuHZlRxrTBRLUEBZPepKqy0WoAmWxfhem3etKuMZB2pFeGQruyy+Y0IXgWLl
	ZCDlRbVHWrUK+0hMLg0wovNY/5Yi0OwdZxQxXNmONcZJkNcmlXLqrcC1scDxRUouE5YOHH
	D50a2XBIa1MUFqSTEdimWobI3GwZY9s=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id D3A4A201FB;
	Wed, 29 Oct 2025 08:02:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1761724921; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=i4SJ1u6YlZpvdBvtqPWVePYQY0BKt3uBwq0MkSLjAGg=;
	b=AiNRgFvVe9u1yYs9leMp0mi0TT0zzN/Mu3/lWlIPhmY+FqQOp0WbQG4BakgAZ3jCWx32SV
	7VHqtysTeKIdRFCx6kAURBaseEnfiNkIZ7ZFWzKpFs8sbjE7YoSff4nmxnrB3JPwe63gc/
	JA5e3GmWKw7fQ0GNnMAPfCgOCI63sQg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1761724921;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=i4SJ1u6YlZpvdBvtqPWVePYQY0BKt3uBwq0MkSLjAGg=;
	b=YZj3+LbC6xz+q0KVf8BwOkb9NCm+WmBAsqSgq7Z7jlF1vfqG6ppzra7qSsDW2e5qeGfJrE
	Vy8CSAm1uzAvURDw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1761724920; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=i4SJ1u6YlZpvdBvtqPWVePYQY0BKt3uBwq0MkSLjAGg=;
	b=HmkWTwFoxbL0FTvKBeHCPigkJfpYqix6rmgJmPwMOUygN2qXubKFZvV+A/6MtCP7X3voTz
	ow/J4ce86rjoS8duUilE66f3kpiB+QCPlCOyQu5ZEJowy2pt/YwJuhJUKi6KjcWlhY4/ra
	gJZLVR2OeTglA1NoDSU62+RmYqW32W8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1761724920;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=i4SJ1u6YlZpvdBvtqPWVePYQY0BKt3uBwq0MkSLjAGg=;
	b=ZyQEV5XA8Oclci8Uy4KOwS6X3rlJIRZqsHlivQD24qzHIMzJNayCPSkDYmsLsT/rquYvLr
	hyx+fcFiQLZgCmAQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id C115C1396A;
	Wed, 29 Oct 2025 08:02:00 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id vH7DLvjJAWmNKgAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Wed, 29 Oct 2025 08:02:00 +0000
Message-ID: <eb40bf3f-dc12-4ed5-be0a-2b6da012e62f@suse.cz>
Date: Wed, 29 Oct 2025 09:02:00 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/vma: small VMA lock cleanups
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: Suren Baghdasaryan <surenb@google.com>,
 "Liam R . Howlett" <Liam.Howlett@oracle.com>,
 Shakeel Butt <shakeel.butt@linux.dev>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
References: <20251024090902.1118174-1-lorenzo.stoakes@oracle.com>
Content-Language: en-US
From: Vlastimil Babka <vbabka@suse.cz>
Autocrypt: addr=vbabka@suse.cz; keydata=
 xsFNBFZdmxYBEADsw/SiUSjB0dM+vSh95UkgcHjzEVBlby/Fg+g42O7LAEkCYXi/vvq31JTB
 KxRWDHX0R2tgpFDXHnzZcQywawu8eSq0LxzxFNYMvtB7sV1pxYwej2qx9B75qW2plBs+7+YB
 87tMFA+u+L4Z5xAzIimfLD5EKC56kJ1CsXlM8S/LHcmdD9Ctkn3trYDNnat0eoAcfPIP2OZ+
 9oe9IF/R28zmh0ifLXyJQQz5ofdj4bPf8ecEW0rhcqHfTD8k4yK0xxt3xW+6Exqp9n9bydiy
 tcSAw/TahjW6yrA+6JhSBv1v2tIm+itQc073zjSX8OFL51qQVzRFr7H2UQG33lw2QrvHRXqD
 Ot7ViKam7v0Ho9wEWiQOOZlHItOOXFphWb2yq3nzrKe45oWoSgkxKb97MVsQ+q2SYjJRBBH4
 8qKhphADYxkIP6yut/eaj9ImvRUZZRi0DTc8xfnvHGTjKbJzC2xpFcY0DQbZzuwsIZ8OPJCc
 LM4S7mT25NE5kUTG/TKQCk922vRdGVMoLA7dIQrgXnRXtyT61sg8PG4wcfOnuWf8577aXP1x
 6mzw3/jh3F+oSBHb/GcLC7mvWreJifUL2gEdssGfXhGWBo6zLS3qhgtwjay0Jl+kza1lo+Cv
 BB2T79D4WGdDuVa4eOrQ02TxqGN7G0Biz5ZLRSFzQSQwLn8fbwARAQABzSBWbGFzdGltaWwg
 QmFia2EgPHZiYWJrYUBzdXNlLmN6PsLBlAQTAQoAPgIbAwULCQgHAwUVCgkICwUWAgMBAAIe
 AQIXgBYhBKlA1DSZLC6OmRA9UCJPp+fMgqZkBQJnyBr8BQka0IFQAAoJECJPp+fMgqZkqmMQ
 AIbGN95ptUMUvo6aAdhxaOCHXp1DfIBuIOK/zpx8ylY4pOwu3GRe4dQ8u4XS9gaZ96Gj4bC+
 jwWcSmn+TjtKW3rH1dRKopvC07tSJIGGVyw7ieV/5cbFffA8NL0ILowzVg8w1ipnz1VTkWDr
 2zcfslxJsJ6vhXw5/npcY0ldeC1E8f6UUoa4eyoskd70vO0wOAoGd02ZkJoox3F5ODM0kjHu
 Y97VLOa3GG66lh+ZEelVZEujHfKceCw9G3PMvEzyLFbXvSOigZQMdKzQ8D/OChwqig8wFBmV
 QCPS4yDdmZP3oeDHRjJ9jvMUKoYODiNKsl2F+xXwyRM2qoKRqFlhCn4usVd1+wmv9iLV8nPs
 2Db1ZIa49fJet3Sk3PN4bV1rAPuWvtbuTBN39Q/6MgkLTYHb84HyFKw14Rqe5YorrBLbF3rl
 M51Dpf6Egu1yTJDHCTEwePWug4XI11FT8lK0LNnHNpbhTCYRjX73iWOnFraJNcURld1jL1nV
 r/LRD+/e2gNtSTPK0Qkon6HcOBZnxRoqtazTU6YQRmGlT0v+rukj/cn5sToYibWLn+RoV1CE
 Qj6tApOiHBkpEsCzHGu+iDQ1WT0Idtdynst738f/uCeCMkdRu4WMZjteQaqvARFwCy3P/jpK
 uvzMtves5HvZw33ZwOtMCgbpce00DaET4y/UzsBNBFsZNTUBCACfQfpSsWJZyi+SHoRdVyX5
 J6rI7okc4+b571a7RXD5UhS9dlVRVVAtrU9ANSLqPTQKGVxHrqD39XSw8hxK61pw8p90pg4G
 /N3iuWEvyt+t0SxDDkClnGsDyRhlUyEWYFEoBrrCizbmahOUwqkJbNMfzj5Y7n7OIJOxNRkB
 IBOjPdF26dMP69BwePQao1M8Acrrex9sAHYjQGyVmReRjVEtv9iG4DoTsnIR3amKVk6si4Ea
 X/mrapJqSCcBUVYUFH8M7bsm4CSxier5ofy8jTEa/CfvkqpKThTMCQPNZKY7hke5qEq1CBk2
 wxhX48ZrJEFf1v3NuV3OimgsF2odzieNABEBAAHCwXwEGAEKACYCGwwWIQSpQNQ0mSwujpkQ
 PVAiT6fnzIKmZAUCZ8gcVAUJFhTonwAKCRAiT6fnzIKmZLY8D/9uo3Ut9yi2YCuASWxr7QQZ
 lJCViArjymbxYB5NdOeC50/0gnhK4pgdHlE2MdwF6o34x7TPFGpjNFvycZqccSQPJ/gibwNA
 zx3q9vJT4Vw+YbiyS53iSBLXMweeVV1Jd9IjAoL+EqB0cbxoFXvnjkvP1foiiF5r73jCd4PR
 rD+GoX5BZ7AZmFYmuJYBm28STM2NA6LhT0X+2su16f/HtummENKcMwom0hNu3MBNPUOrujtW
 khQrWcJNAAsy4yMoJ2Lw51T/5X5Hc7jQ9da9fyqu+phqlVtn70qpPvgWy4HRhr25fCAEXZDp
 xG4RNmTm+pqorHOqhBkI7wA7P/nyPo7ZEc3L+ZkQ37u0nlOyrjbNUniPGxPxv1imVq8IyycG
 AN5FaFxtiELK22gvudghLJaDiRBhn8/AhXc642/Z/yIpizE2xG4KU4AXzb6C+o7LX/WmmsWP
 Ly6jamSg6tvrdo4/e87lUedEqCtrp2o1xpn5zongf6cQkaLZKQcBQnPmgHO5OG8+50u88D9I
 rywqgzTUhHFKKF6/9L/lYtrNcHU8Z6Y4Ju/MLUiNYkmtrGIMnkjKCiRqlRrZE/v5YFHbayRD
 dJKXobXTtCBYpLJM4ZYRpGZXne/FAtWNe4KbNJJqxMvrTOrnIatPj8NhBVI0RSJRsbilh6TE
 m6M14QORSWTLRg==
In-Reply-To: <20251024090902.1118174-1-lorenzo.stoakes@oracle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 9BA9EC000B
X-Stat-Signature: yeksj3jfmymraa7ibsztp7cqgasoiapy
X-Rspam-User: 
X-HE-Tag: 1761724922-68275
X-HE-Meta: U2FsdGVkX18PRunaHkF0OpRCO0R7KUKzL+0aunRqdAcy7FVP1ssUxQU4gHSYW5IFKRTVMn56h98OCkD8Ita/betHq00vjueTb3HuLbGztbQyhfrkz33jEUAyULRlNEXSqpb++HvYMv9QKxoBQCDRo5IdzoHW3g9l+WmhzcjCPvAWiExaAzSDqilMMnmMuDiLzzZJrAeB1oovBN9o2xA4gxl1oJAd7a9F5iZPaGWc3A0iJL7gsDhoyB19qffMSqDTe95jO0C5JCxNZLc9WNeTpWM03QPhnXJ3NpLM/m3aNIlTlrL+Sr7wYJLuEWy3rSnamyfh872Y0zzd2kSRKJ3zePNm7vKPKqaBbbRwDXJQtBPGrPHvWWDB9vjpjpIM92t033Ay0FIZUaUzm6RYsfmQ93bQLj6/oMe5G/ZRk0c1wPJ5mSvSDDSrisMBAvSuLhTTbopfTNofauVOWNAPYMWDtxqPTClfCJxVnWl+IBO+O1AZ/N1PwncWfcm/Pb9oxZZqREMhkS4l3yzYX6ktzXPblc1k2zRfzS2IQD4zLjUR9pmBg0MOQPpprhNqivDxYRZQMmasAYzIcyDRjxRJSetG2rZCoIXgGt3KlgnXGcZZLEyJUGdzz+fEQ5oExHgCVGSiTYuB2f9FO5wTbJNTjsl/PRbvdhRKvPi9eIdsRzB2x8G6bZXJ3XcZKgYvtUB5FnAW4zfxS2oMy+h4cCKyKvBz+72e4YFDarB9st9KzayAh9DNjxUzPgQilAtVh0Qdm+4oclvBTv/VitvVCRXCQDnS8IJlOTXHi3FaiAcYyd5HtKBM7GMMw7LA+8BJ7ZUE3/ZtSy0mGYjtvr/p8iyBBYk6pHPy8VAn/49rsRq5syRyEjOtVLwk1JcySgclj4XuWV/99DBZeTksPj27OmuoOc2wHqkJDSYN8kJyFzGFNWp7aj2lpZYtTRjfEAQiYxIvYX/mWf4gEraiEc6KbhZTp4v
 YIDzcJ4N
 +CVKr33SpV7vtCUS+mMZmepQJ8uHzBhzQR9JzcRf63EaV7m0mv3acF9nApCkGs6ua6J4tVhRvKyh6lOnzIFVTv8QqHNUW3gaPKeWMtm2j+58At1tEKEkOBB2yJ8s+WdV5KkgDfuhtFtK+YGZtkzYh9lk0obzw4hc3kQXs2K2CTL0lEnJ//fpn1nLjmKA63t8n6gA1j0fZ/EeXZMXzsqxpX+iErhYKoxiAWQda+lIWsSes6wcGXZeMgBf1xbDTbyJDfhxjK/RaH3+CJ4CG6u9Qk8vwAdKe0WYh3psPYEK8qFP5rx30jwlDBda+F0aSSCjhbxsXpqcgP5yz0I9CNpAdCEMvFp+ouTsEv6TYALClkdWcJPkuOIZX0qJHIzbko5CLBpZR
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 10/24/25 11:09, Lorenzo Stoakes wrote:
> We declare vma_start_read() as a static function in mm/mmap_lock.c, so
> there is no need to provide a stub for !CONFIG_PER_VMA_LOCK.
> 
> __is_vma_write_locked() is declared in a header and should therefore be static
> inline.
> 
> Put parens around (refcnt & VMA_LOCK_OFFSET) in is_vma_writer_only() to make
> precedence clear.
> 
> Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>

Reviewed-by: Vlastimil Babka <vbabka@suse.cz>

> ---
>  include/linux/mmap_lock.h | 7 ++-----
>  1 file changed, 2 insertions(+), 5 deletions(-)
> 
> diff --git a/include/linux/mmap_lock.h b/include/linux/mmap_lock.h
> index 2c9fffa58714..e05da70dc0cb 100644
> --- a/include/linux/mmap_lock.h
> +++ b/include/linux/mmap_lock.h
> @@ -130,7 +130,7 @@ static inline bool is_vma_writer_only(int refcnt)
>  	 * a detached vma happens only in vma_mark_detached() and is a rare
>  	 * case, therefore most of the time there will be no unnecessary wakeup.
>  	 */
> -	return refcnt & VMA_LOCK_OFFSET && refcnt <= VMA_LOCK_OFFSET + 1;
> +	return (refcnt & VMA_LOCK_OFFSET) && refcnt <= VMA_LOCK_OFFSET + 1;
>  }
>  
>  static inline void vma_refcount_put(struct vm_area_struct *vma)
> @@ -183,7 +183,7 @@ static inline void vma_end_read(struct vm_area_struct *vma)
>  }
>  
>  /* WARNING! Can only be used if mmap_lock is expected to be write-locked */
> -static bool __is_vma_write_locked(struct vm_area_struct *vma, unsigned int *mm_lock_seq)
> +static inline bool __is_vma_write_locked(struct vm_area_struct *vma, unsigned int *mm_lock_seq)
>  {
>  	mmap_assert_write_locked(vma->vm_mm);
>  
> @@ -281,9 +281,6 @@ static inline bool mmap_lock_speculate_retry(struct mm_struct *mm, unsigned int
>  	return true;
>  }
>  static inline void vma_lock_init(struct vm_area_struct *vma, bool reset_refcnt) {}
> -static inline struct vm_area_struct *vma_start_read(struct mm_struct *mm,
> -						    struct vm_area_struct *vma)
> -		{ return NULL; }
>  static inline void vma_end_read(struct vm_area_struct *vma) {}
>  static inline void vma_start_write(struct vm_area_struct *vma) {}
>  static inline void vma_assert_write_locked(struct vm_area_struct *vma)



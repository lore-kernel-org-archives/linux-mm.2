Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BA0DBCD585A
	for <linux-mm@archiver.kernel.org>; Wed,  7 Jan 2026 11:43:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1348D6B0099; Wed,  7 Jan 2026 06:43:23 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 113FF6B009D; Wed,  7 Jan 2026 06:43:23 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 015B36B00A0; Wed,  7 Jan 2026 06:43:22 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E307E6B0099
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 06:43:22 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 959841A02E6
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 11:43:22 +0000 (UTC)
X-FDA: 84304982244.24.716C589
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf08.hostedemail.com (Postfix) with ESMTP id 16C7D160002
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 11:43:19 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=slLWsE6I;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=+fH55pNq;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=slLWsE6I;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=+fH55pNq;
	spf=pass (imf08.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767786200;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HP5iOFWigyyHdMk0fMVZgSA96wcLk4dUN4Yd9D7Dqac=;
	b=1pBNW1VuvipWnxj+1qdDwZDiwAFgQAdQHvEzzuAfcAH39Au4S4oha/XjcxBNkFG9aTqqzJ
	ct8df/MXPraIpYp5KinxMZRHnC02wEb7LIKpY+NEJ1rLQU7pXA+wSJ6ZvQuJ6sdiccs5vU
	nltwDPpH9sH++Qs/rp8/mZ2nEykpDFc=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=slLWsE6I;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=+fH55pNq;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=slLWsE6I;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=+fH55pNq;
	spf=pass (imf08.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767786200; a=rsa-sha256;
	cv=none;
	b=p1OluKOnytq8hRBQodTb0unoRG25g4R+yS3Ls5rMYOjKOYWQRzUNjLMdQlVPTEjKZhoBTC
	TUlW32d6GTRuD4wqk0GwKY657WxMS0sFCUX2CRB6km5+8C3jhCGE2/JGfFF7n9ucITtF3T
	83g4xBO9aCzySallXbytGW7Lp0+Rt2s=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 483715BE2D;
	Wed,  7 Jan 2026 11:43:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1767786198; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=HP5iOFWigyyHdMk0fMVZgSA96wcLk4dUN4Yd9D7Dqac=;
	b=slLWsE6IA4HrnC/+3AnDwSnNIC/SYT01MYQIHrNUvto4luJirwJuq9dJvdkjm0VTI799bq
	t9iCPDYY7yLS3tpR24yJp67pJPVW9+Q+OGVuRnC15fsgJhihtFHlaUXPg5wKH0jmkIvZqq
	GC8GF2kNjuvZ2rOKunBA61AlwoSDI9Q=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1767786198;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=HP5iOFWigyyHdMk0fMVZgSA96wcLk4dUN4Yd9D7Dqac=;
	b=+fH55pNqLCtoXaA6LScKkANSV+qeZmJwHtoiylnmFutu8Syi1ilJnJMye5IF2mrWx+3vta
	wT2LwOcMZs82I2DQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1767786198; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=HP5iOFWigyyHdMk0fMVZgSA96wcLk4dUN4Yd9D7Dqac=;
	b=slLWsE6IA4HrnC/+3AnDwSnNIC/SYT01MYQIHrNUvto4luJirwJuq9dJvdkjm0VTI799bq
	t9iCPDYY7yLS3tpR24yJp67pJPVW9+Q+OGVuRnC15fsgJhihtFHlaUXPg5wKH0jmkIvZqq
	GC8GF2kNjuvZ2rOKunBA61AlwoSDI9Q=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1767786198;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=HP5iOFWigyyHdMk0fMVZgSA96wcLk4dUN4Yd9D7Dqac=;
	b=+fH55pNqLCtoXaA6LScKkANSV+qeZmJwHtoiylnmFutu8Syi1ilJnJMye5IF2mrWx+3vta
	wT2LwOcMZs82I2DQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 175853EA63;
	Wed,  7 Jan 2026 11:43:18 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id e+dgBdZGXmlpIQAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Wed, 07 Jan 2026 11:43:18 +0000
Message-ID: <1372138e-5837-4634-81de-447a1ef0a5ad@suse.cz>
Date: Wed, 7 Jan 2026 12:43:17 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V5 1/8] mm/slab: use unsigned long for orig_size to ensure
 proper metadata align
Content-Language: en-US
To: Harry Yoo <harry.yoo@oracle.com>, akpm@linux-foundation.org
Cc: andreyknvl@gmail.com, cl@gentwo.org, dvyukov@google.com,
 glider@google.com, hannes@cmpxchg.org, linux-mm@kvack.org,
 mhocko@kernel.org, muchun.song@linux.dev, rientjes@google.com,
 roman.gushchin@linux.dev, ryabinin.a.a@gmail.com, shakeel.butt@linux.dev,
 surenb@google.com, vincenzo.frascino@arm.com, yeoreum.yun@arm.com,
 tytso@mit.edu, adilger.kernel@dilger.ca, linux-ext4@vger.kernel.org,
 linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, hao.li@linux.dev,
 stable@vger.kernel.org
References: <20260105080230.13171-1-harry.yoo@oracle.com>
 <20260105080230.13171-2-harry.yoo@oracle.com>
From: Vlastimil Babka <vbabka@suse.cz>
Autocrypt: addr=vbabka@suse.cz; keydata=
 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
 m6M14QORSWTLRg==
In-Reply-To: <20260105080230.13171-2-harry.yoo@oracle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Action: no action
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 16C7D160002
X-Stat-Signature: ogrocxx18ncr65h7hnjeoyuatcrj7bfd
X-HE-Tag: 1767786199-602428
X-HE-Meta: U2FsdGVkX1/FQlQOzh/droYlL85wbKsfLtDj9KkiJpTzZOqxo39SYzIHZHQRG6UA+YY2J3zRZ7o/7EIhF6vtZXfBAuch3KLHt5MxIYBhufTdt7MvqolNUmsfuW6oPkXyBJxawqr0jTG1y9as0BuVTHhY+apzbZlTKYRF4yO3/KSeLWIVodCzhSICtEd4P13ARerjKYiTdWnPj/aJzT8NNsysATuJKv3Yj+wqLLygl7evNf95XjzNMjFqa5GmMcVCBV9ZTzOELQVUHmuKZI3+5YbLCkDJGSDh9iW9XYRPsRlZtRPRAYqt81N1uJEIrHWgihYxDEbYORDTnZYt7BYpukiu1NE8IhTO07xds+4PcT6oYqvTyPuaJFP1z+tqH0w+Lrj2FmHMwLQ3TcED2UE5i7R5dN07Rc0qugljTQVOUB+99YwKt8MtB8w0YB+88fiCHkFXPEYNsoCwjGeY/MFID+jJe8MQ9hnwxSo3aUL7jG8xJG5mSYfuCpk0HaPcR5xYDsQtSs4y0F7F4Ui4DLvMbmlGSXlgrVS5qxQcQdOEdTgEkav9cDOfsHRec4IuaLAKRCR9OdWzeC0GmzdrtfWH0s/NxP2ASeGxJRLoyEqRBaxwkO/UQ+YF6mjEJB7WiIzgnES0OtmhBncyYQRjabGqrAeEAgX3kf5BwS4Ve3UUby+k7O1CE71mNcr0dHE8ITq8fW2aLbHJH6gS8KYhZl076PE1EXMkRMLUJfqpk1/Y6ZaknF/t0ByOXR55VwOE2BdgF0wgsuIH6npkpkMVM+fHTewTopnFEjZ0x2J+70BuztSl/X7b8RKS+m3aIwQ1hO1CLJXTi80EfJCbNlR2crOkGWz7pWgOxZnVccaT7I3crpviaFD5OrFSQ5l9jY2aLk3iynBs7Ppu1uwUg94U22VHZa4NYcTQUIr228WHeUWapTUhfyoC0FtBQ+YyxWmj5TIkq+1Ho9hDfrKT1Ik3daZ
 E++KQM8c
 ZHJJ6YdbqfeuWU+si3QE2HdARcrk3UiDaRsiYR4AEdPb0o8Mu9Hw+zFPUqJ5njxUCvOT4qAaZEgBwd2d+a0kxNXtdw9emY4A5Tkqc1SfHYO6UAOLQGYDdktmjW4gbDBUkzBW97aUJCZZAJxs6Udl55v+bl70wUrWRAgq2S/5ln5Msu0CNVtmXoxGJAqh0WWmgkYb+RdGlq/8iOCJ6wWmucpBkKtqPIODmPZaJJgK1JmCxLR0j1d+kCR989GTD7It4j5FCdzx7Ve4HixON43ZKuuO4sfcgC5QkZthqWQY5C0crZFavZZogp88vYBS19D8YFSCs2KUbo5DnhZpBq7dW9KUyKVMBHW5W1araiFDciZltkIZ8TZt4JbwOgoVGIMJTTp/w8e+bl9s5yvFFd/iYQzUukspMrqDOl0yOG3aemjU02Ejete0HWNPUXRdsemkaRQrR/ACnaM9fVH6sMB6h8qyz37M0EgyVTUFB
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 1/5/26 09:02, Harry Yoo wrote:
> When both KASAN and SLAB_STORE_USER are enabled, accesses to
> struct kasan_alloc_meta fields can be misaligned on 64-bit architectures.
> This occurs because orig_size is currently defined as unsigned int,
> which only guarantees 4-byte alignment. When struct kasan_alloc_meta is
> placed after orig_size, it may end up at a 4-byte boundary rather than
> the required 8-byte boundary on 64-bit systems.

Oops.

> Note that 64-bit architectures without HAVE_EFFICIENT_UNALIGNED_ACCESS
> are assumed to require 64-bit accesses to be 64-bit aligned.
> See HAVE_64BIT_ALIGNED_ACCESS and commit adab66b71abf ("Revert:
> "ring-buffer: Remove HAVE_64BIT_ALIGNED_ACCESS"") for more details.
> 
> Change orig_size from unsigned int to unsigned long to ensure proper
> alignment for any subsequent metadata. This should not waste additional
> memory because kmalloc objects are already aligned to at least
> ARCH_KMALLOC_MINALIGN.

I'll add:

Closes: https://lore.kernel.org/all/aPrLF0OUK651M4dk@hyeyoo/

since that's useful context and discussion.

> Suggested-by: Andrey Ryabinin <ryabinin.a.a@gmail.com>
> Cc: stable@vger.kernel.org
> Fixes: 6edf2576a6cc ("mm/slub: enable debugging memory wasting of kmalloc")
> Signed-off-by: Harry Yoo <harry.yoo@oracle.com>

As the problem was introduced in 6.1, doesn't seem urgent to push as 6.19 rc
fix, so keeping it as part of the series (where it's a necessary
prerequisity per the Closes: link above) and stable backporting later seems
indeed sufficient. Thanks.



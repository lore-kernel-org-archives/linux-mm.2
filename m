Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 69F4FCCFA1A
	for <linux-mm@archiver.kernel.org>; Tue, 11 Nov 2025 22:18:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 912718E0008; Tue, 11 Nov 2025 17:18:41 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8EA7B8E0002; Tue, 11 Nov 2025 17:18:41 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7FFEB8E0008; Tue, 11 Nov 2025 17:18:41 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 6FB528E0002
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 17:18:41 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id D93CA4BAFE
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 22:18:40 +0000 (UTC)
X-FDA: 84099741600.03.4C53A42
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf21.hostedemail.com (Postfix) with ESMTP id 469611C0008
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 22:18:38 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=NFCnAd0C;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=CxyDphfL;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=NFCnAd0C;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=CxyDphfL;
	spf=pass (imf21.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762899518;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GicdksCSyjI82vUkF0Oi03JhVOMlvz+IX5VHtm4eASA=;
	b=tGrKXDDKCigf+jfy1RC4WaJKkh9obGo3PnqkToJ63hrTXEJmzWBWVDhYa5jCBD3xnc14KF
	jjtZ0oxFE/lg2TCQd0BgIWTgv1tGXDA+G1LwgsW0hCTWphYT3TglqVDqqF7hEiJJzQyWJA
	VCaBQVCtIueH0EH2S2wb7aWIKSV/eCA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762899518; a=rsa-sha256;
	cv=none;
	b=0YtbQY4ZAT9AwlWvcUvvnt9VDt8LUOGl6XhdxJB+4ppsDD2fSHOWd4WcjWnCAgFMvuQxwZ
	xeiIvPL9c4VGmbJg0r+i9hwr7PMR1HdyOuTMvZEQaQSkkijR1xrptNhRlf36/VayHDhqyG
	mfzniEv0RRuLYDL04Qnqlm7anV2SDnk=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=NFCnAd0C;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=CxyDphfL;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=NFCnAd0C;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=CxyDphfL;
	spf=pass (imf21.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 11BDE1F458;
	Tue, 11 Nov 2025 22:18:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1762899516; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=GicdksCSyjI82vUkF0Oi03JhVOMlvz+IX5VHtm4eASA=;
	b=NFCnAd0CdU+wg3CFf3WCxS3+vuWYLoBI2PXiNTQ3Q/ofKTjPtRvznMzcsWTd5gFZVYKixH
	I8OqOwM/K8jiD8gC0xphwKIZTqlXmG6TXeZYnL2RRdmQV++Qj7G9979n2lNByBk/jxS6Wo
	riFP0fp/zVVMr3T+vZ9ldUcGsMx4Bxs=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1762899516;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=GicdksCSyjI82vUkF0Oi03JhVOMlvz+IX5VHtm4eASA=;
	b=CxyDphfLW3AsRB2q4RGIcsWDAK20PWCDYLJtNdZth2+v6u1xkPsdzbAo/QlqsS2QQj+A32
	Fh7g8HeIZDG/rACg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1762899516; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=GicdksCSyjI82vUkF0Oi03JhVOMlvz+IX5VHtm4eASA=;
	b=NFCnAd0CdU+wg3CFf3WCxS3+vuWYLoBI2PXiNTQ3Q/ofKTjPtRvznMzcsWTd5gFZVYKixH
	I8OqOwM/K8jiD8gC0xphwKIZTqlXmG6TXeZYnL2RRdmQV++Qj7G9979n2lNByBk/jxS6Wo
	riFP0fp/zVVMr3T+vZ9ldUcGsMx4Bxs=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1762899516;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=GicdksCSyjI82vUkF0Oi03JhVOMlvz+IX5VHtm4eASA=;
	b=CxyDphfLW3AsRB2q4RGIcsWDAK20PWCDYLJtNdZth2+v6u1xkPsdzbAo/QlqsS2QQj+A32
	Fh7g8HeIZDG/rACg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id EC89414BB0;
	Tue, 11 Nov 2025 22:18:35 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id WbznNzu2E2nNBwAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Tue, 11 Nov 2025 22:18:35 +0000
Message-ID: <8219599b-941e-4ffd-875f-6548e217c16c@suse.cz>
Date: Tue, 11 Nov 2025 23:18:35 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/mmap_lock: Reset maple state on lock_vma_under_rcu()
 retry
Content-Language: en-US
To: "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Suren Baghdasaryan <surenb@google.com>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Shakeel Butt <shakeel.butt@linux.dev>, Jann Horn <jannh@google.com>,
 stable@vger.kernel.org, syzbot+131f9eb2b5807573275c@syzkaller.appspotmail.com
References: <20251111215605.1721380-1-Liam.Howlett@oracle.com>
From: Vlastimil Babka <vbabka@suse.cz>
Autocrypt: addr=vbabka@suse.cz; keydata=
 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
 m6M14QORSWTLRg==
In-Reply-To: <20251111215605.1721380-1-Liam.Howlett@oracle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: jhmm8by7toqkaz18rrzyrb91q1ty4coo
X-Rspam-User: 
X-Rspamd-Queue-Id: 469611C0008
X-Rspamd-Server: rspam01
X-HE-Tag: 1762899518-209301
X-HE-Meta: U2FsdGVkX19CA5xFUH6mzEJmjf8+oxMuyCCPsyj1oZA7ONcNttafST9Wnse8lyKd2te6LR7oQP2e+K0s8YCrrEy061Y7j7baoHHGrDobNFr8lczexfcxQtsloH1voiga61+9dqLJpBv67rtynBH4GOaZTrd2s9Q0YkAgVFHMTu0lQDKuYnktBMADJDN8Hqw9dUh22vXOGwdq8Ryw0upWKC8rSv8jSuUclmLg5XD/SX5NLYfoVSZVQjgQyluhH0wEZoWJEKOyDnoIvuGtqztCoYSSyypzm5EO/X+Sm4IRXqpDYTSEUSP3EIjrVL0kP5UQgOENS/40V6aYjsa34RPCIHRoyfxdVk2HEiek4PPdRRK21pcKsbdtih1OcPe6nbrhh6gQLDGzgtALZrBoXy8rTOCPQI9/At3pW3xaCMc7uJwntI9cGv6f8ONYzDPN/P7Uv4aM3yMZkvTgcLj0YbxuJN0zJCzRtn5ZaqN8TRsz1jCjWDkfcQQvZb022X0U0M1kR5t8e52BLzD5/9Dq8pkNoOv8+SLn7FC+zRBAhstUNcGGrKWcVx0Eb9tBl7eVnpF6Qxy7JRdPgQkicGveR/4tzFKMUuxFJIV3bNFgv5t7uPBvAlhb197pyP5n4xmLzSPAZOxVar6DgttNN5x6PZDaY3Cr9eb0G8IyHYuNOWHQqexRS1oNtG3v2Jtr/QjeJFpC1RH45ovUTISE8OCx9MUxa8POfLnN7+M3yHP0/vgJlCsjtc34n/vSKjSLg639fbEdTTyDhbea8Mq4ETjgmC1VMZS0VAzFUBlZXKqbrQ28Q31k86kGX1rUaZ4rhEZn5w3fUnDG4G/6yACF5Lhym5rYvmOI0vGAmAWJrH1UZ0JiKi4udtnNbdLHNSdlH8D6hLkeYvqKXpPzXQsnAxImGT141Ps5CKJGBwAjPaoyj11RfUGbuEnp+/ZtqSGBrza480DyhEfMMJVmeUoJmguV3oc
 hzIjLTwu
 2Y84Lx/wUk5uzk/NMZcKBoV8tv2wyS2pVbStfBn9g43l5NPApmF+TIwqXTa3F0AqpjzT99yXvPcfrmsRKwKpvDRj8TLF0SmXyUKODMbtcRpTpeOoANDf1+eRZ5rvDORFTCttAOEm/mCRpIjxP4rPvb3l6PM5MyxpeP4j5iNKvfscgzr2TG+YS33hfQ31nJZDqOe65mGKdfGJ/aWRi5tWahVFbNted2Gid8AcOfsYOab4SKrus5qu7FmZjh5RwlEDGzsBiPSzvN7wTAMZbsJbIgMaBKnDElbAtnK+afOcPbQUUz4UFVuxSid1wYXz1r4V8faoYFoxl6lawyFxx1r/mRMBgQ9W+GxaqOjMMqT5R0m50LSixcZ5NUvxMrbJX2kHEVeWtbT5DkFepPhhH1egZvOwFsFZPeaRvqLP+xIManNa3pSEthh3YI9QfiHwsJEPrbQxOSEhv+0vJZ1LqHOt1Bok4lSzhL3LgJDiqerXED90M0UcIDz14VqgYxMdDmOtWde5xx8UitDlSjNl3YkAu2434RPOs2rGWhb7qYbQiHcIgiVLSkcJ8Weo+kOsRHbL667RFVEPGX9pecd0QpNSsjHXBIQqgakUbQscDXpm6iE13ByrvuLhSmvU/gRU1FvGP2ZDKettGNFhTiGY7s6eWKUvU/g==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 11/11/25 22:56, Liam R. Howlett wrote:
> The retry in lock_vma_under_rcu() drops the rcu read lock before
> reacquiring the lock and trying again.  This may cause a use-after-free
> if the maple node the maple state was using was freed.
> 
> The maple state is protected by the rcu read lock.  When the lock is
> dropped, the state cannot be reused as it tracks pointers to objects
> that may be freed during the time where the lock was not held.
> 
> Any time the rcu read lock is dropped, the maple state must be
> invalidated.  Resetting the address and state to MA_START is the safest
> course of action, which will result in the next operation starting from
> the top of the tree.
> 
> Prior to commit 0b16f8bed19c ("mm: change vma_start_read() to drop RCU
> lock on failure"), the rcu read lock was dropped and NULL was returned,
> so the retry would not have happened.  However, now that the read lock
> is dropped regardless of the return, we may use a freed maple tree node
> cached in the maple state on retry.
> 
> Cc: Suren Baghdasaryan <surenb@google.com>
> Cc: stable@vger.kernel.org
> Fixes: 0b16f8bed19c ("mm: change vma_start_read() to drop RCU lock on failure")

The commit is 6.18-rc1 so we don't need Cc: stable, but it's a mm-hotfixes
material that must go to Linus before 6.18.

> Reported-by: syzbot+131f9eb2b5807573275c@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=131f9eb2b5807573275c
> Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>

Acked-by: Vlastimil Babka <vbabka@suse.cz>

> ---
>  mm/mmap_lock.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/mm/mmap_lock.c b/mm/mmap_lock.c
> index 39f341caf32c0..f2532af6208c0 100644
> --- a/mm/mmap_lock.c
> +++ b/mm/mmap_lock.c
> @@ -257,6 +257,7 @@ struct vm_area_struct *lock_vma_under_rcu(struct mm_struct *mm,
>  		if (PTR_ERR(vma) == -EAGAIN) {
>  			count_vm_vma_lock_event(VMA_LOCK_MISS);
>  			/* The area was replaced with another one */
> +			mas_set(&mas, address);
>  			goto retry;
>  		}
>  



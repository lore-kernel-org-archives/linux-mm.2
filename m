Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A9271C83F26
	for <linux-mm@archiver.kernel.org>; Mon, 28 Jul 2025 17:39:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3B3356B0092; Mon, 28 Jul 2025 13:39:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 363496B0093; Mon, 28 Jul 2025 13:39:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 22A996B0095; Mon, 28 Jul 2025 13:39:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 0FEE56B0092
	for <linux-mm@kvack.org>; Mon, 28 Jul 2025 13:39:14 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id DA98380397
	for <linux-mm@kvack.org>; Mon, 28 Jul 2025 17:39:13 +0000 (UTC)
X-FDA: 83714384586.03.93B2464
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf12.hostedemail.com (Postfix) with ESMTP id 8C5BA40005
	for <linux-mm@kvack.org>; Mon, 28 Jul 2025 17:39:11 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=dU1kCy4F;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=xyvx5dve;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=dDICnoYB;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=xZdtLFmr;
	spf=pass (imf12.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753724351;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lL4siaau5wOEVET5dKMaw6NZ1FZ9vg0WIn0ATanWYck=;
	b=jqs2TRie89T6ogL0yJcDuZCt7abISocNJGWxWnRU+EkuLGC0EBtWPGLHLtIOOC0L2L8TgF
	mNYuDyOtQdh64SZrb7Hs0t5xg6aqnkodfewzBXDTUe7TbGjSUIWgZEmD+P4oSbKKpomFYL
	s+73UaXAYDoicZL+isYzitHDuuh2YGM=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=dU1kCy4F;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=xyvx5dve;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=dDICnoYB;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=xZdtLFmr;
	spf=pass (imf12.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753724351; a=rsa-sha256;
	cv=none;
	b=cQn56r2Gj6f72WIaNsBlSDjFLKxSjSUw6I7XvquqOcdX7HKnHZBtCO6ebiGG1cge2fWwpG
	UyNXNZrvS4uhATY7tzaHKTe6EPmKHdcXXAuPwolqcLWWTFVmoJsbxhw5l+PyrHm/mK4UYk
	nEttCI0nfCBtT2EIPpDvDa6mHYCD3f8=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 0485E1F7F6;
	Mon, 28 Jul 2025 17:39:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1753724350; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=lL4siaau5wOEVET5dKMaw6NZ1FZ9vg0WIn0ATanWYck=;
	b=dU1kCy4Fn23H52okP8A5jmPCjG3ogzRd10VFJW0i/DRGS053+IipkQIoxdCTtiEp94E5kb
	+fFQGuLVAoodLiQEhqzUNyC0/GBu53+zViHevvvvf0Hib6e26A8BIByk+vsp6HIqIAICT7
	u8v+RaTQlaMTJ5IuVC9gt1fYcfXonb8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1753724350;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=lL4siaau5wOEVET5dKMaw6NZ1FZ9vg0WIn0ATanWYck=;
	b=xyvx5dve/ivffkZDkBM3UGEiRz54a9aKeKFd6rQmqhXxkAX/jn2UgdZgEPDlFf+6pRHu3C
	OuQzQBlPgbdKRvBg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1753724349; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=lL4siaau5wOEVET5dKMaw6NZ1FZ9vg0WIn0ATanWYck=;
	b=dDICnoYBIIAPCPByr25lNNST7qldql5YP9XwitUz5OHX1W1ppzgelpWbN/+bSQE0qXB6Kk
	ly4h8mKE8Smw/R5tnhl4+7IotO0arqEkSuILOKSzhfEdl7ETqdFxr6/Czj6Geg2Wps6eYY
	SiwRpMYA9DRMTZUV/6p8DZHBpXrTA7E=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1753724349;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=lL4siaau5wOEVET5dKMaw6NZ1FZ9vg0WIn0ATanWYck=;
	b=xZdtLFmrvE0WuicdsBclMs/0ccLeoiW/k0S+3dVEX4PpNK4wx2RFd4YADRrJ8YloWLKBs8
	4qTiX/2skWsrP3Ag==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id D43601368A;
	Mon, 28 Jul 2025 17:39:08 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id Ulj7Mry1h2jZTQAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Mon, 28 Jul 2025 17:39:08 +0000
Message-ID: <97938dc6-5dfe-4591-ba53-3729934c1235@suse.cz>
Date: Mon, 28 Jul 2025 19:39:08 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/1] mm: fix a UAF when vma->mm is freed after
 vma->vm_refcnt got dropped
Content-Language: en-US
To: Suren Baghdasaryan <surenb@google.com>
Cc: akpm@linux-foundation.org, jannh@google.com, Liam.Howlett@oracle.com,
 lorenzo.stoakes@oracle.com, pfalcato@suse.de, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, stable@vger.kernel.org
References: <20250728170950.2216966-1-surenb@google.com>
 <3f8c28f4-6935-4581-83ec-d3bc1e6c400e@suse.cz>
 <CAJuCfpGZXGF_k_QVQqHWZpnypB-sWB8hwZeOYMOD0xmAFOBxkA@mail.gmail.com>
From: Vlastimil Babka <vbabka@suse.cz>
Autocrypt: addr=vbabka@suse.cz; keydata=
 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
 m6M14QORSWTLRg==
In-Reply-To: <CAJuCfpGZXGF_k_QVQqHWZpnypB-sWB8hwZeOYMOD0xmAFOBxkA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 8C5BA40005
X-Rspamd-Server: rspam06
X-Stat-Signature: 7mhmbk4wt6rmydphs6em64obddp8frie
X-HE-Tag: 1753724351-223635
X-HE-Meta: U2FsdGVkX18DlYPlpAIfrB0z8g6EhrIilsfYmMEYtxyXSbqA1cv9bzK0ukhqKdNt5+SNcYnrpkeWuYI6y0VfaG7phWewklD5TTho+ggCCaOAIxDUDSJmzNBXFB18P5PTRyOKDXlYWgVXVNkRhmx4hKcUtQlXz/4sd5uTlDx68abZ8eQQH0AP/RODgL26kcheAIFtH7bv1lZjii8Ud6tMH4hNlzlinO4+BsDrRAGrLNLRw1ayeW6gbN96e2b7KbnC4WGSE3rVyercgCWH9Cru+wrl2opuwVzTvt8F7lAmErj3kl8skbMnSucdICEE/Mdq8jhehG4kyw2ONFsC+i4n1qPHRWK3VcTDThdHdzi827zFOgxw/NOumIjdw/i61ouEFe8nBDO+IeIBmd8MuOqmBzqkxcSmRYtSLoOliCjyaG2yJNKVJWPs+AHjJ8DRvIF3k6wboQRuQd2WLTRCMnhtrleUw1NSpviCzAkbQIwEH7B4qy+AYcVDNW/GlwwLhuL7lQjB4ZkuCh0e1MSf/Dja0nfs3LCZs94PxSCXnrVwnPkRjLlPqRAWoAKnx4BbpKo5TabDb8WtWiMIeALiTR4OvJ2F30y1x+JDJuLRYiO/jYu8T5BdC1rN9g88TIYLbAONMbmMC0+GcSJziaRz+rBeZKn1YxUOPrinFYaH6xUvkpQZCuYXx3o9I11u+HYc2+ymYRshSDr50p+pWGgaHT9XfeIE6lfoFXi+G/miKS87NEFELA9uCPlR00baV3QA5F0v7WulUBBNVEcMfxflJIdWXQcdtCSCJo28vC1OAP4QIwhoGZq4xY4AnKRePDMnJFpMnUPl+xjyGAxA0GqGU3MNZNDMRZsvpLHbedlcPeDxXyJ7OJaR5Rocs6rZVc17dvuHyxsrdZznSjrUy/9kAllK3N4wI20CcNnsZ0cKFkjyPzXdH7aZtiA9IgV6HGsVxqY328D9qzO36NDTFXtsh5X
 3I5kshtk
 K7INXvAjN0iA1ILLtiZ1DNcpFkcqCT22/CGL4CTK8tp5+9QZ22CHkEi1SFMz0kgNqJOIkZcQ2YOqLT/3zMulXPre61ZOvQdCqvDkTaYfhO+i4co2A3jmsUFtGfnGB58iyroceYgQPiCfij/MLTiBa6oM8TQ65BcQNHz9Dul8kHhkXs2qX/uBPFdF09hiuHkAkBOlflHxqjqrN8mzOyKFXCc78iKwKTrWwrB28c/YJ8UagEb++fEbMpT+w0Se7mSWKiy48+6ILqECpfYOjhwd7lqtFLMP8NPZ6WtJfA0tVg88A80wd7dPmhjNCCxaKApfthT/3oxM5rcjrj4QSDNWIO3mtj2IwSJ3dPPcV
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/28/25 19:37, Suren Baghdasaryan wrote:
> On Mon, Jul 28, 2025 at 10:19 AM Vlastimil Babka <vbabka@suse.cz> wrote:
>> > +      */
>> > +     if (unlikely(vma->vm_mm != mm)) {
>> > +             /*
>> > +              * __mmdrop() is a heavy operation and we don't need RCU
>> > +              * protection here. Release RCU lock during these operations.
>> > +              */
>> > +             rcu_read_unlock();
>> > +             mmgrab(vma->vm_mm);
>> > +             vma_refcount_put(vma);
>>
>> The vma can go away here.
> 
> No, the vma can't go away here because we are holding vm_refcnt. So,
> the vma and its mm are stable up until vma_refcount_put() drops
> vm_refcnt.

But that's exactly what we're doing here?

>>
>> > +             mmdrop(vma->vm_mm);

And here we reference the vma again?

>> So we need to copy the vma->vm_mm first?
>>
>> > +             rcu_read_lock();
>> > +             return NULL;
>> > +     }
>> > +
>> >       /*
>> >        * Overflow of vm_lock_seq/mm_lock_seq might produce false locked result.
>> >        * False unlocked result is impossible because we modify and check


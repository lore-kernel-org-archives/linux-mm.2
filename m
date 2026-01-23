Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 849A1D74EEC
	for <linux-mm@archiver.kernel.org>; Fri, 23 Jan 2026 16:21:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AAECC6B050D; Fri, 23 Jan 2026 11:21:32 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A7BBD6B050E; Fri, 23 Jan 2026 11:21:32 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 966B86B050F; Fri, 23 Jan 2026 11:21:32 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 846686B050D
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 11:21:32 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 20B9A140401
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 16:21:32 +0000 (UTC)
X-FDA: 84363744024.05.69EDA48
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf02.hostedemail.com (Postfix) with ESMTP id 8C91C80015
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 16:21:28 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=kiL0wXJJ;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=WYSEuCkZ;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=kiL0wXJJ;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=WYSEuCkZ;
	spf=pass (imf02.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769185289;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=L58AJIr91oTMKf0PXTG1TbeTEeGFV9i4xfX9fFVLhOQ=;
	b=CUxjD5m2liXbbEAnW60MaQeXLMipRBpoBUX+afPQEaO1zU96vOFkJ8AL+PxUL4Q6legoqv
	U6Gr4H5BPkikhyMjsXfafZtDniQW8jxvmgW4GUbfcmtbOVhywLr3DxPSeNmE++L9eNHNAn
	8TqDbtUURDQjyc8wShsum/KALICSH58=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=kiL0wXJJ;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=WYSEuCkZ;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=kiL0wXJJ;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=WYSEuCkZ;
	spf=pass (imf02.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769185289; a=rsa-sha256;
	cv=none;
	b=Yx0aGQtv4EaEWPujToUSjdK+mLzT1Ym4w3F5gj5LdOUBjgvVb6FdZUBZsvUM/GFmMRlcXa
	1xVdcHgdu7mz5Sd3t9dUVzXZ/23SQggs9gMA5MqNNzisSaK1Bk1v1f2QLixHA5NL4xsC88
	8F5bpKWhaTabp+hoZ2unCXGyEH5d7ag=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 96E3C5BCCF;
	Fri, 23 Jan 2026 16:21:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1769185286; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=L58AJIr91oTMKf0PXTG1TbeTEeGFV9i4xfX9fFVLhOQ=;
	b=kiL0wXJJgh1HZq4TCsure9RERmyqII/kPjxCj0kIkQLBiE242PuXZ3NdmN1xgGJ41Jhas1
	IX9XioeqvhtuKVp4Y4/0oRdACHfLmwZBu5HPfG1Mik5FaZK0k1xHqTScO5NDFmVSttKrdj
	KLiereNzlxSMJ07q1vMvgC44Ag96riI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1769185286;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=L58AJIr91oTMKf0PXTG1TbeTEeGFV9i4xfX9fFVLhOQ=;
	b=WYSEuCkZ4kAULpe5Rjq1HbLNcgx3KwRNfSAE/H4jyWWJJiGYEXW0r0k+sDTJ6MSMWD0MBI
	LTTJ7lLo2MfeTSDA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1769185286; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=L58AJIr91oTMKf0PXTG1TbeTEeGFV9i4xfX9fFVLhOQ=;
	b=kiL0wXJJgh1HZq4TCsure9RERmyqII/kPjxCj0kIkQLBiE242PuXZ3NdmN1xgGJ41Jhas1
	IX9XioeqvhtuKVp4Y4/0oRdACHfLmwZBu5HPfG1Mik5FaZK0k1xHqTScO5NDFmVSttKrdj
	KLiereNzlxSMJ07q1vMvgC44Ag96riI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1769185286;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=L58AJIr91oTMKf0PXTG1TbeTEeGFV9i4xfX9fFVLhOQ=;
	b=WYSEuCkZ4kAULpe5Rjq1HbLNcgx3KwRNfSAE/H4jyWWJJiGYEXW0r0k+sDTJ6MSMWD0MBI
	LTTJ7lLo2MfeTSDA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 697181395E;
	Fri, 23 Jan 2026 16:21:26 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 9QNXGQagc2nMGwAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Fri, 23 Jan 2026 16:21:26 +0000
Message-ID: <b267b699-f312-4387-8dc0-a14efe72561a@suse.cz>
Date: Fri, 23 Jan 2026 17:21:26 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RESEND v3 08/10] mm/vma: improve and document
 __is_vma_write_locked()
Content-Language: en-US
To: Suren Baghdasaryan <surenb@google.com>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>,
 "Liam R . Howlett" <Liam.Howlett@oracle.com>, Mike Rapoport
 <rppt@kernel.org>, Michal Hocko <mhocko@suse.com>,
 Shakeel Butt <shakeel.butt@linux.dev>, Jann Horn <jannh@google.com>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 linux-rt-devel@lists.linux.dev, Peter Zijlstra <peterz@infradead.org>,
 Ingo Molnar <mingo@redhat.com>, Will Deacon <will@kernel.org>,
 Boqun Feng <boqun.feng@gmail.com>, Waiman Long <longman@redhat.com>,
 Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
 Clark Williams <clrkwllms@kernel.org>, Steven Rostedt <rostedt@goodmis.org>
References: <cover.1769086312.git.lorenzo.stoakes@oracle.com>
 <70dcf80f79ecd00a750ea17101061b0949119429.1769086312.git.lorenzo.stoakes@oracle.com>
 <CAJuCfpF1LthyP2FR4T8iDd+zOi1WAjqma2KBkHcCJsOjm+s32A@mail.gmail.com>
From: Vlastimil Babka <vbabka@suse.cz>
Autocrypt: addr=vbabka@suse.cz; keydata=
 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
 m6M14QORSWTLRg==
In-Reply-To: <CAJuCfpF1LthyP2FR4T8iDd+zOi1WAjqma2KBkHcCJsOjm+s32A@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Action: no action
X-Stat-Signature: 6mkp6nptrkqj4dfxbu54myx6bepx9tf6
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 8C91C80015
X-HE-Tag: 1769185288-835384
X-HE-Meta: U2FsdGVkX1+AC3+7l2WDy8cO+05/vEPOf4/TOQiQhgmY0jBDtLnKXlaJhRHCwSp3jH9p8YZUWMJfHw9D9iRzGQmMxDZKlrbl7SQMk4Bi4DbaOdlehi9iEHHngdZE8KzFLBLQHy5F2YVhnpvLSpxxxuKCU9sH4grmB5zCb8CqKxgrYxsFnombMOrll3px0VfypbKABg+oLiK7cm+EHk0w+3cRmwlxVa3iSEWPXhJMJ0va8cbYOUkFyPVFhhpFntc1RKFRZOz9zBhsN2e9sRxSylNVzmtftNnbDQe6zGjKGyv6iN+nIahCQbVZBw+g7rYMhWbc8qIf+W5Nmw2E+OfMzQGVsM6D8B0OcHwr7+LquqfzvPetZBpKcaYSYmYbkR+2jPMffZsYhRIbT6J9yLHnRgMvHSrvlV/3bQtDEWOwdRfUhy6jMKNuI+fB/qEWJmJDM2fwqpL7wYSJXlPSu4CpqQw4Xw0TezQVswDhVtY2ZbgRmUq3xbQwfG6Lu+zqRnRH/tbEZAdoyvCKS6FSoF1c65a1i3Ji3GPJSkLNqCSq8HZbTjILl5rE9HTDuoeg01+V2OII/ZMAPBr5rmGB1sbHLHb6tjuuJLX6NdeF5uTFqs+AXGxF6pCx3I5tZdXf2u0VqjIliqnzFpxoREkiHINchLHnDOjcJZH57cvC5P7B+aysI9k4cHN0GB+Sso13GcRjxSBEJ9sjNjwRfenVta39f3d7L8ZrEnztomq5wRCvxX9p63KtX3+DVzTh0VT9ZOHnvy/6oZraRgIJJTbfoQWJgXQgaiI1AtonZsSrZBbrup/t2VjqLJETrydKS9q1rNwnM4KR83s9IvCckwE2YxaOvX6/cqi40eRqTKoak9ZXpbou/gXdrbVcERADhtw30CypARhuVoyhvNS8yjhn5xl2tT7yf8Dihm0+t7xE0PHnJf5hd7v07CBuF5rifQPxUO0cLsxeYLCevk0VO05IL17
 4thQ+CL0
 lyOYRZG1YPl1zT7tOiFhsEE7FfRtYGO9oMtdl8xIb7c2Xgc5+usjvygx+QmD2ckmPU+vvIbOqY3lh71aRoKWFJKoATaeBPTgw8SqXr4A3fv7wp5KNT8sX09YFO+7RHAmS/lXGxqbRfvIjWS/NM1uWfHqhJodlOaOzKLM4Rq42mq+J8cSxKNxrYE42V5Lg/q50I3NxI8w/BXZK4Z81mkO9Nb8sc81Re+tdIjHjirmAjVFjP+3zzg3f92aBnhH0nLrUmFhwncvhsYR5b5scbXHGr8woDmEnxvLBKZMln5N07Y3cYCiIXqvsPKiA06iKEzgvOHAFX7+M6zkHPa9P5A/eqL56fody2j1Dqf5pJI5FHbrqL/qiuMNTJznO+wweaz6Kivcr6aHTNgntH43rD7K9TWblot3jwKeV1VfCNO+tYSAu3vtAJXgPYlGtorRY6/9huMPK403qfNcz22g=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 1/22/26 22:55, Suren Baghdasaryan wrote:
> On Thu, Jan 22, 2026 at 5:02 AM Lorenzo Stoakes
> <lorenzo.stoakes@oracle.com> wrote:
>>
>> The function is a little confusing, clean it up a little then add a
>> descriptive comment.
> 
> I appreciate the descriptive comment but what exactly was confusing in
> this function?
> 
>>
>> No functional change intended.
>>
>> Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
>> ---
>>  include/linux/mmap_lock.h | 23 ++++++++++++++++++-----
>>  1 file changed, 18 insertions(+), 5 deletions(-)
>>
>> diff --git a/include/linux/mmap_lock.h b/include/linux/mmap_lock.h
>> index 873bc5f3c97c..b00d34b5ad10 100644
>> --- a/include/linux/mmap_lock.h
>> +++ b/include/linux/mmap_lock.h
>> @@ -252,17 +252,30 @@ static inline void vma_end_read(struct vm_area_struct *vma)
>>         vma_refcount_put(vma);
>>  }
>>
>> -/* WARNING! Can only be used if mmap_lock is expected to be write-locked */
>> -static inline bool __is_vma_write_locked(struct vm_area_struct *vma, unsigned int *mm_lock_seq)
>> +/*
>> + * Determine whether a VMA is write-locked. Must be invoked ONLY if the mmap
>> + * write lock is held.
>> + *
>> + * Returns true if write-locked, otherwise false.
>> + *
>> + * Note that mm_lock_seq is updated only if the VMA is NOT write-locked.

Could it also say to what it's updated to? Or is it too obvious?

> 
> True, this does not result in a functional change because we do not
> use mm_lock_seq if __is_vma_write_locked() succeeds. However this
> seems to add additional gotcha that you need to remember. Any reason
> why?

Actually I wonder if it's really worth returning the mm_lock_seq and passing
it to __vma_start_write(), which could just determine it on its own. It
would simplify things.

>> + */
>> +static inline bool __is_vma_write_locked(struct vm_area_struct *vma,
>> +                                        unsigned int *mm_lock_seq)
>>  {
>> -       mmap_assert_write_locked(vma->vm_mm);
>> +       struct mm_struct *mm = vma->vm_mm;
>> +       const unsigned int seq = mm->mm_lock_seq.sequence;
>> +
>> +       mmap_assert_write_locked(mm);
>>
>>         /*
>>          * current task is holding mmap_write_lock, both vma->vm_lock_seq and
>>          * mm->mm_lock_seq can't be concurrently modified.
>>          */
>> -       *mm_lock_seq = vma->vm_mm->mm_lock_seq.sequence;
>> -       return (vma->vm_lock_seq == *mm_lock_seq);
>> +       if (vma->vm_lock_seq == seq)
>> +               return true;
>> +       *mm_lock_seq = seq;
>> +       return false;
>>  }
>>
>>  int __vma_start_write(struct vm_area_struct *vma, unsigned int mm_lock_seq,
>> --
>> 2.52.0



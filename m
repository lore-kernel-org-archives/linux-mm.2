Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4710ED6CFA4
	for <linux-mm@archiver.kernel.org>; Thu, 22 Jan 2026 20:56:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ACF116B0352; Thu, 22 Jan 2026 15:56:47 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A79BC6B0354; Thu, 22 Jan 2026 15:56:47 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9799D6B0355; Thu, 22 Jan 2026 15:56:47 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 85EBE6B0352
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 15:56:47 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 1813D161803
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 20:56:47 +0000 (UTC)
X-FDA: 84360808854.22.EE04D8D
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf26.hostedemail.com (Postfix) with ESMTP id 7CFF3140006
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 20:56:44 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=IevJUYzs;
	spf=pass (imf26.hostedemail.com: domain of llong@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=llong@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769115404;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CGuem69rerO7TvMKhZx4BKhxoFushL0GwwCO3214nuc=;
	b=1T8np2Jv8I8Yr8N3gzwkR0jKOBr24Vs+zyn5e+nBtCvHwLRrArATGLiltYxEjTEvzSPxH8
	PaboGyJ1HjGns3oTnyGtmpLTR16GAPmjWCCn1UcLM6qyxS/6KXRD70JlGE4EfxUFqYEvTY
	GCQPRoyB2hpaWG5xsWQDRqh/9BmIOH4=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=IevJUYzs;
	spf=pass (imf26.hostedemail.com: domain of llong@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=llong@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769115404; a=rsa-sha256;
	cv=none;
	b=LcTxHl/8pNKzGiZTmbIKTfhC2i10kqMyTk/zVht1RFctU8awpYyNI44tCElxr0cs60b/Z7
	gVy5bSTNAekv9GuHU3n7Zpj7oeII1UV3rLQweXhca1dX8sSIXzAEEstqV2UVVc7MBdwRgw
	BFXTIedKIhyKm9o7Svtq2u6nkYzip/8=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1769115403;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=CGuem69rerO7TvMKhZx4BKhxoFushL0GwwCO3214nuc=;
	b=IevJUYzsinfeCCUhPK+uRmlSO7A6fI4rd6NfesldFxT1dRXyFZEZK55nOsNBlomFfDtNe2
	Fv9eYvWq+yb5bfWalF5I44NUYSVKErww2w0hAgduME01jKDpgqrd80A1qZVpKhMZ7p9DNH
	U7IpAxw3DOiSuH7xze9qdn1XXmJMlsI=
Received: from mail-qt1-f197.google.com (mail-qt1-f197.google.com
 [209.85.160.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-329-G4_qMcz-OtCJfiTDw59jmQ-1; Thu, 22 Jan 2026 15:56:42 -0500
X-MC-Unique: G4_qMcz-OtCJfiTDw59jmQ-1
X-Mimecast-MFC-AGG-ID: G4_qMcz-OtCJfiTDw59jmQ_1769115402
Received: by mail-qt1-f197.google.com with SMTP id d75a77b69052e-50147745917so57132331cf.3
        for <linux-mm@kvack.org>; Thu, 22 Jan 2026 12:56:42 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769115402; x=1769720202;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:subject:user-agent:mime-version:date:message-id:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=CGuem69rerO7TvMKhZx4BKhxoFushL0GwwCO3214nuc=;
        b=FBG/FVpHyWB+PWuK35gnA9ilFpeVIFHz1Yk5GPt+qKydq6V9pQI51vXVFxZAKtXzKp
         1D54B6mgCBZS+RT0LYKjyHdmofsiolowAmTY/v7Qx6lTmDv3SgbteYxk21JjUwT+3oDH
         f+ETM7ug+0mLbwB+QfeKd22iHGOndaNDNwbO/N/lRNPQw5soSe/g//idI0i3sG4VTUxk
         FUDvrh9J5tc9EHx3g05DOBQ3mcqHOzeQoJ+l/9rPOyzg/dXBiKIM4QG2UgtYkdMu57Kq
         4g4cyH1/ujE45WCprz4B6Q/wTCM0aI7K5w+IL1JfnsUlu1paCxxB73rytrW4+mlZ/bN8
         iYgQ==
X-Forwarded-Encrypted: i=1; AJvYcCVKG7Bmlm01k+mhiz+hUqPZuA6W2Mmm1Ce9by4vGif0URLFY+ex+ZDO/3Ye7JpdGmmZRYKn6PyqyQ==@kvack.org
X-Gm-Message-State: AOJu0Yw9WhElc7VPSC37bcKy+/BvUklPkEXX2u+JEF6qzg9ZrajP+xaa
	iwbbXLAGyFhGLMhLyMnGKJBpuR3zqHarc/yXV/X1fMl1FMkPLv+ifybvmAykUJ8hoe92tWMbKSd
	kSkcP2t3o/O9qzBo+fCUxb01NEzHvk6Nqr9kTGfawWvrCAQbR5rL2
X-Gm-Gg: AZuq6aKKvbgkxYJjP7/R9xaXufGFws4PyxxxgMNXjcdoEClWQniezMmuovvYdWEnXmG
	uV5u7MaHkyj9jaP9eMwdBGVzfmKJk5LhwAgg43lf0J1vZ2SSzez1X1TofkzTiunYyWYy/RqYxO5
	ECiloUmVdPnpyafE6j8f9ltwE4n+rVobmFkqdJtnZrHMDEsev5i/shgILHybgK+sLi0pkiu8bDA
	twmuuawBKLrSDfgWFiYrgu7WhYh0UiogySLVbLSOVyHisokefh4lR6gILeBjI3xQyWXjyOD/R30
	WNg1D52HB/T2rGlbrBmxrKFlBMh0StLM0ZkpoJprCf5AxgScKJWtiua8SRJhqC3rgh5+jqjmqzm
	ksa0Nabm2INYXm9rDzn4/vZSND5CPFsU2dXQNwze/v3xdgoVvVr6JR2ap
X-Received: by 2002:a05:622a:1988:b0:4ff:971b:4cba with SMTP id d75a77b69052e-502f7724947mr14758881cf.14.1769115402061;
        Thu, 22 Jan 2026 12:56:42 -0800 (PST)
X-Received: by 2002:a05:622a:1988:b0:4ff:971b:4cba with SMTP id d75a77b69052e-502f7724947mr14758581cf.14.1769115401684;
        Thu, 22 Jan 2026 12:56:41 -0800 (PST)
Received: from ?IPV6:2601:188:c102:b180:1f8b:71d0:77b1:1f6e? ([2601:188:c102:b180:1f8b:71d0:77b1:1f6e])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-502f7f724d2sm2586161cf.20.2026.01.22.12.56.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 22 Jan 2026 12:56:40 -0800 (PST)
From: Waiman Long <llong@redhat.com>
X-Google-Original-From: Waiman Long <longman@redhat.com>
Message-ID: <87d0eae3-e16e-4820-adde-afb519c5dcfc@redhat.com>
Date: Thu, 22 Jan 2026 15:56:39 -0500
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3] mm/mm_init: Don't cond_resched() in
 deferred_init_memmap_chunk() if called from deferred_grow_zone()
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Mike Rapoport <rppt@kernel.org>,
 Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
 Clark Williams <clrkwllms@kernel.org>, Steven Rostedt <rostedt@goodmis.org>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 linux-rt-devel@lists.linux.dev, Wei Yang <richard.weiyang@gmail.com>,
 David Hildenbrand <david@kernel.org>, "Paul E . McKenney"
 <paulmck@kernel.org>
References: <20260122184343.546627-1-longman@redhat.com>
 <20260122112920.2b435873a0cc5f396df5d1a7@linux-foundation.org>
In-Reply-To: <20260122112920.2b435873a0cc5f396df5d1a7@linux-foundation.org>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 5NT73y2PBbplF3rAX168pmg8pw00CLGtKer47HQiVSc_1769115402
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 7CFF3140006
X-Stat-Signature: q3haiopbqgzpabmbftrspew6jjk6gpqn
X-Rspam-User: 
X-HE-Tag: 1769115404-403007
X-HE-Meta: U2FsdGVkX1+eVL3BwYr51iMMYV1RVv850xX2/1MtGWkYlgz+fD5RIi5yTbtPRq5bU0qpHbxn2/uysRQyS0iLqjxggu8aKQ2wXiWg/8aF8yRwe7/ZmKAaMLQLYeQ6TB4bfeMAMOA7OlSsDF/M6IGeUfiMA6LI+zSIzZY5cVOTdhG0hY/i1sXm1qTpntxPFvNduFziXt1Wb69vXSrLPqw3LdXudBCbWsz1nOjbIG22bSvNzXE89fMJxke06eJPjqLDhVKNdVoLk+uA8u3dOUxxvGw2nfShkUdXekGzAQeIRq48rK2pWLEfwtaRjwcx8cX1MGKsewMWwjcWmgvGoJb4sgDwQl4s8bNA4YORUz4iTi86dQNarUgdFlorcgHdsqpnpykI6rBQvK3A9dBy8MsS320I6y8XukDm73uDpENagFzyILl6pSakYxUUZhfyAv/t408wjLU2c06GMhw5LZvN1YEwi4kV3jN1Nkr927shSvUJoc5nF+wxVBiMCvbSA6NLJDsvceGCsv5oGa0n0es/LvZFKfsjPEdtJJVRiJEJCvrxUK5mZgtRwUx5eVESW0oPHkkEKzIjCglADDxP0WfVDCUau+DPAfgrqts6nlNAoJ8QhSlne3f7XE65C/a1kQ3xk5HkcZdJwlIQZPk7FhIZLHqd8W26fhtID3LQZPdgV6r8L5rVRmDO1oXTHOzS2zh5MijUb29HYGGaKJraK1EhC8vxsfJq+9aZcEcxEaUjCxDIHFijS9BctTAh1RtplQFZhNzsbbVo9cVzWUUkIo+SZQGZXGIsNeobhZ6D7QZ0F/iOOGkF+kUQ7JwPL2+Le74h/lhkFaz7fZc9EBP3LU++G8Nw1Ir9rFQ4nJOJ94kZtC4njeJXYPVXa1GQB6Y2n9rcHftfRk4UOT51/IBe90Wc2vc6Lwxt79ASuZ4I0lTNXiw/VZgmmJs4MHZ3kbKblK34QFQBWQg5HPEmKSuXt3P
 ayzgxI6V
 JD7WqWbKvcc0FM+ILFsrDTETzJweEepHQ6Mb888F6xjrueXKyrjl1AcaHhxXKls5IkTl7fSFpeQ7yYHplw1kFq5IZr8jtWcPfDkJIPc4AQoCB6MF6xPWxfN/Q2oZIBFtsdihwOWGRd6dMwl5fAd7vWLRxVjmDuo10QJlaLN5/e2BJy+p4sOMzg8kruDdYnMrtm5sficrtv4yiPCdl3S4HR01mEBtMGO9PcFkdAFqU7yA7e19BwcQJEw3n2mDf/UENggoKfhiBKK/+Adh0vGYaNa9WsokXSmpzNsftVrYdVEH3ycBihDEl9ixeb3d+MjCoIBz3sbKMVEVlKCB5EuFTL82sCF7e7RG1Fpk/c/2hHCXj99a+PP86caoJrL4iZNtnrv3nyvd110A2+wODiP4fGh0BwWa0/ktF0PJNAvOpzMkcx/JR6s49Yxzkou8RNllShAKueTl9cpDWPT8fZz+5+jQTS2pOeH8sBGBoyUbq1+LyHx0Qrf5vlzgR5bitVlZWOi8c39o7aez0t78VHavLfFHnGE+YI43Ko6+VPtNLPCgZJKo0ZHYJt+AHerkfShgXKQ33VqTokXJ1o9VjfxQEvB0/xiuMOmxW3qUk
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 1/22/26 2:29 PM, Andrew Morton wrote:
> On Thu, 22 Jan 2026 13:43:43 -0500 Waiman Long <longman@redhat.com> wrote:
>
>> Commit 3acb913c9d5b ("mm/mm_init: use deferred_init_memmap_chunk()
>> in deferred_grow_zone()") made deferred_grow_zone() call
>> deferred_init_memmap_chunk() within a pgdat_resize_lock() critical
>> section with irqs disabled.
>>
>> It did check for irqs_disabled() in
>> deferred_init_memmap_chunk() to avoid calling cond_resched(). For a
>> PREEMPT_RT kernel build, however, spin_lock_irqsave() does not disable
>> interrupt but rcu_read_lock() is called. This leads to the following
>> bug report.
>>
>>    BUG: sleeping function called from invalid context at mm/mm_init.c:2091
>>    in_atomic(): 0, irqs_disabled(): 0, non_block: 0, pid: 1, name: swapper/0
>>    preempt_count: 0, expected: 0
>>
>> @@ -2085,10 +2085,10 @@ deferred_init_memmap_chunk(unsigned long start_pfn, unsigned long end_pfn,
>>   
>>   			spfn = chunk_end;
>>   
>> -			if (irqs_disabled())
>> -				touch_nmi_watchdog();
>> -			else
>> +			if (can_resched)
>>   				cond_resched();
>> +			else
>> +				touch_nmi_watchdog();
>>   		}
>>   	}
> Disables the cond_resched() in some situations.  Can this reintroduce
> the watchdog warnings which that cond_resched() was intended to
> prevent?
cond_resched() is disabled only when it is called from 
deferred_grow_zone() where a spinlock was acquired with irqs disabled in 
the case of non-RT kernel and in a rcu_read_lock() acquired with RT 
kernel. In either case, scheduling out should not be allowed or 
something bad may happen. I suppose that iterating of pfn's in 
deferred_grow_zone() requires pgdat_resize_lock() protection.

>
> The cond_resched() was added by <dig, dig> da97f2d56bbd ("mm: call
> cond_resched() from deferred_init_memmap()").
>
> Pasha's 2020 patch replaced touch_nmi_watchdog() with cond_resched() to
> prevent RCU stall warnings.  So I think the answer to my question is
> yes, going back to touch_nmi_watchdog() could reintroduce those RCU
> warnings.

deferred_init_memmap() will  still have cond_resched() called in the 
iteration loop. It had RCU stall problem before without cond_resched() 
because it needs to iterate all the available memory which can takes a 
long time if we are talking about TBs of memory.

For deferred_grow_zone(), as long as the number of pfn's that are 
iterated are not huge, RCU stall warning shouldn't happen.

Cheers,
Longman



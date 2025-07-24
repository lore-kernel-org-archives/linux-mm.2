Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6CA32C87FC5
	for <linux-mm@archiver.kernel.org>; Thu, 24 Jul 2025 16:13:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B85958E0098; Thu, 24 Jul 2025 12:13:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B35E68E007C; Thu, 24 Jul 2025 12:13:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9D69C8E0098; Thu, 24 Jul 2025 12:13:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 85B7C8E007C
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 12:13:41 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id F0B1D1D9AA3
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 16:13:40 +0000 (UTC)
X-FDA: 83699653800.22.85ECB16
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf22.hostedemail.com (Postfix) with ESMTP id 7E766C0007
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 16:13:38 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=JVLBbYu9;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf22.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753373618; a=rsa-sha256;
	cv=none;
	b=svMlB435gUgUUa4FAzlCj2SEkCgRn6RC++akk1mnBhLB6sS2jKcat3o9TWTj7kgKpQz6OF
	UdqIq0nRg0npfWRRxN9gAZGks1H8QwNRXILB9jPYNTRyqYrc6dlZUYPOs/yCKla0wktXs3
	Auh9TvwT3G+xkeSBfRTLsJnURFYMtHs=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=JVLBbYu9;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf22.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753373618;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gaIkxu5fgz8fIF+B9EOhggJazywKUE0YQPSwT8mMoTA=;
	b=PZTEDbO4XqIyA3Q9GWqbSSUYlxLDkxz2HxQud0WiH1jYQNrRzDrXaqHw9bvfL9TK6MOkUH
	ZeGs+jFqlHePJOU9nOIZyONveQw8/uw8vb2cshQBHDVej6T2H6E4LgJmBjfrr5zJ/I5nIf
	/aLMOZA+CFG0FIf5BSZJUrNNdscLg80=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1753373617;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=gaIkxu5fgz8fIF+B9EOhggJazywKUE0YQPSwT8mMoTA=;
	b=JVLBbYu94attOXaqaHJXHJxmB3AXmaxYtyRAexJKWqyir4etdE7+Vo8saIKYXwwvOFAhr9
	yH7NSpWT+/xC4OWcepUrvcHKAVb9J868eKBHn5KjHOda9sLfrBxTosOtyNd6dVHAFTu3SK
	ibjts4wct7fTcrRRiYdKclS7GCsgPuA=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-378-WWx10qI1Pm2MFNo5YGsHHQ-1; Thu, 24 Jul 2025 12:13:36 -0400
X-MC-Unique: WWx10qI1Pm2MFNo5YGsHHQ-1
X-Mimecast-MFC-AGG-ID: WWx10qI1Pm2MFNo5YGsHHQ_1753373615
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-454dee17a91so9210295e9.3
        for <linux-mm@kvack.org>; Thu, 24 Jul 2025 09:13:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753373615; x=1753978415;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=gaIkxu5fgz8fIF+B9EOhggJazywKUE0YQPSwT8mMoTA=;
        b=AGoKeXE3brg9XvcFMkENnKVKGbwb6LfSfDKX/IIn8AfBa8VgTlneMX8dnUEvuxeCmP
         aK7pH4szE+ndZIoDu1jfBukLgSfZBMvAqRhbfL1nHzIMJDdOCSmhAgHLm3tQH1jRs1s1
         sOzMDt2LC+tBZ2K5g0XlfStiVHcbNI+t7y0a75Dxzw+2qcrpl31njTDSVij6TqOboR4H
         2G0YNHl7rkat0ObbCYP4uG2HbpK/krpeBkpP3mjJjcY2zMquWc2y+/e0nd+lq5p9iKbb
         EdHK+jyfaN0fpwlqWGYJt6sOcMHs1PKrvghhuCPnb1Fa1NdEmQ72UyoQYnfyfHlaGxuI
         WKcg==
X-Forwarded-Encrypted: i=1; AJvYcCVsKllTcf2vaIcW4cC7I2/bQojl5JRIHs+KRu5gxe1zp+s56L5CDVKEO4aAmqwp1MFEEEbwI9iDiQ==@kvack.org
X-Gm-Message-State: AOJu0YwvlZnKU4bYnwwphRAPThe1tc14gtXPqoGrK2EQ7VRtZwuZtomr
	1+inFSGLZc9bXZY0gBw99AYPsY3BEICCpTaVNgN16ku0nBocG+ucvN0dMTwc/hf6/qGBdmN93ka
	jUDWFWSc2du4afegUl4Z0p/3IT/J8ybihlX4kst2U7gpJuSX8n580
X-Gm-Gg: ASbGncuVcc1Rux7Ebjk/B85EyzRSSCcwmd+r62yMdje7KTvAruYuetqfUlg4wObJGPR
	AeB4rNlHoi1FRVCOGauaVja285BKCC8qUvpK+AXxFZcsUGh7lWrRA2oxUVoTWK0cD4B7+3NBfG/
	b5sCvtoXfzpLKCRgFe2pS/Bwsil5AUmYoKlTGq+R6atYo0C3ItwbqsirCjToYKVWF45JvyL07cY
	Ij/AvEUb1CQsdQxLogzAItrbJpFj80JMX3JJ9qvmk8Sk96RlmA8NCZ8QXdu2xSDLLp/c2KpG/MZ
	i2wG9T34SQTA5vAXJ/8+VmbPt4Pt8ljT3jRLl/896lYbvH+X3crDKnb441dYIbRDEJQVF396A13
	pMLCd39ne2Kjv/6C+lZW84EKMAjUfc8KDy6K3Ld45XXzDQ78x4G5cMPykaQSa9w6Q
X-Received: by 2002:a05:600d:1c:b0:456:1204:e7ec with SMTP id 5b1f17b1804b1-45868dcee77mr64687615e9.10.1753373615155;
        Thu, 24 Jul 2025 09:13:35 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFQzVab87ZyVdyPevqksyrADz+0j6DkLsR0citfF/5aTnOZXNGfrIPOMWvb8uUpl/UzSJwzCg==
X-Received: by 2002:a05:600d:1c:b0:456:1204:e7ec with SMTP id 5b1f17b1804b1-45868dcee77mr64687315e9.10.1753373614628;
        Thu, 24 Jul 2025 09:13:34 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f1f:5e00:c941:d6fb:3e30:b42? (p200300d82f1f5e00c941d6fb3e300b42.dip0.t-ipconnect.de. [2003:d8:2f1f:5e00:c941:d6fb:3e30:b42])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3b76fc78f23sm2601100f8f.36.2025.07.24.09.13.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 24 Jul 2025 09:13:34 -0700 (PDT)
Message-ID: <20325814-43fd-4509-b4e8-56f169e50e2a@redhat.com>
Date: Thu, 24 Jul 2025 18:13:33 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] powerpc/thp: tracing: Hide hugepage events under
 CONFIG_PPC_BOOK3S_64
To: Steven Rostedt <rostedt@goodmis.org>, LKML
 <linux-kernel@vger.kernel.org>,
 Linux trace kernel <linux-trace-kernel@vger.kernel.org>, linux-mm@kvack.org
Cc: Masami Hiramatsu <mhiramat@kernel.org>,
 Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Madhavan Srinivasan <maddy@linux.ibm.com>,
 Michael Ellerman <mpe@ellerman.id.au>
References: <20250612101259.0ad43e48@batman.local.home>
 <20250724092847.1aa83756@batman.local.home>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 g3eXuA==
Organization: Red Hat
In-Reply-To: <20250724092847.1aa83756@batman.local.home>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: j1Ov5o5go7UvAzg6oJqfP0U3-ZL1G5qkKHMp3oSRGH4_1753373615
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 7E766C0007
X-Stat-Signature: ffi6kkz9q8nf1wkfq3fkqx5fkrq9x4tw
X-Rspam-User: 
X-HE-Tag: 1753373618-923561
X-HE-Meta: U2FsdGVkX192h3FcOu+K+FSwH1uwpNrTartRRCm8sDEoaeCPq6s/yfhF8F1bB7tZ7vf7zHN0HRwklXKdKRqRbWciM0VYoZuILCEUEIDoHM2HA4HtmQEltmq0aFceu6Fp53k5rmcsQvL/HMApEN+aPmPjxf5RFi78vroXNXlAWctrPYJHFUSDiCXfq5EdSeh1//ijUMN9TVvaAlJnzkae2+uRY4Aqrk6qvF+0N5WEnv/dPqtLDzez9vgXS0dfseniGFkDC8uLe4merwd4ywk+QOycdcjdlS5lTzXiNRBPCUiTTI+da/XH1SC2rGkQJu78ChGXC+IHUzh0s1tw2U9MmQ9oKhHlbLwYaiBWz5cpdUcjRcyt/yhGaHZSuU1iWtGDwLrE9wf92abDp+AXSD++X6JW6Jel7zgPT+PVM5oH5U/06yxBoOhpTXgqm+DOo3izfoJLeVfqNqr6QELXZnQmB15bGp31k2ZhiQolKC4CID+qzib6+mlLkWFoe7iyPxAmpw9TUS9MpHe4plz1QYDyxn/W2SX3j3UebZXXpleasHxwNlre/ZbIoq2a//ORNpozojclHrzY53Ed0o0UArdSqzb9Vg+dam0nJlgWE0z6PktD8wrK+jGgw0mB0HAeB0TDzj/oYrpmauGLDyhE2nqteQ+JHUA2RMefUupDVHjRkXpOV51XjQgZMa8qv6SA33a0Hm/xcABhjR6vW3t5xnB/gPSrR72tBHIaY44bLH0UHX2vezU7k6rZWaAZiEoSsjeawjW2wJzGXCsyeZBicgoof0cnHfzYrY5hdTYWiGFkiEfql0sRDsJATTsUAjIH94vGLahv/MbIXw4QhmFgCAvAckPcMd6mImd9LRS++uAXn5OKoZ+9KJa56g6hy684MhJyANW1DLK2rI7a9cKeblstW0c826ICerl+9jmaGsW/e6mHvA3eC0zjSLpmkQiaR4QyTcIIKvSeNF2lm7I9N8w
 Mk/XoViL
 mqLJqO/KCF9DaqFnaW3jVzgp6a0KKH4keUxleTf5vIXb6s2WAfynl51pAPSGoqer3R0rzu7Re/JTJqEEk0imTZqHE04SARQGq77nxldhZnI8IWd4PSFlMNALdHjMxRBcJrJU8J31z1xz+jAKWFPi0v8+UGB8oxHw+zHxbvKCvKxwcG2Wu7dHqkphvDx7LJI3WzXtSBieXzvz+7rt1fXWpoJQ3uaPxFmyV6Bm1+gscH9/A4KUmiCJ2yiNFR3tJBz6qWxu10U+u1tPWzYv/bCStXtw/0tfiqAz6AKkstC0KUJ6iv/pitlDHVTzHH/UuiHotO9uMpUOUX/ULdHFpw1UDecZyYWlf8qaKLPSzG2RC3JVf8zD2gzshgnBrUzXGk7wYQReL3jiY3AZWKBFf6jtW/Q+SNhVcxq1qF1diooF0jHs7Op97WxqKiANAkyyrivkLD70ecfbTYYb2G0C9Hb9Q81DetSV6E7MkHBAtUf6JJD7/idzDU4HYl/pnFzEt+RwUlvLktf8KKl8aN6A4mlPC2lhenMGUSkrUYZPwPfW5Axu0IRyWH6fpHgerM8AXVwTdie3bCuqW/edI46dTRlNFNhfXqw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 24.07.25 15:28, Steven Rostedt wrote:
> 
> Anyone have any issues with this patch? Should I take it in my tree?
> 

Huh, I was CCed on the patch but cannot find it in my inbox.

If it compiles, all good:

Acked-by: David Hildenbrand <david@redhat.com>

> -- Steve
> 
> 
> On Thu, 12 Jun 2025 10:12:59 -0400
> Steven Rostedt <rostedt@goodmis.org> wrote:
> 
>> From: Steven Rostedt <rostedt@goodmis.org>
>>
>> The events hugepage_set_pmd, hugepage_set_pud, hugepage_update_pmd and
>> hugepage_update_pud are only called when CONFIG_PPC_BOOK3S_64 is defined.
>> As each event can take up to 5K regardless if they are used or not, it's
>> best not to define them when they are not used. Add #ifdef around these
>> events when they are not used.
>>
>> Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
>> ---
>> Note, I will be adding code soon that will make unused events cause a warning.
>>
>>   include/trace/events/thp.h | 2 ++
>>   1 file changed, 2 insertions(+)
>>
>> diff --git a/include/trace/events/thp.h b/include/trace/events/thp.h
>> index f50048af5fcc..c8fe879d5828 100644
>> --- a/include/trace/events/thp.h
>> +++ b/include/trace/events/thp.h
>> @@ -8,6 +8,7 @@
>>   #include <linux/types.h>
>>   #include <linux/tracepoint.h>
>>   
>> +#ifdef CONFIG_PPC_BOOK3S_64
>>   DECLARE_EVENT_CLASS(hugepage_set,
>>   
>>   	    TP_PROTO(unsigned long addr, unsigned long pte),
>> @@ -66,6 +67,7 @@ DEFINE_EVENT(hugepage_update, hugepage_update_pud,
>>   	    TP_PROTO(unsigned long addr, unsigned long pud, unsigned long clr, unsigned long set),
>>   	    TP_ARGS(addr, pud, clr, set)
> 
>>   );
>> +#endif /* CONFIG_PPC_BOOK3S_64 */
>>   
>>   DECLARE_EVENT_CLASS(migration_pmd,
>>   
> 


-- 
Cheers,

David / dhildenb



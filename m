Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7CD71CA1005
	for <linux-mm@archiver.kernel.org>; Tue,  2 Sep 2025 08:15:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DB1378E0014; Tue,  2 Sep 2025 04:15:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D61066B000D; Tue,  2 Sep 2025 04:15:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C2A0E8E0014; Tue,  2 Sep 2025 04:15:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id ABC1D6B000C
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 04:15:17 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 8118CBD77A
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 08:15:17 +0000 (UTC)
X-FDA: 83843600274.12.5BB4860
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf24.hostedemail.com (Postfix) with ESMTP id 4B446180003
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 08:15:15 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=TYA6Y8D3;
	spf=pass (imf24.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756800915; a=rsa-sha256;
	cv=none;
	b=BN/chQj7soGFtdEuKC8ktwerwTJs0XpczoyN4rhQJ5am78wOyhMRFR3b0WC+8Vk3T3s2qd
	zYim9Ol3o/wBAWFkganmwj3ACi9p4SFOSfL2acIwSBmwuMANiq9XWceugqsE4EYnJHLxkv
	jgmlMkYvseZUh2XTzc4rCR8Rr/Azocg=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=TYA6Y8D3;
	spf=pass (imf24.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756800915;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RogoUtOEfOYQJN4afGzglkQECVqWaZjyfEy0cHwYDVI=;
	b=0/jH/rq6+MWeTGKu3DXdhcq6dLE9FcTAvIxm77xU752nT0wsehK6y4uVnFj3wmQyYaVDpx
	3MeoE8hF1WJ83yIrwWBG+kKdqH16AibjkTAfSJX+sB897IE6IaChjnAYPCRzWY1g2lWjNB
	Mp/fzD6vnPzKQFx3crhQ3ftI35EHoU0=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1756800914;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=RogoUtOEfOYQJN4afGzglkQECVqWaZjyfEy0cHwYDVI=;
	b=TYA6Y8D3bQ/rp9EoDn6MjeozpMj9qmC1y2cmP1tgauJPXoy14QMPzE/vHNe00tbnJIOJgr
	ecseAqZOabjxSLgIiilpgXb4fe9y1S7dGchMMq4DHaPsG0M1GN72l4aibOrFtWHT1aXwa4
	PF+mv5nYOFXEp7XLtohab6UyZl3l8l0=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-592-UpwiEpHcM1OTIBsadX9bjg-1; Tue, 02 Sep 2025 04:15:13 -0400
X-MC-Unique: UpwiEpHcM1OTIBsadX9bjg-1
X-Mimecast-MFC-AGG-ID: UpwiEpHcM1OTIBsadX9bjg_1756800912
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-45b7a0d1a71so41233565e9.2
        for <linux-mm@kvack.org>; Tue, 02 Sep 2025 01:15:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756800912; x=1757405712;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=RogoUtOEfOYQJN4afGzglkQECVqWaZjyfEy0cHwYDVI=;
        b=wk1tZZ0LzJ0dV/27NVKvYrsfF0bJmMppFeAx39Ua4e1tD3Z5flF5M3UonYMHyD5XRc
         7CjWXSFQl2ikj0Pbbk0EfU94HfCEsYXfGJxJ/UnLDYpbWxQoThc3sAWnjcRg1nDLfcIe
         mUaXI9UGegfadq6PIyjJSNcksZ7ya0MzyJu1loI0BLt/4wgOzmkBsJWbUibQvX9UJ+AJ
         nDXuBDWcliZ8g15rT+7CqJVuyxW9U29BP/cFVpWLU/2GDtZ9rkVUPR6XKZe5PdKVyT07
         HIm7yu8sSONqsQl6QGwyMUrBehJ5YV22k2mIA/B6ojqZmXVJG5WtP5a8LoRG//4xk8SB
         eY+w==
X-Forwarded-Encrypted: i=1; AJvYcCUC0UFXV0qPZWbgOkudW7qUnff2ZDZqoFQwLZ9w0LYrExlxyuFcafDhhDOTtZFPCbc7owO8fdtpXA==@kvack.org
X-Gm-Message-State: AOJu0YyCP1+TRqOUM6ph5nT79kPyrKXa9GTG0BnmoBOoePpJSjsc2KcU
	YCOD5/6Hu73RTY9wvPPEid8Wz1JGezA/OhNfqtFkkIsG4T+l3ioIEH60GmH4DzUpcUIGh/iq+O6
	9kspqh4AEKoZkrFQW7EV4k2Cy9cpGH+SKxf6GvSb3sEUPJrro8S5h
X-Gm-Gg: ASbGncv0XVms8GzFPPaSLBSH2E1GoO1vI+ATfiss7hqC0aCEMVJ5fUvd3sZD92XO+qf
	NsZataFeRPXP90VPh4Ow6dlTSpOPhjGlwVhkBHMgLxmXsAj+FUOW2Ray5GoDzYx/5cbw2QyMSqs
	+AUAIDACftyXlNUheFtgDwoXdvlZ7xP0ukBlPEzmN0JaPU0Q17jZtoD2MEIz6V/yXtAxnjDMdLO
	9GF+FUpS84k3MxiW17gz9fv72B6bqGkjdoqu7eviDDVKYm+D6no/2bUe/ij1Usb5dBMJoj9Dj9k
	WHZt6dNyj1KRmR7DYvZG8WlfS0RgkL4FmhFtcbAxUz5ByxwO5g8wDfNXT3C4YDemBrKdJcPywx8
	0yK779DIJEQUm/Ewc1D+zCVRSwPCNjxMFdSAVW3EfqTYtGaeZVdwn8CetsxfgpPNc/iA=
X-Received: by 2002:a05:6000:2889:b0:3d1:61f0:d256 with SMTP id ffacd0b85a97d-3d1e01d549cmr9068719f8f.42.1756800912150;
        Tue, 02 Sep 2025 01:15:12 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHZfeVU3LdB4bHgw3FzcrRO99gHX9zuEWOnoc0/0BZioqs0USiyiN4hqenDT8lLo0/e6yv0pQ==
X-Received: by 2002:a05:6000:2889:b0:3d1:61f0:d256 with SMTP id ffacd0b85a97d-3d1e01d549cmr9068645f8f.42.1756800911636;
        Tue, 02 Sep 2025 01:15:11 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f1f:3f00:731a:f5e5:774e:d40c? (p200300d82f1f3f00731af5e5774ed40c.dip0.t-ipconnect.de. [2003:d8:2f1f:3f00:731a:f5e5:774e:d40c])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3cf33fba9fbsm18677434f8f.50.2025.09.02.01.15.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 02 Sep 2025 01:15:11 -0700 (PDT)
Message-ID: <59c1ef6e-fd26-4d95-ae96-1e1f23c789fa@redhat.com>
Date: Tue, 2 Sep 2025 10:15:08 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 00/12] mm: establish const-correctness for pointer
 parameters
To: Matthew Wilcox <willy@infradead.org>,
 Max Kellermann <max.kellermann@ionos.com>
Cc: akpm@linux-foundation.org, axelrasmussen@google.com, yuanchu@google.com,
 hughd@google.com, mhocko@suse.com, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com,
 vbabka@suse.cz, rppt@kernel.org, surenb@google.com, vishal.moola@gmail.com,
 linux@armlinux.org.uk, James.Bottomley@hansenpartnership.com, deller@gmx.de,
 agordeev@linux.ibm.com, gerald.schaefer@linux.ibm.com, hca@linux.ibm.com,
 gor@linux.ibm.com, borntraeger@linux.ibm.com, svens@linux.ibm.com,
 davem@davemloft.net, andreas@gaisler.com, dave.hansen@linux.intel.com,
 luto@kernel.org, peterz@infradead.org, tglx@linutronix.de, mingo@redhat.com,
 bp@alien8.de, x86@kernel.org, hpa@zytor.com, chris@zankel.net,
 jcmvbkbc@gmail.com, viro@zeniv.linux.org.uk, brauner@kernel.org,
 jack@suse.cz, weixugc@google.com, baolin.wang@linux.alibaba.com,
 rientjes@google.com, shakeel.butt@linux.dev, thuth@redhat.com,
 broonie@kernel.org, osalvador@suse.de, jfalempe@redhat.com,
 mpe@ellerman.id.au, nysal@linux.ibm.com,
 linux-arm-kernel@lists.infradead.org, linux-parisc@vger.kernel.org,
 linux-s390@vger.kernel.org, sparclinux@vger.kernel.org,
 linux-fsdevel@vger.kernel.org
References: <20250901123028.3383461-1-max.kellermann@ionos.com>
 <aLZbaHf-euLQ0isT@casper.infradead.org>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <aLZbaHf-euLQ0isT@casper.infradead.org>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: WAnY86o37M-qVjGGP2R-6zUvYPzqWEWQ2K7be3f0Kh4_1756800912
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 4B446180003
X-Stat-Signature: arboq5bnixishnq5zw854ewexojx34yu
X-Rspam-User: 
X-HE-Tag: 1756800915-5045
X-HE-Meta: U2FsdGVkX19CRa8UQ2O73lY1hFm8FQqKp6avCGJ4zFU2+r5n29aNUUUz0Sp6Q5bsP1KcV4FAUIamyW77xo4hCu/a3qHIyYGbFuyvVSh0k/eYvNq0GmlXNr+z6s1oPXBhXf0vwII4Oxdbb7gLrzFOEwCwnepOZ7Uy5B7HGzHzohLG/dO4cF0nBBfXVWjYf9vzlWyyy/dewSMFZRPYchfYLzZsrdu6O+hPLgX2dK1PD4ObYO2raugzuylQnTnzkZNms06DZzly2PX+Cx96ohMl4ey0WPMbvHzgurdky4mE+tdiRHAJf6dynSwt3eLdkYb3jJ50Gd3+yZZbeLsiCxBdrdPWjiikFyWdGHIURfPnkgSBfukwwwK5PSfn2hNkzY4dhm8q7K9Px2KLfC6Qc9gYU7R4+QfMVF4HobOPnIL+4QSrdcU6x5mKb9pKZabfPaibWyNIRcrvpnckfKrjAa9unLjfNFCNUpCmyCRUzKbc1ySySHKjV5SDjr/GWSaSOm9/b4/E8RB4Ee6Azy4+9xnOrI5YM4tKcF0MHNBQ6lOyaVlrgZZYvyvdckobSOPSiXTm9/j5vk8ImAt6+FR8zGnoZdeXMSRFAbjAln98arQbZA1MJZz9qvcJmzJtM6TZh47kE6g6wlWRoniqLwO0TPBZZlk6WfXfI529/7nORBSZn/Ikl5k3GtP/aaskQ+/SfGoqG7h/AeVyDKUxIxpbrhrrHO/JDVPsFjPmQFdIwODc3pBNynYwnyPUj0i2pOXfE7quh7+Xuw8HaDfxbHYH32xy4Kfy83ABVHSVNWImQrDNeXmXFpa+Xaj6FfjaMBtay+0urcdUZOvThlK3+TaXM4N9/Sbas7uDzmC6xa2l+JOSIn7RK8evYU27AhXsC5QNyKv0NAIPgVHx8DvxJlxzeGy7QLpGOHTvQRARGvw42E+nt1QflNfG+bhHGC1Sls2cuYxNMKFKUdwuVjg05Z5NV+I
 2ThkvGHG
 Mo+y9uIgnxq12SrdEIhBjdEp28JfseA1GjrKEWzdXf58UH85r+qF2o2jviZwDvnEkGnRNq6hkNAA19LjS2Sp8YfXAn6Ub7JthzJ5D3XwHAxuVU6k=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 02.09.25 04:50, Matthew Wilcox wrote:
> On Mon, Sep 01, 2025 at 02:30:16PM +0200, Max Kellermann wrote:
>> For improved const-correctness.
> 
> SLOW DOWN.
> 
> This series is unimportant churn.  There's no way it should be up to v5
> already.  Wait a freaking week before you send another version.

... while we have v6 already on the list :D

In this case, it was reasonable to follow up rather sooner than later 
(too much drama and v6 now seems to make people happy, I wouldn't want 
that spanning over multiple weeks).

But yeah, too many revisions on a single day.

-- 
Cheers

David / dhildenb



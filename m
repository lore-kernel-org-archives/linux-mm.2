Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 944C9CCA470
	for <linux-mm@archiver.kernel.org>; Tue,  7 Oct 2025 19:40:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B56308E0007; Tue,  7 Oct 2025 15:40:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B2D408E0002; Tue,  7 Oct 2025 15:40:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A43498E0007; Tue,  7 Oct 2025 15:40:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 9444D8E0002
	for <linux-mm@kvack.org>; Tue,  7 Oct 2025 15:40:08 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 2BE76B75AF
	for <linux-mm@kvack.org>; Tue,  7 Oct 2025 19:40:08 +0000 (UTC)
X-FDA: 83972334096.19.1EAB24E
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf03.hostedemail.com (Postfix) with ESMTP id DE2A820002
	for <linux-mm@kvack.org>; Tue,  7 Oct 2025 19:40:05 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=GPpksst3;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf03.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759866006; a=rsa-sha256;
	cv=none;
	b=3ZuXm2d6Cuzem6oyYleqkPSssDUry6X6/FAryqmwjrnFiFgdrjy6Vga4+HPgzzP/HvLcWg
	/lOGoTBTyJNc9b3icC/4jyGThSU00HPa1HGeJXAoTltjiALIDql+FA7Yt3ZCpMslEGjFum
	tNax2ougeQ/zuwwGfDh41QS87R/rmk8=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=GPpksst3;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf03.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759866006;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9VumtYpTrX67AUkgEfTTMEIc6RIxe4xeW3+00mS96fE=;
	b=Q1KvN0wxmKiaVfCb7kxkyKRO9oWq1uW74P42FpOYcvleH2iWtyud+tIL9FfGteskUnjtPz
	NkIWFStUKRqvwISs0cPU0Q0SAokCyb304m2e5VbLLyzCeGW5jGl208u/DllVAHisPWBasb
	7mk+LOuDcyCzkFiga3mcK9peBMFW1OQ=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1759866005;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=9VumtYpTrX67AUkgEfTTMEIc6RIxe4xeW3+00mS96fE=;
	b=GPpksst3Q3H7+gEa2JfDfCmDuS/y1kn2NjA0nfcQ43NZauNx6dWO4BjNsVZdTBsdYttJoI
	0xwZUsyya0ePsbYvVJOazwVR7xgSzXAYdfVjVcs2BVYPAaRge4bAEL3+KtwKcpIUqr4E0z
	rpWquRgZ6j04aCcWZ6bIa3jsEg/muEw=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-296-ysPIk9D1Mr-ikcByKWYUtQ-1; Tue, 07 Oct 2025 15:40:02 -0400
X-MC-Unique: ysPIk9D1Mr-ikcByKWYUtQ-1
X-Mimecast-MFC-AGG-ID: ysPIk9D1Mr-ikcByKWYUtQ_1759866001
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-3ee10a24246so3388708f8f.3
        for <linux-mm@kvack.org>; Tue, 07 Oct 2025 12:40:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759866001; x=1760470801;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=9VumtYpTrX67AUkgEfTTMEIc6RIxe4xeW3+00mS96fE=;
        b=YWNVnVfc20tSFKywepWZir2oRq2Xr5ru8bsbUf1CCnxZRXyjKfgOnxwOZ9a14BkCkx
         KqzuNlbERyT+Ihjzg24JDFi5JirV00sEfGIf4f9cMlG0snVBUTrFebraPOyhLuk70tnN
         a8axkJMOtkpr8KIgElrDUQvMECaKKywxQxiCKQd0YaldkmfUANJwuINw5P4awmaMdkdg
         HSNdfFU1wiNtCgoYym+6l6KknLgD9MXNHMQ2zDgZMeOBqeyDi9vj+edOBLsfXFa0951J
         b2HY4AW55vToBcVgtCvPu8cyBSa0gHI6HKS6JzX7MfylXOiFkkHboTK7k40mLFbnu4+8
         Kgcg==
X-Forwarded-Encrypted: i=1; AJvYcCU9rRGKN6fy1pJ6ndHVJOsQPCrv8eop6jPQTlOSQSmH6HGzg4fpGtTYlKcl4xOqOLMGEHWC6W5jyA==@kvack.org
X-Gm-Message-State: AOJu0YwT1priiyhV7lCK8pk+d0sf2FIyMzCnvK1gnIrlBgVSITvFlLHi
	WpIYt+F3XPObMc/a6MMBpWo9JPyrTPNgDEvfOeRQhfdfiny/SW+YnkFGmxUhIA73BkkQ+TE1ho4
	oT1/DS3Q7VGiAEQlltIcUHY1wnHedsa7iWAv3Mtu8zQ/dfHXZrjXK
X-Gm-Gg: ASbGncuV9YQUnSVFm86D+KTRNBHm0O+CQ7VNpdC4xbL10AMgZ9LF7M6xrLNpvnor7g7
	qkj1tXjQts9UpoMvpSRl745E6itNTWhClqFSV9Ber4vKoa6NByWlCUMXEavlrvaSEERzYMI6wjY
	LrkGVPEh7BFr9c5IoYv39FgVCAf6gazSCnEl18Ix/oH2Yrz1fUs4YcloRlCrYKsEw6SmjhgPvZA
	loGvYqqHBDWAsBELg9a6njuZyXQ0g53qt2/ir7ifmXxcfNtv5MgHbCLjozJpXFMaDSUAhlusz5R
	I+qJwSItI9/mTa7iAyUgDoDisxKyBWdF6C6aydR2uG36/KByjANbCWtQW88qrwJfqMlxogewRtg
	zNTUr0RTH
X-Received: by 2002:a05:6000:208a:b0:3ec:42ad:597 with SMTP id ffacd0b85a97d-4266e7dff52mr302903f8f.37.1759866001471;
        Tue, 07 Oct 2025 12:40:01 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEej/svesPDrHY997doiJUMRsBCaL4lMY/21dpeNKaxMJMF1Jf9ZuSBWRwx+hr9s6QqrTCUyg==
X-Received: by 2002:a05:6000:208a:b0:3ec:42ad:597 with SMTP id ffacd0b85a97d-4266e7dff52mr302886f8f.37.1759866001067;
        Tue, 07 Oct 2025 12:40:01 -0700 (PDT)
Received: from [192.168.3.141] (tmo-083-110.customers.d1-online.com. [80.187.83.110])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-46fa9c2a39dsm7457035e9.18.2025.10.07.12.39.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 07 Oct 2025 12:40:00 -0700 (PDT)
Message-ID: <ba392005-8cb1-44c6-a4ca-7608423fea62@redhat.com>
Date: Tue, 7 Oct 2025 21:39:58 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 3/4] s390/sclp: Remove MHP_OFFLINE_INACCESSIBLE
To: Sumanth Korikkar <sumanthk@linux.ibm.com>,
 Andrew Morton <akpm@linux-foundation.org>, linux-mm <linux-mm@kvack.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
 linux-s390 <linux-s390@vger.kernel.org>,
 Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
 Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>,
 Alexander Gordeev <agordeev@linux.ibm.com>
References: <20250926131527.3260733-1-sumanthk@linux.ibm.com>
 <20250926131527.3260733-4-sumanthk@linux.ibm.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <20250926131527.3260733-4-sumanthk@linux.ibm.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: uJm9tBJAC-fHUjCkAkf0m2I8-aMbvpZbjQc5x51QyII_1759866001
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: DE2A820002
X-Stat-Signature: xrxn5mafx1g11chkwarkzn9b6oftop6k
X-HE-Tag: 1759866005-13044
X-HE-Meta: U2FsdGVkX1/0u8NvJgba87cSDxVLRQecMlnkXsW1RLrKQede1O1OWKAwH+pUWTIvZ0vVjo/y1Ub40wCDm9ecNWWmjt8cZkDalOAQiDUOuDl1ArTKtb3Pl87IHVhwo2A6Rcfm4Heb6kXQKuB3z694z16Ur5CHOWOpqUmFSINtyzreWsDJcTuU5Xe03eWUT9+yUFSiHte92H2Oh5OTE4z3meUnW7+p7pT0/Wu2+qA8xn+bmdcVSOAXJEiPmpBXAjZbcm6t19ZppZnIcXslx1H0e0JUKA0kHOmGHa2pdMEYNp1h+QT8TCXa0/FIp+V6ZlXpCQfECePRNl2M0+neCXgYFm7z3B75K4WskBxpNUQlQQsOzFL386mXU5/i0I0Ha8Hx/fHJlhJv8IWGYTJVYoLVKEK9CsUJ8WPVbXdBFVanoF5OSzAZpEqTd0f1F4Y7a2yXbcmgBJTijozk+jsFuCBWYDm5v1w1gojSg/ry3SCJB1ctnowQqfw/giheNmYivdu7nMlD27oopOG2Hlxi68+fVeAQiNYpESl5dCQZIHjpfovPpTzJ6CrFCBinD940qclVLgb1ywivObNWrrpgDuI5ISLyKpt+K5QKV7tK6DGDvb+mt3IKpN/xHSsjjnGkUv1QKN7FnRFQGeG9VbO2c1QVXaaTKPe0zZSa7m2YcbY8vG3imGIv4ahBt9+6HT0QlzxNNDU9pJzR7zqYzeEmJIDG6iH4IoNOSq39C3Gime1CVNPoPW2Qoa/N92F7/9HoGEoHJL0fV/0PF+lnaywrRU8lMr4VoT6R6trGM6YagkJes528M50ym11LHwIq55fRDrGgAkvr3nquYpJBDnRu2kYYQ/pj15yI6sBrCud5TvHEeoGecEggjBPEXQdFuNKxGImafyKTpHWV4CyKlqeEVbhPRfJdZHKjnwTzURHJTpD6un4wcJB8q1rWEccd0TUq27Q2LIJKUtGzN7VgzEQCTmD
 cU7ftVhi
 1l30FH/cEUNGIQd7Os1tXi9GKEEp9gvb61u4pbMIZMM7Kcb+4mEEH/9wp8uUOjEA3cKb6EuXiZ6MNq7GntYS6kXNG6A==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 26.09.25 15:15, Sumanth Korikkar wrote:
> mhp_flag MHP_OFFLINE_INACCESSIBLE was used to mark memory as not
> accessible until memory hotplug online phase begins.
> 
> Earlier, standby memory blocks were added upfront during boottime and
> MHP_OFFLINE_INACCESSIBLE flag avoided page_init_poison() on memmap
> during mhp addtion phase.
> 
> However with dynamic runtime configuration of memory, standby memory can
> be brought to accessible state before performing add_memory(). Hence,
> remove MHP_OFFLINE_INACCESSIBLE.
> 
> Acked-by: Heiko Carstens <hca@linux.ibm.com>
> Signed-off-by: Sumanth Korikkar <sumanthk@linux.ibm.com>
> ---

Reviewed-by: David Hildenbrand <david@redhat.com>

-- 
Cheers

David / dhildenb



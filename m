Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 23106CCD187
	for <linux-mm@archiver.kernel.org>; Thu,  9 Oct 2025 09:34:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 57C658E000C; Thu,  9 Oct 2025 05:34:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 52CAB8E0002; Thu,  9 Oct 2025 05:34:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3F4428E000C; Thu,  9 Oct 2025 05:34:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 2B8758E0002
	for <linux-mm@kvack.org>; Thu,  9 Oct 2025 05:34:50 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id C4D5C13BB81
	for <linux-mm@kvack.org>; Thu,  9 Oct 2025 09:34:49 +0000 (UTC)
X-FDA: 83978066298.05.8C21A1B
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf25.hostedemail.com (Postfix) with ESMTP id 638E8A0007
	for <linux-mm@kvack.org>; Thu,  9 Oct 2025 09:34:47 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=aRh1HmeM;
	spf=pass (imf25.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760002487;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Kh8JGXUB1NsHJYxaM+Pss4KMWF9Q9wo9txu36JERlj0=;
	b=Xr/nEQLhdBGRdYuKJECU8mB2bqUb+A3JH/DIpZLkyykKZPhp45+MVVy1RG2pbQ1YaP7UjP
	6OhTVzuJtlaljfYS56BxqSnPVqV4qJGGHCRKZHYc97CJF2xLjdMoalh0n5zmpOosp3BZsh
	3yhMPs2qvA34PxsGhvX265Mrg1SSCyI=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=aRh1HmeM;
	spf=pass (imf25.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760002487; a=rsa-sha256;
	cv=none;
	b=7OkYNN8oQPro3kXi85N1CVaXcoxhTyYWA76IE0OEYE+VlERuq6L+TgwftxjONGAtlwEPI1
	CbyB5kD4+ednGc6b0xR/xLZK3eqwkkZXXjC8iDf2ycEA48qHWVFc6EjsBbaKZ/QoiU6eTN
	DskywYdrk9RLRTlh5hTNJw1CCA6q6m4=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1760002486;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=Kh8JGXUB1NsHJYxaM+Pss4KMWF9Q9wo9txu36JERlj0=;
	b=aRh1HmeMlXHpBpLSFl1rDCMdfZz5+WnwCrTkOHIsiTFtpFEeZlHtsXLETEgUQuJsAF469T
	Bvgd10Ev0iIVDm0gz31KTuQlztMuUjQ2pDOAbW+IwMqg4QEAEIyqRmF7+9wZo5pzzkvbzv
	BC9gUTF4geYLtYrOgh/MjwznWyHxKUM=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-686-mvH-jwOOMhWdMjWaTFRLxQ-1; Thu, 09 Oct 2025 05:34:45 -0400
X-MC-Unique: mvH-jwOOMhWdMjWaTFRLxQ-1
X-Mimecast-MFC-AGG-ID: mvH-jwOOMhWdMjWaTFRLxQ_1760002484
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-46e3d9bf9e1so4179175e9.1
        for <linux-mm@kvack.org>; Thu, 09 Oct 2025 02:34:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760002484; x=1760607284;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Kh8JGXUB1NsHJYxaM+Pss4KMWF9Q9wo9txu36JERlj0=;
        b=n6Vb62l4KvUoZtNCoTj3RJDXinChmy1gf58GV/DO4PiGet9GcrJFc6iD+V4SX2MPAG
         Kmxu4Nf5QpCe7b1X6ZwGez9YhRB16sE4MQDCGnnBH782MuO7r1TOiLt5JVToLCDclTDm
         bTwUGIYjB9GMTur/WBbkioBbCnokDRZV+pY7vd3sXaAelxkLQS54LrZ4iKTX8eEqYxGw
         fWe5uVRpiN8nqWLZnoKziYcjI5B4+FfW0TdE92+KweHdqBRsC9wezwCB0wo11rDpr6ZM
         yeSZo0znBKfkZEYGKjR1kzd7jOiCTUdGPCzcdsjcO4tKvblWJpvEH4C4h8oqDDJtbrE2
         cZtw==
X-Forwarded-Encrypted: i=1; AJvYcCWw0Wittw5J6NqwC2ODOvNVTyi0kafzq4iH1F79j6QHxKOOICT+rqUkkZXa5TuzMFwNV8a+NTmeCQ==@kvack.org
X-Gm-Message-State: AOJu0YzppvUYARHzgfcY7AsztQIadjKGv+r40aMcBEXrxsNF9VWy9CCX
	GHkwasZqworBUY+N/dSTZprG993Kfba12nYdpRiONExS0dwQy72TJKXXm2PaEnDzByw6uOAfz1Z
	kaZq7xtGisohc8xLaA/snR3gUUS1Dx/IGBbPzPqn7eYIAtGeRJiRO2y+2XAMj
X-Gm-Gg: ASbGncv+vZlG/pUwqxNlTNnfSvzUdTvJ6lRZizIrCLl6RmCegmDXl9grnpBGTpvY5kD
	8Exy/HKlktaagP2czVxNS+8tuVktWz0CEQgo1lUmV2nuW2AmPw05+HbmvC+f5TORN9dVw05xlsM
	JgCeOTOHJpIzNzGIN3GqpehEigCLsQwy9LWtPnxnuRzoBlssEPYfKCkL+zJO8tRldvGeDdgvnfJ
	Sx/7a5pmron8WfVN8MVbz9lJgipdyJ6ppwKGjSnA1UjixdBvAHiN4sMqhR7mt1MOYtzmd5cr2h8
	vboejVcW1xysfuqnbTqdDvVInI2G9HG+fr+j8ANuWbJVnOIBFrHrFN4XFzl8SZlnrPqWItP75J/
	ITHomMu8n
X-Received: by 2002:a05:600d:a:b0:46f:b32e:4af3 with SMTP id 5b1f17b1804b1-46fb32e4c1bmr5153175e9.1.1760002484183;
        Thu, 09 Oct 2025 02:34:44 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGyfdLHmeLVcS/24ELo6N5hr/uPsFsSPCfyzvUigm3fcqdF/w8z07IDJSwlfvj+lOzROactJQ==
X-Received: by 2002:a05:600d:a:b0:46f:b32e:4af3 with SMTP id 5b1f17b1804b1-46fb32e4c1bmr5152945e9.1.1760002483746;
        Thu, 09 Oct 2025 02:34:43 -0700 (PDT)
Received: from [192.168.3.141] (tmo-083-189.customers.d1-online.com. [80.187.83.189])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-46fa9bf8288sm76286315e9.2.2025.10.09.02.34.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 09 Oct 2025 02:34:43 -0700 (PDT)
Message-ID: <5c6aa34e-9f07-40f3-bd5c-2ad3242b31eb@redhat.com>
Date: Thu, 9 Oct 2025 11:34:41 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 01/18] mm/ptdump: Replace READ_ONCE() with standard
 page table accessors
To: Samuel Holland <samuel.holland@sifive.com>,
 Palmer Dabbelt <palmer@dabbelt.com>, Paul Walmsley <pjw@kernel.org>,
 linux-riscv@lists.infradead.org
Cc: devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, Conor Dooley <conor@kernel.org>,
 Alexandre Ghiti <alex@ghiti.fr>, Emil Renner Berthing <kernel@esmil.dk>,
 Andrew Morton <akpm@linux-foundation.org>, Rob Herring <robh+dt@kernel.org>,
 Krzysztof Kozlowski <krzk+dt@kernel.org>,
 Anshuman Khandual <anshuman.khandual@arm.com>, Dev Jain <dev.jain@arm.com>,
 Lance Yang <lance.yang@linux.dev>, SeongJae Park <sj@kernel.org>
References: <20251009015839.3460231-1-samuel.holland@sifive.com>
 <20251009015839.3460231-2-samuel.holland@sifive.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <20251009015839.3460231-2-samuel.holland@sifive.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: r8NjddVVmRtauyeZvrJlEs9omXnrgoRxwycfEk_U5lw_1760002484
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: o57stjeyxpwsnzxu6zgqupebtr16ptin
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 638E8A0007
X-HE-Tag: 1760002487-97254
X-HE-Meta: U2FsdGVkX18rebGmLmTZrpW/hQe2mtZXRvqihZV75l3y+IEn8uRjmWWv1E31mkdopB9CiZERxKfPsjlR9KDVjFsyxaWazI/QYuz6ph/LkmrU3G7w2qyk8R9SHQKOjF1Hbvto5FeJWTru97j92jNta8Acz+nmubDXqE5Ka57grM+9SrmUS2cLD298MXAUYshKPiiXVR47bat5+ASuT+Gi7LNFK0Ig/9f/zyCsUEMAdwZlhF0wXX9YVHoGdPcPg/oKT+VV7wHGvmrCPR6W88QqYQIFp/fGr2K3Hf85LEXOl/bni/13yCeTiYT60KF3HmJihxIk0o8sQG+ldoMkR6UBIouo0+BtGQRDv7mKJ8Q5KZlSLHqvgUwzvJBPU3bwbFe2VWRdmg+zqZPd0nMXuOxU0mXyzZzD2ekxBhY2/v9LEyAU4NiwcsbcUg6rPzHmDiBWeHtEvHkOgdEMD61fpclB6oQlyPqqEvxOqM32qF0H22e6uN6I6b5qYiUHqic4bLTVCJ5oahLXqwDhVTt2pdvAAe0M6WQ6PtKMnPJCrFyPYllapW/QOIjKxyVVjfooy33W3r9YdcX3lu6BIpacC2E+b29ufqhqXBrC0zXp/i5usLPyNBL8e8Oh8UpCJS9Y/q2VcTNJxp8a30gk7j69Jy69uhcouX3/BKMXOsIov0e0SXWx9OIT1tSYBobDKx7U/jVbb5B8ZpvwGVrFpBRM+sncqc1DjhSY+jcc28MCa0Oj1EgtofWk9MbvUE06C52CC1xrjDg/pqEv2otgPFX0Wl+upXOHczNhhOyCOq8SeEwHpS9Bi5mvXAKwxj+Ma+yhonZz97982t5RFUoSftX0XEB9REnImS2TQJS9ieSiZGnIEdcq/voFc7a+8kKcv5B3zkpgsQOVouQo9xqdpm9k8QVyQEKGJa0WUgO7lhMS0XSewM6jsWjW4fY2M7rMT2vV1c6Oa90DkAnWK8CJ8ZsMJLO
 rIK9BdHg
 x2kloKbLBoHOQRX2qASomhVSiv2RvTyICYf2l5xW07pZcHEJb3aH2KVX7XeNzQ+OsApszJyKVpnq9IDRYhFtah0t4lN7k2NG5kgKj0dbGGemPkfKapvvPDBNyIwjMc/oIyeZlxNHBIRtX2y8YHTkYNvLEUZ3aBmjpFXs+0Dput7OA8SSyRb9fvzbffz9EKmMQGY3us0B2X/lIPyOur8ZMtLSEN0sMQlRFHcicLvcQaCnMkrn+58xzgGg4Jfpg1UTTgyU3iLcY3VTJ5yRJWEOgYHhbh3LGQ45Ao3RosLtPU3wKtugEnAkvlUI0NwZ0uxNRdmh+smHlJsKND73P1W+5YYMEZmDTMSvYa0CBY6U+C5g7gMB+xngWpzG8DZAaLIDZeBAqYrZF8IlUyvKmMtP2GbJZAjdGsu3oFgwnoZcZqh4RVEV391XAT35eGu6/OXFB34Yrb4Tp7Yzqx45T98DCA03oLgZrlywMJTVZV+hLUuz5idSwZSaAp+OtxlCKiW8+bE9ARN+utmoWr2IbPqvFUWR8YDf15jjFtcwtnbH12RqPGcneI4+lf0uMwHaHpT9o/NcAtTMqZiuf1282wJZj/oYdSXA+8G0ZSpc+Qv3gQwilzTc14lfqa9SaLLOfnS0B5Ob0h1rncVbk8JqFaNRcREZN4+T79R3AA6nYnJiN/0cwAXk9/1CQ6K90P9aeV5ElNJHCmr71vORxfRNBve7H4hkWB4MeZGaCQVQssKpMt88pAqy2F0lNzi6gUFheKyzbNkudu5nT1jGfnU/MjdbvMaUHMLHVVhCYJ7/qXA+j/47L1YccfjsFVnP91XIjbNCkncX7/NxIYlhPcMccpLF8hwIriocLkImYliNPqCZ+ouetSCXUro1sYXsPFQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 09.10.25 03:57, Samuel Holland wrote:
> From: Anshuman Khandual <anshuman.khandual@arm.com>
> 
> Replace READ_ONCE() with standard page table accessors i.e pxdp_get() which
> anyways default into READ_ONCE() in cases where platform does not override.
> Also convert ptep_get_lockless() into ptep_get() as well.
> 
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: David Hildenbrand <david@redhat.com>
> Cc: linux-mm@kvack.org
> Cc: linux-kernel@vger.kernel.org
> Reviewed-by: Dev Jain <dev.jain@arm.com>
> Acked-by: Lance Yang <lance.yang@linux.dev>
> Acked-by: SeongJae Park <sj@kernel.org>
> Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
> Acked-by: David Hildenbrand <david@redhat.com>
> Link: https://lore.kernel.org/r/20251001042502.1400726-1-anshuman.khandual@arm.com/
> Signed-off-by: Samuel Holland <samuel.holland@sifive.com>
> ---

I'm not sure why I am not CCed on the full series given that it 
apparently has LOADS AND LOADS of core-mm changes in it.

get_maintainers.pl is your friend ;)

-- 
Cheers

David / dhildenb



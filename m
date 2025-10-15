Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EEE0ECCD18E
	for <linux-mm@archiver.kernel.org>; Wed, 15 Oct 2025 12:22:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 56CF38E001C; Wed, 15 Oct 2025 08:22:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 544738E0002; Wed, 15 Oct 2025 08:22:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 45A978E001C; Wed, 15 Oct 2025 08:22:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 35F228E0002
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 08:22:32 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id D42F616013B
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 12:22:31 +0000 (UTC)
X-FDA: 84000261702.07.F9F57F6
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf27.hostedemail.com (Postfix) with ESMTP id 479E440006
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 12:22:29 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=I7kOLgJ3;
	spf=pass (imf27.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760530949;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iJIT5ZHVJDyQvT7NeT43ejVvxQTOh2WUzsnVYFXK6u0=;
	b=Uc3Eoeo+zzAQOnXQTQ8TVbT/eBg6kBcZI5UK7sB0Y+MKI5T+xOQoERRHr6vn/UgQh3t6f0
	9CCCbrsoe2bq5pp4jwWqC3GLJPTq6Y23YZMR6XX3e5iCjveZTk50YBBjVb17MIwcdgnww9
	WklAp1NPiY0rz/YengrrEiPCgaKSFZg=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=I7kOLgJ3;
	spf=pass (imf27.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760530949; a=rsa-sha256;
	cv=none;
	b=uQCgOC9escVJsMFRo0cwMDUlHyWjgq9Enf+J8QixHQFhTCyix22Woj7C+LlXDRAvU09VC6
	TqMIzOUznrlNfzWwfnIx1Tcq3T9rIuTn/I19Wzvky1sllNDVkLBJABhvvUibtAEVPFsWdc
	/NPY6TqPDvGGz4LWcmC5twsogTncIJY=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1760530948;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=iJIT5ZHVJDyQvT7NeT43ejVvxQTOh2WUzsnVYFXK6u0=;
	b=I7kOLgJ3uy6M9Uxbdo7lAl+Yc19PkARfHHTV2KGlw4YZVyUJPPdJZy0LLJMcKRxVYg5U0k
	cuozfsLuFvX1FrQ2pFtr6WwF3ZB7Ta0rh7JscIddG/Q88tjtwwj0axircx1IXpqXsiFnjd
	FTw6idspE5Jgd+SscSzXBGvzDo2HlHs=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-695-rib92eJ7OmiJ8CFwVnsnng-1; Wed, 15 Oct 2025 08:22:27 -0400
X-MC-Unique: rib92eJ7OmiJ8CFwVnsnng-1
X-Mimecast-MFC-AGG-ID: rib92eJ7OmiJ8CFwVnsnng_1760530946
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-470fd49f185so5738645e9.2
        for <linux-mm@kvack.org>; Wed, 15 Oct 2025 05:22:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760530946; x=1761135746;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=iJIT5ZHVJDyQvT7NeT43ejVvxQTOh2WUzsnVYFXK6u0=;
        b=K8QLHPQinI0LqwDRMNHGXP+S1Fs2ZQnIxxp59Xn2PDCcgJ49CLpHa6/AZkxD2XdbsW
         biO2T5IeihNjHjQuxgG40DyDK6ow0b+dIenop16EP/TeqjmdAhoqXS9Hr36oTed62ybg
         /rgF7mmm+9TaiyZ+n3+LQAVfcw/kOlO7l5Rrsp+swMhG2pfiy6dutL8l+scafGcXXO3K
         RzudUaMGKC3HUqL5RJ8f72clyEUcEi4uLDLnTwuPqsC/b9Ty5bMiMW1KOzxJ36N4DSZI
         UTdQZ7gTtDIAUxeyXdjcFVKYalvGY5K3PFRHM/dTMcA9/KSlrzl5ZI8IDEs6L977i8P3
         GsEw==
X-Forwarded-Encrypted: i=1; AJvYcCVHctPQAVIY6r9mmswfUlRvtEN8NEtl6mPalBbnjtKB954s8qa7eptvI5ZzqEspLqgDFePQ700uXw==@kvack.org
X-Gm-Message-State: AOJu0YwOWKXYTGp7pYzV+OpsIMJkOryNRufe/DhbD3J6GLBkwe+8QQCa
	ho5vmMOsoy69yKObCt0aOdSQxgqtiLDVj9FXBMz+kG3A0O9JKydGLHFjyXi+ZIgyzd7q/XTa81y
	zEq4PakI5fwpmTBoYv72LDhW6IfigFy+fTE4pCuAwl+8yQfByOjvl
X-Gm-Gg: ASbGncsRdtzbCYFd3xSustYdli/mAClTXcaALT6KCL9UBlAKji5dw4e5SbJE3ULx26j
	mXk0YitlbTtOpSiiCTSglKRv3VxrUK8JsdEFeIjgol5s8EB1HKlBnL2u+eXpHn/C/+VyfyBHHzL
	VhRYfJgEph3WgmZz7x+yw3GnmNlVicMhD74w6aGA360arUip6iexehD8pTvM68c7LveNeRNeI3A
	+5qkIq1sx7No4iXzFrNOK/NRgnVmdqfdEPeHETpjtYueItQ6axhsEt3GexQlktCFOnGelr4CMOa
	SYPJSaolVlEhans/PKBkko4Mnq31EwgNR466HiOFFs2ODibfyxFIWeo9D1mZ+JI=
X-Received: by 2002:a05:600c:a47:b0:46e:45ff:5bdb with SMTP id 5b1f17b1804b1-46fb4816974mr150652905e9.8.1760530946264;
        Wed, 15 Oct 2025 05:22:26 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEKC5+HlkfIgPUZjNMJXRAqxnI1C8MphzQ2ar4bKN3XqMc4aOndmUgQdYilOQE2UMODbf2nuw==
X-Received: by 2002:a05:600c:a47:b0:46e:45ff:5bdb with SMTP id 5b1f17b1804b1-46fb4816974mr150652675e9.8.1760530945875;
        Wed, 15 Oct 2025 05:22:25 -0700 (PDT)
Received: from [10.32.64.156] (nat-pool-muc-t.redhat.com. [149.14.88.26])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-426ce57d4bbsm29263452f8f.2.2025.10.15.05.22.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 15 Oct 2025 05:22:25 -0700 (PDT)
Message-ID: <86ab6678-94a3-4150-8847-4fad00e09452@redhat.com>
Date: Wed, 15 Oct 2025 14:22:23 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] ksm: use range-walk function to jump over holes in
 scan_get_next_rmap_item
To: Pedro Demarchi Gomes <pedrodemargomes@gmail.com>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: Xu Xin <xu.xin16@zte.com.cn>, Chengming Zhou <chengming.zhou@linux.dev>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20251014151126.87589-1-pedrodemargomes@gmail.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <20251014151126.87589-1-pedrodemargomes@gmail.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: sPUTWATLVxZ_w4HwVRi7xmWMPe08nZHSsL5Edmx5HFI_1760530946
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: z55q8dax68ah6a3qywx36zcmpawacci8
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 479E440006
X-HE-Tag: 1760530949-877210
X-HE-Meta: U2FsdGVkX19J52iAKpOOKLK50IHotuEAlPHhGmZ3XzqhdWBjz+GVVPjErgAdtzgC8GeUCjVKyzTDW3roscG4NMa7ChJrwUtFn45kO/ClnHz3NHK85V2VrYnmasfmIQ9/CPHwU60tiveI+LMVpQyp8UY3UXYcIy9WJhXQaZYATu7jDv1nm/T5/Z7Z3ZDAAVGRce/Q8YCQjerk8/o1kbV+B4yLLk6/mtjxXDa79Ec+CHuSZ8QQgjnXEUlG/KWpY8STsP16pLXMmAaQ7MfLLAUcr+cGYkCuqWwwtYWQelJqO33HLB2zrgHxGj/mA5JJ9mrLg62fCAMioxJyDdrql38oLAcDKWgEoAK/eXjnpwvRLoo5ku9us2jxQkjwNONLZUlh9U9dwzftg7NbNxVnQX4mQaI+PL26CDNvKdCuLdYnNCIBsAl7hGQOxAzELT9Rk/vTKTdOf8v+HUb2gCStAnJdCbxeD/P47BnBeE9XMofqw/T3j2E6Fvg3g//Lw5rzTbwEJSl9jcOYdOd6lQATA4Kag6rM4p7LyDAx0jaraxObAX86m5CL5Zx76G/nh08E8r3kfPNUgVIRjRNdmDlbTzH/YYS7FIXyOwsUsiByg+Odhf35Of1d0D40prpCSw6tHj2wSKr0PUWWPObKKeAt3ENysS8V3Ad9EZdV4PCWXjdJSpvkzbPAR3ps2EWVZPHiGQCZnXH5e/5mr2r4jTBi7ZcR9Miy23zRQIRf//nIovA/l4YAfeg2CVyLrF1+wvw2OqI+8+VgRw8UoHUkrnvxlYajOLskHbnK2zvcXnahjFFxy6E88PzB5/W7zyA3knvMY0pzF4PfYJVJwT5QrBpDk3jDxx69/HlcsxpSTmD2dO7Me9CfeGUb/eOWd5gbdzbAgUIK5FgjfYPx56aluTgUIpaQXlni0ynC14/d/8BywzUk5iFcGzDWjUZCyXRUF6QXL/rTYV1z2F0Uc41h2vMrJ3J
 iuzmymTO
 x+V7haJ8x3iF5AhN4ak1Ze/2tp/1+2zMb4YgsdRTZJ1DSCG9BMgZ4ic1RAd9gmYroD77YaT01nmIDx2xHuWPVn9ojn/MLA29B2tgxhcdAvtNLEfUQXY0IbfY1Dp7KoRKCBdHSkQldhcHlEvDq8Rg1IF136zWvS7UJ9pvsbW8KIPBzEfjmoyxfuGRsNv4ZQ4YCxh3gHg3AV5WXi/Cq/NgG6+E+eV+scg7fa/jrlXbLzQApgF3kafoAag6AatGrPrIrScX+alGiovzPW+J318hT4cnKrM44BLxvOCXlCgYs+oc34qeO+/lKCU8sb+aqU1AiALsDF6F6sB+p6aGGNd8JBjo1FrrdgQ7LDuP0YF12ezNrnNOsaDkMHv2yrlbHkiGRW665zk08K6/qs6wca3ssCAcTVyFDt6+UNKC4oP2Y3aiXIFGL3JPwprU9M632vC8Qx2LwMiz4wvfgHLg9PFXUFQFDkGAmhwsJCyNw0tyhKH4tHeQzAkEZEkSEj1BXSGkRiUQyel6DACqxCsDHjgFAsYYqXjrEPGKOARCYYQgNG7kqaARrgyLq1xjVejX5IUX64DPWWsHuLlRrM2DucABTeQp8uiYkIVM7MztYNxtWng37OFl7oZzxwjzEaQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 14.10.25 17:11, Pedro Demarchi Gomes wrote:
> Currently, scan_get_next_rmap_item() walks every page address in a VMA
> to locate mergeable pages. This becomes highly inefficient when scanning
> large virtual memory areas that contain mostly unmapped regions.
> 
> This patch replaces the per-address lookup with a range walk using
> walk_page_range(). The range walker allows KSM to skip over entire
> unmapped holes in a VMA, avoiding unnecessary lookups.
> This problem was previously discussed in [1].
> 
> Changes since v1 [2]:
> - Use pmd_entry to walk page range
> - Use cond_resched inside pmd_entry()
> - walk_page_range returns page+folio
> 
> [1] https://lore.kernel.org/linux-mm/423de7a3-1c62-4e72-8e79-19a6413e420c@redhat.com/
> [2] https://lore.kernel.org/linux-mm/20251014055828.124522-1-pedrodemargomes@gmail.com/
> 

Can you also make sure to CC the reporter. So you might want to add

Reported-by: craftfever <craftfever@airmail.cc>
Closes: https://lkml.kernel.org/r/020cf8de6e773bb78ba7614ef250129f11a63781@murena.io

And if it was my suggestion

Suggested-by: David Hildenbrand <david@redhat.com>

Not sure if we want a Fixes: tag ... we could have created gigantic
VMAs with an anon VMA for like ever, so it would date back quite a bit.


Please make sure to thoroughly compile- and runtime-test your changes.

-- 
Cheers

David / dhildenb



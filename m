Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 64209C61DD3
	for <linux-mm@archiver.kernel.org>; Tue,  1 Sep 2026 08:42:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5D75F6B00D4; Tue,  1 Sep 2026 04:42:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 588636B00D6; Tue,  1 Sep 2026 04:42:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 49E3C6B00D7; Tue,  1 Sep 2026 04:42:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 2AF7E6B00D4
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 04:42:54 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 2222E1C1806
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 08:42:53 +0000 (UTC)
X-FDA: 85164553026.14.69EBB27
Received: from mail-ej1-f48.google.com (mail-ej1-f48.google.com [209.85.218.48])
	by imf04.hostedemail.com (Postfix) with ESMTP id 3EDAF40004
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 08:42:51 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=R13sx6Do;
	spf=pass (imf04.hostedemail.com: domain of eli.billauer@gmail.com designates 209.85.218.48 as permitted sender) smtp.mailfrom=eli.billauer@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788252171;
	b=5UiRRY4jt7KydKcp7UM9RUXCp2q1VsEpeKcGEvTyWZ+4dDkRCKnscn5tDRVsTtxMSfgO8r
	nybvmtDKITvVwlSaGgtxIMbLdYLzUty8HUWLRZok+DBbhhVHIGPgFhYWVELUyj6iEmtgIw
	SJMEugBcUiyxa2V5SyNebUek/t+IJU4=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=R13sx6Do;
	spf=pass (imf04.hostedemail.com: domain of eli.billauer@gmail.com designates 209.85.218.48 as permitted sender) smtp.mailfrom=eli.billauer@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788252171;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+NB8kXEuSYL9KHpcK9ADFRjV/ISbKtGYd98joTGYzk0=;
	b=8q7eyOPmX+VU6idxT58ojEs2mx0CASLgGPvOms56MZ0pOExFwMiq03vXBUlYPL3AWDHaYA
	v/BLdh9Fz3ZF05mIER+kp4B8k8nc6+1nI9731zhejfBJbpA7S+K2nnoAqvKttPUduysFst
	8oKXhBwsopF+4M+lwUePLHTL48e1U8g=
Received: by mail-ej1-f48.google.com with SMTP id a640c23a62f3a-c15cf78d1a2so65668066b.1
        for <linux-mm@kvack.org>; Tue, 01 Sep 2026 01:42:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788252170; x=1788856970; darn=kvack.org;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :references:cc:to:subject:from:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=+NB8kXEuSYL9KHpcK9ADFRjV/ISbKtGYd98joTGYzk0=;
        b=R13sx6Dowd+iMfZ8JXDMuJeaQToBj/fMClUiQ+/Q9+Nfz1H4qbR5qeLb2uQFgC6uel
         4xlQeeDxrJloFcqa7kwCuyn1xRBLtZcYXhwsTKt6eaMi/8WqZiQpwN8dsQh50Q4/O7vh
         2tmNaoxe4jzH+3fhysxGuXLXPT9ilCDsJFA7SkR0ktSfvYwGTz6oP25vRT2ja1ArBMOz
         fhy152wJOzJkc2oJwyVXRRQ7QZyjtRYbVj0nqnEJjyvkPrXeIhWiFkQfcgnj9cJBMEEf
         rb8OjrIZErim3bxL/c+ZIXB8RgDS+6EWeQDjKxvzQLhjdQcrXqb3S0hIrMBMdjcqDjR0
         YPLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788252170; x=1788856970;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :references:cc:to:subject:from:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=+NB8kXEuSYL9KHpcK9ADFRjV/ISbKtGYd98joTGYzk0=;
        b=pKRDVyNyu1iCFCHpWhiJC3l1qBg9ETq7coqA/a3yX0RJIsRDGQ7VEY59Vi4bUSz1sO
         uQweUtgrqnyehSKsjiFseoH22Mx4r3UhE+emySnwZYXLZUPDdpnOUX6WwmVOIOBesL4L
         boVA942ovq9ISUld3Sm2ekVDxrOvpBS3/UKezaZst5Y+J/bncMYQ1Yrnr6Gi3H7RNFZs
         1DFwWS/KRgkVaky3VHsuBrQgFEPmFHTU5o8rz/RuSQBrqLlHQBX3HemerbbIvvL9mzZr
         QkeKrvrm36qzspC4Mue2PieFgzOsaZjg4bZLFSy7m4OhB9mljpJZk9KmLh1pyVaTRUhq
         vB+A==
X-Forwarded-Encrypted: i=1; AHgh+Ro2OVSzUNJ9Md0XgTxZBY9wHiM+rWJ/LKqj5VU0IEQ+gfnJowC+NemM4b50frjK/GQPnvosfjkFvw==@kvack.org
X-Gm-Message-State: AFuF++lBoQIylqa1MdHSpfPi5Ap9e3O0KVO3SRFNrUR6JIzQMe6najie
	RviLcOldiXMyCZCvwUyjNNiMOGwFnO5x6sU5OGvwafZnlCafO7Yo7FKm
X-Gm-Gg: AR+sD11Xm1RSG2Q3pLK85jP/MpWpZF+SjqHDjHjw5I1lP9DC8tAGrBan9uZQ8zDbFxq
	90peGpLxzcMcetySKoj2QCXrXWsAlJstaozsskrbDI8kPmqZ0Vz2nAhdDRjga3g/uT3WUu3aH2b
	GBEzxLcd1EeFC3teI8wXLtQgWJXchBVQ1RiGTQMS0FakCItFPuUkVbG6M0WCK7RDsIGsRF0qIx4
	o6HQa/eS5dv1FGjeGILL/aqCggFXjh0yTsB355KUm4ckb7D4fBIiNuyg+j6q41hFaRyhuKpSeOJ
	fTnf1XKqP8ZKsrIjQXGL/XV2Fu1lacHfTKMGG7/KKT3L2AxEjd5Js+GoZAaE4g8SFNGmkrI+ofp
	FzngOosxdVcDe7MvUHnqILnemDQjPOyFDc8enxA7c0JZXwvRvCef6Q1BGxTIFWHVM8gflsIJBlH
	bLvBv8o6yC9OMwoOa+PqTJFLxrjemClDbu4wVaRGdZ/YVXCv2HHLhpdXfbpO3NcxmZAPvYyi9+1
	2P6N4Sz72XOMzSAQxqGBTc=
X-Received: by 2002:a17:907:c491:b0:c20:53c7:488d with SMTP id a640c23a62f3a-c25572036b9mr1872224266b.14.1788252169492;
        Tue, 01 Sep 2026 01:42:49 -0700 (PDT)
Received: from [192.168.1.89] (c-85-228-45-68.bbcust.telenor.se. [85.228.45.68])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c255f23cf9fsm543163366b.53.2026.09.01.01.42.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 01 Sep 2026 01:42:49 -0700 (PDT)
Message-ID: <7adfefaa-91c5-4bf4-ff98-5dfbba0eac96@outbound.gmail.com>
Date: Tue, 1 Sep 2026 10:42:47 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
From: Eli Billauer <eli.billauer@gmail.com>
Subject: Re: [PATCH 2/4] char: xillybus: replace __get_free_pages() with
 kmalloc()
To: Mike Rapoport <rppt@kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>, Brad Warrum <bwarrum@linux.ibm.com>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 Michal Simek <michal.simek@amd.com>, Ritu Agarwal <rituagar@linux.ibm.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>, Matthew Wilcox <willy@infradead.org>,
 Vlastimil Babka <vbabka@kernel.org>, linux-arm-kernel@lists.infradead.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 linuxppc-dev@lists.ozlabs.org
References: <20260830-char-misc-v1-0-05e2ce44f291@kernel.org>
 <20260830-char-misc-v1-2-05e2ce44f291@kernel.org>
 <f6001085-9234-4025-ff34-6cc4a66c293a@outbound.gmail.com>
 <apVmYXlqsVr_p4Oc@kernel.org>
Content-Language: en-US
In-Reply-To: <apVmYXlqsVr_p4Oc@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 3EDAF40004
X-Stat-Signature: 7d5dmjx4p1rum3f4f1d5u3cawxar6b36
X-HE-Tag: 1788252171-671494
X-HE-Meta: U2FsdGVkX1+DomJV+IO7kcC1dpc9J6tYJkKOpqDkgelEEEHb+4wcI2DZJgQZgZDJmT8laRYBbGDURZbowP/GIbsxhrHMK5RlAnCABl/kQQR2axoBs0VcCsu42JKDe5bKJEDiUh+Wvon8U0U/IWLPe1nwVw8WHTuHYv/QuhDWUpRFyhkrQQPd9Lg4uIcBDTb7R+gAnZVQE2OSOfzxmnC9aH6ZwU4L4qT7b4g2zktExRuZ9KbmjfCoHqwGgYCJMyjW3X9dj3cYzLCLl41Kd4PMEFUBHuWkyCgVKdL4NyfcOJU9FlpxNswbPsCnSVKPmIU5kg4DWy0+pX+3YZDPdfCgVV5Mv43/ebN4Td+J/ZNKSqCcxMJ78Jt8JoJmjW4CXiUkAuCbBqgfip52l41Nf5BHgWB7aJeLZvzvsunainVRI4NOQ+geRFGs7USXKjQP2N2vsWS0bRh/i3OV1e5iXsJ09b+1Ei3K/7J9Bh8RbahII8FBdGtzrKgU6XCFcQ6mh3x4YzD9B58Zy04Xlt+AQHnMIajv6O0q1amboXlzkwiSbkdWHugLaYhpvIO529FZUTn9BT90bpY9xZpuZJUTtVM5nHOlAIRLFI9glotsGOYCgZfp0Eh9GqQQWKpvYJpWDDj3VSCjXip2OV0lzyO/B1fpSiK+cWHtmyflCjFBnPKcXyVzLkJmjsSf1xzefELYYxKW0j9WpYaMgPpmNyhF72OQSr2QGYKSIyrDrAw1AAPsD3rgxGAB3g1bBvglWXnuyx3rb3hGdaWmeR9Mno7xM5FpY/TXcJvkpcDBfKufkuhZMPeL3p6aqEnRRMFzgrrtf0twphmA8OkHlJnlHxQJPjRfeVQCVLLjwnfyXELWibKXLxncosBxT0MyZEp2xAst1PaBEhNLveguW4FGA8GXkHuSCGsGDw6ZCtkSk1iGpss0Jf4fvx6tPItzEiXKE17klr6nCjibw8EAeiVUPzLhRWq
 VQAVWNsE
 rIu7xvjKbOKFKlpLwt6E8GoGH1Hp4U13FoWZaYtxhVGJuaaD4qLm0rDiVk5WxPPc6UmzL7kacnsWp0GxhS9fjG2/SOyRbdYFrolZsV+ZRYFkS46RqgWN8UlRJvGSVk8crlytiifbFy5IXToDrHZ+4Qs6Lv/ioSagndrB0oHb7gnGmpqOAKDsKepicLlt8Snx1G8VNmBfiOWV9ZN7sMdnIcM9+/ae7Hx7abVPHjl2I/l3ZSfjOn8p+SEwhtT3u/o/E57zdXsICD26wPC4/ymc/ar6/QtOBYLcUgX18teREkOhYe6cabSou8W69xEF2+zbdcWTFHWApa+7oOpxHZv1FIkaovYBfHTF5hvBxoLqFwA2r0xQWyhkKHjSqpfcJ2JqW08XNJhOyEO6nH6ID/cNcytJtYE1YQZkcJL7ytm4ngkLWQa6pT1Z2Bs3zHa1bmqtr8h8vWRsMI1ia8ZqGWLTD8I7pAmkfRt+oD4SpcPB6vbx9V9Q=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 31/08/2026 13:32, Mike Rapoport wrote:
> For large sizes kmalloc falls back to page allocator anyway.
> 
> And the doc is out of date unfortunately.

I think it would be a good idea to update the doc first, and by doing so 
officially change the API. After getting this change approved, it's 
indeed safe to rely on kmalloc() even for larger memory allocations.

Regards,
    Eli


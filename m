Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 728A2CCA476
	for <linux-mm@archiver.kernel.org>; Mon, 13 Oct 2025 09:54:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BBE738E002A; Mon, 13 Oct 2025 05:54:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B6E308E0007; Mon, 13 Oct 2025 05:54:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A5DF48E002A; Mon, 13 Oct 2025 05:54:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 908FE8E0007
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 05:54:09 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 1CF6816031F
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 09:54:09 +0000 (UTC)
X-FDA: 83992630218.04.F507A5F
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf28.hostedemail.com (Postfix) with ESMTP id 96F5CC0009
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 09:54:06 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=YenpYxw1;
	spf=pass (imf28.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760349246;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EJNqEM7yM1jaIMopGhasb5E5+Dj52uVM6msHKbTRxS0=;
	b=4J44OpBuXIrD6E/BdqUWoCFOmuD9iyZWN9p0n2MIreZW5BOo0BYqiaw4MqS7Fq1I16cG1g
	MdRQ6ZHj70ixGGPZ0EyngTCFXsbVEbqmLaQn/5eYD0Y+rEV01P1134AQqwRXFpjR0VjAG9
	8eBT7qYAiTfyUssTwYeOmYaIO+r6oSY=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=YenpYxw1;
	spf=pass (imf28.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760349246; a=rsa-sha256;
	cv=none;
	b=EO1ipiouYBIYfV0Ah9smyY0xdz54Lf25tCcr1gtSnD79vWC096A4xWx4qz4c5g6d5TkpvY
	0DkVUZWWft1ubJWbaolJYxgkYMPWWiPgjH8bkbVcuWQOyPFJrQZU4Q1OsrlZAKI8cCyaAv
	HbxOhYF7pWDcYyExpRwc5WrOtcnSI6g=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1760349246;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=EJNqEM7yM1jaIMopGhasb5E5+Dj52uVM6msHKbTRxS0=;
	b=YenpYxw1LXSnD1bK1rW9N8dFI4X9ZB2sh2VDhABPMyugAKbiVdSzE24KQABG6MVu0Tt+7z
	RI9AKbJG2ptSNp4gUQg6hKP+UOXWHf2OWgPxKDkOZj4o9GHQkvKlVk5lXN1FVepaJ8+kpa
	kzeX7UHXtONI9anWJbac82MmfLx688E=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-17-2EjShMfhNzCXfQEWMyndlw-1; Mon, 13 Oct 2025 05:54:04 -0400
X-MC-Unique: 2EjShMfhNzCXfQEWMyndlw-1
X-Mimecast-MFC-AGG-ID: 2EjShMfhNzCXfQEWMyndlw_1760349243
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-46e4cb3e4deso15140175e9.1
        for <linux-mm@kvack.org>; Mon, 13 Oct 2025 02:54:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760349243; x=1760954043;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=EJNqEM7yM1jaIMopGhasb5E5+Dj52uVM6msHKbTRxS0=;
        b=YNCp3Qrl37qaGVpg8phHV89+4pN5gZ/yMiUHf5PmmDOljp8jdD2jBzTUnc9L1rt6rS
         CZPa+O4Ed+ONhku+mSKPE9tJ3AxUO2VrZ2852EDEssjpCq7S1DPGb5muHjFi3k63WDu8
         x4ajy0uAbdfYLmDriRML1VyCanhhN1ADMP0M8528ldbe9FC9Z3ObrMAQ8fJFjtY6qWJc
         /ur35wCes2LPyE8weWP72yiWKBEC3VJIi1vGjTXrku8MCEuSkYWP+gL5NsRbM7vf1OLz
         ZUKQBHtkoKVBPSVSiqeWy5ctqav9pU3SBhudOZ3p7e0ZywnSBJHCe11AC1bQNJE+1Lkr
         en6Q==
X-Gm-Message-State: AOJu0YycckQ8+o15xeRT3i8CaM4x358gw6ahDs2ENKIlTNEXwWPOQaiX
	y5z2VX9naNVvhD45eX5gq0KdbRwUnDcpi7YTTlNO2x3DLn4KogEDwlZYPOgymi9wKseSOWVudgo
	pxkxqXHOJUtU3K7KYvoz336fbHepBTZIrIecZJYSqyKCdqxoFSzFW
X-Gm-Gg: ASbGncuujT3ZeVcgf9+WMtghIhR0uU7Qqid8Y0f116vyZU/BFPTk28cMi+WMrcVlkHw
	FLFlwHuSw44Q8Kx4p0uD1J2iTZrDuB16JmaG2hq2C6z2kJ0NSJBFL5qFA7hVHwnl7lfSqwQRhUl
	uM2GKSEIJ0x/3qNNTtALyOYvQ0ALiqGEX6DGmLj4FB/nphoDU3MgHAp0J7NNcF9W1eYem8lfbpd
	wYCfGaX8tpLGIVYxhQLlH+KJ8M9yReQeRz5YBBKUaJ6ii59pr1ieJNQ/Ln5PJNG9YeQ65sPW0Xc
	M0PhYg9C0tzM+BXP91NFNXm4AgYNssQNNbCgBpRAbMhwuXmAutx4/Mc0pq3TIexKfpKkZFbnGwC
	tSco=
X-Received: by 2002:a05:600c:1277:b0:46c:adf8:cd82 with SMTP id 5b1f17b1804b1-46fa2952c02mr117821715e9.3.1760349243173;
        Mon, 13 Oct 2025 02:54:03 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHTXPafYWeLRO7Uuqu7fC7gIcp+4dWzio8Ya6TXBPNgFi3I7AUlaSBX+TM+dTAwVgrNJI1szQ==
X-Received: by 2002:a05:600c:1277:b0:46c:adf8:cd82 with SMTP id 5b1f17b1804b1-46fa2952c02mr117821605e9.3.1760349242740;
        Mon, 13 Oct 2025 02:54:02 -0700 (PDT)
Received: from [192.168.3.141] (tmo-083-189.customers.d1-online.com. [80.187.83.189])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-46fb482b9absm200025705e9.2.2025.10.13.02.54.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 13 Oct 2025 02:54:02 -0700 (PDT)
Message-ID: <bab3249a-d9f2-4f19-9493-b7560aecc3ce@redhat.com>
Date: Mon, 13 Oct 2025 11:54:00 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4] hugetlbfs: check for shareable lock before calling
 huge_pmd_unshare()
To: Deepanshu Kartikey <kartikey406@gmail.com>, muchun.song@linux.dev,
 osalvador@suse.de, akpm@linux-foundation.org, broonie@kernel.org
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 syzbot+f26d7c75c26ec19790e7@syzkaller.appspotmail.com
References: <20251013093337.4432-1-kartikey406@gmail.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <20251013093337.4432-1-kartikey406@gmail.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: SzBDfG20a5-jzNA4ujFu5ulWYeJMuz6w2wduQEZ6oG8_1760349243
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: eowfynsz6r563ctgbgzqzn61bjb6izbf
X-Rspamd-Queue-Id: 96F5CC0009
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1760349246-394229
X-HE-Meta: U2FsdGVkX1/iIpu8etg9BJ3yW8ci05smkgrhGkf/fJTnzE04HmKddZRQm/9NGA6DZqC0jo4Z6QTdaSZdayZUfiLVeRdE2P6xfjd/zSoQO8deQXTO7Wdkp4u0S14S9Fgr/FNdyDGZc8OV6WsnNwdW4yeXrgxv2HOmMfzrI0Dx4MnS+C0R3ceWcKU96nmhMOuN3GEpgCAFMEsajh7GItSN4xY8+eB8JJMWIehnBPtZEk13K3BZCf+6ug4XUU9tIfO/TaR6YGvKaZFJTbCk7uAaHChxMErWsSbRQjUjyQAo+XZnP++toHuVfGBW/aEshR4knKLwZpApnlyN9i2EWxCfkuEwrVAdZskYMs4gk69cm+R6RrwwpKFMXUyyVkJuxaM7dBHN5kSOchcFkUeXmF5kM2r6mF3c0SzbzFn9MKz4FaZLtP5IpVN34tXCL6j5I+mMLxsmwX4xNrxeCUyiZQYhdvSunQwy2rqwuVSIWcw/4K1jMpjhxVojuY1NVSlOhXLklrSmimRWLao+6Cj5vYgzsUe7mwR9KAS8Xsz1/d+WamuJQ0KDGKgZ7lOXKsqMhYQtRIXl6ZjdaXr+d2/uOrdwdTrh8lzdfQcS0LRCZ2DDrBnwTsg361HpF+sMxPNE/emp9X7MPnaxPG43gcT9KCGA4klNas+sKbZknd+0lEnlEkObExR3cEFF7VkHjUdwvBL/MGwmzra34scuI4pROWOQatpU1gFIG+CWuD2MhrWIzMsbRK6VofCDw5CWBEM3PfUbKpawacMGZNqqpla0uqy3gqe+11N4X1Qx20UINm6b5sKHRCD7EDicvZpTBnCUeQF5oLQecivysCp8wM4+GwESp3yAUREjZ0fFOSf9cZpcIHtLkW7mnp6CUu+94OnPdRNGzUrLhVB8BtRnHs2MjWFXaJMtPqK0klg1tMmEAaDdbo9HEVaAJbJdXxbsZIMZTJkXB3fXjHr6+RGdk5ioVS0
 owUYbaHn
 qpVUTyVj/aBrKAJw1Viw2a/tjVkRNV6HWHRgiYEN4LonLWBy4ityjMzRa5IPKIOH+RoBsEvwsJrIUlJC8S5s73bQPUSO4+arjeT23qIhq5/vK/U9JZsEtlJUxghekDOjIiuohAnF42pBSbskOFutzghwJdtUowcKjxs7H55eMDdTpZS5GQhZ8Vng+ELnB9uVqS0yFPXzHm0Di6TPehTc45oo4eFsHt/xa6EJ1lFmQygbHD+IJ6KQ0PPKUewiMbFg6GEbSSUOarFvJ5N0OWlZGi/LiY83y1LqCP31yJET3rWqLbEG9mrFHowUQ0chn5YEYeCtcGzi1DXuBtpGlsEevAPgQtOXQA/ZKbleBPKzujP4zx5ipVG+cTbz7YDkp522tLy3ZZmfyh+mv2n1Y/ZvJrV2Ps3ojT9tstlLiIxdqZFycL60hVxuWvhrO3ATa72/mVMzR3LOICQRp+N2LNvQ0r9ZY3QtLLKyATw/c0TeF1SDToNJlg07XhLj2Pt9t3uqs1fStPwdnO/Nm9YFHPItp9ImA8wxQ1qgTqa8km2s7HiUOxiuzpcIoOzApVEBJ1t6iskgnw+a0Bt4q5IF0epnE4BWHiZ10vX6M/77zRwkT/1OWkEtz98gwhFRyHZ6OIc69LjYfW+UwSA/xt3A=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 13.10.25 11:33, Deepanshu Kartikey wrote:
> Hi David,
> 
> That makes a lot of sense - moving the assertions after the early return
> checks is cleaner since the locks are only needed when actual unsharing
> work happens.
> 
> Should I send a v5 with your suggested change?

Let's wait if the hugetlb maintainers have any preference.

-- 
Cheers

David / dhildenb



Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 51EBEC83F27
	for <linux-mm@archiver.kernel.org>; Tue, 22 Jul 2025 15:30:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C49306B00A7; Tue, 22 Jul 2025 11:30:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C20DC6B00A9; Tue, 22 Jul 2025 11:30:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B0F4B6B00AA; Tue, 22 Jul 2025 11:30:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 9F63D6B00A7
	for <linux-mm@kvack.org>; Tue, 22 Jul 2025 11:30:14 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 18D40112996
	for <linux-mm@kvack.org>; Tue, 22 Jul 2025 15:30:14 +0000 (UTC)
X-FDA: 83692286748.07.1B97523
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf24.hostedemail.com (Postfix) with ESMTP id 9E0E018000C
	for <linux-mm@kvack.org>; Tue, 22 Jul 2025 15:30:11 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=T1pzBQIU;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf24.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753198211; a=rsa-sha256;
	cv=none;
	b=mavmuZaZmAXx0aBAsd7ggR+utqbbUhS8vRUYUiKAn3RK2GNUkyd+iqbbaie1dayiRydfCD
	TwuSshJN4vo8j2bQzIlgMx9GYV8Z98uLFM+C2QC7pRZw5prF71uxAFAghZQ63E17cscyQz
	fux4y5j5VD144ubyUBJ7AgbmHwlqxv4=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=T1pzBQIU;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf24.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753198211;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xG23lfY5KrU0OHXZobKzS6Gwy0oCh0at7BY2Y5zGEO8=;
	b=GvmC6Xs2dOqE3S0hzFXWG/cZvP5uz8elso2nJHujw7YbD0on6QKmDMQnpI5o7sxzVIkhpm
	kZFAkzYWeQ7QFc5IgH+RMSQA+89Io1t9sHzl5lkCxSFlRSIbSFvc4z8z90x7OHlK+DIQri
	f2FKHiAFQ68neKhTjKD9iWZnwjDWZIE=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1753198211;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=xG23lfY5KrU0OHXZobKzS6Gwy0oCh0at7BY2Y5zGEO8=;
	b=T1pzBQIUYI7opkW7POCi2X2zPQsextE+GapXhnoG2IDltf0PnIeuv1i2h4TP3vX83THyha
	KLpOgQgb68g2nbby6xnPciwMRY27qQgPV8COZexe+LFyvMgUIAVApdrbbz96AtY30/nYeU
	5hPXh652PfO7RE25RTszzZFYNUxxqRk=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-507-KkFEkbyLO9GbpkaY5_Ejew-1; Tue, 22 Jul 2025 11:30:09 -0400
X-MC-Unique: KkFEkbyLO9GbpkaY5_Ejew-1
X-Mimecast-MFC-AGG-ID: KkFEkbyLO9GbpkaY5_Ejew_1753198208
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-3b604541741so4234953f8f.3
        for <linux-mm@kvack.org>; Tue, 22 Jul 2025 08:30:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753198208; x=1753803008;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=xG23lfY5KrU0OHXZobKzS6Gwy0oCh0at7BY2Y5zGEO8=;
        b=hcbblelICO/wayty3l/bKYttGpc3qimsel/xjq7yfnCjOrVr8CYorvr6Q8wNj5tuy4
         SCylxeczFsmUuKAJblgNYeLdcxbuqm6A4+8vzVbep0giyp1/LlnE3KmN+KRXmoKn/7g2
         SumKrhan89633ujfoS7yG8JuT5xCSVmwBOZIVaM96UrBSt01hhIxvOghUDdO2HGnHKVz
         GgOxfQ+r8QZkMry6Nvx7oc2Sp94nwJAL3bk2voNh/1G/iF1zNj4QQEao1TcIxMBUnZCb
         BrpZITzLaGBKilv8LjSjjZQLJuSs2t0RfG1JIe4K3elHSBzROAsVIydc319RMfxFc1mP
         1A/w==
X-Forwarded-Encrypted: i=1; AJvYcCWhuLAIKxQeK24qa6dM2EtWiwdm36QyrNJaxEldUSNbebn7p2KUtSySmXdiRILG3qqSusOCdEnBkw==@kvack.org
X-Gm-Message-State: AOJu0YyO4s1kAC/c+oOcHRxAcap5ZR5RT4kjk2sG5LJi5YHG8eY17Pcg
	8KBGRsWXQGkUwWTEkyBpivrfLsQS1IPoVcci6FMfUcXg2Rsz/c0HXb9MuACzSR3guyEUexH0usl
	LM0wilp/KqM13YKHXYel4jHmxJcQn+PZALNL7eCtv447xIipKDs1DWhibTCb89PI=
X-Gm-Gg: ASbGnctrHU/7U9rC2MZr9SSgoVLIdtBbzvduH36CXhNC6lpZMElA9PXsMxC5tAsnCbc
	ToOcA7FCqx1vYVXKnEF9HC8FvIzlQrbf3SSnzttjqLtejt3Ov//xhDdrZhpnDtjpQBoQZkqbFD2
	hWtU8YsC1iZKwJceZA27FcHMsk/GJYGOqazojcz8hd2YOxh/PerrRQuXC4HuDR2yvsWJsASdLOX
	1elr/Ep3TBt03S2f5KLpsDO3fYMnuN71TzjXRQQjwNSxVlq/OT5TaRdT1fLloMa36JKZlWSVUdF
	mmPaSvKOiSqN0kTq7e3MGeRXmtrJh9bSd5bwxOcfJJhOTw8FJc7Jz4iu8GocNDNzfcRqtLxtUtb
	CoMRVYkEFpPAXdd0r0wIsAGmZUdJWBtr9g9gdeGz9lfWTSK39nMLah8ay+SgszxGpDRA=
X-Received: by 2002:a05:6000:144e:b0:3b7:649a:6a7b with SMTP id ffacd0b85a97d-3b7649a6d30mr2499807f8f.49.1753198208262;
        Tue, 22 Jul 2025 08:30:08 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFnc7AP+yn6412+xgDHR+YsxZYNcagXCtBTKqNj/IpetAGqIFvRymJSYcZahZiNdQmEI4OZsQ==
X-Received: by 2002:a05:6000:144e:b0:3b7:649a:6a7b with SMTP id ffacd0b85a97d-3b7649a6d30mr2499770f8f.49.1753198207795;
        Tue, 22 Jul 2025 08:30:07 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f28:de00:1efe:3ea4:63ba:1713? (p200300d82f28de001efe3ea463ba1713.dip0.t-ipconnect.de. [2003:d8:2f28:de00:1efe:3ea4:63ba:1713])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3b61ca25443sm13850868f8f.9.2025.07.22.08.30.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 22 Jul 2025 08:30:07 -0700 (PDT)
Message-ID: <a65acb01-282b-4b6e-979e-e3bc2fcd9b15@redhat.com>
Date: Tue, 22 Jul 2025 17:30:06 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/2] mm/memory_hotplug: fix hwpoisoned large folio
 handling in do_migrate_range
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Zi Yan <ziy@nvidia.com>, "Pankaj Raghav (Samsung)"
 <kernel@pankajraghav.com>, Matthew Wilcox <willy@infradead.org>,
 Luis Chamberlain <mcgrof@kernel.org>, Jinjiang Tu <tujinjiang@huawei.com>,
 Oscar Salvador <osalvador@suse.de>, linmiaohe@huawei.com, mhocko@kernel.org,
 linux-mm@kvack.org, wangkefeng.wang@huawei.com
References: <61325284-d1d6-a973-8aa7-c0f226db95fa@huawei.com>
 <7b2c054b-fc33-4127-aaa9-9edf6a63e142@redhat.com>
 <924d9d25-e53c-f159-6ec0-e1fd4e96d6e2@huawei.com>
 <eb6a4203-1555-4aae-8320-99679cec90bc@redhat.com>
 <4c5d4fd5-5582-11d8-9fee-24828ac1913d@huawei.com>
 <8c9719f0-c072-40bb-b7f6-6f2cc41a31dc@redhat.com>
 <1D589FE5-3515-4ED5-B12E-D5CE23BA5D13@nvidia.com>
 <e505c25d-c4bf-4d87-8284-6aa0da2fd979@pankajraghav.com>
 <641F5B0B-2B48-46FA-AC58-3A8A4BEB1448@nvidia.com>
 <3702f6b0-27a9-4ca1-adbd-fb1e2985b2d3@redhat.com>
 <ocgxb3ggoaza3irdpea7xhcw3is4vbt24omy2qki36cxkmtecb@jpn7qtco3lvx>
 <345f7ae6-b2d6-44cd-b8b6-2bdd4b33e9d6@redhat.com>
 <CFAECEE9-24CE-42FD-8D55-FCE832D65DD3@nvidia.com>
 <A1B06D4B-5B39-47C3-94E9-93FE3F0A758D@nvidia.com>
 <c0f5492c-f9fe-48c8-98bc-d8cc8e7e00b3@redhat.com>
 <E0D87F2B-20AD-4AE4-943E-C126395C3CE5@nvidia.com>
 <66bc7274-ec2a-423a-8094-b8d4cc9438fe@redhat.com>
 <20250719192300.9e32c35ddc49f11c7954306b@linux-foundation.org>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 g3eXuA==
Organization: Red Hat
In-Reply-To: <20250719192300.9e32c35ddc49f11c7954306b@linux-foundation.org>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: YhCE_8sE2lu-rtjN4Ce2ipd56NpoXM0oeBAL1Da_gFA_1753198208
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 9E0E018000C
X-Stat-Signature: 8d81f4533wh8mxs5tybi4iox3wfbrte3
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1753198211-562255
X-HE-Meta: U2FsdGVkX1+mrgo/cQaLJL4EDXBNjOdqAtjfivgByq7RUX7OBkykbXGD7Vt67UxAya2AfkzWUaZx48dFznYPvYNCNZ/UIe7tX+TmyieC2kRvOuv6O1Onutb4BdrB+raK6Z6LaG++bZBvrTTFLC3bPQRBRvZYNzFdMkiRbH5F2W+7pWLhCGA8R5GrxwUsMG3Bl39N6GZJta+bMDA2BPZ1ZVXZTXvva88YRXYRqq2oE/MJKTuD8Wuk3hVUv7Qq9NxrMcfMk/Ica4LeMBuIhZpYQvovVvZUXvZ6eOvqAWsSm53cKErXQP96lO6qs+xZHLRnLyaZG9mtVs577lAefilPotc6Pu3BcD0hbBMrufkhuIO6EdqGU+c1MvdPa5+MPqvkPqQb2+ZS9Z++M/+PtWAl1hLgcqCIu6UDIjXJ3YedwksRa/MqePgtYgatXweikoqkPcYuqd3yKH1lJlQUHpk/rjQNsfIUCLL7XL6srG6w++FCwaMR8nBRra0LtWrD6jat/U8SUSn5GLsE9d+IrkFkFMM9Qg8sQHuyYPqke/2zVMsM0XYSYm5qvYOu/wnWJO6rCgo/lGx78JU1AJ13QjSdVE3rNR4RiV0NPXJr7eVfXXUdz3sVl/hj1voIojyUoXb/t/UcN/M1/DBovUziq6WaUwkrhzg5fJ4HWWhpFIzYF3px1MuGTZ/VKQQdBXDUZzcF0oE4REgi/iJPNQiVtGxB2/lZKtHmYpUWAhuC2FPZ2axnv1pYuy+KmhfOwoURrn9EJzVsmg6d5loDRYqfrBt8wTyWuxR4f3S59u+47QVD6VHp8pcd8LV0jRu3oNdwiKpqdEQNqaBh35lgH2IWw6ZUhS1V0ILt0IMHqkPcxNZJ4B7sbYUrkkHxw+G72zMmeYA5qK2DQ3kEk0kmN/1tSIJXKtGmTy60p2nZZOb+9moKzQiAniSoHa+OpsfHZoGnMhITPKy8V9dAoeNaB7/XytG
 6yg1Q4Xu
 +4bGV+81BQW1VPVzvrXbW9EtFYxb6szEEDB1NJxPVSKViOvGOG6Ac1o/GgvKCNbtC0zVFePMxlcAlGFNTjFRTqIvNXFalQRf2agG9kDuhJlDCd29JtJl6DfJLHlTIGlyBEosCG25DhaONfZUFFddL6iAYD+yz5vNIE9+79Vujgxk0yeyN5AZAjkmcBty03SoeK/XWjsg2QFKxAcJVUpNdmWG5kqA3Ya85dtMCSne41fOR8Kj7ZKPfg8Vi0AIKjzcHpC21nrGAUzjQwUTJ9LNdoA5/QLiiBpPfexWLjJlxsBmpuJuSY1jLKgJxE6FJjugKAf7FpyxgDWKZ+7c8yeUfV7OozQh2E3xAZsL3DC5zFpyE9whaQFqtxYcdlJPLupVkH2s+pf5dWUTu/Qr6rZ/RtsPLCyXM9afOB41YeRUalOv2DVYiEVDJq7A3uk3ybKzvCweZFGHKyuegz7YVV6aV8E7/3iNdDKZQAYN6zvjXVJ9h1q2zmUpLeh8r7Sy9T+vxL8AZ
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 20.07.25 04:23, Andrew Morton wrote:
> 
> I continue to retain the original patch in mm-hotfixes as part of
> akpm's lame bug-tracking system.  3 weeks in -next.
> 
> And I just added a cc:stable to it because December 2018.
> 
> I don't expect many real-world users will be putting fake delays in
> memory_failure(), but it's there.
> 
> So what do we do here?  Add a TODO, merge it under the
> better-than-it-was-before theory and move on?

I would feel better if we could just not fail memory offlining. Memory 
offlining is documented to loop forever if something bad happens, and 
user space can cancel it.

-- 
Cheers,

David / dhildenb



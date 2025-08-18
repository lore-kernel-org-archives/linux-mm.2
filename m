Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 37AFDCA0EE4
	for <linux-mm@archiver.kernel.org>; Mon, 18 Aug 2025 13:01:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CAD888E000D; Mon, 18 Aug 2025 09:01:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C5D658E000B; Mon, 18 Aug 2025 09:01:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AD7078E000D; Mon, 18 Aug 2025 09:01:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 9697D8E000B
	for <linux-mm@kvack.org>; Mon, 18 Aug 2025 09:01:51 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 39D40C0890
	for <linux-mm@kvack.org>; Mon, 18 Aug 2025 13:01:51 +0000 (UTC)
X-FDA: 83789890422.07.F1631B1
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf04.hostedemail.com (Postfix) with ESMTP id 7CCC74001B
	for <linux-mm@kvack.org>; Mon, 18 Aug 2025 13:01:48 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=jN9+xZgW;
	spf=pass (imf04.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755522108;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RThlmLPb+EykYg8ligo7HP1ysvF9xQvAuy2c5Z9pU1Q=;
	b=YSKeWh6xxBmkhe1PKcvOgB19NUof/Adg1ko8fTvJbDs37f6GLMtGUeolfXSWq95jo8bY1h
	SgIhpuqrapqwmn7OB06xL3tgkB63/KBuPk7kqWiBOL4a5WqkwR49JOKuXel3pQw3jZytPC
	lX+fAU432JXINyux8mIV5oRy/V2Je0Y=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=jN9+xZgW;
	spf=pass (imf04.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755522108; a=rsa-sha256;
	cv=none;
	b=tmpmyebjFC1jpVMplHIDy+VnDPAIIFZlf1AlGNc6yXhrG4WtnZ3polQBRc4OJvKuacz9Fm
	CZ3xwBDMDX6lZLMR2AMHf/zPDjJNvVPS1goEmc4aM0+6RIHaVp4Ly+8dkxFM+iT0DSuGN7
	08fVu9WbsjFQc4ew4toqYAuNnc0VzY4=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1755522107;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=RThlmLPb+EykYg8ligo7HP1ysvF9xQvAuy2c5Z9pU1Q=;
	b=jN9+xZgWESTqFH2xW3fAttPx2soHWcpgyVaHC6Hp7+cdw2jwtMXNpcEYwrm9NlLA5cHp4d
	VTmsdeRtkorWGtxtNWFY73uEJR2iJzvssMjSMs0JyRCfCOvV61Gkvpow9R4fCpWGlUIbDL
	MNnxzRoiO2QhRBRySilT2DT4z10kSJk=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-481-AKxZv_liOZSEBiBm7Aq3mw-1; Mon, 18 Aug 2025 09:01:46 -0400
X-MC-Unique: AKxZv_liOZSEBiBm7Aq3mw-1
X-Mimecast-MFC-AGG-ID: AKxZv_liOZSEBiBm7Aq3mw_1755522105
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-45a1b0511b3so18213515e9.1
        for <linux-mm@kvack.org>; Mon, 18 Aug 2025 06:01:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755522105; x=1756126905;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=RThlmLPb+EykYg8ligo7HP1ysvF9xQvAuy2c5Z9pU1Q=;
        b=nelSreP3KZR8yKDTkKrdakhvIBjqNHDUPhBIJh1K52HI5QjJqFb3/qAOS+r3Ou/Bjq
         gtNBCx3ET8x7qEUgw+OVR8rHiHYXYpHETww5gHduFL7qUNsQtskEDYj5hIPhtjN4RCA1
         O14dOqOiaukvsT8KMyrAUvXDw2zDUqQ3UJHozxeqhtjEfWCJz00VDP6rxLFkQGdfUH42
         WhxS8kRZ9qulr2q9xLJ3RI+ZkbQKCxUn3NqVk4/WTqDR+iwLmB2U09BbgIEschRh0450
         nnDprJs5jDj61pDSdt4LBdtoFmdH+kTzhP4jXpZm2qZPUz4ynNTbkEZYFD7GV6msIfgU
         lSAA==
X-Forwarded-Encrypted: i=1; AJvYcCV7GDm5oX4PalPa/dwuB02nvMs1dnwpQjJny364VusowjjA/kcTSjXcW2OhzGiuXsXNW9QOvF927A==@kvack.org
X-Gm-Message-State: AOJu0Yykm2GotIYs81zy40uLquMzqK4Nh7GkrBpnFrzvKMa44/PA/GWq
	9XEic8gxTMHSWsVlu/wJ9txaHAANHT+uhvQqb9n9g8S5xhR9DROgncurAb3JDTBrtzK2WiyWEUG
	GFCArJSe3j177QOR2IrlZixFj75yeOhmh6YxoSXgMvt84OaIQAi1E
X-Gm-Gg: ASbGncuNDsdPAM1oO6uuZc9/w0q9vSqVtFlIltmdPhCYYILvfcBm0iK3HlHOw+1gBKA
	MltkHFjA4YrrL0kSr6AWD0KU7V8nMqguBe/gdScgg23SwblTtU+zLTs8QwtsXsdS7HFsdXjBdPY
	/ZGDRZQGmv3tV3DiApScm3f0jm3uToCUhcCIHjMI/YQownQ0ERiwAJLViyqFvhLRSHMWL0VILL/
	S8vD3tYHhSvmClJJpIV8rMZvKs7aUuq25oeeMgJ0yPTPYNp45iU93D6dzG9l2mqfUJV/lKAFcDQ
	/5dKHddfNjl3b3fa8Y5SdP73qJ/zLH3nkq0CaY+rzbtkEyazrT1rluJdAYDiDnXclU0cwQbepep
	3sMCIsNLLUSUy0hxIzfNku8mF9k1zPIeVt64OzSAJXoKq9XPjngjOsjHuyACJp0q/
X-Received: by 2002:a05:600c:350e:b0:458:c059:7db1 with SMTP id 5b1f17b1804b1-45a2679e090mr80917195e9.30.1755522105076;
        Mon, 18 Aug 2025 06:01:45 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHXqLEQpuF/rQnrNlUPYRGzvZNoDdGpC9BmyZtZ0WGAHqRAhiq036JxW235aHv3Ksodxe/Znw==
X-Received: by 2002:a05:600c:350e:b0:458:c059:7db1 with SMTP id 5b1f17b1804b1-45a2679e090mr80916565e9.30.1755522104489;
        Mon, 18 Aug 2025 06:01:44 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f22:600:53c7:df43:7dc3:ae39? (p200300d82f22060053c7df437dc3ae39.dip0.t-ipconnect.de. [2003:d8:2f22:600:53c7:df43:7dc3:ae39])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45a2232fea4sm135100235e9.28.2025.08.18.06.01.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 18 Aug 2025 06:01:44 -0700 (PDT)
Message-ID: <f07b06de-77e4-4d50-9d97-18590faf0b10@redhat.com>
Date: Mon, 18 Aug 2025 15:01:42 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [syzbot] [mm?] WARNING in move_page_tables
To: syzbot <syzbot+4d9a13f0797c46a29e42@syzkaller.appspotmail.com>,
 akpm@linux-foundation.org, harry.yoo@oracle.com, jannh@google.com,
 liam.howlett@oracle.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 lorenzo.stoakes@oracle.com, miko.lenczewski@arm.com, peterx@redhat.com,
 pfalcato@suse.de, ryan.roberts@arm.com, syzkaller-bugs@googlegroups.com,
 vbabka@suse.cz
References: <68a322e3.050a0220.e29e5.00a7.GAE@google.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <68a322e3.050a0220.e29e5.00a7.GAE@google.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: _T48YmBrN-juWGnr7GfH1cna3XJsAT8FO5xorFJP15U_1755522105
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 4z6fwhfsdz8d86wfdkyp4hj5o5hm345p
X-Rspam-User: 
X-Rspamd-Queue-Id: 7CCC74001B
X-Rspamd-Server: rspam05
X-HE-Tag: 1755522108-473611
X-HE-Meta: U2FsdGVkX195PChr6C6PnH68h2nSKwdkddUJ7dgl+FCvYebWbMH+dg5+AqvKLnDPLJ37Zo6d2tEgoUdXBy8AQ7dEsPLDtXMBqkaTGPRjRcUMUwJS/a+l4gT8ipi12ufBCSM15jhntV8ZbYqaDCRUz8rC4D5XsDOi4OX0ueog1v+WKBH9JUL6SYQ8x0YcH+yDGiolUQlFULnP2Fh8kf5YaeYnJVFsVs8ZOzdQq6sEEAZG3/MGhsFnF+pQCDRHohvFobNQmNPckjr5nG0+MqsxSVwK4sxj+QoXHkYDNhM1s2TEqJpxTXxjsa5Ba3Nj9nUX0IIwzwV1Fjc5N9A1Jj0heP1CVG5yrqlCbebDgs5czkk5Ld+UdCqnaoSdhGW3/RAeJsUAVxnb70Vj/XJIIgGYTwcEEYvNbC2dExR1cL10IQC1NxdY0hKTzwEkBJ5ttHf2pST20QmDsxEfRcZbeIdwXTURulHo9bqJ716n2JsMmz/5c3fktkAElr520n9b1ezHKDVLhN0apS8Bq4DBW4CFwo8xY2Rb/OdyLSVorcAfg3GB3FE5Lts31IaCmLWJxhEmm+dO2HtFQ61ek3BaIlVuwMTvt4M+qISKNuPbD2dgr4t/dE/59l/RDrQCam4uYBg7Iws/SPrJC5YsMpLmHt+4XHNxg2Zk811SOBO1vYoej+mqBo4gsF738WhduS5hOqXLQ3Oja3C3ZrxH4AsSTHi8f7231gpi85Kxqw9hLu2OskgLHEHXtUjDcxg0yz2NF1B3ULg/CN7hGMiqan6v3gGtOj5de5hqaDojSEzkhIa2DZG3mZxUaOPbO9fq71a7+BjgEADnJvzo8BNbLlm/bqzV85uAfHu0y3kofRbDBmwD9VmWEDEYzQoa6Iibo3WOHGi+bDkqQdACwhCE9B94mwQmGP8s6yweKoOaX4M4Kj3xA5xaCkYkBYnWTqJJhYQOvNVaGJI+rjQF5zdGDGbCi71
 UcG+D+Kn
 xftClmH71vxTTxAIAu8caWOaQFU8/kCaKWhittzLJbIG4Hm7FHzIk8vE0u9wKTUNM0deRkvKJn2P8zBmPQhBnmmcD5fySD0TeM5VRaFm3GIa1Ng0+2sxaR0/N00CD2BAAsIsV3X/h62LQJrg4aQGY8JT/KGk0l9Zve/xF6jm8H/Dqxz9cB6pFChU4OurkqWcg6c8M2Y+h7ATv04kl5ITdDn2uSHBXX4wHFlJmgOu1Sy+U57x49Th2BEo8erTqVcHgeCfg8Eys35r6QcE7YYrZpQeJZ8c5ED+2UHRH0xH9SOnaKJGlqhqwEPZUiKUZ6v8RxRbx5LBArIV1DCD7FcxR5doi/5A3M4LWp6CHqkO3Ww4K5XsjgkjJ6owzMYzeLmQpiP2FQA90mLwGoEnMB85RKZxSiGsHNhmYbdAcukKalRyzt+OzDHUwYPPBeyk2gFKe7U7LLaPvLQhOPIQaGtveYxi0Nsur5vMwwDrwyYKE3fKV415fM2AmkAZNjoGQy9o/evperCC1hl+unadm97Eyy8O0EHXeSfCy73xg6yqjBv1GKBl4ONiaTaJgxhHR7hwnq2AhNQn5WZzSpDlhjp7YQfgXOcP55gCkCXUD44KCjgnzHjE6ZUj+4NJOTYnN5+G6JlNKJ1hYRagwJpwGwnA8k7luKDiINbRsUKr2
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 18.08.25 14:56, syzbot wrote:
> Hello,
> 
> syzbot tried to test the proposed patch but the build/boot failed:
> 
> failed to apply patch:
> checking file mm/mremap.c
> Hunk #1 FAILED at 323.
> 1 out of 5 hunks FAILED
> 

#syz test https://github.com/davidhildenbrand/linux.git uffd-wp

-- 
Cheers

David / dhildenb



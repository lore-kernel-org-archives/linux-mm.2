Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5DB89C87FC5
	for <linux-mm@archiver.kernel.org>; Thu, 24 Jul 2025 21:32:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DB7408E00BC; Thu, 24 Jul 2025 17:32:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D8E9C8E007C; Thu, 24 Jul 2025 17:32:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C7DC18E00BC; Thu, 24 Jul 2025 17:32:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B406C8E007C
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 17:32:37 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 5C5838052A
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 21:32:37 +0000 (UTC)
X-FDA: 83700457554.02.0DBF51F
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf17.hostedemail.com (Postfix) with ESMTP id D34474000C
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 21:32:34 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=SQcUy6ux;
	spf=pass (imf17.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753392755;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=azr2brsZ6Ua8mVeqP54+Ze96cYo9iUAaUmwXzQQMwtE=;
	b=FtvCWt0lu0X8u+BPp2bgCWyTeCPwKOqBJzOa7oHOeb3yodfCtxgDc+u6LU+DCJOOi8rynH
	2T1ZIHg7jYXFXJhk5b4/+37d6A8yj3XAkIDwgSisr9zBFtPT4mPkWufOXVsPuY8LFc0iLI
	DnAlprRygZmQ8RVqUIuT7ZfNY4kc6Zc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753392755; a=rsa-sha256;
	cv=none;
	b=QdH1qyWwW3AHf2+zDZpSw7rEw+Y9M13511uiToNnIRcC7NtFmmTgL6XBBxQ3PITRelydw/
	gvqaOZnGExGbHvfX1FQsrTQooswuc9aifq6yqhnYa+qY8FTk8uZ70nSKPa/Vs1IdrlTxsM
	AcMuOaaM2vT6PUIcTZnGuj0m585U9kM=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=SQcUy6ux;
	spf=pass (imf17.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1753392754;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=azr2brsZ6Ua8mVeqP54+Ze96cYo9iUAaUmwXzQQMwtE=;
	b=SQcUy6uxLin3kYmEdEefT72XhVJCYwGsjYpdYzHOW1358NQhq3cI4ysq93b8NzYO4Dhz6C
	As/8B4ULfuhQeMc91sga/FGJnbHn0D1xrdQavHrcMjbFPBQbvIARCFLgrtMMTr3O79qGzl
	2rbjdkr5hRse+3UU/3atArdYcuWplOA=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-615-NL_xtD3tMJi_2J6bK1sonQ-1; Thu, 24 Jul 2025 17:32:32 -0400
X-MC-Unique: NL_xtD3tMJi_2J6bK1sonQ-1
X-Mimecast-MFC-AGG-ID: NL_xtD3tMJi_2J6bK1sonQ_1753392751
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-3b7737aed7bso339577f8f.3
        for <linux-mm@kvack.org>; Thu, 24 Jul 2025 14:32:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753392751; x=1753997551;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=azr2brsZ6Ua8mVeqP54+Ze96cYo9iUAaUmwXzQQMwtE=;
        b=KB7uIK/zjzTtoNfBEGux5CexIytcUXR1VcAPzAl5sL1I+c9OU6vBXt0oRxuSxa+eB3
         zscNYGjyfjELqklwueImIvOkjbcDXkdhh+Jaiu4aMGIDki6QZh9VX7sFJ3ItHrf51RhI
         rdftacwy36OmeIWgXnl1wdIfg3cXojluTPMqefFvU0x+Ky5iJgHmycWU6xsYzZRQJzpA
         0aCmV+B8pWbjWep2ZgM7GomEncCV50JMgrDIhOwa02Xj2xwFO7HCfFwdAV0ADBlt6J30
         qQ+h+ZavyVlF7B2Gu2BPtlA9oQYsHbjithBRkd4ox7YGfbrnGTKY8BEm1397lccD0wAo
         gP+w==
X-Forwarded-Encrypted: i=1; AJvYcCWPj8/16qb7prGOcT45IqDOIqQ7u9w7gx7PBnd2GRbLVgAc34LR2bdoCY4FpkzhoRc1mswn6mIMFg==@kvack.org
X-Gm-Message-State: AOJu0YxFvLdP8EdD6sXIOrJt39qsJCRoQbE4s3MJQoJGSmFurATN3lpe
	FVVcQGh1FGaF2MXdd/9HR7H5XhDUXsfpp6dUS0Ha/y/ZrsRG0kKeyNR5KUykuXY+H062erI+e4M
	0WEzZuqCrugM7ZJvtSli9FNjv2qvzRF3D+ZlkSnRh+cmpcoFLXMYm
X-Gm-Gg: ASbGncsbBo8HMaeThD6WV+FzWBV/s3qmvHxL1ltEejq4UsAZfC/odsE2Qo+6atIUgSu
	qS5INS+YJ4fKmufj7ijAK93MKUxNmd7TH93ZyIYyDjaESaPTp40mKafZfPtlGNUY097YVGvzWWW
	z6zXRtkWncuLx4UVMkr7Ttq+UCrumYDESjtcOVk90RhzbElcI1dXHzmhYZJ7sjIN0clV8G7k4IX
	mF++6VAYw78BsgC9KNrNml4oAd38WT0nE4zRaMhLj43Qc8cAIbr7iMF8b2SNwYbMq2rpReroqzY
	S5olrMo1WIgpOouMQG1zfBOoexw7EdljQz4MsW+skuC1lh/8xFZo1qtgtFv5LQtzWf97kaY=
X-Received: by 2002:a05:6000:1a85:b0:3a3:4baa:3f3d with SMTP id ffacd0b85a97d-3b768c9c13dmr6966260f8f.6.1753392751359;
        Thu, 24 Jul 2025 14:32:31 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEBbZa9GDR0ki0Hy0VjprS/a9IUEWZpzBMehLKY4L1dDoNNRYdZKztKjdVKH6ITX6Do3wdiKg==
X-Received: by 2002:a05:6000:1a85:b0:3a3:4baa:3f3d with SMTP id ffacd0b85a97d-3b768c9c13dmr6966239f8f.6.1753392750862;
        Thu, 24 Jul 2025 14:32:30 -0700 (PDT)
Received: from [192.168.3.141] (p57a1acc3.dip0.t-ipconnect.de. [87.161.172.195])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3b76fcad2b4sm3213491f8f.47.2025.07.24.14.32.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 24 Jul 2025 14:32:30 -0700 (PDT)
Message-ID: <e0a22433-541c-40b0-92bb-34b0596db642@redhat.com>
Date: Thu, 24 Jul 2025 23:32:29 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 2/5] mm/mseal: update madvise() logic
To: Kees Cook <kees@kernel.org>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 "Liam R . Howlett" <Liam.Howlett@oracle.com>,
 Vlastimil Babka <vbabka@suse.cz>, Jann Horn <jannh@google.com>,
 Pedro Falcato <pfalcato@suse.de>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Jeff Xu <jeffxu@chromium.org>
References: <cover.1752687069.git.lorenzo.stoakes@oracle.com>
 <ec480dc1fd4ce04bb11c0acac6c6da78dc6f4156.1752687069.git.lorenzo.stoakes@oracle.com>
 <202507241352.22634450C9@keescook>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 g3eXuA==
Organization: Red Hat
In-Reply-To: <202507241352.22634450C9@keescook>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: fMbLiM28aKZ0Fq71gm5dS_8FmAbxhS35rQfuOyN131w_1753392751
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: D34474000C
X-Stat-Signature: eotjwzphzz4fa17oksua8h19o7seqrjh
X-Rspam-User: 
X-HE-Tag: 1753392754-392381
X-HE-Meta: U2FsdGVkX18GF/NOjdGU2nror4MQm+esXjBv6SUgcknLr5ABSu4Bisi8RRaQgbxAoskvDrgtjO1fH/uDLPmnKiRz5zlcR0eNYx5HV9AKVn63DA/SDURQ6KBZSCvNLyQ588WOzw9GpNpGiCgzkBO2NW1OLFtcMMz4m/6+6NuLDQcvTukmqT4GM/cj/DVkdqtJrcgyDTjZuUikUNVJW454AZI0pWqOUX+WVcv/fm1S4tkqDXRNqmrO5baUA43YdDKf02j1PV0XWe+7gr4WFg/e5T2Qy+Qtp8uxNh90zLw4hlh6WiJly/v7N61IwnBiIa36xHkmzLQvqaioQS3PoBZrGtVmSy9qPHbEWqQVHjocsvF+aiUbfhHk4XU9X3liwP/kJnhAALUee3IVOZ/WoyhW+CdlviRoGYlpTE7SEj1cNz6GYUHqQ4jz3bl2q4dZc6wFTfxC6cw1dr3YmaffTrvnvDc6o+WuY3bERX0EAZp9oNj7+ARL7prCOqoHOiiuN5WaTN973H0gCNgVBVR+UM+y/TGuo2AW6JouvQ6kguEIJAxABM4sb+jlKZqzP/r8f3fbVVUk6bok7GuLuZ6Foc2GUV5uWUl3hZ7OaT7l8rBo+eIi1mEet3n96l4gRt53eU+XwETlJ1WLL0sN9mH2cehkL/YEeYDaSdYkR0Z59m6yf4QLCQA6Bi8IOFpPR50M7y8jfqww6qZ4MumQGJUTsxAxMdaVzgjpmnwS6FHCcGOB9NaelZkG72yGEytonf372VUYc9/mc3zDBoGiJsRaBU2hpUz2NCZYR7SLwgd2xao+zTDAN/h0oYT7v2ZMAFoQeZlWyMQ5KeAjy4q7wByVG7yebFlSoDAbZ+QiT9S1PjNwapRafcA+EDAOpdhyzshIHiKwsADyrU9bkfgo/jFBr2T8JTETGJlPKqZoaF2ZkOXZE4KCGLp2GnkhJImUJs3wMVAB9XCqPz5C2clF4hUbIIW
 G9kf+Pao
 3oYFXtGzFeqRO9fxbynBj0r6/aKdJuFtPslTTYsJAVgMiptDrSbdvbS+uy29OAh9/AAT9Yh9If96N43VE9i10s9AQ5TUv08cYEQCZg69/CZpMgFBjyywBQgAK9ge+ZZsFLf+SNwrvQDax/OSoDmHK0HXkCnURWZb/zPGRHrBigv06hqkSyRy4P3O+BTUNp2uQL5AWqHLXjrY5c7wVNZ6hvgbI9JzcwytUPOf3gCpl5vcZEl89/igc1FMNuCkRNmpS+2BNbiQUt2N1ZvEY9ZSNC9BTqIvDy56sAVsju+4VjRQr7nzrYVC29X2+B6oaWQ8ggJ2p7tLiTt2AtU89h/SXiQRBPM/QzGQ3CEZoBCE4p73x8zVP5UVUFemLOOZN+vtRRLfusQNdUAgEI4Mb4S4BDxY4Np8udAhohqaQoIDtWbsVwFo=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> As an aside, why should discard work in this case even without step 4?
> Wouldn't setting "read-only" imply you don't want the memory to change
> out from under you? I guess I'm not clear on the semantics: how do memory
> protection bits map to madvise actions like this?

They generally don't affect MADV_DONTNEED behavior. The only documented 
(man page) reason for EPERM in the man page is related to MADV_HWPOISON.

-- 
Cheers,

David / dhildenb



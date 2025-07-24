Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F36C6C83F1A
	for <linux-mm@archiver.kernel.org>; Thu, 24 Jul 2025 09:12:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 968BD6B0206; Thu, 24 Jul 2025 05:12:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8EB9A6B0208; Thu, 24 Jul 2025 05:12:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 78C626B0209; Thu, 24 Jul 2025 05:12:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 6342E6B0206
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 05:12:20 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 381D110C8F0
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 09:12:20 +0000 (UTC)
X-FDA: 83698592040.16.576ED35
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf03.hostedemail.com (Postfix) with ESMTP id D44DE2000D
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 09:12:17 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=UD57vQWt;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf03.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753348338; a=rsa-sha256;
	cv=none;
	b=4KScn9WTZ3B4oPYouNIp2kU3J5VojE8HJE/8NmotRHz/6HWcW4RdUPd1EtvjD479hRtqMF
	iRJyeQ6FuxNEX33gg7Qpxi+VCAo7heRJP2HU4cW9KM4omU/9ovCsByTMXR5DZRU46+CauA
	BMRIIUHVOwn88h8kvPSGbk6Vg6JQRAM=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=UD57vQWt;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf03.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753348338;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=REaQ47lap51WUskAbR5wjPuC4B6wGSnAM//4iqdNK2w=;
	b=wys7aWJxu91M1lufxFIbTqrmPoKU3h5uHrA2vdParwtDD0X7HIHQ++dvecxj/NZBAVcEG2
	4pBun7ydKFPfi/5Iv3YfxMUZLC68PwopGm3xQQaehPcAHO0iCxvDmALh5rFcGJFTOGLarv
	PWkn8J9Ow1O97KhA6tjgplKwfRbgyAs=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1753348337;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=REaQ47lap51WUskAbR5wjPuC4B6wGSnAM//4iqdNK2w=;
	b=UD57vQWt768v9jYd3HlR8NlDM7588U8wiUngARCV/NhqVD8KO8B2mR9DT8UCdqobMsTIIy
	Q+ka3Ib2Uf2BLgcSzEvd1fzR2Uv6zW459PxdpwXMEs8c2+YrOx6ZLDK/ugWyP2PZLasdem
	VlxAxfJK4k8x7ALK11rsrYdH5Y5wi4A=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-656-A2kY7DOsPWGlIIdR-ith2A-1; Thu, 24 Jul 2025 05:12:15 -0400
X-MC-Unique: A2kY7DOsPWGlIIdR-ith2A-1
X-Mimecast-MFC-AGG-ID: A2kY7DOsPWGlIIdR-ith2A_1753348334
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-4560a30a793so2721855e9.3
        for <linux-mm@kvack.org>; Thu, 24 Jul 2025 02:12:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753348334; x=1753953134;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:to:subject:user-agent:mime-version
         :date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=REaQ47lap51WUskAbR5wjPuC4B6wGSnAM//4iqdNK2w=;
        b=ozSKalR1PdI2rhZqR3Xp6G5fOFfV8nXOnkgUYpGP7MnLcXAUzfzy0mvVCKC78M18U2
         Bi6hhvckbgisdTU88UtoC5zFBwn94ARWbcA988+dhM/ZhWG2rseg6kl203XniP1IYYLK
         JttTOChOPnK4Pje2pmqLDD6WBiM/2VwBlpM5D29T6KtnLQ20FucCjRsSg+uCYq+kS9rv
         0eFoyNzifvxZxUDL0LR3S7BVBC8jlFEMeIfDhANzZkd+tZHMAPXXPudxVLdvAXtyk+xn
         QspP7GeOHAXMNX06Jl2CE/yXqZYDw5D6T07pFsxkouDfF8v/yq39muFDg+maBHhPCQuc
         MOEA==
X-Forwarded-Encrypted: i=1; AJvYcCWL2O/xAR/O0ji58HmoIVDE7AHsBwM9jBiUrU7ztdbMONItPKONnF9jkBCs3dWLwI5G48PaHTUJ7A==@kvack.org
X-Gm-Message-State: AOJu0YxJXfZzYmeU1xZSOgno82d8iWu8rK+36bl1SnzGoH7cDEwjPFWF
	QaOSEVsKC/0QU70Gli3oywiEuswoUYO4lBjxQpOE5l0/ynCB10ODUHzzNK6k4LQdtL9oDWClhW/
	MojrRtP3li+suMCUU3tn/bdWIZWrbOU9RfAbDg2gnTn9lGEciMKqA
X-Gm-Gg: ASbGncu1LDAGIyH2KHInmsw2Q9feC32csSCyyTsWOVC+hc0pOVGhTOa5VhZd2gqd76N
	gj6E5vMrQTVY37EShvCtMD5E5AR/YMOyWggu6A4WeID+E0AOYCAgG2GqKxcwFTha7hxGvq1pDmO
	hUadffMMBtPPNiayeq//2IRMPFPWYG/BMCZYVDSemUj3efP78IV3YPtb814dEUz+quKGZTfv0YH
	A2/56oXQzDl7JwMncIx5X3o0oMZZkq5HvWzzlB/47uYUXDeeT7fLE+K1FdvASym+xXNeS6a5MzS
	xQfUXMeYI+1oj4jBQaLuOmGnmuejwXy5FufMbo/CGUpk/9HkCQIYcze5j/z/ElSJ+QocD37NeJT
	z27ueZPVByvrvDwqhz2Jr0FgEAiIvOpwk0tO9myqiDkw9lNpfTXgCBHSWEqv4Hruv
X-Received: by 2002:a05:600c:8208:b0:456:1a87:a6cb with SMTP id 5b1f17b1804b1-45868cff3b7mr56742425e9.19.1753348334273;
        Thu, 24 Jul 2025 02:12:14 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGDzOX6Mhws9A1Omx3HvWOpCb6kzhDOZIa496xO5yTunIpBln3/qRd12dwGwSfKf4IXi3aG7A==
X-Received: by 2002:a05:600c:8208:b0:456:1a87:a6cb with SMTP id 5b1f17b1804b1-45868cff3b7mr56741905e9.19.1753348333789;
        Thu, 24 Jul 2025 02:12:13 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f1f:5e00:c941:d6fb:3e30:b42? (p200300d82f1f5e00c941d6fb3e300b42.dip0.t-ipconnect.de. [2003:d8:2f1f:5e00:c941:d6fb:3e30:b42])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3b76fcb84e6sm1506388f8f.61.2025.07.24.02.12.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 24 Jul 2025 02:12:13 -0700 (PDT)
Message-ID: <e9bb93a6-1e95-40e5-ad10-a60d80735432@redhat.com>
Date: Thu, 24 Jul 2025 11:12:11 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 0/9] introduce PGTY_mgt_entry page_type
To: Huan Yang <link@vivo.com>, Andrew Morton <akpm@linux-foundation.org>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Rik van Riel
 <riel@surriel.com>, "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Vlastimil Babka <vbabka@suse.cz>, Harry Yoo <harry.yoo@oracle.com>,
 Xu Xin <xu.xin16@zte.com.cn>, Chengming Zhou <chengming.zhou@linux.dev>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Zi Yan <ziy@nvidia.com>,
 Matthew Brost <matthew.brost@intel.com>,
 Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>,
 Byungchul Park <byungchul@sk.com>, Gregory Price <gourry@gourry.net>,
 Ying Huang <ying.huang@linux.alibaba.com>,
 Alistair Popple <apopple@nvidia.com>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>,
 Christian Brauner <brauner@kernel.org>, Usama Arif <usamaarif642@gmail.com>,
 Yu Zhao <yuzhao@google.com>, Baolin Wang <baolin.wang@linux.alibaba.com>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20250724084441.380404-1-link@vivo.com>
 <86516155-f2d9-4e8d-9d27-bdcb59e2d129@redhat.com>
 <cc560d48-884d-4c8f-9fb0-565d74ad769a@vivo.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 xsFNBFXLn5EBEAC+zYvAFJxCBY9Tr1xZgcESmxVNI/0ffzE/ZQOiHJl6mGkmA1R7/uUpiCjJ
 dBrn+lhhOYjjNefFQou6478faXE6o2AhmebqT4KiQoUQFV4R7y1KMEKoSyy8hQaK1umALTdL
 QZLQMzNE74ap+GDK0wnacPQFpcG1AE9RMq3aeErY5tujekBS32jfC/7AnH7I0v1v1TbbK3Gp
 XNeiN4QroO+5qaSr0ID2sz5jtBLRb15RMre27E1ImpaIv2Jw8NJgW0k/D1RyKCwaTsgRdwuK
 Kx/Y91XuSBdz0uOyU/S8kM1+ag0wvsGlpBVxRR/xw/E8M7TEwuCZQArqqTCmkG6HGcXFT0V9
 PXFNNgV5jXMQRwU0O/ztJIQqsE5LsUomE//bLwzj9IVsaQpKDqW6TAPjcdBDPLHvriq7kGjt
 WhVhdl0qEYB8lkBEU7V2Yb+SYhmhpDrti9Fq1EsmhiHSkxJcGREoMK/63r9WLZYI3+4W2rAc
 UucZa4OT27U5ZISjNg3Ev0rxU5UH2/pT4wJCfxwocmqaRr6UYmrtZmND89X0KigoFD/XSeVv
 jwBRNjPAubK9/k5NoRrYqztM9W6sJqrH8+UWZ1Idd/DdmogJh0gNC0+N42Za9yBRURfIdKSb
 B3JfpUqcWwE7vUaYrHG1nw54pLUoPG6sAA7Mehl3nd4pZUALHwARAQABzSREYXZpZCBIaWxk
 ZW5icmFuZCA8ZGF2aWRAcmVkaGF0LmNvbT7CwZgEEwEIAEICGwMGCwkIBwMCBhUIAgkKCwQW
 AgMBAh4BAheAAhkBFiEEG9nKrXNcTDpGDfzKTd4Q9wD/g1oFAmgsLPQFCRvGjuMACgkQTd4Q
 9wD/g1o0bxAAqYC7gTyGj5rZwvy1VesF6YoQncH0yI79lvXUYOX+Nngko4v4dTlOQvrd/vhb
 02e9FtpA1CxgwdgIPFKIuXvdSyXAp0xXuIuRPQYbgNriQFkaBlHe9mSf8O09J3SCVa/5ezKM
 OLW/OONSV/Fr2VI1wxAYj3/Rb+U6rpzqIQ3Uh/5Rjmla6pTl7Z9/o1zKlVOX1SxVGSrlXhqt
 kwdbjdj/csSzoAbUF/duDuhyEl11/xStm/lBMzVuf3ZhV5SSgLAflLBo4l6mR5RolpPv5wad
 GpYS/hm7HsmEA0PBAPNb5DvZQ7vNaX23FlgylSXyv72UVsObHsu6pT4sfoxvJ5nJxvzGi69U
 s1uryvlAfS6E+D5ULrV35taTwSpcBAh0/RqRbV0mTc57vvAoXofBDcs3Z30IReFS34QSpjvl
 Hxbe7itHGuuhEVM1qmq2U72ezOQ7MzADbwCtn+yGeISQqeFn9QMAZVAkXsc9Wp0SW/WQKb76
 FkSRalBZcc2vXM0VqhFVzTb6iNqYXqVKyuPKwhBunhTt6XnIfhpRgqveCPNIasSX05VQR6/a
 OBHZX3seTikp7A1z9iZIsdtJxB88dGkpeMj6qJ5RLzUsPUVPodEcz1B5aTEbYK6428H8MeLq
 NFPwmknOlDzQNC6RND8Ez7YEhzqvw7263MojcmmPcLelYbfOwU0EVcufkQEQAOfX3n0g0fZz
 Bgm/S2zF/kxQKCEKP8ID+Vz8sy2GpDvveBq4H2Y34XWsT1zLJdvqPI4af4ZSMxuerWjXbVWb
 T6d4odQIG0fKx4F8NccDqbgHeZRNajXeeJ3R7gAzvWvQNLz4piHrO/B4tf8svmRBL0ZB5P5A
 2uhdwLU3NZuK22zpNn4is87BPWF8HhY0L5fafgDMOqnf4guJVJPYNPhUFzXUbPqOKOkL8ojk
 CXxkOFHAbjstSK5Ca3fKquY3rdX3DNo+EL7FvAiw1mUtS+5GeYE+RMnDCsVFm/C7kY8c2d0G
 NWkB9pJM5+mnIoFNxy7YBcldYATVeOHoY4LyaUWNnAvFYWp08dHWfZo9WCiJMuTfgtH9tc75
 7QanMVdPt6fDK8UUXIBLQ2TWr/sQKE9xtFuEmoQGlE1l6bGaDnnMLcYu+Asp3kDT0w4zYGsx
 5r6XQVRH4+5N6eHZiaeYtFOujp5n+pjBaQK7wUUjDilPQ5QMzIuCL4YjVoylWiBNknvQWBXS
 lQCWmavOT9sttGQXdPCC5ynI+1ymZC1ORZKANLnRAb0NH/UCzcsstw2TAkFnMEbo9Zu9w7Kv
 AxBQXWeXhJI9XQssfrf4Gusdqx8nPEpfOqCtbbwJMATbHyqLt7/oz/5deGuwxgb65pWIzufa
 N7eop7uh+6bezi+rugUI+w6DABEBAAHCwXwEGAEIACYCGwwWIQQb2cqtc1xMOkYN/MpN3hD3
 AP+DWgUCaCwtJQUJG8aPFAAKCRBN3hD3AP+DWlDnD/4k2TW+HyOOOePVm23F5HOhNNd7nNv3
 Vq2cLcW1DteHUdxMO0X+zqrKDHI5hgnE/E2QH9jyV8mB8l/ndElobciaJcbl1cM43vVzPIWn
 01vW62oxUNtEvzLLxGLPTrnMxWdZgxr7ACCWKUnMGE2E8eca0cT2pnIJoQRz242xqe/nYxBB
 /BAK+dsxHIfcQzl88G83oaO7vb7s/cWMYRKOg+WIgp0MJ8DO2IU5JmUtyJB+V3YzzM4cMic3
 bNn8nHjTWw/9+QQ5vg3TXHZ5XMu9mtfw2La3bHJ6AybL0DvEkdGxk6YHqJVEukciLMWDWqQQ
 RtbBhqcprgUxipNvdn9KwNpGciM+hNtM9kf9gt0fjv79l/FiSw6KbCPX9b636GzgNy0Ev2UV
 m00EtcpRXXMlEpbP4V947ufWVK2Mz7RFUfU4+ETDd1scMQDHzrXItryHLZWhopPI4Z+ps0rB
 CQHfSpl+wG4XbJJu1D8/Ww3FsO42TMFrNr2/cmqwuUZ0a0uxrpkNYrsGjkEu7a+9MheyTzcm
 vyU2knz5/stkTN2LKz5REqOe24oRnypjpAfaoxRYXs+F8wml519InWlwCra49IUSxD1hXPxO
 WBe5lqcozu9LpNDH/brVSzHCSb7vjNGvvSVESDuoiHK8gNlf0v+epy5WYd7CGAgODPvDShGN
 g3eXuA==
Organization: Red Hat
In-Reply-To: <cc560d48-884d-4c8f-9fb0-565d74ad769a@vivo.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: i2AYdW-sGR-zjIRPJPX8qCs3hUjNychGEcQtWAts-Ck_1753348334
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Stat-Signature: zfis7psigw4pxpfj4zs6ciaz1648wfop
X-Rspam-User: 
X-Rspamd-Queue-Id: D44DE2000D
X-Rspamd-Server: rspam02
X-HE-Tag: 1753348337-293147
X-HE-Meta: U2FsdGVkX19m8LCmZplKAudNIPeUM+5gDVupSL2OKGXklptv9cG2NYesWOzCsOIPSMUtrcpPm1GYJU5HNm/YJznLUxwGzKgie6GM8c6BtCrLlFOjnb+xTjQAVbfoYrg255wkgEet3IOmOpr+aEyndaSwn+DbV9CH+pyw3xq1voUJXMD23/Uh6fBATjGR+nZJ4gYGsa9FMluZ6gTxrrWQSphkFRLlbIQfrCU8PYXsD2PFdcHrhrowz8B6IisXv+uKAYH/0KIjcSaB8Pc7Xglf/ZprLniXfu5yf87VOl3HGArNW/Xo019yWx7q9yIzzXjdTs7qg9WEycPSvLCFwx/iIW241IaEoBebcBtEswQbBrJgKUaY6T6sjy2332AM+XoFIOyp1RXsBkbzLixp4AhkWdNOddE4sFXAWWx9u4ElNQmjqpFIqpzXBcSq7c/xV+/8aVK6T5/TgxKu4tdsIYP5lCvOPSL17FSadIJsqB+P/u338FMObLUt76a08MGd2dj4oUhy27pTFEny0wXV/oMSQzkPzZtn8j8xvQUPwaUOR0H8z+eWbvOqxnx3Xe156xEhjyXTyNc1Mnd72OAp4Z0ueNjfi80b3Wz3ZGH4fUBU+V2dF1fItFWteU4OTwA+KlBiTVq1l0HdKdvrRWKR5v9vHZ0bVFMXaRCaNz466zA2mMkBByPgqb+3NcswRVV3HS4htNrPR7PK7P+QXfDhwbyzn03vf6+4h3ZQWM0lZQTfnJF6MfapL73egmKUGOpuXgtpu2Rch5opTOTlDvWzGPKm6eWpqQyrcJsUI86T2eikWsJypcKEZnbkh3bJL5rhH8gxdEtEN3aI+YmCrheudaIlceVIfAh5xEa759UIN2BU6rlXfgs0VVPB5ATq+vcEuh/9fZSe5WqJW7D54ZWmP/hFXyQgPJvVdLsfFnM9WZV1y24YYVU7JdhWABw1Hu2bKVzQhusF+IdedfzJWFgBa0F
 BTvXRBxo
 8nl9UUv9qhywgjN5D7rCTyWlj6OdXqQ/V0IDyPwMaV2l6WRFDHb1Ye8LLYeYvwBKEBYlxPvNF12DxTk7mwBbLcgv1LTrUJInlXYVDjj4x5WsOYHaKBX+qMVK7GoFYKn7Pgmd8dSIqaKRcUf3LfYom/KiIQTExmoUC8uwqVejumaiIIbJZfg+554nWBK8kUnlDavop9AZ/BG/NZpWtjJwipN7U641eJVzruiWx4xaQGf0D0UxL2WLXMUphTucGXXWFL/2/pCIV23puXyjU5w9G+vnUwe9hBQC5mZyM8fP06TbpCr1DN7f1jpr5fsnMeSyStAfud5iO3IHw4Lv8qVBbwnwOQerzr/eNnVMep4A7tDkDTo4hFCSGqspzPhRf4febT7cg4mR2+1nekRGTUHfdtD/tucCXUMFdBV4FuC5Z2Ho9CodKh0dMiUnDPJR8IONgKsNl62gQ8K+PtLm8FdQcMGteTz0swtZjO0L33tsTiLnj/Ns/HJ8BTf5Pc9z4UBNolT24ZQoeOy+NeGyfADeU8nmJ4/I24sSPmY2NipOTTTk9yqR9cpKy0xUiWrDD8lg5Vu+c44TArMu7LBpZsBHFD9hsFCjKdKnaB8+cdqt5iU4qHprGw+XCCdv4lxz6sVBHFghPysgOMKwNses=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 24.07.25 11:09, Huan Yang wrote:
> 
> 在 2025/7/24 16:59, David Hildenbrand 写道:
>> On 24.07.25 10:44, Huan Yang wrote:
>>> Summary
>>> ==
>>> This patchset reuses page_type to store migrate entry count during the
>>> period from migrate entry setup to removal, enabling accelerated VMA
>>> traversal when removing migrate entries, following a similar 
>>> principle to
>>> early termination when folio is unmapped in try_to_migrate.
>>
>> I absolutely detest (ab)using page types for that, so no from my side 
>> unless I am missing something important.
>>
>>>
>>> In my self-constructed test scenario, the migration time can be reduced
>>
>> How relevant is that in practice?
> 
> IMO, any folio mapped < nr vma in mapping(anon_vma, addresss_space), 
> will benefit from this.
> 
> So, all pages that have been COW-ed by child processes can be skipped.

For small anon folios, you could use the anon-exclusive marker to derive 
"there can only be a single mapping".

It's stored alongside the migration entry.

So once you restored that single migration entry, you can just stop the 
walk.

-- 
Cheers,

David / dhildenb



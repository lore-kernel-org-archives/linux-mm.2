Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0DB4EC87FC9
	for <linux-mm@archiver.kernel.org>; Wed, 30 Jul 2025 12:54:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A0D206B0096; Wed, 30 Jul 2025 08:54:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9BD4C6B0098; Wed, 30 Jul 2025 08:54:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 885026B0099; Wed, 30 Jul 2025 08:54:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 76C916B0096
	for <linux-mm@kvack.org>; Wed, 30 Jul 2025 08:54:54 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 25BF91A03C3
	for <linux-mm@kvack.org>; Wed, 30 Jul 2025 12:54:54 +0000 (UTC)
X-FDA: 83720925708.24.F109EE8
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf07.hostedemail.com (Postfix) with ESMTP id B133540002
	for <linux-mm@kvack.org>; Wed, 30 Jul 2025 12:54:51 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=JWP1xRFO;
	spf=pass (imf07.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753880091;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BNOLyc6SmRVRa78hSGFNA3yRycOhT7aevX9lnAuVkng=;
	b=RarK6oADMzY9NfiJOxocfyoo+9c1S5+GXCFFZpamO2rJNcNM8Kkb50QUxEI9VnFCm9dMaN
	J1fPWkw2BI1AS3QYKZH6XmnYitGMzrU6Jen0F+QLBtBD1RCF+nipk5NWBqPo+eB4cSmoat
	ZtkRd7woztwo/bJ6TuMK7hzsAg/PhkM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753880091; a=rsa-sha256;
	cv=none;
	b=gLchVbwxKkHBFeqlgEMZWD6eVjIaWVJ9TDCFPM/6m58VOtU58wKJy86LGAyFwDoaO7uD3m
	ZwX7kK+vEMfzTzcuOC5U29zndlSYu+o8Vcr5X7er7qICTnihRqpSt3V/xeyQwBzRFpGK1C
	KMF/+7bnKvv8dOdAFJjYJiFtox54aI8=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=JWP1xRFO;
	spf=pass (imf07.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1753880091;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=BNOLyc6SmRVRa78hSGFNA3yRycOhT7aevX9lnAuVkng=;
	b=JWP1xRFO+sAzEyHU86GR/whrC9Eu1fWarixOlvmboyM3ikElUgQBDTzbypNuLNmuHjQpjQ
	aSF8BGJov7taS7FFJvExn/rv9Hk8X4rsllFcOoBHNZ4etFs7skYTKCGIuP7JSkUys2lURf
	nEyTVbsdX2vQw1SIFrBfjwUWkmHJ3FQ=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-326-OmE20Fs3NYWRJYiLZNntJw-1; Wed, 30 Jul 2025 08:54:49 -0400
X-MC-Unique: OmE20Fs3NYWRJYiLZNntJw-1
X-Mimecast-MFC-AGG-ID: OmE20Fs3NYWRJYiLZNntJw_1753880089
Received: by mail-ed1-f71.google.com with SMTP id 4fb4d7f45d1cf-61560d2c48bso1207258a12.1
        for <linux-mm@kvack.org>; Wed, 30 Jul 2025 05:54:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753880089; x=1754484889;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=BNOLyc6SmRVRa78hSGFNA3yRycOhT7aevX9lnAuVkng=;
        b=wqpUJ61ioWeEVENAK4ZwifZRmz2Mq15/0OV8AZozYSlrZ/U0Ygm6hAJJ4JqrCFEApx
         UJjTLmT4ACfipvo4OSZdQd3GRddpNMVJciAXs1uY44jOSVLx/uTUDqc9r+RHRFLL1MZk
         MA+whAKV5XXnU8LcqXOSaNPojJMsqYvUGTZYCYoUPBbhDSF815EFIETVMmYFYio1b8Hj
         O1l9nmLbFNVfThGtGqmlxjJq7twUY6bLtsZGn/KIcL3eMySrJlQEWwPo5Sx6miXkczgE
         YKjaLcYMs5gETyqg5GG1NpR2QFadls+whR/pjsAHFs4Tb04Tqbe4KxKF8B/FRU7wMD/b
         PADg==
X-Forwarded-Encrypted: i=1; AJvYcCVYIDdRVPnVCA2fTVSJe3jB0065vXA1TPbxUJ/Xmu4Us83GxwdKKV4bJgIcxjSm9g1N4pB3Xgcwkg==@kvack.org
X-Gm-Message-State: AOJu0YzSpibIJjuqXacxstm8zrUeQbYHo+CSzOdPGOegIpvha3ghJ/KN
	HFfFqwOD+t6eTvZYxdYPFNYEufl5VC0km03RS/zMgaVw4HIjFUDddAt9lLn2qj8+PniNk/cByVO
	e4UEal6MRFOe05by31TkNR6kM81athzrj5wYlybBp4R7HsCOF0Ur2
X-Gm-Gg: ASbGncu4cbBOkL4A4HA1h37TqrrYM0Tkz4uj6B+jsADCALIr0eiH+L6r3VsNKaHPVSJ
	E+D91AkSyasv9pVvkyLPXsBZKQr919JqvV8P6ayWXME0QW0EAdUC7/zUg0I20OmbMRikRpESEw0
	Ed0rXBAGisTzg89JxfAYEUd5Zi/uawZtURpHwBSJHKhyrjs2CKymGPq/Xm3Q5IJZQ2T2B/EqReT
	yelRuRxo9uLkPR08UKCIutPnOffHualByz49sEfLauCeIsDTqZuC2jtfVF26X1nMlwvQIpge6gF
	Zh/Pp8Bpo0s1JLZwLC9hVImB2B6GuMfrFwhDXxjZArGOIIe2TfJSaeuMjX5Pcw==
X-Received: by 2002:a50:cd92:0:b0:615:7e88:ef95 with SMTP id 4fb4d7f45d1cf-6157e88f679mr3494321a12.11.1753880088554;
        Wed, 30 Jul 2025 05:54:48 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEjKq5bY0KudoprYalsB0y2Cl4cMah/r660xfqVfVg64zh4dhPtr+6C+EPKKEUf1j0BUA07jQ==
X-Received: by 2002:a50:cd92:0:b0:615:7e88:ef95 with SMTP id 4fb4d7f45d1cf-6157e88f679mr3494267a12.11.1753880088043;
        Wed, 30 Jul 2025 05:54:48 -0700 (PDT)
Received: from [10.32.64.156] (nat-pool-muc-t.redhat.com. [149.14.88.26])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-6158b7504f3sm993939a12.27.2025.07.30.05.54.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 30 Jul 2025 05:54:47 -0700 (PDT)
Message-ID: <ee6ff4d7-8e48-487b-9685-ce5363f6b615@redhat.com>
Date: Wed, 30 Jul 2025 14:54:46 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 7/9] mm/memory: factor out common code from
 vm_normal_page_*()
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 xen-devel@lists.xenproject.org, linux-fsdevel@vger.kernel.org,
 nvdimm@lists.linux.dev, Andrew Morton <akpm@linux-foundation.org>,
 Juergen Gross <jgross@suse.com>, Stefano Stabellini
 <sstabellini@kernel.org>,
 Oleksandr Tyshchenko <oleksandr_tyshchenko@epam.com>,
 Dan Williams <dan.j.williams@intel.com>, Matthew Wilcox
 <willy@infradead.org>, Jan Kara <jack@suse.cz>,
 Alexander Viro <viro@zeniv.linux.org.uk>,
 Christian Brauner <brauner@kernel.org>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka
 <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>,
 Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
 Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>,
 Hugh Dickins <hughd@google.com>, Oscar Salvador <osalvador@suse.de>,
 Lance Yang <lance.yang@linux.dev>
References: <20250717115212.1825089-1-david@redhat.com>
 <20250717115212.1825089-8-david@redhat.com>
 <1aef6483-18e6-463b-a197-34dd32dd6fbd@lucifer.local>
 <50190a14-78fb-4a4a-82fa-d7b887aa4754@lucifer.local>
 <b7457b96-2b78-4202-8380-4c7cd70767b9@redhat.com>
 <eab1eb16-b99b-4d6b-9539-545d62ed1d5d@lucifer.local>
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
In-Reply-To: <eab1eb16-b99b-4d6b-9539-545d62ed1d5d@lucifer.local>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 2n0nL9RBfzHgLM-iRo8ij03wFGGcrUGfYkQ33H_HeLk_1753880089
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: B133540002
X-Stat-Signature: qjzr4izhhn4df8u34ciijyw5ohguotef
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1753880091-498655
X-HE-Meta: U2FsdGVkX18FBNNHGuRVQCVlm6BEizA8XhJiCJkNlUoXhAWO5chI8N3TSUbxQYFP2zCMHNAmV+L5Px0GV8u5fYEcfnaFeK6lTkiaJDZCDyqzEJQuipkGPD9EH++XjIYCmKbTD6x8+/iTELJekuQ9YxcVo/9qwIq0sbi333WvmqV5UCuAEfFKzTdwKrktzi6dCu3S8x3gYHvauyxb5CVHQ+Z1qTJyCayQsgfSZ4zoq0bInIeRVYBABLsHgLIJOmy+wqW3YZRgUR/IXl6sB+eWogIh9uyfJKvhvqEB6Py2HEuWyK/iGDujTNwgLfnJD7lQemBHpAunRF6L8i5ReG5f4zz3nptdeBt+X1ZpvzVqkT64hVS7W8adCoZZqGXCgrxsaLI/pBsFwQPzR4kpVgOhMVNBofqarhqzJAp5SschjoD9LavSh4KdsX2fH/nZ/Fuwf17PxYuJ+A9PY8yuPnXlnfWXLwejDp9X+NZcY2ZRWchuopi5gN2g2A0JQHztXqTqx4Ypg7JsZXkR3re13y2RK1vJx4Qsb/ziHvR0MHxFBd+aDi6n90BQChvApEDFJzAn01c3mzAq2tdoHlkXZyBZ+xQfTEquqc5FylpiXiKSmp6AdE/jZymvgi1pAFxzyeCbAJUflGk2QMK4PX6eMrwnS/A+eNX1QCKozbKQGhnu3IQb1ONmbSYWmmn5+RUEpYMOx5l3XQrfs7iEwECKwQfN95G/cLnyhwcA0zBq6mUdKBJm49D36Q4S65uW9sJax5vE1NHamaq5RZ0iCq45NGx8gs7Z574hj2krME79NYTwtzg7gcuzKNvzM7tQlScA+3QbavWQqn77JqnrpLdDquoJYu2OWG/Jmff1zE5u1udvVjKLj4K4/Kld05nE4r5v9EqZDQih44vKdx6kzYi0xeKV0MAFYzlUFTWRv28bSgW+SrrQ6SvJE1pZFa/3JIpLeYLIfFygMmYz/+01u15OF4G
 af7EtLxp
 SfA7i1Xd+4ZsBihdlOhf+JMieJXFyG3qW6z2mKUcS9acvpm2DAa1SyeyAyvTZFcO9SnTAlsD9Yps83bFunVMyMJDN25aE/zMut2BlcF3m6HTTMCLFo10sqXzbh+njbv+BP+ZxiaLePZuL4HviuZnhcrOBJhWqXkNSc4tddm8nt7sCuvJ/SKOEMceX1yYUJX83xNU1HK4bEn2edtbR/mzEdz8SqMY+Ex3iK9LXo1KiWF2mQXGZYQHiUrLR2HyDhRFtc28qwARdnav/+YppCRz9KlgSNXEStvPqiEXC7YiHzlcjQSYBqEPLPJqbRykwnc/veZbC6/Thf7inXaIJflG83X4Vo+ange+r9UWBKVP+BI4Ls2AxCD2TRkBFw/CkoIOVqq+NmKcIXGEFKtVi07Z7z0g7QCDTe91X1YLbtXPj/+0jIcQ/g0NBkZWAPPuqZHpydPrTLGG7m6CINvyAVvAlflOXxbVrS/Wv3qVxscsE47FKNwYsHhubhrsYDFqbQMnGDhUBKNCTZDtSSv5GktkG/Vfu+uooEIdwl+trd7eSW73XOngEt9BHlypgrt0N0oo/kpwqLvkU37eTK9yBl730gI/JIw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 18.07.25 14:43, Lorenzo Stoakes wrote:
> On Thu, Jul 17, 2025 at 10:03:44PM +0200, David Hildenbrand wrote:
>> On 17.07.25 21:55, Lorenzo Stoakes wrote:
>>> On Thu, Jul 17, 2025 at 08:51:51PM +0100, Lorenzo Stoakes wrote:
>>>>> @@ -721,37 +772,21 @@ struct page *vm_normal_page_pmd(struct vm_area_struct *vma, unsigned long addr,
>>>>>    		print_bad_page_map(vma, addr, pmd_val(pmd), NULL);
>>>>>    		return NULL;
>>>>>    	}
>>>>> -
>>>>> -	if (unlikely(vma->vm_flags & (VM_PFNMAP|VM_MIXEDMAP))) {
>>>>> -		if (vma->vm_flags & VM_MIXEDMAP) {
>>>>> -			if (!pfn_valid(pfn))
>>>>> -				return NULL;
>>>>> -			goto out;
>>>>> -		} else {
>>>>> -			unsigned long off;
>>>>> -			off = (addr - vma->vm_start) >> PAGE_SHIFT;
>>>>> -			if (pfn == vma->vm_pgoff + off)
>>>>> -				return NULL;
>>>>> -			if (!is_cow_mapping(vma->vm_flags))
>>>>> -				return NULL;
>>>>> -		}
>>>>> -	}
>>>>> -
>>>>> -	if (is_huge_zero_pfn(pfn))
>>>>> -		return NULL;
>>>>> -	if (unlikely(pfn > highest_memmap_pfn)) {
>>>>> -		print_bad_page_map(vma, addr, pmd_val(pmd), NULL);
>>>>> -		return NULL;
>>>>> -	}
>>>>> -
>>>>> -	/*
>>>>> -	 * NOTE! We still have PageReserved() pages in the page tables.
>>>>> -	 * eg. VDSO mappings can cause them to exist.
>>>>> -	 */
>>>>> -out:
>>>>> -	return pfn_to_page(pfn);
>>>>> +	return vm_normal_page_pfn(vma, addr, pfn, pmd_val(pmd));
>>>>
>>>> Hmm this seems broken, because you're now making these special on arches with
>>>> pte_special() right? But then you're invoking the not-special function?
>>>>
>>>> Also for non-pte_special() arches you're kind of implying they _maybe_ could be
>>>> special.
>>>
>>> OK sorry the diff caught me out here, you explicitly handle the pmd_special()
>>> case here, duplicatively (yuck).
>>>
>>> Maybe you fix this up in a later patch :)
>>
>> I had that, but the conditions depend on the level, meaning: unnecessary
>> checks for pte/pmd/pud level.
>>
>> I had a variant where I would pass "bool special" into vm_normal_page_pfn(),
>> but I didn't like it.
>>
>> To optimize out, I would have to provide a "level" argument, and did not
>> convince myself yet that that is a good idea at this point.
> 
> Yeah fair enough. That probably isn't worth it or might end up making things
> even more ugly.

So, I decided to add the level arguments, but not use them to optimize the checks,
only to forward it to the new print_bad_pte().

So the new helper will be

/**
   * __vm_normal_page() - Get the "struct page" associated with a page table entry.
   * @vma: The VMA mapping the page table entry.
   * @addr: The address where the page table entry is mapped.
   * @pfn: The PFN stored in the page table entry.
   * @special: Whether the page table entry is marked "special".
   * @level: The page table level for error reporting purposes only.
   * @entry: The page table entry value for error reporting purposes only.
...
   */
static inline struct page *__vm_normal_page(struct vm_area_struct *vma,
                unsigned long addr, unsigned long pfn, bool special,
                unsigned long long entry, enum pgtable_level level)
...


And vm_nomal_page() will for example be

/**
  * vm_normal_page() - Get the "struct page" associated with a PTE
  * @vma: The VMA mapping the @pte.
  * @addr: The address where the @pte is mapped.
  * @pte: The PTE.
  *
  * Get the "struct page" associated with a PTE. See __vm_normal_page()
  * for details on "normal" and "special" mappings.
  *
  * Return: Returns the "struct page" if this is a "normal" mapping. Returns
  *        NULL if this is a "special" mapping.
  */
struct page *vm_normal_page(struct vm_area_struct *vma, unsigned long addr,
                             pte_t pte)
{
        return __vm_normal_page(vma, addr, pte_pfn(pte), pte_special(pte),
                                pte_val(pte), PGTABLE_LEVEL_PTE);
}



-- 
Cheers,

David / dhildenb



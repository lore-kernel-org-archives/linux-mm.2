Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B5DF1C87FD1
	for <linux-mm@archiver.kernel.org>; Wed,  6 Aug 2025 08:56:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5930D8E000E; Wed,  6 Aug 2025 04:56:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 544478E0001; Wed,  6 Aug 2025 04:56:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 45A318E000E; Wed,  6 Aug 2025 04:56:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 35C658E0001
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 04:56:24 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id D1C14C04D2
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 08:56:23 +0000 (UTC)
X-FDA: 83745726246.28.8C8A19A
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf09.hostedemail.com (Postfix) with ESMTP id 67244140004
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 08:56:21 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=TBQ16AXe;
	spf=pass (imf09.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754470581;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ligMKuzMymYT6q7hFg+L6jC/QWTmCs2aLfpugFK2uvY=;
	b=pm41VmaE6PKnMF6QGeqBB/O5m2X0oTYL0CCUeS4fIHWzScQpptSJf4lXnAUYQ/Ygaqbmnl
	jzbV0W4BH6JpGk1Tb5Y1CHezoArWIKJJKVILsgxAvHJaOy+AjGpL/I7aNw6xD8UFd9tnIY
	bchE0NcIQgAnnj/s28NiXBpLxWsHnbU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754470581; a=rsa-sha256;
	cv=none;
	b=MEY0UoTEGzc4Qjg2g6EzZjHhkvKefs2sn81O1gV+EJ+HbgV0AfiSypsD9wOgTdALeEW9YY
	JD86NZr7ozFdKp2wBJe6YS2wb0zJPzruOAXSETjYjyXOZ9gmcd3CSr3BBntNO4Jd0DpSuW
	yGH6P7adp4MYUnnBDxFSszRX3l5OLbw=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=TBQ16AXe;
	spf=pass (imf09.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1754470580;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=ligMKuzMymYT6q7hFg+L6jC/QWTmCs2aLfpugFK2uvY=;
	b=TBQ16AXeBEbiZHQvGZZVj5kTdGBo1SwXBC5jH9ZqmdQGl0UEK+MalR5JPmU3lZYWdNYqN5
	SShRSbou8HmUeAplZg1KgAXABoyXn6o8NThPsodCbQSzDl2ew1AfGeMgnQ3asLBfxBN7MD
	YDerEG5zDGLe9WMMLRpMfCruUcjQGBs=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-77-eKInXZCdPm24mpZSeFzFbg-1; Wed, 06 Aug 2025 04:56:17 -0400
X-MC-Unique: eKInXZCdPm24mpZSeFzFbg-1
X-Mimecast-MFC-AGG-ID: eKInXZCdPm24mpZSeFzFbg_1754470576
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-3b8d62a680bso399902f8f.0
        for <linux-mm@kvack.org>; Wed, 06 Aug 2025 01:56:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754470576; x=1755075376;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=ligMKuzMymYT6q7hFg+L6jC/QWTmCs2aLfpugFK2uvY=;
        b=jUI4UeRlVqTVmjaJN3rZE2Q2jlyEIQjpzCdehaexIofQSVUQF0WW5sIP2p8qkYZORo
         T1uXz5kW0+ZWkGPsSiY8Y6K66UvEgIryUmo93/KeT0S6OgZ8OmlABhve/mLNOLAXBvEy
         3C9UPESuWWO8W7EfJGbCPs9IIdIKbsk9gjmruaemHStfSZ6fu6dE5GyW5vKHgbtCMkpL
         zU8hHGJWz8El3+dZWC6vbokOH1573WWjN03vaSUx+ApFoTXWsgrNJYT30fNi85LQUdz7
         4kUT4POCP0O0BAvFDDkk6jF6gpDMFkL43HsHVGtmt2I+gznItQZ7RYVjNnkewJG15UXy
         lwcg==
X-Forwarded-Encrypted: i=1; AJvYcCU9V+BYIIYV+BhcTWV0hPBZ9dpEdkydcwfIv4eTPdO55FeX+ZVGJ7Pf20XVB1bmka4TNA3qvljOvA==@kvack.org
X-Gm-Message-State: AOJu0YyzJ0NJ4lXC/azINfS+sA2tMLsPzLW1sBUfQnp/eFDteZtmNxlW
	aGelHfe4TgMJXRSJcF1yJX/YTkA6hJbpF9IYgucAhPs8ZAVZ0kE0DVEeUJ1mor3q0JsQh4bMouH
	5tqT27iDnWw12I8jMwqJpV+LJ+tvwZKn5szVj3I+3KUlSWZo7tNxi
X-Gm-Gg: ASbGncta2F3oBIg4uYITU5AwPMtlZblaQLv+2RvNhrf+IJPjkOSuvY26l40GQiJyYrV
	87VGY6j9OGSfyui2s3pcQ3LCzrcfSLVAdbO39GhZcfGl+r3fXUyABxlUNeV7Ehmw0GULoQAZA/q
	0UFBN4HCf9LllgAcVOSepnBeR+m5QIiaGDp+3FqzD6NzLNDM7kApohFNXXPBD93bQmhiJ4E/Y/G
	o9LpX9QEfjkJywIgCZCqUQ/rQo8VNKFU8UieC3masjSejF5lnWWVUw7raX9GoM/rMTqp0cCJ3WP
	defbB2ExsPPaTLkJK3OyuczmIMMAKvKeznOQN0LGvEsOsq9EMz1Lj6GYDaqAgDXwg9Kf2fTM90Y
	jJh7SQvLpvtR+rV6C6ZUesQAK3kk+9C1YgXklOU5tJCRZkmGIKuPsFsCFuqMx17vWAI0=
X-Received: by 2002:a05:6000:1a8f:b0:3b8:d25e:f480 with SMTP id ffacd0b85a97d-3b8f43723femr1567457f8f.29.1754470576108;
        Wed, 06 Aug 2025 01:56:16 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IE4JMRKLdw3mXUV5OuDO/tBpecNu9HjGvZkP0QMVtkPkAWZcsAuNEwVje9OMdBe9DlC7UE48w==
X-Received: by 2002:a05:6000:1a8f:b0:3b8:d25e:f480 with SMTP id ffacd0b85a97d-3b8f43723femr1567434f8f.29.1754470575683;
        Wed, 06 Aug 2025 01:56:15 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f35:8a00:42f7:2657:34cc:a51f? (p200300d82f358a0042f7265734cca51f.dip0.t-ipconnect.de. [2003:d8:2f35:8a00:42f7:2657:34cc:a51f])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3b79c466838sm23317600f8f.49.2025.08.06.01.56.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 06 Aug 2025 01:56:14 -0700 (PDT)
Message-ID: <4e6e0492-f2f3-44d8-ad02-084a47c9fa4b@redhat.com>
Date: Wed, 6 Aug 2025 10:56:13 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 6/7] mm: Optimize mprotect() by PTE batching
To: Dev Jain <dev.jain@arm.com>, akpm@linux-foundation.org
Cc: ryan.roberts@arm.com, willy@infradead.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, catalin.marinas@arm.com, will@kernel.org,
 Liam.Howlett@oracle.com, lorenzo.stoakes@oracle.com, vbabka@suse.cz,
 jannh@google.com, anshuman.khandual@arm.com, peterx@redhat.com,
 joey.gouly@arm.com, ioworker0@gmail.com, baohua@kernel.org,
 kevin.brodsky@arm.com, quic_zhenhuah@quicinc.com,
 christophe.leroy@csgroup.eu, yangyicong@hisilicon.com,
 linux-arm-kernel@lists.infradead.org, hughd@google.com,
 yang@os.amperecomputing.com, ziy@nvidia.com
References: <20250718090244.21092-1-dev.jain@arm.com>
 <20250718090244.21092-7-dev.jain@arm.com>
 <7567c594-7588-49e0-8b09-2a591181b24d@redhat.com>
 <a2fdcb87-9223-4091-8bda-9d9316c84cf4@arm.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 g3eXuA==
Organization: Red Hat
In-Reply-To: <a2fdcb87-9223-4091-8bda-9d9316c84cf4@arm.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: WKHCPkJ5V0id3lZiz9Tmt3xeQpJ3uGRqMM_9cs9FMqU_1754470576
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 67244140004
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Stat-Signature: d38fytzyp34t6gtta4y1xtpobyys93ct
X-HE-Tag: 1754470581-189942
X-HE-Meta: U2FsdGVkX1/LyMVy5//aevzCm3VFHm2OiiCe/SCmnCIye4M9tCjgLRf6UfPfkbckjuCYrrldhLf0+JLNZ8v/1o9c3Mgz1MDFVeY2lFaduEHmXLinmj+Q3/Nnl8sf3QfMGVUL8YOkHDjeQMxF4iBtVUoXcLAQq00nR9QjGCe4J822V1Ma+Bhgcg3kveNW7tXgVGR8lNengsk/BPYp8k11oPrdsfgxMK05GNFSIDGFDHiB07+i4Hwi794jgEkTwj1OF0Qk8FA81p+HyQP09CS5ihuBGcMjzNjuQisRv2fQ/BMLS+uqxrQc3URfC10zYHoRfnZ2eViY7UzF2K/Rp+8J9S6T2XWJiLC2zvMeKEz8TkVNMmlPjGPa4es4UC9i6q3t+7mboUPP/Ap7IN9nFU+svXAgM6JoQnUizobzdTTr9gdcypiqEddLTq+VsNegK8A3F22Ef2EaTe9+pheuK/4+FbdRZovIY0uIxcP9zSUUolbgYUEXA4Tcd5zPMPuidxoM9cEZPJMrsR6feWzUGeOS0v1hxkKkkrbEdgfewgjO+He6qfA8MXnCL+mq3uJYJWWswYKfQ8AhxlTlCkjH/3fZeTewph5DjDT/t/keJ6LiyFD0znAkF2MViI7zaDdvtu0aB91iHZDPeLbqJcIUS09yoUjb0n4tUH8VckbTz0UlgMz8eVUPBI458a4rps3Huv0vKDreQ3jSKIuDyuiRUK+89UjNAPRMWMoNVInzCNmb023KjOipL04+3tBfFQK+qv1GrVBZ6cXrNSMh2nOpncKUHBYLGwySOw1wLSrGZkd1jJX5XFI2cNu1cX8XvLSEPVWCPDK808a23JtprNXQoK8fMvJV/4MfqtOKV6y3hj89csGYAdyh9wrSu8zFthJu/rp+GGwEgpSmLmVRaO/EzROQE7YhxKOuWKpB1Y8W8JlcoFaBfAJjzGjIt0qorlLsjnfDCbdMZ5qfz/42thcDRLX
 4MezQ0EY
 ypG3/LJzHj9xNwxv5JRMXYnsWfPXcyqintGlh0vGA9akmr/Tf7AiDmkAKSy81HET3PB9LYVlBxuP1AuNGCwk530ZzVxVKGo3qkZAmZgGpIhq8f833rR5tpmzvXwJ5QFK92bATUEW2FMnfrt1hFGABvY2M9d6+AnUjmqfWwvTegbSEKy7gvxzXJFMwZb1D1xiSZQu5XjTOj+/qxxawGQei3EL+uiwb5pQsjv/Jt2tamjK806WuE3E/Hi42b1k/wOni8GeV8xniizEnxkI0JhVRLnRyW6e5AlecIHHvmnti55k6DuEjUKD724B8b92OJn3Im+MLmjVhUpHTkaWQR4LdRl8SwxnEYmtnUUn/jiESn1jdMAtK1YorNQV6Q6dZg691TashU/Az39Mw5WvkuY/LRgzI01tw4moudWUHK0/bW4S5jC+MPMj23S9fk039lyi0/i6tI6MEoGzya6RszW9tBj8q5Q==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


>> While staring at this:
>>
>> Very broken indentation.
> 
> Indeed, but then in order to fix the indentation if we start positioning
> 
> every argument just below the opening bracket then it will take at least
> four lines :)

You are allowed to use more than 80 chars if there is good reason :)

-- 
Cheers,

David / dhildenb



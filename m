Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A7CADCCA470
	for <linux-mm@archiver.kernel.org>; Mon,  6 Oct 2025 06:43:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E8E8D8E0008; Mon,  6 Oct 2025 02:43:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E66978E0002; Mon,  6 Oct 2025 02:43:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D7C328E0008; Mon,  6 Oct 2025 02:43:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id C86DF8E0002
	for <linux-mm@kvack.org>; Mon,  6 Oct 2025 02:43:28 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 7D22913A9BF
	for <linux-mm@kvack.org>; Mon,  6 Oct 2025 06:43:28 +0000 (UTC)
X-FDA: 83966748096.10.6BFE9C5
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf24.hostedemail.com (Postfix) with ESMTP id 1C08E180004
	for <linux-mm@kvack.org>; Mon,  6 Oct 2025 06:43:25 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=ip6YYFYB;
	spf=pass (imf24.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759733006;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jfHfhlWjEclTzEkkz7JaLEzlRipkUaftiUVNQwzVUrQ=;
	b=biHcWg2lfYWg2edHB7XGD+RCnRzHkC/P8faHEHuu8UDmYfqoirRIRbiej3YaoCmF/UTYBp
	30VqjIyf4V14Nmys3uIx65A40i7hBjcXGkX8Tyoyi1iyxT/0n6NQ+9OFkHasZlYwrDMEgZ
	LBLwMX5Wya+tD+M/gtkgNphZMuXeFNw=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=ip6YYFYB;
	spf=pass (imf24.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759733006; a=rsa-sha256;
	cv=none;
	b=PFFw70vgGMmBR0IzkGNDdY7AgXNmhVoVSBUyQh7nXNHXwUz+fJlH9ENghDBFl9wB48J4a0
	8e60uDiWU+UWBu3lKD+EGAii8Fgz/kyDmFCvFBbKNAa9EzeQrc9geQv4H3vM1K4Kg1KRJo
	viBCZrX0/H/Q/PTtXPn8GSt/dZCCLSM=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1759733005;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=jfHfhlWjEclTzEkkz7JaLEzlRipkUaftiUVNQwzVUrQ=;
	b=ip6YYFYBAi5igRqxJqYIEoUqphPXI9T0fBJ5KPDWm3rqwg9Jo5tvXTd8DaU3YCrSEJ/GYi
	P+k4670zDHi1ptS11s7JTCwJ5YaUvjGltcLmL3rve9DeWweGl2jQTWiIIhiycVcwkYPcZR
	EPYbG4w/5YB0fvtlIYnkObas+RJgZUQ=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-189-9jMgM4JuO9WADvepko3BQA-1; Mon, 06 Oct 2025 02:43:23 -0400
X-MC-Unique: 9jMgM4JuO9WADvepko3BQA-1
X-Mimecast-MFC-AGG-ID: 9jMgM4JuO9WADvepko3BQA_1759733002
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-46e4335fa87so22500485e9.0
        for <linux-mm@kvack.org>; Sun, 05 Oct 2025 23:43:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759733002; x=1760337802;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=jfHfhlWjEclTzEkkz7JaLEzlRipkUaftiUVNQwzVUrQ=;
        b=cEz8Eko2yQ2E8EagJcYgev2j0N2fA3Q19r8aox4fV72sFjwLU54H0B5ZadEetQeEIH
         diAYP43vzw9WOLtgp1rF4uF4/DA7LvVnUZiYzoTbwVb6a7jIHC8vHKCK6qOsCvNrw7If
         NByTbGVU+HeFbo2BPIL+0SsAHW27ybmHebIU6f6GDgPgaNlk1M1oDa+ltftvQi5pxNr1
         Sau7Omf+LOZarcy/w2MZIO6Dlfjo6PunS85BqhcT3kEBdJFtOQ2Z2vHIBfzHuz6NAY6c
         mvAbtYaG0OZgv33EjaX7Xy5fnL8v4LtBULhEG9MBDUhChaM5YLvn00Xa1W+D5fEoa2Sy
         60xA==
X-Forwarded-Encrypted: i=1; AJvYcCU6O4mb9qv6UhV2Yvh4i95oVf0rbUh5L8E/y8qzVDtKZu1C9zoutO1oV/Cwf4mA0Ck8kQOqrF0eDQ==@kvack.org
X-Gm-Message-State: AOJu0YyiruUb1R5B8e/iT9n57IFGIq1UxhdfqTOO22JhXmbEWdqOov/W
	g5w3q4pAF+6ZGW8apHPVl5jzUfmfZwTx5/+yh7m4vua8YS1keHYsRskkhCZGpvVF62wq71t9lAk
	ni5vzi9HH1V37ywMgxDyTSEVt8urxQyZDaXnmDAuMwk0T7Zyp7Chh
X-Gm-Gg: ASbGncvDI9G8Tznxu6NCU96/FuO1FYcDovYHW9RfCUFr4BygiDYaVGW2EPHDg0BORPS
	6k3AAHmKZh0NRt44odIynW7R1QrLT8S3SrBbn1oO5pnu0Dqn316ssMLsjg4HXHfMYXOIay/YY2t
	5J2vXfdETTABPYsKR6bKohPMoWf31q/X1aYuDWvkjX2Aam+Pt7fM5a4/PBAhSqNLu+9j+ECZyYa
	GsJfOhmA+3APbcQWN9Bxaz1p9Oz4z8KofOAVDnDSfQcXXQgHWrOieqULMJvoWT3wUd0NZM2OEFK
	swUKMzoPR/1lxFinRbZuADxpAzB9w6SG1JMO3Z+qLelrGjy++IT2SQTmDNbEwnss5UULr1v/2Gv
	ZLhUuIanB
X-Received: by 2002:a05:600c:8591:b0:468:9798:2043 with SMTP id 5b1f17b1804b1-46e7114ea2cmr58006895e9.26.1759733002219;
        Sun, 05 Oct 2025 23:43:22 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHnVyEw86BI/gtAzBivY68i5sRv0VkaSIxTybpYvBIRNDcMyYNtWTEgJAPh8pnAVV8UHxb2PA==
X-Received: by 2002:a05:600c:8591:b0:468:9798:2043 with SMTP id 5b1f17b1804b1-46e7114ea2cmr58006675e9.26.1759733001825;
        Sun, 05 Oct 2025 23:43:21 -0700 (PDT)
Received: from [192.168.3.141] (tmo-083-110.customers.d1-online.com. [80.187.83.110])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-46e7236267bsm153801895e9.16.2025.10.05.23.43.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 05 Oct 2025 23:43:21 -0700 (PDT)
Message-ID: <872c98fa-56d8-45cc-a7d2-1b8d44614640@redhat.com>
Date: Mon, 6 Oct 2025 08:43:17 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] mm: always call rmap_walk() on locked folios
To: Peter Xu <peterx@redhat.com>
Cc: Lokesh Gidra <lokeshgidra@google.com>,
 Dan Williams <dan.j.williams@intel.com>, Alistair Popple
 <apopple@nvidia.com>, akpm@linux-foundation.org, linux-mm@kvack.org,
 kaleshsingh@google.com, ngeoffray@google.com, jannh@google.com,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Harry Yoo <harry.yoo@oracle.com>, Suren Baghdasaryan <surenb@google.com>,
 Barry Song <baohua@kernel.org>, SeongJae Park <sj@kernel.org>
References: <20250918055135.2881413-1-lokeshgidra@google.com>
 <20250918055135.2881413-2-lokeshgidra@google.com>
 <2c9df5ee-6109-4fa5-b895-ad8e47d34bee@redhat.com>
 <CA+EESO4h-_U=Xo3x0G_74t_qJQ54AZ4Qd2Ji437aMV8nDZ+tkw@mail.gmail.com>
 <5549ac3a-20cf-4959-ac53-0a89ed0eadd2@redhat.com>
 <CA+EESO5e0gupVfM9NgWqx34oMRk1jGzsNfM=X3idPKaXkRL2fg@mail.gmail.com>
 <7305f905-0f81-4268-a3b3-933ac00cdb6a@redhat.com>
 <CA+EESO5QruRtz8X=2aO8=6P_=uUQuun3f8Uom9gR9-zL-F7dWg@mail.gmail.com>
 <4909d194-58b7-4e94-b730-f916100238d3@redhat.com> <aOBWF8uLmm9iQ2XG@x1.local>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <aOBWF8uLmm9iQ2XG@x1.local>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: C4-qcxPTmOw9-g6hljsjCUuCrvGH0rNjluEDhCU5oH4_1759733002
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 1C08E180004
X-Stat-Signature: kadkzb9yhjqg9fu1czr5isuqrw6bfmpa
X-HE-Tag: 1759733005-250066
X-HE-Meta: U2FsdGVkX1+QLnylqKU16cMjoRgzZzx50BfQOsbs3NydnizeZ9fU0buQHltrniqbK5uCCrDBxgvYmDldLZN3XrTDPHcsFvLfjWx46MMXcP4/32XOeAagVox1dw8OOLPa1ab137A9ITV0FJccDfYqCyVo/ERRrddfMYj8RhTSIkXYEkj3bS7BZa4IDH0sho2kDigtnKBY4h4FbH5OqdF1s3yIAhHy2AAMIUKXrh6yg78ME3AUw521Inwykj6cbg4UQ8x8DZBYmKUzG48Aegjlpi2Uyw61KfHTgult+fmZxKHl/k30UkpnMwypyzJZQDtjOrI+TcwiAnDftmVa8wk4AENSRFqlKUvTuxlVzo3yOm6en3LJxW+q/7x0CNvLH2X3KKdA0FPuTdpGRYUX+0BLOW/GHb/TzcIECBJ2chIWpPTWk10Q0ZhmCKe7lw2MrOqS50XCKFMaDGe4I4b1eF+I8lgZHbhNav7NoBXH37IBeuXXY8mS6XZ5GdNt9iOZ08Q90UmhhSMlDsOveQ6GTsgcMKqOVdQgAhTX4YwbERXRb600jZntxv+zmhyjl3oIDLBeGJtOeh2nwsHcQEv0ZX/mNFtk0v/B6mhu2feeFZiQSLF5unmghhbAoNMPJy4sB1YqeQdtKIrngxhK7aNiEzCpfvsgq4w6DxnZIbmvp5nFyOD4hOBGERan0SLVbZEymNFXfTagDoNgbqZquTXXKW8IUe49GrRx9PuCApFx01wm9vEtSqfmlHO3eQosBrxNwBxPrh3e4vxWk6suRZBB5zkR6kUWzCmhv4fzHQwvyojMjGvk96VkOS7zPDcKKPPZAoG9pJizVJ8LDElSZYWu5G5gTLhBk0v9NUKkb/xR8N2d7ntmKZvbdnFhhOaPgTWfdM74tSIAF81KJqzcKxZplabR45Vtiyocz73DNSj/jWmqG6SLL2HtX0HUw0M9fX2g8xfSv2F5JmID9qiUS43vf0U
 vzLmzud4
 GMltDdDIEq0zG6/v8S9zYoJlzRZWfXHB6OVTZKKuy4SCgWqSi7kLDNKwOOmmOyEIxKFFisSlFkqOxDmEYZUAEKxKI4Vw1uahBkkaoNz6lInDi+ib1BMbEkIzBJ6CfdpHvFZ9kx8vDrUahxzOAi+4gY0UxWNTUQjGIgoMzhHAez2tAMr3a4Iep0PAv5ItnV5gZ0IRvWxjA5lQvOkPLFCXIzTa803K/Vye89a9yqOm9M44ZSmFFBtzeRn0BUKkj5HkfQrD5tRN5P0juV92bU8IXw02UEj3i3r27wGw/5WCc6cAHCajgnjxzJ3Okht6TK8KHHPNcWtOtHXtBCKjTIKw7tb6Qm6njj32lZOrA1jTSHPO35RDMI9YW7xuPXgGTGapXrRFoGBqAG/hZszhNtPxdXdxM83xuJ/pDrINdijN+Va8/aKx1e+7VqkaTjj7XDQ/rCzamaApcXN7YC/b6f4OV0wxGg8A7in4uFnGBh9s6ElC/5migbf6itdNc52jz478mPfTU1rkqYH7mUJdDl/dXSEoBSvQQBnExQXgEdFNW/GHJOcI=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 04.10.25 01:02, Peter Xu wrote:
> On Thu, Oct 02, 2025 at 09:22:45AM +0200, David Hildenbrand wrote:
>> Staring at mf_generic_kill_procs() once again, we have this
>>
>> switch (pgmap->type) {
>> case MEMORY_DEVICE_PRIVATE:
>> case MEMORY_DEVICE_COHERENT:
>> 	rc = -ENXIO;
>> 	goto unlock;
>> ...
>> }
>>
>> IIRC, all anon device folios are MEMORY_DEVICE_PRIVATE, so we should
>> actually not succeed in this function and just abort.
> 
> The doc says:
> 
>   * MEMORY_DEVICE_PRIVATE:
>   * Device memory that is not directly addressable by the CPU: CPU can neither
>   * read nor write private memory. In this case, we do still have struct pages
>   * backing the device memory. Doing so simplifies the implementation, but it is
>   * important to remember that there are certain points at which the struct page
>   * must be treated as an opaque object, rather than a "normal" struct page.
> 
> It does not intepret to anon private memories, but something that the cpu
> cannot access..

I would not trust the docs that much ;)

We establish device-private folios when a driver requests to migrate an 
ordinary (non-zone-device) anonymous folio to device-private memory 
(e.g., due to a device page fault).

When the CPU re-accesses that memory, we spot a device-private entry and 
trigger migration back from device-private memory to ordinary 
(CPU-accessible) RAM.

The latter is triggered in do_swap_page() where we handle 
is_device_private_entry() to call pgmap->ops->migrate_to_ram(vmf);

For migration and everything around that to work, obviously the 
device-private page also must be anonymous.

It'a s bit more obvious in copy_nonpresent_pte() where we call 
folio_try_dup_anon_rmap_pte() for is_device_private_entry(), because 
these are just anonymous folios.

-- 
Cheers

David / dhildenb



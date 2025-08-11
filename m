Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 259C7CA0EC0
	for <linux-mm@archiver.kernel.org>; Mon, 11 Aug 2025 07:55:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A2E976B0119; Mon, 11 Aug 2025 03:55:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A06056B011A; Mon, 11 Aug 2025 03:55:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 91C716B011B; Mon, 11 Aug 2025 03:55:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 802C56B0119
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 03:55:06 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 553F1C05F4
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 07:55:06 +0000 (UTC)
X-FDA: 83763715812.15.7A751F9
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf19.hostedemail.com (Postfix) with ESMTP id EB3F21A0003
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 07:55:03 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=IPVSWoGb;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf19.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754898904; a=rsa-sha256;
	cv=none;
	b=m68xt9UzBTW8Ig7JRXaxHBJF9kDqDxKiUA84K08/ae3lpoHeXt4YdzUF7kztuhVobSj+Nz
	vWZKppaaw6u/rLr6glio7QG+MKivf2WjAzVpWt4Vkmka62v8LVCnriepYNQwKwX0McH8UE
	2LNn9YJjU/8svX1nh2qHD+xTgBrr1aw=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=IPVSWoGb;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf19.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754898904;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1FQry3Hg34DzSoY0NjJcclgRYZAusQ2A/KtdVBwBlFk=;
	b=3aFk1AcuUTfbvHxVm2C152eeVJweSpyWNGgyt2YBKau6Con+TyloAQ6RqipU/mJMtzx7/U
	w5iOO6LyPv5GwsFafkmTw74Oi47GgEZgKxweDdpOv8e7tSekQa3AB65DntvOByXgBZNI17
	0YB347Rhi10w0R8pnk3HOH3k1NY6GG4=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1754898903;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=1FQry3Hg34DzSoY0NjJcclgRYZAusQ2A/KtdVBwBlFk=;
	b=IPVSWoGbOQJvsG+872YKE/F/S/FypCvn3KLg12gONzWyZhb5nwltu1v2u8P7lL++Jytdwc
	H9skP/kjlcYdHvyLjr9krU6QYg3/8uSRbWp/KYXP5vg+2ijUF5auiGUsAnm6Z6FKmKN+Wu
	UVCKEQjFtrGHxlflhRoaWaWMX8XiWC4=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-20-psWB_VFkNQWw3z0kyDrNbA-1; Mon, 11 Aug 2025 03:55:02 -0400
X-MC-Unique: psWB_VFkNQWw3z0kyDrNbA-1
X-Mimecast-MFC-AGG-ID: psWB_VFkNQWw3z0kyDrNbA_1754898901
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-459d7ed90baso31658485e9.2
        for <linux-mm@kvack.org>; Mon, 11 Aug 2025 00:55:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754898901; x=1755503701;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=1FQry3Hg34DzSoY0NjJcclgRYZAusQ2A/KtdVBwBlFk=;
        b=pwyiWmwiYO0GvRap9XFeStZoEbgKAmRRawLd57kmkmgeqUJotsNCH7Cin+4tZO9wQB
         wuJlxftzs1HxzkBkrufNWx614PcdwZ+Kltr4ZcNLzg4NLvxtwJ0YHXuMNAQ8oGdE43uH
         8SytdEQbBvjUcpsZfLMKrvWKAvASsnvKOM4NzZfZ8SyvBwFpw3HMEdPylxeJqWK9AjYk
         A81di1ITGNOAt663YeCQ0t2YqWnonbvnuKz35YyQXt/ILzIFgU6PsnwH/JeYEXN2YQfY
         mKcvRUUqRO5wbP1ZeA7th8DSWNQGUMvXfi+yxnCgqHnmBnFYnBNXbXK2qdxPaLz3NFSa
         +y6g==
X-Forwarded-Encrypted: i=1; AJvYcCWES/AgJETjIwYR74y29ikAKbCgbIctYFi0gogO4Hqnom1omOzsmCDBxi7KuLl3LKdXIQXw4b8dOw==@kvack.org
X-Gm-Message-State: AOJu0YyVaxDgUc6brrtHRwjrfIpZnb9u1Sz2xu74MnroF24yBzQ9qQM7
	qXtle2xdCU7kO+v6oUxHJWsJTyCzzy9XCQ7l8Y9g5/3hEcfAKoJf9OY7n/j2OoPBqUhuyjZV79U
	wS5N33ah1e1VmS7kpjAPt7QFdZ3IbiaGuUbYgoaaCRjaUxTJBbVZ3
X-Gm-Gg: ASbGncvPWbVOcheKAhD63J7tCkmadBAz/mxScKq12YMFN5BtzBZiySQwleS0YPCLblG
	8Rl6sYGQ0DrOhbuxt5039Ohrjn6mXIaBKagOvyd/scUb7uqFVIhz8efNjasfdJUvGP8xn9RStN5
	zxNhjaGDrxHu/IZMFN2AeqPlfp7Z2h46lLdtVYzgAx8ZHtbkqOiEReagMPIQ5I8ron/0Mgwjxik
	oCWidTUBiega8zJluTDS7DFXHR2EQHFFEPF7oTNuyVMLiUu7OtjyLe7yNopoM/URMAdn5JBBAx/
	nX7/XKvK/P80AgaCuT7TBx7NffVC/eY+OxMIsZRk9U+yhrsxKhVWUudw41fWV1GBx5qgTfw=
X-Received: by 2002:a05:6000:178f:b0:3b8:dabe:bd8b with SMTP id ffacd0b85a97d-3b900b735a9mr7970804f8f.27.1754898900699;
        Mon, 11 Aug 2025 00:55:00 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHVOGWDruciewVEosqcR2+QES2IE7osG5sp4UnCvZaHZfIP5R1LX2uX43AAj1fZmlyY9AYFdQ==
X-Received: by 2002:a05:6000:178f:b0:3b8:dabe:bd8b with SMTP id ffacd0b85a97d-3b900b735a9mr7970790f8f.27.1754898900258;
        Mon, 11 Aug 2025 00:55:00 -0700 (PDT)
Received: from [192.168.3.141] (p57a1a3d6.dip0.t-ipconnect.de. [87.161.163.214])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3b79c3ac51asm40503091f8f.1.2025.08.11.00.54.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 11 Aug 2025 00:54:59 -0700 (PDT)
Message-ID: <9866c69f-e3da-4d47-bbb5-5dc2e91d71a8@redhat.com>
Date: Mon, 11 Aug 2025 09:54:58 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] mm/memory-failure: fix infinite UCE for VM_PFNMAP'ed
 page
To: Jinjiang Tu <tujinjiang@huawei.com>, linmiaohe@huawei.com,
 nao.horiguchi@gmail.com, akpm@linux-foundation.org,
 xueshuai@linux.alibaba.com, ziy@nvidia.com, osalvador@suse.de,
 linux-mm@kvack.org
Cc: wangkefeng.wang@huawei.com
References: <20250811043323.899130-1-tujinjiang@huawei.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 g3eXuA==
Organization: Red Hat
In-Reply-To: <20250811043323.899130-1-tujinjiang@huawei.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 8h9nI6pZLsz-NjItDv8c7asYSWS68JaGjKgvK2tSKXk_1754898901
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 9qw8pm3ub5mqocoihmg19g598xi9dn31
X-Rspam-User: 
X-Rspamd-Queue-Id: EB3F21A0003
X-Rspamd-Server: rspam02
X-HE-Tag: 1754898903-756950
X-HE-Meta: U2FsdGVkX1/gun9RXUOhc2ZD1qVCdnBhfY3e6Lyg4siirZeqXomcXbjXG8SyTBpRyKvyPJFp3wiVN0VKSOOGeP8bRXwWoQJOOS72thnRzj6eMvVqFOcqqQaVIoocfNAz1hSptnYlvrQLwAocCKcv3u1HVlsxGR9au1K7L+XioZ1cqllvkybMcv5L+iRP+TVGAE8td95UJeTT9scqsFzsoexGUG8zSHSOYz5F3T5diBhVvyG+xD4WCXdMjrSjl82ExQ720BEYbfgHeHLKvGol2wyRVIxH33O6IY/W2dgNeq0qqgttuMLvMDj2Xe51IQ4koTFgG6ci7wZgQT/xsqUyy6NpNAaXT7BusgNBQ7/NQUDEhlladXDZ5v8eDAccvylBkT7AziHuK2i0W2fggfUlCUiesPJEf9PR8Gu1Kyi4sbxbt+qM67erNTpxtwZBejkEwW6/NW9dDIba/HqP95zZBva0uweKqvwwu3uzQ/PPye6J0ijmUqWoLfcUSx22ywitjuMdckH8kQgZn8LmjWa8bCHK87GDnFP8Tw0xNVDADhmzwV7SMEMhtmeeaM3nWFSHogx0DAHKOHw+AcLFEEUK7qu72x6kLjgslCnjVK9uxQGvOC2Bu74h2GWP7NqMuAzkCw9H8u/tpB+PHhEbhdHMMO6yEtzL8ZgAhO9x75JsNWkt3zXpfLh/QerImfcz8yem1XoyjByOk8hTisSpCJjBJ9lG9u9hyVCNePl52YfvXlCifOpvl5bWzTBkeqTz84nwecTO/IcNYLX++HSP/uWfn0JG+Re+Ur5GlVkfMi48j89E87veomE1efjx9wpHtYuxj353/x7F6p/BHJYHdOfffaF7Tfey18v9+tzIWuSRNKg7FWi/hXqjKUFsEW4KUEUGi13XokknYwVr4oaANGM8RapmROvZ7byJuD9XSHn8XE4whah9hmbq48LuLmTzWtV1CYaLANdeqL5xqpA8SOi
 gc0p49Ze
 2gOaz5btDbxr31fiPITV5jShWw3oCgrYQ8aOc8UbkbrFC/m2MryuhkZrKUeLB5YFGaV/6BYGugGkNU+6gb/j2QHSqIh6t8vrBmlwz/ZAVe4xTlHrbrts8stTuSCRZGkL3oUrCjrQO4txXx+bcLuRWfaiqXGnDXdIS5Jbe4OiTLEGMkjoGhEeF6DBS8N0vhQNBfaDbh9H1er2h+UB3ZcLwRArJ0Yz1xD017zCMewBvgjv1XkdK1Z+9063P0ode4lu9dtiksn2DfK2VhB3sIbC9byDhfa8EohOI7bvpoGAT9vsF8res0IEKuQyq8IjGM1eCrywnwhhkdYVtP1+YnfxMHqm/yTLGptLBn04HES6oltuoYVFV+fHYW6GsnQaUNrGfzm0XYABTxOvFeCO5/pjDH4Bs0Aro1x4kv5uo+x0EGsk7DBA8wgFTEh5rYNBxOMkWs2mwh2eGLRV5Pk1jwEQm6jT3SXCEQwHyMGCCPcWnrDoQS7zuqvcFfIOBZKCNSPDYeVy2ENMa7SNgSe2Sfi9+8JNTCg6W37lIzfEZ5YA5WVu2Xs/zXm5iWtatcQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 11.08.25 06:33, Jinjiang Tu wrote:
> is not ordinarily mapped, but was mapped through
> remap_pfn_range(), kill_accessing_process() wouldn't identify it as mapped
> even though hwpoison_pte_range() would be prepared to handle it, because
> walk_page_range() will skip VM_PFNMAP as default in walk_page_test(). As
> a result, walk_page_range() will return 0, assuming "not mapped" and SIGBUS

Acked-by: David Hildenbrand <david@redhat.com>

-- 
Cheers,

David / dhildenb



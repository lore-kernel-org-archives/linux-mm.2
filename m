Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D887DCCD1A7
	for <linux-mm@archiver.kernel.org>; Tue, 21 Oct 2025 15:43:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 465568E001F; Tue, 21 Oct 2025 11:43:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 43CD48E0002; Tue, 21 Oct 2025 11:43:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 352DD8E001F; Tue, 21 Oct 2025 11:43:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 2220F8E0002
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 11:43:04 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id BF1DC16052B
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 15:43:03 +0000 (UTC)
X-FDA: 84022539846.06.06BE79A
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf26.hostedemail.com (Postfix) with ESMTP id 3635F140005
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 15:43:01 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="TR/vQEBF";
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf26.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761061381; a=rsa-sha256;
	cv=none;
	b=0bLN3K03ehAp7K30XgOYnjDymU4x3hBrDSXo82t0IiVsiMfjjIH9kpoXgg+gdb1TInCne2
	ssB2Zu1j58a3WwLv839E538r1Fk5cBT7UCuLR7f7r5UpeEBfqJr1DEQHJq9jEPthp6u05h
	/29s0ARHOJCGWNUJv9eTaBydQnNtMLs=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="TR/vQEBF";
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf26.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761061381;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jNcno7kT0irEzub8Roey9W2mYI7FYUplQutZ5yVhFdg=;
	b=Y7XQcbTU3eidweCyOnAUusr4ukyZ0Vy0a0bzlK0YugW4PGaffEqGv8qgySz0InyljAxlRt
	cCUtBM6AH8K09enQCvPOK8vrYpVnJnVN/0OMuqE9ukBuKuEGC2XKn0uK3gi8AcXxm97Mq1
	O5HFH/zHd4UOLqeYFill8x2/P9TJIys=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1761061380;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=jNcno7kT0irEzub8Roey9W2mYI7FYUplQutZ5yVhFdg=;
	b=TR/vQEBFnwU3Wf41alTEwRvP8eRVSe85fnIjwFPPmDZbmVveI09QohhokQqthnj4IkylP9
	vl9nbt3Bf80ezgGOaRyCobqZhjkwafgjjSblKXvTf4xDa7tXp2/MZmv8mg1k0Nns95oMq1
	KTpWC01j9eJPI9rPL6f1M6OBCVPzrak=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-593-AteTPlnzPGmfpJqyDCmo7Q-1; Tue, 21 Oct 2025 11:42:57 -0400
X-MC-Unique: AteTPlnzPGmfpJqyDCmo7Q-1
X-Mimecast-MFC-AGG-ID: AteTPlnzPGmfpJqyDCmo7Q_1761061376
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-4711899ab0aso44347205e9.2
        for <linux-mm@kvack.org>; Tue, 21 Oct 2025 08:42:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761061376; x=1761666176;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=jNcno7kT0irEzub8Roey9W2mYI7FYUplQutZ5yVhFdg=;
        b=VNBSG/I1QeQwTMS40GwxrhzRjlYTfuZeYXj/zAwUZxful5VZgZwUOi5Bv1MkCqt7tw
         rPaeCFy9885DpM5qLuD9gXvm73KA7lODJKY/CCSjMLxu+yo76vAIuJnzE7a3yBusJwn/
         Ea2ywowCnu+PduJSbFTDymsajmeRoDlLLkplIl3hlkzxwN+TF9DbiCdRZZNKE59ONbzU
         XiDsudmqDw1exAF0T0Dxf8wb8W0OXNJLxQvqwrJPYFuhVaFHzS534VAOMvpqg4gy3J/x
         IqsmVCvh8yuny/zCaORkcJW/Id6aesF/UMog6ioYMdLvw91/+tZtYaCB5eQ11zNk64oC
         VUsQ==
X-Forwarded-Encrypted: i=1; AJvYcCUSLY4hfvOVXsr7F+ba0ORYBOBWTE4GZn50PJOq6U5xBKxP1+8XsBw9huH3smQnsK75XIO4JrhIfA==@kvack.org
X-Gm-Message-State: AOJu0YyZmLLHA486DvMWEyjXCqX+k0j0r0mSSlHhSeWTBYNyGHA4blh6
	ntEOm3zYA6tKvO3NCqVXpWZQRY/VU6VF6KGkakUbOICuaf2vNJngpNKHP5qyaoeE8tOZIpS+54T
	2dCXYKCGNn6CCEevzXl+ytL03XBH13s4DOr1YeNMIdj6t1Lq8dk7k
X-Gm-Gg: ASbGncsmWwgPa2MI2GYqYz7XuS4UDsFVZVa+TFDzKwagbGg1DJ/TqPdlzAGEct2jFS7
	hODi6VdNqyJ7SN5b/UsnAXFEsTp/3795C1bv9+an3hl5ngLjg+/w/Fqj/KSAVMZSuF038UyMnAj
	5yloNUJN2lHlFvYlXeyKms4IhsDeJCV5RonbCSaug7chvO9STsefbebZ+nswnFBWXTwmnARyX0N
	BuNQJKvFeJ11kcGFJv5ENUiof98rh2StbClKJVBgzJj62Rh03kXt4465iI6PoZ+cQZiPv0jI5bA
	H9gX5AkjOv/lDe6LOm2eUnp9xKj5vCZYRiCxa9Qomu0oesLzMd7siNEachFXuJSYrYQzs9+DBm3
	nhAR+pO4+HqQnY4PeSRXWuXIz4Plr+Ts84JWu/RcCV3EkrfX8BBpwYAm8M8tzRnwhiB1GJT9Vx4
	i1y+BNfd0no9EZIDH02tj6k77qh5s=
X-Received: by 2002:a05:600c:870b:b0:46f:b42e:e366 with SMTP id 5b1f17b1804b1-4711791fa34mr125576335e9.40.1761061376004;
        Tue, 21 Oct 2025 08:42:56 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHAXCpx0sJcyJNfRiKm2dYACcXvFmWjsvuh2uNond6HHIL7tB74zy8IJxnnZIUjSnynaOrehQ==
X-Received: by 2002:a05:600c:870b:b0:46f:b42e:e366 with SMTP id 5b1f17b1804b1-4711791fa34mr125575985e9.40.1761061375574;
        Tue, 21 Oct 2025 08:42:55 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f4e:3200:c99d:a38b:3f3a:d4b3? (p200300d82f4e3200c99da38b3f3ad4b3.dip0.t-ipconnect.de. [2003:d8:2f4e:3200:c99d:a38b:3f3a:d4b3])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4714fb1b668sm232749515e9.0.2025.10.21.08.42.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 21 Oct 2025 08:42:55 -0700 (PDT)
Message-ID: <88f8477b-5898-4d7e-8583-9d769a34645f@redhat.com>
Date: Tue, 21 Oct 2025 17:42:52 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3] mm/huge_memory: do not change split_huge_page*()
 target order silently.
To: Zi Yan <ziy@nvidia.com>, linmiaohe@huawei.com, jane.chu@oracle.com,
 kernel@pankajraghav.com,
 syzbot+e6367ea2fdab6ed46056@syzkaller.appspotmail.com,
 syzkaller-bugs@googlegroups.com
Cc: akpm@linux-foundation.org, mcgrof@kernel.org, nao.horiguchi@gmail.com,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>,
 Wei Yang <richard.weiyang@gmail.com>, linux-fsdevel@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, stable@vger.kernel.org,
 Pankaj Raghav <p.raghav@samsung.com>
References: <20251017013630.139907-1-ziy@nvidia.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <20251017013630.139907-1-ziy@nvidia.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: m5_9mFTGsfvHeirvuWRwmHoImZAf2qF-fC44bnTUxkk_1761061376
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 1f3nue9npr8ke4wpansuuxx4iao8ft7u
X-Rspamd-Queue-Id: 3635F140005
X-Rspamd-Server: rspam06
X-Rspam-User: 
X-HE-Tag: 1761061381-368940
X-HE-Meta: U2FsdGVkX18SkLODKb3+065c6V/DeUPrRuHWLZD0bTnugQbLHXytZbpcTgky9eHppaTFsFaCFS9sErVZAGAwy32crFD4ThEIXkDnVymD/SdqOqrFnhJZqpmP36lv7mzHIxn+btNonjG++15/5YXK2lD5Rb21xBuLwW4shwe6ks/WzQWYQs6vfs3vfr3alR0tJfFGdbzBSAJU7VX4OILpg+ZAGB8P92wRmGXsYA2Aa4bB0ZUNGFawOZYtIW77zikQjglc4g2WrUphxj8vXBe9P/X3+/hdXwmABgNUYOi2ZZF71wzmyjyn6rw1l7a/Hnk0GTLXjg33FFEpkI61PJuXCkJVZmlWmkXS3rZiDAtVYJiWe6hUilvw18gTrwmvnxQiVEPVi5F52gAV1gnv7RXIEv456+wO0LUFijrJtD4Co1CQa19XQaoz3oSho+xmaTvSXI2AeWqrfZ0wtuwNQm+shmEJC98AVw/lLUV8PngJOQk8QncmBSVYUf4NPT2SPL5belS1kfPq2ZzZdLp83G7RzBJEqCUX9LoG5k5BtKK3v+TARgH6zn4e8xlPZONtfxA9u8n3W95m32kT8fyBkZz08qQZWnhdvkZh2Y8CH+kquhGPUrBxrq4pGVCUdNfpnUuEQHalWjPzCWspP+GkDkuLqEpXMiCPJU7lRo8I0ToRlAMsl9QXlqaF5M3dYIMmLi9yz/C3weS2y7gmk4eEOuPjMo8wQtwYxwFSiIzgn5NxyZdn043Y8i/Cx3aJn//b6JtYsWAXNNp+tZI4OMd+VmTAypSIkoX9b4VlNQNv9sIJcrADLpM5HZMzaKhabnQkbSepfJPkrsM+3WS/V6O7mEcP8WdRV9Qc4rfbpyO5xkQAI6OXWDQFBK9IXQIejxyZpU1QUYumHH7zK2Y0QEWhRizwWNCGI9acU3FoDhVclzVZUzJppwvimOVqIPLEcs8aGam8oFocA8WOVoCw7s0m9Uc
 vwgAJ8HE
 Bl2U9BteCwFxZbNe7flrcU3Ez3t8J8NJyWHc8NFbAVyriQvTA/ZgHq6/UPhauS03Dc5wmhvPMFZDK27zaKiE/7G+KX/vJJj25c9CBu6t2+sgmswofSiTAgqtqjCYchT8mVHC/+i4wO5ji8q4IqCQtKeXYe80b3Eff0y8ULZPHZ+Mp8zYfcnu5qenNr/JWznPMx04jKUMVE2bxWsNhVnIzHf3ERkOG+yUlKeevc6L5a3lK5sgv+l9b8+zX+hpnCj8Uko5J+g7DDycyLlPafedj5Kr4w3c/hqvTPLWwnAHUqmcnnbntxuCQSalUuCSeC15SzlzX4/RQTuY7U28Yx8M9aF4KjBoO8cs8R74LtuGXy3ilLxt0pbpeHsFejwY3ninwI155WkplMO9UP39qJGJU9NbLfY0q6zYzZDiY+4Pwrf3nsvreUHSIFs0/Ef87qLfrOXAmrKRhhDxjPY0ip7muz+AWBuluW+Z6Sgy7CF4w0m5SxleY8FkVthzs44PjpLvLnZ9p/SO+qoOEaV/+puPardvY9W8UhPSGxlowHUK9++DWmEmJS56OQpJ4Prv8st/JL+VQ0Lco4yEsV9CYEmYbvdaytPEbrT8QbPAH4QNQ+qhYfRuOlaOIA/dRrGfpX0mEHogDNCxLqDdxKLFgxcmsOXKtB1QoHmEi3WcVoBbiRQgBsKvNIYh7RfpqAbZC4EHxfRf+0M4AkojUWH/cMwYVAfuKrwnkApLB8F9SpvlxHvE+snlDyyurEgnHc7DpyMbsuyIffrW7CgayM0zgDyHAV5pW79ydKTZzyPQQVdu1xVQEflS7rtq+rvySI6avNYRFOAbQc7bFuV0R+Z4W9fMDHtgFOXv0VZonaeOc
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 17.10.25 03:36, Zi Yan wrote:
> Page cache folios from a file system that support large block size (LBS)
> can have minimal folio order greater than 0, thus a high order folio might
> not be able to be split down to order-0. Commit e220917fa507 ("mm: split a
> folio in minimum folio order chunks") bumps the target order of
> split_huge_page*() to the minimum allowed order when splitting a LBS folio.
> This causes confusion for some split_huge_page*() callers like memory
> failure handling code, since they expect after-split folios all have
> order-0 when split succeeds but in reality get min_order_for_split() order
> folios and give warnings.
> 
> Fix it by failing a split if the folio cannot be split to the target order.
> Rename try_folio_split() to try_folio_split_to_order() to reflect the added
> new_order parameter. Remove its unused list parameter.
> 
> Fixes: e220917fa507 ("mm: split a folio in minimum folio order chunks")
> [The test poisons LBS folios, which cannot be split to order-0 folios, and
> also tries to poison all memory. The non split LBS folios take more memory
> than the test anticipated, leading to OOM. The patch fixed the kernel
> warning and the test needs some change to avoid OOM.]
> Reported-by: syzbot+e6367ea2fdab6ed46056@syzkaller.appspotmail.com
> Closes: https://lore.kernel.org/all/68d2c943.a70a0220.1b52b.02b3.GAE@google.com/
> Cc: stable@vger.kernel.org
> Signed-off-by: Zi Yan <ziy@nvidia.com>
> Reviewed-by: Luis Chamberlain <mcgrof@kernel.org>
> Reviewed-by: Pankaj Raghav <p.raghav@samsung.com>
> Reviewed-by: Wei Yang <richard.weiyang@gmail.com>
> ---

With Lorenzos comments addressed, this looks good to me, thanks for 
taking care of this!

Acked-by: David Hildenbrand <david@redhat.com>

-- 
Cheers

David / dhildenb



Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4BFD1CA0FFD
	for <linux-mm@archiver.kernel.org>; Mon,  1 Sep 2025 08:06:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 90BED8E0002; Mon,  1 Sep 2025 04:06:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8BBF08E0013; Mon,  1 Sep 2025 04:06:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 78C498E0002; Mon,  1 Sep 2025 04:06:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 60F108E0002
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 04:06:33 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 355821DEA19
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 08:06:33 +0000 (UTC)
X-FDA: 83839949466.05.4885E2C
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf06.hostedemail.com (Postfix) with ESMTP id D66CA180015
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 08:06:30 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=f4K5jZDZ;
	spf=pass (imf06.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756713990;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=36asoDc0iHyCQaqJQKzsY9OSxCtFiTj85FzevifIki8=;
	b=dBBvDQK4yRPKf79pxHvUVbRtOrlSm2hQaJZVqWHzbTfLKDh4pJKKxv4n1auTICfu9ImP64
	cM3VLQFoE+zzZUg1FETR2UJiIHmVvOSfMxkdcd90HJ7HgIcsVLtr+An9DM/UlOxU0vd2jB
	X0pAWPlc4Dxc7x3e26AEyzpPq0mNSPU=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=f4K5jZDZ;
	spf=pass (imf06.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756713990; a=rsa-sha256;
	cv=none;
	b=ifPwB33i5r9Hwxc72ZNyFYQ9GcFPm8G7H6t6D5/9FIhOs0fs9hzZGFkgTpdPpsQs3GV19m
	+Ge+lE6mPSzSoOmia9jd7KmeRzf3IpxdDmIS2MqERuidD1IhbC4Ec3rxhwUaj4G4sGeNM4
	29yxFqP/8zDxUeT4a9UuAt8J6UQ1niE=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1756713990;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=36asoDc0iHyCQaqJQKzsY9OSxCtFiTj85FzevifIki8=;
	b=f4K5jZDZSiN9yLIqqem6CyLv5Yj4fLteo7hHjE8hQCPMHI3ZSwoZNXf4lPbNqkTt2UkWCk
	SjPRMBx45LxjUnnEtTJ6ZZ2BToxpVhR2wAY0bt7Xcw2pNO8RAVx9Z+r/a5miJo+cP89r7n
	RJc1DDZCPY1yfPo/aqKBEJFqRB9QQ0M=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-631-phpAzeNiPYKaIgvzmfU33g-1; Mon, 01 Sep 2025 04:06:27 -0400
X-MC-Unique: phpAzeNiPYKaIgvzmfU33g-1
X-Mimecast-MFC-AGG-ID: phpAzeNiPYKaIgvzmfU33g_1756713986
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-45b8a2b9fcaso7211945e9.0
        for <linux-mm@kvack.org>; Mon, 01 Sep 2025 01:06:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756713986; x=1757318786;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=36asoDc0iHyCQaqJQKzsY9OSxCtFiTj85FzevifIki8=;
        b=g2qMNAd246iUD9QahqKxphHCTI4xoLlFkdir5UuQm8x4fgFwgSrvB1PZywGdyjUti/
         CVnDGO3ul1VWXQh9MdqvICM0qudg5NeDXTr+cvXSWZM3S0MSl9dPU3wbBNUkQXoTxP0A
         M2I/VJMdp90wu3i7FSNlE/lNtaBd1+mluCOygbeXMUFjY3zv9KQdVEBo/g5cS2ZFT/w+
         x1oPuP8WuxKeltCd6irGtIUv8xkWY6L4ew2h8u+1a4XB2ZEZ6KmfaflS0k02ONmu+VTC
         4OD24FKLauqo+Jb4MCH/++30OyhPelOswy1H2qkHJ8cRaoaO8Bp295PpOxanOiWfYO0b
         4o8A==
X-Forwarded-Encrypted: i=1; AJvYcCVWcF+Rs/YaypVUgzGP5Esz4o/yWuBjG/4Johc2mc6j7aMFV8HbFDqDc7HXBPQJWZJ2t7NoGVKGWA==@kvack.org
X-Gm-Message-State: AOJu0YxHBSJfL0cLnAg0R+/UPVwsA6lzEL1PYAEf4eeRdlC2NLP0r7kJ
	YUO4O/I0QnjVbKTR0FieqBKJxIgPavQ7UHtW96AzBZanuljL1M9bXdFFNZ1eCyXqKWbKOvmRPdd
	8x+V40gqgOhtPSI184jFbjQD8gUyhBlHQiKLDDHQkUKDxwzCny4tN
X-Gm-Gg: ASbGncuK1qwLuwBTcoqO2qLPyZ3WqBeBsqf0myROPj7WQTKVKwI9iu/P3PupmFRPX7r
	yFiV8QJ4OZUmetVs1Xei7378TRB1hxCs2B+dNNYkhgbTCZ32pcA9HyU1HMw3MVzmP4r4NntA5u6
	lE3Nw3PlwJiVQAWELebFPKwMtIdG4W6bIcB7BUptzsPS/EVb+j+S9gDVDGlHukOduWScMwJBQIq
	DUxCHeuXffEmW0zxjGmPoX3fCEDdisBNlx1OLe4Hfj0q2rYkIMjmdoPkBF663bRcqdcFvfDK0I7
	fd9//VkKOtNdyCxo3+qMgOF0b7/9zu5wTfqoJNQba5CoU3cKOA/0k14OS1iBfq1NFKMNLY3IVnz
	3s+Lxtz6TgFhGY5nOmzjcYkkjNCt7Xgh4zWloegwg3znJW9MUaVTjJ4eibkvAjTByuTQ=
X-Received: by 2002:a05:600c:4f0b:b0:459:d821:a45b with SMTP id 5b1f17b1804b1-45b87bf56e3mr53425415e9.9.1756713985967;
        Mon, 01 Sep 2025 01:06:25 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFgMgZX2cNh35Rid9shheD+9ZZm5Gk0eOcu6r6LL5Iv12JAtT5v9c2Wsf6vZmmcbbRWjzq7zw==
X-Received: by 2002:a05:600c:4f0b:b0:459:d821:a45b with SMTP id 5b1f17b1804b1-45b87bf56e3mr53425135e9.9.1756713985516;
        Mon, 01 Sep 2025 01:06:25 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f37:2b00:948c:dd9f:29c8:73f4? (p200300d82f372b00948cdd9f29c873f4.dip0.t-ipconnect.de. [2003:d8:2f37:2b00:948c:dd9f:29c8:73f4])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45b7e8ab093sm150530455e9.22.2025.09.01.01.06.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 01 Sep 2025 01:06:25 -0700 (PDT)
Message-ID: <1431a00b-d68c-4f25-b075-5021e2faa9db@redhat.com>
Date: Mon, 1 Sep 2025 10:06:23 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 4/7] mm: Revert "mm/gup: clear the LRU flag of a page
 before adding to LRU batch"
To: Hugh Dickins <hughd@google.com>, Andrew Morton <akpm@linux-foundation.org>
Cc: Will Deacon <will@kernel.org>, Shivank Garg <shivankg@amd.com>,
 Matthew Wilcox <willy@infradead.org>, Christoph Hellwig <hch@infradead.org>,
 Keir Fraser <keirf@google.com>, Jason Gunthorpe <jgg@ziepe.ca>,
 John Hubbard <jhubbard@nvidia.com>, Frederick Mayle <fmayle@google.com>,
 Peter Xu <peterx@redhat.com>, "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>,
 Johannes Weiner <hannes@cmpxchg.org>, Vlastimil Babka <vbabka@suse.cz>,
 Alexander Krabler <Alexander.Krabler@kuka.com>, Ge Yang
 <yangge1116@126.com>, Li Zhe <lizhe.67@bytedance.com>,
 Chris Li <chrisl@kernel.org>, Yu Zhao <yuzhao@google.com>,
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>,
 Wei Xu <weixugc@google.com>, Konstantin Khlebnikov <koct9i@gmail.com>,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org
References: <a28b44f7-cdb4-8b81-4982-758ae774fbf7@google.com>
 <0215a42b-99cd-612a-95f7-56f8251d99ef@google.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <0215a42b-99cd-612a-95f7-56f8251d99ef@google.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: sI2fLFZQy_w7hmRoRsDQ4kZnGyjh-0Og6PQhBKvh5EM_1756713986
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: tfug6phkuc8zj9pkxzr7utdakcyqi383
X-Rspam-User: 
X-Rspamd-Queue-Id: D66CA180015
X-Rspamd-Server: rspam05
X-HE-Tag: 1756713990-762942
X-HE-Meta: U2FsdGVkX1927lDy/ZTwVx0znVFEKK23vRjuPLbHxxicOUeA4ys6iMjZmQTjMGHvNWPdQH1Wshz2n8iCL4qKpUfwwKuclssSk8ZyX8AnDdvHrjTas3JysxGvEWYkM2o5ZSaCM+tf0vEvKD7xeITpkxsBPAs+u9vtv34v8vBJmGBEBJ2+RWRL4DpgWhm0CT/aWirzRA5+3LupZg4F6zX6tMMPnhw2ij24EgeegPa6lJBCK+Y94WkbgA8Q4gFRwrzB8Xwm83OXEzYlsg+ZJwhKuKpzmOKDU1l8/fJ7kPsudF69B/dyGBct8ChPFJ2ZM0pX2nTwafjNwe9fhDFjyB7gHLlk/lg0VDbgfEj36ce75fTMQV9hAAiVUuIdQqUvSHmAheVkcesMKeKfDXfQvRUHVpRzMZ2/JzJ2vxiCMMCCeDGmlIBqMpUkKAYffX9ickrEaduVMTw7pBeZbNxTPS2gcBuGURfda69zan1YcT2bihkf4+3i5aUNTnh4CIqhgyKdYN2kg7IFXQ3ZFsFfw+azynF/2X5D6iOJuFAN/NFmi+/H3hnTJsyp5ATnAIUZ1OwbI9W4UOyLuAlk67duSve6czqbyE98ZLLKM9cdYhcDYZUFEcwpqoaZ256HfC0ZI39QYOZGaNpyEV6cKhBoX8Lk2+3X4nsauAllLqJhYlv5BbZ4WMZTrYDVCDqZiq9IEMdzwIXQkXwNP1rQ5sfNn6qMgMYpOJP6mapoHwVH6oHTuR6MTiPa4I++EMu2CbvdQXajvqqM0MBa/Adx2LnBLqrU6QueNTmR28NcLS/zUzl98Gql7LLKN/bG/TPJXbW2rZpH0HgTMNSugtobEW/wqTL1VqtdLMc89YgSn/cEaRm/KUudDkmWbtp8d8hc4gPDjSMkpW6RbOiz0TkqIiTO88Z8ZoC+MFL6cCIMTrWWpwdgqvH10z0xQlJYtkw2/V/SF3jZqR7KSW6tPvufM6XXEZu
 97XMpplu
 y6x6f5ETJeQ/oxLYFWnZmvYMypChLXtOABWKOwYoDS8GGBSj/FNa8/YgopIqxPNZ2goZtCY1KvFvUy8P9Y6lcvnnbfHqn6cBjCuFoS7u+BVd4TDUXNv2o3ebjSTnqDSgZ0GzT90EpakifYfQD1VJRTTSYaO3ZHABt3x1CYdWuHsDLi2LTX3GnM7yEq5ofIvSUtBgbMqv2djokgzWk6i9vifK2cy2DsBdgd3bpkfJyRh4f9jgSkuJsGYZwVncf77nIAywubGnzD41Z8S+3bzxlJNr908xYF6KT+fKj+0dvv6peestmTpVjcWHDnvsLwreag3GoI6TtD9Ym0tZNGhKDRa7zaFw5Lpu0idgxg5tCj1wmZTd5w5y/XSowGdJJBnXmnLwhtgrSHIeG14PPfTxOdJTin3dAkGleRuet7nJkWlUcm0H49VGJiGVLjfl3cDoRGh5VzjXu09/KwqJ/DB7C43sbaTT3raLjm7uHfOAE2F76pf+dfm8XNPN/DY7gz9DME10VkPUkkXc+KIlQw5zLVqh56v9JtL7NRuQQ89/2+zExTK0I/lvFuvElFcEljHMCmHMJAnZSGQy/IW9IZ/zCobQkFtt2MhrPfU0BsqNENA4rW0FCVjbzdWUnBT70Wgfuelh3PbrFqOpPLXE=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 31.08.25 11:11, Hugh Dickins wrote:
> This reverts commit 33dfe9204f29b415bbc0abb1a50642d1ba94f5e9:
> now that collect_longterm_unpinnable_folios() is checking ref_count
> instead of lru, and mlock/munlock do not participate in the revised
> LRU flag clearing, those changes are misleading, and enlarge the
> window during which mlock/munlock may miss an mlock_count update.
> 
> It is possible (I'd hesitate to claim probable) that the greater
> likelihood of missed mlock_count updates would explain the "Realtime
> threads delayed due to kcompactd0" observed on 6.12 in the Link below.
> If that is the case, this reversion will help; but a complete solution
> needs also a further patch, beyond the scope of this series.
> 
> Included some 80-column cleanup around folio_batch_add_and_move().
> 
> The role of folio_test_clear_lru() (before taking per-memcg lru_lock)
> is questionable since 6.13 removed mem_cgroup_move_account() etc; but
> perhaps there are still some races which need it - not examined here.
> 
> Link: https://lore.kernel.org/linux-mm/DU0PR01MB10385345F7153F334100981888259A@DU0PR01MB10385.eurprd01.prod.exchangelabs.com/
> Signed-off-by: Hugh Dickins <hughd@google.com>
> Cc: <stable@vger.kernel.org>
> ---

Acked-by: David Hildenbrand <david@redhat.com>

-- 
Cheers

David / dhildenb



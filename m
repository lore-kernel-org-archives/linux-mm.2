Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5C7D4C87FCB
	for <linux-mm@archiver.kernel.org>; Mon,  4 Aug 2025 08:09:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E0B7F6B007B; Mon,  4 Aug 2025 04:09:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D95786B0088; Mon,  4 Aug 2025 04:09:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C35896B0089; Mon,  4 Aug 2025 04:09:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id AEE286B007B
	for <linux-mm@kvack.org>; Mon,  4 Aug 2025 04:09:27 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 2F07D1A0F13
	for <linux-mm@kvack.org>; Mon,  4 Aug 2025 08:09:27 +0000 (UTC)
X-FDA: 83738350374.19.1AF6224
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf20.hostedemail.com (Postfix) with ESMTP id DB7BC1C000B
	for <linux-mm@kvack.org>; Mon,  4 Aug 2025 08:09:24 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=cRMTjT8J;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf20.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754294965; a=rsa-sha256;
	cv=none;
	b=ws3xjJWLpUSwZY+YHphuufnK9G/jMsk+RQ2yOL5q61JuIWNoS7tqyTBA9m6C30mzzSGwZO
	AZuuUo+fKfQE/xWe9BgyAewGW15uiKm4INsXuYpXfegxzj8O05WgOnyIxX6NbrUGyGqWp+
	mgSLotHC+/DVInGmQ0SK2Ka/8Zj1spw=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=cRMTjT8J;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf20.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754294965;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FeBzew9EjpLsssWR/x3cK3CyNtLtRunP4eu5LSewXBw=;
	b=yMLPPFFcSBYGqL+HAK9cK2wpNpzr2wCJl4RQ9vhWuAlDh0KJeR7mYp7W3irVhixR4XdUT9
	HAdX4mtnyAhhQgE12uvDWk4hi65iyxWL/oqdwwPQkLotnnDdn2b/c6LgVnajvohBL57KX4
	ax3TqIO54vR6Po4N1iIia1VKJJE1ZTQ=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1754294964;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=FeBzew9EjpLsssWR/x3cK3CyNtLtRunP4eu5LSewXBw=;
	b=cRMTjT8JNl7Sf1TOVS0atQVnvZIYiLzaU+fh2tuvYGJuO6TIkDbOy+4EvauzjkJs0o/x56
	KKjV/lhN9kMnV7430Y4GxhyBnO++GefNZPqBJnHNz7VYxNe+q7ArcMxf9oabUl91g63SrY
	brIosH0A6G8gYd+N5z+m6sXUvvNPiH8=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-386-zpif8it0PF2b7oGIe2lx_w-1; Mon, 04 Aug 2025 04:09:22 -0400
X-MC-Unique: zpif8it0PF2b7oGIe2lx_w-1
X-Mimecast-MFC-AGG-ID: zpif8it0PF2b7oGIe2lx_w_1754294961
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-458a321153dso12166715e9.0
        for <linux-mm@kvack.org>; Mon, 04 Aug 2025 01:09:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754294961; x=1754899761;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=FeBzew9EjpLsssWR/x3cK3CyNtLtRunP4eu5LSewXBw=;
        b=scPeETu0meNEBv+lzgHPffXIA3H/Ix00f05aa1JTKokRekp6ycK+pZX4oc1wJGF92e
         28fWhE9ocy+IGYKbU78VGCwrnm6psFP/xKnsSnTZjGZej3yw/MixwTo4xGs+6Y2UktfT
         UlO6+H47e5MOFlVZXJZbBk3cHNuHpx2b8jVJjYRqO8TKb4hU/iPvCfQnG6qYXxbrkzYd
         huVHtYUNkMfVtmMdy8/D7Nb4iupOUq+b9/hVep92QG9ZdOC4bHjWw0RxoKunjIDhB+qS
         QmoENTNTrgKJfMfaq1BvwGj7zK0hiKkoAfphqu5bYNf1gTM7XOYlfAfAdAM+YlRMTHkg
         0TFQ==
X-Forwarded-Encrypted: i=1; AJvYcCU/gNeAcvy9N2XLU8NMhUivf1LDwL5pHDyCcMmtXhkywj0SF81GHgChsQAQX7p3RPEBxVO8bV0bOA==@kvack.org
X-Gm-Message-State: AOJu0YyyJMnyXqu8QzLoiwCRGRbHIMYmaJcjWAjcvmZND1ixWKy1apVI
	oEpJRdo3PHiqXl4vV4Y6g4GqhWkcvO6Kb6juph/BmTSQBCyR2hVZOdaFeveVZ/MCyfjNSQN0vQn
	hEO4hF2pHKzL03+87JB8WNb6cE0+27UERX76rZVzlaFdMMjwHQIB7
X-Gm-Gg: ASbGncvpT6HS8Ksx4RNXN0q0MCeC6tubn3a75Gw+b8OPio5ocExGqxn/XpgSdtsbsw2
	D5SaiuaaJuvfvyd2It9F/NlGZ1fZFYRpo/SKlBO5wnD4KXF2TxAN4uZGrBEBwXhXGBfOeXwYsyk
	1toYowd1tXqbcKF6zbHFe65wHxv01QaV87iRE53JDK78oAg4MrytPRK/IdepTmTJZjCxqFV9eV7
	afHP1Ur/z+nGWXS5L3rJpmqIcd1UgwAfWaeA7Hr3sj5EPQ6hioMswbMAHtgZMx6z3aGiHBL92Il
	3kP3wsE4RLUCMuJ61Lqno1MonbvOliQ4gDV5OP+hX/W89aohuOQ2Vi0LMdU9sOczUIeM4hjMvpD
	/9IBaeMRvdm0qvIaoNdoIwUyaKZFdI0IVE3r6DItIlqjwnaqE9kYfiJIukhnV79NxsTw=
X-Received: by 2002:a05:600c:a43:b0:456:1b93:76b with SMTP id 5b1f17b1804b1-458b69cbdd9mr59436375e9.4.1754294960630;
        Mon, 04 Aug 2025 01:09:20 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHb1/hcPJTdy6j2wd+h4JIDrwPdLrVhFCdL8k5R5TQqequE53RFilWzQbkiLFan+5oyRU6hfg==
X-Received: by 2002:a05:600c:a43:b0:456:1b93:76b with SMTP id 5b1f17b1804b1-458b69cbdd9mr59436005e9.4.1754294960183;
        Mon, 04 Aug 2025 01:09:20 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f0e:2c00:d6bb:8859:fbbc:b8a9? (p200300d82f0e2c00d6bb8859fbbcb8a9.dip0.t-ipconnect.de. [2003:d8:2f0e:2c00:d6bb:8859:fbbc:b8a9])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-458a7c91c0esm136644785e9.11.2025.08.04.01.09.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 04 Aug 2025 01:09:19 -0700 (PDT)
Message-ID: <56331143-0532-4b6d-b23c-d15ca82f17c6@redhat.com>
Date: Mon, 4 Aug 2025 10:09:18 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/userfaultfd: fix kmap_local LIFO ordering for
 CONFIG_HIGHPTE
To: Sasha Levin <sashal@kernel.org>, Andrew Morton <akpm@linux-foundation.org>
Cc: surenb@google.com, aarcange@redhat.com, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
References: <20250731144431.773923-1-sashal@kernel.org>
 <20250801141101.9f3555a172609cb64fde7f71@linux-foundation.org>
 <aI04CQZZzgCDO2A5@lappy>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 g3eXuA==
Organization: Red Hat
In-Reply-To: <aI04CQZZzgCDO2A5@lappy>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: z35hhEHLOZNe8PEswAJkhUXVtOv9er_pBplqYLLA2L4_1754294961
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: DB7BC1C000B
X-Stat-Signature: wufhcr6u5q4cmw51q6g6x9oc1zdhdgb1
X-Rspam-User: 
X-HE-Tag: 1754294964-913294
X-HE-Meta: U2FsdGVkX18ZF82o4mwGvPF3L6t1IrgxyAfLrNrLz0X19spuCy/oSYH9hLY5fK7Qc2Jc7+1nWiUej5VRK+S/b8tkXLNpTgejYrDlWAUF0mrpIVHJQXMT1SL94OGecBOkhJVpqQ/SoSxIuhyMd1wAS15rwIAgKBmKLVEE5c/Y482eQT/66NywVQbrAEZW8eOfGZ2Yr3KTYGh4NHmHMODFFEz3534/lbHZN6DVUxM0DZPszKJKUQNhC+Sb24h+qqQLZEzKFirABF24HrQ1ezS/idzpf9DPnfkWVs2Jdiaw0//k4015dm0RrmQvLPzSPRyvShon8i15Ufy4GBqdwZRJn0RsU15Gx9IMubXAr44Y+ziTlzsyln6pu3OujpqTPOYnL7RtYai7yz23Yb9wIpdbSFXbJG08fc+qLwkLRpjXq2q3YwfCotW8xNEn0ymkurW+ffosHJGl3DpotB8sPisIUaVdCds4+yY27Yh/qYWzBLEv5DBgL+/bjaA1abw8fR8bFq5xPKvN/IgaoQkloTl93Mgm/TJ7N1rbWYcC/m3s79jskTGCt8IA6eClaI2IlcAH50iyjT+SfoaoSwpjTIdcCzqkxr3HaPkszC442qkDmS21Vn9yoz923VZ+YYR4Vc0Z0H7JEfqYzNIs7IQJczDJm2D0w3ozHo+d7X6xNuuj4Sylim/Y2og9ev63I8T0ywKHXvIJaLmrS8qW1MFVXuO45I09yMmdYc0jhKQE3Yt08VMKBRPLmDt+B+5pxhn0IuP63KOEva+tM5/NKyfmfy+0VDChl9orT8fbgUO/rZV1LXY5Ru2rt5+U+MGyL9J6ARKFD0phJamGcM3aeOD+hbSkdCuQG5u5euya7t2BZ2eEyU9tmlT8RJLzcpkHmA9Zei20FdhaukIsu+a6nrt01DlBk5xJ4aFISn7Hr8Zn6TJ3GoEJkm+IkkATOF4O2ba3PfgJyrAp5C0wmp53V+Kz47p
 uq8LzTvH
 0ZsJOxcaC9qqBmDBxiWbItArcPwfJVbhqIIFB9VCWZVOFL3YOWia2u9fRLMDh1KbEOozgaRF2a5aM6UgNTQHtMriqtK3vSAjvRCHVUncXlgpOBeguWAhLxdugFA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 01.08.25 23:56, Sasha Levin wrote:
> On Fri, Aug 01, 2025 at 02:11:01PM -0700, Andrew Morton wrote:
>> On Thu, 31 Jul 2025 10:44:31 -0400 Sasha Levin <sashal@kernel.org> wrote:
>>
>>> With CONFIG_HIGHPTE on 32-bit ARM, move_pages_pte() maps PTE pages using
>>> kmap_local_page(), which requires unmapping in Last-In-First-Out order.
>>>
>>> The current code maps dst_pte first, then src_pte, but unmaps them in
>>> the same order (dst_pte, src_pte), violating the LIFO requirement.
>>> This causes the warning in kunmap_local_indexed():
>>>
>>>    WARNING: CPU: 0 PID: 604 at mm/highmem.c:622 kunmap_local_indexed+0x178/0x17c
>>>    addr \!= __fix_to_virt(FIX_KMAP_BEGIN + idx)
>>>
>>> Fix this by reversing the unmap order to respect LIFO ordering.
>>>
>>> This issue follows the same pattern as similar fixes:
>>> - commit eca6828403b8 ("crypto: skcipher - fix mismatch between mapping and unmapping order")
>>> - commit 8cf57c6df818 ("nilfs2: eliminate staggered calls to kunmap in nilfs_rename")
>>>
>>> Both of which addressed the same fundamental requirement that kmap_local
>>> operations must follow LIFO ordering.
>>>
>>> Fixes: adef440691ba ("userfaultfd: UFFDIO_MOVE uABI")
>>> Co-developed-by: Claude claude-opus-4-20250514
>>
>> Well this is innovative.  I doubt if Co-developed-by: is appropriate
>> for this (where's Claude's Signed-off-by:?)
> 
> Claude (or any other AI) can't legally sign off on code :)

I think we need a different tag than Co-developed-by. Avocado [1] seems 
to use

	Assisted-by:

Which I prefer over things like Generated-by o co-developed-by:

[1] 
https://avocado-framework.readthedocs.io/en/latest/guides/contributor/chapters/ai_policy.html

-- 
Cheers,

David / dhildenb


